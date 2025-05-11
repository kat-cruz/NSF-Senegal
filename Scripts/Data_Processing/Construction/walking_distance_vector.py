import pandas as pd
import os
import googlemaps
import numpy as np
import time
from concurrent.futures import ThreadPoolExecutor


# Google Maps API
API_KEY = "AIzaSyCpbyvfcGuwV08UKbLZ1xHG-3ZHo953UOM"
gmaps = googlemaps.Client(key=API_KEY)


# locations file path and read the baseline data file
locations = os.path.join(r"C:\Users\admmi\Box\NSF Senegal", "Data_Management", "Data", 
                        "_CRDES_CleanData", "Baseline", "Identified", "DISES_Baseline_Complete_PII.dta")

def get_walking_distance(params):
    """Calculate walking distance between villages using multiple methods"""
    coords_i, coords_j, village_i, village_j = params
    origin = f"{coords_i[0]},{coords_i[1]}"
    destination = f"{coords_j[0]},{coords_j[1]}"
    
    try:
        time.sleep(0.1)  # Rate limiting
        
        # Method 1: Try direct walking route
        walk_result = gmaps.distance_matrix(
            origins=[origin],
            destinations=[destination],
            mode="walking"
        )
        
        if walk_result['rows'][0]['elements'][0]['status'] == "OK":
            duration = walk_result['rows'][0]['elements'][0]['duration']['value'] / 60
            print(f"Direct walking route: {village_i} to {village_j} - {duration:.0f} minutes")
            return village_i, village_j, duration
            
        # Method 2: Try driving route and convert to walking time
        drive_result = gmaps.distance_matrix(
            origins=[origin],
            destinations=[destination],
            mode="driving"
        )
        
        if drive_result['rows'][0]['elements'][0]['status'] == "OK":
            drive_distance = drive_result['rows'][0]['elements'][0]['distance']['value']  # in meters
            # Assume walking speed of 5km/h = 1.4m/s
            walking_time = (drive_distance / 1.4) / 60  # Convert to minutes
            print(f"Estimated from driving route: {village_i} to {village_j} - {walking_time:.0f} minutes")
            return village_i, village_j, walking_time
            
        # Method 3: Try directions API for more detailed routing options
        directions_result = gmaps.directions(
            origin,
            destination,
            mode="driving",
            alternatives=True
        )
        
        if directions_result:
            # Get the shortest route distance
            shortest_route = min(directions_result, key=lambda x: x['legs'][0]['distance']['value'])
            distance = shortest_route['legs'][0]['distance']['value']  # in meters
            # Convert to walking time using same 5km/h speed
            walking_time = (distance / 1.4) / 60
            print(f"Estimated from directions API: {village_i} to {village_j} - {walking_time:.0f} minutes")
            return village_i, village_j, walking_time
        
        print(f"No route found between {village_i} and {village_j} using any method")
        return village_i, village_j, float('inf')
            
    except Exception as e:
        print(f"Error for {village_i} to {village_j}: {e}")
        return village_i, village_j, float('inf')

# load Stata file into a pandas
df = pd.read_stata(locations)
print(f"Total households loaded: {len(df)}")

# Replace 132A with 153A in all string columns: This was a village coded incorrectly
string_columns = df.select_dtypes(include=['object']).columns
for col in string_columns:
    df[col] = df[col].str.replace('132A', '153A', regex=False)

# Extract treatment arm from hhid_village (3rd character)
df['treatment_arm'] = df['hhid_village'].str[2].astype(int)
print("Treatment arms distribution:")
print(df['treatment_arm'].value_counts().sort_index())

# centroids for each village
village_centroids = df.groupby('hhid_village').agg({
    'gpd_datalatitude': 'mean',
    'gpd_datalongitude': 'mean',
    'treatment_arm': 'first'
}).reset_index()

print(f"\nNumber of villages after centroid calculation: {len(village_centroids)}")

# Google Maps API
API_KEY = "AIzaSyCpbyvfcGuwV08UKbLZ1xHG-3ZHo953UOM"
gmaps = googlemaps.Client(key=API_KEY)

# distance columns
for arm in range(4):
    village_centroids[f'distance_to_arm_{arm}'] = float('inf')

# own treatment arm distances to 0
for index, row in village_centroids.iterrows():
    current_arm = int(row['treatment_arm'])
    village_centroids.at[index, f'distance_to_arm_{current_arm}'] = 0

# village pairs for parallel processing
village_pairs = []
for i, row_i in village_centroids.iterrows():
    village_i = row_i['hhid_village']
    arm_i = int(row_i['treatment_arm'])
    coords_i = (row_i['gpd_datalatitude'], row_i['gpd_datalongitude'])
    
    for arm_j in range(4):
        if arm_j == arm_i:
            continue
            
        villages_in_arm_j = village_centroids[village_centroids['treatment_arm'] == arm_j]
        for _, row_j in villages_in_arm_j.iterrows():
            village_j = row_j['hhid_village']
            coords_j = (row_j['gpd_datalatitude'], row_j['gpd_datalongitude'])
            village_pairs.append((coords_i, coords_j, village_i, village_j))

# distances in parallel
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

# distances in DataFrame
for village_i, village_j, distance in results:
    row_i = village_centroids[village_centroids['hhid_village'] == village_i].iloc[0]
    row_j = village_centroids[village_centroids['hhid_village'] == village_j].iloc[0]
    arm_j = int(row_j['treatment_arm'])
    
    current_distance = village_centroids.loc[village_centroids['hhid_village'] == village_i, f'distance_to_arm_{arm_j}'].iloc[0]
    if distance < current_distance:
        village_centroids.loc[village_centroids['hhid_village'] == village_i, f'distance_to_arm_{arm_j}'] = distance

# four-element distance vector for each village
village_centroids['distance_vector'] = village_centroids.apply(
    lambda row: [
        row[f'distance_to_arm_0'],
        row[f'distance_to_arm_1'], 
        row[f'distance_to_arm_2'], 
        row[f'distance_to_arm_3']
    ], 
    axis=1
)

# distance vectors to strings for CSV storage
village_centroids['distance_vector_str'] = village_centroids['distance_vector'].apply(str)

# Save
output_path = os.path.join(r"C:\Users\admmi\Box\NSF Senegal", "Data_Management", "Data", "Location_Data", "walking_distance_vector.csv")
village_centroids.to_csv(output_path, index=False)
print(f"\nDistance matrix saved to: {output_path}")

# print results 
print("\nSummary of distance vectors:")
for i, row in village_centroids.iterrows():
    print(f"Village {row['hhid_village']} (Arm {int(row['treatment_arm'])}): {row['distance_vector']}")