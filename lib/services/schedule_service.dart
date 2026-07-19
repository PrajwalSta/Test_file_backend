import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'local_notification_service.dart';
import 'notification_setting_service.dart';

class ScheduleService {
  final SupabaseClient _supabase =
      Supabase.instance.client;

  final NotificationSettingService
      _notificationSettingService =
      NotificationSettingService();

  User get _currentUser {
    final User? user =
        _supabase.auth.currentUser;

    if (user == null) {
      throw Exception(
        'User is not logged in with Supabase.',
      );
    }

    return user;
  }

  int _createNotificationId(
    String scheduleId,
  ) {
    return scheduleId.hashCode.abs() %
        2147483647;
  }

  DateTime _startOfDay(
    DateTime date,
  ) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    );
  }

  // ==========================================================
  // ADD NEW SCHEDULE
  // ==========================================================
  Future<Map<String, dynamic>> addSchedule({
    required String title,
    required String time,
    required DateTime scheduleDateTime,
    required int durationMinutes,
    required String category,
    required String focusMode,
  }) async {
    final User user = _currentUser;

    if (!scheduleDateTime.isAfter(
      DateTime.now(),
    )) {
      throw Exception(
        'Please select a future date and time.',
      );
    }

    debugPrint(
      'Current Supabase user: ${user.email}',
    );

    debugPrint(
      'Current Supabase user ID: ${user.id}',
    );

    try {
      final Map<String, dynamic> schedule =
          await _supabase
              .from('schedules')
              .insert({
                'user_id': user.id,
                'title': title,
                'time': time,
                'scheduled_at':
                    scheduleDateTime
                        .toUtc()
                        .toIso8601String(),
                'duration_minutes':
                    durationMinutes,
                'category': category,
                'focus_mode': focusMode,
                'completed': false,
              })
              .select()
              .single();

      final String scheduleId =
          schedule['id'].toString();

      final int notificationId =
          _createNotificationId(
        scheduleId,
      );

      await _scheduleReminder(
        scheduleId: scheduleId,
        notificationId:
            notificationId,
        title: title,
        scheduleDateTime:
            scheduleDateTime,
      );

      await _supabase
          .from('schedules')
          .update({
            'notification_id':
                notificationId,
          })
          .eq('id', scheduleId)
          .eq('user_id', user.id);

      debugPrint(
        'Schedule created successfully.',
      );

      return {
        ...schedule,
        'notification_id':
            notificationId,
      };
    } on PostgrestException catch (error) {
      debugPrint(
        'Supabase add schedule error: '
        '${error.message}',
      );

      rethrow;
    } catch (error) {
      debugPrint(
        'Add schedule error: $error',
      );

      rethrow;
    }
  }

  // ==========================================================
  // SCHEDULE LOCAL NOTIFICATION
  // ==========================================================
  Future<void> _scheduleReminder({
    required String scheduleId,
    required int notificationId,
    required String title,
    required DateTime scheduleDateTime,
  }) async {
    final bool pushEnabled =
        await _notificationSettingService
            .isSettingEnabled(
      settingKey:
          'push_notifications',
      defaultValue: true,
    );

    final bool reminderEnabled =
        await _notificationSettingService
            .isSettingEnabled(
      settingKey:
          'schedule_reminders',
      defaultValue: true,
    );

    if (!pushEnabled ||
        !reminderEnabled) {
      debugPrint(
        'Schedule notification disabled.',
      );

      return;
    }

    final bool permissionGranted =
        await LocalNotificationService
            .instance
            .requestPermission();

    if (!permissionGranted) {
      debugPrint(
        'Notification permission denied.',
      );

      return;
    }

    await LocalNotificationService
        .instance
        .scheduleNotification(
      id: notificationId,
      title: 'Schedule reminder',
      body: '$title starts now.',
      scheduledDate:
          scheduleDateTime,
      payload: scheduleId,
    );

    debugPrint(
      'Notification scheduled for '
      '$scheduleDateTime',
    );
  }

  // ==========================================================
  // GET ALL SCHEDULES
  // ==========================================================
  Future<List<Map<String, dynamic>>>
      getSchedules() async {
    final User? user =
        _supabase.auth.currentUser;

    if (user == null) {
      return [];
    }

    try {
      final List<Map<String, dynamic>>
          schedules = await _supabase
              .from('schedules')
              .select()
              .eq('user_id', user.id)
              .order(
                'scheduled_at',
                ascending: true,
              );

      debugPrint(
        'Loaded ${schedules.length} schedules.',
      );

      return schedules;
    } on PostgrestException catch (error) {
      debugPrint(
        'Get schedules Supabase error: '
        '${error.message}',
      );

      rethrow;
    } catch (error) {
      debugPrint(
        'Get schedules error: $error',
      );

      rethrow;
    }
  }

  // ==========================================================
  // GET TODAY SCHEDULES
  // ==========================================================
  Future<List<Map<String, dynamic>>>
      getTodaySchedules() async {
    return getSchedulesForDate(
      DateTime.now(),
    );
  }

  // ==========================================================
  // GET TOMORROW SCHEDULES
  // ==========================================================
  Future<List<Map<String, dynamic>>>
      getTomorrowSchedules() async {
    return getSchedulesForDate(
      DateTime.now().add(
        const Duration(days: 1),
      ),
    );
  }

  // ==========================================================
  // GET SCHEDULES FOR SELECTED DATE
  // ==========================================================
  Future<List<Map<String, dynamic>>>
      getSchedulesForDate(
    DateTime date,
  ) async {
    final User? user =
        _supabase.auth.currentUser;

    if (user == null) {
      return [];
    }

    final DateTime localStart =
        _startOfDay(date);

    final DateTime localEnd =
        localStart.add(
      const Duration(days: 1),
    );

    try {
      final List<Map<String, dynamic>>
          schedules = await _supabase
              .from('schedules')
              .select()
              .eq('user_id', user.id)
              .gte(
                'scheduled_at',
                localStart
                    .toUtc()
                    .toIso8601String(),
              )
              .lt(
                'scheduled_at',
                localEnd
                    .toUtc()
                    .toIso8601String(),
              )
              .order(
                'scheduled_at',
                ascending: true,
              );

      debugPrint(
        'Loaded ${schedules.length} '
        'schedules for '
        '${localStart.year}-'
        '${localStart.month}-'
        '${localStart.day}.',
      );

      return schedules;
    } on PostgrestException catch (error) {
      debugPrint(
        'Load schedules by date error: '
        '${error.message}',
      );

      rethrow;
    } catch (error) {
      debugPrint(
        'Load schedules by date error: '
        '$error',
      );

      rethrow;
    }
  }

  // ==========================================================
  // TODAY'S PROGRESS
  // ==========================================================
  Future<Map<String, dynamic>>
      getTodayProgress() async {
    final User? user =
        _supabase.auth.currentUser;

    if (user == null) {
      return {
        'total': 0,
        'completed': 0,
        'progress': 0.0,
      };
    }

    final DateTime now =
        DateTime.now();

    final DateTime startOfToday =
        _startOfDay(now);

    final DateTime startOfTomorrow =
        startOfToday.add(
      const Duration(days: 1),
    );

    try {
      final List<Map<String, dynamic>>
          schedules = await _supabase
              .from('schedules')
              .select(
                'id, completed',
              )
              .eq('user_id', user.id)
              .gte(
                'scheduled_at',
                startOfToday
                    .toUtc()
                    .toIso8601String(),
              )
              .lt(
                'scheduled_at',
                startOfTomorrow
                    .toUtc()
                    .toIso8601String(),
              );

      final int total =
          schedules.length;

      final int completed =
          schedules.where((schedule) {
        return schedule['completed'] ==
            true;
      }).length;

      final double progress =
          total == 0
              ? 0.0
              : completed / total;

      return {
        'total': total,
        'completed': completed,
        'progress': progress,
      };
    } on PostgrestException catch (error) {
      debugPrint(
        'Today progress Supabase error: '
        '${error.message}',
      );

      rethrow;
    } catch (error) {
      debugPrint(
        'Today progress error: $error',
      );

      rethrow;
    }
  }

  // ==========================================================
  // MARK TASK AS COMPLETED
  // ==========================================================
  Future<void> updateCompleted({
    required String scheduleId,
    required bool completed,
    int? notificationId,
  }) async {
    final User user =
        _currentUser;

    try {
      await _supabase
          .from('schedules')
          .update({
            'completed': completed,
          })
          .eq('id', scheduleId)
          .eq('user_id', user.id);

      if (completed &&
          notificationId != null) {
        await LocalNotificationService
            .instance
            .cancelNotification(
          notificationId,
        );
      }
    } on PostgrestException catch (error) {
      debugPrint(
        'Update completed error: '
        '${error.message}',
      );

      rethrow;
    }
  }

  // ==========================================================
  // UPDATE SCHEDULE
  // ==========================================================
  Future<void> updateSchedule({
    required String scheduleId,
    required String title,
    required String time,
    required DateTime scheduleDateTime,
    required int durationMinutes,
    required String category,
    required String focusMode,
    int? notificationId,
  }) async {
    final User user =
        _currentUser;

    if (!scheduleDateTime.isAfter(
      DateTime.now(),
    )) {
      throw Exception(
        'Please select a future date and time.',
      );
    }

    final int newNotificationId =
        notificationId ??
            _createNotificationId(
              scheduleId,
            );

    try {
      if (notificationId != null) {
        await LocalNotificationService
            .instance
            .cancelNotification(
          notificationId,
        );
      }

      await _supabase
          .from('schedules')
          .update({
            'title': title,
            'time': time,
            'scheduled_at':
                scheduleDateTime
                    .toUtc()
                    .toIso8601String(),
            'duration_minutes':
                durationMinutes,
            'category': category,
            'focus_mode': focusMode,
            'notification_id':
                newNotificationId,
          })
          .eq('id', scheduleId)
          .eq('user_id', user.id);

      await _scheduleReminder(
        scheduleId: scheduleId,
        notificationId:
            newNotificationId,
        title: title,
        scheduleDateTime:
            scheduleDateTime,
      );
    } on PostgrestException catch (error) {
      debugPrint(
        'Update schedule error: '
        '${error.message}',
      );

      rethrow;
    } catch (error) {
      debugPrint(
        'Update schedule error: $error',
      );

      rethrow;
    }
  }

  // ==========================================================
  // DELETE SCHEDULE
  // ==========================================================
  Future<void> deleteSchedule(
    String scheduleId,
  ) async {
    final User user =
        _currentUser;

    try {
      final Map<String, dynamic> schedule =
          await _supabase
              .from('schedules')
              .select(
                'notification_id',
              )
              .eq('id', scheduleId)
              .eq('user_id', user.id)
              .single();

      final int? notificationId =
          schedule['notification_id']
              as int?;

      if (notificationId != null) {
        await LocalNotificationService
            .instance
            .cancelNotification(
          notificationId,
        );
      }

      await _supabase
          .from('schedules')
          .delete()
          .eq('id', scheduleId)
          .eq('user_id', user.id);
    } on PostgrestException catch (error) {
      debugPrint(
        'Delete schedule error: '
        '${error.message}',
      );

      rethrow;
    } catch (error) {
      debugPrint(
        'Delete schedule error: $error',
      );

      rethrow;
    }
  }
}