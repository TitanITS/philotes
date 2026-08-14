import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:philotes/models/onboarding_profile_data.dart';
import 'package:philotes/screens/app/philotes_shell_screen.dart';

void main() {
  setUp(() {
    final profile = OnboardingProfileData.instance;

    profile.reset();

    profile.displayName = 'Test Friend';

    profile.meetingDistance = '25';

    profile.selectedInterests = <String>[
      'Movies',
      'Dining Out',
      'Bowling',
      'Live Music',
      'Technology',
      'Museums',
      'Road Trips',
      'Going to Sporting Events',
    ];

    profile.favoriteInterests = <String>[
      'Movies',
      'Dining Out',
      'Bowling',
      'Live Music',
      'Going to Sporting Events',
    ];

    profile.socialFrequency = "Whenever we're both available";
  });

  Future<void> openDiscover(WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: PhilotesShellScreen()));

    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('navDiscover')));

    await tester.pumpAndSettle();
  }

  testWidgets('Discover opens from main navigation', (
    WidgetTester tester,
  ) async {
    await openDiscover(tester);

    expect(find.byKey(const Key('discoverScreen')), findsOneWidget);

    expect(find.text('People To Discover'), findsOneWidget);
  });

  testWidgets('Discover shows all development members by default', (
    WidgetTester tester,
  ) async {
    await openDiscover(tester);

    expect(find.text('Jordan'), findsOneWidget);

    expect(find.text('Taylor'), findsOneWidget);

    expect(find.text('Casey'), findsOneWidget);
  });

  testWidgets('Discover prioritizes compatibility over distance', (
    WidgetTester tester,
  ) async {
    await openDiscover(tester);

    final jordan = find.byKey(const Key('discoverMember-dev-jordan'));

    expect(jordan, findsOneWidget);

    expect(find.byKey(const Key('outsideDistance-dev-jordan')), findsOneWidget);

    expect(find.textContaining('32 miles away'), findsOneWidget);
  });

  testWidgets('Strict distance hides outside-distance member', (
    WidgetTester tester,
  ) async {
    await openDiscover(tester);

    final filter = find.byKey(const Key('discoverDistanceFilter'));

    await tester.ensureVisible(filter);

    await tester.tap(filter);

    await tester.pumpAndSettle();

    await tester.tap(find.text('Strict').last);

    await tester.pumpAndSettle();

    expect(find.text('Jordan'), findsNothing);

    expect(find.text('Taylor'), findsOneWidget);

    expect(find.text('Casey'), findsOneWidget);
  });

  testWidgets('Strong filter keeps only strong compatibility', (
    WidgetTester tester,
  ) async {
    await openDiscover(tester);

    final filter = find.byKey(const Key('discoverCompatibilityFilter'));

    await tester.ensureVisible(filter);

    await tester.tap(filter);

    await tester.pumpAndSettle();

    await tester.tap(find.text('Strong only').last);

    await tester.pumpAndSettle();

    expect(find.text('Jordan'), findsOneWidget);

    expect(find.text('Taylor'), findsNothing);

    expect(find.text('Casey'), findsNothing);
  });

  testWidgets('Discover member opens existing profile screen', (
    WidgetTester tester,
  ) async {
    await openDiscover(tester);

    final jordan = find.byKey(const Key('discoverMember-dev-jordan'));

    await tester.ensureVisible(jordan);

    await tester.tap(jordan);

    await tester.pumpAndSettle();

    expect(find.byKey(const Key('memberProfileScreen')), findsOneWidget);

    expect(find.text('89%'), findsOneWidget);

    expect(find.text('Why You May Connect'), findsOneWidget);
  });

  testWidgets('Discover has no Show Interest decision control', (
    WidgetTester tester,
  ) async {
    await openDiscover(tester);

    expect(find.text('Show Interest'), findsNothing);
  });

  testWidgets('Discover identifies filters as temporary', (
    WidgetTester tester,
  ) async {
    await openDiscover(tester);

    expect(find.textContaining('Temporary filters'), findsOneWidget);

    expect(
      find.byKey(const Key('editPermanentPreferencesButton')),
      findsOneWidget,
    );
  });
}
