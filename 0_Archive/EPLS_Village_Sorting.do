*** DISES Baseline Data - Code used to create Household IDs***
*** File Created By: Kateri Mouawad ***
*** File Last Updated By: Kateri Mouawad ***
*** File Last Updated On: June 13, 2024 ***


 *** This Do File PROCESSES: village 120B.xlsx
						     *village 122A.xlsx
							 *village 123A.xlsx
							 *village 131B.xlsx
  *** This Do File CREATES: village 120B.dta
						    *village 122A.dta
							*village 123A.dta
							*village 131B.dta

				
							
 *** Procedure: 
      * (1) I need to isolate the new data that came in after I did the EPLS/DISES matching to speed the process of rematching. So running these lines merges the old match and new matches which will isolate the newly added data. 


clear all 

*** set maximum variables to at least 20,000 ***
set maxvar 20000

**** Master file path  ****

if "`c(username)'"=="socrm" {
                global master "C:\Users\socrm\Box\NSF Senegal"
}
else if "`c(username)'"=="Kateri" {
                global master "C:\Users\Kateri\Box\NSF Senegal"
				
}
else if "`c(username)'"=="km978" {
                global master "C:\Users\km978\Box\NSF Senegal"
				
}

global data "$master\Data Work\Output\Data Corrections"

global data2 "$master\Baseline Data Collection\EPLS and DISES data\MATCHES"

global data3 "$master\Baseline Data Collection\EPLS and DISES data\Archive Village Checks"


***************************************** Village 120B ********************************


/*
import excel "$data2\village 120B.xlsx", firstrow clear
save "$data2\village 120B.dta", replace 

import excel "$data3\village 120B_done.xlsx", firstrow clear
save "$data3\village 120B_done.dta", replace 
*/

use "$data3\village 120B_done.dta", clear


/*
drop if hh_gender_ == "TOTAL MATCHES"
save "$data3\village 120B_done.dta", replace 
*/

destring hh_gender_ MATCH, replace 
merge m:m individ using "$data2\village 120B.dta", force 

sort _merge 

export excel "$data2\village 120B TO DO (extra data).xlsx", replace 

******************************************* Village 122A ***************************** 
/*
import excel "$data2\village 122A.xlsx", firstrow clear 
save "$data2\village 122A.dta", replace 

import excel "$data3\village 122A_done.xlsx", firstrow clear 
save "$data3\village 122A_done.dta", replace 
*/

use "$data3\village 122A_done.dta", clear 

/*
drop if individ == "TOTAL MATCHES"

save "$data3\village 122A_done.dta", replace 
*/


merge m:m individ using "$data2\village 122A.dta" 

sort _merge 

export excel "$data2\village 122A TO DO (extra data).xlsx", replace 
 


******************************************* Village 123A ***************************** 

******* WE ARE GOODY GOOD
/*
import excel "$data2\village 123A.xlsx", firstrow clear 
save "$data2\village 123A.dta", replace 

import excel "$data3\village 123A_done.xlsx", firstrow clear 
save "$data3\village 123A_done.dta", replace 
*/


*use "$data3\village 123A_done.dta", clear 
use "$data2\village 123A.dta", clear 

/*
drop if individ == "TOTAL MATCHES"

save "$data3\village 123A_done.dta", replace 
*/

merge 1:1 individ using "$data3\village 123A_done.dta" 

tab _merge

sort _merge 

drop if _merge == 3

sort hh_full_name_calc_

export excel "$data2\village 123A TO DO (extra data).xlsx", replace 

tab hh_name_complet_resp


******************************************* Village 131B ***************************** 


/*
import excel "$data2\village 131B.xlsx", firstrow clear 
save "$data2\village 131B.dta", replace 

import excel "$data3\village 131B_done.xlsx", firstrow clear 
save "$data3\village 131B_done.dta", replace 
*/


use "$data2\village 131B.dta", clear 

/*
drop if individ == "TOTAL MATCHES:"

save "$data3\village 131B_done.dta", replace 
*/


merge m:m sup enqu hh_head_name_complet hh_name_complet_resp hh_age_resp hh_gender_resp using "$data3\village 131B_done.dta" 

sort _merge 

export excel "$data2\village 131B TO DO (extra data).xlsx", firstrow(varlabels) replace



*** try the opposite way bigger data to smaller bc somthing is not working out 






