/// Test botanical sample images for demonstration and quality testing
class RecognitionTestSample {
  final String id;
  final String label;
  final String subtitle;
  final String imageUrl;
  final String expectedPlantId;
  final String testDescription;
  final bool isPlant;

  const RecognitionTestSample({
    required this.id,
    required this.label,
    required this.subtitle,
    required this.imageUrl,
    required this.expectedPlantId,
    required this.testDescription,
    this.isPlant = true,
  });
}

/// Pre-configured curated botanical samples matching the 13-class MediPlant vision system.
/// Classes: aloe_vera, amla, ashwagandha, ayapana, brahmi, gotu_kola, moringa,
///          multi_vitamin_plant, neem, rosemary, sarpagandha, tulsi, wood_apple
final List<RecognitionTestSample> mockTestSamples = [
  const RecognitionTestSample(
    id: 'sample_aloe_vera',
    label: 'Aloe Vera',
    subtitle: 'Aloe barbadensis miller',
    imageUrl: '',
    expectedPlantId: 'aloe_vera',
    testDescription: 'Thick succulent lanceolate leaves with serrated margins and soothing inner gel.',
    isPlant: true,
  ),
  const RecognitionTestSample(
    id: 'sample_amla',
    label: 'Amla',
    subtitle: 'Phyllanthus emblica',
    imageUrl: '',
    expectedPlantId: 'amla',
    testDescription: 'Feathery pinnate foliage and pale green antioxidant-rich round fruit.',
    isPlant: true,
  ),
  const RecognitionTestSample(
    id: 'sample_ashwagandha',
    label: 'Ashwagandha',
    subtitle: 'Withania somnifera',
    imageUrl: '',
    expectedPlantId: 'ashwagandha',
    testDescription: 'Downy grayish-green elliptical leaves and adaptogenic root tonic shrub.',
    isPlant: true,
  ),
  const RecognitionTestSample(
    id: 'sample_ayapana',
    label: 'Ayapana',
    subtitle: 'Ayapana triplinervis',
    imageUrl: '',
    expectedPlantId: 'ayapana',
    testDescription: 'Narrow lanceolate aromatic leaves with reddish-purple hemostatic stems.',
    isPlant: true,
  ),
  const RecognitionTestSample(
    id: 'sample_brahmi',
    label: 'Brahmi',
    subtitle: 'Bacopa monnieri',
    imageUrl: '',
    expectedPlantId: 'brahmi',
    testDescription: 'Small oblong succulent creeping leaves with delicate white-blue flowers.',
    isPlant: true,
  ),
  const RecognitionTestSample(
    id: 'sample_gotu_kola',
    label: 'Gotu Kola',
    subtitle: 'Centella asiatica',
    imageUrl: '',
    expectedPlantId: 'gotu_kola',
    testDescription: 'Small round kidney-shaped bright green pennywort leaves on slender runners.',
    isPlant: true,
  ),
  const RecognitionTestSample(
    id: 'sample_moringa',
    label: 'Moringa',
    subtitle: 'Moringa oleifera',
    imageUrl: '',
    expectedPlantId: 'moringa',
    testDescription: 'Tripinnate feathery leaflets of the nutrient-dense Miracle Tree.',
    isPlant: true,
  ),
  const RecognitionTestSample(
    id: 'sample_multi_vitamin',
    label: 'Multi Vitamin Plant',
    subtitle: 'Sauropus androgynus',
    imageUrl: '',
    expectedPlantId: 'multi_vitamin_plant',
    testDescription: 'Nutritious dark green oval leaves of the Chakra Muni living multivitamin shrub.',
    isPlant: true,
  ),
  const RecognitionTestSample(
    id: 'sample_neem',
    label: 'Neem',
    subtitle: 'Azadirachta indica',
    imageUrl: '',
    expectedPlantId: 'neem',
    testDescription: 'Serrated curved pinnate leaflets of the antimicrobial Village Pharmacy tree.',
    isPlant: true,
  ),
  const RecognitionTestSample(
    id: 'sample_rosemary',
    label: 'Rosemary',
    subtitle: 'Salvia rosmarinus',
    imageUrl: '',
    expectedPlantId: 'rosemary',
    testDescription: 'Needle-like silvery-green aromatic leaves with carnosic acid fragrance.',
    isPlant: true,
  ),
  const RecognitionTestSample(
    id: 'sample_sarpagandha',
    label: 'Sarpagandha',
    subtitle: 'Rauvolfia serpentina',
    imageUrl: '',
    expectedPlantId: 'sarpagandha',
    testDescription: 'Whorled glossy green leaves and antihypertensive reserpine-bearing roots.',
    isPlant: true,
  ),
  const RecognitionTestSample(
    id: 'sample_tulsi',
    label: 'Tulsi',
    subtitle: 'Ocimum tenuiflorum',
    imageUrl: '',
    expectedPlantId: 'tulsi',
    testDescription: 'Aromatic Holy Basil leaves and purple-flowered terminal racemes.',
    isPlant: true,
  ),
  const RecognitionTestSample(
    id: 'sample_wood_apple',
    label: 'Wood Apple',
    subtitle: 'Limonia acidissima',
    imageUrl: '',
    expectedPlantId: 'wood_apple',
    testDescription: 'Pinnate compound leaves and hard-shelled digestive tonic fruit of the Bael tree.',
    isPlant: true,
  ),
  const RecognitionTestSample(
    id: 'sample_not_plant',
    label: 'Household Object',
    subtitle: 'Non-Botanical Object',
    imageUrl: '',
    expectedPlantId: '',
    testDescription: 'Non-botanical household object to test plant detection gate model.',
    isPlant: false,
  ),
];
