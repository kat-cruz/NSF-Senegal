*** DISES Midline Data Checks - Household Survey***
*** File originally created By: Kateri Mouawad  ***
*** Updates recorded in GitHub ***

*>>>>>>>>>>**--*--*--*--*--*--*--*--** READ ME **--*--*--*--*--*--*--*--**<<<<<<<<<<<*

		** REDO ALL OF THIS LOL

			*1)	Go to the following file path:
					*Data Management\Output\Data_Quality_Checks\Midline
			*2)	Check for through each of the subfolders to verify which issues have been outputed 
			*3)	Update this script with any new .dta's by appending them, module by module 
			*4) After you apppend all of the issues by module, complete one final append by appending the module issues 
			*5) Export this spread sheet to the Issues folder located here:
				*\Data Management\External_Corrections\Issues for Justin and Amina\Midline\Issues
			

*--*--*--*--*--*--*--*--**--*--*--*--*--*--*--*--**--*--*--*--*--*--*--*--**--*--*--*--*--*--*--*--*

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


global village_observations "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Village_Observations"
global household_roster "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Household_Roster"
global knowledge "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Knowledge"
global health "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Health" 
global agriculture_inputs "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Agriculture_Inputs"
global agriculture_production "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Agriculture_Production"
global food_consumption "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Food_Consumption"
global income "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Income"
global standard_living "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Standard_Living"
global beliefs "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Beliefs" 
global enum_observations "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Enumerator_Observations"

************************* Baseline file path  **********************************

global baseline "$master\Data_Management\_CRDES_CleanData\Baseline\Identified"


************************* Final output file path **********************************


global issues "$master\Data_Management\External_Corrections\Issues for Justin and Amina\Midline\Issues"
global issuesOriginal "$master\Data_Management\Output\Data_Quality_Checks\Midline\_Midline_Original_Issues_Output"


********************** COMBINE FILES INTO SECTION FILES **********************

*** Combine village observation files ***


************************* COMBINE HOUSEHOLD ROSTER FILES *****************
* Note: check to see what was output before running just to ensure things look good 

	clear
	local folder "$household_roster"  

	cd "`folder'"
	local files: dir . files "*.dta"

	foreach file in `files' {
		di "Appending `file'"
		append using "`file'"
	}


	save "$household_roster\Roster_Issues.dta", replace 



***  ***
*************************  COMBINE KNOWLEDGE FILES *****************
* Note: check to see what was output
/*
	
	clear
	local folder "$knowledge"  

	cd "`folder'"
	local files: dir . files "*.dta"

	foreach file in `files' {
		di "Appending `file'"
		append using "`file'"
	}




	save "$knowledge\Knowledge_Issues.dta", replace 
*/


************************* COMBINE HEALTH FILES *****************
* Note: check to see what was output

	clear
	local folder "$health"  

	cd "`folder'"
	local files: dir . files "*.dta"

	foreach file in `files' {
		di "Appending `file'"
		append using "`file'"
	}




	save "$health\Health_Issues.dta", replace 


************************* COMBINE AGRICULTURE INPUTS FILES *****************
* Note: check to see what was output


	clear
	local folder "$agriculture_inputs"  

	cd "`folder'"
	local files: dir . files "*.dta"

	foreach file in `files' {
		di "Appending `file'"
		append using "`file'"
	}


	save "$agriculture_inputs\Ag_Inputs_Issues.dta", replace 


************************* COMBINE AGRICULTURE PRODUCITON FILES *****************
* Note: check to see what was output

	clear
	local folder "$agriculture_production"  

	cd "`folder'"
	local files: dir . files "*.dta"

	foreach file in `files' {
		di "Appending `file'"
		append using "`file'"
	}


	save "$agriculture_production\Ag_Production_Issues.dta", replace 


************************* COMBINE FOOD CONSUMPTION ISSUE FILES *****************
* Note: check to see what was output

 * KRM - none this round, commented out 

	/*

	clear
	local folder "$food_consumption"  

	cd "`folder'"
	local files: dir . files "*.dta"

	foreach file in `files' {
		di "Appending `file'"
		append using "`file'"
	}


	save "$food_consumption\Food_Consumption_Issues.dta", replace 
*/


************************* COMBINE INCOME ISSUE FILES *****************
* Note: check to see what was output

	clear
	local folder "$income"  

	cd "`folder'"
	local files: dir . files "*.dta"

	foreach file in `files' {
		di "Appending `file'"
		append using "`file'"
	}


	save "$income\Income_Issues.dta", replace 



************************* COMBINE STANDARD OF LIVING ISSUE FILES  *****************
* Note: check to see what was output
* R2 - none this round 
	/*
	clear
	local folder "$standard_living"  

	cd "`folder'"
	local files: dir . files "*.dta"

	foreach file in `files' {
		di "Appending `file'"
		append using "`file'"
	}


	save "$standard_living\Standard_Living_Issues.dta", replace 
	*/



************************* COMBINE ENUMERATOR OBSERVATION ISSUE FILES *****************
* Note: check to see what was output
* R2 - none this round 
/*
	
	clear
	local folder "$enum_observations"  

	cd "`folder'"
	local files: dir . files "*.dta"

	foreach file in `files' {
		di "Appending `file'"
		append using "`file'"
	}


	save "$enum_observations\Enum_Observations_Issues.dta", replace 
	*/

************** COMBINE SECTION FILES INTO ONE HOUSEHOLD ISSUES FILE *************

*Note - not all files exist, please verify each round 

		use "$household_roster\Roster_Issues.dta", replace
		*append using "$knowledge\Knoweldge_Issues.dta"
		append using "$health\Health_Issues.dta"
		append using "$agriculture_inputs\Ag_Inputs_Issues.dta"
		append using "$agriculture_production\Ag_Production_Issues.dta"
		*append using "$food_consumption\Food_Consumption_Issues.dta"
		append using "$income\Income_Issues.dta"
		*append using "$standard_living\Standard_of_Living_Issues.dta"
		*append using "$enum_observations\Enumerator_Issues.dta"

		
		rename hh_name_complet_resp hh_individ_complet_resp 

		
************** SAVE DATAFRAME FOR FUTURE ROUND ************** 

		*R3 - please update round number here! 
	/*
		use "$issuesOriginal\Household_Data_Sent_Issues_R3.dta", clear 
	   drop filter_var
	*/
		preserve
		
		gen filter_var = "All sent"
		
		save "$issuesOriginal\Household_Data_Sent_Issues_R2.dta", replace 
		
		restore 

************************************************** STEPS FOR SORTING AND ORGANIZING FOR CLARITY **************************************************
	
*1) *--*--*--*--*--*--*--*--* merge in baseline data *--*--*--*--*--*--*--*--*
				*1.1) **>>>>>>>>> we do this to grab the hh_head_name_complet variable and the corresponding names to hh_individ_complet_resp <<<<<<<<<<**
		
		merge m:m hh_individ_complet_resp using "$baseline\All_Villages_With_Individual_IDs_Selected_Vars.dta"
		drop if sup & sup_name == . 
		drop _merge


*2) *--*--*--*--*--*--*--*--* merge in the previous output to filter for new errors: *--*--*--*--*--*--*--*--*
				*2.1) **>>>>>>>>> filter by the last_update variable <<<<<<<<<<**
				
				**Note - please ensure this merge here is from the previous round 

		merge m:m hhid hh_individ_complet_resp using "$issuesOriginal\Household_Data_Sent_Issues_R1.dta"
		keep if filter_var == ""
		
	*Note: update the _merge var for record since we will need to drop it if we don't for the next merge 
		rename _merge _mergeR2
		replace hh_name_complet_resp = hh_name_complet_resp_new if hh_individ_complet_resp == "999"
		drop hh_name_complet_resp_new filter_var
		*Note - pls update the date
		replace  last_update = "R2 - Sent on Feb 10"
		drop _merge_Jan28
		
*3) *--*--*--*--*--*--*--*--* bring in survey questions - merge on issue_variable_name *--*--*--*--*--*--*--*--*
		** KRM - need to change the round folder name to something more clear ** 
		merge m:m issue_variable_name using "$issuesOriginal\Midline_Survey_Questions.dta"
		
				*3.1) **>>>>>>>>> filter on villageid == empty  <<<<<<<<<<**
	
		drop if villageid == ""
		drop  _merge 

*4) *--*--*--*--*--*--*--*--* order and clean up *--*--*--*--*--*--*--*--*
	
		order villageid sup sup_name enqu enqu_name hhid hh_individ_complet_resp hh_head_name_complet hh_name_complet_resp hh_member_name hh_phone print_issue issue issue_variable_name last_update _mergeR2
		
				
************* EXPORT COMBINED HOUSEHOLD CHECKS DATA FILE ************* 


		*Note - please update DATE on export!:) 
		/*
		export excel using "$issues\Household_Data_Issues_03Feb2025.xlsx", firstrow(variables) replace 
		save "$issues\Household_Data_Issues_03Feb2025.dta", replace 
		*/


		*keep original for version control 
		export excel using "$issuesOriginal\R2_Household_Data_Issues_10Feb2025_test.xlsx", firstrow(variables) replace 
		save "$issuesOriginal\R2_Household_Data_Issues_10Feb2025.dta", replace 


		** end of .do file




************************************ Archive ************************************ 

* KRM -  Leaving for record - I needed to update the survey questions for the first round of checks
/*

import excel using "$issues\Household_Data_Issues_28Jan2025_surveyquestions.xlsx", sheet("Sheet1") firstrow clear
keep SurveyQuestion issue_variable_name

merge m:m issue_variable_name using "$issuesOriginal\Household_Data_Issues_28Jan2025.dta"

	order villageid sup sup_name enqu enqu_name hhid hh_individ_complet_resp hh_head_name_complet hh_name_complet_resp hh_member_name hh_phone print_issue issue issue_variable_name SurveyQuestion last_update _merge_Jan28
*/


*KRM - leaving this here for reference
		/*
		
		use "$baseline\All_Villages_With_Individual_IDs.dta", clear 
		rename hhid_village villageid
		gen hh_individ_complet_resp = individ 
		label var hh_individ_complet_resp "This is the same as individ, but since we merge on hh_individ_complet_resp for the other dfs, this saves a st"
		keep hhid villageid hh_individ_complet_resp hh_head_name_complet hh_name_complet_resp

		save "$baseline\All_Villages_With_Individual_IDs_Selected_Vars.dta", replace 
		*/


		

















