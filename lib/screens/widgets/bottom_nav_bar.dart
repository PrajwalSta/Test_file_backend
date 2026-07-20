import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // return BottomNavigationBar(
    //   currentIndex: currentIndex,
    //   onTap: onTap,
    //   type: BottomNavigationBarType.fixed,
    //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    //   selectedItemColor: Colors.deepPurple,
    //   unselectedItemColor: Colors.grey,
    //   items: const [
    //     BottomNavigationBarItem(
    //       icon: Icon(Icons.home_outlined),
    //       activeIcon: Icon(Icons.home),
    //       label: 'Home',
    //     ),
    //     BottomNavigationBarItem(
    //       icon: Icon(Icons.schedule_outlined),
    //       activeIcon: Icon(Icons.schedule),
    //       label: 'Schedule',
    //     ),
    //     BottomNavigationBarItem(
    //       icon: Icon(Icons.bar_chart_outlined),
    //       activeIcon: Icon(Icons.bar_chart),
    //       label: 'Stats',
    //     ),
    //     BottomNavigationBarItem(
    //       icon: Icon(Icons.access_time_outlined),
    //       activeIcon: Icon(Icons.access_time),
    //       label: 'Clocks',
    //     ),
    //     BottomNavigationBarItem(
    //       icon: Icon(Icons.settings_outlined),
    //       activeIcon: Icon(Icons.settings),
    //       label: 'Settings',
    //     ),
    //   ],
    // );
    return BottomNavigationBar(
  currentIndex: currentIndex,
  onTap: onTap,
  type: BottomNavigationBarType.fixed,
  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
  selectedItemColor: Colors.deepPurple,
  unselectedItemColor: Colors.grey,
  items: [
    BottomNavigationBarItem(
      icon: const Icon(Icons.home_outlined),
      activeIcon: const Icon(Icons.home),
      label: AppLocalizations.of(context)!.home,
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.schedule_outlined),
      activeIcon: const Icon(Icons.schedule),
      label: AppLocalizations.of(context)!.schedule,
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.bar_chart_outlined),
      activeIcon: const Icon(Icons.bar_chart),
      label: AppLocalizations.of(context)!.statistics,
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.access_time_outlined),
      activeIcon: const Icon(Icons.access_time),
      label: AppLocalizations.of(context)!.clocks,
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.settings_outlined),
      activeIcon: const Icon(Icons.settings),
      label: AppLocalizations.of(context)!.settings,
    ),
  ],
);
  }
}