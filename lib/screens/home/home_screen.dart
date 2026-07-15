import 'package:flutter/material.dart';

import '../settings/settings_screen.dart';
import '../statistics_screen/statistics_screen.dart';
import '../widgets/home/greeting_header.dart';
import '../widgets/home/progress_card.dart';
import '../widgets/home/schedule_section.dart';
import '../widgets/home/stat_card.dart';
import '../clocks/world_clocks_screen.dart';
import '../schedule/schedule_screen.dart';
//import '../widgets/bottom_nav_bar.dart';
import '../widgets/schedule/add_schedule_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    _HomePage(),
    ScheduleScreen(),
    StatisticsScreen(),
    WorldClocksScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      // bottomNavigationBar: BottomNavBar(
      //   currentIndex: currentIndex,
      //   onTap: (index) {
      //     setState(() {
      //       currentIndex = index;
      //     });
      //   },
      // ),
    );
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage();

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  void _openAddScheduleSheet() {
    AddScheduleSheet.show(
      context: context,
      onScheduleSaved: (newSchedule) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${newSchedule.title} added successfully',
            ),
            backgroundColor: newSchedule.categoryColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    return ColoredBox(
      color: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.015,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const GreetingHeader(),

                SizedBox(height: screenHeight * 0.025),

                const ProgressCard(),

                SizedBox(height: screenHeight * 0.025),

                Row(
                  children: [
                    const Expanded(
                      child: StatCard(
                        icon: Icons.timer,
                        title: '23h40m',
                        subtitle: 'Focus Time',
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.025),
                    const Expanded(
                      child: StatCard(
                        icon: Icons.flash_on,
                        title: '12/14',
                        subtitle: 'Tasks Done',
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.025),
                    const Expanded(
                      child: StatCard(
                        icon: Icons.nightlight,
                        title: 'Tonight',
                        subtitle: 'Sleep Mode',
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.025),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Today's Schedule",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: (screenWidth * 0.055).clamp(
                            20.0,
                            28.0,
                          ),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _openAddScheduleSheet,
                      icon: const Icon(
                        Icons.add,
                        size: 18,
                      ),
                      label: const Text('Add'),
                      style: TextButton.styleFrom(
                        foregroundColor: colorScheme.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.02),

                const ScheduleSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}