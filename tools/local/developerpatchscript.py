from pathlib import Path
from datetime import datetime
import re


SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = SCRIPT_DIR.parent.parent

APP_ROOT = PROJECT_ROOT / "apps" / "philotes_app"
TEST_FILE = APP_ROOT / "test" / "widget_test.dart"

REPORT_FILE = (
    SCRIPT_DIR
    / "developerpatchscript_report.txt"
)


def main() -> None:
    print()
    print("=" * 72)
    print(
        "PHILOTES DISCOVER LEGACY TEST REPAIR"
    )
    print("=" * 72)
    print()

    if not TEST_FILE.exists():
        print(
            f"FAIL: Test file not found: {TEST_FILE}"
        )
        raise SystemExit(1)

    text = TEST_FILE.read_text(
        encoding="utf-8",
    )

    pattern = re.compile(
        r"""
        testWidgets\(
        \s*
        'Discover\ navigation\ works'
        \s*,
        .*?
        \n\s*\}\s*,\s*\n\s*\);
        """,
        re.VERBOSE | re.DOTALL,
    )

    replacement = r"""testWidgets(
    'Discover navigation works',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home:
              PhilotesShellScreen(),
        ),
      );

      final discover =
          find.byKey(
        const Key(
          'navDiscover',
        ),
      );

      await tester.tap(discover);
      await tester.pumpAndSettle();

      expect(
        find.byKey(
          const Key(
            'discoverScreen',
          ),
        ),
        findsOneWidget,
      );

      expect(
        find.text(
          'People To Discover',
        ),
        findsOneWidget,
      );
    },
  );"""

    new_text, count = pattern.subn(
        replacement,
        text,
        count=1,
    )

    if count != 1:
        print(
            "FAIL: Could not safely locate "
            "the old Discover navigation test."
        )
        raise SystemExit(1)

    TEST_FILE.write_text(
        new_text,
        encoding="utf-8",
    )

    updated = TEST_FILE.read_text(
        encoding="utf-8",
    )

    checks = {
        "Legacy Discover test replaced":
            "friendship preferences"
            not in updated,

        "Discover screen key tested":
            "discoverScreen"
            in updated,

        "People To Discover tested":
            "People To Discover"
            in updated,

        "Discover navigation key retained":
            "navDiscover"
            in updated,
    }

    all_passed = True

    report = [
        "PHILOTES DISCOVER LEGACY TEST REPAIR REPORT",
        "=" * 72,
        "Generated: "
        + datetime.now().isoformat(
            timespec="seconds",
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
            "- Updates only the stale Discover navigation test.",
            "- Does not modify Discover UI code.",
            "- Does not modify Home v2.",
            "- Does not modify onboarding.",
            "- Does not modify compatibility data.",
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
            if all_passed
            else "FAIL"
        )
    )

    if not all_passed:
        raise SystemExit(1)


if __name__ == "__main__":
    main()