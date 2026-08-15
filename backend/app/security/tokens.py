import hashlib
import secrets
import uuid
from datetime import datetime, timedelta, timezone

import jwt
from jwt.exceptions import InvalidTokenError

from ..core.config import settings


class AccessTokenError(Exception):
    pass


def create_refresh_token() -> str:
    return secrets.token_urlsafe(48)


def hash_refresh_token(token: str) -> str:
    return hashlib.sha256(token.encode("utf-8")).hexdigest()


def create_access_token(
    user_id: uuid.UUID,
    session_id: uuid.UUID,
) -> tuple[str, int]:
    expires_in = settings.access_token_expire_minutes * 60
    now = datetime.now(timezone.utc)
    payload = {
        "sub": str(user_id),
        "sid": str(session_id),
        "type": "access",
        "iss": settings.jwt_issuer,
        "iat": now,
        "exp": now + timedelta(seconds=expires_in),
    }

    token = jwt.encode(
        payload,
        settings.jwt_secret_key,
        algorithm=settings.jwt_algorithm,
    )
    return token, expires_in


def decode_access_token(token: str) -> tuple[uuid.UUID, uuid.UUID]:
    try:
        payload = jwt.decode(
            token,
            settings.jwt_secret_key,
            algorithms=[settings.jwt_algorithm],
            issuer=settings.jwt_issuer,
            options={
                "require": ["exp", "iat", "iss", "sub", "sid", "type"],
            },
        )

        if payload.get("type") != "access":
            raise AccessTokenError

        user_id = uuid.UUID(payload["sub"])
        session_id = uuid.UUID(payload["sid"])
        return user_id, session_id
    except (InvalidTokenError, KeyError, TypeError, ValueError) as exc:
        raise AccessTokenError from exc
