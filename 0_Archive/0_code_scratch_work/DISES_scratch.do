

clear all

use "C:\Users\Kateri\Box\NSF Senegal\Baseline Data Collection\Surveys\Baseline CRDES data (Jan-Feb 2024)\Questionnaire Communautaire - NSF DISES_23jan2024.dta", clear 


 *** other ideas for code in case the above ones have problms ***
 
  	* Keep observations where q_23 is NOT 1 and q_24 is either 0 or 1 OR q_23 is 1 and q_24 is NOT 0 or 1
preserve
 	generate ind_1 = q_23 != 1 | q_24 == 0 | q_24 == 1
	generate ind_2 = q_23 == 1 | q_24 != 0 | q_24 != 1
	generate issue_1 = "q_23 has no response"
	generate issue_2 = "q_24 has no response"
	
	keep if ind_1 == 0 
	keep if ind_2 == 0 
	keep village_select sup full_name phone_resp q_23 q_24 issue_1 issue_2

    * Export the dataset to Excel
    export excel using Issue_Community_q_23_noresponse.xlsx, firstrow(variables) replace
	
 restore	
 
 
 foreach num of numlist 28 29 30 31 32 33{
	preserve
    local var1 q_`num'
    local var2 q_`num'a
    
    
    * Step 1: Generate the indicator variable
    generate ind_`var1' = (`var1' != 1 & (`var2' >= 0 & `var2' <= 2000 | `var2' == -9))
    generate issue_`var1' = "Missing `var1'"
    
     *Step 2: Export to Excel only if there are observations meeting the conditions
    ind_`var1' == 1 {
        keep village_select sup full_name phone_resp `var1' `var2' ind_var issue
        export excel using Issue_Community_`var1'_noresponse.xlsx, firstrow(variables) replace
    }
    
     restore
}




*** FOR SEPERATE CODE IF THATS WHAT MOLLY WANTS ****

*** PART 01 ***
preserve
* Step 1: Generate the indicator variable
generate ind_var = (q_28 != 1 & (q_28a >= 0 & q_28a <= 2000 | q_28a == -9))
generate issue = "Missing q_28"

* Step 2: Export to Excel only if there are observations meeting the conditions
if ind_var == 1 {
	keep village_select sup full_name phone_resp q_28 q_28a ind_var issue
    export excel using Issue_Community_q_28_noresponse, firstrow(variables) replace
} 

 restore 	
 
 *** PART 02 ***
 
 preserve
* Step 1: Generate the indicator variable
generate ind_var = (q_28 == 1 & (q_28a < 0 & q_28a > 2000 & q_28a != -9))
generate issue = "Missing q_28a"

* Step 2: Export to Excel only if there are observations meeting the conditions
if ind_var == 1 {
	keep village_select sup full_name phone_resp q_28 q_28a ind_var issue
    export excel using Issue_Community_q_24_noresponse, firstrow(variables) replace
} 

 restore 
 
 
 
 
 
clear all

use "C:\Users\Kateri\Box\NSF Senegal\Baseline Data Collection\Surveys\Baseline CRDES data (Jan-Feb 2024)\Questionnaire Communautaire - NSF DISES_23jan2024.dta", clear 

preserve 
 gen valid_format = 0
foreach var of varlist q_35 {
    replace valid_format = 1 if q_35_check != 1 & q_35 >= 0 & q_35 <= 23741
}
restore 
 
preserve 
  gen valid_format = 0
foreach var of varlist q_35 {
    replace valid_format = 1 if q_35_check == 1 & q_35 < 0 & q_35 > 23741
}
 
restore
 
 
 
 
 
 
  
clear all

use "C:\Users\Kateri\Box\NSF Senegal\Baseline Data Collection\Surveys\Baseline CRDES data (Jan-Feb 2024)\Questionnaire Communautaire - NSF DISES_23jan2024.dta", clear 

 
 
 preserve 
 
 foreach num of numlist 38 40 42{
 
    local var1 q_`num'
    local var2 q_`=`num'-1'
	
	gen ind_`var1' = 0
	replace ind_`var1' = 1 if `var2' == 1 & (missing(`var1') | length(trim(`var1')) == 0)
	generate issue_`var1' = "Missing" if ind_`var1' == 1
	}
		replace issue = "" if ind_`var1' == 0 
	keep village_select sup full_name phone_resp `var1' `var2' ind_`var1' issue_`var1' 	
    if ind_`var1' == 1 {
        export excel using Issue_Community_`var1'_noresponse.xlsx, firstrow(variables) replace
    }
	
	}
restore 

 
  * Step 1: Generate the indicator variable
    generate ind_`var1' = (`var1' == 1 & (`var2' < 0 & `var2' > 2000 & `var2' != -9))
    generate issue_`var1' = "Missing `var1'"
    
     *Step 2: Export to Excel only if there are observations meeting the conditions
    ind_`var1' == 1 {
        keep village_select sup full_name phone_resp `var1' `var2' ind_var issue
        export excel using Issue_Community_`var1'_noresponse.xlsx, firstrow(variables) replace
 
 
 
 *m.	Q62_o should be answered when q62 = -95, response should be text
 
 
*** PART ONE ***

preserve 

	gen ind_var = 0
    replace ind_var = 1 if q62 == -95 & (missing(q62_o ) | length(trim(q62_o )) == 0)
	generate issue = "Missing q62_0" if ind_var == 1
		replace issue = "" if ind_var == 0 
	keep village_select sup full_name phone_resp q62 q62_o ind_var issue
    if ind_var == 1 {
        export excel using Issue_Community_q62_noresponse.xlsx, firstrow(variables) replace
    }
	
restore 

 *** PART TWO FOR LAST QUESTION WRT COMMUNITY????***
 
preserve 

	gen ind_var = 0
    replace ind_var = 1 if q62 == -95 & (missing(q62_o ) | length(trim(q62_o )) == 0)
	generate issue = "Missing q62" if ind_var == 1
		replace issue = "" if ind_var == 0 
	keep village_select sup full_name phone_resp q62 q62_o ind_var issue
    if ind_var == 1 {
        export excel using Issue_Community_q62o_noresponse.xlsx, firstrow(variables) replace
    }
	
restore 


 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
