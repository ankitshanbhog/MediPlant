import 'plant_model.dart';

enum RecognitionStatus {
  
  ownModelSuccess,

  lowConfidence,

  verificationSuccess,

  outsideSupportedClasses,

  notAPlant,

  identificationFailed,
}

enum RecognitionSource {
  
  internalModel,

  externalVerificationApi,

  ensemble,

  none,
}

class PlantAlternative {
  final String commonName;
  final String scientificName;
  final double confidence;
  final String? plantId;

  const PlantAlternative({
    required this.commonName,
    required this.scientificName,
    required this.confidence,
    this.plantId,
  });

  factory PlantAlternative.fromJson(Map<String, dynamic> json) {
    return PlantAlternative(
      commonName: json['commonName'] as String,
      scientificName: json['scientificName'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      plantId: json['plantId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commonName': commonName,
      'scientificName': scientificName,
      'confidence': confidence,
      'plantId': plantId,
    };
  }
}

class RecognitionResult {
  final RecognitionStatus status;
  final Plant? plant;
  final double confidence;
  final RecognitionSource source;
  final String? verificationNote;
  final List<PlantAlternative> alternatives;
  final DateTime timestamp;
  final String? imagePath;
  final bool isModel1Passed;
  final String? nonPlantReason;

  const RecognitionResult({
    required this.status,
    this.plant,
    required this.confidence,
    required this.source,
    this.verificationNote,
    this.alternatives = const [],
    required this.timestamp,
    this.imagePath,
    this.isModel1Passed = true,
    this.nonPlantReason,
  });

  bool get isSuccess =>
      status == RecognitionStatus.ownModelSuccess ||
      status == RecognitionStatus.verificationSuccess ||
      status == RecognitionStatus.outsideSupportedClasses;

  bool get isNotPlant => status == RecognitionStatus.notAPlant;

  bool get isLowConfidence => status == RecognitionStatus.lowConfidence;

  String get formattedConfidence => '${(confidence * 100).toStringAsFixed(1)}%';

  String get sourceLabel {
    switch (source) {
      case RecognitionSource.internalModel:
        return 'High Confidence Match';
      case RecognitionSource.externalVerificationApi:
        return 'Verified Identification';
      case RecognitionSource.ensemble:
        return 'Verified Botanical Match';
      case RecognitionSource.none:
        return 'Standard Analysis';
    }
  }
}
