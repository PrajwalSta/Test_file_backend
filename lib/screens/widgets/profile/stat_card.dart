import 'package:flutter/material.dart';

import '../../../models/stat_model.dart';

class StatCard extends StatelessWidget {
  final StatModel stat;

  const StatCard({
    super.key,
    required this.stat,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
        Theme.of(context);

    final ColorScheme colorScheme =
        theme.colorScheme;

    return Container(
      width: double.infinity,
      height: 95,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.dividerColor.withValues(
            alpha: 0.4,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Icon(
            stat.icon,
            color: stat.color,
            size: 22,
          ),

          const SizedBox(height: 8),

          Text(
            stat.value,
            style: TextStyle(
              color: stat.color,
              fontWeight:
                  FontWeight.bold,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            stat.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colorScheme
                  .onSurfaceVariant,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}