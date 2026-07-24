import 'package:flutter/material.dart';

import '../../../../models/blocked_app_model.dart';
import 'blocked_app_tile.dart';

class BlockedAppsCard extends StatelessWidget {
  final List<BlockedAppModel> apps;
  final void Function(
    int index,
    bool value,
  ) onChanged;

  const BlockedAppsCard({
    super.key,
    required this.apps,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
        Theme.of(context);

    if (apps.isEmpty) {
      return const SizedBox.shrink();
    }

    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: Container(
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius:
              BorderRadius.circular(20),
          border: Border.all(
            color: theme.dividerColor
                .withValues(
              alpha: 0.4,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List<Widget>.generate(
            apps.length,
            (int index) {
              final BlockedAppModel app =
                  apps[index];

              return BlockedAppTile(
                key: ValueKey<String>(
                  app.name,
                ),
                app: app,
                showDivider:
                    index != apps.length - 1,
                onChanged: (
                  bool value,
                ) {
                  onChanged(
                    index,
                    value,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}