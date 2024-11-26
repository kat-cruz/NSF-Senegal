*** DISES Baseline Data Checks ***
*** File Created By: Kateri Mouawad ***
*** File Last Updated By: Kateri Mouawad ***
*** File Last Updated On: Febuary 22, 2024 ***

clear all 

**** Master file path ****
global master "C:\Users\kateri\Box\NSF Senegal\Baseline Data Collection"

global data "$master\Surveys\Baseline CRDES data (Jan-Feb 2024)"

global file "$master\Data Quality Checks\Other checks\Unique primary school & phone numbers\Data sets and extra spread sheets"

global finish "$master\Data Quality Checks\Other checks\Unique primary school & phone numbers"


*************************** import community survey data ************************************************
clear
import delimited "$data\Questionnaire Communautaire - NSF DISES_WIDE_6Feb24.csv", clear varnames(1) bindquote(strict)

*** drop test data ***
drop if strmatch(date, "Jan 10, 2024")

*** tab q_18 to see how many educational facilitiies there are 
*** 73 institutions identify as educational facilities 
*tab q_18

***************************** determine name of villages for CARTO matching *************

tab q56_2



* Use location as a means of identifiying unique primary schools:
********************************* primary school LOWER bound ********************
preserve 

	gen has_primary = 0
	replace has_primary = 1 if q_52 > 0 & q_52 < 3
	*keep if has_primary == 1
	rename q56_3 principle_phone
	rename q56_2 principle_name 
	rename q_52 distance_to_primary
	keep hhid_village sup phone_resp has_primary principle_phone principle_name distance_to_primary
	
save "$file\Unique Primary School Lower Bound.dta", replace 	
export excel using "$file\Unique Primary School Lower Bound.xlsx", firstrow(variables) sheet("Sheet 1") replace

restore 
******************************* primary school UPPER bound  *************************

preserve 

	gen has_primary = 0
	replace has_primary = 1 if q_52 >= 0 & q_52 < 3
	*keep if has_primary == 1
	rename q56_3 principle_phone
	rename q56_2 principle_name 
	rename q_52 distance_to_primary
	keep hhid_village sup phone_resp distance_to_primary has_primary principle_phone principle_name
	
save "$file\Unique Primary School Upper Bound.dta ", replace 	
export excel using "$file\Unique Primary School Upper Bound.xlsx", firstrow(variables) sheet("Sheet 1") replace

restore 

*** To see unique counts of desired variable ***

levelsof hhid_village, local(unique_values)
local num_unique : word count `unique_values'
di "Number of unique values in hhid_village: `num_unique'"



****************************** other educational insitutions present ****************************************

************** public high schools LOWER bound **************

preserve 

	gen has_public_highschool = 0
	replace has_public_highschool = 1 if q_57 > 0 & q_57 < 3
	*keep if has_public_highshcool == 1
	rename q_57 distance_to_public_high_school
	keep hhid_village sup phone_resp has_public_highschool distance_to_public_high_school
	
	
export excel using "$file\Unique Public High School Lower Bound.xlsx", firstrow(variables) sheet("Sheet 1") replace
save "$file\Unique Public High School Lower Bound.dta", replace
restore 

************** public high schools UPPER bound **************
preserve 

	gen has_public_highschool = 0
	replace has_public_highschool = 1 if q_57 >= 0 & q_57 < 3

	*keep if has_public_highschool == 1
	rename q_57 distance_to_public_high_school
	keep hhid_village sup phone_resp has_public_highschool distance_to_public_high_school
	
	
export excel using "$file\Unique Public High School Upper Bound.xlsx", firstrow(variables) sheet("Sheet 1") replace
save "$file\Unique Public High School Upper Bound.dta", replace

restore 

************** islamic schools lower bound **************
preserve 

	gen has_islamic_school = 0
	replace has_islamic_school = 1 if  q60 > 0 &  q60 < 3

	*keep if ind_var == 1
	rename  q60 distance_to_islamic_school
	keep hhid_village sup phone_resp distance_to_islamic_school has_islamic_school
	
export excel using "$file\Unique Islamic School Lower Bound.xlsx", firstrow(variables) sheet("Sheet 1") replace
save  "$file\Unique Islamic School Lower Bound.dta", replace 
restore 


************** islamic schools upper bound **************
preserve 

	gen has_islamic_school = 0
	replace has_islamic_school = 1 if  q60 >= 0 &  q60 < 3

	keep if has_islamic_school == 1
	rename  q60 distance_to_islamic_school
	keep hhid_village sup phone_resp distance_to_islamic_school has_islamic_school

	
export excel using "$file\Unique Islamic School Upper Bound.xlsx", firstrow(variables) sheet("Sheet 1") replace
save  "$file\Unique Islamic School Upper Bound.dta", replace 
restore 


**************************** lower bound merge ***************************
preserve 
clear
use "$file\Unique Primary School Lower Bound.dta"
merge m:m hhid_village using "$file\Unique Islamic School Lower Bound.dta"
merge m:m hhid_village using "$file\Unique Public High School Lower Bound.dta" , generate(merge1_1)

*keep hhid_village has_islamic_school has_public_highschool has_primary has_islamic_school distance_to_islamic_school distance_to_public_high_school distance_to_primary 

keep hhid_village has_islamic_school has_public_highschool has_primary has_islamic_school 

export excel using "$finish\School Comparison Lower Bound.xlsx", firstrow(variables) sheet("Sheet 1") replace
save  "$file\School Comparison Lower Bound.dta", replace 
restore
****************************** upper bound merge **************************
preserve
clear
use "$file\Unique Primary School Upper Bound.dta"
merge m:m hhid_village using "$file\Unique Islamic School Upper Bound.dta"
merge m:m hhid_village using "$file\Unique Public High School Upper Bound.dta" , generate(merge1_1)
keep hhid_village has_islamic_school has_public_highschool has_primary has_islamic_school 

export excel using "$finish\School Comparison Upper Bound.xlsx", firstrow(variables) sheet("Sheet 1") replace
save  "$file\School Comparison Upper Bound.dta", replace 
restore



*****************************  import household data *********************************************************
clear 
set maxvar 20000

import delimited "$data\DISES_enquete_ménage_FINALE_WIDE_6Feb24.csv", clear varnames(1) bindquote(strict)


********************* create unique hh identifiers  *************************

	*** sort data by village ***
	sort village_select 

	*** generate unique household integer in the village ***
	by village_select: gen hh_num = _n 

	*** create two digit unique string for each household in the village ***
	gen hh_id_num = string(hh_num, "%02.0f") 

	*** extract off the village id number ***
	gen villageid = substr(village_select_o, 1, 4)

	*** create unique household identifier using the village identier ***
	*** and the household identifier ***
	egen hhid = concat(villageid hh_id_num)

******************************** filter phone numbers **************************
preserve 

	*sort duplicates 
    quietly bysort hh_phone : gen dup = cond(_N==1,0,_n)
	drop if dup >= 1
	
	gen ind_var = 0
	
    replace ind_var = 1 if hh_phone == 777777777 | hh_phone == 775555555
	replace ind_var = 1 if hh_phone == .
	label variable sup "supervisor's name"
	keep if ind_var == 0 
	keep hhid hhid_village sup hh_phone 
	
	
*save "$finish\Unique Household Phone Numbers.dta", replace
export excel using "$finish\Unique Household Phone Numbers.xlsx", firstrow(variables) sheet("Sheet 1") replace
	
restore 


*********************************** share of phone numbers *************************

preserve 

	*sort duplicates 

	gen ind_var = 0
	
	keep if hh_phone != 999
    *replace ind_var = 1 if hh_phone == 777777777 | hh_phone == 775555555
	replace ind_var = 1 if hh_phone == .
	label variable sup "supervisor's name"
	keep if ind_var == 0 
	keep hhid hhid_village sup hh_phone 
	
	
*save "$file\Nonunique Household Phone Numbers with trailing 7s and 5s.dta", replace
export excel using "$finish\Non-Unique Household Phone Numbers with trailing 7s and 5s.xlsx", firstrow(variables) sheet("Sheet 1") replace
	
restore
























