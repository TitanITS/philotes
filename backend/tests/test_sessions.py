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


def _register(email: str, password: str) -> None:
    response = client.post(
        "/api/v1/auth/register",
        json={"email": email, "password": password},
    )
    assert response.status_code == 201


def _login(
    email: str,
    password: str,
    *,
    device_name: str,
    platform: str,
    client_name: str,
) -> dict:
    response = client.post(
        "/api/v1/auth/login",
        headers={
            "X-Philotes-Device-Name": device_name,
            "X-Philotes-Platform": platform,
            "X-Philotes-Client": client_name,
        },
        json={"email": email, "password": password},
    )
    assert response.status_code == 200
    return response.json()


def test_list_sessions_marks_current_and_returns_compact_metadata() -> None:
    email = f"sessions-list-{uuid.uuid4()}@example.com"
    password = "session management development password"

    try:
        _register(email, password)
        first = _login(
            email,
            password,
            device_name="Windows PC",
            platform="Windows",
            client_name="Philotes Desktop",
        )
        _login(
            email,
            password,
            device_name="Galaxy Test",
            platform="Android",
            client_name="Philotes Mobile",
        )

        response = client.get(
            "/api/v1/sessions",
            headers={
                "Authorization": f"Bearer {first['access_token']}"
            },
        )
        assert response.status_code == 200
        sessions = response.json()["sessions"]
        assert len(sessions) == 2
        assert sum(1 for item in sessions if item["is_current"]) == 1

        current = next(item for item in sessions if item["is_current"])
        assert current["device_name"] == "Windows PC"
        assert current["platform"] == "Windows"
        assert current["client_name"] == "Philotes Desktop"
        assert current["signed_in_at"]
        assert current["last_active_at"]
    finally:
        _cleanup_email(email)


def test_sign_out_others_preserves_current_session() -> None:
    email = f"sessions-others-{uuid.uuid4()}@example.com"
    password = "sign out others development password"

    try:
        _register(email, password)
        current = _login(
            email,
            password,
            device_name="Current PC",
            platform="Windows",
            client_name="Philotes Desktop",
        )
        other = _login(
            email,
            password,
            device_name="Other Phone",
            platform="Android",
            client_name="Philotes Mobile",
        )

        response = client.post(
            "/api/v1/sessions/sign-out-others",
            headers={
                "Authorization": f"Bearer {current['access_token']}"
            },
        )
        assert response.status_code == 204

        current_me = client.get(
            "/api/v1/auth/me",
            headers={
                "Authorization": f"Bearer {current['access_token']}"
            },
        )
        assert current_me.status_code == 200

        other_me = client.get(
            "/api/v1/auth/me",
            headers={
                "Authorization": f"Bearer {other['access_token']}"
            },
        )
        assert other_me.status_code == 401
    finally:
        _cleanup_email(email)


def test_revoke_individual_other_session() -> None:
    email = f"sessions-revoke-{uuid.uuid4()}@example.com"
    password = "individual session development password"

    try:
        _register(email, password)
        current = _login(
            email,
            password,
            device_name="Current PC",
            platform="Windows",
            client_name="Philotes Desktop",
        )
        other = _login(
            email,
            password,
            device_name="Other PC",
            platform="Windows",
            client_name="Philotes Desktop",
        )

        listed = client.get(
            "/api/v1/sessions",
            headers={
                "Authorization": f"Bearer {current['access_token']}"
            },
        ).json()["sessions"]
        other_id = next(
            item["id"]
            for item in listed
            if not item["is_current"]
        )

        revoked = client.delete(
            f"/api/v1/sessions/{other_id}",
            headers={
                "Authorization": f"Bearer {current['access_token']}"
            },
        )
        assert revoked.status_code == 204

        rejected = client.get(
            "/api/v1/auth/me",
            headers={
                "Authorization": f"Bearer {other['access_token']}"
            },
        )
        assert rejected.status_code == 401
    finally:
        _cleanup_email(email)


def test_cannot_revoke_another_users_session() -> None:
    email_a = f"sessions-owner-a-{uuid.uuid4()}@example.com"
    email_b = f"sessions-owner-b-{uuid.uuid4()}@example.com"
    password = "ownership session development password"

    try:
        _register(email_a, password)
        _register(email_b, password)

        a = _login(
            email_a,
            password,
            device_name="A Device",
            platform="Windows",
            client_name="Philotes Desktop",
        )
        b = _login(
            email_b,
            password,
            device_name="B Device",
            platform="Windows",
            client_name="Philotes Desktop",
        )

        with SessionLocal() as db:
            user_b = db.scalars(
                select(User).where(User.email == email_b)
            ).one()
            b_session = db.scalars(
                select(UserSession).where(
                    UserSession.user_id == user_b.id
                )
            ).one()

        response = client.delete(
            f"/api/v1/sessions/{b_session.id}",
            headers={
                "Authorization": f"Bearer {a['access_token']}"
            },
        )
        assert response.status_code == 404

        still_valid = client.get(
            "/api/v1/auth/me",
            headers={
                "Authorization": f"Bearer {b['access_token']}"
            },
        )
        assert still_valid.status_code == 200
    finally:
        _cleanup_email(email_a)
        _cleanup_email(email_b)


def test_sign_out_everywhere_revokes_current_session() -> None:
    email = f"sessions-all-{uuid.uuid4()}@example.com"
    password = "sign out everywhere development password"

    try:
        _register(email, password)
        current = _login(
            email,
            password,
            device_name="Current PC",
            platform="Windows",
            client_name="Philotes Desktop",
        )

        response = client.post(
            "/api/v1/sessions/sign-out-everywhere",
            headers={
                "Authorization": f"Bearer {current['access_token']}"
            },
        )
        assert response.status_code == 204

        after = client.get(
            "/api/v1/auth/me",
            headers={
                "Authorization": f"Bearer {current['access_token']}"
            },
        )
        assert after.status_code == 401
    finally:
        _cleanup_email(email)


def test_current_session_cannot_be_deleted_via_other_session_endpoint() -> None:
    email = f"sessions-current-{uuid.uuid4()}@example.com"
    password = "current session protection development password"

    try:
        _register(email, password)
        current = _login(
            email,
            password,
            device_name="Current PC",
            platform="Windows",
            client_name="Philotes Desktop",
        )

        listed = client.get(
            "/api/v1/sessions",
            headers={
                "Authorization": f"Bearer {current['access_token']}"
            },
        ).json()["sessions"]
        current_id = next(
            item["id"] for item in listed if item["is_current"]
        )

        response = client.delete(
            f"/api/v1/sessions/{current_id}",
            headers={
                "Authorization": f"Bearer {current['access_token']}"
            },
        )
        assert response.status_code == 409

        still_valid = client.get(
            "/api/v1/auth/me",
            headers={
                "Authorization": f"Bearer {current['access_token']}"
            },
        )
        assert still_valid.status_code == 200
    finally:
        _cleanup_email(email)
