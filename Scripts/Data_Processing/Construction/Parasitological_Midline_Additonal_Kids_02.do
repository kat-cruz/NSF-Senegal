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


*<><<><><>><><<><><>>
**# INITIATE SCRIPT
*<><<><><>><><<><><>>
		
	clear all
	set mem 100m
	set maxvar 30000
	set matsize 11000
	set more off

*<><<><><>><><<><><>>
**# SET FILE PATHS
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
	global output_ucad "$master\Data_Management\Data\_Partner_CleanData\Parasitological_Data\Child_Matches\UCAD_Child_Matches\Midline_Rematches"


	global cleandata_ucad_base "$master\Data_Management\Data\_Partner_CleanData\Parasitological_Data\UCAD_Data\Baseline"
	global cleandata_ucad_mid "$master\Data_Management\Data\_Partner_CleanData\Parasitological_Data\UCAD_Data\Midline"

	global cleandata_epls_base "$master\Data_Management\Data\_Partner_CleanData\Parasitological_Data\EPLS_Data\Baseline"
	global cleandata_epls_mid "$master\Data_Management\Data\_Partner_CleanData\Parasitological_Data\EPLS_Data\Midline"
	
	global rawdata_ucad_mid "$master\Data_Management\Data\_Partner_RawData\Parasitological_Data\UCAD_Data\Midline"
	global rawdata_ucad_base "$master\Data_Management\Data\_Partner_RawData\Parasitological_Data\UCAD_Data\Baseline"

	global rawdata_epls_mid "$master\Data_Management\Data\_Partner_RawData\Parasitological_Data\EPLS\Midline"
	global rawdata_epls_base "$master\Data_Management\Data\_Partner_RawData\Parasitological_Data\EPLS_Data\Baseline"

**## Geuo (033A)
*^*^**^*^**^*^**^*^**^*^**^*^* Village Geuo *^*^**^*^**^*^**^*^**^*^**^*^*


	use "$cleandata_ucad_base\geuo_033A_baseline_df.dta", clear

			merge m:m identifiant using "$cleandata_ucad_mid\geuo_033A_midline_df.dta"

* keep new children

		keep if _merge == 2

	
		keep initiales identifiant sexe
		
		
		export excel "${output_ucad}/UCAD_IDS_Geuo_033A_Midline.xlsx", firstrow(variables) sheet("Geuo (033A)")  

use "$id_mid\All_Individual_IDs_Complete.dta", clear

keep if hhid_village == "033A"

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
		
		
		gen UCAD_age = ""
		gen UCAD_ID = ""
		gen MATCH = ""
		gen Unique = ""
		gen SCORE = ""
		gen Notes = ""
		
	keep hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation hhid individ UCAD_ID MATCH Unique SCORE Notes
		order  hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation  hhid individ UCAD_ID MATCH Unique SCORE Notes

	export excel using "$output_ucad\CRDES_Geuo_033A_Midline.xlsx", firstrow(variables) sheet("Geuo (033A)")  

	
	
	use "$cleandata_ucad_base\geuo_033A_baseline_df.dta", clear

			merge m:m identifiant using "$cleandata_ucad_mid\geuo_033A_midline_df.dta"

* keep new children

		keep if _merge != 3
		keep initiales identifiant sexe
		
		
		export excel "${output_ucad}/UCAD_IDS_Geuo_033A_Midline.xlsx", firstrow(variables) sheet("Geuo (033A)")  


**## Dodel (072B) (no new observations)
*^*^**^*^**^*^**^*^**^*^**^*^* Village Dodel *^*^**^*^**^*^**^*^**^*^**^*^*


	use "$cleandata_ucad_base\dodel_072B_baseline_df.dta", clear

			merge m:m identifiant using "$cleandata_ucad_mid\dodel_072B_midline_df.dta"
			

	 **  I see three kids from baseline not matching to midline. these are already recorded as kids who left the study here: dodel_072B_baseline_left_study (outputted from Parasitological_Data_Cleaning.do file)

	 
	 	* NO NEW OBSEVATIONS - COMMENTING OUT
/* 

		** keep new children
preserve 


		keep if _merge == 1
		keep initiales identifiant sexe

		
		*export excel "${output_ucad}/UCAD_IDS_dodel_072B_Midline.xlsx", firstrow(variables) sheet("Dodel (072B)")  
restore 



*^*^* bring in CRDES midline data

	use "$id_mid\All_Individual_IDs_Complete.dta", clear

keep if hhid_village == "072B"

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
		
		
		gen UCAD_age = ""
		gen UCAD_ID = ""
		gen MATCH = ""
		gen Unique = ""
		gen SCORE = ""
		gen Notes = ""
		
	keep hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation hhid individ UCAD_ID MATCH Unique SCORE Notes
		order  hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation  hhid individ UCAD_ID MATCH Unique SCORE Notes

	*export excel using "$output_ucad\CRDES_Dodel_072B_Midline.xlsx", firstrow(variables) sheet("Dodel (072B)")  
 */

**## Diabobe (030B) (no new observations)
	*^*^**^*^**^*^**^*^**^*^**^*^* Village Diabobe *^*^**^*^**^*^**^*^**^*^**^*^*


	use "$cleandata_ucad_base\diabobe_030B_baseline_df.dta", clear

			merge m:m identifiant using "$cleandata_ucad_mid\diabobe_030B_midline_df.dta"
			

* keep new children

		keep if _merge == 2
		keep initiales identifiant sexe
		
/*		
		export excel "${output_ucad}/UCAD_IDS_Diabobe_030B_Midline.xlsx", firstrow(variables) sheet("Diabobe (030B)")  

*^*^* bring in CRDES midline data

	use "$id_mid\All_Individual_IDs_Complete.dta", clear

keep if hhid_village == "030B"

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
		
		
		gen UCAD_age = ""
		gen UCAD_ID = ""
		gen MATCH = ""
		gen Unique = ""
		gen SCORE = ""
		gen Notes = ""
		
	keep hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation hhid individ UCAD_ID MATCH Unique SCORE Notes
		order  hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation  hhid individ UCAD_ID MATCH Unique SCORE Notes

	export excel using "$output_ucad\CRDES_Diabobe_030B_Midline.xlsx", firstrow(variables) sheet("Diabobe (030B)")  
*/


**## Ndiayene Pendao (020B) (no new obsevations)

	*^*^**^*^**^*^**^*^**^*^**^*^* Village Ndiayene Pendao *^*^**^*^**^*^**^*^**^*^**^*^*



	use "$cleandata_ucad_base\ndiayene_pendao_020B_baseline_df.dta", clear

			merge m:m identifiant using "$cleandata_ucad_mid\ndiayene_pendao_020B_midline_df.dta"
* keep new children

		keep if _merge == 2
		keep initiales identifiant sexe
		
	*** NO OBSERVATIONS - COMMENTING OUT THE REST
		
/*
		 
		export excel "${output_ucad}/UCAD_IDS_Ndiayene_Pendao_020B_Midline.xlsx", firstrow(variables) sheet("Ndiayene Pendao (020B)")  

*^*^* bring in CRDES midline data

	use "$id_mid\All_Individual_IDs_Complete.dta", clear

keep if hhid_village == "020B"

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
		
		
		gen UCAD_age = ""
		gen UCAD_ID = ""
		gen MATCH = ""
		gen Unique = ""
		gen SCORE = ""
		gen Notes = ""
		
	keep hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation hhid individ UCAD_ID MATCH Unique SCORE Notes
		order  hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation  hhid individ UCAD_ID MATCH Unique SCORE Notes

	export excel using "$output_ucad\CRDES_Ndiayene_Pendao_020B_Midline.xlsx", firstrow(variables) sheet("Ndiayene Pendao (020B)")  
*/
	
**## Thiangaye (021B) (no new obsevations)
	*^*^**^*^**^*^**^*^**^*^**^*^* Village Thiangaye *^*^**^*^**^*^**^*^**^*^**^*^*
	


	use "$cleandata_ucad_base\thiangaye_021B_baseline_df.dta", clear
			merge m:m identifiant using "$cleandata_ucad_mid\thiangaye_021B_midline_df.dta"
			
	 **  I see three kids from baseline not matching to midline. Append to the df that contains baseline kids NOT included in midline:
 preserve 
		keep if _merge == 1		
		* I already recorded this ID as missing in midline - drop now so I don't have it as a duplicate when I append. 
			drop in 1
			
		append using "$cleandata_ucad_mid\thiangaye_021B_midline_df_left_school.dta"
		save "$cleandata_ucad_mid\thiangaye_021B_midline_df_not_in_midline.dta", replace 
			
restore 
			
	** keep new children
	
	** 	NO OBSERVATIONS - COMMENTING OUT 
	
/* 	

		keep if _merge == 2 
		keep initiales identifiant sexe
		
		
	
		export excel "${output_ucad}/UCAD_IDS_Thiangaye_021B_Midline.xlsx", firstrow(variables) sheet("Thiangaye (021B)")  

*^*^* bring in CRDES midline data

	use "$id_mid\All_Individual_IDs_Complete.dta", clear

keep if hhid_village == "021B"

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
		
		
		gen UCAD_age = ""
		gen UCAD_ID = ""
		gen MATCH = ""
		gen Unique = ""
		gen SCORE = ""
		gen Notes = ""
		
	keep hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation hhid individ UCAD_ID MATCH Unique SCORE Notes
		order  hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation  hhid individ UCAD_ID MATCH Unique SCORE Notes

	export excel using "$output_ucad\CRDES_Thiangaye_021B_Midline.xlsx", firstrow(variables) sheet("Thiangaye (021B)")	
	
*/

**## Fanaye Diery (062B) (no new observations)
	*^*^**^*^**^*^**^*^**^*^**^*^* Village Fanaye Diery *^*^**^*^**^*^**^*^**^*^**^*^*
	


	use "$cleandata_ucad_base\fanaye_diery_062B_baseline_df.dta", clear
			merge m:m identifiant using "$cleandata_ucad_mid\fanaye_diery_062B_midline_df.dta"
			
	  **  I see six kids from baseline not matching to midline. these are already recorded as kids who left the study here: fanaye_diery_062B_baseline_left_school.dta (outputted from Parasitological_Data_Cleaning.do file)
	
	
	** 	NO OBSERVATIONS - COMMENTING OUT 
	
/* 		
			
	** keep new children

		keep if _merge == 2 
		keep initiales identifiant sexe
		
	
		export excel "${output_ucad}/UCAD_IDS_Thiangaye_021B_Midline.xlsx", firstrow(variables) sheet("Thiangaye (021B)")  

*^*^* bring in CRDES midline data

	use "$id_mid\All_Individual_IDs_Complete.dta", clear

keep if hhid_village == "021B"

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
		
		
		gen UCAD_age = ""
		gen UCAD_ID = ""
		gen MATCH = ""
		gen Unique = ""
		gen SCORE = ""
		gen Notes = ""
		
	keep hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation hhid individ UCAD_ID MATCH Unique SCORE Notes
		order  hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation  hhid individ UCAD_ID MATCH Unique SCORE Notes

	export excel using "$output_ucad\CRDES_Thiangaye_021B_Midline.xlsx", firstrow(variables) sheet("Thiangaye (021B)")	
	
*/


**## Saneinte (031B) (no new observations)
	*^*^**^*^**^*^**^*^**^*^**^*^* Village Saneinte *^*^**^*^**^*^**^*^**^*^**^*^*
	


	use "$cleandata_ucad_base\saneinte_031B_baseline_df.dta", clear
			merge m:m identifiant using "$cleandata_ucad_mid\saneinte_031B_midline_df.dta"
			
	  **  I see 1 kid from baseline not matching to midline. these are already recorded as kids who left the study here: saneinte_031B_baseline_midline_left_school.dta (outputted from Parasitological_Data_Cleaning.do file)
	
	
		** 	NO OBSERVATIONS - COMMENTING OUT 
	
/* 		
			
	** keep new children

		keep if _merge == 2 
		keep initiales identifiant sexe
		
	
		export excel "${output_ucad}/UCAD_IDS_Saneinte_031B_Midline.xlsx", firstrow(variables) sheet("Saneinte (031B)")  

*^*^* bring in CRDES midline data

	use "$id_mid\All_Individual_IDs_Complete.dta", clear

keep if hhid_village == "031B"

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
		
		
		gen UCAD_age = ""
		gen UCAD_ID = ""
		gen MATCH = ""
		gen Unique = ""
		gen SCORE = ""
		gen Notes = ""
		
	keep hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation hhid individ UCAD_ID MATCH Unique SCORE Notes
		order  hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation  hhid individ UCAD_ID MATCH Unique SCORE Notes

	export excel using "$output_ucad\CRDES_Saneinte_031B_Midline.xlsx", firstrow(variables) sheet("Saneinte (031B)")	
	
*/


**##   Yetti Yone (033B) (no new observations)
*^*^**^*^**^*^**^*^**^*^**^*^* Village Yetti Yone *^*^**^*^**^*^**^*^**^*^**^*^*

	
	use "$cleandata_ucad_base\yetti_yone_033B_baseline_df.dta", clear
			merge m:m identifiant using "$cleandata_ucad_mid\yetti_yone_033B_midline_df.dta"
			
	  **  I see 1 kid from baseline not matching to midline. these are already recorded as kids who left the study here: yetti_yone_033B_midline_left_school.dta (outputted from Parasitological_Data_Cleaning.do file)
	
	
		** 	NO OBSERVATIONS - COMMENTING OUT 
	
/* 		
			
	** keep new children

		keep if _merge == 2 
		keep initiales identifiant sexe
		
	
		export excel "${output_ucad}/UCAD_IDS_Yetti_Yone_033B_Midline.xlsx", firstrow(variables) sheet("Yetti Yone (033B)")  

*^*^* bring in CRDES midline data

	use "$id_mid\All_Individual_IDs_Complete.dta", clear

keep if hhid_village == "033B"

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
		
		
		gen UCAD_age = ""
		gen UCAD_ID = ""
		gen MATCH = ""
		gen Unique = ""
		gen SCORE = ""
		gen Notes = ""
		
	keep hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation hhid individ UCAD_ID MATCH Unique SCORE Notes
		order  hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation  hhid individ UCAD_ID MATCH Unique SCORE Notes

	export excel using "$output_ucad\CRDES_Yetti_Yone_033B_Midline.xlsx", firstrow(variables) sheet("Yetti Yone (033B)")	
	
*/


**##   Yamane (130A) (no new observations)
*^*^**^*^**^*^**^*^**^*^**^*^* Village Yamane *^*^**^*^**^*^**^*^**^*^**^*^*

	
	use "$cleandata_ucad_base\yamane_130A_baseline_df.dta", clear
			merge m:m identifiant using "$cleandata_ucad_mid\yamane_130A_midline_df.dta"
			
	  **  I see 5 kids from baseline not matching to midline. these are already recorded as kids who left the study here: yamane_130A_midline_left_school.dta (outputted from Parasitological_Data_Cleaning.do file)
	
	
		** 	NO OBSERVATIONS - COMMENTING OUT 
	
/* 		
			
	** keep new children

		keep if _merge == 2 
		keep initiales identifiant sexe
		
	
		export excel "${output_ucad}/UCAD_IDS_Yamane_130A_Midline.xlsx", firstrow(variables) sheet("Yamane (130A)")  

*^*^* bring in CRDES midline data

	use "$id_mid\All_Individual_IDs_Complete.dta", clear

keep if hhid_village == "130A"

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
		
		
		gen UCAD_age = ""
		gen UCAD_ID = ""
		gen MATCH = ""
		gen Unique = ""
		gen SCORE = ""
		gen Notes = ""
		
	keep hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation hhid individ UCAD_ID MATCH Unique SCORE Notes
		order  hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation  hhid individ UCAD_ID MATCH Unique SCORE Notes

	export excel using "$output_ucad\CRDES_Yamane_130A_Midline.xlsx", firstrow(variables) sheet("Yamane (130A)")	
	
*/


**## Diaminar Loyene (130A)
*^*^**^*^**^*^**^*^**^*^**^*^* Village Diaminar Loyene *^*^**^*^**^*^**^*^**^*^**^*^*

	
	use "$cleandata_ucad_base\diaminar_loyene_130A_baseline_df", clear
			merge m:m identifiant using "$cleandata_ucad_mid\diaminar_loyene_130A_midline_df"
			
	  **  I see 5 kids from baseline not matching to midline. these are already recorded as kids who left the study here: yamane_130A_midline_left_school.dta (outputted from Parasitological_Data_Cleaning.do file)
	
	
		** 	NO OBSERVATIONS - COMMENTING OUT 
	
/* 		
			
	** keep new children

		keep if _merge == 2 
		keep initiales identifiant sexe
		
	
		export excel "${output_ucad}/UCAD_IDS_Diaminar_Loyene_130A_Midline.xlsx", firstrow(variables) sheet("Diaminar Loyene (130A)")  

*^*^* bring in CRDES midline data

	use "$id_mid\All_Individual_IDs_Complete.dta", clear

keep if hhid_village == "130A"

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
		
		
		gen UCAD_age = ""
		gen UCAD_ID = ""
		gen MATCH = ""
		gen Unique = ""
		gen SCORE = ""
		gen Notes = ""
		
	keep hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation hhid individ UCAD_ID MATCH Unique SCORE Notes
		order  hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation  hhid individ UCAD_ID MATCH Unique SCORE Notes

	export excel using "$output_ucad\CRDES_Diaminar_Loyene_130A_Midline.xlsx", firstrow(variables) sheet("Diaminar Loyene (130A)")	
	
*/





	
**##   Kassack Nord (030A)
*^*^**^*^**^*^**^*^**^*^**^*^* Baseline Village Kassack Nord *^*^**^*^**^*^**^*^**^*^**^*^*



	
	use "$cleandata_ucad_base\kassack_nord_030A_baseline_df", clear
			merge m:m identifiant using "$cleandata_ucad_mid\kassack_nord_030A_midline_df"
			
	  **  I see 5 kids from baseline not matching to midline. these are already recorded as kids who left the study here: yamane_130A_midline_left_school.dta (outputted from Parasitological_Data_Cleaning.do file)
	
	
		** 	NO OBSERVATIONS - COMMENTING OUT 
	
/* 		
			
	** keep new children

		keep if _merge == 2 
		keep initiales identifiant sexe
		
	
		export excel "${output_ucad}/UCAD_IDS_Kassack_Nord_030A_Midline.xlsx", firstrow(variables) sheet("Kassack Nord (030A)")  

*^*^* bring in CRDES midline data

	use "$id_mid\All_Individual_IDs_Complete.dta", clear

keep if hhid_village == "130A"

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
		
		
		gen UCAD_age = ""
		gen UCAD_ID = ""
		gen MATCH = ""
		gen Unique = ""
		gen SCORE = ""
		gen Notes = ""
		
	keep hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation hhid individ UCAD_ID MATCH Unique SCORE Notes
		order  hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation  hhid individ UCAD_ID MATCH Unique SCORE Notes

	export excel using "$output_ucad\CRDES_Kassack_Nord_030A_Midline.xlsx", firstrow(variables) sheet(Kassack Nord (030A))	
	
*/




**##   Ndiamar (Souloul) (020A)
*^*^**^*^**^*^**^*^**^*^**^*^*  Village Ndiamar *^*^**^*^**^*^**^*^**^*^**^*^*


	use "$cleandata_ucad_base\ndiamar_020A_baseline_df", clear
			merge m:m identifiant using "$cleandata_ucad_mid\ndiamar_020A_midline_df"
			
	  **  I see 5 kid from baseline not matching to midline. these are already recorded as kids who left the study here: ndiamar_020A_midline_left_school.dta (outputted from Parasitological_Data_Cleaning.do file)
	
	
		** 	NO OBSERVATIONS - COMMENTING OUT 
	
/* 		
			
	** keep new children

		keep if _merge == 2 
		keep initiales identifiant sexe
		
	
		export excel "${output_ucad}/UCAD_IDS_Ndiamar_020A_Midline.xlsx", firstrow(variables) sheet("Ndiamar (Souloul) (020A)")  

*^*^* bring in CRDES midline data

	use "$id_mid\All_Individual_IDs_Complete.dta", clear

keep if hhid_village == "130A"

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
		
		
		gen UCAD_age = ""
		gen UCAD_ID = ""
		gen MATCH = ""
		gen Unique = ""
		gen SCORE = ""
		gen Notes = ""
		
	keep hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation hhid individ UCAD_ID MATCH Unique SCORE Notes
		order  hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation  hhid individ UCAD_ID MATCH Unique SCORE Notes

	export excel using "$output_ucad\CRDES_Ndiamar_020A_Midline.xlsx", firstrow(variables) sheet(Ndiamar (Souloul) (020A))	
	
*/



**## El Debiyaye Maraye II (021A) (Maraye)
*^*^**^*^**^*^**^*^**^*^**^*^* Baseline Village El Debiyaye Maraye II  *^*^**^*^**^*^**^*^**^*^**^*^*


	use "$cleandata_ucad_base\el_debiyaye_maraye_021A_baseline_dff", clear
			merge m:m identifiant using "$cleandata_ucad_mid\el_debiyaye_maraye_021A_midline_df"
			
	  **  I see 5 kid from baseline not matching to midline. these are already recorded as kids who left the study here: el_debiyaye_maraye_021A_midline_left_school.dta (outputted from Parasitological_Data_Cleaning.do file)
	
	
		** 	NO OBSERVATIONS - COMMENTING OUT 
	
/* 		
			
	** keep new children

		keep if _merge == 2 
		keep initiales identifiant sexe
		
	
		export excel "${output_ucad}/UCAD_IDS_El_Debiyaye_Maraye_II_021A_Midline.xlsx", firstrow(variables) sheet("El Debiyaye Maraye II (021A) (Maraye)")  

*^*^* bring in CRDES midline data

	use "$id_mid\All_Individual_IDs_Complete.dta", clear

keep if hhid_village == "021A"

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
		
		
		gen UCAD_age = ""
		gen UCAD_ID = ""
		gen MATCH = ""
		gen Unique = ""
		gen SCORE = ""
		gen Notes = ""
		
	keep hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation hhid individ UCAD_ID MATCH Unique SCORE Notes
		order  hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation  hhid individ UCAD_ID MATCH Unique SCORE Notes

	export excel using "$output_ucad\CRDES_El_Debiyaye_Maraye_II_021A_Midline.xlsx", firstrow(variables) sheet(El Debiyaye Maraye II (021A) (Maraye))	
	
*/

	
**## Dioss Peulh (032A) (no new observations)
*^*^**^*^**^*^**^*^**^*^**^*^*  Village Dioss Peulh *^*^**^*^**^*^**^*^**^*^**^*^*


	use "$cleandata_ucad_base\dioss_Peulh_032A_baseline_df", clear
			merge m:m identifiant using "$cleandata_ucad_mid\dioss_peulh_032A_midline_df"
			
	  **  I see 3 kid from baseline not matching to midline. these are already recorded as kids who left the study here: dioss_peulh_032A_midline_left_school.dta (outputted from Parasitological_Data_Cleaning.do file)
	
	
		** 	NO OBSERVATIONS - COMMENTING OUT 
	
/* 		
			
	** keep new children

		keep if _merge == 2 
		keep initiales identifiant sexe
		
	
		export excel "${output_ucad}/UCAD_IDS_Dioss_Peulh_032A_Midline.xlsx", firstrow(variables) sheet("Dioss Peulh (032A)")  

*^*^* bring in CRDES midline data

	use "$id_mid\All_Individual_IDs_Complete.dta", clear

keep if hhid_village == "032A"

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
		
		
		gen UCAD_age = ""
		gen UCAD_ID = ""
		gen MATCH = ""
		gen Unique = ""
		gen SCORE = ""
		gen Notes = ""
		
	keep hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation hhid individ UCAD_ID MATCH Unique SCORE Notes
		order  hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation  hhid individ UCAD_ID MATCH Unique SCORE Notes

	export excel using "$output_ucad\CRDES_Dioss_Peulh_032A_Midline.xlsx", firstrow(variables) sheet(Dioss Peulh (032A))	
	
*/



**## Mberaye (023B) (no new observations)
*^*^**^*^**^*^**^*^**^*^**^*^* Baseline Village Mberaye *^*^**^*^**^*^**^*^**^*^**^*^*


	use "$cleandata_ucad_base\mberaye_023B_baseline_df", clear
			merge m:m identifiant using "$cleandata_ucad_mid\mberaye_023B_midline_df"
			
	  **  I see 3 kid from baseline not matching to midline. these are already recorded as kids who left the study here: mberaye_023B_midline_left_school.dta (outputted from Parasitological_Data_Cleaning.do file)
	
	
		** 	NO OBSERVATIONS - COMMENTING OUT 
	
/* 		
			
	** keep new children

		keep if _merge == 2 
		keep initiales identifiant sexe
		
	
		export excel "${output_ucad}/UCAD_IDS_Mberaye_023B_Midline.xlsx", firstrow(variables) sheet("Mberaye (023B)")  

*^*^* bring in CRDES midline data

	use "$id_mid\All_Individual_IDs_Complete.dta", clear

keep if hhid_village == "023B"

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
		
		
		gen UCAD_age = ""
		gen UCAD_ID = ""
		gen MATCH = ""
		gen Unique = ""
		gen SCORE = ""
		gen Notes = ""
		
	keep hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation hhid individ UCAD_ID MATCH Unique SCORE Notes
		order  hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation  hhid individ UCAD_ID MATCH Unique SCORE Notes

	export excel using "$output_ucad\CRDES_Mberaye_023B_Midline.xlsx", firstrow(variables) sheet(Mberaye (023B)
*/














