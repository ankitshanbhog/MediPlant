import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/database_helper.dart';
import '../../viewmodels/remedies_viewmodel.dart';
import '../theme/app_colors.dart';
import '../widgets/disease_chip.dart';
import '../widgets/remedy_card.dart';
import '../widgets/state_views.dart';
import 'plant_detail_screen.dart';

class RemediesScreen extends StatefulWidget {
  const RemediesScreen({super.key});

  @override
  State<RemediesScreen> createState() => _RemediesScreenState();
}

class _RemediesScreenState extends State<RemediesScreen> {
  // 0: All Remedies, 1: Saved Preparations
  int _selectedTabIndex = 0;

  static const List<String> _quickRemedyFilters = [
    'Cold',
    'Digestion',
    'Immunity',
    'Skin',
    'Tea',
    'Kadha',
    'Honey',
  ];

  @override
  Widget build(BuildContext context) {
    final remediesVM = context.watch<RemediesViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final displayedRemedies = _selectedTabIndex == 1
        ? remediesVM.remedies.where((r) => remediesVM.isBookmarked(r.id)).toList()
        : remediesVM.remedies;

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
                'Herbal Remedies',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.6,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Traditional botanical wellness preparations and recipes',
                style: TextStyle(
                  fontSize: 15,
                  height: 1.4,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight,
                ),
              ),
              const SizedBox(height: 20),

              // Search Bar
              TextField(
                onChanged: (value) => remediesVM.setSearchQuery(value),
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Search remedy (e.g. Honey, Kadha, Steam)...',
                  hintStyle: TextStyle(
                    fontSize: 15,
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    child: Icon(Icons.search_rounded, color: AppColors.primary, size: 24),
                  ),
                  prefixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                  suffixIcon: remediesVM.searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 20),
                          onPressed: () => remediesVM.setSearchQuery(''),
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

              // Quick Focus Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _quickRemedyFilters.map((term) {
                    final isSelected = remediesVM.searchQuery.toLowerCase() == term.toLowerCase();
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(
                        label: Text(term),
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
                            remediesVM.setSearchQuery('');
                          } else {
                            remediesVM.setSearchQuery(term);
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 18),

              // Dual-Segment Switcher: [ 🌿 All Remedies ] vs [ ⭐ Saved Recipes ]
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
                                  Icons.local_florist_rounded,
                                  size: 17,
                                  color: _selectedTabIndex == 0
                                      ? (isDark ? Colors.black : AppColors.primary)
                                      : (isDark ? Colors.grey[400] : Colors.grey[600]),
                                ),
                                const SizedBox(width: 7),
                                Text(
                                  'All Remedies (${remediesVM.remedies.length})',
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
                                  Icons.bookmark_rounded,
                                  size: 17,
                                  color: _selectedTabIndex == 1
                                      ? (isDark ? Colors.black : AppColors.amberHoney)
                                      : (isDark ? Colors.grey[400] : Colors.grey[600]),
                                ),
                                const SizedBox(width: 7),
                                Text(
                                  'Saved (${remediesVM.bookmarkedIds.length})',
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

              // Category Pills (When in All tab)
              if (_selectedTabIndex == 0) ...[
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: remediesVM.categories.map((cat) {
                      return DiseaseChip(
                        label: cat,
                        isSelected: remediesVM.selectedCategory == cat,
                        onTap: () => remediesVM.setCategory(cat),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 18),
              ],

              // Guidance Card
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceSubtleDark : AppColors.lightMint.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Traditional herbal recipes for minor ailments. Always consult a physician for persistent symptoms.',
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // Remedies Feed / Empty State
              if (displayedRemedies.isEmpty) ...[
                EmptyStateView(
                  icon: _selectedTabIndex == 1 ? Icons.bookmark_border_rounded : Icons.healing_outlined,
                  title: _selectedTabIndex == 1 ? 'No Saved Recipes' : 'No Remedies Found',
                  message: _selectedTabIndex == 1
                      ? 'Tap the bookmark icon on any recipe card to save it here for quick kitchen access.'
                      : 'Try searching for another term like "Honey", "Kadha", "Tulsi", or "Steam".',
                ),
              ] else ...[
                ...displayedRemedies.map((remedy) {
                  return RemedyCard(
                    remedy: remedy,
                    isBookmarked: remediesVM.isBookmarked(remedy.id),
                    onToggleBookmark: () => remediesVM.toggleBookmark(remedy.id),
                    onPlantTap: () async {
                      if (remedy.plantId != null) {
                        final matched = await DatabaseHelper.instance.getPlantById(remedy.plantId!);
                        if (matched != null && context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlantDetailScreen(plant: matched),
                            ),
                          );
                        }
                      }
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
