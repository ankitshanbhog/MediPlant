import '../models/remedy_model.dart';

/// Comprehensive library of verified traditional home remedies for the
/// MediPlant 10-class model plants.
///
/// All plantIds reference only the 10 supported classes:
///   ashwagandha_plant, ayapana_plant, cinnamon_plant, gotu_kola_plant,
///   insulin_plant, malabar_nut, pirandai_plant, rosemary_plant,
///   wood_apple_plant, ylang_ylang_plant
final List<Remedy> mockRemedies = [
  // ──────────────────────────────────────────────────────────────────────────
  // MALABAR NUT – Respiratory
  // ──────────────────────────────────────────────────────────────────────────
  const Remedy(
    id: 'remedy_malabar_nut_decoction',
    condition: 'Cough & Bronchial Congestion',
    title: 'Vasaka (Malabar Nut) Bronchial Expectorant',
    primaryPlantName: 'Malabar Nut (Vasaka)',
    primaryPlantScientific: 'Justicia adhatoda',
    plantId: 'malabar_nut',
    ingredients: [
      '5-6 fresh Vasaka leaves, thoroughly washed',
      '1/2 inch fresh ginger, crushed',
      '1 tsp raw honey',
      '2 cups clean water',
      'Pinch of black pepper',
    ],
    preparationSteps: [
      'Tear the Vasaka leaves roughly and place in a saucepan.',
      'Add 2 cups of water and crushed ginger.',
      'Bring to a boil then reduce to a simmer for 10-12 minutes until reduced to 1 cup.',
      'Strain through a fine strainer into a cup.',
      'Add honey and black pepper once the liquid is warm (not boiling hot).',
    ],
    howToUse:
        'Drink warm slowly. The vasicine alkaloid actively liquifies sticky bronchial mucus '
        'and expands constricted airways, providing significant relief from chest congestion.',
    dosage: '2-3 tablespoons twice daily after light food for 3-5 days.',
    precautions: [
      'Strictly contraindicated in pregnancy — Vasaka stimulates uterine contraction.',
      'Do not exceed recommended dosage as high doses may cause nausea.',
      'Consult a doctor if symptoms worsen or include blood in cough.',
    ],
    category: 'Cough',
    timeToPrepare: '15 mins',
    isEducationalOnly: true,
  ),

  // ──────────────────────────────────────────────────────────────────────────
  // CINNAMON – Respiratory / Cold
  // ──────────────────────────────────────────────────────────────────────────
  const Remedy(
    id: 'remedy_cinnamon_honey_tea',
    condition: 'Cold, Sore Throat & Blood Sugar',
    title: 'Ceylon Cinnamon & Honey Warming Infusion',
    primaryPlantName: 'Cinnamon (Ceylon)',
    primaryPlantScientific: 'Cinnamomum verum',
    plantId: 'cinnamon_plant',
    ingredients: [
      '1 small Ceylon cinnamon stick (or 1/2 tsp pure Ceylon cinnamon powder)',
      '1 cup boiling water',
      '1 tsp raw honey',
      '1 tsp fresh lemon juice',
      'Optional: 2-3 cloves',
    ],
    preparationSteps: [
      'Place cinnamon stick (or powder) in a ceramic mug.',
      'Pour 1 cup of freshly boiled water over the cinnamon.',
      'Cover with a saucer and steep for 8-10 minutes.',
      'Strain and allow to cool to a comfortable drinking temperature.',
      'Stir in fresh lemon juice and raw honey.',
    ],
    howToUse:
        'Drink slowly while warm to soothe throat tickle, stimulate circulation, '
        'and provide natural antimicrobial and blood-sugar-moderating benefits.',
    dosage: '1 cup up to 2 times daily. Use Ceylon cinnamon only for daily long-term use.',
    precautions: [
      'Use true Ceylon cinnamon rather than Cassia cinnamon to avoid high coumarin content.',
      'Avoid high doses during early pregnancy.',
      'Monitor blood sugar if taking with antidiabetic medication.',
    ],
    category: 'Cold',
    timeToPrepare: '10 mins',
    isEducationalOnly: true,
  ),

  // ──────────────────────────────────────────────────────────────────────────
  // AYAPANA – Digestive / Wound
  // ──────────────────────────────────────────────────────────────────────────
  const Remedy(
    id: 'remedy_ayapana_infusion',
    condition: 'Stomach Cramps, Indigestion & Minor Bleeding',
    title: 'Ayapana Hemostatic Leaf Decoction',
    primaryPlantName: 'Ayapana',
    primaryPlantScientific: 'Ayapana triplinervis',
    plantId: 'ayapana_plant',
    ingredients: [
      '5-6 fresh Ayapana leaves, thoroughly washed',
      '1.5 cups clean water',
      '1/2 tsp honey (optional)',
    ],
    preparationSteps: [
      'Wash the Ayapana leaves carefully in clean running water.',
      'Crush the leaves gently between your palms to release the aromatic compounds.',
      'Boil in 1.5 cups water for 5-6 minutes until the water takes a pale amber tint.',
      'Strain into a cup and allow to cool to a comfortable temperature.',
    ],
    howToUse:
        'Sip warm to alleviate stomach cramps and indigestion. '
        'For minor surface cuts, apply the cooled crushed leaf pulp directly as a traditional '
        'hemostatic poultice to help stop minor bleeding.',
    dosage: '1 cup once daily for digestive support; topical application as needed.',
    precautions: [
      'Do not use internally during pregnancy.',
      'Patients on anticoagulant medications should consult a physician before use.',
    ],
    category: 'Digestive',
    timeToPrepare: '10 mins',
    isEducationalOnly: true,
  ),

  // ──────────────────────────────────────────────────────────────────────────
  // GOTU KOLA – Cognitive / Anxiety
  // ──────────────────────────────────────────────────────────────────────────
  const Remedy(
    id: 'remedy_gotu_kola_tea',
    condition: 'Headache, Mental Fatigue & Cognitive Support',
    title: 'Gotu Kola (Mandukaparni) Clarity & Calming Tea',
    primaryPlantName: 'Gotu Kola (Indian Pennywort)',
    primaryPlantScientific: 'Centella asiatica',
    plantId: 'gotu_kola_plant',
    ingredients: [
      '8-10 fresh Gotu Kola leaves (or 1 tsp dried herb)',
      '1 cup hot water (just off the boil)',
      '1/2 tsp raw honey',
      'Pinch of black pepper (optional, enhances absorption)',
    ],
    preparationSteps: [
      'Wash fresh Gotu Kola leaves thoroughly in clean water.',
      'Bruise the leaves gently with your fingertips to release the triterpenoids.',
      'Place leaves in a cup and pour hot water over them.',
      'Cover and steep for 6-8 minutes.',
      'Strain and add honey and pepper when comfortably warm.',
    ],
    howToUse:
        'Drink in the afternoon or evening to calm nervous tension, relieve tension headaches, '
        'and enhance cognitive resilience. Regular use supports memory and mental clarity.',
    dosage: '1 cup once or twice daily. Cycle on for 6 weeks, then pause for 2 weeks.',
    precautions: [
      'Avoid high doses in liver disease or with sedative medications.',
      'Limit continuous use to 6-week cycles to protect liver.',
    ],
    category: 'Headache',
    timeToPrepare: '10 mins',
    isEducationalOnly: true,
  ),

  const Remedy(
    id: 'remedy_gotu_kola_skin_paste',
    condition: 'Skin Wound Healing & Scar Reduction',
    title: 'Gotu Kola Fresh Leaf Wound-Healing Paste',
    primaryPlantName: 'Gotu Kola (Indian Pennywort)',
    primaryPlantScientific: 'Centella asiatica',
    plantId: 'gotu_kola_plant',
    ingredients: [
      '10-12 fresh Gotu Kola leaves, washed',
      '1/2 tsp pure coconut oil or cold-pressed sesame oil',
    ],
    preparationSteps: [
      'Wash the leaves thoroughly in clean water.',
      'Grind the fresh leaves with a small amount of coconut oil into a smooth paste.',
      'Apply gently to the affected skin area.',
    ],
    howToUse:
        'Apply the fresh paste directly over minor wounds, healing scars, or irritated skin. '
        'Leave on for 20-30 minutes then rinse with cool water. '
        'Asiaticoside actively stimulates collagen synthesis for faster healing.',
    dosage: 'Apply once daily on clean skin for wound healing; twice weekly for scar reduction.',
    precautions: [
      'Perform a patch test on inner forearm before facial or sensitive area application.',
      'Do not apply to deep infected wounds without medical advice.',
    ],
    category: 'Skin',
    timeToPrepare: '5 mins',
    isEducationalOnly: true,
  ),

  // ──────────────────────────────────────────────────────────────────────────
  // INSULIN PLANT – Diabetes
  // ──────────────────────────────────────────────────────────────────────────
  const Remedy(
    id: 'remedy_insulin_leaf_chew',
    condition: 'Blood Sugar & Diabetes Support',
    title: 'Insulin Plant (Costus) Morning Glycemic Protocol',
    primaryPlantName: 'Insulin Plant (Spiral Ginger)',
    primaryPlantScientific: 'Chamaecostus cuspidatus',
    plantId: 'insulin_plant',
    ingredients: [
      '1-2 fresh mature Insulin Plant leaves',
      '1 glass lukewarm water',
    ],
    preparationSteps: [
      'Harvest 1-2 mature leaves from the plant in the morning.',
      'Wash the leaves thoroughly under running water.',
    ],
    howToUse:
        'Chew 1 fresh leaf thoroughly and slowly on an empty stomach in the morning. '
        'Follow immediately with 1 glass of lukewarm water. The corosolic acid is absorbed '
        'through the oral mucosa for best glycemic effect.',
    dosage: '1 leaf daily in morning on empty stomach. Begin with 1 leaf for 15 days, '
        'then assess blood sugar response before continuing.',
    precautions: [
      'This is a supportive natural adjuvant only. NEVER stop or reduce prescribed insulin '
      'or diabetes medications without physician guidance.',
      'Monitor blood glucose with a glucometer regularly.',
      'Risk of hypoglycemia if used alongside strong antidiabetic drugs.',
    ],
    category: 'Diabetes',
    timeToPrepare: '2 mins',
    isEducationalOnly: true,
  ),

  // ──────────────────────────────────────────────────────────────────────────
  // ASHWAGANDHA – Immunity / Stress / Energy
  // ──────────────────────────────────────────────────────────────────────────
  const Remedy(
    id: 'remedy_ashwagandha_milk',
    condition: 'Stress, Fatigue, Insomnia & Weak Immunity',
    title: 'Ashwagandha Golden Milk (Adaptogenic Night Tonic)',
    primaryPlantName: 'Ashwagandha (Indian Ginseng)',
    primaryPlantScientific: 'Withania somnifera',
    plantId: 'ashwagandha_plant',
    ingredients: [
      '1/2 tsp ashwagandha root powder (standardized)',
      '1 cup warm full-fat milk (or oat/almond milk)',
      '1/4 tsp pure turmeric powder',
      '1/4 tsp Ceylon cinnamon powder',
      '1 tsp raw honey or jaggery',
      'Pinch of black pepper (enhances withanolide absorption)',
    ],
    preparationSteps: [
      'Warm the milk gently in a saucepan on low heat (do not boil).',
      'Add ashwagandha powder, turmeric, and cinnamon.',
      'Whisk well until the powder is fully dissolved and no lumps remain.',
      'Pour into a mug and allow to cool to a comfortable temperature.',
      'Stir in honey or jaggery and a pinch of black pepper before drinking.',
    ],
    howToUse:
        'Drink warm every night 30 minutes before bedtime. The adaptogenic withanolides '
        'reduce cortisol, calm the nervous system, and promote deep restorative sleep. '
        'Consistent use over 4-8 weeks shows best results for stress reduction.',
    dosage: '1 cup nightly before bed. Continue for minimum 4-6 weeks for full adaptogenic benefit.',
    precautions: [
      'Avoid in pregnancy and hyperthyroid conditions.',
      'Discontinue 2 weeks before any scheduled surgery.',
      'Start with 1/4 tsp and gradually increase to assess tolerance.',
    ],
    category: 'Stress & Sleep',
    timeToPrepare: '5 mins',
    isEducationalOnly: true,
  ),

  // ──────────────────────────────────────────────────────────────────────────
  // ROSEMARY – Hair / Joints / Cognitive
  // ──────────────────────────────────────────────────────────────────────────
  const Remedy(
    id: 'remedy_rosemary_scalp_oil',
    condition: 'Hair Loss & Scalp Stimulation',
    title: 'Rosemary Scalp Follicle Stimulating Tonic',
    primaryPlantName: 'Rosemary',
    primaryPlantScientific: 'Salvia rosmarinus',
    plantId: 'rosemary_plant',
    ingredients: [
      '2 fresh rosemary sprigs (or 5 drops pure rosemary essential oil)',
      '2 tbsp cold-pressed jojoba or coconut oil',
    ],
    preparationSteps: [
      'If using fresh sprigs: gently bruise the rosemary between your fingers to release oils.',
      'Mix rosemary into carrier oil and warm gently in a double boiler for 20 minutes.',
      'Alternatively, if using essential oil: simply mix 5 drops into 2 tbsp carrier oil and blend well.',
      'Strain if using fresh herb and store in a clean glass bottle.',
    ],
    howToUse:
        'Part the hair and massage 8-10 drops of the oil directly into the scalp with '
        'fingertip circular motion for 5 full minutes to boost blood circulation. '
        'Leave on for a minimum of 30-60 minutes (or overnight) before washing.',
    dosage: 'Apply 2-3 times weekly for at least 3 months to see significant hair growth results.',
    precautions: [
      'Never apply undiluted rosemary essential oil directly to scalp — always dilute properly.',
      'Epilepsy patients should avoid rosemary essential oil entirely.',
    ],
    category: 'Hair & Scalp',
    timeToPrepare: '5 mins',
    isEducationalOnly: true,
  ),

  const Remedy(
    id: 'remedy_rosemary_joint_rub',
    condition: 'Joint & Muscle Aches',
    title: 'Warm Rosemary Anti-Inflammatory Joint Massage Oil',
    primaryPlantName: 'Rosemary',
    primaryPlantScientific: 'Salvia rosmarinus',
    plantId: 'rosemary_plant',
    ingredients: [
      '3 sprigs fresh rosemary, bruised',
      '1/4 cup virgin coconut or sesame oil',
    ],
    preparationSteps: [
      'Warm oil gently in a double boiler on lowest heat.',
      'Add the bruised rosemary sprigs and steep on the lowest possible heat for 20 minutes.',
      'Strain the infused oil into a clean glass jar.',
    ],
    howToUse:
        'Warm a small amount of oil between palms and massage thoroughly into stiff joints, '
        'aching knees, or fatigued muscles using firm circular strokes. '
        'The ursolic acid in rosemary inhibits COX-2 inflammatory enzymes.',
    dosage: 'Apply once daily, ideally before bathing or before bed for best absorption.',
    precautions: [
      'Ensure oil is comfortably warm, not hot, before applying to avoid burns.',
    ],
    category: 'Joint & Muscle',
    timeToPrepare: '25 mins',
    isEducationalOnly: true,
  ),

  const Remedy(
    id: 'remedy_rosemary_steam',
    condition: 'Sinus Headache & Nasal Congestion',
    title: 'Rosemary Sinus Clearing Herbal Steam Inhalation',
    primaryPlantName: 'Rosemary',
    primaryPlantScientific: 'Salvia rosmarinus',
    plantId: 'rosemary_plant',
    ingredients: [
      '2-3 fresh rosemary sprigs (or 1 tbsp dried rosemary)',
      '1 liter boiling water',
      'Clean large towel',
    ],
    preparationSteps: [
      'Pour 1 liter of freshly boiled water into a wide-mouthed heat-safe bowl.',
      'Add rosemary sprigs and crush them with a wooden spoon to release 1,8-cineole and camphor oils.',
      'Allow to sit for 30 seconds before beginning inhalation.',
    ],
    howToUse:
        'Drape towel over head and the bowl to form a steam tent. '
        'Inhale the fragrant steam gently with eyes firmly closed for 5-8 minutes. '
        'The camphor and 1,8-cineole clear blocked sinuses and sharpen mental alertness.',
    dosage: 'Once or twice daily during active sinus congestion or tension headache.',
    precautions: [
      'Keep face at a safe distance — at least 30 cm — to prevent hot steam burns.',
      'Always keep eyes closed during inhalation.',
      'Do not use if you have epilepsy due to high camphor content.',
    ],
    category: 'Headache',
    timeToPrepare: '5 mins',
    isEducationalOnly: true,
  ),

  // ──────────────────────────────────────────────────────────────────────────
  // YLANG YLANG – Stress / Anxiety / Hair
  // ──────────────────────────────────────────────────────────────────────────
  const Remedy(
    id: 'remedy_ylang_ylang_aroma',
    condition: 'Anxiety, Stress & Insomnia',
    title: 'Ylang Ylang Soothing Nighttime Aromatherapy',
    primaryPlantName: 'Ylang Ylang',
    primaryPlantScientific: 'Cananga odorata',
    plantId: 'ylang_ylang_plant',
    ingredients: [
      '2-3 fresh Ylang Ylang blossoms (or 2-3 drops pure essential oil)',
      'Diffuser or warm water bowl',
    ],
    preparationSteps: [
      'Option A — Fresh flowers: Float 2-3 fresh blossoms in a bowl of warm water and '
          'place near the bedside.',
      'Option B — Essential oil: Add 2-3 drops of ylang ylang essential oil to a room '
          'diffuser filled with 100 ml water.',
    ],
    howToUse:
        'Inhale the naturally sedative floral aroma for 20-30 minutes before retiring to bed. '
        'The linalool and benzyl acetate activate GABA receptors to ease anxiety, '
        'lower blood pressure, and promote deep restful sleep.',
    dosage: 'Nightly aromatherapy session of 20-30 minutes. '
        'For acute stress relief, a 5-minute targeted inhalation is effective.',
    precautions: [
      'Never ingest essential oils directly.',
      'Diffuse with good room ventilation to avoid headache from concentrated inhalation.',
      'Keep diffuser away from small pets and infants.',
      'Avoid if you have hypotension as Ylang Ylang can further lower blood pressure.',
    ],
    category: 'Stress & Sleep',
    timeToPrepare: '3 mins',
    isEducationalOnly: true,
  ),

  // ──────────────────────────────────────────────────────────────────────────
  // WOOD APPLE – Digestive
  // ──────────────────────────────────────────────────────────────────────────
  const Remedy(
    id: 'remedy_wood_apple_digestive',
    condition: 'Digestive Upset, Diarrhea & Liver Health',
    title: 'Wood Apple Gut-Balancing Probiotic Sherbet',
    primaryPlantName: 'Wood Apple (Elephant Apple)',
    primaryPlantScientific: 'Limonia acidissima',
    plantId: 'wood_apple_plant',
    ingredients: [
      '3-4 tablespoons fresh pulp of ripe Wood Apple fruit',
      '1 glass cool water',
      'Pinch of roasted cumin powder',
      '1 tsp raw sugar or jaggery',
      'Pinch of rock salt',
    ],
    preparationSteps: [
      'Crack open the hard woody shell of the Wood Apple fruit carefully.',
      'Scoop out the aromatic brown pulp and soak it in 1 glass of cool water for 10 minutes.',
      'Mash the pulp thoroughly with a spoon and strain through a fine sieve to remove seeds and fibers.',
      'Add roasted cumin powder, rock salt, and jaggery to the strained liquid.',
    ],
    howToUse:
        'Drink chilled or at room temperature before meals. '
        'Wood Apple is renowned in Ayurveda for healing intestinal epithelium, treating IBS, '
        'and balancing gut microbiota through its pectin and tannin content.',
    dosage: '1 glass once daily, preferably before the main afternoon meal.',
    precautions: [
      'Avoid excessive consumption which can cause constipation due to high tannin content.',
      'Not recommended for those with severe constipation.',
    ],
    category: 'Digestive',
    timeToPrepare: '15 mins',
    isEducationalOnly: true,
  ),

  // ──────────────────────────────────────────────────────────────────────────
  // PIRANDAI – Bone / Joint
  // ──────────────────────────────────────────────────────────────────────────
  const Remedy(
    id: 'remedy_pirandai_preparation',
    condition: 'Bone Fracture Healing, Joint Pain & Osteoporosis',
    title: 'Pirandai (Hadjod) Traditional Bone-Healing Preparation',
    primaryPlantName: 'Pirandai (Veldt Grape)',
    primaryPlantScientific: 'Cissus quadrangularis',
    plantId: 'pirandai_plant',
    ingredients: [
      '200 g fresh Pirandai stems, peeled and chopped',
      '1 tbsp sesame oil or ghee',
      '1/2 tsp turmeric powder',
      '1/2 tsp dry ginger powder',
      'Salt and pepper to taste',
      '1/2 cup warm milk (for dry powder preparation)',
    ],
    preparationSteps: [
      'Peel the outer layer of the quadrangular stems to remove the fibrous skin and calcium oxalate.',
      'Chop the stems into small pieces.',
      'Option A (Food): Sauté the chopped stems in sesame oil with turmeric and ginger '
          'until cooked through, about 8-10 minutes. Serve as a vegetable side dish.',
      'Option B (Medicinal powder): Sun-dry the stems for 3-4 days, then grind to a fine powder. '
          'Mix 1/2 tsp powder in warm milk with turmeric and honey.',
    ],
    howToUse:
        'As a cooked vegetable: eat alongside regular meals 3-4 times per week. '
        'As a milk decoction: drink 1 cup warm in the morning for bone strengthening. '
        'The ketosterone phytosterols directly stimulate osteoblast bone-forming cells.',
    dosage: '1/2 tsp dried stem powder in warm milk once daily; '
        'or 1/2 cup cooked stems 3-4 times per week.',
    precautions: [
      'ALWAYS cook or peel Pirandai stems before consumption — raw stems contain '
      'irritating calcium oxalate crystals.',
      'Consult a physician before using as a fracture adjuvant with other medications.',
    ],
    category: 'Bone & Joint',
    timeToPrepare: '15 mins',
    isEducationalOnly: true,
  ),
];
