import '../../models/compatibility/compatibility_level.dart';
import '../../models/compatibility/compatibility_result.dart';
import '../../models/compatibility/suggested_member.dart';
import '../../models/messages/message_thread.dart';
import '../../models/onboarding_profile_data.dart';
import '../compatibility/development_compatibility_service.dart';
import 'message_service.dart';

class DevelopmentMessageService
    extends MessageService {
  const DevelopmentMessageService({
    this.compatibilityService =
        const DevelopmentCompatibilityService(),
  });

  final DevelopmentCompatibilityService
      compatibilityService;

  //
  // Development-only read-state overrides.
  //
  // Production read state will eventually
  // come from the authenticated backend.
  //
  static final Map<String, int>
      _unreadOverrides =
      <String, int>{};

  @override
  void markThreadRead(
    String threadId,
  ) {
    _unreadOverrides[threadId] = 0;
  }

  @override
  void markThreadUnread(
    String threadId,
  ) {
    _unreadOverrides[threadId] = 1;
  }

  int _unreadCount(
    String threadId,
    int defaultCount,
  ) {
    return _unreadOverrides[
            threadId] ??
        defaultCount;
  }

  static const SuggestedMember _morgan =
      SuggestedMember(
    id: 'dev-morgan',
    displayName: 'Morgan',
    initials: 'M',
    distanceMiles: 14,
    introduction:
        'I enjoy local events, casual dinners, '
        'movies, and getting together with '
        'friends for weekend activities.',
    compatibility: CompatibilityResult(
      score: 81,
      level: CompatibilityLevel.strong,
      sharedFavoriteInterests: <String>[
        'Dining Out',
        'Movies',
      ],
      sharedInterests: <String>[
        'Local Events',
        'Live Music',
        'Road Trips',
        'Bowling',
      ],
      reasons: <String>[
        '2 shared Like the Most interests',
        '4 additional shared interests',
        'Compatible social pace',
        'Similar planning style',
      ],
      socialPaceAlignment: 'Strong',
      friendshipStyleAlignment: 'Strong',
      planningStyleAlignment: 'Strong',
      newActivityAlignment: 'Moderate',
      suggestedActivities: <String>[
        'Dining Out',
        'Movies',
        'Local Events',
        'Bowling',
      ],
    ),
  );

  List<SuggestedMember> _friends(
    OnboardingProfileData currentMember,
  ) {
    final discovered =
        compatibilityService.suggestedMembers(
      currentMember,
    );

    final jordan = discovered.firstWhere(
      (member) => member.id == 'dev-jordan',
    );

    final taylor = discovered.firstWhere(
      (member) => member.id == 'dev-taylor',
    );

    return <SuggestedMember>[
      jordan,
      taylor,
      _morgan,
    ];
  }

  MessageParticipant _self(
    OnboardingProfileData currentMember,
  ) {
    final name =
        currentMember.displayName.trim().isEmpty
            ? 'You'
            : currentMember.displayName.trim();

    return MessageParticipant(
      id: 'self',
      displayName: name,
      initials:
          name.isEmpty
              ? 'Y'
              : name
                  .substring(0, 1)
                  .toUpperCase(),
      isCurrentUser: true,
    );
  }

  MessageParticipant _participant(
    SuggestedMember member,
  ) {
    return MessageParticipant(
      id: member.id,
      displayName: member.displayName,
      initials: member.initials,
    );
  }

  @override
  List<SuggestedMember> messageableFriends(
    OnboardingProfileData currentMember,
  ) {
    return _friends(currentMember);
  }

  @override
  SuggestedMember? friendById(
    String memberId,
    OnboardingProfileData currentMember,
  ) {
    for (
      final friend
          in _friends(currentMember)
    ) {
      if (friend.id == memberId) {
        return friend;
      }
    }

    return null;
  }

  @override
  List<MessageThread> threads(
    OnboardingProfileData currentMember,
  ) {
    final friends =
        _friends(currentMember);

    final jordan =
        friends.firstWhere(
      (member) =>
          member.id == 'dev-jordan',
    );

    final taylor =
        friends.firstWhere(
      (member) =>
          member.id == 'dev-taylor',
    );

    final morgan =
        friends.firstWhere(
      (member) =>
          member.id == 'dev-morgan',
    );

    final self =
        _self(currentMember);

    return <MessageThread>[
      MessageThread(
        id: 'thread-jordan',
        type:
            MessageThreadType.direct,
        title: jordan.displayName,
        participants:
            <MessageParticipant>[
          self,
          _participant(jordan),
        ],
        unreadCount: _unreadCount(
          'thread-jordan',
          2,
        ),
        latestActivity:
            DateTime(
          2026,
          8,
          13,
          16,
          42,
        ),
        messages:
            <PhilotesMessage>[
          PhilotesMessage(
            id: 'jordan-1',
            senderId: jordan.id,
            text:
                'Are you free Saturday?',
            sentAt:
                DateTime(
              2026,
              8,
              13,
              16,
              28,
            ),
          ),
          PhilotesMessage(
            id: 'jordan-2',
            senderId: 'self',
            text: 'I should be.',
            sentAt:
                DateTime(
              2026,
              8,
              13,
              16,
              31,
            ),
          ),
          PhilotesMessage(
            id: 'jordan-3',
            senderId: jordan.id,
            text:
                'Want to go axe throwing?',
            sentAt:
                DateTime(
              2026,
              8,
              13,
              16,
              37,
            ),
          ),
          PhilotesMessage(
            id: 'jordan-4',
            senderId: 'self',
            text:
                'That sounds good. '
                'Saturday works.',
            sentAt:
                DateTime(
              2026,
              8,
              13,
              16,
              42,
            ),
          ),
        ],
      ),

      MessageThread(
        id:
            'thread-bowling-night',
        type:
            MessageThreadType.group,
        title: 'Bowling Night',
        participants:
            <MessageParticipant>[
          self,
          _participant(jordan),
          _participant(taylor),
          _participant(morgan),
        ],
        unreadCount: _unreadCount(
          'thread-bowling-night',
          1,
        ),
        latestActivity:
            DateTime(
          2026,
          8,
          13,
          14,
          18,
        ),
        messages:
            <PhilotesMessage>[
          PhilotesMessage(
            id: 'bowling-1',
            senderId: jordan.id,
            text: 'How about 7?',
            sentAt:
                DateTime(
              2026,
              8,
              13,
              14,
              5,
            ),
          ),
          PhilotesMessage(
            id: 'bowling-2',
            senderId: taylor.id,
            text:
                'Works for me. '
                'I will reserve '
                'the second lane.',
            sentAt:
                DateTime(
              2026,
              8,
              13,
              14,
              18,
            ),
          ),
        ],
      ),

      MessageThread(
        id: 'thread-morgan',
        type:
            MessageThreadType.direct,
        title: morgan.displayName,
        participants:
            <MessageParticipant>[
          self,
          _participant(morgan),
        ],
        unreadCount: _unreadCount(
          'thread-morgan',
          0,
        ),
        latestActivity:
            DateTime(
          2026,
          8,
          13,
          11,
          4,
        ),
        messages:
            <PhilotesMessage>[
          PhilotesMessage(
            id: 'morgan-1',
            senderId: morgan.id,
            text:
                'Great, see you then!',
            sentAt:
                DateTime(
              2026,
              8,
              13,
              11,
              4,
            ),
          ),
        ],
      ),

      MessageThread(
        id: 'thread-taylor',
        type:
            MessageThreadType.direct,
        title: taylor.displayName,
        participants:
            <MessageParticipant>[
          self,
          _participant(taylor),
        ],
        unreadCount: _unreadCount(
          'thread-taylor',
          0,
        ),
        latestActivity:
            DateTime(
          2026,
          8,
          12,
          20,
          31,
        ),
        messages:
            <PhilotesMessage>[
          PhilotesMessage(
            id: 'taylor-1',
            senderId: taylor.id,
            text:
                'I will check and '
                'let you know.',
            sentAt:
                DateTime(
              2026,
              8,
              12,
              20,
              31,
            ),
          ),
        ],
      ),
    ];
  }
}
