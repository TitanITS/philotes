import 'package:flutter/material.dart';

import '../../data/development/development_home_fixture.dart';
import '../../theme/philotes_colors.dart';
import 'home_section_card.dart';

class TodayCard extends StatelessWidget {
  const TodayCard({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeSectionCard(
      key: const Key('todayCard'),
      child: DevelopmentHomeFixture.hasPlanToday
          ? const _TodayPlan()
          : const _TodaySuggestion(),
    );
  }
}

class _TodayPlan extends StatelessWidget {
  const _TodayPlan();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          DevelopmentHomeFixture.todayPlanTitle,
          style: TextStyle(
            color: PhilotesColors.navy,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 7),

        const Text(
          DevelopmentHomeFixture.todayPlanTime,
          style: TextStyle(
            color: PhilotesColors.gold,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 14),

        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'The full Plans experience '
                    'will be built later.',
                  ),
                ),
              );
            },
            child: const Text('View Plan'),
          ),
        ),
      ],
    );
  }
}

class _TodaySuggestion extends StatelessWidget {
  const _TodaySuggestion();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your day is open.',
          style: TextStyle(
            color: PhilotesColors.navy,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'Looking for something to do?',
          style: TextStyle(
            color: PhilotesColors.gold,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 10),

        const Text(
          DevelopmentHomeFixture.outingMessage,
          style: TextStyle(
            color: PhilotesColors.navy,
            fontSize: 12,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 14),

        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            key: const Key('exploreOutingIdeaButton'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Outing ideas and local places '
                    'will be connected during the '
                    'Plans frontend build.',
                  ),
                ),
              );
            },
            child: const Text('Explore an Idea'),
          ),
        ),
      ],
    );
  }
}
