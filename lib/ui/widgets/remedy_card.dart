import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/remedy_model.dart';
import '../../viewmodels/voice_viewmodel.dart';
import '../theme/app_colors.dart';
import 'plant_image.dart';

/// Expandable Remedy Card with preparation steps, dosage, and voice read-aloud
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
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isThisSpeaking
              ? AppColors.primaryAccent
              : (isDark ? AppColors.borderDark : AppColors.borderLight),
          width: isThisSpeaking ? 1.5 : 1,
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
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (r.plantId != null && r.plantId!.isNotEmpty)
                      GestureDetector(
                        onTap: widget.onPlantTap,
                        child: Container(
                          margin: const EdgeInsets.only(right: 14),
                          child: PlantImage(
                            plantId: r.plantId!,
                            width: 58,
                            height: 58,
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  r.condition,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    visualDensity: VisualDensity.compact,
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: Icon(
                                      isThisSpeaking ? Icons.volume_up_rounded : Icons.volume_down_rounded,
                                      color: isThisSpeaking ? AppColors.primaryAccent : AppColors.textSecondaryLight,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      voiceVM.togglePlayPause(title: r.title, text: speechText);
                                    },
                                    tooltip: 'Listen to Remedy',
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    visualDensity: VisualDensity.compact,
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: Icon(
                                      widget.isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                                      color: widget.isBookmarked ? AppColors.amberHoney : AppColors.textSecondaryLight,
                                      size: 20,
                                    ),
                                    onPressed: widget.onToggleBookmark,
                                    tooltip: 'Save Remedy',
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            r.title,
                            style: const TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: widget.onPlantTap,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.eco_rounded, size: 13, color: AppColors.primaryLight),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    '${r.primaryPlantName} (${r.primaryPlantScientific})',
                                    style: TextStyle(
                                      fontSize: 12,
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
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceSubtleDark : AppColors.surfaceSubtleLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.timer_outlined, size: 13, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                          const SizedBox(width: 4),
                          Text(
                            r.timeToPrepare,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceSubtleDark : AppColors.surfaceSubtleLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.local_dining_outlined, size: 13, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                          const SizedBox(width: 4),
                          Text(
                            '${r.ingredients.length} items',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        visualDensity: VisualDensity.compact,
                      ),
                      onPressed: () => setState(() => _isExpanded = !_isExpanded),
                      icon: Icon(
                        _isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                        size: 18,
                      ),
                      label: Text(
                        _isExpanded ? 'Hide Steps' : 'View Recipe',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Expandable section
          if (_isExpanded) ...[
            const Divider(height: 1, color: AppColors.borderLight),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ingredients Required:',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  ...r.ingredients.map((ing) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                            Expanded(
                              child: Text(
                                ing,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 12),
                  const Text(
                    'Preparation Steps:',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  ...r.preparationSteps.asMap().entries.map((entry) {
                    final index = entry.key + 1;
                    final step = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '$index',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              step,
                              style: const TextStyle(fontSize: 13, height: 1.35),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceSubtleDark : AppColors.surfaceSubtleLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.info_outline, size: 14, color: AppColors.primary),
                            SizedBox(width: 6),
                            Text(
                              'How to Use & Dosage',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${r.howToUse} (${r.dosage})',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  if (r.precautions.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.warning.withOpacity(0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.warning_amber_rounded, size: 14, color: AppColors.warning),
                              SizedBox(width: 6),
                              Text(
                                'Precautions',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                  color: AppColors.warning,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          ...r.precautions.map((p) => Text('• $p', style: const TextStyle(fontSize: 11))),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],

          // Expand / Collapse Footer Button
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(18)),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceSubtleDark : AppColors.surfaceSubtleLight.withOpacity(0.5),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(18)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isExpanded ? 'Hide Preparation Details' : 'View Full Recipe & Steps',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.mint : AppColors.primary,
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    size: 16,
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
