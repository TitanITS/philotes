import uuid
from datetime import datetime

from pydantic import BaseModel


class SessionResponse(BaseModel):
    id: uuid.UUID
    device_name: str | None
    platform: str | None
    client_name: str | None
    signed_in_at: datetime
    last_active_at: datetime
    expires_at: datetime
    is_current: bool


class SessionListResponse(BaseModel):
    sessions: list[SessionResponse]
