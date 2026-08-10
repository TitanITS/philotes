import 'package:flutter/material.dart';

import '../theme/philotes_colors.dart';
import '../widgets/community_mark.dart';
import '../widgets/titan_attribution.dart';
import 'onboarding/onboarding_intro_screen.dart';

class PhilotesWelcomeScreen extends StatelessWidget {
  const PhilotesWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              PhilotesColors.ivory,
              PhilotesColors.ivoryDark,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 36,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 620,
                ),
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
                      'Real people. Shared interests. Lifelong friendships.',
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
                      'Discover people who enjoy the things you enjoy, '
                      'build genuine connections, and create friendships '
                      'in a community designed around trust and safety.',
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
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Philotes sign in will begin here.',
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
                    const SizedBox(height: 42),
                    const TitanAttribution(),
                    const SizedBox(height: 16),
                    const Text(
                      'Friendship  •  Trust  •  Community  •  Connection',
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
