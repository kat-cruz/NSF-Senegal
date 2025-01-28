*** File originally created By: Molly Doruska ***
      *** Adapted by Kateri Mouawad & Alexander Mills***
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


* Step 1: Create a variable counting households per village
gen one = 1
collapse (sum) one, by(hhid_village)
rename one midline_count

* Step 2: Calculate revisit and attrition rates for each village
gen revisit_rate = (midline_count / 20) * 100
gen attrition_rate = 100 - revisit_rate

* Step 3: Calculate totals
* Total households surveyed at midline
egen total_midline = sum(midline_count)

* Total revisit rate (overall)
gen total_baseline = _N * 20  // Baseline households (20 per village)
gen total_revisit_rate = (total_midline / total_baseline) * 100
gen total_attrition_rate = 100 - total_revisit_rate

* Step 4: Display the results
list hhid_village midline_count revisit_rate attrition_rate, sep(0)

* Step 5: Display totals
di "Total Households Surveyed at Midline: " total_midline[1]
di "Total Revisit Rate: " total_revisit_rate[1] "%"
di "Total Attrition Rate: " total_attrition_rate[1] "%"



***************************************************

* What share of households retained have a different respondent: *

***************************************************

* Step 1: Load midline data
import delimited "$data", clear varnames(1) bindquote(strict)

* Step 2: Generate indicator for different respondent
gen different_respondent = (hh_name_complet_resp == "999")

* Step 3: Count total households retained
count
local total_households = r(N)

* Step 4: Count households with a different respondent
count if different_respondent == 1
local total_different_respondent = r(N)

* Step 5: Calculate share of households with a different respondent
local share_different_respondent = (`total_different_respondent' / `total_households') * 100

* Step 6: Display results
di "Households with Different Respondent: `total_different_respondent'"
di "Share of Households with Different Respondent: `share_different_respondent'%"

***************************************************

* For responses to training questions *

***************************************************

* Step 1: Load midline data
import delimited "$data", clear varnames(1) bindquote(strict)

* Rename hh_global_id to hhid for consistency
rename hh_global_id hhid

* Filter only relevant training records
keep if attend_training == 1 | who_attended_training == 1

* Keep relevant variables
keep hhid_village hhid training_id_* attend_training who_attended_training training_id training_id_*

* Reshape training_id_* variables to long format
reshape long training_id_, i(hhid) j(individ) string

* Standardize individ to uppercase for comparison
gen individ_upper = upper(individ)
drop individ
rename individ_upper individ

* Keep only records where training_id matches individ
keep if training_id == individ

* Save reshaped and filtered midline data
save "$dailyupdates\reshaped_midline_trained_temp.dta", replace

* Step 2: Filter baseline-trained for surveyed villages

* Load baseline training data
use "$training", clear

* Filter for trained individuals
keep if trained_indiv == 1

* Create hhid_village by extracting the first 4 characters of hhid
gen hhid_village = substr(hhid, 1, 4)

* Save baseline-trained individuals
save "$dailyupdates\baseline_trained_indiv.dta", replace

* Load midline data to extract surveyed villages
import delimited "$data", clear varnames(1) bindquote(strict)

* Keep unique hhid_village
keep hhid_village
duplicates drop

* Save surveyed villages
save "$dailyupdates\midline_surveyed_villages.dta", replace

* Load baseline-trained individuals
use "$dailyupdates\baseline_trained_indiv.dta", clear

* Merge with midline-surveyed villages to filter trained individuals in surveyed villages
merge m:1 hhid_village using "$dailyupdates\midline_surveyed_villages.dta"

* Keep only matched records (baseline-trained individuals from surveyed villages)
keep if _merge == 3
drop _merge

* Save filtered baseline-trained individuals
save "$dailyupdates\baseline_trained_in_surveyed_villages.dta", replace

* Step 3: Compare baseline-trained with midline-trained individuals

* Load reshaped midline-trained data
use "$dailyupdates\reshaped_midline_trained_temp.dta", clear

* Merge with baseline-trained individuals in surveyed villages
merge m:1 individ using "$dailyupdates\baseline_trained_in_surveyed_villages.dta"

* Generate match indicator
gen match_training = (_merge == 3 & training_id_ == 1)

* Calculate total matches
count if match_training == 1
local total_matches = r(N)

* Calculate total baseline-trained individuals in surveyed villages
use "$dailyupdates\baseline_trained_in_surveyed_villages.dta", clear
count
local total_baseline_trained = r(N)

* Calculate match percentage
local match_percentage = (`total_matches' / `total_baseline_trained') * 100

* Step 4: Display results

di "Total Baseline-Trained Individuals in Surveyed Villages: `total_baseline_trained'"
di "Total Matches in Midline: `total_matches'"
di "Match Percentage: `match_percentage'%"



***************************************************

* For responses to "yes, attended training" *

***************************************************
import delimited "$data", clear varnames(1) bindquote(strict)

sum attend_training who_attended_training heard_training


