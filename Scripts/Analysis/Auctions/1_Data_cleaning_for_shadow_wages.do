*** Data cleaning for shadow wage estimation *** 
*** File Created By: Molly Doruska ***
*** File Last Updated By: Molly Doruska ***
*** File Last Updated On: May 2, 2025 ***

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
global midline "$master\Data\_CRDES_CleanData\Midline\Deidentified"

*** clean variables to use in shadow wage estimation *** 
*** clean basic household roster data *** 
*** baseline data *** 

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
save "$auctions\water_time_12month.dta", replace 

*** clean hh_21 (7 day recall) on water time use data *** 

*** import household roster data *** 
use "$data\Complete_Baseline_Household_Roster", clear   

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
save "$auctions\water_time_7days.dta", replace 

*** import agricultural plot level data *** 
use "$data\Complete_Baseline_Agriculture", clear   

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

*** save clean plot level data *** 
save "$auctions\plot_level_ag.dta", replace 

*** clean agriculture equipment data *** 

*** import agricultural plot level data *** 
use "$data\Complete_Baseline_Agriculture", clear   

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
 
save "$auctions\assets.dta", replace 
 
*** clean non-standard unit data on compost use *** 

*** import agricultural plot level data *** 
use "$data\Complete_Baseline_Agriculture", clear   

keep hhid agri_6_32_* agri_6_33_*

reshape long agri_6_32_ agri_6_33_ agri_6_33_o_ , i(hhid) j(plot)

drop if agri_6_32_ == . & agri_6_33_ == . & agri_6_33_o_ == . 

*** extract off village ID to pull in non-standard unit measures *** 
gen hhid_village = substr(hhid, 1, 4)

*** merge in non-standard unit measures ***
merge m:1 hhid_village using "$midline\Complete_Midline_Community.dta"

drop if _merge == 2 

drop _merge 

*** calculate manure use in kgs *** 
gen manure_kgs = agri_6_32_ 
replace manure_kgs = agri_6_32 * unit_convert_1 if agri_6_33_ == 2 
replace manure_kgs = agri_6_32 * unit_convert_2 if agri_6_33_ == 3 

keep hhid plot manure_kgs 

save "$auctions\manure_use.dta", replace 

*** clean number of plots data *** 

*** import agricultural plot level data *** 
use "$data\Complete_Baseline_Agriculture", clear   

keep hhid agri_6_14 agri_6_15

replace agri_6_14 = . if agri_6_14 == 2 

replace agri_6_15 = 0 if agri_6_14 == 0

save "$auctions\number_of_plots.dta", replace  

*** clean production data *** 
use "$data\Complete_Baseline_Production.dta", clear   

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
replace sorghum_hectares = . if cerealsposition_3 == 4
replace sorghum_hectares = . if sorghum_hectares == -9 

gen sorghum_prod = cereals_02_2 
replace sorghum_prod = 0 if cereals_consumption_2 == 0 
replace sorghum_prod = . if cerealsposition_2 == 3 
replace sorghum_prod = . if sorghum_prod == -9  

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

keep hhid rice_hectares rice_prod maize_hectares maize_prod millet_hectares millet_prod sorghum_hectares sorghum_prod cassava_hectares cassava_prod sweetpotato_hectares sweetpotato_prod potato_hectares potato_prod yam_hectares yam_prod taro_hectares taro_prod tomato_hectares tomato_prod carrot_hectares carrot_prod onion_hectares onion_prod cucumber_hectares cucumber_prod pepper_hectares pepper_prod peanut_hectares peanut_prod bean_hectares bean_prod pea_hectares pea_prod lentil_hectares lentil_prod

save "$auctions\production.dta", replace 

*** import income module data *** 
use "$data\Complete_Baseline_Income.dta", clear  

*** clean household level income data *** 
keep hhid agri_income_01 agri_income_02 agri_income_03 agri_income_04 agri_income_05 agri_income_06 agri_income_15 agri_income_16 agri_income_17 agri_income_18 agri_income_19  

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

save "$auctions\income.dta", replace 

*** merge together entire household dataset *** 
use "$auctions\main_hh_baseline.dta", clear 

merge 1:1 hhid using "$auctions\water_time_12month.dta" 

drop _merge 

merge 1:1 hhid using "$auctions\water_time_7days.dta"

replace fetch_water_hh_7d_act = 0 if _merge == 1 
replace water_livestock_7d_act = 0 if _merge == 1 
replace fetch_water_ag_7d_act = 0 if _merge == 1 
replace wash_clothes_7d_act = 0 if _merge == 1 
replace dishes_7d_act = 0 if _merge == 1 
replace harvest_veg_7d_act = 0 if _merge == 1 
replace swim_7d_act = 0 if _merge == 1
replace play_7d_act = 0 if _merge == 1

drop _merge 

merge 1:1 hhid using "$auctions\assets.dta"

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

merge 1:1 hhid using "$auctions\number_of_plots.dta"

drop _merge 

merge 1:1 hhid using "$auctions\production.dta"

drop _merge 

merge 1:1 hhid using "$auctions\income.dta"

drop _merge 

*** bring in community price data *** 
gen hhid_village = substr(hhid, 1, 4)

merge m:1 hhid_village using "$data\Complete_Baseline_Community.dta"

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
replace onion_price = . if peanut_price == -9

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

*** create value of output variable *** 
gen value_rice_prod = rice_prod * rice_price 
gen value_corn_prod = maize_prod * corn_price
gen value_millet_prod = millet_prod * millet_price 
gen value_sorghum_prod = sorghum_prod * sorghum_price 
gen value_cowpea_prod = bean_prod * cowpea_price
gen value_tomato_prod = tomato_prod * tomato_price
gen value_onion_prod = onion_prod * onion_price 
gen value_peanut_prod = peanut_prod * peanut_price

egen total_value_production = rowtotal(value_rice_prod value_corn_prod value_millet_prod value_sorghum_prod value_cowpea_prod value_tomato_prod value_onion_prod value_peanut_prod)
egen total_production_hectares = rowtotal(rice_hectares maize_hectares millet_hectares sorghum_hectares bean_hectares tomato_hectares onion_hectares peanut_hectares)

egen number_equipment = rowtotal(plow harrow draftanimals cart tractor sprayer motorpumps hoes ridger sickle seeder kadiandou fanting other)

gen ag_wage = (agri_6_14 == 1 & agri_income_01 == 1)

*** label variables for production summary stats *** 
label variable total_value_production "Total Value of Production"
label variable total_production_hectares "Hectares in Production"
label variable chore_hours "Family Hours Spent on Chores (7 days)"
label variable water_hours "Family Hours Spent Fetching Water (7 days)"
label variable ag_hours "Family Hours Spent on Ag (7 days)"
label variable planting_hours "Family Hours Spent on Planting (7 days)"
label variable growth_hours "Family Hours Spent on Ag Peak Growth (7 days)"
label variable harvest_hours "Family Hours Spent on Harvest (7 days)"
label variable tradehh_hours "Family Hours Spent on Working in the Home (7 days)"
label variable tradeoutside_hours "Family Hours Spent on Working Outside the Home (7 days)"
label variable fertilizer_hours_7days "Family Hours Spent on Fertilizer (7 days)"
label variable number_equipment "Total Number of Pieces of Ag Equipment"
label variable agri_6_14 "Cultivate Land (1 = Yes)"
label variable agri_6_15 "Number of Plots"
label variable agri_income_01 "Household Member Paid Work (1 = Yes)"
label variable daily_wage "Daily Wage for Paid Work (FCFA)"
label variable agri_income_15 "Has Hired Ag Labor (1 = Yes)"
label variable agri_income_16 "Number of Hired Laborers"
label variable ag_wage "Household Does Agriculture and Paid Work (1 = Yes)"

estpost sum agri_6_14 agri_6_15 total_value_production total_production_hectares chore_hours water_hours ag_hours planting_hours growth_hours harvest_hours tradehh_hours tradeoutside_hours fertilizer_hours_7days agri_income_15 agri_income_16 number_equipment agri_income_01 daily_wage ag_wage 

esttab using "$auctions\household_level_production_sum_stats.tex", cells("count mean(fmt(%9.3f)) sd(fmt(%9.3f)) min max") noobs nonumber label replace

*** summary stats for plot level variables *** 
use "$auctions\plot_level_ag.dta", clear

merge 1:1 hhid plot using "$auctions\manure_use.dta"

replace manure_kgs = 0 if _merge == 1 

drop _merge 

label variable collective_manage "Plot is Collectively Managed (1 = Yes)"
label variable rice "Main Crop is Rice (1 = Yes)"
label variable maize "Main Crop is Maize (1 = Yes)"
label variable millet "Main Crop is Millet (1 = Yes)"
label variable sorghum "Main Crop is Sorghum (1 = Yes)"
label variable cowpea "Main Crop is Cowpea (1 = Yes)"
label variable cassava "Main Crop is Cassava (1 = Yes)"
label variable sweetpotato "Main Crop is Sweet Potato (1 = Yes)"
label variable potato "Main Crop is Potato (1 = Yes)"
label variable yam "Main Crop is Yam (1 = Yes)"
label variable taro "Main Crop is Taro (1 = Yes)"
label variable tomato "Main Crop is Tomatoes (1 = Yes)"
label variable carrot "Main Crop is Carrots (1 = Yes)"
label variable onion "Main Crop is Onions (1 = Yes)"
label variable cucumber "Main Crop is Cucumbers (1 = Yes)"
label variable pepper "Main Crop is Peppers (1 = Yes)"
label variable peanut "Main Crop is Peanuts (1 = Yes)"
label variable bean "Main Crop is Beans (1 = Yes)"
label variable pea "Main Crop is Peas (1 = Yes)"
label variable other "Other Main Crop (1 = Yes)"
label variable plot_size_ha "Plot Size (hectares)"
label variable agri_6_30_ "Used Manure on the Plot (1 = Yes)"
label variable agri_6_34_comp_ "Used Compost on the Plot (1 = Yes)"
label variable agri_6_34_ "Used Household Waste on the Plot (1 = Yes)"
label variable agri_6_36_ "Used Fertilizer on the Plot (1 = Yes)"
label variable urea_kgs "Urea Used on Plot (kgs)"
label variable phosphate_kgs "Phosphates Used on Plot (kgs)"
label variable npk_kgs "NPK Used on Plot (kgs)"
label variable other_kgs "Other Chemical Fertilizer Used on Plot (kgs)"

estpost sum collective_manage rice maize millet sorghum cowpea cassava sweetpotato potato yam taro tomato carrot onion cucumber pepper peanut bean pea other plot_size_ha agri_6_30_ agri_6_34_comp_ agri_6_34_ agri_6_36_ urea_kgs phosphate_kgs npk_kgs other_kgs

esttab using "$auctions\plot_level_sum_stats.tex", cells("count mean(fmt(%9.3f)) sd(fmt(%9.3f)) min max") noobs nonumber label replace

*** midline data ***
*** import household roster data *** 
use "$midline\Complete_Midline_Household_Roster", clear   

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
save "$auctions\main_hh_midline.dta", replace 
  
*** clean hh_13 (12 month recall) on water time use data *** 

*** import household roster data *** 
use "$midline\Complete_Midline_Household_Roster", clear   

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
save "$auctions\water_time_12month_midline.dta", replace 

*** clean hh_21 (7 day recall) on water time use data *** 

*** import household roster data *** 
use "$midline\Complete_Midline_Household_Roster", clear   

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
save "$auctions\water_time_7days_midline.dta", replace 

*** import agricultural plot level data *** 
use "$midline\Complete_Midline_Agriculture", clear   

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

*** save clean plot level data *** 
save "$auctions\plot_level_ag_midline.dta", replace 

*** clean agriculture equipment data *** 

*** import agricultural plot level data *** 
use "$midline\Complete_Midline_Agriculture", clear   

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
 
save "$auctions\assets_midline.dta", replace 
 
*** clean non-standard unit data on compost use *** 

*** import agricultural plot level data *** 
use "$midline\Complete_Midline_Agriculture", clear   

keep hhid agri_6_32_* agri_6_33_*

reshape long agri_6_32_ agri_6_33_ agri_6_33_o_ , i(hhid) j(plot)

drop if agri_6_32_ == . & agri_6_33_ == . & agri_6_33_o_ == . 

*** extract off village ID to pull in non-standard unit measures *** 
gen hhid_village = substr(hhid, 1, 4)

*** merge in non-standard unit measures ***
merge m:1 hhid_village using "$midline\Complete_Midline_Community.dta"

drop if _merge == 2 

drop _merge 

*** calculate manure use in kgs *** 
gen manure_kgs = agri_6_32_ 
replace manure_kgs = agri_6_32 * unit_convert_1 if agri_6_33_ == 2 
replace manure_kgs = agri_6_32 * unit_convert_2 if agri_6_33_ == 3 

keep hhid plot manure_kgs 

save "$auctions\manure_use_midline.dta", replace 

*** clean number of plots data *** 

*** import agricultural plot level data *** 
use "$midline\Complete_Midline_Agriculture", clear   

keep hhid agri_6_14 agri_6_15

replace agri_6_14 = . if agri_6_14 == 2 

replace agri_6_15 = 0 if agri_6_14 == 0

save "$auctions\number_of_plots_midline.dta", replace  

*** clean production data *** 
use "$midline\Complete_Midline_Production.dta", clear   

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
replace sorghum_prod = 0 if cereals_consumption_2 == 0 
replace sorghum_prod = . if sorghum_prod == -9  

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

rename legumes_01_5 pepper_hectares 
replace pepper_hectares = 0 if legumes_consumption_5 == 0 
replace pepper_hectares = cucumber_hectares if legumesposition_4 == 5
replace pepper_hectares = . if pepper_hectares == -9 

rename legumes_02_5 pepper_prod 
replace pepper_prod = 0 if legumes_consumption_5 == 0 
replace pepper_prod = cucumber_prod if legumesposition_4 == 5
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

keep hhid rice_hectares rice_prod maize_hectares maize_prod millet_hectares millet_prod sorghum_hectares sorghum_prod cassava_hectares cassava_prod sweetpotato_hectares sweetpotato_prod potato_hectares potato_prod yam_hectares yam_prod taro_hectares taro_prod tomato_hectares tomato_prod carrot_hectares carrot_prod onion_hectares onion_prod cucumber_hectares cucumber_prod pepper_hectares pepper_prod peanut_hectares peanut_prod bean_hectares bean_prod pea_hectares pea_prod lentil_hectares lentil_prod

save "$auctions\production_midline.dta", replace 

*** import income module data *** 
use "$midline\Complete_Midline_Income.dta", clear  

*** clean household level income data *** 
keep hhid agri_income_01 agri_income_02 agri_income_03 agri_income_04 agri_income_05 agri_income_06 agri_income_15 agri_income_16 agri_income_17 agri_income_18 agri_income_19  

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

save "$auctions\income_midline.dta", replace 

*** merge together entire household dataset *** 
use "$auctions\main_hh_midline.dta", clear 

merge 1:1 hhid using "$auctions\water_time_12month_midline.dta" 

drop _merge 

merge 1:1 hhid using "$auctions\water_time_7days_midline.dta"

replace fetch_water_hh_7d_act = 0 if _merge == 1 
replace water_livestock_7d_act = 0 if _merge == 1 
replace fetch_water_ag_7d_act = 0 if _merge == 1 
replace wash_clothes_7d_act = 0 if _merge == 1 
replace dishes_7d_act = 0 if _merge == 1 
replace harvest_veg_7d_act = 0 if _merge == 1 
replace swim_7d_act = 0 if _merge == 1
replace play_7d_act = 0 if _merge == 1

drop _merge 

merge 1:1 hhid using "$auctions\assets_midline.dta"

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

merge 1:1 hhid using "$auctions\number_of_plots_midline.dta"

drop _merge 

merge 1:1 hhid using "$auctions\production_midline.dta"

drop _merge 

merge 1:1 hhid using "$auctions\income_midline.dta"

drop _merge 

*** bring in community price data *** 
gen hhid_village = substr(hhid, 1, 4)

merge m:1 hhid_village using "$midline\Complete_Midline_Community.dta"

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
replace onion_price = . if peanut_price == -9

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

*** create value of output variable *** 
gen value_rice_prod = rice_prod * rice_price 
gen value_corn_prod = maize_prod * corn_price
gen value_millet_prod = millet_prod * millet_price 
gen value_sorghum_prod = sorghum_prod * sorghum_price 
gen value_cowpea_prod = bean_prod * cowpea_price
gen value_tomato_prod = tomato_prod * tomato_price
gen value_onion_prod = onion_prod * onion_price 
gen value_peanut_prod = peanut_prod * peanut_price

egen total_value_production = rowtotal(value_rice_prod value_corn_prod value_millet_prod value_sorghum_prod value_cowpea_prod value_tomato_prod value_onion_prod value_peanut_prod)
egen total_production_hectares = rowtotal(rice_hectares maize_hectares millet_hectares sorghum_hectares bean_hectares tomato_hectares onion_hectares peanut_hectares)

egen number_equipment = rowtotal(plow harrow draftanimals cart tractor sprayer motorpumps hoes ridger sickle seeder kadiandou fanting other)

gen ag_wage = (agri_6_14 == 1 & agri_income_01 == 1)

*** label variables for production summary stats *** 
label variable total_value_production "Total Value of Production"
label variable total_production_hectares "Hectares in Production"
label variable chore_hours "Family Hours Spent on Chores (7 days)"
label variable water_hours "Family Hours Spent Fetching Water (7 days)"
label variable ag_hours "Family Hours Spent on Ag (7 days)"
label variable planting_hours "Family Hours Spent on Planting (7 days)"
label variable growth_hours "Family Hours Spent on Ag Peak Growth (7 days)"
label variable harvest_hours "Family Hours Spent on Harvest (7 days)"
label variable tradehh_hours "Family Hours Spent on Working in the Home (7 days)"
label variable tradeoutside_hours "Family Hours Spent on Working Outside the Home (7 days)"
label variable fertilizer_hours_7days "Family Hours Spent on Fertilizer (7 days)"
label variable number_equipment "Total Number of Pieces of Ag Equipment"
label variable agri_6_14 "Cultivate Land (1 = Yes)"
label variable agri_6_15 "Number of Plots"
label variable agri_income_01 "Household Member Paid Work (1 = Yes)"
label variable daily_wage "Daily Wage for Paid Work (FCFA)"
label variable agri_income_15 "Has Hired Ag Labor (1 = Yes)"
label variable agri_income_16 "Number of Hired Laborers"
label variable ag_wage "Household Does Agriculture and Paid Work (1 = Yes)"

estpost sum agri_6_14 agri_6_15 total_value_production total_production_hectares chore_hours water_hours ag_hours planting_hours growth_hours harvest_hours tradehh_hours tradeoutside_hours fertilizer_hours_7days agri_income_15 agri_income_16 number_equipment agri_income_01 daily_wage ag_wage

esttab using "$auctions\household_level_production_sum_stats_midline.tex", cells("count mean(fmt(%9.3f)) sd(fmt(%9.3f)) min max") noobs nonumber label replace

*** summary stats for plot level variables *** 
use "$auctions\plot_level_ag_midline.dta", clear

merge 1:1 hhid plot using "$auctions\manure_use_midline.dta"

replace manure_kgs = 0 if _merge == 1 

drop _merge 

label variable collective_manage "Plot is Collectively Managed (1 = Yes)"
label variable rice "Main Crop is Rice (1 = Yes)"
label variable maize "Main Crop is Maize (1 = Yes)"
label variable millet "Main Crop is Millet (1 = Yes)"
label variable sorghum "Main Crop is Sorghum (1 = Yes)"
label variable cowpea "Main Crop is Cowpea (1 = Yes)"
label variable cassava "Main Crop is Cassava (1 = Yes)"
label variable sweetpotato "Main Crop is Sweet Potato (1 = Yes)"
label variable potato "Main Crop is Potato (1 = Yes)"
label variable yam "Main Crop is Yam (1 = Yes)"
label variable taro "Main Crop is Taro (1 = Yes)"
label variable tomato "Main Crop is Tomatoes (1 = Yes)"
label variable carrot "Main Crop is Carrots (1 = Yes)"
label variable onion "Main Crop is Onions (1 = Yes)"
label variable cucumber "Main Crop is Cucumbers (1 = Yes)"
label variable pepper "Main Crop is Peppers (1 = Yes)"
label variable peanut "Main Crop is Peanuts (1 = Yes)"
label variable bean "Main Crop is Beans (1 = Yes)"
label variable pea "Main Crop is Peas (1 = Yes)"
label variable other "Other Main Crop (1 = Yes)"
label variable plot_size_ha "Plot Size (hectares)"
label variable agri_6_30_ "Used Manure on the Plot (1 = Yes)"
label variable agri_6_34_comp_ "Used Compost on the Plot (1 = Yes)"
label variable agri_6_34_ "Used Household Waste on the Plot (1 = Yes)"
label variable agri_6_36_ "Used Fertilizer on the Plot (1 = Yes)"
label variable urea_kgs "Urea Used on Plot (kgs)"
label variable phosphate_kgs "Phosphates Used on Plot (kgs)"
label variable npk_kgs "NPK Used on Plot (kgs)"
label variable other_kgs "Other Chemical Fertilizer Used on Plot (kgs)"

estpost sum collective_manage rice maize millet sorghum cowpea cassava sweetpotato potato yam taro tomato carrot onion cucumber pepper peanut bean pea other plot_size_ha agri_6_30_ agri_6_34_comp_ agri_6_34_ agri_6_36_ urea_kgs phosphate_kgs npk_kgs other_kgs

esttab using "$auctions\plot_level_sum_stats_midline.tex", cells("count mean(fmt(%9.3f)) sd(fmt(%9.3f)) min max") noobs nonumber label replace

*** create histogram of number of plots at baseline and midline *** 
use "$auctions\number_of_plots.dta", clear 

gen year = 2024 

append using "$auctions\number_of_plots_midline.dta" 

replace year = 2025 if year == . 

twoway (histogram agri_6_15 if year == 2024, color(gray%50) width(0.5)) (histogram agri_6_15 if year == 2025, fcolor(none) lcolor(red) width(0.5)), legend(order(1 "Baseline" 2 "Midline") cols(2) position(6)) xtitle("Number of Plots")
graph export "$auctions\hist_number_of_plots.eps", as(eps) replace