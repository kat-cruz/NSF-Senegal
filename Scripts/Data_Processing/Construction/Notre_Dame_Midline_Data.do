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
global notredame "$master\Data_Management\External_Sharing\Notre_Dame"

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
global midline_principal "$midline\Complete_Midline_SchoolPrincipal.dta"

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
* Baseline Data Cleaning
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

* health_5_7, health_5_7_1, school_water_main not in baseline
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

* WASH Labels
foreach i in 1 2 3 4 5 6 7 8 9 10 99 {
    local lbl : label (living_01) `i'
    label var village_water_`i' "Number of households in village using `lbl' as main water source"
}

foreach i in 0 1 2 3 4 5 6 99 {
    local lbl : label (living_04) `i'
    label var village_toilet_`i' "Number of households in village using `lbl' as main toilet type"
}

* Vegetation Collection Label
label var village_veg_total "Total kilograms of aquatic vegetation collected by all households in village per week"

* Illness Labels
label var village_ill_count "Number of households in village reporting any illness in past 12 months"

foreach i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 99 {
    local lbl : label (health_5_3_1) `i'
    label var village_illness_`i' "Number of households in village reporting: `lbl'"
}

* Schistosomiasis Specific Labels
label var village_treated_count "Number of households in village with any member receiving schistosomiasis treatment in past 12 months"
label var village_diagnosed_count "Number of households in village with any member ever diagnosed with schistosomiasis"
label var village_blood_8_count "Number of households in village with any member reporting blood in urine in past 12 months"
label var village_blood_9_count "Number of households in village with any member reporting blood in stools in past 12 months"

* Water Usage Labels
label var village_fetch_total "Total hours spent fetching water by all households in village (past 7 days)"
label var village_hh_10_total "Total hours spent within 1m of surface water by all households in village (per week)"
label var village_hh_13_total "Total hours spent at specific water sources by all households in village (per week)"

* Surface Water Source Labels
foreach i in 1 2 3 4 99 {
    local lbl : label (hh_11_1) `i'
    label var village_source_`i'_count "Number of households in village using `lbl' as surface water source"
}

* Water Contact Labels
label var village_contact_count "Number of households in village reporting water contact in past 12 months"
label var village_freq_1_count "Number of households in village with daily water contact"
label var village_freq_2_count "Number of households in village with weekly water contact"
label var village_freq_3_count "Number of households in village with monthly water contact"

* Community Survey Labels
label var number_hh "Total number of households in village (community survey)"
label var number_total "Total population in village (community survey)"
label var q_23 "Number of village water sources"
label var q_24 "Number of functional village water sources"
label var q_35_check "Presence of village health committee (1=yes)"
label var q_35 "Number of village health committee members"

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

* gen a variable of time that says 2024
* Generate time variable for baseline
gen time = 2024
label var time "Survey round (2024=baseline, 2025=midline)"

tempfile baseline_data
save `baseline_data'

**************************************************
* Midline Data Cleaning
**************************************************
use "$midline_household", clear

* merge all together
merge 1:1 hhid using "$midline_health", nogen
merge 1:1 hhid using "$midline_agriculture", nogen
merge 1:1 hhid using "$midline_income", nogen
merge 1:1 hhid using "$midline_standard", nogen
merge 1:1 hhid using "$midline_enumerator", nogen
merge 1:1 hhid using "$midline_beliefs", nogen	
merge 1:1 hhid using "$midline_knowledge", nogen
merge m:1 hhid_village using "$midline_community", nogen

* Keep relevant variables
keep hhid_village hhid living_01 living_04 hh_14* health_5_2* health_5_3* health_5_5* health_5_6* health_5_7* health_5_8* health_5_9* hh_02* hh_10* hh_13* hh_11* knowledge_18 knowledge_21 number_hh number_total q_24 q_35_check q_35 

* Replicate baseline village-level aggregations
* living_01: Count households with each water source type
foreach cat in 1 2 3 4 5 6 7 8 9 10 99 {
    gen water_count_`cat' = (living_01 == `cat')
    bysort hhid_village: egen village_water_`cat' = total(water_count_`cat')
    local lbl : label (living_01) `cat'
    label var village_water_`cat' "Count of HH in village: `lbl'"
}

* living_04: Count households with each toilet type
foreach cat in 0 1 2 3 4 5 6 99 {
    gen toilet_count_`cat' = (living_04 == `cat')
    bysort hhid_village: egen village_toilet_`cat' = total(toilet_count_`cat')
    local lbl : label (living_04) `cat'
    label var village_toilet_`cat' "Count of HH in village: `lbl'"
}

* Vegetation collection
egen hh_veg_total = rowtotal(hh_14*)
bysort hhid_village: egen village_veg_total = total(hh_veg_total)
label var village_veg_total "Total kg vegetation collected in village per week"

* Health indicators
forvalues i = 1/55 {
    cap gen health_5_2_`i'_bin = (health_5_2_`i' == 1) if health_5_2_`i' != 2
}
egen hh_any_ill = rowmax(health_5_2_*_bin)
bysort hhid_village: egen village_ill_count = total(hh_any_ill)

foreach condition in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 99 {
    egen hh_illness_`condition' = rowmax(health_5_3_`condition'_*)
    bysort hhid_village: egen village_illness_`condition' = total(hh_illness_`condition')
}

* Schistosomiasis indicators
forvalues i = 1/55 {
    cap gen health_5_5_`i'_bin = (health_5_5_`i' == 1) if health_5_5_`i' != 2
    cap gen health_5_6_`i'_bin = (health_5_6_`i' == 1) if health_5_6_`i' != 2
}
egen hh_any_schisto_treat = rowmax(health_5_5_*_bin)
egen hh_any_schisto_diag = rowmax(health_5_6_*_bin)
bysort hhid_village: egen village_treated_count = total(hh_any_schisto_treat)
bysort hhid_village: egen village_diagnosed_count = total(hh_any_schisto_diag)

* Blood symptoms
foreach symptom in 8 9 {
    forvalues i = 1/55 {
        cap gen health_5_`symptom'_`i'_bin = (health_5_`symptom'_`i' == 1) if health_5_`symptom'_`i' != 2
    }
    egen hh_any_blood_`symptom' = rowmax(health_5_`symptom'_*_bin)
    bysort hhid_village: egen village_blood_`symptom'_count = total(hh_any_blood_`symptom')
}

* Water usage
egen hh_fetch_total = rowtotal(hh_02*)
bysort hhid_village: egen village_fetch_total = total(hh_fetch_total)

foreach var in hh_10 hh_13 {
    egen `var'_total = rowtotal(`var'*)
    bysort hhid_village: egen village_`var'_total = total(`var'_total)
}

* Water sources
foreach type in 1 2 3 4 99 {
    gen byte hh_water_source_`type' = 0
    foreach i of numlist 1/55 {
        cap replace hh_water_source_`type' = 1 if hh_11_`i' == `type'
    }
    bysort hhid_village: egen village_source_`type'_count = total(hh_water_source_`type')
}

* Water contact
gen water_contact = (knowledge_18 == 1)
bysort hhid_village: egen village_contact_count = total(water_contact)

foreach freq in 1 2 3 {
    gen freq_`freq' = (knowledge_21 == `freq')
    bysort hhid_village: egen village_freq_`freq'_count = total(freq_`freq')
}

* Schistosomiasis affected and pink urine symptoms
forvalues i = 1/55 {
    cap gen health_5_7_`i'_bin = (health_5_7_`i' == 1) if health_5_7_`i' != 2
    cap gen health_5_7_1_`i'_bin = (health_5_7_1_`i' == 1) if health_5_7_1_`i' != 2
}

* Household level aggregation
egen hh_any_schisto_affected = rowmax(health_5_7_*_bin)
egen hh_any_pink_urine = rowmax(health_5_7_1_*_bin)

* Village level counts
bysort hhid_village: egen village_affected_count = total(hh_any_schisto_affected)
bysort hhid_village: egen village_pink_urine_count = total(hh_any_pink_urine)

* Labels
label var village_affected_count "Number of households in village with any member affected by schistosomiasis in past 12 months"
label var village_pink_urine_count "Number of households in village with any member reporting pink urine in past 12 months"

* WASH Labels
foreach i in 1 2 3 4 5 6 7 8 9 10 99 {
    local lbl : label (living_01) `i'
    label var village_water_`i' "Number of households in village using `lbl' as main water source"
}

foreach i in 0 1 2 3 4 5 6 99 {
    local lbl : label (living_04) `i'
    label var village_toilet_`i' "Number of households in village using `lbl' as main toilet type"
}

* Vegetation Collection Label
label var village_veg_total "Total kilograms of aquatic vegetation collected by all households in village per week"

* Illness Labels
label var village_ill_count "Number of households in village reporting any illness in past 12 months"

foreach i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 99 {
    local lbl : label (health_5_3_1) `i'
    label var village_illness_`i' "Number of households in village reporting: `lbl'"
}

* Schistosomiasis Specific Labels
label var village_treated_count "Number of households in village with any member receiving schistosomiasis treatment in past 12 months"
label var village_diagnosed_count "Number of households in village with any member ever diagnosed with schistosomiasis"
label var village_blood_8_count "Number of households in village with any member reporting blood in urine in past 12 months"
label var village_blood_9_count "Number of households in village with any member reporting blood in stools in past 12 months"

* Water Usage Labels
label var village_fetch_total "Total hours spent fetching water by all households in village (past 7 days)"
label var village_hh_10_total "Total hours spent within 1m of surface water by all households in village (per week)"
label var village_hh_13_total "Total hours spent at specific water sources by all households in village (per week)"

* Surface Water Source Labels
foreach i in 1 2 3 4 99 {
    local lbl : label (hh_11_1) `i'
    label var village_source_`i'_count "Number of households in village using `lbl' as surface water source"
}

* Water Contact Labels
label var village_contact_count "Number of households in village reporting water contact in past 12 months"
label var village_freq_1_count "Number of households in village with daily water contact"
label var village_freq_2_count "Number of households in village with weekly water contact"
label var village_freq_3_count "Number of households in village with monthly water contact"

* Community Survey Labels
label var number_hh "Total number of households in village (community survey)"
label var number_total "Total population in village (community survey)"
label var q_24 "Number of functional village water sources"
label var q_35_check "Presence of village health committee (1=yes)"
label var q_35 "Number of village health committee members"

* Keep village-level variables
keep hhid_village village_* number_hh number_total q_24 q_35_check q_35

* Drop duplicates
duplicates drop hhid_village, force

* Store household data in memory
tempfile household_data
save `household_data'

* Now handle school data separately
use "$midline_principal", clear
keep hhid_village school_water_main

* Create school water source counts by village
bysort hhid_village: egen school_count = count(school_water_main)
foreach source in 1 2 3 4 5 99 {
    gen school_water_`source' = (school_water_main == `source')
    bysort hhid_village: egen village_school_water_`source' = total(school_water_`source')
}

* Keep one observation per village
duplicates drop hhid_village, force

* Save school data in memory
tempfile school_data
save `school_data'

* Merge back to main dataset
use `household_data', clear
merge m:1 hhid_village using `school_data', nogen

* Add labels for school water variables
label var school_count "Number of schools in village"
foreach source in 1 2 3 4 5 99 {
    local lbl : label (school_water_main) `source'
    label var village_school_water_`source' "Number of schools in village using `lbl' as water source"
}
drop school_water*
* Generate time variable for midline
gen time = 2025
label var time "Survey round (2024=baseline, 2025=midline)"

* Save complete midline data in memory
tempfile midline_data
save `midline_data'

* Load baseline and append midline to create panel
use `baseline_data', clear
append using `midline_data'

* Final variable labels after appending
* First recreate value labels
label define water_source 1 "Interior tap" 2 "Public tap" 3 "Neighbor's tap" ///
    4 "Protected well" 5 "Unprotected well" 6 "Drill hole" 7 "Tanker service" ///
    8 "Water seller" 9 "Source" 10 "Stream" 99 "Other"

label define toilet_type 0 "None/outside" 1 "Flush with sewer" ///
    2 "Toilet flush with septic tank" 3 "Bucket" 4 "Covered pit latrines" ///
    5 "Uncovered pit latrines" 6 "Improved latrines" 99 "Others"

label define disease_type 1 "Malaria" 2 "Bilharzia" 3 "Diarrhea" 4 "Injuries" ///
    5 "Dental problems" 6 "Skin Problems" 7 "Eye problems" 8 "Throat Problems" ///
    9 "Stomach aches" 10 "Fatigue" 11 "STI" 12 "Trachoma" 13 "Onchocerciasis" ///
    14 "Lymphatic filariasis" 99 "Other"

label define school_water 1 "Piped" 2 "Tubewell" 3 "Well" 4 "Rainwater" ///
    5 "River/Lake/Canal" 99 "Other"

* Basic identifiers
label var hhid_village "Village ID"
label var time "Survey round (2024=baseline, 2025=midline)"

* Community survey variables
label var number_hh "Number of households in village (number_hh)"
label var number_total "Total population in village (number_total)"
label var q_23 "Does the village have running drinking water for drinking (q_23)"
label var q_24 "Does the village have a tap water system (q_24)"
label var q_35_check "Village had deworming treatment by Ministry of Health/other org (1=yes) (q_35_check)"
label var q_35 "Date of last deworming treatment in village (q_35)"

* WASH variables
foreach i in 1 2 3 4 5 6 7 8 9 10 99 {
    local lbl : label water_source `i'
    label var village_water_`i' "Number of HH using `lbl' as main water source (living_01)"
}

foreach i in 0 1 2 3 4 5 6 99 {
    local lbl : label toilet_type `i'
    label var village_toilet_`i' "Number of HH using `lbl' as main toilet type (living_04)"
}

* Vegetation collection
label var village_veg_total "Total kg vegetation collected in village per week (hh_14)"

* General illness
label var village_ill_count "Number of HH reporting any illness in past 12 months (health_5_2)"

* Specific diseases
foreach i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 99 {
    local lbl : label disease_type `i'
    label var village_illness_`i' "Number of HH reporting `lbl' (health_5_3_`i')"
}

* Schistosomiasis indicators
label var village_treated_count "Number of HH with member receiving schisto treatment (health_5_5)"
label var village_diagnosed_count "Number of HH with member diagnosed with schisto (health_5_6)"
label var village_blood_8_count "Number of HH with member reporting blood in urine (health_5_8)"
label var village_blood_9_count "Number of HH with member reporting blood in stools (health_5_9)"
label var village_affected_count "Number of HH with member affected by schisto (health_5_7)"
label var village_pink_urine_count "Number of HH with member reporting pink urine (health_5_7_1)"

* Water usage
label var village_fetch_total "Total hours fetching water in village, past 7 days (hh_02)"
label var village_hh_10_total "Total hours within 1m of surface water in village per week (hh_10)"
label var village_hh_13_total "Total hours at specific water sources in village per week (hh_13)"

* Surface water sources
foreach type in 1 2 3 4 99 {
    local lbl : label water_source `type'
    label var village_source_`type'_count "Number of HH using `lbl' as surface water source (hh_11)"
}

* Water contact behavior
label var village_contact_count "Number of HH reporting water contact (knowledge_18)"
label var village_freq_1_count "Number of HH with daily water contact (knowledge_21)"
label var village_freq_2_count "Number of HH with weekly water contact (knowledge_21)"
label var village_freq_3_count "Number of HH with monthly water contact (knowledge_21)"

* School variables
label var school_count "Number of schools in village"
foreach source in 1 2 3 4 5 99 {
    local lbl : label school_water `source'
    label var village_school_water_`source' "Number of schools using `lbl' as water source (school_water_main)"
}

* Surface water sources
foreach i in 1 2 3 4 99 {
    * Define label text based on code
    local lbl = cond(`i'==1, "Lake", ///
                cond(`i'==2, "Pond", ///
                cond(`i'==3, "River", ///
                cond(`i'==4, "Irrigation channel", "Other"))))
    label var village_source_`i'_count "Number of HH using `lbl' as surface water source (hh_11)"
}

* Save Stata dataset first
save "$notredame/village_level_data.dta", replace

* Export to Excel with labels
preserve
    * Create temporary variable to hold labels
    foreach v of varlist * {
        local lbl : variable label `v'
        if "`lbl'" == "" {
            local lbl "`v'"
        }
        rename `v' `v'_orig
        gen `v' = `v'_orig
        label var `v' "`lbl'"
    }
    
    * Drop original variables
    foreach v of varlist *_orig {
        drop `v'
    }
    
    * Export to Excel
    export excel using "$notredame/village_level_labeled.xlsx", ///
        firstrow(varlabels) replace
    
restore
