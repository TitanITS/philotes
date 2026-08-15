import uuid
from dataclasses import dataclass

from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from sqlalchemy.orm import Session

from ..core.database import get_db
from ..models.user import User
from ..services.auth_service import AuthenticationService, InvalidCredentialsError
from .tokens import AccessTokenError, decode_access_token


bearer_scheme = HTTPBearer(auto_error=False)


@dataclass(frozen=True)
class AuthenticatedSession:
    user: User
    session_id: uuid.UUID


def get_authenticated_session(
    credentials: HTTPAuthorizationCredentials | None = Depends(bearer_scheme),
    db: Session = Depends(get_db),
) -> AuthenticatedSession:
    unauthorized = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Authentication required.",
        headers={"WWW-Authenticate": "Bearer"},
    )

    if credentials is None or credentials.scheme.lower() != "bearer":
        raise unauthorized

    try:
        user_id, session_id = decode_access_token(credentials.credentials)
        user = AuthenticationService(db).get_session_user(
            user_id,
            session_id,
        )
        return AuthenticatedSession(
            user=user,
            session_id=session_id,
        )
    except (AccessTokenError, InvalidCredentialsError) as exc:
        raise unauthorized from exc


def get_current_user(
    authenticated: AuthenticatedSession = Depends(get_authenticated_session),
) -> User:
    return authenticated.user


def get_verified_user(
    current_user: User = Depends(get_current_user),
) -> User:
    if not current_user.email_verified:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Email verification required.",
        )

    return current_user
