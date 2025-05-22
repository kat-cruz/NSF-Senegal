**************************************************
* DISES ANCOVA Regressions Baseline to Midline
* Created by: Alexander Mills
* Last Updated: May 21, 2025
**************************************************

* Setup
clear all
set more off

* Set file paths
if "`c(username)'" == "admmi" global master "C:\Users\admmi\Box\NSF Senegal"
if "`c(username)'" == "km978" global master "C:\Users\km978\Box\NSF Senegal"
if "`c(username)'" == "socrm" global master "C:\Users\socrm\Box\NSF Senegal"

global specifications "$master\Data_Management\Output\Analysis\Specifications\Midline"
global tables "$master\Data_Management\Output\Analysis\Tables\Midline"

* Load specifications dataset
use "$specifications/baseline_to_midline_pap_specifications.dta", clear

* Define control variables and distance vector
global controls q_51 q4 living_01_bin asset_index_std hh_age_h i.hh_gender_h i.hh_education_skills_5_h
global distance_vector walking_minutes_to_arm_0 walking_minutes_to_arm_1 walking_minutes_to_arm_2 walking_minutes_to_arm_3

* Primary Outcomes
eststo clear

* 1.1.1 - AVR (Self-Reports)
eststo avr: reg midline_avr trained_hh baseline_avr $controls $distance_vector i.auction_village, vce(cluster hhid_village)
estadd local baseline_control "Yes"
estadd local controls "Yes"
estadd local distance "Yes"
estadd local auction "Yes"

* 1.1.4-1.1.6 - Compost Production
eststo compost: reg midline_compost_production trained_hh baseline_compost_production $controls $distance_vector i.auction_village, vce(cluster hhid_village)
estadd local baseline_control "Yes"
estadd local controls "Yes"
estadd local distance "Yes"
estadd local auction "Yes"

* 1.1.7 - Food Security
eststo rcsi: reg midline_rcsi_annual trained_hh baseline_rcsi_annual $controls $distance_vector i.auction_village, vce(cluster hhid_village)
estadd local baseline_control "Yes"
estadd local controls "Yes"
estadd local distance "Yes"
estadd local auction "Yes"

eststo lean: reg midline_months_soudure trained_hh baseline_months_soudure $controls $distance_vector i.auction_village, vce(cluster hhid_village)
estadd local baseline_control "Yes"
estadd local controls "Yes"
estadd local distance "Yes"
estadd local auction "Yes"

* 1.1.8.2 - Self-Reported Health
eststo health: reg midline_schisto_symptoms trained_hh baseline_schisto_symptoms $controls $distance_vector i.auction_village, vce(cluster hhid_village)
estadd local baseline_control "Yes"
estadd local controls "Yes"
estadd local distance "Yes"
estadd local auction "Yes"

* Export primary outcomes table
esttab avr compost rcsi lean health using "$tables/ancova_primary_outcomes.tex", ///
    label b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    keep(trained_hh) ///
    scalars("baseline_control Baseline Control" "controls Controls" "distance Distance Vector" "auction Auction FE") ///
    mtitles("AVR" "Compost" "rCSI" "Lean Season" "Health") ///
    title("Treatment Effects on Primary Outcomes") ///
    replace

* Secondary Outcomes
eststo clear

* 2.1.1 - Work Days Lost
eststo work: reg midline_work_days_lost trained_hh baseline_work_days_lost $controls $distance_vector i.auction_village, vce(cluster hhid_village)
estadd local baseline_control "Yes"
estadd local controls "Yes"
estadd local distance "Yes"
estadd local auction "Yes"

* 2.1.1 - Alternative Specification (Per Worker)
eststo work_pw: reg midline_days_per_worker trained_hh baseline_days_per_worker $controls $distance_vector i.auction_village, vce(cluster hhid_village)
estadd local baseline_control "Yes"
estadd local controls "Yes"
estadd local distance "Yes"
estadd local auction "Yes"

* 2.1.2 - Education Outcomes
eststo edu: reg midline_avg_years_edu trained_hh baseline_avg_years_edu $controls $distance_vector i.auction_village, vce(cluster hhid_village)
estadd local baseline_control "Yes"
estadd local controls "Yes"
estadd local distance "Yes"
estadd local auction "Yes"

* Export secondary outcomes table
esttab work work_pw edu using "$tables/ancova_secondary_outcomes.tex", ///
    label b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    keep(trained_hh) ///
    scalars("baseline_control Baseline Control" "controls Controls" "distance Distance Vector" "auction Auction FE") ///
    mtitles("Work Days Lost" "Days Lost per Worker" "Education") ///
    title("Treatment Effects on Secondary Outcomes") ///
    replace