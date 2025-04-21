*==============================================================================
* Program: PCA - Asset Index
* ==============================================================================
* written by: Kateri Mouawad
* additions made by: Kateri Mouawad
* Created: February 2024
* Updates recorded in GitHub 

 ** This file processes: 
	* Complete_Baseline_Household_Roster.dta
	* Complete_Baseline_Health.dta
	* Complete_Baseline_Agriculture.dta
	* Complete_Baseline_Income.dta
	* Complete_Baseline_Standard_Of_Living.dta
	* Complete_Baseline_Public_Goods_Game.dta
	* Complete_Baseline_Enumerator_Observations.dta
	* Complete_Baseline_Community.dta
	
** This file outputs:
   
   * PCA_asset_index_var.dta
	

* <><<><><>> Read Me * <><<><><>>

 *This file outputs an asset index following the Principle Component Analaysis method. 
		* 1) merge in the data
		* 2) select relevant variables
		* 3) create relevant variables (TLU is created here again)
		* 4) Standardize continuous variables 
		* 5) Run PCA test
		* 6) Keep PC1 components 
		* 7) PART TO UPDATE - keep relevent components 
		* 6) Create index
		* 7) Save variable with hhid. 

*<><<><><>><><<><><>>
* BEGIN INITIATION	
*<><<><><>><><<><><>>		
		
		
	clear all
	set mem 100m
	set maxvar 30000
	set matsize 11000
	set more off

*<><<><><>><><<><><>>
* SET FILE PATHS
*<><<><><>><><<><><>>

* Set base Box path for each user
	if "`c(username)'"=="socrm" global master "C:\Users\socrm\Box\NSF Senegal"
	if "`c(username)'"=="kls329" global master "C:\Users\kls329\Box"
	if "`c(username)'"=="km978" global master "C:\Users\km978\Box\NSF Senegal"
	if "`c(username)'"=="Kateri" global master "C:\Users\Kateri\Box\NSF Senegal"
	if "`c(username)'"=="admmi" global master "C:\Users\admmi\Box"

	if "`c(username)'"=="km978" global gitmaster "C:\Users\Kateri\Downloads\GIT-Senegal\NSF-Senegal"
	if "`c(username)'"=="Kateri" global gitmaster "C:\Users\km978\Downloads\GIT-Senegal\NSF-Senegal"


  *^*^* Define project-specific paths

	global data "${master}\Data_Management\Data\_CRDES_CleanData\Baseline\Deidentified"

  *^*^* Output folders 
	global dataOutput "${master}\Data_Management\Output\Analysis\Balance_Tables" 
	global latexOutput "$git_path\Latex_Output\Balance_Tables"
	
  *^*^*  Bring in data 

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

	merge m:1 hhid_village using "$data\Complete_Baseline_Community.dta"
		drop _merge 


* agri_income_23	8.26 Income by frequency
* agri_income_24	8.27 Total annual income
* agri_income_25    8.28 Do you have employees for your non-agricultural activities?
* agri_income_40	8.43 Have you (or a member of your household) lent money to others during this year?
* agri_income_26    8.29 If yes, please specify the number.
* agri_income_27    8.30 Are these employees paid? Question relevant when: 0
* agri_income_40	8.43 Have you (or a member of your household) lent money to others during this year?
* iving_01	9.1 What is the main source of drinking water supply?
* living_02	9.2 Is the water used treated in the household?
* living_03	9.3 If yes, how do you treat the water?
* living_04	9.4 What type of toilet facilities does the household use?
* living_05	9.5 What is the primary fuel used for cooking?
* living_06	9.6 What is the primary fuel used for lighting?


  *^*^* physical assets or durable goods
	keep hhid hhid_village hh_numero agri_6_6 agri_6_23* agri_6_5*  ///
	enum_05* enum_03* enum_04* ///
	living_05* living_06* living_02* living_01* ///
	list_actifs* species*


** drop unneeded vars

	drop agri_6_23_o* living_01_o living_05_o ///
	enum_03_o enum_04_o enum_05_o ///
	species species_autre speciesindex* speciesname* species_o ///   
	list_actifs list_actifs_o living_06_o

*<><<><><>><><<><><>>
* CREATE NEW VARS 
*<><<><><>><><<><><>>

			 
** Living_01 = 1 & 2 & 3

** 1 = Indoor tap
** 2 = Public tap
** 3 = Neighbor's tap
** 4 = Protected well
** 5 = Unprotected well
** 6 = Borehole
** 7 = Tanker truck service
** 8 = Water vendor
** 9 = Spring
** 10 = Stream
** 99 = Other

	gen living_01_bin = 0
		replace living_01_bin = 1 if living_01 == 1 |living_01 == 2 | living_01 == 3 


** living_02
** 9.2 Is the water used treated in the household?
** Yes
** No
** Don't know/did not answer

	gen living_02_bin = 0
		replace living_02_bin = 1 if living_02 == 1

** Living_04 == 1 & 2

** 0 None/Outdoors
** 1 Flush toilet with sewer
** 2 Flush toilet with septic tank
** 3 Bucket
** 4 Covered pit latrine
** 5 Uncovered pit latrine
** 6 Improved latrines
** 99 Others

	gen living_04_bin = 0
		replace living_04_bin = 1 if living_04 == 1 | living_04 == 2 


***** living_05  - options we keep 
** 3 Gas
** 4 Electricity
** 5 Petrol/oil/ethanol
** 6 Animal waste/dung
** 7 Solar


	gen living_05_bin = 0
		replace living_05_bin = 1 if living_05 == 3 | living_05 == 4 | living_05 == 5 | living_05 == 6 | living_05 == 7 


** Living_06 == 1 & 2 &3
** 1 Electricity (Sénélec)
** 2 Electric generator
** 3 Solar
** 4 Gas lamp
** 5 Oil/hurricane lamp
** 6 Candle
** 7 Torchlight
** 99 Other

	gen living_06_bin = 0
		replace living_06_bin = 1 if living_06 == 2 | living_06 == 3


* Create binary agri_6_5 = 2
** 6.5. Did you rent the house or are you the owner?

	gen agri_6_5_bin = 0
		replace agri_6_5_bin = 1 if agri_6_5 == 2 


*** create TLU species variable 

** Species	      TLU Equivalent
** Cattle	          1.0
** Sheep	          0.1
** Goat	              0.1
** Horse (equine)     1.0
** Donkey	          0.5
** Draft animals	  1.0
** Pigs	              0.2
** Poultry	          0.01


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

** List the final TLU variable
	list hhid TLU

** Create rooms per member variable

	gen rooms_per_member = hh_numero / agri_6_6 if agri_6_6 > 0 	

** create binary for agri_6_23

	gen agri_6_23_bin = 0  
	foreach var of varlist agri_6_23_1-agri_6_23_11 {  
		replace agri_6_23_bin = 1 if `var' == 1  
	}

** Check data summary
	summarize list_actifs_* ///
	living_01_bin living_02_bin living_05_bin living_06_bin ///
	agri_6_5_bin agri_6_23_bin ///
	TLU rooms_per_member 


** Standardize continuous variables before PCA
	foreach var in rooms_per_member TLU {
		egen z_`var' = std(`var')  // Create z-score versions
	}

** The correlation matrix standardizes the data, making comparisons between these variables possible, 
** and prevents highly correlated variables (such as the binary ones) from distorting the PCA results.

* Run PCA
pca list_actifs_* ///
    living_01_bin living_02_bin living_05_bin living_06_bin ///
    agri_6_5_bin agri_6_23_bin ///
    z_TLU z_rooms_per_member
r 

** removed living_04_bin because it had 0 variance 

** Display variance explained by each component
	screeplot, ytitle("Proportion of Variance Explained") 


**   PC1 (the first principal component) is typically used as the asset index because it explains the most 
** 	 variation in the data and is often interpreted as a measure of wealth or socioeconomic status in the context of PCA.

** Extract the first principal component (PC1) as the asset index
	predict asset_index if e(sample), score

** Normalize the asset index for better interpretability
	egen asset_index_std = std(asset_index)

** Display results
	list list_actifs_* ///
	living_01_bin living_02_bin living_04_bin living_05_bin living_06_bin ///
	agri_6_5_bin agri_6_23_bin ///
	z_rooms_per_member z_TLU ///
	 if _n <= 10, sep(0)
	  
*^*^* Save data frame 

preserve 

 keep hhid asset_index asset_index_std
* Save dataset with PCA results
save "$dataOutput\PCA_asset_index_var.dta", replace

restore 
*/


