from app.models.base import Base
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
