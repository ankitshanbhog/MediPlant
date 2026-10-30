"""
Evaluation Script for MediPlant Gate Keeper.
Calculates Accuracy, Precision, Recall, F1-Score, and False Negative Rate on the validation set.

Usage:
  python evaluate_gate.py
"""

import os
import argparse
import torch
import numpy as np
from sklearn.metrics import classification_report, confusion_matrix
from tqdm import tqdm

from config import VAL_DIR, CHECKPOINTS_DIR, IMAGE_SIZE, DEVICE
from model import build_gate_model
from dataset_loader import create_gate_dataloaders


def evaluate(model_path: str = None):
    if model_path is None:
        model_path = os.path.join(CHECKPOINTS_DIR, "best_gate_model.pth")

    if not os.path.exists(model_path):
        print(f"[ERROR] Checkpoint not found at: {model_path}")
        print("Please train the model first by running `python train_gate.py`.")
        return

    print(f"\nLoading checkpoint: {model_path}")
    checkpoint = torch.load(model_path, map_location=DEVICE)
    backbone = checkpoint.get("backbone", "mobilenet_v3_small")
    class_names = checkpoint.get("class_names", ["non_plant", "plant"])

    model = build_gate_model(backbone=backbone, pretrained=False)
    model.load_state_dict(checkpoint["state_dict"])
    model.to(DEVICE)
    model.eval()

    _, val_loader, _ = create_gate_dataloaders(
        train_dir=VAL_DIR,  # dummy fallback
        val_dir=VAL_DIR,
        batch_size=32,
        image_size=IMAGE_SIZE
    )

    all_preds = []
    all_labels = []

    print(f"Evaluating {len(val_loader.dataset)} validation samples across classes: {class_names}...\n")
    with torch.no_grad():
        for images, labels in tqdm(val_loader, desc="Testing Gate Model"):
            images = images.to(DEVICE)
            outputs = model(images)
            preds = torch.argmax(outputs, dim=1).cpu().numpy()
            all_preds.extend(preds)
            all_labels.extend(labels.numpy())

    all_preds = np.array(all_preds)
    all_labels = np.array(all_labels)

    # Metrics
    report = classification_report(all_labels, all_preds, target_names=class_names, digits=4)
    cm = confusion_matrix(all_labels, all_preds)

    print("\n========================================================")
    print(" MediPlant Gate Keeper Classification Report")
    print("========================================================")
    print(report)

    print("Confusion Matrix:")
    print(f"                Predicted Non-Plant  Predicted Plant")
    print(f"Actual Non-Plant:     {cm[0][0]:<15}      {cm[0][1]:<15}")
    print(f"Actual Plant:         {cm[1][0]:<15}      {cm[1][1]:<15}")
    print("========================================================\n")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--model", type=str, default=None)
    args = parser.parse_args()
    evaluate(args.model)
