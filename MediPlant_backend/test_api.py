import os
from PIL import Image
from fastapi.testclient import TestClient
from app import app

client = TestClient(app)
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

def test_health():
    response = client.get("/")
    print("Health check response:", response.status_code, response.json())
    assert response.status_code == 200
    data = response.json()
    assert data["gate_ready"] is True
    assert data["classifier_ready"] is True

def test_prediction_with_dataset_image():
    sample_path = os.path.join(BASE_DIR, "Medicinal_dataset", "train", "tulsi_plant", "tulsi_train_original_0000.jpg")
    if os.path.exists(sample_path):
        with open(sample_path, "rb") as f:
            img_bytes = f.read()

        response = client.post(
            "/predict",
            files={"file": ("tulsi_sample.jpg", img_bytes, "image/jpeg")},
        )
        print("Tulsi Prediction response:", response.status_code, response.json())
        assert response.status_code == 200
        data = response.json()
        assert data["is_plant"] is True
        print(f"Recognized plant: {data['plant_name']} with confidence {data['confidence']}%")
    else:
        print("Sample image not found at", sample_path)

if __name__ == "__main__":
    print("Testing health endpoint...")
    test_health()
    print("\nTesting prediction on real Tulsi dataset image...")
    test_prediction_with_dataset_image()
    print("\n[SUCCESS] All backend API tests passed successfully!")
