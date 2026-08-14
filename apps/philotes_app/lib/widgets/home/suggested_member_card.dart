import 'package:flutter/material.dart';

import '../../models/compatibility/compatibility_level.dart';
import '../../models/compatibility/suggested_member.dart';
import '../../theme/philotes_colors.dart';
import '../../theme/philotes_design.dart';

class SuggestedMemberCard extends StatelessWidget {
  const SuggestedMemberCard({
    super.key,
    required this.member,
    required this.onOpenProfile,
  });

  final SuggestedMember member;
  final VoidCallback onOpenProfile;

  Color get _compatibilityColor {
    switch (member.compatibility.level) {
      case CompatibilityLevel.strong:
        return PhilotesColors.gold;
      case CompatibilityLevel.moderate:
        return PhilotesColors.silver;
      case CompatibilityLevel.limited:
        return PhilotesColors.bronze;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: Key('suggestedMember-${member.id}'),
        onTap: onOpenProfile,
        borderRadius: BorderRadius.circular(PhilotesDesign.cardRadius),
        child: Ink(
          decoration: PhilotesDesign.primaryCardDecoration(),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'COMPATIBILITY',
                style: TextStyle(
                  color: PhilotesColors.navy,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                member.compatibility.level.label,
                key: Key('compatibilityLabel-${member.id}'),
                style: TextStyle(
                  color: _compatibilityColor,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 18),

              Center(
                child: Container(
                  width: 92,
                  height: 92,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: PhilotesColors.navy,
                    border: Border.all(color: PhilotesColors.gold, width: 2.2),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    member.initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Text(
                member.displayName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: PhilotesColors.navy,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                '${member.compatibility.sharedFavoriteInterests.length} '
                'favorite interests in common',
                style: const TextStyle(
                  color: PhilotesColors.navy,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                '${member.compatibility.sharedInterests.length} '
                'other shared interests',
                style: PhilotesDesign.supportingText,
              ),

              const SizedBox(height: 16),

              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'View Profile  ›',
                  style: TextStyle(
                    color: PhilotesColors.navy,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
