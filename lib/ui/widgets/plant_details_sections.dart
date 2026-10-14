import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/mock/mock_remedies_data.dart';
import '../../data/models/plant_model.dart';
import '../../data/models/remedy_model.dart';
import '../../viewmodels/remedies_viewmodel.dart';
import '../theme/app_colors.dart';
import 'remedy_card.dart';

/// Reusable, clean, and organized plant information display component.
///
/// Divides plant knowledge into 5 distinct, uncluttered sections:
///   1. Overview (Botanical Description, Habitat, Appearance, Vernacular Names)
///   2. Medicinal Uses (Therapeutic Applications, Health Benefits, Traditional Uses)
///   3. Remedies (Herbal Preparation, Dosage, and Matching Home Remedy Recipes)
///   4. Safety & Precautions (Contraindications, Precautions, Side Effects, Disclaimer)
///   5. Scientific Information (Taxonomy, Phytochemicals, Medicinal Parts Used)
class PlantDetailsSections extends StatefulWidget {
  final Plant plant;
  final int initialSectionIndex;
  final ValueChanged<int>? onSectionChanged;

  const PlantDetailsSections({
    super.key,
    required this.plant,
    this.initialSectionIndex = 0,
    this.onSectionChanged,
  });

  @override
  State<PlantDetailsSections> createState() => _PlantDetailsSectionsState();
}

class _PlantDetailsSectionsState extends State<PlantDetailsSections> {
  late int _currentIndex;

  static const List<_SectionMeta> _sections = [
    _SectionMeta(
      title: 'Overview',
      icon: Icons.eco_rounded,
      color: AppColors.primary,
    ),
    _SectionMeta(
      title: 'Medicinal Uses',
      icon: Icons.healing_rounded,
      color: Color(0xFF00897B),
    ),
    _SectionMeta(
      title: 'Remedies',
      icon: Icons.soup_kitchen_rounded,
      color: Color(0xFFD84315),
    ),
    _SectionMeta(
      title: 'Safety & Warnings',
      icon: Icons.shield_rounded,
      color: Color(0xFFC62828),
    ),
    _SectionMeta(
      title: 'Scientific Info',
      icon: Icons.science_rounded,
      color: Color(0xFF5E35B1),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialSectionIndex;
  }

  void _switchSection(int index) {
    if (index >= 0 && index < _sections.length) {
      setState(() => _currentIndex = index);
      widget.onSectionChanged?.call(index);
    }
  }

  List<Remedy> _getMatchingRemedies() {
    final plant = widget.plant;
    final plantCleanId = plant.id.toLowerCase().replaceAll('_plant', '');
    final plantName = plant.commonName.toLowerCase();
    final plantSci = plant.scientificName.toLowerCase();

    return mockRemedies.where((r) {
      final rPlantId = (r.plantId ?? '').toLowerCase().replaceAll('_plant', '');
      if (rPlantId.isNotEmpty && (rPlantId == plantCleanId || rPlantId == plant.id.toLowerCase())) {
        return true;
      }
      final rSci = r.primaryPlantScientific.toLowerCase();
      if (rSci.isNotEmpty && (rSci.contains(plantSci) || plantSci.contains(rSci))) {
        return true;
      }
      final rName = r.primaryPlantName.toLowerCase();
      if (rName.isNotEmpty && (rName.contains(plantName) || plantName.contains(rName))) {
        return true;
      }
      return false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final plant = widget.plant;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 1. Clean Segmented Navigation Bar ──────────────────────────────
        Container(
          margin: const EdgeInsets.only(bottom: 18),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: List.generate(_sections.length, (index) {
                final section = _sections[index];
                final isSelected = _currentIndex == index;

                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: InkWell(
                    onTap: () => _switchSection(index),
                    borderRadius: BorderRadius.circular(24),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? section.color
                            : (isDark ? AppColors.surfaceDark : Colors.white),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isSelected
                              ? section.color
                              : (isDark ? AppColors.borderDark : AppColors.borderLight),
                          width: isSelected ? 1.5 : 1.0,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: section.color.withOpacity(0.35),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            section.icon,
                            size: 16,
                            color: isSelected
                                ? Colors.white
                                : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            section.title,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),

        // ── 2. Active Section Card View ───────────────────────────────────
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 240),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: KeyedSubtree(
            key: ValueKey<int>(_currentIndex),
            child: _buildCurrentSection(isDark, plant),
          ),
        ),

        const SizedBox(height: 18),

        // ── 3. Quick Section Step Footer ──────────────────────────────────
        _buildSectionFooterNav(isDark),
      ],
    );
  }

  Widget _buildCurrentSection(bool isDark, Plant plant) {
    switch (_currentIndex) {
      case 0:
        return _buildOverviewSection(isDark, plant);
      case 1:
        return _buildMedicinalSection(isDark, plant);
      case 2:
        return _buildRemediesSection(isDark, plant);
      case 3:
        return _buildSafetySection(isDark, plant);
      case 4:
        return _buildScientificSection(isDark, plant);
      default:
        return _buildOverviewSection(isDark, plant);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 1: OVERVIEW
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildOverviewSection(bool isDark, Plant plant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Botanical Description Card
        _buildSectionCard(
          isDark: isDark,
          icon: Icons.eco_rounded,
          iconColor: AppColors.primary,
          title: 'Botanical Description',
          subtitle: 'Ecology, characteristics, and natural habitat',
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                plant.description,
                style: TextStyle(
                  fontSize: 14.5,
                  height: 1.6,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              if (plant.appearance.isNotEmpty || plant.habitat.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 14),
              ],
              if (plant.appearance.isNotEmpty) ...[
                _buildInfoRow(
                  icon: Icons.visibility_outlined,
                  iconColor: AppColors.primary,
                  label: 'Botanical Appearance',
                  value: plant.appearance,
                  isDark: isDark,
                ),
                if (plant.habitat.isNotEmpty) const SizedBox(height: 12),
              ],
              if (plant.habitat.isNotEmpty) ...[
                _buildInfoRow(
                  icon: Icons.terrain_rounded,
                  iconColor: const Color(0xFF2E7D32),
                  label: 'Natural Habitat & Ecology',
                  value: plant.habitat,
                  isDark: isDark,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Regional & Vernacular Names Card
        if (plant.vernacularNames.isNotEmpty) ...[
          _buildSectionCard(
            isDark: isDark,
            icon: Icons.translate_rounded,
            iconColor: const Color(0xFF00897B),
            title: 'Regional & Vernacular Names',
            subtitle: 'Traditional botanical naming across languages',
            content: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: plant.vernacularNames.entries.map((entry) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceSubtleDark : AppColors.lightMint,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : const Color(0xFFC8E6C9),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${entry.key}: ',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.mint : AppColors.primaryDark,
                        ),
                      ),
                      Text(
                        entry.value,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 2: MEDICINAL USES
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildMedicinalSection(bool isDark, Plant plant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Therapeutic Indications
        _buildSectionCard(
          isDark: isDark,
          icon: Icons.healing_rounded,
          iconColor: const Color(0xFF00897B),
          title: 'Documented Therapeutic Actions',
          subtitle: 'Primary physiological and health conditions targeted',
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: plant.medicinalUses
                .map((use) => _buildCheckItem(use, isDark, AppColors.primary))
                .toList(),
          ),
        ),
        const SizedBox(height: 14),

        // Key Health Benefits
        if (plant.healthBenefits.isNotEmpty) ...[
          _buildSectionCard(
            isDark: isDark,
            icon: Icons.favorite_rounded,
            iconColor: const Color(0xFF2E7D32),
            title: 'Key Physiological Benefits',
            subtitle: 'Targeted biochemical mechanisms and clinical wellness support',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: plant.healthBenefits
                  .map((benefit) => _buildCheckItem(benefit, isDark, const Color(0xFF2E7D32)))
                  .toList(),
            ),
          ),
          const SizedBox(height: 14),
        ],

        // Traditional & Ayurvedic Heritage
        if (plant.traditionalUses.isNotEmpty) ...[
          _buildSectionCard(
            isDark: isDark,
            icon: Icons.auto_stories_rounded,
            iconColor: const Color(0xFFE65100),
            title: 'Ayurvedic & Classical Heritage',
            subtitle: 'Historical rasayana preparations and centuries-old practices',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: plant.traditionalUses
                  .map((trad) => _buildCheckItem(trad, isDark, const Color(0xFFE65100)))
                  .toList(),
            ),
          ),
        ],
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 3: REMEDIES
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildRemediesSection(bool isDark, Plant plant) {
    final matchingRemedies = _getMatchingRemedies();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Preparation Methods Card
        if (plant.preparationMethods.isNotEmpty) ...[
          _buildSectionCard(
            isDark: isDark,
            icon: Icons.soup_kitchen_rounded,
            iconColor: const Color(0xFFD84315),
            title: 'Herbal Preparation Methods',
            subtitle: 'Traditional culinary and medicinal processing',
            content: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceSubtleDark : const Color(0xFFFBE9E7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : const Color(0xFFFFCCBC),
                ),
              ),
              child: Text(
                plant.preparationMethods,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: isDark ? AppColors.textPrimaryDark : Colors.black87,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
        ],

        // Dosage Guidelines Card
        if (plant.dosageGuidelines.isNotEmpty) ...[
          _buildSectionCard(
            isDark: isDark,
            icon: Icons.medication_liquid_rounded,
            iconColor: const Color(0xFF00838F),
            title: 'Standard Dosage Guidelines',
            subtitle: 'Recommended intake, timing, and administration',
            content: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceSubtleDark : const Color(0xFFE0F7FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : const Color(0xFFB2EBF2),
                ),
              ),
              child: Text(
                plant.dosageGuidelines,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: isDark ? AppColors.textPrimaryDark : Colors.black87,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
        ],

        // Ready-to-use Home Remedy Recipes
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Verified Home Remedies',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            if (matchingRemedies.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${matchingRemedies.length} Available',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),

        if (matchingRemedies.isNotEmpty) ...[
          Consumer<RemediesViewModel>(
            builder: (context, remediesVM, _) {
              return Column(
                children: matchingRemedies.map((remedy) {
                  final isBookmarked = remediesVM.isBookmarked(remedy.id);
                  return RemedyCard(
                    remedy: remedy,
                    isBookmarked: isBookmarked,
                    onToggleBookmark: () => remediesVM.toggleBookmark(remedy.id),
                  );
                }).toList(),
              );
            },
          ),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: Center(
              child: Column(
                children: [
                  const Icon(Icons.healing_outlined, size: 36, color: AppColors.primary),
                  const SizedBox(height: 8),
                  Text(
                    'Direct formulations for ${plant.commonName} are described in the preparation guidelines above.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 4: SAFETY & PRECAUTIONS
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildSafetySection(bool isDark, Plant plant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Contraindications Alert Card
        if (plant.contraindications.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2E1212) : const Color(0xFFFFEBEE),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFFEF9A9A),
                width: 1.2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC62828).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.block_rounded, color: Color(0xFFC62828), size: 20),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Contraindications (Do Not Use If)',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFFC62828),
                            ),
                          ),
                          Text(
                            'Strict conditions where this botanical should be avoided',
                            style: TextStyle(fontSize: 11.5, color: Color(0xFFB71C1C)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...plant.contraindications.map((c) => _buildWarningTile(
                      c,
                      isDark,
                      const Color(0xFFC62828),
                      Icons.cancel_outlined,
                    )),
              ],
            ),
          ),
          const SizedBox(height: 14),
        ],

        // General Precautions Card
        if (plant.precautions.isNotEmpty) ...[
          _buildSectionCard(
            isDark: isDark,
            icon: Icons.info_outline_rounded,
            iconColor: const Color(0xFFEF6C00),
            title: 'General Safety Precautions',
            subtitle: 'Guidance for pregnant women, children, and medication interactions',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: plant.precautions
                  .map((p) => _buildWarningTile(
                        p,
                        isDark,
                        const Color(0xFFEF6C00),
                        Icons.info_outline_rounded,
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 14),
        ],

        // Possible Side Effects Card
        if (plant.sideEffects.isNotEmpty) ...[
          _buildSectionCard(
            isDark: isDark,
            icon: Icons.warning_amber_rounded,
            iconColor: const Color(0xFFAD1457),
            title: 'Potential Side Effects',
            subtitle: 'Observed reactions under excessive dosage or prolonged use',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: plant.sideEffects
                  .map((s) => _buildWarningTile(
                        s,
                        isDark,
                        const Color(0xFFAD1457),
                        Icons.warning_amber_rounded,
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 14),
        ],

        // Medical Safeguard Note
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? Colors.amber.withOpacity(0.08) : const Color(0xFFFFF8E1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFFD54F)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.health_and_safety_outlined, color: Color(0xFFF57F17), size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Educational botanical guidance only. Always consult a qualified medical doctor or certified Ayurvedic practitioner prior to therapeutic administration.',
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.45,
                    fontWeight: FontWeight.w600,
                    color: isDark ? const Color(0xFFFFD54F) : const Color(0xFF5D4037),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION 5: SCIENTIFIC INFORMATION
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildScientificSection(bool isDark, Plant plant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Botanical Taxonomy Card
        _buildSectionCard(
          isDark: isDark,
          icon: Icons.science_rounded,
          iconColor: const Color(0xFF5E35B1),
          title: 'Botanical Taxonomy & Classification',
          subtitle: 'Scientific identification and taxonomic lineage',
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTaxonomyRow('Binomial Name', plant.scientificName, isItalic: true, isDark: isDark),
              const Divider(height: 16),
              _buildTaxonomyRow('Botanical Family', plant.family, isDark: isDark),
              const Divider(height: 16),
              _buildTaxonomyRow('Plant Classification', plant.plantType, isDark: isDark),
              const Divider(height: 16),
              _buildTaxonomyRow('Model Classification ID', plant.id, isDark: isDark),
              const Divider(height: 16),
              _buildTaxonomyRow('ML Validation Status', 'Verified Botanical Flora', isDark: isDark),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Active Phytochemical Constituents
        if (plant.activeConstituents.isNotEmpty) ...[
          _buildSectionCard(
            isDark: isDark,
            icon: Icons.bubble_chart_rounded,
            iconColor: const Color(0xFF7B1FA2),
            title: 'Active Phytochemicals',
            subtitle: 'Bio-active molecules driving pharmacological action',
            content: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: plant.activeConstituents.map((c) {
                return Chip(
                  avatar: const Icon(Icons.bubble_chart_rounded, size: 16, color: Color(0xFF7B1FA2)),
                  label: Text(
                    c,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12.5,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  backgroundColor: isDark ? AppColors.surfaceSubtleDark : const Color(0xFFF3E5F5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: isDark ? AppColors.borderDark : const Color(0xFFE1BEE7),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 14),
        ],

        // Harvested Medicinal Parts
        if (plant.partsUsed.isNotEmpty) ...[
          _buildSectionCard(
            isDark: isDark,
            icon: Icons.grass_rounded,
            iconColor: AppColors.primary,
            title: 'Medicinal Plant Parts Used',
            subtitle: 'Botanical organs harvested for formulations',
            content: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: plant.partsUsed.map((part) {
                return Chip(
                  avatar: const Icon(Icons.grass_rounded, size: 16, color: AppColors.primary),
                  label: Text(
                    part,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12.5,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  backgroundColor: isDark ? AppColors.surfaceSubtleDark : AppColors.lightMint,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: isDark ? AppColors.borderDark : const Color(0xFFC8E6C9),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SHARED CARD BUILDERS & HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildSectionCard({
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    required Widget content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 1),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          content,
        ],
      ),
    );
  }

  Widget _buildCheckItem(String text, bool isDark, Color checkColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: checkColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check, size: 12, color: checkColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13.5,
                height: 1.45,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningTile(String text, bool isDark, Color accentColor, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: accentColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTaxonomyRow(String label, String value, {bool isItalic = false, required bool isDark}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionFooterNav(bool isDark) {
    final nextIndex = _currentIndex + 1;
    final prevIndex = _currentIndex - 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (prevIndex >= 0)
          TextButton.icon(
            onPressed: () => _switchSection(prevIndex),
            icon: const Icon(Icons.arrow_back_rounded, size: 16),
            label: Text(_sections[prevIndex].title),
            style: TextButton.styleFrom(
              foregroundColor: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          )
        else
          const SizedBox.shrink(),
        if (nextIndex < _sections.length)
          ElevatedButton.icon(
            onPressed: () => _switchSection(nextIndex),
            icon: const Icon(Icons.arrow_forward_rounded, size: 16),
            label: Text('Next: ${_sections[nextIndex].title}'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _sections[nextIndex].color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          )
        else
          const SizedBox.shrink(),
      ],
    );
  }
}

class _SectionMeta {
  final String title;
  final IconData icon;
  final Color color;

  const _SectionMeta({
    required this.title,
    required this.icon,
    required this.color,
  });
}
