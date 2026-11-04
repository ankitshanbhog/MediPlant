import 'dart:async';
import '../data/models/recognition_result_model.dart';
import '../data/mock/mock_sample_images.dart';
export 'backend_recognition_service.dart';

enum PipelineStage {
  idle,

  checkingPlantModel1,

  identifyingSpeciesModel2,

  externalApiVerification,

  completed,

  failed,
}

abstract class RecognitionService {
  Future<RecognitionResult> recognizePlant({
    required String imageSource,
    RecognitionTestSample? simulationSample,
    void Function(PipelineStage stage)? onStageChanged,
  });
}
