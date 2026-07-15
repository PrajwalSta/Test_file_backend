import 'package:flutter/material.dart';

import '../theme/app_constants.dart';
import '../widgets/statistics/category_chart_card.dart';
import '../widgets/statistics/daily_focus_chart.dart';
import '../widgets/statistics/focus_summary_card.dart';
import '../widgets/statistics/monthly_focus_card.dart';
import '../widgets/statistics/statistics_header.dart';
import '../widgets/statistics/statistics_overview.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int currentNavigationIndex = 3;

  void handleNavigation(int index) {
    if (index == currentNavigationIndex) {
      return;
    }

    setState(() {
      currentNavigationIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        break;
      case 2:
        break;
      case 3:
        break;
      case 4:
        break;
      case 5:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  AppConstants.screenHorizontalPadding,
                  18,
                  AppConstants.screenHorizontalPadding,
                  20,
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatisticsHeader(),
                    SizedBox(height: 16),

                    FocusSummaryCard(),
                    SizedBox(height: 12),

                    StatisticsOverview(),
                    SizedBox(height: 14),

                    DailyFocusChart(),
                    SizedBox(height: 14),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 6,
                          child: CategoryChartCard(),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 4,
                          child: MonthlyFocusCard(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // AppBottomNavigation(
            //   currentIndex: currentNavigationIndex,
            //   onTap: handleNavigation,
            // ),
          ],
        ),
      ),
    );
  }
}