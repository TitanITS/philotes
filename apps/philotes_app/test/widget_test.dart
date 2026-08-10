import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:philotes/models/onboarding_profile_data.dart';
import 'package:philotes/screens/onboarding/review_profile_screen.dart';

void main() {
  setUp(() {
    final profile =
        OnboardingProfileData.instance;

    profile.reset();

    profile.displayName =
        'Test Friend';

    profile.introduction =
        'I enjoy movies, bowling, technology, '
        'and meeting good people.';

    profile.selectedInterests = <String>[
      'Movies',
      'Bowling',
      'Technology',
      'Going to Sporting Events',
      'Road Trips',
      'Golf',
      'Museums',
      'Photography',
      'Cooking',
    ];

    profile.favoriteInterests = <String>[
      'Movies',
      'Bowling',
      'Technology',
      'Going to Sporting Events',
      'Road Trips',
    ];

    profile.friendshipStyles = <String>[
      'One-on-one friendships',
      'Small groups',
    ];

    profile.socialFrequency =
        'A few times a month';

    profile.planningStyle =
        'A little of both';

    profile.interestStyle =
        'A balance of shared interests and new experiences';

    profile.newActivityComfort =
        'Maybe';

    profile.minimumFriendAge = 30;
    profile.maximumFriendAge = 55;

    profile.locationSource = 'zip';
    profile.zipCode = '27701';

    profile.meetingDistance = '25';

    profile.onlineFriendships = true;

    profile.photoSelected = true;
    profile.photoSource = 'device';
  });

  testWidgets(
    'Review Profile shows profile photo at the top',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ReviewProfileScreen(),
        ),
      );

      expect(
        find.text(
          'Review Your Profile',
        ),
        findsOneWidget,
      );

      expect(
        find.byKey(
          const Key(
            'reviewProfilePhoto',
          ),
        ),
        findsOneWidget,
      );

      expect(
        find.text(
          'Test Friend',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Review Profile shows favorite interests',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ReviewProfileScreen(),
        ),
      );

      expect(
        find.byKey(
          const Key(
            'favoriteInterestsList',
          ),
        ),
        findsOneWidget,
      );

      expect(
        find.text('Movies'),
        findsOneWidget,
      );

      expect(
        find.text('Bowling'),
        findsOneWidget,
      );

      expect(
        find.text('Technology'),
        findsOneWidget,
      );

      expect(
        find.text(
          'Going to Sporting Events',
        ),
        findsOneWidget,
      );

      expect(
        find.text('Road Trips'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Review Profile shows non-favorite selected interests',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ReviewProfileScreen(),
        ),
      );

      final otherInterestsList =
          find.byKey(
        const Key(
          'otherInterestsList',
        ),
      );

      await tester.ensureVisible(
        otherInterestsList,
      );

      await tester.pumpAndSettle();

      expect(
        find.text(
          'More of My Interests',
        ),
        findsOneWidget,
      );

      expect(
        find.text('Golf'),
        findsOneWidget,
      );

      expect(
        find.text('Museums'),
        findsOneWidget,
      );

      expect(
        find.text('Photography'),
        findsOneWidget,
      );

      expect(
        find.text('Cooking'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Favorite interests are not duplicated in additional interests',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ReviewProfileScreen(),
        ),
      );

      expect(
        find.text('Movies'),
        findsOneWidget,
      );

      expect(
        find.text('Golf'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Review Profile shows friendship preferences',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ReviewProfileScreen(),
        ),
      );

      expect(
        find.text('30 - 55'),
        findsOneWidget,
      );

      expect(
        find.textContaining(
          '25 miles',
        ),
        findsOneWidget,
      );

      expect(
        find.text(
          'A few times a month',
        ),
        findsOneWidget,
      );

      expect(
        find.text(
          'A little of both',
        ),
        findsOneWidget,
      );

      expect(
        find.text(
          'Maybe',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Review Profile shows privacy information',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ReviewProfileScreen(),
        ),
      );

      final privacyCard = find.byKey(
        const Key(
          'reviewPrivacyCard',
        ),
      );

      await tester.ensureVisible(
        privacyCard,
      );

      await tester.pumpAndSettle();

      expect(
        find.text(
          'Your email address',
        ),
        findsOneWidget,
      );

      expect(
        find.text(
          'Your full last name',
        ),
        findsOneWidget,
      );

      expect(
        find.text(
          'Your exact date of birth',
        ),
        findsOneWidget,
      );

      expect(
        find.text(
          'Your ZIP code or exact location',
        ),
        findsOneWidget,
      );

      expect(
        find.text(
          'Your password or account credentials',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Review Profile contains completion control',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ReviewProfileScreen(),
        ),
      );

      expect(
        find.byKey(
          const Key(
            'completeProfileButton',
          ),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Additional interests section hides when there are no extras',
    (WidgetTester tester) async {
      final profile =
          OnboardingProfileData.instance;

      profile.selectedInterests = <String>[
        'Movies',
        'Bowling',
      ];

      profile.favoriteInterests = <String>[
        'Movies',
        'Bowling',
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: ReviewProfileScreen(),
        ),
      );

      expect(
        find.text(
          'More of My Interests',
        ),
        findsNothing,
      );

      expect(
        find.byKey(
          const Key(
            'otherInterestsList',
          ),
        ),
        findsNothing,
      );
    },
  );
}
