import tensorflow as tf
from tensorflow.keras import layers, callbacks

BATCH_SIZE = 32
IMG_SIZE = (224, 224)
SEED = 42

train_ds = tf.keras.utils.image_dataset_from_directory(
    "Check_dataset/train",
    label_mode="binary",
    shuffle=True,
    seed=SEED,
    batch_size=BATCH_SIZE,
    image_size=IMG_SIZE,
)

val_ds = tf.keras.utils.image_dataset_from_directory(
    "Check_dataset/val",
    label_mode="binary",
    shuffle=False,
    batch_size=BATCH_SIZE,
    image_size=IMG_SIZE,
)

print("Classes (index = label):", train_ds.class_names)
# Example: ['not_plant', 'plant'] → sigmoid output ≈ 1 means plant

AUTOTUNE = tf.data.AUTOTUNE
train_ds = train_ds.cache().prefetch(AUTOTUNE)
val_ds = val_ds.cache().prefetch(AUTOTUNE)

base_model = tf.keras.applications.MobileNetV2(
    input_shape=(224, 224, 3),
    include_top=False,
    weights="imagenet",
)
base_model.trainable = False

data_augmentation = tf.keras.Sequential([
    layers.RandomFlip("horizontal"),
    layers.RandomRotation(0.2),
])

inputs = tf.keras.Input(shape=(224, 224, 3))
x = data_augmentation(inputs)
x = layers.Rescaling(1.0 / 127.5, offset=-1.0)(x)  # same as MobileNetV2 preprocess
x = base_model(x, training=False)
x = layers.GlobalAveragePooling2D()(x)
x = layers.Dropout(0.3)(x)
outputs = layers.Dense(1, activation="sigmoid")(x)
model = tf.keras.Model(inputs, outputs)

model.compile(
    optimizer=tf.keras.optimizers.Adam(1e-3),
    loss="binary_crossentropy",
    metrics=[
        "accuracy",
        tf.keras.metrics.AUC(name="auc"),
        tf.keras.metrics.Precision(name="precision"),
        tf.keras.metrics.Recall(name="recall"),
    ],
)

ckpt = callbacks.ModelCheckpoint(
    "plant_gate_best.keras",
    monitor="val_auc",
    mode="max",
    save_best_only=True,
)

model.fit(train_ds, validation_data=val_ds, epochs=10, callbacks=[ckpt])

# Fine-tune last MobileNet blocks
base_model.trainable = True
for layer in base_model.layers[:120]:
    layer.trainable = False

model.compile(
    optimizer=tf.keras.optimizers.Adam(1e-5),
    loss="binary_crossentropy",
    metrics=[
        "accuracy",
        tf.keras.metrics.AUC(name="auc"),
        tf.keras.metrics.Precision(name="precision"),
        tf.keras.metrics.Recall(name="recall"),
    ],
)

# 5 more epochs (NOT epochs=5 and initial_epoch=10)
model.fit(
    train_ds,
    validation_data=val_ds,
    epochs=15,
    initial_epoch=10,
    callbacks=[ckpt],
)

model.load_weights("plant_gate_best.keras")
model.save("my_mobilenet_model.keras")