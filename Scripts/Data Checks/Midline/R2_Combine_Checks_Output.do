*** DISES Midline Data Checks - Household Survey***
*** File originally created By: Molly Doruska - Adapted by Kateri Mouawad & Alex Mills ***
*** Updates recorded in GitHub ***

*>>>>>>>>>>*===========================* READ ME *===========================*<<<<<<<<<<<*


			*1)	Go to the following file path:
					*Data Management\Output\Data Quality Checks\Midline
			*2)	Check for through each of the subfolders to verify which issues have been outputed 
			*3)	Update this script with any new .dta's by appending them, module by module 
			*4) After you apppend all of the issues by module, complete one final append by appending the module issues 
			*5) Export this spread sheet to the Issues folder located here:
				*\Data Management\External_Corrections\Issues for Justin and Amina\Midline\Issues
			

*==============================================================================
clear all
set mem 100m
set maxvar 30000
set matsize 11000
set more off

**************************************************
* SET FILE PATHS
**************************************************

* Set base Box path for each user
if "`c(username)'"=="socrm" global master "C:\Users\socrm\Box"
if "`c(username)'"=="kls329" global master "C:\Users\kls329\Box"
if "`c(username)'"=="km978" global master "C:\Users\km978\Box\NSF Senegal"
if "`c(username)'"=="Kateri" global master "C:\Users\Kateri\Box\NSF Senegal"
if "`c(username)'"=="admmi" global master "C:\Users\admmi\Box\NSF Senegal"



global village_observations "$master\Data Management\Output\Data Quality Checks\Midline\R2_Village_Observations"
global household_roster "$master\Data Management\Output\Data Quality Checks\Midline\R2_Household_Roster"
global knowledge "$master\Data Management\Output\Data Quality Checks\Midline\R2_Knowledge"
global health "$master\Data Management\Output\Data Quality Checks\Midline\R2_Health" 
global agriculture_inputs "$master\Data Management\Output\Data Quality Checks\Midline\R2_Agriculture_Inputs"
global agriculture_production "$master\Data Management\Output\Data Quality Checks\Midline\R2_Agriculture_Production"
global food_consumption "$master\Data Management\Output\Data Quality Checks\Midline\R2_Food_Consumption"
global income "$master\Data Management\Output\Data Quality Checks\Midline\R2_Income"
global standard_living "$master\Data Management\Output\Data Quality Checks\Midline\R2_Standard_Living"
global beliefs "$master\Data Management\Output\Data Quality Checks\Midline\R2_Beliefs" 
global enum_observations "$master\Data Management\Output\Data Quality Checks\Midline\R2_Enumerator_Observations"

************************* Baseline file path  **********************************

global baseline "$master\Data Management\_CRDES_CleanData\Baseline\Identified"


************************* Final output file path **********************************


global issues "$master\Data Management\External_Corrections\Issues for Justin and Amina\Midline\Issues"
global issuesOriginal "$master\Data Management\Output\Data Quality Checks\Midline\_Original_Issues_Output"


********************** COMBINE FILES INTO SECTION FILES **********************

*** Combine village observation files ***


************************* COMBINE HOUSEHOLD ROSTER FILES *****************
* Note: check to see what was output

use "$household_roster\Issue_Household_hh_age_10.dta", clear 
append using "$household_roster\Issue_Household_hh_age_12.dta"
append using "$household_roster\Issue_Household_hh_age_19.dta"
append using "$household_roster\Issue_Household_hh_education_level_1.dta"
append using "$household_roster\Issue_Household_hh_education_level_2.dta"
append using "$household_roster\Issue_Household_hh_education_level_4.dta"
append using "$household_roster\Issue_Household_hh_education_level_5.dta"
append using "$household_roster\Issue_Household_hh_education_level_6.dta"
append using "$household_roster\Issue_Household_hh_education_level_13.dta"
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
append using "$household_roster\Issue_Household_sum_less_than_hh_18_19.dta"
append using "$household_roster\Issue_hh_12_o_1.dta"
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
append using "$household_roster\Issue_hh_44_1.dta"
append using "$household_roster\Issue_hh_44_4.dta"
append using "$household_roster\Issue_hh_44_5.dta"
append using "$household_roster\Issue_hh_44_6.dta"
append using "$household_roster\Issue_hh_44_9.dta"
append using "$household_roster\Issue_hh_44_10.dta"
append using "$household_roster\Issue_hh_46_1.dta"
append using "$household_roster\Issue_hh_46_4.dta"
append using "$household_roster\Issue_hh_46_5.dta"
append using "$household_roster\Issue_hh_46_6.dta"
append using "$household_roster\Issue_hh_46_9.dta"
append using "$household_roster\Issue_hh_46_10.dta"
append using "$household_roster\Issue_hh_47_oth_7.dta"
append using "$household_roster\Issue_hh_47_oth_11.dta"
append using "$household_roster\Issue_hh_47_oth_21.dta"
append using "$household_roster\Issue_HH_Roster_hh_age_resp.dta"
append using "$household_roster\Issue_Household_hh_01_5_unreasonable.dta"
append using "$household_roster\Issue_Household_hh_01_7_unreasonable.dta"
append using "$household_roster\Issue_Household_hh_01_10_unreasonable.dta"
append using "$household_roster\Issue_Household_hh_01_12_unreasonable.dta"
append using "$household_roster\Issue_Household_hh_01_19_unreasonable.dta"
append using "$household_roster\Issue_Household_hh_02_5_unreasonable.dta"
append using "$household_roster\Issue_Household_hh_02_7_unreasonable.dta"
append using "$household_roster\Issue_Household_hh_02_10_unreasonable.dta"
append using "$household_roster\Issue_Household_hh_02_12_unreasonable.dta"
append using "$household_roster\Issue_Household_hh_02_19_unreasonable.dta"
append using "$household_roster\Issue_Household_hh_03_5.dta"
append using "$household_roster\Issue_Household_hh_03_7.dta"
append using "$household_roster\Issue_Household_hh_03_10.dta"
append using "$household_roster\Issue_Household_hh_03_12.dta"
append using "$household_roster\Issue_Household_hh_03_19.dta"
append using "$household_roster\Issue_Household_hh_08_5_unreasonable.dta"
append using "$household_roster\Issue_Household_hh_08_7_unreasonable.dta"
append using "$household_roster\Issue_Household_hh_08_10_unreasonable.dta"
append using "$household_roster\Issue_Household_hh_08_12_unreasonable.dta"
append using "$household_roster\Issue_Household_hh_08_19_unreasonable.dta"
append using "$household_roster\Issue_Household_hh_09_5_unreasonable.dta"
append using "$household_roster\Issue_Household_hh_09_7_unreasonable.dta"
append using "$household_roster\Issue_Household_hh_09_10_unreasonable.dta"
append using "$household_roster\Issue_Household_hh_09_12_unreasonable.dta"
append using "$household_roster\Issue_Household_hh_09_19_unreasonable.dta"
append using "$household_roster\Issue_Household_hh_10_5_unreasonable.dta"
append using "$household_roster\Issue_Household_hh_10_7_unreasonable.dta"
append using "$household_roster\Issue_Household_hh_10_10_unreasonable.dta"
append using "$household_roster\Issue_Household_hh_10_12_unreasonable.dta"
append using "$household_roster\Issue_Household_hh_10_19_unreasonable.dta"
append using "$household_roster\Issue_Household_hh_age_1.dta"
append using "$household_roster\Issue_Household_hh_age_2.dta"
append using "$household_roster\Issue_Household_hh_age_3.dta"
append using "$household_roster\Issue_Household_hh_age_5.dta"
append using "$household_roster\Issue_Household_hh_age_7.dta"
append using "$household_roster\Issue_Household_hh_age_8.dta"


save "$household_roster\Roster_Issues.dta", replace 

***  ***
*************************  COMBINE KNOWLEDGE FILES *****************
* Note: check to see what was output


************************* COMBINE HEALTH FILES *****************
* Note: check to see what was output

use "$health\Issue_health_5_12_4.dta", clear 

append using "$health\Issue_health_5_12_5.dta"
append using "$health\Issue_health_5_12_8.dta"
append using "$health\Issue_health_5_12_9.dta"
append using "$health\Issue_health_5_12_10.dta"
append using "$health\Issue_health_5_12_11.dta"
append using "$health\Issue_health_5_12_12.dta"
append using "$health\Issue_Household_health_5_2_5.dta"
append using "$health\Issue_Household_health_5_2_7.dta"
append using "$health\Issue_Household_health_5_2_10.dta"
append using "$health\Issue_Household_health_5_2_12.dta"
append using "$health\Issue_Household_health_5_2_19.dta"
append using "$health\Issue_Household_health_5_5_5.dta"
append using "$health\Issue_Household_health_5_5_7.dta"
append using "$health\Issue_Household_health_5_5_10.dta"
append using "$health\Issue_Household_health_5_5_12.dta"
append using "$health\Issue_Household_health_5_5_19.dta"
append using "$health\Issue_Household_health_5_6_5.dta"
append using "$health\Issue_Household_health_5_6_7.dta"
append using "$health\Issue_Household_health_5_6_10.dta"
append using "$health\Issue_Household_health_5_6_12.dta"
append using "$health\Issue_Household_health_5_6_19.dta"
append using "$health\Issue_Household_health_5_7_1_5.dta"
append using "$health\Issue_Household_health_5_7_1_7.dta"
append using "$health\Issue_Household_health_5_7_1_10.dta"
append using "$health\Issue_Household_health_5_7_1_12.dta"
append using "$health\Issue_Household_health_5_7_1_19.dta"
append using "$health\Issue_Household_health_5_8_5.dta"
append using "$health\Issue_Household_health_5_8_7.dta"
append using "$health\Issue_Household_health_5_8_10.dta"
append using "$health\Issue_Household_health_5_8_12.dta"
append using "$health\Issue_Household_health_5_8_19.dta"
append using "$health\Issue_Household_health_5_9_5.dta"
append using "$health\Issue_Household_health_5_9_7.dta"
append using "$health\Issue_Household_health_5_9_10.dta"
append using "$health\Issue_Household_health_5_9_12.dta"
append using "$health\Issue_Household_health_5_9_19.dta"
append using "$health\Issue_health_5_12_1.dta"
append using "$health\Issue_health_5_12_2.dta"
append using "$health\Issue_health_5_12_3.dta"

save "$health\Health_Issues.dta", replace 


************************* COMBINE AGRICULTURE INPUTS FILES *****************
* Note: check to see what was output

use "$agriculture_inputs\Issue_agri_6_40_a_code_3_missing.dta", clear 

append using "$agriculture_inputs\Issue_agri_6_40_a_code_4_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_41_a_1_unreasonable.dta"
append using "$agriculture_inputs\Issue_agri_6_41_a_2_unreasonable.dta"
append using "$agriculture_inputs\Issue_agri_6_41_a_code_1_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_41_a_code_2_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_41_a_code_3_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_41_a_code_4_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_41_a_code_5_missing.dta"
append using "$agriculture_inputs\Issue_agriculture__actif_number_5.dta"
append using "$agriculture_inputs\Issue_agri_6_15_unreasonable.dta"
append using "$agriculture_inputs\Issue_agri_6_28_1_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_28_2_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_28_3_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_28_4_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_38_a_1_unreasonable.dta"
append using "$agriculture_inputs\Issue_agri_6_38_a_code_1_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_38_a_code_2_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_38_a_code_4_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_39_a_1_unreasonable.dta"
append using "$agriculture_inputs\Issue_agri_6_39_a_2_unreasonable.dta"
append using "$agriculture_inputs\Issue_agri_6_39_a_code_1_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_39_a_code_2_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_39_a_code_3_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_39_a_code_4_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_39_a_code_5_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_40_a_1_unreasonable.dta"
append using "$agriculture_inputs\Issue_agri_6_40_a_2_unreasonable.dta"
append using "$agriculture_inputs\Issue_agri_6_40_a_code_1_missing.dta"
append using "$agriculture_inputs\Issue_agri_6_40_a_code_2_missing.dta"

save "$agriculture_inputs\Ag_Inputs_Issues.dta", replace 

************************* COMBINE AGRICULTURE PRODUCITON FILES *****************
* Note: check to see what was output


use "$agriculture_production\Issue_legumes_01_3_unreasonable.dta", clear
append using "$agriculture_production\Issue_legumes_02_1_unreasonable.dta"
append using "$agriculture_production\Issue_legumes_02_3_unreasonable.dta"
append using "$agriculture_production\Issue_legumes_02_6_unreasonable.dta"
append using "$agriculture_production\Issue_legumes_03_3_unreasonable.dta"
append using "$agriculture_production\Issue_legumes_04_1_unreasonable.dta"
append using "$agriculture_production\Issue_legumes_04_4_unreasonable.dta"
append using "$agriculture_production\Issue_legumes_05_1_unreasonable.dta"
append using "$agriculture_production\Issue_legumes_05_3_unreasonable.dta"
append using "$agriculture_production\Issue_legumes_05_4_unreasonable.dta"
append using "$agriculture_production\Issue_legumes_05_6_unreasonable.dta"
append using "$agriculture_production\Issue_legumineuses_01_5_unreasonable.dta"
append using "$agriculture_production\Issue_legumineuses_02_5_unreasonable.dta"
append using "$agriculture_production\Issue_legumineuses_05_1_unreasonable.dta"
append using "$agriculture_production\Issue_legumineuses_05_2_unreasonable.dta"
append using "$agriculture_production\Issue_legumineuses_05_3_unreasonable.dta"
append using "$agriculture_production\Issue_legumineuses_05_4_unreasonable.dta"
append using "$agriculture_production\Issue_legumineuses_05_5_unreasonable.dta"
append using "$agriculture_production\Issue_o_culture_01_unreasonable.dta"
append using "$agriculture_production\Issue_o_culture_04_unreasonable.dta"
append using "$agriculture_production\Issue_o_culture_05_unreasonable.dta"
append using "$agriculture_production\Issue_aquatique_01_unreasonable.dta"
append using "$agriculture_production\Issue_aquatique_02_unreasonable.dta"
append using "$agriculture_production\Issue_aquatique_05_unreasonable.dta"
append using "$agriculture_production\Issue_cereals_01_1_unreasonable.dta"
append using "$agriculture_production\Issue_cereals_01_3_unreasonable.dta"
append using "$agriculture_production\Issue_cereals_02_1_unreasonable.dta"
append using "$agriculture_production\Issue_cereals_03_1_unreasonable.dta"
append using "$agriculture_production\Issue_cereals_03_3_unreasonable.dta"
append using "$agriculture_production\Issue_cereals_04_1_unreasonable.dta"
append using "$agriculture_production\Issue_cereals_05_1_unreasonable.dta"
append using "$agriculture_production\Issue_cereals_05_6_unreasonable.dta"
append using "$agriculture_production\Issue_farines_02_2_unreasonable.dta"
append using "$agriculture_production\Issue_farines_05_2_unreasonable.dta"
append using "$agriculture_production\Issue_farines_05_6_unreasonable.dta"
append using "$agriculture_production\Issue_legumes_01_1_unreasonable.dta"



save "$agriculture_production\Ag_Production_Issues.dta", replace 


************************* COMBINE FOOD CONSUMPTION ISSUE FILES *****************
* Note: check to see what was output


************************* COMBINE INCOME ISSUE FILES *****************
* Note: check to see what was output

use "$income\Issue_agri_income_07_o_unreasonable.dta", clear
append using "$income\Issue_agri_income_08_2_unreasonable.dta"
append using "$income\Issue_agri_income_08_3_unreasonable.dta"
append using "$income\Issue_agri_income_08_4_unreasonable.dta"
append using "$income\Issue_agri_income_08_o_unreasonable.dta"
append using "$income\Issue_agri_income_11_1_unreasonable.dta"
append using "$income\Issue_agri_income_11_2_unreasonable.dta"
append using "$income\Issue_agri_income_12_2_unreasonable.dta"
append using "$income\Issue_agri_income_23_1_unreasonable.dta"
append using "$income\Issue_agri_income_23_2_unreasonable.dta"
append using "$income\Issue_agri_income_23_o_unreasonable.dta"
append using "$income\Issue_agri_income_29_unreasonable.dta"
append using "$income\Issue_agri_income_33_unreasonable.dta"
append using "$income\Issue_agri_income_36_1_unreasonable.dta"
append using "$income\Issue_agri_income_36_2_unreasonable.dta"
append using "$income\Issue_agri_income_45_1.dta"
append using "$income\Issue_agri_income_45_2.dta"
append using "$income\Issue_agri_income_45_3.dta"
append using "$income\Issue_agri_income_45_4.dta"
append using "$income\Issue_agri_income_45_5.dta"
append using "$income\Issue_agri_income_45_6.dta"
append using "$income\Issue_agri_income_45_7.dta"
append using "$income\Issue_agri_income_45_8.dta"
append using "$income\Issue_agri_income_47_1.dta"
append using "$income\Issue_animals_sales_o.dta"
append using "$income\Issue_agri_income_03_unreasonable.dta"
append using "$income\Issue_agri_income_05_unreasonable.dta"
append using "$income\Issue_agri_income_06_unreasonable.dta"
append using "$income\Issue_agri_income_07_2_unreasonable.dta"

save "$income\Income_Issues.dta", replace 

************************* COMBINE STANDARD OF LIVING ISSUE FILES  *****************
* Note: check to see what was output

************************* COMBINE ENUMERATOR OBSERVATION ISSUE FILES *****************
* Note: check to see what was output



************** COMBINE SECTION FILES INTO ONE HOUSEHOLD ISSUES FILE *************


		use "$household_roster\Roster_Issues.dta", replace
		*append using "$knowledge\Knoweldge_Issues.dta"
		append using "$health\Health_Issues.dta"
		append using "$agriculture_inputs\Ag_Inputs_Issues.dta"
		append using "$agriculture_production\Ag_Production_Issues.dta"
		*append using "$food_consumption\Food_Consumption_Issues.dta"
		append using "$income\Income_Issues.dta"
		*append using "$standard_living\Standard_of_Living_Issues.dta"
		*append using "$enum_observations\Enumerator_Issues.dta"

		
		rename hh_name_complet_resp individ 
	
*Bring in HH head names from baseline 

*KRM - leaving this here for reference

		/*
		use "$baseline\All_Villages_With_Individual_IDs.dta", clear 
		rename hhid_village villageid
		keep hhid villageid individ hh_head_name_complet hh_name_complet_resp

		save "$baseline\All_Villages_With_Individual_IDs_Selected_Vars.dta", replace 
		*/

		** merge baseline data 
merge m:m hhid individ using "$baseline\All_Villages_With_Individual_IDs_Selected_Vars.dta", force

		** cleaning 
		drop if villageid == ""
		drop if sup == . 
		rename individ hh_individ_complet_resp
		replace hh_name_complet_resp = hh_name_complet_resp_new if hh_individ_complet_resp == "999"
		drop hh_name_complet_resp_new
		gen last_update = "Sent on Jan2825" if _merge != .
		rename _merge _merge_Jan28

		order villageid sup sup_name enqu enqu_name hhid hh_individ_complet_resp hh_head_name_complet hh_name_complet_resp hh_member_name hh_phone print_issue issue issue_variable_name last_update _merge_Jan28
************* EXPORT COMBINED HOUSEHOLD CHECKS DATA FILE ************* 


* update to bring in suvey questions
/*

import excel using "$issues\Household_Data_Issues_28Jan2025_surveyquestions.xlsx", sheet("Sheet1") firstrow clear
keep SurveyQuestion issue_variable_name

merge m:m issue_variable_name using "$issuesOriginal\Household_Data_Issues_28Jan2025.dta"

	order villageid sup sup_name enqu enqu_name hhid hh_individ_complet_resp hh_head_name_complet hh_name_complet_resp hh_member_name hh_phone print_issue issue issue_variable_name SurveyQuestion last_update _merge_Jan28
*/


*Note - please update DATE on export!:) 
export excel using "$issues\Household_Data_Issues_28Jan2025.xlsx", firstrow(variables) replace 
*keep original for version control 
export excel using "$issuesOriginal\Household_Data_Issues_28Jan2025.xlsx", firstrow(variables) replace 
save "$issuesOriginal\Household_Data_Issues_28Jan2025.dta", replace 

