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

* Define the master folder path
global master "$box_path\Data Management"

* Define specific paths for output and input data
global dailyupdates "$master\Output\Data Quality Checks\Midline\R2_Daily_Updates"

global data "$master\_CRDES_RawData\Midline\Household_Survey_Data\DISES_Enquête_ménage_midline_VF_WIDE_23Jan.csv"

global baselinedata "$master\_CRDES_CleanData\Baseline\Identified\DISES_Baseline_Complete_PII.dta"

global individ "$master\_CRDES_CleanData\Baseline\Identified\All_Villages_With_Individual_IDs.dta"

***************************************************

* For computing attrition/revisit rates: *

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
di "Total Households Retained: `total_households'"
di "Households with Different Respondent: `total_different_respondent'"
di "Share of Households with Different Respondent: `share_different_respondent'%"

***************************************************

* For finding how many households are replaced: *

***************************************************



***************************************************

* For responses to training questions *

***************************************************
import delimited "$data", clear varnames(1) bindquote(strict)



***************************************************

* For responses to "yes, attended training" *

***************************************************

* "C:\Users\km978\Box\NSF Senegal\Data Management\Output\Data Corrections\Treatments\Treated_variables_df.dta"

* do we still want to do a geocoor
