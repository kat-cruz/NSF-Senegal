**************************************************
* DISES Baseline Data - Code used to assist with summary stats *
* File Created By: Alexander Mills *
* File Last Updated By: Alexander Mills *
* File Last Updated On: October 2024 *
**************************************************

*** This Do File PROCESSES: DISES_Baseline_Complete_PII.dta ***
*** This Do File CREATES: summarary statistics to input into codebook***
* specifically the ones that the R file with "_01" suffix do not compute
						
*** Procedure: ***

capture log close
clear all
set mem 100m
set maxvar 30000
set matsize 11000
set more off
version 14.1

**************************************************
* SET FILE PATHS
**************************************************

disp "`c(username)'"

* Set global path based on the username
if "`c(username)'" == "admmi" global path "C:\\Users\\admmi\\Box\\Data Management"
if "`c(username)'" == "km978" global path "C:\Users\km978\Box\Data Management"


global survey "$master\Data Management\_CRDES_CleanData\Baseline\Deidentified"

global agriculture_df "survey\Complete_Baseline_Agriculture.dta"
global beliefs_df "survey\Complete_Baseline_Beliefs.dta"

**************************************************
* Income Data Summary
**************************************************

* Use Income data
use "${path}\\_CRDES_CleanData\\Baseline\\Deidentified\\Complete_Baseline_Income.dta", clear

* Summarize agricultural income variables
tabulate agri_income_01
replace agri_income_01 = . if agri_income_01 == 2
summarize agri_income_01

summarize agri_income_03 agri_income_04 agri_income_05 agri_income_06
summarize species_1 species_2 species_3 species_4 species_5 species_6 species_7 species_8 species_9 species_autre

* Loop for summarizing agri_income_07 and agri_income_08
forvalues i = 1/6 {
    summarize agri_income_07_`i' agri_income_08_`i'
}
summarize agri_income_07_o agri_income_08_o

* Loop for tabulating agri_income_09
forvalues i = 1/6 {
    tabulate agri_income_09_`i'
}

summarize agri_income_10_1 agri_income_10_2 agri_income_10_3 agri_income_10_4 agri_income_10_5 agri_income_10_6 agri_income_10_o 
summarize animals_sales_1 animals_sales_2 animals_sales_3 animals_sales_4 animals_sales_5 animals_sales_6 animals_sales_7 animals_sales_8 animals_sales_9 animals_sales_o animals_sales_t 
summarize agri_income_11_1 agri_income_11_2 agri_income_11_3 agri_income_11_4 agri_income_11_5 agri_income_11_o 
summarize agri_income_12_1 agri_income_12_2 agri_income_12_3 agri_income_12_4 agri_income_12_5 agri_income_12_o 
summarize agri_income_14_1 agri_income_14_2 agri_income_14_3 agri_income_14_4 agri_income_14_5 agri_income_14_o 
summarize agri_income_15 agri_income_16 agri_income_17 agri_income_18 agri_income_19 
summarize agri_income_20_1 agri_income_20_2 agri_income_20_3 agri_income_20_4 agri_income_20_5 agri_income_20_6 agri_income_20_7 agri_income_20_8 agri_income_20_9 agri_income_20_t agri_income_20_o

* Summarize agri_income_22* variables
summarize agri_income_22*

* Summarize agri_income_23 and agri_income_24
summarize agri_income_23*
summarize agri_income_24*

* Summarize agri_income_25 to agri_income_30
summarize agri_income_25 agri_income_26 agri_income_27 agri_income_28 agri_income_29 agri_income_30

* Summarize agri_income_31_*
summarize agri_income_31_*

* Summarize additional income variables
summarize agri_income_32 agri_income_33 agri_income_34 agri_income_35
summarize agri_income_36*
summarize agri_income_38*
summarize agri_income_39*
summarize agri_income_40*
summarize agri_income_41*
summarize agri_income_42*
summarize agri_income_43*


* Replace -9 with missing values for specific variables
* Loop through numeric variables starting with agri_income_
ds agri_income_*, has(type numeric)
foreach var of varlist `r(varlist)' {
    * Replace -9 and -99 with missing for each numeric variable
    replace `var' = . if `var' == -9 | `var' == -99
}


// Summarize income variables again for summary statistics not accounting for -9 or 99

* Summarize agricultural income variables
tabulate agri_income_01
replace agri_income_01 = . if agri_income_01 == 2
summarize agri_income_01

summarize agri_income_03 agri_income_04 agri_income_05 agri_income_06
summarize species_1 species_2 species_3 species_4 species_5 species_6 species_7 species_8 species_9 species_autre

* Loop for summarizing agri_income_07 and agri_income_08
forvalues i = 1/6 {
    summarize agri_income_07_`i' agri_income_08_`i'
}
summarize agri_income_07_o agri_income_08_o

* Loop for tabulating agri_income_09
forvalues i = 1/6 {
    tabulate agri_income_09_`i'
}

summarize agri_income_10_1 agri_income_10_2 agri_income_10_3 agri_income_10_4 agri_income_10_5 agri_income_10_6 agri_income_10_o 
summarize animals_sales_1 animals_sales_2 animals_sales_3 animals_sales_4 animals_sales_5 animals_sales_6 animals_sales_7 animals_sales_8 animals_sales_9 animals_sales_o animals_sales_t 
summarize agri_income_11_1 agri_income_11_2 agri_income_11_3 agri_income_11_4 agri_income_11_5 agri_income_11_o 
summarize agri_income_12_1 agri_income_12_2 agri_income_12_3 agri_income_12_4 agri_income_12_5 agri_income_12_o 
summarize agri_income_14_1 agri_income_14_2 agri_income_14_3 agri_income_14_4 agri_income_14_5 agri_income_14_o 
summarize agri_income_15 agri_income_16 agri_income_17 agri_income_18 agri_income_19 
summarize agri_income_20_1 agri_income_20_2 agri_income_20_3 agri_income_20_4 agri_income_20_5 agri_income_20_6 agri_income_20_7 agri_income_20_8 agri_income_20_9 agri_income_20_t agri_income_20_o

* Summarize agri_income_22* variables
summarize agri_income_22*

* Summarize agri_income_23 and agri_income_24
summarize agri_income_23*
summarize agri_income_24*

* Summarize agri_income_25 to agri_income_30
summarize agri_income_25 agri_income_26 agri_income_27 agri_income_28 agri_income_29 agri_income_30

* Summarize agri_income_31_*
summarize agri_income_31_*

* Summarize additional income variables
summarize agri_income_32 agri_income_33 agri_income_34 agri_income_35
summarize agri_income_36*
summarize agri_income_38*
summarize agri_income_39*
summarize agri_income_40*
summarize agri_income_41*
summarize agri_income_42*
summarize agri_income_43*


**************************************************
* Standard of Living Data Summary
**************************************************

* Use Standard of Living data
use "${path}\\_CRDES_CleanData\\Baseline\\Deidentified\\Complete_Baseline_Standard_Of_Living.dta", clear

summarize living_02 

* Tabulate living_01 to living_06
foreach var in living_01 living_03 living_04 living_05 living_06 {
    tabulate `var'
}

**************************************************
* Lean Season Data Summary
**************************************************

* Use Lean Season data
use "${path}\\_CRDES_CleanData\\Baseline\\Deidentified\\Complete_Baseline_Lean_Season.dta", clear

**************************************************
* Beliefs Data Summary
**************************************************

* Use Beliefs data
use "${path}\\_CRDES_CleanData\\Baseline\\Deidentified\\Complete_Baseline_Beliefs.dta", clear

forvalues i = 1/9 {
    tabulate beliefs_0`i'
}
summarize

**************************************************
* Donation Game Data Summary
**************************************************

* Use Donation Game data
use "${path}\\_CRDES_CleanData\\Baseline\\Deidentified\\Complete_Baseline_Public_Goods_Game.dta", clear
summarize

**************************************************
* Enumerator Observations Data Summary
**************************************************

* Use Enumerator Observations data
use "${path}\\_CRDES_CleanData\\Baseline\\Deidentified\\Complete_Baseline_Enumerator_Observations.dta", clear

summarize enum_01 enum_02
tabulate enum_03 
tabulate enum_04 
tabulate enum_05 
tabulate enum_06 
tabulate enum_08

**************************************************
* End of Script
**************************************************
