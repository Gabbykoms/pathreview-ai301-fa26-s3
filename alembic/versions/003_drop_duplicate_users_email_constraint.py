"""Drop duplicate unique constraint on users.email.

Migration 001 created both a unique constraint (uq_users_email) and a unique
index (ix_users_email) on users.email. The User model declares only the
unique index, so the constraint is redundant and makes the migrated schema
differ from the models. Uniqueness stays enforced by ix_users_email.

Revision ID: 003
Revises: 002
Create Date: 2026-10-05 00:00:00.000000
"""

from alembic import op  # type: ignore[attr-defined]

revision = "003"
down_revision = "002"
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.drop_constraint("uq_users_email", "users", type_="unique")


def downgrade() -> None:
    op.create_unique_constraint("uq_users_email", "users", ["email"])
