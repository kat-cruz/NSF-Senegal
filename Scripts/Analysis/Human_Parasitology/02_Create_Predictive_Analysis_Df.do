*==============================================================================
* Program: parasitological data frame analysis construction 
*=============================================================================

* written by: Kateri Mouawad
* Created: February 2025
* Updates recorded in GitHub


* <><<><><>> Read Me  <><<><><>>

			** This file processes: 

							* Complete_Baseline_Health.dta
							* Complete_Baseline_Household_Roster.dta
							* Complete_Baseline_Standard_Of_Living.dta
							* Complete_Baseline_Beliefs.dta
							* Complete_Baseline_Agriculture.dta
							* Complete_Baseline_Community.dta
							* PCA_asset_index_var.dta
							* DISES_baseline_ecological data.dta
							* 01_prepped_inf_matches_df.dta
	
			** This .do file outputs:

							* 02_child_infection_analysis_df.dta

*-----------------------------------------*
**# INITIATE SCRIPT
*-----------------------------------------*
		
	clear all
	set mem 100m
		set maxvar 30000
		set matsize 11000
	set more off

*-----------------------------------------*
**# SET FILE PATHS
*-----------------------------------------*

*<><<><><>><><<><><>>

*^*^* Set base Box path for each user
	if "`c(username)'"=="socrm" global master "C:\Users\socrm\Box\NSF Senegal\Data_Management"
	if "`c(username)'"=="kls329" global master "C:\Users\kls329\Box\NSF Senegal\Data_Management"
	if "`c(username)'"=="km978" global master "C:\Users\km978\Box\NSF Senegal\Data_Management"
	if "`c(username)'"=="Kateri" global master "C:\Users\Kateri\Box\NSF Senegal\Data_Management"
	if "`c(username)'"=="admmi" global master "C:\Users\admmi\Box\NSF Senegal\Data_Management"


*^*^* Define project-specific paths

	global crdes_data "${master}\Data\_CRDES_CleanData\Baseline\Deidentified"
	global crdes_long_data "${master}\Output\Data_Processing\Construction"
	global eco_data "${master}\Data\_Partner_CleanData\Ecological_Data"
	global output "${master}\Output\Analysis\Human_Parasitology\Analysis_Data"
	global asset "${master}\Output\Data_Processing\Construction"
	global paras"${master}\Output\Analysis\Human_Parasitology\Analysis_Data"
	global tidy "${master}\Output\Analysis\Human_Parasitology\Analysis_Data\Tidy_data"
	
*<><<><><>><><<><><>>
**# BEGIN BASELINE WORK
*<><<><><>><><<><><>>


*-----------------------------------------*
**## HOUSEHOLD ROSTER MODULE 
*-----------------------------------------*

*-------------------*
**### Load in data 
*-------------------*

	use "${crdes_long_data}\baseline_household_long.dta", clear // health data 
	
		drop if missing(hh_age_) & missing(hh_gender_) & missing(hh_ethnicity_)

*-------------------*
**### Keep pre-selected variables
*-------------------*

	 	keep hhid individ hh_age_ hh_gender_ hh_main_activity_  ///
		hh_10_ hh_12_6_ hh_15_ hh_26_ hh_32_ hh_37_ 

*-------------------*
**#### recode gender
*-------------------*	
		*^*^*  Recode hh_gender_ (change 2 to 0, leave others unchanged)
		recode hh_gender_ (2=0)
		
		
*-------------------*
**### Check for missings
*-------------------*		

		foreach var of varlist _all {
			quietly count if missing(`var')
			display "`var': " r(N)
		}
		
*-------------------*
**#### Replace logic missings
*-------------------*				
		
	** hh_12_ 
	** Skip pattern: ${hh_10} > 0
		
		replace hh_12_6_ = 0 if hh_10_ == 0

	** hh_10
	** Skip pattern: ${hh_10} > 0 and selected(${hh_12}, "6")	
		
		replace hh_15_ = 0 if hh_10_ == 0 
		replace hh_15_ = 0 if hh_12_6_ == 0	
				
	** hh_37_
	** ${hh_32} = 1 and then ${hh_26} = 1 (hh_32 is conditional on hh_26)
		
		replace hh_32_ = 0 if hh_26_ == 0	// child module - hh_26 begins the module, so the missings come from adults 
		replace hh_37_ = 0 if hh_32_ == 0		
	
	** replace if kids didn't answer these questions KRM - look into this
		foreach var in hh_32_ hh_37_ {
				replace `var' = 0 if missing(`var') & (hh_age_ >= 4 & hh_age_ <= 18)
			}
		
				
*-------------------*
**#### Replace "I don't knows" with missings
*-------------------*				
		
	** replace 2s for variables that have option "I don't know" 
		*1 Yes
		*0 No
		*2 Don't know / Don't answer
		

		foreach var in hh_26_ hh_37_  ///
	 {
			replace `var' = .a if `var' == 2
		}

*-------------------*
**### Begin variable creation
*-------------------*				


*-------------*
**#### hh_15
*-------------*			
		
		*How did he use aquatic vegetation?
* Creating binary variables for hh_15
		foreach x in 1 2 3 4 5 99 {
			gen hh_15_`x' = hh_15_ == `x'
			replace hh_15_`x' = 0 if missing(hh_15_)
		}		
		
		
*-------------*
**#### fishing
*-------------*	

	 gen fishing = .
	 replace fishing = 1 if hh_main_activity_ == 3
	 replace fishing = 0 if hh_main_activity_ != 3
	 
*-------------------*
**### Save data set 
*-------------------*	

/*
	merge m:m individ using "${output}\child_matched_IDs_df", nogen 
		keep if !missing(match_score)
*/

		save "$tidy\household_roster", replace 
		

*-----------------------------------------*
**## HEALTH MODULE
*-----------------------------------------*

*-------------------*
**### Load in data 
*-------------------*

	use "${crdes_long_data}\baseline_health_long.dta", clear // health data 
	
		drop if missing(health_5_2_) & missing(healthgenre_) & missing(healthindex_)

*-------------------*
**### Keep pre-selected variables
*-------------------*

	 	keep hhid individ health_5_2_ health_5_3_1_ health_5_3_2_ health_5_3_3_ health_5_3_6_ health_5_3_9_ ///
		health_5_5_ health_5_8_ health_5_9_


*-------------------*
**### Check for missings
*-------------------*		

		foreach var of varlist _all {
			quietly count if missing(`var')
			display "`var': " r(N)
		}
	
		
*-------------------*
**#### Replace logic missings
*-------------------*				
		
	** health_5_3_ 
	** Skip pattern: ${health_5_2} = 1

			foreach var in health_5_2_ health_5_3_1_ health_5_3_2_ health_5_3_3_ health_5_3_6_ health_5_3_9_ {
				replace `var' = 0 if health_5_2_ == 0
			}	
				
*-------------------*
**#### Replace "I don't knows" with missings
*-------------------*				
		
	** replace 2s for variables that have option "I don't know" 
		*1 Yes
		*0 No
		*2 Don't know / Don't answer
		

		foreach var in health_5_3_1_ health_5_3_2_ health_5_3_3_ health_5_3_6_ health_5_3_9_  {
			replace `var' = .a if health_5_2_ == 2
		}
		

		foreach var in health_5_2_ health_5_5_ health_5_8_ health_5_9_ {
			replace `var' = .a if `var' == 2
		}
		
*-------------------*
**### Save data set 
*-------------------*				

/*
	merge m:m individ using "${output}\child_matched_IDs_df", nogen 
		keep if !missing(match_score)
*/

			
		save "$tidy\health_module.dta", replace 
		
*-----------------------------------------*
**## STANDARD OF LIVING MODULE 
*-----------------------------------------*

*-------------------*
**### Load in data 
*-------------------*

	use "${crdes_data}\Complete_Baseline_Standard_Of_Living.dta", clear // health data 
	
	*-------------------*
**### Keep pre-selected variables
*-------------------*

	 	keep hhid living_01

*-------------------*
**### Check for missings
*-------------------*		

		foreach var of varlist _all {
			quietly count if missing(`var')
			display "`var': " r(N)
		}
		
*-------------------*
**### Begin variable creation
*-------------------*				

*-------------*
**#### living_01_bin
*-------------*			
		
** living_01_bin

	** main source of drinking water supply
		** 1 = Interior tap
		** 2 = Public tap
		** 3 = Neighbor's tap
		** 4 = Protected well
		** 7 = Tanker truck service
		** 8 = Water vendor


		gen living_01_bin = 0
			replace living_01_bin = 1 if living_01 == 1 |living_01 == 2 | living_01 == 3 | living_01 == 4 | living_01 == 7 | living_01 == 8
			
*-------------*
**#### hhid_village
*-------------*			
			
			gen hhid_village = substr(hhid, 1, 4)

			
*-------------------*
**### Save data set 
*-------------------*		

/* 
	merge m:m hhid using "${output}\child_matched_IDs_df", nogen 
		keep if !missing(match_score)
		
	** drop individual level variables 
		drop individ match_score identificant
*/
		
				save "$tidy\standard_of_living_module.dta", replace 
				
*-----------------------------------------*
**## BELIEFS MODULE
*-----------------------------------------*

*-------------------*
**### Load in data 
*-------------------*

	use "${crdes_data}\Complete_Baseline_Beliefs.dta", clear // beliefs data 
	
*-------------------*
**### Keep pre-selected variables
*-------------------*

	 	keep hhid beliefs_01 beliefs_02 beliefs_03

*-------------------*
**### Check for missings
*-------------------*		

		foreach var of varlist _all {
			quietly count if missing(`var')
			display "`var': " r(N)
		}
		
*-------------------*
**### Begin variable creation
*-------------------*				
	
		
** create a Binary Indicator
		*If most responses are ≤2 (Agree/Strongly Agree) → use beliefs_var <= 2 as the binary indicator.
		*If responses are more evenly spread, consider using ≤3 (including Neutral).
		*If disagreement dominates, use beliefs_var >= 4 instead.

*-------------*
**#### beliefs_01_bin
*-------------*		
		
		gen beliefs_01_bin = (beliefs_01 <= 2)  // 55.92% responded 1 or 2
*-------------*
**#### beliefs_02_bin
*-------------*		
		gen beliefs_02_bin = (beliefs_02 <= 2)  // 64.45% responded 1 or 2
*-------------*
**#### beliefs_03_bin
*-------------*	
		gen beliefs_03_bin = (beliefs_03 <= 2)  // 80.09% responded 1 or 2
		
*-------------*
**#### hhid_village
*-------------*			
			
			gen hhid_village = substr(hhid, 1, 4)

*-------------------*
**### Save data set 
*-------------------*		
/* 

	merge m:m hhid using "${output}\child_matched_IDs_df", nogen 
		keep if !missing(match_score)
		
	** drop individual level variables 
		drop individ match_score identificant
*/
		
			save "$tidy\beliefs_module.dta", replace 			
		
*-----------------------------------------*
**## ECOLOGICAL DATA 
*-----------------------------------------*

*-------------------*
**### Load in data 
*-------------------*

	use "${eco_data}\DISES_baseline_ecological data.dta", clear // eco data 
	
*-------------------*
**### Keep pre-selected variables
*-------------------*

	 keep hhid_village Cerratophyllummassg Bulinus Biomph Humanwatercontact Schistoinfection InfectedBulinus  InfectedBiomphalaria schisto_indicator 
		
*-------------------*
**### Check for missings
*-------------------*		

		foreach var of varlist _all {
			quietly count if missing(`var')
			display "`var': " r(N)
		}
		
		** 3 villages missing humanwatercoontact
					
*-------------------*
**### Save data set 
*-------------------*		
	
/* 
	merge m:m hhid using "${output}\child_matched_IDs_df", nogen 
		keep if !missing(match_score)	
	
	** drop individual level variables 
		drop individ match_score identificant	
*/
		
				save "$tidy\eco_data.dta", replace 

*-----------------------------------------*
**## PARASITOLOGICAL DATA
*-----------------------------------------*

*-------------------*
**### Load in data 
*-------------------*

	use "${paras}\01_baseline_paras_df.dta", clear // paras data 
	

*-------------------*
**### Keep pre-selected variables
*-------------------*

	 	keep hhid_village village_name identificant fu_p1 fu_p2 p1_kato1_k1_epg p1_kato2_k2_epg p2_kato1_k1_epg p2_kato2_k2_epg


*-------------------*
**### Check for missings
*-------------------*		

		foreach var of varlist _all {
			quietly count if missing(`var')
			display "`var': " r(N)
		}
			
	** None 

*-------------------*
**### Begin variable creation
*-------------------*				

***  covert variables from string to numeric *** 
		* written by MJD *
		destring fu_p1 fu_p2 p1_kato1_k1_epg p1_kato2_k2_epg p2_kato1_k1_epg p2_kato2_k2_epg, replace force 

*-------------*
**#### sh_inf
*-------------*				
		
		*** count infection of s. haematobium *** 
		gen sh_inf = 0 
		replace sh_inf = 1 if fu_p1 > 0 & fu_p1 != .
		replace sh_inf = 1 if fu_p2 > 0 & fu_p2 != . 

*-------------*
**#### sm_inf
*-------------*	

		gen sm_inf = 0 
		replace sm_inf = 1 if p1_kato1_k1_epg > 0 & p1_kato1_k1_epg != . 
		replace sm_inf = 1 if p1_kato2_k2_epg > 0 & p1_kato2_k2_epg != . 
		replace sm_inf = 1 if p2_kato1_k1_epg > 0 & p2_kato1_k1_epg != . 
		replace sm_inf = 1 if p2_kato2_k2_epg > 0 & p2_kato2_k2_epg != . 

		*** summarize infection results by village *** 
		bysort hhid_village: sum sh_inf sm_inf
		  
		*** summarize infection results overall ***
		sum sh_inf sm_inf  

		
*-------------*
**#### sh_egg_count
*-------------*	
	
*** Calculate egg counts
	
		gen sh_egg_count = cond(fu_p1 > 0, fu_p1, fu_p2)
	
*-------------*
**#### p1_avg
*-------------*	

		gen p1_avg = (p1_kato1_k1_epg + p1_kato2_k2_epg) / 2
	
*-------------*
**#### p2_avg
*-------------*	

		gen p2_avg = (p2_kato1_k1_epg + p2_kato2_k2_epg) / 2
		
*-------------*
**#### sm_egg_count
*-------------*	

		gen sm_egg_count = cond(p1_avg > 0, p1_avg, p2_avg)
	
*-------------*
**#### total_egg
*-------------*	

* Create total egg count

		gen total_egg = sm_egg_count + sh_egg_count
		
*-------------------*
**### Keep pre-selected variables
*-------------------*
			
		
	keep hhid_village village_name identificant sh_inf sm_inf sh_egg_count p1_avg p2_avg sm_egg_count total_egg	
		
*-------------------*
**### Save data set 
*-------------------*		
	
	
/*
	merge m:m identificant using "${output}\child_matched_IDs_df", nogen 
		keep if !missing(match_score)	
*/
	
				save "$tidy\paras_data.dta", replace 
				
		

*-----------------------------------------*
**## Matched Data & merge 
*-----------------------------------------*		

** 31 individuals in the health module and NOT in the household roster. Look into. 

/* 
**long dfs 
		use "$crdes_long_data\baseline_household_long", clear
			merge 1:1 individ using "$crdes_long_data\baseline_health_long"
** og wide dfs 			
		use "$crdes_data\Complete_Baseline_Household_Roster", clear
			use "$crdes_data\Complete_Baseline_Health", clear
** what i cleaned 			
		use "$tidy\household_roster", clear // individual level data 
		use "$tidy\health_module", clear
*/
		
		
		use "$tidy\household_roster", clear // individual level data 
			merge 1:1 individ using "$tidy\health_module" 	 // individual level data 
					keep if _merge != 3
			
			
					 save "$tidy\indiv_level_data.dta", replace 
					
		use "$tidy\standard_of_living_module", clear
			merge 1:1 hhid using "$tidy\beliefs_module", nogen // household level data 		
						save "$tidy\hh_level_data.dta", replace 

		use "$tidy\indiv_level_data.dta", clear
			merge m:1 hhid using "$tidy\hh_level_data.dta", nogen
			merge m:1 hhid_village using "$tidy\eco_data.dta"

			
			
			
			
			
			
			
			
			
			
			*/
			
	** Now link parasitological data
	
			*merge m:1 individ using "${output}\child_matched_IDs_df", nogen
/*						
		
		use `hh_data', clear
			merge m:1 hhid_village using "$tidy\eco_data.dta", nogen
			
					use "$tidy\household_roster", clear // individual level data 
			merge 1:1 individ using "$tidy\health_module", nogen 	 // individual level data 
							tempfile indiv_data
								save `indiv_data'
		
		
/*


		living_01  ///
		health_5_2* health_5_3_* health_5_5* health_5_8* health_5_9* ///
		beliefs_01* beliefs_02* beliefs_03* ///
		q_23 q_24 ///
		asset_index asset_index_std /// 
		Cerratophyllummassg Bulinus Biomph Humanwatercontact Schistoinfection InfectedBulinus  InfectedBiomphalaria schisto_indicator 


tostring health_5_3_*, replace 

drop health_5_3_o* hh_15_o*

*variables removed: hh_age hh_gender living_01 living_02 living_03 living_04

* Reshape long with hhid and id
	reshape long health_5_2_ health_5_3_ health_5_5_ health_5_8_ health_5_9_ /// 	
	health_5_3_1_ health_5_3_2_ health_5_3_3_ health_5_3_4_ health_5_3_5_ health_5_3_6_ health_5_3_7_ health_5_3_8_ health_5_3_9_ health_5_3_10_ health_5_3_11_ health_5_3_12_ health_5_3_13_ health_5_3_14_ health_5_3_99_ ///
	 hh_15_ hh_10_ hh_12_6_ hh_26_ hh_32_ hh_37_ hh_age_ hh_gender_, ///
		i(hhid) j(id)
	
	
* Create matching individual_id_crdes
	tostring hhid, replace format("%12.0f")
	tostring id, gen(str_id) format("%02.0f")
	gen str individual_id_crdes = hhid + str_id
	format individual_id_crdes %15s
	
	  *^*^* Save as a temporary file
			tempfile temp_features_reshaped
				save `temp_features_reshaped'

	
	use "${paras}\01_prepped_inf_matches_df.dta", clear
	rename _merge merge_ 

	merge m:1 individual_id_crdes using `temp_features_reshaped'

		keep if _merge == 3

			drop sex_epls_ucad

*<><<><><>><><<><><>>
**# BEGIN DATA CLEANING/PROCESSING
*<><<><><>><><<><><>>

*^*^* Initial look at data - check missings for each var


	foreach var in Humanwatercontact Biomph Cerratophyllummassg health_5_3_99_ health_5_3_1_-health_5_3_14_ /// 
	{
	
	destring `var', replace 
	
}

		foreach var of varlist _all {
			quietly count if missing(`var')
			display "`var': " r(N)
		}

*^*^* Variables found to have missings 
		
		* hh_15_: 211
		* Humanwatercontact: 3
		* q_24: 19
		* hh_37_: 36
		* hh_26_: 6
		* hh_12_6_: 101
		* health_5_3_1_ - health_5_3_14_: 93
		* sh_kk_2: 210
		* sh_kk_1: 206
		* sex_crdes: 11
		* age_crdes: 3
		

** replace 2s for variables that have option "I don't know" 
	*1 Yes
	*0 No
	*2 Don't know / Don't answer
	
*^*^* Fill out logical missings 

** hh_12_ 
** Skip pattern: ${hh_10} > 0
	
	replace hh_12_6_ = 0 if hh_10_ == 0

** hh_10
** Skip pattern: ${hh_10} > 0 and selected(${hh_12}, "6")	
	
	replace hh_15_ = 0 if hh_10_ == 0 
	replace hh_15_ = 0 if hh_12_6_ == 0	
	
	

	*How did he use aquatic vegetation?
* Creating binary variables for hh_15
		foreach x in 1 2 3 4 5 99 {
			gen hh_15_`x' = hh_15_ == `x'
			replace hh_15_`x' = 0 if missing(hh_15_)
		}



	
	

** 	health_5_3_ 

	* 1. Malaria
	* 2.bilharzia
	* 3. Diarrhea
	* 4. Injury
	* 5. Dental issues
	* 6. Skin issues
	* 7. Eye issues
	* 8 Throat issues
	* 9. Stomach ache
	* 10. Fatigue
	* 12.STI
	* 13.Trachoma
	* 14.Onchocerciasis
	* 15 Lymphatic filariasis
	* 99.Other (to be specfied)

** 	Skip pattern: ${health_5_2} = 1


	foreach var in health_5_3_99_ ///
              health_5_3_1_ health_5_3_2_ health_5_3_3_ health_5_3_4_ ///
              health_5_3_5_ health_5_3_6_ health_5_3_7_ health_5_3_8_ ///
              health_5_3_9_ health_5_3_10_ health_5_3_11_ health_5_3_12_ ///
              health_5_3_13_ health_5_3_14_ {
    replace `var' = 0 if health_5_2_ == 0
}

	
** sh_kk_1 & sh_kk_2 - verify this is ok as these may be genuine missings 
	
	rename sh_kk_2 sh_kk_2_string
	gen sh_kk_2 = "0"
	replace sh_kk_2 = "1" if !missing(sh_kk_2_string)

	rename sh_kk_1 sh_kk_1_string
	gen sh_kk_1 = "0"
	replace sh_kk_1 = "1" if !missing(sh_kk_1_string)

    destring sh_kk_1, replace 
	destring sh_kk_2, replace 

**will likely drop later

** q_24
** Skip pattern: q_23 == 0

	replace q_24 = 0 if q_23 == 0
	
*^*^* remove 2s from yes/no questions 

	foreach var in hh_26_ hh_37_ health_5_5_  health_5_8_ health_5_9_ ///
 {
		replace `var' = .a if `var' == 2
	}



*^*^* replace -9s with NAs for variables that contain them


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

*^*^*  Recode hh_gender_ (change 2 to 0, leave others unchanged)
		recode hh_gender_ (2=0)


*<><<><><>><><<><><>>
**# BEGIN VARIABLE CREATION
*<><<><><>><><<><><>>


** living_01_bin

	** main source of drinking water supply
		** 1 = Interior tap
		** 2 = Public tap
		** 3 = Neighbor's tap
		** 4 = Protected well
		** 7 = Tanker truck service
		** 8 = Water vendor


		gen living_01_bin = 0
			replace living_01_bin = 1 if living_01 == 1 |living_01 == 2 | living_01 == 3 | living_01 == 4 | living_01 == 7 | living_01 == 8


**  beliefs_01	10.1 How likely is it that you will contract schistosomiasis in the next 12 months?
** 	beliefs_02	10.2 How likely is it that a member of your household will contract schistosomiasis in the next 12 months? 
**		(If there is already a household member affected by schistosomiasis, ask the question for all unaffected individuals)
** beliefs_03	10.3 How likely is it that a randomly chosen child in your village, between the ages of 5 and 14, will contract schistosomiasis in the next 12 months?

   ** choose a cutoff (e.g., above median)
	foreach var of varlist beliefs_01 - beliefs_03 {
		tab `var'  // Look at percentiles
		}




	

**# Save final output		
		
*** drop uneeded variables


		keep  village_id village_name hhid individual_id_crdes match_score epls_or_ucad epls_ucad_id ///
			hh_10_ hh_12_6_ hh_26_ hh_32_ hh_37_ hh_age_ hh_gender_ hh_age_resp hh_gender_resp  ///
			health_5_2 health_5_3_1_ health_5_3_2_ health_5_3_3_ health_5_3_6_ health_5_3_9_ health_5_5 health_5_8 health_5_9 ///
			living_01_bin beliefs_01_bin beliefs_02_bin beliefs_03_bin ///
			q_23 q_24 /// 
			asset_index asset_index_std ///
			Cerratophyllummassg Bulinus Biomph Humanwatercontact Schistoinfection InfectedBulinus InfectedBiomphalaria schisto_indicator ///
			sh_inf sm_inf sh_egg_count sm_egg_count total_egg 


	 
		order village_id village_name hhid individual_id_crdes match_score epls_or_ucad epls_ucad_id ///
			hh_10_ hh_12_6_ hh_26_ hh_32_ hh_37_ hh_age_ hh_gender_ hh_age_resp hh_gender_resp  ///
			health_5_2 health_5_3_1_ health_5_3_2_ health_5_3_3_ health_5_3_6_ health_5_3_9_ health_5_5 health_5_8 health_5_9 ///
			living_01_bin beliefs_01_bin beliefs_02_bin beliefs_03_bin ///
			q_23 q_24 /// 
			asset_index asset_index_std ///
			Cerratophyllummassg Bulinus Biomph Humanwatercontact Schistoinfection InfectedBulinus InfectedBiomphalaria schisto_indicator ///
			sh_inf sm_inf sh_egg_count sm_egg_count total_egg 

				
	
	*** label variables:
	
			label variable village_id "Village ID"
			label variable village_name "Village name"
			
			label variable hh_age_ "Individual's age"
			label variable hh_gender_ "Individual's gender"
			label variable hh_age_resp "Household respondent's age"
			label variable hh_gender_resp "Household respondent's gender"

			label variable hh_10_ "Hours per week spent within 1 meter of surface water source"
			label variable hh_26_ "Currently enrolled in formal school? (1=Yes, 2=No)"
			label variable hh_32 "Attends school during the 2023/2024 academic year"
			label variable hh_37_ "Missed >1 consecutive week of school due to illness in the past 12 months? (1=Yes, 0=No, asked to children)"
			

			label variable health_5_2 "Fell ill in the last 12 months (skip 5.4 if no)"
			label variable health_5_3_1 "Suffered from Malaria"
			label variable health_5_3_2 "Suffered from Bilharzia"
			label variable health_5_3_3 "Suffered from Diarrhea"
			label variable health_5_3_6 "Suffered from Skin issues"
			label variable health_5_3_9 "Suffered from Stomach ache"
			label variable health_5_5 "Received medication for schistosomiasis treatment in last 12 months"
			label variable health_5_8 "Had blood in urine in the last 12 months"
			label variable health_5_9 "Had blood in stool in the last 12 months"


	
			label variable living_01_bin "Indicator for selected tap water as main source of drinking water"
			label variable beliefs_01_bin "Probability of contracting bilharzia in the next 12 months (1=Strongly agree/Agree)"
			label variable beliefs_02_bin "Probability of household member contracting bilharzia in the next 12 months (1=Strongly agree/Agree)"
			label variable beliefs_03_bin "Probability of a child contracting bilharzia in the next 12 months (1=Strongly agree/Agree)"
			label variable hh_12_6_ "Harvest aquatic vegetation"
			
			label variable schisto_indicator "Indicator for presence of schistosomiasis infection"
			label variable sh_inf "Indicator for Schistosoma haematobium infection"
			label variable sm_inf "Indicator for Schistosoma mansoni infection"
			label variable sh_egg_count "Egg count for Schistosoma haematobium"
			label variable sm_egg_count "Egg count for Schistosoma mansoni"
			label variable total_egg "Total schistosome egg count"

		
			label variable q_23 "Access to running drinking water for drinking (1 = Yes, 0 = No)"
			label variable q_24 "Presence of tap water system if running water is available (1 = Yes, 0 = No)"

		

				save "${data}\02_child_infection_analysis_df.dta", replace		
						
		
		
		
*/
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	


/*


hh_gender_resp hh_gender_ hh_age_resp hh_age_ hh_37_ hh_26_ hh_15_2_ hh_15_29 hh_15_28 hh_15_27 hh_15_26 hh_15_25 hh_15_24 hh_15_23 hh_15_22 hh_15_21 hh_15_20 hh_15_2 hh_12_6_ hh_10_ health_5_9_ health_5_8_ health_5_5_ health_5_3_9_ health_5_3_99_ health_5_3_8_ health_5_3_7_ health_5_3_6_ health_5_3_5_ schisto_indicator q_24 q_23 living_01 health_5_3_4_ health_5_3_3_ health_5_3_2_ health_5_3_1_ health_5_3_14_ health_5_3_13_ health_5_3_12_ health_5_3_11_ health_5_3_10_ health_5_3_ data_source beliefs_03 beliefs_02 beliefs_01


, ///
    keep(master match) ///
    nogenerate

	use "${paras}\01_prepped_inf_matches_df.dta", clear
	
*/
*<><<><><>><><<><><>>	
* BEGIN DATA CLEANING/PROCESSING
*<><<><><>><><<><><>>	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
** filter hh_13 **

/*
forvalues j = 1/8 {
    gen hh_13_0`j' = .
    forvalues i = 1/7 {
        replace hh_13_0`j' = hh_13_`i'_ if hh_12index_`i' == `j'
    }
}
*/

	 
*drop strings 
*drop hh_12_o* hh_12_a* hh_12_ro* hh_12_cal* 
*hh_13_o* hh_13_s* hh_19_o

/*
foreach i of numlist 1/55 {
    drop hh_12_`i'
}
*/


/*
* Reshape long with hhid and id
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
*/

/*

drop hh_13_7_ hh_13_6_ hh_13_5_ hh_13_4_ hh_13_3_ hh_13_2_ hh_13_1_ 
drop hh_12index_7_ hh_12index_6_ hh_12index_5_ hh_12index_4_ hh_12index_3_ hh_12index_2_ hh_12index_1_



*^*^* keep only scored data 

	keep if match_score != .
* Create matching individual_id_crdes
	tostring hhid, replace format("%12.0f")
	tostring id, gen(str_id) format("%02.0f")
	gen str individual_id_crdes = hhid + str_id
	format individual_id_crdes %15s

* Create wealth index variable 
	gen wealthindex=list_actifscount/16

* **Keep only individual_id_crdes and variables of interest to avoid conflicts**
keep individual_id_crdes  hh_ethnicity_ hh_age_ hh_gender_ hh_age_resp ///
		health_5_3_2_ health_5_4_ health_5_5_ health_5_6_ health_5_8_ health_5_9_ health_5_10_ ///
		hh_10_ hh_12_* hh_13_0* hh_18_ hh_19_ hh_22_ hh_26_ hh_29_ hh_30_ hh_31_ hh_32_ hh_33_ hh_37_ ///
		living_01 living_02 living_03 living_04 ///
		wealthindex list_actifscount list_actifs ///
		q_18 q_19 q_23 q_24 q_35_check q_39 q_49 q_46 q_51 ///
		Cerratophyllummassg Bulinus Biomph Humanwatercontact BegeningTimesampling Endsamplingtime Schistoinfection InfectedBulinus InfectedBiomphalaria schisto_indicator 

* Save temp health data
*save "${dataframe}\temp_health_reshaped.dta", replace

* KRM - new df w/ the other features 
save "${output}\temp_features_reshaped.dta", replace

* Load main dataset 
use "${output}\child_infection_dataframe.dta", clear

* Merge health variables where individual_id_crdes matches
merge m:1 individual_id_crdes using "${output}\temp_features_reshaped.dta", ///
    keep(master match) ///
    nogenerate

sort village_id individual_id_crdes

***  covert variables from string to numeric *** 
		* written by MJD *
		destring fu_p1 fu_p2 p1_kato1_k1_epg p1_kato2_k2_epg p2_kato1_k1_epg p2_kato2_k2_epg, replace force 

		*** count infection of s. haematobium *** 
		gen sh_inf = 0 
		replace sh_inf = 1 if fu_p1 > 0 & fu_p1 != .
		replace sh_inf = 1 if fu_p2 > 0 & fu_p2 != . 

		gen sm_inf = 0 
		replace sm_inf = 1 if p1_kato1_k1_epg > 0 & p1_kato1_k1_epg != . 
		replace sm_inf = 1 if p1_kato2_k2_epg > 0 & p1_kato2_k2_epg != . 
		replace sm_inf = 1 if p2_kato1_k1_epg > 0 & p2_kato1_k1_epg != . 
		replace sm_inf = 1 if p2_kato2_k2_epg > 0 & p2_kato2_k2_epg != . 

		*** summarize infection results by village *** 
		bysort village_id: sum sh_inf sm_inf
		  
		*** summarize infection results overall ***
		sum sh_inf sm_inf  
*********************************************************

drop Notes sex_crdes 


order   village_id village_name individual_id_crdes hhid_crdes epls_ucad_id match_score age_crdes epls_or_ucad data_source ///
		sex_hp age_hp hh_age_resp  hh_age_ hh_gender_ hh_ethnicity_  ///
		health_5_3_2_ health_5_4_ health_5_5_ health_5_6_ health_5_8_ health_5_9_ health_5_10_  ///
		hh_10_ hh_12_* hh_13_0* hh_18_ hh_19_ hh_22_ hh_26_ hh_29_ hh_30_ hh_31_ hh_32_ hh_33_ hh_37_  ///
		living_01 living_02 living_03 living_04 ///
		list_actifs list_actifscount wealthindex  ///
		q_18 q_19 q_23 q_24 q_35_check q_39 q_49 q_46 q_51 ///
		schisto_indicator fu_p1 fu_p2 omega_vivant_1 sm_fu_1 fu_p2 omega_vivant_2 sm_fu_2 p1_kato1_omega p1_kato1_k1_epg pq_kato2_omega p1_kato2_k2_epg sh_kk_1 p2_kato1_omega p2_kato1_k1_epg p2_kato2_omega p2_kato2_k2_epg sh_kk_2 sh_inf sm_inf pzq_1 		pzq_2 ///
	    Cerratophyllummassg Bulinus Biomph Humanwatercontact BegeningTimesampling Endsamplingtime Schistoinfection InfectedBulinus InfectedBiomphalaria


* Save the final dataset

save "${output}\base_child_infection_dataframe.dta", replace


*/



















/*

	* Creating binary variables for hh_29
	foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 99 {
		gen hh_29_`x' = hh_29_ == `x'
		replace hh_29_`x' = 0 if missing(hh_29_)
	}

	* Creating binary variables for living_01
	foreach x in 1 2 3 4 5 6 7 8 9 10 99 {
		gen living_01_`x' = living_01 == `x'
		replace living_01_`x' = 0 if missing(living_01)
	}

	* Creating binary variables for living_03

	foreach x in 1 2 3 99 {
		gen living_03_`x' = living_03 == `x'
		replace living_03_`x' = 0 if missing(living_03)
	}

	* Creating binary variables for living_04
	foreach x in 1 2 3 4 5 6 7 99 {
		gen living_04_`x' = living_04 == `x'
		replace living_04_`x' = 0 if missing(living_04)
	}


** replace 2s for hh_03 health_5_2 health_5_5 health_5_6 health_5_7 as missings 

	foreach var in health_5_5_ health_5_6_ health_5_8_ health_5_9_ health_5_10_ {
		replace `var' = .a if `var' == 2
	}

*/


*<><<><><>><><<><><>>	
* Scale water contact variable 
*<><<><><>><><<><><>>	
/*

	* Create new variables to preserve original data
	gen BegeningTimesampling_clean = BegeningTimesampling
	gen Endsamplingtime_clean = Endsamplingtime

	* Replace "missed" with "0h00" to represent zero time
	/*
	replace BegeningTimesampling_clean = "0h00" if BegeningTimesampling_clean == "missed"
	replace Endsamplingtime_clean = "0h00" if Endsamplingtime_clean == "missed"
	*/

	* Remove the apostrophe at the end of the time strings
	replace BegeningTimesampling_clean = subinstr(BegeningTimesampling_clean, "'", "", .)
	replace Endsamplingtime_clean = subinstr(Endsamplingtime_clean, "'", "", .)

	* Remove any ":" that appears right after "h" for both variables
	replace BegeningTimesampling_clean = regexr(BegeningTimesampling_clean, "h:", "h")
	replace Endsamplingtime_clean = regexr(Endsamplingtime_clean, "h:", "h")

	* Replace "h" with ":" only if "h" exists and ":" is not already present
	replace BegeningTimesampling_clean = subinstr(BegeningTimesampling_clean, "h", ":", .) if strpos(BegeningTimesampling_clean, "h") > 0 & strpos(BegeningTimesampling_clean, ":") == 0
	replace Endsamplingtime_clean = subinstr(Endsamplingtime_clean, "h", ":", .) if strpos(Endsamplingtime_clean, "h") > 0 & strpos(Endsamplingtime_clean, ":") == 0


	replace BegeningTimesampling_clean = trim(BegeningTimesampling_clean)
	replace Endsamplingtime_clean = trim(Endsamplingtime_clean)

	gen double BegeningTimesampling_time = clock(BegeningTimesampling_clean, "hm")
	format BegeningTimesampling_time %tc

	gen double Endsamplingtime_time = clock(Endsamplingtime_clean, "hm")
	format Endsamplingtime_time %tc

	* Convert datetime to total minutes since midnight
	gen BegeningTimesampling_minutes = hh(BegeningTimesampling_time) * 60 + mm(BegeningTimesampling_time)
	gen Endsamplingtime_minutes = hh(Endsamplingtime_time) * 60 + mm(Endsamplingtime_time)

	* Compute total time difference in minutes
	gen total_time = abs(Endsamplingtime_minutes - BegeningTimesampling_minutes)
		
	* Create the scaled variable
	destring Humanwatercontact, replace 
	gen scaled = Humanwatercontact / total_time

	* Replace missing values in total_time with 0
	replace total_time = 0 if missing(total_time)

	* Replace missing values in scaled with 0
	replace scaled = 0 if missing(scaled)

	replace total_time = abs(Endsamplingtime_minutes - BegeningTimesampling_minutes) if !missing(Endsamplingtime_minutes)


	replace total_time = . if missing(Endsamplingtime_minutes)

	drop BegeningTimesampling_time Endsamplingtime_time

*/

*<><<><><>><><<><><>>	



*save "${data}\child_infection_dataframe_analysis.dta", replace

































