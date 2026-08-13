import 'package:flutter/material.dart';

import '../../data/development/development_home_fixture.dart';
import '../../theme/philotes_colors.dart';
import 'home_section_card.dart';

class CommunitySummaryCard
    extends StatelessWidget {
  const CommunitySummaryCard({
    super.key,
    this.onUnreadConversationsTap,
  });

  final VoidCallback? onUnreadConversationsTap;

  @override
  Widget build(BuildContext context) {
    return HomeSectionCard(
      key: const Key(
        'communitySummaryCard',
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.stretch,
        children: [
          _CommunityRow(
            value:
                DevelopmentHomeFixture
                    .unreadConversations,
            label: 'unread conversations',
            onTap: onUnreadConversationsTap,
            showChevron: true,
          ),

          const Divider(height: 26),

          _CommunityRow(
            value:
                DevelopmentHomeFixture
                    .newConnections,
            label: 'new connection',
          ),
        ],
      ),
    );
  }
}


class _CommunityRow extends StatelessWidget {
  const _CommunityRow({
    required this.value,
    required this.label,
    this.onTap,
    this.showChevron = false,
  });

  final int value;
  final String label;
  final VoidCallback? onTap;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final content = Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: PhilotesColors.navy,
            border: Border.all(
              color: PhilotesColors.gold,
              width: 1.5,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            '$value',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: PhilotesColors.navy,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        if (showChevron)
          const Icon(
            Icons.chevron_right,
            color: PhilotesColors.gold,
            size: 20,
          ),
      ],
    );

    if (onTap == null) {
      return content;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: const Key(
          'openMessagesFromHomeButton',
        ),
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(12),
        child: Padding(
          padding:
              const EdgeInsets.symmetric(
            vertical: 3,
          ),
          child: content,
        ),
      ),
    );
  }
}
