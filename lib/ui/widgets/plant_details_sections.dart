import 'package:flutter/material.dart';
import '../../data/models/plant_model.dart';
import '../../data/mock/mock_remedies_data.dart';
import '../../data/models/remedy_model.dart';
import '../theme/app_colors.dart';
import 'remedy_card.dart';

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
      color: Color(0xFFE65100),
    ),
    _SectionMeta(
      title: 'Safety & Dosage',
      icon: Icons.shield_rounded,
      color: Color(0xFFC62828),
    ),
    _SectionMeta(
      title: 'Botanical Science',
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
        // Horizontal Segmented Navigation Bar
        Container(
          margin: const EdgeInsets.only(bottom: 22),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: List.generate(_sections.length, (index) {
                final section = _sections[index];
                final isSelected = _currentIndex == index;

                return Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: InkWell(
                    onTap: () => _switchSection(index),
                    borderRadius: BorderRadius.circular(24),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? section.color
                            : (isDark ? AppColors.surfaceDark : Colors.white),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isSelected
                              ? section.color
                              : (isDark ? AppColors.borderDark : const Color(0xFFE2EBE5)),
                          width: isSelected ? 1.8 : 1.0,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: section.color.withOpacity(0.35),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            section.icon,
                            size: 18,
                            color: isSelected
                                ? Colors.white
                                : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            section.title,
                            style: TextStyle(
                              fontSize: 14.5,
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

        // Section Content
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 240),
          child: KeyedSubtree(
            key: ValueKey<int>(_currentIndex),
            child: _buildCurrentSection(isDark, plant),
          ),
        ),

        const SizedBox(height: 24),

        // Bottom Navigation Next/Previous bar
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

  // ── MODULE 1: OVERVIEW ──
  Widget _buildOverviewSection(bool isDark, Plant plant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                  fontSize: 16,
                  height: 1.6,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              if (plant.appearance.isNotEmpty || plant.habitat.isNotEmpty) ...[
                const SizedBox(height: 18),
                Divider(color: isDark ? AppColors.borderDark : const Color(0xFFEDF2EE)),
                const SizedBox(height: 14),
              ],
              if (plant.appearance.isNotEmpty) ...[
                _buildInfoRow(
                  icon: Icons.visibility_outlined,
                  iconColor: AppColors.primary,
                  label: 'Physical Appearance',
                  value: plant.appearance,
                  isDark: isDark,
                ),
                if (plant.habitat.isNotEmpty) const SizedBox(height: 14),
              ],
              if (plant.habitat.isNotEmpty) ...[
                _buildInfoRow(
                  icon: Icons.terrain_rounded,
                  iconColor: AppColors.primary,
                  label: 'Natural Habitat & Climate',
                  value: plant.habitat,
                  isDark: isDark,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 18),

        if (plant.partsUsed.isNotEmpty)
          _buildSectionCard(
            isDark: isDark,
            icon: Icons.spa_rounded,
            iconColor: const Color(0xFF00897B),
            title: 'Medicinal Plant Parts Used',
            subtitle: 'Harvested components possessing therapeutic actions',
            content: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: plant.partsUsed.map((part) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceSubtleDark : AppColors.lightMint,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : AppColors.primarySubtle,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle_rounded, size: 16, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        part,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  // ── MODULE 2: MEDICINAL USES ──
  Widget _buildMedicinalSection(bool isDark, Plant plant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (plant.medicinalUses.isNotEmpty)
          _buildSectionCard(
            isDark: isDark,
            icon: Icons.healing_rounded,
            iconColor: const Color(0xFF00897B),
            title: 'Primary Health Conditions Treated',
            subtitle: 'Clinically noted therapeutic applications',
            content: Column(
              children: plant.medicinalUses.map((use) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceSubtleDark : const Color(0xFFF3F9F5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : const Color(0xFFD6EAE0),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check_rounded, color: AppColors.primary, size: 18),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          use,
                          style: TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w600,
                            height: 1.45,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        const SizedBox(height: 18),

        if (plant.healthBenefits.isNotEmpty)
          _buildSectionCard(
            isDark: isDark,
            icon: Icons.verified_rounded,
            iconColor: AppColors.primary,
            title: 'Key Health Benefits',
            subtitle: 'Holistic wellness impacts on human physiology',
            content: Column(
              children: plant.healthBenefits.map((benefit) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Icon(Icons.star_rounded, size: 18, color: AppColors.amberHoney),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          benefit,
                          style: TextStyle(
                            fontSize: 15.5,
                            height: 1.45,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  // ── MODULE 3: HOME REMEDIES ──
  Widget _buildRemediesSection(bool isDark, Plant plant) {
    final matchingRemedies = _getMatchingRemedies();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (matchingRemedies.isNotEmpty) ...[
          Text(
            'Traditional Recipes for ${plant.commonName}',
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tap any recipe below to open the step-by-step preparation dossier',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight,
            ),
          ),
          const SizedBox(height: 16),
          ...matchingRemedies.map((remedy) {
            return RemedyCard(
              remedy: remedy,
              isBookmarked: false,
              onToggleBookmark: () {},
            );
          }),
        ] else ...[
          _buildSectionCard(
            isDark: isDark,
            icon: Icons.soup_kitchen_rounded,
            iconColor: const Color(0xFFE65100),
            title: 'Traditional Preparation Methods',
            subtitle: 'Classical decoctions, teas, and topical poultices',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (plant.traditionalUses.isNotEmpty) ...[
                  ...plant.traditionalUses.map((trad) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Icon(Icons.emoji_objects_outlined, size: 18, color: Color(0xFFE65100)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              trad,
                              style: TextStyle(
                                fontSize: 15.5,
                                height: 1.45,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 14),
                ],
                if (plant.preparationMethods.isNotEmpty) ...[
                  Text(
                    plant.preparationMethods,
                    style: TextStyle(
                      fontSize: 15.5,
                      height: 1.5,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }

  // ── MODULE 4: SAFETY & DOSAGE ──
  Widget _buildSafetySection(bool isDark, Plant plant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (plant.dosageGuidelines.isNotEmpty)
          _buildSectionCard(
            isDark: isDark,
            icon: Icons.access_time_filled_rounded,
            iconColor: AppColors.primary,
            title: 'Dosage & Consumption Guidelines',
            subtitle: 'Recommended herbal quantities and frequencies',
            content: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceSubtleDark : const Color(0xFFF3F9F5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : const Color(0xFFD6EAE0),
                ),
              ),
              child: Text(
                plant.dosageGuidelines,
                style: TextStyle(
                  fontSize: 15.5,
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
            ),
          ),
        const SizedBox(height: 18),

        if (plant.precautions.isNotEmpty)
          _buildSectionCard(
            isDark: isDark,
            icon: Icons.warning_amber_rounded,
            iconColor: AppColors.warning,
            title: 'Precautions & Contraindications',
            subtitle: 'Safety guidance for pregnant women, children, and medications',
            content: Column(
              children: plant.precautions.map((prec) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.warning.withOpacity(0.3)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('⚠️ ', style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          prec,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.45,
                            color: isDark ? AppColors.textPrimaryDark : const Color(0xFF5A4000),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        const SizedBox(height: 18),

        if (plant.sideEffects.isNotEmpty)
          _buildSectionCard(
            isDark: isDark,
            icon: Icons.info_outline_rounded,
            iconColor: const Color(0xFFC62828),
            title: 'Possible Side Effects',
            subtitle: 'Reported adverse reactions upon overdose',
            content: Column(
              children: plant.sideEffects.map((side) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 3),
                        child: Icon(Icons.circle, size: 7, color: Color(0xFFC62828)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          side,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.4,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  // ── MODULE 5: BOTANICAL SCIENCE ──
  Widget _buildScientificSection(bool isDark, Plant plant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionCard(
          isDark: isDark,
          icon: Icons.science_rounded,
          iconColor: const Color(0xFF5E35B1),
          title: 'Botanical Classification',
          subtitle: 'Formal scientific taxonomy and vernacular naming',
          content: Column(
            children: [
              _buildInfoRow(
                icon: Icons.title_rounded,
                iconColor: const Color(0xFF5E35B1),
                label: 'Botanical Binomial Name',
                value: plant.scientificName,
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              _buildInfoRow(
                icon: Icons.category_rounded,
                iconColor: const Color(0xFF5E35B1),
                label: 'Botanical Plant Family',
                value: plant.family,
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              _buildInfoRow(
                icon: Icons.grass_rounded,
                iconColor: const Color(0xFF5E35B1),
                label: 'Plant Type / Habit',
                value: plant.plantType,
                isDark: isDark,
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        if (plant.vernacularNames.isNotEmpty)
          _buildSectionCard(
            isDark: isDark,
            icon: Icons.translate_rounded,
            iconColor: const Color(0xFF5E35B1),
            title: 'Regional & Vernacular Names',
            subtitle: 'Names across traditional Indian languages and dialects',
            content: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: plant.vernacularNames.entries.map((entry) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceSubtleDark : const Color(0xFFF3EDF9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : const Color(0xFFDED1EE),
                    ),
                  ),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${entry.key}: ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.mint : const Color(0xFF5E35B1),
                          ),
                        ),
                        TextSpan(
                          text: entry.value,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        const SizedBox(height: 18),

        if (plant.activeConstituents.isNotEmpty)
          _buildSectionCard(
            isDark: isDark,
            icon: Icons.biotech_rounded,
            iconColor: const Color(0xFF5E35B1),
            title: 'Phytochemical Compounds',
            subtitle: 'Active bioactive molecules responsible for efficacy',
            content: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: plant.activeConstituents.map((c) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceSubtleDark : AppColors.surfaceSubtleLight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.circle, size: 6, color: Color(0xFF5E35B1)),
                      const SizedBox(width: 8),
                      Text(
                        c,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  // ── REUSABLE CARD BUILDER ──
  Widget _buildSectionCard({
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? AppColors.borderDark : const Color(0xFFE5ECE7),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          content,
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
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15.5,
                  height: 1.4,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionFooterNav(bool isDark) {
    final hasPrev = _currentIndex > 0;
    final hasNext = _currentIndex < _sections.length - 1;

    return Row(
      children: [
        if (hasPrev)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _switchSection(_currentIndex - 1),
              icon: const Icon(Icons.arrow_back_rounded, size: 18),
              label: Text(_sections[_currentIndex - 1].title),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ),
          )
        else
          const Spacer(),
        const SizedBox(width: 12),
        if (hasNext)
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _switchSection(_currentIndex + 1),
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              label: Text(_sections[_currentIndex + 1].title),
              style: ElevatedButton.styleFrom(
                backgroundColor: _sections[_currentIndex + 1].color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ),
          )
        else
          const Spacer(),
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
