*==============================================================================
* Program: balance tables data tranformation
* ==============================================================================
* written by: Kateri Mouawad
* additions made by: Kateri Mouawad
* Created: December 2024
* Updates recorded in GitHub 

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
if "`c(username)'"=="socrm" global box_path "C:\Users\socrm\Box"
if "`c(username)'"=="kls329" global box_path "C:\Users\kls329\Box"
if "`c(username)'"=="km978" global box_path "C:\Users\km978\Box\NSF Senegal"
if "`c(username)'"=="Kateri" global box_path "C:\Users\Kateri\Box\NSF Senegal"
if "`c(username)'"=="admmi" global box_path "C:\Users\admmi\Box"

if "`c(username)'"=="km978" global git_path "C:\Users\Kateri\Downloads\GIT-Senegal\NSF-Senegal"
if "`c(username)'"=="Kateri" global git_path "C:\Users\km978\Downloads\GIT-Senegal\NSF-Senegal"



* Define project-specific paths

global data "${box_path}\Data Management\_CRDES_CleanData\Baseline\Deidentified"

***** Data folders *****
global dataOutput "${box_path}\Data Management\Output\Data Analysis" 
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


*** Version Control: ***
global date = strofreal(date(c(current_date),"DMY"), "%tdYYNNDD")



********************************************************* Keep relevant variables *********************************************************


keep hhid hhid_village ///
     hh_gender* hh_age* ///
     hh_education_skills* hh_education_level* hh_education_year_achieve* ///
     hh_numero* hh_03* hh_10* hh_11* hh_12* hh_13* ///
     hh_14* hh_15* hh_16* hh_29* ///
     health_5_2* health_5_3* health_5_5* health_5_6* health_5_7* ///
     agri_6_15* species* agri_income_05* ///
     living_01* living_03* living_04* living_05* ///
     montant_02* montant_05* ///
     face_04* face_13* ///
     enum_03* enum_04* enum_05*


********************************************************* Drop unecessary variables *********************************************************



// Drop variables with numbered suffixes (1 to 55) for specific patterns
forval i = 1/55 {
    drop hh_education_skills_`i' hh_12_`i' health_5_3_`i'
}

// Drop variables matching specific patterns
drop hh_12_o* hh_12_a* hh_13_s* hh_13_o*  ///
     living_01_o living_03_o living_04_o living_05_o ///
     enum_03_o enum_04_o enum_05_o species_o ///
	hh_12_r* hh_12name_* hh_12_calc_* hh_12index_* hh_education_level_o_* ///
     hh_11_o_* hh_education_skills_0_* hh_15_o_* hh_gender_res* hh_29_o* health_5_3_o* ///
	 speciesindex* species_autre speciesname*


* Reshape long with hhid and id
forval i = 1/7 {
    // Loop over the second index (1 to 55)
    forval j = 1/55 {
        // Construct the old and new variable names
        local oldname = "hh_13_`j'_`i'"
        local newname = "hh_13_`i'_`j'"
        
        // Rename if the old variable exists
        cap rename `oldname' `newname'
    }
}

********************************************************* Reshape the data *********************************************************


	
	reshape long hh_gender_ hh_age_ hh_education_skills_1_ hh_education_skills_2_ hh_education_skills_3_ hh_education_skills_4_ hh_education_skills_5_ health_5_3_1_ health_5_3_2_ health_5_3_3_ health_5_3_4_ health_5_3_5_ health_5_3_6_ health_5_3_7_ health_5_3_8_ health_5_3_9_ health_5_3_10_ health_5_3_11_ health_5_3_12_ health_5_3_13_ health_5_3_14_ health_5_3_15_ health_5_3_99_ hh_education_level_ hh_education_year_achieve_ ///
hh_number_ hh_03_ hh_10_ hh_11_ hh_12_1_ hh_12_2_ hh_12_3_ hh_12_4_ hh_12_5_ hh_12_6_ hh_12_7_ hh_12_8_ hh_13_1_ hh_13_2_ hh_13_3_ hh_13_4_ hh_13_5_ hh_13_6_ hh_13_7_ hh_14_ hh_15_ hh_16_ hh_29_ health_5_2_ ///
health_5_3_ health_5_5_ health_5_6_ health_5_7_, i(hhid) j(id)



********************************************************* Reorder the variables *********************************************************
drop id species health_5_3_ hh_number_

order hhid hhid_village hh_numero hh_age_resp hh_gender_ hh_age_ hh_education_skills_1_ hh_education_skills_2_ hh_education_skills_3_ hh_education_skills_4_ hh_education_skills_5_ hh_education_level_ hh_education_year_achieve_ hh_03_ hh_10_ hh_11_ hh_12_1_ hh_12_2_ hh_12_3_ hh_12_4_ hh_12_5_ hh_12_6_ hh_12_7_ hh_12_8_ hh_13_1_ hh_13_2_ hh_13_3_ hh_13_4_ hh_13_5_ hh_13_6_ hh_13_7_ hh_14_ hh_15_ hh_16_ hh_29_ health_5_2_ health_5_3_1_ health_5_3_2_ health_5_3_3_ health_5_3_4_ health_5_3_5_ health_5_3_6_ health_5_3_7_ health_5_3_8_ health_5_3_9_ health_5_3_10_ health_5_3_11_ health_5_3_12_ health_5_3_13_ health_5_3_14_ health_5_3_15_ health_5_3_99_ health_5_5_ health_5_6_ health_5_7_ agri_6_15 agri_income_05 species_1 species_2 species_3 species_4 species_5 species_6 species_7 species_8 species_9 species_count living_01 living_03 living_04 living_05 montant_02 montant_05 face_04 face_13 enum_03 enum_04 enum_05



********************************************************* Save the final dataset *********************************************************

export delimited using "${dataOutput}\baseline_balance_tables_data.csv", replace


