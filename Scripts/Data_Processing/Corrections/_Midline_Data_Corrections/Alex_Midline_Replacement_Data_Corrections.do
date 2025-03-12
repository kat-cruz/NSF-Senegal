*==============================================================================
* DISES Midline Replacement Data Corrections - Household Survey
* File originally created By: Alex Mills
* Updates recorded in GitHub: [Alex_Midline_Replacement_Data_Corrections.do](https://github.com/kat-cruz/NSF-Senegal/blob/main/Scripts/Data_Processing/Corrections/_Midline_Data_Corrections/Alex_Midline_Replacement_Data_Corrections.do)

*>>>>>>>>>>*===========================* READ ME *===========================*<<<<<<<<<<<*
*
* Description:
* This script performs data corrections for the DISES Midline Replacement Household Survey dataset using the corrections given in the external corrections files.
* Easiest to use an excel formula then check each correction to make sure qualitative answers correspond to the correct numeric answer from the raw survey CTO file.
*
* Key Functions:
* - Import corrected household survey data (`.dta` file).
* - Apply corrections to the household survey data.
* - Serves as a storage for all corrections made and those values that have been confirmed which need to be overlooked in the next round of checks.
*
* Inputs:
* - Survey Data: The corrected midline dataset (`CORRECTED_DISES_Enquête_ménage_midline_VF_WIDE_[DATE].dta`)
* - File Paths: Ensure that user-specific file paths in the `SET FILE PATHS` section are correctly configured.
*
* Outputs:
* - Corrected Household Replacement Data.
*
* Instructions to Run:
* 1. Update the file paths in the `"SET FILE PATHS"` section for the correct user.
* 2. Check the corrections date in the dataset import section.
* 3. Ensure all the corrections from the external corrections file have been added.
* 4. Run the script sequentially.
*
*==============================================================================

clear all
set mem 100m
set maxvar 30000
set matsize 11000
set more off

**************************************************
* SET FILE PATHS
**************************************************

* Set base Box path for each user
if "`c(username)'"=="socrm" global master "C:\Users\socrm\Box\NSF Senegal"
if "`c(username)'"=="kls329" global master "C:\Users\kls329\Box\NSF Senegal"
if "`c(username)'"=="km978" global master "C:\Users\km978\Box\NSF Senegal"
if "`c(username)'"=="Kateri" global master "C:\Users\Kateri\Box\NSF Senegal"
if "`c(username)'"=="admmi" global master "C:\Users\admmi\Box\NSF Senegal"


**************************** data file paths ****************************`		`	''

global data "$master\Data_Management\_CRDES_RawData\Midline\Replacement_Survey_Data"
global corrected "$master\Data_Management\Output\Data_Corrections\Midline"

**************************** output file paths ****************************
global replacement_survey "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Replacement_Survey"


**************************** Import household data ****************************

* Note: update this every new data cleaning session ***

import delimited "$data\DISES_enquete_ménage_FINALE_MIDLINE_REPLACEMENT_WIDE_5Mar2025.csv", clear varnames(1) bindquote(strict)

* corrections
* use excel formula
* =" replace ind_var = 0 if key == "&CHAR(34)&C2&CHAR(34)& " & " &I2&" == " &K2
/*
 replace ind_var = 0 if key == "uuid:c59bbc4f-9426-4fc7-af1b-90cd2f45f212" & legumineuses_05_1 == 300
 replace ind_var = 0 if key == "uuid:255cbd5b-d7d5-4d66-936e-d69eb3590068" & agri_6_28_1 == NON
 replace ind_var = 0 if key == "uuid:e5d59263-f7b5-4f04-b343-67af288c3c40" & cereals_02_1 == 13500
 replace ind_var = 0 if key == "uuid:e5d59263-f7b5-4f04-b343-67af288c3c40" & legumes_03_3 == 200
 replace ind_var = 0 if key == "uuid:e5d59263-f7b5-4f04-b343-67af288c3c40" & legumes_04_3 == 4000
 replace ind_var = 0 if key == "uuid:e5d59263-f7b5-4f04-b343-67af288c3c40" & legumineuses_05_3 == 300
 replace ind_var = 0 if key == "uuid:909b828e-39cf-46ee-808d-d6f086a2f478" & legumineuses_05_3 == 300
 drop if key == "uuid:26e52230-439a-47ec-962f-46ced28555e7" & agri_income_45_6 == -9
 replace ind_var = 0 if key == "uuid:e492cbe3-8d65-4645-a129-c7e6e075696a" & agri_6_38_a_2 == 0
 replace ind_var = 0 if key == "uuid:3f36eea9-5b56-463d-ab14-5ed51726f204" & hh_phone == 786146562
 replace ind_var = 0 if key == "uuid:83605234-d756-46d1-b633-9a3da11ef813" & legumineuses_05_1 == 300
 replace ind_var = 0 if key == "uuid:64a3cbc6-e8b8-4e8f-b508-bdb4d8a0abc9" & agri_income_23_1 == -9
 replace ind_var = 0 if key == "uuid:64a3cbc6-e8b8-4e8f-b508-bdb4d8a0abc9" & hh_13_1_total == 62
 replace ind_var = 0 if key == "uuid:64a3cbc6-e8b8-4e8f-b508-bdb4d8a0abc9" & hh_13_8_total == 3
 replace ind_var = 0 if key == "uuid:10b77926-7c29-4fec-8e2c-a8153d83dfe7" & hh_13_3_total == 18
*/

replace legumineuses_05_1 = 300 if key == "uuid:c59bbc4f-9426-4fc7-af1b-90cd2f45f212"
replace agri_6_28_1 = 0 if key == "uuid:255cbd5b-d7d5-4d66-936e-d69eb3590068"
replace cereals_02_1 = 13500 if key == "uuid:e5d59263-f7b5-4f04-b343-67af288c3c40"
replace legumes_03_3 = 200 if key == "uuid:e5d59263-f7b5-4f04-b343-67af288c3c40"
replace legumes_04_3 = 4000 if key == "uuid:e5d59263-f7b5-4f04-b343-67af288c3c40"
replace legumineuses_05_3 = 300 if key == "uuid:e5d59263-f7b5-4f04-b343-67af288c3c40"
replace legumineuses_05_3 = 300 if key == "uuid:909b828e-39cf-46ee-808d-d6f086a2f478"
replace agri_income_45_6 = -9 if key == "uuid:26e52230-439a-47ec-962f-46ced28555e7"
replace agri_6_38_a_2 = 0 if key == "uuid:e492cbe3-8d65-4645-a129-c7e6e075696a"
replace hh_phone = 786146562 if key == "uuid:3f36eea9-5b56-463d-ab14-5ed51726f204"
replace legumineuses_05_1 = 300 if key == "uuid:83605234-d756-46d1-b633-9a3da11ef813"
replace agri_income_23_1 = -9 if key == "uuid:64a3cbc6-e8b8-4e8f-b508-bdb4d8a0abc9"

* Village ID was wrong for one of the replacements missing 103B was put as 062B
replace hhid_village = "102B" if hhid_village == "062B"

* Save the corrected dataset
export delimited using "$corrected\CORRECTED_DISES_enquete_ménage_FINALE_MIDLINE_REPLACEMENT_WIDE_12Mar2025.csv", replace

save "$corrected\CORRECTED_DISES_enquete_ménage_FINALE_MIDLINE_REPLACEMENT_WIDE_12Mar2025.dta", replace



