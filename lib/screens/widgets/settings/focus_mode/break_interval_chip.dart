import 'package:flutter/material.dart';

class BreakIntervalChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const BreakIntervalChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
        Theme.of(context);

    final ColorScheme colorScheme =
        theme.colorScheme;

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius:
              BorderRadius.circular(18),
          child: AnimatedContainer(
            duration: const Duration(
              milliseconds: 220,
            ),
            curve: Curves.easeInOut,
            width: double.infinity,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primary
                  : theme.cardColor,
              borderRadius:
                  BorderRadius.circular(18),
              border: Border.all(
                color: isSelected
                    ? colorScheme.primary
                    : theme.dividerColor
                        .withValues(
                      alpha: 0.5,
                    ),
              ),
            ),
            child: AnimatedDefaultTextStyle(
              duration: const Duration(
                milliseconds: 220,
              ),
              curve: Curves.easeInOut,
              textAlign: TextAlign.center,
              style: theme
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                    color: isSelected
                        ? colorScheme.onPrimary
                        : colorScheme
                            .onSurfaceVariant,
                    fontWeight:
                        FontWeight.w700,
                  ) ??
                  TextStyle(
                    color: isSelected
                        ? colorScheme.onPrimary
                        : colorScheme
                            .onSurfaceVariant,
                    fontWeight:
                        FontWeight.w700,
                  ),
              child: Text(
                label,
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }
}