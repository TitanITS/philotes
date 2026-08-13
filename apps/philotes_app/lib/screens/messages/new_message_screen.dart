import 'package:flutter/material.dart';

import '../../models/compatibility/suggested_member.dart';
import '../../models/messages/message_thread.dart';
import '../../models/onboarding_profile_data.dart';
import '../../services/messages/message_service.dart';
import '../../theme/philotes_colors.dart';
import '../../theme/philotes_design.dart';
import 'conversation_screen.dart';

class NewMessageScreen
    extends StatefulWidget {
  const NewMessageScreen({
    super.key,
    required this.messageService,
  });

  final MessageService messageService;

  @override
  State<NewMessageScreen> createState() =>
      _NewMessageScreenState();
}

class _NewMessageScreenState
    extends State<NewMessageScreen> {
  final TextEditingController
      _searchController =
      TextEditingController();

  final TextEditingController
      _groupNameController =
      TextEditingController();

  final Set<String> _selectedIds =
      <String>{};

  String _query = '';

  OnboardingProfileData get _profile =>
      OnboardingProfileData.instance;

  List<SuggestedMember> get _friends {
    final query =
        _query.trim().toLowerCase();

    final values =
        widget.messageService
            .messageableFriends(
          _profile,
        )
            .where(
              (friend) =>
                  query.isEmpty ||
                  friend.displayName
                      .toLowerCase()
                      .contains(query),
            )
            .toList();

    values.sort(
      (a, b) =>
          a.displayName.compareTo(
        b.displayName,
      ),
    );

    return values;
  }

  List<SuggestedMember>
      get _selectedFriends {
    return widget.messageService
        .messageableFriends(
          _profile,
        )
        .where(
          (friend) =>
              _selectedIds.contains(
            friend.id,
          ),
        )
        .toList();
  }

  bool get _isGroup =>
      _selectedIds.length > 1;

  void _toggle(
    SuggestedMember friend,
  ) {
    setState(() {
      if (
        _selectedIds.contains(
          friend.id,
        )
      ) {
        _selectedIds.remove(
          friend.id,
        );
      } else {
        _selectedIds.add(
          friend.id,
        );
      }
    });
  }

  void _continue() {
    final selected =
        _selectedFriends;

    if (selected.isEmpty) {
      return;
    }

    final selfName =
        _profile.displayName
                .trim()
                .isEmpty
            ? 'You'
            : _profile.displayName
                .trim();

    final participants =
        <MessageParticipant>[
      MessageParticipant(
        id: 'self',
        displayName: selfName,
        initials:
            selfName.isEmpty
                ? 'Y'
                : selfName
                    .substring(0, 1)
                    .toUpperCase(),
        isCurrentUser: true,
      ),
      for (final friend in selected)
        MessageParticipant(
          id: friend.id,
          displayName:
              friend.displayName,
          initials:
              friend.initials,
        ),
    ];

    final title =
        _isGroup
            ? _groupNameController
                    .text
                    .trim()
                    .isEmpty
                ? selected
                    .map(
                      (friend) =>
                          friend.displayName,
                    )
                    .join(', ')
                : _groupNameController
                    .text
                    .trim()
            : selected.first.displayName;

    final thread =
        MessageThread(
      id:
          'new-${DateTime.now().microsecondsSinceEpoch}',
      type:
          _isGroup
              ? MessageThreadType.group
              : MessageThreadType.direct,
      title: title,
      participants: participants,
      messages:
          <PhilotesMessage>[],
      latestActivity:
          DateTime.now(),
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (context) =>
            ConversationScreen(
          thread: thread,
          messageService:
              widget.messageService,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _groupNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final friends = _friends;

    return Scaffold(
      key: const Key(
        'newMessageScreen',
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
            'backFromNewMessageButton',
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        title: Text(
          _isGroup
              ? 'New Group Message'
              : 'New Message',
          style: const TextStyle(
            color:
                PhilotesColors.navy,
            fontSize: 16,
            fontWeight:
                FontWeight.w800,
          ),
        ),
        bottom: const PreferredSize(
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
      body: LayoutBuilder(
        builder: (
          BuildContext context,
          BoxConstraints constraints,
        ) {
          final wide =
              constraints.maxWidth >=
              PhilotesDesign
                  .wideBreakpoint;

          return SingleChildScrollView(
            padding:
                EdgeInsets.fromLTRB(
              wide
                  ? PhilotesDesign.widePadding
                  : PhilotesDesign.mobilePadding,
              26,
              wide
                  ? PhilotesDesign.widePadding
                  : PhilotesDesign.mobilePadding,
              42,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(
                  maxWidth: 760,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Choose from your '
                      'Philotes friends.',
                      style: TextStyle(
                        color:
                            PhilotesColors.navy,
                        fontSize: 24,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      'Direct messages are '
                      'one-to-one. Selecting '
                      'more than one friend '
                      'creates a group message.',
                      style:
                          PhilotesDesign
                              .supportingText,
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      key: const Key(
                        'newMessageFriendSearch',
                      ),
                      controller:
                          _searchController,
                      onChanged: (value) {
                        setState(() {
                          _query = value;
                        });
                      },
                      decoration:
                          InputDecoration(
                        hintText:
                            'Search friends...',
                        prefixIcon:
                            const Icon(
                          Icons.search,
                          color:
                              PhilotesColors.gold,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                            PhilotesDesign
                                .cardRadius,
                          ),
                          borderSide:
                              const BorderSide(
                            color:
                                PhilotesColors.gold,
                            width: 1.4,
                          ),
                        ),
                        focusedBorder:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                            PhilotesDesign
                                .cardRadius,
                          ),
                          borderSide:
                              const BorderSide(
                            color:
                                PhilotesColors.navy,
                            width: 1.8,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    for (
                      var index = 0;
                      index < friends.length;
                      index++
                    ) ...[
                      _FriendChoice(
                        friend:
                            friends[index],
                        selected:
                            _selectedIds.contains(
                          friends[index].id,
                        ),
                        onTap: () {
                          _toggle(
                            friends[index],
                          );
                        },
                      ),

                      if (
                        index <
                        friends.length - 1
                      )
                        const SizedBox(
                          height: 10,
                        ),
                    ],

                    if (_isGroup) ...[
                      const SizedBox(
                        height: 22,
                      ),

                      Container(
                        padding:
                            const EdgeInsets
                                .all(16),
                        decoration:
                            PhilotesDesign
                                .primaryCardDecoration(),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .stretch,
                          children: [
                            const Text(
                              'GROUP MESSAGE',
                              style:
                                  TextStyle(
                                color:
                                    PhilotesColors.navy,
                                fontSize: 10,
                                fontWeight:
                                    FontWeight.w900,
                                letterSpacing: 1.1,
                              ),
                            ),

                            const SizedBox(
                              height: 8,
                            ),

                            Text(
                              'You are creating '
                              'a group conversation.',
                              style:
                                  PhilotesDesign
                                      .supportingText,
                            ),

                            const SizedBox(
                              height: 14,
                            ),

                            TextField(
                              key: const Key(
                                'groupNameField',
                              ),
                              controller:
                                  _groupNameController,
                              decoration:
                                  const InputDecoration(
                                labelText:
                                    'Group Name',
                                hintText:
                                    'Saturday Crew',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    Text(
                      'Selected: '
                      '${_selectedIds.length}',
                      key: const Key(
                        'selectedFriendCount',
                      ),
                      style:
                          const TextStyle(
                        color:
                            PhilotesColors.silver,
                        fontSize: 12,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 10),

                    FilledButton(
                      key: const Key(
                        'continueNewMessageButton',
                      ),
                      onPressed:
                          _selectedIds.isEmpty
                              ? null
                              : _continue,
                      style:
                          FilledButton.styleFrom(
                        backgroundColor:
                            PhilotesColors.navy,
                        foregroundColor:
                            Colors.white,
                        padding:
                            const EdgeInsets
                                .symmetric(
                          vertical: 15,
                        ),
                      ),
                      child: Text(
                        _isGroup
                            ? 'Create Group Message'
                            : 'Start Direct Message',
                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


class _FriendChoice
    extends StatelessWidget {
  const _FriendChoice({
    required this.friend,
    required this.selected,
    required this.onTap,
  });

  final SuggestedMember friend;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: Key(
          'messageFriendChoice-${friend.id}',
        ),
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(
          PhilotesDesign.cardRadius,
        ),
        child: Ink(
          padding:
              const EdgeInsets.all(14),
          decoration:
              selected
                  ? PhilotesDesign
                      .primaryCardDecoration()
                  : PhilotesDesign
                      .secondaryCardDecoration(),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration:
                    BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      PhilotesColors.navy,
                  border: Border.all(
                    color:
                        PhilotesColors.gold,
                    width: 1.7,
                  ),
                ),
                alignment:
                    Alignment.center,
                child: Text(
                  friend.initials,
                  style:
                      const TextStyle(
                    color: Colors.white,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  friend.displayName,
                  style:
                      const TextStyle(
                    color:
                        PhilotesColors.navy,
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ),

              Icon(
                selected
                    ? Icons.check_circle
                    : Icons.circle_outlined,
                color:
                    selected
                        ? PhilotesColors.gold
                        : PhilotesColors.silver,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
