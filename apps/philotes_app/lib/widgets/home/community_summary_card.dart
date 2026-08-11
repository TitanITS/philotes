import 'package:flutter/material.dart';

import '../../data/development/development_home_fixture.dart';
import '../../theme/philotes_colors.dart';
import 'home_section_card.dart';

class CommunitySummaryCard
    extends StatelessWidget {
  const CommunitySummaryCard({
    super.key,
  });

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
  });

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
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
      ],
    );
  }
}
