*** Created by: Alex Mills ***
*** Updates recorded in GitHub ***
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

import excel "$corrections\CORRECTIONS_QUESTIONNAIRE_PRINCIPAL_5Feb2025.xlsx", clear firstrow

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

* Save the corrected dataset
export excel using "$corrected\CORRECTED_DISES_Principal_Survey_MIDLINE_VF_WIDE_13Feb2025.xlsx", firstrow(variables) replace

