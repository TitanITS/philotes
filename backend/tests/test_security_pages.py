from app.presentation.security_pages import (
    password_reset_error_page,
    password_reset_form_page,
    password_reset_success_page,
    verification_confirmation_page,
    verification_error_page,
    verification_success_page,
)


def test_verification_confirmation_uses_philotes_security_shell() -> None:
    html = verification_confirmation_page(
        token="development-token-123456789012345678901234567890"
    )

    assert "PHILOTES" in html
    assert "A Community for Friendship" in html
    assert "BROUGHT TO YOU BY" in html
    assert "/api/v1/auth/security-assets/titan-logo.png" in html
    assert ">TITAN</span>" in html
    assert "Verify Email Address" in html
    assert "--philotes-navy" in html
    assert "--philotes-gold" in html


def test_verification_success_uses_philotes_security_shell() -> None:
    html = verification_success_page()

    assert "Email verified" in html
    assert "successfully verified" in html
    assert "return to Philotes" in html
    assert "BROUGHT TO YOU BY" in html
    assert "/api/v1/auth/security-assets/titan-logo.png" in html
    assert ">TITAN</span>" in html


def test_verification_error_uses_philotes_security_shell() -> None:
    html = verification_error_page()

    assert "Verification link unavailable" in html
    assert "invalid, expired, or has already been used" in html
    assert "Request a new verification email" in html
    assert "BROUGHT TO YOU BY" in html
    assert "/api/v1/auth/security-assets/titan-logo.png" in html



def test_password_reset_pages_use_philotes_security_shell() -> None:
    form = password_reset_form_page(
        token="reset-development-token-123456789012345678901234"
    )
    success = password_reset_success_page()
    error = password_reset_error_page()

    for html in (form, success, error):
        assert "PHILOTES" in html
        assert "A Community for Friendship" in html
        assert "BROUGHT TO YOU BY" in html
        assert "/api/v1/auth/security-assets/titan-logo.png" in html
        assert ">TITAN</span>" in html

    assert "Change Password" in form
    assert 'data-password-toggle="new-password"' in form
    assert 'data-password-toggle="confirm-password"' in form
    assert 'aria-label="Show new password"' in form
    assert 'aria-label="Show confirmed password"' in form
    assert "document.querySelectorAll" in form
    assert "Password changed" in success
    assert "Reset link unavailable" in error


def test_security_shell_uses_canonical_philotes_community_mark() -> None:
    html = verification_success_page()

    assert 'class="brand-mark"' in html
    assert "<svg" in html
    assert 'circle cx="50" cy="22"' in html
    assert 'circle cx="24" cy="50"' in html
    assert 'circle cx="76" cy="50"' in html
    assert 'circle cx="50" cy="78"' in html
