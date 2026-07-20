import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/focus_mode_setting_model.dart';

class FocusModeService {
  final SupabaseClient _supabase =
      Supabase.instance.client;

  String get _userId {
    final User? user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception(
        'User must be logged in.',
      );
    }

    return user.id;
  }

  Future<FocusModeSettingModel>
      loadSettings() async {
    final String userId = _userId;

    final Map<String, dynamic>? response =
        await _supabase
            .from('focus_mode_settings')
            .select()
            .eq('user_id', userId)
            .maybeSingle();

    if (response != null) {
      return FocusModeSettingModel.fromMap(
        response,
      );
    }

    final FocusModeSettingModel defaultSettings =
        FocusModeSettingModel(
      userId: userId,
      focusModeEnabled: false,
      breakIntervalMinutes: 25,
      blockInstagram: true,
      blockTwitter: true,
      blockYoutube: true,
      blockTiktok: false,
      blockWhatsapp: false,
      dndEnabled: true,
      dndStartTime: const TimeOfDay(
        hour: 22,
        minute: 0,
      ),
      dndEndTime: const TimeOfDay(
        hour: 7,
        minute: 0,
      ),
    );

    final Map<String, dynamic> inserted =
        await _supabase
            .from('focus_mode_settings')
            .insert(defaultSettings.toMap())
            .select()
            .single();

    return FocusModeSettingModel.fromMap(
      inserted,
    );
  }

  Future<void> saveSettings({
    required bool focusModeEnabled,
    required int breakIntervalMinutes,
    required bool blockInstagram,
    required bool blockTwitter,
    required bool blockYoutube,
    required bool blockTiktok,
    required bool blockWhatsapp,
    required bool dndEnabled,
    required TimeOfDay dndStartTime,
    required TimeOfDay dndEndTime,
  }) async {
    await _supabase
        .from('focus_mode_settings')
        .upsert(
      {
        'user_id': _userId,
        'focus_mode_enabled':
            focusModeEnabled,
        'break_interval_minutes':
            breakIntervalMinutes,
        'block_instagram':
            blockInstagram,
        'block_twitter':
            blockTwitter,
        'block_youtube':
            blockYoutube,
        'block_tiktok':
            blockTiktok,
        'block_whatsapp':
            blockWhatsapp,
        'dnd_enabled':
            dndEnabled,
        'dnd_start_time':
            _formatTime(dndStartTime),
        'dnd_end_time':
            _formatTime(dndEndTime),
        'updated_at':
            DateTime.now()
                .toUtc()
                .toIso8601String(),
      },
      onConflict: 'user_id',
    );
  }

  String _formatTime(TimeOfDay time) {
    final String hour =
        time.hour.toString().padLeft(2, '0');

    final String minute =
        time.minute.toString().padLeft(2, '0');

    return '$hour:$minute:00';
  }
}