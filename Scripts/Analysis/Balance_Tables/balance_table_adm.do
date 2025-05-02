**************************************************
* DISES Baseline Balance Table *
* File Created By: Alexander Mills *
* File Last Updated By: Alexander Mills *
* Updates Tracked on Git *
**************************************************

*** This Do File PROCESSES: PUT ALL SCRIPTS HERE***
*** This Do File CREATES: balance_table_adm.tex"
						
*** Procedure: ***
* 
capture log close
clear all
set mem 100m
set maxvar 30000
set matsize 11000
set more off
version 14.1

**************************************************
* SET FILE PATHS
**************************************************

disp "`c(username)'"

* Set global path based on the username
if "`c(username)'" == "admmi" global master "C:\Users\admmi\Box\NSF Senegal"
if "`c(username)'" == "km978" global master "C:\Users\km978\Box\NSF Senegal"
if "`c(username)'" == "socrm" global master "C:\Users\socrm\Box\NSF Senegal"

global baseline "$master\Data_Management\Data\_CRDES_CleanData\Baseline\Deidentified"
global midline "$master\Data_Management\Data\_CRDES_CleanData\Midline\Deidentified"
global balance "$master\Data_Management\Output\Analysis\Balance_Tables\baseline_balance_tables_data_PAP.dta"
global treatment "$master\Data_Management\Data\_CRDES_CleanData\Treatment\Identified\treatment_indicator_PII.dta"
global asset_index "$master\Data_Management\Output\Data_Processing\Construction\PCA_asset_index_var.dta"
global respondent_index "$master\Data_Management\Data\_CRDES_CleanData\Baseline\Deidentified\respondent_index.dta"
global balance_tables "$master\Data_Management\Output\Analysis\Balance_Tables"

global baseline_agriculture "$baseline\Complete_Baseline_Agriculture.dta"
global baseline_beliefs "$baseline\Complete_Baseline_Beliefs.dta"
global baseline_community "$baseline\Complete_Baseline_Community.dta"
global baseline_enumerator "$baseline\Complete_Baseline_Enumerator_Observations.dta"
global baseline_geographies "$baseline\Complete_Baseline_Geographies.dta"
global baseline_health "$baseline\Complete_Baseline_Health.dta"
global baseline_household "$baseline\Complete_Baseline_Household_Roster.dta"
global baseline_income "$baseline\Complete_Baseline_Income.dta"
global baseline_knowledge "$baseline\Complete_Baseline_Knowledge.dta"
global baseline_lean "$baseline\Complete_Baseline_Lean_Season.dta"
global baseline_production "$baseline\Complete_Baseline_Production.dta"
global baseline_standard "$baseline\Complete_Baseline_Standard_Of_Living.dta"
global baseline_community "$baseline\Complete_Baseline_Community.dta"
global baseline_games "$baseline\Complete_Baseline_Public_Goods_Game"

**************************************************
* controls and treatment data
**************************************************
use "$baseline_household", clear

* merge all together needed for balance tables
merge 1:1 hhid using "$baseline_health", nogen
merge 1:1 hhid using "$baseline_agriculture", nogen
merge 1:1 hhid using "$baseline_income", nogen
merge 1:1 hhid using "$baseline_standard", nogen
merge 1:1 hhid using "$baseline_games", nogen
merge 1:1 hhid using "$baseline_enumerator", nogen
merge 1:1 hhid using "$baseline_beliefs", nogen	
merge m:1 hhid_village using "$baseline_community", nogen

***************
* household head
***************
// need to match this to protocol from the hh_head_index file being created
gen hh_head_index = .

forvalues i = 1/55 {
    * If the household head name matches the full name of member `i`, store the index `i`
    replace hh_head_index = `i' if hh_relation_with_`i' == 1
}

* backfill the missing household heads with respondent index
merge 1:1 hhid using "$respondent_index", nogen
replace hh_head_index = resp_index if missing(hh_head_index) & !missing(resp_index)

* loop through individuals to backfill hh_head_index based on respondent's age and gender
forvalues i = 1/55 {
    replace hh_head_index = `i' if missing(hh_head_index) ///
        & hh_age_resp == hh_age_`i' ///
        & hh_gender_resp == hh_gender_`i'
}
* backfill with oldest male.... need a better way than this TEMPORARY PLACEHOLDER
gen max_male_age = .
forvalues i = 1/55 {
    replace max_male_age = hh_age_`i' if missing(max_male_age) & hh_gender_`i' == 1 ///
        & !missing(hh_age_`i')
    replace max_male_age = hh_age_`i' if hh_gender_`i' == 1 & hh_age_`i' > max_male_age ///
        & !missing(hh_age_`i') & !missing(max_male_age)
}

* oldest male as household head where hh_head_index is still missing
forvalues i = 1/55 {
    replace hh_head_index = `i' if missing(hh_head_index) & hh_gender_`i' == 1 ///
        & hh_age_`i' == max_male_age
}

drop max_male_age

preserve

**************
* trained_hh
**************
use "$treatment", clear
* correction for 132A that should be 153A
foreach var of varlist * {
    capture confirm string variable `var'
    if !_rc {
        replace `var' = subinstr(`var', "132A", "153A", .)
    }
}

collapse (max) trained_hh, by(hhid)
tempfile treatment_clean
save `treatment_clean', replace

restore

merge 1:1 hhid using `treatment_clean', keep(master match) nogen

*********
* hh_age_h
*********
gen hh_age_h = .

forvalues i = 1/55 {
    replace hh_age_h = hh_age_`i' if hh_head_index == `i'
}

***************
* hh_education_level_bin_h
***************
gen hh_education_level_bin_h = 0

forvalues i = 1/55 {
    replace hh_education_level_bin_h = 1 if hh_head_index == `i' & inlist(hh_education_level_`i', 2, 3, 4)
}

**************
* hh_education_skills_5_h
**************
gen hh_education_skills_5_h = 0

forvalues i = 1/55 {
    replace hh_education_skills_5_h = 1 if hh_head_index == `i' & hh_education_skills_5_`i' == 1
}

**************
* hh_gender_h
*************
gen hh_gender_h = .

forvalues i = 1/55 {
    replace hh_gender_h = 1 if hh_head_index == `i' & hh_gender_`i' == 2  // female
    replace hh_gender_h = 0 if hh_head_index == `i' & hh_gender_`i' == 1  // male
}

***********
* hh_numero
************
* hh_numero

**********
* hh_03_ (changed from rowmax to rowtotal)
**********
forvalues i = 1/55 {
    capture confirm variable hh_03_`i'
    if !_rc {
        replace hh_03_`i' = .a if hh_03_`i' == 2
        * Convert to binary first (1 if affirmative, 0 otherwise)
        replace hh_03_`i' = 1 if hh_03_`i' == 1 & `i' <= hh_numero
        replace hh_03_`i' = 0 if missing(hh_03_`i') & `i' <= hh_numero
    }
}

* Count members who answer affirmatively
egen hh_03_ = rowtotal(hh_03_*)
label var hh_03_ "Count of HH members with affirmative response"

**********
* hh_10_ (changed from rowmean to rowtotal)
**********
* For hh_10_ (water interaction), count members with any interaction
gen hours_water_interact_count = 0
forvalues i = 1/55 {
    * Count members who have any water interaction hours (>0)
    replace hours_water_interact_count = hours_water_interact_count + 1 if hh_10_`i' > 0 & `i' <= hh_numero & !missing(hh_10_`i')
}
* Rename to hh_10_ to maintain original variable name
gen hh_10_ = hours_water_interact_count
drop hours_water_interact_count
label var hh_10_ "Count of HH members who interact with surface water"

***********
* hh_12_6_ (changed from rowmax to rowtotal)
**********
* For hh_12_6_ (harvested aquatic vegetation)
* ensure we have values for all individuals who should have been asked
forvalues i = 1/55 {
    * Set to 0 for those who were asked but have missing values
    replace hh_12_6_`i' = 0 if missing(hh_12_6_`i') & hh_10_`i' > 0 & `i' <= hh_numero
    
    * Also set to 0 for household members who didn't interact with water source
    replace hh_12_6_`i' = 0 if missing(hh_12_6_`i') & hh_10_`i' == 0 & `i' <= hh_numero
}

* Count household members who harvested aquatic vegetation
egen hh_12_6_ = rowtotal(hh_12_6_*)
label var hh_12_6_ "Count of HH members who harvested aquatic vegetation"

**********
* hh_16_ (changed from mean average to total hours)
*********
* For hh_16_ (hours producing fertilizer)
* Set to 0 for individuals who should have been asked but have missing values
forvalues i = 1/55 {
    * Set to 0 for those who were asked but have missing values
    replace hh_16_`i' = 0 if missing(hh_16_`i') & hh_10_`i' > 0 & `i' <= hh_numero
    
    * Also set to 0 for household members who didn't interact with water source
    replace hh_16_`i' = 0 if missing(hh_16_`i') & hh_10_`i' == 0 & `i' <= hh_numero
}

* Calculate total hours across all household members
egen hh_16_ = rowtotal(hh_16_*)
label var hh_16_ "Total hours per week producing fertilizer in household"

**********
* hh_15_2_ (changed from rowmax to rowtotal)
**********
* For hh_15_2_ (used for fertilizer)
* First ensure we handle the skip pattern for hh_15_
forvalues i = 1/55 {
    * Set to 0 for those who should have been asked but have missing values
    replace hh_15_`i' = 0 if missing(hh_15_`i') & hh_10_`i' > 0 & hh_12_6_`i' == 1
    
    * Also set to 0 for household members who weren't asked due to skip pattern
    replace hh_15_`i' = 0 if missing(hh_15_`i') & (hh_10_`i' == 0 | hh_12_6_`i' == 0) & `i' <= hh_numero
}

* Create individual-level binary indicator (1 if used for fertilizer, i.e., hh_15_ == 2)
forvalues i = 1/55 {
    gen hh_15_2_`i' = (hh_15_`i' == 2)
    * Ensure all individuals have a value
    replace hh_15_2_`i' = 0 if missing(hh_15_2_`i') & `i' <= hh_numero
}

* Count household members who used harvested vegetation for fertilizer
egen hh_15_2_ = rowtotal(hh_15_2_*)
label var hh_15_2_ "Count of HH members who used vegetation for fertilizer"

*******
* hh_26_ (changed from proportion to count)
********
* identify school-aged children (4–18 years old)
forvalues i = 1/55 {
    gen child_4_18_`i' = inrange(hh_age_`i', 4, 18) & !missing(hh_age_`i')
}

* hh_26_: count of children currently enrolled
forvalues i = 1/55 {
    gen child_in_school_`i' = 0
    replace child_in_school_`i' = 1 if hh_26_`i' == 1 & child_4_18_`i' == 1
    replace child_in_school_`i' = 0 if inlist(hh_26_`i', 2, .) & child_4_18_`i' == 1
}

egen num_children_4_18 = rowtotal(child_4_18_*)
egen num_children_in_school = rowtotal(child_in_school_*)

* Use the raw count instead of proportion
gen hh_26_ = num_children_in_school
label var hh_26_ "Count of school-aged children enrolled in school"
gen has_eligible_children = num_children_4_18 > 0

**********
* hh_29_ (changed from proportion to count)
***********
* hh_29_: count of children in each schooling level
forvalues i = 1/55 {
    gen child_prim_`i'    = inrange(hh_29_`i', 1, 6)   & child_4_18_`i'
    gen child_sec1_`i'    = inrange(hh_29_`i', 7, 10)  & child_4_18_`i'
    gen child_sec2_`i'    = inrange(hh_29_`i', 11, 13) & child_4_18_`i'
    gen child_postsec_`i' = hh_29_`i' == 14            & child_4_18_`i'
}

egen num_prim     = rowtotal(child_prim_*)
egen num_sec1     = rowtotal(child_sec1_*)
egen num_sec2     = rowtotal(child_sec2_*)
egen num_postsec  = rowtotal(child_postsec_*)

* Use raw counts instead of proportions
gen hh_29_01 = num_prim
gen hh_29_02 = num_sec1
gen hh_29_03 = num_sec2
gen hh_29_04 = num_postsec

label var hh_29_01 "Count of children in primary school"
label var hh_29_02 "Count of children in lower secondary school"
label var hh_29_03 "Count of children in upper secondary school"
label var hh_29_04 "Count of children in post-secondary education"

**********
* hh_37_ (changed from proportion to total count)
**********
forvalues i = 1/55 {
    * identify enrolled school-aged children
    gen enrolled_child_`i' = child_4_18_`i' & hh_26_`i' == 1

    * treat "don't know" responses as missing
    replace hh_37_`i' = .a if hh_37_`i' == 2 & enrolled_child_`i'

    * set missing values to 0 *only* for enrolled children
    replace hh_37_`i' = 0 if missing(hh_37_`i') & enrolled_child_`i'

    * keep valid reports of absence among enrolled kids
    gen missed_school_`i' = hh_37_`i' if enrolled_child_`i'
}

* Use total absences rather than proportion
egen hh_37_ = rowtotal(missed_school_*)
label var hh_37_ "Total days of school missed by all enrolled children"

* cleanup
drop child_4_18_* enrolled_child_* missed_school_*

*********
* hh_38_ (changed from proportion to total)
*********
* identify school-aged children
forvalues i = 1/55 {
    gen child_4_18_`i' = inrange(hh_age_`i', 4, 18) & !missing(hh_age_`i')
}

* flag those enrolled in school
forvalues i = 1/55 {
    gen enrolled_`i' = (hh_26_`i' == 1) & child_4_18_`i'
}

* clean attendance variable: only for enrolled children
forvalues i = 1/55 {
    replace hh_38_`i' = .a if hh_38_`i' == -9 & enrolled_`i' == 1
    replace hh_38_`i' = 0 if missing(hh_38_`i') & enrolled_`i' == 1
}

* generate valid attendance only for enrolled school-aged children
forvalues i = 1/55 {
    gen valid_attend_`i' = hh_38_`i' if enrolled_`i' == 1
}

* Use total attendance days rather than average
egen hh_38_ = rowtotal(valid_attend_*)
label var hh_38_ "Total days of school attended by all enrolled children"

* cleanup
drop child_4_18_* enrolled_* valid_attend_*

********
* living_01_bin
********
gen living_01_bin = 0
replace living_01_bin = 1 if living_01 == 1 | living_01 == 2 | living_01 == 3

******** 
* game_A_total
********
egen game_A_total = rowtotal(montant_05 face_13)
******
* game_B_total
********
egen game_B_total = rowtotal(montant_05 face_04)

*********
* TLU
*********
* recode

********
* agri_6_15
*********
* agri_6_15

*********
* agri_6_32_bin
**********
egen agri_6_32_bin = rowmax(agri_6_32_*)

*********
* agri_6_36_bin
**********
egen agri_6_36_bin = rowmax(agri_6_36_*)

********
* total_land_ha
*******
* Convert land area to hectares
forvalues i = 1/11 {
    replace agri_6_21_`i' = agri_6_21_`i' / 10000 if agri_6_22_`i' == 2 // Convert m² to Ha
}

* total hectares
egen total_land_ha = rowtotal(agri_6_21_*)

**********
* agri_6_34_comp_any
************
egen agri_6_34_comp_any = rowmax(agri_6_34_comp_*)

**********
* agri_income_01
**********
* agri_income_01

************
* agri_income_05
**********
*agri_income_05

***************
* beliefs_01_bin - beliefs_09_bin
***************
* Create Binary Indicators for beliefs
gen beliefs_01_bin = (beliefs_01 <= 2)  
gen beliefs_02_bin = (beliefs_02 <= 2)  
gen beliefs_03_bin = (beliefs_03 <= 2)  
gen beliefs_04_bin = (beliefs_04 <= 2)  
gen beliefs_05_bin = (beliefs_05 <= 2) 	
gen beliefs_06_bin = (beliefs_06 <= 2)  
gen beliefs_07_bin = (beliefs_07 <= 2)  
gen beliefs_08_bin = (beliefs_08 <= 2)  
gen beliefs_09_bin = (beliefs_09 <= 2)


**************
* health_5_3_bin
*********
* replace 2 = don't know with missing
forvalues i = 1/55 {
    replace health_5_3_2_`i' = .a if health_5_3_2_`i' == 2
    replace health_5_3_3_`i' = .a if health_5_3_3_`i' == 2
}

* generate binary indicator for each person
forvalues i = 1/55 {
    gen temp_health_`i' = (health_5_3_2_`i' == 1 | health_5_3_3_`i' == 1)
    replace temp_health_`i' = 0 if missing(temp_health_`i')
}

* take max across all members
egen health_5_3_bin = rowmax(temp_health_*)
replace health_5_3_bin = 0 if missing(health_5_3_bin)

* cleanup
drop temp_health_*

***************
* health_5_6_
**************
* clean 'don't know' responses (2 = don't know → .a)
forvalues i = 1/55 {
    replace health_5_6_`i' = .a if health_5_6_`i' == 2
}

* create household-level binary: 1 if anyone diagnosed
egen health_5_6_ = rowmax(health_5_6_*)
replace health_5_6_ = 0 if missing(health_5_6_)


***************
* num_water_access_points
***************
* recode
	
************
* q_51
************
* q_51

********
* target_village
******
gen target_village = inlist(hhid_village, "122A", "123A", "121B", "131B", "120B") | ///
                     inlist(hhid_village, "123B", "153A", "121A", "131A", "141A") | ///
                     hhid_village == "142A"
					 				 
**********************************
* balance tables
*******************************

* extract treatment arm and stratum
gen byte treatment_arm = real(substr(hhid_village, 3, 1))
label define treatlbl 0 "Control" 1 "Arm A - Public Health" 2 "Arm B - Private Benefits" 3 "Arm C - Both Messages"
label values treatment_arm treatlbl

gen stratum = substr(hhid_village, 4, 1)

cd "$balance_tables"

// treatment group based on household ID
gen group = substr(hhid, 3, 2)
gen treatment_group = .
replace treatment_group = 0 if inlist(group, "0A", "0B") // Control
replace treatment_group = 1 if inlist(group, "1A", "1B") // Treatment1 - Private 
replace treatment_group = 2 if inlist(group, "2A", "2B") // Treatment2 - Public
replace treatment_group = 3 if inlist(group, "3A", "3B") // Treatment3 - Private & Public

// labels for treatment groups
label define tg_label 0 "Control" 1 "Private Treatment" 2 "Public Treatment" 3 "Private \& Public Treatment"
label values treatment_group tg_label

// labels for variables in the balance table
label var hh_age_h "Household Head Age"
label var hh_education_level_bin_h "HH Head Secondary Education+"
label var hh_education_skills_5_h "HH Head Literate"
label var hh_gender_h "HH Head Gender (Male=1)"
label var hh_numero "Household Size"
label var hh_03_ "Worked in Agriculture"
label var hh_10_ "Hours Near Water Source"
label var hh_12_6_ "Harvested Aquatic Vegetation"
label var hh_16_ "Hours on Fertilizer Tasks"
label var hh_15_2 "Makes Compost"
label var hh_26_ "Child Enrolled in School"
label var hh_29_01 "HH Member with Diarrhea"
label var hh_29_02 "HH Member with Fever"
label var hh_29_03 "HH Member with Malaria"
label var hh_29_04 "HH Member with Stomach Pain"
label var hh_37_ "Distance to Nearest Health Facility"
label var hh_38_ "Distance to Nearest Water Source"
label var game_A_total "Game A Total Score"
label var game_B_total "Game B Total Score"
label var TLU "Tropical Livestock Units"
label var agri_6_15 "Number of Cultivated Plots"
label var agri_6_32_bin "Used Organic Fertilizer"
label var agri_6_36_bin "Used Chemical Fertilizer"
label var total_land_ha "Total Land (hectares)"
label var agri_6_34_comp_any "Used Compost"
label var agri_income_01 "Income from Crop Sales"
label var agri_income_05 "Income from Livestock Sales"
label var beliefs_01_bin "Environmental Knowledge 1"
label var beliefs_02_bin "Environmental Knowledge 2"
label var beliefs_03_bin "Environmental Knowledge 3"
label var beliefs_04_bin "Village Land = Community"
label var beliefs_05_bin "Water Sources = Community"
label var beliefs_06_bin "Right to Products: Own Land"
label var beliefs_07_bin "Right to Products: Community Land"
label var beliefs_08_bin "Right to Products: Fishing"
label var beliefs_09_bin "Right to Products: Harvesting"
label var health_5_3_bin "Diagnosed Malaria"
label var health_5_6_ "Diagnosed Schistosomiasis"
label var living_01_bin "Improved Living Conditions"
label var num_water_access_points "Number of Water Access Points"
label var target_village "Village in Doruska et. Al. Auction Experiment"

* Define the full list of variables for the main balance table
local balance_vars hh_age_h hh_education_level_bin_h hh_education_skills_5_h ///
    hh_gender_h hh_numero hh_03_ hh_10_ hh_12_6_ hh_16_ hh_15_2 hh_26_ ///
    hh_29_01 hh_29_02 hh_29_03 hh_29_04 hh_37_ hh_38_ game_A_total game_B_total ///
    TLU agri_6_15 agri_6_32_bin agri_6_36_bin total_land_ha agri_6_34_comp_any ///
    agri_income_01 agri_income_05 beliefs_01_bin beliefs_02_bin beliefs_03_bin ///
    beliefs_04_bin beliefs_05_bin beliefs_06_bin beliefs_07_bin beliefs_08_bin ///
    beliefs_09_bin health_5_3_bin health_5_6_ living_01_bin num_water_access_points target_village

* Create matrices to store results
matrix define Coefs = J(4, 1, .)
matrix define SEms = J(4, 1, .)
matrix define Pvals = J(1, 1, .)
matrix define Fstats = J(1, 1, .)
matrix define Ns = J(4, 1, .)

* Calculate sample sizes for each treatment group
quietly tab treatment_group
local total_obs = r(N)
local n_control = 0
local n_private = 0
local n_public = 0
local n_both = 0

forvalues t = 0/3 {
    quietly count if treatment_group == `t'
    local n_`t' = r(N)
}

* Create a file for LaTeX output
file open baltab using "balance_table_adm.tex", write replace

* Write LaTeX table header
file write baltab "\begin{table}[htbp]\centering" _n
file write baltab "\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" _n
file write baltab "\caption{Baseline Balance Table Across Treatment Groups}" _n
file write baltab "\begin{tabular}{l*{4}{c}cc}" _n
file write baltab "\toprule" _n
file write baltab "Variable & Control & Private & Public & Private \& Public & F-test & p-value \\" _n
file write baltab " & Mean (N=`n_0') & Coefficient & Coefficient & Coefficient & & \\" _n
file write baltab " & & (SE) (N=`n_1') & (SE) (N=`n_2') & (SE) (N=`n_3') & & \\" _n
file write baltab "\midrule" _n

* Loop through each variable
foreach var of local balance_vars {
    * Check for missing values by treatment group
    forvalues t = 0/3 {
        quietly count if treatment_group == `t' & !missing(`var')
        local n_var_`t' = r(N)
        matrix Ns[`t'+1,1] = `n_var_`t''
    }
    
    * Verify we have observations for each treatment group
    local all_groups_present = 1
    forvalues t = 0/3 {
        if `n_var_`t'' == 0 {
            local all_groups_present = 0
        }
    }
    
    * Run regression for this variable with error handling
    capture {
        quietly reg `var' i.treatment_group, vce(cluster hhid_village)
        
        * Get F-test (only if all groups are present)
        if `all_groups_present' == 1 {
            test 1.treatment_group 2.treatment_group 3.treatment_group
            local fstat = r(F)
            local pval = r(p)
        }
        else {
            local fstat = .
            local pval = .
        }
        
        * Store coefficients and SEs
        matrix Coefs[1,1] = _b[_cons]
        
        * Carefully extract treatment coefficients if they exist
        forvalues t = 1/3 {
            capture local coef_`t' = _b[`t'.treatment_group]
            if _rc == 0 {
                matrix Coefs[`t'+1,1] = `coef_`t''
            }
            else {
                matrix Coefs[`t'+1,1] = .
            }
            
            capture local se_`t' = _se[`t'.treatment_group]
            if _rc == 0 {
                matrix SEms[`t'+1,1] = `se_`t''
            }
            else {
                matrix SEms[`t'+1,1] = .
            }
        }
        
        matrix SEms[1,1] = _se[_cons]
        matrix Pvals[1,1] = `pval'
        matrix Fstats[1,1] = `fstat'
    }
    
    * Get variable label
    local varlabel : variable label `var'
    if "`varlabel'" == "" {
        local varlabel "`var'"
    }
    
    * Write variable row to LaTeX file
    file write baltab "`varlabel' & "
    
    * Write sample size below variable name in a small font
    file write baltab %9.3f (Coefs[1,1]) " & "
    
    * Treatment coefficients with SE and stars - with missing data handling
    forvalues t = 2/4 {
        if Ns[`t'-1,1] == 0 {
            file write baltab "-- & "
        }
        else if missing(Coefs[`t',1]) | missing(SEms[`t',1]) {
            file write baltab "-- & "
        }
        else if abs(Coefs[`t',1]/SEms[`t',1]) >= 2.58 {
            file write baltab %9.3f (Coefs[`t',1]) "\sym{**} & "
        }
        else if abs(Coefs[`t',1]/SEms[`t',1]) >= 1.96 {
            file write baltab %9.3f (Coefs[`t',1]) "\sym{*} & "
        }
        else {
            file write baltab %9.3f (Coefs[`t',1]) " & "
        }
    }
    
    * F-test and p-value
    if missing(Fstats[1,1]) | missing(Pvals[1,1]) {
        file write baltab "-- & -- \\"
    }
    else {
        file write baltab %9.3f (Fstats[1,1]) " & "
        file write baltab %9.3f (Pvals[1,1]) " \\"
    }
    file write baltab _n
    
    * Write standard errors and sample sizes in parentheses below
    file write baltab " & & "
    forvalues t = 2/4 {
        local t_idx = `t'-1
        if Ns[`t_idx',1] == 0 | missing(SEms[`t',1]) {
            file write baltab "-- & "
        }
        else {
            file write baltab "(" %9.3f (SEms[`t',1]) ") & "
        }
    }
    file write baltab " & \\" _n
    
    * Add sample sizes for each group on third line
    file write baltab " & {\scriptsize N=" %9.0f (Ns[1,1]) "} & "
    forvalues t = 2/4 {
        local t_idx = `t'-1
        file write baltab "{\scriptsize N=" %9.0f (Ns[`t_idx',1]) "} & "
    }
    file write baltab " & \\" _n
    
    file write baltab "\addlinespace" _n
}

* Write table footer with sample sizes for each group
file write baltab "\midrule" _n
file write baltab "\multicolumn{7}{l}{Observations per group: Control (N=`n_0'), Private (N=`n_1'), Public (N=`n_2'), Private \& Public (N=`n_3')}\\" _n
file write baltab "\multicolumn{7}{l}{Total observations: `total_obs'}\\" _n
file write baltab "\bottomrule" _n
file write baltab "\multicolumn{7}{l}{\footnotesize \sym{*} \(p<0.05\), \sym{**} \(p<0.01\)}\\" _n
file write baltab "\end{tabular}" _n
file write baltab "\end{table}" _n

file close baltab

* Additional for actual observation counts per variable (handling missing values)
file open baltab_counts using "balance_table_adm_observations.tex", write replace

file write baltab_counts "\begin{table}[htbp]\centering" _n
file write baltab_counts "\caption{Sample Sizes per Variable by Treatment Group}" _n
file write baltab_counts "\begin{tabular}{l*{5}{c}}" _n
file write baltab_counts "\toprule" _n
file write baltab_counts "Variable & Control & Private & Public & Private \& Public & Total \\" _n
file write baltab_counts "\midrule" _n

foreach var of local balance_vars {
    * Get variable label
    local varlabel : variable label `var'
    if "`varlabel'" == "" {
        local varlabel "`var'"
    }
    
    * Count observations for this variable by treatment group
    file write baltab_counts "`varlabel' & "
    
    * Get counts for each treatment group
    local total_var_obs = 0
    forvalues t = 0/3 {
        quietly count if treatment_group == `t' & !missing(`var')
        local n_var_`t' = r(N)
        local total_var_obs = `total_var_obs' + `n_var_`t''
        file write baltab_counts %9.0f (`n_var_`t'') " & "
    }
    
    * Write total observation count for this variable
    file write baltab_counts %9.0f (`total_var_obs') " \\" _n
}

file write baltab_counts "\bottomrule" _n
file write baltab_counts "\end{tabular}" _n
file write baltab_counts "\end{table}" _n

file close baltab_counts
