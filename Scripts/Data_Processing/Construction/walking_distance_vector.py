import pandas as pd
import os
import googlemaps
import numpy as np
import time
from geopy.distance import geodesic
from concurrent.futures import ThreadPoolExecutor
from itertools import product

# Define the locations file path
locations = os.path.join(r"C:\Users\admmi\Box\NSF Senegal", "Data_Management", "Data", "Location_Data", "hhsurvey_villages.csv")

# Load the CSV file into a pandas DataFrame
df = pd.read_csv(locations)
print(f"Rows after loading: {len(df)}")

# Define villages to drop
villages_to_drop = [
    "115U", "116U", "117U", "119U", "118U", "125U",
    "126U", "124U", "120U", "127U", "128U", "129U"
]

# Drop specified villages
df = df[~df['hhid_village'].isin(villages_to_drop)]
print(f"Rows after dropping specified villages: {len(df)}")

# Drop rows with missing GPS coordinates
df = df.dropna(subset=['gps_collectlatitude', 'gps_collectlongitude'])
print(f"Rows after dropping missing GPS: {len(df)}")

# Initialize Google Maps API client
API_KEY = "AIzaSyCpbyvfcGuwV08UKbLZ1xHG-3ZHo953UOM"
gmaps = googlemaps.Client(key=API_KEY)

def calculate_straight_line_distance(coord1, coord2):
    """Calculate walking time based on straight-line distance with winding factor"""
    try:
        km_distance = geodesic(coord1, coord2).kilometers
        winding_factor = 1.4  # Paths are typically 40% longer than straight line
        walking_time = km_distance * winding_factor * 12  # 12 min/km adjusted walking speed
        return walking_time
    except Exception as e:
        print(f"Error calculating straight-line distance: {e}")
        return float('inf')

def get_walking_distance(params):
    """Calculate distance between two villages with fallback to straight-line"""
    coords_i, coords_j, village_i, village_j = params
    origin = f"{coords_i[0]},{coords_i[1]}"
    destination = f"{coords_j[0]},{coords_j[1]}"
    
    try:
        time.sleep(0.1)  # Rate limiting
        result = gmaps.distance_matrix(
            origins=[origin],
            destinations=[destination],
            mode="walking"
        )
        
        if result['rows'][0]['elements'][0]['status'] == "OK":
            return village_i, village_j, result['rows'][0]['elements'][0]['duration']['value'] / 60
        else:
            return village_i, village_j, calculate_straight_line_distance(coords_i, coords_j)
            
    except Exception as e:
        print(f"Using straight-line distance for {village_i} to {village_j}: {e}")
        return village_i, village_j, calculate_straight_line_distance(coords_i, coords_j)

# Initialize distance columns
for arm in range(4):
    df[f'distance_to_arm_{arm}'] = float('inf')

# Set own treatment arm distances to 0
for index, row in df.iterrows():
    current_arm = int(row['treatment'])
    df.at[index, f'distance_to_arm_{current_arm}'] = 0

# Prepare village pairs for parallel processing
village_pairs = []
for i, row_i in df.iterrows():
    village_i = row_i['hhid_village']
    arm_i = int(row_i['treatment'])
    coords_i = (row_i['gps_collectlatitude'], row_i['gps_collectlongitude'])
    
    for arm_j in range(4):
        if arm_j == arm_i:
            continue
            
        villages_in_arm_j = df[df['treatment'] == arm_j]
        for _, row_j in villages_in_arm_j.iterrows():
            village_j = row_j['hhid_village']
            coords_j = (row_j['gps_collectlatitude'], row_j['gps_collectlongitude'])
            village_pairs.append((coords_i, coords_j, village_i, village_j))

# Calculate distances in parallel
print("\nCalculating distances between villages...")
results = []
with ThreadPoolExecutor(max_workers=4) as executor:
    futures = [executor.submit(get_walking_distance, params) for params in village_pairs]
    total = len(futures)
    
    for i, future in enumerate(futures, 1):
        result = future.result()
        results.append(result)
        if i % 10 == 0 or i == total:
            print(f"Progress: {i}/{total} pairs processed")

# Update distances in DataFrame
for village_i, village_j, distance in results:
    row_i = df[df['hhid_village'] == village_i].iloc[0]
    row_j = df[df['hhid_village'] == village_j].iloc[0]
    arm_j = int(row_j['treatment'])
    
    current_distance = df.loc[df['hhid_village'] == village_i, f'distance_to_arm_{arm_j}'].iloc[0]
    if distance < current_distance:
        df.loc[df['hhid_village'] == village_i, f'distance_to_arm_{arm_j}'] = distance

# Create the four-element distance vector for each village
df['distance_vector'] = df.apply(
    lambda row: [
        row[f'distance_to_arm_0'],
        row[f'distance_to_arm_1'], 
        row[f'distance_to_arm_2'], 
        row[f'distance_to_arm_3']
    ], 
    axis=1
)

# Convert distance vectors to strings for CSV storage
df['distance_vector_str'] = df['distance_vector'].apply(str)

# Save the result
output_path = os.path.join(r"C:\Users\admmi\Box\NSF Senegal", "Data_Management", "Data", "Location_Data", "walking_distance_vector.csv")
df.to_csv(output_path, index=False)
print(f"\nDistance matrix saved to: {output_path}")

# Print summary of results
print("\nSummary of distance vectors:")
for i, row in df.iterrows():
    print(f"Village {row['hhid_village']} (Arm {int(row['treatment'])}): {row['distance_vector']}")