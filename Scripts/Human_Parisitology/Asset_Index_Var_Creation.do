*==============================================================================
* Program: PCA - Asset Index
* ==============================================================================
* written by: Kateri Mouawad
* additions made by: Kateri Mouawad
* Created: February 2024
* Updates recorded in GitHub 

*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<~~~~ Read Me! ~~~~ >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


clear all
set mem 100m
set maxvar 30000
set matsize 11000
set more off

**************************************************
* SET FILE PATHS
**************************************************
* Set base Box path for each user
if "`c(username)'"=="socrm" global master "C:\Users\socrm\Box"
if "`c(username)'"=="kls329" global master "C:\Users\kls329\Box"
if "`c(username)'"=="km978" global master "C:\Users\km978\Box\NSF Senegal"
if "`c(username)'"=="Kateri" global master "C:\Users\Kateri\Box\NSF Senegal"
if "`c(username)'"=="admmi" global master "C:\Users\admmi\Box"

if "`c(username)'"=="km978" global gitmaster "C:\Users\Kateri\Downloads\GIT-Senegal\NSF-Senegal"
if "`c(username)'"=="Kateri" global gitmaster "C:\Users\km978\Downloads\GIT-Senegal\NSF-Senegal"



* Define project-specific paths

global data "${master}\Data_Management\_CRDES_CleanData\Baseline\Deidentified"

***** Data folders *****
global dataOutput "${master}\Data_Management\Output\Data_Analysis\Balance_Tables" 
global latexOutput "$git_path\Latex_Output\Balance_Tables"

use "$data\Complete_Baseline_Household_Roster.dta", clear 

merge 1:1 hhid using "$data\Complete_Baseline_Health.dta"
drop _merge 


merge 1:1 hhid using "$data\Complete_Baseline_Agriculture.dta"
drop _merge 

merge 1:1 hhid using "$data\Complete_Baseline_Income.dta"
drop _merge 

merge 1:1 hhid using "$data\Complete_Baseline_Standard_Of_Living.dta"
drop _merge 

merge 1:1 hhid using "$data\Complete_Baseline_Public_Goods_Game.dta"
drop _merge 

merge 1:1 hhid using "$data\Complete_Baseline_Enumerator_Observations.dta"
drop _merge 

merge m:1 hhid_village using "$data\Complete_Baseline_Community.dta"
drop _merge 







* agri_income_23	8.26 Income by frequency
* agri_income_24	8.27 Total annual income
* agri_income_25    8.28 Do you have employees for your non-agricultural activities?
* agri_income_40	8.43 Have you (or a member of your household) lent money to others during this year?
* agri_income_26    8.29 If yes, please specify the number.
* agri_income_27    8.30 Are these employees paid? Question relevant when: 0

keep  	enum_03* enum_04* enum_05* ///
		living_01* living_03* living_04* living_05* living_06* ///
		agri_6_15* species* agri_income_01 agri_income_05 ///
		list_actifs* agri_6_6 agri_income_23* agri_income_24* agri_income_05 agri_income_34 agri_income_40
             ///






*** to create:

* household_density











