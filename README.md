# NSF Senegal: DISES Project 
## This is where we store and manage our scripts to clean, analyze, and process data. No data is **ever** stored in these folders.

## 💻 Software used:  
Stata, R, and Python  

As of yet, there is no replication package associated with this.  

# 🧑‍🔧 Maintenance of scripts:  
All scripts must contain a README or comments explaining how to run the script. They should include:  
- What data is being processed.  
- What is being outputted (tables, figures, summaries, etc.).  
- File paths, which should be specified at the beginning of the script.
- Comments on important code chunks that explain what is going on. 

# ✨ Our best practices:

All data output should be generated with reproducibility in mind. When constructing data frames, prioritize harmonization across datasets by following these guidelines:

- **Check for ID consistency**  
  Ensure there are no mismatched IDs across data frames—whether at the individual, household, or village level. If mismatches are found, document them clearly.

- **Use round indicators**  
  Tag data according to the round in which it was collected:
  - **Baseline**: Round 1  
  - **Midline**: Round 2  
  - **Endline**: Round 3  

- **Label created variables**  
  Always label new variables clearly so other users can easily understand their purpose and origin.

- **Document issues**  
  Use the **Issues** tab to log any irregularities, assumptions, or changes made during analysis so the team is in the know-how. 

- **Centralize documentation**  
  Save all protocols, notes, and known data issues in the `Documentation` folder on Box for easy access and long-term reference.  

## What to expect in each folder in the repo 

We are currently working with three main folders:

- 📝 **`Scripts`**  
  Contains all scripts used for data management. This is the most frequently used folder and the primary focus of this ReadMe.

- 📈 **`Tables_Figures`**  
  Stores `.tex` files for tables and figures. These can be linked directly to Overleaf to track changes, although this requires an Overleaf premium account.

- 🗃️ **`docs`**  
  Is available to generate and host website updates via GitHub Pages. This is especially useful for sharing HTML outputs and web-based summaries across teams.

The remainder of this ReadMe focuses on the `Scripts` folder, given its central role in project workflow 🥸

# 🔢 Order of Scripts:  
We organize our scripts in the following parts:  
* `Data_Processing/` – Prepares raw data for analysis (e.g., variable transformations, missing value handling) and includes validation scripts to check data consistency and integrity.   
* `Analysis/` – Contains scripts for statistical analysis, summarization, and result interpretation.  

### 📊 `Analysis`  
This folder contains scripts for data analysis, summarization, and manipulation with the intention of interpreting the results. Currently, the following subfolders are stored here:  
* `Balance_Tables`
  *  Contains scripts used to build the balance table data frame and output the summary stats and the balance table. To recreate the table, run the scripts in the numerical order in which they were labeled (so first run 01_, 02_, and so on). 
* `Human_Parasitology`
  * Contains scripts used to construct the base data frame of child infections and ID matching across the household and community survey data, create the dataframe used for analysis, and the scripts used to run the analysese. 
* `Codebook`
  * Contains scripts to output summary stats for baseline and midline data. No actual outputs are produced from these scripts since we copy and paste the results in a Word document, unfortunately. 
* `Winsorization`
  * Contains scripts that windsorize variables for the codebook. Similar to above, no actual outputs are produced from this script.
* `Specifications`
  * Contains scripts that build data frame for running baseline to midline specifications, run the analysis, and output plots.
* `Auctions`
  *  Contains scripts that build data frame for estimating shadow wages using baseline and mildine data, and estimating the agricutlural total factor productivity production function. 
   
### 🔄 `Data_Processing`

This folder contains scripts for data validation, processing, and preparation to ensure the datasets are clean and ready for analysis. The following subfolders are included:
* 🔍 `Checks` 
  * `Baseline`
  * `Midline`
  * `Treatment`
    *  Scripts verify data quality for baseline and midline  and consistency as survey responses were collected in real-time. These check for missing values, logical inconsistencies, skip patters, and outliers in the incoming survey data.
  * 🔧 `Corrections` 
    * `_Midline_Data_Corrections`
      *  Contains scripts that implement corrections based on identified errors in the data. These corrections correspond to issues flagged in the `Checks` scripts and adjustments procotred by the team in Senegal.
      *  The numbering system represents the order in which to run the scripts. "01_" corresponds to the initial checks. That is, the first pass scripts to run on raw data. "01.5_" are the follow-up checks and corrections. Start using these after the first round of corrections have been sent and implemented.
    * `Ecology`
      * Contains a script to update old village IDs for the Baseline ecological data 
     
* 🏗️ `Construction` 
   * Contains scripts that create new variables, data frames, and merged data for the purpose of analysing, deidentifying, and processing data for analytical use. 
  
* 🪪 `ID_Creation` 
   * Contain scripts that create village IDs, household IDs, and individual IDs.
 
