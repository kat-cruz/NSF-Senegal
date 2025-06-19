**************************************************
* DISES ANCOVA Plots Baseline to Midline
* Created by: Alexander Mills
* Updates tracked on Git
**************************************************

* Setup
clear all
set more off

* Set file paths
if "`c(username)'" == "admmi" global master "C:\Users\admmi\Box\NSF Senegal"
if "`c(username)'" == "km978" global master "C:\Users\km978\Box\NSF Senegal"
if "`c(username)'" == "socrm" global master "C:\Users\socrm\Box\NSF Senegal"

global specifications "$master\Data_Management\Output\Analysis\Specifications\Midline"
global figures "$master\Data_Management\Output\Analysis\Specifications\Midline\Figures"

* load specifications dataset
use "$specifications/v2_baseline_to_midline_pap_specifications.dta", clear

* avr participation outcomes 
local avr_outcomes "avr_water_any avr_harvest_any avr_removal_any avr_recent_any avr_harvest_kg avr_recent_kg"

*******************************************
* AVR
*******************************************

* labels
* AVR outcome labels based on survey questions
// Change to match exactly:
local lab_water_any "Harvest Vegetation (12mo)"
local lab_harvest_any "Collect Vegetation (12mo)" 
local lab_removal_any "Remove Vegetation (12mo)"
local lab_recent_any "Harvest Vegetation (7-day)"
local lab_harvest_kg "Avg. Weekly Amount (12mo)"
local lab_recent_kg "Total Amount (7-day)"

* simple baseline to midline mean plots
set scheme s2color

* AVR outcomes plotting
preserve 

* create long dataset with baseline and midline values
gen period = 1
gen time = "Midline"

foreach var of local avr_outcomes {
    gen `var' = midline_`var'
    gen `var'0 = baseline_`var'
}

expand 2
bysort hhid: replace period = _n - 1
replace time = "Baseline" if period == 0

foreach var of local avr_outcomes {
    replace `var' = `var'0 if period == 0
    drop `var'0
}

* calculate means for each period
collapse (mean) avr_*, by(time period)

* plot participation outcomes (all binary measures)
twoway (connected avr_water_any period, msymbol(O)) ///
       (connected avr_harvest_any period, msymbol(D)) ///
       (connected avr_removal_any period, msymbol(T)) ///
       (connected avr_recent_any period, msymbol(S)), ///
    xlabel(0 "Baseline" 1 "Midline") ///
    ylabel(0(.02).1, format(%3.2f)) ///
    xtitle("Survey Round") ytitle("Share of Households Participating") ///
    legend(order(1 "`lab_water_any'" 2 "`lab_harvest_any'" ///
           3 "`lab_removal_any'" 4 "`lab_recent_any'") cols(2)) ///
    title("Household AVR Participation Over Time") ///
    subtitle("Mean household participation rates") ///
    name(participation, replace)

* plot collection amounts (kg measures)
twoway (connected avr_harvest_kg period, msymbol(O)) ///
       (connected avr_recent_kg period, msymbol(D)), ///
    xlabel(0 "Baseline" 1 "Midline") ///
    xtitle("Survey Round") ytitle("Average Collection (kg)") ///
    legend(order(1 "`lab_harvest_kg'" 2 "`lab_recent_kg'")) ///
    title("Collection Amounts") ///
    name(amounts, replace)

* Combine the plots side by side
graph combine participation amounts, ///
    title("Aquatic Vegetation Removal Activities") ///
    subtitle("Participation rates and collection amounts by recall period") ///
    rows(1) xsize(12) ysize(5)
graph export "$figures/avr_all_outcomes.png", replace width(1600)

restore

**************************************
* Composting
**************************************

* Define composting/fertilizer outcomes and labels
local comp_outcomes "fert_ag_any fert_specific_any compost_any waste_any"
// Update to match:
local lab_fert_ag_any "Any HH Member AVR for Fertilizer"
local lab_fert_specific_any "Specific AVR for Fertilizer"
local lab_compost_any "Any Plot Using Compost"
local lab_waste_any "Any Plot Using Household Waste"

* baseline to midline mean plots
preserve 

* long dataset with baseline and midline values
gen period = 1
gen time = "Midline"

foreach var of local comp_outcomes {
    gen `var' = midline_`var'
    gen `var'0 = baseline_`var'
}

expand 2
bysort hhid: replace period = _n - 1
replace time = "Baseline" if period == 0

foreach var of local comp_outcomes {
    replace `var' = `var'0 if period == 0
    drop `var'0
}

* means for each period
collapse (mean) fert_* compost_* waste_*, by(time period)

twoway (connected fert_ag_any period, msymbol(O)) ///
       (connected fert_specific_any period, msymbol(D)) ///
       (connected compost_any period, msymbol(T)) ///
       (connected waste_any period, msymbol(S)), ///
    xlabel(0 "Baseline" 1 "Midline") ///
    ylabel(0(.02).08, format(%3.2f)) /// 
    xtitle("Survey Round") ytitle("Share of Households") ///
    legend(order(1 "`lab_fert_ag_any'" 2 "`lab_fert_specific_any'" ///
                 3 "`lab_compost_any'" 4 "`lab_waste_any'") cols(2)) ///
    title("Household Fertilizer and Organic Input Use") ///
    subtitle("AVR fertilizer use and plot-level organic inputs") ///
    name(composting, replace)
graph export "$figures/fertilizer_composting.png", replace width(1200)
	
	
restore

*******************************************
* Food Security
*******************************************

* Food security outcomes and labels
local food_outcomes "months_soudure rcsi_annual rcsi_work rcsi_assets rcsi_migrate rcsi_skip"
// Keep these specific labels:
local lab_months_soudure "Lean Season Months"
local lab_rcsi_annual "Overall Coping Score"
local lab_rcsi_work "Work-Related Coping"
local lab_rcsi_assets "Asset Sales Coping"
local lab_rcsi_migrate "Migration Coping"
local lab_rcsi_skip "Skip Meals Coping"

* Baseline to midline mean plots
preserve 

* Long dataset with baseline and midline values
gen period = 1
gen time = "Midline"

foreach var of local food_outcomes {
    gen `var' = midline_`var'
    gen `var'0 = baseline_`var'
}

expand 2
bysort hhid: replace period = _n - 1
replace time = "Baseline" if period == 0

foreach var of local food_outcomes {
    replace `var' = `var'0 if period == 0
    drop `var'0
}

* Means for each period
collapse (mean) months_soudure rcsi_annual rcsi_work rcsi_assets rcsi_migrate rcsi_skip, by(time period)

* Food security outcomes plot
twoway (connected months_soudure period, msymbol(O)) ///
       (connected rcsi_annual period, msymbol(D)) ///
       (connected rcsi_work period, msymbol(T)) ///
       (connected rcsi_assets period, msymbol(S)) ///
       (connected rcsi_migrate period, msymbol(+)) ///
       (connected rcsi_skip period, msymbol(X)), ///
    xlabel(0 "Baseline" 1 "Midline") ///
    xtitle("Survey Round") ytitle("Food Security Measures") ///
    legend(order(1 "`lab_months_soudure'" 2 "`lab_rcsi_annual'" ///
                 3 "`lab_rcsi_work'" 4 "`lab_rcsi_assets'" ///
                 5 "`lab_rcsi_migrate'" 6 "`lab_rcsi_skip'") cols(2)) ///
    title("Household Food Security Over Time") ///
    subtitle("Mean household food security measures") ///
    name(food_security, replace) 
graph export "$figures/food_security.png", replace width(1200)

restore

*****************************************
* Schisto
*****************************************

* schisto outcomes and labels
local schisto_outcomes "bilharzia_any meds_any diagnosed_any urine_any stool_any"
local lab_bilharzia_any "Diagnosed in Past 12mo"       // from health_5_3_2
local lab_meds_any "Received Schisto Meds (12mo)"       // from health_5_5
local lab_diagnosed_any "Ever Diagnosed"               // from health_5_6 
local lab_urine_any "Blood in Urine (12mo)"                  // from health_5_8
local lab_stool_any "Blood in Stool (12mo)"

* baseline to midline mean plots
preserve 

* long dataset with baseline and midline values
gen period = 1
gen time = "Midline"

foreach var of local schisto_outcomes {
    gen `var' = midline_`var'
    gen `var'0 = baseline_`var'
}

expand 2
bysort hhid: replace period = _n - 1
replace time = "Baseline" if period == 0

foreach var of local schisto_outcomes {
    replace `var' = `var'0 if period == 0
    drop `var'0
}

* means for each period
collapse (mean) bilharzia_* meds_* diagnosed_* urine_* stool_*, by(time period)

* binary outcomes (symptoms and treatment)
twoway (connected bilharzia_any period, msymbol(O)) ///
       (connected meds_any period, msymbol(D)) ///
       (connected diagnosed_any period, msymbol(T)) ///
       (connected urine_any period, msymbol(S)) ///
       (connected stool_any period, msymbol(+)), ///
    xlabel(0 "Baseline" 1 "Midline") ///
    ylabel(0(.2)1, format(%3.2f)) ///
    xtitle("Survey Round") ytitle("Share of Households") ///
    legend(order(1 "`lab_bilharzia_any'" 2 "`lab_meds_any'" 3 "`lab_diagnosed_any'" ///
           4 "`lab_urine_any'" 5 "`lab_stool_any'") cols(2)) ///
    title("Schistosomiasis Outcomes Over Time") ///
    subtitle("Household diagnosis, treatment, and symptoms") ///
    name(schisto_all, replace)
graph export "$figures/schisto_outcomes.png", replace width(1200)

restore

**************************************
* Property Rights
**************************************

* property rights belief outcomes and labels
local belief_outcomes "comm_land comm_water private_land comm_land_use comm_fish comm_harvest"
local lab_comm_land "Community Land Rights"
local lab_comm_water "Water Rights"
local lab_private_land "Private Land Rights"
local lab_comm_land_use "Land Use Rights"
local lab_comm_fish "Fishing Rights"
local lab_comm_harvest "Harvesting Rights"

* baseline to midline mean plots
preserve 

* long dataset with baseline and midline values
gen period = 1
gen time = "Midline"

foreach var of local belief_outcomes {
    gen `var' = midline_`var'
    gen `var'0 = baseline_`var'
}

expand 2
bysort hhid: replace period = _n - 1
replace time = "Baseline" if period == 0

foreach var of local belief_outcomes {
    replace `var' = `var'0 if period == 0
    drop `var'0
}

* means for each period
collapse (mean) comm_* private_*, by(time period)

* property rights beliefs
twoway (connected comm_land period, msymbol(O)) ///
       (connected comm_water period, msymbol(D)) ///
       (connected private_land period, msymbol(T)) ///
       (connected comm_land_use period, msymbol(S)) ///
       (connected comm_fish period, msymbol(+)) ///
       (connected comm_harvest period, msymbol(X)), ///
    xlabel(0 "Baseline" 1 "Midline") ///
    ylabel(0.5(.2)1, format(%2.1f)) ///
    xtitle("Survey Round") ytitle("Share Agreeing with Rights") ///
    legend(order(1 "`lab_comm_land'" 2 "`lab_comm_water'" 3 "`lab_private_land'" ///
           4 "`lab_comm_land_use'" 5 "`lab_comm_fish'" 6 "`lab_comm_harvest'") cols(2)) ///
    title("Property Rights Beliefs Over Time") ///
    subtitle("Mean household agreement rates") ///
    name(property_rights, replace)
	graph export "$figures/property_rights.png", replace width(1200)	

restore

*************************************
* work, labor, and school 
*************************************

* work, labor, and school outcomes and labels
local work_outcomes "work_days_lost"
local domestic_outcomes "total_chore_hours total_water_hours"
local market_outcomes "ag_workers total_ag_hours total_trade_hours total_wage_hours"
local school_outcomes "any_absence avg_attendance absence_count"

* labels for each outcome
local lab_work_days "Work Days Lost"
local lab_chore_hours "Household Chores"
local lab_water_hours "Water Collection"
local lab_ag_workers "Agricultural Workers"
local lab_ag_hours "Agricultural Work"
local lab_trade_hours "Trading Activities"
local lab_wage_hours "Wage Employment"
local lab_any_absence "Any School Absence"
local lab_attendance "Average Attendance"
local lab_absence_count "Number of Absences"

* Labor supply plots
preserve

* Create long format dataset
gen period = 1
gen time = "Midline"

* Generate variables with standardized names
foreach var in total_chore_hours total_water_hours total_ag_hours total_trade_hours total_wage_hours {
    gen `var' = midline_`var'
    gen `var'0 = baseline_`var'
}

* Expand to create baseline period
expand 2
bysort hhid: replace period = _n - 1
replace time = "Baseline" if period == 0

* Replace baseline values
foreach var in total_chore_hours total_water_hours total_ag_hours total_trade_hours total_wage_hours {
    replace `var' = `var'0 if period == 0
    drop `var'0
}

* Collapse to means
collapse (mean) total_*, by(time period)

* Domestic labor plot
twoway (connected total_chore_hours period, msymbol(O)) ///
       (connected total_water_hours period, msymbol(D)), ///
    xlabel(0 "Baseline" 1 "Midline") ///
    ylabel(0(20)120, format(%2.0f)) ///
    xtitle("Survey Round") ytitle("Hours per Week") ///
    legend(order(1 "Household Chores" 2 "Water Collection") cols(1)) ///
    title("Household Domestic Labor") ///
    subtitle("Mean weekly hours in domestic activities") ///
    name(domestic_labor, replace)
graph export "$figures/domestic_labor.png", replace width(1200)

* Market labor plot  
twoway (connected total_ag_hours period, msymbol(O)) ///
       (connected total_trade_hours period, msymbol(D)) ///
       (connected total_wage_hours period, msymbol(T)), ///
    xlabel(0 "Baseline" 1 "Midline") ///
    ylabel(0(10)50, format(%2.0f)) ///
    xtitle("Survey Round") ytitle("Hours per Week") ///
    legend(order(1 "Agricultural Work" 2 "Trading Activities" 3 "Wage Employment") cols(1)) ///
    title("Household Market Labor") ///
    subtitle("Mean weekly hours in income-generating activities") ///
    name(market_labor, replace)
graph export "$figures/market_labor.png", replace width(1200)

graph combine domestic_labor market_labor, ///
    title("Household Labor Supply Over Time") ///
    subtitle("Mean weekly hours in domestic and market activities") ///
    rows(1) xsize(12) ysize(5)
graph export "$figures/labor_combined.png", replace width(1600)

restore

******************************
* education outcomes
******************************

* education outcomes and labels
local attainment "max_grade"
local enrollment "any_enrolled num_enrolled"
local attendance "avg_attendance any_last_year full_attend"

// Update to match:
local lab_max_grade "Highest Grade"
local lab_any_enrolled "Any Child Enrolled"
local lab_num_enrolled "Number Enrolled"
local lab_avg_attendance "Avg Days Attended"
local lab_any_last_year "Any Child Attended Last Year"
local lab_full_attend "Full Week Attendance"

* baseline to midline mean plots
preserve 

* long dataset setup
gen period = 1
gen time = "Midline"

* generate education variables
foreach var of local attainment {
    gen `var' = midline_`var'
    gen `var'0 = baseline_`var'
}

foreach var of local enrollment {
    gen `var' = midline_`var'
    gen `var'0 = baseline_`var'
}

foreach var of local attendance {
    gen `var' = midline_`var'
    gen `var'0 = baseline_`var'
}

expand 2
bysort hhid: replace period = _n - 1
replace time = "Baseline" if period == 0

* Replace baseline values separately for each group
foreach var of local attainment {
    replace `var' = `var'0 if period == 0
    drop `var'0
}

foreach var of local enrollment {
    replace `var' = `var'0 if period == 0
    drop `var'0
}

foreach var of local attendance {
    replace `var' = `var'0 if period == 0
    drop `var'0
}

* means for each period
collapse (mean) max_grade any_enrolled num_enrolled avg_attendance any_last_year full_attend, by(time period)

* Plot education outcomes with dual axes
twoway (connected max_grade period, msymbol(O) yaxis(1)) ///
       (connected num_enrolled period, msymbol(T) yaxis(1)) ///
       (connected any_enrolled period, msymbol(D) yaxis(2)) ///
       (connected avg_attendance period, msymbol(S) yaxis(2)) ///
       (connected any_last_year period, msymbol(+) yaxis(2)) ///
       (connected full_attend period, msymbol(X) yaxis(2)), ///
    xlabel(0 "Baseline" 1 "Midline") ///
    xtitle("Survey Round") ///
    ytitle("Grade / Number Enrolled", axis(1)) ///
    ytitle("Share of Households", axis(2)) ///
    ylabel(0(2)8, axis(1)) ///
    ylabel(0(1)1, axis(2) format(%3.1f)) ///
    legend(order(1 "`lab_max_grade'" 2 "`lab_num_enrolled'" ///
                 3 "`lab_any_enrolled'" 4 "`lab_avg_attendance'" ///
                 5 "`lab_any_last_year'" 6 "`lab_full_attend'") cols(2)) ///
    title("Educational Outcomes Over Time") ///
    subtitle("Household education measures") ///
    name(education_all, replace)
graph export "$figures/education_outcomes.png", replace width(1200)
	
restore

*******************************************
* Work and School Days Lost
*******************************************

* Define outcomes and labels
local attendance_outcomes "work_days_lost any_absence absence_count"
local lab_work_days_lost "HH Days Lost to Illness"       // Total days lost across household members
local lab_any_absence "Any Child Missing Week+"          // Binary: any child missing week+ due to illness
local lab_absence_count "Children Missing Week+" 

* Baseline to midline mean plots
preserve 

* Long dataset with baseline and midline values
gen period = 1
gen time = "Midline"

foreach var of local attendance_outcomes {
    gen `var' = midline_`var'
    gen `var'0 = baseline_`var'
}

expand 2
bysort hhid: replace period = _n - 1
replace time = "Baseline" if period == 0

foreach var of local attendance_outcomes {
    replace `var' = `var'0 if period == 0
    drop `var'0
}

* Means for each period
collapse (mean) work_days_lost any_absence absence_count, by(time period)

* Work and school attendance plot
twoway (connected work_days_lost period, msymbol(O) yaxis(1)) ///
       (connected absence_count period, msymbol(T) yaxis(2)) ///
       (connected any_absence period, msymbol(D) yaxis(2)), ///
    xlabel(0 "Baseline" 1 "Midline") ///
    xtitle("Survey Round") ///
    ytitle("Days Lost to Illness", axis(1)) ///
    ytitle("Children Missing School / Share of HH", axis(2)) ///
    ylabel(0(5)20, axis(1)) ///  // Adjusted for work days lost mean
    ylabel(0(.2)1, axis(2) format(%3.1f)) ///  // Works for absence measures
    legend(order(1 "HH Days Lost to Illness" ///
                 2 "Children Missing Week+" ///
                 3 "Any Child Missing Week+") cols(1)) ///
    title("Work and School Attendance Over Time") ///
    subtitle("Household illness days and extended school absences") ///
    name(attendance, replace) 
graph export "$figures/attendance_outcomes.png", replace width(1200)

restore