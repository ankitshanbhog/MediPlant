import os
import sqlite3
import json
from datetime import datetime

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
DB_PATH = os.path.join(BASE_DIR, "mediplant_auth.db")

def get_db_connection():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn

def init_farmer_db():
    conn = get_db_connection()
    cursor = conn.cursor()

    # 1. Grower Profiles table
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS grower_profiles (
            farmer_id INTEGER PRIMARY KEY,
            farm_name TEXT NOT NULL,
            region TEXT NOT NULL,
            farming_method TEXT NOT NULL,
            experience_years INTEGER DEFAULT 1,
            bio TEXT,
            contact_phone TEXT,
            FOREIGN KEY (farmer_id) REFERENCES users (id)
        )
    """)

    # 2. Farmer Crops & Harvest Calendar table
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS farmer_crops (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            farmer_id INTEGER NOT NULL,
            plant_name TEXT NOT NULL,
            stage TEXT NOT NULL,           -- Sowing, Vegetative, Flowering, Harvest-Ready, Post-Harvest
            sowing_date TEXT,
            expected_harvest TEXT,
            quantity TEXT,
            notes TEXT,
            created_at TEXT NOT NULL,
            FOREIGN KEY (farmer_id) REFERENCES users (id)
        )
    """)

    # 3. Stock and Batch Management table
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS stock_batches (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            farmer_id INTEGER NOT NULL,
            plant_name TEXT NOT NULL,
            state TEXT NOT NULL,           -- Fresh, Sun-Dried, Powder, Whole Root
            quantity REAL NOT NULL,
            unit TEXT NOT NULL,            -- kg, bundles, grams
            quality_notes TEXT,            -- Grade A Organic, Shade-Dried, etc.
            harvest_date TEXT,
            status TEXT NOT NULL,          -- In Stock, Reserved, Sold Out
            price_per_unit TEXT,
            created_at TEXT NOT NULL,
            FOREIGN KEY (farmer_id) REFERENCES users (id)
        )
    """)

    # 4. Buyer Inquiries table
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS buyer_inquiries (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            farmer_id INTEGER NOT NULL,
            buyer_name TEXT NOT NULL,
            buyer_contact TEXT NOT NULL,
            plant_name TEXT NOT NULL,
            requested_qty TEXT NOT NULL,
            message TEXT,
            status TEXT NOT NULL,          -- pending, accepted, declined
            created_at TEXT NOT NULL,
            FOREIGN KEY (farmer_id) REFERENCES users (id)
        )
    """)

    conn.commit()
    conn.close()

def seed_farmer_sample_data():
    init_farmer_db()
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("SELECT id FROM users WHERE email = 'farmer@mediplant.org'")
    farmer_row = cursor.fetchone()
    if not farmer_row:
        conn.close()
        return

    f_id = farmer_row["id"]
    now_str = datetime.utcnow().strftime("%Y-%m-%d %H:%M")

    # 1. Seed Grower Profile if not present
    cursor.execute("SELECT farmer_id FROM grower_profiles WHERE farmer_id = ?", (f_id,))
    if not cursor.fetchone():
        cursor.execute("""
            INSERT INTO grower_profiles (farmer_id, farm_name, region, farming_method, experience_years, bio, contact_phone)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        """, (
            f_id,
            "Green Valley Herbal Estate",
            "Western Ghats Foothills, Karnataka",
            "Certified Organic & Natural Farming",
            8,
            "Specialized in cultivation of heritage medicinal roots and foliage using eco-friendly regenerative practices.",
            "+91 98765 43210"
        ))

    # 2. Seed Initial Crops if fewer than 2
    cursor.execute("SELECT COUNT(*) as cnt FROM farmer_crops WHERE farmer_id = ?", (f_id,))
    if cursor.fetchone()["cnt"] == 0:
        sample_crops = [
            ("Ashwagandha", "Vegetative Growth", "2026-06-15", "November 2026", "120 kg roots", "Well-drained sandy loam bed, irrigated every 10 days."),
            ("Gotu Kola", "Harvest Ready", "2026-08-01", "Immediate (Weekly)", "45 kg fresh foliage", "Partial shade nursery, organic compost mulched."),
            ("Tulsi (Holy Basil)", "Flowering", "2026-07-20", "December 2026", "60 kg leaves", "Krishna Tulsi variety under shade net.")
        ]
        for name, stage, sow, harv, qty, notes in sample_crops:
            cursor.execute("""
                INSERT INTO farmer_crops (farmer_id, plant_name, stage, sowing_date, expected_harvest, quantity, notes, created_at)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            """, (f_id, name, stage, sow, harv, qty, notes, now_str))

    # 3. Seed Stock Batches if empty
    cursor.execute("SELECT COUNT(*) as cnt FROM stock_batches WHERE farmer_id = ?", (f_id,))
    if cursor.fetchone()["cnt"] == 0:
        sample_batches = [
            ("Ashwagandha Roots", "Sun-Dried", 75.0, "kg", "Grade A Organic, withanolide verified", "2026-09-20", "In Stock", "₹420/kg"),
            ("Gotu Kola Leaves", "Fresh", 30.0, "kg", "Hand-plucked morning harvest", "2026-10-24", "In Stock", "₹180/kg"),
            ("Amla Dried Slices", "Sun-Dried", 40.0, "kg", "Deseeded wild amla fruit", "2026-09-10", "In Stock", "₹240/kg"),
            ("Moringa Leaf Powder", "Powder", 25.0, "kg", "Triple-sieved shadow dried", "2026-08-15", "Reserved", "₹320/kg")
        ]
        for name, state, qty, unit, q_notes, h_date, status, price in sample_batches:
            cursor.execute("""
                INSERT INTO stock_batches (farmer_id, plant_name, state, quantity, unit, quality_notes, harvest_date, status, price_per_unit, created_at)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, (f_id, name, state, qty, unit, q_notes, h_date, status, price, now_str))

    # 4. Seed Buyer Inquiries if empty
    cursor.execute("SELECT COUNT(*) as cnt FROM buyer_inquiries WHERE farmer_id = ?", (f_id,))
    if cursor.fetchone()["cnt"] == 0:
        sample_inquiries = [
            ("AyurVeda Wellness Labs", "+91 94481 12345", "Ashwagandha Roots", "50 kg dried roots", "Seeking certified organic roots with COA for extract preparation. Can arrange pickup.", "pending"),
            ("Kerala Herbal Formulations", "+91 97450 67890", "Gotu Kola Leaves", "25 kg fresh foliage", "Interested in weekly recurring procurement for memory tonic syrups.", "accepted"),
            ("Dr. Shastry Pharmacy", "+91 98801 23456", "Amla Dried Slices", "20 kg dried slices", "Inquiring about current batch tannin content and bulk packaging.", "pending")
        ]
        for buyer, contact, plant, qty, msg, status in sample_inquiries:
            cursor.execute("""
                INSERT INTO buyer_inquiries (farmer_id, buyer_name, buyer_contact, plant_name, requested_qty, message, status, created_at)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            """, (f_id, buyer, contact, plant, qty, msg, status, now_str))

    conn.commit()
    conn.close()

if __name__ == "__main__":
    init_farmer_db()
    seed_farmer_sample_data()
    print("Farmer tables initialized and sample data seeded successfully.")
