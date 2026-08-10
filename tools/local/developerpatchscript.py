from pathlib import Path
from datetime import datetime
from shutil import copy2

SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = SCRIPT_DIR.parent.parent

MASTER_LOGO = PROJECT_ROOT / "assets" / "branding" / "titan-logo.png"

APP_ROOT = PROJECT_ROOT / "apps" / "philotes_app"
APP_ASSET_DIR = APP_ROOT / "assets" / "branding"
APP_LOGO = APP_ASSET_DIR / "titan-logo.png"

PUBSPEC = APP_ROOT / "pubspec.yaml"
MAIN_DART = APP_ROOT / "lib" / "main.dart"

REPORT_PATH = SCRIPT_DIR / "developerpatchscript_report.txt"


OLD_FOOTER = """                    const Text(
                      'BROUGHT TO YOU BY TITAN',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: philotesNavy,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 3,
                      ),
                    ),
"""

NEW_FOOTER = """                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/branding/titan-logo.png',
                          height: 28,
                          width: 28,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 9),
                        const Text(
                          'BROUGHT TO YOU BY TITAN',
                          style: TextStyle(
                            color: philotesNavy,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 3,
                          ),
                        ),
                      ],
                    ),
"""


def fail(message: str) -> None:
    print(f"FAIL: {message}")
    raise SystemExit(1)


def main() -> None:
    print()
    print("=" * 70)
    print("PHILOTES TITAN FOOTER BRANDING PATCH")
    print("=" * 70)
    print()

    if not MASTER_LOGO.exists():
        fail(f"Master Titan logo not found: {MASTER_LOGO}")

    if not PUBSPEC.exists():
        fail(f"pubspec.yaml not found: {PUBSPEC}")

    if not MAIN_DART.exists():
        fail(f"main.dart not found: {MAIN_DART}")

    # ------------------------------------------------------------
    # Copy the master Titan logo into the Flutter application.
    # The repository-level master remains unchanged.
    # ------------------------------------------------------------

    APP_ASSET_DIR.mkdir(parents=True, exist_ok=True)
    copy2(MASTER_LOGO, APP_LOGO)

    # ------------------------------------------------------------
    # Register the image as a Flutter asset.
    # ------------------------------------------------------------

    pubspec_text = PUBSPEC.read_text(encoding="utf-8")

    asset_entry = "    - assets/branding/titan-logo.png"

    if asset_entry not in pubspec_text:
        anchor = "  uses-material-design: true"

        if anchor not in pubspec_text:
            fail("Could not find uses-material-design entry in pubspec.yaml")

        pubspec_text = pubspec_text.replace(
            anchor,
            anchor
            + "\n"
            + "  assets:\n"
            + "    - assets/branding/titan-logo.png",
            1,
        )

        PUBSPEC.write_text(pubspec_text, encoding="utf-8")

    # ------------------------------------------------------------
    # Replace the text-only Titan footer with:
    #
    # [small Titan logo] BROUGHT TO YOU BY TITAN
    # ------------------------------------------------------------

    main_text = MAIN_DART.read_text(encoding="utf-8")

    if NEW_FOOTER not in main_text:
        if OLD_FOOTER not in main_text:
            fail("Expected Titan footer block was not found in main.dart")

        main_text = main_text.replace(
            OLD_FOOTER,
            NEW_FOOTER,
            1,
        )

        MAIN_DART.write_text(main_text, encoding="utf-8")

    # ------------------------------------------------------------
    # Verification
    # ------------------------------------------------------------

    pubspec_verify = PUBSPEC.read_text(encoding="utf-8")
    main_verify = MAIN_DART.read_text(encoding="utf-8")

    checks = {
        "Master Titan logo exists":
            MASTER_LOGO.exists(),

        "Flutter Titan logo copy exists":
            APP_LOGO.exists(),

        "Titan logo registered in pubspec.yaml":
            "assets/branding/titan-logo.png" in pubspec_verify,

        "Titan logo used by main.dart":
            "Image.asset(" in main_verify
            and "assets/branding/titan-logo.png" in main_verify,

        "Titan attribution remains present":
            "BROUGHT TO YOU BY TITAN" in main_verify,
    }

    report = [
        "PHILOTES TITAN FOOTER BRANDING PATCH REPORT",
        "=" * 70,
        f"Generated: {datetime.now().isoformat(timespec='seconds')}",
        f"Project root: {PROJECT_ROOT}",
        f"Master logo: {MASTER_LOGO}",
        f"Flutter logo: {APP_LOGO}",
        "",
    ]

    all_passed = True

    for description, passed in checks.items():
        status = "PASS" if passed else "FAIL"
        print(f"{status}: {description}")
        report.append(f"{status}: {description}")

        if not passed:
            all_passed = False

    report.extend(
        [
            "",
            f"OVERALL: {'PASS' if all_passed else 'FAIL'}",
            "",
            "The repository-level Titan logo was not modified.",
            "The Flutter application uses its own copied branding asset.",
            "The Titan mark is displayed before BROUGHT TO YOU BY TITAN.",
        ]
    )

    REPORT_PATH.write_text(
        "\n".join(report) + "\n",
        encoding="utf-8",
    )

    print()
    print(f"Report: {REPORT_PATH}")
    print()
    print(f"OVERALL: {'PASS' if all_passed else 'FAIL'}")

    if not all_passed:
        raise SystemExit(1)


if __name__ == "__main__":
    main()