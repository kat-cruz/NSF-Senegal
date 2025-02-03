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
global dailyupdates "$master\Output\Data_Quality_Checks\Midline\R2_Daily_Updates"

global data "$master\_CRDES_RawData\Midline\Household_Survey_Data\DISES_Enquête_ménage_midline_VF_WIDE_27Jan.csv"

global baselinedata "$master\_CRDES_CleanData\Baseline\Identified\DISES_Baseline_Complete_PII.dta"

global training "$master\_CRDES_CleanData\Treatment\Identified\treatment_indicator_PII.dta"

global individ "$master\_CRDES_CleanData\Baseline\Identified\All_Villages_With_Individual_IDs.dta"

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

* What share of households retained have a different respondent than the baseline household list: *

***************************************************

import delimited "$data", clear varnames(1) bindquote(strict)

* Generate indicator for different respondent
gen total_new_member_respondent = (hh_name_complet_resp == "999")

* Count total households retained
count
local total_households = r(N)

* Count households with a different respondent
count if total_new_member_respondent == 1
local total_new_member_respondent = r(N)

* Calculate share of households with a different respondent
local share_new_member_respondent = (`total_new_member_respondent' / `total_households') * 100

* Display results
di "Households with New Member Respondent: `total_new_member_respondent'"
di "Share of Households with New Member Respondent: `share_new_member_respondent'%"

***************************************************
* Step 2: Identify Households That Retained the Same Respondent
***************************************************

* Load baseline individual dataset and keep relevant observations
use "$individ", clear
keep if hh_name_complet_resp == hh_full_name_calc_
drop hh_head_name_complet

* Convert individ to string to ensure compatibility
tostring individ, replace force
replace individ = trim(individ)
replace individ = upper(individ)

* Save cleaned dataset
save temp_individ.dta, replace

* Load midline data again
import delimited "$data", clear varnames(1) bindquote(strict)

* Drop missing or invalid names
drop if missing(hh_name_complet_resp)
drop if hh_name_complet_resp == "999"

* Rename for merging consistency
rename hh_name_complet_resp individ

* Convert individ to string format
tostring individ, replace force
replace individ = trim(individ)
replace individ = upper(individ)

* Merge with baseline respondents
merge 1:1 individ using temp_individ.dta

* Check merge results
tab _merge

* Generate indicator for same respondent retained
gen same_respondent = (_merge == 3)  // Matched cases where the same respondent was found in baseline

* Count households where the same respondent was retained
count if same_respondent == 1
local total_same_respondent = r(N)

* Compute number of households with a different respondent
local total_different_respondent = `total_households' - `total_same_respondent'

* Compute share of households that had a different respondent
local share_different_respondent = (`total_different_respondent' / `total_households') * 100

* Display results
di "Households with a Different Respondent: `total_different_respondent'"
di "Share of Households with a Different Respondent: `share_different_respondent' %"

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
* Export respondent retention results
putexcel A6 = "Households with New  Member Respondent" B6 = `total_new_member_respondent'
putexcel A7 = "Share of Households with New Household Member Respondent (%)" B7 = `share_new_member_respondent'

putexcel A8 = "Households with a Different Respondent" B8 = `total_different_respondent'
putexcel A9 = "Share of Households with a Different Respondent (%)" B9 = `share_different_respondent'

***************************************************
* Export Training Attendance Results
***************************************************

putexcel A11 = "Total Trained Individuals (Baseline)" B11 = `total_trained_indiv'
putexcel A12 = "Total Trained Individuals (Midline)" B12 = `total_training_id'
putexcel A13 = "Individual-Level Training Attendance (%)" B13 = `indiv_ratio'

putexcel A15 = "Total Trained Households (Baseline)" B15 = `total_trained_hh'
putexcel A16 = "Total Trained Households Reporting Attendance (Midline)" B16 = `total_attend_hh'
putexcel A17 = "Household-Level Training Attendance (%)" B17 = `hh_ratio'
