import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

class SleepModeSwitchCard
    extends StatelessWidget {
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const SleepModeSwitchCard({
    super.key,
    required this.enabled,
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

    return SwitchListTile(
      value: enabled,
      onChanged: onChanged,
      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(18),
      ),
      tileColor: theme.cardColor,
      secondary: Icon(
        Icons.nightlight_rounded,
        color: colorScheme.primary,
      ),
      title: Text(
        localizations.enableSleepMode,
        maxLines: 1,
        overflow:
            TextOverflow.ellipsis,
        style: theme.textTheme.bodyLarge
            ?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        enabled
            ? localizations.sleepModeActive
            : localizations.sleepModeOff,
        maxLines: 2,
        overflow:
            TextOverflow.ellipsis,
        style: theme.textTheme.bodyMedium
            ?.copyWith(
          color:
              colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}