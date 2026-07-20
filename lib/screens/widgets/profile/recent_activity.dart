import 'package:flutter/material.dart';

import '../../../models/activity_model.dart';
import '../../../services/profile/activity_service.dart';
import 'activity_tile.dart';

class RecentActivity extends StatefulWidget {
  const RecentActivity({
    super.key,
  });

  @override
  State<RecentActivity> createState() =>
      _RecentActivityState();
}

class _RecentActivityState
    extends State<RecentActivity> {
  final ActivityService _activityService =
      ActivityService();

  bool _isLoading = true;
  String? _errorMessage;

  List<ActivityModel> _activities = [];

  @override
  void initState() {
    super.initState();

    _loadActivities();
  }

  Future<void> _loadActivities() async {
    try {
      if (mounted) {
        setState(() {
          _isLoading = true;
          _errorMessage = null;
        });
      }

      final List<Map<String, dynamic>>
          activityRows =
          await _activityService
              .getRecentActivities();

      final List<ActivityModel>
          loadedActivities =
          activityRows.map(
        (Map<String, dynamic> activity) {
          final String activityType =
              activity['activity_type']
                      ?.toString() ??
                  '';

          final String? createdAtValue =
              activity['created_at']
                  ?.toString();

          final DateTime? createdAt =
              createdAtValue == null
                  ? null
                  : DateTime.tryParse(
                      createdAtValue,
                    )?.toLocal();

          return ActivityModel(
            emoji:
                activity['icon']
                        ?.toString() ??
                    _getActivityEmoji(
                      activityType,
                    ),
            title:
                activity['title']
                        ?.toString() ??
                    'Activity',
            time:
                _formatActivityTime(
              createdAt,
            ),
          );
        },
      ).toList();

      if (!mounted) {
        return;
      }

      setState(() {
        _activities =
            loadedActivities;
        _isLoading = false;
      });
    } catch (error) {
      debugPrint(
        'Unable to load recent activities: '
        '$error',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage =
            'Unable to load recent activity';
      });
    }
  }

  String _getActivityEmoji(
    String activityType,
  ) {
    switch (activityType) {
      case 'schedule_added':
        return '📅';

      case 'schedule_completed':
        return '✅';

      case 'schedule_deleted':
        return '🗑️';

      case 'focus_completed':
        return '💻';

      case 'badge_unlocked':
        return '🏆';

      case 'membership_changed':
        return '⭐';

      case 'level_up':
        return '🚀';

      case 'streak_updated':
        return '🔥';

      default:
        return '✨';
    }
  }

  String _formatActivityTime(
    DateTime? createdAt,
  ) {
    if (createdAt == null) {
      return '';
    }

    final DateTime now =
        DateTime.now();

    final Duration difference =
        now.difference(
      createdAt,
    );

    if (difference.inSeconds < 60) {
      return 'Just now';
    }

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    }

    if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    }

    if (difference.inDays == 1) {
      return 'Yesterday';
    }

    if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    }

    return '${createdAt.day.toString().padLeft(2, '0')}/'
        '${createdAt.month.toString().padLeft(2, '0')}/'
        '${createdAt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'RECENT ACTIVITY',
                style: TextStyle(
                  color: colorScheme
                      .onSurfaceVariant,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed:
                    _isLoading
                        ? null
                        : _loadActivities,
                tooltip:
                    'Refresh activity',
                icon:
                    const Icon(
                  Icons.refresh,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(
                  24,
                ),
                child:
                    CircularProgressIndicator(),
              ),
            )
          else if (_errorMessage != null)
            Center(
              child: Column(
                children: [
                  Text(
                    _errorMessage!,
                    style: TextStyle(
                      color:
                          colorScheme.error,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextButton.icon(
                    onPressed:
                        _loadActivities,
                    icon:
                        const Icon(
                      Icons.refresh,
                    ),
                    label:
                        const Text(
                      'Try again',
                    ),
                  ),
                ],
              ),
            )
          else if (_activities.isEmpty)
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.all(
                20,
              ),
              decoration: BoxDecoration(
                color: colorScheme
                    .surfaceContainerHighest
                    .withValues(
                  alpha: 0.35,
                ),
                borderRadius:
                    BorderRadius.circular(
                  16,
                ),
              ),
              child: Text(
                'No recent activity yet.',
                textAlign:
                    TextAlign.center,
                style: TextStyle(
                  color: colorScheme
                      .onSurfaceVariant,
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(),
              itemCount:
                  _activities.length,
              separatorBuilder: (
                BuildContext context,
                int index,
              ) {
                return const SizedBox(
                  height: 12,
                );
              },
              itemBuilder: (
                BuildContext context,
                int index,
              ) {
                return ActivityTile(
                  activity:
                      _activities[index],
                );
              },
            ),
        ],
      ),
    );
  }
}