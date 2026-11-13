"""
MediPlant Dual-Stage Inference Backend
FastAPI server connecting:
  Stage 1: Plant Gatekeeper ONNX Model (Plant vs Non-Plant Filter)
  Stage 2: 13-Class Medicinal Plant Classifier ONNX Model
"""

import io
import json
import logging
import os
import sys
from contextlib import asynccontextmanager
from typing import Any ,Dict ,List ,Optional

import numpy as np
import onnxruntime as ort
import uvicorn
from fastapi import FastAPI ,File ,HTTPException ,UploadFile ,status
from fastapi .middleware .cors import CORSMiddleware
from PIL import Image

logging .basicConfig (
level =logging .INFO ,
format ="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
)
logger =logging .getLogger ("MediPlantBackend")

BASE_DIR =os .path .dirname (os .path .abspath (__file__ ))

GATE_DIR =os .path .join (BASE_DIR ,"gate_keeper","exports")
GATE_MODEL_PATH =os .path .join (GATE_DIR ,"plant_gate_model.onnx")
GATE_CLASSES_PATH =os .path .join (GATE_DIR ,"gate_classes.json")

CLASSIFIER_DIR =os .path .join (BASE_DIR ,"plant_identifier_13","exports")
CLASSIFIER_MODEL_PATH =os .path .join (CLASSIFIER_DIR ,"medicinal_plant_model.onnx")
CLASSIFIER_CLASSES_PATH =os .path .join (CLASSIFIER_DIR ,"classes.json")

gate_session :Optional [ort .InferenceSession ]=None
gate_metadata :Dict [str ,Any ]={}
classifier_session :Optional [ort .InferenceSession ]=None
classifier_metadata :Dict [str ,Any ]={}

SPECIES_CATALOG ={
"aloe_vera":{
"common_name":"Aloe Vera",
"botanical_name":"Aloe barbadensis miller",
"family":"Asphodelaceae",
"key_benefits":"Skin healing, burn soothing, gut health, hydration",
},
"amla":{
"common_name":"Amla (Indian Gooseberry)",
"botanical_name":"Phyllanthus emblica",
"family":"Phyllanthaceae",
"key_benefits":"High vitamin C, immunity booster, hair nourishment, digestion",
},
"ashwagandha":{
"common_name":"Ashwagandha (Indian Ginseng)",
"botanical_name":"Withania somnifera",
"family":"Solanaceae",
"key_benefits":"Adaptogen, stress and cortisol reduction, vitality, sleep aid",
},
"ayapana":{
"common_name":"Ayapana",
"botanical_name":"Ayapana triplinervis",
"family":"Asteraceae",
"key_benefits":"Hemostatic wound healing, indigestion relief, antiseptic wash",
},
"brahmi":{
"common_name":"Brahmi (Water Hyssop)",
"botanical_name":"Bacopa monnieri",
"family":"Plantaginaceae",
"key_benefits":"Memory enhancement, cognitive clarity, neuroprotection, anxiety relief",
},
"gotu_kola":{
"common_name":"Gotu Kola (Mandukaparni)",
"botanical_name":"Centella asiatica",
"family":"Apiaceae",
"key_benefits":"Brain tonic, circulation, collagen synthesis, nervous calming",
},
"moringa":{
"common_name":"Moringa (Drumstick Tree)",
"botanical_name":"Moringa oleifera",
"family":"Moringaceae",
"key_benefits":"Superfood nutrient density, anti-inflammatory, antioxidant, energy",
},
"multi_vitamin_plant":{
"common_name":"Multi Vitamin Plant (Chakra Muni / Katuk)",
"botanical_name":"Sauropus androgynus",
"family":"Phyllanthaceae",
"key_benefits":"Multivitamin rich (A, B, C), calcium, iron, lactation support",
},
"neem":{
"common_name":"Neem (Indian Lilac)",
"botanical_name":"Azadirachta indica",
"family":"Meliaceae",
"key_benefits":"Potent antimicrobial, blood purifier, acne & skin healer, oral care",
},
"rosemary":{
"common_name":"Rosemary",
"botanical_name":"Salvia rosmarinus",
"family":"Lamiaceae",
"key_benefits":"Memory booster, hair follicle stimulation, respiratory decongestant",
},
"sarpagandha":{
"common_name":"Sarpagandha (Indian Snakeroot)",
"botanical_name":"Rauvolfia serpentina",
"family":"Apocynaceae",
"key_benefits":"Antihypertensive reserpine, blood pressure regulation, deep sedative",
},
"tulsi":{
"common_name":"Tulsi (Holy Basil)",
"botanical_name":"Ocimum tenuiflorum",
"family":"Lamiaceae",
"key_benefits":"Adaptogen, cough & cold relief, respiratory support, immune defense",
},
"wood_apple":{
"common_name":"Wood Apple (Bael / Elephant Apple)",
"botanical_name":"Limonia acidissima",
"family":"Rutaceae",
"key_benefits":"Digestive tonic, dysentery relief, gut cooling, antimicrobial",
},
}

def load_models ():
    """Load both ONNX sessions and metadata dictionaries."""
    global gate_session ,gate_metadata ,classifier_session ,classifier_metadata

    if os .path .exists (GATE_MODEL_PATH ):
        try :
            gate_session =ort .InferenceSession (
            GATE_MODEL_PATH ,
            providers =["CPUExecutionProvider"],
            )
            logger .info ("Stage 1 Gate ONNX Model loaded successfully from %s",GATE_MODEL_PATH )
        except Exception as e :
            logger .error ("Failed to initialize Gate ONNX session: %s",e )
    else :
        logger .warning ("Gate ONNX model not found at %s",GATE_MODEL_PATH )

    if os .path .exists (GATE_CLASSES_PATH ):
        try :
            with open (GATE_CLASSES_PATH ,"r",encoding ="utf-8")as f :
                gate_metadata =json .load (f )
            logger .info ("Gate metadata loaded: %s",gate_metadata .get ("class_names"))
        except Exception as e :
            logger .error ("Failed to read Gate metadata: %s",e )
    else :
        gate_metadata ={
        "class_names":["non_plant","plant"],
        "plant_class_index":1 ,
        "image_size":224 ,
        }

    if os .path .exists (CLASSIFIER_MODEL_PATH ):
        try :
            classifier_session =ort .InferenceSession (
            CLASSIFIER_MODEL_PATH ,
            providers =["CPUExecutionProvider"],
            )
            logger .info ("Stage 2 13-Class Identifier loaded from %s",CLASSIFIER_MODEL_PATH )
        except Exception as e :
            logger .error ("Failed to initialize Classifier ONNX session: %s",e )
    else :
        logger .warning ("Classifier ONNX model not found at %s",CLASSIFIER_MODEL_PATH )

    if os .path .exists (CLASSIFIER_CLASSES_PATH ):
        try :
            with open (CLASSIFIER_CLASSES_PATH ,"r",encoding ="utf-8")as f :
                classifier_metadata =json .load (f )
            logger .info ("Classifier metadata loaded: %d classes",len (classifier_metadata .get ("class_names",[])))
        except Exception as e :
            logger .error ("Failed to read Classifier metadata: %s",e )
    else :
        classifier_metadata ={
        "class_names":list (SPECIES_CATALOG .keys ()),
        "image_size":224 ,
        }

@asynccontextmanager
async def lifespan (app :FastAPI ):
    """Lifecycle manager to load models on startup."""
    load_models ()
    yield
    logger .info ("Shutting down MediPlant Backend service.")

app =FastAPI (
title ="MediPlant AI Vision Gateway",
description ="Dual-Stage ONNX Inference Backend for Botanical Verification and Medicinal Classification",
version ="2.0.0",
lifespan =lifespan ,
)

app .add_middleware (
CORSMiddleware ,
allow_origins =["*"],
allow_credentials =True ,
allow_methods =["*"],
allow_headers =["*"],
)

from auth_db import is_postgres ,DATABASE_URL
from auth_routes import auth_router ,seed_default_users
from farmer_routes import farmer_router ,init_farmer_features
from botany_routes import botany_router ,init_botany_features
try :
    seed_default_users ()
    app .include_router (auth_router )
    init_farmer_features ()
    app .include_router (farmer_router )
    init_botany_features ()
    app .include_router (botany_router )
    if is_postgres ():
        masked_host =DATABASE_URL .split ('@')[-1 ]if '@'in DATABASE_URL else 'Neon Cloud'
        logger .info ("Connected to Permanent Cloud PostgreSQL (Neon DB): %s",masked_host )
    else :
        logger .info ("Running on Local Persistent SQLite (backend/mediplant_auth.db). To use Neon DB, add DATABASE_URL in backend/.env")
    logger .info ("RBAC Authentication, Farmer Ecosystem & Botany Catalog registered successfully.")
except Exception as e :
    logger .error ("Failed to register routes: %s",e )

def softmax (x :np .ndarray )->np .ndarray :
    """Numerically stable softmax."""
    e_x =np .exp (x -np .max (x ,axis =-1 ,keepdims =True ))
    return e_x /np .sum (e_x ,axis =-1 ,keepdims =True )

def compute_entropy (probs :np .ndarray )->float :
    """Shannon entropy of probability distribution."""
    clipped =np .clip (probs ,1e-9 ,1.0 )
    return float (-np .sum (clipped *np .log (clipped )))

def evaluate_ood_signals (
    logits :np .ndarray ,
    probs :np .ndarray ,
    entropy_threshold :float =1.45 ,
    top1_threshold :float =0.65 ,
    min_margin :float =1.45 ,
    min_max_logit :float =2.85 ,
):
    """
    Evaluates whether a predicted sample is likely out-of-distribution (OOD)
    or an unsupported plant species using 4 complementary signals:
      1. Maximum Logit Score (MLS): checks if feature activation reaches known plant levels
      2. Logit Margin (1st - 2nd): checks if winner is strongly separated from runner-up
      3. Top-1 Softmax Confidence: must be at least 65%
      4. Shannon Entropy: must be lower than 1.45 (lower = certain, higher = confused)
    """
    s_logits =np .sort (logits )[::-1 ]
    max_logit =float (s_logits [0 ])
    logit_margin =float (max_logit -s_logits [1 ])if len (s_logits )>=2 else max_logit 

    top1_conf =float (np .max (probs ))
    entropy =compute_entropy (probs )
    sorted_probs =np .sort (probs )[::-1 ]
    top3_gap =float (sorted_probs [0 ]-sorted_probs [2 ])if len (sorted_probs )>=3 else float (sorted_probs [0 ])

    if max_logit <min_max_logit :
        return True ,f"low_logit_activation (max_logit={max_logit:.2f} < {min_max_logit})",entropy ,top3_gap 
    if logit_margin <min_margin :
        return True ,f"ambiguous_margin (margin={logit_margin:.2f} < {min_margin})",entropy ,top3_gap 
    if top1_conf <top1_threshold :
        return True ,f"low_confidence (confidence={top1_conf*100:.1f}% < {top1_threshold*100:.0f}%)",entropy ,top3_gap 
    if entropy >entropy_threshold :
        return True ,f"high_entropy (entropy={entropy:.2f} > {entropy_threshold})",entropy ,top3_gap 

    return False ,None ,entropy ,top3_gap 

def preprocess_image_bytes (image_bytes :bytes ,size :int =224 )->np .ndarray :
    """
    Standard MediPlant Preprocessing:
      1. Open and convert to RGB
      2. Aspect-preserving resize (size * 1.14)
      3. Center-crop to (size, size)
      4. Float normalize [0, 1]
      5. ImageNet mean/std normalization
      6. Transpose HWC -> CHW and add batch dimension -> [1, 3, size, size]
    """
    try :
        img =Image .open (io .BytesIO (image_bytes )).convert ("RGB")
    except Exception as exc :
        raise ValueError ("Invalid or corrupted image format")from exc

    target_crop =size
    target_scale =int (target_crop *1.14 )
    img =img .resize ((target_scale ,target_scale ),Image .BILINEAR )

    w ,h =img .size
    left =(w -target_crop )//2
    top =(h -target_crop )//2
    img =img .crop ((left ,top ,left +target_crop ,top +target_crop ))

    arr =np .array (img ,dtype =np .float32 )/255.0

    mean =np .array ([0.485 ,0.456 ,0.406 ],dtype =np .float32 )
    std =np .array ([0.229 ,0.224 ,0.225 ],dtype =np .float32 )
    arr =(arr -mean )/std

    arr =np .transpose (arr ,(2 ,0 ,1 ))
    arr =np .expand_dims (arr ,axis =0 )
    return arr

def generate_tta_tensors (image_bytes :bytes ,size :int =224 )->List [np .ndarray ]:
    """
    Test-Time Augmentation (TTA):
    Generates 5 augmented views of the input image for uncertainty and consistency evaluation:
      1. Standard center crop
      2. Horizontally flipped
      3. Slightly rotated clockwise (+8 deg)
      4. Slightly rotated counter-clockwise (-8 deg)
      5. Slightly zoomed/cropped (1.05x zoom)
    """
    try :
        raw_img =Image .open (io .BytesIO (image_bytes )).convert ("RGB")
    except Exception as exc :
        raise ValueError ("Invalid or corrupted image format")from exc

    target_crop =size
    target_scale =int (target_crop *1.14 )
    base_img =raw_img .resize ((target_scale ,target_scale ),Image .BILINEAR )
    w ,h =base_img .size
    left =(w -target_crop )//2
    top =(h -target_crop )//2

    views =[
    base_img .crop ((left ,top ,left +target_crop ,top +target_crop )),
    base_img .crop ((left ,top ,left +target_crop ,top +target_crop )).transpose (Image .FLIP_LEFT_RIGHT ),
    base_img .rotate (8 ,resample =Image .BILINEAR ).crop ((left ,top ,left +target_crop ,top +target_crop )),
    base_img .rotate (-8 ,resample =Image .BILINEAR ).crop ((left ,top ,left +target_crop ,top +target_crop )),
    ]

    zoom_crop =int (target_crop *0.92 )
    zoom_left =(w -zoom_crop )//2
    zoom_top =(h -zoom_crop )//2
    views .append (base_img .crop ((zoom_left ,zoom_top ,zoom_left +zoom_crop ,zoom_top +zoom_crop )).resize ((target_crop ,target_crop ),Image .BILINEAR ))

    mean =np .array ([0.485 ,0.456 ,0.406 ],dtype =np .float32 )
    std =np .array ([0.229 ,0.224 ,0.225 ],dtype =np .float32 )

    tensors =[]
    for v in views :
        arr =np .array (v ,dtype =np .float32 )/255.0
        arr =(arr -mean )/std
        arr =np .transpose (arr ,(2 ,0 ,1 ))
        tensors .append (np .expand_dims (arr ,axis =0 ))

    return tensors 

@app .get ("/")
def root ():
    """Health status and metadata overview for Flutter BackendRecognitionService."""
    classes =classifier_metadata .get ("class_names",list (SPECIES_CATALOG .keys ()))
    return {
    "status":"online",
    "service":"MediPlant AI Vision Gateway",
    "version":"2.0.0",
    "pipeline":"Two-Stage ONNX Pipeline",
    "stage_1_gate":{
    "name":"Botanical Gatekeeper (Binary Filter)",
    "ready":gate_session is not None ,
    "classes":gate_metadata .get ("class_names",["non_plant","plant"]),
    },
    "stage_2_classifier":{
    "name":"13-Class Medicinal Plant Classifier",
    "ready":classifier_session is not None ,
    "classes_count":len (classes ),
    "supported_classes":classes ,
    },
    }

@app .get ("/health")
def health_check ():
    return {
    "status":"healthy",
    "gate_ready":gate_session is not None ,
    "classifier_ready":classifier_session is not None ,
    }

@app .get ("/classes")
def list_supported_classes ():
    """Return catalog of all 13 supported medicinal plants."""
    classes =classifier_metadata .get ("class_names",list (SPECIES_CATALOG .keys ()))
    catalog =[]
    for slug in classes :
        info =SPECIES_CATALOG .get (slug ,{
        "common_name":slug .replace ("_"," ").title (),
        "botanical_name":"Botanical Species",
        "family":"Flora",
        "key_benefits":"Traditional medicinal usage",
        })
        catalog .append ({"slug":slug ,**info })
    return {"count":len (catalog ),"species":catalog }

@app .post ("/predict")
async def predict (file :UploadFile =File (...)):
    """
    Main inference endpoint:
      1. Gatekeeper Check: Is this a plant leaf/foliage?
      2. If plant, classify species among the 13 supported medicinal plants.
    """
    try :
        contents =await file .read ()
        if not contents or len (contents )<50 :
            raise HTTPException (
            status_code =status .HTTP_400_BAD_REQUEST ,
            detail ="Empty or invalid image data received.",
            )

        tensor =preprocess_image_bytes (contents ,size =224 )

        if gate_session is not None :
            gate_inputs ={gate_session .get_inputs ()[0 ].name :tensor }
            gate_outputs =gate_session .run (None ,gate_inputs )
            gate_probs =softmax (gate_outputs [0 ])[0 ]

            plant_idx =gate_metadata .get ("plant_class_index",1 )
            plant_prob =float (gate_probs [plant_idx ])
            non_plant_prob =float (gate_probs [1 -plant_idx ])

            if plant_prob <0.50 :
                logger .info (
                "Gatekeeper Rejected: Non-Plant (Plant: %.2f%%, Non-Plant: %.2f%%)",
                plant_prob *100 ,
                non_plant_prob *100 ,
                )
                return {
                "is_plant":False ,
                "gate_passed":False ,
                "plant_name":None ,
                "confidence":round (non_plant_prob *100 ,2 ),
                "message":(
                "No botanical structures detected. "
                "Please ensure the camera is focused clearly on plant foliage, leaves, or stems."
                ),
                "predictions":[],
                }

            logger .info ("Gatekeeper Passed: Plant detected (Confidence: %.2f%%)",plant_prob *100 )

        if classifier_session is None :
            return {
            "is_plant":True ,
            "gate_passed":True ,
            "error":"Medicinal plant classifier model is not currently loaded.",
            }

        id_inputs ={classifier_session .get_inputs ()[0 ].name :tensor }
        id_outputs =classifier_session .run (None ,id_inputs )
        initial_logits =id_outputs [0 ][0 ]
        initial_probs =softmax (initial_logits )

        class_slugs =classifier_metadata .get ("class_names",list (SPECIES_CATALOG .keys ()))
        top_idx =int (np .argmax (initial_probs ))
        initial_top_conf =float (initial_probs [top_idx ])

        tta_applied =False 
        tta_agreement =1.0 
        final_probs =initial_probs 
        final_logits =initial_logits 

        if initial_top_conf <0.95 :
            try :
                tta_tensors =generate_tta_tensors (contents ,size =224 )
                tta_probs_list =[]
                tta_logits_list =[]
                tta_top_indices =[]
                input_name =classifier_session .get_inputs ()[0 ].name 

                for t_aug in tta_tensors :
                    out =classifier_session .run (None ,{input_name :t_aug })
                    l_out =out [0 ][0 ]
                    p =softmax (l_out )
                    tta_logits_list .append (l_out )
                    tta_probs_list .append (p )
                    tta_top_indices .append (int (np .argmax (p )))

                final_probs =np .mean (tta_probs_list ,axis =0 )
                final_logits =np .mean (tta_logits_list ,axis =0 )
                tta_applied =True 

                matching_passes =sum (1 for idx in tta_top_indices if idx ==top_idx )
                tta_agreement =matching_passes /float (len (tta_top_indices ))

                logger .info (
                "TTA Executed (5 passes): agreement=%.2f, initial_conf=%.2f%%, refined_conf=%.2f%%",
                tta_agreement ,
                initial_top_conf *100 ,
                float (final_probs [top_idx ])*100 ,
                )
            except Exception as tta_err :
                logger .warning ("TTA pass encountered an error, falling back to initial: %s",tta_err )
                final_probs =initial_probs 
                final_logits =initial_logits 

        probs =final_probs 
        top_idx =int (np .argmax (probs ))
        top_slug =class_slugs [top_idx ]if top_idx <len (class_slugs )else f"plant_{top_idx }"
        top_conf =float (probs [top_idx ])

        ranked_predictions =[]
        sorted_indices =np .argsort (probs )[::-1 ]
        for idx in sorted_indices :
            slug =class_slugs [idx ]if idx <len (class_slugs )else f"plant_{idx }"
            info =SPECIES_CATALOG .get (slug ,{})
            c_name =info .get ("common_name",slug .replace ("_"," ").title ())
            b_name =info .get ("botanical_name","")
            ranked_predictions .append ({
            "class_name":slug ,
            "common_name":c_name ,
            "botanical_name":b_name ,
            "confidence":round (float (probs [idx ])*100 ,2 ),
            })

        is_ood ,ood_reason ,entropy_val ,top3_gap =evaluate_ood_signals (final_logits ,probs )

        if initial_top_conf <0.65 :
            is_ood =True 
            ood_reason =f"low_initial_confidence ({initial_top_conf*100:.1f}% < 65%)"
        elif tta_applied and tta_agreement <0.80 :
            is_ood =True 
            ood_reason =f"tta_low_consensus (agreement={tta_agreement*100:.0f}% < 80%)"
        if is_ood :
            supported_names =", ".join ([v .get ("common_name",k )for k ,v in SPECIES_CATALOG .items ()])
            logger .warning (
            "OOD / Unknown Plant Detected: reason=%s, top1=%.2f%%, entropy=%.3f, top3_gap=%.3f",
            ood_reason ,
            top_conf *100 ,
            entropy_val ,
            top3_gap ,
            )
            return {
            "is_plant":True ,
            "gate_passed":True ,
            "is_known_species":False ,
            "plant_name":None ,
            "confidence":round (top_conf *100 ,2 ),
            "ood_reason":ood_reason ,
            "message":(
            "This is a plant, but it does not match any of the 13 medicinal species "
            f"currently supported by our botanical database (Supported: {supported_names })."
            ),
            "predictions":[],
            }

        species_info =SPECIES_CATALOG .get (top_slug ,{})
        display_name =species_info .get ("common_name",top_slug .replace ("_"," ").title ())

        logger .info (
        "Identified: %s (%s) with %.2f%% confidence (entropy: %.3f)",
        top_slug ,
        display_name ,
        top_conf *100 ,
        entropy_val ,
        )

        return {
        "is_plant":True ,
        "gate_passed":True ,
        "is_known_species":True ,
        "plant_name":top_slug ,
        "common_name":display_name ,
        "botanical_name":species_info .get ("botanical_name",""),
        "family":species_info .get ("family",""),
        "confidence":round (top_conf *100 ,2 ),
        "verification_applied":tta_applied ,
        "message":f"Identified as {display_name } with {round (top_conf *100 ,1 )}% confidence.",
        "predictions":ranked_predictions ,
        }

    except HTTPException :
        raise
    except ValueError as val_err :
        raise HTTPException (
        status_code =status .HTTP_400_BAD_REQUEST ,
        detail =str (val_err ),
        )
    except Exception as exc :
        logger .exception ("Inference error occurred: %s",exc )
        return {
        "is_plant":False ,
        "gate_passed":False ,
        "error":f"An error occurred while processing the image: {str (exc )}",
        }

if __name__ =="__main__":
    print ("="*60 )
    print (" Starting MediPlant Dual-Stage Inference Backend")
    print (" Gatekeeper: plant_gate_model.onnx")
    print (" Classifier: medicinal_plant_model.onnx (13 Classes)")
    print (" URL:        http://0.0.0.0:8000")
    print ("="*60 )
    uvicorn .run (app ,host ="0.0.0.0",port =8000 )
