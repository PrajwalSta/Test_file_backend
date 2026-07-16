
import 'package:flutter/material.dart';

class ScheduleModel {
  final String? id;
  final String emoji;
  final String title;
  final String time;
  final DateTime scheduleDate;
  final String category;
  final Color categoryColor;
  final String focusMode;
  final int durationMinutes;
  final bool completed;

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
    );
  }

  factory ScheduleModel.fromMap(
    Map<String, dynamic> map, {
    required Color categoryColor,
    required String emoji,
  }) {
    final String? scheduleDateValue =
        map['schedule_date']?.toString();

    return ScheduleModel(
      id: map['id']?.toString(),
      emoji: emoji,
      title:
          map['title']?.toString() ??
              'Untitled',
      time:
          map['time']?.toString() ??
              '09:00 AM',
      scheduleDate:
          scheduleDateValue != null &&
                  scheduleDateValue.isNotEmpty
              ? DateTime.tryParse(
                    scheduleDateValue,
                  ) ??
                  DateTime.now()
              : DateTime.now(),
      category:
          map['category']?.toString() ??
              'Study',
      categoryColor:
          categoryColor,
      focusMode:
          map['focus_mode']?.toString() ??
              'Study Mode',
      durationMinutes:
          (map['duration_minutes'] as num?)
                  ?.toInt() ??
              int.tryParse(
                map['duration_minutes']
                        ?.toString() ??
                    '',
              ) ??
              0,
      completed:
          map['completed'] == true,
    );
  }

  Map<String, dynamic> toMap({
    String? userId,
    bool includeId = false,
  }) {
    return {
      if (includeId && id != null)
        'id': id,
      'user_id': ?userId,
      'title': title,
      'time': time,
      'schedule_date':
          formatDatabaseDate(
        scheduleDate,
      ),
      'category': category,
      'focus_mode': focusMode,
      'duration_minutes':
          durationMinutes,
      'completed': completed,
    };
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
