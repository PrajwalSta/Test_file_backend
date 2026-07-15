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
    required this.enabled,
  });
}