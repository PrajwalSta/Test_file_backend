import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../theme/app_constants.dart';
import '../widgets/statistics/category_chart_card.dart';
import '../widgets/statistics/daily_focus_chart.dart';
import '../widgets/statistics/focus_summary_card.dart';
import '../widgets/statistics/monthly_focus_card.dart';
import '../widgets/statistics/statistics_header.dart';
import '../widgets/statistics/statistics_overview.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() =>
      _StatisticsScreenState();
}

class _StatisticsScreenState
    extends State<StatisticsScreen> {
  final SupabaseClient _supabase =
      Supabase.instance.client;

  bool _isLoading = true;
  String? _errorMessage;

  int _totalTasks = 0;
  int _completedTasks = 0;
  int _totalFocusMinutes = 0;

  Map<String, double> _dailyFocusData = {};
  Map<String, double> _categoryFocusData = {};
  Map<String, double> _monthlyFocusData = {};

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage = 'Please log in to view statistics.';
      });

      return;
    }

    try {
      final response = await _supabase
          .from('schedules')
          .select(
            'id, title, category, duration_minutes, '
            'scheduled_at, completed',
          )
          .eq('user_id', user.id)
          .order(
            'scheduled_at',
            ascending: true,
          );

      final schedules =
          List<Map<String, dynamic>>.from(
        response,
      );

      int completedTasks = 0;
      int totalFocusMinutes = 0;

      final Map<String, double> dailyData = {};
      final Map<String, double> categoryData = {};
      final Map<String, double> monthlyData = {};

      for (final schedule in schedules) {
        final bool completed =
            schedule['completed'] == true;

        if (!completed) {
          continue;
        }

        completedTasks++;

        final int durationMinutes =
            _readInt(
          schedule['duration_minutes'],
        );

        totalFocusMinutes += durationMinutes;

        final String category =
            schedule['category']
                    ?.toString()
                    .trim()
                    .isNotEmpty ==
                true
            ? schedule['category'].toString()
            : 'Other';

        categoryData[category] =
            (categoryData[category] ?? 0) +
                durationMinutes.toDouble();

        final String? scheduledAtValue =
            schedule['scheduled_at']?.toString();

        if (scheduledAtValue == null) {
          continue;
        }

        final DateTime? scheduledAt =
            DateTime.tryParse(
          scheduledAtValue,
        )?.toLocal();

        if (scheduledAt == null) {
          continue;
        }

        final String dayKey =
            _getDayName(scheduledAt.weekday);

        dailyData[dayKey] =
            (dailyData[dayKey] ?? 0) +
                durationMinutes.toDouble();

        final String monthKey =
            _getMonthName(scheduledAt.month);

        monthlyData[monthKey] =
            (monthlyData[monthKey] ?? 0) +
                durationMinutes.toDouble();
      }

      final orderedDailyData =
          _createOrderedDailyData(dailyData);

      if (!mounted) {
        return;
      }

      setState(() {
        _totalTasks = schedules.length;
        _completedTasks = completedTasks;
        _totalFocusMinutes = totalFocusMinutes;

        _dailyFocusData = orderedDailyData;
        _categoryFocusData = categoryData;
        _monthlyFocusData = monthlyData;

        _isLoading = false;
        _errorMessage = null;
      });
    } catch (error) {
      debugPrint(
        'Error loading statistics: $error',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage =
            'Unable to load statistics.';
      });
    }
  }

  int _readInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  Map<String, double> _createOrderedDailyData(
    Map<String, double> data,
  ) {
    const days = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];

    return {
      for (final day in days)
        day: data[day] ?? 0,
    };
  }

  String _getDayName(int weekday) {
    const days = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];

    return days[weekday - 1];
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return months[month - 1];
  }

  double get _completionPercentage {
    if (_totalTasks == 0) {
      return 0;
    }

    return (_completedTasks / _totalTasks) * 100;
  }

  double get _totalFocusHours {
    return _totalFocusMinutes / 60;
  }

  Future<void> _refreshStatistics() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await _loadStatistics();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor:
          theme.scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.bar_chart_rounded,
                size: 52,
              ),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _refreshStatistics,
                icon: const Icon(
                  Icons.refresh,
                ),
                label: const Text(
                  'Try Again',
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshStatistics,
      child: SingleChildScrollView(
        physics:
            const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.fromLTRB(
          AppConstants.screenHorizontalPadding,
          18,
          AppConstants.screenHorizontalPadding,
          20,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const StatisticsHeader(),
            const SizedBox(height: 16),

            FocusSummaryCard(
              totalFocusHours:
                  _totalFocusHours,
              completedTasks:
                  _completedTasks,
            ),
            const SizedBox(height: 12),

            StatisticsOverview(
              totalTasks: _totalTasks,
              completedTasks:
                  _completedTasks,
              completionPercentage:
                  _completionPercentage,
            ),
            const SizedBox(height: 14),

            DailyFocusChart(
              dailyData:
                  _dailyFocusData,
            ),
            const SizedBox(height: 14),

            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 6,
                  child: CategoryChartCard(
                    categoryData:
                        _categoryFocusData,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 4,
                  child: MonthlyFocusCard(
                    monthlyData:
                        _monthlyFocusData,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}