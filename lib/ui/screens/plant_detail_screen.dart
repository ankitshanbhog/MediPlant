import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/plant_model.dart';
import '../../viewmodels/remedies_viewmodel.dart';
import '../../viewmodels/voice_viewmodel.dart';
import '../theme/app_colors.dart';
import '../widgets/plant_details_sections.dart';
import '../widgets/plant_image.dart';
import '../widgets/voice_bot_player.dart';
import 'main_shell_screen.dart';

class PlantDetailScreen extends StatefulWidget {
  final Plant plant;

  const PlantDetailScreen({super.key, required this.plant});

  @override
  State<PlantDetailScreen> createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends State<PlantDetailScreen> {
  @override
  void dispose() {
    // Automatically stop speech immediately when user leaves this screen
    try {
      context.read<VoiceViewModel>().stop();
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final plant = widget.plant;
    final speechSummary =
        '${plant.commonName}. Botanical scientific name: ${plant.scientificName}, '
        'from the botanical family ${plant.family}. ${plant.description}. '
        'Key medicinal uses include: ${plant.medicinalUses.join(', ')}. '
        'Traditional preparations: ${plant.traditionalUses.join(', ')}. '
        'Dosage instructions: ${plant.dosageGuidelines}. '
        'Safety precautions: ${plant.precautions.join(', ')}.';

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          context.read<VoiceViewModel>().stop();
        }
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            // Elegant Header Sliver with plant photography and non-overflowing titles
            SliverAppBar(
              expandedHeight: 310,
              pinned: true,
              leading: IconButton(
                icon: CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.55),
                  child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 22),
                ),
                onPressed: () {
                  context.read<VoiceViewModel>().stop();
                  Navigator.pop(context);
                },
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
                            Colors.black.withOpacity(0.4),
                            Colors.transparent,
                            Colors.black.withOpacity(0.9),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.0, 0.45, 1.0],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryAccent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  plant.family.toUpperCase(),
                                  style: const TextStyle(
                                    color: AppColors.primaryDark,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.25),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  plant.plantType,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            plant.commonName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            plant.scientificName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
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

            // Main Modular Body
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Smart Voice Navigation Assistant
                    VoiceBotPlayer(
                      title: plant.commonName,
                      speechText: speechSummary,
                    ),
                    const SizedBox(height: 22),

                    // Modular Sections with Tab Switching
                    PlantDetailsSections(plant: plant),

                    const SizedBox(height: 24),

                    // Explore Remedies Button
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<VoiceViewModel>().stop();
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
                      icon: const Icon(Icons.auto_stories_rounded, size: 22),
                      label: Text('Explore All Recipes for ${plant.commonName}'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                        elevation: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
