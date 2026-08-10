from pathlib import Path
from datetime import datetime
import re

SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = SCRIPT_DIR.parent.parent

APP_ROOT = PROJECT_ROOT / "apps" / "philotes_app"
LIB_ROOT = APP_ROOT / "lib"
TEST_ROOT = APP_ROOT / "test"

REPORT_PATH = SCRIPT_DIR / "developerpatchscript_report.txt"

INTEREST_MODEL = LIB_ROOT / "models" / "interest_item.dart"
INTEREST_DATA = LIB_ROOT / "data" / "interests.dart"

INTERESTS_SCREEN = (
    LIB_ROOT
    / "screens"
    / "onboarding"
    / "interests_screen.dart"
)

BASIC_PROFILE_SCREEN = (
    LIB_ROOT
    / "screens"
    / "onboarding"
    / "basic_profile_screen.dart"
)

WIDGET_TEST = TEST_ROOT / "widget_test.dart"


INTEREST_MODEL_CONTENT = r"""class InterestItem {
  const InterestItem({
    required this.id,
    required this.name,
    required this.category,
  });

  final String id;
  final String name;
  final String category;
}
"""


INTEREST_DATA_CONTENT = r"""import '../models/interest_item.dart';

abstract final class InterestsData {
  static const String sportsRecreation = 'Sports & Recreation';
  static const String sportsFans = 'Sports Fans & Live Events';
  static const String entertainment = 'Entertainment';
  static const String gamingTechnology = 'Gaming & Technology';
  static const String foodSocial = 'Food & Social Activities';
  static const String creativeHobbies = 'Creative & Hobbies';
  static const String learningCulture = 'Learning & Culture';
  static const String outdoorsTravel = 'Outdoors & Travel';
  static const String communityLifestyle = 'Community & Lifestyle';

  static const List<String> categories = [
    sportsRecreation,
    sportsFans,
    entertainment,
    gamingTechnology,
    foodSocial,
    creativeHobbies,
    learningCulture,
    outdoorsTravel,
    communityLifestyle,
  ];

  static const List<InterestItem> interests = [
    // Sports & Recreation
    InterestItem(
      id: 'golf',
      name: 'Golf',
      category: sportsRecreation,
    ),
    InterestItem(
      id: 'bowling',
      name: 'Bowling',
      category: sportsRecreation,
    ),
    InterestItem(
      id: 'tennis',
      name: 'Tennis',
      category: sportsRecreation,
    ),
    InterestItem(
      id: 'pickleball',
      name: 'Pickleball',
      category: sportsRecreation,
    ),
    InterestItem(
      id: 'basketball_play',
      name: 'Playing Basketball',
      category: sportsRecreation,
    ),
    InterestItem(
      id: 'baseball_play',
      name: 'Playing Baseball',
      category: sportsRecreation,
    ),
    InterestItem(
      id: 'soccer_play',
      name: 'Playing Soccer',
      category: sportsRecreation,
    ),
    InterestItem(
      id: 'football_play',
      name: 'Playing Football',
      category: sportsRecreation,
    ),
    InterestItem(
      id: 'hockey_play',
      name: 'Playing Hockey',
      category: sportsRecreation,
    ),
    InterestItem(
      id: 'running',
      name: 'Running',
      category: sportsRecreation,
    ),
    InterestItem(
      id: 'fitness',
      name: 'Gym & Fitness',
      category: sportsRecreation,
    ),
    InterestItem(
      id: 'swimming',
      name: 'Swimming',
      category: sportsRecreation,
    ),
    InterestItem(
      id: 'hiking',
      name: 'Hiking',
      category: sportsRecreation,
    ),
    InterestItem(
      id: 'biking',
      name: 'Biking',
      category: sportsRecreation,
    ),
    InterestItem(
      id: 'fishing',
      name: 'Fishing',
      category: sportsRecreation,
    ),
    InterestItem(
      id: 'camping',
      name: 'Camping',
      category: sportsRecreation,
    ),
    InterestItem(
      id: 'martial_arts',
      name: 'Martial Arts',
      category: sportsRecreation,
    ),

    // Sports Fans & Live Events
    InterestItem(
      id: 'sporting_events',
      name: 'Going to Sporting Events',
      category: sportsFans,
    ),
    InterestItem(
      id: 'football_fan',
      name: 'Football',
      category: sportsFans,
    ),
    InterestItem(
      id: 'basketball_fan',
      name: 'Basketball',
      category: sportsFans,
    ),
    InterestItem(
      id: 'baseball_fan',
      name: 'Baseball',
      category: sportsFans,
    ),
    InterestItem(
      id: 'hockey_fan',
      name: 'Hockey',
      category: sportsFans,
    ),
    InterestItem(
      id: 'soccer_fan',
      name: 'Soccer',
      category: sportsFans,
    ),
    InterestItem(
      id: 'college_sports',
      name: 'College Sports',
      category: sportsFans,
    ),
    InterestItem(
      id: 'motorsports',
      name: 'Motorsports',
      category: sportsFans,
    ),
    InterestItem(
      id: 'golf_tournaments',
      name: 'Golf Tournaments',
      category: sportsFans,
    ),
    InterestItem(
      id: 'tennis_events',
      name: 'Tennis Events',
      category: sportsFans,
    ),
    InterestItem(
      id: 'watch_parties',
      name: 'Watch Parties',
      category: sportsFans,
    ),

    // Entertainment
    InterestItem(
      id: 'movies',
      name: 'Movies',
      category: entertainment,
    ),
    InterestItem(
      id: 'television',
      name: 'TV & Streaming',
      category: entertainment,
    ),
    InterestItem(
      id: 'theater',
      name: 'Theater',
      category: entertainment,
    ),
    InterestItem(
      id: 'concerts',
      name: 'Concerts',
      category: entertainment,
    ),
    InterestItem(
      id: 'live_music',
      name: 'Live Music',
      category: entertainment,
    ),
    InterestItem(
      id: 'comedy',
      name: 'Comedy Shows',
      category: entertainment,
    ),
    InterestItem(
      id: 'festivals',
      name: 'Festivals',
      category: entertainment,
    ),
    InterestItem(
      id: 'museums',
      name: 'Museums',
      category: entertainment,
    ),
    InterestItem(
      id: 'theme_parks',
      name: 'Theme Parks',
      category: entertainment,
    ),

    // Gaming & Technology
    InterestItem(
      id: 'video_games',
      name: 'Video Games',
      category: gamingTechnology,
    ),
    InterestItem(
      id: 'board_games',
      name: 'Board Games',
      category: gamingTechnology,
    ),
    InterestItem(
      id: 'tabletop_games',
      name: 'Tabletop Games',
      category: gamingTechnology,
    ),
    InterestItem(
      id: 'card_games',
      name: 'Card Games',
      category: gamingTechnology,
    ),
    InterestItem(
      id: 'technology',
      name: 'Technology',
      category: gamingTechnology,
    ),
    InterestItem(
      id: 'artificial_intelligence',
      name: 'Artificial Intelligence',
      category: gamingTechnology,
    ),
    InterestItem(
      id: 'coding',
      name: 'Coding',
      category: gamingTechnology,
    ),
    InterestItem(
      id: 'gadgets',
      name: 'Gadgets',
      category: gamingTechnology,
    ),
    InterestItem(
      id: 'virtual_reality',
      name: 'Virtual Reality',
      category: gamingTechnology,
    ),

    // Food & Social Activities
    InterestItem(
      id: 'restaurants',
      name: 'Trying Restaurants',
      category: foodSocial,
    ),
    InterestItem(
      id: 'coffee',
      name: 'Coffee',
      category: foodSocial,
    ),
    InterestItem(
      id: 'cooking',
      name: 'Cooking',
      category: foodSocial,
    ),
    InterestItem(
      id: 'baking',
      name: 'Baking',
      category: foodSocial,
    ),
    InterestItem(
      id: 'food_festivals',
      name: 'Food Festivals',
      category: foodSocial,
    ),
    InterestItem(
      id: 'trivia',
      name: 'Trivia Nights',
      category: foodSocial,
    ),
    InterestItem(
      id: 'brunch',
      name: 'Brunch',
      category: foodSocial,
    ),
    InterestItem(
      id: 'dinner_out',
      name: 'Dinner Out',
      category: foodSocial,
    ),

    // Creative & Hobbies
    InterestItem(
      id: 'photography',
      name: 'Photography',
      category: creativeHobbies,
    ),
    InterestItem(
      id: 'art',
      name: 'Art',
      category: creativeHobbies,
    ),
    InterestItem(
      id: 'drawing',
      name: 'Drawing',
      category: creativeHobbies,
    ),
    InterestItem(
      id: 'painting',
      name: 'Painting',
      category: creativeHobbies,
    ),
    InterestItem(
      id: 'writing',
      name: 'Writing',
      category: creativeHobbies,
    ),
    InterestItem(
      id: 'crafts',
      name: 'Crafts',
      category: creativeHobbies,
    ),
    InterestItem(
      id: 'woodworking',
      name: 'Woodworking',
      category: creativeHobbies,
    ),
    InterestItem(
      id: 'collecting',
      name: 'Collecting',
      category: creativeHobbies,
    ),
    InterestItem(
      id: 'playing_music',
      name: 'Playing Music',
      category: creativeHobbies,
    ),

    // Learning & Culture
    InterestItem(
      id: 'history',
      name: 'History',
      category: learningCulture,
    ),
    InterestItem(
      id: 'science',
      name: 'Science',
      category: learningCulture,
    ),
    InterestItem(
      id: 'languages',
      name: 'Languages',
      category: learningCulture,
    ),
    InterestItem(
      id: 'books',
      name: 'Books',
      category: learningCulture,
    ),
    InterestItem(
      id: 'book_clubs',
      name: 'Book Clubs',
      category: learningCulture,
    ),
    InterestItem(
      id: 'documentaries',
      name: 'Documentaries',
      category: learningCulture,
    ),
    InterestItem(
      id: 'cultural_events',
      name: 'Cultural Events',
      category: learningCulture,
    ),

    // Outdoors & Travel
    InterestItem(
      id: 'road_trips',
      name: 'Road Trips',
      category: outdoorsTravel,
    ),
    InterestItem(
      id: 'travel',
      name: 'Travel',
      category: outdoorsTravel,
    ),
    InterestItem(
      id: 'beaches',
      name: 'Beaches',
      category: outdoorsTravel,
    ),
    InterestItem(
      id: 'mountains',
      name: 'Mountains',
      category: outdoorsTravel,
    ),
    InterestItem(
      id: 'parks',
      name: 'Parks',
      category: outdoorsTravel,
    ),
    InterestItem(
      id: 'sightseeing',
      name: 'Sightseeing',
      category: outdoorsTravel,
    ),
    InterestItem(
      id: 'cruises',
      name: 'Cruises',
      category: outdoorsTravel,
    ),
    InterestItem(
      id: 'nature',
      name: 'Nature',
      category: outdoorsTravel,
    ),

    // Community & Lifestyle
    InterestItem(
      id: 'volunteering',
      name: 'Volunteering',
      category: communityLifestyle,
    ),
    InterestItem(
      id: 'community_events',
      name: 'Community Events',
      category: communityLifestyle,
    ),
    InterestItem(
      id: 'pets',
      name: 'Pets',
      category: communityLifestyle,
    ),
    InterestItem(
      id: 'gardening',
      name: 'Gardening',
      category: communityLifestyle,
    ),
    InterestItem(
      id: 'home_improvement',
      name: 'Home Improvement',
      category: communityLifestyle,
    ),
    InterestItem(
      id: 'cars',
      name: 'Cars',
      category: communityLifestyle,
    ),
    InterestItem(
      id: 'motorcycles',
      name: 'Motorcycles',
      category: communityLifestyle,
    ),
    InterestItem(
      id: 'faith_community',
      name: 'Faith & Community Activities',
      category: communityLifestyle,
    ),
  ];
}
"""


INTERESTS_SCREEN_CONTENT = r"""import 'package:flutter/material.dart';

import '../../data/interests.dart';
import '../../models/interest_item.dart';
import '../../theme/philotes_colors.dart';

class InterestsScreen extends StatefulWidget {
  const InterestsScreen({super.key});

  @override
  State<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  static const int minimumSelections = 5;
  static const int maximumFavorites = 3;

  final TextEditingController _searchController =
      TextEditingController();

  final TextEditingController _customInterestController =
      TextEditingController();

  final Set<String> _selectedIds = <String>{};
  final Set<String> _favoriteIds = <String>{};

  final List<InterestItem> _customInterests = <InterestItem>[];

  String _searchText = '';
  bool _showValidation = false;

  int get _selectedCount => _selectedIds.length;

  int get _favoriteCount => _favoriteIds.length;

  bool get _minimumReached =>
      _selectedCount >= minimumSelections;

  List<InterestItem> get _allInterests => [
        ...InterestsData.interests,
        ..._customInterests,
      ];

  void _toggleInterest(InterestItem interest) {
    setState(() {
      if (_selectedIds.contains(interest.id)) {
        _selectedIds.remove(interest.id);
        _favoriteIds.remove(interest.id);
      } else {
        _selectedIds.add(interest.id);
      }

      if (_minimumReached) {
        _showValidation = false;
      }
    });
  }

  void _toggleFavorite(InterestItem interest) {
    if (!_selectedIds.contains(interest.id)) {
      return;
    }

    setState(() {
      if (_favoriteIds.contains(interest.id)) {
        _favoriteIds.remove(interest.id);
        return;
      }

      if (_favoriteIds.length >= maximumFavorites) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'You can choose up to 3 favorite interests.',
            ),
          ),
        );
        return;
      }

      _favoriteIds.add(interest.id);
    });
  }

  void _addCustomInterest() {
    final value = _customInterestController.text.trim();

    if (value.isEmpty) {
      return;
    }

    final alreadyExists = _allInterests.any(
      (interest) =>
          interest.name.toLowerCase() == value.toLowerCase(),
    );

    if (alreadyExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'That interest is already available.',
          ),
        ),
      );
      return;
    }

    final id = 'custom_${DateTime.now().microsecondsSinceEpoch}';

    final customInterest = InterestItem(
      id: id,
      name: value,
      category: 'Your Custom Interests',
    );

    setState(() {
      _customInterests.add(customInterest);
      _selectedIds.add(id);
      _customInterestController.clear();

      if (_minimumReached) {
        _showValidation = false;
      }
    });
  }

  bool _matchesSearch(InterestItem interest) {
    if (_searchText.trim().isEmpty) {
      return true;
    }

    final query = _searchText.toLowerCase();

    return interest.name.toLowerCase().contains(query) ||
        interest.category.toLowerCase().contains(query);
  }

  void _continue() {
    if (!_minimumReached) {
      setState(() {
        _showValidation = true;
      });

      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Friendship Preferences will be the next onboarding step.',
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _customInterestController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visibleInterests = _allInterests
        .where(_matchesSearch)
        .toList();

    final categoryNames = <String>[
      ...InterestsData.categories,
      if (_customInterests.isNotEmpty) 'Your Custom Interests',
    ];

    return Scaffold(
      backgroundColor: PhilotesColors.ivory,
      appBar: AppBar(
        backgroundColor: PhilotesColors.ivory,
        foregroundColor: PhilotesColors.navy,
        elevation: 0,
        title: const Text(
          'Join Philotes',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              20,
              20,
              20,
              36,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 760,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Your Interests',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: PhilotesColors.navy,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Center(
                    child: Container(
                      width: 120,
                      height: 2,
                      decoration: BoxDecoration(
                        color: PhilotesColors.gold,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'What do you enjoy doing?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: PhilotesColors.navy,
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Choose at least 5 interests. You can also mark up to '
                    '3 favorites with a gold star. Everything can be changed '
                    'later.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: PhilotesColors.silver,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 22),

                  _ProgressPanel(
                    selectedCount: _selectedCount,
                    favoriteCount: _favoriteCount,
                    minimumReached: _minimumReached,
                  ),

                  if (_showValidation) ...[
                    const SizedBox(height: 12),

                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.red.shade600,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red.shade700,
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              'Choose at least 5 interests before continuing.',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  TextField(
                    key: const Key('interestSearchField'),
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchText = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search interests...',
                      prefixIcon: const Icon(
                        Icons.search,
                      ),
                      suffixIcon: _searchText.isEmpty
                          ? null
                          : IconButton(
                              tooltip: 'Clear search',
                              onPressed: () {
                                _searchController.clear();

                                setState(() {
                                  _searchText = '';
                                });
                              },
                              icon: const Icon(
                                Icons.close,
                              ),
                            ),
                      filled: true,
                      fillColor:
                          Colors.white.withValues(alpha: 0.65),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: PhilotesColors.gold
                              .withValues(alpha: 0.65),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: PhilotesColors.gold,
                          width: 2,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 26),

                  if (visibleInterests.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        'No matching interests were found. You can add your '
                        'own interest below.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: PhilotesColors.silver,
                          fontSize: 14,
                        ),
                      ),
                    )
                  else
                    for (final category in categoryNames)
                      _CategorySection(
                        category: category,
                        interests: visibleInterests
                            .where(
                              (interest) =>
                                  interest.category == category,
                            )
                            .toList(),
                        selectedIds: _selectedIds,
                        favoriteIds: _favoriteIds,
                        onToggleInterest: _toggleInterest,
                        onToggleFavorite: _toggleFavorite,
                      ),

                  const SizedBox(height: 14),

                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color:
                            PhilotesColors.gold.withValues(alpha: 0.65),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.add_circle_outline,
                              color: PhilotesColors.gold,
                            ),
                            SizedBox(width: 9),
                            Text(
                              'Something Missing?',
                              style: TextStyle(
                                color: PhilotesColors.navy,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'Add an interest that is not already listed.',
                          style: TextStyle(
                            color: PhilotesColors.silver,
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 14),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextField(
                                key:
                                    const Key('customInterestField'),
                                controller:
                                    _customInterestController,
                                textInputAction:
                                    TextInputAction.done,
                                onSubmitted: (_) {
                                  _addCustomInterest();
                                },
                                decoration: InputDecoration(
                                  hintText: 'Add your interest',
                                  filled: true,
                                  fillColor: PhilotesColors.ivory,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(12),
                                  ),
                                  enabledBorder:
                                      OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: PhilotesColors.gold
                                          .withValues(alpha: 0.65),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 10),

                            IconButton.filled(
                              key:
                                  const Key('addCustomInterestButton'),
                              tooltip: 'Add interest',
                              onPressed: _addCustomInterest,
                              style: IconButton.styleFrom(
                                backgroundColor:
                                    PhilotesColors.navy,
                                foregroundColor: Colors.white,
                              ),
                              icon: const Icon(
                                Icons.add,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  if (_minimumReached)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.celebration_outlined,
                            color: PhilotesColors.gold,
                          ),
                          SizedBox(width: 9),
                          Flexible(
                            child: Text(
                              'Great! These interests will help Philotes '
                              'build your community.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: PhilotesColors.navy,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  SizedBox(
                    height: 56,
                    child: FilledButton(
                      key: const Key('interestsContinueButton'),
                      onPressed: _continue,
                      style: FilledButton.styleFrom(
                        backgroundColor: PhilotesColors.navy,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'Friendship  •  Trust  •  Community  •  Connection',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: PhilotesColors.gold,
                      fontSize: 11,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressPanel extends StatelessWidget {
  const _ProgressPanel({
    required this.selectedCount,
    required this.favoriteCount,
    required this.minimumReached,
  });

  final int selectedCount;
  final int favoriteCount;
  final bool minimumReached;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: minimumReached
            ? PhilotesColors.gold.withValues(alpha: 0.14)
            : Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: PhilotesColors.gold.withValues(alpha: 0.7),
        ),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 18,
        runSpacing: 8,
        children: [
          _ProgressItem(
            icon: minimumReached
                ? Icons.check_circle_outline
                : Icons.interests_outlined,
            text: '$selectedCount selected',
          ),
          _ProgressItem(
            icon: Icons.star_outline,
            text: '$favoriteCount of 3 favorites',
          ),
        ],
      ),
    );
  }
}

class _ProgressItem extends StatelessWidget {
  const _ProgressItem({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: PhilotesColors.gold,
          size: 20,
        ),
        const SizedBox(width: 7),
        Text(
          text,
          style: const TextStyle(
            color: PhilotesColors.navy,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({
    required this.category,
    required this.interests,
    required this.selectedIds,
    required this.favoriteIds,
    required this.onToggleInterest,
    required this.onToggleFavorite,
  });

  final String category;
  final List<InterestItem> interests;
  final Set<String> selectedIds;
  final Set<String> favoriteIds;
  final ValueChanged<InterestItem> onToggleInterest;
  final ValueChanged<InterestItem> onToggleFavorite;

  IconData get _categoryIcon {
    switch (category) {
      case InterestsData.sportsRecreation:
        return Icons.sports_outlined;
      case InterestsData.sportsFans:
        return Icons.stadium_outlined;
      case InterestsData.entertainment:
        return Icons.movie_outlined;
      case InterestsData.gamingTechnology:
        return Icons.sports_esports_outlined;
      case InterestsData.foodSocial:
        return Icons.restaurant_outlined;
      case InterestsData.creativeHobbies:
        return Icons.palette_outlined;
      case InterestsData.learningCulture:
        return Icons.auto_stories_outlined;
      case InterestsData.outdoorsTravel:
        return Icons.travel_explore_outlined;
      case InterestsData.communityLifestyle:
        return Icons.groups_outlined;
      default:
        return Icons.star_border;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (interests.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: PhilotesColors.navy,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: PhilotesColors.gold,
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  _categoryIcon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  category,
                  style: const TextStyle(
                    color: PhilotesColors.navy,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Wrap(
            spacing: 9,
            runSpacing: 9,
            children: [
              for (final interest in interests)
                _InterestChip(
                  key: Key('interest-${interest.id}'),
                  interest: interest,
                  selected:
                      selectedIds.contains(interest.id),
                  favorite:
                      favoriteIds.contains(interest.id),
                  onToggle: () {
                    onToggleInterest(interest);
                  },
                  onFavorite: () {
                    onToggleFavorite(interest);
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InterestChip extends StatelessWidget {
  const _InterestChip({
    super.key,
    required this.interest,
    required this.selected,
    required this.favorite,
    required this.onToggle,
    required this.onFavorite,
  });

  final InterestItem interest;
  final bool selected;
  final bool favorite;
  final VoidCallback onToggle;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? PhilotesColors.navy
          : Colors.white.withValues(alpha: 0.7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(
          color: selected
              ? PhilotesColors.navy
              : PhilotesColors.gold.withValues(alpha: 0.7),
          width: selected ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onToggle,
        child: Padding(
          padding: EdgeInsets.only(
            left: 14,
            right: selected ? 4 : 14,
            top: 7,
            bottom: 7,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                interest.name,
                style: TextStyle(
                  color: selected
                      ? Colors.white
                      : PhilotesColors.navy,
                  fontSize: 13,
                  fontWeight: selected
                      ? FontWeight.w600
                      : FontWeight.w500,
                ),
              ),

              if (selected) ...[
                const SizedBox(width: 4),

                IconButton(
                  key: Key('favorite-${interest.id}'),
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
                    favorite
                        ? Icons.star
                        : Icons.star_border,
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
"""


WIDGET_TEST_CONTENT = r"""import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:philotes/screens/onboarding/interests_screen.dart';

void main() {
  testWidgets(
    'Interests requires five selections and supports favorites',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: InterestsScreen(),
        ),
      );

      expect(
        find.text('Your Interests'),
        findsOneWidget,
      );

      expect(
        find.text('0 selected'),
        findsOneWidget,
      );

      final continueButton = find.byKey(
        const Key('interestsContinueButton'),
      );

      await tester.ensureVisible(continueButton);
      await tester.pumpAndSettle();

      await tester.tap(continueButton);
      await tester.pumpAndSettle();

      expect(
        find.text(
          'Choose at least 5 interests before continuing.',
        ),
        findsOneWidget,
      );

      final interestsToSelect = [
        'golf',
        'bowling',
        'sporting_events',
        'movies',
        'technology',
      ];

      for (final id in interestsToSelect) {
        final finder = find.byKey(
          Key('interest-$id'),
        );

        await tester.ensureVisible(finder);
        await tester.pumpAndSettle();

        await tester.tap(finder);
        await tester.pumpAndSettle();
      }

      expect(
        find.text('5 selected'),
        findsOneWidget,
      );

      final golfFavorite = find.byKey(
        const Key('favorite-golf'),
      );

      await tester.ensureVisible(golfFavorite);
      await tester.pumpAndSettle();

      await tester.tap(golfFavorite);
      await tester.pumpAndSettle();

      expect(
        find.text('1 of 3 favorites'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Interests supports search',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: InterestsScreen(),
        ),
      );

      final searchField = find.byKey(
        const Key('interestSearchField'),
      );

      await tester.enterText(
        searchField,
        'sporting events',
      );

      await tester.pump();

      expect(
        find.text('Going to Sporting Events'),
        findsOneWidget,
      );
    },
  );
}
"""


def write_file(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(
        content,
        encoding="utf-8",
    )


def patch_basic_profile() -> None:
    if not BASIC_PROFILE_SCREEN.exists():
        raise RuntimeError(
            "Basic Profile screen was not found."
        )

    text = BASIC_PROFILE_SCREEN.read_text(
        encoding="utf-8",
    )

    interests_import = "import 'interests_screen.dart';"

    if interests_import not in text:
        theme_import = (
            "import '../../theme/philotes_colors.dart';"
        )

        if theme_import not in text:
            raise RuntimeError(
                "Could not find the Philotes colors import "
                "inside basic_profile_screen.dart."
            )

        text = text.replace(
            theme_import,
            theme_import + "\n" + interests_import,
            1,
        )

    if "const InterestsScreen()" not in text:
        pattern = re.compile(
            r"""
            ScaffoldMessenger\.of\(context\)\.showSnackBar\(
            .*?
            Interests\ will\ be\ the\ next\ onboarding\ step\.
            .*?
            \);
            """,
            re.VERBOSE | re.DOTALL,
        )

        replacement = """Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => const InterestsScreen(),
      ),
    );"""

        text, replacement_count = pattern.subn(
            replacement,
            text,
            count=1,
        )

        if replacement_count != 1:
            raise RuntimeError(
                "Could not locate the temporary Interests "
                "message in basic_profile_screen.dart."
            )

    BASIC_PROFILE_SCREEN.write_text(
        text,
        encoding="utf-8",
    )


def main() -> None:
    print()
    print("=" * 76)
    print("PHILOTES PAGE 7 - INTERESTS PATCH")
    print("=" * 76)
    print()

    if not APP_ROOT.exists():
        print(
            f"FAIL: Flutter application not found: {APP_ROOT}"
        )
        raise SystemExit(1)

    try:
        write_file(
            INTEREST_MODEL,
            INTEREST_MODEL_CONTENT,
        )

        write_file(
            INTEREST_DATA,
            INTEREST_DATA_CONTENT,
        )

        write_file(
            INTERESTS_SCREEN,
            INTERESTS_SCREEN_CONTENT,
        )

        write_file(
            WIDGET_TEST,
            WIDGET_TEST_CONTENT,
        )

        patch_basic_profile()

    except Exception as exc:
        print(f"FAIL: {exc}")
        raise SystemExit(1)

    print(
        "WROTE: "
        f"{INTEREST_MODEL.relative_to(PROJECT_ROOT)}"
    )

    print(
        "WROTE: "
        f"{INTEREST_DATA.relative_to(PROJECT_ROOT)}"
    )

    print(
        "WROTE: "
        f"{INTERESTS_SCREEN.relative_to(PROJECT_ROOT)}"
    )

    print(
        "UPDATED: "
        f"{BASIC_PROFILE_SCREEN.relative_to(PROJECT_ROOT)}"
    )

    print(
        "WROTE: "
        f"{WIDGET_TEST.relative_to(PROJECT_ROOT)}"
    )

    model_text = INTEREST_MODEL.read_text(
        encoding="utf-8",
    )

    data_text = INTEREST_DATA.read_text(
        encoding="utf-8",
    )

    screen_text = INTERESTS_SCREEN.read_text(
        encoding="utf-8",
    )

    basic_profile_text = BASIC_PROFILE_SCREEN.read_text(
        encoding="utf-8",
    )

    test_text = WIDGET_TEST.read_text(
        encoding="utf-8",
    )

    checks = {
        "Interest model exists":
            INTEREST_MODEL.exists(),

        "Interest data exists":
            INTEREST_DATA.exists(),

        "Interests screen exists":
            INTERESTS_SCREEN.exists(),

        "Sports & Recreation category present":
            "Sports & Recreation" in data_text,

        "Sports Fans & Live Events category present":
            "Sports Fans & Live Events" in data_text,

        "Going to Sporting Events present":
            "Going to Sporting Events" in data_text,

        "Entertainment category present":
            "Entertainment" in data_text,

        "Gaming & Technology category present":
            "Gaming & Technology" in data_text,

        "Food & Social Activities category present":
            "Food & Social Activities" in data_text,

        "Creative & Hobbies category present":
            "Creative & Hobbies" in data_text,

        "Learning & Culture category present":
            "Learning & Culture" in data_text,

        "Outdoors & Travel category present":
            "Outdoors & Travel" in data_text,

        "Community & Lifestyle category present":
            "Community & Lifestyle" in data_text,

        "Minimum five interests enforced":
            "minimumSelections = 5" in screen_text,

        "Three favorites maximum present":
            "maximumFavorites = 3" in screen_text,

        "Interest search present":
            "interestSearchField" in screen_text,

        "Custom interest support present":
            "customInterestField" in screen_text,

        "Favorite controls present":
            "favorite-" in screen_text,

        "Basic Profile navigates to Interests":
            "InterestsScreen()" in basic_profile_text,

        "Widget tests updated":
            "5 selected" in test_text,
    }

    all_passed = True

    report = [
        "PHILOTES PAGE 7 - INTERESTS PATCH REPORT",
        "=" * 76,
        f"Generated: {datetime.now().isoformat(timespec='seconds')}",
        f"Project root: {PROJECT_ROOT}",
        "",
    ]

    for description, passed in checks.items():
        status = "PASS" if passed else "FAIL"

        print(f"{status}: {description}")
        report.append(
            f"{status}: {description}"
        )

        if not passed:
            all_passed = False

    report.extend(
        [
            "",
            f"OVERALL: {'PASS' if all_passed else 'FAIL'}",
            "",
            "This patch:",
            "- Adds Page 7: Your Interests.",
            "- Requires at least 5 selected interests.",
            "- Allows up to 3 optional favorites.",
            "- Adds searchable interest categories.",
            "- Adds Sports Fans & Live Events.",
            "- Distinguishes sports participation from fandom.",
            "- Adds Going to Sporting Events.",
            "- Adds custom interests.",
            "- Connects Basic Profile to Interests.",
            "- Does not persist interests to the backend yet.",
            "- Does not perform friendship matching yet.",
        ]
    )

    REPORT_PATH.write_text(
        "\n".join(report) + "\n",
        encoding="utf-8",
    )

    print()
    print(f"Report: {REPORT_PATH}")
    print()

    print(
        f"OVERALL: {'PASS' if all_passed else 'FAIL'}"
    )

    if not all_passed:
        raise SystemExit(1)


if __name__ == "__main__":
    main()