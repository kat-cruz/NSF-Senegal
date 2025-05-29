*==============================================================================
* Program: clean up ecological data to merge with human parasitological df 
* ==============================================================================
* written by: Kateri MOuawad
* Created: May 2025
* Updates recorded in GitHub 


* <><<><><>> Read Me  <><<><><>>

			** This file processes: 

			**	              Mideline 2.xlsx, sheet("Sites biocomposition")		
	
			** This .do file outputs:

			**	              DISES_midline_ecological data.dta		
			
	** PROCEDURE:
	
	** 1) bring in data
	** 2) remove upstream/downstream sites
	** 3) Remove empty columns/rows
	** 4) Update old village IDs (most important part)
	** 5) save .dta

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
*^*^* Set base Box path for each user

	if "`c(username)'"=="socrm" global master "C:\Users\socrm\Box"
	if "`c(username)'"=="kls329" global master "C:\Users\kls329\Box"
	if "`c(username)'"=="km978" global master "C:\Users\km978\Box\NSF Senegal"
	if "`c(username)'"=="Kateri" global master "C:\Users\Kateri\Box\NSF Senegal"
	if "`c(username)'"=="admmi" global master "C:\Users\admmi\Box"

*^*^* Define project-specific paths

	global raw_data "${master}\Data_Management\Data\_Partner_RawData\Ecological_Data\Midline"
	global clean_data "${master}\Data_Management\Data\_Partner_CleanData\Ecological_Data"

*-------------------*
**### Load in data 
*-------------------* 
 
 import excel "$raw_data\Mideline 2.xlsx", sheet("Sites biocomposition") firstrow clear 
 
*-------------------*
**### Remove upstream/downstream
*-------------------* 
   
*** Remove all up or downstream villages without village codes from the data ***

	gen ends_with_u = substr(VillageCodes, -1, 1) == "u" | substr(VillageCodes, -1, 1) == "U"

		*** drop those observations ***
			drop if ends_with_u

		*** clean up the temporary variable ***
			drop ends_with_u
			
*-------------------*
**### Remove empty variables
*-------------------* 

	drop AQ AR AS AT AU

*-------------------*
**### rename VillageCodes to hhid_village
*-------------------* 	

	rename VillageCodes hhid_village
	
*-------------------*
**### DROP empty rows 
*-------------------* 

		drop if hhid_village == ""
		
*-------------------*
**### Create schisto_indicator 
*-------------------* 

		*** create indicator variable based on text variable ***

	gen schisto_indicator = .
		replace schisto_indicator = 1 if Schistoinfection == "1"
		replace schisto_indicator = 0 if Schistoinfection == "0"

 
*-------------------*
**## UPDATE OLD VILLAGE IDS
*-------------------* 

	replace hhid_village = "071B" if Sites == "Dembe"
		replace hhid_village = "132B" if hhid_village == "041B"
		replace hhid_village = "122B" if hhid_village == "063B"
		replace hhid_village = "120A" if hhid_village == "101A"
		replace hhid_village = "130A" if hhid_village == "051A"
		replace hhid_village = "140A" if hhid_village == "111A"
		
	*replace hhid_village = "153A" if hhid_village == "132A" // this was corrected recently IN the midline ecological data 

		save "$clean_data\DISES_midline_ecological data.dta", replace 
		
		
		
		
** end of .do file		
		
		
		
		
		