import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../l10n/app_localizations.dart';
import '../../services/notification_setting_service.dart';

class NotificationInboxScreen
    extends StatefulWidget {
  const NotificationInboxScreen({
    super.key,
  });

  @override
  State<NotificationInboxScreen>
      createState() =>
          _NotificationInboxScreenState();
}

class _NotificationInboxScreenState
    extends State<NotificationInboxScreen> {
  final NotificationSettingService
      _notificationService =
      NotificationSettingService();

  List<Map<String, dynamic>>
      _notifications = [];

  bool _isLoading = true;
  bool _isMarkingAll = false;
  bool _isDeletingAll = false;

  String? _errorMessage;

  bool _notificationDataChanged = false;

  AppLocalizations get _localizations =>
      AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadNotifications();
    });
  }

  Future<void> _loadNotifications() async {
    final User? currentUser =
        Supabase.instance.client.auth.currentUser;

    if (currentUser == null) {
      if (!mounted) {
        return;
      }

      setState(() {
        _notifications = [];
        _isLoading = false;
        _errorMessage =
            _localizations.pleaseLogInToViewNotifications;
      });

      return;
    }

    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final List<Map<String, dynamic>>
          notifications =
          await _notificationService
              .getNotifications();

      debugPrint(
        'Notification inbox loaded: '
        '${notifications.length}',
      );

      for (
        final Map<String, dynamic>
            notification
        in notifications
      ) {
        debugPrint(
          'Inbox notification: '
          '$notification',
        );
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _notifications =
            notifications
                .map(
                  (
                    Map<String, dynamic>
                        item,
                  ) {
                    return Map<String, dynamic>.from(
                      item,
                    );
                  },
                )
                .toList();

        _isLoading = false;
        _errorMessage = null;
      });
    } catch (error, stackTrace) {
      debugPrint(
        'Notification loading error: '
        '$error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage =
            '${_localizations.unableToLoadNotifications}\n'
            '$error';
      });
    }
  }

  Future<void> _markAsRead(
    Map<String, dynamic> notification,
  ) async {
    final String notificationId =
        notification['id']
                ?.toString()
                .trim() ??
            '';

    final bool isRead =
        notification['is_read'] == true;

    if (notificationId.isEmpty ||
        isRead) {
      return;
    }

    try {
      await _notificationService
          .markNotificationAsRead(
        notificationId,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        notification['is_read'] = true;
        _notificationDataChanged = true;
      });

      debugPrint(
        'Inbox item marked as read: '
        '$notificationId',
      );
    } catch (error) {
      debugPrint(
        'Mark notification read error: '
        '$error',
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            '${_localizations.unableToMarkNotificationAsRead}: '
            '$error',
          ),
          behavior:
              SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _markAsUnread(
    Map<String, dynamic> notification,
  ) async {
    final String notificationId =
        notification['id']
                ?.toString()
                .trim() ??
            '';

    if (notificationId.isEmpty) {
      return;
    }

    try {
      await _notificationService
          .markNotificationAsUnread(
        notificationId,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        notification['is_read'] = false;
        _notificationDataChanged = true;
      });
    } catch (error) {
      debugPrint(
        'Mark notification unread error: '
        '$error',
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            '${_localizations.unableToMarkNotificationAsUnread}: '
            '$error',
          ),
          behavior:
              SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _markAllAsRead() async {
    if (_isMarkingAll) {
      return;
    }

    setState(() {
      _isMarkingAll = true;
    });

    try {
      await _notificationService
          .markAllNotificationsAsRead();

      if (!mounted) {
        return;
      }

      setState(() {
        for (
          final Map<String, dynamic>
              notification
          in _notifications
        ) {
          notification['is_read'] = true;
        }

        _notificationDataChanged = true;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            _localizations.allNotificationsMarkedAsRead,
          ),
          behavior:
              SnackBarBehavior.floating,
        ),
      );
    } catch (error) {
      debugPrint(
        'Mark all notifications read error: '
        '$error',
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            '${_localizations.unableToMarkAllAsRead}: '
            '$error',
          ),
          behavior:
              SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isMarkingAll = false;
        });
      }
    }
  }

  Future<bool> _deleteNotification(
    Map<String, dynamic> notification,
  ) async {
    final String notificationId =
        notification['id']
                ?.toString()
                .trim() ??
            '';

    if (notificationId.isEmpty) {
      return false;
    }

    try {
      await _notificationService
          .deleteNotification(
        notificationId,
      );

      if (!mounted) {
        return true;
      }

      setState(() {
        _notifications.removeWhere(
          (
            Map<String, dynamic> item,
          ) {
            return item['id']
                    ?.toString() ==
                notificationId;
          },
        );

        _notificationDataChanged = true;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            _localizations.notificationDeleted,
          ),
          behavior:
              SnackBarBehavior.floating,
        ),
      );

      return true;
    } catch (error) {
      debugPrint(
        'Delete notification error: '
        '$error',
      );

      if (!mounted) {
        return false;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            '${_localizations.unableToDeleteNotification}: '
            '$error',
          ),
          behavior:
              SnackBarBehavior.floating,
        ),
      );

      return false;
    }
  }

  Future<void> _deleteAllNotifications() async {
    if (_isDeletingAll ||
        _notifications.isEmpty) {
      return;
    }

    final bool? shouldDelete =
        await showDialog<bool>(
      context: context,
      builder: (
        BuildContext dialogContext,
      ) {
        return AlertDialog(
          title: Text(
            _localizations.deleteAllNotificationsQuestion,
          ),
          content: Text(
            _localizations.deleteAllNotificationsDescription,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(false);
              },
              child: Text(
                _localizations.cancel,
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(true);
              },
              child: Text(
                _localizations.deleteAll,
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true ||
        !mounted) {
      return;
    }

    setState(() {
      _isDeletingAll = true;
    });

    try {
      await _notificationService
          .deleteAllNotifications();

      if (!mounted) {
        return;
      }

      setState(() {
        _notifications.clear();
        _notificationDataChanged = true;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            _localizations.allNotificationsDeleted,
          ),
          behavior:
              SnackBarBehavior.floating,
        ),
      );
    } catch (error) {
      debugPrint(
        'Delete all notifications error: '
        '$error',
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            '${_localizations.unableToDeleteAllNotifications}: '
            '$error',
          ),
          behavior:
              SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isDeletingAll = false;
        });
      }
    }
  }

  Future<void> _handleNotificationTap(
    Map<String, dynamic> notification,
  ) async {
    await _markAsRead(
      notification,
    );

    final String type =
        notification['type']
                ?.toString() ??
            '';

    final String? scheduleId =
        notification['schedule_id']
            ?.toString();

    debugPrint(
      'Notification selected. '
      'Type: $type, '
      'Schedule ID: $scheduleId',
    );
  }

  void _showNotificationOptions(
    Map<String, dynamic> notification,
  ) {
    final bool isRead =
        notification['is_read'] == true;

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (
        BuildContext sheetContext,
      ) {
        return SafeArea(
          child: Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  isRead
                      ? Icons
                          .mark_email_unread_rounded
                      : Icons
                          .drafts_rounded,
                ),
                title: Text(
                  isRead
                      ? _localizations.markAsUnread
                      : _localizations.markAsRead,
                ),
                onTap: () async {
                  Navigator.of(
                    sheetContext,
                  ).pop();

                  if (isRead) {
                    await _markAsUnread(
                      notification,
                    );
                  } else {
                    await _markAsRead(
                      notification,
                    );
                  }
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.delete_rounded,
                  color: Theme.of(context)
                      .colorScheme
                      .error,
                ),
                title: Text(
                  _localizations.deleteNotification,
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .error,
                  ),
                ),
                onTap: () async {
                  Navigator.of(
                    sheetContext,
                  ).pop();

                  await _deleteNotification(
                    notification,
                  );
                },
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        );
      },
    );
  }

  IconData _getNotificationIcon(
    String type,
  ) {
    switch (type) {
      case 'schedule_reminder':
        return Icons.alarm_rounded;

      case 'task_completed':
        return Icons
            .check_circle_rounded;

      case 'task_cancelled':
        return Icons.cancel_rounded;

      case 'schedule_added':
        return Icons
            .event_available_rounded;

      case 'task_reopened':
        return Icons
            .restart_alt_rounded;

      case 'test_notification':
        return Icons
            .notifications_active_rounded;

      default:
        return Icons
            .notifications_rounded;
    }
  }

  String _formatDate(
    dynamic value,
  ) {
    final DateTime? parsedDate =
        DateTime.tryParse(
      value?.toString() ?? '',
    );

    if (parsedDate == null) {
      return '';
    }

    final DateTime localDate =
        parsedDate.toLocal();

    final DateTime now =
        DateTime.now();

    final DateTime today =
        DateTime(
      now.year,
      now.month,
      now.day,
    );

    final DateTime notificationDay =
        DateTime(
      localDate.year,
      localDate.month,
      localDate.day,
    );

    final DateTime yesterday =
        today.subtract(
      const Duration(
        days: 1,
      ),
    );

    final TimeOfDay time =
        TimeOfDay.fromDateTime(
      localDate,
    );

    final String formattedTime =
        time.format(context);

    if (notificationDay == today) {
      return _localizations.todayWithTime(formattedTime);
    }

    if (notificationDay == yesterday) {
      return _localizations.yesterdayWithTime(formattedTime);
    }

    return '${localDate.day}/'
        '${localDate.month}/'
        '${localDate.year} • '
        '$formattedTime';
  }

  bool get _hasUnreadNotifications {
    return _notifications.any(
      (
        Map<String, dynamic> item,
      ) {
        return item['is_read'] != true;
      },
    );
  }

  Future<bool> _handleBack() async {
    Navigator.of(context).pop(
      _notificationDataChanged,
    );

    return false;
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

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (
        bool didPop,
        dynamic result,
      ) {
        if (!didPop) {
          _handleBack();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: _handleBack,
            icon: const Icon(
              Icons.arrow_back_rounded,
            ),
          ),
          title: Text(
            localizations.notifications,
          ),
          actions: [
            if (_hasUnreadNotifications)
              TextButton(
                onPressed:
                    _isMarkingAll
                        ? null
                        : _markAllAsRead,
                child:
                    _isMarkingAll
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            localizations.markAllRead,
                          ),
              ),
            if (_notifications.isNotEmpty)
              PopupMenuButton<String>(
                onSelected: (
                  String value,
                ) {
                  if (value ==
                      'delete_all') {
                    _deleteAllNotifications();
                  } else if (
                      value == 'refresh') {
                    _loadNotifications();
                  }
                },
                itemBuilder: (
                  BuildContext context,
                ) {
                  return [
                    PopupMenuItem<String>(
                      value: 'refresh',
                      child: Row(
                        children: [
                          Icon(
                            Icons
                                .refresh_rounded,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            localizations.refresh,
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'delete_all',
                      child: Row(
                        children: [
                          Icon(
                            Icons
                                .delete_sweep_rounded,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            localizations.deleteAll,
                          ),
                        ],
                      ),
                    ),
                  ];
                },
              ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh:
              _loadNotifications,
          child: _buildBody(
            colorScheme,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    ColorScheme colorScheme,
  ) {
    if (_isLoading) {
      return ListView(
        physics:
            const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(
            height: 220,
          ),
          Center(
            child:
                CircularProgressIndicator(),
          ),
        ],
      );
    }

    if (_errorMessage != null) {
      return ListView(
        physics:
            const AlwaysScrollableScrollPhysics(),
        padding:
            const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        children: [
          const SizedBox(
            height: 150,
          ),
          Icon(
            Icons.error_outline_rounded,
            size: 55,
            color: colorScheme.error,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            _errorMessage!,
            textAlign:
                TextAlign.center,
            style: TextStyle(
              color:
                  colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child:
                FilledButton.icon(
              onPressed:
                  _loadNotifications,
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label: Text(
                _localizations.tryAgain,
              ),
            ),
          ),
        ],
      );
    }

    if (_notifications.isEmpty) {
      return ListView(
        physics:
            const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(
            height: 180,
          ),
          Icon(
            Icons
                .notifications_off_outlined,
            size: 60,
            color:
                colorScheme.onSurfaceVariant,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            _localizations.noNotificationsYet,
            textAlign:
                TextAlign.center,
            style: TextStyle(
              color:
                  colorScheme.onSurfaceVariant,
              fontSize: 17,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            _localizations.notificationInboxEmptyDescription,
            textAlign:
                TextAlign.center,
            style: TextStyle(
              color:
                  colorScheme.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child:
                OutlinedButton.icon(
              onPressed:
                  _loadNotifications,
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label: Text(
                _localizations.refresh,
              ),
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      padding:
          const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        32,
      ),
      physics:
          const AlwaysScrollableScrollPhysics(),
      itemCount:
          _notifications.length,
      separatorBuilder: (
        BuildContext context,
        int index,
      ) {
        return const SizedBox(
          height: 10,
        );
      },
      itemBuilder: (
        BuildContext context,
        int index,
      ) {
        final Map<String, dynamic>
            notification =
            _notifications[index];

        final String title =
            notification['title']
                    ?.toString() ??
                _localizations.notification;

        final String message =
            notification['message']
                    ?.toString() ??
                '';

        final String type =
            notification['type']
                    ?.toString() ??
                'general';

        final bool isRead =
            notification['is_read'] ==
                true;

        final dynamic dateValue =
            notification['visible_at'] ??
                notification['created_at'];

        final String notificationId =
            notification['id']
                    ?.toString() ??
                'notification_$index';

        return Dismissible(
          key: ValueKey<String>(
            notificationId,
          ),
          direction:
              DismissDirection
                  .endToStart,
          confirmDismiss: (
            DismissDirection direction,
          ) async {
            return _deleteNotification(
              notification,
            );
          },
          background: Container(
            padding:
                const EdgeInsets.only(
              right: 20,
            ),
            alignment:
                Alignment.centerRight,
            decoration:
                BoxDecoration(
              color:
                  colorScheme.error,
              borderRadius:
                  BorderRadius.circular(
                16,
              ),
            ),
            child: Icon(
              Icons.delete_rounded,
              color:
                  colorScheme.onError,
            ),
          ),
          child: Material(
            color: isRead
                ? colorScheme.surfaceContainer
                : colorScheme
                    .primaryContainer
                    .withValues(
                      alpha: 0.45,
                    ),
            borderRadius:
                BorderRadius.circular(
              16,
            ),
            child: InkWell(
              borderRadius:
                  BorderRadius.circular(
                16,
              ),
              onTap: () {
                _handleNotificationTap(
                  notification,
                );
              },
              onLongPress: () {
                _showNotificationOptions(
                  notification,
                );
              },
              child: Padding(
                padding:
                    const EdgeInsets.all(
                  16,
                ),
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    CircleAvatar(
                      backgroundColor:
                          colorScheme
                              .primaryContainer,
                      child: Icon(
                        _getNotificationIcon(
                          type,
                        ),
                        color:
                            colorScheme.primary,
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
                          Row(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Expanded(
                                child: Text(
                                  title,
                                  style:
                                      TextStyle(
                                    fontSize:
                                        16,
                                    fontWeight:
                                        isRead
                                            ? FontWeight
                                                .w600
                                            : FontWeight
                                                .bold,
                                  ),
                                ),
                              ),
                              if (!isRead) ...[
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: 9,
                                  height: 9,
                                  margin:
                                      const EdgeInsets
                                          .only(
                                    top: 5,
                                  ),
                                  decoration:
                                      BoxDecoration(
                                    color:
                                        colorScheme
                                            .primary,
                                    shape:
                                        BoxShape
                                            .circle,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          if (message
                              .isNotEmpty) ...[
                            const SizedBox(
                              height: 6,
                            ),
                            Text(
                              message,
                              style:
                                  TextStyle(
                                color:
                                    colorScheme
                                        .onSurfaceVariant,
                                height:
                                    1.35,
                              ),
                            ),
                          ],
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            _formatDate(
                              dateValue,
                            ),
                            style:
                                TextStyle(
                              color:
                                  colorScheme
                                      .onSurfaceVariant,
                              fontSize:
                                  12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip:
                          _localizations.moreOptions,
                      visualDensity:
                          VisualDensity
                              .compact,
                      onPressed: () {
                        _showNotificationOptions(
                          notification,
                        );
                      },
                      icon: const Icon(
                        Icons
                            .more_vert_rounded,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}