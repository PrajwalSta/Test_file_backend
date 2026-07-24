import 'package:flutter/material.dart';

class LanguageHeader extends StatelessWidget {
  final String subtitle;

  const LanguageHeader({
    super.key,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Text(
      subtitle,
      style: TextStyle(
        color: colorScheme.onSurfaceVariant,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}