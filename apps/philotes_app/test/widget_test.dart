import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:philotes/models/onboarding_profile_data.dart';
import 'package:philotes/screens/onboarding/welcome_to_philotes_screen.dart';

void main() {
  setUp(() {
    final profile =
        OnboardingProfileData.instance;

    profile.reset();

    profile.displayName =
        'Test Friend';
  });

  testWidgets(
    'Welcome screen greets member by display name',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home:
              WelcomeToPhilotesScreen(),
        ),
      );

      expect(
        find.text(
          'Welcome to Philotes, Test Friend!',
        ),
        findsOneWidget,
      );

      expect(
        find.text(
          'Your profile is ready.',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Welcome screen shows three next-step cards',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home:
              WelcomeToPhilotesScreen(),
        ),
      );

      expect(
        find.byKey(
          const Key(
            'discoverPeopleCard',
          ),
        ),
        findsOneWidget,
      );

      expect(
        find.byKey(
          const Key(
            'startConversationsCard',
          ),
        ),
        findsOneWidget,
      );

      expect(
        find.byKey(
          const Key(
            'makePlansTogetherCard',
          ),
        ),
        findsOneWidget,
      );

      expect(
        find.text(
          'Discover People',
        ),
        findsOneWidget,
      );

      expect(
        find.text(
          'Start Conversations',
        ),
        findsOneWidget,
      );

      expect(
        find.text(
          'Make Plans Together',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Welcome screen includes safety reminder',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home:
              WelcomeToPhilotesScreen(),
        ),
      );

      expect(
        find.byKey(
          const Key(
            'welcomeSafetyReminder',
          ),
        ),
        findsOneWidget,
      );

      expect(
        find.text(
          'A Friendly Reminder',
        ),
        findsOneWidget,
      );

      expect(
        find.textContaining(
          'safe public place',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Welcome screen contains Enter Philotes button',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home:
              WelcomeToPhilotesScreen(),
        ),
      );

      final enterButton =
          find.byKey(
        const Key(
          'enterPhilotesButton',
        ),
      );

      await tester.ensureVisible(
        enterButton,
      );

      await tester.pumpAndSettle();

      expect(
        enterButton,
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Enter Philotes shows development completion message',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home:
              WelcomeToPhilotesScreen(),
        ),
      );

      final enterButton =
          find.byKey(
        const Key(
          'enterPhilotesButton',
        ),
      );

      await tester.ensureVisible(
        enterButton,
      );

      await tester.pumpAndSettle();

      await tester.tap(
        enterButton,
      );

      await tester.pumpAndSettle();

      expect(
        find.textContaining(
          'Philotes onboarding complete',
        ),
        findsOneWidget,
      );
    },
  );
}
