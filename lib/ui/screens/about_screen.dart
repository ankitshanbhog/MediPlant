import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// About & Profile Screen with ML Architecture pipeline details and medical disclaimers
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Profile / App Identity
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: AppColors.heroGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryDark.withOpacity(0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.spa_rounded, size: 42, color: AppColors.mint),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'MediPlant',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Medicinal Plant Recognition & Information System',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Version 1.0.0 • Mobile-First Frontend',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Project Objective Card
            _buildSectionCard(
              isDark: isDark,
              icon: Icons.flag_outlined,
              title: 'Project Objective',
              content:
                  'The MediPlant system makes traditional and scientific medicinal plant identification accessible, reliable, and actionable. It bridges ancient herbal wisdom with state-of-the-art computer vision to provide verified botanical profiles, symptom-based searches, and safe home remedies.',
            ),
            const SizedBox(height: 14),

            // Machine Learning Architecture Pipeline Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.hub_outlined, color: AppColors.primary, size: 20),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          '3-Stage ML Recognition Architecture',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'The frontend is architected to seamlessly interface with a 3-tier recognition workflow without cloud dependency:',
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.4,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Stage 1
                  _buildMlStageItem(
                    number: '1',
                    title: 'Model 1: Plant / Not-Plant Classifier',
                    subtitle: 'Binary detector determining if image is botanical flora or a non-plant object.',
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 10),

                  // Stage 2
                  _buildMlStageItem(
                    number: '2',
                    title: 'Model 2: Medicinal Species Model',
                    subtitle: 'Multi-class classifier predicting species and confidence score among supported classes.',
                    color: AppColors.primaryAccent,
                  ),
                  const SizedBox(height: 10),

                  // Stage 3
                  _buildMlStageItem(
                    number: '3',
                    title: 'External Verification / Backup API',
                    subtitle: 'Escalation service for low confidence (<65%) or rare plants outside Model 2 dataset.',
                    color: AppColors.info,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Features Checklist
            _buildSectionCard(
              isDark: isDark,
              icon: Icons.stars_rounded,
              title: 'Core System Capabilities',
              child: Column(
                children: [
                  _buildFeatureRow(Icons.camera_alt_outlined, 'Camera Capture & Photo Gallery Picker'),
                  _buildFeatureRow(Icons.verified_user_outlined, 'Plant vs. Non-Plant Rejection Filter'),
                  _buildFeatureRow(Icons.auto_awesome, 'Multi-Stage Species Classification'),
                  _buildFeatureRow(Icons.volume_up_outlined, 'AI Voice Assistant & Text-to-Speech'),
                  _buildFeatureRow(Icons.medical_services_outlined, 'Disease & Health Condition Search'),
                  _buildFeatureRow(Icons.healing_outlined, 'Traditional Home Remedies with Step-by-Step Recipes'),
                  _buildFeatureRow(Icons.history_rounded, 'Local Scan History with Confidence Meters'),
                  _buildFeatureRow(Icons.local_hospital_outlined, 'Doctor Consultation Recommendation Safeguard'),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Critical Medical Disclaimer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.08),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.warning.withOpacity(0.35)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Important Medical Disclaimer',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'The MediPlant application is designed strictly for educational, informational, and traditional botanical reference. It is NOT a certified medical diagnostic device and does not replace the professional advice, diagnosis, or clinical treatment of a licensed doctor or healthcare provider.\n\nNever disregard professional medical advice or delay seeking it because of information accessed through this application.',
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required bool isDark,
    required IconData icon,
    required String title,
    String? content,
    Widget? child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          if (content != null) ...[
            const SizedBox(height: 10),
            Text(
              content,
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
          ],
          if (child != null) ...[
            const SizedBox(height: 12),
            child,
          ],
        ],
      ),
    );
  }

  Widget _buildMlStageItem({
    required String number,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(color: color),
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 11.5, height: 1.35, color: AppColors.textMutedLight),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
