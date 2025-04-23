*==============================================================================
* written by: Kateri Mouawad
* Created: February 2025
* Updates recorded in GitHub


* <><<><><>> Read Me  <><<><><>>

					*** This .do file processes: 
												*All_Villages.dta
												*Dises year 2_fusion final_3_08042025.UCAD.UGB.xlsx
												*DISES UCAD.UGB.1_VILLAGES.PARASITOLOGY DATA ALL VILLAGES.controled_1_25.06.24.xlsx
												*All_Individual_IDs_Complete.dta
					*** This .do file outputs:
											*
											
		*CONTEXT:
			* After the initial baseline matching, we discovered that two CRDES villages (020B and 090B) send their children to the same school surveyed by UCAD (village 020B, Ndiayene Pendao).

			* To ensure we didn't miss any baseline matches, we verified potential matches between CRDES villages 020B and 090B with UCAD village 020B. Some code chunks reflect this verification step.

			* We also wanted to ensure no matches were missed at midline. To do this, we filtered the UCAD baseline-to-midline data to identify any newly added children, and then attempted to match these new children against the CRDES midline data.
	
		*PROCEDURE:
			* 1) Filter CRDES Data: Output CRDES baseline data for village 090B (we used the same spreadsheet for 020B as part of the rematching process).
			* 2) Prepare UCAD Data: Clean and format the UCAD data, then save it as a .dta file.
			* 3) Filter CRDES Midline Data: Identify and filter CRDES midline records for any UCAD villages found to have new children added at midline.
			* 4) Export for Matching: Save these filtered datasets as Excel spreadsheets for manual rematching.
				

*<><<><><>><><<><><>>
* INITIATE SCRIPT
*<><<><><>><><<><><>>
		
	clear all
	set mem 100m
	set maxvar 30000
	set matsize 11000
	set more off

*<><<><><>><><<><><>>
* SET FILE PATHS
*<><<><><>><><<><><>>

*^*^* Set base Box path for each user

	if "`c(username)'"=="socrm" global master "C:\Users\socrm\Box\NSF Senegal"
	if "`c(username)'"=="kls329" global master "C:\Users\kls329\Box\NSF Senegal"
	if "`c(username)'"=="km978" global master "C:\Users\km978\Box\NSF Senegal"
	if "`c(username)'"=="Kateri" global master "C:\Users\Kateri\Box\NSF Senegal"
	if "`c(username)'"=="admmi" global master "C:\Users\admmi\Box\NSF Senegal"


*^*^* Define project-specific paths

	global id "$master\Data_Management\Output\Data_Processing\ID_Creation\Baseline\UCAD_EPLS_IDs"
	global id_mid  "$master\Data_Management\Data\_CRDES_CleanData\Midline\Identified"
	
	global cleandata_ucad_base "$master\Data_Management\Data\_Partner_CleanData\UCAD_Data\Baseline"
	global cleandata_ucad_mid "$master\Data_Management\Data\_Partner_CleanData\UCAD_Data\Midline"
	global output_ucad "$master\Data_Management\Data\_Partner_CleanData\Child_Matches\UCAD_Child_Matches\Midline_Rematches"

	global cleandata_epls_base "$master\Data_Management\Data\_Partner_CleanData\EPLS_Data\Baseline"
	global cleandata_epls_mid "$master\Data_Management\Data\_Partner_CleanData\EPLS_Data\Midline"

*<><<><><>><><<><><>>
* FILTER BASELINE DATA TO REMATCH VILLAGE
*<><<><><>><><<><><>>


/*
use "$id\All_Villages.dta", clear

rename hh_relation_with_ hh_relation_with
tostring  hh_relation_with, gen(hh_relation)

		replace hh_relation = "Head of household (himself)" if hh_relation_with == 1
		replace hh_relation = "Spouse of head ofhousehold" if hh_relation_with == 2
		replace hh_relation = "Son/daughter of the home" if hh_relation_with == 3
		replace hh_relation = "Spouse of the son/daughterof the head of the family" if hh_relation_with == 4
		replace hh_relation = "Grandson/granddaughter of the head of the family" if hh_relation_with == 5
		replace hh_relation = "Father/Mother of the HH" if hh_relation_with == 6
		replace hh_relation = "Father/Mother of the spouse of the head of the family" if hh_relation_with == 7
		replace hh_relation = "Brother/sister of the head ofthe family" if hh_relation_with == 8
		replace hh_relation = "Brother/sister of the HH's spouse" if hh_relation_with == 9
		replace hh_relation = "Adopted child" if hh_relation_with == 10
		replace hh_relation = "House help" if hh_relation_with == 11
		replace hh_relation = "Other person related to the head of the family" if hh_relation_with == 12
		replace hh_relation = "Other person not related to the head of the family" if hh_relation_with == 13


preserve 

rename hhid_village villageid

	keep if villageid == "090B"
	*keep if hh_age_ <= 18
	count if !missing(hh_age_)
	gen UCAD_age = ""
	gen UCAD_ID = ""
	gen MATCH = ""
	gen Unique = ""
	gen SCORE = ""
	gen Notes = ""
	
	keep villageid hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation hh_relation_with_o_ hhid individ UCAD_ID MATCH Unique SCORE Notes
	
	order villageid hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation hh_relation_with_o_ hhid individ UCAD_ID MATCH Unique SCORE Notes

	*export excel using "$output\Village_Ndiayene_Sare_090B.xlsx", firstrow(variables) sheet("Ndiayene Sare (090B)")  

restore 
*/




	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

*C:\Users\km978\Box\NSF Senegal\Data_Management\_Partner_CleanData\Child_Matches\EPLS_Child_Matches\Archive\Household & Individual IDs\All_Villages.dta

*<><<><><>><><<><><>>
* INITIAL CLEANING
*<><<><><>><><<><><>>

/*

	tostring hh_full_name_calc*, replace 
	tostring hh_relation_with_o*, replace 
	tostring pull_hh_individ_*, replace
	tostring pull_hh_full_name_calc__*, replace 
	tostring hh_full_name_calc_*, replace 
	
	
*<><<><><>><><<><><>>
* KEEP RELEVANT VARIABLES
*<><<><><>><><<><><>>


	keep hhid hhid_village pull_hh_individ_* ///
	hh_head_name_complet hh_name_complet_resp hh_age_resp hh_gender_resp pull_hh_full_name_calc__* hh_full_name_calc_* ///
	hh_gender* pull_hh_age__*  hh_relation_with* ///
	hh_phone hh_name_complet_resp_new replaced


*<><<><><>><><<><><>>
* KEEP RELEVANT VARIABLES
*<><<><><>><><<><><>>

	reshape long pull_hh_individ_ hh_full_name_calc_ hh_gender_ pull_hh_age__ ///
	hh_relation_with_ hh_relation_with_o_  ///
	pull_hh_full_name_calc__, ///
		i(hhid_village hhid hh_name_complet_resp_new hh_name_complet_resp hh_head_name_complet hh_age_resp hh_gender_resp hh_phone replaced) j(individual)

		rename hh_name_complet_resp hh_individ_complet_resp
		rename hhid_village villageid

	merge m:m villageid hh_individ_complet_resp using "$baseline\All_Villages_With_Individual_IDs_Selected_Vars.dta"
		drop _merge

	replace hh_name_complet_resp = hh_name_complet_resp_new if hh_individ_complet_resp == "999"
		drop hh_name_complet_resp_new 


		rename hh_relation_with_o_ other_relation
		rename hh_relation_with_ hh_relation_with
		tostring  hh_relation_with, gen(hh_relation)

		replace hh_relation = "Head of household (himself)" if hh_relation_with == 1
		replace hh_relation = "Spouse of head ofhousehold" if hh_relation_with == 2
		replace hh_relation = "Son/daughter of the home" if hh_relation_with == 3
		replace hh_relation = "Spouse of the son/daughterof the head of the family" if hh_relation_with == 4
		replace hh_relation = "Grandson/granddaughter of the head of the family" if hh_relation_with == 5
		replace hh_relation = "Father/Mother of the HH" if hh_relation_with == 6
		replace hh_relation = "Father/Mother of the spouse of the head of the family" if hh_relation_with == 7
		replace hh_relation = "Brother/sister of the head ofthe family" if hh_relation_with == 8
		replace hh_relation = "Brother/sister of the HH's spouse" if hh_relation_with == 9
		replace hh_relation = "Adopted child" if hh_relation_with == 10
		replace hh_relation = "House help" if hh_relation_with == 11
		replace hh_relation = "Other person related to the head of the family" if hh_relation_with == 12
		replace hh_relation = "Other person not related to the head of the family" if hh_relation_with == 13
		replace hh_relation = "Niece/Nephew" if hh_relation_with == 14


		drop hh_relation_with individual

		rename pull_hh_age__ hh_age

		drop if hh_age & hh_gender_  == .
			
			
			keep if villageid == "020B"
			keep if villageid == "090B" 


*/


