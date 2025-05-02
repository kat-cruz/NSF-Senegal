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


*use "$data\All_Villages.dta", clear


*<><<><><>><><<><><>>
**#  CREATE HH HEAD VARIABLE
*<><<><><>><><<><><>>
 

		* Initialize hh_head variable

		*generate variables 
			gen hh_resp = 0  
			gen hh_relation_with_1 = hh_relation_with_ == 1
			
		*prepare matched_names 
			* Clean and normalize name strings
			gen str_clean_head = lower(trim(ustrnormalize(hh_head_name_complet, "nfc")))
			gen str_clean_full = lower(trim(ustrnormalize(hh_full_name_calc_, "nfc")))
			
		* Generate flag for exact name match
			gen name_match = (str_clean_head == str_clean_full)
			
			
			keep if hh_relation_with_1 != 1
		* For households where no HH_Head was reaported in hh_relation_with_, replace hh_head var = 1 if name match = 1
				bysort hhid (hhid): replace hh_relation_with_1 = 1 if hh_relation_with_ != 1 & !missing(hh_relation_with_) & name_match == 1 ///
		& sum(hh_relation_with_ == 1) == 0
			
			
			bysort hhid (hh_relation_with_): replace hh_resp = 1 if hh_relation_with_ != 1 & !missing(hh_relation_with_) & resp == 1 ///
		& sum(hh_relation_with_ == 1) == 0
		

			gen hh_head = hh_relation_with_1 + hh_resp
			
*<><<><><>><><<><><>>
**#  DETERMINE HH HEAD BY MATCHING TO hh_head_name_complet
*<><<><><>><><<><><>>
			
		* Clean and normalize name strings
			gen str_clean_head = lower(trim(ustrnormalize(hh_head_name_complet, "nfc")))
			gen str_clean_full = lower(trim(ustrnormalize(hh_full_name_calc_, "nfc")))

			* Generate flag for exact name match
			gen name_match = (str_clean_head == str_clean_full)

*<><<><><>><><<><><>>
**#  FIND MULTIPLE HH HEADS
*<><<><><>><><<><><>>

 *preserve 
			
		** find households that report more than 1 head:
		
* First, create a temporary variable for identifying multiple heads per household
gen has_relation_1 = (hh_relation_with_ == 1)
egen num_heads = total(has_relation_1), by(hhid)

* Initialize hh_head as 0
gen hh_head = 0

* If there's only one reported head, mark them
replace hh_head = 1 if hh_relation_with_ == 1 & num_heads == 1

* If there are multiple heads, assign only to the one where name matches
bysort hhid (hhid): replace hh_head = 1 if hh_relation_with_ == 1 & name_match == 1 & num_heads > 1

* Optional: drop helper variables if no longer needed
drop has_relation_1 num_heads
		
		
		
		
/*
		
		* Create indicator for relation == 1
			gen has_relation_1 = (hh_relation_with_ == 1)

			*  Count how many times relation == 1 appears per household
			egen count_relation_1 = total(has_relation_1), by(hhid)

			*  Flag households with more than one head
			gen multiple_heads = (count_relation_1 > 1)

			*  tag unique households
			egen unique_hh = tag(hhid)

			*  View/count only one row per household where there are multiple heads
			list hhid if multiple_heads == 1 & unique_hh == 1
			count if multiple_heads == 1 & unique_hh == 1

			* Clean up temporary vars 
			*drop has_relation_1 count_relation_1 unique_hh
			
			keep if multiple_heads == 1
			
			bysort hhid (hhid): replace hh_head = 1 if hh_relation_with_ == 1 & name_match == 1 & count_relation_1 > 1
			
			tempfile multiple_heads
					save `multiple_heads'
*/

	*restore 		
			
*<><<><><>><><<><><>>
**#  FIND HOUSEHOLDS WITH NO REPORTED HH HEAD IN RELATION VAR 
*<><<><><>><><<><><>>
	preserve 
  
		  ** Sanity check - 50 households did not report a head 
			gen has_relation_1 = (hh_relation_with_ == 1)  // Indicator: 1 if exists, 0 otherwise
			egen household_has_1 = max(has_relation_1), by(hhid)  // Flag households with any 1


			egen unique_hh = tag(hhid)  // Tag one row per household
			count if household_has_1 == 0 & unique_hh == 1  // Count unique households without relation == 1
			
			keep if household_has_1 == 0 & unique_hh == 1
						
			drop has_relation_1 household_has_1 unique_hh
			
			tempfile no_heads
					save `no_heads'
			
			
	restore 		

			
			
			
		use `multiple_heads'
		if name_match = 1, replace hh_head = 1
		
		

			* Generate a household-level flag for "no match found"
			*bysort hhid (name_match): gen byte no_name_match_in_hh = (_n == 1) & (sum(name_match) == 0)
				







