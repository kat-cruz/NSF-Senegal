*** DISES Midline Data Checks - Household Survey***
*** File originally created By: Kateri Mouawad  ***
*** Updates recorded in GitHub ***

*>>>>>>>>>>**--*--*--*--*--*--*--*--** READ ME **--*--*--*--*--*--*--*--**<<<<<<<<<<<*


			*1)	Import community data 
			*2)	Based on the corrected issues from CRDES, complete corrections by replacing the wrong value with the corrected value 
			*3) Export this spread sheet to the Issues folder located here:
				*\Data Management\External_Corrections\Issues for Justin and Amina\Midline\Issues
			

*--*--*--*--*--*--*--*--**--*--*--*--*--*--*--*--**--*--*--*--*--*--*--*--**--*--*--*--*--*--*--*--*

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
if "`c(username)'"=="admmi" global master "C:\Users\admmi\Box\NSF Senegal"


****************************** Import community survey data ********************************************
/*

*** 11.	Bring in the community survey and add the corrections from CRDES.
import delimited "$data\Questionnaire Communautaire - NSF DISES_WIDE_27Feb24.csv", clear varnames(1) bindquote(strict)

** Correction for THILENE
replace	village_select	=84 if key == "uuid:ddd20ef7-0f58-4c79-beec-018819be4edc"
replace	hhid_village	="052A" if key == "uuid:ddd20ef7-0f58-4c79-beec-018819be4edc"
replace	region	="SAINT LOUIS" if key == "uuid:ddd20ef7-0f58-4c79-beec-018819be4edc"
replace	departement	="DAGANA" if key == "uuid:ddd20ef7-0f58-4c79-beec-018819be4edc"
replace	commune	="NDIAYE" if key == "uuid:ddd20ef7-0f58-4c79-beec-018819be4edc"
replace	village	="THILENE" if key == "uuid:ddd20ef7-0f58-4c79-beec-018819be4edc"

** Correction for NADIEL I
replace	village_select	= 54 if key == "uuid:b6e23379-33c3-4314-b5f7-11c6ac21f41a"
replace	hhid_village	= "042B" if key == "uuid:b6e23379-33c3-4314-b5f7-11c6ac21f41a"
replace	region	= "SAINT LOUIS" if key == "uuid:b6e23379-33c3-4314-b5f7-11c6ac21f41a"
replace	departement	= "DAGANA" if key == "uuid:b6e23379-33c3-4314-b5f7-11c6ac21f41a"
replace	commune	= "RONKH" if key == "uuid:b6e23379-33c3-4314-b5f7-11c6ac21f41a"
replace	village	= "NADIEL I" if key == "uuid:b6e23379-33c3-4314-b5f7-11c6ac21f41a"


drop if key == "uuid:1f12bce7-c16e-47c0-936b-f71cca28ff4f" // This observation come from a mistake

replace [var] = [value] if hhid_village == " "




*** 12.	Save the data as DISES_Baseline_Community_Corrected_PII. ***
save "$data\DISES_Baseline_Community_Corrected_PII"
*/

