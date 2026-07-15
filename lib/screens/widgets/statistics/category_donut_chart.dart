import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../data/statistics_data.dart';

class CategoryDonutChart extends StatelessWidget {
  const CategoryDonutChart({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = StatisticsData.categories;
    final theme = Theme.of(context);

    return SizedBox(
      width: 85,
      height: 85,
      child: PieChart(
        PieChartData(
          startDegreeOffset: -90,
          centerSpaceRadius: 25,
          sectionsSpace: 2,
          borderData: FlBorderData(show: false),
          sections: categories.map((category) {
            return PieChartSectionData(
              value: category.percentage,
              color: category.color,
              radius: 13,
              showTitle: false,
              borderSide: BorderSide(
                color: theme.scaffoldBackgroundColor,
                width: 0.8,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}