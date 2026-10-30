"""
Single-Image Gate Tester for MediPlant.
Runs inference on a test image and displays whether it passes or fails the plant gate.

Usage:
  python test_gate.py --image path/to/sample.jpg
"""

import os
import json
import argparse
import numpy as np
from PIL import Image
import onnxruntime as ort

from config import EXPORTS_DIR, IMAGE_SIZE


def softmax(x):
    e_x = np.exp(x - np.max(x))
    return e_x / e_x.sum(axis=1, keepdims=True)


def preprocess_image(image_path: str, size: int = 224) -> np.ndarray:
    img = Image.open(image_path).convert("RGB")
    img = img.resize((int(size * 1.14), int(size * 1.14)), Image.BILINEAR)
    w, h = img.size
    left = (w - size) // 2
    top = (h - size) // 2
    img = img.crop((left, top, left + size, top + size))

    arr = np.array(img, dtype=np.float32) / 255.0
    mean = np.array([0.485, 0.456, 0.406], dtype=np.float32)
    std = np.array([0.229, 0.224, 0.225], dtype=np.float32)
    arr = (arr - mean) / std

    arr = np.transpose(arr, (2, 0, 1))
    arr = np.expand_dims(arr, axis=0)
    return arr


def test_gate(image_path: str, model_path: str = None):
    if model_path is None:
        model_path = os.path.join(EXPORTS_DIR, "plant_gate_model.onnx")

    if not os.path.exists(model_path):
        print(f"[ERROR] ONNX model not found at {model_path}.")
        print("Please train and export using `python export_gate_onnx.py` first.")
        return

    meta_file = os.path.join(EXPORTS_DIR, "gate_classes.json")
    if os.path.exists(meta_file):
        with open(meta_file, "r", encoding="utf-8") as f:
            meta = json.load(f)
            class_names = meta["class_names"]
            plant_idx = meta.get("plant_class_index", 1)
    else:
        class_names = ["non_plant", "plant"]
        plant_idx = 1

    session = ort.InferenceSession(model_path, providers=["CPUExecutionProvider"])
    tensor = preprocess_image(image_path, size=IMAGE_SIZE)

    outputs = session.run(None, {"input": tensor})
    probs = softmax(outputs[0])[0]

    plant_prob = probs[plant_idx] * 100
    non_plant_prob = probs[1 - plant_idx] * 100
    is_plant = plant_prob >= 50.0

    print("\n========================================================")
    print(" MediPlant Gate Keeper Verification")
    print(f" Image: {image_path}")
    print("========================================================")

    if is_plant:
        print(f"Decision:    [PASS] Plant Structure Detected")
        print(f"Confidence:  {plant_prob:.2f}% (Plant)")
        print("Status:      Proceeding to Stage 2 Medicinal Plant Identification.")
    else:
        print(f"Decision:    [REJECT] Not a Plant")
        print(f"Confidence:  {non_plant_prob:.2f}% (Non-Plant)")
        print("Status:      Early Exit - Rejected. Please focus on plant foliage.")

    print(f"\nRaw Probabilities:")
    for idx, cname in enumerate(class_names):
        print(f"  - {cname:<12}: {probs[idx]*100:.2f}%")
    print("========================================================\n")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--image", type=str, required=True, help="Path to image file")
    parser.add_argument("--model", type=str, default=None, help="Path to ONNX model file")
    args = parser.parse_args()
    test_gate(args.image, args.model)
