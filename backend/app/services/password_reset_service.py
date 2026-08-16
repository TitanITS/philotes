from datetime import datetime, timedelta, timezone

from sqlalchemy.orm import Session

from ..core.config import settings
from ..models.user import User
from ..repositories.password_reset_repository import PasswordResetRepository
from ..repositories.user_credential_repository import UserCredentialRepository
from ..repositories.user_repository import UserRepository
from ..repositories.user_session_repository import UserSessionRepository
from ..security.password_reset_tokens import (
    create_password_reset_token,
    hash_password_reset_token,
)
from ..security.passwords import hash_password
from .user_service import UserService


class InvalidPasswordResetTokenError(Exception):
    pass


class PasswordResetService:
    def __init__(self, db: Session) -> None:
        self.db = db
        self.tokens = PasswordResetRepository(db)
        self.users = UserRepository(db)
        self.credentials = UserCredentialRepository(db)
        self.sessions = UserSessionRepository(db)

    def request_reset(self, email: str) -> tuple[User, str] | None:
        normalized_email = UserService.normalize_email(email)
        user = self.users.get_by_email(normalized_email)

        # Public callers receive the same response for missing, inactive,
        # and valid accounts. Returning None here is an internal detail.
        if user is None or not user.is_active:
            return None

        now = datetime.now(timezone.utc)
        self.tokens.invalidate_active_for_user(user.id, now)

        raw_token = create_password_reset_token()
        self.tokens.create(
            user_id=user.id,
            token_hash=hash_password_reset_token(raw_token),
            expires_at=now + timedelta(
                minutes=settings.password_reset_expire_minutes,
            ),
        )
        self.db.commit()
        return user, raw_token

    def validate_reset_token(self, raw_token: str) -> User:
        now = datetime.now(timezone.utc)
        token = self.tokens.get_by_hash(
            hash_password_reset_token(raw_token)
        )

        if (
            token is None
            or token.used_at is not None
            or token.invalidated_at is not None
            or token.expires_at <= now
        ):
            raise InvalidPasswordResetTokenError

        user = self.users.get_by_id(token.user_id)
        if user is None or not user.is_active:
            raise InvalidPasswordResetTokenError

        return user

    def reset_password(
        self,
        *,
        raw_token: str,
        new_password: str,
    ) -> User:
        now = datetime.now(timezone.utc)
        token = self.tokens.get_by_hash(
            hash_password_reset_token(raw_token)
        )

        if (
            token is None
            or token.used_at is not None
            or token.invalidated_at is not None
            or token.expires_at <= now
        ):
            raise InvalidPasswordResetTokenError

        user = self.users.get_by_id(token.user_id)
        if user is None or not user.is_active:
            raise InvalidPasswordResetTokenError

        credential = self.credentials.update_password(
            user_id=user.id,
            password_hash=hash_password(new_password),
            changed_at=now,
        )
        if credential is None:
            raise InvalidPasswordResetTokenError

        token.used_at = now

        # SessionLocal uses autoflush=False. Persist the successful-use
        # marker before invalidating any remaining active reset tokens.
        self.db.flush()

        self.tokens.invalidate_active_for_user(user.id, now)
        self.sessions.revoke_all_for_user(user.id, now)
        self.db.commit()
        self.db.refresh(user)
        return user
