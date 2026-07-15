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
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int currentIndex;

  final List<Widget> pages = const [
    HomeScreen(),
    ScheduleScreen(),
    StatisticsScreen(),
    WorldClocksScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();

    if (widget.initialIndex >= 0 && widget.initialIndex < pages.length) {
      currentIndex = widget.initialIndex;
    } else {
      currentIndex = 0;
    }
  }

  void changePage(int index) {
    if (index < 0 || index >= pages.length) {
      return;
    }

    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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