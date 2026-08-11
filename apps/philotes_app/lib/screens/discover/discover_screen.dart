import 'package:flutter/material.dart';

import '../../models/compatibility/compatibility_level.dart';
import '../../models/compatibility/suggested_member.dart';
import '../../models/onboarding_profile_data.dart';
import '../../screens/members/member_profile_screen.dart';
import '../../services/compatibility/compatibility_service.dart';
import '../../services/compatibility/development_compatibility_service.dart';
import '../../theme/philotes_colors.dart';
import '../../theme/philotes_design.dart';

enum _DiscoverCompatibilityFilter {
  all,
  strong,
  moderateOrBetter,
}

enum _DiscoverDistanceMode {
  recommended,
  strict,
  expanded,
}

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({
    super.key,
    this.compatibilityService =
        const DevelopmentCompatibilityService(),
  });

  final CompatibilityService
  compatibilityService;

  @override
  State<DiscoverScreen> createState() =>
      _DiscoverScreenState();
}

class _DiscoverScreenState
    extends State<DiscoverScreen> {
  _DiscoverCompatibilityFilter
      _compatibilityFilter =
      _DiscoverCompatibilityFilter.all;

  _DiscoverDistanceMode
      _distanceMode =
      _DiscoverDistanceMode.recommended;

  String _interestFilter = 'All interests';

  OnboardingProfileData get _profile =>
      OnboardingProfileData.instance;

  int? get _preferredDistance {
    final value = _profile.meetingDistance;

    if (value == null) {
      return null;
    }

    return int.tryParse(value);
  }

  List<String> get _availableInterests {
    final values = <String>{
      ..._profile.favoriteInterests,
      ..._profile.selectedInterests,
    }.toList()
      ..sort();

    return <String>[
      'All interests',
      ...values,
    ];
  }

  bool _matchesCompatibility(
    SuggestedMember member,
  ) {
    switch (_compatibilityFilter) {
      case _DiscoverCompatibilityFilter.all:
        return true;

      case _DiscoverCompatibilityFilter.strong:
        return member.compatibility.level ==
            CompatibilityLevel.strong;

      case _DiscoverCompatibilityFilter
            .moderateOrBetter:
        return member.compatibility.level !=
            CompatibilityLevel.limited;
    }
  }

  bool _matchesInterest(
    SuggestedMember member,
  ) {
    if (_interestFilter == 'All interests') {
      return true;
    }

    return member
            .compatibility
            .sharedFavoriteInterests
            .contains(_interestFilter) ||
        member
            .compatibility
            .sharedInterests
            .contains(_interestFilter);
  }

  bool _matchesDistance(
    SuggestedMember member,
  ) {
    final preferred =
        _preferredDistance;

    if (preferred == null) {
      return true;
    }

    switch (_distanceMode) {
      case _DiscoverDistanceMode.strict:
        return member.distanceMiles <=
            preferred;

      case _DiscoverDistanceMode.recommended:
        //
        // Recommended mode allows an exceptional
        // compatibility result to appear a modest
        // distance beyond the member's preference.
        //
        // The final production rule will live in
        // the backend discovery engine.
        //
        if (member.distanceMiles <= preferred) {
          return true;
        }

        final extraDistance =
            member.distanceMiles - preferred;

        return member.compatibility.level ==
                CompatibilityLevel.strong &&
            extraDistance <= 15;

      case _DiscoverDistanceMode.expanded:
        return true;
    }
  }

  List<SuggestedMember>
      _visibleMembers() {
    final members = widget
        .compatibilityService
        .suggestedMembers(_profile)
        .where(_matchesCompatibility)
        .where(_matchesInterest)
        .where(_matchesDistance)
        .toList();

    members.sort(
      (
        SuggestedMember a,
        SuggestedMember b,
      ) {
        //
        // Discover ranking priority:
        //
        // 1. Compatibility score
        // 2. Shared Like-the-Most interests
        // 3. Other shared interests
        // 4. Distance
        //
        final scoreCompare =
            b.compatibility.score.compareTo(
          a.compatibility.score,
        );

        if (scoreCompare != 0) {
          return scoreCompare;
        }

        final favoritesCompare =
            b.compatibility
                .sharedFavoriteInterests
                .length
                .compareTo(
                  a.compatibility
                      .sharedFavoriteInterests
                      .length,
                );

        if (favoritesCompare != 0) {
          return favoritesCompare;
        }

        final interestsCompare =
            b.compatibility
                .sharedInterests
                .length
                .compareTo(
                  a.compatibility
                      .sharedInterests
                      .length,
                );

        if (interestsCompare != 0) {
          return interestsCompare;
        }

        return a.distanceMiles.compareTo(
          b.distanceMiles,
        );
      },
    );

    return members;
  }

  void _resetFilters() {
    setState(() {
      _compatibilityFilter =
          _DiscoverCompatibilityFilter.all;

      _distanceMode =
          _DiscoverDistanceMode.recommended;

      _interestFilter =
          'All interests';
    });
  }

  void _openMember(
    SuggestedMember member,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) =>
            MemberProfileScreen(
          member: member,
        ),
      ),
    );
  }

  String _preferredDistanceLabel() {
    final preferred =
        _preferredDistance;

    if (preferred == null) {
      return 'No numeric distance preference';
    }

    return '$preferred miles';
  }

  @override
  Widget build(BuildContext context) {
    final members =
        _visibleMembers();

    return LayoutBuilder(
      builder: (
        BuildContext context,
        BoxConstraints constraints,
      ) {
        final wide =
            constraints.maxWidth >=
            PhilotesDesign.wideBreakpoint;

        return SingleChildScrollView(
          key: const Key(
            'discoverScreen',
          ),
          padding: EdgeInsets.fromLTRB(
            wide
                ? PhilotesDesign.widePadding
                : PhilotesDesign.mobilePadding,
            24,
            wide
                ? PhilotesDesign.widePadding
                : PhilotesDesign.mobilePadding,
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
                    CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Discover',
                    style: TextStyle(
                      color:
                          PhilotesColors.navy,
                      fontSize: 30,
                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Find people you may enjoy '
                    'getting to know.',
                    style: TextStyle(
                      color:
                          PhilotesColors.silver,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 26),

                  _RefineDiscoveryCard(
                    compatibilityFilter:
                        _compatibilityFilter,
                    distanceMode:
                        _distanceMode,
                    interestFilter:
                        _interestFilter,
                    availableInterests:
                        _availableInterests,
                    preferredDistanceLabel:
                        _preferredDistanceLabel(),
                    onCompatibilityChanged:
                        (value) {
                      setState(() {
                        _compatibilityFilter =
                            value;
                      });
                    },
                    onDistanceChanged:
                        (value) {
                      setState(() {
                        _distanceMode =
                            value;
                      });
                    },
                    onInterestChanged:
                        (value) {
                      setState(() {
                        _interestFilter =
                            value;
                      });
                    },
                    onReset: _resetFilters,
                  ),

                  const SizedBox(height: 28),

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
                          'People To Discover',
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

                      Text(
                        '${members.length}',
                        key: const Key(
                          'discoverResultCount',
                        ),
                        style: const TextStyle(
                          color:
                              PhilotesColors
                                  .silver,
                          fontSize: 12,
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  if (members.isEmpty)
                    const _NoResultsCard()
                  else
                    _MemberGrid(
                      members: members,
                      wide: wide,
                      preferredDistance:
                          _preferredDistance,
                      onOpenMember:
                          _openMember,
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


class _RefineDiscoveryCard
    extends StatelessWidget {
  const _RefineDiscoveryCard({
    required this.compatibilityFilter,
    required this.distanceMode,
    required this.interestFilter,
    required this.availableInterests,
    required this.preferredDistanceLabel,
    required this.onCompatibilityChanged,
    required this.onDistanceChanged,
    required this.onInterestChanged,
    required this.onReset,
  });

  final _DiscoverCompatibilityFilter
      compatibilityFilter;

  final _DiscoverDistanceMode
      distanceMode;

  final String interestFilter;

  final List<String>
      availableInterests;

  final String preferredDistanceLabel;

  final ValueChanged<
      _DiscoverCompatibilityFilter>
  onCompatibilityChanged;

  final ValueChanged<_DiscoverDistanceMode>
  onDistanceChanged;

  final ValueChanged<String>
  onInterestChanged;

  final VoidCallback onReset;

  String _compatibilityLabel(
    _DiscoverCompatibilityFilter value,
  ) {
    switch (value) {
      case _DiscoverCompatibilityFilter.all:
        return 'All';

      case _DiscoverCompatibilityFilter.strong:
        return 'Strong only';

      case _DiscoverCompatibilityFilter
            .moderateOrBetter:
        return 'Moderate or better';
    }
  }

  String _distanceLabel(
    _DiscoverDistanceMode value,
  ) {
    switch (value) {
      case _DiscoverDistanceMode.recommended:
        return 'Recommended';

      case _DiscoverDistanceMode.strict:
        return 'Strict';

      case _DiscoverDistanceMode.expanded:
        return 'Expanded';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key(
        'refineDiscoveryCard',
      ),
      padding: const EdgeInsets.all(18),
      decoration:
          PhilotesDesign
              .primaryCardDecoration(),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.stretch,
        children: [
          const Text(
            'REFINE DISCOVERY',
            style: TextStyle(
              color:
                  PhilotesColors.navy,
              fontSize: 12,
              fontWeight:
                  FontWeight.w900,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Temporary filters for this '
            'Discover session.',
            style: TextStyle(
              color:
                  PhilotesColors.silver,
              fontSize: 11,
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'Compatibility',
            style: TextStyle(
              color:
                  PhilotesColors.navy,
              fontSize: 12,
              fontWeight:
                  FontWeight.w700,
            ),
          ),

          const SizedBox(height: 6),

          DropdownButtonFormField<
              _DiscoverCompatibilityFilter>(
            key: const Key(
              'discoverCompatibilityFilter',
            ),
            initialValue:
                compatibilityFilter,
            decoration:
                _filterDecoration(),
            items: [
              for (
                final value
                    in _DiscoverCompatibilityFilter
                        .values
              )
                DropdownMenuItem(
                  value: value,
                  child: Text(
                    _compatibilityLabel(
                      value,
                    ),
                  ),
                ),
            ],
            onChanged: (value) {
              if (value != null) {
                onCompatibilityChanged(
                  value,
                );
              }
            },
          ),

          const SizedBox(height: 16),

          const Text(
            'Shared Interests',
            style: TextStyle(
              color:
                  PhilotesColors.navy,
              fontSize: 12,
              fontWeight:
                  FontWeight.w700,
            ),
          ),

          const SizedBox(height: 6),

          DropdownButtonFormField<String>(
            key: const Key(
              'discoverInterestFilter',
            ),
            initialValue:
                interestFilter,
            decoration:
                _filterDecoration(),
            items: [
              for (
                final interest
                    in availableInterests
              )
                DropdownMenuItem(
                  value: interest,
                  child: Text(
                    interest,
                    overflow:
                        TextOverflow
                            .ellipsis,
                  ),
                ),
            ],
            onChanged: (value) {
              if (value != null) {
                onInterestChanged(
                  value,
                );
              }
            },
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              const Expanded(
                child: Text(
                  'Distance',
                  style: TextStyle(
                    color:
                        PhilotesColors.navy,
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ),

              Text(
                'Usual preference: '
                '$preferredDistanceLabel',
                style: const TextStyle(
                  color:
                      PhilotesColors.silver,
                  fontSize: 10,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          DropdownButtonFormField<
              _DiscoverDistanceMode>(
            key: const Key(
              'discoverDistanceFilter',
            ),
            initialValue:
                distanceMode,
            decoration:
                _filterDecoration(),
            items: [
              for (
                final value
                    in _DiscoverDistanceMode
                        .values
              )
                DropdownMenuItem(
                  value: value,
                  child: Text(
                    _distanceLabel(
                      value,
                    ),
                  ),
                ),
            ],
            onChanged: (value) {
              if (value != null) {
                onDistanceChanged(
                  value,
                );
              }
            },
          ),

          const SizedBox(height: 10),

          const Text(
            'Recommended prioritizes your '
            'usual distance while still allowing '
            'an exceptional compatibility result '
            'to appear slightly farther away.',
            style: TextStyle(
              color:
                  PhilotesColors.silver,
              fontSize: 10,
              height: 1.45,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              TextButton(
                key: const Key(
                  'resetDiscoverFiltersButton',
                ),
                onPressed: onReset,
                child: const Text(
                  'Reset Filters',
                ),
              ),

              const Spacer(),

              TextButton(
                key: const Key(
                  'editPermanentPreferencesButton',
                ),
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Permanent discovery '
                        'preferences will be '
                        'editable under You '
                        'in a later frontend phase.',
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Edit permanent preferences',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  InputDecoration _filterDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(12),
        borderSide: BorderSide(
          color:
              PhilotesColors.gold
                  .withValues(
            alpha: 0.80,
          ),
          width: 1.3,
        ),
      ),
      focusedBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(12),
        borderSide: const BorderSide(
          color:
              PhilotesColors.gold,
          width: 1.8,
        ),
      ),
    );
  }
}


class _MemberGrid extends StatelessWidget {
  const _MemberGrid({
    required this.members,
    required this.wide,
    required this.preferredDistance,
    required this.onOpenMember,
  });

  final List<SuggestedMember> members;
  final bool wide;
  final int? preferredDistance;

  final ValueChanged<SuggestedMember>
  onOpenMember;

  @override
  Widget build(BuildContext context) {
    if (!wide) {
      return Column(
        children: [
          for (
            var index = 0;
            index < members.length;
            index++
          ) ...[
            _DiscoverMemberCard(
              member: members[index],
              preferredDistance:
                  preferredDistance,
              onOpenProfile: () {
                onOpenMember(
                  members[index],
                );
              },
            ),

            if (
              index <
              members.length - 1
            )
              const SizedBox(
                height: 14,
              ),
          ],
        ],
      );
    }

    return LayoutBuilder(
      builder: (
        BuildContext context,
        BoxConstraints constraints,
      ) {
        const gap = 16.0;

        final cardWidth =
            (constraints.maxWidth - gap) /
            2;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final member in members)
              SizedBox(
                width: cardWidth,
                child:
                    _DiscoverMemberCard(
                  member: member,
                  preferredDistance:
                      preferredDistance,
                  onOpenProfile: () {
                    onOpenMember(
                      member,
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}


class _DiscoverMemberCard
    extends StatelessWidget {
  const _DiscoverMemberCard({
    required this.member,
    required this.preferredDistance,
    required this.onOpenProfile,
  });

  final SuggestedMember member;
  final int? preferredDistance;
  final VoidCallback onOpenProfile;

  Color get _levelColor {
    switch (
      member.compatibility.level
    ) {
      case CompatibilityLevel.strong:
        return PhilotesColors.gold;

      case CompatibilityLevel.moderate:
        return PhilotesColors.silver;

      case CompatibilityLevel.limited:
        return PhilotesColors.bronze;
    }
  }

  bool get _outsidePreference {
    if (preferredDistance == null) {
      return false;
    }

    return member.distanceMiles >
        preferredDistance!;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: Key(
          'discoverMember-${member.id}',
        ),
        onTap: onOpenProfile,
        borderRadius:
            BorderRadius.circular(
          PhilotesDesign.cardRadius,
        ),
        child: Ink(
          padding: const EdgeInsets.all(
            18,
          ),
          decoration:
              PhilotesDesign
                  .primaryCardDecoration(),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch,
            children: [
              const Text(
                'COMPATIBILITY',
                style: TextStyle(
                  color:
                      PhilotesColors.navy,
                  fontSize: 10,
                  fontWeight:
                      FontWeight.w800,
                  letterSpacing: 1.1,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                member
                    .compatibility
                    .level
                    .label,
                style: TextStyle(
                  color: _levelColor,
                  fontSize: 17,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),

              const SizedBox(height: 18),

              Center(
                child: Container(
                  width: 96,
                  height: 96,
                  decoration:
                      BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        PhilotesColors.navy,
                    border: Border.all(
                      color:
                          PhilotesColors.gold,
                      width: 2.2,
                    ),
                  ),
                  alignment:
                      Alignment.center,
                  child: Text(
                    member.initials,
                    style:
                        const TextStyle(
                      color: Colors.white,
                      fontSize: 29,
                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Text(
                member.displayName,
                textAlign:
                    TextAlign.center,
                style: const TextStyle(
                  color:
                      PhilotesColors.navy,
                  fontSize: 20,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),

              const SizedBox(height: 18),

              Text(
                '${member.compatibility.sharedFavoriteInterests.length} '
                'favorite interests in common',
                style: const TextStyle(
                  color:
                      PhilotesColors.navy,
                  fontSize: 12,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                '${member.compatibility.sharedInterests.length} '
                'other shared interests',
                style: const TextStyle(
                  color:
                      PhilotesColors.silver,
                  fontSize: 11,
                ),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  const Icon(
                    Icons
                        .location_on_outlined,
                    color:
                        PhilotesColors.navy,
                    size: 16,
                  ),

                  const SizedBox(width: 5),

                  Text(
                    '${member.distanceMiles} '
                    'miles away',
                    style:
                        const TextStyle(
                      color:
                          PhilotesColors.navy,
                      fontSize: 11,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ],
              ),

              if (_outsidePreference) ...[
                const SizedBox(height: 6),

                Text(
                  'Slightly outside your '
                  '${preferredDistance!}-mile '
                  'preference',
                  key: Key(
                    'outsideDistance-${member.id}',
                  ),
                  style: const TextStyle(
                    color:
                        PhilotesColors.bronze,
                    fontSize: 10,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ],

              const SizedBox(height: 18),

              Align(
                alignment:
                    Alignment.centerRight,
                child: Text(
                  'View Profile  ›',
                  style: const TextStyle(
                    color:
                        PhilotesColors.navy,
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _NoResultsCard
    extends StatelessWidget {
  const _NoResultsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key(
        'discoverNoResults',
      ),
      padding:
          const EdgeInsets.all(22),
      decoration:
          PhilotesDesign
              .secondaryCardDecoration(),
      child: const Column(
        children: [
          Text(
            'No people match these '
            'temporary filters.',
            textAlign:
                TextAlign.center,
            style: TextStyle(
              color:
                  PhilotesColors.navy,
              fontSize: 15,
              fontWeight:
                  FontWeight.w700,
            ),
          ),

          SizedBox(height: 7),

          Text(
            'Try widening one of your '
            'Discover filters. Your '
            'permanent preferences have '
            'not been changed.',
            textAlign:
                TextAlign.center,
            style: TextStyle(
              color:
                  PhilotesColors.silver,
              fontSize: 11,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
