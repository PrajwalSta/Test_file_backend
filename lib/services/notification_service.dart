import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationSettingService {
  final SupabaseClient _supabase =
      Supabase.instance.client;

  /*
   * ------------------------------------------------------
   * Notification preference keys
   * ------------------------------------------------------
   */

  static const String pushNotificationsKey =
      'push_notifications';

  static const String emailNotificationsKey =
      'email_notifications';

  static const String scheduleReminderKey =
      'schedule_reminder';

  static const String breakAlertsKey =
      'break_alerts';

  static const String achievementsKey =
      'achievements';

  static const String weeklyReportKey =
      'weekly_report';

  static const String notificationSoundsKey =
      'notification_sounds';

  static const String appBadgesKey =
      'app_badges';

  static const String taskCompletedKey =
      'task_completed';

  static const String taskCancelledKey =
      'task_cancelled';

  /*
   * Default values used when the user has not saved
   * a particular notification preference yet.
   */
  static const Map<String, bool> defaultSettings =
      <String, bool>{
    pushNotificationsKey: true,
    emailNotificationsKey: true,
    scheduleReminderKey: true,
    breakAlertsKey: true,
    achievementsKey: true,
    weeklyReportKey: true,
    notificationSoundsKey: true,
    appBadgesKey: true,
    taskCompletedKey: true,
    taskCancelledKey: true,
  };

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

  /*
   * ------------------------------------------------------
   * Notification preference methods
   * ------------------------------------------------------
   */

  Future<Map<String, bool>>
      getNotificationSettings() async {
    try {
      final List<Map<String, dynamic>>
          response =
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

      final Map<String, bool> settings =
          Map<String, bool>.from(
        defaultSettings,
      );

      for (
        final Map<String, dynamic> row
        in response
      ) {
        final String settingKey =
            row['setting_key']
                    ?.toString()
                    .trim() ??
                '';

        if (settingKey.isEmpty) {
          continue;
        }

        settings[settingKey] =
            row['enabled'] as bool? ??
                true;
      }

      return settings;
    } catch (error, stackTrace) {
      debugPrint(
        'Get notification settings error: '
        '$error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  Future<void> saveNotificationSetting({
    required String settingKey,
    required bool enabled,
  }) async {
    final String trimmedKey =
        settingKey.trim();

    if (trimmedKey.isEmpty) {
      throw ArgumentError(
        'Notification setting key cannot be empty.',
      );
    }

    try {
      await _supabase
          .from(
            'notification_preferences',
          )
          .upsert(
        {
          'user_id': _userId,
          'setting_key': trimmedKey,
          'enabled': enabled,
          'updated_at': DateTime.now()
              .toUtc()
              .toIso8601String(),
        },
        onConflict:
            'user_id,setting_key',
      );

      debugPrint(
        'Notification setting saved: '
        '$trimmedKey = $enabled',
      );
    } catch (error, stackTrace) {
      debugPrint(
        'Save notification setting error: '
        '$error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  Future<void> setNotificationEnabled({
    required String settingKey,
    required bool enabled,
  }) async {
    await saveNotificationSetting(
      settingKey: settingKey,
      enabled: enabled,
    );
  }

  Future<bool> isSettingEnabled({
    required String settingKey,
    bool? defaultValue,
  }) async {
    final bool fallbackValue =
        defaultValue ??
            defaultSettings[settingKey] ??
            true;

    try {
      final List<Map<String, dynamic>>
          response =
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
        return fallbackValue;
      }

      return response.first['enabled']
              as bool? ??
          fallbackValue;
    } catch (error, stackTrace) {
      debugPrint(
        'Check notification setting error: '
        '$error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      return fallbackValue;
    }
  }

  Future<bool> isNotificationEnabled(
    String settingKey,
  ) async {
    return isSettingEnabled(
      settingKey: settingKey,
    );
  }

  /*
   * ------------------------------------------------------
   * Individual setting getters
   * ------------------------------------------------------
   */

  Future<bool>
      isPushNotificationEnabled() async {
    return isSettingEnabled(
      settingKey:
          pushNotificationsKey,
    );
  }

  Future<bool>
      isEmailNotificationEnabled() async {
    return isSettingEnabled(
      settingKey:
          emailNotificationsKey,
    );
  }

  Future<bool>
      isScheduleReminderEnabled() async {
    return isSettingEnabled(
      settingKey:
          scheduleReminderKey,
    );
  }

  Future<bool>
      isBreakAlertsEnabled() async {
    return isSettingEnabled(
      settingKey:
          breakAlertsKey,
    );
  }

  Future<bool>
      isAchievementsEnabled() async {
    return isSettingEnabled(
      settingKey:
          achievementsKey,
    );
  }

  Future<bool>
      isWeeklyReportEnabled() async {
    return isSettingEnabled(
      settingKey:
          weeklyReportKey,
    );
  }

  Future<bool>
      isNotificationSoundEnabled() async {
    return isSettingEnabled(
      settingKey:
          notificationSoundsKey,
    );
  }

  Future<bool>
      isAppBadgesEnabled() async {
    return isSettingEnabled(
      settingKey:
          appBadgesKey,
    );
  }

  Future<bool>
      isTaskCompletedNotificationEnabled()
          async {
    return isSettingEnabled(
      settingKey:
          taskCompletedKey,
    );
  }

  Future<bool>
      isTaskCancelledNotificationEnabled()
          async {
    return isSettingEnabled(
      settingKey:
          taskCancelledKey,
    );
  }

  Future<bool>
      isScheduleDeleteNotificationEnabled()
          async {
    return isTaskCancelledNotificationEnabled();
  }

  /*
   * ------------------------------------------------------
   * Individual setting setters
   * ------------------------------------------------------
   */

  Future<void>
      setPushNotificationEnabled(
    bool enabled,
  ) async {
    await saveNotificationSetting(
      settingKey:
          pushNotificationsKey,
      enabled: enabled,
    );
  }

  Future<void>
      setEmailNotificationEnabled(
    bool enabled,
  ) async {
    await saveNotificationSetting(
      settingKey:
          emailNotificationsKey,
      enabled: enabled,
    );
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

  Future<void> setBreakAlertsEnabled(
    bool enabled,
  ) async {
    await saveNotificationSetting(
      settingKey:
          breakAlertsKey,
      enabled: enabled,
    );
  }

  Future<void> setAchievementsEnabled(
    bool enabled,
  ) async {
    await saveNotificationSetting(
      settingKey:
          achievementsKey,
      enabled: enabled,
    );
  }

  Future<void> setWeeklyReportEnabled(
    bool enabled,
  ) async {
    await saveNotificationSetting(
      settingKey:
          weeklyReportKey,
      enabled: enabled,
    );
  }

  Future<void>
      setNotificationSoundEnabled(
    bool enabled,
  ) async {
    await saveNotificationSetting(
      settingKey:
          notificationSoundsKey,
      enabled: enabled,
    );
  }

  Future<void> setAppBadgesEnabled(
    bool enabled,
  ) async {
    await saveNotificationSetting(
      settingKey:
          appBadgesKey,
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

  /*
   * Creates missing default settings for the
   * currently logged-in user.
   */
  Future<void>
      createDefaultSettings() async {
    try {
      final DateTime now =
          DateTime.now().toUtc();

      final List<Map<String, dynamic>> rows =
          defaultSettings.entries.map(
        (
          MapEntry<String, bool> entry,
        ) {
          return <String, dynamic>{
            'user_id': _userId,
            'setting_key': entry.key,
            'enabled': entry.value,
            'updated_at':
                now.toIso8601String(),
          };
        },
      ).toList();

      await _supabase
          .from(
            'notification_preferences',
          )
          .upsert(
        rows,
        onConflict:
            'user_id,setting_key',
      );

      debugPrint(
        'Default notification settings created.',
      );
    } catch (error, stackTrace) {
      debugPrint(
        'Create default notification settings error: '
        '$error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  Future<void>
      enableAllNotifications() async {
    try {
      await Future.wait(
        defaultSettings.keys.map(
          (String settingKey) {
            return saveNotificationSetting(
              settingKey: settingKey,
              enabled: true,
            );
          },
        ),
      );

      debugPrint(
        'All notification settings enabled.',
      );
    } catch (error) {
      debugPrint(
        'Enable all notifications error: '
        '$error',
      );

      rethrow;
    }
  }

  Future<void>
      disableAllNotifications() async {
    try {
      await Future.wait(
        defaultSettings.keys.map(
          (String settingKey) {
            return saveNotificationSetting(
              settingKey: settingKey,
              enabled: false,
            );
          },
        ),
      );

      debugPrint(
        'All notification settings disabled.',
      );
    } catch (error) {
      debugPrint(
        'Disable all notifications error: '
        '$error',
      );

      rethrow;
    }
  }

  /*
   * ------------------------------------------------------
   * Notification inbox methods
   * ------------------------------------------------------
   */

  Future<List<Map<String, dynamic>>>
      getNotifications() async {
    try {
      final List<Map<String, dynamic>>
          response =
          await _supabase
              .from(
                'notifications',
              )
              .select()
              .eq(
                'user_id',
                _userId,
              )
              .lte(
                'visible_at',
                DateTime.now()
                    .toUtc()
                    .toIso8601String(),
              )
              .order(
                'created_at',
                ascending: false,
              );

      debugPrint(
        'Loaded notifications: '
        '${response.length}',
      );

      return response;
    } catch (error, stackTrace) {
      debugPrint(
        'Get notifications error: '
        '$error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  Future<int>
      getUnreadNotificationCount() async {
    try {
      final List<Map<String, dynamic>>
          response =
          await _supabase
              .from(
                'notifications',
              )
              .select(
                'id',
              )
              .eq(
                'user_id',
                _userId,
              )
              .eq(
                'is_read',
                false,
              )
              .lte(
                'visible_at',
                DateTime.now()
                    .toUtc()
                    .toIso8601String(),
              );

      debugPrint(
        'Unread notification count: '
        '${response.length}',
      );

      return response.length;
    } catch (error, stackTrace) {
      debugPrint(
        'Get unread notification count error: '
        '$error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      return 0;
    }
  }

  Future<void> addNotification({
    required String title,
    required String message,
    required String type,
    String? scheduleId,
    String? notificationKey,
    DateTime? visibleAt,
  }) async {
    try {
      final DateTime now =
          DateTime.now();

      final Map<String, dynamic> data =
          <String, dynamic>{
        'user_id': _userId,
        'title': title,
        'message': message,
        'type': type,
        'is_read': false,
        'created_at':
            now.toUtc().toIso8601String(),
        'visible_at': (visibleAt ?? now)
            .toUtc()
            .toIso8601String(),
      };

      if (scheduleId != null &&
          scheduleId.trim().isNotEmpty) {
        data['schedule_id'] =
            scheduleId.trim();
      }

      if (notificationKey != null &&
          notificationKey
              .trim()
              .isNotEmpty) {
        data['notification_key'] =
            notificationKey.trim();
      }

      debugPrint(
        'Adding inbox notification: '
        '$data',
      );

      final List<Map<String, dynamic>>
          insertedRows =
          await _supabase
              .from(
                'notifications',
              )
              .insert(
                data,
              )
              .select();

      debugPrint(
        'Inbox notification inserted: '
        '$insertedRows',
      );
    } catch (error, stackTrace) {
      debugPrint(
        'Add inbox notification error: '
        '$error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  Future<void>
      addScheduleReminderNotification({
    required String scheduleTitle,
    String? scheduleId,
    String? notificationKey,
    DateTime? visibleAt,
  }) async {
    final bool pushEnabled =
        await isPushNotificationEnabled();

    final bool reminderEnabled =
        await isScheduleReminderEnabled();

    if (!pushEnabled ||
        !reminderEnabled) {
      debugPrint(
        'Schedule reminder notification '
        'is disabled.',
      );

      return;
    }

    await addNotification(
      title:
          'Schedule reminder',
      message:
          '$scheduleTitle is starting soon.',
      type:
          scheduleReminderKey,
      scheduleId:
          scheduleId,
      notificationKey:
          notificationKey,
      visibleAt:
          visibleAt,
    );
  }

  Future<void>
      addTaskCompletedNotification({
    required String scheduleTitle,
    String? scheduleId,
    String? notificationKey,
  }) async {
    final bool pushEnabled =
        await isPushNotificationEnabled();

    final bool completedEnabled =
        await isTaskCompletedNotificationEnabled();

    if (!pushEnabled ||
        !completedEnabled) {
      debugPrint(
        'Task completed notification '
        'is disabled.',
      );

      return;
    }

    await addNotification(
      title:
          'Task completed',
      message:
          '$scheduleTitle has been completed.',
      type:
          taskCompletedKey,
      scheduleId:
          scheduleId,
      notificationKey:
          notificationKey,
    );
  }

  Future<void>
      addTaskCancelledNotification({
    required String scheduleTitle,
    String? scheduleId,
    String? notificationKey,
  }) async {
    final bool pushEnabled =
        await isPushNotificationEnabled();

    final bool cancelledEnabled =
        await isTaskCancelledNotificationEnabled();

    if (!pushEnabled ||
        !cancelledEnabled) {
      debugPrint(
        'Task cancelled notification '
        'is disabled.',
      );

      return;
    }

    await addNotification(
      title:
          'Schedule cancelled',
      message:
          '$scheduleTitle was removed '
          'from your schedule.',
      type:
          taskCancelledKey,
      scheduleId:
          scheduleId,
      notificationKey:
          notificationKey,
    );
  }

  Future<void>
      addBreakAlertNotification({
    String message =
        'It is time to take a short break.',
    String? notificationKey,
    DateTime? visibleAt,
  }) async {
    final bool pushEnabled =
        await isPushNotificationEnabled();

    final bool breakEnabled =
        await isBreakAlertsEnabled();

    if (!pushEnabled ||
        !breakEnabled) {
      debugPrint(
        'Break alert notification '
        'is disabled.',
      );

      return;
    }

    await addNotification(
      title:
          'Break reminder',
      message:
          message,
      type:
          breakAlertsKey,
      notificationKey:
          notificationKey,
      visibleAt:
          visibleAt,
    );
  }

  Future<void>
      addAchievementNotification({
    required String title,
    required String message,
    String? notificationKey,
  }) async {
    final bool pushEnabled =
        await isPushNotificationEnabled();

    final bool achievementEnabled =
        await isAchievementsEnabled();

    if (!pushEnabled ||
        !achievementEnabled) {
      debugPrint(
        'Achievement notification '
        'is disabled.',
      );

      return;
    }

    await addNotification(
      title:
          title,
      message:
          message,
      type:
          achievementsKey,
      notificationKey:
          notificationKey,
    );
  }

  Future<void>
      addWeeklyReportNotification({
    required String message,
    String? notificationKey,
    DateTime? visibleAt,
  }) async {
    final bool pushEnabled =
        await isPushNotificationEnabled();

    final bool reportEnabled =
        await isWeeklyReportEnabled();

    if (!pushEnabled ||
        !reportEnabled) {
      debugPrint(
        'Weekly report notification '
        'is disabled.',
      );

      return;
    }

    await addNotification(
      title:
          'Weekly report',
      message:
          message,
      type:
          weeklyReportKey,
      notificationKey:
          notificationKey,
      visibleAt:
          visibleAt,
    );
  }

  Future<void>
      addScheduleDeletedNotification({
    required String scheduleTitle,
    String? scheduleId,
    String? notificationKey,
  }) async {
    await addTaskCancelledNotification(
      scheduleTitle:
          scheduleTitle,
      scheduleId:
          scheduleId,
      notificationKey:
          notificationKey,
    );
  }

  Future<void>
      markNotificationAsRead(
    String notificationId,
  ) async {
    final String trimmedId =
        notificationId.trim();

    if (trimmedId.isEmpty) {
      return;
    }

    try {
      final List<Map<String, dynamic>>
          updatedRows =
          await _supabase
              .from(
                'notifications',
              )
              .update(
        {
          'is_read': true,
        },
      )
              .eq(
                'id',
                trimmedId,
              )
              .eq(
                'user_id',
                _userId,
              )
              .select();

      debugPrint(
        'Notification marked as read: '
        '$updatedRows',
      );
    } catch (error, stackTrace) {
      debugPrint(
        'Mark notification as read error: '
        '$error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  Future<void>
      markNotificationAsUnread(
    String notificationId,
  ) async {
    final String trimmedId =
        notificationId.trim();

    if (trimmedId.isEmpty) {
      return;
    }

    try {
      final List<Map<String, dynamic>>
          updatedRows =
          await _supabase
              .from(
                'notifications',
              )
              .update(
        {
          'is_read': false,
        },
      )
              .eq(
                'id',
                trimmedId,
              )
              .eq(
                'user_id',
                _userId,
              )
              .select();

      debugPrint(
        'Notification marked as unread: '
        '$updatedRows',
      );
    } catch (error, stackTrace) {
      debugPrint(
        'Mark notification as unread error: '
        '$error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  Future<void>
      markAllNotificationsAsRead() async {
    try {
      final List<Map<String, dynamic>>
          updatedRows =
          await _supabase
              .from(
                'notifications',
              )
              .update(
        {
          'is_read': true,
        },
      )
              .eq(
                'user_id',
                _userId,
              )
              .eq(
                'is_read',
                false,
              )
              .select();

      debugPrint(
        'All notifications marked as read: '
        '${updatedRows.length}',
      );
    } catch (error, stackTrace) {
      debugPrint(
        'Mark all notifications as read error: '
        '$error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  Future<void> deleteNotification(
    String notificationId,
  ) async {
    final String trimmedId =
        notificationId.trim();

    if (trimmedId.isEmpty) {
      return;
    }

    try {
      final List<Map<String, dynamic>>
          deletedRows =
          await _supabase
              .from(
                'notifications',
              )
              .delete()
              .eq(
                'id',
                trimmedId,
              )
              .eq(
                'user_id',
                _userId,
              )
              .select();

      debugPrint(
        'Notification deleted: '
        '$deletedRows',
      );
    } catch (error, stackTrace) {
      debugPrint(
        'Delete notification error: '
        '$error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      rethrow;
    }
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

    try {
      final List<Map<String, dynamic>>
          deletedRows =
          await _supabase
              .from(
                'notifications',
              )
              .delete()
              .eq(
                'notification_key',
                trimmedKey,
              )
              .eq(
                'user_id',
                _userId,
              )
              .select();

      debugPrint(
        'Notification deleted by key: '
        '$deletedRows',
      );
    } catch (error, stackTrace) {
      debugPrint(
        'Delete notification by key error: '
        '$error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  Future<void>
      deleteNotificationsForSchedule(
    String scheduleId,
  ) async {
    final String trimmedScheduleId =
        scheduleId.trim();

    if (trimmedScheduleId.isEmpty) {
      return;
    }

    try {
      final List<Map<String, dynamic>>
          deletedRows =
          await _supabase
              .from(
                'notifications',
              )
              .delete()
              .eq(
                'schedule_id',
                trimmedScheduleId,
              )
              .eq(
                'user_id',
                _userId,
              )
              .select();

      debugPrint(
        'Notifications deleted for schedule: '
        '$deletedRows',
      );
    } catch (error, stackTrace) {
      debugPrint(
        'Delete schedule notifications error: '
        '$error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  Future<void>
      deleteAllNotifications() async {
    try {
      final List<Map<String, dynamic>>
          deletedRows =
          await _supabase
              .from(
                'notifications',
              )
              .delete()
              .eq(
                'user_id',
                _userId,
              )
              .select();

      debugPrint(
        'All inbox notifications deleted: '
        '${deletedRows.length}',
      );
    } catch (error, stackTrace) {
      debugPrint(
        'Delete all notifications error: '
        '$error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }
}