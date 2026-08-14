import 'package:flutter/material.dart';

import '../../data/philotes_activity_catalog.dart';
import '../../models/onboarding_profile_data.dart';
import '../../theme/philotes_colors.dart';
import '../../widgets/interests/philotes_interest_widgets.dart';
import 'friendship_preferences_screen.dart';

class InterestsScreen extends StatefulWidget {
  const InterestsScreen({super.key});

  @override
  State<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  static const int minimumSelections = 5;
  static const int maximumFavorites = 5;

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _customInterestController =
      TextEditingController();

  final Set<String> _selected = <String>{};
  final Set<String> _favorites = <String>{};
  final List<String> _customInterests = <String>[];

  String _searchText = '';
  bool _showValidation = false;

  int get _selectedCount => _selected.length;
  int get _favoriteCount => _favorites.length;
  bool get _minimumReached => _selectedCount >= minimumSelections;

  int _suggestionCount(double width) {
    if (width >= 900) return 16;
    if (width >= 600) return 12;
    return 8;
  }

  void _toggleInterest(String interest) {
    setState(() {
      if (_selected.contains(interest)) {
        _selected.remove(interest);
        _favorites.remove(interest);
      } else {
        _selected.add(interest);
      }
      if (_minimumReached) _showValidation = false;
    });
  }

  void _toggleFavorite(String interest) {
    if (!_selected.contains(interest)) return;

    setState(() {
      if (_favorites.contains(interest)) {
        _favorites.remove(interest);
        return;
      }
      if (_favorites.length >= maximumFavorites) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You can choose up to 5 favorite interests.'),
          ),
        );
        return;
      }
      _favorites.add(interest);
    });
  }

  void _addCustomInterest() {
    final value = _customInterestController.text.trim();
    if (value.isEmpty) return;

    final exists = <String>[
      ...PhilotesActivityCatalog.allActivities,
      ..._customInterests,
    ].any((item) => item.toLowerCase() == value.toLowerCase());

    if (exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('That interest is already available.')),
      );
      return;
    }

    setState(() {
      _customInterests.add(value);
      _selected.add(value);
      _customInterestController.clear();
      if (_minimumReached) _showValidation = false;
    });
  }

  List<String> get _searchResults {
    final query = _searchText.trim().toLowerCase();
    if (query.isEmpty) return const <String>[];

    return <String>[
      ...PhilotesActivityCatalog.allActivities,
      ..._customInterests,
    ].where((item) => item.toLowerCase().contains(query)).toSet().toList();
  }

  void _openAllActivities() {
    Navigator.of(context)
        .push(
          MaterialPageRoute<void>(
            builder: (context) => OnboardingAllActivitiesScreen(
              selected: _selected,
              favorites: _favorites,
              onToggleInterest: _toggleInterest,
              onToggleFavorite: _toggleFavorite,
            ),
          ),
        )
        .then((_) {
          if (mounted) setState(() {});
        });
  }

  void _continue() {
    if (!_minimumReached) {
      setState(() => _showValidation = true);
      return;
    }

    final profile = OnboardingProfileData.instance;
    profile.selectedInterests = _selected.toList();
    profile.favoriteInterests = _favorites.toList();

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => const FriendshipPreferencesScreen(),
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
    return Scaffold(
      backgroundColor: PhilotesColors.ivory,
      appBar: AppBar(
        backgroundColor: PhilotesColors.ivory,
        foregroundColor: PhilotesColors.navy,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Join Philotes',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
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
                    '5 favorites with a gold star. Everything can be changed '
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
                        border: Border.all(color: Colors.red.shade600),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red.shade700),
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
                    onChanged: (value) => setState(() => _searchText = value),
                    decoration:
                        philotesInterestInputDecoration(
                          hintText: 'Search interests...',
                          prefixIcon: Icons.search,
                        ).copyWith(
                          suffixIcon: _searchText.isEmpty
                              ? null
                              : IconButton(
                                  tooltip: 'Clear search',
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _searchText = '');
                                  },
                                  icon: const Icon(Icons.close),
                                ),
                        ),
                  ),
                  const SizedBox(height: 22),
                  if (_searchText.trim().isNotEmpty)
                    PhilotesInterestCard(
                      key: const Key('interestSearchResultsCard'),
                      title: 'Search Results',
                      subtitle: _searchResults.isEmpty
                          ? 'No listed activities match. You can add your own below.'
                          : 'Results from the complete Philotes activity catalog.',
                      icon: Icons.search,
                      child: _searchResults.isEmpty
                          ? const SizedBox.shrink()
                          : Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                for (final interest in _searchResults)
                                  PhilotesInterestChip(
                                    key: Key('searchInterest-$interest'),
                                    label: interest,
                                    selected: _selected.contains(interest),
                                    favorite: _favorites.contains(interest),
                                    onTap: () => _toggleInterest(interest),
                                    onFavorite: () => _toggleFavorite(interest),
                                  ),
                              ],
                            ),
                    )
                  else
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final visible = PhilotesActivityCatalog
                            .starterActivities
                            .take(_suggestionCount(constraints.maxWidth))
                            .toList();
                        return PhilotesInterestCard(
                          key: const Key('interestSuggestionsCard'),
                          title: 'Explore Some Ideas',
                          subtitle:
                              'A few general ideas to get you started. Choose anything that sounds like you.',
                          icon: Icons.lightbulb_outline,
                          child: Wrap(
                            key: const Key('interestSuggestions'),
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (final interest in visible)
                                PhilotesInterestChip(
                                  key: Key('interestStarter-$interest'),
                                  label: interest,
                                  selected: _selected.contains(interest),
                                  favorite: _favorites.contains(interest),
                                  onTap: () => _toggleInterest(interest),
                                  onFavorite: () => _toggleFavorite(interest),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 14),
                  OutlinedButton.icon(
                    key: const Key('viewAllActivitiesButton'),
                    onPressed: _openAllActivities,
                    icon: const Icon(Icons.grid_view_outlined),
                    label: const Text('View All Activities'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: PhilotesColors.navy,
                      backgroundColor: Colors.white.withValues(alpha: 0.45),
                      side: const BorderSide(
                        color: PhilotesColors.gold,
                        width: 1.5,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  PhilotesInterestCard(
                    key: const Key('makeItYoursCard'),
                    title: 'Make It Yours',
                    subtitle:
                        'We have some general activities listed, but your interests do not have to be on our list. Type any activity or interest below and tap the plus button to add it.',
                    icon: Icons.add_circle_outline,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            key: const Key('customInterestField'),
                            controller: _customInterestController,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _addCustomInterest(),
                            decoration: philotesInterestInputDecoration(
                              hintText: 'Add your own interest',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton.filled(
                          key: const Key('addCustomInterestButton'),
                          onPressed: _addCustomInterest,
                          tooltip: 'Add interest',
                          icon: const Icon(Icons.add),
                          style: IconButton.styleFrom(
                            backgroundColor: PhilotesColors.navy,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(52, 52),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  if (_minimumReached)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.celebration_outlined,
                            color: PhilotesColors.gold,
                          ),
                          SizedBox(width: 9),
                          Flexible(
                            child: Text(
                              'Great! These interests will help Philotes build your community.',
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

class OnboardingAllActivitiesScreen extends StatefulWidget {
  const OnboardingAllActivitiesScreen({
    super.key,
    required this.selected,
    required this.favorites,
    required this.onToggleInterest,
    required this.onToggleFavorite,
  });

  final Set<String> selected;
  final Set<String> favorites;
  final ValueChanged<String> onToggleInterest;
  final ValueChanged<String> onToggleFavorite;

  @override
  State<OnboardingAllActivitiesScreen> createState() =>
      _OnboardingAllActivitiesScreenState();
}

class _OnboardingAllActivitiesScreenState
    extends State<OnboardingAllActivitiesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _matches(String value) =>
      _query.isEmpty || value.toLowerCase().contains(_query.toLowerCase());

  @override
  Widget build(BuildContext context) {
    final categories = PhilotesActivityCatalog.categories.entries
        .map(
          (entry) => MapEntry(entry.key, entry.value.where(_matches).toList()),
        )
        .where((entry) => entry.value.isNotEmpty)
        .toList();

    return Scaffold(
      key: const Key('allActivitiesScreen'),
      backgroundColor: PhilotesColors.ivory,
      appBar: AppBar(
        backgroundColor: PhilotesColors.ivory,
        foregroundColor: PhilotesColors.navy,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'All Activities',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.2),
          child: Divider(
            height: 1.2,
            thickness: 1.2,
            color: PhilotesColors.gold,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PhilotesInterestCard(
                    title: 'Find an Activity',
                    icon: Icons.search,
                    child: TextField(
                      key: const Key('allActivitiesSearchField'),
                      controller: _searchController,
                      onChanged: (value) =>
                          setState(() => _query = value.trim()),
                      decoration: philotesInterestInputDecoration(
                        hintText: 'Search all activities',
                        prefixIcon: Icons.search,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  if (categories.isEmpty)
                    const PhilotesInterestCard(
                      title: 'No Matches',
                      icon: Icons.search_off,
                      child: Text(
                        'No listed activities match your search. Return to Your Interests to add anything you want.',
                        style: TextStyle(
                          color: PhilotesColors.silver,
                          fontSize: 13,
                        ),
                      ),
                    )
                  else
                    for (final category in categories) ...[
                      PhilotesInterestCard(
                        key: Key('activityCategory-${category.key}'),
                        title: category.key,
                        icon: _categoryIcon(category.key),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final interest in category.value)
                              PhilotesInterestChip(
                                key: Key('allActivity-$interest'),
                                label: interest,
                                selected: widget.selected.contains(interest),
                                favorite: widget.favorites.contains(interest),
                                onTap: () {
                                  widget.onToggleInterest(interest);
                                  setState(() {});
                                },
                                onFavorite: () {
                                  widget.onToggleFavorite(interest);
                                  setState(() {});
                                },
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Fitness & Wellness':
        return Icons.self_improvement_outlined;
      case 'Sports & Recreation':
        return Icons.sports_outlined;
      case 'Food & Social':
        return Icons.restaurant_outlined;
      case 'Arts & Culture':
        return Icons.palette_outlined;
      case 'Outdoors & Nature':
        return Icons.park_outlined;
      case 'Games & Entertainment':
        return Icons.sports_esports_outlined;
      case 'Learning & Hobbies':
        return Icons.auto_stories_outlined;
      case 'Community & Volunteering':
        return Icons.groups_outlined;
      case 'Travel & Exploration':
        return Icons.travel_explore_outlined;
      default:
        return Icons.interests_outlined;
    }
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: minimumReached
            ? PhilotesColors.gold.withValues(alpha: 0.14)
            : Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: PhilotesColors.gold.withValues(alpha: 0.7)),
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
            text: '$favoriteCount of 5 favorites',
          ),
        ],
      ),
    );
  }
}

class _ProgressItem extends StatelessWidget {
  const _ProgressItem({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: PhilotesColors.gold, size: 20),
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
