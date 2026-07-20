import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app_focus_glow/main.dart';
import 'package:flutter_app_focus_glow/screens/home/home_screen.dart';
import 'package:flutter_app_focus_glow/screens/settings/settings_screen.dart';

void main() {
  testWidgets('App shows splash screen then home screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('FocusFlow'), findsOneWidget);
    expect(find.text('Smart Life Scheduler'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Good Evening,'), findsOneWidget);
  });

  testWidgets('Tapping Add on home opens the schedule sheet', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: HomeScreen()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    expect(find.text('Add Schedule'), findsOneWidget);
  });

  testWidgets('Tapping Notifications opens the notifications screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SettingsScreen(
          onSleepSettingsUpdated: () {},
        ),
      ),
    );

    await tester.tap(find.widgetWithText(ListTile, 'Notifications'));
    await tester.pumpAndSettle();

    expect(find.text('CHANNELS'), findsOneWidget);
  });
}
