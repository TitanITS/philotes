import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:philotes/models/onboarding_profile_data.dart';
import 'package:philotes/screens/onboarding/friendship_preferences_screen.dart';
import 'package:philotes/screens/onboarding/review_profile_screen.dart';

void main() {
  setUp(() {
    OnboardingProfileData.instance.reset();
  });

  testWidgets('Social Pace contains mutual availability option', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: FriendshipPreferencesScreen()),
    );

    final field = find.byKey(const Key('socialFrequencyField'));

    expect(field, findsOneWidget);

    await tester.ensureVisible(field);
    await tester.tap(field);
    await tester.pumpAndSettle();

    expect(find.text("Whenever we're both available"), findsOneWidget);
  });

  testWidgets('Flexible Social Pace explains mutual availability', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: FriendshipPreferencesScreen()),
    );

    final field = find.byKey(const Key('socialFrequencyField'));

    await tester.ensureVisible(field);
    await tester.tap(field);
    await tester.pumpAndSettle();

    await tester.tap(find.text("Whenever we're both available").last);

    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('flexibleSocialPaceExplanation')),
      findsOneWidget,
    );

    expect(
      find.textContaining("I'm flexible. If we're both free"),
      findsOneWidget,
    );

    expect(find.textContaining("open to making plans"), findsOneWidget);
  });

  testWidgets('Social Pace helper is hidden for other selections', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: FriendshipPreferencesScreen()),
    );

    final field = find.byKey(const Key('socialFrequencyField'));

    await tester.ensureVisible(field);
    await tester.tap(field);
    await tester.pumpAndSettle();

    await tester.tap(find.text('About once a week').last);

    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('flexibleSocialPaceExplanation')),
      findsNothing,
    );
  });

  testWidgets('Review Profile displays flexible Social Pace', (
    WidgetTester tester,
  ) async {
    final profile = OnboardingProfileData.instance;

    profile.socialFrequency = "Whenever we're both available";

    await tester.pumpWidget(const MaterialApp(home: ReviewProfileScreen()));

    await tester.pumpAndSettle();

    final socialPace = find.text("Whenever we're both available");

    await tester.scrollUntilVisible(
      socialPace,
      300,
      scrollable: find.byType(Scrollable).first,
    );

    expect(socialPace, findsOneWidget);
  });
}
