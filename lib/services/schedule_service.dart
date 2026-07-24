import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'local_notification_service.dart';
import 'notification_setting_service.dart';
import 'profile/activity_service.dart';

class ScheduleService {
  final SupabaseClient _supabase =
      Supabase.instance.client;

  final NotificationSettingService
      _notificationSettingService =
      NotificationSettingService();

  final ActivityService _activityService =
      ActivityService();

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

  String _cleanText(
    String value,
  ) {
    return value.trim();
  }

  String _createReminderKey(
    String scheduleId,
  ) {
    return 'schedule_reminder_$scheduleId';
  }

  void _validateScheduleInput({
    required String title,
    required String time,
    required DateTime scheduleDateTime,
    required int durationMinutes,
    required String category,
    required String focusMode,
  }) {
    if (_cleanText(title).isEmpty) {
      throw Exception(
        'Schedule title cannot be empty.',
      );
    }

    if (_cleanText(time).isEmpty) {
      throw Exception(
        'Schedule time cannot be empty.',
      );
    }

    if (durationMinutes <= 0) {
      throw Exception(
        'Duration must be greater than zero.',
      );
    }

    if (_cleanText(category).isEmpty) {
      throw Exception(
        'Schedule category cannot be empty.',
      );
    }

    if (_cleanText(focusMode).isEmpty) {
      throw Exception(
        'Focus mode cannot be empty.',
      );
    }

    final DateTime localScheduleTime =
        scheduleDateTime.isUtc
            ? scheduleDateTime.toLocal()
            : scheduleDateTime;

    if (!localScheduleTime.isAfter(
      DateTime.now(),
    )) {
      throw Exception(
        'Please select a future date and time.',
      );
    }
  }

  int? _parseNotificationId(
    dynamic value,
  ) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
      value.toString(),
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
    _validateScheduleInput(
      title: title,
      time: time,
      scheduleDateTime:
          scheduleDateTime,
      durationMinutes:
          durationMinutes,
      category: category,
      focusMode: focusMode,
    );

    final User user =
        _currentUser;

    final String cleanTitle =
        _cleanText(title);

    final String cleanTime =
        _cleanText(time);

    final String cleanCategory =
        _cleanText(category);

    final String cleanFocusMode =
        _cleanText(focusMode);

    final DateTime localScheduleTime =
        scheduleDateTime.isUtc
            ? scheduleDateTime.toLocal()
            : scheduleDateTime;

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
                'title': cleanTitle,
                'time': cleanTime,
                'scheduled_at':
                    localScheduleTime
                        .toUtc()
                        .toIso8601String(),
                'duration_minutes':
                    durationMinutes,
                'category':
                    cleanCategory,
                'focus_mode':
                    cleanFocusMode,
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
        title: cleanTitle,
        scheduleDateTime:
            localScheduleTime,
      );

      await _supabase
          .from('schedules')
          .update({
            'notification_id':
                notificationId,
          })
          .eq(
            'id',
            scheduleId,
          )
          .eq(
            'user_id',
            user.id,
          );

      await _activityService
          .logScheduleAdded(
        cleanTitle,
      );

      debugPrint(
        'Schedule created successfully.',
      );

      return <String, dynamic>{
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
    } catch (error, stackTrace) {
      debugPrint(
        'Add schedule error: $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  // ==========================================================
  // ADD MULTIPLE SCHEDULES
  // ==========================================================
  Future<Map<String, dynamic>>
      addMultipleSchedules({
    required List<Map<String, dynamic>>
        schedules,
  }) async {
    if (schedules.isEmpty) {
      return <String, dynamic>{
        'imported': 0,
        'failed': 0,
        'rows': <Map<String, dynamic>>[],
        'errors': <String>[],
      };
    }

    final List<Map<String, dynamic>>
        insertedRows =
        <Map<String, dynamic>>[];

    final List<String> errors =
        <String>[];

    for (
      int index = 0;
      index < schedules.length;
      index++
    ) {
      final Map<String, dynamic> row =
          schedules[index];

      try {
        final dynamic rawDateTime =
            row['schedule_date_time'];

        if (rawDateTime == null) {
          throw Exception(
            'Schedule date and time are missing.',
          );
        }

        final DateTime scheduleDateTime;

        if (rawDateTime is DateTime) {
          scheduleDateTime =
              rawDateTime.isUtc
                  ? rawDateTime.toLocal()
                  : rawDateTime;
        } else {
          scheduleDateTime =
              DateTime.parse(
            rawDateTime.toString(),
          ).toLocal();
        }

        final dynamic rawDuration =
            row['duration_minutes'];

        if (rawDuration == null) {
          throw Exception(
            'Duration is missing.',
          );
        }

        final int durationMinutes =
            rawDuration is int
                ? rawDuration
                : int.parse(
                    rawDuration.toString(),
                  );

        final Map<String, dynamic>
            insertedRow =
            await addSchedule(
          title:
              row['title']?.toString() ??
                  '',
          time:
              row['time']?.toString() ??
                  '',
          scheduleDateTime:
              scheduleDateTime,
          durationMinutes:
              durationMinutes,
          category:
              row['category']
                      ?.toString() ??
                  '',
          focusMode:
              row['focus_mode']
                      ?.toString() ??
                  '',
        );

        insertedRows.add(
          insertedRow,
        );
      } catch (error) {
        errors.add(
          'Row ${index + 2}: $error',
        );
      }
    }

    return <String, dynamic>{
      'imported':
          insertedRows.length,
      'failed':
          errors.length,
      'rows':
          insertedRows,
      'errors':
          errors,
    };
  }

  // ==========================================================
  // SCHEDULE LOCAL NOTIFICATION
  // Sends notification 5 minutes before schedule starts.
  // ==========================================================
  Future<void> _scheduleReminder({
    required String scheduleId,
    required int notificationId,
    required String title,
    required DateTime scheduleDateTime,
  }) async {
    try {
      final bool pushEnabled =
          await _notificationSettingService
              .isSettingEnabled(
        settingKey:
            NotificationSettingService
                .pushNotificationsKey,
        defaultValue: true,
      );

      final bool reminderEnabled =
          await _notificationSettingService
              .isSettingEnabled(
        settingKey:
            NotificationSettingService
                .scheduleReminderKey,
        defaultValue: true,
      );

      if (!pushEnabled ||
          !reminderEnabled) {
        debugPrint(
          'Schedule reminder is disabled.',
        );

        return;
      }

      final DateTime now =
          DateTime.now();

      final DateTime localScheduleTime =
          scheduleDateTime.isUtc
              ? scheduleDateTime.toLocal()
              : scheduleDateTime;

      if (!localScheduleTime.isAfter(
        now,
      )) {
        debugPrint(
          'Cannot create reminder because '
          'the schedule time has passed.',
        );

        return;
      }

      DateTime reminderTime =
          localScheduleTime.subtract(
        const Duration(minutes: 5),
      );

      /*
       * If the schedule starts in less than
       * five minutes, show the reminder shortly
       * after the schedule is created.
       */
      if (!reminderTime.isAfter(now)) {
        reminderTime = now.add(
          const Duration(seconds: 2),
        );
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

      /*
       * Cancel an existing reminder first.
       * This prevents duplicate notifications
       * when a schedule is edited.
       */
      await LocalNotificationService
          .instance
          .cancelNotification(
        notificationId,
      );

      await LocalNotificationService
          .instance
          .scheduleNotification(
        id: notificationId,
        title: 'Schedule reminder',
        body:
            '$title starts in 5 minutes.',
        scheduledDate:
            reminderTime,
        payload:
            scheduleId,
      );

      final String reminderKey =
          _createReminderKey(
        scheduleId,
      );

      /*
       * Remove the previous inbox reminder
       * before adding the updated one.
       */
      await _notificationSettingService
          .deleteNotificationByKey(
        reminderKey,
      );

      /*
       * This is inserted now but remains hidden
       * until visibleAt is reached.
       */
      await _notificationSettingService
          .addScheduleReminderNotification(
        scheduleTitle:
            title,
        scheduleId:
            scheduleId,
        notificationKey:
            reminderKey,
        visibleAt:
            reminderTime,
      );

      debugPrint(
        'Schedule starts at: '
        '$localScheduleTime',
      );

      debugPrint(
        'Reminder scheduled at: '
        '$reminderTime',
      );
    } catch (error, stackTrace) {
      debugPrint(
        'Schedule reminder error: '
        '$error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  // ==========================================================
  // GET ALL SCHEDULES
  // ==========================================================
  Future<List<Map<String, dynamic>>>
      getSchedules() async {
    final User? user =
        _supabase.auth.currentUser;

    if (user == null) {
      return <Map<String, dynamic>>[];
    }

    try {
      final List<Map<String, dynamic>>
          schedules =
          await _supabase
              .from('schedules')
              .select()
              .eq(
                'user_id',
                user.id,
              )
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
    } catch (error, stackTrace) {
      debugPrint(
        'Get schedules error: $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  // ==========================================================
  // GET SCHEDULES BETWEEN TWO DATES
  // ==========================================================
  Future<List<Map<String, dynamic>>>
      getSchedulesBetween({
    required DateTime start,
    required DateTime end,
  }) async {
    final User? user =
        _supabase.auth.currentUser;

    if (user == null) {
      return <Map<String, dynamic>>[];
    }

    if (!end.isAfter(start)) {
      throw Exception(
        'End date must be after start date.',
      );
    }

    try {
      final List<Map<String, dynamic>>
          schedules =
          await _supabase
              .from('schedules')
              .select()
              .eq(
                'user_id',
                user.id,
              )
              .gte(
                'scheduled_at',
                start
                    .toUtc()
                    .toIso8601String(),
              )
              .lt(
                'scheduled_at',
                end
                    .toUtc()
                    .toIso8601String(),
              )
              .order(
                'scheduled_at',
                ascending: true,
              );

      return schedules;
    } on PostgrestException catch (error) {
      debugPrint(
        'Get schedules between dates error: '
        '${error.message}',
      );

      rethrow;
    } catch (error, stackTrace) {
      debugPrint(
        'Get schedules between dates error: '
        '$error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
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
  // GET SCHEDULES FOR DATE
  // ==========================================================
  Future<List<Map<String, dynamic>>>
      getSchedulesForDate(
    DateTime date,
  ) async {
    final DateTime localStart =
        _startOfDay(
      date,
    );

    final DateTime localEnd =
        localStart.add(
      const Duration(days: 1),
    );

    return getSchedulesBetween(
      start: localStart,
      end: localEnd,
    );
  }

  // ==========================================================
  // TODAY'S PROGRESS
  // ==========================================================
  Future<Map<String, dynamic>>
      getTodayProgress() async {
    final User? user =
        _supabase.auth.currentUser;

    if (user == null) {
      return <String, dynamic>{
        'total': 0,
        'completed': 0,
        'progress': 0.0,
      };
    }

    final DateTime startOfToday =
        _startOfDay(
      DateTime.now(),
    );

    final DateTime startOfTomorrow =
        startOfToday.add(
      const Duration(days: 1),
    );

    try {
      final List<Map<String, dynamic>>
          schedules =
          await _supabase
              .from('schedules')
              .select(
                'id, completed',
              )
              .eq(
                'user_id',
                user.id,
              )
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
          schedules.where(
        (
          Map<String, dynamic>
              schedule,
        ) {
          return schedule['completed'] ==
              true;
        },
      ).length;

      final double progress =
          total == 0
              ? 0.0
              : completed / total;

      return <String, dynamic>{
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
    } catch (error, stackTrace) {
      debugPrint(
        'Today progress error: $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
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
      final Map<String, dynamic>
          schedule =
          await _supabase
              .from('schedules')
              .select(
                'title, completed, notification_id',
              )
              .eq(
                'id',
                scheduleId,
              )
              .eq(
                'user_id',
                user.id,
              )
              .single();

      final String scheduleTitle =
          schedule['title']
                  ?.toString() ??
              'Schedule';

      final bool wasCompleted =
          schedule['completed'] ==
              true;

      final int? savedNotificationId =
          notificationId ??
              _parseNotificationId(
                schedule[
                    'notification_id'],
              );

      await _supabase
          .from('schedules')
          .update({
            'completed': completed,
          })
          .eq(
            'id',
            scheduleId,
          )
          .eq(
            'user_id',
            user.id,
          );

      if (completed &&
          !wasCompleted) {
        await _activityService
            .logScheduleCompleted(
          scheduleTitle,
        );

        await _notificationSettingService
            .addTaskCompletedNotification(
          scheduleTitle:
              scheduleTitle,
          scheduleId:
              scheduleId,
          notificationKey:
              'task_completed_$scheduleId',
        );
      }

      /*
       * Cancel the upcoming reminder after
       * the schedule is marked completed.
       */
      if (completed &&
          savedNotificationId != null) {
        await LocalNotificationService
            .instance
            .cancelNotification(
          savedNotificationId,
        );
      }

      if (completed) {
        await _notificationSettingService
            .deleteNotificationByKey(
          _createReminderKey(
            scheduleId,
          ),
        );
      }

      debugPrint(
        'Schedule completion updated.',
      );
    } on PostgrestException catch (error) {
      debugPrint(
        'Update completed error: '
        '${error.message}',
      );

      rethrow;
    } catch (error, stackTrace) {
      debugPrint(
        'Update completed error: $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
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
    _validateScheduleInput(
      title: title,
      time: time,
      scheduleDateTime:
          scheduleDateTime,
      durationMinutes:
          durationMinutes,
      category: category,
      focusMode: focusMode,
    );

    final User user =
        _currentUser;

    final String cleanTitle =
        _cleanText(title);

    final DateTime localScheduleTime =
        scheduleDateTime.isUtc
            ? scheduleDateTime.toLocal()
            : scheduleDateTime;

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

      await _notificationSettingService
          .deleteNotificationByKey(
        _createReminderKey(
          scheduleId,
        ),
      );

      await _supabase
          .from('schedules')
          .update({
            'title':
                cleanTitle,
            'time':
                _cleanText(time),
            'scheduled_at':
                localScheduleTime
                    .toUtc()
                    .toIso8601String(),
            'duration_minutes':
                durationMinutes,
            'category':
                _cleanText(category),
            'focus_mode':
                _cleanText(focusMode),
            'notification_id':
                newNotificationId,
          })
          .eq(
            'id',
            scheduleId,
          )
          .eq(
            'user_id',
            user.id,
          );

      await _scheduleReminder(
        scheduleId:
            scheduleId,
        notificationId:
            newNotificationId,
        title:
            cleanTitle,
        scheduleDateTime:
            localScheduleTime,
      );

      debugPrint(
        'Schedule updated successfully.',
      );
    } on PostgrestException catch (error) {
      debugPrint(
        'Update schedule error: '
        '${error.message}',
      );

      rethrow;
    } catch (error, stackTrace) {
      debugPrint(
        'Update schedule error: $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
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
      final Map<String, dynamic>
          schedule =
          await _supabase
              .from('schedules')
              .select(
                'title, notification_id',
              )
              .eq(
                'id',
                scheduleId,
              )
              .eq(
                'user_id',
                user.id,
              )
              .single();

      final String scheduleTitle =
          schedule['title']
                  ?.toString() ??
              'Schedule';

      final int? notificationId =
          _parseNotificationId(
        schedule['notification_id'],
      );

      if (notificationId != null) {
        await LocalNotificationService
            .instance
            .cancelNotification(
          notificationId,
        );
      }

      await _notificationSettingService
          .deleteNotificationByKey(
        _createReminderKey(
          scheduleId,
        ),
      );

      await _supabase
          .from('schedules')
          .delete()
          .eq(
            'id',
            scheduleId,
          )
          .eq(
            'user_id',
            user.id,
          );

      await _activityService
          .logScheduleDeleted(
        scheduleTitle,
      );

      await _notificationSettingService
          .addTaskCancelledNotification(
        scheduleTitle:
            scheduleTitle,
        scheduleId:
            scheduleId,
        notificationKey:
            'task_cancelled_$scheduleId',
      );

      debugPrint(
        'Schedule deleted successfully.',
      );
    } on PostgrestException catch (error) {
      debugPrint(
        'Delete schedule error: '
        '${error.message}',
      );

      rethrow;
    } catch (error, stackTrace) {
      debugPrint(
        'Delete schedule error: $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }
}