import 'package:flutter/material.dart';

import '../../theme/app_constants.dart';
import 'monthly_focus_chart.dart';

class MonthlyFocusCard extends StatelessWidget {
  final Map<String, double> monthlyData;

  const MonthlyFocusCard({
    super.key,
    required this.monthlyData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 145,
      padding: const EdgeInsets.fromLTRB(
        14,
        14,
        14,
        8,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Monthly Focus',
            style: theme.textTheme.titleSmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 9),
          Expanded(
            child: MonthlyFocusChart(
              monthlyData: monthlyData,
            ),
          ),
        ],
      ),
    );
  }
}