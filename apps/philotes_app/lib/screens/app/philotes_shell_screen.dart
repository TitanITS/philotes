import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../data/development/development_member_fixture.dart';
import '../../models/onboarding_profile_data.dart';
import '../../theme/philotes_colors.dart';

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
        return const _HomeDestination();

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
        return const _HomeDestination();
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
              child: _buildCurrentDestination(),
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
        backgroundColor:
            Colors.white,
        indicatorColor:
            PhilotesColors.gold.withValues(
          alpha: 0.18,
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


class _PhilotesAppHeader extends StatelessWidget {
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
        border: Border(
          bottom: BorderSide(
            color:
                PhilotesColors.gold
                    .withValues(
              alpha: 0.35,
            ),
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
                width: 1.5,
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


class _HomeDestination extends StatelessWidget {
  const _HomeDestination();

  @override
  Widget build(BuildContext context) {
    final profile =
        OnboardingProfileData.instance;

    final name =
        profile.displayName.trim().isEmpty
            ? 'Friend'
            : profile.displayName.trim();

    return SingleChildScrollView(
      key: const Key(
        'philotesHomeScreen',
      ),
      padding: const EdgeInsets.fromLTRB(
        20,
        24,
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
              Text(
                'Welcome back, $name',
                key: const Key(
                  'homeWelcomeName',
                ),
                style: const TextStyle(
                  color:
                      PhilotesColors.navy,
                  fontSize: 28,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Here is what is happening '
                'in your Philotes community.',
                style: TextStyle(
                  color:
                      PhilotesColors.silver,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 26),

              const _SectionTitle(
                title: 'Your Community',
              ),

              const SizedBox(height: 12),

              const Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      label:
                          'New friend activity',
                      value: '3',
                      description:
                          'People to review',
                    ),
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: _SummaryCard(
                      label:
                          'Unread messages',
                      value: '2',
                      description:
                          'Conversations waiting',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 26),

              const _SectionTitle(
                title:
                    'People You May Enjoy Meeting',
              ),

              const SizedBox(height: 12),

              const _PeoplePreviewCard(),

              const SizedBox(height: 26),

              const _SectionTitle(
                title: 'Upcoming',
              ),

              const SizedBox(height: 12),

              const _UpcomingPlanCard(),

              const SizedBox(height: 26),

              const _SectionTitle(
                title: 'Things To Do Together',
              ),

              const SizedBox(height: 8),

              const Text(
                'Ideas based on the interests '
                'you selected during onboarding.',
                style: TextStyle(
                  color:
                      PhilotesColors.silver,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 12),

              _InterestSuggestions(
                interests:
                    profile.favoriteInterests,
              ),

              if (kDebugMode) ...[
                const SizedBox(height: 28),

                Container(
                  key: const Key(
                    'developmentAccountNotice',
                  ),
                  padding:
                      const EdgeInsets.all(14),
                  decoration:
                      BoxDecoration(
                    color:
                        PhilotesColors.navy
                            .withValues(
                      alpha: 0.05,
                    ),
                    borderRadius:
                        BorderRadius.circular(
                      12,
                    ),
                    border: Border.all(
                      color:
                          PhilotesColors.navy
                              .withValues(
                        alpha: 0.18,
                      ),
                    ),
                  ),
                  child: const Text(
                    'Development account: '
                    'community activity, message '
                    'counts, people previews, '
                    'and upcoming plans shown '
                    'here are simulated frontend '
                    'data. Your onboarding '
                    'profile information is '
                    'preserved when available.',
                    style: TextStyle(
                      color:
                          PhilotesColors.silver,
                      fontSize: 11,
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
  }
}


class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: PhilotesColors.navy,
        fontSize: 18,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}


class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.description,
  });

  final String label;
  final String value;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            Colors.white.withValues(
          alpha: 0.65,
        ),
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color:
              PhilotesColors.gold
                  .withValues(
            alpha: 0.45,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color:
                  PhilotesColors.silver,
              fontSize: 11,
              fontWeight:
                  FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            value,
            style: const TextStyle(
              color:
                  PhilotesColors.navy,
              fontSize: 28,
              fontWeight:
                  FontWeight.w800,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            description,
            style: const TextStyle(
              color:
                  PhilotesColors.silver,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}


class _PeoplePreviewCard extends StatelessWidget {
  const _PeoplePreviewCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key(
        'peoplePreviewCard',
      ),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color:
            Colors.white.withValues(
          alpha: 0.65,
        ),
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color:
              PhilotesColors.gold
                  .withValues(
            alpha: 0.50,
          ),
        ),
      ),
      child: Column(
        children: [
          const _PersonPreviewRow(
            initials: 'JM',
            name: 'Jordan M.',
            detail:
                'Movies • Sporting Events • Dining',
          ),

          const Divider(height: 24),

          const _PersonPreviewRow(
            initials: 'TR',
            name: 'Taylor R.',
            detail:
                'Bowling • Live Music • Road Trips',
          ),

          const Divider(height: 24),

          const _PersonPreviewRow(
            initials: 'CS',
            name: 'Casey S.',
            detail:
                'Technology • Museums • Movies',
          ),

          const SizedBox(height: 6),

          Align(
            alignment:
                Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Discover will be '
                      'built next.',
                    ),
                  ),
                );
              },
              style:
                  TextButton.styleFrom(
                foregroundColor:
                    PhilotesColors.navy,
              ),
              child: const Text(
                'Explore Discover',
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _PersonPreviewRow extends StatelessWidget {
  const _PersonPreviewRow({
    required this.initials,
    required this.name,
    required this.detail,
  });

  final String initials;
  final String name;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                PhilotesColors.navy
                    .withValues(
              alpha: 0.08,
            ),
            border: Border.all(
              color:
                  PhilotesColors.gold,
              width: 1.5,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            initials,
            style: const TextStyle(
              color:
                  PhilotesColors.navy,
              fontSize: 15,
              fontWeight:
                  FontWeight.w800,
            ),
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color:
                      PhilotesColors.navy,
                  fontSize: 15,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                detail,
                style: const TextStyle(
                  color:
                      PhilotesColors.silver,
                  fontSize: 11,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


class _UpcomingPlanCard extends StatelessWidget {
  const _UpcomingPlanCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key(
        'upcomingPlanCard',
      ),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color:
            Colors.white.withValues(
          alpha: 0.65,
        ),
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color:
              PhilotesColors.gold
                  .withValues(
            alpha: 0.50,
          ),
        ),
      ),
      child: const Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            'Saturday Evening',
            style: TextStyle(
              color:
                  PhilotesColors.gold,
              fontSize: 12,
              fontWeight:
                  FontWeight.w700,
            ),
          ),

          SizedBox(height: 6),

          Text(
            'Bowling with friends',
            style: TextStyle(
              color:
                  PhilotesColors.navy,
              fontSize: 17,
              fontWeight:
                  FontWeight.w800,
            ),
          ),

          SizedBox(height: 5),

          Text(
            '7:00 PM • Development example',
            style: TextStyle(
              color:
                  PhilotesColors.silver,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}


class _InterestSuggestions
    extends StatelessWidget {
  const _InterestSuggestions({
    required this.interests,
  });

  final List<String> interests;

  @override
  Widget build(BuildContext context) {
    final visibleInterests =
        interests.isEmpty
            ? <String>[
                'Sporting Events',
                'Movies',
                'Dining Out',
              ]
            : interests.take(5).toList();

    return Wrap(
      key: const Key(
        'homeInterestSuggestions',
      ),
      spacing: 9,
      runSpacing: 9,
      children: [
        for (final interest
            in visibleInterests)
          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color:
                  Colors.white.withValues(
                alpha: 0.70,
              ),
              borderRadius:
                  BorderRadius.circular(30),
              border: Border.all(
                color:
                    PhilotesColors.gold
                        .withValues(
                  alpha: 0.60,
                ),
              ),
            ),
            child: Text(
              interest,
              style: const TextStyle(
                color:
                    PhilotesColors.navy,
                fontSize: 12,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),
      ],
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
                    BoxDecoration(
                  color:
                      Colors.white
                          .withValues(
                    alpha: 0.65,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),
                  border: Border.all(
                    color:
                        PhilotesColors.gold
                            .withValues(
                      alpha: 0.50,
                    ),
                  ),
                ),
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
