class AgronomyDossier {
  final String plantId;
  final String speciesName;
  final String botanicalName;
  final String primaryPart;
  final String soilAndPh;
  final String seedRateAndSpacing;
  final String climateZone;
  final String irrigationNeeds;
  final int daysToMaturity;
  final String harvestingIndicators;
  final String postHarvestCuring;
  final String expectedYield;

  const AgronomyDossier({
    required this.plantId,
    required this.speciesName,
    required this.botanicalName,
    required this.primaryPart,
    required this.soilAndPh,
    required this.seedRateAndSpacing,
    required this.climateZone,
    required this.irrigationNeeds,
    required this.daysToMaturity,
    required this.harvestingIndicators,
    required this.postHarvestCuring,
    required this.expectedYield,
  });
}

class GovernmentScheme {
  final String title;
  final String agency;
  final String subsidyRate;
  final String description;
  final List<String> eligibilityCriteria;
  final List<String> requiredDocuments;
  final String officialPortal;
  final String helplineNumber;
  final String lastVerified;

  const GovernmentScheme({
    required this.title,
    required this.agency,
    required this.subsidyRate,
    required this.description,
    required this.eligibilityCriteria,
    required this.requiredDocuments,
    required this.officialPortal,
    required this.helplineNumber,
    required this.lastVerified,
  });
}

class MarketBenchmark {
  final String cropName;
  final String botanicalName;
  final String grade;
  final String wholesalePriceBand;
  final String trend;
  final String majorMandi;
  final String demandLevel;
  final String lastUpdated;

  const MarketBenchmark({
    required this.cropName,
    required this.botanicalName,
    required this.grade,
    required this.wholesalePriceBand,
    required this.trend,
    required this.majorMandi,
    required this.demandLevel,
    required this.lastUpdated,
  });
}

final List<AgronomyDossier> mockAgronomyDossiers = [
  const AgronomyDossier(
    plantId: 'ashwagandha',
    speciesName: 'Ashwagandha',
    botanicalName: 'Withania somnifera',
    primaryPart: 'Roots & Seeds',
    soilAndPh: 'Sandy loam or light red soil, well-drained. pH 7.5 – 8.0. Unsuitable in waterlogged black clay.',
    seedRateAndSpacing: '10 – 12 kg/ha (broadcasting) or 5 kg/ha (line sowing at 20 cm × 10 cm spacing).',
    climateZone: 'Sub-tropical dry zones with 500–750 mm rainfall. Tolerates mild winter chill and drought.',
    irrigationNeeds: 'Predominantly rainfed late-kharif crop. 1–2 life-saving light irrigations during prolonged dry spells.',
    daysToMaturity: 165,
    harvestingIndicators: 'Leaves begin yellowing and berries turn bright red/orange (150–180 days after sowing).',
    postHarvestCuring: 'Uproot roots carefully, wash soil, sun-dry to < 10% moisture. Cut into 7–10 cm pieces; grade into A, B, and C.',
    expectedYield: '650 – 850 kg dried roots + 50 kg berries/seeds per hectare.',
  ),
  const AgronomyDossier(
    plantId: 'tulsi',
    speciesName: 'Tulsi (Holy Basil)',
    botanicalName: 'Ocimum sanctum',
    primaryPart: 'Leaves & Flowering Tops',
    soilAndPh: 'Fertile loamy to sandy loam soils with rich organic matter. pH 6.5 – 7.5.',
    seedRateAndSpacing: '250 – 300 g seeds/ha for nursery raising. Transplant seedlings at 40 cm × 40 cm.',
    climateZone: 'Warm tropical and subtropical climate with adequate sunlight. Vulnerable to severe frost.',
    irrigationNeeds: 'Weekly irrigation during summer; once every 12–15 days during winter. Avoid water stagnation.',
    daysToMaturity: 80,
    harvestingIndicators: 'First cut at 75–85 days when plants reach full bloom; subsequent cuts every 60–70 days.',
    postHarvestCuring: 'Harvest on bright sunny days. Shade-dry over clean tarpaulins for 8–10 days to preserve volatile essential oils.',
    expectedYield: '15 – 20 tonnes fresh herbage or 3 – 4 tonnes shade-dried leaves/ha annually (3 cuts).',
  ),
  const AgronomyDossier(
    plantId: 'aloe_vera',
    speciesName: 'Aloe Vera',
    botanicalName: 'Aloe barbadensis miller',
    primaryPart: 'Fleshy Mucilaginous Leaves',
    soilAndPh: 'Sandy coastal soils to degraded marginal lands with good drainage. pH 7.0 – 8.5.',
    seedRateAndSpacing: 'Propagation via root suckers. 25,000 – 30,000 suckers/ha planted at 60 cm × 60 cm.',
    climateZone: 'Arid and semi-arid tropical regions. Highly drought-tolerant; sensitive to frost and waterlogging.',
    irrigationNeeds: 'Extremely low. 1 irrigation after planting suckers; 4–6 light irrigations per year during dry months.',
    daysToMaturity: 360,
    harvestingIndicators: 'Outer mature leaves (12–14 months old) reaching 40–50 cm length and 400–600 g weight.',
    postHarvestCuring: 'Slice cleanly at leaf base without tearing. Transport to processing unit within 4–6 hours to prevent gel oxidation.',
    expectedYield: '40 – 50 tonnes fresh mature leaves per hectare annually from year 2.',
  ),
  const AgronomyDossier(
    plantId: 'amla',
    speciesName: 'Amla (Indian Gooseberry)',
    botanicalName: 'Phyllanthus emblica',
    primaryPart: 'Fresh & Dried Fruits',
    soilAndPh: 'Deep loamy to clay-loam soil. Highly tolerant to sodic and saline conditions (pH up to 9.5).',
    seedRateAndSpacing: 'Budded/grafted saplings (NA-7, Krishna, Kanchan). 200 trees/ha spaced at 7 m × 7 m.',
    climateZone: 'Tropical to subtropical. Tolerates dry heat up to 46°C and winter temperature drops down to 0°C.',
    irrigationNeeds: 'Young trees need irrigation every 10–15 days in summer. Established orchards are mostly rainfed.',
    daysToMaturity: 240,
    harvestingIndicators: 'Fruits turn greenish-yellow to translucent with distinct seed segment lines (Nov – Jan).',
    postHarvestCuring: 'Grade by size. For dried flakes, steam-blanch, deseed, and solar-dry to moisture < 8%.',
    expectedYield: '15 – 20 tonnes fresh fruit/ha from year 6 onwards (100–150 kg per mature tree).',
  ),
  const AgronomyDossier(
    plantId: 'brahmi',
    speciesName: 'Brahmi',
    botanicalName: 'Bacopa monnieri',
    primaryPart: 'Whole Herb & Leaves',
    soilAndPh: 'Wet, marshy, clay-loam to alluvial soil with high moisture retention. pH 6.0 – 7.5.',
    seedRateAndSpacing: 'Vegetative stem cuttings (5–10 cm long). 60,000 cuttings/ha planted at 20 cm × 20 cm.',
    climateZone: 'Warm, humid tropical climate with abundant sunshine. Grows vigorously along wetlands.',
    irrigationNeeds: 'High water requirement. Field must remain continuously moist or lightly flooded (2–3 cm water).',
    daysToMaturity: 90,
    harvestingIndicators: 'First harvest 90 days after planting; repeat cuts every 60–75 days leaving 5 cm stubble.',
    postHarvestCuring: 'Wash herbage thoroughly, shade-dry on raised wire-mesh racks to retain rich green color and bacoside potency.',
    expectedYield: '25 – 30 tonnes fresh herbage or 4 – 5 tonnes dried biomass/ha annually (3–4 harvests).',
  ),
  const AgronomyDossier(
    plantId: 'gotu_kola',
    speciesName: 'Gotu Kola (Mandukaparni)',
    botanicalName: 'Centella asiatica',
    primaryPart: 'Leaves & Whole Herb',
    soilAndPh: 'Rich damp sandy-clay loam with plentiful humus. pH 6.5 – 7.5.',
    seedRateAndSpacing: 'Stolon cuttings or rooted runners. 40,000 runners/ha planted at 30 cm × 30 cm.',
    climateZone: 'Tropical and humid subtropical regions. Thrives best under partial canopy shade (25–30% shade).',
    irrigationNeeds: 'Regular sprinkler or channel irrigation every 4–6 days to maintain consistent surface moisture.',
    daysToMaturity: 90,
    harvestingIndicators: 'Leaves expand to 3–5 cm width with deep green pigmentation (80–90 days).',
    postHarvestCuring: 'Harvest early morning. Shade-dry over clean mats; do not dry under direct harsh sunlight.',
    expectedYield: '10 – 12 tonnes fresh herbage or 1.8 – 2.2 tonnes dried herb per hectare annually.',
  ),
  const AgronomyDossier(
    plantId: 'moringa',
    speciesName: 'Moringa (Drumstick Tree)',
    botanicalName: 'Moringa oleifera',
    primaryPart: 'Leaves, Pods & Seeds',
    soilAndPh: 'Well-drained sandy or loamy soil. Sensitive to water stagnation. pH 6.5 – 8.0.',
    seedRateAndSpacing: 'For leaf production (high density): 500 g seeds/ha planted at 1 m × 1 m (10,000 trees/ha).',
    climateZone: 'Warm tropical and subtropical belts. Heat tolerant; vulnerable to severe continuous frost.',
    irrigationNeeds: 'Moderate. Drip irrigation every 7–10 days ensures continuous leaf flushing during summer.',
    daysToMaturity: 75,
    harvestingIndicators: 'First harvest of young branches at 70–80 days when plants reach 1.2 m height; harvest every 45 days.',
    postHarvestCuring: 'Strip leaflets, wash in ozonated or clean water, shade-dry at < 45°C to preserve green vitamin levels.',
    expectedYield: '6 – 8 tonnes dry leaf powder per hectare per year under intensive cutting management.',
  ),
  const AgronomyDossier(
    plantId: 'neem',
    speciesName: 'Neem',
    botanicalName: 'Azadirachta indica',
    primaryPart: 'Seeds (Azadirachtin) & Leaves',
    soilAndPh: 'Hard rocky, shallow, nutrient-poor dry soils. Highly resilient. pH 6.2 – 8.5.',
    seedRateAndSpacing: 'Polybag-raised seedlings. 200 – 250 trees/ha spaced at 6 m × 6 m or 7 m × 7 m.',
    climateZone: 'Arid and semi-arid tropical zones with 400–1,200 mm rainfall. Survives severe heat up to 48°C.',
    irrigationNeeds: 'Irrigate seedlings during the first year; established trees require zero artificial irrigation.',
    daysToMaturity: 365,
    harvestingIndicators: 'Drupes turn golden yellow and drop to ground (June – August); collect promptly.',
    postHarvestCuring: 'Depulp fruits immediately, wash seeds thoroughly, sun-dry to moisture < 9% to prevent fungal decay.',
    expectedYield: '30 – 50 kg dried seeds per mature tree annually (7–10 tonnes/ha).',
  ),
  const AgronomyDossier(
    plantId: 'sarpagandha',
    speciesName: 'Sarpagandha',
    botanicalName: 'Rauvolfia serpentina',
    primaryPart: 'Roots (Reserpine content)',
    soilAndPh: 'Deep sandy loam or clay loam rich in humus. pH 4.5 – 6.0 (slightly acidic).',
    seedRateAndSpacing: 'Root cuttings or nursery seedlings. 40,000 plants/ha planted at 45 cm × 30 cm.',
    climateZone: 'Humid tropical forests with high rainfall (1,500–2,500 mm). Needs sheltered partial shade.',
    irrigationNeeds: 'Requires 12–15 irrigations per year during dry non-monsoon periods.',
    daysToMaturity: 730,
    harvestingIndicators: 'Harvest after 2 to 3 years of growth when root reserpine content peaks (winter dormancy).',
    postHarvestCuring: 'Dig out root system with minimal breakage. Wash clean, cut into 10–12 cm pieces, sun-dry to 8% moisture.',
    expectedYield: '1,500 – 2,000 kg dried roots per hectare (at 30–36 months).',
  ),
  const AgronomyDossier(
    plantId: 'rosemary',
    speciesName: 'Rosemary',
    botanicalName: 'Salvia rosmarinus',
    primaryPart: 'Dried Needle Leaves & Oil',
    soilAndPh: 'Light, calcareous, gravelly well-drained soil. pH 6.5 – 7.8. Root rot occurs in wet clay.',
    seedRateAndSpacing: 'Terminal stem cuttings (10–12 cm long). 20,000 rooted cuttings/ha at 60 cm × 60 cm.',
    climateZone: 'Temperate and sub-tropical hill regions with moderate sunshine. Avoid humid tropical heat.',
    irrigationNeeds: 'Low water requirement. Drip irrigate once every 10–14 days. Allow topsoil to dry between watering.',
    daysToMaturity: 180,
    harvestingIndicators: 'Clip tender top 10–15 cm shoots prior to blooming when essential oil concentration is highest.',
    postHarvestCuring: 'Dry in dark, well-ventilated drying sheds at 32–35°C to preserve green color and needle integrity.',
    expectedYield: '2.5 – 3.5 tonnes dried leaves per hectare annually (2 harvests).',
  ),
];

final List<GovernmentScheme> mockGovernmentSchemes = [
  const GovernmentScheme(
    title: 'National Ayush Mission (NAM) Cultivation Subsidy',
    agency: 'National Medicinal Plants Board (NMPB), Ministry of AYUSH',
    subsidyRate: '30% to 50% of Total Cultivation Cost',
    description:
        'Financial assistance disbursed directly to farmers and farmer producer organisations (FPOs) for commercial cultivation of 140 prioritized medicinal plant species across eligible agro-climatic clusters.',
    eligibilityCriteria: [
      'Individual farmers, self-help groups (SHGs), and registered FPOs with land titles.',
      'Minimum cluster area of 2 hectares (can be aggregated across multiple smallholder farmers).',
      'Grower agreement with verified AYUSH pharmacy, extractor, or cooperative marketing channel.',
    ],
    requiredDocuments: [
      'Land Ownership Record (Pahani / RTC / 7/12 extract).',
      'Aadhaar card and active bank passbook copy (Aadhaar-linked account).',
      'Soil & irrigation water fitness laboratory test certificate.',
      'Cluster grower list with survey numbers certified by District Horticulture Officer (DHO).',
    ],
    officialPortal: 'https://echarak.ayush.gov.in/',
    helplineNumber: '011-23653444 (Toll-free: 1800-11-22-33)',
    lastVerified: 'November 2026',
  ),
  const GovernmentScheme(
    title: 'Mission for Integrated Development of Horticulture (MIDH)',
    agency: 'Ministry of Agriculture & Farmers Welfare, Govt of India',
    subsidyRate: '40% to 50% Capital Assistance',
    description:
        'Centrally sponsored scheme promoting protected cultivation (polyhouses, shade nets), certified disease-free planting material nurseries, micro-irrigation (drip systems), and post-harvest drying units for aromatic and medicinal crops.',
    eligibilityCriteria: [
      'Small and marginal farmers, progressive horticultural growers, and agricultural cooperatives.',
      'Land ownership or registered long-term lease (minimum 10 years).',
      'Compliance with Good Agricultural and Collection Practices (GACP).',
    ],
    requiredDocuments: [
      'Detailed Project Report (DPR) certified by an accredited agricultural engineer.',
      'Bank sanction letter for project term loan (if bank-financed).',
      'Land revenue sketch and non-encumbrance certificate.',
    ],
    officialPortal: 'https://midh.gov.in/',
    helplineNumber: '1800-180-1551 (Kisan Call Center)',
    lastVerified: 'November 2026',
  ),
  const GovernmentScheme(
    title: 'NHB Capital Investment Subsidy for Commercial Horticulture',
    agency: 'National Horticulture Board (NHB)',
    subsidyRate: 'Up to ₹30 Lakhs (40% of Project Cost)',
    description:
        'Credit-linked, back-ended capital investment subsidy for establishing commercial high-density medicinal crop farms, primary cleaning/grading warehouses, and cold-storage facilities for high-value botanical extracts.',
    eligibilityCriteria: [
      'Individual farmers, partnership firms, farmer cooperatives, and private agro-enterprises.',
      'Minimum bank term loan of 50% of the eligible project expenditure.',
      'Clear environmental and water clearance for the proposed farmland.',
    ],
    requiredDocuments: [
      'Comprehensive feasibility report and estimated cash flow forecast.',
      'Bank appraisal letter and loan sanction agreement.',
      'Registered land ownership title with revenue sketch.',
    ],
    officialPortal: 'https://nhb.gov.in/',
    helplineNumber: '0124-2342992',
    lastVerified: 'November 2026',
  ),
  const GovernmentScheme(
    title: 'e-Charak Digital Direct Market Platform',
    agency: 'National Medicinal Plants Board (NMPB) & CDAC',
    subsidyRate: '100% Free Trade Registration & Listing',
    description:
        'Virtual electronic marketplace connecting certified medicinal plant growers directly with licensed pharmaceutical manufacturers, wholesale traders, and AYUSH pharmacies to eliminate middleman price deductions.',
    eligibilityCriteria: [
      'Any registered farmer or cooperative harvesting authentic botanical produce.',
      'Physical inspection certificate or self-declaration of moisture and grade.',
    ],
    requiredDocuments: [
      'Farmer identity proof and mobile number verification.',
      'Harvest batch photos and test report of active constituents (optional for premium rate).',
    ],
    officialPortal: 'https://echarak.ayush.gov.in/',
    helplineNumber: '011-23653450',
    lastVerified: 'November 2026',
  ),
];

final List<MarketBenchmark> mockMarketBenchmarks = [
  const MarketBenchmark(
    cropName: 'Ashwagandha',
    botanicalName: 'Withania somnifera',
    grade: 'Grade A Thick Whole Root (Moisture < 10%)',
    wholesalePriceBand: '₹340 – ₹480 / kg',
    trend: '+12% (High Demand)',
    majorMandi: 'APMC Neemuch & Mandsaur (Madhya Pradesh)',
    demandLevel: 'Strong demand from domestic AYUSH extractors & EU exporters',
    lastUpdated: 'November 2026',
  ),
  const MarketBenchmark(
    cropName: 'Tulsi (Holy Basil)',
    botanicalName: 'Ocimum sanctum',
    grade: 'Clean Shade-Dried Leaves (Whole, Unbroken)',
    wholesalePriceBand: '₹85 – ₹135 / kg',
    trend: '+5% (Steady)',
    majorMandi: 'Nagpur & Lucknow Mandis',
    demandLevel: 'Steady domestic demand for herbal teas and cold formulations',
    lastUpdated: 'November 2026',
  ),
  const MarketBenchmark(
    cropName: 'Amla (Indian Gooseberry)',
    botanicalName: 'Phyllanthus emblica',
    grade: 'Dried Deseeded Flakes (Moisture < 8%)',
    wholesalePriceBand: '₹125 – ₹180 / kg',
    trend: '+8% (Firm)',
    majorMandi: 'Pratapgarh & Varanasi (Uttar Pradesh)',
    demandLevel: 'Bulk procurement by Chyawanprash manufacturers during winter',
    lastUpdated: 'November 2026',
  ),
  const MarketBenchmark(
    cropName: 'Brahmi',
    botanicalName: 'Bacopa monnieri',
    grade: 'Whole Dried Herbage (Rich Green, Stem < 20%)',
    wholesalePriceBand: '₹140 – ₹210 / kg',
    trend: '+15% (Rising)',
    majorMandi: 'Kolkata & Cuttack Markets',
    demandLevel: 'High demand from nootropic formulation brands and extractors',
    lastUpdated: 'November 2026',
  ),
  const MarketBenchmark(
    cropName: 'Gotu Kola (Mandukaparni)',
    botanicalName: 'Centella asiatica',
    grade: 'Shade-Dried Intact Leaves',
    wholesalePriceBand: '₹165 – ₹235 / kg',
    trend: '+10% (High Demand)',
    majorMandi: 'Kochi & Thrissur Mandis (Kerala)',
    demandLevel: 'Sustained demand for dermatological and cognitive formulations',
    lastUpdated: 'November 2026',
  ),
  const MarketBenchmark(
    cropName: 'Sarpagandha',
    botanicalName: 'Rauvolfia serpentina',
    grade: 'Dried Thick Root (Reserpine > 0.15%)',
    wholesalePriceBand: '₹750 – ₹1,150 / kg',
    trend: '+18% (Scarce Supply)',
    majorMandi: 'Guwahati & Dehradun Botanical Auctions',
    demandLevel: 'Very high industrial demand due to strict wild collection bans',
    lastUpdated: 'November 2026',
  ),
  const MarketBenchmark(
    cropName: 'Moringa Leaves',
    botanicalName: 'Moringa oleifera',
    grade: 'Organic Certified Fine Green Leaf Powder',
    wholesalePriceBand: '₹120 – ₹190 / kg',
    trend: '+6% (Steady)',
    majorMandi: 'Dindigul & Theni (Tamil Nadu)',
    demandLevel: 'Robust export demand to European and North American wellness markets',
    lastUpdated: 'November 2026',
  ),
  const MarketBenchmark(
    cropName: 'Aloe Vera',
    botanicalName: 'Aloe barbadensis miller',
    grade: 'Fresh Mature Thick Leaves (Farmgate)',
    wholesalePriceBand: '₹6.50 – ₹11.00 / kg',
    trend: 'Stable',
    majorMandi: 'Jodhpur & Barmer Farmgate Collections (Rajasthan)',
    demandLevel: 'Continuous demand from cosmetic and beverage processing factories',
    lastUpdated: 'November 2026',
  ),
];

