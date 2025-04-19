**************************************************
* DISES Baseline Data - Code used to assist with summary stats for Codebook*
* Summary stats specifically for those that were missing stats at baseline
* File Created By: Alexander Mills *
* File Last Updated By: Alexander Mills *
* Updates Tracked on Git *
**************************************************

*** This Do File PROCESSES: DISES_Baseline_Complete_PII.dta ***
*** This Do File CREATES: ***
						
*** Procedure: ***

capture log close
clear all
set mem 100m
set maxvar 30000
set matsize 11000
set more off
version 14.1

**************************************************
* SET FILE PATHS
**************************************************

disp "`c(username)'"

* Set global path based on the username
if "`c(username)'" == "admmi" global master "C:\Users\admmi\Box\NSF Senegal"
if "`c(username)'" == "km978" global master "C:\Users\km978\Box\NSF Senegal"
if "`c(username)'" == "socrm" global master "C:\Users\socrm\Box\NSF Senegal"

global survey "$master\Data_Management\Data\_CRDES_CleanData\Baseline\Deidentified"

global agriculture "$survey\Complete_Baseline_Agriculture.dta"
global beliefs"$survey\Complete_Baseline_Beliefs.dta"
global community "$survey\Complete_Baseline_Community.dta"
global enumerator"$survey\Complete_Baseline_Enumerator_Observations.dta"
global geographies"$survey\Complete_Baseline_Geographies.dta"
global health"$survey\Complete_Baseline_Health.dta"
global household "$survey\Complete_Baseline_Household_Roster.dta"
global income"$survey\Complete_Baseline_Income.dta"
global knowledge"$survey\Complete_Baseline_Knowledge.dta"
global lean "$survey\Complete_Baseline_Lean_Season.dta"
global production "$survey\Complete_Baseline_Production.dta"
global standard "$survey\Complete_Baseline_Standard_Of_Living.dta"

**************************************************
* Import baseline household
**************************************************
use "$household", clear

keep hhid_village hhid hh_education_skills_1_* hh_education_skills_2_* hh_education_skills_3_* hh_education_skills_4_* hh_education_skills_5_* hh_12_a_* hh_29_*

reshape long hh_education_skills_1_ hh_education_skills_2_ hh_education_skills_3_ hh_education_skills_4_ hh_education_skills_5_ hh_12_a_ hh_29_, i(hhid_village hhid) j(individual)

sum hh_education_skills_1_
tab hh_12_a_
tab hh_29_

**************************************************
* Import baseline income
**************************************************
use "$income", clear
sum agri_income_14_o

reshape long productindex_ agri_income_46_1_ agri_income_46_2_ agri_income_46_3_ agri_income_46_4_, i(hhid) j(indicator)

sum agri_income_46_1_ agri_income_46_2_ agri_income_46_3_ agri_income_46_4_ if productindex_ == 1
