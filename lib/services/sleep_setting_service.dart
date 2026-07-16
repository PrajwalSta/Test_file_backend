import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SleepSettingService {
  // Supabase database client.
  final SupabaseClient _supabase =
      Supabase.instance.client;

  // Name of the Supabase table.
  static const String _tableName =
      'sleep_settings';

  // =========================================================
  // GET CURRENT LOGGED-IN USER
  // =========================================================

  User _getCurrentUser() {
    // Read the currently logged-in Supabase user.
    final User? user =
        _supabase.auth.currentUser;

    // Stop the operation when no user is logged in.
    if (user == null) {
      throw Exception(
        'User is not logged in.',
      );
    }

    return user;
  }

  // =========================================================
  // GET SLEEP SETTINGS
  // =========================================================

  Future<Map<String, dynamic>>
      getSleepSettings() async {
    // Get the logged-in user.
    final User user =
        _getCurrentUser();

    try {
      // Search for one sleep setting row
      // belonging to the current user.
      final Map<String, dynamic>? response =
          await _supabase
              .from(_tableName)
              .select(
                'sleep_time, wake_time, enabled',
              )
              .eq(
                'user_id',
                user.id,
              )
              .maybeSingle();

      // A new user may not have saved
      // Sleep Mode settings yet.
      //
      // Return default values in that case.
      if (response == null) {
        return {
          'sleep_time': '22:00:00',
          'wake_time': '07:00:00',
          'enabled': true,
        };
      }

      // Return settings loaded from Supabase.
      return response;
    } on PostgrestException catch (error) {
      debugPrint(
        'Sleep settings loading error: '
        '${error.message}',
      );

      debugPrint(
        'Sleep settings error code: '
        '${error.code}',
      );

      debugPrint(
        'Sleep settings details: '
        '${error.details}',
      );

      rethrow;
    } catch (error) {
      debugPrint(
        'Unexpected sleep settings error: '
        '$error',
      );

      rethrow;
    }
  }

  // =========================================================
  // SAVE SLEEP SETTINGS
  // =========================================================

  Future<void> saveSleepSettings({
    required String sleepTime,
    required String wakeTime,
    required bool enabled,
  }) async {
    // Get the logged-in user.
    final User user =
        _getCurrentUser();

    try {
      // Upsert creates the row when it does
      // not exist and updates it when it exists.
      //
      // onConflict works because user_id
      // has a UNIQUE constraint in Supabase.
      await _supabase
          .from(_tableName)
          .upsert(
        {
          'user_id': user.id,
          'sleep_time': sleepTime,
          'wake_time': wakeTime,
          'enabled': enabled,
          'updated_at':
              DateTime.now()
                  .toUtc()
                  .toIso8601String(),
        },
        onConflict: 'user_id',
      );

      debugPrint(
        'Sleep settings saved successfully.',
      );
    } on PostgrestException catch (error) {
      debugPrint(
        'Sleep settings saving error: '
        '${error.message}',
      );

      debugPrint(
        'Sleep settings error code: '
        '${error.code}',
      );

      debugPrint(
        'Sleep settings details: '
        '${error.details}',
      );

      rethrow;
    } catch (error) {
      debugPrint(
        'Unexpected sleep settings save error: '
        '$error',
      );

      rethrow;
    }
  }

  // =========================================================
  // UPDATE ONLY ENABLED STATUS
  // =========================================================

  Future<void> updateEnabled({
    required bool enabled,
  }) async {
    // Load the current values first.
    final Map<String, dynamic> currentSettings =
        await getSleepSettings();

    // Save the same times with the new enabled value.
    await saveSleepSettings(
      sleepTime:
          currentSettings['sleep_time']
                  ?.toString() ??
              '22:00:00',
      wakeTime:
          currentSettings['wake_time']
                  ?.toString() ??
              '07:00:00',
      enabled: enabled,
    );
  }
}