*** File originally created By: Molly Doruska ***
      *** Adapted by Kateri Mouawad & Alexander Mills***
	*** Updates recorded in GitHub ***
*==============================================================================
clear all
set mem 100m
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


***************************************************

* For computing attrition/revisit rates: *

***************************************************

*  Load the baseline dataset
use baseline_data.dta, clear

*  Keep only the HHID variable
keep hhid

*  Sort and save the baseline HHIDs
gen in_baseline = 1
save baseline_hhids.dta, replace

* Load the updated weekly midline dataset
use midline_weekly.dta, clear

*  Keep only the HHID variable
keep hhid

* Sort and save the weekly midline HHIDs
gen in_midline = 1
save midline_hhids_weekly.dta, replace

* Merge baseline and weekly midline HHIDs
merge 1:1 hhid using baseline_hhids.dta

*  Label merge results for clarity
label define merge_labels 1 "In Both (Revisited)" 2 "In Midline Only (New)" 3 "In Baseline Only (Not Yet Revisited)"
label values _merge merge_labels

*  Track progress for revisit rates
gen revisit = (_merge == 1)  // 1 if HH revisited, 0 otherwise
tab _merge
sum revisit

* Step 10: Save weekly results for tracking
save merged_hhids_weekly_revisit.dta, replace

* can output as table?
***************************************************


ALEX
* Define the master folder path
global master "$box_path\Data Management"

* Define specific paths for output and input data
global dailyupdates "$master\Output\Data Quality Checks\Midline\R2_Daily_Updates"

global data "$master\_CRDES_RawData\Midline\Household_Survey_Data\DISES_Enquête_ménage_midline_VF_WIDE_23Jan.csv"

global baselinedata "$master\_CRDES_CleanData\Baseline\Identified\DISES_Baseline_Complete_PII.dta"

global individ "$master\_CRDES_CleanData\Baseline\Identified\All_Villages_With_Individual_IDs.dta"

***************************************************

* For computing attrition/revisit rates: *


***************************************************

* Step 1: Load midline data
import delimited "$data", clear varnames(1) bindquote(strict)

* Step 2: Keep relevant identifier and rename
keep hh_global_id
rename hh_global_id hhid

* Step 3: Save the processed midline data temporarily
save "$dailyupdates\Processed_Midline_HHID_23Jan.dta", replace

* Step 4: Load baseline data
use "$baselinedata", clear

* Step 5: Merge baseline data with processed midline data
merge 1:m hhid using "$dailyupdates\Processed_Midline_HHID_23Jan.dta"

* Step 6: Check the merge results
tab _merge

* Explanation of _merge values:
* 1 = In baseline only
* 2 = In midline only (not expected if baseline is the primary dataset)
* 3 = In both baseline and midline

* Step 7: Calculate total households in midline
gen in_midline = (_merge == 2 | _merge == 3)   // Households in midline or both
summarize in_midline
local total_midline = r(sum)

* Step 8: Calculate attrition rate for midline households
gen unmatched = (_merge == 2)   // Households in midline only
summarize unmatched if in_midline == 1
local attrition_rate = r(mean) * 100

* Step 9: Calculate revisit rate for midline households
gen matched = (_merge == 3)     // Households in both baseline and midline
summarize matched if in_midline == 1
local revisit_rate = r(mean) * 100

* Step 10: Display results
di "Total Households Surveyed at Midline: `total_midline'"
di "Attrition Rate for Midline Households: `attrition_rate'%"
di "Revisit Rate for Midline Households: `revisit_rate'%"

***************************************************

* What share of households retained have a different respondent: *

***************************************************

import delimited "$data", clear varnames(1) bindquote(strict)

* Keep relevant variables and rename respondent name
keep hh_name_complet_resp
rename hh_name_complet_resp individ

* Save the processed midline respondent data
save "$dailyupdates\Processed_Midline_Respondents.dta", replace

use "$individ", clear

* Keep only rows where hh_name_complet_resp == hh_full_name_calc_
keep if hh_name_complet_resp == hh_full_name_calc_
keep individ

* Save the processed baseline respondent data
save "$dailyupdates\Processed_Baseline_Respondents.dta", replace

use "$dailyupdates\Processed_Baseline_Respondents.dta", clear
merge 1:m individ using "$dailyupdates\Processed_Midline_Respondents.dta"
gen in_midline = (_merge == 2 | _merge == 3)   // Households in midline or both

* Check merge results
tab _merge

* Explanation of _merge values:
* 1 = In baseline only
* 2 = In midline only
* 3 = In both midline and baseline

* Calculate share of unmatched individuals in midline

* Generate unmatched variable
gen unmatched = (_merge == 2 & in_midline == 1)   // Individuals in midline but not in baseline

* Summarize unmatched respondents
summarize unmatched if in_midline == 1
local unmatched_share = r(mean) * 100

* Total unmatched respondents
count if unmatched == 1
local total_unmatched = r(N)

* Total midline respondents
count if in_midline == 1
local total_midline = r(N)

* Display results
di "Total Midline Respondents: `total_midline'"
di "Total Unmatched Respondents: `total_unmatched'"
di "Share of Unmatched Respondents: `unmatched_share'%"

***************************************************

* For finding how many households are replaced: *

***************************************************



***************************************************

* For responses to training questions *

***************************************************


***************************************************

* For responses to "yes, attended training" *

***************************************************

* "C:\Users\km978\Box\NSF Senegal\Data Management\Output\Data Corrections\Treatments\Treated_variables_df.dta"

* do we still want to do a geocoor

