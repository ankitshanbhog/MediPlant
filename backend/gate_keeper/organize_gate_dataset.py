"""
Dataset Organizer for MediPlant Gate Keeper.
Validates images in dataset/plant and dataset/non_plant, converts all formats
(jpg, png, webp, avif) to standardized RGB JPEGs, and partitions into:
  dataset/train/ (80%)
    ├── non_plant/
    └── plant/
  dataset/val/   (20%)
    ├── non_plant/
    └── plant/

Usage:
  python organize_gate_dataset.py
"""

import os
import sys
import shutil
import random
import hashlib
import json
from PIL import Image

sys.path.append(os.path.dirname(os.path.abspath(__file__)))
from config import (
    RAW_PLANT_DIR, RAW_NON_PLANT_DIR, TRAIN_DIR, VAL_DIR,
    DATASET_DIR, TRAIN_VAL_SPLIT, CLASSES
)


def get_image_hash(img: Image.Image) -> str:
    """Calculates perceptual/data hash to eliminate duplicate images."""
    return hashlib.md5(img.tobytes()).hexdigest()


def process_folder(source_dir: str, class_name: str, seed: int = 42):
    random.seed(seed)
    train_dest = os.path.join(TRAIN_DIR, class_name)
    val_dest = os.path.join(VAL_DIR, class_name)
    os.makedirs(train_dest, exist_ok=True)
    os.makedirs(val_dest, exist_ok=True)

    if not os.path.exists(source_dir):
        print(f"[ERROR] Source folder does not exist: {source_dir}")
        return 0, 0

    print(f"Processing '{class_name}' from: {source_dir} ...")

    valid_images = []
    seen_hashes = set()
    skipped_corrupted = 0
    skipped_duplicate = 0

    # Scan and validate all files in source directory
    file_list = [f for f in os.listdir(source_dir) if os.path.isfile(os.path.join(source_dir, f))]
    
    for filename in file_list:
        file_path = os.path.join(source_dir, filename)
        try:
            with Image.open(file_path) as img:
                img.verify()
            
            with Image.open(file_path) as img:
                rgb_img = img.convert("RGB")
                img_hash = get_image_hash(rgb_img)

                if img_hash in seen_hashes:
                    skipped_duplicate += 1
                    continue

                seen_hashes.add(img_hash)
                valid_images.append((file_path, rgb_img.copy()))
        except Exception:
            skipped_corrupted += 1
            continue

    print(f"  -> Found {len(valid_images)} valid images (Skipped: {skipped_duplicate} duplicates, {skipped_corrupted} corrupted).")

    # Shuffle deterministically
    random.shuffle(valid_images)

    split_idx = int(len(valid_images) * TRAIN_VAL_SPLIT)
    train_set = valid_images[:split_idx]
    val_set = valid_images[split_idx:]

    # Save to train
    for idx, (_, img) in enumerate(train_set):
        save_path = os.path.join(train_dest, f"{class_name}_{idx:04d}.jpg")
        img.save(save_path, "JPEG", quality=94)

    # Save to val
    for idx, (_, img) in enumerate(val_set):
        save_path = os.path.join(val_dest, f"{class_name}_{idx:04d}.jpg")
        img.save(save_path, "JPEG", quality=94)

    return len(train_set), len(val_set)


def main():
    print("==================================================")
    print(" MediPlant Gate Keeper Dataset Organizer")
    print(f" Source: {DATASET_DIR}")
    print(f" Split:  {int(TRAIN_VAL_SPLIT*100)}% Train / {int((1-TRAIN_VAL_SPLIT)*100)}% Validation")
    print("==================================================\n")

    # Clean existing train/val if present to avoid mixing runs
    for split_dir in [TRAIN_DIR, VAL_DIR]:
        if os.path.exists(split_dir):
            shutil.rmtree(split_dir)
        os.makedirs(split_dir, exist_ok=True)

    # Process both classes
    non_plant_train, non_plant_val = process_folder(RAW_NON_PLANT_DIR, "non_plant")
    plant_train, plant_val = process_folder(RAW_PLANT_DIR, "plant")

    print("\n" + "=" * 60)
    print(f"{'Class':<15} | {'Train (80%)':<14} | {'Val (20%)':<12} | {'Total':<10}")
    print("-" * 60)
    print(f"{'non_plant':<15} | {non_plant_train:<14} | {non_plant_val:<12} | {non_plant_train + non_plant_val:<10}")
    print(f"{'plant':<15} | {plant_train:<14} | {plant_val:<12} | {plant_train + plant_val:<10}")
    print("-" * 60)
    total_train = non_plant_train + plant_train
    total_val = non_plant_val + plant_val
    print(f"{'TOTAL':<15} | {total_train:<14} | {total_val:<12} | {total_train + total_val:<10}")
    print("=" * 60)

    # Save summary metadata
    summary = {
        "classes": CLASSES,
        "split_ratio": f"{int(TRAIN_VAL_SPLIT*100)}/{int((1-TRAIN_VAL_SPLIT)*100)}",
        "counts": {
            "non_plant": {"train": non_plant_train, "val": non_plant_val, "total": non_plant_train + non_plant_val},
            "plant": {"train": plant_train, "val": plant_val, "total": plant_train + plant_val},
            "total_train": total_train,
            "total_val": total_val,
            "grand_total": total_train + total_val
        }
    }
    summary_path = os.path.join(DATASET_DIR, "dataset_summary.json")
    with open(summary_path, "w", encoding="utf-8") as f:
        json.dump(summary, f, indent=2)

    print(f"\n[SUCCESS] Dataset organized into:")
    print(f"  - Train: {TRAIN_DIR}")
    print(f"  - Val:   {VAL_DIR}")
    print(f"Summary written to: {summary_path}")
    print("\nReady to train! Run: python train_gate.py")


if __name__ == "__main__":
    main()
