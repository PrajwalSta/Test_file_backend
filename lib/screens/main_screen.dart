import 'package:flutter/material.dart';

import '../screens/clocks/world_clocks_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/schedule/schedule_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/statistics_screen/statistics_screen.dart';
import '../screens/widgets/bottom_nav_bar.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;

  const MainScreen({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainScreen> createState() =>
      _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int currentIndex;

  int sleepSettingsRefreshVersion = 0;
  int scheduleRefreshVersion = 0;

  @override
  void initState() {
    super.initState();

    if (widget.initialIndex >= 0 &&
        widget.initialIndex < 5) {
      currentIndex = widget.initialIndex;
    } else {
      currentIndex = 0;
    }
  }

  void changePage(int index) {
    if (index < 0 || index >= 5) {
      return;
    }

    setState(() {
      currentIndex = index;
    });
  }

  void _refreshSleepSettings() {
    setState(() {
      sleepSettingsRefreshVersion++;
    });
  }

  void _refreshSchedules() {
    setState(() {
      scheduleRefreshVersion++;
    });
  }

  void _openScheduleScreen() {
    changePage(1);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeScreen(
        sleepSettingsRefreshVersion:
            sleepSettingsRefreshVersion,

        // Added: Home reloads when schedules change.
        scheduleRefreshVersion:
            scheduleRefreshVersion,

        onScheduleUpdated:
            _refreshSchedules,

        // Open the Schedule bottom navigation page.
        onOpenSchedule:
            _openScheduleScreen,
      ),

      ScheduleScreen(
        // Added: Notify MainScreen after add,
        // complete, or delete.
        onScheduleUpdated:
            _refreshSchedules,
      ),

      const StatisticsScreen(),

      const WorldClocksScreen(),

      SettingsScreen(
        onSleepSettingsUpdated:
            _refreshSleepSettings,
      ),
    ];

    return Scaffold(
      backgroundColor:
          Theme.of(context)
              .scaffoldBackgroundColor,
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: changePage,
      ),
    );
  }
}