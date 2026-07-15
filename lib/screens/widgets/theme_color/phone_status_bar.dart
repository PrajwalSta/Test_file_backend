import 'package:flutter/material.dart';

class PhoneStatusBar extends StatelessWidget {
  const PhoneStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 14, 22, 8),
      child: Row(
        children: [
          Text(
            "9:41",
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),

          const Spacer(),

          Container(
            width: 72,
            height: 18,
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: theme.dividerColor.withValues(alpha: 0.4),
              ),
            ),
          ),

          const Spacer(),

          Row(
            children: [
              Icon(
                Icons.signal_cellular_alt_rounded,
                color: colorScheme.onSurfaceVariant,
                size: 14,
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.bolt,
                color: Color(0xFFFFD166),
                size: 13,
              ),
              const SizedBox(width: 4),
              Text(
                "87%",
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
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