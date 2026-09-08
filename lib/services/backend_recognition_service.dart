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

/// Real Backend Recognition Service connecting Flutter with the FastAPI ML backend
class BackendRecognitionService implements RecognitionService {
  /// Base API URL (can be customized for physical devices or custom networks)
  String _baseUrl;

  BackendRecognitionService({String? customBaseUrl})
      : _baseUrl = customBaseUrl ?? defaultBaseUrl;

  /// Automatically select optimal backend URL based on execution platform
  static String get defaultBaseUrl {
    if (kIsWeb) {
      return 'http://127.0.0.1:8000';
    }
    try {
      if (Platform.isAndroid) {
        // http://127.0.0.1:8000 is supported directly via USB with 'adb reverse tcp:8000 tcp:8000'
        // This is 100% immune to Wi-Fi firewalls, router client-isolation, and IP changes.
        return 'http://127.0.0.1:8000';
      }
    } catch (_) {}
    // Windows desktop, macOS desktop, iOS Simulator, Linux
    return 'http://127.0.0.1:8000';
  }

  /// List of candidate backend URLs to try on Android in order of reliability
  static List<String> get candidateUrls {
    if (kIsWeb) return ['http://127.0.0.1:8000'];
    try {
      if (Platform.isAndroid) {
        return [
          'http://127.0.0.1:8000',     // Works via USB cable (adb reverse tcp:8000 tcp:8000)
          'http://192.168.0.103:8000', // Wi-Fi LAN IP fallback
          'http://10.0.2.2:8000',      // Android Studio Emulator fallback
        ];
      }
    } catch (_) {}
    return ['http://127.0.0.1:8000'];
  }

  String get baseUrl => _baseUrl;

  set baseUrl(String url) {
    _baseUrl = url.endsWith('/') ? url.substring(0, url.length - 1) : url;
  }

  /// Load custom cloud URL stored in local SQLite settings if set
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

  /// Save custom cloud backend URL persistently to SQLite
  Future<void> saveCustomBaseUrl(String url) async {
    final clean = url.trim().endsWith('/') ? url.trim().substring(0, url.trim().length - 1) : url.trim();
    _baseUrl = clean;
    try {
      await DatabaseHelper.instance.setSetting('custom_backend_url', clean);
    } catch (_) {}
  }

  /// List of candidate backend URLs to try, with active/custom cloud URL prioritized
  List<String> get allCandidateUrls {
    final list = <String>[];
    if (_baseUrl.isNotEmpty) list.add(_baseUrl);
    for (final u in candidateUrls) {
      if (!list.contains(u)) list.add(u);
    }
    return list;
  }

  /// Check if the backend server is reachable
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

  @override
  Future<RecognitionResult> recognizePlant({
    required String imageSource,
    RecognitionTestSample? simulationSample,
    void Function(PipelineStage stage)? onStageChanged,
  }) async {
    await loadCustomBaseUrl();
    // -------------------------------------------------------------------------
    // STAGE 1: Checking Plant Characteristics
    // -------------------------------------------------------------------------
    onStageChanged?.call(PipelineStage.checkingPlantModel1);

    // Read image bytes once so they can be sent or retried across candidates
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

    // Try candidate endpoints (Custom Cloud URL -> USB adb reverse -> Wi-Fi IP -> fallback)
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
          _baseUrl = candidate; // Pin active working endpoint
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

      // -----------------------------------------------------------------------
      // Case 1: Image failed Stage 1 (Not A Plant)
      // -----------------------------------------------------------------------
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

      // -----------------------------------------------------------------------
      // Case 2: Plant identified -> Retrieve from local SQLite database
      // -----------------------------------------------------------------------
      final rawPlantName = data['plant_name'] as String? ?? '';
      final plant = await _lookupPlantInDatabase(rawPlantName);

      // Parse alternatives from backend predictions
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

      // Determine Recognition Status based on confidence & verification
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

  /// Retrieve full detailed plant model from real SQLite database with memory fallback
  Future<Plant?> _lookupPlantInDatabase(String className) async {
    if (className.isEmpty) return null;

    final normalized = className.toLowerCase().trim();

    // 1. Try SQLite Database lookup
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

    // 2. In-Memory fallback: Instant resolution from verified 11-species catalog
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
