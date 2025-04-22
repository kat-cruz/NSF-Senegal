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
global midline "$master\Data\_CRDES_CleanData\Midline\Deidentified"

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
 
save "$auction\assets.dta", replace 
 
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

save "$auctions\number_of_plots.dta", clear 

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
replace maize_prod = . if maize_prod == -9  
