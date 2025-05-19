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

* living_01
* village-level proportions for each water source category
foreach cat in 1 2 3 4 5 6 7 8 9 10 99 {
    * Generate proportion for each category
    gen prop_water_`cat' = (living_01 == `cat')
    
    * Calculate village-level means (proportions)
    bysort hhid_village: egen village_water_`cat' = mean(prop_water_`cat')
    
    * Label variables
    local lbl : label (living_01) `cat'
    label var village_water_`cat' "Prop. HH in village: `lbl'"
}

* living_04
* village-level proportions for each toilet type
foreach cat in 0 1 2 3 4 5 6 99 {
    * proportion for each category
    gen prop_toilet_`cat' = (living_04 == `cat')
    
    * village-level means (proportions)
    bysort hhid_village: egen village_toilet_`cat' = mean(prop_toilet_`cat')
    
    * variables with proper descriptions
    local lbl : label (living_04) `cat'
    label var village_toilet_`cat' "Prop. HH in village: `lbl'"
}

* hh_14
* Sum vegetation collection across household members (hh_14)
egen hh_veg_total = rowtotal(hh_14*)
label var hh_veg_total "Total kg vegetation collected by household per week"

* Calculate village-level means (hh_14)
bysort hhid_village: egen village_veg_mean = mean(hh_veg_total)
label var village_veg_mean "Mean kg vegetation collected per HH in village"

* health_5_2
* Create binary illness indicators for each household member
forvalues i = 1/55 {
    cap gen health_5_2_`i'_bin = (health_5_2_`i' == 1) if health_5_2_`i' != 2
}

* Household level calculations
* Any illness in household
egen hh_any_ill = rowmax(health_5_2_*_bin)
label var hh_any_ill "Any HH member ill in past 12mo"

* health_5_3*
* household-level illness indicators for each condition
foreach condition in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 99 {
    * First get household-level indicators
    egen hh_illness_`condition' = rowmax(health_5_3_`condition'_*)
    label var hh_illness_`condition' "HH: Any member with condition `condition'"
    
    * Then aggregate to village level
    bysort hhid_village: egen village_illness_`condition' = mean(hh_illness_`condition')
    local lbl : label (health_5_3_1) `condition'
    label var village_illness_`condition' "Village prop: `lbl'"
}

* summary measures at household level
egen hh_condition_count = rowtotal(hh_illness_*)
label var hh_condition_count "Number of distinct conditions in HH"

* health_5_5*
* Create clean binary treatment indicators for each household member
forvalues i = 1/55 {
    * Create binary indicator only for clear Yes/No responses
    cap gen health_5_5_`i'_bin = .
    cap replace health_5_5_`i'_bin = 1 if health_5_5_`i' == 1
    cap replace health_5_5_`i'_bin = 0 if health_5_5_`i' == 0
    * Note: leaves as missing if health_5_5_`i' == 2 (Don't know)
}

* Household level calculations
* Any member received treatment (excluding don't know responses)
egen hh_any_schisto_treat = rowmax(health_5_5_*_bin)
label var hh_any_schisto_treat "Any HH member received schisto treatment"

* Count of household members with known treatment status
egen hh_known_treatment = rownonmiss(health_5_5_*_bin)
label var hh_known_treatment "Number of HH members with known treatment status"

* Village level calculations
* Proportion of households with any treatment (among those with known status)
bysort hhid_village: egen village_any_treated = mean(hh_any_schisto_treat)
label var village_any_treated "Prop. of HH in village with any schisto treatment"

* health_5_6*
* Create clean binary diagnosis indicators for each household member
forvalues i = 1/55 {
    * Create binary indicator only for clear Yes/No responses
    cap gen health_5_6_`i'_bin = .
    cap replace health_5_6_`i'_bin = 1 if health_5_6_`i' == 1
    cap replace health_5_6_`i'_bin = 0 if health_5_6_`i' == 0
    * Note: leaves as missing if health_5_6_`i' == 2 (Don't know)
}

* Household level calculations
* Any member ever diagnosed
egen hh_any_schisto_diag = rowmax(health_5_6_*_bin)
label var hh_any_schisto_diag "Any HH member ever diagnosed with schisto"

* Count of household members with known diagnosis status
egen hh_known_diagnosis = rownonmiss(health_5_6_*_bin)
label var hh_known_diagnosis "Number of HH members with known diagnosis status"

* Village level calculations
* Proportion of households with any diagnosis (among those with known status)
bysort hhid_village: egen village_any_diagnosed = mean(hh_any_schisto_diag)
label var village_any_diagnosed "Prop. of HH in village with any schisto diagnosis"

* health_5_8* and health_5_9* (blood in urine and stools)
foreach symptom in 8 9 {
    * Create clean binary indicators for each household member
    forvalues i = 1/55 {
        * Create binary indicator only for clear Yes/No responses
        cap gen health_5_`symptom'_`i'_bin = .
        cap replace health_5_`symptom'_`i'_bin = 1 if health_5_`symptom'_`i' == 1
        cap replace health_5_`symptom'_`i'_bin = 0 if health_5_`symptom'_`i' == 0
        * Note: leaves as missing if == 2 (Don't know)
    }
    
    * Household level calculations
    * Any member with symptom
    egen hh_any_blood_`symptom' = rowmax(health_5_`symptom'_*_bin)
    label var hh_any_blood_`symptom' "Any HH member with blood in `symptom'==8 urine / `symptom'==9 stools"
    
    * Count members with known symptom status
    egen hh_known_blood_`symptom' = rownonmiss(health_5_`symptom'_*_bin)
    label var hh_known_blood_`symptom' "Number HH members with known blood status (`symptom')"
    
    * Village level calculations
    * Proportion of households reporting symptom
    bysort hhid_village: egen village_any_blood_`symptom' = mean(hh_any_blood_`symptom')
    label var village_any_blood_`symptom' "Prop. HH in village with blood in `symptom'==8 urine / `symptom'==9 stools"
    
    * Data quality check
    gen has_blood_data_`symptom' = (hh_known_blood_`symptom' > 0)
    bysort hhid_village: egen village_blood_reporting_`symptom' = mean(has_blood_data_`symptom')
    label var village_blood_reporting_`symptom' "Prop. HH reporting blood status (`symptom')"
}

* Create combined blood symptom indicators
egen hh_any_blood_symptom = rowmax(hh_any_blood_8 hh_any_blood_9)
label var hh_any_blood_symptom "Any HH member with either blood symptom"

* hh_02
egen hh_fetch_total = rowtotal(hh_02*)
label var hh_fetch_total "Total hours fetching water by HH (last 7 days)"

bysort hhid_village: egen village_fetch_mean = mean(hh_fetch_total)
label var village_fetch_mean "Mean hours fetching water per HH in village"

* hh_10 hh_13
foreach var in hh_10 hh_13 {
    * Total hours across household members
    egen `var'_total = rowtotal(`var'*)
    label var `var'_total "Total hours near water per week (HH total)"
    
}

* hh_11
* First for each type
foreach type in 1 2 3 4 99 {
    * Any household member using this source
    gen byte hh_water_source_`type' = 0
    foreach i of numlist 1/55 {
        cap replace hh_water_source_`type' = 1 if hh_11_`i' == `type'
    }
    
    * Get village proportions
    bysort hhid_village: egen village_water_source_`type' = mean(hh_water_source_`type')
    
    * Label variables
    local lbl : label (hh_11_1) `type'
    label var village_water_source_`type' "Prop. HH using `lbl' as surface water"
}

* knowledge_18: Water contact in last 12 months
* Create clean binary indicator
gen water_contact = .
replace water_contact = 1 if knowledge_18 == 1
replace water_contact = 0 if knowledge_18 == 0
label var water_contact "Had water contact in last 12mo"

* Village-level proportion with water contact
bysort hhid_village: egen village_water_contact = mean(water_contact)
label var village_water_contact "Prop. HH with water contact in village"

* knowledge_21: Contact frequency 
* Create ordinal frequency measure (higher = more frequent)
gen water_freq = .
replace water_freq = 3 if knowledge_21 == 1  // Daily
replace water_freq = 2 if knowledge_21 == 2  // Weekly
replace water_freq = 1 if knowledge_21 == 3  // Monthly
label define freq 1 "Monthly" 2 "Weekly" 3 "Daily"
label values water_freq freq
label var water_freq "Frequency of water contact"

