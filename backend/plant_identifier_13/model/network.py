import torch
import torch.nn as nn
from torchvision import models


class MedicinalPlantClassifier(nn.Module):
    """
    13-Class Medicinal Plant Recognition Network.
    Employs MobileNetV3-Large or EfficientNet-B0 backbone pre-trained on ImageNet,
    customized with a botanical feature classifier head.
    """
    def __init__(self, num_classes: int = 13, backbone: str = "mobilenet_v3_large", pretrained: bool = True):
        super(MedicinalPlantClassifier, self).__init__()
        self.backbone_name = backbone

        if backbone == "mobilenet_v3_large":
            weights = models.MobileNet_V3_Large_Weights.DEFAULT if pretrained else None
            base_model = models.mobilenet_v3_large(weights=weights)
            in_features = base_model.classifier[0].in_features
            
            # Preserve feature extractor
            self.features = base_model.features
            self.avgpool = base_model.avgpool
            
            # Custom botanical classification head
            self.classifier = nn.Sequential(
                nn.Linear(in_features, 512),
                nn.Hardswish(),
                nn.Dropout(p=0.3),
                nn.Linear(512, 256),
                nn.ReLU(inplace=True),
                nn.Dropout(p=0.2),
                nn.Linear(256, num_classes)
            )

        elif backbone == "efficientnet_b0":
            weights = models.EfficientNet_B0_Weights.DEFAULT if pretrained else None
            base_model = models.efficientnet_b0(weights=weights)
            in_features = base_model.classifier[1].in_features
            
            self.features = base_model.features
            self.avgpool = base_model.avgpool
            
            self.classifier = nn.Sequential(
                nn.Dropout(p=0.3),
                nn.Linear(in_features, 256),
                nn.SiLU(),
                nn.Dropout(p=0.2),
                nn.Linear(256, num_classes)
            )
        else:
            raise ValueError(f"Unsupported backbone: {backbone}. Choose 'mobilenet_v3_large' or 'efficientnet_b0'.")

    def forward(self, x: torch.Tensor) -> torch.Tensor:
        x = self.features(x)
        x = self.avgpool(x)
        x = torch.flatten(x, 1)
        x = self.classifier(x)
        return x


def build_model(num_classes: int = 13, backbone: str = "mobilenet_v3_large", pretrained: bool = True) -> nn.Module:
    model = MedicinalPlantClassifier(num_classes=num_classes, backbone=backbone, pretrained=pretrained)
    return model


if __name__ == "__main__":
    test_model = build_model(num_classes=13, backbone="mobilenet_v3_large", pretrained=False)
    dummy_input = torch.randn(2, 3, 224, 224)
    out = test_model(dummy_input)
    print(f"Model sanity test passed. Output shape: {out.shape} (Expected: [2, 13])")
