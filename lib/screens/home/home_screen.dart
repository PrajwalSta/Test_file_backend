import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../l10n/app_localizations.dart';
import '../../models/profile/profile_model.dart';
import '../../models/schedule_model.dart';
import '../../services/notification_setting_service.dart';
import '../../services/profile/profile_service.dart';
import '../../services/sleep_setting_service.dart';
import '../notifications/notification_inbox_screen.dart';
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

  final ProfileService _profileService =
      ProfileService();

  final NotificationSettingService
      _notificationSettingService =
      NotificationSettingService();

  List<ScheduleModel> todaySchedules = [];

  String _profileName = 'User';

  int _unreadNotificationCount = 0;
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
  bool _isProfileLoading = true;

  String? _errorType;
  String? _databaseError;

  @override
  void initState() {
    super.initState();

    _loadProfileName();
    _loadTodaySchedules();
    _loadSleepSettings();
    _loadUnreadNotificationCount();
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
      _loadUnreadNotificationCount();
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

  String _getSleepModeText(
    AppLocalizations localizations,
  ) {
    if (!_sleepModeEnabled) {
      return localizations.off;
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
      return localizations.sleeping;
    }

    if (!now.isBefore(bedtimeToday)) {
      return localizations.sleeping;
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

  String _getErrorMessage(
    AppLocalizations localizations,
  ) {
    if (_errorType == 'login') {
      return localizations
          .pleaseLoginToViewSchedules;
    }

    if (_errorType == 'database') {
      return localizations.databaseError(
        _databaseError ?? '',
      );
    }

    return localizations
        .unableToLoadSchedules;
  }

  Future<void> _loadProfileName() async {
    try {
      final ProfileModel profile =
          await _profileService.getProfile();

      if (!mounted) {
        return;
      }

      setState(() {
        final String loadedName =
            profile.fullName.trim();

        _profileName =
            loadedName.isEmpty
                ? _getFallbackName()
                : loadedName;

        _isProfileLoading = false;
      });
    } catch (error) {
      debugPrint(
        'Home profile loading error: $error',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _profileName =
            _getFallbackName();

        _isProfileLoading = false;
      });
    }
  }

  Future<void>
      _loadUnreadNotificationCount() async {
    final User? currentUser =
        _supabase.auth.currentUser;

    if (currentUser == null) {
      if (!mounted) {
        return;
      }

      setState(() {
        _unreadNotificationCount = 0;
      });

      return;
    }

    try {
      final int count =
          await _notificationSettingService
              .getUnreadNotificationCount();

      if (!mounted) {
        return;
      }

      setState(() {
        _unreadNotificationCount = count;
      });
    } on PostgrestException catch (error) {
      debugPrint(
        'Unread notification database error: '
        '${error.message}',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _unreadNotificationCount = 0;
      });
    } catch (error) {
      debugPrint(
        'Unread notification count error: $error',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _unreadNotificationCount = 0;
      });
    }
  }

  String _getFallbackName() {
    final User? currentUser =
        _supabase.auth.currentUser;

    final dynamic metadataName =
        currentUser
            ?.userMetadata?['full_name'];

    if (metadataName != null &&
        metadataName
            .toString()
            .trim()
            .isNotEmpty) {
      return metadataName
          .toString()
          .trim();
    }

    final String? email =
        currentUser?.email;

    if (email != null &&
        email.contains('@')) {
      final String emailName =
          email.split('@').first;

      if (emailName.isNotEmpty) {
        return _formatProfileName(
          emailName,
        );
      }
    }

    return 'User';
  }

  String _formatProfileName(
    String value,
  ) {
    final String cleanedValue =
        value
            .replaceAll('.', ' ')
            .replaceAll('_', ' ')
            .replaceAll('-', ' ')
            .trim();

    if (cleanedValue.isEmpty) {
      return 'User';
    }

    return cleanedValue
        .split(' ')
        .where(
          (String word) =>
              word.isNotEmpty,
        )
        .map(
          (String word) {
            if (word.length == 1) {
              return word.toUpperCase();
            }

            return '${word[0].toUpperCase()}'
                '${word.substring(1).toLowerCase()}';
          },
        )
        .join(' ');
  }

  Future<void> _openNotifications() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return const NotificationInboxScreen();
        },
      ),
    );

    if (!mounted) {
      return;
    }

    await _loadUnreadNotificationCount();
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
        _errorType = 'login';
        _databaseError = null;

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
        _errorType = null;
        _databaseError = null;
      });
    }

    try {
      final DateTime now =
          DateTime.now();

      final DateTime startOfToday =
          DateTime(
        now.year,
        now.month,
        now.day,
      );

      final DateTime startOfTomorrow =
          startOfToday.add(
        const Duration(days: 1),
      );

      final List<Map<String, dynamic>> response =
          await _supabase
              .from('schedules')
              .select()
              .eq(
                'user_id',
                currentUser.id,
              )
              .gte(
                'scheduled_at',
                startOfToday
                    .toUtc()
                    .toIso8601String(),
              )
              .lt(
                'scheduled_at',
                startOfTomorrow
                    .toUtc()
                    .toIso8601String(),
              )
              .order(
                'scheduled_at',
                ascending: true,
              );

      debugPrint(
        'Home loaded rows: ${response.length}',
      );

      final List<ScheduleModel>
          loadedSchedules = [];

      for (final Map<String, dynamic> row
          in response) {
        final String? scheduledAtValue =
            row['scheduled_at']
                ?.toString();

        if (scheduledAtValue == null ||
            scheduledAtValue.isEmpty) {
          continue;
        }

        final DateTime? parsedDate =
            DateTime.tryParse(
          scheduledAtValue,
        );

        if (parsedDate == null) {
          continue;
        }

        final DateTime localScheduleDate =
            parsedDate.toLocal();

        final String categoryName =
            row['category']?.toString() ??
                'Study';

        final ScheduleCategory category =
            CategorySelector.categories
                .firstWhere(
          (ScheduleCategory item) {
            return item.name ==
                categoryName;
          },
          orElse: () {
            return CategorySelector
                .categories.first;
          },
        );

        loadedSchedules.add(
          ScheduleModel(
            id: row['id']?.toString(),
            emoji: category.emoji,
            title:
                row['title']?.toString() ??
                    'Untitled',
            time:
                row['time']?.toString() ??
                    '',
            scheduleDate:
                localScheduleDate,
            category:
                categoryName,
            categoryColor:
                category.color,
            focusMode:
                row['focus_mode']
                        ?.toString() ??
                    'Study Mode',
            durationMinutes:
                (row['duration_minutes']
                            as num?)
                        ?.toInt() ??
                    0,
            completed:
                row['completed'] == true,
          ),
        );
      }

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
        _errorType = 'database';
        _databaseError = error.message;

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
        _errorType = 'loading';
        _databaseError = null;

        todaySchedules = [];
        completedTasks = 0;
        totalTasks = 0;
        totalFocusMinutes = 0;
      });
    }
  }

  Future<void> _refreshHomeData() async {
    await Future.wait([
      _loadProfileName(),
      _loadTodaySchedules(),
      _loadSleepSettings(),
      _loadUnreadNotificationCount(),
    ]);
  }

  void _openAddScheduleSheet() {
    AddScheduleSheet.show(
      context: context,
      onScheduleSaved:
          (ScheduleModel newSchedule) async {
        await _loadTodaySchedules();
        await _loadUnreadNotificationCount();

        widget.onScheduleUpdated?.call();

        if (!mounted) {
          return;
        }

        final AppLocalizations localizations =
            AppLocalizations.of(context)!;

        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
              localizations
                  .scheduleAddedSuccessfully(
                newSchedule.title,
              ),
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

  Widget _buildScheduleSection(
    AppLocalizations localizations,
  ) {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(28),
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    if (_errorType != null) {
      return Center(
        child: Column(
          children: [
            Text(
              _getErrorMessage(
                localizations,
              ),
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
              label: Text(
                localizations.tryAgain,
              ),
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

    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

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
                GreetingHeader(
                  profileName:
                      _isProfileLoading
                          ? 'Loading...'
                          : _profileName,
                  unreadNotificationCount:
                      _unreadNotificationCount,
                  onNotificationTap:
                      _openNotifications,
                ),

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
                            localizations
                                .focusTime,
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
                            localizations
                                .tasksDone,
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
                            _getSleepModeText(
                          localizations,
                        ),
                        subtitle:
                            localizations
                                .sleepMode,
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
                            localizations
                                .todaysSchedule,
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
                      label: Text(
                        localizations.add,
                      ),
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

                _buildScheduleSection(
                  localizations,
                ),

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