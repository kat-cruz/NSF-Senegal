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
 
   import excel "$path\_DISES Baseline ecological data.xlsx", sheet("Sites biocomposition") firstrow clear 
   
*** Remove all up or downstream villages without village codes from the data ***

gen ends_with_u = substr(VillageCodes, -1, 1) == "u"

*** drop those observations ***
drop if ends_with_u

*** clean up the temporary variable ***
drop ends_with_u

*** rename VillageCodes to hhid_village

rename VillageCodes hhid_village


save "$path\DISES_baseline_ecological data.dta", replace 


















