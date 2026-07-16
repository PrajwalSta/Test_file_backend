import 'package:flutter/material.dart';

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
      title: const Text(
        'Enable Sleep Mode',
        style: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        enabled
            ? 'Sleep Mode is active'
            : 'Sleep Mode is turned off',
      ),
    );
  }
}