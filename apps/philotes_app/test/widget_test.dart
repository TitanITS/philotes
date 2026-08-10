import 'package:flutter_test/flutter_test.dart';

import 'package:philotes/app.dart';

void main() {
  testWidgets(
    'Philotes onboarding reaches Community Standards',
    (WidgetTester tester) async {
      await tester.pumpWidget(const PhilotesApp());

      expect(find.text('PHILOTES'), findsOneWidget);
      expect(find.text('Join the Community'), findsOneWidget);

      final joinButton = find.text('Join the Community');

      await tester.ensureVisible(joinButton);
      await tester.pumpAndSettle();

      await tester.tap(joinButton);
      await tester.pumpAndSettle();

      expect(find.text('Before You Join'), findsOneWidget);

      final introContinue = find.text('Continue');

      await tester.ensureVisible(introContinue);
      await tester.pumpAndSettle();

      await tester.tap(introContinue);
      await tester.pumpAndSettle();

      expect(find.text('Community Standards'), findsOneWidget);
      expect(
        find.text('Community Standards Reviewed: 0 of 6'),
        findsOneWidget,
      );

      expect(find.textContaining('Friendship Comes First'), findsOneWidget);
      expect(find.textContaining('Be Yourself'), findsOneWidget);
      expect(
        find.textContaining('Treat People With Respect'),
        findsOneWidget,
      );
      expect(
        find.textContaining('Respect Boundaries and Privacy'),
        findsOneWidget,
      );
      expect(find.textContaining('Put Safety First'), findsOneWidget);
      expect(
        find.textContaining('Help Protect the Community'),
        findsOneWidget,
      );

      final firstStandard =
          find.textContaining('Friendship Comes First');

      await tester.ensureVisible(firstStandard);
      await tester.pumpAndSettle();

      await tester.tap(firstStandard);
      await tester.pumpAndSettle();

      expect(find.text('Reviewed'), findsOneWidget);

      expect(
        find.textContaining('Community Standards Version 1.0'),
        findsOneWidget,
      );
    },
  );
}
