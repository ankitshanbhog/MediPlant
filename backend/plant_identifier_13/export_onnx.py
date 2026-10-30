"""
ONNX Model Exporter for MediPlant 13-Class Identifier.
Converts PyTorch checkpoint (.pth) to an optimized ONNX model (.onnx)
ready for zero-dependency deployment in the FastAPI backend.

Usage:
  python export_onnx.py
"""

import os
import json
import time
import torch
import numpy as np
import onnx
import onnxruntime as ort

from config import CHECKPOINTS_DIR, EXPORTS_DIR, IMAGE_SIZE
from model.network import build_model


def export_to_onnx(checkpoint_path: str = None, output_name: str = "medicinal_plant_model.onnx"):
    if checkpoint_path is None:
        checkpoint_path = os.path.join(CHECKPOINTS_DIR, "best_medicinal_model.pth")

    if not os.path.exists(checkpoint_path):
        print(f"[ERROR] Checkpoint not found at: {checkpoint_path}")
        print("Please train the model first by running `python train.py`.")
        return

    print(f"\nLoading trained PyTorch checkpoint: {checkpoint_path}")
    checkpoint = torch.load(checkpoint_path, map_location="cpu")
    backbone = checkpoint.get("backbone", "mobilenet_v3_large")
    class_names = checkpoint.get("class_names", [])

    # 1. Instantiate PyTorch model
    model = build_model(num_classes=len(class_names), backbone=backbone, pretrained=False)
    model.load_state_dict(checkpoint["state_dict"])
    model.eval()

    # 2. Prepare dummy input tensor [batch_size=1, channels=3, height=224, width=224]
    dummy_input = torch.randn(1, 3, IMAGE_SIZE, IMAGE_SIZE, requires_grad=False)
    onnx_path = os.path.join(EXPORTS_DIR, output_name)

    print(f"Exporting to ONNX format: {onnx_path}...")
    torch.onnx.export(
        model,
        dummy_input,
        onnx_path,
        export_params=True,
        opset_version=17,
        do_constant_folding=True,
        input_names=["input"],
        output_names=["output"],
        dynamic_axes={
            "input": {0: "batch_size"},
            "output": {0: "batch_size"}
        },
        dynamo=False
    )

    # 3. Verify ONNX Graph
    print("Verifying ONNX model integrity...")
    onnx_model = onnx.load(onnx_path)
    onnx.checker.check_model(onnx_model)
    print("  -> ONNX model structure is VALID.")

    # 4. Save class mapping dictionary
    class_map_path = os.path.join(EXPORTS_DIR, "classes.json")
    with open(class_map_path, "w", encoding="utf-8") as f:
        json.dump({
            "num_classes": len(class_names),
            "class_names": class_names,
            "image_size": IMAGE_SIZE,
            "normalization": {
                "mean": [0.485, 0.456, 0.406],
                "std": [0.229, 0.224, 0.225]
            }
        }, f, indent=2)
    print(f"  -> Saved class mappings to: {class_map_path}")

    # 5. Benchmark Latency with ONNX Runtime
    print("\nRunning inference benchmark with ONNX Runtime...")
    session = ort.InferenceSession(onnx_path, providers=["CPUExecutionProvider"])
    sample_np = np.random.randn(1, 3, IMAGE_SIZE, IMAGE_SIZE).astype(np.float32)

    # Warmup
    for _ in range(5):
        session.run(None, {"input": sample_np})

    # Benchmark 20 runs
    times = []
    for _ in range(20):
        t0 = time.perf_counter()
        session.run(None, {"input": sample_np})
        times.append((time.perf_counter() - t0) * 1000.0)

    avg_latency = np.mean(times)
    file_size_mb = os.path.getsize(onnx_path) / (1024 * 1024)

    print(f"  -> Model file size: {file_size_mb:.2f} MB")
    print(f"  -> Average CPU inference latency: {avg_latency:.2f} ms")
    print("\n[SUCCESS] Production ONNX model ready for FastAPI backend integration!")


if __name__ == "__main__":
    export_to_onnx()
