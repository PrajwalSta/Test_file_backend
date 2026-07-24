import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({
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

    return Semantics(
      container: true,
      toggled: value,
      child: SizedBox(
        height: 32,
        child: Transform.scale(
          scale: 0.9,
          child: Switch(
            value: value,
            onChanged: onChanged,

            activeThumbColor:
                colorScheme.onPrimary,
            activeTrackColor:
                colorScheme.primary,

            inactiveThumbColor:
                colorScheme.onSurfaceVariant,
            inactiveTrackColor:
                colorScheme.onSurface
                    .withValues(
                  alpha: 0.15,
                ),

            materialTapTargetSize:
                MaterialTapTargetSize
                    .shrinkWrap,
          ),
        ),
      ),
    );
  }
}