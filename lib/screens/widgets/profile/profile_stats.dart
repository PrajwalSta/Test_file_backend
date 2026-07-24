import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/stat_model.dart';
import '../../theme/app_colors.dart';
import 'stat_card.dart';

class ProfileStats extends StatelessWidget {
  final int streak;
  final int completedTasks;
  final int focusHours;
  final String membership;

  const ProfileStats({
    super.key,
    required this.streak,
    required this.completedTasks,
    required this.focusHours,
    required this.membership,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    final List<StatModel> stats = [
      StatModel(
        icon: Icons.local_fire_department,
        value: streak.toString(),
        label: localizations.days,
        color: AppColors.orange,
      ),
      StatModel(
        icon: Icons.check_box,
        value: completedTasks.toString(),
        label: localizations.done,
        color: AppColors.cyan,
      ),
      StatModel(
        icon: Icons.bolt,
        value: focusHours.toString(),
        label: localizations.hours,
        color: AppColors.primary,
      ),
      StatModel(
        icon: Icons.emoji_events,
        value: membership,
        label: localizations.membership,
        color: AppColors.yellow,
      ),
    ];

    return SizedBox(
      width: double.infinity,
      child: LayoutBuilder(
        builder: (
          BuildContext context,
          BoxConstraints constraints,
        ) {
          int crossAxisCount = 4;

          if (constraints.maxWidth < 700) {
            crossAxisCount = 2;
          }

          return GridView.builder(
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(),
            itemCount: stats.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.45,
            ),
            itemBuilder: (
              BuildContext context,
              int index,
            ) {
              return StatCard(
                stat: stats[index],
              );
            },
          );
        },
      ),
    );
  }
}