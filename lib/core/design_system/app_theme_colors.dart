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
  Color get primaryLightMode => const Color(0xFF5627E8);

  Color get secondary =>
      isDark ? const Color(0xFF22D3EE) : const Color(0xFF0891B2);

  Color get secondaryLight =>
      isDark ? const Color(0xFF67E8F9) : const Color(0xFF0E7490);

  Color get secondaryDark => const Color(0xFF06B6D4);

  Color get success => const Color(0xFF10B981);
  Color get successLight => const Color(0xFF34D399);
  Color get successDark => const Color(0xFF059669);

  Color get warning =>
      isDark ? const Color(0xFFF59E0B) : const Color(0xFFD97706);

  Color get warningLight =>
      isDark ? const Color(0xFFFBBF24) : const Color(0xFFB45309);

  Color get error => const Color(0xFFEF4444);
  Color get errorLight => const Color(0xFFF87171);

  Color get background =>
      isDark ? const Color(0xFF0F0F23) : const Color(0xFFF5F0FF);

  Color get backgroundLight =>
      isDark ? const Color(0xFF1A1A2E) : const Color(0xFFFAF7FF);

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

  Color get completedGlow => const Color(0xFF10B981);
  Color get currentGlow => const Color(0xFF6366F1);
  Color get lockedGlow =>
      isDark ? const Color(0xFF27272A) : const Color(0xFFE8E0F0);

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
          colors: [Color(0xFFF5F0FF), Color(0xFFE8E0F5), Color(0xFFF0E8FA)],
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
          colors: [Color(0xFFFFFFFF), Color(0xFFF9F6FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

  Color get modalBackground =>
      isDark ? const Color(0xFFFFFFFF) : const Color(0xFF1A1A2E);

  Color get modalTextPrimary =>
      isDark ? const Color(0xFF1A0F2E) : const Color(0xFFFFFFFF);

  Color get modalTextSecondary =>
      isDark ? const Color(0xFF6B5B7A) : const Color(0xFFA1A1AA);
}
