import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import 'statistic_small_card.dart';

class StatisticsOverview extends StatelessWidget {
  final int totalTasks;
  final int completedTasks;
  final double completionPercentage;

  const StatisticsOverview({
    super.key,
    required this.totalTasks,
    required this.completedTasks,
    required this.completionPercentage,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    final String percentage =
        '${completionPercentage.toStringAsFixed(0)}%';

    return LayoutBuilder(
      builder: (
        BuildContext context,
        BoxConstraints constraints,
      ) {
        if (constraints.maxWidth < 360) {
          return Column(
            children: [
              StatisticSmallCard(
                value: completedTasks.toString(),
                label: localizations.tasksDone,
              ),
              const SizedBox(
                height: 10,
              ),
              StatisticSmallCard(
                value: totalTasks.toString(),
                label: localizations.totalTasks,
              ),
              const SizedBox(
                height: 10,
              ),
              StatisticSmallCard(
                value: percentage,
                label: localizations.completed,
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: StatisticSmallCard(
                value: completedTasks.toString(),
                label: localizations.tasksDone,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: StatisticSmallCard(
                value: totalTasks.toString(),
                label: localizations.totalTasks,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: StatisticSmallCard(
                value: percentage,
                label: localizations.completed,
              ),
            ),
          ],
        );
      },
    );
  }
}