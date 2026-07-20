import 'package:supabase_flutter/supabase_flutter.dart';

class LanguageService {
  final SupabaseClient _supabase =
      Supabase.instance.client;

  Future<String> loadLanguageCode() async {
    final User? user =
        _supabase.auth.currentUser;

    if (user == null) {
      return 'en';
    }

    final Map<String, dynamic>? response =
        await _supabase
            .from('language_settings')
            .select('language_code')
            .eq('user_id', user.id)
            .maybeSingle();

    return response?['language_code']
            as String? ??
        'en';
  }

  Future<void> saveLanguageCode(
    String languageCode,
  ) async {
    final User? user =
        _supabase.auth.currentUser;

    if (user == null) {
      throw Exception(
        'User is not logged in.',
      );
    }

    await _supabase
        .from('language_settings')
        .upsert(
      {
        'user_id': user.id,
        'language_code': languageCode,
        'updated_at': DateTime.now()
            .toUtc()
            .toIso8601String(),
      },
      onConflict: 'user_id',
    );
  }
}