*==============================================================================
* Program: Analyse "Other" options in Midline data 
* ==============================================================================
* written by: Kateri MOuawad
* Created: May 2025
* Updates recorded in GitHub 


* <><<><><>> Read Me  <><<><><>>

			** This file processes: 

			**	             		
	
			** This .do file outputs:

			**	            	
			
	** PROCEDURE:
	
	** 1) 
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

	global crdes_data "${master}\Data\_CRDES_CleanData\Midline\Deidentified"
	
*<><<><><>><><<><><>>
**# BEGIN MIDLINE WORK
*<><<><><>><><<><><>>
	
	use "$crdes_data\"
*-------------------*
**### Load in data 
*-------------------* 
 
	use 
 
*-------------------*
**### 
*-------------------* 
   
*** 
		

		
		
		