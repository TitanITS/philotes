from pathlib import Path
from datetime import datetime


SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = SCRIPT_DIR.parent.parent

APP_ROOT = (
    PROJECT_ROOT
    / "apps"
    / "philotes_app"
)

LIB_ROOT = APP_ROOT / "lib"
TEST_ROOT = APP_ROOT / "test"

SHELL_FILE = (
    LIB_ROOT
    / "screens"
    / "app"
    / "philotes_shell_screen.dart"
)

YOU_FILE = (
    LIB_ROOT
    / "screens"
    / "you"
    / "you_screen.dart"
)

YOU_TEST_FILE = (
    TEST_ROOT
    / "you_v1_test.dart"
)

WIDGET_TEST_FILE = (
    TEST_ROOT
    / "widget_test.dart"
)

REPORT_FILE = (
    SCRIPT_DIR
    / "developerpatchscript_report.txt"
)


YOU_CONTENT = r"""import 'package:flutter/material.dart';

import '../../models/onboarding_profile_data.dart';
import '../../theme/philotes_colors.dart';
import '../../theme/philotes_design.dart';


class YouScreen extends StatelessWidget {
  const YouScreen({
    super.key,
  });

  OnboardingProfileData get _profile =>
      OnboardingProfileData.instance;

  String get _displayName {
    final value =
        _profile.displayName.trim();

    if (value.isNotEmpty) {
      return value;
    }

    final first =
        _profile.firstName.trim();

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

    return value
        .substring(0, 1)
        .toUpperCase();
  }

  void _open(
    BuildContext context,
    Widget screen,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) =>
            screen,
      ),
    );
  }

  void _showBackendNotice(
    BuildContext context,
    String title,
  ) {
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
                Navigator.of(context)
                    .pop();
              },
              child:
                  const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (
        BuildContext context,
        BoxConstraints constraints,
      ) {
        final wide =
            constraints.maxWidth >=
            PhilotesDesign
                .wideBreakpoint;

        return SingleChildScrollView(
          key: const Key(
            'youScreen',
          ),
          padding:
              EdgeInsets.fromLTRB(
            wide
                ? PhilotesDesign
                    .widePadding
                : PhilotesDesign
                    .mobilePadding,
            24,
            wide
                ? PhilotesDesign
                    .widePadding
                : PhilotesDesign
                    .mobilePadding,
            48,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(
                maxWidth:
                    PhilotesDesign
                        .contentMaxWidth,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .stretch,
                children: [
                  const Text(
                    'You',
                    style: TextStyle(
                      color:
                          PhilotesColors
                              .navy,
                      fontSize: 30,
                      fontWeight:
                          FontWeight
                              .w800,
                    ),
                  ),

                  const SizedBox(
                    height: 6,
                  ),

                  const Text(
                    'Your profile, preferences, '
                    'privacy, security, and account.',
                    style: TextStyle(
                      color:
                          PhilotesColors
                              .silver,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  _ProfileHeroCard(
                    displayName:
                        _displayName,
                    initial:
                        _initial,
                    area:
                        _profile
                            .generalAreaLabel,
                    onViewProfile: () {
                      _open(
                        context,
                        const MyProfilePreviewScreen(),
                      );
                    },
                    onEditProfile: () {
                      _open(
                        context,
                        const EditProfileHubScreen(),
                      );
                    },
                  ),

                  const SizedBox(
                    height: 28,
                  ),

                  _SettingsSection(
                    title:
                        'Profile & Discovery',
                    children: [
                      _SettingsTile(
                        key: const Key(
                          'youInterestsTile',
                        ),
                        icon:
                            Icons
                                .interests_outlined,
                        title:
                            'Interests',
                        subtitle:
                            'Manage interests, '
                            'favorites, and activities.',
                        onTap: () {
                          _open(
                            context,
                            const ProfileInterestsScreen(),
                          );
                        },
                      ),
                      _SettingsTile(
                        key: const Key(
                          'youFriendshipPreferencesTile',
                        ),
                        icon:
                            Icons
                                .people_outline,
                        title:
                            'Friendship Preferences',
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
                        key: const Key(
                          'youDiscoveryPreferencesTile',
                        ),
                        icon:
                            Icons
                                .tune_outlined,
                        title:
                            'Discovery Preferences',
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
                        key: const Key(
                          'youLocationDistanceTile',
                        ),
                        icon:
                            Icons
                                .location_on_outlined,
                        title:
                            'Location & Distance',
                        subtitle:
                            'Your normal discovery '
                            'area and travel preference.',
                        onTap: () {
                          _open(
                            context,
                            const LocationDistanceSummaryScreen(),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  _SettingsSection(
                    title:
                        'Privacy & Safety',
                    children: [
                      _SettingsTile(
                        key: const Key(
                          'youPrivacySettingsTile',
                        ),
                        icon:
                            Icons
                                .shield_outlined,
                        title:
                            'Privacy Settings',
                        subtitle:
                            'Control discovery and '
                            'profile visibility.',
                        onTap: () {
                          _open(
                            context,
                            const PrivacySettingsScreen(),
                          );
                        },
                      ),
                      _SettingsTile(
                        key: const Key(
                          'youBlockedMembersTile',
                        ),
                        icon:
                            Icons
                                .block_outlined,
                        title:
                            'Blocked Members',
                        subtitle:
                            'Review and manage '
                            'blocked accounts.',
                        onTap: () {
                          _open(
                            context,
                            const InformationScreen(
                              title:
                                  'Blocked Members',
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
                        key: const Key(
                          'youSafetyReportingTile',
                        ),
                        icon:
                            Icons
                                .health_and_safety_outlined,
                        title:
                            'Safety & Reporting',
                        subtitle:
                            'Safety guidance, '
                            'reporting, and member '
                            'protections.',
                        onTap: () {
                          _open(
                            context,
                            const SafetyReportingScreen(),
                          );
                        },
                      ),
                      _SettingsTile(
                        key: const Key(
                          'youCommunityGuidelinesTile',
                        ),
                        icon:
                            Icons
                                .groups_outlined,
                        title:
                            'Community Guidelines',
                        subtitle:
                            'Expected conduct for '
                            'the Philotes community.',
                        onTap: () {
                          _open(
                            context,
                            const CommunityGuidelinesScreen(),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  _SettingsSection(
                    title:
                        'Account & Security',
                    children: [
                      _SettingsTile(
                        key: const Key(
                          'youAccountInformationTile',
                        ),
                        icon:
                            Icons
                                .badge_outlined,
                        title:
                            'Account Information',
                        subtitle:
                            'Your Philotes account '
                            'identity and status.',
                        onTap: () {
                          _open(
                            context,
                            const AccountInformationScreen(),
                          );
                        },
                      ),
                      _SettingsTile(
                        key: const Key(
                          'youEmailSignInTile',
                        ),
                        icon:
                            Icons
                                .alternate_email,
                        title:
                            'Email & Sign-In',
                        subtitle:
                            'Verified email, password, '
                            'and account recovery.',
                        onTap: () {
                          _open(
                            context,
                            const EmailSignInScreen(),
                          );
                        },
                      ),
                      _SettingsTile(
                        key: const Key(
                          'youMfaTile',
                        ),
                        icon:
                            Icons
                                .phonelink_lock_outlined,
                        title:
                            'Multi-Factor Authentication',
                        subtitle:
                            'Optional additional '
                            'sign-in protection.',
                        trailingText:
                            'Off',
                        onTap: () {
                          _open(
                            context,
                            const MfaSettingsScreen(),
                          );
                        },
                      ),
                      _SettingsTile(
                        key: const Key(
                          'youSessionsTile',
                        ),
                        icon:
                            Icons
                                .devices_outlined,
                        title:
                            'Active Sessions & Devices',
                        subtitle:
                            'Review where your '
                            'account is signed in.',
                        onTap: () {
                          _open(
                            context,
                            const SessionsDevicesScreen(),
                          );
                        },
                      ),
                      _SettingsTile(
                        key: const Key(
                          'youNotificationsTile',
                        ),
                        icon:
                            Icons
                                .notifications_outlined,
                        title:
                            'Notifications',
                        subtitle:
                            'Choose in-app and email '
                            'notification preferences.',
                        onTap: () {
                          _open(
                            context,
                            const NotificationsSettingsScreen(),
                          );
                        },
                      ),
                      _SettingsTile(
                        key: const Key(
                          'youMembershipTile',
                        ),
                        icon:
                            Icons
                                .workspace_premium_outlined,
                        title:
                            'Subscription / Membership',
                        subtitle:
                            'Membership status and '
                            'billing settings.',
                        onTap: () {
                          _open(
                            context,
                            const MembershipScreen(),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  _SettingsSection(
                    title: 'Application',
                    children: [
                      _SettingsTile(
                        key: const Key(
                          'youAppearanceTile',
                        ),
                        icon:
                            Icons
                                .palette_outlined,
                        title:
                            'Appearance',
                        subtitle:
                            'Visual preferences '
                            'for Philotes.',
                        onTap: () {
                          _open(
                            context,
                            const InformationScreen(
                              title:
                                  'Appearance',
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
                        key: const Key(
                          'youAccessibilityTile',
                        ),
                        icon:
                            Icons
                                .accessibility_new_outlined,
                        title:
                            'Accessibility',
                        subtitle:
                            'Accessibility and '
                            'usability preferences.',
                        onTap: () {
                          _open(
                            context,
                            const AccessibilitySettingsScreen(),
                          );
                        },
                      ),
                      _SettingsTile(
                        key: const Key(
                          'youHelpSupportTile',
                        ),
                        icon:
                            Icons
                                .help_outline,
                        title:
                            'Help & Support',
                        subtitle:
                            'Help using Philotes '
                            'and technical support.',
                        onTap: () {
                          _open(
                            context,
                            const HelpSupportScreen(),
                          );
                        },
                      ),
                      _SettingsTile(
                        key: const Key(
                          'youAboutTile',
                        ),
                        icon:
                            Icons
                                .info_outline,
                        title:
                            'About Philotes',
                        subtitle:
                            'Application and '
                            'version information.',
                        onTap: () {
                          _open(
                            context,
                            const AboutPhilotesScreen(),
                          );
                        },
                      ),
                      _SettingsTile(
                        key: const Key(
                          'youLegalPrivacyTile',
                        ),
                        icon:
                            Icons
                                .gavel_outlined,
                        title:
                            'Legal & Privacy',
                        subtitle:
                            'Terms, privacy, and '
                            'important policies.',
                        onTap: () {
                          _open(
                            context,
                            const LegalPrivacyScreen(),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  _SettingsSection(
                    title:
                        'Account Actions',
                    children: [
                      _SettingsTile(
                        key: const Key(
                          'youSignOutTile',
                        ),
                        icon:
                            Icons
                                .logout_outlined,
                        title:
                            'Sign Out',
                        subtitle:
                            'Sign out of this device.',
                        onTap: () {
                          _showBackendNotice(
                            context,
                            'Sign Out',
                          );
                        },
                      ),
                      _SettingsTile(
                        key: const Key(
                          'youDeactivateAccountTile',
                        ),
                        icon:
                            Icons
                                .pause_circle_outline,
                        title:
                            'Deactivate Account',
                        subtitle:
                            'Temporarily make your '
                            'account inactive.',
                        onTap: () {
                          _showBackendNotice(
                            context,
                            'Deactivate Account',
                          );
                        },
                      ),
                      _SettingsTile(
                        key: const Key(
                          'youDeleteAccountTile',
                        ),
                        icon:
                            Icons
                                .delete_outline,
                        title:
                            'Delete Account',
                        subtitle:
                            'Permanently request '
                            'account deletion.',
                        destructive:
                            true,
                        onTap: () {
                          _showBackendNotice(
                            context,
                            'Delete Account',
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  const Center(
                    child: Text(
                      'Philotes development build',
                      style: TextStyle(
                        color:
                            PhilotesColors
                                .silver,
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


class _ProfileHeroCard
    extends StatelessWidget {
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
      key: const Key(
        'youProfileHeroCard',
      ),
      padding:
          const EdgeInsets.all(22),
      decoration:
          PhilotesDesign
              .primaryCardDecoration(),
      child: Column(
        children: [
          Container(
            width: 96,
            height: 96,
            decoration:
                BoxDecoration(
              shape: BoxShape.circle,
              color:
                  PhilotesColors.navy,
              border: Border.all(
                color:
                    PhilotesColors.gold,
                width: 2.4,
              ),
            ),
            alignment:
                Alignment.center,
            child: Text(
              initial,
              style:
                  const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight:
                    FontWeight.w800,
              ),
            ),
          ),

          const SizedBox(
            height: 14,
          ),

          Text(
            displayName,
            key: const Key(
              'youDisplayName',
            ),
            textAlign:
                TextAlign.center,
            style:
                const TextStyle(
              color:
                  PhilotesColors.navy,
              fontSize: 24,
              fontWeight:
                  FontWeight.w800,
            ),
          ),

          const SizedBox(
            height: 4,
          ),

          Text(
            area,
            textAlign:
                TextAlign.center,
            style:
                const TextStyle(
              color:
                  PhilotesColors.silver,
              fontSize: 12,
            ),
          ),

          const SizedBox(
            height: 18,
          ),

          LayoutBuilder(
            builder: (
              BuildContext context,
              BoxConstraints constraints,
            ) {
              final stacked =
                  constraints.maxWidth <
                  430;

              final view =
                  OutlinedButton.icon(
                key: const Key(
                  'viewMyProfileButton',
                ),
                onPressed:
                    onViewProfile,
                icon: const Icon(
                  Icons
                      .visibility_outlined,
                ),
                label:
                    const Text(
                  'View My Profile',
                ),
                style:
                    OutlinedButton
                        .styleFrom(
                  foregroundColor:
                      PhilotesColors.navy,
                  side:
                      const BorderSide(
                    color:
                        PhilotesColors.gold,
                    width: 1.4,
                  ),
                  padding:
                      const EdgeInsets
                          .symmetric(
                    vertical: 14,
                  ),
                ),
              );

              final edit =
                  FilledButton.icon(
                key: const Key(
                  'editMyProfileButton',
                ),
                onPressed:
                    onEditProfile,
                icon: const Icon(
                  Icons.edit_outlined,
                ),
                label:
                    const Text(
                  'Edit My Profile',
                ),
                style:
                    FilledButton
                        .styleFrom(
                  backgroundColor:
                      PhilotesColors.navy,
                  foregroundColor:
                      Colors.white,
                  padding:
                      const EdgeInsets
                          .symmetric(
                    vertical: 14,
                  ),
                ),
              );

              if (stacked) {
                return Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .stretch,
                  children: [
                    view,
                    const SizedBox(
                      height: 10,
                    ),
                    edit,
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(
                    child: view,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: edit,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}


class _SettingsSection
    extends StatelessWidget {
  const _SettingsSection({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 22,
              decoration:
                  BoxDecoration(
                color:
                    PhilotesColors.gold,
                borderRadius:
                    BorderRadius
                        .circular(4),
              ),
            ),

            const SizedBox(
              width: 9,
            ),

            Expanded(
              child: Text(
                title,
                style:
                    PhilotesDesign
                        .sectionHeading,
              ),
            ),
          ],
        ),

        const SizedBox(
          height: 10,
        ),

        Container(
          decoration:
              PhilotesDesign
                  .primaryCardDecoration(),
          child: Column(
            children: [
              for (
                var index = 0;
                index <
                    children.length;
                index++
              ) ...[
                children[index],
                if (
                  index <
                  children.length - 1
                )
                  const Divider(
                    height: 1,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}


class _SettingsTile
    extends StatelessWidget {
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
    final foreground =
        destructive
            ? Colors.red.shade700
            : PhilotesColors.navy;

    return ListTile(
      onTap: onTap,
      contentPadding:
          const EdgeInsets
              .symmetric(
        horizontal: 16,
        vertical: 5,
      ),
      leading: Container(
        width: 40,
        height: 40,
        decoration:
            BoxDecoration(
          shape: BoxShape.circle,
          color:
              PhilotesColors.navy
                  .withValues(
            alpha: 0.06,
          ),
          border: Border.all(
            color:
                PhilotesColors.gold,
            width: 1,
          ),
        ),
        alignment:
            Alignment.center,
        child: Icon(
          icon,
          color: foreground,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: foreground,
          fontSize: 14,
          fontWeight:
              FontWeight.w700,
        ),
      ),
      subtitle: Padding(
        padding:
            const EdgeInsets
                .only(
          top: 3,
        ),
        child: Text(
          subtitle,
          style:
              const TextStyle(
            color:
                PhilotesColors.silver,
            fontSize: 11,
            height: 1.3,
          ),
        ),
      ),
      trailing: Row(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          if (trailingText !=
              null) ...[
            Text(
              trailingText!,
              style:
                  const TextStyle(
                color:
                    PhilotesColors
                        .silver,
                fontSize: 11,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
          ],
          const Icon(
            Icons.chevron_right,
            color:
                PhilotesColors.gold,
            size: 20,
          ),
        ],
      ),
    );
  }
}


class MyProfilePreviewScreen
    extends StatelessWidget {
  const MyProfilePreviewScreen({
    super.key,
  });

  OnboardingProfileData get _profile =>
      OnboardingProfileData.instance;

  String get _name {
    final value =
        _profile.displayName.trim();

    return value.isEmpty
        ? 'Philotes Member'
        : value;
  }

  @override
  Widget build(BuildContext context) {
    return _YouSubpageScaffold(
      key: const Key(
        'myProfilePreviewScreen',
      ),
      title: 'My Profile',
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment
                .stretch,
        children: [
          const Text(
            'This preview shows the profile '
            'information Philotes can use when '
            'presenting you to other members.',
            style:
                PhilotesDesign
                    .supportingText,
          ),

          const SizedBox(
            height: 20,
          ),

          Container(
            padding:
                const EdgeInsets
                    .all(22),
            decoration:
                PhilotesDesign
                    .primaryCardDecoration(),
            child: Column(
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration:
                      BoxDecoration(
                    shape:
                        BoxShape.circle,
                    color:
                        PhilotesColors
                            .navy,
                    border:
                        Border.all(
                      color:
                          PhilotesColors
                              .gold,
                      width: 2.4,
                    ),
                  ),
                  alignment:
                      Alignment.center,
                  child: Text(
                    _name
                        .substring(
                          0,
                          1,
                        )
                        .toUpperCase(),
                    style:
                        const TextStyle(
                      color:
                          Colors.white,
                      fontSize: 38,
                      fontWeight:
                          FontWeight
                              .w800,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 14,
                ),

                Text(
                  _name,
                  style:
                      const TextStyle(
                    color:
                        PhilotesColors
                            .navy,
                    fontSize: 26,
                    fontWeight:
                        FontWeight
                            .w800,
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),

                Text(
                  _profile
                      .generalAreaLabel,
                  style:
                      const TextStyle(
                    color:
                        PhilotesColors
                            .silver,
                    fontSize: 12,
                  ),
                ),

                if (
                  _profile
                      .introduction
                      .trim()
                      .isNotEmpty
                ) ...[
                  const SizedBox(
                    height: 14,
                  ),
                  Text(
                    _profile
                        .introduction,
                    textAlign:
                        TextAlign
                            .center,
                    style:
                        PhilotesDesign
                            .supportingText,
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          _ProfileValuesCard(
            title:
                'Favorites / Like the Most',
            values:
                _profile
                    .favoriteInterests,
            emptyText:
                'No favorites selected.',
          ),

          const SizedBox(
            height: 16,
          ),

          _ProfileValuesCard(
            title: 'Interests',
            values:
                _profile
                    .selectedInterests,
            emptyText:
                'No interests selected.',
          ),

          const SizedBox(
            height: 16,
          ),

          _ProfileValuesCard(
            title:
                'Friendship Styles',
            values:
                _profile
                    .friendshipStyles,
            emptyText:
                'No friendship styles selected.',
          ),

          const SizedBox(
            height: 16,
          ),

          _ProfileDetailCard(
            title:
                'Friendship Preferences',
            rows: [
              _ProfileDetail(
                label:
                    'Social Frequency',
                value:
                    _profile
                            .socialFrequency ??
                        'Not selected',
              ),
              _ProfileDetail(
                label:
                    'Planning Style',
                value:
                    _profile
                            .planningStyle ??
                        'Not selected',
              ),
              _ProfileDetail(
                label:
                    'Interest Style',
                value:
                    _profile
                            .interestStyle ??
                        'Not selected',
              ),
              _ProfileDetail(
                label:
                    'Trying New Activities',
                value:
                    _profile
                            .newActivityComfort ??
                        'Not selected',
              ),
              _ProfileDetail(
                label:
                    'Friend Age Range',
                value:
                    _profile
                        .friendAgeRangeLabel,
              ),
            ],
          ),

          const SizedBox(
            height: 16,
          ),

          _ProfileDetailCard(
            title:
                'Discovery',
            rows: [
              _ProfileDetail(
                label:
                    'General Area',
                value:
                    _profile
                        .generalAreaLabel,
              ),
              _ProfileDetail(
                label:
                    'Meeting Distance',
                value:
                    _profile
                        .meetingDistanceLabel,
              ),
              _ProfileDetail(
                label:
                    'Flexible Discovery',
                value:
                    _profile
                            .flexibleDiscovery
                        ? 'On'
                        : 'Off',
              ),
              _ProfileDetail(
                label:
                    'Online Friendships',
                value:
                    _profile
                            .onlineFriendships
                        ? 'Allowed'
                        : 'Not selected',
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class EditProfileHubScreen
    extends StatelessWidget {
  const EditProfileHubScreen({
    super.key,
  });

  void _open(
    BuildContext context,
    Widget screen,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) =>
            screen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _YouSubpageScaffold(
      key: const Key(
        'editProfileHubScreen',
      ),
      title:
          'Edit My Profile',
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment
                .stretch,
        children: [
          const Text(
            'Permanent profile changes belong '
            'here. Discover remains focused on '
            'temporary discovery refinement.',
            style:
                PhilotesDesign
                    .supportingText,
          ),

          const SizedBox(
            height: 20,
          ),

          _SettingsSection(
            title:
                'Profile Editing',
            children: [
              _SettingsTile(
                icon:
                    Icons
                        .person_outline,
                title:
                    'Personal Profile',
                subtitle:
                    'Name, introduction, photo, '
                    'and personal details.',
                onTap: () {
                  _open(
                    context,
                    const InformationScreen(
                      title:
                          'Personal Profile',
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
                icon:
                    Icons
                        .interests_outlined,
                title:
                    'Interests',
                subtitle:
                    'Interests and Like the '
                    'Most selections.',
                onTap: () {
                  _open(
                    context,
                    const ProfileInterestsScreen(),
                  );
                },
              ),
              _SettingsTile(
                icon:
                    Icons
                        .people_outline,
                title:
                    'Friendship Preferences',
                subtitle:
                    'Social and friendship '
                    'compatibility preferences.',
                onTap: () {
                  _open(
                    context,
                    const FriendshipPreferencesSummaryScreen(),
                  );
                },
              ),
              _SettingsTile(
                icon:
                    Icons
                        .person_search_outlined,
                title:
                    'Discovery Preferences',
                subtitle:
                    'Permanent discovery '
                    'defaults.',
                onTap: () {
                  _open(
                    context,
                    const DiscoveryPreferencesSummaryScreen(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class ProfileInterestsScreen
    extends StatelessWidget {
  const ProfileInterestsScreen({
    super.key,
  });

  OnboardingProfileData get _profile =>
      OnboardingProfileData.instance;

  @override
  Widget build(BuildContext context) {
    return _YouSubpageScaffold(
      title: 'Interests',
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment
                .stretch,
        children: [
          _ProfileValuesCard(
            title:
                'Favorites / Like the Most',
            values:
                _profile
                    .favoriteInterests,
            emptyText:
                'No favorite interests selected.',
          ),

          const SizedBox(
            height: 16,
          ),

          _ProfileValuesCard(
            title:
                'Other Interests',
            values:
                _profile
                    .selectedInterests
                    .where(
                      (value) =>
                          !_profile
                              .favoriteInterests
                              .contains(
                            value,
                          ),
                    )
                    .toList(),
            emptyText:
                'No additional interests selected.',
          ),

          const SizedBox(
            height: 18,
          ),

          const _DevelopmentNotice(
            text:
                'The production edit controls '
                'will reuse the existing onboarding '
                'interest catalog rather than '
                'creating a second interest system.',
          ),
        ],
      ),
    );
  }
}


class FriendshipPreferencesSummaryScreen
    extends StatelessWidget {
  const FriendshipPreferencesSummaryScreen({
    super.key,
  });

  OnboardingProfileData get _profile =>
      OnboardingProfileData.instance;

  @override
  Widget build(BuildContext context) {
    return _YouSubpageScaffold(
      title:
          'Friendship Preferences',
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment
                .stretch,
        children: [
          _ProfileValuesCard(
            title:
                'Friendship Styles',
            values:
                _profile
                    .friendshipStyles,
            emptyText:
                'No friendship styles selected.',
          ),

          const SizedBox(
            height: 16,
          ),

          _ProfileDetailCard(
            title:
                'Compatibility Preferences',
            rows: [
              _ProfileDetail(
                label:
                    'Social Frequency',
                value:
                    _profile
                            .socialFrequency ??
                        'Not selected',
              ),
              _ProfileDetail(
                label:
                    'Planning Style',
                value:
                    _profile
                            .planningStyle ??
                        'Not selected',
              ),
              _ProfileDetail(
                label:
                    'Interest Style',
                value:
                    _profile
                            .interestStyle ??
                        'Not selected',
              ),
              _ProfileDetail(
                label:
                    'New Activities',
                value:
                    _profile
                            .newActivityComfort ??
                        'Not selected',
              ),
              _ProfileDetail(
                label:
                    'Friend Age Range',
                value:
                    _profile
                        .friendAgeRangeLabel,
              ),
            ],
          ),

          const SizedBox(
            height: 18,
          ),

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


class DiscoveryPreferencesSummaryScreen
    extends StatelessWidget {
  const DiscoveryPreferencesSummaryScreen({
    super.key,
  });

  OnboardingProfileData get _profile =>
      OnboardingProfileData.instance;

  @override
  Widget build(BuildContext context) {
    return _YouSubpageScaffold(
      title:
          'Discovery Preferences',
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment
                .stretch,
        children: [
          _ProfileDetailCard(
            title:
                'Permanent Defaults',
            rows: [
              _ProfileDetail(
                label:
                    'Flexible Discovery',
                value:
                    _profile
                            .flexibleDiscovery
                        ? 'On'
                        : 'Off',
              ),
              _ProfileDetail(
                label:
                    'Friend Age Range',
                value:
                    _profile
                        .friendAgeRangeLabel,
              ),
              _ProfileDetail(
                label:
                    'Meeting Distance',
                value:
                    _profile
                        .meetingDistanceLabel,
              ),
              _ProfileDetail(
                label:
                    'Online Friendships',
                value:
                    _profile
                            .onlineFriendships
                        ? 'Allowed'
                        : 'Off',
              ),
            ],
          ),

          const SizedBox(
            height: 18,
          ),

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


class LocationDistanceSummaryScreen
    extends StatelessWidget {
  const LocationDistanceSummaryScreen({
    super.key,
  });

  OnboardingProfileData get _profile =>
      OnboardingProfileData.instance;

  @override
  Widget build(BuildContext context) {
    return _YouSubpageScaffold(
      title:
          'Location & Distance',
      child: _ProfileDetailCard(
        title:
            'Discovery Area',
        rows: [
          _ProfileDetail(
            label:
                'Location Source',
            value:
                _profile.locationSource ==
                        'device'
                    ? 'Current device area'
                    : _profile.locationSource ==
                            'zip'
                        ? 'ZIP area'
                        : 'Not selected',
          ),
          _ProfileDetail(
            label:
                'General Area',
            value:
                _profile
                    .generalAreaLabel,
          ),
          _ProfileDetail(
            label:
                'Normal Distance',
            value:
                _profile
                    .meetingDistanceLabel,
          ),
          _ProfileDetail(
            label:
                'Flexible Discovery',
            value:
                _profile
                        .flexibleDiscovery
                    ? 'On'
                    : 'Off',
          ),
        ],
      ),
    );
  }
}


class PrivacySettingsScreen
    extends StatefulWidget {
  const PrivacySettingsScreen({
    super.key,
  });

  @override
  State<PrivacySettingsScreen>
      createState() =>
          _PrivacySettingsScreenState();
}


class _PrivacySettingsScreenState
    extends State<
        PrivacySettingsScreen> {
  bool _discoverable = true;
  bool _showApproximateDistance = true;
  bool _showOnlineStatus = false;

  @override
  Widget build(BuildContext context) {
    return _YouSubpageScaffold(
      key: const Key(
        'privacySettingsScreen',
      ),
      title:
          'Privacy Settings',
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment
                .stretch,
        children: [
          _ToggleCard(
            title:
                'Profile Privacy',
            children: [
              _ToggleTile(
                title:
                    'Allow discovery',
                subtitle:
                    'Allow your profile to '
                    'appear to compatible members.',
                value:
                    _discoverable,
                onChanged: (value) {
                  setState(() {
                    _discoverable =
                        value;
                  });
                },
              ),
              _ToggleTile(
                title:
                    'Show approximate distance',
                subtitle:
                    'Display general distance '
                    'rather than precise location.',
                value:
                    _showApproximateDistance,
                onChanged: (value) {
                  setState(() {
                    _showApproximateDistance =
                        value;
                  });
                },
              ),
              _ToggleTile(
                title:
                    'Show online status',
                subtitle:
                    'Allow friends to see when '
                    'you are currently active.',
                value:
                    _showOnlineStatus,
                onChanged: (value) {
                  setState(() {
                    _showOnlineStatus =
                        value;
                  });
                },
              ),
            ],
          ),

          const SizedBox(
            height: 18,
          ),

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


class SafetyReportingScreen
    extends StatelessWidget {
  const SafetyReportingScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const InformationScreen(
      key: Key(
        'safetyReportingScreen',
      ),
      title:
          'Safety & Reporting',
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


class CommunityGuidelinesScreen
    extends StatelessWidget {
  const CommunityGuidelinesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const InformationScreen(
      key: Key(
        'communityGuidelinesScreen',
      ),
      title:
          'Community Guidelines',
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


class AccountInformationScreen
    extends StatelessWidget {
  const AccountInformationScreen({
    super.key,
  });

  OnboardingProfileData get _profile =>
      OnboardingProfileData.instance;

  @override
  Widget build(BuildContext context) {
    return _YouSubpageScaffold(
      title:
          'Account Information',
      child: _ProfileDetailCard(
        title:
            'Member Information',
        rows: [
          _ProfileDetail(
            label:
                'Display Name',
            value:
                _profile
                        .displayName
                        .trim()
                        .isEmpty
                    ? 'Not selected'
                    : _profile
                        .displayName,
          ),
          _ProfileDetail(
            label:
                'First Name',
            value:
                _profile
                        .firstName
                        .trim()
                        .isEmpty
                    ? 'Not selected'
                    : _profile
                        .firstName,
          ),
          _ProfileDetail(
            label:
                'Account Status',
            value:
                'Development account',
          ),
          _ProfileDetail(
            label:
                'Profile Photo',
            value:
                _profile.photoSelected
                    ? 'Selected'
                    : 'Not selected',
          ),
        ],
      ),
    );
  }
}


class EmailSignInScreen
    extends StatelessWidget {
  const EmailSignInScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const _YouSubpageScaffold(
      key: Key(
        'emailSignInScreen',
      ),
      title:
          'Email & Sign-In',
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment
                .stretch,
        children: [
          _ProfileDetailCard(
            title:
                'Verified Email',
            rows: [
              _ProfileDetail(
                label:
                    'Account Email',
                value:
                    'Backend connection required',
              ),
              _ProfileDetail(
                label:
                    'Verification',
                value:
                    'Backend connection required',
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          _ProfileDetailCard(
            title:
                'Sign-In & Recovery',
            rows: [
              _ProfileDetail(
                label:
                    'Change Password',
                value:
                    'Backend connection required',
              ),
              _ProfileDetail(
                label:
                    'Account Recovery',
                value:
                    'Backend connection required',
              ),
              _ProfileDetail(
                label:
                    'Change Email',
                value:
                    'Verification required',
              ),
            ],
          ),
          SizedBox(
            height: 18,
          ),
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


class MfaSettingsScreen
    extends StatelessWidget {
  const MfaSettingsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _YouSubpageScaffold(
      key: const Key(
        'mfaSettingsScreen',
      ),
      title:
          'Multi-Factor Authentication',
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment
                .stretch,
        children: [
          Container(
            padding:
                const EdgeInsets
                    .all(18),
            decoration:
                PhilotesDesign
                    .primaryCardDecoration(),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .stretch,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Status',
                        style:
                            TextStyle(
                          color:
                              PhilotesColors
                                  .navy,
                          fontSize: 15,
                          fontWeight:
                              FontWeight
                                  .w800,
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          const EdgeInsets
                              .symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration:
                          BoxDecoration(
                        borderRadius:
                            BorderRadius
                                .circular(
                          20,
                        ),
                        border:
                            Border.all(
                          color:
                              PhilotesColors
                                  .gold,
                        ),
                      ),
                      child:
                          const Text(
                        'Off',
                        style:
                            TextStyle(
                          color:
                              PhilotesColors
                                  .navy,
                          fontWeight:
                              FontWeight
                                  .w700,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 14,
                ),

                const Text(
                  'MFA is optional for regular '
                  'Philotes members. Members who '
                  'choose to enable it will use '
                  'a supported standards-based '
                  'authenticator.',
                  style:
                      PhilotesDesign
                          .supportingText,
                ),

                const SizedBox(
                  height: 16,
                ),

                FilledButton.icon(
                  key: const Key(
                    'setupMfaButton',
                  ),
                  onPressed: () {
                    showDialog<void>(
                      context:
                          context,
                      builder:
                          (context) {
                        return AlertDialog(
                          title:
                              const Text(
                            'Set Up MFA',
                          ),
                          content:
                              const Text(
                            'MFA enrollment '
                            'will become active '
                            'when the Philotes '
                            'authentication '
                            'backend is built.',
                          ),
                          actions: [
                            TextButton(
                              onPressed:
                                  () {
                                Navigator.of(
                                  context,
                                ).pop();
                              },
                              child:
                                  const Text(
                                'Close',
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon:
                      const Icon(
                    Icons
                        .phonelink_lock_outlined,
                  ),
                  label:
                      const Text(
                    'Set Up MFA',
                  ),
                  style:
                      FilledButton
                          .styleFrom(
                    backgroundColor:
                        PhilotesColors
                            .navy,
                    foregroundColor:
                        Colors.white,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 16,
          ),

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


class SessionsDevicesScreen
    extends StatelessWidget {
  const SessionsDevicesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const InformationScreen(
      title:
          'Active Sessions & Devices',
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


class NotificationsSettingsScreen
    extends StatefulWidget {
  const NotificationsSettingsScreen({
    super.key,
  });

  @override
  State<NotificationsSettingsScreen>
      createState() =>
          _NotificationsSettingsScreenState();
}


class _NotificationsSettingsScreenState
    extends State<
        NotificationsSettingsScreen> {
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

  String _emailFrequency =
      'Immediately';

  @override
  Widget build(BuildContext context) {
    return _YouSubpageScaffold(
      key: const Key(
        'notificationsSettingsScreen',
      ),
      title:
          'Notifications',
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment
                .stretch,
        children: [
          const Text(
            'In-app notifications are the '
            'primary notification channel. '
            'Email delivery can be adjusted '
            'for the events you want.',
            style:
                PhilotesDesign
                    .supportingText,
          ),

          const SizedBox(
            height: 20,
          ),

          _ToggleCard(
            title:
                'In-App Notifications',
            children: [
              _ToggleTile(
                title:
                    'New friendship interest',
                value:
                    _inAppFriendshipInterest,
                onChanged: (value) {
                  setState(() {
                    _inAppFriendshipInterest =
                        value;
                  });
                },
              ),
              _ToggleTile(
                title:
                    'New friendship connection',
                value:
                    _inAppConnection,
                onChanged: (value) {
                  setState(() {
                    _inAppConnection =
                        value;
                  });
                },
              ),
              _ToggleTile(
                title:
                    'New direct message',
                value:
                    _inAppDirectMessage,
                onChanged: (value) {
                  setState(() {
                    _inAppDirectMessage =
                        value;
                  });
                },
              ),
              _ToggleTile(
                title:
                    'New group message',
                value:
                    _inAppGroupMessage,
                onChanged: (value) {
                  setState(() {
                    _inAppGroupMessage =
                        value;
                  });
                },
              ),
              _ToggleTile(
                title:
                    'Plan invitation',
                value:
                    _inAppPlanInvitation,
                onChanged: (value) {
                  setState(() {
                    _inAppPlanInvitation =
                        value;
                  });
                },
              ),
              _ToggleTile(
                title:
                    'Plan update',
                value:
                    _inAppPlanUpdate,
                onChanged: (value) {
                  setState(() {
                    _inAppPlanUpdate =
                        value;
                  });
                },
              ),
              _ToggleTile(
                title:
                    'Plan reminder',
                value:
                    _inAppPlanReminder,
                onChanged: (value) {
                  setState(() {
                    _inAppPlanReminder =
                        value;
                  });
                },
              ),
              const _LockedToggleTile(
                title:
                    'Safety & account alerts',
                subtitle:
                    'Important security and '
                    'safety notices remain on.',
              ),
            ],
          ),

          const SizedBox(
            height: 22,
          ),

          _ToggleCard(
            title:
                'Email Notifications',
            children: [
              _ToggleTile(
                key: const Key(
                  'emailNotificationsMasterToggle',
                ),
                title:
                    'Email notifications',
                subtitle:
                    'Send selected Philotes '
                    'notifications to the '
                    'verified account email.',
                value:
                    _emailEnabled,
                onChanged: (value) {
                  setState(() {
                    _emailEnabled =
                        value;
                  });
                },
              ),

              if (_emailEnabled) ...[
                _ToggleTile(
                  title:
                      'New friendship interest',
                  value:
                      _emailFriendshipInterest,
                  onChanged:
                      (value) {
                    setState(() {
                      _emailFriendshipInterest =
                          value;
                    });
                  },
                ),
                _ToggleTile(
                  title:
                      'New friendship connection',
                  value:
                      _emailConnection,
                  onChanged:
                      (value) {
                    setState(() {
                      _emailConnection =
                          value;
                    });
                  },
                ),
                _ToggleTile(
                  title:
                      'New direct message',
                  value:
                      _emailDirectMessage,
                  onChanged:
                      (value) {
                    setState(() {
                      _emailDirectMessage =
                          value;
                    });
                  },
                ),
                _ToggleTile(
                  title:
                      'New group message',
                  value:
                      _emailGroupMessage,
                  onChanged:
                      (value) {
                    setState(() {
                      _emailGroupMessage =
                          value;
                    });
                  },
                ),
                _ToggleTile(
                  title:
                      'Plan invitation',
                  value:
                      _emailPlanInvitation,
                  onChanged:
                      (value) {
                    setState(() {
                      _emailPlanInvitation =
                          value;
                    });
                  },
                ),
                _ToggleTile(
                  title:
                      'Plan update',
                  value:
                      _emailPlanUpdate,
                  onChanged:
                      (value) {
                    setState(() {
                      _emailPlanUpdate =
                          value;
                    });
                  },
                ),
                _ToggleTile(
                  title:
                      'Plan reminder',
                  value:
                      _emailPlanReminder,
                  onChanged:
                      (value) {
                    setState(() {
                      _emailPlanReminder =
                          value;
                    });
                  },
                ),
                _ToggleTile(
                  title:
                      'General Philotes updates',
                  value:
                      _emailGeneralUpdates,
                  onChanged:
                      (value) {
                    setState(() {
                      _emailGeneralUpdates =
                          value;
                    });
                  },
                ),
                _ToggleTile(
                  title:
                      'Product announcements',
                  value:
                      _emailProductAnnouncements,
                  onChanged:
                      (value) {
                    setState(() {
                      _emailProductAnnouncements =
                          value;
                    });
                  },
                ),
                _ToggleTile(
                  key: const Key(
                    'emailMessagePreviewToggle',
                  ),
                  title:
                      'Show message previews '
                      'in email',
                  subtitle:
                      'Off by default for privacy.',
                  value:
                      _emailMessagePreview,
                  onChanged:
                      (value) {
                    setState(() {
                      _emailMessagePreview =
                          value;
                    });
                  },
                ),
                const _LockedToggleTile(
                  title:
                      'Security & account alerts',
                  subtitle:
                      'Critical account-security '
                      'emails remain enabled.',
                ),
              ],
            ],
          ),

          if (_emailEnabled) ...[
            const SizedBox(
              height: 22,
            ),

            Container(
              padding:
                  const EdgeInsets
                      .all(16),
              decoration:
                  PhilotesDesign
                      .primaryCardDecoration(),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .stretch,
                children: [
                  const Text(
                    'Email Frequency',
                    style:
                        TextStyle(
                      color:
                          PhilotesColors
                              .navy,
                      fontSize: 15,
                      fontWeight:
                          FontWeight
                              .w800,
                    ),
                  ),

                  const SizedBox(
                    height: 6,
                  ),

                  const Text(
                    'Security and critical '
                    'account alerts are always '
                    'sent immediately.',
                    style:
                        PhilotesDesign
                            .supportingText,
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  DropdownButtonFormField<
                      String>(
                    key: const Key(
                      'emailFrequencyDropdown',
                    ),
                    value:
                        _emailFrequency,
                    decoration:
                        const InputDecoration(
                      labelText:
                          'Regular notification email',
                    ),
                    items:
                        const [
                      DropdownMenuItem<
                          String>(
                        value:
                            'Immediately',
                        child:
                            Text(
                          'Immediately',
                        ),
                      ),
                      DropdownMenuItem<
                          String>(
                        value:
                            'Daily summary',
                        child:
                            Text(
                          'Daily summary',
                        ),
                      ),
                      DropdownMenuItem<
                          String>(
                        value: 'Off',
                        child:
                            Text('Off'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value ==
                          null) {
                        return;
                      }

                      setState(() {
                        _emailFrequency =
                            value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(
            height: 18,
          ),

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


class MembershipScreen
    extends StatelessWidget {
  const MembershipScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const InformationScreen(
      title:
          'Subscription / Membership',
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


class AccessibilitySettingsScreen
    extends StatelessWidget {
  const AccessibilitySettingsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const InformationScreen(
      title:
          'Accessibility',
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


class HelpSupportScreen
    extends StatelessWidget {
  const HelpSupportScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const InformationScreen(
      title:
          'Help & Support',
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


class AboutPhilotesScreen
    extends StatelessWidget {
  const AboutPhilotesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const InformationScreen(
      title:
          'About Philotes',
      description:
          'PHILOTES — A Community for Friendship.',
      items: [
        'Brought to you by Titan',
        'Application information',
        'Version information',
        'Acknowledgements',
      ],
    );
  }
}


class LegalPrivacyScreen
    extends StatelessWidget {
  const LegalPrivacyScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const InformationScreen(
      title:
          'Legal & Privacy',
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


class _ToggleCard
    extends StatelessWidget {
  const _ToggleCard({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style:
              PhilotesDesign
                  .sectionHeading,
        ),

        const SizedBox(
          height: 10,
        ),

        Container(
          decoration:
              PhilotesDesign
                  .primaryCardDecoration(),
          child: Column(
            children: [
              for (
                var index = 0;
                index <
                    children.length;
                index++
              ) ...[
                children[index],
                if (
                  index <
                  children.length - 1
                )
                  const Divider(
                    height: 1,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}


class _ToggleTile
    extends StatelessWidget {
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
  final ValueChanged<bool>
      onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(
        title,
        style:
            const TextStyle(
          color:
              PhilotesColors.navy,
          fontSize: 13,
          fontWeight:
              FontWeight.w700,
        ),
      ),
      subtitle:
          subtitle == null
              ? null
              : Text(
                  subtitle!,
                  style:
                      const TextStyle(
                    color:
                        PhilotesColors
                            .silver,
                    fontSize: 10,
                  ),
                ),
      value: value,
      onChanged:
          onChanged,
    );
  }
}


class _LockedToggleTile
    extends StatelessWidget {
  const _LockedToggleTile({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(
        title,
        style:
            const TextStyle(
          color:
              PhilotesColors.navy,
          fontSize: 13,
          fontWeight:
              FontWeight.w700,
        ),
      ),
      subtitle: Text(
        subtitle,
        style:
            const TextStyle(
          color:
              PhilotesColors.silver,
          fontSize: 10,
        ),
      ),
      value: true,
      onChanged: null,
    );
  }
}


class _ProfileValuesCard
    extends StatelessWidget {
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
      crossAxisAlignment:
          CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style:
              PhilotesDesign
                  .sectionHeading,
        ),

        const SizedBox(
          height: 10,
        ),

        Container(
          padding:
              const EdgeInsets
                  .all(16),
          decoration:
              PhilotesDesign
                  .secondaryCardDecoration(),
          child:
              values.isEmpty
                  ? Text(
                      emptyText,
                      style:
                          PhilotesDesign
                              .supportingText,
                    )
                  : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (
                          final value
                              in values
                        )
                          Container(
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration:
                                BoxDecoration(
                              color:
                                  PhilotesColors
                                      .navy,
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                22,
                              ),
                              border:
                                  Border.all(
                                color:
                                    PhilotesColors
                                        .gold,
                                width: 1.2,
                              ),
                            ),
                            child: Text(
                              value,
                              style:
                                  const TextStyle(
                                color:
                                    Colors.white,
                                fontSize: 11,
                                fontWeight:
                                    FontWeight
                                        .w600,
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
  const _ProfileDetail({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
}


class _ProfileDetailCard
    extends StatelessWidget {
  const _ProfileDetailCard({
    required this.title,
    required this.rows,
  });

  final String title;
  final List<_ProfileDetail> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style:
              PhilotesDesign
                  .sectionHeading,
        ),

        const SizedBox(
          height: 10,
        ),

        Container(
          decoration:
              PhilotesDesign
                  .primaryCardDecoration(),
          child: Column(
            children: [
              for (
                var index = 0;
                index <
                    rows.length;
                index++
              ) ...[
                Padding(
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Expanded(
                        child: Text(
                          rows[index]
                              .label,
                          style:
                              const TextStyle(
                            color:
                                PhilotesColors
                                    .navy,
                            fontSize: 12,
                            fontWeight:
                                FontWeight
                                    .w700,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 14,
                      ),
                      Flexible(
                        child: Text(
                          rows[index]
                              .value,
                          textAlign:
                              TextAlign
                                  .right,
                          style:
                              const TextStyle(
                            color:
                                PhilotesColors
                                    .silver,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (
                  index <
                  rows.length - 1
                )
                  const Divider(
                    height: 1,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}


class _DevelopmentNotice
    extends StatelessWidget {
  const _DevelopmentNotice({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.all(15),
      decoration:
          PhilotesDesign
              .secondaryCardDecoration(),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons
                .construction_outlined,
            color:
                PhilotesColors.gold,
            size: 20,
          ),

          const SizedBox(
            width: 10,
          ),

          Expanded(
            child: Text(
              text,
              style:
                  PhilotesDesign
                      .supportingText,
            ),
          ),
        ],
      ),
    );
  }
}


class InformationScreen
    extends StatelessWidget {
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
        crossAxisAlignment:
            CrossAxisAlignment
                .stretch,
        children: [
          Text(
            description,
            style:
                PhilotesDesign
                    .supportingText,
          ),

          const SizedBox(
            height: 18,
          ),

          Container(
            decoration:
                PhilotesDesign
                    .primaryCardDecoration(),
            child: Column(
              children: [
                for (
                  var index = 0;
                  index <
                      items.length;
                  index++
                ) ...[
                  ListTile(
                    leading:
                        const Icon(
                      Icons
                          .check_circle_outline,
                      color:
                          PhilotesColors
                              .gold,
                      size: 20,
                    ),
                    title: Text(
                      items[index],
                      style:
                          const TextStyle(
                        color:
                            PhilotesColors
                                .navy,
                        fontSize: 13,
                        fontWeight:
                            FontWeight
                                .w600,
                      ),
                    ),
                  ),
                  if (
                    index <
                    items.length - 1
                  )
                    const Divider(
                      height: 1,
                    ),
                ],
              ],
            ),
          ),

          const SizedBox(
            height: 18,
          ),

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


class _YouSubpageScaffold
    extends StatelessWidget {
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
      key: key,
      backgroundColor:
          PhilotesColors.ivory,
      appBar: AppBar(
        backgroundColor:
            PhilotesColors.ivory,
        foregroundColor:
            PhilotesColors.navy,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          title,
          style:
              const TextStyle(
            color:
                PhilotesColors.navy,
            fontSize: 17,
            fontWeight:
                FontWeight.w800,
          ),
        ),
        bottom:
            const PreferredSize(
          preferredSize:
              Size.fromHeight(
            1.2,
          ),
          child: Divider(
            height: 1.2,
            thickness:
                PhilotesDesign
                    .secondaryBorderWidth,
            color:
                PhilotesColors.gold,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (
          BuildContext context,
          BoxConstraints constraints,
        ) {
          final wide =
              constraints.maxWidth >=
              PhilotesDesign
                  .wideBreakpoint;

          return SingleChildScrollView(
            padding:
                EdgeInsets.fromLTRB(
              wide
                  ? PhilotesDesign
                      .widePadding
                  : PhilotesDesign
                      .mobilePadding,
              24,
              wide
                  ? PhilotesDesign
                      .widePadding
                  : PhilotesDesign
                      .mobilePadding,
              44,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(
                  maxWidth:
                      PhilotesDesign
                          .contentMaxWidth,
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
"""


YOU_TEST_CONTENT = r"""import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:philotes/models/onboarding_profile_data.dart';
import 'package:philotes/screens/app/philotes_shell_screen.dart';


void main() {
  setUp(() {
    final profile =
        OnboardingProfileData.instance;

    profile.reset();

    profile.firstName = 'Alex';
    profile.displayName = 'Alex';
    profile.introduction =
        'I enjoy good conversation, '
        'live events, and activities '
        'with friends.';

    profile.favoriteInterests =
        <String>[
      'Movies',
      'Dining Out',
      'Bowling',
    ];

    profile.selectedInterests =
        <String>[
      'Movies',
      'Dining Out',
      'Bowling',
      'Technology',
      'Road Trips',
    ];

    profile.friendshipStyles =
        <String>[
      'One-on-one friendships',
      'Small groups',
    ];

    profile.socialFrequency =
        "Whenever we're both available";
    profile.planningStyle =
        'A little of both';
    profile.interestStyle =
        'A balance of shared interests '
        'and new experiences';
    profile.newActivityComfort =
        'Maybe';

    profile.minimumFriendAge = 30;
    profile.maximumFriendAge = 55;

    profile.locationSource =
        'device';
    profile.meetingDistance =
        '25';
    profile.flexibleDiscovery =
        true;
  });

  Future<void> openYou(
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home:
            PhilotesShellScreen(),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(
        const Key(
          'navYou',
        ),
      ),
    );

    await tester.pumpAndSettle();
  }

  testWidgets(
    'You navigation opens You V1',
    (
      WidgetTester tester,
    ) async {
      await openYou(tester);

      expect(
        find.byKey(
          const Key(
            'youScreen',
          ),
        ),
        findsOneWidget,
      );

      expect(
        find.byKey(
          const Key(
            'youProfileHeroCard',
          ),
        ),
        findsOneWidget,
      );

      expect(
        find.text('Alex'),
        findsWidgets,
      );
    },
  );

  testWidgets(
    'View My Profile opens member preview',
    (
      WidgetTester tester,
    ) async {
      await openYou(tester);

      final button =
          find.byKey(
        const Key(
          'viewMyProfileButton',
        ),
      );

      await tester.ensureVisible(
        button,
      );

      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(
        find.byKey(
          const Key(
            'myProfilePreviewScreen',
          ),
        ),
        findsOneWidget,
      );

      expect(
        find.text(
          'Favorites / Like the Most',
        ),
        findsOneWidget,
      );

      expect(
        find.text(
          'Friendship Preferences',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Edit My Profile opens editing hub',
    (
      WidgetTester tester,
    ) async {
      await openYou(tester);

      final button =
          find.byKey(
        const Key(
          'editMyProfileButton',
        ),
      );

      await tester.ensureVisible(
        button,
      );

      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(
        find.byKey(
          const Key(
            'editProfileHubScreen',
          ),
        ),
        findsOneWidget,
      );

      expect(
        find.text(
          'Profile Editing',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Notifications settings expose email preferences',
    (
      WidgetTester tester,
    ) async {
      await openYou(tester);

      final tile =
          find.byKey(
        const Key(
          'youNotificationsTile',
        ),
      );

      await tester.ensureVisible(
        tile,
      );

      await tester.tap(tile);
      await tester.pumpAndSettle();

      expect(
        find.byKey(
          const Key(
            'notificationsSettingsScreen',
          ),
        ),
        findsOneWidget,
      );

      expect(
        find.byKey(
          const Key(
            'emailNotificationsMasterToggle',
          ),
        ),
        findsOneWidget,
      );

      expect(
        find.byKey(
          const Key(
            'emailFrequencyDropdown',
          ),
        ),
        findsOneWidget,
      );

      expect(
        find.byKey(
          const Key(
            'emailMessagePreviewToggle',
          ),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'MFA is optional and has setup destination',
    (
      WidgetTester tester,
    ) async {
      await openYou(tester);

      final tile =
          find.byKey(
        const Key(
          'youMfaTile',
        ),
      );

      await tester.ensureVisible(
        tile,
      );

      await tester.tap(tile);
      await tester.pumpAndSettle();

      expect(
        find.byKey(
          const Key(
            'mfaSettingsScreen',
          ),
        ),
        findsOneWidget,
      );

      expect(
        find.text('Off'),
        findsOneWidget,
      );

      expect(
        find.byKey(
          const Key(
            'setupMfaButton',
          ),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Privacy and safety destinations exist',
    (
      WidgetTester tester,
    ) async {
      await openYou(tester);

      final privacy =
          find.byKey(
        const Key(
          'youPrivacySettingsTile',
        ),
      );

      await tester.ensureVisible(
        privacy,
      );

      expect(
        privacy,
        findsOneWidget,
      );

      expect(
        find.byKey(
          const Key(
            'youBlockedMembersTile',
          ),
        ),
        findsOneWidget,
      );

      expect(
        find.byKey(
          const Key(
            'youSafetyReportingTile',
          ),
        ),
        findsOneWidget,
      );

      expect(
        find.byKey(
          const Key(
            'youCommunityGuidelinesTile',
          ),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Account actions are present',
    (
      WidgetTester tester,
    ) async {
      await openYou(tester);

      final delete =
          find.byKey(
        const Key(
          'youDeleteAccountTile',
        ),
      );

      await tester.ensureVisible(
        delete,
      );

      expect(
        find.byKey(
          const Key(
            'youSignOutTile',
          ),
        ),
        findsOneWidget,
      );

      expect(
        find.byKey(
          const Key(
            'youDeactivateAccountTile',
          ),
        ),
        findsOneWidget,
      );

      expect(
        delete,
        findsOneWidget,
      );
    },
  );
}
"""


def main() -> None:
    print()
    print("=" * 76)
    print(
        "PHILOTES YOU V1 PATCH"
    )
    print("=" * 76)
    print()

    required = [
        SHELL_FILE,
        WIDGET_TEST_FILE,
    ]

    for path in required:
        if not path.exists():
            print(
                f"FAIL: Required file not found: {path}"
            )
            raise SystemExit(1)

    original_shell = (
        SHELL_FILE.read_text(
            encoding="utf-8",
        )
    )

    original_widget_test = (
        WIDGET_TEST_FILE.read_text(
            encoding="utf-8",
        )
    )

    you_existed = YOU_FILE.exists()

    test_existed = YOU_TEST_FILE.exists()

    original_you = (
        YOU_FILE.read_text(
            encoding="utf-8",
        )
        if you_existed
        else ""
    )

    original_you_test = (
        YOU_TEST_FILE.read_text(
            encoding="utf-8",
        )
        if test_existed
        else ""
    )

    try:
        YOU_FILE.parent.mkdir(
            parents=True,
            exist_ok=True,
        )

        YOU_FILE.write_text(
            YOU_CONTENT,
            encoding="utf-8",
        )

        YOU_TEST_FILE.write_text(
            YOU_TEST_CONTENT,
            encoding="utf-8",
        )

        shell = original_shell

        messages_import = (
            "import '../../screens/messages/"
            "messages_screen.dart';"
        )

        you_import = (
            "import '../../screens/you/"
            "you_screen.dart';"
        )

        if you_import not in shell:
            if messages_import not in shell:
                raise RuntimeError(
                    "Messages import anchor "
                    "not found in shell."
                )

            shell = shell.replace(
                messages_import,
                messages_import
                + "\n"
                + you_import,
                1,
            )

        old_you_destination = """      case 4:
        return const _DevelopmentDestination(
          title: 'You',
          description:
              'You will contain your profile, '
              'preferences, privacy controls, '
              'membership, and account settings.',
        );"""

        new_you_destination = """      case 4:
        return const YouScreen();"""

        if new_you_destination not in shell:
            if old_you_destination not in shell:
                raise RuntimeError(
                    "You placeholder "
                    "was not found in shell."
                )

            shell = shell.replace(
                old_you_destination,
                new_you_destination,
                1,
            )

        SHELL_FILE.write_text(
            shell,
            encoding="utf-8",
        )

        widget_test = original_widget_test

        old_you_test = """      expect(
        find.textContaining(
          'profile, preferences',
        ),
        findsOneWidget,
      );"""

        new_you_test = """      expect(
        find.byKey(
          const Key(
            'youScreen',
          ),
        ),
        findsOneWidget,
      );"""

        if new_you_test not in widget_test:
            if old_you_test not in widget_test:
                raise RuntimeError(
                    "Existing You navigation "
                    "test assertion was not found."
                )

            widget_test = (
                widget_test.replace(
                    old_you_test,
                    new_you_test,
                    1,
                )
            )

        WIDGET_TEST_FILE.write_text(
            widget_test,
            encoding="utf-8",
        )

    except Exception as exc:
        SHELL_FILE.write_text(
            original_shell,
            encoding="utf-8",
        )

        WIDGET_TEST_FILE.write_text(
            original_widget_test,
            encoding="utf-8",
        )

        if you_existed:
            YOU_FILE.write_text(
                original_you,
                encoding="utf-8",
            )
        elif YOU_FILE.exists():
            YOU_FILE.unlink()

        if test_existed:
            YOU_TEST_FILE.write_text(
                original_you_test,
                encoding="utf-8",
            )
        elif YOU_TEST_FILE.exists():
            YOU_TEST_FILE.unlink()

        print()
        print(f"FAIL: {exc}")
        print()
        print(
            "Existing files restored and "
            "new You files removed."
        )

        raise SystemExit(1)

    shell = (
        SHELL_FILE.read_text(
            encoding="utf-8",
        )
    )

    you = (
        YOU_FILE.read_text(
            encoding="utf-8",
        )
    )

    you_tests = (
        YOU_TEST_FILE.read_text(
            encoding="utf-8",
        )
    )

    widget_tests = (
        WIDGET_TEST_FILE.read_text(
            encoding="utf-8",
        )
    )

    checks = {
        "You screen created":
            YOU_FILE.exists(),

        "Shell imports You":
            "you_screen.dart"
            in shell,

        "You placeholder replaced":
            "return const YouScreen();"
            in shell,

        "Five-tab navigation preserved":
            "navYou"
            in shell
            and
            "navMessages"
            in shell
            and
            "navPlans"
            in shell
            and
            "navDiscover"
            in shell
            and
            "navHome"
            in shell,

        "Profile hero created":
            "youProfileHeroCard"
            in you,

        "View My Profile created":
            "viewMyProfileButton"
            in you,

        "Edit My Profile created":
            "editMyProfileButton"
            in you,

        "Existing profile data reused":
            "OnboardingProfileData"
            in you,

        "Interests section created":
            "Profile & Discovery"
            in you
            and
            "youInterestsTile"
            in you,

        "Friendship preferences created":
            "youFriendshipPreferencesTile"
            in you,

        "Permanent discovery preferences created":
            "youDiscoveryPreferencesTile"
            in you,

        "Location and distance created":
            "youLocationDistanceTile"
            in you,

        "Privacy settings created":
            "youPrivacySettingsTile"
            in you,

        "Blocked members created":
            "youBlockedMembersTile"
            in you,

        "Safety and reporting created":
            "youSafetyReportingTile"
            in you,

        "Community guidelines created":
            "youCommunityGuidelinesTile"
            in you,

        "Account information created":
            "youAccountInformationTile"
            in you,

        "Email and sign-in created":
            "youEmailSignInTile"
            in you,

        "Optional MFA created":
            "youMfaTile"
            in you
            and
            "Optional additional"
            in you,

        "Active sessions created":
            "youSessionsTile"
            in you,

        "Notifications created":
            "youNotificationsTile"
            in you,

        "In-app notifications created":
            "In-App Notifications"
            in you,

        "Email notifications created":
            "Email Notifications"
            in you,

        "Email master switch created":
            "emailNotificationsMasterToggle"
            in you,

        "Email frequency created":
            "emailFrequencyDropdown"
            in you,

        "Email message-preview privacy created":
            "emailMessagePreviewToggle"
            in you,

        "Critical security alerts preserved":
            "Security & account alerts"
            in you,

        "Membership created":
            "youMembershipTile"
            in you,

        "Accessibility created":
            "youAccessibilityTile"
            in you,

        "Help and support created":
            "youHelpSupportTile"
            in you,

        "About Philotes created":
            "youAboutTile"
            in you,

        "Legal and privacy created":
            "youLegalPrivacyTile"
            in you,

        "Sign out created":
            "youSignOutTile"
            in you,

        "Deactivate account created":
            "youDeactivateAccountTile"
            in you,

        "Delete account created":
            "youDeleteAccountTile"
            in you,

        "Dedicated You tests created":
            YOU_TEST_FILE.exists(),

        "Notifications test created":
            "Notifications settings expose "
            "email preferences"
            in you_tests,

        "MFA test created":
            "MFA is optional and has "
            "setup destination"
            in you_tests,

        "Legacy You placeholder test updated":
            "find.byKey("
            in widget_tests
            and
            "'youScreen'"
            in widget_tests,
    }

    passed = True

    report = [
        (
            "PHILOTES YOU V1 "
            "PATCH REPORT"
        ),
        "=" * 76,
        (
            "Generated: "
            + datetime.now().isoformat(
                timespec="seconds",
            )
        ),
        "",
    ]

    for description, result in checks.items():
        status = (
            "PASS"
            if result
            else "FAIL"
        )

        print(
            f"{status}: {description}"
        )

        report.append(
            f"{status}: {description}"
        )

        if not result:
            passed = False

    report.extend(
        [
            "",
            "OVERALL: "
            + (
                "PASS"
                if passed
                else "FAIL"
            ),
            "",
            "YOU V1 DESIGN CONTRACT",
            "-" * 76,
            (
                "- Existing Home, Discover, Plans, "
                "and Messages remain unchanged."
            ),
            (
                "- You replaces only the existing "
                "You development placeholder."
            ),
            (
                "- Existing OnboardingProfileData "
                "is reused for member profile data."
            ),
            (
                "- Permanent profile preferences "
                "belong under You."
            ),
            (
                "- Discover remains focused on "
                "temporary discovery refinement."
            ),
            (
                "- In-app notifications remain "
                "the primary notification channel."
            ),
            (
                "- Email notifications are "
                "member-configurable."
            ),
            (
                "- Critical security and account "
                "alerts remain enabled."
            ),
            (
                "- Email message previews are "
                "off by default for privacy."
            ),
            (
                "- MFA is optional for normal "
                "members in this frontend design."
            ),
            (
                "- Backend-dependent security, "
                "email, membership, and account "
                "actions are represented honestly "
                "and are not faked as production "
                "functionality."
            ),
        ]
    )

    REPORT_FILE.write_text(
        "\n".join(report) + "\n",
        encoding="utf-8",
    )

    print()
    print(
        f"Report: {REPORT_FILE}"
    )
    print()

    print(
        "OVERALL: "
        + (
            "PASS"
            if passed
            else "FAIL"
        )
    )

    if not passed:
        raise SystemExit(1)


if __name__ == "__main__":
    main()

