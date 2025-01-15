*==============================================================================
* Program: clean up ecological data to merge with human parasitological df 
* ==============================================================================
* written by: Kateri MOuawad
* Created: December 2024
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



* Define project-specific paths

global path "${box_path}\Data Management\_PartnerData\Ecological data\Baseline"

*** load in df ****

*use "$data\Baseline ecological data Jan-Feb 2024 CORRECTED.dta", clear 
 
 
   import excel "$path\_DISES Baseline ecological data.xlsx", sheet("Sites biocomposition") firstrow clear 
   
*** Remove all up or downstream villages without village codes from the data ***

gen ends_with_u = substr(VillageCodes, -1, 1) == "u" | substr(VillageCodes, -1, 1) == "U"

*** drop those observations ***
drop if ends_with_u

*** clean up the temporary variable ***
drop ends_with_u

*** rename VillageCodes to hhid_village

rename VillageCodes hhid_village

*** initial cleaning ***

 drop if hhid_village == ""
 
*** create indicator variable based on text variable ***

gen schisto_indicator = .
replace schisto_indicator = 1 if Schistoinfection == "yes"
replace schisto_indicator = 0 if Schistoinfection == "no"

*** update hhid_village IDs ***

replace hhid_village = "071B" if Sites == "Dembe"
replace hhid_village = "132B" if hhid_village == "041B"
replace hhid_village = "122B" if hhid_village == "063B"
replace hhid_village = "120A" if hhid_village == "101A"
replace hhid_village = "130A" if hhid_village == "051A"
replace hhid_village = "140A" if hhid_village == "111A"



save "$path\DISES_baseline_ecological data.dta", replace 
 















