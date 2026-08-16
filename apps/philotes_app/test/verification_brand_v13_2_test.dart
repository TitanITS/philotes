import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:philotes/screens/onboarding/verification_safety_screen.dart';
import 'package:philotes/screens/onboarding/verify_email_screen.dart';

void main() {
  testWidgets(
    'Check Your Email uses the canonical Philotes brand header',
    (tester) async {
      tester.view.physicalSize = const Size(1200, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: VerifyEmailScreen(email: 'member@example.com'),
        ),
      );

      expect(find.text('PHILOTES'), findsOneWidget);
      expect(find.text('A COMMUNITY FOR FRIENDSHIP'), findsOneWidget);
      expect(find.text('Check Your Email'), findsOneWidget);
      expect(
        find.byKey(const Key('developmentBasicProfileButton')),
        findsNothing,
      );
    },
  );

  testWidgets(
    'Verification and Safety uses canonical brand and real verification copy',
    (tester) async {
      tester.view.physicalSize = const Size(1200, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(home: VerificationSafetyScreen()),
      );

      expect(find.text('PHILOTES'), findsOneWidget);
      expect(find.text('A COMMUNITY FOR FRIENDSHIP'), findsOneWidget);
      expect(find.text('Verification & Safety'), findsOneWidget);
      expect(find.textContaining('Email verified'), findsOneWidget);
      expect(
        find.textContaining('real email verification is not connected'),
        findsNothing,
      );
    },
  );
}
