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

* labels
local lab_water_any "Harvests Vegetation"
local lab_harvest_any "12-Month Collection"
local lab_removal_any "Removes Vegetation" 
local lab_recent_any "7-Day Collection"
local lab_harvest_kg "12-Month Collection (kg)"
local lab_recent_kg "7-Day Collection (kg)"

* simple baseline to midline mean plots
set scheme s2color

*******************************************
* AVR
*******************************************
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

* plot binary outcomes
twoway (connected avr_water_any period, msymbol(O)) ///
       (connected avr_removal_any period, msymbol(D)), ///
    xlabel(0 "Baseline" 1 "Midline") ///
    ylabel(0(.02).1, format(%3.2f)) ///
    xtitle("Survey Round") ytitle("Share of Households Participating") ///
    legend(order(1 "`lab_water_any'" 2 "`lab_removal_any'")) ///
    title("Household AVR Participation Over Time") ///
    subtitle("Mean household participation rates") ///
    graphregion(margin(l=5 r=5 t=2 b=2)) ///
    plotregion(margin(l=2 r=2 t=2 b=2)) ///
    name(binary, replace)
graph export "$figures/avr_participation.png", replace width(1200)

* plot continuous outcomes (kg)
twoway connected avr_harvest_kg avr_recent_kg period, ///
    xlabel(0 "Baseline" 1 "Midline") ///
    xtitle("Survey Round") ytitle("Average Household Collection (kg)") ///
    legend(order(1 "`lab_harvest_kg'" 2 "`lab_recent_kg'")) ///
    title("Household AVR Collection Amounts Over Time") ///
    subtitle("Mean household collection in kilograms") ///
    graphregion(margin(l=5 r=5 t=2 b=2)) ///
    plotregion(margin(l=2 r=2 t=2 b=2)) ///
    name(continuous, replace)
graph export "$figures/avr_collection.png", replace width(1200)

restore

**************************************
* Composting
**************************************

* Define composting outcomes and labels
local comp_outcomes "compost_any waste_any compost_plots waste_plots"
local lab_compost_any "Produces Compost"
local lab_waste_any "Collects Organic Waste"
local lab_compost_plots "Plots Using Compost"
local lab_waste_plots "Plots Using Organic Waste"


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
collapse (mean) *compost_* *waste_*, by(time period)

* binary composting adoption
twoway connected compost_any waste_any period, ///
    xlabel(0 "Baseline" 1 "Midline") ///
    ylabel(0(.02).08, format(%3.2f)) /// 
    xtitle("Survey Round") ytitle("Share of Households") ///
    legend(order(1 "`lab_compost_any'" 2 "`lab_waste_any'")) ///
    title("Household Composting Activities") ///
    subtitle("Share of households producing compost and collecting organic waste") ///
    name(comp_binary, replace)
	graph export "$figures/comp_binary.png", replace width(1200)

* plot-level application
twoway connected compost_plots waste_plots period, ///
    xlabel(0 "Baseline" 1 "Midline") ///
    ylabel(0(.02).08, format(%3.2f)) /// 
    xtitle("Survey Round") ytitle("Average Number of Plots") ///
    legend(order(1 "`lab_compost_plots'" 2 "`lab_waste_plots'")) ///
    title("Agricultural Application of Organic Inputs") ///
    subtitle("Average number of plots using compost or organic waste as fertilizer") ///
    name(comp_plots, replace)
	graph export "$figures/comp_plots.png", replace width(1200)
restore

*******************************************
* Food Security
*******************************************

* food security outcomes and labels
local food_outcomes "months_soudure rcsi_annual"
local lab_months_soudure "Lean Season Months"
local lab_rcsi_annual "12-Month rCSI"

* baseline to midline mean plots
preserve 

* long dataset with baseline and midline values
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

* means for each period
collapse (mean) months_soudure rcsi_annual, by(time period)

* food security outcomes
twoway connected months_soudure rcsi_annual period, ///
    xlabel(0 "Baseline" 1 "Midline") ///
    xtitle("Survey Round") ytitle("Household Food Security Measures") ///
    legend(order(1 "`lab_months_soudure'" 2 "`lab_rcsi_annual'")) ///
    title("Household Food Security Over Time") ///
    subtitle("Mean household lean season months and coping strategy index") ///
    name(food_security, replace) 
	graph export "$figures/food_security.png", replace width(1200)

restore

*****************************************
* Schisto
*****************************************

* schisto outcomes and labels
local schisto_outcomes "bilharzia_any meds_any diagnosed_any urine_any stool_any"
local lab_bilharzia_any "Diagnosed in Past 12mo"       // from health_5_3_2
local lab_meds_any "Received Schisto Medication"       // from health_5_5
local lab_diagnosed_any "Ever Diagnosed"               // from health_5_6 
local lab_urine_any "Blood in Urine"                  // from health_5_8
local lab_stool_any "Blood in Stool"

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
       (connected diagnosed_any period, msymbol(T)), ///
    xlabel(0 "Baseline" 1 "Midline") ///
    ylabel(0(.2)1, format(%3.2f)) ///
    xtitle("Survey Round") ytitle("Share of Households Reporting") ///
    legend(order(1 "`lab_bilharzia_any'" 2 "`lab_meds_any'" 3 "`lab_diagnosed_any'")) ///
    title("Schistosomiasis Symptoms and Treatment") ///
    subtitle("Mean household reporting rates") ///
    name(schisto_symptoms, replace)
	graph export "$figures/schisto_symptoms.png", replace width(1200)

* binary outcomes (testing)
twoway (connected urine_any period, msymbol(O)) ///
       (connected stool_any period, msymbol(D)), ///
    xlabel(0 "Baseline" 1 "Midline") ///
    ylabel(0(.2).8, format(%3.2f)) ///
    xtitle("Survey Round") ytitle("Share of Households") ///
    legend(order(1 "`lab_urine_any'" 2 "`lab_stool_any'")) ///
    title("Schistosomiasis Symptoms") ///
    subtitle("Mean household symptom rates") ///
    name(schisto_testing, replace)
	graph export "$figures/schisto_testing.png", replace width(1200)

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
local labor_outcomes "ag_workers total_ag_hours total_trade_hours total_wage_hours"
local school_outcomes "any_absence avg_attendance absence_count"

*labels for each outcome
local lab_work_days "Work Days Lost"
local lab_ag_workers "Agricultural Workers"
local lab_ag_hours "Agricultural Hours"
local lab_trade_hours "Trading Hours"
local lab_wage_hours "Wage Work Hours"
local lab_any_absence "Any School Absence"
local lab_attendance "Average Attendance"
local lab_absence_count "Number of Absences"

* baseline to midline mean plots
preserve 

* long dataset with baseline and midline values
gen period = 1
gen time = "Midline"

* loops for each outcome group
foreach var of local work_outcomes {
    gen `var' = midline_`var'
    gen `var'0 = baseline_`var'
}

foreach var of local labor_outcomes {
    gen `var' = midline_`var'
    gen `var'0 = baseline_`var'
}

foreach var of local school_outcomes {
    gen `var' = midline_`var'
    gen `var'0 = baseline_`var'
}

expand 2
bysort hhid: replace period = _n - 1
replace time = "Baseline" if period == 0

* means for each period
collapse (mean) work_* ag_* total_* any_* avg_* absence_*, by(time period)

* work days lost
twoway connected work_days_lost period, ///
    xlabel(0 "Baseline" 1 "Midline") ///
	ylabel(0(2)10, format(%2.1f)) ///
    xtitle("Survey Round") ytitle("Days Lost per Household") ///
    legend(order(1 "`lab_work_days'")) ///
    title("Work Days Lost Over Time") ///
    subtitle("Mean household productivity loss") ///
    name(work_loss, replace)
	graph export "$figures/work_loss.png", replace width(1200)	

* labor supply outcomes
twoway (connected ag_workers period, msymbol(O)) ///
       (connected total_ag_hours period, msymbol(D)) ///
       (connected total_trade_hours period, msymbol(T)) ///
       (connected total_wage_hours period, msymbol(S)), ///
    xlabel(0 "Baseline" 1 "Midline") ///
    xtitle("Survey Round") ytitle("Labor Supply Measures") ///
    legend(order(1 "`lab_ag_workers'" 2 "`lab_ag_hours'" ///
           3 "`lab_trade_hours'" 4 "`lab_wage_hours'") cols(2)) ///
    title("Household Labor Supply Over Time") ///
    subtitle("Mean household labor allocation across activities") ///
    name(labor_supply, replace)
	graph export "$figures/labor_supply.png", replace width(1200)	
	

* school attendance outcomes
twoway (connected any_absence period, msymbol(O)) ///
       (connected avg_attendance period, msymbol(D)) ///
       (connected absence_count period, msymbol(T)), ///
    xlabel(0 "Baseline" 1 "Midline") ///
    xtitle("Survey Round") ytitle("School Attendance Measures") ///
    legend(order(1 "`lab_any_absence'" 2 "`lab_attendance'" 3 "`lab_absence_count'")) ///
    title("School Attendance Over Time") ///
    subtitle("Mean household school participation measures") ///
    name(school_attendance, replace)
	graph export "$figures/school_attendance.png", replace width(1200)	

restore

******************************
* education outcomes
******************************

* education outcomes and labels
local attainment "max_grade"
local enrollment "any_enrolled num_enrolled"
local attendance "avg_attendance any_last_year full_attend"

* labels for education outcomes
local lab_max_grade "Maximum Grade Completed"
local lab_any_enrolled "Any Child Enrolled"
local lab_num_enrolled "Number of Children Enrolled"
local lab_avg_attendance "Average Attendance Rate"
local lab_any_last_year "Any Attendance Last Year"
local lab_full_attend "Full Attendance"

* baseline to midline mean plots
preserve 

* long dataset with baseline and midline values
gen period = 1
gen time = "Midline"

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

* means for each period
collapse (mean) max_grade any_enrolled num_enrolled avg_attendance any_last_year full_attend, by(time period)

* educational attainment
twoway connected max_grade period, ///
    xlabel(0 "Baseline" 1 "Midline") ///
	ylabel(0(2)10, format(%2.1f)) ///	
    xtitle("Survey Round") ytitle("Average Grade Level") ///
    legend(order(1 "`lab_max_grade'")) ///
    title("Educational Attainment Over Time") ///
    subtitle("Mean household maximum grade completed") ///
    name(educ_attainment, replace)
	graph export "$figures/educ_attainment.png", replace width(1200)	


* enrollment outcomes
twoway (connected any_enrolled period, msymbol(O)) ///
       (connected num_enrolled period, msymbol(D)), ///
    xlabel(0 "Baseline" 1 "Midline") ///
    xtitle("Survey Round") ytitle("Enrollment Measures") ///
    legend(order(1 "`lab_any_enrolled'" 2 "`lab_num_enrolled'")) ///
    title("School Enrollment Over Time") ///
    subtitle("Mean household enrollment measures") ///
    name(enrollment, replace)
	graph export "$figures/enrollment.png", replace width(1200)	
	

* attendance outcomes
twoway (connected avg_attendance period, msymbol(O)) ///
       (connected any_last_year period, msymbol(D)) ///
       (connected full_attend period, msymbol(T)), ///
    xlabel(0 "Baseline" 1 "Midline") ///
    xtitle("Survey Round") ytitle("Attendance Measures") ///
    legend(order(1 "`lab_avg_attendance'" 2 "`lab_any_last_year'" 3 "`lab_full_attend'")) ///
    title("School Attendance Patterns Over Time") ///
    subtitle("Mean household attendance measures") ///
    name(attendance, replace)
	graph export "$figures/attendance.png", replace width(1200)	

restore