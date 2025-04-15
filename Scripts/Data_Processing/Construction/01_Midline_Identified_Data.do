****** Identified Data Construction ***************************

clear all
set mem 100m
set maxvar 30000
set matsize 11000
set more off

**************************************************
* SET FILE PATHS
**************************************************

* Set base Box path for each user
if "`c(username)'"=="socrm" global master "C:\Users\socrm\Box\NSF Senegal"
if "`c(username)'"=="kls329" global master "C:\Users\kls329\Box\NSF Senegal"
if "`c(username)'"=="km978" global master "C:\Users\km978\Box\NSF Senegal"
if "`c(username)'"=="Kateri" global master "C:\Users\Kateri\Box\NSF Senegal"
if "`c(username)'"=="admmi" global master "C:\Users\admmi\Box\NSF Senegal"

**************************** Data file paths ****************************

global data "$master\Data_Management\Data\_CRDES_RawData\Midline\Household_Survey_Data"
global replacement "$master\Data_Management\Data\_CRDES_RawData\Midline\Replacement_Survey_Data"
global baselineids "$master\Data_Management\Data\_CRDES_CleanData\Baseline\Identified"
global issues "$master\Data_Management\Output\Data_Quality_Checks\Midline\_Midline_Original_Issues_Output"
global corrected "$master\Data_Management\Output\Data_Processing\Checks\Corrections\Midline"
global clean "$master\Data_Management\Data\_CRDES_CleanData\Midline\Identified"
global consent "$master\Data_Management\Data\_CRDES_CleanData\Midline\Identified\DISES_Midline_Complete_PII.dta"


************************ Household Data **************************************
*** Import baseline data 
use "$baselineids\DISES_Baseline_Complete_PII.dta", clear

keep hhid hh_head_name_complet  // Keep only HHID and Village ID
duplicates drop hhid, force  // Keep one entry per household
gen baseline = 1  // Mark as a baseline household

* Correction for 132A that should be 153A
foreach var of varlist * {
    capture confirm string variable `var'
    if !_rc {
        replace `var' = subinstr(`var', "132A", "153A", .)
    }
}

save "$baselineids\DISES_Complete_Baseline_HHID_List.dta", replace

*** Import midline data & Mark Attrition

use "$corrected\CORRECTED_DISES_Enquête_ménage_midline_VF_WIDE_10April2025.dta", clear  
// keep hh_global_id hhid_village consent  // Keep relevant variables
rename hh_global_id hhid
drop hh_head_name_complet
gen attritted = 0  // Default is not attritted
duplicates drop hhid, force  // Keep one entry per household
drop if missing(hhid)
replace attritted = 1 if (consent == 0 | consent == 2)  // Mark attritted if no consent

* Correction for 132A that should be 153A
foreach var of varlist * {
    capture confirm string variable `var'
    if !_rc {
        replace `var' = subinstr(`var', "132A", "153A", .)
    }
}

merge 1:1 hhid using "$baselineids\DISES_Complete_Baseline_HHID_List.dta"
keep if _merge == 3  // Keep only households present in both datasets

drop _merge  // Clean up merge variable

forvalues i = 1/57 {
    rename age_`i' hh_age_`i'
	
}

save "$clean\DISES_Complete_Midline_Retained.dta", replace

*** Merge midline with baseline to find attrition

use "$baselineids\DISES_Complete_Baseline_HHID_List.dta", clear

gen attritted = 1  // Assume all baseline households are attritted initially


merge 1:1 hhid using "$clean\DISES_Complete_Midline_Retained.dta"

replace attritted = 0 if _merge == 3  // If HH appears in both baseline & midline then Not attritted
replace attritted = 1 if _merge == 1  // If HH in baseline but missing in midline then Attritted

save "$clean\DISES_Complete_Midline_Attrition.dta", replace

*** HHID's for Replacements ***
import delimited "$corrected\CORRECTED_DISES_enquete_ménage_FINALE_MIDLINE_REPLACEMENT_WIDE_10April2025.csv", clear varnames(1) bindquote(strict)     

// Mark as a replacement household
gen replaced = 1  

tostring no_consent, force replace

* Sort by village to ensure sequential numbering
bysort hhid_village (hhid): gen rep_number = _n  // Assigns 1, 2, 3,... per village

* Create the new replacement `hhid` based on original `hhid`
gen hhid_replacement = hhid + string(rep_number + 29, "%02.0f")  // Adds 30, 31, 32,...
rename hhid_replacement hhid
drop rep_number

*** Save initial replacement dataset ***
save "$clean\DISES_Complete_Midline_Replacements.dta", replace

*** Process individual IDs in replacements ***

*** Reshape data to long format ***
reshape long hh_full_name_calc_ hh_gender_ hh_age_, ///
    i(hhid_village sup enqu hh_head_name_complet hh_name_complet_resp hh_age_resp hh_gender_resp hh_phone) ///
    j(individual)

*** Drop empty individual records ***
drop if missing(hh_full_name_calc_) & missing(hh_gender_) & missing(hh_age_)

*** Ensure `individual` is a two-digit string ***
gen indiv_index = string(individual, "%02.0f")

*** Construct `individ` ID ***
gen individ = hhid + indiv_index

keep hhid individual individ hh_full_name_calc_ hh_gender_ hh_age_

*** Save individual-level dataset ***
save "$clean\DISES_Complete_Midline_Replacement_Individual_IDs.dta", replace

*** Reshape back to wide format with new naming convention ***
reshape wide individ hh_full_name_calc_ hh_gender_ hh_age_, i(hhid) j(individual)

*** Rename variables to `pull_hh_individ_1`, `pull_hh_individ_2`, etc. ***
rename individ* pull_hh_individ_*
rename hh_full_name_calc_* hh_full_name_calc_*
rename hh_gender_* hh_gender_*
rename hh_age_* hh_age_*

*** Merge updated individual data back with replacement household dataset ***
merge 1:1 hhid using "$clean\DISES_Complete_Midline_Replacements.dta"
drop _merge

rename hh_numero hh_size_actual

forvalues i = 1/14 {
    gen nom_complet_`i' = hh_full_name_calc_`i'
}

gen hh_size_load = hh_size_actual

forvalues i = 1/14 {
    gen full_name_age_`i' = hh_full_name_calc_`i' + " (age: " + string(hh_age_`i') + ")"
}


*** Save final replacement household dataset with individuals included ***
save "$clean\DISES_Complete_Midline_Replacements.dta", replace

*** HHID's for Merged Households
use "$corrected\CORRECTED_DISES_Enquête_ménage_midline_VF_WIDE_10April2025.dta", clear  
// keep hh_global_id hhid_village consent  // Keep relevant variables
rename hh_global_id hhid
drop hh_head_name_complet
drop if consent == 0
drop if consent == 2
duplicates drop hhid, force  // Keep one entry per household
drop if missing(hhid)

merge 1:1 hhid using "$baselineids\DISES_Complete_Baseline_HHID_List.dta"
keep if _merge == 3  // Keep only households present in both datasets

drop _merge  // Clean up merge variable

gen hhid_merged = hhid  // Create a new variable to store updated HHIDs

replace hhid_merged = hhid_village + "70" if inlist(hhid, "133A19", "133A03")
replace hhid_merged = hhid_village + "71" if inlist(hhid, "133A20", "133A02")
replace hhid_merged = hhid_village + "72" if inlist(hhid, "133A05", "133A11")

* Keep only the merged households
keep if inlist(hhid, "133A19", "133A03", "133A20", "133A02", "133A05", "133A11")

drop hhid  
rename hhid_merged hhid  
forvalues i = 1/57 {
    rename age_`i' hh_age_`i'
}


save "$clean\DISES_Complete_Midline_Merged.dta", replace

/*
Merges
HHID 133A19 avec 133A03
133A19 kept in Midline
HHID 133A20 avec 133A02
133A20 kept in Midline
HHID 133A05 avec 133A11
133A11 kept in midline
HHID 133A15 avec 133A01
Indicated that they merged but they are both included seperately in the data

*/
*** Combine Retained and Replacement HHs
use "$clean\DISES_Complete_Midline_Retained.dta", clear
append using "$clean\DISES_Complete_Midline_Replacements.dta", force  
append using "$clean\DISES_Complete_Midline_Merged.dta", force  
save "$clean\DISES_Midline_Complete_PII.dta", replace


save "$clean\DISES_Midline_Complete_PII.dta", replace

************************** Community Survey ************************************
import excel "$corrected\CORRECTED_Community_Survey_10April2025.xlsx", firstrow clear

save "$clean\DISES_Complete_Midline_Community", replace

************************** School Principal Survey *****************************
import excel "$corrected\CORRECTED_DISES_Principal_Survey_MIDLINE_VF_WIDE_10April2025.xlsx", firstrow clear

preserve

keep submissiondate starttime endtime deviceid devicephonenum username device_info duration caseid today record_text village_select village_select_o hhid_village region departement commune village grappe schoolmosqueclinic grappe_int sup sup_txt sup_name consent_obtain consent_notes respondent_is_director respondent_is_not_director respondent_is_not_director_o start_survey date time geo_loclatitude geo_loclongitude geo_localtitude geo_locaccuracy respondent_other_role school_name respondent_other_role_o respondent_name respondent_phone_primary respondent_phone_secondary respondent_gender respondent_age director_experience_general director_experience_specific school_water_main school_water_main_o school_distance_river school_children_water_collection school_water_use school_water_use_1 school_water_use_2 school_water_use_3 school_water_use_99 school_water_use_o school_reading_french school_reading_local school_computer_access school_meal_program school_teachers school_staff_paid_non_teaching school_staff_volunteers school_council council_school_staff council_community_members council_women council_chief_involvement grade_loop grade_loop_1 grade_loop_2 grade_loop_3 grade_loop_4 grade_loop_5 grade_loop_6 grade_loop_count grade_loop_repeat_count grade_loop_index_1 grade_loop_name_1 classroom_count_1 classroom_loop_count_1 classroom_index_1_1 enrollment_2024_total_1_1 enrollment_2024_female_1_1 passing_2024_total_1_1 passing_2024_female_1_1 photo_enrollment_2024_1_1 classroom_index_1_2 enrollment_2024_total_1_2 enrollment_2024_female_1_2 passing_2024_total_1_2 passing_2024_female_1_2 photo_enrollment_2024_1_2 grade_loop_index_2 grade_loop_name_2 classroom_count_2 classroom_loop_count_2 classroom_index_2_1 enrollment_2024_total_2_1 enrollment_2024_female_2_1 passing_2024_total_2_1 passing_2024_female_2_1 photo_enrollment_2024_2_1 classroom_index_2_2 enrollment_2024_total_2_2 enrollment_2024_female_2_2 passing_2024_total_2_2 passing_2024_female_2_2 photo_enrollment_2024_2_2 grade_loop_index_3 grade_loop_name_3 classroom_count_3 classroom_loop_count_3 classroom_index_3_1 enrollment_2024_total_3_1 enrollment_2024_female_3_1 passing_2024_total_3_1 passing_2024_female_3_1 photo_enrollment_2024_3_1 classroom_index_3_2 enrollment_2024_total_3_2 enrollment_2024_female_3_2 passing_2024_total_3_2 passing_2024_female_3_2 photo_enrollment_2024_3_2 grade_loop_index_4 grade_loop_name_4 classroom_count_4 classroom_loop_count_4 classroom_index_4_1 enrollment_2024_total_4_1 enrollment_2024_female_4_1 passing_2024_total_4_1 passing_2024_female_4_1 photo_enrollment_2024_4_1 classroom_index_4_2 enrollment_2024_total_4_2 enrollment_2024_female_4_2 passing_2024_total_4_2 passing_2024_female_4_2 photo_enrollment_2024_4_2 grade_loop_index_5 grade_loop_name_5 classroom_count_5 classroom_loop_count_5 classroom_index_5_1 enrollment_2024_total_5_1 enrollment_2024_female_5_1 passing_2024_total_5_1 passing_2024_female_5_1 photo_enrollment_2024_5_1 classroom_index_5_2 enrollment_2024_total_5_2 enrollment_2024_female_5_2 passing_2024_total_5_2 passing_2024_female_5_2 photo_enrollment_2024_5_2 grade_loop_index_6 grade_loop_name_6 classroom_count_6 classroom_loop_count_6 classroom_index_6_1 enrollment_2024_total_6_1 enrollment_2024_female_6_1 passing_2024_total_6_1 passing_2024_female_6_1 photo_enrollment_2024_6_1 classroom_index_6_2 enrollment_2024_total_6_2 enrollment_2024_female_6_2 passing_2024_total_6_2 passing_2024_female_6_2 photo_enrollment_2024_6_2 grade_loop_2025 grade_loop_2025_1 grade_loop_2025_2 grade_loop_2025_3 grade_loop_2025_4 grade_loop_2025_5 grade_loop_2025_6 grade_loop_count_2025 grade_loop_repeat_2025_count grade_loop_index_2025_1 grade_loop_name_2025_1 classroom_count_2025_1 classroom_loop_2025_count_1 classroom_index_2025_1_1 enrollment_2025_total_1_1 enrollment_2025_female_1_1 photo_enrollment_2025_1_1 attendence_regularly_1_1 classroom_index_2025_1_2 enrollment_2025_total_1_2 enrollment_2025_female_1_2 photo_enrollment_2025_1_2 attendence_regularly_1_2 grade_loop_index_2025_2 grade_loop_name_2025_2 classroom_count_2025_2 classroom_loop_2025_count_2 classroom_index_2025_2_1 enrollment_2025_total_2_1 enrollment_2025_female_2_1 photo_enrollment_2025_2_1 attendence_regularly_2_1 classroom_index_2025_2_2 enrollment_2025_total_2_2 enrollment_2025_female_2_2 photo_enrollment_2025_2_2 attendence_regularly_2_2 grade_loop_index_2025_3 grade_loop_name_2025_3 classroom_count_2025_3 classroom_loop_2025_count_3 classroom_index_2025_3_1 enrollment_2025_total_3_1 enrollment_2025_female_3_1 photo_enrollment_2025_3_1 attendence_regularly_3_1 classroom_index_2025_3_2 enrollment_2025_total_3_2 enrollment_2025_female_3_2 photo_enrollment_2025_3_2 attendence_regularly_3_2 grade_loop_index_2025_4 grade_loop_name_2025_4 classroom_count_2025_4 classroom_loop_2025_count_4 classroom_index_2025_4_1 enrollment_2025_total_4_1 enrollment_2025_female_4_1 photo_enrollment_2025_4_1 attendence_regularly_4_1 classroom_index_2025_4_2 enrollment_2025_total_4_2 enrollment_2025_female_4_2 photo_enrollment_2025_4_2 attendence_regularly_4_2 grade_loop_index_2025_5 grade_loop_name_2025_5 classroom_count_2025_5 classroom_loop_2025_count_5 classroom_index_2025_5_1 enrollment_2025_total_5_1 enrollment_2025_female_5_1 photo_enrollment_2025_5_1 attendence_regularly_5_1 classroom_index_2025_5_2 enrollment_2025_total_5_2 enrollment_2025_female_5_2 photo_enrollment_2025_5_2 attendence_regularly_5_2 grade_loop_index_2025_6 grade_loop_name_2025_6 classroom_count_2025_6 classroom_loop_2025_count_6 classroom_index_2025_6_1 enrollment_2025_total_6_1 enrollment_2025_female_6_1 photo_enrollment_2025_6_1 attendence_regularly_6_1 classroom_index_2025_6_2 enrollment_2025_total_6_2 enrollment_2025_female_6_2 photo_enrollment_2025_6_2 attendence_regularly_6_2 absenteeism_problem main_absenteeism_reasons main_absenteeism_reasons_1 main_absenteeism_reasons_2 main_absenteeism_reasons_3 main_absenteeism_reasons_4 main_absenteeism_reasons_5 main_absenteeism_reasons_6 main_absenteeism_reasons_99 main_absenteeism_reasons_o main_absenteeism_reasons_label1 main_absenteeism_reasons_label2 main_absenteeism_reasons_label3 main_absenteeism_reasons_label4 main_absenteeism_reasons_label5 main_absenteeism_reasons_label6 main_absenteeism_reasons_label7 absenteeism_top_reason absenteeism_top_reason_o schistosomiasis_problem peak_schistosomiasis_month schistosomiasis_primary_effect schistosomiasis_sources schistosomiasis_sources_1 schistosomiasis_sources_2 schistosomiasis_sources_3 schistosomiasis_sources_4 schistosomiasis_sources_99 schistosomiasis_sources_o schistosomiasis_treatment_minist schistosomiasis_treatment_date instanceid instancename formdef_version key

save "$clean\DISES_Complete_Midline_SchoolPrincipal", replace

restore

keep submissiondate starttime endtime deviceid devicephonenum username device_info duration caseid today record_text village_select village_select_o hhid_village region departement commune village grappe schoolmosqueclinic grappe_int sup sup_txt sup_name consent_obtain consent_notes start_survey date time geo_loclatitude geo_loclongitude geo_localtitude geo_locaccuracy respondent_other_role school_name hhid_village region departement commune grappe* sup* consent* respondent* start_survey date time geo_loc* hh_size_load school_repeat_count fu_mem_id_* pull_hhid_village_* pull_hhid_* pull_individ_* pull_hh_* pull_baselineniveau_* pull_family_members_* pull_temp_* info_eleve_* instanceid instancename formdef_version key

tostring pull_baselineniveau_*, replace

reshape long fu_mem_id_ pull_hhid_village_ pull_hhid_ pull_individ_ ///
    pull_hh_first_name__ pull_hh_name__ pull_hh_full_name_calc__ ///
    pull_hh_age_ pull_hh_gender_ pull_hh_head_name_complet_ ///
    pull_baselineniveau_ pull_family_members_ pull_temp_ ///
    pull_fu_mem_id_ info_eleve_2_ info_eleve_3_ info_eleve_7_, ///
    i(key school_name) j(id)

drop if missing(pull_individ_)

rename pull_hhid_ hhid

* keep only those observations who consent was achieved at midline in the household data
merge m:1 hhid using "$consent", keepusing(hh_49) keep(master match) generate(_merge_status)

drop if missing(hh_49) | hh_49 == 0

rename hhid pull_hhid_

reshape wide fu_mem_id_ pull_hhid_village_ pull_hhid_ pull_individ_ ///
    pull_hh_first_name__ pull_hh_name__ pull_hh_full_name_calc__ ///
    pull_hh_age_ pull_hh_gender_ pull_hh_head_name_complet_ ///
    pull_baselineniveau_ pull_family_members_ pull_temp_ ///
    pull_fu_mem_id_ info_eleve_2_ info_eleve_3_ info_eleve_7_, ///
    i(key school_name) j(id)

save "$clean\DISES_Complete_Midline_SchoolAttendance", replace
