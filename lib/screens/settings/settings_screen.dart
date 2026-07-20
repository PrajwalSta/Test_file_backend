import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../services/focus_mode_service.dart';
import '../auth/login_screen.dart';
import '../notifications/notifications_screen.dart';
import '../privacy/privacy_screen.dart';
import '../profile/profile_screen.dart';
import '../settings/focus_mode/focus_dnd_screen.dart';
import '../settings/language/language_screen.dart';
import '../settings/sleep_mode/sleep_mode_screen.dart';
import '../theme/app_colors.dart';
import '../theme/theme_provider.dart';
import '../theme_color/theme_color_screen.dart';
import '../widgets/settings/setting_tile.dart';
import '../widgets/settings/switch_setting_tile.dart';
import '../widgets/settings/toggle_tile.dart';

class SettingsScreen extends StatefulWidget {
  // This callback tells HomeScreen that
  // Sleep Mode settings have changed.
  final VoidCallback onSleepSettingsUpdated;

  const SettingsScreen({
    super.key,
    required this.onSleepSettingsUpdated,
  });

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState
    extends State<SettingsScreen> {
  final FocusModeService _focusModeService =
      FocusModeService();

  // Focus Mode values loaded from Supabase.
  bool focusModeEnabled = false;
  int selectedBreak = 25;

  bool instagramBlocked = true;
  bool twitterBlocked = true;
  bool youtubeBlocked = true;
  bool tiktokBlocked = false;
  bool whatsappBlocked = false;

  // Do Not Disturb values.
  bool doNotDisturb = true;

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

  bool isLoadingFocusSettings = true;
  bool isSavingDnd = false;

  @override
  void initState() {
    super.initState();

    _loadFocusModeSettings();
  }

  // Load Focus Mode and DND values from Supabase.
  Future<void> _loadFocusModeSettings({
    bool showError = true,
  }) async {
    try {
      final settings =
          await _focusModeService.loadSettings();

      if (!mounted) {
        return;
      }

      setState(() {
        focusModeEnabled =
            settings.focusModeEnabled;

        selectedBreak =
            settings.breakIntervalMinutes;

        instagramBlocked =
            settings.blockInstagram;

        twitterBlocked =
            settings.blockTwitter;

        youtubeBlocked =
            settings.blockYoutube;

        tiktokBlocked =
            settings.blockTiktok;

        whatsappBlocked =
            settings.blockWhatsapp;

        doNotDisturb =
            settings.dndEnabled;

        dndStartTime =
            settings.dndStartTime;

        dndEndTime =
            settings.dndEndTime;

        isLoadingFocusSettings = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        isLoadingFocusSettings = false;
      });

      if (showError) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                'Unable to load Do Not Disturb settings: $error',
              ),
            ),
          );
      }
    }
  }

  // Save DND switch while preserving all other Focus Mode values.
  Future<void> _updateDoNotDisturb(
    bool value,
  ) async {
    if (isSavingDnd ||
        isLoadingFocusSettings) {
      return;
    }

    final bool previousValue =
        doNotDisturb;

    setState(() {
      doNotDisturb = value;
      isSavingDnd = true;
    });

    try {
      await _focusModeService.saveSettings(
        focusModeEnabled:
            focusModeEnabled,
        breakIntervalMinutes:
            selectedBreak,
        blockInstagram:
            instagramBlocked,
        blockTwitter:
            twitterBlocked,
        blockYoutube:
            youtubeBlocked,
        blockTiktok:
            tiktokBlocked,
        blockWhatsapp:
            whatsappBlocked,
        dndEnabled:
            doNotDisturb,
        dndStartTime:
            dndStartTime,
        dndEndTime:
            dndEndTime,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              doNotDisturb
                  ? 'Do Not Disturb enabled'
                  : 'Do Not Disturb disabled',
            ),
            behavior:
                SnackBarBehavior.floating,
          ),
        );
    } catch (error) {
      if (!mounted) {
        return;
      }

      // Restore the old switch value if saving fails.
      setState(() {
        doNotDisturb =
            previousValue;
      });

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              'Unable to update Do Not Disturb: $error',
            ),
          ),
        );
    } finally {
      if (mounted) {
        setState(() {
          isSavingDnd = false;
        });
      }
    }
  }

  // Open Focus Mode and reload the DND values
  // after the user returns.
  Future<void> _openFocusModeScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const FocusDndScreen(),
      ),
    );

    if (!mounted) {
      return;
    }

    await _loadFocusModeSettings(
      showError: false,
    );
  }

  // Open Sleep Mode settings.
  Future<void> _openSleepModeScreen() async {
    final bool? updated =
        await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const SleepModeScreen(),
      ),
    );

    if (updated == true && mounted) {
      widget.onSleepSettingsUpdated();

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Sleep Mode settings updated',
          ),
          behavior:
              SnackBarBehavior.floating,
        ),
      );
    }
  }

  // Format time like 10 PM or 7:30 AM.
  String _formatShortTime(
    TimeOfDay time,
  ) {
    final int hour =
        time.hourOfPeriod == 0
            ? 12
            : time.hourOfPeriod;

    final String period =
        time.period == DayPeriod.am
            ? 'AM'
            : 'PM';

    if (time.minute == 0) {
      return '$hour $period';
    }

    final String minute =
        time.minute
            .toString()
            .padLeft(2, '0');

    return '$hour:$minute $period';
  }

  String get _dndSubtitle {
    if (isLoadingFocusSettings) {
      return 'Loading settings...';
    }

    if (!doNotDisturb) {
      return 'Off';
    }

    return '${_formatShortTime(dndStartTime)} – '
        '${_formatShortTime(dndEndTime)} · On';
  }

  // Show sign-out confirmation dialog.
  void signOutDialog() {
    final ThemeData theme =
        Theme.of(context);

    final ColorScheme colorScheme =
        theme.colorScheme;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor:
              theme.cardColor,
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(18),
          ),
          title: Text(
            'Sign Out',
            style: TextStyle(
              color:
                  colorScheme.onSurface,
              fontWeight:
                  FontWeight.w700,
            ),
          ),
          content: Text(
            'Are you sure you want to sign out?',
            style: TextStyle(
              color: colorScheme
                  .onSurfaceVariant,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: colorScheme
                      .onSurfaceVariant,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(
                  dialogContext,
                );

                try {
                  await Supabase
                      .instance
                      .client
                      .auth
                      .signOut();

                  if (!mounted) {
                    return;
                  }

                  Navigator.of(context)
                      .pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) =>
                          const LoginScreen(),
                    ),
                    (route) => false,
                  );
                } on AuthException catch (
                  error
                ) {
                  if (!mounted) {
                    return;
                  }

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    SnackBar(
                      content: Text(
                        error.message,
                      ),
                    ),
                  );
                } catch (error) {
                  if (!mounted) {
                    return;
                  }

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Sign out failed: $error',
                      ),
                    ),
                  );
                }
              },
              child: Text(
                'Sign Out',
                style: TextStyle(
                  color:
                      colorScheme.error,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
        Theme.of(context);

    final ColorScheme colorScheme =
        theme.colorScheme;

    return Scaffold(
      backgroundColor:
          theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 8,
          ),
          child: LayoutBuilder(
            builder: (
              context,
              constraints,
            ) {
              return SingleChildScrollView(
                physics:
                    const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                        constraints.maxHeight,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 8,
                      ),

                      sectionTitleWidget(
                        context,
                        'PROFILE',
                      ),

                      SettingsGroup(
                        children: [
                          SettingTile(
                            icon:
                                Icons.person_outline,
                            iconColor:
                                colorScheme.primary,
                            title: 'Profile',
                            subtitle:
                                'Name, photo, bio',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const ProfileScreen(),
                                ),
                              );
                            },
                          ),

                          divider(context),

                          SettingTile(
                            icon:
                                Icons.lock_outline,
                            iconColor:
                                colorScheme.secondary,
                            title:
                                'Privacy & Security',
                            subtitle:
                                'Password, 2FA, biometrics',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const PrivacySecurityScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),

                      sectionTitleWidget(
                        context,
                        'PREFERENCES',
                      ),

                      SettingsGroup(
                        children: [
                          Consumer<ThemeProvider>(
                            builder: (
                              context,
                              themeProvider,
                              child,
                            ) {
                              return SwitchSettingTile(
                                icon: Icons
                                    .dark_mode_outlined,
                                iconColor:
                                    colorScheme.primary,
                                title:
                                    'Dark Mode',
                                subtitle:
                                    themeProvider.isDarkMode
                                        ? 'On — dark interface'
                                        : 'Off — light interface',
                                value:
                                    themeProvider.isDarkMode,
                                onChanged:
                                    themeProvider.toggleTheme,
                              );
                            },
                          ),

                          divider(context),

                          SettingTile(
                            icon: Icons
                                .notifications_none,
                            iconColor:
                                AppColors.yellow,
                            title:
                                'Notifications',
                            subtitle:
                                'Push, email, reminders',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const NotificationsScreen(),
                                ),
                              );
                            },
                          ),

                          divider(context),

                          SettingTile(
                            icon: Icons
                                .color_lens_outlined,
                            iconColor:
                                AppColors.orange,
                            title:
                                'Theme Color',
                            subtitle:
                                'Customize app color scheme',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const ThemeColorScreen(),
                                ),
                              );
                            },
                          ),

                          divider(context),

                          SettingTile(
                            icon:
                                Icons.language,
                            iconColor:
                                colorScheme.secondary,
                            title:
                                'Language',
                            subtitle:
                                'English (US)',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const LanguageScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),

                      sectionTitleWidget(
                        context,
                        'FOCUS MODES',
                      ),

                      SettingsGroup(
                        children: [
                          SettingTile(
                            icon:
                                Icons.phone_iphone,
                            iconColor:
                                colorScheme.primary,
                            title:
                                'Focus Mode',
                            subtitle:
                                'Blocked apps, break intervals',
                            onTap:
                                _openFocusModeScreen,
                          ),

                          divider(context),

                          SettingTile(
                            icon: Icons
                                .nightlight_rounded,
                            iconColor:
                                AppColors.yellow,
                            title:
                                'Sleep Mode',
                            subtitle:
                                'Bedtime and wake-up schedule',
                            onTap:
                                _openSleepModeScreen,
                          ),

                          divider(context),

                          SwitchSettingTile(
                            icon:
                                Icons.shield_outlined,
                            iconColor:
                                colorScheme.error,
                            title:
                                'Do Not Disturb',
                            subtitle:
                                _dndSubtitle,
                            value:
                                doNotDisturb,
                            onChanged:
                                _updateDoNotDisturb,
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      SizedBox(
                        width:
                            double.infinity,
                        height: 52,
                        child:
                            ElevatedButton.icon(
                          onPressed:
                              signOutDialog,
                          icon: Icon(
                            Icons.logout_rounded,
                            color:
                                colorScheme.error,
                            size: 20,
                          ),
                          label: Text(
                            'Sign Out',
                            style: TextStyle(
                              color:
                                  colorScheme.error,
                              fontSize: 15,
                              fontWeight:
                                  FontWeight.w700,
                            ),
                          ),
                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                colorScheme.error
                                    .withValues(
                              alpha: 0.12,
                            ),
                            foregroundColor:
                                colorScheme.error,
                            elevation: 0,
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                16,
                              ),
                              side: BorderSide(
                                color:
                                    colorScheme.error
                                        .withValues(
                                  alpha: 0.35,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget sectionTitleWidget(
    BuildContext context,
    String title,
  ) {
    final ColorScheme colorScheme =
        Theme.of(context).colorScheme;

    return Padding(
      padding:
          const EdgeInsets.only(
        top: 22,
        bottom: 8,
      ),
      child: Text(
        title,
        style: TextStyle(
          color:
              colorScheme.onSurfaceVariant,
          fontSize: 11,
          fontWeight:
              FontWeight.bold,
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  Widget divider(
    BuildContext context,
  ) {
    final ThemeData theme =
        Theme.of(context);

    return Padding(
      padding:
          const EdgeInsets.only(
        left: 66,
        right: 16,
      ),
      child: Divider(
        height: 1,
        color:
            theme.dividerColor.withValues(
          alpha: 0.4,
        ),
      ),
    );
  }
}

class DemoPage extends StatelessWidget {
  final String title;

  const DemoPage({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme =
        Theme.of(context);

    final ColorScheme colorScheme =
        theme.colorScheme;

    return Scaffold(
      backgroundColor:
          theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor:
            theme.scaffoldBackgroundColor,
        foregroundColor:
            colorScheme.onSurface,
        elevation: 0,
        title: Text(title),
      ),
      body: Center(
        child: Text(
          '$title Page',
          style: TextStyle(
            color:
                colorScheme.onSurface,
            fontSize: 22,
            fontWeight:
                FontWeight.w600,
          ),
        ),
      ),
    );
  }
}