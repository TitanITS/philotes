import uuid

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
