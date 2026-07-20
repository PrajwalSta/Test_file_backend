import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _languageKey =
      'selected_language_code';

  static const List<String> supportedLanguageCodes = [
    'en',
    'ne',
    'hi',
  ];

  Locale _locale = const Locale('en');

  bool _isLoaded = false;

  Locale get locale => _locale;

  String get languageCode => _locale.languageCode;

  bool get isLoaded => _isLoaded;

  Future<void> loadSavedLanguage() async {
    try {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();

      final String savedLanguageCode =
          preferences.getString(_languageKey) ?? 'en';

      if (supportedLanguageCodes.contains(
        savedLanguageCode,
      )) {
        _locale = Locale(savedLanguageCode);
      } else {
        _locale = const Locale('en');
      }
    } catch (error) {
      debugPrint(
        'Unable to load saved language: $error',
      );

      _locale = const Locale('en');
    }

    _isLoaded = true;
    notifyListeners();
  }

  Future<void> changeLanguage(
    String languageCode,
  ) async {
    if (!supportedLanguageCodes.contains(
      languageCode,
    )) {
      return;
    }

    if (_locale.languageCode == languageCode) {
      return;
    }

    _locale = Locale(languageCode);
    notifyListeners();

    try {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();

      await preferences.setString(
        _languageKey,
        languageCode,
      );
    } catch (error) {
      debugPrint(
        'Unable to save selected language: $error',
      );
    }
  }

  Future<void> resetLanguage() async {
    _locale = const Locale('en');
    notifyListeners();

    try {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();

      await preferences.remove(_languageKey);
    } catch (error) {
      debugPrint(
        'Unable to reset language: $error',
      );
    }
  }
}