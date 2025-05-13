*==============================================================================
* Program: balance tables data tranformation
* =============================================================================
* written by: Kateri Mouawad
* additions made by: Kateri Mouawad
* Created: December 2024
* Updates recorded in GitHub 

	
 ** This file processes: 
	* Complete_Baseline_Household_Roster.dta
	* Complete_Baseline_Health.dta
	* Complete_Baseline_Agriculture.dta
	* Complete_Baseline_Income.dta
	* Complete_Baseline_Standard_Of_Living.dta
	* Complete_Baseline_Public_Goods_Game.dta
	* Complete_Baseline_Enumerator_Observations.dta
	* Complete_Baseline_Beliefs.dta
	* Complete_Baseline_Community.dta
	* Treated_variables_df.dta
	* PCA_asset_index_var.dta
	
 ** This file outputs:
	* baseline_balance_tables_data_PAP.dta
 
* <><<><><>> Read Me  <><<><><>>

	* This script merges selects, cleans, and orders the baseline data to setup the dataframe for analysis for the balance tables. 
	* Step 1)
		* Merge all deidentfied dataframes with relevant variables
	* Step 2) Select variables we pre-decided on to check balances
	* Step 3) Rename variables so correct indicies get transformed when we switch the data from wide to long
	* Step 4) Remove useless/dumb variables
	* Step 5) Wrangle data from wide to long for data accuracy and efficiency 
	* Step 6) Reorder variables for clarity
	* Step 7) Save as .csv so we can create the tables in R in the Balance_tables.rmd

*<><<><><>><><<><><>>
**#  INITIATE SCRIPT
*<><<><><>><><<><><>>
	
clear all
set mem 100m
set maxvar 30000
set matsize 11000
set more off


**check list of villge IDs and hhids to spot non-updated ID

*<><<><><>><><<><><>>
**#  SET FILE PATHS
*<><<><><>><><<><><>>

*^*^* Set base Box path for each user
	if "`c(username)'"=="socrm" global master "C:\Users\socrm\Box\NSF Senegal"
	if "`c(username)'"=="kls329" global master "C:\Users\kls329\Box\NSF Senegal"
	if "`c(username)'"=="km978" global master "C:\Users\km978\Box\NSF Senegal"
	if "`c(username)'"=="Kateri" global master "C:\Users\Kateri\Box\NSF Senegal"
	if "`c(username)'"=="admmi" global master "C:\Users\admmi\Box\NSF Senegal"

	if "`c(username)'"=="km978" global gitmaster "C:\Users\Kateri\Downloads\GIT-Senegal\NSF-Senegal"
	if "`c(username)'"=="Kateri" global gitmaster "C:\Users\km978\Downloads\GIT-Senegal\NSF-Senegal"


*^*^* Define project-specific paths

	global data "${master}\Data_Management\Data\_CRDES_CleanData\Baseline\Deidentified"
	global trainedData "${master}\Data_Management\Output\Data_Processing\Checks\Corrections\Treatment"
	global index "${master}\Data_Management\Data\_CRDES_CleanData\Baseline\Deidentified"

*^*^* Data folders 
	global dataOutput "${master}\Data_Management\Output\Analysis\Balance_Tables" 
	global asset "${master}\Data_Management\Output\Data_Processing\Construction"
	global latexOutput "$git_path\Latex_Output\Balance_Tables"


*<><<><><>><><<><><>>
**#  LOAD IN DATA
*<><<><><>><><<><><>>

use "$data\Complete_Baseline_Household_Roster.dta", clear 

	merge 1:1 hhid using "$data\Complete_Baseline_Health.dta"
		drop _merge 

	merge 1:1 hhid using "$data\Complete_Baseline_Agriculture.dta"
		drop _merge 

	merge 1:1 hhid using "$data\Complete_Baseline_Income.dta"
		drop _merge 

	merge 1:1 hhid using "$data\Complete_Baseline_Standard_Of_Living.dta"
		drop _merge 

	merge 1:1 hhid using "$data\Complete_Baseline_Public_Goods_Game.dta"
		drop _merge 

	merge 1:1 hhid using "$data\Complete_Baseline_Enumerator_Observations.dta"
		drop _merge 

	merge 1:1 hhid using "$data\Complete_Baseline_Beliefs.dta"
		drop _merge 	
		
	merge m:1 hhid_village using "$data\Complete_Baseline_Community.dta"
		drop _merge 

		
*<><<><><>><><<><><>>
**#  BEGIN DATA CLEANING/PROCESSING
*<><<><><>><><<><><>>		
		



  *^*^* Keep relevant variables 

	keep hhid hhid_village ///
		 q_51  ///  // village level var 
		 hh_relation_with_* hh_gender* hh_age* hh_age_resp hh_gender_resp ///
		 hh_education_skills* hh_education_level*  ///
		 hh_numero* hh_03* hh_10* hh_11* hh_12* hh_12index_* hh_13* hh_14* hh_15* hh_16* hh_29* /// 	
		 hh_26* hh_27* hh_31* hh_32* hh_37* hh_38* ///  //edu vars 
		 health_5_2* health_5_3* health_5_5* health_5_6* health_5_12* ///
		 agri_6_15* species* agri_income_01 agri_income_05 agri_6_34_comp* ///
		 agri_6_14* agri_6_15* agri_6_21*  agri_6_22* /// // how many parcels & surface area of plot & unit
		 agri_6_32* agri_6_36* /// // used fertilizer vars
		 living_01* living_03* living_04* living_05* living_06* ///
		 beliefs_0* /// // beliefs module
		 montant_02* montant_05* ///
		 face_04* face_13* ///
		 enum_03* enum_04* enum_05*
		// agri_6_38_a* agri_6_39_a* agri_6_40_a* agri_6_41_a* /// // quantity of fertilizer 
 
	 


  *^*^* Drop unecessary variables 
	
*/ Drop variables with numbered suffixes (1 to 55) that are unneeded
	forval i = 1/55 {
		drop hh_education_skills_`i' hh_12_`i' health_5_3_`i'
	}

* Drop uneeded variables 
	drop hh_relation_with_o* hh_12_o* hh_12_a* hh_13_s* hh_13_o*  ///
		 living_01_o living_03_o living_04_o living_05_o ///
		 enum_03_o enum_04_o enum_05_o species_o ///
		hh_12_r* hh_12name_* hh_12_calc_* hh_education_level_o_* ///
		 hh_11_o_* hh_education_skills_0_* hh_15_o_* hh_29_o* health_5_3_o* ///
		 speciesindex* species_autre speciesname* living_06_o 
	//	agri_6_38_a_code_o* agri_6_39_a_code_o* agri_6_40_a_code_o* agri_6_41_a_code_o*



  *^*^* Label the variables - will disapear in the reshape, but I'm leaving this here for reference regardless. - KRM
  forvalues i = 1/55{
  
	label variable hh_gender_`i' "Genre"
	label variable hh_age_`i' "Age"  
	label variable hh_education_level_`i' "Niveau d'education atteint"
  	*label variable hh_education_skills_0_`i' "Education - Competences - 0 Aucun"
	label variable hh_education_skills_1_`i' "Education - Competences - 1 Peut ecrire une courte letter a sa famille"
	label variable hh_education_skills_2_`i' "Education - Competences - 2 A l'aise avec les chiffres et les calculs"
	label variable hh_education_skills_3_`i' "Education - Competences - 3 Arabisant/peut lire le Coran en arabe"
	label variable hh_education_skills_4_`i' "Education - Competences - 4 Parle couramment le wolof/pulaar"
	label variable hh_education_skills_5_`i' "Education - Competences - 5 Peut lire un journal en francais"	
	label variable hh_12_1_`i' "Aller chercher de l'eau pour le menage"
	label variable hh_12_2_`i' "Donner de l'eau au betail"
	label variable hh_12_3_`i' "Aller chercher de l'eau pour l'agriculture"
	label variable hh_12_4_`i' "Laver des vetements"
	label variable hh_12_5_`i' "Faire la vaisselle"
	label variable hh_12_6_`i' "Recolter de la vegetation aquatique"
	label variable hh_12_7_`i' "Nager/se baigner"
	label variable hh_12_8_`i' "Jouer"
	label variable hh_13_`i'_1 "Au cours des 12 derniers mois, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_12 = 1 pres de (< 1 m) ou dans la/les source(s) d'eau?"
	label variable hh_13_`i'_2 "Au cours des 12 derniers mois, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_12 = 2 pres de (< 1 m) ou dans la/les source(s) d'eau?"
	label variable hh_13_`i'_3 "Au cours des 12 derniers mois, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_12 = 3 pres de (< 1 m) ou dans la/les source(s) d'eau?"
	label variable hh_13_`i'_4 "Au cours des 12 derniers mois, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_12 = 4 pres de (< 1 m) ou dans la/les source(s) d'eau?"
	label variable hh_13_`i'_5 "Au cours des 12 derniers mois, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_12 = 5 pres de (< 1 m) ou dans la/les source(s) d'eau?"
	label variable hh_13_`i'_6 "Au cours des 12 derniers mois, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_12 = 6 pres de (< 1 m) ou dans la/les source(s) d'eau?"
	label variable hh_13_`i'_7 "Au cours des 12 derniers mois, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_12 = 7 pres de (< 1 m) ou dans la/les source(s) d'eau?"
	label variable hh_14_`i' "Au cours des 12 derniers mois, combien de vegetation aquatique a-t-il/elle recolte pres de (< 1 m) ou dans la/les source(s) d'eau par semaine, en moyenne (en kg)"
	label variable hh_15_`i' "Comment a-t-il utilise la vegetation aquatique"
	label variable hh_16_`i' "Au cours des 12 derniers mois combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a la production d'engrais, son achat, ou son application sur le champ"
	label variable hh_29_`i' "Quel est le niveau et la classe les plus eleves que [hh_full_name_calc] a reussi a l'ecole"
	label variable hh_26_`i' "[hh_full_name_calc] a-t-il fait ou fait-il des etudes actuellement dans une ecole formelle"
	label variable hh_27_`i' "Est ce que [hh_full_name_calc] a suivi une ecole non formelle ou une formation non-formelle"
	label variable hh_31_`i' "Quel resultat [hh_full_name_calc] a-t-il obtenu au cours de l'annee 2022/2023"
	label variable hh_37_`i' "Au cours des 12 derniers mois, [hh_full_name_calc] a-t-il deja manque plus d'une semaine consecutive d'ecole pour cause de maladie"
	label variable hh_38_`i' "Au cours des 7 derniers jours, combien de jours [hh_full_name_calc] est-il alle a l'ecole pour suivre des cours"
	label variable health_5_2_`i' "Est-ce que [health-name] est tombe malade au cours des 12 derniers mois"
	*label variable health_5_3_`i' "De quel type de maladie ou de blessure a-t-il/elle souffert"
	label variable health_5_3_1_`i' "Paludisme"
	label variable health_5_3_2_`i' "Bilharzoise"
	label variable health_5_3_3_`i' "Diarrhee"
	label variable health_5_3_4_`i' "Blessures"
	label variable health_5_3_5_`i' "Problemes dentaires"
	label variable health_5_3_6_`i' "Problemes de peau"
	label variable health_5_3_7_`i' "Problemes oculaires"
	label variable health_5_3_8_`i' "Problemes de gorge"
	label variable health_5_3_9_`i' "Maux d'estomac"
	label variable health_5_3_10_`i' "Fatigue"
	label variable health_5_3_11_`i' "IST"
	label variable health_5_3_12_`i' "trachome"
	label variable health_5_3_13_`i' "onchocercose"
	label variable health_5_3_14_`i' "filaroise lymphatique"
	label variable health_5_5_`i' "A-t-il/elle recu des medicaments pour le traitement de la schistosomiase au cours des 12 derniers mois"
	label variable health_5_6_`i' "Cette personne a-t-elle deja ete diagnostiquee avec la schistosomiase"
	label variable health_5_12_`i' "Quelle est la distance en km qui vous separe de ce service ou de ce professionnel de sante"

  }
  
  
    forvalues i=1/11 {
  label variable agri_6_21_`i' "Quelle est la superficie de la parcelle selon l'exploitant ? (Indiquer la superficie en hectares ou en metres carres avec deux decimales)"
  label variable agri_6_32_`i' "Quelle quantite de fumier avez-vous appliquee sur la parcelle"
  label variable agri_6_36_`i' "Avez-vous utilise des engrais inorganiques/chimiques sur cette parcelle au cours de cette campagne agricole"
  label variable agri_6_34_comp_`i' "Did you use compost on this plot during this campaign?"
	}
	
	label variable q_51 "How far is the nearest health infrastructure (in kilometers)?"
	label variable agri_6_15 "Combien de parcelles a l'interieur des champs cultives par le menage"
	label variable species "Quelles especes les proprietaires possedent-ils"
	label variable species_1 "Bovins"
	label variable species_2 "Mouton"
	label variable species_3 "Chevre"
	label variable species_4 "Cheval (equide)"
	label variable species_5 "Ane"
	label variable species_6 "Animaux de trait"
	label variable species_7 "Porcs"
	label variable species_8 "Volaille"
	* Beliefs section 
	label variable beliefs_01 "Quelle est la probabilite que vous contractiez la bilharziose au cours des 12 prochains mois"
	label variable beliefs_02 "Quelle est la probabilite qu'un membre de votre menage contracte la bilharziose au cours des 12 prochains mois"
	label variable beliefs_03 "Quelle est la probabilite qu'un enfant choisi au hasard dans votre village, age de 5 a 14 ans, contracte la bilharziose au cours des 12 prochains mois"
	label variable beliefs_04 "Dans quelle mesure etes-vous d'accord avec l'affirmation suivante : Les terres de ce village devraient appartenir a la communaute et non a des individus"
	label variable beliefs_05 "Dans quelle mesure etes-vous d'accord avec l'affirmation suivante : Les sources d'eau de ce village devraient appartenir a la communaute et non aux individus"
	label variable beliefs_06 "Dans quelle mesure etes-vous d'accord avec l'affirmation suivante : Si je travaille sur mes propres terres, j'ai le droit d'utiliser les produits que j'ai obtenus grace a mon travail."
	label variable beliefs_07 "Dans quelle mesure etes-vous d'accord avec l'affirmation suivante : Si je travaille sur des terres appartenant a la communaute, j'ai le droit d'utiliser les produits que j'ai obtenus par mon travail."
	label variable beliefs_08 "Dans quelle mesure etes-vous d'accord avec l'affirmation suivante : Si je peche dans une source d'eau appartenant a la communaute, j'ai le droit d'utiliser les produits que j'ai obtenus par mon travail."
	label variable beliefs_09 "Dans quelle mesure êtes-vous d'accord avec l'affirmation suivante : Si je recolte des produits dans une source d'eau appartenant a la communaute, j'ai le droit d'utiliser les produits que j'ai obtenus par mon travail."
	
	label variable agri_income_01 "Avez-vous (ou un membre de votre menage) effectue un travail remunere au cours des 12 derniers mois"
	label variable agri_income_05 "Montant recu en nature et/ou en especes (FCFA) pour ce travail"
	label variable living_01 "Quelle est la principale source d'approvisionnement en eau potable"
	*label variable living_02 "L'eau utilisee est-elle traitee dans le menage"
	label variable living_04 "Quel est le principal type de toilettes utilise par votre menage"
	label variable living_05 "Quel est le principal combustible utilise pour la cuisine"
	label variable living_06 "Quel est le principal combustible utilise pour l'eclairage"
	label variable montant_02 "Montant verse par le repondant pour le jeu A"
    label variable montant_05 "Montant verse par le repondant pour le jeu B"
	label variable face_04 "Montant verse par le repondant pour le jeu B"
	label variable face_13 "Montant verse par le repondant pour le jeu A"
    label variable enum_03 "Quels sont les materiaux principaux utilises pour le toit de la maison ou dort le chef de famille"
    label variable enum_04 "Quels sont les materiaux principaux utilises pour les murs de la maison ou dort le chef de famille"
	label variable enum_05 "S'il a ete observe, quels sont les materiaux principaux du sol principal de la maison ou dort le chef de famille"
	



* Loop over first index to correct for reshape 

	forval i = 1/7 {
		* Loop over the second index (1 to 55)
		forval j = 1/55 {
			* Construct the old and new variable names
			local oldname = "hh_13_`j'_`i'"
			local newname = "hh_13_`i'_`j'"
			
			* Rename if the old variable exists
			cap rename `oldname' `newname'
		}
	}


* Loop over first index to correct for reshape 
	forval i = 1/7 {
		* Loop over the second index (1 to 55)
		forval j = 1/55 {
			* Construct the old and new variable names
			local oldname = "hh_12index_`j'_`i'"
			local newname = "hh_12index_`i'_`j'"
			
			* Rename if the old variable exists
			cap rename `oldname' `newname'
		}
	}
	
	
  *^*^*  Generate indicator for the household respondent 
  
  
	merge 1:1 hhid using "$index\respondent_index.dta"
	
	forvalues i = 1/55 {
    gen resp_index_`i' = (resp_index == `i')
}
	
	drop _merge
	
	

*<><<><><>><><<><><>> 
**#  RESHAPE THE DATA 
*<><<><><>><><<><><>>

		
	reshape long resp_index_ hh_gender_ hh_age_ hh_relation_with_ hh_education_skills_1_ hh_education_skills_2_ hh_education_skills_3_ hh_education_skills_4_ hh_education_skills_5_ hh_education_level_  ///
			hh_12_1_ hh_12_2_ hh_12_3_ hh_12_4_ hh_12_5_ hh_12_6_ hh_12_7_ hh_12_8_ hh_13_1_ hh_13_2_ hh_13_3_ hh_13_4_ hh_13_5_ hh_13_6_ hh_13_7_ hh_14_ hh_15_ hh_16_ hh_26_ hh_27_ hh_29_ hh_31_ hh_32_ hh_37_ hh_38_  ///
			hh_03_ hh_10_ hh_11_ hh_12index_1_ hh_12index_2_ hh_12index_3_ hh_12index_4_ hh_12index_5_ hh_12index_6_ hh_12index_7_ ///
			health_5_2_ health_5_3_1_ health_5_3_2_ health_5_3_3_ health_5_3_4_ health_5_3_5_ health_5_3_6_ health_5_3_7_  health_5_3_8_ health_5_3_9_ health_5_3_10_ health_5_3_11_ health_5_3_12_ health_5_3_13_ health_5_3_14_ health_5_3_99_ ///
			health_5_5_ health_5_6_ health_5_12_, i(hhid) j(id)
			
			
			
/*
gen village_third = substr(hhid_village, 3, 1)  
tab village_third
*/



*<><<><><>><><<><><>>
**# REPLACE MISSINGS 
*<><<><><>><><<><><>>


** Initial look at data - check missings for each var


		foreach var of varlist _all {
			quietly count if missing(`var')
			display "`var': " r(N)
		}



** replace 2s for variables that have option "I don't know" 
	*1 Yes
	*0 No
	*2 Don't know / Don't answer

	foreach var in hh_03_ hh_26_ hh_27_ hh_37_ health_5_2_ health_5_5_ health_5_6_ ///
		agri_income_01 ///
		agri_6_34_comp_1 agri_6_34_comp_2 agri_6_34_comp_3 agri_6_34_comp_4 agri_6_34_comp_5 ///
		agri_6_34_comp_6 agri_6_34_comp_7 agri_6_34_comp_8 agri_6_34_comp_9 agri_6_34_comp_10 agri_6_34_comp_11 {
		replace `var' = .a if `var' == 2
	}



** replace -9s with NAs for variables that contain them


* Loop through all variables in the dataset

foreach var of varlist _all {
    * Check if the variable is numeric (ignoring strings)
    capture confirm numeric variable `var'
    if !_rc {  // If the variable is numeric
        * Count if -9 exists in the numeric variable
        count if `var' == -9
        if r(N) > 0 {
            display "`var' contains -9"
        }
    }
}

	** Found to have -9s: 
	
		** 	hh_38_ 
		**	health_5_12_ 
		**	agri_income_05

	***INCOME MODULE*****************************************************

	foreach var in hh_38_ health_5_12_ agri_income_05 {
		replace `var' = .a if `var' == -9
	}

		replace agri_income_05 = 0 if agri_income_01 == 0
		
		
		replace agri_6_15 = 0 if agri_6_14 == 0
		

*<><<><><>><><<><><>>
**# BEGIN VARIABLE CREATION
*<><<><><>><><<><><>>


	***CHILD MODULE*****************************************************
	
		egen child_in_home = max(hh_age_ >= 4 & hh_age_ <= 18), by(hhid)

	
		
		*if for each hhid, age is not >= 4 & <= 18, replace hh_26_ == 0
/*		

		gen hh_26_ind = 0
	replace hh_26_ind = 1 if (hh_age_ >= 4 & hh_age_ <= 18) & missing(hh_26_)
	replace hh_26_ = 0 if missing(hh_26_) & hh_26_ind == 0
*/
	**left off here 
		*replace hh_26_ = 0 if missing(hh_26_) & (hh_age_ >= 4 & hh_age_ <= 18)
		
			*Go back to the orgin of the condition
		*hh_38 is also conditional on hh_32, and hh_32 is conditional on hh_26

			foreach var in hh_29_ hh_37_ hh_38_ {
		replace `var' = 0 if missing(`var') & (hh_age_ >= 4 & hh_age_ <= 18)
	}
	
	
		* DROPPED VAR - not including in the PAP balance table
* Creating binary variables for hh_31

	*1. Graduated, studies completed
	*2. Moving to the next class
	*3. Failure, repetition
	*5. Dropping out during the year
	

		gen hh_31_bin = 0
		replace hh_31_bin = 1 if hh_31_ == 1 | hh_31_ == 2
		replace hh_31_bin = . if missing(hh_31_) & (hh_age_ >= 4 & hh_age_ <= 18) // Set to missing if hh_31_ is empty to account for ONLY the child population 

	
* Creating binary variables for hh_29 conditional on grade level:

		* 1.Primary – 1st year
		* 2.Primary – 2nd year
		* 3.Primary – 3rd year
		* 4.Primary – 4th year
		* 5.Primary – 5th year
		* 6.Primary – 6th year
		* 7. Secondary 1 (Middle) - 7th year
		* 8. Secondary 1 (Middle) - 8th year
		* 9. Secondary 1 (Middle) - 9th year
		* 10. Secondary 1 (Middle) - 10th year
		* 11. Secondary 2 (Higher) - 11th year
		* 12. Secondary 2 (Higher) - 12th year
		* 13. Secondary 2 (Higher) - 13th year
		* 14. More than upper secondary (e.g. university)
		* 99. Other (to be specified)


		
		gen hh_29_01 = (0 < hh_29_ & hh_29_ <= 6)  // Primary level

			replace hh_29_01 = .a if missing(hh_29_)
			replace hh_29_01 = 0 if missing(hh_29_01) & (hh_age_ >= 4 & hh_age_ <= 18)


			*replace hh_29_01 = 0 if hh_29_ > 6 & hh_29_ != .

		gen hh_29_02 = (hh_29_ >= 7 & hh_29_ <= 10)  // Secondary middle level
			replace hh_29_02 = .a if missing(hh_29_)
			replace hh_29_02 = 0 if missing(hh_29_02) & (hh_age_ >= 4 & hh_age_ <= 18)

	
			*replace hh_29_02 = 0 if (hh_29_ < 7 | hh_29_ > 10) & hh_29_ != . 

		gen hh_29_03 = (hh_29_ >= 11 & hh_29_ <= 13)  // Secondary higher level
			replace hh_29_03 = .a if missing(hh_29_)
			replace hh_29_03 = 0 if missing(hh_29_03) & (hh_age_ >= 4 & hh_age_ <= 18)

			
			*replace hh_29_03 = 0 if (hh_29_ < 11 | hh_29_ > 13) & hh_29_ != . 

		gen hh_29_04 = (hh_29_ == 14)  // Upper secondary
			replace hh_29_04 = .a if missing(hh_29_)
			replace hh_29_04 = 0 if missing(hh_29_04) & (hh_age_ >= 4 & hh_age_ <= 18)
			
			*replace hh_29_04 = 0 if hh_29_ != 14 & hh_29_ != . 

	**## TIME USE VARIABLES***
	
	** Fill in logic missings with 0s for variables dependent on hh_10
	
/* 
		foreach var in hh_11_ hh_14_ hh_15_ hh_16_  {
				replace `var' = 0 if hh_10_ == 0
		}
		
*/ 

	foreach var in hh_11_ hh_14_  hh_16_  {
				replace `var' = 0 if hh_10_ == 0
		}
		


	* Loop through hh_12_1_ to hh_12_8_
		forval i = 1/8 {
			replace hh_12_`i'_ = 0 if hh_10_ == 0
		}

	* Loop through hh_13_1_ to hh_13_8_
		forval i = 1/7 {
			replace hh_13_`i'_ = 0 if hh_10_ == 0
		}


	  *^*^* filter variable 
	forvalues j = 1/8 {
		gen hh_13_0`j' = .
		forvalues i = 1/7 {
			replace hh_13_0`j' = hh_13_`i' if hh_12index_`i' == `j'
		}
	}
	

	   **drop unecessary variables
		drop hh_13_7_ hh_13_6_ hh_13_5_ hh_13_4_ hh_13_3_ hh_13_2_ hh_13_1_ 
		drop hh_12index_7_ hh_12index_6_ hh_12index_5_ hh_12index_4_ hh_12index_3_ hh_12index_2_ hh_12index_1_
		
		
		* hh_14 relevance: ${hh_10} > 0 and selected(${hh_12}, "6")
		*replace hh_11_ = 0 if hh_10_ == 0 
		* hh_12_: ${hh_10} > 0
		*** KRM - can i replace these all with zeros? or -9s
		/*
		foreach i of numlist 1/8 {
			replace hh_12_`i'_ = 0 if hh_10_ == 0
		}
		*/

		*hh_13: ${hh_10} > 0
		/*

		foreach i of numlist 1/8 {
			replace hh_13_`i'_ = 0 if hh_10_ == 0
		}

		foreach i of numlist 1/8 {
			replace hh_13_`i'_ = 0 if hh_12_`i' == 0
		}

		replace hh_14_ = 0 if hh_10_ == 0

		* hh_16 relevance: ${hh_10} > 0
		replace hh_16_ = 0 if hh_10_ == 0

		* hh_education_year_achieve: {hh_education_level} != 0
		 */

		 ** Dropped var 
		*replace hh_education_year_achieve_ = 0 if hh_education_level_ == 0


		** Note **

		* agri_income_05, hh_11_ hh_12_ hh_13_ hh_14_ hh_16_ are all conditional variables 


* Creating binary variables for hh_education_level
/*
foreach x in 0 1 2 3 4 99 {
    gen hh_education_level_`x' = hh_education_level_ == `x'
    replace hh_education_level_`x' = 0 if missing(hh_education_level_)
}

*/

	** Level of education achieved
	** 2: Secondary level
	** 3: Higher level
	** 4: Technical and vocational school


		gen hh_education_level_bin = 0
			replace hh_education_level_bin = 1 if hh_education_level_ == 2 | hh_education_level_ == 3 | hh_education_level_ == 4


** Education - Skills (multiple choice)

		** 2.Comfortable with numbers and calculations
		** 3. Arabizing/can read the Quranin Arabic
		** 4. Fluent in Wolof/Pulaar
		** 5. Can read a newspaper in French

/*
		gen hh_education_skills_bin = 0
			replace hh_education_skills_bin = 1 if hh_education_skills_2_ == 1 | hh_education_skills_3_ == 1 | 	hh_education_skills_4_ == 1 | hh_education_skills_5_ == 1
*/

       * Update - want only if HH head is LITERATE, so we just need hh_education_skills_5_

** source(s) of surface water?

	** source(s) of surface water?
	* Creating binary variables for hh_11
	

			foreach x in 1 2 3 4 99 {
				gen hh_11_`x' = hh_11_ == `x'
				*replace hh_11_`x' = 0 if missing(hh_11_)
			}

			
** How did they use the quatic vegetation?
** ${hh_10} > 0 and selected(${hh_12}, "6")

			*replace hh_15_ = 0 if hh_12_6_ == 0
			
	*How did he use aquatic vegetation?
	* Creating binary variables for hh_15
/* 
			foreach x in 1 2 3 4 5 99 {
				gen hh_15_`x' =  hh_15_ == `x', missing otherwise 
				replace hh_15_`x' = 0 if missing(hh_15_)
			}
			
*/
				foreach x in 1 2 3 4 5 99 {
					gen hh_15_`x' = .
					replace hh_15_`x' = 1 if hh_15_ == `x'
				}

/*
foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 99 {
    gen hh_29_`x' = hh_29_ == `x'
    replace hh_29_`x' = 0 if missing(hh_29_)
}
*/
			
			
/*
* Creating binary variables for living_01
foreach x in 1 2 3 4 5 6 7 8 9 10 99 {
    gen living_01_`x' = living_01 == `x'
    replace living_01_`x' = 0 if missing(living_01)
}
*/

		** main source of drinking water supply
		**1 = Interior tap
		**2 = Public tap
		**3 = Neighbor's tap
		
	*	(update to include protected well and tanker)

		gen living_01_bin = 0
			replace living_01_bin = 1 if living_01 == 1 |living_01 == 2 | living_01 == 3 

* Creating binary variables for living_03
/*
foreach x in 1 2 3 99 {
    gen living_03_`x' = living_03 == `x'
    replace living_03_`x' = 0 if missing(living_03)
}
*/


/*
* Creating binary variables for living_04
foreach x in 1 2 3 4 5 6 7 99 {
    gen living_04_`x' = living_04 == `x'
    replace living_04_`x' = 0 if missing(living_04)
}
*/

		** Main type of toilet 
		**1 Flush with sewer
		**2 Toilet flush with 


		gen living_04_bin = 0
			replace living_04_bin = 1 if living_04 == 1 | living_04 == 2 

/*
* Creating binary variables for living_05
foreach x in 1 2 3 4 5 6 7 99 {
    gen living_05_`x' = living_05 == `x'
    replace living_05_`x' = 0 if missing(living_05)
}
*/

		** main fuel used for cooking
		** 4 Electricity
		** 7 solar
		gen living_05_bin = 0
			replace living_05_bin = 1 if living_05 == 4 

		** primary fuel used for lighting
		** 1 Electricity (Sénélec)
		** 3 Solar

		gen living_06_bin = 0
			replace living_06_bin = 1 if living_06 == 1 | living_06 == 3


** has cement for roof 

		gen enum_03_bin = 0
			replace enum_03_bin = 1 if enum_03 == 1 

* Creating binary variables for enum_04
/*
foreach x in 1 2 3 4 5 6 99 {
    gen enum_04_`x' = enum_04 == `x'
    replace enum_04_`x' = 0 if missing(enum_04)
}
*/

** has cement for walls for head of the family
		gen enum_04_bin = 0
			replace enum_04_bin = 1 if enum_04 == 1 


/*
foreach x in 1 2 3 4 5 99 {
    gen enum_05_`x' = enum_05 == `x'
    replace enum_05_`x' = 0 if missing(enum_05)
}
*/

* Creating binary variables for enum_05
	**main materials of the main floor of the house 
	** 4 = cement

		gen enum_05_bin = 0
			replace enum_05_bin = 1 if enum_05 == 4

		** had bilharzia or diarrhea
		gen health_5_3_bin = 0
			replace health_5_3_bin = 1 if health_5_3_2_ == 1 | health_5_3_3_ == 1



* Recode hh_gender_ (change 2 to 0, leave others unchanged)
		recode hh_gender_ (2=0)

		tempfile balance_table_ata
			save `balance_table_ata'

/*
* Create binary indicators for each water source type
		gen interior_tap = living_01 == 1
		gen public_tap = living_01 == 2
		gen neighbor_tap = living_01 == 3
		gen protected_well = living_01 == 4
		gen unprotected_well = living_01 == 5
		gen drill_hole = living_01 == 6
		gen tanker_service = living_01 == 7
		gen water_seller = living_01 == 8
		gen natural_source = living_01 == 9
		gen stream = living_01 == 10
		gen other_water = living_01 == 99

* Collapse to village level to get whether any household uses a specific source
	collapse (max) interior_tap public_tap neighbor_tap protected_well ///
		unprotected_well drill_hole tanker_service water_seller ///
		natural_source stream other_water, by(hhid_village)

* Compute the total number of unique water access points per village
	gen num_water_access_points = interior_tap + public_tap + neighbor_tap + ///
		protected_well + unprotected_well + drill_hole + tanker_service + ///
		water_seller + natural_source + stream + other_water

* keep results
	keep hhid_village num_water_access_points

* Save as a temporary file
	tempfile water_access
	save `water_access'


  *^*^* merge in data

	use `balance_table_ata'
	merge m:m hhid_village using `water_access'
	drop _merge
*/

  *^*^* create TLU species variable 

** Species	      TLU Equivalent
** Cattle	          1.0
** Sheep	          0.1
** Goat	              0.1
** Horse (equine)     1.0
** Donkey	          0.5
** Draft animals	  1.0
** Pigs	              0.2
** Poultry	          0.01

** change to amount for TLU


		gen TLU = 0  // Start with TLU equal to 0 for all households

		* Assign TLU values based on animal species
		replace TLU = TLU + (1.0) if species_1 == 1  // Cattle
		replace TLU = TLU + (0.1) if species_2 == 1  // Sheep
		replace TLU = TLU + (0.1) if species_3 == 1  // Goat
		replace TLU = TLU + (1.0) if species_4 == 1  // Horse (equine)
		replace TLU = TLU + (0.5) if species_5 == 1  // Donkey
		replace TLU = TLU + (1.0) if species_6 == 1  // Draft animals
		replace TLU = TLU + (0.2) if species_7 == 1  // Pigs
		replace TLU = TLU + (0.01) if species_8 == 1 // Poultry

* List the final TLU variable
		list hhid species TLU

** create grouped variables for fertilizer amount
   * agri_6_15 how many parcels
   * agri_6_21 surface area of parcel
   * agri_6_22*  unit (Hectare (Ha) Square Meter (m^2))
   * agri_6_32 quantity of organic fertilizer
	
	* Convert land area to hectares
		
		forvalues i = 1/11 {
			replace agri_6_21_`i' = agri_6_21_`i' / 10000 if agri_6_22_`i' == 2 // Convert m² to Ha
		}
					
	 *Create variable that captures total hectares
	 
	 *KRM - change to total land cultivated
	 
		egen total_land_ha = rowtotal(agri_6_21_1 - agri_6_21_11)


* Create binary variable for nonzero agri_6_32 values
		gen agri_6_32_bin = 0
		forvalues i = 1/11 {
			replace agri_6_32_bin = 1 if agri_6_32_`i' != 0 & agri_6_32_`i' != .
		}
		

* Create agri_6_36 binary variable that aggregates to if any of the parcels had organic fertilizer  
		gen agri_6_36_bin = 0
		forvalues i = 1/11 {
			replace agri_6_36_bin = 1 if agri_6_36_`i' == 1
		}
		
		*KRM look into this, either use proportion to compute 
		
* Create agri_6_34_comp binary variable that aggregates to if any of the parcels had organic fertilizer  	
	
	gen agri_6_34_comp_any = 0  // Initialize new variable as 0

		foreach var of varlist agri_6_34_comp_1-agri_6_34_comp_11 {
			replace agri_6_34_comp_any = 1 if `var' == 1
		}
		
* Create new variables that takes the sume for game A: montant_05 face_13 & game B: montant_05 	face_04


		egen game_A_total = rowtotal(montant_05 face_13)
		egen game_B_total = rowtotal(montant_05 face_04)

				
* Create beliefs binarys since these are ordinal variables 
   ** check the distribution

	foreach var of varlist beliefs_01 - beliefs_09 {
		di "`var'"  // Display variable name
		tab `var', missing
	}

   ** choose a cutoff (e.g., above median)
	foreach var of varlist beliefs_01 - beliefs_09 {
		summarize `var', detail  // Look at percentiles
		}

	** create a Binary Indicator
		*If most responses are ≤2 (Agree/Strongly Agree) → use beliefs_var <= 2 as the binary indicator.
		*If responses are more evenly spread, consider using ≤3 (including Neutral).
		*If disagreement dominates, use beliefs_var >= 4 instead.
		
		gen beliefs_01_bin = (beliefs_01 <= 2)  // 59.38% responded 1 or 2
		gen beliefs_02_bin = (beliefs_02 <= 2)  // 65.58% responded 1 or 2
		gen beliefs_03_bin = (beliefs_03 <= 2)  // 76.97% responded 1 or 2
		gen beliefs_04_bin = (beliefs_04 <= 2)  // 85.38% responded 1 or 2 
		gen beliefs_05_bin = (beliefs_05 <= 2) 	// 90.43% responded 1 or 2
		gen beliefs_06_bin = (beliefs_06 <= 2)  // 90.82% responded 1 or 2
		gen beliefs_07_bin = (beliefs_07 <= 2)  // 67.50% responded 1 or 2
		gen beliefs_08_bin = (beliefs_08 <= 2)  // 83.46% responded 1 or 2
		gen beliefs_09_bin = (beliefs_09 <= 2)  // 77.40% responded 1 or 2

	
* Create aution_village variables

	
	gen target_village = inlist(hhid_village, "122A", "123A", "121B", "131B", "120B") | ///
                     inlist(hhid_village, "123B", "153A", "121A", "131A", "141A") | ///
                     hhid_village == "142A"
					 
					 
  *^*^* Save as a temporary file
			tempfile balance_table_wip
				save `balance_table_wip'

	* bring in trained_hh var 

   use "$trainedData\treated_variable_df.dta", clear 
   
   		*replace hhid_village = "153A" if hhid_village == "132A"
		*replace hhid = "153A" + substr(hhid, 5, .) if substr(hhid, 1, 4) == "132A"

   
			keep hhid trained_hh
				merge m:m hhid using `balance_table_wip'
					drop _merge

	
	  *^*^* bring in Asset index 
	  *** WILL DELETE LATER -- WRONG VILLAGE CODE ***

/*
	  	use "$dataOutput\PCA_asset_index_var.dta", clear
		replace hhid = "153A" + substr(hhid, 5, .) if substr(hhid, 1, 4) == "132A"
		save"$dataOutput\PCA_asset_index_var.dta", replace 
*/
	 	  ** confirm asset index is at hh level 
		merge m:m hhid using "$asset\PCA_asset_index_var.dta"
		
		

*<><<><><>><><<><><>> 
**#  REORDER THE VARIABLES & COLLAPSE AT HOUSEHOLD LEVEL
*<><<><><>><><<><><>>

* drop empty/useless variables 

			drop _merge id species health_5_3_10_ health_5_3_11_ health_5_3_12_ health_5_3_13_ health_5_3_14_ ///
			health_5_3_1_ health_5_3_2_ health_5_3_3_ health_5_3_4_ health_5_3_5_ health_5_3_6_ health_5_3_7_  ///
			health_5_3_8_ health_5_3_99_ health_5_3_9_  ///

			
  *^*^* aggregate by HH head 
  
			  ** Sanity check - 50 households did not report a head 
				gen has_relation_1 = (hh_relation_with_ == 1)  // Indicator: 1 if exists, 0 otherwise
				egen household_has_1 = max(has_relation_1), by(hhid)  // Flag households with any 1


				egen unique_hh = tag(hhid)  // Tag one row per household
				count if household_has_1 == 0 & unique_hh == 1  // Count unique households without relation == 1
				
				drop has_relation_1 household_has_1 unique_hh

** Take care of this issue by replacing hh head with the respondent 

** Clean the household head variables by replacing missing housheold heads with the housheold respondent as the household head

		* Initialize hh_complete variable

			gen hh_resp = 0  
			gen hh_relation_with_1 = hh_relation_with_ == 1
			
			bysort hhid (hh_relation_with_): replace hh_resp = 1 if hh_relation_with_ != 1 & !missing(hh_relation_with_) & resp_index_ == 1 ///
		& sum(hh_relation_with_ == 1) == 0
		

			gen hh_complete = hh_relation_with_1 + hh_resp



			rename hh_age_ hh_age 
			rename hh_gender_ hh_gender
			rename hh_education_skills_5_ hh_education_skills_5
* Loop through the variables and create the corresponding head variables
		foreach var in hh_age hh_gender hh_education_skills_5 hh_education_level_bin {
			* Create new variable for each
			gen `var'_h = . 
			
			* Replace the new variable with the value from the original variable if hh_relation_with_ == 1
			replace `var'_h = `var' if hh_complete == 1
		}

		 
		 
	*^*^* collaspe by mean at the CHILD level 	 
	
	
						
			preserve

				keep if child_in_home == 1

				collapse (count) child_in_home hh_26_ hh_27_ hh_31_bin hh_37_ hh_29_* ///
						 (mean) hh_38_, by(hhid)

				tempfile child_aggregates
				save `child_aggregates'

			restore

		 
		
/*
			preserve

			
					keep if child_in_home == 1

					collapse (mean) child_in_home hh_26_ hh_27_ hh_31_bin hh_37_ hh_38_ hh_29_*, by(hhid)

					tempfile child_aggregates
					save `child_aggregates'

			
			restore
			

*/

  *^*^* collaspe by mean at the HOUSEHOLD level & order variables
  
		collapse (mean) ///
			hh_age_h hh_education_level_bin_h hh_education_skills_5_h hh_gender_h hh_numero trained_hh child_in_home ///
			hh_03_ hh_10_ hh_11_* hh_12_*  hh_13_* hh_14_ hh_15_* hh_16_ /// 	
			health_5_2_ health_5_3_bin health_5_5_ health_5_6_ health_5_12 ///
			agri_income_01 agri_income_05 ///
			montant_02 montant_05 face_04 face_13 game_A_total game_B_total ///
			species_* TLU ///
			agri_6_15 agri_6_32_bin agri_6_36_bin total_land_ha agri_6_34_comp_any ///  // parcel amount & fertilizer & land plot
			living_01_bin living_04_bin living_05_bin ///  //living standards 
			beliefs_01_bin beliefs_02_bin beliefs_03_bin beliefs_04_bin beliefs_05_bin beliefs_06_bin beliefs_07_bin beliefs_08_bin beliefs_09_bin ///  //beliefs
			enum_03_bin enum_04_bin enum_05_bin ///
			asset_index asset_index_std ///
			 (first) hhid_village num_water_access_points q_51 target_village, ///
			by(hhid)
			
			hh_12_6_ hh_03_ health_5_3_bin health_5_6_
			
			merge 1:1 hhid using `child_aggregates'
	//hh_26_ hh_27_  hh_31_bin hh_37_ hh_38_ hh_29_*  ///  //edu vars 
	

		
		order hhid_village hhid hh_age_h hh_education_level_bin_h hh_education_skills_5_h hh_gender_h hh_numero trained_hh ///
			hh_03_ hh_10_ hh_11_* hh_12_*  hh_13_* hh_14_ hh_15_* hh_16_ hh_29_* /// 	
			hh_26_ hh_27_ hh_31_bin hh_37_ hh_38_ ///  //edu vars 
			health_5_2_ health_5_3_bin health_5_5_ health_5_6_ health_5_12 ///
			agri_income_01 agri_income_05 ///
			montant_02 montant_05 face_04 face_13 game_A_total game_B_total ///
			species_* TLU ///
			agri_6_15 agri_6_32_bin agri_6_36_bin total_land_ha ///
			living_01_bin living_04_bin living_05_bin agri_6_34_comp_any ///
			beliefs_01_bin beliefs_02_bin beliefs_03_bin beliefs_04_bin beliefs_05_bin beliefs_06_bin beliefs_07_bin beliefs_08_bin beliefs_09_bin ///  //beliefs
			enum_03_bin enum_04_bin enum_05_bin ///
			asset_index asset_index_std ///
			num_water_access_points q_51 target_village
			
			
 **  - check missings for each var

		foreach var of varlist _all {
			quietly count if missing(`var')
			display "`var': " r(N)
		}

 ** check -9s
 
		 foreach var of varlist _all {
			* Check if the variable is numeric (ignoring strings)
			capture confirm numeric variable `var'
			if !_rc {  // If the variable is numeric
				* Count if -9 exists in the numeric variable
				count if `var' == -9
				if r(N) > 0 {
					display "`var' contains -9"
				}
			}
		}


				
  *^*^* Label final variables
  
		
			label variable trained_hh "Trained household"
			label variable hh_age_h "Household head age"
			label variable hh_gender_h "Household head gender"
			label variable hh_education_skills_5_h "Indicator that household head is literate (1=Yes, 0=No)"
			label variable hh_education_level_bin_h "Indicator for household head with secondary education or higher"
			label variable hh_numero "Size of household"
			
			label variable hh_03_ "Worked in domestic agricultural activities?"
			label variable hh_10_ "Hours per week spent within 1 meter of surface water source"
			label variable hh_11_ "Source(s) of surface water?"
			label variable hh_11_1 "Lake"
			label variable hh_11_2 "Pond"
			label variable hh_11_3 "River"
			label variable hh_11_4 "Irrigation channel"
			label variable hh_11_99 "Other, give details"
			label variable hh_12_8_ "Play"
			label variable hh_12_7_ "Swim/bathe"
			label variable hh_12_6_ "Harvest aquatic vegetation"
			label variable hh_12_5_ "Do the dishes"
			label variable hh_12_4_ "Wash clothes"
			label variable hh_12_3_ "Fetch water for agriculture"
			label variable hh_12_2_ "Give water to livestock"
			label variable hh_12_1_ "Fetch water for the household"
			label variable hh_13_08 "Hours spent playing in the water"
			label variable hh_13_07 "Hours spent swimming/bathing"
			label variable hh_13_06 "Hours spent harvesting aquatic vegetation"
			label variable hh_13_05 "Hours spent washing the dishes"
			label variable hh_13_04 "Hours spent washing clothes"
			label variable hh_13_03 "Hours spent fetching water for agriculture"
			label variable hh_13_02 "Hours spent giving water to livestock"
			label variable hh_13_01 "Hours spent fetching water for the household"
			label variable hh_14_ "Of those who answered 'Harvest aquatic vegetation', how much aquatic vegetation did [NAME] collect?"
			label variable hh_15_ "How did he use aquatic vegetation?"
			label variable hh_15_1 "Sell"
			label variable hh_15_2 "Fertilizer"
			label variable hh_15_3 "Livestock feed"
			label variable hh_15_4 "Raw material for the biodigester"
			label variable hh_15_5 "Nothing"
			label variable hh_15_99 "Other (to be specified)"
			
			label variable hh_16_ "Hours spent producing fertilizer, purchasing it, or applying it on the field"
			label variable hh_26_ "Currently enrolled in formal school? (1=Yes, 2=No)"
			label variable hh_27_ "Attended non-formal school or training? (1=Yes, 0=No, asked to children)"
			label variable hh_29_01 "Indicator for primary level education (1=Yes, 0=No, asked about children)"
			label variable hh_29_02 "Indicator for secondary middle level education (1=Yes, 0=No, asked about children)"
			label variable hh_29_03 "Indicator for secondary higher level education (1=Yes, 0=No, asked about children)"
			label variable hh_29_04 "Indicator for upper secondary education (1=Yes, 0=No, asked about children)"

			label variable hh_31_ "School performance during the 2023/2024 year"
			label variable hh_31_bin "Indicator if student completed studies or moved to next class (1=Yes, 0=No, asked to children)"
			label variable hh_38_ "Days attended school in the past 7 days"
			label variable hh_37_ "Missed >1 consecutive week of school due to illness in the past 12 months? (1=Yes, 0=No, asked to children)"
		
			label variable health_5_2_ "Has [Name] been ill last 12 months"
			label variable health_5_3_bin "Indicator for bilharzia or diarrhea in the past 12 months"
			label variable health_5_5_ "Received medication for the treatment of schistosomiasis?"
			label variable health_5_6_ "Person ever been diagnosed with schistosomiasis?"
			label variable health_5_12_ "What is the distance in km to this service or healthcare professional?"
			
			label variable agri_6_15 "How many plots within the fields cultivated by the household?"
			label variable agri_6_32_bin "Used any organic fertilizer"
			label variable agri_6_36_bin  "Used any inorganic/chemical fertilizer"
			label variable agri_6_34_comp_any  "Indicator if a houshold used any compost on any parcel (1=Yes, 0=No)"
			label variable agri_income_01 "Did you (or any member of your household) engage in paid agricultural work in the last 12 months?"
			label variable agri_income_05 "Amount received in kind/cash for agricultural work"
			label variable asset_index "PCA Asset Index"
			label variable asset_index_std "Standardized PCA Asset Index"
			
		
			label variable species_1 "Cattle"
			label variable species_2 "Sheep"
			label variable species_3 "Goat"
			label variable species_4 "Horse (equine)"
			label variable species_5 "Donkey"
			label variable species_6 "Draft animals"
			label variable species_7 "Pigs"
			label variable species_8 "Poultry"
			label variable species_9 "Other"
			label variable species_count "Number of livestock"
			label variable TLU "Tropical livestock units"
			
			label variable living_01_bin "Indicator for selected tap water as main source of drinking water"
			label variable living_04_bin "Indicator for selected main type of toilet: Flush with sewer, Flush with septic tank"
			label variable living_05_bin "Indicator for electricity as main cooking fuel"
			
			label variable beliefs_01_bin "Probability of contracting bilharzia in the next 12 months (1=Strongly agree/Agree)"
			label variable beliefs_02_bin "Probability of household member contracting bilharzia in the next 12 months (1=Strongly agree/Agree)"
			label variable beliefs_03_bin "Probability of a child contracting bilharzia in the next 12 months (1=Strongly agree/Agree)"
			label variable beliefs_04_bin "Agree: Village land should belong to the community, not individuals (1=Strongly agree/Agree)"
			label variable beliefs_05_bin "Agree: Village water sources should belong to the community, not individuals (1=Strongly agree/Agree)"
			label variable beliefs_06_bin "Agree: I should have rights to products from my land (1=Strongly agree/Agree)"
			label variable beliefs_07_bin "Agree: I should have rights to products from community land I work on (1=Strongly agree/Agree)"
			label variable beliefs_08_bin "Agree: I should have rights to products from community water sources I fish in (1=Strongly agree/Agree)"
			label variable beliefs_09_bin "Agree: I should have rights to products from community water sources I harvest from (1=Strongly agree/Agree)"
			
			label variable montant_02 "Amount paid by the respondent for game A: ________ FCFA"
			label variable montant_05 "Amount paid by the respondent for game B: ________ FCFA"
			label variable face_04 "Amount paid by the respondent for game B: ________ FCFA"
			label variable face_13 "Amount paid by the respondent for game A: ________ FCFA"
			label variable game_A_total "Total amount paid for Game A"
			label variable game_B_total "Total amount paid for Game B"
			
			
			label variable enum_03_bin "(Enumerator observation) Indicator if concrete/cement is main material for the house roof"
			label variable enum_05_bin "(Enumerator observation) Indicator if concrete/cement is main material for the house floor"
			label variable enum_04_bin "(Enumerator observation) Indicator if walls in household head's room made of concrete or cement."
			
			label variable num_water_access_points "Number of village water access points"
			label variable target_village  "Indicator for auction village"
			label variable q_51  "Distance to nearest healthcare center (km)"

			
*<><<><><>><><<><><>> 
**#  SAVE THE FINAL DATASET 
*<><<><><>><><<><><>>

		*save "${dataOutput}\baseline_balance_tables_data.dta", replace


*<><<><><>><><<><><>>
* Keep JUST PAP variables 
*<><<><><>><><<><><>>

*vars removed:
	* hh_27
	* hh_31_bin
	
		** Drop missings (are now ONLY the true missings)


		

		 keep hhid_village hhid trained_hh hh_age_h hh_education_level_bin_h hh_education_skills_5_h hh_gender_h hh_numero  ///
		 hh_03_ hh_10_ hh_12_6 hh_16_ hh_15_2 ///
		 hh_26_ hh_29_01 hh_29_02 hh_29_03 hh_29_04 hh_37_ hh_38_  /// //education variables 
		 living_01_bin game_A_total game_B_total   ///
		 TLU agri_6_15 agri_6_32_bin agri_6_36_bin total_land_ha agri_6_34_comp_any ///
		 agri_income_01 agri_income_05 ///
		 beliefs_01_bin beliefs_02_bin beliefs_03_bin beliefs_04_bin beliefs_05_bin beliefs_06_bin beliefs_07_bin beliefs_08_bin beliefs_09_bin  ///
		 health_5_3_bin health_5_6_ ///
		 num_water_access_points q_51 target_village
		 
		 
/*
		foreach var of varlist * {
    drop if missing(`var')
}
*/

		 
		 order hhid_village hhid trained_hh hh_age_h hh_education_level_bin_h hh_education_skills_5_h hh_gender_h hh_numero  ///
		 hh_03_ hh_10_ hh_12_6 hh_16_ hh_15_2 ///
		 hh_26_  hh_29_01 hh_29_02 hh_29_03 hh_29_04 hh_37_ hh_38_  /// //education variables 
		 living_01_bin game_A_total game_B_total   ///
		 TLU agri_6_15 agri_6_32_bin agri_6_36_bin total_land_ha agri_6_34_comp_any ///
		 agri_income_01 agri_income_05 ///
		 beliefs_01_bin beliefs_02_bin beliefs_03_bin beliefs_04_bin beliefs_05_bin beliefs_06_bin beliefs_07_bin beliefs_08_bin beliefs_09_bin  ///
		 health_5_3_bin health_5_6_ ///
		 num_water_access_points q_51 target_village
		 
		 save "${dataOutput}\baseline_balance_tables_data_PAP.dta", replace


*<><<><><>><><<><><>> 
* RUN MULTILOGIT REGRESSION
*<><<><><>><><<><><>>

/*

		use "${dataOutput}\baseline_balance_tables_data_PAP.dta", clear 

* Create group variable by extracting characters 3-4 from hhid
gen group = substr(hhid, 3, 2)

* Initialize treatment_group variable
gen treatment_group = ""

* Assign treatment groups based on 'group' variable
replace treatment_group = "Control"    if inlist(group, "0A", "0B")
replace treatment_group = "Treatment1" if inlist(group, "1A", "1B")
replace treatment_group = "Treatment2" if inlist(group, "2A", "2B")
replace treatment_group = "Treatment3" if inlist(group, "3A", "3B")

* Assign 'Local Control' based on the combination of group and trained_hh
*replace treatment_group = "Local Control" if inlist(group, "1A", "1B", "2A", "2B", "3A", "3B") & trained_hh == 0
drop group 

/*
gen group = substr(hhid, 3, 2)  // Extract characters 3-4 from hhid

	gen treatment_group = ""  // Initialize variable
	replace treatment_group = "Control"    if inlist(group, "0A", "0B")
	replace treatment_group = "Treatment1" if inlist(group, "1A", "1B")
	replace treatment_group = "Treatment2" if inlist(group, "2A", "2B")
	replace treatment_group = "Treatment3" if inlist(group, "3A", "3B")

drop group  // Remove the temporary 'group' variable if not needed
 */


encode treatment_group, gen(treatment_group_num)  // Convert string to numeric


mlogit treatment_group_num hh_age_h hh_education_level_bin_h hh_education_skills_5_h, baseoutcome(1) vce(cluster hhid_village)

* Run multinomial logit regression with clustered standard errors at the hhid_village level
mlogit treatment_group_num hh_age_h hh_education_level_bin_h hh_education_skills_5_h hh_gender_h hh_numero hh_03_ hh_10_ hh_12_6_ hh_16_ ///
  hh_26_ hh_29_01 hh_29_02 hh_29_03 hh_29_04 hh_37_ hh_38_  ///
  living_01_bin game_A_total game_B_total ///
  TLU agri_6_15 agri_6_32_bin agri_6_36_bin total_land_ha agri_6_34_comp_any agri_income_01 agri_income_05 beliefs_01_bin ///
  beliefs_02_bin beliefs_03_bin beliefs_04_bin beliefs_05_bin beliefs_06_bin beliefs_07_bin beliefs_08_bin beliefs_09_bin ///
  health_5_3_bin health_5_6_ num_water_access_points q_51 target_village, baseoutcome(1) vce(cluster hhid_village) 

  test hh_age_h hh_education_level_bin_h hh_education_skills_5_h hh_gender_h hh_numero hh_03_ hh_10_ hh_12_6_ hh_16_ ///
  hh_26_ hh_29_01 hh_29_02 hh_29_03 hh_29_04 hh_37_ hh_38_  ///
  living_01_bin game_A_total game_B_total ///
  TLU agri_6_15 agri_6_32_bin agri_6_36_bin total_land_ha agri_6_34_comp_any agri_income_01 agri_income_05 beliefs_01_bin ///
  beliefs_02_bin beliefs_03_bin beliefs_04_bin beliefs_05_bin beliefs_06_bin beliefs_07_bin beliefs_08_bin beliefs_09_bin ///
  health_5_3_bin health_5_6_ num_water_access_points q_51 target_village

*cluster(hhid_village)



*/

































