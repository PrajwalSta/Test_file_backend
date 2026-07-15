import 'package:flutter/material.dart';

import '../../data/notification_data.dart';
import '../../models/notification_setting.dart';
import '../main_screen.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/notifications/notification_card.dart';
import '../widgets/notifications/notification_header.dart';
import '../widgets/notifications/notification_section_title.dart';
import '../widgets/notifications/notification_tile.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  static const int selectedIndex = 4;

  void _handleBottomNavTap(int index) {
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
        currentIndex: selectedIndex,
        onTap: _handleBottomNavTap,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const NotificationHeader(),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSection(
                        title: 'CHANNELS',
                        items: NotificationData.channels,
                      ),
                      const SizedBox(height: 24),
                      _buildSection(
                        title: 'ALERTS',
                        items: NotificationData.alerts,
                      ),
                      const SizedBox(height: 24),
                      _buildSection(
                        title: 'DISPLAY',
                        items: NotificationData.display,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<NotificationSetting> items,
  }) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NotificationSectionTitle(
            title: title,
          ),
          NotificationCard(
            child: Column(
              children: List.generate(
                items.length,
                (index) {
                  final setting = items[index];

                  return NotificationTile(
                    setting: setting,
                    showDivider: index != items.length - 1,
                    onChanged: (value) {
                      setState(() {
                        setting.enabled = value;
                      });
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}