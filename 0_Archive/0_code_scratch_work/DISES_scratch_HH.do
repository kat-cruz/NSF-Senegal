clear all

set maxvar 20000

import delimited "C:\Users\km978\Box\NSF Senegal\Baseline Data Collection\Surveys\Baseline CRDES data (Jan-Feb 2024)\DISES_enquete_ménage_FINALE_WIDE_29Jan2024.csv", clear 

forvalues i = 1/55 {

    preserve 
    
    * Calculate the sum of hh_21_o_i
    qui sum hh_18_`i'
    local sum_hh_18' = r(sum)
	
	 qui sum hh_21_o_`i'
    local sum_hh_21_o = r(sum)
	
	forvalues j = 1/7 {
		qui sum hh_21_`i'_`j'
		local sum_hh_21 = r(sum)
	}
		
	generate ind_var = 0
	replace ind_var = 1 if sum_hh_21 + sum_hh_21_o < hh_18_`i'
     
	generate issue = "Issue found: Sum of `hh_21_i_j' and `hh_21_o_i' is less than `hh_18_i'" 
   	generate issue_variable_name = "sum_less_than_`hh_18_i'"
	
	rename hh_21_`i'_total print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	
	if _N > 0 {
        save "$household_roster\Issue_Household_sum_less_than_`hh_18_i'.dta", replace
    }
	  restore
    }
  




	egen hh_21_`i'_total = rowtotal (hh_21_`i'_1  hh_21_`i'_2  hh_21_`i'_3  hh_21_`i'_4  hh_21_`i'_5  hh_21_`i'_6  hh_21_`i'_7)


