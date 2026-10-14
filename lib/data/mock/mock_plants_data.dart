import '../models/plant_model.dart';

/// Verified database of all 10 medicinal plant classes supported by the
/// MediPlant 10-class ML model (mediplant_10class_best.keras).
///
/// Classes (alphabetical by model label):
///   ashwagandha_plant, ayapana_plant, cinnamon_plant, gotu_kola_plant,
///   insulin_plant, malabar_nut, pirandai_plant, rosemary_plant,
///   wood_apple_plant, ylang_ylang_plant
final List<Plant> mockPlants = [
  // ═══════════════════════════════════════════════════════════════════════════
  // 1. ASHWAGANDHA
  // ═══════════════════════════════════════════════════════════════════════════
  const Plant(
    id: 'ashwagandha_plant',
    commonName: 'Ashwagandha (Indian Ginseng)',
    scientificName: 'Withania somnifera',
    family: 'Solanaceae (Nightshade Family)',
    vernacularNames: {
      'Hindi': 'Ashwagandha / Asgandh',
      'Sanskrit': 'Ashwagandha / Vajikari',
      'Kannada': 'Ashwagandha / Amukkara',
      'Tamil': 'Amukkira Kilangu',
      'Telugu': 'Pennerugadda',
    },
    description:
        'Ashwagandha is one of the most revered adaptogenic herbs in Ayurvedic medicine, '
        'used for over 3,000 years to restore vitality, reduce stress, and strengthen the body. '
        'The name literally means "smell of horse," reflecting its traditional belief in imparting '
        'the strength and stamina of a horse. Its roots are rich in withanolides — steroidal lactones '
        'scientifically proven to modulate the stress axis, boost testosterone, and protect neurons.',
    imageUrl:
        'https://images.unsplash.com/photo-1615485290382-441e4d049cb5?auto=format&fit=crop&w=800&q=80',
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
    partsUsed: ['Dried roots', 'Root powder', 'Leaves (less common)'],
    sideEffects: [
      'Large doses can cause gastrointestinal upset, diarrhea, and nausea',
      'May cause excessive sedation when combined with CNS depressants',
      'Rare: thyroid overstimulation in hyperthyroid individuals',
    ],
    precautions: [
      'Use standardized root extracts (2.5–5% withanolides) for consistent dosing',
      'Avoid in autoimmune conditions (lupus, RA) without physician clearance',
      'Discontinue 2 weeks before surgery due to CNS depressant interaction',
    ],
    contraindications: [
      'Pregnancy — risk of uterine contractions and potential miscarriage',
      'Hyperthyroidism — may exacerbate overactive thyroid',
      'Patients on immunosuppressants or sedative medications',
    ],
    preparationMethods:
        'Mix 1/2 to 1 teaspoon ashwagandha root powder in warm milk or water. '
        'Add honey or jaggery to taste. Drink at bedtime for best effect.',
    dosageGuidelines:
        '300–600 mg standardized root extract once or twice daily with meals; '
        'or 1/2 tsp (3–6 g) root powder in milk once daily.',
    habitat:
        'Dry subtropical and tropical regions; grows wild on dry stony hills and open wastelands '
        'across India, North Africa, and Mediterranean countries.',
    appearance:
        'Erect branching perennial shrub up to 1.5 m tall, with downy grayish-green elliptical leaves, '
        'small pale greenish-yellow bell-shaped flowers, and bright orange-red berries enclosed in papery husks.',
    plantType: 'Perennial Shrub',
    isSupportedInModel2: true,
  ),

  // ═══════════════════════════════════════════════════════════════════════════
  // 2. AYAPANA
  // ═══════════════════════════════════════════════════════════════════════════
  const Plant(
    id: 'ayapana_plant',
    commonName: 'Ayapana (Water Hemp)',
    scientificName: 'Ayapana triplinervis',
    family: 'Asteraceae (Sunflower Family)',
    vernacularNames: {
      'Hindi': 'Ayapan',
      'Bengali': 'Ayapan',
      'Malayalam': 'Ayapana',
      'Tamil': 'Ayapanai',
      'Portuguese': 'Japana',
    },
    description:
        'Ayapana is a perennial aromatic subshrub native to tropical South America and now '
        'widely naturalized across India, Southeast Asia, and tropical Africa. It is celebrated '
        'in folk medicine as a potent natural hemostatic agent, wound coagulant, digestive '
        'stimulant, and antipyretic herb. Its coumarins — ayapanin and ayapin — give the plant '
        'its distinctive aroma and therapeutic action.',
    imageUrl:
        'https://images.unsplash.com/photo-1518531933037-91b2f5f229cc?auto=format&fit=crop&w=800&q=80',
    medicinalUses: [
      'Topical styptic to arrest bleeding from fresh lacerations and wounds',
      'Relief from acute indigestion, flatulence, and stomach cramps',
      'Oral rinse to reduce bleeding gums, mouth ulcers, and stomatitis',
      'Antipyretic infusion for mild seasonal fevers and chills',
      'Wound healing and antimicrobial poultice for skin abrasions',
    ],
    healthBenefits: [
      'Ayapanin and ayapin coumarins exhibit rapid blood-clotting and hemostatic activity',
      'Demonstrates broad-spectrum antimicrobial action against skin and oral bacteria',
      'Soothes digestive hyperacidity and restores gastric motility and comfort',
      'Reduces inflammatory tissue swelling around dermal wounds',
    ],
    traditionalUses: [
      'Bruised fresh leaves squeezed directly onto bleeding cuts to arrest hemorrhage',
      'Leaf tea brewed with dry ginger and jaggery for stomach spasms and cramps',
      'Gargle prepared from boiled leaves for stomatitis and sore throats',
      'Poultice of crushed leaves applied on skin boils and infected cuts',
    ],
    activeConstituents: [
      'Ayapanin (Herniarin)',
      'Ayapin',
      'Thymohydroquinone dimethyl ether',
      'Caryophyllene',
      'Coumarins',
    ],
    partsUsed: ['Fresh leaves', 'Aerial stems', 'Whole plant'],
    sideEffects: [
      'Excessive oral intake can provoke nausea or emetic sensations in sensitive individuals',
      'High coumarin content may potentiate anticoagulant medications',
    ],
    precautions: [
      'Ensure leaves are thoroughly washed before crushing over open wounds',
      'Not a substitute for emergency sutures or trauma treatment',
      'Consult a physician before use alongside blood-thinning medications',
    ],
    contraindications: [
      'Patients on prescription anticoagulant medications (warfarin, heparin)',
      'Pregnancy — use only under medical supervision',
    ],
    preparationMethods:
        'Crush 4–6 fresh leaves to release sap for topical hemostatic application. '
        'For internal use: steep 10 g leaves in 200 ml hot water for 6 minutes, strain and drink warm.',
    dosageGuidelines:
        'Fresh leaf paste topically as needed for wounds; '
        '15–25 ml light infusion internally once daily.',
    habitat:
        'Humid tropical riverbanks, gardens, and moist forest margins in partial shade. '
        'Found across India, Sri Lanka, and tropical Asia.',
    appearance:
        'Slender reddish-purple stems with narrow lanceolate subserrate leaves and small '
        'pale purplish-white clustered flower heads. Strongly aromatic when crushed.',
    plantType: 'Perennial Aromatic Subshrub',
    isSupportedInModel2: true,
  ),

  // ═══════════════════════════════════════════════════════════════════════════
  // 3. CINNAMON
  // ═══════════════════════════════════════════════════════════════════════════
  const Plant(
    id: 'cinnamon_plant',
    commonName: 'Cinnamon (Ceylon Cinnamon)',
    scientificName: 'Cinnamomum verum',
    family: 'Lauraceae (Laurel Family)',
    vernacularNames: {
      'Hindi': 'Dalchini',
      'Sanskrit': 'Tvak / Darusita',
      'Kannada': 'Dalchini',
      'Tamil': 'Lavangapattai / Ilavangam',
      'Spanish': 'Canela',
    },
    description:
        'Ceylon Cinnamon is an aromatic evergreen tree indigenous to Sri Lanka and South India. '
        'Celebrated since antiquity as both a prized culinary spice and powerful medicine, its '
        'dried inner bark delivers potent cinnamaldehyde that confers remarkable insulin-sensitizing, '
        'antimicrobial, and antioxidant properties. True Ceylon cinnamon (Cinnamomum verum) is '
        'distinct from Cassia cinnamon in its lower coumarin content and superior safety profile.',
    imageUrl:
        'https://images.unsplash.com/photo-1509358271058-acd22cc93898?auto=format&fit=crop&w=800&q=80',
    medicinalUses: [
      'Modulation of postprandial glucose metabolism and insulin sensitivity',
      'Broad-spectrum antimicrobial protection against oral and gastrointestinal pathogens',
      'Relief from intestinal colic, bloating, and sluggish digestion',
      'Warming respiratory decongestant for winter colds and sinus congestion',
      'Anti-inflammatory and antioxidant support for metabolic health',
    ],
    healthBenefits: [
      'Cinnamaldehyde improves cellular glucose uptake by mimicking insulin receptor pathways',
      'Delivers very high ORAC antioxidant scores against cellular lipid peroxidation',
      'Inhibits pathogenic bacterial biofilm formations in oral cavities',
      'Stimulates peripheral blood circulation and thermogenic metabolic balance',
      'Proanthocyanidins support cardiovascular health and reduce LDL oxidation',
    ],
    traditionalUses: [
      'Bark decoction simmered with green tea and honey for winter chills and colds',
      'Fine bark powder dusted over oatmeal or warm milk to moderate blood sugar spikes',
      'Bark paste mixed with clove oil for temporary toothache pain relief',
      'Cinnamon stick chewed after meals as a natural breath freshener and digestive',
    ],
    activeConstituents: [
      'Cinnamaldehyde',
      'Eugenol',
      'Cinnamic acid',
      'Proanthocyanidins',
      'Linalool',
    ],
    partsUsed: ['Inner bark (quills)', 'Dried leaves', 'Volatile essential oil'],
    sideEffects: [
      'Excess consumption of Cassia varieties (high coumarin) can cause liver stress',
      'Undiluted cinnamon oil can cause dermal burning and oral blistering',
      'May lower blood sugar excessively if combined with antidiabetic drugs',
    ],
    precautions: [
      'Prefer authentic Ceylon cinnamon (Cinnamomum verum) for long-term daily intake',
      'Monitor blood glucose closely if combining with antidiabetic prescription drugs',
      'Use no more than 1–2 g per day for medicinal purposes',
    ],
    contraindications: [
      'Severe liver impairment or acute hepatitis',
      'Undiluted essential oil on mucosal membranes',
      'High-dose supplements during first trimester of pregnancy',
    ],
    preparationMethods:
        'Boil 1 small Ceylon cinnamon stick (approx 3 g) in 250 ml water for 10 minutes. '
        'Strain and add honey when warm. Alternatively, stir 1/2 tsp ground powder into warm beverage.',
    dosageGuidelines:
        '1 to 2 grams dried bark powder daily; '
        '1 cup bark tea once or twice daily. Maximum 6 g/day.',
    habitat:
        'Tropical humid lowlands with sandy, well-drained fertile soils. '
        'Cultivated commercially in Sri Lanka, India, Madagascar, and Indonesia.',
    appearance:
        'Evergreen tree up to 10–15 m tall with aromatic papery layered inner bark, '
        'glossy leathery oval leaves with 3–5 prominent longitudinal veins, and small yellow flowers.',
    plantType: 'Evergreen Spice Tree',
    isSupportedInModel2: true,
  ),

  // ═══════════════════════════════════════════════════════════════════════════
  // 4. GOTU KOLA
  // ═══════════════════════════════════════════════════════════════════════════
  const Plant(
    id: 'gotu_kola_plant',
    commonName: 'Gotu Kola (Indian Pennywort)',
    scientificName: 'Centella asiatica',
    family: 'Apiaceae (Carrot Family)',
    vernacularNames: {
      'Hindi': 'Brahmi / Mandukparni',
      'Sanskrit': 'Mandukparni / Brahmi',
      'Kannada': 'Ondelaga',
      'Tamil': 'Vallarai',
      'Sinhalese': 'Gotu Kola',
    },
    description:
        'Gotu Kola is a premier nootropic and adaptogenic creeping herb revered in Ayurveda '
        'and Traditional Chinese Medicine for over 3,000 years. Its triterpenoid saponins — '
        'asiaticoside and asiatic acid — are scientifically proven to enhance cognitive function, '
        'accelerate wound healing, repair skin, and reduce anxiety. Often called "the herb of '
        'longevity," it is used fresh in Sri Lankan cuisine and as a brain tonic across Asia.',
    imageUrl:
        'https://images.unsplash.com/photo-1518531933037-91b2f5f229cc?auto=format&fit=crop&w=800&q=80',
    medicinalUses: [
      'Enhancement of memory, concentration, and cognitive learning capacity',
      'Accelerated wound healing, scar reduction, and skin collagen regeneration',
      'Reduction of venous insufficiency, leg swelling, and varicose vein discomfort',
      'Anxiolytic adaptogenic support for chronic stress, anxiety, and mental fatigue',
      'Neuroprotection in age-related cognitive decline and neurodegenerative support',
    ],
    healthBenefits: [
      'Asiaticoside stimulates dermal collagen synthesis and accelerates epithelial wound closure',
      'Madecassoside crosses the blood-brain barrier to exert neuroprotective antioxidant effects',
      'Reduces cortisol and modulates GABA receptors to achieve natural anxiolysis',
      'Improves peripheral venous tone and microcirculatory blood flow dynamics',
      'Supports myelin sheath integrity and neurite outgrowth in neuronal research',
    ],
    traditionalUses: [
      'Fresh leaves eaten daily as a memory-enhancing brain food in Sri Lanka and South India',
      'Leaf chutney prepared with coconut and cumin as a cognitive tonic side dish',
      'Leaf paste applied on surgical scars, keloids, and chronic skin ulcers',
      'Juice consumed as a nervine tonic for epilepsy and mental weakness in Ayurveda',
    ],
    activeConstituents: [
      'Asiaticoside',
      'Madecassoside',
      'Asiatic acid',
      'Madecassic acid',
      'Brahminoside',
    ],
    partsUsed: ['Fresh aerial leaves', 'Whole plant', 'Dried leaf powder'],
    sideEffects: [
      'Rare: mild nausea, gastric upset, or headache at high doses',
      'Potential hepatotoxicity with very prolonged excessive intake',
    ],
    precautions: [
      'Limit continuous use to 6-week cycles; pause for 2 weeks before resuming',
      'Monitor liver enzymes with extended high-dose supplementation',
      'Avoid driving heavy machinery when using high doses due to mild sedative effect',
    ],
    contraindications: [
      'Existing liver disease or hepatotoxicity history',
      'Pregnancy and lactation at medicinal doses',
      'Allergy to Apiaceae (carrot/celery) family',
    ],
    preparationMethods:
        'Blend 10–15 fresh washed leaves into a chutney or smoothie. '
        'Or steep 1 tsp dried powder in 200 ml hot water for 8 minutes, strain, and drink.',
    dosageGuidelines:
        '500–1000 mg standardized extract (8–10% asiaticosides) once or twice daily; '
        '1 cup fresh leaf tea twice daily.',
    habitat:
        'Moist shaded areas, paddy field margins, river banks, and tropical garden beds '
        'with high humidity across India, Sri Lanka, Southeast Asia, and China.',
    appearance:
        'Low creeping perennial with small round to kidney-shaped bright green leaves '
        'on slender petioles, forming dense ground-covering mats with tiny pinkish-white flowers.',
    plantType: 'Creeping Perennial Herb',
    isSupportedInModel2: true,
  ),

  // ═══════════════════════════════════════════════════════════════════════════
  // 5. INSULIN PLANT
  // ═══════════════════════════════════════════════════════════════════════════
  const Plant(
    id: 'insulin_plant',
    commonName: 'Insulin Plant (Spiral Ginger)',
    scientificName: 'Chamaecostus cuspidatus',
    family: 'Costaceae (Costus Family)',
    vernacularNames: {
      'Hindi': 'Insulin Patta',
      'Kannada': 'Insulin Gida',
      'Malayalam': 'Insulin Chethi',
      'Tamil': 'Insulin Chedi',
      'Telugu': 'Insulin Moku',
    },
    description:
        'The Insulin Plant is a tropical herbaceous perennial plant famed in Indian folk medicine '
        'for its notable ability to assist in glycemic regulation and reduce post-meal blood glucose '
        'levels. The spirally arranged leaves with distinctive reddish-purple undersides make it '
        'easily recognizable. Its corosolic acid content has attracted significant research interest '
        'for diabetes management and antidiabetic support therapy.',
    imageUrl:
        'https://images.unsplash.com/photo-1518531933037-91b2f5f229cc?auto=format&fit=crop&w=800&q=80',
    medicinalUses: [
      'Supportive dietary adjuvant for Type-2 diabetic glycemic management',
      'Attenuation of postprandial glucose spikes when taken before meals',
      'Antioxidant protection against advanced glycation end-products',
      'Diuretic and mild urinary tract cleansing and soothing action',
      'Hyperlipidemia management and lipid profile improvement',
    ],
    healthBenefits: [
      'Corosolic acid stimulates cellular glucose transport and GLUT4 receptor expression',
      'Exerts protective antioxidant influence on pancreatic beta-islet cells',
      'Aids in lipid profile management and reduces oxidative liver strain',
      'Rich in natural flavonoids, triterpenoids, and bioactive minerals',
    ],
    traditionalUses: [
      'Chewing one fresh leaf thoroughly twice daily for 30 consecutive days in traditional use',
      'Sun-dried leaf powder mixed in warm water as an adjunct health beverage',
      'Juice extracted from fresh stems consumed for urinary irritation and infection',
    ],
    activeConstituents: [
      'Corosolic acid',
      'Diosgenin',
      'Quercetin',
      'Lupeol',
      'Beta-carotene',
    ],
    partsUsed: ['Fresh leaves', 'Rhizomes', 'Leaf powder (dried)'],
    sideEffects: [
      'Risk of hypoglycemia if consumed concurrently with strong pharmaceutical antidiabetic drugs',
      'Occasional mild gastric sourness if chewed on an empty stomach',
    ],
    precautions: [
      'Regularly monitor blood sugar with a glucometer when introducing this plant',
      'Never discontinue prescribed insulin or metformin without physician consultation',
      'Use only as an adjuvant — not a replacement for prescribed antidiabetic medication',
    ],
    contraindications: [
      'Hypoglycemic episodes or brittle unstable diabetes with extreme glucose swings',
      'Pregnancy and nursing women',
    ],
    preparationMethods:
        'Wash 1 mature leaf thoroughly in clean water. Chew and swallow early in the morning '
        'followed by a glass of warm water. Alternatively, dry leaves and grind to a fine powder.',
    dosageGuidelines:
        '1 fresh leaf chewed daily on an empty stomach for maintenance; '
        'never exceed 2 leaves daily.',
    habitat:
        'Shady moist tropical understories, stream banks, and humus-rich garden borders '
        'across southern India, Sri Lanka, and Southeast Asia.',
    appearance:
        'Herbaceous perennial with distinctive spiral stem arrangement, large glossy dark green '
        'oblong-lanceolate leaves with reddish-purple undersides and bright orange tubular flowers.',
    plantType: 'Perennial Rhizomatous Herb',
    isSupportedInModel2: true,
  ),

  // ═══════════════════════════════════════════════════════════════════════════
  // 6. MALABAR NUT (VASAKA)
  // ═══════════════════════════════════════════════════════════════════════════
  const Plant(
    id: 'malabar_nut',
    commonName: 'Malabar Nut (Vasaka)',
    scientificName: 'Justicia adhatoda (Adhatoda vasica)',
    family: 'Acanthaceae (Acanthus Family)',
    vernacularNames: {
      'Hindi': 'Adusa / Vasa',
      'Sanskrit': 'Vasaka / Simhasya',
      'Kannada': 'Adusoge',
      'Tamil': 'Adathodai',
      'Malayalam': 'Atalotakam',
    },
    description:
        'Malabar Nut (Vasaka) is one of the most prominent respiratory therapeutics in classical '
        'Ayurveda. Its leaves contain the alkaloid Vasicine, which served as the scientific '
        'chemical prototype for the modern pharmaceutical mucolytic drug Bromhexine. The plant '
        'is a dense evergreen shrub with large lanceolate leaves having a characteristically '
        'strong bitter odor, used across South Asia for centuries.',
    imageUrl:
        'https://images.unsplash.com/photo-1598880940371-c756e015fea1?auto=format&fit=crop&w=800&q=80',
    medicinalUses: [
      'Liquefaction and expulsion of thick bronchial mucus in chronic coughs and bronchitis',
      'Bronchodilation and soothing of asthmatic airway constriction',
      'Hemostatic support for bleeding hemorrhoids and peptic ulcers',
      'Relief from seasonal viral colds accompanied by chest congestion',
      'Anti-inflammatory treatment for pharyngitis and upper respiratory infections',
    ],
    healthBenefits: [
      'Vasicine and vasicinone exert powerful bronchodilatory and secretolytic action',
      'Accelerates tracheal mucociliary clearance of particulate irritants and pathogens',
      'Exerts significant antibacterial activity against pyogenic respiratory pathogens',
      'Possesses anti-inflammatory and mild bronchospasmolytic properties',
    ],
    traditionalUses: [
      'Fresh leaf juice blended with pure ginger juice and wild honey for stubborn cough',
      'Leaf decoction (Kashayam) simmered with black pepper for chest colds',
      'Leaf extract consumed as a traditional remedy for asthma and bronchial congestion',
    ],
    activeConstituents: [
      'Vasicine (Peganine)',
      'Vasicinone',
      'Adhatodic acid',
      'Betaine',
      'Quinazoline alkaloids',
    ],
    partsUsed: ['Mature leaves', 'Roots', 'Flowers'],
    sideEffects: [
      'Excess doses can induce mild nausea, vomiting, or gastric irritation',
      'Strong bitter taste may cause aversion; should be balanced with honey or ginger',
    ],
    precautions: [
      'Always balance with honey or ginger to soothe the intensely bitter taste',
      'Do not exceed recommended dosages; high doses may cause uterine stimulation',
    ],
    contraindications: [
      'Strictly contraindicated during pregnancy — exerts oxytocic uterine stimulation',
      'Nursing mothers should avoid without medical advice',
    ],
    preparationMethods:
        'Simmer 5–8 fresh leaves in 300 ml water until reduced to 100 ml. '
        'Strain and stir in 1 tsp wild honey and a pinch of black pepper.',
    dosageGuidelines:
        '10–20 ml leaf decoction or 5–10 ml fresh leaf juice twice daily after meals.',
    habitat:
        'Abundant across the Indian subcontinent — plains, foothills, and roadsides '
        'from the Himalayas to Sri Lanka. Grows in sunny open habitats and hedge tracts.',
    appearance:
        'Dense evergreen shrub 1–2.5 m tall with large lanceolate dark green leaves, '
        'distinctive bitter aroma, and dense white spike-like flowers resembling a lion\'s mouth.',
    plantType: 'Evergreen Medicinal Shrub',
    isSupportedInModel2: true,
  ),

  // ═══════════════════════════════════════════════════════════════════════════
  // 7. PIRANDAI (VELDT GRAPE / DEVIL'S BACKBONE)
  // ═══════════════════════════════════════════════════════════════════════════
  const Plant(
    id: 'pirandai_plant',
    commonName: 'Pirandai (Veldt Grape)',
    scientificName: 'Cissus quadrangularis',
    family: 'Vitaceae (Grape Family)',
    vernacularNames: {
      'Hindi': 'Hadjod / Hadjora',
      'Sanskrit': 'Asthisamharaka / Vajravalli',
      'Kannada': 'Mangaravalli / Pirandai',
      'Tamil': 'Pirandai',
      'Telugu': 'Nalleru / Gudhaballi',
    },
    description:
        'Pirandai (Hadjod) is a remarkable succulent climbing plant known as the "bone setter" '
        'across Ayurvedic and Siddha traditions. The Sanskrit name "Asthisamharaka" literally '
        'translates to "bone fracture healer." Its quadrangular stems are rich in calcium, '
        'phosphorus, and anabolic phytosterols that accelerate bone regeneration. Used across '
        'India for thousands of years for fractures, osteoporosis, and joint health.',
    imageUrl:
        'https://images.unsplash.com/photo-1628556270448-4d4e4148e1b1?auto=format&fit=crop&w=800&q=80',
    medicinalUses: [
      'Acceleration of bone fracture healing and mineralization',
      'Management of osteoporosis and age-related bone density loss',
      'Relief from joint pain, arthritis, and rheumatic conditions',
      'Digestive tonic and treatment of hemorrhoids (piles)',
      'Anti-obesity and metabolic syndrome management support',
    ],
    healthBenefits: [
      'Ketosterone and onosmin phytosterols stimulate osteoblast activity for bone formation',
      'Rich calcium and phosphorus content supports bone matrix mineralization',
      'Beta-sitosterol and resveratrol exert anti-inflammatory action on joint tissues',
      'Provides significant antioxidant protection against bone oxidative damage',
      'Improves fracture healing rate by 30–50% in clinical and animal studies',
    ],
    traditionalUses: [
      'Stem pieces or paste mixed with sesame oil and applied as poultice over fractures',
      'Tender stems cooked as a vegetable dish (Pirandai thuvaiyal in Tamil cuisine)',
      'Stem juice mixed with pepper and turmeric for digestive ailments and piles',
      'Dried stem powder taken with warm milk for bone strength and joint health',
    ],
    activeConstituents: [
      'Ketosterone',
      'Onosmin',
      'Beta-sitosterol',
      'Resveratrol',
      'Calcium, Phosphorus, Iron',
    ],
    partsUsed: ['Quadrangular stems', 'Young stem tips', 'Stem powder'],
    sideEffects: [
      'Raw stems have astringent and irritant oxalic acid — must be cooked or processed before use',
      'Gastrointestinal discomfort if consumed in large raw quantities',
      'Rarely: mild thyroid stimulation reported at very high supplemental doses',
    ],
    precautions: [
      'Always cook or process stems before consumption to neutralize calcium oxalate',
      'Consult physician before using as a bone fracture adjuvant with anticoagulants',
      'Start with small doses; individual tolerance varies',
    ],
    contraindications: [
      'Pregnancy — insufficient safety data; avoid at medicinal doses',
      'Known Vitaceae (grape family) allergy',
      'Pre-existing thyroid conditions at high supplement doses',
    ],
    preparationMethods:
        'Peel and chop stems; sauté with sesame oil, onion, and spices as a vegetable dish. '
        'For medicinal use: dry stem powder mixed with warm milk and turmeric.',
    dosageGuidelines:
        '500–1000 mg standardized stem extract daily; '
        'or 1/2 cup cooked stem preparation 3–4 times per week.',
    habitat:
        'Dry deciduous forests, scrublands, rocky hillsides, and village hedges across '
        'tropical Africa, India, Sri Lanka, and Southeast Asia.',
    appearance:
        'Climbing succulent vine with distinctive 4-angled (quadrangular) bright green jointed '
        'stems, small lobed leaves, and tiny greenish-red inconspicuous flowers.',
    plantType: 'Succulent Climbing Vine',
    isSupportedInModel2: true,
  ),

  // ═══════════════════════════════════════════════════════════════════════════
  // 8. ROSEMARY
  // ═══════════════════════════════════════════════════════════════════════════
  const Plant(
    id: 'rosemary_plant',
    commonName: 'Rosemary',
    scientificName: 'Salvia rosmarinus (Rosmarinus officinalis)',
    family: 'Lamiaceae (Mint Family)',
    vernacularNames: {
      'Hindi': 'Rusmari / Gulmehendi',
      'Sanskrit': 'Sinduvara (approximate)',
      'Kannada': 'Rosemary',
      'Tamil': 'Rosemary',
      'Spanish': 'Romero',
    },
    description:
        'Rosemary is a fragrant evergreen perennial shrub from the Mediterranean, renowned for '
        'its powerful cognitive-enhancing, circulatory-stimulating, and antioxidant properties. '
        'Its rosmarinic acid and carnosic acid place it among the most potent natural antioxidants '
        'known to botany. The name derives from Latin "ros marinus" meaning "dew of the sea." '
        'Used for thousands of years in cuisine, medicine, and ritual across the Mediterranean world.',
    imageUrl:
        'https://images.unsplash.com/photo-1628556270448-4d4e4148e1b1?auto=format&fit=crop&w=800&q=80',
    medicinalUses: [
      'Enhancement of memory, mental alertness, and cognitive concentration',
      'Scalp stimulation and prevention of androgenic alopecia (hair loss)',
      'Carminative digestive aid for gas, bloating, and sluggish liver function',
      'Circulatory stimulant for cold extremities and poor peripheral blood flow',
      'Antimicrobial mouth rinse for gum disease and oral bacterial control',
    ],
    healthBenefits: [
      'Carnosic acid and carnosol are powerful neuroprotective antioxidants crossing the blood-brain barrier',
      'Rosmarinic acid inhibits acetylcholinesterase to enhance cholinergic neurotransmission and memory',
      'Ursolic acid exerts anti-inflammatory action by suppressing COX-2 and NF-κB pathways',
      'Camphor and 1,8-cineole stimulate scalp microcirculation to promote hair follicle regeneration',
      'Potent antifungal and antibacterial activity against Candida and Helicobacter pylori',
    ],
    traditionalUses: [
      'Rosemary-infused olive oil massaged into scalp for hair growth and dandruff control',
      'Sprigs boiled in steam water for inhalation to clear sinuses and sharpen mental focus',
      'Infusion consumed as a digestive bitter tonic after heavy meals',
      'Aromatic bundles burned or dried to purify living spaces in Mediterranean tradition',
    ],
    activeConstituents: [
      'Rosmarinic acid',
      'Carnosic acid',
      'Ursolic acid',
      '1,8-Cineole',
      'Camphor',
    ],
    partsUsed: ['Fresh and dried leaves', 'Flowering tops', 'Essential oil'],
    sideEffects: [
      'Very large quantities may cause seizures due to high camphor content',
      'Undiluted essential oil is toxic and must never be ingested',
      'May cause skin allergies in sensitive individuals when applied topically',
    ],
    precautions: [
      'Culinary use is entirely safe; medicinal doses should stay within 4–6 g dried herb daily',
      'Epilepsy patients should avoid concentrated rosemary essential oil aromatherapy',
      'Monitor blood pressure as rosemary can mildly elevate it',
    ],
    contraindications: [
      'High-dose supplements during pregnancy — uterine stimulant at pharmacological doses',
      'Seizure disorders — high camphor concentrations may lower seizure threshold',
      'Aspirin allergy — rosmarinic acid may cross-react',
    ],
    preparationMethods:
        'Steep 1–2 fresh sprigs or 1 tsp dried leaves in 200 ml boiling water for 8 minutes. '
        'Strain and drink. For scalp: dilute essential oil 2% in carrier oil for massage.',
    dosageGuidelines:
        '1–2 cups herb tea daily; '
        'rosemary oil diluted to 2% in carrier oil for scalp massage.',
    habitat:
        'Dry, rocky Mediterranean hillsides, coastal cliffs, and well-drained alkaline limestone soils. '
        'Widely cultivated worldwide in temperate gardens.',
    appearance:
        'Woody evergreen shrub with narrow needle-like silvery-green leaves having a pungent '
        'resinous aroma, pale blue to violet-blue flowers, and grayish woody aromatic bark.',
    plantType: 'Evergreen Mediterranean Shrub',
    isSupportedInModel2: true,
  ),

  // ═══════════════════════════════════════════════════════════════════════════
  // 9. WOOD APPLE
  // ═══════════════════════════════════════════════════════════════════════════
  const Plant(
    id: 'wood_apple_plant',
    commonName: 'Wood Apple (Elephant Apple)',
    scientificName: 'Limonia acidissima',
    family: 'Rutaceae (Citrus Family)',
    vernacularNames: {
      'Hindi': 'Kaith / Kapittha',
      'Sanskrit': 'Kapittha / Danthasata',
      'Kannada': 'Belakai / Kattubel',
      'Tamil': 'Vilam Palam',
      'Malayalam': 'Vilam',
    },
    description:
        'Wood Apple (Limonia acidissima) is a hardy thorny tree bearing a distinctive woody-shelled '
        'fruit with aromatic brown pulp that has served South Asian medicine for over 3,000 years. '
        'Its sour-sweet pulp is a potent probiotic promoter, liver tonic, and digestive remedy '
        'packed with tannins, coumarins, and essential oils. The name "Elephant Apple" reflects '
        'its popularity as wild elephant food across the Indian subcontinent.',
    imageUrl:
        'https://images.unsplash.com/photo-1518531933037-91b2f5f229cc?auto=format&fit=crop&w=800&q=80',
    medicinalUses: [
      'Treatment of chronic diarrhea, dysentery, and irritable bowel syndrome',
      'Liver tonic and hepatoprotective support for jaundice and hepatitis recovery',
      'Blood sugar regulation adjuvant in diabetic dietary management',
      'Relief from peptic ulcers, gastritis, and gastric hyperacidity',
      'Appetite stimulant and digestive enzyme activator for sluggish digestion',
    ],
    healthBenefits: [
      'Rich tannin content precipitates intestinal proteins to stop secretory diarrhea',
      'Marmelosin and osthole coumarins exert hepatoprotective antioxidant liver defense',
      'Pectin and dietary fiber act as prebiotics to promote beneficial gut microbiota',
      'Vitamin C and riboflavin content assists immune function and metabolic energy',
      'Alkaloids and volatile oils reduce intestinal spasms and cramping',
    ],
    traditionalUses: [
      'Ripe pulp scooped and consumed directly or blended with jaggery as digestive chutney',
      'Dried unripe fruit powder mixed in buttermilk for acute diarrhea and dysentery',
      'Raw pulp mixed with cumin and rock salt as a liver-stimulating digestive preparation',
      'Bark and leaf decoction used as a gum and throat antiseptic gargle',
    ],
    activeConstituents: [
      'Marmelosin',
      'Osthole',
      'Tannins',
      'Pectin',
      'Limonene',
      'Vitamin C',
    ],
    partsUsed: ['Ripe and unripe fruit pulp', 'Leaves', 'Bark', 'Roots'],
    sideEffects: [
      'Excessive consumption of raw pulp may worsen constipation due to very high tannin content',
      'Unripe fruit in large quantities can cause gastric discomfort',
    ],
    precautions: [
      'Prefer ripe fruit for nutritional use; use dried unripe fruit only medicinally for diarrhea',
      'Moderate intake in individuals with chronic constipation',
    ],
    contraindications: [
      'Severe constipation — high tannin content may worsen obstipation',
      'Known Rutaceae (citrus family) allergy',
    ],
    preparationMethods:
        'Break open the hard shell, scoop ripe pulp, and blend with water and jaggery into a sherbet. '
        'Or dry unripe fruit slices in sun and powder for medicinal use.',
    dosageGuidelines:
        '1 ripe fruit serving daily as a health food; '
        '1–2 tsp dried fruit powder twice daily for diarrhea control.',
    habitat:
        'Dry deciduous forests, scrublands, and semi-arid plains of India, Sri Lanka, '
        'and Southeast Asia. Often found in temple gardens and rural homesteads.',
    appearance:
        'Medium deciduous thorny tree with pinnate compound leaves, small white flowers, '
        'and distinctive woody rounded grey-brown fruits with an extremely hard shell '
        'and aromatic brown sticky edible pulp.',
    plantType: 'Deciduous Medicinal Tree',
    isSupportedInModel2: true,
  ),

  // ═══════════════════════════════════════════════════════════════════════════
  // 10. YLANG YLANG
  // ═══════════════════════════════════════════════════════════════════════════
  const Plant(
    id: 'ylang_ylang_plant',
    commonName: 'Ylang Ylang',
    scientificName: 'Cananga odorata',
    family: 'Annonaceae (Custard Apple Family)',
    vernacularNames: {
      'Hindi': 'Kanaanga / Sugandh Mantri',
      'Sanskrit': 'Navarasa (approximate)',
      'Kannada': 'Ylang Ylang',
      'Tamil': 'Karumugai',
      'Filipino': 'Ilang-Ilang',
    },
    description:
        'Ylang Ylang is a tropical flowering tree native to Southeast Asia whose name literally '
        'means "flower of flowers" in Tagalog. Its intensely fragrant star-shaped blossoms are '
        'steam-distilled to produce one of the world\'s most prized aromatherapeutic essential '
        'oils, revered for its anxiolytic, hypotensive, and skin-nourishing properties. '
        'The oil is a core ingredient in Chanel No. 5 perfume and extensive aromatherapy practice.',
    imageUrl:
        'https://images.unsplash.com/photo-1628556270448-4d4e4148e1b1?auto=format&fit=crop&w=800&q=80',
    medicinalUses: [
      'Aromatherapeutic anxiety reduction, nervous tension relief, and mood elevation',
      'Natural antihypertensive — lowers blood pressure through parasympathetic stimulation',
      'Aphrodisiac and sensory relaxant for emotional tension and psychosomatic complaints',
      'Topical scalp tonic to reduce hair loss, nourish follicles, and condition dry hair',
      'Antifungal and antiseptic for minor skin infections and acne management',
    ],
    healthBenefits: [
      'Linalool and benzyl acetate activate GABA-A receptors to produce anxiolytic calm',
      'Geranyl acetate reduces sympathetic nervous activity to achieve antihypertensive effects',
      'Beta-caryophyllene exerts anti-inflammatory COX-2 inhibition on skin and joints',
      'Farnesol demonstrates broad-spectrum antimicrobial action against dermal pathogens',
      'Reduces salivary cortisol in clinical aromatherapy studies for acute stress management',
    ],
    traditionalUses: [
      'Freshly picked flowers placed on beds as a traditional calming sensory ritual in Philippines',
      'Hair oil infused with ylang ylang flowers for scalp conditioning in Southeast Asia',
      'Flower garlands worn during weddings and celebrations in South and Southeast Asian cultures',
      'Diluted flower oil massaged into temples and wrists for insomnia and heart palpitations',
    ],
    activeConstituents: [
      'Linalool',
      'Benzyl acetate',
      'Geranyl acetate',
      'Farnesol',
      'Beta-caryophyllene',
    ],
    partsUsed: ['Fresh flowers', 'Essential oil (steam-distilled)'],
    sideEffects: [
      'Headache or nausea with prolonged high-concentration inhalation in enclosed spaces',
      'Contact dermatitis or allergic sensitization from undiluted essential oil on skin',
    ],
    precautions: [
      'Always dilute essential oil to 1–2% maximum in a carrier oil before skin application',
      'Diffuse for limited 20–30 minute sessions; ventilate room during aromatherapy',
      'Avoid in low blood pressure patients due to hypotensive effects',
    ],
    contraindications: [
      'Hypotension — may cause excessive blood pressure drop with antihypertensive drugs',
      'Known sensitivity to Annonaceae plant family or tropical flower allergens',
    ],
    preparationMethods:
        'Add 2–3 drops essential oil to 1 tablespoon carrier oil for topical use. '
        'Diffuse 3–4 drops in 100 ml water for aromatherapy.',
    dosageGuidelines:
        'Topical 1–2% dilution applied twice daily; '
        'aromatherapy diffusion for 20–30 minutes per session.',
    habitat:
        'Tropical lowland rainforests, humid coastal regions, and cultivated gardens '
        'of the Philippines, Indonesia, Malaysia, and South Asia.',
    appearance:
        'Medium to large tropical tree with pendulous drooping branches, glossy oval leaves, '
        'and distinctive star-shaped long-petaled fragrant flowers in greenish-yellow '
        'to deep golden-yellow hues.',
    plantType: 'Tropical Flowering Tree',
    isSupportedInModel2: true,
  ),
];
