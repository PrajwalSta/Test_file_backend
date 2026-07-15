import 'package:flutter/material.dart';

import '../../../models/badge_model.dart';
import 'badge_card.dart';

class BadgesSection extends StatelessWidget {
  const BadgesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final badges = [
      const BadgeModel(
        emoji: "🌅",
        title: "Early Bird",
        earned: true,
      ),
      const BadgeModel(
        emoji: "🦉",
        title: "Night Owl",
        earned: true,
      ),
      const BadgeModel(
        emoji: "🔥",
        title: "Streak 7",
        earned: true,
      ),
      const BadgeModel(
        emoji: "⚡",
        title: "Focus 100h",
        earned: false,
      ),
      const BadgeModel(
        emoji: "📅",
        title: "Planner Pro",
        earned: true,
      ),
      const BadgeModel(
        emoji: "🧘",
        title: "Zen Master",
        earned: false,
      ),
    ];

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "BADGES",
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                "4/6 earned",
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = 3;

              if (constraints.maxWidth >= 1000) {
                crossAxisCount = 6;
              } else if (constraints.maxWidth >= 700) {
                crossAxisCount = 4;
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: badges.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (context, index) {
                  return BadgeCard(
                    badge: badges[index],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}