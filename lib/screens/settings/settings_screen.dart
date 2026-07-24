import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/language_provider.dart';
import '../../providers/theme_provider.dart';
import '../../services/focus_mode_service.dart';
import '../auth/login_screen.dart';
import '../notifications/notifications_screen.dart';
import '../privacy/privacy_screen.dart';
import '../profile/profile_screen.dart';
import '../settings/focus_mode/focus_dnd_screen.dart';
import '../settings/language/language_screen.dart';
import '../settings/sleep_mode/sleep_mode_screen.dart';
import '../theme/app_colors.dart';
import '../theme_color/theme_color_screen.dart';
import '../widgets/settings/setting_tile.dart';
import '../widgets/settings/switch_setting_tile.dart';
import '../widgets/settings/toggle_tile.dart';

class SettingsScreen extends StatefulWidget {
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

  bool focusModeEnabled = false;
  int selectedBreak = 25;

  bool instagramBlocked = true;
  bool twitterBlocked = true;
  bool youtubeBlocked = true;
  bool tiktokBlocked = false;
  bool whatsappBlocked = false;

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

  String _getCurrentLanguageLabel(
    String languageCode,
    AppLocalizations localizations,
  ) {
    switch (languageCode) {
      case 'ne':
        return localizations.nepali;
      case 'hi':
        return localizations.hindi;
      default:
        return localizations.english;
    }
  }

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
        final AppLocalizations localizations =
            AppLocalizations.of(context)!;

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                localizations
                    .unableToLoadDndSettings(
                  error.toString(),
                ),
              ),
            ),
          );
      }
    }
  }

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

      final AppLocalizations localizations =
          AppLocalizations.of(context)!;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              doNotDisturb
                  ? localizations.dndEnabled
                  : localizations.dndDisabled,
            ),
            behavior:
                SnackBarBehavior.floating,
          ),
        );
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        doNotDisturb =
            previousValue;
      });

      final AppLocalizations localizations =
          AppLocalizations.of(context)!;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              localizations.unableToUpdateDnd(
                error.toString(),
              ),
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

      final AppLocalizations localizations =
          AppLocalizations.of(context)!;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            localizations
                .sleepModeSettingsUpdated,
          ),
          behavior:
              SnackBarBehavior.floating,
        ),
      );
    }
  }

  String _formatShortTime(
    TimeOfDay time,
    AppLocalizations localizations,
  ) {
    final int hour =
        time.hourOfPeriod == 0
            ? 12
            : time.hourOfPeriod;

    final String period =
        time.period == DayPeriod.am
            ? localizations.am
            : localizations.pm;

    if (time.minute == 0) {
      return '$hour $period';
    }

    final String minute =
        time.minute
            .toString()
            .padLeft(2, '0');

    return '$hour:$minute $period';
  }

  String _getDndSubtitle(
    AppLocalizations localizations,
  ) {
    if (isLoadingFocusSettings) {
      return localizations.loadingSettings;
    }

    if (!doNotDisturb) {
      return localizations.off;
    }

    return '${_formatShortTime(dndStartTime, localizations)} – '
        '${_formatShortTime(dndEndTime, localizations)} · '
        '${localizations.on}';
  }

  void signOutDialog() {
    final ThemeData theme =
        Theme.of(context);

    final ColorScheme colorScheme =
        theme.colorScheme;

    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

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
            localizations.signOut,
            style: TextStyle(
              color:
                  colorScheme.onSurface,
              fontWeight:
                  FontWeight.w700,
            ),
          ),
          content: Text(
            localizations.signOutConfirmation,
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
                localizations.cancel,
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
                        localizations.signOutFailed(
                          error.toString(),
                        ),
                      ),
                    ),
                  );
                }
              },
              child: Text(
                localizations.signOut,
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

    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    final LanguageProvider languageProvider =
        context.watch<LanguageProvider>();

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
                        localizations.profileSection,
                      ),

                      SettingsGroup(
                        children: [
                          SettingTile(
                            icon:
                                Icons.person_outline,
                            iconColor:
                                colorScheme.primary,
                            title:
                                localizations.profile,
                            subtitle:
                                localizations.profileSubtitle,
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
                                localizations.privacyAndSecurity,
                            subtitle:
                                localizations.privacySubtitle,
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
                        localizations.preferencesSection,
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
                                    localizations.darkMode,
                                subtitle:
                                    themeProvider.isDarkMode
                                        ? localizations.darkModeOn
                                        : localizations.darkModeOff,
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
                                localizations.notifications,
                            subtitle:
                                localizations.notificationsSubtitle,
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
                                localizations.themeColor,
                            subtitle:
                                localizations.themeColorSubtitle,
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
                                localizations.language,
                            subtitle:
                                _getCurrentLanguageLabel(
                              languageProvider.languageCode,
                              localizations,
                            ),
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const LanguageScreen(),
                                ),
                              );

                              if (mounted) {
                                setState(() {});
                              }
                            },
                          ),
                        ],
                      ),

                      sectionTitleWidget(
                        context,
                        localizations.focusModesSection,
                      ),

                      SettingsGroup(
                        children: [
                          SettingTile(
                            icon:
                                Icons.phone_iphone,
                            iconColor:
                                colorScheme.primary,
                            title:
                                localizations.focusMode,
                            subtitle:
                                localizations.focusModeSubtitle,
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
                                localizations.sleepMode,
                            subtitle:
                                localizations.sleepModeSubtitle,
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
                                localizations.doNotDisturb,
                            subtitle:
                                _getDndSubtitle(
                              localizations,
                            ),
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
                            localizations.signOut,
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
        title.toUpperCase(),
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

    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

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
          localizations.pageTitle(title),
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
