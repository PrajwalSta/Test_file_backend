import 'package:flutter/material.dart';

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
    final String percentage =
        "${completionPercentage.toStringAsFixed(0)}%";

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 360) {
          return Column(
            children: [
              StatisticSmallCard(
                value: completedTasks.toString(),
                label: 'Tasks Done',
              ),
              const SizedBox(height: 10),
              StatisticSmallCard(
                value: totalTasks.toString(),
                label: 'Total Tasks',
              ),
              const SizedBox(height: 10),
              StatisticSmallCard(
                value: percentage,
                label: 'Completed',
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: StatisticSmallCard(
                value: completedTasks.toString(),
                label: 'Tasks Done',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: StatisticSmallCard(
                value: totalTasks.toString(),
                label: 'Total Tasks',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: StatisticSmallCard(
                value: percentage,
                label: 'Completed',
              ),
            ),
          ],
        );
      },
    );
  }
}