*** DISES Midline Data Checks - Household Survey***
*** File originally created By: Molly Doruska - Adapted by Kateri Mouawad & Alex Mills ***
*** Updates recorded in GitHub ***

*>>>>>>>>>>*===========================* READ ME *===========================*<<<<<<<<<<<*


			*1)	Go to the following file path:
					*Data Management\Output\Data Quality Checks\Midline
			*2)	Check for through each of the subfolders to verify which issues have been outputed 
			*3)	Update this script with any new .dta's by appending them, module by module 
			*4) After you apppend all of the issues by module, complete one final append by appending the module issues 
			*5) Export this spread sheet to the Issues folder located here:
				*\Data Management\External_Corrections\Issues for Justin and Amina\Midline\Issues
			

*==============================================================================
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
if "`c(username)'"=="admmi" global master "C:\Users\admmi\Box\NSF Senegal"



global village_observations "$master\Data Management\Output\Data Quality Checks\Midline\R2_Village_Observations"
global household_roster "$master\Data Management\Output\Data Quality Checks\Midline\R2_Household_Roster"
global knowledge "$master\Data Management\Output\Data Quality Checks\Midline\R2_Knowledge"
global health "$master\Data Management\Output\Data Quality Checks\Midline\R2_Health" 
global agriculture_inputs "$master\Data Management\Output\Data Quality Checks\Midline\R2_Agriculture_Inputs"
global agriculture_production "$master\Data Management\Output\Data Quality Checks\Midline\R2_Agriculture_Production"
global food_consumption "$master\Data Management\Output\Data Quality Checks\Midline\R2_Food_Consumption"
global income "$master\Data Management\Output\Data Quality Checks\Midline\R2_Income"
global standard_living "$master\Data Management\Output\Data Quality Checks\Midline\R2_Standard_Living"
global beliefs "$master\Data Management\Output\Data Quality Checks\Midline\R2_Beliefs" 
global enum_observations "$master\Data Management\Output\Data Quality Checks\Midline\R2_Enumerator_Observations"


************************* Final output file path **********************************


global issues "$master\Data Management\External_Corrections\Issues for Justin and Amina\Midline\Issues"
global issuesOriginal "$master\Data Management\Output\Data Quality Checks\Midline\Original_Issues_Output"


********************** COMBINE FILES INTO SECTION FILES **********************

*** Combine village observation files ***


************************* CHECK TO SEE WHAT WAS OUTPUT *****************


************************* Combine household roster files *****************

* Note: check to see what was output
use "$household_roster\Issue_HH_Roster_hh_age_resp.dta", clear 

append using "$household_roster\Issue_Household_hh_age_1.dta"
append using "$household_roster\Issue_Household_hh_age_2.dta"
append using "$household_roster\Issue_Household_hh_age_3.dta"
append using "$household_roster\Issue_Household_hh_age_5.dta"
append using "$household_roster\Issue_Household_hh_age_7.dta"
append using "$household_roster\Issue_Household_hh_age_8.dta"
append using "$household_roster\Issue_Household_hh_age_19.dta"
append using "$household_roster\Issue_Household_hh_education_level_1.dta"
append using "$household_roster\Issue_Household_hh_education_level_2.dta"
append using "$household_roster\Issue_Household_hh_education_level_4.dta"
append using "$household_roster\Issue_Household_hh_education_level_5.dta"
append using "$household_roster\Issue_Household_hh_education_level_6.dta"
append using "$household_roster\Issue_Household_hh_education_level_13.dta"

save "$household_roster\Roster_Issues.dta", replace 

***  ***
*************************  COMBINE KNOWLEDGE FILES *****************
* Note: check to see what was output


************************* COMBINE HEALTH FILES *****************
* Note: check to see what was output

*use  "$health\Issue_health_5_12_12.dta", clear 


*save "$health\Health_Issues.dta", replace 


************************* COMBINE AGRICULTURE INPUTS FILES *****************
* Note: check to see what was output

*use "$agriculture_inputs\Issue_agri_6_15_unreasonable.dta", clear 

*save "$agriculture_inputs\Ag_Inputs_Issues.dta", replace 

************************* COMBINE AGRICULTURE PRODUCITON FILES *****************
* Note: check to see what was output


* "$agriculture_production\Issue_legumes_01_1_unreasonable.dta", clear 

*save "$agriculture_production\Ag_Production_Issues.dta", replace 


************************* COMBINE FOOD CONSUMPTION ISSUE FILES *****************
* Note: check to see what was output


************************* COMBINE INCOME ISSUE FILES *****************
* Note: check to see what was output

*use "$income\Issue_agri_income_03_unreasonable.dta", clear 


*save "$income\Income_Issues.dta", replace 

************************* COMBINE STANDARD OF LIVING ISSUE FILES  *****************
* Note: check to see what was output

************************* COMBINE ENUMERATOR OBSERVATION ISSUE FILES *****************
* Note: check to see what was output


************** COMBINE SECTION FILES INTO ONE HOUSEHOLD ISSUES FILE *************

*** NOT ALL FILES EXIST YET *** 

use "$household_roster\Roster_Issues.dta", replace
*append using "$knowledge\Knoweldge_Issues.dta"
*append using "$health\Health_Issues.dta"
*append using "$agriculture_inputs\Ag_Inputs_Issues.dta"
*append using "$agriculture_production\Ag_Production_Issues.dta"
*append using "$food_consumption\Food_Consumption_Issues.dta"
*append using "$income\Income_Issues.dta"
*append using "$standard_living\Standard_of_Living_Issues.dta"
*append using "$enum_observations\Enumerator_Issues.dta"

*** export combined household checks data file *** 

*Note - please update DATE on export!:) 
export excel using "$issues\Household_Data_Issues_27Jan2025.xlsx", firstrow(variables) replace 
*keep original for version control 
export excel using "$issuesOriginal\Household_Data_Issues_27Jan2025.xlsx", firstrow(variables) replace 

