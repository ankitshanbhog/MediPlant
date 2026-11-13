
/// Evidence level for medicinal claims.
/// - `traditional` : documented traditional/folk use only
/// - `lab`         : in-vitro or animal study evidence
/// - `clinical`    : human clinical trial evidence
/// - `unknown`     : not yet reviewed
enum EvidenceLevel { traditional, lab, clinical, unknown }

class Plant {
  final String id;
  final String commonName;
  final String scientificName;
  final String family;
  final Map<String, String> vernacularNames;
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
  final bool isSupportedInModel2;

  // ── Stage 1 additions (all optional / backward-compatible) ──
  /// Highest evidence level available for this plant's medicinal uses.
  final EvidenceLevel evidenceLevel;
  /// Known herb–drug interactions (brief descriptions).
  final List<String> drugInteractions;
  /// Source references (e.g. "WHO Monographs, 2002").
  final List<String> sources;
  /// Common name IDs of visually similar plants (look-alikes).
  final List<String> lookAlikeNames;

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
    this.evidenceLevel = EvidenceLevel.unknown,
    this.drugInteractions = const [],
    this.sources = const [],
    this.lookAlikeNames = const [],
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    EvidenceLevel parseEvidence(String? s) {
      switch (s) {
        case 'traditional': return EvidenceLevel.traditional;
        case 'lab': return EvidenceLevel.lab;
        case 'clinical': return EvidenceLevel.clinical;
        default: return EvidenceLevel.unknown;
      }
    }

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
      evidenceLevel: parseEvidence(json['evidenceLevel'] as String?),
      drugInteractions: List<String>.from(json['drugInteractions'] ?? []),
      sources: List<String>.from(json['sources'] ?? []),
      lookAlikeNames: List<String>.from(json['lookAlikeNames'] ?? []),
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
      'evidenceLevel': evidenceLevel.name,
      'drugInteractions': drugInteractions,
      'sources': sources,
      'lookAlikeNames': lookAlikeNames,
    };
  }
}
