import '../models/disease_model.dart';

/// Mock dataset for common illnesses and health conditions
final List<Disease> mockDiseases = [
  const Disease(
    id: 'cough',
    name: 'Cough & Chest Congestion',
    category: 'Respiratory',
    description:
        'A reflex response to clear the respiratory tract of irritants, mucus, and infectious microbes. Herbal expectorants and demulcents help soothe irritated throat tissue and facilitate phlegm expulsion.',
    symptoms: [
      'Dry or productive cough',
      'Chest tightness or heaviness',
      'Throat tickle and irritation',
      'Post-nasal drip',
    ],
    iconName: 'air',
    relatedPlantIds: ['tulsi_plant', 'malabar_nut_plant', 'clocimum_plant', 'cinnamon_plant', 'gotu_kola_plant'],
    homeRemedyIds: ['remedy_tulsi_ginger_tea', 'remedy_malabar_nut_decoction', 'remedy_cinnamon_honey_tea'],
    medicalDisclaimer:
        'This information is for educational purposes only. Always consult a qualified healthcare professional for diagnosis and treatment of persistent or severe cough.',
  ),
  const Disease(
    id: 'cold',
    name: 'Common Cold & Flu',
    category: 'Respiratory',
    description:
        'A viral infection of the upper respiratory tract causing nasal blockage, sneezing, malaise, and mild fever. Supportive natural herbs stimulate immunity and clear nasal congestion.',
    symptoms: [
      'Runny or stuffy nose',
      'Sneezing and sinus pressure',
      'Mild feverish feeling and chills',
      'Body fatigue',
    ],
    iconName: 'ac_unit',
    relatedPlantIds: ['tulsi_plant', 'cinnamon_plant', 'gotu_kola_plant', 'rosemary_plant', 'ayapana_plant'],
    homeRemedyIds: ['remedy_kadha_decoction', 'remedy_tulsi_ginger_tea', 'remedy_cinnamon_honey_tea'],
    medicalDisclaimer:
        'This information is for educational purposes only. Seek medical attention if flu symptoms are severe, worsen rapidly, or persist beyond 7 days.',
  ),
  const Disease(
    id: 'sore_throat',
    name: 'Sore Throat & Pharyngitis',
    category: 'Respiratory',
    description:
        'Painful inflammation of the pharyngeal mucosa causing scratchiness, swallowing pain, and hoarseness. Natural demulcents and antimicrobials soothe the mucosal lining.',
    symptoms: [
      'Pain when swallowing',
      'Dry, scratchy throat feeling',
      'Hoarseness of voice',
      'Mildly swollen tonsils',
    ],
    iconName: 'record_voice_over',
    relatedPlantIds: ['tulsi_plant', 'cinnamon_plant', 'clocimum_plant', 'ayapana_plant', 'tooth_ache_plant'],
    homeRemedyIds: ['remedy_tulsi_honey_chew', 'remedy_tooth_ache_gargle', 'remedy_cinnamon_honey_tea'],
    medicalDisclaimer:
        'This information is for educational purposes only. See a doctor if sore throat is severe, accompanied by high fever, or lasts more than 5-7 days.',
  ),
  const Disease(
    id: 'indigestion',
    name: 'Indigestion, Gas & Acid Reflux',
    category: 'Digestive',
    description:
        'Discomfort in the upper abdomen characterized by bloating, fullness, burping, and acid sensation. Carminative and digestive herbs help regulate gastric motility and enzyme secretion.',
    symptoms: [
      'Upper abdominal bloating',
      'Burning sensation in chest or throat',
      'Excess gas and flatulence',
      'Post-meal heaviness and nausea',
    ],
    iconName: 'restaurant',
    relatedPlantIds: ['aloe_vera_plant', 'wood_apple_plant', 'methi_plant', 'cinnamon_plant', 'ayapana_plant'],
    homeRemedyIds: ['remedy_aloe_vera_juice', 'remedy_wood_apple_digestive', 'remedy_methi_seed_water'],
    medicalDisclaimer:
        'This information is for educational purposes only. Consult a doctor for persistent acid reflux or suspected peptic ulcers.',
  ),
  const Disease(
    id: 'headache',
    name: 'Tension Headache & Stress',
    category: 'Neurological',
    description:
        'Mild to moderate diffuse ache or pressure around the temples, forehead, and neck muscles caused by mental stress, eye strain, or muscular tension.',
    symptoms: [
      'Dull, aching head pain',
      'Tightness across forehead or back of head',
      'Tenderness in scalp, neck, and shoulder muscles',
      'Fatigue and irritability',
    ],
    iconName: 'psychology',
    relatedPlantIds: ['gotu_kola_plant', 'rosemary_plant', 'ylang_ylang_plant', 'tulsi_plant', 'patchouli_plant'],
    homeRemedyIds: ['remedy_gotu_kola_tea', 'remedy_ylang_ylang_aroma', 'remedy_rosemary_steam'],
    medicalDisclaimer:
        'This information is for educational purposes only. Sudden severe headache, vision changes, or neurological symptoms require emergency medical care.',
  ),
  const Disease(
    id: 'skin_acne',
    name: 'Acne, Eczema & Skin Irritations',
    category: 'Dermatological',
    description:
        'Cutaneous inflammation, breakouts, or dry itchy patches caused by bacterial overgrowth, oxidative stress, or compromised barrier function.',
    symptoms: [
      'Inflammatory pimples or blemishes',
      'Redness, itching, and scaling',
      'Sunburn erythema',
      'Dry or cracked skin patches',
    ],
    iconName: 'face',
    relatedPlantIds: ['neem_plant', 'aloe_vera_plant', 'patchouli_plant', 'bryophyllum_plant', 'rosemary_plant'],
    homeRemedyIds: ['remedy_neem_turmeric_paste', 'remedy_pure_aloe_gel', 'remedy_neem_leaf_wash'],
    medicalDisclaimer:
        'This information is for educational purposes only. Severe or widespread skin conditions should be evaluated by a dermatologist.',
  ),
  const Disease(
    id: 'anxiety_sleep',
    name: 'Insomnia, Anxiety & Fatigue',
    category: 'Mental Wellness',
    description:
        'Difficulty initiating or maintaining restful sleep accompanied by daytime restlessness, elevated cortisol, and mental hyperactivity.',
    symptoms: [
      'Trouble falling asleep',
      'Frequent nighttime awakenings',
      'Racing thoughts and mental tension',
      'Chronic daytime tiredness',
    ],
    iconName: 'bedtime',
    relatedPlantIds: ['ylang_ylang_plant', 'gotu_kola_plant', 'tulsi_plant', 'patchouli_plant', 'rosemary_plant'],
    homeRemedyIds: ['remedy_ylang_ylang_aroma', 'remedy_gotu_kola_tea', 'remedy_tulsi_honey_chew'],
    medicalDisclaimer:
        'This information is for educational purposes only. Persistent insomnia or severe anxiety disorders require professional mental health evaluation.',
  ),
  const Disease(
    id: 'joint_pain',
    name: 'Joint Stiffness & Arthritis',
    category: 'Musculoskeletal',
    description:
        'Chronic or exertion-induced joint inflammation, stiffness, and reduced mobility. Polyphenolic herbs inhibit inflammatory enzymes and protect cartilage.',
    symptoms: [
      'Morning joint stiffness',
      'Aching knees, wrists, or hips',
      'Localized mild swelling',
      'Reduced range of motion',
    ],
    iconName: 'accessibility_new',
    relatedPlantIds: ['rosemary_plant', 'methi_plant', 'cinnamon_plant', 'garden_rue_plant', 'gotu_kola_plant'],
    homeRemedyIds: ['remedy_rosemary_joint_rub', 'remedy_methi_seed_water', 'remedy_cinnamon_honey_tea'],
    medicalDisclaimer:
        'This information is for educational purposes only. Rheumatoid arthritis and severe osteoarthritis require qualified medical management.',
  ),
  const Disease(
    id: 'fever_immunity',
    name: 'Seasonal Fever & Weak Immunity',
    category: 'Immunity',
    description:
        'Elevated body temperature during viral seasons or recurring infections signaling a need for natural immunomodulators and antipyretics.',
    symptoms: [
      'Elevated body temperature',
      'Generalized body aches',
      'Loss of appetite and lethargy',
      'Susceptibility to recurrent infections',
    ],
    iconName: 'shield',
    relatedPlantIds: ['tulsi_plant', 'neem_plant', 'ayapana_plant', 'gotu_kola_plant', 'multi_vitamin_plant'],
    homeRemedyIds: ['remedy_kadha_decoction', 'remedy_tulsi_ginger_tea', 'remedy_gotu_kola_tea'],
    medicalDisclaimer:
        'This information is for educational purposes only. High or persistent fever requires prompt medical evaluation and appropriate diagnosis.',
  ),
  const Disease(
    id: 'diabetes',
    name: 'Blood Sugar & Diabetes Management',
    category: 'Metabolic',
    description:
        'Elevated fasting or postprandial blood glucose levels requiring dietary and lifestyle management. Certain medicinal plants contain bioactive compounds that support insulin sensitivity and glycemic regulation as adjuvant therapy.',
    symptoms: [
      'Excessive thirst and frequent urination',
      'Unexplained fatigue and weakness',
      'Slow wound healing',
      'Blurred vision and frequent infections',
    ],
    iconName: 'monitor_heart',
    relatedPlantIds: ['insulin_plant', 'methi_plant', 'cinnamon_plant', 'neem_plant', 'wood_apple_plant'],
    homeRemedyIds: ['remedy_methi_seed_water', 'remedy_insulin_leaf_chew', 'remedy_cinnamon_honey_tea'],
    medicalDisclaimer:
        'IMPORTANT: These plants are supportive adjuvants only. Never replace prescribed diabetes medication without physician guidance. Monitor blood glucose closely.',
  ),
  const Disease(
    id: 'dental_oral',
    name: 'Toothache & Oral Health',
    category: 'Dental',
    description:
        'Dental pain from cavities, gum inflammation, or abscess combined with oral hygiene challenges. Natural antimicrobial and analgesic herbs provide symptomatic relief while professional dental care is arranged.',
    symptoms: [
      'Sharp or throbbing toothache',
      'Gum swelling or bleeding',
      'Bad breath (halitosis)',
      'Tooth sensitivity to temperature',
    ],
    iconName: 'dentistry',
    relatedPlantIds: ['tooth_ache_plant', 'neem_plant', 'clocimum_plant', 'cinnamon_plant', 'tulsi_plant'],
    homeRemedyIds: ['remedy_tooth_ache_gargle', 'remedy_neem_leaf_wash', 'remedy_cinnamon_honey_tea'],
    medicalDisclaimer:
        'This information is for educational purposes only. Toothache may indicate serious dental infection. Visit a dentist promptly — herbal remedies provide only temporary relief.',
  ),
  const Disease(
    id: 'hair_scalp',
    name: 'Hair Loss & Scalp Health',
    category: 'Dermatological',
    description:
        'Excessive hair shedding, dandruff, or scalp inflammation due to stress, nutritional deficiency, or hormonal imbalance. Herbal scalp treatments nourish follicles and combat microbial scalp conditions.',
    symptoms: [
      'Excessive hair shedding or thinning',
      'Visible scalp flaking (dandruff)',
      'Itchy or inflamed scalp',
      'Weak, brittle hair texture',
    ],
    iconName: 'spa',
    relatedPlantIds: ['rosemary_plant', 'neem_plant', 'patchouli_plant', 'aloe_vera_plant', 'ylang_ylang_plant'],
    homeRemedyIds: ['remedy_rosemary_scalp_oil', 'remedy_neem_leaf_wash', 'remedy_pure_aloe_gel'],
    medicalDisclaimer:
        'This information is for educational purposes only. Sudden or severe hair loss should be evaluated by a dermatologist or trichologist for underlying causes.',
  ),
];
