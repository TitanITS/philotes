from pathlib import Path
from datetime import datetime


SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = SCRIPT_DIR.parent.parent
APP_ROOT = PROJECT_ROOT / "apps" / "philotes_app"
LIB_ROOT = APP_ROOT / "lib"
TEST_ROOT = APP_ROOT / "test"

SERVICE_FILE = (
    LIB_ROOT
    / "services"
    / "messages"
    / "message_service.dart"
)

DEV_SERVICE_FILE = (
    LIB_ROOT
    / "services"
    / "messages"
    / "development_message_service.dart"
)

MESSAGES_FILE = (
    LIB_ROOT
    / "screens"
    / "messages"
    / "messages_screen.dart"
)

CONVERSATION_FILE = (
    LIB_ROOT
    / "screens"
    / "messages"
    / "conversation_screen.dart"
)

TEST_FILE = (
    TEST_ROOT
    / "messages_v1_test.dart"
)

REPORT_FILE = (
    SCRIPT_DIR
    / "developerpatchscript_report.txt"
)


SERVICE_CONTENT = r"""import '../../models/compatibility/suggested_member.dart';
import '../../models/messages/message_thread.dart';
import '../../models/onboarding_profile_data.dart';

abstract class MessageService {
  const MessageService();

  List<MessageThread> threads(
    OnboardingProfileData currentMember,
  );

  List<SuggestedMember> messageableFriends(
    OnboardingProfileData currentMember,
  );

  SuggestedMember? friendById(
    String memberId,
    OnboardingProfileData currentMember,
  );

  void markThreadRead(
    String threadId,
  );

  void markThreadUnread(
    String threadId,
  );
}
"""


DEV_SERVICE_CONTENT = r"""import '../../models/compatibility/compatibility_level.dart';
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
"""


MESSAGES_CONTENT = r"""import 'package:flutter/material.dart';

import '../../models/messages/message_thread.dart';
import '../../models/onboarding_profile_data.dart';
import '../../services/messages/development_message_service.dart';
import '../../services/messages/message_service.dart';
import '../../theme/philotes_colors.dart';
import '../../theme/philotes_design.dart';
import 'conversation_screen.dart';
import 'new_message_screen.dart';

class MessagesScreen
    extends StatefulWidget {
  const MessagesScreen({
    super.key,
    this.messageService =
        const DevelopmentMessageService(),
  });

  final MessageService messageService;

  @override
  State<MessagesScreen> createState() =>
      _MessagesScreenState();
}

class _MessagesScreenState
    extends State<MessagesScreen> {
  final TextEditingController
      _searchController =
      TextEditingController();

  final Set<String>
      _selectedThreadIds =
      <String>{};

  String _query = '';
  bool _selectionMode = false;

  OnboardingProfileData get _profile =>
      OnboardingProfileData.instance;

  List<MessageThread> get _threads {
    final values =
        widget.messageService
            .threads(_profile)
            .where(_matchesSearch)
            .toList();

    //
    // Latest activity always controls
    // conversation order.
    //
    values.sort(
      (a, b) =>
          b.latestActivity.compareTo(
        a.latestActivity,
      ),
    );

    return values;
  }

  bool _matchesSearch(
    MessageThread thread,
  ) {
    final query =
        _query.trim().toLowerCase();

    if (query.isEmpty) {
      return true;
    }

    return thread.title
            .toLowerCase()
            .contains(query) ||
        thread.latestPreview
            .toLowerCase()
            .contains(query);
  }

  void _openThread(
    MessageThread thread,
  ) {
    widget.messageService
        .markThreadRead(
      thread.id,
    );

    setState(() {
      thread.unreadCount = 0;
    });

    Navigator.of(context)
        .push(
      MaterialPageRoute<void>(
        builder: (context) =>
            ConversationScreen(
          thread: thread,
          messageService:
              widget.messageService,
        ),
      ),
    )
        .then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _createMessage() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) =>
            NewMessageScreen(
          messageService:
              widget.messageService,
        ),
      ),
    );
  }

  void _enterSelectionMode({
    MessageThread? selectedThread,
  }) {
    setState(() {
      _selectionMode = true;

      if (selectedThread != null) {
        _selectedThreadIds.add(
          selectedThread.id,
        );
      }
    });
  }

  void _cancelSelectionMode() {
    setState(() {
      _selectionMode = false;
      _selectedThreadIds.clear();
    });
  }

  void _toggleSelection(
    MessageThread thread,
  ) {
    setState(() {
      if (
        _selectedThreadIds.contains(
          thread.id,
        )
      ) {
        _selectedThreadIds.remove(
          thread.id,
        );
      } else {
        _selectedThreadIds.add(
          thread.id,
        );
      }

      if (_selectedThreadIds.isEmpty) {
        _selectionMode = false;
      }
    });
  }

  void _toggleSelectAll() {
    final visibleIds =
        _threads
            .map(
              (thread) =>
                  thread.id,
            )
            .toSet();

    final allVisibleSelected =
        visibleIds.isNotEmpty &&
        visibleIds.every(
          _selectedThreadIds.contains,
        );

    setState(() {
      if (allVisibleSelected) {
        _selectedThreadIds
            .removeAll(
          visibleIds,
        );

        if (
          _selectedThreadIds.isEmpty
        ) {
          _selectionMode = false;
        }
      } else {
        _selectionMode = true;

        _selectedThreadIds
            .addAll(
          visibleIds,
        );
      }
    });
  }

  void _markSelectedRead() {
    if (_selectedThreadIds.isEmpty) {
      return;
    }

    for (
      final threadId
          in _selectedThreadIds
    ) {
      widget.messageService
          .markThreadRead(
        threadId,
      );
    }

    _cancelSelectionMode();
  }

  void _markSelectedUnread() {
    if (_selectedThreadIds.isEmpty) {
      return;
    }

    for (
      final threadId
          in _selectedThreadIds
    ) {
      widget.messageService
          .markThreadUnread(
        threadId,
      );
    }

    _cancelSelectionMode();
  }

  String _timestampLabel(
    DateTime value,
  ) {
    const months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final now = DateTime.now();

    final sameDate =
        now.year == value.year &&
        now.month == value.month &&
        now.day == value.day;

    final yesterday =
        DateTime(
          now.year,
          now.month,
          now.day,
        ).subtract(
          const Duration(days: 1),
        );

    final valueDate =
        DateTime(
      value.year,
      value.month,
      value.day,
    );

    final minute =
        value.minute
            .toString()
            .padLeft(2, '0');

    final hour =
        value.hour == 0
            ? 12
            : value.hour > 12
                ? value.hour - 12
                : value.hour;

    final period =
        value.hour >= 12
            ? 'PM'
            : 'AM';

    final time =
        '$hour:$minute $period';

    if (sameDate) {
      return 'Today â€¢ $time';
    }

    if (valueDate == yesterday) {
      return 'Yesterday â€¢ $time';
    }

    return '${months[value.month - 1]} '
        '${value.day} â€¢ $time';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final threads = _threads;

    final visibleIds =
        threads
            .map(
              (thread) =>
                  thread.id,
            )
            .toSet();

    final allVisibleSelected =
        visibleIds.isNotEmpty &&
        visibleIds.every(
          _selectedThreadIds.contains,
        );

    return LayoutBuilder(
      builder: (
        BuildContext context,
        BoxConstraints constraints,
      ) {
        final wide =
            constraints.maxWidth >=
            PhilotesDesign
                .wideBreakpoint;

        return SingleChildScrollView(
          key: const Key(
            'messagesScreen',
          ),
          padding:
              EdgeInsets.fromLTRB(
            wide
                ? PhilotesDesign
                    .widePadding
                : PhilotesDesign
                    .mobilePadding,
            24,
            wide
                ? PhilotesDesign
                    .widePadding
                : PhilotesDesign
                    .mobilePadding,
            40,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(
                maxWidth:
                    PhilotesDesign
                        .contentMaxWidth,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .stretch,
                children: [
                  if (_selectionMode)
                    _SelectionHeader(
                      selectedCount:
                          _selectedThreadIds
                              .length,
                      allVisibleSelected:
                          allVisibleSelected,
                      onCancel:
                          _cancelSelectionMode,
                      onToggleSelectAll:
                          _toggleSelectAll,
                      onMarkRead:
                          _markSelectedRead,
                      onMarkUnread:
                          _markSelectedUnread,
                    )
                  else ...[
                    Row(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Text(
                                'Messages',
                                style:
                                    TextStyle(
                                  color:
                                      PhilotesColors
                                          .navy,
                                  fontSize: 30,
                                  fontWeight:
                                      FontWeight
                                          .w800,
                                ),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                'Your conversations '
                                'with Philotes friends.',
                                style:
                                    TextStyle(
                                  color:
                                      PhilotesColors
                                          .silver,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),

                        PopupMenuButton<String>(
                          key: const Key(
                            'messagesOptionsMenu',
                          ),
                          icon: const Icon(
                            Icons.more_vert,
                            color:
                                PhilotesColors
                                    .navy,
                          ),
                          onSelected:
                              (value) {
                            if (
                              value ==
                              'select'
                            ) {
                              _enterSelectionMode();
                            }
                          },
                          itemBuilder:
                              (context) =>
                                  const [
                            PopupMenuItem<
                                String>(
                              value: 'select',
                              child: Text(
                                'Select '
                                'Conversations',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 24,
                    ),

                    LayoutBuilder(
                      builder: (
                        BuildContext context,
                        BoxConstraints inner,
                      ) {
                        final stacked =
                            inner.maxWidth <
                            620;

                        final search =
                            TextField(
                          key: const Key(
                            'messageSearchField',
                          ),
                          controller:
                              _searchController,
                          onChanged:
                              (value) {
                            setState(() {
                              _query =
                                  value;
                            });
                          },
                          decoration:
                              InputDecoration(
                            hintText:
                                'Search messages...',
                            prefixIcon:
                                const Icon(
                              Icons.search,
                              color:
                                  PhilotesColors
                                      .gold,
                            ),
                            filled: true,
                            fillColor:
                                Colors.white,
                            enabledBorder:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                PhilotesDesign
                                    .cardRadius,
                              ),
                              borderSide:
                                  const BorderSide(
                                color:
                                    PhilotesColors
                                        .gold,
                                width: 1.4,
                              ),
                            ),
                            focusedBorder:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                PhilotesDesign
                                    .cardRadius,
                              ),
                              borderSide:
                                  const BorderSide(
                                color:
                                    PhilotesColors
                                        .navy,
                                width: 1.8,
                              ),
                            ),
                          ),
                        );

                        final create =
                            FilledButton
                                .icon(
                          key: const Key(
                            'createMessageButton',
                          ),
                          onPressed:
                              _createMessage,
                          style:
                              FilledButton
                                  .styleFrom(
                            backgroundColor:
                                PhilotesColors
                                    .navy,
                            foregroundColor:
                                Colors.white,
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal:
                                  18,
                              vertical: 15,
                            ),
                          ),
                          icon:
                              const Icon(
                            Icons.add,
                            size: 18,
                          ),
                          label:
                              const Text(
                            'Create Message',
                            style:
                                TextStyle(
                              fontWeight:
                                  FontWeight
                                      .w700,
                            ),
                          ),
                        );

                        if (stacked) {
                          return Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .stretch,
                            children: [
                              search,
                              const SizedBox(
                                height: 12,
                              ),
                              create,
                            ],
                          );
                        }

                        return Row(
                          children: [
                            Expanded(
                              child: search,
                            ),
                            const SizedBox(
                              width: 14,
                            ),
                            create,
                          ],
                        );
                      },
                    ),
                  ],

                  const SizedBox(height: 30),

                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 22,
                        decoration:
                            BoxDecoration(
                          color:
                              PhilotesColors
                                  .gold,
                          borderRadius:
                              BorderRadius
                                  .circular(4),
                        ),
                      ),

                      const SizedBox(width: 9),

                      const Expanded(
                        child: Text(
                          'Recent Conversations',
                          style: TextStyle(
                            color:
                                PhilotesColors
                                    .navy,
                            fontSize: 18,
                            fontWeight:
                                FontWeight
                                    .w800,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  if (threads.isEmpty)
                    Container(
                      key: const Key(
                        'messageNoResults',
                      ),
                      padding:
                          const EdgeInsets
                              .all(22),
                      decoration:
                          PhilotesDesign
                              .secondaryCardDecoration(),
                      child: Text(
                        'No conversations '
                        'match your search.',
                        textAlign:
                            TextAlign.center,
                        style:
                            PhilotesDesign
                                .supportingText,
                      ),
                    )
                  else
                    Column(
                      children: [
                        for (
                          var index = 0;
                          index <
                              threads.length;
                          index++
                        ) ...[
                          _ConversationCard(
                            thread:
                                threads[index],
                            timestamp:
                                _timestampLabel(
                              threads[index]
                                  .latestActivity,
                            ),
                            selectionMode:
                                _selectionMode,
                            selected:
                                _selectedThreadIds
                                    .contains(
                              threads[index]
                                  .id,
                            ),
                            onOpen: () {
                              if (
                                _selectionMode
                              ) {
                                _toggleSelection(
                                  threads[
                                      index],
                                );
                              } else {
                                _openThread(
                                  threads[
                                      index],
                                );
                              }
                            },
                            onLongPress: () {
                              if (
                                !_selectionMode
                              ) {
                                _enterSelectionMode(
                                  selectedThread:
                                      threads[
                                          index],
                                );
                              }
                            },
                          ),

                          if (
                            index <
                            threads.length - 1
                          )
                            const SizedBox(
                              height: 12,
                            ),
                        ],
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}


class _SelectionHeader
    extends StatelessWidget {
  const _SelectionHeader({
    required this.selectedCount,
    required this.allVisibleSelected,
    required this.onCancel,
    required this.onToggleSelectAll,
    required this.onMarkRead,
    required this.onMarkUnread,
  });

  final int selectedCount;
  final bool allVisibleSelected;
  final VoidCallback onCancel;
  final VoidCallback onToggleSelectAll;
  final VoidCallback onMarkRead;
  final VoidCallback onMarkUnread;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key(
        'messageSelectionToolbar',
      ),
      padding:
          const EdgeInsets.all(16),
      decoration:
          PhilotesDesign
              .primaryCardDecoration(),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '$selectedCount selected',
                  style:
                      const TextStyle(
                    color:
                        PhilotesColors.navy,
                    fontSize: 20,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ),

              TextButton(
                key: const Key(
                  'cancelMessageSelectionButton',
                ),
                onPressed: onCancel,
                child: const Text(
                  'Cancel',
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              TextButton.icon(
                key: const Key(
                  'selectAllMessagesButton',
                ),
                onPressed:
                    onToggleSelectAll,
                icon: Icon(
                  allVisibleSelected
                      ? Icons
                          .check_box
                      : Icons
                          .check_box_outline_blank,
                  color:
                      PhilotesColors.gold,
                ),
                label: Text(
                  allVisibleSelected
                      ? 'Clear All'
                      : 'Select All',
                ),
              ),

              const Spacer(),
            ],
          ),

          const SizedBox(height: 8),

          LayoutBuilder(
            builder: (
              BuildContext context,
              BoxConstraints constraints,
            ) {
              final stacked =
                  constraints.maxWidth <
                  420;

              final markRead =
                  OutlinedButton.icon(
                key: const Key(
                  'bulkMarkReadButton',
                ),
                onPressed:
                    selectedCount == 0
                        ? null
                        : onMarkRead,
                icon: const Icon(
                  Icons
                      .mark_email_read_outlined,
                  size: 18,
                ),
                label:
                    const Text(
                  'Mark Read',
                ),
                style:
                    OutlinedButton
                        .styleFrom(
                  foregroundColor:
                      PhilotesColors
                          .navy,
                  side:
                      const BorderSide(
                    color:
                        PhilotesColors
                            .gold,
                    width: 1.3,
                  ),
                  padding:
                      const EdgeInsets
                          .symmetric(
                    vertical: 13,
                  ),
                ),
              );

              final markUnread =
                  FilledButton.icon(
                key: const Key(
                  'bulkMarkUnreadButton',
                ),
                onPressed:
                    selectedCount == 0
                        ? null
                        : onMarkUnread,
                icon: const Icon(
                  Icons
                      .mark_email_unread_outlined,
                  size: 18,
                ),
                label:
                    const Text(
                  'Mark Unread',
                ),
                style:
                    FilledButton
                        .styleFrom(
                  backgroundColor:
                      PhilotesColors
                          .navy,
                  foregroundColor:
                      Colors.white,
                  padding:
                      const EdgeInsets
                          .symmetric(
                    vertical: 13,
                  ),
                ),
              );

              if (stacked) {
                return Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .stretch,
                  children: [
                    markRead,
                    const SizedBox(
                      height: 10,
                    ),
                    markUnread,
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(
                    child: markRead,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: markUnread,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}


class _ConversationCard
    extends StatelessWidget {
  const _ConversationCard({
    required this.thread,
    required this.timestamp,
    required this.selectionMode,
    required this.selected,
    required this.onOpen,
    required this.onLongPress,
  });

  final MessageThread thread;
  final String timestamp;
  final bool selectionMode;
  final bool selected;
  final VoidCallback onOpen;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final unread =
        thread.unreadCount > 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: Key(
          'messageThread-${thread.id}',
        ),
        onTap: onOpen,
        onLongPress: onLongPress,
        borderRadius:
            BorderRadius.circular(
          PhilotesDesign.cardRadius,
        ),
        child: Ink(
          padding:
              const EdgeInsets.all(17),
          decoration:
              PhilotesDesign
                  .primaryCardDecoration(),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              if (selectionMode) ...[
                Padding(
                  padding:
                      const EdgeInsets
                          .only(
                    top: 11,
                  ),
                  child: Icon(
                    selected
                        ? Icons
                            .check_box
                        : Icons
                            .check_box_outline_blank,
                    key: Key(
                      'messageCheckbox-${thread.id}',
                    ),
                    color:
                        selected
                            ? PhilotesColors
                                .gold
                            : PhilotesColors
                                .silver,
                    size: 24,
                  ),
                ),

                const SizedBox(
                  width: 12,
                ),
              ],

              Container(
                width: 48,
                height: 48,
                decoration:
                    BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      PhilotesColors
                          .navy,
                  border: Border.all(
                    color:
                        PhilotesColors
                            .gold,
                    width: 1.8,
                  ),
                ),
                alignment:
                    Alignment.center,
                child: Icon(
                  thread.isGroup
                      ? Icons
                          .groups_outlined
                      : Icons
                          .person_outline,
                  color: Colors.white,
                  size: 22,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            thread.title,
                            style:
                                TextStyle(
                              color:
                                  PhilotesColors
                                      .navy,
                              fontSize: 16,
                              fontWeight:
                                  unread
                                      ? FontWeight
                                          .w900
                                      : FontWeight
                                          .w700,
                            ),
                          ),
                        ),

                        if (unread)
                          Container(
                            key: Key(
                              'unreadBadge-${thread.id}',
                            ),
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration:
                                BoxDecoration(
                              color:
                                  PhilotesColors
                                      .navy,
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                18,
                              ),
                              border:
                                  Border.all(
                                color:
                                    PhilotesColors
                                        .gold,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              '${thread.unreadCount} '
                              'unread',
                              style:
                                  const TextStyle(
                                color:
                                    Colors.white,
                                fontSize: 9,
                                fontWeight:
                                    FontWeight
                                        .w700,
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Text(
                      thread.latestPreview,
                      maxLines: 2,
                      overflow:
                          TextOverflow
                              .ellipsis,
                      style: TextStyle(
                        color:
                            unread
                                ? PhilotesColors
                                    .navy
                                : PhilotesColors
                                    .silver,
                        fontSize: 12,
                        fontWeight:
                            unread
                                ? FontWeight
                                    .w600
                                : FontWeight
                                    .w400,
                        height: 1.35,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Row(
                      children: [
                        Text(
                          timestamp,
                          style:
                              const TextStyle(
                            color:
                                PhilotesColors
                                    .silver,
                            fontSize: 10,
                          ),
                        ),

                        const Spacer(),

                        if (!selectionMode)
                          const Icon(
                            Icons
                                .chevron_right,
                            color:
                                PhilotesColors
                                    .gold,
                            size: 19,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
"""


CONVERSATION_CONTENT = r"""import 'package:flutter/material.dart';

import '../../models/compatibility/suggested_member.dart';
import '../../models/messages/message_thread.dart';
import '../../models/onboarding_profile_data.dart';
import '../../screens/members/member_profile_screen.dart';
import '../../services/messages/message_service.dart';
import '../../theme/philotes_colors.dart';
import '../../theme/philotes_design.dart';

class ConversationScreen
    extends StatefulWidget {
  const ConversationScreen({
    super.key,
    required this.thread,
    required this.messageService,
  });

  final MessageThread thread;
  final MessageService messageService;

  @override
  State<ConversationScreen> createState() =>
      _ConversationScreenState();
}

class _ConversationScreenState
    extends State<ConversationScreen> {
  final TextEditingController
      _composerController =
      TextEditingController();

  late List<PhilotesMessage>
      _messages;

  OnboardingProfileData get _profile =>
      OnboardingProfileData.instance;

  @override
  void initState() {
    super.initState();

    _messages =
        List<PhilotesMessage>.from(
      widget.thread.messages,
    );

    widget.messageService.markThreadRead(
      widget.thread.id,
    );

    widget.thread.unreadCount = 0;
  }

  @override
  void dispose() {
    _composerController.dispose();
    super.dispose();
  }

  MessageParticipant? get _otherParticipant {
    if (!widget.thread.isDirect) {
      return null;
    }

    for (
      final participant
          in widget.thread.participants
    ) {
      if (!participant.isCurrentUser) {
        return participant;
      }
    }

    return null;
  }

  SuggestedMember? get _otherFriend {
    final participant =
        _otherParticipant;

    if (participant == null) {
      return null;
    }

    return widget.messageService
        .friendById(
      participant.id,
      _profile,
    );
  }

  String _timeLabel(
    DateTime value,
  ) {
    final minute =
        value.minute
            .toString()
            .padLeft(2, '0');

    final hour =
        value.hour == 0
            ? 12
            : value.hour > 12
                ? value.hour - 12
                : value.hour;

    final period =
        value.hour >= 12
            ? 'PM'
            : 'AM';

    return '$hour:$minute $period';
  }

  String _senderName(
    String senderId,
  ) {
    if (senderId == 'self') {
      return 'You';
    }

    for (
      final participant
          in widget.thread.participants
    ) {
      if (
        participant.id ==
        senderId
      ) {
        return participant
            .displayName;
      }
    }

    return 'Member';
  }

  void _sendMessage() {
    final value =
        _composerController.text
            .trim();

    if (value.isEmpty) {
      return;
    }

    final now = DateTime.now();

    setState(() {
      _messages.add(
        PhilotesMessage(
          id:
              'local-${now.microsecondsSinceEpoch}',
          senderId: 'self',
          text: value,
          sentAt: now,
        ),
      );

      widget.thread.latestActivity =
          now;
    });

    _composerController.clear();
  }

  void _toggleReadState() {
    setState(() {
      if (
        widget.thread.unreadCount >
        0
      ) {
        widget.messageService
            .markThreadRead(
          widget.thread.id,
        );

        widget.thread.unreadCount =
            0;
      } else {
        widget.messageService
            .markThreadUnread(
          widget.thread.id,
        );

        widget.thread.unreadCount =
            1;
      }
    });
  }

  void _showNotice(
    String message,
  ) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _openFriendProfile() {
    final friend =
        _otherFriend;

    if (friend == null) {
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) =>
            MemberProfileScreen(
          member: friend,
          mode:
              MemberProfileMode.friend,
          onMessage: () {
            Navigator.of(context)
                .pop();
          },
        ),
      ),
    );
  }

  void _showParticipants() {
    final names =
        widget.thread.participants
            .map(
              (participant) =>
                  participant
                          .isCurrentUser
                      ? 'You'
                      : participant
                          .displayName,
            )
            .join(', ');

    _showNotice(
      'Participants: $names',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key(
        'conversationScreen',
      ),
      backgroundColor:
          PhilotesColors.ivory,
      appBar: AppBar(
        backgroundColor:
            PhilotesColors.ivory,
        foregroundColor:
            PhilotesColors.navy,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          key: const Key(
            'backToMessagesButton',
          ),
          tooltip:
              'Back to Messages',
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        title: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              widget.thread.title,
              style:
                  const TextStyle(
                color:
                    PhilotesColors.navy,
                fontSize: 16,
                fontWeight:
                    FontWeight.w800,
              ),
            ),

            if (widget.thread.isGroup)
              Text(
                '${widget.thread.participants.length} '
                'participants',
                style:
                    const TextStyle(
                  color:
                      PhilotesColors
                          .silver,
                  fontSize: 10,
                ),
              ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            key: const Key(
              'conversationOptionsMenu',
            ),
            icon: const Icon(
              Icons.more_vert,
              color:
                  PhilotesColors.navy,
            ),
            onSelected: (value) {
              switch (value) {
                case 'toggle-read':
                  _toggleReadState();
                  break;

                case 'view-profile':
                  _openFriendProfile();
                  break;

                case 'participants':
                  _showParticipants();
                  break;

                case 'group-info':
                  _showNotice(
                    'Group information will '
                    'be connected during a '
                    'later messaging phase.',
                  );
                  break;

                case 'leave-group':
                  _showNotice(
                    'Leaving a group will '
                    'require confirmation '
                    'and backend authorization.',
                  );
                  break;

                case 'block':
                  _showNotice(
                    'Block will immediately '
                    'prevent future contact '
                    'when the production '
                    'safety backend is '
                    'connected.',
                  );
                  break;

                case 'report':
                  _showNotice(
                    'The report flow will be '
                    'connected to Philotes '
                    'moderation and safety.',
                  );
                  break;
              }
            },
            itemBuilder: (context) {
              final toggleItem =
                  PopupMenuItem<String>(
                value: 'toggle-read',
                child: Text(
                  widget.thread
                              .unreadCount >
                          0
                      ? 'Mark Read'
                      : 'Mark Unread',
                ),
              );

              if (
                widget.thread.isDirect
              ) {
                return [
                  toggleItem,
                  const PopupMenuItem<
                      String>(
                    value:
                        'view-profile',
                    child: Text(
                      'View Profile',
                    ),
                  ),
                  const PopupMenuItem<
                      String>(
                    value: 'block',
                    child: Text(
                      'Block',
                    ),
                  ),
                  const PopupMenuItem<
                      String>(
                    value: 'report',
                    child: Text(
                      'Report',
                    ),
                  ),
                ];
              }

              return [
                toggleItem,
                const PopupMenuItem<
                    String>(
                  value:
                      'participants',
                  child: Text(
                    'View Participants',
                  ),
                ),
                const PopupMenuItem<
                    String>(
                  value:
                      'group-info',
                  child: Text(
                    'Group Information',
                  ),
                ),
                const PopupMenuItem<
                    String>(
                  value:
                      'leave-group',
                  child: Text(
                    'Leave Group',
                  ),
                ),
              ];
            },
          ),
        ],
        bottom:
            const PreferredSize(
          preferredSize:
              Size.fromHeight(1.2),
          child: Divider(
            height: 1.2,
            thickness:
                PhilotesDesign
                    .secondaryBorderWidth,
            color:
                PhilotesColors.gold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              key: const Key(
                'conversationMessageList',
              ),
              padding:
                  const EdgeInsets
                      .fromLTRB(
                18,
                22,
                18,
                22,
              ),
              itemCount:
                  _messages.length,
              itemBuilder: (
                BuildContext context,
                int index,
              ) {
                final message =
                    _messages[index];

                return _MessageBubble(
                  mine:
                      message.senderId ==
                      'self',
                  senderName:
                      _senderName(
                    message.senderId,
                  ),
                  text:
                      message.text,
                  time:
                      _timeLabel(
                    message.sentAt,
                  ),
                );
              },
            ),
          ),

          Container(
            decoration:
                const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color:
                      PhilotesColors.gold,
                  width: 1.2,
                ),
              ),
            ),
            padding:
                const EdgeInsets
                    .fromLTRB(
              14,
              12,
              14,
              14,
            ),
            child: SafeArea(
              top: false,
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .end,
                children: [
                  Expanded(
                    child: TextField(
                      key: const Key(
                        'messageComposerField',
                      ),
                      controller:
                          _composerController,
                      minLines: 1,
                      maxLines: 5,
                      decoration:
                          InputDecoration(
                        hintText:
                            'Type a message...',
                        filled: true,
                        fillColor:
                            PhilotesColors
                                .ivory,
                        enabledBorder:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            16,
                          ),
                          borderSide:
                              const BorderSide(
                            color:
                                PhilotesColors
                                    .gold,
                            width: 1.2,
                          ),
                        ),
                        focusedBorder:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            16,
                          ),
                          borderSide:
                              const BorderSide(
                            color:
                                PhilotesColors
                                    .navy,
                            width: 1.6,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 10,
                  ),

                  FilledButton(
                    key: const Key(
                      'sendMessageButton',
                    ),
                    onPressed:
                        _sendMessage,
                    style:
                        FilledButton
                            .styleFrom(
                      backgroundColor:
                          PhilotesColors
                              .navy,
                      foregroundColor:
                          Colors.white,
                      minimumSize:
                          const Size(
                        72,
                        50,
                      ),
                    ),
                    child:
                        const Text(
                      'Send',
                      style:
                          TextStyle(
                        fontWeight:
                            FontWeight
                                .w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _MessageBubble
    extends StatelessWidget {
  const _MessageBubble({
    required this.mine,
    required this.senderName,
    required this.text,
    required this.time,
  });

  final bool mine;
  final String senderName;
  final String text;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          mine
              ? Alignment.centerRight
              : Alignment.centerLeft,
      child: Container(
        constraints:
            const BoxConstraints(
          maxWidth: 520,
        ),
        margin:
            const EdgeInsets.only(
          bottom: 14,
        ),
        padding:
            const EdgeInsets
                .fromLTRB(
          14,
          10,
          14,
          9,
        ),
        decoration:
            BoxDecoration(
          color:
              mine
                  ? PhilotesColors.navy
                  : Colors.white,
          borderRadius:
              BorderRadius.circular(
            16,
          ),
          border: Border.all(
            color:
                PhilotesColors.gold,
            width: 1.2,
          ),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment
                  .start,
          children: [
            Text(
              senderName,
              style: TextStyle(
                color:
                    mine
                        ? PhilotesColors
                            .gold
                        : PhilotesColors
                            .navy,
                fontSize: 10,
                fontWeight:
                    FontWeight.w800,
              ),
            ),

            const SizedBox(
              height: 4,
            ),

            Text(
              text,
              style: TextStyle(
                color:
                    mine
                        ? Colors.white
                        : PhilotesColors
                            .navy,
                fontSize: 13,
                height: 1.4,
              ),
            ),

            const SizedBox(
              height: 5,
            ),

            Text(
              time,
              style: TextStyle(
                color:
                    mine
                        ? Colors.white70
                        : PhilotesColors
                            .silver,
                fontSize: 9,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
"""


TEST_ADDITION = r"""
  testWidgets(
    'Messages bulk selection marks threads read and unread',
    (
      WidgetTester tester,
    ) async {
      await openMessages(tester);

      await tester.tap(
        find.byKey(
          const Key(
            'messagesOptionsMenu',
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(
        find.text(
          'Select Conversations',
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.byKey(
          const Key(
            'messageSelectionToolbar',
          ),
        ),
        findsOneWidget,
      );

      final jordan = find.byKey(
        const Key(
          'messageThread-thread-jordan',
        ),
      );

      final bowling = find.byKey(
        const Key(
          'messageThread-thread-bowling-night',
        ),
      );

      await tester.tap(jordan);
      await tester.tap(bowling);
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(
          const Key(
            'bulkMarkReadButton',
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.byKey(
          const Key(
            'unreadBadge-thread-jordan',
          ),
        ),
        findsNothing,
      );

      expect(
        find.byKey(
          const Key(
            'unreadBadge-thread-bowling-night',
          ),
        ),
        findsNothing,
      );

      await tester.tap(
        find.byKey(
          const Key(
            'messagesOptionsMenu',
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(
        find.text(
          'Select Conversations',
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(jordan);
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(
          const Key(
            'bulkMarkUnreadButton',
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.byKey(
          const Key(
            'unreadBadge-thread-jordan',
          ),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Long press enters Messages selection mode',
    (
      WidgetTester tester,
    ) async {
      await openMessages(tester);

      final jordan = find.byKey(
        const Key(
          'messageThread-thread-jordan',
        ),
      );

      await tester.longPress(jordan);
      await tester.pumpAndSettle();

      expect(
        find.byKey(
          const Key(
            'messageSelectionToolbar',
          ),
        ),
        findsOneWidget,
      );

      expect(
        find.byKey(
          const Key(
            'messageCheckbox-thread-jordan',
          ),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Conversation menu toggles Mark Unread and Mark Read',
    (
      WidgetTester tester,
    ) async {
      await openMessages(tester);

      final jordan = find.byKey(
        const Key(
          'messageThread-thread-jordan',
        ),
      );

      await tester.tap(jordan);
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(
          const Key(
            'conversationOptionsMenu',
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Mark Unread'),
        findsOneWidget,
      );

      await tester.tap(
        find.text('Mark Unread'),
      );

      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(
          const Key(
            'conversationOptionsMenu',
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Mark Read'),
        findsOneWidget,
      );
    },
  );
"""


def main() -> None:
    print()
    print("=" * 76)
    print(
        "PHILOTES MESSAGES BULK "
        "READ / UNREAD PATCH"
    )
    print("=" * 76)
    print()

    required = [
        SERVICE_FILE,
        DEV_SERVICE_FILE,
        MESSAGES_FILE,
        CONVERSATION_FILE,
        TEST_FILE,
    ]

    for path in required:
        if not path.exists():
            print(
                f"FAIL: Required file not found: {path}"
            )
            raise SystemExit(1)

    originals = {
        path:
            path.read_text(
                encoding="utf-8",
            )
        for path in required
    }

    try:
        SERVICE_FILE.write_text(
            SERVICE_CONTENT,
            encoding="utf-8",
        )

        DEV_SERVICE_FILE.write_text(
            DEV_SERVICE_CONTENT,
            encoding="utf-8",
        )

        MESSAGES_FILE.write_text(
            MESSAGES_CONTENT,
            encoding="utf-8",
        )

        CONVERSATION_FILE.write_text(
            CONVERSATION_CONTENT,
            encoding="utf-8",
        )

        tests = originals[
            TEST_FILE
        ]

        marker = (
            "Messages bulk selection "
            "marks threads read and unread"
        )

        if marker not in tests:
            closing = tests.rfind(
                "\n}"
            )

            if closing == -1:
                raise RuntimeError(
                    "messages_v1_test.dart "
                    "closing brace not found."
                )

            tests = (
                tests[:closing]
                + TEST_ADDITION
                + tests[closing:]
            )

        TEST_FILE.write_text(
            tests,
            encoding="utf-8",
        )

    except Exception as exc:
        for path, content in originals.items():
            path.write_text(
                content,
                encoding="utf-8",
            )

        print()
        print(f"FAIL: {exc}")
        print(
            "All Messages files restored."
        )

        raise SystemExit(1)

    service = SERVICE_FILE.read_text(
        encoding="utf-8",
    )

    dev = DEV_SERVICE_FILE.read_text(
        encoding="utf-8",
    )

    messages = MESSAGES_FILE.read_text(
        encoding="utf-8",
    )

    conversation = (
        CONVERSATION_FILE.read_text(
            encoding="utf-8",
        )
    )

    tests = TEST_FILE.read_text(
        encoding="utf-8",
    )

    checks = {
        "MessageService has Mark Read":
            "markThreadRead"
            in service,

        "MessageService has Mark Unread":
            "markThreadUnread"
            in service,

        "Development service stores overrides":
            "_unreadOverrides"
            in dev,

        "Automatic read behavior preserved":
            "markThreadRead"
            in messages,

        "Select Conversations menu added":
            "Select Conversations"
            in messages,

        "Selection toolbar added":
            "messageSelectionToolbar"
            in messages,

        "Checkboxes added in selection mode":
            "messageCheckbox-"
            in messages,

        "Long press selection added":
            "onLongPress"
            in messages,

        "Select All added":
            "selectAllMessagesButton"
            in messages,

        "Bulk Mark Read added":
            "bulkMarkReadButton"
            in messages,

        "Bulk Mark Unread added":
            "bulkMarkUnreadButton"
            in messages,

        "Conversation contextual read toggle added":
            "toggle-read"
            in conversation,

        "Conversation shows Mark Read":
            "Mark Read"
            in conversation,

        "Conversation shows Mark Unread":
            "Mark Unread"
            in conversation,

        "Bulk selection test added":
            "Messages bulk selection "
            "marks threads read and unread"
            in tests,

        "Long press test added":
            "Long press enters Messages "
            "selection mode"
            in tests,

        "Conversation toggle test added":
            "Conversation menu toggles "
            "Mark Unread and Mark Read"
            in tests,
    }

    passed = True

    report = [
        (
            "PHILOTES MESSAGES BULK "
            "READ / UNREAD PATCH REPORT"
        ),
        "=" * 76,
        (
            "Generated: "
            + datetime.now().isoformat(
                timespec="seconds",
            )
        ),
        "",
    ]

    for description, result in checks.items():
        status = (
            "PASS"
            if result
            else "FAIL"
        )

        print(
            f"{status}: {description}"
        )

        report.append(
            f"{status}: {description}"
        )

        if not result:
            passed = False

    report.extend(
        [
            "",
            "OVERALL: "
            + (
                "PASS"
                if passed
                else "FAIL"
            ),
            "",
            "EXPECTED BEHAVIOR",
            "-" * 76,
            (
                "- Normal Messages view "
                "remains uncluttered."
            ),
            (
                "- Select Conversations "
                "enters checkbox mode."
            ),
            (
                "- Long press enters selection "
                "mode and selects that thread."
            ),
            (
                "- Select All applies only to "
                "currently displayed conversations."
            ),
            (
                "- Bulk Mark Read clears unread "
                "state on selected threads."
            ),
            (
                "- Bulk Mark Unread marks each "
                "selected thread with one unread "
                "conversation indicator."
            ),
            (
                "- Individual conversations use "
                "one contextual Mark Read / "
                "Mark Unread menu item."
            ),
            (
                "- Opening an unread conversation "
                "still automatically marks it read."
            ),
            (
                "- Existing navy, gold, ivory "
                "Philotes styling is preserved."
            ),
        ]
    )

    REPORT_FILE.write_text(
        "\n".join(report) + "\n",
        encoding="utf-8",
    )

    print()
    print(
        f"Report: {REPORT_FILE}"
    )
    print()

    print(
        "OVERALL: "
        + (
            "PASS"
            if passed
            else "FAIL"
        )
    )

    if not passed:
        raise SystemExit(1)


if __name__ == "__main__":
    main()

