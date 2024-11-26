*** DISES Household Survey - Combine Data Checks Files, April data ***
*** Code Created By: Molly Doruska ****
*** Code Last Updated By: Molly Doruska ***
*** Code Last Modified: April 25, 2024 ***

clear all 

*** set maximum variables to at least 20,000 ***
set maxvar 20000

**** Master file path  ****

if "`c(username)'"=="socrm" {
                global master "C:\Users\socrm\Box\NSF Senegal\Baseline Data Collection"
}
else if "`c(username)'"=="Kateri" {
                global master "C:\Users\Kateri\Box\NSF Senegal\Baseline Data Collection"
				
}

*** additional file paths ***
global data "$master\Surveys\Baseline CRDES data (April 2024)"

global village_observations "$master\Data Quality Checks\April Output\Village_Household_Identifiers"
global household_roster "$master\Data Quality Checks\April Output\Household_Roster"
global knowledge "$master\Data Quality Checks\April Output\Knowledge"
global health "$master\Data Quality Checks\April Output\Health" 
global agriculture_inputs "$master\Data Quality Checks\April Output\Agriculture_Inputs"
global agriculture_production "$master\Data Quality Checks\April Output\Agriculture_Production"
global food_consumption "$master\Data Quality Checks\April Output\Food_Consumption"
global income "$master\Data Quality Checks\April Output\Income"
global standard_living "$master\Data Quality Checks\April Output\Standard_Living"
global beliefs "$master\Data Quality Checks\April Output\Beliefs" 
global public_goods "$master\Data Quality Checks\April Output\Public_Goods"
global enum_observations "$master\Data Quality Checks\April Output\Enumerator_Observations"
global issues "$master\Data Quality Checks\Output\April\Full Issues"

********************** COMBINE FILES INTO SECTION FILES **********************

*** Combine village observation files ***
************************* CHECK TO SEE WHAT WAS OUTPUT *****************

*** Combine household roster files ***
************************* CHECK TO SEE WHAT WAS OUTPUT *****************
use "$household_roster\Issue_Household_hh_age_6.dta", clear 
append using "$household_roster\Issue_Household_hh_surname_11.dta"
append using "$household_roster\Issue_Household_hh_surname_12.dta"
append using "$household_roster\Issue_Household_hh_surname_13.dta"
append using "$household_roster\Issue_Household_hh_surname_14.dta"
append using "$household_roster\Issue_Household_hh_surname_15.dta"
append using "$household_roster\Issue_Household_hh_surname_16.dta"
append using "$household_roster\Issue_Household_hh_surname_17.dta"
append using "$household_roster\Issue_Household_hh_surname_18.dta"
append using "$household_roster\Issue_hh_13_1_total_unreasonable.dta"
append using "$household_roster\Issue_hh_13_2_total_unreasonable.dta"
append using "$household_roster\Issue_hh_13_3_total_unreasonable.dta"
append using "$household_roster\Issue_hh_13_4_total_unreasonable.dta"
append using "$household_roster\Issue_hh_13_5_total_unreasonable.dta"
append using "$household_roster\Issue_hh_13_6_total_unreasonable.dta"
append using "$household_roster\Issue_hh_13_7_total_unreasonable.dta"
append using "$household_roster\Issue_hh_13_8_total_unreasonable.dta"
append using "$household_roster\Issue_Household_sum_less_than_hh_18_1.dta"
append using "$household_roster\Issue_Household_sum_less_than_hh_18_2.dta"
append using "$household_roster\Issue_Household_sum_less_than_hh_18_3.dta"
append using "$household_roster\Issue_Household_sum_less_than_hh_18_4.dta"
append using "$household_roster\Issue_Household_sum_less_than_hh_18_5.dta"
append using "$household_roster\Issue_Household_sum_less_than_hh_18_6.dta"
append using "$household_roster\Issue_Household_sum_less_than_hh_18_7.dta"
append using "$household_roster\Issue_Household_sum_less_than_hh_18_8.dta"
append using "$household_roster\Issue_Household_sum_less_than_hh_18_9.dta"
append using "$household_roster\Issue_Household_sum_less_than_hh_18_16.dta"

save "$household_roster\Roster_Issues.dta", replace 

*** Combine knowledge files ***
************************* CHECK TO SEE WHAT WAS OUTPUT *****************

*** Combine health files ***
************************* CHECK TO SEE WHAT WAS OUTPUT *****************
use "$health\Issue_health_5_12_2.dta", clear 
append using "$health\Issue_health_5_12_5.dta"

save "$health\Health_Issues.dta", replace 

*** Combine agriculture inputs files *** 
************************* CHECK TO SEE WHAT WAS OUTPUT *****************
use "$agriculture_inputs\Issue_agri_6_21_1_unreasonable.dta", clear 
append using "$agriculture_inputs\Issue_agri_6_38_a_code_1_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_39_a_1_unreasonable.dta"
append using "$agriculture_inputs\Issue_agri_6_39_a_code_1_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_39_a_code_2_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_39_a_code_3_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_40_a_code_1_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_40_a_code_2_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_41_a_1_unreasonable.dta"
append using "$agriculture_inputs\Issue_agri_6_41_a_code_1_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_41_a_code_2_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_41_a_code_3_missing.dta"

save "$agriculture_inputs\Ag_Inputs_Issues.dta", replace 

*** Combine agriculture produciton files *** 
************************* CHECK TO SEE WHAT WAS OUTPUT *****************
use "$agriculture_production\Issue_cereals_01_1_unreasonable.dta", clear
append using "$agriculture_production\Issue_cereals_01_5_unreasonable.dta"
append using "$agriculture_production\Issue_cereals_02_1_unreasonable.dta"
append using "$agriculture_production\Issue_farines_02_1_unreasonable.dta"
append using "$agriculture_production\Issue_farines_02_2_unreasonable.dta"
append using "$agriculture_production\Issue_farines_02_4_unreasonable.dta"
append using "$agriculture_production\Issue_farines_04_2_unreasonable.dta"
append using "$agriculture_production\Issue_farines_04_4_unreasonable.dta"
append using "$agriculture_production\Issue_legumes_02_3_unreasonable.dta"
append using "$agriculture_production\Issue_legumineuses_01_1_unreasonable.dta"
append using "$agriculture_production\Issue_legumineuses_02_1_unreasonable.dta"
append using "$agriculture_production\Issue_legumineuses_05_1_unreasonable.dta"
append using "$agriculture_production\Issue_legumineuses_05_3_unreasonable.dta"
append using "$agriculture_production\Issue_legumineuses_05_4_unreasonable.dta"
append using "$agriculture_production\Issue_o_culture_01_unreasonable.dta"
append using "$agriculture_production\Issue_o_culture_02_unreasonable.dta"

save "$agriculture_production\Ag_Production_Issues.dta", replace 

*** Combine food consumption issue files *** 
************************* CHECK TO SEE WHAT DATA WAS OUTPUT *****************

*** Combine income issue files *** 
************************* CHECK TO SEE WHAT DATA WAS OUTPUT *****************
use "$income\Issue_agri_income_03_unreasonable.dta", clear 
append using "$income\Issue_agri_income_07_2_unreasonable.dta" 
append using "$income\Issue_agri_income_08_2_unreasonable.dta" 
append using "$income\Issue_agri_income_11_1_unreasonable.dta" 
append using "$income\Issue_agri_income_23_1_unreasonable.dta" 
append using "$income\Issue_agri_income_43_1_unreasonable.dta"
append using "$income\Issue_agri_loan_name_missing.dta"
append using "$income\Issue_expenses_goods_t.dta"

save "$income\Income_Issues.dta", replace 

*** Combine standard of living issue files *** 
************************* CHECK TO SEE WHAT WAS OUTPUT *****************

*** Combine public goods data issue files *** 
************************* CHECK TO SEE WHAT OUTPUT *****************
use "$public_goods\Issue_face_04.dta", clear 

save "$public_goods\Public_Goods_Issue.dta", replace 

*** Combine enumerator observation issue files *** 
************************* CHECK TO SEE WHAT OUTPUT *****************

************** COMBINE SECTION FILES INTO ONE HOUSEHOLD ISSUES FILE *************

*** NOT ALL FILES EXIST YET *** 

use "$household_roster\Roster_Issues.dta", clear
*append using "$knowledge\Knoweldge_Issues.dta"
append using "$health\Health_Issues.dta"
append using "$agriculture_inputs\Ag_Inputs_Issues.dta"
append using "$agriculture_production\Ag_Production_Issues.dta"
*append using "$food_consumption\Food_Consumption_Issues.dta"
append using "$income\Income_Issues.dta"
*append using "$standard_living\Standard_of_Living_Issues.dta"
append using "$public_goods\Public_Goods_Issue.dta"
*append using "$enum_observations\Enumerator_Issues.dta"

*** export combined household checks data file *** 
*export excel using "$issues\Household_Data_Issues_26Apr2024.xlsx", firstrow(variables) 



