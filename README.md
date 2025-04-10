# NSF Senegal: DISES Project (updates are in progress)
## This is where we store and manage our scripts to clean, analyze, and process data. No data is **ever** stored in these folders.

## 💻 Software used:  
Stata, R, and Python  

As of yet, there is no replication package associated with this.  

# 🧑‍🔧 Maintenance of scripts:  
All scripts must contain a README or comments explaining how to run the script. They should include:  
- What data is being processed.  
- What is being outputted (tables, figures, summaries, etc.).  
- File paths, which should be specified at the beginning of the script.  

# 🔢 Order of Scripts:  
We organize our scripts in the following parts:  
* `Data_Processing/` – Prepares raw data for analysis (e.g., variable transformations, missing value handling) and includes validation scripts to check data consistency and integrity.   
* `Analysis/` – Contains scripts for statistical analysis, summarization, and result interpretation.  

## What to expect in each folder  

### 📊 `Analysis`  
This folder contains scripts for data analysis, summarization, and manipulation with the intention of interpreting the results. Currently, the following subfolders are stored here:  
* `Balance_Tables`
  *  Contains scripts used to build the balance table data frame and output the summary stats and the balance table. 
* `Human_Parasitology`
  * Contains scritps used to construct the base data frame of child infections and ID matching across the housheold and community survey data, create the dataframe used for analysis, and the scripts used to run the analysese. 
* `Codebook`
  * Contains scripts to output summary stats for baseline and midline data. No actual outputs are produced from these scripts since we copy and paste the results in a Word document, unfortunetly. 
* `Winsorization`
  * Contains scripts that windsorize variables for the codebook. Similar to above, no actual outputs are produced from this script. 
   
### 🔄 `Data_Processing`

This folder contains scripts for data validation, processing, and preperation to ensure the datasets are clean and ready for analysis. The following subfolders are included:
* 🔍 `Checks` 
  * `Baseline`
  * `Midline`
  * `Treatment`
    *  Scripts verify data quality for baseline and midline  and consistency as survey responses were collected in real-time. These check for missing values, logical inconsistencies, skip patters, and outliers in the incoming survey data.
  * 🔧 `Corrections` 
    * `_Midline_Data_Corrections`
      *  Contains scripts that implement corrections based on identified errors in the data. These corrections correspond to issues flagged in the `Checks` scripts and adjustments procotred by the team in Senegal.
    * `Ecology`
      * Contains a script to update old village IDs for the Baseline ecological data 
     
* 🏗️ `Construction` 
   * Contains scripts that create new variables, data frames, and merged data for the purpose of analysing, deidentifying, and processing data for analytical use. 
  
* 🪪 `ID_Creation` 
   * Contain scripts that create vilage IDs, household IDs, and individual IDs.
 
