import uuid

from fastapi.testclient import TestClient
from sqlalchemy import select

from app.core.database import SessionLocal
from app.main import app
from app.models.user import User
from app.models.user_session import UserSession


client = TestClient(app)


def _cleanup_email(email: str) -> None:
    with SessionLocal() as db:
        user = db.scalars(
            select(User).where(User.email == email)
        ).first()
        if user is not None:
            db.delete(user)
            db.commit()


def _register_and_login(
    email: str,
    password: str,
) -> tuple[str, str]:
    registration = client.post(
        "/api/v1/auth/register",
        json={"email": email, "password": password},
    )
    assert registration.status_code == 201

    login = client.post(
        "/api/v1/auth/login",
        json={"email": email, "password": password},
    )
    assert login.status_code == 200
    body = login.json()
    return body["access_token"], body["refresh_token"]


def test_change_password_replaces_session_and_credentials() -> None:
    email = f"change-password-{uuid.uuid4()}@example.com"
    old_password = "old authenticated development password"
    new_password = "new authenticated development password"

    try:
        old_access, old_refresh = _register_and_login(
            email,
            old_password,
        )

        changed = client.post(
            "/api/v1/auth/change-password",
            headers={"Authorization": f"Bearer {old_access}"},
            json={
                "current_password": old_password,
                "new_password": new_password,
                "confirm_password": new_password,
            },
        )
        assert changed.status_code == 200
        new_tokens = changed.json()
        assert new_tokens["token_type"] == "bearer"
        assert new_tokens["expires_in"] == 900
        assert new_tokens["access_token"] != old_access
        assert new_tokens["refresh_token"] != old_refresh

        # The pre-change access session must be dead.
        old_me = client.get(
            "/api/v1/auth/me",
            headers={"Authorization": f"Bearer {old_access}"},
        )
        assert old_me.status_code == 401

        # The replacement session keeps the current device signed in.
        new_me = client.get(
            "/api/v1/auth/me",
            headers={
                "Authorization": f"Bearer {new_tokens['access_token']}"
            },
        )
        assert new_me.status_code == 200
        assert new_me.json()["email"] == email

        # The old refresh credential must also be dead.
        old_refresh_response = client.post(
            "/api/v1/auth/refresh",
            json={"refresh_token": old_refresh},
        )
        assert old_refresh_response.status_code == 401

        old_login = client.post(
            "/api/v1/auth/login",
            json={"email": email, "password": old_password},
        )
        assert old_login.status_code == 401

        new_login = client.post(
            "/api/v1/auth/login",
            json={"email": email, "password": new_password},
        )
        assert new_login.status_code == 200

        with SessionLocal() as db:
            user = db.scalars(
                select(User).where(User.email == email)
            ).one()
            sessions = db.scalars(
                select(UserSession).where(
                    UserSession.user_id == user.id
                )
            ).all()

            active = [
                session
                for session in sessions
                if session.revoked_at is None
            ]
            assert active
            assert any(
                session.revoked_at is not None
                for session in sessions
            )
    finally:
        _cleanup_email(email)


def test_change_password_rejects_wrong_current_password() -> None:
    email = f"change-wrong-{uuid.uuid4()}@example.com"
    password = "correct authenticated development password"

    try:
        access, _ = _register_and_login(email, password)

        response = client.post(
            "/api/v1/auth/change-password",
            headers={"Authorization": f"Bearer {access}"},
            json={
                "current_password": "wrong authenticated password value",
                "new_password": "replacement authenticated password value",
                "confirm_password": (
                    "replacement authenticated password value"
                ),
            },
        )

        assert response.status_code == 400
        assert response.json() == {
            "detail": "Current password is incorrect."
        }

        # Failed change must not destroy the existing session.
        me = client.get(
            "/api/v1/auth/me",
            headers={"Authorization": f"Bearer {access}"},
        )
        assert me.status_code == 200
    finally:
        _cleanup_email(email)


def test_change_password_rejects_password_reuse() -> None:
    email = f"change-reuse-{uuid.uuid4()}@example.com"
    password = "reuse authenticated development password"

    try:
        access, _ = _register_and_login(email, password)

        response = client.post(
            "/api/v1/auth/change-password",
            headers={"Authorization": f"Bearer {access}"},
            json={
                "current_password": password,
                "new_password": password,
                "confirm_password": password,
            },
        )

        assert response.status_code == 400
        assert response.json() == {
            "detail": (
                "New password must be different from the current password."
            )
        }
    finally:
        _cleanup_email(email)


def test_change_password_rejects_confirmation_mismatch() -> None:
    email = f"change-mismatch-{uuid.uuid4()}@example.com"
    password = "mismatch authenticated development password"

    try:
        access, _ = _register_and_login(email, password)

        response = client.post(
            "/api/v1/auth/change-password",
            headers={"Authorization": f"Bearer {access}"},
            json={
                "current_password": password,
                "new_password": "first replacement password value",
                "confirm_password": "second replacement password value",
            },
        )

        assert response.status_code == 400
        assert response.json() == {
            "detail": "The new password entries do not match."
        }
    finally:
        _cleanup_email(email)


def test_change_password_requires_authentication() -> None:
    response = client.post(
        "/api/v1/auth/change-password",
        json={
            "current_password": "current development password",
            "new_password": "new authenticated development password",
            "confirm_password": "new authenticated development password",
        },
    )
    assert response.status_code == 401
