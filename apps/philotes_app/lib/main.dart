import 'package:flutter/material.dart';

void main() {
  runApp(const PhilotesApp());
}

class PhilotesApp extends StatelessWidget {
  const PhilotesApp({super.key});

  static const Color philotesNavy = Color(0xFF0B2341);
  static const Color philotesGold = Color(0xFFC9A24B);
  static const Color philotesIvory = Color(0xFFF8F4EB);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Philotes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: philotesIvory,
        colorScheme: ColorScheme.fromSeed(
          seedColor: philotesNavy,
          primary: philotesNavy,
          secondary: philotesGold,
          surface: philotesIvory,
        ),
      ),
      home: const PhilotesWelcomeScreen(),
    );
  }
}

class PhilotesWelcomeScreen extends StatelessWidget {
  const PhilotesWelcomeScreen({super.key});

  static const Color philotesNavy = Color(0xFF0B2341);
  static const Color philotesGold = Color(0xFFC9A24B);
  static const Color philotesIvory = Color(0xFFF8F4EB);
  static const Color philotesSilver = Color(0xFF7B8794);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [philotesIvory, Color(0xFFF2EBDD)],
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
                    const _CommunityMark(),

                    const SizedBox(height: 34),

                    const Text(
                      'PHILOTES',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: philotesNavy,
                        fontSize: 46,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 7,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Container(width: 220, height: 1, color: philotesGold),

                    const SizedBox(height: 18),

                    const Text(
                      'A COMMUNITY FOR FRIENDSHIP',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: philotesGold,
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
                        color: philotesNavy,
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
                        color: philotesSilver,
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Philotes onboarding will begin here.',
                              ),
                            ),
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: philotesNavy,
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
                          foregroundColor: philotesNavy,
                          side: const BorderSide(
                            color: philotesGold,
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

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'BROUGHT TO YOU BY',
                          style: TextStyle(
                            color: philotesNavy,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 3,
                          ),
                        ),

                        const SizedBox(width: 7),

                        Image.asset(
                          'assets/branding/titan-logo.png',
                          height: 22,
                          width: 22,
                          fit: BoxFit.contain,
                        ),

                        const SizedBox(width: 4),

                        const Text(
                          'TITAN',
                          style: TextStyle(
                            color: philotesNavy,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 3,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Friendship  •  Trust  •  Community  •  Connection',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: philotesGold,
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

class _CommunityMark extends StatelessWidget {
  const _CommunityMark();

  static const Color philotesNavy = Color(0xFF0B2341);
  static const Color philotesGold = Color(0xFFC9A24B);
  static const Color philotesSilver = Color(0xFF7B8794);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: philotesGold, width: 2),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Positioned(
            top: 25,
            child: _PersonDot(color: philotesNavy, size: 30),
          ),

          const Positioned(
            left: 26,
            top: 62,
            child: _PersonDot(color: Color(0xFF315D88), size: 28),
          ),

          const Positioned(
            right: 26,
            top: 62,
            child: _PersonDot(color: philotesGold, size: 28),
          ),

          const Positioned(
            bottom: 25,
            child: _PersonDot(color: philotesSilver, size: 30),
          ),

          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: philotesGold, width: 1.5),
            ),
            child: const Icon(
              Icons.people_alt_outlined,
              color: philotesNavy,
              size: 31,
            ),
          ),
        ],
      ),
    );
  }
}

class _PersonDot extends StatelessWidget {
  const _PersonDot({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
