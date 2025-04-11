*** DISES data de-identify and split data for analysis *** 
*** File Created By: Molly Doruska ***
*** File Last Updated By: Molly Doruska ***
*** File Last Updated On: October 14, 2024 ***


clear all 

set maxvar 20000

**** Master file path  ****
if "`c(username)'"=="socrm" global master "C:\Users\socrm\Box"
if "`c(username)'"=="kls329" global master "C:\Users\kls329\Box"
if "`c(username)'"=="km978" global master "C:\Users\km978\Box\NSF Senegal"
if "`c(username)'"=="Kateri" global master "C:\Users\Kateri\Box\NSF Senegal"
if "`c(username)'"=="admmi" global master "C:\Users\admmi\Box"


*** additional file paths ***
global data "$master\Data_Management\Output\Data_Processing\Checks\Corrections\Baseline"
global data_raw "$master\Data_Management\Data\_CRDES_RawData\Baseline"
global hhids "$master\Data_Management\Output\Data_Processing\ID_Creation\Baseline"
global data_deidentified "$master\Data_Management\Data\_CRDES_CleanData\Baseline\Deidentified"
global data_identified "$master\Data_Management\Data\_CRDES_CleanData\Baseline\Identified"

*** import complete data for geographic and preliminary information ***
use "$data\DISES_Baseline_Household_Corrected_PII", clear 

*** drop household ids *** 
drop hhid 

*** merge in correct household ids ***
merge 1:1 hhid_village sup enqu hh_phone hh_head_name_complet hh_name_complet_resp hh_age_resp hh_gender_resp using "$hhids\HouseholdIDs_Original_88"

*** check to make sure merge worked correctly ***
drop _merge 

*** keep only household roster data *** 
keep hhid submissiondate starttime endtime duration today village_select village_select_o region departement commune grappe schoolmosqueclinic grappe_int sup enqu hh_arrondissement

*** put household id first in dataset *** 
order hhid, first 

*** save original 88 data ***
save "$data_deidentified\Original_88_Geographies", replace

*** import complete household data ***
use "$data\DISES_Baseline_Household_Corrected_PII", clear 

*** drop household ids *** 
drop hhid 

*** merge in correct household ids ***
merge 1:1 hhid_village sup enqu hh_phone hh_head_name_complet hh_name_complet_resp hh_age_resp hh_gender_resp using "$hhids\HouseholdIDs_Original_88"

*** check to make sure merge worked correctly ***
drop _merge 

*** keep only household roster data *** 
keep start_hh_composition _household_roster_count hh* end_hh_composition

*** drop extra variables created to make household IDs *** 
drop hh_num hh_id_num 

*** drop identifiying and empty variables *** 
drop hh_phone hh_head_name_complet hh_name_complet_resp hh_region hh_department hh_commune hh_district hh_arrondissement hh_village 

forvalues i = 1/55 {
    drop hh_first_name_`i' hh_name_`i' hh_surname_`i' hh_full_name_calc_`i' 
}

*** fix one hh_age_resp ***
replace hh_age_resp = 50 if hhid == "023B09"

*** put household id first in dataset *** 
order hhid, first 

*** save original 88 data ***
save "$data_deidentified\Original_88_Household_Roster", replace

*** import complete knowledge data *** 
use "$data\DISES_Baseline_Household_Corrected_PII", clear 

*** drop household ids *** 
drop hhid 

*** merge in correct household ids ***
merge 1:1 hhid_village sup enqu hh_phone hh_head_name_complet hh_name_complet_resp hh_age_resp hh_gender_resp using "$hhids\HouseholdIDs_Original_88"

*** check to make sure merge worked correctly ***
drop _merge 

*** keep only knoweldge data *** 
keep hhid start_knowledge knowledge_* end_knowledge 

*** put household id first in dataset *** 
order hhid, first 

*** save original 88 data ***
save "$data_deidentified\Original_88_Knowledge", replace 

*** import complete health data *** 
use "$data\DISES_Baseline_Household_Corrected_PII", clear 

*** drop household ids *** 
drop hhid 
 
*** merge in correct household ids ***
merge 1:1 hhid_village sup enqu hh_phone hh_head_name_complet hh_name_complet_resp hh_age_resp hh_gender_resp using "$hhids\HouseholdIDs_Original_88"

*** check to make sure merge worked correctly ***
drop _merge 

*** keep only health data *** 
keep hhid start_health_status _health_roster_count healthindex* healthage* healthgenre* health_5* end_health_status 

*** put household id first in dataset *** 
order hhid, first 

*** save original 88 data ***
save "$data_deidentified\Original_88_Health", replace 

*** import complete agriculture data *** 
use "$data\DISES_Baseline_Household_Corrected_PII", clear 

*** drop household ids *** 
drop hhid 

*** merge in correct household ids ***
merge 1:1 hhid_village sup enqu hh_phone hh_head_name_complet hh_name_complet_resp hh_age_resp hh_gender_resp using "$hhids\HouseholdIDs_Original_88"

*** check to make sure merge worked correctly ***
drop _merge 

*** keep only agriculture and assets data *** 
keep hhid start_actif list_actifs* _actifs_roster_count actifs* _actif_number* actifs_o actifs_o_int list_agri_equip* _agri_roster_count agriindex* agriname* _agri_number* list_agri_equip_o list_agri_equip_o_t list_agri_equip_int agri_6* _parcelle_roster_count parcelleindex* end_actif 

*** put household id first in dataset *** 
order hhid, first 

*** save original 88 data ***
save "$data_deidentified\Original_88_Agriculture", replace

*** import complete production data *** 
use "$data\DISES_Baseline_Household_Corrected_PII", clear 

*** drop household ids *** 
drop hhid 

*** merge in correct household ids ***
merge 1:1 hhid_village sup enqu hh_phone hh_head_name_complet hh_name_complet_resp hh_age_resp hh_gender_resp using "$hhids\HouseholdIDs_Original_88"

*** check to make sure merge worked correctly ***
drop _merge 

*** keep only production data *** 
keep hhid start_crops _cereals_roster_count cerealsposition* cerealsname* cereals_consumption* cereals_* _farine_tubercules_roster_count farine* legumes* legumineuses* aquatique* autre_culture_yesno autre_culture o_culture* end_crops 

*** put household id first in dataset *** 
order hhid, first 

*** save original 88 data ***
save "$data_deidentified\Original_88_Production", replace 

*** import complete lean season data *** 
use "$data\DISES_Baseline_Household_Corrected_PII", clear 

*** drop household ids *** 
drop hhid 

*** merge in correct household ids ***
merge 1:1 hhid_village sup enqu hh_phone hh_head_name_complet hh_name_complet_resp hh_age_resp hh_gender_resp using "$hhids\HouseholdIDs_Original_88"

*** check to make sure merge worked correctly ***
drop _merge 

*** keep only ean season data *** 
keep hhid start_food food* end_food

*** put household id first in dataset *** 
order hhid, first 

*** save original 88 data ***
save "$data_deidentified\Original_88_Lean_Season", replace 

*** import complete income data *** 
use "$data\DISES_Baseline_Household_Corrected_PII", clear 

*** drop household ids *** 
drop hhid 

*** merge in correct household ids ***
merge 1:1 hhid_village sup enqu hh_phone hh_head_name_complet hh_name_complet_resp hh_age_resp hh_gender_resp using "$hhids\HouseholdIDs_Original_88"

*** check to make sure merge worked correctly ***
drop _merge 

*** keep only income data *** 
keep hhid start_income agri_income* species* _species_roster_count animals_sales* _animals_sales_roster_count sale_animales* credit_roster_count credit_askindex* restant_pret* agri_loan* loan_roster_count loanindex* product_divers* _production_roster_count productindex* productname* expenses_goods* _agriculture_goods_roster_count goodsindex* goodsname* end_income 

*** put household id first in dataset *** 
order hhid, first 

*** save original 88 data ***
save "$data_deidentified\Original_88_Income", replace 

*** import complete standard of living data *** 
use "$data\DISES_Baseline_Household_Corrected_PII", clear 

*** drop household ids *** 
drop hhid 

*** merge in correct household ids ***
merge 1:1 hhid_village sup enqu hh_phone hh_head_name_complet hh_name_complet_resp hh_age_resp hh_gender_resp using "$hhids\HouseholdIDs_Original_88"

*** check to make sure merge worked correctly ***
drop _merge 

*** keep only standard of living data *** 
keep hhid start_living living* end_living 

*** put household id first in dataset *** 
order hhid, first 

*** save original 88 data ***
save "$data_deidentified\Original_88_Standard_Of_Living", replace 

*** import complete beliefs data *** 
use "$data\DISES_Baseline_Household_Corrected_PII", clear 

*** drop household ids *** 
drop hhid 

*** merge in correct household ids ***
merge 1:1 hhid_village sup enqu hh_phone hh_head_name_complet hh_name_complet_resp hh_age_resp hh_gender_resp using "$hhids\HouseholdIDs_Original_88"

*** check to make sure merge worked correctly ***
drop _merge 

*** keep only knoweldge data *** 
keep hhid start_beliefs beliefs* end_beliefs 

*** put household id first in dataset *** 
order hhid, first 

*** save original 88 data ***
save "$data_deidentified\Original_88_Beliefs", replace 

*** import complete public goods game data ***
use "$data\DISES_Baseline_Household_Corrected_PII", clear 

*** drop household ids *** 
drop hhid 

*** merge in correct household ids ***
merge 1:1 hhid_village sup enqu hh_phone hh_head_name_complet hh_name_complet_resp hh_age_resp hh_gender_resp using "$hhids\HouseholdIDs_Original_88"

*** check to make sure merge worked correctly ***
drop _merge 

*** keep only public goods game data *** 
keep hhid start_game game_intro game_01 game_02 consent_game_1 montant_02 game_03 montant_05 montant_07 montant_08 face_01 face_02 face_04 face_06 face_07 face_09 face_10 face_11 face_13 end_game  

*** put household id first in dataset *** 
order hhid, first 

*** save original 88 data ***
save "$data_deidentified\Original_88_Public_Goods_Game", replace 

*** import complete enumerator observation data *** 
use "$data\DISES_Baseline_Household_Corrected_PII", clear 

*** drop household ids *** 
drop hhid 

*** merge in correct household ids ***
merge 1:1 hhid_village sup enqu hh_phone hh_head_name_complet hh_name_complet_resp hh_age_resp hh_gender_resp using "$hhids\HouseholdIDs_Original_88"

*** check to make sure merge worked correctly ***
drop _merge 

*** keep only knoweldge data *** 
keep hhid start_enumerator enum_* end_enumerator

*** put household id first in dataset *** 
order hhid, first 

*** save original 88 data ***
save "$data_deidentified\Original_88_Enumerator_Observations", replace 

*** import complete community data ***
use "$data\DISES_Baseline_Community_Corrected_PII", clear 

*** fix retired household IDs *** 
replace hhid_village = "132B" if hhid_village == "041B"
replace hhid_village = "122B" if hhid_village == "063B"
replace hhid_village = "120A" if hhid_village == "101A"
replace hhid_village = "130A" if hhid_village == "051A"
replace hhid_village = "140A" if hhid_village == "111A"

*** drop identifying data *** 
drop full_name phone_resp q56_2 q56_3 q59_2 q59_3 

drop deviceid devicephonenum username device_info caseid record_text gps* description_village instanceid formdef_version key village 

*** save deidentified data *** 
save "$data_deidentified\Original_88_Community", replace 

*** create community location data file *** 
use "$data\DISES_Baseline_Community_Corrected_PII", clear 

*** fix retired household IDs *** 
replace hhid_village = "132B" if hhid_village == "041B"
replace hhid_village = "122B" if hhid_village == "063B"
replace hhid_village = "120A" if hhid_village == "101A"
replace hhid_village = "130A" if hhid_village == "051A"
replace hhid_village = "140A" if hhid_village == "111A"

*** keep village id's and gps location data ***
keep hhid_village gps* 

save "$data_identified\Original_88_Village_Locations", replace 

**************************** SAME PROCESS FOR ADDITIONAL 16 Villages ************

*** import complete household data ***
use "$data\DISES_Baseline_Household_Corrected_Additional_PII", clear 

*** keep only household roster data *** 
keep hhid submissiondate starttime endtime duration today village_select village_select_o region departement commune grappe schoolmosqueclinic grappe_int sup enqu hh_arrondissement

*** put household id first in dataset *** 
order hhid, first 

*** save additional 16 data ***
save "$data_deidentified\Additional_16_Geographies", replace 

*** import complete household data ***
use "$data\DISES_Baseline_Household_Corrected_Additional_PII", clear 

*** keep only household roster data *** 
keep start_hh_composition _household_roster_count hh* end_hh_composition

*** drop identifiying variables *** 
drop hh_phone hh_head_name_complet hh_name_complet_resp hh_region hh_department hh_commune hh_district hh_arrondissement hh_village 

forvalues i = 1/18 {
    drop hh_first_name_`i' hh_name_`i' hh_surname_`i' hh_full_name_calc_`i' 
}

*** put household id first in dataset *** 
order hhid, first 

*** save additional 16 data ***
save "$data_deidentified\Additional_16_Household_Roster", replace 

*** import complete knowledge data *** 
use "$data\DISES_Baseline_Household_Corrected_Additional_PII", clear 

*** keep only knoweldge data *** 
keep hhid start_knowledge knowledge_* end_knowledge 

*** put household id first in dataset *** 
order hhid, first 

*** save additional 16 data ***
save "$data_deidentified\Additional_16_Knowledge", replace 

*** import complete health data *** 
use "$data\DISES_Baseline_Household_Corrected_Additional_PII", clear 

*** keep only health data *** 
keep hhid start_health_status _health_roster_count healthindex* healthage* healthgenre* health_5* end_health_status 

*** put household id first in dataset *** 
order hhid, first 

*** save additional 16 data ***
save "$data_deidentified\Additional_16_Health", replace 

*** import complete agriculture data *** 
use "$data\DISES_Baseline_Household_Corrected_Additional_PII", clear 

*** keep only agriculture and assets data *** 
keep hhid start_actif list_actifs* _actifs_roster_count actifs* _actif_number* actifs_o actifs_o_int list_agri_equip* _agri_roster_count agriindex* agriname* _agri_number* list_agri_equip_o list_agri_equip_o_t list_agri_equip_int agri_6* _parcelle_roster_count parcelleindex* end_actif 

*** put household id first in dataset *** 
order hhid, first 

*** save additional 16 data ***
save "$data_deidentified\Additional_16_Agriculture", replace 

*** import complete production data *** 
use "$data\DISES_Baseline_Household_Corrected_Additional_PII", clear 

*** keep only production data *** 
keep hhid start_crops _cereals_roster_count cerealsposition* cerealsname* cereals_consumption* cereals_* _farine_tubercules_roster_count farine* legumes* legumineuses* aquatique* autre_culture_yesno autre_culture o_culture* end_crops 

*** put household id first in dataset *** 
order hhid, first 

*** save additional 16 data ***
save "$data_deidentified\Additional_16_Production", replace 

*** import complete lean season data *** 
use "$data\DISES_Baseline_Household_Corrected_Additional_PII", clear 

*** keep only lean season data *** 
keep hhid start_food food* end_food

*** put household id first in dataset *** 
order hhid, first 

*** save additional 16 data ***
save "$data_deidentified\Additional_16_Lean_Season", replace 

*** import complete income data *** 
use "$data\DISES_Baseline_Household_Corrected_Additional_PII", clear 

*** keep only income data *** 
keep hhid start_income agri_income* species* _species_roster_count animals_sales* _animals_sales_roster_count sale_animales* credit_roster_count credit_askindex* restant_pret* agri_loan* loan_roster_count loanindex* product_divers* _production_roster_count productindex* productname* expenses_goods* _agriculture_goods_roster_count goodsindex* goodsname* end_income 

*** put household id first in dataset *** 
order hhid, first 

*** save additional 16 data ***
save "$data_deidentified\Additional_16_Income", replace 

*** import complete standard of living data *** 
use "$data\DISES_Baseline_Household_Corrected_Additional_PII", clear 

*** keep only standard of living data *** 
keep hhid start_living living* end_living 

*** put household id first in dataset *** 
order hhid, first 

*** save additional 16 data ***
save "$data_deidentified\Additional_16_Standard_Of_Living", replace 

*** import complete beliefs data *** 
use "$data\DISES_Baseline_Household_Corrected_Additional_PII", clear 

*** keep only knoweldge data *** 
keep hhid start_beliefs beliefs* end_beliefs 

*** put household id first in dataset *** 
order hhid, first 

*** save additional 16 data ***
save "$data_deidentified\Additional_16_Beliefs", replace 

*** import complete household data ***
use "$data\DISES_Baseline_Household_Corrected_Additional_PII", clear 

*** keep only public goods game data *** 
keep hhid start_game game_intro game_01 game_02 consent_game_1 montant_02 game_03 montant_05 montant_07 montant_08 face_01 face_02 face_04 face_06 face_07 face_09 face_10 face_11 face_13 end_game  

*** put household id first in dataset *** 
order hhid, first 

*** save original 88 data ***
save "$data_deidentified\Additional_16_Public_Goods_Game", replace 

*** import complete enumerator observation data *** 
use "$data\DISES_Baseline_Household_Corrected_Additional_PII", clear 

*** keep only knoweldge data *** 
keep hhid start_enumerator enum_* end_enumerator

*** put household id first in dataset *** 
order hhid, first 

*** save additional 16 data ***
save "$data_deidentified\Additional_16_Enumerator_Observations", replace 

*** import complete community data ***
import delimited "$data_raw\Questionnaire Communautaire - NSF DISES_V2_WIDE_10June24.csv", clear varnames(1) 

*** drop identifying data *** 
drop full_name phone_resp q56_2 q56_3 q59_2 q59_3 

drop deviceid devicephonenum username device_info caseid record_text gps* description_village instanceid formdef_version key village 

*** save deidentified data *** 
save "$data_deidentified\Additional_16_Community", replace 

*** create community location data file *** 
import delimited "$data_raw\Questionnaire Communautaire - NSF DISES_V2_WIDE_10June24.csv", clear varnames(1) 

*** keep village id's and gps location data ***
keep hhid_village gps* 

save "$data_identified\Additional_16_Village_Locations", replace 

****************** Append De-identified data files into one file for roster ***************
use "$data_deidentified\Original_88_Geographies", clear
append using "$data_deidentified\Additional_16_Geographies", force 

save "$data_deidentified\Complete_Baseline_Geographies", replace  

use "$data_deidentified\Original_88_Household_Roster", clear
append using "$data_deidentified\Additional_16_Household_Roster", force 

save "$data_deidentified\Complete_Baseline_Household_Roster", replace  

use "$data_deidentified\Original_88_Knowledge", clear
append using "$data_deidentified\Additional_16_Knowledge", force 

save "$data_deidentified\Complete_Baseline_Knowledge", replace 

use "$data_deidentified\Original_88_Health", clear
append using "$data_deidentified\Additional_16_Health", force 

save "$data_deidentified\Complete_Baseline_Health", replace 

use "$data_deidentified\Original_88_Agriculture", clear
append using "$data_deidentified\Additional_16_Agriculture", force 

save "$data_deidentified\Complete_Baseline_Agriculture", replace 

use "$data_deidentified\Original_88_Production", clear
append using "$data_deidentified\Additional_16_Production", force 

save "$data_deidentified\Complete_Baseline_Production", replace 

use "$data_deidentified\Original_88_Lean_Season", clear
append using "$data_deidentified\Additional_16_Lean_Season" 

save "$data_deidentified\Complete_Baseline_Lean_Season", replace 

use "$data_deidentified\Original_88_Income", clear
append using "$data_deidentified\Additional_16_Income", force 

save "$data_deidentified\Complete_Baseline_Income", replace 

use "$data_deidentified\Original_88_Standard_Of_Living", clear
append using "$data_deidentified\Additional_16_Standard_Of_Living", force

save "$data_deidentified\Complete_Baseline_Standard_Of_Living", replace 

use "$data_deidentified\Original_88_Beliefs", clear
append using "$data_deidentified\Additional_16_Beliefs" 

save "$data_deidentified\Complete_Baseline_Beliefs", replace 

use "$data_deidentified\Original_88_Public_Goods_Game", clear
append using "$data_deidentified\Additional_16_Public_Goods_Game"

save "$data_deidentified\Complete_Baseline_Public_Goods_Game", replace 

use "$data_deidentified\Original_88_Enumerator_Observations", clear
append using "$data_deidentified\Additional_16_Enumerator_Observations", force 

save "$data_deidentified\Complete_Baseline_Enumerator_Observations", replace 

use "$data_deidentified\Original_88_Community", clear 
append using "$data_deidentified\Additional_16_Community", force

save "$data_deidentified\Complete_Baseline_Community", replace 

use "$data_identified\Original_88_Village_Locations", clear 
append using "$data_identified\Additional_16_Village_Locations"

*** fix gps locations that are in Dakar *** 
replace gps_collectlatitude = 16.578749 if hhid_village == "051B"
replace gps_collectlongitude = -14.558815 if hhid_village == "051B"
replace gps_collectaltitude = . if hhid_village == "051B"
replace gps_collectaccuracy = . if hhid_village == "051B" 


replace gps_collectlatitude = 16.0758 if hhid_village == "120B"
replace gps_collectlongitude = -15.8923 if hhid_village == "120B"
replace gps_collectaltitude = . if hhid_village == "120B"
replace gps_collectaccuracy = . if hhid_village == "120B"

replace gps_collectlatitude = 16.209708 if hhid_village == "112B"
replace gps_collectlongitude = -15.889664 if hhid_village == "112B"
replace gps_collectaltitude = . if hhid_village == "112B"
replace gps_collectaccuracy = . if hhid_village == "112B"

replace gps_collectlatitude = 16.488007 if hhid_village == "072B"
replace gps_collectlongitude = -14.425702 if hhid_village == "072B"
replace gps_collectaltitude = . if hhid_village == "072B"
replace gps_collectaccuracy = . if hhid_village == "072B"

replace gps_collectlatitude = 16.548259 if hhid_village == "060B"
replace gps_collectlongitude = -14.752889 if hhid_village == "060B"
replace gps_collectaltitude = . if hhid_village == "060B"
replace gps_collectaccuracy = . if hhid_village == "060B" 

replace gps_collectlatitude = 16.600698 if hhid_village == "132B"
replace gps_collectlongitude = -14.33234 if hhid_village == "132B"
replace gps_collectaltitude = . if hhid_village == "132B"
replace gps_collectaccuracy = . if hhid_village == "132B" 

save "$data_identified\Complete_Baseline_Village_Locations", replace

*** create identified household roster dataset ***
*** import complete household data ***
use "$data\DISES_Baseline_Household_Corrected_PII", clear 

*** drop household ids *** 
drop hhid 

*** merge in correct household ids ***
merge 1:1 hhid_village sup enqu hh_phone hh_head_name_complet hh_name_complet_resp hh_age_resp hh_gender_resp using "$hhids\HouseholdIDs_Original_88"

*** check to make sure merge worked correctly ***
drop _merge 

*** keep only household roster data *** 
keep start_hh_composition _household_roster_count hh* end_hh_composition

*** drop extra variables created to make household IDs *** 
drop hh_num hh_id_num 

*** fix one hh_age_resp ***
replace hh_age_resp = 50 if hhid == "023B09"

*** put household id first in dataset *** 
order hhid, first 

*** save original 88 data ***
save "$data_identified\Original_88_Household_Roster", replace

*** import complete household data ***
use "$data\DISES_Baseline_Household_Corrected_Additional_PII", clear 

*** keep only household roster data *** 
keep start_hh_composition _household_roster_count hh* end_hh_composition

*** put household id first in dataset *** 
order hhid, first 

*** save additional 16 data ***
save "$data_identified\Additional_16_Household_Roster", replace 

*** combine for identified household roster datafile ***
use "$data_identified\Original_88_Household_Roster", clear
append using "$data_identified\Additional_16_Household_Roster", force 

save "$data_identified\Complete_Baseline_Household_Roster", replace  