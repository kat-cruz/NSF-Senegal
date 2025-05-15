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
	* Step 2) 
	* Step 3) 
	* Step 4) 
	* Step 5)
	* Step 6) 
	* Step 7) 

*-----------------------------------------*
**#  INITIATE SCRIPT
*-----------------------------------------*

	clear all
	set mem 100m
		set maxvar 30000
		set matsize 11000
	set more off

*-----------------------------------------*
* SET FILE PATHS
*-----------------------------------------*

disp "`c(username)'"

* Set global path based on the username
if "`c(username)'" == "admmi" global master "C:\Users\admmi\Box\NSF Senegal"
if "`c(username)'" == "Kateri" global master "C:\Users\Kateri\Box\NSF Senegal"
if "`c(username)'" == "socrm" global master "C:\Users\socrm\Box\NSF Senegal"

	global baseline "$master\Data_Management\Data\_CRDES_CleanData\Baseline\Deidentified"
	global midline "$master\Data_Management\Data\_CRDES_CleanData\Midline\Deidentified"
	global balance "$master\Data_Management\Output\Analysis\Balance_Tables\baseline_balance_tables_data_PAP.dta"
	global treatment "$master\Data_Management\Data\_CRDES_CleanData\Treatment\Identified\treatment_indicator_PII.dta"
	global asset_index "$master\Data_Management\Output\Data_Processing\Construction\PCA_asset_index_var.dta"
	global respondent_index "$master\Data_Management\Output\Data_Processing\Construction\respondent_index.dta"
	global hh_head_index "$master\Data_Management\Output\Data_Processing\Construction\household_head_index.dta"
	global balance_tables "$master\Data_Management\Output\Analysis\Balance_Tables"

	global baseline_agriculture "$baseline\Complete_Baseline_Agriculture.dta"
	global baseline_beliefs "$baseline\Complete_Baseline_Beliefs.dta"
	global baseline_community "$baseline\Complete_Baseline_Community.dta"
	global baseline_enumerator "$baseline\Complete_Baseline_Enumerator_Observations.dta"
	global baseline_geographies "$baseline\Complete_Baseline_Geographies.dta"
	global baseline_health "$balance_tables\Complete_Baseline_Health.dta"
	global baseline_household "$baseline\Complete_Baseline_Household_Roster.dta"
	global baseline_income "$baseline\Complete_Baseline_Income.dta"
	global baseline_knowledge "$baseline\Complete_Baseline_Knowledge.dta"
	global baseline_lean "$baseline\Complete_Baseline_Lean_Season.dta"
	global baseline_production "$baseline\Complete_Baseline_Production.dta"
	global baseline_standard "$baseline\Complete_Baseline_Standard_Of_Living.dta"
	global baseline_community "$baseline\Complete_Baseline_Community.dta"
	global baseline_games "$baseline\Complete_Baseline_Public_Goods_Game"

*-----------------------------------------*
**# Household Roster Module 
*-----------------------------------------*
use "$baseline_household", clear
		merge 1:1 hhid using "$hh_head_index", nogen
		merge 1:1 hhid using "$respondent_index", nogen

*-----------------------------------------*
**### bring in respondent and household index
*-----------------------------------------*
			forvalues i = 1/55 {
    gen resp_index_`i' = (resp_index == `i')
}

			forvalues i = 1/55 {
	gen hh_index_`i' = (hh_index == `i')
}

keep  resp_index* hh_gender* hh_age* hh_relation_with* hh_education_skills_1_* hh_education_skills_2_* hh_education_skills_3_* hh_education_skills_4_* hh_education_skills_5_* hh_education_level_*  ///
			hh_12_1_* hh_12_2_* hh_12_3_* hh_12_4_* hh_12_5_* hh_12_6_* hh_12_7_* hh_12_8_* hh_13_1_* hh_13_2_* hh_13_3_* hh_13_4_* hh_13_5_* hh_13_6_* hh_13_7_* hh_14_* hh_15_* hh_16_* hh_26_* hh_27_* hh_29_* hh_31_* hh_32_* hh_37_* hh_38_*  ///
			hh_03_* hh_10_* hh_11_v hh_12index_1_* hh_12index_2_* hh_12index_3_* hh_12index_4_* hh_12index_5_* hh_12index_6_* hh_12index_7_*

***	 Drop variables with numbered suffixes (1 to 55) that are unneeded
		forval i = 1/55 {
			drop hh_education_skills_`i' hh_12_`i' health_5_3_`i'
		}


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

*-----------------------------------------*
**### reshape data from wide to long
*-----------------------------------------*
	
	reshape long resp_index_ hh_gender_ hh_age_ hh_relation_with_ hh_education_skills_1_ hh_education_skills_2_ hh_education_skills_3_ hh_education_skills_4_ hh_education_skills_5_ hh_education_level_  ///
			hh_12_1_ hh_12_2_ hh_12_3_ hh_12_4_ hh_12_5_ hh_12_6_ hh_12_7_ hh_12_8_ hh_13_1_ hh_13_2_ hh_13_3_ hh_13_4_ hh_13_5_ hh_13_6_ hh_13_7_ hh_14_ hh_15_ hh_16_ hh_26_ hh_27_ hh_29_ hh_31_ hh_32_ hh_37_ hh_38_  ///
			hh_03_ hh_10_ hh_11_ hh_12index_1_ hh_12index_2_ hh_12index_3_ hh_12index_4_ hh_12index_5_ hh_12index_6_ hh_12index_7_, ///
				i(hhid) j(id) 

*-----------------------------------------*
**### correct for missing values
*-----------------------------------------*
*** Check for missing values in the dataset

	foreach var of varlist _all {
			quietly count if missing(`var')
			display "`var': " r(N)
		}

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

*** Found to have -9s: 
	
		** 	hh_38_ 
		**	health_5_12_ 
		**	agri_income_05

*** make corrections by replacing with missing 

foreach var in hh_38_ health_5_12_ agri_income_05 {
		replace `var' = .a if `var' == -9
	}

*-----------------------------------------*
** replace 2s for variables that have option "I don't know" 
*-----------------------------------------*
	*1 Yes
	*0 No
	*2 Don't know / Don't answer

foreach var in hh_03_ hh_26_ hh_27_ hh_37_ health_5_2_ health_5_5_ health_5_6_ ///
		 {
				replace `var' = .a if `var' == 2
	}

*-----------------------------------------*
**### Child module
*-----------------------------------------*
*** keep only if children are present 

foreach var in hh_29_ hh_37_ hh_38_ {
		replace `var' = 0 if missing(`var') & (hh_age_ >= 4 & hh_age_ <= 18)
	}

*** Begin variable construction 
*-------------------*
**#### child_in_home
*-------------------*


	egen child_in_home = max(hh_age_ >= 4 & hh_age_ <= 18), by(hhid)


*-------------------*
**#### Grade level indicators 
*-------------------*

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

*** hh_29_01
		gen hh_29_01 = (0 < hh_29_ & hh_29_ <= 6)  // Primary level

			replace hh_29_01 = .a if missing(hh_29_)
			replace hh_29_01 = 0 if missing(hh_29_01) & (hh_age_ >= 4 & hh_age_ <= 18)

*** hh_29_02


		gen hh_29_02 = (hh_29_ >= 7 & hh_29_ <= 10)  // Secondary middle level
			replace hh_29_02 = .a if missing(hh_29_)
			replace hh_29_02 = 0 if missing(hh_29_02) & (hh_age_ >= 4 & hh_age_ <= 18)

*** hh_29_03


		gen hh_29_03 = (hh_29_ >= 11 & hh_29_ <= 13)  // Secondary higher level
			replace hh_29_03 = .a if missing(hh_29_)
			replace hh_29_03 = 0 if missing(hh_29_03) & (hh_age_ >= 4 & hh_age_ <= 18)

*** hh_29_04


		gen hh_29_04 = (hh_29_ == 14)  // Upper secondary
			replace hh_29_04 = .a if missing(hh_29_)
			replace hh_29_04 = 0 if missing(hh_29_04) & (hh_age_ >= 4 & hh_age_ <= 18)

*-------------------*
*** hh_31_bin
*-------------------*
	*1. Graduated, studies completed
	*2. Moving to the next class
	*3. Failure, repetition
	*5. Dropping out during the year
	

		gen hh_31_bin = 0
		replace hh_31_bin = 1 if hh_31_ == 1 | hh_31_ == 2
		replace hh_31_bin = . if missing(hh_31_) & (hh_age_ >= 4 & hh_age_ <= 18) // Set to missing if hh_31_ is empty to account for ONLY the child population 

*^*^* collaspe by mean at the CHILD level 	 
	
	
					
		preserve

			keep if child_in_home == 1

			collapse (count) child_in_home hh_26_ hh_27_ hh_31_bin hh_37_ hh_29_* ///
						(mean) hh_38_, by(hhid)

			tempfile child_aggregates
			save `child_aggregates'

		restore


*-----------------------------------------*
**### clean up household roster variables
*-----------------------------------------*

* Recode hh_gender_ (change 2 to 0, leave others unchanged)
	
	recode hh_gender_ (2=0)

*^*^* Fill in logic missings for variables dependent on hh_10

	foreach var in hh_11_ hh_14_  hh_16_  {
				replace `var' = 0 if hh_10_ == 0
		}
		
***	Loop through hh_12_1_ to hh_12_8_
		forval i = 1/8 {
			replace hh_12_`i'_ = 0 if hh_10_ == 0
		}

*** Loop through hh_13_1_ to hh_13_8_
		forval i = 1/7 {
			replace hh_13_`i'_ = 0 if hh_10_ == 0
		}

*^*^* filter variables that rely on index  

	forvalues j = 1/8 {
		gen hh_13_0`j' = .
		forvalues i = 1/7 {
			replace hh_13_0`j' = hh_13_`i' if hh_12index_`i' == `j'
		}
	}

*-----------------------------------------*
**### create household variables 
*-----------------------------------------*
*-------------------*
**#### hh_11_
*-------------------*

*** Education - Skills (multiple choice)

		** 2. Comfortable with numbers and calculations
		** 3. Arabizing/can read the Quranin Arabic
		** 4. Fluent in Wolof/Pulaar
		** 5. Can read a newspaper in French

***source(s) of surface water?

	** source(s) of surface water?
	* Creating binary variables for hh_11
	

	foreach x in 1 2 3 4 99 {
		gen hh_11_`x' = hh_11_ == `x'
	}

*-------------------*
**#### hh_11_
*-------------------*
*** 	*How did he use aquatic vegetation?
***	 	 create binary variables for hh_15

	foreach x in 1 2 3 4 5 99 {
		gen hh_15_`x' = .
		replace hh_15_`x' = 1 if hh_15_ == `x'
	}		 
	
	** main source of drinking water supply
		** 1 = Interior tap
		** 2 = Public tap
		** 3 = Neighbor's tap
		** 4 = Protected well
		** 7 = Tanker truck service
		** 8 = Water vendor
		
	*	(update to include protected well and tanker)
*-------------------*
**#### living_01_bin
*-------------------*

	gen living_01_bin = 0
		replace living_01_bin = 1 if living_01 == 1 |living_01 == 2 | living_01 == 3 | living_01 == 4 | living_01 == 7 | living_01 == 8

*-------------------*
**#### living_04_bin
*-------------------*

		** Main type of toilet 
		**1 Flush with sewer
		**2 Toilet flush with 

		gen living_04_bin = 0
			replace living_04_bin = 1 if living_04 == 1 | living_04 == 2 

*-------------------*
**#### living_05_bin
*-------------------*

		** main fuel used for cooking
		** 4 Electricity
		** 7 solar
		gen living_05_bin = 0
			replace living_05_bin = 1 if living_05 == 4 


*-------------------*
**#### living_06_bin
*-------------------*

		** primary fuel used for lighting
		** 1 Electricity (Sénélec)
		** 3 Solar

		gen living_06_bin = 0
			replace living_06_bin = 1 if living_06 == 1 | living_06 == 3


*-------------------*
**#### household head variables
*-------------------*

rename hh_age_ hh_age 
			rename hh_gender_ hh_gender
			rename hh_education_skills_5_ hh_education_skills_5
* Loop through the variables and create the corresponding head variables
		foreach var in hh_age hh_gender hh_education_skills_5 hh_education_level_bin {
			* Create new variable for each
			gen `var'_h = . 
			
			* Replace the new variable with the value from the original variable if hh_relation_with_ == 1
			replace `var'_h = `var' if hh_index_ == 1
		}


*-----------------------------------------*
**### collapse household variables
*-----------------------------------------*
 
		collapse (mean) ///
			hh_age_h hh_education_level_bin_h hh_education_skills_5_h hh_gender_h hh_numero trained_hh child_in_home ///
			hh_03_ hh_10_ hh_11_* hh_12_*  hh_13_* hh_14_ hh_15_* hh_16_ /// 	
			 (first) hhid_village, ///
		collapse (max) hh_12_6_ hh_03_ health_5_3_bin health_5_6_
			by(hhid)
			
	
			
			merge 1:1 hhid using `child_aggregates'
	//hh_26_ hh_27_  hh_31_bin hh_37_ hh_38_ hh_29_*  ///  //edu vars 
	

		
		order 


*** merge all together needed for balance tables
	merge 1:1 hhid using "$baseline_health", nogen
		merge 1:1 hhid using "$baseline_agriculture", nogen
		merge 1:1 hhid using "$baseline_income", nogen
		merge 1:1 hhid using "$baseline_standard", nogen
		merge 1:1 hhid using "$baseline_games", nogen
		merge 1:1 hhid using "$baseline_enumerator", nogen
		merge 1:1 hhid using "$baseline_beliefs", nogen	
		merge 1:1 hhid using "$hh_head_index", nogen
		merge 1:1 hhid using "$respondent_index", nogen
		merge m:1 hhid_village using "$baseline_community", nogen
		
*-----------------------------------------*
**### keep only relevant variables
*-----------------------------------------*
		

		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		