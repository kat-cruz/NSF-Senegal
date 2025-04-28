**************************************************
* DISES Baseline to Baseline Specifications *
* File Created By: Alexander Mills *
* File Last Updated By: Alexander Mills *
* Updates Tracked on Git *
**************************************************

*** This Do File PROCESSES: PUT ALL SCRIPTS HERE***
*** This Do File CREATES: ANCOVA regression outputs for the PAP specifcaitons on baseline to midline data
						
*** Procedure: ***
* 

capture log close
clear all
set mem 100m
set maxvar 30000
set matsize 11000
set more off
version 14.1

**************************************************
* SET FILE PATHS
**************************************************

disp "`c(username)'"

* Set global path based on the username
if "`c(username)'" == "admmi" global master "C:\Users\admmi\Box\NSF Senegal"
if "`c(username)'" == "km978" global master "C:\Users\km978\Box\NSF Senegal"
if "`c(username)'" == "socrm" global master "C:\Users\socrm\Box\NSF Senegal"

global baseline "$master\Data_Management\Data\_CRDES_CleanData\Baseline\Deidentified"
global midline "$master\Data_Management\Data\_CRDES_CleanData\Midline\Deidentified"
global balance "$master\Data_Management\Output\Analysis\Balance_Tables\baseline_balance_tables_data_PAP.dta"
global treatment "$master\Data_Management\Data\_CRDES_CleanData\Treatment\Identified\treatment_indicator_PII.dta"

global baseline_agriculture "$base\Complete_Baseline_Agriculture.dta"
global baseline_beliefs"$baseline\Complete_Baseline_Beliefs.dta"
global baseline_community "$baseline\Complete_Baseline_Community.dta"
global baseline_enumerator"$baseline\Complete_Baseline_Enumerator_Observations.dta"
global baseline_geographies"$baseline\Complete_Baseline_Geographies.dta"
global baseline_health"$baseline\Complete_Baseline_Health.dta"
global baseline_household "$baseline\Complete_Baseline_Household_Roster.dta"
global baseline_income"$baseline\Complete_Baseline_Income.dta"
global baseline_knowledge"$baseline\Complete_Baseline_Knowledge.dta"
global baseline_lean "$baseline\Complete_Baseline_Lean_Season.dta"
global baseline_production "$baseline\Complete_Baseline_Production.dta"
global baseline_standard "$baseline\Complete_Baseline_Standard_Of_Living.dta"

global midline_agriculture "$midline\Complete_Midline_Agriculture.dta"
global midline_beliefs"$midline\Complete_Midline_Beliefs.dta"
global midline_community "$midline\Complete_Midline_Community.dta"
global midline_enumerator"$midline\Complete_Midline_Enumerator_Observations.dta"
global midline_geographies"$midline\Complete_Midline_Geographies.dta"
global midline_health"$midline\Complete_Midline_Health.dta"
global midline_household "$midline\Complete_Midline_Household_Roster.dta"
global midline_income"$midline\Complete_Midline_Income.dta"
global midline_knowledge"$midline\Complete_Midline_Knowledge.dta"
global midline_lean "$midline\Complete_Midline_Lean_Season.dta"
global midline_production "$midline\Complete_Midline_Production.dta"
global midline_standard "$midline\Complete_Midline_Standard_Of_Living.dta"

**************************************************
* CREATE DATA FOR SPECIFCATIONS
**************************************************

* import balance
* kat created this for balance tables and it has all the controls constructed
* check about the asset_index???
use "$balance", clear
/* x'_i includes controls for baseline village,
household and/or individual characteristics, namely distance to nearest
health clinic and number of water access points used by villagers
(village-level variables), household size, access to piped water, and
wealth as measured by a household asset index), and the household
head's age, sex and literacy status (household-level variables) */

* label controls

* import treatment
use "$treatment", clear
* collapse for if treated household
collapse (max) trained_hh, by(hhid)
tempfile treatment_clean
save `treatment_clean', replace

* import baseline
use "$baseline_household", clear
* y*_iv is the baseline value of the outcome of interest

* label baseline values

* import midline
use "$midline_household", clear
* y_iv is the midline value of the outcome of interest

* label midline values

* merge everything together

* extract treatment arm and stratum
gen byte treatment_arm = real(substr(hhid_village, 3, 1))
label define treatlbl 0 "Control" 1 "Arm A - Public Health" 2 "Arm B - Private Benefits" 3 "Arm C - Both Messages"
label values treatment_arm treatlbl

gen stratum = substr(hhid_village, 4, 1)

**************************************************
* SPECIFICATIONS
**************************************************
* primary outcomes
* 1.1.1

* 1.1.2

* 1.1.3
* need endline

* 1.1.4

* 1.1.5

* 1.1.6

* 1.1.7

* 1.1.8.1
* demands paristological

* 1.1.8.2

* 1.1.9.
* demands paristological

* 1.1.10.1

* 1.1.10.2

* 1.1.11

* 1.1.12
* midline to endline

* secondary outcomes
* 2.1.1

* 2.1.2

* 2.1.3
* baseline to endline

* 2.2.1
* demands sweep/drone imagery

* 2.2.2
* demands upstream water point as regressor

* 2.2.3
* demands upstream water point as regressor

* 2.3.1
* demands focus group





	
