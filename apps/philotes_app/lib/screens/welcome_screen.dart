import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../data/development/development_member_fixture.dart';
import '../theme/philotes_colors.dart';
import '../widgets/community_mark.dart';
import '../widgets/titan_attribution.dart';
import 'app/philotes_shell_screen.dart';
import 'onboarding/onboarding_intro_screen.dart';

class PhilotesWelcomeScreen extends StatelessWidget {
  const PhilotesWelcomeScreen({super.key});

  void _enterDeveloperAccount(BuildContext context) {
    DevelopmentMemberFixture.seedMissingProfileData();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (context) => const PhilotesShellScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [PhilotesColors.ivory, PhilotesColors.ivoryDark],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CommunityMark(),

                    const SizedBox(height: 34),

                    const Text(
                      'PHILOTES',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: PhilotesColors.navy,
                        fontSize: 46,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 7,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Container(
                      width: 220,
                      height: 1,
                      color: PhilotesColors.gold,
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      'A COMMUNITY FOR FRIENDSHIP',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: PhilotesColors.gold,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2.2,
                      ),
                    ),

                    const SizedBox(height: 34),

                    const Text(
                      'Real people. Shared interests. '
                      'Lifelong friendships.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: PhilotesColors.navy,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Discover people who enjoy '
                      'the things you enjoy, '
                      'build genuine connections, '
                      'and create friendships '
                      'in a community designed '
                      'around trust and safety.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: PhilotesColors.silver,
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 40),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton(
                        key: const Key('joinCommunityButton'),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (context) =>
                                  const PhilotesOnboardingIntroScreen(),
                            ),
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: PhilotesColors.navy,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Join the Community',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton(
                        key: const Key('signInButton'),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Philotes sign in '
                                'will begin here.',
                              ),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: PhilotesColors.navy,
                          side: const BorderSide(
                            color: PhilotesColors.gold,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    if (kDebugMode) ...[
                      const SizedBox(height: 32),

                      Container(
                        key: const Key('developerQuickEntrySection'),
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: PhilotesColors.navy.withValues(alpha: 0.045),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: PhilotesColors.silver.withValues(
                              alpha: 0.55,
                            ),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'DEVELOPMENT ONLY',
                              style: TextStyle(
                                color: PhilotesColors.silver,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.5,
                              ),
                            ),

                            const SizedBox(height: 12),

                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: OutlinedButton(
                                key: const Key('developerTestAccountButton'),
                                onPressed: () {
                                  _enterDeveloperAccount(context);
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: PhilotesColors.navy,
                                  side: const BorderSide(
                                    color: PhilotesColors.silver,
                                    width: 1.3,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Enter Developer '
                                  'Test Account',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            const Text(
                              'Bypasses onboarding '
                              'and loads simulated '
                              'development profile data.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: PhilotesColors.silver,
                                fontSize: 11,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 42),

                    const TitanAttribution(),

                    const SizedBox(height: 16),

                    const Text(
                      'Friendship  •  Trust  •  '
                      'Community  •  Connection',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: PhilotesColors.gold,
                        fontSize: 12,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
