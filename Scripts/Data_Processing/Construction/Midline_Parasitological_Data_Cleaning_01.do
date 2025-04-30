*==============================================================================
* written by: Kateri Mouawad
* Created: February 2025
* Updates recorded in GitHub


* <><<><><>> Read Me  <><<><><>>


		*** This .do file processes:
									* DISES UCAD.UGB.1_VILLAGES.PARASITOLOGY DATA ALL VILLAGES.controled_1_25.06.24.xlsx
									* Dises year 2_fusion final_3_08042025.UCAD.UGB.xlsx

		*** This .do file outputs:
								* ucad_baseline_parasitological_df
								* ucad_midline_parasitological_df.dta
								
		*** PROCEDURE:
		*	 This .do file simply puts the UCAD/EPLS data into a .dta format with variable names and labels for both baseline and midline data. Will update to include endline data. 
		
				* 1) Import raw UCAD/EPLS data by village 
				* 2) rename variables
				* 3) drop useless rows
				* 4) label variables
				* 5) save .dta

*<><<><><>><><<><><>>
* INITIATE SCRIPT
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

	global rawdata_epls_mid "$master\Data_Management\Data\_Partner_RawData\Parasitological_Data\EPLS\Midline"
	global rawdata_epls_base "$master\Data_Management\Data\_Partner_RawData\Parasitological_Data\EPLS_Data\Baseline"
	

*<><<><><>><><<><><>>
**# CLEAN UCAD BASELINE DATA
*<><<><><>><><<><><>>

**##  Geuo
*^*^**^*^**^*^**^*^**^*^**^*^* Village Geuo *^*^**^*^**^*^**^*^**^*^**^*^*

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
	
**## Dodel	
*^*^**^*^**^*^**^*^**^*^**^*^* Baseline Village Dodel *^*^**^*^**^*^**^*^**^*^**^*^*
	
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
	
**## Diabobe
*^*^**^*^**^*^**^*^**^*^**^*^*  Baseline Village Diabobe *^*^**^*^**^*^**^*^**^*^**^*^*
	
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
	
	
**##  Ndiayene Pendao
*^*^**^*^**^*^**^*^**^*^**^*^* Baseline Village Ndiayene Pendao *^*^**^*^**^*^**^*^**^*^**^*^*
	
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
		drop if numero == "Control realized by Bruno Senghor 21.06.2024"

	save "$cleandata_ucad_base\ndiayene_pendao_020B_baseline_df", replace 
	
**##   Thiangaye
*^*^**^*^**^*^**^*^**^*^**^*^* Baseline Village Thiangaye *^*^**^*^**^*^**^*^**^*^**^*^*

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
		drop if numero == "Control realized by Bruno Senghor 21.06.2024"

	save "$cleandata_ucad_base\thiangaye_021B_baseline_df", replace 	

*<><<><><>><><<><><>>
**# CLEAN MIDLINE DATA
*<><<><><>><><<><><>>

	**##  Geuo
	
*^*^**^*^**^*^**^*^**^*^**^*^* Midline Village Geuo *^*^**^*^**^*^**^*^**^*^**^*^*

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
		drop in 57
		
	preserve 
	
			keep in 57/78
		
				save "$cleandata_ucad_mid\geuo_033A_midline_df_left_school.dta", replace 
		
	restore 
	
	drop in 57/80

		save "$cleandata_ucad_mid\geuo_033A_midline_df.dta", replace 
	
	
**## Dodel	
*^*^**^*^**^*^**^*^**^*^**^*^* Midline Village Dodel *^*^**^*^**^*^**^*^**^*^**^*^*
	
	
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
		
		
	preserve 
	
	gen obs_no = _n
	keep if inrange(obs_no, 50, 53)
	drop obs_no
	
		save "$cleandata_ucad_mid\dodel_072B_midline_left_study.dta", replace 
	
	restore 
	
	drop in 49/56

	save "$cleandata_ucad_mid\dodel_072B_midline_df.dta", replace 

	**## Diabobe
*^*^**^*^**^*^**^*^**^*^**^*^* Midline Village Diabobe *^*^**^*^**^*^**^*^**^*^**^*^*
	
	
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
		

	save "$cleandata_ucad_mid\diabobe_030B_midline_df.dta", replace 


	**## Ndiayene Pendao
	*^*^**^*^**^*^**^*^**^*^**^*^* Midline Village Ndiayene Pendao *^*^**^*^**^*^**^*^**^*^**^*^*
	
	
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
		
		
	* drop the first 6 rows (they're header or formatting rows)
			
	drop in 1/6
		

	save "$cleandata_ucad_mid\ndiayene_pendao_020B_midline_df.dta", replace 
	
	
	**## Thiangaye
	*^*^**^*^**^*^**^*^**^*^**^*^* Midline Village Thiangaye *^*^**^*^**^*^**^*^**^*^**^*^*
	
	
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
		

	save "$cleandata_ucad_mid\thiangaye_021B_midline_df.dta", replace 

