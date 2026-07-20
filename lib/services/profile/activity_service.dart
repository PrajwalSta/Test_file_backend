import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ActivityService {
  final SupabaseClient _supabase =
      Supabase.instance.client;

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

  Future<void> addActivity({
    required String action,
    required String description,
    String iconName = 'history',
  }) async {
    try {
      final List<Map<String, dynamic>>
          insertedRows =
          await _supabase
              .from('activity_logs')
              .insert({
                'user_id': _userId,
                'action': action,
                'description': description,
                'icon_name': iconName,
              })
              .select();

      if (insertedRows.isEmpty) {
        throw Exception(
          'Unable to save activity',
        );
      }

      debugPrint(
        'Activity saved: '
        '${insertedRows.first}',
      );
    } on PostgrestException catch (error) {
      debugPrint(
        'Activity database error: '
        '${error.message}',
      );

      throw Exception(
        error.message,
      );
    } catch (error) {
      debugPrint(
        'Activity save error: $error',
      );

      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>>
      getRecentActivities({
    int limit = 10,
  }) async {
    try {
      final List<Map<String, dynamic>>
          activities =
          await _supabase
              .from('activity_logs')
              .select()
              .eq(
                'user_id',
                _userId,
              )
              .order(
                'created_at',
                ascending: false,
              )
              .limit(limit);

      debugPrint(
        'Recent activities loaded: '
        '$activities',
      );

      return activities;
    } on PostgrestException catch (error) {
      debugPrint(
        'Activity load error: '
        '${error.message}',
      );

      throw Exception(
        error.message,
      );
    }
  }

  Future<void> logScheduleAdded(
    String scheduleTitle,
  ) async {
    await addActivity(
      action: 'schedule_added',
      description:
          'A new schedule "$scheduleTitle" was created.',
      iconName: 'calendar_today',
    );
  }

  Future<void> logScheduleCompleted(
    String scheduleTitle,
  ) async {
    await addActivity(
      action: 'schedule_completed',
      description:
          'Schedule "$scheduleTitle" was marked as completed.',
      iconName: 'check_circle',
    );
  }

  Future<void> logScheduleDeleted(
    String scheduleTitle,
  ) async {
    await addActivity(
      action: 'schedule_deleted',
      description:
          'Schedule "$scheduleTitle" was deleted.',
      iconName: 'delete',
    );
  }

  Future<void> logFocusCompleted({
    required String title,
    required int minutes,
  }) async {
    await addActivity(
      action: 'focus_completed',
      description:
          'Completed a $minutes-minute focus session for "$title".',
      iconName: 'computer',
    );
  }

  Future<void> logBadgeUnlocked(
    String badgeName,
  ) async {
    await addActivity(
      action: 'badge_unlocked',
      description:
          'Earned the "$badgeName" badge.',
      iconName: 'emoji_events',
    );
  }

  Future<void> logMembershipChanged(
    String membership,
  ) async {
    await addActivity(
      action: 'membership_changed',
      description:
          'Membership changed to "$membership".',
      iconName: 'star',
    );
  }

  Future<void> logLevelUp(
    int level,
  ) async {
    await addActivity(
      action: 'level_up',
      description:
          'Reached level $level.',
      iconName: 'rocket_launch',
    );
  }

  Future<void> logStreakUpdated(
    int streak,
  ) async {
    await addActivity(
      action: 'streak_updated',
      description:
          '$streak-day streak achieved.',
      iconName: 'local_fire_department',
    );
  }
}