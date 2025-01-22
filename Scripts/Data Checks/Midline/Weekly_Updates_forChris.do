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

