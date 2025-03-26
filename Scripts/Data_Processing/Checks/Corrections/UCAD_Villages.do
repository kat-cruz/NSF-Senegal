*** DISES data create individual identifiers *** 
*** File Created By: Kateri Mouawad ***
*** File Last Updated By: Kateri Mouawad ***
*** File Last Updated On: October 28, 2024 ***


  *** READ ME: This .Do file outputs the EPLS villages in an Excel format for the purpose of doing individual level matches across EPLS villages. 


  *** This Do File PROCESSES: All_Villages.dta	- A dataframe that contains specified variables and individual IDS created in the Individual_Level_IDs .do file. 			 		
                            
  *** This Do File CREATES: 
                            ** Village_Diabobes_030B.xlsx
							** Village_Diaminar_Loyene_022A.xlsx
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

*** additional file paths ***

global data "$master\_PartnerData\Village Data (check)"
global output "$master\My projects\UCAD and DISES data\Villages"


********************************************** Export UCAD villages ***************************************************

use "$data\All_Villages.dta"

rename hh_relation_with_ hh_relation_with
tostring  hh_relation_with, gen(hh_relation)

replace hh_relation = "Head of household (himself)" if hh_relation_with == 1
replace hh_relation = "Spouse of head ofhousehold" if hh_relation_with == 2
replace hh_relation = "Son/daughter of the home" if hh_relation_with == 3
replace hh_relation = "Spouse of the son/daughterof the head of the family" if hh_relation_with == 4
replace hh_relation = "Grandson/granddaughter of the head of the family" if hh_relation_with == 5
replace hh_relation = "Father/Mother of the HH" if hh_relation_with == 6
replace hh_relation = "Father/Mother of the spouse of the head of the family" if hh_relation_with == 7
replace hh_relation = "Brother/sister of the head ofthe family" if hh_relation_with == 8
replace hh_relation = "Brother/sister of the HH's spouse" if hh_relation_with == 9
replace hh_relation = "Adopted child" if hh_relation_with == 10
replace hh_relation = "House help" if hh_relation_with == 11
replace hh_relation = "Other person related to the head of the family" if hh_relation_with == 12
replace hh_relation = "Other person not related to the head of the family" if hh_relation_with == 13

drop indiv_index hh_relation_with individual
rename hhid_village villageid

preserve 

	keep if villageid == "030B"
	keep if hh_age_ <= 18
	count if !missing(hh_age_)


	*export excel using "$output\Village_Diabobes_030B.xlsx", firstrow(variables) sheet("Diabobes (030B)") replace

restore 


preserve 

	keep if villageid == "022A"
	
	keep if hh_age_ <= 18
	count if !missing(hh_age_)

	*export excel using "$output\Village_Diaminar_Loyene_022A.xlsx", firstrow(variables) sheet("Diaminar Loyene (022A)") replace

restore 

preserve 

	keep if villageid == "032A"
	keep if hh_age_ <= 18
	count if !missing(hh_age_)

	*export excel using "$output\Village_Dioss_Peulh_032A.xlsx", firstrow(variables) sheet("Dioss Peulh (032A)") replace 

restore 

preserve 

	keep if villageid == "072B"
	keep if hh_age_ <= 18
	count if !missing(hh_age_)

	*export excel using "$output\Village_Dodel_072B.xlsx", firstrow(variables) sheet("Dodel (072B)") replace 

restore 

preserve 

	keep if villageid == "021A"
	keep if hh_age_ <= 18
	count if !missing(hh_age_)

	*export excel using "$output\Village_El_Debiyaye_Maraye_II_021A.xlsx", firstrow(variables) sheet("El Debiyaye Maraye II (021A)") replace 

restore 

preserve 

	keep if villageid == "062B"
	keep if hh_age_ <= 18
	count if !missing(hh_age_)

	*export excel using "$output\Village_Fanaye_Diery_062B.xlsx", firstrow(variables) 	sheet("Fanaye Diery (062B)") replace 

restore 

preserve 

	keep if villageid == "033A"
	keep if hh_age_ <= 18
	count if !missing(hh_age_)

	*export excel using "$output\Village_Keur_Momar_Sarr_033A.xlsx", firstrow(variables) sheet("Keur Momar Sarr (033A)") replace 
	
restore 

preserve 

	keep if villageid == "030A"
	keep if hh_age_ <= 18
	count if !missing(hh_age_)

	*export excel using "$output\Village_Kassack_Nord_030A.xlsx", firstrow(variables) sheet("Kassack Nord (030A)") replace 

restore 


preserve 

	keep if villageid == "023B"
	keep if hh_age_ <= 18
	count if !missing(hh_age_)

	*export excel using "$output\Village_Mberaye_023B.xlsx", firstrow(variables) sheet("Mberaye (023B)") replace 

restore 

preserve 

	keep if villageid == "020A"
	keep if hh_age_ <= 18
	count if !missing(hh_age_)

	*export excel using "$output\Village_Ndiamar_020A.xlsx", firstrow(variables) sheet("Ndiamar (023B)") replace 

restore 

preserve 

	keep if villageid == "020B"
	keep if hh_age_ <= 18
	count if !missing(hh_age_)

	*export excel using "$output\Village_Ndiayene_Pendao_020B.xlsx", firstrow(variables) sheet("Ndiayene Pendao (020B)") replace

restore 

preserve 

	keep if villageid == "031B"
	keep if hh_age_ <= 18
	count if !missing(hh_age_)

	*export excel using "$output\Village_Saneinte_Tacque_031B.xlsx", firstrow(variables) sheet("Saneinte Tacque (031B)") replace

restore 

preserve 

	keep if villageid == "021B"
	keep if hh_age_ <= 18
	count if !missing(hh_age_)

	*export excel using "$output\Village_Thilla_Boubacar_021B.xlsx", firstrow(variables) sheet("Thilla Boubacar (021B)") replace

restore 


preserve 

	keep if villageid == "130A"
	keep if hh_age_ <= 18
	count if !missing(hh_age_)

	*export excel using "$output\Village_Yamane_130A.xlsx", firstrow(variables) sheet("Yamane (130A)") replace

restore 

preserve 

	keep if villageid == "033B"
	keep if hh_age_ <= 18
	count if !missing(hh_age_)

	*export excel using "$output\Village_Yetti_Yoni_033B.xlsx", firstrow(variables) sheet("Yetti Yoni (033B)") replace

restore 




















