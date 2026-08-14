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

    profile.socialFrequency = "Whenever we're both available";
  });

  testWidgets('Home v2 shows two suggested people', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: PhilotesShellScreen()));

    await tester.pumpAndSettle();

    expect(find.text('People You May Enjoy Meeting'), findsOneWidget);

    expect(find.text('Jordan'), findsOneWidget);

    expect(find.text('Taylor'), findsOneWidget);

    expect(find.text('Casey'), findsNothing);
  });

  testWidgets('Home v2 uses compatibility labels', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: PhilotesShellScreen()));

    await tester.pumpAndSettle();

    expect(find.text('Strong'), findsOneWidget);

    expect(find.text('Moderate'), findsOneWidget);
  });

  testWidgets('Home does not contain Show Interest action', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: PhilotesShellScreen()));

    await tester.pumpAndSettle();

    expect(find.text('Show Interest'), findsNothing);
  });

  testWidgets('Suggested member opens compatibility profile', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: PhilotesShellScreen()));

    await tester.pumpAndSettle();

    final jordan = find.byKey(const Key('suggestedMember-dev-jordan'));

    await tester.ensureVisible(jordan);
    await tester.tap(jordan);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('memberProfileScreen')), findsOneWidget);

    expect(find.text('89%'), findsOneWidget);

    expect(find.text('Why You May Connect'), findsOneWidget);
  });

  testWidgets('Member profile contains decision action', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: PhilotesShellScreen()));

    await tester.pumpAndSettle();

    final jordan = find.byKey(const Key('suggestedMember-dev-jordan'));

    await tester.ensureVisible(jordan);
    await tester.tap(jordan);
    await tester.pumpAndSettle();

    final showInterest = find.byKey(const Key('showInterestButton'));

    await tester.scrollUntilVisible(
      showInterest,
      300,
      scrollable: find.byType(Scrollable).last,
    );

    expect(showInterest, findsOneWidget);
  });

  testWidgets('Empty Today shows outing suggestion', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: PhilotesShellScreen()));

    await tester.pumpAndSettle();

    final today = find.byKey(const Key('todayCard'));

    await tester.scrollUntilVisible(
      today,
      250,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.text('Your day is open.'), findsOneWidget);

    expect(find.textContaining('Axe Throwing'), findsOneWidget);
  });

  testWidgets('Main navigation remains intact', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: PhilotesShellScreen()));

    expect(find.byKey(const Key('navHome')), findsOneWidget);

    expect(find.byKey(const Key('navDiscover')), findsOneWidget);

    expect(find.byKey(const Key('navPlans')), findsOneWidget);

    expect(find.byKey(const Key('navMessages')), findsOneWidget);

    expect(find.byKey(const Key('navYou')), findsOneWidget);
  });
}
