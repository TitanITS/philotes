import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/philotes_colors.dart';
import '../../models/onboarding_profile_data.dart';
import 'location_discovery_screen.dart';

class FriendshipPreferencesScreen extends StatefulWidget {
  const FriendshipPreferencesScreen({super.key});

  @override
  State<FriendshipPreferencesScreen> createState() =>
      _FriendshipPreferencesScreenState();
}

class _FriendshipPreferencesScreenState
    extends State<FriendshipPreferencesScreen> {
  final Set<String> _friendshipStyles = <String>{};

  String? _socialFrequency;
  String? _planningStyle;
  String? _interestStyle;
  String? _newActivityComfort;

  String _politicsImportance = 'Not important';
  String _faithImportance = 'Not important';

  String? _politicalOutlook;
  String? _faithDescription;

  bool _flexibleDiscovery = true;
  bool _showValidation = false;

  int _minimumFriendAge = 18;
  int _maximumFriendAge = 80;

  late final TextEditingController _minimumAgeController;
  late final TextEditingController _maximumAgeController;

  bool get _friendshipStyleValid => _friendshipStyles.isNotEmpty;

  bool get _requiredFieldsValid =>
      _friendshipStyleValid &&
      _socialFrequency != null &&
      _planningStyle != null &&
      _interestStyle != null &&
      _newActivityComfort != null;

  @override
  void initState() {
    super.initState();

    _minimumAgeController = TextEditingController(
      text: _minimumFriendAge.toString(),
    );

    _maximumAgeController = TextEditingController(
      text: _formatMaximumAge(_maximumFriendAge),
    );
  }

  @override
  void dispose() {
    _minimumAgeController.dispose();
    _maximumAgeController.dispose();
    super.dispose();
  }

  String _formatMaximumAge(int age) {
    return age >= 80 ? '80+' : age.toString();
  }

  void _toggleFriendshipStyle(String value) {
    setState(() {
      if (_friendshipStyles.contains(value)) {
        _friendshipStyles.remove(value);
      } else {
        _friendshipStyles.add(value);
      }

      if (_requiredFieldsValid) {
        _showValidation = false;
      }
    });
  }

  void _setMinimumAge(int age) {
    int adjustedAge = age.clamp(18, 80);

    setState(() {
      _minimumFriendAge = adjustedAge;

      if (_maximumFriendAge < _minimumFriendAge) {
        _maximumFriendAge = _minimumFriendAge;
      }

      _minimumAgeController.text = _minimumFriendAge.toString();

      _maximumAgeController.text = _formatMaximumAge(_maximumFriendAge);
    });
  }

  void _setMaximumAge(int age) {
    int adjustedAge = age.clamp(18, 80);

    if (adjustedAge < _minimumFriendAge) {
      adjustedAge = _minimumFriendAge;
    }

    setState(() {
      _maximumFriendAge = adjustedAge;

      _maximumAgeController.text = _formatMaximumAge(_maximumFriendAge);
    });
  }

  void _handleMinimumAgeTyped(String value) {
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.isEmpty) {
      return;
    }

    final parsed = int.tryParse(digits);

    if (parsed == null) {
      return;
    }

    if (parsed < 18) {
      _setMinimumAge(18);
      _minimumAgeController.selection = TextSelection.collapsed(
        offset: _minimumAgeController.text.length,
      );
      return;
    }

    _setMinimumAge(parsed);
  }

  void _handleMaximumAgeTyped(String value) {
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.isEmpty) {
      return;
    }

    final parsed = int.tryParse(digits);

    if (parsed == null) {
      return;
    }

    if (parsed < 18) {
      _setMaximumAge(18);
      _maximumAgeController.selection = TextSelection.collapsed(
        offset: _maximumAgeController.text.length,
      );
      return;
    }

    _setMaximumAge(parsed);
  }

  void _continue() {
    if (!_requiredFieldsValid) {
      setState(() {
        _showValidation = true;
      });

      return;
    }

    final profile = OnboardingProfileData.instance;

    profile.friendshipStyles = _friendshipStyles.toList();

    profile.socialFrequency = _socialFrequency;

    profile.planningStyle = _planningStyle;

    profile.interestStyle = _interestStyle;

    profile.newActivityComfort = _newActivityComfort;

    profile.minimumFriendAge = _minimumFriendAge;

    profile.maximumFriendAge = _maximumFriendAge;

    profile.politicsImportance = _politicsImportance;

    profile.politicalOutlook = _politicalOutlook;

    profile.faithImportance = _faithImportance;

    profile.faithDescription = _faithDescription;

    profile.flexibleDiscovery = _flexibleDiscovery;

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => const LocationDiscoveryScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Friendship Preferences',
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
                      width: 145,
                      height: 2,
                      decoration: BoxDecoration(
                        color: PhilotesColors.gold,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'What kind of friendships would fit your life best?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: PhilotesColors.navy,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Your answers guide Philotes recommendations. '
                    'They are not meant to put you in a box, and you '
                    'can change them later.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: PhilotesColors.silver,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),

                  if (_showValidation) ...[
                    const SizedBox(height: 18),

                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Please complete the required '
                              'friendship preference sections '
                              'before continuing.',
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

                  const SizedBox(height: 26),

                  _PreferenceSection(
                    icon: Icons.people_alt_outlined,
                    title: 'Friendship Style',
                    subtitle:
                        'Choose every type of friendship that '
                        'sounds comfortable to you.',
                    required: true,
                    child: Wrap(
                      spacing: 9,
                      runSpacing: 9,
                      children: [
                        for (final option in const [
                          'One-on-one friendships',
                          'Small groups',
                          'Larger social groups',
                          'Activity-based friendships',
                          'Casual friendships',
                          'Close friendships',
                          'Local friends',
                          'Online friends',
                          'Open to any friendship style',
                        ])
                          FilterChip(
                            key: Key('friendshipStyle-$option'),
                            label: Text(option),
                            selected: _friendshipStyles.contains(option),
                            onSelected: (_) {
                              _toggleFriendshipStyle(option);
                            },
                            selectedColor: PhilotesColors.navy,
                            checkmarkColor: PhilotesColors.gold,
                            labelStyle: TextStyle(
                              color: _friendshipStyles.contains(option)
                                  ? Colors.white
                                  : PhilotesColors.navy,
                              fontWeight: _friendshipStyles.contains(option)
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                            side: BorderSide(
                              color: PhilotesColors.gold.withValues(
                                alpha: 0.75,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  _PreferenceSection(
                    icon: Icons.schedule_outlined,
                    title: 'Social Pace',
                    subtitle: 'Tell us what normally fits your schedule.',
                    required: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const _QuestionLabel(
                          text:
                              'How often would you ideally like '
                              'to connect with friends?',
                        ),

                        const SizedBox(height: 10),

                        DropdownButtonFormField<String>(
                          key: const Key('socialFrequencyField'),
                          initialValue: _socialFrequency,
                          decoration: _inputDecoration(
                            hintText: 'Choose a social pace',
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'Several times a week',
                              child: Text('Several times a week'),
                            ),
                            DropdownMenuItem(
                              value: 'About once a week',
                              child: Text('About once a week'),
                            ),
                            DropdownMenuItem(
                              value: 'A few times a month',
                              child: Text('A few times a month'),
                            ),
                            DropdownMenuItem(
                              value: 'Occasionally',
                              child: Text('Occasionally'),
                            ),
                            DropdownMenuItem(
                              value: "Whenever we're both available",
                              child: Text("Whenever we're both available"),
                            ),
                            DropdownMenuItem(
                              value: 'No strong preference',
                              child: Text('No strong preference'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _socialFrequency = value;

                              if (_requiredFieldsValid) {
                                _showValidation = false;
                              }
                            });
                          },
                        ),

                        if (_socialFrequency ==
                            "Whenever we're both available") ...[
                          const SizedBox(height: 10),

                          Container(
                            key: const Key('flexibleSocialPaceExplanation'),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: PhilotesColors.gold.withValues(
                                alpha: 0.10,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: PhilotesColors.gold.withValues(
                                  alpha: 0.70,
                                ),
                              ),
                            ),
                            child: const Text(
                              "I'm flexible. If we're both free "
                              "and want to get together, I'm open "
                              "to making plans.",
                              style: TextStyle(
                                color: PhilotesColors.navy,
                                fontSize: 12,
                                height: 1.45,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 20),

                        const _QuestionLabel(
                          text: 'How do you feel about making plans?',
                        ),

                        const SizedBox(height: 10),

                        _ChoiceGroup(
                          values: const [
                            'I like planning ahead',
                            'A little of both',
                            'I enjoy spontaneous plans',
                          ],
                          selectedValue: _planningStyle,
                          keyPrefix: 'planningStyle',
                          onChanged: (value) {
                            setState(() {
                              _planningStyle = value;

                              if (_requiredFieldsValid) {
                                _showValidation = false;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  _PreferenceSection(
                    icon: Icons.explore_outlined,
                    title: 'Shared Interests & New Experiences',
                    subtitle:
                        'Good friendships do not always require '
                        'identical interests.',
                    required: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const _QuestionLabel(
                          text:
                              'When meeting new friends, what '
                              'sounds best?',
                        ),

                        const SizedBox(height: 10),

                        _ChoiceGroup(
                          values: const [
                            'Mostly people who share my interests',
                            'A balance of shared interests and new experiences',
                            'People who can introduce me to new things',
                            'No preference',
                          ],
                          selectedValue: _interestStyle,
                          keyPrefix: 'interestStyle',
                          onChanged: (value) {
                            setState(() {
                              _interestStyle = value;

                              if (_requiredFieldsValid) {
                                _showValidation = false;
                              }
                            });
                          },
                        ),

                        const SizedBox(height: 20),

                        const _QuestionLabel(
                          text:
                              'Would you try activities outside '
                              'your current interests?',
                        ),

                        const SizedBox(height: 10),

                        _ChoiceGroup(
                          values: const ['Yes', 'Maybe', 'Usually not'],
                          selectedValue: _newActivityComfort,
                          keyPrefix: 'newActivityComfort',
                          onChanged: (value) {
                            setState(() {
                              _newActivityComfort = value;

                              if (_requiredFieldsValid) {
                                _showValidation = false;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  _PreferenceSection(
                    icon: Icons.cake_outlined,
                    title: 'Friendship Age Range',
                    subtitle:
                        'Choose the age range you are comfortable '
                        'meeting friends in.',
                    required: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'These are friendship recommendations, '
                          'not dating preferences. You can change '
                          'this range later.',
                          style: TextStyle(
                            color: PhilotesColors.silver,
                            fontSize: 12,
                            height: 1.45,
                          ),
                        ),

                        const SizedBox(height: 18),

                        LayoutBuilder(
                          builder: (context, constraints) {
                            final narrow = constraints.maxWidth < 430;

                            final minimumField = _AgeField(
                              key: const Key('minimumFriendAgeField'),
                              label: 'Minimum Age',
                              controller: _minimumAgeController,
                              value: _minimumFriendAge,
                              onTyped: _handleMinimumAgeTyped,
                              onSelected: _setMinimumAge,
                              maximumMode: false,
                            );

                            final maximumField = _AgeField(
                              key: const Key('maximumFriendAgeField'),
                              label: 'Maximum Age',
                              controller: _maximumAgeController,
                              value: _maximumFriendAge,
                              onTyped: _handleMaximumAgeTyped,
                              onSelected: _setMaximumAge,
                              maximumMode: true,
                              minimumAllowed: _minimumFriendAge,
                            );

                            if (narrow) {
                              return Column(
                                children: [
                                  minimumField,
                                  const SizedBox(height: 16),
                                  maximumField,
                                ],
                              );
                            }

                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: minimumField),
                                const SizedBox(width: 16),
                                Expanded(child: maximumField),
                              ],
                            );
                          },
                        ),

                        const SizedBox(height: 14),

                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: PhilotesColors.gold.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.people_outline,
                                color: PhilotesColors.gold,
                                size: 20,
                              ),
                              const SizedBox(width: 9),
                              Expanded(
                                child: Text(
                                  'Preferred friendship range: '
                                  '$_minimumFriendAge - '
                                  '${_formatMaximumAge(_maximumFriendAge)}',
                                  style: const TextStyle(
                                    color: PhilotesColors.navy,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  _PreferenceSection(
                    icon: Icons.tune_outlined,
                    title: 'Compatibility Preferences',
                    subtitle:
                        'Optional. Tell Philotes only about '
                        'factors that actually matter to you '
                        'in a friendship.',
                    required: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const _OptionalExplanation(),

                        const SizedBox(height: 18),

                        _ImportanceSelector(
                          title: 'Politics',
                          value: _politicsImportance,
                          onChanged: (value) {
                            setState(() {
                              _politicsImportance = value;

                              if (value == 'Not important') {
                                _politicalOutlook = null;
                              }
                            });
                          },
                        ),

                        if (_politicsImportance != 'Not important') ...[
                          const SizedBox(height: 14),

                          DropdownButtonFormField<String>(
                            key: const Key('politicalOutlookField'),
                            initialValue: _politicalOutlook,
                            decoration: _inputDecoration(
                              hintText: 'Optional political outlook',
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'Conservative',
                                child: Text('Conservative'),
                              ),
                              DropdownMenuItem(
                                value: 'Moderate',
                                child: Text('Moderate'),
                              ),
                              DropdownMenuItem(
                                value: 'Liberal',
                                child: Text('Liberal'),
                              ),
                              DropdownMenuItem(
                                value: 'Independent',
                                child: Text('Independent'),
                              ),
                              DropdownMenuItem(
                                value: 'Other',
                                child: Text('Other'),
                              ),
                              DropdownMenuItem(
                                value: 'Prefer not to say',
                                child: Text('Prefer not to say'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _politicalOutlook = value;
                              });
                            },
                          ),
                        ],

                        const SizedBox(height: 22),

                        _ImportanceSelector(
                          title: 'Faith / Religion',
                          value: _faithImportance,
                          onChanged: (value) {
                            setState(() {
                              _faithImportance = value;

                              if (value == 'Not important') {
                                _faithDescription = null;
                              }
                            });
                          },
                        ),

                        if (_faithImportance != 'Not important') ...[
                          const SizedBox(height: 14),

                          DropdownButtonFormField<String>(
                            key: const Key('faithPreferenceField'),
                            initialValue: _faithDescription,
                            decoration: _inputDecoration(
                              hintText: 'Optional faith preference',
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'Catholic',
                                child: Text('Catholic'),
                              ),
                              DropdownMenuItem(
                                value: 'Christian',
                                child: Text('Christian'),
                              ),
                              DropdownMenuItem(
                                value: 'Jewish',
                                child: Text('Jewish'),
                              ),
                              DropdownMenuItem(
                                value: 'Muslim',
                                child: Text('Muslim'),
                              ),
                              DropdownMenuItem(
                                value: 'Hindu',
                                child: Text('Hindu'),
                              ),
                              DropdownMenuItem(
                                value: 'Buddhist',
                                child: Text('Buddhist'),
                              ),
                              DropdownMenuItem(
                                value: 'Spiritual',
                                child: Text('Spiritual'),
                              ),
                              DropdownMenuItem(
                                value: 'Not religious',
                                child: Text('Not religious'),
                              ),
                              DropdownMenuItem(
                                value: 'Other',
                                child: Text('Other'),
                              ),
                              DropdownMenuItem(
                                value: 'Prefer not to say',
                                child: Text('Prefer not to say'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _faithDescription = value;
                              });
                            },
                          ),
                        ],

                        const SizedBox(height: 18),

                        const Text(
                          'Additional lifestyle compatibility '
                          'options such as smoking, drinking, '
                          'pets, family lifestyle, and '
                          'accessibility can be refined later.',
                          style: TextStyle(
                            color: PhilotesColors.silver,
                            fontSize: 12,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  Material(
                    color: PhilotesColors.gold.withValues(alpha: 0.10),
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: PhilotesColors.gold.withValues(alpha: 0.7),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: CheckboxListTile(
                        key: const Key('flexibleDiscoveryCheckbox'),
                        contentPadding: EdgeInsets.zero,
                        value: _flexibleDiscovery,
                        activeColor: PhilotesColors.navy,
                        checkColor: Colors.white,
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (value) {
                          setState(() {
                            _flexibleDiscovery = value ?? false;
                          });
                        },
                        title: const Text(
                          'Help me discover people I might '
                          'not normally meet.',
                          style: TextStyle(
                            color: PhilotesColors.navy,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        subtitle: const Padding(
                          padding: EdgeInsets.only(top: 6),
                          child: Text(
                            'When appropriate, Philotes can '
                            'broaden recommendations beyond '
                            'your usual patterns while still '
                            'respecting important boundaries.',
                            style: TextStyle(
                              color: PhilotesColors.silver,
                              fontSize: 12,
                              height: 1.45,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: PhilotesColors.gold.withValues(alpha: 0.55),
                      ),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: PhilotesColors.gold,
                          size: 22,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Preferences guide discovery. '
                            'They do not automatically exclude '
                            'someone unless Philotes later '
                            'identifies a setting specifically '
                            'as a deal breaker.',
                            style: TextStyle(
                              color: PhilotesColors.navy,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              height: 1.45,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  SizedBox(
                    height: 56,
                    child: FilledButton(
                      key: const Key('friendshipPreferencesContinueButton'),
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

class _AgeField extends StatelessWidget {
  const _AgeField({
    super.key,
    required this.label,
    required this.controller,
    required this.value,
    required this.onTyped,
    required this.onSelected,
    required this.maximumMode,
    this.minimumAllowed = 18,
  });

  final String label;
  final TextEditingController controller;
  final int value;
  final ValueChanged<String> onTyped;
  final ValueChanged<int> onSelected;
  final bool maximumMode;
  final int minimumAllowed;

  @override
  Widget build(BuildContext context) {
    final availableAges = List<int>.generate(
      63,
      (index) => index + 18,
    ).where((age) => !maximumMode || age >= minimumAllowed);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: PhilotesColors.navy,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
          ],
          onChanged: onTyped,
          decoration: InputDecoration(
            filled: true,
            fillColor: PhilotesColors.ivory.withValues(alpha: 0.65),
            suffixIcon: PopupMenuButton<int>(
              key: Key(
                maximumMode ? 'maximumAgeDropdown' : 'minimumAgeDropdown',
              ),
              tooltip: 'Choose $label',
              icon: const Icon(Icons.arrow_drop_down),
              onSelected: onSelected,
              itemBuilder: (context) {
                return [
                  for (final age in availableAges)
                    PopupMenuItem<int>(
                      value: age,
                      child: Text(
                        maximumMode && age == 80 ? '80+' : age.toString(),
                      ),
                    ),
                ];
              },
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: PhilotesColors.gold.withValues(alpha: 0.6),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: PhilotesColors.gold,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PreferenceSection extends StatelessWidget {
  const _PreferenceSection({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.required,
    required this.child,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool required;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PhilotesColors.gold.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: PhilotesColors.navy,
                  shape: BoxShape.circle,
                  border: Border.all(color: PhilotesColors.gold, width: 1.7),
                ),
                child: Icon(icon, color: Colors.white, size: 22),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            style: const TextStyle(
                              color: PhilotesColors.navy,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (required) ...[
                          const SizedBox(width: 5),
                          const Text(
                            '*',
                            style: TextStyle(
                              color: PhilotesColors.gold,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 4),

                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: PhilotesColors.silver,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          child,
        ],
      ),
    );
  }
}

class _QuestionLabel extends StatelessWidget {
  const _QuestionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: PhilotesColors.navy,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _ChoiceGroup extends StatelessWidget {
  const _ChoiceGroup({
    required this.values,
    required this.selectedValue,
    required this.keyPrefix,
    required this.onChanged,
  });

  final List<String> values;
  final String? selectedValue;
  final String keyPrefix;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final value in values)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              key: Key('$keyPrefix-$value'),
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                onChanged(value);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: selectedValue == value
                      ? PhilotesColors.navy.withValues(alpha: 0.08)
                      : PhilotesColors.ivory.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selectedValue == value
                        ? PhilotesColors.gold
                        : PhilotesColors.gold.withValues(alpha: 0.45),
                    width: selectedValue == value ? 1.6 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      selectedValue == value
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: selectedValue == value
                          ? PhilotesColors.gold
                          : PhilotesColors.silver,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        value,
                        style: TextStyle(
                          color: PhilotesColors.navy,
                          fontSize: 13,
                          fontWeight: selectedValue == value
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ImportanceSelector extends StatelessWidget {
  const _ImportanceSelector({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: PhilotesColors.navy,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 5),

        const Text(
          'Does compatibility in this area matter to you?',
          style: TextStyle(color: PhilotesColors.silver, fontSize: 12),
        ),

        const SizedBox(height: 10),

        SegmentedButton<String>(
          segments: const [
            ButtonSegment<String>(
              value: 'Not important',
              label: Text('Not important'),
            ),
            ButtonSegment<String>(
              value: 'Somewhat important',
              label: Text('Somewhat'),
            ),
            ButtonSegment<String>(value: 'Very important', label: Text('Very')),
          ],
          selected: <String>{value},
          onSelectionChanged: (selection) {
            onChanged(selection.first);
          },
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
              if (states.contains(WidgetState.selected)) {
                return Colors.white;
              }

              return PhilotesColors.navy;
            }),
            backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
              if (states.contains(WidgetState.selected)) {
                return PhilotesColors.navy;
              }

              return Colors.white.withValues(alpha: 0.4);
            }),
          ),
        ),
      ],
    );
  }
}

class _OptionalExplanation extends StatelessWidget {
  const _OptionalExplanation();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: PhilotesColors.gold.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'Some people care about certain personal or '
        'lifestyle factors when forming friendships. '
        'Others do not. This entire section is optional.',
        style: TextStyle(
          color: PhilotesColors.navy,
          fontSize: 12,
          height: 1.45,
        ),
      ),
    );
  }
}

InputDecoration _inputDecoration({required String hintText}) {
  return InputDecoration(
    hintText: hintText,
    filled: true,
    fillColor: PhilotesColors.ivory.withValues(alpha: 0.65),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: PhilotesColors.gold.withValues(alpha: 0.6)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: PhilotesColors.gold, width: 2),
    ),
  );
}
