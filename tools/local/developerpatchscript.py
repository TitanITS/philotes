from pathlib import Path
from datetime import datetime


SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = SCRIPT_DIR.parent.parent

APP_ROOT = PROJECT_ROOT / "apps" / "philotes_app"
LIB_ROOT = APP_ROOT / "lib"
TEST_ROOT = APP_ROOT / "test"

PAGE_8 = (
    LIB_ROOT
    / "screens"
    / "onboarding"
    / "friendship_preferences_screen.dart"
)

MODEL_FILE = (
    LIB_ROOT
    / "models"
    / "onboarding_profile_data.dart"
)

PAGE_12 = (
    LIB_ROOT
    / "screens"
    / "onboarding"
    / "review_profile_screen.dart"
)

DEV_FIXTURE = (
    LIB_ROOT
    / "data"
    / "development"
    / "development_member_fixture.dart"
)

TEST_FILE = (
    TEST_ROOT
    / "social_pace_test.dart"
)

REPORT_PATH = (
    SCRIPT_DIR
    / "developerpatchscript_report.txt"
)

NEW_SOCIAL_PACE = "Whenever we're both available"


TEST_CONTENT = r"""import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:philotes/models/onboarding_profile_data.dart';
import 'package:philotes/screens/onboarding/friendship_preferences_screen.dart';
import 'package:philotes/screens/onboarding/review_profile_screen.dart';

void main() {
  setUp(() {
    OnboardingProfileData.instance.reset();
  });

  testWidgets(
    'Social Pace contains mutual availability option',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FriendshipPreferencesScreen(),
        ),
      );

      final field = find.byKey(
        const Key('socialFrequencyField'),
      );

      expect(field, findsOneWidget);

      await tester.ensureVisible(field);
      await tester.tap(field);
      await tester.pumpAndSettle();

      expect(
        find.text("Whenever we're both available"),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Flexible Social Pace explains mutual availability',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FriendshipPreferencesScreen(),
        ),
      );

      final field = find.byKey(
        const Key('socialFrequencyField'),
      );

      await tester.ensureVisible(field);
      await tester.tap(field);
      await tester.pumpAndSettle();

      await tester.tap(
        find.text(
          "Whenever we're both available",
        ).last,
      );

      await tester.pumpAndSettle();

      expect(
        find.byKey(
          const Key(
            'flexibleSocialPaceExplanation',
          ),
        ),
        findsOneWidget,
      );

      expect(
        find.textContaining(
          "I'm flexible. If we're both free",
        ),
        findsOneWidget,
      );

      expect(
        find.textContaining(
          "open to making plans",
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Social Pace helper is hidden for other selections',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FriendshipPreferencesScreen(),
        ),
      );

      final field = find.byKey(
        const Key('socialFrequencyField'),
      );

      await tester.ensureVisible(field);
      await tester.tap(field);
      await tester.pumpAndSettle();

      await tester.tap(
        find.text(
          'About once a week',
        ).last,
      );

      await tester.pumpAndSettle();

      expect(
        find.byKey(
          const Key(
            'flexibleSocialPaceExplanation',
          ),
        ),
        findsNothing,
      );
    },
  );

  testWidgets(
    'Review Profile displays flexible Social Pace',
    (WidgetTester tester) async {
      final profile =
          OnboardingProfileData.instance;

      profile.socialFrequency =
          "Whenever we're both available";

      await tester.pumpWidget(
        const MaterialApp(
          home: ReviewProfileScreen(),
        ),
      );

      await tester.pumpAndSettle();

      final socialPace = find.text(
        "Whenever we're both available",
      );

      await tester.scrollUntilVisible(
        socialPace,
        300,
        scrollable: find.byType(
          Scrollable,
        ).first,
      );

      expect(
        socialPace,
        findsOneWidget,
      );
    },
  );
}
"""


def read_text(path: Path) -> str:
    if not path.exists():
        raise RuntimeError(
            f"Required file not found: {path}"
        )

    return path.read_text(
        encoding="utf-8",
    )


def write_text(
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


def ensure_page_8_patch() -> None:
    text = read_text(PAGE_8)

    # Add the dropdown option only if it is missing.
    if NEW_SOCIAL_PACE not in text:
        anchor = """                            DropdownMenuItem(
                              value:
                                  'No strong preference',
                              child: Text(
                                'No strong preference',
                              ),
                            ),"""

        replacement = """                            DropdownMenuItem(
                              value:
                                  "Whenever we're both available",
                              child: Text(
                                "Whenever we're both available",
                              ),
                            ),
                            DropdownMenuItem(
                              value:
                                  'No strong preference',
                              child: Text(
                                'No strong preference',
                              ),
                            ),"""

        if anchor not in text:
            raise RuntimeError(
                "Could not locate the Social Pace "
                "'No strong preference' option."
            )

        text = text.replace(
            anchor,
            replacement,
            1,
        )

    # Add helper block only if it is missing.
    if "flexibleSocialPaceExplanation" not in text:
        anchor = """                          onChanged: (value) {
                            setState(() {
                              _socialFrequency = value;

                              if (_requiredFieldsValid) {
                                _showValidation = false;
                              }
                            });
                          },
                        ),

                        const SizedBox(height: 20),"""

        replacement = """                          onChanged: (value) {
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
                            key: const Key(
                              'flexibleSocialPaceExplanation',
                            ),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: PhilotesColors.gold.withValues(
                                alpha: 0.10,
                              ),
                              borderRadius:
                                  BorderRadius.circular(10),
                              border: Border.all(
                                color:
                                    PhilotesColors.gold.withValues(
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

                        const SizedBox(height: 20),"""

        if anchor not in text:
            raise RuntimeError(
                "Could not safely locate the end "
                "of the Social Pace dropdown."
            )

        text = text.replace(
            anchor,
            replacement,
            1,
        )

    write_text(
        PAGE_8,
        text,
    )


def ensure_development_fixture() -> None:
    text = read_text(DEV_FIXTURE)

    if NEW_SOCIAL_PACE in text:
        return

    old = """    profile.socialFrequency ??=
        'A few times a month';"""

    new = """    profile.socialFrequency ??=
        "Whenever we're both available";"""

    if old not in text:
        raise RuntimeError(
            "Could not locate development "
            "Social Pace default."
        )

    text = text.replace(
        old,
        new,
        1,
    )

    write_text(
        DEV_FIXTURE,
        text,
    )


def main() -> None:
    print()
    print("=" * 76)
    print(
        "PHILOTES PAGE 8 - "
        "FLEXIBLE SOCIAL PACE SAFE REPAIR"
    )
    print("=" * 76)
    print()

    try:
        model_text = read_text(
            MODEL_FILE,
        )

        review_text = read_text(
            PAGE_12,
        )

        if "String? socialFrequency;" not in model_text:
            raise RuntimeError(
                "Shared model socialFrequency "
                "field was not found."
            )

        if "socialFrequency = null;" not in model_text:
            raise RuntimeError(
                "Shared model Social Pace reset "
                "was not found."
            )

        if "profile.socialFrequency" not in review_text:
            raise RuntimeError(
                "Page 12 Social Pace display "
                "was not found."
            )

        ensure_page_8_patch()
        ensure_development_fixture()

        write_text(
            TEST_FILE,
            TEST_CONTENT,
        )

    except Exception as exc:
        print(
            f"FAIL: {exc}"
        )
        raise SystemExit(1)

    page_8_text = read_text(
        PAGE_8,
    )

    model_text = read_text(
        MODEL_FILE,
    )

    page_12_text = read_text(
        PAGE_12,
    )

    fixture_text = read_text(
        DEV_FIXTURE,
    )

    test_text = read_text(
        TEST_FILE,
    )

    checks = {
        "Flexible Social Pace option present":
            NEW_SOCIAL_PACE
            in page_8_text,

        "Flexible helper widget present":
            "flexibleSocialPaceExplanation"
            in page_8_text,

        "Helper opening wording present":
            "I'm flexible. If we're both free "
            in page_8_text,

        "Helper planning wording present":
            "open "
            in page_8_text
            and "to making plans."
            in page_8_text,

        "Several-times-a-week option preserved":
            "Several times a week"
            in page_8_text,

        "Once-a-week option preserved":
            "About once a week"
            in page_8_text,

        "Few-times-a-month option preserved":
            "A few times a month"
            in page_8_text,

        "Occasionally option preserved":
            "'Occasionally'"
            in page_8_text,

        "No-strong-preference option preserved":
            "No strong preference"
            in page_8_text,

        "Shared model Social Pace field preserved":
            "String? socialFrequency;"
            in model_text,

        "Shared model Social Pace reset preserved":
            "socialFrequency = null;"
            in model_text,

        "Page 12 Social Pace review preserved":
            "profile.socialFrequency"
            in page_12_text,

        "Page 12 Social pace label preserved":
            "'Social pace'"
            in page_12_text,

        "Development fixture uses flexible pace":
            NEW_SOCIAL_PACE
            in fixture_text,

        "Dedicated Social Pace test exists":
            TEST_FILE.exists(),

        "Flexible option test present":
            "mutual availability option"
            in test_text,

        "Helper explanation test present":
            "explains mutual availability"
            in test_text,

        "Page 12 review test present":
            "Review Profile displays flexible Social Pace"
            in test_text,
    }

    all_passed = True

    report = [
        "PHILOTES PAGE 8 - "
        "FLEXIBLE SOCIAL PACE SAFE REPAIR REPORT",
        "=" * 76,
        "Generated: "
        + datetime.now().isoformat(
            timespec="seconds",
        ),
        f"Project root: {PROJECT_ROOT}",
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

        report.append(
            f"{status}: {description}"
        )

        if not passed:
            all_passed = False

    report.extend(
        [
            "",
            "OVERALL: "
            + (
                "PASS"
                if all_passed
                else "FAIL"
            ),
            "",
            "This repair:",
            "- Is safe to run after the previous patch.",
            "- Does not duplicate the new Social Pace option.",
            "- Does not duplicate the helper box.",
            "- Fixes the checker so split Dart strings are valid.",
            "- Preserves all existing Social Pace choices.",
            "- Preserves Page 12 review behavior.",
            "- Preserves the shared onboarding model.",
            "- Preserves Home v1.",
            "- Keeps compatibility scoring for Home v2.",
        ]
    )

    write_text(
        REPORT_PATH,
        "\n".join(report) + "\n",
    )

    print()
    print(
        f"Report: {REPORT_PATH}"
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
        raise SystemExit(1)


if __name__ == "__main__":
    main()