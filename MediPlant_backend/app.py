import base64
import io
import json
import os
import urllib.request
import urllib.error
import numpy as np
from PIL import Image
import tensorflow as tf
from fastapi import FastAPI, File, UploadFile, Query
from fastapi.middleware.cors import CORSMiddleware
import uvicorn

# Directory where app.py and model files live
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

# Initialize FastAPI App
app = FastAPI(title="MediPlant API", description="Botanical Plant Identification & Verification API")

# Enable CORS for all origins (mobile apps, web, emulators)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# --- 1. Load Models & Class Names on Startup ---
print("Loading models into memory...")

gate_model_path = os.path.join(BASE_DIR, "plant_gate_best.keras")
try:
    plant_gate_model = tf.keras.models.load_model(gate_model_path)
    print(f"[OK] Plant Gate Model loaded from {gate_model_path}")
except Exception as e:
    print(f"Warning: Could not load plant_gate_best.keras: {e}")
    plant_gate_model = None

medicinal_model_path = os.path.join(BASE_DIR, "medicinal_plant_best.keras")
try:
    medicinal_model = tf.keras.models.load_model(medicinal_model_path)
    print(f"[OK] Medicinal Plant Model loaded from {medicinal_model_path}")
except Exception as e:
    print(f"Warning: Could not load medicinal_plant_best.keras: {e}")
    medicinal_model = None

class_names_path = os.path.join(BASE_DIR, "class_names.json")
try:
    with open(class_names_path, "r", encoding="utf-8") as f:
        class_names = json.load(f)
    print(f"[OK] Loaded {len(class_names)} class names: {class_names}")
except Exception as e:
    print(f"Warning: Could not load class_names.json: {e}")
    # Fallback default from dataset directory if file is being retrained
    dataset_train_dir = os.path.join(BASE_DIR, "Medicinal_dataset", "train")
    if os.path.isdir(dataset_train_dir):
        class_names = sorted(os.listdir(dataset_train_dir))
    else:
        class_names = []


# --- 2. Helper Preprocessing Function ---
def preprocess_image(image_bytes: bytes, target_size=(224, 224)):
    """Convert bytes to RGB, resize, and prepare batch array."""
    img = Image.open(io.BytesIO(image_bytes)).convert("RGB")
    img = img.resize(target_size)
    # The SavedModel includes the Rescaling layer internally (from [0, 255] to [-1, 1])
    img_array = np.array(img, dtype=np.float32)
    img_array = np.expand_dims(img_array, axis=0)  # Shape (1, 224, 224, 3)
    return img_array


# --- 3. Third-Party Plant.id API Verification Service (Backend Integration) ---
def verify_with_plant_id(image_bytes: bytes):
    """
    Calls the Plant.id v3 API when internal confidence is borderline.
    Returns: dict with verified scientific_name, common_names, confidence, or None on failure.
    Uses PLANTID_API_KEY environment variable. Never reveals key to frontend.
    """
    api_key = os.environ.get("PLANTID_API_KEY")
    if not api_key:
        return None

    try:
        encoded_image = base64.b64encode(image_bytes).decode("ascii")
        payload = json.dumps({
            "images": [f"data:image/jpeg;base64,{encoded_image}"],
            "latitude": 13.0,
            "longitude": 77.5,
            "similar_images": False
        }).encode("utf-8")

        req = urllib.request.Request(
            "https://plant.id/api/v3/identification?details=common_names,taxonomy,description",
            data=payload,
            headers={
                "Content-Type": "application/json",
                "Api-Key": api_key
            }
        )

        with urllib.request.urlopen(req, timeout=12) as response:
            res_data = json.loads(response.read().decode("utf-8"))

        suggestions = (res_data.get("result", {})
                       .get("classification", {})
                       .get("suggestions", []))
        if suggestions:
            best = suggestions[0]
            common_names_list = best.get("details", {}).get("common_names", [])
            primary_common = common_names_list[0] if common_names_list else best.get("name", "Verified Plant")
            return {
                "scientific_name": best.get("name", ""),
                "common_name": primary_common,
                "confidence": float(best.get("probability", 0.85)),
                "verified": True
            }
    except Exception as e:
        print(f"[Plant.id API Fallback Notice]: {e}")
        return None

    return None


# --- 4. Health Check Endpoint ---
@app.get("/")
def home():
    return {
        "status": "online",
        "message": "MediPlant Backend is active",
        "gate_ready": plant_gate_model is not None,
        "classifier_ready": medicinal_model is not None,
        "classes_count": len(class_names),
        "supported_classes": class_names,
    }


# --- 5. Main Prediction Endpoint ---
@app.post("/predict")
async def predict(file: UploadFile = File(...), force_verify: bool = Query(False)):
    try:
        contents = await file.read()
        if not contents or len(contents) < 100:
            return {
                "is_plant": False,
                "gate_passed": False,
                "message": "Invalid or empty image file received.",
                "confidence": 0.0,
                "predictions": []
            }

        processed_img = preprocess_image(contents, target_size=(224, 224))

        # ----------------------------------------------------
        # STAGE 1: Check if the image contains a plant (Gate Model)
        # ----------------------------------------------------
        if plant_gate_model is not None:
            gate_pred = plant_gate_model.predict(processed_img, verbose=0)[0]
            # Output shape (None, 1) sigmoid probability
            gate_prob = float(gate_pred[0])
            is_plant = gate_prob > 0.50
            gate_confidence = gate_prob if is_plant else (1.0 - gate_prob)

            if not is_plant:
                return {
                    "is_plant": False,
                    "gate_passed": False,
                    "message": "No botanical structures detected. Please capture a clear image of a plant leaf, stem, or flower.",
                    "plant_name": None,
                    "confidence": round(gate_confidence * 100, 2),
                    "predictions": []
                }

        # ----------------------------------------------------
        # STAGE 2: Identify the Medicinal Plant Species
        # ----------------------------------------------------
        if medicinal_model is None:
            return {
                "is_plant": True,
                "gate_passed": True,
                "error": "Species classification model is not loaded."
            }

        predictions = medicinal_model.predict(processed_img, verbose=0)[0]
        top_idx = int(np.argmax(predictions))
        top_confidence = float(predictions[top_idx])

        # Get readable class name from loaded class_names list
        if isinstance(class_names, list) and top_idx < len(class_names):
            plant_name = class_names[top_idx]
        else:
            plant_name = f"plant_{top_idx}"

        # Rank all predictions with probabilities
        ranked_predictions = []
        if isinstance(class_names, list):
            sorted_indices = np.argsort(predictions)[::-1]
            for idx in sorted_indices:
                name = class_names[idx] if idx < len(class_names) else f"plant_{idx}"
                ranked_predictions.append({
                    "class_name": name,
                    "confidence": round(float(predictions[idx]) * 100, 2),
                })

        # ----------------------------------------------------
        # STAGE 3: Enhanced Verification Fallback
        # Check external Plant.id API if confidence is under 85% (0.85) or forced,
        # ensuring mistakes are caught before showing results to the user.
        # ----------------------------------------------------
        verification_threshold = float(os.environ.get("VERIFICATION_THRESHOLD", "0.85"))
        verification_applied = False
        verification_details = None

        if top_confidence < verification_threshold or force_verify:
            verified_data = verify_with_plant_id(contents)
            if verified_data:
                verification_applied = True
                verification_details = verified_data
                # Cross-check verified botanical name against internal prediction
                v_sci = verified_data.get("scientific_name", "").lower()
                v_common = verified_data.get("common_name", "").lower()
                
                # Check if matches any known classes
                for c in class_names:
                    clean_c = c.replace("_plant", "").replace("_", " ")
                    if clean_c in v_sci or clean_c in v_common or v_sci in clean_c:
                        plant_name = c
                        break

                top_confidence = max(top_confidence, verified_data["confidence"])

        return {
            "is_plant": True,
            "gate_passed": True,
            "plant_name": plant_name,
            "confidence": round(top_confidence * 100, 2),
            "verification_applied": verification_applied,
            "verification_details": verification_details,
            "verification_threshold_used": verification_threshold,
            "message": f"Identified as {plant_name.replace('_', ' ').title()} with {round(top_confidence * 100, 1)}% confidence.",
            "predictions": ranked_predictions,
        }

    except Exception as e:
        return {
            "is_plant": False,
            "gate_passed": False,
            "error": "An error occurred while processing the image. Please try again with a clearer photo."
        }


if __name__ == "__main__":
    print("Starting MediPlant API server on http://0.0.0.0:8000 ...")
    uvicorn.run(app, host="0.0.0.0", port=8000)
