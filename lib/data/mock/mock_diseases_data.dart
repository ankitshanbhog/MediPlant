import '../models/disease_model.dart';

/// Disease database for the MediPlant 10-class model.
/// All relatedPlantIds reference only the 10 supported plant classes:
///   ashwagandha_plant, ayapana_plant, cinnamon_plant, gotu_kola_plant,
///   insulin_plant, malabar_nut, pirandai_plant, rosemary_plant,
///   wood_apple_plant, ylang_ylang_plant
final List<Disease> mockDiseases = [
  const Disease(
    id: 'cough',
    name: 'Cough & Chest Congestion',
    category: 'Respiratory',
    description:
        'A reflex response to clear the respiratory tract of irritants, mucus, and infectious '
        'microbes. Herbal expectorants and demulcents help soothe irritated throat tissue and '
        'facilitate phlegm expulsion. Malabar Nut (Vasaka) is the gold-standard Ayurvedic herb '
        'for respiratory mucus clearance.',
    symptoms: [
      'Dry or productive cough',
      'Chest tightness or heaviness',
      'Throat tickle and irritation',
      'Post-nasal drip',
    ],
    iconName: 'air',
    relatedPlantIds: [
      'malabar_nut',
      'cinnamon_plant',
      'ayapana_plant',
      'gotu_kola_plant',
      'ashwagandha_plant',
    ],
    homeRemedyIds: [
      'remedy_malabar_nut_decoction',
      'remedy_cinnamon_honey_tea',
      'remedy_ayapana_infusion',
    ],
    medicalDisclaimer:
        'This information is for educational purposes only. Always consult a qualified healthcare '
        'professional for diagnosis and treatment of persistent or severe cough.',
  ),
  const Disease(
    id: 'cold',
    name: 'Common Cold & Flu',
    category: 'Respiratory',
    description:
        'A viral infection of the upper respiratory tract causing nasal blockage, sneezing, malaise, '
        'and mild fever. Supportive natural herbs stimulate immunity and clear nasal congestion. '
        'Ashwagandha and Cinnamon are key immunomodulatory and warming herbs for cold management.',
    symptoms: [
      'Runny or stuffy nose',
      'Sneezing and sinus pressure',
      'Mild feverish feeling and chills',
      'Body fatigue and malaise',
    ],
    iconName: 'ac_unit',
    relatedPlantIds: [
      'cinnamon_plant',
      'gotu_kola_plant',
      'rosemary_plant',
      'ayapana_plant',
      'ashwagandha_plant',
    ],
    homeRemedyIds: [
      'remedy_cinnamon_honey_tea',
      'remedy_rosemary_steam',
      'remedy_ayapana_infusion',
    ],
    medicalDisclaimer:
        'This information is for educational purposes only. Seek medical attention if flu symptoms '
        'are severe, worsen rapidly, or persist beyond 7 days.',
  ),
  const Disease(
    id: 'indigestion',
    name: 'Indigestion, Gas & Acid Reflux',
    category: 'Digestive',
    description:
        'Discomfort in the upper abdomen characterized by bloating, fullness, burping, and acid '
        'sensation. Wood Apple and Ayapana are premier digestive herbs with proven carminative '
        'and gastrointestinal soothing properties in South Asian tradition.',
    symptoms: [
      'Upper abdominal bloating',
      'Burning sensation in chest or throat',
      'Excess gas and flatulence',
      'Post-meal heaviness and nausea',
    ],
    iconName: 'restaurant',
    relatedPlantIds: [
      'wood_apple_plant',
      'ayapana_plant',
      'cinnamon_plant',
      'gotu_kola_plant',
      'insulin_plant',
    ],
    homeRemedyIds: [
      'remedy_wood_apple_digestive',
      'remedy_ayapana_infusion',
      'remedy_cinnamon_honey_tea',
    ],
    medicalDisclaimer:
        'This information is for educational purposes only. Consult a doctor for persistent '
        'acid reflux or suspected peptic ulcers.',
  ),
  const Disease(
    id: 'headache',
    name: 'Tension Headache & Stress',
    category: 'Neurological',
    description:
        'Mild to moderate diffuse ache or pressure around the temples, forehead, and neck muscles '
        'caused by mental stress, eye strain, or muscular tension. Gotu Kola, Rosemary, and '
        'Ylang Ylang are proven herbal allies for tension headache and stress-related symptoms.',
    symptoms: [
      'Dull, aching head pain',
      'Tightness across forehead or back of head',
      'Tenderness in scalp, neck, and shoulder muscles',
      'Fatigue and irritability',
    ],
    iconName: 'psychology',
    relatedPlantIds: [
      'gotu_kola_plant',
      'rosemary_plant',
      'ylang_ylang_plant',
      'ashwagandha_plant',
      'cinnamon_plant',
    ],
    homeRemedyIds: [
      'remedy_gotu_kola_tea',
      'remedy_ylang_ylang_aroma',
      'remedy_rosemary_steam',
    ],
    medicalDisclaimer:
        'This information is for educational purposes only. Sudden severe headache, vision changes, '
        'or neurological symptoms require emergency medical care.',
  ),
  const Disease(
    id: 'anxiety_sleep',
    name: 'Insomnia, Anxiety & Fatigue',
    category: 'Mental Wellness',
    description:
        'Difficulty initiating or maintaining restful sleep accompanied by daytime restlessness, '
        'elevated cortisol, and mental hyperactivity. Ashwagandha (adaptogen), Ylang Ylang '
        '(anxiolytic aroma), and Gotu Kola (nervine) form a powerful trifecta for natural '
        'stress and sleep support.',
    symptoms: [
      'Trouble falling asleep',
      'Frequent nighttime awakenings',
      'Racing thoughts and mental tension',
      'Chronic daytime tiredness and exhaustion',
    ],
    iconName: 'bedtime',
    relatedPlantIds: [
      'ashwagandha_plant',
      'ylang_ylang_plant',
      'gotu_kola_plant',
      'rosemary_plant',
      'cinnamon_plant',
    ],
    homeRemedyIds: [
      'remedy_ashwagandha_milk',
      'remedy_ylang_ylang_aroma',
      'remedy_gotu_kola_tea',
    ],
    medicalDisclaimer:
        'This information is for educational purposes only. Persistent insomnia or severe anxiety '
        'disorders require professional mental health evaluation.',
  ),
  const Disease(
    id: 'joint_pain',
    name: 'Joint Stiffness, Arthritis & Bone Health',
    category: 'Musculoskeletal',
    description:
        'Chronic or exertion-induced joint inflammation, stiffness, and reduced mobility. '
        'Pirandai (Hadjod) is the premier Ayurvedic bone-strengthening herb, while Rosemary '
        'and Cinnamon provide powerful anti-inflammatory support for arthritic joints.',
    symptoms: [
      'Morning joint stiffness and reduced mobility',
      'Aching knees, wrists, or hips',
      'Localized mild swelling and tenderness',
      'Reduced range of joint motion',
    ],
    iconName: 'accessibility_new',
    relatedPlantIds: [
      'pirandai_plant',
      'rosemary_plant',
      'cinnamon_plant',
      'gotu_kola_plant',
      'ashwagandha_plant',
    ],
    homeRemedyIds: [
      'remedy_pirandai_preparation',
      'remedy_rosemary_joint_rub',
      'remedy_cinnamon_honey_tea',
    ],
    medicalDisclaimer:
        'This information is for educational purposes only. Rheumatoid arthritis and severe '
        'osteoarthritis require qualified medical management.',
  ),
  const Disease(
    id: 'fever_immunity',
    name: 'Seasonal Fever & Weak Immunity',
    category: 'Immunity',
    description:
        'Elevated body temperature during viral seasons or recurring infections signaling a need '
        'for natural immunomodulators and antipyretics. Ashwagandha is the premier Ayurvedic '
        'immunomodulator, while Ayapana provides direct antipyretic effects.',
    symptoms: [
      'Elevated body temperature',
      'Generalized body aches and malaise',
      'Loss of appetite and lethargy',
      'Susceptibility to recurrent infections',
    ],
    iconName: 'shield',
    relatedPlantIds: [
      'ashwagandha_plant',
      'ayapana_plant',
      'gotu_kola_plant',
      'cinnamon_plant',
      'malabar_nut',
    ],
    homeRemedyIds: [
      'remedy_ashwagandha_milk',
      'remedy_ayapana_infusion',
      'remedy_cinnamon_honey_tea',
    ],
    medicalDisclaimer:
        'This information is for educational purposes only. High or persistent fever requires '
        'prompt medical evaluation and appropriate diagnosis.',
  ),
  const Disease(
    id: 'diabetes',
    name: 'Blood Sugar & Diabetes Management',
    category: 'Metabolic',
    description:
        'Elevated fasting or postprandial blood glucose levels requiring dietary and lifestyle '
        'management. The Insulin Plant (corosolic acid) and Cinnamon (cinnamaldehyde) are the '
        'two most studied botanical adjuvants for glycemic control and insulin sensitivity support.',
    symptoms: [
      'Excessive thirst and frequent urination',
      'Unexplained fatigue and weakness',
      'Slow wound healing and recurrent infections',
      'Blurred vision and frequent hunger',
    ],
    iconName: 'monitor_heart',
    relatedPlantIds: [
      'insulin_plant',
      'cinnamon_plant',
      'wood_apple_plant',
      'gotu_kola_plant',
      'ashwagandha_plant',
    ],
    homeRemedyIds: [
      'remedy_insulin_leaf_chew',
      'remedy_cinnamon_honey_tea',
      'remedy_wood_apple_digestive',
    ],
    medicalDisclaimer:
        'IMPORTANT: These plants are supportive adjuvants only. Never replace prescribed diabetes '
        'medication without physician guidance. Monitor blood glucose closely.',
  ),
  const Disease(
    id: 'hair_scalp',
    name: 'Hair Loss & Scalp Health',
    category: 'Dermatological',
    description:
        'Excessive hair shedding, dandruff, or scalp inflammation due to stress, nutritional '
        'deficiency, or hormonal imbalance. Rosemary is clinically proven to match minoxidil '
        'for androgenic hair loss, while Ylang Ylang nourishes scalp follicles.',
    symptoms: [
      'Excessive hair shedding or thinning',
      'Visible scalp flaking (dandruff)',
      'Itchy or inflamed scalp',
      'Weak, brittle, dull hair texture',
    ],
    iconName: 'spa',
    relatedPlantIds: [
      'rosemary_plant',
      'ylang_ylang_plant',
      'ashwagandha_plant',
      'gotu_kola_plant',
      'cinnamon_plant',
    ],
    homeRemedyIds: [
      'remedy_rosemary_scalp_oil',
      'remedy_ylang_ylang_aroma',
      'remedy_ashwagandha_milk',
    ],
    medicalDisclaimer:
        'This information is for educational purposes only. Sudden or severe hair loss should be '
        'evaluated by a dermatologist or trichologist for underlying causes.',
  ),
  const Disease(
    id: 'digestive_health',
    name: 'Digestive Health & Gut Microbiome',
    category: 'Digestive',
    description:
        'Gut dysbiosis, irregular bowel habits, and intestinal inflammation affect overall health '
        'and immunity. Wood Apple is a premier probiotic-promoting digestive herb, while Pirandai '
        'and Cinnamon support gut integrity and microbial balance.',
    symptoms: [
      'Irregular bowel movements or constipation',
      'Abdominal cramping and discomfort',
      'Excessive gas and intestinal bloating',
      'Loss of appetite or food aversions',
    ],
    iconName: 'restaurant_menu',
    relatedPlantIds: [
      'wood_apple_plant',
      'pirandai_plant',
      'cinnamon_plant',
      'ayapana_plant',
      'gotu_kola_plant',
    ],
    homeRemedyIds: [
      'remedy_wood_apple_digestive',
      'remedy_ayapana_infusion',
      'remedy_cinnamon_honey_tea',
    ],
    medicalDisclaimer:
        'This information is for educational purposes only. Persistent digestive issues should be '
        'evaluated by a gastroenterologist.',
  ),
  const Disease(
    id: 'skin_care',
    name: 'Skin Health & Wound Healing',
    category: 'Dermatological',
    description:
        'Cutaneous inflammation, slow-healing wounds, or dry irritated skin due to oxidative stress '
        'or microbial overgrowth. Gotu Kola is scientifically proven to accelerate wound healing '
        'and skin regeneration, while Ylang Ylang and Rosemary provide antimicrobial support.',
    symptoms: [
      'Slow-healing wounds or cuts',
      'Dry, itchy, or inflamed skin',
      'Acne breakouts or blemishes',
      'Post-wound scarring or keloids',
    ],
    iconName: 'face',
    relatedPlantIds: [
      'gotu_kola_plant',
      'ylang_ylang_plant',
      'rosemary_plant',
      'ayapana_plant',
      'cinnamon_plant',
    ],
    homeRemedyIds: [
      'remedy_gotu_kola_skin_paste',
      'remedy_ylang_ylang_aroma',
      'remedy_rosemary_scalp_oil',
    ],
    medicalDisclaimer:
        'This information is for educational purposes only. Severe or widespread skin conditions '
        'should be evaluated by a dermatologist.',
  ),
  const Disease(
    id: 'bone_health',
    name: 'Bone Health & Fracture Recovery',
    category: 'Musculoskeletal',
    description:
        'Age-related bone mineral density loss and fracture recovery are major health concerns. '
        'Pirandai (Hadjod) is the only plant with direct clinical evidence for bone healing '
        'acceleration, reducing recovery time significantly through its unique phytosterol content.',
    symptoms: [
      'Bone pain or chronic tenderness',
      'Slow fracture healing post-injury',
      'Increased susceptibility to fractures',
      'Height loss and stooped posture (osteoporosis)',
    ],
    iconName: 'accessibility_new',
    relatedPlantIds: [
      'pirandai_plant',
      'ashwagandha_plant',
      'gotu_kola_plant',
      'cinnamon_plant',
      'wood_apple_plant',
    ],
    homeRemedyIds: [
      'remedy_pirandai_preparation',
      'remedy_ashwagandha_milk',
      'remedy_cinnamon_honey_tea',
    ],
    medicalDisclaimer:
        'This information is for educational purposes only. Fractures and osteoporosis require '
        'proper medical imaging and treatment by an orthopedic specialist.',
  ),
];
