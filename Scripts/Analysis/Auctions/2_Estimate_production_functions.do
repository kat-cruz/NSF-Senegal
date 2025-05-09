*** Estimate production functions for shadow wages *** 
*** File Created By: Molly Doruska ***
*** File Last Updated By: Molly Doruska ***
*** File Last Updated On: May 9, 2025 ***

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
global auctions "$master\Output\Analysis\Auctions_Shadow_Wages"

*** import complete dataset for production function estimation *** 
use "$auctions\complete_data_clean.dta", clear 

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
gen land_sq = dm_land * dm_land
gen hh_labor_sq = dm_hh_labor * dm_hh_labor
gen fert_sq = dm_fert * dm_fert 
gen TLU_sq = dm_TLU * dm_TLU  
gen hired_labor_sq = dm_hired_labor * dm_hired_labor 
gen equip_sq = dm_equip * dm_equip

gen land_hh_labor = dm_land * dm_hh_labor
gen land_fert = dm_land * dm_fert
gen land_TLU = dm_land * dm_TLU
gen land_hired_labor = dm_land * dm_hired_labor
gen land_equip = dm_land * dm_equip
gen hh_labor_fert = dm_hh_labor * dm_fert
gen hh_labor_TLU = dm_hh_labor * dm_TLU
gen hh_labor_hired_labor = dm_hh_labor * dm_hired_labor
gen hh_labor_equip = dm_hh_labor * dm_equip
gen fert_TLU = dm_fert * dm_TLU
gen fert_hired_labor = dm_fert * dm_hired_labor
gen fert_equip = dm_fert * dm_equip
gen TLU_hired_labor = dm_TLU * dm_hired_labor
gen TLU_equip = dm_TLU * dm_equip
gen hired_labor_equip = dm_hired_labor * dm_equip

gen land_hh_labor_h2 = (dm_land^(1/2)) * (dm_hh_labor^(1/2))
gen land_fert_h2 = (dm_land^(1/2)) * (dm_fert^(1/2))
gen land_TLU_h2 = (dm_land^(1/2)) * (dm_TLU^(1/2))
gen land_hired_labor_h2 = (dm_land^(1/2)) * (dm_hired_labor^(1/2))
gen land_equip_h2 = (dm_land^(1/2)) * (dm_equip^(1/2))
gen hh_labor_fert_h2 = (dm_hh_labor^(1/2)) * (dm_fert^(1/2))
gen hh_labor_TLU_h2 = (dm_hh_labor^(1/2)) * (dm_TLU^(1/2))
gen hh_labor_hired_labor_h2 = (dm_hh_labor^(1/2)) * (dm_hired_labor^(1/2))
gen hh_labor_equip_h2 = (dm_hh_labor^(1/2)) * (dm_equip^(1/2))
gen fert_TLU_h2 = (dm_fert^(1/2)) * (dm_TLU^(1/2))
gen fert_hired_labor_h2 = (dm_fert^(1/2)) * (dm_hired_labor^(1/2))
gen fert_equip_h2 = (dm_fert^(1/2)) * (dm_equip^(1/2))
gen TLU_hired_labor_h2 = (dm_TLU^(1/2)) * (dm_hired_labor^(1/2))
gen TLU_equip_h2 = (dm_TLU^(1/2)) * (dm_equip^(1/2))
gen hired_labor_equip_h2 = (dm_hired_labor^(1/2)) * (dm_equip^(1/2)) 

*** estimate equations with random effects *** 
egen hhid_num = group(hhid)

xtset hhid_num year 

egen village_num = group(hhid_village)

*** generalized quadratic production function *** 
xtreg dm_value dm_land land_sq dm_hh_labor hh_labor_sq dm_fert fert_sq dm_TLU TLU_sq dm_hired_labor hired_labor_sq dm_equip equip_sq land_hh_labor land_fert land_TLU land_hired_labor land_equip hh_labor_fert hh_labor_TLU hh_labor_hired_labor hh_labor_equip fert_TLU fert_hired_labor fert_equip TLU_hired_labor TLU_equip hired_labor_equip manure compost hhwaste i.year, re vce(cluster village_num)

*** generalized leontief production function *** 
xtreg dm_value dm_land dm_hh_labor dm_fert dm_TLU dm_hired_labor dm_equip land_hh_labor_h2 land_fert_h2 land_TLU_h2 land_hired_labor_h2 land_equip_h2 hh_labor_fert_h2 hh_labor_TLU_h2 hh_labor_hired_labor_h2 hh_labor_equip_h2 fert_TLU_h2 fert_hired_labor_h2 fert_equip_h2 TLU_hired_labor_h2 TLU_equip_h2 hired_labor_equip_h2 manure compost hhwaste i.year, re vce(cluster village_num)

*** estimate equations with household fixed effects *** 
*** generalized quadratic production function *** 
xtreg dm_value dm_land land_sq dm_hh_labor hh_labor_sq dm_fert fert_sq dm_TLU TLU_sq dm_hired_labor hired_labor_sq dm_equip equip_sq land_hh_labor land_fert land_TLU land_hired_labor land_equip hh_labor_fert hh_labor_TLU hh_labor_hired_labor hh_labor_equip fert_TLU fert_hired_labor fert_equip TLU_hired_labor TLU_equip hired_labor_equip manure compost hhwaste, fe absorb(village_num year hhid_num) vce(cluster village_num)

*** do not include TLU varaibles *** 
*** quadratic ***
xtreg dm_value dm_land land_sq dm_hh_labor hh_labor_sq dm_fert fert_sq dm_hired_labor hired_labor_sq dm_equip equip_sq land_hh_labor land_fert land_hired_labor land_equip hh_labor_fert hh_labor_hired_labor hh_labor_equip fert_hired_labor fert_equip hired_labor_equip manure compost hhwaste i.village i.year, re vce(cluster village_num)

*** generalized leontief production function - insufficient observations *** 
*xtreg dm_value dm_land dm_hh_labor dm_fert dm_hired_labor dm_equip land_hh_labor_h2 land_fert_h2 land_hired_labor_h2 land_equip_h2 hh_labor_fert_h2 hh_labor_hired_labor_h2 hh_labor_equip_h2 fert_hired_labor_h2 fert_equip_h2 hired_labor_equip_h2 manure compost hhwaste, re vce(cluster village_num)

*** quadratic fixed effects ***
xtreg dm_value dm_land land_sq dm_hh_labor hh_labor_sq dm_fert fert_sq dm_hired_labor hired_labor_sq dm_equip equip_sq land_hh_labor land_fert land_hired_labor land_equip hh_labor_fert hh_labor_hired_labor hh_labor_equip fert_hired_labor fert_equip hired_labor_equip manure compost hhwaste, fe absorb(village_num year hhid_num) vce(cluster village_num)

*** generalized leontief production function - not enough observations *** 
*xtreg dm_value dm_land dm_hh_labor dm_fert dm_hired_labor dm_equip land_hh_labor_h2 land_fert_h2 land_hired_labor_h2 land_equip_h2 hh_labor_fert_h2 hh_labor_hired_labor_h2 hh_labor_equip_h2 fert_hired_labor_h2 fert_equip_h2 hired_labor_equip_h2 manure compost hhwaste, fe absorb(year hhid_num) vce(cluster village_num)