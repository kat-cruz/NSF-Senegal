*** Create date of treatment variable for each village ***
*** File Created By: Molly Doruska ***
*** File Last Updated By: Molly Doruska ***
*** File Last Updated On: January 16, 2025 ***


 *** This Do File PROCESSES: treatment_planning_exercise_PII.dta
 
  *** This Do File CREATES: treatment_dates.dta, treatment_dates.csv 
				
							
 *** Procedure: 
 *(1) Run the file paths
 *(2) Load in the data
 *(3) Run the script that gets rid of PII in the treatment data 
 *(4) Save the de-idnetified data
 
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
global deidentifed "$master\Data Management\_CRDES_CleanData\Treatment\Deidentified"
global identifed "$master\Data Management\_CRDES_CleanData\Treatment\Identified"

*** save complete identifed data *** 
use "$identifed\treatment_planning_exercise_PII.dta", clear 

*** keep village ID and date of visit *** 
keep village_code date_visit

replace date_visit = "Jul 7, 2024" if village_code == "062A"

order village_code, first 

gen month = substr(date_visit,1,3)

*** save treatment date dataset *** 
save "$deidentifed\treatment_dates.dta"

export delimited "$deidentifed\treatment_dates.csv", 