from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from ..models.user import User
from ..repositories.user_credential_repository import UserCredentialRepository
from ..repositories.user_repository import UserRepository
from ..security.passwords import hash_password
from .user_service import UserAlreadyExistsError, UserService


class AuthenticationService:
    def __init__(self, db: Session) -> None:
        self.db = db
        self.users = UserRepository(db)
        self.credentials = UserCredentialRepository(db)

    def register(self, email: str, password: str) -> User:
        normalized_email = UserService.normalize_email(email)

        if self.users.get_by_email(normalized_email) is not None:
            raise UserAlreadyExistsError

        try:
            user = User(email=normalized_email)
            self.db.add(user)
            self.db.flush()

            self.credentials.create(
                user_id=user.id,
                password_hash=hash_password(password),
            )

            self.db.commit()
            self.db.refresh(user)
            return user
        except IntegrityError as exc:
            self.db.rollback()
            raise UserAlreadyExistsError from exc
        except Exception:
            self.db.rollback()
            raise
