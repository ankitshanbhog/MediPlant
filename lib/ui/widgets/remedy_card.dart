import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/remedy_model.dart';
import '../../viewmodels/voice_viewmodel.dart';
import '../theme/app_colors.dart';
import 'plant_image.dart';

class RemedyCard extends StatelessWidget {
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

  void _openRecipeDossier(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _RecipeDossierSheet(
        remedy: remedy,
        isBookmarked: isBookmarked,
        onToggleBookmark: onToggleBookmark,
        onPlantTap: onPlantTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = remedy;
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
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isThisSpeaking
              ? AppColors.primaryAccent
              : (isDark ? AppColors.borderDark : const Color(0xFFE5ECE7)),
          width: isThisSpeaking ? 1.8 : 1,
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
        onTap: () => _openRecipeDossier(context),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top action bar: Condition badge + audio & bookmark buttons
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      r.condition,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const Spacer(),
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
                    tooltip: 'Listen to Recipe',
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                      color: isBookmarked ? AppColors.amberHoney : AppColors.textSecondaryLight,
                      size: 22,
                    ),
                    onPressed: onToggleBookmark,
                    tooltip: 'Save Recipe',
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Middle: Plant Thumbnail + Title + Plant Scientific Name
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (r.plantId != null && r.plantId!.isNotEmpty)
                    GestureDetector(
                      onTap: onPlantTap,
                      child: Container(
                        margin: const EdgeInsets.only(right: 14),
                        child: PlantImage(
                          plantId: r.plantId!,
                          width: 66,
                          height: 66,
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
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 5),
                        GestureDetector(
                          onTap: onPlantTap,
                          child: Row(
                            children: [
                              const Icon(Icons.eco_rounded, size: 14, color: AppColors.primaryLight),
                              const SizedBox(width: 4),
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

              // Bottom Info Bar: Time + Ingredients count + "View Recipe →"
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceSubtleDark : AppColors.surfaceSubtleLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 14,
                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          r.timeToPrepare,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceSubtleDark : AppColors.surfaceSubtleLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 14,
                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${r.ingredients.length} items',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View Recipe',
                        style: TextStyle(
                          fontSize: 13.5,
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
  }
}

// ── Dedicated Recipe Dossier Modal Sheet ──
class _RecipeDossierSheet extends StatefulWidget {
  final Remedy remedy;
  final bool isBookmarked;
  final VoidCallback onToggleBookmark;
  final VoidCallback? onPlantTap;

  const _RecipeDossierSheet({
    required this.remedy,
    required this.isBookmarked,
    required this.onToggleBookmark,
    this.onPlantTap,
  });

  @override
  State<_RecipeDossierSheet> createState() => _RecipeDossierSheetState();
}

class _RecipeDossierSheetState extends State<_RecipeDossierSheet> {
  final Set<int> _checkedIngredients = {};

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
              // Sheet Drag Handle
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
                  padding: const EdgeInsets.fromLTRB(22, 8, 22, 32),
                  children: [
                    // Top header: Condition & Close
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            r.condition,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, size: 24),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Title
                    Text(
                      r.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.4,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Plant Banner
                    if (r.plantId != null && r.plantId!.isNotEmpty)
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          widget.onPlantTap?.call();
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.surfaceDark : const Color(0xFFF2F7F4),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark ? AppColors.borderDark : const Color(0xFFE2EBE5),
                            ),
                          ),
                          child: Row(
                            children: [
                              PlantImage(
                                plantId: r.plantId!,
                                width: 44,
                                height: 44,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      r.primaryPlantName,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Text(
                                      r.primaryPlantScientific,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontStyle: FontStyle.italic,
                                        color: isDark ? AppColors.mint : AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.primary),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),

                    // Quick Meta Row & Actions
                    Row(
                      children: [
                        _DossierMeta(
                          icon: Icons.timer_outlined,
                          title: 'Prep Time',
                          value: r.timeToPrepare,
                          isDark: isDark,
                        ),
                        const SizedBox(width: 10),
                        _DossierMeta(
                          icon: Icons.local_dining_outlined,
                          title: 'Ingredients',
                          value: '${r.ingredients.length} items',
                          isDark: isDark,
                        ),
                        const Spacer(),
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
                            voiceVM.togglePlayPause(title: r.title, text: speechText);
                          },
                          tooltip: 'Listen to Guide',
                        ),
                        const SizedBox(width: 8),
                        IconButton.filledTonal(
                          style: IconButton.styleFrom(
                            backgroundColor: widget.isBookmarked
                                ? AppColors.amberHoney.withOpacity(0.2)
                                : (isDark ? AppColors.surfaceSubtleDark : const Color(0xFFF5F5F5)),
                          ),
                          icon: Icon(
                            widget.isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                            color: widget.isBookmarked ? AppColors.amberHoney : Colors.grey,
                            size: 22,
                          ),
                          onPressed: widget.onToggleBookmark,
                          tooltip: 'Save',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Section 1: Interactive Ingredients Checklist
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Ingredients Checklist',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.2,
                          ),
                        ),
                        Text(
                          '${_checkedIngredients.length}/${r.ingredients.length} ready',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.mint : AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...r.ingredients.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final ing = entry.value;
                      final isChecked = _checkedIngredients.contains(idx);

                      return InkWell(
                        onTap: () {
                          setState(() {
                            if (isChecked) {
                              _checkedIngredients.remove(idx);
                            } else {
                              _checkedIngredients.add(idx);
                            }
                          });
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: isChecked
                                ? (isDark ? AppColors.primary.withOpacity(0.12) : AppColors.lightMint)
                                : (isDark ? AppColors.surfaceDark : const Color(0xFFFBFDFB)),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isChecked
                                  ? AppColors.primary
                                  : (isDark ? AppColors.borderDark : const Color(0xFFE8EFEA)),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isChecked ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                                color: isChecked ? AppColors.primary : Colors.grey[400],
                                size: 22,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  ing,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: isChecked ? FontWeight.w600 : FontWeight.w500,
                                    decoration: isChecked ? TextDecoration.lineThrough : null,
                                    color: isChecked
                                        ? (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)
                                        : null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 24),

                    // Section 2: Step-by-Step Preparation
                    const Text(
                      'Preparation Steps',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...r.preparationSteps.asMap().entries.map((entry) {
                      final index = entry.key + 1;
                      final step = entry.value;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surfaceDark : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark ? AppColors.borderDark : const Color(0xFFE7EFEA),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '$index',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                step,
                                style: const TextStyle(fontSize: 15.5, height: 1.5),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 20),

                    // Section 3: Usage & Dosage Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceSubtleDark : const Color(0xFFF3F9F5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? AppColors.borderDark : const Color(0xFFD6EAE0),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.access_time_filled_rounded, size: 18, color: AppColors.primary),
                              SizedBox(width: 8),
                              Text(
                                'Recommended Intake & Dosage',
                                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'How to Use: ${r.howToUse}',
                            style: const TextStyle(fontSize: 14.5, height: 1.45),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Dosage: ${r.dosage}',
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Section 4: Safety & Precautions
                    if (r.precautions.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.warning.withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.warning_amber_rounded, size: 20, color: AppColors.warning),
                                SizedBox(width: 8),
                                Text(
                                  'Safety Precautions',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                    color: AppColors.warning,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ...r.precautions.map((p) => Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('⚠️ ', style: TextStyle(fontSize: 12)),
                                      Expanded(
                                        child: Text(
                                          p,
                                          style: const TextStyle(fontSize: 14, height: 1.4),
                                        ),
                                      ),
                                    ],
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
          ),
        );
      },
    );
  }
}

class _DossierMeta extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool isDark;

  const _DossierMeta({
    required this.icon,
    required this.title,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceSubtleDark : AppColors.surfaceSubtleLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 10.5,
                  color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
