import '../../models/compatibility/compatibility_level.dart';
import '../../models/compatibility/compatibility_result.dart';
import '../../models/compatibility/suggested_member.dart';
import '../../models/onboarding_profile_data.dart';
import 'compatibility_service.dart';

class DevelopmentCompatibilityService extends CompatibilityService {
  const DevelopmentCompatibilityService();

  static const List<SuggestedMember> _developmentMembers = <SuggestedMember>[
    SuggestedMember(
      id: 'dev-jordan',
      displayName: 'Jordan',
      initials: 'J',
      distanceMiles: 32,
      introduction:
          'I enjoy getting out for activities, '
          'trying new places, attending sporting events, '
          'and spending time with a small group of friends.',
      compatibility: CompatibilityResult(
        score: 89,
        level: CompatibilityLevel.strong,
        sharedFavoriteInterests: <String>[
          'Going to Sporting Events',
          'Movies',
          'Axe Throwing',
        ],
        sharedInterests: <String>[
          'Dining Out',
          'Bowling',
          'Live Music',
          'Road Trips',
          'Museums',
          'Technology',
          'Local Events',
        ],
        reasons: <String>[
          '3 shared Like the Most interests',
          '7 additional shared interests',
          'Flexible social schedules',
          'Similar friendship style',
          'Compatible planning style',
        ],
        socialPaceAlignment: 'Strong',
        friendshipStyleAlignment: 'Strong',
        planningStyleAlignment: 'Strong',
        newActivityAlignment: 'Moderate',
        suggestedActivities: <String>[
          'Axe Throwing',
          'Sporting Events',
          'Movies',
          'Dining Out',
        ],
      ),
    ),
    SuggestedMember(
      id: 'dev-taylor',
      displayName: 'Taylor',
      initials: 'T',
      distanceMiles: 18,
      introduction:
          'I like live music, casual outings, '
          'weekend road trips, and discovering '
          'new activities with friends.',
      compatibility: CompatibilityResult(
        score: 76,
        level: CompatibilityLevel.moderate,
        sharedFavoriteInterests: <String>['Bowling', 'Live Music'],
        sharedInterests: <String>[
          'Road Trips',
          'Movies',
          'Dining Out',
          'Local Events',
          'Museums',
        ],
        reasons: <String>[
          '2 shared Like the Most interests',
          '5 additional shared interests',
          'Compatible social pace',
          'Some overlap in friendship style',
        ],
        socialPaceAlignment: 'Strong',
        friendshipStyleAlignment: 'Moderate',
        planningStyleAlignment: 'Moderate',
        newActivityAlignment: 'Strong',
        suggestedActivities: <String>[
          'Bowling',
          'Live Music',
          'Road Trips',
          'Dining Out',
        ],
      ),
    ),
    SuggestedMember(
      id: 'dev-casey',
      displayName: 'Casey',
      initials: 'C',
      distanceMiles: 11,
      introduction:
          'I enjoy technology, museums, movies, '
          'and quieter social activities.',
      compatibility: CompatibilityResult(
        score: 58,
        level: CompatibilityLevel.limited,
        sharedFavoriteInterests: <String>['Movies'],
        sharedInterests: <String>['Technology', 'Museums', 'Dining Out'],
        reasons: <String>[
          '1 shared Like the Most interest',
          '3 additional shared interests',
          'Different preferred social pace',
        ],
        socialPaceAlignment: 'Limited',
        friendshipStyleAlignment: 'Moderate',
        planningStyleAlignment: 'Moderate',
        newActivityAlignment: 'Moderate',
        suggestedActivities: <String>['Movies', 'Museums', 'Dining Out'],
      ),
    ),
  ];

  @override
  List<SuggestedMember> suggestedMembers(OnboardingProfileData currentMember) {
    // Development-only compatibility results.
    //
    // No production scoring formula is implied by
    // these values. The frontend consumes this
    // service contract so a backend implementation
    // can replace it later.
    return _developmentMembers;
  }

  @override
  SuggestedMember? memberById(
    String memberId,
    OnboardingProfileData currentMember,
  ) {
    for (final member in _developmentMembers) {
      if (member.id == memberId) {
        return member;
      }
    }

    return null;
  }
}
