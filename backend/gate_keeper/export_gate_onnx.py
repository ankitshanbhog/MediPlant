"""
ONNX Exporter for MediPlant Gate Keeper.
Converts trained Keras model or verifies the ONNX model (.onnx)
ready for low-latency CPU serving in the FastAPI backend.

Usage:
  python export_gate_onnx.py
"""

import os
import json
import time
import numpy as np
import onnxruntime as ort
import tensorflow as tf

from config import CHECKPOINTS_DIR, EXPORTS_DIR, IMAGE_SIZE, CLASSES

def verify_gate_onnx(onnx_path: str = None):
    if onnx_path is None:
        onnx_path = os.path.join(EXPORTS_DIR, "plant_gate_model.onnx")

    if not os.path.exists(onnx_path):
        print(f"[ERROR] ONNX model not found at: {onnx_path}")
        return

    print(f"\n[INFO] Verifying ONNX Gate Model at: {onnx_path}")
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

    print(f"  Test Output Shape: {out.shape}")
    print(f"  CPU Latency:       {latency:.2f} ms")
    print(f"  Status:            READY FOR FASTAPI DEPLOYMENT\n")

if __name__ == "__main__":
    verify_gate_onnx()
