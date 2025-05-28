*-----------------------------------------*
* written by: Kateri Mouawad
* Created: May 2025
* Updates recorded in GitHub
*-----------------------------------------*

*<><<><><>><><<><><>>
* Read Me  <><<><><>>
*<><<><><>><><<><><>>

		*** This .do file processes:
			**						 DISES UCAD.UGB.1_VILLAGES.PARASITOLOGY DATA ALL VILLAGES.controled_1_25.06.24.xlsx
			**						 Dises year 2_fusion final_3_08042025.UCAD.UGB.xlsx

		*** This .do file outputs: (need to finish updating output)
								
			**						epls_midline_new_students_to_match.xlsx
						
								
		*** PROCEDURE:
		*		
				* 1) UPDATE 
				
*<><<><><>><><<><><>>
**# INITIATE SCRIPT
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


	global cleandata_ucad_base "$master\Data_Management\Data\_Partner_CleanData\Parasitological_Data\UCAD_Data\Baseline"
	global cleandata_ucad_mid "$master\Data_Management\Data\_Partner_CleanData\Parasitological_Data\UCAD_Data\Midline"

	global cleandata_epls_base "$master\Data_Management\Data\_Partner_CleanData\Parasitological_Data\EPLS_Data\Baseline"
	global cleandata_epls_mid "$master\Data_Management\Data\_Partner_CleanData\Parasitological_Data\EPLS_Data\Midline"
	

	global epls_out "$master\Data_Management\Data\_Partner_CleanData\Parasitological_Data\EPLS_Data\Midline\Midline_Child_Matches"

	global paras_mid "$master\Data_Management\Data\_Partner_RawData\Parasitological_Data\complete_midline_parasitology_df.dta"
	global paras_base "$master\Data_Management\Data\_Partner_RawData\Parasitological_Data\Baseline UCAD & EPLS parasitological data.xlsx"


*-----------------------------------------*
**# Merge baseline against midline to see if there's new kids 
*-----------------------------------------*


		import excel "$paras_base", sheet("Sheet1") firstrow clear 
			merge m:m identificant using "$paras_mid"  

			keep if _merge != 3
			
		** I already matched new kids from UCAD's village Geuo so we can drop that
		
			drop if hhid_village == "033A"
			
		** drop kids that left midline/baseline
		
			drop if missing(sex_hp) & missing(sex_hp) 
				
		** drop kids that left midline/baseline
		
			drop if notes == "Hors village"
		
				
		keep age_hp sex_hp identificant _merge hhid_village initiales
			order hhid_village identificant initiales age_hp sex_hp 

			 
*<><<><><>><><<><><>>
**# EPLS data 
*<><<><><>><><<><><>>

** UCAD had NO new children save for Gueo

*-----------------------------------------*
**# OUTPUT EPLS villages 
*-----------------------------------------*
		
		*export excel using "$epls_out/epls_midline_new_students_to_match.xlsx", firstrow(variables) replace

/* 
       010A |         11        6.83        6.83
       011A |         20       12.42       19.25
       012B |          3        1.86       21.12
       013A |          3        1.86       22.98
       013B |          8        4.97       27.95
       120B |         22       13.66       41.61
       121B |         24       14.91       56.52
       122A |         22       13.66       70.19
       123A |         24       14.91       85.09
       131B |         24       14.91      100.00

*/


*-------------------*
**### 010A Keur Birane Kobar 
*-------------------*

		preserve 

		  keep if hhid_village ==  "010A" 
				  export excel using "$epls_out/010A_keur_birane_kobar.xlsx", firstrow(variables) replace

		restore 
*-------------------*
**### Assy (011A)
*-------------------*

		preserve 

		  keep if hhid_village ==  "011A" 
				  export excel using "$epls_out/011A_assy.xlsx", firstrow(variables) replace

		restore 
*-------------------*
**### 012B Diaminar
*-------------------*

		preserve 

		  keep if hhid_village ==  "012B" 
				  export excel using "$epls_out/012B_diaminar", firstrow(variables) replace

		restore 

*-------------------*
**### 013A Ndelle Boye
*-------------------*

		preserve 

		  keep if hhid_village ==  "013A" 
				  export excel using "$epls_out/013A_ndelle_boye", firstrow(variables) replace

		restore 
*-------------------*
**### 013B Minguene Boye 
*-------------------*
		preserve 

		  keep if hhid_village ==  "013B" 
				  export excel using "$epls_out/013B_minguene_boye", firstrow(variables) replace

		restore 

*-------------------*
**### 120B Syer
*-------------------*

		preserve 

		  keep if hhid_village ==  "120B" 
				  export excel using "$epls_out/120B_syer", firstrow(variables) replace

		restore 

*-------------------*
**### 121B Foss
*-------------------*

		preserve 

		  keep if hhid_village ==  "121B" 
				  export excel using "$epls_out/121B_foss", firstrow(variables) replace

		restore 

*-------------------*
**### 122A Mbakhana
*-------------------*

		preserve 

		  keep if hhid_village ==  "122A" 
				  export excel using "$epls_out/122A_mbakhana", firstrow(variables) replace

		restore 

*-------------------*
**### 123A Mbarigo
*-------------------*

		preserve 

		  keep if hhid_village ==  "123A" 
				  export excel using "$epls_out/123A_mbarigo", firstrow(variables) replace

		restore 

*-------------------*
**### 131B Malla
*-------------------*

		preserve 

		  keep if hhid_village ==  "131B" 
				  export excel using "$epls_out/131B_malla", firstrow(variables) replace

		restore 

*-----------------------------------------*
**# OUTPUT CRDES villages 
*-----------------------------------------*


/* 
       010A |         11        6.83        6.83
       011A |         20       12.42       19.25
       012B |          3        1.86       21.12
       013A |          3        1.86       22.98
       013B |          8        4.97       27.95
       120B |         22       13.66       41.61
       121B |         24       14.91       56.52
       122A |         22       13.66       70.19
       123A |         24       14.91       85.09
       131B |         24       14.91      100.00

*/

use "C:\Users\km978\Box\NSF Senegal\Data_Management\Data\_CRDES_CleanData\Midline\Identified\All_Individual_IDs_Complete.dta", clear

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
		replace hh_relation = "Niece/ Nephew" if hh_relation_with == 14


preserve 

	keep if hhid_village == "010A"
	*keep if hh_age_ <= 18
	count if !missing(hh_age_)
	gen UCAD_age = ""
	gen UCAD_ID = ""
	gen MATCH = ""
	gen Unique = ""
	gen SCORE = ""
	gen Notes = ""
	
	keep hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation hh_relation_with_o_ hhid individ UCAD_ID MATCH Unique SCORE Notes
	
	order hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation hh_relation_with_o_ hhid individ UCAD_ID MATCH Unique SCORE Notes

		export excel using "$epls_out/crdes_010A_keur_birane_kobar.xlsx", firstrow(variables) replace

restore 


*-------------------*
**### 011A Assy
*-------------------*

preserve 

	keep if hhid_village == "011A"
	*keep if hh_age_ <= 18
	count if !missing(hh_age_)
	gen UCAD_age = ""
	gen UCAD_ID = ""
	gen MATCH = ""
	gen Unique = ""
	gen SCORE = ""
	gen Notes = ""
	
	keep hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation hh_relation_with_o_ hhid individ UCAD_ID MATCH Unique SCORE Notes
	
	order hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation hh_relation_with_o_ hhid individ UCAD_ID MATCH Unique SCORE Notes

		export excel using "$epls_out/crdes_011A_assy.xlsx", firstrow(variables) replace

restore 

*-------------------*
**### 012B Diaminar
*-------------------*

preserve 

	keep if hhid_village == "012B"
	*keep if hh_age_ <= 18
	count if !missing(hh_age_)
	gen UCAD_age = ""
	gen UCAD_ID = ""
	gen MATCH = ""
	gen Unique = ""
	gen SCORE = ""
	gen Notes = ""
	
	keep hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation hh_relation_with_o_ hhid individ UCAD_ID MATCH Unique SCORE Notes
	
	order hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation hh_relation_with_o_ hhid individ UCAD_ID MATCH Unique SCORE Notes

		export excel using "$epls_out/crdes_012B_diaminar", firstrow(variables) replace

restore 

*-------------------*
**### 013A Ndelle Boye
*-------------------*

preserve 

	keep if hhid_village == "013A"
	*keep if hh_age_ <= 18
	count if !missing(hh_age_)
	gen UCAD_age = ""
	gen UCAD_ID = ""
	gen MATCH = ""
	gen Unique = ""
	gen SCORE = ""
	gen Notes = ""
	
	keep hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation hh_relation_with_o_ hhid individ UCAD_ID MATCH Unique SCORE Notes
	
	order hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation hh_relation_with_o_ hhid individ UCAD_ID MATCH Unique SCORE Notes

		export excel using "$epls_out/crdes_013A_ndelle_boye", firstrow(variables) replace

restore 

*-------------------*
**### 013B Minguene Boye
*-------------------*
preserve 

	keep if hhid_village == "013B"
	*keep if hh_age_ <= 18
	count if !missing(hh_age_)
	gen UCAD_age = ""
	gen UCAD_ID = ""
	gen MATCH = ""
	gen Unique = ""
	gen SCORE = ""
	gen Notes = ""
	
	keep hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation hh_relation_with_o_ hhid individ UCAD_ID MATCH Unique SCORE Notes
	
	order hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation hh_relation_with_o_ hhid individ UCAD_ID MATCH Unique SCORE Notes

		export excel using "$epls_out/crdes_013B_minguene_boye", firstrow(variables) replace

restore 

*-------------------*
**### 120B Syer
*-------------------*

preserve 

	keep if hhid_village == "120B"
	*keep if hh_age_ <= 18
	count if !missing(hh_age_)
	gen UCAD_age = ""
	gen UCAD_ID = ""
	gen MATCH = ""
	gen Unique = ""
	gen SCORE = ""
	gen Notes = ""
	
	keep hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation hh_relation_with_o_ hhid individ UCAD_ID MATCH Unique SCORE Notes
	
	order hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation hh_relation_with_o_ hhid individ UCAD_ID MATCH Unique SCORE Notes

		export excel using "$epls_out/crdes_120B_syer", firstrow(variables) replace

restore 

*-------------------*
**### 121B Foss
*-------------------*

preserve 

	keep if hhid_village == "121B"
	*keep if hh_age_ <= 18
	count if !missing(hh_age_)
	gen UCAD_age = ""
	gen UCAD_ID = ""
	gen MATCH = ""
	gen Unique = ""
	gen SCORE = ""
	gen Notes = ""
	
	keep hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation hh_relation_with_o_ hhid individ UCAD_ID MATCH Unique SCORE Notes
	
	order hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation hh_relation_with_o_ hhid individ UCAD_ID MATCH Unique SCORE Notes

		export excel using "$epls_out/crdes_121B_foss", firstrow(variables) replace

restore 

*-------------------*
**### 122A Mbakhana
*-------------------*

preserve 

	keep if hhid_village == "122A"
	*keep if hh_age_ <= 18
	count if !missing(hh_age_)
	gen UCAD_age = ""
	gen UCAD_ID = ""
	gen MATCH = ""
	gen Unique = ""
	gen SCORE = ""
	gen Notes = ""
	
	keep hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation hh_relation_with_o_ hhid individ UCAD_ID MATCH Unique SCORE Notes
	
	order hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation hh_relation_with_o_ hhid individ UCAD_ID MATCH Unique SCORE Notes

		export excel using "$epls_out/crdes_122A_mbakhana", firstrow(variables) replace

restore 

*-------------------*
**### 123A Mbarigo
*-------------------*
preserve 

	keep if hhid_village == "123A"
	*keep if hh_age_ <= 18
	count if !missing(hh_age_)
	gen UCAD_age = ""
	gen UCAD_ID = ""
	gen MATCH = ""
	gen Unique = ""
	gen SCORE = ""
	gen Notes = ""
	
	keep hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation hh_relation_with_o_ hhid individ UCAD_ID MATCH Unique SCORE Notes
	
	order hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation hh_relation_with_o_ hhid individ UCAD_ID MATCH Unique SCORE Notes

		export excel using "$epls_out/crdes_123A_mbarigo", firstrow(variables) replace

restore 

*-------------------*
**### 131B Malla
*-------------------*

preserve 

	keep if hhid_village == "131B"
	*keep if hh_age_ <= 18
	count if !missing(hh_age_)
	gen UCAD_age = ""
	gen UCAD_ID = ""
	gen MATCH = ""
	gen Unique = ""
	gen SCORE = ""
	gen Notes = ""
	
	keep hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation hh_relation_with_o_ hhid individ UCAD_ID MATCH Unique SCORE Notes
	
	order hhid_village hh_head_name_complet hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_  UCAD_age hh_relation hh_relation_with_o_ hhid individ UCAD_ID MATCH Unique SCORE Notes

		export excel using "$epls_out/crdes_131B_malla", firstrow(variables) replace

restore 


** end of .do file **
*-----------------------------------------*

