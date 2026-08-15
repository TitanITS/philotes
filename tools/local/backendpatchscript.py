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


__all__ = ["User"]
""",
    APP_ROOT / "repositories" / "__init__.py": "",
    APP_ROOT / "schemas" / "__init__.py": "",
    APP_ROOT / "security" / "__init__.py": "",
    APP_ROOT / "services" / "__init__.py": "",
    TEST_ROOT / "__init__.py": "",
    BACKEND_ROOT / ".env.example": """PHILOTES_APP_NAME=Philotes API
PHILOTES_ENVIRONMENT=development
PHILOTES_DATABASE_URL=postgresql+psycopg://philotes_app:CHANGE_ME@localhost:5432/philotes_dev
""",
    APP_ROOT / "core" / "config.py": """from pathlib import Path

from pydantic_settings import BaseSettings, SettingsConfigDict


BACKEND_ROOT = Path(__file__).resolve().parents[2]


class Settings(BaseSettings):
    app_name: str = "Philotes API"
    environment: str = "development"
    api_v1_prefix: str = "/api/v1"
    database_url: str

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

from .routes.health import router as health_router


api_router = APIRouter()
api_router.include_router(health_router)
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


config = context.config

if config.config_file_name is not None:
    fileConfig(config.config_file_name)

_ = User
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
}


def main() -> None:
    print()
    print("=" * 76)
    print("PHILOTES BACKEND USER MODEL V4")
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
    }

    passed = True
    report = [
        "PHILOTES BACKEND USER MODEL V4 REPORT",
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
        "- V4 defines the first application table model: users.",
        "- User fields are limited to identity/status/timestamps.",
        "- No password hash, login, token, MFA, profile, interest, or messaging fields are added yet.",
        "- The users table is not created directly by this patch; Alembic will generate and apply the migration.",
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
