import 'compatibility_result.dart';

class SuggestedMember {
  const SuggestedMember({
    required this.id,
    required this.displayName,
    required this.initials,
    required this.introduction,
    required this.compatibility,
    this.distanceMiles = 0,
  });

  final String id;

  /// Public-facing name selected by the member.
  ///
  /// Philotes does not manufacture a last-name
  /// initial from private account information.
  final String displayName;

  final String initials;
  final String introduction;

  final CompatibilityResult compatibility;

  /// Development/frontend representation of
  /// approximate discovery distance.
  ///
  /// Production distance will eventually come
  /// from the backend discovery service.
  final int distanceMiles;
}
