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

*** create powers and interactions for estimation *** 
gen land_sq = prod_hect_1 * prod_hect_1
gen hh_labor_sq = ag_hours_1 * ag_hours_1
gen fert_sq = fert_1 * fert_1 
gen TLU_sq = TLU_1 * TLU_1  
gen hired_labor_sq = agri_income_16 * agri_income_16 
gen equip_sq = number_mech_equip * number_mech_equip

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

gen land_hh_labor_h2 = (prod_hect_1^(1/2)) * (ag_hours_1^(1/2))
gen land_fert_h2 = (prod_hect_1^(1/2)) * (fert_1^(1/2))
gen land_TLU_h2 = (prod_hect_1^(1/2)) * (TLU_1^(1/2))
gen land_hired_labor_h2 = (prod_hect_1^(1/2)) * (agri_income_16^(1/2))
gen land_equip_h2 = (prod_hect_1^(1/2)) * (number_mech_equip^(1/2))
gen hh_labor_fert_h2 = (ag_hours_1^(1/2)) * (fert_1^(1/2))
gen hh_labor_TLU_h2 = (ag_hours_1^(1/2)) * (TLU_1^(1/2))
gen hh_labor_hired_labor_h2 = (ag_hours_1^(1/2)) * (agri_income_16^(1/2))
gen hh_labor_equip_h2 = (ag_hours_1^(1/2)) * (number_mech_equip^(1/2))
gen fert_TLU_h2 = (fert_1^(1/2)) * (TLU_1^(1/2))
gen fert_hired_labor_h2 = (fert_1^(1/2)) * (agri_income_16^(1/2))
gen fert_equip_h2 = (fert_1^(1/2)) * (number_mech_equip^(1/2))
gen TLU_hired_labor_h2 = (TLU_1^(1/2)) * (agri_income_16^(1/2))
gen TLU_equip_h2 = (TLU_1^(1/2)) * (number_mech_equip^(1/2))
gen hired_labor_equip_h2 = (agri_income_16^(1/2)) * (number_mech_equip^(1/2)) 

*** estimate equations with random effects *** 
egen hhid_num = group(hhid)

xtset hhid_num year 

egen village_num = group(hhid_village)

*** generalized quadratic production function *** 
xtreg value_prod_1 prod_hect_1 land_sq ag_hours_1 hh_labor_sq fert_1 fert_sq TLU_1 TLU_sq agri_income_16 hired_labor_sq number_mech_equip equip_sq land_hh_labor land_fert land_TLU land_hired_labor land_equip hh_labor_fert hh_labor_TLU hh_labor_hired_labor hh_labor_equip fert_TLU fert_hired_labor fert_equip TLU_hired_labor TLU_equip hired_labor_equip i.village_num i.year, re vce(cluster village_num)

*** generalized leontief production function *** 
xtreg value_prod_1 prod_hect_1 ag_hours_1 fert_1 TLU_1 agri_income_16 number_mech_equip land_hh_labor_h2 land_fert_h2 land_TLU_h2 land_hired_labor_h2 land_equip_h2 hh_labor_fert_h2 hh_labor_TLU_h2 hh_labor_hired_labor_h2 hh_labor_equip_h2 fert_TLU_h2 fert_hired_labor_h2 fert_equip_h2 TLU_hired_labor_h2 TLU_equip_h2 hired_labor_equip_h2 i.village_num i.year, re vce(cluster village_num)

*** estimate equations with household fixed effects *** 
*** generalized quadratic production function *** 
xtreg value_prod_1 prod_hect_1 land_sq ag_hours_1 hh_labor_sq fert_1 fert_sq TLU_1 TLU_sq agri_income_16 hired_labor_sq number_mech_equip equip_sq land_hh_labor land_fert land_TLU land_hired_labor land_equip hh_labor_fert hh_labor_TLU hh_labor_hired_labor hh_labor_equip fert_TLU fert_hired_labor fert_equip TLU_hired_labor TLU_equip hired_labor_equip, fe absorb(village_num year hhid_num) vce(cluster village_num)

*** generalized leontief production function *** 
xtreg value_prod_1 prod_hect_1 ag_hours_1 fert_1 TLU_1 agri_income_16 number_mech_equip land_hh_labor_h2 land_fert_h2 land_TLU_h2 land_hired_labor_h2 land_equip_h2 hh_labor_fert_h2 hh_labor_TLU_h2 hh_labor_hired_labor_h2 hh_labor_equip_h2 fert_TLU_h2 fert_hired_labor_h2 fert_equip_h2 TLU_hired_labor_h2 TLU_equip_h2 hired_labor_equip_h2, fe absorb(village_num year hhid_num) vce(cluster village_num)
