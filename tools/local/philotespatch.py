from __future__ import annotations

from datetime import datetime
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = SCRIPT_DIR.parent.parent
BACKEND_ROOT = PROJECT_ROOT / "backend"

AUTH_FILE = BACKEND_ROOT / "app" / "api" / "routes" / "auth.py"
SERVICE_FILE = BACKEND_ROOT / "app" / "services" / "password_reset_service.py"
PAGES_FILE = BACKEND_ROOT / "app" / "presentation" / "security_pages.py"
RESET_TEST_FILE = BACKEND_ROOT / "tests" / "test_password_reset.py"
PAGE_TEST_FILE = BACKEND_ROOT / "tests" / "test_security_pages.py"
REPORT_FILE = SCRIPT_DIR / "philotespatch_report.txt"

PATCH_ID = "PASSWORD-RESET-HARDENING-V14"
PATCH_NAME = "Password reset hardening, branding, and visibility controls"

SERVICE_ANCHOR = '    def reset_password(\n        self,\n        *,\n        raw_token: str,\n        new_password: str,\n    ) -> User:\n        now = datetime.now(timezone.utc)\n        token = self.tokens.get_by_hash(\n            hash_password_reset_token(raw_token)\n        )\n\n        if (\n            token is None\n            or token.used_at is not None\n            or token.invalidated_at is not None\n            or token.expires_at <= now\n        ):\n            raise InvalidPasswordResetTokenError\n'
SERVICE_REPL = '    def validate_reset_token(self, raw_token: str) -> User:\n        now = datetime.now(timezone.utc)\n        token = self.tokens.get_by_hash(\n            hash_password_reset_token(raw_token)\n        )\n\n        if (\n            token is None\n            or token.used_at is not None\n            or token.invalidated_at is not None\n            or token.expires_at <= now\n        ):\n            raise InvalidPasswordResetTokenError\n\n        user = self.users.get_by_id(token.user_id)\n        if user is None or not user.is_active:\n            raise InvalidPasswordResetTokenError\n\n        return user\n\n    def reset_password(\n        self,\n        *,\n        raw_token: str,\n        new_password: str,\n    ) -> User:\n        now = datetime.now(timezone.utc)\n        token = self.tokens.get_by_hash(\n            hash_password_reset_token(raw_token)\n        )\n\n        if (\n            token is None\n            or token.used_at is not None\n            or token.invalidated_at is not None\n            or token.expires_at <= now\n        ):\n            raise InvalidPasswordResetTokenError\n'
AUTH_OLD = '@router.get(\n    "/reset-password-link",\n    response_class=HTMLResponse,\n    include_in_schema=False,\n)\ndef password_reset_landing_page(\n    token: str = Query(min_length=32, max_length=512),\n) -> HTMLResponse:\n    return HTMLResponse(\n        content=password_reset_form_page(token=token)\n    )\n'
AUTH_NEW = '@router.get(\n    "/reset-password-link",\n    response_class=HTMLResponse,\n    include_in_schema=False,\n)\ndef password_reset_landing_page(\n    token: str = Query(min_length=32, max_length=512),\n    db: Session = Depends(get_db),\n) -> HTMLResponse:\n    try:\n        PasswordResetService(db).validate_reset_token(token)\n        return HTMLResponse(\n            content=password_reset_form_page(token=token)\n        )\n    except InvalidPasswordResetTokenError:\n        return HTMLResponse(\n            status_code=status.HTTP_400_BAD_REQUEST,\n            content=password_reset_error_page(),\n        )\n'
BRAND_CSS_OLD = '    .brand-mark {{\n      width: 64px;\n      height: 64px;\n      margin: 0 auto 12px;\n      border: 2px solid var(--philotes-gold);\n      border-radius: 50%;\n      display: grid;\n      place-items: center;\n      background: var(--philotes-white);\n      color: var(--philotes-navy);\n      font-size: 28px;\n      font-weight: 800;\n      box-shadow: 0 8px 24px rgba(11, 37, 69, 0.08);\n    }}\n'
BRAND_CSS_NEW = '    .brand-mark {{\n      width: 92px;\n      height: 92px;\n      margin: 0 auto 14px;\n      border: 2px solid var(--philotes-gold);\n      border-radius: 50%;\n      display: grid;\n      place-items: center;\n      background: var(--philotes-ivory);\n      box-shadow: 0 8px 24px rgba(11, 37, 69, 0.08);\n      overflow: hidden;\n    }}\n\n    .brand-mark svg {{\n      width: 76px;\n      height: 76px;\n      display: block;\n    }}\n'
BRAND_HTML = '<div class="brand-mark" aria-hidden="true">\n        <svg viewBox="0 0 100 100">\n          <circle cx="50" cy="22" r="13" fill="#0b2545"></circle>\n          <circle cx="24" cy="50" r="13" fill="#32658d"></circle>\n          <circle cx="76" cy="50" r="13" fill="#c89b3c"></circle>\n          <circle cx="50" cy="78" r="13" fill="#7a8796"></circle>\n          <circle cx="50" cy="50" r="21" fill="#f7f2e8" stroke="#c89b3c" stroke-width="2"></circle>\n          <circle cx="45" cy="43" r="5" fill="none" stroke="#0b2545" stroke-width="4"></circle>\n          <circle cx="57" cy="43" r="5" fill="none" stroke="#0b2545" stroke-width="4"></circle>\n          <path d="M35 62c2-8 8-12 15-12s13 4 15 12" fill="none" stroke="#0b2545" stroke-width="4" stroke-linecap="round"></path>\n          <path d="M50 54c4-4 9-5 14-2 4 2 6 5 7 10" fill="none" stroke="#0b2545" stroke-width="4" stroke-linecap="round"></path>\n        </svg>\n      </div>'
PWD_CSS_INSERT = '    .password-field-wrap {{\n      position: relative;\n    }}\n\n    .password-input {{\n      width: 100%;\n      min-height: 50px;\n      border: 1px solid #aeb8c2;\n      border-radius: 12px;\n      padding: 12px 52px 12px 14px;\n      font: inherit;\n      color: var(--philotes-navy);\n      background: var(--philotes-white);\n    }}\n\n    .password-toggle {{\n      position: absolute;\n      top: 50%;\n      right: 10px;\n      transform: translateY(-50%);\n      width: 38px;\n      height: 38px;\n      border: 0;\n      border-radius: 10px;\n      display: grid;\n      place-items: center;\n      background: transparent;\n      color: var(--philotes-navy);\n      cursor: pointer;\n    }}\n\n    .password-toggle svg {{\n      width: 23px;\n      height: 23px;\n      fill: none;\n      stroke: currentColor;\n      stroke-width: 2;\n      stroke-linecap: round;\n      stroke-linejoin: round;\n    }}\n\n'
NEW_FORM_FUNC = 'def password_reset_form_page(\n    *,\n    token: str,\n    error_message: str | None = None,\n) -> str:\n    safe_token = escape(token, quote=True)\n    error_html = (\n        f\'<p class="form-error" role="alert">{escape(error_message)}</p>\'\n        if error_message\n        else ""\n    )\n\n    body = f"""\n{error_html}\n<form method="post" action="/api/v1/auth/reset-password-link">\n  <input type="hidden" name="token" value="{safe_token}">\n\n  <div style="margin-bottom: 16px;">\n    <label for="new-password" style="display:block;margin-bottom:8px;font-weight:700;">\n      New password\n    </label>\n    <div class="password-field-wrap">\n      <input class="password-input" id="new-password" name="new_password"\n        type="password" minlength="15" maxlength="128"\n        autocomplete="new-password" required>\n      <button class="password-toggle" type="button"\n        data-password-toggle="new-password"\n        aria-label="Show new password" aria-pressed="false">\n        <svg viewBox="0 0 24 24" aria-hidden="true">\n          <path d="M2 12s3.5-6 10-6 10 6 10 6-3.5 6-10 6S2 12 2 12Z"></path>\n          <circle cx="12" cy="12" r="3"></circle>\n        </svg>\n      </button>\n    </div>\n  </div>\n\n  <div style="margin-bottom: 22px;">\n    <label for="confirm-password" style="display:block;margin-bottom:8px;font-weight:700;">\n      Confirm new password\n    </label>\n    <div class="password-field-wrap">\n      <input class="password-input" id="confirm-password" name="confirm_password"\n        type="password" minlength="15" maxlength="128"\n        autocomplete="new-password" required>\n      <button class="password-toggle" type="button"\n        data-password-toggle="confirm-password"\n        aria-label="Show confirmed password" aria-pressed="false">\n        <svg viewBox="0 0 24 24" aria-hidden="true">\n          <path d="M2 12s3.5-6 10-6 10 6 10 6-3.5 6-10 6S2 12 2 12Z"></path>\n          <circle cx="12" cy="12" r="3"></circle>\n        </svg>\n      </button>\n    </div>\n  </div>\n\n  <button class="primary-action" type="submit">Change Password</button>\n</form>\n<p class="help-text">\n  Use at least 15 characters. After your password changes,\n  Philotes will sign out all existing sessions for your security.\n</p>\n\n<script>\ndocument.querySelectorAll("[data-password-toggle]").forEach((button) => {{\n  button.addEventListener("click", () => {{\n    const input = document.getElementById(\n      button.getAttribute("data-password-toggle")\n    );\n    if (!input) return;\n    input.type = input.type === "password" ? "text" : "password";\n  }});\n}});\n</script>\n"""\n\n    return philotes_security_page(\n        title="Reset your password",\n        message="Choose a new password for your Philotes account.",\n        body_html=body,\n    )\n\n'
RESET_TEST_ADD = '\n\ndef test_password_reset_browser_link_is_unavailable_after_use() -> None:\n    email = f"reset-browser-single-{uuid.uuid4()}@example.com"\n    old_password = "browser reset original development password"\n    first_password = "browser reset first changed development password"\n    second_password = "browser reset second changed development password"\n\n    try:\n        _register(email, old_password)\n\n        with SessionLocal() as db:\n            reset = PasswordResetService(db).request_reset(email)\n            assert reset is not None\n            _, raw_token = reset\n\n        landing = client.get(\n            "/api/v1/auth/reset-password-link",\n            params={"token": raw_token},\n        )\n        assert landing.status_code == 200\n        assert "Change Password" in landing.text\n\n        first_change = client.post(\n            "/api/v1/auth/reset-password-link",\n            data={\n                "token": raw_token,\n                "new_password": first_password,\n                "confirm_password": first_password,\n            },\n        )\n        assert first_change.status_code == 200\n        assert "Password changed" in first_change.text\n\n        reused_landing = client.get(\n            "/api/v1/auth/reset-password-link",\n            params={"token": raw_token},\n        )\n        assert reused_landing.status_code == 400\n        assert "Reset link unavailable" in reused_landing.text\n        assert "Change Password" not in reused_landing.text\n\n        reused_post = client.post(\n            "/api/v1/auth/reset-password-link",\n            data={\n                "token": raw_token,\n                "new_password": second_password,\n                "confirm_password": second_password,\n            },\n        )\n        assert reused_post.status_code == 400\n        assert "Reset link unavailable" in reused_post.text\n\n        with SessionLocal() as db:\n            user = db.scalars(\n                select(User).where(User.email == email)\n            ).one()\n            credential = AuthenticationService(db).credentials.get_by_user_id(\n                user.id\n            )\n            assert credential is not None\n            assert verify_password(first_password, credential.password_hash)\n            assert not verify_password(second_password, credential.password_hash)\n    finally:\n        _cleanup_email(email)\n'
PAGE_TEST_OLD = '    assert "Change Password" in form\n    assert "Password changed" in success\n    assert "Reset link unavailable" in error\n'
PAGE_TEST_NEW = '    assert "Change Password" in form\n    assert \'data-password-toggle="new-password"\' in form\n    assert \'data-password-toggle="confirm-password"\' in form\n    assert \'aria-label="Show new password"\' in form\n    assert \'aria-label="Show confirmed password"\' in form\n    assert "document.querySelectorAll" in form\n    assert "Password changed" in success\n    assert "Reset link unavailable" in error\n\n\ndef test_security_shell_uses_canonical_philotes_community_mark() -> None:\n    html = verification_success_page()\n\n    assert \'class="brand-mark"\' in html\n    assert "<svg" in html\n    assert \'circle cx="50" cy="22"\' in html\n    assert \'circle cx="24" cy="50"\' in html\n    assert \'circle cx="76" cy="50"\' in html\n    assert \'circle cx="50" cy="78"\' in html\n'


def read_required(path: Path) -> str:
    if not path.exists():
        raise RuntimeError(f"Required file not found: {path}")
    return path.read_text(encoding="utf-8")


def replace_once(text: str, old: str, new: str, description: str) -> str:
    count = text.count(old)
    if count != 1:
        raise RuntimeError(
            f"Expected exactly one block for {description}; found {count}."
        )
    return text.replace(old, new, 1)


def patch_service(text: str) -> str:
    if "def validate_reset_token(" in text:
        return text
    return replace_once(text, SERVICE_ANCHOR, SERVICE_REPL, "reset token validation")


def patch_auth(text: str) -> str:
    if "PasswordResetService(db).validate_reset_token(token)" in text:
        return text
    return replace_once(text, AUTH_OLD, AUTH_NEW, "reset GET route")


def patch_pages(text: str) -> str:
    if ".brand-mark svg" not in text:
        text = replace_once(text, BRAND_CSS_OLD, BRAND_CSS_NEW, "brand CSS")

    if '<svg viewBox="0 0 100 100">' not in text:
        marker = '<div class="brand-mark" aria-hidden="true">'
        start = text.find(marker)
        if start < 0:
            raise RuntimeError("Could not locate brand mark HTML.")
        end = text.find("</div>", start)
        if end < 0:
            raise RuntimeError("Could not locate brand mark closing div.")
        end += len("</div>")
        text = text[:start] + BRAND_HTML + text[end:]

    if ".password-field-wrap" not in text:
        text = replace_once(
            text,
            "    .help-text {{\n",
            PWD_CSS_INSERT + "    .help-text {{\n",
            "password visibility CSS",
        )

    start = text.find("def password_reset_form_page(\n")
    end = text.find("\ndef password_reset_success_page() -> str:\n", start)
    if start < 0 or end < 0:
        raise RuntimeError("Could not locate password reset form function.")
    text = text[:start] + NEW_FORM_FUNC + text[end + 1:]
    return text


def patch_reset_tests(text: str) -> str:
    if "test_password_reset_browser_link_is_unavailable_after_use" in text:
        return text
    return text.rstrip() + RESET_TEST_ADD + "\n"


def patch_page_tests(text: str) -> str:
    if "test_security_shell_uses_canonical_philotes_community_mark" in text:
        return text
    return replace_once(text, PAGE_TEST_OLD, PAGE_TEST_NEW, "security page tests")


def main() -> None:
    print()
    print("=" * 76)
    print("PHILOTES MASTER PATCH SYSTEM")
    print("=" * 76)
    print(f"PATCH ID   : {PATCH_ID}")
    print(f"PATCH NAME : {PATCH_NAME}")
    print("MODE       : SOURCE PATCH ONLY - TESTS MUST BE RUN MANUALLY")
    print("=" * 76)
    print()

    originals = {
        AUTH_FILE: read_required(AUTH_FILE),
        SERVICE_FILE: read_required(SERVICE_FILE),
        PAGES_FILE: read_required(PAGES_FILE),
        RESET_TEST_FILE: read_required(RESET_TEST_FILE),
        PAGE_TEST_FILE: read_required(PAGE_TEST_FILE),
    }

    try:
        SERVICE_FILE.write_text(patch_service(originals[SERVICE_FILE]), encoding="utf-8")
        AUTH_FILE.write_text(patch_auth(originals[AUTH_FILE]), encoding="utf-8")
        PAGES_FILE.write_text(patch_pages(originals[PAGES_FILE]), encoding="utf-8")
        RESET_TEST_FILE.write_text(patch_reset_tests(originals[RESET_TEST_FILE]), encoding="utf-8")
        PAGE_TEST_FILE.write_text(patch_page_tests(originals[PAGE_TEST_FILE]), encoding="utf-8")
    except Exception as exc:
        for path, original in originals.items():
            path.write_text(original, encoding="utf-8")
        print(f"FAIL: {exc}")
        print("All modified files were restored.")
        raise SystemExit(1)

    checks = [
        ("GET reset route validates token",
         "validate_reset_token(token)" in AUTH_FILE.read_text(encoding="utf-8")),
        ("Service validates reset tokens without consuming them",
         "def validate_reset_token(" in SERVICE_FILE.read_text(encoding="utf-8")),
        ("Canonical Philotes community mark added",
         '<svg viewBox="0 0 100 100">' in PAGES_FILE.read_text(encoding="utf-8")),
        ("New password visibility toggle added",
         'data-password-toggle="new-password"' in PAGES_FILE.read_text(encoding="utf-8")),
        ("Confirm password visibility toggle added",
         'data-password-toggle="confirm-password"' in PAGES_FILE.read_text(encoding="utf-8")),
        ("Browser single-use regression test added",
         "test_password_reset_browser_link_is_unavailable_after_use" in RESET_TEST_FILE.read_text(encoding="utf-8")),
    ]

    overall = all(ok for _, ok in checks)
    report = [
        "PHILOTES MASTER PATCH SYSTEM REPORT",
        "=" * 76,
        f"Generated: {datetime.now().isoformat(timespec='seconds')}",
        f"Patch ID: {PATCH_ID}",
        f"Patch Name: {PATCH_NAME}",
        "Mode: SOURCE PATCH ONLY",
        "",
    ]

    for description, ok in checks:
        status = "PASS" if ok else "FAIL"
        print(f"{status}: {description}")
        report.append(f"{status}: {description}")

    report.extend([
        "",
        "OVERALL: " + ("PASS" if overall else "FAIL"),
        "",
        "PATCH CONTRACT",
        "-" * 76,
        "- Used reset URLs are rejected on GET.",
        "- Used reset tokens remain rejected on POST.",
        "- Both password fields are hidden by default.",
        "- Both password fields have independent visibility toggles.",
        "- Security pages use the Philotes community emblem instead of Phi.",
        "- Titan footer branding is preserved.",
        "- Browser-route regression coverage is added.",
        "- This patch runs no tests, Flutter commands, or Git commands.",
    ])

    REPORT_FILE.write_text("\n".join(report) + "\n", encoding="utf-8")
    print()
    print(f"Report: {REPORT_FILE}")
    print("OVERALL: " + ("PASS" if overall else "FAIL"))

    if not overall:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
