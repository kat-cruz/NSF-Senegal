*** Household Data Corrections for additional 16 villages*** 
*** File Created By: Kateri Mouawad ***
*** Updates recorded in Git ***


* <><<><><>> Read Me  <><<><><>>


 *^*^* This script corrects incorrect values that were caught in the Baseline Checks .do file
 ** 1) Load in final baseline data
 ** 2) Check and remove duplicates
 ** 4) Run village level corrections by replacing mistaken values 
 ** 5) Save final output 


 *** This Do File PROCESSES: 
							* Questionnaire Communautaire - NSF DISES_WIDE_27Feb24.csv
				
  
 *** This Do File CREATES:
						  * DISES_Baseline_Community_Corrected_PII


clear all 

set maxvar 20000

**** Master file path  ****
if "`c(username)'"=="socrm" global master "C:\Users\socrm\Box\Data_Management"
if "`c(username)'"=="kls329" global master "C:\Users\kls329\Box\Data_Management"
if "`c(username)'"=="km978" global master "C:\Users\km978\Box\NSF Senegal\Data_Management"
if "`c(username)'"=="Kateri" global master "C:\Users\Kateri\Box\NSF Senegal\Data_Management"
if "`c(username)'"=="admmi" global master "C:\Users\admmi\Box\Data_Management"

*** additional file paths ***
global clean_data "$master\Data\_CRDES_CleanData\Baseline\Identified"
*global data2 "$master\Surveys\Baseline CRDES data (April 2024)"
global corrected_data "$master\Output\Data_Processing\Checks\Baseline"
global raw_data "$master\Data\_CRDES_RawData\Baseline"
global ids   "$master\Output\Data_Processing\ID_Creation\Baseline"



*** 11.	Bring in the community survey and add the corrections from CRDES.
import delimited "$raw_data\Questionnaire Communautaire - NSF DISES_WIDE_27Feb24.csv", clear varnames(1) bindquote(strict)

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

replace q_31a = 50 if hhid_village == "092A"
replace q_43 = 30 if hhid_village == "040B"
replace q_43 = 3 if hhid_village == "043B"
replace q_43 = 12 if hhid_village == "030B"
replace q_43 = 60 if hhid_village == "080B"
replace q_43 = 12 if hhid_village == "082B"
replace q_43 = 6 if hhid_village == "091A"
replace q_43 = 6 if hhid_village == "083B"
replace q_43 = 24 if hhid_village == "103A"
replace q_43 = 20 if hhid_village == "042A"
replace q_43 = 25 if hhid_village == "112A"
replace q_43 = 1 if hhid_village == "070B"
replace q_43 = 6 if hhid_village == "012A"
replace q_43 = 25 if hhid_village == "021A"
replace q_43 = 2 if hhid_village == "071B"
replace q_43 = 30 if hhid_village == "052B"
replace q_43 = 12 if hhid_village == "093A"
replace q_43 = 3 if hhid_village == "022A"
replace q_43 = 12 if hhid_village == "020A"
replace q_43 = 0 if hhid_village == "061B"
replace q_44 = 1 if hhid_village == "082A"
replace q_45 = 36 if hhid_village == "043B"
replace q_49 = 1 if hhid_village == "043B"
replace q_58 = -9 if hhid_village == "083A"
replace q_58 = 6 if hhid_village == "111A"



*** 12.	Save the data as DISES_Baseline_Community_Corrected_PII. ***
*save "$data\DISES_Baseline_Community_Corrected_PII"