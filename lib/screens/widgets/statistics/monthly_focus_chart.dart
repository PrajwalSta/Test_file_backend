import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../data/statistics_data.dart';
import '../../theme/app_colors.dart';

class MonthlyFocusChart extends StatelessWidget {
  const MonthlyFocusChart({super.key});

  @override
  Widget build(BuildContext context) {
    final values = StatisticsData.monthlyFocus;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: values.length - 1,
        minY: 0,
        maxY: 8,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        lineTouchData: const LineTouchData(enabled: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 20,
              interval: 2,
              getTitlesWidget: (value, meta) {
                String? label;

                switch (value.toInt()) {
                  case 2:
                    label = 'W2';
                    break;
                  case 4:
                    label = 'W3';
                    break;
                  case 6:
                    label = 'W4';
                    break;
                }

                if (label == null) {
                  return const SizedBox.shrink();
                }

                return Text(
                  label,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            curveSmoothness: 0.35,
            barWidth: 2,
            color: AppColors.primaryLight,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary.withValues(alpha: 0.35),
                  AppColors.primary.withValues(alpha: 0.02),
                ],
              ),
            ),
            spots: List.generate(
              values.length,
              (index) => FlSpot(
                index.toDouble(),
                values[index],
              ),
            ),
          ),
        ],
      ),
    );
  }
}