* MIDLINE NEW MEMBER INDIVIDUAL ID CONSTRUCTION
* Authors: Alex Mills
* Created: January 2024
* Last modified: May 2025
*
* Purpose: This script constructs unique individual IDs for new household members 
* added during the midline survey. It:
*   1. Processes midline household roster data
*   2. Merges with baseline individual IDs
*   3. Generates new sequential IDs for added members
*   4. Links respondent IDs across household members
*   5. Creates separate files for complete roster and midline-only cases
*
* Input files:
*   - DISES_Midline_Complete_PII.dta
*   - All_Villages_With_Individual_IDs.dta (baseline)
*
* Output files:
*   - All_Individual_IDs_Complete.dta (baseline + midline)
*   - Midline_Individual_IDs.dta (midline only)
*
* Notes:
*   - Handles special case of village code 132A -> 153A conversion
*   - Maintains consistent ID structure across waves
*   - Preserves baseline IDs while adding new members

clear all
set mem 100m
set maxvar 30000
set matsize 11000
set more off

**************************************************
* SET FILE PATHS
**************************************************

* Set base Box path for each user
if "`c(username)'"=="mollydoruska" global master "/Users/mollydoruska/Library/CloudStorage/Box-Box/NSF Senegal"
if "`c(username)'"=="kls329" global master "C:\Users\kls329\Box\NSF Senegal"
if "`c(username)'"=="km978" global master "C:\Users\km978\Box\NSF Senegal"
if "`c(username)'"=="Kateri" global master "C:\Users\Kateri\Box\NSF Senegal"
if "`c(username)'"=="admmi" global master "C:\Users\admmi\Box\NSF Senegal"

**************************** Data file paths ****************************

global data "$master/Data_Management/Data/_CRDES_RawData/Midline/Household_Survey_Data"
global replacement "$master/Data_Management/Data/_CRDES_RawData/Midline/Replacement_Survey_Data"
global baselineids "$master/Data_Management/Data/_CRDES_CleanData/Baseline/Identified"
global issues "$master/Data_Management/Output/Data_Quality_Checks/Midline/_Midline_Original_Issues_Output"
global corrected "$master/Data_Management/Output/Data_Processing/Checks/Corrections/Midline"
global clean "$master/Data_Management/Data/_CRDES_CleanData/Midline/Identified"

*** add missing IDs to main ID set *** 
use "$clean/DISES_Midline_Complete_PII.dta", clear

tostring hh_relation_with_o*, replace 
tostring hh_full_name_calc*, replace
tostring pull_hh_individ_*, replace

keep hhid hhid_village add_new_* pull_hh_individ_* hh_head_name_complet hh_name_complet_resp hh_name_complet_resp_new hh_age_resp hh_gender_resp hh_full_name_calc_* hh_gender_* hh_age_* hh_phone hh_relation_with_* hh_relation_with_o_*

*** create variable individual which is the index of which person in the household the observation is (the j variable in Stata) ***
reshape long pull_hh_individ_ pull_hh_full_name_calc__ pull_hh_age__ add_new_ hh_full_name_calc_ hh_gender_ hh_age_ hh_relation_with_ hh_relation_with_o_, i(hhid_village hhid hh_head_name_complet hh_name_complet_resp hh_name_complet_resp_new hh_age_resp hh_gender_resp hh_phone) j(individual)

*** drop if there is no individual ***
drop if (hh_full_name_calc_ == "" | hh_full_name_calc_ == ".") & hh_gender_ == . & hh_age_ == . 

rename pull_hh_individ_ individ

*** merge w/ the baseline id's
merge m:1 hhid individ using "$baselineids/All_Villages_With_Individual_IDs.dta"

* sort data by household ID and individual index
sort hhid indiv_index

* create a temporary variable to identify maximum index per household
by hhid: egen max_index = max(real(indiv_index))

* replace missing values with appropriate new values
* first create a counter for new individuals within each household
gen new_member_count = 0 if indiv_index != ""
by hhid: replace new_member_count = sum(_merge == 1) if _merge == 1

* generate new index values
gen new_index = ""
replace new_index = string(max_index + new_member_count) if indiv_index == "" & _merge == 1
replace new_index = "0" + new_index if length(new_index) == 1 & new_index != ""

* update the indiv_index
replace indiv_index = new_index if indiv_index == "" & _merge == 1

* generate the full individual ID by concatenating household ID and individual index
replace individ = hhid + indiv_index if individ == ""

* clean 
drop max_index new_member_count new_index

sort hhid indiv_index

* gen new variable to extract the individual id for the new member respondent
gen hh_name_complet_resp_new_individ = ""

replace hh_name_complet_resp_new_individ = individ if hh_name_complet_resp_new == hh_full_name_calc_ 

* create a temp file with the household-respondent matches
preserve
    keep if hh_full_name_calc_ == hh_name_complet_resp_new
    keep hhid individ
    rename individ hh_name_complet_resp_new_individ
    duplicates drop
    tempfile resp_ids
    save `resp_ids'
restore

* merge this information back to all household members
merge m:1 hhid using `resp_ids', update generate(_merge2)
drop _merge2

foreach var of varlist * {
    capture confirm string variable `var'
    if !_rc {
        replace `var' = subinstr(`var', "132A", "153A", .)
    }
}

* save complete dataset with all individual IDs (baseline and midline)
save "$clean/All_Individual_IDs_Complete.dta", replace

* save the midline-only dataset
drop if _merge == 2
save "$clean/Midline_Individual_IDs.dta", replace
