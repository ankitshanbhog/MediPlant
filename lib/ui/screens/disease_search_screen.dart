import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/database_helper.dart';
import '../../data/models/disease_model.dart';
import '../../viewmodels/search_viewmodel.dart';
import '../../viewmodels/voice_viewmodel.dart';
import '../theme/app_colors.dart';
import '../widgets/disease_chip.dart';
import '../widgets/plant_card.dart';
import '../widgets/plant_image.dart';
import '../widgets/state_views.dart';
import 'plant_detail_screen.dart';

class DiseaseSearchScreen extends StatefulWidget {
  const DiseaseSearchScreen({super.key});

  @override
  State<DiseaseSearchScreen> createState() => _DiseaseSearchScreenState();
}

class _DiseaseSearchScreenState extends State<DiseaseSearchScreen> {
  // 0: Health Conditions, 1: Botanical Species
  int _selectedTabIndex = 0;

  static const List<String> _quickSymptoms = [
    'Cough',
    'Cold',
    'Digestion',
    'Fever',
    'Acidity',
    'Skin',
    'Headache',
    'Immunity',
  ];

  IconData _categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'respiratory':
        return Icons.air_rounded;
      case 'digestive':
        return Icons.spa_rounded;
      case 'pain & inflammation':
      case 'pain':
        return Icons.flash_on_rounded;
      case 'skin & hair':
      case 'skin':
        return Icons.face_retouching_natural_rounded;
      case 'immune & general':
      case 'immune':
        return Icons.shield_rounded;
      default:
        return Icons.healing_rounded;
    }
  }

  String _formatPlantId(String id) {
    return id
        .replaceAll('_plant', '')
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
        .join(' ');
  }

  void _openConditionProtocol(BuildContext context, Disease disease) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _ConditionProtocolSheet(
        disease: disease,
        categoryIcon: _categoryIcon(disease.category),
        formatPlantId: _formatPlantId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchVM = context.watch<SearchViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF7FAF8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'Health & Discovery',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.6,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Find botanical remedies by health condition or plant species',
                style: TextStyle(
                  fontSize: 15,
                  height: 1.4,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight,
                ),
              ),
              const SizedBox(height: 20),

              // Search Bar
              TextField(
                style: const TextStyle(fontSize: 16),
                onChanged: (value) => searchVM.setSearchQuery(value),
                decoration: InputDecoration(
                  hintText: 'Search condition or plant (e.g. Cough, Tulsi)...',
                  hintStyle: TextStyle(
                    fontSize: 15,
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    child: Icon(Icons.search_rounded, color: AppColors.primary, size: 24),
                  ),
                  prefixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                  suffixIcon: searchVM.searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 20),
                          onPressed: () => searchVM.clearSearch(),
                        )
                      : null,
                  filled: true,
                  fillColor: isDark ? AppColors.surfaceDark : Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(
                      color: isDark ? AppColors.borderDark : const Color(0xFFE2EBE5),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(color: AppColors.primary, width: 1.8),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Quick Symptom Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _quickSymptoms.map((sym) {
                    final isSelected = searchVM.searchQuery.toLowerCase() == sym.toLowerCase();
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(
                        label: Text(sym),
                        labelStyle: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                        ),
                        backgroundColor: isSelected
                            ? AppColors.primary
                            : (isDark ? AppColors.surfaceDark : Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.primary
                                : (isDark ? AppColors.borderDark : const Color(0xFFE2EBE5)),
                          ),
                        ),
                        onPressed: () {
                          if (isSelected) {
                            searchVM.clearSearch();
                          } else {
                            searchVM.setSearchQuery(sym);
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 18),

              // Dual-Segment Switcher: [ Health Conditions ] vs [ Botanical Species ]
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : const Color(0xFFEDF3EE),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedTabIndex = 0),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          decoration: BoxDecoration(
                            color: _selectedTabIndex == 0
                                ? (isDark ? AppColors.primaryAccent : Colors.white)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(13),
                            boxShadow: _selectedTabIndex == 0
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.06),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.healing_rounded,
                                  size: 17,
                                  color: _selectedTabIndex == 0
                                      ? (isDark ? Colors.black : AppColors.primary)
                                      : (isDark ? Colors.grey[400] : Colors.grey[600]),
                                ),
                                const SizedBox(width: 7),
                                Text(
                                  'Conditions (${searchVM.filteredDiseases.length})',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: _selectedTabIndex == 0 ? FontWeight.w800 : FontWeight.w600,
                                    color: _selectedTabIndex == 0
                                        ? (isDark ? Colors.black : AppColors.primary)
                                        : (isDark ? Colors.grey[400] : Colors.grey[600]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedTabIndex = 1),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          decoration: BoxDecoration(
                            color: _selectedTabIndex == 1
                                ? (isDark ? AppColors.primaryAccent : Colors.white)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(13),
                            boxShadow: _selectedTabIndex == 1
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.06),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.eco_rounded,
                                  size: 17,
                                  color: _selectedTabIndex == 1
                                      ? (isDark ? Colors.black : AppColors.primary)
                                      : (isDark ? Colors.grey[400] : Colors.grey[600]),
                                ),
                                const SizedBox(width: 7),
                                Text(
                                  'Botanical Plants (${searchVM.matchingPlants.length})',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: _selectedTabIndex == 1 ? FontWeight.w800 : FontWeight.w600,
                                    color: _selectedTabIndex == 1
                                        ? (isDark ? Colors.black : AppColors.primary)
                                        : (isDark ? Colors.grey[400] : Colors.grey[600]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Category Pills (Only active for Conditions tab)
              if (_selectedTabIndex == 0) ...[
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: searchVM.categories.map((cat) {
                      return DiseaseChip(
                        label: cat,
                        isSelected: searchVM.selectedCategory == cat,
                        onTap: () => searchVM.setCategory(cat),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Content View based on active Tab
              if (searchVM.hasNoResults) ...[
                DoctorConsultationBanner(
                  query: searchVM.searchQuery,
                  onSearchOther: () => searchVM.clearSearch(),
                ),
              ] else if (_selectedTabIndex == 0) ...[
                // TAB 0: HEALTH CONDITIONS
                if (searchVM.filteredDiseases.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 36),
                      child: Text(
                        'No conditions match this filter.',
                        style: TextStyle(
                          fontSize: 15,
                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                        ),
                      ),
                    ),
                  )
                else
                  ...searchVM.filteredDiseases.map((d) {
                    final icon = _categoryIcon(d.category);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 18),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark ? AppColors.borderDark : const Color(0xFFE5ECE7),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.035),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () => _openConditionProtocol(context, d),
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top Row: Icon + Name + Category + Audio
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Icon(icon, color: AppColors.primary, size: 24),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          d.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 18,
                                            letterSpacing: -0.3,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          d.category,
                                          style: TextStyle(
                                            fontSize: 12.5,
                                            color: isDark ? AppColors.mint : AppColors.primary,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Builder(
                                    builder: (ctx) {
                                      final voiceVM = ctx.watch<VoiceViewModel>();
                                      final isThisSpeaking =
                                          voiceVM.isPlaying && voiceVM.currentNarrationTitle == d.name;
                                      return IconButton(
                                        visualDensity: VisualDensity.compact,
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        icon: Icon(
                                          isThisSpeaking ? Icons.volume_up_rounded : Icons.volume_down_rounded,
                                          color: isThisSpeaking
                                              ? AppColors.primaryAccent
                                              : AppColors.textSecondaryLight,
                                          size: 22,
                                        ),
                                        onPressed: () {
                                          final plantNames =
                                              d.relatedPlantIds.map(_formatPlantId).join(', ');
                                          final speechText =
                                              '${d.name}. Category: ${d.category}. '
                                              '${d.description}. '
                                              'Key symptoms: ${d.symptoms.join(', ')}. '
                                              'Recommended medicinal plants: $plantNames.';
                                          voiceVM.togglePlayPause(title: d.name, text: speechText);
                                        },
                                        tooltip: 'Listen to Protocol',
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Description Snippet
                              Text(
                                d.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                  height: 1.45,
                                ),
                              ),
                              const SizedBox(height: 14),

                              // Bottom Row: Botanical plant allies preview + "View Protocol →"
                              Row(
                                children: [
                                  if (d.relatedPlantIds.isNotEmpty) ...[
                                    Expanded(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: d.relatedPlantIds.take(2).map((pid) {
                                            return Container(
                                              margin: const EdgeInsets.only(right: 6),
                                              padding: const EdgeInsets.fromLTRB(4, 3, 8, 3),
                                              decoration: BoxDecoration(
                                                color: isDark
                                                    ? AppColors.surfaceSubtleDark
                                                    : AppColors.lightMint,
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  PlantImage(
                                                    plantId: pid,
                                                    width: 22,
                                                    height: 22,
                                                    borderRadius: BorderRadius.circular(11),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    _formatPlantId(pid),
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w700,
                                                      color: isDark ? AppColors.mint : AppColors.primary,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Explore Protocol',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: isDark ? AppColors.mint : AppColors.primary,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        Icons.arrow_forward_rounded,
                                        size: 16,
                                        color: isDark ? AppColors.mint : AppColors.primary,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
              ] else ...[
                // TAB 1: BOTANICAL PLANTS ONLY
                if (searchVM.matchingPlants.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 36),
                      child: Text(
                        'No botanical plants match this search.',
                        style: TextStyle(
                          fontSize: 15,
                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                        ),
                      ),
                    ),
                  )
                else
                  ...searchVM.matchingPlants.map((plant) {
                    return PlantCard(
                      plant: plant,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlantDetailScreen(plant: plant),
                          ),
                        );
                      },
                    );
                  }),
              ],
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Dedicated Condition Protocol Modal Sheet ──
class _ConditionProtocolSheet extends StatelessWidget {
  final Disease disease;
  final IconData categoryIcon;
  final String Function(String) formatPlantId;

  const _ConditionProtocolSheet({
    required this.disease,
    required this.categoryIcon,
    required this.formatPlantId,
  });

  @override
  Widget build(BuildContext context) {
    final d = disease;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final voiceVM = context.watch<VoiceViewModel>();
    final isThisSpeaking = voiceVM.isPlaying && voiceVM.currentNarrationTitle == d.name;

    final plantNames = d.relatedPlantIds.map(formatPlantId).join(', ');
    final speechText =
        '${d.name}. Category: ${d.category}. '
        '${d.description}. '
        'Key symptoms: ${d.symptoms.join(', ')}. '
        'Recommended medicinal plants: $plantNames.';

    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.backgroundDark : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            children: [
              // Drag Handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // Scrollable Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(22, 10, 22, 32),
                  children: [
                    // Top Row: Category + Close Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(categoryIcon, size: 16, color: AppColors.primary),
                              const SizedBox(width: 6),
                              Text(
                                d.category,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, size: 24),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Condition Title & Audio
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            d.name,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                        IconButton.filledTonal(
                          style: IconButton.styleFrom(
                            backgroundColor: isThisSpeaking
                                ? AppColors.primaryAccent
                                : (isDark ? AppColors.surfaceSubtleDark : const Color(0xFFE8F5E9)),
                          ),
                          icon: Icon(
                            isThisSpeaking ? Icons.volume_up_rounded : Icons.volume_down_rounded,
                            color: isThisSpeaking
                                ? Colors.white
                                : (isDark ? AppColors.mint : AppColors.primary),
                            size: 22,
                          ),
                          onPressed: () {
                            voiceVM.togglePlayPause(title: d.name, text: speechText);
                          },
                          tooltip: 'Listen to Protocol',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Overview
                    const Text(
                      'Condition Overview',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      d.description,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Symptoms Checklist
                    const Text(
                      'Associated Symptoms',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: d.symptoms.map((sym) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.surfaceDark : const Color(0xFFF0F5F2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark ? AppColors.borderDark : const Color(0xFFE0ECE4),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check_circle_outline_rounded,
                                  size: 16, color: AppColors.primary),
                              const SizedBox(width: 8),
                              Text(
                                sym,
                                style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Recommended Medicinal Plants
                    if (d.relatedPlantIds.isNotEmpty) ...[
                      const Text(
                        'Recommended Botanical Plants',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...d.relatedPlantIds.map((plantId) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.surfaceDark : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark ? AppColors.borderDark : const Color(0xFFE2EBE5),
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                            leading: PlantImage(
                              plantId: plantId,
                              width: 46,
                              height: 46,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            title: Text(
                              formatPlantId(plantId),
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                            ),
                            subtitle: Text(
                              'Traditional botanical ally for ${d.name}',
                              style: TextStyle(
                                fontSize: 12.5,
                                color: isDark ? AppColors.mint : AppColors.primary,
                              ),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                            onTap: () async {
                              final plant = await DatabaseHelper.instance.getPlantById(plantId);
                              if (plant != null && context.mounted) {
                                Navigator.pop(context); // Close bottom sheet
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PlantDetailScreen(plant: plant),
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      }),
                      const SizedBox(height: 18),
                    ],

                    // Medical Disclaimer
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceSubtleDark : const Color(0xFFFFF8E7),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.warning.withOpacity(0.3)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.shield_outlined, size: 20, color: AppColors.warning),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              d.medicalDisclaimer,
                              style: TextStyle(
                                fontSize: 12.5,
                                height: 1.4,
                                color: isDark ? AppColors.textSecondaryDark : const Color(0xFF7A5800),
                              ),
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
        );
      },
    );
  }
}
