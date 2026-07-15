import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import 'section_title.dart';
import 'setting_tile.dart';
import 'switch_tile.dart';

class FocusModeSection extends StatelessWidget {
  const FocusModeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle("FOCUS MODES"),

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
              SettingsTile(
                icon: Icons.phone_android,
                title: "Focus Mode",
                subtitle: "Blocked apps",
                iconColor: AppColors.primary,
              ),

              Divider(
                color: theme.dividerColor.withValues(alpha: 0.4),
                height: 1,
                indent: 16,
                endIndent: 16,
              ),

              const SwitchTile(
                icon: Icons.shield_outlined,
                title: "Do Not Disturb",
                subtitle: "10 PM - 7 AM",
                iconColor: Colors.red,
              ),
            ],
          ),
        ),
      ],
    );
  }
}