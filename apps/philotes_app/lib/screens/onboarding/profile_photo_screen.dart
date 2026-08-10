import 'package:flutter/material.dart';

import '../../theme/philotes_colors.dart';

class ProfilePhotoScreen extends StatefulWidget {
  const ProfilePhotoScreen({super.key});

  @override
  State<ProfilePhotoScreen> createState() =>
      _ProfilePhotoScreenState();
}

class _ProfilePhotoScreenState extends State<ProfilePhotoScreen> {
  bool _photoSelected = false;
  String? _photoSource;
  bool _showValidation = false;

  void _simulatePhotoSelection(String source) {
    setState(() {
      _photoSelected = true;
      _photoSource = source;
      _showValidation = false;
    });
  }

  void _removePhoto() {
    setState(() {
      _photoSelected = false;
      _photoSource = null;
    });
  }

  void _continue() {
    if (!_photoSelected) {
      setState(() {
        _showValidation = true;
      });

      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Review Your Profile will be the next onboarding step.',
        ),
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
                maxWidth: 620,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Add a Profile Photo',
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
                    'Help new friends recognize you.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: PhilotesColors.navy,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'A clear, authentic profile photo helps build '
                    'trust and makes it easier for people to recognize '
                    'each other when meeting in person.',
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
                      key: const Key('profilePhotoError'),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.orange.shade800,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.photo_camera_outlined,
                            color: Colors.orange.shade800,
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              'Please add a profile photo before continuing.',
                              style: TextStyle(
                                color: PhilotesColors.navy,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 30),

                  Center(
                    child: Container(
                      width: 190,
                      height: 190,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _photoSelected
                            ? PhilotesColors.navy
                            : Colors.white.withValues(alpha: 0.70),
                        border: Border.all(
                          color: PhilotesColors.gold,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: PhilotesColors.navy.withValues(
                              alpha: 0.10,
                            ),
                            blurRadius: 16,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: _photoSelected
                          ? const Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 88,
                                ),
                                SizedBox(height: 4),
                                Icon(
                                  Icons.check_circle,
                                  color: PhilotesColors.gold,
                                  size: 28,
                                ),
                              ],
                            )
                          : const Icon(
                              Icons.add_a_photo_outlined,
                              color: PhilotesColors.silver,
                              size: 72,
                            ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Center(
                    child: Text(
                      _photoSelected
                          ? 'Photo selected from $_photoSource'
                          : 'No profile photo selected',
                      key: const Key('profilePhotoStatus'),
                      style: TextStyle(
                        color: _photoSelected
                            ? PhilotesColors.navy
                            : PhilotesColors.silver,
                        fontSize: 13,
                        fontWeight: _photoSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  SizedBox(
                    height: 56,
                    child: FilledButton.icon(
                      key: const Key('takePhotoButton'),
                      onPressed: () {
                        _simulatePhotoSelection('camera');
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: PhilotesColors.navy,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(
                        Icons.photo_camera_outlined,
                      ),
                      label: const Text(
                        'Take a Photo',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    height: 56,
                    child: OutlinedButton.icon(
                      key: const Key('choosePhotoButton'),
                      onPressed: () {
                        _simulatePhotoSelection('device');
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: PhilotesColors.navy,
                        side: const BorderSide(
                          color: PhilotesColors.gold,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(
                        Icons.photo_library_outlined,
                      ),
                      label: const Text(
                        'Choose From Device',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  if (_photoSelected) ...[
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: TextButton.icon(
                            key: const Key('changePhotoButton'),
                            onPressed: () {
                              _simulatePhotoSelection('device');
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: PhilotesColors.navy,
                            ),
                            icon: const Icon(
                              Icons.edit_outlined,
                            ),
                            label: const Text(
                              'Change Photo',
                            ),
                          ),
                        ),

                        Expanded(
                          child: TextButton.icon(
                            key: const Key('removePhotoButton'),
                            onPressed: _removePhoto,
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.brown.shade700,
                            ),
                            icon: const Icon(
                              Icons.delete_outline,
                            ),
                            label: const Text(
                              'Remove Photo',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 24),

                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: PhilotesColors.gold.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.photo_outlined,
                              color: PhilotesColors.gold,
                              size: 23,
                            ),
                            SizedBox(width: 9),
                            Text(
                              'Profile Photo Guidelines',
                              style: TextStyle(
                                color: PhilotesColors.navy,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 14),

                        _PhotoRule(
                          text:
                              'Use a clear, recent photo that represents you.',
                        ),

                        _PhotoRule(
                          text:
                              'Make sure your face is visible and easy '
                              'to recognize.',
                        ),

                        _PhotoRule(
                          text:
                              'You should be the primary person shown '
                              'in your main profile photo.',
                        ),

                        _PhotoRule(
                          text:
                              'Do not use misleading, impersonating, '
                              'explicit, hateful, or threatening images.',
                        ),

                        _PhotoRule(
                          text:
                              'Natural photos are welcome. Your profile '
                              'photo does not need to be a formal headshot.',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: PhilotesColors.gold.withValues(
                        alpha: 0.10,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: PhilotesColors.gold.withValues(
                          alpha: 0.65,
                        ),
                      ),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.visibility_outlined,
                          color: PhilotesColors.gold,
                          size: 22,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Your profile photo will be visible to other '
                            'Philotes members.',
                            key: Key('profilePhotoPrivacyNotice'),
                            style: TextStyle(
                              color: PhilotesColors.navy,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              height: 1.45,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: PhilotesColors.navy.withValues(
                        alpha: 0.05,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: PhilotesColors.navy,
                          size: 20,
                        ),
                        SizedBox(width: 9),
                        Expanded(
                          child: Text(
                            'Camera and photo-library access will be '
                            'connected during platform integration. '
                            'This development screen currently simulates '
                            'photo selection so we can test the onboarding '
                            'experience safely.',
                            style: TextStyle(
                              color: PhilotesColors.silver,
                              fontSize: 11,
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
                      key: const Key('profilePhotoContinueButton'),
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

class _PhotoRule extends StatelessWidget {
  const _PhotoRule({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: PhilotesColors.gold,
            size: 19,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: PhilotesColors.navy,
                fontSize: 13,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
