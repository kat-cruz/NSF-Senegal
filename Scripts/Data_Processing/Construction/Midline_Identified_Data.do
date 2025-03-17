****** Identified Data Construction ***************************

****** NEED TO RERUN THIS ONCE CORRECTIONS FOR HH_49 CONSENT ARE DONE ******
****** NEED TO RERUN THIS ONCE CLARIFIED ON MERGED HOUSEHOLDS **************

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

**************************** Import baseline data ****************************

use "$baselineids\DISES_Baseline_Complete_PII.dta", clear

keep hhid hhid_village  // Keep only HHID and Village ID
duplicates drop hhid, force  // Keep one entry per household
gen baseline = 1  // Mark as a baseline household

save "$baselineids\DISES_Baseline_HHID_List.dta", replace

**************************** Import midline data & Mark Attrition ****************************

use "$corrected\CORRECTED_DISES_Enquête_ménage_midline_VF_WIDE_14Mar2025.dta", clear  
// keep hh_global_id hhid_village consent  // Keep relevant variables
rename hh_global_id hhid
gen attritted = 0  // Default is not attritted
duplicates drop hhid, force  // Keep one entry per household
drop if missing(hhid)
replace attritted = 1 if (consent == 0 | consent == 2)  // Mark attritted if no consent
tostring hh_head_name_complet, force replace

save "$clean\DISES_Midline_Retained.dta", replace

**************************** Merge midline with baseline to find attrition ****************************

use "$baselineids\DISES_Baseline_HHID_List.dta", clear

gen attritted = 1  // Assume all baseline households are attritted initially


merge 1:1 hhid using "$clean\DISES_Midline_Retained.dta"

replace attritted = 0 if _merge == 3  // If HH appears in both baseline & midline → Not attritted
replace attritted = 1 if _merge == 1  // If HH in baseline but missing in midline → Attritted

save "$clean\DISES_Midline_Attrition.dta", replace

**************************** HHID's for Replacements ****************************
import delimited "$corrected\CORRECTED_DISES_enquete_ménage_FINALE_MIDLINE_REPLACEMENT_WIDE_12Mar2025.csv", clear varnames(1) bindquote(strict)     

// keep hhid_village hhid  // Keep relevant replacement variables
gen replaced = 1  // Mark as a replacement household

tostring no_consent, force replace

* Sort by village to ensure sequential numbering
bysort hhid_village (hhid): gen rep_number = _n  // Assigns 1, 2, 3,... per village

* Create the new replacement `hhid` based on original `hhid`
gen hhid_replacement = hhid + string(rep_number + 29, "%02.0f")  // Adds 30, 31, 32,...
rename hhid_replacement hhid
drop rep_number
save "$clean\DISES_Midline_Replacements.dta", replace

**************************** HHID's for Merged Households ****************************
use "$corrected\CORRECTED_DISES_Enquête_ménage_midline_VF_WIDE_14Mar2025.dta", clear  
// keep hh_global_id hhid_village consent  // Keep relevant variables
rename hh_global_id hhid  
drop if consent == 0
drop if consent == 2

gen hhid_merged = hhid  // Create a new variable to store updated HHIDs



replace hhid_merged = hhid_village + "70" if inlist(hhid, "133A19", "133A03")
replace hhid_merged = hhid_village + "71" if inlist(hhid, "133A20", "133A02")
replace hhid_merged = hhid_village + "72" if inlist(hhid, "133A05", "133A11")

* Keep only the merged households
keep if inlist(hhid, "133A19", "133A03", "133A20", "133A02", "133A05", "133A11")

drop hhid  
rename hhid_merged hhid  

save "$clean\DISES_Midline_Merged.dta", replace


/*
Merges
HHID 133A19 avec 133A03
133A19 kept in Midline
HHID 133A20 avec 133A02
133A20 kept in Midline
HHID 133A05 avec 133A11
133A11 kept in midline
HHID 133A15 avec 133A01
Indicated that they merged but they are both included seperately in the data

*/
**************************** Combine Retained and Replacement HHs ****************************

use "$clean\DISES_Midline_Retained.dta", clear
append using "$clean\DISES_Midline_Replacements.dta", force  
append using "$clean\DISES_Midline_Merged.dta", force  
save "$clean\DISES_Midline_Complete_PII.dta", replace


save "$clean\DISES_Midline_Complete_PII.dta", replace



