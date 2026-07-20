import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class CategoryDonutChart extends StatelessWidget {
  final Map<String, double> categoryData;

  const CategoryDonutChart({
    super.key,
    required this.categoryData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final entries = categoryData.entries
        .where((entry) => entry.value > 0)
        .toList();

    if (entries.isEmpty) {
      return SizedBox(
        width: 85,
        height: 85,
        child: Center(
          child: Icon(
            Icons.donut_large_rounded,
            color: theme.colorScheme.onSurfaceVariant,
            size: 42,
          ),
        ),
      );
    }

    final double totalMinutes = entries.fold(
      0,
      (sum, entry) => sum + entry.value,
    );

    return SizedBox(
      width: 85,
      height: 85,
      child: PieChart(
        PieChartData(
          startDegreeOffset: -90,
          centerSpaceRadius: 25,
          sectionsSpace: 2,
          borderData: FlBorderData(
            show: false,
          ),
          sections: List.generate(
            entries.length,
            (index) {
              final entry = entries[index];

              final percentage = totalMinutes == 0
                  ? 0.0
                  : (entry.value / totalMinutes) * 100;

              return PieChartSectionData(
                value: percentage,
                color: _getCategoryColor(
                  entry.key,
                  index,
                  theme,
                ),
                radius: 13,
                showTitle: false,
                borderSide: BorderSide(
                  color: theme.scaffoldBackgroundColor,
                  width: 0.8,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(
    String category,
    int index,
    ThemeData theme,
  ) {
    switch (category.toLowerCase()) {
      case 'work':
        return AppColors.primaryLight;

      case 'study':
        return AppColors.cyan;

      case 'health':
        return Colors.green;

      case 'personal':
        return Colors.orange;

      case 'exercise':
        return Colors.redAccent;

      default:
        final colors = [
          theme.colorScheme.primary,
          theme.colorScheme.secondary,
          theme.colorScheme.tertiary,
          Colors.pinkAccent,
          Colors.amber,
          Colors.teal,
        ];

        return colors[index % colors.length];
    }
  }
}