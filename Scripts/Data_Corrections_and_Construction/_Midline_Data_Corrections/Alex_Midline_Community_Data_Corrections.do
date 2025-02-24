*** Created by: Alex Mills ***
*** Updates recorded in GitHub ***
*==============================================================================
* use excel formula
* = "replace " & [@[issue_variable_name]]&" = "&[@correction]&" if key == "&CHAR(34)&[@[phone_resp]]&CHAR(34)


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
/*
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
*/

**************************************************
* APPLY CORRECTIONS TO SURVEY DATASET
**************************************************

import delimited "$data\Questionnaire Communautaire - NSF DISES MIDLINE VF_WIDE_24Feb2025.csv", clear varnames(1) bindquote(strict)

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

* Feb 24 2025
replace number_hh = 221 if key == "775574379"
replace number_hh = 150 if key == "775631152"
replace q64 = 3000 if key == "775574379"
replace q64 = 2500 if key == "776126116"
replace q_49 = 0 if key == "774126672"
replace q_49 = 0 if key == "785515798"
replace q_49 = 0 if key == "776098799"
replace q_49 = 0 if key == "772410928"
replace q_49 = 0 if key == "775502196"
replace q_49 = 0 if key == "784409612"
replace q_49 = 0 if key == "776420879"
replace q_49 = 0 if key == "776175133"
replace unit_convert_9 = 0 if key == "775631152"
replace number_hh = 100 if key == "773825297"
replace number_total = 1500 if key == "773825297"
replace q64 = 6250 if key == "775151153"
replace q66 = 10000 if key == "775151153"
replace q_43 = 12 if key == "771483510"
replace q_43 = 240 if key == "774984439"
replace q_43 = 60 if key == "777258909"
replace q_43 = 60 if key == "775333280"
replace q_43 = 240 if key == "778711457"
replace q_43 = 180 if key == "777923023"
replace q_43 = 12 if key == "775343266"
replace q_45 = 420 if key == "771712651"
replace unit_convert_1 = 70 if key == "773825297"
replace unit_convert_2 = 50 if key == "773825297"
replace unit_convert_3 = 30 if key == "773825297"
replace unit_convert_4 = 160 if key == "773825297"
replace unit_convert_5 = 160 if key == "773825297"
replace unit_convert_6 = 10 if key == "773825297"
replace unit_convert_7 = 5 if key == "773825297"
replace unit_convert_9 = 50 if key == "773825297"
replace unit_convert_9 = 50 if key == "771483510"
replace q66 = 6000 if key == "771871077"
replace q_43 = 60 if key == "775624831"
replace q_43 = 60 if key == "770795899"
replace q_43 = 60 if key == "775163723"
replace q_43 = 60 if key == "777083631"
replace q_43 = 60 if key == "772735684"
replace q_49 = 0 if key == "775399114"
replace unit_convert_5 = 100 if key == "771871077"
replace unit_convert_6 = 10 if key == "771871077"
replace q66 = 6000 if key == "773584945"
replace q_43 = 60 if key == "774159313"
replace unit_convert_10 = 50 if key == "775664893"
replace unit_convert_11 = 50 if key == "771621507"
replace unit_convert_11 = 50 if key == "775664893"
replace unit_convert_5 = 100 if key == "771621507"
replace unit_convert_6 = 10 if key == "771621507"
replace unit_convert_7 = 10 if key == "771621507"
replace unit_convert_7 = 10 if key == "774159313"
replace unit_convert_8 = 50 if key == "775664893"
replace unit_convert_9 = 50 if key == "775664893"

* Save the corrected dataset
export excel using "$corrected\CORRECTED_Community_Survey_24Feb2025.xlsx", firstrow(variables) replace
