**************************************************
* DISES Data for Notre Dame *
* File Created By: Alexander Mills *
* File Last Updated By: Alexander Mills *
* Updates Tracked on Git *
**************************************************

*** This Do File PROCESSES: PUT ALL SCRIPTS HERE***
*** This Do File CREATES: Notre_Dame_Midline_Data.csv
						
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
keep living_01 living_04 hh_14* health_5_2* health_5_3* health_5_5* health_5_6* health_5_8* health_5_9* hh_02* hh_10* hh_13* hh_11* knowledge_18 knowledge_21 number_hh number_total q_23 q_24 q_35_check q_35 

* collapse row sum of hh_10 to each hhid_village
* 


