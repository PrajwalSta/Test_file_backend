import 'package:flutter/material.dart';

class ScheduleModel {
  final String emoji;
  final String title;
  final String time;
  final String category;
  final Color categoryColor;
  final String focusMode;
  final int durationMinutes;

  const ScheduleModel({
    required this.emoji,
    required this.title,
    required this.time,
    required this.category,
    required this.categoryColor,
    required this.focusMode,
    required this.durationMinutes,
  });

  ScheduleModel copyWith({
    String? emoji,
    String? title,
    String? time,
    String? category,
    Color? categoryColor,
    String? focusMode,
    int? durationMinutes,
  }) {
    return ScheduleModel(
      emoji: emoji ?? this.emoji,
      title: title ?? this.title,
      time: time ?? this.time,
      category: category ?? this.category,
      categoryColor: categoryColor ?? this.categoryColor,
      focusMode: focusMode ?? this.focusMode,
      durationMinutes: durationMinutes ?? this.durationMinutes,
    );
  }
}