import '../../models/compatibility/suggested_member.dart';
import '../../models/onboarding_profile_data.dart';

abstract class CompatibilityService {
  const CompatibilityService();

  List<SuggestedMember> suggestedMembers(
    OnboardingProfileData currentMember,
  );

  SuggestedMember? memberById(
    String memberId,
    OnboardingProfileData currentMember,
  );
}
