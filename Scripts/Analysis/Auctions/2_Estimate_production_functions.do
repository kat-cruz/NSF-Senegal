*** Estimate production functions for shadow wages *** 
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
global auctions "$master/Output/Analysis/Auctions_Shadow_Wages"

*** import complete dataset for production function estimation *** 
use "$auctions/complete_data_clean.dta", clear 

*** demean variables *** 
egen land_mean = mean(prod_hect_1)
egen hh_labor_mean = mean(ag_hours_1)
egen fert_mean = mean(fert_1)
egen TLU_mean = mean(TLU)
egen hired_labor_mean = mean(agri_income_16)
egen equip_mean = mean(number_mech_equip)
egen value_mean = mean(value_prod_1)

gen dm_land = prod_hect_1 - land_mean 
gen dm_hh_labor = ag_hours_1 - hh_labor_mean
gen dm_fert = fert_1 - fert_mean 
gen dm_TLU = TLU_1 - TLU_mean
gen dm_hired_labor = agri_income_16 - hired_labor_mean
gen dm_equip = number_mech_equip - equip_mean
gen dm_value = value_prod_1 - value_mean

*** create powers and interactions for estimation *** 
gen land_sq = prod_hect_1 * prod_hect_1
gen hh_labor_sq = ag_hours_1 * ag_hours_1
gen fert_sq = fert_1 * fert_1 
gen TLU_sq = TLU_1 * TLU_1  
gen hired_labor_sq = agri_income_16 * agri_income_16 
gen equip_sq = number_mech_equip * number_mech_equip

egen land_sq_mean = mean(land_sq)
egen hh_labor_sq_mean = mean(hh_labor_sq)
egen fert_sq_mean = mean(fert_sq)
egen TLU_sq_mean = mean(TLU_sq)
egen hired_labor_sq_mean = mean(hired_labor_sq)
egen equip_sq_mean = mean(equip_sq)

gen dm_land_sq = land_sq - land_sq_mean
gen dm_hh_labor_sq = hh_labor_sq - hh_labor_sq_mean
gen dm_fert_sq = fert_sq - fert_sq_mean 
gen dm_TLU_sq = TLU_sq - TLU_sq_mean
gen dm_hired_labor_sq = hired_labor_sq - hired_labor_sq_mean
gen dm_equip_sq = equip_sq - equip_sq_mean

gen land_hh_labor = prod_hect_1 * ag_hours_1
gen land_fert = prod_hect_1 * fert_1
gen land_TLU = prod_hect_1 * TLU_1
gen land_hired_labor = prod_hect_1 * agri_income_16
gen land_equip = prod_hect_1 * number_mech_equip
gen hh_labor_fert = ag_hours_1 * fert_1
gen hh_labor_TLU = ag_hours_1 * TLU_1
gen hh_labor_hired_labor = ag_hours_1 * agri_income_16
gen hh_labor_equip = ag_hours_1 * number_mech_equip
gen fert_TLU = fert_1 * TLU_1
gen fert_hired_labor = fert_1 * agri_income_16
gen fert_equip = fert_1 * number_mech_equip
gen TLU_hired_labor = TLU_1 * agri_income_16
gen TLU_equip = TLU_1 * number_mech_equip
gen hired_labor_equip = agri_income_16 * number_mech_equip

egen land_hh_labor_mean = mean(land_hh_labor)
egen land_fert_mean = mean(land_fert)
egen land_TLU_mean = mean(land_TLU)
egen land_hired_labor_mean = mean(land_hired_labor)
egen land_equip_mean = mean(land_equip)
egen hh_labor_fert_mean = mean(hh_labor_fert)
egen hh_labor_TLU_mean = mean(hh_labor_TLU)
egen hh_labor_hired_labor_mean = mean(hh_labor_hired_labor)
egen hh_labor_equip_mean = mean(hh_labor_equip)
egen fert_TLU_mean = mean(fert_TLU)
egen fert_hired_labor_mean = mean(fert_hired_labor)
egen fert_equip_mean = mean(fert_equip)
egen TLU_hired_labor_mean = mean(TLU_hired_labor)
egen TLU_equip_mean = mean(TLU_equip)
egen hired_labor_equip_mean = mean(hired_labor_equip)

gen dm_land_hh_labor = land_hh_labor - land_hh_labor_mean
gen dm_land_fert = land_fert - land_fert_mean 
gen dm_land_TLU = land_TLU - land_TLU_mean
gen dm_land_hired_labor = land_hired_labor - land_hired_labor_mean
gen dm_land_equip = land_equip - land_equip_mean
gen dm_hh_labor_fert = hh_labor_fert - hh_labor_fert_mean
gen dm_hh_labor_TLU = hh_labor_TLU - hh_labor_TLU_mean
gen dm_hh_labor_hired_labor = hh_labor_hired_labor - hh_labor_hired_labor_mean
gen dm_hh_labor_equip = hh_labor_equip - hh_labor_equip_mean
gen dm_fert_TLU = fert_TLU - fert_TLU_mean
gen dm_fert_hired_labor = fert_hired_labor - fert_hired_labor_mean
gen dm_fert_equip = fert_equip - fert_equip_mean
gen dm_TLU_hired_labor = TLU_hired_labor - TLU_hired_labor_mean
gen dm_TLU_equip = TLU_equip - TLU_equip_mean
gen dm_hired_labor_equip = hired_labor_equip - hired_labor_equip_mean

gen land_hh_labor_h2 = (sqrt(prod_hect_1)) * (sqrt(ag_hours_1))
gen land_fert_h2 = (sqrt(prod_hect_1)) * (sqrt(fert_1))
gen land_TLU_h2 = (sqrt(prod_hect_1)) * (sqrt(TLU_1))
gen land_hired_labor_h2 = (sqrt(prod_hect_1)) * (sqrt(agri_income_16))
gen land_equip_h2 = (sqrt(prod_hect_1)) * (sqrt(number_mech_equip))
gen hh_labor_fert_h2 = (sqrt(ag_hours_1)) * (sqrt(fert_1))
gen hh_labor_TLU_h2 = (sqrt(ag_hours_1)) * (sqrt(TLU_1))
gen hh_labor_hired_labor_h2 = (sqrt(ag_hours_1)) * (sqrt(agri_income_16))
gen hh_labor_equip_h2 = (sqrt(ag_hours_1)) * (sqrt(number_mech_equip))
gen fert_TLU_h2 = (sqrt(fert_1)) * (sqrt(TLU_1))
gen fert_hired_labor_h2 = (sqrt(fert_1)) * (sqrt(agri_income_16))
gen fert_equip_h2 = (sqrt(fert_1)) * (sqrt(number_mech_equip))
gen TLU_hired_labor_h2 = (sqrt(TLU_1)) * (sqrt(agri_income_16))
gen TLU_equip_h2 = (sqrt(TLU_1)) * (sqrt(number_mech_equip))
gen hired_labor_equip_h2 = (sqrt(agri_income_16)) * (sqrt(number_mech_equip))

egen land_hh_labor_h2_mean = mean(land_hh_labor_h2)
egen land_fert_h2_mean = mean(land_fert_h2)
egen land_TLU_h2_mean = mean(land_TLU_h2)
egen land_hired_labor_h2_mean = mean(land_hired_labor_h2)
egen land_equip_h2_mean = mean(land_equip_h2)
egen hh_labor_fert_h2_mean = mean(hh_labor_fert_h2)
egen hh_labor_TLU_h2_mean = mean(hh_labor_TLU_h2)
egen hh_labor_hired_labor_h2_mean = mean(hh_labor_hired_labor_h2)
egen hh_labor_equip_h2_mean = mean(hh_labor_equip_h2)
egen fert_TLU_h2_mean = mean(fert_TLU_h2)
egen fert_hired_labor_h2_mean = mean(fert_hired_labor_h2)
egen fert_equip_h2_mean = mean(fert_equip_h2)
egen TLU_hired_labor_h2_mean = mean(TLU_hired_labor_h2)
egen TLU_equip_h2_mean = mean(TLU_equip_h2)
egen hired_labor_equip_h2_mean = mean(hired_labor_equip_h2)

gen dm_land_hh_labor_h2 = land_hh_labor_h2 - land_hh_labor_h2_mean
gen dm_land_fert_h2 = land_fert_h2 - land_fert_h2_mean
gen dm_land_TLU_h2 = land_TLU_h2 - land_TLU_h2_mean
gen dm_land_hired_labor_h2 = land_hired_labor_h2 - land_hired_labor_h2_mean
gen dm_land_equip_h2 = land_equip_h2 - land_equip_h2_mean
gen dm_hh_labor_fert_h2 = hh_labor_fert_h2 - hh_labor_fert_h2_mean
gen dm_hh_labor_TLU_h2 = hh_labor_TLU_h2 - hh_labor_TLU_h2_mean
gen dm_hh_labor_hired_labor_h2 = hh_labor_hired_labor_h2 - hh_labor_hired_labor_h2_mean
gen dm_hh_labor_equip_h2 = hh_labor_equip_h2 - hh_labor_equip_h2_mean
gen dm_fert_TLU_h2 = fert_TLU_h2 - fert_TLU_h2_mean
gen dm_fert_hired_labor_h2 = fert_hired_labor_h2 - fert_hired_labor_h2_mean
gen dm_fert_equip_h2 = fert_equip_h2 - fert_equip_h2_mean
gen dm_TLU_hired_labor_h2 = TLU_hired_labor_h2 - TLU_hired_labor_h2_mean
gen dm_TLU_equip_h2 = TLU_equip_h2 - TLU_equip_h2_mean
gen dm_hired_labor_equip_h2 = hired_labor_equip_h2 - hired_labor_equip_h2_mean

*** estimate equations with random effects *** 
egen hhid_num = group(hhid)

xtset hhid_num round

egen village_num = group(hhid_village)

*** generalized quadratic production function *** 
xtreg dm_value dm_land dm_land_sq dm_hh_labor dm_hh_labor_sq dm_fert dm_fert_sq dm_TLU dm_TLU_sq dm_hired_labor dm_hired_labor_sq dm_equip dm_equip_sq dm_land_hh_labor dm_land_fert dm_land_TLU dm_land_hired_labor dm_land_equip dm_hh_labor_fert dm_hh_labor_TLU dm_hh_labor_hired_labor dm_hh_labor_equip dm_fert_TLU dm_fert_hired_labor dm_fert_equip dm_TLU_hired_labor dm_TLU_equip dm_hired_labor_equip manure compost hhwaste i.round i.village_num if agri_6_14 == 1, re vce(cluster village_num)
eststo quad_re
predict quad_re 

gen mpl_quad_re = _b[dm_hh_labor] + 2*_b[dm_hh_labor_sq]*ag_hours_1 + _b[dm_land_hh_labor]*prod_hect_1 + _b[dm_hh_labor_fert]*fert_1 + _b[dm_hh_labor_TLU]*TLU_1 + _b[dm_hh_labor_hired_labor]*agri_income_16 + _b[dm_hh_labor_equip]*number_mech_equip if agri_6_14 == 1 & ag_hours_1 > 0

gen mpland_quad_re = _b[dm_land] + 2*_b[dm_land_sq]*prod_hect_1 + _b[dm_land_hh_labor]*ag_hours_1 + _b[dm_land_fert]*fert_1 + _b[dm_land_TLU]*TLU_1 + _b[dm_land_hired_labor]*agri_income_16 + _b[dm_land_equip]*number_mech_equip if agri_6_14 == 1 & ag_hours_1 > 0

gen mpfert_quad_re = _b[dm_fert] + 2*_b[dm_fert_sq]*fert_1 + _b[dm_land_fert]*prod_hect_1 + _b[dm_hh_labor_fert]*ag_hours_1 + _b[dm_fert_TLU]*TLU_1 + _b[dm_fert_hired_labor]*agri_income_16 + _b[dm_fert_equip]*number_mech_equip if agri_6_14 == 1 & ag_hours_1 > 0

gen mptlu_quad_re = _b[dm_TLU] + 2*_b[dm_TLU_sq]*TLU + _b[dm_land_TLU]*prod_hect_1 + _b[dm_hh_labor_TLU]*ag_hours_1 + _b[dm_fert_TLU]*fert_1 + _b[dm_TLU_hired_labor]*agri_income_16 + _b[dm_TLU_equip]*number_mech_equip if agri_6_14 == 1 & ag_hours_1 > 0

gen mphired_quad_re = _b[dm_hired_labor] + 2*_b[dm_hired_labor_sq]*agri_income_16 + _b[dm_land_hired_labor]*prod_hect_1 + _b[dm_hh_labor_hired_labor]*ag_hours_1 + _b[dm_fert_hired_labor]*fert_1 + _b[dm_TLU_hired_labor]*TLU_1 + _b[dm_hired_labor_equip]*number_mech_equip if agri_6_14 == 1 & ag_hours_1 > 0

gen mpequip_quad_re = _b[dm_equip] + 2*_b[dm_equip_sq]*number_mech_equip + _b[dm_land_equip]*prod_hect_1 + _b[dm_hh_labor_equip]*ag_hours_1 + _b[dm_fert_equip]*fert_1 + _b[dm_TLU_equip]*TLU_1 + _b[dm_hired_labor_equip]*agri_income_16 if agri_6_14 == 1 & ag_hours_1 > 0

*** generalized leontief production function *** 
xtreg dm_value dm_land dm_hh_labor dm_fert dm_TLU dm_hired_labor dm_equip dm_land_hh_labor_h2 dm_land_fert_h2 dm_land_TLU_h2 dm_land_hired_labor_h2 dm_land_equip_h2 dm_hh_labor_fert_h2 dm_hh_labor_TLU_h2 dm_hh_labor_hired_labor_h2 dm_hh_labor_equip_h2 dm_fert_TLU_h2 dm_fert_hired_labor_h2 dm_fert_equip_h2 dm_TLU_hired_labor_h2 dm_TLU_equip_h2 dm_hired_labor_equip_h2 manure compost hhwaste i.round i.village_num if agri_6_14 == 1, re vce(cluster village_num)
eststo leon_re 
predict leon_re 

gen mpl_leon_re = _b[dm_hh_labor] + (1/2)*_b[dm_land_hh_labor_h2]*(1/(sqrt(ag_hours_1)))*(sqrt(prod_hect_1)) + (1/2)*_b[dm_hh_labor_fert_h2]*(1/(sqrt(ag_hours_1)))*(sqrt(fert_1)) + (1/2)*_b[dm_hh_labor_TLU_h2]*(1/(sqrt(ag_hours_1)))*(sqrt(TLU)) + (1/2)*_b[dm_hh_labor_hired_labor_h2]*(1/(sqrt(ag_hours_1)))*(sqrt(agri_income_16)) + (1/2)*_b[dm_hh_labor_equip_h2]*(1/(sqrt(ag_hours_1)))*(sqrt(number_mech_equip)) if agri_6_14 == 1 

gen mpland_leon_re = _b[dm_land] + (1/2)*_b[dm_land_hh_labor_h2]*(1/(sqrt(prod_hect_1)))*(sqrt(ag_hours_1)) + (1/2)*_b[dm_land_fert_h2]*(1/(sqrt(prod_hect_1)))*(sqrt(fert_1)) + (1/2)*_b[dm_land_TLU_h2]*(1/(sqrt(prod_hect_1)))*(sqrt(TLU_1)) + (1/2)*_b[dm_land_hired_labor_h2]*(1/(sqrt(prod_hect_1)))*(sqrt(agri_income_16)) + (1/2)*_b[dm_land_equip_h2]*(1/(sqrt(prod_hect_1)))*(sqrt(number_mech_equip)) if agri_6_14 == 1

gen mpfert_leon_re = _b[dm_fert] + (1/2)*_b[dm_land_fert_h2]*(1/(sqrt(fert_1)))*(sqrt(prod_hect_1)) + (1/2)*_b[dm_hh_labor_fert_h2]*(1/(sqrt(fert_1)))*(sqrt(ag_hours_1)) + (1/2)*_b[dm_fert_TLU_h2]*(1/(sqrt(fert_1)))*(sqrt(TLU_1)) + (1/2)*_b[dm_fert_hired_labor_h2]*(1/(sqrt(fert_1)))*(sqrt(agri_income_16)) + (1/2)*_b[dm_fert_equip_h2]*(1/(sqrt(fert_1)))*(sqrt(number_mech_equip)) if agri_6_14 == 1

gen mptlu_leon_re = _b[dm_TLU] + (1/2)*_b[dm_land_TLU_h2]*(1/(sqrt(TLU_1)))*(sqrt(prod_hect_1)) + (1/2)*_b[dm_hh_labor_TLU_h2]*(1/(sqrt(TLU_1)))*(sqrt(ag_hours_1)) + (1/2)*_b[dm_fert_TLU_h2]*(1/(sqrt(TLU_1)))*(sqrt(fert_1)) + (1/2)*_b[dm_TLU_hired_labor_h2]*(1/(sqrt(TLU_1)))*(sqrt(agri_income_16)) + (1/2)*_b[dm_TLU_equip_h2]*(1/(sqrt(TLU_1)))*(sqrt(number_mech_equip)) if agri_6_14 == 1

gen mphired_leon_re = _b[dm_hired_labor] + (1/2)*_b[dm_land_hired_labor_h2]*(1/(sqrt(agri_income_16)))*(sqrt(prod_hect_1)) + (1/2)*_b[dm_hh_labor_hired_labor_h2]*(1/(sqrt(agri_income_16)))*(sqrt(ag_hours_1)) + (1/2)*_b[dm_TLU_hired_labor_h2]*(1/(sqrt(agri_income_16)))*(sqrt(TLU_1)) + (1/2)*_b[dm_fert_hired_labor_h2]*(1/(sqrt(agri_income_16)))*(sqrt(fert_1)) + (1/2)*_b[dm_hh_labor_equip_h2]*(1/(sqrt(agri_income_16)))*(sqrt(number_mech_equip)) if agri_6_14 == 1

gen mpequip_leon_re = _b[dm_equip] + (1/2)*_b[dm_land_equip_h2]*(1/(sqrt(number_mech_equip)))*(sqrt(prod_hect_1)) + (1/2)*_b[dm_hh_labor_equip_h2]*(1/(sqrt(number_mech_equip)))*(sqrt(ag_hours_1)) + (1/2)*_b[dm_TLU_equip_h2]*(1/(sqrt(number_mech_equip)))*(sqrt(TLU_1)) + (1/2)*_b[dm_fert_equip_h2]*(1/(sqrt(number_mech_equip)))*(sqrt(fert_1)) + (1/2)*_b[dm_hh_labor_equip_h2]*(1/(sqrt(number_mech_equip)))*(sqrt(agri_income_16)) if agri_6_14 == 1

*** estimate equations with household fixed effects *** 
*** generalized quadratic production function *** 
xtreg dm_value dm_land dm_land_sq dm_hh_labor dm_hh_labor_sq dm_fert dm_fert_sq dm_TLU dm_TLU_sq dm_hired_labor dm_hired_labor_sq dm_equip dm_equip_sq dm_land_hh_labor dm_land_fert dm_land_TLU dm_land_hired_labor dm_land_equip dm_hh_labor_fert dm_hh_labor_TLU dm_hh_labor_hired_labor dm_hh_labor_equip dm_fert_TLU dm_fert_hired_labor dm_fert_equip dm_TLU_hired_labor dm_TLU_equip dm_hired_labor_equip manure compost hhwaste if agri_6_14 == 1, fe absorb(village_num round hhid_num) vce(cluster village_num)
eststo quad_fe 
predict quad_fe 

gen mpl_quad_fe = _b[dm_hh_labor] + 2*_b[dm_hh_labor_sq]*ag_hours_1 + _b[dm_land_hh_labor]*prod_hect_1 + _b[dm_hh_labor_fert]*fert_1 + _b[dm_hh_labor_TLU]*TLU_1 + _b[dm_hh_labor_hired_labor]*agri_income_16 + _b[dm_hh_labor_equip]*number_mech_equip if agri_6_14 == 1 & ag_hours_1 > 0

gen mpland_quad_fe = _b[dm_land] + 2*_b[dm_land_sq]*prod_hect_1 + _b[dm_land_hh_labor]*ag_hours_1 + _b[dm_land_fert]*fert_1 + _b[dm_land_TLU]*TLU_1 + _b[dm_land_hired_labor]*agri_income_16 + _b[dm_land_equip]*number_mech_equip if agri_6_14 == 1 & ag_hours_1 > 0

gen mpfert_quad_fe = _b[dm_fert] + 2*_b[dm_fert_sq]*fert_1 + _b[dm_land_fert]*prod_hect_1 + _b[dm_hh_labor_fert]*ag_hours_1 + _b[dm_fert_TLU]*TLU_1 + _b[dm_fert_hired_labor]*agri_income_16 + _b[dm_fert_equip]*number_mech_equip if agri_6_14 == 1 & ag_hours_1 > 0

gen mptlu_quad_fe = _b[dm_TLU] + 2*_b[dm_TLU_sq]*TLU + _b[dm_land_TLU]*prod_hect_1 + _b[dm_hh_labor_TLU]*ag_hours_1 + _b[dm_fert_TLU]*fert_1 + _b[dm_TLU_hired_labor]*agri_income_16 + _b[dm_TLU_equip]*number_mech_equip if agri_6_14 == 1 & ag_hours_1 > 0

gen mphired_quad_fe = _b[dm_hired_labor] + 2*_b[dm_hired_labor_sq]*agri_income_16 + _b[dm_land_hired_labor]*prod_hect_1 + _b[dm_hh_labor_hired_labor]*ag_hours_1 + _b[dm_fert_hired_labor]*fert_1 + _b[dm_TLU_hired_labor]*TLU_1 + _b[dm_hired_labor_equip]*number_mech_equip if agri_6_14 == 1 & ag_hours_1 > 0

gen mpequip_quad_fe = _b[dm_equip] + 2*_b[dm_equip_sq]*number_mech_equip + _b[dm_land_equip]*prod_hect_1 + _b[dm_hh_labor_equip]*ag_hours_1 + _b[dm_fert_equip]*fert_1 + _b[dm_TLU_equip]*TLU_1 + _b[dm_hired_labor_equip]*agri_income_16 if agri_6_14 == 1 & ag_hours_1 > 0

*** generalized leontief production function *** 
xtreg dm_value dm_land dm_hh_labor dm_fert dm_TLU dm_hired_labor dm_equip dm_land_hh_labor_h2 dm_land_fert_h2 dm_land_TLU_h2 dm_land_hired_labor_h2 dm_land_equip_h2 dm_hh_labor_fert_h2 dm_hh_labor_TLU_h2 dm_hh_labor_hired_labor_h2 dm_hh_labor_equip_h2 dm_fert_TLU_h2 dm_fert_hired_labor_h2 dm_fert_equip_h2 dm_TLU_hired_labor_h2 dm_TLU_equip_h2 dm_hired_labor_equip_h2 manure compost hhwaste if agri_6_14 == 1, fe absorb(village_num round hhid_num) vce(cluster village_num)
eststo leon_fe 
predict leon_fe 

gen mpl_leon_fe = _b[dm_hh_labor] + (1/2)*_b[dm_land_hh_labor_h2]*(1/(sqrt(ag_hours_1)))*(sqrt(prod_hect_1)) + (1/2)*_b[dm_hh_labor_fert_h2]*(1/(sqrt(ag_hours_1)))*(sqrt(fert_1)) + (1/2)*_b[dm_hh_labor_TLU_h2]*(1/(sqrt(ag_hours_1)))*(sqrt(TLU_1)) + (1/2)*_b[dm_hh_labor_hired_labor_h2]*(1/(sqrt(ag_hours_1)))*(sqrt(agri_income_16)) + (1/2)*_b[dm_hh_labor_equip_h2]*(1/(sqrt(ag_hours_1)))*(sqrt(number_mech_equip)) if agri_6_14 == 1

gen mpland_leon_fe = _b[dm_land] + (1/2)*_b[dm_land_hh_labor_h2]*(1/(sqrt(prod_hect_1)))*(sqrt(ag_hours_1)) + (1/2)*_b[dm_land_fert_h2]*(1/(sqrt(prod_hect_1)))*(sqrt(fert_1)) + (1/2)*_b[dm_land_TLU_h2]*(1/(sqrt(prod_hect_1)))*(sqrt(TLU_1)) + (1/2)*_b[dm_land_hired_labor_h2]*(1/(sqrt(prod_hect_1)))*(sqrt(agri_income_16)) + (1/2)*_b[dm_land_equip_h2]*(1/(sqrt(prod_hect_1)))*(sqrt(number_mech_equip)) if agri_6_14 == 1

gen mpfert_leon_fe = _b[dm_fert] + (1/2)*_b[dm_land_fert_h2]*(1/(sqrt(fert_1)))*(sqrt(prod_hect_1)) + (1/2)*_b[dm_hh_labor_fert_h2]*(1/(sqrt(fert_1)))*(sqrt(ag_hours_1)) + (1/2)*_b[dm_fert_TLU_h2]*(1/(sqrt(fert_1)))*(sqrt(TLU_1)) + (1/2)*_b[dm_fert_hired_labor_h2]*(1/(sqrt(fert_1)))*(sqrt(agri_income_16)) + (1/2)*_b[dm_fert_equip_h2]*(1/(sqrt(fert_1)))*(sqrt(number_mech_equip)) if agri_6_14 == 1

gen mptlu_leon_fe = _b[dm_TLU] + (1/2)*_b[dm_land_TLU_h2]*(1/(sqrt(TLU_1)))*(sqrt(prod_hect_1)) + (1/2)*_b[dm_hh_labor_TLU_h2]*(1/(sqrt(TLU_1)))*(sqrt(ag_hours_1)) + (1/2)*_b[dm_fert_TLU_h2]*(1/(sqrt(TLU_1)))*(sqrt(fert_1)) + (1/2)*_b[dm_TLU_hired_labor_h2]*(1/(sqrt(TLU_1)))*(sqrt(agri_income_16)) + (1/2)*_b[dm_TLU_equip_h2]*(1/(sqrt(TLU_1)))*(sqrt(number_mech_equip)) if agri_6_14 == 1

gen mphired_leon_fe = _b[dm_hired_labor] + (1/2)*_b[dm_land_hired_labor_h2]*(1/(sqrt(agri_income_16)))*(sqrt(prod_hect_1)) + (1/2)*_b[dm_hh_labor_hired_labor_h2]*(1/(sqrt(agri_income_16)))*(sqrt(ag_hours_1)) + (1/2)*_b[dm_TLU_hired_labor_h2]*(1/(sqrt(agri_income_16)))*(sqrt(TLU_1)) + (1/2)*_b[dm_fert_hired_labor_h2]*(1/(sqrt(agri_income_16)))*(sqrt(fert_1)) + (1/2)*_b[dm_hh_labor_equip_h2]*(1/(sqrt(agri_income_16)))*(sqrt(number_mech_equip)) if agri_6_14 == 1

gen mpequip_leon_fe = _b[dm_equip] + (1/2)*_b[dm_land_equip_h2]*(1/(sqrt(number_mech_equip)))*(sqrt(prod_hect_1)) + (1/2)*_b[dm_hh_labor_equip_h2]*(1/(sqrt(number_mech_equip)))*(sqrt(ag_hours_1)) + (1/2)*_b[dm_TLU_equip_h2]*(1/(sqrt(number_mech_equip)))*(sqrt(TLU_1)) + (1/2)*_b[dm_fert_equip_h2]*(1/(sqrt(number_mech_equip)))*(sqrt(fert_1)) + (1/2)*_b[dm_hh_labor_equip_h2]*(1/(sqrt(number_mech_equip)))*(sqrt(agri_income_16)) if agri_6_14 == 1

*** do not include TLU varaibles *** 
*** quadratic ***
xtreg dm_value dm_land dm_land_sq dm_hh_labor dm_hh_labor_sq dm_fert dm_fert_sq dm_hired_labor dm_hired_labor_sq dm_equip dm_equip_sq dm_land_hh_labor dm_land_fert dm_land_hired_labor dm_land_equip dm_hh_labor_fert dm_hh_labor_hired_labor dm_hh_labor_equip dm_fert_hired_labor dm_fert_equip dm_hired_labor_equip manure compost hhwaste i.village_num i.round if agri_6_14 == 1, re vce(cluster village_num)
eststo quad_re_notlu 
predict quad_re_notlu 

gen mpl_quad_re_notlu = _b[dm_hh_labor] + 2*_b[dm_hh_labor_sq]*ag_hours_1 + _b[dm_land_hh_labor]*prod_hect_1 + _b[dm_hh_labor_fert]*fert_1 + _b[dm_hh_labor_hired_labor]*agri_income_16 + _b[dm_hh_labor_equip]*number_mech_equip if agri_6_14 == 1 & ag_hours_1 > 0

gen mpland_quad_re_notlu = _b[dm_land] + 2*_b[dm_land_sq]*prod_hect_1 + _b[dm_land_hh_labor]*ag_hours_1 + _b[dm_land_fert]*fert_1 + _b[dm_land_hired_labor]*agri_income_16 + _b[dm_land_equip]*number_mech_equip if agri_6_14 == 1 & ag_hours_1 > 0

gen mpfert_quad_re_notlu = _b[dm_fert] + 2*_b[dm_fert_sq]*fert_1 + _b[dm_land_fert]*prod_hect_1 + _b[dm_hh_labor_fert]*ag_hours_1 + _b[dm_fert_hired_labor]*agri_income_16 + _b[dm_fert_equip]*number_mech_equip if agri_6_14 == 1 & ag_hours_1 > 0

gen mphired_quad_re_notlu = _b[dm_hired_labor] + 2*_b[dm_hired_labor_sq]*agri_income_16 + _b[dm_land_hired_labor]*prod_hect_1 + _b[dm_hh_labor_hired_labor]*ag_hours_1 + _b[dm_fert_hired_labor]*fert_1 + _b[dm_hired_labor_equip]*number_mech_equip if agri_6_14 == 1 & ag_hours_1 > 0

gen mpequip_quad_re_notlu = _b[dm_equip] + 2*_b[dm_equip_sq]*number_mech_equip + _b[dm_land_equip]*prod_hect_1 + _b[dm_hh_labor_equip]*ag_hours_1 + _b[dm_fert_equip]*fert_1 + _b[dm_hired_labor_equip]*agri_income_16 if agri_6_14 == 1 & ag_hours_1 > 0

*** generalized leontief production function *** 
xtreg dm_value dm_land dm_hh_labor dm_fert dm_hired_labor dm_equip dm_land_hh_labor_h2 dm_land_fert_h2 dm_land_hired_labor_h2 dm_land_equip_h2 dm_hh_labor_fert_h2 dm_hh_labor_hired_labor_h2 dm_hh_labor_equip_h2 dm_fert_hired_labor_h2 dm_fert_equip_h2 dm_hired_labor_equip_h2 manure compost hhwaste i.round i.village_num if agri_6_14 == 1, re vce(cluster village_num)
eststo leon_re_notlue 
predict leon_re_notlu 

gen mpl_leon_re_notlu = _b[dm_hh_labor] + (1/2)*_b[dm_land_hh_labor_h2]*(1/(sqrt(ag_hours_1)))*(sqrt(prod_hect_1)) + (1/2)*_b[dm_hh_labor_fert_h2]*(1/(sqrt(ag_hours_1)))*(sqrt(fert_1)) + (1/2)*_b[dm_hh_labor_hired_labor_h2]*(1/(sqrt(ag_hours_1)))*(sqrt(agri_income_16)) + (1/2)*_b[dm_hh_labor_equip_h2]*(1/(sqrt(ag_hours_1)))*(sqrt(number_mech_equip)) if agri_6_14 == 1

gen mpland_leon_re_notlu = _b[dm_land] + (1/2)*_b[dm_land_hh_labor_h2]*(1/(sqrt(prod_hect_1)))*(sqrt(ag_hours_1)) + (1/2)*_b[dm_land_fert_h2]*(1/(sqrt(prod_hect_1)))*(sqrt(fert_1)) + (1/2)*_b[dm_land_hired_labor_h2]*(1/(sqrt(prod_hect_1)))*(sqrt(agri_income_16)) + (1/2)*_b[dm_land_equip_h2]*(1/(sqrt(prod_hect_1)))*(sqrt(number_mech_equip)) if agri_6_14 == 1

gen mpfert_leon_re_notlu = _b[dm_fert] + (1/2)*_b[dm_land_fert_h2]*(1/(sqrt(fert_1)))*(sqrt(prod_hect_1)) + (1/2)*_b[dm_hh_labor_fert_h2]*(1/(sqrt(fert_1)))*(sqrt(ag_hours_1)) + (1/2)*_b[dm_fert_hired_labor_h2]*(1/(sqrt(fert_1)))*(sqrt(agri_income_16)) + (1/2)*_b[dm_fert_equip_h2]*(1/(sqrt(fert_1)))*(sqrt(number_mech_equip)) if agri_6_14 == 1

gen mphired_leon_re_notlu = _b[dm_hired_labor] + (1/2)*_b[dm_land_hired_labor_h2]*(1/(sqrt(agri_income_16)))*(sqrt(prod_hect_1)) + (1/2)*_b[dm_hh_labor_hired_labor_h2]*(1/(sqrt(agri_income_16)))*(sqrt(ag_hours_1)) + (1/2)*_b[dm_fert_hired_labor_h2]*(1/(sqrt(agri_income_16)))*(sqrt(fert_1)) + (1/2)*_b[dm_hh_labor_equip_h2]*(1/(sqrt(agri_income_16)))*(sqrt(number_mech_equip)) if agri_6_14 == 1

gen mpequip_leon_re_notlu = _b[dm_equip] + (1/2)*_b[dm_land_equip_h2]*(1/(sqrt(number_mech_equip)))*(sqrt(prod_hect_1)) + (1/2)*_b[dm_hh_labor_equip_h2]*(1/(sqrt(number_mech_equip)))*(sqrt(ag_hours_1)) + (1/2)*_b[dm_fert_equip_h2]*(1/(sqrt(number_mech_equip)))*(sqrt(fert_1)) + (1/2)*_b[dm_hh_labor_equip_h2]*(1/(sqrt(number_mech_equip)))*(sqrt(agri_income_16)) if agri_6_14 == 1

*** quadratic fixed effects ***
xtreg dm_value dm_land dm_land_sq dm_hh_labor dm_hh_labor_sq dm_fert dm_fert_sq dm_hired_labor dm_hired_labor_sq dm_equip dm_equip_sq dm_land_hh_labor dm_land_fert dm_land_hired_labor dm_land_equip dm_hh_labor_fert dm_hh_labor_hired_labor dm_hh_labor_equip dm_fert_hired_labor dm_fert_equip dm_hired_labor_equip manure compost hhwaste if agri_6_14 == 1, fe absorb(village_num round hhid_num) vce(cluster village_num)
eststo quad_fe_notlu 
predict quad_fe_notlu 

gen mpl_quad_fe_notlu = _b[dm_hh_labor] + 2*_b[dm_hh_labor_sq]*ag_hours_1 + _b[dm_land_hh_labor]*prod_hect_1 + _b[dm_hh_labor_fert]*fert_1 + _b[dm_hh_labor_hired_labor]*agri_income_16 + _b[dm_hh_labor_equip]*number_mech_equi if agri_6_14 == 1 & ag_hours_1 > 0

gen mpland_quad_fe_notlu = _b[dm_land] + 2*_b[dm_land_sq]*prod_hect_1 + _b[dm_land_hh_labor]*ag_hours_1 + _b[dm_land_fert]*fert_1 + _b[dm_land_hired_labor]*agri_income_16 + _b[dm_land_equip]*number_mech_equip if agri_6_14 == 1 & ag_hours_1 > 0

gen mpfert_quad_fe_notlu = _b[dm_fert] + 2*_b[dm_fert_sq]*fert_1 + _b[dm_land_fert]*prod_hect_1 + _b[dm_hh_labor_fert]*ag_hours_1 + _b[dm_fert_hired_labor]*agri_income_16 + _b[dm_fert_equip]*number_mech_equip if agri_6_14 == 1 & ag_hours_1 > 0

gen mphired_quad_fe_notlu = _b[dm_hired_labor] + 2*_b[dm_hired_labor_sq]*agri_income_16 + _b[dm_land_hired_labor]*prod_hect_1 + _b[dm_hh_labor_hired_labor]*ag_hours_1 + _b[dm_fert_hired_labor]*fert_1 + _b[dm_hired_labor_equip]*number_mech_equip if agri_6_14 == 1 & ag_hours_1 > 0

gen mpequip_quad_fe_notlu = _b[dm_equip] + 2*_b[dm_equip_sq]*number_mech_equip + _b[dm_land_equip]*prod_hect_1 + _b[dm_hh_labor_equip]*ag_hours_1 + _b[dm_fert_equip]*fert_1 + _b[dm_hired_labor_equip]*agri_income_16 if agri_6_14 == 1 & ag_hours_1 > 0

*** generalized leontief production function *** 
xtreg dm_value dm_land dm_hh_labor dm_fert dm_hired_labor dm_equip dm_land_hh_labor_h2 dm_land_fert_h2 dm_land_hired_labor_h2 dm_land_equip_h2 dm_hh_labor_fert_h2 dm_hh_labor_hired_labor_h2 dm_hh_labor_equip_h2 dm_fert_hired_labor_h2 dm_fert_equip_h2 dm_hired_labor_equip_h2 manure compost hhwaste if agri_6_14 == 1, fe absorb(village_num round hhid_num) vce(cluster village_num)
eststo leon_fe_notlu 
predict leon_fe_notlu 

gen mpl_leon_fe_notlu = _b[dm_hh_labor] + (1/2)*_b[dm_land_hh_labor_h2]*(1/(sqrt(ag_hours_1)))*(sqrt(prod_hect_1)) + (1/2)*_b[dm_hh_labor_fert_h2]*(1/(sqrt(ag_hours_1)))*(sqrt(fert_1)) + (1/2)*_b[dm_hh_labor_hired_labor_h2]*(1/(sqrt(ag_hours_1)))*(sqrt(agri_income_16)) + (1/2)*_b[dm_hh_labor_equip_h2]*(1/(sqrt(ag_hours_1)))*(sqrt(number_mech_equip)) if agri_6_14 == 1

gen mpland_leon_fe_notlu = _b[dm_land] + (1/2)*_b[dm_land_hh_labor_h2]*(1/(sqrt(prod_hect_1)))*(sqrt(ag_hours_1)) + (1/2)*_b[dm_land_fert_h2]*(1/(sqrt(prod_hect_1)))*(sqrt(fert_1)) + (1/2)*_b[dm_land_hired_labor_h2]*(1/(sqrt(prod_hect_1)))*(sqrt(agri_income_16)) + (1/2)*_b[dm_land_equip_h2]*(1/(sqrt(prod_hect_1)))*(sqrt(number_mech_equip)) if agri_6_14 == 1

gen mpfert_leon_fe_notlu = _b[dm_fert] + (1/2)*_b[dm_land_fert_h2]*(1/(sqrt(fert_1)))*(sqrt(prod_hect_1)) + (1/2)*_b[dm_hh_labor_fert_h2]*(1/(sqrt(fert_1)))*(sqrt(ag_hours_1)) + (1/2)*_b[dm_fert_hired_labor_h2]*(1/(sqrt(fert_1)))*(sqrt(agri_income_16)) + (1/2)*_b[dm_fert_equip_h2]*(1/(sqrt(fert_1)))*(sqrt(number_mech_equip)) if agri_6_14 == 1

gen mphired_leon_fe_notlu = _b[dm_hired_labor] + (1/2)*_b[dm_land_hired_labor_h2]*(1/(sqrt(agri_income_16)))*(sqrt(prod_hect_1)) + (1/2)*_b[dm_hh_labor_hired_labor_h2]*(1/(sqrt(agri_income_16)))*(sqrt(ag_hours_1)) + (1/2)*_b[dm_fert_hired_labor_h2]*(1/(sqrt(agri_income_16)))*(sqrt(fert_1)) + (1/2)*_b[dm_hh_labor_equip_h2]*(1/(sqrt(agri_income_16)))*(sqrt(number_mech_equip)) if agri_6_14 == 1

gen mpequip_leon_fe_notlu = _b[dm_equip] + (1/2)*_b[dm_land_equip_h2]*(1/(sqrt(number_mech_equip)))*(sqrt(prod_hect_1)) + (1/2)*_b[dm_hh_labor_equip_h2]*(1/(sqrt(number_mech_equip)))*(sqrt(ag_hours_1)) + (1/2)*_b[dm_fert_equip_h2]*(1/(sqrt(number_mech_equip)))*(sqrt(fert_1)) + (1/2)*_b[dm_hh_labor_equip_h2]*(1/(sqrt(number_mech_equip)))*(sqrt(agri_income_16)) if agri_6_14 == 1

*** no hh fixed effects or random effects *** 
reg dm_value dm_land dm_land_sq dm_hh_labor dm_hh_labor_sq dm_fert dm_fert_sq dm_TLU dm_TLU_sq dm_hired_labor dm_hired_labor_sq dm_equip dm_equip_sq dm_land_hh_labor dm_land_fert dm_land_TLU dm_land_hired_labor dm_land_equip dm_hh_labor_fert dm_hh_labor_TLU dm_hh_labor_hired_labor dm_hh_labor_equip dm_fert_TLU dm_fert_hired_labor dm_fert_equip dm_TLU_hired_labor dm_TLU_equip dm_hired_labor_equip manure compost hhwaste i.round i.village_num if agri_6_14 == 1, cluster(village_num)

reg dm_value dm_land dm_hh_labor dm_fert dm_TLU dm_hired_labor dm_equip dm_land_hh_labor_h2 dm_land_fert_h2 dm_land_TLU_h2 dm_land_hired_labor_h2 dm_land_equip_h2 dm_hh_labor_fert_h2 dm_hh_labor_TLU_h2 dm_hh_labor_hired_labor_h2 dm_hh_labor_equip_h2 dm_fert_TLU_h2 dm_fert_hired_labor_h2 dm_fert_equip_h2 dm_TLU_hired_labor_h2 dm_TLU_equip_h2 dm_hired_labor_equip_h2 manure compost hhwaste i.round i.village_num if agri_6_14 == 1, cluster(village_num)

*** output basic regression results *** 
esttab leon_re leon_fe leon_re_notlue leon_fe_notlu using "$auctions/leon_prods.tex", keep(dm_land dm_hh_labor dm_fert dm_TLU dm_hired_labor dm_equip dm_land_hh_labor_h2 dm_land_fert_h2 dm_land_TLU_h2 dm_land_hired_labor_h2 dm_land_equip_h2 dm_hh_labor_fert_h2 dm_hh_labor_TLU_h2 dm_hh_labor_hired_labor_h2 dm_hh_labor_equip_h2 dm_fert_TLU_h2 dm_fert_hired_labor_h2 dm_fert_equip_h2 dm_TLU_hired_labor_h2 dm_TLU_equip_h2 dm_hired_labor_equip_h2 manure compost hhwaste) se r2 star(* 0.1 ** 0.05 *** 0.01) replace 

esttab quad_re quad_fe quad_re_notlu quad_fe_notlu using "$auctions/quad_prods.tex", keep(dm_land dm_land_sq dm_hh_labor dm_hh_labor_sq dm_fert dm_fert_sq dm_TLU dm_TLU_sq dm_hired_labor dm_hired_labor_sq dm_equip dm_equip_sq dm_land_hh_labor dm_land_fert dm_land_TLU dm_land_hired_labor dm_land_equip dm_hh_labor_fert dm_hh_labor_TLU dm_hh_labor_hired_labor dm_hh_labor_equip dm_fert_TLU dm_fert_hired_labor dm_fert_equip dm_TLU_hired_labor dm_TLU_equip dm_hired_labor_equip manure compost hhwaste) se r2 star(* 0.1 ** 0.05 *** 0.01) replace 

*** censor mpl at zero *** 
gen cen_mpl_leon_re = mpl_leon_re 
replace cen_mpl_leon_re = 0 if mpl_leon_re < 0 & mpl_leon_re != .  

*** summarize estiamte marginal products of labor *** 
sum cen_mpl_leon_re daily_wage_10

estpost summarize cen_mpl_leon_re daily_wage_10

esttab . using "$auctions/mpl_sum_stats.tex", cells("count mean(fmt(%9.3f)) sd(fmt(%9.3f)) min max") noobs nonumber label replace

*** calculate elasticities *** 
gen elas_quad_fe_land = (prod_hect_1*mpland_quad_fe)/quad_fe 
gen elas_quad_fe_labor = (ag_hours_1*mpl_quad_fe)/quad_fe 
gen elas_quad_fe_fert = (fert_1*mpfert_quad_fe)/quad_fe 
gen elas_quad_fe_tlu = (TLU_1*mptlu_quad_fe)/quad_fe 
gen elas_quad_fe_hired = (agri_income_16*mphired_quad_fe)/quad_fe 
gen elas_quad_fe_equip = (number_mech_equip*mpequip_quad_fe)/quad_fe 

gen elas_quad_re_land = (prod_hect_1*mpland_quad_re)/quad_re 
gen elas_quad_re_labor = (ag_hours_1*mpl_quad_re)/quad_re 
gen elas_quad_re_fert = (fert_1*mpfert_quad_re)/quad_re 
gen elas_quad_re_tlu = (TLU_1*mptlu_quad_re)/quad_re 
gen elas_quad_re_hired = (agri_income_16*mphired_quad_re)/quad_re 
gen elas_quad_re_equip = (number_mech_equip*mpequip_quad_re)/quad_re 

gen elas_quad_fenotlu_land = (prod_hect_1*mpland_quad_fe_notlu)/quad_fe_notlu 
gen elas_quad_fenotlu_labor = (ag_hours_1*mpl_quad_fe_notlu)/quad_fe_notlu 
gen elas_quad_fenotlu_fert = (fert_1*mpfert_quad_fe_notlu)/quad_fe_notlu 
gen elas_quad_fenotlu_hired = (agri_income_16*mphired_quad_fe_notlu)/quad_fe_notlu 
gen elas_quad_fenotlu_equip = (number_mech_equip*mpequip_quad_fe_notlu)/quad_fe_notlu 

gen elas_quad_renotlu_land = (prod_hect_1*mpland_quad_re_notlu)/quad_re_notlu 
gen elas_quad_renotlu_labor = (ag_hours_1*mpl_quad_re_notlu)/quad_re_notlu 
gen elas_quad_renotlu_fert = (fert_1*mpfert_quad_re_notlu)/quad_re_notlu 
gen elas_quad_renotlu_hired = (agri_income_16*mphired_quad_re_notlu)/quad_re_notlu 
gen elas_quad_renotlu_equip = (number_mech_equip*mpequip_quad_re_notlu)/quad_re_notlu 

gen elas_leon_fe_land = (prod_hect_1*mpland_leon_fe)/leon_fe if agri_6_14 == 1 & ag_hours_1 > 0
gen elas_leon_fe_labor = (ag_hours_1*mpl_leon_fe)/leon_fe if agri_6_14 == 1 & ag_hours_1 > 0
gen elas_leon_fe_fert = (fert_1*mpfert_leon_fe)/leon_fe if agri_6_14 == 1 & ag_hours_1 > 0
gen elas_leon_fe_tlu = (TLU_1*mptlu_leon_fe)/leon_fe if agri_6_14 == 1 & ag_hours_1 > 0
gen elas_leon_fe_hired = (agri_income_16*mphired_leon_fe)/leon_fe if agri_6_14 == 1 & ag_hours_1 > 0
gen elas_leon_fe_equip = (number_mech_equip*mpequip_leon_fe)/leon_fe if agri_6_14 == 1 & ag_hours_1 > 0

gen elas_leon_re_land = (prod_hect_1*mpland_leon_re)/leon_re if agri_6_14 == 1 & ag_hours_1 > 0
gen elas_leon_re_labor = (ag_hours_1*mpl_leon_re)/leon_re if agri_6_14 == 1 & ag_hours_1 > 0
gen elas_leon_re_fert = (fert_1*mpfert_leon_re)/leon_re if agri_6_14 == 1 & ag_hours_1 > 0
gen elas_leon_re_tlu = (TLU_1*mptlu_leon_re)/leon_re if agri_6_14 == 1 & ag_hours_1 > 0
gen elas_leon_re_hired = (agri_income_16*mphired_leon_re)/leon_re if agri_6_14 == 1 & ag_hours_1 > 0
gen elas_leon_re_equip = (number_mech_equip*mpequip_leon_re)/leon_re if agri_6_14 == 1 & ag_hours_1 > 0

gen elas_leon_fenotlu_land = (prod_hect_1*mpland_leon_fe_notlu)/leon_fe_notlu if agri_6_14 == 1 & ag_hours_1 > 0
gen elas_leon_fenotlu_labor = (ag_hours_1*mpl_leon_fe_notlu)/leon_fe_notlu if agri_6_14 == 1 & ag_hours_1 > 0
gen elas_leon_fenotlu_fert = (fert_1*mpfert_leon_fe_notlu)/leon_fe_notlu if agri_6_14 == 1 & ag_hours_1 > 0
gen elas_leon_fenotlu_hired = (agri_income_16*mphired_leon_fe_notlu)/leon_fe_notlu if agri_6_14 == 1 & ag_hours_1 > 0
gen elas_leon_fenotlu_equip = (number_mech_equip*mpequip_leon_fe_notlu)/leon_fe_notlu if agri_6_14 == 1 & ag_hours_1 > 0

gen elas_leon_renotlu_land = (prod_hect_1*mpland_leon_re_notlu)/leon_re_notlu if agri_6_14 == 1 & ag_hours_1 > 0
gen elas_leon_renotlu_labor = (ag_hours_1*mpl_leon_re_notlu)/leon_re_notlu if agri_6_14 == 1 & ag_hours_1 > 0
gen elas_leon_renotlu_fert = (fert_1*mpfert_leon_re_notlu)/leon_re_notlu if agri_6_14 == 1 & ag_hours_1 > 0
gen elas_leon_renotlu_hired = (agri_income_16*mphired_leon_re_notlu)/leon_re_notlu if agri_6_14 == 1 & ag_hours_1 > 0
gen elas_leon_renotlu_equip = (number_mech_equip*mpequip_leon_re_notlu)/leon_re_notlu if agri_6_14 == 1 & ag_hours_1 > 0

*** summarize elasticities by model *** 
sum elas_quad_fe_*

sum elas_leon_fe_* 

sum elas_quad_re_* 

sum elas_leon_re_* 

sum elas_quad_fenotlu_* 

sum elas_leon_fenotlu_* 

sum elas_quad_renotlu_* 

sum elas_leon_renotlu_* 

*** calculate allocative inefficiency *** 
gen ai_leon_re = ln(daily_wage_10/mpl_leon_re) if ag_wage == 1
gen ihs_ai = asinh(daily_wage_10/mpl_leon_re) if ag_wage == 1
gen cen_ihs_ai = asinh(daily_wage_10/cen_mpl_leon_re) if ag_wage == 1

*** calculate wage to mpl ratio *** 
gen wage_ratio = daily_wage_10 / mpl_leon_re if ag_wage == 1 

*** calculate land to labor ratio ***
gen land_to_labor = prod_hect_1 / ag_hours_1

*** plot allocative inefficiency and wage ratio along land to labor ratio ***
twoway (scatter ai_leon_re land_to_labor if ai_leon_re != .) (fpfit ai_leon_re land_to_labor if ai_leon_re != .), xtitle("Land to Labor Ratio") ytitle("Allocative Inefficiency") legend(off) xlabel(0(0.5)2) 
graph export "$auctions/ai_land_labor.eps", as(eps) replace

twoway (scatter ihs_ai land_to_labor if ihs_ai != . & ihs_ai > -5 & ihs_ai < 5) (fpfit cen_ihs_ai land_to_labor if ihs_ai != . & ihs_ai > -5 & ihs_ai < 5), xtitle("Land to Labor Ratio") ytitle("Allocative Inefficiency") legend(off) xlabel(0(0.5)2) ylabel(-5(2.5)5)
graph export "$auctions/ihs_ai_land_labor.eps", as(eps) replace

twoway (scatter cen_ihs_ai land_to_labor if cen_ihs_ai != . & cen_ihs_ai > -5 & cen_ihs_ai < 5) (fpfit cen_ihs_ai land_to_labor if cen_ihs_ai != . & cen_ihs_ai > -5 & cen_ihs_ai < 5), xtitle("Land to Labor Ratio") ytitle("Allocative Inefficiency") legend(off) xlabel(0(0.5)2) ylabel(-5(2.5)5)
graph export "$auctions/cen_ihs_ai_land_labor.eps", as(eps) replace

*** plot ratio of wage to mpl along land to labor ratio *** 
twoway (scatter wage_ratio land_to_labor) (fpfit wage_ratio land_to_labor), xtitle("Land to Labor Ratio") ytitle("Wage to Marginal Revenue Product of Labor Ratio") legend(off)

*** plot allocative inefficiency along asset index *** 
twoway (scatter ai_leon_re asset_index_std if ai_leon_re != .) (fpfit ai_leon_re asset_index_std if ai_leon_re != .), xtitle("Asset Index") ytitle("Allocative Inefficiency") legend(off) 
graph export "$auctions/ai_asset.eps", as(eps) replace

twoway (scatter ihs_ai asset_index_std if ihs_ai != . & ihs_ai > -5 & ihs_ai < 5) (fpfit ai_leon_re asset_index_std if ihs_ai != . & ihs_ai > -5 & ihs_ai < 5), xtitle("Asset Index") ytitle("Allocative Inefficiency") legend(off) 
graph export "$auctions/ihs_ai_asset.eps", as(eps) replace

*** plot ratio of wage to mpl along asset index *** 
twoway (scatter wage_ratio asset_index_std) (fpfit wage_ratio asset_index_std), xtitle("Asset Index") ytitle("Wage to Marginal Revenue Product of Labor Ratio") legend(off)

*** estiamte factors of allocative inefficiency *** 
gen age2 = hhhead_age*hhhead_age 
gen members2 = members*members
gen child2 = child*child
gen crop_types2 = crop_types*crop_types
gen land2 = prod_hect_1*prod_hect_1
gen TLU2 = TLU_1*TLU_1

reg ai_leon_re hhhead_no_education hhhead_female hhhead_age age2 members members2 child child2 rice crop_types crop_types2 prod_hect_1 land2 TLU_1 TLU2, cluster(village_num) 
eststo ai_factors 

*** predict ai for those who do not do wage labor *** 
gen est_ai = _b[_cons] + _b[hhhead_no_education]*hhhead_no_education + _b[hhhead_female]*hhhead_female + _b[hhhead_age]*hhhead_age + _b[age2]*age2 + _b[members]*members + _b[members2]*members2 + _b[child]*child + _b[child2]*child2 + _b[rice]*rice + _b[crop_types]*crop_types + _b[crop_types2]*crop_types2 + _b[prod_hect_1]*prod_hect_1 +_b[land2]*land2 + _b[TLU_1]*TLU_1 +_b[TLU2]*TLU2 if ag_hours_1 > 0 & ag_wage == 0 

reg ihs_ai hhhead_no_education hhhead_female hhhead_age age2 members members2 child child2 rice crop_types crop_types2 prod_hect_1 land2 TLU_1 TLU2, cluster(village_num) 
eststo ihs_ai_factors 

*** predict ai for those who do not do wage labor *** 
gen est_ihs_ai = _b[_cons] + _b[hhhead_no_education]*hhhead_no_education + _b[hhhead_female]*hhhead_female + _b[hhhead_age]*hhhead_age + _b[age2]*age2 + _b[members]*members + _b[members2]*members2 + _b[child]*child + _b[child2]*child2 + _b[rice]*rice + _b[crop_types]*crop_types + _b[crop_types2]*crop_types2 + _b[prod_hect_1]*prod_hect_1 +_b[land2]*land2 + _b[TLU_1]*TLU_1 +_b[TLU2]*TLU2 if ag_hours_1 > 0 & ag_wage == 0 

reg cen_ihs_ai hhhead_no_education hhhead_female hhhead_age age2 members members2 child child2 rice crop_types crop_types2 prod_hect_1 land2 TLU_1 TLU2, cluster(village_num) 
eststo cen_ihs_ai_factors 

*** predict ai for those who do not do wage labor *** 
gen est_cen_ihs_ai = _b[_cons] + _b[hhhead_no_education]*hhhead_no_education + _b[hhhead_female]*hhhead_female + _b[hhhead_age]*hhhead_age + _b[age2]*age2 + _b[members]*members + _b[members2]*members2 + _b[child]*child + _b[child2]*child2 + _b[rice]*rice + _b[crop_types]*crop_types + _b[crop_types2]*crop_types2 + _b[prod_hect_1]*prod_hect_1 +_b[land2]*land2 + _b[TLU_1]*TLU_1 +_b[TLU2]*TLU2 if ag_hours_1 > 0 & ag_wage == 0 

esttab ai_factors ihs_ai_factors cen_ihs_ai_factors using "$auctions/ai_factors.tex", keep(hhhead_no_education hhhead_female hhhead_age age2 members members2 child child2 rice crop_types crop_types2 prod_hect_1 land2 TLU_1 TLU2) se r2 star(* 0.1 ** 0.05 *** 0.01) replace 

*** estimate factors of the gap *** 
reg wage_ratio hhhead_no_education hhhead_female hhhead_age age2 members members2 child child2 rice crop_types prod_hect_1 TLU_1, cluster(village_num)

*** predict wage ratio for those who do not do wage labor ***
gen est_wage_ratio = _b[_cons] + _b[hhhead_no_education]*hhhead_no_education + _b[hhhead_female]*hhhead_female + _b[hhhead_age]*hhhead_age + _b[age2]*age2 + _b[members]*members + _b[members2]*members2 + _b[child]*child + _b[child2]*child2 + _b[rice]*rice + _b[crop_types]*crop_types + _b[prod_hect_1]*prod_hect_1 + _b[TLU_1]*TLU_1 if ag_hours_1 > 0 & ag_wage == 0 

*** create variable of shadow wage *** 
gen est_shadow_wage = exp(est_ai)*mpl_leon_re  
gen est_shadow_wage_alt = est_wage_ratio*mpl_leon_re
gen shadow_wage = exp(ai_leon_re)*mpl_leon_re
gen shadow_wage_alt = wage_ratio*mpl_leon_re
gen ihs_shadow_wage = sinh(est_ihs_ai)*mpl_leon_re 
gen cen_ihs_shadow_wage_alt = sinh(est_cen_ihs_ai)*mpl_leon_re

*** summarize shaodw wages *** 
sum est_shadow_wage est_shadow_wage_alt shadow_wage shadow_wage_alt ihs_shadow_wage cen_ihs_shadow_wage_alt

gen cen_ihs_shadow_wage = cen_ihs_shadow_wage_alt
replace cen_ihs_shadow_wage = 0 if cen_ihs_shadow_wage_alt < 0 & cen_ihs_shadow_wage_alt != . 

estpost summarize cen_ihs_shadow_wage daily_wage_10, detail 

esttab . using "$auctions/shadow_wage_sum_stats.tex", cells("count mean(fmt(%9.3f)) sd(fmt(%9.3f)) min p50 max") noobs nonumber label replace

*** 

*** save just shadow wages to then use in auctions supply curve *** 
keep daily_wage_10 cen_ihs_shadow_wage_alt slack_hours 

gen wage = daily_wage_10
replace wage = cen_ihs_shadow_wage_alt if daily_wage_10 == . & cen_ihs_shadow_wage_alt != . 

drop if wage == . 

drop if wage < 0 

gen compost_labor_hours = 9.356752746*8 
gen kgs_of_compost = slack_hours / compost_labor_hours

preserve 
gen mc_ton_of_compost = wage*9.356752746 + 100*200
gen fixed_cost = (39.1583907*574.446) / 1000
gen mc_kg_of_compost = mc_ton_of_compost / 1000
gen avg_tot_compost = mc_kg_of_compost + fixed_cost

sort mc_kg_of_compost 

gen count = _n 

gen quantity = kgs_of_compost
replace quantity = quantity[_n - 1] + kgs_of_compost if count > 1 

keep count quantity mc_kg_of_compost

save "$auctions/supply_curve_estimates_compost", replace 
restore 

preserve 
gen kgs_of_aniaml_feed = slack_hours / 8
gen kg_veg_cost = 387.75 / wage 
gen g_veg_cost = kg_veg_cost / 1000 
gen mc_animal_feed = 357.8*kg_veg_cost + 340.825 + (100/5)

sort mc_animal_feed 

gen count = _n 

gen quantity = kgs_of_aniaml_feed
replace quantity = quantity[_n - 1] + kgs_of_aniaml_feed if count > 1 

keep count quantity mc_animal_feed

save "$auctions/supply_curve_estimates_animalfeed", replace 
restore 
