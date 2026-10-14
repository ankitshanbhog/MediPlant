
import random
import shutil
from pathlib import Path

SOURCE_DIR = Path("Dataset_All")
OUTPUT_DIR = Path("Medicinal_dataset_split")

TRAIN_RATIO = 0.70
VAL_RATIO = 0.15
TEST_RATIO = 0.15

SEED = 42
random.seed(SEED)

VALID_EXTENSIONS = {".jpg", ".jpeg", ".png", ".webp"}

if not SOURCE_DIR.exists():
    raise FileNotFoundError(f"Dataset not found: {SOURCE_DIR}")

if OUTPUT_DIR.exists():
    raise FileExistsError(
        f"{OUTPUT_DIR} already exists. Rename or remove it first."
    )

classes = sorted(
    folder for folder in SOURCE_DIR.iterdir()
    if folder.is_dir()
)

if not classes:
    raise ValueError("No plant class folders found.")

for class_folder in classes:
    images = [
        file for file in class_folder.iterdir()
        if file.is_file()
        and file.suffix.lower() in VALID_EXTENSIONS
    ]

    if len(images) < 3:
        raise ValueError(
            f"Not enough images in {class_folder.name}"
        )

    random.shuffle(images)

    total = len(images)
    train_end = int(total * TRAIN_RATIO)
    val_end = train_end + int(total * VAL_RATIO)

    splits = {
        "train": images[:train_end],
        "val": images[train_end:val_end],
        "test": images[val_end:]
    }

    for split_name, split_images in splits.items():
        destination = OUTPUT_DIR / split_name / class_folder.name
        destination.mkdir(parents=True, exist_ok=True)

        for image in split_images:
            shutil.copy2(image, destination / image.name)

    print(
        f"{class_folder.name}: "
        f"train={len(splits['train'])}, "
        f"val={len(splits['val'])}, "
        f"test={len(splits['test'])}"
    )

print("\nDataset splitting completed!")
print(f"Output folder: {OUTPUT_DIR.resolve()}")
