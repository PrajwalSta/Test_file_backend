import 'package:flutter/material.dart';

import '../../services/theme_service.dart';

class ThemeProvider extends ChangeNotifier {
  final ThemeService _themeService = ThemeService();

  ThemeMode _themeMode = ThemeMode.dark;
  bool _isLoading = false;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  bool get isLoading => _isLoading;

  Future<void> loadTheme() async {
    _isLoading = true;
    notifyListeners();

    final bool isDark =
        await _themeService.loadDarkMode();

    _themeMode =
        isDark ? ThemeMode.dark : ThemeMode.light;

    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleTheme(
    bool isDark,
  ) async {
    _themeMode =
        isDark ? ThemeMode.dark : ThemeMode.light;

    notifyListeners();

    await _themeService.saveDarkMode(
      isDark,
    );
  }

  void resetTheme() {
    _themeMode = ThemeMode.dark;
    notifyListeners();
  }
}