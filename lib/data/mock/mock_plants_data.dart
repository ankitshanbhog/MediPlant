import '../models/plant_model.dart';

/// Full comprehensive database of all 20 medicinal plants supported in the MediPlant ML pipeline
final List<Plant> mockPlants = [
  const Plant(
    id: 'aloe_vera_plant',
    commonName: 'Aloe Vera',
    scientificName: 'Aloe barbadensis miller',
    family: 'Asphodelaceae',
    vernacularNames: {
      'Hindi': 'Ghritkumari',
      'Sanskrit': 'Kumari',
      'Kannada': 'Lolisara',
      'Tamil': 'Kathalai',
      'Spanish': 'Sábila',
    },
    description:
        'Aloe Vera is a stemless or very short-stemmed succulent plant known worldwide for thick, fleshy leaves laden with soothing mucilaginous gel containing acemannan, anthraquinones, vitamins, and minerals.',
    imageUrl:
        'https://images.unsplash.com/photo-1596547609652-9cf5d8d76921?auto=format&fit=crop&w=800&q=80',
    medicinalUses: [
      'Rapid cooling relief for thermal burns, sunburns, and cutaneous erythema',
      'Hydration and repair of dry, compromised epidermal skin barriers',
      'Alkalizing gastrointestinal support for mild reflux and gastritis',
      'Topical scalp nutrition to soothe dandruff and pruritus',
    ],
    healthBenefits: [
      'Stimulates dermal collagen synthesis and cellular re-epithelialization',
      'Supplies acemannan polysaccharide for natural tissue soothing',
      'Provides antioxidant protection via vitamins A, C, and E',
      'Assists digestive mucosal comfort when properly processed',
    ],
    traditionalUses: [
      'Fresh split leaf gel applied topically to heat rashes and cuts',
      'Inner clear gel washed and mixed with water as a cooling morning draught',
      'Used as a soothing herbal conditioner for hair luster and scalp health',
    ],
    activeConstituents: ['Acemannan', 'Aloin', 'Bradykinase', 'Salicylic acid', 'Barbaloin'],
    partsUsed: ['Inner clear leaf gel', 'Leaf fillet'],
    sideEffects: [
      'Raw yellow outer latex (aloin) can induce sharp abdominal cramps and diarrhea',
      'Excess oral consumption of unpurified leaf extract may cause potassium depletion',
    ],
    precautions: [
      'Always wash off yellow exudate beneath the rind when extracting gel',
      'Perform a localized forearm patch test prior to facial application',
    ],
    contraindications: [
      'Inflammatory bowel conditions (Crohn\'s, ulcerative colitis) for oral latex',
      'Pregnancy and lactation for concentrated inner latex resins',
    ],
    preparationMethods:
        'Slice leaf margin spikes, discard yellow bitter sap, scoop inner translucent fillet, and rinse with cold water before blending.',
    dosageGuidelines: 'Apply gel topically 2-3 times daily. Ingest 15-30 ml purified juice if instructed.',
    habitat: 'Arid, subtropical, and tropical climates; prefers sandy, well-drained sunny soils.',
    appearance:
        'Thick, rosette-forming fleshy green lanceolate leaves with serrated margins bearing small soft white spines.',
    plantType: 'Succulent Herb',
    isSupportedInModel2: true,
  ),
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
        'Ayapana is a perennial aromatic subshrub native to tropical America and naturalized across India. It is famous in folk medicine as a potent natural hemostatic agent, wound coagulant, and digestive stimulant.',
    imageUrl:
        'https://images.unsplash.com/photo-1518531933037-91b2f5f229cc?auto=format&fit=crop&w=800&q=80',
    medicinalUses: [
      'Topical styptic to stop superficial bleeding in fresh lacerations',
      'Relief from acute indigestion, flatulence, and stomach cramps',
      'Oral rinse to reduce bleeding gums, gingival swelling, and mouth ulcers',
      'Antipyretic infusion for mild seasonal fevers and chills',
    ],
    healthBenefits: [
      'Ayapanin and ayapin coumarins exhibit rapid blood clotting and hemostatic activity',
      'Demonstrates antimicrobial action against skin and oral bacteria',
      'Soothes digestive hyperacidity and restores gastric motility',
      'Reduces inflammatory tissue swelling around dermal wounds',
    ],
    traditionalUses: [
      'Bruised fresh leaves squeezed directly onto bleeding cuts to arrest hemorrhage',
      'Leaf tea brewed with dry ginger and jaggery taken for stomach spasms',
      'Gargle prepared from boiled leaves for stomatitis and sore throats',
    ],
    activeConstituents: ['Ayapanin (Herniarin)', 'Ayapin', 'Thymohydroquinone dimethyl ether', 'Caryophyllene'],
    partsUsed: ['Fresh leaves', 'Aerial stems'],
    sideEffects: [
      'Excessive oral intake can provoke nausea or emetic sensations in sensitive stomachs',
    ],
    precautions: [
      'Ensure leaves are thoroughly washed before crushing over open wounds',
      'Not a substitute for emergency sutures or trauma treatment',
    ],
    contraindications: [
      'Patients on prescription anticoagulant medications (due to coumarin content)',
    ],
    preparationMethods:
        'Crush 4-6 fresh leaves to release sap for topical application, or steep 10g leaves in 200ml hot water for 6 minutes.',
    dosageGuidelines: 'Fresh leaf paste topically as needed; 15-25 ml light infusion internally.',
    habitat: 'Humid tropical riverbanks, gardens, and moist forest margins in partial shade.',
    appearance:
        'Slender reddish-purple stems with narrow lanceolate subserrate leaves and small pale purplish-white flower heads.',
    plantType: 'Perennial Subshrub',
    isSupportedInModel2: true,
  ),
  const Plant(
    id: 'bryophyllum_plant',
    commonName: 'Bryophyllum (Life Plant)',
    scientificName: 'Bryophyllum pinnatum (Kalanchoe pinnata)',
    family: 'Crassulaceae (Stonecrop Family)',
    vernacularNames: {
      'Hindi': 'Patharchatta / Zakhm-e-hayat',
      'Sanskrit': 'Asthibhaksha / Parnabeeja',
      'Kannada': 'Gannu Soppu / Hebbe Soppu',
      'Tamil': 'Ranakalli / Malkangani',
      'Bengali': 'Patharkuchi',
    },
    description:
        'Bryophyllum, known as the Life Plant or Miracle Leaf, is a remarkable succulent perennial celebrated in tropical folk medicine for its extraordinary wound healing, anti-inflammatory, and kidney stone dissolving properties. Its plantlets sprout from leaf margins giving it the "life plant" name.',
    imageUrl:
        'https://images.unsplash.com/photo-1518531933037-91b2f5f229cc?auto=format&fit=crop&w=800&q=80',
    medicinalUses: [
      'Topical healing of cuts, burns, boils, insect stings, and infected wounds',
      'Dissolving kidney and urinary tract stones (nephrolithiasis)',
      'Relief from earache by instilling warmed leaf juice into the ear canal',
      'Antihypertensive support and blood pressure normalization',
      'Antipyretic treatment for malarial and intermittent fevers',
    ],
    healthBenefits: [
      'Bufadienolide compounds provide strong anti-inflammatory and wound healing actions',
      'Flavonoids inhibit calcium oxalate crystal formation to combat kidney stones',
      'Significant antibacterial potency against Staphylococcus and E. coli infections',
      'Analgesic properties to relieve localized pain and swelling',
      'Antifungal defense against dermal mycotic infections',
    ],
    traditionalUses: [
      'Warmed fresh leaf applied as a poultice directly on boils, abscesses, and wounds',
      'Leaf juice drops instilled gently into painful ears for earache relief',
      'Freshly extracted leaf juice mixed with black pepper powder consumed for kidney stones',
      'Juice of leaves given with honey for cough and bronchial irritation',
    ],
    activeConstituents: ['Bufadienolides', 'Bryophyllin A', 'Quercetin', 'Kaempferol', 'Malic acid'],
    partsUsed: ['Fresh leaves', 'Leaf juice'],
    sideEffects: [
      'Cardiac bufadienolides can be toxic at high doses; avoid excess internal consumption',
      'May cause mild gastric discomfort in sensitive individuals',
    ],
    precautions: [
      'Use externally or in very small controlled oral doses only',
      'Not for children without professional guidance',
    ],
    contraindications: [
      'Cardiac glycoside sensitivity or existing heart rhythm disorders',
      'Pregnancy — contains oxytocic compounds that may stimulate uterine contractions',
    ],
    preparationMethods:
        'Warm 2-3 leaves gently, crush, and apply as a poultice; or extract juice from 4-5 fresh leaves and dilute before use.',
    dosageGuidelines: 'Topically as needed; 1-2 tsp fresh leaf juice internally once daily, briefly.',
    habitat: 'Humid tropical and subtropical regions, rocky roadsides, garden margins, and waste grounds.',
    appearance:
        'Succulent perennial with fleshy scalloped oval leaves that sprout miniature plantlets along their margins; bell-shaped pendant orange-red flowers.',
    plantType: 'Succulent Perennial',
    isSupportedInModel2: true,
  ),
  const Plant(
    id: 'cinnamon_plant',
    commonName: 'Cinnamon (Ceylon Cinnamon)',
    scientificName: 'Cinnamomum verum',
    family: 'Lauraceae (Laurel Family)',
    vernacularNames: {
      'Hindi': 'Dalchini',
      'Sanskrit': 'Tvak / Darusita',
      'Kannada': 'Dalchini',
      'Tamil': 'Lavangapattai',
      'Spanish': 'Canela',
    },
    description:
        'Cinnamon is an aromatic evergreen tree indigenous to South Asia. Celebrated since antiquity as both spice and medicine, its dried inner bark delivers potent cinnamaldehyde with remarkable insulin-sensitizing and antioxidant properties.',
    imageUrl:
        'https://images.unsplash.com/photo-1509358271058-acd22cc93898?auto=format&fit=crop&w=800&q=80',
    medicinalUses: [
      'Modulation of postprandial glucose metabolism and insulin sensitivity',
      'Broad-spectrum antimicrobial protection against oral and gastrointestinal pathogens',
      'Relief from intestinal colic, bloating, and sluggish digestion',
      'Warming respiratory decongestant for winter colds and sinus chills',
    ],
    healthBenefits: [
      'Cinnamaldehyde improves cellular glucose uptake by mimicking insulin pathways',
      'Delivers very high ORAC antioxidant scores against cellular lipid peroxidation',
      'Inhibits pathogenic bacterial biofilm formations in oral cavities',
      'Stimulates peripheral blood circulation and thermogenic metabolic balance',
    ],
    traditionalUses: [
      'Bark decoction simmered with green tea and honey for winter chills and colds',
      'Fine bark powder dusted over oatmeal or milk to moderate blood sugar spikes',
      'Bark paste mixed with clove oil for temporary toothache soothing',
    ],
    activeConstituents: ['Cinnamaldehyde', 'Eugenol', 'Cinnamic acid', 'Proanthocyanidins'],
    partsUsed: ['Inner bark', 'Dried leaves', 'Volatile essential oil'],
    sideEffects: [
      'Excess consumption of Cassia varieties (high coumarin) can cause liver stress',
      'Undiluted cinnamon oil can cause dermal burning and oral blistering',
    ],
    precautions: [
      'Prefer authentic Ceylon cinnamon (Cinnamomum verum) for long-term daily intake',
      'Monitor blood glucose closely if combining with antidiabetic prescription drugs',
    ],
    contraindications: [
      'Severe liver impairment or acute hepatitis',
      'Undiluted essential oil on mucosal membranes',
    ],
    preparationMethods:
        'Boil 1 small bark stick (approx 3g) in 250ml water for 10 minutes, or stir 1/2 tsp ground powder into warm beverage.',
    dosageGuidelines: '1 to 2 grams dried bark powder daily; 1 cup bark tea once or twice daily.',
    habitat: 'Tropical rainforests and wet lowlands with sandy humid soil.',
    appearance:
        'Evergreen tree with aromatic papery layered inner bark, glossy leathery oval leaves with 3-5 prominent longitudinal veins.',
    plantType: 'Evergreen Tree',
    isSupportedInModel2: true,
  ),
  const Plant(
    id: 'clocimum_plant',
    commonName: 'Clocimum (Clove-Scented Basil)',
    scientificName: 'Ocimum gratissimum',
    family: 'Lamiaceae (Mint Family)',
    vernacularNames: {
      'Hindi': 'Ram Tulsi / Ban Tulsi',
      'Sanskrit': 'Vriddhatulasi / Ajaka',
      'Kannada': 'Kaadu Tulasi',
      'Tamil': 'Elumicham Thulasi',
      'English': 'African Basil / Clove Basil',
    },
    description:
        'Clocimum is a high-eugenol chemotype of Ocimum gratissimum bred for industrial and herbal clove-scented therapeutic applications. It combines the robust antimicrobial properties of clove with the adaptogenic vitality of basil.',
    imageUrl:
        'https://images.unsplash.com/photo-1615485290382-441e4d049cb5?auto=format&fit=crop&w=800&q=80',
    medicinalUses: [
      'Relief from oral toothache, gingival pain, and halitosis',
      'Steam inhalation decongestant for stubborn bronchitis and sinusitis',
      'Antimicrobial wash for fungal skin conditions and tinea versicolor',
      'Spasmolytic relief for flatulent intestinal colic and nausea',
    ],
    healthBenefits: [
      'Eugenol concentration provides significant local analgesic and antiseptic effect',
      'Suppresses respiratory bacterial strains and loosens congested airway mucus',
      'Provides high antioxidant phenolic capacity to fight free radicals',
      'Acts as a potent natural insect deterrent and mosquito repellent',
    ],
    traditionalUses: [
      'Leaves boiled in steam water for deep pulmonary clearing during heavy colds',
      'Warm leaf juice instilled near painful gum margins to blunt nerve sensitivity',
      'Decoction taken with black pepper for chronic malarial and intermittent fevers',
    ],
    activeConstituents: ['Eugenol (up to 70%)', 'Thymol', 'Ocimene', 'Germacrene-D', 'Linalool'],
    partsUsed: ['Fresh leaves', 'Flowering tops', 'Essential oil'],
    sideEffects: [
      'High concentrations may cause transient oral numbness or mild stomach warmth',
    ],
    precautions: [
      'Do not ingest undiluted concentrated oil without professional direction',
      'Patch test skin before using full-strength leaf extract',
    ],
    contraindications: [
      'Patients taking blood-thinning therapies (due to antiplatelet eugenol activity)',
    ],
    preparationMethods:
        'Infuse 4-5 bruised fresh leaves in boiling water for 5 minutes, or crush fresh leaves for steam inhalation.',
    dosageGuidelines: '1 cup of leaf infusion twice daily; steam inhalation 5 minutes once daily.',
    habitat: 'Tropical and subtropical plains, sunny waste grounds, and cultivated herbal gardens.',
    appearance:
        'Erect aromatic woody-based perennial herb with ovate-elliptical coarsely toothed leaves that release an intense clove fragrance when crushed.',
    plantType: 'Woody Perennial Herb',
    isSupportedInModel2: true,
  ),
  const Plant(
    id: 'garden_rue_plant',
    commonName: 'Garden Rue (Herb of Grace)',
    scientificName: 'Ruta graveolens',
    family: 'Rutaceae (Citrus Family)',
    vernacularNames: {
      'Hindi': 'Sadab / Satari',
      'Sanskrit': 'Somalatha / Sadapaha',
      'Kannada': 'Nagadali',
      'Tamil': 'Aruvadam',
      'Spanish': 'Ruda',
    },
    description:
        'Garden Rue is a strong-scented blue-green subshrub historically termed "Herb of Grace". It is a classic traditional bitter antispasmodic and vascular tonic, rich in the bioflavonoid Rutin which supports capillary integrity.',
    imageUrl:
        'https://images.unsplash.com/photo-1509358271058-acd22cc93898?auto=format&fit=crop&w=800&q=80',
    medicinalUses: [
      'Support for venous fragility, varicose veins, and capillary weakness',
      'Antispasmodic relief for menstrual cramping and delayed menses',
      'Topical compress for sprains, joint swellings, and athletic contusions',
      'Mild parasitic deterrent and insect repellent in traditional medicine',
    ],
    healthBenefits: [
      'Rutin bioflavonoid strengthens microvascular endothelium and reduces capillary permeability',
      'Relaxes smooth involuntary muscle fibers in reproductive and digestive systems',
      'Provides bitter digestive stimulation and bile flow support',
      'Exhibits antifungal and antiparasitic phenolic mechanisms',
    ],
    traditionalUses: [
      'Diluted external poultice applied over closed joint strains and bruised ligaments',
      'Folk aromatic bundle hung in rooms to ward off insects and contagion',
      'Regulated small herbal infusion consumed for spasmodic amenorrhea',
    ],
    activeConstituents: ['Rutin', 'Arborinine', 'Graveoline', 'Furanocoumarins (Bergapten)', 'Skimmianine'],
    partsUsed: ['Leaves', 'Aerial shoots'],
    sideEffects: [
      'Contact with fresh plant sap in sunlight causes severe phytophotodermatitis and blisters',
      'Overdose can cause violent gastroenteritis, uterine spasms, and liver damage',
    ],
    precautions: [
      'Wear gloves when handling fresh plants in strong sunlight to prevent photodermatitis',
      'Strictly avoid recreational or unmeasured oral self-administration',
    ],
    contraindications: [
      'Absolute contraindication in pregnancy (potent abortifacient and uterine stimulant)',
      'Renal disease, liver disorders, and children under 16',
    ],
    preparationMethods:
        'Use solely in standardized professional herbal formulations or very weak external compresses under expert care.',
    dosageGuidelines: 'External compress only; internal therapy restricted to certified phytomedicine prescriptions.',
    habitat: 'Dry stony Mediterranean soils, limestone gravel hills, and sunny herb borders.',
    appearance:
        'Evergreen subshrub with deeply pinnatisect blue-green glaucous foliage, yellow four-petaled flowers, and a pungent acrid herbal aroma.',
    plantType: 'Evergreen Subshrub',
    isSupportedInModel2: true,
  ),
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
      'Malayalam': 'Kudangal',
    },
    description:
        'Gotu Kola is a premier nootropic and adaptogenic herb revered in Ayurveda and Traditional Chinese Medicine for millennia. Its triterpenoid saponins (asiaticoside, asiatic acid) are scientifically proven to enhance cognitive function, accelerate wound healing, and reduce anxiety.',
    imageUrl:
        'https://images.unsplash.com/photo-1518531933037-91b2f5f229cc?auto=format&fit=crop&w=800&q=80',
    medicinalUses: [
      'Enhancement of memory, concentration, and cognitive learning capacity',
      'Accelerated wound healing, scar reduction, and skin collagen regeneration',
      'Reduction of venous insufficiency, leg swelling, and varicose vein discomfort',
      'Anxiolytic adaptogenic support for chronic stress, anxiety, and mental fatigue',
      'Neuroprotection in age-related cognitive decline and neurodegenerative conditions',
    ],
    healthBenefits: [
      'Asiaticoside stimulates dermal collagen synthesis and accelerates epithelial wound closure',
      'Madecassoside crosses the blood-brain barrier to exert neuroprotective antioxidant effects',
      'Reduces cortisol and modulates GABA receptors to achieve natural anxiolysis',
      'Improves peripheral venous tone and microcirculatory blood flow dynamics',
      'Supports myelin sheath integrity and neurite outgrowth in neuronal cells',
    ],
    traditionalUses: [
      'Fresh leaves eaten daily as a memory-enhancing brain food in Sri Lanka and India',
      'Leaf chutney prepared with coconut and cumin as a cognitive tonic side dish',
      'Leaf paste applied on surgical scars, keloids, and chronic skin ulcers',
      'Juice consumed as a nervine tonic for epilepsy and mental weakness in Ayurveda',
    ],
    activeConstituents: ['Asiaticoside', 'Madecassoside', 'Asiatic acid', 'Madecassic acid', 'Brahminoside'],
    partsUsed: ['Fresh aerial leaves', 'Whole plant', 'Dried leaf powder'],
    sideEffects: [
      'Rare: mild nausea, gastric upset, or headache at high doses',
      'Potential hepatotoxicity with very prolonged excessive intake',
    ],
    precautions: [
      'Limit continuous use to 6-week cycles; pause for 2 weeks before resuming',
      'Monitor liver enzymes with extended high-dose supplementation',
    ],
    contraindications: [
      'Existing liver disease or hepatotoxicity history',
      'Pregnancy and lactation at medicinal doses',
    ],
    preparationMethods:
        'Blend 10-15 fresh leaves into a chutney or smoothie; or steep 1 tsp dried powder in hot water for 8 minutes.',
    dosageGuidelines: '500-1000 mg standardized extract once or twice daily; 1 cup leaf tea twice daily.',
    habitat: 'Moist shaded areas, paddy field margins, river banks, and tropical garden beds with high humidity.',
    appearance:
        'Low creeping perennial with small round to kidney-shaped bright green leaves on slender petioles, forming dense ground-covering mats with tiny pinkish-white flowers.',
    plantType: 'Creeping Perennial Herb',
    isSupportedInModel2: true,
  ),
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
      'Spanish': 'Caña Agria',
    },
    description:
        'The Insulin Plant is a tropical herbaceous plant famed in Indian and South American folk medicine for its notable ability to assist in glycemic regulation and reduce post-meal blood glucose levels.',
    imageUrl:
        'https://images.unsplash.com/photo-1518531933037-91b2f5f229cc?auto=format&fit=crop&w=800&q=80',
    medicinalUses: [
      'Supportive dietary adjuvant for Type-2 diabetic glycemic management',
      'Helps attenuate postprandial glucose spikes when taken before meals',
      'Provides antioxidant protection against advanced glycation end-products',
      'Diuretic and mild urinary tract cleansing action',
    ],
    healthBenefits: [
      'Contains corosolic acid which stimulates cellular glucose transport and GLUT4 expression',
      'Exerts protective antioxidant influence on pancreatic beta-islet cells',
      'Aids in lipid profile management and reduces oxidative liver strain',
      'Rich in natural flavonoids, triterpenoids, and bioactive minerals',
    ],
    traditionalUses: [
      'Chewing one fresh leaf thoroughly twice daily for 30 consecutive days',
      'Sun-dried leaf powder mixed in warm water as an adjunct health beverage',
      'Juice extracted from fresh stems consumed for urinary irritation',
    ],
    activeConstituents: ['Corosolic acid', 'Diosgenin', 'Quercetin', 'Lupeol', 'Beta-carotene'],
    partsUsed: ['Fresh leaves', 'Rhizomes'],
    sideEffects: [
      'Risk of hypoglycemia if consumed concurrently with strong pharmaceutical antidiabetic drugs',
      'Occasional mild gastric sourness if chewed on an empty stomach',
    ],
    precautions: [
      'Regularly monitor blood sugar with a glucometer when introducing this plant',
      'Never discontinue prescribed insulin or metformin without physician consultation',
    ],
    contraindications: [
      'Hypoglycemic episodes or brittle unstable diabetes',
      'Pregnancy and nursing women',
    ],
    preparationMethods:
        'Wash 1 mature leaf thoroughly, chew and swallow early in the morning, followed by a glass of warm water.',
    dosageGuidelines: '1 fresh leaf chewed daily for maintenance; never exceed 2 leaves daily.',
    habitat: 'Shady moist tropical understories, stream banks, and humus-rich garden borders.',
    appearance:
        'Herbaceous perennial with spiral stem arrangement, large glossy dark green oblong-lanceolate leaves with reddish-purple undersides and bright orange flowers.',
    plantType: 'Perennial Herb',
    isSupportedInModel2: true,
  ),
  const Plant(
    id: 'makandi_beru_plant',
    commonName: 'Makandi Beru (Coleus)',
    scientificName: 'Coleus barbatus (Plectranthus barbatus)',
    family: 'Lamiaceae (Mint Family)',
    vernacularNames: {
      'Hindi': 'Makandi / Patharchur',
      'Sanskrit': 'Makandi / Gandira',
      'Kannada': 'Makandi Beru',
      'Marathi': 'Mainmula',
      'English': 'Forskolin Plant / Indian Coleus',
    },
    description:
        'Makandi Beru is an Ayurvedic aromatic perennial herb native to subtropical India. Its tuberous roots are the primary natural source of Forskolin, a diterpene that directly stimulates intracellular cyclic AMP (cAMP) production.',
    imageUrl:
        'https://images.unsplash.com/photo-1598880940371-c756e015fea1?auto=format&fit=crop&w=800&q=80',
    medicinalUses: [
      'Cardiovascular support and natural blood pressure regulation',
      'Bronchodilation and airway relaxation in mild respiratory constriction',
      'Assists metabolic fat mobilization and cellular lipolysis',
      'Supports healthy intraocular pressure in glaucoma research',
    ],
    healthBenefits: [
      'Forskolin activates adenylate cyclase, elevating intracellular cAMP without beta-receptor fatigue',
      'Relaxes smooth muscle tissue in bronchial passages and peripheral vascular walls',
      'Promotes thyroid hormone secretion and metabolic energy utilization',
      'Aids digestive secretions and relieves intestinal spasmodic tension',
    ],
    traditionalUses: [
      'Pickled fresh aromatic roots consumed with meals as a digestive appetizer',
      'Root decoction prepared for hypertension and cardiac heartiness in folklore',
      'Crushed leaf juice taken with honey for spasmodic asthma and coughs',
    ],
    activeConstituents: ['Forskolin (Coleonol)', 'Barbatusin', 'Cariocal', 'Essential terpenes'],
    partsUsed: ['Tuberous roots', 'Leaves'],
    sideEffects: [
      'May lower blood pressure excessively if paired with antihypertensive drugs',
      'May stimulate gastric acid secretion and aggravate active peptic ulcers',
    ],
    precautions: [
      'Discontinue usage 2 weeks prior to surgical procedures due to vasodilator effects',
      'Check blood pressure regularly during supplementation',
    ],
    contraindications: [
      'Hypotension (low blood pressure)',
      'Active gastric or duodenal ulcers, and bleeding disorders',
    ],
    preparationMethods:
        'Roots dried and ground to fine powder for decoction, or standardized root extract taken in capsule form.',
    dosageGuidelines: '50-100 mg standardized root extract (10-20% forskolin) once or twice daily with food.',
    habitat: 'Dry, sunny subtropical rocky slopes, dry barren soils of peninsular India.',
    appearance:
        'Fleshy aromatic perennial herb with square stems, thick soft pubescent ovate crenate leaves, pale blue bilabiate flowers, and golden-brown tuberous roots.',
    plantType: 'Perennial Tuberous Herb',
    isSupportedInModel2: true,
  ),
  const Plant(
    id: 'malabar_nut_plant',
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
        'Malabar Nut is one of the most prominent respiratory therapeutics in classical Ayurveda. Its leaves contain the alkaloid Vasicine, which served as the scientific chemical prototype for modern pharmaceutical mucolytics.',
    imageUrl:
        'https://images.unsplash.com/photo-1598880940371-c756e015fea1?auto=format&fit=crop&w=800&q=80',
    medicinalUses: [
      'Liquefaction of thick bronchial mucus in chronic coughs and bronchitis',
      'Bronchodilation and soothing of asthmatic airway constriction',
      'Hemostatic support for bleeding hemorrhoids and peptic ulcers',
      'Relief from seasonal viral colds accompanied by chest congestion',
    ],
    healthBenefits: [
      'Vasicine and vasicinone exert powerful bronchodilatory and secretolytic action',
      'Accelerates tracheal mucociliary clearance of particulate irritants',
      'Exerts antibacterial activity against pyogenic respiratory pathogens',
      'Possesses anti-inflammatory and mild uterine contracting properties',
    ],
    traditionalUses: [
      'Fresh leaf juice blended with pure ginger juice and wild honey for stubborn cough',
      'Leaf decoction (Kashayam) simmered with black pepper for chest colds',
      'Sun-dried leaves rolled into traditional herbal cigarettes to ease asthma fits',
    ],
    activeConstituents: ['Vasicine (Peganine)', 'Vasicinone', 'Adhatodic acid', 'Betaine'],
    partsUsed: ['Mature leaves', 'Roots', 'Flowers'],
    sideEffects: [
      'Excess doses can induce mild nausea, emesis, or gastric irritation',
    ],
    precautions: [
      'Always balance with honey or ginger to soothe its intensely bitter taste',
      'Do not exceed recommended dosages',
    ],
    contraindications: [
      'Strictly contraindicated during pregnancy (exerts oxytocic uterine stimulation)',
    ],
    preparationMethods:
        'Simmer 5-8 fresh leaves in 300ml water until reduced to 100ml. Strain and stir in 1 tsp wild honey and pinch of black pepper.',
    dosageGuidelines: '10-20 ml leaf decoction or 5-10 ml fresh leaf juice twice daily after meals.',
    habitat: 'Abundant across the plains and lower Himalayan foothills in dry sunny hedge tracts.',
    appearance:
        'Dense evergreen shrub with large lanceolate dark green leaves having a characteristic bitter taste and dense white spiked flowers resembling a lion\'s mouth.',
    plantType: 'Evergreen Shrub',
    isSupportedInModel2: true,
  ),
  const Plant(
    id: 'methi_plant',
    commonName: 'Fenugreek (Methi)',
    scientificName: 'Trigonella foenum-graecum',
    family: 'Fabaceae (Legume Family)',
    vernacularNames: {
      'Hindi': 'Methi',
      'Sanskrit': 'Medhika / Dipyaka',
      'Kannada': 'Menthe',
      'Tamil': 'Vendayam',
      'Malayalam': 'Uluva',
    },
    description:
        'Fenugreek (Methi) is one of the oldest cultivated medicinal herbs with a documented history spanning over 4,000 years. Rich in the steroidal saponin diosgenin and soluble galactomannan fiber, it is a powerful glycemic regulator, galactagogue, and digestive tonic widely used across Ayurveda and Middle Eastern medicine.',
    imageUrl:
        'https://images.unsplash.com/photo-1628556270448-4d4e4148e1b1?auto=format&fit=crop&w=800&q=80',
    medicinalUses: [
      'Blood sugar regulation and insulin sensitization in Type-2 diabetes management',
      'Stimulation of breast milk production in nursing mothers (galactagogue)',
      'Relief from menstrual discomfort, PCOS-related hormonal imbalance, and dysmenorrhea',
      'Digestive tonic to relieve constipation, gastritis, and sluggish bowel motility',
      'Cholesterol reduction and cardiovascular lipid profile improvement',
    ],
    healthBenefits: [
      'Galactomannan soluble fiber slows intestinal glucose absorption and prevents sugar spikes',
      'Diosgenin modulates steroid hormone synthesis to balance testosterone and estrogen',
      'Anti-inflammatory saponins reduce arthritic joint inflammation and morning stiffness',
      'Folic acid, iron, and B6 content supports hemoglobin production and anemia recovery',
      'Mucilaginous coating protects gastric mucosa from acid erosion',
    ],
    traditionalUses: [
      'Seeds soaked overnight and consumed on an empty stomach to control blood sugar',
      'Sprouted seeds eaten raw in salads for hormonal support in women',
      'Methi paratha (flatbread with fresh leaves) eaten for digestion and lactation support',
      'Seed paste applied on hair and scalp as a conditioning anti-dandruff hair pack',
    ],
    activeConstituents: ['Diosgenin', '4-Hydroxyisoleucine', 'Trigonelline', 'Galactomannan', 'Quercetin'],
    partsUsed: ['Seeds', 'Fresh leaves', 'Sprouted seedlings'],
    sideEffects: [
      'Strong maple-syrup body odor in sweat and urine is common and harmless',
      'Excessive seed consumption can cause diarrhea and gastric cramping',
      'Mild allergic reactions in those sensitive to other legumes (chickpea cross-reactivity)',
    ],
    precautions: [
      'Avoid high-dose seeds during the first trimester of pregnancy (uterine stimulant risk)',
      'Monitor blood sugar if combining with antidiabetic medication to avoid hypoglycemia',
    ],
    contraindications: [
      'Legume allergy or peanut hypersensitivity',
      'Thyroid disorders at high supplemental doses (may interfere with thyroxine absorption)',
    ],
    preparationMethods:
        'Soak 1-2 tsp seeds overnight in water; consume seeds and water in the morning. Or steep 1 tsp seeds in hot water for 10 minutes.',
    dosageGuidelines: '5-30g seeds daily; 1 cup seed tea once or twice daily with meals.',
    habitat: 'Cultivated across India, Mediterranean, and Middle East in well-drained fertile loam soils under full sun.',
    appearance:
        'Erect annual herb with trifoliate clover-like leaflets, small creamy white to yellowish flowers, and slender curved seed pods containing amber-colored aromatic angular seeds.',
    plantType: 'Annual Leguminous Herb',
    isSupportedInModel2: true,
  ),
  const Plant(
    id: 'multi_vitamin_plant',
    commonName: 'Multi-Vitamin Plant (Chakramuni)',
    scientificName: 'Sauropus androgynus',
    family: 'Phyllanthaceae',
    vernacularNames: {
      'Hindi': 'Chakramuni / Multivitamin',
      'Kannada': 'Chakramuni',
      'Tamil': 'Thavasi Keerai',
      'Malayalam': 'Velicheera',
      'English': 'Sweet Leaf Bush / Star Gooseberry',
    },
    description:
        'Chakramuni is acclaimed as the "Multi-Vitamin Plant" due to its extraordinarily dense concentration of provitamin A, vitamin C, B-complex vitamins, iron, and complete plant protein packed within tender edible leaves.',
    imageUrl:
        'https://images.unsplash.com/photo-1596547609652-9cf5d8d76921?auto=format&fit=crop&w=800&q=80',
    medicinalUses: [
      'Nutritional replenishment for iron-deficiency anemia and fatigue',
      'Boosts systemic lactation (galactagogue) in nursing mothers',
      'Antioxidant support for ocular visual acuity and skin health',
      'General revitalizing metabolic tonic for post-illness recovery',
    ],
    healthBenefits: [
      'Packed with up to 10,000 IU of provitamin A carotenoids per 100g serving',
      'Delivers abundant natural bioavailable ascorbic acid and dietary minerals',
      'High chlorophyll and plant iron support healthy hemoglobin synthesis',
      'Encourages digestive motility through healthy dietary fiber',
    ],
    traditionalUses: [
      'Fresh leaves tossed into everyday lentils (dal) or stir-fries',
      'Fresh raw tender shoots blended with coconut milk and cumin as a nutrient broth',
      'Steamed greens given to new mothers to promote healthy lactation',
    ],
    activeConstituents: ['Provitamin A (Beta-carotene)', 'Ascorbic acid', 'Papaverine (trace)', 'Lutein', 'Iron'],
    partsUsed: ['Tender leaves', 'Young stem tips'],
    sideEffects: [
      'CRITICAL: Excessive long-term consumption of RAW leaves (unboiled juice) has been linked to pulmonary bronchiolitis obliterans in historical weight-loss abuse',
    ],
    precautions: [
      'ALWAYS COOK OR BLANCH LEAVES before regular consumption to deactivate volatile alkaloids',
      'Never consume raw concentrated juices in large daily quantities for weight loss',
    ],
    contraindications: [
      'Pre-existing obstructive pulmonary disease or lung disorders',
      'Extreme daily juicing diets',
    ],
    preparationMethods:
        'Steam, sauté, or boil tender leaves in soups, stir-fries, or dal for 5-8 minutes before eating.',
    dosageGuidelines: 'Enjoy 1/2 cup cooked greens 2-3 times per week as part of a wholesome diet.',
    habitat: 'Tropical humid climates; thrives vigorously in backyard home gardens and fence lines.',
    appearance:
        'Erect slender shrub with arching branches carrying two-ranked small oval dark green leaves with faint white variegation and tiny reddish-purple pendant flowers.',
    plantType: 'Perennial Shrub',
    isSupportedInModel2: true,
  ),
  const Plant(
    id: 'neem_plant',
    commonName: 'Neem (Indian Lilac)',
    scientificName: 'Azadirachta indica',
    family: 'Meliaceae (Mahogany Family)',
    vernacularNames: {
      'Hindi': 'Neem',
      'Sanskrit': 'Nimba / Arishta',
      'Kannada': 'Bevu',
      'Tamil': 'Vembu / Veppu',
      'Malayalam': 'Aryaveppu',
    },
    description:
        'Neem is one of the most revered trees in Indian traditional medicine, dubbed "Sarva Roga Nivarini" (curer of all ailments). Every part — bark, leaf, seed, root, and fruit — harbors potent bioactive limonoids (primarily azadirachtin) conferring unmatched antibacterial, antifungal, antiviral, and blood-purifying properties.',
    imageUrl:
        'https://images.unsplash.com/photo-1596547609652-9cf5d8d76921?auto=format&fit=crop&w=800&q=80',
    medicinalUses: [
      'Purification of blood and elimination of dermatological toxins',
      'Treatment of acne, boils, psoriasis, eczema, and fungal skin infections',
      'Natural oral hygiene — antibacterial against periodontal pathogens',
      'Malarial and intermittent fever management with bitter antipyretic action',
      'Natural pesticide and insect repellent for agricultural and personal use',
    ],
    healthBenefits: [
      'Azadirachtin and nimbidin exhibit powerful antifungal and antibacterial efficacy',
      'Modulates immunological response and enhances natural killer cell activity',
      'Quercetin and catechin provide hepatoprotective antioxidant defense',
      'Demonstrates anti-inflammatory activity comparable to ibuprofen in research models',
      'Supports glycemic control by improving peripheral insulin receptor sensitivity',
    ],
    traditionalUses: [
      'Fresh neem twigs chewed as a traditional miswak toothbrush every morning',
      'Leaves boiled for steam bath or skin wash for chickenpox and measles rashes',
      'Neem oil applied on scalp to treat lice infestation and seborrheic dandruff',
      'Bitter leaf decoction consumed during malarial seasons as prophylactic',
    ],
    activeConstituents: ['Azadirachtin', 'Nimbidin', 'Nimbin', 'Quercetin', 'Gedunin', 'Salannin'],
    partsUsed: ['Leaves', 'Bark', 'Seed oil', 'Twigs', 'Roots'],
    sideEffects: [
      'High oral doses of concentrated neem oil can cause hepatotoxicity and encephalopathy',
      'Seed oil is toxic in large quantities; never ingest undiluted neem oil',
    ],
    precautions: [
      'External use of leaf preparations is safe; restrict internal consumption to very small doses',
      'Always dilute neem oil in carrier oil (1:10 ratio) for topical skin applications',
    ],
    contraindications: [
      'Neem seed oil is STRICTLY CONTRAINDICATED in pregnancy and for infants/children under 5',
      'Organ transplant patients or those on immunosuppressive therapy',
    ],
    preparationMethods:
        'Boil 15-20 fresh leaves in 2 cups water for 10 minutes for external wash; or dry and powder leaves for capsule use.',
    dosageGuidelines: '1-2 g dried leaf powder in capsules twice daily; external wash as needed.',
    habitat: 'Tropical and subtropical semi-arid plains, roadsides, and village commons across India and Southeast Asia.',
    appearance:
        'Fast-growing deciduous tree with dense pinnate compound leaves, fragrant small white flowers, and olive-like green-yellow drupes containing a single seed.',
    plantType: 'Deciduous Tree',
    isSupportedInModel2: true,
  ),
  const Plant(
    id: 'patchouli_plant',
    commonName: 'Patchouli',
    scientificName: 'Pogostemon cablin',
    family: 'Lamiaceae (Mint Family)',
    vernacularNames: {
      'Hindi': 'Pacholi',
      'Sanskrit': 'Pacha / Sugandhivalka',
      'Kannada': 'Pacholi',
      'Tamil': 'Kadhir Pachai',
      'French': 'Patchouli',
    },
    description:
        'Patchouli is a bushy perennial aromatic herb native to tropical Asia. Famous worldwide for its deep, rich, earthy essential oil, it is revered in traditional herbalism for its antimicrobial, insect-repelling, and skin-regenerative qualities.',
    imageUrl:
        'https://images.unsplash.com/photo-1628556270448-4d4e4148e1b1?auto=format&fit=crop&w=800&q=80',
    medicinalUses: [
      'Topical treatment for fungal skin conditions, eczema, and chapped dermis',
      'Aromatherapeutic relief for nervous tension, anxiety, and mental exhaustion',
      'Natural insect repellent against moths, mosquitoes, and storage pests',
      'Antiseptic astringent for soothing minor blemishes and oily scalp dandruff',
    ],
    healthBenefits: [
      'Patchoulol sesquiterpene confers broad antifungal and antibacterial defense',
      'Stimulates cutaneous tissue regeneration and accelerates scar recovery',
      'Centering grounding aroma helps down-regulate stress-induced sympathetic drive',
      'Reduces topical inflammation and itching in allergic contact dermatitis',
    ],
    traditionalUses: [
      'Dried leaves packed between wool and silk garments to repel moths',
      'Diluted oil massaged onto temples and soles of feet for grounding calming sleep',
      'Leaf wash used for treating athlete\'s foot and stubborn cutaneous mycoses',
    ],
    activeConstituents: ['Patchoulol (Patchouli alcohol)', 'Norpatchoulenol', 'Seychellene', 'Alpha-bulnesene'],
    partsUsed: ['Sun-dried fermented leaves', 'Essential oil'],
    sideEffects: [
      'Pure undiluted essential oil can induce localized cutaneous sensitization in reactive skin',
    ],
    precautions: [
      'Always dilute essential oil to 1-2% in a carrier oil (jojoba, almond, coconut) before topical use',
      'Primarily intended for external cosmetic, dermatological, and aromatic therapy',
    ],
    contraindications: [
      'Undiluted application on broken dermal ulcers or mucosal surfaces',
    ],
    preparationMethods:
        'Dilute 2 drops of pure patchouli oil into 1 tablespoon carrier oil for skin application, or infuse dried leaves in boiling water for external wash.',
    dosageGuidelines: 'Topical diluted massage oil 1-2 times daily; diffused aromatically 15-30 minutes.',
    habitat: 'Warm, humid tropical climates in moist rich humus with dappled sunlight.',
    appearance:
        'Bushy aromatic perennial herb reaching 1 meter height, with soft ovate toothed leaves covered in fine glandular trichomes and pale pink-white flowers.',
    plantType: 'Bushy Aromatic Herb',
    isSupportedInModel2: true,
  ),
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
        'Rosemary is a fragrant evergreen perennial shrub from the Mediterranean renowned for its powerful cognitive-enhancing, circulatory stimulating, and antioxidant properties. Its rosmarinic acid and carnosic acid place it among the most potent natural antioxidants known to botany.',
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
      'Carnosic acid and carnosol are powerful neuroprotective antioxidants that cross the blood-brain barrier',
      'Rosmarinic acid inhibits acetylcholinesterase to enhance cholinergic neurotransmission and memory',
      'Ursolic acid exerts anti-inflammatory action by suppressing COX-2 and NF-κB pathways',
      'Camphor and 1,8-cineole stimulate scalp microcirculation to promote hair follicle regeneration',
      'Potent antifungal and antibacterial activity against Candida and Helicobacter pylori',
    ],
    traditionalUses: [
      'Rosemary-infused olive oil massaged into scalp for hair growth and dandruff',
      'Sprigs boiled in steam water for inhalation to clear sinuses and sharpen focus',
      'Infusion consumed as a digestive bitter tonic after heavy meals',
      'Aromatic bundles burned or dried to purify living spaces in Mediterranean tradition',
    ],
    activeConstituents: ['Rosmarinic acid', 'Carnosic acid', 'Ursolic acid', '1,8-Cineole', 'Camphor'],
    partsUsed: ['Fresh and dried leaves', 'Flowering tops', 'Essential oil'],
    sideEffects: [
      'Very large quantities may cause seizures due to high camphor content',
      'Undiluted essential oil is toxic and must never be ingested',
    ],
    precautions: [
      'Culinary use is entirely safe; medicinal doses should stay within 4-6g dried herb daily',
      'Epilepsy patients should avoid concentrated rosemary essential oil aromatherapy',
    ],
    contraindications: [
      'High-dose supplements during pregnancy (uterine stimulant at pharmacological doses)',
      'Seizure disorders — high camphor concentrations may lower seizure threshold',
    ],
    preparationMethods:
        'Steep 1-2 fresh sprigs or 1 tsp dried leaves in 200ml boiling water for 8 minutes; or dilute essential oil in carrier oil for scalp massage.',
    dosageGuidelines: '1-2 cups herb tea daily; rosemary oil diluted to 2% in carrier for scalp use.',
    habitat: 'Dry, rocky Mediterranean hillsides, coastal cliffs, and well-drained alkaline limestone soils.',
    appearance:
        'Woody evergreen shrub with needle-like silvery-green leaves having a pungent resinous aroma, pale blue to violet-blue flowers, and grayish woody bark.',
    plantType: 'Evergreen Shrub',
    isSupportedInModel2: true,
  ),
  const Plant(
    id: 'sarpaghanda_plant',
    commonName: 'Sarpaghanda (Indian Snakeroot)',
    scientificName: 'Rauvolfia serpentina',
    family: 'Apocynaceae (Dogbane Family)',
    vernacularNames: {
      'Hindi': 'Chota Chand / Sarpagandha',
      'Sanskrit': 'Sarpagandha / Chandrika',
      'Kannada': 'Sutranabhi / Patala Garuda',
      'Tamil': 'Sarpagandhi',
      'Malayalam': 'Chuvanna Amalpori',
    },
    description:
        'Sarpaghanda (Indian Snakeroot) is one of the most pharmacologically significant medicinal plants in global history. Its root alkaloid reserpine was the world\'s first effective antihypertensive drug, revolutionizing cardiovascular medicine in the 1950s. It remains a critical Ayurvedic remedy for hypertension, anxiety, and snakebite treatment.',
    imageUrl:
        'https://images.unsplash.com/photo-1628556270448-4d4e4148e1b1?auto=format&fit=crop&w=800&q=80',
    medicinalUses: [
      'Antihypertensive treatment for essential and malignant hypertension',
      'Tranquilizing action for anxiety neurosis, schizophrenia, and insomnia',
      'Traditional snakebite antidote and venom-neutralizing remedy in folk medicine',
      'Sedative for psychosomatic disorders and aggressive behavioral disturbances',
      'Adjuvant in managing febrile convulsions and epilepsy in Ayurveda',
    ],
    healthBenefits: [
      'Reserpine depletes central norepinephrine and dopamine to reduce peripheral vascular resistance',
      'Ajmaline and ajmalicine exert antiarrhythmic cardiac electrophysiological action',
      'Yohimbine modulates alpha-adrenergic receptors with cardiovascular implications',
      'Root alkaloids achieve measurable sedative and central nervous system calming effects',
      'Demonstrates significant antibacterial and antifungal properties in vitro studies',
    ],
    traditionalUses: [
      'Root decoction administered under strict supervision for blood pressure crises',
      'Root powder given with milk as a sedative for insomnia and nervous excitement',
      'Fresh root paste applied on snakebite wounds in tribal folk medicine',
      'Powdered root used as a ritual purification and apotropaic charm against snakes',
    ],
    activeConstituents: ['Reserpine', 'Ajmaline', 'Ajmalicine', 'Serpentine', 'Yohimbine'],
    partsUsed: ['Dried roots', 'Root bark'],
    sideEffects: [
      'Reserpine causes severe depression, Parkinsonism, and bradycardia at therapeutic doses',
      'Nasal congestion, peptic ulceration, and gynecomastia with prolonged use',
      'Extreme hypotension when combined with other antihypertensive agents',
    ],
    precautions: [
      'STRICTLY use only under qualified Ayurvedic or allopathic physician supervision',
      'Never self-administer; drug interactions with MAOIs and cardiac medications are dangerous',
    ],
    contraindications: [
      'Depression and depressive psychoses (reserpine is a known precipitant of clinical depression)',
      'Peptic ulcers, Parkinson\'s disease, pheochromocytoma',
      'Pregnancy and breastfeeding — severely harmful to fetal and neonatal development',
    ],
    preparationMethods:
        'Root powder prepared into standardized formulations under professional Ayurvedic compounding only.',
    dosageGuidelines: 'PROFESSIONAL USE ONLY: 0.25-0.5g root powder per day maximum under physician supervision.',
    habitat: 'Moist deciduous forests, shaded hillsides, and stream banks in the foothills of the Himalayas and Eastern India.',
    appearance:
        'Perennial evergreen shrub with glossy dark green elliptic-lanceolate leaves, small pinkish-white funnel flowers, and distinctive fleshy red-to-black drupe berries.',
    plantType: 'Perennial Shrub',
    isSupportedInModel2: true,
  ),
  const Plant(
    id: 'tooth_ache_plant',
    commonName: 'Toothache Plant (Spilanthes)',
    scientificName: 'Acmella oleracea (Spilanthes acmella)',
    family: 'Asteraceae (Sunflower Family)',
    vernacularNames: {
      'Hindi': 'Akarkara / Toothache Plant',
      'Sanskrit': 'Akallaka / Akarkarabha',
      'Kannada': 'Akkal Kaddi / Dhantu',
      'Tamil': 'Akkarakaram',
      'Bengali': 'Maratica',
    },
    description:
        'The Toothache Plant (Spilanthes) is instantly identifiable by its bold yellow flower heads with red centers that release an intense tingling, numbing sensation upon contact with oral mucosa. This local anesthetic property, driven by the bioactive N-alkylamide spilanthol, makes it nature\'s most targeted oral pain reliever.',
    imageUrl:
        'https://images.unsplash.com/photo-1518531933037-91b2f5f229cc?auto=format&fit=crop&w=800&q=80',
    medicinalUses: [
      'Immediate local analgesia for acute toothache, dental pain, and gum abscesses',
      'Saliva stimulation to combat dry mouth (xerostomia) and improve oral health',
      'Oral antimicrobial rinse against gingival bacteria and Candida oral thrush',
      'Immune modulation and enhancement of innate resistance to infections',
      'Topical analgesic compress for mild joint pain and muscle soreness',
    ],
    healthBenefits: [
      'Spilanthol (N-isobutylamide) blocks sodium ion channels in nociceptive nerve fibers causing potent local anesthesia',
      'Stimulates salivary enzyme secretion to initiate proper digestive cascade',
      'Antibacterial against Streptococcus mutans (primary tooth decay pathogen)',
      'Immunostimulatory alkylamides activate macrophage and NK cell defensive responses',
      'Anti-inflammatory phenolics reduce gingival redness and periapical swelling',
    ],
    traditionalUses: [
      'Fresh flower head chewed directly on painful tooth for 2-3 minutes for instant numbness',
      'Flower and leaf tincture used as a pre-dental-visit numbing rinse',
      'Leaves added to soups and stews as a nutritious salivation-stimulating ingredient',
      'Powdered dried flowers rubbed into gum margins for periodontal pain relief',
    ],
    activeConstituents: ['Spilanthol', 'N-Isobutylamide', 'Undeca-2E,7Z,9E-trienoic acid', 'Luteolin', 'Quercetin'],
    partsUsed: ['Fresh and dried flower heads', 'Leaves', 'Whole aerial plant'],
    sideEffects: [
      'Prolonged direct contact causes temporary marked hypersalivation',
      'May cause mild mucous membrane irritation in very sensitive individuals',
    ],
    precautions: [
      'Not a substitute for professional dental treatment of abscesses or infected pulps',
      'Avoid using during pregnancy at medicinal doses due to uterotonic research concerns',
    ],
    contraindications: [
      'Known Asteraceae / Compositae flower family allergy (ragweed, chrysanthemum cross-reaction)',
      'Pregnancy in medicinal doses beyond culinary use',
    ],
    preparationMethods:
        'Chew 1-2 fresh flower heads directly; or steep 4-5 flowers in 100ml warm water for 5 minutes as an oral rinse.',
    dosageGuidelines: 'Fresh flower chewed as needed; oral rinse 2-3 times daily; tincture 1-2 ml diluted in water.',
    habitat: 'Moist tropical gardens, streamside beds, and semi-shade forest clearings in humid equatorial climates.',
    appearance:
        'Low-growing annual herb with ovate scalloped leaves and distinctive conical yellow flower heads with prominent red-orange centers on erect branching stems.',
    plantType: 'Annual Herb',
    isSupportedInModel2: true,
  ),
  const Plant(
    id: 'tulsi_plant',
    commonName: 'Holy Basil (Tulsi)',
    scientificName: 'Ocimum tenuiflorum (Ocimum sanctum)',
    family: 'Lamiaceae (Mint Family)',
    vernacularNames: {
      'Hindi': 'Tulsi',
      'Sanskrit': 'Surasa / Tulasi',
      'Kannada': 'Tulasi',
      'Tamil': 'Thulasi',
      'Spanish': 'Albahaca Sagrada',
    },
    description:
        'Tulsi, reverently called the "Queen of Herbs" and "Elixir of Life", is an aromatic perennial plant sacred across India. It is celebrated in Ayurveda as a premier adaptogen that enhances physiological, chemical, and psychological resilience.',
    imageUrl:
        'https://images.unsplash.com/photo-1615485290382-441e4d049cb5?auto=format&fit=crop&w=800&q=80',
    medicinalUses: [
      'Rapid relief from acute coughs, colds, and seasonal upper respiratory congestion',
      'Adaptogenic support to normalize cortisol and diminish psychological anxiety',
      'Immunomodulatory protection against recurrent environmental viral infections',
      'Natural oral disinfectant for reducing gingival inflammation and freshening breath',
    ],
    healthBenefits: [
      'Eugenol and rosmarinic acid modulate cellular inflammatory cascade pathways',
      'Assists in fasting blood sugar homeostasis and protects pancreatic islet cells',
      'Shields hepatic and renal organs from metabolic and oxidative stressors',
      'Improves respiratory vital lung capacity and clears airway passages',
    ],
    traditionalUses: [
      'Boiled decoction (Kadha) with black pepper and ginger taken warm for fever and flu',
      'Fresh leaf juice combined with raw honey for soothing inflamed pediatric throats',
      'Chewing 3-5 fresh clean leaves on an empty stomach every morning for vitality',
    ],
    activeConstituents: ['Eugenol', 'Rosmarinic acid', 'Ursolic acid', 'Caryophyllene', 'Apigenin'],
    partsUsed: ['Leaves', 'Seeds', 'Floral spikes', 'Stems'],
    sideEffects: [
      'May mildy slow platelet aggregation if consumed in massive concentrated medicinal doses',
      'May enhance the effect of concurrent pharmaceutical blood glucose medications',
    ],
    precautions: [
      'Discontinue high-dose concentrated extracts 2 weeks prior to major elective surgery',
      'Wash fresh leaves well to remove surface dust before eating',
    ],
    contraindications: [
      'Patients on prescription anticoagulant therapy (warfarin, heparin) without medical advice',
      'Severe hypoglycemia episodes',
    ],
    preparationMethods:
        'Steep 6-8 fresh or 1 tsp dried leaves in 200ml freshly boiled water for 6 minutes. Add a dash of raw honey and crushed black pepper.',
    dosageGuidelines: '1 to 2 cups of herbal tea daily; 5 to 10 ml of fresh leaf extract.',
    habitat: 'Tropical and subtropical lowlands, home courtyards, and warm fertile garden loam.',
    appearance:
        'Erect much-branched aromatic subshrub with purple or green hairy stems, ovate aromatic leaves with serrated edges, and purple-magenta floral spikes.',
    plantType: 'Aromatic Perennial Herb',
    isSupportedInModel2: true,
  ),
  const Plant(
    id: 'wood_apple_plant',
    commonName: 'Wood Apple (Bael / Elephant Apple)',
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
        'Wood Apple (Limonia acidissima) is a hardy thorny tree bearing a woody-shelled fruit with aromatic brown pulp that has served South Asian medicine for over 3,000 years. Its sour-sweet pulp is a potent probiotic promoter, liver tonic, and digestive remedy packed with tannins, coumarins, and essential oils.',
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
      'Raw pulp mixed with cumin and rock salt as a liver-stimulating digestive chutney',
      'Bark and leaf decoction used as a gum and throat antiseptic gargle',
    ],
    activeConstituents: ['Marmelosin', 'Osthole', 'Tannins', 'Pectin', 'Limonene', 'Vitamin C'],
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
      'Known citrus-family (Rutaceae) allergy',
    ],
    preparationMethods:
        'Break open the hard shell, scoop ripe pulp, and blend with water and jaggery into a sherbet; or dry unripe slices in sun and powder for medicinal use.',
    dosageGuidelines: '1 ripe fruit serving daily; 1-2 tsp dried fruit powder twice daily for diarrhea.',
    habitat: 'Dry deciduous forests, scrubland, and semi-arid plains of India, Sri Lanka, and Southeast Asia.',
    appearance:
        'Medium deciduous thorny tree with pinnate compound leaves, small white flowers, and distinctive woody rounded grey-brown fruits with extremely hard shell and aromatic brown sticky pulp.',
    plantType: 'Deciduous Tree',
    isSupportedInModel2: true,
  ),
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
        'Ylang Ylang is a tropical flowering tree native to Southeast Asia whose name literally means "flower of flowers" in Tagalog. Its intensely fragrant star-shaped blossoms are steam-distilled to produce one of the world\'s most prized aromatherapeutic essential oils, revered for its anxiolytic, hypotensive, and skin-nourishing properties.',
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
      'Geranyl acetate reduces sympathetic nervous activity to achieve hypotensive effects',
      'Beta-caryophyllene exerts anti-inflammatory COX-2 inhibition on skin and joints',
      'Farnesol demonstrates broad-spectrum antimicrobial action against dermal pathogens',
      'Reduces cortisol release in clinical aromatherapy studies for acute stress',
    ],
    traditionalUses: [
      'Freshly picked flowers placed on newlywed beds as a traditional sensory mood ritual',
      'Hair oil infused with ylang ylang flowers for scalp conditioning in the Philippines',
      'Flower garlands worn during celebrations in South and Southeast Asian cultures',
      'Diluted flower oil massaged into temples and wrists for insomnia and palpitations',
    ],
    activeConstituents: ['Linalool', 'Benzyl acetate', 'Geranyl acetate', 'Farnesol', 'Beta-caryophyllene'],
    partsUsed: ['Fresh flowers', 'Essential oil (steam-distilled)'],
    sideEffects: [
      'Headache or nausea with prolonged high-concentration inhalation in enclosed spaces',
      'Contact dermatitis or allergic sensitization from undiluted essential oil on skin',
    ],
    precautions: [
      'Always dilute essential oil to 1-2% maximum in a carrier oil before skin application',
      'Diffuse for limited 20-30 minute sessions; ventilate room during aromatherapy',
    ],
    contraindications: [
      'Hypotension — may cause excessive blood pressure drop when combined with antihypertensive drugs',
      'Known sensitivity to Annonaceae plant family or tropical flower allergens',
    ],
    preparationMethods:
        'Add 2-3 drops essential oil to 1 tablespoon carrier oil for topical use; diffuse 3-4 drops in 100ml water for aromatherapy.',
    dosageGuidelines: 'Topical 1-2% dilution twice daily; aromatherapy diffusion 20-30 minutes per session.',
    habitat: 'Tropical lowland rainforests, humid coastal regions, and cultivated gardens of the Philippines, Indonesia, and South Asia.',
    appearance:
        'Medium to large tropical tree with pendulous drooping branches, glossy oval leaves, and distinctive star-shaped long-petaled fragrant flowers in greenish-yellow to deep golden-yellow hues.',
    plantType: 'Tropical Flowering Tree',
    isSupportedInModel2: true,
  ),
];
