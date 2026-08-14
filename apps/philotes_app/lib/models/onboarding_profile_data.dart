class OnboardingProfileData {
  OnboardingProfileData._();

  static final OnboardingProfileData instance = OnboardingProfileData._();

  String firstName = '';
  String lastName = '';
  String displayName = '';
  DateTime? dateOfBirth;

  String? sex;
  String? otherSexDescription;
  String? pronouns;
  String introduction = '';

  List<String> selectedInterests = <String>[];
  List<String> favoriteInterests = <String>[];

  List<String> friendshipStyles = <String>[];

  String? socialFrequency;
  String? planningStyle;
  String? interestStyle;
  String? newActivityComfort;

  int minimumFriendAge = 18;
  int maximumFriendAge = 80;

  String politicsImportance = 'Not important';
  String? politicalOutlook;

  String faithImportance = 'Not important';
  String? faithDescription;

  bool flexibleDiscovery = true;

  String? locationSource;
  String? zipCode;
  String? meetingDistance;
  bool onlineFriendships = false;

  bool photoSelected = false;
  String? photoSource;

  String get generalAreaLabel {
    if (locationSource == 'zip' && zipCode != null && zipCode!.isNotEmpty) {
      return 'ZIP $zipCode area';
    }

    if (locationSource == 'device') {
      return 'Current device area';
    }

    return 'General area not selected';
  }

  String get meetingDistanceLabel {
    switch (meetingDistance) {
      case '10':
        return 'Very close — within about 10 miles';
      case '25':
        return 'Nearby — within about 25 miles';
      case '50':
        return 'A little farther — within about 50 miles';
      case 'farther':
        return 'Willing to travel more than 50 miles';
      case 'flexible':
        return 'Distance is flexible';
      default:
        return 'Not selected';
    }
  }

  String get friendAgeRangeLabel {
    final maximumLabel = maximumFriendAge >= 80
        ? '80+'
        : maximumFriendAge.toString();

    return '$minimumFriendAge - $maximumLabel';
  }

  void reset() {
    firstName = '';
    lastName = '';
    displayName = '';
    dateOfBirth = null;

    sex = null;
    otherSexDescription = null;
    pronouns = null;
    introduction = '';

    selectedInterests = <String>[];
    favoriteInterests = <String>[];

    friendshipStyles = <String>[];

    socialFrequency = null;
    planningStyle = null;
    interestStyle = null;
    newActivityComfort = null;

    minimumFriendAge = 18;
    maximumFriendAge = 80;

    politicsImportance = 'Not important';
    politicalOutlook = null;

    faithImportance = 'Not important';
    faithDescription = null;

    flexibleDiscovery = true;

    locationSource = null;
    zipCode = null;
    meetingDistance = null;
    onlineFriendships = false;

    photoSelected = false;
    photoSource = null;
  }
}
