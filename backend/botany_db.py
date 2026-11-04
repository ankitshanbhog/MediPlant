import os
import json
from datetime import datetime
from auth_db import get_db_connection ,is_postgres

BASE_DIR =os .path .dirname (os .path .abspath (__file__ ))
SEED_JSON_PATH =os .path .join (BASE_DIR ,"botany_seed.json")

def init_botany_db ():
    conn =get_db_connection ()
    cursor =conn .cursor ()

    cursor .execute ("""
        CREATE TABLE IF NOT EXISTS plants (
            id TEXT PRIMARY KEY,
            commonName TEXT NOT NULL,
            scientificName TEXT NOT NULL,
            family TEXT NOT NULL,
            vernacularNames TEXT NOT NULL,
            description TEXT NOT NULL,
            imageUrl TEXT NOT NULL,
            medicinalUses TEXT NOT NULL,
            healthBenefits TEXT NOT NULL,
            traditionalUses TEXT NOT NULL,
            activeConstituents TEXT NOT NULL,
            partsUsed TEXT NOT NULL,
            sideEffects TEXT NOT NULL,
            precautions TEXT NOT NULL,
            contraindications TEXT NOT NULL,
            preparationMethods TEXT NOT NULL,
            dosageGuidelines TEXT NOT NULL,
            habitat TEXT NOT NULL,
            appearance TEXT NOT NULL DEFAULT '',
            plantType TEXT NOT NULL DEFAULT 'Medicinal Herb',
            isSupportedInModel2 INTEGER NOT NULL DEFAULT 1,
            created_at TEXT NOT NULL DEFAULT ''
        )
    """)

    cursor .execute ("""
        CREATE TABLE IF NOT EXISTS diseases (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            category TEXT NOT NULL,
            description TEXT NOT NULL,
            symptoms TEXT NOT NULL,
            iconName TEXT NOT NULL,
            relatedPlantIds TEXT NOT NULL,
            homeRemedyIds TEXT NOT NULL,
            medicalDisclaimer TEXT NOT NULL,
            created_at TEXT NOT NULL DEFAULT ''
        )
    """)

    cursor .execute ("""
        CREATE TABLE IF NOT EXISTS remedies (
            id TEXT PRIMARY KEY,
            condition TEXT NOT NULL,
            title TEXT NOT NULL,
            primaryPlantName TEXT NOT NULL,
            primaryPlantScientific TEXT NOT NULL,
            plantId TEXT,
            ingredients TEXT NOT NULL,
            preparationSteps TEXT NOT NULL,
            howToUse TEXT NOT NULL,
            dosage TEXT NOT NULL,
            precautions TEXT NOT NULL,
            category TEXT NOT NULL,
            timeToPrepare TEXT NOT NULL,
            isEducationalOnly INTEGER NOT NULL DEFAULT 1,
            created_at TEXT NOT NULL DEFAULT ''
        )
    """)

    conn .commit ()
    conn .close ()

def seed_botany_data ():
    init_botany_db ()
    if not os .path .exists (SEED_JSON_PATH ):
        return

    conn =get_db_connection ()
    cursor =conn .cursor ()

    cursor .execute ("SELECT COUNT(*) as cnt FROM plants")
    row =cursor .fetchone ()
    count =row ["cnt"]if isinstance (row ,dict )else row [0 ]

    if count >0 :
        conn .close ()
        return

    with open (SEED_JSON_PATH ,"r",encoding ="utf-8")as f :
        data =json .load (f )

    now_str =datetime .utcnow ().isoformat ()

    for p in data .get ("plants",[]):
        cursor .execute ("""
            INSERT INTO plants (
                id, commonName, scientificName, family, vernacularNames,
                description, imageUrl, medicinalUses, healthBenefits, traditionalUses,
                activeConstituents, partsUsed, sideEffects, precautions, contraindications,
                preparationMethods, dosageGuidelines, habitat, appearance, plantType,
                isSupportedInModel2, created_at
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,(
        p ["id"],p ["commonName"],p ["scientificName"],p ["family"],
        json .dumps (p ["vernacularNames"]),p ["description"],p ["imageUrl"],
        json .dumps (p ["medicinalUses"]),json .dumps (p ["healthBenefits"]),json .dumps (p ["traditionalUses"]),
        json .dumps (p ["activeConstituents"]),json .dumps (p ["partsUsed"]),json .dumps (p ["sideEffects"]),
        json .dumps (p ["precautions"]),json .dumps (p ["contraindications"]),p ["preparationMethods"],
        p ["dosageGuidelines"],p ["habitat"],p .get ("appearance",""),p .get ("plantType","Medicinal Herb"),
        1 if p .get ("isSupportedInModel2",True )else 0 ,now_str
        ))

    for d in data .get ("diseases",[]):
        cursor .execute ("""
            INSERT INTO diseases (
                id, name, category, description, symptoms,
                iconName, relatedPlantIds, homeRemedyIds, medicalDisclaimer, created_at
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,(
        d ["id"],d ["name"],d ["category"],d ["description"],
        json .dumps (d ["symptoms"]),d ["iconName"],json .dumps (d ["relatedPlantIds"]),
        json .dumps (d ["homeRemedyIds"]),d .get ("medicalDisclaimer",""),now_str
        ))

    for r in data .get ("remedies",[]):
        cursor .execute ("""
            INSERT INTO remedies (
                id, condition, title, primaryPlantName, primaryPlantScientific,
                plantId, ingredients, preparationSteps, howToUse, dosage,
                precautions, category, timeToPrepare, isEducationalOnly, created_at
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,(
        r ["id"],r ["condition"],r ["title"],r ["primaryPlantName"],r ["primaryPlantScientific"],
        r .get ("plantId"),json .dumps (r ["ingredients"]),json .dumps (r ["preparationSteps"]),
        r ["howToUse"],r ["dosage"],json .dumps (r ["precautions"]),r ["category"],
        r .get ("timeToPrepare","10 mins"),1 if r .get ("isEducationalOnly",True )else 0 ,now_str
        ))

    conn .commit ()
    conn .close ()
    print ("Botany catalog successfully seeded to database.")

def get_all_plants_from_db (query :str =None ):
    conn =get_db_connection ()
    cursor =conn .cursor ()
    if query and query .strip ():
        q =f"%{query .strip ().lower ()}%"
        cursor .execute ("""
            SELECT * FROM plants
            WHERE LOWER(commonName) LIKE ?
               OR LOWER(scientificName) LIKE ?
               OR LOWER(description) LIKE ?
            ORDER BY commonName ASC
        """,(q ,q ,q ))
    else :
        cursor .execute ("SELECT * FROM plants ORDER BY commonName ASC")
    rows =cursor .fetchall ()
    conn .close ()

    result =[]
    for r in rows :
        d =dict (r )

        for field in ["vernacularNames","medicinalUses","healthBenefits","traditionalUses","activeConstituents","partsUsed","sideEffects","precautions","contraindications"]:
            if isinstance (d .get (field ),str ):
                try :
                    d [field ]=json .loads (d [field ])
                except Exception :
                    pass
        d ["isSupportedInModel2"]=bool (d .get ("isSupportedInModel2",1 ))
        result .append (d )
    return result

def get_plant_by_id_from_db (plant_id :str ):
    conn =get_db_connection ()
    cursor =conn .cursor ()
    cursor .execute ("SELECT * FROM plants WHERE id = ?",(plant_id .strip ().lower (),))
    row =cursor .fetchone ()
    conn .close ()
    if not row :
        return None
    d =dict (row )
    for field in ["vernacularNames","medicinalUses","healthBenefits","traditionalUses","activeConstituents","partsUsed","sideEffects","precautions","contraindications"]:
        if isinstance (d .get (field ),str ):
            try :
                d [field ]=json .loads (d [field ])
            except Exception :
                pass
    d ["isSupportedInModel2"]=bool (d .get ("isSupportedInModel2",1 ))
    return d

def get_all_diseases_from_db ():
    conn =get_db_connection ()
    cursor =conn .cursor ()
    cursor .execute ("SELECT * FROM diseases ORDER BY name ASC")
    rows =cursor .fetchall ()
    conn .close ()
    result =[]
    for r in rows :
        d =dict (r )
        for field in ["symptoms","relatedPlantIds","homeRemedyIds"]:
            if isinstance (d .get (field ),str ):
                try :
                    d [field ]=json .loads (d [field ])
                except Exception :
                    pass
        result .append (d )
    return result

def get_all_remedies_from_db ():
    conn =get_db_connection ()
    cursor =conn .cursor ()
    cursor .execute ("SELECT * FROM remedies ORDER BY title ASC")
    rows =cursor .fetchall ()
    conn .close ()
    result =[]
    for r in rows :
        d =dict (r )
        for field in ["ingredients","preparationSteps","precautions"]:
            if isinstance (d .get (field ),str ):
                try :
                    d [field ]=json .loads (d [field ])
                except Exception :
                    pass
        d ["isEducationalOnly"]=bool (d .get ("isEducationalOnly",1 ))
        result .append (d )
    return result

if __name__ =="__main__":
    init_botany_db ()
    seed_botany_data ()
