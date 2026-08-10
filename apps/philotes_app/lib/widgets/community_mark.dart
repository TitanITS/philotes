import 'package:flutter/material.dart';

import '../theme/philotes_colors.dart';

class CommunityMark extends StatelessWidget {
  const CommunityMark({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: PhilotesColors.gold,
          width: 2,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Positioned(
            top: 25,
            child: _PersonDot(
              color: PhilotesColors.navy,
              size: 30,
            ),
          ),
          const Positioned(
            left: 26,
            top: 62,
            child: _PersonDot(
              color: PhilotesColors.blue,
              size: 28,
            ),
          ),
          const Positioned(
            right: 26,
            top: 62,
            child: _PersonDot(
              color: PhilotesColors.gold,
              size: 28,
            ),
          ),
          const Positioned(
            bottom: 25,
            child: _PersonDot(
              color: PhilotesColors.silver,
              size: 30,
            ),
          ),
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: PhilotesColors.gold,
                width: 1.5,
              ),
            ),
            child: const Icon(
              Icons.people_alt_outlined,
              color: PhilotesColors.navy,
              size: 31,
            ),
          ),
        ],
      ),
    );
  }
}

class _PersonDot extends StatelessWidget {
  const _PersonDot({
    required this.color,
    required this.size,
  });

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
