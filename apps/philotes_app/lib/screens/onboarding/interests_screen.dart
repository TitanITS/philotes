import 'package:flutter/material.dart';

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
  static const int maximumFavorites = 5;

  final TextEditingController _searchController = TextEditingController();

  final TextEditingController _customInterestController =
      TextEditingController();

  final Set<String> _selectedIds = <String>{};
  final Set<String> _favoriteIds = <String>{};

  final List<InterestItem> _customInterests = <InterestItem>[];

  String _searchText = '';
  bool _showValidation = false;

  int get _selectedCount => _selectedIds.length;

  int get _favoriteCount => _favoriteIds.length;

  bool get _minimumReached => _selectedCount >= minimumSelections;

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
            content: Text('You can choose up to 5 favorite interests.'),
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
      (interest) => interest.name.toLowerCase() == value.toLowerCase(),
    );

    if (alreadyExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('That interest is already available.')),
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
    final visibleInterests = _allInterests.where(_matchesSearch).toList();

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
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
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
                    onChanged: (value) {
                      setState(() {
                        _searchText = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search interests...',
                      prefixIcon: const Icon(Icons.search),
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
                              icon: const Icon(Icons.close),
                            ),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.65),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: PhilotesColors.gold.withValues(alpha: 0.65),
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
                            .where((interest) => interest.category == category)
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
                        color: PhilotesColors.gold.withValues(alpha: 0.65),
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
                                key: const Key('customInterestField'),
                                controller: _customInterestController,
                                textInputAction: TextInputAction.done,
                                onSubmitted: (_) {
                                  _addCustomInterest();
                                },
                                decoration: InputDecoration(
                                  hintText: 'Add your interest',
                                  filled: true,
                                  fillColor: PhilotesColors.ivory,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: PhilotesColors.gold.withValues(
                                        alpha: 0.65,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 10),

                            IconButton.filled(
                              key: const Key('addCustomInterestButton'),
                              tooltip: 'Add interest',
                              onPressed: _addCustomInterest,
                              style: IconButton.styleFrom(
                                backgroundColor: PhilotesColors.navy,
                                foregroundColor: Colors.white,
                              ),
                              icon: const Icon(Icons.add),
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
                        mainAxisAlignment: MainAxisAlignment.center,
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
                  border: Border.all(color: PhilotesColors.gold, width: 1.5),
                ),
                child: Icon(_categoryIcon, color: Colors.white, size: 20),
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
                  selected: selectedIds.contains(interest.id),
                  favorite: favoriteIds.contains(interest.id),
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
                  color: selected ? Colors.white : PhilotesColors.navy,
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
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
                    favorite ? Icons.star : Icons.star_border,
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
