import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class MonthlyFocusChart extends StatelessWidget {
  final Map<String, double> monthlyData;

  const MonthlyFocusChart({
    super.key,
    required this.monthlyData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final entries = monthlyData.entries.toList();

    if (entries.isEmpty) {
      return const Center(
        child: Text("No data"),
      );
    }

    final values = entries
        .map((e) => e.value / 60)
        .toList();

    final maxY = values.reduce(
              (a, b) => a > b ? a : b,
            ) +
        1;

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: (values.length - 1).toDouble(),
        minY: 0,
        maxY: maxY,
        gridData: const FlGridData(
          show: false,
        ),
        borderData: FlBorderData(
          show: false,
        ),
        lineTouchData: const LineTouchData(
          enabled: false,
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles:
                SideTitles(showTitles: false),
          ),
          leftTitles: const AxisTitles(
            sideTitles:
                SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles:
                SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 20,
              getTitlesWidget:
                  (value, meta) {
                final index = value.toInt();

                if (index >= entries.length) {
                  return const SizedBox();
                }

                return Text(
                  entries[index].key,
                  style: TextStyle(
                    color: colorScheme
                        .onSurfaceVariant,
                    fontSize: 10,
                    fontWeight:
                        FontWeight.w500,
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
            dotData: const FlDotData(
              show: false,
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin:
                    Alignment.topCenter,
                end:
                    Alignment.bottomCenter,
                colors: [
                  AppColors.primary
                      .withValues(
                    alpha: 0.35,
                  ),
                  AppColors.primary
                      .withValues(
                    alpha: 0.02,
                  ),
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