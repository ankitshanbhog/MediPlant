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
  bool _showOnlyBookmarked = false;

  @override
  Widget build(BuildContext context) {
    final remediesVM = context.watch<RemediesViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final displayedRemedies = _showOnlyBookmarked
        ? remediesVM.remedies.where((r) => remediesVM.isBookmarked(r.id)).toList()
        : remediesVM.remedies;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF7FAF8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Home Remedies',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.6,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Traditional botanical wellness preparations',
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.4,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.bookmark_rounded, size: 17, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Text(
                          '${remediesVM.bookmarkedIds.length} saved',
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              // Search Box
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
              const SizedBox(height: 18),

              // Category & Bookmark Filter Row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: FilterChip(
                        selected: _showOnlyBookmarked,
                        showCheckmark: false,
                        avatar: Icon(
                          _showOnlyBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                          size: 17,
                          color: _showOnlyBookmarked ? Colors.white : AppColors.primary,
                        ),
                        label: Text('Saved (${remediesVM.bookmarkedIds.length})'),
                        labelStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: _showOnlyBookmarked
                              ? Colors.white
                              : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                        ),
                        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
                        selectedColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                          side: BorderSide(
                            color: _showOnlyBookmarked
                                ? AppColors.primary
                                : (isDark ? AppColors.borderDark : AppColors.borderLight),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        onSelected: (selected) {
                          setState(() => _showOnlyBookmarked = selected);
                        },
                      ),
                    ),
                    ...remediesVM.categories.map((cat) {
                      return DiseaseChip(
                        label: cat,
                        isSelected: !_showOnlyBookmarked && remediesVM.selectedCategory == cat,
                        onTap: () {
                          if (_showOnlyBookmarked) {
                            setState(() => _showOnlyBookmarked = false);
                          }
                          remediesVM.setCategory(cat);
                        },
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Guidance Banner
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                        'Traditional preparations for minor ailments. Consult a physician if symptoms persist.',
                        style: TextStyle(
                          fontSize: 13.5,
                          height: 1.4,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Remedies List / Empty State
              if (displayedRemedies.isEmpty) ...[
                EmptyStateView(
                  icon: _showOnlyBookmarked ? Icons.bookmark_border_rounded : Icons.healing_outlined,
                  title: _showOnlyBookmarked ? 'No Saved Remedies' : 'No Remedies Found',
                  message: _showOnlyBookmarked
                      ? 'Tap the bookmark icon on any remedy card to save it here for quick access.'
                      : 'Try searching for another condition or ingredient like "Cinnamon", "Ashwagandha", or "Honey".',
                ),
              ] else ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _showOnlyBookmarked
                          ? 'Saved Remedies (${displayedRemedies.length})'
                          : 'Available Preparations (${displayedRemedies.length})',
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
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
