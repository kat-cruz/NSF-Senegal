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

* global lists
global controls q_51 q4 hh_numero living_01_bin asset_index_std hh_age_h i.hh_gender_h i.hh_education_skills_5_h
global distance_vector walking_minutes_to_arm_0 walking_minutes_to_arm_1 walking_minutes_to_arm_2 walking_minutes_to_arm_3

* 1.1.1 - AVR Self-Reports
eststo clear
eststo: reg midline_avr trained_hh baseline_avr $controls $distance_vector i.auction_village, vce(cluster hhid_village)
estadd local baseline_control "Yes"
estadd local controls "Yes"
estadd local distance "Yes"
estadd local auction "Yes"

* 1.1.4-1.1.6 - Compost Production 
eststo: reg midline_compost_production trained_hh baseline_compost_production $controls $distance_vector i.auction_village, vce(cluster hhid_village)
estadd local baseline_control "Yes"
estadd local controls "Yes"
estadd local distance "Yes"
estadd local auction "Yes"

* 1.1.7 - Food Security
* rCSI Score
eststo: reg midline_rcsi_annual trained_hh baseline_rcsi_annual $controls $distance_vector i.auction_village, vce(cluster hhid_village)
estadd local baseline_control "Yes"
estadd local controls "Yes"
estadd local distance "Yes"
estadd local auction "Yes"

* Months of Soudure
eststo: reg midline_months_soudure trained_hh baseline_months_soudure $controls $distance_vector i.auction_village, vce(cluster hhid_village)
estadd local baseline_control "Yes"
estadd local controls "Yes"
estadd local distance "Yes"
estadd local auction "Yes"

* 1.1.8.2 - Self-Reported Health
eststo: reg midline_schisto_symptoms trained_hh baseline_schisto_symptoms $controls $distance_vector i.auction_village, vce(cluster hhid_village)
estadd local baseline_control "Yes"
estadd local controls "Yes"
estadd local distance "Yes"
estadd local auction "Yes"

* 1.1.11 - Property Rights Beliefs
eststo: reg midline_community_rights trained_hh baseline_community_rights $controls $distance_vector i.auction_village, vce(cluster hhid_village)
estadd local baseline_control "Yes"
estadd local controls "Yes"
estadd local distance "Yes"
estadd local auction "Yes"

* export to table
esttab using "$specifications/ancova_primary_outcomes.tex", ///
    label b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    keep(trained_hh) ///
    scalars("baseline_control Baseline Control" "controls Controls" "distance Distance Vector" "auction Auction FE") ///
    mtitles("AVR" "Compost" "rCSI" "Lean Season" "Schisto" "Property Rights") ///
    title("Treatment Effects on Primary Outcomes") ///
    replace

* secondary Outcomes
eststo clear

* 2.1.1 - Work/School Days Lost
eststo: reg midline_work_days_lost trained_hh baseline_work_days_lost $controls $distance_vector i.auction_village, vce(cluster hhid_village)
estadd local baseline_control "Yes"
estadd local controls "Yes"
estadd local distance "Yes"
estadd local auction "Yes"

* 2.1.2 - education Outcomes
eststo: reg midline_avg_years_edu trained_hh baseline_avg_years_edu $controls $distance_vector i.auction_village, vce(cluster hhid_village)
estadd local baseline_control "Yes"
estadd local controls "Yes"
estadd local distance "Yes"
estadd local auction "Yes"

* export to table
esttab using "$specifications/ancova_secondary_outcomes.tex", ///
    label b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    keep(trained_hh) ///
    scalars("baseline_control Baseline Control" "controls Controls" "distance Distance Vector" "auction Auction FE") ///
    mtitles("Work Days Lost" "Education") ///
    title("Treatment Effects on Secondary Outcomes") ///
    replace