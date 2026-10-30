"""
Standalone Training Script for MediPlant 13-Class Medicinal Plant Recognition.

Usage:
  python train.py
  python train.py --epochs 30 --batch-size 32 --lr 0.0003 --backbone mobilenet_v3_large
"""

import os
import sys
import argparse
import time
import torch
import torch.nn as nn
from torch.optim import AdamW
from torch.optim.lr_scheduler import CosineAnnealingLR
from tqdm import tqdm

from config import (
    TRAIN_DIR, VAL_DIR, CHECKPOINTS_DIR, NUM_CLASSES,
    BATCH_SIZE, EPOCHS, LEARNING_RATE, WEIGHT_DECAY,
    LABEL_SMOOTHING, IMAGE_SIZE, DEVICE
)
from model.network import build_model
from model.dataset_loader import create_dataloaders


def train_epoch(model, dataloader, criterion, optimizer, device):
    model.train()
    running_loss = 0.0
    correct = 0
    total = 0

    progress = tqdm(dataloader, desc="Training Batch", leave=False)
    for images, labels in progress:
        images = images.to(device, non_blocking=True)
        labels = labels.to(device, non_blocking=True)

        optimizer.zero_grad()
        outputs = model(images)
        loss = criterion(outputs, labels)
        loss.backward()
        optimizer.step()

        running_loss += loss.item() * images.size(0)
        _, preds = torch.max(outputs, 1)
        correct += torch.sum(preds == labels.data).item()
        total += labels.size(0)

        progress.set_postfix({
            "loss": f"{loss.item():.4f}",
            "acc": f"{100.0 * correct / total:.2f}%"
        })

    epoch_loss = running_loss / total
    epoch_acc = 100.0 * correct / total
    return epoch_loss, epoch_acc


def validate_epoch(model, dataloader, criterion, device):
    model.eval()
    running_loss = 0.0
    correct = 0
    total = 0

    with torch.no_grad():
        progress = tqdm(dataloader, desc="Validation Batch", leave=False)
        for images, labels in progress:
            images = images.to(device, non_blocking=True)
            labels = labels.to(device, non_blocking=True)

            outputs = model(images)
            loss = criterion(outputs, labels)

            running_loss += loss.item() * images.size(0)
            _, preds = torch.max(outputs, 1)
            correct += torch.sum(preds == labels.data).item()
            total += labels.size(0)

    epoch_loss = running_loss / total
    epoch_acc = 100.0 * correct / total
    return epoch_loss, epoch_acc


def main():
    parser = argparse.ArgumentParser(description="Train MediPlant 13-Class Vision Model")
    parser.add_argument("--epochs", type=int, default=EPOCHS, help="Number of training epochs")
    parser.add_argument("--batch-size", type=int, default=BATCH_SIZE, help="Mini-batch size")
    parser.add_argument("--lr", type=float, default=LEARNING_RATE, help="Base learning rate")
    parser.add_argument("--backbone", type=str, default="mobilenet_v3_large", choices=["mobilenet_v3_large", "efficientnet_b0"])
    args = parser.parse_args()

    print("\n========================================================")
    print(" MediPlant 13-Class Medicinal Plant Model Trainer")
    print("========================================================")
    print(f"Device:           {DEVICE} ({torch.cuda.get_device_name(0) if torch.cuda.is_available() else 'CPU'})")
    print(f"Backbone:         {args.backbone}")
    print(f"Number of classes: {NUM_CLASSES}")
    print(f"Epochs:           {args.epochs}")
    print(f"Batch Size:       {args.batch_size}")
    print(f"Learning Rate:    {args.lr}")
    print(f"Checkpoints:      {CHECKPOINTS_DIR}\n")

    # 1. Prepare DataLoaders
    print("Loading datasets...")
    try:
        train_loader, val_loader, class_names = create_dataloaders(
            train_dir=TRAIN_DIR,
            val_dir=VAL_DIR,
            batch_size=args.batch_size,
            image_size=IMAGE_SIZE
        )
    except FileNotFoundError as e:
        print(f"\n[ERROR] {e}")
        print("Please run `python scraper/download_plants.py` followed by `python scraper/organize_dataset.py` before training.")
        return

    print(f"Detected {len(class_names)} classes: {class_names}")
    print(f"Training samples:   {len(train_loader.dataset)}")
    print(f"Validation samples: {len(val_loader.dataset)}\n")

    # 2. Build Model
    model = build_model(num_classes=NUM_CLASSES, backbone=args.backbone, pretrained=True)
    model = model.to(DEVICE)

    # 3. Loss, Optimizer & Scheduler
    criterion = nn.CrossEntropyLoss(label_smoothing=LABEL_SMOOTHING)
    optimizer = AdamW(model.parameters(), lr=args.lr, weight_decay=WEIGHT_DECAY)
    scheduler = CosineAnnealingLR(optimizer, T_max=args.epochs, eta_min=1e-6)

    best_val_acc = 0.0
    best_model_path = os.path.join(CHECKPOINTS_DIR, "best_medicinal_model.pth")
    latest_model_path = os.path.join(CHECKPOINTS_DIR, "latest_medicinal_model.pth")

    print("Beginning training loop...\n")
    start_time = time.time()

    for epoch in range(1, args.epochs + 1):
        epoch_start = time.time()
        print(f"--- Epoch [{epoch:02d}/{args.epochs:02d}] (LR: {optimizer.param_groups[0]['lr']:.6f}) ---")

        train_loss, train_acc = train_epoch(model, train_loader, criterion, optimizer, DEVICE)
        val_loss, val_acc = validate_epoch(model, val_loader, criterion, DEVICE)
        scheduler.step()

        elapsed = time.time() - epoch_start
        print(f"  Train Loss: {train_loss:.4f} | Train Acc: {train_acc:.2f}%")
        print(f"  Val   Loss: {val_loss:.4f} | Val   Acc: {val_acc:.2f}% | Time: {elapsed:.1f}s")

        # Save checkpoint
        checkpoint = {
            "epoch": epoch,
            "backbone": args.backbone,
            "state_dict": model.state_dict(),
            "best_acc": max(best_val_acc, val_acc),
            "class_names": class_names,
            "optimizer": optimizer.state_dict()
        }
        torch.save(checkpoint, latest_model_path)

        if val_acc > best_val_acc:
            best_val_acc = val_acc
            torch.save(checkpoint, best_model_path)
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
