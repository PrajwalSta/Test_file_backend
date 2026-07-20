import 'package:flutter/material.dart';

import '../../../models/world_clock.dart';
import '../../../services/timezone_service.dart';

class WorldClockCard extends StatelessWidget {
  final WorldClock clock;

  const WorldClockCard({
    super.key,
    required this.clock,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: clock.isSelected
            ? (isDark
                ? const Color(0xFF241653)
                : const Color(0xFFEDE7FF))
            : theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: clock.isSelected
              ? colorScheme.primary.withValues(alpha: 0.5)
              : theme.dividerColor.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              border: Border.all(
                color: colorScheme.primary,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.access_time,
              color: colorScheme.primary,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${clock.flag} ${clock.city}",
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  clock.country,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                TimezoneService.formattedTime(
                  clock.timezoneName,
                ),
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                TimezoneService.period(
                  clock.timezoneName,
                ),
                style: TextStyle(
                  color: Colors.amber.shade600,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}