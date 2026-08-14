import 'package:flutter/material.dart';

import '../../theme/philotes_design.dart';

class HomeSectionCard extends StatelessWidget {
  const HomeSectionCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: PhilotesDesign.primaryCardDecoration(),
      child: child,
    );
  }
}
