*** Created by Alexander Mills***
	*** Updates recorded in GitHub ***
*==============================================================================
clear all
set more off
set maxvar 30000

**************************************************
* SET FILE PATHS
**************************************************

* Set base Box path for each user
if "`c(username)'"=="socrm" global box_path "C:\Users\socrm\Box\NSF Senegal"
if "`c(username)'"=="kls329" global box_path "C:\Users\kls329\Box\NSF Senegal"
if "`c(username)'"=="km978" global box_path "C:\Users\km978\Box\NSF Senegal"
if "`c(username)'"=="Kateri" global box_path "C:\Users\Kateri\Box\NSF Senegal"
if "`c(username)'"=="admmi" global box_path "C:\Users\admmi\Box\NSF Senegal"

* Define the master folder path
global master "$box_path\Data_Management"

* Define specific paths for output and input data
global dailyupdates "$master\Output\Data_Quality_Checks\Midline\Midline_Daily_Updates"
* UPDATE WITH DATE
global data "$master\_CRDES_RawData\Midline\Household_Survey_Data\DISES_Enquête_ménage_midline_VF_WIDE_10Feb2025.csv"
global baselinedata "$master\_CRDES_CleanData\Baseline\Identified\DISES_Baseline_Complete_PII.dta"
global training "$master\_CRDES_CleanData\Treatment\Identified\treatment_indicator_PII.dta"
global respond "$master\_CRDES_CleanData\Baseline\Identified\respondent_index.dta"
global issues "$master\External_Corrections\Issues for Justin and Amina\Midline\Issues"

***************************************************
* UPDATE WITH DATE
putexcel set "$dailyupdates\DISES_DailyChecks_12Feb.xlsx", replace

* Write Revisit and Attrition Rates
putexcel A1 = "Metric" B1 = "Value"

* Load midline data
import delimited "$data", clear varnames(1) bindquote(strict)

* For computing attrition/revisit rates: *
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

* Compute overall revisit and attrition rates
gen total_baseline = _N * 20  // Baseline households (20 per village)
gen total_revisit_rate = (total_midline / total_baseline) * 100
gen total_attrition_rate = 100 - total_revisit_rate

* Display results
di "Total Households Surveyed at Midline: " total_midline[1]
di "Total Revisit Rate: " total_revisit_rate[1] "%"
di "Total Attrition Rate: " total_attrition_rate[1] "%"

* Write Revisit and Attrition Rates
putexcel A1 = "Metric" B1 = "Value"
putexcel A2 = "Total Households Surveyed at Midline" B2 = total_midline
putexcel A3 = "Total Revisit Rate (%)" B3 = total_revisit_rate
putexcel A4 = "Total Attrition Rate (%)" B4 = total_attrition_rate

***************************************************
* Identify Households with Different Respondents
***************************************************

* Load baseline respondent dataset and isolate those who were respondents at baseline
use "$respond", clear

* Convert resp_index to a string and ensure leading zero for single digits
gen str2 resp_str = string(resp_index, "%02.0f")  

gen individ = hhid + resp_str

* Standardize ID format
tostring individ, replace force
replace individ = trim(upper(individ))

* Save cleaned baseline respondents
save temp_individ.dta, replace

* Load midline data again
import delimited "$data", clear varnames(1) bindquote(strict)

* Count total households retained
count
local total_households = r(N)

* Drop missing or invalid respondents
drop if missing(hh_name_complet_resp)

* Standardize ID format
rename hh_name_complet_resp individ
tostring individ, replace force
replace individ = trim(upper(individ))

* Merge with baseline respondent dataset
merge m:1 individ using temp_individ.dta
tab _merge

* Identify same respondent cases
gen same_respondent = (_merge == 3)

* Compute respondent statistics
count if same_respondent == 1
local total_same_respondent = r(N)

local total_different_respondent = `total_households' - `total_same_respondent'

* Compute share safely
if `total_households' > 0 {
    local share_different_respondent = (`total_different_respondent' / `total_households') * 100
} 
else {
    local share_different_respondent = .
}

* Display results
di "Households with a Different Respondent: `total_different_respondent'"
di "Share of Households with a Different Respondent: `share_different_respondent' %"

* Write Respondent Change Statistics
putexcel A6 = "Households with a Different Respondent" B6 = `total_different_respondent'
putexcel A7 = "Share of Households with a Different Respondent (%)" B7 = `share_different_respondent'

* Initialize a counter for flagged values in each row
gen num_flagged_values = 0

* Loop through all variables and count occurrences of special values per row
foreach var of varlist _all {
    capture confirm numeric variable `var'
    if _rc == 0 {  
        replace num_flagged_values = num_flagged_values + (inlist(`var', -999, -99, -9, 999))
    }
    else {
        replace num_flagged_values = num_flagged_values + (inlist(real(`var'), -999, -99, -9, 999))
    }
}

* Compute total number of flagged values across the dataset
egen total_flagged_values = total(num_flagged_values)

* Compute total number of flagged values from households with a different respondent
gen num_flagged_values_new_resp = num_flagged_values if same_respondent == 0
egen total_flagged_values_new_resp = total(num_flagged_values_new_resp)

* Compute share of flagged values from households with a new respondent
gen share_flagged_values_new_resp = (total_flagged_values_new_resp / total_flagged_values) * 100

* Display results
di "Total flagged 'I Don't Know' values in dataset: " total_flagged_values
di "Total flagged 'I Don't Know' values from households with a new respondent: " total_flagged_values_new_resp
di "Percentage of flagged 'I Don't Know' values from new respondent households: " share_flagged_values_new_resp "%"

* Write Flagged Values Statistics
putexcel A9 = "Total Flagged 'I Don't Know' Values in Dataset" B9 = total_flagged_values
putexcel A10 = "Share of Flagged 'I Don't Know' Values from New Respondent Households (%)" B10 = share_flagged_values_new_resp

***************************************************
* Calculate Household-Level Training Status
***************************************************
* Load midline data again
import delimited "$data", clear varnames(1) bindquote(strict)
rename hh_global_id hhid
tempfile midline_clean
save `midline_clean', replace

* Prepare training data
use "$training", clear
collapse (max) trained_hh, by(hhid)
tempfile training_clean
save `training_clean', replace

* Load prepared midline data
use `midline_clean', clear

* Merge with prepared training data
merge m:1 hhid using `training_clean', keep(master match) nogen

* Identify trained households in midline data
gen trained_hh_midline = 0
replace trained_hh_midline = 1 if attend_training == 1 | who_attended_training == 1

* Check overlap: trained_hh == 1 and midline indicators
gen overlap_attended = trained_hh == 1 & (attend_training == 1 | who_attended_training == 1)
gen overlap_heard = trained_hh == 1 & heard_training == 1

* Count totals
count if trained_hh == 1
local total_trained_hh = r(N)

count if overlap_attended == 1
local total_overlap_attended = r(N)

count if overlap_heard == 1
local total_overlap_heard = r(N)

* Compute shares
local share_overlap_attended = (`total_overlap_attended' / `total_trained_hh') * 100
local share_overlap_heard = (`total_overlap_heard' / `total_trained_hh') * 100

* Display results
di "Total trained households: `total_trained_hh'"
di "Trained households attending or having a member attend training at midline: `total_overlap_attended' (`share_overlap_attended'%)"
di "Trained households hearing about training at midline: `total_overlap_heard' (`share_overlap_heard'%)"

***************************************************
* Write Training Statistics to Excel
***************************************************

putexcel A12 = "Total Trained Households in Midline" B12 = `total_trained_hh'
putexcel A13 = "Trained HH Recall Attending Training at Midline" B13 = `total_overlap_attended'
putexcel A14 = "Share of Trained HH Recall Attending Training (%)" B14 = `share_overlap_attended'
putexcel A15 = "Trained HH Heard Training at Midline" B15 = `total_overlap_heard'
putexcel A16 = "Share of Trained HH Heard about Training (%)" B16 = `share_overlap_heard'


***************************************************
* Export Tabulation of HHID_Village to Excel
***************************************************
* see how many hh's are missing from each village
estpost tab hhid_village
esttab using "$dailyupdates\Village_Counts_12Feb.xlsx", cells("b(label(Count)) pct(label(Percent))") replace




