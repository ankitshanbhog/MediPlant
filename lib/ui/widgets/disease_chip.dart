import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class DiseaseChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  const DiseaseChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        avatar: icon != null
            ? Icon(
                icon,
                size: 17,
                color: isSelected
                    ? (isDark ? AppColors.primaryDark : Colors.white)
                    : (isDark ? AppColors.mint : AppColors.primary),
              )
            : null,
        backgroundColor: isDark ? AppColors.surfaceSubtleDark : AppColors.surfaceLight,
        selectedColor: isDark ? AppColors.primaryAccent : AppColors.primary,
        labelStyle: TextStyle(
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          color: isSelected
              ? (isDark ? AppColors.primaryDark : Colors.white)
              : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(
            color: isSelected
                ? Colors.transparent
                : (isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        showCheckmark: false,
      ),
    );
  }
}
