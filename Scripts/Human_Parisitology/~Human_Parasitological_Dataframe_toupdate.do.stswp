*==============================================================================

* written by: Kateri Mouawad
* Created: February 2025
* Updates recorded in GitHub

*>>>>>>>>>>**--*--*--*--*--*--*--*--** READ ME **--*--*--*--*--*--*--*--**<<<<<<<<<<<*
		
clear all
set mem 100m
set maxvar 30000
set matsize 11000
set more off

**************************************************
* SET FILE PATHS
**************************************************


* Set base Box path for each user
if "`c(username)'"=="socrm" global master "C:\Users\socrm\Box"
if "`c(username)'"=="kls329" global master "C:\Users\kls329\Box"
if "`c(username)'"=="km978" global master "C:\Users\km978\Box\NSF Senegal"
if "`c(username)'"=="Kateri" global master "C:\Users\Kateri\Box\NSF Senegal"
if "`c(username)'"=="admmi" global master "C:\Users\admmi\Box\NSF Senegal"


* Define project-specific paths
global data "$master\Data_Management\_PartnerData\Parasitological_Analysis_Dataframe"
global output "$master\Data_Management\_Partner_CleanData\Parasitological_Analysis_Data\Analysis_Data"

use "$data\child_infection_dataframe_features.dta", replace

