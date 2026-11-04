import tensorflow as tf


def hard_swish(x):
    return x * tf.nn.relu6(x + 3.0) / 6.0


class GateClassifier(tf.keras.Model):
    """
    Lightweight Binary Plant vs Non-Plant Gate Classifier.
    Employs MobileNetV3-Small backbone pre-trained on ImageNet,
    customized with a binary classification head.
    """

    def __init__(self, backbone="mobilenet_v3_small", pretrained=True):
        super(GateClassifier, self).__init__()
        self.backbone_name = backbone
        weights = "imagenet" if pretrained else None

        if backbone == "mobilenet_v3_small":
            self.base_model = tf.keras.applications.MobileNetV3Small(
                input_shape=(224, 224, 3),
                include_top=False,
                weights=weights,
            )
        elif backbone == "mobilenet_v3_large":
            self.base_model = tf.keras.applications.MobileNetV3Large(
                input_shape=(224, 224, 3),
                include_top=False,
                weights=weights,
            )
        else:
            raise ValueError(
                f"Unsupported backbone: {backbone}. "
                "Choose 'mobilenet_v3_small' or 'mobilenet_v3_large'."
            )

        self.pooling = tf.keras.layers.GlobalAveragePooling2D()
        self.dense1 = tf.keras.layers.Dense(256)
        self.dropout = tf.keras.layers.Dropout(0.2)
        self.dense2 = tf.keras.layers.Dense(2)

    def call(self, x, training=False):
        x = self.base_model(x, training=training)
        x = self.pooling(x)
        x = self.dense1(x)
        x = hard_swish(x)
        x = self.dropout(x, training=training)
        x = self.dense2(x)
        return x


def build_gate_model(backbone="mobilenet_v3_small", pretrained=True):
    return GateClassifier(backbone=backbone, pretrained=pretrained)


if __name__ == "__main__":
    model = build_gate_model("mobilenet_v3_small", pretrained=False)
    dummy = tf.random.normal((2, 224, 224, 3))
    out = model(dummy, training=False)
    print(f"Gate model sanity check passed! Output shape: {out.shape} (Expected: (2, 2))")
