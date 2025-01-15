*************************************************
* DISES Treatment Data - Codebook Summary Statistics *
* File Created By: Molly Doruska *
* File Last Updated By: Molly Doruska *
* File Last Updated On: October 2024 *
**************************************************

*** This Do File PROCESSES: treatment_planning_exercise.dta, treatment_indicator.dta, treatment_comprehension.dta ***
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

*** path to treatment data ***
global data "${path}\_CRDES_CleanData\Treatment\Deidentified"

**************************************************
* Planning Exercise Summary Statistics 
**************************************************

* Use planning exercise data
use "$data\treatment_planning_exercise.dta", clear

*** summary statisitcs for codebook ***
tab treatment_arms_survey 

tab treatment_arms_original 

sum recap_village q_01 q_02 q_03 q_05 q_06 q_07 q_09 q_15 q_16

tab q_04 

tab q_08

tab q_10

tab q_11 

tab q_14 

tab q_19 

**************************************************
* Comprehension Survey Summary Statistics 
**************************************************

*** Use treatment comprehension survey data *** 
use "$data\treatment_comprehension.dta", clear

*** summary statistics for codebook *** 
tab check_respondant 

tab wealth_stratum 

tab treatment_arms_survey 

tab treatment_arms_original

tab question_11 

tab question_12 

tab question_13 

tab question_14 

tab question_21 

tab question_22 

tab question_23 

tab question_31 

tab question_32 

tab question_34 

**************************************************
* Treatment Indicator Summary Statistics  
**************************************************

*** Use treatment indicator data ***
use "$data\treatment_indicator.dta", clear

*** summary statistics for codebook *** 
sum trained_hh trained_indiv


