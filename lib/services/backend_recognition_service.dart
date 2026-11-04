import 'dart:async';
import 'dart:convert';
import 'dart:io' show File, Platform;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../data/database_helper.dart';
import '../data/mock/mock_plants_data.dart';
import '../data/mock/mock_sample_images.dart';
import '../data/models/plant_model.dart';
import '../data/models/recognition_result_model.dart';
import 'recognition_service.dart';

class BackendRecognitionService implements RecognitionService {
  
  String _baseUrl;

  BackendRecognitionService({String? customBaseUrl})
      : _baseUrl = customBaseUrl ?? defaultBaseUrl;

  static String get defaultBaseUrl {
    if (kIsWeb) {
      return 'http://127.0.0.1:8000';
    }
    try {
      if (Platform.isAndroid) {
        
        return 'http://127.0.0.1:8000';
      }
    } catch (_) {}
    
    return 'http://127.0.0.1:8000';
  }

  static List<String> get candidateUrls {
    if (kIsWeb) return ['http://127.0.0.1:8000'];
    try {
      if (Platform.isAndroid) {
        return [
          'http://127.0.0.1:8000',
          'http://192.168.0.103:8000',
          'http://10.0.2.2:8000',
        ];
      }
    } catch (_) {}
    return ['http://127.0.0.1:8000'];
  }

  String get baseUrl => _baseUrl;

  set baseUrl(String url) {
    _baseUrl = url.endsWith('/') ? url.substring(0, url.length - 1) : url;
  }

  Future<void> loadCustomBaseUrl() async {
    try {
      final savedUrl = await DatabaseHelper.instance.getSetting('custom_backend_url');
      if (savedUrl != null && savedUrl.trim().isNotEmpty) {
        _baseUrl = savedUrl.trim().endsWith('/')
            ? savedUrl.trim().substring(0, savedUrl.trim().length - 1)
            : savedUrl.trim();
      }
    } catch (_) {}
  }

  Future<void> saveCustomBaseUrl(String url) async {
    final clean = url.trim().endsWith('/') ? url.trim().substring(0, url.trim().length - 1) : url.trim();
    _baseUrl = clean;
    try {
      await DatabaseHelper.instance.setSetting('custom_backend_url', clean);
    } catch (_) {}
  }

  List<String> get allCandidateUrls {
    final list = <String>[];
    if (_baseUrl.isNotEmpty) list.add(_baseUrl);
    for (final u in candidateUrls) {
      if (!list.contains(u)) list.add(u);
    }
    return list;
  }

  Future<bool> checkHealth() async {
    await loadCustomBaseUrl();
    for (final candidate in allCandidateUrls) {
      try {
        final response = await http
            .get(Uri.parse('$candidate/'))
            .timeout(const Duration(seconds: 4));
        if (response.statusCode == 200) {
          _baseUrl = candidate;
          return true;
        }
      } catch (_) {}
    }
    return false;
  }

  Future<int> syncCatalogFromCloud() async {
    await loadCustomBaseUrl();
    for (final candidate in allCandidateUrls) {
      try {
        final url = Uri.parse('$candidate/botany/plants');
        final response = await http.get(url).timeout(const Duration(seconds: 4));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final plantsList = data['plants'] as List?;
          if (plantsList == null) continue;
          int synced = 0;
          for (final pJson in plantsList) {
            try {
              final plant = Plant.fromJson(pJson);
              await DatabaseHelper.instance.upsertPlant(plant);
              synced++;
            } catch (_) {}
          }
          return synced;
        }
      } catch (_) {}
    }
    return 0;
  }

  @override
  Future<RecognitionResult> recognizePlant({
    required String imageSource,
    RecognitionTestSample? simulationSample,
    void Function(PipelineStage stage)? onStageChanged,
  }) async {
    await loadCustomBaseUrl();
    
    onStageChanged?.call(PipelineStage.checkingPlantModel1);

    List<int> imageBytes;
    try {
      if (imageSource.startsWith('http://') || imageSource.startsWith('https://')) {
        final imgResponse = await http
            .get(Uri.parse(imageSource))
            .timeout(const Duration(seconds: 10));
        if (imgResponse.statusCode != 200) {
          throw Exception('Failed to load image from source');
        }
        imageBytes = imgResponse.bodyBytes;
      } else {
        imageBytes = await File(imageSource).readAsBytes();
      }
    } catch (e) {
      onStageChanged?.call(PipelineStage.failed);
      throw Exception('Could not read image file. Please try again.');
    }

    await Future.delayed(const Duration(milliseconds: 300));
    onStageChanged?.call(PipelineStage.identifyingSpeciesModel2);

    http.Response? response;

    final urlsToTry = allCandidateUrls;
    for (final candidate in urlsToTry) {
      try {
        final uri = Uri.parse('$candidate/predict');
        final request = http.MultipartRequest('POST', uri);
        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            imageBytes,
            filename: 'input_image.jpg',
          ),
        );

        final streamedResponse = await request.send().timeout(const Duration(seconds: 20));
        final res = await http.Response.fromStream(streamedResponse);
        if (res.statusCode == 200) {
          response = res;
          _baseUrl = candidate;
          break;
        }
      } catch (_) {}
    }

    if (response == null) {
      onStageChanged?.call(PipelineStage.failed);
      throw Exception(
        'Unable to connect to the MediPlant AI server. Please make sure "python app.py" is running in your terminal.',
      );
    }

    try {
      final Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));

      if (data.containsKey('error') && data['error'] != null && data['plant_name'] == null) {
        throw Exception(data['error']);
      }

      final bool isPlant = data['is_plant'] == true;
      final double confidencePercent = (data['confidence'] as num?)?.toDouble() ?? 0.0;
      final double normalizedConfidence = (confidencePercent / 100.0).clamp(0.0, 1.0);
      final bool verificationApplied = data['verification_applied'] == true;

      if (!isPlant) {
        onStageChanged?.call(PipelineStage.completed);
        return RecognitionResult(
          status: RecognitionStatus.notAPlant,
          confidence: normalizedConfidence,
          source: RecognitionSource.none,
          isModel1Passed: false,
          nonPlantReason: data['message'] as String? ??
              'No botanical structures detected. Please ensure the photo is clear and focused on the plant.',
          timestamp: DateTime.now(),
          imagePath: imageSource,
        );
      }

      final rawPlantName = data['plant_name'] as String? ?? '';
      final plant = await _lookupPlantInDatabase(rawPlantName);

      final List<PlantAlternative> alternatives = [];
      if (data['predictions'] is List) {
        for (final item in data['predictions']) {
          if (item is Map) {
            final clsName = item['class_name'] as String? ?? '';
            final altPlant = await _lookupPlantInDatabase(clsName);
            final conf = ((item['confidence'] as num?)?.toDouble() ?? 0.0) / 100.0;

            if (clsName.toLowerCase() != rawPlantName.toLowerCase() && conf > 0.01) {
              alternatives.add(
                PlantAlternative(
                  commonName: altPlant?.commonName ?? _formatClassName(clsName),
                  scientificName: altPlant?.scientificName ?? _formatClassName(clsName),
                  confidence: conf.clamp(0.0, 1.0),
                  plantId: altPlant?.id,
                ),
              );
            }
          }
        }
      }

      final RecognitionStatus status = normalizedConfidence >= 0.60
          ? (verificationApplied ? RecognitionStatus.verificationSuccess : RecognitionStatus.ownModelSuccess)
          : RecognitionStatus.lowConfidence;

      final RecognitionSource source = verificationApplied
          ? RecognitionSource.ensemble
          : RecognitionSource.internalModel;

      onStageChanged?.call(PipelineStage.completed);

      return RecognitionResult(
        status: status,
        plant: plant,
        confidence: normalizedConfidence,
        source: source,
        verificationNote: normalizedConfidence < 0.60
            ? 'Identification has moderate certainty. Please check the botanical features and characteristics.'
            : null,
        alternatives: alternatives,
        timestamp: DateTime.now(),
        imagePath: imageSource,
        isModel1Passed: true,
      );
    } catch (e) {
      onStageChanged?.call(PipelineStage.failed);
      rethrow;
    }
  }

  Future<Plant?> _lookupPlantInDatabase(String className) async {
    if (className.isEmpty) return null;

    final normalized = className.toLowerCase().trim();

    try {
      final db = DatabaseHelper.instance;
      var plant = await db.getPlantById(normalized);
      if (plant != null) return plant;

      final searchResults = await db.searchPlants(normalized.replaceAll('_', ' '));
      if (searchResults.isNotEmpty) {
        return searchResults.first;
      }
    } catch (e) {
      debugPrint('[DatabaseLookup Warning] SQLite query failed: $e');
    }

    try {
      final cleanQuery = normalized.replaceAll('_plant', '').replaceAll('_', ' ');
      for (final p in mockPlants) {
        final pId = p.id.toLowerCase();
        final pCommon = p.commonName.toLowerCase();
        final pScientific = p.scientificName.toLowerCase();

        if (pId == normalized ||
            pId.contains(normalized) ||
            normalized.contains(pId) ||
            pCommon.contains(cleanQuery) ||
            cleanQuery.contains(pCommon) ||
            pScientific.contains(cleanQuery)) {
          return p;
        }
      }
    } catch (_) {}

    return null;
  }

  String _formatClassName(String name) {
    return name
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }
}
