import 'package:flutter/material.dart';

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
