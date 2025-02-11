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
if "`c(username)'"=="socrm" global box_path "C:\Users\socrm\Box\NSF Senegal"
if "`c(username)'"=="kls329" global box_path "C:\Users\kls329\Box\NSF Senegal"
if "`c(username)'"=="km978" global box_path "C:\Users\km978\Box\NSF Senegal"
if "`c(username)'"=="Kateri" global box_path "C:\Users\Kateri\Box\NSF Senegal"
if "`c(username)'"=="admmi" global box_path "C:\Users\admmi\Box\NSF Senegal"

* Define the master folder path
global master "$box_path\Data_Management"

* Define specific paths for output and input data
global schoolprincipal "$master\Output\Data_Quality_Checks\Midline\Midline_Principal_Issues"
global issues "$master\Output\Data_Quality_Checks\Midline\Full_Issues"
global data "$master\_CRDES_RawData\Midline\Principal_Survey_Data"

**************************************************
*** Import school principal survey data ***
**************************************************

import delimited "$data\DISES_Principal_Survey_MIDLINE_VF_WIDE_7Feb.csv", clear varnames(1) bindquote(strict)

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

misstable summarize, generate(missing_)

**************************************************
*** STEP 2: CHECK FOR APPROPRIATE VALUES ***
**************************************************

* Check binary variables (0/1)

foreach var of varlist consent_obtain respondent_is_director school_children_water_collection school_reading_french school_reading_local school_computer_access school_meal_program school_council schistosomiasis_treatment_minist {
    preserve
    gen ind_issue = .
    replace ind_issue = 1 if `var' != 0 & `var' != 1
    keep if ind_issue == 1
	keep hhid_village sup_name respondent_name respondent_phone_primary `var' key
    
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
*** CONSENT CHECKS ***
**************************************************

* 2.1 Check for consent (must be obtained for survey to proceed)
preserve
gen ind_issue = .
replace ind_issue = 1 if consent_obtain == 0
keep if ind_issue == 1
	keep hhid_village sup_name respondent_name respondent_phone_primary consent_obtain key

generate issue = "Consent not obtained; survey should end"
generate issue_variable_name = "consent_obtain"
rename consent_obtain print_issue

if _N > 0 {
    save "$schoolprincipal\Issue_SchoolPrincipal_ConsentNotObtained.dta", replace
}
restore

* 2.2 Check if "consent_notes" is completed when "consent_obtain" is 0
preserve
gen ind_issue = .
replace ind_issue = 1 if consent_obtain == 0 & missing(consent_notes)
keep if ind_issue == 1
	keep hhid_village sup_name respondent_name respondent_phone_primary consent_obtain consent_notes key

generate issue = "Missing reason for lack of consent"
generate issue_variable_name = "consent_notes"
rename consent_notes print_issue


if _N > 0 {
    save "$schoolprincipal\Issue_SchoolPrincipal_ConsentNotesMissing.dta", replace
}
restore

**************************************************
*** RESPONDENT ROLE CHECKS ***
**************************************************

* 2.3 Check if "respondent_is_not_director" is provided when "respondent_is_director" is 0
preserve
gen ind_issue = .
replace ind_issue = 1 if respondent_is_director == 0 & missing(respondent_is_not_director)
keep if ind_issue == 1
	keep hhid_village sup_name respondent_name respondent_phone_primary respondent_is_director respondent_is_not_director key

generate issue = "Missing reason for not interviewing school director"
generate issue_variable_name = "respondent_is_not_director"
rename respondent_is_not_director print_issue


if _N > 0 {
    save "$schoolprincipal\Issue_SchoolPrincipal_NotDirectorReasonMissing.dta", replace
}
restore

* 2.4 Check if "respondent_other_role_o" is completed when "respondent_other_role" = 99 (Other)
preserve
gen ind_issue = .
replace ind_issue = 1 if respondent_other_role == 99 & missing(respondent_other_role_o)
keep if ind_issue == 1
* Retain key metadata fields before exporting
keep hhid_village sup_name respondent_name respondent_phone_primary respondent_other_role respondent_other_role_o key

generate issue = "Missing specification for 'Other' role of respondent"
generate issue_variable_name = "respondent_other_role_o"
rename respondent_other_role_o print_issue



if _N > 0 {
    save "$schoolprincipal\Issue_SchoolPrincipal_OtherRoleMissing.dta", replace
}
restore

**************************************************
*** CHECKS FOR GPS, DATE, AND TIME ***
**************************************************

* 1. Ensure GPS coordinates are collected
preserve
gen ind_issue = .
replace ind_issue = 1 if missing(geo_locaccuracy) | missing(geo_loclatitude) | missing(geo_loclongitude)
keep if ind_issue == 1
* Retain key metadata fields before exporting
keep hhid_village sup_name respondent_name respondent_phone_primary geo_locaccuracy geo_loclatitude geo_loclongitude key
generate issue = "Missing GPS coordinates"
generate issue_variable_name = "geo_locaccuracy/geo_loclatitude/geo_loclongitude"
rename geo_locaccuracy print_issue



if _N > 0 {
    save "$schoolprincipal\Issue_SchoolPrincipal_MissingGPSCoordinates.dta", replace
}
restore

* 2. Ensure date is recorded
preserve
gen ind_issue = .
replace ind_issue = 1 if missing(date)
keep if ind_issue == 1
* Retain key metadata fields before exporting
keep hhid_village sup_name respondent_name respondent_phone_primary date

generate issue = "Date not recorded"
generate issue_variable_name = "date"
rename date print_issue


if _N > 0 {
    save "$schoolprincipal\Issue_SchoolPrincipal_MissingDate.dta", replace
}
restore

* 3. Ensure time is recorded
preserve
gen ind_issue = .
replace ind_issue = 1 if missing(time)
keep if ind_issue == 1
* Retain key metadata fields before exporting
keep hhid_village sup_name respondent_name respondent_phone_primary time key

generate issue = "Time not recorded"
generate issue_variable_name = "time"
rename time print_issue


if _N > 0 {
    save "$schoolprincipal\Issue_SchoolPrincipal_MissingTime.dta", replace
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
keep hhid_village sup_name respondent_name respondent_phone_primary school_water_main key
generate issue = "Missing main source of water for the school"
generate issue_variable_name = "school_water_main"
rename school_water_main print_issue


if _N > 0 {
    save "$schoolprincipal\Issue_SchoolFacilities_WaterMainMissing.dta", replace
}
restore

* 2. Check if "school_distance_river" is missing
preserve
gen ind_issue = .
replace ind_issue = 1 if missing(school_distance_river) | school_distance_river == 0
keep if ind_issue == 1
keep hhid_village sup_name respondent_name respondent_phone_primary school_distance_river key

generate issue = "Missing or invalid distance from school to nearest water access point"
generate issue_variable_name = "school_distance_river"
rename school_distance_river print_issue


if _N > 0 {
    save "$schoolprincipal\Issue_SchoolFacilities_DistanceRiverMissing.dta", replace
}
restore

* 3. Check if "school_children_water_collection" is missing
preserve
gen ind_issue = .
replace ind_issue = 1 if missing(school_children_water_collection)
keep if ind_issue == 1
keep hhid_village sup_name respondent_name respondent_phone_primary school_children_water_collection key

generate issue = "Missing indicator for school sending children to collect water"
generate issue_variable_name = "school_children_water_collection"
rename school_children_water_collection print_issue



if _N > 0 {
    save "$schoolprincipal\Issue_SchoolFacilities_ChildrenWaterCollectionMissing.dta", replace
}
restore

* 4. Check if "school_water_use" is completed when "school_children_water_collection" = 1
preserve
gen ind_issue = .
replace ind_issue = 1 if school_children_water_collection == 1 & missing(school_water_use)
keep if ind_issue == 1
keep hhid_village sup_name respondent_name respondent_phone_primary school_children_water_collection school_water_use key
generate issue = "Missing use of water collected by children"
generate issue_variable_name = "school_water_use"
rename school_water_use print_issue



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
    keep hhid_village sup_name respondent_name respondent_phone_primary `var' key
    generate issue = "Missing value for `var'"
    generate issue_variable_name = "`var'"
    rename `var' print_issue



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
keep hhid_village sup_name respondent_name respondent_phone_primary school_teachers key
generate issue = "Missing number of teachers at the school"
generate issue_variable_name = "school_teachers"
rename school_teachers print_issue



if _N > 0 {
    save "$schoolprincipal\Issue_SchoolFacilities_TeachersMissing.dta", replace
}
restore

* 7. Check if "council_women" does not exceed total members
preserve
gen ind_issue = .
replace ind_issue = 1 if school_council == 1 & council_women > council_school_staff + council_community_members
keep if ind_issue == 1
keep hhid_village sup_name respondent_name respondent_phone_primary school_council council_women council_school_staff council_community_members key
generate issue = "Number of women in council exceeds total council members"
generate issue_variable_name = "council_women"
rename council_women print_issue



if _N > 0 {
    save "$schoolprincipal\Issue_SchoolFacilities_WomenCountExceedsTotal.dta", replace
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
keep hhid_village sup_name respondent_name respondent_phone_primary school_water_main key
generate issue = "Missing main source of water for the school"
generate issue_variable_name = "school_water_main"
rename school_water_main print_issue



if _N > 0 {
    save "$schoolprincipal\Issue_SchoolFacilities_WaterMainMissing.dta", replace
}
restore

* 2. Check if "school_distance_river" is missing or invalid (<= 0)
preserve
gen ind_issue = .
replace ind_issue = 1 if missing(school_distance_river) | school_distance_river <= 0
keep if ind_issue == 1
keep hhid_village sup_name respondent_name respondent_phone_primary school_distance_river key

generate issue = "Missing or invalid distance from school to nearest water access point"
generate issue_variable_name = "school_distance_river"
rename school_distance_river print_issue



if _N > 0 {
    save "$schoolprincipal\Issue_SchoolFacilities_DistanceRiverMissing.dta", replace
}
restore

* 3. Check if "school_children_water_collection" is missing
preserve
gen ind_issue = .
replace ind_issue = 1 if missing(school_children_water_collection)
keep if ind_issue == 1
keep hhid_village sup_name respondent_name respondent_phone_primary school_children_water_collection key

generate issue = "Missing indicator for school sending children to collect water"
generate issue_variable_name = "school_children_water_collection"
rename school_children_water_collection print_issue


if _N > 0 {
    save "$schoolprincipal\Issue_SchoolFacilities_ChildrenWaterCollectionMissing.dta", replace
}
restore

* 4. Check if "school_water_use" is missing when "school_children_water_collection" = 1
preserve
gen ind_issue = .
replace ind_issue = 1 if school_children_water_collection == 1 & missing(school_water_use)
keep if ind_issue == 1
keep hhid_village sup_name respondent_name respondent_phone_primary school_children_water_collection school_water_use key
generate issue = "Missing use of water collected by children"
generate issue_variable_name = "school_water_use"
rename school_water_use print_issue



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
    keep hhid_village sup_name respondent_name respondent_phone_primary `var' key
    generate issue = "Missing value for `var'"
    generate issue_variable_name = "`var'"
    rename `var' print_issue



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
keep hhid_village sup_name respondent_name respondent_phone_primary school_teachers key
generate issue = "Missing number of teachers at the school"
generate issue_variable_name = "school_teachers"
rename school_teachers print_issue



if _N > 0 {
    save "$schoolprincipal\Issue_SchoolFacilities_TeachersMissing.dta", replace
}
restore

* 7. Check if "school_staff_paid_non_teaching" is missing
preserve
gen ind_issue = .
replace ind_issue = 1 if missing(school_staff_paid_non_teaching)
keep if ind_issue == 1
keep hhid_village sup_name respondent_name respondent_phone_primary school_staff_paid_non_teaching key
generate issue = "Missing number of paid non-teaching staff"
generate issue_variable_name = "school_staff_paid_non_teaching"
rename school_staff_paid_non_teaching print_issue



if _N > 0 {
    save "$schoolprincipal\Issue_SchoolFacilities_PaidStaffMissing.dta", replace
}
restore

* 8. Check if "school_staff_volunteers" is missing
preserve
gen ind_issue = .
replace ind_issue = 1 if missing(school_staff_volunteers)
keep if ind_issue == 1
keep hhid_village sup_name respondent_name respondent_phone_primary school_staff_volunteers key
generate issue = "Missing number of unpaid volunteers"
generate issue_variable_name = "school_staff_volunteers"
rename school_staff_volunteers print_issue



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
    keep hhid_village sup_name respondent_name respondent_phone_primary `var' key
    generate issue = "Missing value for `var' when school council exists"
    generate issue_variable_name = "`var'"
    rename `var' print_issue



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
keep hhid_village sup_name respondent_name respondent_phone_primary council_women key
generate issue = "Number of women in council exceeds total council members"
generate issue_variable_name = "council_women"
rename council_women print_issue



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
	keep hhid_village sup_name respondent_name respondent_phone_primary `var' key
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
	keep hhid_village sup_name respondent_name respondent_phone_primary `var' key
    generate issue = "Missing or invalid classroom count"
    generate issue_variable_name = "`var'"
    rename `var' print_issue

    * Export flagged data
    if _N > 0 {
        save "$schoolprincipal\Issue_StudentEnrollment_ClassroomCountInvalid_`var'.dta", replace
    }
    restore
}

**************************************************
*** CHECK GRADE LOOP AND CLASSROOM COUNT CONSISTENCY ***
**************************************************

foreach grade in 1 2 3 4 5 6 {
    local grade_loop_var "grade_loop_`grade'"
    local classroom_count_var "classroom_count_`grade'"

    * Check if grade_loop requires a positive classroom count
    preserve
    gen ind_issue = .
    replace ind_issue = 1 if `grade_loop_var' == `grade' & `classroom_count_var' < `grade'
    keep if ind_issue == 1
	keep hhid_village sup_name respondent_name respondent_phone_primary `classroom_count_var' key
    generate issue = "Classroom count does not match required grade level"
    generate issue_variable_name = "`classroom_count_var'"
    rename `classroom_count_var' print_issue

    * Export flagged data
    if _N > 0 {
        save "$schoolprincipal\Issue_StudentEnrollment_GradeLoop_ClassroomMismatch_G`grade'.dta", replace
    }
    restore
}

**************************************************
*** CHECK ENROLLMENT TOTAL BASED ON CLASSROOM COUNT ***
**************************************************

foreach grade in 1 2 3 4 5 6 {
    local classroom_count_var "classroom_count_`grade'"

    foreach class in 1 2 {
        preserve
        * Check if total enrollment is valid when a classroom exists
        gen ind_issue = .
        replace ind_issue = 1 if `classroom_count_var' >= `class' & missing(enrollment_2024_total_`grade'_`class')
        replace ind_issue = 1 if `classroom_count_var' >= `class' & enrollment_2024_total_`grade'_`class' <= 0
        keep if ind_issue == 1
		keep hhid_village sup_name respondent_name respondent_phone_primary enrollment_2024_total_`grade'_`class' key
        generate issue = "Invalid or missing enrollment total"
        generate issue_variable_name = "enrollment_2024_total_`grade'_`class'"
        rename enrollment_2024_total_`grade'_`class' print_issue

        * Export flagged data
        if _N > 0 {
            save "$schoolprincipal\Issue_StudentEnrollment_EnrollmentTotalInvalid_G`grade'_C`class'.dta", replace
        }
        restore
    }
}

**************************************************
*** CHECK FEMALE ENROLLMENT BASED ON CLASSROOM COUNT ***
**************************************************

foreach grade in 1 2 3 4 5 6 {
    local classroom_count_var "classroom_count_`grade'"

    foreach class in 1 2 {
        preserve
        * Ensure female enrollment exists and is within total enrollment bounds
        gen ind_issue = .
        replace ind_issue = 1 if `classroom_count_var' >= `class' & missing(enrollment_2024_female_`grade'_`class')
        replace ind_issue = 1 if `classroom_count_var' >= `class' & enrollment_2024_female_`grade'_`class' > enrollment_2024_total_`grade'_`class'
        keep if ind_issue == 1
		keep hhid_village sup_name respondent_name respondent_phone_primary enrollment_2024_female_`grade'_`class' key
        generate issue = "Invalid or missing female enrollment"
        generate issue_variable_name = "enrollment_2024_female_`grade'_`class'"
        rename enrollment_2024_female_`grade'_`class' print_issue

        * Export flagged data
        if _N > 0 {
            save "$schoolprincipal\Issue_StudentEnrollment_EnrollmentFemaleInvalid_G`grade'_C`class'.dta", replace
        }
        restore
    }
}

**************************************************
*** CHECK PASSING TOTAL BASED ON ENROLLMENT ***
**************************************************

foreach grade in 1 2 3 4 5 6 {
    local classroom_count_var "classroom_count_`grade'"

    foreach class in 1 2 {
        preserve
        * Ensure passing total is within enrollment limits
        gen ind_issue = .
        replace ind_issue = 1 if `classroom_count_var' >= `class' & missing(passing_2024_total_`grade'_`class')
        replace ind_issue = 1 if `classroom_count_var' >= `class' & passing_2024_total_`grade'_`class' < 0
        replace ind_issue = 1 if `classroom_count_var' >= `class' & passing_2024_total_`grade'_`class' > enrollment_2024_total_`grade'_`class'
        keep if ind_issue == 1
		keep hhid_village sup_name respondent_name respondent_phone_primary passing_2024_total_`grade'_`class' key
        generate issue = "Invalid or missing passing total"
        generate issue_variable_name = "passing_2024_total_`grade'_`class'"
        rename passing_2024_total_`grade'_`class' print_issue

        * Export flagged data
        if _N > 0 {
            save "$schoolprincipal\Issue_StudentEnrollment_PassingTotalInvalid_G`grade'_C`class'.dta", replace
        }
        restore
    }
}

**************************************************
*** CHECK FEMALE PASSING TOTAL BASED ON FEMALE ENROLLMENT ***
**************************************************

foreach grade in 1 2 3 4 5 6 {
    local classroom_count_var "classroom_count_`grade'"

    foreach class in 1 2 {
        preserve
        * Ensure female passing total is within valid enrollment range
        gen ind_issue = .
        replace ind_issue = 1 if `classroom_count_var' >= `class' & missing(passing_2024_female_`grade'_`class')
        replace ind_issue = 1 if `classroom_count_var' >= `class' & passing_2024_female_`grade'_`class' < 0
        replace ind_issue = 1 if `classroom_count_var' >= `class' & passing_2024_female_`grade'_`class' > passing_2024_total_`grade'_`class'
        replace ind_issue = 1 if `classroom_count_var' >= `class' & passing_2024_female_`grade'_`class' > enrollment_2024_female_`grade'_`class'
        keep if ind_issue == 1
		keep hhid_village sup_name respondent_name respondent_phone_primary passing_2024_female_`grade'_`class' key
        generate issue = "Invalid or missing female passing count"
        generate issue_variable_name = "passing_2024_female_`grade'_`class'"
        rename passing_2024_female_`grade'_`class' print_issue

        * Export flagged data
        if _N > 0 {
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
keep hhid_village sup_name respondent_name respondent_phone_primary absenteeism_problem key
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
keep hhid_village sup_name respondent_name respondent_phone_primary main_absenteeism_reasons key
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
keep hhid_village sup_name respondent_name respondent_phone_primary absenteeism_top_reason key
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
keep hhid_village sup_name respondent_name respondent_phone_primary schistosomiasis_problem key
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
keep hhid_village sup_name respondent_name respondent_phone_primary peak_schistosomiasis_month key
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
keep hhid_village sup_name respondent_name respondent_phone_primary schistosomiasis_primary_effect key
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
keep hhid_village sup_name respondent_name respondent_phone_primary schistosomiasis_sources key
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
keep hhid_village sup_name respondent_name respondent_phone_primary schistosomiasis_treatment_minist key
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
keep hhid_village sup_name respondent_name respondent_phone_primary schistosomiasis_treatment_date key
generate issue = "Missing treatment date for schistosomiasis"
generate issue_variable_name = "schistosomiasis_treatment_date"
rename schistosomiasis_treatment_date print_issue

* Export flagged data
if _N > 0 {
    save "$schoolprincipal\Issue_Schistosomiasis_TreatmentDateMissing.dta", replace
}
restore

foreach grade in 1 2 3 4 5 6 {
    preserve
    gen ind_issue = .
    
    * Ensure grade_loop_X is properly accounted for classroom_count_X
    replace ind_issue = 1 if grade_loop_`grade' > 0 & (missing(classroom_count_`grade') | classroom_count_`grade' == 0)
    
    * Keep only problematic cases
    keep if ind_issue == 1
    keep hhid_village sup_name respondent_name respondent_phone_primary classroom_count_`grade' key
    
    * Generate issue description
    generate issue = "Mismatch: grade_loop_`grade' exists but classroom_count_`grade' is missing or zero"
    generate issue_variable_name = "grade_loop_`grade', classroom_count_`grade'"
    
    * Rename for clarity
    rename classroom_count_`grade' print_issue
    
    * Export flagged data if issues found
    if _N > 0 {
        save "$schoolprincipal\Issue_GradeLoop_ClassroomCountMismatch_G`grade'.dta", replace
    }
    restore
}



preserve
gen ind_issue = .
replace ind_issue = 1 if missing(school_name)

* Keep only problematic cases
keep if ind_issue == 1
keep hhid_village sup_name respondent_name respondent_phone_primary school_name key

* Generate issue description
generate issue = "School name is missing"
generate issue_variable_name = "school_name"
drop school_name 
gen print_issue = 0  // Rename for clarity

* Export flagged data if issues found
if _N > 0 {
    save "$schoolprincipal\Issue_SchoolFacilities_SchoolNameMissing.dta", replace
}
restore

**************************************************
*** END OF CHECKS ***
**************************************************

**** Create one output issue file ***

****************** LOOK IN FOLDER AND SEE WHICH OUTPUT ISSUE FILES THERE ARE *******
****************** INCLUDE ALL NEW FILES IN THE FOLDER BELOW *************

* Start with the first issue file

** KRM - use loop below to append faster if you would like !

/*
	clear
	local folder "$schoolprincipal"  

	cd "`folder'"
	local files: dir . files "*.dta"

	foreach file in `files' {
		di "Appending `file'"
		append using "`file'"
	}


	save "$income\Schoolprincipal_Issues.dta", replace // keep record of all the issues for each cleaning to filter
*/



use "C:\Users\admmi\Box\NSF Senegal\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Principal_Issues\Issue_GradeLoop_ClassroomCountMismatch_G1.dta", clear
append using "C:\Users\admmi\Box\NSF Senegal\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Principal_Issues\Issue_GradeLoop_ClassroomCountMismatch_G2.dta"
append using "C:\Users\admmi\Box\NSF Senegal\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Principal_Issues\Issue_GradeLoop_ClassroomCountMismatch_G3.dta"
append using "C:\Users\admmi\Box\NSF Senegal\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Principal_Issues\Issue_GradeLoop_ClassroomCountMismatch_G4.dta"
append using "C:\Users\admmi\Box\NSF Senegal\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Principal_Issues\Issue_GradeLoop_ClassroomCountMismatch_G5.dta"
append using "C:\Users\admmi\Box\NSF Senegal\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Principal_Issues\Issue_GradeLoop_ClassroomCountMismatch_G6.dta"
append using "C:\Users\admmi\Box\NSF Senegal\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Principal_Issues\Issue_SchoolFacilities_DistanceRiverMissing.dta"
append using "C:\Users\admmi\Box\NSF Senegal\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Principal_Issues\Issue_SchoolFacilities_SchoolNameMissing.dta"
append using "C:\Users\admmi\Box\NSF Senegal\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Principal_Issues\Issue_StudentEnrollment_EnrollmentTotalInvalid_G6_C1.dta"
append using "C:\Users\admmi\Box\NSF Senegal\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Principal_Issues\Issue_StudentEnrollment_GradeLoop_ClassroomMismatch_G1.dta"
append using "C:\Users\admmi\Box\NSF Senegal\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Principal_Issues\Issue_StudentEnrollment_PassingFemaleInvalid_G1_C1.dta"
append using "C:\Users\admmi\Box\NSF Senegal\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Principal_Issues\Issue_StudentEnrollment_PassingFemaleInvalid_G1_C2.dta"
append using "C:\Users\admmi\Box\NSF Senegal\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Principal_Issues\Issue_StudentEnrollment_PassingFemaleInvalid_G2_C1.dta"
append using "C:\Users\admmi\Box\NSF Senegal\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Principal_Issues\Issue_StudentEnrollment_PassingFemaleInvalid_G2_C2.dta"
append using "C:\Users\admmi\Box\NSF Senegal\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Principal_Issues\Issue_StudentEnrollment_PassingFemaleInvalid_G3_C1.dta"
append using "C:\Users\admmi\Box\NSF Senegal\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Principal_Issues\Issue_StudentEnrollment_PassingFemaleInvalid_G3_C2.dta"
append using "C:\Users\admmi\Box\NSF Senegal\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Principal_Issues\Issue_StudentEnrollment_PassingFemaleInvalid_G4_C1.dta"
append using "C:\Users\admmi\Box\NSF Senegal\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Principal_Issues\Issue_StudentEnrollment_PassingFemaleInvalid_G4_C2.dta"
append using "C:\Users\admmi\Box\NSF Senegal\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Principal_Issues\Issue_StudentEnrollment_PassingFemaleInvalid_G5_C1.dta"
append using "C:\Users\admmi\Box\NSF Senegal\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Principal_Issues\Issue_StudentEnrollment_PassingFemaleInvalid_G5_C2.dta"
append using "C:\Users\admmi\Box\NSF Senegal\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Principal_Issues\Issue_StudentEnrollment_PassingFemaleInvalid_G6_C1.dta"
append using "C:\Users\admmi\Box\NSF Senegal\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Principal_Issues\Issue_StudentEnrollment_PassingFemaleInvalid_G6_C2.dta"
append using "C:\Users\admmi\Box\NSF Senegal\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Principal_Issues\Issue_StudentEnrollment_PassingTotalInvalid_G1_C1.dta"
append using "C:\Users\admmi\Box\NSF Senegal\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Principal_Issues\Issue_StudentEnrollment_PassingTotalInvalid_G1_C2.dta"
append using "C:\Users\admmi\Box\NSF Senegal\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Principal_Issues\Issue_StudentEnrollment_PassingTotalInvalid_G2_C1.dta"
append using "C:\Users\admmi\Box\NSF Senegal\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Principal_Issues\Issue_StudentEnrollment_PassingTotalInvalid_G2_C2.dta"
append using "C:\Users\admmi\Box\NSF Senegal\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Principal_Issues\Issue_StudentEnrollment_PassingTotalInvalid_G3_C1.dta"
append using "C:\Users\admmi\Box\NSF Senegal\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Principal_Issues\Issue_StudentEnrollment_PassingTotalInvalid_G3_C2.dta"
append using "C:\Users\admmi\Box\NSF Senegal\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Principal_Issues\Issue_StudentEnrollment_PassingTotalInvalid_G4_C1.dta"
append using "C:\Users\admmi\Box\NSF Senegal\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Principal_Issues\Issue_StudentEnrollment_PassingTotalInvalid_G4_C2.dta"
append using "C:\Users\admmi\Box\NSF Senegal\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Principal_Issues\Issue_StudentEnrollment_PassingTotalInvalid_G5_C1.dta"
append using "C:\Users\admmi\Box\NSF Senegal\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Principal_Issues\Issue_StudentEnrollment_PassingTotalInvalid_G5_C2.dta"
append using "C:\Users\admmi\Box\NSF Senegal\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Principal_Issues\Issue_StudentEnrollment_PassingTotalInvalid_G6_C1.dta"
append using "C:\Users\admmi\Box\NSF Senegal\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Principal_Issues\Issue_StudentEnrollment_PassingTotalInvalid_G6_C2.dta"
**************** UPDATE DATE IN FILE NAME ***********************

* Export to Excel
export excel using "$schoolprincipal\SchoolPrincipal_Issues_7Feb2025.xlsx", firstrow(variables) replace  

