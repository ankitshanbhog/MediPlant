
import json
import numpy as np
import pandas as pd
import tensorflow as tf
import matplotlib.pyplot as plt

from pathlib import Path
from sklearn.utils.class_weight import compute_class_weight
from sklearn.metrics import classification_report, confusion_matrix

# ============================================================
# 1. CONFIGURATION
# ============================================================

DATASET_DIR = Path("Medicinal_dataset_split")
TRAIN_DIR = DATASET_DIR / "train"
VAL_DIR = DATASET_DIR / "val"
TEST_DIR = DATASET_DIR / "test"

IMAGE_SIZE = (224, 224)
BATCH_SIZE = 16
SEED = 42

HEAD_EPOCHS = 15
FINE_TUNE_EPOCHS = 15

MODEL_BEST_PATH = "mediplant_10class_best.keras"
MODEL_FINAL_PATH = "mediplant_10class.keras"
LABELS_PATH = "mediplant_10class_labels.json"

REPORT_PATH = "mediplant_10class_report.txt"
MATRIX_CSV_PATH = "mediplant_10class_confusion_matrix.csv"
MATRIX_PNG_PATH = "mediplant_10class_confusion_matrix.png"
HISTORY_PNG_PATH = "mediplant_10class_training_history.png"

tf.keras.utils.set_random_seed(SEED)

# ============================================================
# 2. CHECK DATASET
# ============================================================

for folder in [TRAIN_DIR, VAL_DIR, TEST_DIR]:
    if not folder.exists():
        raise FileNotFoundError(
            f"Folder not found: {folder.resolve()}"
        )

train_ds = tf.keras.utils.image_dataset_from_directory(
    TRAIN_DIR,
    image_size=IMAGE_SIZE,
    batch_size=BATCH_SIZE,
    label_mode="int",
    shuffle=True,
    seed=SEED
)

val_ds = tf.keras.utils.image_dataset_from_directory(
    VAL_DIR,
    image_size=IMAGE_SIZE,
    batch_size=BATCH_SIZE,
    label_mode="int",
    shuffle=False
)

test_ds = tf.keras.utils.image_dataset_from_directory(
    TEST_DIR,
    image_size=IMAGE_SIZE,
    batch_size=BATCH_SIZE,
    label_mode="int",
    shuffle=False
)

class_names = train_ds.class_names
NUM_CLASSES = len(class_names)

if NUM_CLASSES != 10:
    raise ValueError(
        f"Expected 10 classes, found {NUM_CLASSES}: {class_names}"
    )

if val_ds.class_names != class_names:
    raise ValueError("Class order differs between train and val.")

if test_ds.class_names != class_names:
    raise ValueError("Class order differs between train and test.")

print("\nClass order:")
for i, name in enumerate(class_names):
    print(f"{i}: {name}")

with open(LABELS_PATH, "w", encoding="utf-8") as f:
    json.dump(
        {str(i): name for i, name in enumerate(class_names)},
        f,
        indent=4
    )

# ============================================================
# 3. COUNT TRAINING IMAGES AND CLASS WEIGHTS
# ============================================================

class_counts = np.zeros(NUM_CLASSES, dtype=np.int64)

count_ds = tf.keras.utils.image_dataset_from_directory(
    TRAIN_DIR,
    image_size=IMAGE_SIZE,
    batch_size=BATCH_SIZE,
    label_mode="int",
    class_names=class_names,
    shuffle=False
)

for _, labels in count_ds:
    class_counts += np.bincount(
        labels.numpy(),
        minlength=NUM_CLASSES
    )

if np.any(class_counts == 0):
    raise ValueError("At least one class has no training images.")

weights = compute_class_weight(
    class_weight="balanced",
    classes=np.arange(NUM_CLASSES),
    y=np.repeat(np.arange(NUM_CLASSES), class_counts)
)

class_weights = {
    i: float(weights[i]) for i in range(NUM_CLASSES)
}

print("\nTraining images per class:")
for i, name in enumerate(class_names):
    print(f"{name}: {class_counts[i]}")

print("\nClass weights:", class_weights)

del count_ds

# ============================================================
# 4. DATA AUGMENTATION AND PREPROCESSING
# ============================================================

augmentation = tf.keras.Sequential([
    tf.keras.layers.RandomFlip("horizontal"),
    tf.keras.layers.RandomRotation(0.08),
    tf.keras.layers.RandomZoom(0.10),
    tf.keras.layers.RandomContrast(0.10),
], name="data_augmentation")

preprocess = tf.keras.layers.Rescaling(
    scale=1.0 / 127.5,
    offset=-1.0
)

AUTOTUNE = tf.data.AUTOTUNE

def prepare_train(images, labels):
    images = augmentation(images, training=True)
    images = preprocess(images)
    return images, labels

def prepare_eval(images, labels):
    images = preprocess(images)
    return images, labels

train_ds = train_ds.map(
    prepare_train,
    num_parallel_calls=AUTOTUNE
).prefetch(AUTOTUNE)

val_ds = val_ds.map(
    prepare_eval,
    num_parallel_calls=AUTOTUNE
).prefetch(AUTOTUNE)

test_ds = test_ds.map(
    prepare_eval,
    num_parallel_calls=AUTOTUNE
).prefetch(AUTOTUNE)

# ============================================================
# 5. BUILD MOBILENETV2 MODEL
# ============================================================

base_model = tf.keras.applications.MobileNetV2(
    input_shape=(*IMAGE_SIZE, 3),
    include_top=False,
    weights="imagenet"
)

base_model.trainable = False

inputs = tf.keras.Input(shape=(*IMAGE_SIZE, 3))

x = base_model(inputs, training=False)
x = tf.keras.layers.GlobalAveragePooling2D()(x)
x = tf.keras.layers.Dropout(0.30)(x)

outputs = tf.keras.layers.Dense(
    NUM_CLASSES,
    activation="softmax"
)(x)

model = tf.keras.Model(inputs, outputs)

model.compile(
    optimizer=tf.keras.optimizers.Adam(learning_rate=1e-3),
    loss="sparse_categorical_crossentropy",
    metrics=["accuracy"]
)

model.summary()

# ============================================================
# 6. CALLBACKS
# ============================================================

callbacks = [
    tf.keras.callbacks.ModelCheckpoint(
        MODEL_BEST_PATH,
        monitor="val_loss",
        save_best_only=True,
        verbose=1
    ),
    tf.keras.callbacks.EarlyStopping(
        monitor="val_loss",
        patience=5,
        restore_best_weights=True,
        verbose=1
    ),
    tf.keras.callbacks.ReduceLROnPlateau(
        monitor="val_loss",
        factor=0.2,
        patience=2,
        min_lr=1e-7,
        verbose=1
    )
]

# ============================================================
# 7. STAGE 1: TRAIN CLASSIFICATION HEAD
# ============================================================

print("\n========== STAGE 1: TRAINING HEAD ==========\n")

history_head = model.fit(
    train_ds,
    validation_data=val_ds,
    epochs=HEAD_EPOCHS,
    class_weight=class_weights,
    callbacks=callbacks
)

# ============================================================
# 8. STAGE 2: FINE-TUNE MOBILENETV2
# ============================================================

print("\n========== STAGE 2: FINE-TUNING ==========\n")

base_model.trainable = True

for layer in base_model.layers[:-30]:
    layer.trainable = False

for layer in base_model.layers:
    if isinstance(layer, tf.keras.layers.BatchNormalization):
        layer.trainable = False

model.compile(
    optimizer=tf.keras.optimizers.Adam(learning_rate=1e-5),
    loss="sparse_categorical_crossentropy",
    metrics=["accuracy"]
)

history_fine = model.fit(
    train_ds,
    validation_data=val_ds,
    epochs=FINE_TUNE_EPOCHS,
    class_weight=class_weights,
    callbacks=callbacks
)

# ============================================================
# 9. LOAD AND SAVE BEST MODEL
# ============================================================

print("\n========== SAVING BEST MODEL ==========\n")

best_model = tf.keras.models.load_model(MODEL_BEST_PATH)
best_model.save(MODEL_FINAL_PATH)

print(f"Model saved: {MODEL_FINAL_PATH}")
print(f"Labels saved: {LABELS_PATH}")

# ============================================================
# 10. TEST EVALUATION
# ============================================================

print("\n========== TEST EVALUATION ==========\n")

test_loss, test_accuracy = best_model.evaluate(
    test_ds,
    verbose=1
)

print(f"\nTest loss: {test_loss:.4f}")
print(f"Test accuracy: {test_accuracy * 100:.2f}%")

y_true = np.concatenate([
    labels.numpy() for _, labels in test_ds
])

y_prob = best_model.predict(test_ds, verbose=1)
y_pred = np.argmax(y_prob, axis=1)

# ============================================================
# 11. CLASSIFICATION REPORT
# ============================================================

report = classification_report(
    y_true,
    y_pred,
    labels=np.arange(NUM_CLASSES),
    target_names=class_names,
    digits=4,
    zero_division=0
)

print("\nClassification Report:\n")
print(report)

with open(REPORT_PATH, "w", encoding="utf-8") as f:
    f.write(f"Test accuracy: {test_accuracy * 100:.2f}%\n\n")
    f.write(report)

# ============================================================
# 12. CONFUSION MATRIX
# ============================================================

cm = confusion_matrix(
    y_true,
    y_pred,
    labels=np.arange(NUM_CLASSES)
)

pd.DataFrame(
    cm,
    index=class_names,
    columns=class_names
).to_csv(MATRIX_CSV_PATH)

plt.figure(figsize=(12, 10))
plt.imshow(cm, interpolation="nearest", cmap="Blues")
plt.title("MediPlant 10-Class Confusion Matrix")
plt.colorbar()

positions = np.arange(NUM_CLASSES)
plt.xticks(positions, class_names, rotation=45, ha="right")
plt.yticks(positions, class_names)

threshold = cm.max() / 2 if cm.size else 0

for i in range(NUM_CLASSES):
    for j in range(NUM_CLASSES):
        plt.text(
            j, i, str(cm[i, j]),
            ha="center",
            va="center",
            color="white" if cm[i, j] > threshold else "black"
        )

plt.ylabel("Actual Plant")
plt.xlabel("Predicted Plant")
plt.tight_layout()
plt.savefig(MATRIX_PNG_PATH, dpi=200, bbox_inches="tight")
plt.show()

# ============================================================
# 13. TRAINING HISTORY
# ============================================================

def history_values(history, key):
    return history.history.get(key, [])

train_acc = (
    history_values(history_head, "accuracy")
    + history_values(history_fine, "accuracy")
)
val_acc = (
    history_values(history_head, "val_accuracy")
    + history_values(history_fine, "val_accuracy")
)
train_loss = (
    history_values(history_head, "loss")
    + history_values(history_fine, "loss")
)
val_loss = (
    history_values(history_head, "val_loss")
    + history_values(history_fine, "val_loss")
)

plt.figure(figsize=(12, 5))

plt.subplot(1, 2, 1)
plt.plot(train_acc, label="Training accuracy")
plt.plot(val_acc, label="Validation accuracy")
plt.title("Accuracy")
plt.xlabel("Epoch")
plt.legend()

plt.subplot(1, 2, 2)
plt.plot(train_loss, label="Training loss")
plt.plot(val_loss, label="Validation loss")
plt.title("Loss")
plt.xlabel("Epoch")
plt.legend()

plt.tight_layout()
plt.savefig(HISTORY_PNG_PATH, dpi=200)
plt.show()

print("\n========== TRAINING COMPLETED ==========")
print("Model:", MODEL_FINAL_PATH)
print("Labels:", LABELS_PATH)
print("Report:", REPORT_PATH)
print("Confusion matrix:", MATRIX_PNG_PATH)
print("Confusion matrix CSV:", MATRIX_CSV_PATH)
print("Training plots:", HISTORY_PNG_PATH)
