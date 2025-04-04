*** Add treatment arm information to location data *** 
*** Uses "Complete_Baseline_Vilalge_Locations.dta" ***
*** Outputs "Complete_Baseline_Vilalge_Locations.csv" ***
*** Code created by Molly Doruska ***
*** Code last updated by Molly Doruska *** 
*** Last updated on November 14, 2024 *** 

clear all
set more off 

**** Master file path  ****
if "`c(username)'"=="socrm" {
                global master "C:\Users\socrm\Box\NSF Senegal\Data Management"
}
else if "`c(username)'"=="kls329" {
                global master "/Users/kls329\Box\NSF Senegal\Data Management"
}
else if "`c(username)'"=="km978" {
                global master "C:\Users\km978\Box\NSF Senegal\Data Management"
}
else if "`c(username)'"=="Kateri" {
                global master "C:\Users\Kateri\Box\NSF Senegal\Data Management"
}

global data_identified "$master\_CRDES_CleanData\Baseline\Identified"

*** import village location data *** 
use "$data_identified\Complete_Baseline_Village_Locations.dta", clear 

*** split apart key information about village treatment arm from village ID *** 
gen treatment = substr(hhid_village,3,1)

*** generate child testing village variable ***
gen testing = ""
replace testing = "C" if hhid_village == "011A"
replace testing = "C" if hhid_village == "030B"
replace testing = "C" if hhid_village == "012B"
replace testing = "C" if hhid_village == "022A"
replace testing = "C" if hhid_village == "032A"
replace testing = "C" if hhid_village == "072B"
replace testing = "C" if hhid_village == "021A"
replace testing = "C" if hhid_village == "062B"
replace testing = "C" if hhid_village == "033A"
replace testing = "C" if hhid_village == "010B"
replace testing = "C" if hhid_village == "030A"
replace testing = "C" if hhid_village == "010A"
replace testing = "C" if hhid_village == "023B"
replace testing = "C" if hhid_village == "012A"
replace testing = "C" if hhid_village == "013B"
replace testing = "C" if hhid_village == "013A"
replace testing = "C" if hhid_village == "011B"
replace testing = "C" if hhid_village == "020A"
replace testing = "C" if hhid_village == "020B"
replace testing = "C" if hhid_village == "031B"
replace testing = "C" if hhid_village == "021B"
replace testing = "C" if hhid_village == "023A"
replace testing = "C" if hhid_village == "130A"
replace testing = "C" if hhid_village == "033B"
replace testing = "C" if hhid_village == "122A"
replace testing = "C" if hhid_village == "123A"
replace testing = "C" if hhid_village == "121B"
replace testing = "C" if hhid_village == "131B"
replace testing = "C" if hhid_village == "120B"

*** save dataset as csv file for map creation *** 
export delimited using "$data_identified\Complete_Baseline_Village_Locations.csv" 

