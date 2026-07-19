import 'package:supabase_flutter/supabase_flutter.dart';

class ThemeSettingService {
  final SupabaseClient _supabase =
      Supabase.instance.client;

  Future<void> saveThemeSettings({
    required String themeColor,
    required bool darkMode,
  }) async {
    final User? user =
        _supabase.auth.currentUser;

    if (user == null) {
      throw Exception(
        'User is not logged in.',
      );
    }

    await _supabase
        .from('user_theme_settings')
        .upsert(
      {
        'user_id': user.id,
        'theme_color': themeColor,
        'dark_mode': darkMode,
        'updated_at':
            DateTime.now().toIso8601String(),
      },
      onConflict: 'user_id',
    );
  }

  Future<Map<String, dynamic>?>
      getThemeSettings() async {
    final User? user =
        _supabase.auth.currentUser;

    if (user == null) {
      return null;
    }

    final Map<String, dynamic>? response =
        await _supabase
            .from('user_theme_settings')
            .select()
            .eq('user_id', user.id)
            .maybeSingle();

    return response;
  }
}