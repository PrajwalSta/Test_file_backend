import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'l10n/app_localizations.dart';
import 'providers/language_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/theme/app_theme.dart';
import 'services/local_notification_service.dart';

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>();

StreamSubscription<AuthState>?
    authSubscription;

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized();

  /*
   * ------------------------------------------------------
   * Initialize Supabase
   * ------------------------------------------------------
   */
  await Supabase.initialize(
    url:
        'https://kuqiieuuuurvxtnlpqac.supabase.co',
    publishableKey:
        'sb_publishable_2dn-psJkX9OjFVoPc5rQ9w_h-0KgVR-',
  );

  /*
   * ------------------------------------------------------
   * Initialize local notifications
   * ------------------------------------------------------
   */
  try {
    await LocalNotificationService
        .instance
        .initialize();

    debugPrint(
      'Local notification service initialized.',
    );
  } catch (error, stackTrace) {
    /*
     * Notification failure should not stop
     * the complete application.
     */
    debugPrint(
      'Local notification initialization '
      'failed: $error',
    );

    debugPrintStack(
      stackTrace: stackTrace,
    );
  }

  /*
   * ------------------------------------------------------
   * Create application providers
   * ------------------------------------------------------
   */
  final LanguageProvider
      languageProvider =
      LanguageProvider();

  final ThemeProvider themeProvider =
      ThemeProvider();

  /*
   * Load locally saved language.
   */
  try {
    await languageProvider
        .loadSavedLanguage();
  } catch (error, stackTrace) {
    debugPrint(
      'Could not load saved language: '
      '$error',
    );

    debugPrintStack(
      stackTrace: stackTrace,
    );
  }

  /*
   * Load the signed-in user's saved theme.
   *
   * Do not request Supabase theme data when
   * there is no authenticated user.
   */
  if (Supabase.instance.client.auth
          .currentUser !=
      null) {
    try {
      await themeProvider.loadTheme();
    } catch (error, stackTrace) {
      debugPrint(
        'Could not load saved theme: '
        '$error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );
    }
  }

  /*
   * ------------------------------------------------------
   * Start the Flutter application
   * ------------------------------------------------------
   */
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<
            ThemeProvider>.value(
          value: themeProvider,
        ),
        ChangeNotifierProvider<
            LanguageProvider>.value(
          value: languageProvider,
        ),
      ],
      child: const MyApp(),
    ),
  );

  /*
   * ------------------------------------------------------
   * Listen to Supabase authentication events
   * ------------------------------------------------------
   *
   * Password reset OTP flow:
   *
   * ForgotPasswordScreen
   * -> VerifyResetOtpScreen
   * -> ResetPasswordScreen
   * -> LoginScreen
   *
   * main.dart must not automatically open
   * ResetPasswordScreen.
   * ------------------------------------------------------
   */
  authSubscription =
      Supabase.instance.client.auth
          .onAuthStateChange
          .listen(
    (
      AuthState state,
    ) async {
      debugPrint(
        'Supabase authentication event: '
        '${state.event}',
      );

      /*
       * Do not navigate here during password
       * recovery.
       *
       * VerifyResetOtpScreen is responsible for
       * opening ResetPasswordScreen after:
       *
       * verifyOTP(
       *   type: OtpType.recovery,
       * )
       */
      if (state.event ==
          AuthChangeEvent
              .passwordRecovery) {
        debugPrint(
          'Password recovery session detected. '
          'Navigation is handled by the OTP screen.',
        );

        return;
      }

      /*
       * Reload user settings after a normal
       * sign-in or after Supabase restores an
       * existing session.
       *
       * OTP verification may also create a
       * signedIn event. This block only loads
       * settings and does not navigate.
       */
      if (state.event ==
              AuthChangeEvent
                  .signedIn ||
          state.event ==
              AuthChangeEvent
                  .initialSession) {
        /*
         * Ensure a valid user exists before
         * loading user-specific settings.
         */
        final User? currentUser =
            state.session?.user ??
                Supabase.instance.client.auth
                    .currentUser;

        if (currentUser == null) {
          debugPrint(
            'No authenticated user is available.',
          );

          return;
        }

        try {
          await languageProvider
              .loadSavedLanguage();
        } catch (error, stackTrace) {
          debugPrint(
            'Could not reload language '
            'after authentication: $error',
          );

          debugPrintStack(
            stackTrace: stackTrace,
          );
        }

        try {
          await themeProvider
              .loadTheme();
        } catch (error, stackTrace) {
          debugPrint(
            'Could not reload theme '
            'after authentication: $error',
          );

          debugPrintStack(
            stackTrace: stackTrace,
          );
        }
      }

      /*
       * Reset provider values and local
       * notifications after logout.
       */
      if (state.event ==
          AuthChangeEvent.signedOut) {
        languageProvider
            .resetLanguage();

        try {
          await themeProvider
              .resetTheme();
        } catch (error, stackTrace) {
          debugPrint(
            'Could not reset theme '
            'after logout: $error',
          );

          debugPrintStack(
            stackTrace: stackTrace,
          );
        }

        /*
         * Cancel local notifications belonging
         * to the previously signed-in user.
         *
         * clearInbox is false because notification
         * inbox rows should remain in Supabase.
         */
        try {
          await LocalNotificationService
              .instance
              .cancelAllNotifications(
            clearInbox: false,
          );
        } catch (error, stackTrace) {
          debugPrint(
            'Could not cancel local '
            'notifications after logout: '
            '$error',
          );

          debugPrintStack(
            stackTrace: stackTrace,
          );
        }
      }
    },
    onError: (
      Object error,
      StackTrace stackTrace,
    ) {
      debugPrint(
        'Supabase authentication error: '
        '$error',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return const FocusGlowApp();
  }
}

class FocusGlowApp
    extends StatelessWidget {
  const FocusGlowApp({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final ThemeProvider themeProvider =
        context.watch<ThemeProvider>();

    final LanguageProvider
        languageProvider =
        context.watch<
            LanguageProvider>();

    return MaterialApp(
      navigatorKey:
          navigatorKey,

      debugShowCheckedModeBanner:
          false,

      title:
          'Focus Glow',

      /*
       * Light theme using the user's selected
       * primary and secondary colors.
       */
      theme:
          AppTheme.lightTheme(
        primaryColor:
            themeProvider
                .primaryColor,
        secondaryColor:
            themeProvider
                .secondaryColor,
      ),

      /*
       * Dark theme using the user's selected
       * primary and secondary colors.
       */
      darkTheme:
          AppTheme.darkTheme(
        primaryColor:
            themeProvider
                .primaryColor,
        secondaryColor:
            themeProvider
                .secondaryColor,
      ),

      themeMode:
          themeProvider.themeMode,

      locale:
          languageProvider.locale,

      localizationsDelegates:
          AppLocalizations
              .localizationsDelegates,

      supportedLocales:
          AppLocalizations
              .supportedLocales,

      localeResolutionCallback:
          (
        Locale? locale,
        Iterable<Locale>
            supportedLocales,
      ) {
        if (locale == null) {
          return const Locale(
            'en',
          );
        }

        for (
          final Locale
              supportedLocale
          in supportedLocales
        ) {
          if (supportedLocale
                  .languageCode ==
              locale.languageCode) {
            return supportedLocale;
          }
        }

        return const Locale(
          'en',
        );
      },

      home:
          const SplashScreen(),
    );
  }
}