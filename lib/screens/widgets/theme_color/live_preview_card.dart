import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/theme_color_model.dart';

class LivePreviewCard extends StatelessWidget {
  final ThemeColorModel selectedTheme;

  const LivePreviewCard({
    super.key,
    required this.selectedTheme,
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

    final Color primaryColor =
        selectedTheme.color;

    final Color secondaryColor =
        selectedTheme.gradient != null &&
                selectedTheme.gradient!.length > 1
            ? selectedTheme.gradient!.last
            : primaryColor.withValues(
                alpha: 0.85,
              );

    return Padding(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(
          18,
        ),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius:
              BorderRadius.circular(
            18,
          ),
          border: Border.all(
            color:
                primaryColor.withValues(
              alpha: 0.25,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color:
                  primaryColor.withValues(
                alpha: 0.08,
              ),
              blurRadius: 14,
              offset: const Offset(
                0,
                5,
              ),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.visibility_outlined,
                  color: primaryColor,
                  size: 20,
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(
                    localizations.livePreview,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: theme
                        .textTheme.titleMedium
                        ?.copyWith(
                      color: colorScheme
                          .onSurface,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 18,
            ),

            Row(
              children: [
                Expanded(
                  child:
                      _PrimaryPreviewButton(
                    selectedTheme:
                        selectedTheme,
                    foregroundColor:
                        colorScheme.onPrimary,
                    buttonText:
                        localizations.primary,
                    snackBarText:
                        localizations
                            .primaryButtonPreview,
                  ),
                ),

                const SizedBox(
                  width: 14,
                ),

                Expanded(
                  child:
                      _SecondaryPreviewButton(
                    primaryColor:
                        primaryColor,
                    secondaryColor:
                        secondaryColor,
                    buttonText:
                        localizations.secondary,
                    snackBarText:
                        localizations
                            .secondaryButtonPreview,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 16,
            ),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(
                14,
              ),
              decoration: BoxDecoration(
                color:
                    primaryColor.withValues(
                  alpha: 0.08,
                ),
                borderRadius:
                    BorderRadius.circular(
                  14,
                ),
              ),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.palette_outlined,
                    color: primaryColor,
                    size: 19,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      localizations
                          .accentColorPreviewDescription,
                      style: theme
                          .textTheme.bodySmall
                          ?.copyWith(
                        color: colorScheme
                            .onSurfaceVariant,
                        fontSize: 12,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrimaryPreviewButton
    extends StatefulWidget {
  final ThemeColorModel selectedTheme;
  final Color foregroundColor;
  final String buttonText;
  final String snackBarText;

  const _PrimaryPreviewButton({
    required this.selectedTheme,
    required this.foregroundColor,
    required this.buttonText,
    required this.snackBarText,
  });

  @override
  State<_PrimaryPreviewButton>
      createState() =>
          _PrimaryPreviewButtonState();
}

class _PrimaryPreviewButtonState
    extends State<_PrimaryPreviewButton> {
  bool _isPressed = false;

  void _showPreviewMessage() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            widget.snackBarText,
          ),
          behavior:
              SnackBarBehavior.floating,
          duration: const Duration(
            seconds: 1,
          ),
        ),
      );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Semantics(
      button: true,
      label: widget.buttonText,
      child: AnimatedScale(
        scale:
            _isPressed ? 0.96 : 1,
        duration: const Duration(
          milliseconds: 120,
        ),
        child: GestureDetector(
          onTapDown: (_) {
            setState(() {
              _isPressed = true;
            });
          },
          onTapUp: (_) {
            setState(() {
              _isPressed = false;
            });

            _showPreviewMessage();
          },
          onTapCancel: () {
            setState(() {
              _isPressed = false;
            });
          },
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(
                14,
              ),
              gradient:
                  widget.selectedTheme
                              .gradient !=
                          null
                      ? LinearGradient(
                          colors: widget
                              .selectedTheme
                              .gradient!,
                        )
                      : null,
              color:
                  widget.selectedTheme
                              .gradient ==
                          null
                      ? widget
                          .selectedTheme
                          .color
                      : null,
            ),
            alignment:
                Alignment.center,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              child: Text(
                widget.buttonText,
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,
                textAlign:
                    TextAlign.center,
                style: TextStyle(
                  color:
                      widget.foregroundColor,
                  fontSize: 14,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SecondaryPreviewButton
    extends StatefulWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final String buttonText;
  final String snackBarText;

  const _SecondaryPreviewButton({
    required this.primaryColor,
    required this.secondaryColor,
    required this.buttonText,
    required this.snackBarText,
  });

  @override
  State<_SecondaryPreviewButton>
      createState() =>
          _SecondaryPreviewButtonState();
}

class _SecondaryPreviewButtonState
    extends State<_SecondaryPreviewButton> {
  bool _isPressed = false;

  void _showPreviewMessage() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            widget.snackBarText,
          ),
          behavior:
              SnackBarBehavior.floating,
          duration: const Duration(
            seconds: 1,
          ),
        ),
      );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Semantics(
      button: true,
      label: widget.buttonText,
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 120,
        ),
        height: 48,
        decoration: BoxDecoration(
          color: _isPressed
              ? widget.primaryColor
                  .withValues(
                  alpha: 0.12,
                )
              : Colors.transparent,
          borderRadius:
              BorderRadius.circular(
            14,
          ),
          border: Border.all(
            color:
                widget.secondaryColor,
            width: 1.5,
          ),
        ),
        child: InkWell(
          onTap:
              _showPreviewMessage,
          onHighlightChanged: (
            bool highlighted,
          ) {
            setState(() {
              _isPressed =
                  highlighted;
            });
          },
          borderRadius:
              BorderRadius.circular(
            14,
          ),
          child: Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              child: Text(
                widget.buttonText,
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,
                textAlign:
                    TextAlign.center,
                style: TextStyle(
                  color: widget
                      .secondaryColor,
                  fontSize: 14,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}