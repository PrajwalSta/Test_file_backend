import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class CategoryLegend extends StatelessWidget {
  final Map<String, double> categoryData;

  const CategoryLegend({
    super.key,
    required this.categoryData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final entries = categoryData.entries
        .where((entry) => entry.value > 0)
        .toList();

    if (entries.isEmpty) {
      return Center(
        child: Text(
          'No data',
          style: TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontSize: 11,
          ),
        ),
      );
    }

    final double total = entries.fold(
      0,
      (sum, entry) => sum + entry.value,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        entries.length,
        (index) {
          final entry = entries[index];

          final percentage = total == 0
              ? 0
              : ((entry.value / total) * 100).round();

          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 3,
            ),
            child: Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getCategoryColor(
                      entry.key,
                      index,
                      theme,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    entry.key,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 9,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  '$percentage%',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
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