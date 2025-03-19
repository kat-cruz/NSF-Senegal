*==============================================================================

* written by: Kateri Mouawad
* Created: February 2025
* Updates recorded in GitHub


* <><<><><>> Read Me  <><<><><>>


*<><<><><>><><<><><>>
* INITIATE SCRIPT
*<><<><><>><><<><><>>
		
clear all
set mem 100m
set maxvar 30000
set matsize 11000
set more off

*<><<><><>><><<><><>>
* SET FILE PATHS
*<><<><><>><><<><><>>

*^*^* Set base Box path for each user
if "`c(username)'"=="socrm" global master "C:\Users\socrm\Box\NSF Senegal"
if "`c(username)'"=="kls329" global master "C:\Users\kls329\Box\NSF Senegal"
if "`c(username)'"=="km978" global master "C:\Users\km978\Box\NSF Senegal"
if "`c(username)'"=="Kateri" global master "C:\Users\Kateri\Box\NSF Senegal"
if "`c(username)'"=="admmi" global master "C:\Users\admmi\Box\NSF Senegal"


*^*^* Define project-specific paths
global data "$master\Data_Management\_CRDES_CleanData\Midline\Identified"
*global output "$master\Data_Management\_Partner_CleanData\Parasitological_Analysis_Data\Analysis_Data"

global baseline "$master\Data_Management\_CRDES_CleanData\Baseline\Identified"

*<><<><><>><><<><><>>
* LOAD IN DATA
*<><<><><>><><<><><>>

use "$data\DISES_Midline_Complete_PII.dta", clear

*<><<><><>><><<><><>>
* INITIAL CLEANING
*<><<><><>><><<><><>>


	tostring hh_full_name_calc*, replace 
	tostring hh_relation_with_o*, replace 
	tostring pull_hh_individ_*, replace
	tostring pull_hh_full_name_calc__*, replace 
	tostring hh_full_name_calc_*, replace 
	
	
*<><<><><>><><<><><>>
* KEEP RELEVANT VARIABLES
*<><<><><>><><<><><>>


	keep hhid hhid_village pull_hh_individ_* ///
	hh_head_name_complet hh_name_complet_resp hh_age_resp hh_gender_resp pull_hh_full_name_calc__* hh_full_name_calc_* ///
	hh_gender* pull_hh_age__*  hh_relation_with* ///
	hh_phone hh_name_complet_resp_new replaced


*<><<><><>><><<><><>>
* KEEP RELEVANT VARIABLES
*<><<><><>><><<><><>>

	reshape long pull_hh_individ_ hh_full_name_calc_ hh_gender_ pull_hh_age__ ///
	hh_relation_with_ hh_relation_with_o_  ///
	pull_hh_full_name_calc__, ///
		i(hhid_village hhid hh_name_complet_resp_new hh_name_complet_resp hh_head_name_complet hh_age_resp hh_gender_resp hh_phone replaced) j(individual)

		rename hh_name_complet_resp hh_individ_complet_resp
		rename hhid_village villageid

	merge m:m villageid hh_individ_complet_resp using "$baseline\All_Villages_With_Individual_IDs_Selected_Vars.dta"
		drop _merge

	replace hh_name_complet_resp = hh_name_complet_resp_new if hh_individ_complet_resp == "999"
		drop hh_name_complet_resp_new 


		rename hh_relation_with_o_ other_relation
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
		replace hh_relation = "Niece/Nephew" if hh_relation_with == 14


		drop hh_relation_with individual

		rename pull_hh_age__ hh_age

		drop if hh_age & hh_gender_  == .
			
			
			keep if villageid == "020B"
			keep if villageid == "090B" 




