import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationSettingService {
  final SupabaseClient _supabase =
      Supabase.instance.client;

  static const String pushNotificationsKey =
      'push_notifications';

  static const String notificationSoundsKey =
      'notification_sounds';

  static const String appBadgesKey =
      'app_badges';

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

  // =========================================================
  // NOTIFICATION PREFERENCES
  // =========================================================

  Future<Map<String, bool>>
      getNotificationSettings() async {
    final dynamic response =
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

    final List<dynamic> rows =
        response as List<dynamic>;

    final Map<String, bool> settings = {
      pushNotificationsKey: true,
      notificationSoundsKey: true,
      appBadgesKey: true,
      scheduleReminderKey: true,
      taskCompletedKey: true,
      taskCancelledKey: true,
    };

    for (final dynamic item in rows) {
      final Map<String, dynamic> row =
          Map<String, dynamic>.from(
        item as Map,
      );

      final String key =
          row['setting_key']
                  ?.toString() ??
              '';

      if (key.isNotEmpty) {
        settings[key] =
            row['enabled'] as bool? ??
                true;
      }
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
    final List<dynamic> response =
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

    final Map<String, dynamic> row =
        Map<String, dynamic>.from(
      response.first as Map,
    );

    return row['enabled'] as bool? ??
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
      isNotificationSoundEnabled() async {
    return isSettingEnabled(
      settingKey:
          notificationSoundsKey,
      defaultValue: true,
    );
  }

  Future<bool>
      isAppBadgesEnabled() async {
    return isSettingEnabled(
      settingKey:
          appBadgesKey,
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

  // =========================================================
  // HOME NOTIFICATION INBOX
  // =========================================================

  Future<List<Map<String, dynamic>>>
      getNotifications() async {
    final List<dynamic> response =
        await _supabase
            .from('notifications')
            .select()
            .eq(
              'user_id',
              _userId,
            )
            .order(
              'created_at',
              ascending: false,
            );

    return response.map(
      (dynamic item) {
        return Map<String, dynamic>.from(
          item as Map,
        );
      },
    ).toList();
  }

  Future<int>
      getUnreadNotificationCount() async {
    final List<dynamic> response =
        await _supabase
            .from('notifications')
            .select('id')
            .eq(
              'user_id',
              _userId,
            )
            .eq(
              'is_read',
              false,
            );

    return response.length;
  }

  Future<void> addNotification({
    required String title,
    required String message,
    String type = 'general',
    String? scheduleId,
    String? notificationKey,
    DateTime? visibleAt,
  }) async {
    final DateTime now = DateTime.now();

    final Map<String, dynamic> data = {
      'user_id': _userId,
      'title': title,
      'message': message,
      'type': type,
      'is_read': false,
      'created_at': now.toUtc().toIso8601String(),
      'visible_at': (visibleAt ?? now).toUtc().toIso8601String(),
    };

    if (scheduleId != null && scheduleId.trim().isNotEmpty) {
      data['schedule_id'] = scheduleId.trim();
    }

    if (notificationKey != null && notificationKey.trim().isNotEmpty) {
      data['notification_key'] = notificationKey.trim();
    }

    await _supabase
        .from('notifications')
        .insert(data);
  }

  Future<void>
      addScheduleReminderNotification({
    required String scheduleTitle,
    String? scheduleId,
    String? notificationKey,
    DateTime? visibleAt,
  }) async {
    final bool enabled =
        await isScheduleReminderEnabled();

    if (!enabled) {
      return;
    }

    await addNotification(
      title: 'Schedule Reminder',
      message:
          '$scheduleTitle is starting soon.',
      type: 'schedule_reminder',
      scheduleId: scheduleId,
      notificationKey: notificationKey,
      visibleAt: visibleAt,
    );
  }

  Future<void>
      addTaskCompletedNotification({
    required String scheduleTitle,
    String? scheduleId,
    String? notificationKey,
  }) async {
    final bool enabled =
        await isTaskCompletedNotificationEnabled();

    if (!enabled) {
      return;
    }

    await addNotification(
      title: 'Task Completed',
      message:
          '$scheduleTitle was completed successfully.',
      type: 'task_completed',
      scheduleId: scheduleId,
      notificationKey: notificationKey,
    );
  }

  Future<void>
      addTaskCancelledNotification({
    required String scheduleTitle,
    String? scheduleId,
    String? notificationKey,
  }) async {
    final bool enabled =
        await isTaskCancelledNotificationEnabled();

    if (!enabled) {
      return;
    }

    await addNotification(
      title: 'Schedule Cancelled',
      message:
          '$scheduleTitle was cancelled.',
      type: 'task_cancelled',
      scheduleId: scheduleId,
      notificationKey: notificationKey,
    );
  }

  Future<void> markNotificationAsRead(
    String notificationId,
  ) async {
    await _supabase
        .from('notifications')
        .update({
          'is_read': true,
        })
        .eq(
          'id',
          notificationId,
        )
        .eq(
          'user_id',
          _userId,
        );
  }

  Future<void>
      markAllNotificationsAsRead() async {
    await _supabase
        .from('notifications')
        .update({
          'is_read': true,
        })
        .eq(
          'user_id',
          _userId,
        )
        .eq(
          'is_read',
          false,
        );
  }

  Future<void> markNotificationAsUnread(
    String notificationId,
  ) async {
    final String trimmedId =
        notificationId.trim();

    if (trimmedId.isEmpty) {
      return;
    }

    await _supabase
        .from('notifications')
        .update({
          'is_read': false,
        })
        .eq(
          'id',
          trimmedId,
        )
        .eq(
          'user_id',
          _userId,
        );
  }

  Future<void>
      deleteNotificationByKey(
    String notificationKey,
  ) async {
    final String trimmedKey =
        notificationKey.trim();

    if (trimmedKey.isEmpty) {
      return;
    }

    await _supabase
        .from('notifications')
        .delete()
        .eq(
          'notification_key',
          trimmedKey,
        )
        .eq(
          'user_id',
          _userId,
        );
  }

  Future<void> deleteNotification(
    String notificationId,
  ) async {
    await _supabase
        .from('notifications')
        .delete()
        .eq(
          'id',
          notificationId,
        )
        .eq(
          'user_id',
          _userId,
        );
  }

  Future<void>
      deleteAllNotifications() async {
    await _supabase
        .from('notifications')
        .delete()
        .eq(
          'user_id',
          _userId,
        );
  }
}