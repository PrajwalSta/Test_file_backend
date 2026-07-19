import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationSettingService {
  final SupabaseClient _supabase =
      Supabase.instance.client;

  static const String scheduleReminderKey =
      'schedule_reminder';

  static const String taskCompletedKey =
      'task_completed';

  static const String taskCancelledKey =
      'task_cancelled';

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

  Future<Map<String, bool>>
      getNotificationSettings() async {
    final List<Map<String, dynamic>> response =
        await _supabase
            .from(
              'notification_preferences',
            )
            .select(
              'setting_key, enabled',
            )
            .eq(
              'user_id',
              _userId,
            );

    final Map<String, bool> settings = {
      scheduleReminderKey: true,
      taskCompletedKey: true,
      taskCancelledKey: true,
    };

    for (final Map<String, dynamic> row
        in response) {
      final String settingKey =
          row['setting_key']
                  ?.toString() ??
              '';

      if (settingKey.isEmpty) {
        continue;
      }

      settings[settingKey] =
          row['enabled'] as bool? ??
              true;
    }

    return settings;
  }

  Future<void> saveNotificationSetting({
    required String settingKey,
    required bool enabled,
  }) async {
    await _supabase
        .from(
          'notification_preferences',
        )
        .upsert(
      {
        'user_id': _userId,
        'setting_key': settingKey,
        'enabled': enabled,
        'updated_at': DateTime.now()
            .toUtc()
            .toIso8601String(),
      },
      onConflict:
          'user_id,setting_key',
    );
  }

  Future<bool> isSettingEnabled({
    required String settingKey,
    bool defaultValue = true,
  }) async {
    final List<Map<String, dynamic>> response =
        await _supabase
            .from(
              'notification_preferences',
            )
            .select(
              'enabled',
            )
            .eq(
              'user_id',
              _userId,
            )
            .eq(
              'setting_key',
              settingKey,
            )
            .limit(1);

    if (response.isEmpty) {
      return defaultValue;
    }

    return response.first['enabled']
            as bool? ??
        defaultValue;
  }

  Future<bool>
      isScheduleReminderEnabled() async {
    return isSettingEnabled(
      settingKey:
          scheduleReminderKey,
      defaultValue: true,
    );
  }

  Future<bool>
      isTaskCompletedNotificationEnabled()
          async {
    return isSettingEnabled(
      settingKey:
          taskCompletedKey,
      defaultValue: true,
    );
  }

  Future<bool>
      isTaskCancelledNotificationEnabled()
          async {
    return isSettingEnabled(
      settingKey:
          taskCancelledKey,
      defaultValue: true,
    );
  }

  Future<bool>
      isScheduleDeleteNotificationEnabled()
          async {
    return isTaskCancelledNotificationEnabled();
  }

  Future<void>
      setScheduleReminderEnabled(
    bool enabled,
  ) async {
    await saveNotificationSetting(
      settingKey:
          scheduleReminderKey,
      enabled: enabled,
    );
  }

  Future<void>
      setTaskCompletedNotificationEnabled(
    bool enabled,
  ) async {
    await saveNotificationSetting(
      settingKey:
          taskCompletedKey,
      enabled: enabled,
    );
  }

  Future<void>
      setTaskCancelledNotificationEnabled(
    bool enabled,
  ) async {
    await saveNotificationSetting(
      settingKey:
          taskCancelledKey,
      enabled: enabled,
    );
  }

  Future<void>
      setScheduleDeleteNotificationEnabled(
    bool enabled,
  ) async {
    await setTaskCancelledNotificationEnabled(
      enabled,
    );
  }

  Future<void>
      enableAllNotifications() async {
    await Future.wait([
      setScheduleReminderEnabled(
        true,
      ),
      setTaskCompletedNotificationEnabled(
        true,
      ),
      setTaskCancelledNotificationEnabled(
        true,
      ),
    ]);
  }

  Future<void>
      disableAllNotifications() async {
    await Future.wait([
      setScheduleReminderEnabled(
        false,
      ),
      setTaskCompletedNotificationEnabled(
        false,
      ),
      setTaskCancelledNotificationEnabled(
        false,
      ),
    ]);
  }
}