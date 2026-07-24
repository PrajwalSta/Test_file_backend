import 'package:flutter/material.dart';

import '../../../models/badge_model.dart';

class BadgeCard extends StatelessWidget {
  final BadgeModel badge;

  const BadgeCard({
    super.key,
    required this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
        Theme.of(context);

    final ColorScheme colorScheme =
        theme.colorScheme;

    final bool isDark =
        theme.brightness == Brightness.dark;

    return Semantics(
      label: badge.title,
      selected: badge.earned,
      child: Opacity(
        opacity: badge.earned ? 1 : 0.35,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 18,
          ),
          decoration: BoxDecoration(
            color: badge.earned
                ? isDark
                    ? const Color(
                        0xFF211D45,
                      )
                    : const Color(
                        0xFFF2EEFF,
                      )
                : theme.cardColor,
            borderRadius:
                BorderRadius.circular(18),
            border: Border.all(
              color: badge.earned
                  ? colorScheme.primary.withValues(
                      alpha: 0.4,
                    )
                  : theme.dividerColor.withValues(
                      alpha: 0.4,
                    ),
            ),
          ),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Text(
                badge.emoji,
                style: const TextStyle(
                  fontSize: 28,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                badge.title,
                maxLines: 2,
                overflow:
                    TextOverflow.ellipsis,
                textAlign:
                    TextAlign.center,
                style: TextStyle(
                  color:
                      colorScheme.onSurface,
                  fontSize: 12,
                  fontWeight:
                      FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}