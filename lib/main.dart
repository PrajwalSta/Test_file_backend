import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'l10n/app_localizations.dart';
import 'providers/language_provider.dart';
import 'screens/Auth/reset_password_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/theme/app_theme.dart';
import 'screens/theme/theme_provider.dart';
import 'services/local_notification_service.dart';

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>();

StreamSubscription<AuthState>? authSubscription;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://kuqiieuuuurvxtnlpqac.supabase.co',
    publishableKey:
        'sb_publishable_2dn-psJkX9OjFVoPc5rQ9w_h-0KgVR-',
  );

  await LocalNotificationService.instance.initialize();

  final LanguageProvider languageProvider =
      LanguageProvider();

  final ThemeProvider themeProvider =
      ThemeProvider();

  /*
   * Load language saved on the device or backend.
   */
  await languageProvider.loadSavedLanguage();

  /*
   * Load Dark Mode when a Supabase session
   * already exists.
   */
  if (Supabase.instance.client.auth.currentUser !=
      null) {
    await themeProvider.loadTheme();
  }

  authSubscription =
      Supabase.instance.client.auth.onAuthStateChange.listen(
    (AuthState state) async {
      debugPrint(
        'Supabase authentication event: ${state.event}',
      );

      /*
       * Password recovery redirect.
       */
      if (state.event ==
          AuthChangeEvent.passwordRecovery) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) {
            final NavigatorState? navigator =
                navigatorKey.currentState;

            if (navigator == null) {
              debugPrint(
                'Navigator is not ready for password recovery.',
              );
              return;
            }

            navigator.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) =>
                    const ResetPasswordScreen(),
              ),
              (Route<dynamic> route) => false,
            );
          },
        );
      }

      /*
       * Load language and theme after login
       * or when Supabase restores a session.
       */
      if (state.event ==
              AuthChangeEvent.signedIn ||
          state.event ==
              AuthChangeEvent.initialSession) {
        await languageProvider.loadSavedLanguage();

        await themeProvider.loadTheme();
      }

      /*
       * Reset language and theme after logout.
       */
      if (state.event ==
          AuthChangeEvent.signedOut) {
        languageProvider.resetLanguage();

        themeProvider.resetTheme();
      }
    },
    onError: (
      Object error,
      StackTrace stackTrace,
    ) {
      debugPrint(
        'Supabase authentication error: $error',
      );
    },
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: themeProvider,
        ),
        ChangeNotifierProvider.value(
          value: languageProvider,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const FocusGlowApp();
  }
}

class FocusGlowApp extends StatelessWidget {
  const FocusGlowApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider =
        context.watch<ThemeProvider>();

    final LanguageProvider languageProvider =
        context.watch<LanguageProvider>();

    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,

      title: 'Focus Glow',

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,

      locale: languageProvider.locale,

      localizationsDelegates:
          AppLocalizations.localizationsDelegates,

      supportedLocales:
          AppLocalizations.supportedLocales,

      localeResolutionCallback: (
        Locale? locale,
        Iterable<Locale> supportedLocales,
      ) {
        if (locale == null) {
          return const Locale('en');
        }

        for (final Locale supportedLocale
            in supportedLocales) {
          if (supportedLocale.languageCode ==
              locale.languageCode) {
            return supportedLocale;
          }
        }

        return const Locale('en');
      },

      home: const SplashScreen(),
    );
  }
}