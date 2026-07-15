import 'package:flutter/material.dart';

import '../main_screen.dart';
import '../theme/app_constants.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/profile/badges_section.dart';
import '../widgets/profile/profile_avatar.dart';
import '../widgets/profile/profile_header.dart';
import '../widgets/profile/profile_stats.dart';
import '../widgets/profile/recent_activity.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _changePage(BuildContext context, int index) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => MainScreen(
          initialIndex: index,
        ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      bottomNavigationBar: BottomNavBar(
        currentIndex: 4,
        onTap: (index) {
          _changePage(context, index);
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(
            AppConstants.screen,
          ),
          child: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileHeader(),
                SizedBox(height: 24),
                ProfileAvatar(),
                SizedBox(height: 28),
                ProfileStats(),
                SizedBox(height: 30),
                BadgesSection(),
                SizedBox(height: 30),
                RecentActivity(),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}