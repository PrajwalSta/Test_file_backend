import 'package:flutter/material.dart';

import '../../../models/activity_model.dart';

class ActivityTile extends StatelessWidget {
  final ActivityModel activity;

  const ActivityTile({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
        Theme.of(context);

    final ColorScheme colorScheme =
        theme.colorScheme;

    return Semantics(
      label: '${activity.title}, ${activity.time}',
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(
          bottom: 16,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius:
              BorderRadius.circular(18),
          border: Border.all(
            color: theme.dividerColor.withValues(
              alpha: 0.4,
            ),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor:
                  colorScheme.secondaryContainer,
              child: Text(
                activity.emoji,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),

            const SizedBox(
              width: 16,
            ),

            Expanded(
              child: Text(
                activity.title,
                maxLines: 2,
                overflow:
                    TextOverflow.ellipsis,
                style: TextStyle(
                  color:
                      colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(
              width: 12,
            ),

            Flexible(
              child: Text(
                activity.time,
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,
                textAlign:
                    TextAlign.end,
                style: TextStyle(
                  color: colorScheme
                      .onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}