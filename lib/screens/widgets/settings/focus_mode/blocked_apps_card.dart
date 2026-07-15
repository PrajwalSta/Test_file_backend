import 'package:flutter/material.dart';

import '../../../../models/blocked_app_model.dart';
import 'blocked_app_tile.dart';

class BlockedAppsCard extends StatelessWidget {
  final List<BlockedAppModel> apps;
  final Function(int index, bool value) onChanged;

  const BlockedAppsCard({
    super.key,
    required this.apps,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        children: List.generate(
          apps.length,
          (index) {
            return BlockedAppTile(
              app: apps[index],
              showDivider: index != apps.length - 1,
              onChanged: (value) {
                onChanged(index, value);
              },
            );
          },
        ),
      ),
    );
  }
}