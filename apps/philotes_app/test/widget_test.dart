import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:philotes/models/onboarding_profile_data.dart';
import 'package:philotes/screens/app/philotes_shell_screen.dart';

void main() {
  setUp(() {
    final profile = OnboardingProfileData.instance;

    profile.reset();

    profile.displayName = 'Test Friend';

    profile.favoriteInterests = <String>[
      'Going to Sporting Events',
      'Movies',
      'Dining Out',
      'Bowling',
      'Live Music',
    ];
  });

  testWidgets('Philotes Home greets member', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: PhilotesShellScreen()));

    await tester.pumpAndSettle();

    expect(find.byKey(const Key('philotesHomeScreen')), findsOneWidget);

    expect(find.text('Welcome back, Test Friend'), findsOneWidget);
  });

  testWidgets('Philotes shell has five destinations', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: PhilotesShellScreen()));

    expect(find.text('Home'), findsOneWidget);

    expect(find.text('Discover'), findsOneWidget);

    expect(find.text('Plans'), findsOneWidget);

    expect(find.text('Messages'), findsOneWidget);

    expect(find.text('You'), findsOneWidget);
  });

  testWidgets('Home shows simulated community content', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: PhilotesShellScreen()));

    expect(find.text('Your Community'), findsOneWidget);

    expect(find.byKey(const Key('peoplePreviewCard')), findsOneWidget);

    expect(find.text('People You May Enjoy Meeting'), findsOneWidget);
  });

  testWidgets('Discover navigation works', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: PhilotesShellScreen()));

    final discover = find.byKey(const Key('navDiscover'));

    await tester.tap(discover);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('discoverScreen')), findsOneWidget);

    expect(find.text('People To Discover'), findsOneWidget);
  });

  testWidgets('Plans navigation works', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: PhilotesShellScreen()));

    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('navPlans')));

    await tester.pumpAndSettle();

    expect(find.byKey(const Key('plansScreen')), findsOneWidget);

    expect(find.text('Today'), findsOneWidget);

    expect(find.text('Upcoming'), findsOneWidget);

    expect(find.text('Recent Past'), findsOneWidget);
  });

  testWidgets('Messages navigation works', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: PhilotesShellScreen()));

    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('navMessages')));

    await tester.pumpAndSettle();

    expect(find.byKey(const Key('messagesScreen')), findsOneWidget);

    expect(find.text('Recent Conversations'), findsOneWidget);
  });

  testWidgets('You navigation works', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: PhilotesShellScreen()));

    await tester.tap(find.byKey(const Key('navYou')));

    await tester.pumpAndSettle();

    expect(find.byKey(const Key('youScreen')), findsOneWidget);
  });
}
