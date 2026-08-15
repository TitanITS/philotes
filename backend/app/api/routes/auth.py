from fastapi import (
    APIRouter,
    BackgroundTasks,
    Depends,
    Form,
    HTTPException,
    Query,
    Request,
    Response,
    status,
)
from fastapi.responses import FileResponse, HTMLResponse
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy.orm import Session

from ...core.config import BACKEND_ROOT, settings
from ...core.database import get_db
from ...schemas.auth import (
    ChangePasswordRequest,
    ForgotPasswordRequest,
    LoginRequest,
    LogoutRequest,
    PasswordResetStatusResponse,
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
    InvalidCurrentPasswordError,
    InactiveUserError,
    InvalidCredentialsError,
    InvalidRefreshTokenError,
    PasswordReuseError,
)
from ...services.password_reset_service import (
    InvalidPasswordResetTokenError,
    PasswordResetService,
)
from ...services.user_service import UserAlreadyExistsError
from ...models.user import User
from ...presentation.security_pages import (
    password_reset_error_page,
    password_reset_form_page,
    password_reset_success_page,
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
    request: Request,
    db: Session = Depends(get_db),
) -> TokenResponse:
    service = AuthenticationService(db)

    try:
        _, access_token, refresh_token, expires_in = service.login(
            email=str(payload.email),
            password=payload.password,
            device_name=request.headers.get("X-Philotes-Device-Name"),
            platform=request.headers.get("X-Philotes-Platform"),
            client_name=request.headers.get("X-Philotes-Client"),
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


@router.post(
    "/change-password",
    response_model=TokenResponse,
)
def change_password(
    payload: ChangePasswordRequest,
    request: Request,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> TokenResponse:
    if payload.new_password != payload.confirm_password:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="The new password entries do not match.",
        )

    try:
        access_token, refresh_token, expires_in = AuthenticationService(
            db
        ).change_password(
            user_id=current_user.id,
            current_password=payload.current_password,
            new_password=payload.new_password,
            device_name=request.headers.get("X-Philotes-Device-Name"),
            platform=request.headers.get("X-Philotes-Platform"),
            client_name=request.headers.get("X-Philotes-Client"),
        )
        return TokenResponse(
            access_token=access_token,
            refresh_token=refresh_token,
            expires_in=expires_in,
        )
    except InvalidCurrentPasswordError as exc:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Current password is incorrect.",
        ) from exc
    except PasswordReuseError as exc:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="New password must be different from the current password.",
        ) from exc


@router.post(
    "/forgot-password",
    response_model=PasswordResetStatusResponse,
    status_code=status.HTTP_202_ACCEPTED,
)
def forgot_password(
    payload: ForgotPasswordRequest,
    background_tasks: BackgroundTasks,
    db: Session = Depends(get_db),
) -> PasswordResetStatusResponse:
    reset = PasswordResetService(db).request_reset(str(payload.email))

    if reset is not None and settings.email_delivery_enabled:
        user, raw_token = reset
        background_tasks.add_task(
            EmailDeliveryService().send_password_reset_email,
            to_email=user.email,
            raw_token=raw_token,
        )

    # Deliberately identical whether or not the account exists.
    return PasswordResetStatusResponse(status="password_reset_pending")


@router.get(
    "/reset-password-link",
    response_class=HTMLResponse,
    include_in_schema=False,
)
def password_reset_landing_page(
    token: str = Query(min_length=32, max_length=512),
) -> HTMLResponse:
    return HTMLResponse(
        content=password_reset_form_page(token=token)
    )


@router.post(
    "/reset-password-link",
    response_class=HTMLResponse,
    include_in_schema=False,
)
def password_reset_landing_confirm(
    token: str = Form(..., min_length=32, max_length=512),
    new_password: str = Form(..., min_length=15, max_length=128),
    confirm_password: str = Form(..., min_length=15, max_length=128),
    db: Session = Depends(get_db),
) -> HTMLResponse:
    if new_password != confirm_password:
        return HTMLResponse(
            status_code=status.HTTP_400_BAD_REQUEST,
            content=password_reset_form_page(
                token=token,
                error_message="The password entries do not match.",
            ),
        )

    try:
        PasswordResetService(db).reset_password(
            raw_token=token,
            new_password=new_password,
        )
        return HTMLResponse(
            content=password_reset_success_page()
        )
    except InvalidPasswordResetTokenError:
        return HTMLResponse(
            status_code=status.HTTP_400_BAD_REQUEST,
            content=password_reset_error_page(),
        )


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
