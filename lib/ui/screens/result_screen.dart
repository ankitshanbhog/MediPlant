import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/plant_model.dart';
import '../../data/models/recognition_result_model.dart';
import '../../viewmodels/remedies_viewmodel.dart';
import '../../viewmodels/voice_viewmodel.dart';
import '../theme/app_colors.dart';
import '../widgets/plant_details_sections.dart';
import '../widgets/plant_speech_helper.dart';
import '../widgets/voice_bot_player.dart';
import 'main_shell_screen.dart';

class ResultScreen extends StatefulWidget {
  final RecognitionResult result;

  const ResultScreen({super.key, required this.result});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final ScrollController _scrollController = ScrollController();
  int _currentSectionIndex = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    try {
      context.read<VoiceViewModel>().stop();
    } catch (_) {}
    super.dispose();
  }

  void _onSectionChanged(int index) {
    setState(() => _currentSectionIndex = index);
    final plant = widget.result.plant;
    if (plant == null) return;
    final voiceVM = context.read<VoiceViewModel>();
    if (voiceVM.isPlaying || voiceVM.isPaused) {
      final newTitle = '${plant.commonName} - ${PlantSpeechHelper.getSectionTitle(index)}';
      final newText = PlantSpeechHelper.getSpeechForSection(plant, index);
      voiceVM.readAloud(title: newTitle, text: newText);
    }
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

    final sectionTitle = '${plant.commonName} - ${PlantSpeechHelper.getSectionTitle(_currentSectionIndex)}';
    final sectionSpeechText = PlantSpeechHelper.getSpeechForSection(plant, _currentSectionIndex);

    final confidencePercent = (widget.result.confidence * 100).toStringAsFixed(1);
    final isVerified = widget.result.source == RecognitionSource.ensemble;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF7FBF8),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          
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
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
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
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -0.4,
                          ),
                        ),
                        Text(
                          plant.scientificName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  _buildConfidenceBanner(
                    confidencePercent: confidencePercent,
                    confidenceValue: widget.result.confidence,
                    isVerified: isVerified,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 18),

                  VoiceBotPlayer(
                    title: sectionTitle,
                    speechText: sectionSpeechText,
                  ),
                  const SizedBox(height: 22),

                  PlantDetailsSections(
                    plant: plant,
                    initialSectionIndex: _currentSectionIndex,
                    onSectionChanged: _onSectionChanged,
                  ),
                  const SizedBox(height: 24),

                  if (widget.result.alternatives.isNotEmpty) ...[
                    _buildAlternativesCard(isDark),
                    const SizedBox(height: 24),
                  ],

                  if (plant.lookAlikeNames.isNotEmpty) ...[
                    _buildLookAlikesCard(isDark, plant),
                    const SizedBox(height: 24),
                  ],

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
    final isMedium = confidenceValue >= 0.65 && confidenceValue < 0.80;
    final isLow = confidenceValue < 0.65;

    final badgeColor = isHigh
        ? const Color(0xFF2E7D32)
        : (isMedium ? const Color(0xFFE65100) : const Color(0xFFC62828));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isLow
              ? const Color(0xFFC62828).withOpacity(0.5)
              : (isDark ? AppColors.borderDark : AppColors.borderLight),
          width: isLow ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: badgeColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isHigh ? Icons.verified_rounded : (isMedium ? Icons.info_outline_rounded : Icons.warning_amber_rounded),
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
                          : (isMedium
                              ? 'Moderate confidence. Cross-check botanical leaf characteristics below.'
                              : 'Low confidence identification. Image may have glare, blur, or obstruction.'),
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
          if (isLow) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFC62828).withOpacity(0.07),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFC62828).withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.photo_camera_rounded, size: 20, color: Color(0xFFC62828)),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Uncertain match. Retake a closer, well-lit photo of the leaf or flower for safer verification.',
                      style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, height: 1.35),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFC62828),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      visualDensity: VisualDensity.compact,
                    ),
                    child: const Text('Retake', style: TextStyle(fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLookAlikesCard(bool isDark, Plant plant) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE65100).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.compare_rounded, color: Color(0xFFE65100), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Common Look-Alike Species',
                      style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800),
                    ),
                    Text(
                      'Morphologically similar species to distinguish before harvesting',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...plant.lookAlikeNames.map((lookAlike) {
            final isToxicWarning = lookAlike.toUpperCase().contains('TOXIC');
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isToxicWarning
                    ? const Color(0xFFC62828).withOpacity(0.08)
                    : (isDark ? AppColors.surfaceSubtleDark : const Color(0xFFFFF8E1)),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isToxicWarning
                      ? const Color(0xFFC62828).withOpacity(0.4)
                      : (isDark ? AppColors.borderDark : const Color(0xFFFFE082)),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isToxicWarning ? Icons.dangerous_rounded : Icons.nature_rounded,
                    size: 18,
                    color: isToxicWarning ? const Color(0xFFC62828) : const Color(0xFFE65100),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      lookAlike,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isToxicWarning ? FontWeight.w800 : FontWeight.w600,
                        color: isToxicWarning
                            ? const Color(0xFFC62828)
                            : (isDark ? AppColors.textPrimaryDark : const Color(0xFF4E342E)),
                      ),
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
