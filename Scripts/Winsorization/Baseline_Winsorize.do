*** DISES baseline data winsorize *** 
*** File Created By: Molly Doruska ***
*** File Last Updated By: Molly Doruska ***
*** File Last Updated On: November 7, 2024 ***

clear all 

set maxvar 20000

**** Master file path  ****
if "`c(username)'"=="socrm" {
                global master "C:\Users\socrm\Box\NSF Senegal\Data Management"
}
else if "`c(username)'"=="kls329" {
                global master "/Users/kls329\Box\NSF Senegal\Data Management"
}
else if "`c(username)'"=="km978" {
                global master "C:\Users\km978\Box\NSF Senegal\Data Management"
}
else if "`c(username)'"=="Kateri" {
                global master "C:\Users\Kateri\Box\NSF Senegal\Data Management"
}

*** additional file paths ***
global data_deidentified "$master\_CRDES_CleanData\Baseline\Deidentified"
global winsorized "$data_deidentified\Winsorized"
global intermediate "$winsorized\Intermediate"

*** import household roster data *** 
use "$data_deidentified\Complete_Baseline_Household_Roster", clear   

*** check distribution of variables at the household per capita level *** 
*** looking for > 4 sigma or > 6 sigma observations to winsorize *** 
*** first calculate household per capita values of data *** 
*** variables to winsorize: hh_04, hh_05, hh_06, hh_07, hh_08, hh_09, hh_13 ***
*** hh_14, hh_16, hh_17, hh_21, hh_22, hh_24, hh_25 *** 
*** so need to reshape the data *** 

*** need variables and household size *** 
*** keep only hhid, variables to winsorize *** 
*** will merge back with main dataset later *** 
keep hhid hh_04_* hh_05_* hh_06_* hh_07_* hh_08_* hh_09_* hh_14_* hh_16_* hh_17_* hh_22_* hh_24_* hh_25_*

reshape long hh_04_ hh_05_ hh_06_ hh_07_ hh_08_ hh_09_ hh_14_ hh_16_ hh_17_ hh_22_ hh_24_ hh_25_ , i(hhid) j(individual)

*** drop variables for which there is no individual *** 
drop if hh_04_ == . & hh_05_ == . & hh_06_ == . & hh_07_ == . & hh_08_ == . & hh_09_ == .  & hh_14_ == .  & hh_16_ == .  & hh_17_ == .  & hh_22_ == .  & hh_24_ == .  & hh_25_ == .

*** drop -9s for these calculations *** 
replace hh_05_ = . if hh_05_ == -9 
replace hh_06_ = . if hh_06_ == -9 
replace hh_07_ = . if hh_07_ == -9 
replace hh_08_ = . if hh_08_ == -9
 
*** collapse to household level sums to then create per capita variables *** 
collapse (max) hh_size=individual (sum) hh_04_ (sum) hh_05_ (sum) hh_06_ (sum) hh_07_ (sum) hh_08_ (sum) hh_09_ (sum) hh_14_ (sum) hh_16_ (sum) hh_17_ (sum) hh_22_ (sum) hh_24_ (sum) hh_25_, by(hhid)
 
*** calculate per capita variables *** 
gen hh_04_pc = hh_04_ / hh_size 
gen hh_05_pc = hh_05_ / hh_size 
gen hh_06_pc = hh_06_ / hh_size 
gen hh_07_pc = hh_07_ / hh_size 
gen hh_08_pc = hh_08_ / hh_size 
gen hh_09_pc = hh_09_ / hh_size
gen hh_14_pc = hh_14_ / hh_size 
gen hh_16_pc = hh_16_ / hh_size 
gen hh_17_pc = hh_17_ / hh_size 
gen hh_22_pc = hh_22_ / hh_size   
gen hh_24_pc = hh_24_ / hh_size 
gen hh_25_pc = hh_25_ / hh_size 

*** calculate mean, standard deviation of each variable *** 
egen hh_04_mean = mean(hh_04_pc)
egen hh_04_sd = sd(hh_04_pc)
egen hh_05_mean = mean(hh_05_pc)
egen hh_05_sd = sd(hh_05_pc)
egen hh_06_mean = mean(hh_06_pc)
egen hh_06_sd = sd(hh_06_pc)
egen hh_07_mean = mean(hh_07_pc)
egen hh_07_sd = sd(hh_07_pc)
egen hh_08_mean = mean(hh_08_pc)
egen hh_08_sd = sd(hh_08_pc)
egen hh_09_mean = mean(hh_09_pc)
egen hh_09_sd = sd(hh_09_pc)
egen hh_14_mean = mean(hh_14_pc)
egen hh_14_sd = sd(hh_14_pc)
egen hh_16_mean = mean(hh_16_pc)
egen hh_16_sd = sd(hh_16_pc)
egen hh_17_mean = mean(hh_17_pc)
egen hh_17_sd = sd(hh_17_pc)
egen hh_22_mean = mean(hh_22_pc)
egen hh_22_sd = sd(hh_22_pc)
egen hh_24_mean = mean(hh_24_pc)
egen hh_24_sd = sd(hh_24_pc)
egen hh_25_mean = mean(hh_25_pc)
egen hh_25_sd = sd(hh_25_pc)

*** calculate 4 sigma, 6 sigma *** 
gen hh_04_4s = hh_04_mean + 4*hh_04_sd 
gen hh_04_6s = hh_04_mean + 6*hh_04_sd 
gen hh_05_4s = hh_05_mean + 4*hh_05_sd 
gen hh_05_6s = hh_05_mean + 6*hh_05_sd 
gen hh_06_4s = hh_06_mean + 4*hh_06_sd 
gen hh_06_6s = hh_06_mean + 6*hh_06_sd 
gen hh_07_4s = hh_07_mean + 4*hh_07_sd 
gen hh_07_6s = hh_07_mean + 6*hh_07_sd 
gen hh_08_4s = hh_08_mean + 4*hh_08_sd 
gen hh_08_6s = hh_08_mean + 6*hh_08_sd 
gen hh_09_4s = hh_09_mean + 4*hh_09_sd 
gen hh_09_6s = hh_09_mean + 6*hh_09_sd 
gen hh_14_4s = hh_14_mean + 4*hh_14_sd 
gen hh_14_6s = hh_14_mean + 6*hh_14_sd 
gen hh_16_4s = hh_16_mean + 4*hh_16_sd 
gen hh_16_6s = hh_16_mean + 6*hh_16_sd 
gen hh_17_4s = hh_17_mean + 4*hh_17_sd 
gen hh_17_6s = hh_17_mean + 6*hh_17_sd 
gen hh_22_4s = hh_22_mean + 4*hh_22_sd 
gen hh_22_6s = hh_22_mean + 6*hh_22_sd 
gen hh_24_4s = hh_24_mean + 4*hh_24_sd 
gen hh_24_6s = hh_24_mean + 6*hh_24_sd 
gen hh_25_4s = hh_25_mean + 4*hh_25_sd 
gen hh_25_6s = hh_25_mean + 6*hh_25_sd 

*** create indicators for above 4 sigma and above 6 sigma *** 
gen hh_04_4s_a = (hh_04_pc > hh_04_4s)
gen hh_04_6s_a = (hh_04_pc > hh_04_6s)
gen hh_05_4s_a = (hh_05_pc > hh_05_4s)
gen hh_05_6s_a = (hh_05_pc > hh_05_6s)
gen hh_06_4s_a = (hh_06_pc > hh_06_4s)
gen hh_06_6s_a = (hh_06_pc > hh_06_6s)
gen hh_07_4s_a = (hh_07_pc > hh_07_4s)
gen hh_07_6s_a = (hh_07_pc > hh_07_6s)
gen hh_08_4s_a = (hh_08_pc > hh_08_4s)
gen hh_08_6s_a = (hh_08_pc > hh_08_6s)
gen hh_09_4s_a = (hh_09_pc > hh_09_4s)
gen hh_09_6s_a = (hh_09_pc > hh_09_6s)
gen hh_14_4s_a = (hh_14_pc > hh_14_4s)
gen hh_14_6s_a = (hh_14_pc > hh_14_6s)
gen hh_16_4s_a = (hh_16_pc > hh_16_4s)
gen hh_16_6s_a = (hh_16_pc > hh_16_6s)
gen hh_17_4s_a = (hh_17_pc > hh_17_4s)
gen hh_17_6s_a = (hh_17_pc > hh_17_6s)
gen hh_22_4s_a = (hh_22_pc > hh_22_4s)
gen hh_22_6s_a = (hh_22_pc > hh_22_6s)
gen hh_24_4s_a = (hh_24_pc > hh_24_4s)
gen hh_24_6s_a = (hh_24_pc > hh_24_6s)
gen hh_25_4s_a = (hh_25_pc > hh_25_4s)
gen hh_25_6s_a = (hh_25_pc > hh_25_6s)

*** create summary statistics for table to deterime whether to winsorize *** 
sum hh_04_* hh_05_* hh_06_* hh_07_* hh_08_* hh_09_* hh_14_* hh_16_* hh_17_* hh_22_* hh_24_* hh_25_* 

*** save dataset of per capita variables *** 
save "$intermediate\most_hh_per_capita", replace 

*** look at variable hh_13 *** 
use "$data_deidentified\Complete_Baseline_Household_Roster", clear  

*** keep considered variables *** 
keep hhid hh_12index* hh_13_* 

drop hh_13_o* hh_13_sum* 

*** reshape to water source level data *** 
reshape long hh_12index_1_ hh_13_1_ hh_12index_2_ hh_13_2_ hh_12index_3_ hh_13_3_ hh_12index_4_ hh_13_4_ hh_12index_5_ hh_13_5_ hh_12index_6_ hh_13_6_ hh_12index_7_ hh_13_7_ hh_12index_8_ hh_13_8_ hh_12index_9_ hh_13_9_ hh_12index_10_ hh_13_10_ hh_12index_11_ hh_13_11_ hh_12index_12_ hh_13_12_ hh_12index_13_ hh_13_13_ hh_12index_14_ hh_13_14_ hh_12index_15_ hh_13_15_ hh_12index_16_ hh_13_16_ hh_12index_17_ hh_13_17_ hh_12index_18_ hh_13_18_ hh_12index_19_ hh_13_19_ hh_12index_20_ hh_13_20_ hh_12index_21_ hh_13_21_ hh_12index_22_ hh_13_22_ hh_12index_23_ hh_13_23_ hh_12index_24_ hh_13_24_ hh_12index_25_ hh_13_25_ hh_12index_26_ hh_13_26_ hh_12index_27_ hh_13_27_ hh_12index_28_ hh_13_28_ hh_12index_29_ hh_13_29_ hh_12index_30_ hh_13_30_ hh_12index_31_ hh_13_31_ hh_12index_32_ hh_13_32_ hh_12index_33_ hh_13_33_ hh_12index_34_ hh_13_34_ hh_12index_35_ hh_13_35_ hh_12index_36_ hh_13_36_ hh_12index_37_ hh_13_37_ hh_12index_38_ hh_13_38_ hh_12index_39_ hh_13_39_ hh_12index_40_ hh_13_40_ hh_12index_41_ hh_13_41_ hh_12index_42_ hh_13_42_ hh_12index_43_ hh_13_43_ hh_12index_44_ hh_13_44_ hh_12index_45_ hh_13_45_ hh_12index_46_ hh_13_46_ hh_12index_47_ hh_13_47_ hh_12index_48_ hh_13_48_ hh_12index_49_ hh_13_49_ hh_12index_50_ hh_13_50_ hh_12index_51_ hh_13_51_ hh_12index_52_ hh_13_52_ hh_12index_53_ hh_13_53_ hh_12index_54_ hh_13_54_ hh_12index_55_ hh_13_55_ , i(hhid) j(watersource)

*** rename variables to drop the extra _ ***
forvalues i = 1/55{
	rename hh_12index_`i'_ hh_12index_`i' 
	rename hh_13_`i'_ hh_13_`i' 
}

*** reshape to individual level data *** 
reshape long hh_12index_ hh_13_, i(hhid watersource) j(individual)

*** drop missing data *** 
drop if hh_12index_ == . & hh_13_ == . 

*** collapse to household activity level data *** 
collapse (sum) hh_13_, by(hhid hh_12index_)

**** merge in the rest of the household time use data to get household size *** 
merge m:1 hhid using "$intermediate\most_hh_per_capita"

drop _merge 

*** just keep household size to then filter and get activity per capit measures *** 
keep hhid hh_12index_ hh_13_ hh_size 

*** calculate per capita per activity measures *** 
gen hh_13_pc = hh_13_ / hh_size

*** calculate 4 sigma and 6 sigma per activity *** 
forvalues i = 1/8 {
	preserve 
	
	*** keep only one activity type *** 
	keep if hh_12index_ == `i'
	
	*** calculate mean, standard deviation of each variable *** 
	egen hh_13_mean = mean(hh_13_pc)
	egen hh_13_sd = sd(hh_13_pc)
	
	*** calculate 4 sigma, 6 sigma *** 
	gen hh_13_4s = hh_13_mean + 4*hh_13_sd 
	gen hh_13_6s = hh_13_mean + 6*hh_13_sd 
	
	*** create indicators for above 4 sigma and above 6 sigma *** 
	gen hh_13_4s_a = (hh_13_pc > hh_13_4s)
	gen hh_13_6s_a = (hh_13_pc > hh_13_6s)
	
	*** post summary statistics by activity type *** 
	sum hh_13_mean hh_13_sd hh_13_4s hh_13_4s_a hh_13_6s hh_13_6s_a 
	
	restore 
} 

*** look at variable hh_21 *** 
use "$data_deidentified\Complete_Baseline_Household_Roster", clear  

*** keep considered variables *** 
keep hhid hh_20index* hh_21_*

drop hh_21_o* hh_21_sum* 

*** reshape to water source level data *** 
reshape long hh_20index_1_ hh_21_1_ hh_20index_2_ hh_21_2_ hh_20index_3_ hh_21_3_ hh_20index_4_ hh_21_4_ hh_20index_5_ hh_21_5_ hh_20index_6_ hh_21_6_ hh_20index_7_ hh_21_7_ hh_20index_8_ hh_21_8_ hh_20index_9_ hh_21_9_ hh_20index_10_ hh_21_10_ hh_20index_11_ hh_21_11_ hh_20index_12_ hh_21_12_ hh_20index_13_ hh_21_13_ hh_20index_14_ hh_21_14_ hh_20index_15_ hh_21_15_ hh_20index_16_ hh_21_16_ hh_20index_17_ hh_21_17_ hh_20index_18_ hh_21_18_ hh_20index_19_ hh_21_19_ hh_20index_20_ hh_21_20_ hh_20index_21_ hh_21_21_ hh_20index_22_ hh_21_22_ hh_20index_23_ hh_21_23_ hh_20index_24_ hh_21_24_ hh_20index_25_ hh_21_25_ hh_20index_26_ hh_21_26_ hh_20index_27_ hh_21_27_ hh_20index_28_ hh_21_28_ hh_20index_29_ hh_21_29_ hh_20index_30_ hh_21_30_ hh_20index_31_ hh_21_31_ hh_20index_32_ hh_21_32_ hh_20index_33_ hh_21_33_ hh_20index_34_ hh_21_34_ hh_20index_35_ hh_21_35_ hh_20index_36_ hh_21_36_ hh_20index_37_ hh_21_37_ hh_20index_38_ hh_21_38_ hh_20index_39_ hh_21_39_ hh_20index_40_ hh_21_40_ hh_20index_41_ hh_21_41_ hh_20index_42_ hh_21_42_ hh_20index_43_ hh_21_43_ hh_20index_44_ hh_21_44_ hh_20index_45_ hh_21_45_ hh_20index_46_ hh_21_46_ hh_20index_47_ hh_21_47_ hh_20index_48_ hh_21_48_ hh_20index_49_ hh_21_49_ hh_20index_50_ hh_21_50_ hh_20index_51_ hh_21_51_ hh_20index_52_ hh_21_52_ hh_20index_53_ hh_21_53_ hh_20index_54_ hh_21_54_ hh_20index_55_ hh_21_55_ , i(hhid) j(watersource)

*** rename variables to drop the extra _ ***
forvalues i = 1/55{
	rename hh_20index_`i'_ hh_20index_`i' 
	rename hh_21_`i'_ hh_21_`i' 
}

*** reshape to individual level data *** 
reshape long hh_20index_ hh_21_, i(hhid watersource) j(individual)

*** drop missing data *** 
drop if hh_20index_ == . & hh_21_ == . 

*** collapse to household activity level data *** 
collapse (sum) hh_21_, by(hhid hh_20index_)

**** merge in the rest of the household time use data to get household size *** 
merge m:1 hhid using "$intermediate\most_hh_per_capita"

drop _merge 

*** just keep household size to then filter and get activity per capit measures *** 
keep hhid hh_20index_ hh_21_ hh_size 

*** calculate per capita per activity measures *** 
gen hh_21_pc = hh_21_ / hh_size

*** calculate 4 sigma and 6 sigma per activity *** 
forvalues i = 1/8 {
	preserve 
	
	*** keep only one activity type *** 
	keep if hh_20index_ == `i'
	
	*** calculate mean, standard deviation of each variable *** 
	egen hh_21_mean = mean(hh_21_pc)
	egen hh_21_sd = sd(hh_21_pc)
	
	*** calculate 4 sigma, 6 sigma *** 
	gen hh_21_4s = hh_21_mean + 4*hh_21_sd 
	gen hh_21_6s = hh_21_mean + 6*hh_21_sd 
	
	*** create indicators for above 4 sigma and above 6 sigma *** 
	gen hh_21_4s_a = (hh_21_pc > hh_21_4s)
	gen hh_21_6s_a = (hh_21_pc > hh_21_6s)
	
	*** post summary statistics by activity type *** 
	sum hh_21_mean hh_21_sd hh_21_4s hh_21_4s_a hh_21_6s hh_21_6s_a 
	
	restore 
} 

*** import health data ***
use "$data_deidentified\Complete_Baseline_Health", clear   


*** check variables to winsorize, at the household per capita level ***  
*** variables to winsorize: heatlh_5_4 *** 
*** so need to reshape the data *** 

*** keep only hhid, variables to winsorize, will merge back with main dataset later *** 
keep hhid health_5_4_*

*** reshape to individual level data 
reshape long health_5_4_ , i(hhid) j(individual)

*** drop variables for which there is no individual *** 
drop if health_5_4_ == . 
 
*** collapse to household level sums to then create per capita variables *** 
collapse (sum) health_5_4_, by(hhid)

*** merge in household size data *** 
merge 1:1 hhid using "$intermediate\most_hh_per_capita.dta"
 
*** keep just health and household size variables *** 
keep hhid health_5_4_ hh_size 
 
*** calculate per capita variables *** 
gen health_5_4_pc = health_5_4_ / hh_size 

*** calculate mean, standard deviation of each variable *** 
egen health_5_4_mean = mean(health_5_4_pc)
egen health_5_4_sd = sd(health_5_4_pc)

*** calculate 4 sigma, 6 sigma *** 
gen health_5_4_4s = health_5_4_mean + 4*health_5_4_sd 
gen health_5_4_6s = health_5_4_mean + 6*health_5_4_sd 

*** create indicators for above 4 sigma and above 6 sigma *** 
gen health_5_4_4s_a = (health_5_4_pc > health_5_4_4s)
replace health_5_4_4s_a = . if health_5_4_ == . 
gen health_5_4_6s_a = (health_5_4_pc > health_5_4_6s)
replace health_5_4_6s_a = . if health_5_4_ == . 

*** create summary statistics for table to deterime whether to winsorize *** 
sum health_5_4_mean health_5_4_sd health_5_4_4s health_5_4_4s_a health_5_4_6s health_5_4_6s_a

*** save dataset of per capita variables *** 
save "$intermediate\health_5_4_pc_data", replace 

*** import agriculture data ***
use "$data_deidentified\Complete_Baseline_Agriculture", clear   

*** check variables to winsorize at the household per capita level *** 
*** variables to winsorize: _actif_number_, actifsid_ *** 
*** so need to reshape the data *** 

*** keep only hhid, variables to winsorize, will merge back with main dataset later ***  
keep hhid actifsid_* _actif_number_*

*** save water time use variables data set ***
reshape long actifsid_ _actif_number_ , i(hhid) j(item)

*** drop empty observations *** 
drop if actifsid_ == . & _actif_number_ == . 

*** filter by item id and then summarize ***  
forvalues i = 1/16 {
	preserve 
	
	*** keep only one item type *** 
	keep if actifsid_ == `i'
	
	*** calculate mean, standard deviation of each variable *** 
	egen _actif_number_mean = mean(_actif_number_)
	egen _actif_number_sd = sd(_actif_number_)
	
	*** calculate 4 sigma, 6 sigma *** 
	gen _actif_number_4s = _actif_number_mean + 4*_actif_number_sd 
	gen _actif_number_6s = _actif_number_mean + 6*_actif_number_sd 
	
	*** create indicators for above 4 sigma and above 6 sigma *** 
	gen _actif_number_4s_a = (_actif_number_ > _actif_number_4s)
	gen _actif_number_6s_a = (_actif_number_ > _actif_number_6s)
	
	*** post summary statistics by activity type *** 
	sum _actif_number_mean _actif_number_sd _actif_number_4s _actif_number_4s_a _actif_number_6s _actif_number_6s_a 
	
	restore 
} 

*** import agriculture data ***
use "$data_deidentified\Complete_Baseline_Agriculture", clear   

*** check variables to winsorize at the household per capita level *** 
*** variables to winsorize: _agri_number_, agriindex_ *** 
*** so need to reshape the data *** 

*** keep only hhid, variables to winsorize, will merge back with main dataset later ***  
keep hhid agriindex_* _agri_number_*

*** save water time use variables data set ***
reshape long agriindex_ _agri_number_ , i(hhid) j(item)

*** drop empty observations *** 
drop if agriindex_ == . & _agri_number_ == . 

*** filter by item id and then summarize ***  
forvalues i = 1/14 {
	preserve 
	
	*** keep only one item type *** 
	keep if agriindex_ == `i'
	
	*** calculate mean, standard deviation of each variable *** 
	egen _agri_number_mean = mean(_agri_number_)
	egen _agri_number_sd = sd(_agri_number_)
	
	*** calculate 4 sigma, 6 sigma *** 
	gen _agri_number_4s = _agri_number_mean + 4*_agri_number_sd 
	gen _agri_number_6s = _agri_number_mean + 6*_agri_number_sd 
	
	*** create indicators for above 4 sigma and above 6 sigma *** 
	gen _agri_number_4s_a = (_agri_number_ > _agri_number_4s)
	gen _agri_number_6s_a = (_agri_number_ > _agri_number_6s)
	
	*** post summary statistics by activity type *** 
	sum _agri_number_mean _agri_number_sd _agri_number_4s _agri_number_4s_a _agri_number_6s _agri_number_6s_a 
	
	restore 
} 

*** import agriculture data ***
use "$data_deidentified\Complete_Baseline_Agriculture", clear   

*** keep only necessary variables *** 
keep hhid agri_6_21_* agri_6_22_* agri_6_35_* agri_6_37_*  agri_6_38_a_* agri_6_39_a_* agri_6_40_a_* agri_6_41_a_*

reshape long agri_6_21_ agri_6_22_ agri_6_35_ agri_6_37_ agri_6_38_a_ agri_6_38_a_code_ agri_6_39_a_ agri_6_39_a_code_ agri_6_40_a_ agri_6_40_a_code_ agri_6_41_a_ agri_6_41_a_code_, i(hhid) j(plotn)

*** drop variables with no plot *** 
drop if agri_6_21_ == . & agri_6_22_ == . & agri_6_35_ == . & agri_6_37_ == . & agri_6_38_a_ == . & agri_6_38_a_code_ == . & agri_6_39_a_ == . & agri_6_39_a_code_ == . & agri_6_40_a_ == . & agri_6_40_a_code_ == . & agri_6_41_a_ == . & agri_6_41_a_code_ == . 

*** check which variables to winsorize *** 

*** convert all land holding values into meters squared *** 
replace agri_6_21_ = agri_6_21_/10000 if agri_6_22_ == 2 

*** convert all input uses to kilograms *** 
replace agri_6_38_a_ =  agri_6_38_a_ * 1000 if agri_6_38_a_code_ == 2 
replace agri_6_38_a_ =  agri_6_38_a_ * 50 if agri_6_38_a_code_ == 3
replace agri_6_38_a_ = . if agri_6_38_a_code_ > 3  
replace agri_6_39_a_ =  agri_6_39_a_ * 1000 if agri_6_39_a_code_ == 2 
replace agri_6_39_a_ =  agri_6_39_a_ * 50 if agri_6_39_a_code_ == 3
replace agri_6_39_a_ = . if agri_6_39_a_code_ > 3   
replace agri_6_40_a_ =  agri_6_40_a_ * 1000 if agri_6_40_a_code_ == 2 
replace agri_6_40_a_ =  agri_6_40_a_ * 50 if agri_6_40_a_code_ == 3
replace agri_6_40_a_ = . if agri_6_40_a_code_ > 3  
replace agri_6_41_a_ =  agri_6_41_a_ * 1000 if agri_6_41_a_code_ == 2 
replace agri_6_41_a_ =  agri_6_41_a_ * 50 if agri_6_41_a_code_ == 3
replace agri_6_41_a_ = . if agri_6_41_a_code_ > 3  

*** sum up total land holdings and applications *** 
*** keep total number of plots *** 
collapse (max) number_plots = plotn (sum) agri_6_21_ (sum) agri_6_35_ (sum) agri_6_37_ (sum) agri_6_38_a_ (sum) agri_6_39_a_ (sum) agri_6_40_a_ (sum) agri_6_41_a_, by(hhid)

*** calculate per plot number of applications *** 
gen agri_6_35_pp = agri_6_35_ / number_plots 
gen agri_6_37_pp = agri_6_37_ / number_plots 
gen agri_6_38_pp = agri_6_38_a_ / number_plots
gen agri_6_39_pp = agri_6_39_a_ / number_plots
gen agri_6_40_pp = agri_6_40_a_ / number_plots
gen agri_6_41_pp = agri_6_41_a_ / number_plots

*** calculate per plot 

*** calculate mean, standard deviation of each variable *** 
egen agri_6_21_mean = mean(agri_6_21_)
egen agri_6_21_sd = sd(agri_6_21_)
egen agri_6_35_mean = mean(agri_6_35_pp)
egen agri_6_35_sd = sd(agri_6_35_pp)
egen agri_6_37_mean = mean(agri_6_37_pp)
egen agri_6_37_sd = sd(agri_6_37_pp)
egen agri_6_38_mean = mean(agri_6_38_pp)
egen agri_6_38_sd = sd(agri_6_38_pp)
egen agri_6_39_mean = mean(agri_6_39_pp)
egen agri_6_39_sd = sd(agri_6_39_pp)
egen agri_6_40_mean = mean(agri_6_40_pp)
egen agri_6_40_sd = sd(agri_6_40_pp)
egen agri_6_41_mean = mean(agri_6_41_pp)
egen agri_6_41_sd = sd(agri_6_41_pp)

*** calculate 4 sigma, 6 sigma *** 
gen agri_6_21_4s = agri_6_21_mean + 4*agri_6_21_sd 
gen agri_6_21_6s = agri_6_21_mean + 6*agri_6_21_sd 
gen agri_6_35_4s = agri_6_35_mean + 4*agri_6_35_sd 
gen agri_6_35_6s = agri_6_35_mean + 6*agri_6_35_sd 
gen agri_6_37_4s = agri_6_37_mean + 4*agri_6_37_sd 
gen agri_6_37_6s = agri_6_37_mean + 6*agri_6_37_sd 
gen agri_6_38_4s = agri_6_38_mean + 4*agri_6_38_sd 
gen agri_6_38_6s = agri_6_38_mean + 6*agri_6_38_sd 
gen agri_6_39_4s = agri_6_39_mean + 4*agri_6_39_sd 
gen agri_6_39_6s = agri_6_39_mean + 6*agri_6_39_sd 
gen agri_6_40_4s = agri_6_40_mean + 4*agri_6_40_sd 
gen agri_6_40_6s = agri_6_40_mean + 6*agri_6_40_sd 
gen agri_6_41_4s = agri_6_41_mean + 4*agri_6_41_sd 
gen agri_6_41_6s = agri_6_41_mean + 6*agri_6_41_sd 


*** create indicators for above 4 sigma and above 6 sigma *** 
gen agri_6_21_4s_a = (agri_6_21_ > agri_6_21_4s)
replace agri_6_21_4s_a = . if agri_6_21_ == . 
gen agri_6_21_6s_a = (agri_6_21_ > agri_6_21_6s)
replace agri_6_21_6s_a = . if agri_6_21_ == . 
gen agri_6_35_4s_a = (agri_6_35_pp > agri_6_35_4s)
replace agri_6_35_4s_a = . if agri_6_35_ == . 
gen agri_6_35_6s_a = (agri_6_35_pp > agri_6_35_6s)
replace agri_6_35_6s_a = . if agri_6_35_ == . 
gen agri_6_37_4s_a = (agri_6_37_pp > agri_6_37_4s)
replace agri_6_37_4s_a = . if agri_6_37_ == . 
gen agri_6_37_6s_a = (agri_6_37_pp > agri_6_37_6s)
replace agri_6_37_6s_a = . if agri_6_37_ == . 
gen agri_6_38_4s_a = (agri_6_38_pp > agri_6_38_4s)
replace agri_6_38_4s_a = . if agri_6_38_a_ == . 
gen agri_6_38_6s_a = (agri_6_38_pp > agri_6_38_6s)
replace agri_6_38_6s_a = . if agri_6_38_a_ == . 
gen agri_6_39_4s_a = (agri_6_39_pp > agri_6_39_4s)
replace agri_6_39_4s_a = . if agri_6_39_a_ == . 
gen agri_6_39_6s_a = (agri_6_39_pp > agri_6_39_6s)
replace agri_6_39_6s_a = . if agri_6_39_a_ == . 
gen agri_6_40_4s_a = (agri_6_40_pp > agri_6_40_4s)
replace agri_6_40_4s_a = . if agri_6_40_a_ == . 
gen agri_6_40_6s_a = (agri_6_40_pp > agri_6_40_6s)
replace agri_6_40_6s_a = . if agri_6_40_a_ == . 
gen agri_6_41_4s_a = (agri_6_41_pp > agri_6_41_4s)
replace agri_6_41_4s_a = . if agri_6_41_a_ == . 
gen agri_6_41_6s_a = (agri_6_41_pp > agri_6_41_6s)
replace agri_6_41_6s_a = . if agri_6_41_a_ == . 

*** post summary statistics ***
sum agri_6_21_mean agri_6_21_sd agri_6_21_4s agri_6_21_4s_a agri_6_21_6s agri_6_21_6s_a agri_6_35_mean agri_6_35_sd agri_6_35_4s agri_6_35_4s_a agri_6_35_6s agri_6_35_6s_a agri_6_37_mean agri_6_37_sd agri_6_37_4s agri_6_37_4s_a agri_6_37_6s agri_6_37_6s_a agri_6_38_mean agri_6_38_sd agri_6_38_4s agri_6_38_4s_a agri_6_38_6s agri_6_38_6s_a agri_6_39_mean agri_6_39_sd agri_6_39_4s agri_6_39_4s_a agri_6_39_6s agri_6_39_6s_a agri_6_40_mean agri_6_40_sd agri_6_40_4s agri_6_40_4s_a agri_6_40_6s agri_6_40_6s_a agri_6_41_mean agri_6_41_sd agri_6_41_4s agri_6_41_4s_a agri_6_41_6s agri_6_41_6s_a

*** import production data ***
use "$data_deidentified\Complete_Baseline_Production", clear   

*** see which variables to winsorize - cereals ***
forvalues i = 1/5 {
    
	*** code -9s or -99s as missing *** 
	replace cereals_01_`i' = . if cereals_01_`i' < 0 
	replace cereals_02_`i' = . if cereals_02_`i' < 0 
	replace cereals_03_`i' = . if cereals_03_`i' < 0 
	replace cereals_04_`i' = . if cereals_04_`i' < 0 
	replace cereals_05_`i' = . if cereals_05_`i' < 0 
	
	*** calculate mean and standard deviation *** 
	egen cereals_01_`i'_mean = mean(cereals_01_`i')
	egen cereals_01_`i'_sd = sd(cereals_01_`i')
	
	*** calculate 4 sigma, 6 sigma *** 
	gen cereals_01_`i'_4s = cereals_01_`i'_mean + 4*cereals_01_`i'_sd 
	gen cereals_01_`i'_6s = cereals_01_`i'_mean + 6*cereals_01_`i'_sd 
	
	*** create indicators for above 4 sigma and above 6 sigma *** 
	gen cereals_01_`i'_4s_a = (cereals_01_`i' > cereals_01_`i'_4s)
	replace cereals_01_`i'_4s_a = . if cereals_01_`i' == . 
	gen cereals_01_`i'_6s_a = (cereals_01_`i' > cereals_01_`i'_6s)
	replace cereals_01_`i'_6s_a = . if cereals_01_`i' == .
	
	*** calculate mean and standard deviation *** 
	egen cereals_02_`i'_mean = mean(cereals_02_`i')
	egen cereals_02_`i'_sd = sd(cereals_02_`i')
	
	*** calculate 4 sigma, 6 sigma *** 
	gen cereals_02_`i'_4s = cereals_02_`i'_mean + 4*cereals_02_`i'_sd 
	gen cereals_02_`i'_6s = cereals_02_`i'_mean + 6*cereals_02_`i'_sd 
	
	*** create indicators for above 4 sigma and above 6 sigma *** 
	gen cereals_02_`i'_4s_a = (cereals_02_`i' > cereals_02_`i'_4s)
	replace cereals_02_`i'_4s_a = . if cereals_02_`i' == . 
	gen cereals_02_`i'_6s_a = (cereals_02_`i' > cereals_02_`i'_6s)
	replace cereals_02_`i'_6s_a = . if cereals_02_`i' == . 
	
	*** calculate mean and standard deviation *** 
	egen cereals_03_`i'_mean = mean(cereals_03_`i')
	egen cereals_03_`i'_sd = sd(cereals_03_`i')
	
	*** calculate 4 sigma, 6 sigma *** 
	gen cereals_03_`i'_4s = cereals_03_`i'_mean + 4*cereals_03_`i'_sd 
	gen cereals_03_`i'_6s = cereals_03_`i'_mean + 6*cereals_03_`i'_sd 

	
	*** create indicators for above 4 sigma and above 6 sigma *** 
	gen cereals_03_`i'_4s_a = (cereals_03_`i' > cereals_03_`i'_4s)
	replace cereals_03_`i'_4s_a = . if cereals_03_`i' == . 
	gen cereals_03_`i'_6s_a = (cereals_03_`i' > cereals_03_`i'_6s)
	replace cereals_03_`i'_6s_a = . if cereals_03_`i' == . 
	
	*** calculate mean and standard deviation *** 
	egen cereals_04_`i'_mean = mean(cereals_04_`i')
	egen cereals_04_`i'_sd = sd(cereals_04_`i')
	
	*** calculate 4 sigma, 6 sigma *** 
	gen cereals_04_`i'_4s = cereals_04_`i'_mean + 4*cereals_04_`i'_sd 
	gen cereals_04_`i'_6s = cereals_04_`i'_mean + 6*cereals_04_`i'_sd
	
	*** create indicators for above 4 sigma and above 6 sigma *** 
	gen cereals_04_`i'_4s_a = (cereals_04_`i' > cereals_04_`i'_4s)
	replace cereals_04_`i'_4s_a = . if cereals_04_`i' == . 
	gen cereals_04_`i'_6s_a = (cereals_04_`i' > cereals_04_`i'_6s)
	replace cereals_04_`i'_6s_a = . if cereals_04_`i' == . 
	
	*** calculate mean and standard deviation *** 
	egen cereals_05_`i'_mean = mean(cereals_05_`i')
	egen cereals_05_`i'_sd = sd(cereals_05_`i')
	
	*** calculate 4 sigma, 6 sigma *** 
	gen cereals_05_`i'_4s = cereals_05_`i'_mean + 4*cereals_05_`i'_sd 
	gen cereals_05_`i'_6s = cereals_05_`i'_mean + 6*cereals_05_`i'_sd 
	
	*** create indicators for above 4 sigma and above 6 sigma *** 
	gen cereals_05_`i'_4s_a = (cereals_05_`i' > cereals_05_`i'_4s)
	replace cereals_05_`i'_4s_a = . if cereals_05_`i' == . 
	gen cereals_05_`i'_6s_a = (cereals_05_`i' > cereals_05_`i'_6s)
	replace cereals_05_`i'_6s_a = . if cereals_05_`i' == . 
	
}

*** post summary statistics *** 
sum cereals_01_1_mean cereals_01_1_sd cereals_01_1_4s cereals_01_1_4s_a cereals_01_1_6s cereals_01_1_6s_a cereals_02_1_mean cereals_02_1_sd cereals_02_1_4s cereals_02_1_4s_a cereals_02_1_6s cereals_02_1_6s_a cereals_03_1_mean cereals_03_1_sd cereals_03_1_4s cereals_03_1_4s_a cereals_03_1_6s cereals_03_1_6s_a cereals_04_1_mean cereals_04_1_sd cereals_04_1_4s cereals_04_1_4s_a cereals_04_1_6s cereals_04_1_6s_a cereals_05_1_mean cereals_05_1_sd cereals_05_1_4s cereals_05_1_4s_a cereals_05_1_6s cereals_05_1_6s_a 

sum cereals_01_2_mean cereals_01_2_sd cereals_01_2_4s cereals_01_2_4s_a cereals_01_2_6s cereals_01_2_6s_a cereals_02_2_mean cereals_02_2_sd cereals_02_2_4s cereals_02_2_4s_a cereals_02_2_6s cereals_02_2_6s_a cereals_03_2_mean cereals_03_2_sd cereals_03_2_4s cereals_03_2_4s_a cereals_03_2_6s cereals_03_2_6s_a cereals_04_2_mean cereals_04_2_sd cereals_04_2_4s cereals_04_2_4s_a cereals_04_2_6s cereals_04_2_6s_a cereals_05_2_mean cereals_05_2_sd cereals_05_2_4s cereals_05_2_4s_a cereals_05_2_6s cereals_05_2_6s_a 

sum cereals_01_3_mean cereals_01_3_sd cereals_01_3_4s cereals_01_3_4s_a cereals_01_3_6s cereals_01_3_6s_a cereals_02_3_mean cereals_02_3_sd cereals_02_3_4s cereals_02_3_4s_a cereals_02_3_6s cereals_02_3_6s_a cereals_03_3_mean cereals_03_3_sd cereals_03_3_4s cereals_03_3_4s_a cereals_03_3_6s cereals_03_3_6s_a cereals_04_3_mean cereals_04_3_sd cereals_04_3_4s cereals_04_3_4s_a cereals_04_3_6s cereals_04_3_6s_a cereals_05_3_mean cereals_05_3_sd cereals_05_3_4s cereals_05_3_4s_a cereals_05_3_6s cereals_05_3_6s_a 

sum cereals_01_4_mean cereals_01_4_sd cereals_01_4_4s cereals_01_4_4s_a cereals_01_4_6s cereals_01_4_6s_a cereals_02_4_mean cereals_02_4_sd cereals_02_4_4s cereals_02_4_4s_a cereals_02_4_6s cereals_02_4_6s_a cereals_03_4_mean cereals_03_4_sd cereals_03_4_4s cereals_03_4_4s_a cereals_03_4_6s cereals_03_4_6s_a cereals_04_4_mean cereals_04_4_sd cereals_04_4_4s cereals_04_4_4s_a cereals_04_4_6s cereals_04_4_6s_a cereals_05_4_mean cereals_05_4_sd cereals_05_4_4s cereals_05_4_4s_a cereals_05_4_6s cereals_05_4_6s_a 

sum cereals_01_5_mean cereals_01_5_sd cereals_01_5_4s cereals_01_5_4s_a cereals_01_5_6s cereals_01_5_6s_a cereals_02_5_mean cereals_02_5_sd cereals_02_5_4s cereals_02_5_4s_a cereals_02_5_6s cereals_02_5_6s_a cereals_03_5_mean cereals_03_5_sd cereals_03_5_4s cereals_03_5_4s_a cereals_03_5_6s cereals_03_5_6s_a cereals_04_5_mean cereals_04_5_sd cereals_04_5_4s cereals_04_5_4s_a cereals_04_5_6s cereals_04_5_6s_a cereals_05_5_mean cereals_05_5_sd cereals_05_5_4s cereals_05_5_4s_a cereals_05_5_6s cereals_05_5_6s_a 

*** see which variables to winsorize - farines ***
forvalues i = 1/5 {
    
	*** code -9s or -99s as missing *** 
	replace farines_01_`i' = . if farines_01_`i' < 0 
	replace farines_02_`i' = . if farines_02_`i' < 0 
	replace farines_03_`i' = . if farines_03_`i' < 0 
	replace farines_04_`i' = . if farines_04_`i' < 0 
	replace farines_05_`i' = . if farines_05_`i' < 0 
	
	*** calculate mean and standard deviation *** 
	egen farines_01_`i'_mean = mean(farines_01_`i')
	egen farines_01_`i'_sd = sd(farines_01_`i')
	
	*** calculate 4 sigma, 6 sigma *** 
	gen farines_01_`i'_4s = farines_01_`i'_mean + 4*farines_01_`i'_sd 
	gen farines_01_`i'_6s = farines_01_`i'_mean + 6*farines_01_`i'_sd 
	
	*** create indicators for above 4 sigma and above 6 sigma *** 
	gen farines_01_`i'_4s_a = (farines_01_`i' > farines_01_`i'_4s)
	replace farines_01_`i'_4s_a = . if farines_01_`i' == . 
	gen farines_01_`i'_6s_a = (farines_01_`i' > farines_01_`i'_6s)
	replace farines_01_`i'_6s_a = . if farines_01_`i' == .
	
	*** calculate mean and standard deviation *** 
	egen farines_02_`i'_mean = mean(farines_02_`i')
	egen farines_02_`i'_sd = sd(farines_02_`i')
	
	*** calculate 4 sigma, 6 sigma *** 
	gen farines_02_`i'_4s = farines_02_`i'_mean + 4*farines_02_`i'_sd 
	gen farines_02_`i'_6s = farines_02_`i'_mean + 6*farines_02_`i'_sd 
	
	*** create indicators for above 4 sigma and above 6 sigma *** 
	gen farines_02_`i'_4s_a = (farines_02_`i' > farines_02_`i'_4s)
	replace farines_02_`i'_4s_a = . if farines_02_`i' == . 
	gen farines_02_`i'_6s_a = (farines_02_`i' > farines_02_`i'_6s)
	replace farines_02_`i'_6s_a = . if farines_02_`i' == . 
	
	*** calculate mean and standard deviation *** 
	egen farines_03_`i'_mean = mean(farines_03_`i')
	egen farines_03_`i'_sd = sd(farines_03_`i')
	
	*** calculate 4 sigma, 6 sigma *** 
	gen farines_03_`i'_4s = farines_03_`i'_mean + 4*farines_03_`i'_sd 
	gen farines_03_`i'_6s = farines_03_`i'_mean + 6*farines_03_`i'_sd 

	
	*** create indicators for above 4 sigma and above 6 sigma *** 
	gen farines_03_`i'_4s_a = (farines_03_`i' > farines_03_`i'_4s)
	replace farines_03_`i'_4s_a = . if farines_03_`i' == . 
	gen farines_03_`i'_6s_a = (farines_03_`i' > farines_03_`i'_6s)
	replace farines_03_`i'_6s_a = . if farines_03_`i' == . 
	
	*** calculate mean and standard deviation *** 
	egen farines_04_`i'_mean = mean(farines_04_`i')
	egen farines_04_`i'_sd = sd(farines_04_`i')
	
	*** calculate 4 sigma, 6 sigma *** 
	gen farines_04_`i'_4s = farines_04_`i'_mean + 4*farines_04_`i'_sd 
	gen farines_04_`i'_6s = farines_04_`i'_mean + 6*farines_04_`i'_sd
	
	*** create indicators for above 4 sigma and above 6 sigma *** 
	gen farines_04_`i'_4s_a = (farines_04_`i' > farines_04_`i'_4s)
	replace farines_04_`i'_4s_a = . if farines_04_`i' == . 
	gen farines_04_`i'_6s_a = (farines_04_`i' > farines_04_`i'_6s)
	replace farines_04_`i'_6s_a = . if farines_04_`i' == . 
	
	*** calculate mean and standard deviation *** 
	egen farines_05_`i'_mean = mean(farines_05_`i')
	egen farines_05_`i'_sd = sd(farines_05_`i')
	
	*** calculate 4 sigma, 6 sigma *** 
	gen farines_05_`i'_4s = farines_05_`i'_mean + 4*farines_05_`i'_sd 
	gen farines_05_`i'_6s = farines_05_`i'_mean + 6*farines_05_`i'_sd 
	
	*** create indicators for above 4 sigma and above 6 sigma *** 
	gen farines_05_`i'_4s_a = (farines_05_`i' > farines_05_`i'_4s)
	replace farines_05_`i'_4s_a = . if farines_05_`i' == . 
	gen farines_05_`i'_6s_a = (farines_05_`i' > farines_05_`i'_6s)
	replace farines_05_`i'_6s_a = . if farines_05_`i' == . 
	
}

*** post summary statistics *** 
sum farines_01_1_mean farines_01_1_sd farines_01_1_4s farines_01_1_4s_a farines_01_1_6s farines_01_1_6s_a farines_02_1_mean farines_02_1_sd farines_02_1_4s farines_02_1_4s_a farines_02_1_6s farines_02_1_6s_a farines_03_1_mean farines_03_1_sd farines_03_1_4s farines_03_1_4s_a farines_03_1_6s farines_03_1_6s_a farines_04_1_mean farines_04_1_sd farines_04_1_4s farines_04_1_4s_a farines_04_1_6s farines_04_1_6s_a farines_05_1_mean farines_05_1_sd farines_05_1_4s farines_05_1_4s_a farines_05_1_6s farines_05_1_6s_a 

sum farines_01_2_mean farines_01_2_sd farines_01_2_4s farines_01_2_4s_a farines_01_2_6s farines_01_2_6s_a farines_02_2_mean farines_02_2_sd farines_02_2_4s farines_02_2_4s_a farines_02_2_6s farines_02_2_6s_a farines_03_2_mean farines_03_2_sd farines_03_2_4s farines_03_2_4s_a farines_03_2_6s farines_03_2_6s_a farines_04_2_mean farines_04_2_sd farines_04_2_4s farines_04_2_4s_a farines_04_2_6s farines_04_2_6s_a farines_05_2_mean farines_05_2_sd farines_05_2_4s farines_05_2_4s_a farines_05_2_6s farines_05_2_6s_a 

sum farines_01_3_mean farines_01_3_sd farines_01_3_4s farines_01_3_4s_a farines_01_3_6s farines_01_3_6s_a farines_02_3_mean farines_02_3_sd farines_02_3_4s farines_02_3_4s_a farines_02_3_6s farines_02_3_6s_a farines_03_3_mean farines_03_3_sd farines_03_3_4s farines_03_3_4s_a farines_03_3_6s farines_03_3_6s_a farines_04_3_mean farines_04_3_sd farines_04_3_4s farines_04_3_4s_a farines_04_3_6s farines_04_3_6s_a farines_05_3_mean farines_05_3_sd farines_05_3_4s farines_05_3_4s_a farines_05_3_6s farines_05_3_6s_a 

sum farines_01_4_mean farines_01_4_sd farines_01_4_4s farines_01_4_4s_a farines_01_4_6s farines_01_4_6s_a farines_02_4_mean farines_02_4_sd farines_02_4_4s farines_02_4_4s_a farines_02_4_6s farines_02_4_6s_a farines_03_4_mean farines_03_4_sd farines_03_4_4s farines_03_4_4s_a farines_03_4_6s farines_03_4_6s_a farines_04_4_mean farines_04_4_sd farines_04_4_4s farines_04_4_4s_a farines_04_4_6s farines_04_4_6s_a farines_05_4_mean farines_05_4_sd farines_05_4_4s farines_05_4_4s_a farines_05_4_6s farines_05_4_6s_a 

sum farines_01_5_mean farines_01_5_sd farines_01_5_4s farines_01_5_4s_a farines_01_5_6s farines_01_5_6s_a farines_02_5_mean farines_02_5_sd farines_02_5_4s farines_02_5_4s_a farines_02_5_6s farines_02_5_6s_a farines_03_5_mean farines_03_5_sd farines_03_5_4s farines_03_5_4s_a farines_03_5_6s farines_03_5_6s_a farines_04_5_mean farines_04_5_sd farines_04_5_4s farines_04_5_4s_a farines_04_5_6s farines_04_5_6s_a farines_05_5_mean farines_05_5_sd farines_05_5_4s farines_05_5_4s_a farines_05_5_6s farines_05_5_6s_a 

*** see which variables to winsorize - legumes ***
forvalues i = 1/5 {
    
	*** code -9s or -99s as missing *** 
	replace legumes_01_`i' = . if legumes_01_`i' < 0 
	replace legumes_02_`i' = . if legumes_02_`i' < 0 
	replace legumes_03_`i' = . if legumes_03_`i' < 0 
	replace legumes_04_`i' = . if legumes_04_`i' < 0 
	replace legumes_05_`i' = . if legumes_05_`i' < 0 
	
	*** calculate mean and standard deviation *** 
	egen legumes_01_`i'_mean = mean(legumes_01_`i')
	egen legumes_01_`i'_sd = sd(legumes_01_`i')
	
	*** calculate 4 sigma, 6 sigma *** 
	gen legumes_01_`i'_4s = legumes_01_`i'_mean + 4*legumes_01_`i'_sd 
	gen legumes_01_`i'_6s = legumes_01_`i'_mean + 6*legumes_01_`i'_sd 
	
	*** create indicators for above 4 sigma and above 6 sigma *** 
	gen legumes_01_`i'_4s_a = (legumes_01_`i' > legumes_01_`i'_4s)
	replace legumes_01_`i'_4s_a = . if legumes_01_`i' == . 
	gen legumes_01_`i'_6s_a = (legumes_01_`i' > legumes_01_`i'_6s)
	replace legumes_01_`i'_6s_a = . if legumes_01_`i' == .
	
	*** calculate mean and standard deviation *** 
	egen legumes_02_`i'_mean = mean(legumes_02_`i')
	egen legumes_02_`i'_sd = sd(legumes_02_`i')
	
	*** calculate 4 sigma, 6 sigma *** 
	gen legumes_02_`i'_4s = legumes_02_`i'_mean + 4*legumes_02_`i'_sd 
	gen legumes_02_`i'_6s = legumes_02_`i'_mean + 6*legumes_02_`i'_sd 
	
	*** create indicators for above 4 sigma and above 6 sigma *** 
	gen legumes_02_`i'_4s_a = (legumes_02_`i' > legumes_02_`i'_4s)
	replace legumes_02_`i'_4s_a = . if legumes_02_`i' == . 
	gen legumes_02_`i'_6s_a = (legumes_02_`i' > legumes_02_`i'_6s)
	replace legumes_02_`i'_6s_a = . if legumes_02_`i' == . 
	
	*** calculate mean and standard deviation *** 
	egen legumes_03_`i'_mean = mean(legumes_03_`i')
	egen legumes_03_`i'_sd = sd(legumes_03_`i')
	
	*** calculate 4 sigma, 6 sigma *** 
	gen legumes_03_`i'_4s = legumes_03_`i'_mean + 4*legumes_03_`i'_sd 
	gen legumes_03_`i'_6s = legumes_03_`i'_mean + 6*legumes_03_`i'_sd 

	
	*** create indicators for above 4 sigma and above 6 sigma *** 
	gen legumes_03_`i'_4s_a = (legumes_03_`i' > legumes_03_`i'_4s)
	replace legumes_03_`i'_4s_a = . if legumes_03_`i' == . 
	gen legumes_03_`i'_6s_a = (legumes_03_`i' > legumes_03_`i'_6s)
	replace legumes_03_`i'_6s_a = . if legumes_03_`i' == . 
	
	*** calculate mean and standard deviation *** 
	egen legumes_04_`i'_mean = mean(legumes_04_`i')
	egen legumes_04_`i'_sd = sd(legumes_04_`i')
	
	*** calculate 4 sigma, 6 sigma *** 
	gen legumes_04_`i'_4s = legumes_04_`i'_mean + 4*legumes_04_`i'_sd 
	gen legumes_04_`i'_6s = legumes_04_`i'_mean + 6*legumes_04_`i'_sd
	
	*** create indicators for above 4 sigma and above 6 sigma *** 
	gen legumes_04_`i'_4s_a = (legumes_04_`i' > legumes_04_`i'_4s)
	replace legumes_04_`i'_4s_a = . if legumes_04_`i' == . 
	gen legumes_04_`i'_6s_a = (legumes_04_`i' > legumes_04_`i'_6s)
	replace legumes_04_`i'_6s_a = . if legumes_04_`i' == . 
	
	*** calculate mean and standard deviation *** 
	egen legumes_05_`i'_mean = mean(legumes_05_`i')
	egen legumes_05_`i'_sd = sd(legumes_05_`i')
	
	*** calculate 4 sigma, 6 sigma *** 
	gen legumes_05_`i'_4s = legumes_05_`i'_mean + 4*legumes_05_`i'_sd 
	gen legumes_05_`i'_6s = legumes_05_`i'_mean + 6*legumes_05_`i'_sd 
	
	*** create indicators for above 4 sigma and above 6 sigma *** 
	gen legumes_05_`i'_4s_a = (legumes_05_`i' > legumes_05_`i'_4s)
	replace legumes_05_`i'_4s_a = . if legumes_05_`i' == . 
	gen legumes_05_`i'_6s_a = (legumes_05_`i' > legumes_05_`i'_6s)
	replace legumes_05_`i'_6s_a = . if legumes_05_`i' == . 
	
}

*** post summary statistics *** 
sum legumes_01_1_mean legumes_01_1_sd legumes_01_1_4s legumes_01_1_4s_a legumes_01_1_6s legumes_01_1_6s_a legumes_02_1_mean legumes_02_1_sd legumes_02_1_4s legumes_02_1_4s_a legumes_02_1_6s legumes_02_1_6s_a legumes_03_1_mean legumes_03_1_sd legumes_03_1_4s legumes_03_1_4s_a legumes_03_1_6s legumes_03_1_6s_a legumes_04_1_mean legumes_04_1_sd legumes_04_1_4s legumes_04_1_4s_a legumes_04_1_6s legumes_04_1_6s_a legumes_05_1_mean legumes_05_1_sd legumes_05_1_4s legumes_05_1_4s_a legumes_05_1_6s legumes_05_1_6s_a 

sum legumes_01_2_mean legumes_01_2_sd legumes_01_2_4s legumes_01_2_4s_a legumes_01_2_6s legumes_01_2_6s_a legumes_02_2_mean legumes_02_2_sd legumes_02_2_4s legumes_02_2_4s_a legumes_02_2_6s legumes_02_2_6s_a legumes_03_2_mean legumes_03_2_sd legumes_03_2_4s legumes_03_2_4s_a legumes_03_2_6s legumes_03_2_6s_a legumes_04_2_mean legumes_04_2_sd legumes_04_2_4s legumes_04_2_4s_a legumes_04_2_6s legumes_04_2_6s_a legumes_05_2_mean legumes_05_2_sd legumes_05_2_4s legumes_05_2_4s_a legumes_05_2_6s legumes_05_2_6s_a 

sum legumes_01_3_mean legumes_01_3_sd legumes_01_3_4s legumes_01_3_4s_a legumes_01_3_6s legumes_01_3_6s_a legumes_02_3_mean legumes_02_3_sd legumes_02_3_4s legumes_02_3_4s_a legumes_02_3_6s legumes_02_3_6s_a legumes_03_3_mean legumes_03_3_sd legumes_03_3_4s legumes_03_3_4s_a legumes_03_3_6s legumes_03_3_6s_a legumes_04_3_mean legumes_04_3_sd legumes_04_3_4s legumes_04_3_4s_a legumes_04_3_6s legumes_04_3_6s_a legumes_05_3_mean legumes_05_3_sd legumes_05_3_4s legumes_05_3_4s_a legumes_05_3_6s legumes_05_3_6s_a 

sum legumes_01_4_mean legumes_01_4_sd legumes_01_4_4s legumes_01_4_4s_a legumes_01_4_6s legumes_01_4_6s_a legumes_02_4_mean legumes_02_4_sd legumes_02_4_4s legumes_02_4_4s_a legumes_02_4_6s legumes_02_4_6s_a legumes_03_4_mean legumes_03_4_sd legumes_03_4_4s legumes_03_4_4s_a legumes_03_4_6s legumes_03_4_6s_a legumes_04_4_mean legumes_04_4_sd legumes_04_4_4s legumes_04_4_4s_a legumes_04_4_6s legumes_04_4_6s_a legumes_05_4_mean legumes_05_4_sd legumes_05_4_4s legumes_05_4_4s_a legumes_05_4_6s legumes_05_4_6s_a 

sum legumes_01_5_mean legumes_01_5_sd legumes_01_5_4s legumes_01_5_4s_a legumes_01_5_6s legumes_01_5_6s_a legumes_02_5_mean legumes_02_5_sd legumes_02_5_4s legumes_02_5_4s_a legumes_02_5_6s legumes_02_5_6s_a legumes_03_5_mean legumes_03_5_sd legumes_03_5_4s legumes_03_5_4s_a legumes_03_5_6s legumes_03_5_6s_a legumes_04_5_mean legumes_04_5_sd legumes_04_5_4s legumes_04_5_4s_a legumes_04_5_6s legumes_04_5_6s_a legumes_05_5_mean legumes_05_5_sd legumes_05_5_4s legumes_05_5_4s_a legumes_05_5_6s legumes_05_5_6s_a 

*** see which variables to winsorize - legumineuses ***
forvalues i = 1/4 {
    
	*** code -9s or -99s as missing *** 
	replace legumineuses_01_`i' = . if legumineuses_01_`i' < 0 
	replace legumineuses_02_`i' = . if legumineuses_02_`i' < 0 
	replace legumineuses_03_`i' = . if legumineuses_03_`i' < 0 
	replace legumineuses_04_`i' = . if legumineuses_04_`i' < 0 
	replace legumineuses_05_`i' = . if legumineuses_05_`i' < 0 
	
	*** calculate mean and standard deviation *** 
	egen legumineuses_01_`i'_mean = mean(legumineuses_01_`i')
	egen legumineuses_01_`i'_sd = sd(legumineuses_01_`i')
	
	*** calculate 4 sigma, 6 sigma *** 
	gen legumineuses_01_`i'_4s = legumineuses_01_`i'_mean + 4*legumineuses_01_`i'_sd 
	gen legumineuses_01_`i'_6s = legumineuses_01_`i'_mean + 6*legumineuses_01_`i'_sd 
	
	*** create indicators for above 4 sigma and above 6 sigma *** 
	gen legumineuses_01_`i'_4s_a = (legumineuses_01_`i' > legumineuses_01_`i'_4s)
	replace legumineuses_01_`i'_4s_a = . if legumineuses_01_`i' == . 
	gen legumineuses_01_`i'_6s_a = (legumineuses_01_`i' > legumineuses_01_`i'_6s)
	replace legumineuses_01_`i'_6s_a = . if legumineuses_01_`i' == .
	
	*** calculate mean and standard deviation *** 
	egen legumineuses_02_`i'_mean = mean(legumineuses_02_`i')
	egen legumineuses_02_`i'_sd = sd(legumineuses_02_`i')
	
	*** calculate 4 sigma, 6 sigma *** 
	gen legumineuses_02_`i'_4s = legumineuses_02_`i'_mean + 4*legumineuses_02_`i'_sd 
	gen legumineuses_02_`i'_6s = legumineuses_02_`i'_mean + 6*legumineuses_02_`i'_sd 
	
	*** create indicators for above 4 sigma and above 6 sigma *** 
	gen legumineuses_02_`i'_4s_a = (legumineuses_02_`i' > legumineuses_02_`i'_4s)
	replace legumineuses_02_`i'_4s_a = . if legumineuses_02_`i' == . 
	gen legumineuses_02_`i'_6s_a = (legumineuses_02_`i' > legumineuses_02_`i'_6s)
	replace legumineuses_02_`i'_6s_a = . if legumineuses_02_`i' == . 
	
	*** calculate mean and standard deviation *** 
	egen legumineuses_03_`i'_mean = mean(legumineuses_03_`i')
	egen legumineuses_03_`i'_sd = sd(legumineuses_03_`i')
	
	*** calculate 4 sigma, 6 sigma *** 
	gen legumineuses_03_`i'_4s = legumineuses_03_`i'_mean + 4*legumineuses_03_`i'_sd 
	gen legumineuses_03_`i'_6s = legumineuses_03_`i'_mean + 6*legumineuses_03_`i'_sd 

	
	*** create indicators for above 4 sigma and above 6 sigma *** 
	gen legumineuses_03_`i'_4s_a = (legumineuses_03_`i' > legumineuses_03_`i'_4s)
	replace legumineuses_03_`i'_4s_a = . if legumineuses_03_`i' == . 
	gen legumineuses_03_`i'_6s_a = (legumineuses_03_`i' > legumineuses_03_`i'_6s)
	replace legumineuses_03_`i'_6s_a = . if legumineuses_03_`i' == . 
	
	*** calculate mean and standard deviation *** 
	egen legumineuses_04_`i'_mean = mean(legumineuses_04_`i')
	egen legumineuses_04_`i'_sd = sd(legumineuses_04_`i')
	
	*** calculate 4 sigma, 6 sigma *** 
	gen legumineuses_04_`i'_4s = legumineuses_04_`i'_mean + 4*legumineuses_04_`i'_sd 
	gen legumineuses_04_`i'_6s = legumineuses_04_`i'_mean + 6*legumineuses_04_`i'_sd
	
	*** create indicators for above 4 sigma and above 6 sigma *** 
	gen legumineuses_04_`i'_4s_a = (legumineuses_04_`i' > legumineuses_04_`i'_4s)
	replace legumineuses_04_`i'_4s_a = . if legumineuses_04_`i' == . 
	gen legumineuses_04_`i'_6s_a = (legumineuses_04_`i' > legumineuses_04_`i'_6s)
	replace legumineuses_04_`i'_6s_a = . if legumineuses_04_`i' == . 
	
	*** calculate mean and standard deviation *** 
	egen legumineuses_05_`i'_mean = mean(legumineuses_05_`i')
	egen legumineuses_05_`i'_sd = sd(legumineuses_05_`i')
	
	*** calculate 4 sigma, 6 sigma *** 
	gen legumineuses_05_`i'_4s = legumineuses_05_`i'_mean + 4*legumineuses_05_`i'_sd 
	gen legumineuses_05_`i'_6s = legumineuses_05_`i'_mean + 6*legumineuses_05_`i'_sd 
	
	*** create indicators for above 4 sigma and above 6 sigma *** 
	gen legumineuses_05_`i'_4s_a = (legumineuses_05_`i' > legumineuses_05_`i'_4s)
	replace legumineuses_05_`i'_4s_a = . if legumineuses_05_`i' == . 
	gen legumineuses_05_`i'_6s_a = (legumineuses_05_`i' > legumineuses_05_`i'_6s)
	replace legumineuses_05_`i'_6s_a = . if legumineuses_05_`i' == . 
	
}

*** post summary statistics *** 
sum legumineuses_01_1_mean legumineuses_01_1_sd legumineuses_01_1_4s legumineuses_01_1_4s_a legumineuses_01_1_6s legumineuses_01_1_6s_a legumineuses_02_1_mean legumineuses_02_1_sd legumineuses_02_1_4s legumineuses_02_1_4s_a legumineuses_02_1_6s legumineuses_02_1_6s_a legumineuses_03_1_mean legumineuses_03_1_sd legumineuses_03_1_4s legumineuses_03_1_4s_a legumineuses_03_1_6s legumineuses_03_1_6s_a legumineuses_04_1_mean legumineuses_04_1_sd legumineuses_04_1_4s legumineuses_04_1_4s_a legumineuses_04_1_6s legumineuses_04_1_6s_a legumineuses_05_1_mean legumineuses_05_1_sd legumineuses_05_1_4s legumineuses_05_1_4s_a legumineuses_05_1_6s legumineuses_05_1_6s_a 

sum legumineuses_01_2_mean legumineuses_01_2_sd legumineuses_01_2_4s legumineuses_01_2_4s_a legumineuses_01_2_6s legumineuses_01_2_6s_a legumineuses_02_2_mean legumineuses_02_2_sd legumineuses_02_2_4s legumineuses_02_2_4s_a legumineuses_02_2_6s legumineuses_02_2_6s_a legumineuses_03_2_mean legumineuses_03_2_sd legumineuses_03_2_4s legumineuses_03_2_4s_a legumineuses_03_2_6s legumineuses_03_2_6s_a legumineuses_04_2_mean legumineuses_04_2_sd legumineuses_04_2_4s legumineuses_04_2_4s_a legumineuses_04_2_6s legumineuses_04_2_6s_a legumineuses_05_2_mean legumineuses_05_2_sd legumineuses_05_2_4s legumineuses_05_2_4s_a legumineuses_05_2_6s legumineuses_05_2_6s_a 

sum legumineuses_01_3_mean legumineuses_01_3_sd legumineuses_01_3_4s legumineuses_01_3_4s_a legumineuses_01_3_6s legumineuses_01_3_6s_a legumineuses_02_3_mean legumineuses_02_3_sd legumineuses_02_3_4s legumineuses_02_3_4s_a legumineuses_02_3_6s legumineuses_02_3_6s_a legumineuses_03_3_mean legumineuses_03_3_sd legumineuses_03_3_4s legumineuses_03_3_4s_a legumineuses_03_3_6s legumineuses_03_3_6s_a legumineuses_04_3_mean legumineuses_04_3_sd legumineuses_04_3_4s legumineuses_04_3_4s_a legumineuses_04_3_6s legumineuses_04_3_6s_a legumineuses_05_3_mean legumineuses_05_3_sd legumineuses_05_3_4s legumineuses_05_3_4s_a legumineuses_05_3_6s legumineuses_05_3_6s_a 

sum legumineuses_01_4_mean legumineuses_01_4_sd legumineuses_01_4_4s legumineuses_01_4_4s_a legumineuses_01_4_6s legumineuses_01_4_6s_a legumineuses_02_4_mean legumineuses_02_4_sd legumineuses_02_4_4s legumineuses_02_4_4s_a legumineuses_02_4_6s legumineuses_02_4_6s_a legumineuses_03_4_mean legumineuses_03_4_sd legumineuses_03_4_4s legumineuses_03_4_4s_a legumineuses_03_4_6s legumineuses_03_4_6s_a legumineuses_04_4_mean legumineuses_04_4_sd legumineuses_04_4_4s legumineuses_04_4_4s_a legumineuses_04_4_6s legumineuses_04_4_6s_a legumineuses_05_4_mean legumineuses_05_4_sd legumineuses_05_4_4s legumineuses_05_4_4s_a legumineuses_05_4_6s legumineuses_05_4_6s_a 

sum legumineuses_01_5_mean legumineuses_01_5_sd legumineuses_01_5_4s legumineuses_01_5_4s_a legumineuses_01_5_6s legumineuses_01_5_6s_a legumineuses_02_5_mean legumineuses_02_5_sd legumineuses_02_5_4s legumineuses_02_5_4s_a legumineuses_02_5_6s legumineuses_02_5_6s_a legumineuses_03_5_mean legumineuses_03_5_sd legumineuses_03_5_4s legumineuses_03_5_4s_a legumineuses_03_5_6s legumineuses_03_5_6s_a legumineuses_04_5_mean legumineuses_04_5_sd legumineuses_04_5_4s legumineuses_04_5_4s_a legumineuses_04_5_6s legumineuses_04_5_6s_a legumineuses_05_5_mean legumineuses_05_5_sd legumineuses_05_5_4s legumineuses_05_5_4s_a legumineuses_05_5_6s legumineuses_05_5_6s_a 

*** see which variables to winsorize - aquatique ***
forvalues i = 1/1 {
    
	*** code -9s or -99s as missing *** 
	replace aquatique_01_`i' = . if aquatique_01_`i' < 0 
	replace aquatique_02_`i' = . if aquatique_02_`i' < 0 
	replace aquatique_03_`i' = . if aquatique_03_`i' < 0 
	replace aquatique_04_`i' = . if aquatique_04_`i' < 0 
	replace aquatique_05_`i' = . if aquatique_05_`i' < 0 
	
	*** calculate mean and standard deviation *** 
	egen aquatique_01_`i'_mean = mean(aquatique_01_`i')
	egen aquatique_01_`i'_sd = sd(aquatique_01_`i')
	
	*** calculate 4 sigma, 6 sigma *** 
	gen aquatique_01_`i'_4s = aquatique_01_`i'_mean + 4*aquatique_01_`i'_sd 
	gen aquatique_01_`i'_6s = aquatique_01_`i'_mean + 6*aquatique_01_`i'_sd 
	
	*** create indicators for above 4 sigma and above 6 sigma *** 
	gen aquatique_01_`i'_4s_a = (aquatique_01_`i' > aquatique_01_`i'_4s)
	replace aquatique_01_`i'_4s_a = . if aquatique_01_`i' == . 
	gen aquatique_01_`i'_6s_a = (aquatique_01_`i' > aquatique_01_`i'_6s)
	replace aquatique_01_`i'_6s_a = . if aquatique_01_`i' == .
	
	*** calculate mean and standard deviation *** 
	egen aquatique_02_`i'_mean = mean(aquatique_02_`i')
	egen aquatique_02_`i'_sd = sd(aquatique_02_`i')
	
	*** calculate 4 sigma, 6 sigma *** 
	gen aquatique_02_`i'_4s = aquatique_02_`i'_mean + 4*aquatique_02_`i'_sd 
	gen aquatique_02_`i'_6s = aquatique_02_`i'_mean + 6*aquatique_02_`i'_sd 
	
	*** create indicators for above 4 sigma and above 6 sigma *** 
	gen aquatique_02_`i'_4s_a = (aquatique_02_`i' > aquatique_02_`i'_4s)
	replace aquatique_02_`i'_4s_a = . if aquatique_02_`i' == . 
	gen aquatique_02_`i'_6s_a = (aquatique_02_`i' > aquatique_02_`i'_6s)
	replace aquatique_02_`i'_6s_a = . if aquatique_02_`i' == . 
	
	*** calculate mean and standard deviation *** 
	egen aquatique_03_`i'_mean = mean(aquatique_03_`i')
	egen aquatique_03_`i'_sd = sd(aquatique_03_`i')
	
	*** calculate 4 sigma, 6 sigma *** 
	gen aquatique_03_`i'_4s = aquatique_03_`i'_mean + 4*aquatique_03_`i'_sd 
	gen aquatique_03_`i'_6s = aquatique_03_`i'_mean + 6*aquatique_03_`i'_sd 

	
	*** create indicators for above 4 sigma and above 6 sigma *** 
	gen aquatique_03_`i'_4s_a = (aquatique_03_`i' > aquatique_03_`i'_4s)
	replace aquatique_03_`i'_4s_a = . if aquatique_03_`i' == . 
	gen aquatique_03_`i'_6s_a = (aquatique_03_`i' > aquatique_03_`i'_6s)
	replace aquatique_03_`i'_6s_a = . if aquatique_03_`i' == . 
	
	*** calculate mean and standard deviation *** 
	egen aquatique_04_`i'_mean = mean(aquatique_04_`i')
	egen aquatique_04_`i'_sd = sd(aquatique_04_`i')
	
	*** calculate 4 sigma, 6 sigma *** 
	gen aquatique_04_`i'_4s = aquatique_04_`i'_mean + 4*aquatique_04_`i'_sd 
	gen aquatique_04_`i'_6s = aquatique_04_`i'_mean + 6*aquatique_04_`i'_sd
	
	*** create indicators for above 4 sigma and above 6 sigma *** 
	gen aquatique_04_`i'_4s_a = (aquatique_04_`i' > aquatique_04_`i'_4s)
	replace aquatique_04_`i'_4s_a = . if aquatique_04_`i' == . 
	gen aquatique_04_`i'_6s_a = (aquatique_04_`i' > aquatique_04_`i'_6s)
	replace aquatique_04_`i'_6s_a = . if aquatique_04_`i' == . 
	
	*** calculate mean and standard deviation *** 
	egen aquatique_05_`i'_mean = mean(aquatique_05_`i')
	egen aquatique_05_`i'_sd = sd(aquatique_05_`i')
	
	*** calculate 4 sigma, 6 sigma *** 
	gen aquatique_05_`i'_4s = aquatique_05_`i'_mean + 4*aquatique_05_`i'_sd 
	gen aquatique_05_`i'_6s = aquatique_05_`i'_mean + 6*aquatique_05_`i'_sd 
	
	*** create indicators for above 4 sigma and above 6 sigma *** 
	gen aquatique_05_`i'_4s_a = (aquatique_05_`i' > aquatique_05_`i'_4s)
	replace aquatique_05_`i'_4s_a = . if aquatique_05_`i' == . 
	gen aquatique_05_`i'_6s_a = (aquatique_05_`i' > aquatique_05_`i'_6s)
	replace aquatique_05_`i'_6s_a = . if aquatique_05_`i' == . 
	
}

*** post summary statistics *** 
sum aquatique_01_1_mean aquatique_01_1_sd aquatique_01_1_4s aquatique_01_1_4s_a aquatique_01_1_6s aquatique_01_1_6s_a aquatique_02_1_mean aquatique_02_1_sd aquatique_02_1_4s aquatique_02_1_4s_a aquatique_02_1_6s aquatique_02_1_6s_a aquatique_03_1_mean aquatique_03_1_sd aquatique_03_1_4s aquatique_03_1_4s_a aquatique_03_1_6s aquatique_03_1_6s_a aquatique_04_1_mean aquatique_04_1_sd aquatique_04_1_4s aquatique_04_1_4s_a aquatique_04_1_6s aquatique_04_1_6s_a aquatique_05_1_mean aquatique_05_1_sd aquatique_05_1_4s aquatique_05_1_4s_a aquatique_05_1_6s aquatique_05_1_6s_a 

*** import agriculture data ***
use "$data_deidentified\Complete_Baseline_Income", clear   

*** check variables to winsorize at the household animal type level *** 
*** variables to winsorize: agri_income_07, agri_income_08 ***
*** so need to reshape the data *** 

*** keep variables related to livestock first set of questions and hhid *** 
keep hhid speciesindex_* agri_income_07_* agri_income_08_*

drop agri_income_07_o agri_income_08_o 

*** reshape to household animaltype level *** 
reshape long speciesindex_ agri_income_07_ agri_income_08_, i(hhid) j(animal)

*** only keep entries with actual animals *** 
drop if speciesindex_ == . & agri_income_07_ == . & agri_income_08_ == . 

*** drop no animal category *** 
drop if speciesindex_ == 9 

*** filter by animal type and then summarize ***  
forvalues i = 1/8 {
	preserve 
	
	*** keep only one item type *** 
	keep if speciesindex_ == `i'
	
	*** calculate mean, standard deviation of each variable *** 
	egen agri_income_07_mean = mean(agri_income_07_)
	egen agri_income_07_sd = sd(agri_income_07_)
	
	*** calculate 4 sigma, 6 sigma *** 
	gen agri_income_07_4s = agri_income_07_mean + 4*agri_income_07_sd 
	gen agri_income_07_6s = agri_income_07_mean + 6*agri_income_07_sd 
	
	*** create indicators for above 4 sigma and above 6 sigma *** 
	gen agri_income_07_4s_a = (agri_income_07_ > agri_income_07_4s)
	gen agri_income_07_6s_a = (agri_income_07_ > agri_income_07_6s)
	
	*** calculate mean, standard deviation of each variable *** 
	egen agri_income_08_mean = mean(agri_income_08_)
	egen agri_income_08_sd = sd(agri_income_08_)
	
	*** calculate 4 sigma, 6 sigma *** 
	gen agri_income_08_4s = agri_income_08_mean + 4*agri_income_08_sd 
	gen agri_income_08_6s = agri_income_08_mean + 6*agri_income_08_sd 
	
	*** create indicators for above 4 sigma and above 6 sigma *** 
	gen agri_income_08_4s_a = (agri_income_08_ > agri_income_08_4s)
	gen agri_income_08_6s_a = (agri_income_08_ > agri_income_08_6s)
	
	*** post summary statistics by activity type *** 
	sum agri_income_07_mean agri_income_07_sd agri_income_07_4s agri_income_07_4s_a agri_income_07_6s agri_income_07_6s_a agri_income_08_mean agri_income_08_sd agri_income_08_4s agri_income_08_4s_a agri_income_08_6s agri_income_08_6s_a 
	
	restore 
} 

*** import agriculture data ***
use "$data_deidentified\Complete_Baseline_Income", clear   

*** check variables to winsorize at the household animal type level *** 
*** variables to winsorize: agri_income_11, agri_income_12, agri_income_14 ***
*** so need to reshape the data *** 

*** keep variables related to livestock first set of questions and hhid *** 
keep hhid sale_animalesindex_* agri_income_11_* agri_income_12_* agri_income_14_*

drop agri_income_11_o agri_income_12_o agri_income_14_o 

*** reshape to household animaltype level *** 
reshape long sale_animalesindex_ agri_income_11_ agri_income_12_ agri_income_14_, i(hhid) j(animal)

*** only keep entries with actual animals *** 
drop if sale_animalesindex_ == . & agri_income_11_ == . & agri_income_12_ == . & agri_income_14_ == .  

*** filter by animal type and then summarize ***  
forvalues i = 1/8 {
	preserve 
	
	*** keep only one item type *** 
	keep if sale_animalesindex_ == `i'
	
	*** replace -9s with missings *** 
	replace agri_income_12_ = . if agri_income_12_ < 0
	
	*** calculate mean, standard deviation of each variable *** 
	egen agri_income_11_mean = mean(agri_income_11_)
	egen agri_income_11_sd = sd(agri_income_11_)
	
	*** calculate 4 sigma, 6 sigma *** 
	gen agri_income_11_4s = agri_income_11_mean + 4*agri_income_11_sd 
	gen agri_income_11_6s = agri_income_11_mean + 6*agri_income_11_sd 
	
	*** create indicators for above 4 sigma and above 6 sigma *** 
	gen agri_income_11_4s_a = (agri_income_11_ > agri_income_11_4s)
	gen agri_income_11_6s_a = (agri_income_11_ > agri_income_11_6s)
	
	*** calculate mean, standard deviation of each variable *** 
	egen agri_income_12_mean = mean(agri_income_12_)
	egen agri_income_12_sd = sd(agri_income_12_)
	
	*** calculate 4 sigma, 6 sigma *** 
	gen agri_income_12_4s = agri_income_12_mean + 4*agri_income_12_sd 
	gen agri_income_12_6s = agri_income_12_mean + 6*agri_income_12_sd 
	
	*** create indicators for above 4 sigma and above 6 sigma *** 
	gen agri_income_12_4s_a = (agri_income_12_ > agri_income_12_4s)
	replace agri_income_12_4s_a = . if agri_income_12_ == . 
	gen agri_income_12_6s_a = (agri_income_12_ > agri_income_12_6s)
	replace agri_income_12_6s_a = . if agri_income_12_ == . 
	
	*** calculate mean, standard deviation of each variable *** 
	egen agri_income_14_mean = mean(agri_income_14_)
	egen agri_income_14_sd = sd(agri_income_14_)
	
	*** calculate 4 sigma, 6 sigma *** 
	gen agri_income_14_4s = agri_income_14_mean + 4*agri_income_14_sd 
	gen agri_income_14_6s = agri_income_14_mean + 6*agri_income_14_sd 
	
	*** create indicators for above 4 sigma and above 6 sigma *** 
	gen agri_income_14_4s_a = (agri_income_14_ > agri_income_14_4s)
	gen agri_income_14_6s_a = (agri_income_14_ > agri_income_14_6s)
	
	*** post summary statistics by activity type *** 
	sum agri_income_11_mean agri_income_11_sd agri_income_11_4s agri_income_11_4s_a agri_income_11_6s agri_income_11_6s_a agri_income_12_mean agri_income_12_sd agri_income_12_4s agri_income_12_4s_a agri_income_12_6s agri_income_12_6s_a agri_income_14_mean agri_income_14_sd agri_income_14_4s agri_income_14_4s_a agri_income_14_6s agri_income_14_6s_a 
	
	restore 
} 

*** import agriculture data ***
use "$data_deidentified\Complete_Baseline_Income", clear   

*** check variables to winsorize at the household level *** 
*** variables to winsorize: agri_income_16, agri_income_19, agri_income_33 ***

*** keep key variables *** 
keep hhid agri_income_16 agri_income_19 agri_income_33

*** create agri_income_19 per worker *** 
gen agri_income_19_pc = agri_income_19 / agri_income_16 

*** calculate mean, standard deviation of each variable *** 
egen agri_income_16_mean = mean(agri_income_16)
egen agri_income_16_sd = sd(agri_income_16)
egen agri_income_19_mean = mean(agri_income_19_pc)
egen agri_income_19_sd = sd(agri_income_19_pc)
egen agri_income_33_mean = mean(agri_income_33)
egen agri_income_33_sd = sd(agri_income_33)
	
*** calculate 4 sigma, 6 sigma *** 
gen agri_income_16_4s = agri_income_16_mean + 4*agri_income_16_sd 
gen agri_income_16_6s = agri_income_16_mean + 6*agri_income_16_sd 
gen agri_income_19_4s = agri_income_19_mean + 4*agri_income_19_sd 
gen agri_income_19_6s = agri_income_19_mean + 6*agri_income_19_sd 
gen agri_income_33_4s = agri_income_33_mean + 4*agri_income_33_sd 
gen agri_income_33_6s = agri_income_33_mean + 6*agri_income_33_sd 
	
*** create indicators for above 4 sigma and above 6 sigma *** 
gen agri_income_16_4s_a = (agri_income_16 > agri_income_16_4s)
replace agri_income_16_4s_a = . if agri_income_16 == . 
gen agri_income_16_6s_a = (agri_income_16 > agri_income_16_6s)
replace agri_income_16_6s_a = . if agri_income_16 == . 
gen agri_income_19_4s_a = (agri_income_19_pc > agri_income_19_4s)
replace agri_income_19_4s_a = . if agri_income_19_pc == . 
gen agri_income_19_6s_a = (agri_income_19_pc > agri_income_19_6s)
replace agri_income_19_6s_a = . if agri_income_19_pc == . 
gen agri_income_33_4s_a = (agri_income_33 > agri_income_33_4s)
replace agri_income_33_4s_a = . if agri_income_33 == . 
gen agri_income_33_6s_a = (agri_income_33 > agri_income_33_6s)
replace agri_income_33_6s_a = . if agri_income_33 == . 

*** post key summary statistics *** 
sum agri_income_16_mean agri_income_16_sd agri_income_16_4s agri_income_16_4s_a agri_income_16_6s agri_income_16_6s_a agri_income_19_mean agri_income_19_sd agri_income_19_4s agri_income_19_4s_a agri_income_19_6s agri_income_19_6s_a agri_income_33_mean agri_income_33_sd agri_income_33_4s agri_income_33_4s_a agri_income_33_6s agri_income_33_6s_a 

*** import agriculture data ***
use "$data_deidentified\Complete_Baseline_Income", clear   

*** check variables to winsorize at the household activity level *** 
*** variables to winsorize: agri_income_21_h, agri_income_21_f ***
*** need to reshape the data *** 

*** keep key variables *** 
keep hhid agri_income_20index_* agri_income_21_h_* agri_income_21_f_*

*** drop other categories *** 
drop agri_income_21_h_o agri_income_21_f_o 

*** reshape data to household activity level ***
reshape long agri_income_20index_ agri_income_21_h_ agri_income_21_f_ , i(hhid) j(activity)

*** drop if no activity *** 
drop if agri_income_20index_ == . & agri_income_21_h_ == . & agri_income_21_f_ == . 

*** filter by activity type and then summarize ***  
forvalues i = 1/8 {
	preserve 
	
	*** keep only one item type *** 
	keep if agri_income_20index_ == `i'
	
	*** replace -9s with missings *** 
	replace agri_income_21_f_ = . if agri_income_21_f_ < 0
	
	*** calculate mean, standard deviation of each variable *** 
	egen agri_income_21_h_mean = mean(agri_income_21_h_)
	egen agri_income_21_h_sd = sd(agri_income_21_h_)
	
	*** calculate 4 sigma, 6 sigma *** 
	gen agri_income_21_h_4s = agri_income_21_h_mean + 4*agri_income_21_h_sd 
	gen agri_income_21_h_6s = agri_income_21_h_mean + 6*agri_income_21_h_sd 
	
	*** create indicators for above 4 sigma and above 6 sigma *** 
	gen agri_income_21_h_4s_a = (agri_income_21_h_ > agri_income_21_h_4s)
	gen agri_income_21_h_6s_a = (agri_income_21_h_ > agri_income_21_h_6s)
	
	*** calculate mean, standard deviation of each variable *** 
	egen agri_income_21_f_mean = mean(agri_income_21_f_)
	egen agri_income_21_f_sd = sd(agri_income_21_f_)
	
	*** calculate 4 sigma, 6 sigma *** 
	gen agri_income_21_f_4s = agri_income_21_f_mean + 4*agri_income_21_f_sd 
	gen agri_income_21_f_6s = agri_income_21_f_mean + 6*agri_income_21_f_sd 
	
	*** create indicators for above 4 sigma and above 6 sigma *** 
	gen agri_income_21_f_4s_a = (agri_income_21_f_ > agri_income_21_f_4s)
	replace agri_income_21_f_4s_a = . if agri_income_21_f_ == . 
	gen agri_income_21_f_6s_a = (agri_income_21_f_ > agri_income_21_f_6s)
	replace agri_income_21_f_6s_a = . if agri_income_21_f_ == . 
	
	*** post summary statistics by activity type *** 
	sum agri_income_21_h_mean agri_income_21_h_sd agri_income_21_h_4s agri_income_21_h_4s_a agri_income_21_h_6s agri_income_21_h_6s_a agri_income_21_f_mean agri_income_21_f_sd agri_income_21_f_4s agri_income_21_f_4s_a agri_income_21_f_6s agri_income_21_f_6s_a 
	
	restore 
} 

*** import agriculture data ***
use "$data_deidentified\Complete_Baseline_Income", clear   

*** check variables to winsorize at the household level *** 
*** variables to winsorize: agri_income_36 ***
*** need to reshape the data *** 

*** keep key variables *** 
keep hhid agri_income_36_* 

*** reshape the data to household loan level *** 
reshape long agri_income_36_, i(hhid) j(loan)

*** get rid of -9s ***
replace agri_income_36 = . if agri_income_36 < 0 

*** collapse to sum at household level *** 
collapse (sum) agri_income_36_, by(hhid)

*** calculate mean, standard deviation of each variable *** 
egen agri_income_36_mean = mean(agri_income_36_)
egen agri_income_36_sd = sd(agri_income_36_)
	
*** calculate 4 sigma, 6 sigma *** 
gen agri_income_36_4s = agri_income_36_mean + 4*agri_income_36_sd 
gen agri_income_36_6s = agri_income_36_mean + 6*agri_income_36_sd 
	
*** create indicators for above 4 sigma and above 6 sigma *** 
gen agri_income_36_4s_a = (agri_income_36_ > agri_income_36_4s)
replace agri_income_36_4s_a = . if agri_income_36_ == . 
gen agri_income_36_6s_a = (agri_income_36_ > agri_income_36_6s)
replace agri_income_36_6s_a = . if agri_income_36_ == . 

*** post key summary statistics *** 
sum agri_income_36_mean agri_income_36_sd agri_income_36_4s agri_income_36_4s_a agri_income_36_6s agri_income_36_6s_a

*** import agriculture data ***
use "$data_deidentified\Complete_Baseline_Income", clear   

*** check variables to winsorize at the household level *** 
*** variables to winsorize: agri_income_41 ***
*** need to reshape the data *** 

*** keep key variables *** 
keep hhid agri_income_41_* 

*** reshape the data to household loan level *** 
reshape long agri_income_41_, i(hhid) j(loan)

*** get rid of -9s ***
replace agri_income_41 = . if agri_income_41 < 0 

*** collapse to sum at household level *** 
collapse (sum) agri_income_41_, by(hhid)

*** calculate mean, standard deviation of each variable *** 
egen agri_income_41_mean = mean(agri_income_41_)
egen agri_income_41_sd = sd(agri_income_41_)
	
*** calculate 4 sigma, 6 sigma *** 
gen agri_income_41_4s = agri_income_41_mean + 4*agri_income_41_sd 
gen agri_income_41_6s = agri_income_41_mean + 6*agri_income_41_sd 
	
*** create indicators for above 4 sigma and above 6 sigma *** 
gen agri_income_41_4s_a = (agri_income_41_ > agri_income_41_4s)
replace agri_income_41_4s_a = . if agri_income_41_ == . 
gen agri_income_41_6s_a = (agri_income_41_ > agri_income_41_6s)
replace agri_income_41_6s_a = . if agri_income_41_ == . 

*** post key summary statistics *** 
sum agri_income_41_mean agri_income_41_sd agri_income_41_4s agri_income_41_4s_a agri_income_41_6s agri_income_41_6s_a

*** import agriculture data ***
use "$data_deidentified\Complete_Baseline_Income", clear   

*** check variables to winsorize at the household product level *** 
*** variables to winsorize: agri_income_45  ***
*** need to reshape the data ***

*** keep key variables *** 
keep hhid productindex_* agri_income_45_* 

*** reshape data *** 
reshape long productindex_ agri_income_45_ , i(hhid) j(item)

*** drop if no product *** 
drop if productindex_ == . & agri_income_45_ == . 

*** filter by activity type and then summarize ***  
forvalues i = 1/14 {
	preserve 
	
	*** keep only one item type *** 
	keep if productindex_ == `i'
	
	*** replace -9s with missings *** 
	replace agri_income_45_ = . if agri_income_45_ < 0
	
	*** calculate mean, standard deviation of each variable *** 
	egen agri_income_45_mean = mean(agri_income_45_)
	egen agri_income_45_sd = sd(agri_income_45_)
	
	*** calculate 4 sigma, 6 sigma *** 
	gen agri_income_45_4s = agri_income_45_mean + 4*agri_income_45_sd 
	gen agri_income_45_6s = agri_income_45_mean + 6*agri_income_45_sd 
	
	*** create indicators for above 4 sigma and above 6 sigma *** 
	gen agri_income_45_4s_a = (agri_income_45_ > agri_income_45_4s)
	replace agri_income_45_4s_a = . if agri_income_45_ == . 
	gen agri_income_45_6s_a = (agri_income_45_ > agri_income_45_6s)
	replace agri_income_45_6s_a = . if agri_income_45_ == . 
	
	*** post summary statistics by activity type *** 
	sum agri_income_45_mean agri_income_45_sd agri_income_45_4s agri_income_45_4s_a agri_income_45_6s agri_income_45_6s_a 
	
	restore 
} 

*** import agriculture data ***
use "$data_deidentified\Complete_Baseline_Income", clear   

*** check variables to winsorize at the household product level *** 
*** variables to winsorize: agri_income_47 agri_income_48  ***
*** need to reshape the data ***

*** keep key variables *** 
keep hhid goodsindex_* agri_income_47_* agri_income_48_* 

*** drop other variables *** 
drop agri_income_47_o agri_income_48_o 

*** reshape data *** 
reshape long goodsindex_ agri_income_47_ agri_income_48_ , i(hhid) j(item)

*** drop if no product *** 
drop if goodsindex_ == . & agri_income_47_ == . & agri_income_48_ == .  

*** filter by activity type and then summarize ***  
forvalues i = 1/2 {
	preserve 
	
	*** keep only one item type *** 
	keep if goodsindex_ == `i'
	
	*** replace negative number with missings *** 
	replace agri_income_47_ = . if agri_income_47_ < 0
	
	*** calculate mean, standard deviation of each variable *** 
	egen agri_income_47_mean = mean(agri_income_47_)
	egen agri_income_47_sd = sd(agri_income_47_)
	
	*** calculate 4 sigma, 6 sigma *** 
	gen agri_income_47_4s = agri_income_47_mean + 4*agri_income_47_sd 
	gen agri_income_47_6s = agri_income_47_mean + 6*agri_income_47_sd 
	
	*** create indicators for above 4 sigma and above 6 sigma *** 
	gen agri_income_47_4s_a = (agri_income_47_ > agri_income_47_4s)
	replace agri_income_47_4s_a = . if agri_income_47_ == . 
	gen agri_income_47_6s_a = (agri_income_47_ > agri_income_47_6s)
	replace agri_income_47_6s_a = . if agri_income_47_ == . 
	
	*** calculate mean, standard deviation of each variable *** 
	egen agri_income_48_mean = mean(agri_income_48_)
	egen agri_income_48_sd = sd(agri_income_48_)
	
	*** calculate 4 sigma, 6 sigma *** 
	gen agri_income_48_4s = agri_income_48_mean + 4*agri_income_48_sd 
	gen agri_income_48_6s = agri_income_48_mean + 6*agri_income_48_sd 
	
	*** create indicators for above 4 sigma and above 6 sigma *** 
	gen agri_income_48_4s_a = (agri_income_48_ > agri_income_48_4s)
	replace agri_income_48_4s_a = . if agri_income_48_ == . 
	gen agri_income_48_6s_a = (agri_income_48_ > agri_income_48_6s)
	replace agri_income_48_6s_a = . if agri_income_48_ == . 
	
	*** post summary statistics by activity type *** 
	sum agri_income_47_mean agri_income_47_sd agri_income_47_4s agri_income_47_4s_a agri_income_47_6s agri_income_47_6s_a agri_income_48_mean agri_income_48_sd agri_income_48_4s agri_income_48_4s_a agri_income_48_6s agri_income_48_6s_a 
	
	restore 
} 


/* 
*** winsorize variable at the 1, 5, and 10 percent levels ***  
egen hh_04_99 = pctile(hh_04_), p(99)
egen hh_04_95 = pctile(hh_04_), p(95)
egen hh_04_90 = pctile(hh_04_), p(90) 

gen hh_04_1_ = hh_04_
replace hh_04_1_ = hh_04_99 if hh_04_ > hh_04_99 
replace hh_04_1_ = . if hh_04_ == . 

gen hh_04_5_ = hh_04_
replace hh_04_5_ = hh_04_95 if hh_04_ > hh_04_95 
replace hh_04_5_ = . if hh_04_ == . 

gen hh_04_10_ = hh_04_
replace hh_04_10_ = hh_04_90 if hh_04_ > hh_04_90 
replace hh_04_10_ = . if hh_04_ == . 

egen hh_05_99 = pctile(hh_05_), p(99)
egen hh_05_95 = pctile(hh_05_), p(95)
egen hh_05_90 = pctile(hh_05_), p(90) 

gen hh_05_1_ = hh_05_
replace hh_05_1_ = hh_05_99 if hh_05_ > hh_05_99 
replace hh_05_1_ = . if hh_05_ == . 

gen hh_05_5_ = hh_05_
replace hh_05_5_ = hh_05_95 if hh_05_ > hh_05_95 
replace hh_05_5_ = . if hh_05_ == . 

gen hh_05_10_ = hh_05_
replace hh_05_10_ = hh_05_90 if hh_05_ > hh_05_90 
replace hh_05_10_ = . if hh_05_ == . 

egen hh_06_99 = pctile(hh_06_), p(99)
egen hh_06_95 = pctile(hh_06_), p(95)
egen hh_06_90 = pctile(hh_06_), p(90) 

gen hh_06_1_ = hh_06_
replace hh_06_1_ = hh_06_99 if hh_06_ > hh_06_99 
replace hh_06_1_ = . if hh_06_ == . 

gen hh_06_5_ = hh_06_
replace hh_06_5_ = hh_06_95 if hh_06_ > hh_06_95 
replace hh_06_5_ = . if hh_06_ == . 

gen hh_06_10_ = hh_06_
replace hh_06_10_ = hh_06_90 if hh_06_ > hh_06_90 
replace hh_06_10_ = . if hh_06_ == . 

egen hh_07_99 = pctile(hh_07_), p(99)
egen hh_07_95 = pctile(hh_07_), p(95)
egen hh_07_90 = pctile(hh_07_), p(90) 

gen hh_07_1_ = hh_07_
replace hh_07_1_ = hh_07_99 if hh_07_ > hh_07_99 
replace hh_07_1_ = . if hh_07_ == . 

gen hh_07_5_ = hh_07_
replace hh_07_5_ = hh_07_95 if hh_07_ > hh_07_95 
replace hh_07_5_ = . if hh_07_ == . 

gen hh_07_10_ = hh_07_
replace hh_07_10_ = hh_07_90 if hh_07_ > hh_07_90 
replace hh_07_10_ = . if hh_07_ == . 

egen hh_08_99 = pctile(hh_08_), p(99)
egen hh_08_95 = pctile(hh_08_), p(95)
egen hh_08_90 = pctile(hh_08_), p(90) 

gen hh_08_1_ = hh_08_
replace hh_08_1_ = hh_08_99 if hh_08_ > hh_08_99 
replace hh_08_1_ = . if hh_08_ == . 

gen hh_08_5_ = hh_08_
replace hh_08_5_ = hh_08_95 if hh_08_ > hh_08_95 
replace hh_08_5_ = . if hh_08_ == . 

gen hh_08_10_ = hh_08_
replace hh_08_10_ = hh_08_90 if hh_08_ > hh_08_90 
replace hh_08_10_ = . if hh_08_ == . 

egen hh_09_99 = pctile(hh_09_), p(99)
egen hh_09_95 = pctile(hh_09_), p(95)
egen hh_09_90 = pctile(hh_09_), p(90) 

gen hh_09_1_ = hh_09_
replace hh_09_1_ = hh_09_99 if hh_09_ > hh_09_99 
replace hh_09_1_ = . if hh_09_ == . 

gen hh_09_5_ = hh_09_
replace hh_09_5_ = hh_09_95 if hh_09_ > hh_09_95 
replace hh_09_5_ = . if hh_09_ == . 

gen hh_09_10_ = hh_09_
replace hh_09_10_ = hh_09_90 if hh_09_ > hh_09_90 
replace hh_09_10_ = . if hh_09_ == . 

egen hh_14_99 = pctile(hh_14_), p(99)
egen hh_14_95 = pctile(hh_14_), p(95)
egen hh_14_90 = pctile(hh_14_), p(90) 

gen hh_14_1_ = hh_14_
replace hh_14_1_ = hh_14_99 if hh_14_ > hh_14_99 
replace hh_14_1_ = . if hh_14_ == . 

gen hh_14_5_ = hh_14_
replace hh_14_5_ = hh_14_95 if hh_14_ > hh_14_95 
replace hh_14_5_ = . if hh_14_ == . 

gen hh_14_10_ = hh_14_
replace hh_14_10_ = hh_14_90 if hh_14_ > hh_14_90 
replace hh_14_10_ = . if hh_14_ == . 

egen hh_16_99 = pctile(hh_16_), p(99)
egen hh_16_95 = pctile(hh_16_), p(95)
egen hh_16_90 = pctile(hh_16_), p(90) 

gen hh_16_1_ = hh_16_
replace hh_16_1_ = hh_16_99 if hh_16_ > hh_16_99 
replace hh_16_1_ = . if hh_16_ == . 

gen hh_16_5_ = hh_16_
replace hh_16_5_ = hh_16_95 if hh_16_ > hh_16_95 
replace hh_16_5_ = . if hh_16_ == . 

gen hh_16_10_ = hh_16_
replace hh_16_10_ = hh_16_90 if hh_16_ > hh_16_90 
replace hh_16_10_ = . if hh_16_ == . 

egen hh_17_99 = pctile(hh_17_), p(99)
egen hh_17_95 = pctile(hh_17_), p(95)
egen hh_17_90 = pctile(hh_17_), p(90) 

gen hh_17_1_ = hh_17_
replace hh_17_1_ = hh_17_99 if hh_17_ > hh_17_99 
replace hh_17_1_ = . if hh_17_ == . 

gen hh_17_5_ = hh_17_
replace hh_17_5_ = hh_17_95 if hh_17_ > hh_17_95 
replace hh_17_5_ = . if hh_17_ == . 

gen hh_17_10_ = hh_17_
replace hh_17_10_ = hh_17_90 if hh_17_ > hh_17_90 
replace hh_17_10_ = . if hh_17_ == . 

egen hh_22_99 = pctile(hh_22_), p(99)
egen hh_22_95 = pctile(hh_22_), p(95)
egen hh_22_90 = pctile(hh_22_), p(90) 

gen hh_22_1_ = hh_22_
replace hh_22_1_ = hh_22_99 if hh_22_ > hh_22_99 
replace hh_22_1_ = . if hh_22_ == . 

gen hh_22_5_ = hh_22_
replace hh_22_5_ = hh_22_95 if hh_22_ > hh_22_95 
replace hh_22_5_ = . if hh_22_ == . 

gen hh_22_10_ = hh_22_
replace hh_22_10_ = hh_22_90 if hh_22_ > hh_22_90 
replace hh_22_10_ = . if hh_22_ == . 

egen hh_24_99 = pctile(hh_24_), p(99)
egen hh_24_95 = pctile(hh_24_), p(95)
egen hh_24_90 = pctile(hh_24_), p(90) 

gen hh_24_1_ = hh_24_
replace hh_24_1_ = hh_24_99 if hh_24_ > hh_24_99 
replace hh_24_1_ = . if hh_24_ == . 

gen hh_24_5_ = hh_24_
replace hh_24_5_ = hh_24_95 if hh_24_ > hh_24_95 
replace hh_24_5_ = . if hh_24_ == . 

gen hh_24_10_ = hh_24_
replace hh_24_10_ = hh_24_90 if hh_24_ > hh_24_90 
replace hh_24_10_ = . if hh_24_ == . 

egen hh_25_99 = pctile(hh_25_), p(99)
egen hh_25_95 = pctile(hh_25_), p(95)
egen hh_25_90 = pctile(hh_25_), p(90) 

gen hh_25_1_ = hh_25_
replace hh_25_1_ = hh_25_99 if hh_25_ > hh_25_99 
replace hh_25_1_ = . if hh_25_ == . 

gen hh_25_5_ = hh_25_
replace hh_25_5_ = hh_25_95 if hh_25_ > hh_25_95 
replace hh_25_5_ = . if hh_25_ == . 

gen hh_25_10_ = hh_25_
replace hh_25_10_ = hh_25_90 if hh_25_ > hh_25_90 
replace hh_25_10_ = . if hh_25_ == . 

*** drop extra variables created to winsorize  *** 
drop hh_04_99 hh_04_95 hh_04_90 hh_05_99 hh_05_95 hh_05_90 hh_06_99 hh_06_95 hh_06_90 hh_07_99 hh_07_95 hh_07_90 hh_08_99 hh_08_95 hh_08_90 hh_09_99 hh_09_95 hh_09_90 hh_14_99 hh_14_95 hh_14_90 hh_16_99 hh_16_95 hh_16_90 hh_17_99 hh_17_95 hh_17_90 hh_22_99 hh_22_95 hh_22_90 hh_24_99 hh_24_95 hh_24_90 hh_25_99 hh_25_95 hh_25_90

*** reshape dataset back to household level observations *** 
reshape wide hh_04_ hh_04_1_ hh_04_5_ hh_04_10_ hh_05_ hh_05_1_ hh_05_5_ hh_05_10_ hh_06_ hh_06_1_ hh_06_5_ hh_06_10_ hh_07_ hh_07_1_ hh_07_5_ hh_07_10_ hh_08_ hh_08_1_ hh_08_5_ hh_08_10_ hh_09_ hh_09_1_ hh_09_5_ hh_09_10_ hh_14_ hh_14_1_ hh_14_5_ hh_14_10_ hh_16_ hh_16_1_ hh_16_5_ hh_16_10_ hh_17_ hh_17_1_ hh_17_5_ hh_17_10_ hh_22_ hh_22_1_ hh_22_5_ hh_22_10_ hh_24_ hh_24_1_ hh_24_5_ hh_24_10_ hh_25_ hh_25_1_ hh_25_5_ hh_25_10_, i(hhid) j(individual)

*** merge back in entire household roster data *** 
merge 1:1 hhid using "$data_deidentified\Complete_Baseline_Household_Roster"

drop _merge 

*** save winsorized dataset ***
save "$winsorized\Baseline_Household_Roster.dta", replace 

*** import health data ***
use "$data_deidentified\Complete_Baseline_Health", clear   

*** winsorize at the 1, 5, and 10 percent levels *** 
*** at the individual level not the household level *** 
*** variables to winsorize: heatlh_5_4 *** 
*** so need to reshape the data *** 

*** keep only hhid, variables to winsorize, will merge back with main dataset later *** 
keep hhid health_5_4_*

reshape long health_5_4_ , i(hhid) j(individual)

*** winsorize variable at the 1, 5, and 10 percent levels *** 
egen health_5_4_99 = pctile(health_5_4_), p(99)
egen health_5_4_95 = pctile(health_5_4_), p(95)
egen health_5_4_90 = pctile(health_5_4_), p(90) 

gen health_5_4_1_ = health_5_4_
replace health_5_4_1_ = health_5_4_99 if health_5_4_ > health_5_4_99 
replace health_5_4_1_ = . if health_5_4_ == . 

gen health_5_4_5_ = health_5_4_
replace health_5_4_5_ = health_5_4_95 if health_5_4_ > health_5_4_95 
replace health_5_4_5_ = . if health_5_4_ == . 

gen health_5_4_10_ = health_5_4_
replace health_5_4_10_ = health_5_4_90 if health_5_4_ > health_5_4_90 
replace health_5_4_10_ = . if health_5_4_ == . 

*** drop extra variables created to winsorize *** 
drop health_5_4_99 health_5_4_95 health_5_4_90 

*** reshape dataset back to original househld level data *** 
reshape wide health_5_4_ health_5_4_1_ health_5_4_5_ health_5_4_10_, i(hhid) j(individual) 

*** merge back in entire household roster data *** 
merge 1:1 hhid using "$data_deidentified\Complete_Baseline_Health"

drop _merge 

*** save winsorized dataset ***
save "$winsorized\Baseline_Health.dta", replace 

*** import agriculture data ***
use "$data_deidentified\Complete_Baseline_Agriculture", clear   

*** winsorize at the 1, 5, and 10 percent levels *** 
*** at the individual level not the household level *** 
*** variables to winsorize: agri_6_21, agri_6_32, agri_6_35, agri_6_37 ***
*** agri_6_38_a, agri_6_39_a, agri_6_40_a, agri_6_41_a ***  
*** so need to reshape the data *** 

*** need additional unit measurement information agri_6_32, agri_6_38_a, agri_6_39_a, agri_6_40_a, agri_6_41_a ***

*** keep only hhid, variables to winsorize, units will merge back with main dataset later *** 
keep hhid agri_6_21_* agri_6_22_* agri_6_32_* agri_6_33_* agri_6_35_* agri_6_37_* agri_6_38_a_* agri_6_39_a_* agri_6_40_a_* agri_6_41_a_*

*** make other variables strings *** 
tostring agri_6_38_a_code_o_3, replace 
tostring agri_6_38_a_code_o_4, replace 
tostring agri_6_38_a_code_o_5, replace 
tostring agri_6_38_a_code_o_6, replace 
tostring agri_6_38_a_code_o_7, replace 
tostring agri_6_38_a_code_o_8, replace 
tostring agri_6_38_a_code_o_9, replace 
tostring agri_6_38_a_code_o_10, replace 
tostring agri_6_38_a_code_o_11, replace  

tostring agri_6_39_a_code_o_4, replace 
tostring agri_6_39_a_code_o_5, replace 
tostring agri_6_39_a_code_o_6, replace 
tostring agri_6_39_a_code_o_7, replace 
tostring agri_6_39_a_code_o_8, replace 
tostring agri_6_39_a_code_o_9, replace 
tostring agri_6_39_a_code_o_10, replace 
tostring agri_6_39_a_code_o_11, replace  

tostring agri_6_40_a_code_o_4, replace 
tostring agri_6_40_a_code_o_5, replace 
tostring agri_6_40_a_code_o_6, replace 
tostring agri_6_40_a_code_o_7, replace 
tostring agri_6_40_a_code_o_8, replace 
tostring agri_6_40_a_code_o_9, replace 
tostring agri_6_40_a_code_o_10, replace 
tostring agri_6_40_a_code_o_11, replace 

tostring agri_6_41_a_code_o_4, replace 
tostring agri_6_41_a_code_o_5, replace 
tostring agri_6_41_a_code_o_6, replace 
tostring agri_6_41_a_code_o_7, replace 
tostring agri_6_41_a_code_o_8, replace 
tostring agri_6_41_a_code_o_9, replace 
tostring agri_6_41_a_code_o_10, replace 
tostring agri_6_41_a_code_o_11, replace 

reshape long agri_6_21_ agri_6_22_ agri_6_32_ agri_6_33_ agri_6_35_ agri_6_37_ agri_6_38_a_ agri_6_38_a_code_ agri_6_38_a_code_o_ agri_6_39_a_ agri_6_39_a_code_ agri_6_39_a_code_o_ agri_6_40_a_ agri_6_40_a_code_ agri_6_40_a_code_o_ agri_6_41_a_  agri_6_41_a_code_ agri_6_41_a_code_o_, i(hhid) j(plotn)

*** winsorize variable at the 1, 5, and 10 percent levels *** 

*** convert all land holding values into meters squared *** 
replace agri_6_21_ = agri_6_21_*10000 if agri_6_22_ == 1 

egen agri_6_21_99 = pctile(agri_6_21_), p(99)
egen agri_6_21_95 = pctile(agri_6_21_), p(95)
egen agri_6_21_90 = pctile(agri_6_21_), p(90) 

gen agri_6_21_1_ = agri_6_21_
replace agri_6_21_1_ = agri_6_21_99 if agri_6_21_ > agri_6_21_99 
replace agri_6_21_1_ = . if agri_6_21_ == . 

gen agri_6_21_5_ = agri_6_21_
replace agri_6_21_5_ = agri_6_21_95 if agri_6_21_ > agri_6_21_95 
replace agri_6_21_5_ = . if agri_6_21_ == . 

gen agri_6_21_10_ = agri_6_21_
replace agri_6_21_10_ = agri_6_21_90 if agri_6_21_ > agri_6_21_90 
replace agri_6_21_10_ = . if agri_6_21_ == . 

egen agri_6_35_99 = pctile(agri_6_35_), p(99)
egen agri_6_35_95 = pctile(agri_6_35_), p(95)
egen agri_6_35_90 = pctile(agri_6_35_), p(90) 

gen agri_6_35_1_ = agri_6_35_
replace agri_6_35_1_ = agri_6_35_99 if agri_6_35_ > agri_6_35_99 
replace agri_6_35_1_ = . if agri_6_35_ == . 

gen agri_6_35_5_ = agri_6_35_
replace agri_6_35_5_ = agri_6_35_95 if agri_6_35_ > agri_6_35_95 
replace agri_6_35_5_ = . if agri_6_35_ == . 

gen agri_6_35_10_ = agri_6_35_
replace agri_6_35_10_ = agri_6_35_90 if agri_6_35_ > agri_6_35_90 
replace agri_6_35_10_ = . if agri_6_35_ == . 

egen agri_6_37_99 = pctile(agri_6_37_), p(99)
egen agri_6_37_95 = pctile(agri_6_37_), p(95)
egen agri_6_37_90 = pctile(agri_6_37_), p(90) 

gen agri_6_37_1_ = agri_6_37_
replace agri_6_37_1_ = agri_6_37_99 if agri_6_37_ > agri_6_37_99 
replace agri_6_37_1_ = . if agri_6_37_ == . 

gen agri_6_37_5_ = agri_6_37_
replace agri_6_37_5_ = agri_6_37_95 if agri_6_37_ > agri_6_37_95 
replace agri_6_37_5_ = . if agri_6_37_ == . 

gen agri_6_37_10_ = agri_6_37_
replace agri_6_37_10_ = agri_6_37_90 if agri_6_37_ > agri_6_37_90 
replace agri_6_37_10_ = . if agri_6_37_ == . 

** drop extra variables created to winsorize *** 
drop agri_6_21_99 agri_6_21_95 agri_6_21_90 agri_6_35_99 agri_6_35_95 agri_6_35_90  agri_6_37_99 agri_6_37_95 agri_6_37_90 

*** reshape dataset back to original househld level data *** 
reshape wide agri_6_21_ agri_6_21_1_ agri_6_21_5_ agri_6_21_10_ agri_6_22_ agri_6_32_ agri_6_33_ agri_6_35_ agri_6_35_1_ agri_6_35_5_ agri_6_35_10_ agri_6_37_ agri_6_37_1_ agri_6_37_5_ agri_6_37_10_ agri_6_38_a_ agri_6_38_a_code_ agri_6_38_a_code_o_ agri_6_39_a_ agri_6_39_a_code_ agri_6_39_a_code_o_ agri_6_40_a_ agri_6_40_a_code_ agri_6_40_a_code_o_ agri_6_41_a_  agri_6_41_a_code_ agri_6_41_a_code_o_, i(hhid) j(plotn) 

*** merge back in entire household roster data *** 
merge 1:1 hhid using "$data_deidentified\Complete_Baseline_Agriculture", force 

drop _merge 

*** save winsorized dataset ***
save "$winsorized\Baseline_Agriculture.dta", replace 

*** import agriculture data ***
use "$data_deidentified\Complete_Baseline_Production", clear   

*** winsorize at the 1, 5, and 10 percent levels ***
forvalues i = 1/5 {
	egen cereals_01_`i'_99 = pctile(cereals_01_`i'), p(99)
	egen cereals_01_`i'_95 = pctile(cereals_01_`i'), p(95)
	egen cereals_01_`i'_90 = pctile(cereals_01_`i'), p(90) 

	gen cereals_01_`i'_1 = cereals_01_`i'
	replace cereals_01_`i'_1 = cereals_01_`i'_99 if cereals_01_`i'_1 > cereals_01_`i'_99 
	replace cereals_01_`i'_1 = . if cereals_01_`i' == . 

	gen cereals_01_`i'_5 = cereals_01_`i'
	replace cereals_01_`i'_5 = cereals_01_`i'_95 if cereals_01_`i'_5 > cereals_01_`i'_95 
	replace cereals_01_`i'_5 = . if cereals_01_`i' == . 

	gen cereals_01_`i'_10 = cereals_01_`i'
	replace cereals_01_`i'_10 = cereals_01_`i'_90 if cereals_01_`i'_10 > cereals_01_`i'_90 
	replace cereals_01_`i'_10 = . if cereals_01_`i' == . 
}

forvalues i = 1/5 {
	egen cereals_02_`i'_99 = pctile(cereals_02_`i'), p(99)
	egen cereals_02_`i'_95 = pctile(cereals_02_`i'), p(95)
	egen cereals_02_`i'_90 = pctile(cereals_02_`i'), p(90) 

	gen cereals_02_`i'_1 = cereals_02_`i'
	replace cereals_02_`i'_1 = cereals_02_`i'_99 if cereals_02_`i'_1 > cereals_02_`i'_99 
	replace cereals_02_`i'_1 = . if cereals_02_`i' == . 

	gen cereals_02_`i'_5 = cereals_02_`i'
	replace cereals_02_`i'_5 = cereals_02_`i'_95 if cereals_02_`i'_5 > cereals_02_`i'_95 
	replace cereals_02_`i'_5 = . if cereals_02_`i' == . 

	gen cereals_02_`i'_10 = cereals_02_`i'
	replace cereals_02_`i'_10 = cereals_02_`i'_90 if cereals_02_`i'_10 > cereals_02_`i'_90 
	replace cereals_02_`i'_10 = . if cereals_02_`i' == . 
}

forvalues i = 1/5 {
	egen cereals_05_`i'_99 = pctile(cereals_05_`i'), p(99)
	egen cereals_05_`i'_95 = pctile(cereals_05_`i'), p(95)
	egen cereals_05_`i'_90 = pctile(cereals_05_`i'), p(90) 

	gen cereals_05_`i'_1 = cereals_05_`i'
	replace cereals_05_`i'_1 = cereals_05_`i'_99 if cereals_05_`i'_1 > cereals_05_`i'_99 
	replace cereals_05_`i'_1 = . if cereals_05_`i' == . 

	gen cereals_05_`i'_5 = cereals_05_`i'
	replace cereals_05_`i'_5 = cereals_05_`i'_95 if cereals_05_`i'_5 > cereals_05_`i'_95 
	replace cereals_05_`i'_5 = . if cereals_05_`i' == . 

	gen cereals_05_`i'_10 = cereals_05_`i'
	replace cereals_05_`i'_10 = cereals_05_`i'_90 if cereals_05_`i'_10 > cereals_05_`i'_90 
	replace cereals_05_`i'_10 = . if cereals_05_`i' == . 
}

forvalues i = 1/2 {
	egen farines_01_`i'_99 = pctile(farines_01_`i'), p(99)
	egen farines_01_`i'_95 = pctile(farines_01_`i'), p(95)
	egen farines_01_`i'_90 = pctile(farines_01_`i'), p(90) 

	gen farines_01_`i'_1 = farines_01_`i'
	replace farines_01_`i'_1 = farines_01_`i'_99 if farines_01_`i'_1 > farines_01_`i'_99 
	replace farines_01_`i'_1 = . if farines_01_`i' == . 

	gen farines_01_`i'_5 = farines_01_`i'
	replace farines_01_`i'_5 = farines_01_`i'_95 if farines_01_`i'_5 > farines_01_`i'_95 
	replace farines_01_`i'_5 = . if farines_01_`i' == . 

	gen farines_01_`i'_10 = farines_01_`i'
	replace farines_01_`i'_10 = farines_01_`i'_90 if farines_01_`i'_10 > farines_01_`i'_90 
	replace farines_01_`i'_10 = . if farines_01_`i' == . 
}

forvalues i = 1/2 {
	egen farines_02_`i'_99 = pctile(farines_02_`i'), p(99)
	egen farines_02_`i'_95 = pctile(farines_02_`i'), p(95)
	egen farines_02_`i'_90 = pctile(farines_02_`i'), p(90) 

	gen farines_02_`i'_1 = farines_02_`i'
	replace farines_02_`i'_1 = farines_02_`i'_99 if farines_02_`i'_1 > farines_02_`i'_99 
	replace farines_02_`i'_1 = . if farines_02_`i' == . 

	gen farines_02_`i'_5 = farines_02_`i'
	replace farines_02_`i'_5 = farines_02_`i'_95 if farines_02_`i'_5 > farines_02_`i'_95 
	replace farines_02_`i'_5 = . if farines_02_`i' == . 

	gen farines_02_`i'_10 = farines_02_`i'
	replace farines_02_`i'_10 = farines_02_`i'_90 if farines_02_`i'_10 > farines_02_`i'_90 
	replace farines_02_`i'_10 = . if farines_02_`i' == . 
}

forvalues i = 1/2 {
	egen farines_05_`i'_99 = pctile(farines_05_`i'), p(99)
	egen farines_05_`i'_95 = pctile(farines_05_`i'), p(95)
	egen farines_05_`i'_90 = pctile(farines_05_`i'), p(90) 

	gen farines_05_`i'_1 = farines_05_`i'
	replace farines_05_`i'_1 = farines_05_`i'_99 if farines_05_`i'_1 > farines_05_`i'_99 
	replace farines_05_`i'_1 = . if farines_05_`i' == . 

	gen farines_05_`i'_5 = farines_05_`i'
	replace farines_05_`i'_5 = farines_05_`i'_95 if farines_05_`i'_5 > farines_05_`i'_95 
	replace farines_05_`i'_5 = . if farines_05_`i' == . 

	gen farines_05_`i'_10 = farines_05_`i'
	replace farines_05_`i'_10 = farines_05_`i'_90 if farines_05_`i'_10 > farines_05_`i'_90 
	replace farines_05_`i'_10 = . if farines_05_`i' == . 
}

egen legumes_01_1_99 = pctile(legumes_01_1), p(99)
egen legumes_01_1_95 = pctile(legumes_01_1), p(95)
egen legumes_01_1_90 = pctile(legumes_01_1), p(90) 

gen legumes_01_1_1 = legumes_01_1
replace legumes_01_1_1 = legumes_01_1_99 if legumes_01_1_1 > legumes_01_1_99 
replace legumes_01_1_1 = . if legumes_01_1 == . 

gen legumes_01_1_5 = legumes_01_1
replace legumes_01_1_5 = legumes_01_1_95 if legumes_01_1_5 > legumes_01_1_95 
replace legumes_01_1_5 = . if legumes_01_1 == . 

gen legumes_01_1_10 = legumes_01_1
replace legumes_01_1_10 = legumes_01_1_90 if legumes_01_1_10 > legumes_01_1_90 
replace legumes_01_1_10 = . if legumes_01_1 == . 

egen legumes_01_3_99 = pctile(legumes_01_3), p(99)
egen legumes_01_3_95 = pctile(legumes_01_3), p(95)
egen legumes_01_3_90 = pctile(legumes_01_3), p(90) 

gen legumes_01_3_1 = legumes_01_3
replace legumes_01_3_1 = legumes_01_3_99 if legumes_01_3_1 > legumes_01_3_99 
replace legumes_01_3_1 = . if legumes_01_3 == . 

gen legumes_01_3_5 = legumes_01_3
replace legumes_01_3_5 = legumes_01_3_95 if legumes_01_3_5 > legumes_01_3_95 
replace legumes_01_3_5 = . if legumes_01_3 == . 

gen legumes_01_3_10 = legumes_01_3
replace legumes_01_3_10 = legumes_01_3_90 if legumes_01_3_10 > legumes_01_3_90 
replace legumes_01_3_10 = . if legumes_01_3 == . 

egen legumineuses_01_1_99 = pctile(legumineuses_01_1), p(99)
egen legumineuses_01_1_95 = pctile(legumineuses_01_1), p(95)
egen legumineuses_01_1_90 = pctile(legumineuses_01_1), p(90) 

gen legumineuses_01_1_1 = legumineuses_01_1
replace legumineuses_01_1_1 = legumineuses_01_1_99 if legumineuses_01_1_1 > legumineuses_01_1_99 
replace legumineuses_01_1_1 = . if legumineuses_01_1 == . 

gen legumineuses_01_1_5 = legumineuses_01_1
replace legumineuses_01_1_5 = legumineuses_01_1_95 if legumineuses_01_1_5 > legumineuses_01_1_95 
replace legumineuses_01_1_5 = . if legumineuses_01_1 == . 

gen legumineuses_01_1_10 = legumineuses_01_1
replace legumineuses_01_1_10 = legumineuses_01_1_90 if legumineuses_01_1_10 > legumineuses_01_1_90 
replace legumineuses_01_1_10 = . if legumineuses_01_1 == . 

*** drop variables created in the winsorization process *** 
drop cereals_01_1_99 cereals_01_1_95 cereals_01_1_90 cereals_01_2_99 cereals_01_2_95 cereals_01_2_90 cereals_01_3_99 cereals_01_3_95 cereals_01_3_90 cereals_01_4_99 cereals_01_4_95 cereals_01_4_90 cereals_01_5_99 cereals_01_5_95 cereals_01_5_90 farines_01_1_99 farines_01_1_95 farines_01_1_90 farines_01_2_99 farines_01_2_95 farines_01_2_90 legumes_01_1_99 legumes_01_1_95 legumes_01_1_90 legumes_01_3_99 legumes_01_3_95 legumes_01_3_90 legumineuses_01_1_99 legumineuses_01_1_95 legumineuses_01_1_90

*** save winsorized dataset ***
save "$winsorized\Baseline_Production.dta", replace 

*** import income data ***
use "$data_deidentified\Complete_Baseline_Income", clear   

*** winsorize household level variables that do not require filtering *** 
egen agri_income_16_99 = pctile(agri_income_16), p(99)
egen agri_income_16_95 = pctile(agri_income_16), p(95)
egen agri_income_16_90 = pctile(agri_income_16), p(90) 

gen agri_income_16_1 = agri_income_16
replace agri_income_16_1 = agri_income_16_99 if agri_income_16_1 > agri_income_16_99 
replace agri_income_16_1 = . if agri_income_16 == . 

gen agri_income_16_5 = agri_income_16
replace agri_income_16_5 = agri_income_16_95 if agri_income_16_5 > agri_income_16_95 
replace agri_income_16_5 = . if agri_income_16 == . 

gen agri_income_16_10 = agri_income_16
replace agri_income_16_10 = agri_income_16_90 if agri_income_16_10 > agri_income_16_90 
replace agri_income_16_10 = . if agri_income_16 == . 

egen agri_income_19_99 = pctile(agri_income_19), p(99)
egen agri_income_19_95 = pctile(agri_income_19), p(95)
egen agri_income_19_90 = pctile(agri_income_19), p(90) 

gen agri_income_19_1 = agri_income_19
replace agri_income_19_1 = agri_income_19_99 if agri_income_19_1 > agri_income_19_99 
replace agri_income_19_1 = . if agri_income_19 == . 

gen agri_income_19_5 = agri_income_19
replace agri_income_19_5 = agri_income_19_95 if agri_income_19_5 > agri_income_19_95 
replace agri_income_19_5 = . if agri_income_19 == . 

gen agri_income_19_10 = agri_income_19
replace agri_income_19_10 = agri_income_19_90 if agri_income_19_10 > agri_income_19_90 
replace agri_income_19_10 = . if agri_income_19 == . 

egen agri_income_33_99 = pctile(agri_income_33), p(99)
egen agri_income_33_95 = pctile(agri_income_33), p(95)
egen agri_income_33_90 = pctile(agri_income_33), p(90) 

gen agri_income_33_1 = agri_income_33
replace agri_income_33_1 = agri_income_33_99 if agri_income_33_1 > agri_income_33_99 
replace agri_income_33_1 = . if agri_income_33 == . 

gen agri_income_33_5 = agri_income_33
replace agri_income_33_5 = agri_income_33_95 if agri_income_33_5 > agri_income_33_95 
replace agri_income_33_5 = . if agri_income_33 == . 

gen agri_income_33_10 = agri_income_33
replace agri_income_33_10 = agri_income_33_90 if agri_income_33_10 > agri_income_33_90 
replace agri_income_33_10 = . if agri_income_33 == . 

*** keep just winsorized variables to pull together everything from this module at the end *** 
keep hhid agri_income_16_1 agri_income_16_5 agri_income_16_10 agri_income_19_1 agri_income_19_5 agri_income_19_10 agri_income_33_1 agri_income_33_5 agri_income_33_10  

save "$winsorized\income_16_19_33.dta", replace 

*** winsorized agri_income_36 *** 
use "$data_deidentified\Complete_Baseline_Income", clear   

*** keep data for winsorize information *** 
keep hhid agri_income_36_*  

reshape long agri_income_36_, i(hhid) j(individual)

*** winsorize variables *** 
egen agri_income_36_99 = pctile(agri_income_36_), p(99)
egen agri_income_36_95 = pctile(agri_income_36_), p(95)
egen agri_income_36_90 = pctile(agri_income_36_), p(90) 

gen agri_income_36_1_ = agri_income_36_
replace agri_income_36_1_ = agri_income_36_99 if agri_income_36_1_ > agri_income_36_99 
replace agri_income_36_1_ = . if agri_income_36_ == . 

gen agri_income_36_5_ = agri_income_36_
replace agri_income_36_5_ = agri_income_36_95 if agri_income_36_5_ > agri_income_36_95 
replace agri_income_36_5_ = . if agri_income_36_ == . 

gen agri_income_36_10_ = agri_income_36_
replace agri_income_36_10_ = agri_income_36_90 if agri_income_36_10_ > agri_income_36_90 
replace agri_income_36_10_ = . if agri_income_36_ == . 

*** keep winsorized variables to reshape and save for merge back together *** 
keep hhid individual agri_income_36_ agri_income_36_1_ agri_income_36_5_ agri_income_36_10_

reshape wide agri_income_36_ agri_income_36_1_ agri_income_36_5_ agri_income_36_10_, i(hhid) j(individual)

save "$winsorized\income_36.dta", replace 

*** winsorized agri_income_36 *** 
use "$data_deidentified\Complete_Baseline_Income", clear   

*** keep data for winsorize information *** 
keep hhid agri_income_41_*  

reshape long agri_income_41_, i(hhid) j(individual)

*** winsorize variables *** 
egen agri_income_41_99 = pctile(agri_income_41_), p(99)
egen agri_income_41_95 = pctile(agri_income_41_), p(95)
egen agri_income_41_90 = pctile(agri_income_41_), p(90) 

gen agri_income_41_1_ = agri_income_41_
replace agri_income_41_1_ = agri_income_41_99 if agri_income_41_1_ > agri_income_41_99 
replace agri_income_41_1_ = . if agri_income_41_ == . 

gen agri_income_41_5_ = agri_income_41_
replace agri_income_41_5_ = agri_income_41_95 if agri_income_41_5_ > agri_income_41_95 
replace agri_income_41_5_ = . if agri_income_41_ == . 

gen agri_income_41_10_ = agri_income_41_
replace agri_income_41_10_ = agri_income_41_90 if agri_income_41_10_ > agri_income_41_90 
replace agri_income_41_10_ = . if agri_income_41_ == . 

*** keep winsorized variables to reshape and save for merge back together *** 
keep hhid individual agri_income_41_ agri_income_41_1_ agri_income_41_5_ agri_income_41_10_

reshape wide agri_income_41_ agri_income_41_1_ agri_income_41_5_ agri_income_41_10_, i(hhid) j(individual)

*** winsorized agri_income_36 *** 
use "$data_deidentified\Complete_Baseline_Income", clear   

*** keep data for winsorize information *** 
keep hhid agri_income_36_*  

reshape long agri_income_36_, i(hhid) j(individual)

*** winsorize variables *** 
egen agri_income_36_99 = pctile(agri_income_36_), p(99)
egen agri_income_36_95 = pctile(agri_income_36_), p(95)
egen agri_income_36_90 = pctile(agri_income_36_), p(90) 

gen agri_income_36_1_ = agri_income_36_
replace agri_income_36_1_ = agri_income_36_99 if agri_income_36_1_ > agri_income_36_99 
replace agri_income_36_1_ = . if agri_income_36_ == . 

gen agri_income_36_5_ = agri_income_36_
replace agri_income_36_5_ = agri_income_36_95 if agri_income_36_5_ > agri_income_36_95 
replace agri_income_36_5_ = . if agri_income_36_ == . 

gen agri_income_36_10_ = agri_income_36_
replace agri_income_36_10_ = agri_income_36_90 if agri_income_36_10_ > agri_income_36_90 
replace agri_income_36_10_ = . if agri_income_36_ == . 

*** keep winsorized variables to reshape and save for merge back together *** 
keep hhid individual agri_income_36_ agri_income_36_1_ agri_income_36_5_ agri_income_36_10_

reshape wide agri_income_36_ agri_income_36_1_ agri_income_36_5_ agri_income_36_10_, i(hhid) j(individual)

save "$winsorized\income_41.dta", replace 

*** merge together winsorized data *** 
use "$data_deidentified\Complete_Baseline_Income", clear   

merge 1:1 hhid using "$winsorized\income_16_19_33.dta"

drop _merge 

merge 1:1 hhid using "$winsorized\income_36.dta"

drop _merge 

merge 1:1 hhid using "$winsorized\income_41.dta"

drop _merge 

save "$winsorized\Baseline_Income.dta", replace 

*/