import 'package:flutter/material.dart';

class PhoneStatusBar extends StatelessWidget {
  final String timeText;
  final int batteryPercentage;
  final bool isCharging;

  const PhoneStatusBar({
    super.key,
    this.timeText = '9:41',
    this.batteryPercentage = 87,
    this.isCharging = true,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
        Theme.of(context);

    final ColorScheme colorScheme =
        theme.colorScheme;

    final int safeBatteryPercentage =
        batteryPercentage.clamp(
      0,
      100,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        22,
        14,
        22,
        8,
      ),
      child: Row(
        children: [
          Text(
            timeText,
            style: TextStyle(
              color: colorScheme
                  .onSurfaceVariant,
              fontSize: 12,
              fontWeight:
                  FontWeight.w600,
            ),
          ),

          const Spacer(),

          Container(
            width: 72,
            height: 18,
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius:
                  BorderRadius.circular(
                20,
              ),
              border: Border.all(
                color: theme.dividerColor
                    .withValues(
                  alpha: 0.4,
                ),
              ),
            ),
          ),

          const Spacer(),

          Row(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              Icon(
                Icons
                    .signal_cellular_alt_rounded,
                color: colorScheme
                    .onSurfaceVariant,
                size: 14,
              ),

              if (isCharging) ...[
                const SizedBox(
                  width: 4,
                ),
                const Icon(
                  Icons.bolt,
                  color: Color(
                    0xFFFFD166,
                  ),
                  size: 13,
                ),
              ],

              const SizedBox(
                width: 4,
              ),

              Text(
                '$safeBatteryPercentage%',
                style: TextStyle(
                  color: colorScheme
                      .onSurfaceVariant,
                  fontSize: 11,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}