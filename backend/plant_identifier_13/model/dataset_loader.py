import os
from torchvision import datasets, transforms
from torch.utils.data import DataLoader


def get_data_transforms(image_size: int = 224):
    """
    Returns data transforms with botanical leaf augmentations.
    Leaf identification requires robustness to orientation, angle, lighting, and shadow.
    """
    train_transform = transforms.Compose([
        transforms.RandomResizedCrop(image_size, scale=(0.75, 1.0)),
        transforms.RandomHorizontalFlip(p=0.5),
        transforms.RandomVerticalFlip(p=0.3),
        transforms.RandomRotation(degrees=35),
        transforms.ColorJitter(brightness=0.2, contrast=0.2, saturation=0.2, hue=0.05),
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225])
    ])

    val_transform = transforms.Compose([
        transforms.Resize(int(image_size * 1.14)),  # ~256
        transforms.CenterCrop(image_size),
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225])
    ])

    return train_transform, val_transform


def create_dataloaders(train_dir: str, val_dir: str, batch_size: int = 32, num_workers: int = 2, image_size: int = 224):
    """
    Constructs PyTorch DataLoaders using ImageFolder.
    """
    train_transform, val_transform = get_data_transforms(image_size=image_size)

    if not os.path.exists(train_dir) or not os.path.exists(val_dir):
        raise FileNotFoundError(f"Dataset directories not found: {train_dir} or {val_dir}. Please run scrapers first.")

    train_dataset = datasets.ImageFolder(root=train_dir, transform=train_transform)
    val_dataset = datasets.ImageFolder(root=val_dir, transform=val_transform)

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
