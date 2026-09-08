import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/database_helper.dart';
import '../../viewmodels/search_viewmodel.dart';
import '../theme/app_colors.dart';
import '../widgets/disease_chip.dart';
import '../widgets/plant_card.dart';
import '../widgets/plant_image.dart';
import '../widgets/state_views.dart';
import 'plant_detail_screen.dart';

/// Redesigned Disease & Health Condition Search Screen
/// Clean, visual, uncluttered layout with plant photo previews and compact cards.
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 1. Title & Subtitle ──────────────────────────────────
              const Text(
                'Health & Conditions',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Find botanical remedies for common health symptoms',
                style: TextStyle(
                  fontSize: 13.5,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight,
                ),
              ),
              const SizedBox(height: 18),

              // ── 2. Search Bar ────────────────────────────────────────
              TextField(
                style: const TextStyle(fontSize: 14.5),
                onChanged: (value) => searchVM.setSearchQuery(value),
                decoration: InputDecoration(
                  hintText: 'Search condition (e.g. Cough, Digestion, Fever)...',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
                  prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary, size: 22),
                  suffixIcon: searchVM.searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 18),
                          onPressed: () => searchVM.clearSearch(),
                        )
                      : null,
                  filled: true,
                  fillColor: isDark ? AppColors.surfaceDark : Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: isDark ? AppColors.borderDark : const Color(0xFFE2EBE5),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // ── 3. Category Filter Chips ─────────────────────────────
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

              // ── 4. Content Area ──────────────────────────────────────
              if (searchVM.hasNoResults) ...[
                DoctorConsultationBanner(
                  query: searchVM.searchQuery,
                  onSearchOther: () => searchVM.clearSearch(),
                ),
              ] else ...[
                // Condition Cards
                if (searchVM.filteredDiseases.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Health Conditions (${searchVM.filteredDiseases.length})',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...searchVM.filteredDiseases.map((d) {
                    final icon = _categoryIcon(d.category);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isDark ? AppColors.borderDark : const Color(0xFFE5ECE7),
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
                          // Header: Icon + Title + Category Badge
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(icon, color: AppColors.primary, size: 22),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      d.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 16,
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      d.category,
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        color: isDark ? AppColors.mint : AppColors.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Concise summary (2 lines max)
                          Text(
                            d.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Symptoms Chips (compact, max 3)
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              ...d.symptoms.take(3).map((sym) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.surfaceSubtleDark : AppColors.surfaceSubtleLight,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.circle, size: 5, color: AppColors.primary),
                                      const SizedBox(width: 5),
                                      Text(
                                        sym,
                                        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                              if (d.symptoms.length > 3)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                  child: Text(
                                    '+${d.symptoms.length - 3} more',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          // Recommended Plant Photos Strip
                          if (d.relatedPlantIds.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            const Divider(height: 1, color: Color(0xFFEDF2EE)),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Text(
                                  'Matching Plants:',
                                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: d.relatedPlantIds.map((plantId) {
                                        return Padding(
                                          padding: const EdgeInsets.only(right: 6),
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
                                            borderRadius: BorderRadius.circular(20),
                                            child: Container(
                                              padding: const EdgeInsets.fromLTRB(4, 3, 8, 3),
                                              decoration: BoxDecoration(
                                                color: isDark ? AppColors.surfaceSubtleDark : AppColors.lightMint,
                                                borderRadius: BorderRadius.circular(20),
                                                border: Border.all(
                                                  color: isDark ? AppColors.borderDark : AppColors.primarySubtle,
                                                  width: 0.8,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  PlantImage(
                                                    plantId: plantId,
                                                    width: 22,
                                                    height: 22,
                                                    borderRadius: BorderRadius.circular(11),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    _formatPlantId(plantId),
                                                    style: TextStyle(
                                                      fontSize: 11,
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
                  const SizedBox(height: 16),
                ],

                // Recommended Medicinal Plants
                if (searchVM.matchingPlants.isNotEmpty) ...[
                  Text(
                    'Botanical Species (${searchVM.matchingPlants.length})',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
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
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
