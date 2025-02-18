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
global data "$master\_CRDES_RawData\Midline\Community_Survey_Data"
global issues "$master\Output\Data_Quality_Checks\Midline\Midline_Community_Issues"
global corrections "$master\External_Corrections\Issues for Justin and Amina\Midline\Issues"
global corrected "$master\Output\Data_Corrections\Midline"

**************************************************
* IMPORT AND PROCESS CORRECTIONS FILE
**************************************************

import excel "$corrections\Corrections communautaire (2).xlsx", clear firstrow

* Save as a temporary file for later use
tempfile corrections_temp

* Drop duplicate cases
duplicates drop phone_resp issue_variable_name print_issue correct, force

save `corrections_temp'

**************************************************
* IMPORT ISSUES FILE AND MERGE WITH CORRECTIONS
**************************************************

import excel "$issues\Community_Issues_16Feb2025.xlsx", clear firstrow

* Drop duplicates
duplicates drop phone_resp issue_variable_name print_issue, force

* Merge corrections with issues using a one-to-one match based on `phone_resp`
merge 1:1 phone_resp issue_variable_name print_issue using `corrections_temp'

* Keep only successfully merged observations (_merge == 3)
keep if _merge == 3
drop _merge

tempfile correctionskey_temp
save `correctionskey_temp'

* Save the corrections dataset including the key
export excel using "$issues\CORRECTIONS_COMMUNITY_16Feb2025.xlsx", firstrow(variables) replace

**************************************************
* APPLY CORRECTIONS TO SURVEY DATASET
**************************************************

import delimited "$data\Questionnaire Communautaire - NSF DISES MIDLINE VF_WIDE_16Feb2025.csv", clear varnames(1) bindquote(strict)

* Apply corrections based on `phone_resp`
replace unit_convert_9 = 50 if phone_resp == 771515236
replace unit_convert_6 = 5 if phone_resp == 771515236
replace unit_convert_2 = 20 if phone_resp == 771515236
replace unit_convert_3 = 10 if phone_resp == 771515236
replace unit_convert_1 = 45 if phone_resp == 771515236
replace unit_convert_7 = 15 if phone_resp == 771515236
replace unit_convert_4 = 100 if phone_resp == 771515236
replace unit_convert_5 = 100 if phone_resp == 771515236

replace unit_convert_6 = 5 if phone_resp == 770124818
replace unit_convert_7 = 12 if phone_resp == 770124818
replace unit_convert_3 = 10 if phone_resp == 770124818
replace unit_convert_5 = 100 if phone_resp == 770124818
replace unit_convert_4 = 100 if phone_resp == 770124818

replace unit_convert_7 = 12 if phone_resp == 775069012
replace unit_convert_3 = 10 if phone_resp == 775069012
replace unit_convert_4 = 100 if phone_resp == 775069012
replace unit_convert_5 = 100 if phone_resp == 775069012
replace unit_convert_6 = 5 if phone_resp == 775069012
replace unit_convert_2 = 20 if phone_resp == 775069012

replace q_49 = 1 if phone_resp == 782368101
replace q_49 = 1 if phone_resp == 775736989
* dealt with in the script
//replace q65 = "I confirm" if phone_resp == 775736989
replace number_hh = 260 if phone_resp == 773678341
//replace q_43 = "I confirm" if phone_resp == 779829326
//replace q65 = "I CONFIRM" if phone_resp == 772000363

* Save the corrected dataset
export excel using "$corrected\CORRECTED_Community_Survey_16Feb2025.xlsx", firstrow(variables) replace
