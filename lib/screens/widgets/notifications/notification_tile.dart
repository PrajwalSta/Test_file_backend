import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
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

  String _localizedTitle(
    AppLocalizations localizations,
  ) {
    switch (setting.title) {
      case 'Push Notifications':
        return localizations.pushNotifications;

      case 'Email Notifications':
        return localizations.emailNotifications;

      case 'Schedule Reminders':
        return localizations.scheduleReminders;

      case 'Break Alerts':
        return localizations.breakAlerts;

      case 'Achievements':
        return localizations.achievements;

      case 'Weekly Report':
        return localizations.weeklyReport;

      case 'Notification Sounds':
        return localizations.notificationSounds;

      case 'App Badges':
        return localizations.appBadges;

      default:
        return setting.title;
    }
  }

  String _localizedSubtitle(
    AppLocalizations localizations,
  ) {
    switch (setting.subtitle) {
      case 'Real-time alerts on your device':
        return localizations
            .realTimeAlertsOnYourDevice;

      case 'Digest to your inbox':
        return localizations.digestToYourInbox;

      case 'Before events start':
        return localizations.beforeEventsStart;

      case 'Remind to take breaks':
        return localizations.remindToTakeBreaks;

      case 'Badges & milestones':
        return localizations.badgesAndMilestones;

      case 'Sunday summary email':
        return localizations.sundaySummaryEmail;

      case 'Audio for alerts':
        return localizations.audioForAlerts;

      case 'Unread count on icon':
        return localizations.unreadCountOnIcon;

      default:
        return setting.subtitle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
        Theme.of(context);

    final ColorScheme colorScheme =
        theme.colorScheme;

    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 14,
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: setting.color
                      .withValues(
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

              const SizedBox(
                width: 15,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      _localizedTitle(
                        localizations,
                      ),
                      style: theme
                          .textTheme.titleSmall
                          ?.copyWith(
                        color:
                            colorScheme.onSurface,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),

                    const SizedBox(
                      height: 3,
                    ),

                    Text(
                      _localizedSubtitle(
                        localizations,
                      ),
                      style: theme
                          .textTheme.bodySmall
                          ?.copyWith(
                        color: colorScheme
                            .onSurfaceVariant,
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
            color: theme.dividerColor
                .withValues(
              alpha: 0.5,
            ),
          ),
      ],
    );
  }
}