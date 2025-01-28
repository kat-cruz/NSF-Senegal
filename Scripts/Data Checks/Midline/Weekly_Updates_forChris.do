*** Created by Alexander Mills***
	*** Updates recorded in GitHub ***
*==============================================================================
clear all
set mem 2000m
set maxvar 30000
set matsize 11000
set more off

**************************************************
* SET FILE PATHS
**************************************************

* Set base Box path for each user
if "`c(username)'"=="socrm" global box_path "C:\Users\socrm\Box"
if "`c(username)'"=="kls329" global box_path "C:\Users\kls329\Box"
if "`c(username)'"=="km978" global box_path "C:\Users\km978\Box\NSF Senegal"
if "`c(username)'"=="Kateri" global box_path "C:\Users\Kateri\Box\NSF Senegal"
if "`c(username)'"=="admmi" global box_path "C:\Users\admmi\Box\NSF Senegal"

* Define the master folder path
global master "$box_path\Data Management"

* Define specific paths for output and input data
global dailyupdates "$master\Output\Data Quality Checks\Midline\R2_Daily_Updates"

global data "$master\_CRDES_RawData\Midline\Household_Survey_Data\DISES_Enquête_ménage_midline_VF_WIDE_27Jan.csv"

global baselinedata "$master\_CRDES_CleanData\Baseline\Identified\DISES_Baseline_Complete_PII.dta"

global training "$master\_CRDES_CleanData\Treatment\Identified\treatment_indicator_PII.dta"

***************************************************

* For computing attrition/revisit rates: *

* Load midline data
import delimited "$data", clear varnames(1) bindquote(strict)

egen midline_count = count(hh_global_id), by(hhid_village)


* Create a variable counting households per village
gen one = 1
collapse (sum) one, by(hhid_village)
rename one midline_count

* Calculate revisit and attrition rates for each village
gen revisit_rate = (midline_count / 20) * 100
gen attrition_rate = 100 - revisit_rate

* Calculate totals
* Total households surveyed at midline
egen total_midline = sum(midline_count)

* Total revisit rate (overall)
gen total_baseline = _N * 20  // Baseline households (20 per village)
gen total_revisit_rate = (total_midline / total_baseline) * 100
gen total_attrition_rate = 100 - total_revisit_rate

* Display the results
list hhid_village midline_count revisit_rate attrition_rate, sep(0)

* Display totals
di "Total Households Surveyed at Midline: " total_midline[1]
di "Total Revisit Rate: " total_revisit_rate[1] "%"
di "Total Attrition Rate: " total_attrition_rate[1] "%"

***************************************************

* What share of households retained have a different respondent: *

***************************************************
* Load midline data
import delimited "$data", clear varnames(1) bindquote(strict)

* Generate indicator for different respondent
gen different_respondent = (hh_name_complet_resp == "999")

* Count total households retained
count
local total_households = r(N)

* Count households with a different respondent
count if different_respondent == 1
local total_different_respondent = r(N)

* Calculate share of households with a different respondent
local share_different_respondent = (`total_different_respondent' / `total_households') * 100

* Display results
di "Households with Different Respondent: `total_different_respondent'"
di "Share of Households with Different Respondent: `share_different_respondent'%"

***************************************************
* Tracking Training Attendance Limited to Midline Villages
***************************************************

* Load midline data
import delimited "$data", clear varnames(1) bindquote(strict)

* Keep unique `hhid_village`
keep hhid_village
duplicates drop

* Save the list of midline `hhid_village`
tempfile midline_villages
save `midline_villages', replace

import delimited "$data", clear varnames(1) bindquote(strict)
rename hh_global_id hhid
keep hhid attend_training who_attended_training
drop if missing(hhid)
tempfile midline_trained
save `midline_trained', replace

* Load midline data
import delimited "$data", clear varnames(1) bindquote(strict)

* Rename hh_global_id to hhid for consistency
rename hh_global_id hhid

drop if missing(training_id)

* Keep relevant variables
keep hhid training_id_* training_id training_id_*

* Reshape training_id_* variables to long format
reshape long training_id_, i(hhid) j(individ) string

* Standardize individ to uppercase for comparison
gen individ_upper = upper(individ)
drop individ
rename individ_upper individ

* Keep only records where training_id matches individ
keep if training_id == individ

merge 1:1 individ using "$training"

* Create hhid_village by extracting the first 4 characters of hhid
gen hhid_village = substr(hhid, 1, 4)

* Rename the first _merge variable to preserve it
rename _merge merge_individ

* Merge with midline `hhid_village`
merge m:1 hhid_village using `midline_villages'

* Keep only matched rows (hhid_village that appear in midline)
keep if _merge == 3
drop _merge

* Rename the second _merge variable to preserve it
//rename _merge merge_individ

merge m:1 hhid using `midline_trained' 

***************************************************
* Calculate Individual-Level Ratio
***************************************************

* Count baseline-trained individuals
count if trained_indiv == 1
local total_trained_indiv = r(N)

* Count baseline-trained individuals who reported midline training
count if trained_indiv == 1 & training_id_ == 1
local total_training_id = r(N)

* Calculate individual-level ratio
local indiv_ratio = (`total_training_id' / `total_trained_indiv') * 100

***************************************************
* Calculate Household-Level Ratio
***************************************************

* Count baseline-trained households
count if trained_hh == 1
local total_trained_hh = r(N)

* Count baseline-trained households with midline attendance
count if trained_hh == 1 & (attend_training == 1 | who_attended_training == 1)
local total_attend_hh = r(N)

* Calculate household-level ratio
local hh_ratio = (`total_attend_hh' / `total_trained_hh') * 100


***************************************************
* Export Results to Excel
***************************************************
putexcel set "$dailyupdates\DISES_DailyChecks_27Jan.xlsx", replace

* Write headers for Revisit and Attrition Rates
putexcel A1 = "Metric" B1 = "Value"

* Load midline data
import delimited "$data", clear varnames(1) bindquote(strict)

egen midline_count = count(hh_global_id), by(hhid_village)

* Create a variable counting households per village
gen one = 1
collapse (sum) one, by(hhid_village)
rename one midline_count

* Calculate revisit and attrition rates for each village
gen revisit_rate = (midline_count / 20) * 100
gen attrition_rate = 100 - revisit_rate

* Calculate totals
* Total households surveyed at midline
egen total_midline = sum(midline_count)

* Total revisit rate (overall)
gen total_baseline = _N * 20  // Baseline households (20 per village)
gen total_revisit_rate = (total_midline / total_baseline) * 100
gen total_attrition_rate = 100 - total_revisit_rate

* Export results to Excel
putexcel A2 = "Total Households Surveyed at Midline" B2 = total_midline[1]
putexcel A3 = "Total Revisit Rate (%)" B3 = total_revisit_rate[1]
putexcel A4 = "Total Attrition Rate (%)" B4 = total_attrition_rate[1]

* Load midline data
import delimited "$data", clear varnames(1) bindquote(strict)

* Generate indicator for different respondent
gen different_respondent = (hh_name_complet_resp == "999")

* Count total households retained
count
local total_households = r(N)

* Count households with a different respondent
count if different_respondent == 1
local total_different_respondent = r(N)

* Calculate share of households with a different respondent
local share_different_respondent = (`total_different_respondent' / `total_households') * 100

* Export results to Excel
putexcel A6 = "Total Households Retained" B6 = `total_households'
putexcel A7 = "Households with Different Respondent" B7 = `total_different_respondent'
putexcel A8 = "Share of Households with Different Respondent (%)" B8 = `share_different_respondent'

* Add the training attendance calculations here
* Include individual-level and household-level ratios
* Export their results after appending to the above Excel file
putexcel A10 = "Total Trained Individuals (Baseline)" B10 = `total_trained_indiv'
putexcel A11 = "Total Trained Individuals (Midline)" B11 = `total_training_id'
putexcel A12 = "Individual-Level Ratio (%)" B12 = `indiv_ratio'

putexcel A14 = "Total Individuals in Trained Households (Baseline)" B14 = `total_trained_hh'
putexcel A15 = "Total Individuals in Trained Households Reporting Attendance (Midline)" B15 = `total_attend_hh'
putexcel A16 = "Household-Level Ratio (%)" B16 = `hh_ratio'

