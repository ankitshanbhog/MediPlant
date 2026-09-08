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

  String get _assetPath {
    final cleanId = plantId
        .trim()
        .replaceAll('.jpg', '')
        .replaceAll('.jpeg', '')
        .replaceAll('.png', '');
    return 'assets/plants/$cleanId.jpg';
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = Image.asset(
      _assetPath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
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
