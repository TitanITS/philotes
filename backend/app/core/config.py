from pathlib import Path

from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict


BACKEND_ROOT = Path(__file__).resolve().parents[2]


class Settings(BaseSettings):
    app_name: str = "Philotes API"
    environment: str = "development"
    api_v1_prefix: str = "/api/v1"
    database_url: str
    jwt_secret_key: str
    jwt_algorithm: str = "HS256"
    jwt_issuer: str = "philotes-api"
    access_token_expire_minutes: int = 15
    session_expire_days: int = 30
    email_verification_expire_hours: int = 24

    # Resend uses its conventional unprefixed environment variable.
    resend_api_key: str | None = Field(
        default=None,
        validation_alias="RESEND_API_KEY",
    )
    email_delivery_enabled: bool = False
    email_from_address: str = (
        "Philotes <account@mail.philotes.titannexustech.com>"
    )
    email_verification_url: str = (
        "http://127.0.0.1:8000/api/v1/auth/verify-email-link"
    )

    model_config = SettingsConfigDict(
        env_file=str(BACKEND_ROOT / ".env"),
        env_file_encoding="utf-8",
        env_prefix="PHILOTES_",
        extra="ignore",
    )


settings = Settings()
