import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../main_screen.dart';
import 'package:flutter_app_focus_glow/models/blocked_app_model.dart';
import 'package:flutter_app_focus_glow/screens/theme/app_constants.dart';
import 'package:flutter_app_focus_glow/screens/widgets/bottom_nav_bar.dart';
import 'package:flutter_app_focus_glow/screens/widgets/settings/focus_mode/blocked_apps_card.dart';
import 'package:flutter_app_focus_glow/screens/widgets/settings/focus_mode/break_interval_card.dart';
import 'package:flutter_app_focus_glow/screens/widgets/settings/focus_mode/dnd_card.dart';
import 'package:flutter_app_focus_glow/screens/widgets/settings/focus_mode/focus_header.dart';
import 'package:flutter_app_focus_glow/screens/widgets/settings/focus_mode/focus_mode_card.dart';
import 'package:flutter_app_focus_glow/screens/widgets/settings/focus_mode/section_title.dart';
import 'package:flutter_app_focus_glow/services/focus_mode_service.dart';

class FocusDndScreen extends StatefulWidget {
  const FocusDndScreen({
    super.key,
  });

  @override
  State<FocusDndScreen> createState() =>
      _FocusDndScreenState();
}

class _FocusDndScreenState
    extends State<FocusDndScreen> {
  final FocusModeService _focusModeService =
      FocusModeService();

  bool focusModeEnabled = false;
  bool dndEnabled = true;

  int selectedBreak = 25;

  TimeOfDay dndStartTime =
      const TimeOfDay(
    hour: 22,
    minute: 0,
  );

  TimeOfDay dndEndTime =
      const TimeOfDay(
    hour: 7,
    minute: 0,
  );

  bool isLoading = true;
  bool isSaving = false;

  late List<BlockedAppModel> blockedApps;

  @override
  void initState() {
    super.initState();

    blockedApps =
        List<BlockedAppModel>.from(
      BlockedAppModel.demoApps,
    );

    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final settings =
          await _focusModeService
              .loadSettings();

      if (!mounted) {
        return;
      }

      setState(() {
        focusModeEnabled =
            settings.focusModeEnabled;

        selectedBreak =
            settings.breakIntervalMinutes;

        dndEnabled =
            settings.dndEnabled;

        dndStartTime =
            settings.dndStartTime;

        dndEndTime =
            settings.dndEndTime;

        if (blockedApps.isNotEmpty) {
          blockedApps[0].isBlocked =
              settings.blockInstagram;
        }

        if (blockedApps.length > 1) {
          blockedApps[1].isBlocked =
              settings.blockTwitter;
        }

        if (blockedApps.length > 2) {
          blockedApps[2].isBlocked =
              settings.blockYoutube;
        }

        if (blockedApps.length > 3) {
          blockedApps[3].isBlocked =
              settings.blockTiktok;
        }

        if (blockedApps.length > 4) {
          blockedApps[4].isBlocked =
              settings.blockWhatsapp;
        }

        isLoading = false;
      });
    } catch (error) {
      debugPrint(
        'Unable to load Focus Mode settings: $error',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        isLoading = false;
      });

      final AppLocalizations localizations =
          AppLocalizations.of(context)!;

      _showMessage(
        localizations
            .unableToLoadFocusModeSettings,
      );
    }
  }

  Future<void> _saveSettings() async {
    if (isLoading || isSaving) {
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await _focusModeService
          .saveSettings(
        focusModeEnabled:
            focusModeEnabled,
        breakIntervalMinutes:
            selectedBreak,
        blockInstagram:
            _blockedValueAt(0),
        blockTwitter:
            _blockedValueAt(1),
        blockYoutube:
            _blockedValueAt(2),
        blockTiktok:
            _blockedValueAt(3),
        blockWhatsapp:
            _blockedValueAt(4),
        dndEnabled:
            dndEnabled,
        dndStartTime:
            dndStartTime,
        dndEndTime:
            dndEndTime,
      );
    } catch (error) {
      debugPrint(
        'Unable to save Focus Mode settings: $error',
      );

      if (!mounted) {
        return;
      }

      final AppLocalizations localizations =
          AppLocalizations.of(context)!;

      _showMessage(
        localizations
            .unableToSaveFocusModeSettings,
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  bool _blockedValueAt(
    int index,
  ) {
    if (index < 0 ||
        index >= blockedApps.length) {
      return false;
    }

    return blockedApps[index].isBlocked;
  }

  void updateBlockedApp(
    int index,
    bool value,
  ) {
    if (index < 0 ||
        index >= blockedApps.length) {
      return;
    }

    setState(() {
      blockedApps[index].isBlocked =
          value;
    });

    _saveSettings();
  }

  void updateBreakInterval(
    int value,
  ) {
    setState(() {
      selectedBreak = value;
    });

    _saveSettings();
  }

  void updateFocusMode(
    bool value,
  ) {
    setState(() {
      focusModeEnabled = value;
    });

    _saveSettings();
  }

  void updateDnd(
    bool value,
  ) {
    setState(() {
      dndEnabled = value;
    });

    _saveSettings();
  }

  void updateDndStartTime(
    TimeOfDay value,
  ) {
    setState(() {
      dndStartTime = value;
    });

    _saveSettings();
  }

  void updateDndEndTime(
    TimeOfDay value,
  ) {
    setState(() {
      dndEndTime = value;
    });

    _saveSettings();
  }

  void _showMessage(
    String message,
  ) {
    final ScaffoldMessengerState messenger =
        ScaffoldMessenger.of(context);

    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
        ),
        behavior:
            SnackBarBehavior.floating,
      ),
    );
  }

  void _handleBottomNavTap(
    int index,
  ) {
    if (index == 4) {
      Navigator.pop(context);
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute<void>(
        builder: (
          BuildContext context,
        ) {
          return MainScreen(
            initialIndex: index,
          );
        },
      ),
      (
        Route<dynamic> route,
      ) {
        return false;
      },
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final ThemeData theme =
        Theme.of(context);

    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor:
          theme.scaffoldBackgroundColor,
      bottomNavigationBar: BottomNavBar(
        currentIndex: 4,
        onTap: _handleBottomNavTap,
      ),
      body: SafeArea(
        child: isLoading
            ? Center(
                child:
                    CircularProgressIndicator(
                  color: theme
                      .colorScheme.primary,
                ),
              )
            : Stack(
                children: [
                  ListView(
                    physics:
                        const BouncingScrollPhysics(),
                    padding:
                        const EdgeInsets.fromLTRB(
                      AppConstants.lg,
                      AppConstants.md,
                      AppConstants.lg,
                      AppConstants.xl,
                    ),
                    children: [
                      const FocusHeader(),

                      const SizedBox(
                        height:
                            AppConstants.xl,
                      ),

                      SizedBox(
                        width:
                            double.infinity,
                        child: FocusModeCard(
                          value:
                              focusModeEnabled,
                          onChanged:
                              updateFocusMode,
                        ),
                      ),

                      const SizedBox(
                        height:
                            AppConstants.lg,
                      ),

                      SizedBox(
                        width:
                            double.infinity,
                        child:
                            BreakIntervalCard(
                          selectedValue:
                              selectedBreak,
                          onSelected:
                              updateBreakInterval,
                        ),
                      ),

                      const SizedBox(
                        height:
                            AppConstants.xl,
                      ),

                      SectionTitle(
                        title: localizations
                            .blockedApps
                            .toUpperCase(),
                      ),

                      const SizedBox(
                        height:
                            AppConstants.sm,
                      ),

                      SizedBox(
                        width:
                            double.infinity,
                        child:
                            BlockedAppsCard(
                          apps: blockedApps,
                          onChanged:
                              updateBlockedApp,
                        ),
                      ),

                      const SizedBox(
                        height:
                            AppConstants.lg,
                      ),

                      SizedBox(
                        width:
                            double.infinity,
                        child: DndCard(
                          enabled:
                              dndEnabled,
                          onChanged:
                              updateDnd,
                          startTime:
                              dndStartTime,
                          endTime:
                              dndEndTime,
                          onStartTimeChanged:
                              updateDndStartTime,
                          onEndTimeChanged:
                              updateDndEndTime,
                        ),
                      ),

                      const SizedBox(
                        height:
                            AppConstants.lg,
                      ),
                    ],
                  ),

                  if (isSaving)
                    Positioned(
                      top: 8,
                      right:
                          AppConstants.lg,
                      child: Semantics(
                        label: localizations
                            .saving,
                        child:
                            const SizedBox(
                          width: 20,
                          height: 20,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}