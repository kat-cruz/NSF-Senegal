clear 
set more off
import excel "$data2\Baseline ecological data Jan-Feb 2024.xlsx", sheet("Sites biocomposition") firstrow clear 

		******** label up/downstream values ********
/*		
	gen hhid_village = VillageCodes

* Create a new variable to store the new codes
	gen Up_downStream = ""

preserve

	local code = 114
	* Loop through each observation
	forvalues i = 1/`=_N' {
		* Increment the code only if the value is "Up/downstrem "
		if hhid_village[`i'] == "Up/downstrem " {
			local code = `code' + 1
			replace Up_downStream = string(`code') + "u" in `i'
		}
	}

		save "$file\UpAndDownstream_test.dta", replace
restore	
*/


gen hhid_village = VillageCodes

preserve

local code = 114

* Loop through each observation
forvalues i = 1/`=_N' {
    * Increment the code only if the value is "Up/downstrem "
    if hhid_village[`i'] == "Up/downstrem " {
        local code = `code' + 1
        replace hhid_village = string(`code') + "u" in `i'
    }
}

save "$file\UpAndDownstream.dta", replace
restore

	
clear
use "$file\UpAndDownstream.dta"

* Create a new variable to store the bottom portion
gen up_downStream = ""

preserve
* Loop through each observation
forvalues i = 1/`=_N' {
    * Check if hhid_village ends with "u"
    local suffix_u = substr(hhid_village[`i'], -1, 1)
    if "`suffix_u'" == "u" {
        * Move the value to the up_downStream column
        replace up_downStream = hhid_village[`i'] in `i'
        * Set the original hhid_village value to missing
        replace hhid_village = "" in `i'
    }
	
}

save "$file\UpAndDownstream_test2.dta", replace
restore
use "$file\UpAndDownstream_test2.dta"
drop up_downStream
keep if hhid_village != ""
save "$file\UpAndDownstream_test2.dta", replace

* Filter the dataset based on values in up_downStream
clear
use "$file\UpAndDownstream_test2.dta"
keep if up_downStream != ""
save "$file\filtered_dataset.dta", replace
restore

use "$file\filtered_dataset.dta"

clear 
use "$file\UpAndDownstream_test2.dta"
merge m:m Date using "$file\filtered_dataset.dta"

clear
use "$file\UpAndDownstream_test2.dta"
append using "$file\filtered_dataset.dta", force
save "$file\filtered_dataset_2.dta", replace

clear 
use "$file\DISES_enquete_ménage_FINALE_WIDE_6Feb24_VILLAGE.dta"
merge m:1 hhid_village using  "$file\filtered_dataset_2.dta"


use "$file\filtered_dataset_2.dta"









clear 
use "$file\filtered_dataset_2.dta"


	levelsof hhid_village, local(unique_values)

	foreach value of local unique_values {
		di "`value'"
	}




















