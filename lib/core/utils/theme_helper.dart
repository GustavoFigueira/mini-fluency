import 'package:flutter/material.dart';
import 'package:mini_fluency/core/design_system/app_theme_colors.dart';
import 'package:mini_fluency/core/providers/theme_provider.dart';
import 'package:provider/provider.dart';

extension ThemeExtension on BuildContext {
  AppThemeColors get themeColors {
    final themeProvider = Provider.of<ThemeProvider>(this);
    return AppThemeColors(themeProvider.themeMode);
  }

  ThemeProvider get themeProvider => Provider.of<ThemeProvider>(this);
}
