from fastapi.testclient import TestClient
from app import app

client = TestClient(app)

def test_everything():
    print("=== Testing Desktop/Backend Integration ===")
    
    # 1. Health & Root check
    root_res = client.get("/")
    print("[1] Root status:", root_res.status_code)
    assert root_res.status_code == 200

    # 2. Login as Farmer
    farmer_res = client.post("/auth/login", json={"email": "farmer@mediplant.org", "password": "Farmer@123"})
    assert farmer_res.status_code == 200, f"Farmer login failed: {farmer_res.text}"
    token = farmer_res.json()["access_token"]
    headers = {"Authorization": f"Bearer {token}"}
    print("[2] Farmer login OK! Roles:", farmer_res.json()["user"]["roles"])

    # 3. Login as Admin
    admin_res = client.post("/auth/login", json={"email": "admin@mediplant.org", "password": "Admin@123"})
    assert admin_res.status_code == 200, f"Admin login failed: {admin_res.text}"
    print("[3] Admin login OK! Roles:", admin_res.json()["user"]["roles"])

    # 4. Login as General User
    user_res = client.post("/auth/login", json={"email": "user@mediplant.org", "password": "User@123"})
    assert user_res.status_code == 200, f"User login failed: {user_res.text}"
    print("[4] User login OK! Roles:", user_res.json()["user"]["roles"])

    # 5. Farmer Overview
    ov_res = client.get("/farmer/overview", headers=headers)
    assert ov_res.status_code == 200, f"Farmer overview failed: {ov_res.text}"
    print("[5] Farmer Overview stats:", ov_res.json()["stats"])

    # 6. Farmer Crops
    crops_res = client.get("/farmer/crops", headers=headers)
    assert crops_res.status_code == 200
    print("[6] Farmer Crops count:", crops_res.json()["count"])

    # 7. Cultivation Guides
    guides_res = client.get("/farmer/cultivation-guides")
    assert guides_res.status_code == 200
    print("[7] Cultivation Guides count:", guides_res.json()["total_guides"])

    # 8. Market Info
    mkt_res = client.get("/farmer/market-info")
    assert mkt_res.status_code == 200
    print("[8] Market Benchmarks count:", len(mkt_res.json()["benchmarks"]))

    print("\nALL DESKTOP/BACKEND TESTS PASSED SUCCESSFULLY!")

if __name__ == "__main__":
    test_everything()
