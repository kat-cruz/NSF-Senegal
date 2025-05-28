*==============================================================================
* Program: human paristological dataframe
* ==============================================================================
* written by: Alex Mills
* Altered by: Kateri Mouawad 
* Created: October 2024
* Updates recorded in GitHub

*<><<><><>><><<><><>>	
** Read Me <><<><><>>
*<><<><><>><><<><><>>	

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
		* 1) To update
		
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
	global raw_data  "${partner_raw}\Parasitological_Data"
	global clean_data  "${partner_clean}\Parasitological_Data"
	global output "${master}\Data_Management\Output\Analysis\Human_Parasitology\Analysis_Data"
	
***Version Control:

global date = strofreal(date(c(current_date),"DMY"), "%tdYYNNDD")
	clear
	
*-----------------------------------------*
**##Clean scored data 
*-----------------------------------------*

	** This does contain baseline data. Remove those variables to maintain matched IDs across the data sets. 

	import excel "${clean_data}\Child_Matches_Dataset.xlsx", firstrow clear
	
	** keep variables that shouldn't change between baseline and midline 
	
		keep VillageID Villagename HHIDCRDES IndividualIDCRDES MatchScore EPLSorUCADID 

	** Clean up the variable names 
		rename VillageID hhid_village
		rename Villagename village_name
		rename HHIDCRDES hhid
		rename IndividualIDCRDES individ
		rename MatchScore match_score
		rename EPLSorUCADID identificant

			drop if missing(individ) & missing(hhid) & missing(match_score) 
	
				save "${output}\child_matched_IDs_df", replace
				
			
*<><<><><>><><<><><>>	
**# Baseline Cleaning
*<><<><><>><><<><><>>	

*-----------------------------------------*
**## Load data
*-----------------------------------------*


	import excel "${raw_data}\Baseline UCAD & EPLS parasitological data.xlsx", sheet("Sheet1") firstrow clear

*-----------------------------------------*
**### Create village name variable
*-----------------------------------------*

** Clean leading/trailing spaces from identificant
	replace identificant = strtrim(identificant)

** Create new variables for village name and village ID
	gen village_name = ""
	gen village_id = ""
	
** Prioritize UCAD/UGB villages: Extract from the first two characters like DL/00/36, DP/00/36, SO/00/36
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
	
*-----------------------------------------*
**### Create data_source name variable
*-----------------------------------------*

** Create a new variable for data source: 1 = UCAD/UGB, 0 = EPLS
	gen data_source = .

** Prioritize UCAD/UGB villages for data_source
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

** Assign remaining villages (i.e., EPLS) as 0
	replace data_source = 0 if data_source == .

** Label the variable for clarity
	label define source_label 0 "EPLS" 1 "UCAD/UGB"
	label values data_source source_label
	
*-----------------------------------------*
**### Rename & order 
*-----------------------------------------*

** Rename variables to coresspond with variable name mapping in the Construction protocol

	rename p1_kato2_k2_peg p1_kato2_k2_epg
	rename p1_kato1_k1_pg p1_kato1_k1_epg
	rename pq_kato2_omega p1_kato2_omega
	rename village_id hhid_village
	
	order hhid_village village_name identificant sex_hp age_hp fu_p1 omega_vivant_1 sm_fu_1 fu_p2 omega_vivant_2 sm_fu_2 p1_kato1_omega p1_kato1_k1_epg p1_kato2_omega p1_kato2_k2_epg sh_kk_1 p2_kato1_omega p2_kato1_k1_epg p2_kato2_omega p2_kato2_k2_epg sh_kk_2 pzq_1 pzq_2 data_source 
	
** First, save the current dataset
		save "${output}\01_baseline_paras_df", replace
		
/* 
*-----------------------------------------*
**### Merge in with child matched df
*-----------------------------------------*
		
** Brind in Child Matched data frame to link to CRDES data 

				merge 1:1 identificant using "${output}\child_matched_IDs_df", nogen 

		order hhid_village village_name hhid individ match_score identificant sex_hp age_hp fu_p1 omega_vivant_1 sm_fu_1 fu_p2 omega_vivant_2 sm_fu_2 p1_kato1_omega p1_kato1_k1_epg p1_kato2_omega p1_kato2_k2_epg sh_kk_1 p2_kato1_omega p2_kato1_k1_epg p2_kato2_omega p2_kato2_k2_epg sh_kk_2 pzq_1 pzq_2 data_source 
		
*-----------------------------------------*
**### save prepped infection df 
*-----------------------------------------*
		save "${output}\01.1_baseline_paras_matches_df.dta", replace
*/

		
*<><<><><>><><<><><>>	
**# Midline Cleaning
*<><<><><>><><<><><>>	

*-----------------------------------------*
**## Load data
*-----------------------------------------*

	use  "${raw_data}\complete_midline_parasitology_df.dta", clear
	
*-----------------------------------------*
**### Create village name variable
*-----------------------------------------*

* Clean leading/trailing spaces from identificant
		replace identificant = strtrim(identificant)

	gen village_name = ""

		replace village_name = "Ndiamar (SO)" if hhid_village  == "020A"
		replace village_name = "Diabobes (DI)" if hhid_village  == "030B"
		replace village_name = "Diaminar Loyene (DL)" if hhid_village  == "022A"
		replace village_name = "Dioss Peulh (DP)" if hhid_village  == "032A"
		replace village_name = "Dodel (DO)" if hhid_village  == "072B"
		replace village_name = "Maraye (MA)" if hhid_village  == "021A"
		replace village_name = "Fanaye Diery (FD)" if hhid_village  == "062B"
		replace village_name = "Gueo (GU)" if hhid_village  == "033A"
		replace village_name = "Kassak Nord (KA)" if hhid_village  == "030A"
		replace village_name = "Mberaye (MB)" if hhid_village  == "023B"
		replace village_name = "Ndiamar (SL)" if hhid_village  == "020A"
		replace village_name = "Ndiayene Pendao (NP)" if hhid_village  == "020B"
		replace village_name = "Saneinte Tacque (SA)" if hhid_village  == "031B"
		replace village_name = "Thiangaye (TH)" if hhid_village  == "021B"
		replace village_name = "Yamane (YA)" if hhid_village  == "130A"
		replace village_name = "Yetti Yoni (YY)" if hhid_village  == "033B"
		replace village_name = "Assy (AB)" if hhid_village  == "011A"
		replace village_name = "Diaminar Keur Kane (DK)" if hhid_village  == "012B"
		replace village_name = "Gueum Yalla (GY)" if hhid_village  == "010B"
		replace village_name = "Keur Birane Kobar (KB)" if hhid_village  == "010A"
		replace village_name = "Mbilor (MR)" if hhid_village  == "012A"
		replace village_name = "Minguene Boye (MI)" if hhid_village  == "013B"
		replace village_name = "Ndelle Boye (NB)" if hhid_village  == "013A"
		replace village_name = "Ndiakhaye (NK)" if hhid_village  == "011B"
		replace village_name = "Thilla (TB)" if hhid_village  == "023A"
		replace village_name = "Mbakhana (MB)" if hhid_village  == "122A"
		replace village_name = "Mbarigo (MO)" if hhid_village  == "123A"
		replace village_name = "Foss (FS)" if hhid_village  == "121B"
		replace village_name = "Malla (MA)" if hhid_village  == "131B"
		replace village_name = "Syer (ST)" if hhid_village  == "120B"

*-----------------------------------------*
**### Create data_source name variable
*-----------------------------------------*		
** Prioritize UCAD/UGB villages for data_source
	
	gen data_source = 0

		replace data_source = 1 if inlist(hhid_village, ///
			"020A", "030B", "022A", "032A", "072B")

		replace data_source = 1 if inlist(hhid_village, ///
			"021A", "062B", "033A", "030A", "023B")

		replace data_source = 1 if inlist(hhid_village, ///
			"020B", "031B", "021B", "130A", "033B")


	* Assign remaining villages (i.e., EPLS) as 0
		replace data_source = 0 if data_source == .

		* Label the variable for clarity
		label define source_label 0 "EPLS" 1 "UCAD/UGB"
		label values data_source source_label

		drop if missing(identificant)
		* drop children who dropped from baseline or midline data 
		drop if missing(age_hp) & missing(sex_hp)

*-----------------------------------------*
**### Order and save infection df
*-----------------------------------------*
		
		order hhid_village village_name numero initiales identificant grade sex_hp age_hp fu_p1 omega_vivant_1 sm_fu_1 fu_p2 omega_vivant_2 sm_fu_2 p1_kato1_omega p1_kato1_k1_epg p1_kato2_omega p1_kato2_k2_epg sh_kk_1 p2_kato1_omega p2_kato1_k1_epg p2_kato2_omega p2_kato2_k2_epg sh_kk_2 pzq_1 pzq_2 data_source 
		
				save "${output}\01_midline_paras_df", replace
				
/* 
		
*-----------------------------------------*
**### Merge in with child matched df
*-----------------------------------------*
			
	merge m:m identificant using "${output}\child_matched_IDs_df", nogen 

		
*-----------------------------------------*
**### Rename & order 
*-----------------------------------------*
		drop numero
	
		order hhid_village village_name hhid individ identificant initiales match_score sex_hp age_hp grade fu_p1 omega_vivant_1 sm_fu_1 fu_p2 omega_vivant_2 sm_fu_2 p1_kato1_omega p1_kato1_k1_epg p1_kato2_omega p1_kato2_k2_epg sh_kk_1 p2_kato1_omega p2_kato1_k1_epg p2_kato2_omega p2_kato2_k2_epg sh_kk_2 pzq_1 pzq_2 data_source 
		
		
*-----------------------------------------*
**### save prepped infection df 
*-----------------------------------------*	

	save "${output}\01.1_midline_paras_matches_df.dta", replace
	
*/
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	