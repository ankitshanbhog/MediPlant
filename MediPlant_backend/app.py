import io
import json
import os
import asyncio
import numpy as np
from PIL import Image
import tensorflow as tf
from fastapi import FastAPI, File, UploadFile, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
import uvicorn

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

app = FastAPI(title="MediPlant API", description="Botanical Plant Identification API – 10-Class Model")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

print("Loading models into memory...")

# ─────────────────────────────────────────────────────────────────────────────
# Gate Model: Detects whether the image contains a plant at all
# ─────────────────────────────────────────────────────────────────────────────
gate_model_path = os.path.join(BASE_DIR, "plant_gate_best.keras")
try:
    plant_gate_model = tf.keras.models.load_model(gate_model_path)
    print(f"[OK] Plant Gate Model loaded from {gate_model_path}")
except Exception as e:
    print(f"Warning: Could not load plant_gate_best.keras: {e}")
    plant_gate_model = None

# ─────────────────────────────────────────────────────────────────────────────
# 10-Class Medicinal Plant Classifier
# Uses mediplant_10class_best.keras (best checkpoint from training)
# Classes: ashwagandha, ayapana, cinnamon, gotu_kola, insulin_plant,
#          malabar_nut, pirandai, rosemary, wood_apple, ylang_ylang
# ─────────────────────────────────────────────────────────────────────────────
medicinal_model_path = os.path.join(BASE_DIR, "mediplant_10class_best.keras")
try:
    medicinal_model = tf.keras.models.load_model(medicinal_model_path)
    print(f"[OK] 10-Class Medicinal Model loaded from {medicinal_model_path}")
except Exception as e:
    print(f"Warning: Could not load mediplant_10class_best.keras: {e}")
    # Fallback to the non-best checkpoint
    fallback_path = os.path.join(BASE_DIR, "mediplant_10class.keras")
    try:
        medicinal_model = tf.keras.models.load_model(fallback_path)
        print(f"[OK] Fallback 10-Class Model loaded from {fallback_path}")
    except Exception as e2:
        print(f"Warning: Could not load fallback model either: {e2}")
        medicinal_model = None

# ─────────────────────────────────────────────────────────────────────────────
# Class Labels for the 10-Class Model
# Loaded from mediplant_10class_labels.json (index → class_name mapping)
# ─────────────────────────────────────────────────────────────────────────────
labels_path = os.path.join(BASE_DIR, "mediplant_10class_labels.json")
try:
    with open(labels_path, "r", encoding="utf-8") as f:
        labels_dict = json.load(f)
    # Convert dict {"0": "ashwagandha_plant", ...} to ordered list
    class_names = [labels_dict[str(i)] for i in range(len(labels_dict))]
    print(f"[OK] Loaded {len(class_names)} class labels: {class_names}")
except Exception as e:
    print(f"Warning: Could not load mediplant_10class_labels.json: {e}")
    # Hard-coded fallback matching the trained model's class order
    class_names = [
        "ashwagandha_plant",
        "ayapana_plant",
        "cinnamon_plant",
        "gotu_kola_plant",
        "insulin_plant",
        "malabar_nut",
        "pirandai_plant",
        "rosemary_plant",
        "wood_apple_plant",
        "ylang_ylang_plant",
    ]
    print(f"[Fallback] Using hard-coded class list: {class_names}")

# Also update class_names.json for reference
try:
    out_path = os.path.join(BASE_DIR, "class_names.json")
    with open(out_path, "w", encoding="utf-8") as f:
        json.dump(class_names, f, indent=2)
    print(f"[OK] class_names.json updated with {len(class_names)} classes")
except Exception as e:
    print(f"Warning: Could not write class_names.json: {e}")


def preprocess_image(image_bytes: bytes, target_size=(224, 224)):
    """
    Convert raw image bytes to a preprocessed float32 tensor.

    Both the gate model and the 10-class medicinal model include an internal
    Rescaling(1/127.5, offset=-1) layer (MobileNetV2-style preprocessing),
    so we only resize and expand dims here — NO external normalisation.
    """
    img = Image.open(io.BytesIO(image_bytes)).convert("RGB")
    img = img.resize(target_size, Image.LANCZOS)
    img_array = np.array(img, dtype=np.float32)       # shape: (224, 224, 3)
    img_array = np.expand_dims(img_array, axis=0)     # shape: (1, 224, 224, 3)
    return img_array


@app.get("/")
def home():
    return {
        "status": "online",
        "message": "MediPlant Backend is active – 10-Class Model",
        "gate_ready": plant_gate_model is not None,
        "classifier_ready": medicinal_model is not None,
        "classes_count": len(class_names),
        "supported_classes": class_names,
    }


@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    try:
        contents = await file.read()
        if not contents or len(contents) < 100:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Invalid or empty image file received.",
            )

        processed_img = preprocess_image(contents, target_size=(224, 224))

        # ── Stage 1: Gate check (is this a plant?) ──────────────────────────
        if plant_gate_model is not None:
            gate_pred = await asyncio.to_thread(plant_gate_model.predict, processed_img, verbose=0)
            gate_prob = float(gate_pred[0][0])
            is_plant = gate_prob > 0.50
            gate_confidence = gate_prob if is_plant else (1.0 - gate_prob)

            if not is_plant:
                return {
                    "is_plant": False,
                    "gate_passed": False,
                    "message": (
                        "No botanical structures detected. "
                        "Please capture a clear image of a plant leaf, stem, or flower."
                    ),
                    "plant_name": None,
                    "confidence": round(gate_confidence * 100, 2),
                    "predictions": [],
                }

        # ── Stage 2: 10-class species classification ─────────────────────────
        if medicinal_model is None:
            return {
                "is_plant": True,
                "gate_passed": True,
                "error": "Species classification model is not loaded.",
            }

        raw_preds = await asyncio.to_thread(medicinal_model.predict, processed_img, verbose=0)
        predictions = raw_preds[0]

        top_idx = int(np.argmax(predictions))
        top_confidence = float(predictions[top_idx])

        if isinstance(class_names, list) and top_idx < len(class_names):
            plant_name = class_names[top_idx]
        else:
            plant_name = f"plant_{top_idx}"

        # Build ranked prediction list (all 10 classes, sorted by confidence)
        ranked_predictions = []
        if isinstance(class_names, list):
            sorted_indices = np.argsort(predictions)[::-1]
            for idx in sorted_indices:
                name = class_names[idx] if idx < len(class_names) else f"plant_{idx}"
                ranked_predictions.append({
                    "class_name": name,
                    "confidence": round(float(predictions[idx]) * 100, 2),
                })

        display_name = plant_name.replace("_", " ").title()

        return {
            "is_plant": True,
            "gate_passed": True,
            "plant_name": plant_name,
            "confidence": round(top_confidence * 100, 2),
            "message": (
                f"Identified as {display_name} "
                f"with {round(top_confidence * 100, 1)}% confidence."
            ),
            "predictions": ranked_predictions,
        }

    except HTTPException as http_exc:
        raise http_exc
    except Exception as e:
        return {
            "is_plant": False,
            "gate_passed": False,
            "error": f"An error occurred while processing the image: {str(e)}",
        }


if __name__ == "__main__":
    print("Starting MediPlant API server on http://0.0.0.0:8000 ...")
    uvicorn.run(app, host="0.0.0.0", port=8000)