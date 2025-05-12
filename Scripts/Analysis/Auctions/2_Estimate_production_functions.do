*** Estimate production functions for shadow wages *** 
*** File Created By: Molly Doruska ***
*** File Last Updated By: Molly Doruska ***
*** File Last Updated On: May 9, 2025 ***

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

xtset hhid_num year 

egen village_num = group(hhid_village)

*** generalized quadratic production function *** 
xtreg dm_value dm_land dm_land_sq dm_hh_labor dm_hh_labor_sq dm_fert dm_fert_sq dm_TLU dm_TLU_sq dm_hired_labor dm_hired_labor_sq dm_equip dm_equip_sq dm_land_hh_labor dm_land_fert dm_land_TLU dm_land_hired_labor dm_land_equip dm_hh_labor_fert dm_hh_labor_TLU dm_hh_labor_hired_labor dm_hh_labor_equip dm_fert_TLU dm_fert_hired_labor dm_fert_equip dm_TLU_hired_labor dm_TLU_equip dm_hired_labor_equip manure compost hhwaste i.year i.village_num, re vce(cluster village_num)

*** generalized leontief production function *** 
xtreg dm_value dm_land dm_hh_labor dm_fert dm_TLU dm_hired_labor dm_equip dm_land_hh_labor_h2 dm_land_fert_h2 dm_land_TLU_h2 dm_land_hired_labor_h2 dm_land_equip_h2 dm_hh_labor_fert_h2 dm_hh_labor_TLU_h2 dm_hh_labor_hired_labor_h2 dm_hh_labor_equip_h2 dm_fert_TLU_h2 dm_fert_hired_labor_h2 dm_fert_equip_h2 dm_TLU_hired_labor_h2 dm_TLU_equip_h2 dm_hired_labor_equip_h2 manure compost hhwaste i.year i.village_num, re vce(cluster village_num)

*** estimate equations with household fixed effects *** 
*** generalized quadratic production function *** 
xtreg dm_value dm_land dm_land_sq dm_hh_labor dm_hh_labor_sq dm_fert dm_fert_sq dm_TLU dm_TLU_sq dm_hired_labor dm_hired_labor_sq dm_equip dm_equip_sq dm_land_hh_labor dm_land_fert dm_land_TLU dm_land_hired_labor dm_land_equip dm_hh_labor_fert dm_hh_labor_TLU dm_hh_labor_hired_labor dm_hh_labor_equip dm_fert_TLU dm_fert_hired_labor dm_fert_equip dm_TLU_hired_labor dm_TLU_equip dm_hired_labor_equip manure compost hhwaste, fe absorb(village_num year hhid_num) vce(cluster village_num)

*** generalized leontief production function *** 
xtreg dm_value dm_land dm_hh_labor dm_fert dm_TLU dm_hired_labor dm_equip dm_land_hh_labor_h2 dm_land_fert_h2 dm_land_TLU_h2 dm_land_hired_labor_h2 dm_land_equip_h2 dm_hh_labor_fert_h2 dm_hh_labor_TLU_h2 dm_hh_labor_hired_labor_h2 dm_hh_labor_equip_h2 dm_fert_TLU_h2 dm_fert_hired_labor_h2 dm_fert_equip_h2 dm_TLU_hired_labor_h2 dm_TLU_equip_h2 dm_hired_labor_equip_h2 manure compost hhwaste, fe absorb(village_num year hhid_num) vce(cluster village_num)

*** do not include TLU varaibles *** 
*** quadratic ***
xtreg dm_value dm_land dm_land_sq dm_hh_labor dm_hh_labor_sq dm_fert dm_fert_sq dm_hired_labor dm_hired_labor_sq dm_equip dm_equip_sq dm_land_hh_labor dm_land_fert dm_land_hired_labor dm_land_equip dm_hh_labor_fert dm_hh_labor_hired_labor dm_hh_labor_equip dm_fert_hired_labor dm_fert_equip dm_hired_labor_equip manure compost hhwaste i.village_num i.year, re vce(cluster village_num)

*** generalized leontief production function *** 
xtreg dm_value dm_land dm_hh_labor dm_fert dm_hired_labor dm_equip dm_land_hh_labor_h2 dm_land_fert_h2 dm_land_hired_labor_h2 dm_land_equip_h2 dm_hh_labor_fert_h2 dm_hh_labor_hired_labor_h2 dm_hh_labor_equip_h2 dm_fert_hired_labor_h2 dm_fert_equip_h2 dm_hired_labor_equip_h2 manure compost hhwaste i.year i.village_num, re vce(cluster village_num)

*** quadratic fixed effects ***
xtreg dm_value dm_land dm_land_sq dm_hh_labor dm_hh_labor_sq dm_fert dm_fert_sq dm_hired_labor dm_hired_labor_sq dm_equip dm_equip_sq dm_land_hh_labor dm_land_fert dm_land_hired_labor dm_land_equip dm_hh_labor_fert dm_hh_labor_hired_labor dm_hh_labor_equip dm_fert_hired_labor dm_fert_equip dm_hired_labor_equip manure compost hhwaste, fe absorb(village_num year hhid_num) vce(cluster village_num)

*** generalized leontief production function - not enough observations *** 
xtreg dm_value dm_land dm_hh_labor dm_fert dm_hired_labor dm_equip dm_land_hh_labor_h2 dm_land_fert_h2 dm_land_hired_labor_h2 dm_land_equip_h2 dm_hh_labor_fert_h2 dm_hh_labor_hired_labor_h2 dm_hh_labor_equip_h2 dm_fert_hired_labor_h2 dm_fert_equip_h2 dm_hired_labor_equip_h2 manure compost hhwaste, fe absorb(village_num year hhid_num) vce(cluster village_num)

*** no hh fixed effects or random effects *** 
reg dm_value dm_land dm_land_sq dm_hh_labor dm_hh_labor_sq dm_fert dm_fert_sq dm_TLU dm_TLU_sq dm_hired_labor dm_hired_labor_sq dm_equip dm_equip_sq dm_land_hh_labor dm_land_fert dm_land_TLU dm_land_hired_labor dm_land_equip dm_hh_labor_fert dm_hh_labor_TLU dm_hh_labor_hired_labor dm_hh_labor_equip dm_fert_TLU dm_fert_hired_labor dm_fert_equip dm_TLU_hired_labor dm_TLU_equip dm_hired_labor_equip manure compost hhwaste i.year i.village_num, cluster(village_num)

reg dm_value dm_land dm_hh_labor dm_fert dm_TLU dm_hired_labor dm_equip dm_land_hh_labor_h2 dm_land_fert_h2 dm_land_TLU_h2 dm_land_hired_labor_h2 dm_land_equip_h2 dm_hh_labor_fert_h2 dm_hh_labor_TLU_h2 dm_hh_labor_hired_labor_h2 dm_hh_labor_equip_h2 dm_fert_TLU_h2 dm_fert_hired_labor_h2 dm_fert_equip_h2 dm_TLU_hired_labor_h2 dm_TLU_equip_h2 dm_hired_labor_equip_h2 manure compost hhwaste i.year i.village_num, cluster(village_num)
