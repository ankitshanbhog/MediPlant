"""
Model Evaluation Script for MediPlant 13-Class Identifier.
Calculates per-class Precision, Recall, F1-Score, and overall accuracy.

Usage:
  python evaluate.py
  python evaluate.py --model checkpoints/best_medicinal_model.pth
"""

import os
import argparse
import torch
import numpy as np
from sklearn.metrics import classification_report, confusion_matrix
from tqdm import tqdm

from config import VAL_DIR, CHECKPOINTS_DIR, IMAGE_SIZE, DEVICE
from model.network import build_model
from model.dataset_loader import create_dataloaders


def evaluate(model_path: str):
    if not os.path.exists(model_path):
        print(f"[ERROR] Checkpoint not found at: {model_path}")
        print("Please train the model first by running `python train.py`.")
        return

    print(f"\nLoading checkpoint: {model_path}")
    checkpoint = torch.load(model_path, map_location=DEVICE)
    backbone = checkpoint.get("backbone", "mobilenet_v3_large")
    class_names = checkpoint.get("class_names", [])

    model = build_model(num_classes=len(class_names), backbone=backbone, pretrained=False)
    model.load_state_dict(checkpoint["state_dict"])
    model.to(DEVICE)
    model.eval()

    _, val_loader, _ = create_dataloaders(
        train_dir=VAL_DIR,  # Dummy fallback
        val_dir=VAL_DIR,
        batch_size=32,
        image_size=IMAGE_SIZE
    )

    all_preds = []
    all_labels = []

    print(f"Evaluating {len(val_loader.dataset)} validation samples across {len(class_names)} classes...\n")
    with torch.no_grad():
        for images, labels in tqdm(val_loader, desc="Testing"):
            images = images.to(DEVICE)
            outputs = model(images)
            preds = torch.argmax(outputs, dim=1).cpu().numpy()
            
            all_preds.extend(preds)
            all_labels.extend(labels.numpy())

    all_preds = np.array(all_preds)
    all_labels = np.array(all_labels)

    # Classification metrics
    report = classification_report(
        all_labels,
        all_preds,
        target_names=class_names,
        digits=4
    )
    print("\n========================================================")
    print(" MediPlant Classification Report")
    print("========================================================")
    print(report)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--model", type=str, default=os.path.join(CHECKPOINTS_DIR, "best_medicinal_model.pth"))
    args = parser.parse_args()
    evaluate(args.model)
