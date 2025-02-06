*** Household Data Corrections *** 
*** File Created By: Molly Doruska ***
*** File Last Updated By: Kateri Mouawad ***
*** Updates on GitHub ***

*>>>>>>>>>>**--*--*--*--*--*--*--*--** READ ME **--*--*--*--*--*--*--*--**<<<<<<<<<<<*





 *** This Do File PROCESSES: 
							* 
  
 *** This Do File CREATES:* 
                           

clear all 

set maxvar 20000

**** Master file path  ****


* Set base Box path for each user
if "`c(username)'"=="socrm" global master "C:\Users\socrm\Box"
if "`c(username)'"=="kls329" global master "C:\Users\kls329\Box"
if "`c(username)'"=="km978" global master "C:\Users\km978\Box\NSF Senegal"
if "`c(username)'"=="Kateri" global master "C:\Users\Kateri\Box\NSF Senegal"
if "`c(username)'"=="admmi" global master "C:\Users\admmi\Box\NSF Senegal"

*** additional file paths ***
global data "$master\Surveys\Baseline CRDES data (Jan-Feb 2024)"
global data2 "$master\Surveys\Baseline CRDES data (April 2024)"

global village_observations "$master\Data Quality Checks\Code\Village_Household_Identifiers"
global household_roster "$master\Data Quality Checks\Code\Household_Roster"
global knowledge "$master\Data Quality Checks\Code\Knowledge"
global health "$master\Data Quality Checks\Code\Health" 
global agriculture_inputs "$master\Data Quality Checks\Code\Agriculture_Inputs"
global agriculture_production "$master\Data Quality Checks\Code\Agriculture_Production"
global food_consumption "$master\Data Quality Checks\Code\Food_Consumption"
global income "$master\Data Quality Checks\Code\Income"
global standard_living "$master\Data Quality Checks\Code\Standard_Living"
global beliefs "$master\Data Quality Checks\Code\Beliefs" 
global public_goods "$master\Data Quality Checks\Code\Public_Goods"
global enum_observations "$master\Data Quality Checks\Code\Enumerator_Observations"



/*
*** Step 1, merge in household identifiers to match the correction file *** 
*** Import data checks household ID numbers to merge *** 
import excel "$village_observations\HouseholdIDs_8Feb24.xlsx", clear firstrow

gen villageid = substr(hhid, 1, 4)

quietly bysort hh_phone hh_head_name_complet hh_name_complet_resp villageid: gen dup = cond(_N==1,0,_n)

save "$data\household_ids_8Feb24", replace 

*** Import data - update this every new data cleaning session ***
import delimited "$data\DISES_enquete_ménage_FINALE_WIDE_27Feb24.csv", clear varnames(1) bindquote(strict)

gen villageid = substr(village_select_o, 1, 4)

*** drop duplicated data *** 
drop if key == "uuid:37e8d522-be4e-4376-8bb7-91a970c58ece"

*** merge in household identifiers *** 
merge 1:m hh_phone hh_head_name_complet hh_name_complet_resp villageid using "$data\household_ids_8Feb24"

*** it does not match one household entry that didn't appear in the server until February 19 
*** and the duplicates identified previously in the word document *** 

*** drop the duplicates that we previously got rid of ***
drop if _merge == 2 

drop _merge dup


				*** Step 2: make corrections as needed *** 
						*** health module ***


*** Step 6, drop household identifiers created in the data checks process *** 
drop hhid villageid 

** Error on village selection
** correction for DARA SALAM

*** drop duplicated data *** 
quietly bysort hhid_village sup enqu hh_phone hh_head_name_complet hh_name_complet_resp hh_age_resp hh_gender_resp: gen dup = cond(_N==1,0,_n)

drop if dup == 2 
drop dup 


*** 8.	Add the code to create household identifiers with the corrected villages. 

********************* CREATE UNIQUE HOUSEHOLD IDENTIFIERS *************************


************************************ New 16 Villages CHECKS **********************************************
*