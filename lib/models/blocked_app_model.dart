import 'package:flutter/material.dart';

/// Model representing a blocked application.
class BlockedAppModel {
  final String name;
  final IconData icon;
  bool isBlocked;

  BlockedAppModel({
    required this.name,
    required this.icon,
    this.isBlocked = false,
  });

  /// Sample data
  static List<BlockedAppModel> demoApps = [
    BlockedAppModel(
      name: 'Instagram',
      icon: Icons.camera_alt_rounded,
      isBlocked: true,
    ),
    BlockedAppModel(
      name: 'Twitter',
      icon: Icons.alternate_email_rounded,
      isBlocked: true,
    ),
    BlockedAppModel(
      name: 'YouTube',
      icon: Icons.play_circle_fill_rounded,
      isBlocked: true,
    ),
    BlockedAppModel(
      name: 'TikTok',
      icon: Icons.music_note_rounded,
      isBlocked: false,
    ),
    BlockedAppModel(
      name: 'WhatsApp',
      icon: Icons.chat_rounded,
      isBlocked: false,
    ),
  ];
}