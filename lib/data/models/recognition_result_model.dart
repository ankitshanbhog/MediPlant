import 'plant_model.dart';

/// The recognition status enum reflecting all machine-learning stages
enum RecognitionStatus {
  /// Image passed Model 1 (is a plant) and Model 2 identified it with high confidence
  ownModelSuccess,

  /// Image is a plant, but Model 2 has borderline/low confidence (triggers external verification recommendation)
  lowConfidence,

  /// External verification/backup API verified the plant or resolved low confidence
  verificationSuccess,

  /// Plant was identified by external verification API because it is outside Model 2's supported classes
  outsideSupportedClasses,

  /// Image failed Model 1 plant/not-plant classifier (Object, Animal, Scene, etc.)
  notAPlant,

  /// Identification process failed or plant cannot be recognized
  identificationFailed,
}

/// Source that provided the recognition result
enum RecognitionSource {
  /// Internal trained Model 2 (On-device/Edge model)
  internalModel,

  /// External Backup / Verification Botanical API
  externalVerificationApi,

  /// Combined / Ensemble consensus
  ensemble,

  /// None (e.g. not a plant)
  none,
}

/// Alternative predictions returned by recognition models
class PlantAlternative {
  final String commonName;
  final String scientificName;
  final double confidence; // 0.0 to 1.0
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

/// Detailed result of the multi-stage recognition pipeline
class RecognitionResult {
  final RecognitionStatus status;
  final Plant? plant;
  final double confidence; // 0.0 to 1.0 (e.g. 0.94 for 94%)
  final RecognitionSource source;
  final String? verificationNote;
  final List<PlantAlternative> alternatives;
  final DateTime timestamp;
  final String? imagePath;
  final bool isModel1Passed; // True if classified as plant by Model 1
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
