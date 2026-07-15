import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import 'section_title.dart';
import 'setting_tile.dart';
import 'switch_tile.dart';

class PreferencesSection extends StatelessWidget {
  const PreferencesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle("PREFERENCES"),

        Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.dividerColor.withValues(alpha: 0.4),
            ),
          ),
          child: Column(
            children: [
              const SwitchTile(
                icon: Icons.dark_mode_outlined,
                title: "Dark Mode",
                subtitle: "On",
                iconColor: AppColors.primary,
              ),

              Divider(
                color: theme.dividerColor.withValues(alpha: 0.4),
                height: 1,
                indent: 16,
                endIndent: 16,
              ),

              SettingsTile(
                icon: Icons.notifications_none,
                title: "Notifications",
                subtitle: "Push, Email",
                iconColor: Colors.amber,
              ),

              Divider(
                color: theme.dividerColor.withValues(alpha: 0.4),
                height: 1,
                indent: 16,
                endIndent: 16,
              ),

              SettingsTile(
                icon: Icons.palette_outlined,
                title: "Theme Color",
                subtitle: "Purple Gradient",
                iconColor: Colors.deepOrange,
              ),

              Divider(
                color: theme.dividerColor.withValues(alpha: 0.4),
                height: 1,
                indent: 16,
                endIndent: 16,
              ),

              SettingsTile(
                icon: Icons.language,
                title: "Language",
                subtitle: "English",
                iconColor: Colors.cyan,
              ),
            ],
          ),
        ),
      ],
    );
  }
}