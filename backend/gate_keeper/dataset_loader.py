import os
from torchvision import datasets, transforms
from torch.utils.data import DataLoader


def get_gate_transforms(image_size: int = 224):
    train_transform = transforms.Compose([
        transforms.RandomResizedCrop(image_size, scale=(0.8, 1.0)),
        transforms.RandomHorizontalFlip(p=0.5),
        transforms.RandomRotation(degrees=25),
        transforms.ColorJitter(brightness=0.15, contrast=0.15),
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225])
    ])

    val_transform = transforms.Compose([
        transforms.Resize(int(image_size * 1.14)),
        transforms.CenterCrop(image_size),
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225])
    ])

    return train_transform, val_transform


def create_gate_dataloaders(train_dir: str, val_dir: str, batch_size: int = 32, num_workers: int = 2, image_size: int = 224):
    if not os.path.exists(train_dir) or not os.path.exists(val_dir):
        raise FileNotFoundError("Train or Val directory not found. Please run `python organize_gate_dataset.py` first.")

    train_tf, val_tf = get_gate_transforms(image_size=image_size)

    train_dataset = datasets.ImageFolder(root=train_dir, transform=train_tf)
    val_dataset = datasets.ImageFolder(root=val_dir, transform=val_tf)

    train_loader = DataLoader(
        train_dataset,
        batch_size=batch_size,
        shuffle=True,
        num_workers=num_workers,
        pin_memory=True
    )

    val_loader = DataLoader(
        val_dataset,
        batch_size=batch_size,
        shuffle=False,
        num_workers=num_workers,
        pin_memory=True
    )

    return train_loader, val_loader, train_dataset.classes
