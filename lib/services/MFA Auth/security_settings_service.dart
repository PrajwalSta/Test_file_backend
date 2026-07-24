import 'package:supabase_flutter/supabase_flutter.dart';

class SecuritySettingsService {
  final SupabaseClient _supabase =
      Supabase.instance.client;

  String get _userId {
    final User? user =
        _supabase.auth.currentUser;

    if (user == null) {
      throw Exception(
        'User is not logged in.',
      );
    }

    return user.id;
  }

  // ==========================================================
  // DEFAULT SETTINGS
  // ==========================================================
  Map<String, dynamic> get _defaultSettings {
    return {
      'user_id': _userId,
      'two_factor_enabled': false,
      'biometric_enabled': false,
      'activity_log_enabled': false,
      'data_sharing_enabled': false,
    };
  }

  // ==========================================================
  // GET SECURITY SETTINGS
  // ==========================================================
  Future<Map<String, dynamic>>
      getSettings() async {
    final String userId = _userId;

    final Map<String, dynamic>? response =
        await _supabase
            .from('user_security_settings')
            .select()
            .eq(
              'user_id',
              userId,
            )
            .maybeSingle();

    if (response != null) {
      return response;
    }

    final List<Map<String, dynamic>>
        insertedRows =
        await _supabase
            .from('user_security_settings')
            .insert(
              _defaultSettings,
            )
            .select();

    if (insertedRows.isEmpty) {
      return _defaultSettings;
    }

    return insertedRows.first;
  }

  // ==========================================================
  // UPDATE TWO-FACTOR AUTHENTICATION
  // ==========================================================
  Future<void> updateTwoFactor(
    bool enabled,
  ) async {
    await _upsertSetting(
      column:
          'two_factor_enabled',
      enabled: enabled,
    );
  }

  // ==========================================================
  // UPDATE BIOMETRIC LOGIN
  // ==========================================================
  Future<void> updateBiometric(
    bool enabled,
  ) async {
    await _upsertSetting(
      column:
          'biometric_enabled',
      enabled: enabled,
    );
  }

  // ==========================================================
  // UPDATE ACTIVITY LOG
  // ==========================================================
  Future<void> updateActivityLog(
    bool enabled,
  ) async {
    await _upsertSetting(
      column:
          'activity_log_enabled',
      enabled: enabled,
    );
  }

  // ==========================================================
  // UPDATE DATA SHARING
  // ==========================================================
  Future<void> updateDataSharing(
    bool enabled,
  ) async {
    await _upsertSetting(
      column:
          'data_sharing_enabled',
      enabled: enabled,
    );
  }

  // ==========================================================
  // UPSERT ONE SECURITY SETTING
  // ==========================================================
  Future<void> _upsertSetting({
    required String column,
    required bool enabled,
  }) async {
    final String userId = _userId;

    await _supabase
        .from('user_security_settings')
        .upsert(
      {
        'user_id': userId,
        column: enabled,
      },
      onConflict: 'user_id',
    );
  }
}