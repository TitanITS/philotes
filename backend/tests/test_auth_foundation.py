import uuid

from fastapi.testclient import TestClient
from sqlalchemy import delete, select

from app.core.database import SessionLocal
from app.main import app
from app.models.user import User
from app.models.user_credential import UserCredential
from app.security.passwords import hash_password, verify_password


client = TestClient(app)


def _cleanup_email(email: str) -> None:
    with SessionLocal() as db:
        user = db.scalars(
            select(User).where(User.email == email)
        ).first()
        if user is not None:
            db.execute(
                delete(UserCredential).where(
                    UserCredential.user_id == user.id
                )
            )
            db.delete(user)
            db.commit()


def test_password_hash_round_trip() -> None:
    password = "correct horse battery staple"
    password_hash = hash_password(password)

    assert password_hash != password
    assert verify_password(password, password_hash) is True
    assert verify_password("wrong password", password_hash) is False


def test_registration_creates_user_and_credential() -> None:
    email = f"registration-{uuid.uuid4()}@EXAMPLE.COM"
    normalized = email.lower()
    password = "a secure development password"

    try:
        response = client.post(
            "/api/v1/auth/register",
            json={
                "email": email,
                "password": password,
            },
        )

        assert response.status_code == 201
        body = response.json()
        assert body["email"] == normalized
        assert "password" not in body
        assert "password_hash" not in body

        with SessionLocal() as db:
            user = db.scalars(
                select(User).where(User.email == normalized)
            ).one()
            credential = db.get(UserCredential, user.id)

            assert credential is not None
            assert credential.password_hash != password
            assert verify_password(
                password,
                credential.password_hash,
            ) is True
    finally:
        _cleanup_email(normalized)


def test_registration_rejects_short_password() -> None:
    response = client.post(
        "/api/v1/auth/register",
        json={
            "email": f"short-{uuid.uuid4()}@example.com",
            "password": "too-short",
        },
    )

    assert response.status_code == 422


def test_registration_rejects_duplicate_email() -> None:
    email = f"auth-duplicate-{uuid.uuid4()}@example.com"
    password = "another secure development password"

    try:
        first = client.post(
            "/api/v1/auth/register",
            json={"email": email, "password": password},
        )
        assert first.status_code == 201

        duplicate = client.post(
            "/api/v1/auth/register",
            json={"email": email.upper(), "password": password},
        )
        assert duplicate.status_code == 409
    finally:
        _cleanup_email(email)
