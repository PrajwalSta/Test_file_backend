import 'package:flutter/material.dart';

/// ===========================================================
/// SecuritySetting Model
/// ===========================================================

class SecuritySetting {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  bool enabled;

  SecuritySetting({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.enabled = false,
  });
}