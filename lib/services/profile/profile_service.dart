import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/profile/profile_model.dart';
import 'badge_service.dart';

class ProfileService {
  final SupabaseClient _supabase =
      Supabase.instance.client;

  final BadgeService _badgeService =
      BadgeService();

  String get _userId {
    final String? userId =
        _supabase.auth.currentUser?.id;

    if (userId == null) {
      throw Exception(
        'User is not logged in',
      );
    }

    return userId;
  }

  Future<ProfileModel> getProfile() async {
    final String userId = _userId;

    Map<String, dynamic>? profile =
        await _supabase
            .from('profiles')
            .select()
            .eq(
              'id',
              userId,
            )
            .maybeSingle();

    if (profile == null) {
      await createProfile();
    }

    await syncCompletedTasks();

    await syncFocusMinutes();

    await updateMembershipAndLevel();

    await _badgeService.checkBadges();

    profile =
        await _supabase
            .from('profiles')
            .select()
            .eq(
              'id',
              userId,
            )
            .single();

    debugPrint(
      'Profile loaded after sync: '
      '$profile',
    );

    return ProfileModel.fromMap(
      profile,
    );
  }

  Future<void> updateProfile({
    required String fullName,
    required String bio,
    String? avatarUrl,
  }) async {
    final List<Map<String, dynamic>>
        updatedRows =
        await _supabase
            .from('profiles')
            .update({
              'full_name':
                  fullName.trim(),
              'bio':
                  bio.trim(),
              'avatar_url':
                  avatarUrl,
              'updated_at':
                  DateTime.now()
                      .toUtc()
                      .toIso8601String(),
            })
            .eq(
              'id',
              _userId,
            )
            .select();

    if (updatedRows.isEmpty) {
      throw Exception(
        'Unable to update profile',
      );
    }
  }

  Future<void> createProfile() async {
    final User? user =
        _supabase.auth.currentUser;

    if (user == null) {
      throw Exception(
        'User is not logged in',
      );
    }

    final Map<String, dynamic>?
        existingProfile =
        await _supabase
            .from('profiles')
            .select('id')
            .eq(
              'id',
              user.id,
            )
            .maybeSingle();

    if (existingProfile != null) {
      debugPrint(
        'Profile already exists. '
        'Creation skipped.',
      );

      return;
    }

    final String? metadataName =
        user.userMetadata?['full_name']
            ?.toString()
            .trim();

    final List<Map<String, dynamic>>
        insertedRows =
        await _supabase
            .from('profiles')
            .insert({
              'id':
                  user.id,
              'full_name':
                  metadataName != null &&
                          metadataName.isNotEmpty
                      ? metadataName
                      : 'Project User',
              'bio':
                  'Focused on building better habits ✨',
              'avatar_url':
                  null,
              'membership':
                  'Free',
              'level':
                  1,
              'streak':
                  0,
              'last_login_date':
                  null,
              'completed_tasks':
                  0,
              'focus_minutes':
                  0,
              'updated_at':
                  DateTime.now()
                      .toUtc()
                      .toIso8601String(),
            })
            .select();

    if (insertedRows.isEmpty) {
      throw Exception(
        'Unable to create profile',
      );
    }

    debugPrint(
      'Profile created: '
      '$insertedRows',
    );
  }

  Future<void> updateStatistics({
    required int streak,
    required int completedTasks,
    required int focusMinutes,
    required int level,
  }) async {
    final List<Map<String, dynamic>>
        updatedRows =
        await _supabase
            .from('profiles')
            .update({
              'streak':
                  streak,
              'completed_tasks':
                  completedTasks,
              'focus_minutes':
                  focusMinutes,
              'level':
                  level,
              'updated_at':
                  DateTime.now()
                      .toUtc()
                      .toIso8601String(),
            })
            .eq(
              'id',
              _userId,
            )
            .select();

    if (updatedRows.isEmpty) {
      throw Exception(
        'Unable to update statistics',
      );
    }

    await updateMembershipAndLevel();
    await _badgeService.checkBadges();
  }

  Future<int> updateLoginStreak() async {
    final User? user =
        _supabase.auth.currentUser;

    if (user == null) {
      throw Exception(
        'User is not logged in',
      );
    }

    Map<String, dynamic>? profile =
        await _supabase
            .from('profiles')
            .select(
              'streak, last_login_date',
            )
            .eq(
              'id',
              user.id,
            )
            .maybeSingle();

    if (profile == null) {
      await createProfile();

      profile =
          await _supabase
              .from('profiles')
              .select(
                'streak, last_login_date',
              )
              .eq(
                'id',
                user.id,
              )
              .single();
    }

    final DateTime now =
        DateTime.now();

    final DateTime today =
        DateTime(
      now.year,
      now.month,
      now.day,
    );

    final int currentStreak =
        (profile['streak'] as num?)
                ?.toInt() ??
            0;

    final String? lastLoginValue =
        profile['last_login_date']
            ?.toString();

    int newStreak = currentStreak;

    if (lastLoginValue == null ||
        lastLoginValue.isEmpty) {
      newStreak = 1;
    } else {
      final DateTime? parsedLastLogin =
          DateTime.tryParse(
        lastLoginValue,
      );

      if (parsedLastLogin == null) {
        newStreak = 1;
      } else {
        final DateTime lastLoginDate =
            DateTime(
          parsedLastLogin.year,
          parsedLastLogin.month,
          parsedLastLogin.day,
        );

        final int difference =
            today
                .difference(
                  lastLoginDate,
                )
                .inDays;

        if (difference == 0) {
          newStreak =
              currentStreak == 0
                  ? 1
                  : currentStreak;
        } else if (difference == 1) {
          newStreak =
              currentStreak + 1;
        } else {
          newStreak = 1;
        }
      }
    }

    final String todayValue =
        '${today.year.toString().padLeft(4, '0')}-'
        '${today.month.toString().padLeft(2, '0')}-'
        '${today.day.toString().padLeft(2, '0')}';

    final List<Map<String, dynamic>>
        updatedRows =
        await _supabase
            .from('profiles')
            .update({
              'streak':
                  newStreak,
              'last_login_date':
                  todayValue,
              'updated_at':
                  DateTime.now()
                      .toUtc()
                      .toIso8601String(),
            })
            .eq(
              'id',
              user.id,
            )
            .select(
              'streak, last_login_date',
            );

    if (updatedRows.isEmpty) {
      throw Exception(
        'Unable to update login streak',
      );
    }

    await _badgeService.checkBadges();

    debugPrint(
      'Login streak updated: '
      '$newStreak days',
    );

    return newStreak;
  }

  Future<int> syncCompletedTasks() async {
    final String userId = _userId;

    final List<Map<String, dynamic>>
        completedSchedules =
        await _supabase
            .from('schedules')
            .select('id')
            .eq(
              'user_id',
              userId,
            )
            .eq(
              'completed',
              true,
            );

    final int completedCount =
        completedSchedules.length;

    debugPrint(
      'Current user ID: '
      '$userId',
    );

    debugPrint(
      'Completed schedules: '
      '$completedSchedules',
    );

    debugPrint(
      'Completed count: '
      '$completedCount',
    );

    final List<Map<String, dynamic>>
        updatedRows =
        await _supabase
            .from('profiles')
            .update({
              'completed_tasks':
                  completedCount,
              'updated_at':
                  DateTime.now()
                      .toUtc()
                      .toIso8601String(),
            })
            .eq(
              'id',
              userId,
            )
            .select(
              'id, completed_tasks',
            );

    debugPrint(
      'Updated profile rows: '
      '$updatedRows',
    );

    if (updatedRows.isEmpty) {
      throw Exception(
        'Profile update returned no rows. '
        'Check profile RLS.',
      );
    }

    final int savedCount =
        (updatedRows.first[
                    'completed_tasks']
                as num?)
            ?.toInt() ??
        completedCount;

    debugPrint(
      'Completed tasks synced: '
      '$savedCount',
    );

    return savedCount;
  }

  Future<int> syncFocusMinutes() async {
    final String userId = _userId;

    final List<Map<String, dynamic>>
        completedSchedules =
        await _supabase
            .from('schedules')
            .select(
              'duration_minutes',
            )
            .eq(
              'user_id',
              userId,
            )
            .eq(
              'completed',
              true,
            );

    int totalMinutes = 0;

    for (final Map<String, dynamic> schedule
        in completedSchedules) {
      final int durationMinutes =
          (schedule['duration_minutes']
                  as num?)
              ?.toInt() ??
          0;

      totalMinutes += durationMinutes;
    }

    debugPrint(
      'Completed schedule durations: '
      '$completedSchedules',
    );

    debugPrint(
      'Total focus minutes: '
      '$totalMinutes',
    );

    final List<Map<String, dynamic>>
        updatedRows =
        await _supabase
            .from('profiles')
            .update({
              'focus_minutes':
                  totalMinutes,
              'updated_at':
                  DateTime.now()
                      .toUtc()
                      .toIso8601String(),
            })
            .eq(
              'id',
              userId,
            )
            .select(
              'id, focus_minutes',
            );

    debugPrint(
      'Updated focus minute rows: '
      '$updatedRows',
    );

    if (updatedRows.isEmpty) {
      throw Exception(
        'Unable to update focus minutes. '
        'Check the profiles RLS policies.',
      );
    }

    final int savedMinutes =
        (updatedRows.first[
                    'focus_minutes']
                as num?)
            ?.toInt() ??
        totalMinutes;

    debugPrint(
      'Focus minutes synced: '
      '$savedMinutes',
    );

    return savedMinutes;
  }

  Future<void>
      updateMembershipAndLevel() async {
    final String userId = _userId;

    final Map<String, dynamic> profile =
        await _supabase
            .from('profiles')
            .select(
              'completed_tasks',
            )
            .eq(
              'id',
              userId,
            )
            .single();

    final int completedTasks =
        (profile['completed_tasks']
                    as num?)
                ?.toInt() ??
            0;

    String membership = 'Free';
    int level = 1;

    if (completedTasks >= 100) {
      membership = 'Elite';
      level = 5;
    } else if (completedTasks >= 50) {
      membership = 'Elite';
      level = 4;
    } else if (completedTasks >= 25) {
      membership = 'Pro';
      level = 3;
    } else if (completedTasks >= 10) {
      membership = 'Pro';
      level = 2;
    }

    final List<Map<String, dynamic>>
        updatedRows =
        await _supabase
            .from('profiles')
            .update({
              'membership':
                  membership,
              'level':
                  level,
              'updated_at':
                  DateTime.now()
                      .toUtc()
                      .toIso8601String(),
            })
            .eq(
              'id',
              userId,
            )
            .select(
              'membership, level',
            );

    if (updatedRows.isEmpty) {
      throw Exception(
        'Unable to update membership '
        'and level',
      );
    }

    debugPrint(
      'Membership updated: '
      '$membership',
    );

    debugPrint(
      'Level updated: '
      '$level',
    );
  }

  Future<void>
      incrementCompletedTasks() async {
    await syncCompletedTasks();
    await syncFocusMinutes();
    await updateMembershipAndLevel();
    await _badgeService.checkBadges();
  }

  Future<void> addFocusMinutes(
    int minutes,
  ) async {
    if (minutes <= 0) {
      return;
    }

    Map<String, dynamic>? profile =
        await _supabase
            .from('profiles')
            .select(
              'focus_minutes',
            )
            .eq(
              'id',
              _userId,
            )
            .maybeSingle();

    if (profile == null) {
      await createProfile();

      profile =
          await _supabase
              .from('profiles')
              .select(
                'focus_minutes',
              )
              .eq(
                'id',
                _userId,
              )
              .single();
    }

    final int currentMinutes =
        (profile['focus_minutes']
                    as num?)
                ?.toInt() ??
            0;

    final List<Map<String, dynamic>>
        updatedRows =
        await _supabase
            .from('profiles')
            .update({
              'focus_minutes':
                  currentMinutes +
                      minutes,
              'updated_at':
                  DateTime.now()
                      .toUtc()
                      .toIso8601String(),
            })
            .eq(
              'id',
              _userId,
            )
            .select(
              'focus_minutes',
            );

    if (updatedRows.isEmpty) {
      throw Exception(
        'Unable to update focus minutes',
      );
    }

    await _badgeService.checkBadges();

    debugPrint(
      'Focus minutes updated: '
      '${currentMinutes + minutes}',
    );
  }
}