import 'package:flutter/material.dart';

import '../../../models/activity_model.dart';
import 'activity_tile.dart';

class RecentActivity extends StatelessWidget {
  const RecentActivity({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final activities = [
      const ActivityModel(
        emoji: "💻",
        title: "Completed Deep Work Session",
        time: "2h ago",
      ),
      const ActivityModel(
        emoji: "🔥",
        title: "7-day streak achieved!",
        time: "Today",
      ),
    ];

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "RECENT ACTIVITY",
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return ActivityTile(
                activity: activities[index],
              );
            },
          ),
        ],
      ),
    );
  }
}