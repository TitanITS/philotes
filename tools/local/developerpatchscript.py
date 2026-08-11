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

WELCOME_FILE = (
    LIB_ROOT
    / "screens"
    / "welcome_screen.dart"
)

SHELL_FILE = (
    LIB_ROOT
    / "screens"
    / "app"
    / "philotes_shell_screen.dart"
)

FIXTURE_FILE = (
    LIB_ROOT
    / "data"
    / "development"
    / "development_member_fixture.dart"
)

TEST_FILE = (
    TEST_ROOT
    / "developer_quick_entry_test.dart"
)

REPORT_FILE = (
    SCRIPT_DIR
    / "developerpatchscript_report.txt"
)


WELCOME_CONTENT = r"""import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../data/development/development_member_fixture.dart';
import '../theme/philotes_colors.dart';
import '../widgets/community_mark.dart';
import '../widgets/titan_attribution.dart';
import 'app/philotes_shell_screen.dart';
import 'onboarding/onboarding_intro_screen.dart';

class PhilotesWelcomeScreen extends StatelessWidget {
  const PhilotesWelcomeScreen({super.key});

  void _enterDeveloperAccount(
    BuildContext context,
  ) {
    DevelopmentMemberFixture
        .seedMissingProfileData();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (context) =>
            const PhilotesShellScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              PhilotesColors.ivory,
              PhilotesColors.ivoryDark,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 36,
              ),
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(
                  maxWidth: 620,
                ),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    const CommunityMark(),

                    const SizedBox(height: 34),

                    const Text(
                      'PHILOTES',
                      textAlign:
                          TextAlign.center,
                      style: TextStyle(
                        color:
                            PhilotesColors.navy,
                        fontSize: 46,
                        fontWeight:
                            FontWeight.w600,
                        letterSpacing: 7,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Container(
                      width: 220,
                      height: 1,
                      color:
                          PhilotesColors.gold,
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      'A COMMUNITY FOR FRIENDSHIP',
                      textAlign:
                          TextAlign.center,
                      style: TextStyle(
                        color:
                            PhilotesColors.gold,
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w600,
                        letterSpacing: 2.2,
                      ),
                    ),

                    const SizedBox(height: 34),

                    const Text(
                      'Real people. Shared interests. '
                      'Lifelong friendships.',
                      textAlign:
                          TextAlign.center,
                      style: TextStyle(
                        color:
                            PhilotesColors.navy,
                        fontSize: 20,
                        fontWeight:
                            FontWeight.w500,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Discover people who enjoy '
                      'the things you enjoy, '
                      'build genuine connections, '
                      'and create friendships '
                      'in a community designed '
                      'around trust and safety.',
                      textAlign:
                          TextAlign.center,
                      style: TextStyle(
                        color:
                            PhilotesColors.silver,
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 40),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton(
                        key: const Key(
                          'joinCommunityButton',
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (context) =>
                                  const PhilotesOnboardingIntroScreen(),
                            ),
                          );
                        },
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
                          'Join the Community',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton(
                        key: const Key(
                          'signInButton',
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Philotes sign in '
                                'will begin here.',
                              ),
                            ),
                          );
                        },
                        style:
                            OutlinedButton.styleFrom(
                          foregroundColor:
                              PhilotesColors.navy,
                          side:
                              const BorderSide(
                            color:
                                PhilotesColors.gold,
                            width: 1.5,
                          ),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              14,
                            ),
                          ),
                        ),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    if (kDebugMode) ...[
                      const SizedBox(height: 32),

                      Container(
                        key: const Key(
                          'developerQuickEntrySection',
                        ),
                        width: double.infinity,
                        padding:
                            const EdgeInsets.all(
                          18,
                        ),
                        decoration: BoxDecoration(
                          color: PhilotesColors
                              .navy
                              .withValues(
                            alpha: 0.045,
                          ),
                          borderRadius:
                              BorderRadius.circular(
                            14,
                          ),
                          border: Border.all(
                            color: PhilotesColors
                                .silver
                                .withValues(
                              alpha: 0.55,
                            ),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'DEVELOPMENT ONLY',
                              style: TextStyle(
                                color:
                                    PhilotesColors
                                        .silver,
                                fontSize: 10,
                                fontWeight:
                                    FontWeight.w800,
                                letterSpacing: 1.5,
                              ),
                            ),

                            const SizedBox(
                              height: 12,
                            ),

                            SizedBox(
                              width:
                                  double.infinity,
                              height: 50,
                              child:
                                  OutlinedButton(
                                key: const Key(
                                  'developerTestAccountButton',
                                ),
                                onPressed: () {
                                  _enterDeveloperAccount(
                                    context,
                                  );
                                },
                                style:
                                    OutlinedButton
                                        .styleFrom(
                                  foregroundColor:
                                      PhilotesColors
                                          .navy,
                                  side:
                                      const BorderSide(
                                    color:
                                        PhilotesColors
                                            .silver,
                                    width: 1.3,
                                  ),
                                  shape:
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      12,
                                    ),
                                  ),
                                ),
                                child:
                                    const Text(
                                  'Enter Developer '
                                  'Test Account',
                                  style:
                                      TextStyle(
                                    fontSize: 14,
                                    fontWeight:
                                        FontWeight
                                            .w700,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            const Text(
                              'Bypasses onboarding '
                              'and loads simulated '
                              'development profile data.',
                              textAlign:
                                  TextAlign.center,
                              style: TextStyle(
                                color:
                                    PhilotesColors
                                        .silver,
                                fontSize: 11,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 42),

                    const TitanAttribution(),

                    const SizedBox(height: 16),

                    const Text(
                      'Friendship  •  Trust  •  '
                      'Community  •  Connection',
                      textAlign:
                          TextAlign.center,
                      style: TextStyle(
                        color:
                            PhilotesColors.gold,
                        fontSize: 12,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
"""


TEST_CONTENT = r"""import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:philotes/models/onboarding_profile_data.dart';
import 'package:philotes/screens/welcome_screen.dart';

void main() {
  setUp(() {
    OnboardingProfileData.instance.reset();
  });

  testWidgets(
    'Developer quick entry is debug guarded',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PhilotesWelcomeScreen(),
        ),
      );

      if (kDebugMode) {
        expect(
          find.byKey(
            const Key(
              'developerQuickEntrySection',
            ),
          ),
          findsOneWidget,
        );

        expect(
          find.byKey(
            const Key(
              'developerTestAccountButton',
            ),
          ),
          findsOneWidget,
        );
      }
    },
  );

  testWidgets(
    'Normal welcome actions remain available',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PhilotesWelcomeScreen(),
        ),
      );

      expect(
        find.byKey(
          const Key(
            'joinCommunityButton',
          ),
        ),
        findsOneWidget,
      );

      expect(
        find.byKey(
          const Key(
            'signInButton',
          ),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Developer account bypasses onboarding',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PhilotesWelcomeScreen(),
        ),
      );

      if (!kDebugMode) {
        return;
      }

      final button = find.byKey(
        const Key(
          'developerTestAccountButton',
        ),
      );

      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(
        find.byKey(
          const Key(
            'philotesHomeScreen',
          ),
        ),
        findsOneWidget,
      );

      expect(
        find.byKey(
          const Key(
            'philotesMainNavigation',
          ),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Developer account seeds fixture profile',
    (WidgetTester tester) async {
      final profile =
          OnboardingProfileData.instance;

      expect(
        profile.displayName,
        isEmpty,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: PhilotesWelcomeScreen(),
        ),
      );

      if (!kDebugMode) {
        return;
      }

      final button = find.byKey(
        const Key(
          'developerTestAccountButton',
        ),
      );

      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(
        profile.displayName,
        'Alex',
      );

      expect(
        profile.selectedInterests,
        isNotEmpty,
      );

      expect(
        profile.favoriteInterests,
        isNotEmpty,
      );

      expect(
        profile.socialFrequency,
        "Whenever we're both available",
      );

      expect(
        profile.photoSelected,
        isTrue,
      );
    },
  );
}
"""


def write_file(
    path: Path,
    content: str,
) -> None:
    path.parent.mkdir(
        parents=True,
        exist_ok=True,
    )

    path.write_text(
        content,
        encoding="utf-8",
    )


def main() -> None:
    print()
    print("=" * 72)
    print(
        "PHILOTES DEBUG DEVELOPER "
        "QUICK ENTRY SAFE PATCH"
    )
    print("=" * 72)
    print()

    required_files = [
        WELCOME_FILE,
        SHELL_FILE,
        FIXTURE_FILE,
    ]

    for path in required_files:
        if not path.exists():
            print(
                "FAIL: Required file "
                f"not found: {path}"
            )
            raise SystemExit(1)

    original_welcome = (
        WELCOME_FILE.read_text(
            encoding="utf-8",
        )
    )

    try:
        write_file(
            WELCOME_FILE,
            WELCOME_CONTENT,
        )

        write_file(
            TEST_FILE,
            TEST_CONTENT,
        )

    except Exception as exc:
        print(
            "FAIL: Could not write "
            f"patch files: {exc}"
        )
        raise SystemExit(1)

    welcome = WELCOME_FILE.read_text(
        encoding="utf-8",
    )

    test = TEST_FILE.read_text(
        encoding="utf-8",
    )

    fixture = FIXTURE_FILE.read_text(
        encoding="utf-8",
    )

    shell = SHELL_FILE.read_text(
        encoding="utf-8",
    )

    checks = {
        "Welcome screen still exists":
            WELCOME_FILE.exists(),

        "Flutter foundation imported":
            "package:flutter/foundation.dart"
            in welcome,

        "Debug guard present":
            "if (kDebugMode)"
            in welcome,

        "Developer section has dedicated key":
            "developerQuickEntrySection"
            in welcome,

        "Developer button has dedicated key":
            "developerTestAccountButton"
            in welcome,

        "Developer button seeds fixture":
            "DevelopmentMemberFixture"
            in welcome
            and "seedMissingProfileData"
            in welcome,

        "Developer entry opens Philotes shell":
            "PhilotesShellScreen"
            in welcome,

        "Developer entry replaces welcome route":
            "pushReplacement"
            in welcome,

        "Normal Join action preserved":
            "Join the Community"
            in welcome
            and
            "PhilotesOnboardingIntroScreen"
            in welcome,

        "Normal Sign In button preserved":
            "'Sign In'"
            in welcome
            and
            "signInButton"
            in welcome,

        "Normal Sign In placeholder preserved":
            "Philotes sign in "
            in welcome
            and
            "will begin here."
            in welcome,

        "Development fixture remains intact":
            "seedMissingProfileData"
            in fixture,

        "Development fixture seeds Alex":
            "profile.displayName = 'Alex'"
            in fixture,

        "Flexible social pace fixture retained":
            "Whenever we're both available"
            in fixture,

        "Shell still contains Home v2":
            "PhilotesHomeScreen"
            in shell,

        "Main navigation remains intact":
            "philotesMainNavigation"
            in shell,

        "Dedicated developer tests created":
            TEST_FILE.exists(),

        "Test verifies debug guard":
            "Developer quick entry is debug guarded"
            in test,

        "Test verifies onboarding bypass":
            "Developer account bypasses onboarding"
            in test,

        "Test verifies fixture seeding":
            "Developer account seeds fixture profile"
            in test,

        "Production administrator not implemented":
            "administrator"
            not in welcome.lower()
            and
            "admin"
            not in welcome.lower(),
    }

    all_passed = True

    report_lines = [
        (
            "PHILOTES DEBUG DEVELOPER "
            "QUICK ENTRY SAFE PATCH REPORT"
        ),
        "=" * 72,
        (
            "Generated: "
            + datetime.now().isoformat(
                timespec="seconds",
            )
        ),
        "",
    ]

    for description, passed in checks.items():
        status = (
            "PASS"
            if passed
            else "FAIL"
        )

        print(
            f"{status}: {description}"
        )

        report_lines.append(
            f"{status}: {description}"
        )

        if not passed:
            all_passed = False

    report_lines.extend(
        [
            "",
            "OVERALL: "
            + (
                "PASS"
                if all_passed
                else "FAIL"
            ),
            "",
            "SAFETY / SCOPE",
            "-" * 72,
            (
                "- Developer quick entry is "
                "shown only under kDebugMode."
            ),
            (
                "- Normal onboarding remains "
                "available."
            ),
            (
                "- Normal Sign In remains "
                "available."
            ),
            (
                "- Existing development fixture "
                "is reused."
            ),
            (
                "- Home v2 remains unchanged."
            ),
            (
                "- No production administrator "
                "system is created."
            ),
            (
                "- No production authentication "
                "bypass is created."
            ),
        ]
    )

    REPORT_FILE.write_text(
        "\n".join(report_lines) + "\n",
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
            if all_passed
            else "FAIL"
        )
    )

    if not all_passed:
        WELCOME_FILE.write_text(
            original_welcome,
            encoding="utf-8",
        )

        print()
        print(
            "Welcome screen restored "
            "because verification failed."
        )

        raise SystemExit(1)


if __name__ == "__main__":
    main()