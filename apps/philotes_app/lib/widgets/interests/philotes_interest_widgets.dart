import 'package:flutter/material.dart';

import '../../theme/philotes_colors.dart';
import '../../theme/philotes_design.dart';

class PhilotesInterestCard extends StatelessWidget {
  const PhilotesInterestCard({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.icon,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: PhilotesDesign.primaryCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: PhilotesColors.navy,
                    border: Border.all(color: PhilotesColors.gold, width: 1.4),
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: PhilotesColors.navy,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Text(subtitle!, style: PhilotesDesign.supportingText),
          ],
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class PhilotesInterestChip extends StatelessWidget {
  const PhilotesInterestChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.favorite = false,
    this.onFavorite,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool favorite;
  final VoidCallback? onFavorite;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? PhilotesColors.navy
          : Colors.white.withValues(alpha: 0.72),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: PhilotesColors.gold,
          width: selected ? 1.6 : 1.15,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.only(
            left: 14,
            right: selected && onFavorite != null ? 4 : 14,
            top: 8,
            bottom: 8,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selected) ...[
                const Icon(Icons.check, color: Colors.white, size: 17),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : PhilotesColors.navy,
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
              if (selected && onFavorite != null) ...[
                const SizedBox(width: 3),
                IconButton(
                  tooltip: favorite
                      ? 'Remove from favorites'
                      : 'Add to favorites',
                  visualDensity: VisualDensity.compact,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  padding: EdgeInsets.zero,
                  onPressed: onFavorite,
                  icon: Icon(
                    favorite ? Icons.star : Icons.star_border,
                    color: PhilotesColors.gold,
                    size: 19,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

InputDecoration philotesInterestInputDecoration({
  required String hintText,
  IconData? prefixIcon,
}) {
  return InputDecoration(
    hintText: hintText,
    prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
    filled: true,
    fillColor: Colors.white.withValues(alpha: 0.72),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        color: PhilotesColors.gold.withValues(alpha: 0.72),
        width: 1.1,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: PhilotesColors.gold, width: 2),
    ),
  );
}
