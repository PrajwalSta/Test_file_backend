import 'package:flutter/material.dart';

import '../../../models/stat_model.dart';
import '../../theme/app_colors.dart';
import 'stat_card.dart';

class ProfileStats extends StatelessWidget {
  const ProfileStats({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = [
      StatModel(
        icon: Icons.local_fire_department,
        value: "7",
        label: "days",
        color: AppColors.orange,
      ),
      const StatModel(
        icon: Icons.check_box,
        value: "142",
        label: "done",
        color: AppColors.cyan,
      ),
      const StatModel(
        icon: Icons.bolt,
        value: "98",
        label: "hours",
        color: AppColors.primary,
      ),
      const StatModel(
        icon: Icons.emoji_events,
        value: "12",
        label: "pro",
        color: AppColors.yellow,
      ),
    ];

    return SizedBox(
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = 4;

          if (constraints.maxWidth < 700) {
            crossAxisCount = 2;
          }

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: stats.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.45,
            ),
            itemBuilder: (context, index) {
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