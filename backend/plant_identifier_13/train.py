"""
Standalone Training Script for MediPlant 13-Class Medicinal Plant Recognition.

Usage:
  python train.py
  python train.py --epochs 30 --batch-size 32 --lr 0.0003 --backbone mobilenet_v3_large
"""

import os
import argparse
import time
import tensorflow as tf
from tqdm import tqdm

from config import (
    TRAIN_DIR,
    VAL_DIR,
    CHECKPOINTS_DIR,
    NUM_CLASSES,
    BATCH_SIZE,
    EPOCHS,
    LEARNING_RATE,
    WEIGHT_DECAY,
    LABEL_SMOOTHING,
    IMAGE_SIZE,
)
from model.network import build_model


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

    epoch_loss = running_loss / total
    epoch_acc = 100.0 * correct / total
    return epoch_loss, epoch_acc


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

    epoch_loss = running_loss / total
    epoch_acc = 100.0 * correct / total
    return epoch_loss, epoch_acc


def main():
    parser = argparse.ArgumentParser(description="Train MediPlant 13-Class Vision Model")
    parser.add_argument("--epochs", type=int, default=EPOCHS, help="Number of training epochs")
    parser.add_argument("--batch-size", type=int, default=BATCH_SIZE, help="Mini-batch size")
    parser.add_argument("--lr", type=float, default=LEARNING_RATE, help="Base learning rate")
    parser.add_argument("--backbone", type=str, default="mobilenet_v3_large",
                        choices=["mobilenet_v3_large", "efficientnet_b0"])
    args = parser.parse_args()

    gpus = tf.config.list_physical_devices("GPU")
    device_info = gpus[0].name if gpus else "CPU"

    print("\n========================================================")
    print(" MediPlant 13-Class Medicinal Plant Model Trainer")
    print("========================================================")
    print(f"Device:            {device_info}")
    print(f"Backbone:          {args.backbone}")
    print(f"Number of classes: {NUM_CLASSES}")
    print(f"Epochs:            {args.epochs}")
    print(f"Batch Size:        {args.batch_size}")
    print(f"Learning Rate:     {args.lr}")
    print(f"Checkpoints:       {CHECKPOINTS_DIR}\n")

    print("Loading datasets...")
    try:
        train_dataset = create_dataset(TRAIN_DIR, args.batch_size, IMAGE_SIZE, shuffle=True)
        val_dataset = create_dataset(VAL_DIR, args.batch_size, IMAGE_SIZE, shuffle=False)
        class_names = train_dataset.class_names
    except Exception as e:
        print(f"\n[ERROR] {e}")
        print("Please run `python scraper/download_plants.py` followed by `python scraper/organize_dataset.py` before training.")
        return

    print(f"Detected {len(class_names)} classes: {class_names}")
    print(f"Training batches:   {len(train_dataset)}")
    print(f"Validation batches: {len(val_dataset)}\n")

    model = build_model(num_classes=NUM_CLASSES, backbone=args.backbone, pretrained=True)

    lr_schedule = tf.keras.optimizers.schedules.CosineDecay(
        initial_learning_rate=args.lr,
        decay_steps=args.epochs,
        alpha=1e-6 / args.lr,
    )
    optimizer = tf.keras.optimizers.AdamW(learning_rate=lr_schedule, weight_decay=WEIGHT_DECAY)
    loss_fn = tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True)

    best_val_acc = 0.0
    os.makedirs(CHECKPOINTS_DIR, exist_ok=True)
    best_model_path = os.path.join(CHECKPOINTS_DIR, "best_medicinal_model.weights.h5")
    latest_model_path = os.path.join(CHECKPOINTS_DIR, "latest_medicinal_model.weights.h5")

    print("Beginning training loop...\n")
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

    total_time = (time.time() - start_time) / 60.0
    print("========================================================")
    print(f" Training Completed in {total_time:.2f} minutes.")
    print(f" Best Validation Accuracy: {best_val_acc:.2f}%")
    print(f" Best Weights File: {best_model_path}")
    print("========================================================")
    print("Next step: Run `python export_onnx.py` to produce the fast runtime model for backend deployment.")


if __name__ == "__main__":
    main()
