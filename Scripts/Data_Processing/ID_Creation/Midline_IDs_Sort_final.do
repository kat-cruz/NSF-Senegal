*==============================================================================
* Program: Midline ID sorting 
*=============================================================================

* written by: Kateri Mouawad
* Created: May 2025
* Updates recorded in GitHub


* <><<><><>> Read Me  <><<><><>>

				** This file processes: 

				**			  DISES_Midline_Complete_PII.dta
				**			  All_Villages.dta
							
				** This .do file outputs:

				**			  all_baseline_ids.dta
				** 				
**# WANT 16540
** -25
*-----------------------------------------*
**# INITIATE SCRIPT
*-----------------------------------------*

	clear all
	set mem 100m
		set maxvar 30000
		set matsize 11000
	set more off

* Set base Box path for each user
	if "`c(username)'"=="socrm" global master "C:\Users\socrm\Box\NSF Senegal"
	if "`c(username)'"=="kls329" global master "C:\Users\kls329\Box\NSF Senegal"
	if "`c(username)'"=="km978" global master "C:\Users\km978\Box\NSF Senegal"
	if "`c(username)'"=="Kateri" global master "C:\Users\Kateri\Box\NSF Senegal"
	if "`c(username)'"=="admmi" global master "C:\Users\admmi\Box\NSF Senegal"

*-----------------------------------------*
**# SET FILE PATHS
*-----------------------------------------*

*<><<><><>><><<><><>>

	global data "$master\Data_Management\Data\_CRDES_RawData\Midline\Household_Survey_Data"
	global replacement "$master\Data_Management\Data\_CRDES_RawData\Midline\Replacement_Survey_Data"
	global baselineids "$master\Data_Management\Data\_CRDES_CleanData\Baseline\Identified"
	global issues "$master\Data_Management\Output\Data_Quality_Checks\Midline\_Midline_Original_Issues_Output"
	global corrected "$master\Data_Management\Output\Data_Processing\Checks\Corrections\Midline"
	global clean "$master\Data_Management\Data\_CRDES_CleanData\Midline\Identified"
	global out_temp "C:\Users\km978\Box\My projects"
	global clean_data "$master\Data_Management\Data\_CRDES_CleanData\Midline\Identified"

*-------------------*
**### Load data
*-------------------*


	use "$clean_data\individual_ids_for_missings_in_midline_hh_roster_long.dta", clear
		
		rename hh_global_id hhid 
		rename pull_hh_full_name_calc__ hh_full_name_calc_
		rename pull_hh_age__ hh_age_
		rename pull_hh_gender__ hh_gender_ 
		rename pull_hh_individ_ individ

		
			tempfile extra_midline_IDs
				save `extra_midline_IDs'
				
*-------------------*
**### Load data
*-------------------*

	use "$clean\DISES_Midline_Complete_PII.dta", clear

*-------------------*
**### Keep relevant variables
*-------------------*



	keep consent add_new_* hhid hh_full_name_calc*  pull_hh_full_name_calc* pull_hh_individ_* still_member*  /// // keep identifiable variables for now to merge in the individual IDs
			  hh_age* hh_gender*   pull_hh_age* pull_hh_gender* hh_name_complet_resp_new
	  
				drop still_member_whynot*


*-------------------*
**### change to strings
*-------------------*

	*tostring hh_relation_with_o*, replace 
	tostring hh_full_name_calc*, replace
	tostring pull_hh_individ_*, replace
	tostring hh_full_name_calc*, replace 
	tostring pull_hh_full_name_calc*, replace 

*-------------------*
**### reshape to long
*-------------------*


	reshape long ///
		still_member_ add_new_ pull_hh_individ_ hh_full_name_calc_  pull_hh_full_name_calc__  /// // keep identifiable variables for now to merge in the individual IDs
		hh_age_ hh_gender_  hh_ethnicity_ pull_hh_gender__ pull_hh_age__, ///
			i(hh_name_complet_resp_new consent hhid) j(individual)

*-------------------*
**### drop empty rows from index
*-------------------*

	drop if (hh_full_name_calc_ == "" | hh_full_name_calc_ == ".") & hh_gender_ == . & hh_age_ == . 

	
*-------------------*
**### rename pull_hh_individ_ to individ
*-------------------*

		rename pull_hh_individ_ individ

*-------------------*
**### remove duplicates from names
*-------------------*



**			tag duplicates based on these variables which I'll be merging on 
				duplicates tag hhid hh_full_name_calc_ hh_gender_ hh_age_, generate(dup_tag)
				tab dup_tag
		
			 * keep if dup_tag != 0
				*sort hh_full_name_calc_
				
**			 drop duplicates, keeping only the first occurrence
				duplicates drop hhid hh_full_name_calc_ hh_gender_ hh_age_, force
				
					drop dup_tag
					

*-------------------*
**### remove old household IDs from merged households
*-------------------*
	
		duplicates tag individ, gen(fml)
				tab fml
					drop fml

		drop if inlist(hhid, "133A19", "133A03", "133A20", "133A02", "133A05", "133A11")


*-----------------------------------------*
**## Append baseline to midline IDs
*-----------------------------------------*		
	preserve 

		
		keep if add_new_ == 1
		
		tempfile  new_members 
			save `new_members'
			
	restore 

		
	preserve 

		
		keep if individ != ""
		
		tempfile  mindline_IDs_in_data
			save `mindline_IDs_in_data'
			
	restore 
	
	use `mindline_IDs_in_data', clear
	append using `extra_midline_IDs'
	append using `new_members'

*-----------------------------------------*
**## Case 01) Keep all midline members that already have correct IDs
*-----------------------------------------*	
/*

/* 
	gen  midline_name = hh_full_name_calc_
		gen  midline_individ = individ
*/
		
	 merge m:1 hhid individ using  "$out_temp\all_baseline_ids.dta"
	  keep still_member_ hhid add_new_ individ hh_full_name_calc_  indiv_index hh_name_complet_resp_new _merge			
			
			
	sort hhid indiv_index

	* create a temporary variable to identify maximum index per household
	by hhid: egen max_index = max(real(indiv_index))
	
	* replace missing values with appropriate new values
	* first create a counter for new individuals within each household
		
	gen new_member_count = 0 if indiv_index != ""
	by hhid: replace new_member_count = sum(_merge == 1) if _merge == 1

* generate new index values
	gen new_index = ""
	replace new_index = string(max_index + new_member_count) if indiv_index == "" & _merge == 1

	replace new_index = "0" + new_index if length(new_index) == 1 & new_index != ""

	replace indiv_index = new_index if indiv_index == "" & _merge == 1

		* generate the full individual ID by concatenating household ID and individual index
	replace individ = hhid + indiv_index if individ == ""
		*drop max_index new_member_count new_index


* gen new variable to extract the individual id for the new member respondent
	gen hh_name_complet_resp_new_individ = ""

	replace hh_name_complet_resp_new_individ = individ if hh_name_complet_resp_new == hh_full_name_calc_ 
	

* create a temp file with the household-respondent matches
	preserve
		keep if hh_full_name_calc_ == hh_name_complet_resp_new
		keep hhid individ
		rename individ hh_name_complet_resp_new_individ
		duplicates drop
		tempfile resp_ids
		save `resp_ids'
	restore

			
	* merge this information back to all household members
	merge m:1 hhid using `resp_ids', update generate(_merge2)
	drop _merge2	
			
		
	
		
	keep if new_index != ""		
	
	
		tempfile midline_new_members
			save `midline_new_members'
					
		
		

	use `mindline_IDs_in_data', clear
	append using `extra_midline_IDs'
	append using `midline_new_members'

			
			
			 
			
*/ 
			
			

				
				
/*				
	
*-------------------*
**###Bring in baseline IDs for sorting 
*-------------------*		
		
*^*^* generate name-match variable to remove duplicate names 		

	
	gen  midline_name = hh_full_name_calc_
	gen  midline_individ = individ
		
	 merge m:1 hhid individ using  "$out_temp\all_baseline_ids.dta"
	  keep still_member_ hhid add_new_ individ hh_full_name_calc_ _merge indiv_index hh_name_complet_resp_new midline_name midline_individ
	  
*-------------------*
**#### subset baseline cases
*-------------------*
	  
	 preserve 
	  
	  drop if add_new == 1
	    keep if _merge != 3
		
			tempfile baseline_IDs_to_sort
				save `baseline_IDs_to_sort'
		
	 restore 
	 
/* 
	 preserve 
	  
	  keep if add_new == 1
	    keep if _merge != 3
		
			tempfile baseline_IDs_to_sort
				save `baseline_IDs_to_sort'
		
	 restore	 
	 
*/


*-------------------*
**## Case 02) baseline memebers IN midline data, but ID WAS NOT RETAINED FOR WHATEVER REASON 
*-------------------*		
	 
	*preserve 	 
	 
		use `baseline_IDs_to_sort', clear 

		duplicates tag hhid hh_full_name_calc_, generate(killme)

		tab killme

	
		sort hh_full_name_calc_


		gen str_clean_base = lower(trim(ustrnormalize(hh_full_name_calc_, "nfc")))
		gen str_clean_mid = lower(trim(ustrnormalize(midline_name, "nfc")))

	* Generate flag for exact name match
			gen name_match = (str_clean_base == str_clean_mid)

				drop if name_match == 1

		tempfile clean_missing_baseline_IDs
			save `clean_missing_baseline_IDs'
					
	restore 		
		
		
		
*-------------------*
**## Case 03) newly added midline member, so MUST CREATE ID
*-------------------*		
		
*preserve 


	sort hhid indiv_index

	* create a temporary variable to identify maximum index per household
	by hhid: egen max_index = max(real(indiv_index))
	
	* replace missing values with appropriate new values
	* first create a counter for new individuals within each household
		
	gen new_member_count = 0 if indiv_index != ""
	by hhid: replace new_member_count = sum(_merge == 1) if _merge == 1

* generate new index values
	gen new_index = ""
	replace new_index = string(max_index + new_member_count) if indiv_index == "" & _merge == 1

	replace new_index = "0" + new_index if length(new_index) == 1 & new_index != ""

	replace indiv_index = new_index if indiv_index == "" & _merge == 1

		* generate the full individual ID by concatenating household ID and individual index
	replace individ = hhid + indiv_index if individ == ""
		*drop max_index new_member_count new_index


* gen new variable to extract the individual id for the new member respondent
	gen hh_name_complet_resp_new_individ = ""

	replace hh_name_complet_resp_new_individ = individ if hh_name_complet_resp_new == hh_full_name_calc_ 
	

* create a temp file with the household-respondent matches
	preserve
		keep if hh_full_name_calc_ == hh_name_complet_resp_new
		keep hhid individ
		rename individ hh_name_complet_resp_new_individ
		duplicates drop
		tempfile resp_ids
		save `resp_ids'
	restore

			
	* merge this information back to all household members
	merge m:1 hhid using `resp_ids', update generate(_merge2)
	drop _merge2	
			
		
	
		
	keep if new_index != ""		
	
	
		tempfile midline_new_members
			save `midline_new_members'
					
		
		
*restore 		
		
	use `clean_midline_IDs', clear
	append using `clean_missing_baseline_IDs'
	append using `midline_new_members'
		
		
		
 foreach var of varlist * { 	
    capture confirm string variable `var'
    if !_rc {
        replace `var' = subinstr(`var', "132A", "153A", .)
    }
}
			
*/
		
		
		
		
		
		
		
		
		
		
		
		
