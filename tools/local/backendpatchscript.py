from pathlib import Path
from datetime import datetime

SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = SCRIPT_DIR.parent.parent
BACKEND_ROOT = PROJECT_ROOT / "backend"
APP_ROOT = BACKEND_ROOT / "app"
TEST_ROOT = BACKEND_ROOT / "tests"
REPORT_FILE = SCRIPT_DIR / "backendpatchscript_report.txt"

FILES = {
    APP_ROOT / "__init__.py": "",
    APP_ROOT / "api" / "__init__.py": "",
    APP_ROOT / "api" / "routes" / "__init__.py": "",
    APP_ROOT / "core" / "__init__.py": "",
    APP_ROOT / "models" / "__init__.py": "",
    APP_ROOT / "repositories" / "__init__.py": "",
    APP_ROOT / "schemas" / "__init__.py": "",
    APP_ROOT / "security" / "__init__.py": "",
    APP_ROOT / "services" / "__init__.py": "",
    TEST_ROOT / "__init__.py": "",
    APP_ROOT / "core" / "config.py": '''from pydantic_settings import BaseSettings, SettingsConfigDict\n\n\nclass Settings(BaseSettings):\n    app_name: str = \"Philotes API\"\n    environment: str = \"development\"\n    api_v1_prefix: str = \"/api/v1\"\n    database_url: str = (\n        \"postgresql+psycopg://philotes:philotes@localhost:5432/philotes\"\n    )\n\n    model_config = SettingsConfigDict(\n        env_file=\".env\",\n        env_file_encoding=\"utf-8\",\n        extra=\"ignore\",\n    )\n\n\nsettings = Settings()\n''',
    APP_ROOT / "core" / "database.py": '''from sqlalchemy import create_engine\nfrom sqlalchemy.orm import Session, sessionmaker\n\nfrom .config import settings\n\n\nengine = create_engine(\n    settings.database_url,\n    pool_pre_ping=True,\n)\n\nSessionLocal = sessionmaker(\n    bind=engine,\n    autoflush=False,\n    autocommit=False,\n    expire_on_commit=False,\n    class_=Session,\n)\n\n\ndef get_db():\n    db = SessionLocal()\n    try:\n        yield db\n    finally:\n        db.close()\n''',
    APP_ROOT / "api" / "routes" / "health.py": '''from fastapi import APIRouter\n\n\nrouter = APIRouter()\n\n\n@router.get(\"/health\", tags=[\"Health\"])\ndef health_check() -> dict[str, str]:\n    return {\n        \"status\": \"healthy\",\n        \"service\": \"Philotes API\",\n    }\n''',
    APP_ROOT / "api" / "router.py": '''from fastapi import APIRouter\n\nfrom .routes.health import router as health_router\n\n\napi_router = APIRouter()\napi_router.include_router(health_router)\n''',
    APP_ROOT / "main.py": '''from fastapi import FastAPI\n\nfrom .api.router import api_router\nfrom .core.config import settings\n\n\ndef create_app() -> FastAPI:\n    app = FastAPI(\n        title=settings.app_name,\n        version=\"0.1.0\",\n    )\n\n    app.include_router(\n        api_router,\n        prefix=settings.api_v1_prefix,\n    )\n\n    return app\n\n\napp = create_app()\n''',
    TEST_ROOT / "test_health.py": '''from fastapi.testclient import TestClient\n\nfrom app.main import app\n\n\nclient = TestClient(app)\n\n\ndef test_health_endpoint() -> None:\n    response = client.get(\"/api/v1/health\")\n\n    assert response.status_code == 200\n    assert response.json() == {\n        \"status\": \"healthy\",\n        \"service\": \"Philotes API\",\n    }\n''',
}


def main() -> None:
    print()
    print("=" * 76)
    print("PHILOTES BACKEND FOUNDATION V1")
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
    ]

    for path in required_dirs:
        if not path.exists():
            print(f"FAIL: Required folder not found: {path}")
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

    checks = {
        "FastAPI app created": "FastAPI(" in (APP_ROOT / "main.py").read_text(encoding="utf-8"),
        "API v1 prefix configured": "/api/v1" in (APP_ROOT / "core" / "config.py").read_text(encoding="utf-8"),
        "Health endpoint created": 'router.get("/health"' in (APP_ROOT / "api" / "routes" / "health.py").read_text(encoding="utf-8"),
        "Database engine configured": "create_engine(" in (APP_ROOT / "core" / "database.py").read_text(encoding="utf-8"),
        "Psycopg PostgreSQL URL configured": "postgresql+psycopg://" in (APP_ROOT / "core" / "config.py").read_text(encoding="utf-8"),
        "Health test created": "test_health_endpoint" in (TEST_ROOT / "test_health.py").read_text(encoding="utf-8"),
    }

    passed = True
    report = [
        "PHILOTES BACKEND FOUNDATION V1 REPORT",
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
        "FOUNDATION CONTRACT",
        "- Backend framework: FastAPI",
        "- ORM: SQLAlchemy",
        "- Database target: PostgreSQL",
        "- PostgreSQL driver: Psycopg 3",
        "- API prefix: /api/v1",
        "- Health endpoint: /api/v1/health",
        "- No authentication or production database actions are implemented yet.",
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
