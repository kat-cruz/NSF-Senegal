*==============================================================================
* Unit Conversion Table - Midline
* Created by: Alexander Mills
* Updates recorded in GitHub: [Midline_Unit_Conversion_table.do](https://github.com/kat-cruz/NSF-Senegal/blob/main/Scripts/Data_Processing/Corrections/_Midline_Data_Corrections/Alex_Midline_Community_Data_Corrections.do)

*>>>>>>>>>>*===========================* READ ME *===========================*<<<<<<<<<<<*
*
* Description:
* This script creates the unit conversion table
*
* Inputs:
* 
*
* Outputs:
* 
*
* Instructions for running the script:
* 1. Ensure Stata is running in a compatible environment.
* 2. Verify that the file paths are correctly set in the "SET FILE PATHS" section.
* 3. Run the script sequentially to 
* 4. 
*
*==============================================================================*
clear all
set mem 100m
set maxvar 30000
set matsize 11000
set more off

**************************************************
* SET FILE PATHS
**************************************************

* Set base Box path for each user
if "`c(username)'"=="socrm" global box_path "C:\Users\socrm\Box\NSF Senegal"
if "`c(username)'"=="kls329" global box_path "C:\Users\kls329\Box"
if "`c(username)'"=="km978" global box_path "C:\Users\km978\Box\NSF Senegal"
if "`c(username)'"=="Kateri" global box_path "C:\Users\Kateri\Box\NSF Senegal"
if "`c(username)'"=="admmi" global box_path "C:\Users\admmi\Box\NSF Senegal"


global community "$box_path\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Community_Issues"
global communityOriginal "$box_path\Data_Management\Output\Data_Quality_Checks\Midline\_Midline_Original_Issues_Output"
global data "$box_path\Data_Management\_CRDES_RawData\Midline\Community_Survey_Data"
global corrected "$box_path\Data_Management\Output\Data_Corrections\Midline"
global sumstats "$box_path\Data_Management\Documentation\Code_book\Midline"

*** import community survey data ***
import excel using "$corrected\CORRECTED_Community_Survey_6May2025", firstrow

* label unit conversions
label variable unit_convert_1 "How many kilograms does a large sack of manure weigh?"
label variable unit_convert_2 "How many kilograms does a medium sack of manure weigh?"
label variable unit_convert_3 "How many kilograms does a small sack of manure weigh?"
label variable unit_convert_4 "How many kilograms does a donkey cart of manure weigh?"
label variable unit_convert_5 "How many kilograms does a cattle cart of manure weigh?"
label variable unit_convert_6 "How many kilograms does a backpack of manure weigh?"
label variable unit_convert_7 "How many kilograms does a basket of manure weigh?"
label variable unit_convert_8 "How many kilograms does a sack of urea weigh?"
label variable unit_convert_9 "How many kilograms does a sack of phosphates weigh?"
label variable unit_convert_10 "How many kilograms does a sack of NPK/Universal formula weigh?"
label variable unit_convert_11 "How many kilograms does a sack of other chemical fertilizers weigh?"

* sum stats
estpost summarize unit_convert_*
esttab using "$sumstats/unit_conversion_table.rtf", cells("mean sd min max") ///
       label title("Summary Statistics of Unit Conversion Variables") ///
       replace

* excel of all the conversions by village
* Loop through the unit_convert variables to get their labels
foreach var of varlist unit_convert_* {
    local lbl : variable label `var'
    if "`lbl'" == "" local lbl "`var'"  // If no label exists, use variable name
    local colnames `"`colnames' "`lbl'""'
}

preserve
keep hhid_village unit_convert_*
export excel using "$sumstats/unit_conversion_values.xlsx", firstrow(variables) replace
restore

