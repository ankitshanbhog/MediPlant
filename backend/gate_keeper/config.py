import os
import tensorflow as tf

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

DATASET_DIR = os.path.join(BASE_DIR, "dataset")
RAW_PLANT_DIR = os.path.join(DATASET_DIR, "plant")
RAW_NON_PLANT_DIR = os.path.join(DATASET_DIR, "non_plant")

TRAIN_DIR = os.path.join(DATASET_DIR, "train")
VAL_DIR = os.path.join(DATASET_DIR, "val")

CHECKPOINTS_DIR = os.path.join(BASE_DIR, "checkpoints")
EXPORTS_DIR = os.path.join(BASE_DIR, "exports")

for d in [CHECKPOINTS_DIR, EXPORTS_DIR]:
    os.makedirs(d, exist_ok=True)

CLASSES = ["non_plant", "plant"]
NUM_CLASSES = len(CLASSES)

IMAGE_SIZE = 224
BATCH_SIZE = 32
NUM_WORKERS = 2
LEARNING_RATE = 3e-4
WEIGHT_DECAY = 1e-4
EPOCHS = 15
TRAIN_VAL_SPLIT = 0.80

DEVICE = "GPU" if len(tf.config.list_physical_devices("GPU")) > 0 else "CPU"
