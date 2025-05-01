import pandas as pd
import os
import googlemaps
import numpy as np
import time

# Define the locations file path
locations = os.path.join(r"C:\Users\admmi\Box\NSF Senegal", "Data_Management", "Data", "Location_Data", "hhsurvey_villages.csv")

# Load the CSV file into a pandas DataFrame
df = pd.read_csv(locations)
print(f"Rows after loading: {len(df)}")

# Drop rows with missing GPS coordinates
df = df.dropna(subset=['gps_collectlatitude', 'gps_collectlongitude'])
print(f"Rows after dropping missing GPS: {len(df)}")

# Initialize Google Maps API client
API_KEY = "AIzaSyCpbyvfcGuwV08UKbLZ1xHG-3ZHo953UOM"
gmaps = googlemaps.Client(key=API_KEY)

# Create distance columns for each treatment arm
for arm in range(1, 4):  # Treatment arms 1, 2, 3
    df[f'distance_to_arm_{arm}'] = float('inf')

# Function to calculate walking distance using Google Maps API
def get_walking_distance(origin, destination):
    try:
        # Add minimal delay to avoid hitting API limits
        time.sleep(0.1)
        
        result = gmaps.distance_matrix(
            origins=[origin],
            destinations=[destination],
            mode="walking"
        )
        
        # Check if a valid route was found
        if result['rows'][0]['elements'][0]['status'] != "OK":
            return float('inf')
            
        walking_time = result['rows'][0]['elements'][0]['duration']['value'] / 60  # Convert seconds to minutes
        return walking_time
    except Exception as e:
        # Keep error messages minimal, just report an error occurred for which coordinates
        print(f"Error calculating distance between {origin} and {destination}")
        return float('inf')

# For each village, set its own treatment arm distance to 0
for index, row in df.iterrows():
    current_arm = row['treatment']
    df.at[index, f'distance_to_arm_{current_arm}'] = 0

# Process each village
print("Calculating distances between villages of different treatment arms...")
total_villages = len(df)
processed = 0

for i, row_i in df.iterrows():
    village_i = row_i['hhid_village']
    arm_i = row_i['treatment']
    coords_i = f"{row_i['gps_collectlatitude']},{row_i['gps_collectlongitude']}"
    
    # Skip if this village already has distances for all arms
    if all(row_i[f'distance_to_arm_{arm}'] < float('inf') for arm in range(1, 4)):
        continue
    
    # Print progress update (only for every 5 villages)
    processed += 1
    if processed % 5 == 0 or processed == 1 or processed == total_villages:
        print(f"Processing village {processed}/{total_villages} ({village_i}, Arm {arm_i})...")
    
    # Find the closest village from each other treatment arm
    for arm_j in range(1, 4):
        # Skip own treatment arm (already set to 0)
        if arm_j == arm_i:
            continue
            
        # Skip if we already have a distance for this arm
        if row_i[f'distance_to_arm_{arm_j}'] < float('inf'):
            continue
        
        # Get all villages from the current arm to compare
        villages_in_arm_j = df[df['treatment'] == arm_j]
        
        min_distance = float('inf')
        closest_village = None
        
        # Find the closest village from arm_j
        for j, row_j in villages_in_arm_j.iterrows():
            village_j = row_j['hhid_village']
            coords_j = f"{row_j['gps_collectlatitude']},{row_j['gps_collectlongitude']}"
            
            # Calculate walking time
            walking_time = get_walking_distance(coords_i, coords_j)
            
            if walking_time < min_distance:
                min_distance = walking_time
                closest_village = village_j
        
        # Update the distance to this arm
        df.at[i, f'distance_to_arm_{arm_j}'] = min_distance

# Create the four-element distance vector for each village
df['distance_vector'] = df.apply(
    lambda row: [
        row[f'distance_to_arm_1'], 
        row[f'distance_to_arm_2'], 
        row[f'distance_to_arm_3']
    ], 
    axis=1
)

# Convert distance vectors to strings for CSV storage
df['distance_vector_str'] = df['distance_vector'].apply(str)

# Save the result
output_path = os.path.join(r"C:\Users\admmi\Box\NSF Senegal", "Data_Management", "Data", "Location_Data", "walking_distance_matrix.csv")
df.to_csv(output_path, index=False)
print(f"\nDistance matrix saved to: {output_path}")

# Create a simplified version with just the essential columns
simplified_df = df[['hhid_village', 'treatment', 'distance_to_arm_1', 'distance_to_arm_2', 'distance_to_arm_3', 'distance_vector_str']]
simplified_output_path = os.path.join(r"C:\Users\admmi\Box\NSF Senegal", "Data_Management", "Data", "Location_Data", "walking_distance_simplified.csv")
simplified_df.to_csv(simplified_output_path, index=False)
print(f"Simplified distance matrix saved to: {simplified_output_path}")
