import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:philotes/screens/app/philotes_shell_screen.dart';

void main() {
  Future<void> openPlans(WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: PhilotesShellScreen()));

    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('navPlans')));

    await tester.pumpAndSettle();
  }

  testWidgets('Plans opens from main navigation', (WidgetTester tester) async {
    await openPlans(tester);

    expect(find.byKey(const Key('plansScreen')), findsOneWidget);

    expect(find.text('Today'), findsOneWidget);

    expect(find.text('Upcoming'), findsOneWidget);

    expect(find.text('Recent Past'), findsOneWidget);
  });

  testWidgets('Plans shows simulated activities', (WidgetTester tester) async {
    await openPlans(tester);

    expect(find.text('Axe Throwing'), findsOneWidget);

    expect(find.text('Bowling Night'), findsOneWidget);

    expect(find.text('Hurricanes Game'), findsOneWidget);
  });

  testWidgets('Plan card opens reusable detail screen', (
    WidgetTester tester,
  ) async {
    await openPlans(tester);

    final card = find.byKey(const Key('planCard-dev-axe-throwing'));

    await tester.ensureVisible(card);
    await tester.tap(card);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('planDetailScreen')), findsOneWidget);

    expect(find.text('Bull City Axe Throwing'), findsOneWidget);

    expect(find.text('Going'), findsOneWidget);

    expect(find.text('Notes'), findsOneWidget);
  });

  testWidgets('Plan detail includes future action hooks', (
    WidgetTester tester,
  ) async {
    await openPlans(tester);

    final card = find.byKey(const Key('planCard-dev-axe-throwing'));

    await tester.ensureVisible(card);
    await tester.tap(card);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('openPlanMapsButton')), findsOneWidget);

    expect(find.byKey(const Key('messagePlanGroupButton')), findsOneWidget);

    expect(find.byKey(const Key('editPlanButton')), findsOneWidget);

    expect(find.byKey(const Key('cancelPlanButton')), findsOneWidget);
  });

  testWidgets('Back returns from plan detail to Plans', (
    WidgetTester tester,
  ) async {
    await openPlans(tester);

    final card = find.byKey(const Key('planCard-dev-axe-throwing'));

    await tester.ensureVisible(card);
    await tester.tap(card);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('planDetailScreen')), findsOneWidget);

    await tester.tap(find.byKey(const Key('backToPlansButton')));

    await tester.pumpAndSettle();

    expect(find.byKey(const Key('plansScreen')), findsOneWidget);
  });

  testWidgets('Plans exposes Create Plan control', (WidgetTester tester) async {
    await openPlans(tester);

    expect(find.byKey(const Key('createPlanButton')), findsOneWidget);
  });

  testWidgets('Plans exposes paged history hook', (WidgetTester tester) async {
    await openPlans(tester);

    final historyButton = find.byKey(const Key('viewMorePlanHistoryButton'));

    await tester.ensureVisible(historyButton);

    expect(historyButton, findsOneWidget);
  });
}
