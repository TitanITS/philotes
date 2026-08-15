from fastapi import (
    APIRouter,
    BackgroundTasks,
    Depends,
    Form,
    HTTPException,
    Query,
    Response,
    status,
)
from fastapi.responses import FileResponse, HTMLResponse
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy.orm import Session

from ...core.config import BACKEND_ROOT, settings
from ...core.database import get_db
from ...schemas.auth import (
    LoginRequest,
    LogoutRequest,
    RefreshRequest,
    RegistrationRequest,
    TokenResponse,
    VerificationStatusResponse,
    VerifyEmailRequest,
)
from ...schemas.user import UserResponse
from ...security.authentication import get_current_user
from ...services.email_delivery_service import EmailDeliveryService
from ...services.email_verification_service import (
    EmailVerificationService,
    InvalidEmailVerificationTokenError,
)
from ...services.auth_service import (
    AuthenticationService,
    InactiveUserError,
    InvalidCredentialsError,
    InvalidRefreshTokenError,
)
from ...services.user_service import UserAlreadyExistsError
from ...models.user import User
from ...presentation.security_pages import (
    verification_confirmation_page,
    verification_error_page,
    verification_success_page,
)


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
    background_tasks: BackgroundTasks,
    db: Session = Depends(get_db),
) -> UserResponse:
    service = AuthenticationService(db)

    try:
        user, verification_token = service.register(
            email=str(payload.email),
            password=payload.password,
        )

        if settings.email_delivery_enabled:
            background_tasks.add_task(
                EmailDeliveryService().send_verification_email,
                to_email=user.email,
                raw_token=verification_token,
            )

        return user
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


@router.post(
    "/verify-email",
    response_model=VerificationStatusResponse,
)
def verify_email(
    payload: VerifyEmailRequest,
    db: Session = Depends(get_db),
) -> VerificationStatusResponse:
    try:
        EmailVerificationService(db).verify(payload.token)
        return VerificationStatusResponse(status="verified")
    except InvalidEmailVerificationTokenError as exc:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Invalid or expired verification token.",
        ) from exc


@router.post(
    "/resend-verification",
    response_model=VerificationStatusResponse,
    status_code=status.HTTP_202_ACCEPTED,
)
def resend_verification(
    background_tasks: BackgroundTasks,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> VerificationStatusResponse:
    if current_user.email_verified:
        return VerificationStatusResponse(status="already_verified")

    verification_token = EmailVerificationService(db).issue_token(
        current_user.id
    )

    if settings.email_delivery_enabled:
        background_tasks.add_task(
            EmailDeliveryService().send_verification_email,
            to_email=current_user.email,
            raw_token=verification_token,
        )

    return VerificationStatusResponse(status="verification_pending")


@router.get(
    "/security-assets/titan-logo.png",
    response_class=FileResponse,
    include_in_schema=False,
)
def titan_security_logo() -> FileResponse:
    logo_path = (
        BACKEND_ROOT
        / "app"
        / "static"
        / "branding"
        / "titan-logo.png"
    )
    return FileResponse(
        path=logo_path,
        media_type="image/png",
        filename="titan-logo.png",
    )


@router.get(
    "/verify-email-link",
    response_class=HTMLResponse,
    include_in_schema=False,
)
def verification_landing_page(
    token: str = Query(min_length=32, max_length=512),
) -> HTMLResponse:
    return HTMLResponse(
        content=verification_confirmation_page(token=token)
    )


@router.post(
    "/verify-email-link",
    response_class=HTMLResponse,
    include_in_schema=False,
)
def verification_landing_confirm(
    token: str = Form(..., min_length=32, max_length=512),
    db: Session = Depends(get_db),
) -> HTMLResponse:
    try:
        EmailVerificationService(db).verify(token)
        return HTMLResponse(
            content=verification_success_page()
        )
    except InvalidEmailVerificationTokenError:
        return HTMLResponse(
            status_code=status.HTTP_400_BAD_REQUEST,
            content=verification_error_page(),
        )
