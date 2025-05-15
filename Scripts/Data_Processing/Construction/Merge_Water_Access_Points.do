 **************************************************
* DISES Number of Water Access Points *
* File Created By: Alexander Mills *
* File Last Updated By: Alexander Mills *
* Updates Tracked on Git *
**************************************************

*** This Do File PROCESSES: "DISES Village Selection\ETUDE DISES - ENQUETES DE PRESELECTION DES SITES_WIDE_MJD.xlsx" ***
*** This Do File ADDS TO: "Complete_Baseline_Community.dta", "$baseline\Complete_Midline_Community.dta""
						
*** Procedure: ***
* 
capture log close
clear all
set mem 100m
set maxvar 30000
set matsize 11000
set more off

**************************************************
* SET FILE PATHS
**************************************************
disp "`c(username)'"

* Set global path based on the username
if "`c(username)'" == "admmi" global master "C:\Users\admmi\Box\NSF Senegal"
if "`c(username)'" == "km978" global master "C:\Users\km978\Box\NSF Senegal"
if "`c(username)'" == "socrm" global master "C:\Users\socrm\Box\NSF Senegal"

global baseline "$master\Data_Management\Data\_CRDES_CleanData\Baseline\Deidentified"
global midline "$master\Data_Management\Data\_CRDES_CleanData\Midline\Deidentified"

global num_water_access_points "$master\DISES Village Selection\ETUDE DISES - ENQUETES DE PRESELECTION DES SITES_WIDE_MJD.xlsx"
global baseline_community "$baseline\Complete_Baseline_Community.dta"
global midline_community "$midline\Complete_Midline_Community.dta"
  
* import water access points data
import excel "$num_water_access_points", firstrow clear
keep hhid_village q4
drop if missing(hhid_village)
collapse (max) q4, by(hhid_village)

* save as a temp file
tempfile waterpoints
save `waterpoints'

* create corrections file
clear
input str5 hhid_village int q4
"041A" 7
"143A" 1
"052B" 1
"133A" 1
end
    
tempfile corrections
save `corrections'

* append the corrections to the water access points data
use `waterpoints', clear
append using `corrections'

* save the final water access points dataset
tempfile final_waterpoints
save `final_waterpoints'

* merge with baseline community data
use "$baseline_community", clear
merge m:1 hhid_village using `final_waterpoints', nogen
save "$baseline_community", replace

* merge with midline community data
use "$midline_community", clear  
merge m:1 hhid_village using `final_waterpoints', nogen
save "$midline_community", replace
