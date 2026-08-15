from pydantic import BaseModel, EmailStr, Field


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


class VerifyEmailRequest(BaseModel):
    token: str = Field(
        min_length=32,
        max_length=512,
    )


class VerificationStatusResponse(BaseModel):
    status: str



class ForgotPasswordRequest(BaseModel):
    email: EmailStr


class PasswordResetStatusResponse(BaseModel):
    status: str



class ChangePasswordRequest(BaseModel):
    current_password: str = Field(
        min_length=1,
        max_length=128,
    )
    new_password: str = Field(
        min_length=15,
        max_length=128,
    )
    confirm_password: str = Field(
        min_length=15,
        max_length=128,
    )
