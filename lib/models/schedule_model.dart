import 'package:flutter/material.dart';

class ScheduleModel {
  final String? id;
  final String emoji;
  final String title;
  final String time;

  // Stores the complete selected date and time.
  final DateTime scheduleDate;

  final String category;
  final Color categoryColor;
  final String focusMode;
  final int durationMinutes;
  final bool completed;

  // Used to cancel or replace the local notification.
  final int? notificationId;

  const ScheduleModel({
    this.id,
    required this.emoji,
    required this.title,
    required this.time,
    required this.scheduleDate,
    required this.category,
    required this.categoryColor,
    required this.focusMode,
    required this.durationMinutes,
    this.completed = false,
    this.notificationId,
  });

  ScheduleModel copyWith({
    String? id,
    String? emoji,
    String? title,
    String? time,
    DateTime? scheduleDate,
    String? category,
    Color? categoryColor,
    String? focusMode,
    int? durationMinutes,
    bool? completed,
    int? notificationId,
    bool removeNotificationId = false,
  }) {
    return ScheduleModel(
      id: id ?? this.id,
      emoji: emoji ?? this.emoji,
      title: title ?? this.title,
      time: time ?? this.time,
      scheduleDate:
          scheduleDate ?? this.scheduleDate,
      category:
          category ?? this.category,
      categoryColor:
          categoryColor ?? this.categoryColor,
      focusMode:
          focusMode ?? this.focusMode,
      durationMinutes:
          durationMinutes ?? this.durationMinutes,
      completed:
          completed ?? this.completed,
      notificationId:
          removeNotificationId
              ? null
              : notificationId ??
                  this.notificationId,
    );
  }

  factory ScheduleModel.fromMap(
    Map<String, dynamic> map, {
    required Color categoryColor,
    required String emoji,
  }) {
    final DateTime scheduleDate =
        _parseScheduleDate(map);

    return ScheduleModel(
      id: map['id']?.toString(),
      emoji: emoji,
      title:
          map['title']?.toString() ??
              'Untitled',
      time:
          map['time']?.toString() ??
              '09:00 AM',
      scheduleDate: scheduleDate,
      category:
          map['category']?.toString() ??
              'Study',
      categoryColor: categoryColor,
      focusMode:
          map['focus_mode']?.toString() ??
              'Study Mode',
      durationMinutes:
          _parseInt(
        map['duration_minutes'],
      ),
      completed:
          map['completed'] == true,
      notificationId:
          map['notification_id'] != null
              ? _parseInt(
                  map['notification_id'],
                )
              : null,
    );
  }

  Map<String, dynamic> toMap({
    String? userId,
    bool includeId = false,
  }) {
    final Map<String, dynamic> data = {
      'title': title,
      'time': time,

      // Keep this if your table still uses schedule_date.
      'schedule_date':
          formatDatabaseDate(
        scheduleDate,
      ),

      // Complete date and time used for notifications.
      'scheduled_at':
          scheduleDate
              .toUtc()
              .toIso8601String(),

      'category': category,
      'focus_mode': focusMode,
      'duration_minutes':
          durationMinutes,
      'completed': completed,
    };

    if (includeId && id != null) {
      data['id'] = id;
    }

    if (userId != null) {
      data['user_id'] = userId;
    }

    if (notificationId != null) {
      data['notification_id'] =
          notificationId;
    }

    return data;
  }

  static DateTime _parseScheduleDate(
    Map<String, dynamic> map,
  ) {
    final dynamic scheduledAtValue =
        map['scheduled_at'];

    if (scheduledAtValue != null) {
      final DateTime? scheduledAt =
          DateTime.tryParse(
        scheduledAtValue.toString(),
      );

      if (scheduledAt != null) {
        return scheduledAt.toLocal();
      }
    }

    final String? scheduleDateValue =
        map['schedule_date']?.toString();

    if (scheduleDateValue != null &&
        scheduleDateValue.isNotEmpty) {
      final DateTime? parsedDate =
          DateTime.tryParse(
        scheduleDateValue,
      );

      if (parsedDate != null) {
        return parsedDate;
      }
    }

    return DateTime.now();
  }

  static int _parseInt(
    dynamic value,
  ) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  static String formatDatabaseDate(
    DateTime date,
  ) {
    final String month =
        date.month
            .toString()
            .padLeft(2, '0');

    final String day =
        date.day
            .toString()
            .padLeft(2, '0');

    return '${date.year}-$month-$day';
  }
}
