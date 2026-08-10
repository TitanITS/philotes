from pathlib import Path
from datetime import datetime

SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = SCRIPT_DIR.parent.parent

APP_ROOT = PROJECT_ROOT / "apps" / "philotes_app"
LIB_ROOT = APP_ROOT / "lib"
TEST_ROOT = APP_ROOT / "test"

REPORT_PATH = SCRIPT_DIR / "developerpatchscript_report.txt"


FILES = {
    # ============================================================
    # COMMUNITY STANDARD MODEL
    # ============================================================
    LIB_ROOT / "models" / "community_standard.dart": r"""class CommunityStandard {
  const CommunityStandard({
    required this.number,
    required this.title,
    required this.summary,
    required this.details,
    required this.simpleTerms,
  });

  final int number;
  final String title;
  final String summary;
  final String details;
  final String simpleTerms;
}
""",

    # ============================================================
    # COMMUNITY STANDARDS DATA
    # ============================================================
    LIB_ROOT / "data" / "community_standards.dart": r"""import '../models/community_standard.dart';

abstract final class CommunityStandardsData {
  static const String version = '1.0';

  static const List<CommunityStandard> standards = [
    CommunityStandard(
      number: 1,
      title: 'Friendship Comes First',
      summary:
          'Philotes is for genuine friendship, shared interests, and '
          'community - not dating or hookups.',
      details: '''Philotes exists to help people build genuine friendships,
discover shared interests, participate in activities, and create meaningful
social connections.

Members should use Philotes with friendship and community as their purpose.
Philotes is not intended to be a dating, hookup, or sexually focused platform.

We understand that friendships between adults can sometimes naturally develop
into something more. Philotes is not here to police genuine relationships that
develop naturally between consenting adults. However, members may not use
Philotes primarily to pursue dates, sexual encounters, romantic partners, or
repeatedly make unwanted romantic or sexual advances toward other members.

If another member tells you that they are not interested in a romantic or
sexual relationship, respect that boundary immediately.''',
      simpleTerms:
          'Come to Philotes looking for friends. Treat anything beyond '
          'friendship as something that must develop naturally, mutually, '
          'and respectfully - not as the purpose of using the community.',
    ),
    CommunityStandard(
      number: 2,
      title: 'Be Yourself',
      summary:
          'Be truthful about who you are. Impersonation, deceptive profiles, '
          'and fraudulent identities are not allowed.',
      details: '''Trust begins with knowing that the people you meet are
representing themselves honestly.

Members must provide truthful information about themselves and may not
impersonate another person, create a deliberately false identity, misrepresent
themselves in ways intended to deceive others, or use another person's
photographs as their own.

Do not create accounts intended to mislead, manipulate, scam, harass, or
secretly monitor another person.

Members also may not create additional accounts to evade a suspension,
restriction, block, safety measure, or other action taken by Philotes.

We do not expect every profile to tell a person's entire life story. Members
remain in control of what personal information they choose to share, subject to
information Philotes may require for account or safety purposes. Privacy is not
dishonesty.''',
      simpleTerms:
          'You do not have to tell everyone everything about yourself - but '
          'what you do represent about yourself should be genuine.',
    ),
    CommunityStandard(
      number: 3,
      title: 'Treat People With Respect',
      summary:
          'Every member deserves to participate without harassment, bullying, '
          'threats, hate, sexual misconduct, or persistent unwanted contact.',
      details: '''Philotes should be a place where people with different
personalities, backgrounds, abilities, experiences, and interests can meet one
another with dignity and respect.

Harassment, bullying, intimidation, credible threats, stalking behavior,
hateful conduct, targeted humiliation, sexual harassment, and deliberately
abusive behavior are not acceptable.

Do not repeatedly contact someone who has clearly asked you to stop. Do not
pressure another member into conversations, activities, relationships, sharing
information, or physical contact they do not want.

Disagreements will happen. Members are allowed to disagree, end friendships,
leave conversations, decline invitations, and decide that they simply do not
get along.

Disagreement itself is not misconduct.

The expectation is that members handle those situations without harassment,
retaliation, threats, humiliation, or attempts to turn other members against
someone.''',
      simpleTerms:
          'You do not have to like everyone you meet on Philotes. You do have '
          'to treat them with basic dignity and respect.',
    ),
    CommunityStandard(
      number: 4,
      title: 'Respect Boundaries and Privacy',
      summary:
          'Respect personal boundaries and never expose, threaten to expose, '
          'or misuse another person\'s private information.',
      details: '''Every member has the right to control their own personal
information and establish reasonable boundaries around how they interact with
others.

Do not pressure another member to provide their phone number, home address,
workplace, personal email address, precise location, photographs, social-media
accounts, financial information, family information, or other private details.

Never publish, distribute, reveal, or threaten to reveal another person's
private or identifying information without their permission when doing so could
violate their privacy, expose them to unwanted contact, intimidate them, harass
them, or place them at risk.

This includes doxing.

Examples may include another person's home address, private phone number,
workplace information, personal email address, precise location, private
photographs, family details, financial information, identifying documents, or
other sensitive personal information.

This protection does not disappear simply because you knew the person before
encountering them on Philotes. Information learned outside Philotes may not be
weaponized against someone through the Philotes community.

Likewise, information another member trusted you with privately should not be
used to embarrass, threaten, control, retaliate against, or endanger them.

Respect people's decisions about communication and real-world interaction. If
someone does not want to exchange contact information, meet in person, continue
a conversation, or maintain a friendship, respect that decision.''',
      simpleTerms:
          'Someone trusting you with access to their life does not give you '
          'ownership of their information or their boundaries.',
    ),
    CommunityStandard(
      number: 5,
      title: 'Put Safety First',
      summary:
          'Make thoughtful, safe choices online and when meeting people in '
          'person - especially during first gatherings.',
      details: '''Philotes is intended to help online connections develop into
meaningful friendships and shared activities, but personal safety should always
come first.

Take time to get to know someone before deciding to meet them in person. For
initial meetings, Philotes encourages members to choose appropriate public
places and use good judgment about when, where, and how they meet.

Never pressure another member into meeting privately, changing a meeting
location, entering a home or vehicle, consuming alcohol or other substances,
participating in an activity they are uncomfortable with, or remaining
somewhere they want to leave.

Every member has the right to change their mind about a gathering or leave an
interaction at any time.

Do not use Philotes to facilitate violence, exploitation, fraud, coercion,
predatory behavior, or other conduct that could place another person in danger.

Philotes can provide safety tools and encourage safer choices, but no platform
can guarantee another person's behavior. Members should continue using their
own judgment and take reasonable precautions when interacting online and in
person.

If something feels unsafe, members should prioritize their immediate safety
and use Philotes' blocking and reporting tools when appropriate.''',
      simpleTerms:
          'A friendship opportunity is never more important than your safety '
          'or someone else\'s.',
    ),
    CommunityStandard(
      number: 6,
      title: 'Help Protect the Community',
      summary:
          'Use Philotes\' safety tools responsibly and help us address '
          'behavior that threatens members or the community.',
      details: '''A safe community depends on both responsible members and
responsible moderation.

Philotes will provide tools that allow members to block people they no longer
wish to interact with and report behavior they believe violates Community
Standards or creates a safety concern.

If you experience or witness concerning behavior, you may report it. Reports
should be made honestly and in good faith.

Knowingly submitting false reports to punish, intimidate, retaliate against, or
harass another member is itself an abuse of the community's safety systems.

Philotes may review reported behavior and take appropriate action based on the
circumstances. Depending on the seriousness and available information, actions
may include warnings, restrictions, removal of content or privileges, temporary
suspension, or permanent removal from the community.

Immediate or serious safety situations may require actions beyond Philotes'
internal tools. Philotes' reporting system is not a replacement for emergency
services or appropriate authorities when someone faces an immediate real-world
danger.

Members should not attempt to organize public retaliation, harassment, or
vigilante action against someone they believe violated the rules. Report the
concern and allow the appropriate process to address it.''',
      simpleTerms:
          'Protect yourself, look out for others, report genuine concerns, '
          'and do not misuse safety tools to hurt someone.',
    ),
  ];
}
""",

    # ============================================================
    # COMMUNITY STANDARDS SCREEN
    # ============================================================
    LIB_ROOT
    / "screens"
    / "onboarding"
    / "community_standards_screen.dart": r"""import 'package:flutter/material.dart';

import '../../data/community_standards.dart';
import '../../theme/philotes_colors.dart';

class CommunityStandardsScreen extends StatefulWidget {
  const CommunityStandardsScreen({super.key});

  @override
  State<CommunityStandardsScreen> createState() =>
      _CommunityStandardsScreenState();
}

class _CommunityStandardsScreenState extends State<CommunityStandardsScreen> {
  final Set<int> _reviewedStandards = <int>{};

  final List<GlobalKey> _standardKeys = List<GlobalKey>.generate(
    CommunityStandardsData.standards.length,
    (_) => GlobalKey(),
  );

  final GlobalKey _acknowledgementKey = GlobalKey();

  bool _acknowledged = false;
  bool _showValidation = false;

  bool get _allReviewed =>
      _reviewedStandards.length == CommunityStandardsData.standards.length;

  void _markReviewed(int index, bool expanded) {
    if (!expanded || _reviewedStandards.contains(index)) {
      return;
    }

    setState(() {
      _reviewedStandards.add(index);

      if (_allReviewed) {
        _showValidation = false;
      }
    });
  }

  Future<void> _scrollTo(GlobalKey key) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));

    final context = key.currentContext;

    if (context == null || !mounted) {
      return;
    }

    await Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      alignment: 0.15,
    );
  }

  Future<void> _handleContinue() async {
    if (!_allReviewed) {
      setState(() {
        _showValidation = true;
      });

      final firstIncompleteIndex = List<int>.generate(
        CommunityStandardsData.standards.length,
        (index) => index,
      ).firstWhere(
        (index) => !_reviewedStandards.contains(index),
      );

      await _scrollTo(_standardKeys[firstIncompleteIndex]);
      return;
    }

    if (!_acknowledged) {
      setState(() {
        _showValidation = true;
      });

      await _scrollTo(_acknowledgementKey);
      return;
    }

    setState(() {
      _showValidation = false;
    });

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Account creation will be the next onboarding step.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final standards = CommunityStandardsData.standards;

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
              24,
              20,
              24,
              36,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 720,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Community Standards',
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
                      width: 135,
                      height: 2,
                      decoration: BoxDecoration(
                        color: PhilotesColors.gold,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Friendship starts with how we treat one another. '
                    'Please review each standard before continuing.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: PhilotesColors.silver,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 22),

                  _ReviewProgress(
                    reviewed: _reviewedStandards.length,
                    total: standards.length,
                  ),

                  if (_showValidation && !_allReviewed) ...[
                    const SizedBox(height: 12),
                    const _ValidationMessage(
                      message:
                          'Please review each Community Standard before '
                          'continuing.',
                    ),
                  ],

                  const SizedBox(height: 18),

                  for (int index = 0; index < standards.length; index++) ...[
                    _CommunityStandardCard(
                      key: _standardKeys[index],
                      standardIndex: index,
                      reviewed: _reviewedStandards.contains(index),
                      showIncomplete:
                          _showValidation &&
                          !_reviewedStandards.contains(index),
                      onExpansionChanged: (expanded) {
                        _markReviewed(index, expanded);
                      },
                    ),
                    if (index != standards.length - 1)
                      const SizedBox(height: 14),
                  ],

                  const SizedBox(height: 26),

                  Container(
                    key: _acknowledgementKey,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color:
                            _showValidation &&
                                _allReviewed &&
                                !_acknowledged
                            ? Colors.red.shade600
                            : PhilotesColors.gold.withValues(alpha: 0.65),
                        width:
                            _showValidation &&
                                _allReviewed &&
                                !_acknowledged
                            ? 2
                            : 1,
                      ),
                    ),
                    child: CheckboxListTile(
                      value: _acknowledged,
                      onChanged: _allReviewed
                          ? (value) {
                              setState(() {
                                _acknowledged = value ?? false;

                                if (_acknowledged) {
                                  _showValidation = false;
                                }
                              });
                            }
                          : null,
                      activeColor: PhilotesColors.navy,
                      checkColor: Colors.white,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text(
                        'I have reviewed and understand the Philotes '
                        'Community Standards. I agree to follow these '
                        'standards and respect the safety, privacy, and '
                        'boundaries of other members.',
                        style: TextStyle(
                          color: PhilotesColors.navy,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          height: 1.45,
                        ),
                      ),
                      subtitle: !_allReviewed
                          ? const Padding(
                              padding: EdgeInsets.only(top: 6),
                              child: Text(
                                'Review all six standards to unlock this '
                                'acknowledgement.',
                                style: TextStyle(
                                  color: PhilotesColors.silver,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          : null,
                    ),
                  ),

                  if (_showValidation &&
                      _allReviewed &&
                      !_acknowledged) ...[
                    const SizedBox(height: 10),
                    const _ValidationMessage(
                      message:
                          'Please acknowledge the Community Standards '
                          'before continuing.',
                    ),
                  ],

                  const SizedBox(height: 26),

                  SizedBox(
                    height: 56,
                    child: FilledButton(
                      onPressed: _handleContinue,
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

                  Text(
                    'Community Standards Version '
                    '${CommunityStandardsData.version}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: PhilotesColors.silver,
                      fontSize: 11,
                    ),
                  ),

                  const SizedBox(height: 8),

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

class _ReviewProgress extends StatelessWidget {
  const _ReviewProgress({
    required this.reviewed,
    required this.total,
  });

  final int reviewed;
  final int total;

  @override
  Widget build(BuildContext context) {
    final complete = reviewed == total;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: complete
            ? PhilotesColors.gold.withValues(alpha: 0.14)
            : Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: PhilotesColors.gold.withValues(alpha: 0.7),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            complete
                ? Icons.check_circle_outline
                : Icons.menu_book_outlined,
            color: complete
                ? PhilotesColors.gold
                : PhilotesColors.navy,
            size: 21,
          ),
          const SizedBox(width: 9),
          Text(
            'Community Standards Reviewed: $reviewed of $total',
            style: const TextStyle(
              color: PhilotesColors.navy,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ValidationMessage extends StatelessWidget {
  const _ValidationMessage({
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.red.shade600,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red.shade700,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.red.shade800,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CommunityStandardCard extends StatelessWidget {
  const _CommunityStandardCard({
    super.key,
    required this.standardIndex,
    required this.reviewed,
    required this.showIncomplete,
    required this.onExpansionChanged,
  });

  final int standardIndex;
  final bool reviewed;
  final bool showIncomplete;
  final ValueChanged<bool> onExpansionChanged;

  static const List<IconData> _icons = [
    Icons.people_alt_outlined,
    Icons.badge_outlined,
    Icons.favorite_border,
    Icons.lock_outline,
    Icons.shield_outlined,
    Icons.volunteer_activism_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    final standard =
        CommunityStandardsData.standards[standardIndex];

    final borderColor = showIncomplete
        ? Colors.red.shade600
        : reviewed
        ? PhilotesColors.gold
        : PhilotesColors.gold.withValues(alpha: 0.55);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: showIncomplete || reviewed ? 1.6 : 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: ExpansionTile(
          onExpansionChanged: onExpansionChanged,
          tilePadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          childrenPadding: const EdgeInsets.fromLTRB(
            18,
            0,
            18,
            20,
          ),
          iconColor: PhilotesColors.gold,
          collapsedIconColor: PhilotesColors.navy,
          leading: Container(
            width: 46,
            height: 46,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: showIncomplete
                    ? Colors.red.shade600
                    : PhilotesColors.gold,
                width: 2,
              ),
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: PhilotesColors.navy,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _icons[standardIndex],
                color: Colors.white,
                size: 21,
              ),
            ),
          ),
          title: Text(
            '${standard.number}. ${standard.title}',
            style: const TextStyle(
              color: PhilotesColors.navy,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  standard.summary,
                  style: const TextStyle(
                    color: PhilotesColors.silver,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                if (reviewed)
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: PhilotesColors.gold,
                        size: 17,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Reviewed',
                        style: TextStyle(
                          color: PhilotesColors.gold,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  )
                else if (showIncomplete)
                  Text(
                    'Review required',
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                else
                  const Text(
                    'Tap to review',
                    style: TextStyle(
                      color: PhilotesColors.navy,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
          children: [
            const Divider(
              color: PhilotesColors.gold,
              height: 24,
            ),
            Text(
              standard.details,
              style: const TextStyle(
                color: PhilotesColors.navy,
                fontSize: 14,
                height: 1.55,
              ),
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: PhilotesColors.gold.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      PhilotesColors.gold.withValues(alpha: 0.55),
                ),
              ),
              child: Text(
                'In simple terms: ${standard.simpleTerms}',
                style: const TextStyle(
                  color: PhilotesColors.navy,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
""",

    # ============================================================
    # PAGE 2 - PRESERVE APPROVED DESIGN, CHANGE CONTINUE ACTION
    # ============================================================
    LIB_ROOT
    / "screens"
    / "onboarding"
    / "onboarding_intro_screen.dart": r"""import 'package:flutter/material.dart';

import '../../theme/philotes_colors.dart';
import 'community_standards_screen.dart';

class PhilotesOnboardingIntroScreen extends StatelessWidget {
  const PhilotesOnboardingIntroScreen({super.key});

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
              24,
              20,
              24,
              36,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 620,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Before You Join',
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
                      width: 110,
                      height: 2,
                      decoration: BoxDecoration(
                        color: PhilotesColors.gold,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Philotes is built for genuine friendship, shared '
                    'interests, and safer real-world connections.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: PhilotesColors.silver,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 30),

                  const _OnboardingPrinciple(
                    icon: Icons.cake_outlined,
                    title: 'Adults 18+',
                    description:
                        'Philotes membership is limited to adults age 18 '
                        'and older.',
                  ),

                  const SizedBox(height: 14),

                  const _OnboardingPrinciple(
                    icon: Icons.verified_user_outlined,
                    title: 'Verification Required',
                    description:
                        'Members will complete identity and safety '
                        'verification before receiving full community access.',
                  ),

                  const SizedBox(height: 14),

                  const _OnboardingPrinciple(
                    icon: Icons.people_outline,
                    title: 'Friendship, Not Dating',
                    description:
                        'Philotes is designed to help people build genuine '
                        'friendships around shared interests and activities.',
                  ),

                  const SizedBox(height: 14),

                  const _OnboardingPrinciple(
                    icon: Icons.shield_outlined,
                    title: 'Safety Comes First',
                    description:
                        'Community standards, reporting tools, privacy '
                        'protections, and safer public gatherings are part '
                        'of the Philotes experience.',
                  ),

                  const SizedBox(height: 32),

                  SizedBox(
                    height: 56,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (context) =>
                                const CommunityStandardsScreen(),
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

class _OnboardingPrinciple extends StatelessWidget {
  const _OnboardingPrinciple({
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
        color: Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: PhilotesColors.gold.withValues(alpha: 0.55),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: PhilotesColors.gold,
                width: 2,
              ),
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: PhilotesColors.navy,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: PhilotesColors.navy,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  description,
                  style: const TextStyle(
                    color: PhilotesColors.silver,
                    fontSize: 14,
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
""",

    # ============================================================
    # WIDGET TEST
    # ============================================================
    TEST_ROOT / "widget_test.dart": r"""import 'package:flutter_test/flutter_test.dart';

import 'package:philotes/app.dart';

void main() {
  testWidgets(
    'Philotes onboarding reaches Community Standards',
    (WidgetTester tester) async {
      await tester.pumpWidget(const PhilotesApp());

      expect(find.text('PHILOTES'), findsOneWidget);
      expect(find.text('Join the Community'), findsOneWidget);

      final joinButton = find.text('Join the Community');

      await tester.ensureVisible(joinButton);
      await tester.pumpAndSettle();

      await tester.tap(joinButton);
      await tester.pumpAndSettle();

      expect(find.text('Before You Join'), findsOneWidget);

      final introContinue = find.text('Continue');

      await tester.ensureVisible(introContinue);
      await tester.pumpAndSettle();

      await tester.tap(introContinue);
      await tester.pumpAndSettle();

      expect(find.text('Community Standards'), findsOneWidget);
      expect(
        find.text('Community Standards Reviewed: 0 of 6'),
        findsOneWidget,
      );

      expect(find.textContaining('Friendship Comes First'), findsOneWidget);
      expect(find.textContaining('Be Yourself'), findsOneWidget);
      expect(
        find.textContaining('Treat People With Respect'),
        findsOneWidget,
      );
      expect(
        find.textContaining('Respect Boundaries and Privacy'),
        findsOneWidget,
      );
      expect(find.textContaining('Put Safety First'), findsOneWidget);
      expect(
        find.textContaining('Help Protect the Community'),
        findsOneWidget,
      );

      final firstStandard =
          find.textContaining('Friendship Comes First');

      await tester.ensureVisible(firstStandard);
      await tester.pumpAndSettle();

      await tester.tap(firstStandard);
      await tester.pumpAndSettle();

      expect(find.text('Reviewed'), findsOneWidget);

      expect(
        find.textContaining('Community Standards Version 1.0'),
        findsOneWidget,
      );
    },
  );
}
""",
}


def write_file(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8")


def main() -> None:
    print()
    print("=" * 74)
    print("PHILOTES COMMUNITY STANDARDS V1 PATCH")
    print("=" * 74)
    print()

    if not APP_ROOT.exists():
        print(f"FAIL: Flutter app not found: {APP_ROOT}")
        raise SystemExit(1)

    for path, content in FILES.items():
        write_file(path, content)
        print(f"WROTE: {path.relative_to(PROJECT_ROOT)}")

    standards_file = (
        LIB_ROOT / "data" / "community_standards.dart"
    )

    screen_file = (
        LIB_ROOT
        / "screens"
        / "onboarding"
        / "community_standards_screen.dart"
    )

    intro_file = (
        LIB_ROOT
        / "screens"
        / "onboarding"
        / "onboarding_intro_screen.dart"
    )

    checks = {
        "Community Standard model exists":
            (
                LIB_ROOT
                / "models"
                / "community_standard.dart"
            ).exists(),

        "Community Standards data exists":
            standards_file.exists(),

        "Six standards present":
            standards_file.read_text(
                encoding="utf-8"
            ).count("CommunityStandard(") == 6,

        "Community Standards version is 1.0":
            "version = '1.0'" in standards_file.read_text(
                encoding="utf-8"
            ),

        "Doxing language present":
            "This includes doxing." in standards_file.read_text(
                encoding="utf-8"
            ),

        "Community Standards screen exists":
            screen_file.exists(),

        "Review tracking present":
            "_reviewedStandards" in screen_file.read_text(
                encoding="utf-8"
            ),

        "Acknowledgement present":
            "I have reviewed and understand"
            in screen_file.read_text(
                encoding="utf-8"
            ),

        "Validation behavior present":
            "Review required" in screen_file.read_text(
                encoding="utf-8"
            ),

        "Page 2 navigates to Community Standards":
            "CommunityStandardsScreen"
            in intro_file.read_text(
                encoding="utf-8"
            ),

        "Widget test updated":
            "Community Standards Reviewed: 0 of 6"
            in (
                TEST_ROOT / "widget_test.dart"
            ).read_text(encoding="utf-8"),
    }

    report = [
        "PHILOTES COMMUNITY STANDARDS V1 PATCH REPORT",
        "=" * 74,
        f"Generated: {datetime.now().isoformat(timespec='seconds')}",
        f"Project root: {PROJECT_ROOT}",
        "",
    ]

    all_passed = True

    for description, passed in checks.items():
        status = "PASS" if passed else "FAIL"
        print(f"{status}: {description}")
        report.append(f"{status}: {description}")

        if not passed:
            all_passed = False

    report.extend(
        [
            "",
            f"OVERALL: {'PASS' if all_passed else 'FAIL'}",
            "",
            "This patch:",
            "- Adds Community Standards V1 content.",
            "- Separates standards content from the screen UI.",
            "- Adds six expandable review sections.",
            "- Tracks which sections have been reviewed.",
            "- Requires all six reviews before acknowledgement.",
            "- Requires acknowledgement before successful continuation.",
            "- Highlights incomplete requirements in red.",
            "- Preserves approved Page 2 visual design.",
            "- Does not persist acceptance to the backend yet.",
        ]
    )

    REPORT_PATH.write_text(
        "\n".join(report) + "\n",
        encoding="utf-8",
    )

    print()
    print(f"Report: {REPORT_PATH}")
    print()
    print(f"OVERALL: {'PASS' if all_passed else 'FAIL'}")

    if not all_passed:
        raise SystemExit(1)


if __name__ == "__main__":
    main()