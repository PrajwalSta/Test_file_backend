import 'package:flutter/material.dart';

class ScheduleModel {
  final String? id;
  final String emoji;
  final String title;
  final String time;
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
      category:
          category ?? this.category,
      categoryColor:
          categoryColor ??
              this.categoryColor,
      focusMode:
          focusMode ?? this.focusMode,
      durationMinutes:
          durationMinutes ??
              this.durationMinutes,
      completed:
          completed ?? this.completed,
    );
  }
}