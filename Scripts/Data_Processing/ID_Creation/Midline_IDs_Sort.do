clear all
set mem 100m
set maxvar 30000
set matsize 11000
set more off

**************************************************
* SET FILE PATHS
**************************************************

* Set base Box path for each user
if "`c(username)'"=="socrm" global master "C:\Users\socrm\Box\NSF Senegal"
if "`c(username)'"=="kls329" global master "C:\Users\kls329\Box\NSF Senegal"
if "`c(username)'"=="km978" global master "C:\Users\km978\Box\NSF Senegal"
if "`c(username)'"=="Kateri" global master "C:\Users\Kateri\Box\NSF Senegal"
if "`c(username)'"=="admmi" global master "C:\Users\admmi\Box\NSF Senegal"

**************************** Data file paths ****************************

global data "$master\Data_Management\Data\_CRDES_RawData\Midline\Household_Survey_Data"
global replacement "$master\Data_Management\Data\_CRDES_RawData\Midline\Replacement_Survey_Data"
global baselineids "$master\Data_Management\Data\_CRDES_CleanData\Baseline\Identified"
global issues "$master\Data_Management\Output\Data_Quality_Checks\Midline\_Midline_Original_Issues_Output"
global corrected "$master\Data_Management\Output\Data_Processing\Checks\Corrections\Midline"
global clean "$master\Data_Management\Data\_CRDES_CleanData\Midline\Identified"
global out_temp "C:\Users\km978\Box\My projects"

use "$clean\DISES_Midline_Complete_PII.dta", clear

tostring hh_relation_with_o*, replace 
tostring hh_full_name_calc*, replace
tostring pull_hh_individ_*, replace

	tostring hh_full_name_calc*, replace 
	tostring pull_hh_full_name_calc*, replace 

/* 

keep hhid hhid_village add_new_* pull_hh_individ_* hh_head_name_complet hh_name_complet_resp hh_name_complet_resp_new hh_age_resp hh_gender_resp hh_full_name_calc_* hh_gender_* hh_age_* hh_phone hh_relation_with_* hh_relation_with_o_* pull
*/

*rpt_mem_count
 
			keep add_new_* hhid hh_full_name_calc*  pull_hh_full_name_calc* pull_hh_individ_* still_member*  /// // keep identifiable variables for now to merge in the individual IDs
			  hh_age* hh_gender*   pull_hh_age* pull_hh_gender* hh_name_complet_resp_new
	  
				drop still_member_whynot*
				
** replace any missing values in hh_full_name_calc_ hh_age_ hh_gender_ to retain full list



*** create variable individual which is the index of which person in the household the observation is (the j variable in Stata) ***

	  
	reshape long ///
	   still_member_ add_new_ pull_hh_individ_ hh_full_name_calc_  pull_hh_full_name_calc__  /// // keep identifiable variables for now to merge in the individual IDs
      hh_age_ hh_gender_  hh_ethnicity_ pull_hh_gender__ pull_hh_age__, ///
			i(hh_name_complet_resp_new hhid) j(individual)
			
		replace hh_full_name_calc_ = pull_hh_full_name_calc__ if hh_full_name_calc_ == ""
		replace hh_age_ = pull_hh_age__ if hh_age_ == .
		replace hh_gender_ = pull_hh_gender__ if hh_gender_ == .
			
			
	

/*
reshape long pull_hh_individ_ add_new_ hh_full_name_calc_ hh_gender_ hh_age_ hh_relation_with_ hh_relation_with_o_, i(hhid_village hhid hh_head_name_complet hh_name_complet_resp hh_name_complet_resp_new hh_age_resp hh_gender_resp hh_phone) j(individual)
*/

*** drop if there is no individual ***
drop if (hh_full_name_calc_ == "" | hh_full_name_calc_ == ".") & hh_gender_ == . & hh_age_ == . 


**			tag duplicates based on these variables which I'll be merging on 
				duplicates tag hhid hh_full_name_calc_ hh_gender_ hh_age_, generate(dup_tag)
			
			*keep if dup_tag != 0

**			drop duplicates, keeping only the first occurrence
				duplicates drop hhid hh_full_name_calc_ hh_gender_ hh_age_, force
				
					drop dup_tag
					

				rename pull_hh_individ_ individ
				
				duplicates tag individ, gen(fml)
				tab fml
			
				drop if inlist(hhid, "133A19", "133A03", "133A20", "133A02", "133A05", "133A11")
				drop fml


*** merge w/ the baseline id's
/*
use "$baselineids\All_Villages_With_Individual_IDs.dta", clear 
keep hhid_village hhid hh_full_name_calc_ hh_gender_ hh_age_ indiv_index individ
save "$out_temp\all_baseline_ids.dta", replace 
*/


gen  midline_name = hh_full_name_calc_
gen  midline_individ = individ

merge m:1 hhid individ using  "$out_temp\all_baseline_ids.dta"
keep still_member_ hhid add_new_ individ hh_full_name_calc_ _merge indiv_index hh_name_complet_resp_new midline_name midline_individ
keep if _merge != 3

duplicates tag hhid hh_full_name_calc_, generate(killme)
tab killme
keep if killme != 0
drop if add_new == 1
sort hhid


gen str_clean_base = lower(trim(ustrnormalize(hh_full_name_calc_, "nfc")))
gen str_clean_mid = lower(trim(ustrnormalize(midline_name, "nfc")))

* Generate flag for exact name match
gen name_match = (str_clean_base == str_clean_mid)

drop if name_match == 1

replace 

/* 
sort hh_full_name_calc_

use "C:\Users\km978\Box\NSF Senegal\Data_Management\Output\Data_Processing\ID_Creation\Baseline\Individual_IDs_For_EPLS_UCAD_Matching\All_Villages.dta", clear

**			tag duplicates based on these variables which I'll be merging on 
				duplicates tag hhid hh_full_name_calc_ hh_gender_ hh_age_, generate(dup_tag)
			
			*keep if dup_tag != 0

**			drop duplicates, keeping only the first occurrence
				duplicates drop hhid hh_full_name_calc_ hh_gender_ hh_age_, force
				
save "$out_temp\all_baseline_ids.dta", replace 	 */			
				
* sort data by household ID and individual index
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



*individ	hh_full_name_calc_	_merge	max_index	new_member_count
*030A1013	SaÃ¯dou Gaye	Using only (2)	14	0


keep still_member_ hhid add_new_ individ max_index new_member_count new_index hh_full_name_calc_ _merge indiv_index hh_name_complet_resp_new


replace new_index = "0" + new_index if length(new_index) == 1 & new_index != ""

* update the indiv_index
replace indiv_index = new_index if indiv_index == "" & _merge == 1

* generate the full individual ID by concatenating household ID and individual index
replace individ = hhid + indiv_index if individ == ""

* clean 
drop max_index new_member_count new_index

sort hhid indiv_index

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

foreach var of varlist * {
    capture confirm string variable `var'
    if !_rc {
        replace `var' = subinstr(`var', "132A", "153A", .)
    }
}

* save complete dataset with all individual IDs (baseline and midline)
*save "$clean\All_Individual_IDs_Complete.dta", replace

* save the midline-only dataset
drop if _merge == 2
*save "$clean\Midline_Individual_IDs.dta", replace
