*************************************************
* DISES Baseline Data - Additional Agriculture Summary Statistics *
* File Created By: Molly Doruska *
* File Last Updated By: Molly Doruska *
* File Last Updated On: October 2024 *
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
if "`c(username)'" == "admmi" global path "C:\\Users\\admmi\\Box\\Data Management"
if "`c(username)'" == "km978" global path "C:\Users\km978\Box\Data Management"
if "`c(username)'" == "socrm" global path "C:\Users\socrm\Box\NSF Senegal\Data Management"

**************************************************
* Agriculture Data Summary
**************************************************

* Use Agriculture data
use "${path}\_CRDES_CleanData\Baseline\Deidentified\Complete_Baseline_Agriculture.dta", clear

*** keep only missing summary statistics variables *** 
keep hhid agri_6_34_* agri_6_35_* agri_6_36_* agri_6_37_* agri_6_38_a_* agri_6_38_a_code_* agri_6_38_a_code_o_* agri_6_39_a_* agri_6_39_a_code_* agri_6_39_a_code_o_* agri_6_40_a_* agri_6_40_a_code_* agri_6_40_a_code_o_* agri_6_41_a_* agri_6_41_a_code_* agri_6_41_a_code_o_*

*** create string variables where necessary *** 
tostring agri_6_38_a_code_o*, replace 
tostring agri_6_39_a_code_o*, replace 
tostring agri_6_40_a_code_o*, replace 
tostring agri_6_41_a_code_o*, replace 

*** reshape missing variables from wide to long *** 
reshape long agri_6_34_ agri_6_35_ agri_6_36_ agri_6_37_ agri_6_38_a_ agri_6_38_a_code_ agri_6_38_a_code_o_ agri_6_39_a_ agri_6_39_a_code_ agri_6_39_a_code_o_ agri_6_40_a_ agri_6_40_a_code_ agri_6_40_a_code_o_ agri_6_41_a_ agri_6_41_a_code_ agri_6_41_a_code_o_, i(hhid) j(plotn) 

*** summarize variables for codebook *** 
summarize agri_6_35_ agri_6_37_ agri_6_38_a_ agri_6_39_a_ agri_6_40_a_ agri_6_41_a_  

tab agri_6_34_ 
summarize agri_6_34_ if agri_6_34_ < 2

tab agri_6_36_ 
summarize agri_6_36_ if agri_6_36_ < 2

tab agri_6_38_a_code_

tab agri_6_39_a_code_

tab agri_6_40_a_code_ 

tab agri_6_41_a_code_

* Use Household roster data 
use "${path}\_CRDES_CleanData\Baseline\Deidentified\Complete_Baseline_Household_Roster.dta", clear

tab hh_gender_resp 

