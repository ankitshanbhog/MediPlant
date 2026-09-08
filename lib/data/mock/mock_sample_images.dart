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

/// Pre-configured curated botanical samples matching the 20-species pipeline
final List<RecognitionTestSample> mockTestSamples = [
  const RecognitionTestSample(
    id: 'sample_tulsi',
    label: 'Tulsi (Holy Basil)',
    subtitle: 'Ocimum tenuiflorum',
    imageUrl: '',
    expectedPlantId: 'tulsi_plant',
    testDescription: 'Mature aromatic Tulsi leaf specimen with distinctive venation.',
    isPlant: true,
  ),
  const RecognitionTestSample(
    id: 'sample_neem',
    label: 'Neem (Indian Lilac)',
    subtitle: 'Azadirachta indica',
    imageUrl: '',
    expectedPlantId: 'neem_plant',
    testDescription: 'Pinnate compound leaf with serrated falcate leaflets.',
    isPlant: true,
  ),
  const RecognitionTestSample(
    id: 'sample_aloe',
    label: 'Aloe Vera',
    subtitle: 'Aloe barbadensis miller',
    imageUrl: '',
    expectedPlantId: 'aloe_vera_plant',
    testDescription: 'Fleshy succulent Aloe Vera leaf rosette.',
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
    id: 'sample_rosemary',
    label: 'Rosemary',
    subtitle: 'Salvia rosmarinus',
    imageUrl: '',
    expectedPlantId: 'rosemary_plant',
    testDescription: 'Needle-like aromatic leaves with revolute margins.',
    isPlant: true,
  ),
  const RecognitionTestSample(
    id: 'sample_patchouli',
    label: 'Patchouli',
    subtitle: 'Pogostemon cablin',
    imageUrl: '',
    expectedPlantId: 'patchouli_plant',
    testDescription: 'Soft ovate serrated patchouli foliage.',
    isPlant: true,
  ),
  const RecognitionTestSample(
    id: 'sample_not_plant',
    label: 'Household Object',
    subtitle: 'Non-Botanical Object',
    imageUrl: '',
    expectedPlantId: '',
    testDescription: 'Non-botanical household object to test plant detection gate.',
    isPlant: false,
  ),
];
