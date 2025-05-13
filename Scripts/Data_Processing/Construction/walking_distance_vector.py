import pandas as pd
import os
import numpy as np
import time
import requests
from concurrent.futures import ThreadPoolExecutor

def get_walking_distance(coords_i, coords_j):
    """Get walking distance using OSRM public API"""
    try:
        # OSRM uses longitude,latitude order
        url = f"http://router.project-osrm.org/route/v1/foot/{coords_i[1]},{coords_i[0]};{coords_j[1]},{coords_j[0]}?overview=false"
        response = requests.get(url)
        if response.status_code == 200:
            result = response.json()
            if result['code'] == 'Ok' and len(result['routes']) > 0:
                # Convert meters to walking minutes (assuming 5km/h walking speed)
                return (result['routes'][0]['distance'] / 1000) * 12
        return float('inf')
    except Exception:
        return float('inf')

def process_village_pairs(village_centroids):
    """Process all village pairs with progress tracking"""
    results = []
    pairs_processed = 0
    total_pairs = 0
    
    for i, row_i in village_centroids.iterrows():
        village_i = row_i['hhid_village']
        arm_i = int(row_i['treatment_arm'])
        coords_i = (row_i['gpd_datalatitude'], row_i['gpd_datalongitude'])
        
        # Initialize distances for this village
        distances = {j: float('inf') for j in range(4)}
        distances[arm_i] = 0  # Own treatment arm distance is 0
        
        # Find nearest village in each other treatment arm
        for arm_j in range(4):
            if arm_j == arm_i:
                continue
                
            villages_in_arm_j = village_centroids[village_centroids['treatment_arm'] == arm_j]
            min_distance = float('inf')
            
            for _, row_j in villages_in_arm_j.iterrows():
                coords_j = (row_j['gpd_datalatitude'], row_j['gpd_datalongitude'])
                distance = get_walking_distance(coords_i, coords_j)
                min_distance = min(min_distance, distance)
                pairs_processed += 1
                
            distances[arm_j] = min_distance
            
        results.append((village_i, list(distances.values())))
        print(f"\rProcessed {pairs_processed} pairs...", end='', flush=True)
    
    return results

# Load and process data
print("Loading data...")
locations = os.path.join(r"C:\Users\admmi\Box\NSF Senegal", "Data_Management", "Data", 
                        "_CRDES_CleanData", "Baseline", "Identified", "DISES_Baseline_Complete_PII.dta")

df = pd.read_stata(locations)
df['treatment_arm'] = df['hhid_village'].str[2].astype(int)

# Calculate village centroids
village_centroids = df.groupby('hhid_village').agg({
    'gpd_datalatitude': 'mean',
    'gpd_datalongitude': 'mean',
    'treatment_arm': 'first'
}).reset_index()

print(f"Processing {len(village_centroids)} villages...")
results = process_village_pairs(village_centroids)

# Create final dataframe
print("\nCreating distance vectors...")
for village_i, distances in results:
    village_centroids.loc[village_centroids['hhid_village'] == village_i, 'distance_vector'] = str(distances)

# Save results
output_path = os.path.join(r"C:\Users\admmi\Box\NSF Senegal", "Data_Management", "Data", 
                          "Location_Data", "walking_distance_vector.csv")
village_centroids.to_csv(output_path, index=False)
print(f"Results saved to: {output_path}")