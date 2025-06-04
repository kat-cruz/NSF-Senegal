*==============================================================================
* Program : Transform Household and Health module data into long form 
*=============================================================================
* written by: Kateri Mouawad
* Created: April 2025
* Updates recorded in GitHub

* <><<><><>> Read Me  <><<><><>>

	*^*^* This .do file processes:
	*** 							DISES_Midline_Complete_PII
	
	
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
	global data "$master\Data_Management\Data\_CRDES_CleanData\Midline\Identified"
	global hhids "$master\Data_Management\Output\Data_Processing\ID_Creation\Midline"
	global long_out "$master\Data_Management\Output\Data_Processing\Construction"
	global ids "$master\Data_Management\Data\_CRDES_CleanData\Midline\Identified\Midline_Individual_IDs.dta"
	global clean "$master\Data_Management\Data\_CRDES_CleanData\Midline\Identified"
	

	*** import complete data for geographic and preliminary information ***
		use "$data\DISES_Midline_Complete_PII.dta", clear 
		
		*(use "C:\Users\km978\Box\NSF Senegal\Data_Management\Data\_CRDES_CleanData\Midline\Deidentified\Complete_Midline_Household_Roster.dta", clear
	
/* 

*-----------------------------------------*
**# Household roster module
*-----------------------------------------*
	
	** Laying out all variables for bookeeping 
	
	** removed from baseline:
		** audit_record*
		** hh_33

*preserve 	



keep starttime* endtime* deviceid* devicephonenum* username* device_info* duration* caseid* ///
     today* record_text*  ///
     village_select* village_select_o* hhid_village* hhid region* departement* commune* village* grappe* schoolmosqueclinic* grappe_int* ///
      sup* sup_txt* sup_name* ///
     enqu* enqu_o* enqu_txt* enqu_name* ///
     consent* ///
     start_survey*  ///
     start_identification* hh_region* hh_department* hh_commune* hh_district* ///
     hh_arrondissement* hh_village* hh_numero* hh_phone* hh_head_name_complet* hh_name_complet_resp* ///
     hh_age_resp* hh_gender_resp* hh_date* hh_time* end_identification* ///
     start_hh_composition*  _household_roster* ///
     hh_first_name* hh_name* hh_surname* hh_full_name_calc* pull_hh_full_name_calc* hh_gender* hh_age* pull_hh_age* pull_hh_gender* /// // identifiable info here 
     hh_ethnicity* hh_ethnicity_o* hh_relation_with* hh_relation_with_o* hh_education_skills* ///
     hh_education_level* hh_education_level_o* hh_education_year_achieve* hh_main_activity* hh_main_activity_o* ///
     hh_mother_live* hh_relation_imam* hh_presence_winter* hh_presence_dry* hh_active_agri* ///
     hh_01* hh_02* hh_03* hh_04* hh_05* hh_06* hh_07* hh_08* hh_09* hh_10* hh_11* hh_11_o* hh_12* hh_12_a* hh_12_o* ///
     hh_12_calc* hh_12_roster* hh_12index* hh_12name* hh_13* hh_13_o* hh_13_sum* ///
     hh_14* hh_15* hh_15_o* hh_16* hh_17* hh_18* hh_19* hh_19_o* hh_20* hh_20_a* hh_20_o* hh_20_calc* ///
     hh_20_roster* hh_20index* hh_20name* hh_21* hh_21_o* hh_21_sum* ///
     hh_22* hh_23* hh_23_o* hh_24* hh_25* hh_26* hh_27* hh_28* hh_29* hh_29_o* hh_30* ///
     hh_31* hh_32* hh_34* hh_35* hh_36* hh_37* hh_38* ///
	 hh_39* hh_40* hh_41* hh_42* hh_43* hh_44* hh_45* hh_46* hh_47* hh_48* hh_48* hh_50* hh_51* hh_52* ///
     posif_here* calc_man* calc_woman* ///
     current_list* list_man* list_woman* ///
     name* ///
     end_hh_composition* final_list* final_list_confirm* 
	 

	** now drop identifying variables 
	
	*^*^* drop variables that are not relevant/ or are identifiable 
	
	
	drop starttime* endtime* deviceid* devicephonenum* username* device_info* duration* caseid* ///
     today* record_text*   ///
     village_select* village_select_o* hhid_village* region* departement* commune* village* grappe* schoolmosqueclinic* grappe_int* ///
      sup* sup_txt* sup_name* ///
     enqu* enqu_o* enqu_txt* enqu_name* ///
     consent* ///
     start_survey*  ///
     start_identification* hh_region* hh_department* hh_commune* hh_district* ///
	 hh_arrondissement* hh_first_name* hh_numero* ///	 
	 end_identification* _household_roster* start_hh_composition* ///
	 posif_here* calc_man* calc_woman* ///
     current_list* list_man* list_woman* ///
     name* ///
     end_hh_composition* final_list* final_list_confirm* 
		 *hh_age_resp* hh_gender_resp* hh_date* hh_time* hh_name* hh_surname* hh_full_name_calc* ///
		  hh_phone* hh_head_name_complet* hh_name_complet_resp* ///
		 
	*^*^* reindex variables with bad indecies to prep for reshape the data 	
		 
		 * hh_12index
		forval i = 7(-1)1 {
			forval j = 1/57 {
				cap rename hh_12index_`j'_`i' hh_12index_`i'_`j'
			}
		}

		* hh_12name
		forval i = 7(-1)1 {
			forval j = 1/57 {
				cap rename hh_12name_`j'_`i' hh_12name_`i'_`j'
			}
		}

		* hh_13
		forval i = 7(-1)1 {
			forval j = 1/57 {
				cap rename hh_13_`j'_`i' hh_13_`i'_`j'
			}
		}

		* hh_20index
		forval i = 7(-1)1 {
			forval j = 1/57 {
				cap rename hh_20index_`j'_`i' hh_20index_`i'_`j'
			}
		}

		* hh_20name
		forval i = 7(-1)1 {
			forval j = 1/57 {
				cap rename hh_20name_`j'_`i' hh_20name_`i'_`j'
			}
		}
		
		* hh_21 
		forval i = 7(-1)1 {
			forval j = 1/57 {
				cap rename hh_21_`j'_`i' hh_21_`i'_`j'
			}
		}
		
	*** transform variables that need to be strings for the reshape 
		
		forvalues i = 1/57 {
			tostring hh_20_`i', replace
			tostring hh_23_`i', replace
			tostring hh_12_`i', replace
			tostring hh_education_level_o_`i', replace 
			tostring hh_ethnicity_o_`i', replace 
			tostring hh_education_skills_`i', replace 
			tostring hh_main_activity_o_`i', replace 
			tostring hh_relation_with_o_`i', replace 
			tostring pull_hh_full_name_calc__`i', replace 
		}
		
	tostring hh_11_o_* hh_12_o* hh_15_o_* hh_19_o* hh_20_o* hh_23_o* hh_29_o_* hh_12name* hh_20name* hh_47_oth_* hh_52* hh_46_o* hh_12_a_o* hh_full_name_calc_*, replace 
	
/* 
	preserve 
	
	keep hhid hh_age_resp hh_gender_resp hh_phone
		tempfile indiv_data
			save `indiv_data'
	
	restore 
		
*/
	reshape long ///
	   hh_full_name_calc_  pull_hh_full_name_calc__  pull_hh_age__  pull_hh_gender__ /// // keep identifiable variables for now to merge in the individual IDs
      hh_age_ hh_gender_  hh_ethnicity_ hh_ethnicity_o_ hh_relation_with_o_ ///
			hh_education_skills_ hh_education_skills_0_ hh_education_skills_1_ hh_education_skills_2_ hh_education_skills_3_ hh_education_skills_4_ hh_education_skills_5_ hh_education_skills_o_ hh_education_level_o_ hh_education_level_  hh_education_year_achieve_   ///
			hh_mother_live_ hh_relation_imam_ hh_relation_with_ hh_presence_winter_ hh_presence_dry_ hh_main_activity_ hh_main_activity_o_ hh_active_agri_ ///
			hh_01_ hh_02_ hh_03_ hh_04_ hh_05_ hh_06_ hh_07_ hh_08_ hh_09_ hh_10_ hh_11_ hh_11_o_ ///
			hh_12_ hh_12_1_ hh_12_2_ hh_12_3_ hh_12_4_ hh_12_5_ hh_12_6_ hh_12_7_ hh_12_8_ hh_12_9_ hh_12_10_ hh_12_999_ ///
			hh_12_a_ hh_12_a_o_ hh_12_o_ hh_12_calc_ hh_12_roster_ hh_12_roster_count_ ///
			hh_12index_1_ hh_12index_2_ hh_12index_3_ hh_12index_4_ hh_12index_5_ hh_12index_6_ hh_12index_7_ ///
			hh_12name_1_ hh_12name_2_ hh_12name_3_ hh_12name_4_ hh_12name_5_ hh_12name_6_ hh_12name_7_ ///
			hh_13_ hh_13_o_ hh_13_sum_ ///
			hh_13_1_ hh_13_2_ hh_13_3_ hh_13_4_ hh_13_5_ hh_13_6_ hh_13_7_ ///
			hh_14_ hh_14_a_ hh_14_b_ hh_15_ hh_15_o_ hh_16_ hh_17_ hh_18_ hh_19_ hh_19_o_ ///
			hh_20_ hh_20_1_ hh_20_2_ hh_20_3_ hh_20_4_ hh_20_5_ hh_20_6_ hh_20_7_ hh_20_8_ hh_20_9_ hh_20_10_ hh_20_999_ ///
			hh_20_a_ hh_20_o_ hh_20_calc_ hh_20_roster_  hh_20_roster_count_ ///
			hh_20index_1_ hh_20index_2_ hh_20index_3_ hh_20index_4_ hh_20index_5_ hh_20index_6_ hh_20index_7_ ///
			hh_20name_1_ hh_20name_2_ hh_20name_3_ hh_20name_4_ hh_20name_5_ hh_20name_6_ hh_20name_7_ ///
			hh_21_ hh_21_o_ hh_21_sum_ ///
			hh_21_1_ hh_21_2_ hh_21_3_ hh_21_4_ hh_21_5_ hh_21_6_ hh_21_7_ ///
			hh_22_ hh_23_ hh_23_o_ hh_23_1_ hh_23_2_ hh_23_3_ hh_23_4_ hh_23_5_ hh_23_99_ hh_24_ hh_25_ hh_26_ hh_27_ hh_28_ hh_29_ hh_29_o_ hh_30_ ///
			hh_31_ hh_32_ hh_34_ hh_35_ hh_36_ hh_37_ hh_38_ ///
			hh_39_ hh_40_ hh_41_ hh_42_ hh_43_ hh_44_ hh_45_ hh_46_ hh_46_o_ ///
			hh_47_oth_ hh_47_a_ hh_47_b_ hh_47_c_ hh_47_d_ hh_47_e_ hh_47_f_ hh_47_g_ ///		
			hh_48_ hh_50_ hh_51_ hh_52_, ///
			i(hhid) j(id)
	
			*merge m:1 hhid using `indiv_data', nogen 
		merge m:1 hhid hh_full_name_calc_ hh_gender_ hh_age_ using "C:\Users\km978\Box\NSF Senegal\Data_Management\Data\_CRDES_CleanData\Midline\Identified\All_Individual_IDs_Complete.dta", force nogen
	
					save "$long_out\delete_later", replace 

*-----------------------------------------*
**# Clean ID data frame 
*-----------------------------------------*	

** Here I clean the Midline_Individual_IDs data (IDs_no_merge_delete_later.dta is created below in this script)

     use  "$ids", clear
	  
	 * use "C:\Users\km978\Box\NSF Senegal\Data_Management\Data\_CRDES_CleanData\Midline\Identified\All_Individual_IDs_Complete.dta", clear
	  	* Tag duplicates based on these variables
			duplicates tag hhid hh_full_name_calc_ hh_gender_ hh_age_, generate(dup_tag)
			
			*keep if dup_tag != 0

			* Drop duplicates, keeping only the first occurrence
			duplicates drop hhid hh_full_name_calc_ hh_gender_ hh_age_, force
			* Optionally, drop the tag variable if no longer needed
			drop dup_tag
			
			drop _merge
					

		save "$long_out\dupids_from_id_list_delete_later.dta", replace

		
*-----------------------------------------*
**# Under construction 
*-----------------------------------------*					
					
			
		use "$long_out\delete_later", clear 
			
 ** keep some identifying variables to see what's going on 
 
			keep hhid hh_full_name_calc*  pull_hh_full_name_calc*  /// // keep identifiable variables for now to merge in the individual IDs
			  hh_age* hh_gender*  hh_ethnicity_ pull_hh_age* pull_hh_gender*
	  
				
** replace any missing values in hh_full_name_calc_ hh_age_ hh_gender_ to retain full list
 
			replace hh_full_name_calc_ = pull_hh_full_name_calc__ if hh_full_name_calc_ == ""
			replace hh_age_ = pull_hh_age__ if hh_age_ == .
			replace hh_gender_ = pull_hh_gender__ if hh_gender_ == .
			
** drop empty rows
		
				drop if (hh_full_name_calc_ == "" | hh_full_name_calc_ == ".") & hh_gender_ == . & hh_age_ == .  
		 
		 
** remove dupliactes

**			tag duplicates based on these variables which I'll be merging on 
				duplicates tag hhid hh_full_name_calc_ hh_gender_ hh_age_, generate(dup_tag)
			
			*keep if dup_tag != 0

**			drop duplicates, keeping only the first occurrence
				duplicates drop hhid hh_full_name_calc_ hh_gender_ hh_age_, force
				
					drop dup_tag
					
** merge with ll_Individual_IDs_Complete.dta  that has been cleaned of duplicates 

			merge 1:1 hhid hh_full_name_calc_ hh_gender_ hh_age_ using "$long_out\dupids_from_id_list_delete_later.dta"  
			*merge 1:m hhid hh_full_name_calc_ hh_gender_ hh_age_ using  "$ids", nogen 
			
				keep if _merge != 3
				
**	what is retained are all the names in the midline data that I don't see in the Midline_Individual_IDs data.


** review tomorrow 









************IGNORE EVERYTHING HERE HAHAHAHAHAH************************

	**## Merge in df with midline individual IDs
		
		*use "$long_out\IDs_no_merge_delete_later", clear
/ 
		
** RUN THIS PORTION TO SEE WHATS WRONG
		
		use "$clean\All_Individual_IDs_Complete.dta", clear
		drop _merge
	
	
			merge m:m  hh_full_name_calc_ hh_gender_ hh_age_ hh_relation_with_ using "$long_out\delete_later" 
			
			keep if _merge != 3
				keep  hhid individ hh_full_name_calc_ hh_gender_ hh_age_ hh_relation_with_ _merge pull_hh_full_name_calc__
				
				 sort hhid
				
*/
					
			
		** merge is not working 
				
			*use  "$ids", clear
			
	*drop hh_head_name_complet_ hh_name_complet_resp_ hh_age_resp_ hh_gender_resp_ hh_phone_ hh_full_name_calc_ hh_gender_ hh_age_ hh_relation_with_

	*save "$long_out\baseline_household_long.dta", replace 

		
*restore 

 
*-----------------------------------------*
**# Health roster module
*-----------------------------------------*	
		
*preserve 		
 */
  
/*
 preserve 
 
 use  "C:\Users\km978\Box\NSF Senegal\Data_Management\Data\_CRDES_CleanData\Midline\Identified\Midline_Individual_IDs.dta", clear 
 drop _merge
 tempfile Midline_Individual_IDs
 save `Midline_Individual_IDs'
 
 restore 
 
*/
keep hhid_village hhid health* ///
 hh_full_name_calc* hh_gender* hh_age* add_new* hh_relation_with_*  // identifiable info here 

	drop health_5_13 health_5_14_a health_5_14_b health_5_14_c healthname* hh_age_resp hh_gender_resp hh_relation_with_o*
	
forvalues i = 1/57 {
			tostring health_5_11_o_`i', replace 
			tostring  health_5_3_`i', replace 
			tostring health_5_3_o_`i', replace 
			tostring  hh_full_name_calc_`i', replace 
		}


reshape long /// 
	hh_full_name_calc_  hh_relation_with_ hh_age_  hh_gender_ add_new_ ///
	health_add_new_ health_still_member_ ///
	health_5_2_ health_5_3_ ///
	health_5_3_1_ health_5_3_2_ health_5_3_3_ health_5_3_4_ health_5_3_5_ health_5_3_6_ health_5_3_7_ health_5_3_8_ health_5_3_9_ health_5_3_10_ health_5_3_11_ health_5_3_12_  health_5_3_13_ health_5_3_14_ health_5_3_99_  ///
	health_5_3_o_ health_5_4_ health_5_5_  ///
	health_5_6_ health_5_7_ health_5_7_1_ health_5_8_ health_5_9_ health_5_10_ ///
	health_5_11_  health_5_11_o_ health_5_12_ health_5_14_ ///
	health_5_14_note_   ///
	healthage_ healthindex_ healthgenre_, ///
			i(hhid hhid_village) j(id)
			
		drop if (hh_full_name_calc_ == "" | hh_full_name_calc_ == ".") & hh_gender_ == . & hh_age_ == . 

		drop if inlist(hhid, "133A19", "133A03", "133A20", "133A02", "133A05", "133A11")
		
		
		merge m:m hhid_village hhid add_new_ hh_full_name_calc_ hh_gender_ hh_age_ hh_relation_with_ using "C:\Users\km978\Box\NSF Senegal\Data_Management\Data\_CRDES_CleanData\Midline\Identified\Midline_Individual_IDs.dta"
				
		drop if inlist(hhid, "133A19", "133A03", "133A20", "133A02", "133A05", "133A11")
				
			drop hh_full_name_calc_ hh_relation_with_ hh_age_ hh_gender_ add_new_ hh_head_name_complet hh_name_complet_resp hh_name_complet_resp_new hh_age_resp hh_gender_resp hh_phone individual pull_hh_full_name_calc__ pull_hh_age__ hh_relation_with_o_ indiv_index hh_name_complet_resp_new_individ _merge
					
	save "$long_out\midline_health_long.dta", replace 	
	
				
*restore 				
				
*/

				
				
*** end of .do file				
				
				
            			
