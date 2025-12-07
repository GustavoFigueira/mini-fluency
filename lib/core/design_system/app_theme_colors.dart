import 'package:flutter/material.dart';
import 'package:mini_fluency/core/providers/theme_provider.dart';

class AppThemeColors {
  final AppThemeMode themeMode;

  const AppThemeColors(this.themeMode);

  bool get isDark => themeMode == AppThemeMode.dark;
  bool get isLight => themeMode == AppThemeMode.light;

  Color get primary => const Color(0xFF6366F1);
  Color get primaryLight => const Color(0xFF818CF8);
  Color get primaryDark => const Color(0xFF4F46E5);

  Color get secondary => const Color(0xFF22D3EE);
  Color get secondaryLight => const Color(0xFF67E8F9);
  Color get secondaryDark => const Color(0xFF06B6D4);

  Color get success => const Color(0xFF10B981);
  Color get successLight => const Color(0xFF34D399);
  Color get successDark => const Color(0xFF059669);

  Color get warning => const Color(0xFFF59E0B);
  Color get warningLight => const Color(0xFFFBBF24);

  Color get error => const Color(0xFFEF4444);
  Color get errorLight => const Color(0xFFF87171);

  Color get background => isDark
      ? const Color(0xFF0F0F23)
      : const Color(0xFFFFFFFF);

  Color get backgroundLight => isDark
      ? const Color(0xFF1A1A2E)
      : const Color(0xFFF5F5F5);

  Color get surface => isDark
      ? const Color(0xFF16213E)
      : const Color(0xFFFFFFFF);

  Color get surfaceLight => isDark
      ? const Color(0xFF1F2937)
      : const Color(0xFFF9F9F9);

  Color get textPrimary => isDark
      ? const Color(0xFFFFFFFF)
      : const Color(0xFF000000);

  Color get textSecondary => isDark
      ? const Color(0xFFA1A1AA)
      : const Color(0xFF525252);

  Color get textMuted => isDark
      ? const Color(0xFF71717A)
      : const Color(0xFF9E9E9E);

  Color get divider => isDark
      ? const Color(0xFF27272A)
      : const Color(0xFFE5E5E5);

  Color get border => isDark
      ? const Color(0xFF3F3F46)
      : const Color(0xFFD4D4D4);

  Color get locked => isDark
      ? const Color(0xFF52525B)
      : const Color(0xFF9E9E9E);

  Color get lockedLight => isDark
      ? const Color(0xFF71717A)
      : const Color(0xFFB0B0B0);

  Color get completedGlow => const Color(0xFF10B981);
  Color get currentGlow => const Color(0xFF6366F1);
  Color get lockedGlow => isDark
      ? const Color(0xFF27272A)
      : const Color(0xFFE5E5E5);

  LinearGradient get primaryGradient => const LinearGradient(
        colors: [Color(0xFF6366F1), Color(0xFF22D3EE)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  LinearGradient get backgroundGradient => isDark
      ? const LinearGradient(
          colors: [Color(0xFF0F0F23), Color(0xFF1A1A3E)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )
      : const LinearGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFFF5F5F5)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );

  LinearGradient get cardGradient => isDark
      ? const LinearGradient(
          colors: [Color(0xFF1F2937), Color(0xFF16213E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
      : const LinearGradient(
          colors: [Color(0xFFF9F9F9), Color(0xFFFFFFFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

  Color get modalBackground => isDark
      ? const Color(0xFF16213E)
      : const Color(0xFF1A1A2E);

  Color get modalTextPrimary => isDark
      ? const Color(0xFFFFFFFF)
      : const Color(0xFFFFFFFF);

  Color get modalTextSecondary => isDark
      ? const Color(0xFFA1A1AA)
      : const Color(0xFFA1A1AA);
}

