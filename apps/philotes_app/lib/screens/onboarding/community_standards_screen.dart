import 'package:flutter/material.dart';

import '../../data/community_standards.dart';
import '../../theme/philotes_colors.dart';
import 'create_account_screen.dart';

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

    final targetContext = key.currentContext;

    if (targetContext == null || !targetContext.mounted) {
      return;
    }

    await Scrollable.ensureVisible(
      targetContext,
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
      ).firstWhere((index) => !_reviewedStandards.contains(index));

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

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => const CreateAccountScreen(),
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
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
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
                        color: _showValidation && _allReviewed && !_acknowledged
                            ? Colors.red.shade600
                            : PhilotesColors.gold.withValues(alpha: 0.65),
                        width: _showValidation && _allReviewed && !_acknowledged
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

                  if (_showValidation && _allReviewed && !_acknowledged) ...[
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
  const _ReviewProgress({required this.reviewed, required this.total});

  final int reviewed;
  final int total;

  @override
  Widget build(BuildContext context) {
    final complete = reviewed == total;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: complete
            ? PhilotesColors.gold.withValues(alpha: 0.14)
            : Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: PhilotesColors.gold.withValues(alpha: 0.7)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            complete ? Icons.check_circle_outline : Icons.menu_book_outlined,
            color: complete ? PhilotesColors.gold : PhilotesColors.navy,
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
  const _ValidationMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade600),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
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
    final standard = CommunityStandardsData.standards[standardIndex];

    final borderColor = showIncomplete
        ? Colors.red.shade600
        : reviewed
        ? PhilotesColors.gold
        : PhilotesColors.gold.withValues(alpha: 0.55);

    return Material(
      color: Colors.white.withValues(alpha: 0.55),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: borderColor,
          width: showIncomplete || reviewed ? 1.6 : 1,
        ),
      ),
      child: ExpansionTile(
        onExpansionChanged: onExpansionChanged,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        iconColor: PhilotesColors.gold,
        collapsedIconColor: PhilotesColors.navy,
        leading: Container(
          width: 46,
          height: 46,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: showIncomplete ? Colors.red.shade600 : PhilotesColors.gold,
              width: 2,
            ),
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: PhilotesColors.navy,
              shape: BoxShape.circle,
            ),
            child: Icon(_icons[standardIndex], color: Colors.white, size: 21),
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
          const Divider(color: PhilotesColors.gold, height: 24),
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
                color: PhilotesColors.gold.withValues(alpha: 0.55),
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
    );
  }
}
