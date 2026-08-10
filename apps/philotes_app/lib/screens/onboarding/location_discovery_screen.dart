import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/philotes_colors.dart';
import 'verification_safety_screen.dart';

class LocationDiscoveryScreen extends StatefulWidget {
  const LocationDiscoveryScreen({super.key});

  @override
  State<LocationDiscoveryScreen> createState() =>
      _LocationDiscoveryScreenState();
}

class _LocationDiscoveryScreenState
    extends State<LocationDiscoveryScreen> {
  final TextEditingController _zipController =
      TextEditingController();

  String? _locationSource;
  String? _meetingDistance;

  bool _showZipEntry = false;
  bool _zipIsConfirmed = false;
  bool _onlineFriendships = false;
  bool _showValidation = false;

  bool get _locationSelected =>
      _locationSource != null;

  bool get _distanceSelected =>
      _meetingDistance != null;

  bool get _canContinue =>
      _locationSelected && _distanceSelected;

  bool get _zipIsValid =>
      RegExp(r'^\d{5}$').hasMatch(
        _zipController.text.trim(),
      );

  void _useCurrentLocation() {
    setState(() {
      _locationSource = 'device';
      _showZipEntry = false;
      _zipIsConfirmed = false;

      if (_canContinue) {
        _showValidation = false;
      }
    });
  }

  void _showZipCodeEntry() {
    setState(() {
      _showZipEntry = true;

      if (_locationSource == 'device') {
        _locationSource = null;
      }
    });
  }

  void _confirmZipCode() {
    if (!_zipIsValid) {
      setState(() {
        _zipIsConfirmed = false;
      });

      return;
    }

    setState(() {
      _locationSource = 'zip';
      _zipIsConfirmed = true;

      if (_canContinue) {
        _showValidation = false;
      }
    });
  }

  void _selectDistance(String value) {
    setState(() {
      _meetingDistance = value;

      if (_canContinue) {
        _showValidation = false;
      }
    });
  }

  void _continue() {
    if (!_canContinue) {
      setState(() {
        _showValidation = true;
      });

      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) =>
            const VerificationSafetyScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _zipController.dispose();
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
              20,
              20,
              20,
              36,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 680,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Location & Discovery',
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
                        borderRadius:
                            BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Help Philotes find people in your general area.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: PhilotesColors.navy,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'You choose how Philotes determines your general '
                    'area and how far you are comfortable traveling '
                    'to meet a friend.',
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
                        color:
                            Colors.red.withValues(alpha: 0.08),
                        borderRadius:
                            BorderRadius.circular(12),
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
                              'Please choose a location source and '
                              'meeting distance before continuing.',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 13,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 26),

                  _SectionCard(
                    icon: Icons.location_on_outlined,
                    title: 'Your General Area',
                    subtitle:
                        'Choose one way for Philotes to determine '
                        'where to look for nearby friends.',
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.stretch,
                      children: [
                        _LocationChoiceButton(
                          key: const Key(
                            'useCurrentLocationButton',
                          ),
                          selected:
                              _locationSource == 'device',
                          icon:
                              Icons.my_location_outlined,
                          title:
                              'Use My Current Location',
                          subtitle:
                              'Use your device location to determine '
                              'your general area.',
                          onTap: _useCurrentLocation,
                        ),

                        const SizedBox(height: 14),

                        const Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: PhilotesColors.gold,
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Text(
                                'OR',
                                style: TextStyle(
                                  color:
                                      PhilotesColors.silver,
                                  fontSize: 11,
                                  fontWeight:
                                      FontWeight.w700,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: PhilotesColors.gold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        _LocationChoiceButton(
                          key: const Key(
                            'enterZipCodeButton',
                          ),
                          selected:
                              _locationSource == 'zip',
                          icon:
                              Icons.pin_drop_outlined,
                          title:
                              'Enter ZIP Code Instead',
                          subtitle:
                              'Use a general ZIP-code area without '
                              'using your device location.',
                          onTap: _showZipCodeEntry,
                        ),

                        if (_showZipEntry) ...[
                          const SizedBox(height: 16),

                          Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: TextField(
                                  key: const Key(
                                    'zipCodeField',
                                  ),
                                  controller:
                                      _zipController,
                                  keyboardType:
                                      TextInputType.number,
                                  maxLength: 5,
                                  inputFormatters: [
                                    FilteringTextInputFormatter
                                        .digitsOnly,
                                    LengthLimitingTextInputFormatter(
                                      5,
                                    ),
                                  ],
                                  onChanged: (_) {
                                    if (_zipIsConfirmed) {
                                      setState(() {
                                        _zipIsConfirmed =
                                            false;
                                        _locationSource =
                                            null;
                                      });
                                    }
                                  },
                                  decoration:
                                      InputDecoration(
                                    hintText:
                                        '5-digit ZIP code',
                                    counterText: '',
                                    filled: true,
                                    fillColor:
                                        Colors.white
                                            .withValues(
                                      alpha: 0.65,
                                    ),
                                    errorText:
                                        _zipController
                                                    .text
                                                    .isNotEmpty &&
                                                !_zipIsValid
                                            ? 'Enter a valid 5-digit ZIP code.'
                                            : null,
                                    border:
                                        OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        12,
                                      ),
                                    ),
                                    enabledBorder:
                                        OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        12,
                                      ),
                                      borderSide:
                                          BorderSide(
                                        color:
                                            PhilotesColors
                                                .gold
                                                .withValues(
                                          alpha: 0.65,
                                        ),
                                      ),
                                    ),
                                    focusedBorder:
                                        OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        12,
                                      ),
                                      borderSide:
                                          const BorderSide(
                                        color:
                                            PhilotesColors
                                                .gold,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 10),

                              SizedBox(
                                height: 56,
                                child:
                                    FilledButton(
                                  key: const Key(
                                    'confirmZipCodeButton',
                                  ),
                                  onPressed:
                                      _confirmZipCode,
                                  style:
                                      FilledButton
                                          .styleFrom(
                                    backgroundColor:
                                        PhilotesColors
                                            .navy,
                                    foregroundColor:
                                        Colors.white,
                                    shape:
                                        RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        12,
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    'Use ZIP',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],

                        if (_locationSource != null) ...[
                          const SizedBox(height: 16),

                          Container(
                            key: const Key(
                              'selectedLocationSummary',
                            ),
                            padding:
                                const EdgeInsets.all(13),
                            decoration:
                                BoxDecoration(
                              color:
                                  PhilotesColors.gold
                                      .withValues(
                                alpha: 0.10,
                              ),
                              borderRadius:
                                  BorderRadius.circular(
                                12,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons
                                      .check_circle_outline,
                                  color:
                                      PhilotesColors.gold,
                                  size: 21,
                                ),
                                const SizedBox(
                                  width: 9,
                                ),
                                Expanded(
                                  child: Text(
                                    _locationSource ==
                                            'device'
                                        ? 'Current device area selected'
                                        : 'ZIP ${_zipController.text.trim()} area selected',
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
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  _SectionCard(
                    icon: Icons.route_outlined,
                    title: 'Meeting Distance',
                    subtitle:
                        'How far are you comfortable traveling '
                        'to meet a friend?',
                    child: Column(
                      children: [
                        _DistanceChoice(
                          key: const Key(
                            'distance10',
                          ),
                          selected:
                              _meetingDistance ==
                                  '10',
                          title:
                              'Very close to me',
                          subtitle:
                              'Within about 10 miles',
                          onTap: () {
                            _selectDistance('10');
                          },
                        ),

                        const SizedBox(height: 9),

                        _DistanceChoice(
                          key: const Key(
                            'distance25',
                          ),
                          selected:
                              _meetingDistance ==
                                  '25',
                          title: 'Nearby',
                          subtitle:
                              'Within about 25 miles',
                          onTap: () {
                            _selectDistance('25');
                          },
                        ),

                        const SizedBox(height: 9),

                        _DistanceChoice(
                          key: const Key(
                            'distance50',
                          ),
                          selected:
                              _meetingDistance ==
                                  '50',
                          title:
                              'A little farther away',
                          subtitle:
                              'Within about 50 miles',
                          onTap: () {
                            _selectDistance('50');
                          },
                        ),

                        const SizedBox(height: 9),

                        _DistanceChoice(
                          key: const Key(
                            'distanceFarther',
                          ),
                          selected:
                              _meetingDistance ==
                                  'farther',
                          title:
                              'I\'m willing to travel farther',
                          subtitle:
                              'More than 50 miles',
                          onTap: () {
                            _selectDistance(
                              'farther',
                            );
                          },
                        ),

                        const SizedBox(height: 9),

                        _DistanceChoice(
                          key: const Key(
                            'distanceFlexible',
                          ),
                          selected:
                              _meetingDistance ==
                                  'flexible',
                          title:
                              'Distance isn\'t very important to me',
                          subtitle:
                              'Keep my discovery range flexible',
                          onTap: () {
                            _selectDistance(
                              'flexible',
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  Material(
                    color: Colors.white.withValues(
                      alpha: 0.55,
                    ),
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(16),
                      side: BorderSide(
                        color: PhilotesColors.gold
                            .withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.all(16),
                      child: CheckboxListTile(
                        key: const Key(
                          'onlineFriendshipsCheckbox',
                        ),
                        contentPadding:
                            EdgeInsets.zero,
                        value:
                            _onlineFriendships,
                        activeColor:
                            PhilotesColors.navy,
                        checkColor: Colors.white,
                        controlAffinity:
                            ListTileControlAffinity
                                .leading,
                        onChanged: (value) {
                          setState(() {
                            _onlineFriendships =
                                value ?? false;
                          });
                        },
                        title: const Text(
                          'I\'m also interested in online friendships.',
                          style: TextStyle(
                            color:
                                PhilotesColors.navy,
                            fontSize: 15,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),
                        subtitle: const Padding(
                          padding:
                              EdgeInsets.only(top: 6),
                          child: Text(
                            'Online friendships can expand '
                            'discovery beyond your local '
                            'meeting distance.',
                            style: TextStyle(
                              color:
                                  PhilotesColors
                                      .silver,
                              fontSize: 12,
                              height: 1.45,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: PhilotesColors.gold
                          .withValues(
                        alpha: 0.10,
                      ),
                      borderRadius:
                          BorderRadius.circular(14),
                      border: Border.all(
                        color: PhilotesColors.gold
                            .withValues(
                          alpha: 0.65,
                        ),
                      ),
                    ),
                    child: const Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.lock_outline,
                          color:
                              PhilotesColors.gold,
                          size: 22,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Your exact location is not shown '
                            'to other Philotes members. '
                            'Location is used to help estimate '
                            'distance for friendship discovery.',
                            style: TextStyle(
                              color:
                                  PhilotesColors.navy,
                              fontSize: 13,
                              fontWeight:
                                  FontWeight.w600,
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
                      key: const Key(
                        'locationDiscoveryContinueButton',
                      ),
                      onPressed: _continue,
                      style:
                          FilledButton.styleFrom(
                        backgroundColor:
                            PhilotesColors.navy,
                        foregroundColor:
                            Colors.white,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            14,
                          ),
                        ),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight:
                              FontWeight.w600,
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

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color:
            Colors.white.withValues(alpha: 0.55),
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color: PhilotesColors.gold
              .withValues(alpha: 0.6),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: PhilotesColors.navy,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        PhilotesColors.gold,
                    width: 1.7,
                  ),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 22,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color:
                            PhilotesColors.navy,
                        fontSize: 18,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      subtitle,
                      style: const TextStyle(
                        color:
                            PhilotesColors.silver,
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

class _LocationChoiceButton extends StatelessWidget {
  const _LocationChoiceButton({
    super.key,
    required this.selected,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? PhilotesColors.navy.withValues(
              alpha: 0.08,
            )
          : PhilotesColors.ivory.withValues(
              alpha: 0.55,
            ),
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(14),
        side: BorderSide(
          color: selected
              ? PhilotesColors.gold
              : PhilotesColors.gold
                  .withValues(alpha: 0.55),
          width: selected ? 1.7 : 1,
        ),
      ),
      child: InkWell(
        borderRadius:
            BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(
                icon,
                color: selected
                    ? PhilotesColors.gold
                    : PhilotesColors.navy,
                size: 25,
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color:
                            PhilotesColors.navy,
                        fontSize: 15,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color:
                            PhilotesColors.silver,
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),

              if (selected)
                const Icon(
                  Icons.check_circle,
                  color:
                      PhilotesColors.gold,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DistanceChoice extends StatelessWidget {
  const _DistanceChoice({
    super.key,
    required this.selected,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final bool selected;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? PhilotesColors.navy.withValues(
              alpha: 0.08,
            )
          : PhilotesColors.ivory.withValues(
              alpha: 0.50,
            ),
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(12),
        side: BorderSide(
          color: selected
              ? PhilotesColors.gold
              : PhilotesColors.gold
                  .withValues(alpha: 0.45),
          width: selected ? 1.6 : 1,
        ),
      ),
      child: InkWell(
        borderRadius:
            BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          child: Row(
            children: [
              Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons
                        .radio_button_unchecked,
                color: selected
                    ? PhilotesColors.gold
                    : PhilotesColors.silver,
                size: 21,
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color:
                            PhilotesColors.navy,
                        fontSize: 14,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color:
                            PhilotesColors.silver,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
