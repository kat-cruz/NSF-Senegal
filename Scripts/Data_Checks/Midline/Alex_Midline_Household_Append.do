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

**************************** data file paths ****************************`		`	''
global data "$master\Data_Management\_CRDES_RawData\Midline\Household_Survey_Data"

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
global hh18 "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Household_Roster\hh18_16Feb2025"
global hh13 "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Household_Roster\hh13_16Feb2025"

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
		
sort enqu_name issue_variable_name
gen issue_variable_label = ""  
foreach var of varlist issue_variable_name {  
    replace issue_variable_label = "`: variable label `var''" if issue_variable_name == "`var'"
}
sort enqu_name issue_variable_name
merge m:m hhid hh_individ_complet_resp using "$issuesOriginal\\Updated_Midline_Survey_Questions.dta"

* Export the dataset to Excel
//export excel using "$issues\Household_Issues_13Feb2025.xlsx", firstrow(variables) replace
export excel using "$issuesOriginal\Part1_Household_Issues_16Feb2025.xlsx", firstrow(variables) replace

**** TIME USE QUESTIONS *****************
	clear
	local folder "$hh13"  

	cd "`folder'"
	local files: dir . files "*.dta"

	foreach file in `files' {
		di "Appending `file'"
		append using "`file'"
	}

	gen issue_variable_label = ""  
foreach var of varlist issue_variable_name {  
    replace issue_variable_label = "`: variable label `var''" if issue_variable_name == "`var'"
}
sort enqu_name issue_variable_name

merge m:m hhid hh_individ_complet_resp using "$issuesOriginal\\Updated_Midline_Survey_Questions.dta"
	save "$hh13\Part2_Household_Issues_16Feb2025.dta", replace 
	
**** TIME USE QUESTIONS *****************
	clear
	local folder "$hh18"  

	cd "`folder'"
	local files: dir . files "*.dta"

	foreach file in `files' {
		di "Appending `file'"
		append using "`file'"
	}
	
gen issue_variable_label = ""  
foreach var of varlist issue_variable_name {  
    replace issue_variable_label = "`: variable label `var''" if issue_variable_name == "`var'"
}
sort enqu_name issue_variable_name
merge m:m hhid hh_individ_complet_resp using "$issuesOriginal\\Updated_Midline_Survey_Questions.dta"
	save "$hh18\Part3_Household_Issues_16Feb2025.dta", replace 
	

