import 'package:flutter/material.dart';
import '../../main_screen.dart';
import 'package:flutter_app_project/models/blocked_app_model.dart';
import 'package:flutter_app_project/screens/theme/app_constants.dart';
import 'package:flutter_app_project/screens/widgets/bottom_nav_bar.dart';
import 'package:flutter_app_project/screens/widgets/settings/focus_mode/blocked_apps_card.dart';
import 'package:flutter_app_project/screens/widgets/settings/focus_mode/break_interval_card.dart';
import 'package:flutter_app_project/screens/widgets/settings/focus_mode/dnd_card.dart';
import 'package:flutter_app_project/screens/widgets/settings/focus_mode/focus_header.dart';
import 'package:flutter_app_project/screens/widgets/settings/focus_mode/focus_mode_card.dart';
import 'package:flutter_app_project/screens/widgets/settings/focus_mode/section_title.dart';

class FocusDndScreen extends StatefulWidget {
  const FocusDndScreen({super.key});

  @override
  State<FocusDndScreen> createState() => _FocusDndScreenState();
}

class _FocusDndScreenState extends State<FocusDndScreen> {
  bool focusModeEnabled = false;
  bool dndEnabled = true;
  int selectedBreak = 25;

  late List<BlockedAppModel> blockedApps;

  @override
  void initState() {
    super.initState();
    blockedApps = BlockedAppModel.demoApps;
  }

  void updateBlockedApp(int index, bool value) {
    setState(() {
      blockedApps[index].isBlocked = value;
    });
  }

  void updateBreakInterval(int value) {
    setState(() {
      selectedBreak = value;
    });
  }

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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      bottomNavigationBar: BottomNavBar(
        currentIndex: 4,
        onTap: _handleBottomNavTap,
      ),

      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            AppConstants.lg,
            AppConstants.md,
            AppConstants.lg,
            AppConstants.xl,
          ),
          children: [
            const FocusHeader(),

            const SizedBox(height: AppConstants.xl),

            SizedBox(
              width: double.infinity,
              child: FocusModeCard(
                value: focusModeEnabled,
                onChanged: (value) {
                  setState(() {
                    focusModeEnabled = value;
                  });
                },
              ),
            ),

            const SizedBox(height: AppConstants.lg),

            SizedBox(
              width: double.infinity,
              child: BreakIntervalCard(
                selectedValue: selectedBreak,
                onSelected: updateBreakInterval,
              ),
            ),

            const SizedBox(height: AppConstants.xl),

            const SectionTitle(
              title: "BLOCKED APPS",
            ),

            const SizedBox(height: AppConstants.sm),

            SizedBox(
              width: double.infinity,
              child: BlockedAppsCard(
                apps: blockedApps,
                onChanged: updateBlockedApp,
              ),
            ),

            const SizedBox(height: AppConstants.lg),

            SizedBox(
              width: double.infinity,
              child: DndCard(
                enabled: dndEnabled,
                onChanged: (value) {
                  setState(() {
                    dndEnabled = value;
                  });
                },
              ),
            ),

            const SizedBox(height: AppConstants.lg),
          ],
        ),
      ),
    );
  }
}