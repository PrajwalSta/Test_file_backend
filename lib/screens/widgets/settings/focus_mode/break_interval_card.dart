import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
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

  static const List<int> _intervals = <int>[
    15,
    25,
    45,
    60,
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
        Theme.of(context);

    final ColorScheme colorScheme =
        theme.colorScheme;

    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

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
          Text(
            localizations.breakInterval,
            style: theme
                .textTheme.titleMedium
                ?.copyWith(
              color:
                  colorScheme.onSurface,
              fontWeight:
                  FontWeight.w600,
            ),
          ),

          const SizedBox(
            height: AppConstants.lg,
          ),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _intervals.map(
              (int minute) {
                return SizedBox(
                  width: 90,
                  child:
                      BreakIntervalChip(
                    label:
                        '$minute${localizations.minutesAbbreviation}',
                    isSelected:
                        selectedValue ==
                            minute,
                    onTap: () =>
                        onSelected(
                      minute,
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }
}