import os
import torch

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

# Directory structure
DATASET_DIR = os.path.join(BASE_DIR, "dataset")
RAW_DIR = os.path.join(DATASET_DIR, "raw")
TRAIN_DIR = os.path.join(DATASET_DIR, "train")
VAL_DIR = os.path.join(DATASET_DIR, "val")
CHECKPOINTS_DIR = os.path.join(BASE_DIR, "checkpoints")
EXPORTS_DIR = os.path.join(BASE_DIR, "exports")

# Create essential directories
for d in [DATASET_DIR, RAW_DIR, TRAIN_DIR, VAL_DIR, CHECKPOINTS_DIR, EXPORTS_DIR]:
    os.makedirs(d, exist_ok=True)

# 13 Target Medicinal Plants specification
PLANT_SPECIES = [
    {
        "class_id": 0,
        "slug": "ashwagandha",
        "common_name": "Ashwagandha",
        "botanical_name": "Withania somnifera",
        "inaturalist_taxa": ["Withania somnifera", "Withania"],
        "search_queries": [
            "Withania somnifera leaf plant",
            "Ashwagandha medicinal plant leaves",
            "Withania somnifera foliage close up"
        ]
    },
    {
        "class_id": 1,
        "slug": "ayapana",
        "common_name": "Ayapana",
        "botanical_name": "Ayapana triplinervis",
        "inaturalist_taxa": ["Ayapana triplinervis", "Eupatorium triplinerve", "Ayapana"],
        "search_queries": [
            "Ayapana triplinervis plant",
            "Eupatorium ayapana leaf medicinal",
            "Ayapana herbal leaf"
        ]
    },
    {
        "class_id": 2,
        "slug": "gotu_kola",
        "common_name": "Gotu Kola",
        "botanical_name": "Centella asiatica",
        "inaturalist_taxa": ["Centella asiatica"],
        "search_queries": [
            "Centella asiatica leaf",
            "Gotu Kola plant leaves close up",
            "Centella asiatica medicinal herb"
        ]
    },
    {
        "class_id": 3,
        "slug": "rosemary",
        "common_name": "Rosemary",
        "botanical_name": "Salvia rosmarinus",
        "inaturalist_taxa": ["Salvia rosmarinus", "Rosmarinus officinalis"],
        "search_queries": [
            "Salvia rosmarinus plant foliage",
            "Rosemary herb fresh leaves",
            "Rosmarinus officinalis leaf sprig"
        ]
    },
    {
        "class_id": 4,
        "slug": "wood_apple",
        "common_name": "Wood Apple",
        "botanical_name": "Limonia acidissima",
        "inaturalist_taxa": ["Limonia acidissima", "Aegle marmelos"],
        "search_queries": [
            "Limonia acidissima leaves",
            "Wood apple tree leaves close up",
            "Aegle marmelos Bael leaf plant"
        ]
    },
    {
        "class_id": 5,
        "slug": "moringa",
        "common_name": "Moringa",
        "botanical_name": "Moringa oleifera",
        "inaturalist_taxa": ["Moringa oleifera"],
        "search_queries": [
            "Moringa oleifera leaves close up",
            "Drumstick tree leaf branch",
            "Moringa plant foliage"
        ]
    },
    {
        "class_id": 6,
        "slug": "tulsi",
        "common_name": "Tulsi",
        "botanical_name": "Ocimum tenuiflorum",
        "inaturalist_taxa": ["Ocimum tenuiflorum", "Ocimum sanctum"],
        "search_queries": [
            "Ocimum tenuiflorum Holy basil leaves",
            "Tulsi plant foliage medicinal",
            "Ocimum sanctum fresh leaf"
        ]
    },
    {
        "class_id": 7,
        "slug": "neem",
        "common_name": "Neem",
        "botanical_name": "Azadirachta indica",
        "inaturalist_taxa": ["Azadirachta indica"],
        "search_queries": [
            "Azadirachta indica leaves",
            "Neem tree foliage close up",
            "Neem medicinal leaf branch"
        ]
    },
    {
        "class_id": 8,
        "slug": "aloe_vera",
        "common_name": "Aloe Vera",
        "botanical_name": "Aloe barbadensis",
        "inaturalist_taxa": ["Aloe vera", "Aloe barbadensis"],
        "search_queries": [
            "Aloe barbadensis plant succulent leaves",
            "Aloe vera plant top view",
            "Fresh Aloe vera medicinal leaf"
        ]
    },
    {
        "class_id": 9,
        "slug": "multi_vitamin_plant",
        "common_name": "Multi Vitamin Plant",
        "botanical_name": "Sauropus androgynus",
        "inaturalist_taxa": ["Sauropus androgynus", "Breynia androgyna"],
        "search_queries": [
            "Sauropus androgynus plant leaves",
            "Katuk leaves Chakra Muni plant",
            "Multi vitamin plant green leaves"
        ]
    },
    {
        "class_id": 10,
        "slug": "amla",
        "common_name": "Amla",
        "botanical_name": "Phyllanthus emblica",
        "inaturalist_taxa": ["Phyllanthus emblica"],
        "search_queries": [
            "Phyllanthus emblica leaves branch",
            "Indian gooseberry tree foliage",
            "Amla leaf pinnate pattern"
        ]
    },
    {
        "class_id": 11,
        "slug": "brahmi",
        "common_name": "Brahmi",
        "botanical_name": "Bacopa monnieri",
        "inaturalist_taxa": ["Bacopa monnieri"],
        "search_queries": [
            "Bacopa monnieri herb leaves",
            "Water hyssop Brahmi plant",
            "Bacopa monnieri foliage close up"
        ]
    },
    {
        "class_id": 12,
        "slug": "sarpagandha",
        "common_name": "Sarpagandha",
        "botanical_name": "Rauvolfia serpentina",
        "inaturalist_taxa": ["Rauvolfia serpentina"],
        "search_queries": [
            "Rauvolfia serpentina plant leaves",
            "Sarpagandha medicinal herb foliage",
            "Indian snakeroot leaves"
        ]
    }
]

CLASS_NAMES = [p["slug"] for p in PLANT_SPECIES]
NUM_CLASSES = len(CLASS_NAMES)

# Model Training Configuration
IMAGE_SIZE = 224
BATCH_SIZE = 32
NUM_WORKERS = 2
LEARNING_RATE = 3e-4
WEIGHT_DECAY = 1e-4
LABEL_SMOOTHING = 0.1
EPOCHS = 25
TRAIN_VAL_SPLIT = 0.80  # 80% train, 20% validation

# Compute device
DEVICE = torch.device("cuda" if torch.cuda.is_available() else "cpu")
