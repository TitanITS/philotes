import 'package:flutter/material.dart';

import '../theme/philotes_colors.dart';
import 'community_mark.dart';

class PhilotesBrandHeader extends StatelessWidget {
  const PhilotesBrandHeader({
    super.key,
    this.compact = false,
  });

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final markSize = compact ? 112.0 : 148.0;
    final titleSize = compact ? 34.0 : 42.0;
    final dividerWidth = compact ? 180.0 : 220.0;

    return Column(
      key: const Key('philotesBrandHeader'),
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: markSize,
          height: markSize,
          child: const FittedBox(
            fit: BoxFit.contain,
            child: CommunityMark(),
          ),
        ),
        SizedBox(height: compact ? 18 : 24),
        Text(
          'PHILOTES',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: PhilotesColors.navy,
            fontSize: titleSize,
            fontWeight: FontWeight.w600,
            letterSpacing: compact ? 5 : 7,
          ),
        ),
        SizedBox(height: compact ? 10 : 14),
        Container(
          width: dividerWidth,
          height: 1,
          color: PhilotesColors.gold,
        ),
        SizedBox(height: compact ? 12 : 18),
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
      ],
    );
  }
}
