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
if "`c(username)'"=="socrm" global master "C:\Users\socrm\Box\NSF Senegal"
if "`c(username)'"=="kls329" global master "C:\Users\kls329\Box"
if "`c(username)'"=="km978" global master "C:\Users\km978\Box\NSF Senegal"
if "`c(username)'"=="Kateri" global master "C:\Users\Kateri\Box\NSF Senegal"
if "`c(username)'"=="admmi" global master "C:\Users\admmi\Box\NSF Senegal"


**************************** data file paths ****************************

global data "$master\Data_Management\_CRDES_RawData\Midline\Household_Survey_Data"

**************************** output file paths ****************************

global village_observations "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Village_Observations"
global household_roster "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Household_Roster"
global knowledge "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Knowledge"
global health "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Health" 
global agriculture_inputs "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Agriculture_Inputs"
global agriculture_production "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Agriculture_Production"
global food_consumption "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Food_Consumption"
global income "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Income"
global standard_living "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Standard_Living"
global beliefs "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Beliefs" 
global enum_observations "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Enumerator_Observations"


**************************** Import household data ****************************

* Note: update this every new data cleaning session ***
** KRM - needed to re-output these checks to add a filter variable, update next round 
import delimited "$data\DISES_Enquête_ménage_midline_VF_WIDE_6Feb.csv", clear varnames(1) bindquote(strict)

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

merge m:1 individ using "C:\Users\socrm\Box\NSF Senegal\Data_Management\_CRDES_CleanData\Baseline\Identified\All_Villages_With_Individual_IDs.dta"

keep if _merge == 3

gen diff_age = pull_hh_age__ - hh_age_