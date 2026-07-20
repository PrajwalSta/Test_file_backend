import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/privacy/activity_log_model.dart';

class ActivityLogService {
  final SupabaseClient _supabase =
      Supabase.instance.client;

  Future<void> addActivity({
    required String action,
    required String description,
    String iconName = 'history',
  }) async {
    final User? user =
        _supabase.auth.currentUser;

    if (user == null) {
      debugPrint(
        'Activity log failed: no logged-in user.',
      );

      throw Exception(
        'User is not logged in.',
      );
    }

    try {
      debugPrint(
        'Saving activity: $action',
      );

      await _supabase
          .from('activity_logs')
          .insert({
        'user_id': user.id,
        'action': action,
        'description': description,
        'icon_name': iconName,
      });

      debugPrint(
        'Activity saved successfully: $action',
      );
    } on PostgrestException catch (error) {
      debugPrint(
        'Supabase activity log error: ${error.message}',
      );

      throw Exception(
        error.message,
      );
    } catch (error) {
      debugPrint(
        'Activity log error: $error',
      );

      throw Exception(
        'Unable to save activity.',
      );
    }
  }

  Future<List<ActivityLogModel>>
      getActivityLogs() async {
    final User? user =
        _supabase.auth.currentUser;

    if (user == null) {
      throw Exception(
        'User is not logged in.',
      );
    }

    try {
      final List<dynamic> response =
          await _supabase
              .from('activity_logs')
              .select()
              .eq(
                'user_id',
                user.id,
              )
              .order(
                'created_at',
                ascending: false,
              )
              .limit(50);

      debugPrint(
        'Loaded ${response.length} activity records.',
      );

      return response
          .map(
            (item) =>
                ActivityLogModel.fromMap(
              item as Map<String, dynamic>,
            ),
          )
          .toList();
    } on PostgrestException catch (error) {
      debugPrint(
        'Unable to load activity logs: ${error.message}',
      );

      throw Exception(
        error.message,
      );
    }
  }

  Future<void> clearActivityLogs() async {
    final User? user =
        _supabase.auth.currentUser;

    if (user == null) {
      throw Exception(
        'User is not logged in.',
      );
    }

    try {
      await _supabase
          .from('activity_logs')
          .delete()
          .eq(
            'user_id',
            user.id,
          );

      debugPrint(
        'Activity logs cleared successfully.',
      );
    } on PostgrestException catch (error) {
      debugPrint(
        'Unable to clear activity logs: ${error.message}',
      );

      throw Exception(
        error.message,
      );
    }
  }
}