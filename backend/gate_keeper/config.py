import os
import torch

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

# Data directories
DATASET_DIR = os.path.join(BASE_DIR, "dataset")
RAW_PLANT_DIR = os.path.join(DATASET_DIR, "plant")
RAW_NON_PLANT_DIR = os.path.join(DATASET_DIR, "non_plant")

TRAIN_DIR = os.path.join(DATASET_DIR, "train")
VAL_DIR = os.path.join(DATASET_DIR, "val")

CHECKPOINTS_DIR = os.path.join(BASE_DIR, "checkpoints")
EXPORTS_DIR = os.path.join(BASE_DIR, "exports")

# Ensure required directories exist
for d in [CHECKPOINTS_DIR, EXPORTS_DIR]:
    os.makedirs(d, exist_ok=True)

# Binary Classes
CLASSES = ["non_plant", "plant"]
NUM_CLASSES = len(CLASSES)

# Training Hyperparameters
IMAGE_SIZE = 224
BATCH_SIZE = 32
NUM_WORKERS = 2
LEARNING_RATE = 3e-4
WEIGHT_DECAY = 1e-4
EPOCHS = 15
TRAIN_VAL_SPLIT = 0.80  # 80% train, 20% validation

# Device
DEVICE = torch.device("cuda" if torch.cuda.is_available() else "cpu")
