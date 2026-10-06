#!/usr/bin/env bash
# Validate database migrations against a fresh, empty database.
#
# Applies every Alembic migration in order, then checks that the resulting
# schema matches the SQLAlchemy models (Base.metadata). Exits non-zero if a
# migration fails to apply or the schema has drifted from the models.
#
# Usage:
#   DATABASE_URL=postgresql+asyncpg://user:pass@host:port/empty_db scripts/validate_migrations.sh
#
# DATABASE_URL must point at an empty database and use the asyncpg driver,
# since alembic/env.py connects through create_async_engine.

set -euo pipefail

if [[ -z "${DATABASE_URL:-}" ]]; then
  echo "error: DATABASE_URL is not set" >&2
  exit 1
fi

if [[ "$DATABASE_URL" != postgresql+asyncpg://* ]]; then
  echo "error: DATABASE_URL must use the postgresql+asyncpg:// scheme" >&2
  exit 1
fi

cd "$(dirname "$0")/.."

echo "==> Applying all migrations to a fresh database"
alembic upgrade head

echo "==> Checking the migrated schema against the SQLAlchemy models"
alembic check

echo "Migrations applied cleanly and the schema matches the models."
