import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/world_clock.dart';

class WorldClockService {
  final SupabaseClient _supabase =
      Supabase.instance.client;

  Future<List<WorldClock>> getWorldClocks() async {
    final User? user =
        _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    final List<dynamic> response =
        await _supabase
            .from('world_clocks')
            .select()
            .eq('user_id', user.id)
            .order(
              'sort_order',
              ascending: true,
            )
            .order(
              'created_at',
              ascending: true,
            );

    return response
        .map(
          (dynamic item) =>
              WorldClock.fromMap(
            item as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<WorldClock> addWorldClock({
    required String city,
    required String country,
    required String flag,
    required String timezoneName,
  }) async {
    final User? user =
        _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    final Map<String, dynamic> response =
        await _supabase
            .from('world_clocks')
            .insert({
              'user_id': user.id,
              'city': city,
              'country': country,
              'flag': flag,
              'timezone_name':
                  timezoneName,
              'is_selected': false,
              'sort_order': 0,
            })
            .select()
            .single();

    return WorldClock.fromMap(
      response,
    );
  }

  Future<void> deleteWorldClock(
    String id,
  ) async {
    final User? user =
        _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    await _supabase
        .from('world_clocks')
        .delete()
        .eq('id', id)
        .eq('user_id', user.id);
  }
}