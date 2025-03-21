clear all
set mem 100m
set maxvar 30000
set matsize 11000
set more off

**************************************************
* SET FILE PATHS
**************************************************

* Set base Box path for each user
global data "$master\Data_Management\_CRDES_RawData\Midline\Household_Survey_Data"
global replacement "$master\Data_Management\_CRDES_RawData\Midline\Replacement_Survey_Data"
global baselineids "$master\Data_Management\_CRDES_CleanData\Baseline\Identified"
global issues "$master\Data_Management\Output\Data_Quality_Checks\Midline\_Midline_Original_Issues_Output"
global corrected "$master\Data_Management\Output\Data_Corrections\Midline"
global clean "$master\Data_Management\_CRDES_CleanData\Midline\Identified"

************************ School Data **************************************
*--------------------*
* Load School Data   *
*--------------------

use "$clean\DISES_Complete_Midline_SchoolPrincipal.dta", clear

tempfile school_villages
save `school_villages'
keep hhid_village
*-----------------------------*
* Load Household PII Data     *
*-----------------------------*
use "$clean\DISES_Midline_Complete_PII.dta", clear

duplicates drop hhid_village, force
keep hhid_village
*--------------------*
* Merge & Inspect    *
*--------------------*
merge 1:m hhid_village using `school_villages'
keep hhid_village _merge

* Show result
tab _merge
list hhid_village if _merge == 1
list hhid_village if _merge == 2

drop if missing(hhid_village)

duplicates drop hhid_village, force

use "$clean\DISES_Complete_Midline_Community.dta", clear

duplicates list hhid_village

tempfile community_villages
save `community_villages'
keep hhid_village
*-----------------------------*
* Load Household PII Data     *
*-----------------------------*
use "$clean\DISES_Midline_Complete_PII.dta", clear
duplicates drop hhid_village, force
keep hhid_village
*--------------------*
* Merge & Inspect    *
*--------------------*
merge 1:m hhid_village using `community_villages'
keep hhid_village _merge
* Show result
tab _merge
list hhid_village if _merge == 1
list hhid_village if _merge == 2
drop if missing(hhid_village)
duplicates drop hhid_village, force
