from pathlib import Path
from datetime import datetime


SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = SCRIPT_DIR.parent.parent

APP_ROOT = PROJECT_ROOT / "apps" / "philotes_app"
LIB_ROOT = APP_ROOT / "lib"
TEST_ROOT = APP_ROOT / "test"

REPORT_PATH = (
    SCRIPT_DIR
    / "developerpatchscript_report.txt"
)

COLORS_FILE = (
    LIB_ROOT
    / "theme"
    / "philotes_colors.dart"
)

DESIGN_FILE = (
    LIB_ROOT
    / "theme"
    / "philotes_design.dart"
)

SHELL_FILE = (
    LIB_ROOT
    / "screens"
    / "app"
    / "philotes_shell_screen.dart"
)

HOME_FILE = (
    LIB_ROOT
    / "screens"
    / "home"
    / "philotes_home_screen.dart"
)

MEMBER_PROFILE_FILE = (
    LIB_ROOT
    / "screens"
    / "members"
    / "member_profile_screen.dart"
)

COMPATIBILITY_LEVEL_FILE = (
    LIB_ROOT
    / "models"
    / "compatibility"
    / "compatibility_level.dart"
)

COMPATIBILITY_RESULT_FILE = (
    LIB_ROOT
    / "models"
    / "compatibility"
    / "compatibility_result.dart"
)

SUGGESTED_MEMBER_FILE = (
    LIB_ROOT
    / "models"
    / "compatibility"
    / "suggested_member.dart"
)

COMPATIBILITY_SERVICE_FILE = (
    LIB_ROOT
    / "services"
    / "compatibility"
    / "compatibility_service.dart"
)

DEVELOPMENT_COMPATIBILITY_SERVICE_FILE = (
    LIB_ROOT
    / "services"
    / "compatibility"
    / "development_compatibility_service.dart"
)

DEVELOPMENT_HOME_FIXTURE_FILE = (
    LIB_ROOT
    / "data"
    / "development"
    / "development_home_fixture.dart"
)

HOME_SECTION_CARD_FILE = (
    LIB_ROOT
    / "widgets"
    / "home"
    / "home_section_card.dart"
)

SUGGESTED_MEMBER_CARD_FILE = (
    LIB_ROOT
    / "widgets"
    / "home"
    / "suggested_member_card.dart"
)

TODAY_CARD_FILE = (
    LIB_ROOT
    / "widgets"
    / "home"
    / "today_card.dart"
)

COMMUNITY_CARD_FILE = (
    LIB_ROOT
    / "widgets"
    / "home"
    / "community_summary_card.dart"
)

TEST_FILE = (
    TEST_ROOT
    / "home_v2_test.dart"
)


COLORS_CONTENT = r"""import 'package:flutter/material.dart';

abstract final class PhilotesColors {
  static const Color navy = Color(0xFF0B2341);
  static const Color gold = Color(0xFFC9A24B);
  static const Color ivory = Color(0xFFF8F4EB);
  static const Color ivoryDark = Color(0xFFF2EBDD);
  static const Color silver = Color(0xFF7B8794);
  static const Color bronze = Color(0xFF9A6A3A);
  static const Color blue = Color(0xFF315D88);
}
"""


DESIGN_CONTENT = r"""import 'package:flutter/material.dart';

import 'philotes_colors.dart';

abstract final class PhilotesDesign {
  static const double mobilePadding = 18;
  static const double widePadding = 28;

  static const double cardRadius = 16;
  static const double primaryBorderWidth = 1.7;
  static const double secondaryBorderWidth = 1.2;

  static const double sectionSpacing = 26;
  static const double contentMaxWidth = 1180;
  static const double wideBreakpoint = 900;

  static BoxDecoration primaryCardDecoration({
    Color? backgroundColor,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? Colors.white,
      borderRadius: BorderRadius.circular(
        cardRadius,
      ),
      border: Border.all(
        color: PhilotesColors.gold,
        width: primaryBorderWidth,
      ),
    );
  }

  static BoxDecoration secondaryCardDecoration({
    Color? backgroundColor,
  }) {
    return BoxDecoration(
      color:
          backgroundColor ??
          Colors.white.withValues(
            alpha: 0.82,
          ),
      borderRadius: BorderRadius.circular(
        cardRadius,
      ),
      border: Border.all(
        color: PhilotesColors.gold.withValues(
          alpha: 0.72,
        ),
        width: secondaryBorderWidth,
      ),
    );
  }

  static TextStyle get sectionHeading =>
      const TextStyle(
        color: PhilotesColors.navy,
        fontSize: 18,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.2,
      );

  static TextStyle get supportingText =>
      const TextStyle(
        color: PhilotesColors.silver,
        fontSize: 12,
        height: 1.45,
      );
}
"""


COMPATIBILITY_LEVEL_CONTENT = r"""enum CompatibilityLevel {
  strong,
  moderate,
  limited,
}

extension CompatibilityLevelLabel
    on CompatibilityLevel {
  String get label {
    switch (this) {
      case CompatibilityLevel.strong:
        return 'Strong';
      case CompatibilityLevel.moderate:
        return 'Moderate';
      case CompatibilityLevel.limited:
        return 'Limited';
    }
  }
}
"""


COMPATIBILITY_RESULT_CONTENT = r"""import 'compatibility_level.dart';

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
"""


SUGGESTED_MEMBER_CONTENT = r"""import 'compatibility_result.dart';

class SuggestedMember {
  const SuggestedMember({
    required this.id,
    required this.displayName,
    required this.initials,
    required this.introduction,
    required this.compatibility,
  });

  final String id;

  /// Public-facing name selected by the member.
  ///
  /// Philotes does not manufacture a last-name
  /// initial from private account information.
  final String displayName;

  final String initials;
  final String introduction;

  final CompatibilityResult compatibility;
}
"""


COMPATIBILITY_SERVICE_CONTENT = r"""import '../../models/compatibility/suggested_member.dart';
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
"""


DEVELOPMENT_COMPATIBILITY_SERVICE_CONTENT = r"""import '../../models/compatibility/compatibility_level.dart';
import '../../models/compatibility/compatibility_result.dart';
import '../../models/compatibility/suggested_member.dart';
import '../../models/onboarding_profile_data.dart';
import 'compatibility_service.dart';

class DevelopmentCompatibilityService
    extends CompatibilityService {
  const DevelopmentCompatibilityService();

  static const List<SuggestedMember>
  _developmentMembers = <SuggestedMember>[
    SuggestedMember(
      id: 'dev-jordan',
      displayName: 'Jordan',
      initials: 'J',
      introduction:
          'I enjoy getting out for activities, '
          'trying new places, attending sporting events, '
          'and spending time with a small group of friends.',
      compatibility: CompatibilityResult(
        score: 89,
        level: CompatibilityLevel.strong,
        sharedFavoriteInterests: <String>[
          'Going to Sporting Events',
          'Movies',
          'Axe Throwing',
        ],
        sharedInterests: <String>[
          'Dining Out',
          'Bowling',
          'Live Music',
          'Road Trips',
          'Museums',
          'Technology',
          'Local Events',
        ],
        reasons: <String>[
          '3 shared Like the Most interests',
          '7 additional shared interests',
          'Flexible social schedules',
          'Similar friendship style',
          'Compatible planning style',
        ],
        socialPaceAlignment: 'Strong',
        friendshipStyleAlignment: 'Strong',
        planningStyleAlignment: 'Strong',
        newActivityAlignment: 'Moderate',
        suggestedActivities: <String>[
          'Axe Throwing',
          'Sporting Events',
          'Movies',
          'Dining Out',
        ],
      ),
    ),
    SuggestedMember(
      id: 'dev-taylor',
      displayName: 'Taylor',
      initials: 'T',
      introduction:
          'I like live music, casual outings, '
          'weekend road trips, and discovering '
          'new activities with friends.',
      compatibility: CompatibilityResult(
        score: 76,
        level: CompatibilityLevel.moderate,
        sharedFavoriteInterests: <String>[
          'Bowling',
          'Live Music',
        ],
        sharedInterests: <String>[
          'Road Trips',
          'Movies',
          'Dining Out',
          'Local Events',
          'Museums',
        ],
        reasons: <String>[
          '2 shared Like the Most interests',
          '5 additional shared interests',
          'Compatible social pace',
          'Some overlap in friendship style',
        ],
        socialPaceAlignment: 'Strong',
        friendshipStyleAlignment: 'Moderate',
        planningStyleAlignment: 'Moderate',
        newActivityAlignment: 'Strong',
        suggestedActivities: <String>[
          'Bowling',
          'Live Music',
          'Road Trips',
          'Dining Out',
        ],
      ),
    ),
    SuggestedMember(
      id: 'dev-casey',
      displayName: 'Casey',
      initials: 'C',
      introduction:
          'I enjoy technology, museums, movies, '
          'and quieter social activities.',
      compatibility: CompatibilityResult(
        score: 58,
        level: CompatibilityLevel.limited,
        sharedFavoriteInterests: <String>[
          'Movies',
        ],
        sharedInterests: <String>[
          'Technology',
          'Museums',
          'Dining Out',
        ],
        reasons: <String>[
          '1 shared Like the Most interest',
          '3 additional shared interests',
          'Different preferred social pace',
        ],
        socialPaceAlignment: 'Limited',
        friendshipStyleAlignment: 'Moderate',
        planningStyleAlignment: 'Moderate',
        newActivityAlignment: 'Moderate',
        suggestedActivities: <String>[
          'Movies',
          'Museums',
          'Dining Out',
        ],
      ),
    ),
  ];

  @override
  List<SuggestedMember> suggestedMembers(
    OnboardingProfileData currentMember,
  ) {
    // Development-only compatibility results.
    //
    // No production scoring formula is implied by
    // these values. The frontend consumes this
    // service contract so a backend implementation
    // can replace it later.
    return _developmentMembers;
  }

  @override
  SuggestedMember? memberById(
    String memberId,
    OnboardingProfileData currentMember,
  ) {
    for (final member in _developmentMembers) {
      if (member.id == memberId) {
        return member;
      }
    }

    return null;
  }
}
"""


DEVELOPMENT_HOME_FIXTURE_CONTENT = r"""class DevelopmentHomeFixture {
  const DevelopmentHomeFixture._();

  static const bool hasPlanToday = false;

  static const String todayPlanTitle =
      'Bowling with Robert and Michael';

  static const String todayPlanTime =
      '7:00 PM';

  static const int unreadConversations = 2;

  static const int newConnections = 1;

  static const String outingFriendName =
      'Jordan';

  static const String outingActivity =
      'Axe Throwing';

  static const String outingMessage =
      'You and Jordan both enjoy Axe Throwing. '
      'We found a few nearby ideas you may want '
      'to turn into a future plan.';
}
"""


HOME_SECTION_CARD_CONTENT = r"""import 'package:flutter/material.dart';

import '../../theme/philotes_design.dart';

class HomeSectionCard extends StatelessWidget {
  const HomeSectionCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration:
          PhilotesDesign.primaryCardDecoration(),
      child: child,
    );
  }
}
"""


SUGGESTED_MEMBER_CARD_CONTENT = r"""import 'package:flutter/material.dart';

import '../../models/compatibility/compatibility_level.dart';
import '../../models/compatibility/suggested_member.dart';
import '../../theme/philotes_colors.dart';
import '../../theme/philotes_design.dart';

class SuggestedMemberCard extends StatelessWidget {
  const SuggestedMemberCard({
    super.key,
    required this.member,
    required this.onOpenProfile,
  });

  final SuggestedMember member;
  final VoidCallback onOpenProfile;

  Color get _compatibilityColor {
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: Key(
          'suggestedMember-${member.id}',
        ),
        onTap: onOpenProfile,
        borderRadius: BorderRadius.circular(
          PhilotesDesign.cardRadius,
        ),
        child: Ink(
          decoration:
              PhilotesDesign.primaryCardDecoration(),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch,
            children: [
              const Text(
                'COMPATIBILITY',
                style: TextStyle(
                  color: PhilotesColors.navy,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                member.compatibility.level.label,
                key: Key(
                  'compatibilityLabel-${member.id}',
                ),
                style: TextStyle(
                  color: _compatibilityColor,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 18),

              Center(
                child: Container(
                  width: 92,
                  height: 92,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: PhilotesColors.navy,
                    border: Border.all(
                      color: PhilotesColors.gold,
                      width: 2.2,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    member.initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Text(
                member.displayName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: PhilotesColors.navy,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                '${member.compatibility.sharedFavoriteInterests.length} '
                'favorite interests in common',
                style: const TextStyle(
                  color: PhilotesColors.navy,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                '${member.compatibility.sharedInterests.length} '
                'other shared interests',
                style: PhilotesDesign.supportingText,
              ),

              const SizedBox(height: 16),

              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'View Profile  ›',
                  style: TextStyle(
                    color: PhilotesColors.navy,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
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
"""


TODAY_CARD_CONTENT = r"""import 'package:flutter/material.dart';

import '../../data/development/development_home_fixture.dart';
import '../../theme/philotes_colors.dart';
import '../../theme/philotes_design.dart';
import 'home_section_card.dart';

class TodayCard extends StatelessWidget {
  const TodayCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return HomeSectionCard(
      key: const Key('todayCard'),
      child:
          DevelopmentHomeFixture.hasPlanToday
              ? const _TodayPlan()
              : const _TodaySuggestion(),
    );
  }
}


class _TodayPlan extends StatelessWidget {
  const _TodayPlan();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          DevelopmentHomeFixture.todayPlanTitle,
          style: TextStyle(
            color: PhilotesColors.navy,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 7),

        const Text(
          DevelopmentHomeFixture.todayPlanTime,
          style: TextStyle(
            color: PhilotesColors.gold,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 14),

        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                const SnackBar(
                  content: Text(
                    'The full Plans experience '
                    'will be built later.',
                  ),
                ),
              );
            },
            child: const Text(
              'View Plan',
            ),
          ),
        ),
      ],
    );
  }
}


class _TodaySuggestion extends StatelessWidget {
  const _TodaySuggestion();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          'Your day is open.',
          style: TextStyle(
            color: PhilotesColors.navy,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'Looking for something to do?',
          style: TextStyle(
            color: PhilotesColors.gold,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 10),

        const Text(
          DevelopmentHomeFixture.outingMessage,
          style: TextStyle(
            color: PhilotesColors.navy,
            fontSize: 12,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 14),

        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            key: const Key(
              'exploreOutingIdeaButton',
            ),
            onPressed: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                const SnackBar(
                  content: Text(
                    'Outing ideas and local places '
                    'will be connected during the '
                    'Plans frontend build.',
                  ),
                ),
              );
            },
            child: const Text(
              'Explore an Idea',
            ),
          ),
        ),
      ],
    );
  }
}
"""


COMMUNITY_CARD_CONTENT = r"""import 'package:flutter/material.dart';

import '../../data/development/development_home_fixture.dart';
import '../../theme/philotes_colors.dart';
import 'home_section_card.dart';

class CommunitySummaryCard
    extends StatelessWidget {
  const CommunitySummaryCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return HomeSectionCard(
      key: const Key(
        'communitySummaryCard',
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.stretch,
        children: [
          _CommunityRow(
            value:
                DevelopmentHomeFixture
                    .unreadConversations,
            label: 'unread conversations',
          ),

          const Divider(height: 26),

          _CommunityRow(
            value:
                DevelopmentHomeFixture
                    .newConnections,
            label: 'new connection',
          ),
        ],
      ),
    );
  }
}


class _CommunityRow extends StatelessWidget {
  const _CommunityRow({
    required this.value,
    required this.label,
  });

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: PhilotesColors.navy,
            border: Border.all(
              color: PhilotesColors.gold,
              width: 1.5,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            '$value',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: PhilotesColors.navy,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
"""


MEMBER_PROFILE_CONTENT = r"""import 'package:flutter/material.dart';

import '../../models/compatibility/compatibility_level.dart';
import '../../models/compatibility/suggested_member.dart';
import '../../theme/philotes_colors.dart';
import '../../theme/philotes_design.dart';

class MemberProfileScreen extends StatelessWidget {
  const MemberProfileScreen({
    super.key,
    required this.member,
  });

  final SuggestedMember member;

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
"""


HOME_CONTENT = r"""import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/compatibility/suggested_member.dart';
import '../../models/onboarding_profile_data.dart';
import '../../screens/members/member_profile_screen.dart';
import '../../services/compatibility/compatibility_service.dart';
import '../../services/compatibility/development_compatibility_service.dart';
import '../../theme/philotes_colors.dart';
import '../../theme/philotes_design.dart';
import '../../widgets/home/community_summary_card.dart';
import '../../widgets/home/suggested_member_card.dart';
import '../../widgets/home/today_card.dart';

class PhilotesHomeScreen extends StatelessWidget {
  const PhilotesHomeScreen({
    super.key,
    this.compatibilityService =
        const DevelopmentCompatibilityService(),
  });

  final CompatibilityService
  compatibilityService;

  void _openMember(
    BuildContext context,
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

  @override
  Widget build(BuildContext context) {
    final profile =
        OnboardingProfileData.instance;

    final name =
        profile.displayName.trim().isEmpty
            ? 'Friend'
            : profile.displayName.trim();

    final members =
        compatibilityService
            .suggestedMembers(profile)
            .take(2)
            .toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide =
            constraints.maxWidth >=
            PhilotesDesign.wideBreakpoint;

        return SingleChildScrollView(
          key: const Key(
            'philotesHomeScreen',
          ),
          padding: EdgeInsets.fromLTRB(
            isWide
                ? PhilotesDesign.widePadding
                : PhilotesDesign.mobilePadding,
            24,
            isWide
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
                  Text(
                    'Welcome back, $name',
                    key: const Key(
                      'homeWelcomeName',
                    ),
                    style: const TextStyle(
                      color:
                          PhilotesColors.navy,
                      fontSize: 29,
                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    "Here's what's happening today.",
                    style: TextStyle(
                      color:
                          PhilotesColors.silver,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 28),

                  if (isWide)
                    _WideHomeLayout(
                      members: members,
                      onOpenMember: (
                        member,
                      ) {
                        _openMember(
                          context,
                          member,
                        );
                      },
                    )
                  else
                    _MobileHomeLayout(
                      members: members,
                      onOpenMember: (
                        member,
                      ) {
                        _openMember(
                          context,
                          member,
                        );
                      },
                    ),

                  if (kDebugMode) ...[
                    const SizedBox(height: 28),

                    Container(
                      key: const Key(
                        'developmentAccountNotice',
                      ),
                      padding:
                          const EdgeInsets.all(
                        14,
                      ),
                      decoration:
                          PhilotesDesign
                              .secondaryCardDecoration(
                        backgroundColor:
                            PhilotesColors
                                .navy
                                .withValues(
                          alpha: 0.04,
                        ),
                      ),
                      child: const Text(
                        'Development environment: '
                        'suggested members, compatibility '
                        'results, community counts, and '
                        'Today content are simulated. '
                        'The production backend and final '
                        'compatibility engine have not '
                        'been connected yet.',
                        style: TextStyle(
                          color:
                              PhilotesColors
                                  .silver,
                          fontSize: 10,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}


class _MobileHomeLayout
    extends StatelessWidget {
  const _MobileHomeLayout({
    required this.members,
    required this.onOpenMember,
  });

  final List<SuggestedMember> members;
  final ValueChanged<SuggestedMember>
  onOpenMember;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.stretch,
      children: [
        _SuggestedPeopleSection(
          members: members,
          onOpenMember: onOpenMember,
        ),

        const SizedBox(
          height:
              PhilotesDesign.sectionSpacing,
        ),

        const _SectionHeading(
          title: 'Today',
        ),

        const SizedBox(height: 10),

        const TodayCard(),

        const SizedBox(
          height:
              PhilotesDesign.sectionSpacing,
        ),

        const _SectionHeading(
          title: 'Your Community',
        ),

        const SizedBox(height: 10),

        const CommunitySummaryCard(),
      ],
    );
  }
}


class _WideHomeLayout
    extends StatelessWidget {
  const _WideHomeLayout({
    required this.members,
    required this.onOpenMember,
  });

  final List<SuggestedMember> members;
  final ValueChanged<SuggestedMember>
  onOpenMember;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 7,
          child: _SuggestedPeopleSection(
            members: members,
            onOpenMember:
                onOpenMember,
            wide: true,
          ),
        ),

        const SizedBox(width: 26),

        const Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch,
            children: [
              _SectionHeading(
                title: 'Today',
              ),

              SizedBox(height: 10),

              TodayCard(),

              SizedBox(
                height:
                    PhilotesDesign
                        .sectionSpacing,
              ),

              _SectionHeading(
                title:
                    'Your Community',
              ),

              SizedBox(height: 10),

              CommunitySummaryCard(),
            ],
          ),
        ),
      ],
    );
  }
}


class _SuggestedPeopleSection
    extends StatelessWidget {
  const _SuggestedPeopleSection({
    required this.members,
    required this.onOpenMember,
    this.wide = false,
  });

  final List<SuggestedMember> members;
  final ValueChanged<SuggestedMember>
  onOpenMember;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const Key(
        'peoplePreviewCard',
      ),
      crossAxisAlignment:
          CrossAxisAlignment.stretch,
      children: [
        const _SectionHeading(
          title:
              'People You May Enjoy Meeting',
        ),

        const SizedBox(height: 5),

        const Text(
          'Based on your interests and '
          'friendship preferences.',
          style: TextStyle(
            color: PhilotesColors.silver,
            fontSize: 12,
          ),
        ),

        const SizedBox(height: 12),

        if (wide)
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              for (
                var index = 0;
                index < members.length;
                index++
              ) ...[
                Expanded(
                  child:
                      SuggestedMemberCard(
                    member:
                        members[index],
                    onOpenProfile: () {
                      onOpenMember(
                        members[index],
                      );
                    },
                  ),
                ),
                if (index <
                    members.length - 1)
                  const SizedBox(
                    width: 14,
                  ),
              ],
            ],
          )
        else
          Column(
            children: [
              for (
                var index = 0;
                index < members.length;
                index++
              ) ...[
                SuggestedMemberCard(
                  member:
                      members[index],
                  onOpenProfile: () {
                    onOpenMember(
                      members[index],
                    );
                  },
                ),
                if (index <
                    members.length - 1)
                  const SizedBox(
                    height: 14,
                  ),
              ],
            ],
          ),

        const SizedBox(height: 10),

        Align(
          alignment: Alignment.center,
          child: TextButton(
            key: const Key(
              'viewMorePeopleButton',
            ),
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(
                const SnackBar(
                  content: Text(
                    'The full Discover '
                    'experience will be '
                    'built next.',
                  ),
                ),
              );
            },
            child: const Text(
              'View More People',
            ),
          ),
        ),
      ],
    );
  }
}


class _SectionHeading
    extends StatelessWidget {
  const _SectionHeading({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 22,
          decoration: BoxDecoration(
            color: PhilotesColors.gold,
            borderRadius:
                BorderRadius.circular(4),
          ),
        ),

        const SizedBox(width: 9),

        Expanded(
          child: Text(
            title,
            style:
                PhilotesDesign
                    .sectionHeading,
          ),
        ),
      ],
    );
  }
}
"""


SHELL_CONTENT = r"""import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../data/development/development_member_fixture.dart';
import '../../screens/home/philotes_home_screen.dart';
import '../../theme/philotes_colors.dart';
import '../../theme/philotes_design.dart';

class PhilotesShellScreen extends StatefulWidget {
  const PhilotesShellScreen({super.key});

  @override
  State<PhilotesShellScreen> createState() =>
      _PhilotesShellScreenState();
}

class _PhilotesShellScreenState
    extends State<PhilotesShellScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    if (kDebugMode) {
      DevelopmentMemberFixture
          .seedMissingProfileData();
    }
  }

  void _selectDestination(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildCurrentDestination() {
    switch (_selectedIndex) {
      case 0:
        return const PhilotesHomeScreen();

      case 1:
        return const _DevelopmentDestination(
          title: 'Discover',
          description:
              'Discover will become the place '
              'to meet people who fit your '
              'friendship preferences and '
              'share meaningful interests.',
        );

      case 2:
        return const _DevelopmentDestination(
          title: 'Plans',
          description:
              'Plans will help friends decide '
              'what to do together and organize '
              'future activities and gatherings.',
        );

      case 3:
        return const _DevelopmentDestination(
          title: 'Messages',
          description:
              'Messages will contain your '
              'conversations with Philotes '
              'friends and future group chats.',
        );

      case 4:
        return const _DevelopmentDestination(
          title: 'You',
          description:
              'You will contain your profile, '
              'preferences, privacy controls, '
              'membership, and account settings.',
        );

      default:
        return const PhilotesHomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PhilotesColors.ivory,
      body: SafeArea(
        child: Column(
          children: [
            const _PhilotesAppHeader(),

            Expanded(
              child:
                  _buildCurrentDestination(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        key: const Key(
          'philotesMainNavigation',
        ),
        selectedIndex: _selectedIndex,
        onDestinationSelected:
            _selectDestination,
        backgroundColor: Colors.white,
        indicatorColor:
            PhilotesColors.gold.withValues(
          alpha: 0.24,
        ),
        labelBehavior:
            NavigationDestinationLabelBehavior
                .alwaysShow,
        destinations: const [
          NavigationDestination(
            key: Key('navHome'),
            icon: Icon(
              Icons.home_outlined,
            ),
            selectedIcon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            key: Key('navDiscover'),
            icon: Icon(
              Icons.person_search_outlined,
            ),
            selectedIcon: Icon(
              Icons.person_search,
            ),
            label: 'Discover',
          ),
          NavigationDestination(
            key: Key('navPlans'),
            icon: Icon(
              Icons.calendar_month_outlined,
            ),
            selectedIcon: Icon(
              Icons.calendar_month,
            ),
            label: 'Plans',
          ),
          NavigationDestination(
            key: Key('navMessages'),
            icon: Icon(
              Icons.chat_bubble_outline,
            ),
            selectedIcon: Icon(
              Icons.chat_bubble,
            ),
            label: 'Messages',
          ),
          NavigationDestination(
            key: Key('navYou'),
            icon: Icon(
              Icons.person_outline,
            ),
            selectedIcon: Icon(
              Icons.person,
            ),
            label: 'You',
          ),
        ],
      ),
    );
  }
}


class _PhilotesAppHeader
    extends StatelessWidget {
  const _PhilotesAppHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        14,
        20,
        14,
      ),
      decoration: BoxDecoration(
        color: PhilotesColors.ivory,
        border: const Border(
          bottom: BorderSide(
            color: PhilotesColors.gold,
            width:
                PhilotesDesign
                    .secondaryBorderWidth,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: PhilotesColors.navy,
              border: Border.all(
                color: PhilotesColors.gold,
                width: 1.7,
              ),
            ),
            child: const Icon(
              Icons.groups_outlined,
              color: Colors.white,
              size: 21,
            ),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'PHILOTES',
                  style: TextStyle(
                    color:
                        PhilotesColors.navy,
                    fontSize: 18,
                    fontWeight:
                        FontWeight.w900,
                    letterSpacing: 1.8,
                  ),
                ),

                SizedBox(height: 2),

                Text(
                  'A Community for Friendship',
                  style: TextStyle(
                    color:
                        PhilotesColors.gold,
                    fontSize: 11,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            key: const Key(
              'homeNotificationsButton',
            ),
            tooltip: 'Notifications',
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Notifications will be '
                    'connected during the '
                    'frontend build.',
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.notifications_none_outlined,
              color: PhilotesColors.navy,
            ),
          ),
        ],
      ),
    );
  }
}


class _DevelopmentDestination
    extends StatelessWidget {
  const _DevelopmentDestination({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        20,
        36,
        20,
        36,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(
            maxWidth: 620,
          ),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  color:
                      PhilotesColors.navy,
                  fontSize: 30,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),

              const SizedBox(height: 10),

              Container(
                width: 100,
                height: 2,
                color:
                    PhilotesColors.gold,
              ),

              const SizedBox(height: 26),

              Container(
                padding:
                    const EdgeInsets.all(
                  22,
                ),
                decoration:
                    PhilotesDesign
                        .primaryCardDecoration(),
                child: Column(
                  children: [
                    Text(
                      description,
                      textAlign:
                          TextAlign.center,
                      style:
                          const TextStyle(
                        color:
                            PhilotesColors
                                .navy,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    const Text(
                      'This section is part '
                      'of the next frontend '
                      'development phase.',
                      textAlign:
                          TextAlign.center,
                      style: TextStyle(
                        color:
                            PhilotesColors
                                .silver,
                        fontSize: 12,
                      ),
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


TEST_CONTENT = r"""import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:philotes/models/onboarding_profile_data.dart';
import 'package:philotes/screens/app/philotes_shell_screen.dart';

void main() {
  setUp(() {
    final profile =
        OnboardingProfileData.instance;

    profile.reset();
    profile.displayName = 'Test Friend';

    profile.favoriteInterests = <String>[
      'Going to Sporting Events',
      'Movies',
      'Dining Out',
      'Bowling',
      'Live Music',
    ];

    profile.socialFrequency =
        "Whenever we're both available";
  });

  testWidgets(
    'Home v2 shows two suggested people',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PhilotesShellScreen(),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text(
          'People You May Enjoy Meeting',
        ),
        findsOneWidget,
      );

      expect(
        find.text('Jordan'),
        findsOneWidget,
      );

      expect(
        find.text('Taylor'),
        findsOneWidget,
      );

      expect(
        find.text('Casey'),
        findsNothing,
      );
    },
  );

  testWidgets(
    'Home v2 uses compatibility labels',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PhilotesShellScreen(),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Strong'),
        findsOneWidget,
      );

      expect(
        find.text('Moderate'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Home does not contain Show Interest action',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PhilotesShellScreen(),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Show Interest'),
        findsNothing,
      );
    },
  );

  testWidgets(
    'Suggested member opens compatibility profile',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PhilotesShellScreen(),
        ),
      );

      await tester.pumpAndSettle();

      final jordan = find.byKey(
        const Key(
          'suggestedMember-dev-jordan',
        ),
      );

      await tester.ensureVisible(jordan);
      await tester.tap(jordan);
      await tester.pumpAndSettle();

      expect(
        find.byKey(
          const Key(
            'memberProfileScreen',
          ),
        ),
        findsOneWidget,
      );

      expect(
        find.text('89%'),
        findsOneWidget,
      );

      expect(
        find.text(
          'Why You May Connect',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Member profile contains decision action',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PhilotesShellScreen(),
        ),
      );

      await tester.pumpAndSettle();

      final jordan = find.byKey(
        const Key(
          'suggestedMember-dev-jordan',
        ),
      );

      await tester.ensureVisible(jordan);
      await tester.tap(jordan);
      await tester.pumpAndSettle();

      final showInterest = find.byKey(
        const Key(
          'showInterestButton',
        ),
      );

      await tester.scrollUntilVisible(
        showInterest,
        300,
        scrollable: find.byType(
          Scrollable,
        ).last,
      );

      expect(
        showInterest,
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Empty Today shows outing suggestion',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PhilotesShellScreen(),
        ),
      );

      await tester.pumpAndSettle();

      final today = find.byKey(
        const Key('todayCard'),
      );

      await tester.scrollUntilVisible(
        today,
        250,
        scrollable: find.byType(
          Scrollable,
        ).first,
      );

      expect(
        find.text(
          'Your day is open.',
        ),
        findsOneWidget,
      );

      expect(
        find.textContaining(
          'Axe Throwing',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Main navigation remains intact',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PhilotesShellScreen(),
        ),
      );

      expect(
        find.byKey(
          const Key('navHome'),
        ),
        findsOneWidget,
      );

      expect(
        find.byKey(
          const Key('navDiscover'),
        ),
        findsOneWidget,
      );

      expect(
        find.byKey(
          const Key('navPlans'),
        ),
        findsOneWidget,
      );

      expect(
        find.byKey(
          const Key('navMessages'),
        ),
        findsOneWidget,
      );

      expect(
        find.byKey(
          const Key('navYou'),
        ),
        findsOneWidget,
      );
    },
  );
}
"""


def write_file(
    path: Path,
    content: str,
) -> None:
    path.parent.mkdir(
        parents=True,
        exist_ok=True,
    )

    path.write_text(
        content,
        encoding="utf-8",
    )


def main() -> None:
    print()
    print("=" * 76)
    print(
        "PHILOTES HOME V2 + "
        "COMPATIBILITY PROFILE PATCH"
    )
    print("=" * 76)
    print()

    required = [
        APP_ROOT,
        COLORS_FILE,
        SHELL_FILE,
        (
            LIB_ROOT
            / "models"
            / "onboarding_profile_data.dart"
        ),
        (
            LIB_ROOT
            / "data"
            / "development"
            / "development_member_fixture.dart"
        ),
    ]

    for path in required:
        if not path.exists():
            print(
                f"FAIL: Required path not found: "
                f"{path}"
            )
            raise SystemExit(1)

    try:
        write_file(
            COLORS_FILE,
            COLORS_CONTENT,
        )

        write_file(
            DESIGN_FILE,
            DESIGN_CONTENT,
        )

        write_file(
            COMPATIBILITY_LEVEL_FILE,
            COMPATIBILITY_LEVEL_CONTENT,
        )

        write_file(
            COMPATIBILITY_RESULT_FILE,
            COMPATIBILITY_RESULT_CONTENT,
        )

        write_file(
            SUGGESTED_MEMBER_FILE,
            SUGGESTED_MEMBER_CONTENT,
        )

        write_file(
            COMPATIBILITY_SERVICE_FILE,
            COMPATIBILITY_SERVICE_CONTENT,
        )

        write_file(
            DEVELOPMENT_COMPATIBILITY_SERVICE_FILE,
            DEVELOPMENT_COMPATIBILITY_SERVICE_CONTENT,
        )

        write_file(
            DEVELOPMENT_HOME_FIXTURE_FILE,
            DEVELOPMENT_HOME_FIXTURE_CONTENT,
        )

        write_file(
            HOME_SECTION_CARD_FILE,
            HOME_SECTION_CARD_CONTENT,
        )

        write_file(
            SUGGESTED_MEMBER_CARD_FILE,
            SUGGESTED_MEMBER_CARD_CONTENT,
        )

        write_file(
            TODAY_CARD_FILE,
            TODAY_CARD_CONTENT,
        )

        write_file(
            COMMUNITY_CARD_FILE,
            COMMUNITY_CARD_CONTENT,
        )

        write_file(
            MEMBER_PROFILE_FILE,
            MEMBER_PROFILE_CONTENT,
        )

        write_file(
            HOME_FILE,
            HOME_CONTENT,
        )

        write_file(
            SHELL_FILE,
            SHELL_CONTENT,
        )

        write_file(
            TEST_FILE,
            TEST_CONTENT,
        )

    except Exception as exc:
        print()
        print(
            f"FAIL: {exc}"
        )
        raise SystemExit(1)

    shell_text = SHELL_FILE.read_text(
        encoding="utf-8",
    )

    home_text = HOME_FILE.read_text(
        encoding="utf-8",
    )

    profile_text = (
        MEMBER_PROFILE_FILE.read_text(
            encoding="utf-8",
        )
    )

    service_text = (
        DEVELOPMENT_COMPATIBILITY_SERVICE_FILE
        .read_text(
            encoding="utf-8",
        )
    )

    design_text = DESIGN_FILE.read_text(
        encoding="utf-8",
    )

    colors_text = COLORS_FILE.read_text(
        encoding="utf-8",
    )

    fixture_text = (
        DEVELOPMENT_HOME_FIXTURE_FILE
        .read_text(
            encoding="utf-8",
        )
    )

    test_text = TEST_FILE.read_text(
        encoding="utf-8",
    )

    checks = {
        "Philotes design system exists":
            DESIGN_FILE.exists(),

        "Bronze color centralized":
            "static const Color bronze"
            in colors_text,

        "Strong gold borders defined":
            "primaryBorderWidth = 1.7"
            in design_text,

        "Compatibility service boundary exists":
            COMPATIBILITY_SERVICE_FILE.exists(),

        "Development compatibility service exists":
            DEVELOPMENT_COMPATIBILITY_SERVICE_FILE.exists(),

        "Development service disclaimer exists":
            "No production scoring formula"
            in service_text,

        "Suggested members use display names only":
            "displayName: 'Jordan'"
            in service_text
            and "Jordan M."
            not in service_text,

        "Strong compatibility present":
            "CompatibilityLevel.strong"
            in service_text,

        "Moderate compatibility present":
            "CompatibilityLevel.moderate"
            in service_text,

        "Limited compatibility present":
            "CompatibilityLevel.limited"
            in service_text,

        "Home v2 exists":
            HOME_FILE.exists(),

        "Home supports responsive layout":
            "wideBreakpoint"
            in home_text,

        "Wide Home layout exists":
            "_WideHomeLayout"
            in home_text,

        "Mobile Home layout exists":
            "_MobileHomeLayout"
            in home_text,

        "Only two people shown on Home":
            ".take(2)"
            in home_text,

        "Home has no Show Interest":
            "Show Interest"
            not in home_text,

        "Today empty-state fixture exists":
            "hasPlanToday = false"
            in fixture_text,

        "Today outing suggestion exists":
            "Axe Throwing"
            in fixture_text,

        "Member Profile exists":
            MEMBER_PROFILE_FILE.exists(),

        "Member Profile shows percentage":
            "compatibilityPercentage"
            in profile_text,

        "Member Profile explains compatibility":
            "Why You May Connect"
            in profile_text,

        "Member Profile shows shared favorites":
            "Shared Favorites"
            in profile_text,

        "Member Profile shows other interests":
            "Other Shared Interests"
            in profile_text,

        "Member Profile shows friendship compatibility":
            "Friendship Compatibility"
            in profile_text,

        "Member Profile shows activity ideas":
            "Things You May Enjoy Together"
            in profile_text,

        "Decision action lives on profile":
            "showInterestButton"
            in profile_text,

        "Shell imports Home v2":
            "philotes_home_screen.dart"
            in shell_text,

        "Home navigation retained":
            "navHome"
            in shell_text,

        "Discover navigation retained":
            "navDiscover"
            in shell_text,

        "Plans navigation retained":
            "navPlans"
            in shell_text,

        "Messages navigation retained":
            "navMessages"
            in shell_text,

        "You navigation retained":
            "navYou"
            in shell_text,

        "Dedicated Home v2 tests created":
            TEST_FILE.exists(),

        "Tests verify no Home decision action":
            "Home does not contain Show Interest action"
            in test_text,

        "Tests verify profile navigation":
            "Suggested member opens compatibility profile"
            in test_text,
    }

    all_passed = True

    report = [
        "PHILOTES HOME V2 + "
        "COMPATIBILITY PROFILE PATCH REPORT",
        "=" * 76,
        "Generated: "
        + datetime.now().isoformat(
            timespec="seconds",
        ),
        f"Project root: {PROJECT_ROOT}",
        "",
    ]

    for description, passed in checks.items():
        status = (
            "PASS"
            if passed
            else "FAIL"
        )

        print(
            f"{status}: {description}"
        )

        report.append(
            f"{status}: {description}"
        )

        if not passed:
            all_passed = False

    report.extend(
        [
            "",
            "OVERALL: "
            + (
                "PASS"
                if all_passed
                else "FAIL"
            ),
            "",
            "HOME V2 SUMMARY",
            "-" * 76,
            "- Separates Home from the application shell.",
            "- Uses one responsive screen for mobile and wide/web layouts.",
            "- Uses two suggested people on Home.",
            "- Uses Strong / Moderate / Limited compatibility labels.",
            "- Uses Gold / Silver / Bronze compatibility colors.",
            "- Uses display names only; no manufactured last-name initials.",
            "- Keeps Like / Show Interest decisions off Home.",
            "- Opens a dedicated Member Compatibility Profile.",
            "- Shows the detailed percentage only on the Member Profile.",
            "- Explains why two members may connect.",
            "- Shows shared favorite and additional interests.",
            "- Shows friendship preference alignment.",
            "- Shows contextual activities on the Member Profile.",
            "- Uses Today rather than a weekly Home calendar.",
            "- Uses a suggested outing when Today has no plans.",
            "- Leaves local-business sponsorship/Featured placement for later.",
            "- Uses simulated compatibility data behind a service boundary.",
            "- Does NOT implement the production compatibility engine.",
            "- Does NOT implement backend friendship requests.",
            "- Keeps Discover, Plans, Messages, and You as development placeholders.",
        ]
    )

    REPORT_PATH.write_text(
        "\n".join(report) + "\n",
        encoding="utf-8",
    )

    print()
    print(
        f"Report: {REPORT_PATH}"
    )
    print()

    print(
        "OVERALL: "
        + (
            "PASS"
            if all_passed
            else "FAIL"
        )
    )

    if not all_passed:
        raise SystemExit(1)


if __name__ == "__main__":
    main()