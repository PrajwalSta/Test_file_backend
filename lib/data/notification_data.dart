import 'package:flutter/material.dart';

import '../models/notification_setting.dart';
import '../screens/theme/app_colors.dart';

class NotificationData {
  NotificationData._();

  static final List<NotificationSetting> channels =
      <NotificationSetting>[
    NotificationSetting(
      icon: Icons.notifications_none,
      color: AppColors.primary,
      title: 'Push Notifications',
      subtitle:
          'Real-time alerts on your device',
      enabled: true,
    ),
    NotificationSetting(
      icon: Icons.email_outlined,
      color: AppColors.cyan,
      title: 'Email Notifications',
      subtitle: 'Digest to your inbox',
      enabled: true,
    ),
  ];

  static final List<NotificationSetting> alerts =
      <NotificationSetting>[
    NotificationSetting(
      icon: Icons.schedule,
      color: AppColors.orange,
      title: 'Schedule Reminders',
      subtitle: 'Before events start',
      enabled: true,
    ),
    NotificationSetting(
      icon: Icons.free_breakfast_outlined,
      color: AppColors.red,
      title: 'Break Alerts',
      subtitle: 'Remind to take breaks',
      enabled: true,
    ),
    NotificationSetting(
      icon: Icons.emoji_events_outlined,
      color: AppColors.cyan,
      title: 'Achievements',
      subtitle: 'Badges & milestones',
      enabled: true,
    ),
    NotificationSetting(
      icon: Icons.bar_chart,
      color: AppColors.primary,
      title: 'Weekly Report',
      subtitle: 'Sunday summary email',
      enabled: false,
    ),
  ];

  static final List<NotificationSetting> display =
      <NotificationSetting>[
    NotificationSetting(
      icon: Icons.volume_up_outlined,
      color: AppColors.primary,
      title: 'Notification Sounds',
      subtitle: 'Audio for alerts',
      enabled: true,
    ),
    NotificationSetting(
      icon:
          Icons.circle_notifications_outlined,
      color: AppColors.pink,
      title: 'App Badges',
      subtitle: 'Unread count on icon',
      enabled: true,
    ),
  ];
}