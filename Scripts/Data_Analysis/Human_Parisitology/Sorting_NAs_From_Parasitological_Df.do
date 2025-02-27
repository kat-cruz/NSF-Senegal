*** Sorting out NAs *** 
*** File Created By: Molly Doruska ***
*** File Last Updated By: Molly Doruska ***
*** File Last Updated On: November 7, 2024 ***

clear all 

set maxvar 20000

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

*** additional file paths ***
global data_identified "$master\_CRDES_CleanData\Baseline\Identified"
global data_deidentified "$master\_CRDES_CleanData\Baseline\Deidentified"
global na_df "$master\Output\Data Analysis"

*** bring in dataframe from child matching with NAs *** 
use "$data_identified\All_Villages_With_Individual_IDs.dta", clear   

import delimited "$na_df\Na_df.csv", clear 

rename individual_id_crdes individ 
rename hhid_crdes hhid
rename age_crdes hh_age_

destring hh_age_, replace force 
 
merge m:m hh_age_ hhid using "$data_identified\All_Villages_With_Individual_IDs.dta", force 

gen ind = 1 if _merge == 3

*** IDs aren't matching, need to rectify that. Kat updated these mannually in the Human_Parasitological_Dataframe.do script bc merging isn't working with deidentified data. ***


