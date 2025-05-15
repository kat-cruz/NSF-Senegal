*==============================================================================
* Program : Transform Household and Health module data into long form 
*=============================================================================
* written by: Kateri Mouawad
* Created: April 2025
* Updates recorded in GitHub

* <><<><><>> Read Me  <><<><><>>

	*^*^* This .do file processes:
	*** 							DISES_Baseline_Complete_PII
	
	
	*^*^* This .do file outputs:
	***							   baseline_household_long.dta



*-----------------------------------------*
**# INITIATE SCRIPT
*-----------------------------------------*
		
	clear all
	set mem 100m
		set maxvar 30000
		set matsize 11000
	set more off


*-----------------------------------------*
**# SET FILE PATHS
*-----------------------------------------*

*^*^* Set base Box path for each user
	if "`c(username)'"=="socrm" global master "C:\Users\socrm\Box\NSF Senegal"
	if "`c(username)'"=="kls329" global master "C:\Users\kls329\Box\NSF Senegal"
	if "`c(username)'"=="km978" global master "C:\Users\km978\Box\NSF Senegal"
	if "`c(username)'"=="Kateri" global master "C:\Users\Kateri\Box\NSF Senegal"
	if "`c(username)'"=="admmi" global master "C:\Users\admmi\Box\NSF Senegal"

	
	*** additional file paths ***
	global data_clean "$master\Data_Management\Data\_CRDES_CleanData\Baseline\Identified"
	global data_raw "$master\Data_Management\Data\_CRDES_RawData\Baseline"
	global hhids "$master\Data_Management\Output\Data_Processing\ID_Creation\Baseline"
	global data_deidentified "$master\Data_Management\Data\_CRDES_CleanData\Baseline\Deidentified"
	global data_identified "$master\Data_Management\Data\_CRDES_CleanData\Baseline\Identified"
	global long_out "$master\Data_Management\Output\Data_Processing\Construction"
	*** I've created a data set that contains the resp and household head index for the balance tables along with the IDs
	global balance_out "$master\Data_Management\Output\Analysis\Balance_Tables"
		global respondent_index "$master\Data_Management\Data\_CRDES_CleanData\Baseline\Deidentified\respondent_index.dta"
		global hh_head_index "$master\Data_Management\Data\_CRDES_CleanData\Baseline\Deidentified\household_head_index.dta"

	*** import complete data for geographic and preliminary information ***
	use "$data_clean\DISES_Baseline_Complete_PII", clear 
		
		
			
/* 

		*merge 1:1 hhid using "$hh_head_index", nogen
		*merge 1:1 hhid using "$respondent_index", nogen
			
			forvalues i = 1/55 {
			gen resp_index_`i' = (resp_index == `i')
		}
			
			forvalues i = 1/55 {
			gen hh_head_index_`i' = (hh_head_index == `i')
		}
	
*/
	
	

*-----------------------------------------*
**# Household roster module
*-----------------------------------------*
	
	** Laying out all variables for bookeeping 

preserve 	

keep starttime* endtime* deviceid* devicephonenum* username* device_info* duration* caseid* ///
     today* record_text* audit_record*  ///
     village_select* village_select_o* hhid_village* hhid region* departement* commune* village* grappe* schoolmosqueclinic* grappe_int* ///
      sup* sup_txt* sup_name* ///
     enqu* enqu_o* enqu_txt* enqu_name* ///
     consent* ///
     start_survey*  ///
     start_identification* hh_region* hh_department* hh_commune* hh_district* ///
    hh_head_index resp_index hh_arrondissement* hh_village* hh_numero* hh_phone* hh_head_name_complet* hh_name_complet_resp* ///
     hh_age_resp* hh_gender_resp* hh_date* hh_time* end_identification* ///
     start_hh_composition*  _household_roster* ///
     hh_first_name* hh_name* hh_surname* hh_full_name_calc* hh_gender* hh_age* ///
     hh_ethnicity* hh_ethnicity_o* hh_relation_with* hh_relation_with_o* hh_education_skills* ///
     hh_education_level* hh_education_level_o* hh_education_year_achieve* hh_main_activity* hh_main_activity_o* ///
     hh_mother_live* hh_relation_imam* hh_presence_winter* hh_presence_dry* hh_active_agri* ///
     hh_01* hh_02* hh_03* hh_04* hh_05* hh_06* hh_07* hh_08* hh_09* hh_10* hh_11* hh_11_o* hh_12* hh_12_a* hh_12_o* ///
     hh_12_calc* hh_12_roster* hh_12index* hh_12name* hh_13* hh_13_o* hh_13_sum* ///
     hh_14* hh_15* hh_15_o* hh_16* hh_17* hh_18* hh_19* hh_19_o* hh_20* hh_20_a* hh_20_o* hh_20_calc* ///
     hh_20_roster* hh_20index* hh_20name* hh_21* hh_21_o* hh_21_sum* ///
     hh_22* hh_23* hh_23_o* hh_24* hh_25* hh_26* hh_27* hh_28* hh_29* hh_29_o* hh_30* ///
     hh_31* hh_32* hh_33* hh_34* hh_35* hh_36* hh_37* hh_38* ///
     posif_here* calc_man* calc_woman* ///
     current_list* list_man* list_woman* ///
     name* ///
     end_hh_composition* final_list* final_list_confirm* 

	** drop identifying variables 
	
	*^*^* drop variables that are not relevant/ or are identifiable 
	
	
	drop starttime* endtime* deviceid* devicephonenum* username* device_info* duration* caseid* ///
     today* record_text* audit_record*  ///
     village_select* village_select_o* hhid_village* region* departement* commune* village* grappe* schoolmosqueclinic* grappe_int* ///
      sup* sup_txt* sup_name* ///
     enqu* enqu_o* enqu_txt* enqu_name* ///
     consent* ///
     start_survey*  ///
     start_identification* hh_region* hh_department* hh_commune* hh_district* ///
	 hh_arrondissement* hh_first_name* hh_numero* hh_age_resp* hh_gender_resp* hh_date* hh_time* hh_first_name* hh_name* hh_surname* hh_full_name_calc* ///
	 end_identification* _household_roster* start_hh_composition* ///
	 hh_phone* hh_head_name_complet* hh_name_complet_resp* ///
	 posif_here* calc_man* calc_woman* ///
     current_list* list_man* list_woman* ///
     name* ///
     end_hh_composition* final_list* final_list_confirm* 
	
		 
	*^*^* reindex variables with bad indecies to prep for reshape the data 	
		 
		 * hh_12index
		forval i = 7(-1)1 {
			forval j = 1/55 {
				cap rename hh_12index_`j'_`i' hh_12index_`i'_`j'
			}
		}

		* hh_12name
		forval i = 7(-1)1 {
			forval j = 1/55 {
				cap rename hh_12name_`j'_`i' hh_12name_`i'_`j'
			}
		}

		* hh_13
		forval i = 7(-1)1 {
			forval j = 1/55 {
				cap rename hh_13_`j'_`i' hh_13_`i'_`j'
			}
		}

		* hh_20index
		forval i = 7(-1)1 {
			forval j = 1/55 {
				cap rename hh_20index_`j'_`i' hh_20index_`i'_`j'
			}
		}

		* hh_20name
		forval i = 7(-1)1 {
			forval j = 1/55 {
				cap rename hh_20name_`j'_`i' hh_20name_`i'_`j'
			}
		}
		
		* hh_21 
		forval i = 7(-1)1 {
			forval j = 1/55 {
				cap rename hh_21_`j'_`i' hh_21_`i'_`j'
			}
		}
		
	*** transform variables that need to be strings for the reshape 
		
		forvalues i = 1/55 {
			tostring hh_20_`i', replace
			tostring hh_23_`i', replace
			tostring hh_12_`i', replace
			tostring hh_education_level_o_`i', replace 
			tostring hh_ethnicity_o_`i', replace 
			tostring  hh_education_skills_`i', replace 
			tostring   hh_main_activity_o_`i', replace 
			tostring   hh_relation_with_o_`i', replace 
			 
		}
		
	tostring hh_11_o_* hh_12_o* hh_15_o_* hh_19_o* hh_20_o* hh_23_o* hh_29_o_* hh_12name* hh_20name*, replace 
	
		
	reshape long ///
    hh_head_index_ resp_index_ hh_age_ hh_gender_  hh_ethnicity_ hh_ethnicity_o_ hh_relation_with_o_ ///
			hh_education_skills_ hh_education_skills_0_ hh_education_skills_1_ hh_education_skills_2_ hh_education_skills_3_ hh_education_skills_4_ hh_education_skills_5_ hh_education_skills_o_ hh_education_level_o_ hh_education_level_  hh_education_year_achieve_   ///
			hh_mother_live_ hh_relation_imam_ hh_relation_with_ hh_presence_winter_ hh_presence_dry_ hh_main_activity_ hh_main_activity_o_ hh_active_agri_ ///
			hh_01_ hh_02_ hh_03_ hh_04_ hh_05_ hh_06_ hh_07_ hh_08_ hh_09_ hh_10_ hh_11_ hh_11_o_ ///
			hh_12_ hh_12_1_ hh_12_2_ hh_12_3_ hh_12_4_ hh_12_5_ hh_12_6_ hh_12_7_ hh_12_8_ ///
			hh_12_a_ hh_12_o_ hh_12_calc_ hh_12_roster_ hh_12_roster_count_ ///
			hh_12index_1_ hh_12index_2_ hh_12index_3_ hh_12index_4_ hh_12index_5_ hh_12index_6_ hh_12index_7_ ///
			hh_12name_1_ hh_12name_2_ hh_12name_3_ hh_12name_4_ hh_12name_5_ hh_12name_6_ hh_12name_7_ ///
			hh_13_ hh_13_o_ hh_13_sum_ ///
			hh_13_1_ hh_13_2_ hh_13_3_ hh_13_4_ hh_13_5_ hh_13_6_ hh_13_7_ ///
			hh_14_ hh_15_ hh_15_o_ hh_16_ hh_17_ hh_18_ hh_19_ hh_19_o_ ///
			hh_20_ hh_20_1_ hh_20_2_ hh_20_3_ hh_20_4_ hh_20_5_ hh_20_6_ hh_20_7_ hh_20_8_ ///
			hh_20_a_ hh_20_o_ hh_20_calc_ hh_20_roster_  hh_20_roster_count_ ///
			hh_20index_1_ hh_20index_2_ hh_20index_3_ hh_20index_4_ hh_20index_5_ hh_20index_6_ hh_20index_7_ ///
			hh_20name_1_ hh_20name_2_ hh_20name_3_ hh_20name_4_ hh_20name_5_ hh_20name_6_ hh_20name_7_ ///
			hh_21_ hh_21_o_ hh_21_sum_ ///
			hh_21_1_ hh_21_2_ hh_21_3_ hh_21_4_ hh_21_5_ hh_21_6_ hh_21_7_ ///
			hh_22_ hh_23_ hh_23_o_ hh_23_1_ hh_23_2_ hh_23_3_ hh_23_4_ hh_23_5_ hh_23_99_ hh_24_ hh_25_ hh_26_ hh_27_ hh_28_ hh_29_ hh_29_o_ hh_30_ ///
			hh_31_ hh_32_ hh_33_ hh_34_ hh_35_ hh_36_ hh_37_ hh_38_, ///
			i(hhid) j(id)

		
	**## Create matching individ
			tostring hhid, replace format("%12.0f")
			tostring id, gen(str_id) format("%02.0f")
			gen str individ = hhid + str_id
			format individ %15s
			

	save "$long_out\baseline_household_long.dta", replace 
		
restore 

 
*-----------------------------------------*
**# Health roster module
*-----------------------------------------*	
		
preserve 		
 
keep hhid health*


forvalues i = 1/55 {
			tostring health_5_11_o_`i', replace 
			tostring  health_5_3_`i', replace 
			tostring health_5_3_o_`i', replace 
			 
		}


reshape long ///
	hh_head_index_ resp_index_ ///
	health_5_2_ health_5_3_ ///
	health_5_3_1_ health_5_3_2_ health_5_3_3_ health_5_3_4_ health_5_3_5_ health_5_3_6_ health_5_3_7_ health_5_3_8_ health_5_3_9_ health_5_3_10_ health_5_3_11_ health_5_3_12_  health_5_3_13_ health_5_3_14_ health_5_3_99_  ///
	health_5_3_o_ health_5_4_ health_5_5_  ///
	health_5_6_ health_5_7_ health_5_8_ health_5_9_ health_5_10_ ///
	health_5_11_  health_5_11_o_ health_5_12_ health_5_13_ health_5_14_ ///
	health_5_14_note_ health_5_14_a_ health_5_14_c_ ///
	healthage_ healthindex_ healthgenre_ healthname_, ///
			i(hhid) j(id)
	
				
				
		
	**## Create matching individ
			tostring hhid, replace format("%12.0f")
			tostring id, gen(str_id) format("%02.0f")
			gen str individ = hhid + str_id
			format individ %15s				
				
						
	save "$long_out\baseline_health_long.dta", replace 	
	
				
restore 				
				
				
				
*** end of .do file				
				
				
            			








