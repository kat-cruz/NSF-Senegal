**************************************************
* DISES Baseline to Baseline Specifications *
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
global walking_distance_vector "$master\Data_Management\Data\Location_Data\walking_distance_vector.csv"
global tfp "$master\Data_Management\Output\Analysis\Auctions_Shadow_Wages\complete_data_clean.dta"
global specifications "$master\Data_Management\Output\Analysis\Specifications\Midline"

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
* controls and treatment data
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
merge m:1 hhid_village using "$baseline_community", nogen

* control variables:
* - q_51: distance to nearest health clinic (village-level)
* - num_water_access_points: number of water access points used by villagers (village-level)
* - hh_numero: household size
* - living_01_bin: access to piped water
* - hh_age_h: household head's age
* - hh_gender_h: household head's sex
* - hh_education_skills_5_h: household head's literacy status


* access to piped water
* using indicator for selected tap water as main source of drinking water
* household-level piped water access (taps only)
gen living_01_bin = inlist(living_01, 1, 2, 3) // interior, public, or neighbor's tap
label variable living_01_bin "Household has piped water access"

* count of water sources at village level
preserve 
    // generate indicators for each water source type
    gen interior_tap = living_01 == 1 
    gen public_tap = living_01 == 2
    gen neighbor_tap = living_01 == 3 
    gen protected_well = living_01 == 4
    gen unprotected_well = living_01 == 5  
    gen drill_hole = living_01 == 6
    gen tanker_service = living_01 == 7
    gen water_seller = living_01 == 8
    gen natural_source = living_01 == 9
    gen stream = living_01 == 10
    gen other_water = living_01 == 99

    // collapse to village level - any household using each source
    collapse (max) interior_tap public_tap neighbor_tap protected_well unprotected_well ///
        drill_hole tanker_service water_seller natural_source stream other_water, ///
        by(hhid_village)
    
    // count total number of different water sources used in village
    egen num_water_access_points = rowtotal(interior_tap public_tap neighbor_tap ///
        protected_well unprotected_well drill_hole tanker_service water_seller ///
        natural_source stream other_water)
    
    keep hhid_village num_water_access_points
    
    tempfile village_water
    save `village_water'
restore

// merge village-level water access back to main data
merge m:1 hhid_village using `village_water', nogen

label variable num_water_access_points "Number of different water sources used in village"

* household head controls
* bring in hh head index for id
merge 1:1 hhid using "$hh_head_index", nogen

* age of head
gen hh_age_h = .
forvalues i = 1/55 {
    replace hh_age_h = hh_age_`i' if hh_head_index == `i'
}
label variable hh_age_h "Household head age"

* gender of head (1 = male, 0 = female)
gen hh_gender_h = .
forvalues i = 1/55 {
    replace hh_gender_h = 1 if hh_head_index == `i' & hh_gender_`i' == 1
    replace hh_gender_h = 0 if hh_head_index == `i' & hh_gender_`i' == 2
}
label variable hh_gender_h "Household head gender"

* literacy of head
gen hh_education_skills_5_h = 0
forvalues i = 1/55 {
    replace hh_education_skills_5_h = 1 if hh_head_index == `i' & hh_education_skills_5_`i' == 1
}
label variable hh_education_skills_5_h "Indicator that household head is literate"

* 
gen auction_village = inlist(hhid_village, "122A", "123A", "121B", "131B", "120B") | ///
                     inlist(hhid_village, "123B", "153A", "121A", "131A", "141A") | ///
                     hhid_village == "142A"

keep hhid hhid_village hh_age_h hh_education_skills_5_h hh_gender_h hh_numero living_01_bin auction_village q4 q_51

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

* global controls (need to construct num_water_access_points)
global controls q_4 q_51 hh_numero living_01_bin asset_index_std hh_age_h i.hh_gender_h i.hh_education_skills_5_h

tempfile combined_data
save `combined_data', replace

*******************************
* DISTANCE VECTOR
*******************************
import delimited "$walking_distance_vector", clear

tempfile distance_vector
save `distance_vector', replace

use `combined_data', clear
merge m:1 hhid_village using `distance_vector', keep(master match) nogen

* label variables
label var walking_minutes_to_arm_0 "Walking minutes to nearest control village (arm 0)"
label var walking_minutes_to_arm_1 "Walking minutes to nearest treatment village (arm A)"
label var walking_minutes_to_arm_2 "Walking minutes to nearest treatment village (arm B)"
label var walking_minutes_to_arm_3 "Walking minutes to nearest treatment village (arm C)"
label var treatment_arm "Treatment arm"
label var stratum "Randomization stratum"
label var q4 "Number of Water Access Points"
label var q_51 "Distance to nearest health facility"
label var hhid "Household ID"
label var hhid_village "Village ID"
label var hh_numero "Household size"
label var gpd_datalatitude "GPS latitude"
label var gpd_datalongitude "GPS longitude"
label var distance_vector "Distance vector"
label var auction_village "Village in auction experiment (Doruska et al. 2024)"
label var trained_hh "Treated Household"

global distance_vector walking_minutes_to_arm_0 walking_minutes_to_arm_1 walking_minutes_to_arm_2 walking_minutes_to_arm_3

save `combined_data', replace

**************************************************
* load and prepare baseline outcome variables
**************************************************
* 1.1.1, 1.1.2, 1.1.3
* baseline AVR (self-reports)
use "$baseline_household", clear
merge 1:1 hhid using "$baseline_health", nogen
merge 1:1 hhid using "$baseline_agriculture", nogen
merge 1:1 hhid using "$baseline_income", nogen
merge 1:1 hhid using "$baseline_standard", nogen
merge 1:1 hhid using "$baseline_games", nogen
merge 1:1 hhid using "$baseline_enumerator", nogen
merge 1:1 hhid using "$baseline_beliefs", nogen	
merge m:1 hhid_village using "$baseline_community", nogen

* variables: hh_12_6, hh_13_6, hh_14, hh_20_6, hh_21, hh_22
* aggregate hh_12_6* to a value of 1 if there is any value of 1 or that rowtotal > 0
ds hh_12_6*, has(type string)
foreach var of varlist `r(varlist)' {
    destring `var', replace force
}
egen rowtotal_hh_12_6 = rowtotal(hh_12_6*)
gen agg_hh_12_6 = rowtotal_hh_12_6 > 0
* aggregate hh_14* to a value of 1 if there is any value greater than 0 in that rowtotal
egen rowtotal_hh_14 = rowtotal(hh_14*)
gen agg_hh_14 = rowtotal_hh_14 > 0
* aggregate hh_20_6* to a value of 1 if there is any value of 1 or that rowtotal > 0
ds hh_20_6*, has(type string)
foreach var of varlist `r(varlist)' {
    destring `var', replace force
}
egen rowtotal_hh_20_6 = rowtotal(hh_20_6*)
gen agg_hh_20_6 = rowtotal_hh_20_6 > 0
* aggregate hh_22* to a value of 1 if there is any value greater than 0 in that row total
egen rowtotal_hh_22 = rowtotal(hh_22*)
gen agg_hh_22 = rowtotal_hh_22 > 0
* create AVR composite indicator from any of the aggregated components
gen baseline_avr = (agg_hh_12_6 == 1 | agg_hh_14 == 1 | agg_hh_20_6 == 1 | agg_hh_22 == 1)

* 1.1.4, 1.1.5, 1.1.6
* baseline compost proudction
* variables: hh_15_2, hh_23_2, agri_6_34_comp, agri_6_34
* hh_15_2* > 0
ds hh_15_2*, has(type string)
if "`r(varlist)'" != "" {
    foreach var of varlist `r(varlist)' {
        destring `var', replace force
    }
}
egen rowtotal_hh_15_2 = rowtotal(hh_15_2*)
gen agg_hh_15_2 = rowtotal_hh_15_2 > 0
* hh_23_2* > 1
ds hh_23_2*, has(type string)
if "`r(varlist)'" != "" {
    foreach var of varlist `r(varlist)' {
        destring `var', replace force
    }
}
egen rowtotal_hh_23_2 = rowtotal(hh_23_2*)
gen agg_hh_23_2 = rowtotal_hh_23_2 > 1
* agri_6_34_comp == 1
ds agri_6_34_comp*, has(type numeric)
egen rowtotal_agri_6_34_comp = rowtotal(`r(varlist)')
gen agg_agri_6_34_comp = rowtotal_agri_6_34_comp > 0
* agri_6_34 == 1
ds agri_6_34*, has(type numeric)
egen rowtotal_agri_6_34 = rowtotal(`r(varlist)')
gen agg_agri_6_34 = rowtotal_agri_6_34 > 0

* create compost composite indicator from any of the aggregated components
gen baseline_compost_production = (agg_hh_15_2 == 1 | agg_hh_23_2 == 1 | agg_agri_6_34_comp == 1 | agg_agri_6_34 == 1)

* variable labels
label var baseline_avr "Baseline AVR"
label var baseline_compost_production "Baseline compost production"

keep hhid baseline_avr baseline_compost_production

tempfile baseline_outcomes
save `baseline_outcomes'

* merge back into combined data
use `combined_data', clear
merge 1:1 hhid using `baseline_outcomes', keep(master match) nogen

save `combined_data', replace

* 1.1.6
use "$tfp", clear
keep if year == 2024
merge 1:1 hhid using "$baseline_agriculture", nogen
merge 1:1 hhid using "$baseline_income", nogen 
merge 1:1 hhid using "$baseline_production", nogen
merge m:1 hhid_village using "$baseline_community", nogen

* keep only variables needed for TFP calculation
keep hhid hhid_village year ///
    value_prod_1 /// Output value
    prod_hect_1 /// Land input
    ag_hours_1  /// Labor hours
    daily_wage_1 /// Wage rate
    agri_income_16 /// Hired labor cost
    fert_1 /// Fertilizer quantity
    q63_1 /// Fertilizer price (from community survey)
    number_mech_equip /// Equipment
    agri_income_01 /// Land rental payments
    total_production_hectares // For land rate calculation

* calculate input values using observed prices
* Labor cost (family + hired)
gen labor_cost = (ag_hours_1 * daily_wage_1) + agri_income_16

* land cost
bysort hhid_village: egen land_rate = median(agri_income_01/total_production_hectares)
gen land_cost = prod_hect_1 * land_rate

* fertilizer cost
gen fert_cost = fert_1 * q63_1

* equipment cost (using standard rental/depreciation)
gen equip_cost = number_mech_equip * 25000 // Standard equipment value

* calculate total costs and TFP
egen total_input_value = rowtotal(labor_cost land_cost fert_cost equip_cost)
gen tfp = value_prod_1/total_input_value

tempfile baseline_outcomes
save `baseline_outcomes'

* merge back into combined data
use `combined_data', clear
merge 1:1 hhid using `baseline_outcomes', keep(master match) nogen

save `combined_data', replace

* 1.1.7
* baseline self-reported months of soudure and reduced coping strategies index
* variables: food01, food02, food03, food05, food06, food07, food08, food09, food11, food12
use "$baseline_lean", clear

* Binary indicators rather than frequency
* Since we have yes/no responses for 12-month period rather than days/week
* Using standard severity weights but adjusted for binary responses:
*   - Less preferred food = 1
*   - Borrow food/help = 2
*   - Reduce portions = 1
*   - Restrict adult consumption = 3
*   - Reduce meals = 1

* create weighted binary component scores
gen baseline_rcsi_work = (food02==1) * 2     // Paid work (borrowing/help proxy)
gen baseline_rcsi_assets = (food03==1) * 3   // Sold assets (adult restriction proxy)
gen baseline_rcsi_migrate = (food11==1) * 1  // Migration (less preferred food proxy)
gen baseline_rcsi_skip = (food12==1) * 1     // Skip meals (reduce meals proxy)

* calculate modified annual rCSI score
egen baseline_rcsi_annual = rowtotal(baseline_rcsi_work baseline_rcsi_assets baseline_rcsi_migrate baseline_rcsi_skip)
label var baseline_rcsi_annual "Annual Reduced Coping Strategies Score"

* generate modified IPC Phase categories 
* Note: These thresholds are adapted for annual binary measures
gen baseline_ipc_phase = .
replace baseline_ipc_phase = 1 if baseline_rcsi_annual <= 1    // No/minimal coping
replace baseline_ipc_phase = 2 if baseline_rcsi_annual == 2    // Stress coping
replace baseline_ipc_phase = 3 if baseline_rcsi_annual == 3    // Crisis coping
replace baseline_ipc_phase = 4 if baseline_rcsi_annual >= 4    // Emergency coping
label define baseline_ipc 1 "Minimal" 2 "Stress" 3 "Crisis" 4 "Emergency"
label values baseline_ipc_phase baseline_ipc

* percentages by phase
tab baseline_ipc_phase, m

* baseline months soudure
rename food01 baseline_months_soudure
label var baseline_months_soudure "Self-reported months of lean season"

keep hhid baseline_rcsi_* baseline_ipc_phase baseline_months_soudure

tempfile baseline_outcomes
save `baseline_outcomes'

* merge back into combined data
use `combined_data', clear
merge 1:1 hhid using `baseline_outcomes', keep(master match) nogen

save `combined_data', replace

* 1.1.8
* baseline prevalence of schistosomaisis self-reported condition and symptoms
* variables: health_5_3, health_5_5, health_5_6, health_5_8, health_5_9	Individual level for child testing, household level for self-reported data	Individual level
use "$baseline_health", clear

* create binary indicators for each numbered variable
forvalues i = 1/55 {
    * Binary indicators for each symptom/condition
    cap gen health_5_3_2_`i'_bin = (health_5_3_2_`i' == 1)
    cap gen health_5_5_`i'_bin = (health_5_5_`i' == 1) 
    cap gen health_5_6_`i'_bin = (health_5_6_`i' == 1)
    cap gen health_5_8_`i'_bin = (health_5_8_`i' == 1)
    cap gen health_5_9_`i'_bin = (health_5_9_`i' == 1)
}

* collapse to household level - any member reporting
foreach symptom in health_5_3_2 health_5_5 health_5_6 health_5_8 health_5_9 {
    * Get max across household members
    egen hh_`symptom' = rowmax(`symptom'_*_bin)
    label var hh_`symptom' "Any HH member reporting `symptom'"
}

* composite indicator (any symptom)
egen baseline_schisto_symptoms = rowmax(hh_health_5_3_2 hh_health_5_5 hh_health_5_6 hh_health_5_8 hh_health_5_9)
label var baseline_schisto_symptoms "Any HH member reporting schisto symptoms"

* symptom count
egen baseline_schisto_count = rowtotal(hh_health_5_3_2 hh_health_5_5 hh_health_5_6 hh_health_5_8 hh_health_5_9)
label var baseline_schisto_count "Number of distinct schisto symptoms in HH"

* label variables
label var hh_health_5_3_2 "HH: Any member with bilharzia past 12mo"
label var hh_health_5_5 "HH: Any member received schisto meds past 12mo"
label var hh_health_5_6 "HH: Any member ever diagnosed with schisto"
label var hh_health_5_8 "HH: Any member with blood in urine past 12mo"
label var hh_health_5_9 "HH: Any member with blood in stool past 12mo"

* household-level measures
keep hhid hh_health_5_* baseline_schisto_symptoms baseline_schisto_count

tempfile baseline_outcomes
save `baseline_outcomes'

* merge back into combined data
use `combined_data', clear
merge 1:1 hhid using `baseline_outcomes', keep(master match) nogen

save `combined_data', replace

* 1.1.11
* Does promoting the private benefits of a common pool resource (aquatic vegetation) induce a change in beliefs about property rights?
* variables: beliefs_01, beliefs_02, beliefs_03, beliefs_04, beliefs_05, beliefs_06, beliefs_07, beliefs_08, beliefs_09
use "$baseline_beliefs", clear

* indices for different types of beliefs
* 1. Community Property Rights (beliefs_04, beliefs_05)
egen baseline_community_rights = rowmean(beliefs_04 beliefs_05)
label var baseline_community_rights "Baseline support for community property rights"

* 2. Private Use Rights (beliefs_06 - beliefs_09)
egen baseline_private_rights = rowmean(beliefs_06 beliefs_07 beliefs_08 beliefs_09)
label var baseline_private_rights "Baseline support for private use rights"

* 3. Disease Risk Perception (beliefs_01 - beliefs_03)
foreach var in beliefs_01 beliefs_02 beliefs_03 {
    * Exclude "currently affected" responses (code 6)
    replace `var' = . if `var' == 6
}
egen baseline_disease_risk = rowmean(beliefs_01 beliefs_02 beliefs_03)
label var baseline_disease_risk "Baseline perceived disease risk"

* variables for merge
keep hhid baseline_community_rights baseline_private_rights baseline_disease_risk

tempfile baseline_outcomes
save `baseline_outcomes'

use `combined_data', clear
merge 1:1 hhid using `baseline_outcomes', keep(master match) nogen

save `combined_data', replace

* 2.1.1
* baseline number of days of work or school lost due to ill health
* variables: health_5_4, hh_03, hh_04, hh_08, hh_09, hh_37, hh_38
* 2.1.1 Baseline work/school days lost due to illness
use "$baseline_health", clear

* handle work days lost (health_5_4)
forvalues i = 1/55 {
    cap gen health_5_4_`i'_days = health_5_4_`i'
    cap replace health_5_4_`i'_days = . if health_5_4_`i' < 0  // Clean negative values
    cap replace health_5_4_`i'_days = . if health_5_4_`i' > 31 // Cap at month maximum
}

* calc household total work days lost 
egen baseline_work_days_lost = rowtotal(health_5_4_*_days)
label var baseline_work_days_lost "Total HH work days lost to illness past month"

* merge in household roster for work/school info
merge 1:1 hhid using "$baseline_household", nogen

* work indicators for each HH member
forvalues i = 1/55 {
    * works in agriculture
    gen works_ag_`i' = (hh_03_`i' == 1)
    * any work hours (ag, trade, or wage work)
    egen total_work_hrs_`i' = rowtotal(hh_04_`i' hh_08_`i' hh_09_`i')
    gen is_worker_`i' = (total_work_hrs_`i' > 0)
}

* school absence indicators
forvalues i = 1/55 {
    * Missed week+ of school
    gen school_absence_`i' = (hh_37_`i' == 1)
    * Expected school days (from hh_38)
    gen expected_school_`i' = hh_38_`i' if hh_38_`i' >= 0 & hh_38_`i' <= 7
}

* Calculate household-level measures
* # of workers in household
egen baseline_num_workers = rowtotal(is_worker_*)
label var baseline_num_workers "Number of HH members who work"

* avg days lost per worker
gen baseline_days_per_worker = baseline_work_days_lost / baseline_num_workers
label var baseline_days_per_worker "Average work days lost per working HH member"

* school absence indicator
egen baseline_any_school_absence = anymatch(school_absence_*), values(1)
label var baseline_any_school_absence "Any child missed week+ of school due to illness"

keep hhid baseline_work_days_lost baseline_num_workers baseline_days_per_worker baseline_any_school_absence

tempfile baseline_outcomes
save `baseline_outcomes'

use `combined_data', clear
merge 1:1 hhid using `baseline_outcomes', keep(master match) nogen

save `combined_data', replace

* 2.1.2
* baseline highest completed grade, current school enrollment, self-reported school attendance
* variables: hh_26, hh_29, hh_30, hh_31, hh_32, hh_33, hh_34, hh_35, hh_36, hh_37, hh_38
use "$baseline_household", clear

* for each household member
forvalues i = 1/55 {
    * current enrollment (hh_32)
    gen enrolled_`i' = (hh_32_`i' == 1)
    
    * grade level (hh_35) - convert to years of education
    gen years_edu_`i' = .
    replace years_edu_`i' = hh_35_`i' if inrange(hh_35_`i', 1, 13)  // primary through Secondary
    replace years_edu_`i' = 14 if hh_35_`i' == 14  // University
    
    * attendance (hh_38) - days attended last week
    gen attendance_`i' = hh_38_`i' if inrange(hh_38_`i', 0, 7)
}

* hh level measures
* any school-aged children enrolled
egen baseline_any_enrolled = rowmax(enrolled_*)
label var baseline_any_enrolled "Any school-aged children enrolled"

* avg years of education for school-aged children
egen baseline_avg_years_edu = rowmean(years_edu_*)
label var baseline_avg_years_edu "Average years of education for school-aged children"

* Average attendance days last week
egen baseline_avg_attendance = rowmean(attendance_*)
label var baseline_avg_attendance "Average days attended school last week"

* already have school absence from illness
* baseline_any_school_absence previously created

* relevant variables
keep hhid baseline_any_enrolled baseline_avg_years_edu baseline_avg_attendance

tempfile baseline_outcomes
save `baseline_outcomes'

use `combined_data', clear
merge 1:1 hhid using `baseline_outcomes', keep(master match) nogen

save `combined_data', replace

**************************************************
* load and prepare midline outcome variables
**************************************************

* 1.1.1-1.1.3: AVR Outcomes
use "$midline_household", clear

* aggregate AVR indicators
ds hh_12_6*, has(type string)
foreach var of varlist `r(varlist)' {
    destring `var', replace force
}
egen rowtotal_hh_12_6 = rowtotal(hh_12_6*)
gen agg_hh_12_6 = rowtotal_hh_12_6 > 0

egen rowtotal_hh_14 = rowtotal(hh_14*)
gen agg_hh_14 = rowtotal_hh_14 > 0

ds hh_20_6*, has(type string)
foreach var of varlist `r(varlist)' {
    destring `var', replace force
}
egen rowtotal_hh_20_6 = rowtotal(hh_20_6*)
gen agg_hh_20_6 = rowtotal_hh_20_6 > 0

egen rowtotal_hh_22 = rowtotal(hh_22*)
gen agg_hh_22 = rowtotal_hh_22 > 0

* composite AVR indicator
gen midline_avr = (agg_hh_12_6 == 1 | agg_hh_14 == 1 | agg_hh_20_6 == 1 | agg_hh_22 == 1)
label var midline_avr "Midline AVR participation"

* 1.1.4-1.1.6: Compost Production
egen rowtotal_hh_15_2 = rowtotal(hh_15_2*)
gen agg_hh_15_2 = rowtotal_hh_15_2 > 0

egen rowtotal_hh_23_2 = rowtotal(hh_23_2*)
gen agg_hh_23_2 = rowtotal_hh_23_2 > 1

merge 1:1 hhid using "$midline_agriculture", nogen

ds agri_6_34_comp*, has(type numeric)
egen rowtotal_agri_6_34_comp = rowtotal(`r(varlist)')
gen agg_agri_6_34_comp = rowtotal_agri_6_34_comp > 0

ds agri_6_34*, has(type numeric)
egen rowtotal_agri_6_34 = rowtotal(`r(varlist)')
gen agg_agri_6_34 = rowtotal_agri_6_34 > 0

* composite compost indicator
gen midline_compost_production = (agg_hh_15_2 == 1 | agg_hh_23_2 == 1 | ///
    agg_agri_6_34_comp == 1 | agg_agri_6_34 == 1)
label var midline_compost_production "Midline compost production"

keep hhid midline_avr midline_compost_production
tempfile midline_outcomes
save `midline_outcomes'

* 1.1.7: Food Security
use "$midline_lean", clear

* weighted binary component scores
gen midline_rcsi_work = (food02==1) * 2     
gen midline_rcsi_assets = (food03==1) * 3   
gen midline_rcsi_migrate = (food11==1) * 1  
gen midline_rcsi_skip = (food12==1) * 1     

egen midline_rcsi_annual = rowtotal(midline_rcsi_work midline_rcsi_assets ///
    midline_rcsi_migrate midline_rcsi_skip)
label var midline_rcsi_annual "Midline Annual Reduced Coping Strategies Score"

gen midline_ipc_phase = .
replace midline_ipc_phase = 1 if midline_rcsi_annual <= 1
replace midline_ipc_phase = 2 if midline_rcsi_annual == 2
replace midline_ipc_phase = 3 if midline_rcsi_annual == 3
replace midline_ipc_phase = 4 if midline_rcsi_annual >= 4
label define midline_ipc 1 "Minimal" 2 "Stress" 3 "Crisis" 4 "Emergency"
label values midline_ipc_phase midline_ipc

rename food01 midline_months_soudure
label var midline_months_soudure "Midline self-reported months of lean season"

keep hhid midline_rcsi_* midline_ipc_phase midline_months_soudure
tempfile food_security
save `food_security'

* 1.1.8: Health Outcomes
use "$midline_health", clear

forvalues i = 1/55 {
    cap gen health_5_3_2_`i'_bin = (health_5_3_2_`i' == 1)
    cap gen health_5_5_`i'_bin = (health_5_5_`i' == 1) 
    cap gen health_5_6_`i'_bin = (health_5_6_`i' == 1)
    cap gen health_5_8_`i'_bin = (health_5_8_`i' == 1)
    cap gen health_5_9_`i'_bin = (health_5_9_`i' == 1)
}

foreach symptom in health_5_3_2 health_5_5 health_5_6 health_5_8 health_5_9 {
    egen hh_`symptom' = rowmax(`symptom'_*_bin)
}

egen midline_schisto_symptoms = rowmax(hh_health_5_3_2 hh_health_5_5 ///
    hh_health_5_6 hh_health_5_8 hh_health_5_9)
label var midline_schisto_symptoms "Midline: Any HH member reporting schisto symptoms"

egen midline_schisto_count = rowtotal(hh_health_5_3_2 hh_health_5_5 ///
    hh_health_5_6 hh_health_5_8 hh_health_5_9)
label var midline_schisto_count "Midline: Number of distinct schisto symptoms in HH"

keep hhid hh_health_5_* midline_schisto_*
tempfile health_outcomes
save `health_outcomes'

* 2.1.1: Work/School Days Lost
use "$midline_health", clear

forvalues i = 1/55 {
    cap gen health_5_4_`i'_days = health_5_4_`i'
    cap replace health_5_4_`i'_days = . if health_5_4_`i' < 0
    cap replace health_5_4_`i'_days = . if health_5_4_`i' > 31
}

egen midline_work_days_lost = rowtotal(health_5_4_*_days)
label var midline_work_days_lost "Total HH work days lost to illness past month"

merge 1:1 hhid using "$midline_household", nogen

forvalues i = 1/55 {
    gen works_ag_`i' = (hh_03_`i' == 1)
    egen total_work_hrs_`i' = rowtotal(hh_04_`i' hh_08_`i' hh_09_`i')
    gen is_worker_`i' = (total_work_hrs_`i' > 0)
}

egen midline_num_workers = rowtotal(is_worker_*)
label var midline_num_workers "Number of HH members who work"

gen midline_days_per_worker = midline_work_days_lost / midline_num_workers
label var midline_days_per_worker "Average work days lost per working HH member"

keep hhid midline_work_days_lost midline_num_workers midline_days_per_worker
tempfile work_outcomes
save `work_outcomes'

* merge all midline outcomes into combined dataset
use `combined_data', clear
foreach dataset in midline_outcomes food_security health_outcomes work_outcomes {
    merge 1:1 hhid using ``dataset'', keep(master match) nogen
}

save `combined_data', replace

* save final dataset to specifications folder
save "$specifications/baseline_to_midline_pap_specifications.dta", replace

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
