import 'package:flutter/material.dart';

import '../../theme/app_constants.dart';
import 'category_donut_chart.dart';
import 'category_legend.dart';

class CategoryChartCard extends StatelessWidget {
  final Map<String, double> categoryData;

  const CategoryChartCard({
    super.key,
    required this.categoryData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 145,
      padding: const EdgeInsets.all(14),
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
            'By Category',
            style: theme.textTheme.titleSmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Row(
              children: [
                CategoryDonutChart(
                  categoryData: categoryData,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CategoryLegend(
                    categoryData: categoryData,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}