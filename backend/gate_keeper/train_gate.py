"""
Training Script for MediPlant Gate Keeper (Plant vs Non-Plant Filter).

Usage:
  python train_gate.py
  python train_gate.py --epochs 15 --batch-size 32 --lr 0.0003 --backbone mobilenet_v3_small
"""

import os
import argparse
import time
import tensorflow as tf
from tqdm import tqdm

from config import (
    TRAIN_DIR, VAL_DIR, CHECKPOINTS_DIR, BATCH_SIZE,
    EPOCHS, LEARNING_RATE, WEIGHT_DECAY, IMAGE_SIZE, CLASSES
)
from model import build_gate_model


def create_dataset(directory, batch_size, image_size, shuffle=True):
    dataset = tf.keras.utils.image_dataset_from_directory(
        directory,
        image_size=(image_size, image_size),
        batch_size=batch_size,
        shuffle=shuffle,
        label_mode="int",
    )
    rescale = tf.keras.layers.Rescaling(1.0 / 255)
    dataset = dataset.map(lambda x, y: (rescale(x), y), num_parallel_calls=tf.data.AUTOTUNE)
    dataset = dataset.prefetch(tf.data.AUTOTUNE)
    return dataset


def train_epoch(model, dataset, loss_fn, optimizer):
    running_loss = 0.0
    correct = 0
    total = 0

    for images, labels in tqdm(dataset, desc="Training Batch", leave=False):
        with tf.GradientTape() as tape:
            outputs = model(images, training=True)
            loss = loss_fn(labels, outputs)

        gradients = tape.gradient(loss, model.trainable_variables)
        optimizer.apply_gradients(zip(gradients, model.trainable_variables))

        batch_size = images.shape[0]
        running_loss += loss.numpy() * batch_size
        preds = tf.argmax(outputs, axis=1, output_type=tf.int32)
        correct += tf.reduce_sum(tf.cast(preds == tf.cast(labels, tf.int32), tf.int32)).numpy()
        total += batch_size

    return running_loss / total, 100.0 * correct / total


def validate_epoch(model, dataset, loss_fn):
    running_loss = 0.0
    correct = 0
    total = 0

    for images, labels in tqdm(dataset, desc="Validation Batch", leave=False):
        outputs = model(images, training=False)
        loss = loss_fn(labels, outputs)

        batch_size = images.shape[0]
        running_loss += loss.numpy() * batch_size
        preds = tf.argmax(outputs, axis=1, output_type=tf.int32)
        correct += tf.reduce_sum(tf.cast(preds == tf.cast(labels, tf.int32), tf.int32)).numpy()
        total += batch_size

    return running_loss / total, 100.0 * correct / total


def main():
    parser = argparse.ArgumentParser(description="Train MediPlant Plant vs Non-Plant Gate Model")
    parser.add_argument("--epochs", type=int, default=EPOCHS, help="Number of epochs (default: 15)")
    parser.add_argument("--batch-size", type=int, default=BATCH_SIZE, help="Batch size (default: 32)")
    parser.add_argument("--lr", type=float, default=LEARNING_RATE, help="Learning rate (default: 0.0003)")
    parser.add_argument("--backbone", type=str, default="mobilenet_v3_small",
                        choices=["mobilenet_v3_small", "mobilenet_v3_large"])
    args = parser.parse_args()

    gpus = tf.config.list_physical_devices("GPU")
    device_info = gpus[0].name if gpus else "CPU"

    print("\n========================================================")
    print(" MediPlant Gate Keeper Model Trainer")
    print(" (Binary Classifier: Non-Plant vs Plant)")
    print("========================================================")
    print(f"Device:        {device_info}")
    print(f"Backbone:      {args.backbone}")
    print(f"Epochs:        {args.epochs}")
    print(f"Batch Size:    {args.batch_size}")
    print(f"Learning Rate: {args.lr}")
    print(f"Checkpoints:   {CHECKPOINTS_DIR}\n")

    try:
        train_dataset = create_dataset(TRAIN_DIR, args.batch_size, IMAGE_SIZE, shuffle=True)
        val_dataset = create_dataset(VAL_DIR, args.batch_size, IMAGE_SIZE, shuffle=False)
        class_names = train_dataset.class_names
    except Exception as e:
        print(f"[ERROR] {e}")
        return

    print(f"Classes:            {class_names}")
    print(f"Training batches:   {len(train_dataset)}")
    print(f"Validation batches: {len(val_dataset)}\n")

    model = build_gate_model(backbone=args.backbone, pretrained=True)

    lr_schedule = tf.keras.optimizers.schedules.CosineDecay(
        initial_learning_rate=args.lr,
        decay_steps=args.epochs,
        alpha=1e-6 / args.lr,
    )
    optimizer = tf.keras.optimizers.AdamW(learning_rate=lr_schedule, weight_decay=WEIGHT_DECAY)
    loss_fn = tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True)

    best_val_acc = 0.0
    os.makedirs(CHECKPOINTS_DIR, exist_ok=True)
    best_model_path = os.path.join(CHECKPOINTS_DIR, "best_gate_model.weights.h5")
    latest_model_path = os.path.join(CHECKPOINTS_DIR, "latest_gate_model.weights.h5")

    start_time = time.time()

    for epoch in range(1, args.epochs + 1):
        epoch_start = time.time()
        current_lr = float(lr_schedule(optimizer.iterations))
        print(f"--- Epoch [{epoch:02d}/{args.epochs:02d}] (LR: {current_lr:.6f}) ---")

        train_loss, train_acc = train_epoch(model, train_dataset, loss_fn, optimizer)
        val_loss, val_acc = validate_epoch(model, val_dataset, loss_fn)

        elapsed = time.time() - epoch_start
        print(f"  Train Loss: {train_loss:.4f} | Train Acc: {train_acc:.2f}%")
        print(f"  Val   Loss: {val_loss:.4f} | Val   Acc: {val_acc:.2f}% | Time: {elapsed:.1f}s")

        model.save_weights(latest_model_path)

        if val_acc > best_val_acc:
            best_val_acc = val_acc
            model.save_weights(best_model_path)
            print(f"  [+] New Best Model Saved! (Val Accuracy: {best_val_acc:.2f}%)")

        print()

    total_min = (time.time() - start_time) / 60.0
    print("========================================================")
    print(f" Gate Model Training Complete in {total_min:.2f} minutes.")
    print(f" Best Validation Accuracy: {best_val_acc:.2f}%")
    print(f" Best Weights File: {best_model_path}")
    print("========================================================")
    print("Next step: Run `python evaluate_gate.py` to inspect precision/recall.")
    print("Then: Run `python export_gate_onnx.py` to create the runtime model.")


if __name__ == "__main__":
    main()
