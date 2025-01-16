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

*drop strings 
drop hh_12_o* hh_12_a* hh_12_ro* hh_12_cal* hh_13_o* hh_13_s* hh_19_o* hh_ethnicity_o* hh_29_o* list_actifs_o agri_6_20_o*

foreach i of numlist 1/55 {
    drop hh_12_`i'
}


*variables removed: hh_age hh_gender living_01 living_02 living_03 living_04

* Reshape long with hhid and id
reshape long health_5_3_2_ health_5_4_ health_5_5_ health_5_6_ health_5_7_ health_5_8_ health_5_9_ health_5_10_ hh_ethnicity_  hh_10_ hh_12_1_ hh_12_2_ hh_12_3_ hh_12_4_ hh_12_5_ hh_12_6_ hh_12_7_ hh_12_8_ hh_13_ hh_18_ hh_19_ hh_22_ hh_26_ hh_29_ hh_30_ hh_31_ hh_32_ hh_33_ hh_37_ hh_age_ hh_gender_ agri_6_20_, ///
    i(hhid) j(id)


* Create matching individual_id_crdes
tostring hhid, replace format("%12.0f")
tostring id, gen(str_id) format("%02.0f")
gen str individual_id_crdes = hhid + str_id
format individual_id_crdes %15s

* Create wealth index variable 
gen wealthindex=list_actifscount/16

* **Keep only individual_id_crdes and variables of interest to avoid conflicts**
keep individual_id_crdes health_5_3_2_ health_5_4_ health_5_5_ health_5_6_ health_5_7_ health_5_8_ health_5_9_ health_5_10_ hh_ethnicity_ hh_10_ hh_12_1_ hh_12_2_ hh_12_3_ hh_12_4_ hh_12_5_ hh_12_6_ hh_12_7_ hh_12_8_ hh_13_ hh_18_ hh_19_ hh_22_ hh_26_ hh_29_ hh_30_ hh_31_ hh_32_ hh_33_ hh_37_ hh_age_ hh_gender_ living_01 living_02 living_03 living_04 wealthindex q_18 q_19 q_23 q_24 q_35_check q_39 q_49 q_46 q_51 list_actifscount Cerratophyllummassg Bulinus Biomph Humanwatercontact BegeningTimesampling Endsamplingtime Schistoinfection InfectedBulinus  InfectedBiomphalaria schisto_indicator list_actifs agri_6_20_

* Save temp health data
*save "${dataframe}\temp_health_reshaped.dta", replace


*********************************************************


* Save the final dataset
*save "${dataframe}\child_infection_dataframe.dta", replace
save "${dataframe}\child_infection_dataframe_features.dta", replace

********************* For rice analysis *********************
*save "${output}\child_infection_dataframe_features.dta", replace

*erase "${dataframe}\temp_health_reshaped.dta"


