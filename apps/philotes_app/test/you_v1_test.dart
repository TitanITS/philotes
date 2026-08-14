import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:philotes/models/onboarding_profile_data.dart';
import 'package:philotes/screens/app/philotes_shell_screen.dart';

void main() {
  setUp(() {
    final profile = OnboardingProfileData.instance;

    profile.reset();

    profile.firstName = 'Alex';
    profile.displayName = 'Alex';
    profile.introduction =
        'I enjoy good conversation, '
        'live events, and activities '
        'with friends.';

    profile.favoriteInterests = <String>['Movies', 'Dining Out', 'Bowling'];

    profile.selectedInterests = <String>[
      'Movies',
      'Dining Out',
      'Bowling',
      'Technology',
      'Road Trips',
    ];

    profile.friendshipStyles = <String>[
      'One-on-one friendships',
      'Small groups',
    ];

    profile.socialFrequency = "Whenever we're both available";
    profile.planningStyle = 'A little of both';
    profile.interestStyle =
        'A balance of shared interests '
        'and new experiences';
    profile.newActivityComfort = 'Maybe';

    profile.minimumFriendAge = 30;
    profile.maximumFriendAge = 55;

    profile.locationSource = 'device';
    profile.meetingDistance = '25';
    profile.flexibleDiscovery = true;
  });

  Future<void> openYou(WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: PhilotesShellScreen()));

    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('navYou')));

    await tester.pumpAndSettle();
  }

  testWidgets('You navigation opens You V1', (WidgetTester tester) async {
    await openYou(tester);

    expect(find.byKey(const Key('youScreen')), findsOneWidget);

    expect(find.byKey(const Key('youProfileHeroCard')), findsOneWidget);

    expect(find.text('Alex'), findsWidgets);
  });

  testWidgets('View My Profile opens member preview', (
    WidgetTester tester,
  ) async {
    await openYou(tester);

    final button = find.byKey(const Key('viewMyProfileButton'));

    await tester.ensureVisible(button);

    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('myProfilePreviewScreen')), findsOneWidget);

    expect(find.text('Favorites / Like the Most'), findsOneWidget);

    expect(find.text('Friendship Preferences'), findsOneWidget);
  });

  testWidgets('Edit My Profile opens editing hub', (WidgetTester tester) async {
    await openYou(tester);

    final button = find.byKey(const Key('editMyProfileButton'));

    await tester.ensureVisible(button);

    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('editProfileHubScreen')), findsOneWidget);

    expect(find.text('Profile Editing'), findsOneWidget);
  });

  testWidgets('Notifications settings expose email preferences', (
    WidgetTester tester,
  ) async {
    await openYou(tester);

    final tile = find.byKey(const Key('youNotificationsTile'));

    await tester.ensureVisible(tile);

    await tester.tap(tile);
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('notificationsSettingsScreen')),
      findsOneWidget,
    );

    expect(
      find.byKey(const Key('emailNotificationsMasterToggle')),
      findsOneWidget,
    );

    expect(find.byKey(const Key('emailFrequencyDropdown')), findsOneWidget);

    expect(find.byKey(const Key('emailMessagePreviewToggle')), findsOneWidget);
  });

  testWidgets('MFA is optional and has setup destination', (
    WidgetTester tester,
  ) async {
    await openYou(tester);

    final tile = find.byKey(const Key('youMfaTile'));

    await tester.ensureVisible(tile);

    await tester.tap(tile);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('mfaSettingsScreen')), findsOneWidget);

    expect(find.text('Off'), findsOneWidget);

    expect(find.byKey(const Key('setupMfaButton')), findsOneWidget);
  });

  testWidgets('Privacy and safety destinations exist', (
    WidgetTester tester,
  ) async {
    await openYou(tester);

    final privacy = find.byKey(const Key('youPrivacySettingsTile'));

    await tester.ensureVisible(privacy);

    expect(privacy, findsOneWidget);

    expect(find.byKey(const Key('youBlockedMembersTile')), findsOneWidget);

    expect(find.byKey(const Key('youSafetyReportingTile')), findsOneWidget);

    expect(find.byKey(const Key('youCommunityGuidelinesTile')), findsOneWidget);
  });

  testWidgets('Interests V2 exposes clean suggestions and catalog', (
    WidgetTester tester,
  ) async {
    await openYou(tester);

    final tile = find.byKey(const Key('youInterestsTile'));
    await tester.ensureVisible(tile);
    await tester.tap(tile);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('profileInterestsScreen')), findsOneWidget);
    expect(find.byKey(const Key('interestSuggestions')), findsOneWidget);
    expect(find.text('Pilates'), findsOneWidget);
    expect(find.text('Running'), findsOneWidget);

    final viewAll = find.byKey(const Key('viewAllActivitiesButton'));
    await tester.ensureVisible(viewAll);
    await tester.tap(viewAll);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('allActivitiesScreen')), findsOneWidget);
    expect(find.text('Fitness & Wellness'), findsOneWidget);
    expect(find.text('Arts & Culture'), findsOneWidget);
  });

  testWidgets('Interests V2 adds a custom interest', (
    WidgetTester tester,
  ) async {
    await openYou(tester);

    final tile = find.byKey(const Key('youInterestsTile'));
    await tester.ensureVisible(tile);
    await tester.tap(tile);
    await tester.pumpAndSettle();

    final field = find.byKey(const Key('customInterestField'));
    await tester.ensureVisible(field);
    await tester.enterText(field, 'Pottery');
    await tester.tap(find.byKey(const Key('addCustomInterestButton')));
    await tester.pumpAndSettle();

    expect(
      OnboardingProfileData.instance.selectedInterests,
      contains('Pottery'),
    );
  });

  testWidgets('Account actions are present', (WidgetTester tester) async {
    await openYou(tester);

    final delete = find.byKey(const Key('youDeleteAccountTile'));

    await tester.ensureVisible(delete);

    expect(find.byKey(const Key('youSignOutTile')), findsOneWidget);

    expect(find.byKey(const Key('youDeactivateAccountTile')), findsOneWidget);

    expect(delete, findsOneWidget);
  });
}
