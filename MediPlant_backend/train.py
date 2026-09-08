import json
import os
from collections import Counter

import numpy as np
import tensorflow as tf
from sklearn.metrics import classification_report, confusion_matrix
from sklearn.utils.class_weight import compute_class_weight
from tensorflow.keras import layers, callbacks

# 1. BASIC SETTINGS
BATCH_SIZE = 32
IMG_SIZE = (224, 224)
SEED = 42
EXPECTED_NUM_CLASSES = 20

TRAIN_DIR = "Medicinal_dataset/train"
VAL_DIR = "Medicinal_dataset/val"
TEST_DIR = "Medicinal_dataset/test"

tf.keras.utils.set_random_seed(SEED)


# 2. LOAD TRAINING DATASET
train_ds = tf.keras.utils.image_dataset_from_directory(
    TRAIN_DIR,
    label_mode="int",
    shuffle=True,
    seed=SEED,
    batch_size=BATCH_SIZE,
    image_size=IMG_SIZE,
)

# 3. LOAD VALIDATION DATASET
val_ds = tf.keras.utils.image_dataset_from_directory(
    VAL_DIR,
    label_mode="int",
    shuffle=False,
    batch_size=BATCH_SIZE,
    image_size=IMG_SIZE,
)

# 4. GET CLASS NAMES AND SANITY-CHECK
class_names = train_ds.class_names
val_class_names = val_ds.class_names

assert class_names == val_class_names, (
    "Train/val class names or order do not match.\n"
    f"train: {class_names}\n"
    f"val:   {val_class_names}"
)

NUM_CLASSES = len(class_names)

assert NUM_CLASSES == EXPECTED_NUM_CLASSES, (
    f"Expected {EXPECTED_NUM_CLASSES} classes, got {NUM_CLASSES}: {class_names}"
)

print("Classes:")
for index, name in enumerate(class_names):
    print(f"  {index} -> {name}")
print("Number of classes:", NUM_CLASSES)

with open("class_names.json", "w", encoding="utf-8") as f:
    json.dump(class_names, f, indent=2, ensure_ascii=False)

print("Saved class_names.json")

# 5. OPTIMIZE DATA PIPELINE
AUTOTUNE = tf.data.AUTOTUNE

train_ds = train_ds.cache().prefetch(AUTOTUNE)
val_ds = val_ds.cache().prefetch(AUTOTUNE)


# 6. CLASS WEIGHTS (helps if some plants have fewer images)
label_list = []
for _, labels in train_ds:
    label_list.extend(labels.numpy().tolist())

label_array = np.array(label_list, dtype=np.int32)
counts = Counter(label_array)
print("Train images per class:", dict(sorted(counts.items())))

weights = compute_class_weight(
    class_weight="balanced",
    classes=np.arange(NUM_CLASSES),
    y=label_array,
)
class_weight = {i: float(w) for i, w in enumerate(weights)}
print("Class weights:", class_weight)

# 7. LOAD PRETRAINED MOBILENETV2
base_model = tf.keras.applications.MobileNetV2(
    input_shape=(224, 224, 3),
    include_top=False,
    weights="imagenet",
)

base_model.trainable = False

# 8. DATA AUGMENTATION
data_augmentation = tf.keras.Sequential([
    layers.RandomFlip("horizontal"),
    layers.RandomRotation(0.2),
    layers.RandomZoom(0.1),
    layers.RandomContrast(0.1),
])

# 9. BUILD MODEL
inputs = tf.keras.Input(shape=(224, 224, 3))
x = data_augmentation(inputs)
x = layers.Rescaling(1.0 / 127.5, offset=-1.0)(x)
x = base_model(x, training=False)
x = layers.GlobalAveragePooling2D()(x)
x = layers.Dropout(0.3)(x)
outputs = layers.Dense(NUM_CLASSES, activation="softmax")(x)

model = tf.keras.Model(inputs, outputs)


def compile_model(learning_rate):
    model.compile(
        optimizer=tf.keras.optimizers.Adam(learning_rate=learning_rate),
        loss="sparse_categorical_crossentropy",
        metrics=[
            "accuracy",
            tf.keras.metrics.SparseTopKCategoricalAccuracy(k=3, name="top3"),
        ],
    )


compile_model(1e-3)


# 10. CALLBACKS
ckpt = callbacks.ModelCheckpoint(
    "medicinal_plant_best.keras",
    monitor="val_accuracy",
    mode="max",
    save_best_only=True,
)

early = callbacks.EarlyStopping(
    monitor="val_accuracy",
    patience=3,
    restore_best_weights=False,
)

# 11. FIRST TRAINING STAGE
print("\nStarting initial training...\n")

model.fit(
    train_ds,
    validation_data=val_ds,
    epochs=10,
    class_weight=class_weight,
    callbacks=[ckpt, early],
)

# 12. FINE-TUNING
print("\nStarting fine-tuning...\n")

base_model.trainable = True

for layer in base_model.layers[:120]:
    layer.trainable = False

compile_model(1e-5)

model.fit(
    train_ds,
    validation_data=val_ds,
    epochs=15,
    initial_epoch=10,
    class_weight=class_weight,
    callbacks=[ckpt, early],
)

# 13. LOAD BEST CHECKPOINT AND SAVE FINAL MODEL
model.load_weights("medicinal_plant_best.keras")
model.save("medicinal_plant_model.keras")

print("\nEvaluating best checkpoint on validation set...")
val_results = model.evaluate(val_ds, return_dict=True)
print(val_results)


# 14. OPTIONAL TEST SET (use this number in the report)
if os.path.isdir(TEST_DIR):
    test_ds = tf.keras.utils.image_dataset_from_directory(
        TEST_DIR,
        label_mode="int",
        shuffle=False,
        batch_size=BATCH_SIZE,
        image_size=IMG_SIZE,
    )
    assert test_ds.class_names == class_names, (
        "Test class names or order do not match train.\n"
        f"train: {class_names}\n"
        f"test:  {test_ds.class_names}"
    )
    test_ds = test_ds.cache().prefetch(AUTOTUNE)
    print("\nEvaluating on test set...")
    print(model.evaluate(test_ds, return_dict=True))
else:
    test_ds = None
    print(f"\nNo test folder at {TEST_DIR} — report test accuracy once you add one.")

# 15. CONFUSION MATRIX AND PER-CLASS REPORT (validation)

def collect_labels_and_preds(dataset):
    y_true, y_pred, y_conf = [], [], []
    for images, labels in dataset:
        probs = model.predict(images, verbose=0)
        y_true.extend(labels.numpy())
        y_pred.extend(np.argmax(probs, axis=1))
        y_conf.extend(np.max(probs, axis=1))
    return np.array(y_true), np.array(y_pred), np.array(y_conf)


y_true, y_pred, y_conf = collect_labels_and_preds(val_ds)

print("\nClassification report (validation):\n")
print(classification_report(y_true, y_pred, target_names=class_names, digits=4))

print("Confusion matrix (rows = true, columns = predicted):")
print(confusion_matrix(y_true, y_pred))

# Helps you pick an "unknown / call API" threshold later
print("\nMean max-softmax on validation:", float(np.mean(y_conf)))
print("Min max-softmax on validation:", float(np.min(y_conf)))


print("\nTraining complete.")
print("Files written:")
print("  medicinal_plant_best.keras")
print("  medicinal_plant_model.keras")
print("  class_names.json")