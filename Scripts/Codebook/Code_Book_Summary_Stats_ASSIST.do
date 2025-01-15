*** DISES Baseline Data - Code used assist with summary stats (those are located in an R markdown) ***
*** File Created By: Kateri Mouawad ***
*** File Last Updated By: Kateri Mouawad ***
*** File Last Updated On: August 2024 ***


 *** This Do File PROCESSES: DISES_Baseline_Complete_PII.dta
 
  *** This Do File CREATES: 

				
							
 *** Procedure: 
 
 
 
 
clear all 

*** set maximum variables to at least 20,000 ***
set maxvar 20000

**** Master file path  ****
**# Bookmark #1

if "`c(username)'"=="socrm" {
                global master "C:\Users\socrm\Box\NSF Senegal"
}
else if "`c(username)'"=="Kateri" {
                global master "C:\Users\Kateri\Box\NSF Senegal"
				
}
else if "`c(username)'"=="km978" {
                global master "C:\Users\km978\Box\NSF Senegal"
				
}

global hhid_df "$master\Data Management\_CRDES_CleanData\Baseline\Identified"
global com_df "$master\Data Management\_CRDES_CleanData\Baseline\Deidentified"
global hhid_dfs "$master\Data Management\_CRDES_CleanData\Baseline\Didentified"

use "$hhid_df\DISES_Baseline_Complete_PII.dta", clear

/*
use "$com_df\Complete_Baseline_Community.dta", clear

use "$com_df\Complete_Baseline_Household_Roster.dta", clear
*/

/*
keep hh_15_*

foreach var of varlist hh_15_* {
    if regexm("`var'", "hh_15_\\d+$") {
        display "`var'"
    }
}
*/





******************* Trying to find the hhid of the larger number *******************

* Step 1: Preserve the current dataset
preserve

	* Check the variables (adjust if necessary)
	describe hh_34*
	keep hh_34*  hh_full_name_calc_* hhid

	*keep hh_head_name_complet hh_full_name_calc_* hh_age_* hh_phone hhid hh_34* hh_gender*

	* Step 3: Reshape the dataset from wide to long
	*reshape long hh_34_ hh_full_name_calc_ hh_age_  hh_gender_, i(hhid) j(state_variable)
    reshape long hh_34_ hh_full_name_calc_, i(hhid) j(amount)

* Step 6: Restore the original dataset
restore

***********File paths that i need to update but don't want to ****************

use "C:\Users\km978\Box\NSF Senegal\Data Management\_CRDES_CleanData\Baseline\Deidentified\Complete_Baseline_Health.dta", clear 

use "C:\Users\km978\Box\NSF Senegal\Data Management\_CRDES_CleanData\Baseline\Deidentified\Complete_Baseline_Household_Roster.dta", clear 



* Step 1: Preserve the current dataset
preserve

use "C:\Users\km978\Box\NSF Senegal\Data Management\_CRDES_CleanData\Baseline\Deidentified\Complete_Baseline_Income.dta", clear 


*use "C:\Users\km978\Box\NSF Senegal\Data Management\_CRDES_CleanData\Baseline\Deidentified\Complete_Baseline_Community.dta", clear 

	* Check the variables (adjust if necessary)
	*describe hh_38*
	keep agri_6_33*  hhid

	*keep hh_head_name_complet hh_full_name_calc_* hh_age_* hh_phone hhid hh_34* hh_gender*

	* Step 3: Reshape the dataset from wide to long
	*reshape long hh_34_ hh_full_name_calc_ hh_age_  hh_gender_, i(hhid) j(state_variable)
    reshape long agri_6_33_, i(hhid) j(amount)

	tab agri_6_33_
* Step 6: Restore the original dataset
restore


tab speciesindex_6
tab speciesindex_5
tab speciesindex_4
tab speciesindex_3
tab speciesindex_2
tab speciesindex_1


tab speciesname_6
tab speciesname_5
tab speciesname_4
tab speciesname_3
tab speciesname_2
tab speciesname_1


keep agri_income_07* agri_income_08* speciesindex_* speciesname_*


keep hhid agri_income_07_1 agri_income_07_2 agri_income_08_1 agri_income_08_2 speciesindex_1 speciesindex_2 speciesname_1 speciesname_2

keep legumesname*


keep agri_income_09_2 speciesname_2









