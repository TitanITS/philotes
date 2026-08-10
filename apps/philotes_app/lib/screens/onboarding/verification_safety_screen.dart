import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../theme/philotes_colors.dart';

class VerificationSafetyScreen extends StatefulWidget {
  const VerificationSafetyScreen({super.key});

  @override
  State<VerificationSafetyScreen> createState() =>
      _VerificationSafetyScreenState();
}

class _VerificationSafetyScreenState
    extends State<VerificationSafetyScreen> {
  bool _meetingSafetyExpanded = false;
  bool _safetyAcknowledged = false;
  bool _showValidation = false;

  void _continue() {
    if (!_safetyAcknowledged) {
      setState(() {
        _showValidation = true;
      });

      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Profile Photo will be the next onboarding step.',
        ),
      ),
    );
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
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              20,
              20,
              20,
              36,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 700,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Verification & Safety',
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
                      width: 150,
                      height: 2,
                      decoration: BoxDecoration(
                        color: PhilotesColors.gold,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Philotes is built for real people and safer friendships.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: PhilotesColors.navy,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'A healthy community depends on authenticity, '
                    'respect, privacy, and members looking out for '
                    'themselves and each other.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: PhilotesColors.silver,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 26),

                  _SafetySection(
                    icon: Icons.mark_email_read_outlined,
                    title: 'Email Verification',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (kDebugMode)
                          Container(
                            key: const Key(
                              'developmentEmailVerificationStatus',
                            ),
                            padding: const EdgeInsets.all(13),
                            decoration: BoxDecoration(
                              color: PhilotesColors.navy.withValues(
                                alpha: 0.06,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: PhilotesColors.navy.withValues(
                                  alpha: 0.45,
                                ),
                              ),
                            ),
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.developer_mode_outlined,
                                  color: PhilotesColors.navy,
                                  size: 21,
                                ),
                                SizedBox(width: 9),
                                Expanded(
                                  child: Text(
                                    'Development mode: real email '
                                    'verification is not connected yet. '
                                    'Production onboarding will require '
                                    'successful email verification before '
                                    'reaching this page.',
                                    style: TextStyle(
                                      color: PhilotesColors.navy,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      height: 1.45,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.verified_outlined,
                                color: PhilotesColors.gold,
                                size: 23,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Your verified email helps protect '
                                  'your account and supports community '
                                  'authenticity.',
                                  style: TextStyle(
                                    color: PhilotesColors.navy,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    height: 1.45,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  const _SafetySection(
                    icon: Icons.person_search_outlined,
                    title: 'Profile Authenticity',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Be yourself.',
                          style: TextStyle(
                            color: PhilotesColors.navy,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Use accurate profile information and authentic '
                          'photos. Misleading identities, impersonation, '
                          'and deceptive profiles do not belong in the '
                          'Philotes community.',
                          style: TextStyle(
                            color: PhilotesColors.silver,
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Government-issued identification is not '
                          'required during V1 onboarding. Additional '
                          'optional verification may be introduced later.',
                          style: TextStyle(
                            color: PhilotesColors.silver,
                            fontSize: 12,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  const _SafetySection(
                    icon: Icons.health_and_safety_outlined,
                    title: 'Your Safety Tools',
                    child: Column(
                      children: [
                        _SafetyToolRow(
                          icon: Icons.block_outlined,
                          title: 'Block',
                          description:
                              'Stop another member from interacting '
                              'with you.',
                        ),
                        SizedBox(height: 13),
                        _SafetyToolRow(
                          icon: Icons.flag_outlined,
                          title: 'Report',
                          description:
                              'Tell Philotes about suspicious, abusive, '
                              'or inappropriate behavior.',
                        ),
                        SizedBox(height: 13),
                        _SafetyToolRow(
                          icon: Icons.lock_outline,
                          title: 'Privacy',
                          description:
                              'Control what information you share '
                              'with the community.',
                        ),
                        SizedBox(height: 13),
                        _SafetyToolRow(
                          icon: Icons.shield_outlined,
                          title: 'Community Moderation',
                          description:
                              'Philotes can review reports and take '
                              'appropriate action to protect the community.',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  const _ScamWarning(),

                  const SizedBox(height: 18),

                  Material(
                    color: Colors.white.withValues(alpha: 0.55),
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: PhilotesColors.gold.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                    child: InkWell(
                      key: const Key('meetingSafetyToggle'),
                      onTap: () {
                        setState(() {
                          _meetingSafetyExpanded =
                              !_meetingSafetyExpanded;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: PhilotesColors.navy,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: PhilotesColors.gold,
                                      width: 1.7,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.people_outline,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),

                                const SizedBox(width: 12),

                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Meeting Safely',
                                        style: TextStyle(
                                          color: PhilotesColors.navy,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Practical tips for meeting '
                                        'someone new.',
                                        style: TextStyle(
                                          color:
                                              PhilotesColors.silver,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Icon(
                                  _meetingSafetyExpanded
                                      ? Icons.expand_less
                                      : Icons.expand_more,
                                  color: PhilotesColors.gold,
                                ),
                              ],
                            ),

                            if (_meetingSafetyExpanded) ...[
                              const SizedBox(height: 18),
                              const Divider(
                                color: PhilotesColors.gold,
                              ),
                              const SizedBox(height: 12),
                              const _SafetyTip(
                                text:
                                    'Meet in a public place when meeting '
                                    'someone for the first time.',
                              ),
                              const _SafetyTip(
                                text:
                                    'Tell someone you trust where you are '
                                    'going and who you are meeting.',
                              ),
                              const _SafetyTip(
                                text:
                                    'Arrange your own transportation when '
                                    'possible so you can leave independently.',
                              ),
                              const _SafetyTip(
                                text:
                                    'Protect sensitive personal and '
                                    'financial information.',
                              ),
                              const _SafetyTip(
                                text:
                                    'Trust your judgment. If a situation '
                                    'feels wrong or uncomfortable, leave.',
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Material(
                    color: PhilotesColors.gold.withValues(alpha: 0.10),
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: _showValidation &&
                                !_safetyAcknowledged
                            ? Colors.orange.shade800
                            : PhilotesColors.gold.withValues(
                                alpha: 0.75,
                              ),
                        width: _showValidation &&
                                !_safetyAcknowledged
                            ? 2
                            : 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: CheckboxListTile(
                        key: const Key(
                          'safetyAcknowledgementCheckbox',
                        ),
                        contentPadding: EdgeInsets.zero,
                        value: _safetyAcknowledged,
                        activeColor: PhilotesColors.navy,
                        checkColor: Colors.white,
                        controlAffinity:
                            ListTileControlAffinity.leading,
                        onChanged: (value) {
                          setState(() {
                            _safetyAcknowledged =
                                value ?? false;

                            if (_safetyAcknowledged) {
                              _showValidation = false;
                            }
                          });
                        },
                        title: const Text(
                          'I understand that Philotes helps people '
                          'connect, but I am responsible for using good '
                          'judgment when communicating with or meeting '
                          'another member.',
                          style: TextStyle(
                            color: PhilotesColors.navy,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                  ),

                  if (_showValidation &&
                      !_safetyAcknowledged) ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Please acknowledge the safety statement '
                      'before continuing.',
                      key: Key('safetyAcknowledgementError'),
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],

                  const SizedBox(height: 28),

                  SizedBox(
                    height: 56,
                    child: FilledButton(
                      key: const Key(
                        'verificationSafetyContinueButton',
                      ),
                      onPressed: _continue,
                      style: FilledButton.styleFrom(
                        backgroundColor: PhilotesColors.navy,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

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

class _ScamWarning extends StatelessWidget {
  const _ScamWarning();

  @override
  Widget build(BuildContext context) {
    final warningColor = Colors.amber.shade800;

    return Container(
      key: const Key('antiScamWarning'),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: warningColor,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: warningColor.withValues(alpha: 0.10),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.shield_outlined,
                color: warningColor,
                size: 30,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'PROTECT YOURSELF FROM SCAMS',
                  style: TextStyle(
                    color: warningColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.7,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          const Text(
            'Philotes will never ask you to send money to '
            'another member or share your financial information, '
            'password, or verification codes with them.',
            key: Key('primaryScamWarningText'),
            style: TextStyle(
              color: PhilotesColors.navy,
              fontSize: 17,
              fontWeight: FontWeight.w800,
              height: 1.45,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'If another member asks for money, financial information, '
            'your password, or a verification code, do not provide it. '
            'Report the request to Philotes.',
            style: TextStyle(
              color: Colors.brown.shade800,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _SafetySection extends StatelessWidget {
  const _SafetySection({
    required this.icon,
    required this.title,
    required this.child,
  });

  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: PhilotesColors.gold.withValues(alpha: 0.6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: PhilotesColors.navy,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: PhilotesColors.gold,
                    width: 1.7,
                  ),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: PhilotesColors.navy,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          child,
        ],
      ),
    );
  }
}

class _SafetyToolRow extends StatelessWidget {
  const _SafetyToolRow({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: PhilotesColors.gold,
          size: 22,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                color: PhilotesColors.silver,
                fontSize: 13,
                height: 1.45,
              ),
              children: [
                TextSpan(
                  text: '$title — ',
                  style: const TextStyle(
                    color: PhilotesColors.navy,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: description,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SafetyTip extends StatelessWidget {
  const _SafetyTip({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: PhilotesColors.gold,
            size: 19,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: PhilotesColors.navy,
                fontSize: 13,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
