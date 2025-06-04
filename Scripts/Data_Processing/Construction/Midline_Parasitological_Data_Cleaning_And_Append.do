*-----------------------------------------*
* written by: Kateri Mouawad
* Created: February 2025
* Updates recorded in GitHub
*-----------------------------------------*
* <><<><><>> Read Me  <><<><><>>


		*** This .do file processes:
									* DISES UCAD.UGB.1_VILLAGES.PARASITOLOGY DATA ALL VILLAGES.controled_1_25.06.24.xlsx
									* Dises year 2_fusion final_3_08042025.UCAD.UGB.xlsx

		*** This .do file outputs: 
		
			**			thiangaye_021B_midline_df.dta
			**			ndiayene_pendao_020B_midline_df.dta
			**			geuo_033A_midline_df.dta
			**			dodel_072B_midline_df.dta
			**			diabobe_030B_midline_df.dta
			**			yetti_yone_033B_midline_df.dta
			**			yamane_130A_midline_df.dta
			**			saneinte_031B_midline_df.dta
			**			ndiamar_020A_midline_df.dta
			**			kassack_nord_030A_midline_df.dta
			**			fanaye_diery_062B_midline_df.dta
			**			diaminar_loyene_022A_midline_df.dta
			**			mberaye_023B_midline_df.dta
			**			el_debiyaye_maraye_021A_midline_df.dta
			**			dioss_peulh_032A_midline_df.dta
			**			complete_midline_ucad_parasitology_df.dta
			**			thilla_023A_midline_df.dta
			**			syer_120B_midline_df.dta
			**			ndiakhaye_011B_midline_df.dta
			**			ndelle_boye_013A_midline_df.dta
			**			minguene_boye_013B_midline_df.dta
			**			mbilor_012A_midline_df.dta
			**			mbarigo_123A_midline_df.dta
			**			mbakhana_122A_midline_df.dta
			**			malla_131B_midline_df.dta
			**			keur_birane_kobar_010A_midline_df.dta
			**			gueum_yalla_010B_midline_df.dta
			**			foss_121B_midline_df.dta
			**			diaminar_012B_midline_df.dta
			**			complete_midline_epls_parasitology_df.dta
			**			assy_011A_midline_df.dta
			** 			complete_midline_parasitology_df
			**			complete_midline_parasitology_df.xlsx

						
								
		*** PROCEDURE:
		*	 This .do file simply puts the UCAD/EPLS data into a .dta format with variable names and labels for both baseline and midline data. Will update to include endline data. 
		
				* 1) Import raw UCAD/EPLS data by village 
				* 2) rename variables
				* 3) drop empty/irralavent rows
				* 4) label variables
				* 5) Generate village ID
				* 6) Move any notes in paras variables to the note column 
				* 5) save .dta
				
		**** NOTE:
		
		** 	EPLS stored age in the consent forms in midline. I grabbed age in each consent form and merged it to the paras data frame.

*<><<><><>><><<><><>>
**# INITIATE SCRIPT
*<><<><><>><><<><><>>
		
	clear all
		set mem 100m
		set maxvar 30000
	set matsize 11000
	set more off

*<><<><><>><><<><><>>
* SET FILE PATHS
*<><<><><>><><<><><>>

*^*^* Set base Box path for each user

	if "`c(username)'"=="socrm" global master "C:\Users\socrm\Box\NSF Senegal"
	if "`c(username)'"=="kls329" global master "C:\Users\kls329\Box\NSF Senegal"
	if "`c(username)'"=="km978" global master "C:\Users\km978\Box\NSF Senegal"
	if "`c(username)'"=="Kateri" global master "C:\Users\Kateri\Box\NSF Senegal"
	if "`c(username)'"=="admmi" global master "C:\Users\admmi\Box\NSF Senegal"


*^*^* Define project-specific paths


	global cleandata_ucad_base "$master\Data_Management\Data\_Partner_CleanData\Parasitological_Data\UCAD_Data\Baseline"
	global cleandata_ucad_mid "$master\Data_Management\Data\_Partner_CleanData\Parasitological_Data\UCAD_Data\Midline\Midline_Cleaned_Parasitology_Data"

	global cleandata_epls_base "$master\Data_Management\Data\_Partner_CleanData\Parasitological_Data\EPLS_Data\Baseline"
	global cleandata_epls_mid "$master\Data_Management\Data\_Partner_CleanData\Parasitological_Data\EPLS_Data\Midline\Midline_Cleaned_Parasitology_Data"
	
	global rawdata_ucad_mid "$master\Data_Management\Data\_Partner_RawData\Parasitological_Data\UCAD_Data\Midline"
	global rawdata_ucad_base "$master\Data_Management\Data\_Partner_RawData\Parasitological_Data\UCAD_Data\Baseline"

	global rawdata_epls_mid "$master\Data_Management\Data\_Partner_RawData\Parasitological_Data\EPLS_Data\Midline"
	global rawdata_epls_base "$master\Data_Management\Data\_Partner_RawData\Parasitological_Data\EPLS_Data\Baseline"
	
	global dataexport "$master\Data_Management\Data\_Partner_RawData\Parasitological_Data"
 
*<><<><><>><><<><><>>
**# CLEAN BASELINE UCAD DATA
*<><<><><>><><<><><>>

/* 

**##  Geuo (033A)
*-----------------------------------------* Village Geuo *-----------------------------------------*

		import excel "$rawdata_ucad_base\DISES UCAD.UGB.1_VILLAGES.PARASITOLOGY DATA ALL VILLAGES.controled_1_25.06.24.xlsx", sheet("10_GU") firstrow clear


 

		*^*^*rename variables for clarity 

		rename DISES_SEN2151_Parasitologiede numero
		rename B initiales
		rename C identificant
		rename D sex_hp
		rename E age_hp_hp
		rename F fu_p1
		rename G omega_vivant_1
		rename H sm_fu_1
		rename I fu_p2
		rename J omega_vivant_2
		rename K sm_fu_2
		rename L p1_kato1
		rename M p1_kato1_epg
		rename N p1_kato2
		rename O p1_kato2_epg
		rename P sh_kk_p1
		rename Q p2_kato1
		rename R p2_kato1_epg
		rename S p2_kato2
		rename T p2_kato2_epg
		rename U sh_kk_p2
		rename V treatment_date
		
		*^*^* Label variables 
	  
		label variable numero "Record number"
		label variable initiales "Initials"
		label variable identificant "Unique ID"
		label variable sex_hp "Sex"
		label variableage_hp "Current age"
		label variable fu_p1 "Follow-up period 1"
		label variable omega_vivant_p1 "ω (alive) during FU/P1"
		label variable sm_fup1 "S. mansoni present at FU/P1"
		label variable fu_p2 "Follow-up period 2"
		label variable omega_vivant_p2 "ω (alive) during FU/P2"
		label variable sm_fup2 "S. mansoni present at FU/P2"
		label variable p1_kato1 "Kato-Katz 1 (P1)"
		label variable p1_kato1_epg "EPG (P1, slide 1)"
		label variable p1_kato2 "Kato-Katz 2 (P1)"
		label variable p1_kato2_epg "EPG (P1, slide 2)"
		label variable sh_kk_p1 "S. haematobium (P1)"
		label variable p2_kato1 "Kato-Katz 1 (P2)"
		label variable p2_kato1_epg "EPG (P2, slide 1)"
		label variable p2_kato2 "Kato-Katz 2 (P2)"
		label variable p2_kato2_epg "EPG (P2, slide 2)"
		label variable sh_kk_p2 "S. haematobium (P2)"
		label variable treatment_date "Date of PZQ treatment"
		
		**drop unneeded/empty rows
		
		drop in 1/6
		drop in 57


	save "$cleandata_ucad_base\geuo_033A_baseline_df", replace 
	
**## Dodel (072B)
*-----------------------------------------* Baseline Village Dodel *-----------------------------------------*
	
		import excel "$rawdata_ucad_base\DISES UCAD.UGB.1_VILLAGES.PARASITOLOGY DATA ALL VILLAGES.controled_1_25.06.24.xlsx", sheet("1_DO") firstrow clear


 

		*^*^*rename variables for clarity 

		rename DISES_SEN2151_Parasitologiede numero
		rename B initiales
		rename C identificant
		rename D sex_hp
		rename Eage_hp
		rename F fu_p1
		rename G omega_vivant_p1
		rename H sm_fup1
		rename I fu_p2
		rename J omega_vivant_p2
		rename K sm_fup2
		rename L p1_kato1
		rename M p1_kato1_epg
		rename N p1_kato2
		rename O p1_kato2_epg
		rename P sh_kk_p1
		rename Q p2_kato1
		rename R p2_kato1_epg
		rename S p2_kato2
		rename T p2_kato2_epg
		rename U sh_kk_p2
		rename V treatment_date
		
		*^*^* Label variables 
	  
		label variable numero "Record number"
		label variable initiales "Initials"
		label variable identificant "Unique ID"
		label variable sex_hp "Sex"
		label variable age_hp "Current age"
		label variable fu_p1 "Follow-up period 1"
		label variable omega_vivant_p1 "ω (alive) during FU/P1"
		label variable sm_fup1 "S. mansoni present at FU/P1"
		label variable fu_p2 "Follow-up period 2"
		label variable omega_vivant_p2 "ω (alive) during FU/P2"
		label variable sm_fup2 "S. mansoni present at FU/P2"
		label variable p1_kato1 "Kato-Katz 1 (P1)"
		label variable p1_kato1_epg "EPG (P1, slide 1)"
		label variable p1_kato2 "Kato-Katz 2 (P1)"
		label variable p1_kato2_epg "EPG (P1, slide 2)"
		label variable sh_kk_p1 "S. haematobium (P1)"
		label variable p2_kato1 "Kato-Katz 1 (P2)"
		label variable p2_kato1_epg "EPG (P2, slide 1)"
		label variable p2_kato2 "Kato-Katz 2 (P2)"
		label variable p2_kato2_epg "EPG (P2, slide 2)"
		label variable sh_kk_p2 "S. haematobium (P2)"
		label variable treatment_date "Date of PZQ treatment"
		
		**drop unneeded/empty rows
		
		drop in 1/6
		drop if identificant == "Control realized by Bruno Senghor 21.06.2024"

	save "$cleandata_ucad_base\dodel_072B_baseline_df", replace 
	
**## Diabobe (030B)
*-----------------------------------------*  Baseline Village Diabobe *-----------------------------------------*
	
		import excel "$rawdata_ucad_base\DISES UCAD.UGB.1_VILLAGES.PARASITOLOGY DATA ALL VILLAGES.controled_1_25.06.24.xlsx", sheet("2_DI") firstrow clear


 

		*^*^*rename variables for clarity 

		rename CartoBil_SEN2151_Parasitologie numero
		rename B initiales
		rename C identificant
		rename D sex_hp
		rename Eage_hp
		rename F fu_p1
		rename G omega_vivant_p1
		rename H sm_fup1
		rename I fu_p2
		rename J omega_vivant_p2
		rename K sm_fup2
		rename L p1_kato1
		rename M p1_kato1_epg
		rename N p1_kato2
		rename O p1_kato2_epg
		rename P sh_kk_p1
		rename Q p2_kato1
		rename R p2_kato1_epg
		rename S p2_kato2
		rename T p2_kato2_epg
		rename U sh_kk_p2
		rename V treatment_date
		
		*^*^* Label variables 
	  
		label variable numero "Record number"
		label variable initiales "Initials"
		label variable identificant "Unique ID"
		label variable sex_hp "Sex"
		label variable age_hp "Current age"
		label variable fu_p1 "Follow-up period 1"
		label variable omega_vivant_p1 "ω (alive) during FU/P1"
		label variable sm_fup1 "S. mansoni present at FU/P1"
		label variable fu_p2 "Follow-up period 2"
		label variable omega_vivant_p2 "ω (alive) during FU/P2"
		label variable sm_fup2 "S. mansoni present at FU/P2"
		label variable p1_kato1 "Kato-Katz 1 (P1)"
		label variable p1_kato1_epg "EPG (P1, slide 1)"
		label variable p1_kato2 "Kato-Katz 2 (P1)"
		label variable p1_kato2_epg "EPG (P1, slide 2)"
		label variable sh_kk_p1 "S. haematobium (P1)"
		label variable p2_kato1 "Kato-Katz 1 (P2)"
		label variable p2_kato1_epg "EPG (P2, slide 1)"
		label variable p2_kato2 "Kato-Katz 2 (P2)"
		label variable p2_kato2_epg "EPG (P2, slide 2)"
		label variable sh_kk_p2 "S. haematobium (P2)"
		label variable treatment_date "Date of PZQ treatment"
		
		**drop unneeded/empty rows
		
		drop in 1/4
		drop if identificant == "Control realized by Bruno Senghor 21.06.2024"

	save "$cleandata_ucad_base\diabobe_030B_baseline_df", replace 
	
	
**##  Ndiayene Pendao (020B)
*-----------------------------------------* Baseline Village Ndiayene Pendao *-----------------------------------------*
	
		import excel "$rawdata_ucad_base\DISES UCAD.UGB.1_VILLAGES.PARASITOLOGY DATA ALL VILLAGES.controled_1_25.06.24.xlsx", sheet("3_NP") firstrow clear


 

		*^*^*rename variables for clarity 

		rename A numero
		rename DISES_SEN2151_Parasitologiede initiales
		rename C identificant
		rename D sex_hp
		rename Eage_hp
		rename F fu_p1
		rename G omega_vivant_p1
		rename H sm_fup1
		rename I fu_p2
		rename J omega_vivant_p2
		rename K sm_fup2
		rename L p1_kato1
		rename M p1_kato1_epg
		rename N p1_kato2
		rename O p1_kato2_epg
		rename P sh_kk_p1
		rename Q p2_kato1
		rename R p2_kato1_epg
		rename S p2_kato2
		rename T p2_kato2_epg
		rename U sh_kk_p2
		rename V treatment_date
		
		*^*^* Label variables 
	  
		label variable numero "Record number"
		label variable initiales "Initials"
		label variable identificant "Unique ID"
		label variable sex_hp "Sex"
		label variable age_hp "Current age"
		label variable fu_p1 "Follow-up period 1"
		label variable omega_vivant_p1 "ω (alive) during FU/P1"
		label variable sm_fup1 "S. mansoni present at FU/P1"
		label variable fu_p2 "Follow-up period 2"
		label variable omega_vivant_p2 "ω (alive) during FU/P2"
		label variable sm_fup2 "S. mansoni present at FU/P2"
		label variable p1_kato1 "Kato-Katz 1 (P1)"
		label variable p1_kato1_epg "EPG (P1, slide 1)"
		label variable p1_kato2 "Kato-Katz 2 (P1)"
		label variable p1_kato2_epg "EPG (P1, slide 2)"
		label variable sh_kk_p1 "S. haematobium (P1)"
		label variable p2_kato1 "Kato-Katz 1 (P2)"
		label variable p2_kato1_epg "EPG (P2, slide 1)"
		label variable p2_kato2 "Kato-Katz 2 (P2)"
		label variable p2_kato2_epg "EPG (P2, slide 2)"
		label variable sh_kk_p2 "S. haematobium (P2)"
		label variable treatment_date "Date of PZQ treatment"
		
		**drop unneeded/empty rows
		
		drop in 1/4
		drop in 54/55

	save "$cleandata_ucad_base\ndiayene_pendao_020B_baseline_df", replace 
	
**##   Thiangaye (021B)
*-----------------------------------------* Baseline Village Thiangaye *-----------------------------------------*

		import excel "$rawdata_ucad_base\DISES UCAD.UGB.1_VILLAGES.PARASITOLOGY DATA ALL VILLAGES.controled_1_25.06.24.xlsx", sheet("4_TH") firstrow clear


 

		*^*^*rename variables for clarity 

		rename DISES_SEN2151_Parasitologiede numero
		rename B initiales
		rename C identificant
		rename D sex_hp
		rename Eage_hp
		rename F fu_p1
		rename G omega_vivant_p1
		rename H sm_fup1
		rename I fu_p2
		rename J omega_vivant_p2
		rename K sm_fup2
		rename L p1_kato1
		rename M p1_kato1_epg
		rename N p1_kato2
		rename O p1_kato2_epg
		rename P sh_kk_p1
		rename Q p2_kato1
		rename R p2_kato1_epg
		rename S p2_kato2
		rename T p2_kato2_epg
		rename U sh_kk_p2
		rename V treatment_date
		
		*^*^* Label variables 
	  
		label variable numero "Record number"
		label variable initiales "Initials"
		label variable identificant "Unique ID"
		label variable sex_hp "Sex"
		label variable age_hp "Current age"
		label variable fu_p1 "Follow-up period 1"
		label variable omega_vivant_p1 "ω (alive) during FU/P1"
		label variable sm_fup1 "S. mansoni present at FU/P1"
		label variable fu_p2 "Follow-up period 2"
		label variable omega_vivant_p2 "ω (alive) during FU/P2"
		label variable sm_fup2 "S. mansoni present at FU/P2"
		label variable p1_kato1 "Kato-Katz 1 (P1)"
		label variable p1_kato1_epg "EPG (P1, slide 1)"
		label variable p1_kato2 "Kato-Katz 2 (P1)"
		label variable p1_kato2_epg "EPG (P1, slide 2)"
		label variable sh_kk_p1 "S. haematobium (P1)"
		label variable p2_kato1 "Kato-Katz 1 (P2)"
		label variable p2_kato1_epg "EPG (P2, slide 1)"
		label variable p2_kato2 "Kato-Katz 2 (P2)"
		label variable p2_kato2_epg "EPG (P2, slide 2)"
		label variable sh_kk_p2 "S. haematobium (P2)"
		label variable treatment_date "Date of PZQ treatment"
		
		**drop unneeded/empty rows
		
		drop in 1/4
		drop in 56/57

	save "$cleandata_ucad_base\thiangaye_021B_baseline_df", replace 	

	
	
**##   Fanaye Diery (062B)
*-----------------------------------------* Baseline Village Fanaye Diery *-----------------------------------------*

		import excel "$rawdata_ucad_base\DISES UCAD.UGB.1_VILLAGES.PARASITOLOGY DATA ALL VILLAGES.controled_1_25.06.24.xlsx", sheet("5_FD") firstrow clear


 

		*^*^*rename variables for clarity 

		rename DISES_SEN2151_Parasitologiede numero
		rename B initiales
		rename C identificant
		rename D sex_hp
		rename Eage_hp
		rename F fu_p1
		rename G omega_vivant_p1
		rename H sm_fup1
		rename I fu_p2
		rename J omega_vivant_p2
		rename K sm_fup2
		rename L p1_kato1
		rename M p1_kato1_epg
		rename N p1_kato2
		rename O p1_kato2_epg
		rename P sh_kk_p1
		rename Q p2_kato1
		rename R p2_kato1_epg
		rename S p2_kato2
		rename T p2_kato2_epg
		rename U sh_kk_p2
		rename V treatment_date
		
		*^*^* Label variables 
	  
		label variable numero "Record number"
		label variable initiales "Initials"
		label variable identificant "Unique ID"
		label variable sex_hp "Sex"
		label variable age_hp "Current age"
		label variable fu_p1 "Follow-up period 1"
		label variable omega_vivant_p1 "ω (alive) during FU/P1"
		label variable sm_fup1 "S. mansoni present at FU/P1"
		label variable fu_p2 "Follow-up period 2"
		label variable omega_vivant_p2 "ω (alive) during FU/P2"
		label variable sm_fup2 "S. mansoni present at FU/P2"
		label variable p1_kato1 "Kato-Katz 1 (P1)"
		label variable p1_kato1_epg "EPG (P1, slide 1)"
		label variable p1_kato2 "Kato-Katz 2 (P1)"
		label variable p1_kato2_epg "EPG (P1, slide 2)"
		label variable sh_kk_p1 "S. haematobium (P1)"
		label variable p2_kato1 "Kato-Katz 1 (P2)"
		label variable p2_kato1_epg "EPG (P2, slide 1)"
		label variable p2_kato2 "Kato-Katz 2 (P2)"
		label variable p2_kato2_epg "EPG (P2, slide 2)"
		label variable sh_kk_p2 "S. haematobium (P2)"
		label variable treatment_date "Date of PZQ treatment"
		
		**drop unneeded/empty rows
		
		drop in 1/6
		drop in 56/57

	save "$cleandata_ucad_base\fanaye_diery_062B_baseline_df", replace 	 	
	
	
	
	
**##   Saneinte (031B)

*-----------------------------------------* Baseline Village Saneinte *-----------------------------------------*

		import excel "$rawdata_ucad_base\DISES UCAD.UGB.1_VILLAGES.PARASITOLOGY DATA ALL VILLAGES.controled_1_25.06.24.xlsx", sheet("6_SA") firstrow clear


 

		*^*^*rename variables for clarity 

		rename DISES_SEN2151_Parasitologiede numero
		rename B initiales
		rename C identificant
		rename D sex_hp
		rename E age_hp_hp 
		rename F fu_p1
		rename G omega_vivant_p1
		rename H sm_fup1
		rename I fu_p2
		rename J omega_vivant_p2
		rename K sm_fup2
		rename L p1_kato1
		rename M p1_kato1_epg
		rename N p1_kato2
		rename O p1_kato2_epg
		rename P sh_kk_p1
		rename Q p2_kato1
		rename R p2_kato1_epg
		rename S p2_kato2
		rename T p2_kato2_epg
		rename U sh_kk_p2
		rename V treatment_date
		
		*^*^* Label variables 
	  
		label variable numero "Record number"
		label variable initiales "Initials"
		label variable identificant "Unique ID"
		label variable sex_hp "Sex"
		label variable age_hp  "Current age"
		label variable fu_p1 "Follow-up period 1"
		label variable omega_vivant_p1 "ω (alive) during FU/P1"
		label variable sm_fup1 "S. mansoni present at FU/P1"
		label variable fu_p2 "Follow-up period 2"
		label variable omega_vivant_p2 "ω (alive) during FU/P2"
		label variable sm_fup2 "S. mansoni present at FU/P2"
		label variable p1_kato1 "Kato-Katz 1 (P1)"
		label variable p1_kato1_epg "EPG (P1, slide 1)"
		label variable p1_kato2 "Kato-Katz 2 (P1)"
		label variable p1_kato2_epg "EPG (P1, slide 2)"
		label variable sh_kk_p1 "S. haematobium (P1)"
		label variable p2_kato1 "Kato-Katz 1 (P2)"
		label variable p2_kato1_epg "EPG (P2, slide 1)"
		label variable p2_kato2 "Kato-Katz 2 (P2)"
		label variable p2_kato2_epg "EPG (P2, slide 2)"
		label variable sh_kk_p2 "S. haematobium (P2)"
		label variable treatment_date "Date of PZQ treatment"
		
		**drop unneeded/empty rows
		
		drop in 1/4
		drop in 57

	save "$cleandata_ucad_base\saneinte_031B_baseline_df", replace 	 	
	
**##   Yetti Yone (033B) KRM - double check 
*-----------------------------------------* Baseline Village Yetti Yone *-----------------------------------------*

		import excel "$rawdata_ucad_base\DISES UCAD.UGB.1_VILLAGES.PARASITOLOGY DATA ALL VILLAGES.controled_1_25.06.24.xlsx", sheet("7_YY") firstrow clear


 

		*^*^*rename variables for clarity 

		rename A numero
		rename DISES_SEN2151_Parasitologiede initiales
		rename C identificant
		rename D sex_hp
		rename E age_hp_hp 
		rename F fu_p1
		rename G omega_vivant_p1
		rename H sm_fup1
		rename I fu_p2
		rename J omega_vivant_p2
		rename K sm_fup2
		rename L p1_kato1
		rename M p1_kato1_epg
		rename N p1_kato2
		rename O p1_kato2_epg
		rename P sh_kk_p1
		rename Q p2_kato1
		rename R p2_kato1_epg
		rename S p2_kato2
		rename T p2_kato2_epg
		rename U sh_kk_p2
		rename V treatment_date
		
		*^*^* Label variables 
	  
		label variable numero "Record number"
		label variable initiales "Initials"
		label variable identificant "Unique ID"
		label variable sex_hp "Sex"
		label variable age_hp "Current age"
		label variable fu_p1 "Follow-up period 1"
		label variable omega_vivant_p1 "ω (alive) during FU/P1"
		label variable sm_fup1 "S. mansoni present at FU/P1"
		label variable fu_p2 "Follow-up period 2"
		label variable omega_vivant_p2 "ω (alive) during FU/P2"
		label variable sm_fup2 "S. mansoni present at FU/P2"
		label variable p1_kato1 "Kato-Katz 1 (P1)"
		label variable p1_kato1_epg "EPG (P1, slide 1)"
		label variable p1_kato2 "Kato-Katz 2 (P1)"
		label variable p1_kato2_epg "EPG (P1, slide 2)"
		label variable sh_kk_p1 "S. haematobium (P1)"
		label variable p2_kato1 "Kato-Katz 1 (P2)"
		label variable p2_kato1_epg "EPG (P2, slide 1)"
		label variable p2_kato2 "Kato-Katz 2 (P2)"
		label variable p2_kato2_epg "EPG (P2, slide 2)"
		label variable sh_kk_p2 "S. haematobium (P2)"
		label variable treatment_date "Date of PZQ treatment"
		
		
		drop in 1/5
		
	** save child who recended consent 
	 preserve 
	
			keep in 57/58
		
				tempfile _033B_left_school
					save  `_033B_left_school'

		
	restore 
				
		**drop unneeded/empty rows
				drop in 59/60

			save "$cleandata_ucad_base\yetti_yone_033B_baseline_df", replace 	 	
		
**##   Yamane (130A)
*-----------------------------------------* Baseline Village Yamane *-----------------------------------------*

		import excel "$rawdata_ucad_base\DISES UCAD.UGB.1_VILLAGES.PARASITOLOGY DATA ALL VILLAGES.controled_1_25.06.24.xlsx", sheet("8_YA") firstrow clear


 

		*^*^*rename variables for clarity 

		rename A numero
		rename DISES_SEN2151_Parasitologiede initiales
		rename C identificant
		rename D sex_hp
		rename E age_hp_hp
		rename F fu_p1
		rename G omega_vivant_p1
		rename H sm_fup1
		rename I fu_p2
		rename J omega_vivant_p2
		rename K sm_fup2
		rename L p1_kato1
		rename M p1_kato1_epg
		rename N p1_kato2
		rename O p1_kato2_epg
		rename P sh_kk_p1
		rename Q p2_kato1
		rename R p2_kato1_epg
		rename S p2_kato2
		rename T p2_kato2_epg
		rename U sh_kk_p2
		rename V treatment_date
		
		*^*^* Label variables 
	  
		label variable numero "Record number"
		label variable initiales "Initials"
		label variable identificant "Unique ID"
		label variable sex_hp "Sex"
		label variable age_hp "Current age"
		label variable fu_p1 "Follow-up period 1"
		label variable omega_vivant_p1 "ω (alive) during FU/P1"
		label variable sm_fup1 "S. mansoni present at FU/P1"
		label variable fu_p2 "Follow-up period 2"
		label variable omega_vivant_p2 "ω (alive) during FU/P2"
		label variable sm_fup2 "S. mansoni present at FU/P2"
		label variable p1_kato1 "Kato-Katz 1 (P1)"
		label variable p1_kato1_epg "EPG (P1, slide 1)"
		label variable p1_kato2 "Kato-Katz 2 (P1)"
		label variable p1_kato2_epg "EPG (P1, slide 2)"
		label variable sh_kk_p1 "S. haematobium (P1)"
		label variable p2_kato1 "Kato-Katz 1 (P2)"
		label variable p2_kato1_epg "EPG (P2, slide 1)"
		label variable p2_kato2 "Kato-Katz 2 (P2)"
		label variable p2_kato2_epg "EPG (P2, slide 2)"
		label variable sh_kk_p2 "S. haematobium (P2)"
		label variable treatment_date "Date of PZQ treatment"
		
		**drop unneeded/empty rows
		
		drop in 1/4
				
		drop in 57

			save "$cleandata_ucad_base\yamane_130A_baseline_df", replace 
	

	**##   Diaminar Loyene (130A)

*-----------------------------------------* Baseline Village Diaminar Loyene *-----------------------------------------*

		import excel "$rawdata_ucad_base\DISES UCAD.UGB.1_VILLAGES.PARASITOLOGY DATA ALL VILLAGES.controled_1_25.06.24.xlsx", sheet("9_DL") firstrow clear


 

		*^*^*rename variables for clarity 

		rename DISES_SEN2151_Parasitologiede numero
		rename B initiales
		rename C identificant
		rename D sex_hp
		rename E age_hp_hp
		rename F fu_p1
		rename G omega_vivant_p1
		rename H sm_fup1
		rename I fu_p2
		rename J omega_vivant_p2
		rename K sm_fup2
		rename L p1_kato1
		rename M p1_kato1_epg
		rename N p1_kato2
		rename O p1_kato2_epg
		rename P sh_kk_p1
		rename Q p2_kato1
		rename R p2_kato1_epg
		rename S p2_kato2
		rename T p2_kato2_epg
		rename U sh_kk_p2
		rename V treatment_date
		
		*^*^* Label variables 
	  
		label variable numero "Record number"
		label variable initiales "Initials"
		label variable identificant "Unique ID"
		label variable sex_hp "Sex"
		label variable age_hp "Current age"
		label variable fu_p1 "Follow-up period 1"
		label variable omega_vivant_p1 "ω (alive) during FU/P1"
		label variable sm_fup1 "S. mansoni present at FU/P1"
		label variable fu_p2 "Follow-up period 2"
		label variable omega_vivant_p2 "ω (alive) during FU/P2"
		label variable sm_fup2 "S. mansoni present at FU/P2"
		label variable p1_kato1 "Kato-Katz 1 (P1)"
		label variable p1_kato1_epg "EPG (P1, slide 1)"
		label variable p1_kato2 "Kato-Katz 2 (P1)"
		label variable p1_kato2_epg "EPG (P1, slide 2)"
		label variable sh_kk_p1 "S. haematobium (P1)"
		label variable p2_kato1 "Kato-Katz 1 (P2)"
		label variable p2_kato1_epg "EPG (P2, slide 1)"
		label variable p2_kato2 "Kato-Katz 2 (P2)"
		label variable p2_kato2_epg "EPG (P2, slide 2)"
		label variable sh_kk_p2 "S. haematobium (P2)"
		label variable treatment_date "Date of PZQ treatment"
		
		
		**drop unneeded/empty rows
		
		drop in 1/4
		drop in 56/57

			save "$cleandata_ucad_base\diaminar_loyene_130A_baseline_df", replace 	 			
	
**##   Kassack Nord (030A)
*-----------------------------------------* Baseline Village Kassack Nord *-----------------------------------------*

		import excel "$rawdata_ucad_base\DISES UCAD.UGB.1_VILLAGES.PARASITOLOGY DATA ALL VILLAGES.controled_1_25.06.24.xlsx", sheet("11_KA") firstrow clear


 

		*^*^*rename variables for clarity 

		rename DISES_SEN2151_Parasitologiede numero
		rename B initiales
		rename C identificant
		rename D sex_hp
		rename E age_hp_hp
		rename F fu_p1
		rename G omega_vivant_p1
		rename H sm_fup1
		rename I fu_p2
		rename J omega_vivant_p2
		rename K sm_fup2
		rename L p1_kato1
		rename M p1_kato1_epg
		rename N p1_kato2
		rename O p1_kato2_epg
		rename P sh_kk_p1
		rename Q p2_kato1
		rename R p2_kato1_epg
		rename S p2_kato2
		rename T p2_kato2_epg
		rename U sh_kk_p2
		rename V treatment_date
		
		*^*^* Label variables 
	  
		label variable numero "Record number"
		label variable initiales "Initials"
		label variable identificant "Unique ID"
		label variable sex_hp "Sex"
		label variable age_hp "Current age"
		label variable fu_p1 "Follow-up period 1"
		label variable omega_vivant_p1 "ω (alive) during FU/P1"
		label variable sm_fup1 "S. mansoni present at FU/P1"
		label variable fu_p2 "Follow-up period 2"
		label variable omega_vivant_p2 "ω (alive) during FU/P2"
		label variable sm_fup2 "S. mansoni present at FU/P2"
		label variable p1_kato1 "Kato-Katz 1 (P1)"
		label variable p1_kato1_epg "EPG (P1, slide 1)"
		label variable p1_kato2 "Kato-Katz 2 (P1)"
		label variable p1_kato2_epg "EPG (P1, slide 2)"
		label variable sh_kk_p1 "S. haematobium (P1)"
		label variable p2_kato1 "Kato-Katz 1 (P2)"
		label variable p2_kato1_epg "EPG (P2, slide 1)"
		label variable p2_kato2 "Kato-Katz 2 (P2)"
		label variable p2_kato2_epg "EPG (P2, slide 2)"
		label variable sh_kk_p2 "S. haematobium (P2)"
		label variable treatment_date "Date of PZQ treatment"
		
		**drop unneeded/empty rows
		
		drop in 1/6
		drop in 55

			save "$cleandata_ucad_base\kassack_nord_030A_baseline_df", replace 	 			
	
	
	
**##   Ndiamar (Souloul) (020A)
*-----------------------------------------* Baseline Village Ndiamar *-----------------------------------------*

		import excel "$rawdata_ucad_base\DISES UCAD.UGB.1_VILLAGES.PARASITOLOGY DATA ALL VILLAGES.controled_1_25.06.24.xlsx", sheet("12_SO") firstrow clear


 

		*^*^*rename variables for clarity 

		rename DISES_SEN2151_Parasitologiede numero
		rename B initiales
		rename C identificant
		rename D sex_hp
		rename E age_hp
		rename F fu_p1
		rename G omega_vivant_p1
		rename H sm_fup1
		rename I fu_p2
		rename J omega_vivant_p2
		rename K sm_fup2
		rename L p1_kato1
		rename M p1_kato1_epg
		rename N p1_kato2
		rename O p1_kato2_epg
		rename P sh_kk_p1
		rename Q p2_kato1
		rename R p2_kato1_epg
		rename S p2_kato2
		rename T p2_kato2_epg
		rename U sh_kk_p2
		rename V treatment_date
		
		*^*^* Label variables 
	  
		label variable numero "Record number"
		label variable initiales "Initials"
		label variable identificant "Unique ID"
		label variable sex_hp "Sex"
		label variable age_hp "Current age"
		label variable fu_p1 "Follow-up period 1"
		label variable omega_vivant_p1 "ω (alive) during FU/P1"
		label variable sm_fup1 "S. mansoni present at FU/P1"
		label variable fu_p2 "Follow-up period 2"
		label variable omega_vivant_p2 "ω (alive) during FU/P2"
		label variable sm_fup2 "S. mansoni present at FU/P2"
		label variable p1_kato1 "Kato-Katz 1 (P1)"
		label variable p1_kato1_epg "EPG (P1, slide 1)"
		label variable p1_kato2 "Kato-Katz 2 (P1)"
		label variable p1_kato2_epg "EPG (P1, slide 2)"
		label variable sh_kk_p1 "S. haematobium (P1)"
		label variable p2_kato1 "Kato-Katz 1 (P2)"
		label variable p2_kato1_epg "EPG (P2, slide 1)"
		label variable p2_kato2 "Kato-Katz 2 (P2)"
		label variable p2_kato2_epg "EPG (P2, slide 2)"
		label variable sh_kk_p2 "S. haematobium (P2)"
		label variable treatment_date "Date of PZQ treatment"
		
		**drop unneeded/empty rows
		
		drop in 1/6
		drop in 57

			save "$cleandata_ucad_base\ndiamar_020A_baseline_df", replace 	 				
	
	
	
**## El Debiyaye Maraye II (021A) (Maraye)
*-----------------------------------------* Baseline Village Maraye *-----------------------------------------*

		import excel "$rawdata_ucad_base\DISES UCAD.UGB.1_VILLAGES.PARASITOLOGY DATA ALL VILLAGES.controled_1_25.06.24.xlsx", sheet("13_MA") firstrow clear


 

		*^*^*rename variables for clarity 

		rename DISES_SEN2151_Parasitologiede numero
		rename B initiales
		rename C identificant
		rename D sex_hp
		rename E age_hp
		rename F fu_p1
		rename G omega_vivant_p1
		rename H sm_fup1
		rename I fu_p2
		rename J omega_vivant_p2
		rename K sm_fup2
		rename L p1_kato1
		rename M p1_kato1_epg
		rename N p1_kato2
		rename O p1_kato2_epg
		rename P sh_kk_p1
		rename Q p2_kato1
		rename R p2_kato1_epg
		rename S p2_kato2
		rename T p2_kato2_epg
		rename U sh_kk_p2
		rename V treatment_date
		
		*^*^* Label variables 
	  
		label variable numero "Record number"
		label variable initiales "Initials"
		label variable identificant "Unique ID"
		label variable sex_hp "Sex"
		label variable age_hp "Current age"
		label variable fu_p1 "Follow-up period 1"
		label variable omega_vivant_p1 "ω (alive) during FU/P1"
		label variable sm_fup1 "S. mansoni present at FU/P1"
		label variable fu_p2 "Follow-up period 2"
		label variable omega_vivant_p2 "ω (alive) during FU/P2"
		label variable sm_fup2 "S. mansoni present at FU/P2"
		label variable p1_kato1 "Kato-Katz 1 (P1)"
		label variable p1_kato1_epg "EPG (P1, slide 1)"
		label variable p1_kato2 "Kato-Katz 2 (P1)"
		label variable p1_kato2_epg "EPG (P1, slide 2)"
		label variable sh_kk_p1 "S. haematobium (P1)"
		label variable p2_kato1 "Kato-Katz 1 (P2)"
		label variable p2_kato1_epg "EPG (P2, slide 1)"
		label variable p2_kato2 "Kato-Katz 2 (P2)"
		label variable p2_kato2_epg "EPG (P2, slide 2)"
		label variable sh_kk_p2 "S. haematobium (P2)"
		label variable treatment_date "Date of PZQ treatment"
		
		**drop unneeded/empty rows
		
		drop in 1/6
		drop in 51

			save "$cleandata_ucad_base\el_debiyaye_maraye_021A_baseline_df", replace 	 				
		
	
	
**## Dioss Peulh (032A)
*-----------------------------------------* Baseline Village Dioss Peulh *-----------------------------------------*

		import excel "$rawdata_ucad_base\DISES UCAD.UGB.1_VILLAGES.PARASITOLOGY DATA ALL VILLAGES.controled_1_25.06.24.xlsx", sheet("14_DP") firstrow clear


 

		*^*^*rename variables for clarity 

		rename DISES_SEN2151_Parasitologiede numero
		rename B initiales
		rename C identificant
		rename D sex_hp
		rename E age_hp
		rename F fu_p1
		rename G omega_vivant_p1
		rename H sm_fup1
		rename I fu_p2
		rename J omega_vivant_p2
		rename K sm_fup2
		rename L p1_kato1
		rename M p1_kato1_epg
		rename N p1_kato2
		rename O p1_kato2_epg
		rename P sh_kk_p1
		rename Q p2_kato1
		rename R p2_kato1_epg
		rename S p2_kato2
		rename T p2_kato2_epg
		rename U sh_kk_p2
		rename V treatment_date
		
		*^*^* Label variables 
	  
		label variable numero "Record number"
		label variable initiales "Initials"
		label variable identificant "Unique ID"
		label variable sex_hp "Sex"
		label variable age_hp "Current age"
		label variable fu_p1 "Follow-up period 1"
		label variable omega_vivant_p1 "ω (alive) during FU/P1"
		label variable sm_fup1 "S. mansoni present at FU/P1"
		label variable fu_p2 "Follow-up period 2"
		label variable omega_vivant_p2 "ω (alive) during FU/P2"
		label variable sm_fup2 "S. mansoni present at FU/P2"
		label variable p1_kato1 "Kato-Katz 1 (P1)"
		label variable p1_kato1_epg "EPG (P1, slide 1)"
		label variable p1_kato2 "Kato-Katz 2 (P1)"
		label variable p1_kato2_epg "EPG (P1, slide 2)"
		label variable sh_kk_p1 "S. haematobium (P1)"
		label variable p2_kato1 "Kato-Katz 1 (P2)"
		label variable p2_kato1_epg "EPG (P2, slide 1)"
		label variable p2_kato2 "Kato-Katz 2 (P2)"
		label variable p2_kato2_epg "EPG (P2, slide 2)"
		label variable sh_kk_p2 "S. haematobium (P2)"
		label variable treatment_date "Date of PZQ treatment"
		
		**drop unneeded/empty rows
		
		drop in 1/6
		drop in 53

			save "$cleandata_ucad_base\dioss_peulh_032A_baseline_df", replace 	 				
		
**## Mberaye (023B)
*-----------------------------------------* Baseline Village Mberaye *-----------------------------------------*

		import excel "$rawdata_ucad_base\DISES UCAD.UGB.1_VILLAGES.PARASITOLOGY DATA ALL VILLAGES.controled_1_25.06.24.xlsx", sheet("15_MB") firstrow clear


 

		*^*^*rename variables for clarity 

		rename DISES_SEN2151_Parasitologiede numero
		rename B initiales
		rename C identificant
		rename D sex_hp
		rename E age_hp
		rename F fu_p1
		rename G omega_vivant_p1
		rename H sm_fup1
		rename I fu_p2
		rename J omega_vivant_p2
		rename K sm_fup2
		rename L p1_kato1
		rename M p1_kato1_epg
		rename N p1_kato2
		rename O p1_kato2_epg
		rename P sh_kk_p1
		rename Q p2_kato1
		rename R p2_kato1_epg
		rename S p2_kato2
		rename T p2_kato2_epg
		rename U sh_kk_p2
		rename V treatment_date
		
		*^*^* Label variables 
	  
		label variable numero "Record number"
		label variable initiales "Initials"
		label variable identificant "Unique ID"
		label variable sex_hp "Sex"
		label variable age_hp "Current age"
		label variable fu_p1 "Follow-up period 1"
		label variable omega_vivant_p1 "ω (alive) during FU/P1"
		label variable sm_fup1 "S. mansoni present at FU/P1"
		label variable fu_p2 "Follow-up period 2"
		label variable omega_vivant_p2 "ω (alive) during FU/P2"
		label variable sm_fup2 "S. mansoni present at FU/P2"
		label variable p1_kato1 "Kato-Katz 1 (P1)"
		label variable p1_kato1_epg "EPG (P1, slide 1)"
		label variable p1_kato2 "Kato-Katz 2 (P1)"
		label variable p1_kato2_epg "EPG (P1, slide 2)"
		label variable sh_kk_p1 "S. haematobium (P1)"
		label variable p2_kato1 "Kato-Katz 1 (P2)"
		label variable p2_kato1_epg "EPG (P2, slide 1)"
		label variable p2_kato2 "Kato-Katz 2 (P2)"
		label variable p2_kato2_epg "EPG (P2, slide 2)"
		label variable sh_kk_p2 "S. haematobium (P2)"
		label variable treatment_date "Date of PZQ treatment"
		
		**drop unneeded/empty rows
		
		drop in 1/6
		drop in 57

			save "$cleandata_ucad_base\mberaye_023B_baseline_df", replace 	 					
	
	*/	
	
	
	
*<><<><><>><><<><><>>
**# CLEAN UCAD MIDLINE DATA
*<><<><><>><><<><><>>

	**##  Geuo (033A)
	**##UPDATES TO MAKE STARTING HERE LOL
*-----------------------------------------* Midline Village Geuo *-----------------------------------------*

	import excel "$rawdata_ucad_mid\Dises year 2_fusion final_3_08042025.UCAD.UGB.xlsx", sheet("10_GU") firstrow clear

  *^*^*rename variables for clarity 

		rename DISES_SEN23119_Parasitologied numero
		rename B initiales
		rename C identificant
		rename D sex_hp
		rename E age_hp
		rename F fu_p1
		rename G omega_vivant_1
		rename H sm_fu_1
		rename I fu_p2
		rename J omega_vivant_2
		rename K sm_fu_2
		rename L p1_kato1_omega
		rename M p1_kato1_k1_epg
		rename N p1_kato2_omega
		rename O p1_kato2_k2_epg
		rename P sh_kk_1
		rename Q p2_kato1_omega
		rename R p2_kato1_k1_epg
		rename S p2_kato2_omega
		rename T p2_kato2_k2_epg
		rename U sh_kk_2
		rename V pzq_1

 *^*^* label variables

		label variable numero               "Record number"
		label variable initiales            "Initials"
		label variable identificant         "Unique ID"
		label variable sex_hp               "Sex"
		label variable age_hp               "Current age"
		label variable fu_p1                "Follow-up period 1"
		label variable omega_vivant_1       "ω (alive) during FU/P1"
		label variable sm_fu_1              "S. mansoni present at FU/P1"
		label variable fu_p2                "Follow-up period 2"
		label variable omega_vivant_2       "ω (alive) during FU/P2"
		label variable sm_fu_2              "S. mansoni present at FU/P2"
		label variable p1_kato1_omega       "Kato-Katz 1 (P1)"
		label variable p1_kato1_k1_epg      "EPG (P1, slide 1)"
		label variable p1_kato2_omega       "Kato-Katz 2 (P1)"
		label variable p1_kato2_k2_epg      "EPG (P1, slide 2)"
		label variable sh_kk_1              "S. haematobium (P1)"
		label variable p2_kato1_omega       "Kato-Katz 1 (P2)"
		label variable p2_kato1_k1_epg      "EPG (P2, slide 1)"
		label variable p2_kato2_omega       "Kato-Katz 2 (P2)"
		label variable p2_kato2_k2_epg      "EPG (P2, slide 2)"
		label variable sh_kk_2              "S. haematobium (P2)"
		label variable pzq_1                "Date of PZQ treatment"

		
		
	* drop the first 6 rows (they're header or formatting rows)
			
		drop in 1/6
		
	* gen village ID
	
		gen hhid_village = "033A"
			order hhid_village
		
		
	* save all kids in midline  
	
		preserve 
			
			gen notes = ""
			
			forvalues i = 59/80 {
				replace notes = fu_p1 in `i'
				replace fu_p1 = "" in `i'
			}

			drop in 57/58
			drop in 78/79
			replace notes = "Transfert\Nouveaux recruts" if notes == "Transfert"
			replace omega_vivant_2 = "" if omega_vivant_2 == "Nouveaux recruts "
			replace notes = "Crtl finalisé __Dr Bruno_le / /2025" if numero == "Crtl finalisé __Dr Bruno_le / /2025"
			replace numero = "" if numero == "Crtl finalisé __Dr Bruno_le / /2025"
			
		save "$cleandata_ucad_mid\geuo_033A_midline_df.dta", replace 
	
	restore 
	
	
	
**## Dodel (072B)
*-----------------------------------------* Midline Village Dodel *-----------------------------------------*
	
	
	import excel "$rawdata_ucad_mid\Dises year 2_fusion final_3_08042025.UCAD.UGB.xlsx", sheet("1_DO") firstrow clear

  *^*^*rename variables for clarity 

		rename DISES_SEN23119_Parasitologied numero
		rename B initiales
		rename C identificant
		rename D sex_hp
		rename E age_hp
		rename F fu_p1
		rename G omega_vivant_1
		rename H sm_fu_1
		rename I fu_p2
		rename J omega_vivant_2
		rename K sm_fu_2
		rename L p1_kato1_omega
		rename M p1_kato1_k1_epg
		rename N p1_kato2_omega
		rename O p1_kato2_k2_epg
		rename P sh_kk_1
		rename Q p2_kato1_omega
		rename R p2_kato1_k1_epg
		rename S p2_kato2_omega
		rename T p2_kato2_k2_epg
		rename U sh_kk_2
		rename V pzq_1

*^*^* label variables
		label variable numero                "Record number"
		label variable initiales            "Initials"
		label variable identificant         "Unique ID"
		label variable sex_hp               "Sex"
		label variable age_hp               "Current age"
		label variable fu_p1                "Follow-up period 1"
		label variable omega_vivant_1       "ω (alive) during FU/P1"
		label variable sm_fu_1              "S. mansoni present at FU/P1"
		label variable fu_p2                "Follow-up period 2"
		label variable omega_vivant_2       "ω (alive) during FU/P2"
		label variable sm_fu_2              "S. mansoni present at FU/P2"
		label variable p1_kato1_omega       "Kato-Katz 1 (P1)"
		label variable p1_kato1_k1_epg      "EPG (P1, slide 1)"
		label variable p1_kato2_omega       "Kato-Katz 2 (P1)"
		label variable p1_kato2_k2_epg      "EPG (P1, slide 2)"
		label variable sh_kk_1              "S. haematobium (P1)"
		label variable p2_kato1_omega       "Kato-Katz 1 (P2)"
		label variable p2_kato1_k1_epg      "EPG (P2, slide 1)"
		label variable p2_kato2_omega       "Kato-Katz 2 (P2)"
		label variable p2_kato2_k2_epg      "EPG (P2, slide 2)"
		label variable sh_kk_2              "S. haematobium (P2)"
		label variable pzq_1                "Date of PZQ treatment"
		
		
	* drop the first 6 rows (they're header or formatting rows)
			
		drop in 1/6
		drop if numero == "Controle réalisé __Dr Bruno_Senghor le 07/ 04/2025"
		drop W X Y Z
		
	* gen village ID
	
		gen hhid_village = "072B"
			order hhid_village
		

	**drop unneeded/empty rows	
			
			drop in 49/50
			drop in 52/54
			
		save "$cleandata_ucad_mid\dodel_072B_midline_df.dta", replace 
	
	
	
	
	

	**## Diabobe (030B)
*-----------------------------------------* Midline Village Diabobe *-----------------------------------------*
	
	
	import excel "$rawdata_ucad_mid\Dises year 2_fusion final_3_08042025.UCAD.UGB.xlsx", sheet("2_DI") firstrow clear

  *^*^*rename variables for clarity 

		rename CartoBil_SEN23119_Parasitologi numero
		rename B initiales
		rename C identificant
		rename D sex_hp
		rename E age_hp
		rename F fu_p1
		rename G omega_vivant_1
		rename H sm_fu_1
		rename I fu_p2
		rename J omega_vivant_2
		rename K sm_fu_2
		rename L p1_kato1_omega
		rename M p1_kato1_k1_epg
		rename N p1_kato2_omega
		rename O p1_kato2_k2_epg
		rename P sh_kk_1
		rename Q p2_kato1_omega
		rename R p2_kato1_k1_epg
		rename S p2_kato2_omega
		rename T p2_kato2_k2_epg
		rename U sh_kk_2
		rename V pzq_1
		
*^*^* label variables
		label variable numero                "Record number"
		label variable initiales            "Initials"
		label variable identificant         "Unique ID"
		label variable sex_hp               "Sex"
		label variable age_hp               "Current age"
		label variable fu_p1                "Follow-up period 1"
		label variable omega_vivant_1       "ω (alive) during FU/P1"
		label variable sm_fu_1              "S. mansoni present at FU/P1"
		label variable fu_p2                "Follow-up period 2"
		label variable omega_vivant_2       "ω (alive) during FU/P2"
		label variable sm_fu_2              "S. mansoni present at FU/P2"
		label variable p1_kato1_omega       "Kato-Katz 1 (P1)"
		label variable p1_kato1_k1_epg      "EPG (P1, slide 1)"
		label variable p1_kato2_omega       "Kato-Katz 2 (P1)"
		label variable p1_kato2_k2_epg      "EPG (P1, slide 2)"
		label variable sh_kk_1              "S. haematobium (P1)"
		label variable p2_kato1_omega       "Kato-Katz 1 (P2)"
		label variable p2_kato1_k1_epg      "EPG (P2, slide 1)"
		label variable p2_kato2_omega       "Kato-Katz 2 (P2)"
		label variable p2_kato2_k2_epg      "EPG (P2, slide 2)"
		label variable sh_kk_2              "S. haematobium (P2)"
		label variable pzq_1                "Date of PZQ treatment"
		
		
	* drop the first 6 rows (they're header or formatting rows)
		drop in 1/6
			* gen village ID
	
		gen hhid_village = "030B"
			order hhid_village
		
		** keep kids who left baseline
	
	preserve 
	
			keep in 52/54
		
				tempfile _030B_left_school
					save  `_030B_left_school'
						
	restore 
		
		**drop unneeded/empty rows

			drop in 51
			drop in 54

		save "$cleandata_ucad_mid\diabobe_030B_midline_df.dta", replace 


	**## Ndiayene Pendao (020B)
	*-----------------------------------------* Midline Village Ndiayene Pendao *-----------------------------------------*
	
	
	import excel "$rawdata_ucad_mid\Dises year 2_fusion final_3_08042025.UCAD.UGB.xlsx", sheet("3_NP") firstrow clear

  *^*^*rename variables for clarity 

		rename A numero
		rename DISES_SEN23119_Parasitologied initiales
		rename C identificant
		rename D sex_hp
		rename E age_hp
		rename F fu_p1
		rename G omega_vivant_1
		rename H sm_fu_1
		rename I fu_p2
		rename J omega_vivant_2
		rename K sm_fu_2
		rename L p1_kato1_omega
		rename M p1_kato1_k1_epg
		rename N p1_kato2_omega
		rename O p1_kato2_k2_epg
		rename P sh_kk_1
		rename Q p2_kato1_omega
		rename R p2_kato1_k1_epg
		rename S p2_kato2_omega
		rename T p2_kato2_k2_epg
		rename U sh_kk_2
		rename V pzq_1
		
*^*^* label variables
		label variable numero                "Record number"
		label variable initiales            "Initials"
		label variable identificant         "Unique ID"
		label variable sex_hp               "Sex"
		label variable age_hp               "Current age"
		label variable fu_p1                "Follow-up period 1"
		label variable omega_vivant_1       "ω (alive) during FU/P1"
		label variable sm_fu_1              "S. mansoni present at FU/P1"
		label variable fu_p2                "Follow-up period 2"
		label variable omega_vivant_2       "ω (alive) during FU/P2"
		label variable sm_fu_2              "S. mansoni present at FU/P2"
		label variable p1_kato1_omega       "Kato-Katz 1 (P1)"
		label variable p1_kato1_k1_epg      "EPG (P1, slide 1)"
		label variable p1_kato2_omega       "Kato-Katz 2 (P1)"
		label variable p1_kato2_k2_epg      "EPG (P1, slide 2)"
		label variable sh_kk_1              "S. haematobium (P1)"
		label variable p2_kato1_omega       "Kato-Katz 1 (P2)"
		label variable p2_kato1_k1_epg      "EPG (P2, slide 1)"
		label variable p2_kato2_omega       "Kato-Katz 2 (P2)"
		label variable p2_kato2_k2_epg      "EPG (P2, slide 2)"
		label variable sh_kk_2              "S. haematobium (P2)"
		label variable pzq_1                "Date of PZQ treatment"

		
	** drop the first 6 rows (they're header or formatting rows)
			
	drop in 1/6
	gen hhid_village = "020B"
		order hhid_village
	
	
	**drop unneeded/empty rows
	
		drop in 52
		drop in 54

			save "$cleandata_ucad_mid\ndiayene_pendao_020B_midline_df.dta", replace 
	
	
	**## Thiangaye (021B)
	*-----------------------------------------* Midline Village Thiangaye *-----------------------------------------*
	
	
	import excel "$rawdata_ucad_mid\Dises year 2_fusion final_3_08042025.UCAD.UGB.xlsx", sheet("4_TH") firstrow clear

  *^*^*rename variables for clarity 

		rename DISES_SEN23119_Parasitologied numero
		rename B initiales
		rename C identificant
		rename D sex_hp
		rename E age_hp
		rename F fu_p1
		rename G omega_vivant_1
		rename H sm_fu_1
		rename I fu_p2
		rename J omega_vivant_2
		rename K sm_fu_2
		rename L p1_kato1_omega
		rename M p1_kato1_k1_epg
		rename N p1_kato2_omega
		rename O p1_kato2_k2_epg
		rename P sh_kk_1
		rename Q p2_kato1_omega
		rename R p2_kato1_k1_epg
		rename S p2_kato2_omega
		rename T p2_kato2_k2_epg
		rename U sh_kk_2
		rename V pzq_1
		
*^*^* label variables
		label variable numero                "Record number"
		label variable initiales            "Initials"
		label variable identificant         "Unique ID"
		label variable sex_hp               "Sex"
		label variable age_hp               "Current age"
		label variable fu_p1                "Follow-up period 1"
		label variable omega_vivant_1       "ω (alive) during FU/P1"
		label variable sm_fu_1              "S. mansoni present at FU/P1"
		label variable fu_p2                "Follow-up period 2"
		label variable omega_vivant_2       "ω (alive) during FU/P2"
		label variable sm_fu_2              "S. mansoni present at FU/P2"
		label variable p1_kato1_omega       "Kato-Katz 1 (P1)"
		label variable p1_kato1_k1_epg      "EPG (P1, slide 1)"
		label variable p1_kato2_omega       "Kato-Katz 2 (P1)"
		label variable p1_kato2_k2_epg      "EPG (P1, slide 2)"
		label variable sh_kk_1              "S. haematobium (P1)"
		label variable p2_kato1_omega       "Kato-Katz 1 (P2)"
		label variable p2_kato1_k1_epg      "EPG (P2, slide 1)"
		label variable p2_kato2_omega       "Kato-Katz 2 (P2)"
		label variable p2_kato2_k2_epg      "EPG (P2, slide 2)"
		label variable sh_kk_2              "S. haematobium (P2)"
		label variable pzq_1                "Date of PZQ treatment"
		
		
	* drop the first 6 rows (they're header or formatting rows)
	
			
	drop in 1/6
	gen notes = ""
	gen hhid_village = "021B"
		order hhid_village
		
				replace notes = age in 57
				replace age_hp = sex_hp in 57
				replace sex_hp = identificant in 57
				replace identificant = initiales in 57
				replace initiales = numero in 57
				replace numero = "" in 57
	
	**drop unneeded/empty rows
		
		drop in 55/56
		drop in 56/58
	
			save "$cleandata_ucad_mid\thiangaye_021B_midline_df.dta", replace 
	
	
**##   Fanaye Diery (062B)
*-----------------------------------------* Midline Village Fanaye Diery *-----------------------------------------*

		import excel "$rawdata_ucad_mid\Dises year 2_fusion final_3_08042025.UCAD.UGB.xlsx", sheet("5_FD") firstrow clear


 

		*^*^*rename variables for clarity 

		rename DISES_SEN23119_Parasitologied numero
		rename B initiales
		rename C identificant
		rename D sex_hp
		rename E age_hp
		rename F fu_p1
		rename G omega_vivant_1
		rename H sm_fu_1
		rename I fu_p2
		rename J omega_vivant_2
		rename K sm_fu_2
		rename L p1_kato1_omega
		rename M p1_kato1_k1_epg
		rename N p1_kato2_omega
		rename O p1_kato2_k2_epg
		rename P sh_kk_1
		rename Q p2_kato1_omega
		rename R p2_kato1_k1_epg
		rename S p2_kato2_omega
		rename T p2_kato2_k2_epg
		rename U sh_kk_2
		rename V pzq_1
		
*^*^* label variables
		label variable numero                "Record number"
		label variable initiales            "Initials"
		label variable identificant         "Unique ID"
		label variable sex_hp               "Sex"
		label variable age_hp               "Current age"
		label variable fu_p1                "Follow-up period 1"
		label variable omega_vivant_1       "ω (alive) during FU/P1"
		label variable sm_fu_1              "S. mansoni present at FU/P1"
		label variable fu_p2                "Follow-up period 2"
		label variable omega_vivant_2       "ω (alive) during FU/P2"
		label variable sm_fu_2              "S. mansoni present at FU/P2"
		label variable p1_kato1_omega       "Kato-Katz 1 (P1)"
		label variable p1_kato1_k1_epg      "EPG (P1, slide 1)"
		label variable p1_kato2_omega       "Kato-Katz 2 (P1)"
		label variable p1_kato2_k2_epg      "EPG (P1, slide 2)"
		label variable sh_kk_1              "S. haematobium (P1)"
		label variable p2_kato1_omega       "Kato-Katz 1 (P2)"
		label variable p2_kato1_k1_epg      "EPG (P2, slide 1)"
		label variable p2_kato2_omega       "Kato-Katz 2 (P2)"
		label variable p2_kato2_k2_epg      "EPG (P2, slide 2)"
		label variable sh_kk_2              "S. haematobium (P2)"
		label variable pzq_1                "Date of PZQ treatment"
		
		
		drop in 1/6
		gen hhid_village = "062B"
			order hhid_village
			
		gen notes = ""
			forvalues i = 50/56 {
				replace notes = fu_p1 in `i'
				replace fu_p1 = "" in `i'
			}
		
		
		
	**drop unneeded/empty rows
	
	drop in 50
	drop in 56/57

		save "$cleandata_ucad_mid\fanaye_diery_062B_midline_df", replace 	 		

		
	**##  Saneinte (031B)
*-----------------------------------------* Midline Village Saneinte *-----------------------------------------*

		import excel "$rawdata_ucad_mid\Dises year 2_fusion final_3_08042025.UCAD.UGB.xlsx", sheet("6_SA") firstrow clear


 

		*^*^*rename variables for clarity 

		rename DISES_SEN23119_Parasitologied numero
		rename B initiales
		rename C identificant
		rename D sex_hp
		rename E age_hp
		rename F fu_p1
		rename G omega_vivant_1
		rename H sm_fu_1
		rename I fu_p2
		rename J omega_vivant_2
		rename K sm_fu_2
		rename L p1_kato1_omega
		rename M p1_kato1_k1_epg
		rename N p1_kato2_omega
		rename O p1_kato2_k2_epg
		rename P sh_kk_1
		rename Q p2_kato1_omega
		rename R p2_kato1_k1_epg
		rename S p2_kato2_omega
		rename T p2_kato2_k2_epg
		rename U sh_kk_2
		rename V pzq_1
		
*^*^* label variables

		label variable numero                "Record number"
		label variable initiales            "Initials"
		label variable identificant         "Unique ID"
		label variable sex_hp               "Sex"
		label variable age_hp               "Current age"
		label variable fu_p1                "Follow-up period 1"
		label variable omega_vivant_1       "ω (alive) during FU/P1"
		label variable sm_fu_1              "S. mansoni present at FU/P1"
		label variable fu_p2                "Follow-up period 2"
		label variable omega_vivant_2       "ω (alive) during FU/P2"
		label variable sm_fu_2              "S. mansoni present at FU/P2"
		label variable p1_kato1_omega       "Kato-Katz 1 (P1)"
		label variable p1_kato1_k1_epg      "EPG (P1, slide 1)"
		label variable p1_kato2_omega       "Kato-Katz 2 (P1)"
		label variable p1_kato2_k2_epg      "EPG (P1, slide 2)"
		label variable sh_kk_1              "S. haematobium (P1)"
		label variable p2_kato1_omega       "Kato-Katz 1 (P2)"
		label variable p2_kato1_k1_epg      "EPG (P2, slide 1)"
		label variable p2_kato2_omega       "Kato-Katz 2 (P2)"
		label variable p2_kato2_k2_epg      "EPG (P2, slide 2)"
		label variable sh_kk_2              "S. haematobium (P2)"
		label variable pzq_1                "Date of PZQ treatment"
		
		
		drop in 1/6
			gen hhid_village = "031B"
				order hhid_village	
		
		gen notes = ""
			
		replace notes = age in 58
		replace age_hp = sex_hp in 58
		replace sex_hp = identificant in 58
		replace identificant = initiales in 58
		replace initiales = numero in 58
		replace numero = "" in 58

		
	**drop unneeded/empty rows
	
		drop in 56/57
		drop in 57
	
		save "$cleandata_ucad_mid\saneinte_031B_midline_df", replace 	 
	
	
**##  Yetti Yone (033B)
*-----------------------------------------* Midline Village Yetti Yone *-----------------------------------------*

		import excel "$rawdata_ucad_mid\Dises year 2_fusion final_3_08042025.UCAD.UGB.xlsx", sheet("7_YY") firstrow clear


 

		*^*^*rename variables for clarity 

		rename A numero
		rename DISES_SEN23119_Parasitologied initiales
		rename C identificant
		rename D sex_hp
		rename E age_hp
		rename F fu_p1
		rename G omega_vivant_1
		rename H sm_fu_1
		rename I fu_p2
		rename J omega_vivant_2
		rename K sm_fu_2
		rename L p1_kato1_omega
		rename M p1_kato1_k1_epg
		rename N p1_kato2_omega
		rename O p1_kato2_k2_epg
		rename P sh_kk_1
		rename Q p2_kato1_omega
		rename R p2_kato1_k1_epg
		rename S p2_kato2_omega
		rename T p2_kato2_k2_epg
		rename U sh_kk_2
		rename V pzq_1
		
*^*^* label variables
		label variable numero                "Record number"
		label variable initiales            "Initials"
		label variable identificant         "Unique ID"
		label variable sex_hp               "Sex"
		label variable age_hp               "Current age"
		label variable fu_p1                "Follow-up period 1"
		label variable omega_vivant_1       "ω (alive) during FU/P1"
		label variable sm_fu_1              "S. mansoni present at FU/P1"
		label variable fu_p2                "Follow-up period 2"
		label variable omega_vivant_2       "ω (alive) during FU/P2"
		label variable sm_fu_2              "S. mansoni present at FU/P2"
		label variable p1_kato1_omega       "Kato-Katz 1 (P1)"
		label variable p1_kato1_k1_epg      "EPG (P1, slide 1)"
		label variable p1_kato2_omega       "Kato-Katz 2 (P1)"
		label variable p1_kato2_k2_epg      "EPG (P1, slide 2)"
		label variable sh_kk_1              "S. haematobium (P1)"
		label variable p2_kato1_omega       "Kato-Katz 1 (P2)"
		label variable p2_kato1_k1_epg      "EPG (P2, slide 1)"
		label variable p2_kato2_omega       "Kato-Katz 2 (P2)"
		label variable p2_kato2_k2_epg      "EPG (P2, slide 2)"
		label variable sh_kk_2              "S. haematobium (P2)"
		label variable pzq_1                "Date of PZQ treatment"
		
		
		drop in 1/6
			gen notes = ""
			gen hhid_village = "033B"
				order hhid_village
				
		
		replace notes = age in 52/57
		replace age_hp = sex_hp in 52/57
		replace sex_hp = identificant in 52/57
		replace identificant = initiales in 52/57
		replace initiales = numero in 52/57
		replace numero = "" in 52/57


		
	**drop unneeded/empty rows
	
	drop in 51
	drop in 57/59
		
		save "$cleandata_ucad_mid\yetti_yone_033B_midline_df", replace 	 		
	
	
	
**##  Yamane (130A)
*-----------------------------------------* Midline Village Yamane *-----------------------------------------*

		import excel "$rawdata_ucad_mid\Dises year 2_fusion final_3_08042025.UCAD.UGB.xlsx", sheet("8_YA") firstrow clear


 

		*^*^*rename variables for clarity 

		rename DISES_SEN23119_Parasitologied numero
		rename B initiales
		rename C identificant
		rename D sex_hp
		rename E age_hp
		rename F fu_p1
		rename G omega_vivant_1
		rename H sm_fu_1
		rename I fu_p2
		rename J omega_vivant_2
		rename K sm_fu_2
		rename L p1_kato1_omega
		rename M p1_kato1_k1_epg
		rename N p1_kato2_omega
		rename O p1_kato2_k2_epg
		rename P sh_kk_1
		rename Q p2_kato1_omega
		rename R p2_kato1_k1_epg
		rename S p2_kato2_omega
		rename T p2_kato2_k2_epg
		rename U sh_kk_2
		rename V pzq_1
		
*^*^* label variables

		label variable numero                "Record number"
		label variable initiales            "Initials"
		label variable identificant         "Unique ID"
		label variable sex_hp               "Sex"
		label variable age_hp               "Current age"
		label variable fu_p1                "Follow-up period 1"
		label variable omega_vivant_1       "ω (alive) during FU/P1"
		label variable sm_fu_1              "S. mansoni present at FU/P1"
		label variable fu_p2                "Follow-up period 2"
		label variable omega_vivant_2       "ω (alive) during FU/P2"
		label variable sm_fu_2              "S. mansoni present at FU/P2"
		label variable p1_kato1_omega       "Kato-Katz 1 (P1)"
		label variable p1_kato1_k1_epg      "EPG (P1, slide 1)"
		label variable p1_kato2_omega       "Kato-Katz 2 (P1)"
		label variable p1_kato2_k2_epg      "EPG (P1, slide 2)"
		label variable sh_kk_1              "S. haematobium (P1)"
		label variable p2_kato1_omega       "Kato-Katz 1 (P2)"
		label variable p2_kato1_k1_epg      "EPG (P2, slide 1)"
		label variable p2_kato2_omega       "Kato-Katz 2 (P2)"
		label variable p2_kato2_k2_epg      "EPG (P2, slide 2)"
		label variable sh_kk_2              "S. haematobium (P2)"
		label variable pzq_1                "Date of PZQ treatment"
		
		
		drop in 1/6
		gen notes = ""
		gen hhid_village = "130A"
			order hhid_village
	
		replace notes = fu_p1 in 53/57
		replace fu_p1 = "" in 53/57
		
			
	**drop unneeded/empty rows
	
	drop in 52
	drop in 57/58
		
		save "$cleandata_ucad_mid\yamane_130A_midline_df", replace 	 		
		
	
	
**##  Diaminar Loyene (130A) CHECK
*-----------------------------------------* Midline Village Diaminar Loyene *-----------------------------------------*


		import excel "$rawdata_ucad_mid\Dises year 2_fusion final_3_08042025.UCAD.UGB.xlsx", sheet("9_DL") firstrow clear


* drop columns that are hidden in raw data_mg

	drop DISES_SEN23119_Parasitologied B 

		*^*^*rename variables for clarity 

		rename C numero
		rename D initiales
		rename E identificant
		rename F sex_hp
		rename G age_hp
		rename H fu_p1
		rename I omega_vivant_1
		rename J sm_fu_1
		rename K fu_p2
		rename L omega_vivant_2
		rename M sm_fu_2
		rename N p1_kato1_omega
		rename O p1_kato1_k1_epg
		rename P p1_kato2_omega
		rename Q p1_kato2_k2_epg
		rename R sh_kk_1
		rename S p2_kato1_omega
		rename T p2_kato1_k1_epg
		rename U p2_kato2_omega
		rename V p2_kato2_k2_epg
		rename W sh_kk_2
		rename X pzq_1
		
*^*^* label variables
		label variable numero                "Record number"
		label variable initiales            "Initials"
		label variable identificant         "Unique ID"
		label variable sex_hp               "Sex"
		label variable age_hp               "Current age"
		label variable fu_p1                "Follow-up period 1"
		label variable omega_vivant_1       "ω (alive) during FU/P1"
		label variable sm_fu_1              "S. mansoni present at FU/P1"
		label variable fu_p2                "Follow-up period 2"
		label variable omega_vivant_2       "ω (alive) during FU/P2"
		label variable sm_fu_2              "S. mansoni present at FU/P2"
		label variable p1_kato1_omega       "Kato-Katz 1 (P1)"
		label variable p1_kato1_k1_epg      "EPG (P1, slide 1)"
		label variable p1_kato2_omega       "Kato-Katz 2 (P1)"
		label variable p1_kato2_k2_epg      "EPG (P1, slide 2)"
		label variable sh_kk_1              "S. haematobium (P1)"
		label variable p2_kato1_omega       "Kato-Katz 1 (P2)"
		label variable p2_kato1_k1_epg      "EPG (P2, slide 1)"
		label variable p2_kato2_omega       "Kato-Katz 2 (P2)"
		label variable p2_kato2_k2_epg      "EPG (P2, slide 2)"
		label variable sh_kk_2              "S. haematobium (P2)"
		label variable pzq_1                "Date of PZQ treatment"
		
		
		drop in 1/6
		gen notes = ""
		gen hhid_village = "022A"
			order hhid_village

		replace notes = fu_p1 in 57
		replace fu_p1 = "" in 57
		

	**drop unneeded/empty rows
	
	drop in 55/56
	drop in 56
		
		save "$cleandata_ucad_mid\diaminar_loyene_022A_midline_df", replace 	
	
*/
	
**##  Kassack Nord (030A)
*-----------------------------------------* Midline Village Kassack Nord *-----------------------------------------*

		import excel "$rawdata_ucad_mid\Dises year 2_fusion final_3_08042025.UCAD.UGB.xlsx", sheet("11_KA") firstrow clear


 

		*^*^*rename variables for clarity 

		rename DISES_SEN23119_Parasitologied numero
		rename B initiales
		rename C identificant
		rename D sex_hp
		rename E age_hp
		rename F fu_p1
		rename G omega_vivant_1
		rename H sm_fu_1
		rename I fu_p2
		rename J omega_vivant_2
		rename K sm_fu_2
		rename L p1_kato1_omega
		rename M p1_kato1_k1_epg
		rename N p1_kato2_omega
		rename O p1_kato2_k2_epg
		rename P sh_kk_1
		rename Q p2_kato1_omega
		rename R p2_kato1_k1_epg
		rename S p2_kato2_omega
		rename T p2_kato2_k2_epg
		rename U sh_kk_2
		rename V pzq_1
		
*^*^* label variables

		label variable numero                "Record number"
		label variable initiales            "Initials"
		label variable identificant         "Unique ID"
		label variable sex_hp               "Sex"
		label variable age_hp               "Current age"
		label variable fu_p1                "Follow-up period 1"
		label variable omega_vivant_1       "ω (alive) during FU/P1"
		label variable sm_fu_1              "S. mansoni present at FU/P1"
		label variable fu_p2                "Follow-up period 2"
		label variable omega_vivant_2       "ω (alive) during FU/P2"
		label variable sm_fu_2              "S. mansoni present at FU/P2"
		label variable p1_kato1_omega       "Kato-Katz 1 (P1)"
		label variable p1_kato1_k1_epg      "EPG (P1, slide 1)"
		label variable p1_kato2_omega       "Kato-Katz 2 (P1)"
		label variable p1_kato2_k2_epg      "EPG (P1, slide 2)"
		label variable sh_kk_1              "S. haematobium (P1)"
		label variable p2_kato1_omega       "Kato-Katz 1 (P2)"
		label variable p2_kato1_k1_epg      "EPG (P2, slide 1)"
		label variable p2_kato2_omega       "Kato-Katz 2 (P2)"
		label variable p2_kato2_k2_epg      "EPG (P2, slide 2)"
		label variable sh_kk_2              "S. haematobium (P2)"
		label variable pzq_1                "Date of PZQ treatment"
		
		drop in 1/6
		gen notes = ""
		gen hhid_village = "030A"
			order hhid_village

		replace notes = fu_p1 in 53/55
			replace fu_p1 = "" in 53/55

		
	**drop unneeded/empty rows
	
	drop in 52
	drop in 55/56
		
		save "$cleandata_ucad_mid\kassack_nord_030A_midline_df", replace 	
		
**##  Ndiamar (Souloul) 020A (correct for kids who refused/absent de 2 passage)
*-----------------------------------------* Midline Village Ndiamar *-----------------------------------------*

		import excel "$rawdata_ucad_mid\Dises year 2_fusion final_3_08042025.UCAD.UGB.xlsx", sheet("12_SO") firstrow clear


 

		*^*^*rename variables for clarity 

		rename DISES_SEN23119_Parasitologied numero
		rename B initiales
		rename C identificant
		rename D sex_hp
		rename E age_hp
		rename F fu_p1
		rename G omega_vivant_1
		rename H sm_fu_1
		rename I fu_p2
		rename J omega_vivant_2
		rename K sm_fu_2
		rename L p1_kato1_omega
		rename M p1_kato1_k1_epg
		rename N p1_kato2_omega
		rename O p1_kato2_k2_epg
		rename P sh_kk_1
		rename Q p2_kato1_omega
		rename R p2_kato1_k1_epg
		rename S p2_kato2_omega
		rename T p2_kato2_k2_epg
		rename U sh_kk_2
		rename V pzq_1
		
*^*^* label variables
		label variable numero                "Record number"
		label variable initiales            "Initials"
		label variable identificant         "Unique ID"
		label variable sex_hp               "Sex"
		label variable age_hp               "Current age"
		label variable fu_p1                "Follow-up period 1"
		label variable omega_vivant_1       "ω (alive) during FU/P1"
		label variable sm_fu_1              "S. mansoni present at FU/P1"
		label variable fu_p2                "Follow-up period 2"
		label variable omega_vivant_2       "ω (alive) during FU/P2"
		label variable sm_fu_2              "S. mansoni present at FU/P2"
		label variable p1_kato1_omega       "Kato-Katz 1 (P1)"
		label variable p1_kato1_k1_epg      "EPG (P1, slide 1)"
		label variable p1_kato2_omega       "Kato-Katz 2 (P1)"
		label variable p1_kato2_k2_epg      "EPG (P1, slide 2)"
		label variable sh_kk_1              "S. haematobium (P1)"
		label variable p2_kato1_omega       "Kato-Katz 1 (P2)"
		label variable p2_kato1_k1_epg      "EPG (P2, slide 1)"
		label variable p2_kato2_omega       "Kato-Katz 2 (P2)"
		label variable p2_kato2_k2_epg      "EPG (P2, slide 2)"
		label variable sh_kk_2              "S. haematobium (P2)"
		label variable pzq_1                "Date of PZQ treatment"
		
		
		drop in 1/6
		gen notes = ""
		gen hhid_village = "020A"
			order hhid_village
			
		replace notes = fu_p1 in 57
		replace fu_p1 = "" in 57



	* drop rows without data 
	
	drop in 56
	drop in 57/59
		
		save "$cleandata_ucad_mid\ndiamar_020A_midline_df", replace 	
		
	
**## El Debiyaye Maraye II (021A) (Maraye)
*-----------------------------------------* Midline Village Maraye *-----------------------------------------*

		import excel "$rawdata_ucad_mid\Dises year 2_fusion final_3_08042025.UCAD.UGB.xlsx", sheet("13_MA") firstrow clear


 

		*^*^*rename variables for clarity 

		rename DISES_SEN23119_Parasitologied numero
		rename B initiales
		rename C identificant
		rename D sex_hp
		rename E age_hp
		rename F fu_p1
		rename G omega_vivant_1
		rename H sm_fu_1
		rename I fu_p2
		rename J omega_vivant_2
		rename K sm_fu_2
		rename L p1_kato1_omega
		rename M p1_kato1_k1_epg
		rename N p1_kato2_omega
		rename O p1_kato2_k2_epg
		rename P sh_kk_1
		rename Q p2_kato1_omega
		rename R p2_kato1_k1_epg
		rename S p2_kato2_omega
		rename T p2_kato2_k2_epg
		rename U sh_kk_2
		rename V pzq_1
		
*^*^* label variables
		label variable numero                "Record number"
		label variable initiales            "Initials"
		label variable identificant         "Unique ID"
		label variable sex_hp               "Sex"
		label variable age_hp               "Current age"
		label variable fu_p1                "Follow-up period 1"
		label variable omega_vivant_1       "ω (alive) during FU/P1"
		label variable sm_fu_1              "S. mansoni present at FU/P1"
		label variable fu_p2                "Follow-up period 2"
		label variable omega_vivant_2       "ω (alive) during FU/P2"
		label variable sm_fu_2              "S. mansoni present at FU/P2"
		label variable p1_kato1_omega       "Kato-Katz 1 (P1)"
		label variable p1_kato1_k1_epg      "EPG (P1, slide 1)"
		label variable p1_kato2_omega       "Kato-Katz 2 (P1)"
		label variable p1_kato2_k2_epg      "EPG (P1, slide 2)"
		label variable sh_kk_1              "S. haematobium (P1)"
		label variable p2_kato1_omega       "Kato-Katz 1 (P2)"
		label variable p2_kato1_k1_epg      "EPG (P2, slide 1)"
		label variable p2_kato2_omega       "Kato-Katz 2 (P2)"
		label variable p2_kato2_k2_epg      "EPG (P2, slide 2)"
		label variable sh_kk_2              "S. haematobium (P2)"
		label variable pzq_1                "Date of PZQ treatment"
		
		
		drop in 1/6
		
		gen notes = ""
		gen hhid_village = "021A"
			order hhid_village

		replace notes = fu_p1 in 47/51
		replace fu_p1 = "" in 47/51
		
	
	**drop unneeded/empty rows
	
	drop in 46
	drop in 51/52
		
	save "$cleandata_ucad_mid\el_debiyaye_maraye_021A_midline_df", replace 		
	
	
	
**## Dioss Peulh (032A)
*-----------------------------------------* Midline Village Dioss Peulh *-----------------------------------------*

		import excel "$rawdata_ucad_mid\Dises year 2_fusion final_3_08042025.UCAD.UGB.xlsx", sheet("14_DP") firstrow clear


 

		*^*^ 

		rename DISES_SEN23119_Parasitologied numero
		rename B initiales
		rename C identificant
		rename D sex_hp
		rename E age_hp
		rename F fu_p1
		rename G omega_vivant_1
		rename H sm_fu_1
		rename I fu_p2
		rename J omega_vivant_2
		rename K sm_fu_2
		rename L p1_kato1_omega
		rename M p1_kato1_k1_epg
		rename N p1_kato2_omega
		rename O p1_kato2_k2_epg
		rename P sh_kk_1
		rename Q p2_kato1_omega
		rename R p2_kato1_k1_epg
		rename S p2_kato2_omega
		rename T p2_kato2_k2_epg
		rename U sh_kk_2
		rename V pzq_1
		
*^*^* label variables

		label variable numero                "Record number"
		label variable initiales            "Initials"
		label variable identificant         "Unique ID"
		label variable sex_hp               "Sex"
		label variable age_hp               "Current age"
		label variable fu_p1                "Follow-up period 1"
		label variable omega_vivant_1       "ω (alive) during FU/P1"
		label variable sm_fu_1              "S. mansoni present at FU/P1"
		label variable fu_p2                "Follow-up period 2"
		label variable omega_vivant_2       "ω (alive) during FU/P2"
		label variable sm_fu_2              "S. mansoni present at FU/P2"
		label variable p1_kato1_omega       "Kato-Katz 1 (P1)"
		label variable p1_kato1_k1_epg      "EPG (P1, slide 1)"
		label variable p1_kato2_omega       "Kato-Katz 2 (P1)"
		label variable p1_kato2_k2_epg      "EPG (P1, slide 2)"
		label variable sh_kk_1              "S. haematobium (P1)"
		label variable p2_kato1_omega       "Kato-Katz 1 (P2)"
		label variable p2_kato1_k1_epg      "EPG (P2, slide 1)"
		label variable p2_kato2_omega       "Kato-Katz 2 (P2)"
		label variable p2_kato2_k2_epg      "EPG (P2, slide 2)"
		label variable sh_kk_2              "S. haematobium (P2)"
		label variable pzq_1                "Date of PZQ treatment"
		
		
		drop in 1/6
		
		gen notes = ""
		gen hhid_village = "032A"
			order hhid_village
			
		
		replace notes = fu_p1 in 51/53
		replace fu_p1 = "" in 51/53


	**drop unneeded/empty rows
	
		drop in 50
		drop in 53/54
			
		save "$cleandata_ucad_mid\dioss_peulh_032A_midline_df", replace 		
		
	
	
**##  Mberaye (023B)
*-----------------------------------------* Midline Village Maraye *-----------------------------------------*

		import excel "$rawdata_ucad_mid\Dises year 2_fusion final_3_08042025.UCAD.UGB.xlsx", sheet("15_MB") firstrow clear

		*^*^*rename variables for clarity 

		rename DISES_SEN23119_Parasitologied numero
		rename B initiales
		rename C identificant
		rename D sex_hp
		rename E age_hp
		rename F fu_p1
		rename G omega_vivant_1
		rename H sm_fu_1
		rename I fu_p2
		rename J omega_vivant_2
		rename K sm_fu_2
		rename L p1_kato1_omega
		rename M p1_kato1_k1_epg
		rename N p1_kato2_omega
		rename O p1_kato2_k2_epg
		rename P sh_kk_1
		rename Q p2_kato1_omega
		rename R p2_kato1_k1_epg
		rename S p2_kato2_omega
		rename T p2_kato2_k2_epg
		rename U sh_kk_2
		rename V pzq_1
		
*^*^* label variables

		label variable numero                "Record number"
		label variable initiales            "Initials"
		label variable identificant         "Unique ID"
		label variable sex_hp               "Sex"
		label variable age_hp               "Current age"
		label variable fu_p1                "Follow-up period 1"
		label variable omega_vivant_1       "ω (alive) during FU/P1"
		label variable sm_fu_1              "S. mansoni present at FU/P1"
		label variable fu_p2                "Follow-up period 2"
		label variable omega_vivant_2       "ω (alive) during FU/P2"
		label variable sm_fu_2              "S. mansoni present at FU/P2"
		label variable p1_kato1_omega       "Kato-Katz 1 (P1)"
		label variable p1_kato1_k1_epg      "EPG (P1, slide 1)"
		label variable p1_kato2_omega       "Kato-Katz 2 (P1)"
		label variable p1_kato2_k2_epg      "EPG (P1, slide 2)"
		label variable sh_kk_1              "S. haematobium (P1)"
		label variable p2_kato1_omega       "Kato-Katz 1 (P2)"
		label variable p2_kato1_k1_epg      "EPG (P2, slide 1)"
		label variable p2_kato2_omega       "Kato-Katz 2 (P2)"
		label variable p2_kato2_k2_epg      "EPG (P2, slide 2)"
		label variable sh_kk_2              "S. haematobium (P2)"
		label variable pzq_1                "Date of PZQ treatment"
		
		
		drop in 1/6
		gen notes = ""
		gen hhid_village = "023B"
			order hhid_village

		replace notes = fu_p1 in 55/57
		replace fu_p1 = "" in 55/57

		
	
	**drop unneeded/empty rows
	
	drop in 54
	drop in 57
		
		save "$cleandata_ucad_mid\mberaye_023B_midline_df", replace 		
		
	
*/


*<><<><><>><><<><><>>
**# CLEAN EPLS MIDLINE DATA
*<><<><><>><><<><><>>	
	
	
	
**##  Malla (131B)
*-----------------------------------------* Village Malla *-----------------------------------------*

		import excel "$rawdata_epls_mid\Dises_Année 2_Compilation data_mg.xlsx", sheet("1_MA") firstrow clear

 
		rename A numero
		rename DISES_SEN23119_Parasitologied initiales
		rename C identificant
		rename D sex_hp
		rename E grade
		rename F fu_p1
		rename G omega_vivant_1
		rename H sm_fu_1
		rename I fu_p2
		rename J omega_vivant_2
		rename K sm_fu_2
		rename L p1_kato1_omega
		rename M p1_kato1_k1_epg
		rename N p1_kato2_omega
		rename O p1_kato2_k2_epg
		rename P sh_kk_1
		rename Q p2_kato1_omega
		rename R p2_kato1_k1_epg
		rename S p2_kato2_omega
		rename T p2_kato2_k2_epg
		rename U sh_kk_2
		rename V pzq_1
		rename W pzq_2
		rename X notes
		
*^*^* label variables

		label variable numero               "Record number"
		label variable initiales            "Initials"
		label variable identificant         "Unique ID"
		label variable sex_hp               "Sex"
		label variable grade               	"Current grade"
		label variable fu_p1                "Follow-up period 1"
		label variable omega_vivant_1       "ω (alive) during FU/P1"
		label variable sm_fu_1              "S. mansoni present at FU/P1"
		label variable fu_p2                "Follow-up period 2"
		label variable omega_vivant_2       "ω (alive) during FU/P2"
		label variable sm_fu_2              "S. mansoni present at FU/P2"
		label variable p1_kato1_omega       "Kato-Katz 1 (P1)"
		label variable p1_kato1_k1_epg      "EPG (P1, slide 1)"
		label variable p1_kato2_omega       "Kato-Katz 2 (P1)"
		label variable p1_kato2_k2_epg      "EPG (P1, slide 2)"
		label variable sh_kk_1              "S. haematobium (P1)"
		label variable p2_kato1_omega       "Kato-Katz 1 (P2)"
		label variable p2_kato1_k1_epg      "EPG (P2, slide 1)"
		label variable p2_kato2_omega       "Kato-Katz 2 (P2)"
		label variable p2_kato2_k2_epg      "EPG (P2, slide 2)"
		label variable sh_kk_2              "S. haematobium (P2)"
		label variable pzq_1				"Date of 1st PZQ treatment post-parasitology"
		label variable pzq_2				"Date of 2nd PZQ treatment post-parasitology"
		label variable notes				"Notes from field team"	

		
					
			**drop unneeded/empty rows
		
		drop in 1/6
		drop in 51/52
		
		** grab ages 

		preserve 
		
			import excel "$rawdata_epls_mid\Dises_Année 2_Compilation data_mg.xlsx", sheet("Consent_MA") firstrow clear
			
			rename B initiales
			rename C identificant
			rename D sex_hp
			rename E age_hp
				label variable age_hp "Current age"
			
			
		keep initiales identificant age_hp sex_hp 
		drop in 1/5
		drop in 51/54
	
			
			tempfile _131B_ages
				save `_131B_ages'
				
		restore 
		

		merge 1:1 sex_hp identificant initiales using `_131B_ages', nogen 
		
			replace grade = age_hp in 51
				replace age_hp = "" in 51
			replace notes = sex_hp in 51
				replace sex_hp = "" in 51
				
		gen hhid_village = "131B"
			order hhid_village
			
		order age_hp, before(grade)

	save "$cleandata_epls_mid\malla_131B_midline_df", replace 	
		

**##  Mbilor (012A)
*-----------------------------------------* Village Mbilor *-----------------------------------------*	
	
	
		import excel "$rawdata_epls_mid\Dises_Année 2_Compilation data_mg.xlsx", sheet("2_MR") firstrow clear

 

		*^*^*rename variables for clarity 

		rename A numero
		rename DISES_SEN23119_Parasitologied initiales
		rename C identificant
		rename D sex_hp
		rename E grade
		rename F fu_p1
		rename G omega_vivant_1
		rename H sm_fu_1
		rename I fu_p2
		rename J omega_vivant_2
		rename K sm_fu_2
		rename L p1_kato1_omega
		rename M p1_kato1_k1_epg
		rename N p1_kato2_omega
		rename O p1_kato2_k2_epg
		rename P sh_kk_1
		rename Q p2_kato1_omega
		rename R p2_kato1_k1_epg
		rename S p2_kato2_omega
		rename T p2_kato2_k2_epg
		rename U sh_kk_2
		rename V pzq_1
		rename W pzq_2
		rename X notes
		
*^*^* label variables

		label variable numero               "Record number"
		label variable initiales            "Initials"
		label variable identificant         "Unique ID"
		label variable sex_hp               "Sex"
		label variable grade                "Current grade"
		label variable fu_p1                "Follow-up period 1"
		label variable omega_vivant_1       "ω (alive) during FU/P1"
		label variable sm_fu_1              "S. mansoni present at FU/P1"
		label variable fu_p2                "Follow-up period 2"
		label variable omega_vivant_2       "ω (alive) during FU/P2"
		label variable sm_fu_2              "S. mansoni present at FU/P2"
		label variable p1_kato1_omega       "Kato-Katz 1 (P1)"
		label variable p1_kato1_k1_epg      "EPG (P1, slide 1)"
		label variable p1_kato2_omega       "Kato-Katz 2 (P1)"
		label variable p1_kato2_k2_epg      "EPG (P1, slide 2)"
		label variable sh_kk_1              "S. haematobium (P1)"
		label variable p2_kato1_omega       "Kato-Katz 1 (P2)"
		label variable p2_kato1_k1_epg      "EPG (P2, slide 1)"
		label variable p2_kato2_omega       "Kato-Katz 2 (P2)"
		label variable p2_kato2_k2_epg      "EPG (P2, slide 2)"
		label variable sh_kk_2              "S. haematobium (P2)"
		label variable pzq_1				"Date of 1st PZQ treatment post-parasitology"
		label variable pzq_2				"Date of 2nd PZQ treatment post-parasitology"
		label variable notes				"Notes from UCAD/EPLS team"	
	
			
			**drop unneeded/empty rows
		
		drop in 1/6
		drop in 53/54
		
		** grab ages 

		preserve 
		
			import excel "$rawdata_epls_mid\Dises_Année 2_Compilation data_mg.xlsx", sheet("Consent MR") firstrow clear
			
			rename B initiales
			rename C identificant
			rename D sex_hp
			rename E age_hp
				label variable age_hp "Current age"
			rename F signature 
			
		keep initiales identificant age_hp sex_hp signature

		drop in 1/5
		drop in 53/56
		drop in 55
	
			
			tempfile _012A_ages
				save `_012A_ages'
				
		restore 
		
		
		merge 1:1 initiales identificant sex_hp using `_012A_ages', nogen 

		** clean up notes
		
		replace notes = sex_hp in 53/54
			replace sex_hp = "" in 53/54
		replace grade = signature in 53/54
			replace signature = "" in 53/54
				drop signature
			
		gen hhid_village = "012A"
		order hhid_village
		
		order age_hp, before(grade)

	save "$cleandata_epls_mid\mbilor_012A_midline_df", replace 		
	

**##  Gueum Yalla (010B)
*-----------------------------------------* Village Gueum Yalla *-----------------------------------------*	
	
	
		import excel "$rawdata_epls_mid\Dises_Année 2_Compilation data_mg.xlsx", sheet("3_GY") firstrow clear

 

		*^*^*rename variables for clarity 

		rename A numero
		rename DISES_SEN23119_Parasitologied initiales
		rename C identificant
		rename D sex_hp
		rename E grade
		rename F fu_p1
		rename G omega_vivant_1
		rename H sm_fu_1
		rename I fu_p2
		rename J omega_vivant_2
		rename K sm_fu_2
		rename L p1_kato1_omega
		rename M p1_kato1_k1_epg
		rename N p1_kato2_omega
		rename O p1_kato2_k2_epg
		rename P sh_kk_1
		rename Q p2_kato1_omega
		rename R p2_kato1_k1_epg
		rename S p2_kato2_omega
		rename T p2_kato2_k2_epg
		rename U sh_kk_2
		rename V pzq_1
		rename W pzq_2
		rename X notes
		
*^*^* label variables

		label variable numero               "Record number"
		label variable initiales            "Initials"
		label variable identificant         "Unique ID"
		label variable sex_hp               "Sex"
		label variable grade                "Current grade"
		label variable fu_p1                "Follow-up period 1"
		label variable omega_vivant_1       "ω (alive) during FU/P1"
		label variable sm_fu_1              "S. mansoni present at FU/P1"
		label variable fu_p2                "Follow-up period 2"
		label variable omega_vivant_2       "ω (alive) during FU/P2"
		label variable sm_fu_2              "S. mansoni present at FU/P2"
		label variable p1_kato1_omega       "Kato-Katz 1 (P1)"
		label variable p1_kato1_k1_epg      "EPG (P1, slide 1)"
		label variable p1_kato2_omega       "Kato-Katz 2 (P1)"
		label variable p1_kato2_k2_epg      "EPG (P1, slide 2)"
		label variable sh_kk_1              "S. haematobium (P1)"
		label variable p2_kato1_omega       "Kato-Katz 1 (P2)"
		label variable p2_kato1_k1_epg      "EPG (P2, slide 1)"
		label variable p2_kato2_omega       "Kato-Katz 2 (P2)"
		label variable p2_kato2_k2_epg      "EPG (P2, slide 2)"
		label variable sh_kk_2              "S. haematobium (P2)"
		label variable pzq_1				"Date of 1st PZQ treatment post-parasitology"
		label variable pzq_2				"Date of 2nd PZQ treatment post-parasitology"
		label variable notes				"Notes from UCAD/EPLS team"	
		
			
			**drop unneeded/empty rows
		
		drop in 1/6
		drop in 51/52
		
		** grab ages 

	preserve 
		
			import excel "$rawdata_epls_mid\Dises_Année 2_Compilation data_mg.xlsx", sheet("Consent GY") firstrow clear
		
		
			rename B initiales
			rename C identificant
			rename D sex_hp
			rename E age_hp
				label variable age_hp "Current age"
			
		
		keep initiales identificant age_hp sex_hp  
		drop in 1/4
		drop in 51/54
	
			
			tempfile _010B_ages
				save `_010B_ages'
				
	restore 
		
	** merge in ages 
			
		merge 1:1 identificant initiales using `_010B_ages', nogen 
	
				
		replace notes = sex_hp in 51/52
			replace sex_hp = "" in 51/52
			
		gen hhid_village = "010B"
			order hhid_village
			
		order age_hp, before(grade)

	save "$cleandata_epls_mid\gueum_yalla_010B_midline_df", replace 		
	
		
**##  Keur Birane Kobar (010A)
*-----------------------------------------* Village Keur Birane Kobar *-----------------------------------------*	
	
	
		import excel "$rawdata_epls_mid\Dises_Année 2_Compilation data_mg.xlsx", sheet("4_KB") firstrow clear

 

		*^*^*rename variables for clarity 

		rename A numero
		rename DISES_SEN23119_Parasitologied initiales
		rename C identificant
		rename D sex_hp
		rename E grade
		rename F fu_p1
		rename G omega_vivant_1
		rename H sm_fu_1
		rename I fu_p2
		rename J omega_vivant_2
		rename K sm_fu_2
		rename L p1_kato1_omega
		rename M p1_kato1_k1_epg
		rename N p1_kato2_omega
		rename O p1_kato2_k2_epg
		rename P sh_kk_1
		rename Q p2_kato1_omega
		rename R p2_kato1_k1_epg
		rename S p2_kato2_omega
		rename T p2_kato2_k2_epg
		rename U sh_kk_2
		rename V pzq_1
		rename W pzq_2
		rename X notes
		
*^*^* label variables

		label variable numero               "Record number"
		label variable initiales            "Initials"
		label variable identificant         "Unique ID"
		label variable sex_hp               "Sex"
		label variable grade                "Current grade"
		label variable fu_p1                "Follow-up period 1"
		label variable omega_vivant_1       "ω (alive) during FU/P1"
		label variable sm_fu_1              "S. mansoni present at FU/P1"
		label variable fu_p2                "Follow-up period 2"
		label variable omega_vivant_2       "ω (alive) during FU/P2"
		label variable sm_fu_2              "S. mansoni present at FU/P2"
		label variable p1_kato1_omega       "Kato-Katz 1 (P1)"
		label variable p1_kato1_k1_epg      "EPG (P1, slide 1)"
		label variable p1_kato2_omega       "Kato-Katz 2 (P1)"
		label variable p1_kato2_k2_epg      "EPG (P1, slide 2)"
		label variable sh_kk_1              "S. haematobium (P1)"
		label variable p2_kato1_omega       "Kato-Katz 1 (P2)"
		label variable p2_kato1_k1_epg      "EPG (P2, slide 1)"
		label variable p2_kato2_omega       "Kato-Katz 2 (P2)"
		label variable p2_kato2_k2_epg      "EPG (P2, slide 2)"
		label variable sh_kk_2              "S. haematobium (P2)"
		label variable pzq_1				"Date of 1st PZQ treatment post-parasitology"
		label variable pzq_2				"Date of 2nd PZQ treatment post-parasitology"
		label variable notes				"Notes from UCAD/EPLS team"	
	
			
			**drop unneeded/empty rows
		
		drop in 1/6
		drop in 54/55
		
		** grab ages 

	preserve 
		
			import excel "$rawdata_epls_mid\Dises_Année 2_Compilation data_mg.xlsx", sheet("Consent KB") firstrow clear
			
			rename B initiales
			rename C identificant
			rename D sex_hp
			rename E age_hp
				label variable age_hp "Current age"

			
		keep initiales identificant age_hp sex_hp 

		drop in 1/5
		drop in 54/57
			
			tempfile _010A_ages
				save `_010A_ages'
				
	restore
		
		
	** merge in ages 
			
		merge 1:1 identificant using `_010A_ages', nogen 
	
			replace grade = age_hp in 56/58
				replace age_hp = "" in 56/58
			replace notes = sex_hp in 56/58
				replace sex_hp = "" in 56/58
			
		gen hhid_village = "010A"
			order hhid_village
		
		order age_hp, before(grade)

	save "$cleandata_epls_mid\keur_birane_kobar_010A_midline_df", replace 		
		
	
		
**##  Ndiakhaye (011B)
*-----------------------------------------* Village Ndiakhaye *-----------------------------------------*	
	
	
		import excel "$rawdata_epls_mid\Dises_Année 2_Compilation data_mg.xlsx", sheet("5_NK") firstrow clear

 

		*^*^*rename variables for clarity 

		rename DISES_SEN23119_Parasitologied numero
		rename B initiales
		rename C identificant
		rename D sex_hp
		rename E grade
		rename F fu_p1
		rename G omega_vivant_1
		rename H sm_fu_1
		rename I fu_p2
		rename J omega_vivant_2
		rename K sm_fu_2
		rename L p1_kato1_omega
		rename M p1_kato1_k1_epg
		rename N p1_kato2_omega
		rename O p1_kato2_k2_epg
		rename P sh_kk_1
		rename Q p2_kato1_omega
		rename R p2_kato1_k1_epg
		rename S p2_kato2_omega
		rename T p2_kato2_k2_epg
		rename U sh_kk_2
		rename V pzq_1
		rename W pzq_2
		rename X notes
		
*^*^* label variables

		label variable numero               "Record number"
		label variable initiales            "Initials"
		label variable identificant         "Unique ID"
		label variable sex_hp               "Sex"
		label variable grade                "Current grade"
		label variable fu_p1                "Follow-up period 1"
		label variable omega_vivant_1       "ω (alive) during FU/P1"
		label variable sm_fu_1              "S. mansoni present at FU/P1"
		label variable fu_p2                "Follow-up period 2"
		label variable omega_vivant_2       "ω (alive) during FU/P2"
		label variable sm_fu_2              "S. mansoni present at FU/P2"
		label variable p1_kato1_omega       "Kato-Katz 1 (P1)"
		label variable p1_kato1_k1_epg      "EPG (P1, slide 1)"
		label variable p1_kato2_omega       "Kato-Katz 2 (P1)"
		label variable p1_kato2_k2_epg      "EPG (P1, slide 2)"
		label variable sh_kk_1              "S. haematobium (P1)"
		label variable p2_kato1_omega       "Kato-Katz 1 (P2)"
		label variable p2_kato1_k1_epg      "EPG (P2, slide 1)"
		label variable p2_kato2_omega       "Kato-Katz 2 (P2)"
		label variable p2_kato2_k2_epg      "EPG (P2, slide 2)"
		label variable sh_kk_2              "S. haematobium (P2)"
		label variable pzq_1				"Date of 1st PZQ treatment post-parasitology"
		label variable pzq_2				"Date of 2nd PZQ treatment post-parasitology"
		label variable notes				"Notes from UCAD/EPLS team"	
		
			**drop unneeded/empty rows
		
		drop in 1/6
		drop in 51/54
		
		** grab ages 

	preserve 
		
			import excel "$rawdata_epls_mid\Dises_Année 2_Compilation data_mg.xlsx", sheet("Consent NK") firstrow clear
			
			rename B initiales
			rename C identificant
			rename D sex_hp
			rename E age_hp
				label variable age_hp "Current age"

			
		keep initiales identificant age_hp sex_hp 

		drop if initiales == "Initiales"
		drop if identificant == ""
			
			tempfile _011B_ages
				save `_011B_ages'
				
	restore
		
		
	** merge in ages 
			
		merge 1:1 initiales identificant sex_hp using `_011B_ages', nogen 
		
		forvalues i = 51/52 { 
	
			replace grade = age_hp in `i'
				replace age_hp = "" in `i'
			replace notes = sex_hp in `i'
				replace sex_hp = "" in `i'
				
				}
			
		gen hhid_village = "011B"
			order hhid_village
			
		order age_hp, before(grade)

	save "$cleandata_epls_mid\ndiakhaye_011B_midline_df", replace 		
		
	 
	 
**##  Foss (121B)
*-----------------------------------------* Village Foss *-----------------------------------------*	
	
	
		import excel "$rawdata_epls_mid\Dises_Année 2_Compilation data_mg.xlsx", sheet("6_FS") firstrow clear

 

		*^*^*rename variables for clarity 

		rename A numero
		rename DISES_SEN23119_Parasitologied initiales
		rename C identificant
		rename D sex_hp
		rename E grade
		rename F fu_p1
		rename G omega_vivant_1
		rename H sm_fu_1
		rename I fu_p2
		rename J omega_vivant_2
		rename K sm_fu_2
		rename L p1_kato1_omega
		rename M p1_kato1_k1_epg
		rename N p1_kato2_omega
		rename O p1_kato2_k2_epg
		rename P sh_kk_1
		rename Q p2_kato1_omega
		rename R p2_kato1_k1_epg
		rename S p2_kato2_omega
		rename T p2_kato2_k2_epg
		rename U sh_kk_2
		rename V pzq_1
		rename W pzq_2
		rename X notes
		
*^*^* label variables

		label variable numero               "Record number"
		label variable initiales            "Initials"
		label variable identificant         "Unique ID"
		label variable sex_hp               "Sex"
		label variable grade                "Current grade"
		label variable fu_p1                "Follow-up period 1"
		label variable omega_vivant_1       "ω (alive) during FU/P1"
		label variable sm_fu_1              "S. mansoni present at FU/P1"
		label variable fu_p2                "Follow-up period 2"
		label variable omega_vivant_2       "ω (alive) during FU/P2"
		label variable sm_fu_2              "S. mansoni present at FU/P2"
		label variable p1_kato1_omega       "Kato-Katz 1 (P1)"
		label variable p1_kato1_k1_epg      "EPG (P1, slide 1)"
		label variable p1_kato2_omega       "Kato-Katz 2 (P1)"
		label variable p1_kato2_k2_epg      "EPG (P1, slide 2)"
		label variable sh_kk_1              "S. haematobium (P1)"
		label variable p2_kato1_omega       "Kato-Katz 1 (P2)"
		label variable p2_kato1_k1_epg      "EPG (P2, slide 1)"
		label variable p2_kato2_omega       "Kato-Katz 2 (P2)"
		label variable p2_kato2_k2_epg      "EPG (P2, slide 2)"
		label variable sh_kk_2              "S. haematobium (P2)"
		label variable pzq_1				"Date of 1st PZQ treatment post-parasitology"
		label variable pzq_2				"Date of 2nd PZQ treatment post-parasitology"
		label variable notes				"Notes from UCAD/EPLS team"	
		

			**drop unneeded/empty rows
		
		drop in 1/6
		drop in 54/55
		
		** grab ages 

	preserve 
		
			import excel "$rawdata_epls_mid\Dises_Année 2_Compilation data_mg.xlsx", sheet("Consent FS") firstrow clear
			
			rename B initiales
			rename C identificant
			rename D sex_hp
			rename E age_hp
				label variable age_hp "Current age"
			
		keep initiales identificant age_hp sex_hp 

		drop if initiales == "Initiales"
		drop if identificant == ""
			
			tempfile _011B_ages
				save `_011B_ages'
				
	restore
		
		
	** merge in ages 
			
		merge 1:1 initiales identificant sex_hp using `_011B_ages', nogen 
		
		forvalues i = 54/55 { 
	
			replace grade = age_hp in `i'
				replace age_hp = "" in `i'
			replace notes = sex_hp in `i'
				replace sex_hp = "" in `i'
				
				}
				
		gen hhid_village = "121B"
			order hhid_village
						
		order age_hp, before(grade)

	save "$cleandata_epls_mid\foss_121B_midline_df", replace 		
		
		
**##  Diaminar (012B)
*-----------------------------------------* Village Diaminar *-----------------------------------------*	
	
	
		import excel "$rawdata_epls_mid\Dises_Année 2_Compilation data_mg.xlsx", sheet("7_DK") firstrow clear

 

		*^*^*rename variables for clarity 

		rename A numero
		rename DISES_SEN23119_Parasitologied initiales
		rename C identificant
		rename D sex_hp
		rename E grade
		rename F fu_p1
		rename G omega_vivant_1
		rename H sm_fu_1
		rename I fu_p2
		rename J omega_vivant_2
		rename K sm_fu_2
		rename L p1_kato1_omega
		rename M p1_kato1_k1_epg
		rename N p1_kato2_omega
		rename O p1_kato2_k2_epg
		rename P sh_kk_1
		rename Q p2_kato1_omega
		rename R p2_kato1_k1_epg
		rename S p2_kato2_omega
		rename T p2_kato2_k2_epg
		rename U sh_kk_2
		rename V pzq_1
		rename W pzq_2
		rename X notes
		
*^*^* label variables

		label variable numero               "Record number"
		label variable initiales            "Initials"
		label variable identificant         "Unique ID"
		label variable sex_hp               "Sex"
		label variable grade                "Current grade"
		label variable fu_p1                "Follow-up period 1"
		label variable omega_vivant_1       "ω (alive) during FU/P1"
		label variable sm_fu_1              "S. mansoni present at FU/P1"
		label variable fu_p2                "Follow-up period 2"
		label variable omega_vivant_2       "ω (alive) during FU/P2"
		label variable sm_fu_2              "S. mansoni present at FU/P2"
		label variable p1_kato1_omega       "Kato-Katz 1 (P1)"
		label variable p1_kato1_k1_epg      "EPG (P1, slide 1)"
		label variable p1_kato2_omega       "Kato-Katz 2 (P1)"
		label variable p1_kato2_k2_epg      "EPG (P1, slide 2)"
		label variable sh_kk_1              "S. haematobium (P1)"
		label variable p2_kato1_omega       "Kato-Katz 1 (P2)"
		label variable p2_kato1_k1_epg      "EPG (P2, slide 1)"
		label variable p2_kato2_omega       "Kato-Katz 2 (P2)"
		label variable p2_kato2_k2_epg      "EPG (P2, slide 2)"
		label variable sh_kk_2              "S. haematobium (P2)"
		label variable pzq_1				"Date of 1st PZQ treatment post-parasitology"
		label variable pzq_2				"Date of 2nd PZQ treatment post-parasitology"
		label variable notes				"Notes from UCAD/EPLS team"	
		
			**drop unneeded/empty rows
		
		drop in 1/6
		drop if identificant == ""
		
		** grab ages 

	preserve 
		
			import excel "$rawdata_epls_mid\Dises_Année 2_Compilation data_mg.xlsx", sheet("Consent DK") firstrow clear
			
			rename B initiales
			rename C identificant
			rename D sex_hp
			rename E age_hp
				label variable age_hp "Current age"

			
		keep initiales identificant age_hp sex_hp 

		drop if initiales == "Initiales"
		drop if identificant == ""
			
			tempfile _012B_ages
				save `_012B_ages'
				
	restore
		
		
	** merge in ages 
			
		merge 1:1 initiales identificant sex_hp using `_012B_ages', nogen 
		
		forvalues i = 50/52 { 
	
			replace grade = age_hp in `i'
				replace age_hp = "" in `i'
			replace notes = sex_hp in `i'
				replace sex_hp = "" in `i'
				
				}
				
	gen hhid_village = "012B"
		order hhid_village
						
		order age_hp, before(grade)

	save "$cleandata_epls_mid\diaminar_012B_midline_df", replace 		
	
		
**##  Syer (120B)
*-----------------------------------------* Village Syer *-----------------------------------------*	
	
	
		import excel "$rawdata_epls_mid\Dises_Année 2_Compilation data_mg.xlsx", sheet("8_ST") firstrow clear

 

		*^*^*rename variables for clarity 

		rename A numero
		rename DISES_SEN23119_Parasitologied initiales
		rename C identificant
		rename D sex_hp
		rename E grade
		rename F fu_p1
		rename G omega_vivant_1
		rename H sm_fu_1
		rename I fu_p2
		rename J omega_vivant_2
		rename K sm_fu_2
		rename L p1_kato1_omega
		rename M p1_kato1_k1_epg
		rename N p1_kato2_omega
		rename O p1_kato2_k2_epg
		rename P sh_kk_1
		rename Q p2_kato1_omega
		rename R p2_kato1_k1_epg
		rename S p2_kato2_omega
		rename T p2_kato2_k2_epg
		rename U sh_kk_2
		rename V pzq_1
		rename W pzq_2
		rename X notes
		
*^*^* label variables

		label variable numero               "Record number"
		label variable initiales            "Initials"
		label variable identificant         "Unique ID"
		label variable sex_hp               "Sex"
		label variable grade                "Current grade"
		label variable fu_p1                "Follow-up period 1"
		label variable omega_vivant_1       "ω (alive) during FU/P1"
		label variable sm_fu_1              "S. mansoni present at FU/P1"
		label variable fu_p2                "Follow-up period 2"
		label variable omega_vivant_2       "ω (alive) during FU/P2"
		label variable sm_fu_2              "S. mansoni present at FU/P2"
		label variable p1_kato1_omega       "Kato-Katz 1 (P1)"
		label variable p1_kato1_k1_epg      "EPG (P1, slide 1)"
		label variable p1_kato2_omega       "Kato-Katz 2 (P1)"
		label variable p1_kato2_k2_epg      "EPG (P1, slide 2)"
		label variable sh_kk_1              "S. haematobium (P1)"
		label variable p2_kato1_omega       "Kato-Katz 1 (P2)"
		label variable p2_kato1_k1_epg      "EPG (P2, slide 1)"
		label variable p2_kato2_omega       "Kato-Katz 2 (P2)"
		label variable p2_kato2_k2_epg      "EPG (P2, slide 2)"
		label variable sh_kk_2              "S. haematobium (P2)"
		label variable pzq_1				"Date of 1st PZQ treatment post-parasitology"
		label variable pzq_2				"Date of 2nd PZQ treatment post-parasitology"
		label variable notes				"Notes from UCAD/EPLS team"	
	
			
			**drop unneeded/empty rows
		
		drop in 1/6
		drop if identificant == ""
		
		** grab ages 

	preserve 
		
			import excel "$rawdata_epls_mid\Dises_Année 2_Compilation data_mg.xlsx", sheet("Consent ST") firstrow clear
			
			rename B initiales
			rename C identificant
			rename D sex_hp
			rename E age_hp
				label variable age_hp "Current age"

			
		keep initiales identificant age_hp sex_hp 

		drop if initiales == "Initiales"
		drop if identificant == ""
			
			tempfile _120B_ages
				save `_120B_ages'
				
	restore
		
		
	** merge in ages 
			
		merge 1:1 initiales identificant sex_hp using `_120B_ages', nogen 
		
		forvalues i = 51/51 { 
	
			replace grade = age_hp in `i'
				replace age_hp = "" in `i'
			replace notes = sex_hp in `i'
				replace sex_hp = "" in `i'
				
				}
				
		gen hhid_village = "120B"
			order hhid_village
			
		order age_hp, before(grade)
		

	save "$cleandata_epls_mid\syer_120B_midline_df", replace 		
		
	
**##  Thilla (023A)
*-----------------------------------------* Village Thilla *-----------------------------------------*	
	
	
		import excel "$rawdata_epls_mid\Dises_Année 2_Compilation data_mg.xlsx", sheet("9_TB") firstrow clear

 

		*^*^*rename variables for clarity 

		rename DISES_SEN23119_Parasitologied numero
		rename B initiales
		rename C identificant
		rename D sex_hp
		rename E grade
		rename F fu_p1
		rename G omega_vivant_1
		rename H sm_fu_1
		rename I fu_p2
		rename J omega_vivant_2
		rename K sm_fu_2
		rename L p1_kato1_omega
		rename M p1_kato1_k1_epg
		rename N p1_kato2_omega
		rename O p1_kato2_k2_epg
		rename P sh_kk_1
		rename Q p2_kato1_omega
		rename R p2_kato1_k1_epg
		rename S p2_kato2_omega
		rename T p2_kato2_k2_epg
		rename U sh_kk_2
		rename V pzq_1
		rename W pzq_2
		rename X notes
		
*^*^* label variables

		label variable numero               "Record number"
		label variable initiales            "Initials"
		label variable identificant         "Unique ID"
		label variable sex_hp               "Sex"
		label variable grade                "Current grade"
		label variable fu_p1                "Follow-up period 1"
		label variable omega_vivant_1       "ω (alive) during FU/P1"
		label variable sm_fu_1              "S. mansoni present at FU/P1"
		label variable fu_p2                "Follow-up period 2"
		label variable omega_vivant_2       "ω (alive) during FU/P2"
		label variable sm_fu_2              "S. mansoni present at FU/P2"
		label variable p1_kato1_omega       "Kato-Katz 1 (P1)"
		label variable p1_kato1_k1_epg      "EPG (P1, slide 1)"
		label variable p1_kato2_omega       "Kato-Katz 2 (P1)"
		label variable p1_kato2_k2_epg      "EPG (P1, slide 2)"
		label variable sh_kk_1              "S. haematobium (P1)"
		label variable p2_kato1_omega       "Kato-Katz 1 (P2)"
		label variable p2_kato1_k1_epg      "EPG (P2, slide 1)"
		label variable p2_kato2_omega       "Kato-Katz 2 (P2)"
		label variable p2_kato2_k2_epg      "EPG (P2, slide 2)"
		label variable sh_kk_2              "S. haematobium (P2)"
		label variable pzq_1				"Date of 1st PZQ treatment post-parasitology"
		label variable pzq_2				"Date of 2nd PZQ treatment post-parasitology"
		label variable notes				"Notes from UCAD/EPLS team"	
	
			
			**drop unneeded/empty rows
		
		drop in 1/6
		drop if identificant == ""
		
		** grab ages 

	preserve 
		
			import excel "$rawdata_epls_mid\Dises_Année 2_Compilation data_mg.xlsx", sheet("Consent TB") firstrow clear
			
			rename B initiales
			rename C identificant
			rename D sex_hp
			rename E age_hp
				label variable age_hp "Current age"

			
		keep initiales identificant age_hp sex_hp 

		drop if initiales == "Initiales"
		drop if identificant == ""
			
			tempfile _023A_ages
				save `_023A_ages'
				
	restore
		
		
	** merge in ages 
			
		merge 1:1 initiales identificant sex_hp using `_023A_ages', nogen 
		
		gen hhid_village = "023A"
			order hhid_village
	
			order age_hp, before(grade)

	save "$cleandata_epls_mid\thilla_023A_midline_df", replace 		
			
	
**##  Minguene Boye (013B)
*-----------------------------------------* Village Minguene Boye *-----------------------------------------*	
	
	
		import excel "$rawdata_epls_mid\Dises_Année 2_Compilation data_mg.xlsx", sheet("10_MI") firstrow clear

 

		*^*^*rename variables for clarity 
		
		rename DISES_SEN23119_Parasitologied numero
		rename B initiales
		rename C identificant
		rename D sex_hp
		rename E grade
		rename F fu_p1
		rename G omega_vivant_1
		rename H sm_fu_1
		rename I fu_p2
		rename J omega_vivant_2
		rename K sm_fu_2
		rename L p1_kato1_omega
		rename M p1_kato1_k1_epg
		rename N p1_kato2_omega
		rename O p1_kato2_k2_epg
		rename P sh_kk_1
		rename Q p2_kato1_omega
		rename R p2_kato1_k1_epg
		rename S p2_kato2_omega
		rename T p2_kato2_k2_epg
		rename U sh_kk_2
		rename V pzq_1
		rename W pzq_2
		rename X notes
		
*^*^* label variables

		label variable numero               "Record number"
		label variable initiales            "Initials"
		label variable identificant         "Unique ID"
		label variable sex_hp               "Sex"
		label variable grade                "Current grade"
		label variable fu_p1                "Follow-up period 1"
		label variable omega_vivant_1       "ω (alive) during FU/P1"
		label variable sm_fu_1              "S. mansoni present at FU/P1"
		label variable fu_p2                "Follow-up period 2"
		label variable omega_vivant_2       "ω (alive) during FU/P2"
		label variable sm_fu_2              "S. mansoni present at FU/P2"
		label variable p1_kato1_omega       "Kato-Katz 1 (P1)"
		label variable p1_kato1_k1_epg      "EPG (P1, slide 1)"
		label variable p1_kato2_omega       "Kato-Katz 2 (P1)"
		label variable p1_kato2_k2_epg      "EPG (P1, slide 2)"
		label variable sh_kk_1              "S. haematobium (P1)"
		label variable p2_kato1_omega       "Kato-Katz 1 (P2)"
		label variable p2_kato1_k1_epg      "EPG (P2, slide 1)"
		label variable p2_kato2_omega       "Kato-Katz 2 (P2)"
		label variable p2_kato2_k2_epg      "EPG (P2, slide 2)"
		label variable sh_kk_2              "S. haematobium (P2)"
		label variable pzq_1				"Date of 1st PZQ treatment post-parasitology"
		label variable pzq_2				"Date of 2nd PZQ treatment post-parasitology"
		label variable notes				"Notes from UCAD/EPLS team"	
			
			**drop unneeded/empty rows
		
		drop in 1/6
		drop if identificant == ""
		
		** grab ages 

	preserve 
		
			import excel "$rawdata_epls_mid\Dises_Année 2_Compilation data_mg.xlsx", sheet("Consent MI") firstrow clear
			
			rename B initiales
			rename C identificant
			rename D sex_hp
			rename E age_hp
				label variable age_hp "Current age"

			
		keep initiales identificant age_hp sex_hp 

		drop if initiales == "Initiales"
		drop if identificant == ""
			
			tempfile _013B_ages
				save `_013B_ages'
				
	restore 
		
		
	** merge in ages 
			
		merge 1:1 initiales identificant sex_hp using `_013B_ages'
		
			replace notes = sex_hp in 53
			replace notes = sex_hp in 56/58
			replace notes = sex_hp in 60/62
				replace sex_hp = "" in 53
				replace sex_hp = "" in 56/58
				replace sex_hp = "" in 60/62
			replace grade = age_hp in 53
			replace grade = age_hp in 56/58
			replace grade = age_hp in 60/62
				replace age_hp = "" in 53
				replace age_hp = "" in 56/58
				replace age_hp = "" in 60/62

		gen hhid_village = "013B"
			order hhid_village	
			
		order age_hp, before(grade)
		
		**KRM - FIX DUPLICATE IDS BY DROPPING ID FROM CONSENT FORM. STILL NEED TO CONFIRM SEX
		
		drop if _merge == 2 & identificant == "3/MI/2/04"
		drop _merge 

	save "$cleandata_epls_mid\minguene_boye_013B_midline_df", replace 		
	
**##  Ndelle Boye (013A)
*-----------------------------------------* Village Ndelle Boye *-----------------------------------------*	
	
	
		import excel "$rawdata_epls_mid\Dises_Année 2_Compilation data_mg.xlsx", sheet("11_NB") firstrow clear

 

		*^*^*rename variables for clarity 
		
		rename DISES_SEN23119_Parasitologied numero
		rename B initiales
		rename C identificant
		rename D sex_hp
		rename E grade
		rename F fu_p1
		rename G omega_vivant_1
		rename H sm_fu_1
		rename I fu_p2
		rename J omega_vivant_2
		rename K sm_fu_2
		rename L p1_kato1_omega
		rename M p1_kato1_k1_epg
		rename N p1_kato2_omega
		rename O p1_kato2_k2_epg
		rename P sh_kk_1
		rename Q p2_kato1_omega
		rename R p2_kato1_k1_epg
		rename S p2_kato2_omega
		rename T p2_kato2_k2_epg
		rename U sh_kk_2
		rename V pzq_1
		rename W pzq_2
		rename X notes
		
*^*^* label variables

		label variable numero               "Record number"
		label variable initiales            "Initials"
		label variable identificant         "Unique ID"
		label variable sex_hp               "Sex"
		label variable grade                "Current grade"
		label variable fu_p1                "Follow-up period 1"
		label variable omega_vivant_1       "ω (alive) during FU/P1"
		label variable sm_fu_1              "S. mansoni present at FU/P1"
		label variable fu_p2                "Follow-up period 2"
		label variable omega_vivant_2       "ω (alive) during FU/P2"
		label variable sm_fu_2              "S. mansoni present at FU/P2"
		label variable p1_kato1_omega       "Kato-Katz 1 (P1)"
		label variable p1_kato1_k1_epg      "EPG (P1, slide 1)"
		label variable p1_kato2_omega       "Kato-Katz 2 (P1)"
		label variable p1_kato2_k2_epg      "EPG (P1, slide 2)"
		label variable sh_kk_1              "S. haematobium (P1)"
		label variable p2_kato1_omega       "Kato-Katz 1 (P2)"
		label variable p2_kato1_k1_epg      "EPG (P2, slide 1)"
		label variable p2_kato2_omega       "Kato-Katz 2 (P2)"
		label variable p2_kato2_k2_epg      "EPG (P2, slide 2)"
		label variable sh_kk_2              "S. haematobium (P2)"
		label variable pzq_1				"Date of 1st PZQ treatment post-parasitology"
		label variable pzq_2				"Date of 2nd PZQ treatment post-parasitology"
		label variable notes				"Notes from field team"	
		

			**drop unneeded/empty rows
		
		drop in 1/6
		drop if identificant == ""
		
		** grab ages 

	preserve 
		
			import excel "$rawdata_epls_mid\Dises_Année 2_Compilation data_mg.xlsx", sheet("Consent NB") firstrow clear
			
			rename B initiales
			rename C identificant
			rename D sex_hp
			rename E age_hp
				label variable age_hp "Current age"

			
		keep initiales identificant age_hp sex_hp 

		drop if initiales == "Initiales"
		drop if identificant == ""
			
			tempfile _013A_ages
				save `_013A_ages'
				
	restore
		
		
	** merge in ages 
			
		merge 1:1 initiales identificant sex_hp using `_013A_ages', nogen 
		
		forvalues i = 51/58 { 
	
			replace grade = age_hp in `i'
				replace age_hp = "" in `i'
			replace notes = sex_hp in `i'
				replace sex_hp = "" in `i'
				
				}

		gen hhid_village = "013A"
			order hhid_village
							
		order age_hp, before(grade)

	save "$cleandata_epls_mid\ndelle_boye_013A_midline_df", replace 		
	
	
**##  Assy (011A)
*-----------------------------------------* Village Assy *-----------------------------------------*	
	
	
		import excel "$rawdata_epls_mid\Dises_Année 2_Compilation data_mg.xlsx", sheet("12_AB") firstrow clear

 

		*^*^*rename variables for clarity 
		
		rename DISES_SEN23119_Parasitologied numero
		rename B initiales
		rename C identificant
		rename D sex_hp
		rename E grade
		rename F fu_p1
		rename G omega_vivant_1
		rename H sm_fu_1
		rename I fu_p2
		rename J omega_vivant_2
		rename K sm_fu_2
		rename L p1_kato1_omega
		rename M p1_kato1_k1_epg
		rename N p1_kato2_omega
		rename O p1_kato2_k2_epg
		rename P sh_kk_1
		rename Q p2_kato1_omega
		rename R p2_kato1_k1_epg
		rename S p2_kato2_omega
		rename T p2_kato2_k2_epg
		rename U sh_kk_2
		rename V pzq_1
		rename W pzq_2
		rename X notes
		
*^*^* label variables

		label variable numero               "Record number"
		label variable initiales            "Initials"
		label variable identificant         "Unique ID"
		label variable sex_hp               "Sex"
		label variable grade                "Current grade"
		label variable fu_p1                "Follow-up period 1"
		label variable omega_vivant_1       "ω (alive) during FU/P1"
		label variable sm_fu_1              "S. mansoni present at FU/P1"
		label variable fu_p2                "Follow-up period 2"
		label variable omega_vivant_2       "ω (alive) during FU/P2"
		label variable sm_fu_2              "S. mansoni present at FU/P2"
		label variable p1_kato1_omega       "Kato-Katz 1 (P1)"
		label variable p1_kato1_k1_epg      "EPG (P1, slide 1)"
		label variable p1_kato2_omega       "Kato-Katz 2 (P1)"
		label variable p1_kato2_k2_epg      "EPG (P1, slide 2)"
		label variable sh_kk_1              "S. haematobium (P1)"
		label variable p2_kato1_omega       "Kato-Katz 1 (P2)"
		label variable p2_kato1_k1_epg      "EPG (P2, slide 1)"
		label variable p2_kato2_omega       "Kato-Katz 2 (P2)"
		label variable p2_kato2_k2_epg      "EPG (P2, slide 2)"
		label variable sh_kk_2              "S. haematobium (P2)"
		label variable pzq_1				"Date of 1st PZQ treatment post-parasitology"
		label variable pzq_2				"Date of 2nd PZQ treatment post-parasitology"
		label variable notes				"Notes from field team"	
	
			
			**drop unneeded/empty rows
		
		drop in 1/6
		drop if identificant == ""
		
		** grab ages 

	preserve 
		
			import excel "$rawdata_epls_mid\Dises_Année 2_Compilation data_mg.xlsx", sheet("Consent AB") firstrow clear
			
			rename B initiales
			rename C identificant
			rename D sex_hp
			rename E age_hp
				label variable age_hp "Current age"

			
		keep initiales identificant age_hp sex_hp 

		drop if initiales == "Initiales"
		drop if identificant == ""
			
			tempfile _011A_ages
				save `_011A_ages'
				
	restore
		
		
	** merge in ages 
			
		merge 1:1 initiales identificant sex_hp using `_011A_ages', nogen 
		
		forvalues i = 52/58 { 
	
			replace grade = age_hp in `i'
				replace age_hp = "" in `i'
			replace notes = sex_hp in `i'
				replace sex_hp = "" in `i'
				
				}

		gen hhid_village = "011A"
			order hhid_village
		order age_hp, before(grade)

	save "$cleandata_epls_mid\assy_011A_midline_df", replace 		
	
	
**##  Mbakhana (122A)
*-----------------------------------------* Village Mbakhana *-----------------------------------------*	
	
	
		import excel "$rawdata_epls_mid\Dises_Année 2_Compilation data_mg.xlsx", sheet("13_MB") firstrow clear

 

		*^*^*rename variables for clarity 
		
		rename DISES_SEN23119_Parasitologied numero
		rename B initiales
		rename C identificant
		rename D sex_hp
		rename E grade
		rename F fu_p1
		rename G omega_vivant_1
		rename H sm_fu_1
		rename I fu_p2
		rename J omega_vivant_2
		rename K sm_fu_2
		rename L p1_kato1_omega
		rename M p1_kato1_k1_epg
		rename N p1_kato2_omega
		rename O p1_kato2_k2_epg
		rename P sh_kk_1
		rename Q p2_kato1_omega
		rename R p2_kato1_k1_epg
		rename S p2_kato2_omega
		rename T p2_kato2_k2_epg
		rename U sh_kk_2
		rename V pzq_1
		rename W pzq_2
		rename X notes
		
*^*^* label variables

		label variable numero               "Record number"
		label variable initiales            "Initials"
		label variable identificant         "Unique ID"
		label variable sex_hp               "Sex"
		label variable grade                "Current grade"
		label variable fu_p1                "Follow-up period 1"
		label variable omega_vivant_1       "ω (alive) during FU/P1"
		label variable sm_fu_1              "S. mansoni present at FU/P1"
		label variable fu_p2                "Follow-up period 2"
		label variable omega_vivant_2       "ω (alive) during FU/P2"
		label variable sm_fu_2              "S. mansoni present at FU/P2"
		label variable p1_kato1_omega       "Kato-Katz 1 (P1)"
		label variable p1_kato1_k1_epg      "EPG (P1, slide 1)"
		label variable p1_kato2_omega       "Kato-Katz 2 (P1)"
		label variable p1_kato2_k2_epg      "EPG (P1, slide 2)"
		label variable sh_kk_1              "S. haematobium (P1)"
		label variable p2_kato1_omega       "Kato-Katz 1 (P2)"
		label variable p2_kato1_k1_epg      "EPG (P2, slide 1)"
		label variable p2_kato2_omega       "Kato-Katz 2 (P2)"
		label variable p2_kato2_k2_epg      "EPG (P2, slide 2)"
		label variable sh_kk_2              "S. haematobium (P2)"
		label variable pzq_1				"Date of 1st PZQ treatment post-parasitology"
		label variable pzq_2				"Date of 2nd PZQ treatment post-parasitology"
		label variable notes				"Notes from field team"	
		
			
			**drop unneeded/empty rows
		
		drop in 1/6
		drop if identificant == ""
		
		** grab ages 

	preserve 
		
			import excel "$rawdata_epls_mid\Dises_Année 2_Compilation data_mg.xlsx", sheet("Consent _MB") firstrow clear
			
			rename B initiales
			rename C identificant
			rename D sex_hp
			rename E age_hp
				label variable age_hp "Current age"

			
		keep initiales identificant age_hp sex_hp 

		drop if initiales == "Initiales"
		drop if identificant == ""
			
			tempfile _122A_ages
				save `_122A_ages'
				
	restore
		
		
	** merge in ages 
			
		merge 1:1 initiales identificant sex_hp using `_122A_ages', nogen 
		
		forvalues i = 51/52 { 
	
			replace grade = age_hp in `i'
				replace age_hp = "" in `i'
			replace notes = sex_hp in `i'
				replace sex_hp = "" in `i'
				
				}
					
					
		gen hhid_village = "122A"
			order hhid_village
		order age_hp, before(grade)

	save "$cleandata_epls_mid\mbakhana_122A_midline_df", replace 		
	
		
**##  Mbarigo (123A)
*-----------------------------------------* Village Mbarigo *-----------------------------------------*	
	
	
		import excel "$rawdata_epls_mid\Dises_Année 2_Compilation data_mg.xlsx", sheet("14_MO") firstrow clear

 

		*^*^*rename variables for clarity 
		
		rename DISES_SEN23119_Parasitologied numero
		rename B initiales
		rename C identificant
		rename D sex_hp
		rename E grade
		rename F fu_p1
		rename G omega_vivant_1
		rename H sm_fu_1
		rename I fu_p2
		rename J omega_vivant_2
		rename K sm_fu_2
		rename L p1_kato1_omega
		rename M p1_kato1_k1_epg
		rename N p1_kato2_omega
		rename O p1_kato2_k2_epg
		rename P sh_kk_1
		rename Q p2_kato1_omega
		rename R p2_kato1_k1_epg
		rename S p2_kato2_omega
		rename T p2_kato2_k2_epg
		rename U sh_kk_2
		rename V pzq_1
		rename W pzq_2
		rename X notes
		
*^*^* label variables

		label variable numero               "Record number"
		label variable initiales            "Initials"
		label variable identificant         "Unique ID"
		label variable sex_hp               "Sex"
		label variable grade                "Current grade"
		label variable fu_p1                "Follow-up period 1"
		label variable omega_vivant_1       "ω (alive) during FU/P1"
		label variable sm_fu_1              "S. mansoni present at FU/P1"
		label variable fu_p2                "Follow-up period 2"
		label variable omega_vivant_2       "ω (alive) during FU/P2"
		label variable sm_fu_2              "S. mansoni present at FU/P2"
		label variable p1_kato1_omega       "Kato-Katz 1 (P1)"
		label variable p1_kato1_k1_epg      "EPG (P1, slide 1)"
		label variable p1_kato2_omega       "Kato-Katz 2 (P1)"
		label variable p1_kato2_k2_epg      "EPG (P1, slide 2)"
		label variable sh_kk_1              "S. haematobium (P1)"
		label variable p2_kato1_omega       "Kato-Katz 1 (P2)"
		label variable p2_kato1_k1_epg      "EPG (P2, slide 1)"
		label variable p2_kato2_omega       "Kato-Katz 2 (P2)"
		label variable p2_kato2_k2_epg      "EPG (P2, slide 2)"
		label variable sh_kk_2              "S. haematobium (P2)"
		label variable pzq_1				"Date of 1st PZQ treatment post-parasitology"
		label variable pzq_2				"Date of 2nd PZQ treatment post-parasitology"
		label variable notes				"Notes from field team"	
		
			
			**drop unneeded/empty rows
		
		drop in 1/6
		drop if identificant == ""
		
		** grab ages 

	preserve 
		
			import excel "$rawdata_epls_mid\Dises_Année 2_Compilation data_mg.xlsx", sheet("Consent MO") firstrow clear
			
			rename B initiales
			rename C identificant
			rename D sex_hp
			rename E age_hp
				label variable age_hp "Current age"

			
		keep initiales identificant age_hp sex_hp 

		drop if initiales == "Initiales"
		drop if identificant == ""
			
			tempfile _123A_ages
				save `_123A_ages'
				
	restore
		
		
	** merge in ages 
			
		merge 1:1 initiales identificant sex_hp using `_123A_ages', nogen 
		
		forvalues i = 51/54 { 
	
			replace grade = age_hp in `i'
				replace age_hp = "" in `i'
			replace notes = sex_hp in `i'
				replace sex_hp = "" in `i'
				
				}
				
		gen hhid_village = "123A"
			order hhid_village							
		order age_hp, before(grade)

	save "$cleandata_epls_mid\mbarigo_123A_midline_df", replace 			
			
*<><<><><>><><<><><>>
**# APPEND UCAD DATA
*<><<><><>><><<><><>>
	
	use "$cleandata_ucad_mid\geuo_033a_midline_df.dta", clear
		append using "$cleandata_ucad_mid\dodel_072b_midline_df.dta"
		append using "$cleandata_ucad_mid\diabobe_030b_midline_df.dta"
		append using "$cleandata_ucad_mid\thiangaye_021b_midline_df.dta"
		append using "$cleandata_ucad_mid\ndiayene_pendao_020b_midline_df.dta"
		append using "$cleandata_ucad_mid\fanaye_diery_062b_midline_df.dta"
		append using "$cleandata_ucad_mid\saneinte_031b_midline_df.dta"
		append using "$cleandata_ucad_mid\yetti_yone_033b_midline_df.dta"
		append using "$cleandata_ucad_mid\yamane_130a_midline_df.dta"
		append using "$cleandata_ucad_mid\diaminar_loyene_022a_midline_df.dta"
		append using "$cleandata_ucad_mid\kassack_nord_030a_midline_df.dta"
		append using "$cleandata_ucad_mid\ndiamar_020a_midline_df.dta"
		append using "$cleandata_ucad_mid\el_debiyaye_maraye_021a_midline_df.dta"
		append using "$cleandata_ucad_mid\dioss_peulh_032a_midline_df.dta"
		append using "$cleandata_ucad_mid\mberaye_023b_midline_df.dta"

	

/* 
	clear
	local folder "$cleandata_ucad_mid"  

	cd "`folder'"
	local files: dir . files "*.dta"

	foreach file in `files' {
		di "Appending `file'"
		append using "`file'"

	}
*/

	save "$cleandata_ucad_mid\complete_midline_ucad_parasitology_df.dta", replace 
	
	
	
			
*<><<><><>><><<><><>>
**# APPEND EPLS DATA
*<><<><><>><><<><><>>

	use "$cleandata_epls_mid\thilla_023A_midline_df.dta", clear
		append using "$cleandata_epls_mid\syer_120B_midline_df.dta"
		append using "$cleandata_epls_mid\ndiakhaye_011B_midline_df.dta"
		append using "$cleandata_epls_mid\ndelle_boye_013A_midline_df.dta"
		append using "$cleandata_epls_mid\minguene_boye_013B_midline_df.dta"
		append using "$cleandata_epls_mid\mbilor_012A_midline_df.dta"
		append using "$cleandata_epls_mid\mbarigo_123A_midline_df.dta"
		append using "$cleandata_epls_mid\mbakhana_122A_midline_df.dta"
		append using "$cleandata_epls_mid\malla_131B_midline_df.dta"
		append using "$cleandata_epls_mid\keur_birane_kobar_010A_midline_df.dta"
		append using "$cleandata_epls_mid\gueum_yalla_010B_midline_df.dta"
		append using "$cleandata_epls_mid\foss_121B_midline_df.dta"
		append using "$cleandata_epls_mid\diaminar_012B_midline_df.dta"
		append using "$cleandata_epls_mid\assy_011A_midline_df.dta"

	save "$cleandata_epls_mid\complete_midline_epls_parasitology_df.dta", replace 
/* 
	clear
	local folder "$cleandata_epls_mid"  

	cd "`folder'"
	local files: dir . files "*.dta"

	foreach file in `files' {
		di "Appending `file'"
		append using "`file'"
	}

*/
	
			
*<><<><><>><><<><><>>
**# APPEND FINAL MIDLINE DF
*<><<><><>><><<><><>>
	
	

 use "$cleandata_epls_mid\complete_midline_epls_parasitology_df.dta", clear
	append using "$cleandata_ucad_mid\complete_midline_ucad_parasitology_df.dta"
	
		gen round = 1

	save "$dataexport\complete_midline_parasitology_df.dta", replace 
		export excel using "$dataexport/complete_midline_parasitology_df.xlsx", firstrow(variables) replace

	
	
*** end of .do file












