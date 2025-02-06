*** DISES Baseline Data Checks ***
*** File Created By: Molly Doruska ***
*** File Last Updated By: Kateri Mouawad ***
*** File Last Updated On: February 06, 2025 ***
*KRM - updated file paths. All updates recorded on GitHub. 

clear all 

**** Master file path  ****

if "`c(username)'"=="socrm" {
                global master "C:\Users\socrm\Box\NSF Senegal\Data_Management"
}
else if "`c(username)'"=="Kateri" {
                global master "C:\Users\Kateri\Box\NSF Senegal\Data_Management"
				
}
global community "$master\Data_Quality_Checks\Baseline\Jan-Feb_Output\Community_Issues"
global issues "$master\Data_Quality_Checks\Baseline\Jan-Feb_Output\1_Full_Issues"

global data "$master\_CRDES_RawData\Baseline"

*** import community survey data ***
import delimited "$data\Questionnaire Communautaire - NSF DISES_WIDE_6Feb24.csv", clear varnames(1) bindquote(strict)

*** drop test data ***
drop if strmatch(date, "Jan 10, 2024")

*** label variables ***
label variable number_hh "Nombre de menages dans le village"
label variable number_total "Population du village (# personnes)"
label variable city_near "Nom de la grande ville la plus proche"
label variable q_16 "Est-ce que le village a installations de transport (par exemple, arret de bus)"
label variable q_17 "Est-ce que le village a routes pavees menant au village"
label variable q_18 "Est-ce que le village a installations educatives (par exemple, ecole)"
label variable q_19 "Est-ce que le village a installations de sante (par exemple, centre de sante)"
label variable q_20 "Est-ce que le vilalge a facilites bancaires/microfinance"
label variable q_21 "Est-ce que le village a kiosques d'argent mobile (par exemple, Orange Money)"
label variable q_22 "Est-ce que le village a preteur informel"
label variable q_23 "Est-ce que le village a eau portable coruant pour boire"
label variable q_24 "Est-ce que le village a systeme d'eau par robinet"
label variable q_25 "Est-ce que le village a electricite du reseau"
label variable q_26 "Est-ce que le village a latrines publiques"
label variable q_27 "Est-ce que le village a decharge d'ordeurs"
label variable q_28 "Est-ce que le village a groupement(s) agricole/paysan"
label variable q_28a "Nombre de participants aux groupements agricoles/paysans"
label variable q_29 "Est-ce que le village a groupment(s) d'entreprises"
label variable q_29a "Nombre de participants aux groupements d'entreprises"
label variable q_30 "Est-ce que le vilalge a groupement(s) de credit/finacier/d'entraide"
label variable q_30a "Nombre de participants aux groupements de credit/finacier/d'entraide"
label variable q_31 "Est-ce que le village a groupement(s) de femmes"
label variable q_31a "Nombre de participants aux groupements de femmes"
label variable q_32 "Est-ce que le vilalge a groupement(s) de jeunes"
label variable q_32a "Nombre de participants aux groupements de jenues"
label variable q_33 "Est-ce que le village a groupement(s) religieux"
label variable q_33a "Nombre de participants aux groupements religieux"
label variable q_34 "Est-ce que le village a service de vulgarisation agricole"
label variable q_35_check "Est-ce qu'il y a eu un traitement vermifuge effectué par le ministère de la santé ou une autre organisation"
label variable q_35 "Quelle est la date du dernier traitement vermifuge effectué par le ministère de la santé ou une autre organisation"
label variable q_36 "Quelle organisation l'a mis en place (traitement vermifuge)"
label variable q_37 "Dans le village, y a-t-il actuellement des projets de développement en cours visant à stimuler la productivité agricole"
label variable q_38 "Quelle organisation l'a mis en place (projets de developpement en cours visant a stimuler la productivite agricole)"
label variable q_39 "Dans le village, y a-t-il actuellement des projets en cours visant a reduire la prévalence de la bilharziose"
label variable q_40 "Quelle organisation l'a mis en place (projets en cours visant a reduire la prévalence de la bilharziose)"
label variable q_41 "Dans le village, y a-t-il actuellement des projets en cours visant a ameliorer la gestion de l'eau"
label variable q_42 "Quelle organisation l'a mis en place (projets en cours visant a ameliorer la gestion de l'eau)"
label variable q_43 "Combien de minutes faut-il pour aller au magasin le plus proche (celui où vous pouvez acheter du riz) a pied"
label variable q_44 "Combien de minutes faut-il pour aller au magasin le plus proche (celui où vous pouvez acheter du riz) en voiture/moto"
label variable q_45 "Combien de minutes faut-il pour aller au medecin le plus proche a pied"
label variable q_46 "Combien de minutes faut-il pour aller au medecin le plus proche en voiture/moto"
label variable q_47 "A quelle distance est le marche hebdomadaire le plus proche (en kilometres)"
label variable q_48 "A quelle distance se trouve l'arret de bus le plus proche (en kilometres)"
label variable q_49 "A quelle distance se trouve le point d'eau le plus proche (en kilometres)"
label variable q_50 "A quelle distance se trouve la route bitumee la plus proche le plus proche (en kilometres)"
label variable q_51 "A quelle distance se trouve l'infrastructure de sante la plus proche (en kilometres)"
label variable q_52 "Quelle est la distance a l'ecole primaire publique la plus proche desservant cette communaute (en kilometre)"
label variable q_53 "Combien de salles de classe y a-t-il dans l'ecole primaire publique la plus proche"
label variable q_54 "Dans cette ecole, combien de salles de classe ne sont pas construites en briques avec des toits en tole ou avec d'autres materiaux de construction permanents"
label variable q_55 "Combien d'eleves fréquentent regulierement l'ecole primaire publique la plus proche"
label variable q_57 "Quelle est la distance a l'ecole secondaire publique la plus proche desservant cette communaute (en kilometre)"
label variable q_58 "Combien de salles de classe y a-t-il dans l'ecole secondaire publique gouvernementale la plus proche"
label variable q60 "Quelle est la distance a l'ecole islamique (madrasa) la plus proche desservant cette communaute (en km)"
label variable q61 "Combien d'eleves frequentent regulierement l'ecole islamique (madrasa) la plus proche"
label variable q62 "Quel est le principal aliment de base dans le village"
label variable q62_o "Autre a precise (aliment de base)"
label variable q63_1 "Quel est le prix que les menages dans le village paient pour a l’heure actuelle Uree (CFA par kilogramme)"
label variable q63_2 "Quel est le prix que les menages dans le village paient pour a l’heure actuelle Fumier (CFA par kilogramme)"
label variable q63_3 "Quel est le prix que les menages dans le village paient pour a l’heure actuelle Riz (CFA par kilogramme)"
label variable q63_4 "Quel est le prix que les menages dans le village paient pour a l’heure actuelle Mais (CFA par kilogramme)" 
label variable q63_5 "Quel est le prix que les menages dans le village paient pour a l’heure actuelle Mil (CFA par kilogramme)"
label variable q63_6 "Quel est le prix que les menages dans le village paient pour a l’heure actuelle Sorgho (CFA par kilogramme)"
label variable q63_7 "Quel est le prix que les menages dans le village paient pour a l’heure actuelle Niebe (CFA par kilogramme)"
label variable q63_8 "Quel est le prix que les menages dans le village paient pour a l’heure actuelle Tomates (CFA par kilogramme)"
label variable q63_9 "Quel est le prix que les menages dans le village paient pour a l’heure actuelle Oignons (CFA par kilogramme)"
label variable q63_10 "Quel est le prix que les menages dans le village paient pour a l’heure actuelle Arachides (CFA par kilogramme)"
label variable q64 "Combien un ouvrier agricole du village gagne-t-il en moyenne par jour pendant la recolte la plus recent"
label variable q65 "Combien un technicien agricole du village gagne-t-il en moyenne par jour a l’heure actuelle "
label variable q66 "Combien un ouvrier non-agricole du village gagne-t-il en moyenne par jour a l’heure actuelle"
label variable q67 "Y a-t-il autre chose que nous devons savoir sur votre village"

*** define value labels ***
label define yesno 1 "Oui" 0 "Non"
label define aliment 1 "Mais" 2 "Riz" 3 "Ble" 4 "Pommes de terr" 5 "Manoic" 6 "Soja" 7 "Patates douces" 8 "Ignames" 9 "Sorgho" 10 "Plantain" -95 "Autre" -9 "Ne sais pas/Ne reponds pas"

*** add value labels to variables ***
label values q_16 q_17 q_18 q_19 q_20 q_21 q_22 q_23 q_24 q_25 q_26 q_27 q_28 q_29 q_30 q_31 q_32 q_33 q_34 q_35_check q_37 q_39 q_41 yesno
label values q62 aliment


*** Value Checks ***

* a. Check for missing values in the variables below:
* PROBLEM: first variable NOT being detected - need to run through misstable first 
misstable summarize, generate(missing)

*********************** CHECK THIS LIST AGAINST MISSING VALUES ***********************
*********************** ONLY RUN THOSE WITH MISSING VALUES ***************************
************************ CURRENTLY NONE SO THIS LOOP IS COMMENTED OUT ****************
*foreach var of varlist village_select village_select_o hhid_village region departement commune village ///
*            sup date arrondissement gps_collectLatitude gps_collectLongitude gps_collectAltitude gps_collectAccuracy description_village number_hh number_total ///
*            city_near q_16 q_17 q_18 q_19 q_20 q_21 q_22 q_23 q_25 q_26 q_27 q_28 q_29 q_30 ///
*            q_31 q_32 q_33 q_34 q_35_check q_37 q_39 q_41 q_43 q_44 q_45 q_46 q_47 q_48 q_49 ///
*            q_50 q_51 q_52 q_53 q_54 q_55 q_57 q_58 q60 q61 q62 q63_1 q63_2 q63_3 q63_4 q63_5 ///
*            q63_6 q63_7 q63_8 q63_9 q63_10 q64 q65 q66 q67 {
*    preserve
    * Keep only observations with missing values for the current variable
*    keep if missing`var' == 1
  
    * Keep relevant variables
 *   keep village_select sup full_name phone_resp `var'
  
    * Generate an "issue" variable
*    generate issue = "Missing"
	
	* Generate name of variable issue 
*	gen issue_variable_name = "`var'"
	
	* Rename variable with issue 
*	rename `var' print_issue
  
    * Export the dataset to Excel if there are observations that meet this condition:
*	if _N > 0 {
*    save "$community\Issue_Community_`var'.dta", replace
*	}
*    restore
*}

********************* SHOULD THIS LOOP BE KEPT? *******************************
*******************************************************************************

*foreach var of varlist village_select village_select_o hhid_village region departement commune village ///
*            sup date arrondissement gps_collectlatitude gps_collectlongitude gps_collectaltitude gps_collectaccuracy description_village number_hh number_total ///
*            city_near q_16 q_17 q_18 q_19 q_20 q_21 q_22 q_23 q_25 q_26 q_27 q_28 q_29 q_30 ///
*            q_31 q_32 q_33 q_34 q_35_check q_37 q_39 q_41 q_43 q_44 q_45 q_46 q_47 q_48 q_49 ///
*            q_50 q_51 q_52 q_53 q_54 q_55 q_57 q_58 q60 q61 q62 q63_1 q63_2 q63_3 q63_4 q63_5 ///
*            q63_6 q63_7 q63_8 q63_9 q63_10 q64 q65 q66 q67 {
    * Check if there are any missing values for the current variable
*    qui count if missing(`var')
*    if r(N) == 0 continue
  
*    preserve
    * Keep only observations with missing values for the current variable
*    keep if missing`var' == 1
  
    * Keep relevant variables
*    keep village_select sup full_name phone_resp `var'
  
    * Generate an "issue" variable
*    generate issue = "Missing"
	
	* Generate name of variable issue 
*	gen issue_variable_name = "`var'"
	
  
  	* Rename variable with issue 
*	rename `var' print_issue
	
    * Export the dataset to Excel if there are observations that meet this condition:
*	if _N > 0 {
*    export excel using "$community\Issue_Community_`var'.xlsx", firstrow(variables) replace
*	}
*    restore
*}



*** b. Check if the values of these variables are 0 or 1 ***

foreach var of varlist q_17 q_18 q_19 q_20 q_21 q_22 q_23 q_25 q_26 q_27 q_28 ///
                       q_29 q_30 q_31 q_32 q_33 q_34 q_35_check q_37 q_39 q_41 { 
	preserve	

    keep if `var' < 0 & `var' > 1
	
	keep hhid_village sup full_name phone_resp `var'
  
    * Generate an "issue" variable
    generate issue = "Not zero or one"
	
	* Generate name of variable issue 
	gen issue_variable_name = "`var'"
	
	* Rename variable with issue 
	rename `var' print_issue
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$community\Issue_Community_`var'.dta" if _N > 0, replace
	}
    restore
	
	}


*** c. For q_43 and q_44 verify response is between 0 and 45 or -9 ***

foreach var of varlist q_43 q_44 {
	preserve 
	
	gen ind_issue = . 
	replace ind_issue = 1 if `var' < 0 & `var' != -9
	replace ind_issue = 1 if `var' > 45
	keep if ind_issue == 1 
	
    *keep if `var' < 0 | `var' > 45 | `var' != -9
	
	keep hhid_village sup full_name phone_resp `var'
  
    * Generate an "issue" variable
    generate issue = "Unreasonable Value"
	
	* Generate name of variable issue 
	gen issue_variable_name = "`var'"
	
	* Rename variable with issue 
	rename `var' print_issue
  	
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$community\Issue_Community_`var'.dta", replace
	}
    restore
	}

*** d.	For q_45 and q_46 verify response is between 0 and 300 or -9 ***

foreach var of varlist q_45 q_46 {
	preserve 
	
	gen ind_issue = . 
	replace ind_issue = 1 if `var' < 0 & `var' != -9
	replace ind_issue = 1 if `var' > 300
	keep if ind_issue == 1 
	
	keep hhid_village sup full_name phone_resp `var'
  
    * Generate an "issue" variable
    generate issue = "Unreasonable Value"
	
	* Rename variable with issue 
	rename `var' print_issue
  
  	* Generate name of variable issue 
	gen issue_variable_name = "`var'"
	
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$community\Issue_Community_`var'.dta", replace
	}
    restore
	}

*** f.	For q_47, q_48, q_50, q_51, q_52, q_58, and q60 verify response is between 0 and 100 or -9 ***

foreach var of varlist q_47 q_48 q_50 q_51 q_52 q_58{
	preserve 
	
	gen ind_issue = . 
	replace ind_issue = 1 if `var' < 0 & `var' != -9
	replace ind_issue = 1 if `var' > 100
	keep if ind_issue == 1 

	keep hhid_village sup full_name phone_resp `var'
  
    * Generate an "issue" variable
    generate issue = "Unreasonable Value"
	
	* Rename variable with issue 
	rename `var' print_issue
  
  	* Generate name of variable issue 
	gen issue_variable_name = "`var'"
	
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$community\Issue_Community_`var'.dta", replace
	}
    restore
	}
	
*** h.	For q_49, verify response is between 0 and 10 or -9 ***

	preserve 
	
	gen ind_issue = . 
	replace ind_issue = 1 if q_49 < 0 & q_49 != -9
	replace ind_issue = 1 if q_49 > 10
	keep if ind_issue == 1
	
	keep hhid_village sup full_name phone_resp q_49 
  
    * Generate an "issue" variable
    generate issue = "Unreasonable Value"
	
	* Rename variable with issue 
	rename q_49 print_issue
  
  	* Generate name of variable issue 
	gen issue_variable_name = "q_49"
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$community\Issue_Community_q_49.dta", replace
	}
    restore
	
*** i.	For q_53 and q_54 verify response is between 0 and 50 or -9 ***

foreach var of varlist q_53 q_54{
	preserve 
	
    gen ind_issue = . 
	replace ind_issue = 1 if `var' < 0 & `var' != -9
	replace ind_issue = 1 if `var' > 50
	keep if ind_issue == 1 
	
	keep hhid_village sup full_name phone_resp `var'
  
    * Generate an "issue" variable
    generate issue = "Unreasonable value"
  
	* Rename variable with issue 
	rename `var' print_issue
  
  	* Generate name of variable issue 
	gen issue_variable_name = "`var'"
	
    * Export the dataset to Excel
	if _N > 0 {
    save "$community\Issue_Community_`var'.dta", replace
	}
    restore
	}

*** j. q_24 should be answered when q_23 = 1, response should be 0 or 1 ***

*** Part 01: Check if there are any accidental answers for q_24 ***
	*Note:
		* The expression q_23 == 1 & (q_24 != 0 & q_24 != 1) assigns a value of 1 to ind_var if q_23 is equal to 1 and q_24 is not equal to 0 and not equal to 1. 
		* Otherwise, ind_var will be assigned a value of 0.
preserve
* Step 1: Generate the indicator variable
generate ind_var = (q_23 != 1 & (q_24 == 0 | q_24 == 1))


* Step 2: Export to Excel only if there are observations meeting the conditions
if ind_var == 1 {
	
	* Rename variable with issue 
	rename q_23 print_issue
  
  	* Generate name of variable issue 
	gen issue_variable_name = "q_23 and q_24"
	
	* Note issue type 
	generate issue = "Incorreclty answered q_24"
	
	keep hhid_village sup full_name phone_resp issue issue_variable_name print_issue
    save "$community\Issue_Community_q_24_incorrectresponse.dta", replace
} 

 restore 
 
*** Part 02: Check if there are any missing answers for q_24 ***
	*Note: 
		* the expression q_23 != 1 & (q_24 == 0 | q_24 == 1) assigns a value of 1 to ind_var if q_23 is not equal to 1 and q_24 is either equal to 0 or equal to 1. 
		* Otherwise, ind_var will be assigned a value of 0

preserve

* Step 1: Generate the indicator variable
generate ind_var = (q_23 == 1 & q_24 == .)

* Step 2: Export to Excel only if there are observations meeting the conditions
if ind_var == 1 {
	
	* Rename variable with issue 
	rename q_24 print_issue 
	
	* Generate name of variable issue 
	gen issue_variable_name "q_24"
	
	* Describe issue 
	generate issue = "Missing q_24"
	
	keep hhid_village sup full_name phone_resp issue print_issue issue_variable_name
    save "$community\Issue_Community_q_24_noresponse.dta", replace
} 

 restore
 

*** k.	q_28a, 29a, 30a, 31a, 32a, 33a should be answered when q_28 29 30 31 32 33 = 1, response should be between 0 and 2000 or -9  ***

 *** PART 01 ***
  foreach num of numlist 28 29 30 31 32 33{
	 preserve

    * Step 1: Generate the indicator variable
    generate ind_var = 0
	replace ind_var = 1 if q_`num' == 1 & q_`num'a < 0 & q_`num'a != -9
	replace ind_var = 1 if q_`num' == 1 & q_`num'a > 2000
	
	* Keep and add variables to export 
	keep if ind_var == 1 
	
	generate issue = "Unreasonable value" 
		
	generate issue_variable_name = "q_`num'a"
		
	rename q_`num'a print_issue
	
	keep hhid_village sup full_name phone_resp issue print_issue issue_variable_name
	
     *Step 2: Export to Excel only if there are observations meeting the conditions
    if _N > 0 {
        save "$community\Issue_Community_q_`num'a_noresponse.dta", replace
    }
    
     restore
}

*** PART 02 ***


foreach num of numlist 28 29 30 31 32 33{
	preserve

    * Step 1: Generate the indicator variable
	generate ind_var = 0
    replace ind_var = 1 if q_`num' == 0 & q_`num'a != . 
	keep if ind_var == 1 
	
	generate issue = "Extra response" 
		
	generate issue_variable_name = "q_`num'a"
		
	rename q_`num'a print_issue
	
	keep hhid_village sup full_name phone_resp issue print_issue issue_variable_name
    if _N > 0 {
        save "$community\Issue_Community_q_`num'a_extraresponse.dta", replace
    }
    
     restore
}



*** i.	Q_36 should be answered when q_35_check = 1, response should be text ***

*** PART ONE ***

preserve 

	gen ind_var = 0
    replace ind_var = 1 if q_35_check == 1 & q_36 == "."
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "q_36"
	rename q_36 print_issue
	keep hhid_village sup full_name phone_resp issue print_issue issue_variable_name
    if _N > 0 {
        save "$community\Issue_Community_q36.dta", replace
    }
	
restore 

 *** PART TWO ***
 
preserve 
	gen ind_var = 0
    replace ind_var = 1 if q_35_check == 1 & q_35 == "."
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "q_35"
	rename q_35 print_issue
	keep hhid_village sup full_name phone_resp issue print_issue issue_variable_name
	if _N > 0 {
    save "$community\Issue_Community_q35_noresponse.dta", replace
	}
	
restore
 
 *** j. When q_37, q_39, q_41 = 1, q_38, q_40, q_42 should be answered with text ***
 *** PART ONE ***
 
  foreach num of numlist 38 40 42{
 preserve
    local var1 q_`num'
    local var2 q_`=`num'-1'
	
	gen ind_var = 0
	replace ind_var = 1 if `var2' == 1 & length(trim(`var1')) == 0
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "`var1'"
	rename q_`num' print_issue 
	keep hhid_village sup full_name phone_resp issue print_issue issue_variable_name
    if _N > 0 {
    save "$community\Issue_Community_`var1'_norespone.dta", replace
}
	 restore
	}
	
*** PART TWO ***

  foreach num of numlist 38 40 42{
 preserve 
 
    local var1 q_`num'
    local var2 q_`=`num'-1'
	
	gen ind_var = 0
	replace ind_var = 1 if `var2' != 1 & length(trim(`var1')) > 0
	keep if ind_var == 1 
	generate issue = "Extra response" 
	generate issue_variable_name = "`var1'"
	rename q_`num' print_issue 
	keep hhid_village sup full_name phone_resp issue print_issue issue_variable_name	
	if _N > 0 {
    save "$community\Issue_Community_`var1'_extraresponse.dta", replace
}
	restore 
	}
	
	
*** m.	Q62_o should be answered when q62 = -95, response should be text ***

preserve 

	gen ind_var = 0
    replace ind_var = 1 if q62 == -95 & length(trim(q62_o )) == 0
	keep if ind_var == 1
	generate issue = "Missing" 
	generate issue_variable_name = "q62_o"
	rename q62_o print_issue 
	keep hhid_village sup full_name phone_resp issue print_issue issue_variable_name	
	if _N > 0 {
        save "$community\Issue_Community_q62_noresponse.dta", replace
    }
	
restore 

**** create one output issue file ***

****************** LOOK IN FOLDER AND SEE WHICH OUTPUT ISSUE FILES THERE ARE *******
****************** INCLUDE ALL NEW FILES IN THE FOLDER BELOW *************

use "$community\Issue_Community_q_31a_noresponse.dta", clear 
append using "$community\Issue_Community_q_43.dta"
append using "$community\Issue_Community_q_44.dta" 
append using "$community\Issue_Community_q_45.dta" 
append using "$community\Issue_Community_q_49.dta" 
append using "$community\Issue_Community_q_58.dta" 

**************** UPDATE DATE IN FILE NAME ***********************
*export excel using "$issues\Community_Issues_6Feb2024.xlsx", firstrow(variables)  

