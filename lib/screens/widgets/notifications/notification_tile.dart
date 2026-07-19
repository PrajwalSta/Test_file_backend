import 'package:flutter/material.dart';

import '../../../models/notification_setting.dart';
import 'custom_switch.dart';

class NotificationTile extends StatelessWidget {
  final NotificationSetting setting;
  final ValueChanged<bool>? onChanged;
  final bool showDivider;

  const NotificationTile({
    super.key,
    required this.setting,
    required this.onChanged,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 14,
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: setting.color.withValues(
                    alpha: 0.15,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  setting.icon,
                  color: setting.color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      setting.title,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      setting.subtitle,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(
                        color:
                            colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              CustomSwitch(
                value: setting.enabled,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            indent: 72,
            height: 1,
            color: theme.dividerColor.withValues(
              alpha: 0.5,
            ),
          ),
      ],
    );
  }
}