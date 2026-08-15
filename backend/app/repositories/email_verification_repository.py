import uuid
from datetime import datetime

from sqlalchemy import select, update
from sqlalchemy.orm import Session

from ..models.email_verification_token import EmailVerificationToken


class EmailVerificationRepository:
    def __init__(self, db: Session) -> None:
        self.db = db

    def get_by_hash(self, token_hash: str) -> EmailVerificationToken | None:
        statement = select(EmailVerificationToken).where(
            EmailVerificationToken.token_hash == token_hash
        )
        return self.db.scalars(statement).first()

    def create(
        self,
        user_id: uuid.UUID,
        token_hash: str,
        expires_at: datetime,
    ) -> EmailVerificationToken:
        record = EmailVerificationToken(
            user_id=user_id,
            token_hash=token_hash,
            expires_at=expires_at,
        )
        self.db.add(record)
        self.db.flush()
        return record

    def invalidate_active_for_user(
        self,
        user_id: uuid.UUID,
        when: datetime,
    ) -> None:
        statement = (
            update(EmailVerificationToken)
            .where(
                EmailVerificationToken.user_id == user_id,
                EmailVerificationToken.used_at.is_(None),
                EmailVerificationToken.invalidated_at.is_(None),
            )
            .values(invalidated_at=when)
        )
        self.db.execute(statement)
