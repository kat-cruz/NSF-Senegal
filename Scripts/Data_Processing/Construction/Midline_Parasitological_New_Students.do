*-----------------------------------------*
* written by: Kateri Mouawad
* Created: May 2025
* Updates recorded in GitHub
*-----------------------------------------*

*<><<><><>><><<><><>>
* Read Me  <><<><><>>
*<><<><><>><><<><><>>

		*** This .do file processes:
									* DISES UCAD.UGB.1_VILLAGES.PARASITOLOGY DATA ALL VILLAGES.controled_1_25.06.24.xlsx
									* Dises year 2_fusion final_3_08042025.UCAD.UGB.xlsx

		*** This .do file outputs: (need to finish updating output)
								
			**	
						
								
		*** PROCEDURE:
		*		
				* 1) 
				
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
	

	global dataexport "$master\Data_Management\Data\_Partner_CleanData\Parasitological_Data\Child_Matches\EPLS_Child_Matches\Midline_Matches"

	global paras_mid "$master\Data_Management\Data\_Partner_RawData\Parasitological_Data\complete_midline_parasitology_df.dta"
	global paras_base "$master\Data_Management\Data\_Partner_RawData\Parasitological_Data\Baseline UCAD & EPLS parasitological data.xlsx"

 
*-----------------------------------------*
**# CLEAN BASELINE UCAD DATA
*-----------------------------------------*


		import excel "$paras_base", sheet("Sheet1") firstrow clear 
			merge m:m identificant using "$paras_mid"  

			keep age_hp sex_hp identificant _merge hhid_village initiales


			keep if _merge != 3
			
			drop if hhid_village == "033A"


		order hhid_village identificant initiales age_hp sex_hp 
		
		export excel using "$dataexport/epls_midline_new_students_to_match.xlsx", firstrow(variables) replace
































