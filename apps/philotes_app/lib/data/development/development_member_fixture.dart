import '../../models/onboarding_profile_data.dart';

class DevelopmentMemberFixture {
  const DevelopmentMemberFixture._();

  static void seedMissingProfileData() {
    final profile = OnboardingProfileData.instance;

    if (profile.firstName.trim().isEmpty) {
      profile.firstName = 'Alex';
    }

    if (profile.displayName.trim().isEmpty) {
      profile.displayName = 'Alex';
    }

    if (profile.introduction.trim().isEmpty) {
      profile.introduction =
          'I enjoy good conversation, live events, '
          'trying new restaurants, and getting out '
          'for activities with friends.';
    }

    if (profile.selectedInterests.isEmpty) {
      profile.selectedInterests = <String>[
        'Going to Sporting Events',
        'Movies',
        'Dining Out',
        'Bowling',
        'Live Music',
        'Technology',
        'Road Trips',
        'Museums',
      ];
    }

    if (profile.favoriteInterests.isEmpty) {
      profile.favoriteInterests = <String>[
        'Going to Sporting Events',
        'Movies',
        'Dining Out',
        'Bowling',
        'Live Music',
      ];
    }

    if (profile.friendshipStyles.isEmpty) {
      profile.friendshipStyles = <String>[
        'One-on-one friendships',
        'Small groups',
      ];
    }

    if (profile.minimumFriendAge == 18 &&
        profile.maximumFriendAge == 80) {
      profile.minimumFriendAge = 30;
      profile.maximumFriendAge = 55;
    }

    profile.socialFrequency ??=
        "Whenever we're both available";

    profile.planningStyle ??=
        'A little of both';

    profile.interestStyle ??=
        'A balance of shared interests and new experiences';

    profile.newActivityComfort ??=
        'Maybe';

    profile.locationSource ??=
        'device';

    profile.meetingDistance ??=
        '25';

    if (!profile.photoSelected) {
      profile.photoSelected = true;
      profile.photoSource = 'development';
    }
  }
}
