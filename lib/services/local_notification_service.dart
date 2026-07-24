import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'notification_setting_service.dart';

class LocalNotificationService {
  LocalNotificationService._();

  static final LocalNotificationService instance =
      LocalNotificationService._();

  final FlutterLocalNotificationsPlugin
      _notifications =
      FlutterLocalNotificationsPlugin();

  final NotificationSettingService
      _notificationSettingService =
      NotificationSettingService();

  bool _isInitialized = false;
  bool _permissionRequested = false;
  bool _permissionGranted = false;

  // ==========================================================
  // INITIALIZE NOTIFICATIONS
  // ==========================================================
  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    if (kIsWeb) {
      debugPrint(
        'Local notifications are not supported on web.',
      );

      return;
    }

    await _configureLocalTimezone();

    const AndroidInitializationSettings
        androidSettings =
        AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const DarwinInitializationSettings
        iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
      defaultPresentBanner: true,
      defaultPresentList: true,
    );

    const DarwinInitializationSettings
        macOsSettings =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
      defaultPresentBanner: true,
      defaultPresentList: true,
    );

    const InitializationSettings
        initializationSettings =
        InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      macOS: macOsSettings,
    );

    final bool? initialized =
        await _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          _handleNotificationTap,
    );

    _isInitialized = initialized ?? true;

    debugPrint(
      'Local notifications initialized: '
      '$_isInitialized',
    );
  }

  // ==========================================================
  // TIMEZONE CONFIGURATION
  // ==========================================================
  Future<void> _configureLocalTimezone() async {
    tz.initializeTimeZones();

    try {
      final dynamic timezoneResult =
          await FlutterTimezone
              .getLocalTimezone();

      final String timezoneName;

      if (timezoneResult is String) {
        timezoneName =
            timezoneResult;
      } else {
        timezoneName =
            timezoneResult.identifier
                .toString();
      }

      tz.setLocalLocation(
        tz.getLocation(
          timezoneName,
        ),
      );

      debugPrint(
        'Local timezone configured: '
        '$timezoneName',
      );
    } catch (error) {
      debugPrint(
        'Could not load device timezone: '
        '$error',
      );

      tz.setLocalLocation(
        tz.getLocation(
          'Australia/Sydney',
        ),
      );

      debugPrint(
        'Fallback timezone used: '
        'Australia/Sydney',
      );
    }
  }

  // ==========================================================
  // NOTIFICATION TAP
  // ==========================================================
  void _handleNotificationTap(
    NotificationResponse response,
  ) {
    debugPrint(
      'Notification tapped.',
    );

    debugPrint(
      'Payload: ${response.payload}',
    );

    debugPrint(
      'Action ID: ${response.actionId}',
    );
  }

  // ==========================================================
  // PERMISSION HANDLING
  // ==========================================================
  Future<bool> requestPermission() async {
    await initialize();

    if (kIsWeb) {
      return false;
    }

    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin?
          androidPlugin =
          _notifications
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>();

      final bool? granted =
          await androidPlugin
              ?.requestNotificationsPermission();

      _permissionRequested = true;
      _permissionGranted =
          granted ?? true;

      debugPrint(
        'Android notification permission: '
        '$_permissionGranted',
      );

      return _permissionGranted;
    }

    if (Platform.isIOS) {
      final IOSFlutterLocalNotificationsPlugin?
          iosPlugin =
          _notifications
              .resolvePlatformSpecificImplementation<
                  IOSFlutterLocalNotificationsPlugin>();

      final bool? granted =
          await iosPlugin?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

      _permissionRequested = true;
      _permissionGranted =
          granted ?? false;

      debugPrint(
        'iOS notification permission: '
        '$_permissionGranted',
      );

      return _permissionGranted;
    }

    if (Platform.isMacOS) {
      final MacOSFlutterLocalNotificationsPlugin?
          macOsPlugin =
          _notifications
              .resolvePlatformSpecificImplementation<
                  MacOSFlutterLocalNotificationsPlugin>();

      final bool? granted =
          await macOsPlugin?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

      _permissionRequested = true;
      _permissionGranted =
          granted ?? false;

      debugPrint(
        'macOS notification permission: '
        '$_permissionGranted',
      );

      return _permissionGranted;
    }

    _permissionRequested = true;
    _permissionGranted = true;

    return true;
  }

  Future<bool> _ensurePermission() async {
    if (!_permissionRequested) {
      return requestPermission();
    }

    return _permissionGranted;
  }

  // ==========================================================
  // NOTIFICATION ID HELPERS
  // ==========================================================
  int _createNotificationId() {
    return DateTime.now()
        .millisecondsSinceEpoch
        .remainder(
          2147483647,
        );
  }

  String _createNotificationKey({
    required String type,
    required int notificationId,
  }) {
    return '${type}_$notificationId';
  }

  // ==========================================================
  // BUILD NOTIFICATION DETAILS
  //
  // Reads Notification Sounds and App Badges settings.
  // ==========================================================
  Future<NotificationDetails>
      _buildNotificationDetails({
    required String channelType,
  }) async {
    final bool soundEnabled =
        await _notificationSettingService
            .isNotificationSoundEnabled();

    final bool badgeEnabled =
        await _notificationSettingService
            .isAppBadgesEnabled();

    final String androidChannelId;

    final String androidChannelName;

    final String channelDescription;

    if (channelType ==
        'schedule') {
      androidChannelId =
          soundEnabled
              ? 'focusflow_schedule_sound'
              : 'focusflow_schedule_silent';

      androidChannelName =
          soundEnabled
              ? 'Schedule Reminders'
              : 'Silent Schedule Reminders';

      channelDescription =
          'Notifications for upcoming '
          'FocusFlow schedules';
    } else if (
        channelType ==
        'test') {
      androidChannelId =
          soundEnabled
              ? 'focusflow_test_sound'
              : 'focusflow_test_silent';

      androidChannelName =
          soundEnabled
              ? 'FocusFlow Test'
              : 'Silent FocusFlow Test';

      channelDescription =
          'Test notifications for FocusFlow';
    } else {
      androidChannelId =
          soundEnabled
              ? 'focusflow_task_status_sound'
              : 'focusflow_task_status_silent';

      androidChannelName =
          soundEnabled
              ? 'Task Status'
              : 'Silent Task Status';

      channelDescription =
          'Notifications for completed '
          'and deleted schedules';
    }

    final AndroidNotificationDetails
        androidDetails =
        AndroidNotificationDetails(
      androidChannelId,
      androidChannelName,
      channelDescription:
          channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      playSound:
          soundEnabled,
      enableVibration: true,
      enableLights: true,
      showWhen: true,
      number:
          badgeEnabled ? 1 : 0,
    );

    final DarwinNotificationDetails
        darwinDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBanner: true,
      presentList: true,
      presentSound:
          soundEnabled,
      presentBadge:
          badgeEnabled,
      badgeNumber:
          badgeEnabled ? 1 : 0,
    );

    return NotificationDetails(
      android:
          androidDetails,
      iOS:
          darwinDetails,
      macOS:
          darwinDetails,
    );
  }

  // ==========================================================
  // SAVE TO SUPABASE NOTIFICATION INBOX
  // ==========================================================
  Future<void> _saveToInbox({
    required String title,
    required String message,
    required String type,
    required int notificationId,
    String? scheduleId,
    String? notificationKey,
    DateTime? visibleAt,
  }) async {
    try {
      final String key =
          notificationKey ??
              _createNotificationKey(
                type: type,
                notificationId:
                    notificationId,
              );

      await _notificationSettingService
          .addNotification(
        title: title,
        message: message,
        type: type,
        scheduleId:
            scheduleId,
        notificationKey:
            key,
        visibleAt:
            visibleAt,
      );

      debugPrint(
        'Notification saved to inbox: '
        '$title',
      );

      debugPrint(
        'Notification key: $key',
      );

      debugPrint(
        'Notification visible at: '
        '${visibleAt ?? DateTime.now()}',
      );
    } catch (error, stackTrace) {
      debugPrint(
        'Could not save notification '
        'to inbox: $error',
      );

      debugPrintStack(
        stackTrace:
            stackTrace,
      );
    }
  }

  // ==========================================================
  // TEST NOTIFICATION
  // ==========================================================
  Future<void>
      showTestNotification() async {
    await initialize();

    final bool pushEnabled =
        await _notificationSettingService
            .isSettingEnabled(
      settingKey:
          NotificationSettingService
              .pushNotificationsKey,
      defaultValue: true,
    );

    if (!pushEnabled) {
      debugPrint(
        'Push notifications are disabled.',
      );

      return;
    }

    final int notificationId =
        _createNotificationId();

    const String title =
        'FocusFlow';

    const String message =
        'Your notification pop-up is working.';

    await _saveToInbox(
      title: title,
      message: message,
      type:
          'test_notification',
      notificationId:
          notificationId,
      notificationKey:
          'test_notification_$notificationId',
      visibleAt:
          DateTime.now(),
    );

    final bool permissionGranted =
        await _ensurePermission();

    if (!permissionGranted) {
      debugPrint(
        'Test notification not shown '
        'because permission was denied.',
      );

      return;
    }

    final NotificationDetails
        notificationDetails =
        await _buildNotificationDetails(
      channelType:
          'test',
    );

    await _notifications.show(
      notificationId,
      title,
      message,
      notificationDetails,
      payload:
          'test_notification',
    );

    debugPrint(
      'Test notification displayed.',
    );
  }

  // ==========================================================
  // SCHEDULE REMINDER
  //
  // ScheduleService calculates the time 5 minutes early.
  //
  // saveToInbox defaults to false because ScheduleService
  // already creates the Supabase inbox reminder.
  // ==========================================================
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    String type =
        NotificationSettingService
            .scheduleReminderKey,
    String? scheduleId,
    bool saveToInbox = false,
  }) async {
    await initialize();

    final DateTime localScheduledDate =
        scheduledDate.isUtc
            ? scheduledDate.toLocal()
            : scheduledDate;

    if (!localScheduledDate.isAfter(
      DateTime.now(),
    )) {
      throw Exception(
        'Notification time must be '
        'in the future.',
      );
    }

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
            .isScheduleReminderEnabled();

    if (!pushEnabled ||
        !reminderEnabled) {
      debugPrint(
        'Schedule reminder notifications '
        'are disabled.',
      );

      return;
    }

    final String notificationKey =
        scheduleId != null &&
                scheduleId.trim().isNotEmpty
            ? 'schedule_reminder_${scheduleId.trim()}'
            : 'schedule_reminder_$id';

    /*
     * Only save here when specifically requested.
     *
     * Your ScheduleService already saves the
     * reminder with visibleAt, so leaving this
     * false prevents duplicate inbox rows.
     */
    if (saveToInbox) {
      await _saveToInbox(
        title: title,
        message: body,
        type: type,
        notificationId:
            id,
        scheduleId:
            scheduleId,
        notificationKey:
            notificationKey,
        visibleAt:
            localScheduledDate,
      );
    }

    final bool permissionGranted =
        await _ensurePermission();

    if (!permissionGranted) {
      debugPrint(
        'Phone reminder was not created '
        'because permission was denied.',
      );

      return;
    }

    final NotificationDetails
        notificationDetails =
        await _buildNotificationDetails(
      channelType:
          'schedule',
    );

    final tz.TZDateTime
        notificationTime =
        tz.TZDateTime.from(
      localScheduledDate,
      tz.local,
    );

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      notificationTime,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation
              .absoluteTime,

      /*
       * exactAllowWhileIdle gives a more exact
       * reminder time than inexactAllowWhileIdle.
       */
      androidScheduleMode:
          AndroidScheduleMode
              .exactAllowWhileIdle,
      payload:
          payload ??
              (
                scheduleId == null
                    ? 'schedule_reminder'
                    : 'schedule_reminder:$scheduleId'
              ),
    );

    debugPrint(
      'Phone notification scheduled for: '
      '$notificationTime',
    );
  }

  // ==========================================================
  // GENERAL IMMEDIATE TASK NOTIFICATION
  // ==========================================================
  Future<void>
      showTaskStatusNotification({
    required String title,
    required String body,
    required String type,
    int? id,
    String? scheduleId,
    String? payload,
    String? notificationKey,
  }) async {
    await initialize();

    final bool pushEnabled =
        await _notificationSettingService
            .isSettingEnabled(
      settingKey:
          NotificationSettingService
              .pushNotificationsKey,
      defaultValue: true,
    );

    final int notificationId =
        id ??
            _createNotificationId();

    /*
     * Save to the in-app inbox even if phone
     * push notifications are disabled.
     */
    await _saveToInbox(
      title: title,
      message: body,
      type: type,
      notificationId:
          notificationId,
      scheduleId:
          scheduleId,
      notificationKey:
          notificationKey,
      visibleAt:
          DateTime.now(),
    );

    if (!pushEnabled) {
      debugPrint(
        'Push notifications are disabled. '
        'Notification saved only to inbox.',
      );

      return;
    }

    final bool permissionGranted =
        await _ensurePermission();

    if (!permissionGranted) {
      debugPrint(
        'Task notification not shown '
        'because permission was denied.',
      );

      return;
    }

    final NotificationDetails
        notificationDetails =
        await _buildNotificationDetails(
      channelType:
          'task',
    );

    await _notifications.show(
      notificationId,
      title,
      body,
      notificationDetails,
      payload:
          payload ??
              'task_status',
    );

    debugPrint(
      'Task notification displayed: '
      '$title',
    );
  }

  // ==========================================================
  // TASK COMPLETED NOTIFICATION
  // ==========================================================
  Future<void>
      showTaskCompletedNotification({
    required String taskTitle,
    String? scheduleId,
    int? id,
  }) async {
    final bool enabled =
        await _notificationSettingService
            .isTaskCompletedNotificationEnabled();

    if (!enabled) {
      debugPrint(
        'Task completed notifications '
        'are disabled.',
      );

      return;
    }

    final int notificationId =
        id ??
            _createNotificationId();

    await showTaskStatusNotification(
      id:
          notificationId,
      title:
          'Task Completed',
      body:
          '$taskTitle has been completed '
          'successfully.',
      type:
          NotificationSettingService
              .taskCompletedKey,
      scheduleId:
          scheduleId,
      notificationKey:
          scheduleId == null
              ? 'task_completed_$notificationId'
              : 'task_completed_$scheduleId',
      payload:
          scheduleId == null
              ? 'task_completed'
              : 'task_completed:$scheduleId',
    );
  }

  // ==========================================================
  // SCHEDULE DELETED NOTIFICATION
  // ==========================================================
  Future<void>
      showScheduleDeletedNotification({
    required String scheduleTitle,
    String? scheduleId,
    int? id,
  }) async {
    final bool enabled =
        await _notificationSettingService
            .isTaskCancelledNotificationEnabled();

    if (!enabled) {
      debugPrint(
        'Task cancelled notifications '
        'are disabled.',
      );

      return;
    }

    final int notificationId =
        id ??
            _createNotificationId();

    await showTaskStatusNotification(
      id:
          notificationId,
      title:
          'Schedule Cancelled',
      body:
          '$scheduleTitle has been deleted '
          'from your schedule.',
      type:
          NotificationSettingService
              .taskCancelledKey,

      /*
       * Keep this null to avoid a foreign-key
       * issue after the schedule is deleted.
       */
      scheduleId:
          null,
      notificationKey:
          scheduleId == null
              ? 'task_cancelled_$notificationId'
              : 'task_cancelled_$scheduleId',
      payload:
          scheduleId == null
              ? 'task_cancelled'
              : 'task_cancelled:$scheduleId',
    );
  }

  // ==========================================================
  // CUSTOM NOTIFICATION
  // ==========================================================
  Future<void> showAndSaveNotification({
    required String title,
    required String body,
    required String type,
    String? scheduleId,
    String? payload,
    String? notificationKey,
    int? id,
  }) async {
    await showTaskStatusNotification(
      id:
          id,
      title:
          title,
      body:
          body,
      type:
          type,
      scheduleId:
          scheduleId,
      payload:
          payload,
      notificationKey:
          notificationKey,
    );
  }

  // ==========================================================
  // CANCEL ONE NOTIFICATION
  // ==========================================================
  Future<void> cancelNotification(
    int id, {
    String? notificationKey,
  }) async {
    await initialize();

    await _notifications.cancel(
      id,
    );

    if (notificationKey != null &&
        notificationKey
            .trim()
            .isNotEmpty) {
      try {
        await _notificationSettingService
            .deleteNotificationByKey(
          notificationKey.trim(),
        );
      } catch (error) {
        debugPrint(
          'Could not delete cancelled '
          'notification from inbox: $error',
        );
      }
    }

    debugPrint(
      'Local notification cancelled: $id',
    );
  }

  // ==========================================================
  // CANCEL SCHEDULE NOTIFICATION
  // ==========================================================
  Future<void>
      cancelScheduleNotification({
    required int notificationId,
    required String scheduleId,
  }) async {
    await initialize();

    await _notifications.cancel(
      notificationId,
    );

    try {
      await _notificationSettingService
          .deleteNotificationByKey(
        'schedule_reminder_$scheduleId',
      );
    } catch (error) {
      debugPrint(
        'Could not remove schedule reminder '
        'from inbox: $error',
      );
    }

    debugPrint(
      'Schedule notification cancelled: '
      '$notificationId',
    );
  }

  // ==========================================================
  // CANCEL ALL NOTIFICATIONS
  // ==========================================================
  Future<void> cancelAllNotifications({
    bool clearInbox = false,
  }) async {
    await initialize();

    await _notifications.cancelAll();

    if (clearInbox) {
      try {
        await _notificationSettingService
            .deleteAllNotifications();
      } catch (error) {
        debugPrint(
          'Could not clear notification inbox: '
          '$error',
        );
      }
    }

    debugPrint(
      'All local notifications cancelled.',
    );
  }

  // ==========================================================
  // GET PENDING NOTIFICATIONS
  //
  // Useful for testing whether the 5-minute reminder exists.
  // ==========================================================
  Future<List<PendingNotificationRequest>>
      getPendingNotifications() async {
    await initialize();

    final List<PendingNotificationRequest>
        pendingNotifications =
        await _notifications
            .pendingNotificationRequests();

    debugPrint(
      'Pending local notifications: '
      '${pendingNotifications.length}',
    );

    for (
      final PendingNotificationRequest
          notification
      in pendingNotifications
    ) {
      debugPrint(
        'Pending ID: ${notification.id}, '
        'title: ${notification.title}, '
        'payload: ${notification.payload}',
      );
    }

    return pendingNotifications;
  }
}