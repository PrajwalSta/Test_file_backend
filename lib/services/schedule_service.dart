import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ScheduleService {
  // Get the Supabase client
  final SupabaseClient _supabase =
      Supabase.instance.client;

  // ==========================================================
  // ADD NEW SCHEDULE
  // ==========================================================
  Future<void> addSchedule({
    required String title,
    required String time,
    required int durationMinutes,
    required String category,
    required String focusMode,
  }) async {
    // Get currently logged in user
    final User? user =
        _supabase.auth.currentUser;

    debugPrint(
      'Current Supabase user: ${user?.email}',
    );

    debugPrint(
      'Current Supabase user ID: ${user?.id}',
    );

    // Stop if user is not logged in
    if (user == null) {
      throw Exception(
        'User is not logged in with Supabase',
      );
    }

    try {
      // Insert new schedule into Supabase
      await _supabase.from('schedules').insert({
        'user_id': user.id,
        'title': title,
        'time': time,
        'duration_minutes':
            durationMinutes,
        'category': category,
        'focus_mode': focusMode,
        'completed': false,
      });

      debugPrint(
        'Schedule inserted successfully',
      );
    } on PostgrestException catch (error) {
      debugPrint(
        'Supabase error: ${error.message}',
      );

      rethrow;
    }
  }

  // ==========================================================
  // GET ALL SCHEDULES
  // ==========================================================
  Future<List<Map<String, dynamic>>>
      getSchedules() async {
    // Get current user
    final User? user =
        _supabase.auth.currentUser;

    if (user == null) {
      return [];
    }

    // Get all schedules for this user
    final List<Map<String, dynamic>> schedules =
        await _supabase
            .from('schedules')
            .select()
            .eq('user_id', user.id)
            .order(
              'created_at',
              ascending: true,
            );

    return schedules;
  }

  // ==========================================================
  // TODAY'S PROGRESS
  // ==========================================================
  Future<Map<String, dynamic>>
      getTodayProgress() async {
    // Get current user
    final User? user =
        _supabase.auth.currentUser;

    if (user == null) {
      return {
        'total': 0,
        'completed': 0,
        'progress': 0.0,
      };
    }

    // Get all schedules for current user
    final List<Map<String, dynamic>> schedules =
        await _supabase
            .from('schedules')
            .select('id, completed')
            .eq('user_id', user.id);

    // Total number of schedules
    final int total = schedules.length;

    // Count completed schedules
    final int completed =
        schedules.where((schedule) {
      return schedule['completed'] == true;
    }).length;

    // Calculate progress
    // Example:
    // 3 completed
    // 5 total
    // progress = 3 / 5 = 0.60
    final double progress =
        total == 0 ? 0.0 : completed / total;

    return {
      'total': total,
      'completed': completed,
      'progress': progress,
    };
  }

  // ==========================================================
  // MARK TASK AS COMPLETED
  // ==========================================================
  Future<void> updateCompleted({
    required String scheduleId,
    required bool completed,
  }) async {
    final User? user =
        _supabase.auth.currentUser;

    if (user == null) {
      throw Exception(
        'User is not logged in',
      );
    }

    // Update completed status
    await _supabase
        .from('schedules')
        .update({
          'completed': completed,
        })
        .eq('id', scheduleId)
        .eq('user_id', user.id);
  }

  // ==========================================================
  // UPDATE SCHEDULE
  // ==========================================================
  Future<void> updateSchedule({
    required String scheduleId,
    required String title,
    required String time,
    required int durationMinutes,
    required String category,
    required String focusMode,
  }) async {
    final User? user =
        _supabase.auth.currentUser;

    if (user == null) {
      throw Exception(
        'User is not logged in',
      );
    }

    // Update schedule information
    await _supabase
        .from('schedules')
        .update({
          'title': title,
          'time': time,
          'duration_minutes':
              durationMinutes,
          'category': category,
          'focus_mode': focusMode,
        })
        .eq('id', scheduleId)
        .eq('user_id', user.id);
  }

  // ==========================================================
  // DELETE SCHEDULE
  // ==========================================================
  Future<void> deleteSchedule(
    String scheduleId,
  ) async {
    final User? user =
        _supabase.auth.currentUser;

    if (user == null) {
      throw Exception(
        'User is not logged in',
      );
    }

    // Delete schedule
    await _supabase
        .from('schedules')
        .delete()
        .eq('id', scheduleId)
        .eq('user_id', user.id);
  }
}