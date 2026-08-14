import 'package:flutter/material.dart';

import '../../models/onboarding_profile_data.dart';
import '../../theme/philotes_colors.dart';
import '../app/philotes_shell_screen.dart';

class WelcomeToPhilotesScreen extends StatelessWidget {
  const WelcomeToPhilotesScreen({super.key});

  void _enterPhilotes(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (context) => const PhilotesShellScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = OnboardingProfileData.instance;

    final displayName = profile.displayName.trim().isEmpty
        ? 'Friend'
        : profile.displayName.trim();

    return Scaffold(
      backgroundColor: PhilotesColors.ivory,
      appBar: AppBar(
        backgroundColor: PhilotesColors.ivory,
        foregroundColor: PhilotesColors.navy,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Philotes',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 36),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //
                  // COMPLETION EMBLEM
                  //
                  Center(
                    child: Container(
                      key: const Key('welcomeCompletionEmblem'),
                      width: 118,
                      height: 118,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: PhilotesColors.navy,
                        border: Border.all(
                          color: PhilotesColors.gold,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: PhilotesColors.navy.withValues(alpha: 0.12),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.people_alt_outlined,
                        color: Colors.white,
                        size: 54,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'PHILOTES',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: PhilotesColors.navy,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.2,
                    ),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    'A Community for Friendship',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: PhilotesColors.gold,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),

                  const SizedBox(height: 26),

                  Text(
                    'Welcome to Philotes, $displayName!',
                    key: const Key('welcomeDisplayName'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: PhilotesColors.navy,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Your profile is ready.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: PhilotesColors.gold,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'You are now part of a community built '
                    'around friendship, shared interests, trust, '
                    'and meaningful connections.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: PhilotesColors.silver,
                      fontSize: 14,
                      height: 1.55,
                    ),
                  ),

                  const SizedBox(height: 30),

                  const _WelcomeFeatureCard(
                    key: Key('discoverPeopleCard'),
                    icon: Icons.person_search_outlined,
                    title: 'Discover People',
                    description:
                        'Meet people nearby or online who '
                        'share your interests, activities, '
                        'and friendship preferences.',
                  ),

                  const SizedBox(height: 14),

                  const _WelcomeFeatureCard(
                    key: Key('startConversationsCard'),
                    icon: Icons.chat_bubble_outline,
                    title: 'Start Conversations',
                    description:
                        'Get to know potential friends through '
                        'Philotes before deciding whether you '
                        'would like to meet.',
                  ),

                  const SizedBox(height: 14),

                  const _WelcomeFeatureCard(
                    key: Key('makePlansTogetherCard'),
                    icon: Icons.event_available_outlined,
                    title: 'Make Plans Together',
                    description:
                        'Find ideas for restaurants, movies, '
                        'sporting events, recreation, entertainment, '
                        'and other activities you may enjoy together.',
                  ),

                  const SizedBox(height: 24),

                  //
                  // SAFETY REMINDER
                  //
                  Container(
                    key: const Key('welcomeSafetyReminder'),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: PhilotesColors.gold.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: PhilotesColors.gold.withValues(alpha: 0.70),
                      ),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.shield_outlined,
                              color: PhilotesColors.gold,
                              size: 23,
                            ),
                            SizedBox(width: 9),
                            Expanded(
                              child: Text(
                                'A Friendly Reminder',
                                style: TextStyle(
                                  color: PhilotesColors.navy,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 12),

                        Text(
                          'Take your time getting to know new '
                          'people. Protect your personal information, '
                          'trust your judgment, and choose a safe '
                          'public place when meeting someone for '
                          'the first time.',
                          style: TextStyle(
                            color: PhilotesColors.navy,
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),

                        SizedBox(height: 10),

                        Text(
                          'Philotes helps create introductions. '
                          'You always decide who you connect with '
                          'and when you are ready to meet.',
                          style: TextStyle(
                            color: PhilotesColors.silver,
                            fontSize: 12,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  //
                  // ENTER PHILOTES
                  //
                  SizedBox(
                    height: 60,
                    child: FilledButton.icon(
                      key: const Key('enterPhilotesButton'),
                      onPressed: () {
                        _enterPhilotes(context);
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: PhilotesColors.navy,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(
                            color: PhilotesColors.gold,
                            width: 1.5,
                          ),
                        ),
                      ),
                      icon: const Icon(Icons.groups_outlined, size: 23),
                      label: const Text(
                        'Enter Philotes',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  //
                  // PHILOTES VALUES
                  //
                  const Text(
                    'Friendship  •  Trust  •  Community  •  Connection',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: PhilotesColors.gold,
                      fontSize: 11,
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(height: 18),

                  //
                  // TITAN BRAND ATTRIBUTION
                  //
                  Row(
                    key: const Key('titanAttribution'),
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'BROUGHT TO YOU BY',
                        style: TextStyle(
                          color: PhilotesColors.navy,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2.0,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Image.asset(
                        'assets/branding/titan-logo.png',
                        height: 22,
                        fit: BoxFit.contain,
                      ),

                      const SizedBox(width: 10),

                      const Text(
                        'TITAN',
                        style: TextStyle(
                          color: PhilotesColors.navy,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ],
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

class _WelcomeFeatureCard extends StatelessWidget {
  const _WelcomeFeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PhilotesColors.gold.withValues(alpha: 0.55)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: PhilotesColors.navy,
              border: Border.all(color: PhilotesColors.gold, width: 1.5),
            ),
            child: Icon(icon, color: Colors.white, size: 23),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: PhilotesColors.navy,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  description,
                  style: const TextStyle(
                    color: PhilotesColors.silver,
                    fontSize: 13,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
