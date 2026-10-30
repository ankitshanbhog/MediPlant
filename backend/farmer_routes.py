import os
import json
from datetime import datetime
from typing import List, Optional
from pydantic import BaseModel
from fastapi import APIRouter, Depends, HTTPException, status
from farmer_db import get_db_connection, init_farmer_db, seed_farmer_sample_data
from auth_service import get_current_user, require_roles

farmer_router = APIRouter(prefix="/farmer", tags=["Farmer & Grower Ecosystem"])

def init_farmer_features():
    init_farmer_db()
    seed_farmer_sample_data()

# ── Pydantic Request Models ──────────────────────────────────────────────────
class ProfileUpdateRequest(BaseModel):
    farm_name: str
    region: str
    farming_method: str
    experience_years: int = 1
    bio: Optional[str] = None
    contact_phone: Optional[str] = None

class CropRecordCreate(BaseModel):
    plant_name: str
    stage: str
    sowing_date: Optional[str] = None
    expected_harvest: Optional[str] = None
    quantity: Optional[str] = None
    notes: Optional[str] = None

class CropStageUpdate(BaseModel):
    stage: str
    notes: Optional[str] = None

class StockBatchCreate(BaseModel):
    plant_name: str
    state: str  # Fresh, Sun-Dried, Powder, Whole Root
    quantity: float
    unit: str = "kg"
    quality_notes: Optional[str] = None
    harvest_date: Optional[str] = None
    status: str = "In Stock"
    price_per_unit: Optional[str] = None

class StockStatusUpdate(BaseModel):
    status: str  # In Stock, Reserved, Sold Out

class InquiryStatusUpdate(BaseModel):
    status: str  # pending, accepted, declined

# ── 1. Farmer Overview & Dashboard Summary ──────────────────────────────────
@farmer_router.get("/overview", dependencies=[Depends(require_roles(["farmer"]))])
def get_farmer_overview(current_user: dict = Depends(get_current_user)):
    f_id = current_user["id"]
    conn = get_db_connection()
    cursor = conn.cursor()

    # Profile
    cursor.execute("SELECT * FROM grower_profiles WHERE farmer_id = ?", (f_id,))
    p_row = cursor.fetchone()
    profile = dict(p_row) if p_row else {
        "farm_name": "My Herbal Farm",
        "region": "Not Set",
        "farming_method": "Natural Cultivation",
        "experience_years": 1,
        "bio": "Registered grower on MediPlant network.",
        "contact_phone": "",
    }

    # Crops count
    cursor.execute("SELECT COUNT(*) as count FROM farmer_crops WHERE farmer_id = ?", (f_id,))
    crops_count = cursor.fetchone()["count"]

    # Stock batches count & available total
    cursor.execute("SELECT COUNT(*) as count, SUM(quantity) as total_kg FROM stock_batches WHERE farmer_id = ? AND status = 'In Stock'", (f_id,))
    stock_stat = cursor.fetchone()

    # Pending inquiries count
    cursor.execute("SELECT COUNT(*) as count FROM buyer_inquiries WHERE farmer_id = ? AND status = 'pending'", (f_id,))
    pending_inquiries = cursor.fetchone()["count"]

    conn.close()

    return {
        "farmer_name": current_user["name"],
        "is_verified": current_user["is_verified"],
        "profile": profile,
        "stats": {
            "active_crops": crops_count,
            "in_stock_batches": stock_stat["count"] or 0,
            "total_stock_kg": round(stock_stat["total_kg"] or 0.0, 1),
            "pending_inquiries": pending_inquiries,
        },
        "verification_explanation": (
            "Your grower profile is botanically authenticated by MediPlant reviewers. "
            "Verified status confirms your agricultural identity and adherence to GAP (Good Agricultural Practices)."
            if current_user["is_verified"] else
            "Account verification is in review. You can list crops and manage harvest batches while review is pending."
        )
    }

# ── 2. Grower Profile & Trust Management ─────────────────────────────────────
@farmer_router.get("/profile", dependencies=[Depends(require_roles(["farmer"]))])
def get_grower_profile(current_user: dict = Depends(get_current_user)):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM grower_profiles WHERE farmer_id = ?", (current_user["id"],))
    row = cursor.fetchone()
    conn.close()

    if not row:
        return {
            "farm_name": f"{current_user['name']}'s Medicinal Farm",
            "region": "Pending Configuration",
            "farming_method": "Traditional / Organic",
            "experience_years": 1,
            "bio": "Herbal cultivator focused on high-quality botanical planting materials.",
            "contact_phone": "",
            "is_verified": current_user["is_verified"],
        }
    data = dict(row)
    data["is_verified"] = current_user["is_verified"]
    return data

@farmer_router.put("/profile", dependencies=[Depends(require_roles(["farmer"]))])
def update_grower_profile(req: ProfileUpdateRequest, current_user: dict = Depends(get_current_user)):
    f_id = current_user["id"]
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("""
        INSERT INTO grower_profiles (farmer_id, farm_name, region, farming_method, experience_years, bio, contact_phone)
        VALUES (?, ?, ?, ?, ?, ?, ?)
        ON CONFLICT(farmer_id) DO UPDATE SET
            farm_name = excluded.farm_name,
            region = excluded.region,
            farming_method = excluded.farming_method,
            experience_years = excluded.experience_years,
            bio = excluded.bio,
            contact_phone = excluded.contact_phone
    """, (f_id, req.farm_name.strip(), req.region.strip(), req.farming_method.strip(), req.experience_years, req.bio, req.contact_phone))
    conn.commit()
    conn.close()

    return {"message": "Grower profile updated successfully.", "profile": req.dict()}

# ── 3. Crop Planning & Harvest Calendar ──────────────────────────────────────
@farmer_router.get("/crops", dependencies=[Depends(require_roles(["farmer"]))])
def list_farmer_crops(current_user: dict = Depends(get_current_user)):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM farmer_crops WHERE farmer_id = ? ORDER BY id DESC", (current_user["id"],))
    crops = [dict(row) for row in cursor.fetchall()]
    conn.close()
    return {"count": len(crops), "crops": crops}

@farmer_router.post("/crops", dependencies=[Depends(require_roles(["farmer"]))])
def create_farmer_crop(req: CropRecordCreate, current_user: dict = Depends(get_current_user)):
    conn = get_db_connection()
    cursor = conn.cursor()
    now_str = datetime.utcnow().strftime("%Y-%m-%d %H:%M")
    cursor.execute("""
        INSERT INTO farmer_crops (farmer_id, plant_name, stage, sowing_date, expected_harvest, quantity, notes, created_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    """, (current_user["id"], req.plant_name.strip(), req.stage.strip(), req.sowing_date, req.expected_harvest, req.quantity, req.notes, now_str))
    crop_id = cursor.lastrowid
    conn.commit()
    conn.close()

    return {
        "message": "Crop batch registered in calendar.",
        "crop": {
            "id": crop_id,
            "plant_name": req.plant_name,
            "stage": req.stage,
            "sowing_date": req.sowing_date,
            "expected_harvest": req.expected_harvest,
            "quantity": req.quantity,
            "notes": req.notes,
        }
    }

@farmer_router.put("/crops/{crop_id}/stage", dependencies=[Depends(require_roles(["farmer"]))])
def update_crop_stage(crop_id: int, req: CropStageUpdate, current_user: dict = Depends(get_current_user)):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("""
        UPDATE farmer_crops SET stage = ?, notes = COALESCE(?, notes)
        WHERE id = ? AND farmer_id = ?
    """, (req.stage, req.notes, crop_id, current_user["id"]))
    if cursor.rowcount == 0:
        conn.close()
        raise HTTPException(status_code=404, detail="Crop record not found or unauthorized.")
    conn.commit()
    conn.close()
    return {"message": "Crop stage updated."}

@farmer_router.delete("/crops/{crop_id}", dependencies=[Depends(require_roles(["farmer"]))])
def delete_farmer_crop(crop_id: int, current_user: dict = Depends(get_current_user)):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM farmer_crops WHERE id = ? AND farmer_id = ?", (crop_id, current_user["id"]))
    if cursor.rowcount == 0:
        conn.close()
        raise HTTPException(status_code=404, detail="Crop record not found.")
    conn.commit()
    conn.close()
    return {"message": "Crop record deleted."}

# ── 4. Stock & Batch Management ──────────────────────────────────────────────
@farmer_router.get("/stock", dependencies=[Depends(require_roles(["farmer"]))])
def list_stock_batches(current_user: dict = Depends(get_current_user)):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM stock_batches WHERE farmer_id = ? ORDER BY id DESC", (current_user["id"],))
    batches = [dict(row) for row in cursor.fetchall()]
    conn.close()
    return {"count": len(batches), "batches": batches}

@farmer_router.post("/stock", dependencies=[Depends(require_roles(["farmer"]))])
def create_stock_batch(req: StockBatchCreate, current_user: dict = Depends(get_current_user)):
    conn = get_db_connection()
    cursor = conn.cursor()
    now_str = datetime.utcnow().strftime("%Y-%m-%d %H:%M")
    cursor.execute("""
        INSERT INTO stock_batches (farmer_id, plant_name, state, quantity, unit, quality_notes, harvest_date, status, price_per_unit, created_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """, (current_user["id"], req.plant_name.strip(), req.state.strip(), req.quantity, req.unit.strip(), req.quality_notes, req.harvest_date, req.status, req.price_per_unit, now_str))
    batch_id = cursor.lastrowid
    conn.commit()
    conn.close()

    return {"message": "Harvest batch added to stock.", "batch_id": batch_id}

@farmer_router.put("/stock/{batch_id}/status", dependencies=[Depends(require_roles(["farmer"]))])
def update_stock_status(batch_id: int, req: StockStatusUpdate, current_user: dict = Depends(get_current_user)):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("""
        UPDATE stock_batches SET status = ?
        WHERE id = ? AND farmer_id = ?
    """, (req.status, batch_id, current_user["id"]))
    if cursor.rowcount == 0:
        conn.close()
        raise HTTPException(status_code=404, detail="Stock batch not found or unauthorized.")
    conn.commit()
    conn.close()
    return {"message": f"Stock status updated to '{req.status}'."}

@farmer_router.delete("/stock/{batch_id}", dependencies=[Depends(require_roles(["farmer"]))])
def delete_stock_batch(batch_id: int, current_user: dict = Depends(get_current_user)):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM stock_batches WHERE id = ? AND farmer_id = ?", (batch_id, current_user["id"]))
    if cursor.rowcount == 0:
        conn.close()
        raise HTTPException(status_code=404, detail="Stock batch not found.")
    conn.commit()
    conn.close()
    return {"message": "Stock batch removed."}

# ── 5. Buyer Inquiries ───────────────────────────────────────────────────────
@farmer_router.get("/inquiries", dependencies=[Depends(require_roles(["farmer"]))])
def list_buyer_inquiries(current_user: dict = Depends(get_current_user)):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM buyer_inquiries WHERE farmer_id = ? ORDER BY id DESC", (current_user["id"],))
    inquiries = [dict(row) for row in cursor.fetchall()]
    conn.close()
    return {"count": len(inquiries), "inquiries": inquiries}

@farmer_router.put("/inquiries/{inquiry_id}/status", dependencies=[Depends(require_roles(["farmer"]))])
def update_inquiry_status(inquiry_id: int, req: InquiryStatusUpdate, current_user: dict = Depends(get_current_user)):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("""
        UPDATE buyer_inquiries SET status = ?
        WHERE id = ? AND farmer_id = ?
    """, (req.status, inquiry_id, current_user["id"]))
    if cursor.rowcount == 0:
        conn.close()
        raise HTTPException(status_code=404, detail="Inquiry not found or unauthorized.")
    conn.commit()
    conn.close()
    return {"message": f"Inquiry marked as '{req.status}'."}

# ── 6. Cultivation Assistant (Documented Agronomy Guidance) ───────────────────
@farmer_router.get("/cultivation-guides")
def get_cultivation_guides():
    guides = [
        {
            "species": "Ashwagandha (Withania somnifera)",
            "primary_part": "Roots",
            "soil": "Well-drained sandy loam or light red soil, pH 7.5 - 8.0.",
            "sunlight": "Full direct sunlight (6-8 hours daily).",
            "climate": "Subtropical / arid, 20°C - 35°C; low humidity, annual rainfall 600-750 mm.",
            "propagation": "Propagated by seeds directly sown or transplanted at 4-6 weeks.",
            "irrigation": "Low water requirement; light irrigation every 10-14 days. Avoid waterlogging at all costs.",
            "spacing": "60 cm row-to-row x 30 cm plant-to-plant.",
            "pests": "Aphids, mites, seedling blight. Controlled with neem oil (5 ml/L) spray.",
            "harvesting": "150-180 days after sowing when leaves dry and red berries form.",
            "post_harvest": "Roots washed carefully, shade-dried to 10% moisture, cut into 7-10 cm cylindrical pieces."
        },
        {
            "species": "Gotu Kola (Centella asiatica)",
            "primary_part": "Leaves & Whole Herb",
            "soil": "Clay loam, rich organic humus, high moisture-retention, pH 6.0 - 7.0.",
            "sunlight": "Partial shade (40-50% shade netting ideal) or filtered sunlight.",
            "climate": "Warm and humid tropical climate, 22°C - 32°C.",
            "propagation": "Vegetative runners and stolon cuttings with rooted nodes.",
            "irrigation": "Frequent shallow irrigation; soil should remain consistently moist but not stagnant.",
            "spacing": "30 cm x 30 cm creeping groundcover.",
            "pests": "Caterpillars and leaf spot. Bio-fungicide Trichoderma viride applied to roots.",
            "harvesting": "First cutting after 90 days, subsequent harvests every 45-60 days year-round.",
            "post_harvest": "Wash foliage with clean potable water, dry under shade on clean racks to retain green color."
        },
        {
            "species": "Tulsi (Ocimum tenuiflorum)",
            "primary_part": "Leaves & Tender Shoots",
            "soil": "Rich loam with good drainage, pH 6.5 - 7.5.",
            "sunlight": "Full sunlight (minimum 6 hours daily).",
            "climate": "Warm tropical climate, 20°C - 35°C.",
            "propagation": "Seeds sown in nursery beds or terminal softwood cuttings.",
            "irrigation": "Moderate watering when top inch of soil feels dry.",
            "spacing": "45 cm x 45 cm bushy spacing.",
            "pests": "Leaf rollers and lace bugs. Organic neem seed kernel extract spray.",
            "harvesting": "Leaves plucked regularly once plant reaches 30 cm height.",
            "post_harvest": "Spread thinly on raised drying meshes in airy shade, moisture <10%."
        },
        {
            "species": "Amla (Phyllanthus emblica)",
            "primary_part": "Fruits",
            "soil": "Light to heavy soil with well-drained subsoil, tolerant of alkalinity up to pH 9.0.",
            "sunlight": "Full open orchard exposure.",
            "climate": "Tropical and subtropical, hardy against summer heat.",
            "propagation": "Patch or shield budding on rootstocks.",
            "irrigation": "Protective irrigation during fruit development (summer).",
            "spacing": "8 m x 8 m orchard grid.",
            "pests": "Bark eating caterpillar and fruit borer. Biological pheromone traps.",
            "harvesting": "Mature fruits turn greenish-yellow from November to February.",
            "post_harvest": "Graded by size, fresh market dispatch or deseeded and sun-dried."
        },
        {
            "species": "Neem (Azadirachta indica)",
            "primary_part": "Leaves, Seeds & Bark",
            "soil": "Thrives on almost all types of soils including rocky, stony shallow ground.",
            "sunlight": "Full bright sunlight.",
            "climate": "Arid to semi-arid tropical zones.",
            "propagation": "Fresh viable seeds collected during monsoon.",
            "irrigation": "Only required in the first 1-2 years until deep taproot establishes.",
            "spacing": "5 m x 5 m farm boundary or agro-forestry.",
            "pests": "Naturally insect repellent; rarely plagued by pests.",
            "harvesting": "Seed berries collected from ground when yellow; leaves collected year round.",
            "post_harvest": "Seeds depulped, washed, sun dried for neem oil cold-pressing."
        }
    ]
    return {"total_guides": len(guides), "guides": guides}

# ── 7. Market Information & Demand Signals ───────────────────────────────────
@farmer_router.get("/market-info")
def get_market_information():
    benchmarks = [
        {
            "crop": "Ashwagandha (Dry Roots)",
            "benchmark_price": "₹380 - ₹460 / kg",
            "trend": "High Demand",
            "demand_signal": "Strong export demand from Ayurvedic extract manufacturers.",
            "source": "e-Charak / NMPB Market Bulletin (Quarterly Review)",
            "last_updated": "October 2026",
            "disclaimer": "Benchmark reference only. Actual prices vary with root girth and withanolide percentage."
        },
        {
            "crop": "Gotu Kola (Centella Asiatica - Fresh)",
            "benchmark_price": "₹140 - ₹190 / kg",
            "trend": "Steady",
            "demand_signal": "Continuous steady regional demand for fresh food and syrup formulation.",
            "source": "Regional Agricultural Marketing Board",
            "last_updated": "October 2026",
            "disclaimer": "Perishable commodity. Local logistics and proximity determine farm-gate rates."
        },
        {
            "crop": "Tulsi (Dried Leaves)",
            "benchmark_price": "₹120 - ₹180 / kg",
            "trend": "High Demand",
            "demand_signal": "Year-round demand for herbal green tea infusions and wellness blends.",
            "source": "National Medicinal Plants Board",
            "last_updated": "October 2026",
            "disclaimer": "Quality dependent on volatile oil aroma and absence of dust."
        },
        {
            "crop": "Amla Wild Dried Slices (Deseeded)",
            "benchmark_price": "₹220 - ₹280 / kg",
            "trend": "Seasonal High",
            "demand_signal": "Pre-winter surge from Chyawanprash formulation units.",
            "source": "Tribal Cooperative Marketing Federation",
            "last_updated": "October 2026",
            "disclaimer": "Must meet moisture content under 12%."
        }
    ]
    return {
        "disclaimer_notice": "Market figures are sourced reference benchmarks for farm planning. MediPlant does not guarantee buyer prices or market fulfillment.",
        "benchmarks": benchmarks
    }

# ── 8. Agricultural Resources & Government Schemes Directory ──────────────────
@farmer_router.get("/agricultural-resources")
def get_agricultural_resources():
    resources = [
        {
            "title": "National Ayush Mission (NAM) - Medicinal Plants Component",
            "agency": "Ministry of Ayush, Govt. of India",
            "scheme_summary": "Financial assistance covering 30% to 75% of cultivation cost for prioritized endangered and high-value medicinal plant species.",
            "eligibility": "Farmers owning or leasing arable land with access to water; organized into Farmer Producer Organizations (FPOs) or individual growers.",
            "official_link": "https://echarak.ayush.gov.in/",
            "contact": "State Ayush Society / District Horticulture Officer",
            "last_checked": "October 2026"
        },
        {
            "title": "NMPB Post-Harvest Management & Drying Units",
            "agency": "National Medicinal Plants Board",
            "scheme_summary": "50% grant assistance for setting up solar drying sheds, quality testing mini-labs, and hermetic storage facilities.",
            "eligibility": "Grower clusters, cooperatives, and registered organic grower groups.",
            "official_link": "https://www.nmpb.nic.in/",
            "contact": "Regional-cum-Facilitation Centres (RCFC - NMPB)",
            "last_checked": "October 2026"
        },
        {
            "title": "KVK Agronomy Helpline & Soil Testing Network",
            "agency": "Indian Council of Agricultural Research (ICAR)",
            "scheme_summary": "Free soil nutrient health card profiling, microbial biofertilizer culture kits, and GAP certification counseling.",
            "eligibility": "All registered agricultural and horticultural landholders.",
            "official_link": "https://kvk.icar.gov.in/",
            "contact": "Toll Free Kisan Call Centre: 1800-180-1551",
            "last_checked": "October 2026"
        }
    ]
    return {"total_resources": len(resources), "resources": resources}
