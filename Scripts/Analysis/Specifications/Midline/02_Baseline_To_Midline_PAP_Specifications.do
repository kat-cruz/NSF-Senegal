**************************************************
* DISES ANCOVA Regressions Baseline to Midline
* Created by: Alexander Mills
* File Last Updated By: Alexander Mills *
* Updates Tracked on Git *
**************************************************

* Setup
clear all
set more off

* Set file paths
if "`c(username)'" == "admmi" global master "C:\Users\admmi\Box\NSF Senegal"
if "`c(username)'" == "km978" global master "C:\Users\km978\Box\NSF Senegal"
if "`c(username)'" == "socrm" global master "C:\Users\socrm\Box\NSF Senegal"

global specifications "$master\Data_Management\Output\Analysis\Specifications\Midline"

* specifications dataset
use "$specifications/baseline_to_midline_pap_specifications.dta", clear

* global macros
global controls q_51 q4 living_01_bin asset_index_std hh_age_h i.hh_gender_h i.hh_education_skills_5_h
global distance_vector walking_minutes_to_arm_0 walking_minutes_to_arm_1 walking_minutes_to_arm_2 walking_minutes_to_arm_3

* treatment arm indicators for equation 2
gen T_A = (treatment_arm == 1)
gen T_B = (treatment_arm == 2) 
gen T_C = (treatment_arm == 3)

* local control and treated indicators for equation 3
gen T_L = (trained_hh == 0 & treatment_arm > 0)
gen T_T = (trained_hh == 1)

* arm-specific local/treated indicators for equation 4
gen T_A_L = (trained_hh == 0 & treatment_arm == 1)
gen T_A_T = (trained_hh == 1 & treatment_arm == 1)
gen T_B_L = (trained_hh == 0 & treatment_arm == 2)
gen T_B_T = (trained_hh == 1 & treatment_arm == 2)
gen T_C_L = (trained_hh == 0 & treatment_arm == 3)
gen T_C_T = (trained_hh == 1 & treatment_arm == 3)

**************************************************
* Primary Outcomes
**************************************************
eststo clear

* 1.1.1 - AVR Main Effect
eststo avr_main: reg midline_avr trained_hh baseline_avr $controls $distance_vector i.auction_village, vce(cluster hhid_village)
estadd local baseline_control "Yes"
estadd local controls "Yes"
estadd local distance "Yes"
estadd local auction "Yes"

* 1.1.1 - AVR Treatment Arm Effects (Equation 2)
eststo avr_arms: reg midline_avr T_A T_B T_C baseline_avr $controls $distance_vector i.auction_village, vce(cluster hhid_village)
test T_A = T_B
estadd scalar p_ab = r(p)
test T_A = T_C
estadd scalar p_ac = r(p)
test T_B = T_C
estadd scalar p_bc = r(p)
estadd local baseline_control "Yes"
estadd local controls "Yes"
estadd local distance "Yes"
estadd local auction "Yes"

* 1.1.2 - AVR Spillover Effects
eststo avr_spill: reg midline_avr T_L T_T baseline_avr $controls $distance_vector i.auction_village, vce(cluster hhid_village)
test T_L = T_T
estadd scalar p_lt = r(p)
estadd local baseline_control "Yes"
estadd local controls "Yes"
estadd local distance "Yes"
estadd local auction "Yes"

* 1.1.2 - AVR Arm-Specific Spillovers
eststo avr_arm_spill: reg midline_avr T_A_L T_A_T T_B_L T_B_T T_C_L T_C_T baseline_avr $controls $distance_vector i.auction_village, vce(cluster hhid_village)
* test equality across arms for local controls
test T_A_L = T_B_L
estadd scalar p_l_ab = r(p)
test T_A_L = T_C_L
estadd scalar p_l_ac = r(p)
test T_B_L = T_C_L
estadd scalar p_l_bc = r(p)
* equality across arms for treated
test T_A_T = T_B_T
estadd scalar p_t_ab = r(p)
test T_A_T = T_C_T
estadd scalar p_t_ac = r(p)
test T_B_T = T_C_T
estadd scalar p_t_bc = r(p)
estadd local baseline_control "Yes"
estadd local controls "Yes"
estadd local distance "Yes"
estadd local auction "Yes"

* AVR analysis tables
esttab avr_main avr_arms avr_spill avr_arm_spill using "$specifications/ancova_primary_outcomes_part1.tex", ///
    label b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    keep(trained_hh T_A T_B T_C T_L T_T T_A_L T_A_T T_B_L T_B_T T_C_L T_C_T) ///
    scalars("p_ab A=B p-value" "p_ac A=C p-value" "p_bc B=C p-value" ///
            "p_lt Local=Treated p-value" ///
            "p_l_ab Local A=B p-value" "p_l_ac Local A=C p-value" "p_l_bc Local B=C p-value" ///
            "p_t_ab Treated A=B p-value" "p_t_ac Treated A=C p-value" "p_t_bc Treated B=C p-value" ///
            "baseline_control Baseline Control" "controls Controls" "distance Distance Vector" "auction Auction FE") ///
    mtitles("Main Effect" "Treatment Arms" "Spillovers" "Arm-Specific") ///
    title("AVR Treatment Effects and Spillovers") ///
	note("Analysis restricted to households tracked from baseline to midline (N=2,029) out of 2,080 baseline households. Replacement households excluded due to missing baseline data.") ///
    replace

eststo clear

* 1.1.1 - AVR Main Effect
eststo avr_main2: reg midline_avr trained_hh baseline_avr $controls $distance_vector i.auction_village, vce(cluster hhid_village)
estadd local baseline_control "Yes"
estadd local controls "Yes"
estadd local distance "Yes"
estadd local auction "Yes"

* 1.1.4-1.1.6 - Compost Production
eststo compost_main: reg midline_compost_production trained_hh baseline_compost_production $controls $distance_vector i.auction_village, vce(cluster hhid_village)
estadd local baseline_control "Yes"
estadd local controls "Yes"
estadd local distance "Yes"
estadd local auction "Yes"

* 1.1.7 - Food Security (rCSI)
eststo rcsi_main: reg midline_rcsi_annual trained_hh baseline_rcsi_annual $controls $distance_vector i.auction_village, vce(cluster hhid_village)
estadd local baseline_control "Yes"
estadd local controls "Yes"
estadd local distance "Yes"
estadd local auction "Yes"

* 1.1.7 - Food Security (Lean Season)
eststo lean_main: reg midline_months_soudure trained_hh baseline_months_soudure $controls $distance_vector i.auction_village, vce(cluster hhid_village)
estadd local baseline_control "Yes"
estadd local controls "Yes"
estadd local distance "Yes"
estadd local auction "Yes"

* 1.1.8.2 - Self-Reported Health
eststo health_main: reg midline_schisto_symptoms trained_hh baseline_schisto_symptoms $controls $distance_vector i.auction_village, vce(cluster hhid_village)
estadd local baseline_control "Yes"
estadd local controls "Yes"
estadd local distance "Yes"
estadd local auction "Yes"

* Export primary outcomes table
esttab avr_main2 compost_main rcsi_main lean_main health_main using "$specifications/ancova_primary_outcomes_part2.tex", ///
    label b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    keep(trained_hh) ///
    scalars("baseline_control Baseline Control" "controls Controls" "distance Distance Vector" "auction Auction FE") ///
    mtitles("AVR" "Compost" "rCSI" "Lean Season" "Health") ///
    title("Treatment Effects on Primary Outcomes") ///
	note("Analysis restricted to households tracked from baseline to midline (N=2,029) out of 2,080 baseline households. Replacement households excluded due to missing baseline data.") ///
    replace

**************************************************
* Secondary Outcomes
**************************************************
eststo clear

* 2.1.1 - Work Days Lost
eststo work: reg midline_work_days_lost trained_hh baseline_work_days_lost $controls $distance_vector i.auction_village, vce(cluster hhid_village)
estadd local baseline_control "Yes"
estadd local controls "Yes"
estadd local distance "Yes"
estadd local auction "Yes"

* 2.1.1 - Days Lost Per Worker
eststo work_pw: reg midline_days_per_worker trained_hh baseline_days_per_worker $controls $distance_vector i.auction_village, vce(cluster hhid_village)
estadd local baseline_control "Yes"
estadd local controls "Yes"
estadd local distance "Yes"
estadd local auction "Yes"

* 2.1.2 - Education: Enrollment
eststo enroll: reg midline_any_enrolled trained_hh baseline_any_enrolled $controls $distance_vector i.auction_village, vce(cluster hhid_village)
estadd local baseline_control "Yes"
estadd local controls "Yes"
estadd local distance "Yes"
estadd local auction "Yes"

* 2.1.2 - Education: Years
eststo years: reg midline_avg_years_edu trained_hh baseline_avg_years_edu $controls $distance_vector i.auction_village, vce(cluster hhid_village)
estadd local baseline_control "Yes"
estadd local controls "Yes"
estadd local distance "Yes"
estadd local auction "Yes"

* 2.1.2 - Education: Attendance
eststo attend: reg midline_avg_attendance trained_hh baseline_avg_attendance $controls $distance_vector i.auction_village, vce(cluster hhid_village)
estadd local baseline_control "Yes"
estadd local controls "Yes"
estadd local distance "Yes"
estadd local auction "Yes"

* Export secondary outcomes table
esttab work work_pw enroll years attend using "$specifications/ancova_secondary_outcomes.tex", ///
    label b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    keep(trained_hh) ///
    scalars("baseline_control Baseline Control" "controls Controls" "distance Distance Vector" "auction Auction FE") ///
    mtitles("Work Days Lost" "Days per Worker" "Enrollment" "Years Education" "Attendance") ///
    title("Treatment Effects on Secondary Outcomes") ///
	note("Analysis restricted to households tracked from baseline to midline (N=2,029) out of 2,080 baseline households. Replacement households excluded due to missing baseline data.") ///
    replace