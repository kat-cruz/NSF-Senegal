*==============================================================================
* DISES Midline Data Checks - Household Survey
* File originally created By: Kateri Mouawad
* Updates recorded in GitHub: [Alex_Midline_Household_Append.do](https://github.com/kat-cruz/NSF-Senegal/blob/main/Scripts/Data_Processing/Checks/Midline/Alex_Midline_Household_Append.do)

*>>>>>>>>>>*===========================* READ ME *===========================*<<<<<<<<<<<*
*
* Description:
* This script performs data quality checks for the DISES Midline Household Survey dataset. It involves appending issue files from various modules, combining them, and exporting the combined data for further corrections.
*
* Key Functions:
* - Verify which issue files have been outputted.
* - Append issue files module by module. Comment out the section if there are no issues
* - Perform a final append by combining the module issue files.
* - Export the combined issue data to the Issues folder.
*
* Inputs:
* - **Issue Files:** Various `.dta` files containing issue data for different modules.
* - **File Paths:** Ensure that user-specific file paths in the `SET FILE PATHS` section are correctly configured.
*
* Outputs:
* - **Combined Issue Data:** Appended issue data from various modules, exported to the Issues folder.
*
* Instructions to Run:
* 1. Go to the following file path: `Data Management\Output\Data_Quality_Checks\Midline`.
* 2. Check through each of the subfolders to verify which issues have been outputted.
* 3. Update this script with any new `.dta` files by appending them, module by module.
* 4. After appending all the issues by module, perform one final append by combining the module issues.
* 5. Export the combined issue data to the Issues folder located at `\Data Management\External_Corrections\Issues for Justin and Amina\Midline\Issues`.
*
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
global hh18 "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Household_Roster\HH18"
global hh13 "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Household_Roster\HH13"
global replacementsurvey "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Replacement_Survey"

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

/*
	clear
	local folder "$agriculture_inputs"  

	cd "`folder'"
	local files: dir . files "*.dta"

	foreach file in `files' {
		di "Appending `file'"
		append using "`file'"
	}


	save "$agriculture_inputs\Ag_Inputs_Issues.dta", replace 
*/

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
		*append using "$agriculture_inputs\Ag_Inputs_Issues.dta"
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
merge m:m issue_variable_name using "$issuesOriginal\Updated_Midline_Survey_Questions.dta"
rename hh_name_complet_resp individ
drop _merge

merge m:1 individ using "C:\Users\admmi\Box\NSF Senegal\Data_Management\_CRDES_CleanData\Baseline\Identified\All_Villages_With_Individual_IDs.dta"

* Step 2: Keep only matched (`_merge == 3`) or cases where hh_name_complet_resp is 999
keep if _merge == 3 | individ == "999"

* Step 3: Keep only the specified variables
* Export the dataset to Excel
//export excel using "$issues\Household_Issues_13Feb2025.xlsx", firstrow(variables) replace
merge m:m issue_variable_name using "$issuesOriginal\Updated_Midline_Survey_Questions.dta"
drop _merge
export excel using "$issuesOriginal\Part1_Household_Issues_26Feb2025.xlsx", firstrow(variables) replace

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
order villageid sup sup_name enqu enqu_name hh_phone hhid hh_name_complet_resp hh_name_complet_resp_new hh_member_name hh_13* hh_10*

drop
merge m:m issue_variable_name using "$issuesOriginal\Updated_Midline_Survey_Questions.dta"
	save "$hh13\Part2_Household_Issues_19Feb2025.dta", replace 
	export excel using "$hh13\Part2_Household_Issues_19Feb2025.xlsx", firstrow(variables) replace
	
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
order villageid sup sup_name enqu enqu_name hh_phone hhid hh_name_complet_resp hh_name_complet_resp_new hh_member_name hh_21* hh_18_*
merge m:m issue_variable_name using "$issuesOriginal\Updated_Midline_Survey_Questions.dta"
	save "$hh18\Part3_Household_Issues_19Feb2025.dta", replace 
	export excel using "$hh18\Part3_Household_Issues_19Feb2025.xlsx", firstrow(variables) replace

	
***** Replacment Survey **************
	clear
	local folder "$replacementsurvey"  

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
merge m:m issue_variable_name using "$issuesOriginal\Updated_Midline_Survey_Questions.dta"
	save "$replacementsurvey\ReplacementSurvey_Issues_26Feb2025.dta", replace 
	export excel using "$replacementsurvey\Replacement_Issues_26Feb2025.xlsx", firstrow(variables) replace
