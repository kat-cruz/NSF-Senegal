*** DISES data create individual identifiers *** 
*** File Created By: Molly Doruska ***
*** File Last Updated By: Kateri Mouawad ***
*** File Last Updated On: May 21, 2024 ***

 * READ ME: This .Do file creates INDIVIDUAL unique identifiers with SELECTED variables for the purpose of performing individual level matches across other data sets.
 
 **PROCEDURE:
		* (1) Import CLEANED baseline data for ALL villages. 
		* (2) Move through the process of creating unique individual identifiers
		* (3) keep RELEVENT variabels. If you would like to add or remove certain variables, do so in the the keep section at line 63. 
		* (4) MAKE SURE TO CARRY THOSE VARIABLES OVER IN THE RESHAPE FEATURE 

  *** This Do File PROCESSES: ** DISES_Baseline_Complete_PII.dta 

  *** This Do File CREATES: 
							  ** All_Villages.dta
                   
				   
 ** UPDATE NOTES:

clear all 

set maxvar 20000

**** Master file path  ****

if "`c(username)'"=="socrm" {
                global master "C:\Users\socrm\Box\NSF Senegal\Data_Management"
}
else if "`c(username)'"=="km978" {
                global master "C:\Users\km978\Box\NSF Senegal\Data_Management"
				
}
else if "`c(username)'"=="Kateri" {
                global master "C:\Users\Kateri\Box\NSF Senegal\Data_Management"
				
}

*"C:\Users\socrm\Box\NSF Senegal\Data Management\_CRDES_CleanData\Baseline\Identified\DISES_Baseline_Complete_PII.dta"

*** additional file paths ***
*global data "$master\Data\_CRDES_CleanData\Baseline\Identified"
global data "$master\Output\Data_Processing\Checks\Corrections\Baseline"
*global village_observations "$master\Data Quality Checks\Output\April\Village_Household_Identifiers"
*global output "$master\Data Quality Checks\Output"
*global data2 "$master\Surveys\Baseline CRDES data (Jan-Feb 2024)"
*global eplsOutput "$master\_PartnerData\EPLS and DISES data\Household & Individual IDs"
global eplsOutput "$master\Output\Data_Processing\ID_Creation\Baseline\UCAD_EPLS_IDs"


*"C:\Users\socrm\Box\NSF Senegal\Data Management\_PartnerData\EPLS and DISES data\Household & Individual IDs\All_Villages.dta"

*** import complete household data *** 
use "$data\DISES_Baseline_Complete_PII.dta", clear 

*** verify household IDs are unique *** 
unique hhid 

tostring hh_relation_with_o*, replace 


keep hhid hhid_village sup enqu hh_head_name_complet hh_name_complet_resp hh_age_resp hh_gender_resp hh_full_name_calc* hh_gender* hh_age*  hh_relation_with* hh_phone


*** 4. Create the variable individual which is the index of which person in the household the observation is (the j variable in Stata) ***
reshape long hh_full_name_calc_ hh_gender_ hh_age_ hh_relation_with_ hh_relation_with_o_, i(hhid_village sup enqu hh_head_name_complet hh_name_complet_resp hh_age_resp hh_gender_resp hh_phone) j(individual)

*** drop if there is no individual ***
drop if hh_full_name_calc_ == "" & hh_gender_ == . & hh_age_ == . 


*** 5.	Create a new variable indiv_index which adds a leading zero where necessary to individual to create a two digit string. ***

gen indiv_index = string(individual, "%02.0f")

*** 6.	Create a new variable individ which adds indiv_index on to the household id. The first four digits of the new variable individ correspond to the village. The next two digits correspond to the household in the village. The last two digits correspond to the individual in the household. ***


gen individ = hhid + indiv_index

*** 7. Save as .dta file and excel spread sheet ***
save "$eplsOutput\All_Villages.dta", replace

*************************************** OLD CODE *******************************
*********************** From Original 88 and Additional 16 Villages ************

// *** import complete household data ***
*run full path 
*use "$data2\DISES_Baseline_Household_Corrected_PII.dta", clear 

*** drop household ids *** 
*drop hhid 

*** merge in correct household ids ***
*merge 1:1 hhid_village sup enqu hh_phone hh_head_name_complet hh_name_complet_resp hh_age_resp hh_gender_resp using "$data2\HouseholdIDs_Original_88"

*** check to make sure merge worked correctly ***
*drop _merge 

*** keep only identifiers and household names in roster data ***
*** need to rethink how to do this with the structure of the data and the reshape command *** 

*keep hhid hhid_village sup enqu hh_head_name_complet hh_name_complet_resp hh_age_resp hh_gender_resp hh_full_name_calc* hh_gender* hh_age*  hh_relation_with*

	*** verify household IDs are unique ***
*unique hhid 

*tostring hh_relation_with_o*, replace 

*** 4. Create the variable individual which is the index of which person in the household the observation is (the j variable in Stata) ***
*reshape long hh_full_name_calc_ hh_gender_ hh_age_ hh_relation_with_ hh_relation_with_o_, i(hhid_village sup enqu hh_head_name_complet hh_name_complet_resp hh_age_resp hh_gender_resp) j(individual)

		*** drop if there is no individual ***
*drop if hh_full_name_calc_ == "" & hh_gender_ == . & hh_age_ == . 


*** 5.	Create a new variable indiv_index which adds a leading zero where necessary to individual to create a two digit string. ***

*gen indiv_index = string(individual, "%02.0f")

*** 6.	Create a new variable individ which adds indiv_index on to the household id. The first four digits of the new variable individ correspond to the village. The next two digits correspond to the household in the village. The last two digits correspond to the individual in the household. ***


*gen individ = hhid + indiv_index

*rename hhid_village villageid 

*** 7. Save as .dta file and excel spread sheet ***

*save "$eplsOutput\Original88.dta"

*export excel using "$output\EPLSVillages_ToMatch.xlsx", firstrow(variables) sheet("Sheet 1") replace

*use "$eplsOutput\Original88.dta"

***************************************   FOR NEW EPLS VILLAGES: **************************************


*do the same thing as above with this data (i think) then append the two and then you can resave the villages specific to EPLS/UCAD


* THIS DATA >>>> HouseholdIDs_052024.xlsx

*import excel "$eplsOutput\HouseholdIDs_052024.xlsx", firstrow clear 

*save "$data2\HouseholdIDs_052024.dta", replace  

*** keep only identifiers and household names in roster data ***

*keep hhid villageid sup enqu hh_head_name_complet hh_name_complet_resp hh_age_resp hh_gender_resp hh_full_name_calc* hh_gender* hh_age*  hh_relation_with*

	*** verify household IDs are unique ***
*unique hhid 

*tostring hh_relation_with_o*, replace 

*** 4. Create the variable individual which is the index of which person in the household the observation is (the j variable in Stata) ***
*reshape long hh_full_name_calc_ hh_gender_ hh_age_ hh_relation_with_ hh_relation_with_o_, i(villageid sup enqu hh_head_name_complet hh_name_complet_resp hh_age_resp hh_gender_resp) j(individual)

		*** drop if there is no individual ***
*drop if hh_full_name_calc_ == "" & hh_gender_ == . & hh_age_ == . 


*** 5.	Create a new variable indiv_index which adds a leading zero where necessary to individual to create a two digit string. ***

*gen indiv_index = string(individual, "%02.0f")

*** 6.	Create a new variable individ which adds indiv_index on to the household id. The first four digits of the new variable individ correspond to the village. The next two digits correspond to the household in the village. The last two digits correspond to the individual in the household. ***


*gen individ = hhid + indiv_index

*** 7. Save as .dta file and excel spread sheet ***

*save "$eplsOutput\additional_16_villages.dta"

****************************************** Append both data files ******************************************


*use "$eplsOutput\Original88.dta", clear 

*append using "$eplsOutput\additional_16_villages.dta"



*** save complete dataset **
*save "$eplsOutput\All_Villages.dta"








