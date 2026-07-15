import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/splash/splash_screen.dart';
import 'screens/theme/app_theme.dart';
import 'screens/theme/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://kuqiieuuuurvxtnlpqac.supabase.co',
    publishableKey:
        'sb_publishable_2dn-psJkX9OjFVoPc5rQ9w_h-0KgVR-',
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const FocusGlowApp();
  }
}

class FocusGlowApp extends StatelessWidget {
  const FocusGlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider =
        context.watch<ThemeProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Focus Glow',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      home: const SplashScreen(),
    );
  }
}