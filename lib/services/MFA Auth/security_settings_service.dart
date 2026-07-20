import 'package:supabase_flutter/supabase_flutter.dart';

class SecuritySettingsService {
  final SupabaseClient _supabase =
      Supabase.instance.client;

  Future<Map<String, dynamic>> getSettings() async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      return {};
    }

    final response = await _supabase
        .from('user_security_settings')
        .select()
        .eq('user_id', user.id)
        .maybeSingle();

    if (response == null) {
      await _supabase
          .from('user_security_settings')
          .insert({
        'user_id': user.id,
      });

      return {
        'two_factor_enabled': false,
        'biometric_enabled': false,
        'activity_log_enabled': false,
        'data_sharing_enabled': false,
      };
    }

    return response;
  }

  Future<void> updateTwoFactor(
    bool enabled,
  ) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      return;
    }

    await _supabase
        .from('user_security_settings')
        .update({
      'two_factor_enabled': enabled,
    }).eq('user_id', user.id);
  }

  Future<void> updateBiometric(
    bool enabled,
  ) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      return;
    }

    await _supabase
        .from('user_security_settings')
        .update({
      'biometric_enabled': enabled,
    }).eq('user_id', user.id);
  }

  Future<void> updateActivityLog(
    bool enabled,
  ) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      return;
    }

    await _supabase
        .from('user_security_settings')
        .update({
      'activity_log_enabled': enabled,
    }).eq('user_id', user.id);
  }

  Future<void> updateDataSharing(
    bool enabled,
  ) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      return;
    }

    await _supabase
        .from('user_security_settings')
        .update({
      'data_sharing_enabled': enabled,
    }).eq('user_id', user.id);
  }
}