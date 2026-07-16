
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  // Temporary local Do Not Disturb value.
  bool doNotDisturb = true;

  // Open a temporary demo page.
  void openPage(String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DemoPage(
          title: title,
        ),
      ),
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

    // SleepModeScreen returns true after
    // the settings are successfully saved.
    if (updated == true && mounted) {
      // Tell HomeScreen to reload Sleep Mode.
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
          shape: RoundedRectangleBorder(
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
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const LoginScreen(),
                  ),
                  (route) => false,
                );
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
          child: SingleChildScrollView(
            physics:
                const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

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
                          title: 'Dark Mode',
                          subtitle: themeProvider
                                  .isDarkMode
                              ? 'On — dark interface'
                              : 'Off — light interface',
                          value: themeProvider
                              .isDarkMode,
                          onChanged:
                              themeProvider
                                  .toggleTheme,
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
                      title: 'Language',
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
                    // Focus Mode screen.
                    SettingTile(
                      icon:
                          Icons.phone_iphone,
                      iconColor:
                          colorScheme.primary,
                      title:
                          'Focus Mode',
                      subtitle:
                          'Blocked apps, break intervals',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const FocusDndScreen(),
                          ),
                        );
                      },
                    ),

                    divider(context),

                    // Sleep Mode screen.
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

                    // Temporary Do Not Disturb switch.
                    SwitchSettingTile(
                      icon:
                          Icons.shield_outlined,
                      iconColor:
                          colorScheme.error,
                      title:
                          'Do Not Disturb',
                      subtitle:
                          doNotDisturb
                              ? '10 PM – 7 AM · On'
                              : 'Off',
                      value:
                          doNotDisturb,
                      onChanged: (value) {
                        setState(() {
                          doNotDisturb =
                              value;
                        });
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Sign-out button.
                SizedBox(
                  width: double.infinity,
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

                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Section title.
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
          color: colorScheme
              .onSurfaceVariant,
          fontSize: 11,
          fontWeight:
              FontWeight.bold,
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  // Divider between setting tiles.
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
        color: theme.dividerColor
            .withValues(
          alpha: 0.4,
        ),
      ),
    );
  }
}

// Temporary screen for unfinished settings pages.
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
