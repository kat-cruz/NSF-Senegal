*** DISES Household Survey - Combine Data Checks Files ***
*** Code Created By: Molly Doruska ****
*** File Last Updated By: Kateri Mouawad ***
*** File Last Updated On: February 06, 2025 ***
*KRM - updated file paths. All updates recorded on GitHub. 

clear all 
set maxvar 20000 

*** file set up *** 


if "`c(username)'"=="socrm" {
                global master "C:\Users\socrm\Box\NSF Senegal\Data_Management"
}
else if "`c(username)'"=="Kateri" {
                global master "C:\Users\Kateri\Box\NSF Senegal\Data_Management"
				
}


*** additional file paths ***
global data "$master\_CRDES_RawData\Baseline"

global village_observations "$master\Data_Quality_Checks\Baseline\Jan-Feb_Output\Baseline_Village_Household_Identifiers"
global household_roster "$master\Data_Quality_Checks\Baseline\Jan-Feb_Output\Baseline_Household_Roster"
global knowledge "$master\Data_Quality_Checks\Baseline\Jan-Feb_Output\Baseline_Knowledge"
global health "$master\Data_Quality_Checks\Baseline\Jan-Feb_Output\Baseline_Health" 
global agriculture_inputs "$master\Data_Quality_Checks\Baseline\Jan-Feb_Output\Baseline_Agriculture_Inputs"
global agriculture_production "$master\Data_Quality_Checks\Baseline\Jan-Feb_Output\Baseline_Agriculture_Production"
global food_consumption "$master\Data_Quality_Checks\Baseline\Jan-Feb_Output\Baseline_Food_Consumption"
global income "$master\Data_Quality_Checks\Baseline\Jan-Feb_Output\Baseline_Income"
global standard_living "$master\Data_Quality_Checks\Output\Baseline\Jan-Feb_Output\Baseline_Standard_Living"
global beliefs "$master\Data_Quality_Checks\Baseline\Jan-Feb_Output\Baseline_Beliefs" 
global public_goods "$master\Data_Quality_Checks\Baseline\Jan-Feb_Output\Baseline_Public_Goods"
global enum_observations "$master\Data_Quality_Checks\Baseline\Jan-Feb_Output\Baseline_Enumerator_Observations"

********************** COMBINE FILES INTO SECTION FILES **********************

*** Combine village observation files ***
************************* CHECK TO SEE WHAT WAS OUTPUT *****************

*** Combine household roster files ***
************************* CHECK TO SEE WHAT WAS OUTPUT *****************
use "$household_roster\Issue_Household_hh_age_1.dta", clear 
append using "$household_roster\Issue_Household_hh_age_2.dta"
append using "$household_roster\Issue_Household_hh_age_3.dta"
append using "$household_roster\Issue_Household_hh_age_4.dta"
append using "$household_roster\Issue_Household_hh_age_7.dta"
append using "$household_roster\Issue_Household_hh_age_8.dta"
append using "$household_roster\Issue_Household_hh_age_14.dta"
append using "$household_roster\Issue_Household_hh_age_18.dta"
append using "$household_roster\Issue_Household_hh_education_level_3.dta"
append using "$household_roster\Issue_Household_hh_education_level_4.dta"
append using "$household_roster\Issue_Household_hh_education_level_5.dta"
append using "$household_roster\Issue_Household_hh_education_level_6.dta"
append using "$household_roster\Issue_Household_hh_education_level_7.dta"
append using "$household_roster\Issue_Household_hh_education_level_9.dta"
append using "$household_roster\Issue_Household_hh_education_level_10.dta"
append using "$household_roster\Issue_Household_hh_education_level_12.dta"
append using "$household_roster\Issue_hh_13_1_total_unreasonable.dta"
append using "$household_roster\Issue_hh_13_2_total_unreasonable.dta"
append using "$household_roster\Issue_hh_13_3_total_unreasonable.dta"
append using "$household_roster\Issue_hh_13_4_total_unreasonable.dta"
append using "$household_roster\Issue_hh_13_5_total_unreasonable.dta"
append using "$household_roster\Issue_hh_13_6_total_unreasonable.dta"
append using "$household_roster\Issue_hh_13_7_total_unreasonable.dta"
append using "$household_roster\Issue_hh_13_8_total_unreasonable.dta"
append using "$household_roster\Issue_hh_13_9_total_unreasonable.dta"
append using "$household_roster\Issue_hh_13_10_total_unreasonable.dta"
append using "$household_roster\Issue_hh_13_11_total_unreasonable.dta"
append using "$household_roster\Issue_hh_13_12_total_unreasonable.dta"
append using "$household_roster\Issue_hh_13_13_total_unreasonable.dta"
append using "$household_roster\Issue_hh_13_14_total_unreasonable.dta"
append using "$household_roster\Issue_hh_13_15_total_unreasonable.dta"
append using "$household_roster\Issue_hh_13_16_total_unreasonable.dta"
append using "$household_roster\Issue_hh_13_17_total_unreasonable.dta"
append using "$household_roster\Issue_hh_13_18_total_unreasonable.dta"
append using "$household_roster\Issue_hh_13_19_total_unreasonable.dta"
append using "$household_roster\Issue_hh_13_22_total_unreasonable.dta"
append using "$household_roster\Issue_hh_13_24_total_unreasonable.dta"
append using "$household_roster\Issue_hh_13_44_total_unreasonable.dta"
append using "$household_roster\Issue_Household_sum_less_than_hh_18_1.dta"
append using "$household_roster\Issue_Household_sum_less_than_hh_18_2.dta"
append using "$household_roster\Issue_Household_sum_less_than_hh_18_3.dta"
append using "$household_roster\Issue_Household_sum_less_than_hh_18_4.dta"
append using "$household_roster\Issue_Household_sum_less_than_hh_18_5.dta"
append using "$household_roster\Issue_Household_sum_less_than_hh_18_6.dta"
append using "$household_roster\Issue_Household_sum_less_than_hh_18_7.dta"
append using "$household_roster\Issue_Household_sum_less_than_hh_18_8.dta"
append using "$household_roster\Issue_Household_sum_less_than_hh_18_9.dta"
append using "$household_roster\Issue_Household_sum_less_than_hh_18_10.dta"
append using "$household_roster\Issue_Household_sum_less_than_hh_18_11.dta"
append using "$household_roster\Issue_Household_sum_less_than_hh_18_12.dta"
append using "$household_roster\Issue_Household_sum_less_than_hh_18_13.dta"
append using "$household_roster\Issue_Household_sum_less_than_hh_18_14.dta"
append using "$household_roster\Issue_Household_sum_less_than_hh_18_15.dta"
append using "$household_roster\Issue_Household_sum_less_than_hh_18_16.dta"
append using "$household_roster\Issue_Household_sum_less_than_hh_18_17.dta"
append using "$household_roster\Issue_Household_sum_less_than_hh_18_18.dta"
append using "$household_roster\Issue_Household_sum_less_than_hh_18_23.dta"

save "$household_roster\Roster_Issues.dta", replace 

*** Combine knowledge files ***
************************* CHECK TO SEE WHAT WAS OUTPUT *****************

*** Combine health files ***
************************* CHECK TO SEE WHAT WAS OUTPUT *****************
use "$health\Issue_health_5_12_1.dta", clear 
append using "$health\Issue_health_5_12_2.dta"
append using "$health\Issue_health_5_12_3.dta"
append using "$health\Issue_health_5_12_4.dta"
append using "$health\Issue_health_5_12_5.dta"
append using "$health\Issue_health_5_12_6.dta"
append using "$health\Issue_health_5_12_7.dta"
append using "$health\Issue_health_5_12_8.dta"
append using "$health\Issue_health_5_12_9.dta"
append using "$health\Issue_health_5_12_10.dta"
append using "$health\Issue_health_5_12_11.dta"
append using "$health\Issue_health_5_12_12.dta"
append using "$health\Issue_health_5_12_13.dta"
append using "$health\Issue_health_5_12_16.dta"

save "$health\Health_Issues.dta", replace 

*** Combine agriculture inputs files *** 
************************* CHECK TO SEE WHAT WAS OUTPUT *****************
use "$agriculture_inputs\Issue_agri_6_21_1_unreasonable.dta", clear 
append using "$agriculture_inputs\Issue_agri_6_21_2_unreasonable.dta"
append using "$agriculture_inputs\Issue_agri_6_21_3_unreasonable.dta"
append using "$agriculture_inputs\Issue_agri_6_28_1_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_28_4_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_38_a_1_unreasonable.dta"
append using "$agriculture_inputs\Issue_agri_6_38_a_2_unreasonable.dta"
append using "$agriculture_inputs\Issue_agri_6_38_a_3_unreasonable.dta"
append using "$agriculture_inputs\Issue_agri_6_38_a_4_unreasonable.dta"
append using "$agriculture_inputs\Issue_agri_6_38_a_code_1_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_38_a_code_2_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_38_a_code_3_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_38_a_code_4_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_38_a_code_5_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_38_a_code_6_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_38_a_code_11_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_39_a_1_unreasonable.dta"
append using "$agriculture_inputs\Issue_agri_6_39_a_2_unreasonable.dta"
append using "$agriculture_inputs\Issue_agri_6_39_a_3_unreasonable.dta"
append using "$agriculture_inputs\Issue_agri_6_39_a_4_unreasonable.dta"
append using "$agriculture_inputs\Issue_agri_6_39_a_5_unreasonable.dta"
append using "$agriculture_inputs\Issue_agri_6_39_a_code_1_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_39_a_code_2_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_39_a_code_3_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_39_a_code_4_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_39_a_code_5_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_39_a_code_6_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_39_a_code_7_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_39_a_code_8_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_39_a_code_9_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_39_a_code_10_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_39_a_code_11_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_40_a_1_unreasonable.dta"
append using "$agriculture_inputs\Issue_agri_6_40_a_2_unreasonable.dta"
append using "$agriculture_inputs\Issue_agri_6_40_a_3_unreasonable.dta"
append using "$agriculture_inputs\Issue_agri_6_40_a_4_unreasonable.dta"
append using "$agriculture_inputs\Issue_agri_6_40_a_code_1_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_40_a_code_2_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_40_a_code_3_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_40_a_code_4_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_40_a_code_5_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_40_a_code_6_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_40_a_code_7_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_40_a_code_8_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_40_a_code_9_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_40_a_code_10_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_40_a_code_11_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_41_a_1_unreasonable.dta"
append using "$agriculture_inputs\Issue_agri_6_41_a_2_unreasonable.dta"
append using "$agriculture_inputs\Issue_agri_6_41_a_3_unreasonable.dta"
append using "$agriculture_inputs\Issue_agri_6_41_a_4_unreasonable.dta"
append using "$agriculture_inputs\Issue_agri_6_41_a_5_unreasonable.dta"
append using "$agriculture_inputs\Issue_agri_6_41_a_code_1_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_41_a_code_2_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_41_a_code_3_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_41_a_code_4_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_41_a_code_5_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_41_a_code_6_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_41_a_code_7_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_41_a_code_8_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_41_a_code_9_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_41_a_code_10_missing.dta"

save "$agriculture_inputs\Ag_Inputs_Issues.dta", replace 

*** Combine agriculture produciton files *** 
************************* CHECK TO SEE WHAT WAS OUTPUT *****************
use "$agriculture_production\Issue_aquatique_01_unreasonable.dta", clear 
append using "$agriculture_production\Issue_cereals_01_1_unreasonable.dta"
append using "$agriculture_production\Issue_cereals_01_2_unreasonable.dta"
append using "$agriculture_production\Issue_cereals_01_3_unreasonable.dta"
append using "$agriculture_production\Issue_cereals_01_5_unreasonable.dta"
append using "$agriculture_production\Issue_cereals_02_1_unreasonable.dta"
append using "$agriculture_production\Issue_cereals_02_2_unreasonable.dta"
append using "$agriculture_production\Issue_cereals_02_5_unreasonable.dta"
append using "$agriculture_production\Issue_cereals_03_1_unreasonable.dta"
append using "$agriculture_production\Issue_cereals_03_2_unreasonable.dta"
append using "$agriculture_production\Issue_cereals_04_1_unreasonable.dta"
append using "$agriculture_production\Issue_cereals_05_1_unreasonable.dta"
append using "$agriculture_production\Issue_cereals_05_2_unreasonable.dta"
append using "$agriculture_production\Issue_cereals_05_5_unreasonable.dta"
append using "$agriculture_production\Issue_farines_01_1_unreasonable.dta"
append using "$agriculture_production\Issue_farines_01_2_unreasonable.dta"
append using "$agriculture_production\Issue_farines_01_6_unreasonable.dta"
append using "$agriculture_production\Issue_farines_02_1_unreasonable.dta"
append using "$agriculture_production\Issue_farines_02_2_unreasonable.dta"
append using "$agriculture_production\Issue_farines_03_1_unreasonable.dta"
append using "$agriculture_production\Issue_farines_03_2_unreasonable.dta"
append using "$agriculture_production\Issue_farines_04_1_unreasonable.dta"
append using "$agriculture_production\Issue_farines_04_2_unreasonable.dta"
append using "$agriculture_production\Issue_farines_05_1_unreasonable.dta"
append using "$agriculture_production\Issue_farines_05_2_unreasonable.dta"
append using "$agriculture_production\Issue_farines_05_6_unreasonable.dta"
append using "$agriculture_production\Issue_legumes_01_1_unreasonable.dta"
append using "$agriculture_production\Issue_legumes_01_3_unreasonable.dta"
append using "$agriculture_production\Issue_legumes_01_4_unreasonable.dta"
append using "$agriculture_production\Issue_legumes_01_6_unreasonable.dta"
append using "$agriculture_production\Issue_legumes_02_1_unreasonable.dta"
append using "$agriculture_production\Issue_legumes_02_2_unreasonable.dta"
append using "$agriculture_production\Issue_legumes_02_3_unreasonable.dta"
append using "$agriculture_production\Issue_legumes_03_3_unreasonable.dta"
append using "$agriculture_production\Issue_legumes_04_1_unreasonable.dta"
append using "$agriculture_production\Issue_legumes_04_3_unreasonable.dta"
append using "$agriculture_production\Issue_legumes_05_1_unreasonable.dta"
append using "$agriculture_production\Issue_legumes_05_2_unreasonable.dta"
append using "$agriculture_production\Issue_legumes_05_3_unreasonable.dta"
append using "$agriculture_production\Issue_legumes_05_6_unreasonable.dta"
append using "$agriculture_production\Issue_legumineuses_01_1_unreasonable.dta"
append using "$agriculture_production\Issue_legumineuses_01_3_unreasonable.dta"
append using "$agriculture_production\Issue_legumineuses_01_5_unreasonable.dta"
append using "$agriculture_production\Issue_legumineuses_05_1_unreasonable.dta"
append using "$agriculture_production\Issue_legumineuses_05_2_unreasonable.dta"
append using "$agriculture_production\Issue_legumineuses_05_3_unreasonable.dta"
append using "$agriculture_production\Issue_legumineuses_05_4_unreasonable.dta"
append using "$agriculture_production\Issue_legumineuses_05_5_unreasonable.dta"
append using "$agriculture_production\Issue_o_culture_01_unreasonable.dta"
append using "$agriculture_production\Issue_o_culture_02_unreasonable.dta"
append using "$agriculture_production\Issue_o_culture_04_unreasonable.dta"
append using "$agriculture_production\Issue_o_culture_05_unreasonable.dta"

save "$agriculture_production\Ag_Production_Issues.dta", replace 

*** Combine food consumption issue files *** 
************************* CHECK TO SEE WHAT DATA WAS OUTPUT *****************

*** Combine income issue files *** 
************************* CHECK TO SEE WHAT DATA WAS OUTPUT *****************
use "$income\Issue_agri_income_03_unreasonable.dta", clear 
append using "$income\Issue_agri_income_05_unreasonable.dta" 
append using "$income\Issue_agri_income_06_unreasonable.dta" 
append using "$income\Issue_agri_income_07_o_unreasonable.dta"  
append using "$income\Issue_agri_income_08_o_unreasonable.dta" 
append using "$income\Issue_agri_income_10_1_unreasonable.dta" 
append using "$income\Issue_agri_income_10_2_unreasonable.dta"  
append using "$income\Issue_agri_income_11_1_unreasonable.dta" 
append using "$income\Issue_agri_income_12_1_unreasonable.dta" 
append using "$income\Issue_agri_income_13_autre_3_missing.dta" 
append using "$income\Issue_agri_income_13_autre_4_missing.dta" 
append using "$income\Issue_agri_income_13_autre_5_missing.dta" 
append using "$income\Issue_agri_income_16_unreasonable.dta" 
append using "$income\Issue_agri_income_19_unreasonable.dta" 
append using "$income\Issue_agri_income_21_h_o_unreasonable.dta" 
append using "$income\Issue_agri_income_33_unreasonable.dta" 
append using "$income\Issue_agri_income_36_1_unreasonable.dta" 
append using "$income\Issue_agri_income_42_1_unreasonable.dta" 
append using "$income\Issue_agri_income_43_1_unreasonable.dta" 
append using "$income\Issue_agri_income_46_o_3_missing.dta" 
append using "$income\Issue_agri_income_46_o_4_missing.dta"
append using "$income\Issue_agri_income_07_1_unreasonable.dta"
append using "$income\Issue_agri_income_07_2_unreasonable.dta"
append using "$income\Issue_agri_income_07_3_unreasonable.dta"
append using "$income\Issue_agri_income_07_o_unreasonable.dta"
append using "$income\Issue_agri_income_08_1_unreasonable.dta"
append using "$income\Issue_agri_income_08_2_unreasonable.dta"
append using "$income\Issue_agri_income_08_3_unreasonable.dta"
append using "$income\Issue_agri_income_08_o_unreasonable.dta"
append using "$income\Issue_agri_income_12_1_unreasonable.dta"
append using "$income\Issue_agri_income_21_h_2.dta"
append using "$income\Issue_agri_income_21_h_o.dta"
append using "$income\Issue_agri_income_23_1_unreasonable.dta"
append using "$income\Issue_agri_income_23_2_unreasonable.dta"
append using "$income\Issue_agri_income_21_f_1.dta"
append using "$income\Issue_agri_income_21_f_2.dta"
append using "$income\Issue_agri_income_45_2.dta"
append using "$income\Issue_agri_income_45_3.dta"
append using "$income\Issue_animals_sales_o.dta"
append using "$income\Issue_expenses_goods_t.dta"

save "$income\Income_Issues.dta", replace 

*** Combine standard of living issue files *** 
************************* CHECK TO SEE WHAT WAS OUTPUT *****************

*** Combine public goods data issue files *** 
************************* CHECK TO SEE WHAT OUTPUT *****************
use "$public_goods\Issue_face_04.dta", clear 
append using "$public_goods\Issue_montant_05.dta"

save "$public_goods\Public_Goods_Issue.dta", replace 

*** Combine enumerator observation issue files *** 
************************* CHECK TO SEE WHAT OUTPUT *****************
use "$enum_observations\Issue_enum_02_unreasonable.dta", clear 

save "$enum_observations\Enumerator_Issues.dta", replace 


************** COMBINE SECTION FILES INTO ONE HOUSEHOLD ISSUES FILE *************

*** NOT ALL FILES EXIST YET *** 

use "$household_roster\Roster_Issues.dta", replace
*append using "$knowledge\Knoweldge_Issues.dta"
append using "$health\Health_Issues.dta"
append using "$agriculture_inputs\Ag_Inputs_Issues.dta"
append using "$agriculture_production\Ag_Production_Issues.dta"
*append using "$food_consumption\Food_Consumption_Issues.dta"
append using "$income\Income_Issues.dta"
*append using "$standard_living\Standard_of_Living_Issues.dta"
append using "$public_goods\Public_Goods_Issue.dta"
append using "$enum_observations\Enumerator_Issues.dta"

*** export combined household checks data file *** 
*export excel using "$issues\Household_Data_Issues_6Feb2024.xlsx", firstrow(variables)



