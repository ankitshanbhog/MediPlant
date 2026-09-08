# MediPlant Backend Cloud Deployment Guide

Deploying this backend to the cloud ensures you **never have to run it from your computer or connect via USB / Wi-Fi**. The mobile app will connect to your public cloud URL over any cellular or Wi-Fi network.

---

## Option 1: Hugging Face Spaces (RECOMMENDED — 100% Free Forever)
- **Why**: Gives **16 GB RAM + 2 vCPU completely free**, runs TensorFlow effortlessly, gives a permanent public HTTPS URL (e.g., `https://yourname-mediplant-backend.hf.space`), and has zero sleep limit.

### Steps:
1. Create a free account at [huggingface.co](https://huggingface.co).
2. Click **New Space** (or go to `huggingface.co/new-space`).
3. Fill in:
   - **Space Name**: `mediplant-backend`
   - **Space SDK**: Select **Docker** -> **Blank**.
   - **Visibility**: Public.
4. Clone your new space repository or upload the files from `MediPlant_backend`:
   - `Dockerfile`
   - `requirements.txt`
   - `app.py`
   - `class_names.json`
   - `medicinal_plant_best.keras`
   - `plant_gate_best.keras`
5. Click **Commit**. Hugging Face will automatically build and start your container in ~2 minutes!
6. Copy your public space URL (e.g., `https://YOUR_USERNAME-mediplant-backend.hf.space`).
7. Open the **MediPlant app** on your phone -> Tap the **Server Settings** icon in the top header -> Paste your URL and tap **Save**. Done!

---

## Option 2: Render.com (Free Tier)
1. Sign up at [render.com](https://render.com).
2. Click **New +** -> **Web Service**.
3. Connect your GitHub repository containing the `MediPlant_backend` folder.
4. Settings:
   - **Root Directory**: `MediPlant_backend`
   - **Runtime**: `Docker`
   - **Instance Type**: Free
5. Click **Create Web Service**.
6. Once deployed, copy your `https://xxx.onrender.com` URL and paste it into the app's Server Settings.

---

## Testing Your Deployed Server
Visit your public URL in any browser:
```
https://your-deployed-url/
```
You should see:
```json
{
  "status": "online",
  "message": "MediPlant Backend is active",
  "gate_ready": true,
  "classifier_ready": true,
  "classes_count": 11
}
```
