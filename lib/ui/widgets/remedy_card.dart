import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/remedy_model.dart';
import '../../viewmodels/voice_viewmodel.dart';
import '../theme/app_colors.dart';
import 'plant_image.dart';

class RemedyCard extends StatefulWidget {
  final Remedy remedy;
  final bool isBookmarked;
  final VoidCallback onToggleBookmark;
  final VoidCallback? onPlantTap;

  const RemedyCard({
    super.key,
    required this.remedy,
    required this.isBookmarked,
    required this.onToggleBookmark,
    this.onPlantTap,
  });

  @override
  State<RemedyCard> createState() => _RemedyCardState();
}

class _RemedyCardState extends State<RemedyCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final r = widget.remedy;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final voiceVM = context.watch<VoiceViewModel>();
    final isThisSpeaking = voiceVM.isPlaying && voiceVM.currentNarrationTitle == r.title;

    final speechText =
        'Home remedy for ${r.condition}: ${r.title}. Primary plant: ${r.primaryPlantName}. '
        'Ingredients needed: ${r.ingredients.join(', ')}. '
        'Preparation: ${r.preparationSteps.join('. ')}. '
        'How to use: ${r.howToUse}. Dosage: ${r.dosage}. '
        'Precautions: ${r.precautions.join('. ')}.';

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isThisSpeaking
              ? AppColors.primaryAccent
              : (isDark ? AppColors.borderDark : AppColors.borderLight),
          width: isThisSpeaking ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Card Header ──
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Top row: condition pill + action icons
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          r.condition,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        isThisSpeaking ? Icons.volume_up_rounded : Icons.volume_down_rounded,
                        color: isThisSpeaking ? AppColors.primaryAccent : AppColors.textSecondaryLight,
                        size: 22,
                      ),
                      onPressed: () {
                        voiceVM.togglePlayPause(title: r.title, text: speechText);
                      },
                      tooltip: 'Listen to Remedy',
                    ),
                    const SizedBox(width: 6),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        widget.isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                        color: widget.isBookmarked ? AppColors.amberHoney : AppColors.textSecondaryLight,
                        size: 22,
                      ),
                      onPressed: widget.onToggleBookmark,
                      tooltip: 'Save Remedy',
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Plant image + title + plant name
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (r.plantId != null && r.plantId!.isNotEmpty)
                      GestureDetector(
                        onTap: widget.onPlantTap,
                        child: Container(
                          margin: const EdgeInsets.only(right: 16),
                          child: PlantImage(
                            plantId: r.plantId!,
                            width: 68,
                            height: 68,
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            r.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          GestureDetector(
                            onTap: widget.onPlantTap,
                            child: Row(
                              children: [
                                const Icon(Icons.eco_rounded, size: 14, color: AppColors.primaryLight),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    '${r.primaryPlantName} (${r.primaryPlantScientific})',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? AppColors.mint : AppColors.primary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
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

                const SizedBox(height: 16),

                // Meta badges + View Recipe button
                Row(
                  children: [
                    _MetaBadge(
                      icon: Icons.timer_outlined,
                      label: r.timeToPrepare,
                      isDark: isDark,
                    ),
                    const SizedBox(width: 10),
                    _MetaBadge(
                      icon: Icons.local_dining_outlined,
                      label: '${r.ingredients.length} items',
                      isDark: isDark,
                    ),
                    const Spacer(),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        visualDensity: VisualDensity.compact,
                      ),
                      onPressed: () => setState(() => _isExpanded = !_isExpanded),
                      icon: Icon(
                        _isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                        size: 20,
                      ),
                      label: Text(
                        _isExpanded ? 'Hide Steps' : 'View Recipe',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),
              ],
            ),
          ),

          // ── Expanded Detail Section ──
          if (_isExpanded) ...[
            const Divider(height: 1, color: AppColors.borderLight),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Ingredients
                  const Text(
                    'Ingredients Required',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                  const SizedBox(height: 10),
                  ...r.ingredients.map((ing) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 2),
                              child: Text('• ', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
                            ),
                            Expanded(
                              child: Text(
                                ing,
                                style: const TextStyle(fontSize: 15, height: 1.4),
                              ),
                            ),
                          ],
                        ),
                      )),

                  const SizedBox(height: 18),

                  // Preparation Steps
                  const Text(
                    'Preparation Steps',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                  const SizedBox(height: 10),
                  ...r.preparationSteps.asMap().entries.map((entry) {
                    final index = entry.key + 1;
                    final step = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '$index',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              step,
                              style: const TextStyle(fontSize: 15, height: 1.5),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 14),

                  // How to Use & Dosage
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceSubtleDark : AppColors.surfaceSubtleLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.info_outline, size: 16, color: AppColors.primary),
                            SizedBox(width: 8),
                            Text(
                              'How to Use & Dosage',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${r.howToUse} (${r.dosage})',
                          style: const TextStyle(fontSize: 14, height: 1.5),
                        ),
                      ],
                    ),
                  ),

                  if (r.precautions.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.warning.withOpacity(0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.warning_amber_rounded, size: 16, color: AppColors.warning),
                              SizedBox(width: 8),
                              Text(
                                'Precautions',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: AppColors.warning,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...r.precautions.map((p) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  '• $p',
                                  style: const TextStyle(fontSize: 13, height: 1.4),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],

          // ── Expand / Collapse Bottom Bar ──
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceSubtleDark : AppColors.surfaceSubtleLight.withOpacity(0.5),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isExpanded ? 'Hide Preparation Details' : 'View Full Recipe & Steps',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.mint : AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: isDark ? AppColors.mint : AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Private helper widget for meta badges ──
class _MetaBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;

  const _MetaBadge({required this.icon, required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceSubtleDark : AppColors.surfaceSubtleLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
