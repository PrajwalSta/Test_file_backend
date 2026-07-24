import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../theme/app_constants.dart';
import 'custom_switch.dart';

class FocusModeCard extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const FocusModeCard({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
        Theme.of(context);

    final ColorScheme colorScheme =
        theme.colorScheme;

    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    return Semantics(
      container: true,
      toggled: value,
      label: localizations.focusMode,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(
          AppConstants.lg,
        ),
        decoration: BoxDecoration(
          color: colorScheme.primary
              .withValues(
            alpha: 0.12,
          ),
          borderRadius:
              BorderRadius.circular(20),
          border: Border.all(
            color: colorScheme.primary
                .withValues(
              alpha: 0.25,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.focusMode,
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

                  const SizedBox(
                    height: AppConstants.xs,
                  ),

                  Text(
                    localizations
                        .focusModeDescription,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style: theme
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                      color: colorScheme
                          .onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              width: AppConstants.md,
            ),

            CustomSwitch(
              value: value,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}