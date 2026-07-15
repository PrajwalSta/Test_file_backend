import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ScheduleService {
  final SupabaseClient _supabase =
      Supabase.instance.client;


  Future<void> addSchedule({
    required String title,
    required String time,
    required int durationMinutes,
    required String category,
    required String focusMode,
  }) async {
    final User? user =
        _supabase.auth.currentUser;

    debugPrint(
      'Current Supabase user: ${user?.email}',
    );

    debugPrint(
      'Current Supabase user ID: ${user?.id}',
    );

    if (user == null) {
      throw Exception(
        'User is not logged in with Supabase',
      );
    }

    try {
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

      debugPrint(
        'Error code: ${error.code}',
      );

      debugPrint(
        'Error details: ${error.details}',
      );

      rethrow;
    }
  }

  // Keep getSchedules(), updateSchedule(),
  // updateCompleted(), and deleteSchedule() below.
}