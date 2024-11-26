*** DISES data create individual identifiers *** 
*** File Created By: Molly Doruska ***
*** File Last Updated By: Kateri Mouawad ***
*** File Last Updated On: April 4, 2024 ***

clear all 

set maxvar 20000

**** Master file path  ****

if "`c(username)'"=="socrm" {
                global master "C:\Users\socrm\Box\NSF Senegal\Baseline Data Collection"
}
else if "`c(username)'"=="km978" {
                global master "C:\Users\km978\Box\NSF Senegal\Baseline Data Collection"
				
}

*** additional file paths ***
global data "$master\Surveys\Baseline CRDES data (Jan-Feb 2024)"
global output "$master\Data Quality Checks\Output"

*** ensure correct household identifiers ***
import excel "$data\HouseholdIDs_Original_88_Final_040224.xlsx", firstrow clear 

save "$data\HouseholdIDs_Original_88", replace 
*use "$data\HouseholdIDs_Original_88", clear

*** import complete household data ***
use "$data\DISES_Baseline_Household_Corrected_PII", clear 

*** drop household ids *** 
drop hhid 

*** merge in correct household ids ***
merge 1:1 hhid_village sup enqu hh_phone hh_head_name_complet hh_name_complet_resp hh_age_resp hh_gender_resp using "$data\HouseholdIDs_Original_88"

*** check to make sure merge worked correctly ***
drop _merge 

*** keep only identifiers and household names in roster data ***
*** need to rethink how to do this with the structure of the data and the reshape command *** 

keep hhid hhid_village sup enqu hh_head_name_complet hh_name_complet_resp hh_age_resp hh_gender_resp hh_full_name_calc* hh_gender* hh_age* 

	*** verify household IDs are unique ***
unique hhid 


*** 4. Create the variable individual which is the index of which person in the household the observation is (the j variable in Stata) ***
reshape long hh_full_name_calc_ hh_gender_ hh_age_ , i(hhid_village sup enqu hh_head_name_complet hh_name_complet_resp hh_age_resp hh_gender_resp) j(individual)

		*** drop if there is no individual ***
drop if hh_full_name_calc_ == "" & hh_gender_ == . & hh_age_ == . 


*** 5.	Create a new variable indiv_index which adds a leading zero where necessary to individual to create a two digit string. ***

gen indiv_index = string(individual, "%02.0f")

*** 6.	Create a new variable individ which adds indiv_index on to the household id. The first four digits of the new variable individ correspond to the village. The next two digits correspond to the household in the village. The last two digits correspond to the individual in the household. ***


gen individ = hhid + indiv_index

*** 7. Save as .dta file and excel spread sheet ***

save "$output\HouseholdIDs_Unique.dta", replace

export excel using "$output\HouseholdIDs_Unique.xlsx", firstrow(variables) sheet("Sheet 1") replace
