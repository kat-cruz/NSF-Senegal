*** Data cleaning for shadow wage estimation *** 
*** File Created By: Molly Doruska ***
*** File Last Updated By: Molly Doruska ***
*** File Last Updated On: June 11, 2025 ***

clear all 

set maxvar 20000

**** Master file path  ****
if "`c(username)'"=="mollydoruska" {
                global master "/Users/mollydoruska/Library/CloudStorage/Box-Box/NSF Senegal/Data_Management"
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
global data "$master/Data/_CRDES_CleanData/Baseline/Deidentified"
global auctions "$master/Output/Analysis/Auctions_Shadow_Wages"
global midline "$master/Data/_CRDES_CleanData/Midline/Deidentified"
global asset_index "$master/Output/Data_Processing/Construction"

*** clean variables to use in shadow wage estimation *** 
*** clean basic household roster data *** 
*** baseline data *** 

*** import household roster data *** 
use "$data/Complete_Baseline_Household_Roster", clear   

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

*** count children *** 
gen child = (hh_age_ < 18)

*** count household labor hours totals and per capita *** 
collapse (sum) chore_hours = hh_01_ (sum) water_hours = hh_02_ (sum) ag_hours = hh_04_ (sum) planting_hours = hh_05_ (sum) growth_hours = hh_06_ (sum) harvest_hours = hh_07_ (sum) tradehh_hours = hh_08_ (sum) tradeoutside_hours = hh_09_ (sum) water_hours_12mo = hh_10_ (sum) veg_collected_12mo = hh_14_ (sum) fertilizer_hours_12mo = hh_16_ (sum) feed_hours_12mo = hh_17_ (sum) water_hours_7days = hh_18_ (sum) veg_collected_7days = hh_22_ (sum) fertilizer_hours_7days = hh_24_ (sum) feed_hours_7days = hh_25_ (count) members = hh_gender_ (mean) female household_head spouse no_education primary_education secondary_education tertiary_education technical_education other_education sell_veg_12mo fertilizer_veg_12mo biodigest_veg_12mo nothing_veg_12mo other_veg_12mo hh_01_ hh_02_ hh_03_ hh_04_ hh_05_ hh_06_ hh_07_ hh_08_ hh_09_ hh_10_ hh_14_ hh_16_ hh_17_ hh_18_ hh_22_ hh_23_1_ hh_23_2_ hh_23_3_ hh_23_4_ hh_23_5_ hh_23_99_ hh_24_ hh_25_ (sum) child, by(hhid)

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
tempfile main_hh_baseline 
save `main_hh_baseline'

*** clean household head variables - education, gender, age *** 
use "$data/Complete_Baseline_Household_Roster", clear   

*** keep only needed data and reshape to long *** 
keep hhid hhid_village hh_gender_* hh_age_* hh_education_level_* 

drop hh_age_resp hh_gender_resp hh_education_level_o_* 

*** bring in household head index data *** 
merge 1:1 hhid using "$data/household_head_index"

drop _merge 

reshape long hh_gender_ hh_age_ hh_education_level_ , i(hhid hhid_village) j(person)

drop if hh_gender_ == . 

*** keep only the household head *** 
keep if person == hh_head_index 

*** create indicator variables ***
gen hhhead_female = (hh_gender_ == 2)
gen hhhead_no_education = (hh_education_level_ == 0)
gen hhhead_primary_education = (hh_education_level_ == 1)
gen hhhead_secondary_education = (hh_education_level_ == 2)
gen hhhead_tertiary_education = (hh_education_level_ == 3)
gen hhhead_technical_education = (hh_education_level_ == 4)
gen hhhaed_other_education = (hh_education_level_ == 99)

rename hh_age_ hhhead_age 

*** keep cleaned household head variables *** 
keep hhid hhhead* 

tempfile hhhead_baseline 
save `hhhead_baseline'

*** clean hh_13 (12 month recall) on water time use data *** 

*** import household roster data *** 
use "$data/Complete_Baseline_Household_Roster", clear   

*** keep 12 month recall time in water data *** 
keep hhid hh_10* hh_12index* hh_13_*

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
reshape long hh_10_ hh_12index1_ hh_131_ hh_12index2_ hh_132_ hh_12index3_ hh_133_ hh_12index4_ hh_134_ hh_12index5_ hh_135_ hh_12index6_ hh_136_ hh_12index7_ hh_137_, i(hhid) j(person)

*** drop extra people *** 
drop if hh_10_ == . 

*** rename variables to get to activity level data *** 
forvalues i = 1/7{
    rename hh_12index`i'_ hh_12_index_`i' 
	rename hh_13`i'_ hh_13_`i' 
}

*** reshape to person level *** 
reshape long hh_12_index_ hh_13_, i(hhid person) j(activity)

replace hh_13_ = 0 if hh_10_ == 0 

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
tempfile water_time_12month
save `water_time_12month'

*** clean hh_21 (7 day recall) on water time use data *** 

*** import household roster data *** 
use "$data/Complete_Baseline_Household_Roster", clear   

*** keep 7 day recall time in water data *** 
keep hhid hh_18* hh_20index* hh_21_*

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
reshape long hh_18_ hh_20index1_ hh_211_ hh_20index2_ hh_212_ hh_20index3_ hh_213_ hh_20index4_ hh_214_ hh_20index5_ hh_215_ hh_20index6_ hh_216_ hh_20index7_ hh_217_, i(hhid) j(person)

*** drop extra people *** 
drop if hh_18_ == . 

*** rename variables to get to activity level data *** 
forvalues i = 1/7{
    rename hh_20index`i'_ hh_20_index_`i' 
	rename hh_21`i'_ hh_21_`i' 
}

*** reshape to person level *** 
reshape long hh_20_index_ hh_21_, i(hhid person) j(activity)

replace hh_21_ = 0 if hh_18_ == 0 

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
tempfile water_time_7days 
save `water_time_7days'

*** calculate above age 15 slack labor hours *** 
*** import household roster data *** 
use "$data/Complete_Baseline_Household_Roster", clear   

*** keep 7 day recall time use variables and age variable *** 
keep hhid hh_age_* hh_01_* hh_02_* hh_04_* hh_08_* hh_09_* hh_18_* 

drop hh_age_resp

*** reshape to long *** 
reshape long hh_age_ hh_01_ hh_02_ hh_04_ hh_08_ hh_09_ hh_18_ , i(hhid) j(person)

drop if hh_01_ == . 

*** drop if under 15 *** 
drop if hh_age_ < 15

*** calculate total weekly labor hours *** 
egen weekly_hrs = rowtotal(hh_01_ hh_02_ hh_04_ hh_08_ hh_09_ hh_18_)

*** declare slack hours as any hours less than 80 hours per week *** 
gen slack_hours = 80 - weekly_hrs 
replace slack_hours = 0 if slack_hours < 0 

*** calculate total number of slack labor hours per household ***
collapse (sum) slack_hours, by(hhid)

tempfile slackhours 
save `slackhours'

*** import agricultural plot level data *** 
use "$data/Complete_Baseline_Agriculture", clear   

*** keep key variables to reshape to the plot level *** 
keep hhid agri_6_18_* agri_6_20_* agri_6_21_* agri_6_22_* agri_6_30_* agri_6_31_* agri_6_34_comp_* agri_6_34_* agri_6_35_* agri_6_36_* agri_6_37_* agri_6_38_a_* agri_6_38_a_code_* agri_6_39_a_* agri_6_39_a_code_* agri_6_40_a_* agri_6_40_a_code_* agri_6_41_a_* agri_6_41_a_code_*   

forvalue i = 1/11 {
	tostring agri_6_20_o_`i', replace 
	tostring agri_6_31_o_`i', replace
	tostring agri_6_38_a_code_o_`i', replace
	tostring agri_6_39_a_code_o_`i', replace
	tostring agri_6_40_a_code_o_`i', replace
	tostring agri_6_41_a_code_o_`i', replace
}
 
*** reshape data to long, plot level data ***
reshape long agri_6_18_ agri_6_20_ agri_6_20_o_ agri_6_21_ agri_6_22_ agri_6_30_ agri_6_31_ agri_6_31_o_ agri_6_34_comp_ agri_6_34_ agri_6_35_ agri_6_36_ agri_6_37_ agri_6_38_a_ agri_6_38_a_code_ agri_6_38_a_code_o_ agri_6_39_a_ agri_6_39_a_code_ agri_6_39_a_code_o_ agri_6_40_a_ agri_6_40_a_code_ agri_6_40_a_code_o_ agri_6_41_a_ agri_6_41_a_code_ agri_6_41_a_code_o_, i(hhid) j(plot)

drop if agri_6_18_ == . 

*** create single unit variables for land, application amounts  *** 
gen plot_size_ha = agri_6_21_ 
replace plot_size_ha = agri_6_21_ / 1000 if agri_6_22_ == 2 

gen urea_kgs = agri_6_38_a_ 
replace urea_kgs = agri_6_38_a_ * 1000 if agri_6_38_a_code_ == 2 
replace urea_kgs = agri_6_38_a_ * 50 if agri_6_38_a_code_ == 3 
replace urea_kgs = . if agri_6_38_a_code_ == 99 

gen phosphate_kgs = agri_6_39_a_ 
replace phosphate_kgs = agri_6_39_a_ * 1000 if agri_6_39_a_code_ == 2 
replace phosphate_kgs = agri_6_39_a_ * 50 if agri_6_39_a_code_ == 3 

gen npk_kgs = agri_6_40_a_ 
replace npk_kgs = agri_6_40_a_ * 1000 if agri_6_40_a_code_ == 2 
replace npk_kgs = agri_6_40_a_ * 50 if agri_6_40_a_code_ == 3 
replace npk_kgs = . if agri_6_40_a_code_ == 99 

gen other_kgs = agri_6_41_a_ 
replace other_kgs = agri_6_41_a_ * 1000 if agri_6_41_a_code_ == 2 
replace other_kgs = agri_6_41_a_ * 50 if agri_6_41_a_code_ == 3 
replace other_kgs = . if agri_6_41_a_code_ == 99 

*** get rid of don't knows *** 
replace agri_6_30_ = . if agri_6_30_ == 2
replace agri_6_34_comp_ = . if agri_6_34_comp_ == 2
replace agri_6_34_ = . if agri_6_34_ == 2
replace agri_6_36_ = . if agri_6_36_ == 2

*** create indicator variables for crop types ***
gen collective_manage = (agri_6_18_ == 2) 
gen rice = (agri_6_20_ == 1)
gen maize = (agri_6_20_ == 2)
gen millet = (agri_6_20_ == 3)
gen sorghum = (agri_6_20_ == 4)
gen cowpea = (agri_6_20_ == 5)
gen cassava = (agri_6_20_ == 6)
gen sweetpotato = (agri_6_20_ == 7)
gen potato = (agri_6_20_ == 8)
gen yam = (agri_6_20_ == 9)
gen taro = (agri_6_20_ == 10)
gen tomato = (agri_6_20_ == 11)
gen carrot = (agri_6_20_ == 12)
gen onion = (agri_6_20_ == 13)
gen cucumber = (agri_6_20_ == 14)
gen pepper = (agri_6_20_ == 15)
replace pepper = 1 if agri_6_20_o == "PIMENT"
replace pepper = 1 if agri_6_20_o == "PIMENTS"
replace pepper = 1 if agri_6_20_o == "Piment"
gen peanut = (agri_6_20_ == 16)
replace peanut = 1 if agri_6_20_o == "ARACHIDES"
gen bean = (agri_6_20_ == 17)
gen pea = (agri_6_20_ == 18)
gen other = (agri_6_20_ == 99)
replace other = 0 if agri_6_20_o == "ARACHIDES"
replace other = 0 if agri_6_20_o == "PIMENT"
replace other = 0 if agri_6_20_o == "PIMENTS"
replace other = 0 if agri_6_20_o == "Piment"

gen manure_direct_parking = (agri_6_31_ == 1)
gen manure_indirect_parking = (agri_6_31_ == 2)
gen manure_purchase = (agri_6_31_ == 3)
gen manure_other_source = (agri_6_31_ == 99)

gen crop_types = rice + maize + millet + sorghum + cowpea + cassava + sweetpotato + potato + yam + taro + tomato + carrot + onion + cucumber + pepper + peanut + bean + pea + other

*** collapse to household level *** 
collapse (sum) plot_size_ha (sum) urea_kgs (sum) phosphate_kgs (sum) npk_kgs (sum) other_kgs (sum) agri_6_30_ (sum) agri_6_34_comp_ (sum) agri_6_34_ (sum) agri_6_36_ (sum) rice (sum) collective_manage (sum) crop_types, by(hhid)

*** save clean plot level data *** 
tempfile plot_level_ag
save `plot_level_ag'

*** clean agriculture equipment data *** 

*** import agricultural plot level data *** 
use "$data/Complete_Baseline_Agriculture", clear   

*** keep variables related to agricultural equipment *** 
keep hhid agriindex_* _agri_number_* 

*** reshape to long *** 
reshape long agriindex_ _agri_number_ , i(hhid) j(equip)

drop if agriindex_ == . & _agri_number_ == . 

*** create count of each equipment type at the household level *** 
gen plow = _agri_number_ if agriindex_ == 1 
gen harrow = _agri_number_ if agriindex_ == 2  
gen draftanimals = _agri_number_ if agriindex_ == 3  
gen cart = _agri_number_ if agriindex_ == 4 
gen tractor = _agri_number_ if agriindex_ == 5 
gen sprayer = _agri_number_ if agriindex_ == 6 
gen motorpumps = _agri_number_ if agriindex_ == 7 
gen hoes = _agri_number_ if agriindex_ == 8 
gen ridger = _agri_number_ if agriindex_ == 9 
gen sickle = _agri_number_ if agriindex_ == 10 
gen seeder = _agri_number_ if agriindex_ == 11 
gen kadiandou = _agri_number_ if agriindex_ == 12 
gen fanting = _agri_number_ if agriindex_ == 13 
gen other = _agri_number_ if agriindex_ == 14 

collapse plow harrow draftanimals cart tractor sprayer motorpumps hoes ridger sickle seeder kadiandou fanting other, by(hhid)
 
replace plow = 0 if plow == .
replace harrow = 0 if harrow == .
replace draftanimals = 0 if draftanimals == .
replace cart = 0 if cart == . 
replace tractor = 0 if tractor == . 
replace sprayer = 0 if sprayer == . 
replace motorpumps = 0 if motorpumps == . 
replace hoes = 0 if hoes == . 
replace ridger = 0 if ridger == . 
replace sickle = 0 if sickle == . 
replace seeder = 0 if seeder == . 
replace kadiandou = 0 if kadiandou == . 
replace fanting = 0 if fanting == . 
replace other = 0 if other == . 
 
tempfile assets 
save `assets' 

*** clean non-standard unit data on compost use *** 

*** import agricultural plot level data *** 
use "$data/Complete_Baseline_Agriculture", clear   

keep hhid agri_6_32_* agri_6_33_*

reshape long agri_6_32_ agri_6_33_ agri_6_33_o_ , i(hhid) j(plot)

drop if agri_6_32_ == . & agri_6_33_ == . & agri_6_33_o_ == . 

*** extract off village ID to pull in non-standard unit measures *** 
gen hhid_village = substr(hhid, 1, 4)

*** merge in non-standard unit measures ***
merge m:1 hhid_village using "$midline/Complete_Midline_Community.dta"

drop if _merge == 2 

drop _merge 

*** calculate manure use in kgs *** 
gen manure_kgs = agri_6_32_ 
replace manure_kgs = agri_6_32 * unit_convert_1 if agri_6_33_ == 2 
replace manure_kgs = agri_6_32 * unit_convert_2 if agri_6_33_ == 3 

keep hhid plot manure_kgs 

collapse (sum) manure_kgs, by(hhid)

tempfile manure_use 
save `manure_use'

*** clean number of plots data *** 

*** import agricultural plot level data *** 
use "$data/Complete_Baseline_Agriculture", clear   

keep hhid agri_6_14 agri_6_15

replace agri_6_14 = . if agri_6_14 == 2 

replace agri_6_15 = 0 if agri_6_14 == 0

tempfile number_of_plots 
save `number_of_plots'

*** clean production data *** 
use "$data/Complete_Baseline_Production.dta", clear   

rename cereals_01_1 rice_hectares 
replace rice_hectares = 0 if cereals_consumption_1 == 0 
replace rice_hectares = . if rice_hectares == -9 

rename cereals_02_1 rice_prod 
replace rice_prod = 0 if cereals_consumption_1 == 0 
replace rice_prod = . if rice_prod == -9

gen maize_hectares = cereals_01_2 
replace maize_hectares = 0 if cereals_consumption_2 == 0
replace maize_hectares = . if cerealsposition_2 == 3
replace maize_hectares = . if maize_hectares == -9 

gen maize_prod = cereals_02_2 
replace maize_prod = 0 if cereals_consumption_2 == 0 
replace maize_prod = . if cerealsposition_2 == 3 
replace maize_prod = . if maize_prod == -9 

gen millet_hectares = cereals_01_3 
replace millet_hectares = 0 if cereals_consumption_3 == 0
replace millet_hectares = cereals_01_2 if cerealsposition_2 == 3
replace millet_hectares = . if millet_hectares == -9 

gen millet_prod = cereals_02_3 
replace millet_prod = 0 if cereals_consumption_3 == 0 
replace millet_prod = cereals_02_2 if cerealsposition_2 == 3 
replace millet_prod = . if millet_prod == -9

gen sorghum_hectares = cereals_01_4 
replace sorghum_hectares = 0 if cereals_consumption_4 == 0
replace sorghum_hectares = cereals_01_3 if cerealsposition_3 == 4
replace sorghum_hectares = . if sorghum_hectares == -9 

gen sorghum_prod = cereals_02_4 
replace sorghum_prod = 0 if cereals_consumption_3 == 0 
replace sorghum_prod = cereals_02_3 if cerealsposition_3 == 4 
replace sorghum_prod = . if sorghum_prod == -9 

gen cowpea_hectares = cereals_01_5 
replace cowpea_hectares = 0 if cereals_consumption_4 == 0
replace cowpea_hectares = cereals_01_4 if cerealsposition_4 == 5
replace cowpea_hectares = . if cowpea_hectares == -9 

gen cowpea_prod = cereals_02_5 
replace cowpea_prod = 0 if cereals_consumption_4 == 0 
replace cowpea_prod = cereals_02_5 if cerealsposition_4 == 5 
replace cowpea_prod = . if sorghum_prod == -9  

rename farines_01_1 cassava_hectares 
replace cassava_hectares = 0 if farine_tubercules_consumption_1 == 0 
replace cassava_hectares = . if cassava_hectares == -9 

rename farines_02_1 cassava_prod 
replace cassava_prod = 0 if farine_tubercules_consumption_1 == 0 
replace cassava_prod = . if cassava_prod == -9

rename farines_01_2 sweetpotato_hectares 
replace sweetpotato_hectares = 0 if farine_tubercules_consumption_2 == 0 
replace sweetpotato_hectares = . if sweetpotato_hectares == -9 

rename farines_02_2 sweetpotato_prod 
replace sweetpotato_prod = 0 if farine_tubercules_consumption_2 == 0 
replace sweetpotato_prod = . if sweetpotato_prod == -9 
replace sweetpotato_prod = . if sweetpotato_prod == -90

rename farines_01_3 potato_hectares 
replace potato_hectares = 0 if farine_tubercules_consumption_3 == 0 
replace potato_hectares = . if potato_hectares == -9 

rename farines_02_3 potato_prod 
replace potato_prod = 0 if farine_tubercules_consumption_3 == 0 
replace potato_prod = . if potato_prod == -9

rename farines_01_4 yam_hectares 
replace yam_hectares = 0 if farine_tubercules_consumption_4 == 0 
replace yam_hectares = . if yam_hectares == -9 

rename farines_02_4 yam_prod 
replace yam_prod = 0 if farine_tubercules_consumption_4 == 0 
replace yam_prod = . if yam_prod == -9

rename farines_01_5 taro_hectares 
replace taro_hectares = 0 if farine_tubercules_consumption_5 == 0 
replace taro_hectares = . if taro_hectares == -9 

rename farines_02_5 taro_prod 
replace taro_prod = 0 if farine_tubercules_consumption_5 == 0 
replace taro_prod = . if taro_prod == -9

rename legumes_01_1 tomato_hectares 
replace tomato_hectares = 0 if legumes_consumption_1 == 0 
replace tomato_hectares = . if tomato_hectares == -9 

rename legumes_02_1 tomato_prod 
replace tomato_prod = 0 if legumes_consumption_1 == 0 
replace tomato_prod = . if tomato_prod == -9

rename legumes_01_2 carrot_hectares 
replace carrot_hectares = 0 if legumes_consumption_2 == 0 
replace carrot_hectares = . if carrot_hectares == -9 

rename legumes_02_2 carrot_prod 
replace carrot_prod = 0 if legumes_consumption_2 == 0 
replace carrot_prod = . if carrot_prod == -9

rename legumes_01_3 onion_hectares 
replace onion_hectares = 0 if legumes_consumption_3 == 0 
replace onion_hectares = . if onion_hectares == -9 

rename legumes_02_3 onion_prod 
replace onion_prod = 0 if legumes_consumption_3 == 0 
replace onion_prod = . if onion_prod == -9

rename legumes_01_4 cucumber_hectares 
replace cucumber_hectares = 0 if legumes_consumption_4 == 0 
replace cucumber_hectares = . if cucumber_hectares == -9 

rename legumes_02_4 cucumber_prod 
replace cucumber_prod = 0 if legumes_consumption_4 == 0 
replace cucumber_prod = . if cucumber_prod == -9

rename legumes_01_5 pepper_hectares 
replace pepper_hectares = 0 if legumes_consumption_5 == 0 
replace pepper_hectares = . if pepper_hectares == -9 

rename legumes_02_5 pepper_prod 
replace pepper_prod = 0 if legumes_consumption_5 == 0 
replace pepper_prod = . if pepper_prod == -9

rename legumineuses_01_1 peanut_hectares 
replace peanut_hectares = 0 if legumineuses_consumption_1 == 0 
replace peanut_hectares = . if peanut_hectares == -9 

rename legumineuses_02_1 peanut_prod 
replace peanut_prod = 0 if legumineuses_consumption_1 == 0 
replace peanut_prod = . if peanut_prod == -9

rename legumineuses_01_2 bean_hectares 
replace bean_hectares = 0 if legumineuses_consumption_2 == 0 
replace bean_hectares = . if bean_hectares == -9 

rename legumineuses_02_2 bean_prod 
replace bean_prod = 0 if legumineuses_consumption_2 == 0 
replace bean_prod = . if bean_prod == -9

rename legumineuses_01_3 pea_hectares 
replace pea_hectares = 0 if legumineuses_consumption_3 == 0 
replace pea_hectares = . if pea_hectares == -9 

rename legumineuses_02_3 pea_prod 
replace pea_prod = 0 if legumineuses_consumption_3 == 0 
replace pea_prod = . if pea_prod == -9

rename legumineuses_01_4 lentil_hectares 
replace lentil_hectares = 0 if legumineuses_consumption_4 == 0 
replace lentil_hectares = . if lentil_hectares == -9 

rename legumineuses_02_4 lentil_prod 
replace lentil_prod = 0 if legumineuses_consumption_4 == 0 
replace lentil_prod = . if lentil_prod == -9

keep hhid rice_hectares rice_prod maize_hectares maize_prod millet_hectares millet_prod sorghum_hectares sorghum_prod cowpea_hectares cowpea_prod cassava_hectares cassava_prod sweetpotato_hectares sweetpotato_prod potato_hectares potato_prod yam_hectares yam_prod taro_hectares taro_prod tomato_hectares tomato_prod carrot_hectares carrot_prod onion_hectares onion_prod cucumber_hectares cucumber_prod pepper_hectares pepper_prod peanut_hectares peanut_prod bean_hectares bean_prod pea_hectares pea_prod lentil_hectares lentil_prod farines_05_1 farines_05_2 farines_05_3 farines_05_4 farines_05_5 legumes_05_2 legumes_05_4 legumes_05_5 legumineuses_05_2 legumineuses_05_3 legumineuses_05_4 

tempfile production 
save `production'

*** import income module data *** 
use "$data/Complete_Baseline_Income.dta", clear  

*** clean household level income data *** 
keep hhid agri_income_01 agri_income_02 agri_income_03 agri_income_04 agri_income_05 agri_income_06 agri_income_12* agri_income_15 agri_income_16 agri_income_17 agri_income_18 agri_income_19  

replace agri_income_01 = . if agri_income_01 == 2 

*** filter to max 12 months, 52 weeks, 365 days for work days ***
replace agri_income_03 = 365 if agri_income_03 > 365 & agri_income_04 == 1
replace agri_income_03 = 52 if agri_income_03 > 52 & agri_income_04 == 2
replace agri_income_03 = 12 if agri_income_03 > 12 & agri_income_04 == 3

gen work_days = agri_income_03 if agri_income_04 == 1 
replace work_days = agri_income_03 * 5 if agri_income_04 == 2 
replace work_days = agri_income_03 * 5 * 4 if agri_income_04 == 3 

replace agri_income_05 = . if agri_income_05 == -9 
replace agri_income_06 = . if agri_income_06 == -9

gen daily_wage = agri_income_05 / work_days 

replace agri_income_15 = . if agri_income_15 == -2 

replace agri_income_16 = 0 if agri_income_15 == 0 

replace agri_income_12_1 = . if agri_income_12_1 == -9

*** calculate total income from livestock sales *** 
egen tot_livestock_sales = rowtotal(agri_income_12_1 agri_income_12_2 agri_income_12_3 agri_income_12_4 agri_income_12_5 agri_income_12_o)

tempfile income 
save `income'

*** import income module data *** 
use "$data/Complete_Baseline_Income.dta", clear  

*** clean milk production data *** 
keep hhid sale_animalesindex_* agri_income_11_* agri_income_12_* agri_income_13_* agri_income_14_* 

forvalues i = 1/5 {
	tostring agri_income_13_`i', replace
}

*** reshape to animal type level data *** 
reshape long sale_animalesindex_ agri_income_11_ agri_income_12_ agri_income_13_ agri_income_13_1_ agri_income_13_2_ agri_income_13_3_ agri_income_13_99_ agri_income_13_9_ agri_income_13_5_ agri_income_13_6_ agri_income_13_7_ agri_income_13_8_ agri_income_13_10_ agri_income_14_ , i(hhid) j(animalcount)

drop if sale_animalesindex_ == . 

*** keep milk production transactions ***  
keep if agri_income_13_1_ == 1 

*** divide total sales evenly across all product types if milk is sold with other products *** 
gen tot_animal_products = agri_income_13_1_ + agri_income_13_2_ + agri_income_13_3_ + agri_income_13_99_ + agri_income_13_9_ + agri_income_13_5_ + agri_income_13_6_ + agri_income_13_7_ + agri_income_13_8_ + agri_income_13_10_

gen milk_sales = agri_income_14_ / tot_animal_products

*** create household level milk production *** 
collapse (sum) milk_sales, by(hhid)

tempfile milk_sales_baseline
save `milk_sales_baseline'

*** calculate TLUs ***
*** import income module data *** 
use "$data/Complete_Baseline_Income.dta", clear  

*** keep livestock holding data *** 
keep hhid speciesindex* agri_income_07* 

drop agri_income_07_o 

*** reshape to livestock level *** 
reshape long speciesindex_ agri_income_07_ , i(hhid) j(num)

drop if speciesindex_ ==. & agri_income_07_ == . 

gen TLU = 0 
replace TLU = 1*agri_income_07_ if speciesindex_ == 1 
replace TLU = 0.1*agri_income_07_ if speciesindex_ == 2 
replace TLU = 0.1*agri_income_07_ if speciesindex_ == 3
replace TLU = 1*agri_income_07_ if speciesindex_ == 4
replace TLU = 0.5*agri_income_07_ if speciesindex_ == 5
replace TLU = 1*agri_income_07_ if speciesindex_ == 6
replace TLU = 0.2*agri_income_07_ if speciesindex_ == 7
replace TLU = 0.01*agri_income_07_ if speciesindex_ == 8

collapse (sum) TLU, by(hhid) 

merge 1:1 hhid using "$data/Complete_Baseline_Income.dta"

replace TLU = 0 if _merge == 2 

keep hhid TLU species_o agri_income_07_o

replace TLU = TLU + 1*agri_income_07_o if species_o == "Boeuf"
replace TLU = TLU + 0.01*agri_income_07_o if species_o == "Canards"
replace TLU = TLU + 0.01*agri_income_07_o if species_o == "Pigeons"
replace TLU = TLU + 1*agri_income_07_o if species_o == "Vache"
replace TLU = TLU + 1*agri_income_07_o if species_o == "Vaches"
replace TLU = TLU + 1*agri_income_07_o if species_o == "Vaches l"

keep hhid TLU 

save "$auctions/tlu_baseline.dta", replace 

*** merge together entire household dataset *** 
use `main_hh_baseline', clear 

merge 1:1 hhid using `hhhead_baseline'

drop _merge 

merge 1:1 hhid using `water_time_12month' 

drop _merge 

merge 1:1 hhid using `water_time_7days' 

replace fetch_water_hh_7d_act = 0 if _merge == 1 
replace water_livestock_7d_act = 0 if _merge == 1 
replace fetch_water_ag_7d_act = 0 if _merge == 1 
replace wash_clothes_7d_act = 0 if _merge == 1 
replace dishes_7d_act = 0 if _merge == 1 
replace harvest_veg_7d_act = 0 if _merge == 1 
replace swim_7d_act = 0 if _merge == 1
replace play_7d_act = 0 if _merge == 1

drop _merge 

merge 1:1 hhid using `assets'

replace plow = 0 if _merge == 1
replace harrow = 0 if _merge == 1
replace draftanimals = 0 if _merge == 1
replace cart = 0 if _merge == 1 
replace tractor = 0 if _merge == 1 
replace sprayer = 0 if _merge == 1 
replace motorpumps = 0 if _merge == 1 
replace hoes = 0 if _merge == 1 
replace ridger = 0 if _merge == 1 
replace sickle = 0 if _merge == 1 
replace seeder = 0 if _merge == 1 
replace kadiandou = 0 if _merge == 1 
replace fanting = 0 if _merge == 1 
replace other = 0 if _merge == 1 

drop _merge 

merge 1:1 hhid using `number_of_plots'

drop _merge 

merge 1:1 hhid using `production' 

drop _merge 

merge 1:1 hhid using `income' 

drop _merge 

merge 1:1 hhid using `milk_sales_baseline'

gen any_milk_sales = _merge == 3 

replace milk_sales = 0 if _merge == 1

drop _merge 

merge 1:1 hhid using "$auctions/tlu_baseline.dta" 

drop _merge

*** bring in community price data *** 
gen hhid_village = substr(hhid, 1, 4)

merge m:1 hhid_village using "$data/Complete_Baseline_Community.dta"

drop _merge 

merge 1:1 hhid using `plot_level_ag'

drop _merge 

merge 1:1 hhid using `manure_use' 

replace manure_kgs = 0 if _merge == 1 & agri_6_14 == 1

drop _merge 

merge 1:1 hhid using "$asset_index/pooled_asset_index_var.dta"

drop if _merge == 2 

drop _merge 

rename asset_index_std0 asset_index_std

merge 1:1 hhid using `slackhours'

drop _merge 

*** clean price data *** 
rename q63_1 urea_price 
rename q63_2 manure_price
rename q63_3 rice_price
rename q63_4 corn_price
rename q63_5 millet_price
rename q63_6 sorghum_price
rename q63_7 cowpea_price
rename q63_8 tomato_price
rename q63_9 onion_price
rename q63_10 peanut_price

rename farines_05_1 cassava_price 
rename farines_05_2 sweetpotato_price 
rename farines_05_3 potato_price 
rename farines_05_4 yam_price 
rename farines_05_5 taro_price
rename legumes_05_2 carrot_price 
rename legumes_05_4 cucumber_price
rename legumes_05_5 pepper_price 
rename legumineuses_05_2 bean_price 
rename legumineuses_05_3 pea_price
rename legumineuses_05_4 lentil_price 

replace manure_price = . if manure_price == -9
replace corn_price = . if corn_price == -9
replace millet_price = . if millet_price == -9
replace sorghum_price = . if sorghum_price == -9
replace cowpea_price = . if cowpea_price == -9
replace tomato_price = . if tomato_price == -9
replace onion_price = . if onion_price == -9
replace peanut_price = . if peanut_price == -9
replace sweetpotato_price = . if sweetpotato_price == -9 

egen med_manure_price = median(manure_price)
replace manure_price = med_manure_price if manure_price == . 
egen med_corn_price = median(corn_price)
replace corn_price = med_corn_price if corn_price == . 
egen med_millet_price = median(millet_price)
replace millet_price = med_millet_price if millet_price == . 
egen med_sorghum_price = median(sorghum_price)
replace sorghum_price = med_sorghum_price if sorghum_price == .
egen med_cowpea_price = median(cowpea_price)
replace cowpea_price = med_cowpea_price if cowpea_price == .
egen med_tomato_price = median(tomato_price)
replace tomato_price = med_tomato_price if tomato_price == .   
egen med_onion_price = median(onion_price)
replace onion_price = med_onion_price if onion_price == . 
egen med_cassava_price = median(cassava_price)
egen med_sweetpotato_price = median(sweetpotato_price)
egen med_yam_price = median(yam_price)
egen med_carrot_price = median(carrot_price)
egen med_cucumber_price = median(cucumber_price)
egen med_pepper_price = median(pepper_price)
egen med_bean_price = median(bean_price)
egen med_pea_price = median(pea_price)
egen med_lentil_price = median(lentil_price)

*** create value of output variable *** 
gen value_rice_prod = rice_prod * rice_price 
gen value_corn_prod = maize_prod * corn_price
gen value_millet_prod = millet_prod * millet_price 
gen value_sorghum_prod = sorghum_prod * sorghum_price 
gen value_cowpea_prod = cowpea_prod * cowpea_price
gen value_tomato_prod = tomato_prod * tomato_price
gen value_onion_prod = onion_prod * onion_price 
gen value_peanut_prod = peanut_prod * peanut_price
gen value_cassava_prod = cassava_prod * cassava_price
gen value_sweetpotato_prod = sweetpotato_prod * sweetpotato_price
gen value_yam_prod = yam_prod * yam_price
gen value_carrot_prod = carrot_prod * carrot_price
gen value_cucumber_prod = cucumber_prod * cucumber_price
gen value_pepper_prod = pepper_prod * pepper_price
gen value_bean_prod = bean_prod * bean_price
gen value_pea_prod = pea_prod * pea_price
gen value_lentil_prod = lentil_prod * lentil_price

egen total_value_production = rowtotal(value_rice_prod value_corn_prod value_millet_prod value_sorghum_prod value_cowpea_prod value_tomato_prod value_onion_prod value_peanut_prod value_cassava_prod value_sweetpotato_prod value_yam_prod value_carrot_prod value_cucumber_prod value_pepper_prod value_bean_prod value_pea_prod value_lentil_prod)
egen total_production_hectares = rowtotal(rice_hectares maize_hectares millet_hectares sorghum_hectares cowpea_hectares tomato_hectares onion_hectares peanut_hectares cassava_hectares sweetpotato_hectares yam_hectares carrot_hectares cucumber_hectares pepper_hectares bean_hectares pea_hectares lentil_hectares)

egen number_equipment = rowtotal(plow harrow draftanimals cart tractor sprayer motorpumps hoes ridger sickle seeder kadiandou fanting other)
egen number_mech_equip = rowtotal(plow harrow tractor sprayer motorpumps)

gen ag_wage = (agri_6_14 == 1 & agri_income_01 == 1)

gen any_livestock_income = (tot_livestock_sales > 0) 

egen total_ag_hours = rowtotal(ag_hours planting_hours growth_hours harvest_hours)

egen total_fert = rowtotal(urea_kgs phosphate_kgs npk_kgs other_kgs)

keep hhid agri_6_14 agri_6_15 total_value_production total_production_hectares total_ag_hours total_fert collective_manage rice agri_6_30_ agri_6_34_comp_ agri_6_34_ agri_income_15 agri_income_16 number_mech_equip TLU any_milk_sales milk_sales agri_income_01 daily_wage ag_wage hhhead* rice crop_types child members asset_index_std slack_hours urea_price

tempfile shadow_wage_baseline
save `shadow_wage_baseline'

*** midline data ***
*** import household roster data *** 
use "$midline/Complete_Midline_Household_Roster", clear   

*** keep only needed data and reshape to long *** 
keep hhid hhid_village hh_01_* hh_02_* hh_03_* hh_04_* hh_05_* hh_06_* hh_07_* hh_08_* hh_09_* hh_10_* hh_14_* hh_15_* hh_16_* hh_17_* hh_18_* hh_22_* hh_23_* hh_24_* hh_25_* hh_gender_* hh_age_* hh_education_level_* hh_relation_with_* 

drop hh_age_resp hh_gender_resp 

forvalues i = 1/57 {
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
replace hh_01_ = . if hh_01_ == -9 
replace hh_02_ = . if hh_02_ == -9
replace hh_04_ = . if hh_04_ == -9
replace hh_05_ = . if hh_05_ == -9
replace hh_06_ = . if hh_06_ == -9 
replace hh_07_ = . if hh_07_ == -9
replace hh_08_ = . if hh_08_ == -9
replace hh_09_ = . if hh_09_ == -9
replace hh_16_ = . if hh_16_ == -9
replace hh_24_ = . if hh_24_ == -9

*** count children *** 
gen child = (hh_age_ < 18)

*** count household labor hours totals and per capita *** 
collapse (sum) chore_hours = hh_01_ (sum) water_hours = hh_02_ (sum) ag_hours = hh_04_ (sum) planting_hours = hh_05_ (sum) growth_hours = hh_06_ (sum) harvest_hours = hh_07_ (sum) tradehh_hours = hh_08_ (sum) tradeoutside_hours = hh_09_ (sum) water_hours_12mo = hh_10_ (sum) veg_collected_12mo = hh_14_ (sum) fertilizer_hours_12mo = hh_16_ (sum) feed_hours_12mo = hh_17_ (sum) water_hours_7days = hh_18_ (sum) veg_collected_7days = hh_22_ (sum) fertilizer_hours_7days = hh_24_ (sum) feed_hours_7days = hh_25_ (count) members = hh_gender_ (mean) female household_head spouse no_education primary_education secondary_education tertiary_education technical_education other_education sell_veg_12mo fertilizer_veg_12mo biodigest_veg_12mo nothing_veg_12mo other_veg_12mo hh_01_ hh_02_ hh_03_ hh_04_ hh_05_ hh_06_ hh_07_ hh_08_ hh_09_ hh_10_ hh_14_ hh_16_ hh_17_ hh_18_ hh_22_ hh_23_1_ hh_23_2_ hh_23_3_ hh_23_4_ hh_23_5_ hh_23_99_ hh_24_ hh_25_ (sum) child, by(hhid)

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
tempfile main_hh_midline
save `main_hh_midline'

*** clean household head variables - education, gender, age *** 
use "$midline/Complete_Midline_Household_Roster", clear   

*** keep only needed data and reshape to long *** 
keep hhid hhid_village hh_gender_* hh_age_* hh_education_level_* hh_relation_with_*

drop hh_age_resp hh_gender_resp hh_education_level_o_* hh_relation_with_o_*  

reshape long hh_gender_ hh_age_ hh_education_level_ hh_relation_with_ , i(hhid hhid_village) j(person)

drop if hh_gender_ == . 

*** keep only the household head *** 
keep if hh_relation_with_ == 1 

*** create indicator variables ***
gen hhhead_female = (hh_gender_ == 2)
gen hhhead_no_education = (hh_education_level_ == 0)
gen hhhead_primary_education = (hh_education_level_ == 1)
gen hhhead_secondary_education = (hh_education_level_ == 2)
gen hhhead_tertiary_education = (hh_education_level_ == 3)
gen hhhead_technical_education = (hh_education_level_ == 4)
gen hhhaed_other_education = (hh_education_level_ == 99)

rename hh_age_ hhhead_age 

*** keep cleaned household head variables *** 
keep hhid hhhead* 

tempfile hhhead_midline 
save `hhhead_midline'

*** clean hh_13 (12 month recall) on water time use data *** 

*** import household roster data *** 
use "$midline/Complete_Midline_Household_Roster", clear   

*** keep 12 month recall time in water data *** 
keep hhid hh_10* hh_12index* hh_13_*

drop hh_13_sum_* hh_13_o_*

*** change indexs to have last number be person *** 
forvalues i = 1/57 {
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
reshape long hh_10_ hh_12index1_ hh_131_ hh_12index2_ hh_132_ hh_12index3_ hh_133_ hh_12index4_ hh_134_ hh_12index5_ hh_135_ hh_12index6_ hh_136_ hh_12index7_ hh_137_, i(hhid) j(person)

*** drop extra people *** 
drop if hh_10_ == . 

*** rename variables to get to activity level data *** 
forvalues i = 1/7{
    rename hh_12index`i'_ hh_12_index_`i' 
	rename hh_13`i'_ hh_13_`i' 
}

*** reshape to person level *** 
reshape long hh_12_index_ hh_13_, i(hhid person) j(activity)

replace hh_13_ = 0 if hh_10_ == 0 

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
tempfile water_time_12month_midline
save `water_time_12month_midline'

*** clean hh_21 (7 day recall) on water time use data *** 

*** import household roster data *** 
use "$midline/Complete_Midline_Household_Roster", clear   

*** keep 7 day recall time in water data *** 
keep hhid hh_18* hh_20index* hh_21_*

drop hh_21_sum_* hh_21_o_*

*** change indexs to have last number be person *** 
forvalues i = 1/57 {
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
reshape long hh_18_ hh_20index1_ hh_211_ hh_20index2_ hh_212_ hh_20index3_ hh_213_ hh_20index4_ hh_214_ hh_20index5_ hh_215_ hh_20index6_ hh_216_ hh_20index7_ hh_217_, i(hhid) j(person)

*** drop extra people *** 
drop if hh_18_ == . 

*** rename variables to get to activity level data *** 
forvalues i = 1/7{
    rename hh_20index`i'_ hh_20_index_`i' 
	rename hh_21`i'_ hh_21_`i' 
}

*** reshape to person level *** 
reshape long hh_20_index_ hh_21_, i(hhid person) j(activity)

replace hh_21_ = 0 if hh_18_ == 0 

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
tempfile water_time_7days_midline
save `water_time_7days_midline' 

*** calculate above age 15 slack labor hours *** 
*** import household roster data *** 
use "$midline/Complete_Midline_Household_Roster", clear   

*** keep 7 day recall time use variables and age variable *** 
keep hhid hh_age_* hh_01_* hh_02_* hh_04_* hh_08_* hh_09_* hh_18_* 

drop hh_age_resp

*** reshape to long *** 
reshape long hh_age_ hh_01_ hh_02_ hh_04_ hh_08_ hh_09_ hh_18_ , i(hhid) j(person)

drop if hh_01_ == . 

*** drop if under 15 *** 
drop if hh_age_ < 15

*** calculate total weekly labor hours *** 
egen weekly_hrs = rowtotal(hh_01_ hh_02_ hh_04_ hh_08_ hh_09_ hh_18_)

*** declare slack hours as any hours less than 80 hours per week *** 
gen slack_hours = 80 - weekly_hrs 
replace slack_hours = 0 if slack_hours < 0 

*** calculate total number of slack labor hours per household ***
collapse (sum) slack_hours, by(hhid)

tempfile slackhours_midline 
save `slackhours_midline'

*** import agricultural plot level data *** 
use "$midline/Complete_Midline_Agriculture", clear   

*** keep key variables to reshape to the plot level *** 
keep hhid agri_6_18_* agri_6_20_* agri_6_21_* agri_6_22_* agri_6_30_* agri_6_31_* agri_6_34_comp_* agri_6_34_* agri_6_35_* agri_6_36_* agri_6_37_* agri_6_38_a_* agri_6_38_a_code_* agri_6_39_a_* agri_6_39_a_code_* agri_6_40_a_* agri_6_40_a_code_* agri_6_41_a_* agri_6_41_a_code_*   

forvalue i = 1/9 {
	tostring agri_6_20_o_`i', replace 
	tostring agri_6_31_o_`i', replace
	tostring agri_6_38_a_code_o_`i', replace
	tostring agri_6_39_a_code_o_`i', replace
	tostring agri_6_40_a_code_o_`i', replace
	tostring agri_6_41_a_code_o_`i', replace
}
 
*** reshape data to long, plot level data ***
reshape long agri_6_18_ agri_6_20_ agri_6_20_o_ agri_6_21_ agri_6_22_ agri_6_30_ agri_6_31_ agri_6_31_o_ agri_6_34_comp_ agri_6_34_ agri_6_35_ agri_6_36_ agri_6_37_ agri_6_38_a_ agri_6_38_a_code_ agri_6_38_a_code_o_ agri_6_39_a_ agri_6_39_a_code_ agri_6_39_a_code_o_ agri_6_40_a_ agri_6_40_a_code_ agri_6_40_a_code_o_ agri_6_41_a_ agri_6_41_a_code_ agri_6_41_a_code_o_, i(hhid) j(plot)

drop if agri_6_18_ == . 

*** create single unit variables for land, application amounts  *** 
gen plot_size_ha = agri_6_21_ 
replace plot_size_ha = agri_6_21_ / 1000 if agri_6_22_ == 2 

gen urea_kgs = agri_6_38_a_ 
replace urea_kgs = agri_6_38_a_ * 1000 if agri_6_38_a_code_ == 2 
replace urea_kgs = agri_6_38_a_ * 50 if agri_6_38_a_code_ == 3 
replace urea_kgs = . if agri_6_38_a_code_ == 99 

gen phosphate_kgs = agri_6_39_a_ 
replace phosphate_kgs = agri_6_39_a_ * 1000 if agri_6_39_a_code_ == 2 
replace phosphate_kgs = agri_6_39_a_ * 50 if agri_6_39_a_code_ == 3 

gen npk_kgs = agri_6_40_a_ 
replace npk_kgs = agri_6_40_a_ * 1000 if agri_6_40_a_code_ == 2 
replace npk_kgs = agri_6_40_a_ * 50 if agri_6_40_a_code_ == 3 
replace npk_kgs = . if agri_6_40_a_code_ == 99 

gen other_kgs = agri_6_41_a_ 
replace other_kgs = agri_6_41_a_ * 1000 if agri_6_41_a_code_ == 2 
replace other_kgs = agri_6_41_a_ * 50 if agri_6_41_a_code_ == 3 
replace other_kgs = . if agri_6_41_a_code_ == 99 

*** get rid of don't knows *** 
replace agri_6_30_ = . if agri_6_30_ == 2
replace agri_6_34_comp_ = . if agri_6_34_comp_ == 2
replace agri_6_34_ = . if agri_6_34_ == 2
replace agri_6_36_ = . if agri_6_36_ == 2

*** create indicator variables for crop types ***
gen collective_manage = (agri_6_18_ == 2) 
gen rice = (agri_6_20_ == 1)
gen maize = (agri_6_20_ == 2)
gen millet = (agri_6_20_ == 3)
gen sorghum = (agri_6_20_ == 4)
gen cowpea = (agri_6_20_ == 5)
gen cassava = (agri_6_20_ == 6)
gen sweetpotato = (agri_6_20_ == 7)
gen potato = (agri_6_20_ == 8)
gen yam = (agri_6_20_ == 9)
gen taro = (agri_6_20_ == 10)
gen tomato = (agri_6_20_ == 11)
gen carrot = (agri_6_20_ == 12)
gen onion = (agri_6_20_ == 13)
replace onion = 1 if agri_6_20_o_ == "OIGNON"
gen cucumber = (agri_6_20_ == 14)
gen pepper = (agri_6_20_ == 15)
replace pepper = 1 if agri_6_20_o == "PIMENT"
replace pepper = 1 if agri_6_20_o == "PIMENTS"
replace pepper = 1 if agri_6_20_o == "Piment"
replace pepper = 1 if agri_6_20_o_ == "PUMANTS"
replace pepper = 1 if agri_6_20_o_ == "Poivrons"
gen peanut = (agri_6_20_ == 16)
gen bean = (agri_6_20_ == 17)
gen pea = (agri_6_20_ == 18)
gen other = (agri_6_20_ == 99)
replace other = 0 if agri_6_20_o_ == "OIGNON"
replace other = 0 if agri_6_20_o == "PIMENT"
replace other = 0 if agri_6_20_o == "PIMENTS"
replace other = 0 if agri_6_20_o == "Piment"
replace other = 0 if agri_6_20_o_ == "PUMANTS"
replace other = 0 if agri_6_20_o_ == "Poivrons"

gen manure_direct_parking = (agri_6_31_ == 1)
gen manure_indirect_parking = (agri_6_31_ == 2)
gen manure_purchase = (agri_6_31_ == 3)
gen manure_other_source = (agri_6_31_ == 99)

gen crop_types = rice + maize + millet + sorghum + cowpea + cassava + sweetpotato + potato + yam + taro + tomato + carrot + onion + cucumber + pepper + peanut + bean + pea + other

*** collapse to household level *** 
collapse (sum) plot_size_ha (sum) urea_kgs (sum) phosphate_kgs (sum) npk_kgs (sum) other_kgs (sum) agri_6_30_ (sum) agri_6_34_comp_ (sum) agri_6_34_ (sum) agri_6_36_ (sum) rice (sum) collective_manage (sum) crop_types, by(hhid)

*** save clean plot level data *** 
tempfile plot_level_ag_midline
save `plot_level_ag_midline'

*** clean agriculture equipment data *** 

*** import agricultural plot level data *** 
use "$midline/Complete_Midline_Agriculture", clear   

*** keep variables related to agricultural equipment *** 
keep hhid agriindex_* _agri_number_* 

*** reshape to long *** 
reshape long agriindex_ _agri_number_ , i(hhid) j(equip)

drop if agriindex_ == . & _agri_number_ == . 

*** create count of each equipment type at the household level *** 
gen plow = _agri_number_ if agriindex_ == 1 
gen harrow = _agri_number_ if agriindex_ == 2  
gen draftanimals = _agri_number_ if agriindex_ == 3  
gen cart = _agri_number_ if agriindex_ == 4 
gen tractor = _agri_number_ if agriindex_ == 5 
gen sprayer = _agri_number_ if agriindex_ == 6 
gen motorpumps = _agri_number_ if agriindex_ == 7 
gen hoes = _agri_number_ if agriindex_ == 8 
gen ridger = _agri_number_ if agriindex_ == 9 
gen sickle = _agri_number_ if agriindex_ == 10 
gen seeder = _agri_number_ if agriindex_ == 11 
gen kadiandou = _agri_number_ if agriindex_ == 12 
gen fanting = _agri_number_ if agriindex_ == 13 
gen solarplanels = _agri_number_ if agriindex_ == 14
gen other = _agri_number_ if agriindex_ == 15 

collapse plow harrow draftanimals cart tractor sprayer motorpumps hoes ridger sickle seeder kadiandou fanting solarplanels other, by(hhid)
 
replace plow = 0 if plow == .
replace harrow = 0 if harrow == .
replace draftanimals = 0 if draftanimals == .
replace cart = 0 if cart == . 
replace tractor = 0 if tractor == . 
replace sprayer = 0 if sprayer == . 
replace motorpumps = 0 if motorpumps == . 
replace hoes = 0 if hoes == . 
replace ridger = 0 if ridger == . 
replace sickle = 0 if sickle == . 
replace seeder = 0 if seeder == . 
replace kadiandou = 0 if kadiandou == . 
replace fanting = 0 if fanting == . 
replace solarplanels = 0 if solarplanels == . 
replace other = 0 if other == . 
 
tempfile assets_midline
save `assets_midline' 

*** clean non-standard unit data on compost use *** 

*** import agricultural plot level data *** 
use "$midline/Complete_Midline_Agriculture", clear   

keep hhid agri_6_32_* agri_6_33_*

reshape long agri_6_32_ agri_6_33_ agri_6_33_o_ , i(hhid) j(plot)

drop if agri_6_32_ == . & agri_6_33_ == . & agri_6_33_o_ == . 

*** extract off village ID to pull in non-standard unit measures *** 
gen hhid_village = substr(hhid, 1, 4)

*** merge in non-standard unit measures ***
merge m:1 hhid_village using "$midline/Complete_Midline_Community.dta"

drop if _merge == 2 

drop _merge 

*** calculate manure use in kgs *** 
gen manure_kgs = agri_6_32_ 
replace manure_kgs = agri_6_32 * unit_convert_1 if agri_6_33_ == 2 
replace manure_kgs = agri_6_32 * unit_convert_2 if agri_6_33_ == 3 

keep hhid plot manure_kgs 

*** collapse to household level *** 
collapse (sum) manure_kgs, by(hhid)

tempfile manure_use_midline
save `manure_use_midline'

*** clean number of plots data *** 

*** import agricultural plot level data *** 
use "$midline/Complete_Midline_Agriculture", clear   

keep hhid agri_6_14 agri_6_15

replace agri_6_14 = . if agri_6_14 == 2 

replace agri_6_15 = 0 if agri_6_14 == 0

tempfile number_of_plots_midline
save `number_of_plots_midline'

*** clean production data *** 
use "$midline/Complete_Midline_Production.dta", clear   

rename cereals_01_1 rice_hectares 
replace rice_hectares = 0 if cereals_consumption_1 == 0 
replace rice_hectares = . if rice_hectares == -9 

rename cereals_02_1 rice_prod 
replace rice_prod = 0 if cereals_consumption_1 == 0 
replace rice_prod = . if rice_prod == -9

gen maize_hectares = cereals_01_2 
replace maize_hectares = 0 if cereals_consumption_2 == 0
replace maize_hectares = . if maize_hectares == -9 

gen maize_prod = cereals_02_2 
replace maize_prod = 0 if cereals_consumption_2 == 0  
replace maize_prod = . if maize_prod == -9 

gen millet_hectares = cereals_01_3 
replace millet_hectares = 0 if cereals_consumption_3 == 0
replace millet_hectares = . if millet_hectares == -9 

gen millet_prod = cereals_02_3 
replace millet_prod = 0 if cereals_consumption_3 == 0 
replace millet_prod = . if millet_prod == -9

gen sorghum_hectares = cereals_01_4 
replace sorghum_hectares = 0 if cereals_consumption_4 == 0
replace sorghum_hectares = . if sorghum_hectares == -9 

gen sorghum_prod = cereals_02_2 
replace sorghum_prod = 0 if cereals_consumption_4 == 0 
replace sorghum_prod = . if sorghum_prod == -9  

gen cowpea_hectares = cereals_01_5 
replace cowpea_hectares = 0 if cereals_consumption_5 == 0
replace cowpea_hectares = . if cowpea_hectares == -9 

gen cowpea_prod = cereals_02_5 
replace cowpea_prod = 0 if cereals_consumption_5 == 0 
replace cowpea_prod = . if cowpea_prod == -9  

rename farines_01_1 cassava_hectares 
replace cassava_hectares = 0 if farine_tubercules_consumption_1 == 0 
replace cassava_hectares = . if cassava_hectares == -9 

rename farines_02_1 cassava_prod 
replace cassava_prod = 0 if farine_tubercules_consumption_1 == 0 
replace cassava_prod = . if cassava_prod == -9

rename farines_05_1 cassava_price

rename farines_01_2 sweetpotato_hectares 
replace sweetpotato_hectares = 0 if farine_tubercules_consumption_2 == 0 
replace sweetpotato_hectares = . if sweetpotato_hectares == -9 

rename farines_02_2 sweetpotato_prod 
replace sweetpotato_prod = 0 if farine_tubercules_consumption_2 == 0 
replace sweetpotato_prod = . if sweetpotato_prod == -9

rename farines_05_2 sweetpotato_price
replace sweetpotato_price = . if sweetpotato_price == -9

rename farines_01_3 potato_hectares 
replace potato_hectares = 0 if farine_tubercules_consumption_3 == 0 
replace potato_hectares = . if farine_tuberculesposition_3 == 4 
replace potato_hectares = . if potato_hectares == -9 

rename farines_02_3 potato_prod 
replace potato_prod = 0 if farine_tubercules_consumption_3 == 0 
replace potato_prod = . if farine_tuberculesposition_3 == 4 
replace potato_prod = . if potato_prod == -9

rename farines_01_4 yam_hectares 
replace yam_hectares = 0 if farine_tubercules_consumption_4 == 0 
replace yam_hectares = potato_hectares if farine_tuberculesposition_3 == 4 
replace yam_hectares = . if yam_hectares == -9 

rename farines_02_4 yam_prod 
replace yam_prod = 0 if farine_tubercules_consumption_4 == 0 
replace yam_prod = potato_prod if farine_tuberculesposition_3 == 4 
replace yam_prod = . if yam_prod == -9

rename farines_05_4 yam_price
replace yam_price = farines_05_3 if farine_tuberculesposition_3 == 4 

rename farines_01_5 taro_hectares 
replace taro_hectares = 0 if farine_tubercules_consumption_5 == 0 
replace taro_hectares = yam_hectares if farine_tuberculesposition_4 == 5 
replace taro_hectares = . if taro_hectares == -9 

rename farines_02_5 taro_prod 
replace taro_prod = 0 if farine_tubercules_consumption_5 == 0 
replace taro_prod = yam_prod if farine_tuberculesposition_4 == 5 
replace taro_prod = . if taro_prod == -9

rename legumes_01_1 tomato_hectares 
replace tomato_hectares = 0 if legumes_consumption_1 == 0 
replace tomato_hectares = . if tomato_hectares == -9 

rename legumes_02_1 tomato_prod 
replace tomato_prod = 0 if legumes_consumption_1 == 0 
replace tomato_prod = . if tomato_prod == -9

rename legumes_01_2 carrot_hectares 
replace carrot_hectares = 0 if legumes_consumption_2 == 0 
replace carrot_hectares = . if legumesposition_2 == 3 
replace carrot_hectares = . if carrot_hectares == -9 

rename legumes_02_2 carrot_prod 
replace carrot_prod = 0 if legumes_consumption_2 == 0 
replace carrot_prod = . if legumesposition_2 == 3
replace carrot_prod = . if carrot_prod == -9

rename legumes_05_2 carrot_price
replace carrot_price = . if legumesposition_2 == 3 

rename legumes_01_3 onion_hectares 
replace onion_hectares = 0 if legumes_consumption_3 == 0 
replace onion_hectares = carrot_hectares if legumesposition_2 == 3
replace onion_hectares = . if onion_hectares == -9 

rename legumes_02_3 onion_prod 
replace onion_prod = 0 if legumes_consumption_3 == 0 
replace onion_prod = carrot_prod if legumesposition_2 == 3
replace onion_prod = . if onion_prod == -9

rename legumes_01_4 cucumber_hectares 
replace cucumber_hectares = 0 if legumes_consumption_4 == 0 
replace cucumber_hectares = onion_hectares if legumesposition_3 == 4
replace cucumber_hectares = . if cucumber_hectares == -9 

rename legumes_02_4 cucumber_prod 
replace cucumber_prod = 0 if legumes_consumption_4 == 0 
replace cucumber_prod = onion_prod if legumesposition_3 == 4
replace cucumber_prod = . if cucumber_prod == -9

rename legumes_05_4 cucumber_price
replace cucumber_price = legumes_05_3 if legumesposition_3 == 4 
replace cucumber_price = . if cucumber_price == -9

rename legumes_01_5 pepper_hectares 
replace pepper_hectares = 0 if legumes_consumption_5 == 0 
replace pepper_hectares = cucumber_hectares if legumesposition_4 == 5
replace pepper_hectares = . if pepper_hectares == -9 

rename legumes_02_5 pepper_prod 
replace pepper_prod = 0 if legumes_consumption_5 == 0 
replace pepper_prod = cucumber_prod if legumesposition_4 == 5
replace pepper_prod = . if pepper_prod == -9

rename legumes_05_5 pepper_price
replace pepper_price = cucumber_price if legumesposition_4 == 5
replace pepper_price = . if pepper_price == -9

rename legumineuses_01_1 peanut_hectares 
replace peanut_hectares = 0 if legumineuses_consumption_1 == 0 
replace peanut_hectares = . if peanut_hectares == -9 

rename legumineuses_02_1 peanut_prod 
replace peanut_prod = 0 if legumineuses_consumption_1 == 0 
replace peanut_prod = . if peanut_prod == -9

rename legumineuses_01_2 bean_hectares 
replace bean_hectares = 0 if legumineuses_consumption_2 == 0 
replace bean_hectares = . if bean_hectares == -9 

rename legumineuses_02_2 bean_prod 
replace bean_prod = 0 if legumineuses_consumption_2 == 0 
replace bean_prod = . if bean_prod == -9

rename legumineuses_05_2 bean_price 

rename legumineuses_01_3 pea_hectares 
replace pea_hectares = 0 if legumineuses_consumption_3 == 0 
replace pea_hectares = . if pea_hectares == -9 

rename legumineuses_02_3 pea_prod 
replace pea_prod = 0 if legumineuses_consumption_3 == 0 
replace pea_prod = . if pea_prod == -9

rename legumineuses_05_3 pea_price 

rename legumineuses_01_4 lentil_hectares 
replace lentil_hectares = 0 if legumineuses_consumption_4 == 0 
replace lentil_hectares = . if lentil_hectares == -9 

rename legumineuses_02_4 lentil_prod 
replace lentil_prod = 0 if legumineuses_consumption_4 == 0 
replace lentil_prod = . if lentil_prod == -9

rename legumineuses_05_4 lentil_price

keep hhid rice_hectares rice_prod maize_hectares maize_prod millet_hectares millet_prod sorghum_hectares sorghum_prod cowpea_hectares cowpea_prod cassava_hectares cassava_prod sweetpotato_hectares sweetpotato_prod potato_hectares potato_prod yam_hectares yam_prod taro_hectares taro_prod tomato_hectares tomato_prod carrot_hectares carrot_prod onion_hectares onion_prod cucumber_hectares cucumber_prod pepper_hectares pepper_prod peanut_hectares peanut_prod bean_hectares bean_prod pea_hectares pea_prod lentil_hectares lentil_prod cassava_price sweetpotato_price yam_price carrot_price cucumber_price pepper_price bean_price pea_price lentil_price

tempfile production_midline
save `production_midline'

*** import income module data *** 
use "$midline/Complete_Midline_Income.dta", clear  

*** clean household level income data *** 
keep hhid agri_income_01 agri_income_02 agri_income_03 agri_income_04 agri_income_05 agri_income_06 agri_income_12_* agri_income_15 agri_income_16 agri_income_17 agri_income_18 agri_income_19  

replace agri_income_01 = . if agri_income_01 == 2 

*** filter to max 12 months, 52 weeks, 365 days for work days ***
replace agri_income_03 = 365 if agri_income_03 > 365 & agri_income_04 == 1
replace agri_income_03 = 52 if agri_income_03 > 52 & agri_income_04 == 2
replace agri_income_03 = 12 if agri_income_03 > 12 & agri_income_04 == 3

gen work_days = agri_income_03 if agri_income_04 == 1 
replace work_days = agri_income_03 * 5 if agri_income_04 == 2 
replace work_days = agri_income_03 * 5 * 4 if agri_income_04 == 3 

replace agri_income_05 = . if agri_income_05 == -9 
replace agri_income_06 = . if agri_income_06 == -9

gen daily_wage = agri_income_05 / work_days 

replace agri_income_15 = . if agri_income_15 == -2 

replace agri_income_16 = 0 if agri_income_15 == 0 
replace agri_income_16 = . if agri_income_16 == -9

*** calculate total income from livestock sales *** 
egen tot_livestock_sales = rowtotal(agri_income_12_1 agri_income_12_2 agri_income_12_3 agri_income_12_4 agri_income_12_5 agri_income_12_6 agri_income_12_o)

tempfile income_midline
save `income_midline'

*** import income module data *** 
use "$midline/Complete_Midline_Income.dta", clear  

*** clean milk production data *** 
keep hhid sale_animalesindex_* agri_income_11_* agri_income_12_* agri_income_13_* agri_income_14_* 

forvalues i = 1/6 {
	tostring agri_income_13_`i', replace
}

*** reshape to animal type level data *** 
reshape long sale_animalesindex_ agri_income_11_ agri_income_12_ agri_income_13_ agri_income_13_1_ agri_income_13_2_ agri_income_13_3_ agri_income_13_99_ agri_income_13_9_ agri_income_13_5_ agri_income_13_6_ agri_income_13_7_ agri_income_13_8_ agri_income_13_10_ agri_income_14_ , i(hhid) j(animalcount)

drop if sale_animalesindex_ == . 

*** keep milk production transactions ***  
keep if agri_income_13_1_ == 1 

*** divide total sales evenly across all product types if milk is sold with other products *** 
gen tot_animal_products = agri_income_13_1_ + agri_income_13_2_ + agri_income_13_3_ + agri_income_13_99_ + agri_income_13_9_ + agri_income_13_5_ + agri_income_13_6_ + agri_income_13_7_ + agri_income_13_8_ + agri_income_13_10_

gen milk_sales = agri_income_14_ / tot_animal_products

*** create household level milk production *** 
collapse (sum) milk_sales, by(hhid)

tempfile milk_sales_midline
save `milk_sales_midline'

*** calculate TLUs ***
*** import income module data *** 
use "$midline/Complete_Midline_Income.dta", clear  

*** keep livestock holding data *** 
keep hhid speciesindex* agri_income_07* 

drop agri_income_07_o 

*** reshape to livestock level *** 
reshape long speciesindex_ agri_income_07_ , i(hhid) j(num)

drop if speciesindex_ ==. & agri_income_07_ == . 

replace agri_income_07_ = . if agri_income_07_ == -9

gen TLU = 0 
replace TLU = 1*agri_income_07_ if speciesindex_ == 1 
replace TLU = 0.1*agri_income_07_ if speciesindex_ == 2 
replace TLU = 0.1*agri_income_07_ if speciesindex_ == 3
replace TLU = 1*agri_income_07_ if speciesindex_ == 4
replace TLU = 0.5*agri_income_07_ if speciesindex_ == 5
replace TLU = 1*agri_income_07_ if speciesindex_ == 6
replace TLU = 0.2*agri_income_07_ if speciesindex_ == 7
replace TLU = 0.01*agri_income_07_ if speciesindex_ == 8

collapse (sum) TLU, by(hhid) 

merge 1:1 hhid using "$midline/Complete_Midline_Income.dta"

replace TLU = 0 if _merge == 2 

keep hhid TLU species_o agri_income_07_o

replace TLU = TLU + 0.01*agri_income_07_o if species_o == "PIGEON"
replace TLU = TLU + 0.01*agri_income_07_o if species_o == "PINTADES"
replace TLU = TLU + 1*agri_income_07_o if species_o == "VÃCHE"

keep hhid TLU 

save "$auctions/tlu_midline.dta", replace 

*** merge together entire household dataset *** 
use `main_hh_midline', clear 

merge 1:1 hhid using `hhhead_midline'

drop _merge 

merge 1:1 hhid using `water_time_12month_midline' 

drop _merge 

merge 1:1 hhid using `water_time_7days_midline'

replace fetch_water_hh_7d_act = 0 if _merge == 1 
replace water_livestock_7d_act = 0 if _merge == 1 
replace fetch_water_ag_7d_act = 0 if _merge == 1 
replace wash_clothes_7d_act = 0 if _merge == 1 
replace dishes_7d_act = 0 if _merge == 1 
replace harvest_veg_7d_act = 0 if _merge == 1 
replace swim_7d_act = 0 if _merge == 1
replace play_7d_act = 0 if _merge == 1

drop _merge 

merge 1:1 hhid using `assets_midline' 

replace plow = 0 if _merge == 1
replace harrow = 0 if _merge == 1
replace draftanimals = 0 if _merge == 1
replace cart = 0 if _merge == 1 
replace tractor = 0 if _merge == 1 
replace sprayer = 0 if _merge == 1 
replace motorpumps = 0 if _merge == 1 
replace hoes = 0 if _merge == 1 
replace ridger = 0 if _merge == 1 
replace sickle = 0 if _merge == 1 
replace seeder = 0 if _merge == 1 
replace kadiandou = 0 if _merge == 1 
replace fanting = 0 if _merge == 1 
replace solarplanels = 0 if _merge == 1 
replace other = 0 if _merge == 1 

drop _merge 

merge 1:1 hhid using `number_of_plots_midline' 

drop _merge 

merge 1:1 hhid using `production_midline'

drop _merge 

merge 1:1 hhid using `income_midline'

drop _merge 

merge 1:1 hhid using `milk_sales_midline'

gen any_milk_sales = _merge == 3 

replace milk_sales = 0 if _merge == 1

drop _merge 

merge 1:1 hhid using "$auctions/tlu_midline.dta"

drop _merge

*** bring in community price data *** 
gen hhid_village = substr(hhid, 1, 4)

merge m:1 hhid_village using "$midline/Complete_Midline_Community.dta"

drop _merge 

merge 1:1 hhid using `plot_level_ag_midline' 

drop _merge 

merge 1:1 hhid using `manure_use_midline' 

replace manure_kgs = 0 if _merge == 1 & agri_6_14 == 1

drop _merge 

merge 1:1 hhid using "$asset_index/pooled_asset_index_var.dta"

drop if _merge == 2 

drop _merge 

rename asset_index_std1 asset_index_std

merge 1:1 hhid using `slackhours_midline'

drop _merge 

*** clean price data *** 
rename q63_1 urea_price 
rename q63_2 manure_price
rename q63_3 rice_price
rename q63_4 corn_price
rename q63_5 millet_price
rename q63_6 sorghum_price
rename q63_7 cowpea_price
rename q63_8 tomato_price
rename q63_9 onion_price
rename q63_10 peanut_price

replace manure_price = . if manure_price == -9
replace corn_price = . if corn_price == -9
replace millet_price = . if millet_price == -9
replace sorghum_price = . if sorghum_price == -9
replace cowpea_price = . if cowpea_price == -9
replace tomato_price = . if tomato_price == -9
replace onion_price = . if onion_price == -9
replace peanut_price = . if peanut_price == -9

egen med_manure_price = median(manure_price)
replace manure_price = med_manure_price if manure_price == . 
egen med_corn_price = median(corn_price)
replace corn_price = med_corn_price if corn_price == . 
egen med_millet_price = median(millet_price)
replace millet_price = med_millet_price if millet_price == . 
egen med_sorghum_price = median(sorghum_price)
replace sorghum_price = med_sorghum_price if sorghum_price == .
egen med_cowpea_price = median(cowpea_price)
replace cowpea_price = med_cowpea_price if cowpea_price == .
egen med_tomato_price = median(tomato_price)
replace tomato_price = med_tomato_price if tomato_price == .   
egen med_onion_price = median(onion_price)
replace onion_price = med_onion_price if onion_price == . 
egen med_cassava_price = median(cassava_price)
egen med_sweetpotato_price = median(sweetpotato_price)
egen med_yam_price = median(yam_price)
egen med_carrot_price = median(carrot_price)
egen med_cucumber_price = median(cucumber_price)
egen med_pepper_price = median(pepper_price)
egen med_bean_price = median(bean_price)
egen med_pea_price = median(pea_price)
egen med_lentil_price = median(lentil_price)

*** create value of output variable *** 
gen value_rice_prod = rice_prod * rice_price 
gen value_corn_prod = maize_prod * corn_price
gen value_millet_prod = millet_prod * millet_price 
gen value_sorghum_prod = sorghum_prod * sorghum_price 
gen value_cowpea_prod = cowpea_prod * cowpea_price
gen value_tomato_prod = tomato_prod * tomato_price
gen value_onion_prod = onion_prod * onion_price 
gen value_peanut_prod = peanut_prod * peanut_price
gen value_cassava_prod = cassava_prod * cassava_price
gen value_sweetpotato_prod = sweetpotato_prod * sweetpotato_price
gen value_yam_prod = yam_prod * yam_price
gen value_carrot_prod = carrot_prod * carrot_price
gen value_cucumber_prod = cucumber_prod * cucumber_price
gen value_pepper_prod = pepper_prod * pepper_price
gen value_bean_prod = bean_prod * bean_price
gen value_pea_prod = pea_prod * pea_price
gen value_lentil_prod = lentil_prod * lentil_price

egen total_value_production = rowtotal(value_rice_prod value_corn_prod value_millet_prod value_sorghum_prod value_cowpea_prod value_tomato_prod value_onion_prod value_peanut_prod value_cassava_prod value_sweetpotato_prod value_yam_prod value_carrot_prod value_cucumber_prod value_pepper_prod value_bean_prod value_pea_prod value_lentil_prod)
egen total_production_hectares = rowtotal(rice_hectares maize_hectares millet_hectares sorghum_hectares cowpea_hectares tomato_hectares onion_hectares peanut_hectares cassava_hectares sweetpotato_hectares yam_hectares carrot_hectares cucumber_hectares pepper_hectares bean_hectares pea_hectares lentil_hectares)

egen number_equipment = rowtotal(plow harrow draftanimals cart tractor sprayer motorpumps hoes ridger sickle seeder kadiandou fanting other)
egen number_mech_equip = rowtotal(plow harrow tractor sprayer motorpumps)

gen ag_wage = (agri_6_14 == 1 & agri_income_01 == 1)

gen any_livestock_income = (tot_livestock_sales > 0) 

egen total_ag_hours = rowtotal(ag_hours planting_hours growth_hours harvest_hours)

egen total_fert = rowtotal(urea_kgs phosphate_kgs npk_kgs other_kgs)

keep hhid agri_6_14 agri_6_15 total_value_production total_production_hectares total_ag_hours total_fert collective_manage rice agri_6_30_ agri_6_34_comp_ agri_6_34_ agri_income_15 agri_income_16 number_mech_equip TLU any_milk_sales milk_sales agri_income_01 daily_wage ag_wage hhhead* rice crop_types child members asset_index_std slack_hours urea_price  

tempfile shadow_wage_midline
save `shadow_wage_midline'

*** create histogram of number of plots at baseline and midline *** 
use `number_of_plots', clear 

gen year = 2024 

append using `number_of_plots_midline' 

replace year = 2025 if year == . 

twoway (histogram agri_6_15 if year == 2024, color(gray%50) width(0.5)) (histogram agri_6_15 if year == 2025, fcolor(none) lcolor(red) width(0.5)), legend(order(1 "Baseline" 2 "Midline") cols(2) position(6)) xtitle("Number of Plots")
graph export "$auctions/hist_number_of_plots.eps", as(eps) replace

*** append data together *** 
use `shadow_wage_baseline', clear 

gen round = 1  

append using `shadow_wage_midline'

replace round = 2 if round == . 

*** winsorize data *** 
egen value_prod_99 = pctile(total_value_production), p(99)
gen value_prod_1 = total_value_production 
replace value_prod_1 = value_prod_99 if total_value_production > value_prod_99 
replace value_prod_1 = . if total_value_production == . 

egen value_prod_95 = pctile(total_value_production), p(95)
gen value_prod_5 = total_value_production 
replace value_prod_5 = value_prod_95 if total_value_production > value_prod_95 
replace value_prod_5 = . if total_value_production == . 

egen value_prod_90 = pctile(total_value_production), p(90)
gen value_prod_10 = total_value_production 
replace value_prod_10 = value_prod_90 if total_value_production > value_prod_90 
replace value_prod_10 = . if total_value_production == . 

egen prod_hect_99 = pctile(total_production_hectares), p(99)
gen prod_hect_1 = total_production_hectares 
replace prod_hect_1 = prod_hect_99 if total_production_hectares > prod_hect_99 
replace prod_hect_1 = . if total_production_hectares == . 

egen prod_hect_95 = pctile(total_production_hectares), p(95)
gen prod_hect_5 = total_production_hectares 
replace prod_hect_5 = prod_hect_95 if total_production_hectares > prod_hect_95 
replace prod_hect_5 = . if total_production_hectares == . 

egen prod_hect_90 = pctile(total_production_hectares), p(90)
gen prod_hect_10 = total_production_hectares 
replace prod_hect_10 = prod_hect_99 if total_production_hectares > prod_hect_90 
replace prod_hect_10 = . if total_production_hectares == . 

egen ag_hours_99 = pctile(total_ag_hours), p(99)
gen ag_hours_1 = total_ag_hours 
replace ag_hours_1 = ag_hours_99 if total_ag_hours > ag_hours_99 
replace ag_hours_1 = . if total_ag_hours == . 

egen ag_hours_95 = pctile(total_ag_hours), p(95)
gen ag_hours_5 = total_ag_hours 
replace ag_hours_5 = ag_hours_95 if total_ag_hours > ag_hours_95 
replace ag_hours_5 = . if total_ag_hours == .

egen ag_hours_90 = pctile(total_ag_hours), p(90)
gen ag_hours_10 = total_ag_hours 
replace ag_hours_10 = ag_hours_90 if total_ag_hours > ag_hours_90 
replace ag_hours_10 = . if total_ag_hours == .

egen fert_99 = pctile(total_fert), p(99)
gen fert_1 = total_fert 
replace fert_1 = fert_99 if total_fert > fert_99 
replace fert_1 = . if total_fert == . 

egen fert_95 = pctile(total_fert), p(95)
gen fert_5 = total_fert 
replace fert_5 = fert_95 if total_fert > fert_95 
replace fert_5 = . if total_fert == . 

egen fert_90 = pctile(total_fert), p(90)
gen fert_10 = total_fert 
replace fert_10 = fert_90 if total_fert > fert_90 
replace fert_10 = . if total_fert == . 

egen TLU_99 = pctile(TLU), p(99)
gen TLU_1 = TLU
replace TLU_1 = TLU_99 if TLU > TLU_99 
replace TLU_1 = . if TLU == . 

egen TLU_95 = pctile(TLU), p(95)
gen TLU_5 = TLU
replace TLU_5 = TLU_95 if TLU > TLU_95 
replace TLU_5 = . if TLU == . 

egen TLU_90 = pctile(TLU), p(90)
gen TLU_10 = TLU
replace TLU_10 = TLU_90 if TLU > TLU_90 
replace TLU_10 = . if TLU == . 

egen daily_wage_99 = pctile(daily_wage), p(99)
gen daily_wage_1 = daily_wage 
replace daily_wage_1 = daily_wage_99 if daily_wage > daily_wage_99 
replace daily_wage_1 = . if daily_wage == . 

egen daily_wage_95 = pctile(daily_wage), p(95)
gen daily_wage_5 = daily_wage 
replace daily_wage_5 = daily_wage_95 if daily_wage > daily_wage_95 
replace daily_wage_5 = . if daily_wage == . 

egen daily_wage_90 = pctile(daily_wage), p(90)
gen daily_wage_10 = daily_wage 
replace daily_wage_10 = daily_wage_90 if daily_wage > daily_wage_90 
replace daily_wage_10 = . if daily_wage == . 

*** label variables for production summary stats *** 
label variable value_prod_1 "Total Value of Crop Production (FCFA)"
label variable prod_hect_1 "Hectares in Production"
label variable ag_hours_1 "Total Household Hours Spent on Agriculture"
label variable number_mech_equip "Total Number of Pieces of Mechanical Ag Equipment"
label variable agri_6_14 "Cultivate Land (1 = Yes)"
label variable agri_6_15 "Number of Plots"
label variable collective_manage "Number of Plots Collectively Managed (1 = Yes)"
label variable rice "Number of Plots where Main Crop is Rice"
label variable agri_6_30_ "Number of Plots that Used Manure"
label variable agri_6_34_comp_ "Number of Plots that Used Compost"
label variable agri_6_34_ "Number of Plots that Used Household Waste"
label variable fert_1 "Total Fertilizer Used (kgs)"
label variable TLU_1 "Livestock Owned (TLU)"
label variable agri_income_01 "Household Member Paid Work (1 = Yes)"
label variable daily_wage_10 "Daily Wage for Paid Work (FCFA)"
label variable agri_income_15 "Has Hired Ag Labor (1 = Yes)"
label variable agri_income_16 "Number of Hired Laborers"
label variable ag_wage "Household Does Agriculture and Paid Work (1 = Yes)"
label variable hhhead_female "Household Head Female (1 = Yes)"
label variable hhhead_no_education "Household Head No Education (1 = Yes)"
label variable hhhead_age "Household Head Age"
label variable rice "Household Grows Rice"
label variable crop_types "Number of Crops Grown"
label variable members "Household Size"
label variable child "Number of Children"
label variable asset_index_std "Standardized Asset Index"

estpost sum agri_6_14 agri_6_15 value_prod_1 prod_hect_1 ag_hours_1 fert_1 collective_manage rice agri_6_30_ agri_6_34_comp_ agri_6_34_ agri_income_15 agri_income_16 number_mech_equip TLU_1 agri_income_01 daily_wage_10 ag_wage hhhead_age hhhead_female hhhead_no_education members child rice crop_types asset_index_std

esttab using "$auctions/household_level_production_sum_stats.tex", cells("count mean(fmt(%9.3f)) sd(fmt(%9.3f)) min max") noobs nonumber label replace

*** create indicator variables *** 
gen manure = (agri_6_30_ > 0)
replace manure = 0 if agri_6_14 == 0
gen compost = (agri_6_34_comp_ > 0)
replace compost = 0 if agri_6_14 == 0
gen hhwaste = (agri_6_34_ > 0)
replace hhwaste = 0 if agri_6_14 == 0

*** create village indicator *** 
gen hhid_village = substr(hhid, 1, 4)

*** check correspondence between use manure and TLU for households who cultivate ***
corr manure TLU if agri_6_14 == 1 
corr agri_6_30_ TLU if agri_6_14 == 1

twoway scatter TLU manure if agri_6_14 == 1
twoway scatter TLU agri_6_30_ if agri_6_14 == 1

reg manure TLU if agri_6_14 == 1
eststo manure 

reg agri_6_30_ TLU if agri_6_14 == 1
eststo plots 

esttab manure plots using "$auctions/corr_manure_tlu.tex", se star(* 0.1 ** 0.05 *** 0.01) replace 

*** save clean dataset *** 
save "$auctions/complete_data_clean.dta", replace 
