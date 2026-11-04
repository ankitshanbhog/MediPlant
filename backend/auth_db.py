import os
import json
import sqlite3
from datetime import datetime

try :
    import psycopg2
    from psycopg2 .extras import RealDictCursor
    PSYCOPG2_AVAILABLE =True
except ImportError :
    PSYCOPG2_AVAILABLE =False

BASE_DIR =os .path .dirname (os .path .abspath (__file__ ))
DB_PATH =os .path .join (BASE_DIR ,"mediplant_auth.db")

ENV_PATH =os .path .join (BASE_DIR ,".env")
if os .path .exists (ENV_PATH ):
    try :
        with open (ENV_PATH ,"r",encoding ="utf-8")as _f :
            for _line in _f :
                _line =_line .strip ()
                if _line and not _line .startswith ("#")and "="in _line :
                    _k ,_v =_line .split ("=",1 )
                    os .environ .setdefault (_k .strip (),_v .strip ().strip ("'").strip ('"'))
    except Exception as _e :
        print ("[auth_db] Warning: Could not read .env:",_e )

DATABASE_URL =os .environ .get ("DATABASE_URL","").strip ()
if DATABASE_URL .startswith ("postgres://"):
    DATABASE_URL =DATABASE_URL .replace ("postgres://","postgresql://",1 )

def is_postgres ()->bool :
    return bool (DATABASE_URL )and PSYCOPG2_AVAILABLE

class PgCursorWrapper :
    def __init__ (self ,raw_cursor ,conn ):
        self ._cur =raw_cursor
        self ._conn =conn
        self .lastrowid =None

    def execute (self ,sql ,params =None ):
        pg_sql =sql .replace ("?","%s")
        upper_sql =pg_sql .strip ().upper ()
        if upper_sql .startswith ("INSERT INTO")and "RETURNING"not in upper_sql :
            pg_sql_ret =pg_sql .rstrip ().rstrip (";")+" RETURNING id;"
            try :
                if params :
                    self ._cur .execute (pg_sql_ret ,params )
                else :
                    self ._cur .execute (pg_sql_ret )
                row =self ._cur .fetchone ()
                if row :
                    self .lastrowid =row ["id"]if isinstance (row ,dict )else row [0 ]
                return self
            except Exception :
                self ._conn .rollback ()

        if params :
            self ._cur .execute (pg_sql ,params )
        else :
            self ._cur .execute (pg_sql )
        return self

    def fetchone (self ):
        return self ._cur .fetchone ()

    def fetchall (self ):
        return self ._cur .fetchall ()

    @property
    def rowcount (self ):
        return self ._cur .rowcount

    def close (self ):
        self ._cur .close ()

class PgConnectionWrapper :
    def __init__ (self ,raw_conn ):
        self ._conn =raw_conn

    def cursor (self ):
        raw_cur =self ._conn .cursor (cursor_factory =RealDictCursor )
        return PgCursorWrapper (raw_cur ,self ._conn )

    def commit (self ):
        self ._conn .commit ()

    def rollback (self ):
        self ._conn .rollback ()

    def close (self ):
        self ._conn .close ()

def get_db_connection ():
    if is_postgres ():
        raw_conn =psycopg2 .connect (DATABASE_URL )
        return PgConnectionWrapper (raw_conn )
    else :
        conn =sqlite3 .connect (DB_PATH )
        conn .row_factory =sqlite3 .Row
        return conn

def init_auth_db ():
    conn =get_db_connection ()
    cursor =conn .cursor ()

    if is_postgres ():
        cursor .execute ("""
            CREATE TABLE IF NOT EXISTS users (
                id SERIAL PRIMARY KEY,
                name TEXT NOT NULL,
                email TEXT UNIQUE NOT NULL,
                hashed_password TEXT NOT NULL,
                roles TEXT NOT NULL,           -- JSON array: ["user"], ["farmer", "user"], ["admin"]
                is_verified INTEGER DEFAULT 0, -- 1 for verified farmers / trusted reviewers
                created_at TEXT NOT NULL
            );
        """)
        cursor .execute ("CREATE INDEX IF NOT EXISTS idx_users_email_lower ON users (LOWER(email));")
    else :
        cursor .execute ("""
            CREATE TABLE IF NOT EXISTS users (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                email TEXT UNIQUE NOT NULL,
                hashed_password TEXT NOT NULL,
                roles TEXT NOT NULL,           -- JSON array: ["user"], ["farmer", "user"], ["admin"]
                is_verified INTEGER DEFAULT 0, -- 1 for verified farmers / trusted reviewers
                created_at TEXT NOT NULL
            )
        """)

    conn .commit ()
    conn .close ()

if __name__ =="__main__":
    init_auth_db ()
    db_type ="Cloud PostgreSQL ("+DATABASE_URL .split ('@')[-1 ]+")"if is_postgres ()else "Persistent SQLite ("+DB_PATH +")"
    print ("Auth database initialized successfully with:",db_type )
