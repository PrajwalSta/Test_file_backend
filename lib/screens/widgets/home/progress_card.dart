import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class ProgressCard extends StatelessWidget {
  // Progress value should be between 0.0 and 1.0.
  final double progress;

  // Number of completed schedules.
  final int completedTasks;

  // Total number of schedules.
  final int totalTasks;

  const ProgressCard({
    super.key,
    required this.progress,
    required this.completedTasks,
    required this.totalTasks,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
        Theme.of(context);

    final ColorScheme colorScheme =
        theme.colorScheme;

    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    /*
     * Keep the task values safe.
     */
    final int safeTotalTasks =
        totalTasks < 0 ? 0 : totalTasks;

    final int safeCompletedTasks =
        completedTasks.clamp(
      0,
      safeTotalTasks,
    );

    /*
     * Keep progress between 0 and 1.
     */
    final double safeProgress =
        progress.clamp(
      0.0,
      1.0,
    );

    /*
     * Convert progress into percentage.
     */
    final int percentage =
        (safeProgress * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(
        16,
      ),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius:
            BorderRadius.circular(
          20,
        ),
        border: Border.all(
          color: theme.dividerColor
              .withValues(
            alpha: 0.45,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  localizations
                      .todaysProgress,
                  style: TextStyle(
                    color: colorScheme
                        .onSurfaceVariant,
                    fontSize: 14,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  '$percentage%',
                  style: TextStyle(
                    color:
                        colorScheme.onSurface,
                    fontSize: 32,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  localizations.tasksCompleted(
                    safeCompletedTasks,
                    safeTotalTasks,
                  ),
                  style: TextStyle(
                    color: colorScheme
                        .onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          SizedBox(
            height: 70,
            width: 70,
            child:
                CircularProgressIndicator(
              value: safeProgress,
              strokeWidth: 8,
              backgroundColor:
                  colorScheme.primary
                      .withValues(
                alpha: 0.15,
              ),
              valueColor:
                  AlwaysStoppedAnimation<
                      Color>(
                colorScheme.primary,
              ),
              strokeCap:
                  StrokeCap.round,
              semanticsLabel:
                  localizations
                      .todaysProgress,
              semanticsValue:
                  '$percentage%',
            ),
          ),
        ],
      ),
    );
  }
}