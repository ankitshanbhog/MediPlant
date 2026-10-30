import torch
import torch.nn as nn
from torchvision import models


class GateClassifier(nn.Module):
    """
    Lightweight Binary Plant vs Non-Plant Gate Classifier.
    Employs MobileNetV3-Small backbone pre-trained on ImageNet,
    customized with a binary classification head.
    """
    def __init__(self, backbone: str = "mobilenet_v3_small", pretrained: bool = True):
        super(GateClassifier, self).__init__()
        self.backbone_name = backbone

        if backbone == "mobilenet_v3_small":
            weights = models.MobileNet_V3_Small_Weights.DEFAULT if pretrained else None
            base_model = models.mobilenet_v3_small(weights=weights)
            in_features = base_model.classifier[0].in_features

            self.features = base_model.features
            self.avgpool = base_model.avgpool
            self.classifier = nn.Sequential(
                nn.Linear(in_features, 256),
                nn.Hardswish(),
                nn.Dropout(p=0.2),
                nn.Linear(256, 2)  # [non_plant, plant]
            )

        elif backbone == "mobilenet_v3_large":
            weights = models.MobileNet_V3_Large_Weights.DEFAULT if pretrained else None
            base_model = models.mobilenet_v3_large(weights=weights)
            in_features = base_model.classifier[0].in_features

            self.features = base_model.features
            self.avgpool = base_model.avgpool
            self.classifier = nn.Sequential(
                nn.Linear(in_features, 256),
                nn.Hardswish(),
                nn.Dropout(p=0.2),
                nn.Linear(256, 2)
            )
        else:
            raise ValueError(f"Unsupported backbone: {backbone}. Choose 'mobilenet_v3_small' or 'mobilenet_v3_large'.")

    def forward(self, x: torch.Tensor) -> torch.Tensor:
        x = self.features(x)
        x = self.avgpool(x)
        x = torch.flatten(x, 1)
        x = self.classifier(x)
        return x


def build_gate_model(backbone: str = "mobilenet_v3_small", pretrained: bool = True) -> nn.Module:
    return GateClassifier(backbone=backbone, pretrained=pretrained)


if __name__ == "__main__":
    model = build_gate_model("mobilenet_v3_small", pretrained=False)
    dummy = torch.randn(2, 3, 224, 224)
    out = model(dummy)
    print(f"Gate model sanity check passed! Output shape: {out.shape} (Expected: [2, 2])")
