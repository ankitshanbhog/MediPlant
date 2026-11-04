import tensorflow as tf


def hard_swish(x):
    return x * tf.nn.relu6(x + 3.0) / 6.0


class MedicinalPlantClassifier(tf.keras.Model):
    """
    13-Class Medicinal Plant Recognition Network.
    Employs MobileNetV3-Large or EfficientNet-B0 backbone pre-trained on ImageNet,
    customized with a botanical feature classifier head.
    """

    def __init__(self, num_classes=13, backbone="mobilenet_v3_large", pretrained=True):
        super(MedicinalPlantClassifier, self).__init__()
        self.backbone_name = backbone
        weights = "imagenet" if pretrained else None

        if backbone == "mobilenet_v3_large":
            self.base_model = tf.keras.applications.MobileNetV3Large(
                input_shape=(224, 224, 3),
                include_top=False,
                weights=weights,
            )
            self.pooling = tf.keras.layers.GlobalAveragePooling2D()
            self.dense1 = tf.keras.layers.Dense(512)
            self.dropout1 = tf.keras.layers.Dropout(0.3)
            self.dense2 = tf.keras.layers.Dense(256)
            self.dropout2 = tf.keras.layers.Dropout(0.2)
            self.dense3 = tf.keras.layers.Dense(num_classes)

        elif backbone == "efficientnet_b0":
            self.base_model = tf.keras.applications.EfficientNetB0(
                input_shape=(224, 224, 3),
                include_top=False,
                weights=weights,
            )
            self.pooling = tf.keras.layers.GlobalAveragePooling2D()
            self.dropout1 = tf.keras.layers.Dropout(0.3)
            self.dense1 = tf.keras.layers.Dense(256)
            self.dropout2 = tf.keras.layers.Dropout(0.2)
            self.dense3 = tf.keras.layers.Dense(num_classes)

        else:
            raise ValueError(
                f"Unsupported backbone: {backbone}. "
                "Choose 'mobilenet_v3_large' or 'efficientnet_b0'."
            )

    def call(self, x, training=False):
        x = self.base_model(x, training=training)
        x = self.pooling(x)

        if self.backbone_name == "mobilenet_v3_large":
            x = self.dense1(x)
            x = hard_swish(x)
            x = self.dropout1(x, training=training)
            x = self.dense2(x)
            x = tf.keras.activations.relu(x)
            x = self.dropout2(x, training=training)
            x = self.dense3(x)

        elif self.backbone_name == "efficientnet_b0":
            x = self.dropout1(x, training=training)
            x = self.dense1(x)
            x = tf.keras.activations.swish(x)
            x = self.dropout2(x, training=training)
            x = self.dense3(x)

        return x


def build_model(num_classes=13, backbone="mobilenet_v3_large", pretrained=True):
    model = MedicinalPlantClassifier(
        num_classes=num_classes, backbone=backbone, pretrained=pretrained
    )
    return model


if __name__ == "__main__":
    test_model = build_model(num_classes=13, backbone="mobilenet_v3_large", pretrained=False)
    dummy_input = tf.random.normal((2, 224, 224, 3))
    out = test_model(dummy_input, training=False)
    print(f"Model sanity test passed. Output shape: {out.shape} (Expected: (2, 13))")
