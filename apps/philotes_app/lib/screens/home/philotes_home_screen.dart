import 'package:flutter/foundation.dart';
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
    this.compatibilityService = const DevelopmentCompatibilityService(),
    this.onOpenMessages,
  });

  final CompatibilityService compatibilityService;

  final VoidCallback? onOpenMessages;

  void _openMember(BuildContext context, SuggestedMember member) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => MemberProfileScreen(member: member),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = OnboardingProfileData.instance;

    final name = profile.displayName.trim().isEmpty
        ? 'Friend'
        : profile.displayName.trim();

    final members = compatibilityService
        .suggestedMembers(profile)
        .take(2)
        .toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= PhilotesDesign.wideBreakpoint;

        return SingleChildScrollView(
          key: const Key('philotesHomeScreen'),
          padding: EdgeInsets.fromLTRB(
            isWide ? PhilotesDesign.widePadding : PhilotesDesign.mobilePadding,
            24,
            isWide ? PhilotesDesign.widePadding : PhilotesDesign.mobilePadding,
            40,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: PhilotesDesign.contentMaxWidth,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Welcome back, $name',
                    key: const Key('homeWelcomeName'),
                    style: const TextStyle(
                      color: PhilotesColors.navy,
                      fontSize: 29,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    "Here's what's happening today.",
                    style: TextStyle(
                      color: PhilotesColors.silver,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 28),

                  if (isWide)
                    _WideHomeLayout(
                      members: members,
                      onOpenMessages: onOpenMessages,
                      onOpenMember: (member) {
                        _openMember(context, member);
                      },
                    )
                  else
                    _MobileHomeLayout(
                      members: members,
                      onOpenMessages: onOpenMessages,
                      onOpenMember: (member) {
                        _openMember(context, member);
                      },
                    ),

                  if (kDebugMode) ...[
                    const SizedBox(height: 28),

                    Container(
                      key: const Key('developmentAccountNotice'),
                      padding: const EdgeInsets.all(14),
                      decoration: PhilotesDesign.secondaryCardDecoration(
                        backgroundColor: PhilotesColors.navy.withValues(
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
                          color: PhilotesColors.silver,
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

class _MobileHomeLayout extends StatelessWidget {
  const _MobileHomeLayout({
    required this.members,
    required this.onOpenMember,
    this.onOpenMessages,
  });

  final List<SuggestedMember> members;
  final ValueChanged<SuggestedMember> onOpenMember;
  final VoidCallback? onOpenMessages;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SuggestedPeopleSection(members: members, onOpenMember: onOpenMember),

        const SizedBox(height: PhilotesDesign.sectionSpacing),

        const _SectionHeading(title: 'Today'),

        const SizedBox(height: 10),

        const TodayCard(),

        const SizedBox(height: PhilotesDesign.sectionSpacing),

        const _SectionHeading(title: 'Your Community'),

        const SizedBox(height: 10),

        CommunitySummaryCard(onUnreadConversationsTap: onOpenMessages),
      ],
    );
  }
}

class _WideHomeLayout extends StatelessWidget {
  const _WideHomeLayout({
    required this.members,
    required this.onOpenMember,
    this.onOpenMessages,
  });

  final List<SuggestedMember> members;
  final ValueChanged<SuggestedMember> onOpenMember;
  final VoidCallback? onOpenMessages;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 7,
          child: _SuggestedPeopleSection(
            members: members,
            onOpenMember: onOpenMember,
            wide: true,
          ),
        ),

        const SizedBox(width: 26),

        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SectionHeading(title: 'Today'),

              SizedBox(height: 10),

              TodayCard(),

              SizedBox(height: PhilotesDesign.sectionSpacing),

              _SectionHeading(title: 'Your Community'),

              SizedBox(height: 10),

              CommunitySummaryCard(onUnreadConversationsTap: onOpenMessages),
            ],
          ),
        ),
      ],
    );
  }
}

class _SuggestedPeopleSection extends StatelessWidget {
  const _SuggestedPeopleSection({
    required this.members,
    required this.onOpenMember,
    this.wide = false,
  });

  final List<SuggestedMember> members;
  final ValueChanged<SuggestedMember> onOpenMember;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const Key('peoplePreviewCard'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionHeading(title: 'People You May Enjoy Meeting'),

        const SizedBox(height: 5),

        const Text(
          'Based on your interests and '
          'friendship preferences.',
          style: TextStyle(color: PhilotesColors.silver, fontSize: 12),
        ),

        const SizedBox(height: 12),

        if (wide)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var index = 0; index < members.length; index++) ...[
                Expanded(
                  child: SuggestedMemberCard(
                    member: members[index],
                    onOpenProfile: () {
                      onOpenMember(members[index]);
                    },
                  ),
                ),
                if (index < members.length - 1) const SizedBox(width: 14),
              ],
            ],
          )
        else
          Column(
            children: [
              for (var index = 0; index < members.length; index++) ...[
                SuggestedMemberCard(
                  member: members[index],
                  onOpenProfile: () {
                    onOpenMember(members[index]);
                  },
                ),
                if (index < members.length - 1) const SizedBox(height: 14),
              ],
            ],
          ),

        const SizedBox(height: 10),

        Align(
          alignment: Alignment.center,
          child: TextButton(
            key: const Key('viewMorePeopleButton'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'The full Discover '
                    'experience will be '
                    'built next.',
                  ),
                ),
              );
            },
            child: const Text('View More People'),
          ),
        ),
      ],
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title});

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
            borderRadius: BorderRadius.circular(4),
          ),
        ),

        const SizedBox(width: 9),

        Expanded(child: Text(title, style: PhilotesDesign.sectionHeading)),
      ],
    );
  }
}
