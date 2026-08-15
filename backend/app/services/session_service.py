import uuid
from datetime import datetime, timezone

from sqlalchemy.orm import Session

from ..models.user_session import UserSession
from ..repositories.user_session_repository import UserSessionRepository


class SessionNotFoundError(Exception):
    pass


class CurrentSessionRevocationError(Exception):
    pass


class SessionService:
    def __init__(self, db: Session) -> None:
        self.db = db
        self.sessions = UserSessionRepository(db)

    def list_active(
        self,
        *,
        user_id: uuid.UUID,
        current_session_id: uuid.UUID,
    ) -> list[tuple[UserSession, bool]]:
        now = datetime.now(timezone.utc)
        records = self.sessions.list_active_for_user(user_id, now)
        self.sessions.touch(current_session_id, now)
        self.db.commit()

        return [
            (record, record.id == current_session_id)
            for record in records
        ]

    def revoke_session(
        self,
        *,
        user_id: uuid.UUID,
        current_session_id: uuid.UUID,
        session_id: uuid.UUID,
    ) -> None:
        if session_id == current_session_id:
            raise CurrentSessionRevocationError

        revoked = self.sessions.revoke_by_id_for_user(
            user_id=user_id,
            session_id=session_id,
            when=datetime.now(timezone.utc),
        )
        if not revoked:
            raise SessionNotFoundError

        self.db.commit()

    def revoke_others(
        self,
        *,
        user_id: uuid.UUID,
        current_session_id: uuid.UUID,
    ) -> None:
        self.sessions.revoke_others_for_user(
            user_id=user_id,
            current_session_id=current_session_id,
            when=datetime.now(timezone.utc),
        )
        self.db.commit()

    def revoke_everywhere(
        self,
        *,
        user_id: uuid.UUID,
    ) -> None:
        self.sessions.revoke_all_for_user(
            user_id,
            datetime.now(timezone.utc),
        )
        self.db.commit()
