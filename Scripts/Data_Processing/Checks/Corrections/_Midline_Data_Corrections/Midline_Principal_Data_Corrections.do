*==============================================================================
* DISES Midline Data Corrections - School Principal Survey
* File originally created By: Alex Mills
* Updates recorded in GitHub: [Midline_Principal_Data_Corrections.do](https://github.com/kat-cruz/NSF-Senegal/blob/main/Scripts/Data_Processing/Corrections/_Midline_Data_Corrections/Midline_Principal_Data_Corrections.do)

*>>>>>>>>>>*===========================* READ ME *===========================*<<<<<<<<<<<*
*
* Description:
* This script processes and corrects the data from the Midline School Principal Survey for the NSF Senegal project. It includes data import, variable labeling, value checks, and exporting flagged issues for further review.
*
* Key Functions:
* - Import school principal survey data.
* - Set up file paths for different users.
* - Label variables and define value labels.
* - Perform value checks for missing or invalid data.
* - Export flagged issues to Stata and Excel files.
*
* Inputs:
* - **School Principal Survey Data:** The school principal dataset (`CORRECTED_DISES_Principal_Survey_MIDLINE_VF_WIDE_6Mar2025.xlsx`)
* - **File Paths:** Ensure that user-specific file paths in the `SET FILE PATHS` section are correctly configured.
*
* Outputs:
* - **Flagged Issues:** Data files with flagged issues for review (`Issue_SchoolPrincipal_*.dta`)
* - **Excel Reports:** Reports with flagged issues for review (`Issue_SchoolPrincipal_*.xlsx`)
*
* Instructions to Run:
* 1. Update the **file paths** in the `"SET FILE PATHS"` section for the correct user.
* 2. Run the script sequentially in Stata.
* 3. Verify that the flagged issues are correctly identified.
* 4. Check the flagged data and Excel reports saved in the specified directories.
*
*==============================================================================
* use excel formula 
* ="replace "&issue_variable_name&" = "&corrected&" if key == "&CHAR(34)&key&CHAR(34)



*==============================================================================

clear all
set more off
set maxvar 30000
set matsize 11000

**************************************************
* SET FILE PATHS
**************************************************

* Set base Box path for each user
if "`c(username)'"=="socrm" global box_path "C:\Users\socrm\Box\NSF Senegal"
if "`c(username)'"=="kls329" global box_path "C:\Users\kls329\Box\NSF Senegal"
if "`c(username)'"=="km978" global box_path "C:\Users\km978\Box\NSF Senegal"
if "`c(username)'"=="Kateri" global box_path "C:\Users\Kateri\Box\NSF Senegal"
if "`c(username)'"=="admmi" global box_path "C:\Users\admmi\Box\NSF Senegal"

* Define the master folder path
global master "$box_path\Data_Management"

* Define specific paths for output and input data
global data "$master\data\_CRDES_RawData\Midline\Principal_Survey_Data"
global schoolprincipal "$master\Output\Data_Processing\Checks\Midline\Midline_Principal_Issues"
global issues "$master\Output\Data_Quality_Checks\Midline\Midline_Principal_Issues"
global corrections "$master\External_Corrections\Issues for Justin and Amina\Midline\Issues"
global corrected "$master\Output\Data_Processing\Checks\Data_Corrections\Midline"

**************************************************
* IMPORT AND PROCESS CORRECTIONS FILE
**************************************************
/*
import excel "$corrections\CORRECTIONS_QUESTIONNAIRE_PRINCIPAL_Feb2025.xlsx", clear firstrow

* Save as a temporary file for later use
tempfile corrections_temp

keep if hhid_village == B

* Drop duplicate cases
duplicates drop hhid_village sup_name respondent_name respondent_phone_primary issue_variable_name print_issue, force

// save temp file of these corrections from Amina
save `corrections_temp'


**************************************************
* IMPORT ISSUES FILE AND MERGE WITH CORRECTIONS
**************************************************
* Import issues file containing the key
import excel "$issues\SchoolPrincipal_Issues_13Feb2025.xlsx", clear firstrow

* Drop duplicates to ensure unique entries
duplicates drop hhid_village sup_name respondent_name respondent_phone_primary issue_variable_name print_issue, force

* Generate a placeholder variable for correction values
//gen correction = .

* Merge corrections with issues using a one-to-one match based on identifiers
merge 1:1 hhid_village sup_name respondent_name respondent_phone_primary issue_variable_name print_issue using `corrections_temp'

* Keep only successfully merged observations (_merge == 3)
keep if _merge == 3
drop _merge

tempfile correctionskey_temp
save `correctionskey_temp'
* Save the corrections dataset including the key
export excel using "$issues\CORRECTIONS_QUESTIONNAIRE_PRINCIPAL_5Feb2025_key.xlsx", firstrow(variables) replace
*/

**************************************************
* APPLY CORRECTIONS TO SURVEY DATASET
**************************************************

import delimited "$data\DISES_Principal_Survey_MIDLINE_VF_WIDE_6Mar2025.csv", clear varnames(1) bindquote(strict)

* Dealt with the ones commented out in the daily checks because those are actually valid answers of i dont know
replace school_name = "ECOLE PRIMAIRE KASACK NORD" if key == "433515e7-f57f-4968-9fd1-d83a2cc493ed"
//replace passing_2024_female_1_1 = "Le nouveau directeur n'a pas le régistre de l'année derniére" if key == "uuid:1503ab7c-6da3-4662-b96d-7236229cf1d5"
//replace passing_2024_female_1_2 = "Le nouveau directeur n'a pas le régistre de l'année derniére" if key == "uuid:1503ab7c-6da3-4662-b96d-7236229cf1d5"
//replace passing_2024_female_2_1 = "Le nouveau directeur n'a pas le régistre de l'année derniére" if key == "uuid:1503ab7c-6da3-4662-b96d-7236229cf1d5"
//replace passing_2024_female_2_2 = "Le nouveau directeur n'a pas le régistre de l'année derniére" if key == "uuid:1503ab7c-6da3-4662-b96d-7236229cf1d5"
//replace passing_2024_female_3_1 = "Le nouveau directeur n'a pas le régistre de l'année derniére" if key == "uuid:1503ab7c-6da3-4662-b96d-7236229cf1d5"
//replace passing_2024_female_3_2 = "Le nouveau directeur n'a pas le régistre de l'année derniére" if key == "uuid:1503ab7c-6da3-4662-b96d-7236229cf1d5"
//replace passing_2024_female_4_1 = "Le nouveau directeur n'a pas le régistre de l'année derniére" if key == "uuid:1503ab7c-6da3-4662-b96d-7236229cf1d5"
//replace passing_2024_female_4_2 = "Le nouveau directeur n'a pas le régistre de l'année derniére" if key == "uuid:1503ab7c-6da3-4662-b96d-7236229cf1d5"
//replace passing_2024_female_5_1 = "Le nouveau directeur n'a pas le régistre de l'année derniére" if key == "uuid:1503ab7c-6da3-4662-b96d-7236229cf1d5"
//replace passing_2024_female_5_2 = "Le nouveau directeur n'a pas le régistre de l'année derniére" if key == "uuid:1503ab7c-6da3-4662-b96d-7236229cf1d5"
//replace passing_2024_female_6_1 = "Le nouveau directeur n'a pas le régistre de l'année derniére" if key == "uuid:1503ab7c-6da3-4662-b96d-7236229cf1d5"
//replace passing_2024_female_6_2 = "Le nouveau directeur n'a pas le régistre de l'année derniére" if key == "uuid:1503ab7c-6da3-4662-b96d-7236229cf1d5"
//replace passing_2024_total_1_1 = "Le nouveau directeur n'a pas le régistre de l'année derniére" if key == "uuid:1503ab7c-6da3-4662-b96d-7236229cf1d5"
//replace passing_2024_total_1_2 = "Le nouveau directeur n'a pas le régistre de l'année derniére" if key == "uuid:1503ab7c-6da3-4662-b96d-7236229cf1d5"
replace school_distance_river = 150 if key == "uuid:1503ab7c-6da3-4662-b96d-7236229cf1d5"
replace enrollment_2024_total_6_1 = 50 if key == "uuid:ebcbdc95-60c1-422f-8f04-1d3e6476fd06"
replace grade_loop_2 = 47 if key == "uuid:ebcbdc95-60c1-422f-8f04-1d3e6476fd06"
replace school_distance_river = 100 if key == "uuid:ebcbdc95-60c1-422f-8f04-1d3e6476fd06"
replace school_distance_river = 25 if key == "uuid:226708c5-70ec-4239-a011-7fed43bd24af"
replace school_distance_river = 100 if key == "uuid:b1671839-a3f7-4208-ade7-be102852852a"
replace school_distance_river = 200 if key == "uuid:3d5f2533-db3d-408c-8470-298a055466e5"
replace school_distance_river = 10 if key == "uuid:02b42cee-1536-4ffa-b4da-f743aba2f9f9"
replace school_name = "ECOLE PRIMAIRE FANAYE DIERY" if key == "uuid:647bd35f-ba4e-4d71-a0b3-91ee40c1ab90"
replace school_distance_river = 50 if key == "uuid:826f6865-e506-4f21-bdfa-3b9b919c6038"
replace school_distance_river = 150 if key == "uuid:f8f2f9c9-4a05-487b-9df1-e73abc040841"
replace school_distance_river = 100 if key == "uuid:340fb41d-7a90-4c7f-bc3c-9dc0a2cae877"
replace school_distance_river = 20 if key == "uuid:baab2814-72a1-4a37-aad1-e4ad960d982b"
replace school_name = "ECOLE PRIMAIRE DE GAMADJI SARE" if key == "uuid:baab2814-72a1-4a37-aad1-e4ad960d982b"
replace school_distance_river = 100 if key == "uuid:6150ed8c-4bb7-48c8-ab77-a9dcbe7443f0"
replace school_name = "ECOLE PRIMAIRE DE LERABE" if key == "uuid:6150ed8c-4bb7-48c8-ab77-a9dcbe7443f0"
replace school_distance_river = 100 if key == "uuid:1c9bdbcc-0f29-4938-8539-a12a8c3b5352"
replace school_name = "ECOLE PRIMAIRE FANAYE WALO" if key == "uuid:1c9bdbcc-0f29-4938-8539-a12a8c3b5352"
replace school_name = "ECOLE PRIMAIRE DE KHOR" if key == "uuid:431e16bd-2154-457d-b394-ae2c6cede5a8"
replace school_name = "ECOLE PRIMAIRE DE MBAKHANA" if key == "uuid:beb73689-535b-4c76-9057-be452d774559"

* corrections 2/24/2025
replace classroom_count_1 = 1 if key == "uuid:1a0ee54d-7385-46ca-a34f-7aa44595152e"
replace classroom_count_2 = 1 if key == "uuid:5ea415f5-cfc4-4ed2-b2e7-5cc9c7fa47c7"
replace classroom_count_3 = 1 if key == "uuid:d3e231f1-65b9-43d2-a70a-ac36b0126297"
replace school_distance_river = 50 if key == "uuid:02b42cee-1536-4ffa-b4da-f743aba2f9f9"
replace classroom_count_6 = 1 if key == "uuid:1a0ee54d-7385-46ca-a34f-7aa44595152e"
replace classroom_count_4 = 1 if key == "uuid:d3e231f1-65b9-43d2-a70a-ac36b0126297"
replace classroom_count_2 = 1 if key == "uuid:a1b8a221-60a3-4b01-bd52-730dcd8cbe50"
replace classroom_count_4 = 1 if key == "uuid:ea1555f3-97cd-42c3-b908-7b5ec9957af5"
replace classroom_count_5 = 1 if key == "uuid:1ddffda6-e7cc-4161-a527-3b6dd851a76c"
replace classroom_count_2 = 1 if key == "uuid:ea1555f3-97cd-42c3-b908-7b5ec9957af5"
replace school_distance_river = 100 if key == "uuid:5ea415f5-cfc4-4ed2-b2e7-5cc9c7fa47c7"
replace classroom_count_1 = 1 if key == "uuid:881d0069-391e-4c69-af6a-ce4fd190e375"
replace classroom_count_3 = 1 if key == "uuid:ea1555f3-97cd-42c3-b908-7b5ec9957af5"
replace classroom_count_2 = 1 if key == "uuid:d3e231f1-65b9-43d2-a70a-ac36b0126297"
replace classroom_count_1 = 1 if key == "uuid:a1b8a221-60a3-4b01-bd52-730dcd8cbe50"
replace classroom_count_1 = 1 if key == "uuid:ea1555f3-97cd-42c3-b908-7b5ec9957af5"
replace classroom_count_3 = 1 if key == "uuid:1ddffda6-e7cc-4161-a527-3b6dd851a76c"
replace classroom_count_2 = 1 if key == "uuid:881d0069-391e-4c69-af6a-ce4fd190e375"
replace classroom_count_4 = 1 if key == "uuid:881d0069-391e-4c69-af6a-ce4fd190e375"
replace classroom_count_4 = 1 if key == "uuid:a1b8a221-60a3-4b01-bd52-730dcd8cbe50"
replace classroom_count_1 = 1 if key == "uuid:aaa4b018-e8e4-4e7e-b1a9-84b36a78b731"
replace classroom_count_6 = 1 if key == "uuid:d3e231f1-65b9-43d2-a70a-ac36b0126297"
replace classroom_count_1 = 1 if key == "uuid:1ddffda6-e7cc-4161-a527-3b6dd851a76c"
replace classroom_count_1 = 1 if key == "uuid:602b5b07-79fc-444f-8aaf-eeb82521ce8e"
replace classroom_count_5 = 1 if key == "uuid:a1b8a221-60a3-4b01-bd52-730dcd8cbe50"
replace classroom_count_2 = 1 if key == "uuid:aaa4b018-e8e4-4e7e-b1a9-84b36a78b731"
replace classroom_count_1 = 1 if key == "uuid:aaa4b018-e8e4-4e7e-b1a9-84b36a78b731"
replace classroom_count_5 = 1 if key == "uuid:1a0ee54d-7385-46ca-a34f-7aa44595152e"
replace classroom_count_3 = 1 if key == "uuid:881d0069-391e-4c69-af6a-ce4fd190e375"
replace classroom_count_1 = 1 if key == "uuid:602b5b07-79fc-444f-8aaf-eeb82521ce8e"
replace classroom_count_4 = 1 if key == "uuid:aaa4b018-e8e4-4e7e-b1a9-84b36a78b731"
replace classroom_count_3 = 1 if key == "uuid:5ea415f5-cfc4-4ed2-b2e7-5cc9c7fa47c7"
replace classroom_count_1 = 1 if key == "uuid:d3e231f1-65b9-43d2-a70a-ac36b0126297"
replace classroom_count_2 = 1 if key == "uuid:602b5b07-79fc-444f-8aaf-eeb82521ce8e"
replace classroom_count_4 = 1 if key == "uuid:1a0ee54d-7385-46ca-a34f-7aa44595152e"
replace classroom_count_1 = 1 if key == "uuid:5ea415f5-cfc4-4ed2-b2e7-5cc9c7fa47c7"
replace classroom_count_1 = 1 if key == "uuid:5ea415f5-cfc4-4ed2-b2e7-5cc9c7fa47c7"
replace classroom_count_6 = 1 if key == "uuid:1ddffda6-e7cc-4161-a527-3b6dd851a76c"
replace classroom_count_4 = 1 if key == "uuid:1ddffda6-e7cc-4161-a527-3b6dd851a76c"
replace classroom_count_5 = 1 if key == "uuid:5ea415f5-cfc4-4ed2-b2e7-5cc9c7fa47c7"
replace classroom_count_1 = 1 if key == "uuid:1a0ee54d-7385-46ca-a34f-7aa44595152e"
replace classroom_count_5 = 1 if key == "uuid:ea1555f3-97cd-42c3-b908-7b5ec9957af5"
replace classroom_count_3 = 1 if key == "uuid:a1b8a221-60a3-4b01-bd52-730dcd8cbe50"
replace classroom_count_1 = 1 if key == "uuid:1ddffda6-e7cc-4161-a527-3b6dd851a76c"
replace classroom_count_5 = 1 if key == "uuid:d3e231f1-65b9-43d2-a70a-ac36b0126297"
replace classroom_count_6 = 1 if key == "uuid:5ea415f5-cfc4-4ed2-b2e7-5cc9c7fa47c7"
replace classroom_count_3 = 1 if key == "uuid:602b5b07-79fc-444f-8aaf-eeb82521ce8e"
replace classroom_count_6 = 1 if key == "uuid:a1b8a221-60a3-4b01-bd52-730dcd8cbe50"
replace classroom_count_6 = 1 if key == "uuid:aaa4b018-e8e4-4e7e-b1a9-84b36a78b731"
replace classroom_count_6 = 1 if key == "uuid:602b5b07-79fc-444f-8aaf-eeb82521ce8e"
replace classroom_count_3 = 1 if key == "uuid:1a0ee54d-7385-46ca-a34f-7aa44595152e"
replace school_name = "ECOLE ELEMENTAIRE GUEDE" if key == "uuid:602b5b07-79fc-444f-8aaf-eeb82521ce8e"
replace classroom_count_6 = 1 if key == "uuid:ea1555f3-97cd-42c3-b908-7b5ec9957af5"
replace classroom_count_6 = 1 if key == "uuid:881d0069-391e-4c69-af6a-ce4fd190e375"
replace classroom_count_1 = 1 if key == "uuid:d3e231f1-65b9-43d2-a70a-ac36b0126297"
replace classroom_count_1 = 1 if key == "uuid:ea1555f3-97cd-42c3-b908-7b5ec9957af5"
replace classroom_count_2 = 1 if key == "uuid:1a0ee54d-7385-46ca-a34f-7aa44595152e"
replace classroom_count_1 = 1 if key == "uuid:881d0069-391e-4c69-af6a-ce4fd190e375"
replace school_distance_river = 500 if key == "uuid:57d475b3-051c-4ae4-8b90-aa25c929303b"
replace classroom_count_1 = 1 if key == "uuid:a1b8a221-60a3-4b01-bd52-730dcd8cbe50"
replace classroom_count_2 = 1 if key == "uuid:1ddffda6-e7cc-4161-a527-3b6dd851a76c"
replace classroom_count_4 = 1 if key == "uuid:5ea415f5-cfc4-4ed2-b2e7-5cc9c7fa47c7"
replace classroom_count_5 = 1 if key == "uuid:881d0069-391e-4c69-af6a-ce4fd190e375"
replace classroom_count_4 = 1 if key == "uuid:602b5b07-79fc-444f-8aaf-eeb82521ce8e"
replace classroom_count_5 = 1 if key == "uuid:602b5b07-79fc-444f-8aaf-eeb82521ce8e"
* NOTE IN LOOP FOR CHECKS THIS KEY
/*
replace passing_2024_total_6_1 = le nouveau directeur ne dispose pas de ces informations if key == "uuid:9d8e7068-1bdc-4c3d-8575-29eb68d1794b"
replace passing_2024_female_4_1 = le nouveau directeur ne dispose pas de ces informations if key == "uuid:9d8e7068-1bdc-4c3d-8575-29eb68d1794b"
replace passing_2024_female_6_1 = le nouveau directeur ne dispose pas de ces informations if key == "uuid:9d8e7068-1bdc-4c3d-8575-29eb68d1794b"
replace passing_2024_female_3_1 = le nouveau directeur ne dispose pas de ces informations if key == "uuid:9d8e7068-1bdc-4c3d-8575-29eb68d1794b"
replace passing_2024_female_2_1 = le nouveau directeur ne dispose pas de ces informations if key == "uuid:9d8e7068-1bdc-4c3d-8575-29eb68d1794b"
replace passing_2024_total_5_1 = le nouveau directeur ne dispose pas de ces informations if key == "uuid:9d8e7068-1bdc-4c3d-8575-29eb68d1794b"
replace passing_2024_total_3_1 = le nouveau directeur ne dispose pas de ces informations if key == "uuid:9d8e7068-1bdc-4c3d-8575-29eb68d1794b"
replace passing_2024_female_5_1 = le nouveau directeur ne dispose pas de ces informations if key == "uuid:9d8e7068-1bdc-4c3d-8575-29eb68d1794b"
replace passing_2024_total_4_1 = le nouveau directeur ne dispose pas de ces informations if key == "uuid:9d8e7068-1bdc-4c3d-8575-29eb68d1794b"
*/
replace classroom_count_2 = 1 if key == "uuid:9c94b876-40a4-43e5-8be6-1510e5fdf3ba"
replace classroom_count_2 = 1 if key == "uuid:ebcbdc95-60c1-422f-8f04-1d3e6476fd06"
replace school_distance_river = 1 if key == "uuid:5b13f462-5794-4852-a956-5c3b11cf9953"
replace classroom_count_3 = 1 if key == "uuid:9c94b876-40a4-43e5-8be6-1510e5fdf3ba"
replace classroom_count_4 = 1 if key == "uuid:9c94b876-40a4-43e5-8be6-1510e5fdf3ba"
replace school_name = "ECOLE ELEMENTAIRE KASACK NORD"  if key == "uuid:433515e7-f57f-4968-9fd1-d83a2cc493ed"
replace classroom_count_4 = 1 if key == "uuid:c9cbaf66-6628-4825-bdd0-ee5577b838c4"
* NOTE IN LOOP FOR CHECKS FOR THIS KEY
//replace passing_2024_total_1_1 = le nouveau directeur ne dispose pas de ces informations if key == "uuid:9c94b876-40a4-43e5-8be6-1510e5fdf3ba"
replace classroom_count_5 = 1 if key == "uuid:9c94b876-40a4-43e5-8be6-1510e5fdf3ba"
replace classroom_count_6 = 1 if key == "uuid:c9cbaf66-6628-4825-bdd0-ee5577b838c4"
replace classroom_count_6 = 1 if key == "uuid:9c94b876-40a4-43e5-8be6-1510e5fdf3ba"
* NOTE IN LOOP FOR CHECKS FOR THIS KEY
*replace enrollment_2024_total_1_1 = le nouveau directeur ne dispose pas de ces informations if key == "uuid:9c94b876-40a4-43e5-8be6-1510e5fdf3ba"
*replace passing_2024_female_1_1 = le nouveau directeur ne dispose pas de ces informations if key == "uuid:9c94b876-40a4-43e5-8be6-1510e5fdf3ba"


* 24Feb2025
replace passing_2024_female_5_1 = -9 if key == "uuid:881d0069-391e-4c69-af6a-ce4fd190e375"
replace passing_2024_female_4_1 = -9 if key == "uuid:1a0ee54d-7385-46ca-a34f-7aa44595152e"
replace enrollment_2024_female_1_1 = -9 if key == "uuid:602b5b07-79fc-444f-8aaf-eeb82521ce8e"
replace enrollment_2024_female_4_1 = -9 if key == "uuid:602b5b07-79fc-444f-8aaf-eeb82521ce8e"
replace passing_2024_female_6_1 = -9 if key == "uuid:5ea415f5-cfc4-4ed2-b2e7-5cc9c7fa47c7"
replace enrollment_2024_total_4_1 = -9 if key == "uuid:881d0069-391e-4c69-af6a-ce4fd190e375"
replace enrollment_2024_total_4_1 = -9 if key == "uuid:1ddffda6-e7cc-4161-a527-3b6dd851a76c"
replace enrollment_2024_female_4_1 = -9 if key == "uuid:ea1555f3-97cd-42c3-b908-7b5ec9957af5"
replace passing_2024_total_3_1 = -9 if key == "uuid:d3e231f1-65b9-43d2-a70a-ac36b0126297"
replace school_distance_river = 100 if key == "uuid:602b5b07-79fc-444f-8aaf-eeb82521ce8e"
replace passing_2024_female_2_1 = -9 if key == "uuid:1ddffda6-e7cc-4161-a527-3b6dd851a76c"
replace passing_2024_total_6_1 = -9 if key == "uuid:a1b8a221-60a3-4b01-bd52-730dcd8cbe50"
replace enrollment_2024_female_5_1 = -9 if key == "uuid:ea1555f3-97cd-42c3-b908-7b5ec9957af5"
replace enrollment_2024_female_4_1 = -9 if key == "uuid:1a0ee54d-7385-46ca-a34f-7aa44595152e"
replace enrollment_2024_total_6_1 = -9 if key == "uuid:ea1555f3-97cd-42c3-b908-7b5ec9957af5"
replace enrollment_2024_female_2_1 = -9 if key == "uuid:a1b8a221-60a3-4b01-bd52-730dcd8cbe50"
replace passing_2024_total_6_1 = -9 if key == "uuid:d3e231f1-65b9-43d2-a70a-ac36b0126297"
replace passing_2024_total_5_1 = -9 if key == "uuid:ea1555f3-97cd-42c3-b908-7b5ec9957af5"
replace enrollment_2024_female_4_1 = -9 if key == "uuid:1ddffda6-e7cc-4161-a527-3b6dd851a76c"
replace passing_2024_total_5_1 = -9 if key == "uuid:a1b8a221-60a3-4b01-bd52-730dcd8cbe50"
replace enrollment_2024_female_5_1 = -9 if key == "uuid:1a0ee54d-7385-46ca-a34f-7aa44595152e"
replace passing_2024_total_4_1 = -9 if key == "uuid:d3e231f1-65b9-43d2-a70a-ac36b0126297"
replace passing_2024_total_1_1 = -9 if key == "uuid:1a0ee54d-7385-46ca-a34f-7aa44595152e"
replace passing_2024_total_5_1 = -9 if key == "uuid:5ea415f5-cfc4-4ed2-b2e7-5cc9c7fa47c7"
replace enrollment_2024_female_5_1 = -9 if key == "uuid:5ea415f5-cfc4-4ed2-b2e7-5cc9c7fa47c7"
replace passing_2024_total_3_1 = -9 if key == "uuid:602b5b07-79fc-444f-8aaf-eeb82521ce8e"
replace enrollment_2024_total_5_1 = -9 if key == "uuid:5ea415f5-cfc4-4ed2-b2e7-5cc9c7fa47c7"
replace enrollment_2024_total_5_1 = -9 if key == "uuid:d3e231f1-65b9-43d2-a70a-ac36b0126297"
replace passing_2024_female_1_1 = -9 if key == "uuid:5ea415f5-cfc4-4ed2-b2e7-5cc9c7fa47c7"
replace enrollment_2024_total_1_1 = -9 if key == "uuid:d3e231f1-65b9-43d2-a70a-ac36b0126297"
replace enrollment_2024_total_4_1 = -9 if key == "uuid:d3e231f1-65b9-43d2-a70a-ac36b0126297"
replace passing_2024_total_4_1 = -9 if key == "uuid:5ea415f5-cfc4-4ed2-b2e7-5cc9c7fa47c7"
replace enrollment_2024_female_3_1 = -9 if key == "uuid:1ddffda6-e7cc-4161-a527-3b6dd851a76c"
replace enrollment_2024_total_6_1 = -9 if key == "uuid:aaa4b018-e8e4-4e7e-b1a9-84b36a78b731"
replace passing_2024_total_3_1 = -9 if key == "uuid:1a0ee54d-7385-46ca-a34f-7aa44595152e"
replace enrollment_2024_total_3_1 = -9 if key == "uuid:d3e231f1-65b9-43d2-a70a-ac36b0126297"
replace passing_2024_total_4_1 = -9 if key == "uuid:881d0069-391e-4c69-af6a-ce4fd190e375"
replace enrollment_2024_female_1_1 = -9 if key == "uuid:d3e231f1-65b9-43d2-a70a-ac36b0126297"
replace enrollment_2024_female_5_1 = -9 if key == "uuid:881d0069-391e-4c69-af6a-ce4fd190e375"
replace enrollment_2024_total_6_1 = -9 if key == "uuid:a1b8a221-60a3-4b01-bd52-730dcd8cbe50"
replace enrollment_2024_female_4_1 = -9 if key == "uuid:881d0069-391e-4c69-af6a-ce4fd190e375"
replace passing_2024_total_6_1 = -9 if key == "uuid:1ddffda6-e7cc-4161-a527-3b6dd851a76c"
replace passing_2024_female_2_1 = -9 if key == "uuid:1a0ee54d-7385-46ca-a34f-7aa44595152e"
replace passing_2024_total_3_1 = -9 if key == "uuid:ea1555f3-97cd-42c3-b908-7b5ec9957af5"
replace passing_2024_total_4_1 = -9 if key == "uuid:602b5b07-79fc-444f-8aaf-eeb82521ce8e"
replace enrollment_2024_total_4_1 = -9 if key == "uuid:602b5b07-79fc-444f-8aaf-eeb82521ce8e"
replace enrollment_2024_female_2_1 = -9 if key == "uuid:1ddffda6-e7cc-4161-a527-3b6dd851a76c"
replace passing_2024_total_6_1 = -9 if key == "uuid:881d0069-391e-4c69-af6a-ce4fd190e375"
replace enrollment_2024_female_3_1 = -9 if key == "uuid:881d0069-391e-4c69-af6a-ce4fd190e375"
replace enrollment_2024_female_2_1 = -9 if key == "uuid:1a0ee54d-7385-46ca-a34f-7aa44595152e"
replace enrollment_2024_female_2_1 = -9 if key == "uuid:881d0069-391e-4c69-af6a-ce4fd190e375"
replace passing_2024_total_2_1 = -9 if key == "uuid:1a0ee54d-7385-46ca-a34f-7aa44595152e"
replace enrollment_2024_female_3_1 = -9 if key == "uuid:5ea415f5-cfc4-4ed2-b2e7-5cc9c7fa47c7"
replace enrollment_2024_female_1_1 = -9 if key == "uuid:5ea415f5-cfc4-4ed2-b2e7-5cc9c7fa47c7"
replace enrollment_2024_female_4_1 = -9 if key == "uuid:5ea415f5-cfc4-4ed2-b2e7-5cc9c7fa47c7"
replace passing_2024_total_1_1 = -9 if key == "uuid:a1b8a221-60a3-4b01-bd52-730dcd8cbe50"
replace passing_2024_total_4_1 = -9 if key == "uuid:ea1555f3-97cd-42c3-b908-7b5ec9957af5"
replace enrollment_2024_total_5_1 = -9 if key == "uuid:602b5b07-79fc-444f-8aaf-eeb82521ce8e"
replace passing_2024_female_1_1 = -9 if key == "uuid:aaa4b018-e8e4-4e7e-b1a9-84b36a78b731"
replace enrollment_2024_female_5_1 = -9 if key == "uuid:d3e231f1-65b9-43d2-a70a-ac36b0126297"
replace passing_2024_female_2_1 = -9 if key == "uuid:d3e231f1-65b9-43d2-a70a-ac36b0126297"
replace passing_2024_female_2_1 = -9 if key == "uuid:aaa4b018-e8e4-4e7e-b1a9-84b36a78b731"
replace enrollment_2024_total_1_1 = -9 if key == "uuid:1a0ee54d-7385-46ca-a34f-7aa44595152e"
replace enrollment_2024_total_5_1 = -9 if key == "uuid:a1b8a221-60a3-4b01-bd52-730dcd8cbe50"
replace enrollment_2024_total_6_1 = -9 if key == "uuid:881d0069-391e-4c69-af6a-ce4fd190e375"
replace enrollment_2024_female_6_1 = -9 if key == "uuid:881d0069-391e-4c69-af6a-ce4fd190e375"
replace passing_2024_female_4_1 = -9 if key == "uuid:aaa4b018-e8e4-4e7e-b1a9-84b36a78b731"
replace enrollment_2024_female_5_1 = -9 if key == "uuid:1ddffda6-e7cc-4161-a527-3b6dd851a76c"
replace passing_2024_female_6_1 = -9 if key == "uuid:a1b8a221-60a3-4b01-bd52-730dcd8cbe50"
replace enrollment_2024_female_5_1 = -9 if key == "uuid:a1b8a221-60a3-4b01-bd52-730dcd8cbe50"
replace enrollment_2024_total_3_1 = -9 if key == "uuid:881d0069-391e-4c69-af6a-ce4fd190e375"
replace enrollment_2024_female_6_1 = -9 if key == "uuid:aaa4b018-e8e4-4e7e-b1a9-84b36a78b731"
replace passing_2024_female_6_1 = -9 if key == "uuid:d3e231f1-65b9-43d2-a70a-ac36b0126297"
replace passing_2024_total_1_1 = -9 if key == "uuid:1ddffda6-e7cc-4161-a527-3b6dd851a76c"
replace passing_2024_female_3_1 = -9 if key == "uuid:881d0069-391e-4c69-af6a-ce4fd190e375"
replace enrollment_2024_female_3_1 = -9 if key == "uuid:d3e231f1-65b9-43d2-a70a-ac36b0126297"
replace passing_2024_female_2_1 = -9 if key == "uuid:ea1555f3-97cd-42c3-b908-7b5ec9957af5"
replace passing_2024_female_1_1 = -9 if key == "uuid:d3e231f1-65b9-43d2-a70a-ac36b0126297"
replace passing_2024_female_2_1 = -9 if key == "uuid:602b5b07-79fc-444f-8aaf-eeb82521ce8e"
replace passing_2024_total_5_1 = -9 if key == "uuid:d3e231f1-65b9-43d2-a70a-ac36b0126297"
replace enrollment_2024_total_5_1 = -9 if key == "uuid:881d0069-391e-4c69-af6a-ce4fd190e375"
replace passing_2024_female_1_1 = -9 if key == "uuid:602b5b07-79fc-444f-8aaf-eeb82521ce8e"
replace enrollment_2024_total_3_1 = -9 if key == "uuid:a1b8a221-60a3-4b01-bd52-730dcd8cbe50"
replace passing_2024_total_5_1 = -9 if key == "uuid:602b5b07-79fc-444f-8aaf-eeb82521ce8e"
replace enrollment_2024_female_4_1 = -9 if key == "uuid:a1b8a221-60a3-4b01-bd52-730dcd8cbe50"
replace enrollment_2024_total_3_1 = -9 if key == "uuid:ea1555f3-97cd-42c3-b908-7b5ec9957af5"
replace enrollment_2024_female_3_1 = -9 if key == "uuid:602b5b07-79fc-444f-8aaf-eeb82521ce8e"
replace passing_2024_total_4_1 = -9 if key == "uuid:a1b8a221-60a3-4b01-bd52-730dcd8cbe50"
replace passing_2024_total_2_1 = -9 if key == "uuid:d3e231f1-65b9-43d2-a70a-ac36b0126297"
replace passing_2024_total_2_1 = -9 if key == "uuid:1ddffda6-e7cc-4161-a527-3b6dd851a76c"
replace enrollment_2024_female_4_1 = -9 if key == "uuid:d3e231f1-65b9-43d2-a70a-ac36b0126297"
replace enrollment_2024_total_6_1 = -9 if key == "uuid:1ddffda6-e7cc-4161-a527-3b6dd851a76c"
replace passing_2024_female_1_1 = -9 if key == "uuid:a1b8a221-60a3-4b01-bd52-730dcd8cbe50"
replace enrollment_2024_female_6_1 = -9 if key == "uuid:a1b8a221-60a3-4b01-bd52-730dcd8cbe50"
replace enrollment_2024_female_6_1 = -9 if key == "uuid:d3e231f1-65b9-43d2-a70a-ac36b0126297"
replace enrollment_2024_total_2_1 = -9 if key == "uuid:a1b8a221-60a3-4b01-bd52-730dcd8cbe50"
replace passing_2024_total_6_1 = -9 if key == "uuid:ea1555f3-97cd-42c3-b908-7b5ec9957af5"
replace enrollment_2024_total_2_1 = -9 if key == "uuid:aaa4b018-e8e4-4e7e-b1a9-84b36a78b731"
replace enrollment_2024_total_5_1 = -9 if key == "uuid:1a0ee54d-7385-46ca-a34f-7aa44595152e"
replace passing_2024_female_6_1 = -9 if key == "uuid:1a0ee54d-7385-46ca-a34f-7aa44595152e"
replace passing_2024_female_5_1 = -9 if key == "uuid:ea1555f3-97cd-42c3-b908-7b5ec9957af5"
replace enrollment_2024_female_6_1 = -9 if key == "uuid:5ea415f5-cfc4-4ed2-b2e7-5cc9c7fa47c7"
replace enrollment_2024_female_6_1 = -9 if key == "uuid:1ddffda6-e7cc-4161-a527-3b6dd851a76c"
replace enrollment_2024_total_2_1 = -9 if key == "uuid:d3e231f1-65b9-43d2-a70a-ac36b0126297"
replace enrollment_2024_total_3_1 = -9 if key == "uuid:5ea415f5-cfc4-4ed2-b2e7-5cc9c7fa47c7"
replace passing_2024_total_4_1 = -9 if key == "uuid:aaa4b018-e8e4-4e7e-b1a9-84b36a78b731"
replace passing_2024_total_5_1 = -9 if key == "uuid:1ddffda6-e7cc-4161-a527-3b6dd851a76c"
replace enrollment_2024_total_3_1 = -9 if key == "uuid:1ddffda6-e7cc-4161-a527-3b6dd851a76c"
replace enrollment_2024_total_4_1 = -9 if key == "uuid:aaa4b018-e8e4-4e7e-b1a9-84b36a78b731"
replace passing_2024_female_5_1 = -9 if key == "uuid:5ea415f5-cfc4-4ed2-b2e7-5cc9c7fa47c7"
replace enrollment_2024_total_3_1 = -9 if key == "uuid:1a0ee54d-7385-46ca-a34f-7aa44595152e"
replace enrollment_2024_total_1_1 = -9 if key == "uuid:881d0069-391e-4c69-af6a-ce4fd190e375"
replace enrollment_2024_total_2_1 = -9 if key == "uuid:5ea415f5-cfc4-4ed2-b2e7-5cc9c7fa47c7"
replace enrollment_2024_female_5_1 = -9 if key == "uuid:602b5b07-79fc-444f-8aaf-eeb82521ce8e"
replace enrollment_2024_female_6_1 = -9 if key == "uuid:1a0ee54d-7385-46ca-a34f-7aa44595152e"
replace enrollment_2024_female_1_1 = -9 if key == "uuid:1ddffda6-e7cc-4161-a527-3b6dd851a76c"
replace enrollment_2024_total_1_1 = -9 if key == "uuid:aaa4b018-e8e4-4e7e-b1a9-84b36a78b731"
replace enrollment_2024_total_2_1 = -9 if key == "uuid:602b5b07-79fc-444f-8aaf-eeb82521ce8e"
replace passing_2024_female_5_1 = -9 if key == "uuid:602b5b07-79fc-444f-8aaf-eeb82521ce8e"
replace passing_2024_female_5_1 = -9 if key == "uuid:1a0ee54d-7385-46ca-a34f-7aa44595152e"
replace passing_2024_total_6_1 = -9 if key == "uuid:1a0ee54d-7385-46ca-a34f-7aa44595152e"
replace enrollment_2024_total_1_1 = -9 if key == "uuid:a1b8a221-60a3-4b01-bd52-730dcd8cbe50"
replace passing_2024_female_4_1 = -9 if key == "uuid:881d0069-391e-4c69-af6a-ce4fd190e375"
replace enrollment_2024_total_5_1 = -9 if key == "uuid:1ddffda6-e7cc-4161-a527-3b6dd851a76c"
replace enrollment_2024_female_2_1 = -9 if key == "uuid:d3e231f1-65b9-43d2-a70a-ac36b0126297"
replace enrollment_2024_total_5_1 = -9 if key == "uuid:ea1555f3-97cd-42c3-b908-7b5ec9957af5"
replace passing_2024_female_4_1 = -9 if key == "uuid:d3e231f1-65b9-43d2-a70a-ac36b0126297"
replace passing_2024_female_1_1 = -9 if key == "uuid:ea1555f3-97cd-42c3-b908-7b5ec9957af5"
replace enrollment_2024_female_4_1 = -9 if key == "uuid:aaa4b018-e8e4-4e7e-b1a9-84b36a78b731"
replace passing_2024_female_1_1 = -9 if key == "uuid:1a0ee54d-7385-46ca-a34f-7aa44595152e"
replace enrollment_2024_total_6_1 = -9 if key == "uuid:5ea415f5-cfc4-4ed2-b2e7-5cc9c7fa47c7"
replace enrollment_2024_female_6_1 = -9 if key == "uuid:602b5b07-79fc-444f-8aaf-eeb82521ce8e"
replace passing_2024_female_5_1 = -9 if key == "uuid:1ddffda6-e7cc-4161-a527-3b6dd851a76c"
replace passing_2024_female_2_1 = -9 if key == "uuid:5ea415f5-cfc4-4ed2-b2e7-5cc9c7fa47c7"
replace passing_2024_female_5_1 = -9 if key == "uuid:d3e231f1-65b9-43d2-a70a-ac36b0126297"
replace enrollment_2024_total_4_1 = -9 if key == "uuid:5ea415f5-cfc4-4ed2-b2e7-5cc9c7fa47c7"
replace passing_2024_female_4_1 = -9 if key == "uuid:602b5b07-79fc-444f-8aaf-eeb82521ce8e"
replace enrollment_2024_female_1_1 = -9 if key == "uuid:ea1555f3-97cd-42c3-b908-7b5ec9957af5"
replace passing_2024_total_6_1 = -9 if key == "uuid:5ea415f5-cfc4-4ed2-b2e7-5cc9c7fa47c7"
replace enrollment_2024_total_1_1 = -9 if key == "uuid:5ea415f5-cfc4-4ed2-b2e7-5cc9c7fa47c7"
replace enrollment_2024_female_1_1 = -9 if key == "uuid:aaa4b018-e8e4-4e7e-b1a9-84b36a78b731"
replace enrollment_2024_total_1_1 = -9 if key == "uuid:1ddffda6-e7cc-4161-a527-3b6dd851a76c"
replace enrollment_2024_female_3_1 = -9 if key == "uuid:1a0ee54d-7385-46ca-a34f-7aa44595152e"
replace enrollment_2024_total_2_1 = -9 if key == "uuid:1a0ee54d-7385-46ca-a34f-7aa44595152e"
replace enrollment_2024_total_6_1 = -9 if key == "uuid:602b5b07-79fc-444f-8aaf-eeb82521ce8e"
replace passing_2024_female_3_1 = -9 if key == "uuid:d3e231f1-65b9-43d2-a70a-ac36b0126297"
replace passing_2024_female_3_1 = -9 if key == "uuid:602b5b07-79fc-444f-8aaf-eeb82521ce8e"
replace passing_2024_female_5_1 = -9 if key == "uuid:a1b8a221-60a3-4b01-bd52-730dcd8cbe50"
replace enrollment_2024_total_4_1 = -9 if key == "uuid:ea1555f3-97cd-42c3-b908-7b5ec9957af5"
replace enrollment_2024_female_2_1 = -9 if key == "uuid:ea1555f3-97cd-42c3-b908-7b5ec9957af5"
replace enrollment_2024_total_2_1 = -9 if key == "uuid:1ddffda6-e7cc-4161-a527-3b6dd851a76c"
replace passing_2024_female_6_1 = -9 if key == "uuid:ea1555f3-97cd-42c3-b908-7b5ec9957af5"
replace passing_2024_total_3_1 = -9 if key == "uuid:5ea415f5-cfc4-4ed2-b2e7-5cc9c7fa47c7"
replace enrollment_2024_total_4_1 = -9 if key == "uuid:a1b8a221-60a3-4b01-bd52-730dcd8cbe50"
replace passing_2024_female_6_1 = -9 if key == "uuid:602b5b07-79fc-444f-8aaf-eeb82521ce8e"
replace passing_2024_female_6_1 = -9 if key == "uuid:1ddffda6-e7cc-4161-a527-3b6dd851a76c"
replace passing_2024_total_6_1 = -9 if key == "uuid:aaa4b018-e8e4-4e7e-b1a9-84b36a78b731"
replace enrollment_2024_female_1_1 = -9 if key == "uuid:881d0069-391e-4c69-af6a-ce4fd190e375"
replace passing_2024_female_3_1 = -9 if key == "uuid:1ddffda6-e7cc-4161-a527-3b6dd851a76c"
replace passing_2024_female_3_1 = -9 if key == "uuid:ea1555f3-97cd-42c3-b908-7b5ec9957af5"
replace enrollment_2024_total_6_1 = -9 if key == "uuid:d3e231f1-65b9-43d2-a70a-ac36b0126297"
replace passing_2024_female_3_1 = -9 if key == "uuid:1a0ee54d-7385-46ca-a34f-7aa44595152e"
replace passing_2024_female_2_1 = -9 if key == "uuid:a1b8a221-60a3-4b01-bd52-730dcd8cbe50"
replace passing_2024_female_4_1 = -9 if key == "uuid:a1b8a221-60a3-4b01-bd52-730dcd8cbe50"
replace passing_2024_total_4_1 = -9 if key == "uuid:1a0ee54d-7385-46ca-a34f-7aa44595152e"
replace passing_2024_female_1_1 = -9 if key == "uuid:881d0069-391e-4c69-af6a-ce4fd190e375"
replace enrollment_2024_female_1_1 = -9 if key == "uuid:1a0ee54d-7385-46ca-a34f-7aa44595152e"
replace passing_2024_total_1_1 = -9 if key == "uuid:ea1555f3-97cd-42c3-b908-7b5ec9957af5"
replace enrollment_2024_total_4_1 = -9 if key == "uuid:1a0ee54d-7385-46ca-a34f-7aa44595152e"
replace passing_2024_female_4_1 = -9 if key == "uuid:ea1555f3-97cd-42c3-b908-7b5ec9957af5"
replace enrollment_2024_total_1_1 = -9 if key == "uuid:ea1555f3-97cd-42c3-b908-7b5ec9957af5"
replace passing_2024_total_2_1 = -9 if key == "uuid:aaa4b018-e8e4-4e7e-b1a9-84b36a78b731"
replace enrollment_2024_female_3_1 = -9 if key == "uuid:a1b8a221-60a3-4b01-bd52-730dcd8cbe50"
replace enrollment_2024_female_2_1 = -9 if key == "uuid:602b5b07-79fc-444f-8aaf-eeb82521ce8e"
replace passing_2024_female_4_1 = -9 if key == "uuid:1ddffda6-e7cc-4161-a527-3b6dd851a76c"
replace enrollment_2024_total_2_1 = -9 if key == "uuid:ea1555f3-97cd-42c3-b908-7b5ec9957af5"
replace passing_2024_total_4_1 = -9 if key == "uuid:1ddffda6-e7cc-4161-a527-3b6dd851a76c"
replace enrollment_2024_total_1_1 = -9 if key == "uuid:602b5b07-79fc-444f-8aaf-eeb82521ce8e"
replace passing_2024_female_3_1 = -9 if key == "uuid:a1b8a221-60a3-4b01-bd52-730dcd8cbe50"
replace enrollment_2024_total_3_1 = -9 if key == "uuid:602b5b07-79fc-444f-8aaf-eeb82521ce8e"
replace enrollment_2024_total_2_1 = -9 if key == "uuid:881d0069-391e-4c69-af6a-ce4fd190e375"
replace enrollment_2024_total_6_1 = -9 if key == "uuid:1a0ee54d-7385-46ca-a34f-7aa44595152e"
replace passing_2024_total_2_1 = -9 if key == "uuid:ea1555f3-97cd-42c3-b908-7b5ec9957af5"
replace passing_2024_total_3_1 = -9 if key == "uuid:a1b8a221-60a3-4b01-bd52-730dcd8cbe50"
replace enrollment_2024_female_2_1 = -9 if key == "uuid:aaa4b018-e8e4-4e7e-b1a9-84b36a78b731"
replace enrollment_2024_female_3_1 = -9 if key == "uuid:ea1555f3-97cd-42c3-b908-7b5ec9957af5"
replace passing_2024_female_6_1 = -9 if key == "uuid:aaa4b018-e8e4-4e7e-b1a9-84b36a78b731"
replace passing_2024_female_6_1 = -9 if key == "uuid:881d0069-391e-4c69-af6a-ce4fd190e375"
replace enrollment_2024_female_6_1 = -9 if key == "uuid:ea1555f3-97cd-42c3-b908-7b5ec9957af5"
replace passing_2024_total_1_1 = -9 if key == "uuid:aaa4b018-e8e4-4e7e-b1a9-84b36a78b731"
replace passing_2024_total_2_1 = -9 if key == "uuid:602b5b07-79fc-444f-8aaf-eeb82521ce8e"
replace passing_2024_total_1_1 = -9 if key == "uuid:602b5b07-79fc-444f-8aaf-eeb82521ce8e"
replace passing_2024_total_3_1 = -9 if key == "uuid:881d0069-391e-4c69-af6a-ce4fd190e375"
replace enrollment_2024_female_1_1 = -9 if key == "uuid:a1b8a221-60a3-4b01-bd52-730dcd8cbe50"
replace passing_2024_total_3_1 = -9 if key == "uuid:1ddffda6-e7cc-4161-a527-3b6dd851a76c"
replace passing_2024_total_1_1 = -9 if key == "uuid:881d0069-391e-4c69-af6a-ce4fd190e375"
replace passing_2024_total_5_1 = -9 if key == "uuid:881d0069-391e-4c69-af6a-ce4fd190e375"
replace passing_2024_total_6_1 = -9 if key == "uuid:602b5b07-79fc-444f-8aaf-eeb82521ce8e"
replace passing_2024_total_5_1 = -9 if key == "uuid:1a0ee54d-7385-46ca-a34f-7aa44595152e"
replace passing_2024_total_1_1 = -9 if key == "uuid:d3e231f1-65b9-43d2-a70a-ac36b0126297"
replace passing_2024_female_2_1 = -9 if key == "uuid:881d0069-391e-4c69-af6a-ce4fd190e375"
replace enrollment_2024_female_2_1 = -9 if key == "uuid:5ea415f5-cfc4-4ed2-b2e7-5cc9c7fa47c7"
replace passing_2024_total_2_1 = -9 if key == "uuid:a1b8a221-60a3-4b01-bd52-730dcd8cbe50"
replace passing_2024_female_3_1 = -9 if key == "uuid:5ea415f5-cfc4-4ed2-b2e7-5cc9c7fa47c7"
replace passing_2024_total_2_1 = -9 if key == "uuid:881d0069-391e-4c69-af6a-ce4fd190e375"
replace passing_2024_total_1_1 = -9 if key == "uuid:5ea415f5-cfc4-4ed2-b2e7-5cc9c7fa47c7"
replace passing_2024_female_1_1 = -9 if key == "uuid:1ddffda6-e7cc-4161-a527-3b6dd851a76c"
replace passing_2024_female_4_1 = -9 if key == "uuid:5ea415f5-cfc4-4ed2-b2e7-5cc9c7fa47c7"
replace passing_2024_total_2_1 = -9 if key == "uuid:5ea415f5-cfc4-4ed2-b2e7-5cc9c7fa47c7"
replace enrollment_2024_female_4_1 = -9 if key == "uuid:9c94b876-40a4-43e5-8be6-1510e5fdf3ba"
replace passing_2024_total_2_1 = -9 if key == "uuid:9c94b876-40a4-43e5-8be6-1510e5fdf3ba"
replace passing_2024_female_3_1 = -9 if key == "uuid:9c94b876-40a4-43e5-8be6-1510e5fdf3ba"
replace passing_2024_female_6_1 = -9 if key == "uuid:9c94b876-40a4-43e5-8be6-1510e5fdf3ba"
replace enrollment_2024_female_3_1 = -9 if key == "uuid:9c94b876-40a4-43e5-8be6-1510e5fdf3ba"
replace passing_2024_female_2_1 = -9 if key == "uuid:9c94b876-40a4-43e5-8be6-1510e5fdf3ba"
replace passing_2024_female_6_1 = -9 if key == "uuid:c9cbaf66-6628-4825-bdd0-ee5577b838c4"
replace passing_2024_female_2_1 = -9 if key == "uuid:ebcbdc95-60c1-422f-8f04-1d3e6476fd06"
replace enrollment_2024_total_1_1 = -9 if key == "uuid:9c94b876-40a4-43e5-8be6-1510e5fdf3ba"
replace enrollment_2024_female_2_1 = -9 if key == "uuid:9c94b876-40a4-43e5-8be6-1510e5fdf3ba"
replace passing_2024_total_4_1 = -9 if key == "uuid:9c94b876-40a4-43e5-8be6-1510e5fdf3ba"
replace passing_2024_total_5_1 = -9 if key == "uuid:9c94b876-40a4-43e5-8be6-1510e5fdf3ba"
replace enrollment_2024_female_4_1 = -9 if key == "uuid:c9cbaf66-6628-4825-bdd0-ee5577b838c4"
replace enrollment_2024_total_4_1 = -9 if key == "uuid:c9cbaf66-6628-4825-bdd0-ee5577b838c4"
replace enrollment_2024_female_6_1 = -9 if key == "uuid:c9cbaf66-6628-4825-bdd0-ee5577b838c4"
replace passing_2024_female_4_1 = -9 if key == "uuid:c9cbaf66-6628-4825-bdd0-ee5577b838c4"
replace passing_2024_female_5_1 = -9 if key == "uuid:9c94b876-40a4-43e5-8be6-1510e5fdf3ba"
replace enrollment_2024_total_6_1 = -9 if key == "uuid:9c94b876-40a4-43e5-8be6-1510e5fdf3ba"
replace enrollment_2024_total_2_1 = -9 if key == "uuid:9c94b876-40a4-43e5-8be6-1510e5fdf3ba"
replace enrollment_2024_total_4_1 = -9 if key == "uuid:9c94b876-40a4-43e5-8be6-1510e5fdf3ba"
replace enrollment_2024_total_6_1 = -9 if key == "uuid:c9cbaf66-6628-4825-bdd0-ee5577b838c4"
replace passing_2024_total_4_1 = -9 if key == "uuid:c9cbaf66-6628-4825-bdd0-ee5577b838c4"
replace enrollment_2024_female_2_1 = -9 if key == "uuid:ebcbdc95-60c1-422f-8f04-1d3e6476fd06"
replace enrollment_2024_total_2_1 = -9 if key == "uuid:ebcbdc95-60c1-422f-8f04-1d3e6476fd06"
replace enrollment_2024_total_5_1 = -9 if key == "uuid:9c94b876-40a4-43e5-8be6-1510e5fdf3ba"
replace enrollment_2024_female_6_1 = -9 if key == "uuid:9c94b876-40a4-43e5-8be6-1510e5fdf3ba"
replace passing_2024_total_3_1 = -9 if key == "uuid:9c94b876-40a4-43e5-8be6-1510e5fdf3ba"
replace passing_2024_total_6_1 = -9 if key == "uuid:c9cbaf66-6628-4825-bdd0-ee5577b838c4"
replace enrollment_2024_female_5_1 = -9 if key == "uuid:9c94b876-40a4-43e5-8be6-1510e5fdf3ba"
replace passing_2024_total_6_1 = -9 if key == "uuid:9c94b876-40a4-43e5-8be6-1510e5fdf3ba"
replace enrollment_2024_total_3_1 = -9 if key == "uuid:9c94b876-40a4-43e5-8be6-1510e5fdf3ba"
replace passing_2024_female_4_1 = -9 if key == "uuid:9c94b876-40a4-43e5-8be6-1510e5fdf3ba"
replace passing_2024_total_2_1 = -9 if key == "uuid:ebcbdc95-60c1-422f-8f04-1d3e6476fd06"

* 6Mar2025
replace classroom_count_1 = 1 if key == "uuid:a36c008d-b97e-42f7-809a-a1c7a50d2c76"
replace classroom_count_1 = 1 if key == "uuid:a36c008d-b97e-42f7-809a-a1c7a50d2c76"
replace classroom_count_5 = 1 if key == "uuid:a36c008d-b97e-42f7-809a-a1c7a50d2c76"
replace classroom_count_6 = 1 if key == "uuid:a36c008d-b97e-42f7-809a-a1c7a50d2c76"
replace classroom_count_2 = 1 if key == "uuid:a36c008d-b97e-42f7-809a-a1c7a50d2c76"
replace classroom_count_4 = 1 if key == "uuid:a36c008d-b97e-42f7-809a-a1c7a50d2c76"
replace classroom_count_3 = 1 if key == "uuid:a36c008d-b97e-42f7-809a-a1c7a50d2c76"
replace school_name = "ECOLE ELEMENTAIRE DE MBARIGO" if key == "uuid:91ebd701-ed56-4ddd-8691-73ea751feb32"
replace classroom_count_6 = 1 if key == "uuid:2058b073-bd8b-4b73-ab1b-d7128bd15831"
replace classroom_count_1 = 1 if key == "uuid:2058b073-bd8b-4b73-ab1b-d7128bd15831"
replace classroom_count_4 = 1 if key == "uuid:2058b073-bd8b-4b73-ab1b-d7128bd15831"
replace classroom_count_2 = 1 if key == "uuid:2058b073-bd8b-4b73-ab1b-d7128bd15831"
replace classroom_count_1 = 1 if key == "uuid:2058b073-bd8b-4b73-ab1b-d7128bd15831"
replace classroom_count_3 = 1 if key == "uuid:2058b073-bd8b-4b73-ab1b-d7128bd15831"
replace classroom_count_5 = 1 if key == "uuid:2058b073-bd8b-4b73-ab1b-d7128bd15831"

* 10Mar2025
replace enrollment_2024_female_1_1 = -9 if key == "uuid:a36c008d-b97e-42f7-809a-a1c7a50d2c76"
replace enrollment_2024_female_1_1 = -9 if key == "uuid:2058b073-bd8b-4b73-ab1b-d7128bd15831"
replace enrollment_2024_female_2_1 = -9 if key == "uuid:a36c008d-b97e-42f7-809a-a1c7a50d2c76"
replace enrollment_2024_female_2_1 = -9 if key == "uuid:2058b073-bd8b-4b73-ab1b-d7128bd15831"
replace enrollment_2024_female_3_1 = -9 if key == "uuid:a36c008d-b97e-42f7-809a-a1c7a50d2c76"
replace enrollment_2024_female_3_1 = -9 if key == "uuid:2058b073-bd8b-4b73-ab1b-d7128bd15831"
replace enrollment_2024_female_4_1 = -9 if key == "uuid:a36c008d-b97e-42f7-809a-a1c7a50d2c76"
replace enrollment_2024_female_4_1 = -9 if key == "uuid:2058b073-bd8b-4b73-ab1b-d7128bd15831"
replace enrollment_2024_female_5_1 = -9 if key == "uuid:a36c008d-b97e-42f7-809a-a1c7a50d2c76"
replace enrollment_2024_female_5_1 = -9 if key == "uuid:2058b073-bd8b-4b73-ab1b-d7128bd15831"
replace enrollment_2024_female_6_1 = -9 if key == "uuid:a36c008d-b97e-42f7-809a-a1c7a50d2c76"
replace enrollment_2024_female_6_1 = -9 if key == "uuid:2058b073-bd8b-4b73-ab1b-d7128bd15831"
replace enrollment_2024_total_1_1 = -9 if key == "uuid:a36c008d-b97e-42f7-809a-a1c7a50d2c76"
replace enrollment_2024_total_1_1 = -9 if key == "uuid:2058b073-bd8b-4b73-ab1b-d7128bd15831"
replace enrollment_2024_total_2_1 = -9 if key == "uuid:a36c008d-b97e-42f7-809a-a1c7a50d2c76"
replace enrollment_2024_total_2_1 = -9 if key == "uuid:2058b073-bd8b-4b73-ab1b-d7128bd15831"
replace enrollment_2024_total_3_1 = -9 if key == "uuid:a36c008d-b97e-42f7-809a-a1c7a50d2c76"
replace enrollment_2024_total_3_1 = -9 if key == "uuid:2058b073-bd8b-4b73-ab1b-d7128bd15831"
replace enrollment_2024_total_4_1 = -9 if key == "uuid:a36c008d-b97e-42f7-809a-a1c7a50d2c76"
replace enrollment_2024_total_4_1 = -9 if key == "uuid:2058b073-bd8b-4b73-ab1b-d7128bd15831"
replace enrollment_2024_total_5_1 = -9 if key == "uuid:a36c008d-b97e-42f7-809a-a1c7a50d2c76"
replace enrollment_2024_total_5_1 = -9 if key == "uuid:2058b073-bd8b-4b73-ab1b-d7128bd15831"
replace enrollment_2024_total_6_1 = -9 if key == "uuid:a36c008d-b97e-42f7-809a-a1c7a50d2c76"
replace enrollment_2024_total_6_1 = -9 if key == "uuid:2058b073-bd8b-4b73-ab1b-d7128bd15831"
replace passing_2024_female_1_1 = -9 if key == "uuid:a36c008d-b97e-42f7-809a-a1c7a50d2c76"
replace passing_2024_female_1_1 = -9 if key == "uuid:2058b073-bd8b-4b73-ab1b-d7128bd15831"
replace passing_2024_female_2_1 = -9 if key == "uuid:a36c008d-b97e-42f7-809a-a1c7a50d2c76"
replace passing_2024_female_2_1 = -9 if key == "uuid:2058b073-bd8b-4b73-ab1b-d7128bd15831"
replace passing_2024_female_3_1 = -9 if key == "uuid:a36c008d-b97e-42f7-809a-a1c7a50d2c76"
replace passing_2024_female_3_1 = -9 if key == "uuid:2058b073-bd8b-4b73-ab1b-d7128bd15831"
replace passing_2024_female_4_1 = -9 if key == "uuid:a36c008d-b97e-42f7-809a-a1c7a50d2c76"
replace passing_2024_female_4_1 = -9 if key == "uuid:2058b073-bd8b-4b73-ab1b-d7128bd15831"
replace passing_2024_female_5_1 = -9 if key == "uuid:a36c008d-b97e-42f7-809a-a1c7a50d2c76"
replace passing_2024_female_5_1 = -9 if key == "uuid:2058b073-bd8b-4b73-ab1b-d7128bd15831"
replace passing_2024_female_6_1 = -9 if key == "uuid:a36c008d-b97e-42f7-809a-a1c7a50d2c76"
replace passing_2024_female_6_1 = -9 if key == "uuid:2058b073-bd8b-4b73-ab1b-d7128bd15831"
replace passing_2024_total_1_1 = -9 if key == "uuid:a36c008d-b97e-42f7-809a-a1c7a50d2c76"
replace passing_2024_total_1_1 = -9 if key == "uuid:2058b073-bd8b-4b73-ab1b-d7128bd15831"
replace passing_2024_total_2_1 = -9 if key == "uuid:a36c008d-b97e-42f7-809a-a1c7a50d2c76"
replace passing_2024_total_2_1 = -9 if key == "uuid:2058b073-bd8b-4b73-ab1b-d7128bd15831"
replace passing_2024_total_3_1 = -9 if key == "uuid:a36c008d-b97e-42f7-809a-a1c7a50d2c76"
replace passing_2024_total_3_1 = -9 if key == "uuid:2058b073-bd8b-4b73-ab1b-d7128bd15831"
replace passing_2024_total_4_1 = -9 if key == "uuid:a36c008d-b97e-42f7-809a-a1c7a50d2c76"
replace passing_2024_total_4_1 = -9 if key == "uuid:2058b073-bd8b-4b73-ab1b-d7128bd15831"
replace passing_2024_total_5_1 = -9 if key == "uuid:a36c008d-b97e-42f7-809a-a1c7a50d2c76"
replace passing_2024_total_5_1 = -9 if key == "uuid:2058b073-bd8b-4b73-ab1b-d7128bd15831"
replace passing_2024_total_6_1 = -9 if key == "uuid:a36c008d-b97e-42f7-809a-a1c7a50d2c76"
replace passing_2024_total_6_1 = -9 if key == "uuid:2058b073-bd8b-4b73-ab1b-d7128bd15831"

*** Retired HHID' inputting info manually
*****************************************
* 132B <- 041B (in the village_select_o but denoted hhid_village 041B and coded that way)
* 122B <- 063B (all good)
* 120A <- 101A (in the village_select_o but denoted hhid_village 101A...)
* 130A <- 051A (neither id's in the community surey?? but 051A has a photo of survey: unsure how to read it)
* 140A <- 111A (all good)

* Missing for attendance checks (ID's)
*****************************************
* 041B (needs to be changed to 132B then use picture of 132B)
replace hhid_village == "132B" if hhid_village == "041B" 
replace pull_hhid_village_1 pull_hhid_1 pull_individ_1 pull_hh_first_name__1 pull_hh_name__1 pull_hh_full_name_calc__1 pull_hh_age_1 pull_hh_gender_1 pull_hh_head_name_complet_1 pull_baselineniveau_1 pull_family_members_1 pull_temp_1 pull_fu_mem_id_1

hhid_village	individ	nom_complet	niveau	age	sexe	inscrit	niveau_classe	present	ménage
132B	132B1508	AMADOU MBODJI	CI	7	garçon	Oui    Non		Oui    Non	MAMADOU MBODJI, KHARDIATA PAME, FADIME MBODJI, HAWA MBODJI, AISSATA GUAYE, MARIAME MBODJI, HAROUNA GAYE, AMADOU MBODJI, KALIDOU MBODJI, ALIOU MBODJI, NGAIDÃ MBODJI, ALY MBODJI
132B	132B1805	Alassane Nbodji	CI	10	garçon	Oui    Non		Oui    Non	Abdoulaye Nbodji, Fama Nbodji, MARIAMA Nbodji, Rouguuyatou Nbodji, Alassane Nbodji, Kardiatou Nbodji, Mainouma Nbodji
132B	132B1906	Bylo NDIAYE	CI	8	fille	Oui    Non		Oui    Non	AMADOU MOUSSA  NDIAYE, AISSAITA MOUSSA  THIAM, ABDOUL  Ba, Alassane  Ndiaye, MOUHAMADOU  NdiAYE, Bylo NDIAYE, Laye Ndiaye, Mody Ndiaye
132B	132B0508	Fama Nbodji	CI	8	fille	Oui    Non		Oui    Non	Ibrahima mouctar  Nbodji, Tacko NDIAYE, Djienaba  Pam, Alassane  Nbodji, Mouctar  Nbodji, Mamoudou  Nbodji, KADIATA  Nbodji, Fama Nbodji, SOUNA Nbodji, Boudy Nbodji, Djienaba  Nbodji, Tacko  Nbodji
132B	132B0804	MAIRAM OUMAR MBODJ	CI	6	fille	Oui    Non		Oui    Non	MALICK MAMOUDOU MBODJ, MAIRAM MAMOUDOU MBODJ, KARDIATA OUMAR MBODJ, MAIRAM OUMAR MBODJ, THIERNO OUMAR MBODJ
132B	132B0904	PENDA NDIAYE	CI	7	fille	Oui    Non		Oui    Non	MAMADOU NDIAYE, FATIMATA NDIAYE, FATIMATA  MAMADOU NDIAYE, PENDA NDIAYE, ABDOULAYE NDIAYE, AMADOU NDIAYE
132B	132B1103	DJIBRIL OUMAR FALL	CP	8	garçon	Oui    Non		Oui    Non	SAFRA FALL, OUMAR HAMADY FALL, DJIBRIL OUMAR FALL, KARDIATA FALL
132B	132B1206	FATMATOU WADOU	CP	7	fille	Oui    Non		Oui    Non	FATIMATA DJIKINDE, AISSATA IDY KONÃ, FAMA THIAM, AISSATA NDIAYE, AISSATA AHMADOU NDIAYE, FATMATOU WADOU
132B	132B1507	HAROUNA GAYE	CP	7	garçon	Oui    Non		Oui    Non	MAMADOU MBODJI, KHARDIATA PAME, FADIME MBODJI, HAWA MBODJI, AISSATA GUAYE, MARIAME MBODJI, HAROUNA GAYE, AMADOU MBODJI, KALIDOU MBODJI, ALIOU MBODJI, NGAIDÃ MBODJI, ALY MBODJI
132B	132B0803	KARDIATA OUMAR MBODJ	CP	8	fille	Oui    Non		Oui    Non	MALICK MAMOUDOU MBODJ, MAIRAM MAMOUDOU MBODJ, KARDIATA OUMAR MBODJ, MAIRAM OUMAR MBODJ, THIERNO OUMAR MBODJ
132B	132B0705	DIEYNABA MBODJI	CE1	8	fille	Oui    Non		Oui    Non	ALASSANE OUSMANE MBODJI, RAMATA ABDOUL MBODJI, OUSMANE ALASSANE MBODJI, MARIAME ALASSANE MBODJI, DIEYNABA MBODJI, KHADIATOU MBODJI
132B	132B0903	FATIMATA  MAMADOU NDIAYE	CE1	10	fille	Oui    Non		Oui    Non	MAMADOU NDIAYE, FATIMATA NDIAYE, FATIMATA  MAMADOU NDIAYE, PENDA NDIAYE, ABDOULAYE NDIAYE, AMADOU NDIAYE
132B	132B1007	HAWA HAMADY SECK	CE1	11	fille	Oui    Non		Oui    Non	HAMADY SECK, TOMBA DIA, FAMA DIALLO, YERO NDIAYE, AISSATA NDIAYE, YOUGOUBA SECK, HAWA HAMADY SECK
132B	132B1804	Rouguuyatou Nbodji	CE1	11	fille	Oui    Non		Oui    Non	Abdoulaye Nbodji, Fama Nbodji, MARIAMA Nbodji, Rouguuyatou Nbodji, Alassane Nbodji, Kardiatou Nbodji, Mainouma Nbodji
132B	132B0305	AISSATA AMADOU MBODJ	CE2	10	fille	Oui    Non		Oui    Non	AMADOU MAMOUDOU MBODJ, KARDIATA OUSMANE MBODJ, KARDIATA AMADOU MBODJ, ALASSANE AMADOU MBODJ, AISSATA AMADOU MBODJ, MAIMOUNA AMADOU MBODJ, ROUGUIYATA AMADOU MBODJ
132B	132B0105	AISSATA OUSMANE MBODJI	CE2	10	fille	Oui    Non		Oui    Non	MARIAM ALIOU MBODJI, HAMADY ALIOU MBODJI, OUSMANE ALIOU MBODJI, MOUCTAR OUSMANE MBODJI, AISSATA OUSMANE MBODJI
132B	132B1404	MAIRAM MAMADOU MBODJ	CM1	11	fille	Oui    Non		Oui    Non	KARDIATA HAMADY MBODJ, ALASSANE MAMADOU MBODJ, MOCTAR MAMADOU MBODJ, MAIRAM MAMADOU MBODJ, RASSOULOU MAMADOU MBODJ, ELIMANE MAMADOU MBODJ
132B	132B0905	ABDOULAYE NDIAYE		5	garçon	Oui    Non		Oui    Non	MAMADOU NDIAYE, FATIMATA NDIAYE, FATIMATA  MAMADOU NDIAYE, PENDA NDIAYE, ABDOULAYE NDIAYE, AMADOU NDIAYE
132B	132B1603	AISSATA SY		5	fille	Oui    Non		Oui    Non	SAFIETOU OUSMANE GAYE, OUMAR FALL, AISSATA SY
132B	132B1710	AMADOU KÃBA DIALLO		7	garçon	Oui    Non		Oui    Non	FARMATA AMADOU NDIAYE, ROUGUIATA HAMADY DIA, KÃBA DIALLO, BINETA ABDOURAHMANI DIALLO, HAMADY NDIAYE, AMADOU SANÃ, FARMATA SANÃ, ROUGUI SANÃ, NDEYE KÃBA DIALLO, AMADOU KÃBA DIALLO, FARMATA KÃBA DIALLO
132B	132B0606	IBRAHIMA MBODJI		5	garçon	Oui    Non		Oui    Non	DIEYNABA ALIOU MBODJI, MAMOUDOU MALICK SALL, MARIAME ABDOUL NDIAYE, SOKHNA ABDOUL NDIAYE, AMINATA ABDOUL NDIAYE, IBRAHIMA MBODJI
132B	132B1509	KALIDOU MBODJI		9	garçon	Oui    Non		Oui    Non	MAMADOU MBODJI, KHARDIATA PAME, FADIME MBODJI, HAWA MBODJI, AISSATA GUAYE, MARIAME MBODJI, HAROUNA GAYE, AMADOU MBODJI, KALIDOU MBODJI, ALIOU MBODJI, NGAIDÃ MBODJI, ALY MBODJI
132B	132B1905	MOUHAMADOU  NdiAYE		6	garçon	Oui    Non		Oui    Non	AMADOU MOUSSA  NDIAYE, AISSAITA MOUSSA  THIAM, ABDOUL  Ba, Alassane  Ndiaye, MOUHAMADOU  NdiAYE, Bylo NDIAYE, Laye Ndiaye, Mody Ndiaye
132B	132B1304	MOUSSA MBODJ		6	garçon	Oui    Non		Oui    Non	MOUSSA ABDOULAYE MBODJ, MAIRAM WADE, FAMA MBODJ, MOUSSA MBODJ, SALAMATA MOUSSA MBODJ
132B	132B0203	Nourrou sy		6	garçon	Oui    Non		Oui    Non	Tidjane Sy, Aminata Wade, Nourrou sy, THIERNO Sy, OUMAR Sy, Aliou sy
132B	132B0509	SOUNA Nbodji		5	garçon	Oui    Non		Oui    Non	Ibrahima mouctar  Nbodji, Tacko NDIAYE, Djienaba  Pam, Alassane  Nbodji, Mouctar  Nbodji, Mamoudou  Nbodji, KADIATA  Nbodji, Fama Nbodji, SOUNA Nbodji, Boudy Nbodji, Djienaba  Nbodji, Tacko  Nbodji


* 073A (there's a picture)
replace pull_hhid_village_1 pull_hhid_1 pull_individ_1 pull_hh_first_name__1 pull_hh_name__1 pull_hh_full_name_calc__1 pull_hh_age_1 pull_hh_gender_1 pull_hh_head_name_complet_1 pull_baselineniveau_1 pull_family_members_1 pull_temp_1 pull_fu_mem_id_1

hhid_village	individ	nom_complet	niveau	age	sexe	inscrit	niveau_classe	present	ménage
072A	072A1206	ALHADJI MALICK THIAM	Pas enregistré. Vérifiez primaire.	9	garçon	Oui    Non		Oui    Non	PAPE CHEIKH THIAM, MBAYANG MBODJ, AMINTA DIOP, AWA THIAM, NDEYE ARAME THIAM, ALHADJI MALICK THIAM, ATOU THIAM, OUMEU DIAGNE
072A	072A0607	Assane Ndao	Pas enregistré. Vérifiez primaire.	5	garçon	Oui    Non		Oui    Non	Amadou Ndao, Yatta Diop, Mame coumba GuÃ©ye, Talla Ndao, Diakher Ndao, Bathie Ndao, Assane Ndao, NdoumbÃ© GuÃ©ye
072A	072A0410	Gamou Diop	Pas enregistré. Vérifiez primaire.	5	fille	Oui    Non		Oui    Non	Ndiaga Diop, Adama Sy, Cheikh Diop, Fatou Diop, Ousmane Diop, Asy Mbodji, Khady Mbaye, Malick Diop, Massamba Diop, Gamou Diop, Ameth Diop, Cheikh Diop, Doudou Diop, Faty Diop
072A	072A0711	IBRAHIMA SALL	Pas enregistré. Vérifiez primaire.	5	garçon	Oui    Non		Oui    Non	IBEU SALL, NDIAKANE SALL, AWA BA, YAMAR SALL, COUMBA BA, SAMBA LAOBÃ SALL, OUSMANE SALL, ANNA SEYE, ALHASSANE SALL, AMINATA SALL, IBRAHIMA SALL, YACINE SALL, MOUHAMED SALL
072A	072A1708	MACODE JUNIOR DIOP	Pas enregistré. Vérifiez primaire.	6	garçon	Oui    Non		Oui    Non	MACODE DIOP, FATOU CISSE, DIAGUA DIOP, Fatou DIOP, Yaram DIOP, MOUHAMED DIOP, AMINTA DIOP, MACODE JUNIOR DIOP, MBAYE DIOP, NDEYE DIAW, NDEYE DIOP, DIAGUA JUNIOR DIOP, RAMALAYE NIANG, DIADJI DIOP
072A	072A0713	MOUHAMED SALL	Pas enregistré. Vérifiez primaire.	5	garçon	Oui    Non		Oui    Non	IBEU SALL, NDIAKANE SALL, AWA BA, YAMAR SALL, COUMBA BA, SAMBA LAOBÃ SALL, OUSMANE SALL, ANNA SEYE, ALHASSANE SALL, AMINATA SALL, IBRAHIMA SALL, YACINE SALL, MOUHAMED SALL
072A	072A1304	Maremme GUEYE	Pas enregistré. Vérifiez primaire.	5	fille	Oui    Non		Oui    Non	FATOU birame WADE, AWA MBODIE, COUMBA MBODIE, Maremme GUEYE, Tagne MBODIE, MBAYE MBODIE, Ousseynou MBODIE, OUSMANE MBODIE
072A	072A1506	PAPE KARIM SANE	Pas enregistré. Vérifiez primaire.	6	garçon	Oui    Non		Oui    Non	PAPE DIOP, LOLY SARR, SANTO DIOP, MAREME DIAGNE, MOHAMED EL AMINE SANE, PAPE KARIM SANE, ZEYNABOU HADIJA SANE
072A	072A0807	NDEYE DIABY	CI	6	fille	Oui    Non		Oui    Non	BANDA DIÃNG, PENDA DIOP, NOGAYE DIENG, IBRAHIMA DIENG, BOURA NDIAYE DIENG, NDEYE COUMBA DIABI, NDEYE DIABY
072A	072A0203	Ndeye  THIAM	CI	7	fille	Oui    Non		Oui    Non	Ibrahima  GUEYE, Mariama  THIAM, Ndeye  THIAM
072A	072A0911	OULEY NDOUR	CI	7	fille	Oui    Non		Oui    Non	SODDA NDIAYE, COUMBA NDAO, NAKE NIANG, MAGUETTE NIANG, MOHAMED NIANG, ROKHAYA NIANG, PAPE AMADOU NIANG, ABDOU DIEYE, MOHAMED NDIAYE, OUMAR NDIAYE, OULEY NDOUR
072A	072A0409	Massamba Diop	CP	8	garçon	Oui    Non		Oui    Non	Ndiaga Diop, Adama Sy, Cheikh Diop, Fatou Diop, Ousmane Diop, Asy Mbodji, Khady Mbaye, Malick Diop, Massamba Diop, Gamou Diop, Ameth Diop, Cheikh Diop, Doudou Diop, Faty Diop
072A	072A0413	Doudou Diop	CE1	11	garçon	Oui    Non		Oui    Non	Ndiaga Diop, Adama Sy, Cheikh Diop, Fatou Diop, Ousmane Diop, Asy Mbodji, Khady Mbaye, Malick Diop, Massamba Diop, Gamou Diop, Ameth Diop, Cheikh Diop, Doudou Diop, Faty Diop
072A	072A1505	MOHAMED EL AMINE SANE	CE1	8	garçon	Oui    Non		Oui    Non	PAPE DIOP, LOLY SARR, SANTO DIOP, MAREME DIAGNE, MOHAMED EL AMINE SANE, PAPE KARIM SANE, ZEYNABOU HADIJA SANE
072A	072A1806	MOUHAMED SEYE	CE1	10	garçon	Oui    Non		Oui    Non	PAPE SEYE, Salimata SALL, Mame SEYE, ABDOUL AZIZ SEYE, Elhadji MASEYE SEYE, MOUHAMED SEYE, OULIMATA Diouf
072A	072A1711	NDEYE DIOP	CE1	8	fille	Oui    Non		Oui    Non	MACODE DIOP, FATOU CISSE, DIAGUA DIOP, Fatou DIOP, Yaram DIOP, MOUHAMED DIOP, AMINTA DIOP, MACODE JUNIOR DIOP, MBAYE DIOP, NDEYE DIAW, NDEYE DIOP, DIAGUA JUNIOR DIOP, RAMALAYE NIANG, DIADJI DIOP
072A	072A0606	Bathie Ndao	CE2	9	garçon	Oui    Non		Oui    Non	Amadou Ndao, Yatta Diop, Mame coumba GuÃ©ye, Talla Ndao, Diakher Ndao, Bathie Ndao, Assane Ndao, NdoumbÃ© GuÃ©ye
072A	072A1707	AMINTA DIOP	CM1	10	garçon	Oui    Non		Oui    Non	MACODE DIOP, FATOU CISSE, DIAGUA DIOP, Fatou DIOP, Yaram DIOP, MOUHAMED DIOP, AMINTA DIOP, MACODE JUNIOR DIOP, MBAYE DIOP, NDEYE DIAW, NDEYE DIOP, DIAGUA JUNIOR DIOP, RAMALAYE NIANG, DIADJI DIOP
072A	072A1805	Elhadji MASEYE SEYE	CM1	11	garçon	Oui    Non		Oui    Non	PAPE SEYE, Salimata SALL, Mame SEYE, ABDOUL AZIZ SEYE, Elhadji MASEYE SEYE, MOUHAMED SEYE, OULIMATA Diouf
072A	072A1606	Fatou MBODJI	CM2	9	fille	Oui    Non		Oui    Non	LIMALE DIOP, CODOU FALL, Moado Diop, ASSANE DIOP, Bathio DIOP, Fatou MBODJI, Sigueu Toure, ASTOU TOURE, Amadou TOURE


* 101A (needs to be changed to 120A then use picture of 120A)
replace hhid_village == "120A" if hhid_village == "101A"
replace pull_hhid_village_1 pull_hhid_1 pull_individ_1 pull_hh_first_name__1 pull_hh_name__1 pull_hh_full_name_calc__1 pull_hh_age_1 pull_hh_gender_1 pull_hh_head_name_complet_1 pull_baselineniveau_1 pull_family_members_1 pull_temp_1 pull_fu_mem_id_1

hhid_village	individ	nom_complet	niveau	age	sexe	inscrit	niveau_classe	present	ménage
120A	120A0405	ALASSANE FALL	CI	7	garçon	Oui    Non		Oui    Non	FARMATA BOCAR FALL, KHALIFA FALL, AISSATA MARIAME DIOP, ALIOU FALL, ALASSANE FALL, HAWA FALL, RAMATOULAYE FALL
120A	120A1406	ALIOU DIOP	CI	7	garçon	Oui    Non		Oui    Non	BOCAR DIOP, FARMATA ABDOULAYE GADIO, AISSATA BOCAR DIOP, MAMADOU DIOP, OUMOU DIOP, ALIOU DIOP, ALSSANE DIOP, OUMAR DIOP, MALICK DIOP
120A	120A0404	ALIOU FALL	CI	7	garçon	Oui    Non		Oui    Non	FARMATA BOCAR FALL, KHALIFA FALL, AISSATA MARIAME DIOP, ALIOU FALL, ALASSANE FALL, HAWA FALL, RAMATOULAYE FALL
120A	120A1407	ALSSANE DIOP	CI	7	garçon	Oui    Non		Oui    Non	BOCAR DIOP, FARMATA ABDOULAYE GADIO, AISSATA BOCAR DIOP, MAMADOU DIOP, OUMOU DIOP, ALIOU DIOP, ALSSANE DIOP, OUMAR DIOP, MALICK DIOP
120A	120A0205	AMINATA SALL	CI	6	fille	Oui    Non		Oui    Non	BOCAR TIDIANE SALL, BINTA SYLLA, AISSATA SALL, HABSATOU SALL, AMINATA SALL, BANNDEL SALL
120A	120A1106	Aminata Diop	CI	7	fille	Oui    Non		Oui    Non	Sileymane Diop, KADIATA Lome, Mamadou Diop, Fati Diop, Mamadou Diop, Aminata Diop
120A	120A0703	AÃSSÃ  DIOP	CI	5	fille	Oui    Non		Oui    Non	OUMAR DIOP, FATY LY, AÃSSÃ  DIOP, DIEYNABA  DIOP, SEYDOU OUMAR  DIOP
120A	120A2005	FARMATA DIOP	CI	8	fille	Oui    Non		Oui    Non	FARMATA BAIDY DIOP, ALASSANE BANA DIOP, YOUBA DIOP, MOUSSA DIOP, FARMATA DIOP, THIERNO BOCAR DIOP, FAT DIEYNABA DIOP
120A	120A0510	IBA SY	CI	5	garçon	Oui    Non		Oui    Non	OUMAR SY, IBRAHIMA OUMAR SY, MAMADOU SY, DEYIBOU SY, MAMADOU SY, SEYDOU SY, SOULEYMANE SY, HAWA SY, RACKY SALL, IBA SY, KHADY SOW, FATIMATA BA
120A	120A1603	MAMADOU SETT	CI	5	garçon	Oui    Non		Oui    Non	IBRAHIMA SETT, RACKY SETT, MAMADOU SETT, HOULEYE SETT, FARMATA SETT
120A	120A1906	Mama Wone	CI	11	garçon	Oui    Non		Oui    Non	MALICK SAMBA  WONE, Hawa  Tome, Mariama  Wone, Adama  WONE, ThielÃ© Wone, Mama Wone, Cherif Wone, Dielia Wone, Moussa Wone, Salif Wone
120A	120A0105	OUMAR DIOP	CI	6	garçon	Oui    Non		Oui    Non	MAMADOU DIOP, HAWA DIENG, HABIB DIOP, MARIAMA DIOP, OUMAR DIOP, FATY LY DIOP
120A	120A0509	RACKY SALL	CI	7	fille	Oui    Non		Oui    Non	OUMAR SY, IBRAHIMA OUMAR SY, MAMADOU SY, DEYIBOU SY, MAMADOU SY, SEYDOU SY, SOULEYMANE SY, HAWA SY, RACKY SALL, IBA SY, KHADY SOW, FATIMATA BA
120A	120A1008	Dicko  Sarr	CP	8	fille	Oui    Non		Oui    Non	BALIOU Sarr, Dicko  Diop, Oumar  Sarr, FATI  Sall, Penda Sow, Amar  Sarr, OUSMANE  Sarr, Dicko  Sarr
120A	120A0508	HAWA SY	CP	6	fille	Oui    Non		Oui    Non	OUMAR SY, IBRAHIMA OUMAR SY, MAMADOU SY, DEYIBOU SY, MAMADOU SY, SEYDOU SY, SOULEYMANE SY, HAWA SY, RACKY SALL, IBA SY, KHADY SOW, FATIMATA BA
120A	120A1708	KADIA SARR	CP	6	fille	Oui    Non		Oui    Non	THIERNO SARR, AMINATA DIAGNE, FATY SARR, OUSMANE SARR, BANAA SARR, COUMBA SARR, HAWO SARR, KADIA SARR, FATY THIERNO SARR
120A	120A1105	Mamadou Diop	CP	8	garçon	Oui    Non		Oui    Non	Sileymane Diop, KADIATA Lome, Mamadou Diop, Fati Diop, Mamadou Diop, Aminata Diop
120A	120A1509	NAZIRE NDIAYE	CP	9	garçon	Oui    Non		Oui    Non	IBRAHIMA MOCTAR NDIAYE, HAWO ISSA SY, SILEYMANE NDIAYE, BOUBOU NDIAYE, MARIAME NDIAYE, FATY NDIAYE, RAMATOULAYE NDIAYE, MOCTAR IBRAHIMA NDIAYE, NAZIRE NDIAYE, ALASSANE NDIAYE, ISSA NDIAYE
120A	120A1007	OUSMANE  Sarr	CP	8	garçon	Oui    Non		Oui    Non	BALIOU Sarr, Dicko  Diop, Oumar  Sarr, FATI  Sall, Penda Sow, Amar  Sarr, OUSMANE  Sarr, Dicko  Sarr
120A	120A0806	SILEYE MALICK DIOP	CP	8	garçon	Oui    Non		Oui    Non	MALICK IBRAHIMA DIOP, KADIATA SARR, HAMATH MALICK DIOP, HAWA MALICK DIOP, AISSATA MALICK DIOP, SILEYE MALICK DIOP
120A	120A0403	AISSATA MARIAME DIOP	CE1	9	fille	Oui    Non		Oui    Non	FARMATA BOCAR FALL, KHALIFA FALL, AISSATA MARIAME DIOP, ALIOU FALL, ALASSANE FALL, HAWA FALL, RAMATOULAYE FALL
120A	120A1104	Fati Diop	CE1	9	fille	Oui    Non		Oui    Non	Sileymane Diop, KADIATA Lome, Mamadou Diop, Fati Diop, Mamadou Diop, Aminata Diop
120A	120A0204	HABSATOU SALL	CE1	8	fille	Oui    Non		Oui    Non	BOCAR TIDIANE SALL, BINTA SYLLA, AISSATA SALL, HABSATOU SALL, AMINATA SALL, BANNDEL SALL
120A	120A1807	HOULEYE  LY	CE1	9	fille	Oui    Non		Oui    Non	IBRAHIMA Ly, AMINATA BA, MAMADOU  LY, BOUBOU LY, MADOUDOU LY, MOUHAMED LY, HOULEYE  LY
120A	120A1405	OUMOU DIOP	CE1	10	fille	Oui    Non		Oui    Non	BOCAR DIOP, FARMATA ABDOULAYE GADIO, AISSATA BOCAR DIOP, MAMADOU DIOP, OUMOU DIOP, ALIOU DIOP, ALSSANE DIOP, OUMAR DIOP, MALICK DIOP
120A	120A0507	SOULEYMANE SY	CE1	9	garçon	Oui    Non		Oui    Non	OUMAR SY, IBRAHIMA OUMAR SY, MAMADOU SY, DEYIBOU SY, MAMADOU SY, SEYDOU SY, SOULEYMANE SY, HAWA SY, RACKY SALL, IBA SY, KHADY SOW, FATIMATA BA
120A	120A0604	Toly Wone	CE1	11	fille	Oui    Non		Oui    Non	Ibrahima Sy, Bassirou Sylla, Fatimata Ly, Toly Wone, Adama Wone, miyel Wone, Bocar Sall, Hawa Wone, Hawa Dia
120A	120A0203	AISSATA SALL	CE2	10	fille	Oui    Non		Oui    Non	BOCAR TIDIANE SALL, BINTA SYLLA, AISSATA SALL, HABSATOU SALL, AMINATA SALL, BANNDEL SALL
120A	120A0605	Adama Wone		5	garçon	Oui    Non		Oui    Non	Ibrahima Sy, Bassirou Sylla, Fatimata Ly, Toly Wone, Adama Wone, miyel Wone, Bocar Sall, Hawa Wone, Hawa Dia
120A	120A1907	Cherif Wone		7	garçon	Oui    Non		Oui    Non	MALICK SAMBA  WONE, Hawa  Tome, Mariama  Wone, Adama  WONE, ThielÃ© Wone, Mama Wone, Cherif Wone, Dielia Wone, Moussa Wone, Salif Wone
120A	120A1908	Dielia Wone		5	fille	Oui    Non		Oui    Non	MALICK SAMBA  WONE, Hawa  Tome, Mariama  Wone, Adama  WONE, ThielÃ© Wone, Mama Wone, Cherif Wone, Dielia Wone, Moussa Wone, Salif Wone
120A	120A0406	HAWA FALL		5	fille	Oui    Non		Oui    Non	FARMATA BOCAR FALL, KHALIFA FALL, AISSATA MARIAME DIOP, ALIOU FALL, ALASSANE FALL, HAWA FALL, RAMATOULAYE FALL
120A	120A1910	Salif Wone		6	garçon	Oui    Non		Oui    Non	MALICK SAMBA  WONE, Hawa  Tome, Mariama  Wone, Adama  WONE, ThielÃ© Wone, Mama Wone, Cherif Wone, Dielia Wone, Moussa Wone, Salif Wone
120A	120A2006	THIERNO BOCAR DIOP		7	garçon	Oui    Non		Oui    Non	FARMATA BAIDY DIOP, ALASSANE BANA DIOP, YOUBA DIOP, MOUSSA DIOP, FARMATA DIOP, THIERNO BOCAR DIOP, FAT DIEYNABA DIOP


* Save the corrected dataset
export excel using "$corrected\CORRECTED_DISES_Principal_Survey_MIDLINE_VF_WIDE_27Mar2025.xlsx", firstrow(variables) replace
