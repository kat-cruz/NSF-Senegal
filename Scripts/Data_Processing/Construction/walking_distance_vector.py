import pandas as pd
import os
import numpy as np
import time
import requests
from concurrent.futures import ProcessPoolExecutor, as_completed
from functools import partial

def process_single_pair(coords_pair):
    """Process a single pair of coordinates"""
    coords_i, coords_j = coords_pair
    return get_walking_distance(coords_i, coords_j)

def process_village_pairs(village_centroids):
    """Process all village pairs with parallel processing"""
    results = []
    pairs_processed = 0
    
    # Use number of CPU cores for parallel processing
    max_workers = os.cpu_count()
    print(f"\nUsing {max_workers} CPU cores for parallel processing")
    
    with ProcessPoolExecutor(max_workers=max_workers) as executor:
        for i, row_i in village_centroids.iterrows():
            village_i = row_i['hhid_village']
            arm_i = int(row_i['treatment_arm'])
            coords_i = (row_i['gpd_datalatitude'], row_i['gpd_datalongitude'])
            
            distances = {j: float('inf') for j in range(4)}
            distances[arm_i] = 0
            
            # Create coordinate pairs for parallel processing
            coord_pairs = []
            for arm_j in range(4):
                if arm_j == arm_i:
                    continue
                    
                villages_in_arm_j = village_centroids[village_centroids['treatment_arm'] == arm_j]
                for _, row_j in villages_in_arm_j.iterrows():
                    coords_j = (row_j['gpd_datalatitude'], row_j['gpd_datalongitude'])
                    coord_pairs.append((coords_i, coords_j))
            
            # Process pairs in parallel
            futures = [executor.submit(process_single_pair, pair) for pair in coord_pairs]
            
            # Collect results
            for arm_j in range(4):
                if arm_j == arm_i:
                    continue
                villages_in_arm_j = len(village_centroids[village_centroids['treatment_arm'] == arm_j])
                arm_distances = []
                for _ in range(villages_in_arm_j):
                    if futures:
                        distance = futures.pop(0).result()
                        arm_distances.append(distance)
                distances[arm_j] = min(arm_distances) if arm_distances else float('inf')
            
            results.append((village_i, distances))
            pairs_processed += len(coord_pairs)
            print(f"\rProcessed {pairs_processed} pairs...", end='', flush=True)
    
    return results

def get_walking_distance(coords_i, coords_j):
    """Get walking time using OSRM's built-in duration calculation"""
    try:
        url = f"http://router.project-osrm.org/route/v1/foot/{coords_i[1]},{coords_i[0]};{coords_j[1]},{coords_j[0]}?overview=false"
        response = requests.get(url)
        if response.status_code == 200:
            result = response.json()
            if result['code'] == 'Ok' and len(result['routes']) > 0:
                # duration comes directly in seconds, convert to minutes
                return result['routes'][0]['duration'] / 60
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
            
        results.append((village_i, distances))
        print(f"\rProcessed {pairs_processed} pairs...", end='', flush=True)
    
    return results

# Load and process data
print("Loading data...")
locations = os.path.join(r"C:\Users\admmi\Box\NSF Senegal", "Data_Management", "Data", 
                        "_CRDES_CleanData", "Baseline", "Identified", "DISES_Baseline_Complete_PII.dta")

df = pd.read_stata(locations)

# Replace "132A" with "153A" in all string columns
print("Replacing village codes...")
for col in df.select_dtypes(include=['object']):
    df[col] = df[col].str.replace("132A", "153A", regex=False)

df['treatment_arm'] = df['hhid_village'].str[2].astype(int)

# Calculate village centroids
village_centroids = df.groupby('hhid_village').agg({
    'gpd_datalatitude': 'mean',
    'gpd_datalongitude': 'mean',
    'treatment_arm': 'first'
}).reset_index()

print(f"Processing {len(village_centroids)} villages...")
results = process_village_pairs(village_centroids)

# Create both distance vector and separate columns
print("\nCreating distance columns...")
# Add separate columns for each arm
for arm in range(4):
    village_centroids[f'walking_minutes_to_arm_{arm}'] = float('inf')

# Add both vector and individual columns
for village_i, distances in results:
    # Add distance vector
    village_centroids.loc[village_centroids['hhid_village'] == village_i, 'distance_vector'] = str(list(distances.values()))
    
    # Add separate columns
    for arm, distance in distances.items():
        village_centroids.loc[village_centroids['hhid_village'] == village_i, 
                            f'walking_minutes_to_arm_{arm}'] = distance

# Save results
output_path = os.path.join(r"C:\Users\admmi\Box\NSF Senegal", "Data_Management", "Data", 
                          "Location_Data", "walking_distance_vector.csv")
village_centroids.to_csv(output_path, index=False)
print(f"Results saved to: {output_path}")
