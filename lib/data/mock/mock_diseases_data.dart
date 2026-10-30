import '../models/disease_model.dart';

/// Disease and health conditions database for all 13 supported MediPlant species:
///   aloe_vera, amla, ashwagandha, ayapana, brahmi, gotu_kola, moringa,
///   multi_vitamin_plant, neem, rosemary, sarpagandha, tulsi, wood_apple
final List<Disease> mockDiseases = [
  const Disease(
    id: 'cough',
    name: 'Cough & Chest Congestion',
    category: 'Respiratory',
    description:
        'A reflex response to clear the respiratory tract of irritants, mucus, and infectious microbes. '
        'Herbal expectorants, bronchodilators, and demulcents soothe inflamed mucosal linings and facilitate '
        'productive phlegm expulsion. Tulsi, Rosemary, and Ayapana provide powerful respiratory relief.',
    symptoms: [
      'Productive chest cough with thick mucus',
      'Dry, scratchy throat tickle',
      'Chest tightness and wheezing',
      'Post-nasal drip and bronchial irritation',
    ],
    iconName: 'air',
    relatedPlantIds: [
      'tulsi',
      'rosemary',
      'ayapana',
      'moringa',
      'ashwagandha',
    ],
    homeRemedyIds: [
      'remedy_tulsi_ginger_kadha',
      'remedy_tulsi_sinus_steam',
      'remedy_rosemary_steam_inhalation',
    ],
    medicalDisclaimer:
        'This information is for educational purposes only. Always consult a qualified physician '
        'if coughing persists beyond 7 days, produces blood, or is accompanied by high fever.',
  ),

  const Disease(
    id: 'cold',
    name: 'Common Cold & Upper Respiratory Virus',
    category: 'Respiratory',
    description:
        'Viral infection of the upper respiratory tract causing mucosal congestion, sneezing, '
        'rhinorrhea, low-grade fever, and general fatigue. Antiviral, warming adaptogenic herbs '
        'stimulate phagocytosis, clear nasal passageways, and truncate symptom duration.',
    symptoms: [
      'Runny or blocked nasal passages',
      'Frequent sneezing and sinus heaviness',
      'Throat soreness and swallowing discomfort',
      'Mild feverish sensation and body aches',
    ],
    iconName: 'ac_unit',
    relatedPlantIds: [
      'tulsi',
      'amla',
      'rosemary',
      'ashwagandha',
      'ayapana',
    ],
    homeRemedyIds: [
      'remedy_tulsi_ginger_kadha',
      'remedy_amla_immunity_elixir',
      'remedy_rosemary_steam_inhalation',
    ],
    medicalDisclaimer:
        'Herbal remedies support immune recovery. Seek medical attention if you experience '
        'difficulty breathing, severe chest pain, or symptoms lasting over 10 days.',
  ),

  const Disease(
    id: 'indigestion',
    name: 'Indigestion, Gastric Acidity & Dyspepsia',
    category: 'Digestion',
    description:
        'Gastrointestinal distress characterized by epigastric burning, acid regurgitation, bloating, '
        'and delayed gastric emptying. Cooling mucilaginous plants and carminatives restore the stomach’s '
        'protective mucosal barrier, neutralize excess hydrochloric acid, and soothe irritation.',
    symptoms: [
      'Epigastric fullness and burning heartburn',
      'Sour acid eructation after eating',
      'Abdominal distention, bloating, and gas',
      'Mild nausea or sluggish morning appetite',
    ],
    iconName: 'restaurant',
    relatedPlantIds: [
      'wood_apple',
      'aloe_vera',
      'ayapana',
      'amla',
      'tulsi',
    ],
    homeRemedyIds: [
      'remedy_wood_apple_sharbat',
      'remedy_aloe_vera_digestive_juice',
      'remedy_ayapana_digestive_infusion',
    ],
    medicalDisclaimer:
        'Chronic recurrent heartburn may indicate GERD or peptic ulcer disease. '
        'Consult a gastroenterologist if symptoms persist or interfere with nutrition.',
  ),

  const Disease(
    id: 'stress_anxiety',
    name: 'Chronic Stress, Anxiety & Adrenal Fatigue',
    category: 'Stress & Mental Wellness',
    description:
        'Protracted nervous system overdrive mediated by elevated hypothalamic-pituitary-adrenal (HPA) '
        'axis activation and cortisol surges. Adaptogenic and nervine herbs modulate GABA and serotonin '
        'pathways, restore adrenal equilibrium, and promote calm focus without sedation.',
    symptoms: [
      'Restless, racing thoughts and nervous tension',
      'Chronic daytime fatigue and brain fog',
      'Palpitations and muscle tightness in neck/shoulders',
      'Difficulty falling asleep and fragmented sleep',
    ],
    iconName: 'self_improvement',
    relatedPlantIds: [
      'ashwagandha',
      'brahmi',
      'gotu_kola',
      'sarpagandha',
      'tulsi',
    ],
    homeRemedyIds: [
      'remedy_ashwagandha_moon_milk',
      'remedy_brahmi_memory_ghee',
      'remedy_gotu_kola_memory_salad',
      'remedy_sarpagandha_bp_infusion',
    ],
    medicalDisclaimer:
        'Adaptogens provide natural emotional and nervous system balance. '
        'Severe panic disorders or clinical depression require comprehensive psychiatric evaluation.',
  ),

  const Disease(
    id: 'skin_acne',
    name: 'Acne, Skin Inflammation & Blemishes',
    category: 'Skin',
    description:
        'Inflammatory follicular obstruction driven by sebum hypersecretion, Propionibacterium acnes '
        'colonization, and cutaneous microbial imbalance. Potent antibacterial limonoids and soothing '
        'aloe acemannan reduce redness, accelerate healing, and clear cystic outbreaks without scarring.',
    symptoms: [
      'Red, tender inflammatory papules and pustules',
      'Excess facial oiliness and clogged pores',
      'Persistent post-inflammatory hyperpigmentation',
      'Irritated, itchy dermal flare-ups',
    ],
    iconName: 'spa',
    relatedPlantIds: [
      'neem',
      'aloe_vera',
      'ayapana',
      'gotu_kola',
      'amla',
    ],
    homeRemedyIds: [
      'remedy_neem_acne_paste',
      'remedy_aloe_vera_burn_gel',
      'remedy_neem_antiseptic_wash',
    ],
    medicalDisclaimer:
        'Perform a patch test before topical facial application. '
        'Severe nodulocystic acne may require evaluation by a board-certified dermatologist.',
  ),

  const Disease(
    id: 'hair_thinning',
    name: 'Hair Loss, Dandruff & Follicle Weakness',
    category: 'Hair & Scalp',
    description:
        'Androgenetic follicle miniaturization, microvascular circulatory sluggishness, and fungal '
        'Malassezia scalp overgrowth leading to thinning and flaking. Rosemary carnosic acid and Amla '
        'polyphenols stimulate follicle microcirculation, arrest hair fall, and restore hair luster.',
    symptoms: [
      'Excessive daily hair shedding during brushing/washing',
      'Itchy scalp with visible dry or greasy flakes',
      'Gradual widening of hair parting and scalp visibility',
      'Dry, brittle hair shafts prone to breakage',
    ],
    iconName: 'brush',
    relatedPlantIds: [
      'rosemary',
      'amla',
      'neem',
      'aloe_vera',
    ],
    homeRemedyIds: [
      'remedy_rosemary_hair_growth_tonic',
      'remedy_amla_hair_oil',
      'remedy_neem_antiseptic_wash',
    ],
    medicalDisclaimer:
        'Topical herbal hair rinses promote follicular vitality. Consult a trichologist or doctor '
        'to rule out underlying thyroid disorders, severe nutritional deficiencies, or autoimmune alopecia.',
  ),

  const Disease(
    id: 'low_immunity',
    name: 'Nutritional Depletion & Low Immunity',
    category: 'Immunity & Nutrition',
    description:
        'Susceptibility to recurrent opportunistic infections, chronic daytime fatigue, and micronutrient '
        'deficiencies (vitamins A, B, C, iron, and bioavailable antioxidants). Botanical superfoods '
        'restore cellular micronutrient stores and stimulate natural killer cell activity.',
    symptoms: [
      'Recurrent seasonal infections and prolonged recovery',
      'Sluggish vitality, brain fatigue, and low stamina',
      'Pale nail beds, brittle hair, and micro-nutritional anemia',
      'General feeling of burnout and low vitality',
    ],
    iconName: 'shield',
    relatedPlantIds: [
      'amla',
      'moringa',
      'multi_vitamin_plant',
      'tulsi',
      'ashwagandha',
    ],
    homeRemedyIds: [
      'remedy_amla_immunity_elixir',
      'remedy_moringa_green_soup',
      'remedy_multivitamin_daily_greens',
      'remedy_ashwagandha_moon_milk',
    ],
    medicalDisclaimer:
        'Botanical superfoods provide whole-food cellular replenishment. '
        'Confirm nutritional status through routine blood panels if anemia or extreme lethargy persists.',
  ),

  const Disease(
    id: 'hypertension',
    name: 'High Blood Pressure & Arterial Stress',
    category: 'Cardiovascular',
    description:
        'Elevated systemic vascular resistance and hyperactive sympathetic nervous tone predisposing '
        'to cardiovascular strain. Rauvolfia reserpine and Moringa isothiocyanates promote peripheral '
        'arterial vasodilation, reduce cardiac workload, and restore autonomic tranquility.',
    symptoms: [
      'Occipital morning headaches and neck tightness',
      'Occasional lightheadedness and blurred vision',
      'Tense inner restlessness and bounding pulse',
      'Elevated sphygmomanometer readings (> 130/80 mmHg)',
    ],
    iconName: 'favorite',
    relatedPlantIds: [
      'sarpagandha',
      'moringa',
      'gotu_kola',
      'tulsi',
    ],
    homeRemedyIds: [
      'remedy_sarpagandha_bp_infusion',
      'remedy_moringa_green_soup',
      'remedy_gotu_kola_memory_salad',
    ],
    medicalDisclaimer:
        'Hypertension is a serious medical condition requiring ongoing clinical monitoring. '
        'Never stop prescribed cardiovascular medications without direct physician consultation.',
  ),

  const Disease(
    id: 'memory_decline',
    name: 'Memory Loss, Brain Fog & Study Fatigue',
    category: 'Neurological & Cognitive',
    description:
        'Suboptimal neurotransmitter signaling, synaptic oxidation, and mental exhaustion affecting '
        'concentration, executive function, and long-term memory recall. Traditional Medhya Rasayanas '
        'repair dendrite branching, elevate brain-derived neurotrophic factor (BDNF), and sharpen intellect.',
    symptoms: [
      'Difficulty recalling names, details, and recent information',
      'Sluggish mental processing speed and poor concentration',
      'Brain fog during prolonged work or academic study',
      'Mental exhaustion and difficulty focusing under pressure',
    ],
    iconName: 'psychology',
    relatedPlantIds: [
      'brahmi',
      'gotu_kola',
      'rosemary',
      'ashwagandha',
    ],
    homeRemedyIds: [
      'remedy_brahmi_memory_ghee',
      'remedy_gotu_kola_memory_salad',
      'remedy_rosemary_hair_growth_tonic',
    ],
    medicalDisclaimer:
        'Nootropic herbs support cognitive retention and focus. '
        'Progressive memory deterioration in older adults should be evaluated by a neurologist.',
  ),

  const Disease(
    id: 'diarrhea',
    name: 'Diarrhea, Dysentery & Loose Stools',
    category: 'Digestion',
    description:
        'Acute or chronic intestinal hypermotility with excessive water loss and mucosal inflammation '
        'triggered by food contamination or enterotoxins. Wood apple (Bael) tannins and Ayapana '
        'coumarins bind the intestinal mucosa, inhibit fluid hypersecretion, and eliminate pathogens.',
    symptoms: [
      'Frequent watery or loose bowel movements',
      'Lower abdominal cramping and tenesmus',
      'Dehydration, dry mouth, and electrolyte weakness',
      'Intestinal rumbling and urgency',
    ],
    iconName: 'water_drop',
    relatedPlantIds: [
      'wood_apple',
      'ayapana',
    ],
    homeRemedyIds: [
      'remedy_wood_apple_diarrhea_decoction',
      'remedy_wood_apple_sharbat',
      'remedy_ayapana_digestive_infusion',
    ],
    medicalDisclaimer:
        'Oral rehydration therapy with water and electrolytes is critical during diarrhea. '
        'Seek immediate emergency medical care if blood appears in stools or if signs of severe dehydration develop.',
  ),

  const Disease(
    id: 'wounds_cuts',
    name: 'Cuts, Superficial Wounds & Bleeding',
    category: 'First Aid & Dermal Care',
    description:
        'Mechanical breaks in the cutaneous skin barrier accompanied by capillary bleeding and risk '
        'of secondary bacterial invasion. Fast-acting hemostatic herbs (Ayapana) and cell-proliferating '
        'botanicals (Aloe Vera, Gotu Kola) arrest bleeding and accelerate tissue regeneration.',
    symptoms: [
      'Active minor bleeding from skin lacerations',
      'Pain, stinging, and localized inflammation',
      'Bruising, abrasions, and scrape marks',
      'Delayed wound granulation and healing',
    ],
    iconName: 'healing',
    relatedPlantIds: [
      'ayapana',
      'aloe_vera',
      'neem',
      'gotu_kola',
    ],
    homeRemedyIds: [
      'remedy_ayapana_wound_poultice',
      'remedy_aloe_vera_burn_gel',
      'remedy_neem_acne_paste',
    ],
    medicalDisclaimer:
        'Clean all wounds thoroughly with potable water before herbal poultice application. '
        'Deep puncture wounds, arterial bleeding, or animal bites require immediate hospital emergency treatment and tetanus prophylaxis.',
  ),

  const Disease(
    id: 'insomnia',
    name: 'Insomnia & Fragmented Sleep',
    category: 'Stress & Mental Wellness',
    description:
        'Inability to initiate or maintain restorative nocturnal sleep due to hyperarousal of the '
        'central nervous system. Gentle herbal hypnotics and GABA-enhancers induce natural drowsiness, '
        'reduce nighttime awakenings, and restore healthy circadian rhythm architectures.',
    symptoms: [
      'Lying awake for over 30 minutes struggling to sleep',
      'Frequent midnight awakenings with racing mind',
      'Non-restorative sleep leading to unrefreshed mornings',
      'Daytime drowsiness and mood irritability',
    ],
    iconName: 'bedtime',
    relatedPlantIds: [
      'ashwagandha',
      'sarpagandha',
      'brahmi',
    ],
    homeRemedyIds: [
      'remedy_ashwagandha_moon_milk',
      'remedy_sarpagandha_bp_infusion',
      'remedy_brahmi_memory_ghee',
    ],
    medicalDisclaimer:
        'Herbal sleep tonics promote natural neurochemical relaxation. '
        'Chronic insomnia accompanied by sleep apnea or severe mood disorders requires clinical evaluation.',
  ),
];
