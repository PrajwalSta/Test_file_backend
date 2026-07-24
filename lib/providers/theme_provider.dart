import 'package:flutter/material.dart';

import '../../services/theme_color/theme_color_service.dart';
import '../../services/theme_color/theme_service.dart';

class ThemeProvider extends ChangeNotifier {
  final ThemeService _themeService =
      ThemeService();

  final ThemeColorService _themeColorService =
      ThemeColorService();

  ThemeMode _themeMode =
      ThemeMode.dark;

  String _selectedThemeColor =
      'purple';

  bool _isLoading = false;

  ThemeMode get themeMode =>
      _themeMode;

  bool get isDarkMode =>
      _themeMode == ThemeMode.dark;

  bool get isLoading =>
      _isLoading;

  String get selectedThemeColor =>
      _selectedThemeColor;

  /// Main theme colour.
  ///
  /// Use with:
  /// Theme.of(context).colorScheme.primary
  Color get primaryColor {
    switch (_selectedThemeColor) {
      case 'ocean':
        return const Color(
          0xff20C8F6,
        );

      case 'sunset':
        return const Color(
          0xffFF6B6B,
        );

      case 'forest':
        return const Color(
          0xff2ECC71,
        );

      case 'rose':
        return const Color(
          0xffFF4D8D,
        );

      case 'gold':
        return const Color(
          0xffF5B942,
        );

      case 'purple':
      default:
        return const Color(
          0xff7B61FF,
        );
    }
  }

  /// Supporting theme colour.
  ///
  /// Use with:
  /// Theme.of(context).colorScheme.secondary
  Color get secondaryColor {
    switch (_selectedThemeColor) {
      case 'ocean':
        return const Color(
          0xff0A84FF,
        );

      case 'sunset':
        return const Color(
          0xffFF9F43,
        );

      case 'forest':
        return const Color(
          0xff20C997,
        );

      case 'rose':
        return const Color(
          0xffC850C0,
        );

      case 'gold':
        return const Color(
          0xffFF8C00,
        );

      case 'purple':
      default:
        return const Color(
          0xff20C8F6,
        );
    }
  }

  /// Text/icons placed on the primary colour.
  Color get onPrimaryColor {
    return _contrastColor(
      primaryColor,
    );
  }

  /// Text/icons placed on the secondary colour.
  Color get onSecondaryColor {
    return _contrastColor(
      secondaryColor,
    );
  }

  /// Gradient using the selected primary
  /// and secondary colors.
  LinearGradient get themeGradient {
    return LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: <Color>[
        primaryColor,
        secondaryColor,
      ],
    );
  }

  /// Loads dark/light mode and selected
  /// theme colour from storage/backend.
  Future<void> loadThemeSettings() async {
    _isLoading = true;
    notifyListeners();

    try {
      final ThemeMode? savedThemeMode =
          await _themeService
              .getThemeMode();

      final String? savedThemeColor =
          await _themeColorService
              .getThemeColor();

      _themeMode =
          savedThemeMode ??
          ThemeMode.dark;

      _selectedThemeColor =
          _validateThemeColor(
        savedThemeColor,
      );
    } catch (error) {
      debugPrint(
        'Failed to load theme settings: $error',
      );

      _themeMode =
          ThemeMode.dark;

      _selectedThemeColor =
          'purple';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Alias for existing code that calls
  /// loadTheme().
  Future<void> loadTheme() async {
    await loadThemeSettings();
  }

  /// Changes the selected colour preset
  /// and saves it.
  Future<void> changeThemeColor(
    String colorName,
  ) async {
    final String newColor =
        _validateThemeColor(
      colorName,
    );

    if (newColor ==
        _selectedThemeColor) {
      return;
    }

    final String previousColor =
        _selectedThemeColor;

    _selectedThemeColor =
        newColor;

    notifyListeners();

    try {
      await _themeColorService
          .saveThemeColor(
        newColor,
      );
    } catch (error) {
      // Restore the previous colour when
      // saving fails.
      _selectedThemeColor =
          previousColor;

      notifyListeners();

      debugPrint(
        'Failed to save theme colour: $error',
      );

      rethrow;
    }
  }

  /// Changes dark/light mode and saves it.
  Future<void> toggleTheme(
    bool useDarkMode,
  ) async {
    final ThemeMode newMode =
        useDarkMode
            ? ThemeMode.dark
            : ThemeMode.light;

    if (newMode == _themeMode) {
      return;
    }

    final ThemeMode previousMode =
        _themeMode;

    _themeMode =
        newMode;

    notifyListeners();

    try {
      await _themeService
          .saveThemeMode(
        newMode,
      );
    } catch (error) {
      _themeMode =
          previousMode;

      notifyListeners();

      debugPrint(
        'Failed to save theme mode: $error',
      );

      rethrow;
    }
  }

  /// Restores the original app design:
  /// dark mode + purple/cyan colors.
  Future<void> resetToOriginalTheme() async {
    final ThemeMode previousMode =
        _themeMode;

    final String previousColor =
        _selectedThemeColor;

    _themeMode =
        ThemeMode.dark;

    _selectedThemeColor =
        'purple';

    notifyListeners();

    try {
      await _themeService
          .saveThemeMode(
        ThemeMode.dark,
      );

      await _themeColorService
          .saveThemeColor(
        'purple',
      );
    } catch (error) {
      _themeMode =
          previousMode;

      _selectedThemeColor =
          previousColor;

      notifyListeners();

      debugPrint(
        'Failed to reset theme: $error',
      );

      rethrow;
    }
  }

  /// Alias for existing code that calls
  /// resetTheme().
  Future<void> resetTheme() async {
    await resetToOriginalTheme();
  }

  /// Prevents unsupported values from
  /// being saved or loaded.
  String _validateThemeColor(
    String? colorName,
  ) {
    const Set<String> allowedColors =
        <String>{
      'purple',
      'ocean',
      'sunset',
      'forest',
      'rose',
      'gold',
    };

    final String value =
        colorName
            ?.trim()
            .toLowerCase() ??
        'purple';

    if (allowedColors.contains(
      value,
    )) {
      return value;
    }

    return 'purple';
  }

  /// Automatically chooses readable
  /// black or white text.
  Color _contrastColor(
    Color backgroundColor,
  ) {
    return ThemeData
                .estimateBrightnessForColor(
              backgroundColor,
            ) ==
            Brightness.dark
        ? Colors.white
        : Colors.black;
  }
}