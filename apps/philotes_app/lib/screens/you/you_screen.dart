import 'package:flutter/material.dart';

import '../../data/philotes_activity_catalog.dart';
import '../../models/onboarding_profile_data.dart';
import '../../theme/philotes_colors.dart';
import '../../theme/philotes_design.dart';
import '../../widgets/interests/philotes_interest_widgets.dart';

class YouScreen extends StatelessWidget {
  const YouScreen({super.key});

  OnboardingProfileData get _profile => OnboardingProfileData.instance;

  String get _displayName {
    final value = _profile.displayName.trim();

    if (value.isNotEmpty) {
      return value;
    }

    final first = _profile.firstName.trim();

    if (first.isNotEmpty) {
      return first;
    }

    return 'Philotes Member';
  }

  String get _initial {
    final value = _displayName;

    if (value.isEmpty) {
      return 'P';
    }

    return value.substring(0, 1).toUpperCase();
  }

  void _open(BuildContext context, Widget screen) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (context) => screen));
  }

  void _showBackendNotice(BuildContext context, String title) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: const Text(
            'This control is part of the '
            'approved Philotes design. '
            'Its production action will be '
            'connected when the authenticated '
            'backend is built.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final wide = constraints.maxWidth >= PhilotesDesign.wideBreakpoint;

        return SingleChildScrollView(
          key: const Key('youScreen'),
          padding: EdgeInsets.fromLTRB(
            wide ? PhilotesDesign.widePadding : PhilotesDesign.mobilePadding,
            24,
            wide ? PhilotesDesign.widePadding : PhilotesDesign.mobilePadding,
            48,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: PhilotesDesign.contentMaxWidth,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'You',
                    style: TextStyle(
                      color: PhilotesColors.navy,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Your profile, preferences, '
                    'privacy, security, and account.',
                    style: TextStyle(
                      color: PhilotesColors.silver,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 24),

                  _ProfileHeroCard(
                    displayName: _displayName,
                    initial: _initial,
                    area: _profile.generalAreaLabel,
                    onViewProfile: () {
                      _open(context, const MyProfilePreviewScreen());
                    },
                    onEditProfile: () {
                      _open(context, const EditProfileHubScreen());
                    },
                  ),

                  const SizedBox(height: 28),

                  _SettingsSection(
                    title: 'Profile & Discovery',
                    children: [
                      _SettingsTile(
                        key: const Key('youInterestsTile'),
                        icon: Icons.interests_outlined,
                        title: 'Interests',
                        subtitle:
                            'Manage interests, '
                            'favorites, and activities.',
                        onTap: () {
                          _open(context, const ProfileInterestsScreen());
                        },
                      ),
                      _SettingsTile(
                        key: const Key('youFriendshipPreferencesTile'),
                        icon: Icons.people_outline,
                        title: 'Friendship Preferences',
                        subtitle:
                            'Social pace, friendship '
                            'style, planning, and '
                            'new activities.',
                        onTap: () {
                          _open(
                            context,
                            const FriendshipPreferencesSummaryScreen(),
                          );
                        },
                      ),
                      _SettingsTile(
                        key: const Key('youDiscoveryPreferencesTile'),
                        icon: Icons.tune_outlined,
                        title: 'Discovery Preferences',
                        subtitle:
                            'Permanent discovery '
                            'defaults for your account.',
                        onTap: () {
                          _open(
                            context,
                            const DiscoveryPreferencesSummaryScreen(),
                          );
                        },
                      ),
                      _SettingsTile(
                        key: const Key('youLocationDistanceTile'),
                        icon: Icons.location_on_outlined,
                        title: 'Location & Distance',
                        subtitle:
                            'Your normal discovery '
                            'area and travel preference.',
                        onTap: () {
                          _open(context, const LocationDistanceSummaryScreen());
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  _SettingsSection(
                    title: 'Privacy & Safety',
                    children: [
                      _SettingsTile(
                        key: const Key('youPrivacySettingsTile'),
                        icon: Icons.shield_outlined,
                        title: 'Privacy Settings',
                        subtitle:
                            'Control discovery and '
                            'profile visibility.',
                        onTap: () {
                          _open(context, const PrivacySettingsScreen());
                        },
                      ),
                      _SettingsTile(
                        key: const Key('youBlockedMembersTile'),
                        icon: Icons.block_outlined,
                        title: 'Blocked Members',
                        subtitle:
                            'Review and manage '
                            'blocked accounts.',
                        onTap: () {
                          _open(
                            context,
                            const InformationScreen(
                              title: 'Blocked Members',
                              description:
                                  'Blocked-member '
                                  'management will be '
                                  'connected to the '
                                  'Philotes safety '
                                  'backend.',
                              items: [
                                'View blocked members',
                                'Unblock a member',
                                'Blocking help',
                              ],
                            ),
                          );
                        },
                      ),
                      _SettingsTile(
                        key: const Key('youSafetyReportingTile'),
                        icon: Icons.health_and_safety_outlined,
                        title: 'Safety & Reporting',
                        subtitle:
                            'Safety guidance, '
                            'reporting, and member '
                            'protections.',
                        onTap: () {
                          _open(context, const SafetyReportingScreen());
                        },
                      ),
                      _SettingsTile(
                        key: const Key('youCommunityGuidelinesTile'),
                        icon: Icons.groups_outlined,
                        title: 'Community Guidelines',
                        subtitle:
                            'Expected conduct for '
                            'the Philotes community.',
                        onTap: () {
                          _open(context, const CommunityGuidelinesScreen());
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  _SettingsSection(
                    title: 'Account & Security',
                    children: [
                      _SettingsTile(
                        key: const Key('youAccountInformationTile'),
                        icon: Icons.badge_outlined,
                        title: 'Account Information',
                        subtitle:
                            'Your Philotes account '
                            'identity and status.',
                        onTap: () {
                          _open(context, const AccountInformationScreen());
                        },
                      ),
                      _SettingsTile(
                        key: const Key('youEmailSignInTile'),
                        icon: Icons.alternate_email,
                        title: 'Email & Sign-In',
                        subtitle:
                            'Verified email, password, '
                            'and account recovery.',
                        onTap: () {
                          _open(context, const EmailSignInScreen());
                        },
                      ),
                      _SettingsTile(
                        key: const Key('youMfaTile'),
                        icon: Icons.phonelink_lock_outlined,
                        title: 'Multi-Factor Authentication',
                        subtitle:
                            'Optional additional '
                            'sign-in protection.',
                        trailingText: 'Off',
                        onTap: () {
                          _open(context, const MfaSettingsScreen());
                        },
                      ),
                      _SettingsTile(
                        key: const Key('youSessionsTile'),
                        icon: Icons.devices_outlined,
                        title: 'Active Sessions & Devices',
                        subtitle:
                            'Review where your '
                            'account is signed in.',
                        onTap: () {
                          _open(context, const SessionsDevicesScreen());
                        },
                      ),
                      _SettingsTile(
                        key: const Key('youNotificationsTile'),
                        icon: Icons.notifications_outlined,
                        title: 'Notifications',
                        subtitle:
                            'Choose in-app and email '
                            'notification preferences.',
                        onTap: () {
                          _open(context, const NotificationsSettingsScreen());
                        },
                      ),
                      _SettingsTile(
                        key: const Key('youMembershipTile'),
                        icon: Icons.workspace_premium_outlined,
                        title: 'Subscription / Membership',
                        subtitle:
                            'Membership status and '
                            'billing settings.',
                        onTap: () {
                          _open(context, const MembershipScreen());
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  _SettingsSection(
                    title: 'Application',
                    children: [
                      _SettingsTile(
                        key: const Key('youAppearanceTile'),
                        icon: Icons.palette_outlined,
                        title: 'Appearance',
                        subtitle:
                            'Visual preferences '
                            'for Philotes.',
                        onTap: () {
                          _open(
                            context,
                            const InformationScreen(
                              title: 'Appearance',
                              description:
                                  'Application display '
                                  'preferences will live '
                                  'here.',
                              items: [
                                'Theme',
                                'Display preferences',
                                'Text presentation',
                              ],
                            ),
                          );
                        },
                      ),
                      _SettingsTile(
                        key: const Key('youAccessibilityTile'),
                        icon: Icons.accessibility_new_outlined,
                        title: 'Accessibility',
                        subtitle:
                            'Accessibility and '
                            'usability preferences.',
                        onTap: () {
                          _open(context, const AccessibilitySettingsScreen());
                        },
                      ),
                      _SettingsTile(
                        key: const Key('youHelpSupportTile'),
                        icon: Icons.help_outline,
                        title: 'Help & Support',
                        subtitle:
                            'Help using Philotes '
                            'and technical support.',
                        onTap: () {
                          _open(context, const HelpSupportScreen());
                        },
                      ),
                      _SettingsTile(
                        key: const Key('youAboutTile'),
                        icon: Icons.info_outline,
                        title: 'About Philotes',
                        subtitle:
                            'Application and '
                            'version information.',
                        onTap: () {
                          _open(context, const AboutPhilotesScreen());
                        },
                      ),
                      _SettingsTile(
                        key: const Key('youLegalPrivacyTile'),
                        icon: Icons.gavel_outlined,
                        title: 'Legal & Privacy',
                        subtitle:
                            'Terms, privacy, and '
                            'important policies.',
                        onTap: () {
                          _open(context, const LegalPrivacyScreen());
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  _SettingsSection(
                    title: 'Account Actions',
                    children: [
                      _SettingsTile(
                        key: const Key('youSignOutTile'),
                        icon: Icons.logout_outlined,
                        title: 'Sign Out',
                        subtitle: 'Sign out of this device.',
                        onTap: () {
                          _showBackendNotice(context, 'Sign Out');
                        },
                      ),
                      _SettingsTile(
                        key: const Key('youDeactivateAccountTile'),
                        icon: Icons.pause_circle_outline,
                        title: 'Deactivate Account',
                        subtitle:
                            'Temporarily make your '
                            'account inactive.',
                        onTap: () {
                          _showBackendNotice(context, 'Deactivate Account');
                        },
                      ),
                      _SettingsTile(
                        key: const Key('youDeleteAccountTile'),
                        icon: Icons.delete_outline,
                        title: 'Delete Account',
                        subtitle:
                            'Permanently request '
                            'account deletion.',
                        destructive: true,
                        onTap: () {
                          _showBackendNotice(context, 'Delete Account');
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  const Center(
                    child: Text(
                      'Philotes development build',
                      style: TextStyle(
                        color: PhilotesColors.silver,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProfileHeroCard extends StatelessWidget {
  const _ProfileHeroCard({
    required this.displayName,
    required this.initial,
    required this.area,
    required this.onViewProfile,
    required this.onEditProfile,
  });

  final String displayName;
  final String initial;
  final String area;
  final VoidCallback onViewProfile;
  final VoidCallback onEditProfile;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('youProfileHeroCard'),
      padding: const EdgeInsets.all(22),
      decoration: PhilotesDesign.primaryCardDecoration(),
      child: Column(
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: PhilotesColors.navy,
              border: Border.all(color: PhilotesColors.gold, width: 2.4),
            ),
            alignment: Alignment.center,
            child: Text(
              initial,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          const SizedBox(height: 14),

          Text(
            displayName,
            key: const Key('youDisplayName'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: PhilotesColors.navy,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            area,
            textAlign: TextAlign.center,
            style: const TextStyle(color: PhilotesColors.silver, fontSize: 12),
          ),

          const SizedBox(height: 18),

          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final stacked = constraints.maxWidth < 430;

              final view = OutlinedButton.icon(
                key: const Key('viewMyProfileButton'),
                onPressed: onViewProfile,
                icon: const Icon(Icons.visibility_outlined),
                label: const Text('View My Profile'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: PhilotesColors.navy,
                  side: const BorderSide(
                    color: PhilotesColors.gold,
                    width: 1.4,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              );

              final edit = FilledButton.icon(
                key: const Key('editMyProfileButton'),
                onPressed: onEditProfile,
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit My Profile'),
                style: FilledButton.styleFrom(
                  backgroundColor: PhilotesColors.navy,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              );

              if (stacked) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [view, const SizedBox(height: 10), edit],
                );
              }

              return Row(
                children: [
                  Expanded(child: view),
                  const SizedBox(width: 12),
                  Expanded(child: edit),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 22,
              decoration: BoxDecoration(
                color: PhilotesColors.gold,
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            const SizedBox(width: 9),

            Expanded(child: Text(title, style: PhilotesDesign.sectionHeading)),
          ],
        ),

        const SizedBox(height: 10),

        Container(
          decoration: PhilotesDesign.primaryCardDecoration(),
          child: Column(
            children: [
              for (var index = 0; index < children.length; index++) ...[
                children[index],
                if (index < children.length - 1) const Divider(height: 1),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailingText,
    this.destructive = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final String? trailingText;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final foreground = destructive ? Colors.red.shade700 : PhilotesColors.navy;

    return Material(
      color: Colors.transparent,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: PhilotesColors.navy.withValues(alpha: 0.06),
            border: Border.all(color: PhilotesColors.gold, width: 1),
          ),
          alignment: Alignment.center,
          child: Icon(icon, color: foreground, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: foreground,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(
            subtitle,
            style: const TextStyle(
              color: PhilotesColors.silver,
              fontSize: 11,
              height: 1.3,
            ),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trailingText != null) ...[
              Text(
                trailingText!,
                style: const TextStyle(
                  color: PhilotesColors.silver,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 5),
            ],
            const Icon(
              Icons.chevron_right,
              color: PhilotesColors.gold,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class MyProfilePreviewScreen extends StatelessWidget {
  const MyProfilePreviewScreen({super.key});

  OnboardingProfileData get _profile => OnboardingProfileData.instance;

  String get _name {
    final value = _profile.displayName.trim();

    return value.isEmpty ? 'Philotes Member' : value;
  }

  @override
  Widget build(BuildContext context) {
    return _YouSubpageScaffold(
      key: const Key('myProfilePreviewScreen'),
      title: 'My Profile',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'This preview shows the profile '
            'information Philotes can use when '
            'presenting you to other members.',
            style: PhilotesDesign.supportingText,
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(22),
            decoration: PhilotesDesign.primaryCardDecoration(),
            child: Column(
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: PhilotesColors.navy,
                    border: Border.all(color: PhilotesColors.gold, width: 2.4),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _name.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                Text(
                  _name,
                  style: const TextStyle(
                    color: PhilotesColors.navy,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  _profile.generalAreaLabel,
                  style: const TextStyle(
                    color: PhilotesColors.silver,
                    fontSize: 12,
                  ),
                ),

                if (_profile.introduction.trim().isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Text(
                    _profile.introduction,
                    textAlign: TextAlign.center,
                    style: PhilotesDesign.supportingText,
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 20),

          _ProfileValuesCard(
            title: 'Favorites / Like the Most',
            values: _profile.favoriteInterests,
            emptyText: 'No favorites selected.',
          ),

          const SizedBox(height: 16),

          _ProfileValuesCard(
            title: 'Interests',
            values: _profile.selectedInterests,
            emptyText: 'No interests selected.',
          ),

          const SizedBox(height: 16),

          _ProfileValuesCard(
            title: 'Friendship Styles',
            values: _profile.friendshipStyles,
            emptyText: 'No friendship styles selected.',
          ),

          const SizedBox(height: 16),

          _ProfileDetailCard(
            title: 'Friendship Preferences',
            rows: [
              _ProfileDetail(
                label: 'Social Frequency',
                value: _profile.socialFrequency ?? 'Not selected',
              ),
              _ProfileDetail(
                label: 'Planning Style',
                value: _profile.planningStyle ?? 'Not selected',
              ),
              _ProfileDetail(
                label: 'Interest Style',
                value: _profile.interestStyle ?? 'Not selected',
              ),
              _ProfileDetail(
                label: 'Trying New Activities',
                value: _profile.newActivityComfort ?? 'Not selected',
              ),
              _ProfileDetail(
                label: 'Friend Age Range',
                value: _profile.friendAgeRangeLabel,
              ),
            ],
          ),

          const SizedBox(height: 16),

          _ProfileDetailCard(
            title: 'Discovery',
            rows: [
              _ProfileDetail(
                label: 'General Area',
                value: _profile.generalAreaLabel,
              ),
              _ProfileDetail(
                label: 'Meeting Distance',
                value: _profile.meetingDistanceLabel,
              ),
              _ProfileDetail(
                label: 'Flexible Discovery',
                value: _profile.flexibleDiscovery ? 'On' : 'Off',
              ),
              _ProfileDetail(
                label: 'Online Friendships',
                value: _profile.onlineFriendships ? 'Allowed' : 'Not selected',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EditProfileHubScreen extends StatelessWidget {
  const EditProfileHubScreen({super.key});

  void _open(BuildContext context, Widget screen) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (context) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return _YouSubpageScaffold(
      key: const Key('editProfileHubScreen'),
      title: 'Edit My Profile',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Permanent profile changes belong '
            'here. Discover remains focused on '
            'temporary discovery refinement.',
            style: PhilotesDesign.supportingText,
          ),

          const SizedBox(height: 20),

          _SettingsSection(
            title: 'Profile Editing',
            children: [
              _SettingsTile(
                icon: Icons.person_outline,
                title: 'Personal Profile',
                subtitle:
                    'Name, introduction, photo, '
                    'and personal details.',
                onTap: () {
                  _open(
                    context,
                    const InformationScreen(
                      title: 'Personal Profile',
                      description:
                          'These fields already '
                          'exist in the Philotes '
                          'profile model and will '
                          'be made editable here.',
                      items: [
                        'First name',
                        'Last name',
                        'Display name',
                        'Introduction / bio',
                        'Profile photo',
                        'Pronouns',
                      ],
                    ),
                  );
                },
              ),
              _SettingsTile(
                icon: Icons.interests_outlined,
                title: 'Interests',
                subtitle:
                    'Interests and Like the '
                    'Most selections.',
                onTap: () {
                  _open(context, const ProfileInterestsScreen());
                },
              ),
              _SettingsTile(
                icon: Icons.people_outline,
                title: 'Friendship Preferences',
                subtitle:
                    'Social and friendship '
                    'compatibility preferences.',
                onTap: () {
                  _open(context, const FriendshipPreferencesSummaryScreen());
                },
              ),
              _SettingsTile(
                icon: Icons.person_search_outlined,
                title: 'Discovery Preferences',
                subtitle:
                    'Permanent discovery '
                    'defaults.',
                onTap: () {
                  _open(context, const DiscoveryPreferencesSummaryScreen());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProfileInterestsScreen extends StatefulWidget {
  const ProfileInterestsScreen({super.key});

  @override
  State<ProfileInterestsScreen> createState() => _ProfileInterestsScreenState();
}

class _ProfileInterestsScreenState extends State<ProfileInterestsScreen> {
  final TextEditingController _customInterestController =
      TextEditingController();

  OnboardingProfileData get _profile => OnboardingProfileData.instance;

  @override
  void dispose() {
    _customInterestController.dispose();
    super.dispose();
  }

  void _toggleInterest(String interest) {
    setState(() {
      if (_profile.selectedInterests.contains(interest)) {
        _profile.selectedInterests = _profile.selectedInterests
            .where((value) => value != interest)
            .toList();
        _profile.favoriteInterests = _profile.favoriteInterests
            .where((value) => value != interest)
            .toList();
      } else {
        _profile.selectedInterests = <String>[
          ..._profile.selectedInterests,
          interest,
        ];
      }
    });
  }

  void _addCustomInterest() {
    final interest = _customInterestController.text.trim();
    if (interest.isEmpty) return;

    final alreadySelected = _profile.selectedInterests.any(
      (value) => value.toLowerCase() == interest.toLowerCase(),
    );

    if (!alreadySelected) {
      setState(() {
        _profile.selectedInterests = <String>[
          ..._profile.selectedInterests,
          interest,
        ];
      });
    }

    _customInterestController.clear();
  }

  void _openAllActivities() {
    Navigator.of(context)
        .push(
          MaterialPageRoute<void>(
            builder: (context) => AllActivitiesScreen(
              selectedInterests: _profile.selectedInterests,
              onToggleInterest: _toggleInterest,
            ),
          ),
        )
        .then((_) {
          if (mounted) setState(() {});
        });
  }

  int _suggestionCount(double width) {
    if (width >= 900) return 16;
    if (width >= 600) return 12;
    return 8;
  }

  @override
  Widget build(BuildContext context) {
    return _YouSubpageScaffold(
      key: const Key('profileInterestsScreen'),
      title: 'Interests',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ProfileValuesCard(
            title: 'Favorites / Like the Most',
            values: _profile.favoriteInterests,
            emptyText: 'No favorite interests selected.',
          ),
          const SizedBox(height: 16),
          _ProfileValuesCard(
            title: 'Your Interests',
            values: _profile.selectedInterests,
            emptyText: 'No interests selected yet.',
          ),
          const SizedBox(height: 22),
          LayoutBuilder(
            builder: (context, constraints) {
              final visible = PhilotesActivityCatalog.starterActivities
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
                        key: Key('interestSuggestion-$interest'),
                        label: interest,
                        selected: _profile.selectedInterests.contains(interest),
                        onTap: () => _toggleInterest(interest),
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
              side: const BorderSide(color: PhilotesColors.gold, width: 1.5),
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
        ],
      ),
    );
  }
}

class AllActivitiesScreen extends StatefulWidget {
  const AllActivitiesScreen({
    super.key,
    required this.selectedInterests,
    required this.onToggleInterest,
  });

  final List<String> selectedInterests;
  final ValueChanged<String> onToggleInterest;

  @override
  State<AllActivitiesScreen> createState() => _AllActivitiesScreenState();
}

class _AllActivitiesScreenState extends State<AllActivitiesScreen> {
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

    return _YouSubpageScaffold(
      key: const Key('allActivitiesScreen'),
      title: 'All Activities',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PhilotesInterestCard(
            title: 'Find an Activity',
            icon: Icons.search,
            child: TextField(
              key: const Key('allActivitiesSearchField'),
              controller: _searchController,
              onChanged: (value) => setState(() => _query = value.trim()),
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
                'No listed activities match your search. Return to Interests to add anything you want.',
                style: TextStyle(color: PhilotesColors.silver, fontSize: 13),
              ),
            )
          else
            for (final category in categories) ...[
              PhilotesInterestCard(
                key: Key('activityCategory-${category.key}'),
                title: category.key,
                icon: _activityCategoryIcon(category.key),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final interest in category.value)
                      PhilotesInterestChip(
                        key: Key('allActivity-$interest'),
                        label: interest,
                        selected: widget.selectedInterests.contains(interest),
                        onTap: () {
                          widget.onToggleInterest(interest);
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
    );
  }
}

IconData _activityCategoryIcon(String category) {
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

class FriendshipPreferencesSummaryScreen extends StatelessWidget {
  const FriendshipPreferencesSummaryScreen({super.key});

  OnboardingProfileData get _profile => OnboardingProfileData.instance;

  @override
  Widget build(BuildContext context) {
    return _YouSubpageScaffold(
      title: 'Friendship Preferences',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ProfileValuesCard(
            title: 'Friendship Styles',
            values: _profile.friendshipStyles,
            emptyText: 'No friendship styles selected.',
          ),

          const SizedBox(height: 16),

          _ProfileDetailCard(
            title: 'Compatibility Preferences',
            rows: [
              _ProfileDetail(
                label: 'Social Frequency',
                value: _profile.socialFrequency ?? 'Not selected',
              ),
              _ProfileDetail(
                label: 'Planning Style',
                value: _profile.planningStyle ?? 'Not selected',
              ),
              _ProfileDetail(
                label: 'Interest Style',
                value: _profile.interestStyle ?? 'Not selected',
              ),
              _ProfileDetail(
                label: 'New Activities',
                value: _profile.newActivityComfort ?? 'Not selected',
              ),
              _ProfileDetail(
                label: 'Friend Age Range',
                value: _profile.friendAgeRangeLabel,
              ),
            ],
          ),

          const SizedBox(height: 18),

          const _DevelopmentNotice(
            text:
                'Editing these values will later '
                'update the member profile and '
                'trigger compatibility recalculation '
                'through the backend.',
          ),
        ],
      ),
    );
  }
}

class DiscoveryPreferencesSummaryScreen extends StatelessWidget {
  const DiscoveryPreferencesSummaryScreen({super.key});

  OnboardingProfileData get _profile => OnboardingProfileData.instance;

  @override
  Widget build(BuildContext context) {
    return _YouSubpageScaffold(
      title: 'Discovery Preferences',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ProfileDetailCard(
            title: 'Permanent Defaults',
            rows: [
              _ProfileDetail(
                label: 'Flexible Discovery',
                value: _profile.flexibleDiscovery ? 'On' : 'Off',
              ),
              _ProfileDetail(
                label: 'Friend Age Range',
                value: _profile.friendAgeRangeLabel,
              ),
              _ProfileDetail(
                label: 'Meeting Distance',
                value: _profile.meetingDistanceLabel,
              ),
              _ProfileDetail(
                label: 'Online Friendships',
                value: _profile.onlineFriendships ? 'Allowed' : 'Off',
              ),
            ],
          ),

          const SizedBox(height: 18),

          const _DevelopmentNotice(
            text:
                'Permanent settings belong here. '
                'The Discover page remains free '
                'to make temporary search '
                'refinements without changing '
                'the member profile.',
          ),
        ],
      ),
    );
  }
}

class LocationDistanceSummaryScreen extends StatelessWidget {
  const LocationDistanceSummaryScreen({super.key});

  OnboardingProfileData get _profile => OnboardingProfileData.instance;

  @override
  Widget build(BuildContext context) {
    return _YouSubpageScaffold(
      title: 'Location & Distance',
      child: _ProfileDetailCard(
        title: 'Discovery Area',
        rows: [
          _ProfileDetail(
            label: 'Location Source',
            value: _profile.locationSource == 'device'
                ? 'Current device area'
                : _profile.locationSource == 'zip'
                ? 'ZIP area'
                : 'Not selected',
          ),
          _ProfileDetail(
            label: 'General Area',
            value: _profile.generalAreaLabel,
          ),
          _ProfileDetail(
            label: 'Normal Distance',
            value: _profile.meetingDistanceLabel,
          ),
          _ProfileDetail(
            label: 'Flexible Discovery',
            value: _profile.flexibleDiscovery ? 'On' : 'Off',
          ),
        ],
      ),
    );
  }
}

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  bool _discoverable = true;
  bool _showApproximateDistance = true;
  bool _showOnlineStatus = false;

  @override
  Widget build(BuildContext context) {
    return _YouSubpageScaffold(
      key: const Key('privacySettingsScreen'),
      title: 'Privacy Settings',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ToggleCard(
            title: 'Profile Privacy',
            children: [
              _ToggleTile(
                title: 'Allow discovery',
                subtitle:
                    'Allow your profile to '
                    'appear to compatible members.',
                value: _discoverable,
                onChanged: (value) {
                  setState(() {
                    _discoverable = value;
                  });
                },
              ),
              _ToggleTile(
                title: 'Show approximate distance',
                subtitle:
                    'Display general distance '
                    'rather than precise location.',
                value: _showApproximateDistance,
                onChanged: (value) {
                  setState(() {
                    _showApproximateDistance = value;
                  });
                },
              ),
              _ToggleTile(
                title: 'Show online status',
                subtitle:
                    'Allow friends to see when '
                    'you are currently active.',
                value: _showOnlineStatus,
                onChanged: (value) {
                  setState(() {
                    _showOnlineStatus = value;
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 18),

          const _DevelopmentNotice(
            text:
                'Privacy controls are visual '
                'during frontend development. '
                'Production enforcement must '
                'occur in the backend.',
          ),
        ],
      ),
    );
  }
}

class SafetyReportingScreen extends StatelessWidget {
  const SafetyReportingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const InformationScreen(
      key: Key('safetyReportingScreen'),
      title: 'Safety & Reporting',
      description:
          'Philotes provides safety tools '
          'and guidance, but members remain '
          'responsible for their real-world '
          'decisions and personal safety.',
      items: [
        'How Philotes helps members stay safer',
        'Reporting a member',
        'Blocking a member',
        'Safe first-meeting guidance',
        'Scams & suspicious behavior',
        'Harassment & threatening behavior',
        'Emergency situations',
        'My submitted reports',
      ],
    );
  }
}

class CommunityGuidelinesScreen extends StatelessWidget {
  const CommunityGuidelinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const InformationScreen(
      key: Key('communityGuidelinesScreen'),
      title: 'Community Guidelines',
      description:
          'Philotes is a community for '
          'friendship. Members are expected '
          'to treat one another safely, '
          'honestly, and respectfully.',
      items: [
        'No harassment or threats',
        'No stalking or unwanted contact',
        'No sexual misconduct',
        'No impersonation or deception',
        'No scams or exploitation',
        'No hate-based abuse',
        'Do not bypass blocking or safety tools',
        'Serious violations may result in '
            'restrictions or account removal',
      ],
    );
  }
}

class AccountInformationScreen extends StatelessWidget {
  const AccountInformationScreen({super.key});

  OnboardingProfileData get _profile => OnboardingProfileData.instance;

  @override
  Widget build(BuildContext context) {
    return _YouSubpageScaffold(
      title: 'Account Information',
      child: _ProfileDetailCard(
        title: 'Member Information',
        rows: [
          _ProfileDetail(
            label: 'Display Name',
            value: _profile.displayName.trim().isEmpty
                ? 'Not selected'
                : _profile.displayName,
          ),
          _ProfileDetail(
            label: 'First Name',
            value: _profile.firstName.trim().isEmpty
                ? 'Not selected'
                : _profile.firstName,
          ),
          _ProfileDetail(label: 'Account Status', value: 'Development account'),
          _ProfileDetail(
            label: 'Profile Photo',
            value: _profile.photoSelected ? 'Selected' : 'Not selected',
          ),
        ],
      ),
    );
  }
}

class EmailSignInScreen extends StatelessWidget {
  const EmailSignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _YouSubpageScaffold(
      key: Key('emailSignInScreen'),
      title: 'Email & Sign-In',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ProfileDetailCard(
            title: 'Verified Email',
            rows: [
              _ProfileDetail(
                label: 'Account Email',
                value: 'Backend connection required',
              ),
              _ProfileDetail(
                label: 'Verification',
                value: 'Backend connection required',
              ),
            ],
          ),
          SizedBox(height: 16),
          _ProfileDetailCard(
            title: 'Sign-In & Recovery',
            rows: [
              _ProfileDetail(
                label: 'Change Password',
                value: 'Backend connection required',
              ),
              _ProfileDetail(
                label: 'Account Recovery',
                value: 'Backend connection required',
              ),
              _ProfileDetail(
                label: 'Change Email',
                value: 'Verification required',
              ),
            ],
          ),
          SizedBox(height: 18),
          _DevelopmentNotice(
            text:
                'Philotes signup will use a '
                'verified email address. The '
                'email will be used for account '
                'recovery, security notices, '
                'and optional email notifications.',
          ),
        ],
      ),
    );
  }
}

class MfaSettingsScreen extends StatelessWidget {
  const MfaSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _YouSubpageScaffold(
      key: const Key('mfaSettingsScreen'),
      title: 'Multi-Factor Authentication',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: PhilotesDesign.primaryCardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Status',
                        style: TextStyle(
                          color: PhilotesColors.navy,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: PhilotesColors.gold),
                      ),
                      child: const Text(
                        'Off',
                        style: TextStyle(
                          color: PhilotesColors.navy,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                Text(
                  'MFA is optional for regular '
                  'Philotes members. Members who '
                  'choose to enable it will use '
                  'a supported standards-based '
                  'authenticator.',
                  style: PhilotesDesign.supportingText,
                ),

                const SizedBox(height: 16),

                FilledButton.icon(
                  key: const Key('setupMfaButton'),
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Set Up MFA'),
                          content: const Text(
                            'MFA enrollment '
                            'will become active '
                            'when the Philotes '
                            'authentication '
                            'backend is built.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.phonelink_lock_outlined),
                  label: const Text('Set Up MFA'),
                  style: FilledButton.styleFrom(
                    backgroundColor: PhilotesColors.navy,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          const _DevelopmentNotice(
            text:
                'Recovery methods will be '
                'designed with the backend so '
                'members do not lose access '
                'because of an MFA device change.',
          ),
        ],
      ),
    );
  }
}

class SessionsDevicesScreen extends StatelessWidget {
  const SessionsDevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const InformationScreen(
      title: 'Active Sessions & Devices',
      description:
          'Authenticated session management '
          'will be connected to the backend.',
      items: [
        'Current device',
        'Other signed-in devices',
        'Sign out other sessions',
        'Recent security activity',
        'New sign-in history',
      ],
    );
  }
}

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends State<NotificationsSettingsScreen> {
  bool _inAppFriendshipInterest = true;
  bool _inAppConnection = true;
  bool _inAppDirectMessage = true;
  bool _inAppGroupMessage = true;
  bool _inAppPlanInvitation = true;
  bool _inAppPlanUpdate = true;
  bool _inAppPlanReminder = true;

  bool _emailEnabled = true;
  bool _emailFriendshipInterest = true;
  bool _emailConnection = true;
  bool _emailDirectMessage = true;
  bool _emailGroupMessage = false;
  bool _emailPlanInvitation = true;
  bool _emailPlanUpdate = true;
  bool _emailPlanReminder = true;
  bool _emailGeneralUpdates = false;
  bool _emailProductAnnouncements = false;
  bool _emailMessagePreview = false;

  String _emailFrequency = 'Immediately';

  @override
  Widget build(BuildContext context) {
    return _YouSubpageScaffold(
      key: const Key('notificationsSettingsScreen'),
      title: 'Notifications',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'In-app notifications are the '
            'primary notification channel. '
            'Email delivery can be adjusted '
            'for the events you want.',
            style: PhilotesDesign.supportingText,
          ),

          const SizedBox(height: 20),

          _ToggleCard(
            title: 'In-App Notifications',
            children: [
              _ToggleTile(
                title: 'New friendship interest',
                value: _inAppFriendshipInterest,
                onChanged: (value) {
                  setState(() {
                    _inAppFriendshipInterest = value;
                  });
                },
              ),
              _ToggleTile(
                title: 'New friendship connection',
                value: _inAppConnection,
                onChanged: (value) {
                  setState(() {
                    _inAppConnection = value;
                  });
                },
              ),
              _ToggleTile(
                title: 'New direct message',
                value: _inAppDirectMessage,
                onChanged: (value) {
                  setState(() {
                    _inAppDirectMessage = value;
                  });
                },
              ),
              _ToggleTile(
                title: 'New group message',
                value: _inAppGroupMessage,
                onChanged: (value) {
                  setState(() {
                    _inAppGroupMessage = value;
                  });
                },
              ),
              _ToggleTile(
                title: 'Plan invitation',
                value: _inAppPlanInvitation,
                onChanged: (value) {
                  setState(() {
                    _inAppPlanInvitation = value;
                  });
                },
              ),
              _ToggleTile(
                title: 'Plan update',
                value: _inAppPlanUpdate,
                onChanged: (value) {
                  setState(() {
                    _inAppPlanUpdate = value;
                  });
                },
              ),
              _ToggleTile(
                title: 'Plan reminder',
                value: _inAppPlanReminder,
                onChanged: (value) {
                  setState(() {
                    _inAppPlanReminder = value;
                  });
                },
              ),
              const _LockedToggleTile(
                title: 'Safety & account alerts',
                subtitle:
                    'Important security and '
                    'safety notices remain on.',
              ),
            ],
          ),

          const SizedBox(height: 22),

          _ToggleCard(
            title: 'Email Notifications',
            children: [
              _ToggleTile(
                key: const Key('emailNotificationsMasterToggle'),
                title: 'Email notifications',
                subtitle:
                    'Send selected Philotes '
                    'notifications to the '
                    'verified account email.',
                value: _emailEnabled,
                onChanged: (value) {
                  setState(() {
                    _emailEnabled = value;
                  });
                },
              ),

              if (_emailEnabled) ...[
                _ToggleTile(
                  title: 'New friendship interest',
                  value: _emailFriendshipInterest,
                  onChanged: (value) {
                    setState(() {
                      _emailFriendshipInterest = value;
                    });
                  },
                ),
                _ToggleTile(
                  title: 'New friendship connection',
                  value: _emailConnection,
                  onChanged: (value) {
                    setState(() {
                      _emailConnection = value;
                    });
                  },
                ),
                _ToggleTile(
                  title: 'New direct message',
                  value: _emailDirectMessage,
                  onChanged: (value) {
                    setState(() {
                      _emailDirectMessage = value;
                    });
                  },
                ),
                _ToggleTile(
                  title: 'New group message',
                  value: _emailGroupMessage,
                  onChanged: (value) {
                    setState(() {
                      _emailGroupMessage = value;
                    });
                  },
                ),
                _ToggleTile(
                  title: 'Plan invitation',
                  value: _emailPlanInvitation,
                  onChanged: (value) {
                    setState(() {
                      _emailPlanInvitation = value;
                    });
                  },
                ),
                _ToggleTile(
                  title: 'Plan update',
                  value: _emailPlanUpdate,
                  onChanged: (value) {
                    setState(() {
                      _emailPlanUpdate = value;
                    });
                  },
                ),
                _ToggleTile(
                  title: 'Plan reminder',
                  value: _emailPlanReminder,
                  onChanged: (value) {
                    setState(() {
                      _emailPlanReminder = value;
                    });
                  },
                ),
                _ToggleTile(
                  title: 'General Philotes updates',
                  value: _emailGeneralUpdates,
                  onChanged: (value) {
                    setState(() {
                      _emailGeneralUpdates = value;
                    });
                  },
                ),
                _ToggleTile(
                  title: 'Product announcements',
                  value: _emailProductAnnouncements,
                  onChanged: (value) {
                    setState(() {
                      _emailProductAnnouncements = value;
                    });
                  },
                ),
                _ToggleTile(
                  key: const Key('emailMessagePreviewToggle'),
                  title:
                      'Show message previews '
                      'in email',
                  subtitle: 'Off by default for privacy.',
                  value: _emailMessagePreview,
                  onChanged: (value) {
                    setState(() {
                      _emailMessagePreview = value;
                    });
                  },
                ),
                const _LockedToggleTile(
                  title: 'Security & account alerts',
                  subtitle:
                      'Critical account-security '
                      'emails remain enabled.',
                ),
              ],
            ],
          ),

          if (_emailEnabled) ...[
            const SizedBox(height: 22),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: PhilotesDesign.primaryCardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Email Frequency',
                    style: TextStyle(
                      color: PhilotesColors.navy,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Security and critical '
                    'account alerts are always '
                    'sent immediately.',
                    style: PhilotesDesign.supportingText,
                  ),

                  const SizedBox(height: 12),

                  DropdownButtonFormField<String>(
                    key: const Key('emailFrequencyDropdown'),
                    initialValue: _emailFrequency,
                    decoration: const InputDecoration(
                      labelText: 'Regular notification email',
                    ),
                    items: const [
                      DropdownMenuItem<String>(
                        value: 'Immediately',
                        child: Text('Immediately'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Daily summary',
                        child: Text('Daily summary'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Off',
                        child: Text('Off'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }

                      setState(() {
                        _emailFrequency = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 18),

          const _DevelopmentNotice(
            text:
                'These controls are visual '
                'during frontend development. '
                'The backend notification engine '
                'will persist and enforce member '
                'preferences and prevent repeated '
                'email flooding.',
          ),
        ],
      ),
    );
  }
}

class MembershipScreen extends StatelessWidget {
  const MembershipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const InformationScreen(
      title: 'Subscription / Membership',
      description:
          'Philotes membership and billing '
          'will be connected to production '
          'subscription services later.',
      items: [
        'Membership status',
        'Billing method',
        'Payment history',
        'Manage membership',
        'Cancellation settings',
      ],
    );
  }
}

class AccessibilitySettingsScreen extends StatelessWidget {
  const AccessibilitySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const InformationScreen(
      title: 'Accessibility',
      description:
          'Accessibility options will remain '
          'a first-class part of Philotes '
          'rather than an afterthought.',
      items: [
        'Text size',
        'Motion preferences',
        'Visual assistance',
        'Interaction assistance',
        'Screen-reader support',
      ],
    );
  }
}

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const InformationScreen(
      title: 'Help & Support',
      description:
          'Members will be able to get '
          'application and account help here.',
      items: [
        'Help center',
        'Contact support',
        'Report a technical issue',
        'Account help',
        'Safety help',
      ],
    );
  }
}

class AboutPhilotesScreen extends StatelessWidget {
  const AboutPhilotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const InformationScreen(
      title: 'About Philotes',
      description: 'PHILOTES — A Community for Friendship.',
      items: [
        'Brought to you by Titan',
        'Application information',
        'Version information',
        'Acknowledgements',
      ],
    );
  }
}

class LegalPrivacyScreen extends StatelessWidget {
  const LegalPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const InformationScreen(
      title: 'Legal & Privacy',
      description:
          'Production legal documents will '
          'be finalized and professionally '
          'reviewed before launch.',
      items: [
        'Terms of Service',
        'Privacy Policy',
        'Community Guidelines',
        'Safety information',
        'Account deletion information',
      ],
    );
  }
}

class _ToggleCard extends StatelessWidget {
  const _ToggleCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: PhilotesDesign.sectionHeading),

        const SizedBox(height: 10),

        Container(
          decoration: PhilotesDesign.primaryCardDecoration(),
          child: Column(
            children: [
              for (var index = 0; index < children.length; index++) ...[
                children[index],
                if (index < children.length - 1) const Divider(height: 1),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SwitchListTile(
        title: Text(
          title,
          style: const TextStyle(
            color: PhilotesColors.navy,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: subtitle == null
            ? null
            : Text(
                subtitle!,
                style: const TextStyle(
                  color: PhilotesColors.silver,
                  fontSize: 10,
                ),
              ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}

class _LockedToggleTile extends StatelessWidget {
  const _LockedToggleTile({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SwitchListTile(
        title: Text(
          title,
          style: const TextStyle(
            color: PhilotesColors.navy,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: PhilotesColors.silver, fontSize: 10),
        ),
        value: true,
        onChanged: null,
      ),
    );
  }
}

class _ProfileValuesCard extends StatelessWidget {
  const _ProfileValuesCard({
    required this.title,
    required this.values,
    required this.emptyText,
  });

  final String title;
  final List<String> values;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: PhilotesDesign.sectionHeading),

        const SizedBox(height: 10),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: PhilotesDesign.secondaryCardDecoration(),
          child: values.isEmpty
              ? Text(emptyText, style: PhilotesDesign.supportingText)
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final value in values)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: PhilotesColors.navy,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: PhilotesColors.gold,
                            width: 1.2,
                          ),
                        ),
                        child: Text(
                          value,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _ProfileDetail {
  const _ProfileDetail({required this.label, required this.value});

  final String label;
  final String value;
}

class _ProfileDetailCard extends StatelessWidget {
  const _ProfileDetailCard({required this.title, required this.rows});

  final String title;
  final List<_ProfileDetail> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: PhilotesDesign.sectionHeading),

        const SizedBox(height: 10),

        Container(
          decoration: PhilotesDesign.primaryCardDecoration(),
          child: Column(
            children: [
              for (var index = 0; index < rows.length; index++) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          rows[index].label,
                          style: const TextStyle(
                            color: PhilotesColors.navy,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Flexible(
                        child: Text(
                          rows[index].value,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: PhilotesColors.silver,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (index < rows.length - 1) const Divider(height: 1),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _DevelopmentNotice extends StatelessWidget {
  const _DevelopmentNotice({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: PhilotesDesign.secondaryCardDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.construction_outlined,
            color: PhilotesColors.gold,
            size: 20,
          ),

          const SizedBox(width: 10),

          Expanded(child: Text(text, style: PhilotesDesign.supportingText)),
        ],
      ),
    );
  }
}

class InformationScreen extends StatelessWidget {
  const InformationScreen({
    super.key,
    required this.title,
    required this.description,
    required this.items,
  });

  final String title;
  final String description;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return _YouSubpageScaffold(
      key: key,
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(description, style: PhilotesDesign.supportingText),

          const SizedBox(height: 18),

          Container(
            decoration: PhilotesDesign.primaryCardDecoration(),
            child: Column(
              children: [
                for (var index = 0; index < items.length; index++) ...[
                  ListTile(
                    leading: const Icon(
                      Icons.check_circle_outline,
                      color: PhilotesColors.gold,
                      size: 20,
                    ),
                    title: Text(
                      items[index],
                      style: const TextStyle(
                        color: PhilotesColors.navy,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (index < items.length - 1) const Divider(height: 1),
                ],
              ],
            ),
          ),

          const SizedBox(height: 18),

          const _DevelopmentNotice(
            text:
                'Production actions on this '
                'page will be persisted and '
                'enforced by the Philotes '
                'backend.',
          ),
        ],
      ),
    );
  }
}

class _YouSubpageScaffold extends StatelessWidget {
  const _YouSubpageScaffold({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PhilotesColors.ivory,
      appBar: AppBar(
        backgroundColor: PhilotesColors.ivory,
        foregroundColor: PhilotesColors.navy,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          title,
          style: const TextStyle(
            color: PhilotesColors.navy,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.2),
          child: Divider(
            height: 1.2,
            thickness: PhilotesDesign.secondaryBorderWidth,
            color: PhilotesColors.gold,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final wide = constraints.maxWidth >= PhilotesDesign.wideBreakpoint;

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              wide ? PhilotesDesign.widePadding : PhilotesDesign.mobilePadding,
              24,
              wide ? PhilotesDesign.widePadding : PhilotesDesign.mobilePadding,
              44,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: PhilotesDesign.contentMaxWidth,
                ),
                child: child,
              ),
            ),
          );
        },
      ),
    );
  }
}
