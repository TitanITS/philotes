import uuid

from fastapi.testclient import TestClient
from sqlalchemy import select

from app.core.config import settings
from app.core.database import SessionLocal
from app.main import app
from app.models.user import User
from app.providers.resend_email_provider import ResendEmailProvider
from app.services.email_delivery_service import EmailDeliveryService


client = TestClient(app)


def _cleanup_email(email: str) -> None:
    with SessionLocal() as db:
        user = db.scalars(
            select(User).where(User.email == email)
        ).first()
        if user is not None:
            db.delete(user)
            db.commit()


def test_resend_provider_builds_expected_message(monkeypatch) -> None:
    captured: dict = {}

    def fake_send(params):
        captured.update(params)
        return {"id": "development-email-id"}

    monkeypatch.setattr(
        "app.providers.resend_email_provider.resend.Emails.send",
        fake_send,
    )
    monkeypatch.setattr(
        settings,
        "resend_api_key",
        "re_development_test_key",
    )

    EmailDeliveryService(
        provider=ResendEmailProvider()
    ).send_verification_email(
        to_email="delivery-test@example.com",
        raw_token="development-verification-token-1234567890",
    )

    assert captured["from"] == settings.email_from_address
    assert captured["to"] == ["delivery-test@example.com"]
    assert captured["subject"] == "Verify your Philotes email"
    assert "development-verification-token" in captured["html"]
    assert "development-verification-token" in captured["text"]


def test_verification_link_get_does_not_verify_email() -> None:
    email = f"email-link-{uuid.uuid4()}@example.com"
    password = "verification delivery development password"

    try:
        registration = client.post(
            "/api/v1/auth/register",
            json={"email": email, "password": password},
        )
        assert registration.status_code == 201

        with SessionLocal() as db:
            user = db.scalars(
                select(User).where(User.email == email)
            ).one()
            token = EmailDeliveryService.build_verification_url(
                "placeholder-token-value-12345678901234567890"
            )
            assert user.email_verified is False

        # The GET landing page must never consume a token. Link scanners
        # may prefetch verification links.
        response = client.get(
            "/api/v1/auth/verify-email-link",
            params={
                "token": "placeholder-token-value-12345678901234567890"
            },
        )
        assert response.status_code == 200

        with SessionLocal() as db:
            user = db.scalars(
                select(User).where(User.email == email)
            ).one()
            assert user.email_verified is False
    finally:
        _cleanup_email(email)



def test_resend_provider_builds_password_reset_message(monkeypatch) -> None:
    captured: dict = {}

    def fake_send(params):
        captured.update(params)
        return {"id": "development-reset-email-id"}

    monkeypatch.setattr(
        "app.providers.resend_email_provider.resend.Emails.send",
        fake_send,
    )
    monkeypatch.setattr(
        settings,
        "resend_api_key",
        "re_development_test_key",
    )

    EmailDeliveryService(
        provider=ResendEmailProvider()
    ).send_password_reset_email(
        to_email="reset-delivery-test@example.com",
        raw_token="development-reset-token-12345678901234567890",
    )

    assert captured["from"] == settings.email_from_address
    assert captured["to"] == ["reset-delivery-test@example.com"]
    assert captured["subject"] == "Reset your Philotes password"
    assert "development-reset-token" in captured["html"]
    assert "development-reset-token" in captured["text"]
