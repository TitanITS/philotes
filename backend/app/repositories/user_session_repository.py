import uuid
from datetime import datetime

from sqlalchemy import select, update
from sqlalchemy.orm import Session

from ..models.user_session import UserSession


class UserSessionRepository:
    def __init__(self, db: Session) -> None:
        self.db = db

    def get_by_id(self, session_id: uuid.UUID) -> UserSession | None:
        return self.db.get(UserSession, session_id)

    def get_by_refresh_hash(self, refresh_token_hash: str) -> UserSession | None:
        statement = select(UserSession).where(
            UserSession.refresh_token_hash == refresh_token_hash
        )
        return self.db.scalars(statement).first()

    def create(
        self,
        user_id: uuid.UUID,
        refresh_token_hash: str,
        expires_at: datetime,
    ) -> UserSession:
        session = UserSession(
            user_id=user_id,
            refresh_token_hash=refresh_token_hash,
            expires_at=expires_at,
        )
        self.db.add(session)
        self.db.flush()
        return session


    def revoke_all_for_user(
        self,
        user_id: uuid.UUID,
        when: datetime,
    ) -> None:
        statement = (
            update(UserSession)
            .where(
                UserSession.user_id == user_id,
                UserSession.revoked_at.is_(None),
            )
            .values(revoked_at=when)
        )
        self.db.execute(statement)
