*==============================================================================
* Program: HH Head sorting 
* =============================================================================
* written by: Kateri Mouawad
* additions made by: Kateri Mouawad
* Created: April 2025
* Updates recorded in GitHub 

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

*** additional file paths ***
	global data "$master\Data_Management\Output\Data_Processing\ID_Creation\Baseline\Individual_IDs_For_EPLS_UCAD_Matching"
	global index "$master\Data_Management\Output\Data_Processing\ID_Creation\Baseline"

	import excel "$index\Identify_Respondent_HH_Index.xlsx", sheet("Sheet1") firstrow clear


*<><<><><>><><<><><>>
**#  CREATE HH HEAD VARIABLE
*<><<><><>><><<><><>>
		
		*prepare matched_names 
			* Clean and normalize name strings
		gen str_clean_head = lower(trim(ustrnormalize(hh_head_name_complet, "nfc")))
		gen str_clean_full = lower(trim(ustrnormalize(hh_full_name_calc_, "nfc")))
			
	* Generate flag for exact name match
		gen name_match = (str_clean_head == str_clean_full)
			
				
		*  Initialize hh_head
		gen hh_head = (hh_relation_with_ == 1)
		
		* create flag variables
		
		egen num_heads_per_hh = total(hh_head), by(hhid)
		

		keep hh_relation_with_ hh_age_ hhid individ resp str_clean_head str_clean_full name_match hh_head num_heads_per_hh
		
					
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
				
		egen num_heads_per_hh_3 = total(hh_head == 1), by(hhid)
		keep if num_heads_per_hh_3 == 0
		drop num_heads_per_hh_3
				
			
*<><<><><>><><<><><>>
**#  **Mannually correct for where name didn't match but is close 
*<><<><><>><><<><><>>
		
	 	
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		/*
		
		keep hh_relation_with_ hhid individ resp str_clean_head str_clean_full name_match hh_head num_heads_per_hh

		
		keep if num_heads_per_hh == 2 | num_heads_per_hh == 3
		
		replace hh_head = 0 if name_match == 0 & num_heads_per_hh > 1
*/

		
/* 
		egen one_row_per_hh = tag(hhid)
		gen multiple_heads_flag = (num_heads_per_hh > 1) if one_row_per_hh
		
*/
/*
		
		egen has_hh_head = max(hh_head), by(hhid)
		gen hh_head_missing = (has_hh_head == 0)
		
		* Count how many times hh_head_missing == 1 per household
			bysort hhid (hhid): gen hh_head_missing_count = sum(hh_head_missing == 1)

			* Then keep only one row per household to view the count
			egen tag = tag(hhid)
			list hhid hh_head_missing_count if tag == 1
			drop tag
						
				replace hh_head = 1 if hh_head_missing == 1 & name_match == 1
				
		egen has_hh_head2 = max(hh_head), by(hhid)
		gen hh_head_missing2 = (has_hh_head2 == 0)

		gen multiple_heads_flag = (num_heads_per_hh > 1)
	
		
		
		keep if multiple_heads_flag == 1 | hh_head_missing2
		
		
*/
		
		
		
		
		

		