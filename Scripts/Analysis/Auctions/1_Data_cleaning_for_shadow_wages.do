*** Data cleaning for shadow wage estimation *** 
*** File Created By: Molly Doruska ***
*** File Last Updated By: Molly Doruska ***
*** File Last Updated On: April 22, 2025 ***

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
  
*** clean hh_13 (12 month recall) on water time use data *** 

*** import household roster data *** 
use "$data\Complete_Baseline_Household_Roster", clear   

*** keep 12 month recall time in water data *** 
keep hhid hh_12index* hh_13_*

drop hh_13_sum_* hh_13_o_*

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

*** reshape to individual level ***
reshape long hh_12index1_ hh_131_ hh_12index2_ hh_132_ hh_12index3_ hh_133_ hh_12index4_ hh_134_ hh_12index5_ hh_135_ hh_12index6_ hh_136_ hh_12index7_ hh_137_, i(hhid) j(person)

*** drop extra people *** 
drop if hh_12index1_ == . & hh_131_ == . 

*** rename variables to get to activity level data *** 
forvalues i = 1/7{
    rename hh_12index`i'_ hh_12_index_`i' 
	rename hh_13`i'_ hh_13_`i' 
}

*** reshape to person level *** 
reshape long hh_12_index_ hh_13_, i(hhid person) j(activity)

drop if hh_12_index == . & hh_13_ == . 

*** calculate total household hours spent doing agriculture tasks in the water *** 
egen fetch_water_hh_12mo_act = total(hh_13_) if hh_12_index_ == 1, by(hhid)
replace fetch_water_hh_12mo_act = 0 if fetch_water_hh_12mo_act == . 

egen water_livestock_12mo_act = total(hh_13_) if hh_12_index_ == 2, by(hhid)
replace water_livestock_12mo_act = 0 if water_livestock_12mo_act == . 

egen fetch_water_ag_12mo_act = total(hh_13_) if hh_12_index_ == 3, by(hhid)
replace fetch_water_ag_12mo_act = 0 if fetch_water_ag_12mo_act == . 

egen wash_clothes_12mo_act = total(hh_13_) if hh_12_index_ == 4, by(hhid)
replace wash_clothes_12mo_act = 0 if wash_clothes_12mo_act == . 

egen dishes_12mo_act = total(hh_13_) if hh_12_index_ == 5, by(hhid)
replace dishes_12mo_act = 0 if dishes_12mo_act == .

egen harvest_veg_12mo_act = total(hh_13_) if hh_12_index_ == 6, by(hhid)
replace harvest_veg_12mo_act = 0 if harvest_veg_12mo_act == .  

egen swim_12mo_act = total(hh_13_) if hh_12_index_ == 7, by(hhid)
replace swim_12mo_act = 0 if swim_12mo_act == . 

egen play_12mo_act = total(hh_13_) if hh_12_index_ == 8, by(hhid)
replace play_12mo_act = 0 if play_12mo_act == . 

collapse (max) fetch_water_hh_12mo_act water_livestock_12mo_act fetch_water_ag_12mo_act wash_clothes_12mo_act dishes_12mo_act harvest_veg_12mo_act swim_12mo_act play_12mo_act, by(hhid)

*** save dataset *** 
save "$auctions\water_time_12month.dta", replace 

*** clean hh_21 (7 day recall) on water time use data *** 

*** import household roster data *** 
use "$data\Complete_Baseline_Household_Roster", clear   

*** keep 7 day recall time in water data *** 
keep hhid hh_20index* hh_21_*

drop hh_21_sum_* hh_21_o_*

*** change indexs to have last number be person *** 
forvalues i = 1/55 {
    rename hh_20index_`i'_7 hh_20index7_`i'
	rename hh_21_`i'_7 hh_217_`i'
	rename hh_20index_`i'_6 hh_20index6_`i'
	rename hh_21_`i'_6 hh_216_`i'
	rename hh_20index_`i'_5 hh_20index5_`i'
	rename hh_21_`i'_5 hh_215_`i'
	rename hh_20index_`i'_4 hh_20index4_`i'
	rename hh_21_`i'_4 hh_214_`i'
	rename hh_20index_`i'_3 hh_20index3_`i'
	rename hh_21_`i'_3 hh_213_`i'
	rename hh_20index_`i'_2 hh_20index2_`i'
	rename hh_21_`i'_2 hh_212_`i'
	rename hh_20index_`i'_1 hh_20index1_`i'
	rename hh_21_`i'_1 hh_211_`i'	
}

*** reshape to individual level ***
reshape long hh_20index1_ hh_211_ hh_20index2_ hh_212_ hh_20index3_ hh_213_ hh_20index4_ hh_214_ hh_20index5_ hh_215_ hh_20index6_ hh_216_ hh_20index7_ hh_217_, i(hhid) j(person)

*** drop extra people *** 
drop if hh_20index1_ == . & hh_211_ == . 

*** rename variables to get to activity level data *** 
forvalues i = 1/7{
    rename hh_20index`i'_ hh_20_index_`i' 
	rename hh_21`i'_ hh_21_`i' 
}

*** reshape to person level *** 
reshape long hh_20_index_ hh_21_, i(hhid person) j(activity)

drop if hh_20_index == . & hh_21_ == . 

*** calculate total household hours spent doing agriculture tasks in the water *** 
egen fetch_water_hh_7d_act = total(hh_21_) if hh_20_index_ == 1, by(hhid)
replace fetch_water_hh_7d_act = 0 if fetch_water_hh_7d_act == . 

egen water_livestock_7d_act = total(hh_21_) if hh_20_index_ == 2, by(hhid)
replace water_livestock_7d_act = 0 if water_livestock_7d_act == . 

egen fetch_water_ag_7d_act = total(hh_21_) if hh_20_index_ == 3, by(hhid)
replace fetch_water_ag_7d_act = 0 if fetch_water_ag_7d_act == . 

egen wash_clothes_7d_act = total(hh_21_) if hh_20_index_ == 4, by(hhid)
replace wash_clothes_7d_act = 0 if wash_clothes_7d_act == . 

egen dishes_7d_act = total(hh_21_) if hh_20_index_ == 5, by(hhid)
replace dishes_7d_act = 0 if dishes_7d_act == .

egen harvest_veg_7d_act = total(hh_21_) if hh_20_index_ == 6, by(hhid)
replace harvest_veg_7d_act = 0 if harvest_veg_7d_act == .  

egen swim_7d_act = total(hh_21_) if hh_20_index_ == 7, by(hhid)
replace swim_7d_act = 0 if swim_7d_act == . 

egen play_7d_act = total(hh_21_) if hh_20_index_ == 8, by(hhid)
replace play_7d_act = 0 if play_7d_act == . 

collapse (max) fetch_water_hh_7d_act water_livestock_7d_act fetch_water_ag_7d_act wash_clothes_7d_act dishes_7d_act harvest_veg_7d_act swim_7d_act play_7d_act, by(hhid)

*** save dataset *** 
save "$auctions\water_time_7days.dta", replace 