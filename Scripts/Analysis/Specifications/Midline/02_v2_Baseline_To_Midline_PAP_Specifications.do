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
local balancevars baseline_avr_water_any baseline_avr_harvest_any baseline_avr_removal_any baseline_avr_recent_any ///
    baseline_avr_harvest_kg baseline_avr_recent_kg baseline_fert_ag_any baseline_fert_specific_any baseline_compost_any baseline_waste_any baseline_fert_ag_count baseline_compost_plots baseline_waste_plots baseline_months_soudure baseline_rcsi_annual baseline_ipc_phase baseline_bilharzia_any baseline_meds_any baseline_diagnosed_any baseline_urine_any baseline_stool_any baseline_bilharzia_count baseline_meds_count baseline_diagnosed_count baseline_urine_count baseline_stool_count baseline_personal_risk baseline_hh_risk baseline_child_risk baseline_comm_land baseline_comm_water baseline_private_land baseline_comm_land_use baseline_comm_fish baseline_comm_harvest baseline_work_days_lost baseline_ag_workers baseline_total_ag_hours baseline_total_trade_hours baseline_total_wage_hours baseline_any_absence baseline_avg_attendance baseline_absence_count baseline_max_grade baseline_any_enrolled baseline_num_enrolled baseline_any_last_year baseline_full_attend ///
q_51 q4 living_01_bin asset_index_std hh_age_h hh_gender_h hh_education_skills_5_h hh_numero ///
walking_minutes_to_arm_0 walking_minutes_to_arm_1 walking_minutes_to_arm_2 walking_minutes_to_arm_3

* for latex table
file open balance using "$specifications/balance_table.tex", write replace

* header
file write balance "\begin{table}[htbp]" _n
file write balance "\centering" _n
file write balance "\caption{Balance Across Treatment Arms}" _n
file write balance "\label{tab:balance}" _n
file write balance "\begin{tabular}{lccccp{2cm}}" _n
file write balance "\hline\hline" _n
file write balance " & Control & Public & Private & Both & F-test \\" _n
file write balance "Variable & Group & Health & Benefits & Messages & p-value \\" _n
file write balance "\hline" _n

foreach var of local balancevars {
    * var label
    local varlabel: variable label `var'
    if "`varlabel'" == "" local varlabel "`var'"
    
    * control group mean
    sum `var' if treatment_arm == 0
    local mean0 = r(mean)
    local sd0 = r(sd)
    
    * treatment group means
    forvalues t = 1/3 {
        sum `var' if treatment_arm == `t'
        local mean`t' = r(mean)
        local sd`t' = r(sd)
    }
    
    * F-test
    reg `var' i.treatment_arm, r cluster(hhid_village)
    test 1.treatment_arm 2.treatment_arm 3.treatment_arm
    local pval = r(p)
    
    * write row
    file write balance "`varlabel' & "
    file write balance %9.3f (`mean0') " & "
    file write balance %9.3f (`mean1') " & "
    file write balance %9.3f (`mean2') " & "
    file write balance %9.3f (`mean3') " & "
    file write balance %9.3f (`pval') " \\" _n
    
    * stdev row
    file write balance "& ("
    file write balance %9.3f (`sd0') ") & ("
    file write balance %9.3f (`sd1') ") & ("
    file write balance %9.3f (`sd2') ") & ("
    file write balance %9.3f (`sd3') ") & \\" _n
}

*  footer
file write balance "\hline" _n
file write balance "\end{tabular}" _n
file write balance "\begin{tablenotes}" _n
file write balance "\small" _n
file write balance "\item Notes: Table reports means and standard deviations (in parentheses) for each variable by treatment arm. The last column shows p-values from F-tests of joint equality across treatment arms. Standard errors are clustered at the village level. Analysis includes 2,029 households tracked from baseline to midline out of 2,080 baseline households." _n
file write balance "\end{tablenotes}" _n
file write balance "\end{table}" _n

file close balance

**************************************************
* 1.1.1: AVR Main Effects
**************************************************

* avr participation outcomes (binary indicators)
local avr_outcomes "avr_water_any avr_harvest_any avr_removal_any avr_recent_any"

* labels
local lab_water_any "Harvests from Water Sources"
local lab_harvest_any "12-Month Vegetation Collection"
local lab_removal_any "Removes Aquatic Vegetation"
local lab_recent_any "7-Day Vegetation Collection"

* main effects (eq 1 and 2)
eststo clear
foreach y of local avr_outcomes {
    * main treatment effect (eq 1)
    eststo main_`y': reg midline_`y' trained_hh baseline_`y' ///
        $controls $distance_vector i.auction_village, vce(cluster hhid_village)
    estadd local baseline_control "Yes"
    estadd local controls "Yes"
    estadd local distance "Yes"
    estadd local auction "Yes"
    
    * treatment arm effects (eq 2)
    eststo arms_`y': reg midline_`y' i.treatment_arm baseline_`y' ///
        $controls $distance_vector i.auction_village, vce(cluster hhid_village)
    test 1.treatment_arm = 2.treatment_arm
    estadd scalar p_12 = r(p)
    test 1.treatment_arm = 3.treatment_arm
    estadd scalar p_13 = r(p)
    test 2.treatment_arm = 3.treatment_arm
    estadd scalar p_23 = r(p)
}

* export main treatment effects (eq 1)
esttab main_* using "$specifications/avr_main_effects.tex", replace ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    keep(trained_hh) ///
    stats(baseline_control controls distance auction N r2, ///
        labels("Baseline Control" "Controls" "Distance Vector" "Auction FE" "N" "R-squared") ///
        fmt(0 0 0 0 %9.0f 3)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    mlabels("`lab_water_any'" "`lab_harvest_any'" "`lab_removal_any'" "`lab_recent_any'") ///
    title("Treatment Effects on Aquatic Vegetation Removal (AVR)") ///
    note("Dependent variables are binary indicators for different types of AVR participation. All specifications include baseline outcome, household controls, walking distances to nearest villages by treatment arm, and auction experiment fixed effects. Standard errors clustered at village level.")

* export treatment arm effects (eq 2)
esttab arms_* using "$specifications/avr_treatment_arms.tex", replace ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    keep(*.treatment_arm) ///
    stats(p_12 p_13 p_23 baseline_control controls distance auction N r2, ///
        labels("P-value A=B" "P-value A=C" "P-value B=C" "Baseline Control" "Controls" "Distance Vector" "Auction FE" "N" "R-squared") ///
        fmt(3 3 3 0 0 0 0 %9.0f 3)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    mlabels("`lab_water_any'" "`lab_harvest_any'" "`lab_removal_any'" "`lab_recent_any'") ///
    title("Treatment Arm Effects on Aquatic Vegetation Removal (AVR)") ///
    note("Treatment arms: A=Public Health, B=Private Benefits, C=Both Messages. All specifications include baseline outcome, household controls, walking distances to nearest villages by treatment arm, and auction experiment fixed effects. Standard errors clustered at village level.")
	
**************************************************
* 1.1.2: AVR Spillover Effects
**************************************************

* generate spillover indicators
gen local_control = (treatment_arm != 0 & trained_hh == 0)
gen treated = trained_hh

* generate arm-specific spillover indicators
foreach arm in A B C {
    local armnum = cond("`arm'"=="A",1,cond("`arm'"=="B",2,3))
    gen T_`arm'_L = (treatment_arm == `armnum' & trained_hh == 0)
    gen T_`arm'_T = (treatment_arm == `armnum' & trained_hh == 1)
}

* spillover effects (Equation 3)
eststo clear
foreach y of local avr_outcomes {
    * basic spillovers
    eststo spill_`y': reg midline_`y' local_control treated baseline_`y' ///
        $controls $distance_vector i.auction_village, vce(cluster hhid_village)
    test local_control = treated
    estadd scalar p_diff = r(p)
    
    * arm-specific spillovers
    eststo spill_arm_`y': reg midline_`y' T_A_L T_A_T T_B_L T_B_T T_C_L T_C_T baseline_`y' ///
        $controls $distance_vector i.auction_village, vce(cluster hhid_village)
    
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
esttab spill_* using "$specifications/avr_spillovers.tex", replace ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    keep(local_control treated) ///
    stats(p_diff baseline_control controls distance auction N r2, ///
        labels("P-value L=T" "Baseline Control" "Controls" "Distance Vector" "Auction FE" "N" "R-squared") ///
        fmt(3 0 0 0 0 %9.0f 3)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    mlabels("`lab_water_any'" "`lab_harvest_any'" "`lab_removal_any'" "`lab_recent_any'") ///
    title("AVR Spillover Effects") ///
    note("Local control indicates untreated households in treatment villages. Standard errors clustered at village level.")

* export arm-specific spillover results 
esttab spill_arm_* using "$specifications/avr_arm_spillovers.tex", replace ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    keep(T_*) ///
    stats(p_L_AB p_L_AC p_L_BC p_LT_A p_LT_B p_LT_C N r2, ///
        labels("P-value L_A=L_B" "P-value L_A=L_C" "P-value L_B=L_C" ///
               "P-value L=T in A" "P-value L=T in B" "P-value L=T in C" "N" "R-squared") ///
        fmt(3 3 3 3 3 3 %9.0f 3)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    mlabels("`lab_water_any'" "`lab_harvest_any'" "`lab_removal_any'" "`lab_recent_any'") ///
    title("AVR Arm-Specific Spillover Effects") ///
    note("L indicates local control (untreated) households, T indicates treated households, by treatment arm (A=Public Health, B=Private Benefits, C=Both). Standard errors clustered at village level.")

* clean
drop local_control treated T_*_L T_*_T

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
    
    * estimate change over time
    eststo control_`y': reg `y' time $controls $distance_vector i.auction_village, ///
        vce(cluster hhid_village)
        
    estadd local controls "Yes"
    estadd local distance "Yes"
    estadd local auction "Yes"
    
    restore
}

* export results 
esttab control_* using "$specifications/avr_control_changes.tex", replace ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    keep(time) ///
    stats(controls distance auction N r2, ///
        labels("Controls" "Distance Vector" "Auction FE" "N" "R-squared") ///
        fmt(0 0 0 %9.0f 3)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    mlabels("`lab_water_any'" "`lab_harvest_any'" "`lab_removal_any'" "`lab_recent_any'") ///
    title("Changes in AVR Practices in Pure Control Villages") ///
    note("Sample restricted to pure control villages. Coefficient shows change from baseline to midline. All specifications include household controls, walking distances to nearest villages by treatment arm, and auction experiment fixed effects. Standard errors clustered at village level.")
	
**************************************************
* 1.1.4: Compost Production Analysis
**************************************************

* compost-related outcomes
local comp_extensive "compost_any waste_any"              // binary adoption
local comp_intensive "compost_plots waste_plots"         // intensity measures
local fert_outcomes "fert_ag_any fert_specific_any fert_ag_count"  // fertilizer use

* treatment arm effects (eq 2)
eststo clear
foreach y of local comp_extensive {
    eststo arm_`y': reg midline_`y' i.treatment_arm baseline_`y' ///
        $controls $distance_vector i.auction_village, vce(cluster hhid_village)
        
    * Test differences between arms
    test 1.treatment_arm = 2.treatment_arm  // Public vs Private
    estadd scalar p_12 = r(p)
    test 1.treatment_arm = 3.treatment_arm  // Public vs Both
    estadd scalar p_13 = r(p)
    test 2.treatment_arm = 3.treatment_arm  // Private vs Both
    estadd scalar p_23 = r(p)
}

* spillover effects (eq 3)
foreach y of local comp_extensive {
    * gen treatment indicators
    gen T_L = (treatment_arm != 0 & trained_hh == 0)  // local controls
    gen T_T = trained_hh                              // treat households
    
    eststo spill_`y': reg midline_`y' T_L T_T baseline_`y' ///
        $controls $distance_vector i.auction_village, vce(cluster hhid_village)
    
    * test difference between local controls and treated
    test T_L = T_T
    estadd scalar p_diff = r(p)
    
    drop T_L T_T
}

* export treatment arm 
esttab arm_* using "$specifications/compost_arm_effects.tex", replace ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    keep(*.treatment_arm) ///
    stats(p_12 p_13 p_23 N r2, ///
        labels("P-value Public=Private" "P-value Public=Both" "P-value Private=Both" "N" "R-squared") ///
        fmt(3 3 3 %9.0f 3)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    mtitles("Compost Production" "Waste Collection") ///
    title("Treatment Arm Effects on Compost Activities") ///
    note("Treatment arms: Public Health (A), Private Benefits (B), Both Messages (C). All specifications include baseline outcome, household controls, walking distances to nearest villages by treatment arm, and auction experiment fixed effects. Standard errors clustered at village level.")

* export spillover
esttab spill_* using "$specifications/compost_spillovers.tex", replace ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    keep(T_L T_T) ///
    stats(p_diff N r2, ///
        labels("P-value L=T" "N" "R-squared") ///
        fmt(3 %9.0f 3)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    mtitles("Compost Production" "Waste Collection") ///
    title("Spillover Effects on Compost Activities") ///
    note("L indicates local control (untreated) households, T indicates treated households. Standard errors clustered at village level.")
	
**************************************************
* 1.1.5: Private Benefits Spillovers for Composting
**************************************************

* composting outcomes
local comp_outcomes "compost_any waste_any"
local labels "Compost Production" "Waste Collection"

eststo clear

* basic spillovers in private benefits arms only (eq 3)
foreach y of local comp_outcomes {
    * restrict to arms B, C and control
    preserve
    keep if inlist(treatment_arm, 0, 2, 3)  // control, private benefits, both
    
    * gen indicators
    gen T_L = (treatment_arm != 0 & trained_hh == 0)  // local controls
    gen T_T = trained_hh                              // Treated households
    
    eststo priv_`y': reg midline_`y' T_L T_T baseline_`y' ///
        $controls $distance_vector i.auction_village, vce(cluster hhid_village)
    test T_L = T_T
    estadd scalar p_diff = r(p)
    restore
}

* arm-specific spillovers (eq 4)
foreach y of local comp_outcomes {
    * gen arm-specific indicators
    foreach arm in B C {
        local armnum = cond("`arm'"=="B",2,3)
        gen T_`arm'_L = (treatment_arm == `armnum' & trained_hh == 0)
        gen T_`arm'_T = (treatment_arm == `armnum' & trained_hh == 1)
    }
    
    eststo arms_`y': reg midline_`y' T_B_L T_B_T T_C_L T_C_T baseline_`y' ///
        $controls $distance_vector i.auction_village, vce(cluster hhid_village)
    
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
    cells(b(star fmt(3)) se(par fmt(3))) ///
    keep(T_L T_T) ///
    stats(p_diff N r2, ///
        labels("P-value L=T" "N" "R-squared") ///
        fmt(3 %9.0f 3)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    mtitles("`labels'") ///
    title("Private Benefits Spillovers on Compost Activities") ///
    note("Sample restricted to control villages and those receiving private benefits information (arms B and C). L indicates local control (untreated) households, T indicates treated households. Standard errors clustered at village level.")

* export arm-specific private benefits results
esttab arms_* using "$specifications/compost_private_arms.tex", replace ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    keep(T_*) ///
    stats(p_B p_C p_L_BC N r2, ///
        labels("P-value L=T in Private" "P-value L=T in Both" "P-value Private L=Both L" "N" "R-squared") ///
        fmt(3 3 3 %9.0f 3)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    mtitles("`labels'") ///
    title("Arm-Specific Private Benefits Spillovers") ///
    note("Compares spillovers between private benefits only (B) and both messages (C) arms. L indicates local control (untreated) households, T indicates treated households. Standard errors clustered at village level.")
	
**************************************************
* 1.1.6: Total Factor Productivity and Profitability
**************************************************
* wait until molly gets done with production functions

**************************************************
* 1.1.7: Food Security Analysis
**************************************************

* food security outcomes
local food_outcomes "months_soudure rcsi_annual"     // main outcomes
local rcsi_components "rcsi_work rcsi_assets rcsi_migrate rcsi_skip"  // RCSI components 
local food_labels "Lean Season Months" "Reduced CSI" 

* treatment arm effects on food security (eq 2)
eststo clear
foreach y of local food_outcomes {
    eststo food_`y': reg midline_`y' i.treatment_arm baseline_`y' ///
        $controls $distance_vector i.auction_village, vce(cluster hhid_village)
    
    * test differences between arms
    test 1.treatment_arm = 2.treatment_arm  // pub vs priv Benefits
    estadd scalar p_12 = r(p)
    test 1.treatment_arm = 3.treatment_arm  // pub vs both
    estadd scalar p_13 = r(p)
    test 2.treatment_arm = 3.treatment_arm  // priv vs both
    estadd scalar p_23 = r(p)
    
    estadd local baseline_control "Yes"
    estadd local controls "Yes"
    estadd local distance "Yes"
    estadd local auction "Yes"
}

* export food security results
esttab food_* using "$specifications/food_security.tex", replace ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    keep(*.treatment_arm) ///
    stats(p_12 p_13 p_23 baseline_control controls distance auction N r2, ///
        labels("P-value Public=Private" "P-value Public=Both" "P-value Private=Both" ///
               "Baseline Control" "Controls" "Distance Vector" "Auction FE" "N" "R-squared") ///
        fmt(3 3 3 0 0 0 0 %9.0f 3)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    mtitles("`food_labels'") ///
    title("Treatment Effects on Food Security Outcomes") ///
    note("Treatment arms: A=Public Health, B=Private Benefits, C=Both Messages. Lean season months measures self-reported soudure duration. Reduced CSI is composite index of coping strategies. All specifications include baseline outcome, household controls, walking distances to nearest villages by treatment arm, and auction experiment fixed effects. Standard errors clustered at village level.")

* additional of RCSI components
eststo clear 
foreach y of local rcsi_components {
    eststo rcsi_`y': reg midline_`y' i.treatment_arm baseline_`y' ///
        $controls $distance_vector i.auction_village, vce(cluster hhid_village)
    
    test 1.treatment_arm = 2.treatment_arm
    estadd scalar p_12 = r(p)
    test 1.treatment_arm = 3.treatment_arm
    estadd scalar p_13 = r(p)
    test 2.treatment_arm = 3.treatment_arm
    estadd scalar p_23 = r(p)
}

* export RCSI component results
esttab rcsi_* using "$specifications/food_security_components.tex", replace ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    keep(*.treatment_arm) ///
    stats(p_12 p_13 p_23 N r2, ///
        labels("P-value Public=Private" "P-value Public=Both" "P-value Private=Both" "N" "R-squared") ///
        fmt(3 3 3 %9.0f 3)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    mtitles("Work-Related" "Asset Sales" "Migration" "Skip Meals") ///
    title("Treatment Effects on Coping Strategy Components") ///
    note("Decomposition of Reduced Coping Strategies Index (RCSI) into component measures. Standard errors clustered at village level.")
	
**************************************************
* 1.1.8: Schistosomiasis Analysis (Self-Reported)
**************************************************

* schistosomiasis outcomes
local schisto_outcomes "bilharzia_any meds_any diagnosed_any urine_any stool_any"

* labels
local lab_bilharzia "Self-Reported Infection"
local lab_meds "Medication Use"
local lab_diagnosed "Diagnosed Cases"
local lab_urine "Urine Symptoms"
local lab_stool "Stool Symptoms"

* main treatment effects (eq 1)
eststo clear
foreach y of local schisto_outcomes {
    * village-level treatment effect
    eststo main_`y': reg midline_`y' trained_hh baseline_`y' ///
        $controls $distance_vector i.auction_village, vce(cluster hhid_village)
    estadd local baseline_control "Yes"
    estadd local controls "Yes"
    estadd local distance "Yes"
    estadd local auction "Yes"
}

* spillover effects (eq 3)
foreach y of local schisto_outcomes {
    * gen treatment indicators
    gen T_L = (treatment_arm != 0 & trained_hh == 0)  // local controls
    gen T_T = trained_hh                              // treat households
    
    eststo spill_`y': reg midline_`y' T_L T_T baseline_`y' ///
        $controls $distance_vector i.auction_village, vce(cluster hhid_village)
    
    * test difference between local controls and treated
    test T_L = T_T
    estadd scalar p_diff = r(p)
    
    drop T_L T_T
}

* main treatment effects
esttab main_* using "$specifications/schisto_main_effects.tex", replace ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    keep(trained_hh) ///
    stats(baseline_control controls distance auction N r2, ///
        labels("Baseline Control" "Controls" "Distance Vector" "Auction FE" "N" "R-squared") ///
        fmt(0 0 0 0 %9.0f 3)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    mlabels("`lab_bilharzia'" "`lab_meds'" "`lab_diagnosed'" "`lab_urine'" "`lab_stool'") ///
    title("Treatment Effects on Self-Reported Schistosomiasis Outcomes") ///
    note("Dependent variables are binary indicators for schistosomiasis-related conditions and symptoms. All specifications include baseline outcome, household controls, walking distances to nearest villages by treatment arm, and auction experiment fixed effects. Standard errors clustered at village level.")

* spillover effects
esttab spill_* using "$specifications/schisto_spillovers.tex", replace ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    keep(T_L T_T) ///
    stats(p_diff baseline_control controls distance auction N r2, ///
        labels("P-value L=T" "Baseline Control" "Controls" "Distance Vector" "Auction FE" "N" "R-squared") ///
        fmt(3 0 0 0 0 %9.0f 3)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    mlabels("`lab_bilharzia'" "`lab_meds'" "`lab_diagnosed'" "`lab_urine'" "`lab_stool'") ///
    title("Spillover Effects on Self-Reported Schistosomiasis Outcomes") ///
    note("L indicates local control (untreated) households, T indicates treated households. All specifications include baseline outcome, household controls, walking distances to nearest villages by treatment arm, and auction experiment fixed effects. Standard errors clustered at village level.")
	
**************************************************
* 1.1.11: Property Rights Beliefs Analysis
**************************************************

* property rights belief outcomes
local belief_outcomes "comm_land comm_water private_land comm_land_use comm_fish comm_harvest"

* labels 
local lab_comm_land "Community Land Rights"
local lab_comm_water "Community Water Rights"
local lab_private_land "Private Land Rights"
local lab_comm_land_use "Community Land Use"
local lab_comm_fish "Fishing Rights"
local lab_comm_harvest "Harvesting Rights"

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
    
    estadd local baseline_control "Yes"
    estadd local controls "Yes"
    estadd local distance "Yes"
    estadd local auction "Yes"
}

* export property rights beliefs
esttab belief_* using "$specifications/property_rights_beliefs.tex", replace ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    keep(*.treatment_arm) ///
    stats(p_12 p_13 p_23 p_priv baseline_control controls distance auction N r2, ///
        labels("P-value Public=Private" "P-value Public=Both" "P-value Private=Both" ///
               "P-value Private Arms=Control" "Baseline Control" "Controls" ///
               "Distance Vector" "Auction FE" "N" "R-squared") ///
        fmt(3 3 3 3 0 0 0 0 %9.0f 3)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    mlabels("`lab_comm_land'" "`lab_comm_water'" "`lab_private_land'" ///
            "`lab_comm_land_use'" "`lab_comm_fish'" "`lab_comm_harvest'") ///
    title("Treatment Effects on Property Rights Beliefs") ///
    note("Compares beliefs about resource rights across treatment arms, with focus on private benefits messaging (arms B and C) versus public health only (arm A) and control. All specifications include baseline outcome, household controls, walking distances to nearest villages by treatment arm, and auction experiment fixed effects. Standard errors clustered at village level.")
	
**************************************************
* 2.1.1: Work and School Days Lost Analysis
**************************************************

* outcomes
local work_outcomes "work_days_lost"                       // work days lost
local labor_outcomes "ag_workers total_ag_hours total_trade_hours total_wage_hours"  // labor supply
local school_outcomes "any_absence avg_attendance absence_count"  // school attendance

* labels
local lab_work_days "Work Days Lost"
local lab_ag_workers "Agricultural Workers"
local lab_ag_hours "Agricultural Hours"
local lab_trade_hours "Trade Hours"
local lab_wage_hours "Wage Hours"
local lab_any_absence "Any School Absence"
local lab_attendance "Average Attendance"
local lab_absence_count "Number of Absences"

* main treatment effects (eq 1)
eststo clear
foreach y in work_days_lost any_absence absence_count {
    eststo main_`y': reg midline_`y' trained_hh baseline_`y' ///
        $controls $distance_vector i.auction_village, vce(cluster hhid_village)
    estadd local baseline_control "Yes"
    estadd local controls "Yes"
    estadd local distance "Yes"
    estadd local auction "Yes"
}

* spillover effects (eq 3)
foreach y in work_days_lost any_absence absence_count {
    * gen treatment indicators
    gen T_L = (treatment_arm != 0 & trained_hh == 0)  // local controls
    gen T_T = trained_hh                              // treat households
    
    eststo spill_`y': reg midline_`y' T_L T_T baseline_`y' ///
        $controls $distance_vector i.auction_village, vce(cluster hhid_village)
    
    * difference between local controls and treated
    test T_L = T_T
    estadd scalar p_diff = r(p)
    
    drop T_L T_T
}

* main treatment effects
esttab main_* using "$specifications/work_school_main.tex", replace ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    keep(trained_hh) ///
    stats(baseline_control controls distance auction N r2, ///
        labels("Baseline Control" "Controls" "Distance Vector" "Auction FE" "N" "R-squared") ///
        fmt(0 0 0 0 %9.0f 3)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    mtitles("Work Days Lost" "Any School Absence" "Number of Absences") ///
    title("Treatment Effects on Work and School Days Lost") ///
    note("Work days lost and school absences are self-reported. All specifications include baseline outcome, household controls, walking distances to nearest villages by treatment arm, and auction experiment fixed effects. Standard errors clustered at village level.")

* spillover effects
esttab spill_* using "$specifications/work_school_spillovers.tex", replace ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    keep(T_L T_T) ///
    stats(p_diff baseline_control controls distance auction N r2, ///
        labels("P-value L=T" "Baseline Control" "Controls" "Distance Vector" "Auction FE" "N" "R-squared") ///
        fmt(3 0 0 0 0 %9.0f 3)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    mtitles("Work Days Lost" "Any School Absence" "Number of Absences") ///
    title("Spillover Effects on Work and School Days Lost") ///
    note("L indicates local control (untreated) households, T indicates treated households. All specifications include baseline outcome, household controls, walking distances to nearest villages by treatment arm, and auction experiment fixed effects. Standard errors clustered at village level.")
	
**************************************************
* 2.1.2: Educational Outcomes Analysis
**************************************************

* education outcomes
local attainment "max_grade"                       // educational attainment
local enrollment "any_enrolled num_enrolled"       // school participation (extensive)
local attendance "avg_attendance any_last_year full_attend"  // school participation (intensive)

* labels
local lab_max_grade "Highest Grade"
local lab_any_enrolled "Any Enrollment"
local lab_num_enrolled "Number Enrolled"
local lab_avg_attendance "Average Attendance"
local lab_any_last_year "Attended Last Year"
local lab_full_attend "Full Attendance"

* main treatment effects (eq 1)
eststo clear
foreach y in max_grade any_enrolled num_enrolled avg_attendance any_last_year full_attend {
    eststo main_`y': reg midline_`y' trained_hh baseline_`y' ///
        $controls $distance_vector i.auction_village, vce(cluster hhid_village)
    estadd local baseline_control "Yes"
    estadd local controls "Yes"
    estadd local distance "Yes"
    estadd local auction "Yes"
}

* spillover effects (eq 3)
foreach y in max_grade any_enrolled num_enrolled avg_attendance any_last_year full_attend {
    * gen treatment indicators
    gen T_L = (treatment_arm != 0 & trained_hh == 0)  // local controls
    gen T_T = trained_hh                              // treat households
    
    eststo spill_`y': reg midline_`y' T_L T_T baseline_`y' ///
        $controls $distance_vector i.auction_village, vce(cluster hhid_village)
    
    * difference between local controls and treated
    test T_L = T_T
    estadd scalar p_diff = r(p)
    
    drop T_L T_T
}

* export main treatment effects
esttab main_* using "$specifications/education_main.tex", replace ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    keep(trained_hh) ///
    stats(baseline_control controls distance auction N r2, ///
        labels("Baseline Control" "Controls" "Distance Vector" "Auction FE" "N" "R-squared") ///
        fmt(0 0 0 0 %9.0f 3)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    mlabels("`lab_max_grade'" "`lab_any_enrolled'" "`lab_num_enrolled'" ///
            "`lab_avg_attendance'" "`lab_any_last_year'" "`lab_full_attend'") ///
    title("Treatment Effects on Educational Outcomes") ///
    note("Outcomes include measures of attainment (highest grade), enrollment, and attendance. All specifications include baseline outcome, household controls, walking distances to nearest villages by treatment arm, and auction experiment fixed effects. Standard errors clustered at village level.")

* spillover effects
esttab spill_* using "$specifications/education_spillovers.tex", replace ///
    cells(b(star fmt(3)) se(par fmt(3))) ///
    keep(T_L T_T) ///
    stats(p_diff baseline_control controls distance auction N r2, ///
        labels("P-value L=T" "Baseline Control" "Controls" "Distance Vector" "Auction FE" "N" "R-squared") ///
        fmt(3 0 0 0 0 %9.0f 3)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    mlabels("`lab_max_grade'" "`lab_any_enrolled'" "`lab_num_enrolled'" ///
            "`lab_avg_attendance'" "`lab_any_last_year'" "`lab_full_attend'") ///
    title("Spillover Effects on Educational Outcomes") ///
    note("L indicates local control (untreated) households, T indicates treated households. All specifications include baseline outcome, household controls, walking distances to nearest villages by treatment arm, and auction experiment fixed effects. Standard errors clustered at village level.")