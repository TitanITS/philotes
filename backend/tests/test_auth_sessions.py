import uuid

from fastapi.testclient import TestClient
from sqlalchemy import delete, select

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
            db.execute(
                delete(UserSession).where(
                    UserSession.user_id == user.id
                )
            )
            db.delete(user)
            db.commit()


def _register(email: str, password: str) -> None:
    response = client.post(
        "/api/v1/auth/register",
        json={"email": email, "password": password},
    )
    assert response.status_code == 201


def test_login_me_refresh_logout_flow() -> None:
    email = f"session-{uuid.uuid4()}@example.com"
    password = "session development password"
    try:
        _register(email, password)

        login = client.post(
            "/api/v1/auth/login",
            json={"email": email, "password": password},
        )
        assert login.status_code == 200
        tokens = login.json()
        assert tokens["token_type"] == "bearer"
        assert tokens["expires_in"] == 900

        me = client.get(
            "/api/v1/auth/me",
            headers={
                "Authorization": f"Bearer {tokens['access_token']}"
            },
        )
        assert me.status_code == 200
        assert me.json()["email"] == email

        refreshed = client.post(
            "/api/v1/auth/refresh",
            json={"refresh_token": tokens["refresh_token"]},
        )
        assert refreshed.status_code == 200
        new_tokens = refreshed.json()
        assert new_tokens["refresh_token"] != tokens["refresh_token"]

        old_refresh = client.post(
            "/api/v1/auth/refresh",
            json={"refresh_token": tokens["refresh_token"]},
        )
        assert old_refresh.status_code == 401

        logout = client.post(
            "/api/v1/auth/logout",
            json={"refresh_token": new_tokens["refresh_token"]},
        )
        assert logout.status_code == 204

        revoked_me = client.get(
            "/api/v1/auth/me",
            headers={
                "Authorization": f"Bearer {new_tokens['access_token']}"
            },
        )
        assert revoked_me.status_code == 401
    finally:
        _cleanup_email(email)


def test_login_rejects_bad_password_without_email_disclosure() -> None:
    email = f"bad-login-{uuid.uuid4()}@example.com"
    password = "correct development password"
    try:
        _register(email, password)

        wrong_password = client.post(
            "/api/v1/auth/login",
            json={
                "email": email,
                "password": "incorrect development password",
            },
        )
        missing_email = client.post(
            "/api/v1/auth/login",
            json={
                "email": f"missing-{uuid.uuid4()}@example.com",
                "password": "incorrect development password",
            },
        )

        assert wrong_password.status_code == 401
        assert missing_email.status_code == 401
        assert wrong_password.json() == missing_email.json()
        assert wrong_password.json() == {
            "detail": "Invalid email or password."
        }
    finally:
        _cleanup_email(email)


def test_me_requires_bearer_token() -> None:
    response = client.get("/api/v1/auth/me")
    assert response.status_code == 401
