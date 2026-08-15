import uuid

from fastapi import APIRouter, Depends, HTTPException, Response, status
from sqlalchemy.orm import Session

from ...core.database import get_db
from ...schemas.session import SessionListResponse, SessionResponse
from ...security.authentication import (
    AuthenticatedSession,
    get_authenticated_session,
)
from ...services.session_service import (
    CurrentSessionRevocationError,
    SessionNotFoundError,
    SessionService,
)


router = APIRouter(
    prefix="/sessions",
    tags=["Sessions"],
)


@router.get(
    "",
    response_model=SessionListResponse,
)
def list_sessions(
    authenticated: AuthenticatedSession = Depends(
        get_authenticated_session
    ),
    db: Session = Depends(get_db),
) -> SessionListResponse:
    records = SessionService(db).list_active(
        user_id=authenticated.user.id,
        current_session_id=authenticated.session_id,
    )

    return SessionListResponse(
        sessions=[
            SessionResponse(
                id=session.id,
                device_name=session.device_name,
                platform=session.platform,
                client_name=session.client_name,
                signed_in_at=session.created_at,
                last_active_at=session.last_used_at,
                expires_at=session.expires_at,
                is_current=is_current,
            )
            for session, is_current in records
        ]
    )


@router.delete(
    "/{session_id}",
    status_code=status.HTTP_204_NO_CONTENT,
)
def revoke_session(
    session_id: uuid.UUID,
    authenticated: AuthenticatedSession = Depends(
        get_authenticated_session
    ),
    db: Session = Depends(get_db),
) -> Response:
    try:
        SessionService(db).revoke_session(
            user_id=authenticated.user.id,
            current_session_id=authenticated.session_id,
            session_id=session_id,
        )
        return Response(status_code=status.HTTP_204_NO_CONTENT)
    except CurrentSessionRevocationError as exc:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail=(
                "Use the normal sign-out action to end the "
                "current session."
            ),
        ) from exc
    except SessionNotFoundError as exc:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Session not found.",
        ) from exc


@router.post(
    "/sign-out-others",
    status_code=status.HTTP_204_NO_CONTENT,
)
def sign_out_others(
    authenticated: AuthenticatedSession = Depends(
        get_authenticated_session
    ),
    db: Session = Depends(get_db),
) -> Response:
    SessionService(db).revoke_others(
        user_id=authenticated.user.id,
        current_session_id=authenticated.session_id,
    )
    return Response(status_code=status.HTTP_204_NO_CONTENT)


@router.post(
    "/sign-out-everywhere",
    status_code=status.HTTP_204_NO_CONTENT,
)
def sign_out_everywhere(
    authenticated: AuthenticatedSession = Depends(
        get_authenticated_session
    ),
    db: Session = Depends(get_db),
) -> Response:
    SessionService(db).revoke_everywhere(
        user_id=authenticated.user.id,
    )
    return Response(status_code=status.HTTP_204_NO_CONTENT)
