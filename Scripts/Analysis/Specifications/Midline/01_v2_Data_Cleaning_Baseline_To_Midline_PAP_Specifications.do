**************************************************
* DISES Baseline to Midline Specifications *
* File Created By: Alexander Mills *
* File Last Updated By: Alexander Mills *
* Updates Tracked on Git *
**************************************************

*** This Do File PROCESSES: PUT ALL SCRIPTS HERE***
*** This Do File CREATES: dataset for the PAP specifcaitons on baseline to midline data
						
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

* collapse to village level - any household using each source
    collapse (max) interior_tap public_tap neighbor_tap protected_well unprotected_well ///
        drill_hole tanker_service water_seller natural_source stream other_water, ///
        by(hhid_village)
    
* count total number of different water sources used in village
    egen num_water_access_points = rowtotal(interior_tap public_tap neighbor_tap ///
        protected_well unprotected_well drill_hole tanker_service water_seller ///
        natural_source stream other_water)
    
    keep hhid_village num_water_access_points
    
    tempfile village_water
    save `village_water'
restore

* merge village-level water access back to main data
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
label variable hh_gender_h "Household head gender (1 = male, 0 = female)"

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
* BASELINE
* load and prepare baseline outcome variables
**************************************************
use "$baseline_household", clear
merge 1:1 hhid using "$baseline_health", nogen
merge 1:1 hhid using "$baseline_agriculture", nogen
merge 1:1 hhid using "$baseline_income", nogen
merge 1:1 hhid using "$baseline_standard", nogen
merge 1:1 hhid using "$baseline_games", nogen
merge 1:1 hhid using "$baseline_enumerator", nogen
merge 1:1 hhid using "$baseline_beliefs", nogen	
merge m:1 hhid_village using "$baseline_community", nogen


******* 1.1.1, 1.1.2, 1.1.3 ************
* AVR Self-reported participation (extensive margin)
* water interaction for AVR (from hh_12_6: "Harvest aquatic vegetation" activity)
egen baseline_avr_water_any = anymatch(hh_12_6_*), values(1)
label var baseline_avr_water_any "Any HH member harvests vegetation (hh_12_6: water activities)"

* vegetation harvest (from hh_14: kg collected per week, 12mo avg)
egen baseline_avr_harvest_any = anymatch(hh_14_*), values(0/2000)
label var baseline_avr_harvest_any "Any HH member collected vegetation (hh_14: 12mo collection)"

* vegetation removal (from hh_20_6: "Harvest aquatic vegetation" purpose)
egen baseline_avr_removal_any = anymatch(hh_20_6_*), values(1)
label var baseline_avr_removal_any "Any HH member removes vegetation (hh_20_6: removal activities)"

* recent harvest (from hh_22: kg collected in last 7 days)
egen baseline_avr_recent_any = anymatch(hh_22_*), values(0/2000)
label var baseline_avr_recent_any "Any HH member collected vegetation (hh_22: last 7 days)"

* quantity harvested (intensive margin)
* 12-month average weekly harvest (from hh_14: kg/week)
egen baseline_avr_harvest_kg = rowtotal(hh_14_*)
label var baseline_avr_harvest_kg "Total HH vegetation harvest kg/week (hh_14: 12mo avg)"

* 7-day harvest (from hh_22: kg last week)
egen baseline_avr_recent_kg = rowtotal(hh_22_*)
label var baseline_avr_recent_kg "Total HH vegetation harvest kg (hh_22: last 7 days)"

******** 1.1.4, 1.1.5, 1.1.6 ***********
* fertilizer/compost use (Extensive Margin)
* use of fertilizer in agricultural activities (hh_15: selecting "2: Fertilizer")
drop hh_15_o*
egen baseline_fert_ag_any = anymatch(hh_15_*), values(2)
label var baseline_fert_ag_any "Any HH member using fertilizer (hh_15 = 2)"

* use of fertilizer in specified activities (hh_23_2)
egen baseline_fert_specific_any = anymatch(hh_23_2*), values(1)
label var baseline_fert_specific_any "Any HH member using fertilizer (hh_23_2 = 1)"

* use of compost on plots (agri_6_34_comp)
egen baseline_compost_any = anymatch(agri_6_34_comp*), values(1)
label var baseline_compost_any "Any plot with compost use (agri_6_34_comp)"

* use of household waste on plots (agri_6_34)
egen baseline_waste_any = anymatch(agri_6_34*), values(1)
label var baseline_waste_any "Any plot with household waste use (agri_6_34)"

* count measures (Intensive Margin)
* create temporary indicators for fertilizer use
forvalues i = 1/55 {
    gen temp_fert_base_`i' = (hh_15_`i' == 2)
    gen temp_fert_mid_`i' = (hh_15_`i' == 2)
}

* num of HH members using fertilizer
egen baseline_fert_ag_count = rowtotal(temp_fert_base_*)
label var baseline_fert_ag_count "Number of HH members using fertilizer (hh_15 = 2)"

* dorp temps
drop temp_fert_*

* number of plots using different inputs
* create temporary indicators for compost and waste
forvalues i = 1/11 {
    cap gen temp_compost_base_`i' = (agri_6_34_comp_`i' == 1)
    cap gen temp_compost_mid_`i' = (agri_6_34_comp_`i' == 1)
    cap gen temp_waste_base_`i' = (agri_6_34_`i' == 1)
    cap gen temp_waste_mid_`i' = (agri_6_34_`i' == 1)
}

egen baseline_compost_plots = rowtotal(temp_compost_base_*)
egen baseline_waste_plots = rowtotal(temp_waste_base_*)

label var baseline_compost_plots "Number of plots using compost (agri_6_34_comp)"
label var baseline_waste_plots "Number of plots using household waste (agri_6_34)"

* drop temps
drop temp_*

* relevant variables and merge
keep hhid ///
	baseline_avr_water_any baseline_avr_harvest_any baseline_avr_removal_any 	baseline_avr_recent_any ///
    baseline_avr_harvest_kg baseline_avr_recent_kg ///
    baseline_fert_ag_any ///
    baseline_fert_specific_any  ///
    baseline_compost_any  ///
    baseline_waste_any  ///
    baseline_fert_ag_count  ///
    baseline_compost_plots  ///
    baseline_waste_plots 

tempfile compost_outcomes
save `compost_outcomes'

use `combined_data', clear 
merge 1:1 hhid using `compost_outcomes', keep(master match) nogen

save `combined_data', replace

******** 1.1.6 **********
* this is the tfp come back to this once molly has the production functions finished

******* 1.1.7 ***********
* baseline self-reported months of soudure and reduced coping strategies index
* variables: food01, food02, food03, food05, food06, food07, food08, food09, food11, food12
use "$baseline_lean", clear

* binary indicators rather than frequency
* since we have yes/no responses for 12-month period rather than days/week
* using standard severity weights but adjusted for binary responses:
*   - less preferred food = 1
*   - borrow food/help = 2
*   - reduce portions = 1
*   - restrict adult consumption = 3
*   - reduce meals = 1

* create weighted binary component scores
gen baseline_rcsi_work = (food02==1) * 2     // Paid work (borrowing/help proxy)
gen baseline_rcsi_assets = (food03==1) * 3   // Sold assets (adult restriction proxy)
gen baseline_rcsi_migrate = (food11==1) * 1  // Migration (less preferred food proxy)
gen baseline_rcsi_skip = (food12==1) * 1     // Skip meals (reduce meals proxy)

* calculate modified annual rCSI score
egen baseline_rcsi_annual = rowtotal(baseline_rcsi_work baseline_rcsi_assets baseline_rcsi_migrate baseline_rcsi_skip)
label var baseline_rcsi_annual "Annual Reduced Coping Strategies Score"

* generate modified IPC Phase categories 
* Note: these thresholds are adapted for annual binary measures
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

********** 1.1.8 *********
* baseline prevalence of schistosomaisis self-reported condition and symptoms
* variables: health_5_3, health_5_5, health_5_6, health_5_8, health_5_9	Individual level for child testing, household level for self-reported data	Individual level
use "$baseline_health", clear

* individ-level prevalence (extensive margin)
forvalues i = 1/55 {
    * bilharzia diagnosis (health_5_3_2: past 12 months)
    cap gen bilharzia_`i' = (health_5_3_2_`i' == 1)
    
    * meds (health_5_5: received schisto meds)
    cap gen schisto_meds_`i' = (health_5_5_`i' == 1)
    
    * diagnosis history (health_5_6: ever diagnosed)
    cap gen ever_diagnosed_`i' = (health_5_6_`i' == 1)
    
    * symptoms (health_5_8, health_5_9: blood in urine/stool)
    cap gen blood_urine_`i' = (health_5_8_`i' == 1)
    cap gen blood_stool_`i' = (health_5_9_`i' == 1)
}

* hh-level measures
* any member with condition/symptom
egen baseline_bilharzia_any = anymatch(bilharzia_*), values(1)
label var baseline_bilharzia_any "Any HH member with bilharzia (health_5_3_2: 12mo)"

egen baseline_meds_any = anymatch(schisto_meds_*), values(1)
label var baseline_meds_any "Any HH member received schisto meds (health_5_5)"

egen baseline_diagnosed_any = anymatch(ever_diagnosed_*), values(1)
label var baseline_diagnosed_any "Any HH member ever diagnosed (health_5_6)"

egen baseline_urine_any = anymatch(blood_urine_*), values(1)
label var baseline_urine_any "Any HH member with blood in urine (health_5_8)"

egen baseline_stool_any = anymatch(blood_stool_*), values(1)
label var baseline_stool_any "Any HH member with blood in stool (health_5_9)"

* count measures (intensive margin)
* num of members with condition/symptom
egen baseline_bilharzia_count = rowtotal(bilharzia_*)
label var baseline_bilharzia_count "Number of HH members with bilharzia (health_5_3_2)"

egen baseline_meds_count = rowtotal(schisto_meds_*)
label var baseline_meds_count "Number of HH members receiving meds (health_5_5)"

egen baseline_diagnosed_count = rowtotal(ever_diagnosed_*)
label var baseline_diagnosed_count "Number of HH members ever diagnosed (health_5_6)"

egen baseline_urine_count = rowtotal(blood_urine_*)
label var baseline_urine_count "Number of HH members with blood in urine (health_5_8)"

egen baseline_stool_count = rowtotal(blood_stool_*)
label var baseline_stool_count "Number of HH members with blood in stool (health_5_9)"

// keep only the created variables and identifier
keep hhid ///
    baseline_bilharzia_any baseline_meds_any baseline_diagnosed_any baseline_urine_any baseline_stool_any ///
    baseline_bilharzia_count baseline_meds_count baseline_diagnosed_count baseline_urine_count baseline_stool_count

* tempfile
tempfile schisto_outcomes
save `schisto_outcomes'

* merge back
use `combined_data', clear
merge 1:1 hhid using `schisto_outcomes', keep(master match) nogen

save `combined_data', replace

********* 1.1.11 **********
* Does promoting the private benefits of a common pool resource (aquatic vegetation) induce a change in beliefs about property rights?
* variables: beliefs_01, beliefs_02, beliefs_03, beliefs_04, beliefs_05, beliefs_06, beliefs_07, beliefs_08, beliefs_09
use "$baseline_beliefs", clear

* 1. disesase risk beliefs (beliefs_01-03)
* personal risk (59.38% agree/strongly agree)
gen baseline_personal_risk = (beliefs_01 <= 2)
label var baseline_personal_risk "Likely/Very likely to get bilharzia (beliefs_01 <= 2)"

* household risk (65.58% agree/strongly agree)
gen baseline_hh_risk = (beliefs_02 <= 2)
label var baseline_hh_risk "Likely/Very likely HH member gets bilharzia (beliefs_02 <= 2)"

* child risk (76.97% agree/strongly agree)
gen baseline_child_risk = (beliefs_03 <= 2)
label var baseline_child_risk "Likely/Very likely child gets bilharzia (beliefs_03 <= 2)"

* 2. community property rights (beliefs_04-05)
* community land rights (85.38% agree/strongly agree)
gen baseline_comm_land = (beliefs_04 <= 2)
label var baseline_comm_land "Agree: land belongs to community (beliefs_04 <= 2)"

* community water rights (90.43% agree/strongly agree)
gen baseline_comm_water = (beliefs_05 <= 2)
label var baseline_comm_water "Agree: water belongs to community (beliefs_05 <= 2)"

* 3. private Use Rights (beliefs_06-09)
* private land use rights (90.82% agree/strongly agree)
gen baseline_private_land = (beliefs_06 <= 2)
label var baseline_private_land "Agree: right to products from own land (beliefs_06 <= 2)"

* community land use rights (67.50% agree/strongly agree)
gen baseline_comm_land_use = (beliefs_07 <= 2)
label var baseline_comm_land_use "Agree: right to products from community land (beliefs_07 <= 2)"

* fishing rights (83.46% agree/strongly agree)
gen baseline_comm_fish = (beliefs_08 <= 2)
label var baseline_comm_fish "Agree: right to products from fishing (beliefs_08 <= 2)"

* harvesting rights (77.40% agree/strongly agree)
gen baseline_comm_harvest = (beliefs_09 <= 2)
label var baseline_comm_harvest "Agree: right to products from harvesting (beliefs_09 <= 2)"

* only created belief variables and identifier
keep hhid ///
    baseline_personal_risk  ///
    baseline_hh_risk  ///
    baseline_child_risk  ///
    baseline_comm_land  ///
    baseline_comm_water  ///
    baseline_private_land  ///
    baseline_comm_land_use  ///
    baseline_comm_fish  ///
    baseline_comm_harvest 

* tempfile
tempfile belief_outcomes
save `belief_outcomes'

* back into combined data
use `combined_data', clear
merge 1:1 hhid using `belief_outcomes', keep(master match) nogen

save `combined_data', replace

******** 2.1.1 *********
* baseline number of days of work or school lost due to ill health
* variables: health_5_4, hh_03, hh_04, hh_08, hh_09, hh_37, hh_38
* 2.1.1 Baseline work/school days lost due to illness
use "$baseline_health", clear
* merge in household roster for work/school info
merge 1:1 hhid using "$baseline_household", nogen

* 1. work loss measures
* Days lost to illness (health_5_4)
forvalues i = 1/55 {
    cap gen health_5_4_`i'_days = health_5_4_`i'
    cap replace health_5_4_`i'_days = . if health_5_4_`i' < 0
    cap replace health_5_4_`i'_days = . if health_5_4_`i' > 31
}

* work participation by type
forvalues i = 1/55 {
    * ag work (hh_03, hh_04)
    gen baseline_ag_work_any_`i' = (hh_03_`i' == 1)
    gen baseline_ag_hours_`i' = hh_04_`i'
    label var baseline_ag_hours_`i' "Agricultural work hours (hh_04)"
    
    * trade work (hh_08)
    gen baseline_trade_hours_`i' = hh_08_`i'
    label var baseline_trade_hours_`i' "Trade work hours (hh_08)"
    
    * wage work (hh_09)
    gen baseline_wage_hours_`i' = hh_09_`i'
    label var baseline_wage_hours_`i' "Wage work hours (hh_09)"
}

* hh-level work measures
* total days lost
egen baseline_work_days_lost = rowtotal(health_5_4_*_days)
label var baseline_work_days_lost "Total work days lost to illness (health_5_4)"

* ag participation
egen baseline_ag_workers = rowtotal(baseline_ag_work_any_*)
label var baseline_ag_workers "Number of agricultural workers (hh_03)"

* Hours by type
egen baseline_total_ag_hours = rowtotal(baseline_ag_hours_*)
egen baseline_total_trade_hours = rowtotal(baseline_trade_hours_*)
egen baseline_total_wage_hours = rowtotal(baseline_wage_hours_*)
label var baseline_total_ag_hours "Total HH agricultural hours (hh_04)"
label var baseline_total_trade_hours "Total HH trade hours (hh_08)"
label var baseline_total_wage_hours "Total HH wage hours (hh_09)"

* 2. school loss measures
forvalues i = 1/55 {
    * school absence (hh_37)
    gen baseline_school_absence_`i' = (hh_37_`i' == 1)
    label var baseline_school_absence_`i' "Missed week+ school due illness (hh_37)"
    
    * school attendance (hh_38)
    gen baseline_school_days_`i' = hh_38_`i' if inrange(hh_38_`i', 0, 7)
    label var baseline_school_days_`i' "Days attended school last week (hh_38)"
}

* hh-level school measures
* any child missing school
egen baseline_any_absence = anymatch(baseline_school_absence_*), values(1)
label var baseline_any_absence "Any child missed week+ school (hh_37)"

* avg attendance
egen baseline_avg_attendance = rowmean(baseline_school_days_*)
label var baseline_avg_attendance "Average school days attended (hh_38)"

* count of children missing school
egen baseline_absence_count = rowtotal(baseline_school_absence_*)
label var baseline_absence_count "Number of children missing school (hh_37)"

* relevant variables
keep hhid baseline_work_days_lost baseline_ag_workers ///
    baseline_total_ag_hours baseline_total_trade_hours baseline_total_wage_hours ///
    baseline_any_absence baseline_avg_attendance baseline_absence_count

tempfile work_school_outcomes
save `work_school_outcomes'

* back into combined data
use `combined_data', clear
merge 1:1 hhid using `work_school_outcomes', keep(master match) nogen

save `combined_data', replace

********** 2.1.2 **********
* baseline highest completed grade, current school enrollment, self-reported school attendance
* variables: hh_26, hh_29, hh_30, hh_31, hh_32, hh_33, hh_34, hh_35, hh_36, hh_37, hh_38
* Education Outcomes
use "$baseline_household", clear

* 1. educ attainment (hh_29)
forvalues i = 1/55 {
    * years of education completed
    gen edu_years_`i' = 0 if hh_29_`i' == 0  // No education
    replace edu_years_`i' = hh_29_`i' if inrange(hh_29_`i', 1, 13)
    replace edu_years_`i' = 14 if hh_29_`i' == 14 // University
}

* highest grade completed in household
egen baseline_max_grade = rowmax(edu_years_*)
label var baseline_max_grade "Highest grade completed in HH (hh_29)"

* 2. school participation - extensive margin
forvalues i = 1/55 {
    * current enrollment (hh_32)
    gen enrolled_`i' = (hh_32_`i' == 1) if !missing(hh_32_`i')
    
    * last year attendance (hh_30) 
    gen last_year_`i' = (hh_30_`i' == 1) if !missing(hh_30_`i')
}

* enrollment measures
egen baseline_any_enrolled = anymatch(enrolled_*), values(1)
label var baseline_any_enrolled "Any member currently enrolled (hh_32)"

egen baseline_num_enrolled = rowtotal(enrolled_*)
label var baseline_num_enrolled "Number currently enrolled"

egen baseline_any_last_year = anymatch(last_year_*), values(1)
label var baseline_any_last_year "Any member attended last year (hh_30)"

* 3. school participation - intensive margin (hh_38)
forvalues i = 1/55 {
    gen attend_days_`i' = hh_38_`i' if inrange(hh_38_`i', 0, 7)
}

* attendance measures 
egen baseline_avg_attendance = rowmean(attend_days_*)
label var baseline_avg_attendance "Average days attended last week (hh_38)"

egen baseline_full_attend = anymatch(attend_days_*), values(7)
label var baseline_full_attend "Any member perfect attendance"

* keep educ outcomes
keep hhid baseline_max_grade baseline_any_enrolled baseline_num_enrolled ///
    baseline_any_last_year baseline_avg_attendance baseline_full_attend


* tempfile
tempfile education_outcomes
save `education_outcomes'

* back into combined data
use `combined_data', clear
merge 1:1 hhid using `education_outcomes', keep(master match) nogen

save `combined_data', replace

**************************************************
* MIDLINE
* load and prepare midline outcome variables
**************************************************
use "$midline_household", clear
merge 1:1 hhid using "$midline_health", nogen
merge 1:1 hhid using "$midline_agriculture", nogen
merge 1:1 hhid using "$midline_income", nogen
merge 1:1 hhid using "$midline_standard", nogen
* merge 1:1 hhid using "$midline_games", nogen
merge 1:1 hhid using "$midline_enumerator", nogen
merge 1:1 hhid using "$midline_beliefs", nogen	
merge m:1 hhid_village using "$midline_community", nogen


******* 1.1.1, 1.1.2, 1.1.3 ************
* AVR Self-reported participation (extensive margin)
* water interaction for AVR (from hh_12_6: "Harvest aquatic vegetation" activity)
egen midline_avr_water_any = anymatch(hh_12_6_*), values(1)
label var midline_avr_water_any "Any HH member harvests vegetation (hh_12_6: water activities)"

* vegetation harvest (from hh_14: kg collected per week, 12mo avg)
egen midline_avr_harvest_any = anymatch(hh_14_*), values(0/2000)
label var midline_avr_harvest_any "Any HH member collected vegetation (hh_14: 12mo collection)"

* vegetation removal (from hh_20_6: "Harvest aquatic vegetation" purpose)
egen midline_avr_removal_any = anymatch(hh_20_6_*), values(1)
label var midline_avr_removal_any "Any HH member removes vegetation (hh_20_6: removal activities)"

* recent harvest (from hh_22: kg collected in last 7 days)
egen midline_avr_recent_any = anymatch(hh_22_*), values(0/2000)
label var midline_avr_recent_any "Any HH member collected vegetation (hh_22: last 7 days)"

* quantity harvested (intensive margin)
* 12-month average weekly harvest (from hh_14: kg/week)
egen midline_avr_harvest_kg = rowtotal(hh_14_*)
label var midline_avr_harvest_kg "Total HH vegetation harvest kg/week (hh_14: 12mo avg)"

* 7-day harvest (from hh_22: kg last week)
egen midline_avr_recent_kg = rowtotal(hh_22_*)
label var midline_avr_recent_kg "Total HH vegetation harvest kg (hh_22: last 7 days)"

******** 1.1.4, 1.1.5, 1.1.6 ***********
* fertilizer/compost use (Extensive Margin)
* use of fertilizer in agricultural activities (hh_15: selecting "2: Fertilizer")
drop hh_15_o*
egen midline_fert_ag_any = anymatch(hh_15_*), values(2)
label var midline_fert_ag_any "Any HH member using fertilizer (hh_15 = 2)"

* use of fertilizer in specified activities (hh_23_2)
egen midline_fert_specific_any = anymatch(hh_23_2*), values(1)
label var midline_fert_specific_any "Any HH member using fertilizer (hh_23_2 = 1)"

* use of compost on plots (agri_6_34_comp)
egen midline_compost_any = anymatch(agri_6_34_comp*), values(1)
label var midline_compost_any "Any plot with compost use (agri_6_34_comp)"

* use of household waste on plots (agri_6_34)
egen midline_waste_any = anymatch(agri_6_34*), values(1)
label var midline_waste_any "Any plot with household waste use (agri_6_34)"

* count measures (Intensive Margin)
* create temporary indicators for fertilizer use
forvalues i = 1/57 {
    gen temp_fert_base_`i' = (hh_15_`i' == 2)
    gen temp_fert_mid_`i' = (hh_15_`i' == 2)
}

* num of HH members using fertilizer
egen midline_fert_ag_count = rowtotal(temp_fert_base_*)
label var midline_fert_ag_count "Number of HH members using fertilizer (hh_15 = 2)"

* dorp temps
drop temp_fert_*

* number of plots using different inputs
* create temporary indicators for compost and waste
forvalues i = 1/11 {
    cap gen temp_compost_base_`i' = (agri_6_34_comp_`i' == 1)
    cap gen temp_compost_mid_`i' = (agri_6_34_comp_`i' == 1)
    cap gen temp_waste_base_`i' = (agri_6_34_`i' == 1)
    cap gen temp_waste_mid_`i' = (agri_6_34_`i' == 1)
}

egen midline_compost_plots = rowtotal(temp_compost_base_*)
egen midline_waste_plots = rowtotal(temp_waste_base_*)

label var midline_compost_plots "Number of plots using compost (agri_6_34_comp)"
label var midline_waste_plots "Number of plots using household waste (agri_6_34)"

* drop temps
drop temp_*

* relevant variables and merge
keep hhid ///
	midline_avr_water_any midline_avr_harvest_any midline_avr_removal_any 	midline_avr_recent_any ///
    midline_avr_harvest_kg midline_avr_recent_kg ///
    midline_fert_ag_any ///
    midline_fert_specific_any  ///
    midline_compost_any  ///
    midline_waste_any  ///
    midline_fert_ag_count  ///
    midline_compost_plots  ///
    midline_waste_plots 

tempfile compost_outcomes
save `compost_outcomes'

use `combined_data', clear 
merge 1:1 hhid using `compost_outcomes', keep(master match) nogen

save `combined_data', replace

******** 1.1.6 **********
* this is the tfp come back to this once molly has the production functions finished

******* 1.1.7 ***********
* midline self-reported months of soudure and reduced coping strategies index
* variables: food01, food02, food03, food05, food06, food07, food08, food09, food11, food12
use "$midline_lean", clear

* binary indicators rather than frequency
* since we have yes/no responses for 12-month period rather than days/week
* using standard severity weights but adjusted for binary responses:
*   - less preferred food = 1
*   - borrow food/help = 2
*   - reduce portions = 1
*   - restrict adult consumption = 3
*   - reduce meals = 1

* create weighted binary component scores
gen midline_rcsi_work = (food02==1) * 2     // Paid work (borrowing/help proxy)
gen midline_rcsi_assets = (food03==1) * 3   // Sold assets (adult restriction proxy)
gen midline_rcsi_migrate = (food11==1) * 1  // Migration (less preferred food proxy)
gen midline_rcsi_skip = (food12==1) * 1     // Skip meals (reduce meals proxy)

* calculate modified annual rCSI score
egen midline_rcsi_annual = rowtotal(midline_rcsi_work midline_rcsi_assets midline_rcsi_migrate midline_rcsi_skip)
label var midline_rcsi_annual "Annual Reduced Coping Strategies Score"

* generate modified IPC Phase categories 
* Note: these thresholds are adapted for annual binary measures
gen midline_ipc_phase = .
replace midline_ipc_phase = 1 if midline_rcsi_annual <= 1    // No/minimal coping
replace midline_ipc_phase = 2 if midline_rcsi_annual == 2    // Stress coping
replace midline_ipc_phase = 3 if midline_rcsi_annual == 3    // Crisis coping
replace midline_ipc_phase = 4 if midline_rcsi_annual >= 4    // Emergency coping
label define midline_ipc 1 "Minimal" 2 "Stress" 3 "Crisis" 4 "Emergency"
label values midline_ipc_phase midline_ipc

* percentages by phase
tab midline_ipc_phase, m

* midline months soudure
rename food01 midline_months_soudure
label var midline_months_soudure "Self-reported months of lean season"

keep hhid midline_rcsi_* midline_ipc_phase midline_months_soudure

tempfile midline_outcomes
save `midline_outcomes'

* merge back into combined data
use `combined_data', clear
merge 1:1 hhid using `midline_outcomes', keep(master match) nogen

save `combined_data', replace

********** 1.1.8 *********
* midline prevalence of schistosomaisis self-reported condition and symptoms
* variables: health_5_3, health_5_5, health_5_6, health_5_8, health_5_9	Individual level for child testing, household level for self-reported data	Individual level
use "$midline_health", clear

* individ-level prevalence (extensive margin)
forvalues i = 1/57 {
    * bilharzia diagnosis (health_5_3_2: past 12 months)
    cap gen bilharzia_`i' = (health_5_3_2_`i' == 1)
    
    * meds (health_5_5: received schisto meds)
    cap gen schisto_meds_`i' = (health_5_5_`i' == 1)
    
    * diagnosis history (health_5_6: ever diagnosed)
    cap gen ever_diagnosed_`i' = (health_5_6_`i' == 1)
    
    * symptoms (health_5_8, health_5_9: blood in urine/stool)
    cap gen blood_urine_`i' = (health_5_8_`i' == 1)
    cap gen blood_stool_`i' = (health_5_9_`i' == 1)
}

* hh-level measures
* any member with condition/symptom
egen midline_bilharzia_any = anymatch(bilharzia_*), values(1)
label var midline_bilharzia_any "Any HH member with bilharzia (health_5_3_2: 12mo)"

egen midline_meds_any = anymatch(schisto_meds_*), values(1)
label var midline_meds_any "Any HH member received schisto meds (health_5_5)"

egen midline_diagnosed_any = anymatch(ever_diagnosed_*), values(1)
label var midline_diagnosed_any "Any HH member ever diagnosed (health_5_6)"

egen midline_urine_any = anymatch(blood_urine_*), values(1)
label var midline_urine_any "Any HH member with blood in urine (health_5_8)"

egen midline_stool_any = anymatch(blood_stool_*), values(1)
label var midline_stool_any "Any HH member with blood in stool (health_5_9)"

* count measures (intensive margin)
* num of members with condition/symptom
egen midline_bilharzia_count = rowtotal(bilharzia_*)
label var midline_bilharzia_count "Number of HH members with bilharzia (health_5_3_2)"

egen midline_meds_count = rowtotal(schisto_meds_*)
label var midline_meds_count "Number of HH members receiving meds (health_5_5)"

egen midline_diagnosed_count = rowtotal(ever_diagnosed_*)
label var midline_diagnosed_count "Number of HH members ever diagnosed (health_5_6)"

egen midline_urine_count = rowtotal(blood_urine_*)
label var midline_urine_count "Number of HH members with blood in urine (health_5_8)"

egen midline_stool_count = rowtotal(blood_stool_*)
label var midline_stool_count "Number of HH members with blood in stool (health_5_9)"

// keep only the created variables and identifier
keep hhid ///
    midline_bilharzia_any midline_meds_any midline_diagnosed_any midline_urine_any midline_stool_any ///
    midline_bilharzia_count midline_meds_count midline_diagnosed_count midline_urine_count midline_stool_count

* tempfile
tempfile schisto_outcomes
save `schisto_outcomes'

* merge back
use `combined_data', clear
merge 1:1 hhid using `schisto_outcomes', keep(master match) nogen

save `combined_data', replace

********* 1.1.11 **********
* Does promoting the private benefits of a common pool resource (aquatic vegetation) induce a change in beliefs about property rights?
* variables: beliefs_01, beliefs_02, beliefs_03, beliefs_04, beliefs_05, beliefs_06, beliefs_07, beliefs_08, beliefs_09
use "$midline_beliefs", clear

* 1. disesase risk beliefs (beliefs_01-03)
* personal risk 
gen midline_personal_risk = (beliefs_01 <= 2)
label var midline_personal_risk "Likely/Very likely to get bilharzia (beliefs_01 <= 2)"

* household risk
gen midline_hh_risk = (beliefs_02 <= 2)
label var midline_hh_risk "Likely/Very likely HH member gets bilharzia (beliefs_02 <= 2)"

* child risk
gen midline_child_risk = (beliefs_03 <= 2)
label var midline_child_risk "Likely/Very likely child gets bilharzia (beliefs_03 <= 2)"

* 2. community property rights (beliefs_04-05)
* community land rights
gen midline_comm_land = (beliefs_04 <= 2)
label var midline_comm_land "Agree: land belongs to community (beliefs_04 <= 2)"

* community water rights
gen midline_comm_water = (beliefs_05 <= 2)
label var midline_comm_water "Agree: water belongs to community (beliefs_05 <= 2)"

* 3. private Use Rights (beliefs_06-09)
* private land use rights 
gen midline_private_land = (beliefs_06 <= 2)
label var midline_private_land "Agree: right to products from own land (beliefs_06 <= 2)"

* community land use rights
gen midline_comm_land_use = (beliefs_07 <= 2)
label var midline_comm_land_use "Agree: right to products from community land (beliefs_07 <= 2)"

* fishing rights 
gen midline_comm_fish = (beliefs_08 <= 2)
label var midline_comm_fish "Agree: right to products from fishing (beliefs_08 <= 2)"

* harvesting rights 
gen midline_comm_harvest = (beliefs_09 <= 2)
label var midline_comm_harvest "Agree: right to products from harvesting (beliefs_09 <= 2)"

* only created belief variables and identifier
keep hhid ///
    midline_personal_risk  ///
    midline_hh_risk  ///
    midline_child_risk  ///
    midline_comm_land  ///
    midline_comm_water  ///
    midline_private_land  ///
    midline_comm_land_use  ///
    midline_comm_fish  ///
    midline_comm_harvest 

* tempfile
tempfile belief_outcomes
save `belief_outcomes'

* back into combined data
use `combined_data', clear
merge 1:1 hhid using `belief_outcomes', keep(master match) nogen

save `combined_data', replace

******** 2.1.1 *********
* midline number of days of work or school lost due to ill health
* variables: health_5_4, hh_03, hh_04, hh_08, hh_09, hh_37, hh_38
* 2.1.1 midline work/school days lost due to illness
use "$midline_health", clear
* merge in household roster for work/school info
merge 1:1 hhid using "$midline_household", nogen

* 1. work loss measures
* Days lost to illness (health_5_4)
forvalues i = 1/57 {
    cap gen health_5_4_`i'_days = health_5_4_`i'
    cap replace health_5_4_`i'_days = . if health_5_4_`i' < 0
    cap replace health_5_4_`i'_days = . if health_5_4_`i' > 31
}

* work participation by type
forvalues i = 1/57 {
    * ag work (hh_03, hh_04)
    gen midline_ag_work_any_`i' = (hh_03_`i' == 1)
    gen midline_ag_hours_`i' = hh_04_`i'
    label var midline_ag_hours_`i' "Agricultural work hours (hh_04)"
    
    * trade work (hh_08)
    gen midline_trade_hours_`i' = hh_08_`i'
    label var midline_trade_hours_`i' "Trade work hours (hh_08)"
    
    * wage work (hh_09)
    gen midline_wage_hours_`i' = hh_09_`i'
    label var midline_wage_hours_`i' "Wage work hours (hh_09)"
}

* hh-level work measures
* total days lost
egen midline_work_days_lost = rowtotal(health_5_4_*_days)
label var midline_work_days_lost "Total work days lost to illness (health_5_4)"

* ag participation
egen midline_ag_workers = rowtotal(midline_ag_work_any_*)
label var midline_ag_workers "Number of agricultural workers (hh_03)"

* Hours by type
egen midline_total_ag_hours = rowtotal(midline_ag_hours_*)
egen midline_total_trade_hours = rowtotal(midline_trade_hours_*)
egen midline_total_wage_hours = rowtotal(midline_wage_hours_*)
label var midline_total_ag_hours "Total HH agricultural hours (hh_04)"
label var midline_total_trade_hours "Total HH trade hours (hh_08)"
label var midline_total_wage_hours "Total HH wage hours (hh_09)"

* 2. school loss measures
forvalues i = 1/57 {
    * school absence (hh_37)
    gen midline_school_absence_`i' = (hh_37_`i' == 1)
    label var midline_school_absence_`i' "Missed week+ school due illness (hh_37)"
    
    * school attendance (hh_38)
    gen midline_school_days_`i' = hh_38_`i' if inrange(hh_38_`i', 0, 7)
    label var midline_school_days_`i' "Days attended school last week (hh_38)"
}

* hh-level school measures
* any child missing school
egen midline_any_absence = anymatch(midline_school_absence_*), values(1)
label var midline_any_absence "Any child missed week+ school (hh_37)"

* avg attendance
egen midline_avg_attendance = rowmean(midline_school_days_*)
label var midline_avg_attendance "Average school days attended (hh_38)"

* count of children missing school
egen midline_absence_count = rowtotal(midline_school_absence_*)
label var midline_absence_count "Number of children missing school (hh_37)"

* relevant variables
keep hhid midline_work_days_lost midline_ag_workers ///
    midline_total_ag_hours midline_total_trade_hours midline_total_wage_hours ///
    midline_any_absence midline_avg_attendance midline_absence_count

tempfile work_school_outcomes
save `work_school_outcomes'

* back into combined data
use `combined_data', clear
merge 1:1 hhid using `work_school_outcomes', keep(master match) nogen

save `combined_data', replace

********** 2.1.2 **********
* midline highest completed grade, current school enrollment, self-reported school attendance
* variables: hh_26, hh_29, hh_30, hh_31, hh_32, hh_33, hh_34, hh_35, hh_36, hh_37, hh_38
* Education Outcomes
use "$midline_household", clear

* 1. education attainment 
forvalues i = 1/57 {
    * for non-enrolled: use completed education (hh_29)
    gen edu_years_`i' = 0 if hh_29_`i' == 0  
    replace edu_years_`i' = hh_29_`i' if inrange(hh_29_`i', 1, 13)
    replace edu_years_`i' = 14 if hh_29_`i' == 14
    
    * for currently enrolled: use current grade (hh_35)
    replace edu_years_`i' = hh_35_`i' if hh_32_`i' == 1 & inrange(hh_35_`i', 1, 14)
}

* highest grade in household
egen midline_max_grade = rowmax(edu_years_*)
label var midline_max_grade "Highest grade completed/current in HH (hh_29/hh_35)"

* 2. school participation - extensive margin
forvalues i = 1/57 {
    * current enrollment (hh_32)
    gen enrolled_`i' = (hh_32_`i' == 1) if !missing(hh_32_`i')
    
    * last year attendance (hh_30) 
    gen last_year_`i' = (hh_30_`i' == 1) if !missing(hh_30_`i')
}

* enrollment measures
egen midline_any_enrolled = anymatch(enrolled_*), values(1)
label var midline_any_enrolled "Any member currently enrolled (hh_32)"

egen midline_num_enrolled = rowtotal(enrolled_*)
label var midline_num_enrolled "Number currently enrolled"

egen midline_any_last_year = anymatch(last_year_*), values(1)
label var midline_any_last_year "Any member attended last year (hh_30)"

* 3. school participation - intensive margin (hh_38)
forvalues i = 1/57 {
    gen attend_days_`i' = hh_38_`i' if inrange(hh_38_`i', 0, 7)
}

* attendance measures 
egen midline_avg_attendance = rowmean(attend_days_*)
label var midline_avg_attendance "Average days attended last week (hh_38)"

egen midline_full_attend = anymatch(attend_days_*), values(7)
label var midline_full_attend "Any member perfect attendance"

* keep educ outcomes
keep hhid midline_max_grade midline_any_enrolled midline_num_enrolled ///
    midline_any_last_year midline_avg_attendance midline_full_attend


* tempfile
tempfile education_outcomes
save `education_outcomes'

* back into combined data
use `combined_data', clear
merge 1:1 hhid using `education_outcomes', keep(master match) nogen

save `combined_data', replace

drop gpd_datalatitude gpd_datalongitude

* save final dataset to specifications folder
save "$specifications/v2_baseline_to_midline_pap_specifications.dta", replace



