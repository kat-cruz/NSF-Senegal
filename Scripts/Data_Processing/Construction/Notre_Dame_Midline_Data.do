**************************************************
* DISES Data for Notre Dame *
* File Created By: Alexander Mills *
* File Last Updated By: Alexander Mills *
* Updates Tracked on Git *
**************************************************

*** This Do File PROCESSES: PUT ALL SCRIPTS HERE***
*** This Do File CREATES: DISES_Data_for_Notre_Dame
						
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
global midline_community "$midline\Complete_Midline_Community.dta"

**************************************************
* baseline data
/*
Requested Village-level data:
-WASH adjacent (living_1, living_4)
-self-reported vegetation removal (binary and hours reported: hh_14)
-infected prevalence of children (and self-reported infection prevalence)
--> health_5_2, health_5_3, health_5_5, health_5_6, health_5_7, health_7_1, health_5_8, health_5_9
-reported water usage (hh_02, hh_10, hh_13)
-common water source (hh_11)
-knowledge_18, knowledge_21

From the community survey:
-number_hh & number_total
-q_23, q_24
-q_35_check, q_35

From the school survey:
-school_water_main

Requested individual-level data:
-child infection status, age, and gender
*/
**************************************************
use "$baseline_household", clear
* merge all together
merge 1:1 hhid using "$baseline_health", nogen
merge 1:1 hhid using "$baseline_agriculture", nogen
merge 1:1 hhid using "$baseline_income", nogen
merge 1:1 hhid using "$baseline_standard", nogen
merge 1:1 hhid using "$baseline_games", nogen
merge 1:1 hhid using "$baseline_enumerator", nogen
merge 1:1 hhid using "$baseline_beliefs", nogen	
merge 1:1 hhid using "$baseline_knowledge", nogen
merge m:1 hhid_village using "$baseline_community", nogen

* health_5_7, health_5_7_1, school_water_main, age, gender not in baseline
* child infection status, age, and gender from the paristological data?
keep hhid_village hhid living_01 living_04 hh_14* health_5_2* health_5_3* health_5_5* health_5_6* health_5_8* health_5_9* hh_02* hh_10* hh_13* hh_11* knowledge_18 knowledge_21 number_hh number_total q_23 q_24 q_35_check q_35 

* living_01: Count households with each water source type by village
foreach cat in 1 2 3 4 5 6 7 8 9 10 99 {
    gen water_count_`cat' = (living_01 == `cat')
    bysort hhid_village: egen village_water_`cat' = total(water_count_`cat')
    local lbl : label (living_01) `cat'
    label var village_water_`cat' "Count of HH in village: `lbl'"
}

* living_04: Count households with each toilet type by village
foreach cat in 0 1 2 3 4 5 6 99 {
    gen toilet_count_`cat' = (living_04 == `cat')
    bysort hhid_village: egen village_toilet_`cat' = total(toilet_count_`cat')
    local lbl : label (living_04) `cat'
    label var village_toilet_`cat' "Count of HH in village: `lbl'"
}

* hh_14: Total vegetation collection by village
egen hh_veg_total = rowtotal(hh_14*)
bysort hhid_village: egen village_veg_total = total(hh_veg_total)
label var village_veg_total "Total kg vegetation collected in village per week"

* health_5_2: Count households with any illness by village
forvalues i = 1/55 {
    cap gen health_5_2_`i'_bin = (health_5_2_`i' == 1) if health_5_2_`i' != 2
}
egen hh_any_ill = rowmax(health_5_2_*_bin)
bysort hhid_village: egen village_ill_count = total(hh_any_ill)
label var village_ill_count "Count of HH in village with any illness"

* health_5_3: Count households with each condition by village
foreach condition in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 99 {
    egen hh_illness_`condition' = rowmax(health_5_3_`condition'_*)
    bysort hhid_village: egen village_illness_`condition' = total(hh_illness_`condition')
    local lbl : label (health_5_3_1) `condition'
    label var village_illness_`condition' "Count of HH in village: `lbl'"
}

* health_5_5: Count households with schisto treatment
forvalues i = 1/55 {
    cap gen health_5_5_`i'_bin = (health_5_5_`i' == 1) if health_5_5_`i' != 2
}
egen hh_any_schisto_treat = rowmax(health_5_5_*_bin)
bysort hhid_village: egen village_treated_count = total(hh_any_schisto_treat)
label var village_treated_count "Count of HH in village with schisto treatment"

* health_5_6: Count households with schisto diagnosis
forvalues i = 1/55 {
    cap gen health_5_6_`i'_bin = (health_5_6_`i' == 1) if health_5_6_`i' != 2
}
egen hh_any_schisto_diag = rowmax(health_5_6_*_bin)
bysort hhid_village: egen village_diagnosed_count = total(hh_any_schisto_diag)
label var village_diagnosed_count "Count of HH in village with schisto diagnosis"

* health_5_8/9: Count households with blood symptoms
foreach symptom in 8 9 {
    forvalues i = 1/55 {
        cap gen health_5_`symptom'_`i'_bin = (health_5_`symptom'_`i' == 1) if health_5_`symptom'_`i' != 2
    }
    egen hh_any_blood_`symptom' = rowmax(health_5_`symptom'_*_bin)
    bysort hhid_village: egen village_blood_`symptom'_count = total(hh_any_blood_`symptom')
    label var village_blood_`symptom'_count "Count of HH in village with blood in `symptom'==8 urine / `symptom'==9 stools"
}

* Water usage: Total hours by village
* hh_02: Water fetching
egen hh_fetch_total = rowtotal(hh_02*)
bysort hhid_village: egen village_fetch_total = total(hh_fetch_total)
label var village_fetch_total "Total hours fetching water in village (last 7 days)"

* hh_10/13: Water contact hours
foreach var in hh_10 hh_13 {
    egen `var'_total = rowtotal(`var'*)
    bysort hhid_village: egen village_`var'_total = total(`var'_total)
    label var village_`var'_total "Total hours near water in village per week"
}

* hh_11: Count households using each water source
foreach type in 1 2 3 4 99 {
    gen byte hh_water_source_`type' = 0
    foreach i of numlist 1/55 {
        cap replace hh_water_source_`type' = 1 if hh_11_`i' == `type'
    }
    bysort hhid_village: egen village_source_`type'_count = total(hh_water_source_`type')
    local lbl : label (hh_11_1) `type'
    label var village_source_`type'_count "Count of HH using `lbl' as surface water"
}

* knowledge_18/21: Count households by water contact and frequency
gen water_contact = (knowledge_18 == 1)
bysort hhid_village: egen village_contact_count = total(water_contact)
label var village_contact_count "Count of HH with water contact"

foreach freq in 1 2 3 {
    gen freq_`freq' = (knowledge_21 == `freq')
    bysort hhid_village: egen village_freq_`freq'_count = total(freq_`freq')
    local lbl : label freq `freq'
    label var village_freq_`freq'_count "Count of HH with `lbl' water contact"
}

* Keep only village-level aggregates and community variables
keep hhid_village ///
    /* Village WASH counts */ ///
    village_water_* village_toilet_* ///
    /* Village vegetation total */ ///
    village_veg_total ///
    /* Village illness counts */ ///
    village_ill_count village_illness_* ///
    village_treated_count village_diagnosed_count ///
    village_blood_*_count ///
    /* Village water usage */ ///
    village_fetch_total village_hh_10_total village_hh_13_total ///
    village_source_*_count ///
    /* Village water contact */ ///
    village_contact_count village_freq_*_count ///
    /* Community variables */ ///
    number_hh number_total q_23 q_24 q_35_check q_35

* Drop duplicates and keep only village-level counts
duplicates drop hhid_village, force