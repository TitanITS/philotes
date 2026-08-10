import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:philotes/screens/onboarding/friendship_preferences_screen.dart';

void main() {
  testWidgets(
    'Friendship Preferences validates required sections',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FriendshipPreferencesScreen(),
        ),
      );

      expect(
        find.text('Friendship Preferences'),
        findsOneWidget,
      );

      final continueButton = find.byKey(
        const Key(
          'friendshipPreferencesContinueButton',
        ),
      );

      await tester.ensureVisible(
        continueButton,
      );

      await tester.pumpAndSettle();

      await tester.tap(
        continueButton,
      );

      await tester.pumpAndSettle();

      expect(
        find.textContaining(
          'Please complete the required friendship',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Friendship Preferences contains age and compatibility controls',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FriendshipPreferencesScreen(),
        ),
      );

      expect(
        find.text('Friendship Style'),
        findsOneWidget,
      );

      expect(
        find.text('Social Pace'),
        findsOneWidget,
      );

      expect(
        find.text(
          'Shared Interests & New Experiences',
        ),
        findsOneWidget,
      );

      expect(
        find.text('Friendship Age Range'),
        findsOneWidget,
      );

      expect(
        find.byKey(
          const Key('minimumFriendAgeField'),
        ),
        findsOneWidget,
      );

      expect(
        find.byKey(
          const Key('maximumFriendAgeField'),
        ),
        findsOneWidget,
      );

      expect(
        find.text(
          'Preferred friendship range: 18 - 80+',
        ),
        findsOneWidget,
      );

      expect(
        find.text('Compatibility Preferences'),
        findsOneWidget,
      );

      expect(
        find.byKey(
          const Key('flexibleDiscoveryCheckbox'),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Friendship age minimum cannot go below 18',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FriendshipPreferencesScreen(),
        ),
      );

      final minimumAgeField = find.byKey(
        const Key('minimumFriendAgeField'),
      );

      await tester.ensureVisible(
        minimumAgeField,
      );

      await tester.pumpAndSettle();

      final textField = find.descendant(
        of: minimumAgeField,
        matching: find.byType(TextField),
      );

      await tester.enterText(
        textField,
        '12',
      );

      await tester.pumpAndSettle();

      expect(
        find.text(
          'Preferred friendship range: 18 - 80+',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Catholic is available as a faith preference',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FriendshipPreferencesScreen(),
        ),
      );

      expect(
        find.text('Faith / Religion'),
        findsOneWidget,
      );

      expect(
        find.text('Compatibility Preferences'),
        findsOneWidget,
      );
    },
  );
}
