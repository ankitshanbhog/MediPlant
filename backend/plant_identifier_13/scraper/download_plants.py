"""
High-Yield Botanical Image Scraper for MediPlant 13 Species.
Primary Source: iNaturalist Open Botanical Observations (Thousands of research-grade photos, NO API key required)
Secondary Source: Wikimedia Commons API (Public botanical photography)
Tertiary Source: GBIF Botanical Observations
Fallback: Search Engine Imagery

Images are validated, deduplicated via MD5, and saved into dataset/raw/<plant_slug>/
"""

import os
import sys
import re
import time
import hashlib
import requests
from io import BytesIO
from PIL import Image
from tqdm import tqdm
from concurrent.futures import ThreadPoolExecutor, as_completed

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from config import PLANT_SPECIES, RAW_DIR

USER_AGENT = "MediPlantBot/2.0 (botanical-research; https://github.com/mediplant) Python-Requests/2.31"
HEADERS = {"User-Agent": USER_AGENT}


def get_image_hash(image_bytes: bytes) -> str:
    """Calculates MD5 hash of image to eliminate exact duplicates."""
    return hashlib.md5(image_bytes).hexdigest()


def is_valid_image(image_bytes: bytes, min_size: int = 150) -> Image.Image:
    """Verifies image integrity and ensures it's not a thumbnail or corrupted file."""
    try:
        img = Image.open(BytesIO(image_bytes))
        img.verify()
        img = Image.open(BytesIO(image_bytes))
        if img.width < min_size or img.height < min_size:
            return None
        return img.convert("RGB")
    except Exception:
        return None


def fetch_from_inaturalist(taxa_names: list, max_count: int = 300) -> list:
    """
    Fetches high-resolution field photos from iNaturalist Open Data.
    iNaturalist has over 100,000 verified botanical photos across these 13 species.
    """
    urls = []
    for taxon in taxa_names:
        if len(urls) >= max_count:
            break
        # Query up to 3 pages (100 observations per page)
        for page in range(1, 4):
            if len(urls) >= max_count:
                break
            try:
                endpoint = "https://api.inaturalist.org/v1/observations"
                params = {
                    "taxon_name": taxon,
                    "photos": "true",
                    "per_page": 100,
                    "page": page,
                    "order": "desc",
                    "order_by": "votes"
                }
                res = requests.get(endpoint, params=params, headers=HEADERS, timeout=12)
                if res.status_code == 200:
                    data = res.json()
                    results = data.get("results", [])
                    if not results:
                        break  # No more pages

                    for obs in results:
                        for photo in obs.get("photos", []):
                            u = photo.get("url", "")
                            if u and u.startswith("http"):
                                # Convert square thumbnail to high-resolution medium photo (500-1024px)
                                medium_url = u.replace("square.jpg", "medium.jpg").replace("square.jpeg", "medium.jpeg")
                                urls.append(medium_url)
                                if len(urls) >= max_count:
                                    break
            except Exception as e:
                pass
            time.sleep(0.2)  # Respectful rate limiting
    return urls


def fetch_from_wikimedia(query: str, max_count: int = 40) -> list:
    """Fetches plant images from Wikimedia Commons API."""
    urls = []
    try:
        endpoint = "https://commons.wikimedia.org/w/api.php"
        params = {
            "action": "query",
            "generator": "search",
            "gsrsearch": query,
            "gsrlimit": min(max_count, 40),
            "gsrnamespace": "6",
            "prop": "imageinfo",
            "iiprop": "url",
            "format": "json"
        }
        res = requests.get(endpoint, params=params, headers=HEADERS, timeout=12)
        if res.status_code == 200:
            data = res.json()
            pages = data.get("query", {}).get("pages", {})
            for page in pages.values():
                imageinfo = page.get("imageinfo", [])
                if imageinfo and "url" in imageinfo[0]:
                    url = imageinfo[0]["url"]
                    if url.lower().endswith((".jpg", ".jpeg", ".png")):
                        urls.append(url)
                        if len(urls) >= max_count:
                            break
    except Exception:
        pass
    return urls


def fetch_from_duckduckgo(query: str, max_count: int = 50) -> list:
    """Queries search fallbacks for supplementary imagery."""
    urls = []
    try:
        token_url = "https://duckduckgo.com/"
        res = requests.get(token_url, params={"q": query}, headers=HEADERS, timeout=8)
        vqd_match = re.search(r'vqd=([\d-]+)&', res.text) or re.search(r'vqd="([^"]+)"', res.text)
        if not vqd_match:
            return urls
        vqd = vqd_match.group(1)

        img_url = "https://duckduckgo.com/i.js"
        params = {"l": "us-en", "o": "json", "q": query, "vqd": vqd, "f": ",,,", "p": "1"}
        res = requests.get(img_url, params=params, headers=HEADERS, timeout=10)
        if res.status_code == 200:
            data = res.json()
            for result in data.get("results", []):
                img = result.get("image")
                if img and img.startswith("http"):
                    urls.append(img)
                    if len(urls) >= max_count:
                        break
    except Exception:
        pass
    return urls


def download_single_image(url: str, target_dir: str, slug: str, counter: int, existing_hashes: set):
    """Worker function to download and validate a single candidate image."""
    try:
        resp = requests.get(url, headers=HEADERS, timeout=10)
        if resp.status_code != 200:
            return None

        content = resp.content
        img_hash = get_image_hash(content)
        if img_hash in existing_hashes:
            return None

        valid_img = is_valid_image(content)
        if valid_img is None:
            return None

        filename = f"{slug}_{counter:04d}.jpg"
        save_path = os.path.join(target_dir, filename)
        valid_img.save(save_path, "JPEG", quality=92)
        return img_hash
    except Exception:
        return None


def download_plant_class(species_info: dict, target_per_class: int = 150):
    slug = species_info["slug"]
    botanical = species_info["botanical_name"]
    common = species_info["common_name"]
    taxa_list = species_info.get("inaturalist_taxa", [botanical])
    target_dir = os.path.join(RAW_DIR, slug)
    os.makedirs(target_dir, exist_ok=True)

    print(f"\n==================================================")
    print(f"Collecting: [{common}] ({botanical}) -> {slug}/")
    print(f"==================================================")

    # 1. Check existing images
    existing_hashes = set()
    for f in os.listdir(target_dir):
        fp = os.path.join(target_dir, f)
        if os.path.isfile(fp):
            try:
                with open(fp, "rb") as cur:
                    existing_hashes.add(hashlib.md5(cur.read()).hexdigest())
            except Exception:
                pass

    if len(existing_hashes) >= target_per_class:
        print(f"  Already has {len(existing_hashes)} verified images. Skipping.")
        return

    # 2. Gather candidate URLs
    candidate_urls = []

    # Primary: iNaturalist Open Data
    print(f"  -> Querying iNaturalist API for taxa: {taxa_list}...")
    inat_urls = fetch_from_inaturalist(taxa_list, max_count=target_per_class * 2)
    candidate_urls.extend(inat_urls)
    print(f"     Found {len(inat_urls)} iNaturalist verified photo URLs.")

    # Secondary: Wikimedia Commons
    if len(candidate_urls) < target_per_class * 2:
        print(f"  -> Querying Wikimedia Commons...")
        wm_urls = fetch_from_wikimedia(f"{botanical} leaf", max_count=30)
        candidate_urls.extend(wm_urls)

    # Tertiary: DuckDuckGo fallback
    if len(candidate_urls) < target_per_class:
        print(f"  -> Querying Fallback Search...")
        for q in species_info.get("search_queries", []):
            ddg_urls = fetch_from_duckduckgo(q, max_count=30)
            candidate_urls.extend(ddg_urls)

    # Deduplicate candidate URLs
    unique_urls = list(dict.fromkeys(candidate_urls))
    print(f"  -> Total candidate URLs: {len(unique_urls)}")

    # 3. Fast Parallel Image Download
    saved_count = len(existing_hashes)
    needed = target_per_class - saved_count
    progress = tqdm(total=target_per_class, initial=saved_count, desc=f"Downloading {slug}")

    # Use ThreadPoolExecutor for faster downloads with batching
    batch_size = 15
    with ThreadPoolExecutor(max_workers=6) as executor:
        for batch_start in range(0, len(unique_urls), batch_size):
            if saved_count >= target_per_class:
                break
            batch_urls = unique_urls[batch_start:batch_start + batch_size]
            futures = [
                executor.submit(download_single_image, u, target_dir, slug, saved_count + idx, existing_hashes)
                for idx, u in enumerate(batch_urls)
            ]
            for future in as_completed(futures):
                img_hash = future.result()
                if img_hash is not None and img_hash not in existing_hashes:
                    existing_hashes.add(img_hash)
                    saved_count += 1
                    progress.update(1)
                    if saved_count >= target_per_class:
                        break

    progress.close()
    print(f"  [DONE] Verified images in {slug}/: {saved_count}")


def main():
    import argparse
    parser = argparse.ArgumentParser(description="Download botanical dataset for 13 species")
    parser.add_argument("--count", type=int, default=150, help="Target verified images per species (default: 150)")
    parser.add_argument("--species", type=str, default=None, help="Target specific plant slug (e.g. ashwagandha)")
    args = parser.parse_args()

    print("========================================================")
    print(" MediPlant High-Yield Botanical Dataset Downloader")
    print(f" Target destination:      {RAW_DIR}")
    print(f" Target count per plant:  {args.count}")
    print("========================================================")

    targets = PLANT_SPECIES
    if args.species:
        targets = [p for p in PLANT_SPECIES if p["slug"] == args.species]
        if not targets:
            print(f"[ERROR] Species slug '{args.species}' not found in config.")
            return

    for species in targets:
        download_plant_class(species, target_per_class=args.count)

    print("\n[SUCCESS] Image collection finished.")
    print("Next step: Run `python scraper/organize_dataset.py` to create the train/val split.")


if __name__ == "__main__":
    main()
