import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:philotes/screens/onboarding/verification_safety_screen.dart';

void main() {
  testWidgets(
    'Verification and Safety requires acknowledgement',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: VerificationSafetyScreen(),
        ),
      );

      expect(
        find.text('Verification & Safety'),
        findsOneWidget,
      );

      final continueButton = find.byKey(
        const Key(
          'verificationSafetyContinueButton',
        ),
      );

      await tester.ensureVisible(continueButton);
      await tester.pumpAndSettle();

      await tester.tap(continueButton);
      await tester.pumpAndSettle();

      expect(
        find.byKey(
          const Key('safetyAcknowledgementError'),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Verification and Safety contains prominent scam warning',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: VerificationSafetyScreen(),
        ),
      );

      expect(
        find.byKey(
          const Key('antiScamWarning'),
        ),
        findsOneWidget,
      );

      expect(
        find.text('PROTECT YOURSELF FROM SCAMS'),
        findsOneWidget,
      );

      expect(
        find.byKey(
          const Key('primaryScamWarningText'),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Meeting Safety expands to show guidance',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: VerificationSafetyScreen(),
        ),
      );

      final meetingSafetyToggle = find.byKey(
        const Key('meetingSafetyToggle'),
      );

      await tester.ensureVisible(meetingSafetyToggle);
      await tester.pumpAndSettle();

      await tester.tap(meetingSafetyToggle);
      await tester.pumpAndSettle();

      expect(
        find.textContaining(
          'Meet in a public place',
        ),
        findsOneWidget,
      );

      expect(
        find.textContaining(
          'Arrange your own transportation',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Safety acknowledgement can be selected',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: VerificationSafetyScreen(),
        ),
      );

      final acknowledgement = find.byKey(
        const Key(
          'safetyAcknowledgementCheckbox',
        ),
      );

      await tester.ensureVisible(acknowledgement);
      await tester.pumpAndSettle();

      await tester.tap(acknowledgement);
      await tester.pumpAndSettle();

      final checkbox =
          tester.widget<CheckboxListTile>(
        acknowledgement,
      );

      expect(
        checkbox.value,
        isTrue,
      );
    },
  );
}
