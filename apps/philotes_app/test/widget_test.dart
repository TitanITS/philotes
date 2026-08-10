import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:philotes/screens/onboarding/location_discovery_screen.dart';

void main() {
  testWidgets('Location Discovery requires location and distance', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LocationDiscoveryScreen()));

    expect(find.text('Location & Discovery'), findsOneWidget);

    final continueButton = find.byKey(
      const Key('locationDiscoveryContinueButton'),
    );

    await tester.ensureVisible(continueButton);

    await tester.pumpAndSettle();

    await tester.tap(continueButton);

    await tester.pumpAndSettle();

    expect(
      find.textContaining('Please choose a location source'),
      findsOneWidget,
    );
  });

  testWidgets('Location Discovery accepts device location', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LocationDiscoveryScreen()));

    final currentLocationButton = find.byKey(
      const Key('useCurrentLocationButton'),
    );

    await tester.ensureVisible(currentLocationButton);

    await tester.pumpAndSettle();

    await tester.tap(currentLocationButton);

    await tester.pumpAndSettle();

    expect(find.text('Current device area selected'), findsOneWidget);
  });

  testWidgets('Location Discovery accepts a valid ZIP code', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LocationDiscoveryScreen()));

    final zipOption = find.byKey(const Key('enterZipCodeButton'));

    await tester.ensureVisible(zipOption);

    await tester.pumpAndSettle();

    await tester.tap(zipOption);

    await tester.pumpAndSettle();

    final zipField = find.byKey(const Key('zipCodeField'));

    await tester.ensureVisible(zipField);

    await tester.pumpAndSettle();

    await tester.enterText(zipField, '27701');

    await tester.pumpAndSettle();

    final confirmZipButton = find.byKey(const Key('confirmZipCodeButton'));

    await tester.ensureVisible(confirmZipButton);

    await tester.pumpAndSettle();

    await tester.tap(confirmZipButton);

    await tester.pumpAndSettle();

    expect(find.text('ZIP 27701 area selected'), findsOneWidget);
  });

  testWidgets('Location Discovery rejects an incomplete ZIP code', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LocationDiscoveryScreen()));

    final zipOption = find.byKey(const Key('enterZipCodeButton'));

    await tester.ensureVisible(zipOption);

    await tester.pumpAndSettle();

    await tester.tap(zipOption);

    await tester.pumpAndSettle();

    final zipField = find.byKey(const Key('zipCodeField'));

    await tester.ensureVisible(zipField);

    await tester.pumpAndSettle();

    await tester.enterText(zipField, '277');

    await tester.pumpAndSettle();

    final confirmZipButton = find.byKey(const Key('confirmZipCodeButton'));

    await tester.ensureVisible(confirmZipButton);

    await tester.pumpAndSettle();

    await tester.tap(confirmZipButton);

    await tester.pumpAndSettle();

    expect(find.text('Enter a valid 5-digit ZIP code.'), findsOneWidget);

    expect(find.text('ZIP 277 area selected'), findsNothing);
  });

  testWidgets('Location Discovery contains meeting distance options', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LocationDiscoveryScreen()));

    expect(find.text('Very close to me'), findsOneWidget);

    expect(find.text('Nearby'), findsOneWidget);

    expect(find.text('A little farther away'), findsOneWidget);

    expect(find.text('I\'m willing to travel farther'), findsOneWidget);

    expect(find.text('Distance isn\'t very important to me'), findsOneWidget);

    expect(find.byKey(const Key('onlineFriendshipsCheckbox')), findsOneWidget);
  });

  testWidgets('Location Discovery allows meeting distance selection', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LocationDiscoveryScreen()));

    final distance25 = find.byKey(const Key('distance25'));

    await tester.ensureVisible(distance25);

    await tester.pumpAndSettle();

    await tester.tap(distance25);

    await tester.pumpAndSettle();

    expect(find.text('Within about 25 miles'), findsOneWidget);
  });

  testWidgets('Location Discovery supports online friendship preference', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LocationDiscoveryScreen()));

    final onlineCheckbox = find.byKey(const Key('onlineFriendshipsCheckbox'));

    await tester.ensureVisible(onlineCheckbox);

    await tester.pumpAndSettle();

    await tester.tap(onlineCheckbox);

    await tester.pumpAndSettle();

    final checkbox = tester.widget<CheckboxListTile>(onlineCheckbox);

    expect(checkbox.value, isTrue);
  });
}
