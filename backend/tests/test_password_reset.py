import uuid
from datetime import datetime, timedelta, timezone

from fastapi.testclient import TestClient
from sqlalchemy import select

from app.core.database import SessionLocal
from app.main import app
from app.models.password_reset_token import PasswordResetToken
from app.models.user import User
from app.models.user_session import UserSession
from app.security.passwords import verify_password
from app.services.auth_service import AuthenticationService
from app.services.password_reset_service import (
    InvalidPasswordResetTokenError,
    PasswordResetService,
)


client = TestClient(app)


def _cleanup_email(email: str) -> None:
    with SessionLocal() as db:
        user = db.scalars(
            select(User).where(User.email == email)
        ).first()
        if user is not None:
            db.delete(user)
            db.commit()


def _register(email: str, password: str) -> None:
    response = client.post(
        "/api/v1/auth/register",
        json={"email": email, "password": password},
    )
    assert response.status_code == 201


def test_forgot_password_does_not_disclose_account_existence() -> None:
    real_email = f"reset-real-{uuid.uuid4()}@example.com"
    missing_email = f"reset-missing-{uuid.uuid4()}@example.com"
    password = "password reset development password"

    try:
        _register(real_email, password)

        real = client.post(
            "/api/v1/auth/forgot-password",
            json={"email": real_email},
        )
        missing = client.post(
            "/api/v1/auth/forgot-password",
            json={"email": missing_email},
        )

        assert real.status_code == 202
        assert missing.status_code == 202
        assert real.json() == missing.json()
        assert real.json() == {
            "status": "password_reset_pending"
        }
    finally:
        _cleanup_email(real_email)


def test_password_reset_hashes_token_and_changes_password() -> None:
    email = f"reset-change-{uuid.uuid4()}@example.com"
    old_password = "old password reset development value"
    new_password = "new password reset development value"

    try:
        _register(email, old_password)

        with SessionLocal() as db:
            reset = PasswordResetService(db).request_reset(email)
            assert reset is not None
            user, raw_token = reset

            token = db.scalars(
                select(PasswordResetToken).where(
                    PasswordResetToken.user_id == user.id,
                    PasswordResetToken.used_at.is_(None),
                    PasswordResetToken.invalidated_at.is_(None),
                )
            ).one()

            assert len(token.token_hash) == 64
            assert token.token_hash != raw_token
            old_changed_at = user.id

        with SessionLocal() as db:
            PasswordResetService(db).reset_password(
                raw_token=raw_token,
                new_password=new_password,
            )

        with SessionLocal() as db:
            user = db.scalars(
                select(User).where(User.email == email)
            ).one()
            credential = AuthenticationService(db).credentials.get_by_user_id(
                user.id
            )
            assert credential is not None
            assert verify_password(
                new_password,
                credential.password_hash,
            )
            assert not verify_password(
                old_password,
                credential.password_hash,
            )
            assert credential.password_changed_at is not None
    finally:
        _cleanup_email(email)


def test_password_reset_token_is_single_use() -> None:
    email = f"reset-single-{uuid.uuid4()}@example.com"
    password = "single use reset development password"

    try:
        _register(email, password)

        with SessionLocal() as db:
            reset = PasswordResetService(db).request_reset(email)
            assert reset is not None
            _, raw_token = reset

        with SessionLocal() as db:
            PasswordResetService(db).reset_password(
                raw_token=raw_token,
                new_password="first changed development password",
            )

        with SessionLocal() as db:
            try:
                PasswordResetService(db).reset_password(
                    raw_token=raw_token,
                    new_password="second changed development password",
                )
            except InvalidPasswordResetTokenError:
                pass
            else:
                raise AssertionError("Used reset token was accepted twice")
    finally:
        _cleanup_email(email)


def test_expired_password_reset_token_is_rejected() -> None:
    email = f"reset-expired-{uuid.uuid4()}@example.com"
    password = "expired reset development password"

    try:
        _register(email, password)

        with SessionLocal() as db:
            reset = PasswordResetService(db).request_reset(email)
            assert reset is not None
            user, raw_token = reset
            token = db.scalars(
                select(PasswordResetToken).where(
                    PasswordResetToken.user_id == user.id,
                    PasswordResetToken.invalidated_at.is_(None),
                )
            ).one()
            token.expires_at = (
                datetime.now(timezone.utc) - timedelta(minutes=1)
            )
            db.commit()

        with SessionLocal() as db:
            try:
                PasswordResetService(db).reset_password(
                    raw_token=raw_token,
                    new_password="expired changed development password",
                )
            except InvalidPasswordResetTokenError:
                pass
            else:
                raise AssertionError("Expired reset token was accepted")
    finally:
        _cleanup_email(email)


def test_password_reset_revokes_existing_sessions() -> None:
    email = f"reset-session-{uuid.uuid4()}@example.com"
    password = "session reset development password"

    try:
        _register(email, password)

        login = client.post(
            "/api/v1/auth/login",
            json={"email": email, "password": password},
        )
        assert login.status_code == 200
        access_token = login.json()["access_token"]

        with SessionLocal() as db:
            reset = PasswordResetService(db).request_reset(email)
            assert reset is not None
            user, raw_token = reset

        with SessionLocal() as db:
            PasswordResetService(db).reset_password(
                raw_token=raw_token,
                new_password="replacement session development password",
            )

        old_me = client.get(
            "/api/v1/auth/me",
            headers={"Authorization": f"Bearer {access_token}"},
        )
        assert old_me.status_code == 401

        with SessionLocal() as db:
            sessions = db.scalars(
                select(UserSession).where(
                    UserSession.user_id == user.id
                )
            ).all()
            assert sessions
            assert all(
                session.revoked_at is not None
                for session in sessions
            )
    finally:
        _cleanup_email(email)

def test_password_reset_browser_link_is_unavailable_after_use() -> None:
    email = f"reset-browser-single-{uuid.uuid4()}@example.com"
    old_password = "browser reset original development password"
    first_password = "browser reset first changed development password"
    second_password = "browser reset second changed development password"

    try:
        _register(email, old_password)

        with SessionLocal() as db:
            reset = PasswordResetService(db).request_reset(email)
            assert reset is not None
            _, raw_token = reset

        landing = client.get(
            "/api/v1/auth/reset-password-link",
            params={"token": raw_token},
        )
        assert landing.status_code == 200
        assert "Change Password" in landing.text

        first_change = client.post(
            "/api/v1/auth/reset-password-link",
            data={
                "token": raw_token,
                "new_password": first_password,
                "confirm_password": first_password,
            },
        )
        assert first_change.status_code == 200
        assert "Password changed" in first_change.text

        reused_landing = client.get(
            "/api/v1/auth/reset-password-link",
            params={"token": raw_token},
        )
        assert reused_landing.status_code == 400
        assert "Reset link unavailable" in reused_landing.text
        assert "Change Password" not in reused_landing.text

        reused_post = client.post(
            "/api/v1/auth/reset-password-link",
            data={
                "token": raw_token,
                "new_password": second_password,
                "confirm_password": second_password,
            },
        )
        assert reused_post.status_code == 400
        assert "Reset link unavailable" in reused_post.text

        with SessionLocal() as db:
            user = db.scalars(
                select(User).where(User.email == email)
            ).one()
            credential = AuthenticationService(db).credentials.get_by_user_id(
                user.id
            )
            assert credential is not None
            assert verify_password(first_password, credential.password_hash)
            assert not verify_password(second_password, credential.password_hash)
    finally:
        _cleanup_email(email)

