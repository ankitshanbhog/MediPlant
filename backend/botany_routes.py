from typing import List ,Optional ,Dict ,Any
from pydantic import BaseModel
from fastapi import APIRouter ,HTTPException ,Query ,Depends
from botany_db import (
get_all_plants_from_db ,
get_plant_by_id_from_db ,
get_all_diseases_from_db ,
get_all_remedies_from_db ,
init_botany_db ,
seed_botany_data ,
get_db_connection
)
import json
from datetime import datetime

botany_router =APIRouter (prefix ="/botany",tags =["Botanical Catalog & Expansion Engine"])

def init_botany_features ():
    init_botany_db ()
    seed_botany_data ()

class NewPlantCreate (BaseModel ):
    id :str
    commonName :str
    scientificName :str
    family :str
    vernacularNames :Dict [str ,str ]={}
    description :str
    imageUrl :str
    medicinalUses :List [str ]=[]
    healthBenefits :List [str ]=[]
    traditionalUses :List [str ]=[]
    activeConstituents :List [str ]=[]
    partsUsed :List [str ]=[]
    sideEffects :List [str ]=[]
    precautions :List [str ]=[]
    contraindications :List [str ]=[]
    preparationMethods :str =""
    dosageGuidelines :str =""
    habitat :str =""
    appearance :str =""
    plantType :str ="Medicinal Herb"
    isSupportedInModel2 :bool =False

@botany_router .get ("/plants")
def list_plants (q :Optional [str ]=Query (None ,description ="Search by common or scientific name")):
    """Retrieve all medicinal plants stored in Neon Cloud DB."""
    plants =get_all_plants_from_db (query =q )
    return {"total":len (plants ),"plants":plants }

@botany_router .get ("/plants/{plant_id}")
def get_plant_detail (plant_id :str ):
    """Retrieve complete botanical, medicinal, and safety details for a plant."""
    plant =get_plant_by_id_from_db (plant_id )
    if not plant :
        raise HTTPException (status_code =404 ,detail =f"Plant '{plant_id }' not found in catalog.")
    return plant

@botany_router .post ("/plants")
def add_new_plant (req :NewPlantCreate ):
    """Add a new medicinal plant species to expand the dataset in Neon DB."""
    plant_id =req .id .strip ().lower ().replace (" ","_")
    existing =get_plant_by_id_from_db (plant_id )
    if existing :
        raise HTTPException (status_code =409 ,detail =f"A plant with id '{plant_id }' already exists.")

    conn =get_db_connection ()
    cursor =conn .cursor ()
    now_str =datetime .utcnow ().isoformat ()

    cursor .execute ("""
        INSERT INTO plants (
            id, commonName, scientificName, family, vernacularNames,
            description, imageUrl, medicinalUses, healthBenefits, traditionalUses,
            activeConstituents, partsUsed, sideEffects, precautions, contraindications,
            preparationMethods, dosageGuidelines, habitat, appearance, plantType,
            isSupportedInModel2, created_at
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """,(
    plant_id ,req .commonName .strip (),req .scientificName .strip (),req .family .strip (),
    json .dumps (req .vernacularNames ),req .description .strip (),req .imageUrl .strip (),
    json .dumps (req .medicinalUses ),json .dumps (req .healthBenefits ),json .dumps (req .traditionalUses ),
    json .dumps (req .activeConstituents ),json .dumps (req .partsUsed ),json .dumps (req .sideEffects ),
    json .dumps (req .precautions ),json .dumps (req .contraindications ),req .preparationMethods .strip (),
    req .dosageGuidelines .strip (),req .habitat .strip (),req .appearance .strip (),req .plantType .strip (),
    1 if req .isSupportedInModel2 else 0 ,now_str
    ))
    conn .commit ()
    conn .close ()

    return {"message":f"Plant '{req .commonName }' added successfully to Neon DB.","id":plant_id }

@botany_router .get ("/diseases")
def list_diseases ():
    """Retrieve all disease and health condition profiles."""
    diseases =get_all_diseases_from_db ()
    return {"total":len (diseases ),"diseases":diseases }

@botany_router .get ("/remedies")
def list_remedies ():
    """Retrieve all home herbal remedies and preparations."""
    remedies =get_all_remedies_from_db ()
    return {"total":len (remedies ),"remedies":remedies }
