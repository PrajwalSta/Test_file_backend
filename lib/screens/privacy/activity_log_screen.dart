import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../models/privacy/activity_log_model.dart';
import '../../services/MFA Auth/activity_log_service.dart';

class ActivityLogScreen extends StatefulWidget {
  const ActivityLogScreen({
    super.key,
  });

  @override
  State<ActivityLogScreen> createState() =>
      _ActivityLogScreenState();
}

class _ActivityLogScreenState
    extends State<ActivityLogScreen> {
  final ActivityLogService _activityLogService =
      ActivityLogService();

  List<ActivityLogModel> _activities =
      <ActivityLogModel>[];

  bool _isLoading = true;
  bool _isClearing = false;

  AppLocalizations get _localizations =>
      AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  // ==========================================================
  // LOAD ACTIVITY LOGS
  // ==========================================================
  Future<void> _loadActivities() async {
    try {
      final List<ActivityLogModel> activities =
          await _activityLogService
              .getActivityLogs();

      if (!mounted) {
        return;
      }

      setState(() {
        _activities = activities;
        _isLoading = false;
      });
    } catch (error, stackTrace) {
      debugPrint(
        'Unable to load activity logs: $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });

      _showMessage(
        _localizations.unableToLoadActivityLog,
      );
    }
  }

  // ==========================================================
  // CLEAR ACTIVITY LOGS
  // ==========================================================
  Future<void> _clearActivities() async {
    if (_activities.isEmpty ||
        _isClearing) {
      return;
    }

    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    final bool? confirmed =
        await showDialog<bool>(
      context: context,
      builder: (
        BuildContext dialogContext,
      ) {
        return AlertDialog(
          title: Text(
            localizations.clearActivityLogQuestion,
          ),
          content: Text(
            localizations
                .allActivityRecordsDeleted,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: Text(
                localizations.cancel,
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: Text(
                localizations.clear,
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true ||
        !mounted) {
      return;
    }

    setState(() {
      _isClearing = true;
    });

    try {
      await _activityLogService
          .clearActivityLogs();

      if (!mounted) {
        return;
      }

      setState(() {
        _activities.clear();
      });

      _showMessage(
        _localizations.activityLogCleared,
      );
    } catch (error, stackTrace) {
      debugPrint(
        'Unable to clear activity logs: $error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) {
        return;
      }

      _showMessage(
        _localizations.unableToClearActivityLog,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isClearing = false;
        });
      }
    }
  }

  // ==========================================================
  // SHOW MESSAGE
  // ==========================================================
  void _showMessage(
    String message,
  ) {
    if (!mounted) {
      return;
    }

    final ScaffoldMessengerState messenger =
        ScaffoldMessenger.of(context);

    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
        ),
        behavior:
            SnackBarBehavior.floating,
      ),
    );
  }

  // ==========================================================
  // GET ACTIVITY ICON
  // ==========================================================
  IconData _getIcon(
    String iconName,
  ) {
    switch (iconName) {
      case 'password':
      case 'lock':
        return Icons.lock_outline;

      case 'email':
      case 'security':
        return Icons.email_outlined;

      case 'biometric':
      case 'fingerprint':
        return Icons.fingerprint;

      case 'login':
        return Icons.login;

      case 'logout':
        return Icons.logout;

      case 'schedule':
        return Icons.calendar_month_outlined;

      case 'delete':
        return Icons.delete_outline;

      case 'privacy':
        return Icons.privacy_tip_outlined;

      case 'history':
        return Icons.history;

      default:
        return Icons.history;
    }
  }

  // ==========================================================
  // FORMAT ACTIVITY TIME
  // ==========================================================
  String _formatTime(
    BuildContext context,
    DateTime dateTime,
  ) {
    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    final DateTime localDateTime =
        dateTime.toLocal();

    final DateTime now =
        DateTime.now();

    final Duration difference =
        now.difference(localDateTime);

    if (difference.isNegative ||
        difference.inMinutes < 1) {
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

    if (difference.inDays < 7) {
      return localizations.daysAgo(
        difference.inDays,
      );
    }

    final MaterialLocalizations
        materialLocalizations =
        MaterialLocalizations.of(context);

    return materialLocalizations
        .formatShortDate(localDateTime);
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final ThemeData theme =
        Theme.of(context);

    final ColorScheme colorScheme =
        theme.colorScheme;

    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.activityLog,
        ),
        actions: [
          IconButton(
            onPressed:
                _isClearing ||
                        _activities.isEmpty
                    ? null
                    : _clearActivities,
            tooltip:
                localizations.clearActivityLog,
            icon: _isClearing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child:
                        CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(
                    Icons
                        .delete_sweep_outlined,
                  ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child:
                  CircularProgressIndicator(
                color:
                    colorScheme.primary,
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadActivities,
              child: _activities.isEmpty
                  ? _buildEmptyState(
                      context,
                      localizations,
                    )
                  : _buildActivityList(
                      context,
                      colorScheme,
                    ),
            ),
    );
  }

  // ==========================================================
  // EMPTY STATE
  // ==========================================================
  Widget _buildEmptyState(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    final ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return ListView(
      physics:
          const AlwaysScrollableScrollPhysics(),
      padding:
          const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      children: [
        const SizedBox(
          height: 180,
        ),
        Icon(
          Icons.history,
          size: 72,
          color:
              colorScheme.onSurfaceVariant,
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          localizations
              .noActivityRecordedYet,
          textAlign:
              TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(
            color:
                colorScheme.onSurfaceVariant,
            fontWeight:
                FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // ACTIVITY LIST
  // ==========================================================
  Widget _buildActivityList(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    return ListView.separated(
      physics:
          const AlwaysScrollableScrollPhysics(),
      padding:
          const EdgeInsets.all(20),
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
        final ActivityLogModel activity =
            _activities[index];

        return Semantics(
          container: true,
          label:
              '${activity.action}. '
              '${activity.description}. '
              '${_formatTime(context, activity.createdAt)}',
          child: Container(
            padding:
                const EdgeInsets.all(
              16,
            ),
            decoration: BoxDecoration(
              color: colorScheme
                  .surfaceContainerHighest,
              borderRadius:
                  BorderRadius.circular(
                18,
              ),
            ),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor:
                      colorScheme
                          .primaryContainer,
                  child: Icon(
                    _getIcon(
                      activity.iconName,
                    ),
                    color: colorScheme
                        .onPrimaryContainer,
                  ),
                ),

                const SizedBox(
                  width: 14,
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Text(
                        activity.action,
                        style: themeTextStyle(
                          context,
                        ),
                      ),

                      const SizedBox(
                        height: 4,
                      ),

                      Text(
                        activity.description,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                          color: colorScheme
                              .onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  width: 10,
                ),

                Text(
                  _formatTime(
                    context,
                    activity.createdAt,
                  ),
                  textAlign:
                      TextAlign.end,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color: colorScheme
                        .onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  TextStyle? themeTextStyle(
    BuildContext context,
  ) {
    final ThemeData theme =
        Theme.of(context);

    return theme.textTheme.titleSmall
        ?.copyWith(
      color:
          theme.colorScheme.onSurface,
      fontWeight:
          FontWeight.bold,
    );
  }
}