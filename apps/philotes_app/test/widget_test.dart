import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:philotes/screens/onboarding/interests_screen.dart';

void main() {
  testWidgets('Interests requires five selections and supports favorites', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: InterestsScreen()));

    expect(find.text('Your Interests'), findsOneWidget);

    expect(find.text('0 selected'), findsOneWidget);

    final continueButton = find.byKey(const Key('interestsContinueButton'));

    await tester.ensureVisible(continueButton);
    await tester.pumpAndSettle();

    await tester.tap(continueButton);
    await tester.pumpAndSettle();

    expect(
      find.text('Choose at least 5 interests before continuing.'),
      findsOneWidget,
    );

    final interestsToSelect = [
      'golf',
      'bowling',
      'sporting_events',
      'movies',
      'technology',
    ];

    for (final id in interestsToSelect) {
      final finder = find.byKey(Key('interest-$id'));

      await tester.ensureVisible(finder);
      await tester.pumpAndSettle();

      await tester.tap(finder);
      await tester.pumpAndSettle();
    }

    expect(find.text('5 selected'), findsOneWidget);

    final golfFavorite = find.byKey(const Key('favorite-golf'));

    await tester.ensureVisible(golfFavorite);
    await tester.pumpAndSettle();

    await tester.tap(golfFavorite);
    await tester.pumpAndSettle();

    expect(find.text('1 of 5 favorites'), findsOneWidget);
  });

  testWidgets('Interests supports search', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: InterestsScreen()));

    final searchField = find.byKey(const Key('interestSearchField'));

    await tester.enterText(searchField, 'sporting events');

    await tester.pump();

    expect(find.text('Going to Sporting Events'), findsOneWidget);
  });
}
