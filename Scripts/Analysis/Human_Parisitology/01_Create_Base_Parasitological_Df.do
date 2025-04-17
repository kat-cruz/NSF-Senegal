*==============================================================================
* Program: human paristological dataframe
* ==============================================================================
* written by: Alex Mills
* Altered by: Kateri Mouawad 
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
		* 1) To update
		
	clear all
	set mem 100m
	set maxvar 30000
	set matsize 11000
	set more off

*<><<><><>><><<><><>>	
* SET FILE PATHS
*<><<><><>><><<><><>>	

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
	global clean_data  "${partner_clean}\Parasitological_Data\Child_Matches"
	global output "${master}\Data_Management\Output\Analysis\Parasitological_Analysis_Data\Analysis_Data"

***Version Control:

global date = strofreal(date(c(current_date),"DMY"), "%tdYYNNDD")
	clear
	
*<><<><><>><><<><><>>	
* LOAD IN RAW UCAD/EPLS PARASITOLOGICAL DATA
*<><<><><>><><<><><>>	

import excel "${raw_data}\UCAD & EPLS parasitological data.xlsx", sheet("Sheet1") firstrow

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


* Drop observations with missing identificant
		drop if missing(identificant)

* Save this as a temporary file
		save "temp_epls_data.dta", replace

* Load back the original dataset
		use "${output}\01_base_infection_df.dta", clear

* Merge with the EPLS/UCAD data
		*merge 1:1 identificant using "temp_epls_data.dta", update
				merge 1:1 identificant using "temp_epls_data.dta"

* Clean up
		erase "temp_epls_data.dta"

* Check merge results
		tab _merge

	rename identificant epls_ucad_id

		order village_id village_name hhid_crdes individual_id_crdes match_score sex_crdes age_crdes sex_epls_ucad age_epls_ucad epls_ucad_result epls_or_ucad epls_ucad_id sex_hp age_hp fu_p1 omega_vivant_1 sm_fu_1 fu_p2 omega_vivant_2 sm_fu_2 p1_kato1_omega p1_kato1_k1_pg pq_kato2_omega p1_kato2_k2_peg sh_kk_1 p2_kato1_omega p2_kato1_k1_epg p2_kato2_omega p2_kato2_k2_epg sh_kk_2 pzq_1 pzq_2 data_source _merge
		


		save "${output}\01_prepped_inf_matches_df.dta", replace





