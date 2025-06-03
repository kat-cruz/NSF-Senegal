*** DISES Midline Data Checks - Check for correct individual IDs, that they pull correctly ***
*** File originally created By: Molly Doruska 
     ***>>> Adapted by Kateri Mouawad & Alex Mills <<<***
*** Updates recorded in GitHub ***

*==============================================================================

clear all
set mem 100m
set maxvar 30000
set matsize 11000
set more off

**************************************************
* SET FILE PATHS
**************************************************

* Set base Box path for each user
if "`c(username)'"=="mollydoruska" global master "/Users/mollydoruska/Library/CloudStorage/Box-Box/NSF Senegal"
if "`c(username)'"=="kls329" global master "C:\Users\kls329\Box"
if "`c(username)'"=="km978" global master "C:\Users\km978\Box\NSF Senegal"
if "`c(username)'"=="Kateri" global master "C:\Users\Kateri\Box\NSF Senegal"
if "`c(username)'"=="admmi" global master "C:\Users\admmi\Box\NSF Senegal"


**************************** data file paths ****************************

global data "$master/Data_Management/Data/_CRDES_RawData/Midline/Household_Survey_Data"
global clean_data "$master/Data_Management/Data/_CRDES_CleanData/Midline/Identified"

**************************** output file paths ****************************

global village_observations "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Village_Observations"
global household_roster "$master\Data_Management\Output\Data_Processing\Checks\Midline\Midline_Household_Roster\_Archive"
global knowledge "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Knowledge"
global health "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Health" 
global agriculture_inputs "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Agriculture_Inputs"
global agriculture_production "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Agriculture_Production"
global food_consumption "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Food_Consumption"
global income "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Income"
global standard_living "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Standard_Living"
global beliefs "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Beliefs" 
global enum_observations "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Enumerator_Observations"

global individual_ids "$master\Data_Management\Data\_CRDES_CleanData\Baseline\Identified"

**************************** Import household data ****************************
import delimited "$data/DISES_Enquête_ménage_midline_VF_WIDE_6Feb.csv", clear varnames(1) bindquote(strict)

*** identify if lack of pull_hhid's is ongoing or just a first few days issue *** 
keep submissiondate starttime endtime hhid_village sup sup_name enqu enqu_o hh_global_id fu_mem_id_* pull_hh_full_name_calc__* pull_hh_gender__* pull_hh_age__* pull_hh_individ_*

tostring fu_mem_id_56 fu_mem_id_57 pull_hh_full_name_calc__56 pull_hh_full_name_calc__57 pull_hh_individ_56 pull_hh_individ_57, replace 

reshape long fu_mem_id_ pull_hh_full_name_calc__ pull_hh_gender__ pull_hh_age__ pull_hh_individ_, i(submissiondate starttime endtime hhid_village sup sup_name enqu enqu_o hh_global_id) j(personindex)

drop if fu_mem_id_ == ""

drop if fu_mem_id_ == "."

*** create list of people missing individual IDs *** 
preserve 

keep if pull_hh_individ_ == ""

*** save list of people missing individual IDs *** 
export excel "$household_roster\missing_pull_hh_individ.xlsx", replace firstrow(variables)

restore 

*** see if current individual IDs are for the correct people ***  
preserve 

drop if pull_hh_individ_ == ""

rename pull_hh_individ_ individ 

merge m:1 individ using "$individual_ids\All_Villages_With_Individual_IDs.dta"

keep if _merge == 3

gen diff_age = pull_hh_age__ - hh_age_

sum diff_age 

restore 

*** identify individual IDs for those missing individual IDs *** 
import excel "$household_roster\missing_pull_hh_individ.xlsx", first clear 

*** prepare for merge with individual IDs from baseline *** 
rename hh_global_id hhid 
rename pull_hh_full_name_calc__ hh_full_name_calc_
rename pull_hh_age__ hh_age_
rename pull_hh_gender__ hh_gender_ 

*** merge in baseline individual IDs *** 
merge 1:m hhid hh_full_name_calc_ hh_age_ hh_gender_ using "$individual_ids\All_Villages_With_Individual_IDs.dta"

*** drop baseline people not in this dataset *** 
drop if _merge == 2 

drop _merge 

*** add in additional IDs that did not merge with baseline *** 
*** due to wingdings/French accents in names *** 
replace individ = "030A1508" if hhid == "030A15" & hh_full_name_calc_ == "BÃ¨bÃ¨ awa Diop" & hh_gender_ == 2 & hh_age_ == 27 
replace individ = "030A1603" if hhid == "030A16" & hh_full_name_calc_ == "Farmata CissÃ¨" & hh_gender_ == 2 & hh_age_ == 8
replace individ = "030A2009" if hhid == "030A20" & hh_full_name_calc_ == "OUMOU KHAÃÂRI DIALLO" & hh_gender_ == 2 & hh_age_ == 21
replace individ = "062B1405" if hhid == "062B14" & hh_full_name_calc_ == "AÃÂSSATA GAYE" & hh_gender_ == 2 & hh_age_ == 0
replace individ = "091B1512" if hhid == "091B15" & hh_full_name_calc_ == "NAÃÂSSÃ MAMADOU SOW" & hh_gender_ == 2 & hh_age_ == 6 
replace individ = "102B1111" if hhid == "102B11" & hh_full_name_calc_ == "GuillÃ¨ Djick" & hh_gender_ == 2 & hh_age_ == 8 
replace individ = "102B1408" if hhid == "102B14" & hh_full_name_calc_ == "MariÃ¨le Ndiaye" & hh_gender_ == 2 & hh_age_ == 16 
replace individ = "102B1410" if hhid == "102B14" & hh_full_name_calc_ == "Oumou hÃÂ Ã¯ri Ndiaye" & hh_gender_ == 2 & hh_age_ == 9 
replace individ = "102B1503" if hhid == "102B15" & hh_full_name_calc_ == "DjamilÃ¨ Ly" & hh_gender_ == 2 & hh_age_ == 56
replace individ = "102B1811" if hhid == "102B18" & hh_full_name_calc_ == "Hamet SoumarÃ¨" & hh_gender_ == 1 & hh_age_ == 13 
replace individ = "102B2006" if hhid == "102B20" & hh_full_name_calc_ == "ISMAÃâ¹L SARR" & hh_gender_ == 1 & hh_age_ == 34
replace individ = "110B0102" if hhid == "110B01" & hh_full_name_calc_ == "Fary GuÃ¨ye" & hh_gender_ == 2 & hh_age_ == 30 
replace individ = "110B0309" if hhid == "110B03" & hh_full_name_calc_ == "Ami kollÃ¨  Ndiaye" & hh_gender_ == 2 & hh_age_ == 34
replace individ = "110B0710" if hhid == "110B07" & hh_full_name_calc_ == "Khady GuÃ¨ye" & hh_gender_ == 2 & hh_age_ == 6 
replace individ = "110B0708" if hhid == "110B07" & hh_full_name_calc_ == "NdÃ¨ye Ndiaye" & hh_gender_ == 2 & hh_age_ == 9 
replace individ = "110B0705" if hhid == "110B07" & hh_full_name_calc_ == "Ousmane DiakhatÃ¨" & hh_gender_ == 1 & hh_age_ == 28 
replace individ = "110B0805" if hhid == "110B08" & hh_full_name_calc_ == "MARÃËME GUEYE" & hh_gender_ == 2 & hh_age_ == 14
replace individ = "110B1503" if hhid == "110B15" & hh_full_name_calc_ == "BiguÃ¨ Ndiaye" & hh_gender_ == 2 & hh_age_ == 30
replace individ = "110B1508" if hhid == "110B15" & hh_full_name_calc_ == "ThiÃ¨ga Ndiaye" & hh_gender_ == 2 & hh_age_ == 13
replace individ = "110B1811" if hhid == "110B18" & hh_full_name_calc_ == "DÃ¨guÃ¨ne Fall" & hh_gender_ == 2 & hh_age_ == 2 
replace individ = "110B1802" if hhid == "110B18" & hh_full_name_calc_ == "DÃ¨guÃ¨ne GuÃ¨ye" & hh_gender_ == 2 & hh_age_ == 55
replace individ = "110B1810" if hhid == "110B18" & hh_full_name_calc_ == "NdÃ¨ye Nor Ndiaye" & hh_gender_ == 2 & hh_age_ == 25
replace individ = "110B1911" if hhid == "110B19" & hh_full_name_calc_ == "MARÃËME FALL" & hh_gender_ == 2 & hh_age_ == 9 
replace individ = "122A0707" if hhid == "122A07" & hh_full_name_calc_ == "OUMOU KHAÃÂRI FALL" & hh_gender_ == 2 & hh_age_ == 10 
replace individ = "122A1603" if hhid == "122A16" & hh_full_name_calc_ == "BAÃÂLO FALL" & hh_gender_ == 1 & hh_age_ == 33 
replace individ = "123A1006" if hhid == "123A10" & hh_full_name_calc_ == "ISMAÃâ¹L DIOP" & hh_gender_ == 1 & hh_age_ == 5 
replace individ = "123A1903" if hhid == "123A19" & hh_full_name_calc_ == "AÃÂCHA DIALLO" & hh_gender_ == 2 & hh_age_ == 16 
replace individ = "123A1905" if hhid == "123A19" & hh_full_name_calc_ == "NAFISSATOU NGAÃÂDO DIALLO" & hh_gender_ == 2 & hh_age_ == 6

*** replace pull_hh_individ_ with individ
tostring pull_hh_individ_, replace  
replace pull_hh_individ_ = individ 

*** undo rename variables *** 
rename hhid hh_global_id
rename hh_full_name_calc_ pull_hh_full_name_calc__ 
rename hh_age_ pull_hh_age__ 
rename hh_gender_  pull_hh_gender__ 

*** keep variables from original dataset *** 
keep submissiondate starttime endtime hhid_village sup sup_name enqu enqu_o hh_global_id fu_mem_id_ pull_hh_full_name_calc__ pull_hh_gender__ pull_hh_age__ pull_hh_individ_ personindex 

*** save long version of individual id's that didn't pull in correctly at baseline *** 
save "$clean_data\individual_ids_for_missings_in_midline_hh_roster_long.dta" 

*** save wide version of individual id's that didn't pull in correctly at baseline *** 
reshape wide fu_mem_id_ pull_hh_full_name_calc__ pull_hh_gender__ pull_hh_age__ pull_hh_individ_, i(submissiondate starttime endtime hhid_village sup sup_name enqu enqu_o hh_global_id) j(personindex)

save "$clean_data\individual_ids_for_missing_in_midline_hh_roster_wide.dta"

*** identify potential duplicate household members in baseline data *** 
use "$individual_ids\All_Villages_With_Individual_IDs.dta", clear
bysort hhid hh_full_name_calc_ hh_gender_ hh_age_ hh_relation_with_: gen dup = _N

keep if dup > 1 

*save "$individual_ids\Potential_Duplicate_HH_Members_Baseline.dta"

*** merge in midline individual IDs to see what happened with these individuals at midline ***
use "$clean_data\Midline_Individual_IDs.dta", clear 

drop _merge 

merge m:1 individ using "$individual_ids\Potential_Duplicate_HH_Members_Baseline.dta"

drop if _merge == 1 

*** only 1 out of the 5 potential duplicates does not exist in the midline data ***
