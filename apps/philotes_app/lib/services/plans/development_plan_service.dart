import '../../models/plans/philotes_plan.dart';
import 'plan_service.dart';

class DevelopmentPlanService
    extends PlanService {
  const DevelopmentPlanService();

  static const List<PhilotesPlan>
      _developmentPlans =
      <PhilotesPlan>[
    PhilotesPlan(
      id: 'dev-axe-throwing',
      title: 'Axe Throwing',
      dateLabel: 'Today',
      timeLabel: '7:00 PM',
      locationName:
          'Bull City Axe Throwing',
      locationArea: 'Durham, NC',
      attendees: <String>[
        'Alex',
        'Jordan',
        'Taylor',
      ],
      notes:
          'Meet near the front entrance '
          'about 15 minutes before the '
          'reservation.',
      status: PhilotesPlanStatus.today,
      isOrganizer: true,
    ),
    PhilotesPlan(
      id: 'dev-bowling-night',
      title: 'Bowling Night',
      dateLabel: 'Saturday, August 15',
      timeLabel: '7:00 PM',
      locationName:
          'Triangle Bowling Center',
      locationArea: 'Durham, NC',
      attendees: <String>[
        'Alex',
        'Jordan',
        'Taylor',
        'Morgan',
      ],
      notes:
          'Two lanes are planned. '
          'Arrive a few minutes early '
          'if you need bowling shoes.',
      status:
          PhilotesPlanStatus.upcoming,
      isOrganizer: true,
    ),
    PhilotesPlan(
      id: 'dev-hockey-game',
      title: 'Hurricanes Game',
      dateLabel: 'Friday, August 21',
      timeLabel: '7:30 PM',
      locationName:
          'Lenovo Center',
      locationArea: 'Raleigh, NC',
      attendees: <String>[
        'Alex',
        'Jordan',
        'Morgan',
      ],
      notes:
          'Meet outside the main entrance '
          'before going through security.',
      status:
          PhilotesPlanStatus.upcoming,
    ),
    PhilotesPlan(
      id: 'dev-museum',
      title: 'Museum Afternoon',
      dateLabel: 'Sunday, August 23',
      timeLabel: '1:00 PM',
      locationName:
          'North Carolina Museum of Art',
      locationArea: 'Raleigh, NC',
      attendees: <String>[
        'Alex',
        'Casey',
      ],
      notes:
          'Start with the main collection '
          'and decide on lunch afterward.',
      status:
          PhilotesPlanStatus.upcoming,
    ),
    PhilotesPlan(
      id: 'dev-dinner',
      title: 'Dinner Downtown',
      dateLabel: 'August 7',
      timeLabel: '6:30 PM',
      locationName:
          'Downtown Durham',
      locationArea: 'Durham, NC',
      attendees: <String>[
        'Alex',
        'Jordan',
        'Taylor',
      ],
      notes:
          'A relaxed dinner after work.',
      status:
          PhilotesPlanStatus.completed,
    ),
    PhilotesPlan(
      id: 'dev-movie-night',
      title: 'Movie Night',
      dateLabel: 'August 2',
      timeLabel: '7:15 PM',
      locationName:
          'Local Cinema',
      locationArea: 'Durham, NC',
      attendees: <String>[
        'Alex',
        'Taylor',
      ],
      notes:
          'Met in the lobby before '
          'the movie.',
      status:
          PhilotesPlanStatus.completed,
    ),
  ];

  @override
  List<PhilotesPlan> plans() {
    return _developmentPlans;
  }

  @override
  PhilotesPlan? planById(
    String planId,
  ) {
    for (
      final plan in _developmentPlans
    ) {
      if (plan.id == planId) {
        return plan;
      }
    }

    return null;
  }
}
