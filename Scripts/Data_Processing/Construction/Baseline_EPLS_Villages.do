*** DISES data create individual identifiers *** 
*** File Created By: Kateri Mouawad ***
*** File Last Updated By: Kateri Mouawad ***
*** File Last Updated On: May 20, 2024 ***


  *** READ ME: This .Do file outputs the EPLS villages in an Excel format for the purpose of doing individual level matches across EPLS villages. 


  *** This Do File PROCESSES: All_Villages.dta	- A dataframe that contains specified variables and individual IDS created in the Individual_Level_IDs .do file. 			 		
                            
  *** This Do File CREATES: 
                            ** village 010A.xlsx
							** village 010B.xlsx
							** village 011A.xlsx							
							** village 011B.xlsx							
 							** village 012A.xlsx
							** village 012B.xlsx							
							** village 013A.xlsx							
							** village 013B.xlsx							
							** village 023A.xlsx							
							** village 120B.xlsx							
							** village 121B.xlsx							
							** village 122A.xlsx							
							** village 123A.xlsx							
							** village 131B.xlsx							
							
							
 ** UPDATE NOTES: These Excel spreadsheets have all been renamed to ensure no overwriting could occur. 


clear all 

set maxvar 20000

**** Master file path  ****

if "`c(username)'"=="socrm" {
                global master "C:\Users\socrm\Box\NSF Senegal\Data Management"
}
else if "`c(username)'"=="km978" {
                global master "C:\Users\km978\Box\NSF Senegal\Data Management"
				
}
else if "`c(username)'"=="Kateri" {
                global master "C:\Users\Kateri\Box\NSF Senegal\Data Management"
				
}


*** additional file paths ***

global data "$master\_PartnerData\EPLS and DISES data\Household & Individual IDs"
global output "$master\_PartnerData\EPLS and DISES data\Cleaning"
global oldvillage "$master\_PartnerData\EPLS and DISES data\Archive Village Checks"

********************************************** Export EPLS villages ***************************************************



use "$data\All_Villages.dta", clear

drop hh_relation_with_o_
tostring  hh_relation_with_, gen(hh_relation)
replace hh_relation = "Head of household (himself)" if hh_relation_with == 1
replace hh_relation = "Spouse of head ofhousehold" if hh_relation_with == 2
replace hh_relation = "Son/daughter of the home" if hh_relation_with == 3
replace hh_relation = "Spouse of the son/daughterof the head of the family" if hh_relation_with == 4
replace hh_relation = "Grandson/granddaughter ofthe head of the family" if hh_relation_with == 5
replace hh_relation = "Father/Mother of the HH" if hh_relation_with == 6
replace hh_relation = "Father/Mother of the spouseof the head of the family" if hh_relation_with == 7
replace hh_relation = "Brother/sister of the head ofthe family" if hh_relation_with == 8
replace hh_relation = "Brother/sister of the HH's spouse" if hh_relation_with == 9
replace hh_relation = "Adopted child" if hh_relation_with == 10
replace hh_relation = "House help" if hh_relation_with == 11
replace hh_relation = "Other person related to thehead of the family" if hh_relation_with == 12
replace hh_relation = "Other person not related to the head of the family" if hh_relation_with == 13


preserve 

keep if villageid == "010A"

export excel using "$output\village 010A.xlsx", firstrow(variables) sheet("Sheet 1") replace

restore 


preserve 

keep if villageid == "010B"

export excel using "$output\village 010B.xlsx", firstrow(variables) replace

restore 

preserve 

keep if villageid == "011A"

export excel using "$output\village 011A.xlsx", firstrow(variables) replace

restore 

preserve 

keep if villageid == "011B"

export excel using "$output\village 011B.xlsx", firstrow(variables) replace

restore 

preserve 

keep if villageid == "012A"

export excel using "$output\village 012A.xlsx", firstrow(variables) replace

restore 

preserve 

keep if villageid == "012B"

export excel using "$output\village 012B.xlsx", firstrow(variables) replace
restore 

preserve 

keep if villageid == "023A"

export excel using "$output\village 023A.xlsx", firstrow(variables) replace
restore 

preserve 

keep if villageid == "013A"

export excel using "$output\village 013A.xlsx", firstrow(variables) replace
restore 


preserve 

keep if villageid == "013B"

export excel using "$output\village 013B.xlsx", firstrow(variables) replace
restore 

************************************ newly added 5 EPLS villages **************************************************



preserve 

	keep if hhid_village == "122A"

	export excel using "$output\village 122A.xlsx", firstrow(variables) replace

	save "$output\village 122A.dta", replace 

restore 

preserve 

	keep if hhid_village == "123A"

	export excel using "$output\Mbarigo_123A.xlsx", firstrow(variables) sheet("Sheet 1") replace

	save "$output\Mbarigo_123A.dta", replace 

restore 

preserve 

	keep if hhid_village == "121B"

	export excel using "$output\Foss_121B.xlsx", firstrow(variables) replace
	
	save "$output\Foss_121B.dta", replace

restore 

preserve 

	keep if hhid_village == "131B"

	export excel using "$output\Malla_131B.xlsx", firstrow(variables) replace

	save "$output\Malla_131B.dta", replace

restore 

preserve 

	keep if hhid_village == "120B"

	export excel using "$output\Syer_120B.xlsx", firstrow(variables) replace

	save "$output\Syer_120B.dta", replace

restore 

******************************** SORT out IDs to determine which kids have the wrong IDs *****************************************



*************************************** Mbakhana - village 122A_done.dta ***************************************

use "$oldvillage/village 122A_done.dta", clear

rename villageid hhid_village

	/*
	merge 1:1 individ using "$output/village 122A_new.dta"


	duplicates tag hh_age_ hh_full_name_calc_ hhid_village, gen(ugh)

	sort ugh 

	tab ugh

	keep if ugh == 1

	sort hh_full_name_calc_

	duplicates drop hh_age_ hh_full_name_calc_ hhid_village, force 
	*/
	merge m:m hh_age_ hh_full_name_calc_ hhid_village using "$output/village 122A_new.dta"

	merge 1:1 individ using "$output/village 122A_new.dta"

** No updated data so we're good **

*************************************** Mbarigo_123A.xlsx ***************************************

use "$oldvillage/village 123A_done.dta", clear

	rename villageid hhid_village

	merge 1:1 hh_age_ hh_full_name_calc_ hhid_village using "$output/Mbarigo_123A.dta"

	duplicates tag hh_age_ hh_full_name_calc_ hhid_village, gen(shet)

	duplicates report hh_age_ hh_full_name_calc_ hhid_village

**** No updated data so we're good 


*************************************** Foss_121B.xlsx ***************************************

import excel "$oldvillage/village 121B_done.xlsx", firstrow clear

save "$oldvillage/village 121B_done.dta", replace 


use "$oldvillage/village 121B_done.dta", clear

	rename villageid hhid_village

	merge m:m hh_age_ hh_full_name_calc_ hhid_village using "$output/Foss_121B.dta"
	
	drop if hhid == ""

	**duplicates tag hh_age_ hh_full_name_calc_ hhid, gen(shet)

	duplicates report hh_age_ hh_full_name_calc_ hhid

	sort _merge 

	export excel using "$output\Foss_121B TO DO.xlsx", firstrow(variables) replace

*************************************** Malla_131B.xlsx ***************************************	

/*
import excel "$oldvillage/village 131B_done.xlsx", firstrow clear

save "$oldvillage/village 131B_done.dta", replace 
*/


use "$oldvillage/village 131B_done.dta", clear

	rename villageid hhid_village

	merge m:m hh_age_ hh_full_name_calc_ hhid_village using "$output/Malla_131B.dta"
	
	drop if hhid == ""

	**duplicates tag hh_age_ hh_full_name_calc_ hhid, gen(shet)

	duplicates report hh_age_ hh_full_name_calc_ hhid

	sort _merge 

	export excel using "$output\Malla_131B TO DO.xlsx", firstrow(variables) replace
	
	
*************************************** Syer_120B.xlsx ***************************************	

use "$oldvillage/village 120B_done.dta", clear

	rename villageid hhid_village

	merge m:m hh_age_ hh_full_name_calc_ hhid_village using "$output/Syer_120B.dta", force
	
	drop if hhid == ""

	**duplicates tag hh_age_ hh_full_name_calc_ hhid, gen(shet)

	duplicates report hh_age_ hh_full_name_calc_ hhid

	sort _merge 

	export excel using "$output\Syer_120B TO DO.xlsx", firstrow(variables) replace
