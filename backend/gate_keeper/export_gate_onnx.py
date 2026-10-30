"""
ONNX Exporter for MediPlant Gate Keeper.
Converts PyTorch checkpoint (.pth) to an optimized ONNX model (.onnx)
ready for low-latency CPU serving in the FastAPI backend.

Usage:
  python export_gate_onnx.py
"""

import os
import json
import time
import torch
import numpy as np
import onnx
import onnxruntime as ort

from config import CHECKPOINTS_DIR, EXPORTS_DIR, IMAGE_SIZE
from model import build_gate_model


def export_to_onnx(checkpoint_path: str = None, output_name: str = "plant_gate_model.onnx"):
    if checkpoint_path is None:
        checkpoint_path = os.path.join(CHECKPOINTS_DIR, "best_gate_model.pth")

    if not os.path.exists(checkpoint_path):
        print(f"[ERROR] Checkpoint not found at: {checkpoint_path}")
        print("Please train the model first by running `python train_gate.py`.")
        return

    print(f"\nLoading trained Gate PyTorch checkpoint: {checkpoint_path}")
    checkpoint = torch.load(checkpoint_path, map_location="cpu")
    backbone = checkpoint.get("backbone", "mobilenet_v3_small")
    class_names = checkpoint.get("class_names", ["non_plant", "plant"])

    # 1. Instantiate model
    model = build_gate_model(backbone=backbone, pretrained=False)
    model.load_state_dict(checkpoint["state_dict"])
    model.eval()

    # 2. Export to ONNX
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

    # 3. Verify graph
    print("Verifying ONNX model integrity...")
    onnx_model = onnx.load(onnx_path)
    onnx.checker.check_model(onnx_model)
    print("  -> ONNX Gate model structure is VALID.")

    # 4. Save metadata
    class_map_path = os.path.join(EXPORTS_DIR, "gate_classes.json")
    with open(class_map_path, "w", encoding="utf-8") as f:
        json.dump({
            "num_classes": len(class_names),
            "class_names": class_names,
            "plant_class_index": class_names.index("plant") if "plant" in class_names else 1,
            "image_size": IMAGE_SIZE,
            "normalization": {
                "mean": [0.485, 0.456, 0.406],
                "std": [0.229, 0.224, 0.225]
            }
        }, f, indent=2)
    print(f"  -> Saved gate class metadata to: {class_map_path}")

    # 5. Benchmark Latency
    print("\nBenchmarking CPU inference latency...")
    session = ort.InferenceSession(onnx_path, providers=["CPUExecutionProvider"])
    sample_np = np.random.randn(1, 3, IMAGE_SIZE, IMAGE_SIZE).astype(np.float32)

    for _ in range(5):
        session.run(None, {"input": sample_np})

    times = []
    for _ in range(25):
        t0 = time.perf_counter()
        session.run(None, {"input": sample_np})
        times.append((time.perf_counter() - t0) * 1000.0)

    avg_ms = np.mean(times)
    file_size_mb = os.path.getsize(onnx_path) / (1024 * 1024)

    print(f"  -> Model file size: {file_size_mb:.2f} MB")
    print(f"  -> Average CPU inference latency: {avg_ms:.2f} ms")
    print("\n[SUCCESS] Production Plant Gate ONNX model ready for FastAPI backend!")


if __name__ == "__main__":
    export_to_onnx()
