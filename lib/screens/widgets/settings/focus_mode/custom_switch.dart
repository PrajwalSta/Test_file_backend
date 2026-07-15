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
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 32,
      child: Transform.scale(
        scale: 0.9,
        child: Switch(
          value: value,
          onChanged: onChanged,

          activeThumbColor: colorScheme.onPrimary,
          activeTrackColor: colorScheme.primary,

          inactiveThumbColor: colorScheme.onSurfaceVariant,
          inactiveTrackColor:
              colorScheme.onSurface.withValues(alpha: 0.15),

          materialTapTargetSize:
              MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }
}