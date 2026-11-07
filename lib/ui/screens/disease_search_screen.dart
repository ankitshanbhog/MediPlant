import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/database_helper.dart';
import '../../viewmodels/search_viewmodel.dart';
import '../../viewmodels/voice_viewmodel.dart';
import '../theme/app_colors.dart';
import '../widgets/disease_chip.dart';
import '../widgets/plant_card.dart';
import '../widgets/plant_image.dart';
import '../widgets/state_views.dart';
import 'plant_detail_screen.dart';

class DiseaseSearchScreen extends StatelessWidget {
  const DiseaseSearchScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    final searchVM = context.watch<SearchViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF7FAF8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'Health & Conditions',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.6,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Find botanical remedies for common health symptoms',
                style: TextStyle(
                  fontSize: 15,
                  height: 1.4,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight,
                ),
              ),
              const SizedBox(height: 22),

              // Search Box
              TextField(
                style: const TextStyle(fontSize: 16),
                onChanged: (value) => searchVM.setSearchQuery(value),
                decoration: InputDecoration(
                  hintText: 'Search condition (e.g. Cough, Fever, Digestion)...',
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
              const SizedBox(height: 18),

              // Category Filter Row
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
              const SizedBox(height: 24),

              if (searchVM.hasNoResults) ...[
                DoctorConsultationBanner(
                  query: searchVM.searchQuery,
                  onSearchOther: () => searchVM.clearSearch(),
                ),
              ] else ...[
                // Health Conditions List
                if (searchVM.filteredDiseases.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Health Conditions (${searchVM.filteredDiseases.length})',
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...searchVM.filteredDiseases.map((d) {
                    final icon = _categoryIcon(d.category);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark ? AppColors.borderDark : const Color(0xFFE5ECE7),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header: Icon + Name + Category + Audio Button
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Icon(icon, color: AppColors.primary, size: 26),
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
                                    const SizedBox(height: 4),
                                    Text(
                                      d.category,
                                      style: TextStyle(
                                        fontSize: 13,
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
                                  final isThisSpeaking = voiceVM.isPlaying && voiceVM.currentNarrationTitle == d.name;
                                  return IconButton(
                                    visualDensity: VisualDensity.compact,
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: Icon(
                                      isThisSpeaking ? Icons.volume_up_rounded : Icons.volume_down_rounded,
                                      color: isThisSpeaking ? AppColors.primaryAccent : AppColors.textSecondaryLight,
                                      size: 22,
                                    ),
                                    onPressed: () {
                                      final plantNames = d.relatedPlantIds.map(_formatPlantId).join(', ');
                                      final speechText =
                                          '${d.name}. Category: ${d.category}. '
                                          '${d.description}. '
                                          'Key symptoms: ${d.symptoms.join(', ')}. '
                                          'Recommended medicinal plants: $plantNames.';
                                      voiceVM.togglePlayPause(title: d.name, text: speechText);
                                    },
                                    tooltip: 'Listen to Condition & Plants',
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Description
                          Text(
                            d.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14.5,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Symptoms Chips
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              ...d.symptoms.take(3).map((sym) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.surfaceSubtleDark : AppColors.surfaceSubtleLight,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.circle, size: 6, color: AppColors.primary),
                                      const SizedBox(width: 6),
                                      Text(
                                        sym,
                                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                              if (d.symptoms.length > 3)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  child: Text(
                                    '+${d.symptoms.length - 3} more',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          // Matching Plants Section
                          if (d.relatedPlantIds.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Divider(
                              height: 1,
                              color: isDark ? AppColors.borderDark : const Color(0xFFEDF2EE),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                const Text(
                                  'Matching Plants:',
                                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: d.relatedPlantIds.map((plantId) {
                                        return Padding(
                                          padding: const EdgeInsets.only(right: 8),
                                          child: InkWell(
                                            onTap: () async {
                                              final plant = await DatabaseHelper.instance.getPlantById(plantId);
                                              if (plant != null && context.mounted) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => PlantDetailScreen(plant: plant),
                                                  ),
                                                );
                                              }
                                            },
                                            borderRadius: BorderRadius.circular(22),
                                            child: Container(
                                              padding: const EdgeInsets.fromLTRB(6, 4, 12, 4),
                                              decoration: BoxDecoration(
                                                color: isDark ? AppColors.surfaceSubtleDark : AppColors.lightMint,
                                                borderRadius: BorderRadius.circular(22),
                                                border: Border.all(
                                                  color: isDark ? AppColors.borderDark : AppColors.primarySubtle,
                                                  width: 1,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  PlantImage(
                                                    plantId: plantId,
                                                    width: 26,
                                                    height: 26,
                                                    borderRadius: BorderRadius.circular(13),
                                                  ),
                                                  const SizedBox(width: 7),
                                                  Text(
                                                    _formatPlantId(plantId),
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w700,
                                                      color: isDark ? AppColors.mint : AppColors.primary,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 18),
                ],

                // Matching Botanical Plants
                if (searchVM.matchingPlants.isNotEmpty) ...[
                  Text(
                    'Botanical Species (${searchVM.matchingPlants.length})',
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 14),
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
              ],
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}
