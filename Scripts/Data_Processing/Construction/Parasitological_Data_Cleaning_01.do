*==============================================================================
* written by: Kateri Mouawad
* Created: February 2025
* Updates recorded in GitHub


* <><<><><>> Read Me  <><<><><>>


		*** This .do file processes:
									* DISES UCAD.UGB.1_VILLAGES.PARASITOLOGY DATA ALL VILLAGES.controled_1_25.06.24.xlsx
									* Dises year 2_fusion final_3_08042025.UCAD.UGB.xlsx

		*** This .do file outputs: (need to finish updating output)
								
			**			ndiamar_020A_midline_left_school.dta
			**			ndiamar_020A_midline_df
			**			el_debiyaye_maraye_021A_midline_left_school.dta
			**			el_debiyaye_maraye_021A_midline_df
			**			dioss_peulh_032A_midline_left_school.dta
			**			dioss_peulh_032A_midline_df
			**			mberaye_023B_midline_left_school.dta
			**			mberaye_023B_midline_df
						
								
		*** PROCEDURE:
		*	 This .do file simply puts the UCAD/EPLS data into a .dta format with variable names and labels for both baseline and midline data. Will update to include endline data. 
		
				* 1) Import raw UCAD/EPLS data by village 
				* 2) rename variables
				* 3) drop useless rows
				* 4) label variables
				* 5) save .dta

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
	global cleandata_ucad_mid "$master\Data_Management\Data\_Partner_CleanData\Parasitological_Data\UCAD_Data\Midline"

	global cleandata_epls_base "$master\Data_Management\Data\_Partner_CleanData\Parasitological_Data\EPLS_Data\Baseline"
	global cleandata_epls_mid "$master\Data_Management\Data\_Partner_CleanData\Parasitological_Data\EPLS_Data\Midline"
	
	global rawdata_ucad_mid "$master\Data_Management\Data\_Partner_RawData\Parasitological_Data\UCAD_Data\Midline"
	global rawdata_ucad_base "$master\Data_Management\Data\_Partner_RawData\Parasitological_Data\UCAD_Data\Baseline"

	global rawdata_epls_mid "$master\Data_Management\Data\_Partner_RawData\Parasitological_Data\EPLS_Data\Midline"
	global rawdata_epls_base "$master\Data_Management\Data\_Partner_RawData\Parasitological_Data\EPLS_Data\Baseline"
	
 
*<><<><><>><><<><><>>
**# CLEAN BASELINE UCAD DATA
*<><<><><>><><<><><>>

/* 

**##  Geuo (033A)
*-----------------------------------------* Village Geuo *-----------------------------------------*

		import excel "$rawdata_ucad_base\DISES UCAD.UGB.1_VILLAGES.PARASITOLOGY DATA ALL VILLAGES.controled_1_25.06.24.xlsx", sheet("10_GU") firstrow clear


*rename variables for clarity 

		*^*^*rename variables for clarity 

		rename DISES_SEN2151_Parasitologiede numero
		rename B initiales
		rename C identifiant
		rename D sexe
		rename E age
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
		label variable identifiant "Unique ID"
		label variable sexe "Sex"
		label variable age "Current age"
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
		
		
		drop in 1/6
		drop in 57


	save "$cleandata_ucad_base\geuo_033A_baseline_df", replace 
	
**## Dodel (072B)
*-----------------------------------------* Baseline Village Dodel *-----------------------------------------*
	
		import excel "$rawdata_ucad_base\DISES UCAD.UGB.1_VILLAGES.PARASITOLOGY DATA ALL VILLAGES.controled_1_25.06.24.xlsx", sheet("1_DO") firstrow clear


*rename variables for clarity 

		*^*^*rename variables for clarity 

		rename DISES_SEN2151_Parasitologiede numero
		rename B initiales
		rename C identifiant
		rename D sexe
		rename E age
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
		label variable identifiant "Unique ID"
		label variable sexe "Sex"
		label variable age "Current age"
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
		
		
		drop in 1/6
		drop if identifiant == "Control realized by Bruno Senghor 21.06.2024"

	save "$cleandata_ucad_base\dodel_072B_baseline_df", replace 
	
**## Diabobe (030B)
*-----------------------------------------*  Baseline Village Diabobe *-----------------------------------------*
	
		import excel "$rawdata_ucad_base\DISES UCAD.UGB.1_VILLAGES.PARASITOLOGY DATA ALL VILLAGES.controled_1_25.06.24.xlsx", sheet("2_DI") firstrow clear


*rename variables for clarity 

		*^*^*rename variables for clarity 

		rename CartoBil_SEN2151_Parasitologie numero
		rename B initiales
		rename C identifiant
		rename D sexe
		rename E age
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
		label variable identifiant "Unique ID"
		label variable sexe "Sex"
		label variable age "Current age"
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
		
		
		drop in 1/4
		drop if identifiant == "Control realized by Bruno Senghor 21.06.2024"

	save "$cleandata_ucad_base\diabobe_030B_baseline_df", replace 
	
	
**##  Ndiayene Pendao (020B)
*-----------------------------------------* Baseline Village Ndiayene Pendao *-----------------------------------------*
	
		import excel "$rawdata_ucad_base\DISES UCAD.UGB.1_VILLAGES.PARASITOLOGY DATA ALL VILLAGES.controled_1_25.06.24.xlsx", sheet("3_NP") firstrow clear


*rename variables for clarity 

		*^*^*rename variables for clarity 

		rename A numero
		rename DISES_SEN2151_Parasitologiede initiales
		rename C identifiant
		rename D sexe
		rename E age
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
		label variable identifiant "Unique ID"
		label variable sexe "Sex"
		label variable age "Current age"
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
		
		
		drop in 1/4
		drop in 54/55

	save "$cleandata_ucad_base\ndiayene_pendao_020B_baseline_df", replace 
	
**##   Thiangaye (021B)
*-----------------------------------------* Baseline Village Thiangaye *-----------------------------------------*

		import excel "$rawdata_ucad_base\DISES UCAD.UGB.1_VILLAGES.PARASITOLOGY DATA ALL VILLAGES.controled_1_25.06.24.xlsx", sheet("4_TH") firstrow clear


*rename variables for clarity 

		*^*^*rename variables for clarity 

		rename DISES_SEN2151_Parasitologiede numero
		rename B initiales
		rename C identifiant
		rename D sexe
		rename E age
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
		label variable identifiant "Unique ID"
		label variable sexe "Sex"
		label variable age "Current age"
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
		
		
		drop in 1/4
		drop in 56/57

	save "$cleandata_ucad_base\thiangaye_021B_baseline_df", replace 	

	
	
**##   Fanaye Diery (062B)
*-----------------------------------------* Baseline Village Fanaye Diery *-----------------------------------------*

		import excel "$rawdata_ucad_base\DISES UCAD.UGB.1_VILLAGES.PARASITOLOGY DATA ALL VILLAGES.controled_1_25.06.24.xlsx", sheet("5_FD") firstrow clear


*rename variables for clarity 

		*^*^*rename variables for clarity 

		rename DISES_SEN2151_Parasitologiede numero
		rename B initiales
		rename C identifiant
		rename D sexe
		rename E age
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
		label variable identifiant "Unique ID"
		label variable sexe "Sex"
		label variable age "Current age"
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
		
		
		drop in 1/6
		drop in 56/57

	save "$cleandata_ucad_base\fanaye_diery_062B_baseline_df", replace 	 	
	
	
	
	
**##   Saneinte (031B)

*-----------------------------------------* Baseline Village Saneinte *-----------------------------------------*

		import excel "$rawdata_ucad_base\DISES UCAD.UGB.1_VILLAGES.PARASITOLOGY DATA ALL VILLAGES.controled_1_25.06.24.xlsx", sheet("6_SA") firstrow clear


*rename variables for clarity 

		*^*^*rename variables for clarity 

		rename DISES_SEN2151_Parasitologiede numero
		rename B initiales
		rename C identifiant
		rename D sexe
		rename E age
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
		label variable identifiant "Unique ID"
		label variable sexe "Sex"
		label variable age "Current age"
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
		
		
		drop in 1/4
		drop in 57

	save "$cleandata_ucad_base\saneinte_031B_baseline_df", replace 	 	
	
**##   Yetti Yone (033B)
*-----------------------------------------* Baseline Village Yetti Yone *-----------------------------------------*

		import excel "$rawdata_ucad_base\DISES UCAD.UGB.1_VILLAGES.PARASITOLOGY DATA ALL VILLAGES.controled_1_25.06.24.xlsx", sheet("7_YY") firstrow clear


*rename variables for clarity 

		*^*^*rename variables for clarity 

		rename A numero
		rename DISES_SEN2151_Parasitologiede initiales
		rename C identifiant
		rename D sexe
		rename E age
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
		label variable identifiant "Unique ID"
		label variable sexe "Sex"
		label variable age "Current age"
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
		
				save "$cleandata_ucad_mid\yetti_yone_033B_baseline_left_school.dta", replace 
		
	restore 
				
		drop in 57/60

	save "$cleandata_ucad_base\yetti_yone_033B_baseline_df", replace 	 	
		
**##   Yamane (130A)
*-----------------------------------------* Baseline Village Yamane *-----------------------------------------*

		import excel "$rawdata_ucad_base\DISES UCAD.UGB.1_VILLAGES.PARASITOLOGY DATA ALL VILLAGES.controled_1_25.06.24.xlsx", sheet("8_YA") firstrow clear


*rename variables for clarity 

		*^*^*rename variables for clarity 

		rename A numero
		rename DISES_SEN2151_Parasitologiede initiales
		rename C identifiant
		rename D sexe
		rename E age
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
		label variable identifiant "Unique ID"
		label variable sexe "Sex"
		label variable age "Current age"
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
		
		
		drop in 1/4
				
		drop in 57

	save "$cleandata_ucad_base\yamane_130A_baseline_df", replace 
	

	**##   Diaminar Loyene (130A)

*-----------------------------------------* Baseline Village Diaminar Loyene *-----------------------------------------*

		import excel "$rawdata_ucad_base\DISES UCAD.UGB.1_VILLAGES.PARASITOLOGY DATA ALL VILLAGES.controled_1_25.06.24.xlsx", sheet("9_DL") firstrow clear


*rename variables for clarity 

		*^*^*rename variables for clarity 

		rename DISES_SEN2151_Parasitologiede numero
		rename B initiales
		rename C identifiant
		rename D sexe
		rename E age
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
		label variable identifiant "Unique ID"
		label variable sexe "Sex"
		label variable age "Current age"
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
		
		
		drop in 1/4
				
		drop in 56/57

			save "$cleandata_ucad_base\diaminar_loyene_130A_baseline_df", replace 	 			
	
**##   Kassack Nord (030A)
*-----------------------------------------* Baseline Village Kassack Nord *-----------------------------------------*

		import excel "$rawdata_ucad_base\DISES UCAD.UGB.1_VILLAGES.PARASITOLOGY DATA ALL VILLAGES.controled_1_25.06.24.xlsx", sheet("11_KA") firstrow clear


*rename variables for clarity 

		*^*^*rename variables for clarity 

		rename DISES_SEN2151_Parasitologiede numero
		rename B initiales
		rename C identifiant
		rename D sexe
		rename E age
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
		label variable identifiant "Unique ID"
		label variable sexe "Sex"
		label variable age "Current age"
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
		
		
		drop in 1/6
				
		drop in 55

			save "$cleandata_ucad_base\kassack_nord_030A_baseline_df", replace 	 			
	
	
	
**##   Ndiamar (Souloul) (020A)
*-----------------------------------------* Baseline Village Ndiamar *-----------------------------------------*

		import excel "$rawdata_ucad_base\DISES UCAD.UGB.1_VILLAGES.PARASITOLOGY DATA ALL VILLAGES.controled_1_25.06.24.xlsx", sheet("12_SO") firstrow clear


*rename variables for clarity 

		*^*^*rename variables for clarity 

		rename DISES_SEN2151_Parasitologiede numero
		rename B initiales
		rename C identifiant
		rename D sexe
		rename E age
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
		label variable identifiant "Unique ID"
		label variable sexe "Sex"
		label variable age "Current age"
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
		
		
		drop in 1/6
				
		drop in 57

			save "$cleandata_ucad_base\ndiamar_020A_baseline_df", replace 	 				
	
	
	
**## El Debiyaye Maraye II (021A) (Maraye)
*-----------------------------------------* Baseline Village Maraye *-----------------------------------------*

		import excel "$rawdata_ucad_base\DISES UCAD.UGB.1_VILLAGES.PARASITOLOGY DATA ALL VILLAGES.controled_1_25.06.24.xlsx", sheet("13_MA") firstrow clear


*rename variables for clarity 

		*^*^*rename variables for clarity 

		rename DISES_SEN2151_Parasitologiede numero
		rename B initiales
		rename C identifiant
		rename D sexe
		rename E age
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
		label variable identifiant "Unique ID"
		label variable sexe "Sex"
		label variable age "Current age"
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
		
		
		drop in 1/6
				
		drop in 51

			save "$cleandata_ucad_base\el_debiyaye_maraye_021A_baseline_df", replace 	 				
		
	
	
**## Dioss Peulh (032A)
*-----------------------------------------* Baseline Village Dioss Peulh *-----------------------------------------*

		import excel "$rawdata_ucad_base\DISES UCAD.UGB.1_VILLAGES.PARASITOLOGY DATA ALL VILLAGES.controled_1_25.06.24.xlsx", sheet("14_DP") firstrow clear


*rename variables for clarity 

		*^*^*rename variables for clarity 

		rename DISES_SEN2151_Parasitologiede numero
		rename B initiales
		rename C identifiant
		rename D sexe
		rename E age
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
		label variable identifiant "Unique ID"
		label variable sexe "Sex"
		label variable age "Current age"
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
		
		
		drop in 1/6
				
		drop in 53

			save "$cleandata_ucad_base\dioss_peulh_032A_baseline_df", replace 	 				
		
**## Mberaye (023B)
*-----------------------------------------* Baseline Village Mberaye *-----------------------------------------*

		import excel "$rawdata_ucad_base\DISES UCAD.UGB.1_VILLAGES.PARASITOLOGY DATA ALL VILLAGES.controled_1_25.06.24.xlsx", sheet("15_MB") firstrow clear


*rename variables for clarity 

		*^*^*rename variables for clarity 

		rename DISES_SEN2151_Parasitologiede numero
		rename B initiales
		rename C identifiant
		rename D sexe
		rename E age
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
		label variable identifiant "Unique ID"
		label variable sexe "Sex"
		label variable age "Current age"
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
		
		
		drop in 1/6
				
		drop in 57

			save "$cleandata_ucad_base\mberaye_023B_baseline_df", replace 	 					
	
	*/	
	
	
	
*<><<><><>><><<><><>>
**# CLEAN UCAD MIDLINE DATA
*<><<><><>><><<><><>>

	**##  Geuo (033A)
	
*-----------------------------------------* Midline Village Geuo *-----------------------------------------*

	import excel "$rawdata_ucad_mid\Dises year 2_fusion final_3_08042025.UCAD.UGB.xlsx", sheet("10_GU") firstrow clear

  *^*^*rename variables for clarity 

		rename DISES_SEN23119_Parasitologied numero
		rename B initiales
		rename C identifiant
		rename D sexe
		rename E age
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
		label variable identifiant "Unique ID"
		label variable sexe "Sex"
		label variable age "Current age"
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
		
		
	* drop the first 6 rows (they're header or formatting rows)
			
		drop in 1/6
		
	* gen village ID
	
		gen hhid_village = "033A"
		order hhid_village
		
	* save kids that left school
		
	preserve 
	
			keep in 57/78
		
				save "$cleandata_ucad_mid\geuo_033A_midline_df_left_school.dta", replace 
	restore 

		
	* save all kids in midline  
	
	restore 
	
		preserve 
			
			gen notes = ""
			
			forvalues i = 59/80 {
				replace notes = fu_p1 in `i'
				replace fu_p1 = "" in `i'
			}

			drop in 57/58
			drop in 78/79
			replace notes = "Transfert\Nouveaux recruts" if notes == "Transfert"
			replace omega_vivant_p2 = "" if omega_vivant_p2 == "Nouveaux recruts "
			replace notes = "Crtl finalisé __Dr Bruno_le / /2025" if numero == "Crtl finalisé __Dr Bruno_le / /2025"
			replace numero = "" if numero == "Crtl finalisé __Dr Bruno_le / /2025"
			
		save "$cleandata_ucad_mid\all_geuo_033A_midline_df.dta", replace 
	
	restore 
	
	
	
**## Dodel (072B)
*-----------------------------------------* Midline Village Dodel *-----------------------------------------*
	
	
	import excel "$rawdata_ucad_mid\Dises year 2_fusion final_3_08042025.UCAD.UGB.xlsx", sheet("1_DO") firstrow clear

  *^*^*rename variables for clarity 

		rename DISES_SEN23119_Parasitologied numero
		rename B initiales
		rename C identifiant
		rename D sexe
		rename E age
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
		label variable identifiant "Unique ID"
		label variable sexe "Sex"
		label variable age "Current age"
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
		
		
	* drop the first 6 rows (they're header or formatting rows)
			
		drop in 1/6
		drop if numero == "Controle réalisé __Dr Bruno_Senghor le 07/ 04/2025"
		drop W X Y Z
		
	* gen village ID
	
		gen hhid_village = "072B"
		order hhid_village
		
	** keep kids who left were in baseline but left in midline	
	preserve 
	
	gen obs_no = _n
	keep if inrange(obs_no, 50, 53)
	drop obs_no
	
		save "$cleandata_ucad_mid\dodel_072B_midline_left_study.dta", replace 
	restore 
	* save all kids in midline  
	
			
			drop in 49/50
			drop in 52/54
			
		save "$cleandata_ucad_mid\all_dodel_072B_midline_df.dta", replace 
	
	
	
	
	

	**## Diabobe (030B)
*-----------------------------------------* Midline Village Diabobe *-----------------------------------------*
	
	
	import excel "$rawdata_ucad_mid\Dises year 2_fusion final_3_08042025.UCAD.UGB.xlsx", sheet("2_DI") firstrow clear

  *^*^*rename variables for clarity 

		rename CartoBil_SEN23119_Parasitologi numero
		rename B initiales
		rename C identifiant
		rename D sexe
		rename E age
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
		label variable identifiant "Unique ID"
		label variable sexe "Sex"
		label variable age "Current age"
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
		
		
	* drop the first 6 rows (they're header or formatting rows)
		drop in 1/6
		
		** keep kids who left baseline
	
	preserve 
	
			keep in 52/54
		
				tempfile _030B_left_school
					save  `_030B_left_school'
						
	restore 
		
		* keep only midline kids for filtering 

			drop in 51
			drop in 54

		save "$cleandata_ucad_mid\diabobe_030B_midline_df.dta", replace 


	**## Ndiayene Pendao (020B)
	*-----------------------------------------* Midline Village Ndiayene Pendao *-----------------------------------------*
	
	
	import excel "$rawdata_ucad_mid\Dises year 2_fusion final_3_08042025.UCAD.UGB.xlsx", sheet("3_NP") firstrow clear

  *^*^*rename variables for clarity 

		rename A numero
		rename DISES_SEN23119_Parasitologied initiales
		rename C identifiant
		rename D sexe
		rename E age
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
		label variable identifiant "Unique ID"
		label variable sexe "Sex"
		label variable age "Current age"
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
		
		
	** drop the first 6 rows (they're header or formatting rows)
			
	drop in 1/6
	gen hhid_village = "020B"
	
	** keep kids who left baseline
	
	preserve 
	
			keep in 53/54
		
				tempfile _020B_left_school
				save `_020B_left_school'
		
	restore 
		
	** drop kids who left baseline now to keep record of all kids enrolled in midline 
	
		drop in 52
		drop in 54

			save "$cleandata_ucad_mid\ndiayene_pendao_020B_midline_df.dta", replace 
	
	
	**## Thiangaye (021B)
	*-----------------------------------------* Midline Village Thiangaye *-----------------------------------------*
	
	
	import excel "$rawdata_ucad_mid\Dises year 2_fusion final_3_08042025.UCAD.UGB.xlsx", sheet("4_TH") firstrow clear

  *^*^*rename variables for clarity 

		rename DISES_SEN23119_Parasitologied numero
		rename B initiales
		rename C identifiant
		rename D sexe
		rename E age
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
		label variable identifiant "Unique ID"
		label variable sexe "Sex"
		label variable age "Current age"
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
		
		
	* drop the first 6 rows (they're header or formatting rows)
	
			
	drop in 1/6
	gen hhid_village = "021B"
		order hhid_village
	
	*^*^* keep kids who left baseline
	
	preserve 
	
			keep in 57
		
		gen temp_v1 = v2
			replace v1 = temp_v1
			replace v2 = v3
			replace v3 = v4
			replace v4 = .

			drop temp_v1
		
				tempfile _021B_left_school
					save `_021B_left_school'
		
	restore 
		
	** drop kids who left baseline now to keep record of all kids enrolled in midline 
	
	drop in 55/56
	drop in 56/58
	
		

	save "$cleandata_ucad_mid\thiangaye_021B_midline_df.dta", replace 
	
	
**##   Fanaye Diery (062B)
*-----------------------------------------* Midline Village Fanaye Diery *-----------------------------------------*

		import excel "$rawdata_ucad_mid\Dises year 2_fusion final_3_08042025.UCAD.UGB.xlsx", sheet("5_FD") firstrow clear


*rename variables for clarity 

		*^*^*rename variables for clarity 

		rename DISES_SEN23119_Parasitologied numero
		rename B initiales
		rename C identifiant
		rename D sexe
		rename E age
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
		label variable identifiant "Unique ID"
		label variable sexe "Sex"
		label variable age "Current age"
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
		
		
		drop in 1/6
		
			*^*^* keep kids who left baseline
	
	preserve 
	
			keep in 51/56
		
				save "$cleandata_ucad_mid\fanaye_diery_062B_midline_left_school.dta", replace 
		
	restore 
		
	** drop kids who left baseline now to keep record of all kids enrolled in midline 
	
	drop in 50/58
		
	save "$cleandata_ucad_mid\fanaye_diery_062B_midline_df", replace 	 		

	**##  Saneinte (031B)
*-----------------------------------------* Midline Village Saneinte *-----------------------------------------*

		import excel "$rawdata_ucad_mid\Dises year 2_fusion final_3_08042025.UCAD.UGB.xlsx", sheet("6_SA") firstrow clear


*rename variables for clarity 

		*^*^*rename variables for clarity 

		rename DISES_SEN23119_Parasitologied numero
		rename B initiales
		rename C identifiant
		rename D sexe
		rename E age
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
		label variable identifiant "Unique ID"
		label variable sexe "Sex"
		label variable age "Current age"
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
		
		
		drop in 1/6
		
			*^*^* keep kids who left baseline
	
	preserve 
	
			keep in 58
		
				save "$cleandata_ucad_mid\saneinte_031B_midline_left_school.dta", replace 
		
	restore 
		
	** drop kids who left baseline now to keep record of all kids enrolled in midline 
	
	drop in 56/59
		
	save "$cleandata_ucad_mid\saneinte_031B_midline_df", replace 	 
	
	
**##  Yetti Yone (033B)
*-----------------------------------------* Midline Village Yetti Yone *-----------------------------------------*

		import excel "$rawdata_ucad_mid\Dises year 2_fusion final_3_08042025.UCAD.UGB.xlsx", sheet("7_YY") firstrow clear


*rename variables for clarity 

		*^*^*rename variables for clarity 

		rename A numero
		rename DISES_SEN23119_Parasitologied initiales
		rename C identifiant
		rename D sexe
		rename E age
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
		label variable identifiant "Unique ID"
		label variable sexe "Sex"
		label variable age "Current age"
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
		
		
		drop in 1/6
		
			*^*^* keep kids who left baseline
	
	preserve 
	
			keep in 52/57
		
				save "$cleandata_ucad_mid\yetti_yone_033B_midline_left_school.dta", replace 
		
	restore 
		
	** drop kids who left baseline now to keep record of all kids enrolled in midline 
	
	drop in 51/60
		
	save "$cleandata_ucad_mid\yetti_yone_033B_midline_df", replace 	 		
	
	
	
**##  Yamane (130A)
*-----------------------------------------* Midline Village Yamane *-----------------------------------------*

		import excel "$rawdata_ucad_mid\Dises year 2_fusion final_3_08042025.UCAD.UGB.xlsx", sheet("8_YA") firstrow clear


*rename variables for clarity 

		*^*^*rename variables for clarity 

		rename DISES_SEN23119_Parasitologied numero
		rename B initiales
		rename C identifiant
		rename D sexe
		rename E age
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
		label variable identifiant "Unique ID"
		label variable sexe "Sex"
		label variable age "Current age"
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
		
		
		drop in 1/6
		
			*^*^* keep kids who left baseline
	
	preserve 
	
			keep in 53/57
		
				save "$cleandata_ucad_mid\yamane_130A_midline_left_school.dta", replace 
		
	restore 
		
	** drop kids who left baseline now to keep record of all kids enrolled in midline 
	
	drop in 52/59
		
	save "$cleandata_ucad_mid\yamane_130A_midline_df", replace 	 		
		
	
	
**##  Diaminar Loyene (130A) VERIFY & RUN
*-----------------------------------------* Midline Village Diaminar Loyene *-----------------------------------------*

/* 
		import excel "$rawdata_ucad_mid\Dises year 2_fusion final_3_08042025.UCAD.UGB.xlsx", sheet("9_DL") firstrow clear


*rename variables for clarity 

		*^*^*rename variables for clarity 

		rename DISES_SEN23119_Parasitologied numero
		rename B initiales
		rename C identifiant
		rename D sexe
		rename E age
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
		label variable identifiant "Unique ID"
		label variable sexe "Sex"
		label variable age "Current age"
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
		
		
		drop in 1/6
		
			*^*^* keep kids who left baseline
	
	preserve 
	
			keep in 53/57
		
				save "$cleandata_ucad_mid\diaminar_loyene_022A_midline_left_school.dta", replace 
		
	restore 
		
	** drop kids who left baseline now to keep record of all kids enrolled in midline 
	
	drop in 52/59
		
	save "$cleandata_ucad_mid\diaminar_loyene_022A_midline_df", replace 	
	
*/
	
**##  Kassack Nord (030A)
*-----------------------------------------* Midline Village Kassack Nord *-----------------------------------------*

		import excel "$rawdata_ucad_mid\Dises year 2_fusion final_3_08042025.UCAD.UGB.xlsx", sheet("11_KA") firstrow clear


*rename variables for clarity 

		*^*^*rename variables for clarity 

		rename DISES_SEN23119_Parasitologied numero
		rename B initiales
		rename C identifiant
		rename D sexe
		rename E age
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
		label variable identifiant "Unique ID"
		label variable sexe "Sex"
		label variable age "Current age"
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
		
		
		drop in 1/6
		
			*^*^* keep kids who left baseline
	
	preserve 
	
			keep in 53/55
		
				save "$cleandata_ucad_mid\kassack_nord_030A_midline_left_school.dta", replace 
		
	restore 
		
	** drop kids who left baseline now to keep record of all kids enrolled in midline 
	
	drop in 52/57
		
	save "$cleandata_ucad_mid\kassack_nord_030A_midline_df", replace 	
		
**##  Ndiamar (Souloul) 020A (correct for kids who refused/absent de 2 passage)
*-----------------------------------------* Midline Village Ndiamar *-----------------------------------------*

		import excel "$rawdata_ucad_mid\Dises year 2_fusion final_3_08042025.UCAD.UGB.xlsx", sheet("12_SO") firstrow clear


*rename variables for clarity 

		*^*^*rename variables for clarity 

		rename DISES_SEN23119_Parasitologied numero
		rename B initiales
		rename C identifiant
		rename D sexe
		rename E age
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
		label variable identifiant "Unique ID"
		label variable sexe "Sex"
		label variable age "Current age"
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
		
		
		drop in 1/6
		
			*^*^* keep kids who left baseline
	
	preserve 
	
			keep in 57
			gen village = "Ndiamar (Souloul) 020A"
		
				save "$cleandata_ucad_mid\ndiamar_020A_midline_left_school.dta", replace 
		
	restore 
		
	** drop kids who left baseline now to keep record of all kids enrolled in midline 
	
	drop in 56/60
		
	save "$cleandata_ucad_mid\ndiamar_020A_midline_df", replace 	
		
	
**## El Debiyaye Maraye II (021A) (Maraye)
*-----------------------------------------* Midline Village Maraye *-----------------------------------------*

		import excel "$rawdata_ucad_mid\Dises year 2_fusion final_3_08042025.UCAD.UGB.xlsx", sheet("13_MA") firstrow clear


*rename variables for clarity 

		*^*^*rename variables for clarity 

		rename DISES_SEN23119_Parasitologied numero
		rename B initiales
		rename C identifiant
		rename D sexe
		rename E age
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
		label variable identifiant "Unique ID"
		label variable sexe "Sex"
		label variable age "Current age"
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
		
		
		drop in 1/6
		
			*^*^* keep kids who left baseline
	
	preserve 
	
			keep in 47/51
			gen village = "El Debiyaye Maraye II (Maraye) 021A "
		
				save "$cleandata_ucad_mid\el_debiyaye_maraye_021A_midline_left_school.dta", replace 
		
	restore 
		
	** drop kids who left baseline now to keep record of all kids enrolled in midline 
	
	drop in 46/53
		
	save "$cleandata_ucad_mid\el_debiyaye_maraye_021A_midline_df", replace 		
	
	
	
**## Dioss Peulh (032A)
*-----------------------------------------* Midline Village Dioss Peulh *-----------------------------------------*

		import excel "$rawdata_ucad_mid\Dises year 2_fusion final_3_08042025.UCAD.UGB.xlsx", sheet("14_DP") firstrow clear


*rename variables for clarity 

		*^*^*rename variables for clarity 

		rename DISES_SEN23119_Parasitologied numero
		rename B initiales
		rename C identifiant
		rename D sexe
		rename E age
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
		label variable identifiant "Unique ID"
		label variable sexe "Sex"
		label variable age "Current age"
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
		
		
		drop in 1/6
		
			*^*^* keep kids who left baseline
	
	preserve 
	
			keep in 51/53
			gen village = "Dioss Peulh (032A)"
		
				save "$cleandata_ucad_mid\dioss_peulh_032A_midline_left_school.dta", replace 
		
	restore 
		
	** drop kids who left baseline now to keep record of all kids enrolled in midline 
	
	drop in 50/55
		
	save "$cleandata_ucad_mid\dioss_peulh_032A_midline_df", replace 		
		
	
	
**##  Mberaye (023B)
*-----------------------------------------* Midline Village Maraye *-----------------------------------------*

		import excel "$rawdata_ucad_mid\Dises year 2_fusion final_3_08042025.UCAD.UGB.xlsx", sheet("15_MB") firstrow clear


*rename variables for clarity 

		*^*^*rename variables for clarity 

		rename DISES_SEN23119_Parasitologied numero
		rename B initiales
		rename C identifiant
		rename D sexe
		rename E age
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
		label variable identifiant "Unique ID"
		label variable sexe "Sex"
		label variable age "Current age"
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
		
		
		drop in 1/6
		
			*^*^* keep kids who left baseline
	
	preserve 
	
			keep in 55/57
			gen village = "Mberaye (023B)"
		
				save "$cleandata_ucad_mid\mberaye_023B_midline_left_school.dta", replace 
		
	restore 
		
	** drop kids who left baseline now to keep record of all kids enrolled in midline 
	
	drop in 54/58
		
	save "$cleandata_ucad_mid\mberaye_023B_midline_df", replace 		
		
	
*/


*<><<><><>><><<><><>>
**# CLEAN EPLS MIDLINE DATA
*<><<><><>><><<><><>>	
	
	
	
**##  Malla (131B)
*-----------------------------------------* Village Malla *-----------------------------------------*

		import excel "$rawdata_epls_mid\Dises_Année 2_Compilation data_mg.xlsx", sheet("1_MA") firstrow clear

*rename variables for clarity 

		*^*^*rename variables for clarity 

		rename DISES_SEN2151_Parasitologiede numero
		rename B initiales
		rename C identifiant
		rename D sexe
		rename E age
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
		label variable identifiant "Unique ID"
		label variable sexe "Sex"
		label variable age "Current age"
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
		
		
		drop in 1/6
		drop in 57


	save "$cleandata_ucad_base\geuo_033A_baseline_df", replace 	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

