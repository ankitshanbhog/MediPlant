import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/plant_model.dart';
import '../../viewmodels/remedies_viewmodel.dart';
import '../theme/app_colors.dart';
import '../widgets/plant_details_sections.dart';
import '../widgets/plant_image.dart';
import '../widgets/voice_bot_player.dart';
import 'main_shell_screen.dart';

/// Reusable Detailed Plant Information Screen (Botanical Encyclopedia)
/// Clean, organized 5-section presentation of botanical knowledge.
class PlantDetailScreen extends StatelessWidget {
  final Plant plant;

  const PlantDetailScreen({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
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
                backgroundColor: Colors.black.withOpacity(0.55),
                child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.55),
                  child: IconButton(
                    icon: const Icon(Icons.share_rounded, color: Colors.white, size: 20),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Botanical profile for ${plant.commonName} copied to clipboard.'),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
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
                          Colors.black.withOpacity(0.35),
                          Colors.transparent,
                          Colors.black.withOpacity(0.85),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.0, 0.45, 1.0],
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
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primaryAccent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                plant.family.toUpperCase(),
                                style: const TextStyle(
                                  color: AppColors.primaryDark,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.22),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                plant.plantType,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          plant.commonName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.4,
                          ),
                        ),
                        Text(
                          plant.scientificName,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
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
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Voice Assistant Player
                  VoiceBotPlayer(
                    title: plant.commonName,
                    speechText: speechSummary,
                  ),
                  const SizedBox(height: 20),

                  // ── Clean 5-Section Botanical Information Display ──
                  PlantDetailsSections(plant: plant),

                  const SizedBox(height: 24),

                  // Button to search related remedies across app
                  ElevatedButton.icon(
                    onPressed: () {
                      final remediesVM = context.read<RemediesViewModel>();
                      remediesVM.setSearchQuery(plant.commonName);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainShellScreen(initialIndex: 2),
                        ),
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.auto_stories_rounded, size: 20),
                    label: Text('Explore All Remedies for ${plant.commonName}'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
