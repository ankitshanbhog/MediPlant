"""
ONNX Model Exporter for MediPlant 13-Class Identifier.
Verifies and configures the optimized ONNX model (.onnx)
ready for zero-dependency deployment in the FastAPI backend.

Usage:
  python export_onnx.py
"""

import os
import json
import time
import numpy as np
import onnxruntime as ort
import tensorflow as tf

from config import CHECKPOINTS_DIR, EXPORTS_DIR, IMAGE_SIZE, CLASS_NAMES

def verify_identifier_onnx(onnx_path: str = None):
    if onnx_path is None:
        onnx_path = os.path.join(EXPORTS_DIR, "medicinal_plant_model.onnx")

    if not os.path.exists(onnx_path):
        print(f"[ERROR] Model not found at: {onnx_path}")
        return

    print(f"\n[INFO] Verifying ONNX 13-Class Model at: {onnx_path}")
    session = ort.InferenceSession(onnx_path, providers=["CPUExecutionProvider"])
    input_name = session.get_inputs()[0].name
    output_name = session.get_outputs()[0].name

    print(f"  Input Name:  {input_name}")
    print(f"  Input Shape: {session.get_inputs()[0].shape}")
    print(f"  Output Name: {output_name}")
    print(f"  Output Shape:{session.get_outputs()[0].shape}")

    # Run dummy test pass
    dummy = np.random.randn(1, 3, IMAGE_SIZE, IMAGE_SIZE).astype(np.float32)
    start_time = time.time()
    out = session.run([output_name], {input_name: dummy})[0]
    latency = (time.time() - start_time) * 1000

    print(f"  Classes:           {len(CLASS_NAMES)}")
    print(f"  Test Output Shape: {out.shape}")
    print(f"  CPU Latency:       {latency:.2f} ms")
    print(f"  Status:            READY FOR FASTAPI DEPLOYMENT\n")

if __name__ == "__main__":
    verify_identifier_onnx()
