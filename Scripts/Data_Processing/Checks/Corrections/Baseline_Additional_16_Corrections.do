*** Household Data Corrections for additional 16 villages*** 
*** File Created By: Kateri Mouawad ***
*** Updates recorded in Git ***


* <><<><><>> Read Me  <><<><><>>


 *^*^* This script corrects incorrect values that were caught in the Baseline Checks .do file
 ** 1) Load in final baseline data
 ** 2) Check and remove duplicates
 ** 3) Merge in with HHIDs to run checks
 ** 4) Run individual checks by replacing mistaken values 
 ** 5) Save final output 

 *^*^* NOTE: most recent update on 09 April 2025. We found an old village ID: 132A's should be 153A's. Since this was part of the later 16 villages that were added, updates were made only in the new village correction section. 


 *** This Do File PROCESSES: 
							* DISES_enquete_ménage_FINALE_V2_WIDE_26April24.csv
							* Compelte_HouseholdIDs_Final.dta
		
  
 *** This Do File CREATES:
						  * DISES_Baseline_Additional16_Corrected_PII
						  * householdIDs_april_updated_04092025.dta


clear all 

set maxvar 20000

**** Master file path  ****
if "`c(username)'"=="socrm" global master "C:\Users\socrm\Box\Data_Management"
if "`c(username)'"=="kls329" global master "C:\Users\kls329\Box\Data_Management"
if "`c(username)'"=="km978" global master "C:\Users\km978\Box\NSF Senegal\Data_Management"
if "`c(username)'"=="Kateri" global master "C:\Users\Kateri\Box\NSF Senegal\Data_Management"
if "`c(username)'"=="admmi" global master "C:\Users\admmi\Box\Data_Management"

*** additional file paths ***
global clean_data "$master\Data\_CRDES_CleanData\Baseline\Identified"
*global data2 "$master\Surveys\Baseline CRDES data (April 2024)"
global corrected_data "$master\Output\Data_Processing\Checks\Corrections\Baseline"
global raw_data "$master\Data\_CRDES_RawData\Baseline"
global ids   "$master\Output\Data_Processing\ID_Creation\Baseline"



*** Import data - update this every new data cleaning session ***
import delimited "$raw_data\DISES_enquete_ménage_FINALE_V2_WIDE_26April24.csv", clear varnames(1) bindquote(strict)
*** UPDATE village ID to merge with household IDs

*gen villageid = substr(village_select_o, 1, 4)
*replace villageid = "153A" if villageid == "132A"

replace hhid_village = "153A" if hhid_village == "132A"

*** 

*** drop duplicated data *** 
drop if key == "uuid:37e8d522-be4e-4376-8bb7-91a970c58ece"
drop if key == "uuid:aa78d511-792e-413c-8c48-fe865ef31541"
drop if key == "uuid:c5c17b00-deb1-4c85-a135-2acc0ef130c5"
drop if key == "uuid:9017f1e5-a04c-44d9-89d0-d44eea3306e5"
drop if key == "uuid:c36d6125-ffb7-42f1-93cb-0159eaff1bd7"
drop if key == "uuid:a916410b-c591-437b-bffd-7e867ed25fc9"
drop if key == "uuid:c27692fc-dbf2-4516-8352-113dbba436f1"
drop if key == "uuid:eda339a8-b704-4ef4-9a40-6db0bbc3924d"
drop if key == "uuid:e02da6a0-cc1a-4ef7-887a-37198091a7aa"
drop if key == "uuid:b992c83d-579b-474d-9163-856b0c5c8ae1"



************************************ New 16 Villages CHECKS **********************************************
*** Import data checks household ID numbers to merge *** 
*** UPDATE: Outdated file here, leaving as record but this won't run. 

/*
import excel "$april_id\HouseholdIDs_042624.xlsx", clear firstrow

*gen villageid = substr(hhid, 1, 4)

quietly bysort hh_phone hh_head_name_complet hh_name_complet_resp villageid: gen dup = cond(_N==1,0,_n)

save "$data\household_ids_april"
*/

*<><<><><>><><<><><>>
*SUBSET UPDATED VILLAGE IDS (Molly fixed the Compelte_HouseholdIDs_Final.dta to include the corrected hhids - changed all 132As to 153As)
*<><<><><>><><<><><>>

/*
use "$ids\Compelte_HouseholdIDs_Final.dta", clear


gen keepme = villageid == "122A" | villageid == "123A" | villageid == "121B" | ///
             villageid == "131B" | villageid == "120B" | villageid == "123B" | ///
             villageid == "153A" | villageid == "121A" | villageid == "131A" | ///
             villageid == "141A" | villageid == "142A" | villageid == "151A" | ///
             villageid == "161A" | villageid == "133A" | villageid == "171A" | ///
             villageid == "143A"

replace hhid_village = villageid
keep if keepme
drop keepme



keep hh_phone hh_head_name_complet hh_name_complet_resp villageid hhid_village hhid



save "$ids\householdIDs_april_updated_04092025.dta", replace 

*/

*<><<><><>><><<><><>>
* BRING IN DATA
*<><<><><>><><<><><>>

*** merge in household identifiers *** 
merge 1:1 hh_phone hh_head_name_complet hh_name_complet_resp hhid_village using "$ids\householdIDs_april_updated_04092025.dta"

*** drop the duplicates that we previously got rid of ***
drop if _merge == 2 

drop _merge 
*drop _merge dup

*<><<><><>><><<><><>>
* BEGIN CLEANING
*<><<><><>><><<><><>>

replace agri_6_38_a_code_1 = 1 if hhid == "153A02"
replace agri_6_38_a_code_1 = 1 if hhid == "141A16"
replace agri_6_38_a_code_1 = 1 if hhid == "143A02"
replace agri_6_38_a_code_1 = 1 if hhid == "120B01"
replace agri_6_38_a_code_1 = 1 if hhid == "120B16"
replace agri_6_38_a_code_1 = 1 if hhid == "121A04"
replace agri_6_38_a_code_1 = 1 if hhid == "121A07"
replace agri_6_38_a_code_1 = 1 if hhid == "121A14"
replace agri_6_38_a_code_1 = 1 if hhid == "121A20"
replace agri_6_38_a_code_1 = 1 if hhid == "153A17"
replace agri_6_38_a_code_1 = 1 if hhid == "153A18"
replace agri_6_38_a_code_1 = 1 if hhid == "153A20"
replace agri_6_38_a_code_1 = 1 if hhid == "141A17"

replace agri_6_39_a_code_1 = 1 if hhid == "121B01"
replace agri_6_39_a_code_1 = 1 if hhid == "121B08"
replace agri_6_39_a_code_1 = 1 if hhid == "131B03"
replace agri_6_39_a_code_1 = 1 if hhid == "131B07"
replace agri_6_39_a_code_1 = 1 if hhid == "131B09"
replace agri_6_39_a_code_1 = 1 if hhid == "120B01"
replace agri_6_39_a_code_1 = 1 if hhid == "120B04"
replace agri_6_39_a_code_1 = 1 if hhid == "120B16"
replace agri_6_39_a_code_1 = 1 if hhid == "153A05"
replace agri_6_39_a_code_1 = 1 if hhid == "153A07"
replace agri_6_39_a_code_1 = 1 if hhid == "153A13"


replace agri_6_39_a_code_1 = 1 if hhid == "153A15"
replace agri_6_39_a_code_1 = 1 if hhid == "121A04"
replace agri_6_39_a_code_1 = 1 if hhid == "121A07"
replace agri_6_39_a_code_1 = 1 if hhid == "141A03"
replace agri_6_39_a_code_1 = 1 if hhid == "141A06"
replace agri_6_39_a_code_1 = 1 if hhid == "141A14"
replace agri_6_39_a_code_1 = 1 if hhid == "143A03"
replace agri_6_39_a_code_1 = 1 if hhid == "143A08"
replace agri_6_39_a_code_1 = 1 if hhid == "143A15"
replace agri_6_39_a_code_1 = 1 if hhid == "121B09"

replace agri_6_39_a_code_1 = 1 if hhid == "121B10"
replace agri_6_39_a_code_1 = 1 if hhid == "121B17"
replace agri_6_39_a_code_1 = 1 if hhid == "131B05"
replace agri_6_39_a_code_1 = 1 if hhid == "131B12"
replace agri_6_39_a_code_1 = 1 if hhid == "120B08"
replace agri_6_39_a_code_1 = 1 if hhid == "123B06"
replace agri_6_39_a_code_1 = 1 if hhid == "123B11"
replace agri_6_39_a_code_1 = 1 if hhid == "123B14"
replace agri_6_39_a_code_1 = 1 if hhid == "153A11"
replace agri_6_39_a_code_1 = 1 if hhid == "143A07"

replace agri_6_39_a_code_1 = 1 if hhid == "143A12"
replace agri_6_39_a_code_1 = 1 if hhid == "121B02"
replace agri_6_39_a_code_1 = 1 if hhid == "121B05"
replace agri_6_39_a_code_1 = 1 if hhid == "131B13"
replace agri_6_39_a_code_1 = 1 if hhid == "131B16"
replace agri_6_39_a_code_1 = 1 if hhid == "120B02"
replace agri_6_39_a_code_1 = 1 if hhid == "120B05"
replace agri_6_39_a_code_1 = 1 if hhid == "120B06"
replace agri_6_39_a_code_1 = 1 if hhid == "120B11"
replace agri_6_39_a_code_1 = 1 if hhid == "123B04"

replace agri_6_39_a_code_1 = 1 if hhid == "123B07"
replace agri_6_39_a_code_1 = 1 if hhid == "123B13"
replace agri_6_39_a_code_1 = 1 if hhid == "153A01"
replace agri_6_39_a_code_1 = 1 if hhid == "153A02"
replace agri_6_39_a_code_1 = 1 if hhid == "153A08"
replace agri_6_39_a_code_1 = 1 if hhid == "153A10"
replace agri_6_39_a_code_1 = 1 if hhid == "121A09"
replace agri_6_39_a_code_1 = 1 if hhid == "121A12"
replace agri_6_39_a_code_1 = 1 if hhid == "141A01"
replace agri_6_39_a_code_1 = 1 if hhid == "141A04"

replace agri_6_39_a_code_1 = 1 if hhid == "141A16"
replace agri_6_39_a_code_1 = 1 if hhid == "143A02"
replace agri_6_39_a_code_1 = 1 if hhid == "143A10"
replace agri_6_39_a_code_1 = 1 if hhid == "143A16"
replace agri_6_39_a_code_1 = 1 if hhid == "121B11"
replace agri_6_39_a_code_1 = 1 if hhid == "121B12"
replace agri_6_39_a_code_1 = 1 if hhid == "121A18"
replace agri_6_39_a_code_1 = 1 if hhid == "121A20"
replace agri_6_39_a_code_1 = 1 if hhid == "123B17"

replace agri_6_39_a_code_1 = 1 if hhid == "123B18"
replace agri_6_39_a_code_1 = 1 if hhid == "131B19"
replace agri_6_39_a_code_1 = 1 if hhid == "131B20"
replace agri_6_39_a_code_1 = 1 if hhid == "153A17"
replace agri_6_39_a_code_1 = 1 if hhid == "153A18"
replace agri_6_39_a_code_1 = 1 if hhid == "153A19"
replace agri_6_39_a_code_1 = 1 if hhid == "153A20"
replace agri_6_39_a_code_1 = 1 if hhid == "141A17"
replace agri_6_39_a_code_1 = 1 if hhid == "141A18"
replace agri_6_39_a_code_1 = 1 if hhid == "141A19"
replace agri_6_39_a_code_1 = 1 if hhid == "143A18"
replace agri_6_39_a_code_1 = 1 if hhid == "143A19"
replace agri_6_39_a_code_1 = 1 if hhid == "143A20"
replace agri_6_39_a_code_1 = 1 if hhid == "151A02"


replace agri_6_39_a_code_2 = 1 if hhid == "141A17"
replace agri_6_39_a_code_2 = 1 if hhid == "121B03"
replace agri_6_39_a_code_2 = 1 if hhid == "121B08"
replace agri_6_39_a_code_2 = 1 if hhid == "121B17"
replace agri_6_39_a_code_2 = 1 if hhid == "120B14"
replace agri_6_39_a_code_2 = 1 if hhid == "123B11"
replace agri_6_39_a_code_2 = 1 if hhid == "121B02"
replace agri_6_39_a_code_2 = 1 if hhid == "120B06"
replace agri_6_39_a_code_2 = 1 if hhid == "120B11"
replace agri_6_39_a_code_2 = 1 if hhid == "123B04"
replace agri_6_39_a_code_2 = 1 if hhid == "123B07"
replace agri_6_39_a_code_2 = 1 if hhid == "153A08"
replace agri_6_39_a_code_2 = 1 if hhid == "153A10"
replace agri_6_39_a_code_2 = 1 if hhid == "143A10"

replace agri_6_39_a_code_3 = 1 if hhid == "121B08"
replace agri_6_39_a_code_3 = 1 if hhid == "121B02"

replace agri_6_40_a_code_1 = 1 if hhid == "151A10"
replace agri_6_40_a_code_1 = 1 if hhid == "123B01"
replace agri_6_40_a_code_1 = 1 if hhid == "121A14"
replace agri_6_40_a_code_1 = 1 if hhid == "141A03"
replace agri_6_40_a_code_1 = 1 if hhid == "131B16"
replace agri_6_40_a_code_1 = 1 if hhid == "120B02"
replace agri_6_40_a_code_1 = 1 if hhid == "153A02"
replace agri_6_40_a_code_1 = 1 if hhid == "121A12"
replace agri_6_40_a_code_1 = 1 if hhid == "143A02"
replace agri_6_40_a_code_1 = 1 if hhid == "143A10"
replace agri_6_40_a_code_1 = 1 if hhid == "121B07"

**here
replace agri_6_40_a_code_1 = 1 if hhid == "131B09"
replace agri_6_40_a_code_1 = 1 if hhid == "120B01"
replace agri_6_40_a_code_1 = 1 if hhid == "120B04"
replace agri_6_40_a_code_1 = 1 if hhid == "120B10"
replace agri_6_40_a_code_1 = 1 if hhid == "120B16"
replace agri_6_40_a_code_1 = 1 if hhid == "121A04"
replace agri_6_40_a_code_1 = 1 if hhid == "121A07"
*replace agri_6_40_a_code_1 = 1 if hhid == "131B09"
*replace agri_6_40_a_code_1 = 1 if hhid == "131B16"
replace agri_6_40_a_code_1 = 1 if hhid == "131B19"
replace agri_6_40_a_code_1 = 1 if hhid == "153A17"
replace agri_6_40_a_code_1 = 1 if hhid == "153A18"
replace agri_6_40_a_code_1 = 1 if hhid == "153A20"
replace agri_6_40_a_code_1 = 1 if hhid == "141A17"
replace agri_6_40_a_code_1 = 1 if hhid == "141A18"
replace agri_6_40_a_code_1 = 1 if hhid == "171A06"
replace agri_6_40_a_code_1 = 1 if hhid == "171A19"

replace agri_6_40_a_code_2 = 1 if hhid == "141A17"
replace agri_6_40_a_code_2 = 1 if hhid == "123B04"
replace agri_6_40_a_code_2 = 1 if hhid == "143A10"

replace agri_6_41_a_code_1 = 1 if hhid == "121B03"
replace agri_6_41_a_code_1 = 1 if hhid == "121B07"
replace agri_6_41_a_code_1 = 1 if hhid == "121B08"
replace agri_6_41_a_code_1 = 1 if hhid == "131B02"
replace agri_6_41_a_code_1 = 1 if hhid == "131B03"
replace agri_6_41_a_code_1 = 1 if hhid == "131B09"
replace agri_6_41_a_code_1 = 1 if hhid == "120B01"
replace agri_6_41_a_code_1 = 1 if hhid == "120B04"
replace agri_6_41_a_code_1 = 1 if hhid == "120B10"
replace agri_6_41_a_code_1 = 1 if hhid == "120B16"
replace agri_6_41_a_code_1 = 1 if hhid == "123B01"
replace agri_6_41_a_code_1 = 1 if hhid == "123B08"
replace agri_6_41_a_code_1 = 1 if hhid == "153A05"
replace agri_6_41_a_code_1 = 1 if hhid == "153A07"
replace agri_6_41_a_code_1 = 1 if hhid == "153A13"
replace agri_6_41_a_code_1 = 1 if hhid == "153A15"

replace agri_6_41_a_code_1 = 1 if hhid == "121A04"
replace agri_6_41_a_code_1 = 1 if hhid == "121A07"
replace agri_6_41_a_code_1 = 1 if hhid == "121A14"
replace agri_6_41_a_code_1 = 1 if hhid == "141A03"
replace agri_6_41_a_code_1 = 1 if hhid == "141A06"
replace agri_6_41_a_code_1 = 1 if hhid == "141A14"
replace agri_6_41_a_code_1 = 1 if hhid == "141A15"
replace agri_6_41_a_code_1 = 1 if hhid == "143A03"
replace agri_6_41_a_code_1 = 1 if hhid == "143A08"
replace agri_6_41_a_code_1 = 1 if hhid == "143A11"
replace agri_6_41_a_code_1 = 1 if hhid == "143A15"
replace agri_6_41_a_code_1 = 1 if hhid == "121B09"
replace agri_6_41_a_code_1 = 1 if hhid == "121B10"
replace agri_6_41_a_code_1 = 1 if hhid == "121B17"
replace agri_6_41_a_code_1 = 1 if hhid == "153A06"

replace agri_6_41_a_code_1 = 1 if hhid == "121B02"
replace agri_6_41_a_code_1 = 1 if hhid == "121B05"
replace agri_6_41_a_code_1 = 1 if hhid == "121B16"
replace agri_6_41_a_code_1 = 1 if hhid == "131B11"
replace agri_6_41_a_code_1 = 1 if hhid == "131B13"
replace agri_6_41_a_code_1 = 1 if hhid == "131B14"
replace agri_6_41_a_code_1 = 1 if hhid == "131B16"
replace agri_6_41_a_code_1 = 1 if hhid == "120B02"
replace agri_6_41_a_code_1 = 1 if hhid == "120B05"
replace agri_6_41_a_code_1 = 1 if hhid == "120B06"
replace agri_6_41_a_code_1 = 1 if hhid == "120B11"
replace agri_6_41_a_code_1 = 1 if hhid == "123B04"
replace agri_6_41_a_code_1 = 1 if hhid == "153A01"
replace agri_6_41_a_code_1 = 1 if hhid == "153A02"

replace agri_6_41_a_code_1 = 1 if hhid == "153A08"
replace agri_6_41_a_code_1 = 1 if hhid == "153A10"
replace agri_6_41_a_code_1 = 1 if hhid == "121A09"
replace agri_6_41_a_code_1 = 1 if hhid == "121A12"
replace agri_6_41_a_code_1 = 1 if hhid == "141A01"
replace agri_6_41_a_code_1 = 1 if hhid == "141A04"
replace agri_6_41_a_code_1 = 1 if hhid == "141A16"
replace agri_6_41_a_code_1 = 1 if hhid == "143A02"
replace agri_6_41_a_code_1 = 1 if hhid == "143A10"
replace agri_6_41_a_code_1 = 1 if hhid == "121B11"
replace agri_6_41_a_code_1 = 1 if hhid == "121B12"

replace agri_6_41_a_code_1 = 1 if hhid == "121B14"
replace agri_6_41_a_code_1 = 1 if hhid == "120B19"
replace agri_6_41_a_code_1 = 1 if hhid == "121A18"
replace agri_6_41_a_code_1 = 1 if hhid == "121A19"
replace agri_6_41_a_code_1 = 1 if hhid == "121A20"
replace agri_6_41_a_code_1 = 1 if hhid == "123B17"
replace agri_6_41_a_code_1 = 1 if hhid == "131B17"
replace agri_6_41_a_code_1 = 1 if hhid == "131B18"
replace agri_6_41_a_code_1 = 1 if hhid == "131B19"
replace agri_6_41_a_code_1 = 1 if hhid == "153A17"
replace agri_6_41_a_code_1 = 1 if hhid == "153A18"
replace agri_6_41_a_code_1 = 1 if hhid == "153A19"
replace agri_6_41_a_code_1 = 1 if hhid == "153A20"
replace agri_6_41_a_code_1 = 1 if hhid == "141A17"
replace agri_6_41_a_code_1 = 1 if hhid == "141A18"
replace agri_6_41_a_code_1 = 1 if hhid == "141A19"
replace agri_6_41_a_code_1 = 1 if hhid == "141A20"
replace agri_6_41_a_code_1 = 1 if hhid == "143A19"
replace agri_6_41_a_code_1 = 1 if hhid == "161A16"
replace agri_6_41_a_code_1 = 1 if hhid == "171A06"
replace agri_6_41_a_code_1 = 1 if hhid == "171A19"
replace agri_6_41_a_code_1 = 1 if hhid == "151A02"


replace agri_6_41_a_code_2 = 1 if hhid == "142A15"
replace agri_6_41_a_code_2 = 1 if hhid == "121B03"
replace agri_6_41_a_code_2 = 1 if hhid == "121B08"
replace agri_6_41_a_code_2 = 1 if hhid == "121B02"
replace agri_6_41_a_code_2 = 1 if hhid == "120B06"
replace agri_6_41_a_code_2 = 1 if hhid == "120B11"
replace agri_6_41_a_code_2 = 1 if hhid == "123B04"
replace agri_6_41_a_code_2 = 1 if hhid == "123B07"
replace agri_6_41_a_code_2 = 1 if hhid == "153A08"
replace agri_6_41_a_code_2 = 1 if hhid == "153A10"
replace agri_6_41_a_code_2 = 1 if hhid == "143A10"
replace agri_6_41_a_code_2 = 1 if hhid == "121A19"
replace agri_6_41_a_code_2 = 1 if hhid == "141A17"

replace agri_6_41_a_code_3 = 1 if hhid == "121B02"

replace cereals_01_1 = 0.5 if hhid == "123A10"

replace cereals_01_5 = 0.5 if hhid == "123A13"

replace cereals_02_1 = 208 if hhid == "141A03"
replace cereals_02_1 = 112 if hhid == "141A15"
replace cereals_02_1 = 130 if hhid == "142A03"
replace cereals_02_1 = 2240 if hhid == "142A07"
replace cereals_02_1 = 2870 if hhid == "142A08"
replace cereals_02_1 = 1400 if hhid == "142A18"
replace cereals_02_1 = 300 if hhid == "142A20"
replace cereals_02_1 = 4000 if hhid == "151A04"
replace cereals_02_1 = 250 if hhid == "151A12"
replace cereals_02_1 = 160 if hhid == "151A13"
replace cereals_02_1 = 1600 if hhid == "151A18"
replace cereals_02_1 = 162 if hhid == "133A06"
replace cereals_02_1 = 4800 if hhid == "141A17"


replace farines_02_1 = 160 if hhid == "153A15"
replace farines_02_1 = 120 if hhid == "143A03"
replace farines_02_1 = 100 if hhid == "143A15"

replace farines_02_2 = 250 if hhid == "120B01"

replace legumes_02_3 = 200 if hhid == "153A15"
replace legumes_02_3 = 250 if hhid == "143A15"

replace legumineuses_01_1 = 0.3 if hhid == "120B06"

replace legumineuses_02_1 = 104 if hhid == "153A15"

replace legumineuses_05_1 = 700 if hhid == "121B17"
replace legumineuses_05_1 = 600 if hhid == "143A12"
replace legumineuses_05_1 = 400 if hhid == "143A08"
replace legumineuses_05_1 = 0 if hhid == "133A04"
replace legumineuses_05_1 = 400 if hhid == "133A10"
replace legumineuses_05_1 = 0 if hhid == "171A02"
replace legumineuses_05_1 = 0 if hhid == "171A07"
replace legumineuses_05_1 = 0 if hhid == "171A11"

replace legumineuses_05_3 = 700 if hhid == "131B12"
replace legumineuses_05_3 = 0 if hhid == "133A12"
replace legumineuses_05_3 = 0 if hhid == "171A01"
replace legumineuses_05_3 = 500 if hhid == "171A06"
replace legumineuses_05_3 = 0 if hhid == "171A09"
replace legumineuses_05_3 = 0 if hhid == "171A11"
replace legumineuses_05_3 = 500 if hhid == "171A13"
replace legumineuses_05_3 = 0 if hhid == "171A17"
replace legumineuses_05_3 = 400 if hhid == "153A13"
replace legumineuses_05_3 = 400 if hhid == "153A15"
replace legumineuses_05_3 = 400 if hhid == "143A03"
replace legumineuses_05_3 = 400 if hhid == "143A08"
replace legumineuses_05_3 = 400 if hhid == "143A11"
replace legumineuses_05_3 = 400 if hhid == "143A15"
replace legumineuses_05_3 = 800 if hhid == "131B12"
replace legumineuses_05_3 = 600 if hhid == "153A11"
replace legumineuses_05_3 = 300 if hhid == "153A12"
replace legumineuses_05_3 = 300 if hhid == "120B06"
replace legumineuses_05_3 = 300 if hhid == "143A16"

replace legumineuses_05_4 = 0 if hhid == "133A03"
replace legumineuses_05_4 = 0 if hhid == "133A10"
replace legumineuses_05_4 = 0 if hhid == "133A18"
replace legumineuses_05_4 = 400 if hhid == "131B03"
replace legumineuses_05_4 = 600 if hhid == "131B04"

replace agri_income_03 = 10 if hhid == "123B01"
replace agri_income_03 = 11 if hhid == "123B03"
replace agri_income_03 = 9 if hhid == "121A13"
replace agri_income_03 = 7 if hhid == "141A15"

replace expenses_goods_t = 0 if hhid == "121B11"

replace agri_6_21_1 = 1.3 if hhid == "171A10"

replace agri_6_39_a_1 = 0 if hhid == "141A20"

replace agri_6_41_a_1 = 0 if hhid == "121A19"
replace agri_6_41_a_1 = 0 if hhid == "131B20"

replace farines_04_4 = 60000 if hhid == "143A17"

replace hh_age_6 = 53 if hhid == "122A18"

replace agri_6_41_a_1 = 1 if hhid == "153A06"

replace health_5_12_5 = 1 if hhid == "131A13"

replace agri_6_21_1 = 2.5 if hhid == "131A13"


replace o_culture_01 = 2.5 if hhid == "123A13"
replace o_culture_01 = 2.5 if hhid == "123A20"
replace o_culture_02 = 3000 if hhid == "123A20"

replace agri_income_07_2 = 150 if hhid == "122A03"

replace agri_income_08_2 = 1 if hhid == "122A03"

replace agri_income_23_1 = -9 if hhid == "123A04"

replace agri_income_43_1 = 75000 if hhid == "142A06"

replace agri_loan_name = 1 if hhid == "142A17"

replace face_04 = 1000 if hhid == "123A14"


save "$corrected_data\DISES_Baseline_Additional16_Corrected_PII.dta", replace 



































