*==============================================================================
* Program: human paristological dataframe
* ==============================================================================

* written by: Alex Mills
* additions made by: Kateri Mouawad (KRM), Molly Doruska (MJD)
* Created: October 2024
* Updates recorded in GitHub


* <><<><><>> Read Me  <><<><><>>
** General notes:
 * individual_id_crdes variable is created here which replicates the individual IDs made in the Individual_Level_IDs.do file
 * hh_13 are just indicies - the variable needs to be filtered (as seen at line 337)


       ** This .do file processes: 
				* DISES UCAD paristological data.xlsx
				* Child_Matches_Dataset
				* child_infections.dta
				* Complete_Baseline_Health.dta
				* Complete_Baseline_Household_Roster.dta
				* Complete_Baseline_Standard_Of_Living.dta
				* Complete_Baseline_Agriculture.dta
				* Complete_Baseline_Community.dta
				* DISES_baseline_ecological data.dta
				
	  ** This .do file outputs:
				
				* child_infections.dta
				* child_infection_dataframe
				* temp_epls_data.dta
				* temp_features_reshaped.dta
				* base_child_infection_dataframe.dta
		
 *** Run the following:
		* 1) 
		
		
		
		

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


* Define project-specific paths
global partner_raw "${master}\Data_Management\Data\_Partner_RawData"
global partner_clean "${master}\Data_Management\Data\_Partner_CleanData"

global crdes_data "${master}\Data_Management\Data\_CRDES_CleanData"
global eco_data "${master}\Data_Management\Data\_Partner_RawData\Ecological_Data\Baseline"


***** Global folders *****
global raw_data  "${partner_raw}\UCAD_Data"
global clean_data  "${partner_clean}\Child_Matches"
global output "${master}\Data_Management\Output\Analysis\Parasitological_Analysis_Data\Analysis_Data"

***Version Control:

global date = strofreal(date(c(current_date),"DMY"), "%tdYYNNDD")

clear

import excel "${raw_data}\DISES UCAD paristological data.xlsx", sheet("Sheet1") firstrow


* Clean leading/trailing spaces from identificant
replace identificant = strtrim(identificant)

* Create new variables for village name and village ID
gen village_name = ""
gen village_id = ""

* Prioritize UCAD/UGB villages: Extract from the first two characters like DL/00/36, DP/00/36, SO/00/36
	replace village_name = "Ndiamar (SO)" if substr(identificant, 1, 2) == "SO"
	replace village_id = "020A" if substr(identificant, 1, 2) == "SO"

	replace village_name = "Diabobes (DI)" if substr(identificant, 1, 2) == "DI"
	replace village_id = "030B" if substr(identificant, 1, 2) == "DI"

	replace village_name = "Diaminar Loyene (DL)" if substr(identificant, 1, 2) == "DL"
	replace village_id = "022A" if substr(identificant, 1, 2) == "DL"

	replace village_name = "Dioss Peulh (DP)" if substr(identificant, 1, 2) == "DP"
	replace village_id = "032A" if substr(identificant, 1, 2) == "DP"

	replace village_name = "Dodel (DO)" if substr(identificant, 1, 2) == "DO"
	replace village_id = "072B" if substr(identificant, 1, 2) == "DO"

	replace village_name = "Maraye (MA)" if substr(identificant, 1, 2) == "MA"
	replace village_id = "021A" if substr(identificant, 1, 2) == "MA"

	replace village_name = "Fanaye Diery (FD)" if substr(identificant, 1, 2) == "FD"
	replace village_id = "062B" if substr(identificant, 1, 2) == "FD"

	replace village_name = "Gueo (GU)" if substr(identificant, 1, 2) == "GU"
	replace village_id = "033A" if substr(identificant, 1, 2) == "GU"

	replace village_name = "Kassak Nord (KA)" if substr(identificant, 1, 2) == "KA"
	replace village_id = "030A" if substr(identificant, 1, 2) == "KA"

	replace village_name = "Mberaye (MB)" if substr(identificant, 1, 2) == "MB"
	replace village_id = "023B" if substr(identificant, 1, 2) == "MB"

	replace village_name = "Ndiamar (SL)" if substr(identificant, 1, 2) == "SL"
	replace village_id = "020A" if substr(identificant, 1, 2) == "SL"

	replace village_name = "Ndiayene Pendao (NP)" if substr(identificant, 1, 2) == "NP"
	replace village_id = "020B" if substr(identificant, 1, 2) == "NP"

	replace village_name = "Saneinte Tacque (SA)" if substr(identificant, 1, 2) == "SA"
	replace village_id = "031B" if substr(identificant, 1, 2) == "SA"

	replace village_name = "Thiangaye (TH)" if substr(identificant, 1, 2) == "TH"
	replace village_id = "021B" if substr(identificant, 1, 2) == "TH"

	replace village_name = "Yamane (YA)" if substr(identificant, 1, 2) == "YA"
	replace village_id = "130A" if substr(identificant, 1, 2) == "YA"

	replace village_name = "Yetti Yoni (YY)" if substr(identificant, 1, 2) == "YY"
	replace village_id = "033B" if substr(identificant, 1, 2) == "YY"

* Now handle EPLS villages: Extract based on positions like 3/MR/2/31
	replace village_name = "Assy (AB)" if substr(identificant, 3, 2) == "AB"
	replace village_id = "011A" if substr(identificant, 3, 2) == "AB"

	replace village_name = "Diaminar Keur Kane (DK)" if substr(identificant, 3, 2) == "DK"
	replace village_id = "012B" if substr(identificant, 3, 2) == "DK"

	replace village_name = "Gueum Yalla (GY)" if substr(identificant, 3, 2) == "GY"
	replace village_id = "010B" if substr(identificant, 3, 2) == "GY"

	replace village_name = "Keur Birane Kobar (KB)" if substr(identificant, 3, 2) == "KB"
	replace village_id = "010A" if substr(identificant, 3, 2) == "KB"
	// Some KB are coded as BK
	replace village_name = "Keur Birane Kobar (KB)" if substr(identificant, 3, 2) == "BK"
	replace village_id = "010A" if substr(identificant, 3, 2) == "BK"

	replace village_name = "Mbilor (MR)" if substr(identificant, 3, 2) == "MR"
	replace village_id = "012A" if substr(identificant, 3, 2) == "MR"

	replace village_name = "Minguene Boye (MI)" if substr(identificant, 3, 2) == "MI"
	replace village_id = "013B" if substr(identificant, 3, 2) == "MI"

	replace village_name = "Ndelle Boye (NB)" if substr(identificant, 3, 2) == "NB"
	replace village_id = "013A" if substr(identificant, 3, 2) == "NB"

	replace village_name = "Ndiakhaye (NK)" if substr(identificant, 3, 2) == "NK"
	replace village_id = "011B" if substr(identificant, 3, 2) == "NK"

	replace village_name = "Thilla (TB)" if substr(identificant, 3, 2) == "TB"
	replace village_id = "023A" if substr(identificant, 3, 2) == "TB"

	replace village_name = "Mbakhana (MB)" if substr(identificant, 3, 2) == "MB"
	replace village_id = "122A" if substr(identificant, 3, 2) == "MB"

	replace village_name = "Mbarigo (MO)" if substr(identificant, 3, 2) == "MO"
	replace village_id = "123A" if substr(identificant, 3, 2) == "MO"

	replace village_name = "Foss (FS)" if substr(identificant, 3, 2) == "FS"
	replace village_id = "121B" if substr(identificant, 3, 2) == "FS"

	replace village_name = "Malla (MA)" if substr(identificant, 3, 2) == "MA"
	replace village_id = "131B" if substr(identificant, 3, 2) == "MA"

	replace village_name = "Syer (ST)" if substr(identificant, 3, 2) == "ST"
	replace village_id = "120B" if substr(identificant, 3, 2) == "ST"

* Create a new variable for data source: 1 = UCAD/UGB, 0 = EPLS
gen data_source = .

* Prioritize UCAD/UGB villages for data_source
replace data_source = 1 if substr(identificant, 1, 2) == "SO" | ///
							 substr(identificant, 1, 2) == "DI" | ///
							 substr(identificant, 1, 2) == "DL" | ///
							 substr(identificant, 1, 2) == "DP" | ///
                             substr(identificant, 1, 2) == "DO" | ///
                             substr(identificant, 1, 2) == "MA" | ///
                             substr(identificant, 1, 2) == "FD" | ///
                             substr(identificant, 1, 2) == "GU" | ///
                             substr(identificant, 1, 2) == "KA" | ///
                             substr(identificant, 1, 2) == "MB" | ///
                             substr(identificant, 1, 2) == "SL" | ///
                             substr(identificant, 1, 2) == "NP" | ///
                             substr(identificant, 1, 2) == "SA" | ///
                             substr(identificant, 1, 2) == "TH" | ///
                             substr(identificant, 1, 2) == "YA" | ///
                             substr(identificant, 1, 2) == "YY"

* Assign remaining villages (i.e., EPLS) as 0
replace data_source = 0 if data_source == .

* Label the variable for clarity
label define source_label 0 "EPLS" 1 "UCAD/UGB"
label values data_source source_label

* First, save the current dataset
save "${output}\01_base_infection_df", replace

* Import the Excel file
import excel "${clean_data}\Child_Matches_Dataset.xlsx", firstrow clear


* Clean up the variable names 
	rename VillageID village_id
	rename Villagename village_name
	rename HHIDCRDES hhid_crdes
	rename IndividualIDCRDES individual_id_crdes
	rename MatchScore match_score
	rename SexCRDES sex_crdes
	rename AgeCRDES age_crdes
	rename EPLSorUCADID identificant
	rename SexEPLSorUCAD sex_epls_ucad
	rename AgeEPLSorUCAD age_epls_ucad
	rename EPLSorUCADResult epls_ucad_result
	rename EPLS1orUCAD2 epls_or_ucad

****************** Update by KRM: fix mismatched child IDs ****************************
** Updated Nov 11, 2024 

* I also went and updated these mannually to the OG df that Alex is using so I'm leaving this here just for record. 
/*
replace individual_id_crdes = "120B0608" if individual_id_crdes == "120B1608"
replace individual_id_crdes = "121B0308" if individual_id_crdes == "121B0408"
replace individual_id_crdes = "121B0309" if individual_id_crdes == "121B0409"
replace individual_id_crdes = "123A1113" if individual_id_crdes == "123A0713"
*above ID already existed so needed to update other match
replace individual_id_crdes = "123A1413" if individual_id_crdes == "123A1113"
replace individual_id_crdes = "123A0211" if individual_id_crdes == "123A1811"
replace individual_id_crdes = "131B0707" if individual_id_crdes == "131B0607"
replace individual_id_crdes = "131B0307" if individual_id_crdes == "131B0807"
*/

*************************************************************************************
* Drop observations with missing identificant
drop if missing(identificant)

* Save this as a temporary file
save "temp_epls_data.dta", replace

* Load back the original dataset
use "${output}\01_base_infection_df.dta", clear

* Merge with the EPLS/UCAD data
merge 1:1 identificant using "temp_epls_data.dta", update

* Clean up
erase "temp_epls_data.dta"

* Check merge results
tab _merge

rename identificant epls_ucad_id

order village_id village_name hhid_crdes individual_id_crdes match_score sex_crdes age_crdes sex_epls_ucad age_epls_ucad epls_ucad_result epls_or_ucad epls_ucad_id sex_hp age_hp fu_p1 omega_vivant_1 sm_fu_1 fu_p2 omega_vivant_2 sm_fu_2 p1_kato1_omega p1_kato1_k1_pg pq_kato2_omega p1_kato2_k2_peg sh_kk_1 p2_kato1_omega p2_kato1_k1_epg p2_kato2_omega p2_kato2_k2_epg sh_kk_2 pzq_1 pzq_2 data_source _merge

*drop sex_epls_ucad age_epls_ucad epls_ucad_result _merge

save "${output}\01_prepped_inf_matches_df.dta", replace

/*
* Load and prep health data
use "${crdes_data}\Baseline\Deidentified\Complete_Baseline_Health.dta", clear

* Keep necessary health variables
*keep hhid health_5_3_2_* health_5_4_* health_5_5_* health_5_6_* health_5_7_* health_5_8_* health_5_9_* health_5_10_* 

*use  "${crdes}\Baseline\Deidentified\Complete_Baseline_Household_Roster.dta", clear 
*** keep additional variables that may be useful  ***
* 	hh_11 = which water source 
* 	hh_12 = why person spent time near water source 
* 	hh_33 = performace in class
* 	hh_37 = had illness last 12 months
* 	living_01 = source of drinking water 
* 	living_02 = is the water treated 
* 	living_03 = if so, how 
* 	living_04 = main type of toilet used

* bring in other dfs with the relevent variables 

merge 1:1 hhid using "${crdes_data}\Baseline\Deidentified\Complete_Baseline_Household_Roster.dta"
drop _merge

merge 1:1 hhid using "${crdes_data}\Baseline\Deidentified\Complete_Baseline_Standard_Of_Living.dta"
drop _merge 

merge 1:1 hhid using "${crdes_data}\Baseline\Deidentified\Complete_Baseline_Agriculture.dta"
drop _merge
 
*include community data
merge m:1 hhid_village using "${crdes_data}\Baseline\Deidentified\Complete_Baseline_Community.dta"
drop _merge 

*use "${crdes}\Baseline\Deidentified\Complete_Baseline_Community.dta", clear 

* include ecological data
merge m:1 hhid_village using "${eco_data}\DISES_baseline_ecological data.dta"



	keep hhid hh_age_resp hh_age* hh_gender* hh_ethnicity_* ///
		health_5_3_2_* health_5_4_* health_5_5_* health_5_6_* health_5_8_* health_5_9_* health_5_10_* ///
		hh_10_* hh_12_* hh_13_* hh_18_* hh_19_* hh_22_* hh_26_* hh_29_* hh_30_* hh_31_* hh_32_* hh_33_* hh_37_* ///
		living_01 living_02 living_03 living_04 ///
		list_actifscount list_actifs* ///
		q_18 q_19 q_23 q_24 q_35_check q_39 q_49 q_46 q_51 ///
		Cerratophyllummassg Bulinus Biomph Humanwatercontact BegeningTimesampling Endsamplingtime Schistoinfection InfectedBulinus  InfectedBiomphalaria schisto_indicator 
	 
*drop strings 
drop hh_12_o* hh_12_a* hh_12_ro* hh_12_cal* hh_13_o* hh_13_s* hh_19_o* hh_ethnicity_o* hh_29_o* list_actifs_o 

foreach i of numlist 1/55 {
    drop hh_12_`i'
}


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




*variables removed: hh_age hh_gender living_01 living_02 living_03 living_04

* Reshape long with hhid and id
	reshape long health_5_3_2_ health_5_4_ health_5_5_ health_5_6_  health_5_8_ health_5_9_ health_5_10_ hh_ethnicity_  hh_10_  ///
	hh_12index_1_ hh_12index_2_ hh_12index_3_ hh_12index_4_ hh_12index_5_ hh_12index_6_ hh_12index_7_ hh_12_1_ hh_12_2_ hh_12_3_ hh_12_4_ hh_12_5_ hh_12_6_ hh_12_7_ hh_12_8_ ///
	hh_13_1_ hh_13_2_ hh_13_3_ hh_13_4_ hh_13_5_ hh_13_6_ hh_13_7_ hh_18_ hh_19_ hh_22_ hh_26_ hh_29_ hh_30_ hh_31_ hh_32_ hh_33_ hh_37_ hh_age_ hh_gender_, ///
		i(hhid) j(id)
	
	 
** filter hh_13 **

forvalues j = 1/8 {
    gen hh_13_0`j' = .
    forvalues i = 1/7 {
        replace hh_13_0`j' = hh_13_`i'_ if hh_12index_`i' == `j'
    }
}


drop hh_13_7_ hh_13_6_ hh_13_5_ hh_13_4_ hh_13_3_ hh_13_2_ hh_13_1_ 
drop hh_12index_7_ hh_12index_6_ hh_12index_5_ hh_12index_4_ hh_12index_3_ hh_12index_2_ hh_12index_1_



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
		destring fu_p1 fu_p2 p1_kato1_k1_pg p1_kato2_k2_peg p2_kato1_k1_epg p2_kato2_k2_epg, replace force 

		*** count infection of s. haematobium *** 
		gen sh_inf = 0 
		replace sh_inf = 1 if fu_p1 > 0 & fu_p1 != .
		replace sh_inf = 1 if fu_p2 > 0 & fu_p2 != . 

		gen sm_inf = 0 
		replace sm_inf = 1 if p1_kato1_k1_pg > 0 & p1_kato1_k1_pg != . 
		replace sm_inf = 1 if p1_kato2_k2_peg > 0 & p1_kato2_k2_peg != . 
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
		schisto_indicator fu_p1 fu_p2 omega_vivant_1 sm_fu_1 fu_p2 omega_vivant_2 sm_fu_2 p1_kato1_omega p1_kato1_k1_pg pq_kato2_omega p1_kato2_k2_peg sh_kk_1 p2_kato1_omega p2_kato1_k1_epg p2_kato2_omega p2_kato2_k2_epg sh_kk_2 sh_inf sm_inf pzq_1 		pzq_2 ///
	    Cerratophyllummassg Bulinus Biomph Humanwatercontact BegeningTimesampling Endsamplingtime Schistoinfection InfectedBulinus InfectedBiomphalaria


* Save the final dataset

save "${output}\base_child_infection_dataframe.dta", replace

*/



