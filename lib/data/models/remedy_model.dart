// Data model for Home Remedies in MediPlant

class Remedy {
  final String id;
  final String condition;
  final String title;
  final String primaryPlantName;
  final String primaryPlantScientific;
  final String? plantId;
  final List<String> ingredients;
  final List<String> preparationSteps;
  final String howToUse;
  final String dosage;
  final List<String> precautions;
  final String category; // Cough, Cold, Sore throat, Mild indigestion, Headache, Skin, Immunity
  final String timeToPrepare; // e.g. "10 mins"
  final bool isEducationalOnly;

  const Remedy({
    required this.id,
    required this.condition,
    required this.title,
    required this.primaryPlantName,
    required this.primaryPlantScientific,
    this.plantId,
    required this.ingredients,
    required this.preparationSteps,
    required this.howToUse,
    required this.dosage,
    required this.precautions,
    required this.category,
    this.timeToPrepare = '10 mins',
    this.isEducationalOnly = true,
  });

  factory Remedy.fromJson(Map<String, dynamic> json) {
    return Remedy(
      id: json['id'] as String,
      condition: json['condition'] as String,
      title: json['title'] as String,
      primaryPlantName: json['primaryPlantName'] as String,
      primaryPlantScientific: json['primaryPlantScientific'] as String,
      plantId: json['plantId'] as String?,
      ingredients: List<String>.from(json['ingredients'] ?? []),
      preparationSteps: List<String>.from(json['preparationSteps'] ?? []),
      howToUse: json['howToUse'] as String,
      dosage: json['dosage'] as String,
      precautions: List<String>.from(json['precautions'] ?? []),
      category: json['category'] as String,
      timeToPrepare: json['timeToPrepare'] as String? ?? '10 mins',
      isEducationalOnly: json['isEducationalOnly'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'condition': condition,
      'title': title,
      'primaryPlantName': primaryPlantName,
      'primaryPlantScientific': primaryPlantScientific,
      'plantId': plantId,
      'ingredients': ingredients,
      'preparationSteps': preparationSteps,
      'howToUse': howToUse,
      'dosage': dosage,
      'precautions': precautions,
      'category': category,
      'timeToPrepare': timeToPrepare,
      'isEducationalOnly': isEducationalOnly,
    };
  }
}
