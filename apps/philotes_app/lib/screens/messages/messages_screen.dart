import 'package:flutter/material.dart';

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
