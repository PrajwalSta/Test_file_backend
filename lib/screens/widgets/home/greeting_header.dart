import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class GreetingHeader extends StatelessWidget {
  final String profileName;
  final int unreadNotificationCount;
  final VoidCallback onNotificationTap;

  const GreetingHeader({
    super.key,
    required this.profileName,
    required this.unreadNotificationCount,
    required this.onNotificationTap,
  });

  String _getGreeting(
    AppLocalizations localizations,
  ) {
    final int hour = DateTime.now().hour;

    if (hour < 12) {
      return localizations.goodMorning;
    }

    if (hour < 17) {
      return localizations.goodAfternoon;
    }

    return localizations.goodEvening;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final ColorScheme colorScheme =
        theme.colorScheme;

    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    final String displayName =
        profileName.trim().isEmpty
            ? localizations.user
            : profileName.trim();

    final int safeUnreadCount =
        unreadNotificationCount < 0
            ? 0
            : unreadNotificationCount;

    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      crossAxisAlignment:
          CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                _getGreeting(
                  localizations,
                ),
                style: TextStyle(
                  color: colorScheme
                      .onSurfaceVariant,
                  fontSize: 15,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                '$displayName ✨',
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,
                style: TextStyle(
                  color:
                      colorScheme.onSurface,
                  fontSize: 30,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Semantics(
          button: true,
          label: safeUnreadCount > 0
              ? localizations
                  .notificationsUnread(
                  safeUnreadCount,
                )
              : localizations
                  .notifications,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Material(
                color: theme.cardColor,
                shape:
                    const CircleBorder(),
                clipBehavior:
                    Clip.antiAlias,
                child: InkWell(
                  onTap:
                      onNotificationTap,
                  customBorder:
                      const CircleBorder(),
                  child: Padding(
                    padding:
                        const EdgeInsets.all(
                      12,
                    ),
                    child: Icon(
                      safeUnreadCount > 0
                          ? Icons
                              .notifications_rounded
                          : Icons
                              .notifications_none_rounded,
                      color:
                          colorScheme.onSurface,
                      size: 25,
                    ),
                  ),
                ),
              ),
              if (safeUnreadCount > 0)
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    constraints:
                        const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    decoration:
                        BoxDecoration(
                      color:
                          colorScheme.error,
                      shape:
                          BoxShape.circle,
                      border: Border.all(
                        color: theme
                            .scaffoldBackgroundColor,
                        width: 2,
                      ),
                    ),
                    alignment:
                        Alignment.center,
                    child: Text(
                      safeUnreadCount > 99
                          ? '99+'
                          : safeUnreadCount
                              .toString(),
                      style:
                          TextStyle(
                        color: colorScheme
                            .onError,
                        fontSize: 10,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}