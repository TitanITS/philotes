import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:philotes/models/onboarding_profile_data.dart';
import 'package:philotes/screens/welcome_screen.dart';

void main() {
  setUp(() {
    OnboardingProfileData.instance.reset();
  });

  testWidgets('Developer quick entry is debug guarded', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: PhilotesWelcomeScreen()));

    if (kDebugMode) {
      expect(
        find.byKey(const Key('developerQuickEntrySection')),
        findsOneWidget,
      );

      expect(
        find.byKey(const Key('developerTestAccountButton')),
        findsOneWidget,
      );
    }
  });

  testWidgets('Normal welcome actions remain available', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: PhilotesWelcomeScreen()));

    expect(find.byKey(const Key('joinCommunityButton')), findsOneWidget);

    expect(find.byKey(const Key('signInButton')), findsOneWidget);
  });

  testWidgets('Developer account bypasses onboarding', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: PhilotesWelcomeScreen()));

    if (!kDebugMode) {
      return;
    }

    final button = find.byKey(const Key('developerTestAccountButton'));

    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('philotesHomeScreen')), findsOneWidget);

    expect(find.byKey(const Key('philotesMainNavigation')), findsOneWidget);
  });

  testWidgets('Developer account seeds fixture profile', (
    WidgetTester tester,
  ) async {
    final profile = OnboardingProfileData.instance;

    expect(profile.displayName, isEmpty);

    await tester.pumpWidget(const MaterialApp(home: PhilotesWelcomeScreen()));

    if (!kDebugMode) {
      return;
    }

    final button = find.byKey(const Key('developerTestAccountButton'));

    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(profile.displayName, 'Alex');

    expect(profile.selectedInterests, isNotEmpty);

    expect(profile.favoriteInterests, isNotEmpty);

    expect(profile.socialFrequency, "Whenever we're both available");

    expect(profile.photoSelected, isTrue);
  });
}
