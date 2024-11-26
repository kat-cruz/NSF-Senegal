*** Misstable explanation code *** 
*** Molly Doruska ***
*** January 24, 2024 ***

clear all 

*** import data *** 
use "C:\Users\socrm\Box\NSF Senegal\Baseline Data Collection\Surveys\Baseline CRDES data (Jan-Feb 2024)\Questionnaire Communautaire - NSF DISES_23jan2024.dta", clear

*** misstable ***
misstable summarize
misstable summarize , generate(missing)
*tab misssingq_24
*keep if misssingq_24 == 1
*keep village_select sup full_name phone_resp q_24
*generate issue = "Missing"
*export excel using Issue_Community.xlsx, firstrow(variables)

foreach var of varlist q_24 q_28a q_29a q_30a q_31a q_32a q_33a q_35 {
    preserve
		keep if missing`var' == 1 
		keep village_select sup full_name phone_resp `var'
		generate issue = "Missing"
		export excel using Community_Issue_`var'.xlsx, firstrow(variables) replace 
	restore
}