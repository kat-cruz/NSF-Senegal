*==============================================================================
* Program: balance tables data tranformation
* ==============================================================================
* written by: Kateri Mouawad
* additions made by: Kateri Mouawad (KRM), Molly Doruska (MJD)
* Created: October 2024
* Updates recorded in GitHub 

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
if "`c(username)'"=="admmi" global box_path "C:\Users\admmi\Box"

if "`c(username)'"=="km978" global git_path "C:\Users\Kateri\Downloads\GIT-Senegal\NSF-Senegal"
if "`c(username)'"=="Kateri" global git_path "C:\Users\km978\Downloads\GIT-Senegal\NSF-Senegal"



* Define project-specific paths
global path "${box_path}\Data Management\Output\Data Analysis"
global output "$git_path\Latex_Output\Balance_Tables"


***** Global folders *****
global data  "${path}\Balance_Tables"

***Version Control:
global date = strofreal(date(c(current_date),"DMY"), "%tdYYNNDD")

clear

use "$data\balance_tables_data.dta"


foreach i of numlist 1/55 {
    drop hh_education_skills_`i'  hh_12_`i' health_5_3_`i'
}

drop hh_12_o* hh_12_a* hh_13_s* hh_13_o* health_5_3_o* living_01_o  living_03_o living_04_o living_05_o enum_03_o enum_04_o enum_05_o species_o
*variables removed: hh_age hh_gender living_01 living_02 living_03 living_04

* Reshape long with hhid and id
forval i = 1/7 {
    // Loop over the second index (1 to 55)
    forval j = 1/55 {
        // Construct the old and new variable names
        local oldname = "hh_13_`j'_`i'"
        local newname = "hh_13_`i'_`j'"
        
        // Rename if the old variable exists
        cap rename `oldname' `newname'
    }
}

	
	reshape long hh_gender_ hh_age_ hh_education_skills_1_ hh_education_skills_2_ hh_education_skills_3_ hh_education_skills_4_ hh_education_skills_5_ health_5_3_1_ health_5_3_2_ health_5_3_3_ health_5_3_4_ health_5_3_5_ health_5_3_6_ health_5_3_7_ health_5_3_8_ health_5_3_9_ health_5_3_10_ health_5_3_11_ health_5_3_12_ health_5_3_13_ health_5_3_14_ health_5_3_15_ health_5_3_99_ hh_education_level_ hh_education_year_achieve_ ///
hh_number_ hh_03_ hh_10_ hh_11_ hh_12_1_ hh_12_2_ hh_12_3_ hh_12_4_ hh_12_5_ hh_12_6_ hh_12_7_ hh_12_8_ hh_13_1_ hh_13_2_ hh_13_3_ hh_13_4_ hh_13_5_ hh_13_6_ hh_13_7_ hh_14_ hh_15_ hh_16_ hh_29_ health_5_2_ ///
health_5_3_ health_5_5_ health_5_6_ health_5_7_, i(hhid) j(id)


* Save temp health data
*save "${dataframe}\temp_health_reshaped.dta", replace


*********************************************************


* Save the final dataset
*save "${dataframe}\child_infection_dataframe.dta", replace
save "${dataframe}\child_infection_dataframe_features.dta", replace

********************* For rice analysis *********************
*save "${output}\child_infection_dataframe_features.dta", replace

*erase "${dataframe}\temp_health_reshaped.dta"


