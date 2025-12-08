import 'package:flutter/material.dart';

/// Fluency Academy color palette with brand colors
/// Roxo: #5627E8, Vermelho: #FC4B33, Verde Claro: #7BFFB4
/// Amarelo: #F3B124, Rosa Claro: #F38897, Azul Claro: #65BDE9
abstract final class AppColors {
  // Fluency Brand Purple: #5627E8
  static const Color primary = Color(0xFF5627E8);
  static const Color primaryLight = Color(0xFF7C5FED);
  static const Color primaryDark = Color(0xFF4518D4);

  // Fluency Brand Light Blue: #65BDE9
  static const Color secondary = Color(0xFF65BDE9);
  static const Color secondaryLight = Color(0xFF8DD4F0);
  static const Color secondaryDark = Color(0xFF4A9BC4);

  // Fluency Brand Light Green: #7BFFB4
  static const Color success = Color(0xFF7BFFB4);
  static const Color successLight = Color(0xFF9EFFC8);
  static const Color successDark = Color(0xFF5FE89A);

  // Fluency Brand Yellow: #F3B124
  static const Color warning = Color(0xFFF3B124);
  static const Color warningLight = Color(0xFFF5C04A);

  // Fluency Brand Red: #FC4B33
  static const Color error = Color(0xFFFC4B33);
  static const Color errorLight = Color(0xFFFF6B5A);

  // Fluency Brand Light Pink: #F38897
  static const Color accent = Color(0xFFF38897);
  static const Color accentLight = Color(0xFFFFA5B3);
  static const Color accentDark = Color(0xFFE87585);

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

  static const Color completedGlow = success;
  static const Color currentGlow = primary;
  static const Color lockedGlow = Color(0xFF27272A);

  // Gradient using Fluency brand colors: Purple to Light Blue
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
