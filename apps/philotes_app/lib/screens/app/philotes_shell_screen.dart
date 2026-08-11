import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../data/development/development_member_fixture.dart';
import '../../screens/home/philotes_home_screen.dart';
import '../../screens/discover/discover_screen.dart';
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
        return const DiscoverScreen();

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
