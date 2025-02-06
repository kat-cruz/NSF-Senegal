*** Created by: Alex Mills ***
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
global schoolprincipal "$master\Output\Data_Quality_Checks\Midline\R2_Principal_Issues"
global issues "$master\Output\Data_Quality_Checks\Midline\Full Issues"
global schooldata "$master\_CRDES_RawData\Midline\Principal_Survey_Data"
global hhdata "$master\_CRDES_RawData\Midline\Household_Survey_Data"

* Import the HH data
import delimited "$hhdata\DISES_Enquête_ménage_midline_VF_WIDE_5Feb.csv", clear varnames(1) bindquote(strict)

drop if missing(hh_global_id)

duplicates drop hh_global_id, force

keep if missing(hh_49)

* Save the imported CSV as a Stata .dta file for merging
save "$hhdata\DISES_Enquête_ménage_midline_VF_WIDE_5Feb_Missing_hh49.dta", replace

* Import School Attendance check
import delimited "$schooldata\DISES_Principal_Survey_MIDLINE_VF_WIDE_5Feb.csv", clear varnames(1) bindquote(strict)

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

* Reshape long with `id` as the suffix and `school_name` as the unique identifier
reshape long fu_mem_id_ pull_hhid_village_ pull_hhid_ pull_individ_ ///
    pull_hh_first_name__ pull_hh_name__ pull_hh_full_name_calc__ ///
    pull_hh_age_ pull_hh_gender_ pull_hh_head_name_complet_ ///
    pull_baselineniveau_ pull_family_members_ pull_temp_, ///
    i(school_name) j(id)
	
* Keep only relevant variables
keep school_name fu_mem_id_* pull_hhid_village_* pull_hhid_* pull_individ_* ///
    pull_hh_* pull_baselineniveau_* pull_family_members_* pull_temp_* ///
    instanceid instancename formdef_version key

drop if missing(pull_hhid_)

rename pull_hhid_ hh_global_id

drop if missing(pull_hhid_)

duplicates drop hh_global_id, force

preserve

merge m:1 hh_global_id using "$hhdata\DISES_Enquête_ménage_midline_VF_WIDE_5Feb_Missing_hh49.dta"

tab _merge

keep if _merge == 3

drop _merge

keep school_name pull_hhid_village_ hh_global_id pull_individ_ pull_hh_first_name__ pull_hh_name__ pull_hh_full_name_calc__ pull_hh_age_ pull_hh_gender_ pull_hh_head_name_complet_ pull_baselineniveau_ pull_family_members_

export excel using "$schoolprincipal/attendance_checks_missing_hh49.xlsx", firstrow(variables) replace 



