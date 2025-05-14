*==============================================================================
* Program: HH Head index creation  
* =============================================================================
* written by: Kateri Mouawad
* additions made by: Kateri Mouawad
* Created: April 2025
* Updates recorded in GitHub 

*-----------------------------------------*
*<><<><><>><><<><><>>
* READ ME
*<><<><><>><><<><><>>
*-----------------------------------------*

	*** This Do File PROCESSES: 
	***						 Identify_Respondent_HH_Index.xlsx
	***						 baseline_household_long.dta
                            
	*** This Do File CREATES: 
	***                      household_head_index.dta
	
	
	*** Procedure: NEED TO UPDATE 
	
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
	
*-----------------------------------------*
**#  INITIATE SCRIPT
*-----------------------------------------*
	
	clear all
		set mem 100m
		set maxvar 30000
	set matsize 11000
	set more off


**check list of villge IDs and hhids to spot non-updated ID

*-----------------------------------------*
**#  SET FILE PATHS
*-----------------------------------------*

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
	global long_data "$master\Data_Management\Output\Data_Processing\Construction"
	
*^*^* import long data	
	
	use "$long_data\baseline_household_long.dta", clear 
	
	keep hhid individ hh_main_activity_ hh_active_agri_ hh_03_ hh_08_ hh_09_
	
	gen work = .
	replace work = 1 if (hh_active_agri_ > 0 | hh_03_ > 0 | hh_08_ > 0 | hh_09_ > 0) ///
		& !missing(hh_active_agri_) & !missing(hh_03_) & !missing(hh_08_) & !missing(hh_09_)

	replace work = 0 if hh_active_agri_ <= 0 & hh_03_ <= 0 & hh_08_ <= 0 & hh_09_ <= 0 ///
		& !missing(hh_active_agri_) & !missing(hh_03_) & !missing(hh_08_) & !missing(hh_09_)

	tempfile work_vars
	save `work_vars'

*^*^* import data

		import excel "$index\Identify_Respondent_HH_Index.xlsx", sheet("Sheet1") firstrow clear
		merge 1:1 individ using `work_vars'
		
		keep if _merge == 3
		
		 ** keep relevant variables 
		keep hhid individ individual resp hh_relation_with_ hh_head_name_complet hh_full_name_calc_ hh_name_complet_resp hh_age_ hh_gender_ work 
			order hhid individ individual resp hh_relation_with_ hh_head_name_complet hh_full_name_calc_ hh_name_complet_resp hh_age_ hh_gender_ work 

*-----------------------------------------*
**#  CREATE relevant variables 
*-----------------------------------------*
		
		* prepare matched_names 
			* Clean and normalize name strings
		gen str_clean_head = lower(trim(ustrnormalize(hh_head_name_complet, "nfc")))
		gen str_clean_full = lower(trim(ustrnormalize(hh_full_name_calc_, "nfc")))
		gen str_clean_full_resp = lower(trim(ustrnormalize(hh_name_complet_resp, "nfc")))	
		
		* Generate flag for exact name match
		gen name_match = (str_clean_head == str_clean_full)

		
		
*-----------------------------------------*
*<><<><><>><><<><><>>
**#  HH Head Index Protocol: 
*<><<><><>><><<><><>>
*-----------------------------------------*
		
*-----------------------------------------*
**##  1.	Primary Rule
**		a.	Assign household head indicator = 1 if hh_relation == 1 (self-reported household head).
*-----------------------------------------*	
		
		gen hh_head = (hh_relation_with_ == 1)
		
*-----------------------------------------*
**##  2.	Multiple Household Heads
*-----------------------------------------*		
		
		*** gen amount of hh heads per hh
		egen num_heads_per_hh = total(hh_head), by(hhid)
		
	
*^*^*	a.	Use hh_head_name_complet and age > 18 to identify the correct head via name matching with hh roster names (hh_full_name_calc_). *^*^*
		
preserve 

*** keep if multiple heads are present - deal with no hh heads later 		
		keep if num_heads_per_hh > 1
*** check if name_match has a head < 18
		gen child_head = 1 if name_match == 1 & hh_age_ < 18
		tab child_head
		*** no observations - procced as planned 
*** replace with matched name
		replace hh_head = 0 if (name_match == 0 & hh_head == 1)
*** 		see what's left
		egen num_heads_per_hh_2 = total(hh_head), by(hhid)
		tab num_heads_per_hh_2
*** need to filter cleaned data 	
		count // 174
		
		tempfile multiple_heads_firstpass
			save `multiple_heads_firstpass'
		
		keep if num_heads_per_hh_2 == 1
		
		count // 138
		
		tempfile multiple_heads_cleaned1
			save `multiple_heads_cleaned1'

			
restore 


*^*^*   b.	If no matched name is available, select oldest working male as head   *^*^*

preserve 

use `multiple_heads_firstpass', clear

	keep if num_heads_per_hh_2 == 0
	
	
***  	identify candidate heads: working males 18+ in households missing a head
			gen candidate = 0
				replace candidate = 1 if hh_gender_ == 1 & work == 1 & hh_age_ >= 18

***  	create sort key — candidates first, eldest among them first
			gen sortkey = -1000 * candidate - hh_age_

*** 	sort so each household has candidates first, then by descending age
			sort hhid sortkey

***  	select the first candidate in each household
			gen select_head = 0
			by hhid: replace select_head = 1 if candidate == 1 & _n == 1

***  	assign that person as household head
			by hhid: replace hh_head = 1 if select_head == 1

			drop  select_head candidate sortkey
		
		count // 36

				tempfile multiple_heads_cleaned2
					save `multiple_heads_cleaned2'

restore 


*-----------------------------------------*
**##  3.	No Household Head Identified
*-----------------------------------------*		
		
*^*^* a.	If name in hh_head_name_complet matches someone in hh_full_name_calc_ and hh_age_ >= 18, assign that person as head	  *^*^*

preserve 
	
	keep if num_heads_per_hh < 1
	
*** 		a.	If name in hh_head_name_complet matches someone in hh_full_name_calc_ and hh_age_ >= 18, assign that person as head. (example 3.a)
*** 		check if name_match has a head < 18
				gen child_head = 1 if name_match == 1 & hh_age_ < 18
					tab child_head
*** 		no issues - proceed as planned 

	replace hh_head = 1 if name_match == 1 & hh_age_ > 18
***         check at what was not corrected	
			egen num_heads_per_hh_2 = total(hh_head), by(hhid)
				tab num_heads_per_hh_2
				
				drop child_head num_heads_per_hh_2
				
		count // 392
		
		tempfile no_hh_firstpass
			save `no_hh_firstpass'
			
		egen has_head = max(hh_head), by(hhid)
			tab has_head
		
				keep if has_head == 1
				
		tempfile no_hh_cleaned1
			save `no_hh_cleaned1'
			

		
	restore 
	
				
*^*^* 	b.	If no name match, assign the eldest working male.  *^*^*


preserve 

use `no_hh_firstpass', clear 

*** 		create indicator for whether each household has a head
		egen has_head = max(hh_head), by(hhid)
		tab has_head
		
				keep if has_head == 0

***  identify candidate heads: working males 18+ in households missing a head
		gen candidate = 0
		replace candidate = 1 if has_head == 0 & hh_gender_ == 1 & work == 1 & hh_age_ >= 18

***  create sort key — candidates first, eldest among them first
		gen sortkey = -1000 * candidate - hh_age_

*** sort so each household has candidates first, then by descending age
		sort hhid sortkey

***  select the first candidate in each household
		gen select_head = 0
		by hhid: replace select_head = 1 if candidate == 1 & _n == 1

***  assign that person as household head
		replace hh_head = 1 if has_head == 0 & select_head == 1

		drop has_head select_head candidate sortkey
		
				tempfile no_hh_secondpass
					save `no_hh_secondpass'
					
		egen has_head = max(hh_head), by(hhid)
			tab has_head
		
				keep if has_head == 1
				drop has_head
				
		tempfile no_hh_cleaned2
			save `no_hh_cleaned2'
			
	
restore 

*^*^*	c.	If no working male is available, assign the eldest male  *^*^*


preserve 

use `no_hh_secondpass', clear 

*** 		create indicator for whether each household has a head
		egen has_head = max(hh_head), by(hhid)
		tab has_head

			keep if has_head == 0
		
		gen candidate = 0
		replace candidate = 1 if has_head == 0 & hh_gender_ == 1 & hh_age_ >= 18

***  create sort key — candidates first, eldest among them first
		gen sortkey = -1000 * candidate - hh_age_

*** sort so each household has candidates first, then by descending age
		sort hhid sortkey

***  select the first candidate in each household
		gen select_head = 0
		by hhid: replace select_head = 1 if candidate == 1 & _n == 1

***  assign that person as household head
		replace hh_head = 1 if has_head == 0 & select_head == 1

				drop has_head select_head candidate sortkey
***	save working data 
			tempfile no_hh_thirdpass
					save `no_hh_thirdpass'

***    create filter to keep cleaned data 
			egen has_head = max(hh_head), by(hhid)
				tab has_head
		
				keep if has_head == 1
				drop has_head
				
		tempfile no_hh_cleaned3
			save `no_hh_cleaned3'

restore


*^*^*d.	If eldest male is not available, select respondent as head  *^*^*

preserve 

use `no_hh_thirdpass', clear

	egen has_head = max(hh_head), by(hhid)
			tab has_head
		
		keep if has_head == 0
 
			replace hh_head = 1 if resp == 1
			
			drop has_head

		tempfile no_hh_cleaned4
			save `no_hh_cleaned4'


restore 


*-----------------------------------------*
**#Append data 
*-----------------------------------------*	


keep if num_heads_per_hh == 1
	append using `multiple_heads_cleaned1'
	append using `multiple_heads_cleaned2'
	append using `no_hh_cleaned1'
	append using `no_hh_cleaned2'
	append using `no_hh_cleaned3'
	append using `no_hh_cleaned4'


*** one last check for old times sake 
	count 
		tab hh_head //  2,080 bless 
		duplicates tag individ, generate(uhoh)
		tab uhoh 

		drop uhoh 

*-----------------------------------------*
**#  SELECT VARIABLES AND SAVE FILE 
*-----------------------------------------*

		keep if hh_head == 1
		
*** r		ename the inedex var for clarity 

		rename individual hh_head_index 	
		
*** 		keep only household id and respondent index variable *** 
		
		keep hhid hh_head_index 

***			save final data set.

	save "$data_deidentified\household_head_index.dta", replace 






*** end of .do file 

















/* 
** DELETE WHEN FINALIZED 
*-----------------------------------------*
**## 4. 	Matching Criteria
*-----------------------------------------*		


* b.	Case: Stata couldn't find matched name due to typos/spacing: If names differ but plausibly match and age ≥ 18 → assign as head.



		** correct child head with name-matched hh head
		replace hh_head = 1 if individ == "050A2003"
				** replace child with 0
				replace hh_head = 0 if individ == "050A2009"
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
		replace hh_head = 1 if individ == "153A1501"	
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


		* clean up relation variables
		
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

		
*/ 
 
 