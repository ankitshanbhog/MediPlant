// Data model for Medicinal Plants in MediPlant

class Plant {
  final String id;
  final String commonName;
  final String scientificName;
  final String family;
  final Map<String, String> vernacularNames; // e.g. {'Hindi': 'Tulsi', 'Sanskrit': 'Surasa'}
  final String description;
  final String imageUrl;
  final List<String> medicinalUses;
  final List<String> healthBenefits;
  final List<String> traditionalUses;
  final List<String> activeConstituents;
  final List<String> partsUsed;
  final List<String> sideEffects;
  final List<String> precautions;
  final List<String> contraindications;
  final String preparationMethods;
  final String dosageGuidelines;
  final String habitat;
  final String appearance;
  final String plantType;
  final bool isSupportedInModel2; // True if supported in internal ML Model 2

  const Plant({
    required this.id,
    required this.commonName,
    required this.scientificName,
    required this.family,
    required this.vernacularNames,
    required this.description,
    required this.imageUrl,
    required this.medicinalUses,
    required this.healthBenefits,
    required this.traditionalUses,
    required this.activeConstituents,
    required this.partsUsed,
    required this.sideEffects,
    required this.precautions,
    required this.contraindications,
    required this.preparationMethods,
    required this.dosageGuidelines,
    required this.habitat,
    this.appearance = '',
    this.plantType = 'Medicinal Herb',
    this.isSupportedInModel2 = true,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id'] as String,
      commonName: json['commonName'] as String,
      scientificName: json['scientificName'] as String,
      family: json['family'] as String,
      vernacularNames: Map<String, String>.from(json['vernacularNames'] ?? {}),
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      medicinalUses: List<String>.from(json['medicinalUses'] ?? []),
      healthBenefits: List<String>.from(json['healthBenefits'] ?? []),
      traditionalUses: List<String>.from(json['traditionalUses'] ?? []),
      activeConstituents: List<String>.from(json['activeConstituents'] ?? []),
      partsUsed: List<String>.from(json['partsUsed'] ?? []),
      sideEffects: List<String>.from(json['sideEffects'] ?? []),
      precautions: List<String>.from(json['precautions'] ?? []),
      contraindications: List<String>.from(json['contraindications'] ?? []),
      preparationMethods: json['preparationMethods'] as String? ?? '',
      dosageGuidelines: json['dosageGuidelines'] as String? ?? '',
      habitat: json['habitat'] as String? ?? '',
      appearance: json['appearance'] as String? ?? '',
      plantType: json['plantType'] as String? ?? 'Medicinal Plant',
      isSupportedInModel2: json['isSupportedInModel2'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'commonName': commonName,
      'scientificName': scientificName,
      'family': family,
      'vernacularNames': vernacularNames,
      'description': description,
      'imageUrl': imageUrl,
      'medicinalUses': medicinalUses,
      'healthBenefits': healthBenefits,
      'traditionalUses': traditionalUses,
      'activeConstituents': activeConstituents,
      'partsUsed': partsUsed,
      'sideEffects': sideEffects,
      'precautions': precautions,
      'contraindications': contraindications,
      'preparationMethods': preparationMethods,
      'dosageGuidelines': dosageGuidelines,
      'habitat': habitat,
      'appearance': appearance,
      'plantType': plantType,
      'isSupportedInModel2': isSupportedInModel2,
    };
  }
}
