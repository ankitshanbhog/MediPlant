"""
Model Evaluation Script for MediPlant 13-Class Identifier.
Calculates per-class Precision, Recall, F1-Score, and overall accuracy.

Usage:
  python evaluate.py
"""

import os
import argparse
import numpy as np
import tensorflow as tf
from sklearn.metrics import classification_report, confusion_matrix
from tqdm import tqdm

from config import VAL_DIR, CHECKPOINTS_DIR, IMAGE_SIZE, CLASS_NAMES
import onnxruntime as ort

def evaluate(model_path: str = None):
    if model_path is None:
        model_path = os.path.join(os.path.dirname(__file__), "exports", "medicinal_plant_model.onnx")

    if not os.path.exists(model_path):
        print(f"[ERROR] Model file not found at: {model_path}")
        return

    print(f"\nLoading model: {model_path}")
    sess = ort.InferenceSession(model_path, providers=["CPUExecutionProvider"])
    input_name = sess.get_inputs()[0].name

    if not os.path.exists(VAL_DIR):
        print(f"[ERROR] Validation directory not found at: {VAL_DIR}")
        return

    val_dataset = tf.keras.utils.image_dataset_from_directory(
        VAL_DIR,
        image_size=(IMAGE_SIZE, IMAGE_SIZE),
        batch_size=32,
        shuffle=False,
        label_mode="int",
    )
    class_names = val_dataset.class_names

    mean = np.array([0.485, 0.456, 0.406], dtype=np.float32)
    std = np.array([0.229, 0.224, 0.225], dtype=np.float32)

    all_preds = []
    all_labels = []

    print(f"Evaluating validation samples across {len(class_names)} classes...\n")
    for images, labels in tqdm(val_dataset, desc="Evaluating"):
        # Normalize as expected by model
        arr = (images.numpy() / 255.0 - mean) / std
        arr = np.transpose(arr, (0, 3, 1, 2)).astype(np.float32)
        outputs = sess.run(None, {input_name: arr})[0]
        preds = np.argmax(outputs, axis=1)

        all_preds.extend(preds)
        all_labels.extend(labels.numpy())

    all_preds = np.array(all_preds)
    all_labels = np.array(all_labels)

    report = classification_report(
        all_labels,
        all_preds,
        target_names=class_names,
        digits=4,
    )
    print("\n========================================================")
    print(" MediPlant Classification Report")
    print("========================================================")
    print(report)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--model", type=str, default=None)
    args = parser.parse_args()
    evaluate(args.model)
