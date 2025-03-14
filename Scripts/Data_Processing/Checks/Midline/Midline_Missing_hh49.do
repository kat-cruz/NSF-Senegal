*==============================================================================
* DISES Midline Data Checks - Missing HH49
* File originally created By: Alex Mills
* Updates recorded in GitHub: [Midline_Missing_hh49.do](https://github.com/kat-cruz/NSF-Senegal/blob/main/Scripts/Data_Processing/Checks/Midline/Midline_Missing_hh49.do)

*>>>>>>>>>>*===========================* READ ME *===========================*<<<<<<<<<<<*
*
* Description:
* This script processes and updates the Midline Household Survey data for the NSF Senegal project. It identifies and processes households missing the hh_49 (consent) variable.
*
* Key Functions:
* - Import household survey and school attendance data.
* - Set up file paths for different users.
* - Identify households with missing hh_49 variable.
* - Export processed data to Excel for further analysis.
*
* Inputs:
* - **Household Survey Data:** The household dataset (`DISES_Enquête ménage midline VF_WIDE_[INSERT DATE HERE].csv`)
* - **School Attendance Data:** The school attendance dataset (`DISES_Principal_Survey_MIDLINE_VF_WIDE_[INSERT_DATE_HERE.csv`)
* - **File Paths:** Ensure that user-specific file paths in the `SET FILE PATHS` section are correctly configured.
*
* Outputs:
* - **Processed Household Data:** The dataset with missing hh_49 variable (`DISES_Enquête_ménage_midline_VF_WIDE__Missing_hh49.dta`)
* - **Excel Reports:** Attendance checks missing hh_49 (`attendance_checks_missing_hh49_10Feb2025.xlsx`)
*
* Instructions to Run:
* 1. Update the **file paths** in the `"SET FILE PATHS"` section for the correct user.
* 2. Run the script sequentially in Stata.
* 3. Verify that the households with missing hh_49 variable are correctly identified.
* 4. Check the processed dataset and Excel files saved in the specified directories.
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
if "`c(username)'"=="socrm" global box_path "C:\Users\socrm\Box"
if "`c(username)'"=="kls329" global box_path "C:\Users\kls329\Box"
if "`c(username)'"=="km978" global box_path "C:\Users\km978\Box\NSF Senegal"
if "`c(username)'"=="Kateri" global box_path "C:\Users\Kateri\Box\NSF Senegal"
if "`c(username)'"=="admmi" global box_path "C:\Users\admmi\Box\NSF Senegal"

* Define the master folder path
global master "$box_path\Data_Management"

* Define specific paths for output and input data
global schoolprincipal "$master\Output\Data_Quality_Checks\Midline\Midline_Principal_Issues"
global issues "$master\Output\Data_Quality_Checks\Midline\Full Issues"
global schooldata "$master\_CRDES_RawData\Midline\Principal_Survey_Data"
global hhdata "$master\_CRDES_RawData\Midline\Household_Survey_Data"
global crdes "$master\External_Corrections\Issues for Justin and Amina\Midline\Issues"
global corrected "$master\Output\Data_Corrections\Midline"

* Import the HH data  // change to corrected hh data
use "$corrected\CORRECTED_DISES_Enquête_ménage_midline_VF_WIDE_14Mar2025", clear

drop if missing(hh_global_id)

duplicates drop hh_global_id, force

keep if missing(hh_49)
drop sup_name

* Save the imported CSV as a Stata .dta file for merging   // change to corrected hh data
save "$hhdata\DISES_Enquête_ménage_midline_VF_WIDE_14Mar_Missing_hh49.dta", replace

* Import School Attendance check  // change to corrected
import excel "$corrected\CORRECTED_DISES_Principal_Survey_MIDLINE_VF_WIDE_12Mar2025.xlsx", clear firstrow

* Drop completely empty variables
ds
foreach var in `r(varlist)' {
    capture assert missing(`var')
    if _rc == 0 {
        drop `var'
    }
}

* Convert `pull_baselineniveau_*` variables to string format to prevent type mismatches
foreach var of varlist pull_baselineniveau_* {
    tostring `var', replace force
}

* Replace missing school_name with village_select_o
replace school_name = village_select_o if missing(school_name)

* Keep only the first school name duplicates (2 cases right now) doesn't matter here just need the roster list to know who consent is needed for
duplicates drop school_name, force


* Reshape long with `id` as the suffix and `school_name` as the unique identifier
reshape long fu_mem_id_ pull_hhid_village_ pull_hhid_ pull_individ_ ///
    pull_hh_first_name__ pull_hh_name__ pull_hh_full_name_calc__ ///
    pull_hh_age_ pull_hh_gender_ pull_hh_head_name_complet_ ///
    pull_baselineniveau_ pull_family_members_ pull_temp_, ///
    i(school_name) j(id)
	
* Keep only relevant variables
keep respondent_phone_primary respondent_phone_secondary school_name sup_name fu_mem_id_* pull_hhid_village_* pull_hhid_* pull_individ_* ///
    pull_hh_* pull_baselineniveau_* pull_family_members_* pull_temp_* ///
    instanceid instancename formdef_version key

drop if missing(pull_hhid_)

rename pull_hhid_ hh_global_id

drop if missing(pull_hhid_)

duplicates drop hh_global_id, force

preserve

merge m:1 hh_global_id using "$hhdata\DISES_Enquête_ménage_midline_VF_WIDE_14Mar_Missing_hh49.dta"  

tab _merge

keep if _merge == 3

drop _merge

 keep respondent_phone_primary respondent_phone_secondary school_name sup_name school_name pull_hhid_village_ hh_global_id pull_individ_ pull_hh_first_name__ pull_hh_name__ pull_hh_full_name_calc__ pull_hh_age_ pull_hh_gender_ pull_hh_head_name_complet_ pull_baselineniveau_ pull_family_members_ key

export excel using "$schoolprincipal\attendance_checks_missing_hh49_14Mar2025.xlsx", firstrow(variables) replace 

// export excel using "$crdes\attendance_checks_missing_hh49_10Feb2025.xlsx", firstrow(variables) replace 



