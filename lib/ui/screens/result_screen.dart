import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/recognition_result_model.dart';
import '../../viewmodels/remedies_viewmodel.dart';
import '../theme/app_colors.dart';
import '../widgets/plant_details_sections.dart';
import '../widgets/voice_bot_player.dart';
import 'main_shell_screen.dart';

/// Redesigned Plant Identification Result Screen
///
/// Features a clear, un-cluttered 5-section layout:
///   1. Overview
///   2. Medicinal Uses
///   3. Remedies
///   4. Safety & Precautions
///   5. Scientific Information
/// Identical layout and navigation consistency with Plant Encyclopedia.
class ResultScreen extends StatefulWidget {
  final RecognitionResult result;

  const ResultScreen({super.key, required this.result});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final plant = widget.result.plant;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (plant == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Identification Result', style: TextStyle(fontWeight: FontWeight.bold)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.red.withOpacity(0.15) : const Color(0xFFFFEBEE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.search_off_rounded,
                    size: 48,
                    color: Colors.redAccent,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Species Not Matched',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.result.nonPlantReason ??
                      'The captured plant could not be recognized with sufficient confidence in the botanical database.\nPlease try capturing a closer, well-lit photo of the leaf, flower, or stem.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.refresh_rounded, size: 20),
                  label: const Text('Try Another Photo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Natural punctuated speech summary for natural TTS pacing
    final speechSummary =
        'Identified ${plant.commonName}. '
        'Scientific botanical name: ${plant.scientificName}. '
        'Belonging to the family ${plant.family}. '
        'Description: ${plant.description}. '
        'Primary medicinal uses include: ${plant.medicinalUses.join('. ')}. '
        'Preparation advice: ${plant.preparationMethods}. '
        'Dosage guidelines: ${plant.dosageGuidelines}. '
        'Important safety precautions: ${plant.precautions.join('. ')}.';

    final confidencePercent = (widget.result.confidence * 100).toStringAsFixed(1);
    final isVerified = widget.result.source == RecognitionSource.ensemble;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF7FBF8),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // ── 1. Hero Botanical Image Header ───────────────────────────────
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: isDark ? AppColors.surfaceDark : AppColors.primaryDark,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.55),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
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
                  _buildHeaderImage(widget.result.imagePath, plant.imageUrl, plantId: plant.id),
                  // Gradient vignette for high readability
                  DecoratedBox(
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
                    bottom: 20,
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
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.6,
                                  color: AppColors.primaryDark,
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
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          plant.commonName,
                          style: const TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -0.4,
                          ),
                        ),
                        Text(
                          plant.scientificName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── 2. Content Body ───────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Confidence & AI Verification Banner
                  _buildConfidenceBanner(
                    confidencePercent: confidencePercent,
                    confidenceValue: widget.result.confidence,
                    isVerified: isVerified,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 18),

                  // AI Voice Companion Card
                  VoiceBotPlayer(
                    title: plant.commonName,
                    speechText: speechSummary,
                  ),
                  const SizedBox(height: 22),

                  // ── Clean 5-Section Botanical Information Display ──
                  PlantDetailsSections(plant: plant),
                  const SizedBox(height: 24),

                  // ── Secondary Model Predictions (if any alternatives) ─────
                  if (widget.result.alternatives.isNotEmpty) ...[
                    _buildAlternativesCard(isDark),
                    const SizedBox(height: 24),
                  ],

                  // ── Quick Action Buttons ──────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context.read<RemediesViewModel>().setSearchQuery(plant.commonName);
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => const MainShellScreen(initialIndex: 2)),
                              (route) => false,
                            );
                          },
                          icon: const Icon(Icons.auto_stories_rounded, size: 20),
                          label: const Text('Explore Remedies'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            textStyle: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.camera_alt_rounded, size: 20),
                          label: const Text('Scan Another'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            textStyle: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Helper Widgets ─────────────────────────────────────────────────────────

  Widget _buildHeaderImage(String? localPath, String fallbackUrl, {String? plantId}) {
    if (localPath != null && localPath.isNotEmpty && !localPath.startsWith('http')) {
      final file = File(localPath);
      if (file.existsSync()) {
        return Image.file(file, fit: BoxFit.cover);
      }
    }
    if (plantId != null && plantId.isNotEmpty) {
      final cleanId = plantId.replaceAll('.jpg', '').replaceAll('.png', '');
      return Image.asset(
        'assets/plants/$cleanId.jpg',
        fit: BoxFit.cover,
        errorBuilder: (ctx, err, stack) {
          if (fallbackUrl.isNotEmpty && fallbackUrl.startsWith('http')) {
            return Image.network(fallbackUrl, fit: BoxFit.cover);
          }
          return Container(
            color: AppColors.primaryDark,
            child: const Center(child: Icon(Icons.eco_rounded, color: Colors.white54, size: 72)),
          );
        },
      );
    }
    return Container(
      color: AppColors.primaryDark,
      child: const Center(child: Icon(Icons.eco_rounded, color: Colors.white54, size: 72)),
    );
  }

  Widget _buildConfidenceBanner({
    required String confidencePercent,
    required double confidenceValue,
    required bool isVerified,
    required bool isDark,
  }) {
    final isHigh = confidenceValue >= 0.80;
    final isMedium = confidenceValue >= 0.60 && confidenceValue < 0.80;

    final badgeColor = isHigh
        ? const Color(0xFF2E7D32)
        : (isMedium ? const Color(0xFFE65100) : const Color(0xFFC62828));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isHigh ? Icons.verified_rounded : Icons.info_outline_rounded,
              color: badgeColor,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '$confidencePercent% Confidence',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: badgeColor,
                      ),
                    ),
                    if (isVerified) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1565C0),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'API VERIFIED',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  isHigh
                      ? 'High certainty botanical identification matched against 10-class ML catalog.'
                      : 'Moderate confidence. Cross-check botanical leaf characteristics below.',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlternativesCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1565C0).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.alt_route_rounded, color: Color(0xFF1565C0), size: 20),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Secondary Model Predictions',
                      style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800),
                    ),
                    Text(
                      'Other botanical species evaluated during neural identification',
                      style: TextStyle(fontSize: 11.5, color: AppColors.textMutedLight),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...widget.result.alternatives.map((alt) {
            final pct = (alt.confidence * 100).toStringAsFixed(1);
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceSubtleDark : AppColors.lightMint,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDark ? AppColors.borderDark : const Color(0xFFC8E6C9)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(alt.commonName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
                      Text(alt.scientificName, style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.blueGrey.withOpacity(0.3) : const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$pct%',
                      style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF1565C0)),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
