import 'package:flutter/material.dart';
import 'package:mini_fluency/core/providers/theme_provider.dart';

class AppThemeColors {
  final AppThemeMode themeMode;

  const AppThemeColors(this.themeMode);

  bool get isDark => themeMode == AppThemeMode.dark;
  bool get isLight => themeMode == AppThemeMode.light;

  // Fluency Brand Colors
  // Roxo: #5627E8
  Color get primary => isDark
      ? const Color(0xFF5627E8) // Fluency Purple
      : const Color(0xFF5627E8);

  Color get primaryLight => isDark
      ? const Color(0xFF7C5FED) // Lighter purple for dark mode
      : const Color(0xFF6B3FF5); // Slightly lighter for light mode

  Color get primaryDark => isDark
      ? const Color(0xFF4518D4) // Darker purple for dark mode
      : const Color(0xFF4518D4);

  Color get primaryLightMode => const Color(0xFF5627E8);

  // Azul Claro: #65BDE9
  Color get secondary =>
      isDark ? const Color(0xFF65BDE9) : const Color(0xFF4A9BC4);

  Color get secondaryLight =>
      isDark ? const Color(0xFF8DD4F0) : const Color(0xFF65BDE9);

  Color get secondaryDark =>
      isDark ? const Color(0xFF4A9BC4) : const Color(0xFF3A7FA3);

  // Verde Claro: #7BFFB4
  Color get success => isDark
      ? const Color(0xFF7BFFB4) // Fluency Light Green
      : const Color(0xFF5FE89A); // Slightly darker for light mode

  Color get successLight => isDark
      ? const Color(0xFF9EFFC8) // Lighter green for dark mode
      : const Color(0xFF7BFFB4); // Original for light mode

  Color get successDark => isDark
      ? const Color(0xFF5FE89A) // Darker green for dark mode
      : const Color(0xFF4BC97F); // Even darker for light mode

  // Amarelo: #F3B124
  Color get warning =>
      isDark ? const Color(0xFFF3B124) : const Color(0xFFE09A1A);

  Color get warningLight =>
      isDark ? const Color(0xFFF5C04A) : const Color(0xFFF3B124);

  // Vermelho: #FC4B33
  Color get error => isDark
      ? const Color(0xFFFC4B33) // Fluency Red
      : const Color(0xFFE6391F); // Slightly darker for light mode

  Color get errorLight => isDark
      ? const Color(0xFFFF6B5A) // Lighter red for dark mode
      : const Color(0xFFFC4B33); // Original for light mode

  // Background with subtle purple tint to complement Fluency brand
  Color get background =>
      isDark ? const Color(0xFF0F0A1F) : const Color(0xFFF8F5FF);

  Color get backgroundLight =>
      isDark ? const Color(0xFF1A1229) : const Color(0xFFFAF7FF);

  Color get surface =>
      isDark ? const Color(0xFF16213E) : const Color(0xFFFFFFFF);

  Color get surfaceLight =>
      isDark ? const Color(0xFF1F2937) : const Color(0xFFF9F6FF);

  Color get textPrimary =>
      isDark ? const Color(0xFFFFFFFF) : const Color(0xFF1A0F2E);

  Color get textSecondary =>
      isDark ? const Color(0xFFA1A1AA) : const Color(0xFF6B5B7A);

  Color get textMuted =>
      isDark ? const Color(0xFF71717A) : const Color(0xFF9E8FAE);

  Color get divider =>
      isDark ? const Color(0xFF27272A) : const Color(0xFFE8E0F0);

  Color get border =>
      isDark ? const Color(0xFF3F3F46) : const Color(0xFFD4C8E0);

  Color get locked =>
      isDark ? const Color(0xFF52525B) : const Color(0xFFB8A8C8);

  Color get lockedLight => isDark
      ? const Color(0xFF71717A)
      : const Color.fromARGB(255, 186, 178, 190);

  Color get completedGlow => success;
  Color get currentGlow => primary;
  Color get lockedGlow =>
      isDark ? const Color(0xFF27272A) : const Color(0xFFE8E0F0);

  // Gradient using Fluency brand colors: Purple to Light Blue
  LinearGradient get primaryGradient => LinearGradient(
        colors: isDark
            ? [primary, secondary] // Purple to Light Blue
            : [primary, secondaryLight], // Slightly adjusted for light mode
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  // Background gradient with Fluency purple tones
  LinearGradient get backgroundGradient => isDark
      ? LinearGradient(
          colors: [
            const Color(0xFF0F0A1F), // Dark purple-tinted background
            const Color(0xFF1A1229), // Slightly lighter purple-tinted
            const Color(0xFF1A0F2E), // Even lighter
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )
      : LinearGradient(
          colors: [
            const Color(0xFFF8F5FF), // Very light purple tint
            const Color(0xFFF0E8FA), // Light purple
            const Color(0xFFE8E0F5), // Slightly more purple
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );

  // Card gradient with subtle Fluency brand influence
  LinearGradient get cardGradient => isDark
      ? LinearGradient(
          colors: [
            const Color(0xFF1A1229), // Purple-tinted dark
            const Color(0xFF16213E), // Dark blue-purple
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
      : LinearGradient(
          colors: [
            const Color(0xFFFFFFFF), // Pure white
            const Color(0xFFF9F6FF), // Very light purple tint
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

  Color get modalBackground =>
      isDark ? const Color(0xFFFFFFFF) : const Color(0xFF1A1A2E);

  Color get modalTextPrimary =>
      isDark ? const Color(0xFF1A0F2E) : const Color(0xFFFFFFFF);

  Color get modalTextSecondary =>
      isDark ? const Color(0xFF6B5B7A) : const Color(0xFFA1A1AA);

  // Rosa Claro: #F38897 - Accent color for special highlights
  Color get accent => isDark
      ? const Color(0xFFF38897) // Fluency Light Pink
      : const Color(0xFFE87585); // Slightly darker for light mode

  Color get accentLight => isDark
      ? const Color(0xFFFFA5B3) // Lighter pink for dark mode
      : const Color(0xFFF38897); // Original for light mode

  Color get accentDark => isDark
      ? const Color(0xFFE87585) // Darker pink for dark mode
      : const Color(0xFFD96473); // Even darker for light mode
}
