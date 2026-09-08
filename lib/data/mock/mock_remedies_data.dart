import '../models/remedy_model.dart';

/// Comprehensive library of verified traditional home remedies for MediPlant
final List<Remedy> mockRemedies = [
  const Remedy(
    id: 'remedy_tulsi_ginger_tea',
    condition: 'Cough',
    title: 'Tulsi & Ginger Soothing Decoction',
    primaryPlantName: 'Holy Basil (Tulsi)',
    primaryPlantScientific: 'Ocimum tenuiflorum',
    plantId: 'tulsi_plant',
    ingredients: [
      '8-10 fresh Tulsi leaves (or 1 tsp dried)',
      '1 inch crushed fresh ginger root',
      '3-4 whole black peppercorns (crushed)',
      '1 tsp raw organic honey',
      '2 cups clean water',
    ],
    preparationSteps: [
      'In a saucepan, bring 2 cups of clean water to a rolling boil.',
      'Add crushed ginger, fresh Tulsi leaves, and crushed black peppercorns.',
      'Reduce flame to low and simmer for 6 to 8 minutes until water reduces to 1 cup.',
      'Strain liquid into a ceramic mug.',
      'Allow to cool until warm, then stir in 1 teaspoon of raw honey (never add honey to boiling liquid).',
    ],
    howToUse:
        'Sip slowly while warm, allowing the aromatic vapors to coat the throat and clear the chest.',
    dosage: '1 cup twice daily, preferably morning and late afternoon for 3-5 days.',
    precautions: [
      'Avoid giving raw honey to infants under 12 months of age.',
      'If cough is accompanied by blood, shortness of breath, or high fever (>102°F), consult a doctor immediately.',
    ],
    category: 'Cough',
    timeToPrepare: '10 mins',
  ),
  const Remedy(
    id: 'remedy_malabar_nut_decoction',
    condition: 'Cough & Bronchial Congestion',
    title: 'Vasaka (Malabar Nut) Bronchial Expectorant',
    primaryPlantName: 'Malabar Nut (Vasaka)',
    primaryPlantScientific: 'Justicia adhatoda',
    plantId: 'malabar_nut_plant',
    ingredients: [
      '4-5 fresh Vasaka leaves thoroughly washed',
      '1/2 inch fresh crushed ginger',
      '1 tsp raw honey',
      '2 cups water',
    ],
    preparationSteps: [
      'Tear leaves roughly and boil in 2 cups of water with ginger.',
      'Boil down to 1 cup on low flame.',
      'Strain through a fine tea strainer.',
      'Add honey once the decoction is warm (not boiling hot).',
    ],
    howToUse:
        'Drink warm. Helps liquify sticky mucus and expand constricted bronchial airways.',
    dosage: '2-3 tablespoons twice daily after light food.',
    precautions: [
      'Contraindicated in early pregnancy as Vasaka stimulates uterine contraction.',
      'Do not exceed recommended dosage.',
    ],
    category: 'Cough',
    timeToPrepare: '12 mins',
  ),
  const Remedy(
    id: 'remedy_cinnamon_honey_tea',
    condition: 'Cold & Sore Throat',
    title: 'Cinnamon & Honey Warming Infusion',
    primaryPlantName: 'Cinnamon',
    primaryPlantScientific: 'Cinnamomum verum',
    plantId: 'cinnamon_plant',
    ingredients: [
      '1 small Ceylon cinnamon stick (or 1/2 tsp pure Ceylon cinnamon powder)',
      '1 cup boiling water',
      '1 tsp raw honey',
      '1 tsp fresh lemon juice',
    ],
    preparationSteps: [
      'Place cinnamon stick or powder in a cup.',
      'Pour 1 cup of boiling water over the cinnamon.',
      'Cover with a saucer and steep for 8-10 minutes.',
      'Stir in lemon juice and raw honey when comfortably warm.',
    ],
    howToUse:
        'Drink slowly while warm to soothe throat tickle, stimulate circulation, and provide natural antimicrobial benefits.',
    dosage: '1 cup up to 2 times daily.',
    precautions: [
      'Use true Ceylon cinnamon rather than Cassia cinnamon to avoid high coumarin content.',
      'Avoid high doses during early pregnancy.',
    ],
    category: 'Cold',
    timeToPrepare: '10 mins',
  ),
  const Remedy(
    id: 'remedy_kadha_decoction',
    condition: 'Seasonal Fever & Immunity',
    title: 'Ayush Traditional Immunity Kadha',
    primaryPlantName: 'Tulsi & Spices',
    primaryPlantScientific: 'Ocimum tenuiflorum',
    plantId: 'tulsi_plant',
    ingredients: [
      '6-8 Tulsi leaves',
      '1/2 cinnamon stick',
      '1/2 tsp crushed dry ginger (sunthi)',
      '3 crushed black peppercorns',
      '1 small piece jaggery (optional for taste)',
      '2.5 cups water',
    ],
    preparationSteps: [
      'Combine all spices and herbs in water.',
      'Boil on medium heat until volume is reduced by half.',
      'Strain into a cup and drink warm.',
    ],
    howToUse:
        'Drink warm in the morning or during seasonal transitions to bolster innate immunity.',
    dosage: '1/2 to 1 cup once daily.',
    precautions: [
      'Individuals with active gastric ulcers should reduce pepper and ginger.',
    ],
    category: 'Immunity',
    timeToPrepare: '15 mins',
  ),
  const Remedy(
    id: 'remedy_tulsi_honey_chew',
    condition: 'Sore Throat',
    title: 'Fresh Tulsi Leaf & Honey Chew',
    primaryPlantName: 'Holy Basil (Tulsi)',
    primaryPlantScientific: 'Ocimum tenuiflorum',
    plantId: 'tulsi_plant',
    ingredients: [
      '4-5 fresh clean Tulsi leaves',
      '1/2 tsp raw honey',
    ],
    preparationSteps: [
      'Wash fresh tender Tulsi leaves in clean drinking water.',
      'Dip the leaves in pure honey.',
    ],
    howToUse:
        'Chew slowly and swallow the extracted juices, allowing them to coat the irritated mucosal throat lining.',
    dosage: 'Repeat 2 to 3 times a day as needed.',
    precautions: [
      'Rinse mouth with water afterward as frequent chewing of acidic herbs can affect tooth enamel.',
    ],
    category: 'Sore throat',
    timeToPrepare: '2 mins',
  ),
  const Remedy(
    id: 'remedy_tooth_ache_gargle',
    condition: 'Toothache & Oral Health',
    title: 'Toothache Plant Analgesic Oral Rinse',
    primaryPlantName: 'Toothache Plant (Akarkara)',
    primaryPlantScientific: 'Acmella oleracea',
    plantId: 'tooth_ache_plant',
    ingredients: [
      '1 fresh flower bud or 3-4 fresh leaves of Toothache Plant',
      '1/2 cup warm water',
      'Pinch of rock salt',
    ],
    preparationSteps: [
      'Crush the flower bud or leaves lightly in a mortar.',
      'Steep in warm water with a pinch of rock salt for 5 minutes.',
      'Strain the infusion.',
    ],
    howToUse:
        'Swish around the mouth and target near the painful tooth or gum for 1-2 minutes, then spit out completely. The spilanthol compound provides natural numbing.',
    dosage: 'Use 2-3 times daily as temporary relief until seeing a dentist.',
    precautions: [
      'Spits out completely; do not swallow in large volumes.',
      'Does not replace definitive professional dental treatment for caries or abscesses.',
    ],
    category: 'Dental',
    timeToPrepare: '5 mins',
  ),
  const Remedy(
    id: 'remedy_aloe_vera_juice',
    condition: 'Mild Indigestion & Heartburn',
    title: 'Cooling Aloe Vera Digestive Juice',
    primaryPlantName: 'Aloe Vera',
    primaryPlantScientific: 'Aloe barbadensis miller',
    plantId: 'aloe_vera_plant',
    ingredients: [
      '2 tbsp fresh clear inner Aloe Vera gel fillet (no yellow latex)',
      '1 cup room temperature water or coconut water',
      '1 tsp cumin seed powder (optional)',
    ],
    preparationSteps: [
      'Harvest mature leaf, stand vertically for 10 minutes to drain yellow aloin latex.',
      'Carefully peel outer green rind and rinse the clear gel fillet in cold water.',
      'Blend gel fillet with water until smooth.',
    ],
    howToUse:
        'Drink slowly on an empty stomach in the morning to soothe hyperacidity and stomach lining irritation.',
    dosage: '50-100 ml once daily in the morning.',
    precautions: [
      'Ensure complete removal of yellow latex which has strong laxative properties.',
      'Avoid during active diarrhea or acute abdominal pain.',
    ],
    category: 'Mild Indigestion',
    timeToPrepare: '8 mins',
  ),
  const Remedy(
    id: 'remedy_wood_apple_digestive',
    condition: 'Digestive Upset & Diarrhea',
    title: 'Wood Apple (Bael) Gut-Balancing Sherbet',
    primaryPlantName: 'Wood Apple (Bael)',
    primaryPlantScientific: 'Aegle marmelos',
    plantId: 'wood_apple_plant',
    ingredients: [
      '3-4 tbsp fresh pulp of ripe Wood Apple',
      '1 glass cool water',
      'Pinch of roasted cumin powder',
      '1 tsp raw sugar or jaggery',
    ],
    preparationSteps: [
      'Scoop ripe pulp from shell and soak in cool water for 15 minutes.',
      'Mash with fingers or spoon and strain seeds and fibrous strands through a sieve.',
      'Mix in cumin powder and jaggery.',
    ],
    howToUse:
        'Drink chilled or room temperature. Renowned in Ayurveda for healing intestinal epithelium, IBS, and chronic dysentery.',
    dosage: '1 glass once daily before noon.',
    precautions: [
      'Avoid excessive consumption which can cause constipation.',
    ],
    category: 'Mild Indigestion',
    timeToPrepare: '15 mins',
  ),
  const Remedy(
    id: 'remedy_methi_seed_water',
    condition: 'Metabolic & Digestive Support',
    title: 'Fenugreek (Methi) Overnight Metabolic Water',
    primaryPlantName: 'Fenugreek (Methi)',
    primaryPlantScientific: 'Trigonella foenum-graecum',
    plantId: 'methi_plant',
    ingredients: [
      '1 tsp whole Fenugreek seeds',
      '1 glass warm drinking water',
    ],
    preparationSteps: [
      'Rinse methi seeds and soak in 1 glass of water overnight (8 hours).',
      'In the morning, warm the water slightly.',
    ],
    howToUse:
        'Strain and drink the water on an empty stomach, and chew the softened seeds. Helps modulate postprandial blood glucose and supports digestive regularity.',
    dosage: '1 glass daily every morning.',
    precautions: [
      'Patients taking hypoglycemic medications should monitor blood sugar closely.',
      'Avoid large quantities during pregnancy.',
    ],
    category: 'Diabetes & Digestion',
    timeToPrepare: '5 mins (overnight soak)',
  ),
  const Remedy(
    id: 'remedy_gotu_kola_tea',
    condition: 'Headache & Mental Fatigue',
    title: 'Gotu Kola (Mandukaparni) Clarity & Calming Tea',
    primaryPlantName: 'Gotu Kola (Centella)',
    primaryPlantScientific: 'Centella asiatica',
    plantId: 'gotu_kola_plant',
    ingredients: [
      '6-8 fresh Gotu Kola leaves (or 1 tsp dried herb)',
      '1 cup hot water',
      '1/2 tsp honey',
    ],
    preparationSteps: [
      'Wash fresh leaves thoroughly.',
      'Bruise leaves gently with fingertips and place in a cup.',
      'Pour hot water over leaves and steep covered for 6-8 minutes.',
      'Strain and add a drop of honey.',
    ],
    howToUse:
        'Drink in the afternoon or evening to calm nervous tension, relieve tension headaches, and enhance cognitive resilience.',
    dosage: '1 cup once or twice daily.',
    precautions: [
      'Avoid high doses in liver disease or with sedative medications.',
    ],
    category: 'Headache',
    timeToPrepare: '8 mins',
  ),
  const Remedy(
    id: 'remedy_ylang_ylang_aroma',
    condition: 'Stress & Insomnia',
    title: 'Ylang Ylang Soothing Nighttime Aromatherapy',
    primaryPlantName: 'Ylang Ylang',
    primaryPlantScientific: 'Cananga odorata',
    plantId: 'ylang_ylang_plant',
    ingredients: [
      '2 fresh Ylang Ylang blossoms (or 2-3 drops essential oil)',
      'Diffuser or warm water bowl',
    ],
    preparationSteps: [
      'Float fresh flowers in a bowl of warm water near the bedside or add 2 drops of essential oil to a diffuser.',
    ],
    howToUse:
        'Inhale the naturally sedative floral aroma 20 minutes before retiring to bed to ease anxiety and promote restful sleep.',
    dosage: 'Nightly aromatherapy session for 20-30 minutes.',
    precautions: [
      'Never ingest essential oils directly. Keep diffuser away from small pets.',
    ],
    category: 'Stress & Sleep',
    timeToPrepare: '3 mins',
  ),
  const Remedy(
    id: 'remedy_rosemary_steam',
    condition: 'Sinus Headache & Congestion',
    title: 'Rosemary Sinus Clearing Herbal Steam',
    primaryPlantName: 'Rosemary',
    primaryPlantScientific: 'Salvia rosmarinus',
    plantId: 'rosemary_plant',
    ingredients: [
      '2 fresh rosemary sprigs (or 1 tbsp dried rosemary)',
      '1 liter boiling water',
      'Clean towel',
    ],
    preparationSteps: [
      'Add rosemary sprigs to a bowl of steaming boiling water.',
      'Crush sprigs with a wooden spoon to release 1,8-cineole and camphor oils.',
    ],
    howToUse:
        'Drape towel over head and inhale steam gently with eyes closed for 5-8 minutes.',
    dosage: 'Once or twice daily during sinus congestion.',
    precautions: [
      'Keep safe distance to prevent hot steam burns. Keep eyes closed.',
    ],
    category: 'Headache',
    timeToPrepare: '5 mins',
  ),
  const Remedy(
    id: 'remedy_neem_turmeric_paste',
    condition: 'Acne & Skin Blemishes',
    title: 'Purifying Neem & Turmeric Spot Compress',
    primaryPlantName: 'Neem',
    primaryPlantScientific: 'Azadirachta indica',
    plantId: 'neem_plant',
    ingredients: [
      '10-12 fresh Neem leaves',
      '1/4 tsp pure turmeric powder',
      '1-2 tsp pure rosewater',
    ],
    preparationSteps: [
      'Wash neem leaves thoroughly and grind to a smooth paste with minimal water.',
      'Mix in turmeric powder and rosewater to form a thick, spreadable paste.',
    ],
    howToUse:
        'Apply directly onto acne spots or inflamed blemishes. Leave on for 15-20 minutes, then rinse gently with lukewarm water.',
    dosage: 'Apply once daily in the evening until inflammation calms.',
    precautions: [
      'Perform patch test on inner wrist before applying to facial skin.',
      'Do not apply directly into open bleeding wounds or eyes.',
    ],
    category: 'Skin',
    timeToPrepare: '8 mins',
  ),
  const Remedy(
    id: 'remedy_pure_aloe_gel',
    condition: 'Skin Irritation & Sunburn',
    title: 'Pure Soothing Aloe Gel Compress',
    primaryPlantName: 'Aloe Vera',
    primaryPlantScientific: 'Aloe barbadensis miller',
    plantId: 'aloe_vera_plant',
    ingredients: [
      '2 tbsp fresh clear inner Aloe Vera fillet',
      '1 tsp pure rosewater',
    ],
    preparationSteps: [
      'Extract clear inner gel, ensuring no yellow margin is included.',
      'Mash or blend with rosewater until silky smooth.',
      'Chill in refrigerator for 10 minutes.',
    ],
    howToUse:
        'Spread cool gel generously over irritated, dry, or sunburned skin.',
    dosage: 'Apply 2-3 times daily as soothing relief.',
    precautions: [
      'For external dermatological use only.',
    ],
    category: 'Skin',
    timeToPrepare: '10 mins',
  ),
  const Remedy(
    id: 'remedy_neem_leaf_wash',
    condition: 'Skin Infections & Dandruff',
    title: 'Antiseptic Neem Leaf Cleansing Wash',
    primaryPlantName: 'Neem',
    primaryPlantScientific: 'Azadirachta indica',
    plantId: 'neem_plant',
    ingredients: [
      'A handful (20-25) of fresh Neem leaves',
      '1 liter clean water',
    ],
    preparationSteps: [
      'Boil neem leaves in water for 10-12 minutes until water turns greenish.',
      'Strain leaves and let the liquid cool completely to room temperature.',
    ],
    howToUse:
        'Use as a final hair rinse for stubborn dandruff, or as a topical antiseptic wash for itchy skin, boils, and fungal rashes.',
    dosage: 'Use 2-3 times a week after bathing.',
    precautions: [
      'Avoid contact with eyes; rinse immediately with cool water if stinging occurs.',
    ],
    category: 'Skin & Scalp',
    timeToPrepare: '15 mins',
  ),
  const Remedy(
    id: 'remedy_rosemary_joint_rub',
    condition: 'Joint & Muscle Aches',
    title: 'Warm Rosemary Joint Massage Oil',
    primaryPlantName: 'Rosemary',
    primaryPlantScientific: 'Salvia rosmarinus',
    plantId: 'rosemary_plant',
    ingredients: [
      '3 sprigs fresh rosemary bruised',
      '1/4 cup virgin coconut or sesame oil',
    ],
    preparationSteps: [
      'Warm oil gently in a double boiler.',
      'Add bruised rosemary sprigs and steep on lowest heat for 20 minutes.',
      'Strain into a clean glass jar.',
    ],
    howToUse:
        'Massage warm herbal oil into stiff joints, knees, or fatigued muscles using circular strokes.',
    dosage: 'Apply once daily before bath or before bed.',
    precautions: [
      'Ensure oil is warm, not hot, before applying to skin.',
    ],
    category: 'Joint & Muscle',
    timeToPrepare: '25 mins',
  ),
  const Remedy(
    id: 'remedy_insulin_leaf_chew',
    condition: 'Diabetes & Glucose Support',
    title: 'Costus (Insulin Plant) Morning Protocol',
    primaryPlantName: 'Insulin Plant (Fiery Costus)',
    primaryPlantScientific: 'Costus igneus',
    plantId: 'insulin_plant',
    ingredients: [
      '1-2 fresh mature Insulin Plant leaves',
      '1 glass lukewarm water',
    ],
    preparationSteps: [
      'Wash fresh leaves thoroughly in running water.',
    ],
    howToUse:
        'Chew 1 fresh leaf thoroughly on an empty stomach in the morning for the first 15 days, followed by a glass of lukewarm water.',
    dosage: '1 leaf daily in morning on empty stomach.',
    precautions: [
      'Adjuvant natural support only. Never stop or modify prescription insulin or diabetes medications without your physician.',
      'Monitor blood glucose regularly.',
    ],
    category: 'Diabetes',
    timeToPrepare: '2 mins',
  ),
  const Remedy(
    id: 'remedy_rosemary_scalp_oil',
    condition: 'Hair Fall & Scalp Health',
    title: 'Rosemary Scalp Follicle Stimulating Tonic',
    primaryPlantName: 'Rosemary',
    primaryPlantScientific: 'Salvia rosmarinus',
    plantId: 'rosemary_plant',
    ingredients: [
      '2 sprigs fresh rosemary (or 5 drops pure rosemary essential oil)',
      '2 tbsp cold-pressed jojoba or coconut oil',
    ],
    preparationSteps: [
      'Mix rosemary extract into carrier oil thoroughly.',
    ],
    howToUse:
        'Part hair and massage 5-10 drops directly into scalp with fingertips for 5 minutes. Leave on for 30-60 minutes before washing with mild shampoo.',
    dosage: 'Apply 2-3 times weekly.',
    precautions: [
      'Dilute pure essential oil properly in carrier oil before scalp application.',
    ],
    category: 'Hair & Scalp',
    timeToPrepare: '5 mins',
  ),
  const Remedy(
    id: 'remedy_bryophyllum_poultice',
    condition: 'Wound Healing & Inflammation',
    title: 'Bryophyllum Warm Leaf Poultice',
    primaryPlantName: 'Bryophyllum (Pashanbheda)',
    primaryPlantScientific: 'Bryophyllum pinnatum',
    plantId: 'bryophyllum_plant',
    ingredients: [
      '2 thick fleshy Bryophyllum leaves',
      'Few drops pure castor oil or ghee',
    ],
    preparationSteps: [
      'Wash leaves and lightly smear one side with ghee or castor oil.',
      'Gently warm the leaf over a low flame or hot pan until pliable.',
    ],
    howToUse:
        'Apply the warm leaf directly over closed bruises, sprains, or minor skin swellings and bind with a clean gauze.',
    dosage: 'Apply once daily for 30 minutes.',
    precautions: [
      'Do not place over deep infected or open puncture wounds.',
    ],
    category: 'Skin & Bruises',
    timeToPrepare: '5 mins',
  ),
  const Remedy(
    id: 'remedy_ayapana_infusion',
    condition: 'Stomach Cramps & Bleeding Cuts',
    title: 'Ayapana Soothing Leaf Decoction',
    primaryPlantName: 'Ayapana',
    primaryPlantScientific: 'Ayapana triplinervis',
    plantId: 'ayapana_plant',
    ingredients: [
      '4-5 fresh Ayapana leaves',
      '1.5 cups clean water',
    ],
    preparationSteps: [
      'Wash and crush leaves gently.',
      'Boil in water for 5 minutes until water takes a pale tint.',
      'Strain into a cup.',
    ],
    howToUse:
        'Sip warm to alleviate stomach cramps and indigestion, or use cool crushed leaf pulp as traditional hemostatic poultice for minor surface scrapes.',
    dosage: '1 cup once daily.',
    precautions: [
      'Do not use during pregnancy.',
    ],
    category: 'Mild Indigestion',
    timeToPrepare: '7 mins',
  ),
  const Remedy(
    id: 'remedy_clocimum_steam',
    condition: 'Cough & Sinus Congestion',
    title: 'Clocimum (Clove Basil) Therapeutic Steam',
    primaryPlantName: 'Clocimum (Clove Basil)',
    primaryPlantScientific: 'Ocimum gratissimum',
    plantId: 'clocimum_plant',
    ingredients: [
      '8-10 fresh Clocimum leaves',
      '1 liter boiling water',
    ],
    preparationSteps: [
      'Bruise eugenol-rich leaves and immerse in boiling water.',
    ],
    howToUse:
        'Inhale vapors with a towel tent over the head for 5-7 minutes to relieve chest and sinus heaviness.',
    dosage: 'Once daily during congestion.',
    precautions: [
      'Keep eyes closed to avoid eugenol vapor irritation.',
    ],
    category: 'Cold',
    timeToPrepare: '5 mins',
  ),
];
