"""
MediPlant Dual-Stage Inference Backend
FastAPI server connecting:
  Stage 1: Plant Gatekeeper ONNX Model (Plant vs Non-Plant Filter)
  Stage 2: 13-Class Medicinal Plant Classifier ONNX Model
"""

import io
import json
import logging
import os
import sys
from contextlib import asynccontextmanager
from typing import Any, Dict, List, Optional

import numpy as np
import onnxruntime as ort
import uvicorn
from fastapi import FastAPI, File, HTTPException, UploadFile, status
from fastapi.middleware.cors import CORSMiddleware
from PIL import Image

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
)
logger = logging.getLogger("MediPlantBackend")

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

# Gate Model paths
GATE_DIR = os.path.join(BASE_DIR, "gate_keeper", "exports")
GATE_MODEL_PATH = os.path.join(GATE_DIR, "plant_gate_model.onnx")
GATE_CLASSES_PATH = os.path.join(GATE_DIR, "gate_classes.json")

# 13-Class Classifier Model paths
CLASSIFIER_DIR = os.path.join(BASE_DIR, "plant_identifier_13", "exports")
CLASSIFIER_MODEL_PATH = os.path.join(CLASSIFIER_DIR, "medicinal_plant_model.onnx")
CLASSIFIER_CLASSES_PATH = os.path.join(CLASSIFIER_DIR, "classes.json")

# Global session and metadata variables
gate_session: Optional[ort.InferenceSession] = None
gate_metadata: Dict[str, Any] = {}
classifier_session: Optional[ort.InferenceSession] = None
classifier_metadata: Dict[str, Any] = {}

# Comprehensive metadata for the 13 supported medicinal species
SPECIES_CATALOG = {
    "aloe_vera": {
        "common_name": "Aloe Vera",
        "botanical_name": "Aloe barbadensis miller",
        "family": "Asphodelaceae",
        "key_benefits": "Skin healing, burn soothing, gut health, hydration",
    },
    "amla": {
        "common_name": "Amla (Indian Gooseberry)",
        "botanical_name": "Phyllanthus emblica",
        "family": "Phyllanthaceae",
        "key_benefits": "High vitamin C, immunity booster, hair nourishment, digestion",
    },
    "ashwagandha": {
        "common_name": "Ashwagandha (Indian Ginseng)",
        "botanical_name": "Withania somnifera",
        "family": "Solanaceae",
        "key_benefits": "Adaptogen, stress and cortisol reduction, vitality, sleep aid",
    },
    "ayapana": {
        "common_name": "Ayapana",
        "botanical_name": "Ayapana triplinervis",
        "family": "Asteraceae",
        "key_benefits": "Hemostatic wound healing, indigestion relief, antiseptic wash",
    },
    "brahmi": {
        "common_name": "Brahmi (Water Hyssop)",
        "botanical_name": "Bacopa monnieri",
        "family": "Plantaginaceae",
        "key_benefits": "Memory enhancement, cognitive clarity, neuroprotection, anxiety relief",
    },
    "gotu_kola": {
        "common_name": "Gotu Kola (Mandukaparni)",
        "botanical_name": "Centella asiatica",
        "family": "Apiaceae",
        "key_benefits": "Brain tonic, circulation, collagen synthesis, nervous calming",
    },
    "moringa": {
        "common_name": "Moringa (Drumstick Tree)",
        "botanical_name": "Moringa oleifera",
        "family": "Moringaceae",
        "key_benefits": "Superfood nutrient density, anti-inflammatory, antioxidant, energy",
    },
    "multi_vitamin_plant": {
        "common_name": "Multi Vitamin Plant (Chakra Muni / Katuk)",
        "botanical_name": "Sauropus androgynus",
        "family": "Phyllanthaceae",
        "key_benefits": "Multivitamin rich (A, B, C), calcium, iron, lactation support",
    },
    "neem": {
        "common_name": "Neem (Indian Lilac)",
        "botanical_name": "Azadirachta indica",
        "family": "Meliaceae",
        "key_benefits": "Potent antimicrobial, blood purifier, acne & skin healer, oral care",
    },
    "rosemary": {
        "common_name": "Rosemary",
        "botanical_name": "Salvia rosmarinus",
        "family": "Lamiaceae",
        "key_benefits": "Memory booster, hair follicle stimulation, respiratory decongestant",
    },
    "sarpagandha": {
        "common_name": "Sarpagandha (Indian Snakeroot)",
        "botanical_name": "Rauvolfia serpentina",
        "family": "Apocynaceae",
        "key_benefits": "Antihypertensive reserpine, blood pressure regulation, deep sedative",
    },
    "tulsi": {
        "common_name": "Tulsi (Holy Basil)",
        "botanical_name": "Ocimum tenuiflorum",
        "family": "Lamiaceae",
        "key_benefits": "Adaptogen, cough & cold relief, respiratory support, immune defense",
    },
    "wood_apple": {
        "common_name": "Wood Apple (Bael / Elephant Apple)",
        "botanical_name": "Limonia acidissima",
        "family": "Rutaceae",
        "key_benefits": "Digestive tonic, dysentery relief, gut cooling, antimicrobial",
    },
}


def load_models():
    """Load both ONNX sessions and metadata dictionaries."""
    global gate_session, gate_metadata, classifier_session, classifier_metadata

    # 1. Gatekeeper model
    if os.path.exists(GATE_MODEL_PATH):
        try:
            gate_session = ort.InferenceSession(
                GATE_MODEL_PATH,
                providers=["CPUExecutionProvider"],
            )
            logger.info("Stage 1 Gate ONNX Model loaded successfully from %s", GATE_MODEL_PATH)
        except Exception as e:
            logger.error("Failed to initialize Gate ONNX session: %s", e)
    else:
        logger.warning("Gate ONNX model not found at %s", GATE_MODEL_PATH)

    if os.path.exists(GATE_CLASSES_PATH):
        try:
            with open(GATE_CLASSES_PATH, "r", encoding="utf-8") as f:
                gate_metadata = json.load(f)
            logger.info("Gate metadata loaded: %s", gate_metadata.get("class_names"))
        except Exception as e:
            logger.error("Failed to read Gate metadata: %s", e)
    else:
        gate_metadata = {
            "class_names": ["non_plant", "plant"],
            "plant_class_index": 1,
            "image_size": 224,
        }

    # 2. 13-Class Identifier model
    if os.path.exists(CLASSIFIER_MODEL_PATH):
        try:
            classifier_session = ort.InferenceSession(
                CLASSIFIER_MODEL_PATH,
                providers=["CPUExecutionProvider"],
            )
            logger.info("Stage 2 13-Class Identifier loaded from %s", CLASSIFIER_MODEL_PATH)
        except Exception as e:
            logger.error("Failed to initialize Classifier ONNX session: %s", e)
    else:
        logger.warning("Classifier ONNX model not found at %s", CLASSIFIER_MODEL_PATH)

    if os.path.exists(CLASSIFIER_CLASSES_PATH):
        try:
            with open(CLASSIFIER_CLASSES_PATH, "r", encoding="utf-8") as f:
                classifier_metadata = json.load(f)
            logger.info("Classifier metadata loaded: %d classes", len(classifier_metadata.get("class_names", [])))
        except Exception as e:
            logger.error("Failed to read Classifier metadata: %s", e)
    else:
        classifier_metadata = {
            "class_names": list(SPECIES_CATALOG.keys()),
            "image_size": 224,
        }


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Lifecycle manager to load models on startup."""
    load_models()
    yield
    logger.info("Shutting down MediPlant Backend service.")


app = FastAPI(
    title="MediPlant AI Vision Gateway",
    description="Dual-Stage ONNX Inference Backend for Botanical Verification and Medicinal Classification",
    version="2.0.0",
    lifespan=lifespan,
)

# Enable CORS for Flutter mobile, web, and emulator clients
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Register Role-Based Access Control (RBAC) & Farmer Ecosystem Routers
from auth_routes import auth_router, seed_default_users
from farmer_routes import farmer_router, init_farmer_features
try:
    seed_default_users()
    app.include_router(auth_router)
    init_farmer_features()
    app.include_router(farmer_router)
    logger.info("RBAC Authentication and Farmer Ecosystem routes registered successfully.")
except Exception as e:
    logger.error("Failed to register RBAC/Farmer routes: %s", e)


def softmax(x: np.ndarray) -> np.ndarray:
    """Numerically stable softmax."""
    e_x = np.exp(x - np.max(x, axis=-1, keepdims=True))
    return e_x / np.sum(e_x, axis=-1, keepdims=True)


def preprocess_image_bytes(image_bytes: bytes, size: int = 224) -> np.ndarray:
    """
    Standard MediPlant Preprocessing:
      1. Open and convert to RGB
      2. Aspect-preserving resize (size * 1.14)
      3. Center-crop to (size, size)
      4. Float normalize [0, 1]
      5. ImageNet mean/std normalization
      6. Transpose HWC -> CHW and add batch dimension -> [1, 3, size, size]
    """
    try:
        img = Image.open(io.BytesIO(image_bytes)).convert("RGB")
    except Exception as exc:
        raise ValueError("Invalid or corrupted image format") from exc

    # Resize keeping aspect ratio, then center-crop
    target_crop = size
    target_scale = int(target_crop * 1.14)
    img = img.resize((target_scale, target_scale), Image.BILINEAR)

    w, h = img.size
    left = (w - target_crop) // 2
    top = (h - target_crop) // 2
    img = img.crop((left, top, left + target_crop, top + target_crop))

    # Convert to float numpy array normalized between [0, 1]
    arr = np.array(img, dtype=np.float32) / 255.0

    # ImageNet standard normalization
    mean = np.array([0.485, 0.456, 0.406], dtype=np.float32)
    std = np.array([0.229, 0.224, 0.225], dtype=np.float32)
    arr = (arr - mean) / std

    # Transpose HWC -> CHW, add batch dim -> [1, 3, 224, 224]
    arr = np.transpose(arr, (2, 0, 1))
    arr = np.expand_dims(arr, axis=0)
    return arr


@app.get("/")
def root():
    """Health status and metadata overview for Flutter BackendRecognitionService."""
    classes = classifier_metadata.get("class_names", list(SPECIES_CATALOG.keys()))
    return {
        "status": "online",
        "service": "MediPlant AI Vision Gateway",
        "version": "2.0.0",
        "pipeline": "Two-Stage ONNX Pipeline",
        "stage_1_gate": {
            "name": "Botanical Gatekeeper (Binary Filter)",
            "ready": gate_session is not None,
            "classes": gate_metadata.get("class_names", ["non_plant", "plant"]),
        },
        "stage_2_classifier": {
            "name": "13-Class Medicinal Plant Classifier",
            "ready": classifier_session is not None,
            "classes_count": len(classes),
            "supported_classes": classes,
        },
    }


@app.get("/health")
def health_check():
    return {
        "status": "healthy",
        "gate_ready": gate_session is not None,
        "classifier_ready": classifier_session is not None,
    }


@app.get("/classes")
def list_supported_classes():
    """Return catalog of all 13 supported medicinal plants."""
    classes = classifier_metadata.get("class_names", list(SPECIES_CATALOG.keys()))
    catalog = []
    for slug in classes:
        info = SPECIES_CATALOG.get(slug, {
            "common_name": slug.replace("_", " ").title(),
            "botanical_name": "Botanical Species",
            "family": "Flora",
            "key_benefits": "Traditional medicinal usage",
        })
        catalog.append({"slug": slug, **info})
    return {"count": len(catalog), "species": catalog}


@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    """
    Main inference endpoint:
      1. Gatekeeper Check: Is this a plant leaf/foliage?
      2. If plant, classify species among the 13 supported medicinal plants.
    """
    try:
        contents = await file.read()
        if not contents or len(contents) < 50:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Empty or invalid image data received.",
            )

        tensor = preprocess_image_bytes(contents, size=224)

        # ═════════════════════════════════════════════════════════════════════
        # STAGE 1: Botanical Gatekeeper Check
        # ═════════════════════════════════════════════════════════════════════
        if gate_session is not None:
            gate_inputs = {gate_session.get_inputs()[0].name: tensor}
            gate_outputs = gate_session.run(None, gate_inputs)
            gate_probs = softmax(gate_outputs[0])[0]

            plant_idx = gate_metadata.get("plant_class_index", 1)
            plant_prob = float(gate_probs[plant_idx])
            non_plant_prob = float(gate_probs[1 - plant_idx])

            # Rejection threshold: require at least 50% plant probability
            if plant_prob < 0.50:
                logger.info(
                    "Gatekeeper Rejected: Non-Plant (Plant: %.2f%%, Non-Plant: %.2f%%)",
                    plant_prob * 100,
                    non_plant_prob * 100,
                )
                return {
                    "is_plant": False,
                    "gate_passed": False,
                    "plant_name": None,
                    "confidence": round(non_plant_prob * 100, 2),
                    "message": (
                        "No botanical structures detected. "
                        "Please ensure the camera is focused clearly on plant foliage, leaves, or stems."
                    ),
                    "predictions": [],
                }

            logger.info("Gatekeeper Passed: Plant detected (Confidence: %.2f%%)", plant_prob * 100)

        # ═════════════════════════════════════════════════════════════════════
        # STAGE 2: 13-Class Medicinal Plant Classification
        # ═════════════════════════════════════════════════════════════════════
        if classifier_session is None:
            return {
                "is_plant": True,
                "gate_passed": True,
                "error": "Medicinal plant classifier model is not currently loaded.",
            }

        id_inputs = {classifier_session.get_inputs()[0].name: tensor}
        id_outputs = classifier_session.run(None, id_inputs)
        probs = softmax(id_outputs[0])[0]

        class_slugs = classifier_metadata.get("class_names", list(SPECIES_CATALOG.keys()))
        top_idx = int(np.argmax(probs))
        top_slug = class_slugs[top_idx] if top_idx < len(class_slugs) else f"plant_{top_idx}"
        top_conf = float(probs[top_idx])

        # Build full ranked predictions list
        ranked_predictions = []
        sorted_indices = np.argsort(probs)[::-1]
        for idx in sorted_indices:
            slug = class_slugs[idx] if idx < len(class_slugs) else f"plant_{idx}"
            info = SPECIES_CATALOG.get(slug, {})
            c_name = info.get("common_name", slug.replace("_", " ").title())
            b_name = info.get("botanical_name", "")
            ranked_predictions.append({
                "class_name": slug,
                "common_name": c_name,
                "botanical_name": b_name,
                "confidence": round(float(probs[idx]) * 100, 2),
            })

        species_info = SPECIES_CATALOG.get(top_slug, {})
        display_name = species_info.get("common_name", top_slug.replace("_", " ").title())

        logger.info(
            "Identified: %s (%s) with %.2f%% confidence",
            top_slug,
            display_name,
            top_conf * 100,
        )

        return {
            "is_plant": True,
            "gate_passed": True,
            "plant_name": top_slug,
            "common_name": display_name,
            "botanical_name": species_info.get("botanical_name", ""),
            "family": species_info.get("family", ""),
            "confidence": round(top_conf * 100, 2),
            "message": f"Identified as {display_name} with {round(top_conf * 100, 1)}% confidence.",
            "predictions": ranked_predictions,
        }

    except HTTPException:
        raise
    except ValueError as val_err:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(val_err),
        )
    except Exception as exc:
        logger.exception("Inference error occurred: %s", exc)
        return {
            "is_plant": False,
            "gate_passed": False,
            "error": f"An error occurred while processing the image: {str(exc)}",
        }


if __name__ == "__main__":
    print("=" * 60)
    print(" Starting MediPlant Dual-Stage Inference Backend")
    print(" Gatekeeper: plant_gate_model.onnx")
    print(" Classifier: medicinal_plant_model.onnx (13 Classes)")
    print(" URL:        http://0.0.0.0:8000")
    print("=" * 60)
    uvicorn.run(app, host="0.0.0.0", port=8000)
