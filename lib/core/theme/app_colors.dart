import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color secondaryBlue = Color(0xFF3B82F6);
  static const Color lightBlue = Color(0xFFDBEAFE);

  // Success Colors
  static const Color successGreen = Color(0xFF10B981);
  static const Color lightGreen = Color(0xFFD1FAE5);

  // Warning Colors
  static const Color warningOrange = Color(0xFFF59E0B);
  static const Color lightOrange = Color(0xFFFEF3C7);

  // Error Colors
  static const Color errorRed = Color(0xFFEF4444);
  static const Color lightRed = Color(0xFFFEE2E2);

  // Purple Colors
  static const Color purple = Color(0xFF8B5CF6);
  static const Color lightPurple = Color(0xFFEDE9FE);

  // Neutral Colors
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey900 = Color(0xFF111827);
  static const Color grey800 = Color(0xFF1F2937);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey50 = Color(0xFFF9FAFB);

  // Background Colors
  static const Color backgroundLight = Color(0xFFFAFBFC);
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E293B);

  // Text Colors
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textInverse = Color(0xFFFFFFFF);

  // Border Colors
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color borderMedium = Color(0xFFD1D5DB);
  static const Color borderDark = Color(0xFF9CA3AF);

  // Feature-specific Colors
  static const Color resumeBlue = Color(0xFF3B82F6);
  static const Color interviewGreen = Color(0xFF10B981);
  static const Color coverLetterOrange = Color(0xFFF59E0B);
  static const Color analyticsIndigo = Color(0xFF6366F1);
  static const Color premiumGold = Color(0xFFFFD700);

  // Gradient Colors
  static const List<Color> primaryGradient = [
    primaryBlue,
    secondaryBlue,
  ];

  static const List<Color> successGradient = [
    successGreen,
    Color(0xFF059669),
  ];

  static const List<Color> warningGradient = [
    warningOrange,
    Color(0xFFD97706),
  ];

  static const List<Color> premiumGradient = [
    Color(0xFFFFD700),
    Color(0xFFFFB347),
  ];

  // Status Colors
  static const Color statusActive = Color(0xFF10B981);
  static const Color statusInactive = Color(0xFF6B7280);
  static const Color statusPending = Color(0xFFF59E0B);
  static const Color statusError = Color(0xFFEF4444);

  // Rating Colors
  static const Color ratingExcellent = Color(0xFF10B981);
  static const Color ratingGood = Color(0xFF84CC16);
  static const Color ratingAverage = Color(0xFFF59E0B);
  static const Color ratingPoor = Color(0xFFEF4444);

  // Social Media Colors
  static const Color linkedin = Color(0xFF0A66C2);
  static const Color google = Color(0xFF4285F4);
  static const Color apple = Color(0xFF000000);
  static const Color facebook = Color(0xFF1877F2);
  static const Color twitter = Color(0xFF1DA1F2);

  // Helper methods
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  static Color lighten(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }

  static Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}