*** DISES Baseline Data - Code used to create Household IDs***
*** File Created By: Kateri Mouawad ***
*** File Last Updated By: Kateri Mouawad ***
*** File Last Updated On: June 13, 2024 ***


 *** This Do File PROCESSES: DISES_Baseline_Household_Corrected_PII
 
  *** This Do File CREATES: 

				
							
 *** Procedure: 
 
clear all 

*** set maximum variables to at least 20,000 ***
set maxvar 20000

**** Master file path  ****

if "`c(username)'"=="socrm" {
                global master "C:\Users\socrm\Box\NSF Senegal"
}
else if "`c(username)'"=="Kateri" {
                global master "C:\Users\Kateri\Box\NSF Senegal"
				
}


global data "$master\Data Work\Output\Data Corrections"



use "$data\DISES_Baseline_Household_Corrected_PII", clear 
replace hh_age_resp = 50 if hhid == "023B09"
*ssc install estout


********************* Household Roster *********************


 *** hh_age *** 
 *think about a way to export this into a maxtrix type format so it's easily doable 
preserve

	keep hh_age* hhid hh_02*
	drop hh_age_resp
	reshape long hh_age_ hh_02_,  i(hhid) j(id)
	estpost summarize hh_age_ hh_02_
	eststo hh_age 

restore 

 *** hh_02 ***

preserve 

	keep hh_02* hhid
	reshape long hh_02_, i(hhid) j(hh_02_id)
	estpost summarize hh_02_ 
	eststo hh_02

restore 


 *** hh_04 ***


preserve 

	keep hh_04* hhid
	reshape long hh_04_, i(hhid) j(hh_04_id)
	estpost summarize hh_04_ 
	eststo hh_04

restore 




esttab hh_age hh_02 hh_04 using summary_stats.rtf, replace rtf ///
    cells("mean min max sd N") ///
    title("Summary Statistics for Selected Variables") ///
    label unstack







preserve 

	keep health_5_5* hhid
	reshape long health_5_5_, i(hhid) j(health_5_5_id)
	estpost summarize health_5_5_ 
	eststo health_5_5_

restore 




preserve
keep health_5_5* hhid
reshape long health_5_5_, i(hhid) j(health_5_5_id)

* Filter to keep observations where health_5_5_ is 0 or 1
keep if health_5_5_ == 0 | health_5_5_ == 1

* Summarize the filtered data
estpost summarize health_5_5_
eststo health_5_5_
restore
















