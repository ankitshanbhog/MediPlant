import json
from datetime import datetime
from typing import List, Optional
from pydantic import BaseModel
from fastapi import APIRouter, Depends, HTTPException, status
from auth_db import get_db_connection, init_auth_db
from auth_service import (
    hash_password,
    verify_password,
    create_access_token,
    get_user_by_email,
    get_user_by_id,
    get_current_user,
    require_roles,
)

auth_router = APIRouter()

ALLOWED_REGISTRATION_ROLES = ["user", "farmer"]

# ── Pydantic Request Models ──────────────────────────────────────────────────
class RegisterRequest(BaseModel):
    name: str
    email: str
    password: str
    role: str = "user"  # "user" or "farmer"

class LoginRequest(BaseModel):
    email: str
    password: str

class VerifyUserRequest(BaseModel):
    user_id: int
    is_verified: bool

# ── Seed Default Accounts ───────────────────────────────────────────────────
def seed_default_users():
    init_auth_db()
    conn = get_db_connection()
    cursor = conn.cursor()

    defaults = [
        ("Botanical Admin", "admin@mediplant.org", "Admin@123", ["admin", "user"], 1),
        ("Ramesh Farmer", "farmer@mediplant.org", "Farmer@123", ["farmer", "user"], 1),
        ("Aarav Enthusiast", "user@mediplant.org", "User@123", ["user"], 0),
    ]

    for name, email, raw_pwd, roles, is_verified in defaults:
        cursor.execute("SELECT id FROM users WHERE LOWER(email) = LOWER(?)", (email,))
        if not cursor.fetchone():
            hashed = hash_password(raw_pwd)
            cursor.execute("""
                INSERT INTO users (name, email, hashed_password, roles, is_verified, created_at)
                VALUES (?, ?, ?, ?, ?, ?)
            """, (name, email, hashed, json.dumps(roles), is_verified, datetime.utcnow().isoformat()))

    conn.commit()
    conn.close()

# ── Public Authentication Endpoints ──────────────────────────────────────────
@auth_router.post("/auth/register")
def register(req: RegisterRequest):
    req_role = req.role.lower().strip()
    if req_role not in ALLOWED_REGISTRATION_ROLES:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Invalid registration role '{req.role}'. Allowed: {ALLOWED_REGISTRATION_ROLES}",
        )

    if len(req.password) < 6:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Password must be at least 6 characters long.",
        )

    existing = get_user_by_email(req.email)
    if existing:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="An account with this email already exists.",
        )

    roles = [req_role] if req_role == "user" else [req_role, "user"]
    hashed = hash_password(req.password)
    now_str = datetime.utcnow().isoformat()

    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("""
        INSERT INTO users (name, email, hashed_password, roles, is_verified, created_at)
        VALUES (?, ?, ?, ?, 0, ?)
    """, (req.name.strip(), req.email.strip().lower(), hashed, json.dumps(roles), now_str))
    user_id = cursor.lastrowid
    conn.commit()
    conn.close()

    token = create_access_token({"sub": str(user_id), "email": req.email, "roles": roles})
    return {
        "access_token": token,
        "token_type": "bearer",
        "user": {
            "id": user_id,
            "name": req.name.strip(),
            "email": req.email.strip().lower(),
            "roles": roles,
            "is_verified": False,
        },
    }

@auth_router.post("/auth/login")
def login(req: LoginRequest):
    user = get_user_by_email(req.email)
    if not user or not verify_password(req.password, user["hashed_password"]):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid email or password.",
            headers={"WWW-Authenticate": "Bearer"},
        )

    token = create_access_token({"sub": str(user["id"]), "email": user["email"], "roles": user["roles"]})
    return {
        "access_token": token,
        "token_type": "bearer",
        "user": {
            "id": user["id"],
            "name": user["name"],
            "email": user["email"],
            "roles": user["roles"],
            "is_verified": user["is_verified"],
        },
    }

@auth_router.get("/auth/me")
def get_profile(current_user: dict = Depends(get_current_user)):
    return {
        "id": current_user["id"],
        "name": current_user["name"],
        "email": current_user["email"],
        "roles": current_user["roles"],
        "is_verified": current_user["is_verified"],
        "created_at": current_user["created_at"],
    }

# ── Admin Role-Guarded Endpoints ─────────────────────────────────────────────
@auth_router.get("/admin/users", dependencies=[Depends(require_roles(["admin"]))])
def list_users(current_user: dict = Depends(get_current_user)):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT id, name, email, roles, is_verified, created_at FROM users ORDER BY id ASC")
    users = []
    for row in cursor.fetchall():
        users.append({
            "id": row["id"],
            "name": row["name"],
            "email": row["email"],
            "roles": json.loads(row["roles"]),
            "is_verified": bool(row["is_verified"]),
            "created_at": row["created_at"],
        })
    conn.close()
    return {"total_users": len(users), "users": users}

@auth_router.post("/admin/verify-user", dependencies=[Depends(require_roles(["admin"]))])
def verify_user(req: VerifyUserRequest, current_user: dict = Depends(get_current_user)):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("UPDATE users SET is_verified = ? WHERE id = ?", (1 if req.is_verified else 0, req.user_id))
    if cursor.rowcount == 0:
        conn.close()
        raise HTTPException(status_code=404, detail="User not found.")
    conn.commit()
    conn.close()

    return {"message": f"User ID {req.user_id} verification set to {req.is_verified}."}
