*** DISES create complete identified data set *** 
*** File Created By: Molly Doruska ***
*** File Last Updated By: Molly Doruska ***
*** File Last Updated On: June 18, 2024 ***

clear all 

set maxvar 20000

**** Master file path  ****

if "`c(username)'"=="socrm" {
                global master "C:\Users\socrm\Box\NSF Senegal"
}
else if "`c(username)'"=="km978" {
                global master "C:\Users\km978\Box\NSF Senegal"
				
}
else if "`c(username)'"=="Kateri" {
                global master "C:\Users\Kateri\Box\NSF Senegal"
				
}

*** additional file paths ***
global data "$master\Data_Management\Output\Data_Processing\Checks\Corrections\Baseline"
global ids "$master\Data_Management\Output\Data_Processing\ID_Creation\Baseline"


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

