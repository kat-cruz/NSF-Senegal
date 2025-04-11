*** DISES data create variable for index of respondent *** 
*** File Created By: Molly Doruska ***
*** Updates recorded in Git


*<><<><><>><><<><><>>
* READ ME
*<><<><><>><><<><><>>

				*** This .do file processes: 
											* Identify_Respondent_HH_Index.xlsx
			    *** This .do file outputs:
											*respondent_index.dta
											
			*Here, we create a variable that identifies the respondent in the baseline deidentified household survey data.

clear all 

set maxvar 20000

**** Master file path  ****

if "`c(username)'"=="socrm" {
                global master "C:\Users\socrm\Box\NSF Senegal\Data_Management"
}
else if "`c(username)'"=="km978" {
                global master "C:\Users\km978\Box\NSF Senegal\Data_Management"
				
}

*** additional file paths ***
global household_ids "$master\Output\Data_Processing\ID_Creation\Baseline"
global data_deidentified "$master\Data\_CRDES_CleanData\Baseline\Deidentified"

*** import dataset with index person marked *** 
import excel using "$household_ids\Identify_Respondent_HH_Index.xlsx", clear first 

*** keep only household respondent ***
keep if resp != . 
 
*** rename individual respondent index variable ***
rename individual resp_index 

*** UPDATE: Correct old HHID: 

replace hhid = "153A" + substr(hhid, 5, .) if substr(hhid, 1, 4) == "132A"



*** keep only household id and respondent index variable *** 
keep hhid resp_index 



*** output deidentified dataset *** 
save "$data_deidentified\respondent_index.dta"