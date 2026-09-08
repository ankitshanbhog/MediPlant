// Data model for Disease and Health Conditions in MediPlant

class Disease {
  final String id;
  final String name;
  final String category; // Respiratory, Digestion, Skin, Immunity, Pain & Fever, Stress, etc.
  final String description;
  final List<String> symptoms;
  final String iconName;
  final List<String> relatedPlantIds;
  final List<String> homeRemedyIds;
  final String medicalDisclaimer;

  const Disease({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.symptoms,
    required this.iconName,
    required this.relatedPlantIds,
    required this.homeRemedyIds,
    this.medicalDisclaimer = 'Herbal preparations are for complementary support only. If symptoms persist beyond 48 hours or worsen, consult a medical doctor.',
  });

  factory Disease.fromJson(Map<String, dynamic> json) {
    return Disease(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      symptoms: List<String>.from(json['symptoms'] ?? []),
      iconName: json['iconName'] as String,
      relatedPlantIds: List<String>.from(json['relatedPlantIds'] ?? []),
      homeRemedyIds: List<String>.from(json['homeRemedyIds'] ?? []),
      medicalDisclaimer: json['medicalDisclaimer'] as String? ??
          'Herbal preparations are for complementary support only. If symptoms persist beyond 48 hours or worsen, consult a medical doctor.',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'symptoms': symptoms,
      'iconName': iconName,
      'relatedPlantIds': relatedPlantIds,
      'homeRemedyIds': homeRemedyIds,
      'medicalDisclaimer': medicalDisclaimer,
    };
  }
}
