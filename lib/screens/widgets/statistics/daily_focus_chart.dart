import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_constants.dart';

class DailyFocusChart extends StatelessWidget {
  final Map<String, double> dailyData;

  const DailyFocusChart({
    super.key,
    required this.dailyData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final entries = dailyData.entries.toList();

    final double highestHours = entries.isEmpty
        ? 0
        : entries
            .map((entry) => entry.value / 60)
            .reduce((a, b) => a > b ? a : b);

    final double maxY = highestHours <= 1
        ? 1
        : highestHours.ceilToDouble() + 1;

    final int highlightedIndex =
        _findHighestDayIndex(entries);

    return Container(
      height: 185,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        16,
        15,
        16,
        12,
      ),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(
          AppConstants.cardRadius,
        ),
        border: Border.all(
          color: theme.dividerColor.withValues(
            alpha: 0.5,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            'Daily Focus Hours',
            style: theme.textTheme.titleSmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: entries.isEmpty
                ? Center(
                    child: Text(
                      'No focus data yet',
                      style: theme
                          .textTheme.bodySmall
                          ?.copyWith(
                        color: colorScheme
                            .onSurfaceVariant,
                      ),
                    ),
                  )
                : BarChart(
                    BarChartData(
                      minY: 0,
                      maxY: maxY,
                      alignment:
                          BarChartAlignment.spaceAround,
                      gridData:
                          const FlGridData(
                        show: false,
                      ),
                      borderData:
                          FlBorderData(
                        show: false,
                      ),
                      barTouchData:
                          BarTouchData(
                        enabled: true,
                        touchTooltipData:
                            BarTouchTooltipData(
                          getTooltipColor: (_) =>
                              colorScheme
                                  .inverseSurface,
                          getTooltipItem: (
                            group,
                            groupIndex,
                            rod,
                            rodIndex,
                          ) {
                            return BarTooltipItem(
                              '${rod.toY.toStringAsFixed(1)}h',
                              TextStyle(
                                color: colorScheme
                                    .onInverseSurface,
                                fontSize: 10,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            );
                          },
                        ),
                      ),
                      titlesData:
                          FlTitlesData(
                        topTitles:
                            const AxisTitles(
                          sideTitles:
                              SideTitles(
                            showTitles: false,
                          ),
                        ),
                        leftTitles:
                            const AxisTitles(
                          sideTitles:
                              SideTitles(
                            showTitles: false,
                          ),
                        ),
                        rightTitles:
                            const AxisTitles(
                          sideTitles:
                              SideTitles(
                            showTitles: false,
                          ),
                        ),
                        bottomTitles:
                            AxisTitles(
                          sideTitles:
                              SideTitles(
                            showTitles: true,
                            reservedSize: 24,
                            getTitlesWidget:
                                (value, meta) {
                              final index =
                                  value.toInt();

                              if (index < 0 ||
                                  index >=
                                      entries.length) {
                                return const SizedBox
                                    .shrink();
                              }

                              return Padding(
                                padding:
                                    const EdgeInsets
                                        .only(
                                  top: 7,
                                ),
                                child: Text(
                                  entries[index].key,
                                  style: TextStyle(
                                    color: colorScheme
                                        .onSurfaceVariant,
                                    fontSize: 10,
                                    fontWeight:
                                        FontWeight.w500,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      barGroups:
                          List.generate(
                        entries.length,
                        (index) {
                          final item =
                              entries[index];

                          final double hours =
                              item.value / 60;

                          final bool
                              isHighlighted =
                              index ==
                                  highlightedIndex;

                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: hours,
                                width: 19,
                                borderRadius:
                                    const BorderRadius
                                        .vertical(
                                  top:
                                      Radius.circular(
                                    6,
                                  ),
                                ),
                                gradient:
                                    isHighlighted
                                        ? const LinearGradient(
                                            begin: Alignment
                                                .bottomCenter,
                                            end: Alignment
                                                .topCenter,
                                            colors: [
                                              AppColors
                                                  .cyan,
                                              AppColors
                                                  .primaryLight,
                                            ],
                                          )
                                        : LinearGradient(
                                            begin: Alignment
                                                .bottomCenter,
                                            end: Alignment
                                                .topCenter,
                                            colors: isDark
                                                ? const [
                                                    Color(
                                                      0xFF32246E,
                                                    ),
                                                    Color(
                                                      0xFF43358A,
                                                    ),
                                                  ]
                                                : const [
                                                    Color(
                                                      0xFFD8D0F8,
                                                    ),
                                                    Color(
                                                      0xFFB9A7F2,
                                                    ),
                                                  ],
                                          ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  int _findHighestDayIndex(
    List<MapEntry<String, double>> entries,
  ) {
    if (entries.isEmpty) {
      return -1;
    }

    int highestIndex = 0;
    double highestValue = entries.first.value;

    for (int index = 1;
        index < entries.length;
        index++) {
      if (entries[index].value >
          highestValue) {
        highestValue = entries[index].value;
        highestIndex = index;
      }
    }

    return highestIndex;
  }
}