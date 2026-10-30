# MediPlant 13-Class Medicinal Plant Recognition Engine

This package contains the complete, self-contained machine learning pipeline to collect datasets, train, evaluate, and export a custom vision model for **13 targeted medicinal plant species** without any external APIs.

---

## 1. Supported Species

| # | Common Name | Botanical Name | Slug |
|---|---|---|---|
| 1 | **Ashwagandha** | *Withania somnifera* | `ashwagandha` |
| 2 | **Ayapana** | *Ayapana triplinervis* | `ayapana` |
| 3 | **Gotu Kola** | *Centella asiatica* | `gotu_kola` |
| 4 | **Rosemary** | *Salvia rosmarinus* | `rosemary` |
| 5 | **Wood Apple** | *Limonia acidissima* | `wood_apple` |
| 6 | **Moringa** | *Moringa oleifera* | `moringa` |
| 7 | **Tulsi** | *Ocimum tenuiflorum* | `tulsi` |
| 8 | **Neem** | *Azadirachta indica* | `neem` |
| 9 | **Aloe Vera** | *Aloe barbadensis* | `aloe_vera` |
| 10 | **Multi-Vitamin Plant** | *Sauropus androgynus* | `multi_vitamin_plant` |
| 11 | **Amla** | *Phyllanthus emblica* | `amla` |
| 12 | **Brahmi** | *Bacopa monnieri* | `brahmi` |
| 13 | **Sarpagandha** | *Rauvolfia serpentina* | `sarpagandha` |

---

## 2. Directory Layout & Data Storage

```
plant_identifier_13/
├── config.py                 # Plant species, search definitions & hyperparameters
├── requirements.txt          # Python dependencies
├── dataset/                  # Dataset storage (created automatically)
│   ├── raw/                  # Downloaded raw verified images per species
│   │   ├── ashwagandha/
│   │   ├── tulsi/
│   │   └── ... (all 13 species)
│   ├── train/                # 80% split for training
│   │   ├── ashwagandha/
│   │   └── ...
│   ├── val/                  # 20% split for validation/testing
│   │   ├── ashwagandha/
│   │   └── ...
│   └── dataset_summary.json  # Metadata breakdown of sample counts
├── scraper/
│   ├── download_plants.py    # Downloads botanical images from GBIF, Wikimedia & DuckDuckGo
│   └── organize_dataset.py   # Verifies file integrity, eliminates duplicates & creates train/val splits
├── model/
│   ├── network.py            # Neural network architecture (MobileNetV3 / EfficientNet-B0 + custom head)
│   └── dataset_loader.py     # Botanical augmentations (rotation, jitter, flip) & PyTorch DataLoaders
├── checkpoints/              # Checkpoints generated during training
│   ├── best_medicinal_model.pth
│   └── latest_medicinal_model.pth
├── exports/                  # Production-ready ONNX artifacts
│   ├── medicinal_plant_model.onnx
│   └── classes.json
├── train.py                  # Standalone training script (run manually)
├── evaluate.py               # Computes Precision, Recall, F1-Score & confusion matrix
├── export_onnx.py            # Exports PyTorch weights to lightweight ONNX runtime
└── test_inference.py         # CLI test tool for single image predictions
```

---

## 3. How to Run the Pipeline (Step-by-Step)

### Step 1: Install Dependencies
Open your terminal in this folder (`c:\Users\ANKIT SHANBHOG\Desktop\Backend\plant_identifier_13`):
```bash
pip install -r requirements.txt
```

### Step 2: Download the Dataset
Run the multi-source scraper. It will automatically download verified botanical images into `dataset/raw/`:
```bash
python scraper/download_plants.py
```
*Note: If you have your own leaf photos, you can simply drop them directly into `dataset/raw/<plant_slug>/` as well.*

### Step 3: Organize and Split the Dataset (80% Train / 20% Val)
Verify all images, purge corrupted files, and create the train/val split:
```bash
python scraper/organize_dataset.py
```

### Step 4: Train the Model Manually
Run the training script whenever you are ready:
```bash
# Standard training (MobileNetV3-Large, 25 epochs)
python train.py

# Or customize hyperparameters:
python train.py --epochs 30 --batch-size 32 --lr 0.0003 --backbone mobilenet_v3_large

# Or train using EfficientNet-B0 backbone:
python train.py --epochs 30 --backbone efficientnet_b0
```
* The training script automatically tracks loss/accuracy, applies learning rate decay, and saves the best model to `checkpoints/best_medicinal_model.pth`.

### Step 5: Evaluate Accuracy & Metrics
Check per-class performance (Precision, Recall, F1-Score):
```bash
python evaluate.py
```

### Step 6: Export to ONNX for Production
Convert the trained `.pth` model to a production `.onnx` model:
```bash
python export_onnx.py
```
This produces:
- `exports/medicinal_plant_model.onnx` (~15 MB, runs in ~25ms on CPU)
- `exports/classes.json`

### Step 7: Test an Image
Test any individual image locally:
```bash
python test_inference.py --image path/to/leaf_photo.jpg
```
