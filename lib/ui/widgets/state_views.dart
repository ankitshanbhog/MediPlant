import 'package:flutter/material.dart';
import '../../services/recognition_service.dart';
import '../theme/app_colors.dart';

/// Displayed when Model 1 determines the uploaded image is not a plant
class NotAPlantView extends StatelessWidget {
  final String? reason;
  final VoidCallback onRetry;

  const NotAPlantView({
    super.key,
    this.reason,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.confidenceLow.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.no_photography_outlined,
                size: 48,
                color: AppColors.confidenceLow,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No Plant Detected',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              reason ??
                  'The image does not appear to contain a plant. Please upload a clear, well-lit photo of a plant leaf, stem, or flower.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.camera_alt_outlined),
              label: const Text('Try Another Image'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Crucial Doctor Consultation Banner displayed when no suitable plant/remedy is found
class DoctorConsultationBanner extends StatelessWidget {
  final String query;
  final VoidCallback? onSearchOther;

  const DoctorConsultationBanner({
    super.key,
    required this.query,
    this.onSearchOther,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C1E1B) : const Color(0xFFFFF3EE),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.warning.withOpacity(0.4),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.medical_services_outlined,
                  color: AppColors.warning,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'No Verified Remedy Found',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.warning,
                      ),
                    ),
                    Text(
                      'Medical Consultation Strongly Advised',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Unable to find a verified medicinal plant or traditional home remedy for "$query".',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          const SizedBox(height: 6),
          Text(
            'Herbal and traditional remedies are strictly complementary and cannot replace certified medical diagnosis or clinical therapy. If you are experiencing persistent, severe, or worsening symptoms, please consult a licensed medical doctor or healthcare professional immediately.',
            style: TextStyle(
              fontSize: 13,
              height: 1.45,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? Colors.black26 : Colors.white70,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.emergency_outlined, color: AppColors.confidenceLow, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'For acute chest pain, high fever (>103°F), difficulty breathing, or severe trauma, seek immediate emergency medical care.',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
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

/// Loading / Recognition Stage View with stage-by-stage visual feedback
class PipelineLoadingView extends StatelessWidget {
  final PipelineStage stage;

  const PipelineLoadingView({super.key, required this.stage});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryAccent),
                    backgroundColor: isDark ? AppColors.surfaceSubtleDark : AppColors.lightMint,
                  ),
                ),
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.filter_vintage_rounded,
                    size: 36,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Text(
              _stageTitle(stage),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              _stageDescription(stage),
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _StageStepsIndicator(currentStage: stage),
          ],
        ),
      ),
    );
  }

  String _stageTitle(PipelineStage stage) {
    return 'Identifying your plant...';
  }

  String _stageDescription(PipelineStage stage) {
    switch (stage) {
      case PipelineStage.checkingPlantModel1:
        return 'Analysing the image for plant characteristics...';
      case PipelineStage.identifyingSpeciesModel2:
        return 'Matching against medicinal plant species...';
      case PipelineStage.externalApiVerification:
        return 'Performing additional verification for best accuracy...';
      default:
        return 'Processing your image...';
    }
  }
}

class _StageStepsIndicator extends StatelessWidget {
  final PipelineStage currentStage;
  const _StageStepsIndicator({required this.currentStage});

  @override
  Widget build(BuildContext context) {
    // Simple animated dots — no internal stage names exposed to user
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final isActive = currentStage.index == i ||
            (i == 2 && currentStage == PipelineStage.externalApiVerification);
        final isDone = currentStage.index > i;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isDone
                ? AppColors.primary
                : (isActive ? AppColors.primaryAccent : AppColors.borderLight),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

/// Generic Empty State
class EmptyStateView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionText;
  final VoidCallback? onAction;

  const EmptyStateView({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceSubtleDark : AppColors.surfaceSubtleLight,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: onAction,
                child: Text(actionText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
