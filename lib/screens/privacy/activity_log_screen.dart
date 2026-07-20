import 'package:flutter/material.dart';

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

  List<ActivityLogModel> _activities = [];

  bool _isLoading = true;
  bool _isClearing = false;

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

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
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });

      _showMessage(
        _cleanError(error),
      );
    }
  }

  Future<void> _clearActivities() async {
    if (_activities.isEmpty) {
      return;
    }

    final bool? confirmed =
        await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Clear activity log?',
          ),
          content: const Text(
            'All activity records will be deleted.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child: const Text(
                'Cancel',
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },
              child: const Text(
                'Clear',
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
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
        'Activity log cleared.',
      );
    } catch (error) {
      _showMessage(
        _cleanError(error),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isClearing = false;
        });
      }
    }
  }

  String _cleanError(Object error) {
    return error
        .toString()
        .replaceFirst(
          'Exception: ',
          '',
        );
  }

  void _showMessage(
    String message,
  ) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  IconData _getIcon(
    String iconName,
  ) {
    switch (iconName) {
      case 'password':
        return Icons.lock_outline;

      case 'email':
        return Icons.email_outlined;

      case 'biometric':
        return Icons.fingerprint;

      case 'login':
        return Icons.login;

      case 'logout':
        return Icons.logout;

      case 'schedule':
        return Icons.calendar_month_outlined;

      case 'delete':
        return Icons.delete_outline;

      default:
        return Icons.history;
    }
  }

  String _formatTime(
    DateTime dateTime,
  ) {
    final DateTime now =
        DateTime.now();

    final Duration difference =
        now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    }

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    }

    if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    }

    if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    }

    final String day =
        dateTime.day.toString().padLeft(
              2,
              '0',
            );

    final String month =
        dateTime.month.toString().padLeft(
              2,
              '0',
            );

    return '$day/$month/${dateTime.year}';
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Activity Log',
        ),
        actions: [
          IconButton(
            onPressed:
                _isClearing || _activities.isEmpty
                    ? null
                    : _clearActivities,
            tooltip: 'Clear activity log',
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
                    Icons.delete_sweep_outlined,
                  ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _loadActivities,
              child: _activities.isEmpty
                  ? ListView(
                      physics:
                          const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(
                          height: 180,
                        ),
                        Icon(
                          Icons.history,
                          size: 72,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          'No activity recorded yet.',
                          textAlign:
                              TextAlign.center,
                        ),
                      ],
                    )
                  : ListView.separated(
                      physics:
                          const AlwaysScrollableScrollPhysics(),
                      padding:
                          const EdgeInsets.all(20),
                      itemCount:
                          _activities.length,
                      separatorBuilder:
                          (_, __) =>
                              const SizedBox(
                        height: 12,
                      ),
                      itemBuilder:
                          (context, index) {
                        final ActivityLogModel
                            activity =
                            _activities[index];

                        return Container(
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
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                    colorScheme
                                        .primaryContainer,
                                child: Icon(
                                  _getIcon(
                                    activity
                                        .iconName,
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
                                      activity
                                          .action,
                                      style:
                                          const TextStyle(
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      activity
                                          .description,
                                      style:
                                          TextStyle(
                                        color: colorScheme
                                            .onSurfaceVariant,
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
                                  activity
                                      .createdAt,
                                ),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colorScheme
                                      .onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}