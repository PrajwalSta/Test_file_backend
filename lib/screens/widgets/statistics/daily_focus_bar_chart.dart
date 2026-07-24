import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';

class DailyFocusBarChart extends StatelessWidget {
  const DailyFocusBarChart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
        Theme.of(context);

    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    final ColorScheme colorScheme =
        theme.colorScheme;

    final List<String> days = [
      localizations.mon,
      localizations.tue,
      localizations.wed,
      localizations.thu,
      localizations.fri,
      localizations.sat,
      localizations.sun,
    ];

    return SizedBox(
      height: 220,
      child: BarChart(
        BarChartData(
          alignment:
              BarChartAlignment.spaceAround,

          borderData: FlBorderData(
            show: false,
          ),

          gridData: FlGridData(
            drawVerticalLine: false,
            horizontalInterval: 2,
            getDrawingHorizontalLine: (
              value,
            ) {
              return FlLine(
                color: colorScheme
                    .outlineVariant
                    .withValues(
                      alpha: 0.45,
                    ),
                strokeWidth: 1,
              );
            },
          ),

          titlesData: FlTitlesData(
            topTitles:
                const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),

            rightTitles:
                const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),

            leftTitles:
                AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 26,
                getTitlesWidget: (
                  value,
                  meta,
                ) {
                  return Text(
                    value
                        .toInt()
                        .toString(),
                    style: TextStyle(
                      color: colorScheme
                          .onSurfaceVariant,
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),

            bottomTitles:
                AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (
                  value,
                  meta,
                ) {
                  final int index =
                      value.toInt();

                  if (index < 0 ||
                      index >=
                          days.length) {
                    return const SizedBox
                        .shrink();
                  }

                  return Padding(
                    padding:
                        const EdgeInsets.only(
                      top: 8,
                    ),
                    child: Text(
                      days[index],
                      style: TextStyle(
                        color:
                            colorScheme
                                .onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          barGroups: [
            _bar(0, 5),
            _bar(1, 7),
            _bar(2, 6),
            _bar(3, 9),
            _bar(4, 8),
            _bar(5, 4),
            _bar(6, 6),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _bar(
    int x,
    double y,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 18,
          borderRadius:
              BorderRadius.circular(
            8,
          ),
          gradient:
              const LinearGradient(
            colors: [
              AppColors.secondary,
              AppColors.primary,
            ],
            begin:
                Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
      ],
    );
  }
}