import 'package:flutter/material.dart';

import 'philotes_colors.dart';

abstract final class PhilotesDesign {
  static const double mobilePadding = 18;
  static const double widePadding = 28;

  static const double cardRadius = 16;
  static const double primaryBorderWidth = 1.7;
  static const double secondaryBorderWidth = 1.2;

  static const double sectionSpacing = 26;
  static const double contentMaxWidth = 1180;
  static const double wideBreakpoint = 900;

  static BoxDecoration primaryCardDecoration({
    Color? backgroundColor,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? Colors.white,
      borderRadius: BorderRadius.circular(
        cardRadius,
      ),
      border: Border.all(
        color: PhilotesColors.gold,
        width: primaryBorderWidth,
      ),
    );
  }

  static BoxDecoration secondaryCardDecoration({
    Color? backgroundColor,
  }) {
    return BoxDecoration(
      color:
          backgroundColor ??
          Colors.white.withValues(
            alpha: 0.82,
          ),
      borderRadius: BorderRadius.circular(
        cardRadius,
      ),
      border: Border.all(
        color: PhilotesColors.gold.withValues(
          alpha: 0.72,
        ),
        width: secondaryBorderWidth,
      ),
    );
  }

  static TextStyle get sectionHeading =>
      const TextStyle(
        color: PhilotesColors.navy,
        fontSize: 18,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.2,
      );

  static TextStyle get supportingText =>
      const TextStyle(
        color: PhilotesColors.silver,
        fontSize: 12,
        height: 1.45,
      );
}
