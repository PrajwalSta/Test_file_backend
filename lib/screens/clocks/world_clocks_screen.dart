import 'package:flutter/material.dart';

import '../../data/world_clock_data.dart';
import '../widgets/clocks/world_clock_card.dart';

class WorldClocksScreen extends StatelessWidget {
  final bool showBottomNavigationBar;

  const WorldClocksScreen({
    super.key,
    this.showBottomNavigationBar = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.public,
                    color: colorScheme.primary,
                  ),

                  const SizedBox(width: 8),

                  Text(
                    "World Clocks",
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Spacer(),

                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.dividerColor.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Icon(
                      Icons.add,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Expanded(
                child: ListView.builder(
                  itemCount: worldClocks.length,
                  itemBuilder: (context, index) {
                    return WorldClockCard(
                      clock: worldClocks[index],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}