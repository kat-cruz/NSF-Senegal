*** DISES Treatment Data - Code used to deidentify treatment data ***
*** File Created By: Molly Doruska ***
*** File Last Updated By: Molly Doruska ***
*** File Last Updated On: October 21, 2024 ***


 *** This Do File PROCESSES: Treated_variables_df.dta
 
  *** This Do File CREATES: treatment_indicator_PII.dta, treatment_indicator.dta, treatment_planning_exercise_PII.dta, treatment_planning_exercise.dta, treatment_comprehension_PII.dta, treatment_comprehension.dta
				
							
 *** Procedure: 
 *(1) Run the file paths
 *(2) Load in the data
 *(3) Run the script that gets rid of PII in the treatment data 
 *(4) Save the de-idnetified data
 
clear all
set more off 

*** set maximum variables to at least 20,000 ***
set maxvar 20000

**** Master file path  ****

if "`c(username)'"=="socrm" {
                global master "C:\Users\socrm\Box\NSF Senegal"
}
else if "`c(username)'"=="Kateri" {
                global master "C:\Users\Kateri\Box\NSF Senegal"
				
}
else if "`c(username)'"=="km978" {
                global master "C:\Users\km978\Box\NSF Senegal"
				
}

*** file paths *** 
global output  "$master\Data Management\Output\Data Corrections\Treatments"
global deidentifed "$master\Data Management\_CRDES_CleanData\Treatment\Deidentified"
global identifed "$master\Data Management\_CRDES_CleanData\Treatment\Identified"
global raw "$master\Data Management\_CRDES_RawData\Treatment"

*** import dataset of treatment hosuehold and treatment individual indicator variables ***
use "$output/Treated_variables_df.dta", clear

save "$identifed\treatment_indicator_PII.dta", replace 

*** deidentify data *** 
keep hhid individ trained_hh trained_indiv 

save "$deidentifed\treatment_indicator.dta", replace 

*** import raw planning exercise survey *** 
import delimited "$raw\Exercice de planification_WIDE_21Oct24.csv", varnames(1) bindquote(strict) clear 

*** drop pilot *** 
drop if village_select == -999

*** save complete identifed data *** 
save "$identifed\treatment_planning_exercise_PII.dta", replace 

*** get rid of identifying data *** 
drop username device_info devicephonenum caseid sup_o sup_label sup_name chef_name relais_name chef_phone q_12 q_13 q_17 q_18 instanceid formdef_version key y_loc_dec x_loc_dec

*** save deidentifed data *** 
save "$deidentifed\treatment_planning_exercise.dta", replace 

*** import raw comprehension survey *** 
import excel "$raw\DISES_Export_info_08072024_v2 review.xlsx", first clear 

replace treatment_arms_survey = "A" if hhid_village == "021B"
replace treatment_arms_original = "1B" if hhid_village == "021B"
replace treatment_arms_survey = "B" if hhid_village == "062B"
replace treatment_arms_original = "2B" if hhid_village == "062B"

*** save complete identified data ***
save "$identifed\treatment_comprehension_PII.dta", replace  

*** drop identifiying variables *** 
drop hh_phone hh_head_name_complet hh_name_complet_resp hh_age_resp hh_gender_resp deviceid devicephonenum username device_info caseid formdef_version key 

*** save deidentified data *** 
save "$deidentifed\treatment_comprehension.dta", replace 