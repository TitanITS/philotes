import '../../models/compatibility/suggested_member.dart';
import '../../models/messages/message_thread.dart';
import '../../models/onboarding_profile_data.dart';

abstract class MessageService {
  const MessageService();

  List<MessageThread> threads(OnboardingProfileData currentMember);

  List<SuggestedMember> messageableFriends(OnboardingProfileData currentMember);

  SuggestedMember? friendById(
    String memberId,
    OnboardingProfileData currentMember,
  );

  void markThreadRead(String threadId);

  void markThreadUnread(String threadId);
}
