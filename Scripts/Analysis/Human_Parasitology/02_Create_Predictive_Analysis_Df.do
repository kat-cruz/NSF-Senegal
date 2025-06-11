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

*----------------------------------------*
**# INITIATE SCRIPT
*----------------------------------------*		
	clear all
	set mem 100m
		set maxvar 30000
		set matsize 11000
	set more off

*----------------------------------------*
**# SET FILE PATHS
*----------------------------------------*

*<><<><><>><><<><><>>

*^*^* Set base Box path for each user
	if "`c(username)'"=="socrm" global master "C:\Users\socrm\Box\NSF Senegal\Data_Management"
	if "`c(username)'"=="kls329" global master "C:\Users\kls329\Box\NSF Senegal\Data_Management"
	if "`c(username)'"=="km978" global master "C:\Users\km978\Box\NSF Senegal\Data_Management"
	if "`c(username)'"=="Kateri" global master "C:\Users\Kateri\Box\NSF Senegal\Data_Management"
	if "`c(username)'"=="admmi" global master "C:\Users\admmi\Box\NSF Senegal\Data_Management"


*^*^* Define project-specific paths

	global crdes_base "${master}\Data\_CRDES_CleanData\Baseline\Deidentified"
	global crdes_base_long "${master}\Output\Data_Processing\Construction"
	global crdes_mid "${master}\Data\_CRDES_CleanData\Midline\Deidentified"
	global crdes_mid_long "${master}\Output\Data_Processing\Construction"
	global eco_data "${master}\Data\_Partner_CleanData\Ecological_Data"
	global asset "${master}\Output\Data_Processing\Construction"
	global paras"${master}\Output\Analysis\Human_Parasitology\Analysis_Data"
	global tidy "${master}\Output\Analysis\Human_Parasitology\Analysis_Data\Tidy_data"
	

*<><<><><>><><<><><>>
**# BEGIN BASELINE WORK
*<><<><><>><><<><><>>


*----------------------------------------------------------------------------------*
**### R0 - Household Roster Module 
*----------------------------------------------------------------------------------*

*-------------------*
**#####Load in data 
*-------------------*

	use "${crdes_base_long}\baseline_household_long.dta", clear // health data 
	
		drop if missing(hh_age_) & missing(hh_gender_) & missing(hh_ethnicity_)

*-------------------*
**#####Keep pre-selected variables
*-------------------*

		keep hhid individ hh_age_ hh_gender_ hh_main_activity_  ///
		hh_10_ hh_12_6_ hh_26_ hh_32_ hh_37_ 
	
	** removed hh_15_
		
*-------------------*
**##### recode gender
*-------------------*	
		*^*^*  Recode hh_gender_ (change 2 to 0, leave others unchanged)
		recode hh_gender_ (2=0)
		
		
*-------------------*
**##### Check for missings
*-------------------*		

		foreach var of varlist _all {
			quietly count if missing(`var')
			display "`var': " r(N)
		}
		

*-------------------*
**##### Replace logic missings
*-------------------*				
		
	** hh_12_ 
	** Skip pattern: ${hh_10} > 0
		
		replace hh_12_6_ = 0 if hh_10_ == 0

	** hh_10
	** Skip pattern: ${hh_10} > 0 and selected(${hh_12}, "6")	
		
/* 
		replace hh_15_ = 0 if hh_10_ == 0 
		replace hh_15_ = 0 if hh_12_6_ == 0	
*/
				
	** hh_37_
	** ${hh_32} = 1 and then ${hh_26} = 1 (hh_32 is conditional on hh_26)
		
		replace hh_32_ = 0 if hh_26_ == 0	// child module - hh_26 begins the module, so the missings come from adults 
		replace hh_37_ = 0 if hh_32_ == 0		
	
	** replace if kids didn't answer these questions KRM - look into this
		foreach var in hh_32_ hh_37_ {
				replace `var' = 0 if missing(`var') & (hh_age_ >= 4 & hh_age_ <= 18)
			}
		
				
*-------------------*
**##### Replace "I don't knows" with missings
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
**#####Begin variable creation
*-------------------*				


					
*-------------*
**##### fishing
*-------------*	

	 gen fishing = .
	 replace fishing = 1 if hh_main_activity_ == 3
	 replace fishing = 0 if hh_main_activity_ != 3
		drop hh_main_activity_
	 
*-------------------*
**#####Save data set 
*-------------------*	


		save "$tidy\base_household_roster", replace 
		

*----------------------------------------------------------------------------------*
**### R0 - HEALTH MODULE 
*----------------------------------------------------------------------------------*

*-------------------*
**#####Load in data 
*-------------------*

	use "${crdes_base_long}\baseline_health_long.dta", clear // health data 
	
		drop if missing(health_5_2_) & missing(healthgenre_) & missing(healthindex_)

*-------------------*
**#####Keep pre-selected variables
*-------------------*

		keep hhid individ health_5_2_ health_5_3_1_ health_5_3_2_ health_5_3_3_ health_5_3_6_ health_5_3_9_ ///
		health_5_5_ health_5_8_ health_5_9_ ///
		healthindex_ healthgenre_ // filter variables - will drop at the end
		


*-------------------*
**#####Check for missings
*-------------------*		

		foreach var of varlist _all {
			quietly count if missing(`var')
			display "`var': " r(N)
		}
	
		
*-------------------*
**##### Replace logic missings
*-------------------*				
		
	** health_5_3_ 
	** Skip pattern: ${health_5_2} = 1

			foreach var in health_5_2_ health_5_3_1_ health_5_3_2_ health_5_3_3_ health_5_3_6_ health_5_3_9_ {
				replace `var' = 0 if health_5_2_ == 0
			}	
				
*-------------------*
**##### Replace "I don't knows" with missings
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
**#####Save data set 
*-------------------*				

			
		save "$tidy\base_health.dta", replace 
		
*----------------------------------------------------------------------------------*
**### R0 - STANDARD OF LIVING MODULE 
*----------------------------------------------------------------------------------*

*-------------------*
**#####Load in data 
*-------------------*

	use "${crdes_base}\Complete_Baseline_Standard_Of_Living.dta", clear // health data 
	
	*-------------------*
**#####Keep pre-selected variables
*-------------------*

		keep hhid living_01 living_04

*-------------------*
**#####Check for missings
*-------------------*		

		foreach var of varlist _all {
			quietly count if missing(`var')
			display "`var': " r(N)
		}
		
*-------------------*
**#####Begin variable creation
*-------------------*				

*-------------*
**##### living_01_bin
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
**##### living_04_bin
*-------------*	
			
		** Main type of toilet 
		**1 Flush with sewer
		**2 Toilet flush with 

		gen living_04_bin = 0
			replace living_04_bin = 1 if living_04 == 1 | living_04 == 2 
			
	drop living_01 living_04
			
*-------------*
**##### hhid_village
*-------------*			
			
			gen hhid_village = substr(hhid, 1, 4)

			
*-------------------*
**#####Save data set 
*-------------------*		

/* 
	merge m:m hhid using "${output}\child_matched_IDs_df", nogen 
		keep if !missing(match_score)
		
	** drop individual level variables 
		drop individ match_score identificant
*/
		
				save "$tidy\base_standard_of_living.dta", replace 
				
*----------------------------------------------------------------------------------*
**### R0 - BELIEFS MODULE
*----------------------------------------------------------------------------------*

*-------------------*
**#####Load in data 
*-------------------*

	use "${crdes_base}\Complete_Baseline_Beliefs.dta", clear // beliefs data 
	
*-------------------*
**#####Keep pre-selected variables
*-------------------*

		keep hhid beliefs_01 beliefs_02 beliefs_03

*-------------------*
**#####Check for missings
*-------------------*		

		foreach var of varlist _all {
			quietly count if missing(`var')
			display "`var': " r(N)
		}
		
*-------------------*
**#####Begin variable creation
*-------------------*				
	
		
** create a Binary Indicator
		*If most responses are ≤2 (Agree/Strongly Agree) → use beliefs_var <= 2 as the binary indicator.
		*If responses are more evenly spread, consider using ≤3 (including Neutral).
		*If disagreement dominates, use beliefs_var >= 4 instead.

*-------------*
**##### beliefs_01_bin
*-------------*		
		
		gen beliefs_01_bin = (beliefs_01 <= 2)  // 55.92% responded 1 or 2
*-------------*
**##### beliefs_02_bin
*-------------*		
		gen beliefs_02_bin = (beliefs_02 <= 2)  // 64.45% responded 1 or 2
*-------------*
**##### beliefs_03_bin
*-------------*	
		gen beliefs_03_bin = (beliefs_03 <= 2)  // 80.09% responded 1 or 2
		
*-------------*
**##### hhid_village
*-------------*			
			
		gen hhid_village = substr(hhid, 1, 4)

*-------------------*
**#####Save data set 
*-------------------*		


drop beliefs_01 beliefs_02 beliefs_03
		
			save "$tidy\base_beliefs.dta", replace 	
			
*----------------------------------------------------------------------------------*
**### R0 - COMMUNITY DATA 
*----------------------------------------------------------------------------------*

*-------------------*
**#####Load in data 
*-------------------*

	use "${crdes_base}\Complete_Baseline_Community.dta", clear // community data
	
*-------------------*
**#####Keep pre-selected variables
*-------------------*

	 keep hhid_village q_51
		
*-------------------*
**#####Check for missings
*-------------------*		

		foreach var of varlist _all {
			quietly count if missing(`var')
			display "`var': " r(N)
		}
		
		** no missings
					
*-------------------*
**#####Save data set 
*-------------------*		
	
	save "$tidy\base_community.dta", replace 
*----------------------------------------------------------------------------------*
**### R0 - ASSET INDEX
*----------------------------------------------------------------------------------*

*-------------------*
**#####Load in data 
*-------------------*

	use "${asset}\pooled_asset_index_var", clear // asset data
	
*-------------------*
**#####Keep pre-selected variables
*-------------------*

	 keep hhid asset_index0 asset_index_std0
		
*-------------------*
**#####Check for missings
*-------------------*		

		foreach var of varlist _all {
			quietly count if missing(`var')
			display "`var': " r(N)
		}
		
		** missings come from replaced/merged households 
	
		drop if missing(asset_index0)  & missing(asset_index_std0)
		
		rename asset_index0 asset_index
		rename asset_index_std0 asset_index_std
		
		** 31 dropped
					
*-------------------*
**#####Save data set 
*-------------------*		
	
	save "$tidy\base_asset", replace 
		
*----------------------------------------------------------------------------------*
**### R0 - ECOLOGICAL DATA 
*----------------------------------------------------------------------------------*

*-------------------*
**#####Load in data 
*-------------------*

	use "${eco_data}\DISES_baseline_ecological data.dta", clear // eco data 
	
*-------------------*
**#####Keep pre-selected variables
*-------------------*

	 keep hhid_village Cerratophyllummassg Bulinus Biomph Humanwatercontact  InfectedBulinus  InfectedBiomphalaria schisto_indicator 
		
*-------------------*
**#####Check for missings
*-------------------*		

		foreach var of varlist _all {
			quietly count if missing(`var')
			display "`var': " r(N)
		}
		
		** 3 villages missing humanwatercoontact
		
*-------------------*
**#####Tidy up 
*-------------------*	

		destring Cerratophyllummassg, replace
		destring Biomph, replace 
		
		replace Humanwatercontact = "50" if Humanwatercontact == "+50"
			destring Humanwatercontact, replace 

					
*-------------------*
**#####Save data set 
*-------------------*		
	
	
				save "$tidy\base_eco.dta", replace 

*----------------------------------------------------------------------------------*
**### R0 - PARASITOLOGICAL DATA
*----------------------------------------------------------------------------------*

*-------------------*
**#####Load in data 
*-------------------*

	use "${paras}\01_baseline_paras_df.dta", clear // paras data 
	

*-------------------*
**#####Keep pre-selected variables
*-------------------*

		keep hhid_village village_name identificant fu_p1 fu_p2 p1_kato1_k1_epg p1_kato2_k2_epg p2_kato1_k1_epg p2_kato2_k2_epg age_hp sex_hp


*-------------------*
**#####Check for missings
*-------------------*		

		foreach var of varlist _all {
			  quietly ds `var', has(type string)
			if "`r(varlist)'" != "" {
				quietly count if missing(`var')
				display "`var': " r(N)
			}
		}

			
	** None 
	
*-------------------*
**#####Clean up age
*-------------------*	

	replace age_hp = subinstr(age_hp, " ans", "", .)
	replace age_hp = subinstr(age_hp, "ans", "", .)
	replace age_hp = subinstr(age_hp, " ", "", .)


	replace sex_hp = "1" if sex_hp == "M"
	replace sex_hp = "0" if sex_hp == "F"	
	
*-------------------*
**#####Begin variable creation
*-------------------*				

***  covert variables from string to numeric *** 
		* written by MJD *
		destring fu_p1 fu_p2 p1_kato1_k1_epg p1_kato2_k2_epg p2_kato1_k1_epg p2_kato2_k2_epg age_hp sex_hp, replace force 

*-------------*
**##### sh_inf
*-------------*				
		
		*** count infection of s. haematobium *** 
		gen sh_inf = 0 
		replace sh_inf = 1 if fu_p1 > 0 & fu_p1 != .
		replace sh_inf = 1 if fu_p2 > 0 & fu_p2 != . 

*-------------*
**##### sm_inf
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
**##### sm_sh_inf
*-------------*	
		
		gen sm_sh_inf = (sm_inf == 1 | sh_inf == 1)
		
		
*-------------*
**##### sh_egg_count
*-------------*	
	
*** Calculate egg counts
	
		gen sh_egg_count = cond(fu_p1 > 0, fu_p1, fu_p2)
	
*-------------*
**##### p1_avg
*-------------*	

		gen p1_avg = (p1_kato1_k1_epg + p1_kato2_k2_epg) / 2
	
*-------------*
**##### p2_avg
*-------------*	

		gen p2_avg = (p2_kato1_k1_epg + p2_kato2_k2_epg) / 2
		
*-------------*
**##### sm_egg_count
*-------------*	

		gen sm_egg_count = cond(p1_avg > 0, p1_avg, p2_avg)
	
*-------------*
**##### total_egg
*-------------*	

* Create total egg count

		gen total_egg = sm_egg_count + sh_egg_count
		
*-------------------*
**#####Keep pre-selected variables
*-------------------*
			
		
	keep hhid_village village_name identificant sh_inf sm_inf sm_sh_inf sh_egg_count p1_avg p2_avg sm_egg_count total_egg age_hp sex_hp	
		
*-------------------*
**#####Save data set 
*-------------------*		
	
	
				save "$tidy\base_paras.dta", replace 
		

*----------------------------------------------------------------------------------*
**### Prepare to export main df
*----------------------------------------------------------------------------------*		
			
*-------------------*
**#####Merge data frames
*-------------------*


**	bring in CRDES survey individual level FIRST and merge 

		use "$tidy\base_household_roster", clear
			
					*drop if missing(hh_full_name_calc_) | missing(hh_gender_) | missing(hh_age_)
					drop if hh_gender_ == . & hh_age_ == . 

							tempfile hh_roster
								save `hh_roster'
								
		use "$tidy\base_health", clear		
					*drop if missing(health_5_2_) & missing(healthgenre_) & missing(healthindex_)
						drop if missing(health_5_2_) | missing(healthgenre_) | missing(healthindex_)
						
							drop healthindex_ healthgenre_

					merge 1:1 individ using `hh_roster', nogen
							 save "$tidy\base_indiv_level_data.dta", replace 
								
** now bring in CRDES survey household level data SECOND and merge

		use "$tidy\base_standard_of_living", clear
			
					merge 1:1 hhid using "$tidy\base_beliefs", nogen // household level data 		
					merge 1:1 hhid using "$tidy\base_asset.dta", nogen
											
							save "$tidy\base_hh_level_data.dta", replace 
							
** now merge the CRDES survey data together

		use "$tidy\base_indiv_level_data.dta", clear
			
					merge m:1 hhid using "$tidy\base_hh_level_data.dta", nogen
					merge m:1 hhid_village using "$tidy\base_community.dta", nogen
							save "$tidy\baseline_crdes_base_data", replace 
							
** now bring in child matched IDs the link in the parasitological data and survey data

		use "$paras\child_matched_IDs_df.dta", clear	
			keep if round == 0
				drop round
			
					merge 1:1 identificant using "$tidy\base_paras.dta" // merge in paras data
						keep if _merge == 3
							drop _merge
					
					merge 1:1 individ using "$tidy\baseline_crdes_base_data" // merge in CRDES data
						keep if _merge == 3
							drop _merge
					
					merge m:1 hhid_village using "$tidy\base_eco" // merge in eco data
						keep if _merge == 3
							drop _merge
		
*-------------------*
**#####Look at outliers 
*-------------------*		

		preserve 
		
			keep if hh_age_ < 4 | hh_age_ > 18
				keep hhid_village village_name hhid individ match_score identificant hh_age_ hh_gender_
				
		restore 
							
				
			
*-------------------*
**#####Order variables
*-------------------*		
		gen round = 1

		order hhid_village village_name hhid individ identificant match_score  ///
		hh_age_ hh_gender_ fishing  ///
		hh_10_ hh_12_6_ hh_26_ hh_32_ hh_37_  ///
		health_5_2_ health_5_3_1_ health_5_3_2_ health_5_3_3_ health_5_3_6_ health_5_3_9_ health_5_5_ health_5_8_ health_5_9_ ///
		living_01_bin living_04_bin ///
		beliefs_01_bin beliefs_02_bin beliefs_03_bin ///
		asset_index asset_index_std ///
		q_51 ///
		sh_inf sm_inf sm_sh_inf sh_egg_count p1_avg p2_avg sm_egg_count total_egg schisto_indicator age_hp sex_hp ///
		Cerratophyllummassg Bulinus Biomph Humanwatercontact InfectedBulinus InfectedBiomphalaria schisto_indicator round

*-------------------*
**#####Label variables
*-------------------*			
	
	
		label variable hhid_village "Village ID"
		label variable village_name "Village name"
		
		label variable hh_age_ "Individual's age"
		label variable hh_gender_ "Individual's gender"
		label variable fishing  "Indicator if individual selected fishing as maing household activity"
		
		label variable hh_10_ "Hours per week spent within 1 meter of surface water source"
		label variable hh_12_6_ "Harvest aquatic vegetation"
		label variable hh_26_ "Currently enrolled in formal school? (1=Yes, 2=No)"
		label variable hh_32 "Attends school during the 2023/2024 academic year"
		label variable hh_37_ "Missed >1 week of school due to illness, past 12mo (children only)"
	

		label variable health_5_2 "Fell ill in the last 12 months"
		label variable health_5_3_1 "Suffered from Malaria"
		label variable health_5_3_2 "Suffered from Bilharzia"
		label variable health_5_3_3 "Suffered from Diarrhea"
		label variable health_5_3_6 "Suffered from Skin issues"
		label variable health_5_3_9 "Suffered from Stomach ache"
		label variable health_5_5 "Received medication for schistosomiasis treatment in last 12 months"
		label variable health_5_8 "Had blood in urine in the last 12 months"
		label variable health_5_9 "Had blood in stool in the last 12 months"


		label variable living_01_bin "Indicator for selected tap water as main source of drinking water"
		label variable living_04_bin "Indicator for latrine in home"
		
		label variable beliefs_01_bin "Prob. self gets bilharzia in next 12mo (1=Agree/Strongly agree)"
		label variable beliefs_02_bin "Prob. HH member gets bilharzia in next 12mo (1=Agree/Strongly agree)"
		label variable beliefs_03_bin "Prob. child gets bilharzia in next 12mo (1=Agree/Strongly agree)"
		
		label variable asset_index "PCA Asset index"
		label variable asset_index_std "Standardized PCA Asset index"
		
		label variable schisto_indicator "Indicator for presence of schistosomiasis infection"
		label variable sh_inf "Indicator for Schistosoma haematobium infection"
		label variable sm_inf "Indicator for Schistosoma mansoni infection"
		label variable sm_sh_inf "Indicator for Schistosoma manson OR haematobium infection"
		label variable sh_egg_count "Egg count for Schistosoma haematobium"
		label variable sm_egg_count "Egg count for Schistosoma mansoni"
		label variable p1_avg "Average EPG from P1 (Kato-Katz slide 1 and 2)"
		label variable p2_avg "Average EPG from P2 (Kato-Katz slide 1 and 2)"
		label variable total_egg "Total schistosome egg count" 
		label variable sex_hp "EPLS/UCAD child sex"
		label variable age_hp "EPLS/UCAD child age"
		
		label variable q_51 "Distance to health facility"
		label variable round "0 = Baseline, 1 = Midline"
	

		
		
			
*-------------------*
**#####save final data frame
*-------------------*		
	

				save "$paras\02_baseline_analysis_df.dta", replace 
				
	*<><<><><>><><<><><>>
**# MIDLINE WORK
*<><<><><>><><<><><>>

 

*----------------------------------------------------------------------------------*
**### R1 - HOUSEHOLD ROSTER MODULE 
*----------------------------------------------------------------------------------*

*-------------------*
**##### Load in data 
*-------------------*

	use "${crdes_mid}\Complete_Midline_Household_Roster.dta", clear // household roster
	
	
*-------------------*
**#####Keep pre-selected variables
*-------------------*

		keep hhid individ* hh_age* hh_gender* hh_main_activity*  ///
		hh_10* hh_12_6* hh_26* hh_32* hh_37*
		drop hh_main_activity_o*
		
*-------------------*
**#####reshape
*-------------------*
		reshape long individ_ hh_age_ hh_gender_ hh_main_activity_ hh_10_ hh_12_6_ hh_26_ hh_32_ hh_37_, i(hhid) j(id)

	rename individ_ individ
		drop if missing(individ) 
		drop id hh_age_resp hh_gender_resp hh_12_6
		
*-------------------*
**#####dropped merged hhids
*-------------------*		
		
		drop if inlist(hhid, "133A19", "133A03", "133A20", "133A02", "133A05", "133A11")

*-------------------*
**##### recode gender
*-------------------*	

		*^*^*  Recode hh_gender_ (change 2 to 0, leave others unchanged)
		recode hh_gender_ (2=0)
		
*-------------------*
**#####Check for missings
*-------------------*		

		foreach var of varlist _all {
			quietly count if missing(`var')
			display "`var': " r(N)
		}
		
*-------------------*
**##### Replace logic missings
*-------------------*				
		
	** hh_12_ 
	** Skip pattern: ${hh_10} > 0
		
		replace hh_12_6_ = 0 if hh_10_ == 0

	** hh_10
	** Skip pattern: ${hh_10} > 0 and selected(${hh_12}, "6")	
				
	** hh_37_
	** ${hh_32} = 1 and then ${hh_26} = 1 (hh_32 is conditional on hh_26)
		
		replace hh_32_ = 0 if hh_26_ == 0	// child module - hh_26 begins the module, so the missings come from adults 
		replace hh_37_ = 0 if hh_32_ == 0		
	
	** replace if kids didn't answer these questions KRM - look into this
		foreach var in hh_32_ hh_37_ {
				replace `var' = 0 if missing(`var') & (hh_age_ >= 4 & hh_age_ <= 18)
			}
		
				
*-------------------*
**##### Replace "I don't knows" with missings
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
**##### Begin variable creation
*-------------------*	
		
*-------------*
**##### fishing
*-------------*	

	 gen fishing = .
	 replace fishing = 1 if hh_main_activity_ == 3
	 replace fishing = 0 if hh_main_activity_ != 3
		drop hh_main_activity_
		
*-------------------*
**#####Handle duplicates
*-------------------*	
 
/*
**			tag duplicates based on these variables which I'll be merging on 
				duplicates tag hhid individ, generate(uhoh)
			
					tab uhoh
						keep if uhoh != 0

**			drop duplicates, keeping only the first occurrence
				duplicates drop hhid hh_full_name_calc_ hh_gender_ hh_age_, force
				
					drop dup_tag
*/
	 
*-------------------*
**#####Save data set 
*-------------------*	


		save "$tidy\mid_household_roster", replace 
		

*----------------------------------------------------------------------------------*
**### R1 - HEALTH MODULE
*----------------------------------------------------------------------------------*

*-------------------*
**#####Load in data 
*-------------------*

	use  "${crdes_mid_long}\midline_health_long.dta", clear // health data
	
		drop if missing(health_5_2_) & missing(healthgenre_) & missing(healthindex_)

*-------------------*
**#####Keep pre-selected variables
*-------------------*

		keep hhid individ health_5_2_ health_5_3_1_ health_5_3_2_ health_5_3_3_ health_5_3_6_ health_5_3_9_ ///
		health_5_5_ health_5_8_ health_5_9_ 
	
		
	
*-------------------*
**#####Check for missings
*-------------------*		

		foreach var of varlist _all {
			quietly count if missing(`var')
			display "`var': " r(N)
		}
	
		
*-------------------*
**##### Replace logic missings
*-------------------*				
		
	** health_5_3_ 
	** Skip pattern: ${health_5_2} = 1

			foreach var in health_5_2_ health_5_3_1_ health_5_3_2_ health_5_3_3_ health_5_3_6_ health_5_3_9_ {
				replace `var' = 0 if health_5_2_ == 0
			}	
				
*-------------------*
**##### Replace "I don't knows" with missings
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
**#####Save data set 
*-------------------*				
			
		save "$tidy\mid_health_module.dta", replace 
		
*----------------------------------------------------------------------------------*
**### R1 - STANDARD OF LIVING MODULE 
*----------------------------------------------------------------------------------*

*-------------------*
**#####Load in data 
*-------------------*

	use "${crdes_mid}\Complete_Midline_Standard_Of_Living.dta", clear // standard of living 
	
	*-------------------*
**#####Keep pre-selected variables
*-------------------*

		keep hhid living_01 living_04

*-------------------*
**#####Check for missings
*-------------------*		

		foreach var of varlist _all {
			quietly count if missing(`var')
			display "`var': " r(N)
		}
		
*-------------------*
**#####Begin variable creation
*-------------------*				

*-------------*
**##### living_01_bin
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
				
		** Main type of toilet 
		**1 Flush with sewer
		**2 Toilet flush with 

		gen living_04_bin = 0
			replace living_04_bin = 1 if living_04 == 1 | living_04 == 2 
			
	drop living_01 living_04
			
*-------------*
**##### hhid_village
*-------------*			
			
			gen hhid_village = substr(hhid, 1, 4)
					order hhid_village
				
*-------------------*
**#####Save data set 
*-------------------*		

	
	save "$tidy\mid_standard_of_living_module.dta", replace 
				

*----------------------------------------------------------------------------------*
**### R1 - BELIEFS MODULE
*----------------------------------------------------------------------------------*

*-------------------*
**#####Load in data 
*-------------------*

	use "${crdes_mid}\Complete_Midline_Beliefs.dta", clear // beliefs data 
	
*-------------------*
**#####Keep pre-selected variables
*-------------------*

		keep hhid beliefs_01 beliefs_02 beliefs_03

*-------------------*
**#####Check for missings
*-------------------*		

		foreach var of varlist _all {
			quietly count if missing(`var')
			display "`var': " r(N)
		}
		
*-------------------*
**#####Begin variable creation
*-------------------*				
	
		
** create a Binary Indicator
		*If most responses are ≤2 (Agree/Strongly Agree) → use beliefs_var <= 2 as the binary indicator.
		*If responses are more evenly spread, consider using ≤3 (including Neutral).
		*If disagreement dominates, use beliefs_var >= 4 instead.

*-------------*
**##### beliefs_01_bin
*-------------*		
		
		gen beliefs_01_bin = (beliefs_01 <= 2)  // 55.92% responded 1 or 2
*-------------*
**##### beliefs_02_bin
*-------------*		
		gen beliefs_02_bin = (beliefs_02 <= 2)  // 64.45% responded 1 or 2
*-------------*
**##### beliefs_03_bin
*-------------*	
		gen beliefs_03_bin = (beliefs_03 <= 2)  // 80.09% responded 1 or 2
		
*-------------*
**##### hhid_village
*-------------*			
			
		gen hhid_village = substr(hhid, 1, 4)

*-------------------*
**#####Save data set 
*-------------------*		

	drop beliefs_01 beliefs_02 beliefs_03
		
			save "$tidy\mid_beliefs_module.dta", replace
				
*----------------------------------------------------------------------------------*
**### R1 - COMMUNITY DATA 
*----------------------------------------------------------------------------------*

*-------------------*
**#####Load in data 
*-------------------*

	use "${crdes_mid}\Complete_Midline_Community.dta", clear // community data
	
*-------------------*
**#####Keep pre-selected variables
*-------------------*

	 keep hhid_village q_51
		
*-------------------*
**#####Check for missings
*-------------------*		

		foreach var of varlist _all {
			quietly count if missing(`var')
			display "`var': " r(N)
		}
		
		** no missings
					
*-------------------*
**#####Save data set 
*-------------------*		
	
	save "$tidy\mid_community.dta", replace 

*----------------------------------------------------------------------------------*
**### R1 - ASSET INDEX
*----------------------------------------------------------------------------------*

*-------------------*
**#####Load in data 
*-------------------*

	use "${asset}\pooled_asset_index_var", clear // asset data
	
*-------------------*
**#####Keep pre-selected variables
*-------------------*

	 keep hhid asset_index1 asset_index_std1
		
*-------------------*
**#####Check for missings
*-------------------*		

		foreach var of varlist _all {
			quietly count if missing(`var')
			display "`var': " r(N)
		}
		
		** missings come from replaced/merged households 
		
		drop if missing(asset_index1)  & missing(asset_index_std1) 
		
		** 31 dropped
		rename asset_index1 asset_index
		rename asset_index_std1 asset_index_std
					
*-------------------*
**#####Save data set 
*-------------------*		
	
	save "$tidy\mid_asset", replace 

	
*----------------------------------------------------------------------------------*
**### R1 - ECOLOGICAL DATA 
*----------------------------------------------------------------------------------*

*-------------------*
**#####Load in data 
*-------------------*

	use "${eco_data}\DISES_midline_ecological data.dta", clear // eco data 

*-------------------*
**#####Keep pre-selected variables
*-------------------*


	rename  Cerratophyllummass Cerratophyllummassg
	rename 	TotalBulinus Bulinus
	rename 	Biomphalaria Biomph


		keep hhid_village Cerratophyllummassg Bulinus Biomph Schistoinfection InfectedBulinus  InfectedBiomphalaria schisto_indicator HWC05 HWC618 HWC18
		
*-------------------*
**#####Check for missings
*-------------------*		

		foreach var of varlist _all {
			quietly count if missing(`var')
			display "`var': " r(N)
		}
		
		** 4 villages missing schisto_indicator due to dried up water point
		
*-------------------*
**#####Tidy things up 
*-------------------*	

	foreach var in Cerratophyllummassg Bulinus Biomph Schistoinfection HWC05 HWC618 HWC18 {
			replace `var' = ".a" if `var' == "dried up"
			replace `var' = ".a" if `var' == "NA"
						
			}
		
		destring Cerratophyllummassg Bulinus Biomph Schistoinfection HWC05 HWC618 HWC18, replace 
		
		replace schisto_indicator = .a if schisto_indicator == .

*-------------------*
**#####Create Humanwatercontact
*-------------------*			
		
	egen Humanwatercontact = rowtotal(HWC05 HWC618 HWC18)


*-------------------*
**#####Collapse at village level
*-------------------*			
** 	Only ONE waterpoint was sampled at baseline, which is why we didn't need to collapse. 

**	Collapse to one observation per village:

		collapse ///
			(mean) Cerratophyllummassg Bulinus Biomph InfectedBulinus InfectedBiomphalaria Humanwatercontact ///
			(max) schisto_indicator ///
			, by(hhid_village)
					
*-------------------*
**#####Save data set 
*-------------------*		
	
				save "$tidy\mid_eco_data.dta", replace 

*----------------------------------------------------------------------------------*
**### R1 - PARASITOLOGICAL DATA
*----------------------------------------------------------------------------------*

*-------------------*
**#####Load in data 
*-------------------*

	use "${paras}\01_midline_paras_df.dta", clear // paras data 
	

*-------------------*
**#####Keep pre-selected variables
*-------------------*

		keep hhid_village village_name identificant fu_p1 fu_p2 p1_kato1_k1_epg p1_kato2_k2_epg p2_kato1_k1_epg p2_kato2_k2_epg age_hp sex_hp



*-------------------*
**#####Check for missings
*-------------------*		

		foreach var of varlist _all {
			  quietly ds `var', has(type string)
			if "`r(varlist)'" != "" {
				quietly count if missing(`var')
				display "`var': " r(N)
			}
		}

			
	** None 
	
*-------------------*
**#####Clean up age
*-------------------*	

	replace age_hp = subinstr(age_hp, " ans", "", .)
	replace age_hp = subinstr(age_hp, "ans", "", .)
	replace age_hp = subinstr(age_hp, " ", "", .)


	replace sex_hp = "1" if sex_hp == "M"
	replace sex_hp = "0" if sex_hp == "F"	
	
	
**		fu_p1: 75
**		fu_p2: 91
**		p1_kato1_k1_epg: 104
**		p1_kato2_k2_epg: 104
**		p2_kato1_k1_epg: 120
**		p2_kato2_k2_epg: 120



*-------------------*
**#####Begin variable creation
*-------------------*				

***  covert variables from string to numeric *** 
		* written by MJD *
		destring fu_p1 fu_p2 p1_kato1_k1_epg p1_kato2_k2_epg p2_kato1_k1_epg p2_kato2_k2_epg age_hp sex_hp, replace force 

*-------------*
**##### sh_inf
*-------------*				
		
		*** count infection of s. haematobium *** 
		gen sh_inf = 0 
		replace sh_inf = 1 if fu_p1 > 0 & fu_p1 != .
		replace sh_inf = 1 if fu_p2 > 0 & fu_p2 != . 

*-------------*
**##### sm_inf
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
**##### sm_sh_inf
*-------------*	
		
		gen sm_sh_inf = (sm_inf == 1 | sh_inf == 1)
		
*-------------*
**##### sh_egg_count
*-------------*	
	
*** Calculate egg counts
	
		gen sh_egg_count = cond(fu_p1 > 0, fu_p1, fu_p2)
	
*-------------*
**##### p1_avg
*-------------*	

		gen p1_avg = (p1_kato1_k1_epg + p1_kato2_k2_epg) / 2
	
*-------------*
**##### p2_avg
*-------------*	

		gen p2_avg = (p2_kato1_k1_epg + p2_kato2_k2_epg) / 2
		
*-------------*
**##### sm_egg_count
*-------------*	

		gen sm_egg_count = cond(p1_avg > 0, p1_avg, p2_avg)
	
*-------------*
**##### total_egg
*-------------*	

* Create total egg count

		gen total_egg = sm_egg_count + sh_egg_count
		
*-------------------*
**#####Keep pre-selected variables
*-------------------*
			
		
	keep hhid_village village_name identificant sh_inf sm_inf sm_sh_inf sh_egg_count p1_avg p2_avg sm_egg_count total_egg age_hp sex_hp	
		
*-------------------*
**#####Save data set 
*-------------------*		

				save "$tidy\mid_paras_data.dta", replace 
				

*----------------------------------------------------------------------------------*
**### Prepare to export main df
*----------------------------------------------------------------------------------*		
			
*-------------------*
**#####Merge data frames
*-------------------*


**	bring in CRDES survey individual level FIRST and merge 

		use "$tidy\mid_household_roster", clear
			
							tempfile hh_roster
								save `hh_roster'
								
		use "$tidy\mid_health_module", clear		
										
						merge 1:1 individ using `hh_roster', nogen
							 save "$tidy\mid_indiv_level_data.dta", replace 
								
** now bring in CRDES survey household level data SECOND and merge

		use "$tidy\mid_standard_of_living_module", clear
			
					merge 1:1 hhid using "$tidy\mid_beliefs_module", nogen // household level data 		
					merge 1:1 hhid using "$tidy\mid_asset", nogen
					
					*KRM - figure out which df has the bad IDs - I think it's all of them ??
					drop if inlist(hhid, "133A19", "133A03", "133A20", "133A02", "133A05", "133A11")
											
							save "$tidy\mid_hh_level_data.dta", replace 
							
** now merge the CRDES survey data together

		use "$tidy\mid_indiv_level_data.dta", clear
			
					merge m:1 hhid using "$tidy\mid_hh_level_data.dta", nogen
					merge m:1 hhid_village using "$tidy\mid_community.dta", nogen
					
							save "$tidy\midline_crdes_data", replace 
							
** now bring in child matched IDs the link in the parasitological data and survey data

		use "$paras\child_matched_IDs_df.dta", clear
				drop round
					merge 1:1 identificant using "$tidy\mid_paras_data.dta" // merge in paras data
						keep if _merge == 3
							drop _merge

					
					merge m:1 individ using "$tidy\midline_crdes_data" // merge in CRDES data
						keep if _merge == 3
							drop _merge
							
							
					merge m:1 hhid_village using "$tidy\mid_eco_data" // merge in eco data
						keep if _merge == 3
							drop _merge
				
*-------------------*
**#####Order variables
*-------------------*		
	
	gen round = 2

		order hhid_village village_name hhid individ identificant match_score  ///
		hh_age_ hh_gender_ fishing  ///
		hh_10_ hh_12_6_ hh_26_ hh_32_ hh_37_  ///
		health_5_2_ health_5_3_1_ health_5_3_2_ health_5_3_3_ health_5_3_6_ health_5_3_9_ health_5_5_ health_5_8_ health_5_9_ ///
		living_01_bin living_04_bin ///
		beliefs_01_bin beliefs_02_bin beliefs_03_bin ///
		asset_index asset_index_std ///
		sh_inf sm_inf sm_sh_inf sh_egg_count p1_avg p2_avg sm_egg_count total_egg age_hp sex_hp ///
		q_51 ///
		Cerratophyllummassg Bulinus Biomph Humanwatercontact InfectedBulinus InfectedBiomphalaria schisto_indicator round

*-------------------*
**#####Label variables
*-------------------*			
	
	
		label variable hhid_village "Village ID"
		label variable village_name "Village name"
		
		label variable hh_age_ "Individual's age"
		label variable hh_gender_ "Individual's gender"
		label variable fishing  "Indicator if individual selected fishing as maing household activity"
		
		label variable hh_10_ "Hours per week spent within 1 meter of surface water source"
		label variable hh_12_6_ "Harvest aquatic vegetation"
		label variable hh_26_ "Currently enrolled in formal school? (1=Yes, 2=No)"
		label variable hh_32 "Attends school during the 2023/2024 academic year"
		label variable hh_37_ "Missed >1 consecutive week of school due to illness in the past 12 months? (1=Yes, 0=No, asked to children)"
		

		label variable health_5_2 "Fell ill in the last 12 months"
		label variable health_5_3_1 "Suffered from Malaria"
		label variable health_5_3_2 "Suffered from Bilharzia"
		label variable health_5_3_3 "Suffered from Diarrhea"
		label variable health_5_3_6 "Suffered from Skin issues"
		label variable health_5_3_9 "Suffered from Stomach ache"
		label variable health_5_5 "Received medication for schistosomiasis treatment in last 12 months"
		label variable health_5_8 "Had blood in urine in the last 12 months"
		label variable health_5_9 "Had blood in stool in the last 12 months"



		label variable living_01_bin "Indicator for selected tap water as main source of drinking water"
		label variable living_04_bin "Indicator for latrine in home"
		label variable beliefs_01_bin "Probability of contracting bilharzia in the next 12 months (1=Strongly agree/Agree)"
		label variable beliefs_02_bin "Probability of household member contracting bilharzia in the next 12 months (1=Strongly agree/Agree)"
		label variable beliefs_03_bin "Probability of a child contracting bilharzia in the next 12 months (1=Strongly agree/Agree)"
		
		label variable asset_index "PCA Asset index"
		label variable asset_index_std "Standardized PCA Asset index"
		
		label variable schisto_indicator "Indicator for presence of schistosomiasis infection"
		label variable sh_inf "Indicator for Schistosoma haematobium infection"
		label variable sm_inf "Indicator for Schistosoma mansoni infection"
		label variable sm_sh_inf "Indicator for Schistosoma manson OR haematobium infection"
		label variable sh_egg_count "Egg count for Schistosoma haematobium"
		label variable sm_egg_count "Egg count for Schistosoma mansoni"
		label variable p1_avg "Average EPG from P1 (Kato-Katz slide 1 and 2)"
		label variable p2_avg "Average EPG from P2 (Kato-Katz slide 1 and 2)"
		label variable total_egg "Total schistosome egg count"
		label variable sex_hp "EPLS/UCAD child sex"
		label variable age_hp "EPLS/UCAD child age"
		
		label variable q_51 "Distance to health facility"
		label variable round "0 = Baseline, 1 = Midline"
		
		
*-------------------*
**#####save final data frame
*-------------------*		
	
		
				save "$paras\02_midline_analysis_df.dta", replace 
			
*-------------------*
**## APPEND BASELINE & MIDLINE
*-------------------*					


		use "$paras\02_baseline_analysis_df.dta", clear
			append using "$paras\02_midline_analysis_df.dta"
		
			
*-------------------*
**## Winsorize continuous values
*-------------------*	



* Get detailed summary stats
	summarize hh_10_, detail

* Display specific percentiles
	display "90th percentile: " r(p90)
	display "95th percentile: " r(p95)
	display "99th percentile: " r(p99)
			
			
**   hh_10
	egen hh_10_p99 = pctile(hh_10_), p(99)
		gen hh_10_w99 = hh_10_
			replace hh_10_w99 = hh_10_p99 if hh_10_ > hh_10_p99 & !missing(hh_10_)
				drop hh_10_p99

	order hh_10_w99, before(hh_10_)
	label variable hh_10_w99 "Hours per week spent within 1 meter of surface water source, Winsorized 99th"
				
* Get detailed summary stats
	summarize q_51, detail
			
* Display specific percentiles
	display "90th percentile: " r(q_51)
	display "95th percentile: " r(q_51)
	display "99th percentile: " r(q_51)			
			
**   q_51
	egen q_51_p99 = pctile(q_51), p(99)
		gen q_51_w99 = q_51
			replace q_51_w99 = q_51_p99 if q_51 > q_51_p99 & !missing(q_51)
				drop q_51_p99			
			

	order q_51_w99, before(q_51)		
	order hh_10_w99, before(hh_10_)
		label variable q_51_w99 "Distance to health facility, Winsorized 99th"
		
*-------------------*
**## data corrections
*-------------------*	
		
		

		
preserve 

			keep if hh_age_ < 4 | hh_age_ > 18
				keep hhid_village village_name hhid individ match_score identificant hh_age_ hh_gender_ round

				tab hh_age_
				
			
restore 


	replace hh_age_ = 4 if individ == "072B2010" & round == 2
	
*-------------------*
**## data imputation
*-------------------*	


		
		foreach var of varlist _all {
			quietly count if missing(`var')
			if r(N) > 0 {
				local type : type `var'
				display "`var' (`type'): " r(N) " missing"
			}
		}
				
				
	** determine how to take care of the missings here

			
*-------------------*
**## Save final df
*-------------------*	

					
			save "$paras\03_mid_base_analysis_df.dta", replace 			
			


** end of .do file :D


