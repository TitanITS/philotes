import 'package:flutter/material.dart';

import '../../theme/philotes_colors.dart';
import 'interests_screen.dart';

class BasicProfileScreen extends StatefulWidget {
  const BasicProfileScreen({super.key});

  @override
  State<BasicProfileScreen> createState() =>
      _BasicProfileScreenState();
}

class _BasicProfileScreenState extends State<BasicProfileScreen> {
  final TextEditingController _firstNameController =
      TextEditingController();

  final TextEditingController _lastNameController =
      TextEditingController();

  final TextEditingController _displayNameController =
      TextEditingController();

  final TextEditingController _otherSexController =
      TextEditingController();

  final TextEditingController _pronounsController =
      TextEditingController();

  final TextEditingController _introductionController =
      TextEditingController();

  DateTime? _dateOfBirth;

  String? _sex;

  bool _showPronouns = false;
  bool _showValidation = false;

  bool get _firstNameValid =>
      _firstNameController.text.trim().isNotEmpty;

  bool get _lastNameValid =>
      _lastNameController.text.trim().isNotEmpty;

  bool get _displayNameValid =>
      _displayNameController.text.trim().isNotEmpty;

  bool get _ageValid =>
      _dateOfBirth != null && _isAtLeast18(_dateOfBirth!);

  bool get _requiredFieldsValid =>
      _firstNameValid &&
      _lastNameValid &&
      _displayNameValid &&
      _ageValid;

  bool _isAtLeast18(DateTime birthDate) {
    final today = DateTime.now();

    int age = today.year - birthDate.year;

    final birthdayHasOccurred =
        today.month > birthDate.month ||
        (today.month == birthDate.month &&
            today.day >= birthDate.day);

    if (!birthdayHasOccurred) {
      age--;
    }

    return age >= 18;
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$month/$day/${date.year}';
  }

  void _refresh(String value) {
    setState(() {
      if (_showValidation && _requiredFieldsValid) {
        _showValidation = false;
      }
    });
  }

  Future<void> _selectDateOfBirth() async {
    final today = DateTime.now();

    final eighteenYearsAgo = DateTime(
      today.year - 18,
      today.month,
      today.day,
    );

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? eighteenYearsAgo,
      firstDate: DateTime(1900),
      lastDate: today,
      helpText: 'Select your date of birth',
    );

    if (selectedDate == null || !mounted) {
      return;
    }

    setState(() {
      _dateOfBirth = selectedDate;
    });
  }

  void _continue() {
    if (!_requiredFieldsValid) {
      setState(() {
        _showValidation = true;
      });

      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => const InterestsScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _displayNameController.dispose();
    _otherSexController.dispose();
    _pronounsController.dispose();
    _introductionController.dispose();
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
              24,
              20,
              24,
              36,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 620,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Your Basic Profile',
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
                      width: 130,
                      height: 2,
                      decoration: BoxDecoration(
                        color: PhilotesColors.gold,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Tell Philotes the basics. You will have plenty of '
                    'opportunities to share interests and personality in '
                    'the next steps.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: PhilotesColors.silver,
                      fontSize: 16,
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
                        border: Border.all(
                          color: Colors.red,
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Please complete all required fields and '
                              'confirm that you are at least 18 years old.',
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

                  const SizedBox(height: 28),

                  _FieldLabel(
                    label: 'First Name',
                    required: true,
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    key: const Key('firstNameField'),
                    controller: _firstNameController,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    autofillHints: const [
                      AutofillHints.givenName,
                    ],
                    onChanged: _refresh,
                    decoration: _fieldDecoration(
                      hintText: 'Your first name',
                      icon: Icons.person_outline,
                      errorText:
                          _showValidation && !_firstNameValid
                          ? 'First name is required.'
                          : null,
                    ),
                  ),

                  const SizedBox(height: 22),

                  _FieldLabel(
                    label: 'Last Name',
                    required: true,
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    key: const Key('lastNameField'),
                    controller: _lastNameController,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    autofillHints: const [
                      AutofillHints.familyName,
                    ],
                    onChanged: _refresh,
                    decoration: _fieldDecoration(
                      hintText: 'Your last name',
                      icon: Icons.badge_outlined,
                      errorText:
                          _showValidation && !_lastNameValid
                          ? 'Last name is required.'
                          : null,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const _PrivacyNote(
                    text:
                        'Your full last name is private and will not be '
                        'shown publicly by default.',
                  ),

                  const SizedBox(height: 22),

                  _FieldLabel(
                    label: 'Display Name',
                    required: true,
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    key: const Key('displayNameField'),
                    controller: _displayNameController,
                    textInputAction: TextInputAction.next,
                    onChanged: _refresh,
                    decoration: _fieldDecoration(
                      hintText: 'How members will know you',
                      icon: Icons.account_circle_outlined,
                      errorText:
                          _showValidation && !_displayNameValid
                          ? 'Display name is required.'
                          : null,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const _SupportingNote(
                    text:
                        'This is the name other Philotes members will '
                        'normally see.',
                  ),

                  const SizedBox(height: 22),

                  _FieldLabel(
                    label: 'Date of Birth',
                    required: true,
                  ),

                  const SizedBox(height: 8),

                  OutlinedButton(
                    key: const Key('dateOfBirthButton'),
                    onPressed: _selectDateOfBirth,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 17,
                      ),
                      foregroundColor: PhilotesColors.navy,
                      side: BorderSide(
                        color:
                            _showValidation && !_ageValid
                            ? Colors.red
                            : PhilotesColors.gold,
                        width:
                            _showValidation && !_ageValid
                            ? 2
                            : 1.2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_month_outlined,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _dateOfBirth == null
                                ? 'Select your date of birth'
                                : _formatDate(_dateOfBirth!),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: _dateOfBirth == null
                                  ? FontWeight.w400
                                  : FontWeight.w600,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_drop_down,
                        ),
                      ],
                    ),
                  ),

                  if (_dateOfBirth != null && !_ageValid) ...[
                    const SizedBox(height: 8),

                    const Text(
                      'Philotes membership is limited to adults age 18 '
                      'and older.',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],

                  const SizedBox(height: 8),

                  const _PrivacyNote(
                    text:
                        'Used to confirm age eligibility. Your birthday '
                        'will not be shown publicly.',
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'Optional Profile Details',
                    style: TextStyle(
                      color: PhilotesColors.navy,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Share only what you are comfortable sharing.',
                    style: TextStyle(
                      color: PhilotesColors.silver,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const _FieldLabel(
                    label: 'Sex',
                    required: false,
                  ),

                  const SizedBox(height: 8),

                  DropdownButtonFormField<String>(
                    key: const Key('sexField'),
                    initialValue: _sex,
                    decoration: _fieldDecoration(
                      hintText: 'Select an option',
                      icon: Icons.person_search_outlined,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Male',
                        child: Text('Male'),
                      ),
                      DropdownMenuItem(
                        value: 'Female',
                        child: Text('Female'),
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
                        _sex = value;

                        if (_sex != 'Other') {
                          _otherSexController.clear();
                        }
                      });
                    },
                  ),

                  if (_sex == 'Other') ...[
                    const SizedBox(height: 14),

                    TextField(
                      key: const Key('otherSexField'),
                      controller: _otherSexController,
                      textInputAction: TextInputAction.next,
                      decoration: _fieldDecoration(
                        hintText:
                            'How would you like to describe yourself?',
                        icon: Icons.edit_outlined,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const _SupportingNote(
                      text: 'Optional.',
                    ),
                  ],

                  const SizedBox(height: 20),

                  if (!_showPronouns)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        key: const Key('addPronounsButton'),
                        onPressed: () {
                          setState(() {
                            _showPronouns = true;
                          });
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: PhilotesColors.navy,
                        ),
                        icon: const Icon(
                          Icons.add_circle_outline,
                        ),
                        label: const Text(
                          'Add pronouns',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  else ...[
                    const _FieldLabel(
                      label: 'Pronouns',
                      required: false,
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      key: const Key('pronounsField'),
                      controller: _pronounsController,
                      textInputAction: TextInputAction.next,
                      decoration: _fieldDecoration(
                        hintText: 'Optional pronouns',
                        icon: Icons.chat_bubble_outline,
                        suffixIcon: IconButton(
                          tooltip: 'Remove pronouns field',
                          onPressed: () {
                            setState(() {
                              _showPronouns = false;
                              _pronounsController.clear();
                            });
                          },
                          icon: const Icon(
                            Icons.close,
                          ),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 22),

                  const _FieldLabel(
                    label:
                        'What should new friends know about you?',
                    required: false,
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    key: const Key('introductionField'),
                    controller: _introductionController,
                    minLines: 4,
                    maxLines: 6,
                    maxLength: 300,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: _fieldDecoration(
                      hintText:
                          'Share a little about yourself, what you enjoy, '
                          'or what kind of friendships you hope to build.',
                      icon: Icons.waving_hand_outlined,
                      alignLabelWithHint: true,
                    ),
                  ),

                  const SizedBox(height: 28),

                  SizedBox(
                    height: 56,
                    child: FilledButton(
                      key: const Key('basicProfileContinueButton'),
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

  InputDecoration _fieldDecoration({
    required String hintText,
    required IconData icon,
    String? errorText,
    Widget? suffixIcon,
    bool alignLabelWithHint = false,
  }) {
    return InputDecoration(
      hintText: hintText,
      errorText: errorText,
      prefixIcon: Icon(icon),
      suffixIcon: suffixIcon,
      alignLabelWithHint: alignLabelWithHint,
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.5,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 2,
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({
    required this.label,
    required this.required,
  });

  final String label;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            label,
            style: const TextStyle(
              color: PhilotesColors.navy,
              fontSize: 15,
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
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ],
    );
  }
}

class _PrivacyNote extends StatelessWidget {
  const _PrivacyNote({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.lock_outline,
          color: PhilotesColors.gold,
          size: 16,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: PhilotesColors.silver,
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _SupportingNote extends StatelessWidget {
  const _SupportingNote({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: PhilotesColors.silver,
        fontSize: 12,
        height: 1.4,
      ),
    );
  }
}
