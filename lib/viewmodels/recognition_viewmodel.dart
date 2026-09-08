import 'package:flutter/foundation.dart';
import '../data/mock/mock_sample_images.dart';
import '../data/models/history_item_model.dart';
import '../data/models/recognition_result_model.dart';
import '../data/repositories/history_repository.dart';
import '../services/camera_service.dart';
import '../services/recognition_service.dart';

class RecognitionViewModel extends ChangeNotifier {
  final RecognitionService _recognitionService;
  final CameraGalleryService _cameraService;
  final HistoryRepository _historyRepository;

  RecognitionViewModel({
    required RecognitionService recognitionService,
    required CameraGalleryService cameraService,
    required HistoryRepository historyRepository,
  })  : _recognitionService = recognitionService,
        _cameraService = cameraService,
        _historyRepository = historyRepository;

  String? _selectedImagePath;
  RecognitionTestSample? _selectedSample;
  PipelineStage _currentStage = PipelineStage.idle;
  RecognitionResult? _result;
  bool _isAnalyzing = false;
  String? _errorMessage;

  String? get selectedImagePath => _selectedImagePath;
  RecognitionTestSample? get selectedSample => _selectedSample;
  PipelineStage get currentStage => _currentStage;
  RecognitionResult? get result => _result;
  bool get isAnalyzing => _isAnalyzing;
  String? get errorMessage => _errorMessage;
  bool get hasImage => _selectedImagePath != null || _selectedSample != null;

  String get effectiveImageDisplayUrl {
    if (_selectedSample != null) return _selectedSample!.imageUrl;
    return _selectedImagePath ?? '';
  }

  void selectTestSample(RecognitionTestSample sample) {
    _selectedSample = sample;
    _selectedImagePath = sample.imageUrl;
    _result = null;
    _errorMessage = null;
    _currentStage = PipelineStage.idle;
    notifyListeners();
  }

  Future<void> capturePhoto() async {
    _errorMessage = null;
    try {
      final path = await _cameraService.captureFromCamera();
      if (path != null) {
        _selectedImagePath = path;
        _selectedSample = null;
        _result = null;
        _currentStage = PipelineStage.idle;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to capture photo: $e';
      notifyListeners();
    }
  }

  Future<void> pickFromGallery() async {
    _errorMessage = null;
    try {
      final path = await _cameraService.pickFromGallery();
      if (path != null) {
        _selectedImagePath = path;
        _selectedSample = null;
        _result = null;
        _currentStage = PipelineStage.idle;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to pick image from gallery: $e';
      notifyListeners();
    }
  }

  void clearSelectedImage() {
    _selectedImagePath = null;
    _selectedSample = null;
    _result = null;
    _currentStage = PipelineStage.idle;
    _errorMessage = null;
    notifyListeners();
  }

  Future<RecognitionResult?> startIdentification() async {
    final image = _selectedImagePath ?? _selectedSample?.imageUrl;
    if (image == null) {
      _errorMessage = 'Please select or capture an image first.';
      notifyListeners();
      return null;
    }

    _isAnalyzing = true;
    _errorMessage = null;
    _result = null;
    _currentStage = PipelineStage.checkingPlantModel1;
    notifyListeners();

    try {
      final res = await _recognitionService.recognizePlant(
        imageSource: image,
        simulationSample: _selectedSample,
        onStageChanged: (stage) {
          _currentStage = stage;
          notifyListeners();
        },
      );

      _result = res;
      _isAnalyzing = false;
      _currentStage = PipelineStage.completed;

      // Automatically save to scan history if it was a successful identification
      if (res.plant != null) {
        await _historyRepository.addHistoryItem(
          HistoryItem(
            id: 'scan_${DateTime.now().millisecondsSinceEpoch}',
            timestamp: DateTime.now(),
            plantName: res.plant!.commonName,
            scientificName: res.plant!.scientificName,
            plantId: res.plant!.id,
            confidence: res.confidence,
            status: res.status,
            source: res.source,
            imagePath: res.imagePath,
          ),
        );
      }

      notifyListeners();
      return res;
    } catch (e) {
      _isAnalyzing = false;
      _currentStage = PipelineStage.failed;
      _errorMessage = 'Recognition failed: $e';
      notifyListeners();
      return null;
    }
  }

  void reset() {
    _selectedImagePath = null;
    _selectedSample = null;
    _result = null;
    _currentStage = PipelineStage.idle;
    _isAnalyzing = false;
    _errorMessage = null;
    notifyListeners();
  }
}
