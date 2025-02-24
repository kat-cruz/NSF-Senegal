*** Created by: Alex Mills ***
*** Updates recorded in GitHub ***
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
global data "$master\_CRDES_RawData\Midline\Principal_Survey_Data"
global schoolprincipal "$master\Output\Data_Quality_Checks\Midline\Midline_Principal_Issues"
global issues "$master\Output\Data_Quality_Checks\Midline\Midline_Principal_Issues"
global corrections "$master\External_Corrections\Issues for Justin and Amina\Midline\Issues"
global corrected "$master\Output\Data_Corrections\Midline"

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

import delimited "$data\DISES_Principal_Survey_MIDLINE_VF_WIDE_13Feb2025.csv", clear varnames(1) bindquote(strict)

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



* Save the corrected dataset
export excel using "$corrected\CORRECTED_DISES_Principal_Survey_MIDLINE_VF_WIDE_24Feb2025.xlsx", firstrow(variables) replace

