import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode { light, dark }

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  AppThemeMode _themeMode = AppThemeMode.dark;

  AppThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == AppThemeMode.dark;
  bool get isLightMode => _themeMode == AppThemeMode.light;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey(_themeKey)) {
        final themeIndex = prefs.getInt(_themeKey)!;
        _themeMode = AppThemeMode.values[themeIndex];
      } else {
        _themeMode = AppThemeMode.dark;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading theme: $e');
      _themeMode = AppThemeMode.dark;
      notifyListeners();
    }
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, mode.index);
    } catch (e) {
      debugPrint('Error saving theme: $e');
    }
  }

  Future<void> toggleTheme() async {
    final newMode = _themeMode == AppThemeMode.dark
        ? AppThemeMode.light
        : AppThemeMode.dark;
    await setThemeMode(newMode);
  }
}
