import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class FocusSummaryCard extends StatelessWidget {
  final double totalFocusHours;
  final int completedTasks;

  const FocusSummaryCard({
    super.key,
    required this.totalFocusHours,
    required this.completedTasks,
  });

  String formattedFocusTime(
    AppLocalizations localizations,
  ) {
    final int totalMinutes =
        (totalFocusHours * 60).round();

    final int hours = totalMinutes ~/ 60;
    final int minutes = totalMinutes % 60;

    if (hours == 0) {
      return '$minutes ${localizations.minutesShort}';
    }

    if (minutes == 0) {
      return '$hours ${localizations.hoursShort}';
    }

    return '$hours ${localizations.hoursShort} '
        '$minutes ${localizations.minutesShort}';
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
        Theme.of(context);

    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    final ColorScheme colorScheme =
        theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius:
            BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius:
                  BorderRadius.circular(
                18,
              ),
            ),
            child: Icon(
              Icons.timer_outlined,
              color:
                  colorScheme.onPrimary,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.totalFocusTime,
                  style: theme
                      .textTheme.bodyMedium
                      ?.copyWith(
                    color: colorScheme
                        .onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  formattedFocusTime(
                    localizations,
                  ),
                  style: theme
                      .textTheme.headlineSmall
                      ?.copyWith(
                    color: colorScheme
                        .onPrimaryContainer,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.end,
            children: [
              Text(
                '$completedTasks',
                style: theme
                    .textTheme.headlineSmall
                    ?.copyWith(
                  color: colorScheme
                      .onPrimaryContainer,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
              Text(
                completedTasks == 1
                    ? localizations.taskDone
                    : localizations.tasksDonePlural,
                style: theme
                    .textTheme.bodySmall
                    ?.copyWith(
                  color: colorScheme
                      .onPrimaryContainer,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}