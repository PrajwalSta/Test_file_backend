import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../main_screen.dart';

class SecurityHeader extends StatelessWidget {
  const SecurityHeader({
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
        Material(
          color: theme.cardColor,
          shape: const CircleBorder(),
          child: Ink(
            decoration: ShapeDecoration(
              color: theme.cardColor,
              shape: const CircleBorder(),
            ),
            child: IconButton(
              onPressed: () {
                final NavigatorState navigator =
                    Navigator.of(context);

                navigator
                    .maybePop()
                    .then(
                  (
                    bool didPop,
                  ) {
                    if (!didPop &&
                        context.mounted) {
                      navigator.pushReplacement(
                        MaterialPageRoute<void>(
                          builder: (
                            BuildContext context,
                          ) {
                            return const MainScreen(
                              initialIndex: 4,
                            );
                          },
                        ),
                      );
                    }
                  },
                );
              },
              icon: Icon(
                Icons.arrow_back,
                color:
                    colorScheme.onSurface,
                size: 20,
              ),
              tooltip:
                  localizations.back,
              splashRadius: 24,
              padding:
                  EdgeInsets.zero,
            ),
          ),
        ),

        const SizedBox(
          width: 12,
        ),

        Expanded(
          child: Text(
            localizations
                .privacyAndSecurity,
            maxLines: 1,
            overflow:
                TextOverflow.ellipsis,
            style: TextStyle(
              color:
                  colorScheme.onSurface,
              fontSize: 22,
              fontWeight:
                  FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}