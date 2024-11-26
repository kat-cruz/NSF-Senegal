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
global output "$master\Baseline Data Collection\Data Quality Checks\Output"
global eplsOutput "$master\Baseline Data Collection\EPLS and DISES data"
global village_observations "$master\Baseline Data Collection\Data Quality Checks\April Output\Village_Household_Identifiers"

global info_treat "$master\Information Treatments\Data"



*********************************** import DISES_Export_participantlist.xlsx *************************************************


/*
import excel "$infoTreat\DISES_Export_participantlist.xlsx", first clear 

save "$infoTreat\DISES_Export_participantlist.dta", replace 
*/



*********************************** bring in Questionaire list and merge with hhid ********************************************

import delimited "$info_treat\Questionnaire participant d’intervention - NSF DISES_WIDE_13May24.csv", clear varnames(1) bindquote(strict)

*** remove hyphens ***
gen hhid = subinstr(pull_select_name, "-", "", .)

drop if hhid == ""

*** bring in data to merge ***
merge m:1 hhid using "$output\Complete_HouseholdIDs.dta"

keep if _merge == 3

drop _merge 

save "$output\ParticipantListWithNames.dta", replace 

***************************************** bring in participant list to verify the names ******************************************

use "$output\ParticipantListWithNames.dta", clear
	
	*** This captures those who are matching ***
	preserve 
merge m:m hh_name_complet_resp hh_phone hhid_village using "$info_treat\DISES_Export_participantlist.dta"

	keep if _merge == 3

	gen village_id= villageid + hhid_village

	sort village_id

	keep village_id hh_name_complet_resp key hh_phone _merge
	
	tostring hh_phone, replace 

save "$output\ParticipantList_Matched.dta", replace
     restore 

	 *** This captures those who are NOT matching up ***
	
	preserve 
merge m:m hh_name_complet_resp hh_phone hhid_village using "$info_treat\DISES_Export_participantlist.dta"

	drop if _merge == 3

	gen village_id= villageid + hhid_village

	sort village_id

	keep village_id hh_name_complet_resp key hh_phone _merge
	
	tostring hh_phone, replace 

save "$output\ParticipantList_NOT_Matched.dta", replace
     restore 


*************************** compare ********************************



*master = our dataset
*using only = hers 
*merge both village IDs, sort them, determine what is going on 

use "$info_treat\DISES_Export_participantlist.dta", clear

use "$output\ParticipantList_Matched.dta", clear



use "$output\ParticipantList_NOT_Matched.dta", clear

sort  _merge

sort hh_name_complet_resp

duplicates tag hh_phone, gen(dup_tag)

duplicates report hh_phone

duplicates tag hh_phone, gen(dup_tag)

* Count duplicates
count if dup_tag > 0

drop if dup_tag > 0

duplicates list hh_phone


************************************** clean out duplciates ************************************************************


use "$info_treat\DISES_Export_participantlist.dta", clear

*tostring hh_phone, replace 
* duplicate check

	duplicates report hh_phone

	duplicates tag hh_phone, gen(dup_tag)

	drop if dup_tag > 0



merge m:m hh_name_complet_resp hh_phone hhid_village using "$output\ParticipantListWithNames.dta"

   gen village_id= villageid + hhid_village
   
   keep if _merge == 3
   
   

   	preserve 
merge m:m hh_name_complet_resp hh_phone hhid_village using "$info_treat\DISES_Export_participantlist.dta"

	drop if _merge == 3

	gen village_id= villageid + hhid_village

	sort village_id

	keep village_id hh_name_complet_resp key hh_phone _merge
	
	tostring hh_phone, replace 

save "$output\ParticipantList_NOT_Matched.dta", replace
     restore




