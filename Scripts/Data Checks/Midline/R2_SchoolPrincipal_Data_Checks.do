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
if "`c(username)'"=="admmi" global box_path "C:\Users\admmi\Box\NSF Senegal"

* Define the master folder path
global master "$box_path\Data Management"

* Define specific paths for output and input data
global schoolprincipal "$master\Output\Data Quality Checks\Midline\R2_Principal_Issues"
global issues "$master\Output\Data Quality Checks\Midline\Full Issues"
global data "$master\_CRDES_RawData\Midline\Principal_Survey_Data"

**************************************************
*** Import school principal survey data ***
**************************************************

import delimited "$data\DISES_Principal_Survey_MIDLINE_VF_WIDE_26Jan.csv", clear varnames(1) bindquote(strict)

*** label variables ***
label variable consent_obtain "Etes-vous d'accord de participer afin que je puisse poursuivre avec nos questions ?" 
label variable consent_notes "Si NON, precisez pourquoi ils ont dit NON au consentement" 
label variable respondent_is_director "La personne que vous interrogez occupe-t-elle la fonction de directeur/directrice de l'école ?"
label variable respondent_is_not_director "Pourquoi n'êtes-vous pas en mesure d'interviewer le directeur de l'école ?"

label variable respondent_other_role "Qui est la personne que vous interviewez ?"
label variable respondent_other_role_o "Autre à préciser"
label variable respondent_name "Nom du répondant"
label variable respondent_phone_primary "Numéro de téléphone principal du répondant"
label variable respondent_phone_secondary "Numéro de téléphone secondaire du répondant"
label variable respondent_gender "Genre"
label variable respondent_age "Quel âge avez-vous ? (en années révolues)"
label variable director_experience_general "Depuis combien de temps travaillez-vous en tant que directeur a n'importe quelle ecole?"
label variable director_experience_specific "Depuis combien de temps travaillez-vous en tant que directeur a cette ecole?"

label variable school_water_main "Quelle est la principale source d'eau de l'école ?"
// label variable school_water_main_o "Autre à préciser" 
label variable school_distance_river "À quelle distance se trouve l'école du point d'accès communautaire le plus proche pour collecter de l'eau de surface (par exemple, rivière, lac ou canal) ?"
label variable school_children_water_collection "L'école envoie-t-elle parfois des enfants à la rivière, au lac ou au canal pour collecter de l'eau de surface ?"
label variable school_water_use "SI OUI, à quoi sert l'eau de surface ?"
// label variable school_water_use_o "Autre à préciser"
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
foreach var of varlist grade_loop* {
    label variable `var' "Combien de niveaux scolaires ont été enseignés à l'école l'année dernière ?"
}
foreach var of varlist classroom_loop* {
    label variable `var' "Combien de salles de classe y avait-il dans la classe de ${grade} ?"
}
foreach var of varlist enrollment_2024_total_*_* {
    label variable `var' "L'année dernière (2023/24), combien d'élèves étaient inscrits dans la classe de ${grade_loop_name}, salle ${classroom_index} <b> qui sont femme </b> ?"
}
foreach var of varlist enrollment_2024_total_*_* {
    label variable `var' "L'année dernière (2023/24), combien d'élèves étaient inscrits dans la classe de ${grade_loop_name}, salle ${classroom_index}, au total ?"
}
foreach var of varlist enrollment_2024_female_*_* {
    label variable `var' "L'année dernière (2023/24), combien d'élèves étaient inscrits dans la classe de ${grade_loop_name}, salle ${classroom_index} <b> qui sont femme </b> ?"
}
foreach var of varlist passing_2024_total_*_* {
    label variable `var' "L'année dernière (2023/24), combien d'élèves ont réussi dans la classe de ${grade_loop_name}, salle ${classroom_index} au <b> total </b> ?"
}
foreach var of varlist passing_2024_female_*_* {
    label variable `var' "L'année dernière (2023/24), combien d'élèves ont réussi dans la classe de ${grade_loop_name}, salle ${classroom_index} <b> qui sont femme </b> ?"
}
foreach var of varlist photo_enrollment_2024_*_* {
    label variable `var' "L'année dernière (2023/24), prenez une photo du registre des inscriptions pour la classe de ${grade_loop_name}, salle ${classroom_index}."
}
foreach var of varlist enrollment_2025_total_*_* {
    label variable `var' "Cette année (2024/25), combien d'élèves sont inscrits dans la classe de ${grade_loop_name_2025}, salle ${classroom_index_2025} au total ?"
}
foreach var of varlist enrollment_2025_female_*_* {
    label variable `var' "Cette année (2024/25), combien d'élèves sont inscrits dans la classe de ${grade_loop_name_2025}, salle ${classroom_index_2025} <b> qui sont femme </b> ?"
}

foreach var of varlist photo_enrollment_2025_*_* {
    label variable `var' "Cette année (2024/25), prenez une photo du registre des inscriptions pour la classe de ${grade_loop_name_2025}, salle ${classroom_index_2025}."
}
foreach var of varlist attendence_regularly_*_* {
    label variable `var' "Cette année (2024/25), les enseignants enregistrent-ils la présence des élèves régulièrement ?"
}
label variable absenteeism_problem "Pensez-vous que l'absentéisme des élèves est un problème dans votre école (parmi les enfants déjà inscrits) ?"
label variable main_absenteeism_reasons "Quelles sont les principales raisons de l'absentéisme des élèves dans votre école ? [Sélectionnez plusieurs réponses]"
label variable absenteeism_top_reason "Parmi celles sélectionnées, laquelle diriez-vous est la raison principale ? [Sélectionnez une réponse]"
label variable schistosomiasis_problem "Pensez-vous que la schistosomiase (bilharziose) est un problème dans votre école parmi les élèves ?"
label variable peak_schistosomiasis_month "Au cours de quel mois les élèves contractent-ils généralement le plus d'infections de schistosomiase (bilharziose) ?"
label variable schistosomiasis_primary_effect "Selon vous, quelle est la principale manière dont la schistosomiase (bilharziose) affecte les élèves ?"
foreach var of varlist schistosomiasis_sources_* {
    label variable `var' "Où pensez-vous que les enfants contractent la schistosomiase ?"
}
label variable schistosomiasis_treatment_minist "Le ministère de la Santé est-il venu dans votre école en décembre pour administrer des médicaments aux élèves contre la schistosomiase (bilharziose) ?"
label variable schistosomiasis_treatment_date "Quand est-ce que quelqu'un est venu administrer des médicaments aux élèves contre la schistosomiase (bilharziose) pour la dernière fois ?"

*** define value labels ***
label define yesno 1 "Oui" 0 "Non"
label define gender 1 "Homme" 2 "Femme"
label define respondent_position 1 "Directeur adjoint" 2 "Enseignant" 99 "Autre, précisez"
label define water_source 1 "Tuyau" 2 "Forage tubulaire" 3 "Puits" 4 "Eau de pluie" 5 "Rivière, lac ou canal" 99 "Autre, précisez"
label define water_use 1 "Boire" 2 "Nettoyage" 3 "Arrosage des plantes" 99 "Autre, précisez"
label define not_director 1 "Ils sont absents du travail (en voyage, malades, etc.)" 2 "Impossible de les joindre par téléphone" 3 "Il n'y a pas de directeur d'école actuellement" 99 "Autre, précisez"
label define months 1 "Janvier" 2 "Février" 3 "Mars" 4 "Avril" 5 "Mai" 6 "Juin" 7 "Juillet" 8 "Août" 9 "Septembre" 10 "Octobre" 11 "Novembre" 12 "Décembre"
label define schisto_impact 1 "Les élèves manquent l'école parce qu'ils restent à la maison en raison de la maladie" 2 "Les élèves vont à l'école mais ne peuvent pas bien apprendre parce qu'ils sont malades"
label define schisto_source 1 "Rivière, lac ou canal" 2 "Eau stagnante près de la pompe" 3 "Eau stagnante dans les champs" 4 "Autre eau stagnante" 99 "Autre, précisez"
label define likert_scale 1 "Pas du tout d'accord" 2 "Pas d'accord" 3 "Neutre" 4 "D'accord" 5 "Tout à fait d'accord"
label define absenteeism_reasons 1 "Mauvaise santé" 2 "Tâches ménagères (non liées à l'agriculture)" 3 "Absence à l'école" 4 "Inaccessible en raison de la distance ou des conditions météorologiques" 5 "Travaux agricoles" 6 "Travaux non agricoles" 99 "Autre, précisez"

*** add value labels to variables ***
label values consent_obtain respondent_is_director school_children_water_collection school_reading_french school_reading_local school_computer_access school_meal_program school_council council_chief_involvement  schistosomiasis_treatment_minist yesno
label values respondent_is_not_director not_director
label values respondent_other_role respondent_position
label values respondent_gender gender
label values school_water_main water_source
// label values main_absenteeism_reasons absenteeism_top_reason absenteeism_reasons
label values schistosomiasis_problem absenteeism_problem likert_scale
label values peak_schistosomiasis_month months
label values schistosomiasis_primary_effect schisto_impact
label values schistosomiasis_sources_* schisto_source

*** Value Checks ***
*** Drop observations where consent is not provided ***
drop if consent_obtain == 0

**************************************************
*** STEP 1: CHECK FOR MISSING VALUES ***
**************************************************

misstable summarize, generate(missing_)

* List of required variables
local required_vars village_select sup consent_obtain respondent_is_director ///
    geo_locaccuracy geo_localtitude geo_loclatitude geo_loclongitude ///
    respondent_name respondent_phone_primary respondent_gender respondent_age ///
    school_water_main ///
    school_distance_river school_children_water_collection ///
    school_reading_french school_reading_local school_computer_access ///
    school_meal_program school_teachers school_staff_paid_non_teaching ///
    school_staff_volunteers school_council ///
    absenteeism_problem main_absenteeism_reasons absenteeism_top_reason ///
    schistosomiasis_problem peak_schistosomiasis_month ///
    schistosomiasis_primary_effect schistosomiasis_sources ///
    schistosomiasis_treatment_minist schistosomiasis_treatment_date ///

* Loop through each variable and check for missing values
foreach var of local required_vars {
    preserve
    gen ind_issue = .
    replace ind_issue = 1 if missing(`var')
    keep if ind_issue == 1
    generate issue = "Missing value detected"
    generate issue_variable_name = "`var'"
    rename `var' print_issue

    * Export flagged data if there are missing values
    if _N > 0 {
        save "$schoolprincipal\Issue_SchoolPrincipal_`var'_missing.dta", replace
    }
    restore
}

**************************************************
*** STEP 2: CHECK FOR APPROPRIATE VALUES ***
**************************************************

* Check binary variables (0/1)

foreach var of varlist consent_obtain respondent_is_director school_children_water_collection school_reading_french school_reading_local school_computer_access school_meal_program school_council schistosomiasis_treatment_minist {
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

**************************************************
*** CONSENT ***
**************************************************

* 2.1 Check for consent (must be obtained for survey to proceed)
preserve
gen ind_issue = .
replace ind_issue = 1 if consent_obtain == 0
keep if ind_issue == 1
generate issue = "Consent not obtained; survey should end"
generate issue_variable_name = "consent_obtain"
rename consent_obtain print_issue

* Export flagged data if consent not obtained
if _N > 0 {
    save "$schoolprincipal\Issue_SchoolPrincipal_ConsentNotObtained.dta", replace
}
restore

* 2.2 Check if "consent_notes" is completed when "consent_obtain" is 0
preserve
gen ind_issue = .
replace ind_issue = 1 if consent_obtain == 0 & missing(consent_notes)
keep if ind_issue == 1
generate issue = "Missing reason for lack of consent"
generate issue_variable_name = "consent_notes"
rename consent_notes print_issue

* Export flagged data
if _N > 0 {
    save "$schoolprincipal\Issue_SchoolPrincipal_ConsentNotesMissing.dta", replace
}
restore

* 2.3 Check if "respondent_is_not_director" is provided when "respondent_is_director" is 0
preserve
gen ind_issue = .
replace ind_issue = 1 if respondent_is_director == 0 & missing(respondent_is_not_director)
keep if ind_issue == 1
generate issue = "Missing reason for not interviewing school director"
generate issue_variable_name = "respondent_is_not_director"
rename respondent_is_not_director print_issue

* Export flagged data
if _N > 0 {
    save "$schoolprincipal\Issue_SchoolPrincipal_NotDirectorReasonMissing.dta", replace
}
restore

* 2.4 Check if "respondent_other_role_o" is completed when "respondent_other_role" = 99 (Other)
preserve
gen ind_issue = .
replace ind_issue = 1 if respondent_other_role == 99 & missing(respondent_other_role_o)
keep if ind_issue == 1
generate issue = "Missing specification for 'Other' role of respondent"
generate issue_variable_name = "respondent_other_role_o"
rename respondent_other_role_o print_issue

* Export flagged data
if _N > 0 {
    save "$schoolprincipal\Issue_SchoolPrincipal_OtherRoleMissing.dta", replace
}
restore

* 1. Ensure GPS coordinates are collected
preserve
gen ind_issue = .
replace ind_issue = 1 if missing(geo_locaccuracy) | missing(geo_loclatitude) | missing(geo_loclongitude)
keep if ind_issue == 1
generate issue = "Missing GPS coordinates"
generate issue_variable_name = "geo_locaccuracy/geo_loclatitude/geo_loclongitude"
rename geo_locaccuracy print_issue

* Export flagged data if GPS coordinates are missing
if _N > 0 {
    save "$schoolprincipal\Issue_SchoolPrincipal_MissingGPSCoordinates.dta", replace
}
restore

* 2. Ensure date is recorded
preserve
gen ind_issue = .
replace ind_issue = 1 if missing(date)
keep if ind_issue == 1
generate issue = "Date not recorded"
generate issue_variable_name = "date"
rename date print_issue

* Export flagged data if date is missing
if _N > 0 {
    save "$schoolprincipal\Issue_SchoolPrincipal_MissingDate.dta", replace
}
restore

* 3. Ensure time is recorded
preserve
gen ind_issue = .
replace ind_issue = 1 if missing(time)
keep if ind_issue == 1
generate issue = "Time not recorded"
generate issue_variable_name = "time"
rename time print_issue

* Export flagged data if time is missing
if _N > 0 {
    save "$schoolprincipal\Issue_SchoolPrincipal_MissingTime.dta", replace
}
restore

**************************************************
*** RESPONDENT DETAILS SECTION CHECKS ***
**************************************************

* 1. Check if "respondent_other_role_o" is completed when "respondent_other_role" = 99 (Other)
preserve
gen ind_issue = .
replace ind_issue = 1 if respondent_other_role == 99 & missing(respondent_other_role_o)
keep if ind_issue == 1
generate issue = "Missing specification for 'Other' role of respondent"
generate issue_variable_name = "respondent_other_role_o"
rename respondent_other_role_o print_issue

* Export flagged data
if _N > 0 {
    save "$schoolprincipal\Issue_SchoolPrincipal_OtherRoleMissing.dta", replace
}
restore

* 2. Check if "respondent_name" is missing
preserve
gen ind_issue = .
replace ind_issue = 1 if missing(respondent_name)
keep if ind_issue == 1
generate issue = "Respondent's full name is missing"
generate issue_variable_name = "respondent_name"
rename respondent_name print_issue

* Export flagged data
if _N > 0 {
    save "$schoolprincipal\Issue_SchoolPrincipal_NameMissing.dta", replace
}
restore

* 3. Check if "respondent_phone_primary" is missing
preserve
gen ind_issue = .
replace ind_issue = 1 if missing(respondent_phone_primary)
keep if ind_issue == 1
generate issue = "Primary contact number of respondent is missing"
generate issue_variable_name = "respondent_phone_primary"
rename respondent_phone_primary print_issue

* Export flagged data
if _N > 0 {
    save "$schoolprincipal\Issue_SchoolPrincipal_PrimaryPhoneMissing.dta", replace
}
restore

* 4. Check if "respondent_gender" is missing
preserve
gen ind_issue = .
replace ind_issue = 1 if missing(respondent_gender)
keep if ind_issue == 1
generate issue = "Respondent's gender is missing"
generate issue_variable_name = "respondent_gender"
rename respondent_gender print_issue

* Export flagged data
if _N > 0 {
    save "$schoolprincipal\Issue_SchoolPrincipal_GenderMissing.dta", replace
}
restore

* 5. Check if "respondent_age" is missing
preserve
gen ind_issue = .
replace ind_issue = 1 if missing(respondent_age)
keep if ind_issue == 1
generate issue = "Respondent's age is missing"
generate issue_variable_name = "respondent_age"
rename respondent_age print_issue

* Export flagged data
if _N > 0 {
    save "$schoolprincipal\Issue_SchoolPrincipal_AgeMissing.dta", replace
}
restore

* 6. Check if "director_experience_general" is missing when "respondent_is_director" = 1
preserve
gen ind_issue = .
replace ind_issue = 1 if respondent_is_director == 1 & missing(director_experience_general)
keep if ind_issue == 1
generate issue = "Missing general experience as director when respondent is a director"
generate issue_variable_name = "director_experience_general"
rename director_experience_general print_issue

* Export flagged data
if _N > 0 {
    save "$schoolprincipal\Issue_SchoolPrincipal_GeneralExperienceMissing.dta", replace
}
restore

* 7. Check if "director_experience_specific" is missing when "respondent_is_director" = 1
preserve
gen ind_issue = .
replace ind_issue = 1 if respondent_is_director == 1 & missing(director_experience_specific)
keep if ind_issue == 1
generate issue = "Missing specific experience at this school when respondent is a director"
generate issue_variable_name = "director_experience_specific"
rename director_experience_specific print_issue

* Export flagged data
if _N > 0 {
    save "$schoolprincipal\Issue_SchoolPrincipal_SpecificExperienceMissing.dta", replace
}
restore

* 8. Check if "director_experience_specific" exceeds "director_experience_general"
preserve
gen ind_issue = .
replace ind_issue = 1 if respondent_is_director == 1 & director_experience_specific > director_experience_general
keep if ind_issue == 1
generate issue = "Specific experience exceeds general experience for director"
generate issue_variable_name = "director_experience_specific"
rename director_experience_specific print_issue

* Export flagged data
if _N > 0 {
    save "$schoolprincipal\Issue_SchoolPrincipal_SpecificExperienceExceedsGeneral.dta", replace
}
restore



**************************************************
*** SCHOOL FACILITIES SECTION CHECKS ***
**************************************************

* 1. Check if "school_water_main" is missing
preserve
gen ind_issue = .
replace ind_issue = 1 if missing(school_water_main)
keep if ind_issue == 1
generate issue = "Missing main source of water for the school"
generate issue_variable_name = "school_water_main"
rename school_water_main print_issue

* Export flagged data
if _N > 0 {
    save "$schoolprincipal\Issue_SchoolFacilities_WaterMainMissing.dta", replace
}
restore

* 2. Check if "school_distance_river" is missing
preserve
gen ind_issue = .
replace ind_issue = 1 if missing(school_distance_river)
keep if ind_issue == 1
generate issue = "Missing distance from school to nearest water access point"
generate issue_variable_name = "school_distance_river"
rename school_distance_river print_issue

* Export flagged data
if _N > 0 {
    save "$schoolprincipal\Issue_SchoolFacilities_DistanceRiverMissing.dta", replace
}
restore

* 3. Check if "school_children_water_collection" is missing
preserve
gen ind_issue = .
replace ind_issue = 1 if missing(school_children_water_collection)
keep if ind_issue == 1
generate issue = "Missing indicator for school sending children to collect water"
generate issue_variable_name = "school_children_water_collection"
rename school_children_water_collection print_issue

* Export flagged data
if _N > 0 {
    save "$schoolprincipal\Issue_SchoolFacilities_ChildrenWaterCollectionMissing.dta", replace
}
restore

* 4. Check if "school_water_use" is completed when "school_children_water_collection" = 1
preserve
gen ind_issue = .
replace ind_issue = 1 if school_children_water_collection == 1 & missing(school_water_use)
keep if ind_issue == 1
generate issue = "Missing use of water collected by children"
generate issue_variable_name = "school_water_use"
rename school_water_use print_issue

* Export flagged data
if _N > 0 {
    save "$schoolprincipal\Issue_SchoolFacilities_WaterUseMissing.dta", replace
}
restore

* 5. Check for missing yes/no variables: reading materials, computer access, meal program, council presence
foreach var in school_reading_french school_reading_local school_computer_access school_meal_program school_council {
    preserve
    gen ind_issue = .
    replace ind_issue = 1 if missing(`var')
    keep if ind_issue == 1
    generate issue = "Missing value for `var'"
    generate issue_variable_name = "`var'"
    rename `var' print_issue
    
    * Export flagged data
    if _N > 0 {
        save "$schoolprincipal\Issue_SchoolFacilities_`var'Missing.dta", replace
    }
    restore
}

* 6. Check if "school_teachers" is missing
preserve
gen ind_issue = .
replace ind_issue = 1 if missing(school_teachers)
keep if ind_issue == 1
generate issue = "Missing number of teachers at the school"
generate issue_variable_name = "school_teachers"
rename school_teachers print_issue

* Export flagged data
if _N > 0 {
    save "$schoolprincipal\Issue_SchoolFacilities_TeachersMissing.dta", replace
}
restore

* 7. Check if "school_staff_paid_non_teaching" is missing
preserve
gen ind_issue = .
replace ind_issue = 1 if missing(school_staff_paid_non_teaching)
keep if ind_issue == 1
generate issue = "Missing number of paid non-teaching staff"
generate issue_variable_name = "school_staff_paid_non_teaching"
rename school_staff_paid_non_teaching print_issue

* Export flagged data
if _N > 0 {
    save "$schoolprincipal\Issue_SchoolFacilities_PaidStaffMissing.dta", replace
}
restore

* 8. Check if "school_staff_volunteers" is missing
preserve
gen ind_issue = .
replace ind_issue = 1 if missing(school_staff_volunteers)
keep if ind_issue == 1
generate issue = "Missing number of unpaid volunteers"
generate issue_variable_name = "school_staff_volunteers"
rename school_staff_volunteers print_issue

* Export flagged data
if _N > 0 {
    save "$schoolprincipal\Issue_SchoolFacilities_VolunteersMissing.dta", replace
}
restore

* 9. Check council-related variables when "school_council" = 1
foreach var in council_school_staff council_community_members council_women council_chief_involvement {
    preserve
    gen ind_issue = .
    replace ind_issue = 1 if school_council == 1 & missing(`var')
    keep if ind_issue == 1
    generate issue = "Missing value for `var' when school council exists"
    generate issue_variable_name = "`var'"
    rename `var' print_issue

    * Export flagged data
    if _N > 0 {
        save "$schoolprincipal\Issue_SchoolFacilities_`var'Missing.dta", replace
    }
    restore
}

* 10. Check if "council_women" does not exceed total members
preserve
gen ind_issue = .
replace ind_issue = 1 if school_council == 1 & council_women > council_school_staff + council_community_members
keep if ind_issue == 1
generate issue = "Number of women in council exceeds total council members"
generate issue_variable_name = "council_women"
rename council_women print_issue

* Export flagged data
if _N > 0 {
    save "$schoolprincipal\Issue_SchoolFacilities_WomenCountExceedsTotal.dta", replace
}
restore

**************************************************
*** STUDENT ENROLLMENT SECTION CHECKS ***
**************************************************
* Check if grade_loop variables are missing
foreach var in grade_loop grade_loop_1 grade_loop_2 grade_loop_3 grade_loop_4 grade_loop_5 grade_loop_6 {
    preserve
    gen ind_issue = .
    replace ind_issue = 1 if missing(`var')
    keep if ind_issue == 1
    generate issue = "Missing grade loop variable"
    generate issue_variable_name = "`var'"
    rename `var' print_issue

    * Export flagged data
    if _N > 0 {
        save "$schoolprincipal\Issue_StudentEnrollment_GradeLoopMissing_`var'.dta", replace
    }
    restore
}

* Check if classroom counts are missing or invalid
foreach var in classroom_count_1 classroom_count_2 classroom_count_3 classroom_count_4 classroom_count_5 classroom_count_6 {
    preserve
    gen ind_issue = .
    replace ind_issue = 1 if missing(`var') | `var' < 0
    keep if ind_issue == 1
    generate issue = "Missing or invalid classroom count"
    generate issue_variable_name = "`var'"
    rename `var' print_issue

    * Export flagged data
    if _N > 0 {
        save "$schoolprincipal\Issue_StudentEnrollment_ClassroomCountInvalid_`var'.dta", replace
    }
    restore
}

* Check enrollment and passing totals, considering zero classroom/grade counts
foreach grade in 1 2 3 4 5 6 {
    local classroom_count_var = "classroom_count_`grade'"
    local grade_loop_var = "grade_loop_`grade'"

    preserve
    * Skip if both classroom count and grade loop are zero
    drop if (`classroom_count_var' == 0 & `grade_loop_var' == 0)

    foreach class in 1 2 {
        preserve
        * Check classroom count to ensure valid range for this grade/class combination
        keep if `class' <= `classroom_count_var' // Only keep observations where classroom count permits this class

        * Skip checks for classes beyond the declared classroom count
        if _N == 0 {
            restore
            continue
        }

        * Check enrollment_2024_total
        gen ind_issue = .
        replace ind_issue = 1 if missing(enrollment_2024_total_`grade'_`class') & `classroom_count_var' > 0
        keep if ind_issue == 1
        generate issue = "Missing or invalid enrollment total"
        generate issue_variable_name = "enrollment_2024_total_`grade'_`class'"
        rename enrollment_2024_total_`grade'_`class' print_issue

        * Export flagged data
        if _N > 0 {
            save "$schoolprincipal\Issue_StudentEnrollment_EnrollmentTotalInvalid_G`grade'_C`class'.dta", replace
        }
        restore

        * Check enrollment_2024_female
        preserve
        gen ind_issue = .
        replace ind_issue = 1 if missing(enrollment_2024_female_`grade'_`class') & `classroom_count_var' > 0
        replace ind_issue = 1 if enrollment_2024_female_`grade'_`class' < 0 | enrollment_2024_female_`grade'_`class' > enrollment_2024_total_`grade'_`class'
        keep if ind_issue == 1
        generate issue = "Missing or invalid female enrollment count"
        generate issue_variable_name = "enrollment_2024_female_`grade'_`class'"
        rename enrollment_2024_female_`grade'_`class' print_issue

        * Export flagged data
        if _N > 0 {
            save "$schoolprincipal\Issue_StudentEnrollment_EnrollmentFemaleInvalid_G`grade'_C`class'.dta", replace
        }
        restore

        * Check passing_2024_total
        preserve
        gen ind_issue = .
        replace ind_issue = 1 if missing(passing_2024_total_`grade'_`class') & `classroom_count_var' > 0
        replace ind_issue = 1 if passing_2024_total_`grade'_`class' < 0 | passing_2024_total_`grade'_`class' > enrollment_2024_total_`grade'_`class'
        keep if ind_issue == 1
        generate issue = "Missing or invalid passing total"
        generate issue_variable_name = "passing_2024_total_`grade'_`class'"
        rename passing_2024_total_`grade'_`class' print_issue

        * Export flagged data
        if _N > 0 {
            save "$schoolprincipal\Issue_StudentEnrollment_PassingTotalInvalid_G`grade'_C`class'.dta", replace
        }
        restore

* Check passing_2024_female
foreach grade in 1 2 3 4 5 6 {
    local classroom_count_var = "classroom_count_`grade'"
    foreach class in 1 2 {
        preserve
        gen ind_issue = .
        replace ind_issue = 1 if missing(passing_2024_female_`grade'_`class') & `classroom_count_var' > 0
        replace ind_issue = 1 if passing_2024_female_`grade'_`class' < 0 | passing_2024_female_`grade'_`class' > passing_2024_total_`grade'_`class' | passing_2024_female_`grade'_`class' > enrollment_2024_female_`grade'_`class'
        keep if ind_issue == 1
        if _N > 0 {
            generate issue = "Missing or invalid female passing count"
            generate issue_variable_name = "passing_2024_female_`grade'_`class'"
            rename passing_2024_female_`grade'_`class' print_issue

            * Export flagged data
            save "$schoolprincipal\Issue_StudentEnrollment_PassingFemaleInvalid_G`grade'_C`class'.dta", replace
        }
        restore
    }
}



**************************************************
*** SCHISTOSOMIASIS SECTION CHECKS ***
**************************************************

* 1. Check for missing or invalid values in absenteeism_problem
preserve
gen ind_issue = .
replace ind_issue = 1 if missing(absenteeism_problem) | absenteeism_problem < 1 | absenteeism_problem > 5
keep if ind_issue == 1
generate issue = "Missing or invalid response for absenteeism problem"
generate issue_variable_name = "absenteeism_problem"
rename absenteeism_problem print_issue

* Export flagged data
if _N > 0 {
    save "$schoolprincipal\Issue_Schistosomiasis_AbsenteeismProblemInvalid.dta", replace
}
restore

* 2. Check for missing values in main_absenteeism_reasons
preserve
gen ind_issue = .
replace ind_issue = 1 if missing(main_absenteeism_reasons)
keep if ind_issue == 1
generate issue = "Missing main reasons for absenteeism"
generate issue_variable_name = "main_absenteeism_reasons"
rename main_absenteeism_reasons print_issue

* Export flagged data
if _N > 0 {
    save "$schoolprincipal\Issue_Schistosomiasis_MainAbsenteeismReasonsMissing.dta", replace
}
restore

* 3. Check for missing or invalid values in absenteeism_top_reason
preserve
gen ind_issue = .
replace ind_issue = 1 if missing(absenteeism_top_reason) | absenteeism_top_reason < 1 | absenteeism_top_reason > 99
keep if ind_issue == 1
generate issue = "Missing or invalid top reason for absenteeism"
generate issue_variable_name = "absenteeism_top_reason"
rename absenteeism_top_reason print_issue

* Export flagged data
if _N > 0 {
    save "$schoolprincipal\Issue_Schistosomiasis_AbsenteeismTopReasonInvalid.dta", replace
}
restore

* 4. Check for missing or invalid values in schistosomiasis_problem
preserve
gen ind_issue = .
replace ind_issue = 1 if missing(schistosomiasis_problem) | schistosomiasis_problem < 1 | schistosomiasis_problem > 5
keep if ind_issue == 1
generate issue = "Missing or invalid response for schistosomiasis problem"
generate issue_variable_name = "schistosomiasis_problem"
rename schistosomiasis_problem print_issue

* Export flagged data
if _N > 0 {
    save "$schoolprincipal\Issue_Schistosomiasis_ProblemInvalid.dta", replace
}
restore

* 5. Check for missing or invalid values in peak_schistosomiasis_month
preserve
gen ind_issue = .
replace ind_issue = 1 if missing(peak_schistosomiasis_month) | peak_schistosomiasis_month < 1 | peak_schistosomiasis_month > 12
keep if ind_issue == 1
generate issue = "Missing or invalid peak schistosomiasis month"
generate issue_variable_name = "peak_schistosomiasis_month"
rename peak_schistosomiasis_month print_issue

* Export flagged data
if _N > 0 {
    save "$schoolprincipal\Issue_Schistosomiasis_PeakMonthInvalid.dta", replace
}
restore

* 6. Check for missing or invalid values in schistosomiasis_primary_effect
preserve
gen ind_issue = .
replace ind_issue = 1 if missing(schistosomiasis_primary_effect) | schistosomiasis_primary_effect < 1 | schistosomiasis_primary_effect > 2
keep if ind_issue == 1
generate issue = "Missing or invalid primary effect of schistosomiasis"
generate issue_variable_name = "schistosomiasis_primary_effect"
rename schistosomiasis_primary_effect print_issue

* Export flagged data
if _N > 0 {
    save "$schoolprincipal\Issue_Schistosomiasis_PrimaryEffectInvalid.dta", replace
}
restore

* 7. Check for missing values in schistosomiasis_sources
preserve
gen ind_issue = .
replace ind_issue = 1 if missing(schistosomiasis_sources)
keep if ind_issue == 1
generate issue = "Missing sources of schistosomiasis"
generate issue_variable_name = "schistosomiasis_sources"
rename schistosomiasis_sources print_issue

* Export flagged data
if _N > 0 {
    save "$schoolprincipal\Issue_Schistosomiasis_SourcesMissing.dta", replace
}
restore

* 8. Check for missing or invalid values in schistosomiasis_treatment_ministry
preserve
gen ind_issue = .
replace ind_issue = 1 if missing(schistosomiasis_treatment_minist) | (schistosomiasis_treatment_minist != 0 & schistosomiasis_treatment_minist != 1)
keep if ind_issue == 1
generate issue = "Missing or invalid Ministry of Health treatment indicator"
generate issue_variable_name = "schistosomiasis_treatment_ministry"
rename schistosomiasis_treatment_minist print_issue

* Export flagged data
if _N > 0 {
    save "$schoolprincipal\Issue_Schistosomiasis_TreatmentMinistryInvalid.dta", replace
}
restore

* 9. Check for missing values in schistosomiasis_treatment_date
preserve
gen ind_issue = .
replace ind_issue = 1 if missing(schistosomiasis_treatment_date)
keep if ind_issue == 1
generate issue = "Missing treatment date for schistosomiasis"
generate issue_variable_name = "schistosomiasis_treatment_date"
rename schistosomiasis_treatment_date print_issue

* Export flagged data
if _N > 0 {
    save "$schoolprincipal\Issue_Schistosomiasis_TreatmentDateMissing.dta", replace
}
restore

**************************************************
*** VERIFICATION PRESENCE SCOLAIRE CHECKS ***
**************************************************

* 1. Check if school_repeat_count matches hh_size_load
preserve
gen ind_issue = .
replace ind_issue = 1 if school_repeat_count != hh_size_load
keep if ind_issue == 1
generate issue = "Mismatch between school_repeat_count and hh_size_load"
generate issue_variable_name = "school_repeat_count, hh_size_load"

* Export flagged data
if _N > 0 {
    save "$schoolprincipal\Issue_SchoolRepeat_vs_HHSizeLoad.dta", replace
}
restore

* 2. Check that required data is recorded for all fu_mem_id iterations
preserve
gen ind_issue = .
gen ind_missing = .
forval i = 1/`=school_repeat_count' {
    gen check_`i' = !missing(pull_fu_mem_id_`i') & !missing(pull_hh_full_name_calc__`i')
    replace ind_missing = 1 if check_`i' == 0
}
replace ind_issue = 1 if ind_missing == 1
keep if ind_issue == 1
generate issue = "Missing required data for fu_mem_id iteration"
generate issue_variable_name = "fu_mem_id_`i', pull_hh_full_name_calc__`i'"

* Export flagged data
if _N > 0 {
    save "$schoolprincipal\Issue_FuMemID_RequiredDataMissing.dta", replace
}
restore

* 3. Check for logical inconsistencies (unenrolled student being present or having a grade)
preserve
gen ind_issue = .
gen ind_inconsistent = 0

forval i = 1/`=school_repeat_count' {
    gen unenrolled_`i' = (info_eleve_2_`i' == 0)   // Check if student is unenrolled
    gen present_`i' = (info_eleve_7_`i' == 1)      // Check if student is present
    gen grade_assigned_`i' = !missing(info_eleve_3_`i') // Check if grade is assigned

    * Logical inconsistency checks
    replace ind_inconsistent = 1 if unenrolled_`i' & present_`i'
    replace ind_inconsistent = 1 if unenrolled_`i' & grade_assigned_`i'
}

replace ind_issue = 1 if ind_inconsistent == 1
keep if ind_issue == 1
generate issue = "Logical inconsistency: Unenrolled student marked as present or has a grade"
generate issue_variable_name = "info_eleve_2_`i', info_eleve_7_`i', info_eleve_3_`i'"

* Export flagged data
if _N > 0 {
    save "$schoolprincipal\Issue_LogicalInconsistencies.dta", replace
}
restore

    * Identify cases where grade_loop_X is 1 but classroom_count_X is 0 or missing
    replace ind_issue = 1 if grade_loop_`grade' == 1 & (classroom_count_`grade' == 0 | missing(classroom_count_`grade'))
    
    * Keep only problematic cases
    keep if ind_issue == 1
    
    * Generate issue description
    generate issue = "Inconsistency: grade_loop_`grade' is 1 but classroom_count_`grade' is 0 or missing"
    generate issue_variable_name = "grade_loop_`grade', classroom_count_`grade'"
    
    * Display issues for debugging
    list grade_loop_`grade' classroom_count_`grade' if ind_issue == 1

    * Export flagged data if issues found
    if _N > 0 {
        save "$schoolprincipal/Issue_GradeLoop_ClassroomCount_Mismatch_G`grade'.dta", replace
    }
    restore
}

**************************************************
*** END OF CHECKS ***
**************************************************

**** Create one output issue file ***

****************** LOOK IN FOLDER AND SEE WHICH OUTPUT ISSUE FILES THERE ARE *******
****************** INCLUDE ALL NEW FILES IN THE FOLDER BELOW *************

* Start with the first issue file
use "$schoolprincipal\Issue_Community_number_hh.dta", clear 

* Append all relevant issue files
local issue_files "Issue_GradeLoop_ClassroomCount_Mismatch_G1.dta Issue_GradeLoop_ClassroomCount_Mismatch_G2.dta Issue_GradeLoop_ClassroomCount_Mismatch_G3.dta Issue_GradeLoop_ClassroomCount_Mismatch_G4.dta Issue_GradeLoop_ClassroomCount_Mismatch_G5.dta Issue_GradeLoop_ClassroomCount_Mismatch_G6.dta"

foreach file in `issue_files' {
    capture append using "$schoolprincipal\`file'"
}

**************** UPDATE DATE IN FILE NAME ***********************

* Export to Excel
export excel using "$schoolprincipal\SchoolPrincipal_Issues_28Jan2025.xlsx", firstrow(variables) replace  
