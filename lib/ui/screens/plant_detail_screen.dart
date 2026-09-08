import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/plant_model.dart';
import '../../viewmodels/remedies_viewmodel.dart';
import '../theme/app_colors.dart';
import '../widgets/plant_image.dart';
import '../widgets/voice_bot_player.dart';
import 'main_shell_screen.dart';

/// Reusable Detailed Plant Information Screen (Botanical Encyclopedia)
class PlantDetailScreen extends StatelessWidget {
  final Plant plant;

  const PlantDetailScreen({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final speechSummary =
        '${plant.commonName}, botanical scientific name ${plant.scientificName}, '
        'from the botanical family ${plant.family}. ${plant.description} '
        'Key medicinal uses: ${plant.medicinalUses.join(', ')}. '
        'Traditional preparations: ${plant.traditionalUses.join(', ')}. '
        'Dosage instructions: ${plant.dosageGuidelines}. '
        'Safety precautions: ${plant.precautions.join(', ')}.';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header Botanical Image Sliver
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            leading: IconButton(
              icon: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.5),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  PlantImage(
                    plantId: plant.id,
                    fallbackUrl: plant.imageUrl,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.8),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryAccent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            plant.family,
                            style: const TextStyle(
                              color: AppColors.primaryDark,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          plant.commonName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          plant.scientificName,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Detail Content Sections
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Voice Assistant Player
                  VoiceBotPlayer(
                    title: plant.commonName,
                    speechText: speechSummary,
                  ),
                  const SizedBox(height: 22),

                  // Vernacular Regional Names
                  if (plant.vernacularNames.isNotEmpty) ...[
                    const Text(
                      'Vernacular / Regional Names',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: plant.vernacularNames.entries.map((entry) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.surfaceSubtleDark : AppColors.surfaceSubtleLight,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isDark ? AppColors.borderDark : AppColors.borderLight,
                            ),
                          ),
                          child: Text(
                            '${entry.key}: ${entry.value}',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Description Overview
                  const Text(
                    'Botanical Overview & Ecology',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    plant.description,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.55,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                  if (plant.habitat.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.terrain_rounded, size: 16, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Native Habitat: ${plant.habitat}',
                            style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 20),

                  // Parts Used
                  if (plant.partsUsed.isNotEmpty) ...[
                    const Text(
                      'Medicinal Parts Used',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      children: plant.partsUsed.map((part) {
                        return Chip(
                          label: Text(part, style: const TextStyle(fontSize: 12)),
                          backgroundColor: isDark ? AppColors.surfaceSubtleDark : AppColors.lightMint,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Medicinal Uses
                  const Text(
                    'Documented Medicinal Uses',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 10),
                  ...plant.medicinalUses.map((use) => _buildCheckItem(use, isDark)),
                  const SizedBox(height: 20),

                  // Health Benefits
                  const Text(
                    'Key Physiological Benefits',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 10),
                  ...plant.healthBenefits.map((benefit) => _buildBulletItem(benefit, isDark)),
                  const SizedBox(height: 20),

                  // Traditional Ayurvedic / Herbal Uses
                  if (plant.traditionalUses.isNotEmpty) ...[
                    const Text(
                      'Traditional Preparations',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 10),
                    ...plant.traditionalUses.map((trad) => _buildBulletItem(trad, isDark)),
                    const SizedBox(height: 20),
                  ],

                  // Preparation Methods & Dosage
                  if (plant.preparationMethods.isNotEmpty || plant.dosageGuidelines.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceSubtleDark : AppColors.lightMint.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.menu_book_outlined, color: AppColors.primary, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'Preparation & Dosage Guidelines',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary),
                              ),
                            ],
                          ),
                          if (plant.preparationMethods.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              plant.preparationMethods,
                              style: const TextStyle(fontSize: 13, height: 1.45),
                            ),
                          ],
                          if (plant.dosageGuidelines.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Standard Dosage: ${plant.dosageGuidelines}',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Safety, Precautions & Contraindications
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
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
                              'Precautions & Contraindications',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppColors.warning,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (plant.precautions.isNotEmpty) ...[
                          const Text(
                            'Precautions:',
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                          ),
                          const SizedBox(height: 4),
                          ...plant.precautions.map((p) => Text('• $p', style: const TextStyle(fontSize: 12, height: 1.35))),
                          const SizedBox(height: 8),
                        ],
                        if (plant.contraindications.isNotEmpty) ...[
                          const Text(
                            'Contraindications:',
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                          ),
                          const SizedBox(height: 4),
                          ...plant.contraindications.map((c) => Text('• $c', style: const TextStyle(fontSize: 12, height: 1.35))),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Button to search related remedies
                  ElevatedButton.icon(
                    onPressed: () {
                      final remediesVM = context.read<RemediesViewModel>();
                      remediesVM.setSearchQuery(plant.commonName);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainShellScreen(initialIndex: 3),
                        ),
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.healing_rounded),
                    label: Text('Find Remedies Using ${plant.commonName}'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, size: 12, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13.5,
                height: 1.35,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletItem(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: AppColors.primaryAccent, fontSize: 16, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                height: 1.35,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
