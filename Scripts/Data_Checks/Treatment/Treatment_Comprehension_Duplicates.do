*** DISES Treatment Data - check comprehension survey ***
*** File Created By: Molly Doruska ***
*** File Last Updated By: Molly Doruska ***
*** File Last Updated On: October 22, 2024 ***


 *** This Do File PROCESSES: treatment comprehension survey data from Amina in November, treated data frame 
 
  *** This Do File CREATES: list of duplicates, issues, list of households without a trained individual 
				
							
 *** Procedure: 
 *(1) Run the file paths
 *(2) Load in the data
 *(3) Run the script 
 *(4) Save the excel sheet of issues 
 
clear all
set more off 

*** set maximum variables to at least 20,000 ***
set maxvar 20000

**** Master file path  ****

if "`c(username)'"=="socrm" {
                global master "C:\Users\socrm\Box\NSF Senegal"
}
else if "`c(username)'"=="Kateri" {
                global master "C:\Users\Kateri\Box\NSF Senegal"
				
}
else if "`c(username)'"=="km978" {
                global master "C:\Users\km978\Box\NSF Senegal"
				
}

*** file paths *** 
global issues  "$master\Data_Management\Output\Data_Quality_Checks\Jan-Feb Output\Treatment"
global deidentifed "$master\Data_Management\_CRDES_CleanData\Treatment\Deidentified"
global identifed "$master\Data_Management\_CRDES_CleanData\Treatment\Identified"
global raw "$master\Data_Management\_CRDES_RawData\Treatment"
global output  "$master\Data_Management\Output\Data_Corrections\Treatment"

*** import raw comprehension survey *** 
import excel "$raw\DISES_Export_info_08072024_v2.xlsx", first clear 

*** check if hhid is the same as the household head name *** 
gen same = 0 
replace same = 1 if hhid != pull_select_name

*** output list of issues with household head names in the comprehension survey ***
preserve 

keep if same == 1 

export excel using "$issues\ID_Name_Mismatch_102224.xlsx", replace firstrow(variables)

restore 

drop same 

*** output list of duplicates based on hhid *** 
bysort hhid: gen dup = _N 

preserve 

keep if dup > 1 

export excel using "$issues\ID_Duplicates_102224.xlsx", replace firstrow(variables)

restore 

drop dup 

*** output list of duplicates based on household head name *** 
bysort pull_select_name: gen dup = _N 

preserve 

keep if dup > 1 

export excel using "$issues\Name_Duplicates_102224.xlsx", replace firstrow(variables)

restore 

drop dup 

*** check for differences in hhid memberfu ***
gen hh_num = substr(hhid,-2,2)
gen check_id = hhid_village +"-"+ hh_num
gen same = 0 
replace same = 1 if memberfu != check_id 
replace same = 0 if memberfu == ""

*** output list of issues with hhid memberfu differences *** 
preserve 

keep if same == 1 

export excel using "$issues\ID_Issue_102224.xlsx", replace firstrow(variables)

restore 

drop same 

*** create list of houesholds without a trained individual *** 
use "$output/Treated_variables_df", clear 

*** create variable for trained individual identified in household ***
egen trained_in_hh = max(trained_indiv), by(hhid)

*** keep only trained households *** 
keep if trained_hh == 1 

*** create household level dataset *** 
bysort hhid: gen dup = _n 
drop if dup > 1 

*** only keep households for which we cannot identify a trained individual *** 
keep if trained_in_hh == 0

*** only keep hh head name, phone number, hhid, trained_hh and trained_in_hh variables ***
keep hh_head_name_complet hh_phone hhid trained_hh trained_in_hh 

*** output dataset *** 
export excel using "$issues\No_Trained_Inidividual.xlsx", replace firstrow(variables)

