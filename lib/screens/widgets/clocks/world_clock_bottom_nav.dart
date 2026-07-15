import 'package:flutter/material.dart';

/// Bottom navigation bar for app navigation
class WorldClockBottomNav extends StatelessWidget {
  const WorldClockBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      type: BottomNavigationBarType.fixed,
      currentIndex: 4,

      selectedItemColor: const Color(0xff8B5CF6),
      unselectedItemColor: Colors.white54,

      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.schedule),
          label: "Schedule",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: "Calendar",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: "Stats",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.public),
          label: "Clocks",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: "Settings",
        ),
      ],
    );
  }
}