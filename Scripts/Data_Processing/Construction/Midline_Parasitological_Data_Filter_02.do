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
	global output_ucad "$master\Data_Management\Data\_Partner_CleanData\Parasitological_Data\Child_Matches\UCAD_Child_Matches\Midline_Rematches"


	global cleandata_ucad_base "$master\Data_Management\Data\_Partner_CleanData\Parasitological_Data\UCAD_Data\Baseline"
	global cleandata_ucad_mid "$master\Data_Management\Data\_Partner_CleanData\Parasitological_Data\UCAD_Data\Midline"

	global cleandata_epls_base "$master\Data_Management\Data\_Partner_CleanData\Parasitological_Data\EPLS_Data\Baseline"
	global cleandata_epls_mid "$master\Data_Management\Data\_Partner_CleanData\Parasitological_Data\EPLS_Data\Midline"
	
	global rawdata_ucad_mid "$master\Data_Management\Data\_Partner_RawData\Parasitological_Data\UCAD_Data\Midline"
	global rawdata_ucad_base "$master\Data_Management\Data\_Partner_RawData\Parasitological_Data\UCAD_Data\Baseline"

	global rawdata_epls_mid "$master\Data_Management\Data\_Partner_RawData\Parasitological_Data\EPLS\Midline"
	global rawdata_epls_base "$master\Data_Management\Data\_Partner_RawData\Parasitological_Data\EPLS_Data\Baseline"


*^*^**^*^**^*^**^*^**^*^**^*^* Village Geuo *^*^**^*^**^*^**^*^**^*^**^*^*


	use "$cleandata_ucad_base\geuo_033A_baseline_df.dta", clear

			merge m:m identifiant using "$cleandata_ucad_mid\geuo_033A_midline_df.dta"

* keep new children

		keep if _merge != 3
		keep initiales identifiant sexe
		
		
		export excel "${output_ucad}/UCAD_IDS_Geuo_033A_Midline.xlsx", firstrow(variables) sheet("Geuo (033A)")  

*<><<><><>><><<><><>>
* FILTER CRDES MILDINE DATA 
*<><<><><>><><<><><>>


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


		
*^*^**^*^**^*^**^*^**^*^**^*^* Village Dodel *^*^**^*^**^*^**^*^**^*^**^*^*


	use "$cleandata_ucad_base\dodel_072B_baseline_df.dta", clear

			merge m:m identifiant using "$cleandata_ucad_mid\dodel_072B_midline_df.dta"

* keep new children

		keep if _merge != 3
		keep initiales identifiant sexe
		
		
		export excel "${output_ucad}/UCAD_IDS_dodel_072B_Midline.xlsx", firstrow(variables) sheet("Dodel (072B)")  

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

	export excel using "$output_ucad\CRDES_Dodel_072B_Midline.xlsx", firstrow(variables) sheet("Dodel (072B)")  

	
	
	