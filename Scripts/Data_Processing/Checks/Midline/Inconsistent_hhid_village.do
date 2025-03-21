clear all
set mem 100m
set maxvar 30000
set matsize 11000
set more off

**************************************************
* SET FILE PATHS
**************************************************

**** Master file path  ****
if "`c(username)'"=="socrm" global master "C:\Users\socrm\Box\NSF Senegal"
if "`c(username)'"=="kls329" global master "C:\Users\kls329\Box"
if "`c(username)'"=="km978" global master "C:\Users\km978\Box\NSF Senegal"
if "`c(username)'"=="Kateri" global master "C:\Users\Kateri\Box\NSF Senegal"
if "`c(username)'"=="admmi" global master "C:\Users\admmi\Box\NSF Senegal"

* Set base Box path for each user
global data "$master\Data_Management\_CRDES_RawData\Midline\Household_Survey_Data"
global replacement "$master\Data_Management\_CRDES_RawData\Midline\Replacement_Survey_Data"
global baselineids "$master\Data_Management\_CRDES_CleanData\Baseline\Identified"
global issues "$master\Data_Management\Output\Data_Quality_Checks\Midline\_Midline_Original_Issues_Output"
global corrected "$master\Data_Management\Output\Data_Corrections\Midline"
global clean "$master\Data_Management\_CRDES_CleanData\Midline\Identified"
global hhids "$master\Data_Management\Output\Household_IDs"

************************ School Data **************************************
*--------------------*
* Load School Data   *
*--------------------

use "$clean\DISES_Complete_Midline_SchoolPrincipal.dta", clear

tempfile school_villages
save `school_villages'
keep hhid_village

*-----------------------------*
* Load Baseline Household IDs *
*-----------------------------*
use "$hhids\Complete_HouseholdIDs", clear

replace hhid_village = villageid if hhid_village == "" & villageid != ""

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
* Load Baseline Household IDs *
*-----------------------------*
use "$hhids\Complete_HouseholdIDs", clear

replace hhid_village = villageid if hhid_village == "" & villageid != ""

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
