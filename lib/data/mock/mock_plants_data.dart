import '../models/plant_model.dart';

/// Verified botanical database of all 13 medicinal plant classes supported by the
/// MediPlant dual-stage vision system (medicinal_plant_model.onnx + plant_gate_model.onnx).
///
/// 13 Supported Classes (alphabetical by model slug):
///   1. aloe_vera
///   2. amla
///   3. ashwagandha
///   4. ayapana
///   5. brahmi
///   6. gotu_kola
///   7. moringa
///   8. multi_vitamin_plant
///   9. neem
///   10. rosemary
///   11. sarpagandha
///   12. tulsi
///   13. wood_apple
final List<Plant> mockPlants = [
  // ═══════════════════════════════════════════════════════════════════════════
  // 1. ALOE VERA
  // ═══════════════════════════════════════════════════════════════════════════
  const Plant(
    id: 'aloe_vera',
    commonName: 'Aloe Vera (Ghritkumari)',
    scientificName: 'Aloe barbadensis miller',
    family: 'Asphodelaceae (Aloe Family)',
    vernacularNames: {
      'Hindi': 'Ghritkumari / Gwarpatha',
      'Sanskrit': 'Ghritakumari',
      'Kannada': 'Lolisara',
      'Tamil': 'Katrazhai',
      'Telugu': 'Kalabanda',
      'Malayalam': 'Kattarvazha',
    },
    description:
        'Aloe Vera is a stemless or very short-stemmed succulent plant renowned for thousands '
        'of years across Egyptian, Ayurvedic, and Mediterranean medicine. Its thick, fleshy, '
        'lanceolate leaves contain clear mucilaginous gel packed with polysaccharides (acemannan), '
        'vitamins, minerals, and enzymes. It accelerates dermal wound repair, soothes gastrointestinal '
        'inflammation, stimulates collagen synthesis, and provides intense hydration.',
    imageUrl:
        'https://images.unsplash.com/photo-1596547609652-9cf5d8d76921?auto=format&fit=crop&w=800&q=80',
    medicinalUses: [
      'Accelerates burn, sunburn, and superficial wound healing',
      'Soothes gastritis, acid reflux, and ulcerative colitis (inner fillet)',
      'Moisturizes dry skin and combats inflammatory acne and psoriasis',
      'Reduces dental plaque and oral candida when used as an oral rinse',
      'Assists in mild blood glucose and lipid management in metabolic syndrome',
    ],
    healthBenefits: [
      'Acemannan activates macrophage phagocytosis and epidermal fibroblast growth',
      'Glucomannan and gibberellin stimulate collagen synthesis and cross-linking',
      'Contains bradykinase, which reduces excessive skin inflammation when applied topically',
      'High water content with antioxidant vitamins A (beta-carotene), C, and E',
      'Anthraquinones in latex offer potent short-term laxative effects',
    ],
    traditionalUses: [
      'Fresh inner gel applied directly to minor burns, cuts, and irritated skin',
      'Pulp blended with water or amla juice taken in the morning for liver and gut health',
      'Gel mixed with turmeric applied as an Ayurvedic face mask for blemishes',
      'Root and leaf juice prepared as classical Kumari Asava for female reproductive tonification',
    ],
    activeConstituents: [
      'Acemannan (acetylated polymannose)',
      'Aloin & Aloe-emodin (anthraquinone glycosides)',
      'Bradykinase & Amylase enzymes',
      'Salicylic acid & Saponins',
      'Vitamins A, C, E, B12, and Choline',
    ],
    partsUsed: ['Fresh inner gel / pulp', 'Leaf outer rind (extracts)', 'Leaf exudate (latex)'],
    sideEffects: [
      'Topical use is safe; occasional allergic contact dermatitis in sensitive individuals',
      'Oral ingestion of whole leaf/latex containing aloin may cause abdominal cramping and diarrhea',
      'Excessive internal intake can cause electrolyte imbalance (hypokalemia)',
    ],
    precautions: [
      'Always use purified inner gel free of yellow bitter latex for oral consumption',
      'Perform a skin patch test before widespread topical application',
      'Do not apply on deep surgical wounds or severe third-degree burns',
    ],
    contraindications: [
      'Contraindicated orally during pregnancy (aloin induces uterine contractions)',
      'Contraindicated in intestinal obstruction, Crohn’s disease, or appendicitis',
      'Caution with concurrent diuretic and anti-arrhythmic medications',
    ],
    preparationMethods:
        'Fillet the outer green rind to extract the clear inner jelly. Wash thoroughly with clean water '
        'to purge yellow bitter aloin latex before topical use or culinary blending.',
    dosageGuidelines:
        'Topical: Apply generous layer of fresh gel 2-3 times daily. '
        'Internal: 15-30 ml purified inner gel juice mixed with water once daily before breakfast.',
    habitat: 'Arid, tropical, and subtropical regions; easily cultivated in sunny home gardens and pots.',
    appearance: 'Dense rosette of thick, lanceolate, fleshy green leaves with serrated spiny margins.',
    plantType: 'Medicinal Succulent',
    isSupportedInModel2: true,
  ),

  // ═══════════════════════════════════════════════════════════════════════════
  // 2. AMLA
  // ═══════════════════════════════════════════════════════════════════════════
  const Plant(
    id: 'amla',
    commonName: 'Amla (Indian Gooseberry)',
    scientificName: 'Phyllanthus emblica',
    family: 'Phyllanthaceae (Gooseberry Family)',
    vernacularNames: {
      'Hindi': 'Amla / Aonla',
      'Sanskrit': 'Amalaki / Dhatri',
      'Kannada': 'Nellikai',
      'Tamil': 'Nellikai',
      'Telugu': 'Usirikaya',
      'Malayalam': 'Nellikka',
    },
    description:
        'Amla, or Indian Gooseberry, is one of the most celebrated rejuvenating rasayana herbs in '
        'Ayurvedic pharmacology and the chief ingredient in Chyawanprash and Triphala. The greenish-yellow '
        'globular fruit possesses one of the highest concentrations of heat-stable Vitamin C found in nature, '
        'bound to protective polyphenols (ellagitannins, emblicanin A & B). It strengthens immune vitality, '
        'reverses oxidative stress, promotes hair pigmentation and follicle growth, and fortifies digestion.',
    imageUrl: 'assets/plants/amla_plant.jpg',
    medicinalUses: [
      'Potent systemic antioxidant protection and cellular rejuvenation',
      'Immune defense against seasonal viral and upper respiratory infections',
      'Strengthens hair follicles, prevents premature graying and combats alopecia',
      'Aids glycemic control and reduces HbA1c in type 2 diabetic profiles',
      'Protects liver tissue against hepatotoxins and lipid peroxidation',
    ],
    healthBenefits: [
      'Contains 600-900 mg of Vitamin C per 100g, stabilized by emblicanin polyphenols',
      'Inhibits 5-alpha reductase enzyme to curb hair follicle shrinkage and thinning',
      'Promotes digestive agni without aggravating pitta dosha due to cooling virya',
      'Reduces LDL cholesterol and triglyceride accumulation in blood vessels',
      'Protects lens and retinal cells from diabetic oxidative glycation',
    ],
    traditionalUses: [
      'Fresh fruit chewed with a pinch of rock salt for oral hygiene and saliva stimulation',
      'Dried fruit decoction cooked in coconut oil to create cooling hair revitalizing oil',
      'Key component of Triphala Churna for colon regulation and gentle detoxification',
      'Raw juice taken with raw honey for morning immunity and metabolic activation',
    ],
    activeConstituents: [
      'Ascorbic acid (Vitamin C)',
      'Emblicanin A and Emblicanin B',
      'Ellagitannins (Punigluconin, Pedunculagin)',
      'Gallic acid & Ellagic acid',
      'Chebulinic acid & Quercetin',
    ],
    partsUsed: ['Fresh / dried fruit', 'Fruit pericarp', 'Leaves', 'Seeds'],
    sideEffects: [
      'Very safe nutritional fruit; excessive raw consumption can cause mild stomach acidity or loosen stools',
      'May enhance bleeding tendency when taken in concentrated extracts alongside antiplatelet agents',
    ],
    precautions: [
      'Diabetic patients should monitor glucose when starting therapeutic high-dose amla',
      'Avoid high doses late at night to prevent acid regurgitation in sensitive stomachs',
    ],
    contraindications: [
      'Contraindicated in acute dysentery or cold aggravated dry cough without proper carrier',
      'Discontinue high-dose extracts 2 weeks prior to scheduled surgery',
    ],
    preparationMethods:
        'Eat fresh fruit raw, prepare cold-pressed fresh juice with water, or grind shade-dried '
        'deseeded fruit into a fine micro-powder (churna).',
    dosageGuidelines:
        'Fresh juice: 15-20 ml diluted in water with honey. '
        'Churna (powder): 3-6 grams daily with warm water or ghee after meals.',
    habitat: 'Deciduous tropical and subtropical forests across the Indian subcontinent and Southeast Asia.',
    appearance: 'Small to medium tree with light gray bark, feathery pinnate leaves, and pale green round fruit.',
    plantType: 'Medicinal Deciduous Tree',
    isSupportedInModel2: true,
  ),

  // ═══════════════════════════════════════════════════════════════════════════
  // 3. ASHWAGANDHA
  // ═══════════════════════════════════════════════════════════════════════════
  const Plant(
    id: 'ashwagandha',
    commonName: 'Ashwagandha (Indian Ginseng)',
    scientificName: 'Withania somnifera',
    family: 'Solanaceae (Nightshade Family)',
    vernacularNames: {
      'Hindi': 'Ashwagandha / Asgandh',
      'Sanskrit': 'Ashwagandha / Vajikari',
      'Kannada': 'Ashwagandha / Amukkara',
      'Tamil': 'Amukkira Kilangu',
      'Telugu': 'Pennerugadda',
      'Malayalam': 'Amukkuram',
    },
    description:
        'Ashwagandha is one of the most revered adaptogenic herbs in Ayurvedic medicine, '
        'used for over 3,000 years to restore vitality, reduce stress, and strengthen the body. '
        'The name literally means "smell of horse," reflecting its traditional belief in imparting '
        'the strength and stamina of a horse. Its roots are rich in withanolides — steroidal lactones '
        'scientifically proven to modulate the stress axis, boost testosterone, and protect neurons.',
    imageUrl: 'assets/plants/ashwagandha_plant.jpg',
    medicinalUses: [
      'Adaptogenic stress relief and cortisol normalization',
      'Enhancement of male reproductive health and testosterone levels',
      'Neuroprotection and cognitive function support',
      'Immune system modulation and anti-inflammatory action',
      'Energy, stamina, and athletic performance improvement',
    ],
    healthBenefits: [
      'Withanolides reduce serum cortisol levels, mitigating adrenal fatigue',
      'Withaferin A demonstrates anti-cancer and anti-inflammatory properties in research',
      'Improves thyroid function by stimulating T4 to T3 conversion',
      'Enhances GABA receptor activity to reduce anxiety and promote sleep',
      'Increases VO2 max and muscle strength in clinical exercise studies',
    ],
    traditionalUses: [
      'Root powder boiled in milk with honey consumed nightly as a rasayana rejuvenative tonic',
      'Root paste applied topically on joint swellings and rheumatic pain',
      'Decoction given to children for growth, nutrition, and immune strengthening',
      'Used in classical Ayurvedic formulations like Ashwagandhadi Lehyam',
    ],
    activeConstituents: [
      'Withanolides (Withaferin A, Withanolide D)',
      'Alkaloids (Somniferine, Anaferine)',
      'Sitoindosides VII & VIII',
      'Iron, Steroidal Lactones',
      'Glycowithanolides',
    ],
    partsUsed: ['Dried Roots', 'Leaves (topical)', 'Seeds'],
    sideEffects: [
      'Generally very well tolerated at standard dosages',
      'High doses may cause mild stomach upset, nausea, or loose stools',
      'May cause mild drowsiness in sensitive individuals',
    ],
    precautions: [
      'Monitor thyroid levels if taking synthetic thyroid hormones',
      'May potentiate the sedative effect of barbiturates and benzodiazepines',
      'Discontinue 2 weeks prior to scheduled surgery',
    ],
    contraindications: [
      'Contraindicated in pregnancy — potential abortifacient activity at high doses',
      'Avoid in active hyperthyroidism unless supervised by an integrative physician',
      'Caution in autoimmune conditions (SLE, rheumatoid arthritis, Hashimoto’s)',
    ],
    preparationMethods:
        'Roots dried and ground to fine powder. Consumed as churna in warm milk, ghee, '
        'or standardized liquid or capsule extract (KSM-66 or Sensoril).',
    dosageGuidelines:
        'Churna (root powder): 3-6 grams daily with warm milk before bedtime. '
        'Standardized extract: 300-600 mg once or twice daily with food.',
    habitat: 'Dry, arid regions of India, the Middle East, and parts of Africa.',
    appearance: 'Small woody shrub (35-75 cm) with dull green elliptic leaves, bell-shaped greenish-yellow flowers, and red berries.',
    plantType: 'Medicinal Shrub',
    isSupportedInModel2: true,
  ),

  // ═══════════════════════════════════════════════════════════════════════════
  // 4. AYAPANA
  // ═══════════════════════════════════════════════════════════════════════════
  const Plant(
    id: 'ayapana',
    commonName: 'Ayapana (Water Hemp)',
    scientificName: 'Ayapana triplinervis',
    family: 'Asteraceae (Daisy Family)',
    vernacularNames: {
      'Hindi': 'Ayapana',
      'Sanskrit': 'Ayapanah',
      'Kannada': 'Ayapana',
      'Tamil': 'Ayapani',
      'Malayalam': 'Ayapana / Vishahari',
      'Bengali': 'Ayapan',
    },
    description:
        'Ayapana is an aromatic medicinal perennial herb native to tropical South America '
        'and naturalized widely across South India and Southeast Asia. Renowned for its potent '
        'hemostatic, antiseptic, and gastroprotective properties, it is traditionally applied '
        'to arrest active external bleeding and heal gastric ulcers. It contains ayapanin and '
        'ayapin, coumarin derivatives with proven antimicrobial and clot-stabilizing actions.',
    imageUrl: 'assets/plants/ayapana_plant.jpg',
    medicinalUses: [
      'Rapid hemostasis to stop bleeding from cuts, wounds, and hemorrhoids',
      'Gastric ulcer healing, digestive stimulant, and hyperacidity relief',
      'Antimicrobial protection against skin pathogens and fungal infections',
      'Antidote for insect bites, scorpion stings, and minor reptile bites',
      'Gentle diaphoretic tea for clearing fever, cold, and respiratory phlegm',
    ],
    healthBenefits: [
      'Ayapanin and ayapin act as coumarins with significant vascular protective actions',
      'Accelerates tissue granulation and wound closure when applied as fresh crushed poultice',
      'Inhibits excessive gastric acid secretion and protects mucosal lining',
      'Essential oil fractions demonstrate broad-spectrum antimicrobial efficacy',
    ],
    traditionalUses: [
      'Fresh leaf crushed between fingers and applied directly to cuts for instant hemostasis',
      'Hot water leaf infusion consumed for stomach cramps, indigestion, and diarrhea',
      'Decoction used as an antiseptic gargle for bleeding gums and mouth ulcers',
      'Leaves boiled in coconut oil applied topically on chronic slow-healing wounds',
    ],
    activeConstituents: [
      'Ayapanin (7-methoxycoumarin)',
      'Ayapin (6,7-methylenedioxycoumarin)',
      'Thymohydroquinone dimethyl ether',
      'Stigmasterol and Beta-sitosterol',
      'Essential oils, Flavonoids, Tannins',
    ],
    partsUsed: ['Fresh leaves', 'Tender stems', 'Whole aerial plant'],
    sideEffects: [
      'Extremely safe in traditional external applications',
      'Very high oral doses of raw coumarins may cause mild nausea',
    ],
    precautions: [
      'Patients on prescription anticoagulant drugs (Warfarin, Heparin) should avoid high oral doses',
      'Ensure leaves are thoroughly washed before application on open skin breaks',
    ],
    contraindications: [
      'Contraindicated in severe bleeding disorders (hemophilia) without medical supervision',
      'Avoid high-dose internal consumption during pregnancy',
    ],
    preparationMethods:
        'Fresh leaves bruised to extract juice for topical wound application. '
        'Dry or fresh leaves steeped in boiling water for 5-7 minutes for herbal digestive tea.',
    dosageGuidelines:
        'Topical: Apply bruised leaves or extracted juice directly on wound. '
        'Internal: 10-15 ml fresh leaf juice or 50-100 ml infusion twice daily before meals.',
    habitat: 'Tropical river banks, damp forest edges, and cultivated home gardens in moist climates.',
    appearance: 'Erect perennial herb (40-60 cm) with reddish-purple stems, narrow lanceolate aromatic leaves, and pale purple flower heads.',
    plantType: 'Medicinal Herb',
    isSupportedInModel2: true,
  ),

  // ═══════════════════════════════════════════════════════════════════════════
  // 5. BRAHMI
  // ═══════════════════════════════════════════════════════════════════════════
  const Plant(
    id: 'brahmi',
    commonName: 'Brahmi (Water Hyssop)',
    scientificName: 'Bacopa monnieri',
    family: 'Plantaginaceae (Plantain Family)',
    vernacularNames: {
      'Hindi': 'Brahmi / Jalneem',
      'Sanskrit': 'Brahmi / Medhya',
      'Kannada': 'Brahmi / Ondelaga',
      'Tamil': 'Neerbrahmi',
      'Telugu': 'Sambhramachettu',
      'Malayalam': 'Brahmi',
    },
    description:
        'Brahmi is one of the premier "Medhya Rasayana" (brain-enhancing intellect rejuvenators) '
        'in the Vedic medical tradition, documented in Charaka Samhita for boosting memory, '
        'concentration, and neurological longevity. A small creeping marsh succulent, its active '
        'bacosides repair damaged neurons, enhance synaptic synaptic transmission, stimulate '
        'cerebral protein synthesis, and exert anxiolytic, neuroprotective calm without sedation.',
    imageUrl: 'assets/plants/brahmi_plant.jpg',
    medicinalUses: [
      'Improves memory consolidation, cognitive retention, and information recall',
      'Reduces anxiety, mental fatigue, brain fog, and chronic nervous restlessness',
      'Supports neuro-regeneration and neuroplasticity in age-related cognitive decline',
      'Assists focus and executive functioning in attention deficit conditions',
      'Exerts mild anticonvulsant and neuroprotective antioxidant actions',
    ],
    healthBenefits: [
      'Bacosides A & B cross the blood-brain barrier to repair damaged synaptic structures',
      'Modulates dopamine and serotonin receptor density, improving emotional equilibrium',
      'Up-regulates brain superoxide dismutase (SOD) and catalase against free radical toxicity',
      'Stimulates GABA synthesis to alleviate neurogenic stress and insomnia',
      'Enhances cerebral blood flow and oxygenation without elevating cardiac blood pressure',
    ],
    traditionalUses: [
      'Fresh leaves sautéed in pure cow ghee (Brahmi Ghrita) consumed on an empty stomach for intellect',
      'Fresh juice given to students to enhance exam preparation and retention',
      'Leaves boiled in coconut or sesame oil massaged into the scalp for cooling mental calm and deep sleep',
      'Decoction mixed with honey for hoarseness of voice, speech clarity, and throat stamina',
    ],
    activeConstituents: [
      'Bacoside A (bacoside A3, bacopaside II, jujubogenin isomer)',
      'Bacoside B',
      'Bacopasaponins & Betulinic acid',
      'Luteolin & Apigenin flavonoids',
      'Hersaponin, D-mannitol, Stigmasterol',
    ],
    partsUsed: ['Whole creeping plant', 'Fresh leaves', 'Tender succulent stems'],
    sideEffects: [
      'Very safe botanical; can occasionally cause mild gastrointestinal cramps or nausea if taken on an empty stomach without ghee/milk',
      'May produce a mild laxative effect at higher doses',
    ],
    precautions: [
      'Best absorbed when taken alongside dietary healthy fats (milk, ghee, coconut oil)',
      'May increase thyroid hormone concentrations; monitor if hyperthyroid',
    ],
    contraindications: [
      'Caution with concurrent sedatives, thyroid medication, or calcium channel blockers',
      'Contraindicated in urinary tract obstruction or acute gastrointestinal ulceration',
    ],
    preparationMethods:
        'Consume as fresh juice with honey, take powdered dried whole herb blended in warm milk, '
        'or administer medically prepared classical Brahmi Ghrita.',
    dosageGuidelines:
        'Fresh leaf juice: 10-15 ml once daily. '
        'Dry herb powder: 2-3 grams daily in warm milk with honey. '
        'Standardized extract (20% bacosides): 300-450 mg daily with a fat-containing meal.',
    habitat: 'Wet, marshy wetlands, stream banks, and tropical shallow rice paddies across India.',
    appearance: 'Low creeping succulent perennial with oblong fleshy leaves and delicate pale blue or white flowers.',
    plantType: 'Medicinal Aquatic Succulent',
    isSupportedInModel2: true,
  ),

  // ═══════════════════════════════════════════════════════════════════════════
  // 6. GOTU KOLA
  // ═══════════════════════════════════════════════════════════════════════════
  const Plant(
    id: 'gotu_kola',
    commonName: 'Gotu Kola (Mandukaparni)',
    scientificName: 'Centella asiatica',
    family: 'Apiaceae (Parsley Family)',
    vernacularNames: {
      'Hindi': 'Mandukaparni / Brahmi booti',
      'Sanskrit': 'Mandukaparni / Saraswati',
      'Kannada': 'Ondelaga / Timare',
      'Tamil': 'Vallarai',
      'Telugu': 'Saraswathi Aku',
      'Malayalam': 'Muthil / Kodangal',
    },
    description:
        'Gotu Kola is a revered Ayurvedic rejuvenating herb (Medhya Rasayana) and a staple of '
        'traditional Chinese medicine, frequently referred to as the "herb of longevity." '
        'Its distinctive fan- or kidney-shaped leaves resemble the hemispheres of the human brain, '
        'echoing the traditional doctrine of signatures. Clinically, it stimulates microcirculation, '
        'promotes collagen synthesis type I, enhances memory retention, and soothes systemic inflammation.',
    imageUrl: 'assets/plants/gotu_kola_plant.jpg',
    medicinalUses: [
      'Cognitive enhancement, concentration, and mental stamina',
      'Venous insufficiency, varicose veins, and microcirculation support',
      'Wound healing, scar reduction, and collagen type I stimulation',
      'Anxiety reduction and nervous system equilibrium',
      'Skin rejuvenation, eczema management, and stretch mark healing',
    ],
    healthBenefits: [
      'Asiaticoside stimulates type I collagen synthesis and angiogenesis for tissue repair',
      'Madecassoside exhibits potent neuroprotective actions against amyloid-beta neurotoxicity',
      'Improves microvascular flow and reduces capillary filtration in chronic venous insufficiency',
      'Modulates GABA and BDNF pathways to improve mental focus and relieve anxiety',
    ],
    traditionalUses: [
      'Fresh leaves eaten raw with grated coconut and rice (Vallarai Thuvaiyal / Sambol) for memory',
      'Leaf juice mixed with honey taken daily in the morning for nervous clarity',
      'Leaf paste applied to wounds, burns, and chronic eczema to prevent hypertrophic scarring',
      'Infused in sesame oil for cooling head massage to stimulate hair growth and calm the mind',
    ],
    activeConstituents: [
      'Triterpenoid saponins (Asiaticoside, Madecassoside)',
      'Asiatic acid and Madecassic acid',
      'Centelloside, Brahminoside',
      'Quercetin, Kaempferol flavonoids',
      'Vitamins B, C, and mineral ash',
    ],
    partsUsed: ['Fresh leaves', 'Aerial parts', 'Whole plant'],
    sideEffects: [
      'Extremely safe culinary and medicinal herb consumed daily as food in Sri Lanka and India',
      'Very high doses may rarely cause mild headache or skin rash in hypersensitive individuals',
    ],
    precautions: [
      'May interact additively with sedative or anxiolytic medications',
      'Discontinue 2 weeks before elective surgical procedures',
    ],
    contraindications: [
      'High-dose medicinal extracts contraindicated during pregnancy and lactation',
      'Caution in patients with severe pre-existing hepatic impairment',
    ],
    preparationMethods:
        'Fresh leaves consumed raw in salads or pestos. Dried whole herb ground to powder '
        'or steeped as hot water herbal infusion.',
    dosageGuidelines:
        'Fresh leaves: 5-10 leaves daily. '
        'Churna (powder): 2-4 grams daily with warm water, milk, or ghee. '
        'Extract: 500-1000 mg standardized extract daily.',
    habitat: 'Tropical and subtropical wetlands, stream edges, and damp shaded soils.',
    appearance: 'Creeping herbaceous perennial with slender stolons, kidney-shaped notched leaves, and tiny pinkish-white flowers.',
    plantType: 'Medicinal Herb',
    isSupportedInModel2: true,
  ),

  // ═══════════════════════════════════════════════════════════════════════════
  // 7. MORINGA
  // ═══════════════════════════════════════════════════════════════════════════
  const Plant(
    id: 'moringa',
    commonName: 'Moringa (Drumstick Tree)',
    scientificName: 'Moringa oleifera',
    family: 'Moringaceae (Moringa Family)',
    vernacularNames: {
      'Hindi': 'Sahjan / Munaga',
      'Sanskrit': 'Shigru / Shobhanjana',
      'Kannada': 'Nuggekai',
      'Tamil': 'Murungai',
      'Telugu': 'Munaga Chettu',
      'Malayalam': 'Muringa',
    },
    description:
        'Moringa, often crowned "The Miracle Tree," is an exceptionally resilient drought-resistant '
        'tree whose leaves boast extraordinary nutrient density. Gram for gram, fresh moringa leaves '
        'contain 7x more Vitamin C than oranges, 4x more calcium than milk, 4x more Vitamin A than carrots, '
        'and 3x more potassium than bananas. It serves as an anti-inflammatory, antioxidant power plant, '
        'combats malnutrition, stabilizes blood sugar, and supports lactation in nursing mothers.',
    imageUrl: 'assets/plants/moringa_plant.jpg',
    medicinalUses: [
      'Combatting nutritional deficiencies, chronic fatigue, and anemia',
      'Blood glucose regulation and postprandial insulin sensitivity',
      'Anti-inflammatory relief for joint stiffness, arthritis, and edema',
      'Cardioprotective lipid lowering and blood pressure modulation',
      'Natural galactagogue stimulating breast milk production in postpartum mothers',
    ],
    healthBenefits: [
      'Isothiocyanates (moringin) suppress inflammatory cytokines and NF-kB signaling',
      'High polyphenol content (chlorogenic acid, quercetin) inhibits hepatic glucose release',
      'Bioavailable plant iron and folate elevate hemoglobin levels safely in nutritional anemia',
      'Potent antimicrobial action against enteric bacteria and dermatophytes',
      'Rich in all 9 essential amino acids, making it a complete botanical protein source',
    ],
    traditionalUses: [
      'Fresh leaves cooked into savory dhal, stir-fries, and medicinal soups for strength',
      'Leaf juice mixed with honey taken for high blood pressure and bronchial asthma',
      'Leaf poultice applied over glandular swellings, joint inflammation, and headaches',
      'Crushed seeds utilized for traditional coagulant water purification',
    ],
    activeConstituents: [
      'Isothiocyanates (Moringin)',
      'Chlorogenic acid & Quercetin',
      'Beta-carotene, Vitamins A, C, E, K',
      'Calcium, Potassium, Iron, Magnesium',
      'Complete essential amino acids profile',
    ],
    partsUsed: ['Fresh / dried leaves', 'Tender seed pods (drumsticks)', 'Seeds', 'Bark (external)'],
    sideEffects: [
      'Leaves and pods are widely consumed safe culinary staples',
      'Overconsumption of raw leaf powder may cause mild laxative effects or stomach rumble',
      'Bark and roots contain alkaloid spirochin and should NOT be consumed internally',
    ],
    precautions: [
      'Monitor blood sugar levels if taking oral antidiabetic agents',
      'Stick to leaves and culinary pods; avoid roots, bark, and excessive seed consumption',
    ],
    contraindications: [
      'Moringa bark, roots, and flowers are contraindicated in pregnancy due to potential uterine stimulation',
      'Use caution if taking thyroid replacement hormones',
    ],
    preparationMethods:
        'Incorporate fresh leaves into curries and soups. Dry leaves in shade and powder '
        'for adding to smoothies, warm water, or herbal teas.',
    dosageGuidelines:
        'Fresh leaves: 1-2 cups cooked daily. '
        'Leaf powder: 3-5 grams daily with warm water, juice, or meals.',
    habitat: 'Sub-Himalayan tracts, arid and semi-arid tropical regions worldwide.',
    appearance: 'Fast-growing slender deciduous tree with drooping branches, tripinnate feathery leaves, fragrant white flowers, and long ribbed seed pods.',
    plantType: 'Medicinal Superfood Tree',
    isSupportedInModel2: true,
  ),

  // ═══════════════════════════════════════════════════════════════════════════
  // 8. MULTI VITAMIN PLANT
  // ═══════════════════════════════════════════════════════════════════════════
  const Plant(
    id: 'multi_vitamin_plant',
    commonName: 'Multi Vitamin Plant (Chakra Muni / Katuk)',
    scientificName: 'Sauropus androgynus',
    family: 'Phyllanthaceae (Gooseberry Family)',
    vernacularNames: {
      'Hindi': 'Chakra Muni / Multivitamin paudha',
      'Sanskrit': 'Chakramuni',
      'Kannada': 'Chakramuni / Chekurmanis',
      'Tamil': 'Thavasi Murungai',
      'Malayalam': 'Madhura Cheera / Veli Cheera',
      'English': 'Sweet Leaf Bush / Katuk',
    },
    description:
        'Sauropus androgynus, popularly known across South and Southeast Asia as the "Multi-Vitamin Plant" '
        'or "Chakra Muni," is a perennial shrub celebrated as nature’s living multivitamin tablet. '
        'Consuming just a handful of its nutty, pea-flavored fresh leaves fulfills daily requirements '
        'for essential vitamins A, B-complex, C, and K, together with iron, calcium, and protein. '
        'It is extensively grown as an edible medicinal hedge for vitality, eye health, and lactation.',
    imageUrl: 'assets/plants/multi_vitamin_plant.jpg',
    medicinalUses: [
      'Natural whole-food multivitamin supplementation and prevention of nutritional deficiencies',
      'Enhancing eye health and preventing night blindness (provitamin A beta-carotene)',
      'Stimulating breast milk volume and quality in lactating mothers',
      'Combatting iron-deficiency anemia and boosting cellular oxygenation',
      'Supportive cooling green in fever, urinary dysuria, and metabolic heat',
    ],
    healthBenefits: [
      'Unusually high botanical protein content (up to 7% fresh weight, 34% dry weight)',
      'Massive beta-carotene concentration exceeds that of carrots and spinach',
      'Bioavailable calcium and phosphorus strengthen bone matrix and dental enamel',
      'Papaverine alkaloid fractions support smooth muscle relaxation and lactation induction',
      'Antioxidant polyphenols defend hepatocytes and red blood cells from lipid oxidation',
    ],
    traditionalUses: [
      'Fresh raw leaves (5-10 daily) chewed fresh straight from the plant for quick daily nourishment',
      'Leaves lightly sautéed with garlic, grated coconut, and lentils as therapeutic sabzi/curry',
      'Leaf soup prepared for newly delivered mothers to stimulate breast milk and rebuild blood',
      'Leaves crushed in cool water applied as a wash for inflamed eyes and skin rashes',
    ],
    activeConstituents: [
      'Beta-carotene (Provitamin A) & Lutein',
      'Vitamins B1 (thiamine), B2 (riboflavin), C, and K',
      'High plant protein and amino acids',
      'Calcium, Iron, Magnesium, Zinc, Phosphorus',
      'Papaverine alkaloid (trace)',
    ],
    partsUsed: ['Fresh leaves', 'Tender shoot tips'],
    sideEffects: [
      'Extremely safe and nutritious when eaten cooked or raw in customary culinary quantities (10-30 leaves/day)',
      'Excessive industrial juicing of kilograms of raw leaves for fad weight loss in the 1990s was linked to bronchiolitis obliterans; always consume in moderate normal dietary amounts',
    ],
    precautions: [
      'Cook or lightly steam leaves if consuming large bowlfuls to denature trace papaverine',
      'Do not consume extreme concentrated raw juices in excessive amounts',
    ],
    contraindications: [
      'Individuals with severe pre-existing pulmonary obstructive disease should avoid massive raw consumption',
    ],
    preparationMethods:
        'Eat fresh raw leaves (5-10 leaves) daily, or steam/stir-fry with lentils, coconut, and ghee '
        'for a delicious, highly nutritious medicinal vegetable dish.',
    dosageGuidelines:
        'Fresh leaves: 5-15 raw leaves daily as a living multivitamin, or 1 small bowl cooked with food.',
    habitat: 'Tropical home gardens, moist lowland shaded borders, and agroforestry hedges throughout India and Southeast Asia.',
    appearance: 'Upright dark green shrub (1-2 m) with flexible slender stems, alternate ovate leaves, and tiny dark red flowers along the underside of branchlets.',
    plantType: 'Medicinal Shrub / Vegetable',
    isSupportedInModel2: true,
  ),

  // ═══════════════════════════════════════════════════════════════════════════
  // 9. NEEM
  // ═══════════════════════════════════════════════════════════════════════════
  const Plant(
    id: 'neem',
    commonName: 'Neem (Indian Lilac)',
    scientificName: 'Azadirachta indica',
    family: 'Meliaceae (Mahogany Family)',
    vernacularNames: {
      'Hindi': 'Neem / Nimb',
      'Sanskrit': 'Nimba / Arishta',
      'Kannada': 'Bevinamara',
      'Tamil': 'Veppamaram',
      'Telugu': 'Vepa Chettu',
      'Malayalam': 'Aryaveppu',
    },
    description:
        'Neem is revered across the Indian subcontinent as the "Village Pharmacy" and "Cure-All" '
        '(Sarva Roga Nivarini). Every part of the tree possesses potent medicinal actions. Its intense '
        'bitter taste (tikta rasa) indicates strong blood-purifying, antiviral, antibacterial, '
        'antifungal, and antiparasitic properties. Rich in limonoids like azadirachtin and nimbin, '
        'it resolves chronic inflammatory skin disorders, controls hyperglycemia, and protects oral health.',
    imageUrl: 'assets/plants/neem_plant.jpg',
    medicinalUses: [
      'Dermatological conditions: severe acne, eczema, psoriasis, ringworm, and boils',
      'Blood purification and systemic toxic heat clearing (Pitta-Kapha pacification)',
      'Oral hygiene, gingivitis prevention, cavity reduction, and halitosis cure',
      'Antidiabetic blood glucose management and beta-cell support',
      'Natural insect repellent, head lice eradication, and wound disinfection',
    ],
    healthBenefits: [
      'Azadirachtin and gedunin disrupt bacterial cell walls and fungal ergosterol synthesis',
      'Nimbolide and nimbidin exert potent anti-inflammatory COX/LOX enzymatic inhibition',
      'Inhibits alpha-amylase and alpha-glucosidase to moderate glucose absorption',
      'Modulates immune response without over-activating allergic autoimmune pathways',
      'Promotes rapid re-epithelialization of infected or non-healing cutaneous ulcers',
    ],
    traditionalUses: [
      'Tender young leaves chewed on an empty stomach in spring for blood purification and immunity',
      'Leaf paste applied directly as a clarifying pack on cystic acne, rashes, and fungal infections',
      'Neem twigs used traditionally as toothbrushes (datun) for sparkling teeth and healthy gums',
      'Fresh leaves boiled in bathwater for treating skin eruptions, chickenpox rash, and pruritus',
    ],
    activeConstituents: [
      'Azadirachtin (tetranortriterpenoid)',
      'Nimbin, Nimbidin, Nimbolide',
      'Gedunin, Salannin, Mahmoodin',
      'Quercetin & Beta-sitosterol',
      'Essential sulfur-containing compounds',
    ],
    partsUsed: ['Leaves', 'Bark', 'Seeds / Seed Oil (external only)', 'Flowers', 'Twigs'],
    sideEffects: [
      'Extremely bitter; high internal doses can cause nausea or gastric irritation',
      'Neem seed oil is strictly for external use and is toxic if swallowed, especially in young children',
    ],
    precautions: [
      'Monitor blood sugar closely if on insulin or metformin',
      'Do not administer pure neem oil internally to children or infants',
    ],
    contraindications: [
      'Contraindicated during pregnancy and for couples attempting conception (anti-fertility effect)',
      'Avoid high-dose internal use in severe weakness, emaciation, or low blood pressure',
    ],
    preparationMethods:
        'Make fresh leaf paste with water for topical skin issues. Boil leaves in water for an antiseptic '
        'wash. Grind dried leaves into churna for micro-dosing.',
    dosageGuidelines:
        'Fresh leaves: 4-6 leaves chewed with water. '
        'Leaf juice: 5-10 ml diluted in water. '
        'Churna (powder): 1-2 grams daily for short courses (not exceeding 3-4 consecutive weeks).',
    habitat: 'Tropical and semi-arid plains, roadsides, and dry deciduous forests across the Indian subcontinent.',
    appearance: 'Large evergreen tree (15-20 m) with broad spreading crown, pinnate serrated leaflets, and fragrant white flowers.',
    plantType: 'Medicinal Tree',
    isSupportedInModel2: true,
  ),

  // ═══════════════════════════════════════════════════════════════════════════
  // 10. ROSEMARY
  // ═══════════════════════════════════════════════════════════════════════════
  const Plant(
    id: 'rosemary',
    commonName: 'Rosemary',
    scientificName: 'Salvia rosmarinus',
    family: 'Lamiaceae (Mint Family)',
    vernacularNames: {
      'Hindi': 'Rusmari / Rosemary',
      'Sanskrit': 'Rusmari',
      'Kannada': 'Rosemary',
      'Tamil': 'Rosemary',
      'Malayalam': 'Rosemary',
    },
    description:
        'Rosemary is a fragrant evergreen shrub native to the Mediterranean hillsides, celebrated '
        'since ancient Greece as the herb of memory and remembrance ("There’s rosemary, that’s for '
        'remembrance" — Hamlet). Its pungent, pine-like aroma stems from high concentrations of '
        'rosmarinic acid, carnosic acid, and camphor. It dramatically stimulates peripheral and '
        'cerebral circulation, boosts mental alertness, and arrests androgenetic alopecia hair loss.',
    imageUrl: 'assets/plants/rosemary_plant.jpg',
    medicinalUses: [
      'Memory retention, mental focus, alertness, and cognitive endurance',
      'Scalp stimulation, hair thinning reversal, and androgenetic alopecia defense',
      'Digestive stimulation, bile production, and relief of flatulence and dyspepsia',
      'Antimicrobial respiratory clearing, steam inhalation for sinusitis, and bronchial cough',
      'Topical analgesic relief for muscular aches, tension headaches, and arthritis',
    ],
    healthBenefits: [
      'Carnosic acid and carnosol inhibit lipid peroxidation and neutralize cerebral peroxynitrite radicals',
      'Inhibits acetylcholinesterase (AChE) to preserve acetylcholine levels essential for memory',
      'Topical rosemary oil shows efficacy comparable to 2% minoxidil in hair regrowth trials',
      'Rosmarinic acid down-regulates inflammatory leukotrienes and suppresses histamine release',
      'Stimulates microvascular capillary dilation to bring nutrients to nerve roots and hair follicles',
    ],
    traditionalUses: [
      'Crushed sprigs inhaled directly to banish fatigue, brain fog, and drowsiness while studying',
      'Leaves boiled in water to prepare hair rinse water to stimulate follicles and remove dandruff',
      'Infused in warm olive or jojoba oil massaged into the scalp 2-3 times per week for hair growth',
      'Hot tea steeped with lemon and honey consumed for sluggish digestion and tension headache',
    ],
    activeConstituents: [
      'Rosmarinic acid & Carnosic acid',
      'Carnosol & Ursolic acid',
      '1,8-Cineole (Eucalyptol)',
      'Camphor & Alpha-pinene',
      'Luteolin & Apigenin flavonoids',
    ],
    partsUsed: ['Fresh / dried needle leaves', 'Flowering sprigs', 'Essential oil (external)'],
    sideEffects: [
      'Culinary amounts are completely safe',
      'Undiluted essential oil can irritate sensitive skin; always dilute with carrier oil',
      'High internal doses of pure volatile oil may trigger vomiting or convulsions',
    ],
    precautions: [
      'Always dilute pure essential oil to 2-3% in carrier oil before scalp application',
      'Avoid high medicinal doses in individuals with epilepsy or high blood pressure',
    ],
    contraindications: [
      'High medicinal doses contraindicated in pregnancy (may stimulate menstrual flow)',
      'Do not ingest pure concentrated rosemary essential oil',
    ],
    preparationMethods:
        'Steep 1 tsp dried or fresh needle leaves in 1 cup boiling water for 10 minutes. '
        'For hair: simmer leaves in water for 20 minutes to make rosemary hair tonic water.',
    dosageGuidelines:
        'Tea: 1 cup (2-3 grams leaves) up to twice daily. '
        'Hair tonic: Spray liberally onto clean scalp daily and gently massage for 2-3 minutes.',
    habitat: 'Sunny, rocky Mediterranean hillsides; widely cultivated in well-drained garden pots.',
    appearance: 'Woody evergreen shrub with aromatic needle-like leaves (dark green above, white-pubescent beneath) and pale blue flowers.',
    plantType: 'Medicinal Aromatic Shrub',
    isSupportedInModel2: true,
  ),

  // ═══════════════════════════════════════════════════════════════════════════
  // 11. SARPAGANDHA
  // ═══════════════════════════════════════════════════════════════════════════
  const Plant(
    id: 'sarpagandha',
    commonName: 'Sarpagandha (Indian Snakeroot)',
    scientificName: 'Rauvolfia serpentina',
    family: 'Apocynaceae (Dogbane Family)',
    vernacularNames: {
      'Hindi': 'Sarpagandha / Chandrabhaga',
      'Sanskrit': 'Sarpagandha / Nakuli',
      'Kannada': 'Sarpagandhi / Patalagandhi',
      'Tamil': 'Sarpaganti',
      'Telugu': 'Sarpagandhi',
      'Malayalam': 'Sarpagandhi / Amalpori',
    },
    description:
        'Sarpagandha is a legendary medicinal shrub whose serpent-like roots gave modern medicine '
        'its first breakthrough pharmaceutical treatment for hypertension and schizophrenia — reserpine. '
        'Documented in Ayurvedic texts for over two millennia as "Nidrajanani" (inducer of deep sleep) '
        'and "Unmada Hara" (subduer of mental frenzy), it depletes catecholamines from peripheral sympathetic '
        'nerve endings, producing dramatic blood pressure reduction and central nervous sedation.',
    imageUrl: 'assets/plants/sarpagandha_plant.jpg',
    medicinalUses: [
      'Essential hypertension and acute hypertensive emergency management',
      'Severe insomnia, agitated restlessness, and nervous excitability',
      'Neuropsychiatric agitation, acute anxiety psychosis, and mania',
      'Traditional calming remedy for venomous snake bites and scorpion stings',
      'Uterine contractions stimulation in delayed or difficult labor (under strict supervision)',
    ],
    healthBenefits: [
      'Reserpine irreversibly blocks vesicular monoamine transporter (VMAT), depleting noradrenaline and serotonin',
      'Produces sustained, reliable peripheral vasodilatation and systemic blood pressure drop',
      'Ajmaline exhibits anti-arrhythmic Class IA actions on cardiac sodium channels',
      'Ajmalicine (raubasine) acts as an alpha-1 blocker improving peripheral and cerebral blood flow',
      'Calms hyperactive autonomic sympathetic tone, inducing deep sleep and cardiac rest',
    ],
    traditionalUses: [
      'Root powder mixed with pure rosewater or milk taken before bedtime for high blood pressure and insomnia',
      'Root decoction administered in classical Ayurveda for psychiatric agitation and mania',
      'Fresh root paste applied over the puncture wounds of viper and cobra bites',
      'Root powder combined with jatamansi and shankhpushpi for chronic nervous insomnia',
    ],
    activeConstituents: [
      'Reserpine (indole alkaloid)',
      'Ajmaline, Ajmalicine (Raubasine)',
      'Serpentine, Serpentinine',
      'Rescinnamine, Yohimbine (trace)',
      'Phytosterols and fatty acids',
    ],
    partsUsed: ['Dried Roots (primary)', 'Leaves (rare topical)'],
    sideEffects: [
      'POTENT MEDICINAL HERB — requires precise dosing; overdosage causes severe hypotension, bradycardia, nasal congestion, and severe depression',
      'Chronic unmonitored use can deplete dopamine leading to Parkinsonian tremors',
    ],
    precautions: [
      'MUST be used under qualified medical or Ayurvedic practitioner supervision',
      'Monitor blood pressure and pulse regularly throughout usage',
      'Do not abruptly discontinue high doses without medical advice',
    ],
    contraindications: [
      'STRICTLY CONTRAINDICATED in clinical depression or history of suicidal ideation',
      'Contraindicated in peptic ulcers, ulcerative colitis, Parkinson’s disease, and bradycardia',
      'Strictly contraindicated during pregnancy and breastfeeding',
    ],
    preparationMethods:
        'Roots dried and ground to fine standardized churna. Formulated in classical tablets '
        'like Sarpagandha Ghan Vati alongside balancing carminatives.',
    dosageGuidelines:
        'Root powder (churna): 250 mg to 500 mg (strictly controlled) at bedtime with milk or warm water. '
        'Sarpagandha Ghan Vati: 1 tablet (approx. 250 mg) at night under professional supervision.',
    habitat: 'Shady moist tropical deciduous forests and foothills of the Western Ghats and Sub-Himalayas.',
    appearance: 'Small erect glabrous evergreen shrub (30-90 cm) with whorled leaves, white-to-pinkish flowers, and black-purple berries.',
    plantType: 'Medicinal Shrub (Controlled Dosing)',
    isSupportedInModel2: true,
  ),

  // ═══════════════════════════════════════════════════════════════════════════
  // 12. TULSI
  // ═══════════════════════════════════════════════════════════════════════════
  const Plant(
    id: 'tulsi',
    commonName: 'Tulsi (Holy Basil)',
    scientificName: 'Ocimum tenuiflorum',
    family: 'Lamiaceae (Mint Family)',
    vernacularNames: {
      'Hindi': 'Tulsi',
      'Sanskrit': 'Tulasi / Surasa',
      'Kannada': 'Tulasi',
      'Tamil': 'Thulasi',
      'Telugu': 'Tulasi Chettu',
      'Malayalam': 'Tulasi',
    },
    description:
        'Tulsi, worshipped as the "Queen of Herbs" and "The Incomparable One," occupies the central '
        'courtyard of traditional Indian homes as a guardian of physical, spiritual, and ecological health. '
        'An extraordinary adaptogen, it protects against physical, chemical, metabolic, and psychological '
        'stress. Packed with eugenol, rosmarinic acid, and caryophyllene, Tulsi relieves coughs, colds, '
        'and bronchial congestion, balances blood glucose, purifies the air, and protects vital organs.',
    imageUrl: 'assets/plants/tulsi_plant.jpg',
    medicinalUses: [
      'Respiratory relief: productive cough, bronchitis, asthma, sinusitis, and cold',
      'Adaptogenic defense against psychological stress, anxiety, and mental fatigue',
      'Antimicrobial protection against viral pathogens, oral bacteria, and candida',
      'Fever reduction and immune modulation during seasonal viral infections',
      'Metabolic regulation of fasting blood glucose, lipid panels, and blood pressure',
    ],
    healthBenefits: [
      'Eugenol acts as a natural COX-2 inhibitor with potent pain-relieving and anti-inflammatory action',
      'Liquifies viscous bronchial phlegm and dilates airways through camphene and cineole volatile oils',
      'Reduces elevated stress hormone (cortisol) levels and mitigates adrenal exhaustion',
      'Elevates antioxidant glutathione and protects cellular DNA from toxic environmental radiation',
      'Exerts broad-spectrum antiviral action against respiratory and enveloped viruses',
    ],
    traditionalUses: [
      'Fresh leaves (4-5) plucked in the morning, chewed or swallowed with water for daily immunity',
      'Tulsi Ginger Kadha (decoction) boiled with black pepper and honey for severe colds and cough',
      'Leaves infused in boiling water used for steam inhalation to clear blocked sinuses',
      'Fresh leaf juice with honey given to children for fever, phlegm, and colic discomfort',
    ],
    activeConstituents: [
      'Eugenol (1-hydroxy-2-methoxy-4-allylbenzene)',
      'Rosmarinic acid & Ursolic acid',
      'Caryophyllene & Carvacrol',
      'Linalool, Camphene, Cineole',
      'Apigenin, Orientin, Vicenin flavonoids',
    ],
    partsUsed: ['Fresh leaves', 'Flowering tops / seeds', 'Root (decoctions)'],
    sideEffects: [
      'Extremely safe, widely consumed herb',
      'May mildly thin the blood; caution with prescription blood thinners',
      'High concentrated doses of eugenol over prolonged periods may have mild antifertility effects',
    ],
    precautions: [
      'Traditional recommendation to swallow whole or brew into tea rather than intensely chewing raw leaves to protect dental enamel from trace iron/mercury compounds',
      'Monitor blood sugar if taking antidiabetic pharmaceuticals',
    ],
    contraindications: [
      'Avoid high therapeutic doses during pregnancy and when actively trying to conceive',
      'Discontinue high-dose extracts 2 weeks before scheduled surgery',
    ],
    preparationMethods:
        'Steep 5-10 fresh leaves in boiling water for 5-7 minutes. Boil with ginger and black pepper '
        'for medicinal Kadha. Consume dried leaf tea daily.',
    dosageGuidelines:
        'Fresh leaves: 5-10 leaves daily. '
        'Herbal tea/infusion: 1-2 cups daily. '
        'Churna (powder): 2-3 grams daily with honey or warm water.',
    habitat: 'Cultivated in home gardens, temple courtyards, and warm tropical regions across India.',
    appearance: 'Aromatic branched subshrub (30-60 cm) with green or purple ovate serrate leaves and purple-flowered terminal racemes.',
    plantType: 'Medicinal Aromatic Herb',
    isSupportedInModel2: true,
  ),

  // ═══════════════════════════════════════════════════════════════════════════
  // 13. WOOD APPLE
  // ═══════════════════════════════════════════════════════════════════════════
  const Plant(
    id: 'wood_apple',
    commonName: 'Wood Apple (Bael / Elephant Apple)',
    scientificName: 'Limonia acidissima',
    family: 'Rutaceae (Citrus Family)',
    vernacularNames: {
      'Hindi': 'Bael / Kaitha / Bel',
      'Sanskrit': 'Kapittha / Bilva',
      'Kannada': 'Belada Hannu / Bilva Patre',
      'Tamil': 'Vilam Pazham / Vilvam',
      'Telugu': 'Velaga Pandu / Maredu',
      'Malayalam': 'Vilam Palam / Koovalam',
    },
    description:
        'Wood Apple is a sacred and robust tree whose trifoliate leaves are reverently offered to Lord Shiva '
        'and whose round, hard-shelled fruits are hailed as the supreme Ayurvedic remedy for gastrointestinal '
        'disorders. Both the leaves and the aromatic brown fruit pulp possess high concentrations of tannins, '
        'pectin, and coumarins (marmelosin), which tone intestinal mucosa, halt chronic diarrhea and dysentery, '
        'cool the digestive tract, and combat intestinal parasites.',
    imageUrl: 'assets/plants/wood_apple_plant.jpg',
    medicinalUses: [
      'Gastrointestinal therapy: chronic dysentery, bacillary diarrhea, and ulcerative colitis',
      'Digestive tonic for chronic indigestion, sluggish bowel, and hyperacidity',
      'Metabolic regulation of elevated blood glucose and insulin sensitivity',
      'Antiparasitic defense against intestinal worms and amoebic infections',
      'Cooling summer beverage to prevent heat stroke and dehydration',
    ],
    healthBenefits: [
      'Marmelosin and imperatorin coumarins provide antispasmodic and anti-inflammatory gut relief',
      'High tannin content astringently binds and heals weeping inflamed mucosal walls',
      'Rich in soluble pectin fiber, acting as a prebiotic substrate for healthy gut microbiota',
      'Leaf extracts stimulate beta cells to release insulin and improve peripheral glucose uptake',
      'Antimicrobial against enteropathogenic Escherichia coli, Shigella, and Salmonella strains',
    ],
    traditionalUses: [
      'Fresh fruit pulp blended with jaggery and water to make refreshing cooling Bael Sharbat',
      'Unripe dried fruit slice decoction consumed for acute watery dysentery and gut spasms',
      'Fresh leaves crushed and soaked overnight in water; the strained infusion consumed for diabetes',
      'Leaf juice mixed with black pepper taken for jaundice and liver sluggishness',
    ],
    activeConstituents: [
      'Marmelosin & Imperatorin (furocoumarins)',
      'Tannins (up to 20% in unripe fruit)',
      'Pectin (mucilage polysaccharides)',
      'Aegeline & Lupeol',
      'Citric acid, Ascorbic acid, Riboflavin',
    ],
    partsUsed: ['Ripe & unripe fruit pulp', 'Leaves (trifoliate)', 'Bark', 'Root'],
    sideEffects: [
      'Extremely safe and wholesome medicinal food',
      'Excessive consumption of unripe fruit high in tannins may cause temporary constipation',
    ],
    precautions: [
      'Monitor blood sugar levels closely if consuming therapeutic leaf extracts alongside diabetes drugs',
      'Choose ripe fruit for constipation and unripe fruit for diarrhea/dysentery',
    ],
    contraindications: [
      'High-dose leaf extracts are contraindicated during pregnancy (traditional emmenagogue actions)',
      'Avoid high unripe fruit tannin intake in acute intestinal obstruction',
    ],
    preparationMethods:
        'Crack open the hard woody shell and scoop out the pulp. Soak in water, mash and strain '
        'seeds/fibers to make Bael Sharbat. Leaves steeped as hot water tea.',
    dosageGuidelines:
        'Fruit pulp: 50-100 grams of fresh pulp diluted as beverage. '
        'Leaf juice: 10-15 ml once daily. '
        'Leaf churna: 2-3 grams daily before food.',
    habitat: 'Dry deciduous forests, rocky dry soils, and plains of India, Sri Lanka, and Southeast Asia.',
    appearance: 'Medium-sized armed thorny deciduous tree with smooth gray bark, alternate pinnate leaves (3-5 leaflets), and round hard woody-shelled fruit.',
    plantType: 'Medicinal Fruit Tree',
    isSupportedInModel2: true,
  ),
];
