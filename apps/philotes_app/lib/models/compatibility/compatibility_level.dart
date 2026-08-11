enum CompatibilityLevel {
  strong,
  moderate,
  limited,
}

extension CompatibilityLevelLabel
    on CompatibilityLevel {
  String get label {
    switch (this) {
      case CompatibilityLevel.strong:
        return 'Strong';
      case CompatibilityLevel.moderate:
        return 'Moderate';
      case CompatibilityLevel.limited:
        return 'Limited';
    }
  }
}
