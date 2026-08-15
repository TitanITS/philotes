import uuid
from datetime import datetime, timedelta, timezone

import pytest
from fastapi import HTTPException
from fastapi.testclient import TestClient
from sqlalchemy import delete, select

from app.core.database import SessionLocal
from app.main import app
from app.models.email_verification_token import EmailVerificationToken
from app.models.user import User
from app.security.authentication import get_verified_user
from app.services.email_verification_service import EmailVerificationService


client = TestClient(app)


def _cleanup_email(email: str) -> None:
    with SessionLocal() as db:
        user = db.scalars(
            select(User).where(User.email == email)
        ).first()
        if user is not None:
            db.delete(user)
            db.commit()


def _register_and_login(email: str, password: str) -> str:
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
    return login.json()["access_token"]


def test_registration_creates_hashed_verification_token() -> None:
    email = f"verify-register-{uuid.uuid4()}@example.com"
    password = "verification development password"
    try:
        response = client.post(
            "/api/v1/auth/register",
            json={"email": email, "password": password},
        )
        assert response.status_code == 201
        assert response.json()["email_verified"] is False

        with SessionLocal() as db:
            user = db.scalars(
                select(User).where(User.email == email)
            ).one()
            token = db.scalars(
                select(EmailVerificationToken).where(
                    EmailVerificationToken.user_id == user.id,
                    EmailVerificationToken.invalidated_at.is_(None),
                    EmailVerificationToken.used_at.is_(None),
                )
            ).one()
            assert len(token.token_hash) == 64
            assert token.expires_at > datetime.now(timezone.utc)
    finally:
        _cleanup_email(email)


def test_verify_email_token_is_single_use() -> None:
    email = f"verify-use-{uuid.uuid4()}@example.com"
    password = "verification development password"
    try:
        client.post(
            "/api/v1/auth/register",
            json={"email": email, "password": password},
        )

        with SessionLocal() as db:
            user = db.scalars(
                select(User).where(User.email == email)
            ).one()
            raw_token = EmailVerificationService(db).issue_token(user.id)

        verified = client.post(
            "/api/v1/auth/verify-email",
            json={"token": raw_token},
        )
        assert verified.status_code == 200
        assert verified.json() == {"status": "verified"}

        reused = client.post(
            "/api/v1/auth/verify-email",
            json={"token": raw_token},
        )
        assert reused.status_code == 400

        with SessionLocal() as db:
            user = db.scalars(
                select(User).where(User.email == email)
            ).one()
            assert user.email_verified is True

            used_token = db.scalars(
                select(EmailVerificationToken).where(
                    EmailVerificationToken.user_id == user.id,
                    EmailVerificationToken.used_at.is_not(None),
                )
            ).one()
            assert used_token.invalidated_at is None

            superseded_tokens = db.scalars(
                select(EmailVerificationToken).where(
                    EmailVerificationToken.user_id == user.id,
                    EmailVerificationToken.used_at.is_(None),
                )
            ).all()
            assert superseded_tokens
            assert all(
                record.invalidated_at is not None
                for record in superseded_tokens
            )
    finally:
        _cleanup_email(email)


def test_expired_verification_token_is_rejected() -> None:
    email = f"verify-expired-{uuid.uuid4()}@example.com"
    password = "verification development password"
    try:
        client.post(
            "/api/v1/auth/register",
            json={"email": email, "password": password},
        )

        with SessionLocal() as db:
            user = db.scalars(
                select(User).where(User.email == email)
            ).one()
            raw_token = EmailVerificationService(db).issue_token(user.id)
            token = db.scalars(
                select(EmailVerificationToken).where(
                    EmailVerificationToken.user_id == user.id,
                    EmailVerificationToken.invalidated_at.is_(None),
                )
            ).one()
            token.expires_at = datetime.now(timezone.utc) - timedelta(minutes=1)
            db.commit()

        response = client.post(
            "/api/v1/auth/verify-email",
            json={"token": raw_token},
        )
        assert response.status_code == 400
    finally:
        _cleanup_email(email)


def test_resend_invalidates_previous_active_token() -> None:
    email = f"verify-resend-{uuid.uuid4()}@example.com"
    password = "verification development password"
    try:
        access_token = _register_and_login(email, password)

        response = client.post(
            "/api/v1/auth/resend-verification",
            headers={"Authorization": f"Bearer {access_token}"},
        )
        assert response.status_code == 202
        assert response.json() == {"status": "verification_pending"}

        with SessionLocal() as db:
            user = db.scalars(
                select(User).where(User.email == email)
            ).one()
            active = db.scalars(
                select(EmailVerificationToken).where(
                    EmailVerificationToken.user_id == user.id,
                    EmailVerificationToken.used_at.is_(None),
                    EmailVerificationToken.invalidated_at.is_(None),
                )
            ).all()
            assert len(active) == 1
    finally:
        _cleanup_email(email)


def test_resend_for_verified_user_reports_already_verified() -> None:
    email = f"verify-already-{uuid.uuid4()}@example.com"
    password = "verification development password"
    try:
        access_token = _register_and_login(email, password)

        with SessionLocal() as db:
            user = db.scalars(
                select(User).where(User.email == email)
            ).one()
            raw_token = EmailVerificationService(db).issue_token(user.id)

        verified = client.post(
            "/api/v1/auth/verify-email",
            json={"token": raw_token},
        )
        assert verified.status_code == 200

        resend = client.post(
            "/api/v1/auth/resend-verification",
            headers={"Authorization": f"Bearer {access_token}"},
        )
        assert resend.status_code == 202
        assert resend.json() == {"status": "already_verified"}

        with SessionLocal() as db:
            user = db.scalars(
                select(User).where(User.email == email)
            ).one()
            active = db.scalars(
                select(EmailVerificationToken).where(
                    EmailVerificationToken.user_id == user.id,
                    EmailVerificationToken.used_at.is_(None),
                    EmailVerificationToken.invalidated_at.is_(None),
                )
            ).all()
            assert active == []
    finally:
        _cleanup_email(email)


def test_verified_user_dependency_rejects_unverified_user() -> None:
    user = User(email="dependency@example.com", email_verified=False)

    with pytest.raises(HTTPException) as caught:
        get_verified_user(current_user=user)

    assert caught.value.status_code == 403
