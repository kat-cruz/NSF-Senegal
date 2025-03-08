*==============================================================================
* DISES Attrition & Replacement Analysis
* File originally created By: Alex Mills
* Updates recorded in GitHub: [Midline_Villages_Replacements_Checks.do](https://github.com/kat-cruz/NSF-Senegal/blob/main/Scripts/Data_Processing/Checks/Midline/Midline_Villages_Replacements_Checks.do)
*==============================================================================
*
* Description:
* This script performs an analysis of attrition and replacements for the Midline Household Survey data in the NSF Senegal project. It identifies households that have attritted and those that need replacements.
*
* Key Functions:
* - Import baseline and midline survey data.
* - Identify attritted households.
* - Import and process replacement survey data.
* - Combine retained and replacement households.
* - Count households per village and identify those below the target count.
* - Export results for field teams.
*
* Inputs:
* - **Baseline Data:** The baseline dataset (`DISES_Baseline_Complete_PII.dta`)
* - **Midline Data:** The midline dataset (`DISES_Enquête_ménage_midline_VF_WIDE_24Feb2025.csv`)
* - **Replacement Data:** The replacement dataset (`DISES_enquete_ménage_FINALE_MIDLINE_REPLACEMENT_WIDE_24Feb2025.csv`)
* - **File Paths:** Ensure that user-specific file paths in the `SET FILE PATHS` section are correctly configured.
*
* Outputs:
* - **Processed Household Data:** Datasets for retained and attritted households, as well as replacements.
* - **Excel Reports:** Lists of villages needing replacements and household IDs.
*
* Instructions to Run:
* 1. Update the **file paths** in the `"SET FILE PATHS"` section for the correct user.
* 2. Run the script sequentially in Stata.
* 3. Verify that households needing replacements are correctly identified.
* 4. Check the processed datasets and Excel files saved in the specified directories.
*
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
if "`c(username)'"=="socrm" global master "C:\Users\socrm\Box\NSF Senegal"
if "`c(username)'"=="kls329" global master "C:\Users\kls329\Box\NSF Senegal"
if "`c(username)'"=="km978" global master "C:\Users\km978\Box\NSF Senegal"
if "`c(username)'"=="Kateri" global master "C:\Users\Kateri\Box\NSF Senegal"
if "`c(username)'"=="admmi" global master "C:\Users\admmi\Box\NSF Senegal"

**************************** Data file paths ****************************

global data "$master\Data_Management\_CRDES_RawData\Midline\Household_Survey_Data"
global replacement "$master\Data_Management\_CRDES_RawData\Midline\Replacement_Survey_Data"
global baselineids "$master\Data_Management\_CRDES_CleanData\Baseline\Identified"
global issues "$master\Data_Management\Output\Data_Quality_Checks\Midline\_Midline_Original_Issues_Output"

**************************** Import baseline data ****************************

use "$baselineids\DISES_Baseline_Complete_PII.dta", clear

keep hhid hhid_village  // Keep only HHID and Village ID
duplicates drop hhid, force  // Keep one entry per household
gen baseline = 1  // Mark as a baseline household

save "$baselineids\DISES_Baseline_HHID_List.dta", replace

**************************** Import midline data & Mark Attrition ****************************

import delimited "$data\DISES_Enquête_ménage_midline_VF_WIDE_24Feb2025.csv", clear varnames(1) bindquote(strict)
keep hh_global_id hhid_village consent  // Keep relevant variables
rename hh_global_id hhid
gen attritted = 0  // Default is not attritted
duplicates drop hhid, force  // Keep one entry per household
drop if missing(hhid)
replace attritted = 1 if (consent == 0 | consent == 2)  // Mark attritted if no consent

save "$issues\DISES_Midline_HHID_Retained.dta", replace

**************************** Merge midline with baseline to find attrition ****************************

use "$baselineids\DISES_Baseline_HHID_List.dta", clear

gen attritted = 1  // Assume all baseline households are attritted initially


merge 1:1 hhid using "$issues\DISES_Midline_HHID_Retained.dta"

replace attritted = 0 if _merge == 3  // If HH appears in both baseline & midline → Not attritted
replace attritted = 1 if _merge == 1  // If HH in baseline but missing in midline → Attritted

save "$issues\DISES_Attrition_List.dta", replace
export delimited "$issues\DISES_Attrition_List.csv", replace

**************************** Import replacement survey data ****************************

import delimited "$replacement\DISES_enquete_ménage_FINALE_MIDLINE_REPLACEMENT_WIDE_24Feb2025.csv", clear varnames(1) bindquote(strict)

keep hhid_village hhid  // Keep relevant replacement variables
gen replaced = 1  // Mark as a replacement household

* Sort by village to ensure sequential numbering
bysort hhid_village (hhid): gen rep_number = _n  // Assigns 1, 2, 3,... per village

* Create the new replacement `hhid` based on original `hhid`
gen hhid_replacement = hhid + string(rep_number + 29, "%02.0f")  // Adds 30, 31, 32,...
rename hhid_replacement hhid
drop rep_number
save "$issues\DISES_Replacements.dta", replace

**************************** Combine Retained and Replacement HHs ****************************

use "$issues\DISES_Midline_HHID_Retained.dta", clear
append using "$issues\DISES_Replacements.dta"  // Combine both datasets

save "$issues\DISES_Midline_Complete_HHIDs.dta", replace

**************************** Count Midline Households per Village ****************************

use "$issues\DISES_Midline_Complete_HHIDs.dta", clear
gen count_hh = 1  // Temporary numeric variable for counting
collapse (count) count_hh, by(hhid_village)  
rename count_hh midline_hh_count  // Rename to make clear this is midline count

save "$issues\DISES_Midline_HH_Counts.dta", replace

**************************** Merge with Baseline Village Counts ****************************

use "$issues\DISES_Attrition_List.dta", clear  // Load baseline attrition list
gen count_hh = 1  // Temporary numeric variable for counting
collapse (count) count_hh, by(hhid_village)  // Get total baseline HHs per village
rename count_hh baseline_hh_count

merge 1:1 hhid_village using "$issues\DISES_Midline_HH_Counts.dta", nogen

**************************** Identify Villages Still Below 20 HHs ****************************

gen households_needed = baseline_hh_count - midline_hh_count  // How many HHs are missing?
replace households_needed = 0 if households_needed < 0  // No negative values

gen status = "Complet" if midline_hh_count >= baseline_hh_count
replace status = "Besoin de remplacements" if midline_hh_count < baseline_hh_count

keep hhid_village baseline_hh_count midline_hh_count households_needed status


**************************** Save & Export for Field Teams ****************************

save "$issues\DISES_Villages_Besoin_De_Remplacements.dta", replace
export delimited "$issues\DISES_Villages_Besoin_De_Remplacements.csv", replace

**************************** Match HHIDs for These Villages ****************************

use "$issues\DISES_Midline_Complete_HHIDs.dta", clear  // Load full midline household list

merge m:1 hhid_village using "$issues\DISES_Villages_Besoin_De_Remplacements.dta", nogen

* Keep only villages still needing replacements
keep if status == "Besoin de remplacements"  

**************************** Save the Final List of HHIDs for Villages Still Needing Replacements ****************************

save "$issues\DISES_HHIDs_Besoin_De_Remplacements.dta", replace
export delimited "$issues\DISES_HHIDs_Besoin_De_Remplacements.csv", replace



