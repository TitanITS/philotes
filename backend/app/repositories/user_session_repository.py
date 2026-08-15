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
        *,
        device_name: str | None = None,
        platform: str | None = None,
        client_name: str | None = None,
    ) -> UserSession:
        session = UserSession(
            user_id=user_id,
            device_name=device_name,
            platform=platform,
            client_name=client_name,
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


    def list_active_for_user(
        self,
        user_id: uuid.UUID,
        now: datetime,
    ) -> list[UserSession]:
        statement = (
            select(UserSession)
            .where(
                UserSession.user_id == user_id,
                UserSession.revoked_at.is_(None),
                UserSession.expires_at > now,
            )
            .order_by(UserSession.created_at.desc())
        )
        return list(self.db.scalars(statement).all())

    def revoke_by_id_for_user(
        self,
        *,
        user_id: uuid.UUID,
        session_id: uuid.UUID,
        when: datetime,
    ) -> bool:
        session = self.get_by_id(session_id)
        if (
            session is None
            or session.user_id != user_id
            or session.revoked_at is not None
        ):
            return False

        session.revoked_at = when
        return True

    def revoke_others_for_user(
        self,
        *,
        user_id: uuid.UUID,
        current_session_id: uuid.UUID,
        when: datetime,
    ) -> None:
        statement = (
            update(UserSession)
            .where(
                UserSession.user_id == user_id,
                UserSession.id != current_session_id,
                UserSession.revoked_at.is_(None),
            )
            .values(revoked_at=when)
        )
        self.db.execute(statement)

    def touch(
        self,
        session_id: uuid.UUID,
        when: datetime,
    ) -> None:
        session = self.get_by_id(session_id)
        if session is not None and session.revoked_at is None:
            session.last_used_at = when
