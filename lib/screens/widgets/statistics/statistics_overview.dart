import 'package:flutter/material.dart';

import 'statistic_small_card.dart';

class StatisticsOverview extends StatelessWidget {
  const StatisticsOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 360) {
          return const Column(
            children: [
              StatisticSmallCard(
                value: '55',
                label: 'Tasks Done',
              ),
              SizedBox(height: 10),
              StatisticSmallCard(
                value: '7.9h',
                label: 'Avg Daily',
              ),
              SizedBox(height: 10),
              StatisticSmallCard(
                value: 'Thu',
                label: 'Best Day',
              ),
            ],
          );
        }

        return const Row(
          children: [
            Expanded(
              child: StatisticSmallCard(
                value: '55',
                label: 'Tasks Done',
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: StatisticSmallCard(
                value: '7.9h',
                label: 'Avg Daily',
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: StatisticSmallCard(
                value: 'Thu',
                label: 'Best Day',
              ),
            ),
          ],
        );
      },
    );
  }
}