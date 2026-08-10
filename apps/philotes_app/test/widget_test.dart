import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:philotes/screens/onboarding/profile_photo_screen.dart';

void main() {
  testWidgets(
    'Profile Photo requires a photo before continuing',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfilePhotoScreen(),
        ),
      );

      expect(
        find.text('Add a Profile Photo'),
        findsOneWidget,
      );

      final continueButton = find.byKey(
        const Key('profilePhotoContinueButton'),
      );

      await tester.ensureVisible(continueButton);
      await tester.pumpAndSettle();

      await tester.tap(continueButton);
      await tester.pumpAndSettle();

      expect(
        find.byKey(
          const Key('profilePhotoError'),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Profile Photo can simulate camera selection',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfilePhotoScreen(),
        ),
      );

      final cameraButton = find.byKey(
        const Key('takePhotoButton'),
      );

      await tester.ensureVisible(cameraButton);
      await tester.pumpAndSettle();

      await tester.tap(cameraButton);
      await tester.pumpAndSettle();

      expect(
        find.text('Photo selected from camera'),
        findsOneWidget,
      );

      expect(
        find.byKey(
          const Key('removePhotoButton'),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Profile Photo can simulate device selection',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfilePhotoScreen(),
        ),
      );

      final chooseButton = find.byKey(
        const Key('choosePhotoButton'),
      );

      await tester.ensureVisible(chooseButton);
      await tester.pumpAndSettle();

      await tester.tap(chooseButton);
      await tester.pumpAndSettle();

      expect(
        find.text('Photo selected from device'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Profile Photo can be removed',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfilePhotoScreen(),
        ),
      );

      final cameraButton = find.byKey(
        const Key('takePhotoButton'),
      );

      await tester.tap(cameraButton);
      await tester.pumpAndSettle();

      final removeButton = find.byKey(
        const Key('removePhotoButton'),
      );

      await tester.ensureVisible(removeButton);
      await tester.pumpAndSettle();

      await tester.tap(removeButton);
      await tester.pumpAndSettle();

      expect(
        find.text('No profile photo selected'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Profile Photo clearly states photo visibility',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfilePhotoScreen(),
        ),
      );

      expect(
        find.byKey(
          const Key('profilePhotoPrivacyNotice'),
        ),
        findsOneWidget,
      );

      expect(
        find.textContaining(
          'visible to other',
        ),
        findsOneWidget,
      );
    },
  );
}
