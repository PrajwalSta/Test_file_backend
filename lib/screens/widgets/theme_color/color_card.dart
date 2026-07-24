import 'package:flutter/material.dart';

import '../../../models/theme_color_model.dart';

class ColorCard extends StatelessWidget {
  final ThemeColorModel color;
  final bool isSelected;
  final VoidCallback onTap;

  const ColorCard({
    super.key,
    required this.color,
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
      label: color.title,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius:
              BorderRadius.circular(18),
          child: AnimatedContainer(
            duration: const Duration(
              milliseconds: 250,
            ),
            curve: Curves.easeInOut,
            padding:
                const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 10,
            ),
            decoration: BoxDecoration(
              color: colorScheme
                  .surfaceContainerHighest,
              borderRadius:
                  BorderRadius.circular(18),
              border: Border.all(
                color: isSelected
                    ? color.color
                    : colorScheme
                        .outlineVariant
                        .withValues(
                          alpha: 0.45,
                        ),
                width:
                    isSelected ? 2.5 : 1,
              ),
            ),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(
                    milliseconds: 250,
                  ),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        color.gradient == null
                            ? color.color
                            : null,
                    gradient:
                        color.gradient == null
                            ? null
                            : LinearGradient(
                                begin:
                                    Alignment.topLeft,
                                end: Alignment
                                    .bottomRight,
                                colors:
                                    color.gradient!,
                              ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: color.color
                                  .withValues(
                                alpha: 0.30,
                              ),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(
                      milliseconds: 200,
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check_rounded,
                            key:
                                ValueKey<String>(
                              'selected',
                            ),
                            color: Colors.white,
                            size: 28,
                          )
                        : const SizedBox(
                            key:
                                ValueKey<String>(
                              'not-selected',
                            ),
                          ),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                Flexible(
                  child: Text(
                    color.title,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    textAlign:
                        TextAlign.center,
                    style: TextStyle(
                      color: isSelected
                          ? colorScheme
                              .onSurface
                          : colorScheme
                              .onSurfaceVariant,
                      fontSize: 14,
                      fontWeight:
                          isSelected
                              ? FontWeight.w700
                              : FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}