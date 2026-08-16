from __future__ import annotations

from datetime import datetime
from pathlib import Path


SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = SCRIPT_DIR.parent.parent
REPORT_FILE = SCRIPT_DIR / "philotespatch_report.txt"

PATCH_ID = "NO-ACTIVE-PATCH"
PATCH_NAME = "Philotes Master Patch System - Safe Idle State"


def main() -> None:
    print()
    print("=" * 76)
    print("PHILOTES MASTER PATCH SYSTEM")
    print("=" * 76)
    print(f"PATCH ID   : {PATCH_ID}")
    print(f"PATCH NAME : {PATCH_NAME}")
    print("MODE       : SAFE IDLE - NO SOURCE FILES WILL BE MODIFIED")
    print("=" * 76)
    print()

    required_paths = {
        "Repository root": PROJECT_ROOT,
        "Frontend root": PROJECT_ROOT / "apps" / "philotes_app",
        "Backend root": PROJECT_ROOT / "backend",
    }

    all_ok = True
    report_lines = [
        "PHILOTES MASTER PATCH SYSTEM REPORT",
        "=" * 76,
        f"Generated: {datetime.now().isoformat(timespec='seconds')}",
        f"Patch ID: {PATCH_ID}",
        f"Patch Name: {PATCH_NAME}",
        "Mode: SAFE IDLE",
        "",
    ]

    for description, path in required_paths.items():
        ok = path.exists()
        all_ok = all_ok and ok
        status = "PASS" if ok else "FAIL"
        print(f"{status}: {description}")
        report_lines.append(f"{status}: {description}: {path}")

    report_lines.extend(
        [
            "",
            "OVERALL: " + ("PASS" if all_ok else "FAIL"),
            "",
            "MASTER PATCH POLICY",
            "-" * 76,
            "- philotespatch.cmd is the only patch launcher.",
            "- philotespatch.py is the only patch implementation file.",
            "- Patch scripts modify files only when an explicit patch is loaded.",
            "- Patch scripts do not run Flutter tests.",
            "- Patch scripts do not run backend tests.",
            "- Patch scripts do not run Git commands.",
            "- Patch scripts do not start servers or applications.",
            "- Validation is always run manually after patching.",
            "- The safe idle state makes no application source changes.",
        ]
    )

    REPORT_FILE.write_text(
        "\n".join(report_lines) + "\n",
        encoding="utf-8",
    )

    print()
    print("No active patch is loaded.")
    print("No application source files were modified.")
    print(f"Report: {REPORT_FILE}")

    if not all_ok:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
