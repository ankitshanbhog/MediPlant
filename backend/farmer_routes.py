import os
import json
from datetime import datetime
from typing import List ,Optional
from pydantic import BaseModel
from fastapi import APIRouter ,Depends ,HTTPException ,status
from farmer_db import get_db_connection ,init_farmer_db ,seed_farmer_sample_data
from auth_service import get_current_user ,require_roles

farmer_router =APIRouter (prefix ="/farmer",tags =["Farmer & Grower Ecosystem"])

def init_farmer_features ():
    init_farmer_db ()
    seed_farmer_sample_data ()

class ProfileUpdateRequest (BaseModel ):
    farm_name :str
    region :str
    farming_method :str
    experience_years :int =1
    bio :Optional [str ]=None
    contact_phone :Optional [str ]=None

class CropRecordCreate (BaseModel ):
    plant_name :str
    stage :str
    sowing_date :Optional [str ]=None
    expected_harvest :Optional [str ]=None
    quantity :Optional [str ]=None
    notes :Optional [str ]=None

class CropStageUpdate (BaseModel ):
    stage :str
    notes :Optional [str ]=None

class StockBatchCreate (BaseModel ):
    plant_name :str
    state :str
    quantity :float
    unit :str ="kg"
    quality_notes :Optional [str ]=None
    harvest_date :Optional [str ]=None
    status :str ="In Stock"
    price_per_unit :Optional [str ]=None

class StockStatusUpdate (BaseModel ):
    status :str

class InquiryStatusUpdate (BaseModel ):
    status :str

@farmer_router .get ("/overview",dependencies =[Depends (require_roles (["farmer"]))])
def get_farmer_overview (current_user :dict =Depends (get_current_user )):
    f_id =current_user ["id"]
    conn =get_db_connection ()
    cursor =conn .cursor ()

    cursor .execute ("SELECT * FROM grower_profiles WHERE farmer_id = ?",(f_id ,))
    p_row =cursor .fetchone ()
    profile =dict (p_row )if p_row else {
    "farm_name":"My Herbal Farm",
    "region":"Not Set",
    "farming_method":"Natural Cultivation",
    "experience_years":1 ,
    "bio":"Registered grower on MediPlant network.",
    "contact_phone":"",
    }

    cursor .execute ("SELECT COUNT(*) as count FROM farmer_crops WHERE farmer_id = ?",(f_id ,))
    crops_count =cursor .fetchone ()["count"]

    cursor .execute ("SELECT COUNT(*) as count, SUM(quantity) as total_kg FROM stock_batches WHERE farmer_id = ? AND status = 'In Stock'",(f_id ,))
    stock_stat =cursor .fetchone ()

    cursor .execute ("SELECT COUNT(*) as count FROM buyer_inquiries WHERE farmer_id = ? AND status = 'pending'",(f_id ,))
    pending_inquiries =cursor .fetchone ()["count"]

    conn .close ()

    return {
    "farmer_name":current_user ["name"],
    "is_verified":current_user ["is_verified"],
    "profile":profile ,
    "stats":{
    "active_crops":crops_count ,
    "in_stock_batches":stock_stat ["count"]or 0 ,
    "total_stock_kg":round (stock_stat ["total_kg"]or 0.0 ,1 ),
    "pending_inquiries":pending_inquiries ,
    },
    "verification_explanation":(
    "Your grower profile is botanically authenticated by MediPlant reviewers. "
    "Verified status confirms your agricultural identity and adherence to GAP (Good Agricultural Practices)."
    if current_user ["is_verified"]else
    "Account verification is in review. You can list crops and manage harvest batches while review is pending."
    )
    }

@farmer_router .get ("/profile",dependencies =[Depends (require_roles (["farmer"]))])
def get_grower_profile (current_user :dict =Depends (get_current_user )):
    conn =get_db_connection ()
    cursor =conn .cursor ()
    cursor .execute ("SELECT * FROM grower_profiles WHERE farmer_id = ?",(current_user ["id"],))
    row =cursor .fetchone ()
    conn .close ()

    if not row :
        return {
        "farm_name":f"{current_user ['name']}'s Medicinal Farm",
        "region":"Pending Configuration",
        "farming_method":"Traditional / Organic",
        "experience_years":1 ,
        "bio":"Herbal cultivator focused on high-quality botanical planting materials.",
        "contact_phone":"",
        "is_verified":current_user ["is_verified"],
        }
    data =dict (row )
    data ["is_verified"]=current_user ["is_verified"]
    return data

@farmer_router .put ("/profile",dependencies =[Depends (require_roles (["farmer"]))])
def update_grower_profile (req :ProfileUpdateRequest ,current_user :dict =Depends (get_current_user )):
    f_id =current_user ["id"]
    conn =get_db_connection ()
    cursor =conn .cursor ()
    cursor .execute ("""
        INSERT INTO grower_profiles (farmer_id, farm_name, region, farming_method, experience_years, bio, contact_phone)
        VALUES (?, ?, ?, ?, ?, ?, ?)
        ON CONFLICT(farmer_id) DO UPDATE SET
            farm_name = excluded.farm_name,
            region = excluded.region,
            farming_method = excluded.farming_method,
            experience_years = excluded.experience_years,
            bio = excluded.bio,
            contact_phone = excluded.contact_phone
    """,(f_id ,req .farm_name .strip (),req .region .strip (),req .farming_method .strip (),req .experience_years ,req .bio ,req .contact_phone ))
    conn .commit ()
    conn .close ()

    return {"message":"Grower profile updated successfully.","profile":req .dict ()}

@farmer_router .get ("/crops",dependencies =[Depends (require_roles (["farmer"]))])
def list_farmer_crops (current_user :dict =Depends (get_current_user )):
    conn =get_db_connection ()
    cursor =conn .cursor ()
    cursor .execute ("SELECT * FROM farmer_crops WHERE farmer_id = ? ORDER BY id DESC",(current_user ["id"],))
    crops =[dict (row )for row in cursor .fetchall ()]
    conn .close ()
    return {"count":len (crops ),"crops":crops }

@farmer_router .post ("/crops",dependencies =[Depends (require_roles (["farmer"]))])
def create_farmer_crop (req :CropRecordCreate ,current_user :dict =Depends (get_current_user )):
    conn =get_db_connection ()
    cursor =conn .cursor ()
    now_str =datetime .utcnow ().strftime ("%Y-%m-%d %H:%M")
    cursor .execute ("""
        INSERT INTO farmer_crops (farmer_id, plant_name, stage, sowing_date, expected_harvest, quantity, notes, created_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    """,(current_user ["id"],req .plant_name .strip (),req .stage .strip (),req .sowing_date ,req .expected_harvest ,req .quantity ,req .notes ,now_str ))
    crop_id =cursor .lastrowid
    conn .commit ()
    conn .close ()

    return {
    "message":"Crop batch registered in calendar.",
    "crop":{
    "id":crop_id ,
    "plant_name":req .plant_name ,
    "stage":req .stage ,
    "sowing_date":req .sowing_date ,
    "expected_harvest":req .expected_harvest ,
    "quantity":req .quantity ,
    "notes":req .notes ,
    }
    }

@farmer_router .put ("/crops/{crop_id}/stage",dependencies =[Depends (require_roles (["farmer"]))])
def update_crop_stage (crop_id :int ,req :CropStageUpdate ,current_user :dict =Depends (get_current_user )):
    conn =get_db_connection ()
    cursor =conn .cursor ()
    cursor .execute ("""
        UPDATE farmer_crops SET stage = ?, notes = COALESCE(?, notes)
        WHERE id = ? AND farmer_id = ?
    """,(req .stage ,req .notes ,crop_id ,current_user ["id"]))
    if cursor .rowcount ==0 :
        conn .close ()
        raise HTTPException (status_code =404 ,detail ="Crop record not found or unauthorized.")
    conn .commit ()
    conn .close ()
    return {"message":"Crop stage updated."}

@farmer_router .delete ("/crops/{crop_id}",dependencies =[Depends (require_roles (["farmer"]))])
def delete_farmer_crop (crop_id :int ,current_user :dict =Depends (get_current_user )):
    conn =get_db_connection ()
    cursor =conn .cursor ()
    cursor .execute ("DELETE FROM farmer_crops WHERE id = ? AND farmer_id = ?",(crop_id ,current_user ["id"]))
    if cursor .rowcount ==0 :
        conn .close ()
        raise HTTPException (status_code =404 ,detail ="Crop record not found.")
    conn .commit ()
    conn .close ()
    return {"message":"Crop record deleted."}

@farmer_router .get ("/stock",dependencies =[Depends (require_roles (["farmer"]))])
def list_stock_batches (current_user :dict =Depends (get_current_user )):
    conn =get_db_connection ()
    cursor =conn .cursor ()
    cursor .execute ("SELECT * FROM stock_batches WHERE farmer_id = ? ORDER BY id DESC",(current_user ["id"],))
    batches =[dict (row )for row in cursor .fetchall ()]
    conn .close ()
    return {"count":len (batches ),"batches":batches }

@farmer_router .post ("/stock",dependencies =[Depends (require_roles (["farmer"]))])
def create_stock_batch (req :StockBatchCreate ,current_user :dict =Depends (get_current_user )):
    conn =get_db_connection ()
    cursor =conn .cursor ()
    now_str =datetime .utcnow ().strftime ("%Y-%m-%d %H:%M")
    cursor .execute ("""
        INSERT INTO stock_batches (farmer_id, plant_name, state, quantity, unit, quality_notes, harvest_date, status, price_per_unit, created_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """,(current_user ["id"],req .plant_name .strip (),req .state .strip (),req .quantity ,req .unit .strip (),req .quality_notes ,req .harvest_date ,req .status ,req .price_per_unit ,now_str ))
    batch_id =cursor .lastrowid
    conn .commit ()
    conn .close ()

    return {"message":"Harvest batch added to stock.","batch_id":batch_id }

@farmer_router .put ("/stock/{batch_id}/status",dependencies =[Depends (require_roles (["farmer"]))])
def update_stock_status (batch_id :int ,req :StockStatusUpdate ,current_user :dict =Depends (get_current_user )):
    conn =get_db_connection ()
    cursor =conn .cursor ()
    cursor .execute ("""
        UPDATE stock_batches SET status = ?
        WHERE id = ? AND farmer_id = ?
    """,(req .status ,batch_id ,current_user ["id"]))
    if cursor .rowcount ==0 :
        conn .close ()
        raise HTTPException (status_code =404 ,detail ="Stock batch not found or unauthorized.")
    conn .commit ()
    conn .close ()
    return {"message":f"Stock status updated to '{req .status }'."}

@farmer_router .delete ("/stock/{batch_id}",dependencies =[Depends (require_roles (["farmer"]))])
def delete_stock_batch (batch_id :int ,current_user :dict =Depends (get_current_user )):
    conn =get_db_connection ()
    cursor =conn .cursor ()
    cursor .execute ("DELETE FROM stock_batches WHERE id = ? AND farmer_id = ?",(batch_id ,current_user ["id"]))
    if cursor .rowcount ==0 :
        conn .close ()
        raise HTTPException (status_code =404 ,detail ="Stock batch not found.")
    conn .commit ()
    conn .close ()
    return {"message":"Stock batch removed."}

@farmer_router .get ("/inquiries",dependencies =[Depends (require_roles (["farmer"]))])
def list_buyer_inquiries (current_user :dict =Depends (get_current_user )):
    conn =get_db_connection ()
    cursor =conn .cursor ()
    cursor .execute ("SELECT * FROM buyer_inquiries WHERE farmer_id = ? ORDER BY id DESC",(current_user ["id"],))
    inquiries =[dict (row )for row in cursor .fetchall ()]
    conn .close ()
    return {"count":len (inquiries ),"inquiries":inquiries }

@farmer_router .put ("/inquiries/{inquiry_id}/status",dependencies =[Depends (require_roles (["farmer"]))])
def update_inquiry_status (inquiry_id :int ,req :InquiryStatusUpdate ,current_user :dict =Depends (get_current_user )):
    conn =get_db_connection ()
    cursor =conn .cursor ()
    cursor .execute ("""
        UPDATE buyer_inquiries SET status = ?
        WHERE id = ? AND farmer_id = ?
    """,(req .status ,inquiry_id ,current_user ["id"]))
    if cursor .rowcount ==0 :
        conn .close ()
        raise HTTPException (status_code =404 ,detail ="Inquiry not found or unauthorized.")
    conn .commit ()
    conn .close ()
    return {"message":f"Inquiry marked as '{req .status }'."}

@farmer_router.get("/cultivation-guides")
def get_cultivation_guides():
    guides = [
        {
            "species": "Ashwagandha (Withania somnifera)",
            "primary_part": "Roots & Seeds",
            "soil": "Sandy loam or light red soil, well-drained. pH 7.5 – 8.0.",
            "sunlight": "Full direct sunlight (6-8 hours daily).",
            "climate": "Sub-tropical dry zones with 500–750 mm rainfall.",
            "propagation": "10 – 12 kg/ha (broadcasting) or 5 kg/ha (line sowing at 20 cm × 10 cm).",
            "irrigation": "Predominantly rainfed late-kharif crop. 1–2 life-saving light irrigations during dry spells.",
            "spacing": "20 cm row-to-row × 10 cm plant-to-plant.",
            "pests": "Aphids, mites, seedling blight. Controlled with neem oil (5 ml/L) spray.",
            "harvesting": "150–180 days after sowing when leaves yellow and berries turn red.",
            "post_harvest": "Roots washed carefully, shade-dried to < 10% moisture, cut into 7–10 cm pieces; grade A, B, C."
        },
        {
            "species": "Tulsi (Ocimum sanctum)",
            "primary_part": "Leaves & Flowering Tops",
            "soil": "Fertile loamy to sandy loam soils with rich organic matter. pH 6.5 – 7.5.",
            "sunlight": "Full bright sunlight.",
            "climate": "Warm tropical and subtropical climate. Vulnerable to severe frost.",
            "propagation": "250 – 300 g seeds/ha for nursery raising. Transplant seedlings at 40 cm × 40 cm.",
            "irrigation": "Weekly irrigation during summer; once every 12–15 days during winter.",
            "spacing": "40 cm × 40 cm bushy spacing.",
            "pests": "Leaf rollers and lace bugs. Organic neem seed kernel extract spray.",
            "harvesting": "First cut at 75–85 days when plants reach full bloom; repeat every 60–70 days.",
            "post_harvest": "Shade-dry over clean tarpaulins for 8–10 days to preserve volatile essential oils."
        },
        {
            "species": "Aloe Vera (Aloe barbadensis)",
            "primary_part": "Fleshy Leaves",
            "soil": "Sandy coastal soils to degraded marginal lands with good drainage. pH 7.0 – 8.5.",
            "sunlight": "Full sun exposure.",
            "climate": "Arid and semi-arid tropical regions. Highly drought-tolerant.",
            "propagation": "Root suckers. 25,000 – 30,000 suckers/ha planted at 60 cm × 60 cm.",
            "irrigation": "Low. 1 irrigation after planting; 4–6 light irrigations per year.",
            "spacing": "60 cm × 60 cm grid.",
            "pests": "Mealybugs and black rot. Avoid water stagnation.",
            "harvesting": "Outer mature leaves (12–14 months old) reaching 40–50 cm length.",
            "post_harvest": "Slice cleanly at base. Transport to processing unit within 4–6 hours to prevent gel oxidation."
        },
        {
            "species": "Amla (Phyllanthus emblica)",
            "primary_part": "Fresh & Dried Fruits",
            "soil": "Deep loamy to clay-loam soil. Sodic and saline tolerant up to pH 9.5.",
            "sunlight": "Full open orchard exposure.",
            "climate": "Tropical to subtropical, hardy against summer heat (up to 46°C).",
            "propagation": "Budded/grafted saplings (NA-7, Krishna, Kanchan). 200 trees/ha spaced at 7 m × 7 m.",
            "irrigation": "Protective irrigation during fruit development in summer.",
            "spacing": "7 m × 7 m orchard grid.",
            "pests": "Bark eating caterpillar and fruit borer. Biological pheromone traps.",
            "harvesting": "Mature fruits turn greenish-yellow from November to January.",
            "post_harvest": "Steam-blanch, deseed, and solar-dry to moisture < 8% for dried flakes."
        },
        {
            "species": "Brahmi (Bacopa monnieri)",
            "primary_part": "Whole Herb & Leaves",
            "soil": "Wet, marshy, clay-loam to alluvial soil with high moisture retention. pH 6.0 – 7.5.",
            "sunlight": "Warm, humid tropical climate with abundant sunshine.",
            "climate": "Wet tropical zones.",
            "propagation": "Vegetative stem cuttings (5–10 cm long). 60,000 cuttings/ha planted at 20 cm × 20 cm.",
            "irrigation": "High water requirement. Field must remain continuously moist or lightly flooded.",
            "spacing": "20 cm × 20 cm grid.",
            "pests": "Grasshoppers and leaf blight.",
            "harvesting": "First harvest 90 days after planting; repeat cuts every 60–75 days.",
            "post_harvest": "Wash herbage thoroughly, shade-dry on raised wire-mesh racks to retain green color."
        },
        {
            "species": "Gotu Kola (Centella asiatica)",
            "primary_part": "Leaves & Whole Herb",
            "soil": "Rich damp sandy-clay loam with plentiful humus. pH 6.5 – 7.5.",
            "sunlight": "Partial shade (25–30% shade netting ideal) or filtered sunlight.",
            "climate": "Warm and humid tropical climate, 22°C - 32°C.",
            "propagation": "Stolon cuttings or rooted runners. 40,000 runners/ha planted at 30 cm × 30 cm.",
            "irrigation": "Regular sprinkler or channel irrigation every 4–6 days.",
            "spacing": "30 cm × 30 cm creeping groundcover.",
            "pests": "Caterpillars and leaf spot. Bio-fungicide Trichoderma applied to roots.",
            "harvesting": "Leaves expand to 3–5 cm width (80–90 days). Subsequent cuts every 50 days.",
            "post_harvest": "Harvest early morning. Shade-dry over clean mats to preserve asiaticoside levels."
        },
        {
            "species": "Moringa (Moringa oleifera)",
            "primary_part": "Leaves, Pods & Seeds",
            "soil": "Well-drained sandy or loamy soil. Sensitive to water stagnation. pH 6.5 – 8.0.",
            "sunlight": "Full tropical sun.",
            "climate": "Warm tropical and subtropical belts.",
            "propagation": "500 g seeds/ha planted at 1 m × 1 m for high-density leaf production.",
            "irrigation": "Drip irrigation every 7–10 days ensures continuous leaf flushing in summer.",
            "spacing": "1 m × 1 m high density.",
            "pests": "Hairy caterpillars and pod fly.",
            "harvesting": "First cut at 70–80 days when plants reach 1.2 m height; harvest every 45 days.",
            "post_harvest": "Strip leaflets, wash in clean water, shade-dry at < 45°C to preserve vitamins."
        },
        {
            "species": "Neem (Azadirachta indica)",
            "primary_part": "Seeds & Leaves",
            "soil": "Hard rocky, shallow, nutrient-poor dry soils. Highly resilient. pH 6.2 – 8.5.",
            "sunlight": "Full bright sunlight.",
            "climate": "Arid to semi-arid tropical zones.",
            "propagation": "Polybag-raised seedlings. 200 – 250 trees/ha spaced at 6 m × 6 m.",
            "irrigation": "Only required in the first 1-2 years until deep taproot establishes.",
            "spacing": "6 m × 6 m farm boundary or agro-forestry.",
            "pests": "Naturally insect repellent; rarely plagued by pests.",
            "harvesting": "Seed berries collected from ground when yellow (June – August).",
            "post_harvest": "Seeds depulped, washed, sun dried for cold-pressed neem oil extraction."
        },
        {
            "species": "Sarpagandha (Rauvolfia serpentina)",
            "primary_part": "Roots (Reserpine)",
            "soil": "Deep sandy loam or clay loam rich in humus. pH 4.5 – 6.0.",
            "sunlight": "Humid tropical forests; needs sheltered partial shade.",
            "climate": "Humid tropical climate (1,500–2,500 mm rainfall).",
            "propagation": "Root cuttings or nursery seedlings. 40,000 plants/ha planted at 45 cm × 30 cm.",
            "irrigation": "Requires 12–15 irrigations per year during dry non-monsoon periods.",
            "spacing": "45 cm × 30 cm.",
            "pests": "Root rot and leaf spot.",
            "harvesting": "Harvest after 2 to 3 years when root reserpine content peaks.",
            "post_harvest": "Dig root system with minimal breakage. Wash clean, cut into 10–12 cm pieces, sun-dry to 8% moisture."
        },
        {
            "species": "Rosemary (Salvia rosmarinus)",
            "primary_part": "Dried Leaves & Oil",
            "soil": "Light, calcareous, gravelly well-drained soil. pH 6.5 – 7.8.",
            "sunlight": "Temperate and sub-tropical hill regions with moderate sunshine.",
            "climate": "Cool subtropical and Mediterranean hill climate.",
            "propagation": "Terminal stem cuttings. 20,000 rooted cuttings/ha at 60 cm × 60 cm.",
            "irrigation": "Low water requirement. Drip irrigate once every 10–14 days.",
            "spacing": "60 cm × 60 cm.",
            "pests": "Spider mites and powdery mildew in high humidity.",
            "harvesting": "Clip tender top 10–15 cm shoots prior to blooming.",
            "post_harvest": "Dry in well-ventilated dark drying sheds at 32–35°C to preserve needle integrity."
        }
    ]
    return {"total_guides": len(guides), "guides": guides}

@farmer_router.get("/market-info")
def get_market_information():
    benchmarks = [
        {
            "crop": "Ashwagandha",
            "botanical_name": "Withania somnifera",
            "grade": "Grade A Thick Whole Root (Moisture < 10%)",
            "benchmark_price": "₹340 – ₹480 / kg",
            "trend": "+12% (High Demand)",
            "major_mandi": "APMC Neemuch & Mandsaur (Madhya Pradesh)",
            "demand_signal": "Strong demand from domestic AYUSH extractors & EU exporters.",
            "source": "e-Charak / NMPB Market Bulletin (Quarterly Review)",
            "last_updated": "November 2026"
        },
        {
            "crop": "Tulsi (Holy Basil)",
            "botanical_name": "Ocimum sanctum",
            "grade": "Clean Shade-Dried Leaves (Whole, Unbroken)",
            "benchmark_price": "₹85 – ₹135 / kg",
            "trend": "+5% (Steady)",
            "major_mandi": "Nagpur & Lucknow Mandis",
            "demand_signal": "Steady domestic demand for herbal teas and cold formulations.",
            "source": "National Medicinal Plants Board",
            "last_updated": "November 2026"
        },
        {
            "crop": "Amla (Indian Gooseberry)",
            "botanical_name": "Phyllanthus emblica",
            "grade": "Dried Deseeded Flakes (Moisture < 8%)",
            "benchmark_price": "₹125 – ₹180 / kg",
            "trend": "+8% (Firm)",
            "major_mandi": "Pratapgarh & Varanasi (Uttar Pradesh)",
            "demand_signal": "Bulk procurement by Chyawanprash manufacturers during winter.",
            "source": "Tribal Cooperative Marketing Federation",
            "last_updated": "November 2026"
        },
        {
            "crop": "Brahmi",
            "botanical_name": "Bacopa monnieri",
            "grade": "Whole Dried Herbage (Rich Green, Stem < 20%)",
            "benchmark_price": "₹140 – ₹210 / kg",
            "trend": "+15% (Rising)",
            "major_mandi": "Kolkata & Cuttack Markets",
            "demand_signal": "High demand from nootropic formulation brands and extractors.",
            "source": "State Medicinal Plants Board",
            "last_updated": "November 2026"
        },
        {
            "crop": "Gotu Kola (Mandukaparni)",
            "botanical_name": "Centella asiatica",
            "grade": "Shade-Dried Intact Leaves",
            "benchmark_price": "₹165 – ₹235 / kg",
            "trend": "+10% (High Demand)",
            "major_mandi": "Kochi & Thrissur Mandis (Kerala)",
            "demand_signal": "Sustained demand for dermatological and cognitive formulations.",
            "source": "Regional Agricultural Marketing Board",
            "last_updated": "November 2026"
        },
        {
            "crop": "Sarpagandha",
            "botanical_name": "Rauvolfia serpentina",
            "grade": "Dried Thick Root (Reserpine > 0.15%)",
            "benchmark_price": "₹750 – ₹1,150 / kg",
            "trend": "+18% (Scarce Supply)",
            "major_mandi": "Guwahati & Dehradun Botanical Auctions",
            "demand_signal": "Very high industrial demand due to strict wild collection bans.",
            "source": "Dehradun Forest Produce Trade Union",
            "last_updated": "November 2026"
        },
        {
            "crop": "Moringa Leaves",
            "botanical_name": "Moringa oleifera",
            "grade": "Organic Certified Fine Green Leaf Powder",
            "benchmark_price": "₹120 – ₹190 / kg",
            "trend": "+6% (Steady)",
            "major_mandi": "Dindigul & Theni (Tamil Nadu)",
            "demand_signal": "Robust export demand to European and North American wellness markets.",
            "source": "Tamil Nadu Spices & Horticulture Board",
            "last_updated": "November 2026"
        },
        {
            "crop": "Aloe Vera",
            "botanical_name": "Aloe barbadensis miller",
            "grade": "Fresh Mature Thick Leaves (Farmgate)",
            "benchmark_price": "₹6.50 – ₹11.00 / kg",
            "trend": "Stable",
            "major_mandi": "Jodhpur & Barmer Farmgate Collections (Rajasthan)",
            "demand_signal": "Continuous demand from cosmetic and beverage processing factories.",
            "source": "Rajasthan Agro Industries Development Corporation",
            "last_updated": "November 2026"
        }
    ]
    return {
        "disclaimer_notice": "Market figures are sourced wholesale benchmark ranges for farm planning. MediPlant does not guarantee buyer prices or market fulfillment.",
        "benchmarks": benchmarks
    }

@farmer_router.get("/agricultural-resources")
def get_agricultural_resources():
    resources = [
        {
            "title": "National Ayush Mission (NAM) Cultivation Subsidy",
            "agency": "National Medicinal Plants Board (NMPB), Ministry of AYUSH",
            "subsidy_rate": "30% to 50% of Total Cultivation Cost",
            "scheme_summary": "Financial assistance disbursed directly to farmers and FPOs for commercial cultivation of 140 prioritized medicinal plant species across eligible agro-climatic clusters.",
            "eligibility": "Individual farmers, SHGs, and registered FPOs with land titles (minimum 2 hectares cluster).",
            "official_link": "https://echarak.ayush.gov.in/",
            "helpline": "011-23653444 (Toll-free: 1800-11-22-33)",
            "last_checked": "November 2026"
        },
        {
            "title": "Mission for Integrated Development of Horticulture (MIDH)",
            "agency": "Ministry of Agriculture & Farmers Welfare, Govt of India",
            "subsidy_rate": "40% to 50% Capital Assistance",
            "scheme_summary": "Promoting protected cultivation (polyhouses, shade nets), certified disease-free nurseries, drip irrigation, and solar drying units for medicinal crops.",
            "eligibility": "Small and marginal farmers, horticultural cooperatives with land ownership or registered 10-year lease.",
            "official_link": "https://midh.gov.in/",
            "helpline": "1800-180-1551 (Kisan Call Center)",
            "last_checked": "November 2026"
        },
        {
            "title": "NHB Capital Investment Subsidy for Commercial Horticulture",
            "agency": "National Horticulture Board (NHB)",
            "subsidy_rate": "Up to ₹30 Lakhs (40% of Project Cost)",
            "scheme_summary": "Credit-linked back-ended subsidy for establishing commercial high-density medicinal crop farms and primary cleaning/grading warehouses.",
            "eligibility": "Individual farmers, partnerships, and cooperatives with minimum bank term loan of 50%.",
            "official_link": "https://nhb.gov.in/",
            "helpline": "0124-2342992",
            "last_checked": "November 2026"
        },
        {
            "title": "e-Charak Digital Direct Market Platform",
            "agency": "National Medicinal Plants Board (NMPB) & CDAC",
            "subsidy_rate": "100% Free Trade Registration & Listing",
            "scheme_summary": "Virtual electronic marketplace connecting certified medicinal plant growers directly with licensed pharmaceutical manufacturers to eliminate middleman margins.",
            "eligibility": "Any registered farmer or cooperative harvesting authentic botanical produce.",
            "official_link": "https://echarak.ayush.gov.in/",
            "helpline": "011-23653450",
            "last_checked": "November 2026"
        }
    ]
    return {"total_resources": len(resources), "resources": resources}
