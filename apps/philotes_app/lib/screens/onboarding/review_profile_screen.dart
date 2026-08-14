import 'package:flutter/material.dart';

import '../../models/onboarding_profile_data.dart';
import 'welcome_to_philotes_screen.dart';
import '../../theme/philotes_colors.dart';

class ReviewProfileScreen extends StatelessWidget {
  const ReviewProfileScreen({super.key});

  void _showEditMessage(BuildContext context, String section) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$section editing will return to its onboarding section.',
        ),
      ),
    );
  }

  void _completeProfile(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (context) => const WelcomeToPhilotesScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = OnboardingProfileData.instance;

    final displayName = profile.displayName.trim().isEmpty
        ? 'Your Display Name'
        : profile.displayName.trim();

    final introduction = profile.introduction.trim().isEmpty
        ? 'No introduction added yet.'
        : profile.introduction.trim();

    final otherInterests = profile.selectedInterests
        .where((interest) => !profile.favoriteInterests.contains(interest))
        .toList();

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
              constraints: const BoxConstraints(maxWidth: 700),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Review Your Profile',
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
                      width: 150,
                      height: 2,
                      decoration: BoxDecoration(
                        color: PhilotesColors.gold,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Take a look at how you will appear '
                    'to the Philotes community.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: PhilotesColors.silver,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 28),

                  //
                  // PROFILE PHOTO
                  //
                  Center(
                    child: Container(
                      key: const Key('reviewProfilePhoto'),
                      width: 210,
                      height: 210,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: PhilotesColors.navy,
                        border: Border.all(
                          color: PhilotesColors.gold,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: PhilotesColors.navy.withValues(alpha: 0.12),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 110,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    displayName,
                    key: const Key('reviewDisplayName'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: PhilotesColors.navy,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: PhilotesColors.gold,
                        size: 18,
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          profile.generalAreaLabel,
                          key: const Key('reviewGeneralArea'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: PhilotesColors.silver,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Center(
                    child: TextButton.icon(
                      key: const Key('editPhotoButton'),
                      onPressed: () {
                        _showEditMessage(context, 'Profile photo');
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: PhilotesColors.navy,
                      ),
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: const Text('Edit Photo'),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const _SectionHeading(
                    title: 'WHAT OTHER MEMBERS WILL SEE',
                    icon: Icons.visibility_outlined,
                  ),

                  const SizedBox(height: 12),

                  //
                  // ABOUT ME
                  //
                  _ReviewCard(
                    title: 'About Me',
                    editKey: 'editIntroductionButton',
                    onEdit: () {
                      _showEditMessage(context, 'About Me');
                    },
                    child: Text(
                      introduction,
                      key: const Key('reviewIntroduction'),
                      style: const TextStyle(
                        color: PhilotesColors.navy,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  //
                  // FAVORITES
                  //
                  _ReviewCard(
                    title: 'My Favorites',
                    editKey: 'editInterestsButton',
                    onEdit: () {
                      _showEditMessage(context, 'Interests');
                    },
                    child: profile.favoriteInterests.isEmpty
                        ? const Text(
                            'No favorite interests selected.',
                            style: TextStyle(
                              color: PhilotesColors.silver,
                              fontSize: 13,
                            ),
                          )
                        : Wrap(
                            key: const Key('favoriteInterestsList'),
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (final interest in profile.favoriteInterests)
                                Chip(
                                  label: Text(interest),
                                  backgroundColor: PhilotesColors.navy,
                                  side: const BorderSide(
                                    color: PhilotesColors.gold,
                                  ),
                                  avatar: const Icon(
                                    Icons.star,
                                    color: PhilotesColors.gold,
                                    size: 17,
                                  ),
                                  labelStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                            ],
                          ),
                  ),

                  //
                  // ALL REMAINING INTERESTS
                  //
                  if (otherInterests.isNotEmpty) ...[
                    const SizedBox(height: 14),

                    _ReviewCard(
                      title: 'More of My Interests',
                      editKey: 'editMoreInterestsButton',
                      onEdit: () {
                        _showEditMessage(context, 'Interests');
                      },
                      child: Wrap(
                        key: const Key('otherInterestsList'),
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final interest in otherInterests)
                            Chip(
                              label: Text(interest),
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.80,
                              ),
                              side: BorderSide(
                                color: PhilotesColors.gold.withValues(
                                  alpha: 0.75,
                                ),
                              ),
                              avatar: const Icon(
                                Icons.interests_outlined,
                                color: PhilotesColors.gold,
                                size: 16,
                              ),
                              labelStyle: const TextStyle(
                                color: PhilotesColors.navy,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],

                  //
                  // OPTIONAL PUBLIC PROFILE DETAILS
                  //
                  if (profile.pronouns != null &&
                      profile.pronouns!.trim().isNotEmpty) ...[
                    const SizedBox(height: 14),

                    _ReviewCard(
                      title: 'Profile Details',
                      editKey: 'editProfileDetailsButton',
                      onEdit: () {
                        _showEditMessage(context, 'Profile details');
                      },
                      child: Row(
                        children: [
                          const Text(
                            'Pronouns: ',
                            style: TextStyle(
                              color: PhilotesColors.silver,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            profile.pronouns!,
                            style: const TextStyle(
                              color: PhilotesColors.navy,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 26),

                  //
                  // FRIENDSHIP PREFERENCES
                  //
                  const _SectionHeading(
                    title: 'YOUR FRIENDSHIP PREFERENCES',
                    icon: Icons.tune_outlined,
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'These settings help Philotes find people '
                    'who may be a good fit for you. They are '
                    'not automatically shown on your public profile.',
                    style: TextStyle(
                      color: PhilotesColors.silver,
                      fontSize: 12,
                      height: 1.45,
                    ),
                  ),

                  const SizedBox(height: 12),

                  _ReviewCard(
                    title: 'Discovery Preferences',
                    editKey: 'editPreferencesButton',
                    onEdit: () {
                      _showEditMessage(context, 'Friendship preferences');
                    },
                    child: Column(
                      children: [
                        _PreferenceRow(
                          label: 'Preferred friend age range',
                          value: profile.friendAgeRangeLabel,
                        ),

                        const Divider(height: 22),

                        _PreferenceRow(
                          label: 'Meeting distance',
                          value: profile.meetingDistanceLabel,
                        ),

                        const Divider(height: 22),

                        _PreferenceRow(
                          label: 'Online friendships',
                          value: profile.onlineFriendships ? 'Yes' : 'No',
                        ),

                        if (profile.friendshipStyles.isNotEmpty) ...[
                          const Divider(height: 22),

                          _PreferenceRow(
                            label: 'Friendship styles',
                            value: profile.friendshipStyles.join(', '),
                          ),
                        ],

                        if (profile.socialFrequency != null) ...[
                          const Divider(height: 22),

                          _PreferenceRow(
                            label: 'Social pace',
                            value: profile.socialFrequency!,
                          ),
                        ],

                        if (profile.planningStyle != null) ...[
                          const Divider(height: 22),

                          _PreferenceRow(
                            label: 'Planning style',
                            value: profile.planningStyle!,
                          ),
                        ],

                        if (profile.interestStyle != null) ...[
                          const Divider(height: 22),

                          _PreferenceRow(
                            label: 'Shared interests',
                            value: profile.interestStyle!,
                          ),
                        ],

                        if (profile.newActivityComfort != null) ...[
                          const Divider(height: 22),

                          _PreferenceRow(
                            label: 'Trying new activities',
                            value: profile.newActivityComfort!,
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 26),

                  //
                  // PRIVACY
                  //
                  const _SectionHeading(
                    title: 'YOUR PRIVACY',
                    icon: Icons.shield_outlined,
                  ),

                  const SizedBox(height: 12),

                  Container(
                    key: const Key('reviewPrivacyCard'),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: PhilotesColors.gold.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: PhilotesColors.gold.withValues(alpha: 0.70),
                      ),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Other members will not see:',
                          style: TextStyle(
                            color: PhilotesColors.navy,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        SizedBox(height: 14),

                        _PrivacyRow(text: 'Your email address'),
                        _PrivacyRow(text: 'Your full last name'),
                        _PrivacyRow(text: 'Your exact date of birth'),
                        _PrivacyRow(text: 'Your ZIP code or exact location'),
                        _PrivacyRow(
                          text: 'Your password or account credentials',
                        ),
                        _PrivacyRow(
                          text:
                              'Internal verification, safety, '
                              'and standards records',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'Everything look right?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: PhilotesColors.navy,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'You can change your profile later '
                    'from your Philotes settings.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: PhilotesColors.silver,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    height: 58,
                    child: FilledButton.icon(
                      key: const Key('completeProfileButton'),
                      onPressed: () {
                        _completeProfile(context);
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: PhilotesColors.navy,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text(
                        'Complete My Profile',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
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

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: PhilotesColors.gold, size: 22),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: PhilotesColors.navy,
              fontSize: 14,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
            ),
          ),
        ),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({
    required this.title,
    required this.editKey,
    required this.onEdit,
    required this.child,
  });

  final String title;
  final String editKey;
  final VoidCallback onEdit;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PhilotesColors.gold.withValues(alpha: 0.55)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: PhilotesColors.navy,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton.icon(
                key: Key(editKey),
                onPressed: onEdit,
                style: TextButton.styleFrom(
                  foregroundColor: PhilotesColors.navy,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text('Edit'),
              ),
            ],
          ),

          const SizedBox(height: 10),

          child,
        ],
      ),
    );
  }
}

class _PreferenceRow extends StatelessWidget {
  const _PreferenceRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: const TextStyle(color: PhilotesColors.silver, fontSize: 12),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          flex: 5,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: PhilotesColors.navy,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _PrivacyRow extends StatelessWidget {
  const _PrivacyRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lock_outline, color: PhilotesColors.gold, size: 17),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: PhilotesColors.navy,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
