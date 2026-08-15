from pathlib import Path
from datetime import datetime

SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = SCRIPT_DIR.parent.parent
BACKEND_ROOT = PROJECT_ROOT / "backend"
APP_ROOT = BACKEND_ROOT / "app"
TEST_ROOT = BACKEND_ROOT / "tests"
ALEMBIC_ROOT = BACKEND_ROOT / "alembic"
ALEMBIC_INI = BACKEND_ROOT / "alembic.ini"
REPORT_FILE = SCRIPT_DIR / "backendpatchscript_report.txt"

FILES = {
    APP_ROOT / "__init__.py": "",
    APP_ROOT / "api" / "__init__.py": "",
    APP_ROOT / "api" / "routes" / "__init__.py": "",
    APP_ROOT / "core" / "__init__.py": "",
    APP_ROOT / "models" / "__init__.py": """from .user import User
from .user_credential import UserCredential
from .user_session import UserSession


__all__ = ["User", "UserCredential", "UserSession"]
""",
    APP_ROOT / "repositories" / "__init__.py": """from .user_credential_repository import UserCredentialRepository
from .user_repository import UserRepository
from .user_session_repository import UserSessionRepository


__all__ = [
    "UserCredentialRepository",
    "UserRepository",
    "UserSessionRepository",
]
""",
    APP_ROOT / "schemas" / "__init__.py": """from .auth import (
    LoginRequest,
    LogoutRequest,
    RefreshRequest,
    RegistrationRequest,
    TokenResponse,
)
from .user import UserCreate, UserResponse


__all__ = [
    "LoginRequest",
    "LogoutRequest",
    "RefreshRequest",
    "RegistrationRequest",
    "TokenResponse",
    "UserCreate",
    "UserResponse",
]
""",
    APP_ROOT / "security" / "__init__.py": """from .passwords import hash_password, verify_password
from .tokens import (
    create_access_token,
    create_refresh_token,
    decode_access_token,
    hash_refresh_token,
)


__all__ = [
    "create_access_token",
    "create_refresh_token",
    "decode_access_token",
    "hash_password",
    "hash_refresh_token",
    "verify_password",
]
""",
    APP_ROOT / "services" / "__init__.py": """from .auth_service import (
    AuthenticationService,
    InactiveUserError,
    InvalidCredentialsError,
    InvalidRefreshTokenError,
)
from .user_service import UserAlreadyExistsError, UserNotFoundError, UserService


__all__ = [
    "AuthenticationService",
    "InactiveUserError",
    "InvalidCredentialsError",
    "InvalidRefreshTokenError",
    "UserAlreadyExistsError",
    "UserNotFoundError",
    "UserService",
]
""",
    TEST_ROOT / "__init__.py": "",
    BACKEND_ROOT / ".env.example": """PHILOTES_APP_NAME=Philotes API
PHILOTES_ENVIRONMENT=development
PHILOTES_DATABASE_URL=postgresql+psycopg://philotes_app:CHANGE_ME@localhost:5432/philotes_dev
PHILOTES_JWT_SECRET_KEY=CHANGE_ME_WITH_A_RANDOM_SECRET
PHILOTES_JWT_ALGORITHM=HS256
PHILOTES_JWT_ISSUER=philotes-api
PHILOTES_ACCESS_TOKEN_EXPIRE_MINUTES=15
PHILOTES_SESSION_EXPIRE_DAYS=30
""",
    APP_ROOT / "core" / "config.py": """from pathlib import Path

from pydantic_settings import BaseSettings, SettingsConfigDict


BACKEND_ROOT = Path(__file__).resolve().parents[2]


class Settings(BaseSettings):
    app_name: str = "Philotes API"
    environment: str = "development"
    api_v1_prefix: str = "/api/v1"
    database_url: str
    jwt_secret_key: str
    jwt_algorithm: str = "HS256"
    jwt_issuer: str = "philotes-api"
    access_token_expire_minutes: int = 15
    session_expire_days: int = 30

    model_config = SettingsConfigDict(
        env_file=str(BACKEND_ROOT / ".env"),
        env_file_encoding="utf-8",
        env_prefix="PHILOTES_",
        extra="ignore",
    )


settings = Settings()
""",
    APP_ROOT / "core" / "database.py": """from sqlalchemy import create_engine
from sqlalchemy.orm import Session, sessionmaker

from .config import settings


engine = create_engine(
    settings.database_url,
    pool_pre_ping=True,
)

SessionLocal = sessionmaker(
    bind=engine,
    autoflush=False,
    autocommit=False,
    expire_on_commit=False,
    class_=Session,
)


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
""",
    APP_ROOT / "models" / "base.py": """from sqlalchemy.orm import DeclarativeBase


class Base(DeclarativeBase):
    pass
""",
    APP_ROOT / "models" / "user.py": """import uuid
from datetime import datetime

from sqlalchemy import Boolean, DateTime, String, Uuid, func
from sqlalchemy.orm import Mapped, mapped_column

from .base import Base


class User(Base):
    __tablename__ = "users"

    id: Mapped[uuid.UUID] = mapped_column(
        Uuid,
        primary_key=True,
        default=uuid.uuid4,
    )
    email: Mapped[str] = mapped_column(
        String(320),
        nullable=False,
        unique=True,
        index=True,
    )
    email_verified: Mapped[bool] = mapped_column(
        Boolean,
        nullable=False,
        default=False,
        server_default="false",
    )
    is_active: Mapped[bool] = mapped_column(
        Boolean,
        nullable=False,
        default=True,
        server_default="true",
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
        onupdate=func.now(),
    )
""",
    APP_ROOT / "models" / "user_credential.py": """import uuid
from datetime import datetime

from sqlalchemy import DateTime, ForeignKey, String, Uuid, func
from sqlalchemy.orm import Mapped, mapped_column

from .base import Base


class UserCredential(Base):
    __tablename__ = "user_credentials"

    user_id: Mapped[uuid.UUID] = mapped_column(
        Uuid,
        ForeignKey("users.id", ondelete="CASCADE"),
        primary_key=True,
    )
    password_hash: Mapped[str] = mapped_column(
        String(512),
        nullable=False,
    )
    password_changed_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
        onupdate=func.now(),
    )
""",
    APP_ROOT / "security" / "passwords.py": """from pwdlib import PasswordHash


_password_hash = PasswordHash.recommended()


def hash_password(password: str) -> str:
    return _password_hash.hash(password)


def verify_password(password: str, password_hash: str) -> bool:
    return _password_hash.verify(password, password_hash)
""",
    APP_ROOT / "models" / "user_session.py": """import uuid
from datetime import datetime

from sqlalchemy import DateTime, ForeignKey, String, Uuid, func
from sqlalchemy.orm import Mapped, mapped_column

from .base import Base


class UserSession(Base):
    __tablename__ = "user_sessions"

    id: Mapped[uuid.UUID] = mapped_column(
        Uuid,
        primary_key=True,
        default=uuid.uuid4,
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        Uuid,
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    refresh_token_hash: Mapped[str] = mapped_column(
        String(64),
        nullable=False,
        unique=True,
        index=True,
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
    )
    last_used_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
    )
    expires_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
    )
    revoked_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True),
        nullable=True,
    )
""",
    APP_ROOT / "security" / "tokens.py": """import hashlib
import secrets
import uuid
from datetime import datetime, timedelta, timezone

import jwt
from jwt.exceptions import InvalidTokenError

from ..core.config import settings


class AccessTokenError(Exception):
    pass


def create_refresh_token() -> str:
    return secrets.token_urlsafe(48)


def hash_refresh_token(token: str) -> str:
    return hashlib.sha256(token.encode("utf-8")).hexdigest()


def create_access_token(
    user_id: uuid.UUID,
    session_id: uuid.UUID,
) -> tuple[str, int]:
    expires_in = settings.access_token_expire_minutes * 60
    now = datetime.now(timezone.utc)
    payload = {
        "sub": str(user_id),
        "sid": str(session_id),
        "type": "access",
        "iss": settings.jwt_issuer,
        "iat": now,
        "exp": now + timedelta(seconds=expires_in),
    }

    token = jwt.encode(
        payload,
        settings.jwt_secret_key,
        algorithm=settings.jwt_algorithm,
    )
    return token, expires_in


def decode_access_token(token: str) -> tuple[uuid.UUID, uuid.UUID]:
    try:
        payload = jwt.decode(
            token,
            settings.jwt_secret_key,
            algorithms=[settings.jwt_algorithm],
            issuer=settings.jwt_issuer,
            options={
                "require": ["exp", "iat", "iss", "sub", "sid", "type"],
            },
        )

        if payload.get("type") != "access":
            raise AccessTokenError

        user_id = uuid.UUID(payload["sub"])
        session_id = uuid.UUID(payload["sid"])
        return user_id, session_id
    except (InvalidTokenError, KeyError, TypeError, ValueError) as exc:
        raise AccessTokenError from exc
""",
    APP_ROOT / "schemas" / "auth.py": """from pydantic import BaseModel, EmailStr, Field


class RegistrationRequest(BaseModel):
    email: EmailStr
    password: str = Field(
        min_length=15,
        max_length=128,
    )


class LoginRequest(BaseModel):
    email: EmailStr
    password: str = Field(
        min_length=1,
        max_length=128,
    )


class RefreshRequest(BaseModel):
    refresh_token: str = Field(
        min_length=32,
        max_length=512,
    )


class LogoutRequest(BaseModel):
    refresh_token: str = Field(
        min_length=32,
        max_length=512,
    )


class TokenResponse(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str = "bearer"
    expires_in: int
""",
    APP_ROOT / "schemas" / "user.py": """import uuid
from datetime import datetime

from pydantic import BaseModel, ConfigDict, EmailStr


class UserCreate(BaseModel):
    email: EmailStr


class UserResponse(BaseModel):
    id: uuid.UUID
    email: EmailStr
    email_verified: bool
    is_active: bool
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)
""",
    APP_ROOT / "repositories" / "user_repository.py": """import uuid

from sqlalchemy import select
from sqlalchemy.orm import Session

from ..models.user import User


class UserRepository:
    def __init__(self, db: Session) -> None:
        self.db = db

    def get_by_id(self, user_id: uuid.UUID) -> User | None:
        return self.db.get(User, user_id)

    def get_by_email(self, email: str) -> User | None:
        statement = select(User).where(User.email == email)
        return self.db.scalars(statement).first()

    def create(self, email: str) -> User:
        user = User(email=email)
        self.db.add(user)
        self.db.commit()
        self.db.refresh(user)
        return user
""",
    APP_ROOT / "repositories" / "user_credential_repository.py": """import uuid

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
""",
    APP_ROOT / "repositories" / "user_session_repository.py": """import uuid
from datetime import datetime

from sqlalchemy import select
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
""",
    APP_ROOT / "services" / "user_service.py": """import uuid

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
""",
    APP_ROOT / "services" / "auth_service.py": """import uuid
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
from .user_service import UserAlreadyExistsError, UserService


class InvalidCredentialsError(Exception):
    pass


class InactiveUserError(Exception):
    pass


class InvalidRefreshTokenError(Exception):
    pass


class AuthenticationService:
    def __init__(self, db: Session) -> None:
        self.db = db
        self.users = UserRepository(db)
        self.credentials = UserCredentialRepository(db)
        self.sessions = UserSessionRepository(db)

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

    def login(self, email: str, password: str) -> tuple[User, str, str, int]:
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
""",
    APP_ROOT / "security" / "authentication.py": """from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from sqlalchemy.orm import Session

from ..core.database import get_db
from ..models.user import User
from ..services.auth_service import AuthenticationService, InvalidCredentialsError
from .tokens import AccessTokenError, decode_access_token


bearer_scheme = HTTPBearer(auto_error=False)


def get_current_user(
    credentials: HTTPAuthorizationCredentials | None = Depends(bearer_scheme),
    db: Session = Depends(get_db),
) -> User:
    unauthorized = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Authentication required.",
        headers={"WWW-Authenticate": "Bearer"},
    )

    if credentials is None or credentials.scheme.lower() != "bearer":
        raise unauthorized

    try:
        user_id, session_id = decode_access_token(credentials.credentials)
        return AuthenticationService(db).get_session_user(
            user_id,
            session_id,
        )
    except (AccessTokenError, InvalidCredentialsError) as exc:
        raise unauthorized from exc
""",
    APP_ROOT / "api" / "routes" / "auth.py": """from fastapi import APIRouter, Depends, HTTPException, Response, status
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy.orm import Session

from ...core.database import get_db
from ...schemas.auth import (
    LoginRequest,
    LogoutRequest,
    RefreshRequest,
    RegistrationRequest,
    TokenResponse,
)
from ...schemas.user import UserResponse
from ...security.authentication import get_current_user
from ...services.auth_service import (
    AuthenticationService,
    InactiveUserError,
    InvalidCredentialsError,
    InvalidRefreshTokenError,
)
from ...services.user_service import UserAlreadyExistsError
from ...models.user import User


router = APIRouter(
    prefix="/auth",
    tags=["Authentication"],
)


@router.post(
    "/register",
    response_model=UserResponse,
    status_code=status.HTTP_201_CREATED,
)
def register(
    payload: RegistrationRequest,
    db: Session = Depends(get_db),
) -> UserResponse:
    service = AuthenticationService(db)

    try:
        return service.register(
            email=str(payload.email),
            password=payload.password,
        )
    except UserAlreadyExistsError as exc:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="An account with that email already exists.",
        ) from exc
    except SQLAlchemyError as exc:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Database unavailable",
        ) from exc


@router.post(
    "/login",
    response_model=TokenResponse,
)
def login(
    payload: LoginRequest,
    db: Session = Depends(get_db),
) -> TokenResponse:
    service = AuthenticationService(db)

    try:
        _, access_token, refresh_token, expires_in = service.login(
            email=str(payload.email),
            password=payload.password,
        )
        return TokenResponse(
            access_token=access_token,
            refresh_token=refresh_token,
            expires_in=expires_in,
        )
    except InvalidCredentialsError as exc:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid email or password.",
        ) from exc
    except InactiveUserError as exc:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Account is inactive.",
        ) from exc
    except SQLAlchemyError as exc:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Database unavailable",
        ) from exc


@router.post(
    "/refresh",
    response_model=TokenResponse,
)
def refresh(
    payload: RefreshRequest,
    db: Session = Depends(get_db),
) -> TokenResponse:
    try:
        access_token, refresh_token, expires_in = AuthenticationService(
            db
        ).refresh(payload.refresh_token)
        return TokenResponse(
            access_token=access_token,
            refresh_token=refresh_token,
            expires_in=expires_in,
        )
    except InvalidRefreshTokenError as exc:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired refresh token.",
        ) from exc


@router.post(
    "/logout",
    status_code=status.HTTP_204_NO_CONTENT,
)
def logout(
    payload: LogoutRequest,
    db: Session = Depends(get_db),
) -> Response:
    AuthenticationService(db).logout(payload.refresh_token)
    return Response(status_code=status.HTTP_204_NO_CONTENT)


@router.get(
    "/me",
    response_model=UserResponse,
)
def me(
    current_user: User = Depends(get_current_user),
) -> UserResponse:
    return current_user
""",
    APP_ROOT / "api" / "routes" / "users.py": """import uuid

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy.orm import Session

from ...core.database import get_db
from ...schemas.user import UserCreate, UserResponse
from ...services.user_service import (
    UserAlreadyExistsError,
    UserNotFoundError,
    UserService,
)


router = APIRouter(
    prefix="/users",
    tags=["Users"],
)


@router.post(
    "",
    response_model=UserResponse,
    status_code=status.HTTP_201_CREATED,
)
def create_user(
    payload: UserCreate,
    db: Session = Depends(get_db),
) -> UserResponse:
    service = UserService(db)

    try:
        return service.create_user(str(payload.email))
    except UserAlreadyExistsError as exc:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="An account with that email already exists.",
        ) from exc
    except SQLAlchemyError as exc:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Database unavailable",
        ) from exc


@router.get(
    "/{user_id}",
    response_model=UserResponse,
)
def get_user(
    user_id: uuid.UUID,
    db: Session = Depends(get_db),
) -> UserResponse:
    service = UserService(db)

    try:
        return service.get_user(user_id)
    except UserNotFoundError as exc:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found.",
        ) from exc
    except SQLAlchemyError as exc:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Database unavailable",
        ) from exc
""",
    APP_ROOT / "api" / "routes" / "health.py": """from fastapi import APIRouter, HTTPException
from sqlalchemy import text
from sqlalchemy.exc import SQLAlchemyError

from ...core.config import settings
from ...core.database import engine


router = APIRouter()


@router.get("/health", tags=["Health"])
def health_check() -> dict[str, str]:
    return {
        "status": "healthy",
        "service": settings.app_name,
    }


@router.get("/health/database", tags=["Health"])
def database_health_check() -> dict[str, str]:
    try:
        with engine.connect() as connection:
            connection.execute(text("SELECT 1"))
    except SQLAlchemyError as exc:
        raise HTTPException(
            status_code=503,
            detail="Database unavailable",
        ) from exc

    return {
        "status": "healthy",
        "service": settings.app_name,
        "database": "connected",
    }
""",
    APP_ROOT / "api" / "router.py": """from fastapi import APIRouter

from .routes.auth import router as auth_router
from .routes.health import router as health_router
from .routes.users import router as users_router


api_router = APIRouter()
api_router.include_router(auth_router)
api_router.include_router(health_router)
api_router.include_router(users_router)
""",
    APP_ROOT / "main.py": """from fastapi import FastAPI

from .api.router import api_router
from .core.config import settings


def create_app() -> FastAPI:
    app = FastAPI(
        title=settings.app_name,
        version="0.1.0",
    )

    app.include_router(
        api_router,
        prefix=settings.api_v1_prefix,
    )

    return app


app = create_app()
""",
    ALEMBIC_ROOT / "env.py": """from logging.config import fileConfig

from alembic import context

from app.core.config import settings
from app.core.database import engine
from app.models.base import Base
from app.models.user import User
from app.models.user_credential import UserCredential
from app.models.user_session import UserSession


config = context.config

if config.config_file_name is not None:
    fileConfig(config.config_file_name)

_ = (User, UserCredential, UserSession)
target_metadata = Base.metadata


def run_migrations_offline() -> None:
    context.configure(
        url=settings.database_url,
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
        compare_type=True,
    )

    with context.begin_transaction():
        context.run_migrations()


def run_migrations_online() -> None:
    with engine.connect() as connection:
        context.configure(
            connection=connection,
            target_metadata=target_metadata,
            compare_type=True,
        )

        with context.begin_transaction():
            context.run_migrations()


if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()
""",
    TEST_ROOT / "test_health.py": """from fastapi.testclient import TestClient

from app.main import app


client = TestClient(app)


def test_health_endpoint() -> None:
    response = client.get("/api/v1/health")

    assert response.status_code == 200
    assert response.json() == {
        "status": "healthy",
        "service": "Philotes API",
    }


def test_database_health_endpoint() -> None:
    response = client.get("/api/v1/health/database")

    assert response.status_code == 200
    assert response.json() == {
        "status": "healthy",
        "service": "Philotes API",
        "database": "connected",
    }
""",
    TEST_ROOT / "test_database_foundation.py": """from app.models.base import Base
from app.models.user import User


def test_sqlalchemy_base_exists() -> None:
    assert Base.metadata is not None


def test_user_model_registered() -> None:
    assert User.__tablename__ == "users"
    assert "users" in Base.metadata.tables


def test_user_model_identity_columns() -> None:
    expected = {
        "id",
        "email",
        "email_verified",
        "is_active",
        "created_at",
        "updated_at",
    }
    assert set(User.__table__.columns.keys()) == expected
    assert User.__table__.c.email.unique is True
    assert User.__table__.c.email.index is True
""",
    TEST_ROOT / "test_users.py": """import uuid

from fastapi.testclient import TestClient
from sqlalchemy import delete

from app.core.database import SessionLocal
from app.main import app
from app.models.user import User


client = TestClient(app)


def _cleanup_email(email: str) -> None:
    with SessionLocal() as db:
        db.execute(delete(User).where(User.email == email))
        db.commit()


def test_create_and_get_user() -> None:
    email = f"account-{uuid.uuid4()}@EXAMPLE.COM"
    normalized = email.lower()

    try:
        create_response = client.post(
            "/api/v1/users",
            json={"email": email},
        )

        assert create_response.status_code == 201
        created = create_response.json()
        assert created["email"] == normalized
        assert created["email_verified"] is False
        assert created["is_active"] is True

        user_id = created["id"]

        get_response = client.get(
            f"/api/v1/users/{user_id}",
        )

        assert get_response.status_code == 200
        assert get_response.json()["id"] == user_id
        assert get_response.json()["email"] == normalized
    finally:
        _cleanup_email(normalized)


def test_duplicate_email_is_rejected() -> None:
    email = f"duplicate-{uuid.uuid4()}@example.com"

    try:
        first = client.post(
            "/api/v1/users",
            json={"email": email},
        )
        assert first.status_code == 201

        duplicate = client.post(
            "/api/v1/users",
            json={"email": email.upper()},
        )

        assert duplicate.status_code == 409
        assert duplicate.json() == {
            "detail": "An account with that email already exists."
        }
    finally:
        _cleanup_email(email)


def test_invalid_email_is_rejected() -> None:
    response = client.post(
        "/api/v1/users",
        json={"email": "not-an-email"},
    )

    assert response.status_code == 422


def test_unknown_user_returns_404() -> None:
    response = client.get(
        f"/api/v1/users/{uuid.uuid4()}",
    )

    assert response.status_code == 404
    assert response.json() == {
        "detail": "User not found."
    }
""",
    TEST_ROOT / "test_auth_foundation.py": """import uuid

from fastapi.testclient import TestClient
from sqlalchemy import delete, select

from app.core.database import SessionLocal
from app.main import app
from app.models.user import User
from app.models.user_credential import UserCredential
from app.security.passwords import hash_password, verify_password


client = TestClient(app)


def _cleanup_email(email: str) -> None:
    with SessionLocal() as db:
        user = db.scalars(
            select(User).where(User.email == email)
        ).first()
        if user is not None:
            db.execute(
                delete(UserCredential).where(
                    UserCredential.user_id == user.id
                )
            )
            db.delete(user)
            db.commit()


def test_password_hash_round_trip() -> None:
    password = "correct horse battery staple"
    password_hash = hash_password(password)

    assert password_hash != password
    assert verify_password(password, password_hash) is True
    assert verify_password("wrong password", password_hash) is False


def test_registration_creates_user_and_credential() -> None:
    email = f"registration-{uuid.uuid4()}@EXAMPLE.COM"
    normalized = email.lower()
    password = "a secure development password"

    try:
        response = client.post(
            "/api/v1/auth/register",
            json={
                "email": email,
                "password": password,
            },
        )

        assert response.status_code == 201
        body = response.json()
        assert body["email"] == normalized
        assert "password" not in body
        assert "password_hash" not in body

        with SessionLocal() as db:
            user = db.scalars(
                select(User).where(User.email == normalized)
            ).one()
            credential = db.get(UserCredential, user.id)

            assert credential is not None
            assert credential.password_hash != password
            assert verify_password(
                password,
                credential.password_hash,
            ) is True
    finally:
        _cleanup_email(normalized)


def test_registration_rejects_short_password() -> None:
    response = client.post(
        "/api/v1/auth/register",
        json={
            "email": f"short-{uuid.uuid4()}@example.com",
            "password": "too-short",
        },
    )

    assert response.status_code == 422


def test_registration_rejects_duplicate_email() -> None:
    email = f"auth-duplicate-{uuid.uuid4()}@example.com"
    password = "another secure development password"

    try:
        first = client.post(
            "/api/v1/auth/register",
            json={"email": email, "password": password},
        )
        assert first.status_code == 201

        duplicate = client.post(
            "/api/v1/auth/register",
            json={"email": email.upper(), "password": password},
        )
        assert duplicate.status_code == 409
    finally:
        _cleanup_email(email)
""",
    TEST_ROOT / "test_auth_sessions.py": """import uuid

from fastapi.testclient import TestClient
from sqlalchemy import delete, select

from app.core.database import SessionLocal
from app.main import app
from app.models.user import User
from app.models.user_session import UserSession


client = TestClient(app)


def _cleanup_email(email: str) -> None:
    with SessionLocal() as db:
        user = db.scalars(
            select(User).where(User.email == email)
        ).first()
        if user is not None:
            db.execute(
                delete(UserSession).where(
                    UserSession.user_id == user.id
                )
            )
            db.delete(user)
            db.commit()


def _register(email: str, password: str) -> None:
    response = client.post(
        "/api/v1/auth/register",
        json={"email": email, "password": password},
    )
    assert response.status_code == 201


def test_login_me_refresh_logout_flow() -> None:
    email = f"session-{uuid.uuid4()}@example.com"
    password = "session development password"
    try:
        _register(email, password)

        login = client.post(
            "/api/v1/auth/login",
            json={"email": email, "password": password},
        )
        assert login.status_code == 200
        tokens = login.json()
        assert tokens["token_type"] == "bearer"
        assert tokens["expires_in"] == 900

        me = client.get(
            "/api/v1/auth/me",
            headers={
                "Authorization": f"Bearer {tokens['access_token']}"
            },
        )
        assert me.status_code == 200
        assert me.json()["email"] == email

        refreshed = client.post(
            "/api/v1/auth/refresh",
            json={"refresh_token": tokens["refresh_token"]},
        )
        assert refreshed.status_code == 200
        new_tokens = refreshed.json()
        assert new_tokens["refresh_token"] != tokens["refresh_token"]

        old_refresh = client.post(
            "/api/v1/auth/refresh",
            json={"refresh_token": tokens["refresh_token"]},
        )
        assert old_refresh.status_code == 401

        logout = client.post(
            "/api/v1/auth/logout",
            json={"refresh_token": new_tokens["refresh_token"]},
        )
        assert logout.status_code == 204

        revoked_me = client.get(
            "/api/v1/auth/me",
            headers={
                "Authorization": f"Bearer {new_tokens['access_token']}"
            },
        )
        assert revoked_me.status_code == 401
    finally:
        _cleanup_email(email)


def test_login_rejects_bad_password_without_email_disclosure() -> None:
    email = f"bad-login-{uuid.uuid4()}@example.com"
    password = "correct development password"
    try:
        _register(email, password)

        wrong_password = client.post(
            "/api/v1/auth/login",
            json={
                "email": email,
                "password": "incorrect development password",
            },
        )
        missing_email = client.post(
            "/api/v1/auth/login",
            json={
                "email": f"missing-{uuid.uuid4()}@example.com",
                "password": "incorrect development password",
            },
        )

        assert wrong_password.status_code == 401
        assert missing_email.status_code == 401
        assert wrong_password.json() == missing_email.json()
        assert wrong_password.json() == {
            "detail": "Invalid email or password."
        }
    finally:
        _cleanup_email(email)


def test_me_requires_bearer_token() -> None:
    response = client.get("/api/v1/auth/me")
    assert response.status_code == 401
""",
}


def main() -> None:
    print()
    print("=" * 76)
    print("PHILOTES BACKEND AUTHENTICATION V2")
    print("=" * 76)
    print()

    required_dirs = [
        BACKEND_ROOT,
        APP_ROOT,
        APP_ROOT / "api",
        APP_ROOT / "api" / "routes",
        APP_ROOT / "core",
        APP_ROOT / "models",
        APP_ROOT / "repositories",
        APP_ROOT / "schemas",
        APP_ROOT / "security",
        APP_ROOT / "services",
        TEST_ROOT,
        ALEMBIC_ROOT,
        ALEMBIC_ROOT / "versions",
    ]

    for path in required_dirs:
        if not path.exists():
            print(f"FAIL: Required folder not found: {path}")
            raise SystemExit(1)

    if not ALEMBIC_INI.exists():
        print(f"FAIL: Alembic configuration not found: {ALEMBIC_INI}")
        print("Run Alembic initialization before this patch.")
        raise SystemExit(1)

    originals: dict[Path, str | None] = {}
    for path in FILES:
        originals[path] = path.read_text(encoding="utf-8") if path.exists() else None

    try:
        for path, content in FILES.items():
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(content, encoding="utf-8")
    except Exception as exc:
        for path, original in originals.items():
            if original is None:
                if path.exists():
                    path.unlink()
            else:
                path.write_text(original, encoding="utf-8")

        print()
        print(f"FAIL: {exc}")
        print("Existing backend files restored.")
        raise SystemExit(1)

    alembic_ini_text = ALEMBIC_INI.read_text(encoding="utf-8")
    env_text = (ALEMBIC_ROOT / "env.py").read_text(encoding="utf-8")
    base_text = (APP_ROOT / "models" / "base.py").read_text(encoding="utf-8")

    checks = {
        "FastAPI app created": "FastAPI(" in (APP_ROOT / "main.py").read_text(encoding="utf-8"),
        "API v1 prefix configured": "/api/v1" in (APP_ROOT / "core" / "config.py").read_text(encoding="utf-8"),
        "Health endpoint created": 'router.get("/health"' in (APP_ROOT / "api" / "routes" / "health.py").read_text(encoding="utf-8"),
        "Database engine configured": "create_engine(" in (APP_ROOT / "core" / "database.py").read_text(encoding="utf-8"),
        "Environment prefix configured": 'env_prefix="PHILOTES_"' in (APP_ROOT / "core" / "config.py").read_text(encoding="utf-8"),
        "Backend .env path configured": 'BACKEND_ROOT / ".env"' in (APP_ROOT / "core" / "config.py").read_text(encoding="utf-8"),
        "Safe .env example created": (BACKEND_ROOT / ".env.example").exists(),
        "Database health endpoint created": 'router.get("/health/database"' in (APP_ROOT / "api" / "routes" / "health.py").read_text(encoding="utf-8"),
        "Database SELECT 1 check configured": 'text("SELECT 1")' in (APP_ROOT / "api" / "routes" / "health.py").read_text(encoding="utf-8"),
        "SQLAlchemy DeclarativeBase created": "class Base(DeclarativeBase)" in base_text,
        "User model created": (APP_ROOT / "models" / "user.py").exists(),
        "User table named users": '__tablename__ = "users"' in (APP_ROOT / "models" / "user.py").read_text(encoding="utf-8"),
        "User model uses UUID identity": "Mapped[uuid.UUID]" in (APP_ROOT / "models" / "user.py").read_text(encoding="utf-8"),
        "User email is unique": "unique=True" in (APP_ROOT / "models" / "user.py").read_text(encoding="utf-8"),
        "Alembic initialized": "script_location" in alembic_ini_text,
        "Alembic uses application settings": "settings.database_url" in env_text,
        "Alembic uses application engine": "from app.core.database import engine" in env_text,
        "Alembic target metadata configured": "target_metadata = Base.metadata" in env_text,
        "Alembic imports User model": "from app.models.user import User" in env_text,
        "Alembic avoids hard-coded database password": "driver://user:pass" not in env_text,
        "Database foundation test created": "test_sqlalchemy_base_exists" in (TEST_ROOT / "test_database_foundation.py").read_text(encoding="utf-8"),
        "User model tests created": "test_user_model_registered" in (TEST_ROOT / "test_database_foundation.py").read_text(encoding="utf-8"),
        "User request/response schemas created": (APP_ROOT / "schemas" / "user.py").exists(),
        "User repository created": (APP_ROOT / "repositories" / "user_repository.py").exists(),
        "User service created": (APP_ROOT / "services" / "user_service.py").exists(),
        "Users API route created": (APP_ROOT / "api" / "routes" / "users.py").exists(),
        "Users router registered": "include_router(users_router)" in (APP_ROOT / "api" / "router.py").read_text(encoding="utf-8"),
        "Email validation configured": "EmailStr" in (APP_ROOT / "schemas" / "user.py").read_text(encoding="utf-8"),
        "Email normalization configured": "email.strip().lower()" in (APP_ROOT / "services" / "user_service.py").read_text(encoding="utf-8"),
        "Duplicate email conflict configured": "HTTP_409_CONFLICT" in (APP_ROOT / "api" / "routes" / "users.py").read_text(encoding="utf-8"),
        "Unknown user 404 configured": "HTTP_404_NOT_FOUND" in (APP_ROOT / "api" / "routes" / "users.py").read_text(encoding="utf-8"),
        "Account API tests created": (TEST_ROOT / "test_users.py").exists(),
        "UserCredential model created": (APP_ROOT / "models" / "user_credential.py").exists(),
        "Password hashing service created": (APP_ROOT / "security" / "passwords.py").exists(),
        "Registration schema created": (APP_ROOT / "schemas" / "auth.py").exists(),
        "Authentication service created": (APP_ROOT / "services" / "auth_service.py").exists(),
        "Registration API route created": (APP_ROOT / "api" / "routes" / "auth.py").exists(),
        "Authentication router registered": "include_router(auth_router)" in (APP_ROOT / "api" / "router.py").read_text(encoding="utf-8"),
        "Password minimum length configured": "min_length=15" in (APP_ROOT / "schemas" / "auth.py").read_text(encoding="utf-8"),
        "Argon2-ready pwdlib hashing configured": "PasswordHash.recommended()" in (APP_ROOT / "security" / "passwords.py").read_text(encoding="utf-8"),
        "Alembic imports UserCredential": "from app.models.user_credential import UserCredential" in env_text,
        "Authentication foundation tests created": (TEST_ROOT / "test_auth_foundation.py").exists(),
        "UserSession model created": (APP_ROOT / "models" / "user_session.py").exists(),
        "UserSession table named user_sessions": '__tablename__ = "user_sessions"' in (APP_ROOT / "models" / "user_session.py").read_text(encoding="utf-8"),
        "Refresh tokens stored as hashes": "refresh_token_hash" in (APP_ROOT / "models" / "user_session.py").read_text(encoding="utf-8"),
        "JWT access-token service created": (APP_ROOT / "security" / "tokens.py").exists(),
        "Bearer current-user dependency created": (APP_ROOT / "security" / "authentication.py").exists(),
        "Login endpoint created": '"/login"' in (APP_ROOT / "api" / "routes" / "auth.py").read_text(encoding="utf-8"),
        "Refresh endpoint created": '"/refresh"' in (APP_ROOT / "api" / "routes" / "auth.py").read_text(encoding="utf-8"),
        "Logout endpoint created": '"/logout"' in (APP_ROOT / "api" / "routes" / "auth.py").read_text(encoding="utf-8"),
        "Current-user endpoint created": '"/me"' in (APP_ROOT / "api" / "routes" / "auth.py").read_text(encoding="utf-8"),
        "Access token lifetime configured": "access_token_expire_minutes: int = 15" in (APP_ROOT / "core" / "config.py").read_text(encoding="utf-8"),
        "Session lifetime configured": "session_expire_days: int = 30" in (APP_ROOT / "core" / "config.py").read_text(encoding="utf-8"),
        "Alembic imports UserSession": "from app.models.user_session import UserSession" in env_text,
        "Authentication session tests created": (TEST_ROOT / "test_auth_sessions.py").exists(),
    }

    passed = True
    report = [
        "PHILOTES BACKEND AUTHENTICATION V2 REPORT",
        "=" * 76,
        "Generated: " + datetime.now().isoformat(timespec="seconds"),
        "",
    ]

    for description, result in checks.items():
        status = "PASS" if result else "FAIL"
        print(f"{status}: {description}")
        report.append(f"{status}: {description}")
        if not result:
            passed = False

    report.extend([
        "",
        "OVERALL: " + ("PASS" if passed else "FAIL"),
        "",
        "DATABASE FOUNDATION CONTRACT",
        "- Backend framework: FastAPI",
        "- ORM: SQLAlchemy 2.x DeclarativeBase",
        "- Database target: PostgreSQL",
        "- PostgreSQL driver: Psycopg 3",
        "- Migration system: Alembic",
        "- Alembic reads the same backend/.env configuration as FastAPI.",
        "- Alembic target metadata is Base.metadata.",
        "- Database credentials are not stored in alembic.ini or generated source.",
        "- API prefix: /api/v1",
        "- Application health endpoint: /api/v1/health",
        "- Database health endpoint: /api/v1/health/database",
        "- Authentication Foundation V1 adds password hashing and credential storage.",
        "- User fields are limited to identity/status/timestamps.",
        "- Password hashes are stored only in user_credentials; plaintext passwords are never stored or returned.",
        "- Login, bearer tokens, refresh sessions, email-verification delivery, password reset, and MFA are not implemented yet.",
        "- The user_credentials table is not created directly by this patch; Alembic will generate and apply the migration.",
    ])

    REPORT_FILE.write_text("\n".join(report) + "\n", encoding="utf-8")

    print()
    print(f"Report: {REPORT_FILE}")
    print()
    print("OVERALL: " + ("PASS" if passed else "FAIL"))

    if not passed:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
