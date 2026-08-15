import uuid

from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from ..models.user import User
from ..repositories.user_repository import UserRepository


class UserAlreadyExistsError(Exception):
    pass


class UserNotFoundError(Exception):
    pass


class UserService:
    def __init__(self, db: Session) -> None:
        self.db = db
        self.repository = UserRepository(db)

    @staticmethod
    def normalize_email(email: str) -> str:
        return email.strip().lower()

    def create_user(self, email: str) -> User:
        normalized_email = self.normalize_email(email)

        if self.repository.get_by_email(normalized_email) is not None:
            raise UserAlreadyExistsError

        try:
            return self.repository.create(normalized_email)
        except IntegrityError as exc:
            self.db.rollback()
            raise UserAlreadyExistsError from exc

    def get_user(self, user_id: uuid.UUID) -> User:
        user = self.repository.get_by_id(user_id)

        if user is None:
            raise UserNotFoundError

        return user
