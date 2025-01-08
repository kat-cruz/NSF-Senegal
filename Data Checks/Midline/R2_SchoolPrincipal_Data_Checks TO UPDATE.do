*** Created by: Alex Mills ***
*** Updates recorded in GitHub ***
*==============================================================================
clear all
set mem 100m
set maxvar 30000
set matsize 11000
set more off

**************************************************
* SET FILE PATHS
**************************************************

* Set base Box path for each user
if "`c(username)'"=="socrm" global box_path "C:\Users\socrm\Box"
if "`c(username)'"=="kls329" global box_path "C:\Users\kls329\Box"
if "`c(username)'"=="km978" global box_path "C:\Users\km978\Box\NSF Senegal"
if "`c(username)'"=="Kateri" global box_path "C:\Users\Kateri\Box\NSF Senegal"
if "`c(username)'"=="admmi" global box_path "C:\Users\admmi\Box"

global schoolprincipal "$master\Data Quality Checks\Output\SchoolPrincipal_Issues"  /// Create \SchoolPrincip_Issues
global issues "$master\Data Quality Checks\Full Issues"

global data "$master\Surveys\____" //// Update for Midline

*** Import School Principal Survey Data ***
import delimited 

*** import community survey data ***
import delimited "$data\____", clear varnames(1) bindquote(strict)

*** drop test data ***
drop if strmatch(date, "DATE")

*** label variables ***
label variable consent_obtain "Etes-vous d'accord de participer afin que je puisse poursuivre avec nos questions ?"
label variable consent_notes "Si \"non\", precisez pourquoi ils ont dit NON au consentement"
label variable respondent_is_director "La personne que vous interrogez occupe-t-elle la fonction de directeur/directrice de l'école ?"
label variable respondent_is_not_director "Pourquoi n'êtes-vous pas en mesure d'interviewer le directeur de l'école ?"

label variable respondent_other_role "Qui est la personne que vous interviewez ?"
label variable respondent_other_role_o "Autre a precise"
label variable respondent_name "Nom du répondant"
label variable respondent_phone_primary "Numéro de téléphone principal du répondant"
label variable respondent_phone_secondary "Numéro de téléphone secondaire du répondant"
label variable respondent_gender "Genre"
label variable respondent_age "Quel âge avez-vous ? (en années révolues)"
label variable director_experience_general "Depuis combien de temps travaillez-vous en tant que directeur a n'importe quelle ecole?"
label variable director_experience_specific "Depuis combien de temps travaillez-vous en tant que directeur a cette ecole?"

label variable school_water_main "Quelle est la principale source d'eau de l'école ?"
label variable school_water_main_o "Autre a precise"
label variable school_distance_river "À quelle distance se trouve l'école du point d'accès communautaire le plus proche pour collecter de l'eau de surface (par exemple, rivière, lac ou canal) ?"
label variable school_children_water_collection "L'école envoie-t-elle parfois des enfants à la rivière, au lac ou au canal pour collecter de l'eau de surface ?"
label variable school_water_use "SI OUI, à quoi sert l'eau de surface ?"
label variable school_water_use_o "Autre a precise"
label variable school_reading_french "L'école dispose-t-elle de matériels de lecture en français pour les élèves des classes de 1re à 3e année ?"
label variable school_reading_local "L'école dispose-t-elle de matériels de lecture en [langue locale] pour les élèves des classes de 1re à 3e année ?"
label variable school_computer_access "L'école dispose-t-elle d'équipements informatiques accessibles aux élèves ?"
label variable school_meal_program "L'école dispose-t-elle d'un programme régulier de repas scolaires ?"
label variable school_teachers "Combien d'enseignants travaillent dans l'école ?"
label variable school_staff_paid_non_teaching "Combien de membres du personnel non enseignant rémunérés travaillent régulièrement à l'école ?"
label variable school_staff_volunteers "Combien de bénévoles non rémunérés travaillent régulièrement à l'école (sans inclure les membres du conseil d'école) ?"
label variable school_council "L'école dispose-t-elle d'un conseil d'école ?"
label variable council_school_staff "Combien de membres du personnel de l'école siègent au conseil d'école ?"
label variable council_community_members "Combien de membres de la communauté (qui ne font pas partie du personnel de l'école) siègent au conseil d'école ?"
label variable council_women "Combien de femmes siègent au conseil d'école ?"
label variable council_chief_involvement "Le chef du village siège-t-il au conseil d'école ?"

label variable grade_loop "Combien de niveaux scolaires ont été enseignés à l'école l'année dernière ?"
label variable classroom_loop "Combien de salles de classe y avait-il dans la classe de ${grade} ?"
label variable enrollment_2024_male "Combien d'élèves étaient inscrits dans la classe de ${grade}, salle ${room} qui sont homme?"
label variable enrollment_2024_female "Combien d'élèves étaient inscrits dans la classe de ${grade}, salle ${room}  qui sont femme?"
label variable passing_2024_male "Combien d'élèves ont réussi dans la classe de ${grade}, salle ${room} qui sont homme?"
label variable passing_2024_female "Combien d'élèves ont réussi dans la classe de ${grade}, salle ${room} qui sont femme?"
label variable photo_enrollment_2024 "Prenez une photo du registre des inscriptions pour la classe de ${grade}, salle ${room}."
label variable grade_loop_2025 "Combien de niveaux scolaires sont enseignés à l'école cette année ?"
label variable classroom_loop_2025 "Combien de salles de classe y a-t-il dans la classe de ${grade} ?"
label variable enrollment_2025_male "Combien d'élèves sont inscrits dans la classe de ${grade}, salle ${room} qui sont homme ?"
label variable enrollment_2025_female "Combien d'élèves sont inscrits dans la classe de ${grade}, salle ${room} qui sont femme?"
label variable photo_enrollment_2025 "Prenez une photo du registre des inscriptions pour la classe de ${grade}, salle ${room}."
label variable attendence_regularly "Les enseignants enregistrent-ils la présence des élèves régulièrement ?"

label variable absenteeism_problem "Pensez-vous que l'absentéisme des élèves est un problème dans votre école (parmi les enfants déjà inscrits) ?"
label variable main_absenteeism_reasons "Quelles sont les principales raisons de l'absentéisme des élèves dans votre école ? [Sélectionnez plusieurs réponses]"
label variable absenteeism_top_reason "Parmi celles sélectionnées, laquelle diriez-vous est la raison principale ? [Sélectionnez une réponse]"
label variable schistosomiasis_problem "Pensez-vous que la schistosomiase (bilharziose) est un problème dans votre école parmi les élèves ?"
label variable peak_schistosomiasis_month "Au cours de quel mois les élèves contractent-ils généralement le plus d'infections de schistosomiase (bilharziose) ?"
label variable schistosomiasis_primary_effect "Selon vous, quelle est la principale manière dont la schistosomiase (bilharziose) affecte les élèves ?"
label variable schistosomiasis_sources "Où pensez-vous que les enfants contractent la schistosomiase ?"
label variable schistosomiasis_treatment_ministry "Le ministère de la Santé est-il venu dans votre école en décembre pour administrer des médicaments aux élèves contre la schistosomiase (bilharziose) ?"
label variable schistosomiasis_treatment_date "Quand est-ce que quelqu'un est venu administrer des médicaments aux élèves contre la schistosomiase (bilharziose) pour la dernière fois ?"

*** define value labels ***
label define yesno 1 "Yes" 0 "No"
label define gender 1 "Male" 2 "Female"
label define respondent_position 1 "Deputy Director" 2 "Teacher" 99 "Other, specify"
label define water_source 1 "Piped" 2 "Tubewell" 3 "Well" 4 "Rainwater" 5 "River, Lake, or Canal" 99 "Other, specify"
label define water_use 1 "Drinking" 2 "Cleaning" 3 "Watering plants" 99 "Other, specify"
label define not_director 1 "They are away from work (traveling, sick, etc.)" 2 "Cannot get through to their phone" 3 "There is not currently a school director" 99 "Other, specify"
label define months 1 "January" 2 "February" 3 "March" 4 "April" 5 "May" 6 "June" 7 "July" 8 "August" 9 "September" 10 "October" 11 "November" 12 "December"
label define schisto_impact 1 "Students miss school because they stay home due to the illness" 2 "Students attend school but are unable to learn well because they are sick"
label define schisto_source 1 "River, lake or canal" 2 "Standing water near pump" 3 "Standing water in fields" 4 "Other standing water" 99 "Other, specify"
label define likert_scale 1 "Strongly Disagree" 2 "Disagree" 3 "Neutral" 4 "Agree" 5 "Strongly Agree"
label define absenteeism_reasons 1 "Poor health" 2 "Household chores (not agricultural responsibilities)" 3 "Skipping school" 4 "Inaccessible due to distance or weather" 5 "Agricultural work" 6 "Non-agricultural work" 99 "Other, specify"

*** add value labels to variables ***
label values consent_obtain respondent_is_director school_children_water_collection school_reading_french school_reading_local school_computer_access school_meal_program school_council council_chief_involvement absenteeism_problem schistosomiasis_treatment_ministry yesno
label values respondent_is_director not_director
label values respondent_other_role respondent_position
label values respondent_gender gender
label values school_water_main water_source
label values main_absenteeism_reasons absenteeism_top_reason absenteeism_reasons
label values schistosomiasis_problem likert_scale
label values peak_schistosomiasis_month months
label values schistosomiasis_primary_effect schisto_impact
label values schistosomiasis_sources schisto_source

*** Value Checks ***
*** Drop observations where consent is not provided ***
drop if consent_obtain == 0

* a. Check for missing values in the variables below:
* PROBLEM: first variable NOT being detected - need to run through misstable first 
misstable summarize, generate(missing)

*********************** CHECK THIS LIST AGAINST MISSING VALUES ***********************
*********************** ONLY RUN THOSE WITH MISSING VALUES ***************************
************************ CURRENTLY NONE SO THIS LOOP IS COMMENTED OUT ****************
*foreach var of varlist village_select village_select_o region departement commune village ///
*            sup date arrondissement gps_collectLatitude gps_collectLongitude gps_collectAltitude gps_collectAccuracy description_village consent_obtain respondent_is_director respondent_is_not_director respondent_other_role respondent_name respondent_phone_primary respondent_gender respondent_age director_experience_general director_experience_specific school_water_main school_distance_river school_children_water_collection school_water_use school_reading_french school_reading_local school_computer_access school_meal_program school_teachers school_staff_paid_non_teaching /// school_staff_volunteers school_council council_school_staff council_community_members council_women council_chief_involvement grade_loop classroom_loop enrollment_2024_male enrollment_2024_female passing_2024_male /// passing_2024_female photo_enrollment_2024 grade_loop_2025 classroom_loop_2025 enrollment_2025_male ///  enrollment_2025_female photo_enrollment_2025 attendence_regularly absenteeism_problem main_absenteeism_reasons /// absenteeism_top_reason schistosomiasis_problem peak_schistosomiasis_month schistosomiasis_primary_effect /// schistosomiasis_sources schistosomiasis_treatment_ministry schistosomiasis_treatment_date {
    
*    preserve
    * Keep only observations with missing values for the current variable
*    keep if missing`var' == 1
  
    * Keep relevant variables
 *   keep village_select `var'
  
    * Generate an "issue" variable
*    generate issue = "Missing"
	
	* Generate name of variable issue 
*	gen issue_variable_name = "`var'"
	
	* Rename variable with issue 
*	rename `var' print_issue
  
    * Export the dataset to Excel if there are observations that meet this condition:
*	if _N > 0 {
*    save "$schoolprincipal\Issue_SchoolPrincipal_`var'.dta", replace
*	}
*    restore
*}

********************* SHOULD THIS LOOP BE KEPT? *******************************
*******************************************************************************

*foreach var of varlist village_select village_select_o region departement commune village ///
*            sup date arrondissement gps_collectLatitude gps_collectLongitude gps_collectAltitude gps_collectAccuracy description_village consent_obtain consent_notes respondent_is_director respondent_is_not_director respondent_other_role respondent_name respondent_phone_primary respondent_phone_secondary respondent_gender respondent_age director_experience_general director_experience_specific school_water_main school_distance_river school_children_water_collection school_water_use school_reading_french school_reading_local school_computer_access school_meal_program school_teachers school_staff_paid_non_teaching school_staff_volunteers school_council council_school_staff council_community_members council_women council_chief_involvement grade_loop classroom_loop enrollment_2024_male enrollment_2024_female passing_2024_male passing_2024_female photo_enrollment_2024 grade_loop_2025 classroom_loop_2025 enrollment_2025_male enrollment_2025_female photo_enrollment_2025 attendence_regularly absenteeism_problem main_absenteeism_reasons absenteeism_top_reason schistosomiasis_problem peak_schistosomiasis_month schistosomiasis_primary_effect schistosomiasis_sources schistosomiasis_treatment_ministry schistosomiasis_treatment_date {
    * Check if there are any missing values for the current variable
*    qui count if missing(`var')
*    if r(N) == 0 continue
  
*    preserve
    * Keep only observations with missing values for the current variable
*    keep if missing`var' == 1
  
    * Keep relevant variables
*    keep village_select `var'
  
    * Generate an "issue" variable
*    generate issue = "Missing"
	
	* Generate name of variable issue 
*	gen issue_variable_name = "`var'"
	
  
  	* Rename variable with issue 
*	rename `var' print_issue
	
    * Export the dataset to Excel if there are observations that meet this condition:
*	if _N > 0 {
*    export excel using "$schoolprincipal\Issue_SchoolPrincipal_`var'.dta", firstrow(variables) replace
*	}
*    restore
*}



*** Check if variables with value labels have appropriate values ***

foreach var of varlist consent_obtain respondent_is_director school_children_water_collection school_reading_french school_reading_local school_computer_access school_meal_program school_council council_chief_involvement absenteeism_problem schistosomiasis_treatment_ministry {
    preserve
    gen ind_issue = .
    replace ind_issue = 1 if `var' != 0 & `var' != 1
    keep if ind_issue == 1
    
    * Generate issue variables
    generate issue = "Value out of range (should be 0 or 1)"
    generate issue_variable_name = "`var'"
    rename `var' print_issue
    
    * Export flagged issues
    if _N > 0 {
        save "$schoolprincipal\Issue_SchoolPrincipal_`var'_valuerange.dta", replace
    }
    restore
}

foreach var of varlist respondent_is_director {
    preserve
    gen ind_issue = .
    replace ind_issue = 1 if `var' < 1 | `var' > 3 & `var' != 99
    keep if ind_issue == 1
    
    * Generate issue variables
    generate issue = "Value out of range (1-3 or 99)"
    generate issue_variable_name = "`var'"
    rename `var' print_issue
    
    * Export flagged issues
    if _N > 0 {
        save "$schoolprincipal\Issue_SchoolPrincipal_`var'_valuerange.dta", replace
    }
    restore
}

foreach var of varlist school_water_main schistosomiasis_sources {
    preserve
    gen ind_issue = .
    replace ind_issue = 1 if `var' < 1 | `var' > 5 & `var' != 99
    keep if ind_issue == 1
    
    * Generate issue variables
    generate issue = "Value out of range (1-5 or 99)"
    generate issue_variable_name = "`var'"
    rename `var' print_issue
    
    * Export flagged issues
    if _N > 0 {
        save "$schoolprincipal\Issue_SchoolPrincipal_`var'_valuerange.dta", replace
    }
    restore
}

foreach var of varlist peak_schistosomiasis_month {
    preserve
    gen ind_issue = .
    replace ind_issue = 1 if `var' < 1 | `var' > 12
    keep if ind_issue == 1
    
    * Generate issue variables
    generate issue = "Value out of range (1-12)"
    generate issue_variable_name = "`var'"
    rename `var' print_issue
    
    * Export flagged issues
    if _N > 0 {
        save "$schoolprincipal\Issue_SchoolPrincipal_`var'_valuerange.dta", replace
    }
    restore
}

foreach var of varlist main_absenteeism_reasons absenteeism_top_reason {
    preserve
    gen ind_issue = .
    replace ind_issue = 1 if `var' < 1 | `var' > 6 & `var' != 99
    keep if ind_issue == 1
    
    * Generate issue variables
    generate issue = "Value out of range (1-6 or 99)"
    generate issue_variable_name = "`var'"
    rename `var' print_issue
    
    * Export flagged issues
    if _N > 0 {
        save "$schoolprincipal\Issue_SchoolPrincipal_`var'_valuerange.dta", replace
    }
    restore
}

foreach var of varlist school_teachers school_staff_paid_non_teaching school_staff_volunteers council_school_staff council_community_members council_women enrollment_2024_male enrollment_2024_female enrollment_2025_male enrollment_2025_female passing_2024_male passing_2024_female passing_2025_male passing_2025_female {
    preserve
    gen ind_issue = .
    replace ind_issue = 1 if `var' < 0 & `var' != -9
    keep if ind_issue == 1

    * Generate issue variables
    generate issue = "Invalid value: Negative number other than -9"
    generate issue_variable_name = "`var'"
    rename `var' print_issue

    * Export flagged issues
    if _N > 0 {
        save "$schoolprincipal\Issue_SchoolPrincipal_`var'_negative_check.dta", replace
    }
    restore
}

*** Ensure "I don't know (99)" responses have corresponding text in the "other/specify" variable ***

foreach var of varlist school_water_main respondent_other_role main_absenteeism_reasons schistosomiasis_sources {
    local specify_var = "`var'_o" // Generate the associated "other/specify" variable name

    preserve
    gen ind_issue = .
    replace ind_issue = 1 if `var' == 99 & (missing(`specify_var') | trim(`specify_var') == "")
    keep if ind_issue == 1

    * Generate issue variables
    generate issue = "Invalid response: 'I don't know' (99) requires a corresponding 'other/specify' explanation"
    generate issue_variable_name = "`specify_var'"
    rename `specify_var' print_issue

    * Export flagged issues
    if _N > 0 {
        save "$schoolprincipal\Issue_SchoolPrincipal_`var'_specify_check.dta", replace
    }
    restore
}


*** For numeric variables, ensure values do not exceed the number of students in the school or are valid as -9 ***

foreach var of varlist school_teachers school_staff_paid_non_teaching school_staff_volunteers council_school_staff council_community_members council_women {
    preserve
    gen ind_issue = .
    replace ind_issue = 1 if `var' < -9 | (`var' > (enrollment_2024_male + enrollment_2024_female) & `var' != -9)
    keep if ind_issue == 1
    
    * Generate issue variables
    generate issue = "Invalid value: Exceeds number of students or invalid negative"
    generate issue_variable_name = "`var'"
    rename `var' print_issue
    
    * Export flagged issues
    if _N > 0 {
        save "$schoolprincipal\Issue_SchoolPrincipal_`var'_valuecheck.dta", replace
    }
    restore
}

*** Ensure students passing is not greater than student enrollment ***

foreach var_male of varlist passing_2024_male passing_2025_male {
    local enroll_var_male = subinstr("`var_male'", "passing", "enrollment", .)
    preserve
    gen ind_issue = .
    replace ind_issue = 1 if `var_male' > `enroll_var_male'
    keep if ind_issue == 1

    * Generate issue variables
    generate issue = "Invalid value: Passing exceeds enrollment for males"
    generate issue_variable_name = "`var_male'"
    rename `var_male' print_issue

    * Export flagged issues
    if _N > 0 {
        save "$schoolprincipal\Issue_SchoolPrincipal_`var_male'_exceed_enrollment.dta", replace
    }
    restore
}

foreach var_female of varlist passing_2024_female passing_2025_female {
    local enroll_var_female = subinstr("`var_female'", "passing", "enrollment", .)
    preserve
    gen ind_issue = .
    replace ind_issue = 1 if `var_female' > `enroll_var_female'
    keep if ind_issue == 1

    * Generate issue variables
    generate issue = "Invalid value: Passing exceeds enrollment for females"
    generate issue_variable_name = "`var_female'"
    rename `var_female' print_issue

    * Export flagged issues
    if _N > 0 {
        save "$schoolprincipal\Issue_SchoolPrincipal_`var_female'_exceed_enrollment.dta", replace
    }
    restore
}

*** Ensure director's general experience is greater or equal to specific experience ***

preserve
gen ind_issue = .
replace ind_issue = 1 if director_experience_general < director_experience_specific
keep if ind_issue == 1

* Generate issue variables
generate issue = "Invalid value: General experience less than specific experience"
generate issue_variable_name = "director_experience_general"
rename director_experience_general print_issue

* Export flagged issues
if _N > 0 {
    save "$schoolprincipal\Issue_SchoolPrincipal_director_experience_consistency.dta", replace
}
restore

*** Ensure age is greater than both experience fields and within valid range ***

preserve
gen ind_issue = .
replace ind_issue = 1 if respondent_age < director_experience_general | respondent_age < director_experience_specific | respondent_age < 18 | respondent_age > 120
keep if ind_issue == 1

* Generate issue variables
generate issue = "Invalid value: Age inconsistent with experience or out of range (18-120)"
generate issue_variable_name = "respondent_age"
rename respondent_age print_issue

* Export flagged issues
if _N > 0 {
    save "$schoolprincipal\Issue_SchoolPrincipal_respondent_age_consistency.dta", replace
}
restore


*** c. Validate Skip Patterns ***

* Skip Pattern 1: If `consent_obtain` = 0, `consent_notes` must not be missing
preserve
gen ind_issue = .
replace ind_issue = 1 if consent_obtain == 0 & missing(consent_notes)
keep if ind_issue == 1
generate issue = "Missing 'consent_notes' despite 'consent_obtain' = 0"
generate issue_variable_name = "consent_notes"
rename consent_notes print_issue
if _N > 0 {
    save "$schoolprincipal\Issue_SchoolPrincipal_consent_notes_skip.dta", replace
}
restore

* Skip Pattern 2: If `respondent_is_director` = 2, `respondent_is_not_director` must not be missing
preserve
gen ind_issue = .
replace ind_issue = 1 if respondent_is_director == 2 & missing(respondent_is_not_director)
keep if ind_issue == 1
generate issue = "Missing 'respondent_is_not_director' despite 'respondent_is_director' = 2"
generate issue_variable_name = "respondent_is_not_director"
rename respondent_is_not_director print_issue
if _N > 0 {
    save "$schoolprincipal\Issue_SchoolPrincipal_respondent_skip.dta", replace
}
restore

* Skip Pattern 3: If `school_children_water_collection` = 1, `school_water_use` must not be missing
preserve
gen ind_issue = .
replace ind_issue = 1 if school_children_water_collection == 1 & missing(school_water_use)
keep if ind_issue == 1
generate issue = "Missing 'school_water_use' despite 'school_children_water_collection' = 1"
generate issue_variable_name = "school_water_use"
rename school_water_use print_issue
if _N > 0 {
    save "$schoolprincipal\Issue_SchoolPrincipal_water_use_skip.dta", replace
}
restore

* Skip Pattern 4: If `school_council` = 1, `council_school_staff`, `council_community_members`, `council_women`, and `council_chief_involvement` must not be missing
foreach var of varlist council_school_staff council_community_members council_women council_chief_involvement {
    preserve
    gen ind_issue = .
    replace ind_issue = 1 if school_council == 1 & missing(`var')
    keep if ind_issue == 1
    generate issue = "Missing `var' despite 'school_council' = 1"
    generate issue_variable_name = "`var'"
    rename `var' print_issue
    if _N > 0 {
        save "$schoolprincipal\Issue_SchoolPrincipal_`var'_skip.dta", replace
    }
    restore
}

* Skip Pattern 5: If `absenteeism_problem` = 1, `main_absenteeism_reasons` and `absenteeism_top_reason` must not be missing
preserve
gen ind_issue = .
replace ind_issue = 1 if absenteeism_problem == 1 & (missing(main_absenteeism_reasons) | missing(absenteeism_top_reason))
keep if ind_issue == 1
generate issue = "Missing 'main_absenteeism_reasons' or 'absenteeism_top_reason' despite 'absenteeism_problem' = 1"
generate issue_variable_name = "main_absenteeism_reasons, absenteeism_top_reason"
rename main_absenteeism_reasons print_issue
if _N > 0 {
    save "$schoolprincipal\Issue_SchoolPrincipal_absenteeism_skip.dta", replace
}
restore

* Skip Pattern 6: If `schistosomiasis_problem` = 1, `peak_schistosomiasis_month`, `schistosomiasis_primary_effect`, and `schistosomiasis_sources` must not be missing
foreach var of varlist peak_schistosomiasis_month schistosomiasis_primary_effect schistosomiasis_sources {
    preserve
    gen ind_issue = .
    replace ind_issue = 1 if schistosomiasis_problem == 1 & missing(`var')
    keep if ind_issue == 1
    generate issue = "Missing `var' despite 'schistosomiasis_problem' = 1"
    generate issue_variable_name = "`var'"
    rename `var' print_issue
    if _N > 0 {
        save "$schoolprincipal\Issue_SchoolPrincipal_`var'_skip.dta", replace
    }
    restore
}

**** create one output issue file ***
****************** LOOK IN FOLDER AND SEE WHICH OUTPUT ISSUE FILES THERE ARE *******
****************** INCLUDE ALL NEW FILES IN THE FOLDER BELOW *************

*** Define the folder containing the issue files ***
local issue_folder "$schoolprincipal"

*** Create a list of all issue files in the folder ***
local issue_files: dir `issue_folder' files "Issue_SchoolPrincipal_*.dta"

*** Start combining issue files ***
clear
local first_file = 1

foreach file in `issue_files' {
    use "`issue_folder'/`file'", clear
    if `first_file' == 1 {
        save "`issue_folder'/Combined_SchoolPrincipal_Issues.dta", replace
        local first_file = 0
    }
    else {
        append using "`issue_folder'/Combined_SchoolPrincipal_Issues.dta"
        save "`issue_folder'/Combined_SchoolPrincipal_Issues.dta", replace
    }
}

**************** UPDATE DATE IN FILE NAME ***********************
*export excel using "$issues\Community_Issues_6Feb2024.xlsx", firstrow(variables)  
export excel using "$issues\SchoolPrincipal_Issues_Combined_6Jan2025.xlsx", firstrow(variables) replace
