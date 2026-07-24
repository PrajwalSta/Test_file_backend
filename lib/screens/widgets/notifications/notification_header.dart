import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class NotificationHeader extends StatelessWidget {
  const NotificationHeader({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final ThemeData theme =
        Theme.of(context);

    final ColorScheme colorScheme =
        theme.colorScheme;

    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    return Row(
      children: [
        Semantics(
          button: true,
          label: localizations.back,
          child: InkWell(
            borderRadius:
                BorderRadius.circular(100),
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: theme.cardColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.dividerColor
                      .withValues(
                    alpha: 0.4,
                  ),
                ),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color:
                    colorScheme.onSurface,
              ),
            ),
          ),
        ),

        const SizedBox(
          width: 14,
        ),

        Expanded(
          child: Text(
            localizations.notifications,
            overflow:
                TextOverflow.ellipsis,
            style: theme
                .textTheme.headlineSmall
                ?.copyWith(
              color:
                  colorScheme.onSurface,
              fontSize: 24,
              fontWeight:
                  FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}