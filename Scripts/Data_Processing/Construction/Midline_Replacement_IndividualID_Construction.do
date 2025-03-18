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

*** upload replacement survey data
use "$clean\DISES_Complete_Midline_Replacements.dta"
*** Reshape data to long format ***

* Drop completely empty variables
foreach var in `r(varlist)' {
    capture assert missing(`var')
    if _rc == 0 {
        drop `var'
    }
}

reshape long hh_full_name_calc_ hh_gender_ hh_age_, ///
    i(hhid_village sup enqu hh_head_name_complet hh_name_complet_resp hh_age_resp hh_gender_resp hh_phone) ///
    j(individual)

*** Drop empty individual records ***
drop if missing(hh_full_name_calc_) & missing(hh_gender_) & missing(hh_age_)

*** Ensure `individual` is a two-digit string ***
gen indiv_index = string(individual, "%02.0f")

*** Construct `individ` ID ***
gen individ = hhid + indiv_index

keep hhid individual individ hh_full_name_calc_ hh_gender_ hh_age_

*** Save the dataset with individual-level information ***
save "$clean\DISES_Complete_Midline_Replacement_Individual_IDs.dta", replace

*** Reshape back to wide format with new naming convention ***
reshape wide individ hh_full_name_calc_ hh_gender_ hh_age_, i(hhid) j(individual)

*** Rename variables to `pull_hh_individ_1`, `pull_hh_individ_2`, etc. ***
rename individ* pull_hh_individ_*
rename hh_full_name_calc_* hh_full_name_calc_*
rename hh_gender_* hh_gender_*
rename hh_age_* hh_age_*

merge 1:1 hhid using "$clean\DISES_Complete_Midline_Replacements"

drop _merge

save "$clean\DISES_Complete_Midline_Replacements.dta", replace

