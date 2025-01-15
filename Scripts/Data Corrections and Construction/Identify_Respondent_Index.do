*** DISES data create variable for index of respondent *** 
*** File Created By: Molly Doruska ***
*** File Last Updated By: Molly Doruska ***
*** File Last Updated On: July 30, 2024 ***

clear all 

set maxvar 20000

**** Master file path  ****

if "`c(username)'"=="socrm" {
                global master "C:\Users\socrm\Box\NSF Senegal\Data Management"
}
else if "`c(username)'"=="km978" {
                global master "C:\Users\km978\Box\NSF Senegal\Data Management"
				
}

*** additional file paths ***
global household_ids "$master\Output\Household IDs"
global data_deidentified "$master\_CRDES_CleanData\Baseline\Deidentified\Baseline"

*** import dataset with index person marked *** 
import excel using "$household_ids\Identify_Respondent_HH_Index.xlsx", clear first 

*** keep only household respondent ***
keep if resp != . 
 
*** rename individual respondent index variable ***
rename individual resp_index 

*** keep only household id and respondent index variable *** 
keep hhid resp_index 

*** output deidentified dataset *** 
save "$data_deidentified\respondent_index.dta"