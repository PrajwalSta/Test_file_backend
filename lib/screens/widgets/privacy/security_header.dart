import 'package:flutter/material.dart';

import '../../main_screen.dart';

class SecurityHeader extends StatelessWidget {
  const SecurityHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Material(
          color: theme.cardColor,
          shape: const CircleBorder(),
          child: Ink(
            decoration: ShapeDecoration(
              color: theme.cardColor,
              shape: const CircleBorder(),
            ),
            child: IconButton(
              onPressed: () {
                final navigator = Navigator.of(context);

                navigator.maybePop().then((didPop) {
                  if (!didPop && context.mounted) {
                    navigator.pushReplacement(
                      MaterialPageRoute(
                        builder: (_) =>
                            const MainScreen(initialIndex: 4),
                      ),
                    );
                  }
                });
              },
              icon: Icon(
                Icons.arrow_back,
                color: colorScheme.onSurface,
                size: 20,
              ),
              splashRadius: 24,
              padding: EdgeInsets.zero,
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Text(
            "Privacy & Security",
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}