****************** Midline Deidentified Dataset Construction *******************

clear all
set mem 100m
set maxvar 30000
set matsize 11000
set more off

**************************************************
* SET FILE PATHS
**************************************************

* Set base Box path for each user
if "`c(username)'"=="socrm" global master "C:\Users\socrm\Box\NSF Senegal"
if "`c(username)'"=="kls329" global master "C:\Users\kls329\Box\NSF Senegal"
if "`c(username)'"=="km978" global master "C:\Users\km978\Box\NSF Senegal"
if "`c(username)'"=="Kateri" global master "C:\Users\Kateri\Box\NSF Senegal"
if "`c(username)'"=="admmi" global master "C:\Users\admmi\Box\NSF Senegal"

**************************** Data file paths ****************************

global data "$master\Data_Management\_CRDES_RawData\Midline\Household_Survey_Data"
global replacement "$master\Data_Management\_CRDES_RawData\Midline\Replacement_Survey_Data"
global baselineids "$master\Data_Management\_CRDES_CleanData\Baseline\Identified"
global issues "$master\Data_Management\Output\Data_Quality_Checks\Midline\_Midline_Original_Issues_Output"
global corrected "$master\Data_Management\Output\Data_Corrections\Midline"
global clean "$master\Data_Management\_CRDES_CleanData\Midline\Identified"
global data_deidentified "$master\Data_Management\_CRDES_CleanData\Midline\Deidentified"

***************** Community data **************************************
import excel "$corrected\CORRECTED_Community_Survey_13May2025.xlsx", firstrow clear

*** drop identifying data *** 
drop full_name phone_resp pull_hh_full_name_calc__* pull_hh_head_name_complet_* pull_hh_name_complet_resp_* pull_hh_phone_* new_household_*

drop deviceid devicephonenum username device_info caseid record_text gps* description_village instanceid formdef_version key village 

save "$data_deidentified\Complete_Midline_Community", replace

