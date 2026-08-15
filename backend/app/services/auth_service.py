import uuid
from datetime import datetime, timedelta, timezone

from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from ..core.config import settings
from ..models.user import User
from ..repositories.user_credential_repository import UserCredentialRepository
from ..repositories.user_repository import UserRepository
from ..repositories.user_session_repository import UserSessionRepository
from ..security.passwords import hash_password, verify_password
from ..security.tokens import (
    create_access_token,
    create_refresh_token,
    hash_refresh_token,
)
from .email_verification_service import EmailVerificationService
from .user_service import UserAlreadyExistsError, UserService


class InvalidCredentialsError(Exception):
    pass


class InactiveUserError(Exception):
    pass


class InvalidRefreshTokenError(Exception):
    pass


class InvalidCurrentPasswordError(Exception):
    pass


class PasswordReuseError(Exception):
    pass


class AuthenticationService:
    def __init__(self, db: Session) -> None:
        self.db = db
        self.users = UserRepository(db)
        self.credentials = UserCredentialRepository(db)
        self.sessions = UserSessionRepository(db)
        self.email_verifications = EmailVerificationService(db)

    def register(
        self,
        email: str,
        password: str,
    ) -> tuple[User, str]:
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
            verification_token = self.email_verifications.issue_token(
                user.id,
                commit=False,
            )

            self.db.commit()
            self.db.refresh(user)
            return user, verification_token
        except IntegrityError as exc:
            self.db.rollback()
            raise UserAlreadyExistsError from exc
        except Exception:
            self.db.rollback()
            raise

    def login(
        self,
        email: str,
        password: str,
        *,
        device_name: str | None = None,
        platform: str | None = None,
        client_name: str | None = None,
    ) -> tuple[User, str, str, int]:
        normalized_email = UserService.normalize_email(email)
        user = self.users.get_by_email(normalized_email)

        if user is None:
            raise InvalidCredentialsError

        credential = self.credentials.get_by_user_id(user.id)
        if credential is None or not verify_password(
            password,
            credential.password_hash,
        ):
            raise InvalidCredentialsError

        if not user.is_active:
            raise InactiveUserError

        refresh_token = create_refresh_token()
        expires_at = datetime.now(timezone.utc) + timedelta(
            days=settings.session_expire_days,
        )

        session = self.sessions.create(
            user_id=user.id,
            refresh_token_hash=hash_refresh_token(refresh_token),
            expires_at=expires_at,
            device_name=device_name,
            platform=platform,
            client_name=client_name,
        )
        self.db.commit()

        access_token, expires_in = create_access_token(
            user.id,
            session.id,
        )
        return user, access_token, refresh_token, expires_in

    def refresh(self, refresh_token: str) -> tuple[str, str, int]:
        now = datetime.now(timezone.utc)
        session = self.sessions.get_by_refresh_hash(
            hash_refresh_token(refresh_token)
        )

        if (
            session is None
            or session.revoked_at is not None
            or session.expires_at <= now
        ):
            raise InvalidRefreshTokenError

        user = self.users.get_by_id(session.user_id)
        if user is None or not user.is_active:
            raise InvalidRefreshTokenError

        new_refresh_token = create_refresh_token()
        session.refresh_token_hash = hash_refresh_token(new_refresh_token)
        session.last_used_at = now
        self.db.commit()

        access_token, expires_in = create_access_token(
            user.id,
            session.id,
        )
        return access_token, new_refresh_token, expires_in

    def logout(self, refresh_token: str) -> None:
        session = self.sessions.get_by_refresh_hash(
            hash_refresh_token(refresh_token)
        )

        if session is None:
            return

        if session.revoked_at is None:
            session.revoked_at = datetime.now(timezone.utc)
            self.db.commit()

    def change_password(
        self,
        *,
        user_id: uuid.UUID,
        current_password: str,
        new_password: str,
        device_name: str | None = None,
        platform: str | None = None,
        client_name: str | None = None,
    ) -> tuple[str, str, int]:
        credential = self.credentials.get_by_user_id(user_id)

        if credential is None or not verify_password(
            current_password,
            credential.password_hash,
        ):
            raise InvalidCurrentPasswordError

        if verify_password(
            new_password,
            credential.password_hash,
        ):
            raise PasswordReuseError

        now = datetime.now(timezone.utc)

        updated = self.credentials.update_password(
            user_id=user_id,
            password_hash=hash_password(new_password),
            changed_at=now,
        )
        if updated is None:
            raise InvalidCurrentPasswordError

        # A password change is a security boundary. Revoke every
        # pre-change session, including the session that submitted this
        # request, then create a replacement session for this device.
        self.sessions.revoke_all_for_user(user_id, now)

        new_refresh_token = create_refresh_token()
        replacement_session = self.sessions.create(
            user_id=user_id,
            refresh_token_hash=hash_refresh_token(new_refresh_token),
            expires_at=now + timedelta(
                days=settings.session_expire_days,
            ),
            device_name=device_name,
            platform=platform,
            client_name=client_name,
        )

        self.db.commit()

        access_token, expires_in = create_access_token(
            user_id,
            replacement_session.id,
        )
        return access_token, new_refresh_token, expires_in

    def get_session_user(
        self,
        user_id: uuid.UUID,
        session_id: uuid.UUID,
    ) -> User:
        now = datetime.now(timezone.utc)
        session = self.sessions.get_by_id(session_id)

        if (
            session is None
            or session.user_id != user_id
            or session.revoked_at is not None
            or session.expires_at <= now
        ):
            raise InvalidCredentialsError

        user = self.users.get_by_id(user_id)
        if user is None or not user.is_active:
            raise InvalidCredentialsError

        return user
