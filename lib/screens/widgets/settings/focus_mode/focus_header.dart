import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../theme/app_constants.dart';

class FocusHeader extends StatelessWidget {
  const FocusHeader({
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
        _buildBackButton(
          context,
          localizations,
        ),

        const SizedBox(
          width: AppConstants.md,
        ),

        Expanded(
          child: Text(
            localizations.focusAndDnd,
            maxLines: 1,
            overflow:
                TextOverflow.ellipsis,
            style: theme
                .textTheme.titleLarge
                ?.copyWith(
              color:
                  colorScheme.onSurface,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackButton(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    final ThemeData theme =
        Theme.of(context);

    final ColorScheme colorScheme =
        theme.colorScheme;

    return Semantics(
      button: true,
      label: localizations.back,
      child: InkWell(
        borderRadius:
            BorderRadius.circular(14),
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius:
                BorderRadius.circular(
              14,
            ),
            border: Border.all(
              color: theme.dividerColor
                  .withValues(
                alpha: 0.4,
              ),
            ),
          ),
          child: Icon(
            Icons
                .arrow_back_ios_new_rounded,
            size: 18,
            color:
                colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}