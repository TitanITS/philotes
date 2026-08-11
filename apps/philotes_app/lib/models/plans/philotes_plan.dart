enum PhilotesPlanStatus {
  today,
  upcoming,
  completed,
}

class PhilotesPlan {
  const PhilotesPlan({
    required this.id,
    required this.title,
    required this.dateLabel,
    required this.timeLabel,
    required this.locationName,
    required this.locationArea,
    required this.attendees,
    required this.notes,
    required this.status,
    this.isOrganizer = false,
  });

  final String id;
  final String title;

  /// Display labels are used by the frontend
  /// fixture only.
  ///
  /// Production will eventually use actual
  /// timestamps supplied by the backend.
  final String dateLabel;
  final String timeLabel;

  final String locationName;
  final String locationArea;

  /// Public-facing display names only.
  final List<String> attendees;

  final String notes;
  final PhilotesPlanStatus status;

  /// Determines whether plan-management actions
  /// should eventually be available to this user.
  final bool isOrganizer;

  bool get isPast =>
      status == PhilotesPlanStatus.completed;
}
