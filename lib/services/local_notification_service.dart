import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  LocalNotificationService._();

  static final LocalNotificationService instance =
      LocalNotificationService._();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  bool _permissionRequested = false;

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    await _configureLocalTimezone();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const DarwinInitializationSettings iosSettings =
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

    const DarwinInitializationSettings macOsSettings =
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

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      macOS: macOsSettings,
    );

    final bool? initialized =
        await _notifications.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse:
          _handleNotificationTap,
    );

    _isInitialized = initialized ?? true;

    debugPrint(
      'Local notifications initialized: '
      '$_isInitialized',
    );
  }

  Future<void> _configureLocalTimezone() async {
    tz.initializeTimeZones();

    try {
      final TimezoneInfo timezoneInfo =
          await FlutterTimezone.getLocalTimezone();

      tz.setLocalLocation(
        tz.getLocation(
          timezoneInfo.identifier,
        ),
      );

      debugPrint(
        'Local timezone: '
        '${timezoneInfo.identifier}',
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
    }
  }

  void _handleNotificationTap(
    NotificationResponse response,
  ) {
    debugPrint(
      'Notification tapped: '
      '${response.payload}',
    );
  }

  Future<bool> requestPermission() async {
    await initialize();

    if (kIsWeb) {
      debugPrint(
        'Local notifications are not '
        'supported on web.',
      );

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

      debugPrint(
        'Android notification permission: '
        '$granted',
      );

      return granted ?? true;
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

      debugPrint(
        'iOS notification permission: '
        '$granted',
      );

      return granted ?? false;
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

      debugPrint(
        'macOS notification permission: '
        '$granted',
      );

      return granted ?? false;
    }

    _permissionRequested = true;

    return true;
  }

  Future<bool> _ensurePermission() async {
    if (!_permissionRequested) {
      return requestPermission();
    }

    return true;
  }

  int _createNotificationId() {
    return DateTime.now()
        .millisecondsSinceEpoch
        .remainder(
          2147483647,
        );
  }

  Future<void> showTestNotification() async {
    await initialize();

    final bool permissionGranted =
        await _ensurePermission();

    if (!permissionGranted) {
      debugPrint(
        'Test notification was not shown '
        'because permission was denied.',
      );

      return;
    }

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'focusflow_test',
      'FocusFlow Test',
      channelDescription:
          'Test notifications for FocusFlow',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const DarwinNotificationDetails darwinDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      presentBanner: true,
      presentList: true,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );

    await _notifications.show(
      id: _createNotificationId(),
      title: 'FocusFlow',
      body:
          'Your notification pop-up is working.',
      notificationDetails:
          notificationDetails,
      payload: 'test_notification',
    );

    debugPrint(
      'Test notification displayed.',
    );
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    await initialize();

    final bool permissionGranted =
        await _ensurePermission();

    if (!permissionGranted) {
      debugPrint(
        'Schedule notification was not created '
        'because permission was denied.',
      );

      return;
    }

    if (!scheduledDate.isAfter(
      DateTime.now(),
    )) {
      throw Exception(
        'Notification time must be in the future.',
      );
    }

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'focusflow_schedule_reminders',
      'Schedule Reminders',
      channelDescription:
          'Notifications for FocusFlow schedules',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const DarwinNotificationDetails darwinDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      presentBanner: true,
      presentList: true,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );

    final tz.TZDateTime notificationTime =
        tz.TZDateTime.from(
      scheduledDate,
      tz.local,
    );

    await _notifications.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: notificationTime,
      notificationDetails:
          notificationDetails,
      androidScheduleMode:
          AndroidScheduleMode.inexactAllowWhileIdle,
      payload: payload,
    );

    debugPrint(
      'Notification scheduled for: '
      '$notificationTime',
    );
  }

  Future<void> showTaskStatusNotification({
    required String title,
    required String body,
    int? id,
  }) async {
    await initialize();

    final bool permissionGranted =
        await _ensurePermission();

    if (!permissionGranted) {
      debugPrint(
        'Task status notification was not shown '
        'because permission was denied.',
      );

      return;
    }

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'focusflow_task_status',
      'Task Status',
      channelDescription:
          'Notifications for completed and deleted schedules',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const DarwinNotificationDetails darwinDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      presentBanner: true,
      presentList: true,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );

    final int notificationId =
        id ?? _createNotificationId();

    await _notifications.show(
      id: notificationId,
      title: title,
      body: body,
      notificationDetails:
          notificationDetails,
      payload: 'task_status',
    );

    debugPrint(
      'Task status notification displayed: '
      '$title',
    );
  }

  Future<void> showTaskCompletedNotification({
    required String taskTitle,
  }) async {
    await showTaskStatusNotification(
      title: 'Task Completed',
      body:
          '$taskTitle has been completed successfully.',
    );
  }

  Future<void> showScheduleDeletedNotification({
    required String scheduleTitle,
  }) async {
    await showTaskStatusNotification(
      title: 'Schedule Cancelled',
      body:
          '$scheduleTitle has been deleted from your schedule.',
    );
  }

  Future<void> cancelNotification(
    int id,
  ) async {
    await initialize();

    await _notifications.cancel(
      id: id,
    );
  }

  Future<void> cancelAllNotifications() async {
    await initialize();

    await _notifications.cancelAll();
  }
}