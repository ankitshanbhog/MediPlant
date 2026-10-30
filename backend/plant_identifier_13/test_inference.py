"""
Test Inference CLI for MediPlant.
Runs inference on a single image file using the exported ONNX model or PyTorch checkpoint.

Usage:
  python test_inference.py --image path/to/leaf.jpg
"""

import os
import sys
import json
import argparse
import numpy as np
from PIL import Image
import onnxruntime as ort

from config import EXPORTS_DIR, PLANT_SPECIES, IMAGE_SIZE


def softmax(x):
    e_x = np.exp(x - np.max(x))
    return e_x / e_x.sum(axis=1, keepdims=True)


def preprocess_image(image_path: str, size: int = 224) -> np.ndarray:
    """Preprocesses input image into normalized float32 tensor [1, 3, 224, 224]."""
    img = Image.open(image_path).convert("RGB")
    # Resize keeping aspect ratio, then center crop
    img = img.resize((int(size * 1.14), int(size * 1.14)), Image.BILINEAR)
    w, h = img.size
    left = (w - size) // 2
    top = (h - size) // 2
    img = img.crop((left, top, left + size, top + size))

    # Convert to float numpy array normalized between [0, 1]
    arr = np.array(img, dtype=np.float32) / 255.0
    
    # Standard ImageNet normalization
    mean = np.array([0.485, 0.456, 0.406], dtype=np.float32)
    std = np.array([0.229, 0.224, 0.225], dtype=np.float32)
    arr = (arr - mean) / std

    # Transpose HWC -> CHW, add batch dimension -> [1, 3, 224, 224]
    arr = np.transpose(arr, (2, 0, 1))
    arr = np.expand_dims(arr, axis=0)
    return arr


def predict(image_path: str, model_path: str = None):
    if model_path is None:
        model_path = os.path.join(EXPORTS_DIR, "medicinal_plant_model.onnx")

    if not os.path.exists(model_path):
        print(f"[ERROR] ONNX model not found at {model_path}.")
        print("Please train and export the model using `python export_onnx.py` first.")
        return

    # Load class mapping
    class_map_file = os.path.join(EXPORTS_DIR, "classes.json")
    if os.path.exists(class_map_file):
        with open(class_map_file, "r", encoding="utf-8") as f:
            classes_meta = json.load(f)
            class_slugs = classes_meta["class_names"]
    else:
        class_slugs = [p["slug"] for p in PLANT_SPECIES]

    # Map slug to botanical info
    info_map = {p["slug"]: p for p in PLANT_SPECIES}

    # Initialize ONNX Runtime session
    session = ort.InferenceSession(model_path, providers=["CPUExecutionProvider"])

    # Preprocess image
    tensor = preprocess_image(image_path, size=IMAGE_SIZE)

    # Run inference
    outputs = session.run(None, {"input": tensor})
    logits = outputs[0]
    probs = softmax(logits)[0]

    # Sort by confidence
    top_indices = np.argsort(probs)[::-1][:3]

    print("\n========================================================")
    print(f" MediPlant Leaf Identification Result")
    print(f" Image: {image_path}")
    print("========================================================")

    top_slug = class_slugs[top_indices[0]]
    top_conf = probs[top_indices[0]] * 100
    top_info = info_map.get(top_slug, {})

    print(f"\nTop Match:    {top_info.get('common_name', top_slug)}")
    print(f"Botanical:    {top_info.get('botanical_name', 'Unknown')}")
    print(f"Confidence:   {top_conf:.2f}%\n")

    print("Top 3 Candidates:")
    for rank, idx in enumerate(top_indices, start=1):
        slug = class_slugs[idx]
        info = info_map.get(slug, {})
        c_name = info.get("common_name", slug)
        b_name = info.get("botanical_name", "")
        conf = probs[idx] * 100
        print(f"  {rank}. {c_name:<20} ({b_name:<25}) : {conf:.2f}%")

    if top_conf < 60.0:
        print("\n[NOTE] Confidence is below 60%. The scanned specimen might not be one of the cataloged 13 medicinal species.")
    print("========================================================\n")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--image", type=str, required=True, help="Path to leaf image file")
    parser.add_argument("--model", type=str, default=None, help="Path to ONNX model file")
    args = parser.parse_args()
    predict(args.image, args.model)
