*** Data cleaning for shadow wage estimation *** 
*** File Created By: Molly Doruska ***
*** File Last Updated By: Molly Doruska ***
*** File Last Updated On: April 21, 2025 ***

clear all 

set maxvar 20000

**** Master file path  ****
if "`c(username)'"=="socrm" {
                global master "C:\Users\socrm\Box\NSF Senegal\Data_Management"
}
else if "`c(username)'"=="kls329" {
                global master "/Users/kls329\Box\NSF Senegal\Data_Management"
}
else if "`c(username)'"=="km978" {
                global master "C:\Users\km978\Box\NSF Senegal\Data_Management"
}
else if "`c(username)'"=="Kateri" {
                global master "C:\Users\Kateri\Box\NSF Senegal\Data_Management"
}

*** additional file paths ***
global data "$master\Data\_CRDES_CleanData\Baseline\Deidentified"
global auctions "$master\Output\Analysis\Auctions_Shadow_Wages"

*** clean variables to use in shadow wage estimation *** 
*** clean basic household roster data *** 

*** import household roster data *** 
use "$data\Complete_Baseline_Household_Roster", clear   

*** keep only needed data and reshape to long *** 
keep hhid hhid_village hh_01_* hh_02_* hh_03_* hh_04_* hh_05_* hh_06_* hh_07_* hh_08_* hh_09_* hh_10_* hh_14_* hh_15_* hh_16_* hh_17_* hh_18_* hh_22_* hh_23_* hh_24_* hh_25_* hh_gender_* hh_age_* hh_education_level_* hh_relation_with_* 

drop hh_age_resp hh_gender_resp 

forvalues i = 1/55 {
    drop hh_23_`i'
	tostring hh_relation_with_o_`i', replace 
	tostring hh_education_level_o_`i', replace 
	tostring hh_15_o_`i', replace 
	tostring hh_23_o_`i', replace 
}

reshape long hh_gender_ hh_age_ hh_relation_with_ hh_relation_with_o_ hh_education_level_ hh_education_level_o_ hh_01_ hh_02_ hh_03_ hh_04_ hh_05_ hh_06_ hh_07_ hh_08_ hh_09_ hh_10_ hh_14_ hh_15_ hh_15_o_ hh_16_ hh_17_ hh_18_ hh_22_ hh_23_1_ hh_23_2_ hh_23_3_ hh_23_4_ hh_23_5_ hh_23_99_ hh_23_o_ hh_24_ hh_25_, i(hhid hhid_village) j(person)

drop if hh_gender_ == . 

*** create indicator variables ***
gen female = (hh_gender_ == 2)
gen household_head = (hh_relation_with_ == 1)
gen spouse = (hh_relation_with_ == 2)
gen no_education = (hh_education_level_ == 0)
gen primary_education = (hh_education_level_ == 1)
gen secondary_education = (hh_education_level_ == 2)
gen tertiary_education = (hh_education_level_ == 3)
gen technical_education = (hh_education_level_ == 4)
gen other_education = (hh_education_level_ == 99)
gen sell_veg_12mo = (hh_15_ == 1)
gen fertilizer_veg_12mo = (hh_15_ == 2)
gen livestock_veg_12mo = (hh_15_ == 3)
gen biodigest_veg_12mo = (hh_15_ == 4)
gen nothing_veg_12mo = (hh_15_ == 5)
gen other_veg_12mo = (hh_15_ == 99)

*** code don't knows as missing ***
replace hh_03_ = . if hh_03_ == 2 
replace hh_05_ = . if hh_05_ == -9
replace hh_06_ = . if hh_06_ == -9 
replace hh_07_ = . if hh_07_ == -9

*** count household labor hours totals and per capita *** 
collapse (sum) chore_hours = hh_01_ (sum) water_hours = hh_02_ (sum) ag_hours = hh_04_ (sum) planting_hours = hh_05_ (sum) growth_hours = hh_06_ (sum) harvest_hours = hh_07_ (sum) tradehh_hours = hh_08_ (sum) tradeoutside_hours = hh_09_ (sum) water_hours_12mo = hh_10_ (sum) veg_collected_12mo = hh_14_ (sum) fertilizer_hours_12mo = hh_16_ (sum) feed_hours_12mo = hh_17_ (sum) water_hours_7days = hh_18_ (sum) veg_collected_7days = hh_22_ (sum) fertilizer_hours_7days = hh_24_ (sum) feed_hours_7days = hh_25_ (count) members = hh_gender_ (mean) female household_head spouse no_education primary_education secondary_education tertiary_education technical_education other_education sell_veg_12mo fertilizer_veg_12mo biodigest_veg_12mo nothing_veg_12mo other_veg_12mo hh_01_ hh_02_ hh_03_ hh_04_ hh_05_ hh_06_ hh_07_ hh_08_ hh_09_ hh_10_ hh_14_ hh_16_ hh_17_ hh_18_ hh_22_ hh_23_1_ hh_23_2_ hh_23_3_ hh_23_4_ hh_23_5_ hh_23_99_ hh_24_ hh_25_ , by(hhid)

*** calculate per capita measures *** 
gen chore_hours_pc = chore_hours / members 
gen water_hours_pc = water_hours / members 
gen ag_hours_pc = ag_hours / members
gen planting_hours_pc = planting_hours / members
gen growth_hours_pc = growth_hours / members
gen harvest_hours_pc = harvest_hours / members
gen tradehh_hours_pc = tradehh_hours / members
gen tradeoutside_hours_pc = tradeoutside_hours / members
gen water_hours_12mo_pc = chore_hours / members     
gen fertilizer_hours_12mo_pc = chore_hours / members  
gen feed_hours_12mo_pc = chore_hours / members  
gen water_hours_7days_pc = chore_hours / members     
gen fertilizer_hours_7days_pc = chore_hours / members  
gen feed_hours_7days_pc = chore_hours / members

*** save cleaned main household roster data set ***
save "$auctions\main_hh_baseline.dta", replace 
  
*** clean hh_12 (12 month recall) on water time use data *** 

*** import household roster data *** 
use "$data\Complete_Baseline_Household_Roster", clear   

*** keep 12 month recall time in water data *** 
keep hhid hh_12index* hh_13_*

drop hh_13_sum_*

*** change indexs to have last number be person *** 
forvalues i = 1/55 {
    rename hh_12index_`i'_7 hh_12index7_`i'
	rename hh_13_`i'_7 hh_137_`i'
	rename hh_12index_`i'_6 hh_12index6_`i'
	rename hh_13_`i'_6 hh_136_`i'
	rename hh_12index_`i'_5 hh_12index5_`i'
	rename hh_13_`i'_5 hh_135_`i'
	rename hh_12index_`i'_4 hh_12index4_`i'
	rename hh_13_`i'_4 hh_134_`i'
	rename hh_12index_`i'_3 hh_12index3_`i'
	rename hh_13_`i'_3 hh_133_`i'
	rename hh_12index_`i'_2 hh_12index2_`i'
	rename hh_13_`i'_2 hh_132_`i'
	rename hh_12index_`i'_1 hh_12index1_`i'
	rename hh_13_`i'_1 hh_131_`i'	
}

*** reshape to activity level ***
reshape long hh_12index1_ hh_131_ hh_12index2_ hh_132_ hh_12index3_ hh_133_ hh_12index4_ hh_134_ hh_12index5_ hh_135_ hh_12index6_ hh_136_ hh_12index7_ hh_137_, i(hhid) j(activity)
*** clean 