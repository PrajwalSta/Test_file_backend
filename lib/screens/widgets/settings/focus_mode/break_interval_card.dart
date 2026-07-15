import 'package:flutter/material.dart';

import '../../../theme/app_constants.dart';
import 'break_interval_chip.dart';

class BreakIntervalCard extends StatelessWidget {
  final int selectedValue;
  final ValueChanged<int> onSelected;

  const BreakIntervalCard({
    super.key,
    required this.selectedValue,
    required this.onSelected,
  });

  static const List<int> _intervals = [15, 25, 45, 60];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.lg),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Break Interval",
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: AppConstants.lg),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _intervals.map((minute) {
              return SizedBox(
                width: 90,
                child: BreakIntervalChip(
                  label: "${minute}m",
                  isSelected: selectedValue == minute,
                  onTap: () => onSelected(minute),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}