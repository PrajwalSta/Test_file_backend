import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BadgeService {
  final SupabaseClient _supabase =
      Supabase.instance.client;

  String get _userId {
    final String? userId =
        _supabase.auth.currentUser?.id;

    if (userId == null) {
      throw Exception('User not logged in');
    }

    return userId;
  }

  Future<void> checkBadges() async {
    final profile =
        await _supabase
            .from('profiles')
            .select(
              'streak, completed_tasks, focus_minutes',
            )
            .eq('id', _userId)
            .single();

    final int streak =
        (profile['streak'] as num?)?.toInt() ??
            0;

    final int completedTasks =
        (profile['completed_tasks'] as num?)
                ?.toInt() ??
            0;

    final int focusHours =
        ((profile['focus_minutes'] as num?)
                    ?.toInt() ??
                0) ~/
            60;

    await _saveBadge(
      key: 'early_bird',
      name: 'Early Bird',
      unlocked: completedTasks >= 10,
    );

    await _saveBadge(
      key: 'night_owl',
      name: 'Night Owl',
      unlocked: focusHours >= 20,
    );

    await _saveBadge(
      key: 'streak_7',
      name: 'Streak 7',
      unlocked: streak >= 7,
    );

    await _saveBadge(
      key: 'focus_100',
      name: 'Focus 100h',
      unlocked: focusHours >= 100,
    );

    await _saveBadge(
      key: 'planner_pro',
      name: 'Planner Pro',
      unlocked: completedTasks >= 50,
    );

    await _saveBadge(
      key: 'zen_master',
      name: 'Zen Master',
      unlocked: streak >= 365,
    );

    debugPrint('Badges checked');
  }

  Future<void> _saveBadge({
    required String key,
    required String name,
    required bool unlocked,
  }) async {
    await _supabase
        .from('badges')
        .upsert(
      {
        'user_id': _userId,
        'badge_key': key,
        'badge_name': name,
        'unlocked': unlocked,
        'unlocked_at': unlocked
            ? DateTime.now()
                .toUtc()
                .toIso8601String()
            : null,
      },
      onConflict: 'user_id,badge_key',
    );
  }

  Future<List<Map<String, dynamic>>>
      getBadges() async {
    return await _supabase
        .from('badges')
        .select()
        .eq('user_id', _userId)
        .order('created_at');
  }
}