import 'package:flutter/material.dart';

class NotificationSetting {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  bool enabled;

  NotificationSetting({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    this.enabled = true,
  });
}

class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String message;
  final String notificationType;
  final String? scheduleId;
  final bool isRead;
  final DateTime? scheduledAt;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.notificationType,
    this.scheduleId,
    required this.isRead,
    this.scheduledAt,
    required this.createdAt,
  });

  factory NotificationModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return NotificationModel(
      id: map['id']?.toString() ?? '',
      userId: map['user_id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      message: map['message']?.toString() ?? '',
      notificationType:
          map['notification_type']?.toString() ??
              'general',
      scheduleId:
          map['schedule_id']?.toString(),
      isRead:
          map['is_read'] as bool? ?? false,
      scheduledAt:
          _parseDateTime(
        map['scheduled_at'],
      ),
      createdAt:
          _parseDateTime(
        map['created_at'],
      ) ??
              DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'message': message,
      'notification_type':
          notificationType,
      'schedule_id': scheduleId,
      'is_read': isRead,
      'scheduled_at':
          scheduledAt
              ?.toUtc()
              .toIso8601String(),
      'created_at':
          createdAt
              .toUtc()
              .toIso8601String(),
    };
  }

  Map<String, dynamic> toInsertMap() {
    return {
      'user_id': userId,
      'title': title,
      'message': message,
      'notification_type':
          notificationType,
      'schedule_id': scheduleId,
      'is_read': isRead,
      'scheduled_at':
          scheduledAt
              ?.toUtc()
              .toIso8601String(),
    };
  }

  NotificationModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? message,
    String? notificationType,
    String? scheduleId,
    bool? isRead,
    DateTime? scheduledAt,
    DateTime? createdAt,
    bool removeScheduleId = false,
    bool removeScheduledAt = false,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      message: message ?? this.message,
      notificationType:
          notificationType ??
              this.notificationType,
      scheduleId: removeScheduleId
          ? null
          : scheduleId ??
              this.scheduleId,
      isRead: isRead ?? this.isRead,
      scheduledAt:
          removeScheduledAt
              ? null
              : scheduledAt ??
                  this.scheduledAt,
      createdAt:
          createdAt ?? this.createdAt,
    );
  }

  static DateTime? _parseDateTime(
    dynamic value,
  ) {
    if (value == null) {
      return null;
    }

    if (value is DateTime) {
      return value;
    }

    return DateTime.tryParse(
      value.toString(),
    );
  }

  @override
  String toString() {
    return 'NotificationModel('
        'id: $id, '
        'userId: $userId, '
        'title: $title, '
        'message: $message, '
        'notificationType: '
        '$notificationType, '
        'scheduleId: $scheduleId, '
        'isRead: $isRead, '
        'scheduledAt: $scheduledAt, '
        'createdAt: $createdAt'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other
            is NotificationModel &&
        other.id == id &&
        other.userId == userId &&
        other.title == title &&
        other.message == message &&
        other.notificationType ==
            notificationType &&
        other.scheduleId == scheduleId &&
        other.isRead == isRead &&
        other.scheduledAt ==
            scheduledAt &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      userId,
      title,
      message,
      notificationType,
      scheduleId,
      isRead,
      scheduledAt,
      createdAt,
    );
  }
}