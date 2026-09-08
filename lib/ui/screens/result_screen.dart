import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/recognition_result_model.dart';
import '../../viewmodels/remedies_viewmodel.dart';
import '../theme/app_colors.dart';
import '../widgets/voice_bot_player.dart';
import 'main_shell_screen.dart';

/// Redesigned Spacious, User-Friendly Result Screen
///
/// Eliminates cramped 4-tab layout in favor of a clean, high-legibility,
/// continuous-flow experience with large readable typography and quick-jump navigation.
class ResultScreen extends StatefulWidget {
  final RecognitionResult result;

  const ResultScreen({super.key, required this.result});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final ScrollController _scrollController = ScrollController();

  // GlobalKeys for smooth scrolling to specific sections
  final GlobalKey _overviewKey = GlobalKey();
  final GlobalKey _medicinalKey = GlobalKey();
  final GlobalKey _preparationKey = GlobalKey();
  final GlobalKey _safetyKey = GlobalKey();
  final GlobalKey _chemistryKey = GlobalKey();
  final GlobalKey _alternativesKey = GlobalKey();

  int _selectedSectionIndex = 0;

  void _scrollToSection(GlobalKey key, int index) {
    setState(() => _selectedSectionIndex = index);
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
        alignment: 0.08,
      );
    }
  }

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
                    fontSize: 16,
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
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
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
                        SnackBar(content: Text('Botanical profile for ${plant.commonName} copied to clipboard.')),
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
                          Colors.black.withOpacity(0.4),
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
                                  letterSpacing: 0.8,
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
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          plant.scientificName,
                          style: const TextStyle(
                            fontSize: 17,
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

                  // Sticky-like Section Navigation Chips (Replaces 4 cramped tabs)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildNavChip('🌿 Overview', 0, () => _scrollToSection(_overviewKey, 0)),
                        _buildNavChip('🩺 Healing Uses', 1, () => _scrollToSection(_medicinalKey, 1)),
                        _buildNavChip('🍵 Preparation', 2, () => _scrollToSection(_preparationKey, 2)),
                        _buildNavChip('⚠️ Safety & Warnings', 3, () => _scrollToSection(_safetyKey, 3)),
                        _buildNavChip('🔬 Chemistry', 4, () => _scrollToSection(_chemistryKey, 4)),
                        if (widget.result.alternatives.isNotEmpty)
                          _buildNavChip('🔍 Alternatives', 5, () => _scrollToSection(_alternativesKey, 5)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  // ── SECTION 1: Overview & Botanical Details ─────────────
                  Container(
                    key: _overviewKey,
                    child: _buildSectionCard(
                      isDark: isDark,
                      icon: Icons.eco_rounded,
                      iconColor: AppColors.primary,
                      title: 'Botanical Overview',
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            plant.description,
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.6,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          ),
                          const SizedBox(height: 18),
                          if (plant.appearance.isNotEmpty) ...[
                            _buildInfoRow(
                              icon: Icons.visibility_outlined,
                              label: 'Botanical Appearance',
                              value: plant.appearance,
                              isDark: isDark,
                            ),
                            const SizedBox(height: 12),
                          ],
                          if (plant.habitat.isNotEmpty) ...[
                            _buildInfoRow(
                              icon: Icons.landscape_outlined,
                              label: 'Natural Habitat',
                              value: plant.habitat,
                              isDark: isDark,
                            ),
                            const SizedBox(height: 16),
                          ],
                          const Divider(height: 24),
                          const Text(
                            'Regional & Vernacular Names',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: plant.vernacularNames.entries.map((entry) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.surfaceSubtleDark : AppColors.lightMint,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isDark ? AppColors.borderDark : AppColors.primarySubtle,
                                  ),
                                ),
                                child: Text.rich(
                                  TextSpan(
                                    text: '${entry.key}: ',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? AppColors.mint : AppColors.primaryDark,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: entry.value,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: isDark ? Colors.white : Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── SECTION 2: Medicinal Uses & Health Benefits ──────────
                  Container(
                    key: _medicinalKey,
                    child: _buildSectionCard(
                      isDark: isDark,
                      icon: Icons.healing_rounded,
                      iconColor: const Color(0xFF00897B),
                      title: 'Medicinal Uses & Proven Benefits',
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Therapeutic Applications',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 12),
                          ...plant.medicinalUses.map((use) => _buildCheckItem(use, isDark, AppColors.primary)),
                          if (plant.healthBenefits.isNotEmpty) ...[
                            const Divider(height: 28),
                            const Text(
                              'Key Health Benefits',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 12),
                            ...plant.healthBenefits.map((benefit) => _buildCheckItem(benefit, isDark, const Color(0xFF2E7D32))),
                          ],
                          if (plant.traditionalUses.isNotEmpty) ...[
                            const Divider(height: 28),
                            const Text(
                              'Traditional & Ayurvedic Heritage',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 12),
                            ...plant.traditionalUses.map((trad) => _buildCheckItem(trad, isDark, const Color(0xFFE65100))),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── SECTION 3: Preparation & Dosage Guidelines ──────────
                  Container(
                    key: _preparationKey,
                    child: _buildSectionCard(
                      isDark: isDark,
                      icon: Icons.local_cafe_rounded,
                      iconColor: const Color(0xFF6D4C41),
                      title: 'Preparation & Dosage Guidelines',
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.surfaceSubtleDark : const Color(0xFFF1F8E9),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isDark ? AppColors.borderDark : const Color(0xFFDCEDC8),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.soup_kitchen_rounded, color: Color(0xFF558B2F), size: 24),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'How to Prepare',
                                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        plant.preparationMethods,
                                        style: TextStyle(
                                          fontSize: 15,
                                          height: 1.5,
                                          color: isDark ? AppColors.textPrimaryDark : Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.surfaceSubtleDark : const Color(0xFFE0F7FA),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isDark ? AppColors.borderDark : const Color(0xFFB2EBF2),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.medication_liquid_rounded, color: Color(0xFF00838F), size: 24),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Recommended Dosage',
                                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        plant.dosageGuidelines,
                                        style: TextStyle(
                                          fontSize: 15,
                                          height: 1.5,
                                          color: isDark ? AppColors.textPrimaryDark : Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── SECTION 4: Safety, Contraindications & Side Effects ─
                  Container(
                    key: _safetyKey,
                    child: _buildSectionCard(
                      isDark: isDark,
                      icon: Icons.shield_rounded,
                      iconColor: const Color(0xFFC62828),
                      title: 'Safety Precautions & Warnings',
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (plant.precautions.isNotEmpty) ...[
                            const Text(
                              'General Precautions',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 10),
                            ...plant.precautions.map((p) => _buildWarningItem(p, isDark, const Color(0xFFEF6C00), Icons.info_outline_rounded)),
                          ],
                          if (plant.contraindications.isNotEmpty) ...[
                            const Divider(height: 28),
                            const Text(
                              'Do Not Use If (Contraindications)',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFFC62828)),
                            ),
                            const SizedBox(height: 10),
                            ...plant.contraindications.map((c) => _buildWarningItem(c, isDark, const Color(0xFFC62828), Icons.block_rounded)),
                          ],
                          if (plant.sideEffects.isNotEmpty) ...[
                            const Divider(height: 28),
                            const Text(
                              'Possible Side Effects',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 10),
                            ...plant.sideEffects.map((s) => _buildWarningItem(s, isDark, const Color(0xFFAD1457), Icons.warning_amber_rounded)),
                          ],
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.amber.withOpacity(0.08) : const Color(0xFFFFF8E1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFFFD54F)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.health_and_safety_outlined, color: Color(0xFFF57F17), size: 22),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Educational guidance only. Always consult an Ayurvedic or licensed health practitioner before starting herbal remedies.',
                                    style: TextStyle(
                                      fontSize: 13,
                                      height: 1.4,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? const Color(0xFFFFD54F) : const Color(0xFF5D4037),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── SECTION 5: Chemistry & Botanical Parts Used ──────────
                  Container(
                    key: _chemistryKey,
                    child: _buildSectionCard(
                      isDark: isDark,
                      icon: Icons.science_rounded,
                      iconColor: const Color(0xFF7B1FA2),
                      title: 'Active Constituents & Parts Used',
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Active Phytochemicals',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: plant.activeConstituents.map((c) {
                              return Chip(
                                avatar: const Icon(Icons.bubble_chart_rounded, size: 16, color: Color(0xFF7B1FA2)),
                                label: Text(c, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                backgroundColor: isDark ? AppColors.surfaceSubtleDark : const Color(0xFFF3E5F5),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            'Parts Used for Medicine',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: plant.partsUsed.map((p) {
                              return Chip(
                                avatar: const Icon(Icons.grass_rounded, size: 16, color: AppColors.primary),
                                label: Text(p, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                backgroundColor: isDark ? AppColors.surfaceSubtleDark : AppColors.lightMint,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── SECTION 6: Alternative Candidates (if any) ────────────
                  if (widget.result.alternatives.isNotEmpty) ...[
                    Container(
                      key: _alternativesKey,
                      child: _buildSectionCard(
                        isDark: isDark,
                        icon: Icons.alt_route_rounded,
                        iconColor: const Color(0xFF1565C0),
                        title: 'Secondary Model Predictions',
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Other botanical species evaluated during neural identification:',
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...widget.result.alternatives.map((alt) {
                              final pct = (alt.confidence * 100).toStringAsFixed(1);
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.surfaceSubtleDark : AppColors.surfaceLight,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(alt.commonName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
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
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // ── Quick Action Buttons ──────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Pre-filter remedies by this plant name
                            context.read<RemediesViewModel>().setSearchQuery(plant.commonName);
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => const MainShellScreen(initialIndex: 2)),
                              (route) => false,
                            );
                          },
                          icon: const Icon(Icons.auto_stories_rounded, size: 20),
                          label: const Text('Find Remedies'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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

  Widget _buildNavChip(String label, int index, VoidCallback onTap) {
    final isSelected = _selectedSectionIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        selectedColor: AppColors.primary,
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        labelStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected
                ? AppColors.primary
                : (isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
        ),
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
                      ? 'High certainty botanical identification matched against 11-species ML catalog.'
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

  Widget _buildSectionCard({
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String title,
    required Widget content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.borderDark : const Color(0xFFE4EDE7),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
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
                  color: iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: isDark ? AppColors.mint : AppColors.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Text.rich(
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckItem(String text, bool isDark, Color checkColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_rounded, color: checkColor, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                height: 1.45,
                color: isDark ? AppColors.textPrimaryDark : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningItem(String text, bool isDark, Color color, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                height: 1.45,
                color: isDark ? AppColors.textPrimaryDark : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
