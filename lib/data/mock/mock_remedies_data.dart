import '../models/remedy_model.dart';

/// Comprehensive library of verified traditional home remedies for all 13 supported
/// MediPlant species:
///   aloe_vera, amla, ashwagandha, ayapana, brahmi, gotu_kola, moringa,
///   multi_vitamin_plant, neem, rosemary, sarpagandha, tulsi, wood_apple
final List<Remedy> mockRemedies = [
  // ──────────────────────────────────────────────────────────────────────────
  // 1. ALOE VERA
  // ──────────────────────────────────────────────────────────────────────────
  const Remedy(
    id: 'remedy_aloe_vera_burn_gel',
    condition: 'Sunburn, Burns & Skin Irritation',
    title: 'Pure Aloe Acemannan Soothing Gel',
    primaryPlantName: 'Aloe Vera (Ghritkumari)',
    primaryPlantScientific: 'Aloe barbadensis miller',
    plantId: 'aloe_vera',
    ingredients: [
      '1 fresh organic Aloe Vera leaf',
      '2 drops pure tea tree oil (optional for acne/antiseptic)',
      '1/2 tsp pure cold-pressed coconut oil or Vitamin E oil',
    ],
    preparationSteps: [
      'Sever a thick outer leaf from the base of the Aloe plant.',
      'Stand the leaf upright in a glass for 10 minutes to drain the bitter yellow aloin resin.',
      'Slice off the prickly serrated margins with a knife, then fillet the top green rind.',
      'Scoop out the clear inner translucent gel with a spoon and rinse with cold water.',
      'Blend the gel lightly for 5 seconds until smooth. Mix with coconut or Vitamin E oil.',
    ],
    howToUse:
        'Smooth generously over sunburned skin, minor thermal burns, eczema patches, or acne. '
        'Leave to absorb naturally without washing off. Reapply 3-4 times daily.',
    dosage: 'Apply topically 3-4 times daily as needed.',
    precautions: [
      'For external use; discard the yellow aloin latex to prevent skin dermatitis.',
      'Do not apply on deep, open surgical incisions or third-degree burns.',
    ],
    category: 'Skin',
    timeToPrepare: '10 mins',
    isEducationalOnly: true,
  ),

  const Remedy(
    id: 'remedy_aloe_vera_digestive_juice',
    condition: 'Acid Reflux, Heartburn & Gastritis',
    title: 'Aloe Inner Fillet Mucilage Soothing Juice',
    primaryPlantName: 'Aloe Vera (Ghritkumari)',
    primaryPlantScientific: 'Aloe barbadensis miller',
    plantId: 'aloe_vera',
    ingredients: [
      '2 tablespoons freshly harvested, rinsed clear Aloe Vera gel',
      '1 cup chilled room-temperature water or coconut water',
      '1 tsp raw honey or a squeeze of fresh lime',
    ],
    preparationSteps: [
      'Extract clear inner gel fillet, ensuring zero yellow latex residue.',
      'Rinse the clear jelly thoroughly under clean running water twice.',
      'Place in a blender with water or coconut water and blend for 15 seconds.',
      'Pour into a glass and stir in honey or lime juice.',
    ],
    howToUse:
        'Drink slowly on an empty stomach in the morning or 20 minutes before a meal. '
        'The mucilaginous polysaccharides coat and soothe irritated esophageal and gastric linings.',
    dosage: '1 glass (about 200 ml) once daily 20 minutes before breakfast.',
    precautions: [
      'Ensure 100% absence of yellow latex (aloin) which causes severe cramping and diarrhea.',
      'Avoid high-dose internal use during pregnancy.',
    ],
    category: 'Digestion',
    timeToPrepare: '10 mins',
    isEducationalOnly: true,
  ),

  // ──────────────────────────────────────────────────────────────────────────
  // 2. AMLA
  // ──────────────────────────────────────────────────────────────────────────
  const Remedy(
    id: 'remedy_amla_immunity_elixir',
    condition: 'Low Immunity, Fatigue & Seasonal Viral Defense',
    title: 'Amla & Honey Vitamin C Cellular Elixir',
    primaryPlantName: 'Amla (Indian Gooseberry)',
    primaryPlantScientific: 'Phyllanthus emblica',
    plantId: 'amla',
    ingredients: [
      '2-3 fresh ripe Amla fruits, deseeded and chopped',
      '1/2 inch fresh ginger root',
      '1 tablespoon raw unprocessed honey',
      '1/2 glass warm water',
      'Pinch of roasted cumin or black pepper',
    ],
    preparationSteps: [
      'Grind chopped amla pieces and ginger with 3-4 tablespoons of water in a blender.',
      'Strain through a fine mesh strainer or muslin cloth to extract fresh cloudy juice.',
      'Dilute with 1/2 glass of warm water.',
      'Stir in raw honey and black pepper thoroughly.',
    ],
    howToUse:
        'Sip first thing in the morning on an empty stomach. The bioavailable Vitamin C '
        'and emblicanin polyphenols stimulate white blood cell phagocytosis and scavenge free radicals.',
    dosage: '20-30 ml fresh juice diluted in water once daily.',
    precautions: [
      'Do not boil fresh amla juice as heat may reduce ascorbic acid concentration.',
      'Diabetic patients can omit honey or substitute with pure stevia.',
    ],
    category: 'Immunity',
    timeToPrepare: '8 mins',
    isEducationalOnly: true,
  ),

  const Remedy(
    id: 'remedy_amla_hair_oil',
    condition: 'Hair Fall, Premature Graying & Dandruff',
    title: 'Ayurvedic Amla & Coconut Follicle Nourishing Oil',
    primaryPlantName: 'Amla (Indian Gooseberry)',
    primaryPlantScientific: 'Phyllanthus emblica',
    plantId: 'amla',
    ingredients: [
      '3 fresh Amla fruits, grated (or 2 tbsp pure dried Amla powder)',
      '1/2 cup cold-pressed virgin coconut oil',
      '1 tsp fenugreek (methi) seeds',
      'Optional: 4-5 fresh curry leaves',
    ],
    preparationSteps: [
      'Heat coconut oil in a small heavy-bottomed pan on low heat.',
      'Add grated amla (or powder), fenugreek seeds, and curry leaves.',
      'Simmer gently on low heat for 12-15 minutes until the amla turns golden-brown.',
      'Turn off the heat and allow the oil to cool completely.',
      'Strain through a muslin cloth into a clean, dry glass bottle.',
    ],
    howToUse:
        'Massage warm oil deeply into the scalp and along hair strands using circular motions. '
        'Leave on for at least 1-2 hours or overnight before washing with a gentle sulfate-free shampoo.',
    dosage: 'Apply 2-3 times per week before washing hair.',
    precautions: [
      'Warm the oil gently; do not overheat or burn the amla sediment.',
      'Keep away from water contamination to ensure 3-month shelf life.',
    ],
    category: 'Skin',
    timeToPrepare: '20 mins',
    isEducationalOnly: true,
  ),

  // ──────────────────────────────────────────────────────────────────────────
  // 3. ASHWAGANDHA
  // ──────────────────────────────────────────────────────────────────────────
  const Remedy(
    id: 'remedy_ashwagandha_moon_milk',
    condition: 'Chronic Stress, Insomnia & Low Stamina',
    title: 'Ashwagandha Rejuvenating Golden Moon Milk',
    primaryPlantName: 'Ashwagandha (Indian Ginseng)',
    primaryPlantScientific: 'Withania somnifera',
    plantId: 'ashwagandha',
    ingredients: [
      '1 tsp pure Ashwagandha root powder (churna)',
      '1 cup warm whole milk (or oat/almond milk for vegan)',
      '1/4 tsp ground turmeric',
      '1/4 tsp ground cardamom',
      'Pinch of nutmeg (enhances sleep)',
      '1 tsp raw honey or organic jaggery',
    ],
    preparationSteps: [
      'Add milk to a small saucepan and heat gently over low heat.',
      'Whisk in Ashwagandha powder, turmeric, cardamom, and nutmeg.',
      'Simmer gently for 5 minutes, stirring continuously so no lumps form.',
      'Remove from heat and pour into a mug.',
      'Stir in honey or jaggery once the milk cools to comfortable drinking temperature.',
    ],
    howToUse:
        'Drink warm 30-45 minutes before bedtime. The withanolides cross the blood-brain barrier '
        'to modulate GABA receptors and downregulate salivary cortisol, promoting deep restorative sleep.',
    dosage: '1 cup nightly before sleep for 4-8 weeks.',
    precautions: [
      'Contraindicated in pregnancy — may stimulate uterine contractions.',
      'Those with hyperthyroidism should consult an integrative physician.',
    ],
    category: 'Immunity',
    timeToPrepare: '10 mins',
    isEducationalOnly: true,
  ),

  // ──────────────────────────────────────────────────────────────────────────
  // 4. AYAPANA
  // ──────────────────────────────────────────────────────────────────────────
  const Remedy(
    id: 'remedy_ayapana_wound_poultice',
    condition: 'Cuts, Minor Wounds & Bleeding Hemorrhoids',
    title: 'Fresh Ayapana Hemostatic Wound Poultice',
    primaryPlantName: 'Ayapana',
    primaryPlantScientific: 'Ayapana triplinervis',
    plantId: 'ayapana',
    ingredients: [
      '4-5 fresh Ayapana leaves, washed clean',
      'Pinch of pure turmeric powder',
      'Sterile gauze or clean bandage',
    ],
    preparationSteps: [
      'Rinse fresh leaves in clean saline or boiled cool water.',
      'Crush the leaves thoroughly in a clean mortar and pestle to release their aromatic juice.',
      'Blend in a small pinch of turmeric.',
    ],
    howToUse:
        'Apply the bruised leaf pulp directly over minor bleeding cuts, scratches, or insect bites. '
        'Hold with gentle pressure for 2 minutes until bleeding ceases, then secure with sterile gauze.',
    dosage: 'Apply immediately upon minor bleeding or 2 times daily on healing abrasions.',
    precautions: [
      'Seek emergency medical evaluation for deep arterial spurting or severe lacerations.',
      'Ensure leaves are completely clean to avoid secondary bacterial infection.',
    ],
    category: 'Skin',
    timeToPrepare: '5 mins',
    isEducationalOnly: true,
  ),

  const Remedy(
    id: 'remedy_ayapana_digestive_infusion',
    condition: 'Indigestion, Stomach Cramps & Gas',
    title: 'Ayapana Aromatic Stomach-Calming Tea',
    primaryPlantName: 'Ayapana',
    primaryPlantScientific: 'Ayapana triplinervis',
    plantId: 'ayapana',
    ingredients: [
      '5-6 fresh or dried Ayapana leaves',
      '1.5 cups clean water',
      '1/2 tsp crushed fennel (saunf) seeds',
      '1 tsp raw honey (optional)',
    ],
    preparationSteps: [
      'Bring water to a rolling boil in a small pot.',
      'Add crushed Ayapana leaves and fennel seeds.',
      'Cover with a lid and let steep off the heat for 7-10 minutes.',
      'Strain through a tea strainer into a cup and sweeten with honey if desired.',
    ],
    howToUse:
        'Sip warm after a heavy or greasy meal. The essential oil fraction eases gastrointestinal spasms '
        'and reduces painful abdominal bloating.',
    dosage: '1 cup 1-2 times daily after meals.',
    precautions: [
      'Do not consume in high doses if taking prescription blood thinners.',
    ],
    category: 'Digestion',
    timeToPrepare: '10 mins',
    isEducationalOnly: true,
  ),

  // ──────────────────────────────────────────────────────────────────────────
  // 5. BRAHMI
  // ──────────────────────────────────────────────────────────────────────────
  const Remedy(
    id: 'remedy_brahmi_memory_ghee',
    condition: 'Memory Loss, Brain Fog & Academic Concentration',
    title: 'Brahmi Medhya Intellect Enhancing Infusion',
    primaryPlantName: 'Brahmi (Water Hyssop)',
    primaryPlantScientific: 'Bacopa monnieri',
    plantId: 'brahmi',
    ingredients: [
      '1 tsp pure dried Brahmi powder (or 10-12 fresh crushed leaves)',
      '1/2 tsp grass-fed pure cow ghee (A2 ghee)',
      '1/2 cup warm water or warm milk',
      'Pinch of black pepper (enhances bioavailability)',
    ],
    preparationSteps: [
      'Gently melt the ghee in a small pan on low heat.',
      'Stir in the Brahmi powder and black pepper for 30 seconds.',
      'Add warm milk or warm water and stir thoroughly.',
      'Pour into a cup and consume immediately.',
    ],
    howToUse:
        'Drink in the morning on an empty stomach. Ghee serves as a lipophilic carrier (yogavahi) '
        'that transports bacosides across the lipid blood-brain barrier to accelerate synaptic repair.',
    dosage: 'Consume once daily in the morning for 8-12 weeks.',
    precautions: [
      'Always consume alongside healthy fats (ghee/milk) to avoid potential gastric upset.',
      'Do not exceed recommended dosage.',
    ],
    category: 'Immunity',
    timeToPrepare: '5 mins',
    isEducationalOnly: true,
  ),

  // ──────────────────────────────────────────────────────────────────────────
  // 6. GOTU KOLA
  // ──────────────────────────────────────────────────────────────────────────
  const Remedy(
    id: 'remedy_gotu_kola_memory_salad',
    condition: 'Mental Fatigue, Poor Microcirculation & Vein Health',
    title: 'Gotu Kola (Vallarai) Longevity Herbal Tea',
    primaryPlantName: 'Gotu Kola (Mandukaparni)',
    primaryPlantScientific: 'Centella asiatica',
    plantId: 'gotu_kola',
    ingredients: [
      '8-10 fresh Gotu Kola leaves (or 1 tsp dried herb)',
      '1.5 cups boiling water',
      '1/2 inch fresh ginger, crushed',
      '1 tsp raw honey',
      'Squeeze of fresh lemon',
    ],
    preparationSteps: [
      'Wash fresh Gotu Kola leaves thoroughly and roughly tear them.',
      'Place in a teapot or mug alongside crushed ginger.',
      'Pour boiling water over the leaves, cover, and steep for 8-10 minutes.',
      'Strain, add lemon juice and honey, and stir well.',
    ],
    howToUse:
        'Drink in the morning or early afternoon. Asiaticoside stimulates cerebral microcirculation '
        'and enhances connective tissue collagen without raising cardiac pulse.',
    dosage: '1 cup once or twice daily.',
    precautions: [
      'Avoid high medicinal doses in pregnancy.',
      'Do not consume excessively if on strong liver-clearing prescription medications.',
    ],
    category: 'Immunity',
    timeToPrepare: '10 mins',
    isEducationalOnly: true,
  ),

  // ──────────────────────────────────────────────────────────────────────────
  // 7. MORINGA
  // ──────────────────────────────────────────────────────────────────────────
  const Remedy(
    id: 'remedy_moringa_green_soup',
    condition: 'Nutritional Anemia, General Weakness & Joint Pain',
    title: 'Moringa Leaf Vitality & Joint-Relief Broth',
    primaryPlantName: 'Moringa (Drumstick Tree)',
    primaryPlantScientific: 'Moringa oleifera',
    plantId: 'moringa',
    ingredients: [
      '1 cup fresh tender Moringa leaves, washed and stripped from stems',
      '2 cups water or vegetable stock',
      '2 cloves garlic, crushed',
      '1/2 tsp cumin seeds',
      '1/2 tsp crushed black peppercorns',
      'Pinch of turmeric and pink Himalayan salt',
      '1 tsp cold-pressed sesame or coconut oil',
    ],
    preparationSteps: [
      'Heat oil in a saucepan; add cumin seeds, crushed garlic, and black pepper until fragrant.',
      'Add fresh Moringa leaves and sauté for 1 minute.',
      'Pour in water or vegetable stock, add turmeric and salt.',
      'Simmer gently for 6-8 minutes until leaves are tender.',
      'Serve warm as a nourishing restorative soup.',
    ],
    howToUse:
        'Consume warm as a pre-meal appetizer or light restorative dinner. Delivers dense bioavailable '
        'iron, calcium, Vitamin C, and moringin isothiocyanates to relieve inflammation.',
    dosage: '1 warm bowl 3-4 times a week.',
    precautions: [
      'Use only leaves and culinary drumstick pods; never use moringa roots or bark.',
    ],
    category: 'Immunity',
    timeToPrepare: '15 mins',
    isEducationalOnly: true,
  ),

  // ──────────────────────────────────────────────────────────────────────────
  // 8. MULTI VITAMIN PLANT
  // ──────────────────────────────────────────────────────────────────────────
  const Remedy(
    id: 'remedy_multivitamin_daily_greens',
    condition: 'Micronutrient Deficiency, Eye Strain & Low Lactation',
    title: 'Chakra Muni Living Multivitamin Green Sauté',
    primaryPlantName: 'Multi Vitamin Plant (Chakra Muni / Katuk)',
    primaryPlantScientific: 'Sauropus androgynus',
    plantId: 'multi_vitamin_plant',
    ingredients: [
      '1 cup tender fresh Chakra Muni leaves, washed clean',
      '2 cloves garlic, finely sliced',
      '1/2 tsp mustard seeds',
      '2 tbsp grated fresh coconut',
      '1 tsp cold-pressed oil or ghee',
      'Pinch of sea salt',
    ],
    preparationSteps: [
      'Heat oil or ghee in a pan; pop the mustard seeds and add sliced garlic.',
      'Add fresh Chakra Muni leaves and a pinch of salt.',
      'Sauté on medium heat for 2-3 minutes until wilted but still vibrant green.',
      'Stir in grated coconut, turn off the heat, and mix thoroughly.',
    ],
    howToUse:
        'Eat as a side dish with lunch or dinner. The gentle cooking makes beta-carotene, '
        'lutein, iron, and plant proteins immediately bioavailable for absorption.',
    dosage: '1 small bowl daily or 5-10 raw leaves chewed fresh in the morning.',
    precautions: [
      'Always consume in moderate dietary amounts; avoid fad raw juicing of excessive quantities.',
    ],
    category: 'Immunity',
    timeToPrepare: '8 mins',
    isEducationalOnly: true,
  ),

  // ──────────────────────────────────────────────────────────────────────────
  // 9. NEEM
  // ──────────────────────────────────────────────────────────────────────────
  const Remedy(
    id: 'remedy_neem_acne_paste',
    condition: 'Cystic Acne, Pimples & Skin Blemishes',
    title: 'Neem & Turmeric Clarifying Antimicrobial Mask',
    primaryPlantName: 'Neem (Indian Lilac)',
    primaryPlantScientific: 'Azadirachta indica',
    plantId: 'neem',
    ingredients: [
      '10-12 fresh tender Neem leaves (or 1 tsp pure Neem leaf powder)',
      '1/4 tsp pure wild turmeric (kasturi manjal)',
      '1-2 tablespoons pure rose water or cool water',
      '1 tsp organic multani mitti (Fuller’s Earth - optional)',
    ],
    preparationSteps: [
      'Grind fresh washed neem leaves with rose water in a mortar into a smooth green paste.',
      'Mix in turmeric powder and Fuller’s earth until a spreadable consistency forms.',
    ],
    howToUse:
        'Apply directly onto affected acne spots or as a thin clarifying face mask. '
        'Leave on for 15-20 minutes until dry, then rinse gently with cool water.',
    dosage: 'Apply 2-3 times per week on blemished skin.',
    precautions: [
      'For external use only. Discontinue if redness or stinging occurs.',
      'Avoid contact with immediate eye contours.',
    ],
    category: 'Skin',
    timeToPrepare: '7 mins',
    isEducationalOnly: true,
  ),

  const Remedy(
    id: 'remedy_neem_antiseptic_wash',
    condition: 'Dandruff, Scalp Itch & Bacterial Skin Rashes',
    title: 'Boiled Neem Leaf Antiseptic Scalp & Body Wash',
    primaryPlantName: 'Neem (Indian Lilac)',
    primaryPlantScientific: 'Azadirachta indica',
    plantId: 'neem',
    ingredients: [
      '2 large handfuls of fresh Neem leaves',
      '4 cups clean water',
    ],
    preparationSteps: [
      'Wash neem leaves thoroughly to remove dust.',
      'Bring 4 cups of water to a boil in a pot and add the neem leaves.',
      'Boil on medium heat for 10-12 minutes until the water turns pale greenish-yellow.',
      'Turn off heat, cover, and let steep until room temperature.',
      'Strain out the leaves.',
    ],
    howToUse:
        'Use as a final rinse over hair and scalp after shampooing for dandruff relief, '
        'or use as an antiseptic wash for fungal skin rashes and chickenpox lesions.',
    dosage: 'Use 2-3 times weekly as a topical rinse.',
    precautions: [
      'Avoid getting directly into the eyes as neem water can sting.',
    ],
    category: 'Skin',
    timeToPrepare: '15 mins',
    isEducationalOnly: true,
  ),

  // ──────────────────────────────────────────────────────────────────────────
  // 10. ROSEMARY
  // ──────────────────────────────────────────────────────────────────────────
  const Remedy(
    id: 'remedy_rosemary_hair_growth_tonic',
    condition: 'Hair Thinning, Alopecia & Scalp Sluggishness',
    title: 'Rosemary Carnosic Acid Hair Regrowth Spray',
    primaryPlantName: 'Rosemary',
    primaryPlantScientific: 'Salvia rosmarinus',
    plantId: 'rosemary',
    ingredients: [
      '3-4 fresh Rosemary sprigs (or 2 tbsp dried rosemary needles)',
      '2 cups purified water',
      '1 tsp pure apple cider vinegar (optional for pH balance)',
      'Clean spray mist bottle',
    ],
    preparationSteps: [
      'Bring water to a rolling boil in a pot.',
      'Add rosemary sprigs, reduce heat, cover, and simmer for 15-20 minutes.',
      'Turn off heat and let cool completely (the water turns a deep amber-red hue).',
      'Strain through a fine filter and pour into a clean spray mist bottle.',
    ],
    howToUse:
        'Part hair in sections and spray directly onto clean scalp every morning or evening. '
        'Gently massage with fingertips for 2-3 minutes. Do not rinse out.',
    dosage: 'Apply once daily directly to the scalp.',
    precautions: [
      'Perform a patch test first. Store spray bottle in the refrigerator for up to 2 weeks.',
    ],
    category: 'Skin',
    timeToPrepare: '25 mins',
    isEducationalOnly: true,
  ),

  const Remedy(
    id: 'remedy_rosemary_steam_inhalation',
    condition: 'Sinus Congestion, Tension Headache & Mental Fog',
    title: 'Rosemary & Cineole Respiratory Steam Therapy',
    primaryPlantName: 'Rosemary',
    primaryPlantScientific: 'Salvia rosmarinus',
    plantId: 'rosemary',
    ingredients: [
      '2 fresh sprigs of Rosemary (or 1 tbsp dried needles)',
      '4 cups steaming hot water',
      'Large towel',
    ],
    preparationSteps: [
      'Bring water to a vigorous boil and pour into a heatproof ceramic or glass bowl.',
      'Bruise the rosemary needles with fingers and drop them into the steaming water.',
    ],
    howToUse:
        'Drape a towel over your head and bowl, close eyes, and breathe deeply through the nose '
        'for 5-8 minutes. The 1,8-cineole and camphor penetrate and decongest blocked sinus cavities.',
    dosage: 'Perform once or twice daily during acute nasal congestion.',
    precautions: [
      'Keep eyes firmly closed during steam inhalation to avoid volatile oil irritation.',
      'Keep a safe distance from steaming water to avoid burns.',
    ],
    category: 'Cough',
    timeToPrepare: '8 mins',
    isEducationalOnly: true,
  ),

  // ──────────────────────────────────────────────────────────────────────────
  // 11. SARPAGANDHA
  // ──────────────────────────────────────────────────────────────────────────
  const Remedy(
    id: 'remedy_sarpagandha_bp_infusion',
    condition: 'Hypertension & Chronic Restless Insomnia',
    title: 'Classical Sarpagandha Bedtime Blood Pressure Tonic',
    primaryPlantName: 'Sarpagandha (Indian Snakeroot)',
    primaryPlantScientific: 'Rauvolfia serpentina',
    plantId: 'sarpagandha',
    ingredients: [
      '250 mg (strictly measured) pure Sarpagandha root powder',
      '1/2 cup warm milk or water',
      '1/4 tsp pure rose water',
      'Pinch of cardamom powder',
    ],
    preparationSteps: [
      'Carefully measure exactly 250 mg of pure Sarpagandha root powder using a micro-scale.',
      'Stir into warm milk or water alongside cardamom and rose water.',
      'Mix thoroughly and consume immediately.',
    ],
    howToUse:
        'Consume strictly at bedtime under professional guidance. Reserpine depletes sympathetic '
        'catecholamines, lowering arterial blood pressure and promoting deep sedation.',
    dosage: '250 mg once daily at bedtime (under medical/Ayurvedic supervision).',
    precautions: [
      'STRICT DOSING: Do not overdose. Overdosing causes dangerous hypotension and bradycardia.',
      'Regular blood pressure monitoring is mandatory.',
    ],
    category: 'Immunity',
    timeToPrepare: '3 mins',
    isEducationalOnly: true,
  ),

  // ──────────────────────────────────────────────────────────────────────────
  // 12. TULSI
  // ──────────────────────────────────────────────────────────────────────────
  const Remedy(
    id: 'remedy_tulsi_ginger_kadha',
    condition: 'Cough, Sore Throat, Cold & Fever',
    title: 'Traditional Ayurvedic Tulsi Ginger Healing Kadha',
    primaryPlantName: 'Tulsi (Holy Basil)',
    primaryPlantScientific: 'Ocimum tenuiflorum',
    plantId: 'tulsi',
    ingredients: [
      '8-10 fresh Holy Basil (Tulsi) leaves',
      '1/2 inch fresh ginger, crushed',
      '3-4 whole black peppercorns, crushed',
      '1 small piece cinnamon stick',
      '2 cups clean water',
      '1 tsp raw honey or organic jaggery',
    ],
    preparationSteps: [
      'In a saucepan, combine water, fresh Tulsi leaves, crushed ginger, black pepper, and cinnamon.',
      'Bring to a boil and simmer on low heat for 10 minutes until reduced by half.',
      'Strain the fragrant warm decoction into a mug.',
      'Allow to cool slightly before stirring in honey or jaggery.',
    ],
    howToUse:
        'Sip warm slowly 2-3 times daily. Eugenol and camphene thin mucus, expand bronchial airways, '
        'soothe throat irritation, and accelerate viral clearance.',
    dosage: '1/2 to 1 cup twice or thrice daily for 3-5 days.',
    precautions: [
      'Add honey only when the decoction is warm, not boiling hot.',
      'Those on blood thinners should avoid excessive quantities.',
    ],
    category: 'Cough',
    timeToPrepare: '15 mins',
    isEducationalOnly: true,
  ),

  const Remedy(
    id: 'remedy_tulsi_sinus_steam',
    condition: 'Sinus Congestion, Rhinitis & Upper Phlegm',
    title: 'Tulsi Eugenol Steam Inhalation',
    primaryPlantName: 'Tulsi (Holy Basil)',
    primaryPlantScientific: 'Ocimum tenuiflorum',
    plantId: 'tulsi',
    ingredients: [
      '15-20 fresh Tulsi leaves, bruised',
      '4 cups boiling water',
      'Pinch of turmeric powder',
      'Clean towel',
    ],
    preparationSteps: [
      'Boil water vigorously in a wide bowl.',
      'Add bruised Tulsi leaves and turmeric into the steaming water.',
    ],
    howToUse:
        'Cover head and bowl with a towel. Inhale steam through nostrils deeply for 5-8 minutes.',
    dosage: 'Twice daily during acute colds and blocked sinuses.',
    precautions: [
      'Keep eyes closed. Keep face at a comfortable distance to prevent steam scald.',
    ],
    category: 'Cough',
    timeToPrepare: '7 mins',
    isEducationalOnly: true,
  ),

  // ──────────────────────────────────────────────────────────────────────────
  // 13. WOOD APPLE
  // ──────────────────────────────────────────────────────────────────────────
  const Remedy(
    id: 'remedy_wood_apple_sharbat',
    condition: 'Chronic Indigestion, Dysentery & Gut Inflammation',
    title: 'Refreshing Bael Fruit Gut-Cooling Sharbat',
    primaryPlantName: 'Wood Apple (Bael / Elephant Apple)',
    primaryPlantScientific: 'Limonia acidissima',
    plantId: 'wood_apple',
    ingredients: [
      '1 medium ripe Wood Apple (Bael fruit)',
      '2 cups clean cool water',
      '1-2 tbsp organic jaggery or raw sugar',
      '1/4 tsp roasted cumin powder',
      'Pinch of black salt (kala namak)',
    ],
    preparationSteps: [
      'Crack open the hard woody shell by tapping firmly with a pestle.',
      'Scoop out the aromatic brown pulp with a spoon into a large bowl.',
      'Add 1 cup of water and mash the pulp thoroughly with clean hands or a potato masher.',
      'Strain through a soup strainer, pressing with a spoon to separate sticky seeds and fibers.',
      'Add the remaining water, jaggery, roasted cumin, and black salt. Whisk until smooth.',
    ],
    howToUse:
        'Drink chilled or room temperature. The pectin mucilage and marmelosin coat the intestinal mucosa, '
        'bind loose watery stools, and soothe digestive burning.',
    dosage: '1 glass (about 200 ml) daily between meals.',
    precautions: [
      'Do not blend with an electric mixer as seeds will break and make the drink intensely bitter.',
    ],
    category: 'Digestion',
    timeToPrepare: '12 mins',
    isEducationalOnly: true,
  ),

  const Remedy(
    id: 'remedy_wood_apple_diarrhea_decoction',
    condition: 'Acute Diarrhea, Loose Stools & Irritable Bowel',
    title: 'Astringent Wood Apple Leaf & Tannin Decoction',
    primaryPlantName: 'Wood Apple (Bael / Elephant Apple)',
    primaryPlantScientific: 'Limonia acidissima',
    plantId: 'wood_apple',
    ingredients: [
      '5-6 fresh Wood Apple (Bael) leaves, washed clean',
      '1.5 cups clean water',
      '1/2 tsp roasted cumin seeds, crushed',
      'Pinch of dry ginger powder (saunth)',
    ],
    preparationSteps: [
      'Roughly crush the fresh Bael leaves.',
      'Combine with water, crushed cumin, and dry ginger in a small saucepan.',
      'Boil on medium heat until reduced to 1 cup.',
      'Strain through a fine strainer into a cup.',
    ],
    howToUse:
        'Sip warm between meals. The astringent tannins cross-link surface mucosal proteins '
        'to arrest excessive intestinal fluid secretion.',
    dosage: '1/2 cup twice daily until loose stools subside.',
    precautions: [
      'Do not consume if suffering from severe dry constipation.',
    ],
    category: 'Digestion',
    timeToPrepare: '10 mins',
    isEducationalOnly: true,
  ),
];
