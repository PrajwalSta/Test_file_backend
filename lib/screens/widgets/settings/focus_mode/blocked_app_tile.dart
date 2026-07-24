import 'package:flutter/material.dart';

import '../../../../models/blocked_app_model.dart';
import '../../../theme/app_constants.dart';
import 'custom_switch.dart';

class BlockedAppTile extends StatelessWidget {
  final BlockedAppModel app;
  final bool showDivider;
  final ValueChanged<bool> onChanged;

  const BlockedAppTile({
    super.key,
    required this.app,
    required this.showDivider,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
        Theme.of(context);

    final ColorScheme colorScheme =
        theme.colorScheme;

    return Semantics(
      container: true,
      toggled: app.isBlocked,
      label: app.name,
      child: Container(
        width: double.infinity,
        padding:
            const EdgeInsets.symmetric(
          horizontal: AppConstants.md,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          border: showDivider
              ? Border(
                  bottom: BorderSide(
                    color: theme
                        .dividerColor
                        .withValues(
                      alpha: 0.5,
                    ),
                  ),
                )
              : null,
        ),
        child: Row(
          children: [
            _buildIcon(
              context,
            ),

            const SizedBox(
              width: AppConstants.md,
            ),

            Expanded(
              child: Text(
                app.name,
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,
                style: theme
                    .textTheme.bodyMedium
                    ?.copyWith(
                  color:
                      colorScheme.onSurface,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(
              width: 12,
            ),

            CustomSwitch(
              value: app.isBlocked,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(
    BuildContext context,
  ) {
    final ThemeData theme =
        Theme.of(context);

    final ColorScheme colorScheme =
        theme.colorScheme;

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: colorScheme.primary
            .withValues(
          alpha: 0.12,
        ),
        borderRadius:
            BorderRadius.circular(
          14,
        ),
        border: Border.all(
          color: colorScheme.primary
              .withValues(
            alpha: 0.18,
          ),
        ),
      ),
      child: Icon(
        app.icon,
        color: colorScheme.primary,
        size: 21,
      ),
    );
  }
}