import 'package:flutter/material.dart';

import '../../../theme/app_constants.dart';
import 'custom_switch.dart';
import 'time_picker_box.dart';

class DndCard extends StatelessWidget {
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const DndCard({
    super.key,
    required this.enabled,
    required this.onChanged,
  });

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
          Row(
            children: [
              Expanded(
                child: Text(
                  "Do Not Disturb",
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              CustomSwitch(
                value: enabled,
                onChanged: onChanged,
              ),
            ],
          ),

          const SizedBox(height: AppConstants.lg),

          const Row(
            children: [
              Expanded(
                child: TimePickerBox(
                  title: "Start",
                  time: "10:00 PM",
                ),
              ),
              SizedBox(width: AppConstants.md),
              Expanded(
                child: TimePickerBox(
                  title: "End",
                  time: "07:00 AM",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}