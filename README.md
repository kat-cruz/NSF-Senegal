# NSF Senegal: DISES Project  (WIP - not accurate atm)
## This is where we store and manage our scripts to clean, analyze, and process data. No data is **ever** stored in these folders.

## Software used:  
Stata, R, and Python  

As of yet, there is no replication package associated with this.  

# Maintenance of scripts:  
All scripts must contain a README or comments explaining how to run the script. They should include:  
- What data is being processed.  
- What is being outputted (tables, figures, summaries, etc.).  
- File paths, which should be specified at the beginning of the script.  

# Order of Scripts:  
We organize our scripts in the following parts:  
* `Data_Cleaning/` – Prepares raw data for analysis (e.g., variable transformations, missing value handling).  
* `Data_Checks/` – Includes validation scripts to check data consistency and integrity.  
* `Data_Analysis/` – Contains scripts for statistical analysis, summarization, and result interpretation.  

## What to expect in each folder  

### `Data_Analysis` 📊 
This folder contains scripts for data analysis, summarization, and manipulation with the intention of interpreting the results. Currently, the following subfolders are stored here:  
* `Balance_Tables`
  * `Balance_Tables_Data_Frame.do`
    *  This .do file creates the data frame for the baseline balance tables.
  *  `Asset_Index_Var_Creation.do`
     *  This .do file creates the assest index variable using principal component analysis
  *  `Balance_Tables.Rmd`
      *   This markdown computes and outputs the balance tables and summary statistics for the relevant variables. 
  *  `asset_index_TEST.do` and `balance_table_TEST.Rmd` are test scripts that simulated the process for developing the asset variable and balance tables.
* `Human_Parasitology`
  *  `Parasitological_Predictive_Analysis.Rmd`
     *  This markdown runs the predictive analysis. 
  *  `Parasitological_EDA.Rmd`
     *  This markdown creates scatter plots and summary stats for initial review 
  *  `Parisitology_Summary_Stats.do`
  *  `Human_Parasitological_Dataframe_toupdate.do`
      *  This .Do file creates the Parasitological data frame used to run analysis.
 
### `Data_Processing`
TThis folder contains scripts for data validation, processing, and preperation to ensure the datasets are clean and ready for anlysis. The following subfolders are included:
* `Checks`
  * `Baseline`
    *
  * `Midline`
   * Scripts verify data quality and consistency as survey responses were collected in real-time. These check for missing values, logical inconsistencies, skip patters, and outliers in the incoming survey data.
* `Cleaning/Ecology`
* `Construction`
* `Corrections`
  * Contains scripts that implement corrections based on identified errors in the data. These corrections correspond to issues flagged in the `Checks` scripts and adjustments procotred by the team in Senegal.
