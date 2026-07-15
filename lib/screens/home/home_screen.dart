import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/schedule_model.dart';
import '../clocks/world_clocks_screen.dart';
import '../schedule/schedule_screen.dart';
import '../settings/settings_screen.dart';
import '../statistics_screen/statistics_screen.dart';
import '../widgets/home/greeting_header.dart';
import '../widgets/home/progress_card.dart';
import '../widgets/home/schedule_section.dart';
import '../widgets/home/stat_card.dart';
import '../widgets/schedule/add_schedule_sheet.dart';
import '../widgets/schedule/category_selector.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  int scheduleRefreshVersion = 0;

  void _refreshScheduleScreen() {
    setState(() {
      scheduleRefreshVersion++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final List<Widget> pages = [
      _HomePage(
        onScheduleSaved: _refreshScheduleScreen,
      ),
      ScheduleScreen(
        key: ValueKey(
          scheduleRefreshVersion,
        ),
      ),
      const StatisticsScreen(),
      const WorldClocksScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      backgroundColor:
          theme.scaffoldBackgroundColor,
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
    );
  }
}

class _HomePage extends StatefulWidget {
  final VoidCallback onScheduleSaved;

  const _HomePage({
    required this.onScheduleSaved,
  });

  @override
  State<_HomePage> createState() =>
      _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  final SupabaseClient _supabase =
      Supabase.instance.client;

  List<ScheduleModel> todaySchedules = [];

  int completedTasks = 0;
  int totalTasks = 0;

  bool _isLoading = true;

  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _loadTodaySchedules();
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
      // Load every schedule for today.
      // Do not filter completed here because we need
      // completed tasks for the Tasks Done count.
      final List<Map<String, dynamic>> response =
          await _supabase
              .from('schedules')
              .select()
              .eq(
                'user_id',
                currentUser.id,
              )
              .eq(
                'schedule_day',
                'today',
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
            CategorySelector.categories.firstWhere(
          (item) =>
              item.name == categoryName,
          orElse: () =>
              CategorySelector.categories.first,
        );

        return ScheduleModel(
          id: row['id']?.toString(),
          emoji: category.emoji,
          title:
              row['title']?.toString() ??
                  'Untitled',
          time:
              row['time']?.toString() ??
                  '09:00 AM',
          category: categoryName,
          categoryColor: category.color,
          focusMode:
              row['focus_mode']?.toString() ??
                  'Study Mode',
          durationMinutes:
              (row['duration_minutes'] as num?)
                      ?.toInt() ??
                  0,
          completed:
              row['completed'] == true,
        );
      }).toList();

      // Count completed schedules.
      final int completedCount =
          loadedSchedules.where((schedule) {
        return schedule.completed;
      }).length;

      // Show only incomplete schedules on Home.
      final List<ScheduleModel>
          incompleteSchedules =
          loadedSchedules.where((schedule) {
        return !schedule.completed;
      }).toList();

      if (!mounted) {
        return;
      }

      setState(() {
        // Only incomplete schedules are visible.
        todaySchedules =
            incompleteSchedules;

        // Completed count for Tasks Done.
        completedTasks =
            completedCount;

        // Total includes both completed
        // and incomplete schedules.
        totalTasks =
            loadedSchedules.length;

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
      });
    }
  }

  void _openAddScheduleSheet() {
    AddScheduleSheet.show(
      context: context,
      onScheduleSaved: (newSchedule) async {
        // Refresh Home after saving.
        await _loadTodaySchedules();

        // Refresh Schedule screen too.
        widget.onScheduleSaved();

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
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          '${schedule.title} selected',
        ),
        behavior:
            SnackBarBehavior.floating,
      ),
    );
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
      schedules: todaySchedules,
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

    final double screenWidth =
        MediaQuery.sizeOf(context).width;

    final double screenHeight =
        MediaQuery.sizeOf(context).height;

    return ColoredBox(
      color:
          theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh:
              _loadTodaySchedules,
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

                const ProgressCard(),

                SizedBox(
                  height:
                      screenHeight * 0.025,
                ),

                Row(
                  children: [
                    const Expanded(
                      child: StatCard(
                        icon: Icons.timer,
                        title: '23h40m',
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

                    const Expanded(
                      child: StatCard(
                        icon:
                            Icons.nightlight,
                        title: 'Tonight',
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
                      child: Text(
                        "Today's Schedule",
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style: TextStyle(
                          color:
                              colorScheme.onSurface,
                          fontSize:
                              (screenWidth * 0.055)
                                  .clamp(
                            20.0,
                            28.0,
                          ),
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),

                    TextButton.icon(
                      onPressed:
                          _openAddScheduleSheet,
                      icon: const Icon(
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