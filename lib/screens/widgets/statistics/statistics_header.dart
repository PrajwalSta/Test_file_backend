import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class StatisticsHeader extends StatelessWidget {
  const StatisticsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
        Theme.of(context);

    final ColorScheme colorScheme =
        theme.colorScheme;

    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          localizations.statistics,
          style: theme
              .textTheme
              .headlineMedium
              ?.copyWith(
            color:
                colorScheme.onSurface,
            fontWeight:
                FontWeight.w700,
          ),
        ),

        const SizedBox(height: 3),

        Text(
          localizations
              .productivityInsights,
          style: theme
              .textTheme
              .bodyMedium
              ?.copyWith(
            color: colorScheme
                .onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}