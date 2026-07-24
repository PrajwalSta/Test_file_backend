import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
        Theme.of(context);

    final ColorScheme colorScheme =
        theme.colorScheme;

    final bool isDark =
        theme.brightness ==
            Brightness.dark;

    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,

      backgroundColor: isDark
          ? const Color(0xff0D0E20)
          : Colors.white,

      selectedItemColor:
          colorScheme.primary,

      unselectedItemColor:
          colorScheme.onSurfaceVariant,

      selectedIconTheme: IconThemeData(
        color: colorScheme.primary,
        size: 26,
      ),

      unselectedIconTheme: IconThemeData(
        color:
            colorScheme.onSurfaceVariant,
        size: 24,
      ),

      selectedLabelStyle:
          const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),

      unselectedLabelStyle:
          const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),

      showSelectedLabels: true,
      showUnselectedLabels: true,

      elevation: 8,

      items: [
        BottomNavigationBarItem(
          icon: const Icon(
            Icons.home_outlined,
          ),
          activeIcon: const Icon(
            Icons.home,
          ),
          label: localizations.home,
        ),

        BottomNavigationBarItem(
          icon: const Icon(
            Icons.schedule_outlined,
          ),
          activeIcon: const Icon(
            Icons.schedule,
          ),
          label: localizations.schedule,
        ),

        BottomNavigationBarItem(
          icon: const Icon(
            Icons.bar_chart_outlined,
          ),
          activeIcon: const Icon(
            Icons.bar_chart,
          ),
          label:
              localizations.statistics,
        ),

        BottomNavigationBarItem(
          icon: const Icon(
            Icons.access_time_outlined,
          ),
          activeIcon: const Icon(
            Icons.access_time,
          ),
          label: localizations.clocks,
        ),

        BottomNavigationBarItem(
          icon: const Icon(
            Icons.settings_outlined,
          ),
          activeIcon: const Icon(
            Icons.settings,
          ),
          label: localizations.settings,
        ),
      ],
    );
  }
}