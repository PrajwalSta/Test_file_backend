import 'package:flutter/material.dart';

class GreetingHeader extends StatelessWidget {
  const GreetingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Good Evening,",
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Project ✨",
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        CircleAvatar(
          backgroundColor: theme.cardColor,
          child: Icon(
            Icons.notifications_none,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}