import 'compatibility_level.dart';

class CompatibilityResult {
  const CompatibilityResult({
    required this.score,
    required this.level,
    required this.sharedFavoriteInterests,
    required this.sharedInterests,
    required this.reasons,
    required this.socialPaceAlignment,
    required this.friendshipStyleAlignment,
    required this.planningStyleAlignment,
    required this.newActivityAlignment,
    required this.suggestedActivities,
  });

  final int score;
  final CompatibilityLevel level;

  final List<String> sharedFavoriteInterests;
  final List<String> sharedInterests;

  final List<String> reasons;

  final String socialPaceAlignment;
  final String friendshipStyleAlignment;
  final String planningStyleAlignment;
  final String newActivityAlignment;

  final List<String> suggestedActivities;
}
