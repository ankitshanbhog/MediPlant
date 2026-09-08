import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Interactive visual gauge displaying recognition confidence and model source
class ConfidenceIndicator extends StatelessWidget {
  final double confidence; // 0.0 to 1.0
  final String sourceLabel;
  final bool isVerified;
  final bool isCompact;

  const ConfidenceIndicator({
    super.key,
    required this.confidence,
    required this.sourceLabel,
    this.isVerified = false,
    this.isCompact = false,
  });

  Color get _confidenceColor {
    if (confidence >= 0.85) return AppColors.confidenceHigh;
    if (confidence >= 0.65) return AppColors.warning;
    return AppColors.confidenceLow;
  }

  String get _confidenceLevelText {
    if (confidence >= 0.90) return 'High Confidence';
    if (confidence >= 0.75) return 'Good Match';
    if (confidence >= 0.60) return 'Moderate Match';
    return 'Low Confidence';
  }

  @override
  Widget build(BuildContext context) {
    final percent = (confidence * 100).toStringAsFixed(1);

    if (isCompact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _confidenceColor.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _confidenceColor.withOpacity(0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isVerified ? Icons.verified : Icons.analytics_outlined,
              size: 14,
              color: _confidenceColor,
            ),
            const SizedBox(width: 4),
            Text(
              '$percent%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: _confidenceColor,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _confidenceColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _confidenceColor.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _confidenceColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isVerified ? Icons.verified_user_rounded : Icons.psychology_rounded,
                  color: _confidenceColor,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _confidenceLevelText,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: _confidenceColor,
                      ),
                    ),
                    Text(
                      isVerified
                          ? 'Identification verified'
                          : (confidence >= 0.65
                              ? 'Identification complete'
                              : 'Cross-check recommended'),
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Text(
                '$percent%',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: _confidenceColor,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: confidence.clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: _confidenceColor.withOpacity(0.15),
              valueColor: AlwaysStoppedAnimation<Color>(_confidenceColor),
            ),
          ),
        ],
      ),
    );
  }
}
