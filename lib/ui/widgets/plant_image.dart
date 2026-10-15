import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Clean, robust widget to display verified botanical plant images from assets/plants/
/// with graceful fallback to network URLs and botanical placeholders.
class PlantImage extends StatelessWidget {
  final String plantId;
  final String? fallbackUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const PlantImage({
    super.key,
    required this.plantId,
    this.fallbackUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  static String resolveAssetPath(String plantId) {
    final cleanId = plantId
        .trim()
        .toLowerCase()
        .replaceAll('.jpg', '')
        .replaceAll('.jpeg', '')
        .replaceAll('.png', '')
        .replaceAll('.webp', '');

    if (cleanId == 'malabar_nut' || cleanId == 'malabar_nut_plant') {
      return 'assets/plants/malabar_nut_plant.jpg';
    }
    if (cleanId == 'pirandai' || cleanId == 'pirandai_plant') {
      return 'assets/plants/pirandai_plant.webp';
    }
    if (cleanId.endsWith('_plant')) {
      return 'assets/plants/$cleanId.jpg';
    }
    return 'assets/plants/${cleanId}_plant.jpg';
  }

  String get _assetPath => resolveAssetPath(plantId);

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = Image.asset(
      _assetPath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        // Try alternate asset file if initial fails (e.g. pirandai_plant.jpg or malabar_nut.jpg)
        final fallbackAsset = _assetPath.endsWith('.webp')
            ? _assetPath.replaceAll('.webp', '.jpg')
            : (_assetPath.contains('_plant')
                ? _assetPath.replaceAll('_plant.jpg', '.jpg')
                : _assetPath.replaceAll('.jpg', '_plant.jpg'));

        return Image.asset(
          fallbackAsset,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, err2, stack2) {
            if (fallbackUrl != null && fallbackUrl!.isNotEmpty && fallbackUrl!.startsWith('http')) {
              return Image.network(
                fallbackUrl!,
                width: width,
                height: height,
                fit: fit,
                errorBuilder: (context, err, stack) => _buildPlaceholder(),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return _buildPlaceholder(isLoading: true);
                },
              );
            }
            return _buildPlaceholder();
          },
        );
      },
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildPlaceholder({bool isLoading = false}) {
    return Container(
      width: width,
      height: height,
      color: AppColors.lightMint,
      child: Center(
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              )
            : const Icon(
                Icons.spa_rounded,
                color: AppColors.primary,
                size: 28,
              ),
      ),
    );
  }
}
