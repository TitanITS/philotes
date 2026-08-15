import uuid
from datetime import datetime, timedelta, timezone

from sqlalchemy.orm import Session

from ..core.config import settings
from ..models.user import User
from ..repositories.email_verification_repository import EmailVerificationRepository
from ..repositories.user_repository import UserRepository
from ..security.email_verification_tokens import (
    create_email_verification_token,
    hash_email_verification_token,
)


class InvalidEmailVerificationTokenError(Exception):
    pass


class EmailVerificationService:
    def __init__(self, db: Session) -> None:
        self.db = db
        self.tokens = EmailVerificationRepository(db)
        self.users = UserRepository(db)

    def issue_token(
        self,
        user_id: uuid.UUID,
        *,
        commit: bool = True,
    ) -> str:
        now = datetime.now(timezone.utc)
        self.tokens.invalidate_active_for_user(user_id, now)

        raw_token = create_email_verification_token()
        self.tokens.create(
            user_id=user_id,
            token_hash=hash_email_verification_token(raw_token),
            expires_at=now + timedelta(
                hours=settings.email_verification_expire_hours,
            ),
        )

        if commit:
            self.db.commit()

        return raw_token

    def verify(self, raw_token: str) -> User:
        now = datetime.now(timezone.utc)
        token = self.tokens.get_by_hash(
            hash_email_verification_token(raw_token)
        )

        if (
            token is None
            or token.used_at is not None
            or token.invalidated_at is not None
            or token.expires_at <= now
        ):
            raise InvalidEmailVerificationTokenError

        user = self.users.get_by_id(token.user_id)
        if user is None or not user.is_active:
            raise InvalidEmailVerificationTokenError

        user.email_verified = True
        token.used_at = now

        # SessionLocal uses autoflush=False. Flush the successful-use
        # state before invalidating any other active tokens so the
        # token being consumed is not mistakenly invalidated too.
        self.db.flush()

        self.tokens.invalidate_active_for_user(user.id, now)
        self.db.commit()
        self.db.refresh(user)
        return user
