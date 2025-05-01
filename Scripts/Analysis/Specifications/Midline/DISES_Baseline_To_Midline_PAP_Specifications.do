**************************************************
* DISES Baseline to Midline Specifications *
* File Created By: Alexander Mills *
* File Last Updated By: Alexander Mills *
* Updates Tracked on Git *
**************************************************

*** This Do File PROCESSES: PUT ALL SCRIPTS HERE***
*** This Do File CREATES: ANCOVA regression outputs for the PAP specifcaitons on baseline to midline data
						
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
global balance "$master\Data_Management\Output\Analysis\Balance_Tables\baseline_balance_tables_data_PAP.dta"
global treatment "$master\Data_Management\Data\_CRDES_CleanData\Treatment\Identified\treatment_indicator_PII.dta"
global asset_index "$master\Data_Management\Output\Data_Processing\Construction\PCA_asset_index_var.dta"
global hh_head_index "$master\Data_Management\Data\_CRDES_CleanData\Baseline\Deidentified\household_head_index.dta"
global balance_tables "$master\Data_Management\Output\Analysis\Balance_Tables"
global locations "$master\Data_Management\Data\Location_Data\hhsurvey_villages.csv"

global baseline_agriculture "$baseline\Complete_Baseline_Agriculture.dta"
global baseline_beliefs "$baseline\Complete_Baseline_Beliefs.dta"
global baseline_community "$baseline\Complete_Baseline_Community.dta"
global baseline_enumerator "$baseline\Complete_Baseline_Enumerator_Observations.dta"
global baseline_geographies "$baseline\Complete_Baseline_Geographies.dta"
global baseline_health "$baseline\Complete_Baseline_Health.dta"
global baseline_household "$baseline\Complete_Baseline_Household_Roster.dta"
global baseline_income "$baseline\Complete_Baseline_Income.dta"
global baseline_knowledge "$baseline\Complete_Baseline_Knowledge.dta"
global baseline_lean "$baseline\Complete_Baseline_Lean_Season.dta"
global baseline_production "$baseline\Complete_Baseline_Production.dta"
global baseline_standard "$baseline\Complete_Baseline_Standard_Of_Living.dta"
global baseline_community "$baseline\Complete_Baseline_Community.dta"
global baseline_games "$baseline\Complete_Baseline_Public_Goods_Game"

global midline_agriculture "$midline\Complete_Midline_Agriculture.dta"
global midline_beliefs "$midline\Complete_Midline_Beliefs.dta"
global midline_community "$midline\Complete_Midline_Community.dta"
global midline_enumerator "$midline\Complete_Midline_Enumerator_Observations.dta"
global midline_geographies "$midline\Complete_Midline_Geographies.dta"
global midline_health "$midline\Complete_Midline_Health.dta"
global midline_household "$midline\Complete_Midline_Household_Roster.dta"
global midline_income "$midline\Complete_Midline_Income.dta"
global midline_knowledge "$midline\Complete_Midline_Knowledge.dta"
global midline_lean "$midline\Complete_Midline_Lean_Season.dta"
global midline_production "$midline\Complete_Midline_Production.dta"
global midline_standard "$midline\Complete_Midline_Standard_Of_Living.dta"
global midline_community "$baseline\Complete_Midline_Community.dta"

**************************************************
* controls and treatment data
**************************************************
use "$baseline_household", clear

* merge all together needed for balance tables
merge 1:1 hhid using "$baseline_health", nogen
merge 1:1 hhid using "$baseline_agriculture", nogen
merge 1:1 hhid using "$baseline_income", nogen
merge 1:1 hhid using "$baseline_standard", nogen
merge 1:1 hhid using "$baseline_games", nogen
merge 1:1 hhid using "$baseline_enumerator", nogen
merge 1:1 hhid using "$baseline_beliefs", nogen	
merge m:1 hhid_village using "$baseline_community", nogen

* control variables:
* - q_51: distance to nearest health clinic (village-level)
* - num_water_access_points: number of water access points used by villagers (village-level)
* - hh_numero: household size
* - living_01_bin: access to piped water
* - hh_age_h: household head's age
* - hh_gender_h: household head's sex
* - hh_education_skills_5_h: household head's literacy status

* Create hh_numero (household size assumed to already exist)
* If not defined yet:
* egen hh_numero = rownonmiss(hh_age_*)  // example based on age vars

* Piped water access indicator
gen living_01_bin = inlist(living_01, 1, 2, 3)

***************
* num_water_access_points (village-level)
***************


***************
* Household head controls
***************
* Bring in respondent index to help ID head
merge 1:1 hhid using "$hh_head_index", nogen

gen hh_head_index = .
forvalues i = 1/55 {
    replace hh_head_index = `i' if hh_relation_with_`i' == 1
}
replace hh_head_index = resp_index if missing(hh_head_index) & !missing(resp_index)

* Fallback: use match by age/gender if still missing
forvalues i = 1/55 {
    replace hh_head_index = `i' if missing(hh_head_index) ///
        & hh_age_resp == hh_age_`i' & hh_gender_resp == hh_gender_`i'
}

* Age of head
gen hh_age_h = .
forvalues i = 1/55 {
    replace hh_age_h = hh_age_`i' if hh_head_index == `i'
}

* Gender of head (1 = male, 0 = female)
gen hh_gender_h = .
forvalues i = 1/55 {
    replace hh_gender_h = 1 if hh_head_index == `i' & hh_gender_`i' == 1
    replace hh_gender_h = 0 if hh_head_index == `i' & hh_gender_`i' == 2
}

* Literacy of head
gen hh_education_skills_5_h = 0
forvalues i = 1/55 {
    replace hh_education_skills_5_h = 1 if hh_head_index == `i' & hh_education_skills_5_`i' == 1
}


gen auction_village = inlist(hhid_village, "122A", "123A", "121B", "131B", "120B") | ///
                     inlist(hhid_village, "123B", "153A", "121A", "131A", "141A") | ///
                     hhid_village == "142A"
					 
keep hhid hhid_village hh_age_h hh_education_skills_5_h hh_gender_h hh_numero living_01_bin num_water_access_points auction_village


tempfile control_data
save `control_data', replace

**************************************************
* MERGE IN ASSET INDEX *
**************************************************
use "$asset_index", clear
tempfile asset_data
save `asset_data', replace

use `control_data', clear
merge 1:1 hhid using `asset_data', keep(master match) nogen

tempfile combined_data
save `combined_data', replace

**************************************************
* MERGE IN TREATMENT DATA *
**************************************************
use "$treatment", clear
foreach var of varlist * {
    capture confirm string variable `var'
    if !_rc {
        replace `var' = subinstr(`var', "132A", "153A", .)
    }
}
* collapse to treated household
collapse (max) trained_hh, by(hhid)
tempfile treatment_data
save `treatment_data', replace

use `combined_data', clear
merge 1:1 hhid using `treatment_data', keep(master match) nogen
drop if missing(hhid_village)

* gen treatment arm
gen byte treatment_arm = real(substr(hhid_village, 3, 1))
label define treatlbl 0 "Control" 1 "Arm A - Public Health" 2 "Arm B - Private Benefits" 3 "Arm C - Both Messages"
label values treatment_arm treatlbl

* gen stratum
gen stratum = substr(hhid_village, 4, 1)

* global controls
global controls q_51 num_water_access_points hh_numero living_01_bin asset_index_std hh_age_h i.hh_gender_h i.hh_education_skills_5_h

tempfile combined_data
save `combined_data', replace


*******************************
* DISTANCE VECTOR
*******************************

			
**************************************************
* 1.1.1, 1.1.2, 1.1.3
**************************************************
* baseline AVR (self-reports)
use "$baseline_household", clear
* household engaged in AVR (binary variable)
foreach var of varlist hh_14_* {
    replace `var' = 0 if missing(`var')
}
egen max_hh14 = rowmax(hh_14_*)

gen baseline_AVR = 0
replace baseline_AVR = 1 if max_hh14 > 0 

* keep just household id and avr for merging
keep hhid baseline_AVR

* store the avr data for later
tempfile baseline_avr_data
save `baseline_avr_data', replace

* 1.1.1, 1.1.2, 1.1.3
* midline AVR (self-reports)
use "$midline_household", clear
* household engaged in AVR (binary variable)
foreach var of varlist hh_14_* {
    replace `var' = 0 if missing(`var')
}
egen max_hh14 = rowmax(hh_14_*)

gen midline_AVR = 0
replace midline_AVR = 1 if max_hh14 > 0 

* keep just household id and avr for merging
keep hhid hhid_village midline_AVR

* store the midline avr data for later merging
tempfile midline_avr_data
save `midline_avr_data', replace

**************************************************
* merge everything together
**************************************************
* start with the combined dataset from before
use `combined_data', clear

* merge with treatment data
merge 1:1 hhid using `treatment_data', keep(master match) nogen

* merge in the baseline avr data
merge 1:1 hhid using `baseline_avr_data', keepusing(baseline_AVR) keep(master match) nogen

* merge in the midline avr data
merge 1:1 hhid using `midline_avr_data', keepusing(midline_AVR) keep(master match) nogen

**************************************************
* load and prepare baseline outcome variables
**************************************************
* 1.1.1, 1.1.2, 1.1.3
* baseline AVR (self-reports)
* variables: hh_12_6, hh_14

* 1.1.4, 1.1.5, 1.1.6
* baseline compost proudction
* repurpose vegetation for fertilizer. unsure the appropriate proxy

* 1.1.6
* baseline agricultral total factor productivity (value of total output divided by value of all inputs)
* baseline profitability
* heterogeneity anlalysis 

* 1.1.7
* baseline self-reported months of soudure and reduced coping strategies index

* 1.1.8
* baseline prevalence of schistosomaisis self-reported condition and symptoms

* 2.1.1
* baseline number of days of work or school lost due to ill health

* 2.1.2
* baseline highest completed grade, current school enrollment, self-reported school attendance

**************************************************
* load and prepare midline outcome variables
**************************************************
* 1.1.1, 1.1.2, 1.1.3
* midline AVR (self-reports)

* 1.1.4, 1.1.5, 1.1.6
* midline compost proudction
* repurpose vegetation for fertilizer? unsure the appropriate proxy

* 1.1.6
* midline agricultral total factor productivity (value of total output divided by value of all inputs)
* midline profitability
* heterogeneity anlalysis 

* 1.1.7
* midline self-reported months of soudure and reduced coping strategies index

* 1.1.8
* midline prevalence of schistosomaisis self-reported condition and symptoms

* 2.1.1
* midline number of days of work or school lost due to ill health

* 2.1.2
* midline highest completed grade, current school enrollment, self-reported school attendance

**************************************************
* specifications
**************************************************
* primary outcomes
* does training induce AVR (self-reports)
* 1.1.1
* need to add distance vector and then the controls are not binary from balance data either
* reg midline_AVR baseline_AVR $controls i.auctions_experiment, vce(cluster hhid_village) 
* 1.1.2

* 1.1.3
* need endline

* 1.1.4

* 1.1.5

* 1.1.6

* 1.1.7

* 1.1.8.1
* demands paristological

* 1.1.8.2

* 1.1.9.
* demands paristological

* 1.1.10.1

* 1.1.10.2

* 1.1.11

* 1.1.12
* midline to endline

* secondary outcomes
* 2.1.1

* 2.1.2

* 2.1.3
* baseline to endline

* 2.2.1
* demands sweep/drone imagery

* 2.2.2
* demands upstream water point as regressor

* 2.2.3
* demands upstream water point as regressor

* 2.3.1
* demands focus group
