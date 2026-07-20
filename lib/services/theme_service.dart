import 'package:supabase_flutter/supabase_flutter.dart';

class ThemeService {
  final SupabaseClient _supabase =
      Supabase.instance.client;

  Future<bool> loadDarkMode() async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      return true;
    }

    final response = await _supabase
        .from('theme_settings')
        .select('is_dark_mode')
        .eq('user_id', user.id)
        .maybeSingle();

    if (response == null) {
      return true;
    }

    return response['is_dark_mode'] ?? true;
  }

  Future<void> saveDarkMode(
    bool isDark,
  ) async {
    final user = _supabase.auth.currentUser;

    if (user == null) return;

    await _supabase
        .from('theme_settings')
        .upsert(
      {
        'user_id': user.id,
        'is_dark_mode': isDark,
      },
      onConflict: 'user_id',
    );
  }
}