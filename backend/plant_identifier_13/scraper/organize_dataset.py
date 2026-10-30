"""
Dataset Organizer & Train/Val Splitter for MediPlant.
Reads images from dataset/raw/<slug>/, validates each image,
and organizes into:
  dataset/train/<slug>/ (80%)
  dataset/val/<slug>/   (20%)
"""

import os
import sys
import shutil
import random
import json
from PIL import Image

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from config import RAW_DIR, TRAIN_DIR, VAL_DIR, PLANT_SPECIES, TRAIN_VAL_SPLIT, DATASET_DIR


def clean_directory(path: str):
    """Safely cleans an existing directory without deleting the root."""
    if os.path.exists(path):
        for item in os.listdir(path):
            item_path = os.path.join(path, item)
            if os.path.isdir(item_path):
                shutil.rmtree(item_path)
            else:
                os.remove(item_path)
    os.makedirs(path, exist_ok=True)


def organize_dataset(seed: int = 42):
    random.seed(seed)
    print("\n==================================================")
    print("MediPlant Dataset Splitter & Integrity Verification")
    print(f"Source: {RAW_DIR}")
    print(f"Targets: {TRAIN_DIR} (80%) | {VAL_DIR} (20%)")
    print("==================================================\n")

    summary = []
    total_train = 0
    total_val = 0

    metadata = {
        "num_classes": len(PLANT_SPECIES),
        "split_ratio": f"{int(TRAIN_VAL_SPLIT*100)}/{int((1-TRAIN_VAL_SPLIT)*100)}",
        "classes": {}
    }

    for species in PLANT_SPECIES:
        slug = species["slug"]
        common = species["common_name"]
        raw_slug_dir = os.path.join(RAW_DIR, slug)

        if not os.path.exists(raw_slug_dir):
            print(f"  [WARN] Missing raw directory for {slug}. Please run download_plants.py first.")
            continue

        # Target directories
        train_class_dir = os.path.join(TRAIN_DIR, slug)
        val_class_dir = os.path.join(VAL_DIR, slug)
        os.makedirs(train_class_dir, exist_ok=True)
        os.makedirs(val_class_dir, exist_ok=True)

        # Collect verified image files
        valid_files = []
        for f in os.listdir(raw_slug_dir):
            fp = os.path.join(raw_slug_dir, f)
            if os.path.isfile(fp) and f.lower().endswith((".jpg", ".jpeg", ".png")):
                try:
                    with Image.open(fp) as img:
                        img.verify()
                    valid_files.append(fp)
                except Exception:
                    continue

        if len(valid_files) == 0:
            print(f"  [WARN] No valid images found for {slug}.")
            continue

        # Shuffle deterministically
        random.shuffle(valid_files)

        split_idx = int(len(valid_files) * TRAIN_VAL_SPLIT)
        train_files = valid_files[:split_idx]
        val_files = valid_files[split_idx:]

        # Copy into train
        for src in train_files:
            dst = os.path.join(train_class_dir, os.path.basename(src))
            shutil.copy2(src, dst)

        # Copy into val
        for src in val_files:
            dst = os.path.join(val_class_dir, os.path.basename(src))
            shutil.copy2(src, dst)

        summary.append({
            "slug": slug,
            "common": common,
            "train": len(train_files),
            "val": len(val_files),
            "total": len(valid_files)
        })

        metadata["classes"][slug] = {
            "class_id": species["class_id"],
            "common_name": common,
            "botanical_name": species["botanical_name"],
            "train_samples": len(train_files),
            "val_samples": len(val_files)
        }

        total_train += len(train_files)
        total_val += len(val_files)

    # Print summary table
    print(f"{'Class (Common)':<24} | {'Slug':<20} | {'Train':<7} | {'Val':<6} | {'Total':<6}")
    print("-" * 72)
    for row in summary:
        print(f"{row['common']:<24} | {row['slug']:<20} | {row['train']:<7} | {row['val']:<6} | {row['total']:<6}")
    print("-" * 72)
    print(f"{'TOTALS':<47} | {total_train:<7} | {total_val:<6} | {total_train + total_val:<6}\n")

    # Save metadata JSON
    meta_path = os.path.join(DATASET_DIR, "dataset_summary.json")
    with open(meta_path, "w", encoding="utf-8") as f:
        json.dump(metadata, f, indent=2)

    print(f"[SUCCESS] Dataset successfully partitioned and saved.")
    print(f"Metadata index written to: {meta_path}")
    print("Ready for model training via: python train.py")


if __name__ == "__main__":
    organize_dataset()
