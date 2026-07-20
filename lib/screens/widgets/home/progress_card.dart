import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class ProgressCard extends StatelessWidget {
  // Progress value must be between 0.0 and 1.0.
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

    // Make sure progress stays between 0 and 1.
    final double safeProgress =
        progress.clamp(0.0, 1.0);

    // Convert progress into percentage.
    final int percentage =
        (safeProgress * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color: theme.dividerColor
              .withValues(alpha: 0.45),
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
                  localizations.todaysProgress,
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
                    completedTasks,
                    totalTasks,
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
            child: CircularProgressIndicator(
              value: safeProgress,
              strokeWidth: 8,
              backgroundColor:
                  colorScheme.primary.withValues(
                alpha: 0.15,
              ),
              valueColor:
                  AlwaysStoppedAnimation<Color>(
                colorScheme.primary,
              ),
              strokeCap: StrokeCap.round,
            ),
          ),
        ],
      ),
    );
  }
}