**************************************************
* DISES ANCOVA Regressions Baseline to Midline V2
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

* Load specifications dataset
use "$specifications/v2_baseline_to_midline_pap_specifications.dta", clear

* Define global macros
global controls "q_51 q4 hh_numero living_01_bin asset_index_std hh_age_h i.hh_gender_h i.hh_education_skills_5_h"
global distance_vector "walking_minutes_to_arm_0 walking_minutes_to_arm_1 walking_minutes_to_arm_2 walking_minutes_to_arm_3"

* Set up controls and treatment variables
global controls "q_51 q4 hh_numero living_01_bin asset_index_std hh_age_h i.hh_gender_h i.hh_education_skills_5_h"
global distance_vector "walking_minutes_to_arm_0 walking_minutes_to_arm_1 walking_minutes_to_arm_2 walking_minutes_to_arm_3"

**************************************************
* Balance Table
**************************************************

* vars to check balance
* group variables by category for balance tests
local avr_vars "baseline_avr_water_any baseline_avr_harvest_any baseline_avr_removal_any baseline_avr_recent_any baseline_avr_harvest_kg baseline_avr_recent_kg"
local comp_vars "baseline_fert_ag_any baseline_fert_specific_any baseline_compost_any baseline_waste_any baseline_fert_ag_count baseline_compost_plots baseline_waste_plots"
local food_vars "baseline_months_soudure baseline_rcsi_annual"
local health_vars "baseline_bilharzia_any baseline_meds_any baseline_diagnosed_any baseline_urine_any baseline_stool_any baseline_bilharzia_count baseline_meds_count baseline_diagnosed_count baseline_urine_count baseline_stool_count"
local belief_vars "baseline_personal_risk baseline_hh_risk baseline_child_risk baseline_comm_land baseline_comm_water baseline_private_land baseline_comm_land_use baseline_comm_fish baseline_comm_harvest"
local work_school_vars "baseline_work_days_lost baseline_ag_workers baseline_total_ag_hours baseline_total_trade_hours baseline_total_wage_hours baseline_any_absence baseline_avg_attendance baseline_absence_count baseline_max_grade baseline_any_enrolled baseline_num_enrolled baseline_any_last_year baseline_full_attend"
local control_vars "q_51 q4 living_01_bin asset_index_std hh_age_h hh_gender_h hh_education_skills_5_h hh_numero walking_minutes_to_arm_0 walking_minutes_to_arm_1 walking_minutes_to_arm_2 walking_minutes_to_arm_3"

* create latex table
file open balance using "$specifications/balance_table.tex", write replace

* start longtable
file write balance "\begin{longtable}{lccccp{2cm}}" _n
file write balance "\caption{Balance Across Treatment Arms} \\" _n
file write balance "\label{tab:balance} \\" _n
file write balance "\toprule" _n
file write balance " & Control & Public & Private & Both & F-test \\" _n
file write balance "Variable & Group & Health & Benefits & Messages & p-value \\" _n
file write balance "\midrule" _n
file write balance "\endfirsthead" _n
file write balance "\multicolumn{6}{l}{Table \thetable{} continued} \\" _n
file write balance "\toprule" _n
file write balance " & Control & Public & Private & Both & F-test \\" _n
file write balance "Variable & Group & Health & Benefits & Messages & p-value \\" _n
file write balance "\midrule" _n
file write balance "\endhead" _n
file write balance "\midrule" _n
file write balance "\multicolumn{6}{r}{continued on next page} \\" _n
file write balance "\endfoot" _n
file write balance "\bottomrule" _n 
file write balance "\multicolumn{6}{p{0.8\textwidth}}{\footnotesize Notes: Table reports means and standard deviations (in parentheses) for each variable by treatment arm. The last column shows p-values from F-tests of joint equality across treatment arms. Standard errors are clustered at the village level. Analysis includes 2,029 households tracked from baseline to midline out of 2,080 baseline households.} \\" _n
file write balance "\endlastfoot" _n

* panel headers and content
file write balance "\multicolumn{6}{l}{\textbf{Panel A: Aquatic Vegetation Removal}} \\" _n
foreach var of local avr_vars {
    * same balance calculation code as before
    local varlabel: variable label `var'
    if "`varlabel'" == "" local varlabel "`var'"
    
    qui sum `var' if treatment_arm == 0
    local mean0 = r(mean)
    local sd0 = r(sd)
    
    forvalues t = 1/3 {
        qui sum `var' if treatment_arm == `t'
        local mean`t' = r(mean)
        local sd`t' = r(sd)
    }
    
    qui reg `var' i.treatment_arm, r cluster(hhid_village)
    test 1.treatment_arm 2.treatment_arm 3.treatment_arm
    local pval = r(p)
    
    file write balance "`varlabel' & "
    file write balance %9.3f (`mean0') " & "
    file write balance %9.3f (`mean1') " & "
    file write balance %9.3f (`mean2') " & "
    file write balance %9.3f (`mean3') " & "
    file write balance %9.3f (`pval') " \\" _n
    
    file write balance "& ("
    file write balance %9.3f (`sd0') ") & ("
    file write balance %9.3f (`sd1') ") & ("
    file write balance %9.3f (`sd2') ") & ("
    file write balance %9.3f (`sd3') ") & \\" _n
}

* repeat for other panels
file write balance "\midrule" _n
file write balance "\multicolumn{6}{l}{\textbf{Panel B: Composting Activities}} \\" _n
foreach var of local comp_vars {
    local varlabel: variable label `var'
    if "`varlabel'" == "" local varlabel "`var'"
    
    qui sum `var' if treatment_arm == 0
    local mean0 = r(mean)
    local sd0 = r(sd)
    
    forvalues t = 1/3 {
        qui sum `var' if treatment_arm == `t'
        local mean`t' = r(mean)
        local sd`t' = r(sd)
    }
    
    qui reg `var' i.treatment_arm, r cluster(hhid_village)
    test 1.treatment_arm 2.treatment_arm 3.treatment_arm
    local pval = r(p)
    
    file write balance "`varlabel' & "
    file write balance %9.3f (`mean0') " & "
    file write balance %9.3f (`mean1') " & "
    file write balance %9.3f (`mean2') " & "
    file write balance %9.3f (`mean3') " & "
    file write balance %9.3f (`pval') " \\" _n
    
    file write balance "& ("
    file write balance %9.3f (`sd0') ") & ("
    file write balance %9.3f (`sd1') ") & ("
    file write balance %9.3f (`sd2') ") & ("
    file write balance %9.3f (`sd3') ") & \\" _n
}

file write balance "\midrule" _n 
file write balance "\multicolumn{6}{l}{\textbf{Panel C: Food Security}} \\" _n
foreach var of local food_vars {
    local varlabel: variable label `var'
    if "`varlabel'" == "" local varlabel "`var'"
    
    qui sum `var' if treatment_arm == 0
    local mean0 = r(mean)
    local sd0 = r(sd)
    
    forvalues t = 1/3 {
        qui sum `var' if treatment_arm == `t'
        local mean`t' = r(mean)
        local sd`t' = r(sd)
    }
    
    qui reg `var' i.treatment_arm, r cluster(hhid_village)
    test 1.treatment_arm 2.treatment_arm 3.treatment_arm
    local pval = r(p)
    
    file write balance "`varlabel' & "
    file write balance %9.3f (`mean0') " & "
    file write balance %9.3f (`mean1') " & "
    file write balance %9.3f (`mean2') " & "
    file write balance %9.3f (`mean3') " & "
    file write balance %9.3f (`pval') " \\" _n
    
    file write balance "& ("
    file write balance %9.3f (`sd0') ") & ("
    file write balance %9.3f (`sd1') ") & ("
    file write balance %9.3f (`sd2') ") & ("
    file write balance %9.3f (`sd3') ") & \\" _n
}

file write balance "\midrule" _n
file write balance "\multicolumn{6}{l}{\textbf{Panel D: Health Outcomes}} \\" _n
foreach var of local health_vars {
    local varlabel: variable label `var'
    if "`varlabel'" == "" local varlabel "`var'"
    
    qui sum `var' if treatment_arm == 0
    local mean0 = r(mean)
    local sd0 = r(sd)
    
    forvalues t = 1/3 {
        qui sum `var' if treatment_arm == `t'
        local mean`t' = r(mean)
        local sd`t' = r(sd)
    }
    
    qui reg `var' i.treatment_arm, r cluster(hhid_village)
    test 1.treatment_arm 2.treatment_arm 3.treatment_arm
    local pval = r(p)
    
    file write balance "`varlabel' & "
    file write balance %9.3f (`mean0') " & "
    file write balance %9.3f (`mean1') " & "
    file write balance %9.3f (`mean2') " & "
    file write balance %9.3f (`mean3') " & "
    file write balance %9.3f (`pval') " \\" _n
    
    file write balance "& ("
    file write balance %9.3f (`sd0') ") & ("
    file write balance %9.3f (`sd1') ") & ("
    file write balance %9.3f (`sd2') ") & ("
    file write balance %9.3f (`sd3') ") & \\" _n
}

file write balance "\midrule" _n
file write balance "\multicolumn{6}{l}{\textbf{Panel E: Property Rights Beliefs}} \\" _n
foreach var of local belief_vars {
    local varlabel: variable label `var'
    if "`varlabel'" == "" local varlabel "`var'"
    
    qui sum `var' if treatment_arm == 0
    local mean0 = r(mean)
    local sd0 = r(sd)
    
    forvalues t = 1/3 {
        qui sum `var' if treatment_arm == `t'
        local mean`t' = r(mean)
        local sd`t' = r(sd)
    }
    
    qui reg `var' i.treatment_arm, r cluster(hhid_village)
    test 1.treatment_arm 2.treatment_arm 3.treatment_arm
    local pval = r(p)
    
    file write balance "`varlabel' & "
    file write balance %9.3f (`mean0') " & "
    file write balance %9.3f (`mean1') " & "
    file write balance %9.3f (`mean2') " & "
    file write balance %9.3f (`mean3') " & "
    file write balance %9.3f (`pval') " \\" _n
    
    file write balance "& ("
    file write balance %9.3f (`sd0') ") & ("
    file write balance %9.3f (`sd1') ") & ("
    file write balance %9.3f (`sd2') ") & ("
    file write balance %9.3f (`sd3') ") & \\" _n
}

file write balance "\midrule" _n
file write balance "\multicolumn{6}{l}{\textbf{Panel F: Work and School}} \\" _n
foreach var of local work_school_vars {
    local varlabel: variable label `var'
    if "`varlabel'" == "" local varlabel "`var'"
    
    qui sum `var' if treatment_arm == 0
    local mean0 = r(mean)
    local sd0 = r(sd)
    
    forvalues t = 1/3 {
        qui sum `var' if treatment_arm == `t'
        local mean`t' = r(mean)
        local sd`t' = r(sd)
    }
    
    qui reg `var' i.treatment_arm, r cluster(hhid_village)
    test 1.treatment_arm 2.treatment_arm 3.treatment_arm
    local pval = r(p)
    
    file write balance "`varlabel' & "
    file write balance %9.3f (`mean0') " & "
    file write balance %9.3f (`mean1') " & "
    file write balance %9.3f (`mean2') " & "
    file write balance %9.3f (`mean3') " & "
    file write balance %9.3f (`pval') " \\" _n
    
    file write balance "& ("
    file write balance %9.3f (`sd0') ") & ("
    file write balance %9.3f (`sd1') ") & ("
    file write balance %9.3f (`sd2') ") & ("
    file write balance %9.3f (`sd3') ") & \\" _n
}

file write balance "\midrule" _n
file write balance "\multicolumn{6}{l}{\textbf{Panel G: Control Variables}} \\" _n
foreach var of local control_vars {
    local varlabel: variable label `var'
    if "`varlabel'" == "" local varlabel "`var'"
    
    qui sum `var' if treatment_arm == 0
    local mean0 = r(mean)
    local sd0 = r(sd)
    
    forvalues t = 1/3 {
        qui sum `var' if treatment_arm == `t'
        local mean`t' = r(mean)
        local sd`t' = r(sd)
    }
    
    qui reg `var' i.treatment_arm, r cluster(hhid_village)
    test 1.treatment_arm 2.treatment_arm 3.treatment_arm
    local pval = r(p)
    
    file write balance "`varlabel' & "
    file write balance %9.3f (`mean0') " & "
    file write balance %9.3f (`mean1') " & "
    file write balance %9.3f (`mean2') " & "
    file write balance %9.3f (`mean3') " & "
    file write balance %9.3f (`pval') " \\" _n
    
    file write balance "& ("
    file write balance %9.3f (`sd0') ") & ("
    file write balance %9.3f (`sd1') ") & ("
    file write balance %9.3f (`sd2') ") & ("
    file write balance %9.3f (`sd3') ") & \\" _n
}

* close table and document
file write balance "\end{longtable}" _n

file close balance

**************************************************
* 1.1.1: AVR Main Effects
**************************************************

* avr participation outcomes 
local avr_outcomes "avr_water_any avr_harvest_any avr_removal_any avr_recent_any avr_harvest_kg avr_recent_kg"

* labels
local lab_water_any "Harvests from Water Sources"
local lab_harvest_any "12-Month Vegetation Collection"
local lab_removal_any "Removes Aquatic Vegetation" 
local lab_recent_any "7-Day Vegetation Collection"
local lab_harvest_kg "12-Month Collection (kg)"
local lab_recent_kg "7-Day Collection (kg)"

* main effects (eq 1 and 2)
eststo clear
foreach y of local avr_outcomes {
    * main treatment effect (eq 1)
    eststo main_`y': reg midline_`y' trained_hh baseline_`y' ///
        $controls $distance_vector i.auction_village, vce(cluster hhid_village)
    
    * treatment arm effects (eq 2) - explicitly set control as base
    eststo arms_`y': reg midline_`y' ib0.treatment_arm baseline_`y' ///
        $controls $distance_vector i.auction_village, vce(cluster hhid_village)
    test 1.treatment_arm = 2.treatment_arm
    estadd scalar p_12 = r(p)
    test 1.treatment_arm = 3.treatment_arm
    estadd scalar p_13 = r(p)
    test 2.treatment_arm = 3.treatment_arm
    estadd scalar p_23 = r(p)
    
    * Calculate control group mean for comparison
    qui sum midline_`y' if treatment_arm==0
    estadd scalar control_mean = r(mean)
}

* calc and store control means first
foreach y of local avr_outcomes {
    qui sum midline_`y' if trained_hh==0
    estadd scalar control_mean = r(mean), replace: main_`y'
}

* export main treatment effects (eq 1)
esttab main_* using "$specifications/avr_main_effects.tex", replace ///
    style(tex) booktabs ///
    prehead("\begin{table}[htbp]\centering" ///
        "\begin{threeparttable}" ///
        "\caption{Treatment Effects on Aquatic Vegetation Removal (AVR)}" ///
        "\begin{tabular}{l*{6}{c}}") ///
    posthead("\midrule" ///
        "&\multicolumn{4}{c}{Binary Indicators}&\multicolumn{2}{c}{Collection Amount (kg)}\\\cmidrule(lr){2-5}\cmidrule(lr){6-7}") ///
    prefoot("\midrule") ///
    postfoot("\bottomrule" ///
        "\end{tabular}" ///
        "\begin{tablenotes}\footnotesize" ///
        "\item \textit{Notes:} Dependent variables include binary indicators and continuous measures (kg) for different types of AVR participation. Control group means at midline shown below estimates for comparison. All specifications include baseline outcome, household controls, walking distances to nearest villages by treatment arm, and auction experiment fixed effects. Standard errors clustered at village level." ///
        "\end{tablenotes}" ///
        "\end{threeparttable}" ///
        "\end{table}") ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    keep(trained_hh) ///
    stats(control_mean N r2, ///
        labels("Control Mean" "N" "R-squared") ///
        fmt(3 %9.0f 3)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    collabels(none) ///
mlabels("\shortstack{Harvest Vegetation\\(12mo)}" ///
        "\shortstack{Collect Vegetation\\(12mo)}" ///
        "\shortstack{Remove Vegetation\\(12mo)}" ///
        "\shortstack{Harvest Vegetation\\(7-day)}" ///
        "\shortstack{Avg. Weekly Amount\\(12mo)}" ///
        "\shortstack{Total Amount\\(7-day)}", ///
        prefix(\multicolumn{1}{c}{) suffix(}))
		
* export treatment arm effects (eq 2)
esttab arms_* using "$specifications/avr_treatment_arms.tex", replace ///
    style(tex) booktabs ///
    prehead("\begin{table}[htbp]\centering" ///
        "\begin{threeparttable}" ///
        "\caption{Treatment Arm Effects on Aquatic Vegetation Removal (AVR)}" ///
        "\begin{tabular}{l*{6}{c}}") ///
    posthead("\midrule" ///
        "&\multicolumn{4}{c}{Binary Indicators}&\multicolumn{2}{c}{Collection Amount (kg)}\\\cmidrule(lr){2-5}\cmidrule(lr){6-7}") ///
    prefoot("\midrule") ///
    postfoot("\bottomrule" ///
        "\end{tabular}" ///
        "\begin{tablenotes}\footnotesize" ///
        "\item \textit{Notes:} Treatment arms: A=Public Health, B=Private Benefits, C=Both Messages. Point estimates show effects relative to control group. Control group means at midline shown below for comparison. All specifications include baseline outcome, household controls, walking distances to nearest villages by treatment arm, and auction experiment fixed effects. Standard errors clustered at village level." ///
        "\end{tablenotes}" ///
        "\end{threeparttable}" ///
        "\end{table}") ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    keep(*treatment_arm) ///
    drop(0.treatment_arm) ///
    stats(control_mean p_12 p_13 p_23 N r2, ///
        labels("Control Mean" "P-value A=B" "P-value A=C" "P-value B=C" "N" "R-squared") ///
        fmt(3 3 3 3 %9.0f 3)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    collabels(none) ///
mlabels("\shortstack{Harvest Vegetation\\(12mo)}" ///
        "\shortstack{Collect Vegetation\\(12mo)}" ///
        "\shortstack{Remove Vegetation\\(12mo)}" ///
        "\shortstack{Harvest Vegetation\\(7-day)}" ///
        "\shortstack{Avg. Weekly Amount\\(12mo)}" ///
        "\shortstack{Total Amount\\(7-day)}", ///
        prefix(\multicolumn{1}{c}{) suffix(}))
		
**************************************************
* 1.1.2: AVR Spillover Effects
**************************************************

* generate spillover indicators
gen local_control = (treatment_arm != 0 & trained_hh == 0)
gen treated = trained_hh

* generate arm-specific spillover indicators first
foreach arm in A B C {
    local armnum = cond("`arm'"=="A",1,cond("`arm'"=="B",2,3))
    gen T_`arm'_L = (treatment_arm == `armnum' & trained_hh == 0)
    gen T_`arm'_T = (treatment_arm == `armnum' & trained_hh == 1)
}

* spillover effects (Equation 3)
eststo clear
foreach y of local avr_outcomes {
    * Calculate control mean first
    qui sum midline_`y' if treatment_arm==0
    local cm = r(mean)
    
    * basic spillovers
    eststo spill_`y': reg midline_`y' local_control treated baseline_`y' ///
        $controls $distance_vector i.auction_village, vce(cluster hhid_village)
    
    * Store control mean
    estadd scalar control_mean = `cm'
    
    test local_control = treated
    estadd scalar p_diff = r(p)
    
    * arm-specific spillovers 
    eststo spill_arm_`y': reg midline_`y' T_A_L T_A_T T_B_L T_B_T T_C_L T_C_T baseline_`y' ///
        $controls $distance_vector i.auction_village, vce(cluster hhid_village)
    
    * Store same control mean for arm-specific results
    estadd scalar control_mean = `cm'
    
    * test equality across arms for local controls
    test T_A_L = T_B_L
    estadd scalar p_L_AB = r(p)
    test T_A_L = T_C_L  
    estadd scalar p_L_AC = r(p)
    test T_B_L = T_C_L
    estadd scalar p_L_BC = r(p)
    
    * test local vs treated within arms
    test T_A_L = T_A_T
    estadd scalar p_LT_A = r(p)
    test T_B_L = T_B_T
    estadd scalar p_LT_B = r(p)
    test T_C_L = T_C_T
    estadd scalar p_LT_C = r(p)
}

* export basic spillover results (Equation 3)
esttab spill_avr_* using "$specifications/avr_spillovers.tex", replace ///
    style(tex) booktabs ///
    prehead("\begin{table}[htbp]\centering" ///
        "\begin{threeparttable}" ///
        "\caption{AVR Spillover Effects}" ///
        "\begin{tabular}{l*{6}{c}}") ///
    posthead("\midrule" ///
        "&\multicolumn{4}{c}{Binary Indicators}&\multicolumn{2}{c}{Collection Amount (kg)}\\\cmidrule(lr){2-5}\cmidrule(lr){6-7}") ///
    prefoot("\midrule") ///
    postfoot("\bottomrule" ///
        "\end{tabular}" ///
        "\begin{tablenotes}\footnotesize" ///
        "\item \textit{Notes:} Local control indicates untreated households in treatment villages. All specifications include baseline outcome, household controls, walking distances to nearest villages by treatment arm, and auction experiment fixed effects. Standard errors clustered at village level." ///
        "\end{tablenotes}" ///
        "\end{threeparttable}" ///
        "\end{table}") ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    keep(local_control treated) ///
    order(local_control treated) ///
    stats(control_mean p_diff N r2, ///
        labels("Control Mean" "P-value L=T" "N" "R-squared") ///
        fmt(3 3 %9.0f 3)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    collabels(none) ///
    mlabels("\shortstack{Harvests from\\Water Sources}" ///
            "\shortstack{12-Month\\Collection}" ///
            "\shortstack{Removes\\Aquatic Veg.}" ///
            "\shortstack{7-Day\\Collection}" ///
            "\shortstack{12-Month\\Amount}" ///
            "\shortstack{7-Day\\Amount}", ///
        prefix(\multicolumn{1}{c}{) suffix(}))

* export arm-specific spillover results 
esttab spill_arm_avr_* using "$specifications/avr_arm_spillovers.tex", replace ///
    style(tex) booktabs ///
    prehead("\begin{table}[htbp]\centering" ///
        "\begin{threeparttable}" ///
        "\caption{AVR Arm-Specific Spillover Effects}" ///
        "\begin{tabular}{l*{6}{c}}") ///
    posthead("\midrule" ///
        "&\multicolumn{4}{c}{Binary Indicators}&\multicolumn{2}{c}{Collection Amount (kg)}\\\cmidrule(lr){2-5}\cmidrule(lr){6-7}") ///
    prefoot("\midrule") ///
    postfoot("\bottomrule" ///
        "\end{tabular}" ///
        "\begin{tablenotes}\footnotesize" ///
        "\item \textit{Notes:} L indicates local control (untreated) households, T indicates treated households, by treatment arm (A=Public Health, B=Private Benefits, C=Both). All specifications include baseline outcome, household controls, walking distances to nearest villages by treatment arm, and auction experiment fixed effects. Standard errors clustered at village level." ///
        "\end{tablenotes}" ///
        "\end{threeparttable}" ///
        "\end{table}") ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    keep(T_A_L T_A_T T_B_L T_B_T T_C_L T_C_T) ///
    order(T_A_L T_A_T T_B_L T_B_T T_C_L T_C_T) ///
    stats(control_mean p_L_AB p_L_AC p_L_BC p_LT_A p_LT_B p_LT_C N r2, ///
        labels("Control Mean" "P-value L_A=L_B" "P-value L_A=L_C" "P-value L_B=L_C" ///
               "P-value L=T in A" "P-value L=T in B" "P-value L=T in C" "N" "R-squared") ///
        fmt(3 3 3 3 3 3 3 %9.0f 3)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    collabels(none) ///
    mlabels("\shortstack{Harvests from\\Water Sources}" ///
            "\shortstack{12-Month\\Collection}" ///
            "\shortstack{Removes\\Aquatic Veg.}" ///
            "\shortstack{7-Day\\Collection}" ///
            "\shortstack{12-Month\\Amount}" ///
            "\shortstack{7-Day\\Amount}", ///
        prefix(\multicolumn{1}{c}{) suffix(}))

**************************************************
* 1.1.3: Changes in Pure Control Villages
**************************************************

* AVR outcomes in pure control villages
eststo clear
foreach y in avr_water_any avr_harvest_any avr_removal_any avr_recent_any {
    
    * reshape baseline and midline into long format for pure controls
    preserve
    keep if treatment_arm == 0
    
    * create long dataset with baseline and midline values
    gen byte time = 1
    gen `y' = midline_`y'
    gen `y'0 = baseline_`y'
    
    expand 2
    bysort hhid: replace time = _n - 1
    replace `y' = `y'0 if time == 0
    drop `y'0
    
    * Calculate baseline mean
    qui sum `y' if time==0
    local baseline_mean = r(mean)
    
    * estimate change over time
    eststo control_`y': reg `y' time $controls $distance_vector i.auction_village, ///
        vce(cluster hhid_village)
    
    * store baseline mean
    estadd scalar baseline_mean = `baseline_mean'
        
    restore
}


* export results for pure control changes
esttab control_* using "$specifications/avr_control_changes.tex", replace ///
    style(tex) booktabs ///
    prehead("\begin{table}[htbp]\centering" ///
        "\begin{threeparttable}" ///
        "\caption{Changes in AVR Practices in Pure Control Villages}" ///
        "\begin{tabular}{l*{4}{c}}") ///
    posthead("\midrule") ///
    prefoot("\midrule") ///
    postfoot("\bottomrule" ///
        "\end{tabular}" ///
        "\begin{tablenotes}\footnotesize" ///
        "\item \textit{Notes:} Sample restricted to pure control villages. Coefficient shows change from baseline to midline. All specifications include household controls, walking distances to nearest villages by treatment arm, and auction experiment fixed effects. Standard errors clustered at village level." ///
        "\end{tablenotes}" ///
        "\end{threeparttable}" ///
        "\end{table}") ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    keep(time) ///
    stats(baseline_mean N r2, ///
        labels("Baseline Mean" "N" "R-squared") ///
        fmt(3 %9.0f 3)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    collabels(none) ///
    mlabels("\shortstack{Harvests from\\Water Sources}" ///
            "\shortstack{12-Month\\Collection}" ///
            "\shortstack{Removes\\Aquatic Veg.}" ///
            "\shortstack{7-Day\\Collection}", ///
        prefix(\multicolumn{1}{c}{) suffix(}))
	
**************************************************
* 1.1.4: Compost Production Analysis
**************************************************

* Fertilizer and composting outcomes
local fert_outcomes "fert_ag_any fert_specific_any"        // AVR fertilizer use
local comp_outcomes "compost_any waste_any"                // Composting practices
local all_outcomes "`fert_outcomes' `comp_outcomes'"       // Combined outcomes

* Treatment arm effects (eq 2)
eststo clear
foreach y of local all_outcomes {
    eststo arm_`y': reg midline_`y' i.treatment_arm baseline_`y' ///
        $controls $distance_vector i.auction_village, vce(cluster hhid_village)
        
    qui sum midline_`y' if treatment_arm==0
    estadd scalar control_mean = r(mean)
        
    test 1.treatment_arm = 2.treatment_arm
    estadd scalar p_12 = r(p)
    test 1.treatment_arm = 3.treatment_arm
    estadd scalar p_13 = r(p)
    test 2.treatment_arm = 3.treatment_arm
    estadd scalar p_23 = r(p)
}

* spillover effects (eq 3)
foreach y of local all_outcomes {
    * Calculate control mean first
    qui sum midline_`y' if treatment_arm==0
    local cm = r(mean)
    
    * gen treatment indicators
    gen T_L = (treatment_arm != 0 & trained_hh == 0)  // local controls
    gen T_T = trained_hh                              // treat households
    
    eststo spill_`y': reg midline_`y' T_L T_T baseline_`y' ///
        $controls $distance_vector i.auction_village, vce(cluster hhid_village)
    
    * Store control mean
    estadd scalar control_mean = `cm'
    
    * test difference between local controls and treated
    test T_L = T_T
    estadd scalar p_diff = r(p)
    
    drop T_L T_T
}

*  store control means first
foreach y of local all_outcomes {
    qui sum midline_`y' if treatment_arm==0
    estadd scalar control_mean = r(mean), replace: arm_`y'
}

* Treatment arm effects with control means
esttab arm_* using "$specifications/compost_arm_effects.tex", replace ///
    style(tex) booktabs ///
    prehead("\begin{table}[htbp]\centering" ///
        "\begin{threeparttable}" ///
        "\caption{Treatment Arm Effects on Fertilizer and Compost Use}" ///
        "\begin{tabular}{l*{4}{c}}") ///    // Changed to 4 columns
    posthead("\midrule") ///
    prefoot("\midrule") ///
    postfoot("\bottomrule" ///
        "\end{tabular}" ///
        "\begin{tablenotes}\footnotesize" ///
        "\item \textit{Notes:} Treatment arms: A=Public Health, B=Private Benefits, C=Both Messages. Control group means at midline shown below estimates. All specifications include baseline outcome, household controls, walking distances to nearest villages by treatment arm, and auction experiment fixed effects. Standard errors clustered at village level." ///
        "\end{tablenotes}" ///
        "\end{threeparttable}" ///
        "\end{table}") ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    keep(*treatment_arm) ///
    drop(0.treatment_arm) ///
    stats(control_mean p_12 p_13 p_23 N r2, ///
        labels("Control Mean" "P-value A=B" "P-value A=C" "P-value B=C" "N" "R-squared") ///
        fmt(3 3 3 3 %9.0f 3)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    collabels(none) ///
mlabels("\shortstack{Any HH Member\\AVR for Fertilizer}" ///
        "\shortstack{Specific AVR\\for Fertilizer}" ///
        "\shortstack{Any Plot\\Using Compost}" ///
        "\shortstack{Any Plot Using\\Household Waste}", ///
        prefix(\multicolumn{1}{c}{) suffix(}))
* export spillover effects
esttab spill_* using "$specifications/compost_spillovers.tex", replace ///
    style(tex) booktabs ///
    prehead("\begin{table}[htbp]\centering" ///
        "\begin{threeparttable}" ///
        "\caption{Spillover Effects on Compost Activities}" ///
        "\begin{tabular}{l*{2}{c}}") ///
    posthead("\midrule") ///
    prefoot("\midrule") ///
    postfoot("\bottomrule" ///
        "\end{tabular}" ///
        "\begin{tablenotes}\footnotesize" ///
        "\item \textit{Notes:} L indicates local control (untreated) households, T indicates treated households. All specifications include baseline outcome, household controls, walking distances to nearest villages by treatment arm, and auction experiment fixed effects. Standard errors clustered at village level." ///
        "\end{tablenotes}" ///
        "\end{threeparttable}" ///
        "\end{table}") ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    keep(T_L T_T) ///
    stats(control_mean p_diff N r2, ///
        labels("Control Mean" "P-value L=T" "N" "R-squared") ///
        fmt(3 3 %9.0f 3)) ///
    collabels(none) ///
mlabels("\shortstack{Any HH Member\\AVR for Fertilizer}" ///
        "\shortstack{Specific AVR\\for Fertilizer}" ///
        "\shortstack{Any Plot\\Using Compost}" ///
        "\shortstack{Any Plot Using\\Household Waste}", ///
    prefix(\multicolumn{1}{c}{) suffix(}))
**************************************************
* 1.1.5: Private Benefits Spillovers for Composting
**************************************************

eststo clear

* basic spillovers in private benefits arms only (eq 3)
foreach y of local all_outcomes {
    * restrict to arms B, C and control
    preserve
    keep if inlist(treatment_arm, 0, 2, 3)  // control, private benefits, both
    
    * Calculate control mean first
    qui sum midline_`y' if treatment_arm==0
    local cm = r(mean)
    
    * gen indicators
    gen T_L = (treatment_arm != 0 & trained_hh == 0)  // local controls
    gen T_T = trained_hh                              // Treated households
    
    eststo priv_`y': reg midline_`y' T_L T_T baseline_`y' ///
        $controls $distance_vector i.auction_village, vce(cluster hhid_village)
    
    * Store control mean
    estadd scalar control_mean = `cm'
    
    test T_L = T_T
    estadd scalar p_diff = r(p)
    restore
}

* arm-specific spillovers (eq 4)
foreach y of local all_outcomes {
    * Calculate control mean first 
    qui sum midline_`y' if treatment_arm==0
    local cm = r(mean)
    
    * clean up any existing treatment indicators first
    cap drop T_*_L T_*_T
    
    * gen arm-specific indicators
    foreach arm in B C {
        local armnum = cond("`arm'"=="B",2,3)
        gen T_`arm'_L = (treatment_arm == `armnum' & trained_hh == 0)
        gen T_`arm'_T = (treatment_arm == `armnum' & trained_hh == 1)
    }
    
    eststo arms_`y': reg midline_`y' T_B_L T_B_T T_C_L T_C_T baseline_`y' ///
        $controls $distance_vector i.auction_village, vce(cluster hhid_village)
    
    * Store control mean
    estadd scalar control_mean = `cm'
    
    * test spillovers within private arms
    test T_B_L = T_B_T
    estadd scalar p_B = r(p)
    test T_C_L = T_C_T
    estadd scalar p_C = r(p)
    
    * test spillover differences across arms
    test T_B_L = T_C_L
    estadd scalar p_L_BC = r(p)

    drop T_*_L T_*_T
}

* export private benefits spillover results
esttab priv_* using "$specifications/compost_private_spillovers.tex", replace ///
    style(tex) booktabs ///
    prehead("\begin{table}[htbp]\centering" ///
        "\begin{threeparttable}" ///
        "\caption{Private Benefits Spillovers on Compost Activities}" ///
        "\begin{tabular}{l*{2}{c}}") ///
    posthead("\midrule") ///
    prefoot("\midrule") ///
    postfoot("\bottomrule" ///
        "\end{tabular}" ///
        "\begin{tablenotes}\footnotesize" ///
        "\item \textit{Notes:} Sample restricted to control villages and those receiving private benefits information (arms B and C). L indicates local control (untreated) households, T indicates treated households. All specifications include baseline outcome, household controls, walking distances to nearest villages by treatment arm, and auction experiment fixed effects. Standard errors clustered at village level." ///
        "\end{tablenotes}" ///
        "\end{threeparttable}" ///
        "\end{table}") ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    keep(T_L T_T) ///
    stats(control_mean p_diff N r2, ///
        labels("Control Mean" "P-value L=T" "N" "R-squared") ///
        fmt(3 3 %9.0f 3)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    collabels(none) ///
mlabels("\shortstack{Any HH Member\\AVR for Fertilizer}" ///
        "\shortstack{Specific AVR\\for Fertilizer}" ///
        "\shortstack{Any Plot\\Using Compost}" ///
        "\shortstack{Any Plot Using\\Household Waste}", ///
    prefix(\multicolumn{1}{c}{) suffix(}))

* export arm-specific private benefits results 
esttab arms_* using "$specifications/compost_private_arms.tex", replace ///
    style(tex) booktabs ///
    prehead("\begin{table}[htbp]\centering" ///
        "\begin{threeparttable}" ///
        "\caption{Arm-Specific Private Benefits Spillovers}" ///
        "\begin{tabular}{l*{2}{c}}") ///
    posthead("\midrule") ///
    prefoot("\midrule") ///
    postfoot("\bottomrule" ///
        "\end{tabular}" ///
        "\begin{tablenotes}\footnotesize" ///
        "\item \textit{Notes:} Compares spillovers between private benefits only (B) and both messages (C) arms. L indicates local control (untreated) households, T indicates treated households. All specifications include baseline outcome, household controls, walking distances to nearest villages by treatment arm, and auction experiment fixed effects. Standard errors clustered at village level." ///
        "\end{tablenotes}" ///
        "\end{threeparttable}" ///
        "\end{table}") ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    keep(T_*) ///
    order(T_B_L T_B_T T_C_L T_C_T) ///
    stats(control_mean p_B p_C p_L_BC N r2, ///
        labels("Control Mean" "P-value L=T in Private" "P-value L=T in Both" "P-value Private L=Both L" "N" "R-squared") ///
        fmt(3 3 3 3 %9.0f 3)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    collabels(none) ///
mlabels("\shortstack{Any HH Member\\AVR for Fertilizer}" ///
        "\shortstack{Specific AVR\\for Fertilizer}" ///
        "\shortstack{Any Plot\\Using Compost}" ///
        "\shortstack{Any Plot Using\\Household Waste}", ///
    prefix(\multicolumn{1}{c}{) suffix(}))

**************************************************
* 1.1.6: Total Factor Productivity and Profitability
**************************************************
* wait until molly gets done with production functions

* Food security outcomes with phases
local food_outcomes "months_soudure rcsi_annual ipc_phase"     // main outcomes
local rcsi_components "rcsi_work rcsi_assets rcsi_migrate rcsi_skip"  // coping components 
local food_labels "Lean Season Months" "Coping Score" "Food Security Phase"

* Treatment arm effects on food security (eq 2)
eststo clear
foreach y of local food_outcomes {
    * Run regression
    eststo food_`y': reg midline_`y' i.treatment_arm baseline_`y' ///
        $controls $distance_vector i.auction_village, vce(cluster hhid_village)
    
    * Calculate and store control mean
    qui sum midline_`y' if treatment_arm==0
    estadd scalar control_mean = r(mean)
    
    * Test differences between arms
    test 1.treatment_arm = 2.treatment_arm  
    estadd scalar p_12 = r(p)
    test 1.treatment_arm = 3.treatment_arm  
    estadd scalar p_13 = r(p)
    test 2.treatment_arm = 3.treatment_arm  
    estadd scalar p_23 = r(p)
}

* Export food security results
esttab food_* using "$specifications/food_security.tex", replace ///
    style(tex) booktabs ///
    prehead("\begin{table}[htbp]\centering" ///
        "\begin{threeparttable}" ///
        "\caption{Treatment Effects on Food Security Outcomes}" ///
        "\begin{tabular}{l*{3}{c}}") ///
    posthead("\midrule") ///
    prefoot("\midrule") ///
    postfoot("\bottomrule" ///
        "\end{tabular}" ///
        "\begin{tablenotes}\footnotesize" ///
        "\item \textit{Notes:} Treatment arms: A=Public Health, B=Private Benefits, C=Both Messages. Control group means at midline shown below estimates for comparison. Lean season months measures self-reported soudure duration. Coping Score is sum of weighted coping strategies. Food Security Phase: 1=Minimal (0-2), 2=Stressed (3-4), 3=Crisis (>4). All specifications include baseline outcome, household controls, walking distances to nearest villages by treatment arm, and auction experiment fixed effects. Standard errors clustered at village level." ///
        "\end{tablenotes}" ///
        "\end{threeparttable}" ///
        "\end{table}") ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    keep(1.treatment_arm 2.treatment_arm 3.treatment_arm) /// 
    stats(control_mean p_12 p_13 p_23 N r2, ///
        labels("Control Mean" "P-value A=B" "P-value A=C" "P-value B=C" "N" "R-squared") ///
        fmt(3 3 3 3 %9.0f 3)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    collabels(none) ///
    mlabels("\shortstack{Lean Season\\Months}" ///
            "\shortstack{Coping\\Score}" ///
            "\shortstack{Food Security\\Phase}", ///
        prefix(\multicolumn{1}{c}{) suffix(}))

* RCSI component regressions
eststo clear
foreach y of local rcsi_components {
    * Run regression
    eststo rcsi_`y': reg midline_`y' i.treatment_arm baseline_`y' ///
        $controls $distance_vector i.auction_village, vce(cluster hhid_village)
    
    * Calculate and store control mean
    qui sum midline_`y' if treatment_arm==0
    estadd scalar control_mean = r(mean)
    
    * Test differences between arms
    test 1.treatment_arm = 2.treatment_arm  // pub vs priv Benefits
    estadd scalar p_12 = r(p)
    test 1.treatment_arm = 3.treatment_arm  // pub vs both
    estadd scalar p_13 = r(p)
    test 2.treatment_arm = 3.treatment_arm  // priv vs both
    estadd scalar p_23 = r(p)
}

* export RCSI component results  
esttab rcsi_* using "$specifications/food_security_components.tex", replace ///
    style(tex) booktabs ///
    prehead("\begin{table}[htbp]\centering" ///
        "\begin{threeparttable}" ///
        "\caption{Treatment Effects on Coping Strategy Components}" ///
        "\begin{tabular}{l*{4}{c}}") ///
    posthead("\midrule") ///
    prefoot("\midrule") ///
    postfoot("\bottomrule" ///
        "\end{tabular}" ///
        "\begin{tablenotes}\footnotesize" ///
        "\item \textit{Notes:} Decomposition of Reduced Coping Strategies Index (RCSI) into component measures. Control group means at midline shown below estimates for comparison. All specifications include baseline outcome, household controls, walking distances to nearest villages by treatment arm, and auction experiment fixed effects. Standard errors clustered at village level." ///
        "\end{tablenotes}" ///
        "\end{threeparttable}" ///
        "\end{table}") ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    keep(1.treatment_arm 2.treatment_arm 3.treatment_arm) ///
    stats(control_mean p_12 p_13 p_23 N r2, ///
        labels("Control Mean" "P-value A=B" "P-value A=C" "P-value B=C" "N" "R-squared") ///
        fmt(3 3 3 3 %9.0f 3)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    collabels(none) ///
    mlabels("\shortstack{Work-\\Related}" ///
            "\shortstack{Asset\\Sales}" ///
            "\shortstack{Migration}" ///
            "\shortstack{Skip\\Meals}", ///
        prefix(\multicolumn{1}{c}{) suffix(}))

**************************************************
* 1.1.8: Schistosomiasis Analysis (Self-Reported)
**************************************************

* schistosomiasis outcomes
local schisto_outcomes "bilharzia_any meds_any diagnosed_any urine_any stool_any"

* main treatment effects (eq 1)
eststo clear
foreach y of local schisto_outcomes {
    * Calculate control mean first
    qui sum midline_`y' if treatment_arm==0
    local cm = r(mean)
    
    * Run regression
    eststo main_`y': reg midline_`y' trained_hh baseline_`y' ///
        $controls $distance_vector i.auction_village, vce(cluster hhid_village)
        
    * Store control mean
    estadd scalar control_mean = `cm'
}

* spillover effects (eq 3)
foreach y of local schisto_outcomes {
    * Calculate control mean first
    qui sum midline_`y' if treatment_arm==0
    local cm = r(mean)
    
    * gen treatment indicators
    gen T_L = (treatment_arm != 0 & trained_hh == 0)  // local controls
    gen T_T = trained_hh                              // treat households
    
    eststo spill_`y': reg midline_`y' T_L T_T baseline_`y' ///
        $controls $distance_vector i.auction_village, vce(cluster hhid_village)
    
    * Store control mean
    estadd scalar control_mean = `cm'
    
    * test difference between local controls and treated
    test T_L = T_T
    estadd scalar p_diff = r(p)
    
    drop T_L T_T
}
* export main treatment effects
esttab main_* using "$specifications/schisto_main_effects.tex", replace ///
    style(tex) booktabs ///
    prehead("\begin{table}[htbp]\centering" ///
        "\begin{threeparttable}" ///
        "\caption{Treatment Effects on Self-Reported Schistosomiasis Outcomes}" ///
        "\begin{tabular}{l*{5}{c}}") ///
    posthead("\midrule") ///
    prefoot("\midrule") ///
    postfoot("\bottomrule" ///
        "\end{tabular}" ///
        "\begin{tablenotes}\footnotesize" ///
        "\item \textit{Notes:} Dependent variables are binary indicators for schistosomiasis-related conditions and symptoms. All specifications include baseline outcome, household controls, walking distances to nearest villages by treatment arm, and auction experiment fixed effects. Standard errors clustered at village level." ///
        "\end{tablenotes}" ///
        "\end{threeparttable}" ///
        "\end{table}") ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    keep(trained_hh) ///
    stats(control_mean N r2, ///
        labels("Control Mean" "N" "R-squared") ///
        fmt(3 %9.0f 3)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    collabels(none) ///
    mlabels("\shortstack{Self-Reported\\Infection}" ///
            "\shortstack{Medication\\Use}" ///
            "\shortstack{Diagnosed\\Cases}" ///
            "\shortstack{Urine\\Symptoms}" ///
            "\shortstack{Stool\\Symptoms}", ///
        prefix(\multicolumn{1}{c}{) suffix(}))

* export spillover effects
esttab spill_* using "$specifications/schisto_spillovers.tex", replace ///
    style(tex) booktabs ///
    prehead("\begin{table}[htbp]\centering" ///
        "\begin{threeparttable}" ///
        "\caption{Spillover Effects on Self-Reported Schistosomiasis Outcomes}" ///
        "\begin{tabular}{l*{5}{c}}") ///
    posthead("\midrule") ///
    prefoot("\midrule") ///
    postfoot("\bottomrule" ///
        "\end{tabular}" ///
        "\begin{tablenotes}\footnotesize" ///
        "\item \textit{Notes:} L indicates local control (untreated) households, T indicates treated households. All specifications include baseline outcome, household controls, walking distances to nearest villages by treatment arm, and auction experiment fixed effects. Standard errors clustered at village level." ///
        "\end{tablenotes}" ///
        "\end{threeparttable}" ///
        "\end{table}") ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    keep(T_L T_T) ///
    stats(control_mean p_diff N r2, ///
        labels("Control Mean" "P-value L=T" "N" "R-squared") ///
        fmt(3 3 %9.0f 3)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    collabels(none) ///
    mlabels("\shortstack{Self-Reported\\Infection}" ///
            "\shortstack{Medication\\Use}" ///
            "\shortstack{Diagnosed\\Cases}" ///
            "\shortstack{Urine\\Symptoms}" ///
            "\shortstack{Stool\\Symptoms}", ///
        prefix(\multicolumn{1}{c}{) suffix(}))
	
**************************************************
* 1.1.11: Property Rights Beliefs Analysis
**************************************************

* property rights belief outcomes
local belief_outcomes "comm_land comm_water private_land comm_land_use comm_fish comm_harvest"

* treatment arm effects on property rights beliefs
eststo clear
foreach y of local belief_outcomes {
    eststo belief_`y': reg midline_`y' i.treatment_arm baseline_`y' ///
        $controls $distance_vector i.auction_village, vce(cluster hhid_village)
    
    * test differences between arms
    test 1.treatment_arm = 2.treatment_arm  // Public vs Private
    estadd scalar p_12 = r(p)
    test 1.treatment_arm = 3.treatment_arm  // Public vs Both
    estadd scalar p_13 = r(p)
    test 2.treatment_arm = 3.treatment_arm  // Private vs Both
    estadd scalar p_23 = r(p)
    
    * test private benefits arms jointly different from control
    test 2.treatment_arm 3.treatment_arm    // Private arms vs Control
    estadd scalar p_priv = r(p)
}

* calculate and store control means first
foreach y of local belief_outcomes {
    qui sum midline_`y' if treatment_arm==0
    estadd scalar control_mean = r(mean), replace: belief_`y'
}

* export property rights beliefs with control means
esttab belief_* using "$specifications/property_rights_beliefs.tex", replace ///
    style(tex) booktabs ///
    prehead("\begin{table}[htbp]\centering" ///
        "\begin{threeparttable}" ///
        "\caption{Treatment Effects on Property Rights Beliefs}" ///
        "\begin{tabular}{l*{6}{c}}") ///
    posthead("\midrule") ///
    prefoot("\midrule") ///
    postfoot("\bottomrule" ///
        "\end{tabular}" ///
        "\begin{tablenotes}\footnotesize" ///
        "\item \textit{Notes:} Treatment arms: A=Public Health, B=Private Benefits, C=Both Messages. Control group means at midline shown below estimates for comparison. All specifications include baseline outcome, household controls, walking distances to nearest villages by treatment arm, and auction experiment fixed effects. Standard errors clustered at village level." ///
        "\end{tablenotes}" ///
        "\end{threeparttable}" ///
        "\end{table}") ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    keep(1.treatment_arm 2.treatment_arm 3.treatment_arm) ///
    stats(control_mean p_12 p_13 p_23 p_priv N r2, ///
        labels("Control Mean" "P-value A=B" "P-value A=C" "P-value B=C" "P-value Private Arms=Control" "N" "R-squared") ///
        fmt(3 3 3 3 3 %9.0f 3)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    collabels(none) ///
    mlabels("\shortstack{Community\\Land Rights}" ///
            "\shortstack{Community\\Water Rights}" ///
            "\shortstack{Private\\Land Rights}" ///
            "\shortstack{Community\\Land Use}" ///
            "\shortstack{Fishing\\Rights}" ///
            "\shortstack{Harvesting\\Rights}", ///
        prefix(\multicolumn{1}{c}{) suffix(}))

**************************************************
* 2.1.1: Work and School Days Lost Analysis
**************************************************

* outcomes
local work_outcomes "work_days_lost"                       // work days lost
local labor_outcomes "ag_workers total_ag_hours total_trade_hours total_wage_hours"  // labor supply
local school_outcomes "any_absence avg_attendance absence_count"  // school attendance

* main treatment effects (eq 1)
eststo clear
foreach y in work_days_lost any_absence absence_count {
    * Calculate control mean first
    qui sum midline_`y' if treatment_arm==0
    local cm = r(mean)
    
    * Run regression
    eststo main_`y': reg midline_`y' trained_hh baseline_`y' ///
        $controls $distance_vector i.auction_village, vce(cluster hhid_village)
        
    * Store control mean
    estadd scalar control_mean = `cm'
}

* spillover effects (eq 3)
foreach y in work_days_lost any_absence absence_count {
    * Calculate control mean first
    qui sum midline_`y' if treatment_arm==0
    local cm = r(mean)
    
    * gen treatment indicators
    gen T_L = (treatment_arm != 0 & trained_hh == 0)  // local controls
    gen T_T = trained_hh                              // treat households
    
    eststo spill_`y': reg midline_`y' T_L T_T baseline_`y' ///
        $controls $distance_vector i.auction_village, vce(cluster hhid_village)
    
    * Store control mean
    estadd scalar control_mean = `cm'
    
    * test difference between local controls and treated
    test T_L = T_T
    estadd scalar p_diff = r(p)
    
    drop T_L T_T
}


* export main treatment effects
esttab main_* using "$specifications/work_school_main.tex", replace ///
    style(tex) booktabs ///
    prehead("\begin{table}[htbp]\centering" ///
        "\begin{threeparttable}" ///
        "\caption{Treatment Effects on Work and School Days Lost}" ///
        "\begin{tabular}{l*{3}{c}}") ///
    posthead("\midrule") ///
    prefoot("\midrule") ///
    postfoot("\bottomrule" ///
        "\end{tabular}" ///
        "\begin{tablenotes}\footnotesize" ///
        "\item \textit{Notes:} Work days lost and school absences are self-reported. All specifications include baseline outcome, household controls, walking distances to nearest villages by treatment arm, and auction experiment fixed effects. Standard errors clustered at village level." ///
        "\end{tablenotes}" ///
        "\end{threeparttable}" ///
        "\end{table}") ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    keep(trained_hh) ///
    stats(control_mean N r2, ///
        labels("Control Mean" "N" "R-squared") ///
        fmt(3 %9.0f 3)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    collabels(none) ///
mlabels("\shortstack{HH Days Lost\\to Illness}" ///
        "\shortstack{Any Child Missing\\Week+ School}" ///
        "\shortstack{Children Missing\\Week+ School}", ///
        prefix(\multicolumn{1}{c}{) suffix(}))

* export spillover effects
esttab spill_* using "$specifications/work_school_spillovers.tex", replace ///
    style(tex) booktabs ///
    prehead("\begin{table}[htbp]\centering" ///
        "\begin{threeparttable}" ///
        "\caption{Spillover Effects on Work and School Days Lost}" ///
        "\begin{tabular}{l*{3}{c}}") ///
    posthead("\midrule") ///
    prefoot("\midrule") ///
    postfoot("\bottomrule" ///
        "\end{tabular}" ///
        "\begin{tablenotes}\footnotesize" ///
        "\item \textit{Notes:} L indicates local control (untreated) households, T indicates treated households. All specifications include baseline outcome, household controls, walking distances to nearest villages by treatment arm, and auction experiment fixed effects. Standard errors clustered at village level." ///
        "\end{tablenotes}" ///
        "\end{threeparttable}" ///
        "\end{table}") ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    keep(T_L T_T) ///
    stats(control_mean p_diff N r2, ///
        labels("Control Mean" "P-value L=T" "N" "R-squared") ///
        fmt(3 3 %9.0f 3)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    collabels(none) ///
    mlabels("\shortstack{Work Days\\Lost}" ///
            "\shortstack{Any School\\Absence}" ///
            "\shortstack{Number of\\Absences}", ///
        prefix(\multicolumn{1}{c}{) suffix(}))

**************************************************
* 2.1.2: Educational Outcomes Analysis
**************************************************

* education outcomes
local attainment "max_grade"                       // educational attainment
local enrollment "any_enrolled num_enrolled"       // school participation (extensive)
local attendance "avg_attendance any_last_year full_attend"  // school participation (intensive)

* main treatment effects (eq 1)
eststo clear
foreach y in max_grade any_enrolled num_enrolled avg_attendance any_last_year full_attend {
    * Calculate control mean first
    qui sum midline_`y' if treatment_arm==0
    local cm = r(mean)
    
    * Run regression
    eststo main_`y': reg midline_`y' trained_hh baseline_`y' ///
        $controls $distance_vector i.auction_village, vce(cluster hhid_village)
        
    * Store control mean
    estadd scalar control_mean = `cm'
}

* spillover effects (eq 3)
foreach y in max_grade any_enrolled num_enrolled avg_attendance any_last_year full_attend {
    * Calculate control mean first
    qui sum midline_`y' if treatment_arm==0
    local cm = r(mean)
    
    * gen treatment indicators
    gen T_L = (treatment_arm != 0 & trained_hh == 0)  // local controls
    gen T_T = trained_hh                              // treat households
    
    eststo spill_`y': reg midline_`y' T_L T_T baseline_`y' ///
        $controls $distance_vector i.auction_village, vce(cluster hhid_village)
    
    * Store control mean
    estadd scalar control_mean = `cm'
    
    * test difference between local controls and treated
    test T_L = T_T
    estadd scalar p_diff = r(p)
    
    drop T_L T_T
}

* export main treatment effects
esttab main_* using "$specifications/education_main.tex", replace ///
    style(tex) booktabs ///
    prehead("\begin{table}[htbp]\centering" ///
        "\begin{threeparttable}" ///
        "\caption{Treatment Effects on Educational Outcomes}" ///
        "\begin{tabular}{l*{6}{c}}") ///
    posthead("\midrule" ///
        "&\multicolumn{1}{c}{Attainment}&\multicolumn{2}{c}{Enrollment}&\multicolumn{3}{c}{Attendance}\\\cmidrule(lr){2-2}\cmidrule(lr){3-4}\cmidrule(lr){5-7}") ///
    prefoot("\midrule") ///
    postfoot("\bottomrule" ///
        "\end{tabular}" ///
        "\begin{tablenotes}\footnotesize" ///
        "\item \textit{Notes:} Outcomes include measures of attainment (highest grade), enrollment (any and number enrolled), and attendance measures. All specifications include baseline outcome, household controls, walking distances to nearest villages by treatment arm, and auction experiment fixed effects. Standard errors clustered at village level." ///
        "\end{tablenotes}" ///
        "\end{threeparttable}" ///
        "\end{table}") ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    keep(trained_hh) ///
    stats(control_mean N r2, ///
        labels("Control Mean" "N" "R-squared") ///
        fmt(3 %9.0f 3)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    collabels(none) ///
mlabels("\shortstack{Highest\\Grade}" ///
        "\shortstack{Any Child\\Enrolled}" ///
        "\shortstack{Number\\Enrolled}" ///
        "\shortstack{Avg Days\\Attended}" ///
        "\shortstack{Any Child Attended\\Last Year}" ///
        "\shortstack{Full Week\\Attendance}", ///
        prefix(\multicolumn{1}{c}{) suffix(}))

* export spillover effects
esttab spill_* using "$specifications/education_spillovers.tex", replace ///
    style(tex) booktabs ///
    prehead("\begin{table}[htbp]\centering" ///
        "\begin{threeparttable}" ///
        "\caption{Spillover Effects on Educational Outcomes}" ///
        "\begin{tabular}{l*{6}{c}}") ///
    posthead("\midrule" ///
        "&\multicolumn{1}{c}{Attainment}&\multicolumn{2}{c}{Enrollment}&\multicolumn{3}{c}{Attendance}\\\cmidrule(lr){2-2}\cmidrule(lr){3-4}\cmidrule(lr){5-7}") ///
    prefoot("\midrule") ///
    postfoot("\bottomrule" ///
        "\end{tabular}" ///
        "\begin{tablenotes}\footnotesize" ///
        "\item \textit{Notes:} L indicates local control (untreated) households, T indicates treated households. All specifications include baseline outcome, household controls, walking distances to nearest villages by treatment arm, and auction experiment fixed effects. Standard errors clustered at village level." ///
        "\end{tablenotes}" ///
        "\end{threeparttable}" ///
        "\end{table}") ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    keep(T_L T_T) ///
    stats(control_mean p_diff N r2, ///
        labels("Control Mean" "P-value L=T" "N" "R-squared") ///
        fmt(3 3 %9.0f 3)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    collabels(none) ///
    mlabels("\shortstack{Highest\\Grade}" ///
            "\shortstack{Any\\Enrollment}" ///
            "\shortstack{Number\\Enrolled}" ///
            "\shortstack{Average\\Attendance}" ///
            "\shortstack{Attended\\Last Year}" ///
            "\shortstack{Full\\Attendance}", ///
        prefix(\multicolumn{1}{c}{) suffix(}))

xxx

**************************************************
* Additional Specifications
**************************************************
* water interaction

* child time usage

**************************************************
* Robustness
* Winsorize Continuous Variables at 99th Percentile
**************************************************

* AVR continuous outcomes
foreach var in avr_harvest_kg avr_recent_kg {
    foreach period in baseline midline {
        egen `period'_`var'_p99 = pctile(`period'_`var'), p(99)
        gen `period'_`var'_w99 = `period'_`var'
        replace `period'_`var'_w99 = `period'_`var'_p99 if `period'_`var' > `period'_`var'_p99 & !missing(`period'_`var')
        drop `period'_`var'_p99
    }
}

* edu continuous outcomes
foreach var in max_grade avg_attendance {
    foreach period in baseline midline {
        egen `period'_`var'_p99 = pctile(`period'_`var'), p(99)
        gen `period'_`var'_w99 = `period'_`var'
        replace `period'_`var'_w99 = `period'_`var'_p99 if `period'_`var' > `period'_`var'_p99 & !missing(`period'_`var')
        drop `period'_`var'_p99
    }
}

* work/school continuous outcomes
foreach var in work_days_lost total_ag_hours total_trade_hours total_wage_hours {
    foreach period in baseline midline {
        egen `period'_`var'_p99 = pctile(`period'_`var'), p(99)
        gen `period'_`var'_w99 = `period'_`var'
        replace `period'_`var'_w99 = `period'_`var'_p99 if `period'_`var' > `period'_`var'_p99 & !missing(`period'_`var')
        drop `period'_`var'_p99
    }
}

* food security continuous outcomes
foreach var in months_soudure rcsi_annual {
    foreach period in baseline midline {
        egen `period'_`var'_p99 = pctile(`period'_`var'), p(99)
        gen `period'_`var'_w99 = `period'_`var'
        replace `period'_`var'_w99 = `period'_`var'_p99 if `period'_`var' > `period'_`var'_p99 & !missing(`period'_`var')
        drop `period'_`var'_p99
    }
}

* specifications again
***************************
* AVR with winsorized values 
****************************
eststo clear
foreach y in avr_harvest_kg_w99 avr_recent_kg_w99 {
    * extract shorter name for estimation storage
    local shortname = cond(strpos("`y'","harvest"),"harv","recent")
    
    * main treatment effect
    eststo w99_m_`shortname': reg midline_`y' trained_hh baseline_`y' ///
        $controls $distance_vector i.auction_village, vce(cluster hhid_village)
    
    * treatment arm effects
    eststo w99_a_`shortname': reg midline_`y' i.treatment_arm baseline_`y' ///
        $controls $distance_vector i.auction_village, vce(cluster hhid_village)
    test 1.treatment_arm = 2.treatment_arm
    estadd scalar p_12 = r(p)
    test 1.treatment_arm = 3.treatment_arm
    estadd scalar p_13 = r(p)
    test 2.treatment_arm = 3.treatment_arm
    estadd scalar p_23 = r(p)
}

* export main effects with winsorized values
esttab w99_m_* using "$specifications/avr_main_effects_winsor.tex", replace ///
    style(tex) booktabs ///
    prehead("\begin{table}[htbp]\centering" ///
        "\begin{threeparttable}" ///
        "\caption{Treatment Effects on AVR (Winsorized at 99th Percentile)}" ///
        "\begin{tabular}{l*{2}{c}}") ///
    posthead("\midrule") ///
    prefoot("\midrule") ///
    postfoot("\bottomrule" ///
        "\end{tabular}" ///
        "\begin{tablenotes}\footnotesize" ///
        "\item \textit{Notes:} Continuous outcomes Winsorized at 99th percentile. All specifications include baseline outcome, household controls, walking distances to nearest villages by treatment arm, and auction experiment fixed effects. Standard errors clustered at village level." ///
        "\end{tablenotes}" ///
        "\end{threeparttable}" ///
        "\end{table}") ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    keep(trained_hh) ///
    stats(N r2, ///
        labels("N" "R-squared") ///
        fmt(%9.0f 3)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    collabels(none) ///
    mlabels("\shortstack{12-Month\\Amount}" ///
            "\shortstack{7-Day\\Amount}", ///
        prefix(\multicolumn{1}{c}{) suffix(}))

* export treatment arm effects with winsorized values
esttab w99_a_* using "$specifications/avr_arms_effects_winsor.tex", replace ///
    style(tex) booktabs ///
    prehead("\begin{table}[htbp]\centering" ///
        "\begin{threeparttable}" ///
        "\caption{Treatment Arm Effects on AVR (Winsorized at 99th Percentile)}" ///
        "\begin{tabular}{l*{2}{c}}") ///
    posthead("\midrule") ///
    prefoot("\midrule") ///
    postfoot("\bottomrule" ///
        "\end{tabular}" ///
        "\begin{tablenotes}\footnotesize" ///
        "\item \textit{Notes:} Treatment arms: A=Public Health, B=Private Benefits, C=Both Messages. Continuous outcomes Winsorized at 99th percentile. All specifications include baseline outcome, household controls, walking distances to nearest villages by treatment arm, and auction experiment fixed effects. Standard errors clustered at village level." ///
        "\end{tablenotes}" ///
        "\end{threeparttable}" ///
        "\end{table}") ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    keep(*.treatment_arm) ///
    stats(p_12 p_13 p_23 N r2, ///
        labels("P-value A=B" "P-value A=C" "P-value B=C" "N" "R-squared") ///
        fmt(3 3 3 %9.0f 3)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    collabels(none) ///
    mlabels("\shortstack{12-Month\\Amount}" ///
            "\shortstack{7-Day\\Amount}", ///
        prefix(\multicolumn{1}{c}{) suffix(}))

**************************************
* food security with Winsorized values 
**************************************
eststo clear
foreach y in months_soudure_w99 rcsi_annual_w99 {
    * extract shorter name for estimation storage
    local shortname = cond(strpos("`y'","months"),"soudure","rcsi")
    
    eststo w99_`shortname': reg midline_`y' i.treatment_arm baseline_`y' ///
        $controls $distance_vector i.auction_village, vce(cluster hhid_village)
    
    * test differences between arms
    test 1.treatment_arm = 2.treatment_arm  // pub vs priv Benefits
    estadd scalar p_12 = r(p)
    test 1.treatment_arm = 3.treatment_arm  // pub vs both
    estadd scalar p_13 = r(p)
    test 2.treatment_arm = 3.treatment_arm  // priv vs both
    estadd scalar p_23 = r(p)
}

* export winsorized food security results
esttab w99_* using "$specifications/food_security_winsor.tex", replace ///
    style(tex) booktabs ///
    prehead("\begin{table}[htbp]\centering" ///
        "\begin{threeparttable}" ///
        "\caption{Treatment Effects on Food Security Outcomes (Winsorized at 99th Percentile)}" ///
        "\begin{tabular}{l*{2}{c}}") ///
    posthead("\midrule") ///
    prefoot("\midrule") ///
    postfoot("\bottomrule" ///
        "\end{tabular}" ///
        "\begin{tablenotes}\footnotesize" ///
        "\item \textit{Notes:} Treatment arms: A=Public Health, B=Private Benefits, C=Both Messages. Outcomes Winsorized at 99th percentile. Lean season months measures self-reported soudure duration. Reduced CSI is composite index of coping strategies. All specifications include baseline outcome, household controls, walking distances to nearest villages by treatment arm, and auction experiment fixed effects. Standard errors clustered at village level." ///
        "\end{tablenotes}" ///
        "\end{threeparttable}" ///
        "\end{table}") ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    keep(*.treatment_arm) ///
    stats(p_12 p_13 p_23 N r2, ///
        labels("P-value A=B" "P-value A=C" "P-value B=C" "N" "R-squared") ///
        fmt(3 3 3 %9.0f 3)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    collabels(none) ///
    mlabels("\shortstack{Lean Season\\Months}" ///
            "\shortstack{Reduced CSI}", ///
        prefix(\multicolumn{1}{c}{) suffix(}))

*************************************************
* work and school outcomes with winsorized values
*************************************************
eststo clear

* work days lost (shortened names)
foreach y in work_days_lost_w99 {
    * extract shorter name for estimation storage
    local shortname = "work"
    
    eststo w99_`shortname': reg midline_`y' trained_hh baseline_`y' ///
        $controls $distance_vector i.auction_village, vce(cluster hhid_village)
}

* export winsorized work results
esttab w99_work using "$specifications/work_main_winsor.tex", replace ///
    style(tex) booktabs ///
    prehead("\begin{table}[htbp]\centering" ///
        "\begin{threeparttable}" ///
        "\caption{Treatment Effects on Work Days Lost (Winsorized at 99th Percentile)}" ///
        "\begin{tabular}{l*{1}{c}}") ///
    posthead("\midrule") ///
    prefoot("\midrule") ///
    postfoot("\bottomrule" ///
        "\end{tabular}" ///
        "\begin{tablenotes}\footnotesize" ///
        "\item \textit{Notes:} Continuous outcomes Winsorized at 99th percentile. All specifications include baseline outcome, household controls, walking distances to nearest villages by treatment arm, and auction experiment fixed effects. Standard errors clustered at village level." ///
        "\end{tablenotes}" ///
        "\end{threeparttable}" ///
        "\end{table}") ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    keep(trained_hh) ///
    stats(N r2, ///
        labels("N" "R-squared") ///
        fmt(%9.0f 3)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    collabels(none) ///
    mlabels("\shortstack{Work Days\\Lost}", ///
        prefix(\multicolumn{1}{c}{) suffix(}))
eststo clear

* labor outcomes (shortened names)
foreach y in total_ag_hours_w99 total_trade_hours_w99 total_wage_hours_w99 {
    * extract shorter identifier
    local shortname = substr("`y'", 7, 2)
    
    * store regression
    eststo w99_`shortname': reg midline_`y' trained_hh baseline_`y' ///
        $controls $distance_vector i.auction_village, vce(cluster hhid_village)
}

* export winsorized labor results
esttab w99_ag w99_tr w99_wa using "$specifications/labor_main_winsor.tex", replace ///
    style(tex) booktabs ///
    prehead("\begin{table}[htbp]\centering" ///
        "\begin{threeparttable}" ///
        "\caption{Treatment Effects on Labor Supply (Winsorized at 99th Percentile)}" ///
        "\begin{tabular}{l*{3}{c}}") ///
    posthead("\midrule") ///
    prefoot("\midrule") ///
    postfoot("\bottomrule" ///
        "\end{tabular}" ///
        "\begin{tablenotes}\footnotesize" ///
        "\item \textit{Notes:} Hours worked Winsorized at 99th percentile. All specifications include baseline outcome, household controls, walking distances to nearest villages by treatment arm, and auction experiment fixed effects. Standard errors clustered at village level." ///
        "\end{tablenotes}" ///
        "\end{threeparttable}" ///
        "\end{table}") ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    keep(trained_hh) ///
    stats(N r2, ///
        labels("N" "R-squared") ///
        fmt(%9.0f 3)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    collabels(none) ///
    mlabels("\shortstack{Agricultural\\Hours}" ///
            "\shortstack{Trading\\Hours}" ///
            "\shortstack{Wage\\Hours}", ///
        prefix(\multicolumn{1}{c}{) suffix(}))

*******************************************
* education outcomes with winsorized values
*******************************************

* main treatment effects with winsorized values
eststo clear

* attainment regression with shortened name
foreach y in max_grade_w99 {
    eststo w99_grade: reg midline_`y' trained_hh baseline_`y' ///
        $controls $distance_vector i.auction_village, vce(cluster hhid_village)
}

* attendance regression with shortened name
foreach y in avg_attendance_w99 {
    eststo w99_attend: reg midline_`y' trained_hh baseline_`y' ///
        $controls $distance_vector i.auction_village, vce(cluster hhid_village)
}

* export winsorized education results
esttab w99_grade w99_attend using "$specifications/education_main_winsor.tex", replace ///
    style(tex) booktabs ///
    prehead("\begin{table}[htbp]\centering" ///
        "\begin{threeparttable}" ///
        "\caption{Treatment Effects on Educational Outcomes (Winsorized at 99th Percentile)}" ///
        "\begin{tabular}{l*{2}{c}}") ///
    posthead("\midrule" ///
        "&\multicolumn{1}{c}{Attainment}&\multicolumn{1}{c}{Attendance}\\\cmidrule(lr){2-2}\cmidrule(lr){3-3}") ///
    prefoot("\midrule") ///
    postfoot("\bottomrule" ///
        "\end{tabular}" ///
        "\begin{tablenotes}\footnotesize" ///
        "\item \textit{Notes:} Continuous outcomes Winsorized at 99th percentile. All specifications include baseline outcome, household controls, walking distances to nearest villages by treatment arm, and auction experiment fixed effects. Standard errors clustered at village level." ///
        "\end{tablenotes}" ///
        "\end{threeparttable}" ///
        "\end{table}") ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    keep(trained_hh) ///
    stats(N r2, ///
        labels("N" "R-squared") ///
        fmt(%9.0f 3)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    collabels(none) ///
    mlabels("\shortstack{Highest\\Grade}" ///
            "\shortstack{Average\\Attendance}", ///
        prefix(\multicolumn{1}{c}{) suffix(}))