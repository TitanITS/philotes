from fastapi import Depends, HTTPException, status
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
