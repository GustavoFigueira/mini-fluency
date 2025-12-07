import 'package:flutter/material.dart';

/// Fluency Academy color palette with a modern, vibrant aesthetic
abstract final class AppColors {
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);

  static const Color secondary = Color(0xFF22D3EE);
  static const Color secondaryLight = Color(0xFF67E8F9);
  static const Color secondaryDark = Color(0xFF06B6D4);

  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFF34D399);
  static const Color successDark = Color(0xFF059669);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFBBF24);

  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFF87171);

  static const Color background = Color(0xFF0F0F23);
  static const Color backgroundLight = Color(0xFF1A1A2E);
  static const Color surface = Color(0xFF16213E);
  static const Color surfaceLight = Color(0xFF1F2937);

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA1A1AA);
  static const Color textMuted = Color(0xFF71717A);

  static const Color divider = Color(0xFF27272A);
  static const Color border = Color(0xFF3F3F46);

  static const Color locked = Color(0xFF52525B);
  static const Color lockedLight = Color(0xFF71717A);

  static const Color completedGlow = Color(0xFF10B981);
  static const Color currentGlow = Color(0xFF6366F1);
  static const Color lockedGlow = Color(0xFF27272A);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [background, Color(0xFF1A1A3E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [surfaceLight, surface],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
