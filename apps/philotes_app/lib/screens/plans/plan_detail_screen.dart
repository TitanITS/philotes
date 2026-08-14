import 'package:flutter/material.dart';

import '../../models/plans/philotes_plan.dart';
import '../../theme/philotes_colors.dart';
import '../../theme/philotes_design.dart';

class PlanDetailScreen extends StatelessWidget {
  const PlanDetailScreen({super.key, required this.plan});

  final PhilotesPlan plan;

  void _showDevelopmentMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('planDetailScreen'),
      backgroundColor: PhilotesColors.ivory,
      appBar: AppBar(
        backgroundColor: PhilotesColors.ivory,
        foregroundColor: PhilotesColors.navy,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          key: const Key('backToPlansButton'),
          tooltip: 'Back to Plans',
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Back to Plans',
          style: TextStyle(
            color: PhilotesColors.navy,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.2),
          child: Divider(
            height: 1.2,
            thickness: PhilotesDesign.secondaryBorderWidth,
            color: PhilotesColors.gold,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final wide = constraints.maxWidth >= PhilotesDesign.wideBreakpoint;

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              wide ? PhilotesDesign.widePadding : PhilotesDesign.mobilePadding,
              28,
              wide ? PhilotesDesign.widePadding : PhilotesDesign.mobilePadding,
              44,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 820),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      plan.title,
                      key: Key('planDetailTitle-${plan.id}'),
                      style: const TextStyle(
                        color: PhilotesColors.navy,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      '${plan.dateLabel} • '
                      '${plan.timeLabel}',
                      style: const TextStyle(
                        color: PhilotesColors.gold,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 24),

                    _DetailCard(
                      title: 'Going',
                      icon: Icons.group_outlined,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final attendee in plan.attendees)
                            _AttendeeChip(name: attendee),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    _DetailCard(
                      title: 'Location',
                      icon: Icons.location_on_outlined,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            plan.locationName,
                            style: const TextStyle(
                              color: PhilotesColors.navy,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            plan.locationArea,
                            style: PhilotesDesign.supportingText,
                          ),

                          const SizedBox(height: 14),

                          OutlinedButton.icon(
                            key: const Key('openPlanMapsButton'),
                            onPressed: () {
                              _showDevelopmentMessage(
                                context,
                                'Maps integration '
                                'will open the '
                                'plan location '
                                'in production.',
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: PhilotesColors.navy,
                              side: const BorderSide(
                                color: PhilotesColors.gold,
                                width: 1.4,
                              ),
                            ),
                            icon: const Icon(Icons.map_outlined, size: 18),
                            label: const Text('Open in Maps'),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    _DetailCard(
                      title: 'Notes',
                      icon: Icons.notes_outlined,
                      child: Text(
                        plan.notes,
                        style: const TextStyle(
                          color: PhilotesColors.navy,
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    FilledButton.icon(
                      key: const Key('messagePlanGroupButton'),
                      onPressed: () {
                        _showDevelopmentMessage(
                          context,
                          'Plan group messaging '
                          'will connect to '
                          'Messages later.',
                        );
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: PhilotesColors.navy,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      icon: const Icon(Icons.chat_bubble_outline, size: 18),
                      label: const Text(
                        'Message Group',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),

                    if (plan.isOrganizer && !plan.isPast) ...[
                      const SizedBox(height: 28),

                      const Text(
                        'PLAN MANAGEMENT',
                        style: TextStyle(
                          color: PhilotesColors.silver,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              key: const Key('editPlanButton'),
                              onPressed: () {
                                _showDevelopmentMessage(
                                  context,
                                  'Plan editing '
                                  'will be connected '
                                  'during the '
                                  'frontend build.',
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: PhilotesColors.navy,
                                side: const BorderSide(
                                  color: PhilotesColors.gold,
                                  width: 1.4,
                                ),
                              ),
                              child: const Text('Edit Plan'),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: OutlinedButton(
                              key: const Key('cancelPlanButton'),
                              onPressed: () {
                                _showDevelopmentMessage(
                                  context,
                                  'Plan cancellation '
                                  'will require '
                                  'confirmation '
                                  'and backend '
                                  'permissions.',
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: PhilotesColors.bronze,
                                side: const BorderSide(
                                  color: PhilotesColors.bronze,
                                  width: 1.3,
                                ),
                              ),
                              child: const Text('Cancel Plan'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
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
              Icon(icon, size: 18, color: PhilotesColors.gold),

              const SizedBox(width: 8),

              Text(title, style: PhilotesDesign.sectionHeading),
            ],
          ),

          const SizedBox(height: 14),

          child,
        ],
      ),
    );
  }
}

class _AttendeeChip extends StatelessWidget {
  const _AttendeeChip({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: PhilotesColors.ivory,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: PhilotesColors.gold.withValues(alpha: 0.72),
          width: 1.1,
        ),
      ),
      child: Text(
        name,
        style: const TextStyle(
          color: PhilotesColors.navy,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
