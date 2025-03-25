/**********************************************************
README: Midline Wealth Stratum Classification Export
----------------------------------------------------------
PURPOSE:
- Export household data for wealth stratum classification
- Focused on villages 130A and 012B
- Prepared for community survey data correction

KEY STEPS:
1. Used baseline individual-level dataset
2. Filtered for specific villages (130A, 012B)
3. Reshaped data to household level
4. Kept only first household member (individ ending in "01")
5. Added two key variables:
   - wealth_stratum_02: For wealth classification
   - wealth_stratum_03: For village residency status

INSTRUCTIONS FOR DATA ENTRY:
- Fill in wealth_stratum_02 with household's wealth status
- Confirm if household still resides in village in wealth_stratum_03
- Refer to question text in respective "_question" variables

OUTPUT:
- Excel file: Midline_Wealth_Stratum_Classification_130A_012B.xlsx
- Located in: Data_Management\Output\Data_Quality_Checks\Midline\_Midline_Original_Issues_Output
**********************************************************/

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
global issues "$master\Data_Management\Output\Data_Quality_Checks\Midline\_Midline_Original_Issues_Output"

************************ School Data **************************************

* Load School Data   *
use "$clean\DISES_Complete_Midline_SchoolPrincipal.dta", clear

tempfile school_villages
save `school_villages'
keep hhid_village

* Load Baseline Household IDs *
use "$hhids\Complete_HouseholdIDs", clear

replace hhid_village = villageid if hhid_village == "" & villageid != ""

duplicates drop hhid_village, force
keep hhid_village

* Merge & Inspect    *
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
use "$hhids\Complete_HouseholdIDs", clear

replace hhid_village = villageid if hhid_village == "" & villageid != ""

duplicates drop hhid_village, force
keep hhid_village

* Merge & Inspect    *
merge 1:m hhid_village using `community_villages'
keep hhid_village _merge
* Show result
tab _merge
list hhid_village if _merge == 1
list hhid_village if _merge == 2
drop if missing(hhid_village)
duplicates drop hhid_village, force

*-----------------------------*
* export the hhid for the community survey that need wealth stratum corrected
*-----------------------------*

* Use the dataset
use "$baselineids\All_Villages_With_Individual_IDs.dta", clear

drop indiv_index

* Keep only specific villages
keep if hhid_village == "130A" | hhid_village == "012B"

* Reshape wide to hh level
* Reshape wide
reshape wide ///
    hh_full_name_calc_ ///
    hh_gender_ ///
    hh_age_ ///
    hh_relation_with_ ///
    hh_relation_with_o_, ///
    i(hhid_village sup enqu hh_head_name_complet hh_name_complet_resp hh_age_resp hh_gender_resp hh_phone individ) ///
    j(individual)
	
keep hhid_village individ hh_head_name_complet hh_name_complet_resp  hh_age_resp hh_gender_resp hh_phone individ

* keep one only per household
keep if substr(individ, -2, 2) == "01"

* Generate wealth stratum variables
gen wealth_stratum_02 = .

gen wealth_stratum_02_question = "Pouvez classer ce ménage dans les catégories de richesse au-dessus/en dessous de la médiane EN JANVIER 2024! (PAS MAINTENANT)?"

gen wealth_stratum_03 = .
gen wealth_stratum_03_question = "Est-ce que le répondant et son ménage vivent toujours dans le village?"

* Save to issues folder
export excel using "$issues\Midline_Wealth_Stratum_Classification_130A_012B.xlsx", firstrow(variables) replace

