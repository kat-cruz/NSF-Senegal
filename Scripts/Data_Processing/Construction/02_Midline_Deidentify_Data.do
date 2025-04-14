**** DISES midline data de-identify and split data for analysis *** 
*** File Created By: Molly Doruska ***
*** File Adapted By: Alex Mills ***
*** File Updates Tracked on Git ***

clear all 

set maxvar 20000

**** Master file path  ****
if "`c(username)'"=="socrm" global master "C:\Users\socrm\Box"
if "`c(username)'"=="kls329" global master "C:\Users\kls329\Box"
if "`c(username)'"=="km978" global master "C:\Users\km978\Box\NSF Senegal"
if "`c(username)'"=="Kateri" global master "C:\Users\Kateri\Box\NSF Senegal"
if "`c(username)'"=="admmi" global master "C:\Users\admmi\Box\NSF Senegal"


*** additional file paths ***
global data "$master\Data_Management\Output\Data_Processing\Checks\Corrections\Midline"
global data_raw "$master\Data_Management\Data\_CRDES_RawData\Midline"
global hhids "$master\Data_Management\Output\ID_Creation"
global data_deidentified "$master\Data_Management\Data\_CRDES_CleanData\Midline\Deidentified"
global data_identified "$master\Data_Management\Data\_CRDES_CleanData\Midline\Identified"

*** import complete data for geographic and preliminary information ***
use "$data_identified\DISES_Midline_Complete_PII", clear 

*** keep only household roster data *** 
keep hhid submissiondate starttime endtime duration today village_select village_select_o region departement commune grappe schoolmosqueclinic grappe_int sup enqu hh_arrondissement

*** put household id first in dataset *** 
order hhid, first 

*** save original geography data ***
save "$data_deidentified\Complete_Midline_Geographies", replace

*** import complete data for geographic and preliminary information ***
use "$data_identified\DISES_Midline_Complete_PII", clear 

*** drop identifiying and empty variables *** 
*** keep only household roster data *** 
keep start_hh_composition _household_roster_count hh* end_hh_composition

drop hh_phone hh_head_name_complet hh_name_complet_resp hh_region hh_department hh_commune hh_district hh_arrondissement hh_village hh_gpslatitude hh_gpslongitude hh_gpsaltitude hh_gpsaccuracy

drop hh_name_* hh_first_name_* hh_surname_* hh_full_name_calc_* hh_name_complet_resp_new hh_head_name_complet_label hh_name_complet_resp_id hh_scoohlname_*

*** put household id first in dataset *** 
order hhid, first 

*** save roster data ***
save "$data_deidentified\Complete_Midline_Household_Roster", replace

*** for knowledge dataset
use "$data_identified\DISES_Midline_Complete_PII", clear 

*** keep only knoweldge data *** 
keep hhid start_knowledge knowledge_* end_knowledge 

*** put household id first in dataset *** 
order hhid, first 

*** save knowledge data ***
save "$data_deidentified\Complete_Midline_Knowledge", replace 

*** import complete health data *** 
use "$data_identified\DISES_Midline_Complete_PII", clear 

*** keep only health data *** 
keep hhid start_health_status _health_roster_count healthindex* healthage* healthgenre* health_5* end_health_status 

*** put household id first in dataset *** 
order hhid, first 

*** save health data ***
save "$data_deidentified\Complete_Midline_Health", replace 

*** import complete agriculture data *** 
use "$data_identified\DISES_Midline_Complete_PII", clear 

*** keep only agriculture and assets data *** 
keep hhid start_actif list_actifs* _actifs_roster_count actifs* _actif_number* actifs_o actifs_o_int list_agri_equip* _agri_roster_count agriindex* agriname* _agri_number* list_agri_equip_o list_agri_equip_o_t list_agri_equip_int agri_6* _parcelle_roster_count parcelleindex* end_actif 

*** put household id first in dataset *** 
order hhid, first 

*** save agriculture data ***
save "$data_deidentified\Complete_Midline_Agriculture", replace

*** import complete production data *** 
use "$data_identified\DISES_Midline_Complete_PII", clear 

*** keep only production data *** 
keep hhid start_crops _cereals_roster_count cerealsposition* cerealsname* cereals_consumption* cereals_* _farine_tubercules_roster_count farine* legumes* legumineuses* aquatique* autre_culture_yesno autre_culture o_culture* end_crops 

*** put household id first in dataset *** 
order hhid, first 

*** save production data ***
save "$data_deidentified\Complete_Midline_Production", replace 

*** import complete lean season data *** 
use "$data_identified\DISES_Midline_Complete_PII", clear 

*** keep only ean season data *** 
keep hhid start_food food* end_food

*** put household id first in dataset *** 
order hhid, first 

*** save lean season data ***
save "$data_deidentified\Complete_Midline_Lean_Season", replace 

*** import copmlete income data
use "$data_identified\DISES_Midline_Complete_PII", clear 

*** keep only income data *** 
keep hhid start_income agri_income* species* _species_roster_count animals_sales* _animals_sales_roster_count sale_animales* credit_roster_count credit_askindex* restant_pret* agri_loan* loan_roster_count loanindex* product_divers* _production_roster_count productindex* productname* expenses_goods* _agriculture_goods_roster_count goodsindex* goodsname* end_income 

*** put household id first in dataset *** 
order hhid, first 

*** save income data ***
save "$data_deidentified\Complete_Midline_Income", replace 

*** import copmlete income data
use "$data_identified\DISES_Midline_Complete_PII", clear 

*** keep only standard of living data *** 
keep hhid start_living living* end_living 

*** put household id first in dataset *** 
order hhid, first 

*** save standard of living data ***
save "$data_deidentified\Complete_Midline_Standard_Of_Living", replace 

*** import complete beliefs data
use "$data_identified\DISES_Midline_Complete_PII", clear 

*** keep only knoweldge data *** 
keep hhid start_beliefs beliefs* end_beliefs 

*** put household id first in dataset *** 
order hhid, first 

*** save beliefs data ***
save "$data_deidentified\Complete_Midline_Beliefs", replace 

*** import complete public goods data
use "$data_identified\DISES_Midline_Complete_PII", clear 

*** no game at midline
/*
*** keep only public goods game data *** 
keep hhid start_game game_intro game_01 game_02 consent_game_1 montant_02 game_03 montant_05 montant_07 montant_08 face_01 face_02 face_04 face_06 face_07 face_09 face_10 face_11 face_13 end_game  

*** put household id first in dataset *** 
order hhid, first 

*** save public goods game data ***
save "$data_deidentified\Complete_Midline_Public_Goods_Game", replace 
*/

*** import copmlete enumerator data
use "$data_identified\DISES_Midline_Complete_PII", clear 

*** keep only knoweldge data *** 
keep hhid start_enumerator enum_* end_enumerator

*** put household id first in dataset *** 
order hhid, first 

*** save enumerator data ***
save "$data_deidentified\Complete_Midline_Enumerator_Observations", replace 

*** import copmlete community data
use "$data_identified\DISES_Complete_Midline_Community", clear 

*** drop identifying data *** 
drop full_name phone_resp full_name phone_resp pull_hh_full_name_calc__* pull_hh_head_name_complet_* pull_hh_name_complet_resp_* pull_hh_phone_* new_household_*

drop deviceid devicephonenum username device_info caseid record_text gps* description_village instanceid formdef_version key village pull* fu_*

*** save community data *** 
save "$data_deidentified\Complete_Midline_Community", replace 

*** import complete school principal data
use "$data_identified\DISES_Complete_Midline_SchoolPrincipal", clear 

keep hhid_village grappe schoolmosqueclinic grappe_int sup consent_obtain consent_notes respondent_is_director respondent_is_not_director respondent_is_not_director_o start_survey date time respondent_other_role respondent_other_role_o respondent_gender respondent_age director_experience_general director_experience_specific school_water_main school_water_main_o school_distance_river school_children_water_collection school_water_use* school_water_use_o school_reading_french school_reading_local school_computer_access school_meal_program school_teachers school_staff_paid_non_teaching school_staff_volunteers school_council council_school_staff council_community_members council_women council_chief_involvement grade_loop* classroom_count* enrollment_* passing_* attendence_regularly_* absenteeism_problem main_absenteeism_reasons* main_absenteeism_reasons_label* absenteeism_top_reason schistosomiasis_problem peak_schistosomiasis_month schistosomiasis_primary_effect schistosomiasis_sources* schistosomiasis_treatment_minist schistosomiasis_treatment_date

*** save school principal data *** 
save "$data_deidentified\Complete_Midline_SchoolPrincipal", replace 

*** import complete school principal data
use "$data_identified\DISES_Complete_Midline_SchoolAttendance", clear 

* Keep only relevant variables
keep hhid_village info_eleve_*

save "$data_deidentified\Complete_Midline_SchoolAttendance", replace 
