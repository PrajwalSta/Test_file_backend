import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../theme/app_constants.dart';
import 'custom_switch.dart';
import 'time_picker_box.dart';

class DndCard extends StatelessWidget {
  final bool enabled;
  final ValueChanged<bool> onChanged;

  final TimeOfDay startTime;
  final TimeOfDay endTime;

  final ValueChanged<TimeOfDay>
      onStartTimeChanged;

  final ValueChanged<TimeOfDay>
      onEndTimeChanged;

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
    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    final TimeOfDay? selectedTime =
        await showTimePicker(
      context: context,
      initialTime: startTime,
      helpText:
          localizations.selectDndStartTime,
      cancelText:
          localizations.cancel,
      confirmText:
          localizations.ok,
    );

    if (selectedTime == null) {
      return;
    }

    onStartTimeChanged(
      selectedTime,
    );
  }

  Future<void> _selectEndTime(
    BuildContext context,
  ) async {
    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    final TimeOfDay? selectedTime =
        await showTimePicker(
      context: context,
      initialTime: endTime,
      helpText:
          localizations.selectDndEndTime,
      cancelText:
          localizations.cancel,
      confirmText:
          localizations.ok,
    );

    if (selectedTime == null) {
      return;
    }

    onEndTimeChanged(
      selectedTime,
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final ThemeData theme =
        Theme.of(context);

    final ColorScheme colorScheme =
        theme.colorScheme;

    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

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
          color: theme.dividerColor
              .withValues(
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
                  localizations
                      .doNotDisturb,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
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

              const SizedBox(
                width: 12,
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
                child: Semantics(
                  button: true,
                  enabled: enabled,
                  label:
                      '${localizations.start}: $formattedStartTime',
                  child: GestureDetector(
                    onTap: enabled
                        ? () {
                            _selectStartTime(
                              context,
                            );
                          }
                        : null,
                    behavior:
                        HitTestBehavior.opaque,
                    child: IgnorePointer(
                      child: AnimatedOpacity(
                        duration:
                            const Duration(
                          milliseconds: 200,
                        ),
                        opacity:
                            enabled ? 1 : 0.5,
                        child:
                            TimePickerBox(
                          title:
                              localizations.start,
                          time:
                              formattedStartTime,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                width: AppConstants.md,
              ),

              Expanded(
                child: Semantics(
                  button: true,
                  enabled: enabled,
                  label:
                      '${localizations.end}: $formattedEndTime',
                  child: GestureDetector(
                    onTap: enabled
                        ? () {
                            _selectEndTime(
                              context,
                            );
                          }
                        : null,
                    behavior:
                        HitTestBehavior.opaque,
                    child: IgnorePointer(
                      child: AnimatedOpacity(
                        duration:
                            const Duration(
                          milliseconds: 200,
                        ),
                        opacity:
                            enabled ? 1 : 0.5,
                        child:
                            TimePickerBox(
                          title:
                              localizations.end,
                          time:
                              formattedEndTime,
                        ),
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