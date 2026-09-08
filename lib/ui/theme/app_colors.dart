import 'package:flutter/material.dart';

/// Design tokens and nature-inspired color palette for MediPlant
class AppColors {
  AppColors._();

  // Primary Botanical Greens (More Vibrant)
  static const Color primaryDark = Color(0xFF004D40);
  static const Color primary = Color(0xFF00796B);
  static const Color primaryLight = Color(0xFF26A69A);
  static const Color primaryAccent = Color(0xFF1DE9B6);
  static const Color primarySubtle = Color(0xFFE0F2F1);

  // Mint & Sage Highlights
  static const Color sage = Color(0xFF80CBC4);
  static const Color mint = Color(0xFFB2DFDB);
  static const Color lightMint = Color(0xFFF1F8F6);

  // Warm & Vibrant Floral Accents (Adding variety)
  static const Color amberHoney = Color(0xFFFFB300);
  static const Color warmEarth = Color(0xFFFF7043);
  static const Color floralPink = Color(0xFFF06292);
  static const Color vibrantPurple = Color(0xFFAB47BC);
  static const Color amberLight = Color(0xFFFFF8E1);

  // Status & Confidence Colors
  static const Color confidenceHigh = Color(0xFF00C853);
  static const Color confidenceMedium = Color(0xFFFF9100);
  static const Color confidenceLow = Color(0xFFD50000);
  static const Color verifiedBadge = Color(0xFF2962FF);
  static const Color warning = Color(0xFFFFAB00);
  static const Color info = Color(0xFF00B0FF);

  // Neutral Colors (Light Theme)
  static const Color backgroundLight = Color(0xFFF9FAFA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceSubtleLight = Color(0xFFF0F4F4);
  static const Color textPrimaryLight = Color(0xFF263238);
  static const Color textSecondaryLight = Color(0xFF546E7A);
  static const Color textMutedLight = Color(0xFF90A4AE);
  static const Color borderLight = Color(0xFFCFD8DC);

  // Neutral Colors (Dark Theme)
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color surfaceSubtleDark = Color(0xFF2C2C2C);
  static const Color textPrimaryDark = Color(0xFFECEFF1);
  static const Color textSecondaryDark = Color(0xFFB0BEC5);
  static const Color textMutedDark = Color(0xFF78909C);
  static const Color borderDark = Color(0xFF37474F);

  // Gradients
  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF004D40), Color(0xFF00796B), Color(0xFF26A69A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFE0F2F1)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF1DE9B6), Color(0xFF26A69A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
