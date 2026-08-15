import uuid

from fastapi.testclient import TestClient
from sqlalchemy import delete

from app.core.database import SessionLocal
from app.main import app
from app.models.user import User


client = TestClient(app)


def _cleanup_email(email: str) -> None:
    with SessionLocal() as db:
        db.execute(delete(User).where(User.email == email))
        db.commit()


def test_create_and_get_user() -> None:
    email = f"account-{uuid.uuid4()}@EXAMPLE.COM"
    normalized = email.lower()

    try:
        create_response = client.post(
            "/api/v1/users",
            json={"email": email},
        )

        assert create_response.status_code == 201
        created = create_response.json()
        assert created["email"] == normalized
        assert created["email_verified"] is False
        assert created["is_active"] is True

        user_id = created["id"]

        get_response = client.get(
            f"/api/v1/users/{user_id}",
        )

        assert get_response.status_code == 200
        assert get_response.json()["id"] == user_id
        assert get_response.json()["email"] == normalized
    finally:
        _cleanup_email(normalized)


def test_duplicate_email_is_rejected() -> None:
    email = f"duplicate-{uuid.uuid4()}@example.com"

    try:
        first = client.post(
            "/api/v1/users",
            json={"email": email},
        )
        assert first.status_code == 201

        duplicate = client.post(
            "/api/v1/users",
            json={"email": email.upper()},
        )

        assert duplicate.status_code == 409
        assert duplicate.json() == {
            "detail": "An account with that email already exists."
        }
    finally:
        _cleanup_email(email)


def test_invalid_email_is_rejected() -> None:
    response = client.post(
        "/api/v1/users",
        json={"email": "not-an-email"},
    )

    assert response.status_code == 422


def test_unknown_user_returns_404() -> None:
    response = client.get(
        f"/api/v1/users/{uuid.uuid4()}",
    )

    assert response.status_code == 404
    assert response.json() == {
        "detail": "User not found."
    }
