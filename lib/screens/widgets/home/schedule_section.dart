import 'package:flutter/material.dart';

import 'schedule_item.dart';

class ScheduleSection extends StatelessWidget {
  const ScheduleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ScheduleItem(
          title: 'Morning Workout',
          time: '06:00 AM - 45 min',
          emoji: '🏃',
        ),
        ScheduleItem(
          title: 'Deep Work Session',
          time: '09:00 AM - 2h',
          emoji: '💻',
        ),
        ScheduleItem(
          title: 'Team Standup',
          time: '11:00 AM - 30 min',
          emoji: '👥',
        ),
      ],
    );
  }
}