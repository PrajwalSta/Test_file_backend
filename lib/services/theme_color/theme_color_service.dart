import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ThemeColorService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Load the saved theme index for the current user.
  Future<int> loadSelectedThemeIndex() async {
    final User? user = _supabase.auth.currentUser;
    if (user == null) return 0;

    try {
      final Map<String, dynamic>? data = await _supabase
          .from('user_theme_settings')
          .select('theme_index')
          .eq('user_id', user.id)
          .maybeSingle();

      return data == null ? 0 : (data['theme_index'] as int? ?? 0);
    } catch (e) {
      debugPrint('Load Theme Error: $e');
      return 0;
    }
  }

  /// Save the selected theme for the current user.
  Future<void> saveSelectedTheme({
    required int themeIndex,
    required String themeName,
  }) async {
    final User? user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User is not logged in.');

    try {
      await _supabase.from('user_theme_settings').upsert(
        {
          'user_id': user.id,
          'theme_index': themeIndex,
          'theme_name': themeName,
          'updated_at': DateTime.now().toIso8601String(),
        },
        onConflict: 'user_id',
      );
    } catch (e) {
      debugPrint('Save Theme Error: $e');
      rethrow;
    }
  }

  /// Retrieve the theme record for the user.
  Future<Map<String, dynamic>?> getTheme() async {
    final User? user = _supabase.auth.currentUser;
    if (user == null) return null;

    try {
      return await _supabase
          .from('user_theme_settings')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();
    } catch (e) {
      debugPrint('Get Theme Error: $e');
      return null;
    }
  }

  Future<String?> getThemeColor() async {
    final Map<String, dynamic>? theme = await getTheme();
    if (theme == null) return null;

    return theme['theme_color'] as String?
        ?? theme['theme_name'] as String?;
  }

  /// Delete the user's saved theme.
  Future<void> deleteTheme() async {
    final User? user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      await _supabase.from('user_theme_settings').delete().eq('user_id', user.id);
    } catch (e) {
      debugPrint('Delete Theme Error: $e');
    }
  }

  /// Adapter to return theme settings keys expected by ThemeProvider.
  Future<Map<String, dynamic>> getThemeSettings() async {
    final Map<String, dynamic>? data = await getTheme();
    if (data == null) return <String, dynamic>{};

    return <String, dynamic>{
      'theme_mode': data['theme_mode'] as String? ?? 'dark',
      'theme_color': data['theme_color'] as String? ?? (data['theme_name'] as String? ?? 'purple'),
    };
  }

  /// Save theme color value (string/key).
  Future<void> saveThemeColor(String colorName) async {
    final User? user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User is not logged in.');

    try {
      await _supabase.from('user_theme_settings').upsert(
        {
          'user_id': user.id,
          'theme_color': colorName,
          'theme_name': colorName,
          'updated_at': DateTime.now().toIso8601String(),
        },
        onConflict: 'user_id',
      );
    } catch (e) {
      debugPrint('Save Theme Color Error: $e');
      rethrow;
    }
  }

  /// Save theme mode (e.g., 'light' or 'dark').
  Future<void> saveThemeMode(String mode) async {
    final User? user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User is not logged in.');

    try {
      await _supabase.from('user_theme_settings').upsert(
        {
          'user_id': user.id,
          'theme_mode': mode,
          'updated_at': DateTime.now().toIso8601String(),
        },
        onConflict: 'user_id',
      );
    } catch (e) {
      debugPrint('Save Theme Mode Error: $e');
      rethrow;
    }
  }
}