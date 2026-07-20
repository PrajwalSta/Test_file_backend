import 'package:flutter/material.dart';

class FocusModeSettingModel {
  final String? id;
  final String userId;

  final bool focusModeEnabled;
  final int breakIntervalMinutes;

  final bool blockInstagram;
  final bool blockTwitter;
  final bool blockYoutube;
  final bool blockTiktok;
  final bool blockWhatsapp;

  final bool dndEnabled;
  final TimeOfDay dndStartTime;
  final TimeOfDay dndEndTime;

  const FocusModeSettingModel({
    this.id,
    required this.userId,
    required this.focusModeEnabled,
    required this.breakIntervalMinutes,
    required this.blockInstagram,
    required this.blockTwitter,
    required this.blockYoutube,
    required this.blockTiktok,
    required this.blockWhatsapp,
    required this.dndEnabled,
    required this.dndStartTime,
    required this.dndEndTime,
  });

  factory FocusModeSettingModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return FocusModeSettingModel(
      id: map['id'] as String?,
      userId: map['user_id'] as String,
      focusModeEnabled:
          map['focus_mode_enabled'] as bool? ?? false,
      breakIntervalMinutes:
          map['break_interval_minutes'] as int? ?? 25,
      blockInstagram:
          map['block_instagram'] as bool? ?? true,
      blockTwitter:
          map['block_twitter'] as bool? ?? true,
      blockYoutube:
          map['block_youtube'] as bool? ?? true,
      blockTiktok:
          map['block_tiktok'] as bool? ?? false,
      blockWhatsapp:
          map['block_whatsapp'] as bool? ?? false,
      dndEnabled:
          map['dnd_enabled'] as bool? ?? true,
      dndStartTime: _parseTime(
        map['dnd_start_time'] as String? ?? '22:00:00',
      ),
      dndEndTime: _parseTime(
        map['dnd_end_time'] as String? ?? '07:00:00',
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'focus_mode_enabled': focusModeEnabled,
      'break_interval_minutes':
          breakIntervalMinutes,
      'block_instagram': blockInstagram,
      'block_twitter': blockTwitter,
      'block_youtube': blockYoutube,
      'block_tiktok': blockTiktok,
      'block_whatsapp': blockWhatsapp,
      'dnd_enabled': dndEnabled,
      'dnd_start_time': _formatTime(dndStartTime),
      'dnd_end_time': _formatTime(dndEndTime),
      'updated_at':
          DateTime.now().toUtc().toIso8601String(),
    };
  }

  static TimeOfDay _parseTime(String value) {
    final List<String> parts = value.split(':');

    return TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 0,
      minute: int.tryParse(parts[1]) ?? 0,
    );
  }

  static String _formatTime(TimeOfDay time) {
    final String hour =
        time.hour.toString().padLeft(2, '0');

    final String minute =
        time.minute.toString().padLeft(2, '0');

    return '$hour:$minute:00';
  }
}