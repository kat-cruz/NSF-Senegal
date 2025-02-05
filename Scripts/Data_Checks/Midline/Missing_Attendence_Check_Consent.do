*** DISES Midline Data Checks - Missing Attendance Checks Consent***
*** File originally created By: Molly Doruska ***
*** Updates recorded in GitHub ***

*>>>>>>>>>>*===========================* READ ME *===========================*<<<<<<<<<<<*


			*1)	Create a file with hhids of children in attendence checks 
			*2) Create a file with hhids with no consent for attendence checks 
			*3)	Merge to create list of hhids missing attendence checks 
			
*==============================================================================

clear all
set mem 100m
set maxvar 30000
set matsize 11000
set more off

**************************************************
* SET FILE PATHS
**************************************************

* Set base Box path for each user
if "`c(username)'"=="socrm" global master "C:\Users\socrm\Box\NSF Senegal"
if "`c(username)'"=="kls329" global master "C:\Users\kls329\Box"
if "`c(username)'"=="km978" global master "C:\Users\km978\Box\NSF Senegal"
if "`c(username)'"=="Kateri" global master "C:\Users\Kateri\Box\NSF Senegal"
if "`c(username)'"=="admmi" global master "C:\Users\admmi\Box\NSF Senegal"


**************************** data file paths ****************************

global hh_data "$master\Data Management\_CRDES_RawData\Midline\Household_Survey_Data"
global attend_data "$master\Data Management\_CRDES_RawData\Midline\Principal_Survey_Data"
global hhids "$master\Data Management\Output\Household_IDs"

**************************** output file paths ****************************

global output "$master\Data Management\Output\Data_Quality_Checks\Midline\R2_Principal_Issues"

*** import attendence checks data *** 
import delimited "$attend_data\DISES_ Principal Survey MIDLINE VF_WIDE_4Feb25_2200.csv", clear varnames(1) bindquote(strict)

*** create list of hhid's in attendence checks *** 
keep pull_hhid* 

drop pull_hhid_village*

gen entry = _n

reshape long pull_hhid_, i(entry) j(childindex)

drop if pull_hhid_ == ""

*** get rid of duplicate hhid's *** 
bysort pull_hhid_: gen dup = _n 

drop if dup > 1 

rename pull_hhid hhid 

*** save list of hhids with attendence checks *** 
save "$output\hhids_attendence_checks.dta", replace 

*** import household data *** 
import delimited "$hh_data\DISES_Enquête ménage midline VF_WIDE_4Feb25_2200.csv", clear varnames(1) bindquote(strict)

*** get rid of duplicate hhids *** 
drop if hh_global_id == ""

bysort hh_global_id: gen dup = _n

drop if dup > 1 

*** keep hhid's, phone numbers, and attendence check consent ***
keep hh_phone hh_global_id hh_49 

keep if hh_49 == . 

drop if hh_global_id == ""

rename hh_global_id hhid 
rename hh_49 attendence_check_consent

order hhid, first 

merge 1:1 hhid using "$hhids\Complete_HouseholdIDs.dta"

drop _merge 

*** merge in attendence check hhids *** 
merge 1:1 hhid using "$output\hhids_attendence_checks.dta"

keep if _merge == 3 

drop villageid entry childindex _merge 

order hhid_village hhid, first  

*** save data file of attendence checks without consent *** 
save "$output\missing_attendence_check_consent.dta", replace 
export excel using "$output\missing_attendence_check_consent_4Feb25.xslx", firstrow(variables) replace 