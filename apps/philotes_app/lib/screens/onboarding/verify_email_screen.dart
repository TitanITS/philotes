import 'package:flutter/material.dart';

import '../../services/auth/auth_service.dart';
import '../../services/auth/auth_services.dart';
import '../../theme/philotes_colors.dart';
import '../../widgets/philotes_brand_header.dart';
import 'basic_profile_screen.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key, required this.email});

  final String email;

  void _showTemporaryMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PhilotesColors.ivory,
      appBar: AppBar(
        backgroundColor: PhilotesColors.ivory,
        foregroundColor: PhilotesColors.navy,
        elevation: 0,
        title: const Text(
          'Join Philotes',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 36),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const PhilotesBrandHeader(),
                  const SizedBox(height: 34),

                  const Text(
                    'Check Your Email',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: PhilotesColors.navy,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Center(
                    child: Container(
                      width: 120,
                      height: 2,
                      decoration: BoxDecoration(
                        color: PhilotesColors.gold,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'We sent a verification link to:',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: PhilotesColors.silver,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: PhilotesColors.gold.withValues(alpha: 0.65),
                      ),
                    ),
                    child: Text(
                      email,
                      key: const Key('verificationEmailAddress'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: PhilotesColors.navy,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  TextButton.icon(
                    key: const Key('changeEmailButton'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: PhilotesColors.navy,
                    ),
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text(
                      'Wrong email address? Go back and correct it',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: PhilotesColors.gold.withValues(alpha: 0.65),
                      ),
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.open_in_new_outlined,
                          color: PhilotesColors.gold,
                          size: 28,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Open the message from Philotes and select '
                          'Verify Email.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: PhilotesColors.navy,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'The verification link will confirm that you '
                          'control this email address. After verification, '
                          'Philotes will continue your onboarding securely.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: PhilotesColors.silver,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  SizedBox(
                    height: 54,
                    child: OutlinedButton.icon(
                      key: const Key('resendVerificationButton'),
                      onPressed: () async {
                        try {
                          await AuthServices.current.resendVerification();
                          if (!context.mounted) return;
                          _showTemporaryMessage(
                            context,
                            'A new verification email has been sent.',
                          );
                        } on AuthApiException catch (e) {
                          if (!context.mounted) return;
                          _showTemporaryMessage(context, e.message);
                        }
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
                      icon: const Icon(Icons.refresh_outlined),
                      label: const Text(
                        'Resend Verification Email',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  SizedBox(
                    height: 54,
                    child: FilledButton.icon(
                      key: const Key('checkVerificationButton'),
                      onPressed: () async {
                        try {
                          final user =
                              await AuthServices.current.currentUser();
                          if (!context.mounted) return;
                          if (!user.emailVerified) {
                            _showTemporaryMessage(
                              context,
                              'Your email is not verified yet.',
                            );
                            return;
                          }
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const BasicProfileScreen(),
                            ),
                          );
                        } on AuthApiException catch (e) {
                          if (!context.mounted) return;
                          _showTemporaryMessage(context, e.message);
                        }
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: PhilotesColors.navy,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.verified_outlined),
                      label: const Text('I Have Verified My Email'),
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    'Didn\'t receive the message? Check your spam or junk '
                    'folder and confirm that the email address above is '
                    'correct.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: PhilotesColors.silver,
                      fontSize: 12,
                      height: 1.45,
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Friendship  •  Trust  •  Community  •  Connection',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: PhilotesColors.gold,
                      fontSize: 11,
                      letterSpacing: 1,
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
