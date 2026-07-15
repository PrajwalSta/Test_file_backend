import 'package:flutter/material.dart';

//import '../../theme/app_colors.dart';
import 'setting_tile.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        children: [
          SettingsTile(
            icon: Icons.person_outline,
            title: "Profile",
            subtitle: "Name, photo, bio",
            iconColor: colorScheme.primary,
          ),

          Divider(
            color: theme.dividerColor.withValues(alpha: 0.5),
            height: 1,
            indent: 16,
            endIndent: 16,
          ),

          SettingsTile(
            icon: Icons.lock_outline,
            title: "Privacy & Security",
            subtitle: "Password, 2FA, biometrics",
            iconColor: Colors.cyan,
          ),
        ],
      ),
    );
  }
}