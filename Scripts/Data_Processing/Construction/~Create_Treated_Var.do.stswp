*** DISES Baseline Data - Code used to create trained variable ***
*** File Created By: Kateri Mouawad ***
*** File Last Updated By: Kateri Mouawad ***
*** File Last Updated On: July 11, 2024 ***


 *** This Do File PROCESSES: All_Villages.dta
 
  *** This Do File CREATES: Treated_variables_df.dta
						*	_Transcribed_sign-in_sheets.dta
						*   Questionnaire_additional_households.xlsx
				
							
 *** Procedure: 
 *(1) Run the file paths
 *(2) Load in the data
 *(3) Run the script that updates hh_relation_with_ variable (this tells us value lables of the numbers)
 *(4) Create the variables and run the updates to indiciate which households and individuals were trained.
 *(5) Save the dta. 
 
 
 *** UPDATE: This was rerun to update an old village code: all 132A's were updated to be 153A's
 
 
*<><<><><>><><<><><>>
* INITIATE SCRIPT
*<><<><><>><><<><><>>
 
clear all 

*** set maximum variables to at least 20,000 ***
set maxvar 20000

*<><<><><>><><<><><>>
* SET FILE PATHS
*<><<><><>><><<><><>>

if "`c(username)'"=="socrm" {
                global master "C:\Users\socrm\Box\NSF Senegal\Data_Management"
}
else if "`c(username)'"=="Kateri" {
                global master "C:\Users\Kateri\Box\NSF Senegal\Data_Management"
				
}
else if "`c(username)'"=="km978" {
                global master "C:\Users\km978\Box\NSF Senegal\Data_Management"
				
}

*<><<><><>><><<><><>>
* PROCEDURE
*<><<><><>><><<><><>>

*2.	Set up the data to create the trained variable
*a.	Start with DISES_Baseline_Complete_PII.dta 
*b.	Keep the household ID (hhid), household head name, respondent name, phone number, and names of all household members 
*c.	Output file to Excel 


global data "$master\Output\Data_Processing\ID_Creation\Baseline\UCAD_EPLS_IDs"
global output  "$master\Output\Data_Processing\Checks\Corrections\Treatment"
*global uniqueIDs "$master\Data\_PartnerData\EPLS and DISES data\Household & Individual IDs"
global participant "$master\Data\_CRDES_RawData\Treatment"


/*
ssc install distinct
distinct villageid
*/
 
*<><<><><>><><<><><>>
*BRING IN INDIVIDUAL IDS
*<><<><><>><><<><><>>


use "$data\All_Villages.dta", clear

rename hh_relation_with_ hh_relation_with
tostring  hh_relation_with, gen(hh_relation)

replace hh_relation = "Head of household (himself)" if hh_relation_with == 1
replace hh_relation = "Spouse of head ofhousehold" if hh_relation_with == 2
replace hh_relation = "Son/daughter of the home" if hh_relation_with == 3
replace hh_relation = "Spouse of the son/daughterof the head of the family" if hh_relation_with == 4
replace hh_relation = "Grandson/granddaughter ofthe head of the family" if hh_relation_with == 5
replace hh_relation = "Father/Mother of the HH" if hh_relation_with == 6
replace hh_relation = "Father/Mother of the spouseof the head of the family" if hh_relation_with == 7
replace hh_relation = "Brother/sister of the head ofthe family" if hh_relation_with == 8
replace hh_relation = "Brother/sister of the HH's spouse" if hh_relation_with == 9
replace hh_relation = "Adopted child" if hh_relation_with == 10
replace hh_relation = "House help" if hh_relation_with == 11
replace hh_relation = "Other person related to thehead of the family" if hh_relation_with == 12
replace hh_relation = "Other person not related to the head of the family" if hh_relation_with == 13

keep hh_head_name_complet hh_full_name_calc_ hh_age_ hh_phone hhid individ hh_relation hh_gender_


*export excel using "$output\Baseline_data_to_match.xlsx", firstrow(variables) sheet("Data to match") replace 


** Mannual Matches

gen trained_hh = 0
gen trained_indiv = 0
*gen invited = 0

replace trained_hh = 1 if hhid == "011A03"
replace trained_indiv = 1 if individ == "011A0301"

replace trained_hh = 1 if  hhid == "011A14"
replace trained_indiv = 1 if individ == "011A1401"

replace trained_hh = 1 if  hhid == "011A18"
replace trained_indiv = 1 if individ == "011A1801"

replace trained_hh = 1 if hhid == "011A19"
replace trained_indiv = 1 if individ == "011A1901"

replace trained_hh = 1 if  hhid == "011A15"
replace trained_indiv = 1 if individ == "011A1502"

replace trained_hh = 1 if  hhid == "011A08"
replace trained_indiv = 1 if individ == "011A0801"

replace trained_hh = 1 if  hhid == "011A11"
replace trained_indiv = 1 if individ == "011A1102"

replace trained_hh = 1 if  hhid == "011A07"
replace trained_indiv = 1 if individ == "011A0701"

replace trained_hh = 1 if hhid == "011A20"
replace trained_indiv = 1 if individ == "011A2001"

replace trained_hh = 1 if hhid == "011B09"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if hhid == "011A12"
replace trained_indiv = 1 if individ == "011A1201"

replace trained_hh = 1 if  hhid == "011B02"
replace trained_indiv = 1 if individ == "011B0201"

replace trained_hh = 1 if  hhid == "011B20"
replace trained_indiv = 1 if individ == "011B2002"

replace trained_hh = 1 if  hhid == "011B14"
replace trained_indiv = 1 if individ == "011B1403"

replace trained_hh = 1 if hhid == "011B10"
replace trained_indiv = 1 if individ == "011B1001"

replace trained_hh = 1 if  hhid == "011B16"
replace trained_indiv = 1 if individ == "011B1601"

replace trained_hh = 1 if hhid == "011B07"
replace trained_indiv = 1 if individ == "011B0701"

replace trained_hh = 1 if  hhid == "011B15"
replace trained_indiv = 1 if individ == "011B1501"

replace trained_hh = 1 if  hhid == "011B17"
replace trained_indiv = 1 if individ == "011B1701"

replace trained_hh = 1 if  hhid == "011B08"
replace trained_indiv = 1 if individ == "011B0801"

replace trained_hh = 1 if  hhid == "012A09"
replace trained_indiv = 1 if individ == "012A0901"

replace trained_hh = 1 if  hhid == "012A19"
replace trained_indiv = 1 if individ == "012A1901"

replace trained_hh = 1 if  hhid == "012A13"
replace trained_indiv = 1 if individ == "012A1301"

replace trained_hh = 1 if  hhid == "012A11"
replace trained_indiv = 1 if individ == "012A1101"

replace trained_hh = 1 if  hhid == "012A04"
replace trained_indiv = 1 if individ == "012A0401"

replace trained_hh = 1 if  hhid == "012A01"
replace trained_indiv = 1 if individ == "012A0101"

replace trained_hh = 1 if  hhid == "012A05"
replace trained_indiv = 1 if individ == "012A0501"

replace trained_hh = 1 if  hhid == "012A18"
replace trained_indiv = 1 if individ == "012A1801"

replace trained_hh = 1 if  hhid == "012A08"
replace trained_indiv = 1 if individ == "012A0801"

replace trained_hh = 1 if  hhid == "012A02"
replace trained_indiv = 1 if individ == "012A0201"

replace trained_hh = 1 if  hhid == "012B02"
replace trained_indiv = 1 if individ == "012B0201"

replace trained_hh = 1 if  hhid == "012B14"
replace trained_indiv = 1 if individ == "012B1401"

replace trained_hh = 1 if  hhid == "012B07"
replace trained_indiv = 1 if individ == "012B0721"

replace trained_hh = 1 if  hhid == "012B04"
replace trained_indiv = 1 if individ == "012B0401"

replace trained_hh = 1 if  hhid == "012B13"
replace trained_indiv = 1 if individ == "012B1301"

replace trained_hh = 1 if  hhid == "012B06"
replace trained_indiv = 1 if individ == "012B0601"

replace trained_hh = 1 if  hhid == "012B01"
replace trained_indiv = 1 if individ == "012B0103"

replace trained_hh = 1 if  hhid == "012B09"
replace trained_indiv = 1 if individ == "012B0901"

replace trained_hh = 1 if  hhid == "013A16"
replace trained_indiv = 1 if individ == "013A1601"

replace trained_hh = 1 if  hhid == "013A19"
replace trained_indiv = 1 if individ == "013A1901"

replace trained_hh = 1 if  hhid == "013A15"
replace trained_indiv = 1 if individ == "013A1501"

replace trained_hh = 1 if  hhid == "013A03"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "013A07"
replace trained_indiv = 1 if individ == "013A0701"

replace trained_hh = 1 if  hhid == "013A20"
replace trained_indiv = 1 if individ == "013A2002"

replace trained_hh = 1 if  hhid == "013A01"
replace trained_indiv = 1 if individ == "013A0101"

replace trained_hh = 1 if  hhid == "013A08"
replace trained_indiv = 1 if individ == "013A0801"

replace trained_hh = 1 if  hhid == "013A17"
replace trained_indiv = 1 if individ == "013A1704"

replace trained_hh = 1 if  hhid == "013A12"
replace trained_indiv = 1 if individ == "013A1201"

replace trained_hh = 1 if  hhid == "013A14"
replace trained_indiv = 1 if individ == "013A1401"

replace trained_hh = 1 if  hhid == "013A10"
replace trained_indiv = 1 if individ == "013A1001"

replace trained_hh = 1 if  hhid == "013A04"
replace trained_indiv = 1 if individ == "013A0401"

replace trained_hh = 1 if  hhid == "013B14"
replace trained_indiv = 1 if individ == "013B1401"

replace trained_hh = 1 if  hhid == "013B04"
replace trained_indiv = 1 if individ == "013B0401"

replace trained_hh = 1 if  hhid == "013B08"
replace trained_indiv = 1 if individ == "013B0801"

replace trained_hh = 1 if  hhid == "013B16"
replace trained_indiv = 1 if individ == "013B1602"

replace trained_hh = 1 if  hhid == "013B09"
replace trained_indiv = 1 if individ == "013B0902"

replace trained_hh = 1 if  hhid == "013B05"
replace trained_indiv = 1 if individ == "013B0502"

replace trained_hh = 1 if  hhid == "013B06"
replace trained_indiv = 1 if individ == "013B0601"

replace trained_hh = 1 if  hhid == "013B07"
replace trained_indiv = 1 if individ == "013B0701"

replace trained_hh = 1 if  hhid == "013B02"
replace trained_indiv = 1 if individ == "013B0201"

replace trained_hh = 1 if  hhid == "013B20"
replace trained_indiv = 1 if individ == "013B2001"

replace trained_hh = 1 if  hhid == "021B09"
replace trained_indiv = 1 if individ == "021B0901"

replace trained_hh = 1 if  hhid == "021B08"
replace trained_indiv = 1 if individ == "021B0801"

replace trained_hh = 1 if  hhid == "021B15"
replace trained_indiv = 1 if individ == "021B1501"

replace trained_hh = 1 if  hhid == "021B10"
replace trained_indiv = 1 if individ == "021B1001"

replace trained_hh = 1 if  hhid == "021B01"
replace trained_indiv = 1 if individ == "021B0104"

replace trained_hh = 1 if  hhid == "021B12"
replace trained_indiv = 1 if individ == "021B1202"

replace trained_hh = 1 if  hhid == "021B05"
replace trained_indiv = 1 if individ == "021B0502"

replace trained_hh = 1 if  hhid == "021B11"
replace trained_indiv = 1 if individ == "021B1104"

replace trained_hh = 1 if  hhid == "021B03"
replace trained_indiv = 1 if individ == "021B0301"

replace trained_hh = 1 if  hhid == "021B17"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "022A03"
replace trained_indiv = 1 if individ == "022A0301"

replace trained_hh = 1 if  hhid == "022A04"
replace trained_indiv = 1 if individ == "022A0401"

replace trained_hh = 1 if  hhid == "022A05"
replace trained_indiv = 1 if individ == "022A0502"

replace trained_hh = 1 if  hhid == "022A08"
replace trained_indiv = 1 if individ == "022A0801"

replace trained_hh = 1 if  hhid == "022A17"
replace trained_indiv = 1 if individ == "022A1701"

replace trained_hh = 1 if  hhid == "022A06"
replace trained_indiv = 1 if individ == "022A0601"

replace trained_hh = 1 if  hhid == "022A16"
replace trained_indiv = 1 if individ == "022A1601"

replace trained_hh = 1 if  hhid == "022A02"
replace trained_indiv = 1 if individ == "022A0202"

replace trained_hh = 1 if  hhid == "022A12"
replace trained_indiv = 1 if individ == "022A1201"

replace trained_hh = 1 if  hhid == "022A19"
replace trained_indiv = 1 if individ == "022A1901"

replace trained_hh = 1 if  hhid == "022B16"
replace trained_indiv = 1 if individ == "022B1601"

replace trained_hh = 1 if  hhid == "022B19"
replace trained_indiv = 1 if individ == "022B1902"

replace trained_hh = 1 if  hhid == "022B13"
replace trained_indiv = 1 if individ == "022B1301"

replace trained_hh = 1 if  hhid == "022B01"
replace trained_indiv = 1 if individ == "022B0101"

replace trained_hh = 1 if  hhid == "022B18"
replace trained_indiv = 1 if individ == "022B1801"

replace trained_hh = 1 if  hhid == "022B04"
replace trained_indiv = 1 if individ == "022B0401"

replace trained_hh = 1 if  hhid == "022B11"
replace trained_indiv = 1 if individ == "022B1102"

replace trained_hh = 1 if  hhid == "022B12"
replace trained_indiv = 1 if individ == "022B1201"

replace trained_hh = 1 if  hhid == "022B05"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "023A18"
replace trained_indiv = 1 if individ == "023A1801"

replace trained_hh = 1 if  hhid == "023A07"
replace trained_indiv = 1 if individ == "023A0701"

replace trained_hh = 1 if  hhid == "023A06"
replace trained_indiv = 1 if individ == "023A0603"

replace trained_hh = 1 if  hhid == "023A14"
replace trained_indiv = 1 if individ == "023A1402"

replace trained_hh = 1 if  hhid == "023A09"
replace trained_indiv = 1 if individ == "023A0901"

replace trained_hh = 1 if  hhid == "023A04"
replace trained_indiv = 1 if individ == "023A0401"

replace trained_hh = 1 if  hhid == "023A08"
replace trained_indiv = 1 if individ == "023A0804"

replace trained_hh = 1 if  hhid == "023A01"
replace trained_indiv = 1 if individ == "023A0101"

replace trained_hh = 1 if  hhid == "023A02"
replace trained_indiv = 1 if individ == "023A0201"

replace trained_hh = 1 if  hhid == "023A12"
replace trained_indiv = 1 if individ == "023A1201"

replace trained_hh = 1 if  hhid == "023A03"
replace trained_indiv = 1 if individ == "023A0301"

replace trained_hh = 1 if  hhid == "023B14"
replace trained_indiv = 1 if individ == "023B1402"

replace trained_hh = 1 if  hhid == "023B20"
replace trained_indiv = 1 if individ == "023B2001"

replace trained_hh = 1 if  hhid == "023B10"
replace trained_indiv = 1 if individ == "023B1006"

replace trained_hh = 1 if  hhid == "023B19"
replace trained_indiv = 1 if individ == "023B1904"

replace trained_hh = 1 if  hhid == "023B16"
replace trained_indiv = 1 if individ == "023B1602"

replace trained_hh = 1 if  hhid == "023B13"
replace trained_indiv = 1 if individ == "023B1302"

replace trained_hh = 1 if  hhid == "023B05"
replace trained_indiv = 1 if individ == "023B0501"

replace trained_hh = 1 if  hhid == "023B11"
replace trained_indiv = 1 if individ == "023B1101"

replace trained_hh = 1 if  hhid == "023B03"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "023B08"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "031A03"
replace trained_indiv = 1 if individ == "031A0301"

replace trained_hh = 1 if  hhid == "031A13"
replace trained_indiv = 1 if individ == "031A1301"

replace trained_hh = 1 if  hhid == "031A08"
replace trained_indiv = 1 if individ == "031A0801"

replace trained_hh = 1 if  hhid == "031A10"
replace trained_indiv = 1 if individ == "031A1001"

replace trained_hh = 1 if  hhid == "031A11"
replace trained_indiv = 1 if individ == "031A1101"

replace trained_hh = 1 if  hhid == "031A15"
replace trained_indiv = 1 if individ == "031A1501"

replace trained_hh = 1 if  hhid == "031A16"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "031A01"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "031A01"
replace trained_indiv = 1 if individ == "031A0101"

replace trained_hh = 1 if  hhid == "031B17"
replace trained_indiv = 1 if individ == "031B1701"

replace trained_hh = 1 if  hhid == "031B08"
replace trained_indiv = 1 if individ == "031B0801"

replace trained_hh = 1 if  hhid == "031B14"
replace trained_indiv = 1 if individ == "031B1401"

replace trained_hh = 1 if  hhid == "031B07"
replace trained_indiv = 1 if individ == "031B0701"

replace trained_hh = 1 if  hhid == "031B09"
replace trained_indiv = 1 if individ == "031B0901"

replace trained_hh = 1 if  hhid == "031B13"
replace trained_indiv = 1 if individ == "031B1301"

replace trained_hh = 1 if  hhid == "031B10"
replace trained_indiv = 1 if individ == "031B1001"

replace trained_hh = 1 if  hhid == "032A15"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "032A16"
replace trained_indiv = 1 if individ == "032A1601"

replace trained_hh = 1 if  hhid == "032A09"
replace trained_indiv = 1 if individ == "032A0902"

replace trained_hh = 1 if  hhid == "032A11"
replace trained_indiv = 1 if individ == "032A1102"

replace trained_hh = 1 if  hhid == "032A12"
replace trained_indiv = 1 if individ == "032A1201"

replace trained_hh = 1 if  hhid == "032A18"
replace trained_indiv = 1 if individ == "032A1801"

replace trained_hh = 1 if  hhid == "032A07"
replace trained_indiv = 1 if individ == "032A0701"

replace trained_hh = 1 if  hhid == "032A01"
replace trained_indiv = 1 if individ == "032A0101"

replace trained_hh = 1 if  hhid == "032A14"
replace trained_indiv = 1 if individ == "032A1401"

replace trained_hh = 1 if  hhid == "032A02"
replace trained_indiv = 1 if individ == "032A0201"

replace trained_hh = 1 if  hhid == "032B04"
replace trained_indiv = 1 if individ == "032B0401"

replace trained_hh = 1 if  hhid == "032B20"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "032B09"
replace trained_indiv = 1 if individ == "032B0901"

replace trained_hh = 1 if  hhid == "032B02"
replace trained_indiv = 1 if individ == "032B0201"

replace trained_hh = 1 if  hhid == "032B17"
replace trained_indiv = 1 if individ == "032B1701"

replace trained_hh = 1 if  hhid == "032B05"
replace trained_indiv = 1 if individ == "032B0501"

replace trained_hh = 1 if  hhid == "032B11"
replace trained_indiv = 1 if individ == "032B1101"

replace trained_hh = 1 if  hhid == "032B13"
replace trained_indiv = 1 if individ == "032B1301"

replace trained_hh = 1 if  hhid == "032B14"
replace trained_indiv = 1 if individ == "032B1402"

replace trained_hh = 1 if  hhid == "032B03"
replace trained_indiv = 1 if individ == "032B0302"

replace trained_hh = 1 if  hhid == "032B06"
replace trained_indiv = 1 if individ == "032B0601"

replace trained_hh = 1 if  hhid == "033A03"
replace trained_indiv = 1 if individ == "033A0301"

replace trained_hh = 1 if  hhid == "033A09"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "033A01"
replace trained_indiv = 1 if individ == "033A0101"

replace trained_hh = 1 if  hhid == "033A14"
replace trained_indiv = 1 if individ == "033A1402"

replace trained_hh = 1 if  hhid == "033A10"
replace trained_indiv = 1 if individ == "033A1001"

replace trained_hh = 1 if  hhid == "033A02"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "033A04"
replace trained_indiv = 1 if individ == "033A0402"

replace trained_hh = 1 if  hhid == "033A06"
replace trained_indiv = 1 if individ == "033A0601"

replace trained_hh = 1 if  hhid == "033A15"
replace trained_indiv = 1 if individ == "033A1501"

replace trained_hh = 1 if  hhid == "033A20"
replace trained_indiv = 1 if individ == "033A2002"

replace trained_hh = 1 if  hhid == "033B16"
replace trained_indiv = 1 if individ == "033B1601"
replace trained_indiv = 1 if individ == "033B1602"

replace trained_hh = 1 if  hhid == "033B14"
replace trained_indiv = 1 if individ == "033B1401"

replace trained_hh = 1 if  hhid == "033B19"
replace trained_indiv = 1 if individ == "033B1901"

replace trained_hh = 1 if  hhid == "033B17"
replace trained_indiv = 1 if individ == "033B1701"

replace trained_hh = 1 if  hhid == "033B08"
replace trained_indiv = 1 if individ == "033B0801"

replace trained_hh = 1 if  hhid == "033B10"
replace trained_indiv = 1 if individ == "033B1001"

replace trained_hh = 1 if  hhid == "033B11"
replace trained_indiv = 1 if individ == "033B1101"

replace trained_hh = 1 if  hhid == "033B13"
replace trained_indiv = 1 if individ == "033B1301"

replace trained_hh = 1 if  hhid == "033B03"
replace trained_indiv = 1 if individ == "033B0301"

replace trained_hh = 1 if  hhid == "033B09"
replace trained_indiv = 1 if individ == "033B0901"

replace trained_hh = 1 if  hhid == "041A12"
replace trained_indiv = 1 if individ == "041A1202"

replace trained_hh = 1 if  hhid == "041A14"
replace trained_indiv = 1 if individ == "041A1401"

replace trained_hh = 1 if  hhid == "041A09"
replace trained_indiv = 1 if individ == "041A0901"

replace trained_hh = 1 if  hhid == "041A03"
replace trained_indiv = 1 if individ == "041A0301"

replace trained_hh = 1 if  hhid == "041A01"
replace trained_indiv = 1 if individ == "041A0101"

replace trained_hh = 1 if  hhid == "041A07"
replace trained_indiv = 1 if individ == "041A0701"

replace trained_hh = 1 if  hhid == "041A05"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "041A18"
replace trained_indiv = 1 if individ == "041A1801"

replace trained_hh = 1 if  hhid == "041A13"
replace trained_indiv = 1 if individ == "041A1302"

replace trained_hh = 1 if  hhid == "042A16"
replace trained_indiv = 1 if individ == "042A1601"

replace trained_hh = 1 if  hhid == "042A13"
replace trained_indiv = 1 if individ == "042A1301"

replace trained_hh = 1 if  hhid == "042A10"
replace trained_indiv = 1 if individ == "042A1001"

replace trained_hh = 1 if  hhid == "042A15"
replace trained_indiv = 1 if individ == "042A1501"

replace trained_hh = 1 if  hhid == "042A02"
replace trained_indiv = 1 if individ == "042A0202"

replace trained_hh = 1 if  hhid == "042A20"
replace trained_indiv = 1 if individ == "042A2001"

replace trained_hh = 1 if  hhid == "042A01"
replace trained_indiv = 1 if individ == "042A0101"

replace trained_hh = 1 if  hhid == "042A05"
replace trained_indiv = 1 if individ == "042A0502"

replace trained_hh = 1 if  hhid == "042A08"
replace trained_indiv = 1 if individ == "042A0801"

replace trained_hh = 1 if  hhid == "042A03"
replace trained_indiv = 1 if individ == "042A0301"

replace trained_hh = 1 if  hhid == "042B13"
replace trained_indiv = 1 if individ == "042B1301"

replace trained_hh = 1 if  hhid == "042B10"
replace trained_indiv = 1 if individ == "042B1001"

replace trained_hh = 1 if  hhid == "042B10"
replace trained_indiv = 1 if individ == "042B1001"

replace trained_hh = 1 if  hhid == "042B20"
replace trained_indiv = 1 if individ == "042B2001"

replace trained_hh = 1 if  hhid == "042B20"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "042B04"
replace trained_indiv = 1 if individ == "042B0401"

replace trained_hh = 1 if  hhid == "042B17"
replace trained_indiv = 1 if individ == "042B1702"

replace trained_hh = 1 if  hhid == "042B08"
replace trained_indiv = 1 if individ == "042B0801"

replace trained_hh = 1 if  hhid == "042B06"
replace trained_indiv = 1 if individ == "042B0601"

replace trained_hh = 1 if  hhid == "042B01"
replace trained_indiv = 1 if individ == "042B0101"

replace trained_hh = 1 if  hhid == "042B11"
replace trained_indiv = 1 if individ == "042B1102"

replace trained_hh = 1 if  hhid == "042B19"
replace trained_indiv = 1 if individ == "042B1902"

replace trained_hh = 1 if  hhid == "042B09"
replace trained_indiv = 1 if individ == "042B0901"

replace trained_hh = 1 if  hhid == "042B03"
replace trained_indiv = 1 if individ == "042B0301"

replace trained_hh = 1 if  hhid == "043A03"
replace trained_indiv = 1 if individ == "043A0301"

replace trained_hh = 1 if  hhid == "043A07"
replace trained_indiv = 1 if individ == "043A0701"

replace trained_hh = 1 if  hhid == "043A12"
replace trained_indiv = 1 if individ == "043A1202"

replace trained_hh = 1 if  hhid == "043A09"
replace trained_indiv = 1 if individ == "043A0902"

replace trained_hh = 1 if  hhid == "043A08"
replace trained_indiv = 1 if individ == "043A0802"

replace trained_hh = 1 if  hhid == "043A15"
replace trained_indiv = 1 if individ == "043A1501"

replace trained_hh = 1 if  hhid == "043A02"
replace trained_indiv = 1 if individ == "043A0202"

replace trained_hh = 1 if  hhid == "043A16"
replace trained_indiv = 1 if individ == "043A1602"

replace trained_hh = 1 if  hhid == "043A18"
replace trained_indiv = 1 if individ == "043A1801"

replace trained_hh = 1 if  hhid == "043A04"
replace trained_indiv = 1 if individ == "043A0401"

replace trained_hh = 1 if  hhid == "043B19"
replace trained_indiv = 1 if individ == "043B1901"

replace trained_hh = 1 if  hhid == "043B16"
replace trained_indiv = 1 if individ == "043B1601"

replace trained_hh = 1 if  hhid == "043B13"
replace trained_indiv = 1 if individ == "043B1301"

replace trained_hh = 1 if  hhid == "043B06"
replace trained_indiv = 1 if individ == "043B0601"

replace trained_hh = 1 if  hhid == "043B03"
replace trained_indiv = 1 if individ == "043B0301"

replace trained_hh = 1 if  hhid == "043B17"
replace trained_indiv = 1 if individ == "043B1702"

replace trained_hh = 1 if  hhid == "043B05"
replace trained_indiv = 1 if individ == "043B0501"

replace trained_hh = 1 if  hhid == "043B08"
replace trained_indiv = 1 if individ == "043B0801"

replace trained_hh = 1 if  hhid == "043B15"
replace trained_indiv = 1 if individ == "043B1501"

replace trained_hh = 1 if  hhid == "043B14"
replace trained_indiv = 1 if individ == "043B1401"

replace trained_hh = 1 if  hhid == "043B02"
replace trained_indiv = 1 if individ == "043B0201"

replace trained_hh = 1 if  hhid == "051B18"
replace trained_indiv = 1 if individ == "051B1802"

replace trained_hh = 1 if  hhid == "051B14"
replace trained_indiv = 1 if individ == "051B1402"

replace trained_hh = 1 if  hhid == "051B11"
replace trained_indiv = 1 if individ == "051B1101"

replace trained_hh = 1 if  hhid == "051B16"
replace trained_indiv = 1 if individ == "051B1601"

replace trained_hh = 1 if  hhid == "051B01"
replace trained_indiv = 1 if individ == "051B0101"

replace trained_hh = 1 if  hhid == "051B06"
replace trained_indiv = 1 if individ == "051B0601"

replace trained_hh = 1 if  hhid == "051B08"
replace trained_indiv = 1 if individ == "051B0801"

replace trained_hh = 1 if  hhid == "051B12"
replace trained_indiv = 1 if individ == "051B1201"

replace trained_hh = 1 if  hhid == "051B19"
replace trained_indiv = 1 if individ == "051B1903"

replace trained_hh = 1 if  hhid == "051B17"
replace trained_indiv = 1 if individ == "051B1702"

replace trained_hh = 1 if  hhid == "052A09"
replace trained_indiv = 1 if individ == "052A0901"

replace trained_hh = 1 if  hhid == "052A05"
replace trained_indiv = 1 if individ == "052A0502"

replace trained_hh = 1 if  hhid == "052A12"
replace trained_indiv = 1 if individ == "052A1201"

replace trained_hh = 1 if  hhid == "052A17"
replace trained_indiv = 1 if individ == "052A1704"

replace trained_hh = 1 if  hhid == "052A16"
replace trained_indiv = 1 if individ == "052A1601"

replace trained_hh = 1 if  hhid == "052A15"
replace trained_indiv = 1 if individ == "052A1501"

replace trained_hh = 1 if  hhid == "052A04"
replace trained_indiv = 1 if individ == "052A0402"

replace trained_hh = 1 if  hhid == "052A20"
replace trained_indiv = 1 if individ == "052A2001"

replace trained_hh = 1 if  hhid == "052A01"
replace trained_indiv = 1 if individ == "052A0101"

replace trained_hh = 1 if  hhid == "052A02"
replace trained_indiv = 1 if individ == "052A0201"

replace trained_hh = 1 if  hhid == "052B14"
replace trained_indiv = 1 if individ == "052B1402"

replace trained_hh = 1 if  hhid == "052B08"
replace trained_indiv = 1 if individ == "052B0804"

replace trained_hh = 1 if  hhid == "052B18"
replace trained_indiv = 1 if individ == "052B1801"

replace trained_hh = 1 if  hhid == "052B18"
replace trained_indiv = 1 if individ == "052B1801"

replace trained_hh = 1 if  hhid == "052B09"
replace trained_indiv = 1 if individ == "052B0901"

replace trained_hh = 1 if hhid == "052B12"
replace trained_indiv = 1 if individ == "052B1201"

replace trained_hh = 1 if hhid == "052B15"
replace trained_indiv = 1 if individ == "052B1501"

replace trained_hh = 1 if hhid == "052B04"
replace trained_indiv = 1 if individ == "052B0401"

replace trained_hh = 1 if hhid == "052B10"
replace trained_indiv = 1 if individ == "052B1001"

replace trained_hh = 1 if hhid == "052B13"
replace trained_indiv = 1 if individ == "052B1301"

replace trained_hh = 1 if hhid == "052B16"
replace trained_indiv = 1 if individ == "052B1601"

replace trained_hh = 1 if hhid == "052B05"
replace trained_indiv = 1 if individ == "052B0503"

replace trained_hh = 1 if hhid == "053A12"
replace trained_indiv = 1 if individ == "053A1201"

replace trained_hh = 1 if hhid == "053A19"
replace trained_indiv = 1 if individ == "053A0901" 

replace trained_hh = 1 if  hhid == "053A05"
replace trained_indiv = 1 if individ == "053A0501"

replace trained_hh = 1 if hhid == "053A04"
replace trained_indiv = 1 if individ == "053A0402"

replace trained_hh = 1 if  hhid == "053A13"
replace trained_indiv = 1 if individ == "053A1301"

replace trained_hh = 1 if  hhid == "053A09"
replace trained_indiv = 1 if individ == "053A1901"

replace trained_hh = 1 if  hhid == "053A19"
replace trained_indiv = 1 if individ == "053A1901"

replace trained_hh = 1 if hhid == "053A02"
replace trained_indiv = 1 if  individ == "053A0203"

replace trained_hh = 1 if hhid == "053A15"
replace trained_indiv = 1 if  individ == "053A1501"

replace trained_hh = 1 if hhid == "053A08"
replace trained_indiv = 1 if  individ == "053A0801"

replace trained_hh = 1 if hhid == "053A01"
replace trained_indiv = 1 if  individ == "053A0102"

replace trained_hh = 1 if hhid == "053B03"
replace trained_indiv = 1 if  individ == "053B0301"

replace trained_hh = 1 if hhid == "053B08"
replace trained_indiv = 1 if  individ == "053B0802"

replace trained_hh = 1 if hhid == "053B02"
replace trained_indiv = 1 if  individ == "053B0201"

replace trained_hh = 1 if hhid == "053B20"
replace trained_indiv = 1 if  individ == "053B2001"

replace trained_hh = 1 if hhid == "053B10"
replace trained_indiv = 1 if  individ == "053B1001"

replace trained_hh = 1 if hhid == "053B06"
replace trained_indiv = 1 if individ == "053B0604"

replace trained_hh = 1 if hhid == "053B07"
replace trained_indiv = 1 if individ == "053B0701"

replace trained_hh = 1 if  hhid == "053B15"
replace trained_indiv = 1 if individ == "053B1502"

replace trained_hh = 1 if  hhid == "053B11"
replace trained_indiv = 1 if individ == "053B1101"

replace trained_hh = 1 if  hhid == "061A09"
replace trained_indiv = 1 if individ == "061A0901"

replace trained_hh = 1 if  hhid == "061A05"
replace trained_indiv = 1 if individ == "061A0501"

replace trained_hh = 1 if  hhid == "061A16"
replace trained_indiv = 1 if individ == "061A1602"

replace trained_hh = 1 if  hhid == "061A03"
replace trained_indiv = 1 if individ == "061A0303"

replace trained_hh = 1 if  hhid == "061A17"
replace trained_indiv = 1 if individ == "061A1701"

replace trained_hh = 1 if  hhid == "061A01"
replace trained_indiv = 1 if individ == "061A0101"

replace trained_hh = 1 if  hhid == "061A14"
replace trained_indiv = 1 if individ == "061A1401"

replace trained_hh = 1 if  hhid == "061A18"
replace trained_indiv = 1 if individ == "061A1801"

replace trained_hh = 1 if  hhid == "061A13"
replace trained_indiv = 1 if individ == "061A1301"

replace trained_hh = 1 if  hhid == "061A10"
replace trained_indiv = 1 if individ == "061A1002"

replace trained_hh = 1 if  hhid == "061A08"
replace trained_indiv = 1 if individ == "061A0801"

replace trained_hh = 1 if  hhid == "061A11"
replace trained_indiv = 1 if individ == "061A1101"

replace trained_hh = 1 if  hhid == "061B01"
replace trained_indiv = 1 if individ == "061B0103"

replace trained_hh = 1 if  hhid == "061B09"
replace trained_indiv = 1 if individ == "061B0901"

replace trained_hh = 1 if  hhid == "061B14"
replace trained_indiv = 1 if individ == "061B1401"

replace trained_hh = 1 if  hhid == "061B11"
replace trained_indiv = 1 if individ == "061B1101"

replace trained_hh = 1 if  hhid == "061B06"
replace trained_indiv = 1 if individ == "061B0601"

replace trained_hh = 1 if  hhid == "061B18"
replace trained_indiv = 1 if individ == "061B1801"

replace trained_hh = 1 if  hhid == "061B08"
replace trained_indiv = 1 if individ == "061B0801"

replace trained_hh = 1 if  hhid == "061B10"
replace trained_indiv = 1 if individ == "061B1001"

replace trained_hh = 1 if  hhid == "061B03"
replace trained_indiv = 1 if individ == "061B0302"

replace trained_hh = 1 if  hhid == "061B02"
replace trained_indiv = 1 if individ == "061B0202"

replace trained_hh = 1 if  hhid == "061B08"
replace trained_indiv = 1 if individ == "061B0805"

replace trained_hh = 1 if  hhid == "062B12"
replace trained_indiv = 1 if individ == "062B1201"

replace trained_hh = 1 if  hhid == "062B13"
replace trained_indiv = 1 if individ == "062B1301"

replace trained_hh = 1 if  hhid == "062B19"
replace trained_indiv = 1 if individ == "062B1901"

replace trained_hh = 1 if  hhid == "062B03"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "062B09"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "062B06"
replace trained_indiv = 1 if individ == "062B0601"

replace trained_hh = 1 if  hhid == "063A14"
replace trained_indiv = 1 if individ == "063A1401"

replace trained_hh = 1 if  hhid == "063A08"
replace trained_indiv = 1 if individ == "063A0801"

replace trained_hh = 1 if  hhid == "063A07"
replace trained_indiv = 1 if individ == "063A0701"

replace trained_hh = 1 if  hhid == "063A04"
replace trained_indiv = 1 if individ == "063A0401"

replace trained_hh = 1 if  hhid == "063A13"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "063A11"
replace trained_indiv = 1 if individ == "063A1101"

replace trained_hh = 1 if  hhid == "063A03"
replace trained_indiv = 1 if individ == "063A0301"

replace trained_hh = 1 if  hhid == "063A01"
replace trained_indiv = 1 if individ == "063A0101"

replace trained_hh = 1 if  hhid == "063A16"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "063A05"
replace trained_indiv = 1 if individ == "063A0502"

replace trained_hh = 1 if  hhid == "071A12"
replace trained_indiv = 1 if individ == "071A1201"

replace trained_hh = 1 if  hhid == "071A17"
replace trained_indiv = 1 if individ == "071A1701"

replace trained_hh = 1 if  hhid == "071A20"
replace trained_indiv = 1 if individ == "071A2001"

replace trained_hh = 1 if  hhid == "071A08"
replace trained_indiv = 1 if individ == "071A0801"

replace trained_hh = 1 if  hhid == "071A11"
replace trained_indiv = 1 if individ == "071A1101"

replace trained_hh = 1 if  hhid == "071A16"
replace trained_indiv = 1 if individ == "071A1601"

replace trained_hh = 1 if  hhid == "071A04"
replace trained_indiv = 1 if individ == "071A0403"

replace trained_hh = 1 if  hhid == "071A01"
replace trained_indiv = 1 if individ == "071A0101"

replace trained_hh = 1 if  hhid == "071A18"
replace trained_indiv = 1 if individ == "071A1801"

replace trained_hh = 1 if  hhid == "071A07"
replace trained_indiv = 1 if individ == "071A0701"

replace trained_hh = 1 if  hhid == "071A18"
replace trained_indiv = 1 if individ == "071A1802"

replace trained_hh = 1 if  hhid == "071B06"
replace trained_indiv = 1 if individ == "071B0601"

replace trained_hh = 1 if  hhid == "071B07"
replace trained_indiv = 1 if individ == "071B0701"

replace trained_hh = 1 if  hhid == "071B13"
replace trained_indiv = 1 if individ == "071B1301"

replace trained_hh = 1 if  hhid == "071B14"
replace trained_indiv = 1 if individ == "071B1401"

replace trained_hh = 1 if  hhid == "071B16"
replace trained_indiv = 1 if individ == "071B1602"

replace trained_hh = 1 if  hhid == "071B11"
replace trained_indiv = 1 if individ == "071B1101"

replace trained_hh = 1 if  hhid == "071B10"
replace trained_indiv = 1 if individ == "071B1001"

replace trained_hh = 1 if  hhid == "071B09"
replace trained_indiv = 1 if individ == "071B0901"

replace trained_hh = 1 if  hhid == "071B03"
replace trained_indiv = 1 if individ == "071B0301"

replace trained_hh = 1 if  hhid == "071B17"
replace trained_indiv = 1 if individ == "071B1701"

replace trained_hh = 1 if  hhid == "072A12"
replace trained_indiv = 1 if individ == "072A1201"

replace trained_hh = 1 if  hhid == "072A06"
replace trained_indiv = 1 if individ == "072A0601"

replace trained_hh = 1 if  hhid == "072A05"
replace trained_indiv = 1 if individ == "072A0501"

replace trained_hh = 1 if  hhid == "072A05"
replace trained_indiv = 1 if individ == "072A0501"

replace trained_hh = 1 if  hhid == "072A16"
replace trained_indiv = 1 if individ == "072A1601"

replace trained_hh = 1 if  hhid == "072A02"
replace trained_indiv = 1 if individ == "072A0201"

replace trained_hh = 1 if  hhid == "072A19"
replace trained_indiv = 1 if individ == "072A1901"

replace trained_hh = 1 if  hhid == "072A08"
replace trained_indiv = 1 if individ == "072A0801"

replace trained_hh = 1 if  hhid == "072A18"
replace trained_indiv = 1 if individ == "072A1801"

replace trained_hh = 1 if  hhid == "072A11"
replace trained_indiv = 1 if individ == "072A1101"

replace trained_hh = 1 if  hhid == "072A13"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "072A07"
replace trained_indiv = 1 if individ == "072A0701"

replace trained_hh = 1 if  hhid == "072A20"
replace trained_indiv = 1 if individ == "072A2001"

replace trained_hh = 1 if  hhid == "072A09"
replace trained_indiv = 1 if individ == "072A0901"

replace trained_hh = 1 if  hhid == "072B02"
replace trained_indiv = 1 if individ == "072B0201"

replace trained_hh = 1 if  hhid == "072B02"
replace trained_indiv = 1 if individ == "072B0201"

replace trained_hh = 1 if  hhid == "072B14"
replace trained_indiv = 1 if individ == "072B1401"

replace trained_hh = 1 if  hhid == "072B17"
replace trained_indiv = 1 if individ == "072B1701"

replace trained_hh = 1 if  hhid == "072B03"
replace trained_indiv = 1 if individ == "072B0301"

replace trained_hh = 1 if  hhid == "072B08"
replace trained_indiv = 1 if individ == "072B0804"

replace trained_hh = 1 if  hhid == "072B12"
replace trained_indiv = 1 if individ == "072B1201"

replace trained_hh = 1 if  hhid == "072B15"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "072B01"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "072B09"
replace trained_indiv = 1 if individ == "072B0901"

replace trained_hh = 1 if  hhid == "073A20"
replace trained_indiv = 1 if individ == "073A2001"

replace trained_hh = 1 if  hhid == "073A11"
replace trained_indiv = 1 if individ == "073A1101"

replace trained_hh = 1 if  hhid == "073A13"
replace trained_indiv = 1 if individ == "073A1301"

replace trained_hh = 1 if  hhid == "073A18"
replace trained_indiv = 1 if individ == "073A1801"

replace trained_hh = 1 if  hhid == "073A08"
replace trained_indiv = 1 if individ == "073A0801"

replace trained_hh = 1 if  hhid == "073A17"
replace trained_indiv = 1 if individ == "073A1701"

replace trained_hh = 1 if  hhid == "073A16"
replace trained_indiv = 1 if individ == "073A1601"

replace trained_hh = 1 if  hhid == "073A15"
replace trained_indiv = 1 if individ == "073A1501"

replace trained_hh = 1 if  hhid == "073A07"
replace trained_indiv = 1 if individ == "073A0702"

replace trained_hh = 1 if  hhid == "073A14"
replace trained_indiv = 1 if individ == "073A1401"

replace trained_hh = 1 if  hhid == "073A19"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "073A04"
replace trained_indiv = 1 if individ == "073A0401"

replace trained_hh = 1 if  hhid == "073B20"
replace trained_indiv = 1 if individ == "073B2003"

replace trained_hh = 1 if  hhid == "073B11"
replace trained_indiv = 1 if individ == "073B1101"

replace trained_hh = 1 if  hhid == "073B04"
replace trained_indiv = 1 if individ == "073B0403"

replace trained_hh = 1 if  hhid == "073B12"
replace trained_indiv = 1 if individ == "073B1203"

replace trained_hh = 1 if  hhid == "073B01"
replace trained_indiv = 1 if individ == "073B0101"

replace trained_hh = 1 if  hhid == "073B19"
replace trained_indiv = 1 if individ == "073B1921"

replace trained_hh = 1 if  hhid == "073B05"
replace trained_indiv = 1 if individ == "073B0501"

replace trained_hh = 1 if  hhid == "073B02"
replace trained_indiv = 1 if individ == "073B0202"

replace trained_hh = 1 if  hhid == "073B10"
replace trained_indiv = 1 if individ == "073B1002"

replace trained_hh = 1 if  hhid == "073B07"
replace trained_indiv = 1 if individ == "073B0702"

replace trained_hh = 1 if  hhid == "073B03"
replace trained_indiv = 1 if individ == "073B0302"

replace trained_hh = 1 if  hhid == "073B04"
replace trained_indiv = 1 if individ == "073B0401"

replace trained_hh = 1 if  hhid == "073B14"
replace trained_indiv = 1 if individ == "073B1401"

replace trained_hh = 1 if  hhid == "081A05"
replace trained_indiv = 1 if individ == "081A0501"

replace trained_hh = 1 if  hhid == "081A08"
replace trained_indiv = 1 if individ == "081A0801"

replace trained_hh = 1 if  hhid == "081A04"
replace trained_indiv = 1 if individ == "081A0402"

replace trained_hh = 1 if  hhid == "081A07"
replace trained_indiv = 1 if individ == "081A0701"

replace trained_hh = 1 if  hhid == "081A09"
replace trained_indiv = 1 if individ == "081A0901"

replace trained_hh = 1 if  hhid == "081A20"
replace trained_indiv = 1 if individ == "081A2001"

replace trained_hh = 1 if  hhid == "081A03"
replace trained_indiv = 1 if individ == "081A0301"

replace trained_hh = 1 if  hhid == "081A12"
replace trained_indiv = 1 if individ == "081A1201"

replace trained_hh = 1 if  hhid == "081A01"
replace trained_indiv = 1 if individ == "081A0101"

replace trained_hh = 1 if  hhid == "081A16"
replace trained_indiv = 1 if individ == "081A1601"

replace trained_hh = 1 if  hhid == "081B13"
replace trained_indiv = 1 if individ == "081B1301"

replace trained_hh = 1 if  hhid == "081B08"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "081B06"
replace trained_indiv = 1 if individ == "081B0601"

replace trained_hh = 1 if  hhid == "081B07"
replace trained_indiv = 1 if individ == "081B0701"

replace trained_hh = 1 if  hhid == "081B05"
replace trained_indiv = 1 if individ == "081B0501"

replace trained_hh = 1 if  hhid == "081B03"
replace trained_indiv = 1 if individ == "081B0301"

replace trained_hh = 1 if  hhid == "081B01"
replace trained_indiv = 1 if individ == "081B0101"

replace trained_hh = 1 if  hhid == "081B04"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "081B19"
replace trained_indiv = 1 if individ == "081B1901"

replace trained_hh = 1 if  hhid == "081B18"
replace trained_indiv = 1 if individ == "081B1801"

replace trained_hh = 1 if  hhid == "082A15"
replace trained_indiv = 1 if individ == "082A1502"

replace trained_hh = 1 if  hhid == "082A02"
replace trained_indiv = 1 if individ == "082A0201"

replace trained_hh = 1 if  hhid == "082A17"
replace trained_indiv = 1 if individ == "082A1701"

replace trained_hh = 1 if  hhid == "082A16"
replace trained_indiv = 1 if individ == "082A1601"

replace trained_hh = 1 if  hhid == "082A10"
replace trained_indiv = 1 if individ == "082A1001"

replace trained_hh = 1 if  hhid == "082A12"
replace trained_indiv = 1 if individ == "082A1202"

replace trained_hh = 1 if  hhid == "082A11"
replace trained_indiv = 1 if individ == "082A1101"

replace trained_hh = 1 if  hhid == "082A07"
replace trained_indiv = 1 if individ == "082A0702"

replace trained_hh = 1 if  hhid == "082A01"
replace trained_indiv = 1 if individ == "082A0102"

replace trained_hh = 1 if  hhid == "082A08"
replace trained_indiv = 1 if individ == "082A0801"

replace trained_hh = 1 if  hhid == "082B03"
replace trained_indiv = 1 if individ == "082B0302"

replace trained_hh = 1 if  hhid == "082B10"
replace trained_indiv = 1 if individ == "082B1002"

replace trained_hh = 1 if  hhid == "082B06"
replace trained_indiv = 1 if individ == "082B0602"

replace trained_hh = 1 if  hhid == "082B07"
replace trained_indiv = 1 if individ == "082B0702"

replace trained_hh = 1 if  hhid == "082B14"
replace trained_indiv = 1 if individ == "082B1402"

replace trained_hh = 1 if  hhid == "082B02"
replace trained_indiv = 1 if individ == "082B0202"

replace trained_hh = 1 if  hhid == "082B08"
replace trained_indiv = 1 if individ == "082B0803"

replace trained_hh = 1 if  hhid == "082B04"
replace trained_indiv = 1 if individ == "082B0401"

replace trained_hh = 1 if  hhid == "082B01"
replace trained_indiv = 1 if individ == "082B0102"

replace trained_hh = 1 if  hhid == "082B17"
replace trained_indiv = 1 if individ == "082B1701"

replace trained_hh = 1 if  hhid == "083A03"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "083A13"
replace trained_indiv = 1 if individ == "083A1301"

replace trained_hh = 1 if  hhid == "083A01"
replace trained_indiv = 1 if individ == "083A0102"

replace trained_hh = 1 if  hhid == "083A10"
replace trained_indiv = 1 if individ == "083A1001"

replace trained_hh = 1 if  hhid == "083A18"
replace trained_indiv = 1 if individ == "083A1801"

replace trained_hh = 1 if  hhid == "083A06"
replace trained_indiv = 1 if individ == "083A0602"

replace trained_hh = 1 if  hhid == "083A16"
replace trained_indiv = 1 if individ == "083A1601"

replace trained_hh = 1 if  hhid == "083A12"
replace trained_indiv = 1 if individ == "083A1201"

replace trained_hh = 1 if  hhid == "083A05"
replace trained_indiv = 1 if individ == "083A0501"

replace trained_hh = 1 if  hhid == "083A04"
replace trained_indiv = 1 if individ == "083A0402"

replace trained_hh = 1 if  hhid == "083B04"
replace trained_indiv = 1 if individ == "083B0401"

replace trained_hh = 1 if  hhid == "083B06"
replace trained_indiv = 1 if individ == "083B0601"

replace trained_hh = 1 if  hhid == "083B09"
replace trained_indiv = 1 if individ == "083B0901"

replace trained_hh = 1 if  hhid == "083B05"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "083B07"
replace trained_indiv = 1 if individ == "083B0701"

replace trained_hh = 1 if  hhid == "083B01"
replace trained_indiv = 1 if individ == "083B0101"

replace trained_hh = 1 if  hhid == "083B01"
replace trained_indiv = 1 if individ == "083B0101"

replace trained_hh = 1 if  hhid == "083B10"
replace trained_indiv = 1 if individ == "083B1001"

replace trained_hh = 1 if  hhid == "083B16"
replace trained_indiv = 1 if individ == "083B1602"

replace trained_hh = 1 if  hhid == "083B20"
replace trained_indiv = 1 if individ == "083B2005"

replace trained_hh = 1 if  hhid == "083B13"
replace trained_indiv = 1 if individ == "083B1301"

replace trained_hh = 1 if  hhid == "091A01"
replace trained_indiv = 1 if individ == "091A0102"

replace trained_hh = 1 if  hhid == "091A06"
replace trained_indiv = 1 if individ == "091A0601"

replace trained_hh = 1 if  hhid == "091A02"
replace trained_indiv = 1 if individ == "091A0202"

replace trained_hh = 1 if  hhid == "091A16"
replace trained_indiv = 1 if individ == "091A1601"

replace trained_hh = 1 if  hhid == "091A07"
replace trained_indiv = 1 if individ == "091A0701"

replace trained_hh = 1 if  hhid == "091A11"
replace trained_indiv = 1 if individ == "091A1101"

replace trained_hh = 1 if  hhid == "091A17"
replace trained_indiv = 1 if individ == "091A1702"

replace trained_hh = 1 if  hhid == "091A03"
replace trained_indiv = 1 if individ == "091A0301"

replace trained_hh = 1 if  hhid == "091A10"
replace trained_indiv = 1 if individ == "091A1001"

replace trained_hh = 1 if  hhid == "091A05"
replace trained_indiv = 1 if individ == "091A0501"

replace trained_hh = 1 if  hhid == "091B08"
replace trained_indiv = 1 if individ == "091B0802"

replace trained_hh = 1 if  hhid == "091B06"
replace trained_indiv = 1 if individ == "091B0601"

replace trained_hh = 1 if  hhid == "091B20"
replace trained_indiv = 1 if individ == "091B2001"

replace trained_hh = 1 if  hhid == "091B05"
replace trained_indiv = 1 if individ == "091B0501"

replace trained_hh = 1 if  hhid == "091B12"
replace trained_indiv = 1 if individ == "091B1202"

replace trained_hh = 1 if  hhid == "091B17"
replace trained_indiv = 1 if individ == "091B1701"

replace trained_hh = 1 if  hhid == "091B01"
replace trained_indiv = 1 if individ == "091B0101"

replace trained_hh = 1 if  hhid == "091B16"
replace trained_indiv = 1 if individ == "091B1601"

replace trained_hh = 1 if  hhid == "091B03"
replace trained_indiv = 1 if individ == "091B0301"

replace trained_hh = 1 if  hhid == "091B07"
replace trained_indiv = 1 if individ == "091B0701"

replace trained_hh = 1 if  hhid == "092A01"
replace trained_indiv = 1 if individ == "092A0101"

replace trained_hh = 1 if  hhid == "092A02"
replace trained_indiv = 1 if individ == "092A0202"

replace trained_hh = 1 if  hhid == "092A18"
replace trained_indiv = 1 if individ == "092A1803"

replace trained_hh = 1 if  hhid == "092A12"
replace trained_indiv = 1 if individ == "092A1201"

replace trained_hh = 1 if  hhid == "092A14"
replace trained_indiv = 1 if individ == "092A1401"

replace trained_hh = 1 if  hhid == "092A03"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "092A06"
replace trained_indiv = 1 if individ == "092A0601"

replace trained_hh = 1 if  hhid == "092A05"
replace trained_indiv = 1 if individ == "092A0504"

replace trained_hh = 1 if  hhid == "092A07"
replace trained_indiv = 1 if individ == "092A0702"

replace trained_hh = 1 if  hhid == "092A19"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "092B19"
replace trained_indiv = 1 if individ == "092B1902"

replace trained_hh = 1 if  hhid == "092B14"
replace trained_indiv = 1 if individ == "092B1403"

replace trained_hh = 1 if  hhid == "092B04"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "092B05"
replace trained_indiv = 1 if individ == "092B0501"

replace trained_hh = 1 if  hhid == "092B07"
replace trained_indiv = 1 if individ == "092B0701"

replace trained_hh = 1 if  hhid == "092B10"
replace trained_indiv = 1 if individ == "092B1002"

replace trained_hh = 1 if  hhid == "092B02"
replace trained_indiv = 1 if individ == "092B0201"

replace trained_hh = 1 if  hhid == "092B01"
replace trained_indiv = 1 if individ == "092B0101"

replace trained_hh = 1 if  hhid == "092B20"
replace trained_indiv = 1 if individ == "092B2001"

replace trained_hh = 1 if  hhid == "092B09"
replace trained_indiv = 1 if individ == "092B0902"

replace trained_hh = 1 if  hhid == "093A12"
replace trained_indiv = 1 if individ == "093A1202"

replace trained_hh = 1 if  hhid == "093A05"
replace trained_indiv = 1 if individ == "093A0502"

replace trained_hh = 1 if  hhid == "093A20"
replace trained_indiv = 1 if individ == "093A2002"

replace trained_hh = 1 if  hhid == "093A01"
replace trained_indiv = 1 if individ == "093A0102"

replace trained_hh = 1 if  hhid == "093A19"
replace trained_indiv = 1 if individ == "093A1901"

replace trained_hh = 1 if  hhid == "093A13"
replace trained_indiv = 1 if individ == "093A1301"

replace trained_hh = 1 if  hhid == "093A07"
replace trained_indiv = 1 if individ == "093A0701"

replace trained_hh = 1 if  hhid == "093A06"
replace trained_indiv = 1 if individ == "093A0601"

replace trained_hh = 1 if  hhid == "093A04"
replace trained_indiv = 1 if individ == "093A0401"

replace trained_hh = 1 if  hhid == "093A16"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "093B20"
replace trained_indiv = 1 if individ == "093B2001"

replace trained_hh = 1 if  hhid == "093B03"
replace trained_indiv = 1 if individ == "093B0301"

replace trained_hh = 1 if  hhid == "093B05"
replace trained_indiv = 1 if individ == "093B0501"

replace trained_hh = 1 if  hhid == "093B09"
replace trained_indiv = 1 if individ == "093B0901"

replace trained_hh = 1 if  hhid == "093B14"
replace trained_indiv = 1 if individ == "093B1401"

replace trained_hh = 1 if  hhid == "093B11"
replace trained_indiv = 1 if individ == "093B1102"

replace trained_hh = 1 if  hhid == "093B12"
replace trained_indiv = 1 if individ == "093B1201"

replace trained_hh = 1 if  hhid == "093B15"
replace trained_indiv = 1 if individ == "093B1501"

replace trained_hh = 1 if  hhid == "093B07"
replace trained_indiv = 1 if individ == "093B0701"

replace trained_hh = 1 if  hhid == "093B18"
replace trained_indiv = 1 if individ == "093B1803"

replace trained_hh = 1 if  hhid == "101B06"
replace trained_indiv = 1 if individ == "101B0601"

replace trained_hh = 1 if  hhid == "101B10"
replace trained_indiv = 1 if individ == "101B1001"

replace trained_hh = 1 if  hhid == "101B11"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "101B01"
replace trained_indiv = 1 if individ == "101B0101"

replace trained_hh = 1 if  hhid == "101B09"
replace trained_indiv = 1 if individ == "101B0901"

replace trained_hh = 1 if  hhid == "101B16"
replace trained_indiv = 1 if individ == "101B1601"

replace trained_hh = 1 if  hhid == "101B17"
replace trained_indiv = 1 if individ == "101B1701"

replace trained_hh = 1 if  hhid == "101B18"
replace trained_indiv = 1 if individ == "101B1801"

replace trained_hh = 1 if  hhid == "101B03"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "102A02"
replace trained_indiv = 1 if individ == "102A0201"

replace trained_hh = 1 if  hhid == "102A11"
replace trained_indiv = 1 if individ == "102A1101"

replace trained_hh = 1 if  hhid == "102A14"
replace trained_indiv = 1 if individ == "102A1411"

replace trained_hh = 1 if  hhid == "102A06"
replace trained_indiv = 1 if individ == "102A0601"

replace trained_hh = 1 if  hhid == "102A12"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "102A01"
replace trained_indiv = 1 if individ == "102A0101"

replace trained_hh = 1 if  hhid == "102A04"
replace trained_indiv = 1 if individ == "102A0401"

replace trained_hh = 1 if  hhid == "102A05"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "102B12"
replace trained_indiv = 1 if individ == "102B1202"

replace trained_hh = 1 if  hhid == "102B14"
replace trained_indiv = 1 if individ == "102B1402"

replace trained_hh = 1 if  hhid == "102B18"
replace trained_indiv = 1 if individ == "102B1801"

replace trained_hh = 1 if  hhid == "102B07"
replace trained_indiv = 1 if individ == "102B0702"

replace trained_hh = 1 if  hhid == "102B20"
replace trained_indiv = 1 if individ == "102B2001"

replace trained_hh = 1 if  hhid == "102B15"
replace trained_indiv = 1 if individ == "102B1501"

replace trained_hh = 1 if  hhid == "102B08"
replace trained_indiv = 1 if individ == "102B0810"

replace trained_hh = 1 if  hhid == "102B11"
replace trained_indiv = 1 if individ == "102B1102"

replace trained_hh = 1 if  hhid == "102B02"
replace trained_indiv = 1 if individ == "102B0202"

replace trained_hh = 1 if  hhid == "102B17"
replace trained_indiv = 1 if individ == "102B1701"

replace trained_hh = 1 if  hhid == "103A12"
replace trained_indiv = 1 if individ == "103A1201"

replace trained_hh = 1 if  hhid == "103A16"
replace trained_indiv = 1 if individ == "103A1602"

replace trained_hh = 1 if  hhid == "103A19"
replace trained_indiv = 1 if individ == "103A1902"

replace trained_hh = 1 if  hhid == "103A18"
replace trained_indiv = 1 if individ == "103A1804"

replace trained_hh = 1 if  hhid == "103A02"
replace trained_indiv = 1 if individ == "103A0201"

replace trained_hh = 1 if  hhid == "103A01"
replace trained_indiv = 1 if individ == "103A0102"

replace trained_hh = 1 if  hhid == "103A17"
replace trained_indiv = 1 if individ == "103A1702"

replace trained_hh = 1 if  hhid == "103A05"
replace trained_indiv = 1 if individ == "103A0502"

replace trained_hh = 1 if  hhid == "103A09"
replace trained_indiv = 1 if individ == "103A0902"

replace trained_hh = 1 if  hhid == "103A20"
replace trained_indiv = 1 if individ == "103A2006"

replace trained_hh = 1 if  hhid == "103B04"
replace trained_indiv = 1 if individ == "103B0401"

replace trained_hh = 1 if  hhid == "103B07"
replace trained_indiv = 1 if individ == "103B0701"

replace trained_hh = 1 if  hhid == "103B19"
replace trained_indiv = 1 if individ == "103B1901"

replace trained_hh = 1 if  hhid == "103B08"
replace trained_indiv = 1 if individ == "103B0801"

replace trained_hh = 1 if  hhid == "103B20"
replace trained_indiv = 1 if individ == "103B2001"

replace trained_hh = 1 if  hhid == "103B18"
replace trained_indiv = 1 if individ == "103B1801"

replace trained_hh = 1 if  hhid == "103B16"
replace trained_indiv = 1 if individ == "103B1601"

replace trained_hh = 1 if  hhid == "103B15"
replace trained_indiv = 1 if individ == "103B1501"

replace trained_hh = 1 if  hhid == "103B03"
replace trained_indiv = 1 if individ == "103B0301"

replace trained_hh = 1 if hhid == "103B13"
replace trained_indiv = 1 if individ == "103B1302"

replace trained_hh = 1 if hhid == "111B14"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "111B09"
replace trained_indiv = 1 if individ == "111B0901"

replace trained_hh = 1 if  hhid == "111B01"
replace trained_indiv = 1 if individ == "111B0102"

replace trained_hh = 1 if  hhid == "111B02"
replace trained_indiv = 1 if individ == "111B0201"

replace trained_hh = 1 if  hhid == "111B10"
replace trained_indiv = 1 if individ == "111B1001"

replace trained_hh = 1 if  hhid == "111B20"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "111B06"
replace trained_indiv = 1 if individ == "111B0601"

replace trained_hh = 1 if  hhid == "111B15"
replace trained_indiv = 1 if individ == "111B1502"

replace trained_hh = 1 if  hhid == "111B07"
replace trained_indiv = 1 if individ == "111B0701"

replace trained_hh = 1 if  hhid == "111B12"
replace trained_indiv = 1 if individ == "111B1201"

replace trained_hh = 1 if  hhid == "112A15"
replace trained_indiv = 1 if individ == "112A1501"

replace trained_hh = 1 if  hhid == "112A11"
replace trained_indiv = 1 if individ == "112A1101"

replace trained_hh = 1 if  hhid == "112A12"
replace trained_indiv = 1 if individ == "112A1201"

replace trained_hh = 1 if  hhid == "112A04"
replace trained_indiv = 1 if individ == "112A0401"

replace trained_hh = 1 if  hhid == "112A05"
replace trained_indiv = 1 if individ == "112A0502"

replace trained_hh = 1 if  hhid == "112A08"
replace trained_indiv = 1 if individ == "112A0802"

replace trained_hh = 1 if  hhid == "112A07"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "112A18"
replace trained_indiv = 1 if individ == "112A1803"

replace trained_hh = 1 if  hhid == "112A16"
replace trained_indiv = 1 if individ == "112A1602"

replace trained_hh = 1 if  hhid == "112A09"
replace trained_indiv = 1 if individ == "112A0901"

replace trained_hh = 1 if  hhid == "112A20"
replace trained_indiv = 1 if individ == "112A2002"

replace trained_hh = 1 if  hhid == "112B10"
replace trained_indiv = 1 if individ == "112B1001"

replace trained_hh = 1 if  hhid == "112B03"
replace trained_indiv = 1 if individ == "112B0301"

replace trained_hh = 1 if  hhid == "112B16"
replace trained_indiv = 1 if individ == "112B1601"

replace trained_hh = 1 if  hhid == "112B17"
replace trained_indiv = 1 if individ == "112B1701"

replace trained_hh = 1 if  hhid == "112B12"
replace trained_indiv = 1 if individ == "112B1201"

replace trained_hh = 1 if  hhid == "112B04"
replace trained_indiv = 1 if individ == "112B0401"

replace trained_hh = 1 if  hhid == "112B09"
replace trained_indiv = 1 if individ == "112B0902"

replace trained_hh = 1 if  hhid == "112B02"
replace trained_indiv = 1 if individ == "112B0201"

replace trained_hh = 1 if  hhid == "112B13"
replace trained_indiv = 1 if individ == "112B1301"

replace trained_hh = 1 if  hhid == "112B08"
replace trained_indiv = 1 if individ == "112B0801"

replace trained_hh = 1 if  hhid == "113A03"
replace trained_indiv = 1 if individ == "113A0301"

replace trained_hh = 1 if  hhid == "113A02"
replace trained_indiv = 1 if individ == "113A0202"

replace trained_hh = 1 if  hhid == "113A10"
replace trained_indiv = 1 if individ == "113A1003"

replace trained_hh = 1 if  hhid == "113A09"
replace trained_indiv = 1 if individ == "113A0901"

replace trained_hh = 1 if  hhid == "113A17"
replace trained_indiv = 1 if individ == "113A1701"

replace trained_hh = 1 if  hhid == "113A19"
replace trained_indiv = 1 if individ == "113A1916"

replace trained_hh = 1 if  hhid == "113A14"
replace trained_indiv = 1 if individ == "113A1401"

replace trained_hh = 1 if  hhid == "113A07"
replace trained_indiv = 1 if individ == "113A0701"

replace trained_hh = 1 if  hhid == "113A08"
replace trained_indiv = 1 if individ == "113A0801"

replace trained_hh = 1 if  hhid == "113A15"
replace trained_indiv = 1 if individ == "113A1501"

replace trained_hh = 1 if  hhid == "113A02"
replace trained_indiv = 1 if individ == "113A0201"

replace trained_hh = 1 if  hhid == "113B04"
replace trained_indiv = 1 if individ == "113B0401"

replace trained_hh = 1 if  hhid == "113B18"
replace trained_indiv = 1 if individ == "113B1801"

replace trained_hh = 1 if  hhid == "113B15"
replace trained_indiv = 1 if individ == "113B1501"

replace trained_hh = 1 if  hhid == "113B11"
replace trained_indiv = 1 if individ == "113B1101"

replace trained_hh = 1 if  hhid == "113B10"
replace trained_indiv = 1 if individ == "113B1001"

replace trained_hh = 1 if  hhid == "113B06"
replace trained_indiv = 1 if individ == "113B0601"

replace trained_hh = 1 if  hhid == "113B16"
replace trained_indiv = 1 if individ == "113B1601"

replace trained_hh = 1 if  hhid == "113B02"
replace trained_indiv = 1 if individ == "113B0201"

replace trained_hh = 1 if  hhid == "113B20"
replace trained_indiv = 1 if individ == "113B2001"

replace trained_hh = 1 if  hhid == "113B17"
replace trained_indiv = 1 if individ == "113B1701"

replace trained_hh = 1 if  hhid == "113B12"
replace trained_indiv = 1 if individ == "113B1201"

replace trained_hh = 1 if  hhid == "113B03"
replace trained_indiv = 1 if individ == "113B0309"

replace trained_hh = 1 if  hhid == "121A16"
replace trained_indiv = 1 if individ == "121A1605"

replace trained_hh = 1 if  hhid == "121A13"
replace trained_indiv = 1 if individ == "121A1301"

replace trained_hh = 1 if  hhid == "121A06"
replace trained_indiv = 1 if individ == "121A0601"

replace trained_hh = 1 if  hhid == "121A07"
replace trained_indiv = 1 if individ == "121A0701"

replace trained_hh = 1 if  hhid == "121A03"
replace trained_indiv = 1 if individ == "121A0301"

replace trained_hh = 1 if  hhid == "121A20"
replace trained_indiv = 1 if individ == "121A2001"

replace trained_hh = 1 if  hhid == "121A05"
replace trained_indiv = 1 if individ == "121A0501"

replace trained_hh = 1 if  hhid == "121A02"
replace trained_indiv = 1 if individ == "121A0202"

replace trained_hh = 1 if  hhid == "121A12"
replace trained_indiv = 1 if individ == "121A1206"

replace trained_hh = 1 if  hhid == "121A08"
replace trained_indiv = 1 if individ == "121A0802"

replace trained_hh = 1 if  hhid == "121B06"
replace trained_indiv = 1 if individ == "121B0601"

replace trained_hh = 1 if  hhid == "121B16"
replace trained_indiv = 1 if individ == "121B1601"

replace trained_hh = 1 if  hhid == "121B09"
replace trained_indiv = 1 if individ == "121B0901"

replace trained_hh = 1 if  hhid == "121B12"
replace trained_indiv = 1 if individ == "121B1201"

replace trained_hh = 1 if  hhid == "121B20"
replace trained_indiv = 1 if individ == "121B2001"

replace trained_hh = 1 if  hhid == "121B18"
replace trained_indiv = 1 if individ == "121B1801"

replace trained_hh = 1 if  hhid == "121B14"
replace trained_indiv = 1 if individ == "121B1401"

replace trained_hh = 1 if  hhid == "121B07"
replace trained_indiv = 1 if individ == "121B0701"

replace trained_hh = 1 if  hhid == "121B08"
replace trained_indiv = 1 if individ == "121B0801"

replace trained_hh = 1 if  hhid == "121B17"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "122A15"
replace trained_indiv = 1 if individ == "122A1501"

replace trained_hh = 1 if  hhid == "122A09"
replace trained_indiv = 1 if individ == "122A0901"

replace trained_hh = 1 if  hhid == "122A14"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "122A13"
replace trained_indiv = 1 if individ == "122A1302"

replace trained_hh = 1 if  hhid == "122A07"
replace trained_indiv = 1 if individ == "122A0701"

replace trained_hh = 1 if  hhid == "122A19"
replace trained_indiv = 1 if individ == "122A1901"

replace trained_hh = 1 if  hhid == "122A20"
replace trained_indiv = 1 if individ == "122A2001"

replace trained_hh = 1 if  hhid == "122A06"
replace trained_indiv = 1 if individ == "122A0601"

replace trained_hh = 1 if  hhid == "122A11"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "122B18"
replace trained_indiv = 1 if individ == "122B1801"

replace trained_hh = 1 if  hhid == "122B07"
replace trained_indiv = 1 if individ == "122B0701"

replace trained_hh = 1 if  hhid == "122B10"
replace trained_indiv = 1 if individ == "122B1001"

replace trained_hh = 1 if  hhid == "122B20"
replace trained_indiv = 1 if individ == "122B2001"

replace trained_hh = 1 if  hhid == "122B04"
replace trained_indiv = 1 if individ == "122B0401"

replace trained_hh = 1 if  hhid == "122B16"
replace trained_indiv = 1 if individ == "122B1601"

replace trained_hh = 1 if  hhid == "122B11"
replace trained_indiv = 1 if individ == "122B1101"

replace trained_hh = 1 if  hhid == "122B12"
replace trained_indiv = 1 if individ == "122B1201"

replace trained_hh = 1 if  hhid == "122B19"
replace trained_indiv = 1 if individ == "122B1903"

replace trained_hh = 1 if  hhid == "122B15"
replace trained_indiv = 1 if individ == "122B1501"

replace trained_hh = 1 if  hhid == "123A09"
replace trained_indiv = 1 if individ == "123A0901"

replace trained_hh = 1 if  hhid == "123A17"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "123A06"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "123A20"
replace trained_indiv = 1 if individ == "123A2001"

replace trained_hh = 1 if  hhid == "123A10"
replace trained_indiv = 1 if individ == "123A1002"

replace trained_hh = 1 if  hhid == "123A13"
replace trained_indiv = 1 if individ == "123A1301"

replace trained_hh = 1 if  hhid == "123B01"
replace trained_indiv = 1 if individ == "123B0101"

replace trained_hh = 1 if  hhid == "123B10"
replace trained_indiv = 1 if individ == "123B1001"

replace trained_hh = 1 if  hhid == "123B08"
replace trained_indiv = 1 if individ == "123B0801"

replace trained_hh = 1 if  hhid == "123B17"
replace trained_indiv = 1 if individ == "123B1701"

replace trained_hh = 1 if  hhid == "123B09"
replace trained_indiv = 1 if individ == "123B0901"

replace trained_hh = 1 if  hhid == "123B04"
replace trained_indiv = 1 if individ == "123B0401"

replace trained_hh = 1 if  hhid == "123B02"
replace trained_indiv = 1 if individ == "123B0202"

replace trained_hh = 1 if  hhid == "131A03"
replace trained_indiv = 1 if individ == "131A0302"

replace trained_hh = 1 if  hhid == "131A08"
replace trained_indiv = 1 if individ == "131A0802"

replace trained_hh = 1 if  hhid == "131A14"
replace trained_indiv = 1 if individ == "131A1403"

replace trained_hh = 1 if  hhid == "131A12"
replace trained_indiv = 1 if individ == "131A1201"

replace trained_hh = 1 if  hhid == "131A04"
replace trained_indiv = 1 if individ == "131A0401"

replace trained_hh = 1 if  hhid == "131A13"
replace trained_indiv = 1 if individ == "131A1301"

replace trained_hh = 1 if  hhid == "131A09"
replace trained_indiv = 1 if individ == "131A0902"

replace trained_hh = 1 if  hhid == "131A17"
replace trained_indiv = 1 if individ == "131A1701"

replace trained_hh = 1 if  hhid == "131A07"
replace trained_indiv = 1 if individ == "131A0701"

replace trained_hh = 1 if  hhid == "131A05"
replace trained_indiv = 1 if individ == "131A0501"

replace trained_hh = 1 if  hhid == "131A05"
replace trained_indiv = 1 if individ == "131A0501"

replace trained_hh = 1 if  hhid == "131B19"
replace trained_indiv = 1 if individ == "131B1901"

replace trained_hh = 1 if  hhid == "131B12"
replace trained_indiv = 1 if individ == "131B1201"

replace trained_hh = 1 if  hhid == "131B02"
replace trained_indiv = 1 if individ == "131B0201"

replace trained_hh = 1 if  hhid == "131B09"
replace trained_indiv = 1 if individ == "131B0901"

replace trained_hh = 1 if  hhid == "131B08"
replace trained_indiv = 1 if individ == "131B0801"

replace trained_hh = 1 if  hhid == "131B20"
replace trained_indiv = 1 if individ == "131B2001"

replace trained_hh = 1 if  hhid == "131B05"
replace trained_indiv = 1 if individ == "131B0501"

replace trained_hh = 1 if  hhid == "131B13"
replace trained_indiv = 1 if individ == "131B1302"

replace trained_hh = 1 if  hhid == "131B16"
replace trained_indiv = 1 if individ == "131B1602"

replace trained_hh = 1 if  hhid == "131B04"
replace trained_indiv = 1 if individ == "131B0401"

replace trained_hh = 1 if  hhid == "131B13"
replace trained_indiv = 1 if individ == "131B1301"

replace trained_hh = 1 if  hhid == "153A10"
replace trained_indiv = 1 if individ == "153A1001"

replace trained_hh = 1 if  hhid == "153A20"
replace trained_indiv = 1 if individ == "153A2001"

replace trained_hh = 1 if  hhid == "153A05"
replace trained_indiv = 1 if individ == "153A0502"

replace trained_hh = 1 if  hhid == "153A01"
replace trained_indiv = 1 if individ == "153A0101"

replace trained_hh = 1 if  hhid == "153A08"
replace trained_indiv = 1 if individ == "153A0801"

replace trained_hh = 1 if  hhid == "153A04"
replace trained_indiv = 1 if individ == "153A0401"

replace trained_hh = 1 if  hhid == "153A09"
replace trained_indiv = 1 if individ == "153A0908"

replace trained_hh = 1 if  hhid == "153A17"
replace trained_indiv = 1 if individ == "153A1701"

replace trained_hh = 1 if  hhid == "153A07"
replace trained_indiv = 1 if individ == "153A0701"

replace trained_hh = 1 if  hhid == "153A20"
replace trained_indiv = 1 if individ == "153A2001"

replace trained_hh = 1 if  hhid == "132B05"
replace trained_indiv = 1 if individ == "132B0501"

replace trained_hh = 1 if  hhid == "132B20"
replace trained_indiv = 1 if individ == "132B2001"

replace trained_hh = 1 if  hhid == "132B03"
replace trained_indiv = 1 if individ == "132B0302"

replace trained_hh = 1 if  hhid == "132B18"
replace trained_indiv = 1 if individ == "132B1801"

replace trained_hh = 1 if  hhid == "132B11"
replace trained_indiv = 1 if individ == "132B1102"

replace trained_hh = 1 if  hhid == "132B10"
replace trained_indiv = 1 if individ == "132B1001"

replace trained_hh = 1 if  hhid == "132B07"
replace trained_indiv = 1 if individ == "132B0701"

replace trained_hh = 1 if  hhid == "132B13"
replace trained_indiv = 1 if individ == "132B1302"

replace trained_hh = 1 if  hhid == "132B15"
replace trained_indiv = 1 if individ == "132B1502"

replace trained_hh = 1 if  hhid == "132B19"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "133A10"
replace trained_indiv = 1 if individ == "133A1002"

replace trained_hh = 1 if  hhid == "133A14"
replace trained_indiv = 1 if individ == "133A1401"

replace trained_hh = 1 if  hhid == "133A03"
replace trained_indiv = 1 if individ == "133A0301"

replace trained_hh = 1 if  hhid == "133A04"
replace trained_indiv = 1 if individ == "133A0401"

replace trained_hh = 1 if  hhid == "133A18"
replace trained_indiv = 1 if individ == "133A1801"

replace trained_hh = 1 if  hhid == "133A05"
replace trained_indiv = 1 if individ == "133A0501"

replace trained_hh = 1 if  hhid == "133A06"
replace trained_indiv = 1 if individ == "133A0601"

replace trained_hh = 1 if  hhid == "133A09"
replace trained_indiv = 1 if individ == "133A0901"

replace trained_hh = 1 if hhid == "133A08"
replace trained_indiv = 1 if individ == "133A0801"
replace hh_phone = 775158158 if hhid == "133A08"

replace trained_hh = 1 if  hhid == "133A13"
replace trained_indiv = 1 if individ == "133A1301"

replace trained_hh = 1 if  hhid == "141A20"
replace trained_indiv = 1 if individ == "141A2001"

replace trained_hh = 1 if  hhid == "141A08"
replace trained_indiv = 1 if individ == "141A0801"

replace trained_hh = 1 if  hhid == "141A09"
replace trained_indiv = 1 if individ == "141A0901"

replace trained_hh = 1 if  hhid == "141A19"
replace trained_indiv = 1 if individ == "141A1901"

replace trained_hh = 1 if  hhid == "141A05"
replace trained_indiv = 1 if individ == "141A0502"

replace trained_hh = 1 if  hhid == "141A11"
replace trained_indiv = 1 if individ == "141A1101"

replace trained_hh = 1 if  hhid == "141A17"
replace trained_indiv = 1 if individ == "141A1701"

replace trained_hh = 1 if  hhid == "141A12"
replace trained_indiv = 1 if individ == "141A1202"

replace trained_hh = 1 if  hhid == "141A02"
replace trained_indiv = 1 if individ == "141A0201"

replace trained_hh = 1 if  hhid == "141A13"
replace trained_indiv = 1 if individ == "141A1301"

replace trained_hh = 1 if  hhid == "141A07"
replace trained_indiv = 1 if individ == "141A0701"

replace trained_hh = 1 if  hhid == "142A09"
replace trained_indiv = 1 if individ == "142A0901"

replace trained_hh = 1 if  hhid == "142A19"
replace trained_indiv = 1 if individ == "142A1901"

replace trained_hh = 1 if  hhid == "142A07"
replace trained_indiv = 1 if individ == "142A0701"

replace trained_hh = 1 if  hhid == "142A02"
replace trained_indiv = 1 if individ == "142A0201"

replace trained_hh = 1 if  hhid == "142A12"
replace trained_indiv = 1 if individ == "142A1201"

replace trained_hh = 1 if  hhid == "142A10"
replace trained_indiv = 1 if individ == "142A1002"

replace trained_hh = 1 if  hhid == "142A15"
replace trained_indiv = 1 if individ == "142A1502"

replace trained_hh = 1 if  hhid == "142A13"
replace trained_indiv = 1 if individ == "142A1301"

replace trained_hh = 1 if  hhid == "142A14"
replace trained_indiv = 1 if individ == "142A1401"

replace trained_hh = 1 if  hhid == "143A12"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "143A11"
replace trained_indiv = 1 if individ == "143A1102"

replace trained_hh = 1 if  hhid == "143A14"
replace trained_indiv = 1 if individ == "143A1402"

replace trained_hh = 1 if  hhid == "143A10"
replace trained_indiv = 1 if individ == "143A1004"

replace trained_hh = 1 if  hhid == "143A15"
replace trained_indiv = 1 if individ == "143A1501"

replace trained_hh = 1 if  hhid == "143A03"
replace trained_indiv = 1 if individ == "143A0307"

replace trained_hh = 1 if  hhid == "143A13"
replace trained_indiv = 1 if individ == "143A1301"

replace trained_hh = 1 if  hhid == "143A07"
replace trained_indiv = 1 if individ == "143A0702"

replace trained_hh = 1 if  hhid == "143A06"
replace trained_indiv = 1 if individ == "143A0602"

replace trained_hh = 1 if  hhid == "143A16"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "151A06"
replace trained_indiv = 1 if individ == "151A0601"

replace trained_hh = 1 if  hhid == "151A17"
replace trained_indiv = 1 if individ == "151A1701"

replace trained_hh = 1 if  hhid == "133A08"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "151A01"
replace trained_indiv = 1 if individ == "151A0101"

replace trained_hh = 1 if  hhid == "151A11"
replace trained_indiv = 1 if individ == "151A1101"

replace trained_hh = 1 if  hhid == "151A13"
replace trained_indiv = 1 if individ == "151A1301"

replace trained_hh = 1 if  hhid == "151A20"
replace trained_indiv = 1 if individ == "151A2002"

replace trained_hh = 1 if  hhid == "151A09"
replace trained_indiv = 1 if individ == "151A0901"

replace trained_hh = 1 if  hhid == "151A02"
replace trained_indiv = 1 if individ == "151A0201"

replace trained_hh = 1 if  hhid == "151A18"
replace trained_indiv = 1 if individ == "151A1802"

replace trained_hh = 1 if  hhid == "161A14"
replace trained_indiv = 1 if individ == "161A1401"

replace trained_hh = 1 if  hhid == "161A11"
replace trained_indiv = 1 if individ == "161A1102"

replace trained_hh = 1 if  hhid == "161A01"
replace trained_indiv = 1 if individ == "161A0101"

replace trained_hh = 1 if  hhid == "161A04"
replace trained_indiv = 1 if individ == "161A0401"

replace trained_hh = 1 if  hhid == "161A12"
replace trained_indiv = 1 if individ == "161A1201"

replace trained_hh = 1 if  hhid == "161A20"
replace trained_indiv = 1 if individ == "161A2001"

replace trained_hh = 1 if  hhid == "161A09"
replace trained_indiv = 1 if individ == "161A0901"

replace trained_hh = 1 if  hhid == "161A02"
replace trained_indiv = 1 if individ == "161A0201"

replace trained_hh = 1 if  hhid == "171A09"
replace trained_indiv = 1 if individ == "171A0901"

replace trained_hh = 1 if  hhid == "171A10"
replace trained_indiv = 1 if individ == "171A1001"

replace trained_hh = 1 if  hhid == "171A14"
replace trained_indiv = 1 if individ == "171A1401"

replace trained_hh = 1 if  hhid == "171A17"
replace trained_indiv = 1 if individ == "171A1702"

replace trained_hh = 1 if  hhid == "171A11"
replace trained_indiv = 1 if individ == "171A1101"

replace trained_hh = 1 if  hhid == "171A02"
replace trained_indiv = 1 if individ == "171A0201"

replace trained_hh = 1 if  hhid == "171A07"
replace trained_indiv = 1 if individ == "171A0704"

replace trained_hh = 1 if  hhid == "171A13"
replace trained_indiv = 1 if individ == "171A1301"

replace trained_hh = 1 if  hhid == "171A18"
replace trained_indiv = 1 if individ == "171A1801"

replace trained_hh = 1 if  hhid == "171A04"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "171A05"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "031A19"
replace trained_indiv = 1 if individ == "031A1901"

replace trained_hh = 1 if  hhid == "031B01"
replace trained_indiv = 1 if individ == "031B0101"

replace trained_hh = 1 if  hhid == "031B19"
replace trained_indiv = 1 if individ == "031B1908"

replace trained_hh = 1 if  hhid == "031B20"
replace trained_indiv = 1 if individ == "031B2005"

replace trained_hh = 1 if  hhid == "041A20"
replace trained_indiv = 1 if individ == "041A2002"

replace trained_hh = 1 if  hhid == "053B14"
replace trained_indiv = 1 if individ == "053B1401"

replace trained_hh = 1 if  hhid == "062B01"
replace trained_indiv = 1 if individ == "062B0101"

replace trained_hh = 1 if  hhid == "062B02"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "062B04"
replace trained_indiv = 1 if individ == "062B0401"

replace trained_hh = 1 if  hhid == "062B05"
replace trained_indiv = 1 if individ == "062B0501"

replace trained_hh = 1 if  hhid == "072B04"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "092A20"
replace trained_indiv = 1 if individ == "092A2001"

replace trained_hh = 1 if  hhid == "101B15"
replace trained_indiv = 1 if individ == "101B1501"

replace trained_hh = 1 if  hhid == "102A15"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "102A17"
replace trained_indiv = 1 if individ == "102A1701"

replace trained_hh = 1 if  hhid == "122A18"
replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "123A18"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "123B06"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "153A13"
replace trained_indiv = 1 if individ == "153A1301"

replace trained_hh = 1 if  hhid == "151A08"
replace trained_indiv = 1 if individ == "151A0801"

replace trained_hh = 1 if  hhid == "161A06"
*replace trained_indiv = 1 if individ == ""

*save "$output/Treated_vars_sign_in_sheet_ONLY.dta", clear

********************************************************* Add additional households that were NOT on the sign-in sheet info *****************************************


replace trained_hh = 1 if  hhid == "021A02"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "021A20"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "123B05"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "012B10"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "082B09"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "052A06"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "123A16"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "012B08"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "021A03"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "073A01"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "142A01"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "073B09"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "083A09"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "161A03"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "021A12"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "022B02"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "021A06"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "123B15"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "113B14"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "023B09"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if  hhid == "023B07"
*replace trained_indiv = 1 if individ == ""

replace trained_hh = 1 if hhid == "071B12"
*replace trained_indiv = 1 if individ == ""


*************************** late additions (treatment done July 7, 2024) ******
replace trained_hh = 1 if hhid == "062A06"
replace trained_indiv = 1 if individ == "062A0602"

replace trained_hh = 1 if hhid == "062A02"
replace trained_indiv = 1 if individ == "062A0213"

replace trained_hh = 1 if hhid == "062A01" 

replace trained_hh = 1 if hhid == "062A03" 
replace trained_indiv = 1 if individ == "062A0303"

replace trained_hh = 1 if hhid == "062A10"
replace trained_indiv = 1 if individ == "062A1002"

replace trained_hh = 1 if hhid == "062A15"  
replace trained_hh = 1 if individ == "062A1503"

replace trained_hh = 1 if hhid == "062A18" 
replace trained_indiv = 1 if individ == "062A1801"

replace trained_hh = 1 if hhid == "062A19" 

save "$output\treated_variable_df.dta", replace


******************************* Merge with Questionnaire Data set ************************

/*
use "$output/Treated_variables_df", clear 
merge m:m hhid using "$participant/Questionnaire.dta"
*/



************************************ verify counts of hhids and individuals recorded ******************************************************



********* this checks how many unique hhids were marked as trained **********
/*
preserve 

keep if trained_hh == 1

* Step 2: Count the unique hhids
egen unique_hhids = tag(hhid)

* Step 3: Sum the tags to find out how many unique hhids exist
count if unique_hhids == 1

*keep if unique_hhids == 1

* "$output/Treated_variables_SORT",replace
restore 
*/


*********** this checks how many individuals showed up ************************
/*

preserve 

keep if trained_indiv == 1

* Step 2: Count the unique hhids
egen unique_hhids = tag(hhid)

* Step 3: Sum the tags to find out how many unique hhids exist
count if unique_hhids == 1

restore 

*/




******************************************************* find the missing village ***************************************************************

****** check to make sure this .do file reflects the sign-in sheet list 

/*

import excel "$participant\_Transcribed_sign-in_sheets.xlsx", firstrow clear


merge m:m hhid using "$output/Treated_variables_SORT"

drop if Village == ""
drop if hhid == ""

sort _merge
*/



************************************* compare against the participants who took the participation survey *****************************************

****** check to make sure the participation survey matches the sign in sheet list 
/*

import delimited using "C:\Users\km978\Box\NSF Senegal\Data Management\_CRDES_RawData\Treatment\test.csv", varnames(1) clear

* remove hyphens in the hhids:

gen hhid = subinstr(pull_select_name, "-", "", .)

replace hhid = "053B06" if pull_select_hhid == "053B-06"
replace hhid = "092B07" if new_respondant == "Thierno Ibrahima Ba"
* Check for duplicates 
duplicates report hhid 

duplicates tag hhid, gen(ugh)
*keep if ugh == 1
sort hhid
duplicates drop hhid, force 
drop ugh
* After removing duplicates, bring in the sign-in sheet info
*save "C:\Users\km978\Box\NSF Senegal\Data Management\_CRDES_RawData\Treatment\Questionnaire.dta", replace 

merge m:m hhid using "$participant\_Transcribed_sign-in_sheets.dta"

sort _merge

keep if _merge == 1

*Keep the hhids that are NOT in the sign-in sheets to add them to the corrections above 
keep _merge Name treated_name PhoneNumber notes hhid

export excel "$output/Questionnaire_additional_households.xlsx",replace
*/

/*
duplicates tag hhid, gen(ugh)
keep if ugh == 1
sort hhid
duplicates drop hhid, force 
drop ugh
drop notes
*/



**************************************** Sign-in sheet cleaning *************************************************


/*
import excel "$participant\_Transcribed_sign-in_sheets.xlsx", firstrow clear

drop if hhid == ""
drop if Village == ""

duplicates report hhid
duplicates tag hhid, gen(arg)
keep if arg == 1

save "$participant\_Transcribed_sign-in_sheets.dta", replace
*/


****************************************************** List for CRDES to verify **********************************************************************
/*

use "$output/Treated_variables_df", clear 

merge m:m hhid using "$participant\_Transcribed_sign-in_sheets.dta"

	keep if trained_hh == 1

	* Generate a flag for hhids with at least one trained_indiv == 1
	bysort hhid: egen flag_has_one = max(trained_indiv == 1)

	* Keep only hhids where the flag is 0 (no trained_indiv == 1)
	keep if flag_has_one == 0


* Do some cleaning

	rename PhoneNumber sign_in_sheet_phone
	rename treated_name treated_sign_in_sheet_name
	rename Village village_name
	rename VillageCode village_code 


	keep village_name village_code hhid hh_head_name_complet hh_phone hh_full_name_calc_ treated_sign_in_sheet_name sign_in_sheet_phone trained_hh hh_relation

	order village_name village_code hhid hh_head_name_complet hh_phone hh_full_name_calc_ treated_sign_in_sheet_name sign_in_sheet_phone trained_hh hh_relation
* Create flag to capture each household that does NOT have an individual who was trained 
	bysort hhid: egen hhid_flag = max(trained_hh == 1)

* Keep only the first occurrence of each hhid after flagging
	bysort hhid: keep if _n == 1

	duplicates report hhid 

	drop trained_hh hh_relation hh_full_name_calc_ hhid_flag

export excel "$output/Trained_households_missing_indiv.xlsx", firstrow(variables) replace



*/













