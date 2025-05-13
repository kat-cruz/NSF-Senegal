*==============================================================================
* Program : Append corrected baseline identified data 
*=============================================================================
* written by: Molly Doruska
* updated by: Kateri Mouawad
* Created: June 18, 2024
* Updates recorded in GitHub

* <><<><><>> Read Me  <><<><><>>

	*^*^* This .do file processes:
	*** 							DISES_Baseline_Household_Corrected_PII
	
	
	*^*^* This .do file outputs:
	***							   DISES_Baseline_Complete_PII.dta
	
	
*<><<><><>><><<><><>>
**# INITIATE SCRIPT
*<><<><><>><><<><><>>
		
	clear all
	set mem 100m
	set maxvar 30000
	set matsize 11000
	set more off

*<><<><><>><><<><><>>
**# SET FILE PATHS
*<><<><><>><><<><><>>

*^*^* Set base Box path for each user
	if "`c(username)'"=="socrm" global master "C:\Users\socrm\Box\NSF Senegal"
	if "`c(username)'"=="kls329" global master "C:\Users\kls329\Box\NSF Senegal"
	if "`c(username)'"=="km978" global master "C:\Users\km978\Box\NSF Senegal"
	if "`c(username)'"=="Kateri" global master "C:\Users\Kateri\Box\NSF Senegal"
	if "`c(username)'"=="admmi" global master "C:\Users\admmi\Box\NSF Senegal"


*** additional file paths ***
	global data "$master\Data_Management\Output\Data_Processing\Checks\Corrections\Baseline"
	global ids "$master\Data_Management\Output\Data_Processing\ID_Creation\Baseline"
	global output "$master\Data_Management\Data\_CRDES_CleanData\Baseline\Identified"

*** import complete data for geographic and preliminary information ***
	use "$data\DISES_Baseline_Household_Corrected_PII", clear 

*** drop household ids *** 
	drop hhid 

*** merge in correct household ids ***
	merge 1:1 hhid_village sup enqu hh_phone hh_head_name_complet hh_name_complet_resp hh_age_resp hh_gender_resp using "$ids\HouseholdIDs_Original_88"

*** check to make sure merge worked correctly ***
		drop _merge 

*** append additional 16 village data ***
	append using "$data\DISES_Baseline_Additional16_Corrected_PII", force 

*** save complete identified dataset ***
	save "$data\DISES_Baseline_Complete_PII", replace

*** end of .do file