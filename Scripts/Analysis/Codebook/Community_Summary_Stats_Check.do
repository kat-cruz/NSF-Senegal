*==============================================================================
* Project : Education Module	
* Program:	education_summary_stats	
* ==============================================================================

capture log close
clear all
set mem 100m
set maxvar 30000
set matsize 11000
set more off
version 14.1

**************************************************
* SET FILE PATHS
**************************************************

clear all 

set maxvar 20000

if "`c(username)'"=="socrm" {
                global master "C:\Users\socrm\Box\NSF Senegal"
}
else if "`c(username)'"=="km978" {
                global master "C:\Users\km978\Box\NSF Senegal"
				
}
else if "`c(username)'"=="admmi" {
                global master "C:\Users\admmi\OneDrive\Desktop\GRA\Data\Data\Complete_Baseline_Community.dta"
				
}

global data_deidentified "$master\Data Management\_CRDES_CleanData\Baseline\Deidentified"
global data_identified "$master\Data Management\_CRDES_CleanData\Baseline\Identified"

// Install required packages 
ssc install asdoc

**************************************************
* COMMUNITY
**************************************************
* Load the data file using the global `data` macro
use "$data_deidentified\Complete_Baseline_Community.dta", clear

// Updated command to include all variables for summary statistics
asdoc summarize q_16 q_17 q_18 q_19 q_20 q_21 q_22 q_23 q_24 q_25 q_26 q_27 q_28 q_28a q_29 q_29a q_30 q_30a q_31 q_31a q_32 q_32a q_33 q_33a q_34 q_35_check q_52 q_53 q_54 q_55 q_57 q_58 q60 q61 q63_1 q63_2 q63_3 q63_4 q63_5 q63_6 q63_7 q63_8 q63_9 q63_10 q64 q65 q66, replace save(unconstrained_community_summary_stats.doc)
 // Generate summary statistics for all variables with no constraints

// Define the list of variables to be tabulated
local varlist q_18 q_28a q_31a q_32 q_32a q_33a q_52 q_53 q_54 q_55 q_57 q_58 q60 q61 q63_1 q63_2 q63_3 q63_4 q63_5 q63_6 q63_7 q63_8 q63_9 q63_10 q64 q65 q66

// Loop over each variable in the list and tabulate it
foreach var of varlist `varlist' {
    tabulate `var'
}

// Replace negative values representing "I don't know" or "other"
foreach var of varlist q_18 q_28a q_31a q_32 q_32a q_33a q_52 q_53 q_54 q_55 q_57 q_58 q60 q61 q63_1 q63_2 q63_3 q63_4 q63_5 q63_6 q63_7 q63_8 q63_9 q63_10 q64 q65 q66{ 
    replace `var' = . if `var' < 0 
}

// Apply constraints only for q_18 and q_32 (semi-categorical: values should be either 0 or 1: drop 2 representing "I don't know" or "other"
foreach var of varlist q_18 q_32 {
    replace `var' = . if `var' != 0 & `var' != 1
}

asdoc summarize q_16 q_17 q_18 q_19 q_20 q_21 q_22 q_23 q_24 q_25 q_26 q_27 q_28 q_28a q_29 q_29a q_30 q_30a q_31 q_31a q_32 q_32a q_33 q_33a q_34 q_35_check q_52 q_53 q_54 q_55 q_57 q_58 q60 q61 q63_1 q63_2 q63_3 q63_4 q63_5 q63_6 q63_7 q63_8 q63_9 q63_10 q64 q65 q66, replace save(constrained_community_summary_stats.doc) // Generate summary statistics for all variables with no constraints

tabulate q62