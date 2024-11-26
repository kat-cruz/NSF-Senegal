*** DISES Household Survey & Ecological Data - Combine Data Checks Files ***
*** Code Created By: Kateri Mouawad ****
*** Code Last Updated By: Kateri Mouawad ***
*** Code Last Modified: Feb 28, 2024 ***

clear all 
set maxvar 20000 

clear all 

global master "C:\Users\km978\Box\NSF Senegal\Baseline Data Collection"

global data1 "$master\Surveys\Baseline CRDES data (Jan-Feb 2024)"
global data2 "$master\Ecological data"
global file  "$master\Data Quality Checks\Other checks\Village code"
global file2  "$master\Ecological data"

*********************** household survey data ***************************************
clear
import delimited "$data1\DISES_enquete_ménage_FINALE_WIDE_6Feb24.csv", clear varnames(1) bindquote(strict)

	*keep hhid_village village_select village_select_o
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


save "$file\DISES_enquete_ménage_FINALE_WIDE_6Feb24_VILLAGE.dta", replace


************************** ecological data - sites  **********************************
clear 
set more off
import excel "$data2\Baseline ecological data Jan-Feb 2024.xlsx", sheet("Sites biocomposition") firstrow clear 

		******** label up/downstream values ********		
		
gen hhid_village = VillageCodes

preserve

local code = 114

* Loop through each observation
forvalues i = 1/`=_N' {
    * Increment the code only if the value is "Up/downstrem "
    if hhid_village[`i'] == "Up/downstrem " {
        local code = `code' + 1
        replace hhid_village = string(`code') + "u" in `i'
    }
}

save "$file\UpAndDownstream.dta", replace
restore


		******** remove dumplicates ********
clear
use "$file\UpAndDownstream.dta"

drop if Date == ""
  
	duplicates tag hhid_village, gen (dupe)
	tab dupe
	*correct dupelicate
	replace hhid_village = "071B" if Sites == "Diarra"
	drop dup 
	duplicates tag hhid_village, gen (dupe)
	tab dup
	drop dup 
	sort hhid_village
	label var hhid_village "Village Codes Corrected"
	*keep hhid_village Sites hhid_village dupe
	

save "$file2\Baseline ecological data Jan-Feb 2024 CORRECTED.dta", replace 
save "$file\Baseline ecological data Jan-Feb 2024 CORRECTED.dta", replace 

******************* merge data frames *****************
clear 
use "$file\DISES_enquete_ménage_FINALE_WIDE_6Feb24_VILLAGE.dta"
merge m:1 hhid_village using "$file\Baseline ecological data Jan-Feb 2024 CORRECTED.dta"
drop _merge
save "$file2\jan-feb2024_hhSurveyAndEcological_df_merged", replace
save "$file\jan-feb2024_hhSurveyAndEcological_df_merged", replace






