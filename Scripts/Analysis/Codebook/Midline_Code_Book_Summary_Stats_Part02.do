**************************************************
* DISES Midline Data - Code used to assist with summary stats for Codebook*
* File Created By: Alexander Mills *
* File Last Updated By: Alexander Mills *
* Updates Tracked on Git *
**************************************************

*** This Do File PROCESSES: DISES_Midline_Complete_PII.dta ***
*** This Do File CREATES: ***
						
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
if "`c(username)'" == "admmi" global master "C:\Users\admmi\Box\NSF Senegal"
if "`c(username)'" == "km978" global master "C:\Users\km978\Box\NSF Senegal"
if "`c(username)'" == "socrm" global master "C:\Users\socrm\Box\NSF Senegal"

global survey "$master\Data_Management\Data\_CRDES_CleanData\Midline\Deidentified"

global agriculture "$survey\Complete_Midline_Agriculture.dta"
global beliefs"$survey\Complete_Midline_Beliefs.dta"
global community "$survey\Complete_Midline_Community.dta"
global enumerator"$survey\Complete_Midline_Enumerator_Observations.dta"
global geographies"$survey\Complete_Midline_Geographies.dta"
global health"$survey\Complete_Midline_Health.dta"
global household "$survey\Complete_Midline_Household_Roster.dta"
global income"$survey\Complete_Midline_Income.dta"
global knowledge"$survey\Complete_Midline_Knowledge.dta"
global lean "$survey\Complete_Midline_Lean_Season.dta"
global production "$survey\Complete_Midline_Production.dta"
global standard "$survey\Complete_Midline_Standard_Of_Living.dta"

**************************************************
* Income Data Summary
**************************************************
use "$household", clear

sum hh_49

sum final_list_confirm

drop hh_12_a_o*

keep hh_education_level* hhid_village hhid hh_12_a* hh_15* hh_27* hh_28* hh_29* hh_35* hh_36* hh_37* hh_38* hh_39* hh_40* hh_41* hh_42* hh_43* hh_44* hh_45* hh_46* hh_47* hh_48* hh_49* hh_50* hh_51* hh_52*

reshape long hh_education_level_ hh_12_a_ hh_15_ hh_27_ hh_28_ hh_29_ hh_35_ hh_36_ hh_37_ hh_38_ hh_39_ hh_40_ hh_41_ hh_42_ hh_43_ hh_44_ hh_45_ hh_46_ hh_47_a_ hh_47_b_ hh_47_c_ hh_47_d_ hh_47_e_ hh_47_f_ hh_47_g_ hh_48_ hh_50_ hh_51_, i(hhid_village hhid) j(individual)

tab hh_education_level_

tab hh_12_a_
replace hh_12_a_ = . if hh_12_a_ == 2
sum hh_12_a_

tab hh_15_

tab hh_27_
replace hh_27_ = . if hh_27_ == 2
sum hh_27_

tab hh_28_

tab hh_29_

tab hh_35_

tab hh_36_
replace hh_36_ = . if hh_36_ == 2
sum hh_36_

tab hh_37_
replace hh_37_ = . if hh_37_ == 2
sum hh_37_

sum hh_38_

tab hh_39_

tab hh_40_

tab hh_41_
replace hh_41_ = . if hh_41_ == -9
sum hh_41_

tab hh_42_ 
replace hh_42_ = . if hh_42_ == 2
sum hh_42_

tab hh_43_

tab hh_44_
replace hh_44_ = . if hh_44_ == 2
sum hh_44_

tab hh_45_
replace hh_45_ = . if hh_45_ ==2
sum hh_45_

tab hh_46_

sum hh_47_a_ hh_47_b_ hh_47_c_ hh_47_d_ hh_47_e_ hh_47_f_ hh_47_g_

tab hh_47_a_
tab hh_47_b_
tab hh_47_c_
tab hh_47_d_
tab hh_47_e_
tab hh_47_f_
tab hh_47_g_

replace hh_47_a_ = . if hh_47_a_ == -9 
sum hh_47_a_

replace hh_47_b_ = . if hh_47_b_ == -9 
sum hh_47_b_

replace hh_47_c_ = . if hh_47_c_ == -9 
sum hh_47_c_

replace hh_47_d_ = . if hh_47_d_ == -9 
sum hh_47_d_

replace hh_47_e_ = . if hh_47_e_ == -9
sum hh_47_e_

replace hh_47_f_ = . if hh_47_f_ == -9
sum hh_47_f_

replace hh_47_g_ = . if hh_47_g_ == -9
sum hh_47_g_

tab hh_48_
replace hh_48_ = . if hh_48_ == 2
sum hh_48_

tab hh_50_
sum hh_50_

tab hh_51_

**************************************************
* Income Data Summary
**************************************************

* Use Income data
use "$income", clear

* Summarize agricultural income variables
tabulate agri_income_01
replace agri_income_01 = . if agri_income_01 == 2
summarize agri_income_01

tab agri_income_02

tab agri_income_03
tab agri_income_04
tab agri_income_05
tab agri_income_06
tab species_1
tab species_2
tab species_3
tab species_4 
tab species_5 
tab species_6 
tab species_7 
tab species_8 
tab species_9 
tab species_autre
summarize agri_income_03 agri_income_04 agri_income_05 agri_income_06
summarize species_1 species_2 species_3 species_4 species_5 species_6 species_7 species_8 species_9 species_autre

tab agri_income_07_o
sum agri_income_07_o if agri_income_07_o != -9

tab agri_income_08_o
sum agri_income_08_o if agri_income_08_o != -9

* Loop for tabulating agri_income_09
forvalues i = 1/6 {
    tabulate agri_income_09_`i'
}

summarize agri_income_10_1 agri_income_10_2 agri_income_10_3 agri_income_10_4 agri_income_10_5 agri_income_10_6 agri_income_10_o 

summarize animals_sales_1 animals_sales_2 animals_sales_3 animals_sales_4 animals_sales_5 animals_sales_6 animals_sales_7 animals_sales_8 animals_sales_9 animals_sales_o animals_sales_t 
tab animals_sales_o
sum animals_sales_o if animals_sales_o < 2

summarize agri_income_11_o 

summarize agri_income_12_o 

tab agri_income_13_o

summarize agri_income_14_o 

summarize agri_income_15 agri_income_16 agri_income_17 agri_income_18 agri_income_19 
tab agri_income_15
sum agri_income_15 if agri_income_15 < 2
tab agri_income_16
sum agri_income_16 if agri_income_16 > -9
tab agri_income_18
tab agri_income_18_1
tab agri_income_18_2
tab agri_income_18_3
tab agri_income_19
sum agri_income_19 if agri_income_19 > -9

summarize agri_income_20_1 agri_income_20_2 agri_income_20_3 agri_income_20_4 agri_income_20_5 agri_income_20_6 agri_income_20_7 agri_income_20_8 agri_income_20_9 agri_income_20_t agri_income_20_o

* Summarize agri_income_22* variables
summarize agri_income_22*

* Summarize agri_income_23 and agri_income_24
summarize agri_income_23*
summarize agri_income_24*

* Summarize agri_income_25 to agri_income_30
summarize agri_income_25 agri_income_26 agri_income_27 agri_income_28 agri_income_29 agri_income_30 agri_income_30_note
tab agri_income_28
sum agri_income_29 if agri_income_29 > -9
sum agri_income_30 if agri_income_30 < 2


* Summarize agri_income_31_*
summarize agri_income_31_*

* Summarize additional income variables
tab agri_income_32
sum agri_income_32 if agri_income_32 < 2
tab agri_income_33
sum agri_income_33 if agri_income_33 > -9
tab agri_income_34
sum agri_income_34 if agri_income_34 < 2
tab agri_income_35

tab agri_income_40
sum agri_income_40 if agri_income_40 < 2


**************************************************
* Standard of Living Data Summary
**************************************************

* Use Standard of Living data
use "$standard", clear

summarize living_02 

* Tabulate living_01 to living_06
foreach var in living_01 living_03 living_04 living_05 living_06 {
    tabulate `var'
}

**************************************************
* Lean Season Data Summary
**************************************************

* Use Lean Season data
use "$lean", clear
sum food*

tab food02
sum food02 if food02 < 2

tab food06
sum food06 if food06 < 2

tab food07
sum food07 if food07 < 2

tab food08
sum food08 if food08 < 2

tab food09
sum food09 if food09 < 2

tab food12
sum food12 if food12 < 2

**************************************************
* Beliefs Data Summary
**************************************************

* Use Beliefs data
use "$beliefs", clear

forvalues i = 1/9 {
    tabulate beliefs_0`i'
}
summarize

**************************************************
* Donation Game Data Summary (No donation game for Midline)
**************************************************
/*
* Use Donation Game data
use "$public", clear
summarize
*/

**************************************************
* Enumerator Observations Data Summary
**************************************************

* Use Enumerator Observations data
use "$enumerator", clear

summarize enum_01 enum_02
tabulate enum_03 
tabulate enum_04 
tabulate enum_05 
tabulate enum_06 
tabulate enum_08

**************************************************
* Health Data Summary
**************************************************
use "$health", clear

keep hhid health_5_7_*

reshape long health_5_7_ health_5_7_1_, i(hhid) j(individual)

tab health_5_7_
replace health_5_7_ = . if health_5_7_ == 2
sum health_5_7_

tab health_5_7_1_
replace health_5_7_1_ = . if health_5_7_1_ == 2
sum health_5_7_1_


**************************************************
* Agriculture Data Summary
**************************************************
use "$agriculture", clear

keep hhid agri_6_34_* agri_6_35_* agri_6_36_* agri_6_37_* agri_6_38_a_* agri_6_38_a_code_* agri_6_38_a_code_o_* agri_6_39_a_* agri_6_39_a_code_* agri_6_39_a_code_o_* agri_6_40_a_* agri_6_40_a_code_* agri_6_40_a_code_o_* agri_6_41_a_* agri_6_41_a_code_* agri_6_41_a_code_o_*

*** create string variables where necessary *** 
tostring agri_6_38_a_code_o*, replace 
tostring agri_6_39_a_code_o*, replace 
tostring agri_6_40_a_code_o*, replace 
tostring agri_6_41_a_code_o*, replace 

*** reshape missing variables from wide to long *** 
reshape long agri_6_34_ agri_6_35_ agri_6_36_ agri_6_37_ agri_6_38_a_ agri_6_38_a_code_ agri_6_38_a_code_o_ agri_6_39_a_ agri_6_39_a_code_ agri_6_39_a_code_o_ agri_6_40_a_ agri_6_40_a_code_ agri_6_40_a_code_o_ agri_6_41_a_ agri_6_41_a_code_ agri_6_41_a_code_o_, i(hhid) j(plotn) 

*** summarize variables for codebook *** 
summarize agri_6_35_ agri_6_37_ agri_6_38_a_ agri_6_39_a_ agri_6_40_a_ agri_6_41_a_  

tab agri_6_34_ 
summarize agri_6_34_ if agri_6_34_ < 2

tab agri_6_36_ 
summarize agri_6_36_ if agri_6_36_ < 2

tab agri_6_38_a_code_

tab agri_6_39_a_code_

tab agri_6_40_a_code_ 

tab agri_6_41_a_code_

tab agri_6_37_
sum agri_6_37_ if agri_6_37_ > -9

**************************************************
* Production Data Summary
**************************************************
use "$production", clear

sum cereals_01_6 cereals_02_6 cereals_03_6 cereals_04_6 cereals_05_6

tab farine_tubercules_consumption_1
tab farine_tubercules_consumption_2
tab farine_tubercules_consumption_3
tab farine_tubercules_consumption_4
tab farine_tubercules_consumption_5
tab farine_tubercules_consumption_6

tab legumes_03_5
sum legumes_03_5 if legumes_03_5 >= 0

tab legumes_03_6
sum legumes_03_6 if legumes_03_6 >= 0

**************************************************
* End of Script
**************************************************
