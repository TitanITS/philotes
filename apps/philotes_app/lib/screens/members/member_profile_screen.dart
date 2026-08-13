import 'package:flutter/material.dart';

import '../../models/compatibility/compatibility_level.dart';
import '../../models/compatibility/suggested_member.dart';
import '../../theme/philotes_colors.dart';
import '../../theme/philotes_design.dart';

enum MemberProfileMode {
  discovery,
  friend,
}

class MemberProfileScreen extends StatelessWidget {
  const MemberProfileScreen({
    super.key,
    required this.member,
    this.mode =
        MemberProfileMode.discovery,
    this.onMessage,
  });

  final SuggestedMember member;
  final MemberProfileMode mode;
  final VoidCallback? onMessage;

  Color get _levelColor {
    switch (member.compatibility.level) {
      case CompatibilityLevel.strong:
        return PhilotesColors.gold;
      case CompatibilityLevel.moderate:
        return PhilotesColors.silver;
      case CompatibilityLevel.limited:
        return PhilotesColors.bronze;
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = member.compatibility;

    return Scaffold(
      backgroundColor: PhilotesColors.ivory,
      appBar: AppBar(
        backgroundColor: PhilotesColors.ivory,
        foregroundColor: PhilotesColors.navy,
        elevation: 0,
        title: Text(
          member.displayName,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            key: const Key(
              'memberProfileOptionsMenu',
            ),
            icon: const Icon(
              Icons.more_vert,
            ),
            onSelected: (value) {
              String message;

              switch (value) {
                case 'unfriend':
                  message =
                      'Unfriend will require '
                      'confirmation and backend '
                      'friendship authorization.';
                  break;

                case 'hide':
                  message =
                      'This member will be hidden '
                      'from future suggestions '
                      'when discovery preferences '
                      'are connected.';
                  break;

                case 'block':
                  message =
                      'Block will prevent future '
                      'contact when the production '
                      'safety backend is connected.';
                  break;

                default:
                  message =
                      'The report flow will be '
                      'connected to Philotes '
                      'moderation and safety.';
              }

              ScaffoldMessenger.of(context)
                  .showSnackBar(
                SnackBar(
                  content: Text(message),
                ),
              );
            },
            itemBuilder: (context) {
              if (
                mode ==
                MemberProfileMode.friend
              ) {
                return const [
                  PopupMenuItem<String>(
                    value: 'unfriend',
                    child: Text('Unfriend'),
                  ),
                  PopupMenuItem<String>(
                    value: 'block',
                    child: Text('Block'),
                  ),
                  PopupMenuItem<String>(
                    value: 'report',
                    child: Text('Report'),
                  ),
                ];
              }

              return const [
                PopupMenuItem<String>(
                  value: 'hide',
                  child: Text(
                    "Don't Suggest Again",
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'block',
                  child: Text('Block'),
                ),
                PopupMenuItem<String>(
                  value: 'report',
                  child: Text('Report'),
                ),
              ];
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          key: const Key(
            'memberProfileScreen',
          ),
          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            36,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 760,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: PhilotesColors.navy,
                        border: Border.all(
                          color: PhilotesColors.gold,
                          width: 2.5,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        member.initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 44,
                          fontWeight:
                              FontWeight.w800,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    member.displayName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: PhilotesColors.navy,
                      fontSize: 27,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    member.introduction,
                    textAlign: TextAlign.center,
                    style:
                        PhilotesDesign.supportingText,
                  ),

                  const SizedBox(height: 24),

                  Container(
                    key: const Key(
                      'compatibilityScoreCard',
                    ),
                    padding: const EdgeInsets.all(18),
                    decoration:
                        PhilotesDesign
                            .primaryCardDecoration(),
                    child: Column(
                      children: [
                        const Text(
                          'COMPATIBILITY',
                          style: TextStyle(
                            color:
                                PhilotesColors.navy,
                            fontSize: 11,
                            fontWeight:
                                FontWeight.w800,
                            letterSpacing: 1.1,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          '${result.score}%',
                          key: const Key(
                            'compatibilityPercentage',
                          ),
                          style: const TextStyle(
                            color:
                                PhilotesColors.navy,
                            fontSize: 34,
                            fontWeight:
                                FontWeight.w900,
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          result.level.label,
                          style: TextStyle(
                            color: _levelColor,
                            fontSize: 17,
                            fontWeight:
                                FontWeight.w800,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'Development compatibility values '
                          'are being used while we finish '
                          'the frontend. The production '
                          'scoring engine will be built later.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color:
                                PhilotesColors.silver,
                            fontSize: 10,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height:
                        PhilotesDesign.sectionSpacing,
                  ),

                  _DetailSection(
                    title: 'Why You May Connect',
                    child: Column(
                      children: [
                        for (final reason
                            in result.reasons)
                          Padding(
                            padding:
                                const EdgeInsets.only(
                              bottom: 9,
                            ),
                            child: Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                const Text(
                                  '•',
                                  style: TextStyle(
                                    color:
                                        PhilotesColors
                                            .gold,
                                    fontWeight:
                                        FontWeight
                                            .w900,
                                  ),
                                ),
                                const SizedBox(
                                  width: 9,
                                ),
                                Expanded(
                                  child: Text(
                                    reason,
                                    style:
                                        const TextStyle(
                                      color:
                                          PhilotesColors
                                              .navy,
                                      fontSize: 13,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height:
                        PhilotesDesign.sectionSpacing,
                  ),

                  _InterestSection(
                    title: 'Shared Favorites',
                    values:
                        result
                            .sharedFavoriteInterests,
                    emphasized: true,
                  ),

                  const SizedBox(
                    height:
                        PhilotesDesign.sectionSpacing,
                  ),

                  _InterestSection(
                    title: 'Other Shared Interests',
                    values:
                        result.sharedInterests,
                    emphasized: false,
                  ),

                  const SizedBox(
                    height:
                        PhilotesDesign.sectionSpacing,
                  ),

                  _DetailSection(
                    title:
                        'Friendship Compatibility',
                    child: Column(
                      children: [
                        _AlignmentRow(
                          label: 'Social Pace',
                          value:
                              result
                                  .socialPaceAlignment,
                        ),
                        const Divider(height: 24),
                        _AlignmentRow(
                          label:
                              'Friendship Style',
                          value:
                              result
                                  .friendshipStyleAlignment,
                        ),
                        const Divider(height: 24),
                        _AlignmentRow(
                          label:
                              'Planning Style',
                          value:
                              result
                                  .planningStyleAlignment,
                        ),
                        const Divider(height: 24),
                        _AlignmentRow(
                          label:
                              'Trying New Activities',
                          value:
                              result
                                  .newActivityAlignment,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height:
                        PhilotesDesign.sectionSpacing,
                  ),

                  _InterestSection(
                    title:
                        'Things You May Enjoy Together',
                    values:
                        result.suggestedActivities,
                    emphasized: true,
                  ),

                  const SizedBox(height: 30),

                  if (
                    mode ==
                    MemberProfileMode.friend
                  )
                    SizedBox(
                      height: 56,
                      child: FilledButton.icon(
                        key: const Key(
                          'messageFriendFromProfileButton',
                        ),
                        onPressed: onMessage,
                        style:
                            FilledButton.styleFrom(
                          backgroundColor:
                              PhilotesColors.navy,
                          foregroundColor:
                              Colors.white,
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              14,
                            ),
                            side:
                                const BorderSide(
                              color:
                                  PhilotesColors.gold,
                              width: 1.5,
                            ),
                          ),
                        ),
                        icon: const Icon(
                          Icons.chat_bubble_outline,
                        ),
                        label: Text(
                          'Message '
                          '${member.displayName}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      height: 56,
                      child: FilledButton(
                        key: const Key(
                          'showInterestButton',
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Showing interest in '
                                '${member.displayName} '
                                'will be connected to '
                                'the friendship-request '
                                'system later.',
                              ),
                            ),
                          );
                        },
                        style:
                            FilledButton.styleFrom(
                          backgroundColor:
                              PhilotesColors.navy,
                          foregroundColor:
                              Colors.white,
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              14,
                            ),
                            side:
                                const BorderSide(
                              color:
                                  PhilotesColors.gold,
                              width: 1.5,
                            ),
                          ),
                        ),
                        child: const Text(
                          'Show Interest',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class _DetailSection extends StatelessWidget {
  const _DetailSection({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style:
              PhilotesDesign.sectionHeading,
        ),

        const SizedBox(height: 10),

        Container(
          padding: const EdgeInsets.all(18),
          decoration:
              PhilotesDesign
                  .secondaryCardDecoration(),
          child: child,
        ),
      ],
    );
  }
}


class _InterestSection extends StatelessWidget {
  const _InterestSection({
    required this.title,
    required this.values,
    required this.emphasized,
  });

  final String title;
  final List<String> values;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style:
              PhilotesDesign.sectionHeading,
        ),

        const SizedBox(height: 10),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final value in values)
              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color:
                      emphasized
                          ? PhilotesColors.navy
                          : Colors.white,
                  borderRadius:
                      BorderRadius.circular(24),
                  border: Border.all(
                    color:
                        PhilotesColors.gold,
                    width:
                        emphasized ? 1.4 : 1.1,
                  ),
                ),
                child: Text(
                  value,
                  style: TextStyle(
                    color:
                        emphasized
                            ? Colors.white
                            : PhilotesColors.navy,
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}


class _AlignmentRow extends StatelessWidget {
  const _AlignmentRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: PhilotesColors.navy,
              fontSize: 13,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: PhilotesColors.gold,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
