*** DISES Baseline Data - Code used to create Household IDs***
*** File Created By: Molly Doruska ***
*** File Last Updated By: Molly Doruska ***
*** File Last Updated On: May 21, 2024 ***


 *** This Do File PROCESSES: DISES_enquete_ménage_FINALE_WIDE_6Feb24.csv, DISES_enquete_ménage_FINALE_V2_WIDE23April2024.csv, DISES_enquete_ménage_FINALE_V2_WIDE_26April2024.csv
 
  *** This Do File CREATES: 
							** HouseholdIDs.xlsx (these are the ID's for the original 88 villages)
                            ** HouseholdIDs_052024.xlsx (these are the ID's for the new 16 villages)
				*NOTE: We create these seperatley because we recieved the original data seperatley. The first step creates the Household IDs for the original 88 villages. The second step creates the Household IDs for the additional 16 villages
							
 *** Procedure: (This step is done after creating all Household IDs before to create one file with all household IDs)
 * (1) We create household IDs for the original 88 villages
 * (1) We then run a module for the new 16 villages that were survyed in April to create their unique HH IDs.
 * (3) We append the two data sets together to create one list of household IDs ***
 
clear all 

*** set maximum variables to at least 20,000 ***
set maxvar 20000

**** Master file path  ****

if "`c(username)'"=="socrm" {
                global master "C:\Users\socrm\Box\NSF Senegal\Baseline Data Collection"
}
else if "`c(username)'"=="km978" {
                global master "C:\Users\km978\Box\NSF Senegal\Baseline Data Collection"
				
}


*** file paths ***
global data "$master\Surveys\Baselin CRDES data (April 2024)"
global data2 "$master\Surveys\Baseline CRDES data (Jan-Feb 2024)"
global output "$master\Data Quality Checks\Output"
global eplsOutput "$master\EPLS and DISES data"
global village_observations "$master\Data Quality Checks\April Output\Village_Household_Identifiers"

*use "$data2\DISES_Baseline_Household_Corrected_PII.dta", clear 

******************************************* HOUSEHOLD IDS ********************************************

****** CREATE UNIQUE HOUSEHOLD IDENTIFIERS FOR ORIGINAL 88 Villages ************************
import delimited "$data2\DISES_enquete_ménage_FINALE_WIDE_6Feb24.csv", clear varnames(1) bindquote(strict)


sort village_select 

*** generate unique household integer in the village ***
by village_select: gen hh_num = _n 

*** create two digit unique string for each household in the village ***
gen hh_id_num = string(hh_num, "%02.0f") 

*** extract off the village id number ***
gen villageid = substr(village_select_o, 1, 4)

*** create unique household identifier using the village identier ***
*** and the household identifier ***
egen hhid = concat(villageid hh_id_num)

*** export file with IDs to household name and phone numbers ***
*** this file export would be what is appended together at the end ***

/*
preserve 
keep hhid hh_phone hh_head_name_complet hh_name_complet_resp 
export excel "$eplsOutput\HouseholdIDs_052024.xlsx", firstrow(variables)
restore 
*/

********************** CREATE UNIQUE HOUSEHOLD IDENTIFIERS FOR NEW 16 VILLAGES *************************


***************************************** MERGE THESE IDs WITH OG 88 ***************************************
***** WE SHOULD NEVER BE MERGEING ANYTHING BETWEEN THE OG 88 VILLAGES AND THE ADDITIONAL 16 VILLAGES *******
****** ONLY USE APPEND TO ADD ROWS TO THE BOTTOM OF THE DATA SET TO CREATE ONE FILE ************

**** create unique household IDs for set of EPLS villages done first *** 
import delimited "$data\DISES_enquete_ménage_FINALE_V2_WIDE23April2024.csv", clear varnames(1) bindquote(strict)

sort village_select 

*** generate unique household integer in the village ***
by village_select: gen hh_num = _n 

*** create two digit unique string for each household in the village ***
gen hh_id_num = string(hh_num, "%02.0f") 

*** extract off the village id number ***
gen villageid = substr(village_select_o, 1, 4)

*** create unique household identifier using the village identier ***
*** and the household identifier ***
egen hhid = concat(villageid hh_id_num)

*** export file with IDs to household name and phone numbers ***
*** this file export would be what is appended together at the end ***

/*
preserve 
keep hhid hh_phone hh_head_name_complet hh_name_complet_resp 
export excel "$villageobservations\HouseholdIDs_042324.xlsx", firstrow(variables)
save "$villgeobservations\HouseholdIDs_042324.dta"
restore 
*/

*** Bring in complete household data for additional 16 villages *** 
import delimited "$data\DISES_enquete_ménage_FINALE_V2_WIDE_26April2024.csv", clear varnames(1) bindquote(strict)

*** Bring in already created household IDs for the additional 16 villages ***
merge 1:1 villageid sup enqu hh_phone hh_head_name_complet hh_name_complet_resp hh_age_resp hh_gender_resp using "villgeobservations\HouseholdIDs_042324"

drop _merge 

*** extract off the village id number ***
replace villageid = substr(village_select_o, 1, 4) if villageid == ""
 
*** sort data by village ***
sort villageid hh_num  

*** create two digit unique string for each household in the village ***
by villageid: gen hh_num2 = _n 

replace hh_id_num = string(hh_num2, "%02.0f") if hh_id_num == "" 

*** create unique household identifier using the village identier ***
*** and the household identifier ***
egen hhid2 = concat(villageid hh_id_num) if hhid == ""

replace hhid = hhid2 if hhid == ""

*** drop extra variables to create the household IDs *** 
drop hh_id_num hh_num hh_num2 hhid2 

*** export file with IDs to household name and phone numbers ***
/*
preserve 
keep hhid villageid sup enqu hh_phone hh_head_name_complet hh_name_complet_resp hh_age_resp hh_gender_resp
export excel "$village_observations\HouseholdIDs_042624.xlsx", firstrow(variables)

restore 
*/


******* Combine Household ID files for original 88 villages and 16 additional villages 
import excel "$village_observations\HouseholdIDs_042624.xlsx", first clear 

append using "$data2\HouseholdIDs_Original_88"

*save "$output\Complete_HouseholdIDs"






