"""
Evaluation Script for MediPlant Gate Keeper.
Calculates Accuracy, Precision, Recall, F1-Score, and False Negative Rate on the validation set.

Usage:
  python evaluate_gate.py
"""

import os
import argparse
import numpy as np
import tensorflow as tf
from sklearn.metrics import classification_report, confusion_matrix
from tqdm import tqdm
import onnxruntime as ort

from config import VAL_DIR, CHECKPOINTS_DIR, IMAGE_SIZE, CLASSES

def evaluate(model_path: str = None):
    if model_path is None:
        model_path = os.path.join(os.path.dirname(__file__), "exports", "plant_gate_model.onnx")

    if not os.path.exists(model_path):
        print(f"[ERROR] Model not found at: {model_path}")
        return

    print(f"\nLoading ONNX model: {model_path}")
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

    print(f"Evaluating validation samples across classes: {class_names}...\n")
    for images, labels in tqdm(val_dataset, desc="Evaluating Gate Model"):
        arr = (images.numpy() / 255.0 - mean) / std
        arr = np.transpose(arr, (0, 3, 1, 2)).astype(np.float32)
        outputs = sess.run(None, {input_name: arr})[0]
        preds = np.argmax(outputs, axis=1)

        all_preds.extend(preds)
        all_labels.extend(labels.numpy())

    all_preds = np.array(all_preds)
    all_labels = np.array(all_labels)

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
