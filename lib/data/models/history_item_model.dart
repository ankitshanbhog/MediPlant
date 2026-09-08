// Data model for Previously Identified Plant Scans

import 'recognition_result_model.dart';

class HistoryItem {
  final String id;
  final DateTime timestamp;
  final String plantName;
  final String scientificName;
  final String? plantId;
  final double confidence;
  final RecognitionStatus status;
  final RecognitionSource source;
  final String? imagePath;
  final String? thumbnailAsset;

  const HistoryItem({
    required this.id,
    required this.timestamp,
    required this.plantName,
    required this.scientificName,
    this.plantId,
    required this.confidence,
    required this.status,
    required this.source,
    this.imagePath,
    this.thumbnailAsset,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      plantName: json['plantName'] as String,
      scientificName: json['scientificName'] as String,
      plantId: json['plantId'] as String?,
      confidence: (json['confidence'] as num).toDouble(),
      status: RecognitionStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => RecognitionStatus.ownModelSuccess,
      ),
      source: RecognitionSource.values.firstWhere(
        (e) => e.toString() == json['source'],
        orElse: () => RecognitionSource.internalModel,
      ),
      imagePath: json['imagePath'] as String?,
      thumbnailAsset: json['thumbnailAsset'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'plantName': plantName,
      'scientificName': scientificName,
      'plantId': plantId,
      'confidence': confidence,
      'status': status.toString(),
      'source': source.toString(),
      'imagePath': imagePath,
      'thumbnailAsset': thumbnailAsset,
    };
  }
}
