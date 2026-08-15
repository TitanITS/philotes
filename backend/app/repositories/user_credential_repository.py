import uuid
from datetime import datetime

from sqlalchemy.orm import Session

from ..models.user_credential import UserCredential


class UserCredentialRepository:
    def __init__(self, db: Session) -> None:
        self.db = db

    def get_by_user_id(self, user_id: uuid.UUID) -> UserCredential | None:
        return self.db.get(UserCredential, user_id)

    def create(
        self,
        user_id: uuid.UUID,
        password_hash: str,
    ) -> UserCredential:
        credential = UserCredential(
            user_id=user_id,
            password_hash=password_hash,
        )
        self.db.add(credential)
        self.db.flush()
        return credential


    def update_password(
        self,
        *,
        user_id: uuid.UUID,
        password_hash: str,
        changed_at: datetime,
    ) -> UserCredential | None:
        credential = self.get_by_user_id(user_id)
        if credential is None:
            return None

        credential.password_hash = password_hash
        credential.password_changed_at = changed_at
        return credential
