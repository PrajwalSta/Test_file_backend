import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../l10n/app_localizations.dart';

import '../../models/schedule_model.dart';
import '../../services/local_notification_service.dart';
import '../../services/profile/profile_service.dart';
import '../theme/app_constants.dart';
import '../widgets/schedule/add_schedule_sheet.dart';
import '../widgets/schedule/category_selector.dart';
import '../widgets/schedule/schedule_header.dart';
import '../widgets/schedule/schedule_list.dart';

class ScheduleScreen extends StatefulWidget {
  final VoidCallback? onScheduleUpdated;

  const ScheduleScreen({
    super.key,
    this.onScheduleUpdated,
  });

  @override
  State<ScheduleScreen> createState() =>
      _ScheduleScreenState();
}

class _ScheduleScreenState
    extends State<ScheduleScreen> {
  final SupabaseClient _supabase =
      Supabase.instance.client;

  final ProfileService _profileService =
      ProfileService();

  late AppLocalizations _localizations;
  bool _didLoadSchedules = false;

  String selectedCategory = 'All';

  bool _showAddScheduleSheet = false;
  bool _isLoading = true;
  bool _isDeleting = false;
  bool _isUpdatingCompleted = false;

  String? _errorMessage;

  List<ScheduleModel> todaySchedules = [];
  List<ScheduleModel> tomorrowSchedules = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _localizations =
        AppLocalizations.of(context)!;

    if (!_didLoadSchedules) {
      _didLoadSchedules = true;
      _loadSchedules();
    }
  }

  String _formatDisplayTime(
    DateTime dateTime,
  ) {
    final int hour = dateTime.hour;

    final int displayHour =
        hour == 0
            ? 12
            : hour > 12
                ? hour - 12
                : hour;

    final String minute =
        dateTime.minute
            .toString()
            .padLeft(
              2,
              '0',
            );

    final String period =
        hour >= 12
            ? _localizations.pm
            : _localizations.am;

    return '$displayHour:$minute $period';
  }

  Future<void> _loadSchedules() async {
    final User? currentUser =
        _supabase.auth.currentUser;

    if (currentUser == null) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage =
            _localizations.loginToViewSchedules;
        todaySchedules = [];
        tomorrowSchedules = [];
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
      final DateTime now =
          DateTime.now();

      final DateTime today =
          DateTime(
        now.year,
        now.month,
        now.day,
      );

      final DateTime tomorrow =
          today.add(
        const Duration(
          days: 1,
        ),
      );

      final DateTime dayAfterTomorrow =
          tomorrow.add(
        const Duration(
          days: 1,
        ),
      );

      final String startDateTime =
          today
              .toUtc()
              .toIso8601String();

      final String endDateTime =
          dayAfterTomorrow
              .toUtc()
              .toIso8601String();

      final List<Map<String, dynamic>>
          response =
          await _supabase
              .from('schedules')
              .select()
              .eq(
                'user_id',
                currentUser.id,
              )
              .eq(
                'completed',
                false,
              )
              .gte(
                'scheduled_at',
                startDateTime,
              )
              .lt(
                'scheduled_at',
                endDateTime,
              )
              .order(
                'scheduled_at',
                ascending: true,
              );

      debugPrint(
        'Loaded schedule rows: '
        '${response.length}',
      );

      final List<ScheduleModel>
          loadedToday = [];

      final List<ScheduleModel>
          loadedTomorrow = [];

      for (
        final Map<String, dynamic> row
        in response
      ) {
        debugPrint(
          'Schedule row: $row',
        );

        final String categoryName =
            row['category']
                    ?.toString() ??
                _localizations.study;

        final ScheduleCategory category =
            CategorySelector.categories
                .firstWhere(
          (
            ScheduleCategory item,
          ) {
            return item.name ==
                categoryName;
          },
          orElse: () {
            return CategorySelector
                .categories
                .first;
          },
        );

        final String? scheduledAtValue =
            row['scheduled_at']
                ?.toString();

        if (scheduledAtValue == null ||
            scheduledAtValue.isEmpty) {
          debugPrint(
            'Schedule skipped because '
            'scheduled_at is empty.',
          );

          continue;
        }

        final DateTime? parsedDate =
            DateTime.tryParse(
          scheduledAtValue,
        );

        if (parsedDate == null) {
          debugPrint(
            'Could not parse scheduled_at: '
            '$scheduledAtValue',
          );

          continue;
        }

        final DateTime localScheduleDate =
            parsedDate.toLocal();

        final DateTime scheduleDay =
            DateTime(
          localScheduleDate.year,
          localScheduleDate.month,
          localScheduleDate.day,
        );

        final ScheduleModel schedule =
            ScheduleModel(
          id:
              row['id']
                  ?.toString(),
          emoji:
              category.emoji,
          title:
              row['title']
                      ?.toString() ??
                  _localizations.untitled,
          time:
              row['time']
                      ?.toString() ??
                  _formatDisplayTime(
                    localScheduleDate,
                  ),
          scheduleDate:
              localScheduleDate,
          category:
              categoryName,
          categoryColor:
              category.color,
          focusMode:
              row['focus_mode']
                      ?.toString() ??
                  _localizations.studyMode,
          durationMinutes:
              (row['duration_minutes']
                          as num?)
                      ?.toInt() ??
                  0,
          completed:
              row['completed'] ==
                  true,
          notificationId:
              _parseNotificationId(
            row['notification_id'],
          ),
        );

        if (scheduleDay == today) {
          loadedToday.add(
            schedule,
          );
        } else if (
            scheduleDay == tomorrow) {
          loadedTomorrow.add(
            schedule,
          );
        }
      }

      if (!mounted) {
        return;
      }

      setState(() {
        todaySchedules =
            loadedToday;

        tomorrowSchedules =
            loadedTomorrow;

        _isLoading = false;
      });

      debugPrint(
        'Today schedules: '
        '${loadedToday.length}',
      );

      debugPrint(
        'Tomorrow schedules: '
        '${loadedTomorrow.length}',
      );
    } on PostgrestException catch (error) {
      debugPrint(
        'Schedule loading error: '
        '${error.message}',
      );

      debugPrint(
        'Schedule loading code: '
        '${error.code}',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage =
            _localizations.databaseError(
              error.message,
            );
      });
    } catch (error, stackTrace) {
      debugPrint(
        'Unable to load schedules: '
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
            _localizations.unableToLoadSchedules;
      });
    }
  }

  int? _parseNotificationId(
    dynamic value,
  ) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
      value.toString(),
    );
  }

  List<ScheduleModel>
      get filteredTodaySchedules {
    if (selectedCategory == 'All') {
      return todaySchedules;
    }

    return todaySchedules.where(
      (
        ScheduleModel schedule,
      ) {
        return schedule.category ==
            selectedCategory;
      },
    ).toList();
  }

  List<ScheduleModel>
      get filteredTomorrowSchedules {
    if (selectedCategory == 'All') {
      return tomorrowSchedules;
    }

    return tomorrowSchedules.where(
      (
        ScheduleModel schedule,
      ) {
        return schedule.category ==
            selectedCategory;
      },
    ).toList();
  }

  void _openAddScheduleSheet() {
    FocusScope.of(context).unfocus();

    if (!mounted ||
        _showAddScheduleSheet) {
      return;
    }

    setState(() {
      _showAddScheduleSheet = true;
    });
  }

  void _closeAddScheduleSheet() {
    FocusScope.of(context).unfocus();

    if (!mounted ||
        !_showAddScheduleSheet) {
      return;
    }

    setState(() {
      _showAddScheduleSheet = false;
    });
  }

  Future<void> _saveNewSchedule(
    ScheduleModel newSchedule,
  ) async {
    /*
     * Close the Add Schedule sheet immediately
     * after the schedule is saved.
     */
    _closeAddScheduleSheet();

    try {
      await LocalNotificationService.instance
          .showAndSaveNotification(
        title:
            _localizations.scheduleAdded,
        body:
            _localizations.scheduleAddedBody(
          newSchedule.title,
        ),
        type: 'schedule_added',
        scheduleId:
            newSchedule.id,
        payload:
            newSchedule.id == null
                ? 'schedule_added'
                : 'schedule_added:'
                    '${newSchedule.id}',
      );
    } catch (error) {
      debugPrint(
        'Schedule added notification error: '
        '$error',
      );
    }

    await _loadSchedules();

    widget.onScheduleUpdated?.call();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            _localizations
                .scheduleAddedSuccessfully(
              newSchedule.title,
            ),
          ),
          behavior:
              SnackBarBehavior.floating,
          backgroundColor:
              newSchedule.categoryColor,
        ),
      );
  }

  Future<void> _updateCompleted(
    ScheduleModel schedule,
    bool completed,
  ) async {
    if (_isUpdatingCompleted) {
      return;
    }

    final String? scheduleId =
        schedule.id;

    final User? currentUser =
        _supabase.auth.currentUser;

    if (scheduleId == null ||
        scheduleId.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            _localizations.scheduleIdMissing,
          ),
          behavior:
              SnackBarBehavior.floating,
        ),
      );

      return;
    }

    if (currentUser == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            _localizations
                .loginBeforeUpdatingSchedule,
          ),
          behavior:
              SnackBarBehavior.floating,
        ),
      );

      return;
    }

    setState(() {
      _isUpdatingCompleted = true;
    });

    try {
      final List<Map<String, dynamic>>
          updatedRows =
          await _supabase
              .from('schedules')
              .update({
                'completed':
                    completed,
              })
              .eq(
                'id',
                scheduleId,
              )
              .eq(
                'user_id',
                currentUser.id,
              )
              .select(
                'id, user_id, completed',
              );

      debugPrint(
        'Updated schedule rows: '
        '$updatedRows',
      );

      if (updatedRows.isEmpty) {
        throw Exception(
          _localizations.scheduleUpdateFailed,
        );
      }

      final bool savedCompletedValue =
          updatedRows.first[
                  'completed'] ==
              true;

      debugPrint(
        'Saved completed value: '
        '$savedCompletedValue',
      );

      final int completedCount =
          await _profileService
              .syncCompletedTasks();

      debugPrint(
        'Profile Done count: '
        '$completedCount',
      );

      if (completed) {
        try {
          final int notificationId =
              schedule.notificationId ??
                  scheduleId.hashCode;

          await LocalNotificationService
              .instance
              .cancelScheduleNotification(
            notificationId:
                notificationId,
            scheduleId:
                scheduleId,
          );
        } catch (error) {
          debugPrint(
            'Reminder cancellation error: '
            '$error',
          );
        }

        try {
          await LocalNotificationService
              .instance
              .showTaskCompletedNotification(
            taskTitle:
                schedule.title,
            scheduleId:
                scheduleId,
            id:
                scheduleId.hashCode,
          );
        } catch (error) {
          debugPrint(
            'Task completed notification '
            'error: $error',
          );
        }
      } else {
        try {
          await LocalNotificationService
              .instance
              .showAndSaveNotification(
            title:
                _localizations.taskReopened,
            body:
                _localizations.taskReopenedBody(
              schedule.title,
            ),
            type:
                'task_reopened',
            scheduleId:
                scheduleId,
            payload:
                'task_reopened:'
                '$scheduleId',
          );
        } catch (error) {
          debugPrint(
            'Task reopened notification '
            'error: $error',
          );
        }
      }

      await _loadSchedules();

      widget.onScheduleUpdated?.call();

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              completed
                  ? _localizations
                      .taskMarkedCompleted(
                      schedule.title,
                      completedCount,
                    )
                  : _localizations
                      .taskMarkedIncomplete(
                      schedule.title,
                      completedCount,
                    ),
            ),
            behavior:
                SnackBarBehavior.floating,
          ),
        );
    } on PostgrestException catch (error) {
      debugPrint(
        'Completed update error: '
        '${error.message}',
      );

      debugPrint(
        'Completed update code: '
        '${error.code}',
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            _localizations.updateFailed(
              error.message,
            ),
          ),
          behavior:
              SnackBarBehavior.floating,
        ),
      );
    } catch (error, stackTrace) {
      debugPrint(
        'Unexpected update error: '
        '$error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            _localizations
                .unableToUpdateSchedule(
              error.toString(),
            ),
          ),
          behavior:
              SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingCompleted = false;
        });
      }
    }
  }

  Future<void> _deleteSchedule(
    ScheduleModel schedule,
  ) async {
    if (_isDeleting) {
      return;
    }

    final String? scheduleId =
        schedule.id;

    if (scheduleId == null ||
        scheduleId.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            _localizations.scheduleIdMissing,
          ),
          behavior:
              SnackBarBehavior.floating,
        ),
      );

      return;
    }

    final User? currentUser =
        _supabase.auth.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            _localizations
                .loginBeforeDeletingSchedule,
          ),
          behavior:
              SnackBarBehavior.floating,
        ),
      );

      return;
    }

    setState(() {
      _isDeleting = true;
    });

    try {
      /*
       * Cancel the scheduled reminder.
       */
      try {
        final int notificationId =
            schedule.notificationId ??
                scheduleId.hashCode;

        await LocalNotificationService
            .instance
            .cancelScheduleNotification(
          notificationId:
              notificationId,
          scheduleId:
              scheduleId,
        );
      } catch (error) {
        debugPrint(
          'Schedule reminder cancellation '
          'error: $error',
        );
      }

      /*
       * Save the cancellation notification
       * before deleting the schedule row.
       */
      try {
        await LocalNotificationService
            .instance
            .showScheduleDeletedNotification(
          scheduleTitle:
              schedule.title,
          scheduleId:
              scheduleId,
        );
      } catch (error) {
        debugPrint(
          'Schedule deleted notification '
          'error: $error',
        );
      }

      final List<Map<String, dynamic>>
          deletedRows =
          await _supabase
              .from('schedules')
              .delete()
              .eq(
                'id',
                scheduleId,
              )
              .eq(
                'user_id',
                currentUser.id,
              )
              .select(
                'id, completed',
              );

      debugPrint(
        'Deleted schedule rows: '
        '$deletedRows',
      );

      if (deletedRows.isEmpty) {
        throw Exception(
          _localizations.scheduleDeleteFailed,
        );
      }

      final int completedCount =
          await _profileService
              .syncCompletedTasks();

      debugPrint(
        'Done count after delete: '
        '$completedCount',
      );

      await _loadSchedules();

      widget.onScheduleUpdated?.call();

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              _localizations
                  .scheduleDeletedSuccessfully(
                schedule.title,
              ),
            ),
            behavior:
                SnackBarBehavior.floating,
          ),
        );
    } on PostgrestException catch (error) {
      debugPrint(
        'Delete message: '
        '${error.message}',
      );

      debugPrint(
        'Delete code: '
        '${error.code}',
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            _localizations.deleteFailed(
              error.message,
            ),
          ),
          behavior:
              SnackBarBehavior.floating,
        ),
      );
    } catch (error, stackTrace) {
      debugPrint(
        'Unexpected delete error: '
        '$error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            _localizations
                .unableToDeleteSchedule(
              error.toString(),
            ),
          ),
          behavior:
              SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }
  }

  void _handleScheduleTap(
    ScheduleModel schedule,
  ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            _localizations.scheduleSelected(
              schedule.title,
            ),
          ),
          behavior:
              SnackBarBehavior.floating,
        ),
      );
  }

  Widget _buildScheduleContent() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.only(
          top: 100,
        ),
        child: Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.only(
          top: 80,
        ),
        child: Center(
          child: Column(
            children: [
              Text(
                _errorMessage!,
                textAlign:
                    TextAlign.center,
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton.icon(
                onPressed:
                    _loadSchedules,
                icon: const Icon(
                  Icons.refresh_rounded,
                ),
                label: Text(
                  _localizations.tryAgain,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        ScheduleList(
          title: _localizations.today,
          tasks:
              filteredTodaySchedules,
          onScheduleTap:
              _handleScheduleTap,
          onScheduleDelete:
              _deleteSchedule,
          onCompletedChanged:
              _updateCompleted,
        ),
        const SizedBox(
          height: 24,
        ),
        ScheduleList(
          title: _localizations.tomorrow,
          tasks:
              filteredTomorrowSchedules,
          onScheduleTap:
              _handleScheduleTap,
          onScheduleDelete:
              _deleteSchedule,
          onCompletedChanged:
              _updateCompleted,
        ),
      ],
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final ThemeData theme =
        Theme.of(context);

    return ColoredBox(
      color:
          theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh:
                  _loadSchedules,
              child:
                  SingleChildScrollView(
                physics:
                    const AlwaysScrollableScrollPhysics(),
                padding:
                    const EdgeInsets.fromLTRB(
                  AppConstants.pagePadding,
                  16,
                  AppConstants.pagePadding,
                  110,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    ScheduleHeader(
                      selectedCategory:
                          selectedCategory,
                      onCategorySelected:
                          (
                        String category,
                      ) {
                        setState(() {
                          selectedCategory =
                              category;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 28,
                    ),
                    _buildScheduleContent(),
                  ],
                ),
              ),
            ),

            /*
             * Show the floating add button only
             * while the sheet is closed.
             */
            if (!_showAddScheduleSheet)
              Positioned(
                right:
                    AppConstants.pagePadding,
                bottom: 24,
                child:
                    FloatingActionButton(
                  onPressed:
                      _openAddScheduleSheet,
                  child: const Icon(
                    Icons.add_rounded,
                    size: 28,
                  ),
                ),
              ),

            /*
             * Add the overlay and sheet only when
             * _showAddScheduleSheet is true.
             *
             * This completely removes the sheet
             * after save instead of moving it to
             * bottom: -1000.
             */
            if (_showAddScheduleSheet) ...[
              Positioned.fill(
                child: GestureDetector(
                  behavior:
                      HitTestBehavior.opaque,
                  onTap:
                      _closeAddScheduleSheet,
                  child: Container(
                    color: Colors.black
                        .withValues(
                      alpha: 0.70,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child:
                    AddScheduleSheet(
                  onClose:
                      _closeAddScheduleSheet,
                  onScheduleSaved:
                      _saveNewSchedule,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}