import 'package:flutter/material.dart';

import '../../../theme/app_constants.dart';
import 'custom_switch.dart';
import 'time_picker_box.dart';

class DndCard extends StatelessWidget {
  final bool enabled;
  final ValueChanged<bool> onChanged;

  final TimeOfDay startTime;
  final TimeOfDay endTime;

  final ValueChanged<TimeOfDay> onStartTimeChanged;
  final ValueChanged<TimeOfDay> onEndTimeChanged;

  const DndCard({
    super.key,
    required this.enabled,
    required this.onChanged,
    required this.startTime,
    required this.endTime,
    required this.onStartTimeChanged,
    required this.onEndTimeChanged,
  });

  Future<void> _selectStartTime(
    BuildContext context,
  ) async {
    final TimeOfDay? selectedTime =
        await showTimePicker(
      context: context,
      initialTime: startTime,
    );

    if (selectedTime == null) {
      return;
    }

    onStartTimeChanged(selectedTime);
  }

  Future<void> _selectEndTime(
    BuildContext context,
  ) async {
    final TimeOfDay? selectedTime =
        await showTimePicker(
      context: context,
      initialTime: endTime,
    );

    if (selectedTime == null) {
      return;
    }

    onEndTimeChanged(selectedTime);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
        Theme.of(context);

    final ColorScheme colorScheme =
        theme.colorScheme;

    final String formattedStartTime =
        startTime.format(context);

    final String formattedEndTime =
        endTime.format(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(
        AppConstants.lg,
      ),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color: theme.dividerColor.withValues(
            alpha: 0.4,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Do Not Disturb',
                  style: theme
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                    color:
                        colorScheme.onSurface,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ),
              CustomSwitch(
                value: enabled,
                onChanged: onChanged,
              ),
            ],
          ),

          const SizedBox(
            height: AppConstants.lg,
          ),

          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: enabled
                      ? () =>
                          _selectStartTime(
                            context,
                          )
                      : null,
                  behavior:
                      HitTestBehavior.opaque,
                  child: IgnorePointer(
                    child: Opacity(
                      opacity:
                          enabled ? 1 : 0.5,
                      child: TimePickerBox(
                        title: 'Start',
                        time:
                            formattedStartTime,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                width: AppConstants.md,
              ),

              Expanded(
                child: GestureDetector(
                  onTap: enabled
                      ? () =>
                          _selectEndTime(
                            context,
                          )
                      : null,
                  behavior:
                      HitTestBehavior.opaque,
                  child: IgnorePointer(
                    child: Opacity(
                      opacity:
                          enabled ? 1 : 0.5,
                      child: TimePickerBox(
                        title: 'End',
                        time:
                            formattedEndTime,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}