from pathlib import Path
from datetime import datetime
import re


SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = SCRIPT_DIR.parent.parent

APP_ROOT = (
    PROJECT_ROOT
    / "apps"
    / "philotes_app"
)

TEST_FILE = (
    APP_ROOT
    / "test"
    / "widget_test.dart"
)

REPORT_FILE = (
    SCRIPT_DIR
    / "developerpatchscript_report.txt"
)


def main() -> None:
    print()
    print("=" * 72)
    print(
        "PHILOTES PLANS LEGACY TEST REPAIR"
    )
    print("=" * 72)
    print()

    if not TEST_FILE.exists():
        print(
            "FAIL: widget_test.dart "
            "was not found."
        )
        raise SystemExit(1)

    original = TEST_FILE.read_text(
        encoding="utf-8",
    )

    pattern = re.compile(
        r"""
        testWidgets\(
        \s*
        'Plans\ navigation\ works'
        \s*,
        .*?
        \n\s*\}\s*,\s*\n\s*\);
        """,
        re.VERBOSE | re.DOTALL,
    )

    replacement = r"""testWidgets(
    'Plans navigation works',
    (WidgetTester tester) async {
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
            'navPlans',
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.byKey(
          const Key(
            'plansScreen',
          ),
        ),
        findsOneWidget,
      );

      expect(
        find.text(
          'Today',
        ),
        findsOneWidget,
      );

      expect(
        find.text(
          'Upcoming',
        ),
        findsOneWidget,
      );

      expect(
        find.text(
          'Recent Past',
        ),
        findsOneWidget,
      );
    },
  );"""

    updated, count = pattern.subn(
        replacement,
        original,
        count=1,
    )

    if count != 1:
        print(
            "FAIL: Could not safely locate "
            "the old Plans navigation test."
        )
        print(
            "No changes were written."
        )
        raise SystemExit(1)

    TEST_FILE.write_text(
        updated,
        encoding="utf-8",
    )

    final_text = TEST_FILE.read_text(
        encoding="utf-8",
    )

    checks = {
        "Old Plans placeholder assertion removed":
            "organize future activities"
            not in final_text,

        "Plans screen key is tested":
            "plansScreen"
            in final_text,

        "Today section is tested":
            "find.text(\n          'Today'"
            in final_text,

        "Upcoming section is tested":
            "'Upcoming'"
            in final_text,

        "Recent Past section is tested":
            "'Recent Past'"
            in final_text,

        "Plans navigation key retained":
            "navPlans"
            in final_text,
    }

    all_passed = True

    report_lines = [
        "PHILOTES PLANS LEGACY TEST REPAIR REPORT",
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
            "This repair:",
            "- Updates only the stale Plans navigation test.",
            "- Does not modify Plans UI code.",
            "- Does not modify Plan Detail.",
            "- Does not modify Home.",
            "- Does not modify Discover.",
            "- Does not modify onboarding.",
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
        TEST_FILE.write_text(
            original,
            encoding="utf-8",
        )

        print()
        print(
            "widget_test.dart restored "
            "because verification failed."
        )

        raise SystemExit(1)


if __name__ == "__main__":
    main()