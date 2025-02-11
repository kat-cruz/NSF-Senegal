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
if "`c(username)'"=="socrm" global box_path "C:\Users\socrm\Box\NSF Senegal"
if "`c(username)'"=="kls329" global box_path "C:\Users\kls329\Box\NSF Senegal"
if "`c(username)'"=="km978" global box_path "C:\Users\km978\Box\NSF Senegal"
if "`c(username)'"=="Kateri" global box_path "C:\Users\Kateri\Box\NSF Senegal"
if "`c(username)'"=="admmi" global box_path "C:\Users\admmi\Box\NSF Senegal"

* Define the master folder path
global master "$box_path\Data_Management"

* Define specific paths for output and input data
global schoolprincipal "$master\Output\Data_Quality_Checks\Midline\Midline_Principal_Issues"
global hhissues "$master\Output\Data_Quality_Checks\Midline\Midline_Household_Roster"
global schooldata "$master\_CRDES_RawData\Midline\Principal_Survey_Data"
global hhdata "$master\_CRDES_RawData\Midline\Household_Survey_Data"
global crdes "$master\External_Corrections\Issues for Justin and Amina\Midline\Issues"

* Import the HH data
import delimited "$hhdata\DISES_Enquête ménage midline VF_WIDE_10Feb2025.csv", clear varnames(1) bindquote(strict)

drop if consent == 0
drop if missing(hh_global_id)
duplicates list hh_global_id

* Identify and export duplicate household IDs
duplicates report hh_global_id
duplicates tag hh_global_id, generate(dup_hh)

keep if dup_hh > 0
drop dup_hh
export excel using "$hhissues\Household_Duplicates_10Feb2025.xlsx", firstrow(variables) replace
export excel using "$crdes\Household_Duplicates_10Feb2025.xlsx", firstrow(variables) replace


* Import School Attendance check
import delimited "$schooldata\DISES_Principal_Survey_MIDLINE_VF_WIDE_10Feb.csv", clear varnames(1) bindquote(strict)

* Replace missing school_name with village_select_o
replace school_name = village_select_o if missing(school_name)

* Identify and export duplicate school names
duplicates report school_name
duplicates tag school_name, generate(dup_school)
duplicates list school_name

keep if dup_school > 0
drop dup_school
export excel using "$schoolprincipal\SchoolPrincipal_Duplicates_10Feb2025.xlsx", firstrow(variables) replace
export excel using "$crdes\SchoolPrincipal_Duplicates_10Feb2025.xlsx", firstrow(variables) replace


