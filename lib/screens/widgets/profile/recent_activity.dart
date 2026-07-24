import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
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
  bool _hasLoadError = false;

  List<Map<String, dynamic>>
      _activityRows = [];

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
          _hasLoadError = false;
        });
      }

      final List<Map<String, dynamic>>
          activityRows =
          await _activityService
              .getRecentActivities();

      if (!mounted) {
        return;
      }

      setState(() {
        _activityRows = activityRows;
        _isLoading = false;
        _hasLoadError = false;
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
        _hasLoadError = true;
      });
    }
  }

  List<ActivityModel> _buildLocalizedActivities(
    AppLocalizations localizations,
  ) {
    return _activityRows.map(
      (Map<String, dynamic> activity) {
        final String activityType =
            activity['activity_type']
                    ?.toString() ??
                '';

        final String rawTitle =
            activity['title']
                    ?.toString()
                    .trim() ??
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
          title: _getLocalizedActivityTitle(
            localizations,
            activityType,
            rawTitle,
          ),
          time: _formatActivityTime(
            localizations,
            createdAt,
          ),
        );
      },
    ).toList();
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

  String _getLocalizedActivityTitle(
    AppLocalizations localizations,
    String activityType,
    String rawTitle,
  ) {
    switch (activityType) {
      case 'schedule_added':
        return localizations.scheduleAddedActivity;

      case 'schedule_completed':
        return localizations.scheduleCompletedActivity;

      case 'schedule_deleted':
        return localizations.scheduleDeletedActivity;

      case 'focus_completed':
        return localizations.focusCompletedActivity;

      case 'badge_unlocked':
        return localizations.badgeUnlockedActivity;

      case 'membership_changed':
        return localizations.membershipChangedActivity;

      case 'level_up':
        return localizations.levelUpActivity;

      case 'streak_updated':
        return localizations.streakUpdatedActivity;

      default:
        return rawTitle.isNotEmpty
            ? rawTitle
            : localizations.activity;
    }
  }

  String _formatActivityTime(
    AppLocalizations localizations,
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

    if (difference.isNegative ||
        difference.inSeconds < 60) {
      return localizations.justNow;
    }

    if (difference.inMinutes < 60) {
      return localizations.minutesAgo(
        difference.inMinutes,
      );
    }

    if (difference.inHours < 24) {
      return localizations.hoursAgo(
        difference.inHours,
      );
    }

    if (difference.inDays == 1) {
      return localizations.yesterday;
    }

    if (difference.inDays < 7) {
      return localizations.daysAgo(
        difference.inDays,
      );
    }

    return '${createdAt.day.toString().padLeft(2, '0')}/'
        '${createdAt.month.toString().padLeft(2, '0')}/'
        '${createdAt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    final ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    final List<ActivityModel> activities =
        _buildLocalizedActivities(
      localizations,
    );

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  localizations
                      .recentActivity
                      .toUpperCase(),
                  style: TextStyle(
                    color: colorScheme
                        .onSurfaceVariant,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed:
                    _isLoading
                        ? null
                        : _loadActivities,
                tooltip: localizations
                    .refreshActivity,
                icon: const Icon(
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
          else if (_hasLoadError)
            Center(
              child: Column(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  Text(
                    localizations
                        .unableToLoadRecentActivity,
                    textAlign:
                        TextAlign.center,
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
                    icon: const Icon(
                      Icons.refresh,
                    ),
                    label: Text(
                      localizations
                          .tryAgain,
                    ),
                  ),
                ],
              ),
            )
          else if (activities.isEmpty)
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
                localizations
                    .noRecentActivity,
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
                  activities.length,
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
                      activities[index],
                );
              },
            ),
        ],
      ),
    );
  }
}