*** Household Data Corrections *** 
*** File Created By: Molly Doruska ***
*** File Last Updated By: Kateri Mouawad ***
*** Updates on GitHub ***

 *** This Do File PROCESSES: 
							* 
  
 *** This Do File CREATES:* 
                           

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
drop if key == "uuid:aa78d511-792e-413c-8c48-fe865ef31541"
drop if key == "uuid:c5c17b00-deb1-4c85-a135-2acc0ef130c5"
drop if key == "uuid:9017f1e5-a04c-44d9-89d0-d44eea3306e5"
drop if key == "uuid:c36d6125-ffb7-42f1-93cb-0159eaff1bd7"
drop if key == "uuid:a916410b-c591-437b-bffd-7e867ed25fc9"
drop if key == "uuid:c27692fc-dbf2-4516-8352-113dbba436f1"
drop if key == "uuid:eda339a8-b704-4ef4-9a40-6db0bbc3924d"
drop if key == "uuid:e02da6a0-cc1a-4ef7-887a-37198091a7aa"
drop if key == "uuid:b992c83d-579b-474d-9163-856b0c5c8ae1"

*** merge in household identifiers *** 
merge 1:m hh_phone hh_head_name_complet hh_name_complet_resp villageid using "$data\household_ids_8Feb24"

*** it does not match one household entry that didn't appear in the server until February 19 
*** and the duplicates identified previously in the word document *** 

*** drop the duplicates that we previously got rid of ***
drop if _merge == 2 

drop _merge dup


				*** Step 2: make corrections as needed *** 
						*** health module ***



*** agriculture module: ***



**need to insert legumineuses module:

*** income module ***



*** Step 6, drop household identifiers created in the data checks process *** 
drop hhid villageid 

** Error on village selection
** correction for DARA SALAM
replace	village_select	= 8 if key == "uuid:69032cea-f28f-496a-818d-81ac61d40d3c" | key == "uuid:36a316cd-5604-44a5-8123-96250db0a70a"
replace	hhid_village	= "082A" if key == "uuid:69032cea-f28f-496a-818d-81ac61d40d3c" | key == "uuid:36a316cd-5604-44a5-8123-96250db0a70a"
replace	region	= "SAINT LOUIS" if key == "uuid:69032cea-f28f-496a-818d-81ac61d40d3c" | key == "uuid:36a316cd-5604-44a5-8123-96250db0a70a"
replace	departement	= "PODOR" if key == "uuid:69032cea-f28f-496a-818d-81ac61d40d3c" | key == "uuid:36a316cd-5604-44a5-8123-96250db0a70a"
replace	commune	= "GUEDE VILLAGE" if key == "uuid:69032cea-f28f-496a-818d-81ac61d40d3c" | key == "uuid:36a316cd-5604-44a5-8123-96250db0a70a"
replace	village	= "DARA SALAM" if key == "uuid:69032cea-f28f-496a-818d-81ac61d40d3c" | key == "uuid:36a316cd-5604-44a5-8123-96250db0a70a"

** Correction for DIAMEL (DIAMEL DJIERY)
replace	village_select	= 14 if key == "uuid:ae2d7bf6-eb01-4188-b3e0-4a3e6cb9a8cb" | key == "uuid:66d2a11d-74b8-4cda-8076-a8a7dbfb0b1c" | key == "uuid:d446b75b-d113-4ac5-aadd-713cc2509ebf" | key == "uuid:b36d65d0-3364-44e6-915e-a51bbefe125c"
replace	hhid_village	= "040B" if key == "uuid:ae2d7bf6-eb01-4188-b3e0-4a3e6cb9a8cb" | key == "uuid:66d2a11d-74b8-4cda-8076-a8a7dbfb0b1c" | key == "uuid:d446b75b-d113-4ac5-aadd-713cc2509ebf" | key == "uuid:b36d65d0-3364-44e6-915e-a51bbefe125c"
replace	region	= "SAINT LOUIS" if key == "uuid:ae2d7bf6-eb01-4188-b3e0-4a3e6cb9a8cb" | key == "uuid:66d2a11d-74b8-4cda-8076-a8a7dbfb0b1c" | key == "uuid:d446b75b-d113-4ac5-aadd-713cc2509ebf" | key == "uuid:b36d65d0-3364-44e6-915e-a51bbefe125c"
replace	departement	= "PODOR" if key == "uuid:ae2d7bf6-eb01-4188-b3e0-4a3e6cb9a8cb" | key == "uuid:66d2a11d-74b8-4cda-8076-a8a7dbfb0b1c" | key == "uuid:d446b75b-d113-4ac5-aadd-713cc2509ebf" | key == "uuid:b36d65d0-3364-44e6-915e-a51bbefe125c"
replace	commune	= "NDIAYENE PENDAO" if key == "uuid:ae2d7bf6-eb01-4188-b3e0-4a3e6cb9a8cb" | key == "uuid:66d2a11d-74b8-4cda-8076-a8a7dbfb0b1c" | key == "uuid:d446b75b-d113-4ac5-aadd-713cc2509ebf" | key == "uuid:b36d65d0-3364-44e6-915e-a51bbefe125c"
replace	village	= "DIAMEL (DIAMEL DJIERY)" if key == "uuid:ae2d7bf6-eb01-4188-b3e0-4a3e6cb9a8cb" | key == "uuid:66d2a11d-74b8-4cda-8076-a8a7dbfb0b1c" | key == "uuid:d446b75b-d113-4ac5-aadd-713cc2509ebf" | key == "uuid:b36d65d0-3364-44e6-915e-a51bbefe125c"

** Correction for DOUE
replace  village_select	= 23 if key == "uuid:c4840dfc-5053-43b2-a766-19b47149d5cd" | key == "uuid:56c59f4e-ece9-46b3-8ed8-988c1b24f66f" | key == "uuid:f6a47ec3-02fa-4c06-a4c3-a9614152b0bd" | key == "uuid:1175d08e-b13b-4d46-a9c5-022a4918ab05"
replace hhid_village	= "091A" if key == "uuid:c4840dfc-5053-43b2-a766-19b47149d5cd" | key == "uuid:56c59f4e-ece9-46b3-8ed8-988c1b24f66f" | key == "uuid:f6a47ec3-02fa-4c06-a4c3-a9614152b0bd" | key == "uuid:1175d08e-b13b-4d46-a9c5-022a4918ab05"
replace region	= "SAINT LOUIS" if key == "uuid:c4840dfc-5053-43b2-a766-19b47149d5cd" | key == "uuid:56c59f4e-ece9-46b3-8ed8-988c1b24f66f" | key == "uuid:f6a47ec3-02fa-4c06-a4c3-a9614152b0bd" | key == "uuid:1175d08e-b13b-4d46-a9c5-022a4918ab05"
replace departement	= "PODOR" if key == "uuid:c4840dfc-5053-43b2-a766-19b47149d5cd" | key == "uuid:56c59f4e-ece9-46b3-8ed8-988c1b24f66f" | key == "uuid:f6a47ec3-02fa-4c06-a4c3-a9614152b0bd" | key == "uuid:1175d08e-b13b-4d46-a9c5-022a4918ab05"
replace commune	= "GUEDE VILLAGE" if key == "uuid:c4840dfc-5053-43b2-a766-19b47149d5cd" | key == "uuid:56c59f4e-ece9-46b3-8ed8-988c1b24f66f" | key == "uuid:f6a47ec3-02fa-4c06-a4c3-a9614152b0bd" | key == "uuid:1175d08e-b13b-4d46-a9c5-022a4918ab05"
replace village	= "DOUE" if key == "uuid:c4840dfc-5053-43b2-a766-19b47149d5cd" | key == "uuid:56c59f4e-ece9-46b3-8ed8-988c1b24f66f" | key == "uuid:f6a47ec3-02fa-4c06-a4c3-a9614152b0bd" | key == "uuid:1175d08e-b13b-4d46-a9c5-022a4918ab05"

** Correction for LEWAH (TEMEYE LEWAH)
replace	village_select = 45 if key == "uuid:dab56147-41bd-45e8-9b3e-a2748b49c232" | key == "uuid:c34d8f12-155a-40fb-bba8-6c49bd89cd49" | key == "uuid:0ffb7987-1cd7-432d-96c0-0e8e23a942ed" | key == "uuid:46ec7853-da27-421a-8fa4-d9568723fdeb"
replace	hhid_village = "080A" if key == "uuid:dab56147-41bd-45e8-9b3e-a2748b49c232" | key == "uuid:c34d8f12-155a-40fb-bba8-6c49bd89cd49" | key == "uuid:0ffb7987-1cd7-432d-96c0-0e8e23a942ed" | key == "uuid:46ec7853-da27-421a-8fa4-d9568723fdeb"
replace	region	= "SAINT LOUIS" if key == "uuid:dab56147-41bd-45e8-9b3e-a2748b49c232" | key == "uuid:c34d8f12-155a-40fb-bba8-6c49bd89cd49" | key == "uuid:0ffb7987-1cd7-432d-96c0-0e8e23a942ed" | key == "uuid:46ec7853-da27-421a-8fa4-d9568723fdeb"
replace	departement = "DAGANA" if key == "uuid:dab56147-41bd-45e8-9b3e-a2748b49c232" | key == "uuid:c34d8f12-155a-40fb-bba8-6c49bd89cd49" | key == "uuid:0ffb7987-1cd7-432d-96c0-0e8e23a942ed" | key == "uuid:46ec7853-da27-421a-8fa4-d9568723fdeb"
replace	commune	= "MBANE" if key == "uuid:dab56147-41bd-45e8-9b3e-a2748b49c232" | key == "uuid:c34d8f12-155a-40fb-bba8-6c49bd89cd49" | key == "uuid:0ffb7987-1cd7-432d-96c0-0e8e23a942ed" | key == "uuid:46ec7853-da27-421a-8fa4-d9568723fdeb"
replace	village	= "LEWAH (TEMEYE LEWAH)" if key == "uuid:dab56147-41bd-45e8-9b3e-a2748b49c232" | key == "uuid:c34d8f12-155a-40fb-bba8-6c49bd89cd49" | key == "uuid:0ffb7987-1cd7-432d-96c0-0e8e23a942ed" | key == "uuid:46ec7853-da27-421a-8fa4-d9568723fdeb"

** Correction for NGAOULE
replace	village_select	= 70 if key == "uuid:81da74d6-6d1d-4d9d-8cf2-aebcec510ad7" | key == "uuid:649caf3e-13f6-408a-ad3b-cea188fce5f3" | key == "uuid:1c93b24b-d5b4-4cc2-940a-8ce2ca69a022" | key == "uuid:5e0fb922-d3b1-4c38-be92-7b4cf13264fb"
replace	hhid_village	="083B" if key == "uuid:81da74d6-6d1d-4d9d-8cf2-aebcec510ad7" | key == "uuid:649caf3e-13f6-408a-ad3b-cea188fce5f3" | key == "uuid:1c93b24b-d5b4-4cc2-940a-8ce2ca69a022" | key == "uuid:5e0fb922-d3b1-4c38-be92-7b4cf13264fb"
replace	region	="SAINT LOUIS" if key == "uuid:81da74d6-6d1d-4d9d-8cf2-aebcec510ad7" | key == "uuid:649caf3e-13f6-408a-ad3b-cea188fce5f3" | key == "uuid:1c93b24b-d5b4-4cc2-940a-8ce2ca69a022" | key == "uuid:5e0fb922-d3b1-4c38-be92-7b4cf13264fb"
replace	departement	="PODOR" if key == "uuid:81da74d6-6d1d-4d9d-8cf2-aebcec510ad7" | key == "uuid:649caf3e-13f6-408a-ad3b-cea188fce5f3" | key == "uuid:1c93b24b-d5b4-4cc2-940a-8ce2ca69a022" | key == "uuid:5e0fb922-d3b1-4c38-be92-7b4cf13264fb"
replace	commune	="GUEDE VILLAGE" if key == "uuid:81da74d6-6d1d-4d9d-8cf2-aebcec510ad7" | key == "uuid:649caf3e-13f6-408a-ad3b-cea188fce5f3" | key == "uuid:1c93b24b-d5b4-4cc2-940a-8ce2ca69a022" | key == "uuid:5e0fb922-d3b1-4c38-be92-7b4cf13264fb"
replace	village	="NGAOULE" if key == "uuid:81da74d6-6d1d-4d9d-8cf2-aebcec510ad7" | key == "uuid:649caf3e-13f6-408a-ad3b-cea188fce5f3" | key == "uuid:1c93b24b-d5b4-4cc2-940a-8ce2ca69a022" | key == "uuid:5e0fb922-d3b1-4c38-be92-7b4cf13264fb"

** Correction for NGEUNDAR (GARAGE NGUENDAR)
replace	village_select	= 72 if key == "uuid:340c4c36-afa3-4290-8bc2-f154f78fd8f6" | key == "uuid:8d6ef456-6475-440e-bd70-3e0da5657b1f"
replace	hhid_village	= "082B" if key == "uuid:340c4c36-afa3-4290-8bc2-f154f78fd8f6" | key == "uuid:8d6ef456-6475-440e-bd70-3e0da5657b1f"
replace	region	= "SAINT LOUIS" if key == "uuid:340c4c36-afa3-4290-8bc2-f154f78fd8f6" | key == "uuid:8d6ef456-6475-440e-bd70-3e0da5657b1f"
replace	departement	= "PODOR" if key == "uuid:340c4c36-afa3-4290-8bc2-f154f78fd8f6" | key == "uuid:8d6ef456-6475-440e-bd70-3e0da5657b1f"
replace	commune	= "NDIAYENE PENDAO" if key == "uuid:340c4c36-afa3-4290-8bc2-f154f78fd8f6" | key == "uuid:8d6ef456-6475-440e-bd70-3e0da5657b1f"
replace	village	= "NGEUNDAR ( GARAGE NGUENDAR )" if key == "uuid:340c4c36-afa3-4290-8bc2-f154f78fd8f6" | key == "uuid:8d6ef456-6475-440e-bd70-3e0da5657b1f"

** Correction for NDIAYENE SARE
replace	village_select	= 63 if key == "uuid:168edb8b-01cb-4d4e-b2cd-4590a75bae12"
replace	hhid_village	="090B" if key == "uuid:168edb8b-01cb-4d4e-b2cd-4590a75bae12"
replace	region	="SAINT LOUIS" if key == "uuid:168edb8b-01cb-4d4e-b2cd-4590a75bae12"
replace	departement	="PODOR" if key == "uuid:168edb8b-01cb-4d4e-b2cd-4590a75bae12"
replace	commune	="NDIAYENE PENDAO" if key == "uuid:168edb8b-01cb-4d4e-b2cd-4590a75bae12"
replace	village	="NDIAYENE SARE" if key == "uuid:168edb8b-01cb-4d4e-b2cd-4590a75bae12"

** Correction for DIAMAL
replace	village_select	= 13  if key == "uuid:a145dab7-7108-4b9e-a1f4-661c7eb24d9f"
replace	hhid_village = "063B" if key == "uuid:a145dab7-7108-4b9e-a1f4-661c7eb24d9f"
replace	region	= "SAINT LOUIS" if key == "uuid:a145dab7-7108-4b9e-a1f4-661c7eb24d9f"
replace	departement = "PODOR" if key == "uuid:a145dab7-7108-4b9e-a1f4-661c7eb24d9f"
replace	commune	= "DODEL" if key == "uuid:a145dab7-7108-4b9e-a1f4-661c7eb24d9f"
replace	village	= "DIAMAL" if key == "uuid:a145dab7-7108-4b9e-a1f4-661c7eb24d9f"

** Correction for NDIAWARA
replace	village_select	= 60 if key == "uuid:5e744c2f-a415-45f5-b68a-b128cde38ac2"
replace	hhid_village	="050B" if key == "uuid:5e744c2f-a415-45f5-b68a-b128cde38ac2"
replace	region	="SAINT LOUIS" if key == "uuid:5e744c2f-a415-45f5-b68a-b128cde38ac2"
replace	departement	="PODOR" if key == "uuid:5e744c2f-a415-45f5-b68a-b128cde38ac2"
replace	commune	="GUEDE VILLAGE" if key == "uuid:5e744c2f-a415-45f5-b68a-b128cde38ac2"
replace	village	="NDIAWARA" if key == "uuid:5e744c2f-a415-45f5-b68a-b128cde38ac2"

** Correction for Ndialakhar wolof
replace	village_select	= 52 if key == "uuid:bbbf4645-10d1-4ed1-ab58-6d20df5135a0"
replace	hhid_village	= "111B" if key == "uuid:bbbf4645-10d1-4ed1-ab58-6d20df5135a0"
replace	region	= "SAINT LOUIS" if key == "uuid:bbbf4645-10d1-4ed1-ab58-6d20df5135a0"
replace	departement	= "SAINT LOUIS" if key == "uuid:bbbf4645-10d1-4ed1-ab58-6d20df5135a0"
replace	commune	= "GANDON" if key == "uuid:bbbf4645-10d1-4ed1-ab58-6d20df5135a0"
replace	village	= "Ndialakhar wolof" if key == "uuid:bbbf4645-10d1-4ed1-ab58-6d20df5135a0"

** Correction for SANEINTE TACQUE
replace	village_select	= 77 if key == "uuid:5b1098cb-0abb-4544-86d6-f0f7a8d88929"
replace	hhid_village	= "031B" if key == "uuid:5b1098cb-0abb-4544-86d6-f0f7a8d88929"
replace	region	= "SAINT LOUIS" if key == "uuid:5b1098cb-0abb-4544-86d6-f0f7a8d88929"
replace	departement	= "DAGANA" if key == "uuid:5b1098cb-0abb-4544-86d6-f0f7a8d88929"
replace	commune	= "MBANE" if key == "uuid:5b1098cb-0abb-4544-86d6-f0f7a8d88929"
replace	village	= "SANEINTE TACQUE" if key == "uuid:5b1098cb-0abb-4544-86d6-f0f7a8d88929"

** Phone number correction
replace	hh_phone = 775399114 if key == "uuid:8d6ef456-6475-440e-bd70-3e0da5657b1f"
replace	hh_phone = 772264525 if key == "uuid:d41bcb3d-8365-4cd5-99ba-1cc2f43e4a10"
replace	hh_phone = 772264525 if key == "uuid:c5c17b00-deb1-4c85-a135-2acc0ef130c5"
replace	hh_phone = 774203456 if key == "uuid:2bf999dd-b729-4474-8ea1-e0fac3b0ae9c"
replace	hh_phone = 773098731 if key == "uuid:7eff4c39-3617-482c-9403-a9b74fc214cd"
replace	hh_phone = 705378175 if key == "uuid:9a1e2bda-0479-418a-84a8-c73f3cf779bb"
replace	hh_phone = 775399114 if key == "uuid:c27692fc-dbf2-4516-8352-113dbba436f1"
replace	hh_phone = 777336768 if key == "uuid:c1773ffc-66d9-4678-bfe2-9146ef74cbad"
replace	hh_phone = 772069750 if key == "uuid:266e7302-1209-483b-830b-4730af7933a8"
replace	hh_phone = 776429414 if key == "uuid:f4bd7283-24f5-4b6b-8b01-b5fa0e549de6"
replace	hh_phone = 774228590 if key == "uuid:9ee74689-76ea-4c26-b794-5969021e65db"
replace	hh_phone = 764906608 if key == "uuid:a59c2370-93c1-42d1-847b-8ed69ce45bb9"
replace	hh_phone = 771742543 if key == "uuid:c0e64d45-1d40-4790-aa30-a1d9c0124908"

*** drop duplicated data *** 
quietly bysort hhid_village sup enqu hh_phone hh_head_name_complet hh_name_complet_resp hh_age_resp hh_gender_resp: gen dup = cond(_N==1,0,_n)

drop if dup == 2 
drop dup 


*** 8.	Add the code to create household identifiers with the corrected villages. 

********************* CREATE UNIQUE HOUSEHOLD IDENTIFIERS FOR NEW HOUSEHOLDS *************************




