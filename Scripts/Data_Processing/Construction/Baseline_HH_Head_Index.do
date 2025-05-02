*==============================================================================
* Program: HH Head index creation  
* =============================================================================
* written by: Kateri Mouawad
* additions made by: Kateri Mouawad
* Created: April 2025
* Updates recorded in GitHub 

*<><<><><>><><<><><>>
* READ ME
*<><<><><>><><<><><>>

	*** This Do File PROCESSES: 
	***						 Identify_Respondent_HH_Index.xlsx
                            
	*** This Do File CREATES: 
	***                      household_head_index.dta
	
	
	*** Procedure: 
	
	*** 1) bring in Identify_Respondent_HH_Index.xlsx
	*** 2) generate name_match which indicates if the housheold head name is inside the household roster 
	*** 3) generate household head indicator (hh_head) based on hh_relation
		*** 3.1) update hh_head variable by removing 2+ household heads per household based on the name listed in hh_name_complet_resp
		*** 3.2) update hh_head variable by replacing hh_head = 1 if name_match = 1 but no household head was listed in hh_relation
		*** 3.3) Mannually update hh_head if there were no name matches or nobody was identified as the hh head from hh_relation 
			*** 3.3.1) use respondent if hh head was missing all together
			*** 3.3.2) use eldest male in household if respondent and hh head are both missing 
	*** 4) rename individ hh_head_index and keep hhid
	*** 5) save the .dta
	
	*** Note on mannual matches: followed household head matching protocol to determine matches
	
*<><<><><>><><<><><>>
**#  INITIATE SCRIPT
*<><<><><>><><<><><>>
	
	clear all
		set mem 100m
		set maxvar 30000
	set matsize 11000
	set more off


**check list of villge IDs and hhids to spot non-updated ID

*<><<><><>><><<><><>>
**#  SET FILE PATHS
*<><<><><>><><<><><>>

*^*^* Set base Box path for each user
	if "`c(username)'"=="socrm" global master "C:\Users\socrm\Box\NSF Senegal"
	if "`c(username)'"=="kls329" global master "C:\Users\kls329\Box\NSF Senegal"
	if "`c(username)'"=="km978" global master "C:\Users\km978\Box\NSF Senegal"
	if "`c(username)'"=="Kateri" global master "C:\Users\Kateri\Box\NSF Senegal"
	if "`c(username)'"=="admmi" global master "C:\Users\admmi\Box\NSF Senegal"

*^*^* additional file paths 

	global data "$master\Data_Management\Output\Data_Processing\ID_Creation\Baseline\Individual_IDs_For_EPLS_UCAD_Matching"
	global index "$master\Data_Management\Output\Data_Processing\ID_Creation\Baseline"
	global data_deidentified "$master\Data_Management\Data\_CRDES_CleanData\Baseline\Deidentified"

*^*^* import data

		import excel "$index\Identify_Respondent_HH_Index.xlsx", sheet("Sheet1") firstrow clear


*<><<><><>><><<><><>>
**#  CREATE HH HEAD VARIABLE
*<><<><><>><><<><><>>
		
		*prepare matched_names 
			* Clean and normalize name strings
		gen str_clean_head = lower(trim(ustrnormalize(hh_head_name_complet, "nfc")))
		gen str_clean_full = lower(trim(ustrnormalize(hh_full_name_calc_, "nfc")))
		gen str_clean_full_resp = lower(trim(ustrnormalize(hh_name_complet_resp, "nfc")))	
		
	* Generate flag for exact name match
		gen name_match = (str_clean_head == str_clean_full)
			
				
		*  Initialize hh_head
		gen hh_head = (hh_relation_with_ == 1)
		
		* create flag variables
		
		egen num_heads_per_hh = total(hh_head), by(hhid)
		
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


/*
		keep hh_relation hh_relation_with str_clean_full_resp hh_age_ hh_gender_ hhid individ resp str_clean_head str_clean_full name_match hh_head num_heads_per_hh
		order hhid individ resp hh_relation hh_relation_with hh_age_ hh_gender_ str_clean_full_resp str_clean_head str_clean_full name_match hh_head num_heads_per_hh
*/
					
*<><<><><>><><<><><>>
**#  CORRECT IF THERE ARE 2+ HH HEADS REPORTED IN RELATION VAR
*<><<><><>><><<><><>>

		*** correct for <1 housheold head
		replace hh_head = 0 if name_match == 0 & num_heads_per_hh > 1
		*** see what's left
		egen num_heads_per_hh_2 = total(hh_head), by(hhid)
		*** that worked
		
		
*<><<><><>><><<><><>>
**#  CORRECT IF THERE ARE NO HOUSEHOLD HEADS
*<><<><><>><><<><><>>
		
		replace hh_head = 1 if name_match == 1 & num_heads_per_hh < 1
		
			
*<><<><><>><><<><><>>
**#  CHECK TO SEE WHATS LEFT
*<><<><><>><><<><><>>

preserve 
				
		egen num_heads_per_hh_3 = total(hh_head == 1), by(hhid)
		keep if num_heads_per_hh_3 == 0
		drop num_heads_per_hh_3
				
restore 

*<><<><><>><><<><><>>
**#  **Mannually correct for where name didn't match 
*<><<><><>><><<><><>>
			
		** found name			
		replace hh_head = 1 if individ == "023A1201"
		** no name match, replace with respondent 
		replace hh_head = 1 if individ == "023B1801"		
		** no name match, replace with respondent 
		replace hh_head = 1 if individ == "032B0201"
		** no name match, replace with respondent 
		replace hh_head = 1 if individ == "041A0801"
		** keep true household head here. Didn't work first round as there was no name 
		replace hh_head = 1 if individ == "061A0704"
		** no name match, replace with respondent 
		replace hh_head = 1 if individ == "070B0701"
		** keep true household head here. Didn't work first round as there was no name 
		replace hh_head = 1 if individ == "073B1921"
		** no name match, replace with respondent 		
		replace hh_head = 1 if individ == "081B2001"	
		** found name		
		replace hh_head = 1 if individ == "081B1801"
		** can't find respondent/hh head for 081B04, take elsdest male 
		replace hh_head = 1 if individ == "081B0401"
		** can't find respondent/hh head for 081B04, take elsdest male 
		replace hh_head = 1 if individ == "101B1103"
		** found name		
		replace hh_head = 1 if individ == "113B1401"
		** found first name		
		replace hh_head = 1 if individ == "113B0701"	
		** found name		
		replace hh_head = 1 if individ == "132A1501"	
		** no name match, replace with respondent 
		replace hh_head = 1 if individ == "132B1401"
		** no name match, replace with respondent 
		replace hh_head = 1 if individ == "133A1601"	
		** no name match, replace with respondent. Respondent name isn't certain either tbh
		replace hh_head = 1 if individ == "143A1001"	
		** no name match, replace with respondent 
		replace hh_head = 1 if individ == "040A1401"
		** no name match, replace with respondent 
		replace hh_head = 1 if individ == "041A1903"
	** no name match, replace with respondent 
		replace hh_head = 1 if individ == "071B1501"
	** no name match, replace with respondent 
		replace hh_head = 1 if individ == "081B0901"

		
		
*<><<><><>><><<><><>>
**#  CHECK TO SEE WHATS LEFT
*<><<><><>><><<><><>>

preserve
		
		egen num_heads_per_hh_4 = total(hh_head == 1), by(hhid)
		keep if num_heads_per_hh_4 == 0
		drop num_heads_per_hh_4

		** all (17,202) observations were deleted, so it looks like it worked. 
		
restore
		
*<><<><><>><><<><><>>
**#  SELECT VARIABLES AND SAVE FILE 
*<><<><><>><><<><><>>

		keep if hh_head == 1
*^*^* rename the inedex var for clarity 
		

		rename individual hh_head_index 	
		
*^*^* keep only household id and respondent index variable *** 
		
		keep hhid hh_head_index 

*^*^* save final data set.

		save "$data_deidentified\household_head_index.dta", replace 		
	
	

	
	
*^*^* end of .do file
		