*==============================================================================
* Program: balance tables data tranformation
* ==============================================================================
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
	* Complete_Baseline_Community.dta
	
 ** This file outputs:
 
 
 
*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<~~~~ Read Me! ~~~~ >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	* This script merges selects, cleans, and orders the baseline data to setup the dataframe for analysis for the balance tables. 
	* Step 1)
		* Merge all deidentfied dataframes with relevant variables
	* Step 2) Select variables we pre-decided on to check balances
	* Step 3) Rename variables so correct indicies get transformed when we switch the data from wide to long
	* Step 4) Remove useless/dumb variables
	* Step 5) Wrangle data from wide to long for data accuracy and efficiency 
	* Step 6) Reorder variables for clarity
	* Step 7) Save as .csv so we can create the tables in R in the Balance_tables.rmd

clear all
set mem 100m
set maxvar 30000
set matsize 11000
set more off

**************************************************
* SET FILE PATHS
**************************************************
* Set base Box path for each user
if "`c(username)'"=="socrm" global master "C:\Users\socrm\Box"
if "`c(username)'"=="kls329" global master "C:\Users\kls329\Box"
if "`c(username)'"=="km978" global master "C:\Users\km978\Box\NSF Senegal"
if "`c(username)'"=="Kateri" global master "C:\Users\Kateri\Box\NSF Senegal"
if "`c(username)'"=="admmi" global master "C:\Users\admmi\Box"

if "`c(username)'"=="km978" global gitmaster "C:\Users\Kateri\Downloads\GIT-Senegal\NSF-Senegal"
if "`c(username)'"=="Kateri" global gitmaster "C:\Users\km978\Downloads\GIT-Senegal\NSF-Senegal"



* Define project-specific paths

global data "${master}\Data_Management\_CRDES_CleanData\Baseline\Deidentified"

***** Data folders *****
global dataOutput "${master}\Data_Management\Output\Data_Analysis\Balance_Tables" 
global latexOutput "$git_path\Latex_Output\Balance_Tables"

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



********************************************************* Keep relevant variables *********************************************************


** hh_26: 3.41. <font color = "blue"> ${hh_scoohl-name}  </font>a-t-il fait ou fait-il des études actuellement dans une école formelle? 1=oui, 2=non [si non, skip à hh_27]

** hh_27: 3.42. Did <font color = "blue"> ${hh_scoohl-name}  </font> attend non-formal school or non-formal training ? 1=yes, 2=no

** hh_31: 3.46. What result did <font color = "blue"> ${hh_scoohl-name}  </font> achieve during the 2023/2024 school year ?

** hh_38: 3.53. During the last seven days, how many days did <font color = "blue"> ${hh_scoohl-name}  </font> go to school for classes ?

** hh_37: 3.52. During the last 12 months, has <font color = "blue"> ${hh_scoohl-name}  </font> ever missed more than one consecutive week of school due to illness ?


keep hhid hhid_village ///
	 q_51  ///  // village level var 
     hh_relation_with_* hh_gender* hh_age* hh_age_resp hh_gender_resp ///
     hh_education_skills* hh_education_level*  ///
     hh_numero* hh_03* hh_10* hh_11* hh_12* hh_12index_* hh_13* hh_14* hh_15* hh_16* hh_29* /// 	
	 hh_31* hh_33* ///  //edu vars 
     health_5_2* health_5_3* health_5_5* health_5_6* health_5_12* ///
     agri_6_15* species* agri_income_01 agri_income_05 ///
	 agri_6_21*  /// // surface area of plot 
	 agri_6_32* agri_6_36* /// // used fertilizer vars
	 agri_6_38_a* agri_6_39_a* agri_6_40_a* agri_6_41_a* /// // quantity of fertilizer
     living_01* living_03* living_04* living_05* living_06* ///
     montant_02* montant_05* ///
     face_04* face_13* ///
     enum_03* enum_04* enum_05*

********************************************************* Drop unecessary variables *********************************************************
	


*/ Drop variables with numbered suffixes (1 to 55) for specific patterns
forval i = 1/55 {
    drop hh_education_skills_`i' hh_12_`i' health_5_3_`i'
}

* Drop uneeded variables 
drop hh_relation_with_o* hh_12_o* hh_12_a* hh_13_s* hh_13_o*  ///
     living_01_o living_03_o living_04_o living_05_o ///
     enum_03_o enum_04_o enum_05_o species_o ///
	hh_12_r* hh_12name_* hh_12_calc_* hh_education_level_o_* ///
     hh_11_o_* hh_education_skills_0_* hh_15_o_* hh_29_o* health_5_3_o* ///
	 speciesindex* species_autre speciesname* living_06_o ///
	agri_6_38_a_code_o* agri_6_39_a_code_o* agri_6_40_a_code_o* agri_6_41_a_code_o*

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


* Reshape long with hhid and id
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


********************************************************* Reshape the data *********************************************************

	
	reshape long hh_gender_ hh_age_ hh_relation_with_ hh_education_skills_1_ hh_education_skills_2_ hh_education_skills_3_ hh_education_skills_4_ hh_education_skills_5_ health_5_3_1_ health_5_3_2_ health_5_3_3_ health_5_3_4_ health_5_3_5_ health_5_3_6_ health_5_3_7_  health_5_3_8_ health_5_3_9_ health_5_3_10_ health_5_3_11_ health_5_3_12_ health_5_3_13_ health_5_3_14_ health_5_3_15_ health_5_3_99_ hh_education_level_ ///
hh_number_ hh_03_ hh_10_ hh_11_ hh_12index_1_ hh_12index_2_ hh_12index_3_ hh_12index_4_ hh_12index_5_ hh_12index_6_ hh_12index_7_ ///
hh_12_1_ hh_12_2_ hh_12_3_ hh_12_4_ hh_12_5_ hh_12_6_ hh_12_7_ hh_12_8_ hh_13_1_ hh_13_2_ hh_13_3_ hh_13_4_ hh_13_5_ hh_13_6_ hh_13_7_ hh_14_ hh_15_ hh_16_ hh_29_ hh_31_ hh_33_ ///
health_5_2_ health_5_3_ health_5_5_ health_5_6_ health_5_12_, i(hhid) j(id)

 
********************************************************* filter variable *********************************************************

forvalues j = 1/8 {
    gen hh_13_0`j' = .
    forvalues i = 1/7 {
        replace hh_13_0`j' = hh_13_`i' if hh_12index_`i' == `j'
    }
}


drop hh_13_7_ hh_13_6_ hh_13_5_ hh_13_4_ hh_13_3_ hh_13_2_ hh_13_1_ 
drop hh_12index_7_ hh_12index_6_ hh_12index_5_ hh_12index_4_ hh_12index_3_ hh_12index_2_ hh_12index_1_


*Collapse at hh level - default to mean, change to something else IEBaltab - balance table output 

********************************************************* Replace missings by accounting for skip patterns *********************************************************

** replace 2s for hh_03 health_5_2 health_5_5 health_5_6 as missings 

foreach var in hh_03_ health_5_2_ health_5_5_ health_5_6_ {
    replace `var' = .a if `var' == 2
}


*replace agri_income_05 = 0 if agri_income_01 == 0
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

********************************************************* Encode variables to binaries  *********************************************************

* Creating binary variables for hh_education_level
/*
foreach x in 0 1 2 3 4 99 {
    gen hh_education_level_`x' = hh_education_level_ == `x'
    replace hh_education_level_`x' = 0 if missing(hh_education_level_)
}

*/
** update this ** 

** maybe adjust?

** Level of education achieved
** 2: Secondary level
** 3: Higher level
** 4: Technical and vocational school


gen hh_education_level_bin = 0
replace hh_education_level_bin = 1 if hh_education_level_ == 2 | hh_education_level_ == 3 | hh_education_level_ == 4


**Education - Skills (multiple choice)

** 2.Comfortable with numbers and calculations
** 3. Arabizing/can read the Quranin Arabic
** 4. Fluent in Wolof/Pulaar
** 5. Can read a newspaper inFrench


gen hh_education_skills_bin = 0
replace hh_education_skills_bin = 1 if hh_education_skills_2_ == 1 | hh_education_skills_3_ == 1 | hh_education_skills_4_ == 1 | hh_education_skills_5_ == 5


** source(s) of surface water?

** source(s) of surface water?
* Creating binary variables for hh_11
foreach x in 1 2 3 4 99 {
    gen hh_11_`x' = hh_11_ == `x'
    replace hh_11_`x' = 0 if missing(hh_11_)
}

*How did he use aquatic vegetation?
* Creating binary variables for hh_15
foreach x in 1 2 3 4 5 99 {
    gen hh_15_`x' = hh_15_ == `x'
    replace hh_15_`x' = 0 if missing(hh_15_)
}

** dropping variable
/*
* Creating binary variables for hh_29
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

* Creating binary variables for enum_05
/*
foreach x in 1 2 3 4 5 99 {
    gen enum_05_`x' = enum_05 == `x'
    replace enum_05_`x' = 0 if missing(enum_05)
}
*/

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

* Display results
keep hhid_village num_water_access_points

* Save as a temporary file
tempfile water_access
save `water_access'


** merge in data

use `balance_table_ata'
merge m:m hhid_village using `water_access'
drop _merge

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

* List the final TLU variable
list hhid species TLU

** create grouped variables for fertilizer amount
   *agri_6_15 // how many plots cultivated 
   *agri_6_21*  /// // surface area of plot 
	agri_6_32* agri_6_36* /// // used fertilizer vars
	agri_6_38_a* agri_6_39_a* agri_6_40_a* agri_6_41_a*
	
	
	


** bring in Asset index 

merge m:m hhid using "$dataOutput\PCA_asset_index_var.dta"



******************************************************** Reorder the variables & collapse at household level *********************************************************
* drop empty/useless variables 

drop _merge id species health_5_3_ health_5_3_10_ health_5_3_11_ health_5_3_12_ health_5_3_13_ health_5_3_14_ health_5_3_15_ health_5_3_1_ health_5_3_2_ health_5_3_3_ health_5_3_4_ health_5_3_5_ health_5_3_6_ health_5_3_7_ health_5_3_8_ health_5_3_99_ health_5_3_9_ 

** aggregate by HH head 
rename hh_age_ hh_age 
rename hh_gender_ hh_gender
* Loop through the variables and create the corresponding head variables
foreach var in hh_age hh_gender hh_education_skills_bin hh_education_level_bin {
    * Create new variable for each
    gen `var'_h = . 
    
    * Replace the new variable with the value from the original variable if hh_relation_with_ == 1
    replace `var'_h = `var' if hh_relation_with_ == 1
}

** maybe use?? 

*drop hh_age_ hh_gender_ hh_education_skills_1_ hh_education_skills_2_ hh_education_skills_3_ hh_education_skills_4_ hh_education_skills_5_

** collaspe by mean at the household level 
 
collapse (mean) ///
	hh_age_h hh_education_level_bin_h hh_education_skills_bin_h hh_gender_h hh_numero ///
	hh_03_ hh_10_ hh_14_ hh_16_  health_5_2_ health_5_3_bin health_5_5_ health_5_6_ health_5_12 ///
	agri_6_15 agri_income_01 agri_income_05 montant_02 montant_05 face_04 face_13 ///
	hh_11_* hh_12_*  hh_13_* hh_15_* ///
    species_* ///
    living_01_bin living_04_bin living_05_bin ///
	enum_03_bin enum_04_bin enum_05_bin TLU, by(hhid hhid_village num_water_access_points)


/*
collapse (mean)  hh_age_resp hh_gender_ hh_age_ hh_03_ hh_10_ hh_14_ hh_16_ hh_29_* health_5_2_ health_5_5_ health_5_6_ agri_6_15 agri_income_01 agri_income_05 species_count montant_02 montant_05 face_04 face_13 ///
    (sum) hh_education_skills_1_ hh_education_skills_2_ hh_education_skills_3_ hh_education_skills_4_ hh_education_skills_5_ hh_education_level_* hh_11_* hh_12_1_ hh_12_2_ hh_12_3_ hh_12_4_ hh_12_5_ hh_12_6_ hh_12_7_ hh_12_8_ hh_13_01 hh_13_02 	   	hh_13_03 hh_13_04 hh_13_05 hh_13_06 hh_13_07 hh_13_08 hh_15_* ///
    health_5_3_ health_5_3_1_ health_5_3_2_ health_5_3_3_ health_5_3_4_ health_5_3_5_ health_5_3_6_ health_5_3_7_ health_5_3_8_ health_5_3_9_ health_5_3_10_ health_5_3_11_ health_5_3_12_ health_5_3_13_ health_5_3_14_  health_5_3_99_ ///
    species_1 species_2 species_3 species_4 species_5 species_6 species_7 species_8 species_9 ///
    living_01* living_03* living_04* living_05* enum_03* enum_04* enum_05*, by(hhid hhid_village)

*/

order hhid_village hhid hh_age_h hh_education_level_bin_h hh_education_skills_bin_h hh_gender_h hh_numero ///
	hh_03_ hh_10_ hh_14_ hh_16_  health_5_2_ health_5_3_bin health_5_5_ health_5_6_ health_5_12 ///
	agri_6_15 agri_income_01 agri_income_05 montant_02 montant_05 face_04 face_13 ///
	hh_11_* hh_12_*  hh_13_* hh_15_* ///
    species_* ///
    living_01_bin living_04_bin living_05_bin ///
	enum_03_bin enum_04_bin enum_05_bin
	
	
	* Label the variables
label variable num_water_access_points "Number of village water access points"
label variable hh_age_h "Household head age"
label variable hh_gender_h "Household head gender"
label variable hh_education_skills_bin_h "Indicator for household head education skills"
label variable hh_education_level_bin_h "Indicator for selected household head education level"
label variable hh_numero "Size of household"
label variable hh_03_ "Worked in domestic agricultural activities?"
label variable hh_10_ "Hours per week spent within 1 meter of surface water source"
label variable hh_11_ "Source(s) of surface water?"
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
label variable hh_16_ "Hours spent producing fertilizer, purchasing it, or applying it on the field"
label variable health_5_2_ "Has [Name] been ill last 12 months"
label variable health_5_3_bin "Indicator for bilharzia or diarrhea in the past 12 months"
label variable health_5_5_ "Received medication for the treatment of schistosomiasis?"
label variable health_5_6_ "Person ever been diagnosed with schistosomiasis?"
label variable health_5_12_ "What is the distance in km to this service or healthcare professional?"
label variable agri_6_15 "How many plots within the fields cultivated by the household?"
label variable agri_income_01 "Did you (or any member of your household) engage in paid agricultural work in the last 12 months?"
label variable agri_income_05 "Amount received in kind/cash for agricultural work"
label variable species_1 "Cattle"
label variable species_2 "Sheep"
label variable species_3 "Goat"
label variable species_4 "Horse (equine)"
label variable species_5 "Donkey"
label variable species_6 "Draft animals"
label variable species_7 "Pigs"
label variable species_8 "Poultry"
label variable species_9 "Other"
label variable TLU "Tropical livestock units"
label variable living_01_bin "Indicator for selected main source of drinking water"
label variable living_04_bin "Indicator for selected main type of toilet: Flush with sewer, Flush with septic tank"
label variable living_05_bin "Indicator for electricity as main cooking fuel"
label variable montant_02 "Amount paid by the respondent for game A: ________ FCFA"
label variable montant_05 "Amount paid by the respondent for game B: ________ FCFA"
label variable face_04 "Amount paid by the respondent for game B: ________ FCFA"
label variable face_13 "Amount paid by the respondent for game A: ________ FCFA"
label variable enum_03_bin "(Enumerator observation) Indicator if concrete/cement is main material for the house roof"
label variable species_count "Number of livestock"
label variable enum_05_bin "(Enumerator observation) Indicator if concrete/cement is main material for the house floor"

**************************************************** JUST PAP variables **********************************************

keep hhid_village hhid hh_age_h hh_education_level_bin_h hh_education_skills_bin_h hh_gender_h hh_numero ///

*drop if missing(hh_gender_) & missing(hh_age_)


********************************************************* Save the final dataset *********************************************************

save "${dataOutput}\baseline_balance_tables_data.dta", replace


