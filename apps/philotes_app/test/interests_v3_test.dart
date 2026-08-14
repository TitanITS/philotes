import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:philotes/screens/onboarding/interests_screen.dart';
import 'package:philotes/widgets/interests/philotes_interest_widgets.dart';

void main() {
  testWidgets(
    'Interests V3 mobile starter remains clean with eight suggestions',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MaterialApp(home: InterestsScreen()));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('interestSuggestionsCard')), findsOneWidget);
      expect(find.byType(PhilotesInterestChip), findsNWidgets(8));
      expect(find.textContaining('5 favorites'), findsWidgets);
      expect(find.byKey(const Key('viewAllActivitiesButton')), findsOneWidget);
    },
  );

  testWidgets('Interests V3 wide layout exposes sixteen starter suggestions', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: InterestsScreen()));
    await tester.pumpAndSettle();

    expect(find.byType(PhilotesInterestChip), findsNWidgets(16));
  });

  testWidgets('View All Activities uses categorized Philotes cards', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: InterestsScreen()));
    await tester.pumpAndSettle();

    final button = find.byKey(const Key('viewAllActivitiesButton'));
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('allActivitiesScreen')), findsOneWidget);
    expect(find.text('Fitness & Wellness'), findsOneWidget);
    expect(find.text('Sports & Recreation'), findsOneWidget);
    expect(find.text('Pickleball'), findsOneWidget);
  });
}
