
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/schedule_model.dart';
import '../../services/sleep_setting_service.dart';
import '../widgets/home/greeting_header.dart';
import '../widgets/home/progress_card.dart';
import '../widgets/home/schedule_section.dart';
import '../widgets/home/stat_card.dart';
import '../widgets/schedule/add_schedule_sheet.dart';
import '../widgets/schedule/category_selector.dart';

class HomeScreen extends StatefulWidget {
  final int sleepSettingsRefreshVersion;
  final int scheduleRefreshVersion;

  final VoidCallback? onScheduleUpdated;
  final VoidCallback? onOpenSchedule;

  const HomeScreen({
    super.key,
    this.sleepSettingsRefreshVersion = 0,
    this.scheduleRefreshVersion = 0,
    this.onScheduleUpdated,
    this.onOpenSchedule,
  });

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SupabaseClient _supabase =
      Supabase.instance.client;

  final SleepSettingService
      _sleepSettingService =
      SleepSettingService();

  List<ScheduleModel> todaySchedules = [];

  int completedTasks = 0;
  int totalTasks = 0;
  int totalFocusMinutes = 0;

  TimeOfDay _sleepTime =
      const TimeOfDay(
    hour: 22,
    minute: 0,
  );

  TimeOfDay _wakeTime =
      const TimeOfDay(
    hour: 7,
    minute: 0,
  );

  bool _sleepModeEnabled = false;
  bool _isLoading = true;

  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _loadTodaySchedules();
    _loadSleepSettings();
  }

  @override
  void didUpdateWidget(
    covariant HomeScreen oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.sleepSettingsRefreshVersion !=
        widget.sleepSettingsRefreshVersion) {
      _loadSleepSettings();
    }

    if (oldWidget.scheduleRefreshVersion !=
        widget.scheduleRefreshVersion) {
      _loadTodaySchedules();
    }
  }

  double get todayProgress {
    if (totalTasks == 0) {
      return 0.0;
    }

    return completedTasks / totalTasks;
  }

  String get focusTimeText {
    final int hours =
        totalFocusMinutes ~/ 60;

    final int minutes =
        totalFocusMinutes % 60;

    if (hours == 0 && minutes == 0) {
      return '0m';
    }

    if (hours == 0) {
      return '${minutes}m';
    }

    if (minutes == 0) {
      return '${hours}h';
    }

    return '${hours}h ${minutes}m';
  }

  String get sleepModeText {
    if (!_sleepModeEnabled) {
      return 'Off';
    }

    final DateTime now =
        DateTime.now();

    final DateTime bedtimeToday =
        DateTime(
      now.year,
      now.month,
      now.day,
      _sleepTime.hour,
      _sleepTime.minute,
    );

    final DateTime wakeTimeToday =
        DateTime(
      now.year,
      now.month,
      now.day,
      _wakeTime.hour,
      _wakeTime.minute,
    );

    if (now.isBefore(wakeTimeToday)) {
      return 'Sleeping';
    }

    if (!now.isBefore(bedtimeToday)) {
      return 'Sleeping';
    }

    final Duration remaining =
        bedtimeToday.difference(now);

    return _formatDuration(
      remaining,
    );
  }

  String _formatDuration(
    Duration duration,
  ) {
    final int hours =
        duration.inHours;

    final int minutes =
        duration.inMinutes % 60;

    if (hours == 0) {
      return '${minutes}m';
    }

    if (minutes == 0) {
      return '${hours}h';
    }

    return '${hours}h ${minutes}m';
  }

  String _formatDatabaseDate(
    DateTime date,
  ) {
    final String month =
        date.month.toString().padLeft(2, '0');

    final String day =
        date.day.toString().padLeft(2, '0');

    return '${date.year}-$month-$day';
  }

  Future<void> _loadSleepSettings() async {
    try {
      final Map<String, dynamic> settings =
          await _sleepSettingService
              .getSleepSettings();

      final String sleepValue =
          settings['sleep_time']
                  ?.toString() ??
              '22:00:00';

      final String wakeValue =
          settings['wake_time']
                  ?.toString() ??
              '07:00:00';

      final List<String> sleepParts =
          sleepValue.split(':');

      final List<String> wakeParts =
          wakeValue.split(':');

      final int sleepHour =
          int.tryParse(
                sleepParts.first,
              ) ??
              22;

      final int sleepMinute =
          sleepParts.length > 1
              ? int.tryParse(
                    sleepParts[1],
                  ) ??
                  0
              : 0;

      final int wakeHour =
          int.tryParse(
                wakeParts.first,
              ) ??
              7;

      final int wakeMinute =
          wakeParts.length > 1
              ? int.tryParse(
                    wakeParts[1],
                  ) ??
                  0
              : 0;

      if (!mounted) {
        return;
      }

      setState(() {
        _sleepTime = TimeOfDay(
          hour: sleepHour,
          minute: sleepMinute,
        );

        _wakeTime = TimeOfDay(
          hour: wakeHour,
          minute: wakeMinute,
        );

        _sleepModeEnabled =
            settings['enabled'] == true;
      });
    } catch (error) {
      debugPrint(
        'Home Sleep Mode load error: $error',
      );
    }
  }

  Future<void> _loadTodaySchedules() async {
    final User? currentUser =
        _supabase.auth.currentUser;

    if (currentUser == null) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage =
            'Please log in to view schedules.';

        todaySchedules = [];
        completedTasks = 0;
        totalTasks = 0;
        totalFocusMinutes = 0;
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

      final String todayDatabaseDate =
          _formatDatabaseDate(today);

      final List<Map<String, dynamic>> response =
          await _supabase
              .from('schedules')
              .select()
              .eq(
                'user_id',
                currentUser.id,
              )
              .eq(
                'schedule_date',
                todayDatabaseDate,
              )
              .order(
                'created_at',
                ascending: true,
              );

      final List<ScheduleModel> loadedSchedules =
          response.map((row) {
        final String categoryName =
            row['category']?.toString() ??
                'Study';

        final ScheduleCategory category =
            CategorySelector.categories
                .firstWhere(
          (ScheduleCategory item) =>
              item.name == categoryName,
          orElse: () =>
              CategorySelector
                  .categories.first,
        );

        final String scheduleDateValue =
            row['schedule_date']
                    ?.toString() ??
                todayDatabaseDate;

        final DateTime scheduleDate =
            DateTime.tryParse(
                  scheduleDateValue,
                ) ??
                today;

        return ScheduleModel(
          id: row['id']?.toString(),
          emoji: category.emoji,
          title:
              row['title']?.toString() ??
                  'Untitled',
          time:
              row['time']?.toString() ??
                  '09:00 AM',
          scheduleDate:
              scheduleDate,
          category:
              categoryName,
          categoryColor:
              category.color,
          focusMode:
              row['focus_mode']?.toString() ??
                  'Study Mode',
          durationMinutes:
              (row['duration_minutes']
                          as num?)
                      ?.toInt() ??
                  0,
          completed:
              row['completed'] == true,
        );
      }).toList();

      final int completedCount =
          loadedSchedules.where(
        (ScheduleModel schedule) {
          return schedule.completed;
        },
      ).length;

      final int calculatedFocusMinutes =
          loadedSchedules.fold(
        0,
        (
          int total,
          ScheduleModel schedule,
        ) {
          return total +
              schedule.durationMinutes;
        },
      );

      final List<ScheduleModel>
          incompleteSchedules =
          loadedSchedules.where(
        (ScheduleModel schedule) {
          return !schedule.completed;
        },
      ).toList();

      if (!mounted) {
        return;
      }

      setState(() {
        todaySchedules =
            incompleteSchedules;

        completedTasks =
            completedCount;

        totalTasks =
            loadedSchedules.length;

        totalFocusMinutes =
            calculatedFocusMinutes;

        _isLoading = false;
      });
    } on PostgrestException catch (error) {
      debugPrint(
        'Home schedule error: ${error.message}',
      );

      debugPrint(
        'Home schedule code: ${error.code}',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;

        _errorMessage =
            'Database error: ${error.message}';

        todaySchedules = [];
        completedTasks = 0;
        totalTasks = 0;
        totalFocusMinutes = 0;
      });
    } catch (error, stackTrace) {
      debugPrint(
        'Home schedule loading error: $error',
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
            'Unable to load schedules.';

        todaySchedules = [];
        completedTasks = 0;
        totalTasks = 0;
        totalFocusMinutes = 0;
      });
    }
  }

  Future<void> _refreshHomeData() async {
    await Future.wait([
      _loadTodaySchedules(),
      _loadSleepSettings(),
    ]);
  }

  void _openAddScheduleSheet() {
    AddScheduleSheet.show(
      context: context,
      onScheduleSaved:
          (ScheduleModel newSchedule) async {
        await _loadTodaySchedules();

        widget.onScheduleUpdated?.call();

        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
              '${newSchedule.title} added successfully',
            ),
            backgroundColor:
                newSchedule.categoryColor,
            behavior:
                SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(12),
            ),
          ),
        );
      },
    );
  }

  void _handleScheduleTap(
    ScheduleModel schedule,
  ) {
    widget.onOpenSchedule?.call();
  }

  Widget _buildScheduleSection() {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(28),
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          children: [
            Text(
              _errorMessage!,
              textAlign:
                  TextAlign.center,
            ),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton.icon(
              onPressed:
                  _loadTodaySchedules,
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label:
                  const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    return ScheduleSection(
      schedules:
          todaySchedules,
      onScheduleTap:
          _handleScheduleTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
        Theme.of(context);

    final ColorScheme colorScheme =
        theme.colorScheme;

    final Size screenSize =
        MediaQuery.sizeOf(context);

    final double screenWidth =
        screenSize.width;

    final double screenHeight =
        screenSize.height;

    return ColoredBox(
      color:
          theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh:
              _refreshHomeData,
          child:
              SingleChildScrollView(
            physics:
                const AlwaysScrollableScrollPhysics(),
            padding:
                EdgeInsets.symmetric(
              horizontal:
                  screenWidth * 0.05,
              vertical:
                  screenHeight * 0.015,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const GreetingHeader(),

                SizedBox(
                  height:
                      screenHeight * 0.025,
                ),

                ProgressCard(
                  progress:
                      todayProgress,
                  completedTasks:
                      completedTasks,
                  totalTasks:
                      totalTasks,
                ),

                SizedBox(
                  height:
                      screenHeight * 0.025,
                ),

                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        icon:
                            Icons.timer,
                        title:
                            focusTimeText,
                        subtitle:
                            'Focus Time',
                      ),
                    ),

                    SizedBox(
                      width:
                          screenWidth * 0.025,
                    ),

                    Expanded(
                      child: StatCard(
                        icon: Icons
                            .check_circle_outline_rounded,
                        title:
                            '$completedTasks/$totalTasks',
                        subtitle:
                            'Tasks Done',
                      ),
                    ),

                    SizedBox(
                      width:
                          screenWidth * 0.025,
                    ),

                    Expanded(
                      child: StatCard(
                        icon: Icons
                            .nightlight_rounded,
                        title:
                            sleepModeText,
                        subtitle:
                            'Sleep Mode',
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height:
                      screenHeight * 0.025,
                ),

                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap:
                            widget.onOpenSchedule,
                        borderRadius:
                            BorderRadius.circular(
                          8,
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            vertical: 4,
                          ),
                          child: Text(
                            "Today's Schedule",
                            maxLines: 1,
                            overflow:
                                TextOverflow
                                    .ellipsis,
                            style:
                                TextStyle(
                              color:
                                  colorScheme
                                      .onSurface,
                              fontSize:
                                  (screenWidth *
                                          0.055)
                                      .clamp(
                                20.0,
                                28.0,
                              ),
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    TextButton.icon(
                      onPressed:
                          _openAddScheduleSheet,
                      icon:
                          const Icon(
                        Icons.add,
                        size: 18,
                      ),
                      label:
                          const Text('Add'),
                      style:
                          TextButton.styleFrom(
                        foregroundColor:
                            colorScheme.primary,
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 10,
                        ),
                        textStyle:
                            const TextStyle(
                          fontSize: 14,
                          fontWeight:
                              FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height:
                      screenHeight * 0.02,
                ),

                _buildScheduleSection(),

                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
