*** DISES Baseline Data - Code used to validate list of particpants ***
*** File Created By: Kateri Mouawad ***
*** File Last Updated By: Kateri Mouawad ***
*** File Last Updated On: June 04, 2024 ***


 *** This Do File PROCESSES:
							* Complete_HouseholdIDs.dta, 
							* DISES_Export_participantlist.xlsx
							* Questionnaire participant d'intervention - NSF DISES_WIDE_13May24.csv
							
 
  *** This Do File CREATES: 
							** DISES_Export_participantlist.dta 
                            ** ParticipantListWithNames.dta
				*NOTE: 
							
 *** Procedure: 
 * (1) We first bring in the Questionnaire participant d'intervention data and clean the household IDs
 * (1) We then merge this with the Village ID .dta so we can have access to the names and phone numbers that correspond to these household IDs. 
 * (3) We then merge that new dataframe with the Questionaire participant List to verfity the names of each of the 10 respondents per village that were selected to receive follow up SMS ***
 
clear all 

*** set maximum variables to at least 20,000 ***
set maxvar 20000

**** Master file path  ****

if "`c(username)'"=="socrm" {
                global master "C:\Users\socrm\Box\NSF Senegal"
}
else if "`c(username)'"=="km978" {
                global master "C:\Users\km978\Box\NSF Senegal"
				
}

*** file paths ***

global data "$master\Baseline Data Collection\Surveys\Baseline CRDES data (April 2024)"
global data2 "$master\Baseline Data Collection\Surveys\Baseline CRDES data (Jan-Feb 2024)"
global output "$master\Data Work\Output\Data Corrections"
global eplsOutput "$master\Baseline Data Collection\EPLS and DISES data"
global village_observations "$master\Baseline Data Collection\Data Quality Checks\April Output\Village_Household_Identifiers"
global info_treat "$master\Data\Raw\Treatment"



*********************************** import DISES_Export_participantlist.xlsx *************************************************



import excel "$info_treat\DISES_Export_participantlist.xlsx", first clear 

save "$output\DISES_Export_participantlist.dta", replace 




*********************************** bring in Questionaire list and merge with hhid ********************************************

import delimited using "$info_treat\Questionnaire participant d’intervention - NSF DISES_WIDE_11June24.csv", clear


*** create duplicate list to send to CRDES *** 
preserve 

gen hhid = pull_select_name 
replace hhid = pull_select_hhid if pull_select_name == "" 

quietly bysort hhid: gen dup = cond(_N==1,0,_n)

drop if dup == 0

export excel using "$output\Duplicates_Comprehension_Questionnaire.xlsx", firstrow(variables) 

restore 
  
*** remove hyphens ***
gen hhid = subinstr(pull_select_name, "-", "", .)

drop if hhid == ""

*** bring in data to merge ***
merge m:1 hhid using "$output\Complete_HouseholdIDs.dta"

keep if _merge == 3

drop _merge 

save "$output\ParticipantListWithNames.dta", replace 

********************************* Initital data cleaning *********************************************************

* remove instances of duplicates in Participant list:


use "$info_treat\DISES_Export_participantlist.dta", clear
use "C:\Users\km978\Box\NSF Senegal\Information Treatments\Data\DISES_Export_participantlist.dta", clear
* duplicate check

	duplicates report hh_phone hh_name_complet_resp

	duplicates tag hh_phone hh_name_complet_resp, gen(dup_tag)
	sort hh_name_complet_resp
	
	keep if dup_tag >= 1
	tostring hh_phone, replace
	

*save "$info_treat\DISES_Export_participantlist_cleaned.dta", replace 

export excel using "$output\DISES_Export_participantlist_duplicates.xlsx", firstrow(variables) replace 


* remove instances of duplicates in participant d'intervention


use "$output\ParticipantListWithNames.dta", clear


	duplicates report hh_phone

	duplicates tag hh_phone hh_name_complet_resp, gen(dup_tag)
	
	count if dup_tag > 0
	
	duplicates drop hh_phone, force
	
	drop dup_tag 

save "$output\ParticipantListWithNames_cleaned.dta", replace

**************************************** Merge the data frames *******************************************************************


use "$output\ParticipantListWithNames_cleaned.dta", clear
	
	*** This captures those who are matching ***
	preserve 
	
merge m:1 hh_name_complet_resp hh_phone hhid_village using "$info_treat\DISES_Export_participantlist_cleaned.dta"

		keep if _merge == 3

		gen village_id= villageid + hhid_village

		sort village_id

		keep village_id hh_name_complet_resp key hh_phone _merge
		
		tostring hh_phone, replace 

save "$output\ParticipantList_Matched_cleaned.dta", replace
     restore 

	********************************** This captures DUPLICATES *****************************
	
preserve 
	merge m:m hh_name_complet_resp hh_phone hhid_village using "$info_treat\DISES_Export_participantlist_cleaned.dta"

		drop if _merge == 3
		********* check for duplciates:
		
		duplicates report hh_phone 

		duplicates tag hh_phone, gen(dup_tag)
		
		count if dup_tag > 0
		
		keep if dup_tag > 0
		
		sort hh_name_complet_resp
		
		duplicates drop hh_phone, force		
		
		drop dup_tag
		
		
		
		**********clean some other stuff 

		gen village_id= villageid + hhid_village

		sort village_id

		*keep village_id hh_name_complet_resp key hh_phone _merge
		
		tostring hh_phone, replace 

	save "$output\additionalMatches_cleaned.dta", replace

restore 

use "$output\additionalMatches_cleaned.dta"

*********************** Append the additional matches to get total amount:  ********************************************

preserve 
	use "$output\additionalMatches_cleaned.dta", clear
	append using "$output\ParticipantList_Matched_cleaned.dta"
	save "$output\ParticipantList_Matched_Final.dta"
restore 

	 *** This captures those who are in different lists ***

	 
	 
use "$output\ParticipantListWithNames_cleaned.dta", clear	 
	 
	 
preserve 
	merge m:m hh_name_complet_resp hh_phone hhid_village using "$info_treat\DISES_Export_participantlist_cleaned.dta"

		drop if _merge == 3
		********* check for duplciates:
		
		duplicates report hh_phone 

		duplicates tag hh_phone, gen(dup_tag)
		
		count if dup_tag > 0
		
		drop if dup_tag > 0
		
		sort _merge
		
		keep if _merge == 1
		
		drop dup_tag
		
		gen village_id= villageid + hhid_village

	*save "$output\MASTER_only.dta", replace
	
restore 
		
preserve 
	merge m:m hh_name_complet_resp hh_phone hhid_village using "$info_treat\DISES_Export_participantlist_cleaned.dta"

		drop if _merge == 3
		********* check for duplciates:
		
		duplicates report hh_phone 

		duplicates tag hh_phone, gen(dup_tag)
		
		count if dup_tag > 0
		
		drop if dup_tag > 0
		
		sort _merge
		
		keep if _merge == 2
		
		drop dup_tag
		
		gen village_id= villageid + hhid_village

	*save "$output\Using_only.dta", replace
	
restore 
		









