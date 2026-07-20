import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final VoidCallback onEditPressed;

  const ProfileHeader({
    super.key,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
        Theme.of(context);

    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
        Expanded(
          child: Text(
            'Profile',
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          onPressed: onEditPressed,
          icon: const Icon(
            Icons.edit,
          ),
        ),
      ],
    );
  }
}