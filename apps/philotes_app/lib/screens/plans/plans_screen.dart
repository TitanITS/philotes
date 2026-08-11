import 'package:flutter/material.dart';

import '../../models/plans/philotes_plan.dart';
import '../../services/plans/development_plan_service.dart';
import '../../services/plans/plan_service.dart';
import '../../theme/philotes_colors.dart';
import '../../theme/philotes_design.dart';
import 'plan_detail_screen.dart';

class PlansScreen extends StatefulWidget {
  const PlansScreen({
    super.key,
    this.planService =
        const DevelopmentPlanService(),
  });

  final PlanService planService;

  @override
  State<PlansScreen> createState() =>
      _PlansScreenState();
}

class _PlansScreenState
    extends State<PlansScreen> {
  final ScrollController
      _scrollController =
      ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<PhilotesPlan> get _plans =>
      widget.planService.plans();

  List<PhilotesPlan> get _today =>
      _plans
          .where(
            (plan) =>
                plan.status ==
                PhilotesPlanStatus.today,
          )
          .toList();

  List<PhilotesPlan> get _upcoming =>
      _plans
          .where(
            (plan) =>
                plan.status ==
                PhilotesPlanStatus.upcoming,
          )
          .toList();

  List<PhilotesPlan> get _past =>
      _plans
          .where(
            (plan) =>
                plan.status ==
                PhilotesPlanStatus.completed,
          )
          .take(3)
          .toList();

  void _openPlan(
    PhilotesPlan plan,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) =>
            PlanDetailScreen(
          plan: plan,
        ),
      ),
    );
  }

  void _showDevelopmentMessage(
    String message,
  ) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (
        BuildContext context,
        BoxConstraints constraints,
      ) {
        final wide =
            constraints.maxWidth >=
            PhilotesDesign.wideBreakpoint;

        return SingleChildScrollView(
          key: const Key(
            'plansScreen',
          ),
          controller:
              _scrollController,
          padding: EdgeInsets.fromLTRB(
            wide
                ? PhilotesDesign.widePadding
                : PhilotesDesign.mobilePadding,
            24,
            wide
                ? PhilotesDesign.widePadding
                : PhilotesDesign.mobilePadding,
            42,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(
                maxWidth:
                    PhilotesDesign
                        .contentMaxWidth,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.stretch,
                children: [
                  _PlansHeader(
                    onCreatePlan: () {
                      _showDevelopmentMessage(
                        'Plan creation will be '
                        'connected during the '
                        'frontend build.',
                      );
                    },
                  ),

                  const SizedBox(
                    height:
                        PhilotesDesign
                            .sectionSpacing,
                  ),

                  _PlanSection(
                    title: 'Today',
                    plans: _today,
                    wide: wide,
                    emptyMessage:
                        'You have no plans '
                        'scheduled for today.',
                    onOpenPlan: _openPlan,
                  ),

                  const SizedBox(
                    height:
                        PhilotesDesign
                            .sectionSpacing,
                  ),

                  _PlanSection(
                    title: 'Upcoming',
                    plans: _upcoming,
                    wide: wide,
                    emptyMessage:
                        'You do not have any '
                        'upcoming plans yet.',
                    onOpenPlan: _openPlan,
                  ),

                  const SizedBox(
                    height:
                        PhilotesDesign
                            .sectionSpacing,
                  ),

                  _PlanSection(
                    title: 'Recent Past',
                    plans: _past,
                    wide: wide,
                    emptyMessage:
                        'Completed plans will '
                        'appear here.',
                    onOpenPlan: _openPlan,
                    completed: true,
                  ),

                  const SizedBox(height: 12),

                  Align(
                    alignment:
                        Alignment.center,
                    child: TextButton(
                      key: const Key(
                        'viewMorePlanHistoryButton',
                      ),
                      onPressed: () {
                        _showDevelopmentMessage(
                          'Older plan history '
                          'will load in pages '
                          'from the backend.',
                        );
                      },
                      child: const Text(
                        'View More History',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}


class _PlansHeader
    extends StatelessWidget {
  const _PlansHeader({
    required this.onCreatePlan,
  });

  final VoidCallback onCreatePlan;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (
        BuildContext context,
        BoxConstraints constraints,
      ) {
        final compact =
            constraints.maxWidth < 600;

        final heading =
            const Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              'Plans',
              style: TextStyle(
                color:
                    PhilotesColors.navy,
                fontSize: 30,
                fontWeight:
                    FontWeight.w800,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Your activities and '
              'gatherings with friends.',
              style: TextStyle(
                color:
                    PhilotesColors.silver,
                fontSize: 14,
              ),
            ),
          ],
        );

        final button =
            FilledButton.icon(
          key: const Key(
            'createPlanButton',
          ),
          onPressed: onCreatePlan,
          style:
              FilledButton.styleFrom(
            backgroundColor:
                PhilotesColors.navy,
            foregroundColor:
                Colors.white,
            padding:
                const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 14,
            ),
          ),
          icon: const Icon(
            Icons.add,
            size: 18,
          ),
          label: const Text(
            'Create Plan',
            style: TextStyle(
              fontWeight:
                  FontWeight.w700,
            ),
          ),
        );

        if (compact) {
          return Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch,
            children: [
              heading,
              const SizedBox(height: 18),
              button,
            ],
          );
        }

        return Row(
          crossAxisAlignment:
              CrossAxisAlignment.end,
          children: [
            Expanded(child: heading),
            const SizedBox(width: 18),
            button,
          ],
        );
      },
    );
  }
}


class _PlanSection
    extends StatelessWidget {
  const _PlanSection({
    required this.title,
    required this.plans,
    required this.wide,
    required this.emptyMessage,
    required this.onOpenPlan,
    this.completed = false,
  });

  final String title;
  final List<PhilotesPlan> plans;
  final bool wide;
  final String emptyMessage;

  final ValueChanged<PhilotesPlan>
      onOpenPlan;

  final bool completed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 22,
              decoration: BoxDecoration(
                color:
                    PhilotesColors.gold,
                borderRadius:
                    BorderRadius.circular(
                  4,
                ),
              ),
            ),

            const SizedBox(width: 9),

            Expanded(
              child: Text(
                title,
                style:
                    PhilotesDesign
                        .sectionHeading,
              ),
            ),

            Text(
              '${plans.length}',
              style: const TextStyle(
                color:
                    PhilotesColors.silver,
                fontSize: 12,
                fontWeight:
                    FontWeight.w700,
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        if (plans.isEmpty)
          Container(
            padding:
                const EdgeInsets.all(
              20,
            ),
            decoration:
                PhilotesDesign
                    .secondaryCardDecoration(),
            child: Text(
              emptyMessage,
              textAlign:
                  TextAlign.center,
              style:
                  PhilotesDesign
                      .supportingText,
            ),
          )
        else
          _PlanGrid(
            plans: plans,
            wide: wide,
            completed: completed,
            onOpenPlan:
                onOpenPlan,
          ),
      ],
    );
  }
}


class _PlanGrid
    extends StatelessWidget {
  const _PlanGrid({
    required this.plans,
    required this.wide,
    required this.completed,
    required this.onOpenPlan,
  });

  final List<PhilotesPlan> plans;
  final bool wide;
  final bool completed;

  final ValueChanged<PhilotesPlan>
      onOpenPlan;

  @override
  Widget build(BuildContext context) {
    if (!wide) {
      return Column(
        children: [
          for (
            var index = 0;
            index < plans.length;
            index++
          ) ...[
            _PlanCard(
              plan: plans[index],
              completed: completed,
              onOpen: () {
                onOpenPlan(
                  plans[index],
                );
              },
            ),

            if (
              index <
              plans.length - 1
            )
              const SizedBox(
                height: 14,
              ),
          ],
        ],
      );
    }

    return LayoutBuilder(
      builder: (
        BuildContext context,
        BoxConstraints constraints,
      ) {
        const gap = 16.0;

        final cardWidth =
            (constraints.maxWidth - gap) /
            2;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final plan in plans)
              SizedBox(
                width: cardWidth,
                child: _PlanCard(
                  plan: plan,
                  completed: completed,
                  onOpen: () {
                    onOpenPlan(plan);
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}


class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.completed,
    required this.onOpen,
  });

  final PhilotesPlan plan;
  final bool completed;
  final VoidCallback onOpen;

  String get _attendeeSummary {
    if (plan.attendees.isEmpty) {
      return 'No attendees yet';
    }

    final others = plan.attendees
        .where(
          (name) => name != 'Alex',
        )
        .toList();

    if (others.isEmpty) {
      return 'Just you so far';
    }

    if (others.length == 1) {
      return others.first;
    }

    if (others.length == 2) {
      return '${others[0]} • '
          '${others[1]}';
    }

    return '${others[0]} • '
        '${others[1]} + '
        '${others.length - 2}';
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: Key(
          'planCard-${plan.id}',
        ),
        onTap: onOpen,
        borderRadius:
            BorderRadius.circular(
          PhilotesDesign.cardRadius,
        ),
        child: Ink(
          padding:
              const EdgeInsets.all(
            18,
          ),
          decoration:
              PhilotesDesign
                  .primaryCardDecoration(),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      plan.title,
                      style:
                          const TextStyle(
                        color:
                            PhilotesColors
                                .navy,
                        fontSize: 17,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),
                  ),

                  if (completed)
                    Container(
                      padding:
                          const EdgeInsets
                              .symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration:
                          BoxDecoration(
                        color:
                            PhilotesColors
                                .silver
                                .withValues(
                          alpha: 0.12,
                        ),
                        borderRadius:
                            BorderRadius
                                .circular(
                          20,
                        ),
                      ),
                      child: const Text(
                        'Completed',
                        style:
                            TextStyle(
                          color:
                              PhilotesColors
                                  .silver,
                          fontSize: 9,
                          fontWeight:
                              FontWeight
                                  .w700,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 12),

              _PlanCardLine(
                icon:
                    Icons
                        .calendar_today_outlined,
                text:
                    '${plan.dateLabel} • '
                    '${plan.timeLabel}',
              ),

              const SizedBox(height: 8),

              _PlanCardLine(
                icon:
                    Icons
                        .group_outlined,
                text: _attendeeSummary,
              ),

              const SizedBox(height: 8),

              _PlanCardLine(
                icon:
                    Icons
                        .location_on_outlined,
                text:
                    plan.locationName,
              ),

              const SizedBox(height: 16),

              const Align(
                alignment:
                    Alignment.centerRight,
                child: Text(
                  'View Plan  ›',
                  style: TextStyle(
                    color:
                        PhilotesColors.navy,
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w800,
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


class _PlanCardLine
    extends StatelessWidget {
  const _PlanCardLine({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color:
              PhilotesColors.gold,
        ),

        const SizedBox(width: 8),

        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color:
                  PhilotesColors.silver,
              fontSize: 11,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
