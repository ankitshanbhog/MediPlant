import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/mock/mock_sample_images.dart';
import '../../viewmodels/recognition_viewmodel.dart';
import '../theme/app_colors.dart';
import '../widgets/plant_image.dart';
import '../widgets/state_views.dart';
import 'result_screen.dart';

/// Plant Identification Screen with camera, gallery, preview, and multi-stage analysis
class IdentifyScreen extends StatelessWidget {
  const IdentifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final recognitionVM = context.watch<RecognitionViewModel>();

    // Loading / Analyzing State
    if (recognitionVM.isAnalyzing) {
      return Scaffold(
        body: PipelineLoadingView(stage: recognitionVM.currentStage),
      );
    }

    // Result is available and failed Model 1 (Not A Plant)
    if (recognitionVM.result != null && recognitionVM.result!.isNotPlant) {
      return Scaffold(
        body: NotAPlantView(
          reason: recognitionVM.result!.nonPlantReason,
          onRetry: () => recognitionVM.clearSelectedImage(),
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Screen Header
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Plant Recognition',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Capture or upload a clear leaf or plant photo',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textMutedLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Error Banner if network/recognition fails
            if (recognitionVM.errorMessage != null) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.confidenceLow.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.confidenceLow.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline_rounded, color: AppColors.confidenceLow, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        recognitionVM.errorMessage!,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.confidenceLow,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Main Preview Area or Empty Image Picker Placeholder
            if (recognitionVM.hasImage) ...[
              _ImagePreviewContainer(
                imageUrlOrPath: recognitionVM.effectiveImageDisplayUrl,
                sampleName: recognitionVM.selectedSample?.label,
                onRetake: () => recognitionVM.capturePhoto(),
                onChange: () => recognitionVM.pickFromGallery(),
                onClear: () => recognitionVM.clearSelectedImage(),
              ),
              const SizedBox(height: 20),

              // Identify Plant Primary Action Button
              ElevatedButton.icon(
                onPressed: () async {
                  final result = await recognitionVM.startIdentification();
                  if (result != null && !result.isNotPlant && context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultScreen(result: result),
                      ),
                    );
                  } else if (result == null && recognitionVM.errorMessage != null && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(recognitionVM.errorMessage!),
                        backgroundColor: AppColors.confidenceLow,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.search_rounded, size: 22),
                label: const Text('Identify Plant Species'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
              ),
            ] else ...[
              // Image Picker Placeholder
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceSubtleDark : AppColors.lightMint,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_a_photo_outlined,
                        size: 38,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Select a Plant Image',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Ensure good lighting, sharp focus, and clear leaf venation for optimal accuracy.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => recognitionVM.capturePhoto(),
                            icon: const Icon(Icons.camera_alt_rounded),
                            label: const Text('Take Photo'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => recognitionVM.pickFromGallery(),
                            icon: const Icon(Icons.photo_library_rounded),
                            label: const Text('Gallery'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 26),

            // "Try Sample Images" Tray
            const Text(
              'Or Try Sample Photos',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),

            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: mockTestSamples.where((s) => s.isPlant).length,
                itemBuilder: (context, index) {
                  final plantSamples = mockTestSamples.where((s) => s.isPlant).toList();
                  final sample = plantSamples[index];
                  final isSelected = recognitionVM.selectedSample?.id == sample.id;

                  return GestureDetector(
                    onTap: () => recognitionVM.selectTestSample(sample),
                    child: Container(
                      width: 110,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryAccent
                              : (isDark ? AppColors.borderDark : AppColors.borderLight),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PlantImage(
                            plantId: sample.expectedPlantId,
                            fallbackUrl: sample.imageUrl,
                            height: 75,
                            width: double.infinity,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sample.label,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  sample.isPlant ? 'Botanical' : 'Non-Plant',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: sample.isPlant ? AppColors.primary : AppColors.confidenceLow,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Botanical Photography Guidelines Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceSubtleDark : AppColors.surfaceSubtleLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.tips_and_updates_outlined, size: 16, color: AppColors.primary),
                      SizedBox(width: 6),
                      Text(
                        'Photography Tips for Best Results',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildTip(Icons.check_circle_outline, 'Capture the upper surface of a single mature leaf.'),
                  _buildTip(Icons.check_circle_outline, 'Include distinctive flowers or seed pods if present.'),
                  _buildTip(Icons.cancel_outlined, 'Avoid heavy shadows, severe backlighting, or extreme blur.', isNegative: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTip(IconData icon, String text, {bool isNegative = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 14,
            color: isNegative ? AppColors.confidenceLow : AppColors.primary,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImagePreviewContainer extends StatelessWidget {
  final String imageUrlOrPath;
  final String? sampleName;
  final VoidCallback onRetake;
  final VoidCallback onChange;
  final VoidCallback onClear;

  const _ImagePreviewContainer({
    required this.imageUrlOrPath,
    this.sampleName,
    required this.onRetake,
    required this.onChange,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isLocalFile = !imageUrlOrPath.startsWith('http') && !kIsWeb;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                child: isLocalFile
                    ? Image.file(
                        File(imageUrlOrPath),
                        height: 260,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        imageUrlOrPath,
                        height: 260,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          height: 260,
                          color: AppColors.lightMint,
                          child: const Center(
                            child: Icon(Icons.eco, size: 48, color: AppColors.primary),
                          ),
                        ),
                      ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.6),
                  radius: 18,
                  child: IconButton(
                    icon: const Icon(Icons.close, size: 16, color: Colors.white),
                    onPressed: onClear,
                  ),
                ),
              ),
              if (sampleName != null)
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Preset: $sampleName',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onRetake,
                    icon: const Icon(Icons.camera_alt_outlined, size: 16),
                    label: const Text('Retake'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onChange,
                    icon: const Icon(Icons.photo_library_outlined, size: 16),
                    label: const Text('Change Image'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
