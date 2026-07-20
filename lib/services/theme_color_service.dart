import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ThemeColorService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Load the saved theme for the current user.
  Future<int> loadSelectedThemeIndex() async {
    final User? user = _supabase.auth.currentUser;

    if (user == null) {
      return 0;
    }

    try {
      final Map<String, dynamic>? data = await _supabase
          .from('user_theme_settings')
          .select('theme_index')
          .eq('user_id', user.id)
          .maybeSingle();

      if (data == null) {
        return 0;
      }

      return data['theme_index'] as int? ?? 0;
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

    if (user == null) {
      throw Exception('User is not logged in.');
    }

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

  /// Get the complete theme record (optional helper).
  Future<Map<String, dynamic>?> getTheme() async {
    final User? user = _supabase.auth.currentUser;

    if (user == null) {
      return null;
    }

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

  /// Delete the user's saved theme (optional helper).
  Future<void> deleteTheme() async {
    final User? user = _supabase.auth.currentUser;

    if (user == null) return;

    try {
      await _supabase
          .from('user_theme_settings')
          .delete()
          .eq('user_id', user.id);
    } catch (e) {
      debugPrint('Delete Theme Error: $e');
    }
  }
}