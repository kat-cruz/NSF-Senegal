*==============================================================================
* Community Survey Data Corrections - Midline
* Created by: Molly Doruska
* Adapted by: Alexander Mills
* Updates recorded in GitHub: [Alex_Midline_Community_Data_Corrections.do](https://github.com/kat-cruz/NSF-Senegal/blob/main/Scripts/Data_Processing/Corrections/_Midline_Data_Corrections/Alex_Midline_Community_Data_Corrections.do)

*>>>>>>>>>>*===========================* READ ME *===========================*<<<<<<<<<<<*
* Once you've done one round of the household checks and have gotten a round of corrections back, you should ensure that these issues do not repeatedly export as issues by setting the issue to 0 if that specific case

*
* Description:
* This script processes community survey data from the DISES Midline study.
* It applies corrections to the main survey dataset based on phone_resp values.
*
* Inputs:
* Community Issues file: "$issues\Community_Issues_[INSERT DATE HERE].xlsx"
* Corrections file: "$corrections\[MOST RECENT CORRECTIONS FILE FROM THE EXTERNAL CORRECTIONS FOLDER]"
* Survey dataset: "$data\Questionnaire Communautaire - NSF DISES MIDLINE VF_WIDE_[INSERT DATE HERE].csv"
*
* Outputs:
* Corrected community survey data: "$corrected\CORRECTED_Community_Survey_[INSERT DATE HERE].xlsx"
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
global data "$master\Data\_CRDES_RawData\Midline\Community_Survey_Data"
global issues "$master\Output\Data_Quality_Checks\Midline\Midline_Community_Issues"
global corrections "$master\External_Corrections\Issues for Justin and Amina\Midline\Issues"
global corrected "$master\Output\Data_Processing\Checks\Corrections\Midline"

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

* Correction 13May2025
replace unit_convert_6 = 25 if phone_resp == 777211261

* Corrections for 020A duplicate that should be 012B
foreach var of varlist * {
    capture confirm string variable `var'
    if !_rc {
        replace `var' = subinstr(`var', "020A", "012B", .) if abs(gps_collectlatitude - 16.01413) < 0.00001 & abs(gps_collectlongitude - (-15.90185)) < 0.00001
    }
}
* Correction for 051A that should be 130A
foreach var of varlist * {
    capture confirm string variable `var'
    if !_rc {
        replace `var' = subinstr(`var', "051A", "130A", .)
    }
}

* Correction for 132A that should be 153A
foreach var of varlist * {
    capture confirm string variable `var'
    if !_rc {
        replace `var' = subinstr(`var', "132A", "153A", .)
    }
}

* Wealth Stratum Corrections
replace pull_hhid_village_1 = "012B" if hhid_village == "012B"
replace pull_hhid_village_2 = "012B" if hhid_village == "012B"
replace pull_hhid_village_3 = "012B" if hhid_village == "012B"
replace pull_hhid_village_4 = "012B" if hhid_village == "012B"
replace pull_hhid_village_5 = "012B" if hhid_village == "012B"
replace pull_hhid_village_6 = "012B" if hhid_village == "012B"
replace pull_hhid_village_7 = "012B" if hhid_village == "012B"
replace pull_hhid_village_8 = "012B" if hhid_village == "012B"
replace pull_hhid_village_9 = "012B" if hhid_village == "012B"
replace pull_hhid_village_10 = "012B" if hhid_village == "012B"
replace pull_hhid_village_11 = "012B" if hhid_village == "012B"
replace pull_hhid_village_12 = "012B" if hhid_village == "012B"
replace pull_hhid_village_13 = "012B" if hhid_village == "012B"
replace pull_hhid_village_14 = "012B" if hhid_village == "012B"
replace pull_hhid_village_15 = "012B" if hhid_village == "012B"
replace pull_hhid_village_16 = "012B" if hhid_village == "012B"
replace pull_hhid_village_17 = "012B" if hhid_village == "012B"
replace pull_hhid_village_18 = "012B" if hhid_village == "012B"
replace pull_hhid_village_19 = "012B" if hhid_village == "012B"
replace pull_hhid_village_20 = "012B" if hhid_village == "012B"
replace pull_hhid_village_1 = "130A" if hhid_village == "130A"
replace pull_hhid_village_2 = "130A" if hhid_village == "130A"
replace pull_hhid_village_3 = "130A" if hhid_village == "130A"
replace pull_hhid_village_4 = "130A" if hhid_village == "130A"
replace pull_hhid_village_5 = "130A" if hhid_village == "130A"
replace pull_hhid_village_6 = "130A" if hhid_village == "130A"
replace pull_hhid_village_7 = "130A" if hhid_village == "130A"
replace pull_hhid_village_8 = "130A" if hhid_village == "130A"
replace pull_hhid_village_9 = "130A" if hhid_village == "130A"
replace pull_hhid_village_10 = "130A" if hhid_village == "130A"
replace pull_hhid_village_11 = "130A" if hhid_village == "130A"
replace pull_hhid_village_12 = "130A" if hhid_village == "130A"
replace pull_hhid_village_13 = "130A" if hhid_village == "130A"
replace pull_hhid_village_14 = "130A" if hhid_village == "130A"
replace pull_hhid_village_15 = "130A" if hhid_village == "130A"
replace pull_hhid_village_16 = "130A" if hhid_village == "130A"
replace pull_hhid_village_17 = "130A" if hhid_village == "130A"
replace pull_hhid_village_18 = "130A" if hhid_village == "130A"
replace pull_hhid_village_19 = "130A" if hhid_village == "130A"
replace pull_hhid_village_20 = "130A" if hhid_village == "130A"

replace pull_hhid_1 = "012B10" if hhid_village == "012B"
replace pull_hhid_2 = "012B14" if hhid_village == "012B"
replace pull_hhid_3 = "012B13" if hhid_village == "012B"
replace pull_hhid_4 = "012B02" if hhid_village == "012B"
replace pull_hhid_5 = "012B18" if hhid_village == "012B"
replace pull_hhid_6 = "012B07" if hhid_village == "012B"
replace pull_hhid_7 = "012B16" if hhid_village == "012B"
replace pull_hhid_8 = "012B17" if hhid_village == "012B"
replace pull_hhid_9 = "012B04" if hhid_village == "012B"
replace pull_hhid_10 = "012B15" if hhid_village == "012B"
replace pull_hhid_11 = "012B11" if hhid_village == "012B"
replace pull_hhid_12 = "012B09" if hhid_village == "012B"
replace pull_hhid_13 = "012B12" if hhid_village == "012B"
replace pull_hhid_14 = "012B01" if hhid_village == "012B"
replace pull_hhid_15 = "012B03" if hhid_village == "012B"
replace pull_hhid_16 = "012B20" if hhid_village == "012B"
replace pull_hhid_17 = "012B19" if hhid_village == "012B"
replace pull_hhid_18 = "012B05" if hhid_village == "012B"
replace pull_hhid_19 = "012B08" if hhid_village == "012B"
replace pull_hhid_20 = "012B06" if hhid_village == "012B"
replace pull_hhid_1 = "130A14" if hhid_village == "130A"
replace pull_hhid_2 = "130A16" if hhid_village == "130A"
replace pull_hhid_3 = "130A05" if hhid_village == "130A"
replace pull_hhid_4 = "130A02" if hhid_village == "130A"
replace pull_hhid_5 = "130A04" if hhid_village == "130A"
replace pull_hhid_6 = "130A12" if hhid_village == "130A"
replace pull_hhid_7 = "130A01" if hhid_village == "130A"
replace pull_hhid_8 = "130A15" if hhid_village == "130A"
replace pull_hhid_9 = "130A10" if hhid_village == "130A"
replace pull_hhid_10 = "130A06" if hhid_village == "130A"
replace pull_hhid_11 = "130A11" if hhid_village == "130A"
replace pull_hhid_12 = "130A20" if hhid_village == "130A"
replace pull_hhid_13 = "130A08" if hhid_village == "130A"
replace pull_hhid_14 = "130A17" if hhid_village == "130A"
replace pull_hhid_15 = "130A19" if hhid_village == "130A"
replace pull_hhid_16 = "130A18" if hhid_village == "130A"
replace pull_hhid_17 = "130A09" if hhid_village == "130A"
replace pull_hhid_18 = "130A03" if hhid_village == "130A"
replace pull_hhid_19 = "130A13" if hhid_village == "130A"
replace pull_hhid_20 = "130A07" if hhid_village == "130A"

replace pull_individ_1 = "012B1001" if hhid_village == "012B"
replace pull_individ_2 = "012B1401" if hhid_village == "012B"
replace pull_individ_3 = "012B1301" if hhid_village == "012B"
replace pull_individ_4 = "012B0201" if hhid_village == "012B"
replace pull_individ_5 = "012B1801" if hhid_village == "012B"
replace pull_individ_6 = "012B0701" if hhid_village == "012B"
replace pull_individ_7 = "012B1601" if hhid_village == "012B"
replace pull_individ_8 = "012B1701" if hhid_village == "012B"
replace pull_individ_9 = "012B0401" if hhid_village == "012B"
replace pull_individ_10 = "012B1501" if hhid_village == "012B"
replace pull_individ_11 = "012B1101" if hhid_village == "012B"
replace pull_individ_12 = "012B0901" if hhid_village == "012B"
replace pull_individ_13 = "012B1201" if hhid_village == "012B"
replace pull_individ_14 = "012B0101" if hhid_village == "012B"
replace pull_individ_15 = "012B0301" if hhid_village == "012B"
replace pull_individ_16 = "012B2001" if hhid_village == "012B"
replace pull_individ_17 = "012B1901" if hhid_village == "012B"
replace pull_individ_18 = "012B0501" if hhid_village == "012B"
replace pull_individ_19 = "012B0801" if hhid_village == "012B"
replace pull_individ_20 = "012B0601" if hhid_village == "012B"
replace pull_individ_1 = "130A1401" if hhid_village == "130A"
replace pull_individ_2 = "130A1601" if hhid_village == "130A"
replace pull_individ_3 = "130A0501" if hhid_village == "130A"
replace pull_individ_4 = "130A0201" if hhid_village == "130A"
replace pull_individ_5 = "130A0401" if hhid_village == "130A"
replace pull_individ_6 = "130A1201" if hhid_village == "130A"
replace pull_individ_7 = "130A0101" if hhid_village == "130A"
replace pull_individ_8 = "130A1501" if hhid_village == "130A"
replace pull_individ_9 = "130A1001" if hhid_village == "130A"
replace pull_individ_10 = "130A0601" if hhid_village == "130A"
replace pull_individ_11 = "130A1101" if hhid_village == "130A"
replace pull_individ_12 = "130A2001" if hhid_village == "130A"
replace pull_individ_13 = "130A0801" if hhid_village == "130A"
replace pull_individ_14 = "130A1701" if hhid_village == "130A"
replace pull_individ_15 = "130A1901" if hhid_village == "130A"
replace pull_individ_16 = "130A1801" if hhid_village == "130A"
replace pull_individ_17 = "130A0901" if hhid_village == "130A"
replace pull_individ_18 = "130A0301" if hhid_village == "130A"
replace pull_individ_19 = "130A1301" if hhid_village == "130A"
replace pull_individ_20 = "130A0701" if hhid_village == "130A"

replace pull_hh_head_name_complet_1 = "ALIOU SOUARE" if hhid_village == "012B"
replace pull_hh_head_name_complet_2 = "DEMBA SOIRÃ" if hhid_village == "012B"
replace pull_hh_head_name_complet_3 = "Khalifa SAMB" if hhid_village == "012B"
replace pull_hh_head_name_complet_4 = "Ndiaw DIOP" if hhid_village == "012B"
replace pull_hh_head_name_complet_5 = "ANTA DIAW" if hhid_village == "012B"
replace pull_hh_head_name_complet_6 = "Aya Guaye" if hhid_village == "012B"
replace pull_hh_head_name_complet_7 = "Djibril GUAYE" if hhid_village == "012B"
replace pull_hh_head_name_complet_8 = "Elhadji Hann" if hhid_village == "012B"
replace pull_hh_head_name_complet_9 = "CHEIKHOU NIANG" if hhid_village == "012B"
replace pull_hh_head_name_complet_10 = "MAME FAMA DIOUF" if hhid_village == "012B"
replace pull_hh_head_name_complet_11 = "MASSECK DIOP" if hhid_village == "012B"
replace pull_hh_head_name_complet_12 = "PAPE SOUARE" if hhid_village == "012B"
replace pull_hh_head_name_complet_13 = "ALPHA NDIOGUE" if hhid_village == "012B"
replace pull_hh_head_name_complet_14 = "AMADOU SOUWARE" if hhid_village == "012B"
replace pull_hh_head_name_complet_15 = "CHEIKH TIDIANE DIOGUE" if hhid_village == "012B"
replace pull_hh_head_name_complet_16 = "MAMADOU SY" if hhid_village == "012B"
replace pull_hh_head_name_complet_17 = "Aly Sock" if hhid_village == "012B"
replace pull_hh_head_name_complet_18 = "Awa Sock" if hhid_village == "012B"
replace pull_hh_head_name_complet_19 = "Cheikhou SouarÃ©" if hhid_village == "012B"
replace pull_hh_head_name_complet_20 = "Mame Sarr Sock" if hhid_village == "012B"
replace pull_hh_head_name_complet_1 = "BABACAR MBAYE" if hhid_village == "130A"
replace pull_hh_head_name_complet_2 = "Baye Aly MBAYE" if hhid_village == "130A"
replace pull_hh_head_name_complet_3 = "MADIOP MBAYE" if hhid_village == "130A"
replace pull_hh_head_name_complet_4 = "Moustapha MBAYE" if hhid_village == "130A"
replace pull_hh_head_name_complet_5 = "BABA NGUERE" if hhid_village == "130A"
replace pull_hh_head_name_complet_6 = "DAOUDA NGUERE" if hhid_village == "130A"
replace pull_hh_head_name_complet_7 = "MAGUETTE DIEYE" if hhid_village == "130A"
replace pull_hh_head_name_complet_8 = "MARIEME NGUERE" if hhid_village == "130A"
replace pull_hh_head_name_complet_9 = "ASSANE FALL" if hhid_village == "130A"
replace pull_hh_head_name_complet_10 = "ATOUMANE FALL" if hhid_village == "130A"
replace pull_hh_head_name_complet_11 = "MASSAW FALL" if hhid_village == "130A"
replace pull_hh_head_name_complet_12 = "MOUSTAPHA DIÃMÃ" if hhid_village == "130A"
replace pull_hh_head_name_complet_13 = "ALHADJ MBAYE" if hhid_village == "130A"
replace pull_hh_head_name_complet_14 = "ALY SAFI MBAYE" if hhid_village == "130A"
replace pull_hh_head_name_complet_15 = "MBAYE SEYE MBAYE" if hhid_village == "130A"
replace pull_hh_head_name_complet_16 = "NDIACK MBAYE" if hhid_village == "130A"
replace pull_hh_head_name_complet_17 = "Bouya Fall" if hhid_village == "130A"
replace pull_hh_head_name_complet_18 = "Diadji Fall" if hhid_village == "130A"
replace pull_hh_head_name_complet_19 = "Mafall Fall" if hhid_village == "130A"
replace pull_hh_head_name_complet_20 = "Massaer Fall" if hhid_village == "130A"

replace pull_hh_name_complet_resp_1 = "Aliou SOUARE" if hhid_village == "012B"
replace pull_hh_name_complet_resp_2 = "Bougouma DIEYE" if hhid_village == "012B"
replace pull_hh_name_complet_resp_3 = "Khalifa SAMB" if hhid_village == "012B"
replace pull_hh_name_complet_resp_4 = "Ndiaw DIOP" if hhid_village == "012B"
replace pull_hh_name_complet_resp_5 = "ANTA DIAW" if hhid_village == "012B"
replace pull_hh_name_complet_resp_6 = "Aya Guaye" if hhid_village == "012B"
replace pull_hh_name_complet_resp_7 = "Djibril GUAYE" if hhid_village == "012B"
replace pull_hh_name_complet_resp_8 = "Elhadji Hann" if hhid_village == "012B"
replace pull_hh_name_complet_resp_9 = "CHEIKHOU NIANG" if hhid_village == "012B"
replace pull_hh_name_complet_resp_10 = "MAME FAMA DIOUF" if hhid_village == "012B"
replace pull_hh_name_complet_resp_11 = "YARAM DIEYE" if hhid_village == "012B"
replace pull_hh_name_complet_resp_12 = "PAPE SOUARE" if hhid_village == "012B"
replace pull_hh_name_complet_resp_13 = "FATOU SOW" if hhid_village == "012B"
replace pull_hh_name_complet_resp_14 = "FA SECK DIENG" if hhid_village == "012B"
replace pull_hh_name_complet_resp_15 = "CHEIKH TIDIANE DIOGUE" if hhid_village == "012B"
replace pull_hh_name_complet_resp_16 = "MAMADOU SY" if hhid_village == "012B"
replace pull_hh_name_complet_resp_17 = "MarÃ©me Dia" if hhid_village == "012B"
replace pull_hh_name_complet_resp_18 = "Awa Sock" if hhid_village == "012B"
replace pull_hh_name_complet_resp_19 = "Cheikhou SouarÃ©" if hhid_village == "012B"
replace pull_hh_name_complet_resp_20 = "Mame Sarr Sock" if hhid_village == "012B"
replace pull_hh_name_complet_resp_1 = "BABACAR MBAYE" if hhid_village == "130A"
replace pull_hh_name_complet_resp_2 = "Mor MBAYE" if hhid_village == "130A"
replace pull_hh_name_complet_resp_3 = "MADIOP MBAYE" if hhid_village == "130A"
replace pull_hh_name_complet_resp_4 = "MOUSTAPHA MBAYE" if hhid_village == "130A"
replace pull_hh_name_complet_resp_5 = "BABA NGUERE" if hhid_village == "130A"
replace pull_hh_name_complet_resp_6 = "DAOUDA NGUERE" if hhid_village == "130A"
replace pull_hh_name_complet_resp_7 = "MAGUETTE DIEYE" if hhid_village == "130A"
replace pull_hh_name_complet_resp_8 = "MAMOUR NGUERE" if hhid_village == "130A"
replace pull_hh_name_complet_resp_9 = "ASSANE FALL" if hhid_village == "130A"
replace pull_hh_name_complet_resp_10 = "ATOUMANE FALL" if hhid_village == "130A"
replace pull_hh_name_complet_resp_11 = "MASSAW FALL" if hhid_village == "130A"
replace pull_hh_name_complet_resp_12 = "MOUSTAPHA DIÃMÃ" if hhid_village == "130A"
replace pull_hh_name_complet_resp_13 = "ALHADJ MBAYE" if hhid_village == "130A"
replace pull_hh_name_complet_resp_14 = "ALY SAFI MBAYE" if hhid_village == "130A"
replace pull_hh_name_complet_resp_15 = "MOUSTAPHA MBAYE" if hhid_village == "130A"
replace pull_hh_name_complet_resp_16 = "NDIACK MBAYE" if hhid_village == "130A"
replace pull_hh_name_complet_resp_17 = "Bouya Fall" if hhid_village == "130A"
replace pull_hh_name_complet_resp_18 = "Diadji Fall" if hhid_village == "130A"
replace pull_hh_name_complet_resp_19 = "Mafall fall" if hhid_village == "130A"
replace pull_hh_name_complet_resp_20 = "Massaer Fall" if hhid_village == "130A"

replace pull_hh_age_resp_1 = 47 if hhid_village == "012B"
replace pull_hh_age_resp_2 = 70 if hhid_village == "012B"
replace pull_hh_age_resp_3 = 43 if hhid_village == "012B"
replace pull_hh_age_resp_4 = 67 if hhid_village == "012B"
replace pull_hh_age_resp_5 = 59 if hhid_village == "012B"
replace pull_hh_age_resp_6 = 65 if hhid_village == "012B"
replace pull_hh_age_resp_7 = 53 if hhid_village == "012B"
replace pull_hh_age_resp_8 = 43 if hhid_village == "012B"
replace pull_hh_age_resp_9 = 56 if hhid_village == "012B"
replace pull_hh_age_resp_10 = 49 if hhid_village == "012B"
replace pull_hh_age_resp_11 = 45 if hhid_village == "012B"
replace pull_hh_age_resp_12 = 45 if hhid_village == "012B"
replace pull_hh_age_resp_13 = 29 if hhid_village == "012B"
replace pull_hh_age_resp_14 = 62 if hhid_village == "012B"
replace pull_hh_age_resp_15 = 63 if hhid_village == "012B"
replace pull_hh_age_resp_16 = 46 if hhid_village == "012B"
replace pull_hh_age_resp_17 = 25 if hhid_village == "012B"
replace pull_hh_age_resp_18 = 45 if hhid_village == "012B"
replace pull_hh_age_resp_19 = 63 if hhid_village == "012B"
replace pull_hh_age_resp_20 = 70 if hhid_village == "012B"
replace pull_hh_age_resp_1 = 67 if hhid_village == "130A"
replace pull_hh_age_resp_2 = 34 if hhid_village == "130A"
replace pull_hh_age_resp_3 = 61 if hhid_village == "130A"
replace pull_hh_age_resp_4 = 60 if hhid_village == "130A"
replace pull_hh_age_resp_5 = 68 if hhid_village == "130A"
replace pull_hh_age_resp_6 = 59 if hhid_village == "130A"
replace pull_hh_age_resp_7 = 80 if hhid_village == "130A"
replace pull_hh_age_resp_8 = 30 if hhid_village == "130A"
replace pull_hh_age_resp_9 = 59 if hhid_village == "130A"
replace pull_hh_age_resp_10 = 70 if hhid_village == "130A"
replace pull_hh_age_resp_11 = 52 if hhid_village == "130A"
replace pull_hh_age_resp_12 = 65 if hhid_village == "130A"
replace pull_hh_age_resp_13 = 76 if hhid_village == "130A"
replace pull_hh_age_resp_14 = 56 if hhid_village == "130A"
replace pull_hh_age_resp_15 = 45 if hhid_village == "130A"
replace pull_hh_age_resp_16 = 75 if hhid_village == "130A"
replace pull_hh_age_resp_17 = 50 if hhid_village == "130A"
replace pull_hh_age_resp_18 = 51 if hhid_village == "130A"
replace pull_hh_age_resp_19 = 70 if hhid_village == "130A"
replace pull_hh_age_resp_20 = 55 if hhid_village == "130A"


replace pull_hh_gender_resp_1 = 1 if hhid_village == "012B"
replace pull_hh_gender_resp_2 = 2 if hhid_village == "012B"
replace pull_hh_gender_resp_3 = 1 if hhid_village == "012B"
replace pull_hh_gender_resp_4 = 1 if hhid_village == "012B"
replace pull_hh_gender_resp_5 = 2 if hhid_village == "012B"
replace pull_hh_gender_resp_6 = 1 if hhid_village == "012B"
replace pull_hh_gender_resp_7 = 1 if hhid_village == "012B"
replace pull_hh_gender_resp_8 = 1 if hhid_village == "012B"
replace pull_hh_gender_resp_9 = 1 if hhid_village == "012B"
replace pull_hh_gender_resp_10 = 2 if hhid_village == "012B"
replace pull_hh_gender_resp_11 = 2 if hhid_village == "012B"
replace pull_hh_gender_resp_12 = 1 if hhid_village == "012B"
replace pull_hh_gender_resp_13 = 2 if hhid_village == "012B"
replace pull_hh_gender_resp_14 = 2 if hhid_village == "012B"
replace pull_hh_gender_resp_15 = 1 if hhid_village == "012B"
replace pull_hh_gender_resp_16 = 1 if hhid_village == "012B"
replace pull_hh_gender_resp_17 = 2 if hhid_village == "012B"
replace pull_hh_gender_resp_18 = 2 if hhid_village == "012B"
replace pull_hh_gender_resp_19 = 1 if hhid_village == "012B"
replace pull_hh_gender_resp_20 = 1 if hhid_village == "012B"
replace pull_hh_gender_resp_1 = 1 if hhid_village == "130A"
replace pull_hh_gender_resp_2 = 1 if hhid_village == "130A"
replace pull_hh_gender_resp_3 = 1 if hhid_village == "130A"
replace pull_hh_gender_resp_4 = 1 if hhid_village == "130A"
replace pull_hh_gender_resp_5 = 1 if hhid_village == "130A"
replace pull_hh_gender_resp_6 = 1 if hhid_village == "130A"
replace pull_hh_gender_resp_7 = 1 if hhid_village == "130A"
replace pull_hh_gender_resp_8 = 1 if hhid_village == "130A"
replace pull_hh_gender_resp_9 = 1 if hhid_village == "130A"
replace pull_hh_gender_resp_10 = 1 if hhid_village == "130A"
replace pull_hh_gender_resp_11 = 1 if hhid_village == "130A"
replace pull_hh_gender_resp_12 = 1 if hhid_village == "130A"
replace pull_hh_gender_resp_13 = 1 if hhid_village == "130A"
replace pull_hh_gender_resp_14 = 1 if hhid_village == "130A"
replace pull_hh_gender_resp_15 = 1 if hhid_village == "130A"
replace pull_hh_gender_resp_16 = 1 if hhid_village == "130A"
replace pull_hh_gender_resp_17 = 1 if hhid_village == "130A"
replace pull_hh_gender_resp_18 = 1 if hhid_village == "130A"
replace pull_hh_gender_resp_19 = 1 if hhid_village == "130A"
replace pull_hh_gender_resp_20 = 1 if hhid_village == "130A"

replace pull_hh_phone_1 = 771185399 if hhid_village == "012B"
replace pull_hh_phone_2 = 777735220 if hhid_village == "012B"
replace pull_hh_phone_3 = 779762721 if hhid_village == "012B"
replace pull_hh_phone_4 = 774239517 if hhid_village == "012B"
replace pull_hh_phone_5 = 782115653 if hhid_village == "012B"
replace pull_hh_phone_6 = 774207117 if hhid_village == "012B"
replace pull_hh_phone_7 = 771069479 if hhid_village == "012B"
replace pull_hh_phone_8 = 782707962 if hhid_village == "012B"
replace pull_hh_phone_9 = 774743053 if hhid_village == "012B"
replace pull_hh_phone_10 = 777252232 if hhid_village == "012B"
replace pull_hh_phone_11 = 779880584 if hhid_village == "012B"
replace pull_hh_phone_12 = 772065446 if hhid_village == "012B"
replace pull_hh_phone_13 = 781082350 if hhid_village == "012B"
replace pull_hh_phone_14 = 773799306 if hhid_village == "012B"
replace pull_hh_phone_15 = 773517227 if hhid_village == "012B"
replace pull_hh_phone_16 = 783095912 if hhid_village == "012B"
replace pull_hh_phone_17 = 782533585 if hhid_village == "012B"
replace pull_hh_phone_18 = 785689445 if hhid_village == "012B"
replace pull_hh_phone_19 = 775097957 if hhid_village == "012B"
replace pull_hh_phone_20 = 773974919 if hhid_village == "012B"
replace pull_hh_phone_1 = 774390700 if hhid_village == "130A"
replace pull_hh_phone_2 = 774092978 if hhid_village == "130A"
replace pull_hh_phone_3 = 772736925 if hhid_village == "130A"
replace pull_hh_phone_4 = 772396284 if hhid_village == "130A"
replace pull_hh_phone_5 = 772674743 if hhid_village == "130A"
replace pull_hh_phone_6 = 774414762 if hhid_village == "130A"
replace pull_hh_phone_7 = 771551284 if hhid_village == "130A"
replace pull_hh_phone_8 = 782943582 if hhid_village == "130A"
replace pull_hh_phone_9 = 772413270 if hhid_village == "130A"
replace pull_hh_phone_10 = 775861268 if hhid_village == "130A"
replace pull_hh_phone_11 = 775486926 if hhid_village == "130A"
replace pull_hh_phone_12 = 773713097 if hhid_village == "130A"
replace pull_hh_phone_13 = 775070149 if hhid_village == "130A"
replace pull_hh_phone_14 = 777921920 if hhid_village == "130A"
replace pull_hh_phone_15 = 772753922 if hhid_village == "130A"
replace pull_hh_phone_16 = 774159276 if hhid_village == "130A"
replace pull_hh_phone_17 = 774471938 if hhid_village == "130A"
replace pull_hh_phone_18 = 774213661 if hhid_village == "130A"
replace pull_hh_phone_19 = 774418778 if hhid_village == "130A"
replace pull_hh_phone_20 = 776715511 if hhid_village == "130A"


replace pull_individual_1 = 1 if hhid_village == "012B"
replace pull_individual_2 = 1 if hhid_village == "012B"
replace pull_individual_3 = 1 if hhid_village == "012B"
replace pull_individual_4 = 1 if hhid_village == "012B"
replace pull_individual_5 = 1 if hhid_village == "012B"
replace pull_individual_6 = 1 if hhid_village == "012B"
replace pull_individual_7 = 1 if hhid_village == "012B"
replace pull_individual_8 = 1 if hhid_village == "012B"
replace pull_individual_9 = 1 if hhid_village == "012B"
replace pull_individual_10 = 1 if hhid_village == "012B"
replace pull_individual_11 = 1 if hhid_village == "012B"
replace pull_individual_12 = 1 if hhid_village == "012B"
replace pull_individual_13 = 1 if hhid_village == "012B"
replace pull_individual_14 = 1 if hhid_village == "012B"
replace pull_individual_15 = 1 if hhid_village == "012B"
replace pull_individual_16 = 1 if hhid_village == "012B"
replace pull_individual_17 = 1 if hhid_village == "012B"
replace pull_individual_18 = 1 if hhid_village == "012B"
replace pull_individual_19 = 1 if hhid_village == "012B"
replace pull_individual_20 = 1 if hhid_village == "012B"
replace pull_individual_1 = 1 if hhid_village == "130A"
replace pull_individual_2 = 1 if hhid_village == "130A"
replace pull_individual_3 = 1 if hhid_village == "130A"
replace pull_individual_4 = 1 if hhid_village == "130A"
replace pull_individual_5 = 1 if hhid_village == "130A"
replace pull_individual_6 = 1 if hhid_village == "130A"
replace pull_individual_7 = 1 if hhid_village == "130A"
replace pull_individual_8 = 1 if hhid_village == "130A"
replace pull_individual_9 = 1 if hhid_village == "130A"
replace pull_individual_10 = 1 if hhid_village == "130A"
replace pull_individual_11 = 1 if hhid_village == "130A"
replace pull_individual_12 = 1 if hhid_village == "130A"
replace pull_individual_13 = 1 if hhid_village == "130A"
replace pull_individual_14 = 1 if hhid_village == "130A"
replace pull_individual_15 = 1 if hhid_village == "130A"
replace pull_individual_16 = 1 if hhid_village == "130A"
replace pull_individual_17 = 1 if hhid_village == "130A"
replace pull_individual_18 = 1 if hhid_village == "130A"
replace pull_individual_19 = 1 if hhid_village == "130A"
replace pull_individual_20 = 1 if hhid_village == "130A"

replace pull_hh_full_name_calc__1 = "ALIOU SOUARE" if hhid_village == "012B"
replace pull_hh_full_name_calc__2 = "DEMBA SOIRÃ" if hhid_village == "012B"
replace pull_hh_full_name_calc__3 = "Khalifa SAMB" if hhid_village == "012B"
replace pull_hh_full_name_calc__4 = "Ndiaw DIOP" if hhid_village == "012B"
replace pull_hh_full_name_calc__5 = "ANTA DIAW" if hhid_village == "012B"
replace pull_hh_full_name_calc__6 = "Aya Guaye" if hhid_village == "012B"
replace pull_hh_full_name_calc__7 = "Djibril GUAYE" if hhid_village == "012B"
replace pull_hh_full_name_calc__8 = "Elhadji Hann" if hhid_village == "012B"
replace pull_hh_full_name_calc__9 = "CHEIKHOU NIANG" if hhid_village == "012B"
replace pull_hh_full_name_calc__10 = "MAME FAMA DIOUF" if hhid_village == "012B"
replace pull_hh_full_name_calc__11 = "MASSECK DIOP" if hhid_village == "012B"
replace pull_hh_full_name_calc__12 = "PAPE SOUARE" if hhid_village == "012B"
replace pull_hh_full_name_calc__13 = "ALPHA NDIOGUE" if hhid_village == "012B"
replace pull_hh_full_name_calc__14 = "AMADOU SOUWARE" if hhid_village == "012B"
replace pull_hh_full_name_calc__15 = "CHEIKH TIDIANE DIOGUE" if hhid_village == "012B"
replace pull_hh_full_name_calc__16 = "MAMADOU SY" if hhid_village == "012B"
replace pull_hh_full_name_calc__17 = "Aly Sock" if hhid_village == "012B"
replace pull_hh_full_name_calc__18 = "Awa Sock" if hhid_village == "012B"
replace pull_hh_full_name_calc__19 = "Cheikhou SouarÃ©" if hhid_village == "012B"
replace pull_hh_full_name_calc__20 = "Mame Sarr Sock" if hhid_village == "012B"
replace pull_hh_full_name_calc__1 = "BABACAR MBAYE" if hhid_village == "130A"
replace pull_hh_full_name_calc__2 = "Baye Aly MBAYE" if hhid_village == "130A"
replace pull_hh_full_name_calc__3 = "MADIOP MBAYE" if hhid_village == "130A"
replace pull_hh_full_name_calc__4 = "Moustapha MBAYE" if hhid_village == "130A"
replace pull_hh_full_name_calc__5 = "BABA NGUERE" if hhid_village == "130A"
replace pull_hh_full_name_calc__6 = "DAOUDA NGUERE" if hhid_village == "130A"
replace pull_hh_full_name_calc__7 = "MAGUETTE DIEYE" if hhid_village == "130A"
replace pull_hh_full_name_calc__8 = "MARIEME NGUERE" if hhid_village == "130A"
replace pull_hh_full_name_calc__9 = "ASSANE FALL" if hhid_village == "130A"
replace pull_hh_full_name_calc__10 = "ATOUMANE FALL" if hhid_village == "130A"
replace pull_hh_full_name_calc__11 = "MASSAW FALL" if hhid_village == "130A"
replace pull_hh_full_name_calc__12 = "MOUSTAPHA DIÃMÃ" if hhid_village == "130A"
replace pull_hh_full_name_calc__13 = "ALHADJ MBAYE" if hhid_village == "130A"
replace pull_hh_full_name_calc__14 = "ALY SAFI MBAYE" if hhid_village == "130A"
replace pull_hh_full_name_calc__15 = "MBAYE SEYE MBAYE" if hhid_village == "130A"
replace pull_hh_full_name_calc__16 = "NDIACK MBAYE" if hhid_village == "130A"
replace pull_hh_full_name_calc__17 = "Bouya Fall" if hhid_village == "130A"
replace pull_hh_full_name_calc__18 = "Diadji Fall" if hhid_village == "130A"
replace pull_hh_full_name_calc__19 = "Mafall Fall" if hhid_village == "130A"
replace pull_hh_full_name_calc__20 = "Massaer Fall" if hhid_village == "130A"


**** still need to draw in the rest 
/*
1	Plus riche
2	Moins riche
*/

replace wealth_stratum_02_1 = 1 if hhid_village == "012B"
replace wealth_stratum_02_2 = 2 if hhid_village == "012B"
replace wealth_stratum_02_3 = 1 if hhid_village == "012B"
replace wealth_stratum_02_4 = 1 if hhid_village == "012B"
replace wealth_stratum_02_5 = 2 if hhid_village == "012B"
replace wealth_stratum_02_6 = 1 if hhid_village == "012B"
replace wealth_stratum_02_7 = 2 if hhid_village == "012B"
replace wealth_stratum_02_8 = 2 if hhid_village == "012B"
replace wealth_stratum_02_9 = 2 if hhid_village == "012B"
replace wealth_stratum_02_10 = 2 if hhid_village == "012B"
replace wealth_stratum_02_11 = 2 if hhid_village == "012B"
replace wealth_stratum_02_12 = 1 if hhid_village == "012B"
replace wealth_stratum_02_13 = 2 if hhid_village == "012B"
replace wealth_stratum_02_14 = 2 if hhid_village == "012B"
replace wealth_stratum_02_15 = 1 if hhid_village == "012B"
replace wealth_stratum_02_16 = 2 if hhid_village == "012B"
replace wealth_stratum_02_17 = 2 if hhid_village == "012B"
replace wealth_stratum_02_18 = 1 if hhid_village == "012B"
replace wealth_stratum_02_19 = 2 if hhid_village == "012B"
replace wealth_stratum_02_20 = 2 if hhid_village == "012B"
replace wealth_stratum_02_1 = 2 if hhid_village == "130A"
replace wealth_stratum_02_2 = 2 if hhid_village == "130A"
replace wealth_stratum_02_3 = 1 if hhid_village == "130A"
replace wealth_stratum_02_4 = 1 if hhid_village == "130A"
replace wealth_stratum_02_5 = 1 if hhid_village == "130A"
replace wealth_stratum_02_6 = 1 if hhid_village == "130A"
replace wealth_stratum_02_7 = 2 if hhid_village == "130A"
replace wealth_stratum_02_8 = 1 if hhid_village == "130A"
replace wealth_stratum_02_9 = 2 if hhid_village == "130A"
replace wealth_stratum_02_10 = 2 if hhid_village == "130A"
replace wealth_stratum_02_11 = 1 if hhid_village == "130A"
replace wealth_stratum_02_12 = 2 if hhid_village == "130A"
replace wealth_stratum_02_13 = 2 if hhid_village == "130A"
replace wealth_stratum_02_14 = 1 if hhid_village == "130A"
replace wealth_stratum_02_15 = 1 if hhid_village == "130A"
replace wealth_stratum_02_16 = 2 if hhid_village == "130A"
replace wealth_stratum_02_17 = 1 if hhid_village == "130A"
replace wealth_stratum_02_18 = 1 if hhid_village == "130A"
replace wealth_stratum_02_19 = 2 if hhid_village == "130A"
replace wealth_stratum_02_20 = 2 if hhid_village == "130A"


replace wealth_stratum_03_1 = 1 if hhid_village == "012B"
replace wealth_stratum_03_2 = 1 if hhid_village == "012B"
replace wealth_stratum_03_3 = 1 if hhid_village == "012B"
replace wealth_stratum_03_4 = 1 if hhid_village == "012B"
replace wealth_stratum_03_5 = 1 if hhid_village == "012B"
replace wealth_stratum_03_6 = 1 if hhid_village == "012B"
replace wealth_stratum_03_7 = 1 if hhid_village == "012B"
replace wealth_stratum_03_8 = 1 if hhid_village == "012B"
replace wealth_stratum_03_9 = 1 if hhid_village == "012B"
replace wealth_stratum_03_10 = 1 if hhid_village == "012B"
replace wealth_stratum_03_11 = 1 if hhid_village == "012B"
replace wealth_stratum_03_12 = 1 if hhid_village == "012B"
replace wealth_stratum_03_13 = 1 if hhid_village == "012B"
replace wealth_stratum_03_14 = 1 if hhid_village == "012B"
replace wealth_stratum_03_15 = 1 if hhid_village == "012B"
replace wealth_stratum_03_16 = 1 if hhid_village == "012B"
replace wealth_stratum_03_17 = 1 if hhid_village == "012B"
replace wealth_stratum_03_18 = 1 if hhid_village == "012B"
replace wealth_stratum_03_19 = 1 if hhid_village == "012B"
replace wealth_stratum_03_20 = 1 if hhid_village == "012B"
replace wealth_stratum_03_1 = 1 if hhid_village == "130A"
replace wealth_stratum_03_2 = 1 if hhid_village == "130A"
replace wealth_stratum_03_3 = 1 if hhid_village == "130A"
replace wealth_stratum_03_4 = 1 if hhid_village == "130A"
replace wealth_stratum_03_5 = 1 if hhid_village == "130A"
replace wealth_stratum_03_6 = 1 if hhid_village == "130A"
replace wealth_stratum_03_7 = 1 if hhid_village == "130A"
replace wealth_stratum_03_8 = 1 if hhid_village == "130A"
replace wealth_stratum_03_9 = 1 if hhid_village == "130A"
replace wealth_stratum_03_10 = 1 if hhid_village == "130A"
replace wealth_stratum_03_11 = 1 if hhid_village == "130A"
replace wealth_stratum_03_12 = 1 if hhid_village == "130A"
replace wealth_stratum_03_13 = 1 if hhid_village == "130A"
replace wealth_stratum_03_14 = 1 if hhid_village == "130A"
replace wealth_stratum_03_15 = 1 if hhid_village == "130A"
replace wealth_stratum_03_16 = 1 if hhid_village == "130A"
replace wealth_stratum_03_17 = 1 if hhid_village == "130A"
replace wealth_stratum_03_18 = 1 if hhid_village == "130A"
replace wealth_stratum_03_19 = 1 if hhid_village == "130A"
replace wealth_stratum_03_20 = 1 if hhid_village == "130A"

// TAKE THIS XXX away once you are ready to save the actual corrections
// MAKE SURE ALL DATES ARE UP TO DATE
xxx
* Save the corrected dataset. Change date everytime you run this
export excel using "$corrected\CORRECTED_Community_Survey_10April2025.xlsx", firstrow(variables) replace

