import 'dart:async';
import '../data/models/recognition_result_model.dart';
import '../data/mock/mock_sample_images.dart';
export 'backend_recognition_service.dart';

/// Visual stages of the machine learning identification pipeline
enum PipelineStage {
  idle,

  /// Stage 1: Detecting botanical leaf or plant characteristics
  checkingPlantModel1,

  /// Stage 2: Matching medicinal plant species
  identifyingSpeciesModel2,

  /// Stage 3: Verification
  externalApiVerification,

  /// Finished
  completed,

  /// Error
  failed,
}

/// Abstract contract for Medicinal Plant Recognition
abstract class RecognitionService {
  Future<RecognitionResult> recognizePlant({
    required String imageSource,
    RecognitionTestSample? simulationSample,
    void Function(PipelineStage stage)? onStageChanged,
  });
}
