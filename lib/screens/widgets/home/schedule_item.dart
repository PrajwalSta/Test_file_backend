import 'package:flutter/material.dart';

import '../../theme/app_constants.dart';

class ScheduleItem extends StatelessWidget {
  final String title;
  final String time;
  final String emoji;

  const ScheduleItem({
    super.key,
    required this.title,
    required this.time,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
        Theme.of(context);

    final ColorScheme colorScheme =
        theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius:
            BorderRadius.circular(
          AppConstants.largeRadius,
        ),
        border: Border.all(
          color: theme.dividerColor
              .withValues(
            alpha: 0.4,
          ),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius:
            BorderRadius.circular(
          AppConstants.largeRadius,
        ),
        child: InkWell(
          borderRadius:
              BorderRadius.circular(
            AppConstants.largeRadius,
          ),
          onTap: () {},
          child: ListTile(
            leading: Text(
              emoji,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
            title: Text(
              title,
              maxLines: 1,
              overflow:
                  TextOverflow.ellipsis,
              style: TextStyle(
                color:
                    colorScheme.onSurface,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
            subtitle: Text(
              time,
              maxLines: 1,
              overflow:
                  TextOverflow.ellipsis,
              style: TextStyle(
                color: colorScheme
                    .onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}