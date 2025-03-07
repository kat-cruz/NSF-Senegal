*==============================================================================
* Community Survey Data Corrections - Midline
* Created by: Molly Doruska
* Adapted by: Alexander Mills
* Updates recorded in GitHub
*==============================================================================
*
* Description:
* This script processes community survey data from the DISES Midline study.
* It applies corrections to the main survey dataset based on phone_resp values.
*
* Inputs:
* Community Issues file: "$issues\Community_Issues_[INSERT DATE HERE].xlsx"
* Corrections file: "$corrections\[MOST RECENT CORRECTIONS FILE FROM THE EXTERNAL CORRECTIONS FOLDER] "
* Survey dataset: "$data\Questionnaire Communautaire - NSF DISES MIDLINE VF_WIDE_[INSERT DATE HERE].csv"
*
* Outputs:
* Corrected community survey data: "$corrected\CORRECTED_Community_Survey_6May2025.xlsx"
*
* Instructions for running the script:
* 1. Ensure Stata is running in a compatible environment.
* 2. Verify that the file paths are correctly set in the "SET FILE PATHS" section.
* 3. Run the script sequentially to process corrections and apply them to the dataset.
* 4. The final corrected dataset will be saved in the specified output directory.
*
*==============================================================================
* The corrections are drawn from the external corrections folder
* use excel formula in the corrections sheet from the external corrections to easily pull all corrections
* = "replace " & [@[issue_variable_name]]&" = "&[@correction]&" if phone_resp == "&CHAR(34)&[@[phone_resp]]&CHAR(34)


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
* APPLY CORRECTIONS TO SURVEY DATASET
**************************************************
* Use an excel formula in the external corrections file to get these

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
replace number_hh = 221 if phone_resp == 775574379
replace number_hh = 150 if phone_resp == 775631152
replace q64 = 3000 if phone_resp == 775574379
replace q64 = 2500 if phone_resp == 776126116
replace q_49 = 0 if phone_resp == 774126672
replace q_49 = 0 if phone_resp == 785515798
replace q_49 = 0 if phone_resp == 776098799
replace q_49 = 0 if phone_resp == 772410928
replace q_49 = 0 if phone_resp == 775502196
replace q_49 = 0 if phone_resp == 784409612
replace q_49 = 0 if phone_resp == 776420879
replace q_49 = 0 if phone_resp == 776175133
replace unit_convert_9 = 0 if phone_resp == 775631152
replace number_hh = 100 if phone_resp == 773825297
replace number_total = 1500 if phone_resp == 773825297
replace q64 = 6250 if phone_resp == 775151153
replace q66 = 10000 if phone_resp == 775151153
replace q_43 = 12 if phone_resp == 771483510
replace q_43 = 240 if phone_resp == 774984439
replace q_43 = 60 if phone_resp == 777258909
replace q_43 = 60 if phone_resp == 775333280
replace q_43 = 240 if phone_resp == 778711457
replace q_43 = 180 if phone_resp == 777923023
replace q_43 = 12 if phone_resp == 775343266
replace q_45 = 420 if phone_resp == 771712651
replace unit_convert_1 = 70 if phone_resp == 773825297
replace unit_convert_2 = 50 if phone_resp == 773825297
replace unit_convert_3 = 30 if phone_resp == 773825297
replace unit_convert_4 = 160 if phone_resp == 773825297
replace unit_convert_5 = 160 if phone_resp == 773825297
replace unit_convert_6 = 10 if phone_resp == 773825297
replace unit_convert_7 = 5 if phone_resp == 773825297
replace unit_convert_9 = 50 if phone_resp == 773825297
replace unit_convert_9 = 50 if phone_resp == 771483510
replace q66 = 6000 if phone_resp == 771871077
replace q_43 = 60 if phone_resp == 775624831
replace q_43 = 60 if phone_resp == 770795899
replace q_43 = 60 if phone_resp == 775163723
replace q_43 = 60 if phone_resp == 777083631
replace q_43 = 60 if phone_resp == 772735684
replace q_49 = 0 if phone_resp == 775399114
replace unit_convert_5 = 100 if phone_resp == 771871077
replace unit_convert_6 = 10 if phone_resp == 771871077
replace q66 = 6000 if phone_resp == 773584945
replace q_43 = 60 if phone_resp == 774159313
replace unit_convert_10 = 50 if phone_resp == 775664893
replace unit_convert_11 = 50 if phone_resp == 771621507
replace unit_convert_11 = 50 if phone_resp == 775664893
replace unit_convert_5 = 100 if phone_resp == 771621507
replace unit_convert_6 = 10 if phone_resp == 771621507
replace unit_convert_7 = 10 if phone_resp == 771621507
replace unit_convert_7 = 10 if phone_resp == 774159313
replace unit_convert_8 = 50 if phone_resp == 775664893
replace unit_convert_9 = 50 if phone_resp == 775664893

* Corrections 6May2025
replace q_43 = 180 if phone_resp == 779829326  // confirmed value
replace unit_convert_9 = 50 if phone_resp == 775631152

* Save the corrected dataset
export excel using "$corrected\CORRECTED_Community_Survey_6May2025.xlsx", firstrow(variables) replace
