import 'package:flutter/material.dart';

import '../../main_screen.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          _circleButton(
            context,
            Icons.arrow_back_ios_new,
            onTap: () {
              final navigator = Navigator.of(context);

              navigator.maybePop().then((didPop) {
                if (!didPop && context.mounted) {
                  navigator.pushReplacement(
                    MaterialPageRoute(
                      builder: (_) =>
                          const MainScreen(initialIndex: 3),
                    ),
                  );
                }
              });
            },
          ),

          Expanded(
            child: Center(
              child: Text(
                "Profile",
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          _circleButton(
            context,
            Icons.edit,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _circleButton(
    BuildContext context,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(21),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: theme.cardColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: theme.dividerColor.withValues(alpha: 0.4),
          ),
        ),
        child: Icon(
          icon,
          color: colorScheme.onSurface,
          size: 20,
        ),
      ),
    );
  }
}