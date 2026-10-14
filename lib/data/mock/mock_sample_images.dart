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

/// Pre-configured curated botanical samples matching the 10-class MediPlant model pipeline.
/// Classes: ashwagandha_plant, ayapana_plant, cinnamon_plant, gotu_kola_plant,
///          insulin_plant, malabar_nut, pirandai_plant, rosemary_plant,
///          wood_apple_plant, ylang_ylang_plant
final List<RecognitionTestSample> mockTestSamples = [
  const RecognitionTestSample(
    id: 'sample_ashwagandha',
    label: 'Ashwagandha',
    subtitle: 'Withania somnifera',
    imageUrl: '',
    expectedPlantId: 'ashwagandha_plant',
    testDescription: 'Downy grayish-green elliptical leaves of the Indian Ginseng shrub.',
    isPlant: true,
  ),
  const RecognitionTestSample(
    id: 'sample_ayapana',
    label: 'Ayapana',
    subtitle: 'Ayapana triplinervis',
    imageUrl: '',
    expectedPlantId: 'ayapana_plant',
    testDescription: 'Narrow lanceolate aromatic ayapana leaves with reddish-purple stems.',
    isPlant: true,
  ),
  const RecognitionTestSample(
    id: 'sample_cinnamon',
    label: 'Cinnamon',
    subtitle: 'Cinnamomum verum',
    imageUrl: '',
    expectedPlantId: 'cinnamon_plant',
    testDescription: 'Glossy leathery cinnamon leaves with 3 prominent longitudinal veins.',
    isPlant: true,
  ),
  const RecognitionTestSample(
    id: 'sample_gotu_kola',
    label: 'Gotu Kola',
    subtitle: 'Centella asiatica',
    imageUrl: '',
    expectedPlantId: 'gotu_kola_plant',
    testDescription: 'Small round kidney-shaped bright green pennywort leaves.',
    isPlant: true,
  ),
  const RecognitionTestSample(
    id: 'sample_insulin',
    label: 'Insulin Plant',
    subtitle: 'Chamaecostus cuspidatus',
    imageUrl: '',
    expectedPlantId: 'insulin_plant',
    testDescription: 'Large glossy dark green leaf with distinctive reddish-purple underside.',
    isPlant: true,
  ),
  const RecognitionTestSample(
    id: 'sample_malabar_nut',
    label: 'Malabar Nut (Vasaka)',
    subtitle: 'Justicia adhatoda',
    imageUrl: '',
    expectedPlantId: 'malabar_nut',
    testDescription: 'Large lanceolate dark green Vasaka leaf with strong bitter aroma.',
    isPlant: true,
  ),
  const RecognitionTestSample(
    id: 'sample_pirandai',
    label: 'Pirandai (Hadjod)',
    subtitle: 'Cissus quadrangularis',
    imageUrl: '',
    expectedPlantId: 'pirandai_plant',
    testDescription: 'Distinctive 4-angled (quadrangular) bright green succulent vine stem.',
    isPlant: true,
  ),
  const RecognitionTestSample(
    id: 'sample_rosemary',
    label: 'Rosemary',
    subtitle: 'Salvia rosmarinus',
    imageUrl: '',
    expectedPlantId: 'rosemary_plant',
    testDescription: 'Needle-like silvery-green aromatic rosemary leaves with revolute margins.',
    isPlant: true,
  ),
  const RecognitionTestSample(
    id: 'sample_wood_apple',
    label: 'Wood Apple',
    subtitle: 'Limonia acidissima',
    imageUrl: '',
    expectedPlantId: 'wood_apple_plant',
    testDescription: 'Pinnate compound wood apple leaves with aromatic citrus fragrance.',
    isPlant: true,
  ),
  const RecognitionTestSample(
    id: 'sample_ylang_ylang',
    label: 'Ylang Ylang',
    subtitle: 'Cananga odorata',
    imageUrl: '',
    expectedPlantId: 'ylang_ylang_plant',
    testDescription: 'Glossy oval ylang ylang leaf and star-shaped golden-yellow fragrant flower.',
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
