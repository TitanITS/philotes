import 'package:flutter/material.dart';

import '../theme/philotes_colors.dart';

class TitanAttribution extends StatelessWidget {
  const TitanAttribution({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'BROUGHT TO YOU BY',
          style: TextStyle(
            color: PhilotesColors.navy,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(width: 6),
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
            color: PhilotesColors.navy,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 3,
          ),
        ),
      ],
    );
  }
}
