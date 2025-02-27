*** DISES Midline Data Checks - Household Survey***
*** File originally created By: Molly Doruska 
     ***>>> Adapted by Kateri Mouawad & Alex Mills <<<***
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
if "`c(username)'"=="socrm" global master "C:\Users\socrm\Box\NSF Senegal"
if "`c(username)'"=="kls329" global master "C:\Users\kls329\Box\NSF Senegal"
if "`c(username)'"=="km978" global master "C:\Users\km978\Box\NSF Senegal"
if "`c(username)'"=="Kateri" global master "C:\Users\Kateri\Box\NSF Senegal"
if "`c(username)'"=="admmi" global master "C:\Users\admmi\Box\NSF Senegal"


**************************** data file paths ****************************`		`	''

global data "$master\Data_Management\_CRDES_RawData\Midline\Household_Survey_Data"

**************************** output file paths ****************************

global village_observations "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Village_Observations"
global household_roster "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Household_Roster"
global knowledge "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Knowledge"
global health "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Health" 
global agriculture_inputs "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Agriculture_Inputs"
global agriculture_production "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Agriculture_Production"
global food_consumption "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Food_Consumption"
global income "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Income"
global standard_living "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Standard_Living"
global beliefs "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Beliefs" 
global enum_observations "$master\Data_Management\Output\Data_Quality_Checks\Midline\Midline_Enumerator_Observations"
global issuesOriginal "$master\Data_Management\Output\Data_Quality_Checks\Midline\_Midline_Original_Issues_Output"
global corrected "$master\Data_Management\Output\Data_Corrections\Midline"
**************************** Import household data ****************************

* Note: update this every new data cleaning session ***

//import delimited "$data\DISES_Enquête_ménage_midline_VF_WIDE_19Feb2025.csv", clear varnames(1) bindquote(strict)

use "$corrected\CORRECTED_DISES_Enquête_ménage_midline_VF_WIDE_24Feb2025.dta"

**************************** rename variables ****************************
rename hh_size_actual _household_roster_count
rename hhid_village villageid
rename hh_global_id hhid

foreach i of numlist 1/3 {
    capture rename goodsindex_`i' goodsinex_`i' 
}
*Note: check max i value 
foreach i of numlist 1/57 {
    capture rename age_`i' hh_age_`i'
}

drop if consent == 0
drop if consent == 2

**************************** capture label variables ****************************
* Note: we label location and respondents

	capture label variable village_select "Selectionnez le vilalge pour le questionnaire menage"
	capture label variable village_select_o "Nom du village"
	capture label variable hhid_village "Village ID"
	capture label variable consent "Acceptez-vous de faire l'interview et de participier a l'etude"
	capture label variable hh_numero "Nombre de membres dans le menage"
	capture label variable hh_phone "Numero de telephone du menage (ou numero de telephone d'un membre du menage)"
	capture label variable hh_head_name_complet "Nom et prenom du chef du menage"
	capture label variable hh_name_complet_resp "Nom et prenom du repondant"
	capture label variable hh_age_resp "Age du repondant"
	capture label variable hh_gender_resp "Sexe du repondant"
	capture label variable attend_training "Avez-vous assisté à la formation que notre équipe a organisée en [MOIS] 2024 sur l'élimination de la plante aquatique cerat"
	capture label variable who_attended_training "Est-ce que une autre membre de ce menage a assiste a la formation que notre équipe a organisée en [MOIS] 2024 sur l'élimination de la plante aquatique cerato [REMPLACER par le nom local, naithe ?] ?"
	capture label variable training_id "Qui a assiste a la formation (selectionnez de la liste du membres du menage)"
	capture label variable heard_training "Avez-vous entendu parler de la formation menées par le projet ?"
	capture label variable hh_gpslatitude "Date"
	capture label variable hh_gpslongitude "Heure"
	capture label variable hh_gpsaltitude "Heure"
	capture label variable hh_gpsaccuracy  "Heure"
	capture label variable count_chefs "HH Head Count"
	

*** labels for household members - loop through all member numbers ***
*** check the data to ensure this is the maximum number of members in a household ***
forvalues i = 1/57{
	
/* KRM - not present 
	capture label variable hh_first_name_`i' "Prenom"
	capture label variable hh_name_`i' "Nom"
	capture label variable hh_surname_`i' "Surnom"
*/
	capture label variable hh_full_name_calc_`i' "Full Name"
	capture label variable hh_name_complet_resp_`i' "Nom et prénom du répondant" 
	capture label hh_name_complet_resp_new_`i' "Nouveau membre" 
   	capture label still_member_`i'  "Cette personne fait-elle toujours partie du ménage ?"
	capture label still_member_whynot_`i'  "Pourquoi il/elle n´est plus membre du ménage? ?"
	capture label still_member_whynot_o_`i' "Autre raison"
	capture label newmem_why_`i' "Pourquoi il/elle n'était pas enregistré(e) comme membre de votre ménage lors de la dernière collecte ?" 
	capture label add_new_`i' "Y a-t-il d'autres personnes dans le ménage ?"
	capture label variable hh_gender_`i' "Genre"
	capture label variable hh_age_`i' "Age"
	capture label variable hh_ethnicity_`i' "Ethnicite"
	capture label variable hh_ethnicity_o_`i' "Autre ethnie"
	capture label variable hh_relation_with_`i' "Relation avec le chef du menage"
	capture label variable hh_relation_with_o_`i' "Autre forme de relation"
	capture label variable hh_education_skills_`i' "Education - Competences (chiox multiple)"
	capture label variable hh_education_skills_0_`i' "Education - Competences - 0 Aucun"
	capture label variable hh_education_skills_1_`i' "Education - Competences - 1 Peut ecrire une courte letter a sa famille"
	capture label variable hh_education_skills_2_`i' "Education - Competences - 2 A l'aise avec les chiffres et les calculs"
	capture label variable hh_education_skills_3_`i' "Education - Competences - 3 Arabisant/peut lire le Coran en arabe"
	capture label variable hh_education_skills_4_`i' "Education - Competences - 4 Parle couramment le wolof/pulaar"
	capture label variable hh_education_skills_5_`i' "Education - Competences - 5 Peut lire un journal en francais"
	capture label variable hh_education_level_`i' "Niveau d'education atteint"
	
	capture label variable hh_education_level_o_`i' "Autre niveau"
	capture label variable hh_education_year_achieve_`i' "Combien d'annees d'etudes [hh_full_name_calc] a-t-il(elle) acheve(e)"
	capture label variable hh_main_activity_`i' "Activite principale en dehors de la maison"
	capture label variable hh_main_activity_o_`i' "Autre activite"
	capture label variable hh_mother_live_`i' "La mere de [hh_full_name_calc] vivait-elle dans le village le jour de la naissance de [hh_full_name_calc]"
	capture label variable hh_relation_imam_`i' "Lien de parente de [hh_full_name_calc] avec l'Imam ou le Chef du village"
	capture label variable hh_presence_winter_`i' "Presence en hiver/saison des pluies"
	capture label variable hh_presence_dry_`i' "Presence en saison seche"
	capture label variable hh_active_agri_`i' "Est-il/elle un travailleur agricle actif"
	capture label variable hh_01_`i' "Au cours des 7 derniers jours combien d'heurs [hh_full_name_calc] a consacre aux taches menageres ou a la preparation des repas"
	capture label variable hh_02_`i' "Au cours des 7 derniers jours combien d'heurs [hh_full_name_calc] a consacre pour chercher de l'eau"
	capture label variable hh_03_`i' "Au cours des 12 derniers mois, [hh_full_name_calc] a-t-il travaille dans le cadre d'activites agricoles domestiques"
	capture label variable hh_04_`i' "Au cours des 7 derniers jours, combien d'heures [hh_full_name_calc] a-t-il travaille dans le cadre d'activites agricoles domestiques"
	capture label variable hh_05_`i' "Pendant la periode de plantation de la derniere campagne agricole, combien d'heures"
	capture label variable hh_06_`i' "Pendant la periode de croissance maximale de la dernière campagne agricole, combien d'heures"
	capture label variable hh_07_`i' "Pendant la période de recolte de la dernière campagne agricole, combien de jours"
	capture label variable hh_08_`i' "Au cours des 7 derniers jours, combien d'heures [hh_full_name_calc] a t-il consacre pour travailler dans un commerce"
	capture label variable hh_09_`i' "Au cours des 7 derniers jours, combien d'heures [hh_full_name_calc] a t-il consacre pour travailler pour une entreprise"
	capture label variable hh_10_`i' "Au cours des 12 derniers mois, combien d'heures par semaine en moyenne [hh_full_name_calc] a-t-il passe a moins d'un metre ou dans une source d'eau de surface"
	capture label variable hh_11_`i' "Quelle(s) source(s) d'eau de surface?"
	capture label variable hh_11_o_`i' "Autre source"
	
	capture label variable hh_12_`i' "Au cours des 12 derniers mois, pourquoi [hh_full_name_calc] a-t-il passé du temps près de (< 1 m) ou dans la/les source(s) d'eau?"
	capture label variable hh_12_1_`i' "Aller chercher de l'eau pour le menage"
	capture label variable hh_12_2_`i' "Donner de l'eau au betail"
	capture label variable hh_12_3_`i' "Aller chercher de l'eau pour l'agriculture"
	capture label variable hh_12_4_`i' "Laver des vetements"
	capture label variable hh_12_5_`i' "Faire la vaisselle"
	capture label variable hh_12_6_`i' "Recolter de la vegetation aquatique"
	capture label variable hh_12_7_`i' "Nager/se baigner"
	capture label variable hh_12_8_`i' "Jouer"
	capture label variable hh_12_a_`i' "Est-ce qu'il a d'autres raisons pour laquelle [hh_full_name_calc] a-t-il passe du temps pres de (< 1 m) ou dans la/les source(s) d'eau?"
	capture label variable hh_12_o_`i' "Autre a preciser"
	capture label variable hh_13_`i'_1 "Au cours des 12 derniers mois, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_12 = 1 pres de (< 1 m) ou dans la/les source(s) d'eau?"
	capture label variable hh_13_`i'_2 "Au cours des 12 derniers mois, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_12 = 2 pres de (< 1 m) ou dans la/les source(s) d'eau?"
	capture label variable hh_13_`i'_3 "Au cours des 12 derniers mois, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_12 = 3 pres de (< 1 m) ou dans la/les source(s) d'eau?"
	capture label variable hh_13_`i'_4 "Au cours des 12 derniers mois, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_12 = 4 pres de (< 1 m) ou dans la/les source(s) d'eau?"
	capture label variable hh_13_`i'_5 "Au cours des 12 derniers mois, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_12 = 5 pres de (< 1 m) ou dans la/les source(s) d'eau?"
	capture label variable hh_13_`i'_6 "Au cours des 12 derniers mois, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_12 = 6 pres de (< 1 m) ou dans la/les source(s) d'eau?"
** KRM - hh_13_`i'_7  present, added back in  
	capture label variable hh_13_`i'_7 "Au cours des 12 derniers mois, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_12 = 7 pres de (< 1 m) ou dans la/les source(s) d'eau?"
	capture label variable hh_13_o_`i' "Au cours des 12 derniers mois, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a [hh_12_o] pres de (< 1 m) ou dans la/les source(s) d'eau"
	capture label variable hh_14_`i' "Au cours des 12 derniers mois, combien de vegetation aquatique a-t-il/elle recolte pres de (< 1 m) ou dans la/les source(s) d'eau par semaine, en moyenne (en kg)"
	capture label variable hh_14_a_`i' "Au cours des 12 derniers mois, combien de fois a-t-il/elle recolté de végétation aquatique près de (< 1 m) ou dans la/les source(s) d'eau?"
	capture label variable hh_14_b_`i' "Pour chaque fois, en moyenne, combien de végétation aquatique a-t-il/elle recolté près de (< 1 m) ou dans la/les source(s) d'eau? (1= kg Tipha, 2= kg autre)"
	capture label variable hh_15_`i' "Comment a-t-il utilise la vegetation aquatique"
	capture label variable hh_15_o_`i' "Autre a preciser"
	capture label variable hh_16_`i' "Au cours des 12 derniers mois combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a la production d'engrais, son achat, ou son application sur le champ"
	capture label variable hh_17_`i' "Au cours des 12 derniers mois combien d'heures [hh_full_name_calc] a t-il consacre a la production d'aliments pour le betail par semaine en moyenne"
	capture label variable hh_18_`i' "Au cours des 7 derniers jours combien d'heures [hh_full_name_calc] a-t-il passe pres de (< 1 m) ou dans une source d'eau de surface"
	capture label variable hh_19_`i' "Quelle(s) source(s) d'eau de surface"
	capture label variable hh_19_o_`i' "Autre a preciser"
	
	capture label variable hh_20_`i' "Au cours des 7 derniers jours, pourquoi [hh_full_name_calc] a-t-il passe du temps pres de (< 1 m) ou dans la/les source(s) d'eau"
	capture label variable hh_20_1_`i' "Aller chercher de l'eau pour le menage"
	capture label variable hh_20_2_`i' "Donner de l'eau au betail"
	capture label variable hh_20_3_`i' "Aller chercher de l'eau pour l'agriculture"	
	capture label variable hh_20_4_`i' "Laver des vetements"
	capture label variable hh_20_5_`i' "Faire la vaisselle"
	capture label variable hh_20_6_`i' "Recolter de la vegetation aquatique"
	capture label variable hh_20_7_`i' "Nager/se baigner"
	capture label variable hh_20_8_`i' "Jouer"
	capture label variable hh_20_a_`i' "Est-ce qu'il a d'autres raisons pour laquelle [hh_full_name_calc] a-t-il passe du temps pres de (< 1 m) ou dans la/les source(s) d'eau"
	capture label variable hh_20_o_`i' "Autre a preciser"
	capture label variable hh_21_`i'_1 "Au cours des 7 derniers jours, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_20 = 1 pres de (< 1 m) ou dans la/les source(s) d'eau?"
	capture label variable hh_21_`i'_2 "Au cours des 7 derniers jours, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_20 = 2 pres de (< 1 m) ou dans la/les source(s) d'eau?"
	capture label variable hh_21_`i'_3 "Au cours des 7 derniers jours, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_20 = 3 pres de (< 1 m) ou dans la/les source(s) d'eau?"
	capture label variable hh_21_`i'_4 "Au cours des 7 derniers jours, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_20 = 4 pres de (< 1 m) ou dans la/les source(s) d'eau?"
	capture label variable hh_21_`i'_5 "Au cours des 7 derniers jours, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_20 = 5 pres de (< 1 m) ou dans la/les source(s) d'eau?"
	capture label variable hh_21_`i'_6 "Au cours des 7 derniers jours, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_20 = 6 pres de (< 1 m) ou dans la/les source(s) d'eau?"
**# Bookmark #7 - KRM:  present, added back in 
	capture label variable hh_21_`i'_7 "Au cours des 7 derniers jours, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_20 = 7 pres de (< 1 m) ou dans la/les source(s) d'eau?"
	capture label variable hh_21_o_`i' "Au cours des 7 derniers jours, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a [hh_20_o] pres de (< 1 m) ou dans la/les source(s) d'eau"
	capture label variable hh_22_`i' "Au cours des 7 derniers jours, combien de vegetation aquatique a-t-il/elle recolte pres de (< 1 m) ou dans la/les source(s) d'eau (en kg)"
	capture label variable hh_23_`i' "Comment a-t-il utilise la vegetation aquatique"
	capture label variable hh_23_1_`i' "Vendre"
	capture label variable hh_23_2_`i' "Engrais"
	capture label variable hh_23_3_`i' "Alimentation pour le betail"
	capture label variable hh_23_4_`i' "Matiere premiere pour le biodigesteur"
	capture label variable hh_23_5_`i' "Rien"
	capture label variable hh_23_99_`i' "Autre"
	capture label variable hh_23_o_`i' "Autre a preciser"
	capture label variable hh_24_`i' "Au cours des 7 derniers jours combien d'heures [hh_full_name_calc] a t-il consacre a la production d'engrais, son achat, ou son application sur le champ?"
	capture label variable hh_25_`i' "Au cours des 7 derniers jours combien d'heures [hh_full_name_calc] a t-il consacre a la production d'aliments pour le betail"
	capture label variable hh_26_`i' "[hh_full_name_calc] a-t-il fait ou fait-il des etudes actuellement dans une ecole formelle"
	capture label variable hh_27_`i' "Est ce que [hh_full_name_calc] a suivi une ecole non formelle ou une formation non-formelle"
	capture label variable hh_28_`i' "Quel type d'education non-formelle [hh_full_name_calc] a frequente"
	capture label variable hh_29_`i' "Quel est le niveau et la classe les plus eleves que [hh_full_name_calc] a reussi a l'ecole"
	capture label variable hh_29_o_`i' "Autre a preciser"
	capture label variable hh_30_`i' "[hh_full_name_calc] a-t-il frequente une ecole au cours de la derniere annee scolaire 2022-23"
	capture label variable hh_31_`i' "Quel resultat [hh_full_name_calc] a-t-il obtenu au cours de l'annee 2022/2023"
	capture label variable hh_32_`i' "Est-ce que [hh_full_name_calc] frequente une ecole au cours de la presente annee scolaire 2023/2024"
	capture label variable hh_34_`i' "Quel age avait [hh_full_name_calc] quand il (elle) a cesse d'aller a l'ecole"
	capture label variable hh_35_`i' "Quelle est le niveau et la classe frequentee par [hh_full_name_calc] au cours de l'annee 2023/2024"
	capture label variable hh_36_`i' "Pensez-vous que [hh_full_name_calc] reussira son niveau scolaire declare au course de l'annee 2023/2024"
	capture label variable hh_37_`i' "Au cours des 12 derniers mois, [hh_full_name_calc] a-t-il deja manque plus d'une semaine consecutive d'ecole pour cause de maladie"
	capture label variable hh_38_`i' "Au cours des 7 derniers jours, combien de jours [hh_full_name_calc] est-il alle a l'ecole pour suivre des cours"
	capture label variable hh_39_`i' "Qui est la mère ou la belle-mère de cet enfant ? Sélectionnez dans la liste ou ajoutez des catégories supplémentaires : (i) décédée ou (ii) vivante mais ne résidant pas dans le ménage avec l'enfant"
	capture label variable hh_40_`i' "Qui est le père ou le beau-père de cet enfant ? Sélectionnez dans la liste ou ajoutez des catégories supplémentaires : (i) décédé ou (ii) vivant mais ne résidant pas dans le ménage avec l'enfant"
	capture label variable hh_41_`i' "Quel âge avait [NOM] quand il (elle) est entré (e) à l'école?"
	capture label variable hh_42_`i' "[NOM] fréquente-t-il l'école aujourd'hui ?"
	capture label variable hh_43_`i' "Quand [NOM] fréquente-t-il l'école aujourd'hui ?"
	capture label variable hh_44_`i' "L'enfant est-il à la maison ?"
	capture label variable hh_45_`i' "Enquêteur : Observez-vous vous-même l'enfant à la maison ?"
	capture label variable hh_46_`i' "Quelle est la raison principale pour laquelle l'enfant ne fréquente pas l'école aujourd'hui ?"
	capture label variable hh_47_a_`i' "Combien a été dépensé pour l'éducation de [NOM] au cours des 12 derniers mois par le ménage, la famille et les amis : Frais d'inscription et de scolarité ?"
	capture label variable hh_47_b_`i' "Combien a été dépensé pour l'éducation de [NOM] au cours des 12 derniers mois par le ménage, la famille et les amis : Fournitures ?"
	capture label variable hh_47_c_`i' "Combien a été dépensé pour l'éducation de [NOM] au cours des 12 derniers mois par le ménage, la famille et les amis : Uniformes ?"
	capture label variable hh_47_d_`i' "Combien a été dépensé pour l'éducation de [NOM] au cours des 12 derniers mois par le ménage, la famille et les amis : Repas scolaires ?"
	capture label variable hh_47_e_`i' "Combien a été dépensé pour l'éducation de [NOM] au cours des 12 derniers mois par le ménage, la famille et les amis : Transport scolaire ?"
	capture label variable hh_47_f_`i' "Combien a été dépensé pour l'éducation de [NOM] au cours des 12 derniers mois par le ménage, la famille et les amis : Cours particuliers ou séances de répétition ?"
	capture label variable hh_47_g_`i' "Combien a été dépensé pour l'éducation de [NOM] au cours des 12 derniers mois par le ménage, la famille et les amis : Autres (préciser ?"
	capture label variable hh_47_oth_`i' "Combien a été dépensé pour l'éducation de [NOM] au cours des 12 derniers mois par le ménage, la famille et les amis : Autre à préciser ?"
	capture label variable hh_48_`i' "[NOM] a-t-il été testé pour la bilharziose à l'école ?"
	capture label variable hh_49_`i' "Cet enfant fréquente-t-il actuellement une école située dans cette communauté ?"	
	capture label variable hh_50_`i' "Quel est le nom de l'école?"	
	capture label variable hh_51_`i' "Comment cet enfant va-t'il à cette école?"	
	capture label variable hh_52_`i' "Quel est le nom de l'école?"	
	
	}



*** knowledge section ***
	capture label variable knowledge_01 "Avez-vous deja entendu parler de la bilharziose"
	capture label variable knowledge_02 "Pouvez-vous nous dire en termes simples ce qu'est la bilharziose"
	capture label variable knowledge_03 "Pensez-vous que la bilharziose est une maladie"
	capture label variable knowledge_04 "Si vous pensez que la bilharziose est une maladie, pensez-vous qu'il s'agit d'une maladie grave"
	capture label variable knowledge_05 "Quelle est la cause de la bilharziose"
	capture label variable knowledge_05_o "Autre cause"
	capture label variable knowledge_06 "A votre avis, comment savez-vous si une personne est atteinte de bilharziose"
	capture label variable knowledge_06_1 "Lorsq'ils ont de la fievre"
	capture label variable knowledge_06_2 "En cas de diarrhee"
	capture label variable knowledge_06_3 "En cas de douleurs a l'estomac"
	capture label variable knowledge_06_4 "En cas de sang dans les urines"
	capture label variable knowledge_06_5 "En cas de demangeaisons"
	capture label variable knowledge_06_6 "Je ne sais pas si c'est le cas"
	capture label variable knowledge_07 "Savez-vous s'il existe un test a l'hopital pour detecter la bilharziose chez un individu"
	capture label variable knowledge_08 "Si oui, lequel"
	capture label variable knowledge_09 "Comment une personne peut-elle se proteger contre la bilharziose"
	capture label variable knowledge_09_1 "Eviter d'uriner dans la riviere"
	capture label variable knowledge_09_2 "Eviter de defequer dans la riviere"
	capture label variable knowledge_09_3 "Eviter de se rendre a la riviere"
	capture label variable knowledge_09_4 "Eviter de marcher pieds nus"
	capture label variable knowledge_09_5 "Dormir sous une moustiquaire"
	capture label variable knowledge_09_6 "Retirer les plantes des points d'eau"
	capture label variable knowledge_09_99 "Autre (a preciser)"
	capture label variable knowledge_09_o "Autre precaution"
	capture label variable knowledge_10 "Comment peut-on contracter la bilharziose"
	capture label variable knowledge_10_1 "En marchant pieds nus"
	capture label variable knowledge_10_2 "En mangeant sans se lever les mains"
	capture label variable knowledge_10_3 "En allant a la riviere"
	capture label variable knowledge_10_4 "En buvant l'eau de la riviere"
	capture label variable knowledge_10_5 "En se faisant piquer par des moustiques"
	capture label variable knowledge_10_6 "Lors de rapports sexuels avec une personne infectee par la bilharziose"
	capture label variable knowledge_10_7 "Je ne sais pas"
	capture label variable knowledge_10_99 "Autre specification"
	capture label variable knowledge_10_o "Autre"
	capture label variable knowledge_11 "Pensez-vous que la bilharziose est contagieuse"
	capture label variable knowledge_12 "Connaissez-vous l'animal qui transmet la bilharziose"
	capture label variable knowledge_12_o "Autre animal"
	capture label variable knowledge_13 "Pensez-vous que la bilharziose peut etre guerie sans traitement"
	capture label variable knowledge_14 "Pensez-vous qu'il existe un medicament pour traiter la bilharziose"
	capture label variable knowledge_15 "Connaissez-vous un traitement traditionnel pour la bilharziose"
	capture label variable knowledge_16 "Pensez-vous que ce traitement traditionnel est efficace, qu'il soigne vraiment"
	capture label variable knowledge_17 "Avez-vous des commentaires sur le traitement de la bilharziose"
	capture label variable knowledge_18 "Avez-vous ete en contact avec un plan d'eau (lac, riviere, ruisseau, marais, etc.) au cours des 12 derniers mois"
	capture label variable knowledge_19 "De quel type de plan d'eau s'agissait-il"
	capture label variable knowledge_19_o "Autre type d'eau"
	capture label variable knowledge_20 "Ou etes-vous entre en contact avec la masse d'eau"
	capture label variable knowledge_20_o "Autre lieu"
	capture label variable knowledge_21 "A quelle frequence"
	capture label variable knowledge_22 "Quand y etes-vous alle pour la derniere fois"
	capture label variable knowledge_23 "Quelles sont les raisons pour lesquelles vous avez ete (ou etes) en contact avec le cours d'eau"
	capture label variable knowledge_23_1 "Pour les taches menageres (vaisselle, lessive, etc.)"
	capture label variable knowledge_23_2 "Pour aller chercher de l'eau"
	capture label variable knowledge_23_3 "Pour sa baigner"
	capture label variable knowledge_23_4 "Jouer"
	capture label variable knowledge_23_5 "Pecher"
	capture label variable knowledge_23_6 "Pour mes activites agricoles"
	capture label variable knowledge_23_99 "Pour d'autres raisons"
	capture label variable knowledge_23_o "Autre raison"

*** health module indiviudals - this is for member index 1 ***
*** verify maximum number in data set ****
forvalues i = 1/57 {
    capture label variable health_5_2_`i' "Est-ce que [health-name] est tombe malade au cours des 12 derniers mois"
	capture label variable health_5_3_`i' "De quel type de maladie ou de blessure a-t-il/elle souffert"
	capture label variable health_5_3_1_`i' "Paludisme"
	capture label variable health_5_3_2_`i' "Bilharzoise"
	capture label variable health_5_3_3_`i' "Diarrhee"
	capture label variable health_5_3_4_`i' "Blessures"
	capture label variable health_5_3_5_`i' "Problemes dentaires"
	capture label variable health_5_3_6_`i' "Problemes de peau"
	capture label variable health_5_3_7_`i' "Problemes oculaires"
	capture label variable health_5_3_8_`i' "Problemes de gorge"
	capture label variable health_5_3_9_`i' "Maux d'estomac"
	capture label variable health_5_3_10_`i' "Fatigue"
	capture label variable health_5_3_11_`i' "IST"
	capture label variable health_5_3_12_`i' "trachome"
	capture label variable health_5_3_13_`i' "onchocercose"
	capture label variable health_5_3_14_`i' "filaroise lymphatique"
	capture label variable health_5_3_99_`i' "autres (a preciser)"
	capture label variable health_5_3_o_`i' "Autre maladie"
	capture label variable health_5_4_`i' "Combien de jours a-t-il/elle manque au travail/a l'ecole en raison d'une maladie ou d'une blessure au cours du dernier mois"
	capture label variable health_5_5_`i' "A-t-il/elle recu des medicaments pour le traitement de la schistosomiase au cours des 12 derniers mois"
	capture label variable health_5_6_`i' "Cette personne a-t-elle deja ete diagnostiquee avec la schistosomiase"
	capture label variable health_5_7_`i' "Cette personne a-t-elle ete affectee par la schistosomiase au cours des 12 derniers mois"
	capture label variable health_5_7_1_`i' "Cette personne a-t-elle eu de l'urine avec une coloration rose au cours des 12 derniers mois ?"
	capture label variable health_5_8_`i' "Cette personne a-t-elle eu du sang dans ses urines au cours des 12 derniers mois"
	capture label variable health_5_9_`i' "Cette personne a-t-elle eu du sang dans ses selles au cours des 12 derniers mois"
	capture label variable health_5_10_`i' "Avez-vous consulte quelqu'un pour une maladie au cours des 12 derniers mois"
	capture label variable health_5_11_`i' "Quel type de service de sante/professionnel de sante cette personne a-t-elle consulte en premier lieu"
	capture label variable health_5_11_o_`i' "Autre type de service de sante"
	capture label variable health_5_12_`i' "Quelle est la distance en km qui vous separe de ce service ou de ce professionnel de sante"
}

*** labels for health modules at the household level ***
	capture label variable health_5_13 "Avez-vous beneficie de campagnes de sensibilisation sur la schistosomiase au cours des cinq dernieres annees"
	capture label variable health_5_14_a "Manifestation de la bilharzoise"
	capture label variable health_5_14_b "Pratique pour eviter la bilharzose"
	capture label variable health_5_14_c "Mesurer a prendre pour le traitement de la bilharziose"

*** Assets module ***
	capture label variable list_actifs_1 "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Fer a repasser (electrique/non-eletrique)"
	capture label variable list_actifs_2 "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Machine a coudre"
	capture label variable list_actifs_3 "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Television"
	capture label variable list_actifs_4 "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Voiture"
	capture label variable list_actifs_5 "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Refridgerateur"
	capture label variable list_actifs_6 "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Radio"
	capture label variable list_actifs_7 "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Montre/horloge"
	capture label variable list_actifs_8 "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Lit ou matelas"
	capture label variable list_actifs_9 "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Velo"
	capture label variable list_actifs_10 "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Moto"
	capture label variable list_actifs_11 "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Table"
	capture label variable list_actifs_12 "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Chaise"
	capture label variable list_actifs_13 "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Climatiseur"
	capture label variable list_actifs_14 "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Ordinateur"
	capture label variable list_actifs_15 "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Telephone portable"
	capture label variable list_actifs_16 "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Maison"
	capture label variable _actif_number_1 "Combien de [actifs-name] est-ce que vous avez"
	capture label variable _actif_number_2 "Combien de [actifs-name] est-ce que vous avez"
	capture label variable _actif_number_3 "Combien de [actifs-name] est-ce que vous avez"
	capture label variable _actif_number_4 "Combien de [actifs-name] est-ce que vous avez"
	capture label variable _actif_number_5 "Combien de [actifs-name] est-ce que vous avez"
	capture label variable _actif_number_6 "Combien de [actifs-name] est-ce que vous avez"
	capture label variable _actif_number_7 "Combien de [actifs-name] est-ce que vous avez"
	capture label variable _actif_number_8 "Combien de [actifs-name] est-ce que vous avez"
	capture label variable _actif_number_9 "Combien de [actifs-name] est-ce que vous avez"
	capture label variable _actif_number_10 "Combien de [actifs-name] est-ce que vous avez"
	capture label variable _actif_number_11 "Combien de [actifs-name] est-ce que vous avez"
	capture label variable _actif_number_12 "Combien de [actifs-name] est-ce que vous avez"
	capture label variable _actif_number_13 "Combien de [actifs-name] est-ce que vous avez"
	capture label variable _actif_number_14 "Combien de [actifs-name] est-ce que vous avez"
	capture label variable list_actifs_o "Est-ce qu'il y a un autre actif que l'on a pas pris en compte"
	capture label variable actifs_o "Autre Actifs"
	capture label variable actifs_o_int "Combien de [actifs_o] est-ce que vous avez"
	capture label variable list_agri_equip_1 "Votre foyer dispose-t-il aujourd'hui de l'un des equipements suivants? En etat de marche - Charrue"
	capture label variable list_agri_equip_2 "Votre foyer dispose-t-il aujourd'hui de l'un des equipements suivants? En etat de marche - Arara"
	capture label variable list_agri_equip_3 "Votre foyer dispose-t-il aujourd'hui de l'un des equipements suivants? En etat de marche - Animaux de traits"
	capture label variable list_agri_equip_4 "Votre foyer dispose-t-il aujourd'hui de l'un des equipements suivants? En etat de marche - Charrette"
	capture label variable list_agri_equip_5 "Votre foyer dispose-t-il aujourd'hui de l'un des equipements suivants? En etat de marche - Tracteur"
	capture label variable list_agri_equip_6 "Votre foyer dispose-t-il aujourd'hui de l'un des equipements suivants? En etat de marche - Pulverisateur"
	capture label variable list_agri_equip_7 "Votre foyer dispose-t-il aujourd'hui de l'un des equipements suivants? En etat de marche - Groupe Motos Pompes (GMP)"
	capture label variable list_agri_equip_8 "Votre foyer dispose-t-il aujourd'hui de l'un des equipements suivants? En etat de marche - Houes"
	capture label variable list_agri_equip_9 "Votre foyer dispose-t-il aujourd'hui de l'un des equipements suivants? En etat de marche - Hilaires"
	capture label variable list_agri_equip_10 "Votre foyer dispose-t-il aujourd'hui de l'un des equipements suivants? En etat de marche - Daba/faucille"
	capture label variable list_agri_equip_11 "Votre foyer dispose-t-il aujourd'hui de l'un des equipements suivants? En etat de marche - Semoir"
	capture label variable list_agri_equip_12 "Votre foyer dispose-t-il aujourd'hui de l'un des equipements suivants? En etat de marche - Kadiandou"
	capture label variable list_agri_equip_13 "Votre foyer dispose-t-il aujourd'hui de l'un des equipements suivants? En etat de marche - Fanting"
	capture label variable list_agri_equip_14 "Votre foyer dispose-t-il aujourd'hui de l'un des equipements suivants? En etat de marche - Panneaux solaires"
	capture label variable _agri_number_1 "Combien de [agri-name] avez-vous eu" 
	capture label variable _agri_number_2 "Combien de [agri-name] avez-vous eu" 
	capture label variable _agri_number_3 "Combien de [agri-name] avez-vous eu" 
	capture label variable _agri_number_4 "Combien de [agri-name] avez-vous eu" 
	capture label variable _agri_number_5 "Combien de [agri-name] avez-vous eu" 
	capture label variable _agri_number_6 "Combien de [agri-name] avez-vous eu" 
	capture label variable _agri_number_7 "Combien de [agri-name] avez-vous eu" 
	capture label variable _agri_number_8 "Combien de [agri-name] avez-vous eu" 
	**KRM : R2 - not present
	*capture label variable _agri_number_9 "Combien de [agri-name] avez-vous eu" 
	*capture label variable _agri_number_10 "Combien de [agri-name] avez-vous eu" 
	capture label variable list_agri_equip_o "Est-ce qu'il y a un autre equipement agricole que l'on n'a pas pris en compte"
	capture label variable list_agri_equip_o_t "Autre liste"
	capture label variable list_agri_equip_int "Combien de [list_agri_equip_o_t] avez-vous eu"

*** Agriculture Inputs Module ***
	capture label variable agri_6_5 "Avez-vous loue la maison ou etes-vous le proprietaire"
	capture label variable agri_6_6 "Combien de pieces separees le menage possede-t-il"
	capture label variable agri_6_7 "Un membre de votre menage a-t-il un compte bancaire"
	capture label variable agri_6_8 "Un membre de votre menage participe-t-il a des mecanismes informels d'epargne et de credit (par exemple, des associations d'epargne et de credit ou des groupes rotatifs d'epargne et de credit)"
	capture label variable agri_6_9 "Un membre de votre menage fait-il partie d'un groupe de femmes du village"
	capture label variable agri_6_10 "Avez-vous un compte d'argent mobile (ex. Orange Money, Wave, Tigo Cash, Freemoney, K-PAYE)"
	capture label variable agri_6_11 "Si vous aviez besoin de 250 000 FCFA d'ici la semaine prochaine (pour une urgence medicale ou une autre dépense imprevue), seriez-vous en mesure de les obtenir"
	capture label variable agri_6_12 "Comment pourriez-vous obtenir cet argent (reponse a choix multiples)"
	capture label variable agri_6_12_1 "Emprunt bancaire"
	capture label variable agri_6_12_2 "Emprunter sur le compte epargne/pret du village (tontine, groupe de preteurs individuels, etc.)"
	capture label variable agri_6_12_3 "Emprunter aupres de voisins, d'amis ou de parents"
	capture label variable agri_6_12_4 "Utiliser son propre compte d'epargne"
	capture label variable agri_6_12_5 "Vendre des recoltes ou du betail"
	capture label variable agri_6_12_6 "Vendre d'autres biens ou proprietes"
	capture label variable agri_6_12_7 "Argent de poche/maison"
	capture label variable agri_6_12_99 " Autre (veuillez preciser)"
	capture label variable agri_6_12_o "Autre possibilite pour avoir l'argent"
	capture label variable agri_6_14 "Est-ce qu'au moins un membre du ménage a cultivé de la terre (y compris des cultures pérennes), qu'elle lui appartienne ou non, au cours de la dernière saison de culture"
	capture label variable agri_6_15 "Combien de parcelles a l'interieur des champs cultives par le menage"

*** parcel questions ****
*** Note: verify maximum in dataset ***
forvalues i=1/5 {
	capture label variable agri_6_16_`i' "Ordre de numeration du champ"
	capture label variable agri_6_17_`i' "Numero de la parcelle dans le champ"
	capture label variable agri_6_18_`i' "Quel est le mode de gestion de la parcelle"
	capture label variable agri_6_19_`i' "Quel est le numero d'ordre de la personne qui cultive la parcelle (utiliser les identifiants de la section B sur les caracteristiques demographiques du menage)"
	capture label variable agri_6_20_`i' "Quelle est la principale culture pratiquee sur cette parcelle au cours de la derniere periode de vegetation"
	capture label variable agri_6_20_o_`i' "Autre culture principale"
	capture label variable agri_6_21_`i' "Quelle est la superficie de la parcelle selon l'exploitant ? (Indiquer la superficie en hectares ou en metres carres avec deux decimales)"
	capture label variable agri_6_22_`i' "Unite"
	capture label variable agri_6_23_`i' "Quel est le mode d'occupation de cette parcelle"
	capture label variable agri_6_23_o_`i' "Autre mode d'occupation de cette parcelle"
	capture label variable agri_6_24_`i' "Quel est le numero d'ordre du proprietaire de la parcelle"
	capture label variable agri_6_25_`i' "Quel est le mode d'acquisition de cette parcelle"
	capture label variable agri_6_25_o_`i' "Autre mode d'acquisition de cetter parcelle"
	capture label variable agri_6_26_`i' "Disposez-vous d'un document legal (titre, acte, certificat, etc.) confirmant votre propriete sur cette parcelle"
	capture label variable agri_6_26_o_`i' "Autre document legal"
	capture label variable agri_6_27_`i' "Quels sont les membres du menage figurant sur ce document legal"
	capture label variable agri_6_27_1_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 1"
	capture label variable agri_6_27_2_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 2"
	capture label variable agri_6_27_3_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 3"
	capture label variable agri_6_27_4_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 4"
	capture label variable agri_6_27_5_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 5"
	capture label variable agri_6_27_6_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 6"
	capture label variable agri_6_27_7_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 7"
	capture label variable agri_6_27_8_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 8"
	capture label variable agri_6_27_9_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 9"
	capture label variable agri_6_27_10_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 10"
	capture label variable agri_6_27_11_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 11"
	capture label variable agri_6_27_12_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 12"
	capture label variable agri_6_27_13_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 13"
	capture label variable agri_6_27_14_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 14"
	capture label variable agri_6_27_15_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 15"
	capture label variable agri_6_27_16_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 16"
	capture label variable agri_6_27_17_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 17"
	capture label variable agri_6_27_18_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 18"
	capture label variable agri_6_27_19_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 19"
	capture label variable agri_6_27_20_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 20"
	capture label variable agri_6_27_21_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 21"
	capture label variable agri_6_27_22_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 22"
	capture label variable agri_6_27_23_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 23"
	capture label variable agri_6_27_24_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 24"
	capture label variable agri_6_27_25_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 25"
	capture label variable agri_6_27_26_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 26"
	capture label variable agri_6_27_27_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 27"
	capture label variable agri_6_27_28_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 28"
	capture label variable agri_6_27_29_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 29"
	capture label variable agri_6_27_30_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 30"
	capture label variable agri_6_27_31_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 31"
	capture label variable agri_6_27_32_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 32"
	capture label variable agri_6_27_33_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 33"
	capture label variable agri_6_27_34_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 34"
	capture label variable agri_6_27_35_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 35"
	capture label variable agri_6_27_36_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 36"
	capture label variable agri_6_27_37_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 37"
	capture label variable agri_6_27_38_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 38"
	capture label variable agri_6_27_39_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 39"
	capture label variable agri_6_27_40_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 40"
	capture label variable agri_6_27_41_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 41"
	capture label variable agri_6_27_42_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 42"
	capture label variable agri_6_27_43_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 43"
	capture label variable agri_6_27_44_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 44"
	capture label variable agri_6_27_45_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 45"
	capture label variable agri_6_27_46_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 46"
	capture label variable agri_6_27_47_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 47"
	capture label variable agri_6_27_48_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 48"
	capture label variable agri_6_27_49_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 49"
	capture label variable agri_6_27_50_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 50"
	capture label variable agri_6_27_51_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 51"
	capture label variable agri_6_27_52_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 52"
	capture label variable agri_6_27_53_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 53"
	capture label variable agri_6_27_54_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 54"
	capture label variable agri_6_27_55_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 55"
	capture label variable agri_6_27_56_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 56"
	capture label variable agri_6_27_57_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 57"
	capture label variable agri_6_27_58_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 58"
	capture label variable agri_6_27_59_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 59"
	capture label variable agri_6_27_60_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 60"
	capture label variable agri_6_28_`i' "Pensez-vous qu'il existe un risque de perdre les droits associes a cette parcelle dans les 5 prochaines annees"
	capture label variable agri_6_29_`i' "Quelle est la principale preoccupation"
	capture label variable agri_6_29_o_`i' "Autre type de preoccupation"
	capture label variable agri_6_30_`i' "Avez-vous utilise du fumier animal sur cette parcelle au cours de cette campagne agricole"
	capture label variable agri_6_31_`i' "Quelle a ete la principale methode d'acquisition de ce fumier"
	capture label variable agri_6_31_o_`i' "Autre methode d'acquisition de l'animale"
	capture label variable agri_6_32_`i' "Quelle quantite de fumier avez-vous appliquee sur la parcelle"
	capture label variable agri_6_33_`i' "Code Unite"
	capture label variable agri_6_33_o_`i' "Autre type de quantite"
	capture label variable agri_6_34_comp_`i' "Avez-vous utilise du compost sur cette parcelle durant cette campagne"
	capture label variable agri_6_34_`i' "Avez-vous utilise des dechets menagers et autres sur cette parcelle au cours de cette campagne agricole"
	capture label variable agri_6_35_`i' "Combien de fois avez-vous epandu des dechets menagers sur cette parcelle au cours de cette campagne agricole"
	capture label variable agri_6_36_`i' "Avez-vous utilise des engrais inorganiques/chimiques sur cette parcelle au cours de cette campagne agricole"
	capture label variable agri_6_37_`i' "Combien de fois avez-vous epandu des engrais inorganiques sur cette parcelle au cours de cette campagne agricole"
	capture label variable agri_6_38_a_`i' "Quelle quantite d'Uree avez-vous utilisee"
	capture label variable agri_6_38_a_code_`i' "Unite"
	capture label variable agri_6_38_a_code_o_`i' "Autre code"
	capture label variable agri_6_39_a_`i' "Quelle quantite de Phosphates avez-vous utilisee"
	capture label variable agri_6_39_a_code_`i' "Unite"
	capture label variable agri_6_39_a_code_o_`i' "Autre code"
	capture label variable agri_6_40_a_`i' "Quelle quantite de NPK/Formule unique avez-vous utilisee"
	capture label variable agri_6_40_a_code_`i' "Unite"
	capture label variable agri_6_40_a_code_o_`i' "Autre code"
	capture label variable agri_6_41_a_`i' "Quelle quantite d'autres engrais chimiques avez-vous utilisee"
	capture label variable agri_6_41_a_code_`i' "Unite"
	capture label variable agri_6_41_a_code_o_`i' "Autre code"
}

*** Agriculture Production Module ***
*** Cereals ***
local cereal1 "RIZ"
local cereal2 "MAIS"
local cereal3 "MIL"
local cereal4 "SORGHO"
local cereal5 "NIEBE"
local cereal6 "AUTRES CÉRÉALES"

*** Farines et Tubercules ***
local farine1 "FARINE MANIOC VERT"
local farine2 "MANIOC SÉCHÉ"
local farine3 "PATATES DOUCES"
local farine4 "POMMES DE TERRE"
local farine5 "IGNAME"
local farine6 "TARO"
local farine7 "AUTRES TUBERCULES"

*** Légumes ***
local legume1 "BRÈDES"
local legume2 "TOMATES"
local legume3 "CAROTTES"
local legume4 "OIGNONS"
local legume5 "CONCOMBRES"
local legume6 "POIVRONS"
local legume7 "AUTRES LÉGUMES"

*** Légumineuses Séchées ***
local legumineuse1 "ARACHIDES"
local legumineuse2 "HARICOTS SECS"
local legumineuse3 "POIS"
local legumineuse4 "LENTILLES"
local legumineuse5 "AUTRES LÉGUMINEUSES"

*** Végétation Aquatique ***
local aquatique1 "VÉGÉTATION AQUATIQUE"

*** Autres Cultures (User-Specified) ***
local autre1 "AUTRES CULTURES"
*** Agriculture Production Module ***
*** Cereals ***
forvalues i=1/6 {
    local cereal_name `cereal`i''  

    capture label variable cereals_consumption_`i' "Votre ménage a-t-il cultivé du `cereal_name' durant cette période?"
    capture label variable cereals_01_`i' "Superficie en hectare de `cereal_name'"
    capture label variable cereals_02_`i' "Production totale en 2023 (kg) de `cereal_name'"
    capture label variable cereals_03_`i' "Quantité autoconsommée en 2023 de `cereal_name'"
    capture label variable cereals_04_`i' "Quantité vendue en kg en 2023 de `cereal_name'"
    capture label variable cereals_05_`i' "Prix de vente actuel en FCFA/kg de `cereal_name'"
}

*** Farines et Tubercules ***
forvalues i=1/7 {
    local farine_name `farine`i''  

    capture label variable farine_tubercules_consumption_`i' "Votre ménage a-t-il cultivé du `farine_name' durant cette période?"
    capture label variable farines_01_`i' "Superficie en hectare de `farine_name'"
    capture label variable farines_02_`i' "Production totale en 2023 (kg) de `farine_name'"
    capture label variable farines_03_`i' "Quantité autoconsommée en 2023 de `farine_name'"
    capture label variable farines_04_`i' "Quantité vendue en kg en 2023 de `farine_name'"
    capture label variable farines_05_`i' "Prix de vente actuel en FCFA/kg de `farine_name'"
}

*** Légumes ***
forvalues i=1/7 {
    local legume_name `legume`i''  

    capture label variable legumes_consumption_`i' "Votre ménage a-t-il cultivé du `legume_name' durant cette période?"
    capture label variable legumes_01_`i' "Superficie en hectare de `legume_name'"
    capture label variable legumes_02_`i' "Production totale en 2023 (kg) de `legume_name'"
    capture label variable legumes_03_`i' "Quantité autoconsommée en 2023 de `legume_name'"
    capture label variable legumes_04_`i' "Quantité vendue en kg en 2023 de `legume_name'"
    capture label variable legumes_05_`i' "Prix de vente actuel en FCFA/kg de `legume_name'"
}

*** Légumineuses Séchées ***
forvalues i=1/5 {
    local legumineuse_name `legumineuse`i''  

    capture label variable legumineuses_consumption_`i' "Votre ménage a-t-il cultivé du `legumineuse_name' durant cette période?"
    capture label variable legumineuses_01_`i' "Superficie en hectare de `legumineuse_name'"
    capture label variable legumineuses_02_`i' "Production totale en 2023 (kg) de `legumineuse_name'"
    capture label variable legumineuses_03_`i' "Quantité autoconsommée en 2023 de `legumineuse_name'"
    capture label variable legumineuses_04_`i' "Quantité vendue en kg en 2023 de `legumineuse_name'"
    capture label variable legumineuses_05_`i' "Prix de vente actuel en FCFA/kg de `legumineuse_name'"
}

*** Végétation Aquatique ***
capture label variable aquatique_consumption_1 "Votre ménage a-t-il cultivé du `aquatique1' durant cette période?"
capture label variable aquatique_01_1 "Superficie en hectare de `aquatique1'"
capture label variable aquatique_02_1 "Production totale en 2023 (kg) de `aquatique1'"
capture label variable aquatique_03_1 "Quantité autoconsommée en 2023 de `aquatique1'"
capture label variable aquatique_04_1 "Quantité vendue en kg en 2023 de `aquatique1'"
capture label variable aquatique_05_1 "Prix de vente actuel en FCFA/kg de `aquatique1'"

*** Autres Cultures (User-Specified) ***
capture label variable autre_culture_yesno "Est-ce qu'il y a un autre type de culture?"
capture label variable autre_culture "Autre type de culture"
capture label variable o_culture_01 "Superficie en hectare de `autre1'"
capture label variable o_culture_02 "Production totale en 2023 (kg) de `autre1'"
capture label variable o_culture_03 "Quantité autoconsommée en 2023 de `autre1'"
capture label variable o_culture_04 "Quantité vendue en kg en 2023 de `autre1'"
capture label variable o_culture_05 "Prix de vente actuel en FCFA/kg de `autre1'"


*** Food consumption module ***
	capture label variable food01 "Dans les douze (12) derniers mois, combien de mois a dure la periode de soudure"
	capture label variable food02 "Avez-vous (ou un membre de votre famille) exerce un travail remunere pendant cette période pour faire face a la periode de soudure"
	capture label variable food03 "Avez-vous vendu des biens pour subvenir a vos besoins pendant cette periode"
	capture label variable food05 "Le betail"
	capture label variable food06 "Les charrettes"
	capture label variable food07 "Les outils de production"
	capture label variable food08 "Biens materiels"
	capture label variable food09 "Puiser dans d'autres ressources (par exemple, un magasin)"
	capture label variable food10 "Autres, veuillez preciser"
	capture label variable food11 "Des membres du ménage ont-ils migre pendant cette periode en raison de la periode de soudure"
	capture label variable food12 "Avez-vous saute des repas pendant la journee en raison de la periode de soudure"

*** Household Income module ***
	capture label variable agri_income_01 "Avez-vous (ou un membre de votre menage) effectue un travail remunere au cours des 12 derniers mois"
	capture label variable agri_income_02 "De quel type de travail s'agissait-il (s'agissaient-ils)"
	capture label variable agri_income_02_o "Autre type de travail"
	capture label variable agri_income_03 "Quelle est la duree de ce travail (frequence) dans les derniers 12 mois"
	capture label variable agri_income_04 "Unite de temps"
	capture label variable agri_income_05 "Montant recu en nature et/ou en especes (FCFA) pour ce travail"
	capture label variable agri_income_06 "Quel a ete le montant total (en FCFA) des depenses engagees pour ce travail (transport, nourriture, etc.)"
	capture label variable species "Quelles especes les proprietaires possedent-ils"
	capture label variable species_1 "Bovins"
	capture label variable species_2 "Mouton"
	capture label variable species_3 "Chevre"
	capture label variable species_4 "Cheval (equide)"
	capture label variable species_5 "Ane"
	capture label variable species_6 "Animaux de trait"
	capture label variable species_7 "Porcs"
	capture label variable species_8 "Volaille"

*** Livestock ownership questions ***
*** Note: verify max i  ***

forvalues i=1/7 {
	capture label variable agri_income_07_`i' "Nombre de tetes de [species-name] actuellement"
	capture label variable agri_income_08_`i' "Nombre de tetes de [species-name] vendues (cette annee)"
	capture label variable agri_income_09_`i' " Principales raisons de la vente de [species-name]"
	capture label variable agri_income_09_o_`i' "Autre raison de vendre"
	capture label variable agri_income_10_`i' "Prix moyen par tete de [species-name] en FCFA"
}

	capture label variable agri_income_07_o "Nombre de tetes de [species_o] actuellement"
	capture label variable agri_income_08_o "Nombre de tetes de [species_o] vendues (cette annee)"
	capture label variable agri_income_09_o_o "Principales raisons de la vente de [species_o]"
	capture label variable agri_income_09_o_o_o "Autre raison de vendre"
	capture label variable agri_income_10_o "Prix moyen par tete de [species_o] en FCFA"
	capture label variable animals_sales "Revenues de l'elevage"
	capture label variable animals_sales_1 "Bovins"
	capture label variable animals_sales_2 "Mouton"
	capture label variable animals_sales_3 "Chevre"
	capture label variable animals_sales_4 "Cheval (equide)"
	capture label variable animals_sales_5 "Ane"
	capture label variable animals_sales_6 "Animaux de trait"
	capture label variable animals_sales_7 "Porcs"
	capture label variable animals_sales_8 "Volaille"
	capture label variable animals_sales_o "Est-ce qu'il y a d'autres animaux vendus par le menage"
	capture label variable animals_sales_t "Autre animal vendu par le menage"

*** Livestock/animal product sales quesitons ***
*** Note: verify maximum value in data ***

forvalues i=1/4 {
	capture label variable agri_income_11_`i' "Nombre de tetes de [sale_animales-name] vendus"
	capture label variable agri_income_12_`i' "Montant total en FCFA pour la vente de [sale_animales-name]"
	capture label variable agri_income_13_`i' "Nature des produits provenant de [sale_animales-name] vendus"
	capture label variable agri_income_13_1_`i' "Lait"
	capture label variable agri_income_13_2_`i' "Le beurre"
	capture label variable agri_income_13_3_`i' "Le fumier"
	capture label variable agri_income_13_99_`i' "Autres"
	capture label variable agri_income_14_`i' "Montant en FCFA du total de vente pour les produits provenant de [sale_animales-name]"
	capture label variable agri_income_13_autre_`i' "Autre nature"
}

	capture label variable agri_income_11_o "Nombre de tetes de [animals_sales_t] vendus"
	capture label variable agri_income_12_o "Montant total en FCFA pour la vente de [animals_sales_t]"
	capture label variable agri_income_13_o "Nature des produits provenant de [animals_sales_t] vendus"
	capture label variable agri_income_13_o_1 "Lait"
	capture label variable agri_income_13_o_2 "Le beurre"
	capture label variable agri_income_13_o_3 "Le fumier"
	capture label variable agri_income_13_o_99 "Autres"
	capture label variable agri_income_14_o "Montant en FCFA du total de vente pour les produits provenant de [animals_sales_t]"
	capture label variable agri_income_13_o_t "Autre nature"
	capture label variable agri_income_15 "Avez-vous des employes pour vos activites agricoles"
	capture label variable agri_income_16 "Si oui, veuillez en preciser le nombre"

	capture label variable agri_income_17 "Ces employes sont-ils remuneres"
	capture label variable agri_income_18 "Comment sont-ils payes"
	capture label variable agri_income_18_o "Autre type de paiement"
	capture label variable agri_income_19 "Quel est le montant total de la remuneration dans les 12 derniers mois pour tous travailleurs (argent plus en nature)"
	capture label variable agri_income_20 "Type d'activite non agricole"
	capture label variable agri_income_20_1 "Peche"
	capture label variable agri_income_20_2 "Sylviculture"
	capture label variable agri_income_20_3 "Artisanat"
	capture label variable agri_income_20_4 "Commerce"
	capture label variable agri_income_20_5 "Services"
	capture label variable agri_income_20_6 "Emploi salaire"
	capture label variable agri_income_20_7 "Transport"
	capture label variable agri_income_20_8 "Recolte"
	capture label variable agri_income_20_t "Est-ce qu'il y a d'autres activites non agricoles"
	capture label variable agri_income_20_o "Autre type d'activites non agricoles"

*** Revenu non agricole types ***
*** Note: verify maximum in data ***
forvalues i=1/4{
	capture label variable agri_income_21_h_`i' "Nombre de personnes impliquees dans [agri_income_20-name] (Homme)"
	capture label variable agri_income_21_f_`i' "Nombre de personnes impliquees dans [agri_income_20-name] (Femme)"
	capture label variable agri_income_22_`i' "Frequence de [agri_income_20-name] par an (nombre de mois)"
	capture label variable agri_income_23_`i' "Revenus par frequence (par [agri_income_22] mois)"
	capture label variable agri_income_24_`i' "Revenue annuel total"
}

	capture label variable agri_income_21_h_o "Nombre de personnes impliquees dans [agri_income_20_o] (Homme)"
	capture label variable agri_income_21_f_o "Nombre de personnes impliquees dans [agri_income_20_o] (Femme)"
	capture label variable agri_income_22_o "Frequence de [agri_income_20_o] par an (nombre de mois)" 
	capture label variable agri_income_23_o "Revenus par frequence (par [agri_income_22_o] mois)"
	capture label variable agri_income_25 "Avez-vous des employes pour vos activites non agricoles"
	capture label variable agri_income_26 "Si oui, veuillez en preciser le nombre"


	capture label variable agri_income_27 "Ces employes sont-ils remuneres"
	capture label variable agri_income_28 "Comment sont-ils payes"
	capture label variable agri_income_28_1 "En nature"
	capture label variable agri_income_28_2 "En argent"
	capture label variable agri_income_28_3 "Autre"
	capture label variable agri_income_28_o "Autre mode de paiement"
	capture label variable agri_income_29 "Quel est le montant total de la remuneration dans les 12 derniers mois pour tous travailleurs (argent plus en nature)"
	capture label variable agri_income_30 "Certains membres de votre menage migrent-ils a l'interieur ou à l'exterieur du pays"
	capture label variable agri_income_31 "Si oui, ou sont-ils ? (Choix multiple possible s'il y a plusieurs personnes dans une autre zone)"
	capture label variable agri_income_31_1 "Un autre region du Senegal"
	capture label variable agri_income_31_2 "Autres pays d'Afrique"
	capture label variable agri_income_31_3 "Europe"
	capture label variable agri_income_31_4 "Amerique"
	capture label variable agri_income_31_5 "Asie"
	capture label variable agri_income_31_6 "Autre regions"
	capture label variable agri_income_31_o "Autre zone de migration"
	capture label variable agri_income_32 "Si oui, envoient-ils de l'argent pour les besoins du menage"
	capture label variable agri_income_33 "Si oui, combien avez-vous recu au total au cours des 12 derniers mois"
	capture label variable agri_income_34 "Avez-vous (ou un membre de votre menage) contracte un prêt au cours des douze (12) derniers mois"
	capture label variable agri_income_35 "Si non, pourquoi ne l'avez-vous pas fait"
	capture label variable agri_income_name "Choisissez les membres de votre menage qui ont contracte un pret"

*** Credit roster questions ***
*** Note: verify maximum in data ***

forvalues i=1/5{
	capture label variable agri_income_36_`i' "Quel montant de ce pret [credit_ask-name] a t'il contracte"
	capture label variable agri_income_37_`i' "Aupres de qui [credit_ask-name] a t'il contracte ce pret"
	capture label variable agri_income_38_`i' "Quel est le montant de ce pret que [credit_ask-name] deja rembourse"
	capture label variable agri_income_39_`i' "Quel est le montant de ce pret que [credit_ask-name] reste a payer"
}

	capture label variable agri_loan_name "Choisissez les membres de votre menage qui ont prete de l'argent a d'autres personnes"

*** Loan roster questions - right now only one in the data set but my need a loop ***
	capture label variable agri_income_41_1 "Quel est le montant que [loan-name] a prete a d'autres personnes"
	capture label variable agri_income_42_1 "Quel est le montant prete par [loan-name] a d'autres personnes deja paye"
	capture label variable agri_income_43_1 "Quel est le montant prete par [loan-name] a d'autres personnes encore du"
*** DROPPED VAR ***
*capture label variable agri_income_44_1 "Quelle est la valeur nette des transferts effectués au cours des 12 derniers mois"

	capture label variable product_divers "Quelles sont les depenses globales du menage au cours des quatre derniers mois, les sources de financement ou les pratiques que vous developpez pour repondre a ces besoins, et qui sont les responsables de ces besoins de financement au sein du menage"
	capture label variable product_divers_1 "Alimentation (produits alimentaires)"
	capture label variable product_divers_2 "La sante"
	capture label variable product_divers_3 "L'education"
	capture label variable product_divers_4 "Eau/Electricite pour le menage"
	capture label variable product_divers_5 "Logement/transport"
	capture label variable product_divers_6 "Depenses pour les appareils menagers et le mobilier"
	capture label variable product_divers_7 "Autres investissements non agricoles"
	capture label variable product_divers_8 "Depenses de construction, de reparation et de modification"
	capture label variable product_divers_9 "Acquisition de moyens de transport"
	capture label variable product_divers_10 "Depenses pour l'habillement et les chaussures du menage"
	capture label variable product_divers_11 "Depenses de reparation et d'achat de divers articles menagers"
	capture label variable product_divers_12 "Depenses pour les ceremonies menageres/acquisition de bijoux et de pierres precieuses"
	capture label variable product_divers_13 "Autres depenses (cadeaux, dons, aides, tabac, alcool, taxes, amendes, assurances)"
	capture label variable product_divers_14 "Frais de telephone/Wifi"
	capture label variable product_divers_99 "Autres depenses"

*** product questions ***
*** Note: verify maximum in data ***
forvalues i=1/15{
	capture label variable agri_income_45_`i' "Montant en [product-name]"
	capture label variable agri_income_46_`i' "Source de finacement (choix multiples)"
	capture label variable agri_income_46_1_`i' "Le credit"
	capture label variable agri_income_46_2_`i' "Revenus propres"
	capture label variable agri_income_46_3_`i' "Dons"
	capture label variable agri_income_46_4_`i' "Autres"
	capture label variable agri_income_46_o_`i' "Autre source de financement"
}

	capture label variable expenses_goods "Types de dépenses"
	capture label variable expenses_goods_1 "Engrais"
	capture label variable expenses_goods_2 "Aliments pour le betail"
	capture label variable expenses_goods_t "Est-ce qu'il y a d'autre type de depense"
	capture label variable expenses_goods_o "Autre a preciser"
	capture label variable agri_income_47_1 "Montant (KG) de [goods-name]"
	capture label variable agri_income_48_1 "Qunatite (FCFA)"
	capture label variable agri_income_47_2 "Montant (KG) de [goods-name]"
	capture label variable agri_income_48_2 "Qunatite (FCFA)"
	capture label variable agri_income_47_o "Montant (KG) de [expenses_goods_o]"
	capture label variable agri_income_48_o "Qunatite (FCFA)"

*** Living standards section ***
	capture label variable living_01 "Quelle est la principale source d'approvisionnement en eau potable"
	capture label variable living_01_o "Autre source d'approvisionnement en eau"
	capture label variable living_02 "L'eau utilisee est-elle traitee dans le menage"
	capture label variable living_03 "Si oui, comment l'eau est-elle traitee"
	capture label variable living_03_o "Autre type de traitement de l'eau"
	capture label variable living_04 "Quel est le principal type de toilettes utilise par votre menage"
	capture label variable living_04_o "Autre type de toilettes"
	capture label variable living_05 "Quel est le principal combustible utilise pour la cuisine"
	capture label variable living_05_o "Autre type de combustible"
	capture label variable living_06 "Quel est le principal combustible utilise pour l'eclairage"
	capture label variable living_06_o "Autre type de combustible utilise pour l'eclairage"

*** Beleifs section ***
	capture label variable beliefs_01 "Quelle est la probabilite que vous contractiez la bilharziose au cours des 12 prochains mois"
	capture label variable beliefs_02 "Quelle est la probabilite qu'un membre de votre menage contracte la bilharziose au cours des 12 prochains mois"
	capture label variable beliefs_03 "Quelle est la probabilite qu'un enfant choisi au hasard dans votre village, age de 5 a 14 ans, contracte la bilharziose au cours des 12 prochains mois"
	capture label variable beliefs_04 "Dans quelle mesure etes-vous d'accord avec l'affirmation suivante : Les terres de ce village devraient appartenir a la communaute et non a des individus"
	capture label variable beliefs_05 "Dans quelle mesure etes-vous d'accord avec l'affirmation suivante : Les sources d'eau de ce village devraient appartenir a la communaute et non aux individus"
	capture label variable beliefs_06 "Dans quelle mesure etes-vous d'accord avec l'affirmation suivante : Si je travaille sur mes propres terres, j'ai le droit d'utiliser les produits que j'ai obtenus grace a mon travail."
	capture label variable beliefs_07 "Dans quelle mesure etes-vous d'accord avec l'affirmation suivante : Si je travaille sur des terres appartenant a la communaute, j'ai le droit d'utiliser les produits que j'ai obtenus par mon travail."
	capture label variable beliefs_08 "Dans quelle mesure etes-vous d'accord avec l'affirmation suivante : Si je peche dans une source d'eau appartenant a la communaute, j'ai le droit d'utiliser les produits que j'ai obtenus par mon travail."
	capture label variable beliefs_09 "Dans quelle mesure êtes-vous d'accord avec l'affirmation suivante : Si je recolte des produits dans une source d'eau appartenant a la communaute, j'ai le droit d'utiliser les produits que j'ai obtenus par mon travail."


*** Enumerator Observations ***
	capture label variable enum_01 "D'autres personnes que les repondants ont-elles suivi l'entretien"
	capture label variable enum_02 "Combien de personnes environ ont observe l'entretien"
	capture label variable enum_03 "Quels sont les materiaux principaux utilises pour le toit de la maison ou dort le chef de famille"
	capture label variable enum_03_o "Autre type de materiaux pour le toit"
	capture label variable enum_04 "Quels sont les materiaux principaux utilises pour les murs de la maison ou dort le chef de famille"
	capture label variable enum_04_o "Autre type de materiaux pour les murs"
	capture label variable enum_05 "S'il a ete observe, quels sont les materiaux principaux du sol principal de la maison ou dort le chef de famille"
	capture label variable enum_05_o "Autre type de materiaux pour le sol"
	capture label variable enum_06 "Comment evaluez-vous la comprehension globale des questions par le repondant"
	capture label variable enum_07 "Veuillez indiquer les parties difficiles"
	capture label variable enum_08 "Veuillez donner votre avis sur le revenu du menage"

***========================================================================================*** Data Checks ***========================================================================================***

*********** COUNT THE NUMBER OF OBSERVATIONS PER VILLAGE *******************
preserve 

*** sort data by village ***
sort village_select 

*** generate total observations per village *** 
by village_select: gen total_hh = _N

*** generate unique household integer in the village ***
by village_select: gen hh_num = _n 

*** generate no consent per village number ***
gen no_consent = (consent == 0)
egen total_no_consent = total(no_consent), by(village_select)

*** generate total observations per village ***
gen village_observations = total_hh - total_no_consent 

*** collapse data to villages and print number of observations per village *** 
collapse (max) village_observations =  village_observations, by(village_select)

********************* UPDATE WITH DATE *****************************
*export excel "$village_observations\Village_Observations.xlsx", firstrow(variables)

restore

************************************ HOUSEHOLD ROSTER **********************************
***>>>>>>>>>>>>>>>>>>>>>>>>>>>>***** Important! *****<<<<<<<<<<<<<<<<<<<<<<<<<<<<<***
		*Please verify the max value for each of the loops to ensure we're capturing all of the variables.

*** check individual identificaiton data for missing values *** 

*** Locate HHs with missing hhids

 ** hh_date – check that there is a text entry

    preserve 

		
	*** generate indicator variable ***   
	gen ind_var = 0
    replace ind_var = 1  if missing(hh_date)
 
    	* keep and add variables to export *    **** CHECKED (NEEDS TO BE REQUIRED ON SURVEY CTO)
	keep if ind_var == 1 	
	generate issue =  "Missing value"
	generate issue_variable_name = "hh_date"
	rename hh_date print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$household_roster\Issue_HH_Roster_hh_date.dta", replace
	}
  
    restore
	
	** correct_hh – check that it = 1
    preserve 

			*** generate indicator variable ***    *** CHECKED (NEEDS TO BE REQUIRED ON SURVEY CTO)
	gen ind_var = 0
    replace ind_var = 1 if correct_hh != 1
 
    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Missing value"
	generate issue_variable_name = "correct_hh"
	rename correct_hh print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$household_roster\Issue_HH_Roster_correct_hh.dta", replace
	}
  
    restore

	
	** count_chefs  - check that it = 1
		
	preserve 

			*** generate indicator variable ***    *** CHECKED
	gen ind_var = 0
    replace ind_var = 1 if count_chefs != 1
 
    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Missing value"
	generate issue_variable_name = "count_chefs"
	rename count_chefs print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$household_roster\Issue_HH_Roster_count_chefs.dta", replace
	}
  
    restore

** hh_time – check that there is a text entry

    preserve 

		
	*** generate indicator variable ***   *** CHECKED (NEEDS TO BE REQUIRED ON SURVEY CTO)
	gen ind_var = 0
    replace ind_var = 1  if missing(hh_time)
 
    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Missing value"
	generate issue_variable_name = "hh_time"
	rename hh_time print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$household_roster\Issue_HH_Roster_hh_time.dta", replace
	}
  
    restore


** hh_gpslatitude – check that there is a numeric entry 
** KRM - checking if it's missing, if there's a non-numeric value the var will be a string and will fail the check 

    preserve 

		
	*** generate indicator variable ***    *** CHECKED
	gen ind_var = 0
	replace ind_var = 1 if missing(hh_gpslatitude)


    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Missing value"
	generate issue_variable_name = "hh_gpslatitude"
	rename hh_gpslatitude print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$household_roster\Issue_HH_Roster_hh_gpslatitude.dta", replace
	}
  
    restore

	** hh_gpslongitude – check that there is a numeric entry
	** KRM - checking if it's missing, if there's a non-numeric value the var will be a string and will fail the check 

    preserve 

		
	*** generate indicator variable ***   **** CHECKED
	gen ind_var = 0
	replace ind_var = 1 if missing(hh_gpslongitude)


    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Missing value"
	generate issue_variable_name = "hh_gpslongitude"
	rename hh_gpslongitude print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$household_roster\Issue_HH_Roster_hh_gpslongitude.dta", replace
	}
  
    restore
	
	** hh_gpsaltitude – check that there is a numeric entry
	** KRM - checking if it's missing, if there's a non-numeric value the var will be a string and will fail the check    *** CHECKED

    preserve 

		
	*** generate indicator variable ***
	gen ind_var = 0
	replace ind_var = 1 if missing(hh_gpsaltitude)


    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Missing value"
	generate issue_variable_name = "hh_gpsaltitude"
	rename hh_gpsaltitude print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$household_roster\Issue_HH_Roster_hh_gpsaltitude.dta", replace
	}
  
    restore

	** hh_gpsaccuracy – check that there is a numeric entry
	** KRM - checking if it's missing, if there's a non-numeric value the var will be a string and will fail the check  *** CHECKED
	 preserve 

		
	*** generate indicator variable ***
	gen ind_var = 0
	replace ind_var = 1 if missing(hh_gpsaccuracy)


    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Missing value"
	generate issue_variable_name = "hh_gpsaccuracy"
	rename hh_gpsaccuracy print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$household_roster\Issue_HH_Roster_hh_gpsaccuracy.dta", replace
	}
  
    restore
	
	** Check phone number - add check for valid phone numbers, should be 300000000- 309999999, 330000000-339999999, 700000000-709999999, 750000000-789999999 
	
preserve  

	*** generate indicator variable ***  *** CHECKED
	gen ind_var = 0  
	replace ind_var = 1 if missing(hh_phone)  

	*** Check if phone number is within valid ranges ***  
	replace ind_var = 1 if !inrange(hh_phone, 300000000, 309999999) & ///
							 !inrange(hh_phone, 330000000, 339999999) & ///
							 !inrange(hh_phone, 700000000, 709999999) & ///
							 !inrange(hh_phone, 750000000, 789999999)  

	* keep and add variables to export *  
	keep if ind_var == 1  
	generate issue = "Invalid or missing phone number"  
	generate issue_variable_name = "hh_phone"  
	gen print_issue = hh_phone  
	tostring(print_issue), replace  

	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	
	
	* Export the dataset to Excel conditional on there being an issue  
	if _N > 0 {  
		save "$household_roster\Issue_HH_Roster_hh_phone.dta", replace  
	}  

restore  


	
	** check houshold roster respondent age **** CHECKED (PHONE NUMBERS COMING IN HERE. ONE AGE AS 91... prolly valid?)

    preserve 

	*** drop no consent households *** 
	drop if consent == 0 
	
	*** generate indicator variable ***
	gen ind_var = 0
    replace ind_var = 1  if hh_age_resp < 0 | hh_age_resp > 100  
 
    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Unreasonable value"
	generate issue_variable_name = "hh_age_resp"
	rename hh_age_resp print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$household_roster\Issue_HH_Roster_hh_age_resp.dta", replace
	}
  
    restore

  ** hh_name_complet_resp – check that there is a text entry here  // CHECKED
  
   
    preserve 

		
	*** generate indicator variable ***
	gen ind_var = 0
    replace ind_var = 1  if missing(hh_name_complet_resp)
 
    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Missing value"
	generate issue_variable_name = "hh_name_complet_resp"
	rename hh_age_resp print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$household_roster\Issue_HH_Roster_hh_name_complet_resp.dta", replace
	}
  
    restore
  
  * check that we have names for new respondends   **** CHECKED (ONE OUTPUT THAT HAS "1" INSTEAD OF TXT)

    preserve 

	*** drop no consent households ***    
	drop if consent == 0 
	
	*** generate indicator variable ***
	gen ind_var = 0
    replace ind_var = 1 if hh_name_complet_resp == "999" & missing(hh_name_complet_resp_new) 
	replace ind_var = 1 if hh_name_complet_resp == "999" & !regexm(hh_name_complet_resp_new, "[A-Za-z]")

    
    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Missing name"
	generate issue_variable_name = "hh_name_complet_resp_new"
	generate print_issue = "hh_name_complet_resp_new"
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$household_roster\Issue_HH_Roster_hh_name_complet_resp_new.dta", replace
	}
  
    restore

	
	** attend_training: for treatment groups, check that the answer is 0, 1, or 2  *** CHECKED
	
	   
    preserve 

	*** drop no consent households *** 
	drop if consent == 0 
	keep if grappe_int == 1
		
	*** generate indicator variable ***
	gen ind_var = 0
    replace ind_var = 1 if attend_training != 0 & attend_training != 1 & attend_training != 2
 
    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Attend_training needs to = 0, 1, or 2"
	generate issue_variable_name = "attend_training"
	rename attend_training print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$household_roster\Issue_HH_Roster_Attend_training.dta", replace
	}
  
    restore

	
		**  training_id – when who_attended_training = 1, check that there is a text entry *** CHECKED
    preserve 

	*** drop no consent households *** 
	drop if consent == 0 
	keep if grappe_int == 1
		
	*** generate indicator variable ***
	gen ind_var = 0
    replace ind_var = 1 if who_attended_training == 1 & missing(training_id)
 
    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Missing ID"
	generate issue_variable_name = "training_id"
	rename training_id print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$household_roster\Issue_HH_Roster_training_id.dta", replace
	}
  
    restore

	
	** heard_training – for treatment groups, check that the answer is 0, 1, or 2  *** CHECKED
	
	preserve 

	*** drop no consent households *** 
	drop if consent == 0 
	keep if grappe_int == 1
		
	*** generate indicator variable ***
	gen ind_var = 0
	replace ind_var = 1 if heard_training != 0 & heard_training != 1 & heard_training != 2
 
    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "heard_training needs to = 0, 1, or 2"
	generate issue_variable_name = "heard_training"
	rename heard_training print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$household_roster\Issue_HH_Roster_heard_training.dta", replace
	}
  
    restore
	
	
	
	** who_attended_training – for treatment groups, check that the answer is 0, 1, or 2  ***CHECKED
	
	preserve 

	*** drop no consent households *** 
	drop if consent == 0 
	keep if grappe_int == 1
		
	*** generate indicator variable ***
	gen ind_var = 0
	replace ind_var = 1 if who_attended_training != 0 & who_attended_training != 1 & who_attended_training != 2
 
    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "who_attended_training needs to = 0, 1, or 2"
	generate issue_variable_name = "who_attended_training"
	rename who_attended_training print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$household_roster\Issue_HH_Roster_who_attended_training.dta", replace
	}
  
    restore
	
	** still_member – add check that is 0, 1  or 2 - will filter if the name from baseline is empty **** CHECKED
	
	forvalues i = 1/57 {

    preserve 

	*** drop no consent households *** 
	drop if consent == 0 
	
    local still_member still_member_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	local add_new add_new_`i'
	tostring(`pull_hh_full_name_calc'), replace 
	keep if `pull_hh_full_name_calc' != ""
	keep if `pull_hh_full_name_calc' != "."
	*** generate indicator variable ***
	gen ind_var = 0
	replace ind_var = 1 if `still_member' != 0 & `still_member' != 1 & `still_member' != 2
	*replace ind_var = 0 if _household_roster_count < `i'

/*
	replace ind_var = 0 if `add_new' == 0
	replace ind_var = 0 if `add_new' == 1
	replace ind_var = 0 if _household_roster_count < `i'
*/
	*replace ind_var = 0 if _household_roster_count < `i'
    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Unreasonable value"
	generate issue_variable_name = "still_member_`i'"
	
	
	rename `pull_hh_full_name_calc' hh_member_name
	rename `still_member' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$household_roster\Issue_Household_`still_member'.dta", replace
    }
  
    restore
}	
	
	
	** newmem_why_ - check that for new members, the response should be 1, 2, 3, 4, or 10 *** CHECKED
	
	forvalues i = 1/57 {

    preserve 

	*** drop no consent households *** 
	drop if consent == 0 
	
	local add_new add_new_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i'
	rename `pull_hh_full_name_calc' hh_member_name
	tostring(hh_member_name), replace 
	keep if hh_member_name != ""
	keep if hh_member_name != "."
	*** generate indicator variable ***

	keep if `add_new' == 1
	gen ind_var = 0
    replace ind_var = 1 if !inlist(newmem_why_`i', 1, 2, 3, 4, 10 )
	replace ind_var = 1 if missing(newmem_why_`i')
	
	  
    *drop if still_member_`i' == 0
    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Unreasonable value"
	generate issue_variable_name = "newmem_why_`i'"
	
	rename newmem_why_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$household_roster\Issue_Household_newmem_why_`i'.dta", replace
    }
  
    restore
}	
	
	

	
** still_member_whynot – add check that there is a response of 1,2,3,4,5,6,7,8,9,11 or -777 when still_member == 0  **** CHECKED

forvalues i = 1/57 {
    preserve

    *** Drop households with no consent ***
    drop if consent == 0
    
    local still_member still_member_`i'
    local pull_hh_full_name_calc pull_hh_full_name_calc__`i'
    rename `pull_hh_full_name_calc' hh_member_name
	tostring(hh_member_name), replace 
	keep if hh_member_name != ""
	keep if hh_member_name != "."
	

    *** Generate indicator variable ***
    gen ind_var = 0

    * Check for unreasonable still_member values and valid still_member_whynot values when still_member == 0 *
    
	keep if `still_member' == 0 
    replace ind_var = 1 if !inlist(still_member_whynot_`i', 1, 2, 3, 4, 5, 6, 7, 8, 9, 11, -777) 
	replace ind_var = 1 if missing(still_member_whynot_`i')

    *** Keep only flagged cases ***
    keep if ind_var == 1  	


    generate issue = "Unreasonable value"
    generate issue_variable_name = "still_member_whynot_`i'"

    rename still_member_whynot_`i' print_issue
    tostring(print_issue), replace

    keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key

    * Export the dataset to Excel conditional on there being an issue *
    if _N > 0 {
        save "$household_roster/Issue_HH_Roster_still_member_whynot_`i'.dta", replace
    }

    restore
}

	
** still_member_whynot_o – add check that there is a text entry when still_member_whynot == -777  *** CHECKED


forvalues i = 1/57 {
    preserve

    *** Drop households with no consent ***
    drop if consent == 0
    
    local still_member_whynot_o still_member_whynot_o_`i'
	local still_member_whynot still_member_whynot_`i'
    local pull_hh_full_name_calc pull_hh_full_name_calc__`i'
    rename `pull_hh_full_name_calc' hh_member_name
	tostring `still_member_whynot_o', replace 
	tostring(hh_member_name), replace 
	keep if hh_member_name != ""
	keep if hh_member_name != "."

    *** Generate indicator variable ***
    gen ind_var = 0

    * Check for unreasonable values 
    
    keep if `still_member_whynot' == -777 
	replace ind_var = 1 if `still_member_whynot_o' == ""

    *** Keep only flagged cases ***
    keep if ind_var == 1  	

    generate issue = "Unreasonable value"
    generate issue_variable_name = "still_member_whynot_o_`i'"

    rename `still_member_whynot_o' print_issue
    tostring(print_issue), replace

    keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key

    * Export the dataset to Excel conditional on there being an issue *
    if _N > 0 {
        save "$household_roster/Issue_HH_Roster_still_member_whynot_o_`i'.dta", replace
    }

    restore
}

	
** hh_presence_winter – check that there is a response for each household member and is 0, 1, or 2  *** CHECKED



	forvalues i = 1/57 {

    preserve 

	*** drop no consent households *** 
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 2
	drop if add_new_`i' == 0
	
    local hh_presence_winter hh_presence_winter_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i'
	rename `pull_hh_full_name_calc' hh_member_name
	*** generate indicator variable ***

	gen ind_var = 0
	replace ind_var = 1  if missing(`hh_presence_winter' )
    replace ind_var = 1  if `hh_presence_winter' != 0 & `hh_presence_winter' != 1  & `hh_presence_winter' != 2
 	replace ind_var = 0 if _household_roster_count < `i'  
   
    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Unreasonable value"
	generate issue_variable_name = "hh_presence_winter_`i'"
	
	rename `hh_presence_winter' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$household_roster\Issue_HH_Roster_`hh_presence_winter'.dta", replace
    }
  
    restore
}	
	
** hh_presence_dry – check that there is a response for each household member and is 0, 1, or 2  *** CHECKED
**KRM - check this too 

	forvalues i = 1/57 {

    preserve 

	*** drop no consent households *** 
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 2
	drop if add_new_`i' == 0
	
    local hh_presence_dry hh_presence_dry_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i'
	rename `pull_hh_full_name_calc' hh_member_name
	*** generate indicator variable ***

	gen ind_var = 0
	replace ind_var = 1  if missing(`hh_presence_dry' )
    replace ind_var = 1  if `hh_presence_dry' != 0 & `hh_presence_dry' != 1  & `hh_presence_dry' != 2
 	replace ind_var = 0 if _household_roster_count < `i'  
   
    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Unreasonable value"
	generate issue_variable_name = "hh_presence_dry_`i'"
	
	rename `hh_presence_dry' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$household_roster\Issue_HH_Roster_`hh_presence_dry'.dta", replace
    }
  
    restore
}	
		** hh_active_agri – check that there is a response for each household member and is 0, 1, or 2  *** CHECKED
		
	forvalues i = 1/57 {

    preserve 

	*** drop no consent households *** 
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 2
	drop if add_new_`i' == 0
	
    local hh_active_agri hh_active_agri_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i'
	rename `pull_hh_full_name_calc' hh_member_name
	*** generate indicator variable ***

	gen ind_var = 0
	replace ind_var = 1  if missing(`hh_active_agri' )
    replace ind_var = 1  if `hh_active_agri' != 0 & `hh_active_agri' != 1  & `hh_active_agri' != 2
 	replace ind_var = 0 if _household_roster_count < `i'  
  
    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Unreasonable value"
	generate issue_variable_name = "hh_active_agri_`i'"
	
	rename `hh_active_agri' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$household_roster\Issue_HH_Roster_`hh_active_agri'.dta", replace
    }
  
    restore
}	






***	i.	Age needs to be between 0 and 90 ***
*** I realized these checks were picking up the household that did not give consent *** 
*** So for the initial checks without dependencies I added a drop them ***  **** PROBLEM CONSIDER CHANGING MAX AGE TO 100; -9 A VALID ANSWER?


forvalues i = 1/57 {

    preserve 

	*** drop no consent households *** 
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 2
	drop if add_new_`i' == 0
	
    local hh_age hh_age_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i'
	rename `pull_hh_full_name_calc' hh_member_name
	*** generate indicator variable ***
	gen ind_var = 0
    replace ind_var = 1  if `hh_age' < 0 | `hh_age' > 90    
 	replace ind_var = 0 if _household_roster_count < `i'
	replace ind_var = 0 if key == "uuid:d821e832-2f31-4039-9003-20d913da3311" & hh_age_1 == 92
replace ind_var = 0 if key == "uuid:e6aa7e36-c770-4ee8-be3d-4de123c20a17" & hh_age_1 == 92
replace ind_var = 0 if key == "uuid:2640003a-e439-43ff-a45f-723739ead318" & hh_age_2 == 91
replace ind_var = 0 if key == "uuid:e8949caf-47ee-4e5e-8b89-3eced60feb3d" & hh_age_3 == 99
replace ind_var = 0 if key == "uuid:274749b0-85ce-4907-97b2-f15fae16e9bb" & hh_age_3 == 95
replace ind_var = 0 if key == "uuid:c5be1602-4373-4562-8647-30703fddb2d2" & hh_age_5 == 91
replace ind_var = 0 if key == "uuid:6bc3c04b-1957-4811-8f2f-2c62506708f3" & hh_age_5 == 92
replace ind_var = 0 if key == "uuid:443cfabd-f98c-4336-8e20-80f8957bad20" & hh_age_8 == -9
  
    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Unreasonable value"
	generate issue_variable_name = "hh_age_`i'"
	
	rename `hh_age' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$household_roster\Issue_Household_`hh_age'.dta", replace
    }
  
    restore
}	
	

***	ii.	Hh_education_level should be less than two when age is less than 18 ***  *** PROBLEM HH_EDCUATION == 3 POSSIBLE WHEN AGE < 18

forvalues i = 1/57 {

	preserve 

	*** drop no consent households *** 
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 2
	drop if add_new_`i' == 0
	
	
    local hh_age hh_age_`i'
	local hh_education_level hh_education_level_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i'
	rename `pull_hh_full_name_calc' hh_member_name
	
    gen ind_var = 0
    keep if `hh_age' < 18 
	drop if `hh_education_level' == 99
	replace ind_var = 1 if `hh_education_level' > 2 
	replace ind_var = 0 if _household_roster_count < `i'
	replace ind_var = 0 if key == "uuid:22a38dae-c26f-4f93-ada7-e4904a6bcea5" & hh_education_level_1 == 4
replace ind_var = 0 if key == "uuid:c5a9ad94-512d-4d5e-86be-32bbaea376a8" & hh_education_level_13 == 3
replace ind_var = 0 if key == "uuid:102325d0-e44c-43d8-bf45-03fc0d4bbeeb" & hh_education_level_2 == 3
replace ind_var = 0 if key == "uuid:544b9ce9-1148-4de4-8682-e7a053bc55f6" & hh_education_level_4 == 4
replace ind_var = 0 if key == "uuid:4b9d032f-e2ac-4e4f-b7f2-bad5b9917eaf" & hh_education_level_4 == 3
replace ind_var = 0 if key == "uuid:924ae568-e479-4dc0-9311-dd77acb165c1" & hh_education_level_5 == 3
replace ind_var = 0 if key == "uuid:63d42e02-d823-4062-97c5-479202f66254" & hh_education_level_5 == 3
replace ind_var = 0 if key == "uuid:749d6e2c-6917-439f-8e0a-ac743dee1e1d" & hh_education_level_5 == 3
replace ind_var = 0 if key == "uuid:140ccd1f-98cc-4f31-ae6e-948f6b7c88c8" & hh_education_level_5 == 3
replace ind_var = 0 if key == "uuid:c5a9ad94-512d-4d5e-86be-32bbaea376a8" & hh_education_level_6 == 3
replace ind_var = 0 if key == "uuid:ce4348d4-f8dc-4f45-859b-f7fb9e9c8222" & hh_education_level_7 == 3
replace ind_var = 0 if key == "uuid:fe78ae3a-df95-4ba8-9205-133a78bb7675" & hh_education_level_8 == 3
	
  	
	* keep and add variables to export *
	keep if ind_var == 1
    generate issue = "Unreasonable value" 
	generate issue_variable_name = "hh_education_level_`i'"
	rename `hh_education_level' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	
    if _N > 0 {
        save "$household_roster\Issue_Household_`hh_education_level'.dta", replace
    }
	restore
}


***	iii. Hh_education_year_acheive should be less than age ***  *** CHECKED

forvalues i = 1/57 {

	preserve 
	
	*** drop no consent households *** 
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 2
	drop if add_new_`i' == 0

    local hh_age hh_age_`i'
	local hh_education_level hh_education_year_achieve_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i'
	rename `pull_hh_full_name_calc' hh_member_name

	gen ind_var = 0
    replace ind_var = 1 if `hh_education_level ' > `hh_age' & `hh_education_level' != .
	replace ind_var = 0 if _household_roster_count < `i'

	* keep and add variables to export *
	keep if ind_var == 1 
    generate issue = "Unreasonable value" 
	generate issue_variable_name = "hh_education_year_achieve_`i'"
	rename hh_education_year_achieve_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key

	
    if _N > 0 {
        save "$household_roster\Issue_Household_`hh_education_level'.dta", replace
    }
	restore
}

*** check for missing values for hh_03 *** ***CHECKED
forvalues i = 1/57 {

    preserve 

	*** drop no consent households *** 
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 2
	drop if add_new_`i' == 0
	
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i'
	rename `pull_hh_full_name_calc' hh_member_name

	
	gen ind_var = 0
    replace ind_var = 1 if hh_03_`i' == .  
 	replace ind_var = 0 if _household_roster_count < `i'
	
   
    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Missing value"
	generate issue_variable_name = "hh_03_`i'"
	rename hh_03_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$household_roster\Issue_Household_hh_03_`i'.dta", replace
    }
  
    restore
}


***	iv.	hh_01 should be between 0 and 168 or -9 ***
***	v.	hh_02 should be between 0 and 168 or -9 ***
***	vi.	hh_08 should be between 0 and 168 or -9 ***
***	vii. hh_09 should be between 0 and 168 or -9 ***
***	viii. hh_10 should be between 0 and 168 or -9  ***
*** for these questions, not every household has each person ***
*** want to drop any flags from less than that may household members ***

**** CHECKED
forvalues i = 1/57 {         
	preserve
	
	*** drop no consent households *** 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 2
	drop if add_new_`i' == 0
	
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i'
	rename `pull_hh_full_name_calc' hh_member_name

	
	gen ind_var = 0 
	replace ind_var = 1 if hh_01_`i' < 0 & hh_01_`i' != -9
	replace ind_var = 1 if hh_01_`i' > 168
	replace ind_var = 0 if _household_roster_count < `i'

	keep if ind_var == 1 
	
	generate issue = "Unreasonable value"
	generate issue_variable_name = "hh_01_`i'"
	rename hh_01_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key

    
	if _N > 0 {
		save "$household_roster\Issue_Household_hh_01_`i'_unreasonable.dta", replace
	}
    
	restore
}


*** CHECKED
forvalues i = 1/57 {
	preserve
	
	*** drop no consent households *** 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 2
	drop if add_new_`i' == 0
	
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
	
	
	gen ind_var = 0 
	replace ind_var = 1 if hh_02_`i' < 0 & hh_02_`i' != -9
	replace ind_var = 1 if hh_02_`i' > 168
	replace ind_var = 0 if _household_roster_count < `i'
	
	keep if ind_var == 1 
	
	generate issue = "Unreasonable value"
	generate issue_variable_name = "hh_02_`i'"
	rename hh_02_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key

    
	if _N > 0 {
		save "$household_roster\Issue_Household_hh_02_`i'_unreasonable.dta", replace
	}
    
	restore
}


**** CHECKED
forvalues i = 1/57 {
	preserve

	*** drop no consent households *** 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 2
	drop if add_new_`i' == 0
	
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
	

	gen ind_var = 0 
	replace ind_var = 1 if hh_08_`i' < 0 & hh_08_`i' != -9
	replace ind_var = 1 if hh_08_`i' > 168
	replace ind_var = 0 if _household_roster_count < `i'
	
	keep if ind_var == 1 
	
	generate issue = "Unreasonable value"
	generate issue_variable_name = "hh_08_`i'"
	rename hh_08_`i' print_issue 
	tostring(print_issue), replace
	
	keep villageid hhid sup enqu sup_name enqu_name hh_phone  hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key

    
	if _N > 0 {
		save "$household_roster\Issue_Household_hh_08_`i'_unreasonable.dta", replace
	}
    
	restore
}


*** CHECKED
forvalues i = 1/57 {
	preserve

	*** drop no consent households *** 
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 2
	drop if add_new_`i' == 0
	
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 	
	
	gen ind_var = 0 
	replace ind_var = 1 if hh_09_`i' < 0 & hh_09_`i' != -9
	replace ind_var = 1 if hh_09_`i' > 168
	replace ind_var = 0 if _household_roster_count < `i'

	keep if ind_var == 1 
	
	generate issue = "Unreasonable value"
	generate issue_variable_name = "hh_09_`i'"
	rename hh_09_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key

    
	if _N > 0 {
		save "$household_roster\Issue_Household_hh_09_`i'_unreasonable.dta", replace
	}
    
	restore
}

*** CHECKED
forvalues i = 1/57 {
	preserve

	*** drop no consent households *** 
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 2
	drop if add_new_`i' == 0
	
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
	
	
	gen ind_var = 0 
	replace ind_var = 1 if hh_10_`i' < 0 & hh_10_`i' != -9
	replace ind_var = 1 if 	hh_10_`i' > 168
	replace ind_var = 0 if _household_roster_count < `i'

	
	keep if ind_var == 1 
	
	generate issue = "Unreasonable value"
	generate issue_variable_name = "hh_10_`i'"
	rename hh_10_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key

    
	if _N > 0 {
		save "$household_roster\Issue_Household_hh_10_`i'_unreasonable.dta", replace
	}
    
	restore
}

***	ix.	The sum of all values for each individual's hh_13 should be less than hh_10 ***   *** PROBLEM

*removed hh_13_`i'_7, add back in if someone selects 
forvalues i = 1/57 {
	
		
	preserve

	*** drop no consent households *** 
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 2
	drop if add_new_`i' == 0
	
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
	
	egen hh_13_`i'_total = rowtotal(hh_13_`i'_1  hh_13_`i'_2  hh_13_`i'_3 hh_13_`i'_4  hh_13_`i'_5 hh_13_`i'_6 hh_13_`i'_7 )
	
	gen ind_var = 0 
	replace ind_var = 1 if hh_13_`i'_total > hh_10_`i' 
	replace ind_var = 0 if _household_roster_count < `i'
	replace ind_var = 0 if key == "uuid:4d6f8ba3-921e-4c44-b880-7c26e5bd52b9"
replace ind_var = 0 if key == "uuid:91ba8b33-fa95-4775-bf72-c0e18499736c"
replace ind_var = 0 if key == "uuid:ed4a3ab3-eb94-46fa-8ca7-d4305cf8e36e"
replace ind_var = 0 if key == "uuid:ed4a3ab3-eb94-46fa-8ca7-d4305cf8e36e"
replace ind_var = 0 if key == "uuid:2c43c97e-4854-45f3-acb7-49a56e4a5276"
replace ind_var = 0 if key == "uuid:5e203451-1121-4391-83f9-590148136101"
replace ind_var = 0 if key == "uuid:610ca467-4669-42cf-83bd-036cfcbef797"
replace ind_var = 0 if key == "uuid:6fc34a13-7455-46b5-9d1a-5bafa2e11b9e"
replace ind_var = 0 if key == "uuid:54cf3fe4-e1ce-42cb-9d5e-145583555e00"
replace ind_var = 0 if key == "uuid:22a38dae-c26f-4f93-ada7-e4904a6bcea5"
replace ind_var = 0 if key == "uuid:c7ecc3c7-f961-4f01-a59e-519ce6d7b325"
replace ind_var = 0 if key == "uuid:4887e397-f600-4e7f-93cb-6c20c8aeaf2a"
replace ind_var = 0 if key == "uuid:9da62ab2-6426-4bbe-8665-003c0a00080f"
replace ind_var = 0 if key == "uuid:2c43c97e-4854-45f3-acb7-49a56e4a5276"
replace ind_var = 0 if key == "uuid:d84a37d5-09e5-45ee-94fc-da2954f60d2b"
replace ind_var = 0 if key == "uuid:202a0a2f-288d-4913-a1c0-51628440129d"
replace ind_var = 0 if key == "uuid:83b54118-2059-4722-ba2b-bc8b6fff02ea"
replace ind_var = 0 if key == "uuid:cda122cf-9280-432d-a1a8-8b7d8c4948f9"
replace ind_var = 0 if key == "uuid:06f20c08-d76a-498a-ba77-dadca0993fb9"
replace ind_var = 0 if key == "uuid:57bb8e54-caf8-49c9-a0f5-fd636d2a2592"
replace ind_var = 0 if key == "uuid:07815cfd-fc9e-42e6-823e-83d93c2b9461"
replace ind_var = 0 if key == "uuid:950634d7-6af7-48f4-81f2-23e84812d304"
replace ind_var = 0 if key == "uuid:07815cfd-fc9e-42e6-823e-83d93c2b9461"
replace ind_var = 0 if key == "uuid:8f49e817-68d3-4a92-98c6-02ed3739a07f"
replace ind_var = 0 if key == "uuid:715348c5-4975-4ab4-9299-efc393087ce8"
replace ind_var = 0 if key == "uuid:230eeec0-f4e6-476f-a49b-68a540e6612e"
replace ind_var = 0 if key == "uuid:36cc7c65-9580-4182-92d9-ddda36fbb0ea"
replace ind_var = 0 if key == "uuid:ab4bc620-6e26-47f3-9530-e99a2768597e"
replace ind_var = 0 if key == "uuid:f72c4194-1658-4baa-9e40-7e6b0ea2b3a8"
replace ind_var = 0 if key == "uuid:ab4bc620-6e26-47f3-9530-e99a2768597e"
replace ind_var = 0 if key == "uuid:d27907d8-f6aa-4b80-81cc-9a1006e1012e"
replace ind_var = 0 if key == "uuid:f72c4194-1658-4baa-9e40-7e6b0ea2b3a8"
replace ind_var = 0 if key == "uuid:ce006143-d00a-48fd-928c-252e34c0cec8"
replace ind_var = 0 if key == "uuid:c1f669a3-8c71-4496-ad2a-48299f1252fa"
replace ind_var = 0 if key == "uuid:ae96b0a8-e61f-45f0-acdb-dfd03bcaa73f"
replace ind_var = 0 if key == "uuid:94fc3496-7082-49fc-92ff-c1f97c2200fa"
replace ind_var = 0 if key == "uuid:7e856dd9-4999-4581-8a10-a211bb7e63b4"
replace ind_var = 0 if key == "uuid:3d62ede2-09be-4490-8ccf-918371d1b1b9"
replace ind_var = 0 if key == "uuid:f72c4194-1658-4baa-9e40-7e6b0ea2b3a8"
replace ind_var = 0 if key == "uuid:0b0fb3f0-5253-417a-a40c-b4225652ad7f"
replace ind_var = 0 if key == "uuid:f72c4194-1658-4baa-9e40-7e6b0ea2b3a8"
replace ind_var = 0 if key == "uuid:0b0fb3f0-5253-417a-a40c-b4225652ad7f"
replace ind_var = 0 if key == "uuid:b9e97e2c-cb4b-4f65-8865-ff559d932464"
replace ind_var = 0 if key == "uuid:f27e2583-e9b9-4b03-bc4f-a56b8bf18447"
replace ind_var = 0 if key == "uuid:7e856dd9-4999-4581-8a10-a211bb7e63b4"
replace ind_var = 0 if key == "uuid:0b0fb3f0-5253-417a-a40c-b4225652ad7f"
replace ind_var = 0 if key == "uuid:6edd5242-6e3f-4e36-90b5-05a461dc952b"
replace ind_var = 0 if key == "uuid:e4d9ab46-b30f-4d93-a47b-9b0e1c367d58"
replace ind_var = 0 if key == "uuid:ac4e0095-40d2-4290-94b4-14930802dbd0"
replace ind_var = 0 if key == "uuid:a58331c4-b5ce-40a8-af97-c1e0292d8ef1"
replace ind_var = 0 if key == "uuid:e226d02b-cb74-42c9-bfd2-cfd2ef823aa2"
replace ind_var = 0 if key == "uuid:94d8e8c9-df2a-466b-b173-f7d1403ac905"
replace ind_var = 0 if key == "uuid:05e470c2-03bd-4546-9072-21f897c957b0"
replace ind_var = 0 if key == "uuid:f27e2583-e9b9-4b03-bc4f-a56b8bf18447"
replace ind_var = 0 if key == "uuid:0e156f00-686e-43cf-b85f-b72427ea07ea"
replace ind_var = 0 if key == "uuid:94d8e8c9-df2a-466b-b173-f7d1403ac905"
replace ind_var = 0 if key == "uuid:7eb66aa0-0169-41c4-a623-c4e0dcd139b5"
replace ind_var = 0 if key == "uuid:e4d9ab46-b30f-4d93-a47b-9b0e1c367d58"
replace ind_var = 0 if key == "uuid:f72c4194-1658-4baa-9e40-7e6b0ea2b3a8"
replace ind_var = 0 if key == "uuid:e4d9ab46-b30f-4d93-a47b-9b0e1c367d58"
replace ind_var = 0 if key == "uuid:94d8e8c9-df2a-466b-b173-f7d1403ac905"
replace ind_var = 0 if key == "uuid:ae96b0a8-e61f-45f0-acdb-dfd03bcaa73f"
replace ind_var = 0 if key == "uuid:b9e97e2c-cb4b-4f65-8865-ff559d932464"
replace ind_var = 0 if key == "uuid:f72c4194-1658-4baa-9e40-7e6b0ea2b3a8"
replace ind_var = 0 if key == "uuid:0b9db113-4ef6-466e-80d0-190be268de07"
replace ind_var = 0 if key == "uuid:fa7f73fd-c387-457f-99aa-da844bb4e83e"
replace ind_var = 0 if key == "uuid:4d26f521-80a5-4da0-8826-f6bdaa39fac4"
replace ind_var = 0 if key == "uuid:6c3a3767-95be-47d7-a5d3-7e893c18ac0f"
replace ind_var = 0 if key == "uuid:0ce7d392-22ca-4a4f-abd1-8bb9364ddaa4"
replace ind_var = 0 if key == "uuid:a4e17fab-1883-4ce7-ae61-d89165dce193"
replace ind_var = 0 if key == "uuid:9bd0d7cb-a3b9-4ef9-a83c-e48bb8791500"
replace ind_var = 0 if key == "uuid:acaacc67-ef2f-4d73-a0fa-a58ca30c2153"
replace ind_var = 0 if key == "uuid:f0e95d05-f703-4242-bb05-cdf1c7be4e16"
replace ind_var = 0 if key == "uuid:276b30ac-8a01-4e01-8a96-2f23dc4001f8"
replace ind_var = 0 if key == "uuid:04f82d4c-d64b-4f3d-b127-21f022dd526b"
replace ind_var = 0 if key == "uuid:17dd2ae2-270d-40a2-8904-226e20abc4f2"
replace ind_var = 0 if key == "uuid:bff7956c-0e63-4cf7-b6f8-abf16a8c0276"
replace ind_var = 0 if key == "uuid:2ce3ed31-0439-4336-942e-3885ce4ca0b4"
replace ind_var = 0 if key == "uuid:7c39851f-d41d-4438-830c-7df92cf9c209"
replace ind_var = 0 if key == "uuid:1bf03019-0fe3-4171-bf36-5ee1cbc502f5"
replace ind_var = 0 if key == "uuid:acaacc67-ef2f-4d73-a0fa-a58ca30c2153"
replace ind_var = 0 if key == "uuid:93743604-01c7-48c5-a295-3242254348b6"
replace ind_var = 0 if key == "uuid:f0e95d05-f703-4242-bb05-cdf1c7be4e16"
replace ind_var = 0 if key == "uuid:2ce3ed31-0439-4336-942e-3885ce4ca0b4"
replace ind_var = 0 if key == "uuid:6c8b1e85-b2f2-4977-a3be-5c53ac28188e"
replace ind_var = 0 if key == "uuid:f3fc7fa3-cc52-48a4-b153-e65733a5a392"
replace ind_var = 0 if key == "uuid:8b5fa358-6317-4e65-a16f-0fce2d44c6b5"
replace ind_var = 0 if key == "uuid:ac7acb5b-cc03-405a-b699-c7049bbb6f16"
replace ind_var = 0 if key == "uuid:ac7acb5b-cc03-405a-b699-c7049bbb6f16"
replace ind_var = 0 if key == "uuid:8b5fa358-6317-4e65-a16f-0fce2d44c6b5"
replace ind_var = 0 if key == "uuid:255d0b95-f83e-45d6-85d8-079546e38ac2"
replace ind_var = 0 if key == "uuid:8367d735-f929-48ef-bd00-c7f042f3666f"
replace ind_var = 0 if key == "uuid:de358167-c62b-4063-830a-a3f52a40516e"
replace ind_var = 0 if key == "uuid:4ad73e64-38f3-461a-8631-05589869add6"
replace ind_var = 0 if key == "uuid:48307db7-0b01-44ba-9c41-45125c0352bd"
replace ind_var = 0 if key == "uuid:90fe8f5d-1972-4a14-981b-53c3b8d1bb20"
replace ind_var = 0 if key == "uuid:99c16594-e479-4aa3-92cc-2a3e9f09cba0"
replace ind_var = 0 if key == "uuid:d7cf7d20-89ae-405c-af0f-c9f04d222f68"
replace ind_var = 0 if key == "uuid:7b44e820-4a74-4f8e-b21d-edbc2eed548c"
replace ind_var = 0 if key == "uuid:8e2a7ee4-2de2-4ed6-baa8-89adbccfa261"
replace ind_var = 0 if key == "uuid:4cfa8fad-9dae-44cd-9e79-1dd479afc34c"
replace ind_var = 0 if key == "uuid:d685d816-bff6-4336-b2d7-18e5e0ce6642"
replace ind_var = 0 if key == "uuid:17d10f64-73a3-47f9-b5cc-d3181be64f21"
replace ind_var = 0 if key == "uuid:1e6b9d1b-bee3-4d17-b5eb-2610596e005a"
replace ind_var = 0 if key == "uuid:45e97396-5ee5-4b55-ac86-cbd4824e8263"
replace ind_var = 0 if key == "uuid:14962970-5438-430e-a873-4b7083b3ff89"
replace ind_var = 0 if key == "uuid:2f85582e-6352-4e1a-b9b4-6566eec8bd87"
replace ind_var = 0 if key == "uuid:c7c6ac20-be3f-47ba-b2b4-eb17e08123c4"
replace ind_var = 0 if key == "uuid:d7cf7d20-89ae-405c-af0f-c9f04d222f68"
replace ind_var = 0 if key == "uuid:14962970-5438-430e-a873-4b7083b3ff89"
replace ind_var = 0 if key == "uuid:5280aabf-8b4f-416e-84b9-5b78d5382352"
replace ind_var = 0 if key == "uuid:94643380-9b5b-4ec2-ac9c-a3fd30a51af7"
replace ind_var = 0 if key == "uuid:3836b5eb-ccd2-4c6b-bd5f-bf42d09c166c"
replace ind_var = 0 if key == "uuid:155e4011-7e23-4a13-9190-c8859bb3641f"
replace ind_var = 0 if key == "uuid:8bc2c8fe-0e98-4b50-9db9-ba66521af34d"
replace ind_var = 0 if key == "uuid:09622dd4-4613-46e3-939b-c3a43a585bb5"
replace ind_var = 0 if key == "uuid:ab7d5d15-0083-4d38-8abb-bb1b924d1b88"
replace ind_var = 0 if key == "uuid:5af0d03f-adee-40c6-837f-cd2d839cfcff"
replace ind_var = 0 if key == "uuid:dc9ced48-126c-438c-a13d-a25d09b3d415"
replace ind_var = 0 if key == "uuid:155e4011-7e23-4a13-9190-c8859bb3641f"
replace ind_var = 0 if key == "uuid:7d6f6d9d-c257-4195-8a67-0aecd4e1b233"
replace ind_var = 0 if key == "uuid:3836b5eb-ccd2-4c6b-bd5f-bf42d09c166c"
replace ind_var = 0 if key == "uuid:225f0fda-48a9-4216-bb6a-dcd5cbf8c6a0"
replace ind_var = 0 if key == "uuid:7d6f6d9d-c257-4195-8a67-0aecd4e1b233"
replace ind_var = 0 if key == "uuid:8906bfb9-1397-48b5-a2c8-ad8c6a8d05d4"
replace ind_var = 0 if key == "uuid:273ef459-4a4b-421f-b45f-5938f44138fb"
replace ind_var = 0 if key == "uuid:82b29ac5-2558-4aa3-a780-b48b45483422"
replace ind_var = 0 if key == "uuid:5bde4af2-d8dc-4fae-8884-fc042a5d12a6"
replace ind_var = 0 if key == "uuid:a4402ec7-4feb-48e1-958c-e58af2695a91"
replace ind_var = 0 if key == "uuid:eb83f695-2664-47fa-817c-9dac667e6e36"
replace ind_var = 0 if key == "uuid:3836b5eb-ccd2-4c6b-bd5f-bf42d09c166c"
replace ind_var = 0 if key == "uuid:d44573d3-a9ca-4ddf-9562-1a17f4041335"
replace ind_var = 0 if key == "uuid:e1f57db1-c71f-4b6b-8e34-e79a83b811e1"
replace ind_var = 0 if key == "uuid:19e1735c-2567-450b-af13-bf2a4c46401f"
replace ind_var = 0 if key == "uuid:1c2ad303-cb84-4bf8-a5cf-f5d38b1ee77c"
replace ind_var = 0 if key == "uuid:7d9f8b44-84f1-4118-b829-ec224829dc78"
replace ind_var = 0 if key == "uuid:ab7d5d15-0083-4d38-8abb-bb1b924d1b88"
replace ind_var = 0 if key == "uuid:347b10a5-29e2-4221-9079-08b5d95c139b"
replace ind_var = 0 if key == "uuid:835ad0a6-7209-486a-9324-9f1201bd9a44"
replace ind_var = 0 if key == "uuid:d44573d3-a9ca-4ddf-9562-1a17f4041335"
replace ind_var = 0 if key == "uuid:82b29ac5-2558-4aa3-a780-b48b45483422"
replace ind_var = 0 if key == "uuid:5280aabf-8b4f-416e-84b9-5b78d5382352"
replace ind_var = 0 if key == "uuid:155e4011-7e23-4a13-9190-c8859bb3641f"
replace ind_var = 0 if key == "uuid:d7d885fe-9a4f-4a10-8991-80d5fd4dd3f9"
replace ind_var = 0 if key == "uuid:52114c0c-1d86-4b02-bfad-1d2915662339"
replace ind_var = 0 if key == "uuid:b632245d-c09f-449a-8531-7d895647d580"
replace ind_var = 0 if key == "uuid:ff3a6c1c-3914-48f6-88fd-0ad12b79a00e"
replace ind_var = 0 if key == "uuid:3836b5eb-ccd2-4c6b-bd5f-bf42d09c166c"
replace ind_var = 0 if key == "uuid:347b10a5-29e2-4221-9079-08b5d95c139b"
replace ind_var = 0 if key == "uuid:1c2ad303-cb84-4bf8-a5cf-f5d38b1ee77c"
replace ind_var = 0 if key == "uuid:e27a987c-199d-4435-9888-71d4f1a0fb69"
replace ind_var = 0 if key == "uuid:7c9ed2c3-473c-4558-b887-3549340d10d2"
replace ind_var = 0 if key == "uuid:82b29ac5-2558-4aa3-a780-b48b45483422"
replace ind_var = 0 if key == "uuid:155e4011-7e23-4a13-9190-c8859bb3641f"
replace ind_var = 0 if key == "uuid:977bfb1b-9b32-40f3-a5b9-b378470fe0c7"
replace ind_var = 0 if key == "uuid:cf7580cb-13e6-4b55-9893-3d6a6e4e82b4"
replace ind_var = 0 if key == "uuid:155e4011-7e23-4a13-9190-c8859bb3641f"
replace ind_var = 0 if key == "uuid:82b29ac5-2558-4aa3-a780-b48b45483422"
replace ind_var = 0 if key == "uuid:94e7466e-6e68-47b2-a2e6-3665b1e43ddc"
replace ind_var = 0 if key == "uuid:f05825dc-a539-40ff-8384-8edaef71070b"
replace ind_var = 0 if key == "uuid:d5f48d8a-650d-40bc-b6ad-a365623fda48"
replace ind_var = 0 if key == "uuid:1c2ad303-cb84-4bf8-a5cf-f5d38b1ee77c"
replace ind_var = 0 if key == "uuid:ab7d5d15-0083-4d38-8abb-bb1b924d1b88"
replace ind_var = 0 if key == "uuid:3836b5eb-ccd2-4c6b-bd5f-bf42d09c166c"
replace ind_var = 0 if key == "uuid:bd5809d6-cf3f-4953-84dd-55dde87227f5"
replace ind_var = 0 if key == "uuid:b6b0e45c-70af-459a-b1fc-68ef8ad671ba"
replace ind_var = 0 if key == "uuid:742d4881-da1e-4e85-9270-0c5bd07d1b00"
replace ind_var = 0 if key == "uuid:7d9f8b44-84f1-4118-b829-ec224829dc78"
replace ind_var = 0 if key == "uuid:b6b0e45c-70af-459a-b1fc-68ef8ad671ba"
replace ind_var = 0 if key == "uuid:7d9f8b44-84f1-4118-b829-ec224829dc78"
replace ind_var = 0 if key == "uuid:3c3b579a-f6e1-43d8-8b41-2f3c0d88225c"
replace ind_var = 0 if key == "uuid:85bf20ba-a400-46bd-b464-e95c8c84b83a"
replace ind_var = 0 if key == "uuid:844ab214-bd8f-4cfd-b13e-38ce3bba59a8"
replace ind_var = 0 if key == "uuid:a0da06c7-4f16-44ab-b40a-c8fe75daf322"
replace ind_var = 0 if key == "uuid:446cce08-7cc4-44c1-be46-e651f216e5bc"
replace ind_var = 0 if key == "uuid:5cdbeb2d-f857-4604-bd8e-a8c71598c780"
replace ind_var = 0 if key == "uuid:5ea1d587-2469-4448-92aa-5e52f24e0944"
replace ind_var = 0 if key == "uuid:6c6af704-258e-4141-89bb-38b76f5fcd0a"
replace ind_var = 0 if key == "uuid:50b29906-6426-4b14-b03d-be24b5bb4fbc"
replace ind_var = 0 if key == "uuid:f09c2ec3-49c7-4065-8012-aa9394ead732"
replace ind_var = 0 if key == "uuid:5cdbeb2d-f857-4604-bd8e-a8c71598c780"
replace ind_var = 0 if key == "uuid:a0da06c7-4f16-44ab-b40a-c8fe75daf322"
replace ind_var = 0 if key == "uuid:d087f767-d251-4ab8-a3f3-7f749499d11d"
replace ind_var = 0 if key == "uuid:50b29906-6426-4b14-b03d-be24b5bb4fbc"
replace ind_var = 0 if key == "uuid:0243f237-580f-48db-81ac-af07d0ec3c7d"
replace ind_var = 0 if key == "uuid:d087f767-d251-4ab8-a3f3-7f749499d11d"
replace ind_var = 0 if key == "uuid:e2eb2697-0ed5-4a5c-8049-b1ea036fbe9c"
replace ind_var = 0 if key == "uuid:8f4cbc6a-8472-4738-b738-7057a87ab85e"
replace ind_var = 0 if key == "uuid:eb71f1ee-5f44-4a52-926b-7db730824f49"
replace ind_var = 0 if key == "uuid:6fd4bf23-18ad-4397-b6e5-51b08c474051"
replace ind_var = 0 if key == "uuid:a137313a-7bc1-4510-a7cc-367cd5242870"
replace ind_var = 0 if key == "uuid:6fd4bf23-18ad-4397-b6e5-51b08c474051"
replace ind_var = 0 if key == "uuid:aa31efb9-7412-4e3a-9439-0bb286420a63"
replace ind_var = 0 if key == "uuid:50f46c9d-224d-475a-9e79-88c00fd6c213"
replace ind_var = 0 if key == "uuid:eb71f1ee-5f44-4a52-926b-7db730824f49"
replace ind_var = 0 if key == "uuid:7e085ce7-6243-4ba5-bb47-88eb94f46bab"
replace ind_var = 0 if key == "uuid:d956e550-a088-43b7-b422-7417e1341024"
replace ind_var = 0 if key == "uuid:53f9620b-0bad-4850-8858-daef5ca40bb1"
replace ind_var = 0 if key == "uuid:a137313a-7bc1-4510-a7cc-367cd5242870"
replace ind_var = 0 if key == "uuid:5405184a-72e2-45d3-9d4b-7de603a79851"
replace ind_var = 0 if key == "uuid:50f46c9d-224d-475a-9e79-88c00fd6c213"
replace ind_var = 0 if key == "uuid:a137313a-7bc1-4510-a7cc-367cd5242870"
replace ind_var = 0 if key == "uuid:1e9da38f-f800-4f19-93ac-73bbf37def32"
replace ind_var = 0 if key == "uuid:e59e2eae-b1ae-449a-8842-d4641331f136"
replace ind_var = 0 if key == "uuid:4a0fe362-32d1-4dad-ba8c-ca382d519c63"
replace ind_var = 0 if key == "uuid:8fa21ba5-01a7-4793-83e1-dff07d42eb16"
replace ind_var = 0 if key == "uuid:ea66090c-4853-434a-8501-93e90526a596"
replace ind_var = 0 if key == "uuid:57dd6094-f7b5-43e7-9c80-108266eac06b"
replace ind_var = 0 if key == "uuid:71a3b9e5-abc7-4e2c-94a3-006da861982b"
replace ind_var = 0 if key == "uuid:fe4d47d8-1ccf-4acf-a7b9-e9d0c7e6d252"
replace ind_var = 0 if key == "uuid:4a0fe362-32d1-4dad-ba8c-ca382d519c63"
replace ind_var = 0 if key == "uuid:8cb164e9-bedb-4168-b1fa-f5ce9354c2a9"
replace ind_var = 0 if key == "uuid:731b2b96-2cc9-4c40-ab3d-1c8eca615b1d"
replace ind_var = 0 if key == "uuid:71a3b9e5-abc7-4e2c-94a3-006da861982b"
replace ind_var = 0 if key == "uuid:ea66090c-4853-434a-8501-93e90526a596"
replace ind_var = 0 if key == "uuid:71a3b9e5-abc7-4e2c-94a3-006da861982b"
replace ind_var = 0 if key == "uuid:8cb164e9-bedb-4168-b1fa-f5ce9354c2a9"
replace ind_var = 0 if key == "uuid:71a3b9e5-abc7-4e2c-94a3-006da861982b"
replace ind_var = 0 if key == "uuid:d7df3ea3-ed60-4690-83db-4a41ccfe4d2e"
replace ind_var = 0 if key == "uuid:e59e2eae-b1ae-449a-8842-d4641331f136"
replace ind_var = 0 if key == "uuid:cacc2793-2389-4662-9f45-57888c195209"
replace ind_var = 0 if key == "uuid:b1fae32c-057b-45c3-a10b-5fbdf289d4d6"
replace ind_var = 0 if key == "uuid:68e479ee-1a91-4b2c-99d0-cfb335f8aeeb"
replace ind_var = 0 if key == "uuid:f74852e0-f784-45df-9ba6-40933da3b8d1"
replace ind_var = 0 if key == "uuid:92bf8c6e-ed5e-45f9-a303-3edb224aa9a9"
replace ind_var = 0 if key == "uuid:33059fa7-c2ec-4757-925c-e9caca8b3365"
replace ind_var = 0 if key == "uuid:ee63debf-822a-411e-a0f2-d08e9eade8c3"
replace ind_var = 0 if key == "uuid:cdc2da54-b15a-4620-8ab1-79529d3e76e8"
replace ind_var = 0 if key == "uuid:a671b107-d7f9-4662-9727-5a5ee7218919"
replace ind_var = 0 if key == "uuid:96923c86-ad11-4def-97ce-64a3089a78a1"
replace ind_var = 0 if key == "uuid:06a0710b-f29b-48db-894f-4d4cf39a1b4a"
replace ind_var = 0 if key == "uuid:fd300527-e33a-4519-8ba2-1df30a653a0c"
replace ind_var = 0 if key == "uuid:41e60432-f713-4dd5-8c23-dce0e4f5116d"
replace ind_var = 0 if key == "uuid:7bc76c9c-7953-4dc6-8f11-a7b27a31fb2e"
replace ind_var = 0 if key == "uuid:2281e503-58c4-4cc7-8d8a-c0f0556fc6fe"
replace ind_var = 0 if key == "uuid:b23e5229-ac34-49c5-bb00-dc31eb3bd45a"
replace ind_var = 0 if key == "uuid:f5bfd38e-c47c-4d7f-aa1f-37602fef6c9c"
replace ind_var = 0 if key == "uuid:1a90220f-66e7-4dbc-9c15-d68d00a2837c"
replace ind_var = 0 if key == "uuid:8beba4f4-7066-4673-974d-d1e6ce1c202d"
replace ind_var = 0 if key == "uuid:18f82da1-ec44-4a27-aa91-dc3e5e255ab0"
replace ind_var = 0 if key == "uuid:38e50014-cbb3-4ccf-a592-222277e3c778"
replace ind_var = 0 if key == "uuid:98c2222f-078f-4f22-a564-daa6d11a3137"
replace ind_var = 0 if key == "uuid:97005d53-1aba-40bb-b43e-9ee1381dca64"
replace ind_var = 0 if key == "uuid:99c82cc7-1de5-4a4a-9f31-d20eecd3780b"
replace ind_var = 0 if key == "uuid:6807b869-b596-4b86-8e58-0ab895ba820d"
replace ind_var = 0 if key == "uuid:57dd6094-f7b5-43e7-9c80-108266eac06b"
replace ind_var = 0 if key == "uuid:3483bf73-dafd-4ff8-9f01-fd15130e5fc1"
replace ind_var = 0 if key == "uuid:478dad1c-ebf1-4e82-89a3-d7dd1b17b817"
replace ind_var = 0 if key == "uuid:1df09cfd-b5f7-4fa5-8227-199fa261ae20"
replace ind_var = 0 if key == "uuid:8cb164e9-bedb-4168-b1fa-f5ce9354c2a9"
replace ind_var = 0 if key == "uuid:38e50014-cbb3-4ccf-a592-222277e3c778"
replace ind_var = 0 if key == "uuid:92bf8c6e-ed5e-45f9-a303-3edb224aa9a9"
replace ind_var = 0 if key == "uuid:18f82da1-ec44-4a27-aa91-dc3e5e255ab0"
replace ind_var = 0 if key == "uuid:9d9dda6a-deb5-4cce-bd4c-ed3f2bc00381"
replace ind_var = 0 if key == "uuid:b047f2ab-50c4-44f9-afb1-47950ed4d298"
replace ind_var = 0 if key == "uuid:a9c4ed22-5c74-45bc-a014-6fa3b78dea51"
replace ind_var = 0 if key == "uuid:021408c0-3c5f-42ad-bf3c-4df9fc199963"
replace ind_var = 0 if key == "uuid:4f33e08d-f88b-4c66-9f8c-5c6ffcb99c7e"
replace ind_var = 0 if key == "uuid:f74852e0-f784-45df-9ba6-40933da3b8d1"
replace ind_var = 0 if key == "uuid:6b9b2707-4a82-4053-b891-58a4da25d61f"
replace ind_var = 0 if key == "uuid:8f2f96ba-cb33-4481-b386-214bf00ad3e3"
replace ind_var = 0 if key == "uuid:fd300527-e33a-4519-8ba2-1df30a653a0c"
replace ind_var = 0 if key == "uuid:6807b869-b596-4b86-8e58-0ab895ba820d"
replace ind_var = 0 if key == "uuid:57dd6094-f7b5-43e7-9c80-108266eac06b"
replace ind_var = 0 if key == "uuid:18f82da1-ec44-4a27-aa91-dc3e5e255ab0"
replace ind_var = 0 if key == "uuid:8f2f96ba-cb33-4481-b386-214bf00ad3e3"
replace ind_var = 0 if key == "uuid:fe78ae3a-df95-4ba8-9205-133a78bb7675"
replace ind_var = 0 if key == "uuid:0aa1bd0b-c8f4-493d-a32e-5256cc8a58d0"
replace ind_var = 0 if key == "uuid:f74852e0-f784-45df-9ba6-40933da3b8d1"
replace ind_var = 0 if key == "uuid:f5bfd38e-c47c-4d7f-aa1f-37602fef6c9c"
replace ind_var = 0 if key == "uuid:06a0710b-f29b-48db-894f-4d4cf39a1b4a"
replace ind_var = 0 if key == "uuid:38e50014-cbb3-4ccf-a592-222277e3c778"
replace ind_var = 0 if key == "uuid:b89a7ed1-e6ea-4835-8e6d-2e374b8d1cdb"
replace ind_var = 0 if key == "uuid:731b2b96-2cc9-4c40-ab3d-1c8eca615b1d"
replace ind_var = 0 if key == "uuid:44c3f48f-0077-4b77-8299-067409188bf3"
replace ind_var = 0 if key == "uuid:7f450507-9f4a-40a5-99e4-8b63c95b4d2c"
replace ind_var = 0 if key == "uuid:902f961e-7553-4463-81b7-39f9ad8f7903"
replace ind_var = 0 if key == "uuid:cacc2793-2389-4662-9f45-57888c195209"
replace ind_var = 0 if key == "uuid:43c5f3aa-5f3e-4087-98de-31d897566c82"
replace ind_var = 0 if key == "uuid:98c2222f-078f-4f22-a564-daa6d11a3137"
replace ind_var = 0 if key == "uuid:95ab2e1d-999b-4548-bdb3-f2b43f8c8d43"
replace ind_var = 0 if key == "uuid:8beba4f4-7066-4673-974d-d1e6ce1c202d"
replace ind_var = 0 if key == "uuid:398fb50b-ed82-412f-948c-8c9b36a4d647"
replace ind_var = 0 if key == "uuid:6807b869-b596-4b86-8e58-0ab895ba820d"
replace ind_var = 0 if key == "uuid:b047f2ab-50c4-44f9-afb1-47950ed4d298"
replace ind_var = 0 if key == "uuid:e692401a-2af4-4a0f-9e12-1d7bb0856037"
replace ind_var = 0 if key == "uuid:e59e2eae-b1ae-449a-8842-d4641331f136"
replace ind_var = 0 if key == "uuid:0b064064-0c43-4beb-b04f-f7cbe586b32a"
replace ind_var = 0 if key == "uuid:44c3f48f-0077-4b77-8299-067409188bf3"
replace ind_var = 0 if key == "uuid:92171a8f-7a48-4292-a5ef-6850b6c04333"
replace ind_var = 0 if key == "uuid:b724a25d-830a-4bab-a8e8-0bac4750ce73"
replace ind_var = 0 if key == "uuid:1a90220f-66e7-4dbc-9c15-d68d00a2837c"
replace ind_var = 0 if key == "uuid:f74852e0-f784-45df-9ba6-40933da3b8d1"
replace ind_var = 0 if key == "uuid:4c778d8f-97d4-47fa-af7d-7e3314c48feb"
replace ind_var = 0 if key == "uuid:06a0710b-f29b-48db-894f-4d4cf39a1b4a"
replace ind_var = 0 if key == "uuid:2281e503-58c4-4cc7-8d8a-c0f0556fc6fe"
replace ind_var = 0 if key == "uuid:7df27b6f-72da-4704-ae80-891dc6884470"
replace ind_var = 0 if key == "uuid:021408c0-3c5f-42ad-bf3c-4df9fc199963"
replace ind_var = 0 if key == "uuid:92bf8c6e-ed5e-45f9-a303-3edb224aa9a9"
replace ind_var = 0 if key == "uuid:33059fa7-c2ec-4757-925c-e9caca8b3365"
replace ind_var = 0 if key == "uuid:35f6931b-c1e5-4ed4-ac86-d169b66b7963"
replace ind_var = 0 if key == "uuid:18f82da1-ec44-4a27-aa91-dc3e5e255ab0"
replace ind_var = 0 if key == "uuid:b1fae32c-057b-45c3-a10b-5fbdf289d4d6"
replace ind_var = 0 if key == "uuid:54f5143b-9911-4187-a30c-9e3239c47476"
replace ind_var = 0 if key == "uuid:fe78ae3a-df95-4ba8-9205-133a78bb7675"
replace ind_var = 0 if key == "uuid:0aa1bd0b-c8f4-493d-a32e-5256cc8a58d0"
replace ind_var = 0 if key == "uuid:6807b869-b596-4b86-8e58-0ab895ba820d"
replace ind_var = 0 if key == "uuid:c549c58d-ef59-4d7f-a241-ebe47316e790"
replace ind_var = 0 if key == "uuid:92bf8c6e-ed5e-45f9-a303-3edb224aa9a9"
replace ind_var = 0 if key == "uuid:b724a25d-830a-4bab-a8e8-0bac4750ce73"
replace ind_var = 0 if key == "uuid:1a90220f-66e7-4dbc-9c15-d68d00a2837c"
replace ind_var = 0 if key == "uuid:1df09cfd-b5f7-4fa5-8227-199fa261ae20"
replace ind_var = 0 if key == "uuid:8cb164e9-bedb-4168-b1fa-f5ce9354c2a9"
replace ind_var = 0 if key == "uuid:d072558d-e4ba-46a6-b08f-70dcd69a6876"
replace ind_var = 0 if key == "uuid:f5bfd38e-c47c-4d7f-aa1f-37602fef6c9c"
replace ind_var = 0 if key == "uuid:057ebbe7-b982-4f48-9287-24be6d59f40a"
replace ind_var = 0 if key == "uuid:fe78ae3a-df95-4ba8-9205-133a78bb7675"
replace ind_var = 0 if key == "uuid:cdc2da54-b15a-4620-8ab1-79529d3e76e8"
replace ind_var = 0 if key == "uuid:4c778d8f-97d4-47fa-af7d-7e3314c48feb"
replace ind_var = 0 if key == "uuid:18f82da1-ec44-4a27-aa91-dc3e5e255ab0"
replace ind_var = 0 if key == "uuid:6b9b2707-4a82-4053-b891-58a4da25d61f"
replace ind_var = 0 if key == "uuid:c840f2ec-d0ec-4652-9e94-39ce87bad68a"
replace ind_var = 0 if key == "uuid:7df04366-985d-4f5e-895f-61ec47f30529"
replace ind_var = 0 if key == "uuid:96923c86-ad11-4def-97ce-64a3089a78a1"
replace ind_var = 0 if key == "uuid:0aa1bd0b-c8f4-493d-a32e-5256cc8a58d0"
replace ind_var = 0 if key == "uuid:fe4d47d8-1ccf-4acf-a7b9-e9d0c7e6d252"
replace ind_var = 0 if key == "uuid:6b9b2707-4a82-4053-b891-58a4da25d61f"
replace ind_var = 0 if key == "uuid:4f33e08d-f88b-4c66-9f8c-5c6ffcb99c7e"
replace ind_var = 0 if key == "uuid:021408c0-3c5f-42ad-bf3c-4df9fc199963"
replace ind_var = 0 if key == "uuid:e03c2b73-d6ee-4ade-9f1b-9cbdbc89aef8"
replace ind_var = 0 if key == "uuid:cdc2da54-b15a-4620-8ab1-79529d3e76e8"
replace ind_var = 0 if key == "uuid:68e479ee-1a91-4b2c-99d0-cfb335f8aeeb"
replace ind_var = 0 if key == "uuid:e692401a-2af4-4a0f-9e12-1d7bb0856037"
replace ind_var = 0 if key == "uuid:fe78ae3a-df95-4ba8-9205-133a78bb7675"
replace ind_var = 0 if key == "uuid:f5bfd38e-c47c-4d7f-aa1f-37602fef6c9c"
replace ind_var = 0 if key == "uuid:1df09cfd-b5f7-4fa5-8227-199fa261ae20"
replace ind_var = 0 if key == "uuid:76360573-efa2-4b0d-9979-a990ca4571a4"
replace ind_var = 0 if key == "uuid:18f82da1-ec44-4a27-aa91-dc3e5e255ab0"
replace ind_var = 0 if key == "uuid:fd300527-e33a-4519-8ba2-1df30a653a0c"
replace ind_var = 0 if key == "uuid:27c99328-fe86-4b31-956f-6c9aaf3b1284"
replace ind_var = 0 if key == "uuid:ea66090c-4853-434a-8501-93e90526a596"
replace ind_var = 0 if key == "uuid:4f33e08d-f88b-4c66-9f8c-5c6ffcb99c7e"
replace ind_var = 0 if key == "uuid:6b9b2707-4a82-4053-b891-58a4da25d61f"
replace ind_var = 0 if key == "uuid:8cb164e9-bedb-4168-b1fa-f5ce9354c2a9"
replace ind_var = 0 if key == "uuid:2281e503-58c4-4cc7-8d8a-c0f0556fc6fe"
replace ind_var = 0 if key == "uuid:398fb50b-ed82-412f-948c-8c9b36a4d647"
replace ind_var = 0 if key == "uuid:4c778d8f-97d4-47fa-af7d-7e3314c48feb"
replace ind_var = 0 if key == "uuid:731b2b96-2cc9-4c40-ab3d-1c8eca615b1d"
replace ind_var = 0 if key == "uuid:c336de53-c390-436d-8371-5e5bc87a526c"
replace ind_var = 0 if key == "uuid:41e60432-f713-4dd5-8c23-dce0e4f5116d"
replace ind_var = 0 if key == "uuid:44c3f48f-0077-4b77-8299-067409188bf3"
replace ind_var = 0 if key == "uuid:a671b107-d7f9-4662-9727-5a5ee7218919"
replace ind_var = 0 if key == "uuid:76360573-efa2-4b0d-9979-a990ca4571a4"
replace ind_var = 0 if key == "uuid:fd300527-e33a-4519-8ba2-1df30a653a0c"
replace ind_var = 0 if key == "uuid:4a0fe362-32d1-4dad-ba8c-ca382d519c63"
replace ind_var = 0 if key == "uuid:57dd6094-f7b5-43e7-9c80-108266eac06b"
replace ind_var = 0 if key == "uuid:0aa1bd0b-c8f4-493d-a32e-5256cc8a58d0"
replace ind_var = 0 if key == "uuid:7f450507-9f4a-40a5-99e4-8b63c95b4d2c"
replace ind_var = 0 if key == "uuid:4c778d8f-97d4-47fa-af7d-7e3314c48feb"
replace ind_var = 0 if key == "uuid:ea66090c-4853-434a-8501-93e90526a596"
replace ind_var = 0 if key == "uuid:38e50014-cbb3-4ccf-a592-222277e3c778"
replace ind_var = 0 if key == "uuid:e692401a-2af4-4a0f-9e12-1d7bb0856037"
replace ind_var = 0 if key == "uuid:e59e2eae-b1ae-449a-8842-d4641331f136"
replace ind_var = 0 if key == "uuid:ea66090c-4853-434a-8501-93e90526a596"
replace ind_var = 0 if key == "uuid:71a3b9e5-abc7-4e2c-94a3-006da861982b"
replace ind_var = 0 if key == "uuid:63f9341b-cb38-461f-b438-cb6e08f9b1c7"
replace ind_var = 0 if key == "uuid:4a93facc-81f2-47bf-834f-ade9801ee7c8"
replace ind_var = 0 if key == "uuid:16671bba-7134-410e-adcc-d943d1515258"
replace ind_var = 0 if key == "uuid:885049cc-1088-4324-82a2-6a3d1aa5c3bf"
replace ind_var = 0 if key == "uuid:bc6c1d3d-fa4b-4767-9ae5-c7422db73c6c"
replace ind_var = 0 if key == "uuid:d56edb36-89c5-436c-93d2-f3e9f0f601a5"
replace ind_var = 0 if key == "uuid:72ed82ab-7a9a-4eb1-bff3-db27dcae2ad8"
replace ind_var = 0 if key == "uuid:ac73ba38-b143-418d-b5b8-ce3c42cc3cbc"
replace ind_var = 0 if key == "uuid:58f97ff1-d328-4186-b783-6e4eb46e1683"
replace ind_var = 0 if key == "uuid:e883f07a-0650-4828-9cac-5b7f90fa0721"
replace ind_var = 0 if key == "uuid:20c6f12b-0474-449e-88cf-7e4bb8572ccf"
replace ind_var = 0 if key == "uuid:37867bda-7341-492f-a065-8037d1e444de"
replace ind_var = 0 if key == "uuid:10cdabf2-f022-4539-8c2b-7eaa1bead1d1"
replace ind_var = 0 if key == "uuid:d119d84e-18ad-43a8-aaaf-8b807d8af117"
replace ind_var = 0 if key == "uuid:7927b2e6-e46d-4be1-8163-7669e0733149"
replace ind_var = 0 if key == "uuid:dbaf39d5-e977-4dad-a0fd-d3f8f978a2c5"
replace ind_var = 0 if key == "uuid:5dacec94-0b4b-459d-bc8d-7ca6379119bc"
replace ind_var = 0 if key == "uuid:4a93facc-81f2-47bf-834f-ade9801ee7c8"
replace ind_var = 0 if key == "uuid:1e25364f-6fd7-4898-9631-7343b0d1b0f7"
replace ind_var = 0 if key == "uuid:44e9ec51-4de3-4be7-985d-1aed9746258a"
replace ind_var = 0 if key == "uuid:ce5549e0-79b0-4bde-9e8b-37fab5eedf2f"
replace ind_var = 0 if key == "uuid:d9a96108-6ff6-4a01-b035-8c4edbc3d016"
replace ind_var = 0 if key == "uuid:4894e36a-965b-440d-aa57-d70254caa566"
replace ind_var = 0 if key == "uuid:10cdabf2-f022-4539-8c2b-7eaa1bead1d1"
replace ind_var = 0 if key == "uuid:be9e4bd2-80ed-421f-b7e9-118e547dfd7b"
replace ind_var = 0 if key == "uuid:7927b2e6-e46d-4be1-8163-7669e0733149"
replace ind_var = 0 if key == "uuid:16671bba-7134-410e-adcc-d943d1515258"
replace ind_var = 0 if key == "uuid:6995a33b-0e9c-458f-9e49-d08266c63a04"
replace ind_var = 0 if key == "uuid:72ed82ab-7a9a-4eb1-bff3-db27dcae2ad8"
replace ind_var = 0 if key == "uuid:21a44c69-6d8a-4ded-b1b8-98280d8f04c1"
replace ind_var = 0 if key == "uuid:37867bda-7341-492f-a065-8037d1e444de"
replace ind_var = 0 if key == "uuid:1e25364f-6fd7-4898-9631-7343b0d1b0f7"
replace ind_var = 0 if key == "uuid:59d24152-883e-4d28-9e64-01a5d66013fb"
replace ind_var = 0 if key == "uuid:20c6f12b-0474-449e-88cf-7e4bb8572ccf"
replace ind_var = 0 if key == "uuid:5dacec94-0b4b-459d-bc8d-7ca6379119bc"
replace ind_var = 0 if key == "uuid:26b0ed38-3990-4668-bc30-dff21cdb74c0"
replace ind_var = 0 if key == "uuid:63f9341b-cb38-461f-b438-cb6e08f9b1c7"
replace ind_var = 0 if key == "uuid:51bbc017-d8de-4e30-9a9b-3594922d7738"
replace ind_var = 0 if key == "uuid:69019e28-f6ad-44ef-a357-cced4225faa1"
replace ind_var = 0 if key == "uuid:51bbc017-d8de-4e30-9a9b-3594922d7738"
replace ind_var = 0 if key == "uuid:16671bba-7134-410e-adcc-d943d1515258"
replace ind_var = 0 if key == "uuid:952f24db-030b-475b-a2cb-f383305e65e3"
replace ind_var = 0 if key == "uuid:01639e53-ecd4-43fe-bf12-bd59d60e79e6"
replace ind_var = 0 if key == "uuid:21a44c69-6d8a-4ded-b1b8-98280d8f04c1"
replace ind_var = 0 if key == "uuid:d9a96108-6ff6-4a01-b035-8c4edbc3d016"
replace ind_var = 0 if key == "uuid:10cdabf2-f022-4539-8c2b-7eaa1bead1d1"
replace ind_var = 0 if key == "uuid:bc6c1d3d-fa4b-4767-9ae5-c7422db73c6c"
replace ind_var = 0 if key == "uuid:91bc113a-de51-4284-9c11-5f9402f5de2a"
replace ind_var = 0 if key == "uuid:7927b2e6-e46d-4be1-8163-7669e0733149"
replace ind_var = 0 if key == "uuid:f4aa1eed-3ba6-43e0-84f4-3c3a2e7c1e14"
replace ind_var = 0 if key == "uuid:4a93facc-81f2-47bf-834f-ade9801ee7c8"
replace ind_var = 0 if key == "uuid:cb84f382-f029-467d-bb51-4ee455ca0c9d"
replace ind_var = 0 if key == "uuid:18b5cc2f-a861-4487-ba1d-8bb0bbbe13cc"
replace ind_var = 0 if key == "uuid:72ed82ab-7a9a-4eb1-bff3-db27dcae2ad8"
replace ind_var = 0 if key == "uuid:175f92a9-aded-464b-a5ef-684193f755d6"
replace ind_var = 0 if key == "uuid:5dacec94-0b4b-459d-bc8d-7ca6379119bc"
replace ind_var = 0 if key == "uuid:4a93facc-81f2-47bf-834f-ade9801ee7c8"
replace ind_var = 0 if key == "uuid:6995a33b-0e9c-458f-9e49-d08266c63a04"
replace ind_var = 0 if key == "uuid:51bbc017-d8de-4e30-9a9b-3594922d7738"
replace ind_var = 0 if key == "uuid:480e7175-e4f0-467b-ae3d-d2d3c957d314"
replace ind_var = 0 if key == "uuid:f4aa1eed-3ba6-43e0-84f4-3c3a2e7c1e14"
replace ind_var = 0 if key == "uuid:10cdabf2-f022-4539-8c2b-7eaa1bead1d1"
replace ind_var = 0 if key == "uuid:16671bba-7134-410e-adcc-d943d1515258"
replace ind_var = 0 if key == "uuid:58f97ff1-d328-4186-b783-6e4eb46e1683"
replace ind_var = 0 if key == "uuid:4894e36a-965b-440d-aa57-d70254caa566"
replace ind_var = 0 if key == "uuid:21a44c69-6d8a-4ded-b1b8-98280d8f04c1"
replace ind_var = 0 if key == "uuid:cb84f382-f029-467d-bb51-4ee455ca0c9d"
replace ind_var = 0 if key == "uuid:72ed82ab-7a9a-4eb1-bff3-db27dcae2ad8"
replace ind_var = 0 if key == "uuid:44e9ec51-4de3-4be7-985d-1aed9746258a"
replace ind_var = 0 if key == "uuid:18b5cc2f-a861-4487-ba1d-8bb0bbbe13cc"
replace ind_var = 0 if key == "uuid:d9a96108-6ff6-4a01-b035-8c4edbc3d016"
replace ind_var = 0 if key == "uuid:63f9341b-cb38-461f-b438-cb6e08f9b1c7"
replace ind_var = 0 if key == "uuid:bc6c1d3d-fa4b-4767-9ae5-c7422db73c6c"
replace ind_var = 0 if key == "uuid:16671bba-7134-410e-adcc-d943d1515258"
replace ind_var = 0 if key == "uuid:f69cb7e8-65de-4496-b54e-bc11994583e7"
replace ind_var = 0 if key == "uuid:1e25364f-6fd7-4898-9631-7343b0d1b0f7"
replace ind_var = 0 if key == "uuid:d56edb36-89c5-436c-93d2-f3e9f0f601a5"
replace ind_var = 0 if key == "uuid:952f24db-030b-475b-a2cb-f383305e65e3"
replace ind_var = 0 if key == "uuid:10cdabf2-f022-4539-8c2b-7eaa1bead1d1"
replace ind_var = 0 if key == "uuid:dbaf39d5-e977-4dad-a0fd-d3f8f978a2c5"
replace ind_var = 0 if key == "uuid:e256772b-6441-4b1e-9274-0991789ff4e9"
replace ind_var = 0 if key == "uuid:d36c69ef-5cf2-4f39-bde7-7beb5520e907"
replace ind_var = 0 if key == "uuid:72ed82ab-7a9a-4eb1-bff3-db27dcae2ad8"
replace ind_var = 0 if key == "uuid:4a93facc-81f2-47bf-834f-ade9801ee7c8"
replace ind_var = 0 if key == "uuid:dfbffc80-1e52-496c-ba85-f1692acbd5f0"
replace ind_var = 0 if key == "uuid:d9a96108-6ff6-4a01-b035-8c4edbc3d016"
replace ind_var = 0 if key == "uuid:dbaf39d5-e977-4dad-a0fd-d3f8f978a2c5"
replace ind_var = 0 if key == "uuid:e256772b-6441-4b1e-9274-0991789ff4e9"
replace ind_var = 0 if key == "uuid:1e25364f-6fd7-4898-9631-7343b0d1b0f7"
replace ind_var = 0 if key == "uuid:51bbc017-d8de-4e30-9a9b-3594922d7738"
replace ind_var = 0 if key == "uuid:da41eaad-41fa-4adb-b7c6-7c521bc678cf"
replace ind_var = 0 if key == "uuid:4894e36a-965b-440d-aa57-d70254caa566"
replace ind_var = 0 if key == "uuid:f69cb7e8-65de-4496-b54e-bc11994583e7"
replace ind_var = 0 if key == "uuid:f4aa1eed-3ba6-43e0-84f4-3c3a2e7c1e14"
replace ind_var = 0 if key == "uuid:8177e88d-e580-4cc3-837c-68966c731d12"
replace ind_var = 0 if key == "uuid:21a44c69-6d8a-4ded-b1b8-98280d8f04c1"
replace ind_var = 0 if key == "uuid:16671bba-7134-410e-adcc-d943d1515258"
replace ind_var = 0 if key == "uuid:44e9ec51-4de3-4be7-985d-1aed9746258a"
replace ind_var = 0 if key == "uuid:d821e832-2f31-4039-9003-20d913da3311"
replace ind_var = 0 if key == "uuid:72ed82ab-7a9a-4eb1-bff3-db27dcae2ad8"
replace ind_var = 0 if key == "uuid:fff75691-71ee-4a1a-9ea0-807f2bd5908a"
replace ind_var = 0 if key == "uuid:63f9341b-cb38-461f-b438-cb6e08f9b1c7"
replace ind_var = 0 if key == "uuid:7927b2e6-e46d-4be1-8163-7669e0733149"
replace ind_var = 0 if key == "uuid:21a44c69-6d8a-4ded-b1b8-98280d8f04c1"
replace ind_var = 0 if key == "uuid:4894e36a-965b-440d-aa57-d70254caa566"
replace ind_var = 0 if key == "uuid:9592ef45-c1b9-4b5b-a4d6-040ac97fdc5f"
replace ind_var = 0 if key == "uuid:72ed82ab-7a9a-4eb1-bff3-db27dcae2ad8"
replace ind_var = 0 if key == "uuid:cb84f382-f029-467d-bb51-4ee455ca0c9d"
replace ind_var = 0 if key == "uuid:69019e28-f6ad-44ef-a357-cced4225faa1"
replace ind_var = 0 if key == "uuid:1e25364f-6fd7-4898-9631-7343b0d1b0f7"
replace ind_var = 0 if key == "uuid:4a93facc-81f2-47bf-834f-ade9801ee7c8"
replace ind_var = 0 if key == "uuid:dbaf39d5-e977-4dad-a0fd-d3f8f978a2c5"
replace ind_var = 0 if key == "uuid:91bc113a-de51-4284-9c11-5f9402f5de2a"
replace ind_var = 0 if key == "uuid:7927b2e6-e46d-4be1-8163-7669e0733149"
replace ind_var = 0 if key == "uuid:2da18445-e0f4-4b04-a536-bfdaaf05e974"
replace ind_var = 0 if key == "uuid:9592ef45-c1b9-4b5b-a4d6-040ac97fdc5f"
replace ind_var = 0 if key == "uuid:62f6265a-d35b-4b63-a24e-e159377cb165"
replace ind_var = 0 if key == "uuid:9211237f-7b08-4c13-b007-2bc27f4fe27b"
replace ind_var = 0 if key == "uuid:91d4c4b4-ac34-42e9-9e3d-c3491b708ca0"
replace ind_var = 0 if key == "uuid:7857f5dd-b97f-42c2-9506-5fa8bf7847cf"
replace ind_var = 0 if key == "uuid:31c89eaf-8d8c-4319-a80a-e476001b5a9e"
replace ind_var = 0 if key == "uuid:677eb96e-7e1d-4cce-93d3-f743b6c3290c"
replace ind_var = 0 if key == "uuid:b8042304-f055-4121-8b87-84b76c897d63"
replace ind_var = 0 if key == "uuid:31c89eaf-8d8c-4319-a80a-e476001b5a9e"
replace ind_var = 0 if key == "uuid:f7c1d3b1-0f51-495c-9ed5-7fd642518c73"
replace ind_var = 0 if key == "uuid:f7c1d3b1-0f51-495c-9ed5-7fd642518c73"
replace ind_var = 0 if key == "uuid:e73c95dc-e245-49a9-abb6-1f9f95bc5fb1"
replace ind_var = 0 if key == "uuid:9c021088-c048-4623-a9cb-ea3cd9292720"
replace ind_var = 0 if key == "uuid:f7c1d3b1-0f51-495c-9ed5-7fd642518c73"
replace ind_var = 0 if key == "uuid:9211237f-7b08-4c13-b007-2bc27f4fe27b"
replace ind_var = 0 if key == "uuid:869babf6-be9d-49ad-a3e6-b949d3719a28"
replace ind_var = 0 if key == "uuid:00dc6224-fae4-4de7-9d21-2f418b471aca"
replace ind_var = 0 if key == "uuid:677eb96e-7e1d-4cce-93d3-f743b6c3290c"
replace ind_var = 0 if key == "uuid:31c89eaf-8d8c-4319-a80a-e476001b5a9e"
replace ind_var = 0 if key == "uuid:91d4c4b4-ac34-42e9-9e3d-c3491b708ca0"
replace ind_var = 0 if key == "uuid:61ae58e8-67ed-407f-94e6-c83fe4454247"
replace ind_var = 0 if key == "uuid:9f0c73e5-660c-4f8f-9be1-e4f4806229f1"
replace ind_var = 0 if key == "uuid:61ae58e8-67ed-407f-94e6-c83fe4454247"
replace ind_var = 0 if key == "uuid:9211237f-7b08-4c13-b007-2bc27f4fe27b"
replace ind_var = 0 if key == "uuid:65cbfec8-d9d7-4cda-9341-546edf1ffc8b"
replace ind_var = 0 if key == "uuid:9a2701e9-2f77-43c6-948a-00c892e2739f"
replace ind_var = 0 if key == "uuid:31c89eaf-8d8c-4319-a80a-e476001b5a9e"
replace ind_var = 0 if key == "uuid:91d4c4b4-ac34-42e9-9e3d-c3491b708ca0"
replace ind_var = 0 if key == "uuid:dce059c7-c3d8-4f48-9e71-2e6e6ced417b"
replace ind_var = 0 if key == "uuid:001728aa-dfd3-4b19-88d9-daa7c05791c6"
replace ind_var = 0 if key == "uuid:18f89f48-e1c9-4d26-a54d-9279f5ca0355"
replace ind_var = 0 if key == "uuid:e73c95dc-e245-49a9-abb6-1f9f95bc5fb1"
replace ind_var = 0 if key == "uuid:f46febb7-4f27-4491-8bcb-e26865df976b"
replace ind_var = 0 if key == "uuid:2fba3e48-9d7b-4b32-ab2d-990fc6d2d413"
replace ind_var = 0 if key == "uuid:001728aa-dfd3-4b19-88d9-daa7c05791c6"
replace ind_var = 0 if key == "uuid:70dadb25-9ae1-4772-b406-419c7d134f96"
replace ind_var = 0 if key == "uuid:fdf33b9e-6ab7-470a-aa87-213e9241982e"
replace ind_var = 0 if key == "uuid:4219536c-3d1b-4d77-a065-f63913f70d0e"
replace ind_var = 0 if key == "uuid:7857f5dd-b97f-42c2-9506-5fa8bf7847cf"
replace ind_var = 0 if key == "uuid:9211237f-7b08-4c13-b007-2bc27f4fe27b"
replace ind_var = 0 if key == "uuid:887b6285-2eca-449b-885e-3e8a3e9733ac"
replace ind_var = 0 if key == "uuid:b523b6ee-b33f-4331-ac8e-e3770b31148e"
replace ind_var = 0 if key == "uuid:31c89eaf-8d8c-4319-a80a-e476001b5a9e"
replace ind_var = 0 if key == "uuid:c3e6b5a4-b144-4260-bd64-715cff263da9"
replace ind_var = 0 if key == "uuid:9211237f-7b08-4c13-b007-2bc27f4fe27b"
replace ind_var = 0 if key == "uuid:6328ecdf-d662-4f49-b937-36e8d7430b79"
replace ind_var = 0 if key == "uuid:dce059c7-c3d8-4f48-9e71-2e6e6ced417b"
replace ind_var = 0 if key == "uuid:91d4c4b4-ac34-42e9-9e3d-c3491b708ca0"
replace ind_var = 0 if key == "uuid:3adf763f-622e-4cf3-9e2e-cb5a9909deb2"
replace ind_var = 0 if key == "uuid:9a2701e9-2f77-43c6-948a-00c892e2739f"
replace ind_var = 0 if key == "uuid:7857f5dd-b97f-42c2-9506-5fa8bf7847cf"
replace ind_var = 0 if key == "uuid:31c89eaf-8d8c-4319-a80a-e476001b5a9e"
replace ind_var = 0 if key == "uuid:72dbf5df-2ca4-419b-8876-f54246c9919d"
replace ind_var = 0 if key == "uuid:001728aa-dfd3-4b19-88d9-daa7c05791c6"
replace ind_var = 0 if key == "uuid:b523b6ee-b33f-4331-ac8e-e3770b31148e"
replace ind_var = 0 if key == "uuid:29afbbec-6664-48db-9cc4-024245c48be8"
replace ind_var = 0 if key == "uuid:9211237f-7b08-4c13-b007-2bc27f4fe27b"
replace ind_var = 0 if key == "uuid:4219536c-3d1b-4d77-a065-f63913f70d0e"
replace ind_var = 0 if key == "uuid:f7c1d3b1-0f51-495c-9ed5-7fd642518c73"
replace ind_var = 0 if key == "uuid:dce059c7-c3d8-4f48-9e71-2e6e6ced417b"
replace ind_var = 0 if key == "uuid:61ae58e8-67ed-407f-94e6-c83fe4454247"
replace ind_var = 0 if key == "uuid:af2c741b-183a-419c-aac4-334755418d88"
replace ind_var = 0 if key == "uuid:91d4c4b4-ac34-42e9-9e3d-c3491b708ca0"
replace ind_var = 0 if key == "uuid:61ae58e8-67ed-407f-94e6-c83fe4454247"
replace ind_var = 0 if key == "uuid:95d5efa7-920e-4c24-a832-47290c8adf86"
replace ind_var = 0 if key == "uuid:3adf763f-622e-4cf3-9e2e-cb5a9909deb2"
replace ind_var = 0 if key == "uuid:2ec47a04-9451-4eae-863a-709abcb0f494"
replace ind_var = 0 if key == "uuid:e73c95dc-e245-49a9-abb6-1f9f95bc5fb1"
replace ind_var = 0 if key == "uuid:f7c1d3b1-0f51-495c-9ed5-7fd642518c73"
replace ind_var = 0 if key == "uuid:c755bc6d-e89f-4f06-bf41-d36b813d17ef"
replace ind_var = 0 if key == "uuid:3adf763f-622e-4cf3-9e2e-cb5a9909deb2"
replace ind_var = 0 if key == "uuid:61ae58e8-67ed-407f-94e6-c83fe4454247"
replace ind_var = 0 if key == "uuid:91d4c4b4-ac34-42e9-9e3d-c3491b708ca0"
replace ind_var = 0 if key == "uuid:2ec47a04-9451-4eae-863a-709abcb0f494"
replace ind_var = 0 if key == "uuid:757230ee-0ed7-43a2-ab87-de28c4339fd7"
replace ind_var = 0 if key == "uuid:7857f5dd-b97f-42c2-9506-5fa8bf7847cf"
replace ind_var = 0 if key == "uuid:95d5efa7-920e-4c24-a832-47290c8adf86"
replace ind_var = 0 if key == "uuid:31c89eaf-8d8c-4319-a80a-e476001b5a9e"
replace ind_var = 0 if key == "uuid:9a2701e9-2f77-43c6-948a-00c892e2739f"
replace ind_var = 0 if key == "uuid:869babf6-be9d-49ad-a3e6-b949d3719a28"
replace ind_var = 0 if key == "uuid:29afbbec-6664-48db-9cc4-024245c48be8"
replace ind_var = 0 if key == "uuid:9211237f-7b08-4c13-b007-2bc27f4fe27b"
replace ind_var = 0 if key == "uuid:7857f5dd-b97f-42c2-9506-5fa8bf7847cf"
replace ind_var = 0 if key == "uuid:dce059c7-c3d8-4f48-9e71-2e6e6ced417b"
replace ind_var = 0 if key == "uuid:887b6285-2eca-449b-885e-3e8a3e9733ac"
replace ind_var = 0 if key == "uuid:215540ae-d768-4832-817a-9fdcc1755eb2"
replace ind_var = 0 if key == "uuid:e73c95dc-e245-49a9-abb6-1f9f95bc5fb1"
replace ind_var = 0 if key == "uuid:b8042304-f055-4121-8b87-84b76c897d63"
replace ind_var = 0 if key == "uuid:ca23115b-7957-4302-8b26-511c5243ee05"
replace ind_var = 0 if key == "uuid:61f3b362-cd7a-4dec-9d7c-dc982eb1def9"
replace ind_var = 0 if key == "uuid:91d4c4b4-ac34-42e9-9e3d-c3491b708ca0"
replace ind_var = 0 if key == "uuid:9211237f-7b08-4c13-b007-2bc27f4fe27b"
replace ind_var = 0 if key == "uuid:7857f5dd-b97f-42c2-9506-5fa8bf7847cf"
replace ind_var = 0 if key == "uuid:3453d9d5-708b-4f02-8897-cc77ef1f6673"
replace ind_var = 0 if key == "uuid:677eb96e-7e1d-4cce-93d3-f743b6c3290c"
replace ind_var = 0 if key == "uuid:28e5893e-1205-4647-b375-2ab2e07290f8"
replace ind_var = 0 if key == "uuid:3005e9a7-0c4f-4735-a3ee-13a5bd96f68e"
replace ind_var = 0 if key == "uuid:57141e25-c8fe-4256-865c-ffb74b8722f1"
replace ind_var = 0 if key == "uuid:1e1c2c1b-4f20-4c81-aaa7-6177fd8e9133"
replace ind_var = 0 if key == "uuid:9c58f46f-beae-4fef-b4ae-65b5d22dbae8"
replace ind_var = 0 if key == "uuid:a389351c-405b-4fcf-bc2d-4f9b647cd821"
replace ind_var = 0 if key == "uuid:12bd5e4f-c269-49d9-9ac4-31ce86bde8a5"
replace ind_var = 0 if key == "uuid:1e57be6b-bcb6-49dd-b73c-989a0acc3f5c"
replace ind_var = 0 if key == "uuid:da458b40-5f33-47ce-b317-c2e278cd8d79"
replace ind_var = 0 if key == "uuid:b31f7951-4d7b-41af-b373-a0a283ceba75"
replace ind_var = 0 if key == "uuid:d856f3b3-2b61-4838-ba0b-4f8a6ea18725"
replace ind_var = 0 if key == "uuid:9395c227-458d-4a0c-a7ff-11cb8e93046b"
replace ind_var = 0 if key == "uuid:57141e25-c8fe-4256-865c-ffb74b8722f1"
replace ind_var = 0 if key == "uuid:102325d0-e44c-43d8-bf45-03fc0d4bbeeb"
replace ind_var = 0 if key == "uuid:b81044cb-fdfd-41a7-b76b-70a36b935af3"
replace ind_var = 0 if key == "uuid:86eb5846-fbde-44a1-b04c-7dab574f678b"
replace ind_var = 0 if key == "uuid:e053fdfb-769e-46cb-963f-d7d62859c636"
replace ind_var = 0 if key == "uuid:0952b916-0478-409a-aad7-eab78718a734"
replace ind_var = 0 if key == "uuid:9c58f46f-beae-4fef-b4ae-65b5d22dbae8"
replace ind_var = 0 if key == "uuid:102325d0-e44c-43d8-bf45-03fc0d4bbeeb"
replace ind_var = 0 if key == "uuid:75a4d2b2-cae3-4345-aeaa-920a8a97c89c"
replace ind_var = 0 if key == "uuid:9395c227-458d-4a0c-a7ff-11cb8e93046b"
replace ind_var = 0 if key == "uuid:fc088a43-edd6-4622-af6c-63532af6f8d7"
replace ind_var = 0 if key == "uuid:57141e25-c8fe-4256-865c-ffb74b8722f1"
replace ind_var = 0 if key == "uuid:a0dfe598-6001-469b-a7d8-108daf3c97ff"
replace ind_var = 0 if key == "uuid:a389351c-405b-4fcf-bc2d-4f9b647cd821"
replace ind_var = 0 if key == "uuid:a850d7a9-ed56-4f03-8045-6e298dae3fff"
replace ind_var = 0 if key == "uuid:1cf5e8e5-012a-4791-a399-071c5984af16"
replace ind_var = 0 if key == "uuid:b81044cb-fdfd-41a7-b76b-70a36b935af3"
replace ind_var = 0 if key == "uuid:0adb569b-f2f6-43a3-9ad1-5f7f73f18f94"
replace ind_var = 0 if key == "uuid:7f8ec050-0ea9-4858-b4ec-962ff43746dc"
replace ind_var = 0 if key == "uuid:a850d7a9-ed56-4f03-8045-6e298dae3fff"
replace ind_var = 0 if key == "uuid:28e5893e-1205-4647-b375-2ab2e07290f8"
replace ind_var = 0 if key == "uuid:86db61ce-f9cb-4f7a-b0a5-66ffddfdca6a"
replace ind_var = 0 if key == "uuid:28e5893e-1205-4647-b375-2ab2e07290f8"
replace ind_var = 0 if key == "uuid:434fcca5-a3ae-4bdd-a61c-aa38dad0ff28"
replace ind_var = 0 if key == "uuid:1cf5e8e5-012a-4791-a399-071c5984af16"
replace ind_var = 0 if key == "uuid:28e5893e-1205-4647-b375-2ab2e07290f8"
replace ind_var = 0 if key == "uuid:a174f3ae-1533-4f24-9056-c76dc2c8ec40"
replace ind_var = 0 if key == "uuid:e6efc18c-7a7b-4132-8535-6e7dff6a7ac7"
replace ind_var = 0 if key == "uuid:2d69cae2-bc11-4173-a5df-4264bd41d410"
replace ind_var = 0 if key == "uuid:e7469bf6-d4e8-47ee-ae36-7e0c6e04f083"
replace ind_var = 0 if key == "uuid:26971b58-f29b-4ca2-835b-f25a19f057c3"
replace ind_var = 0 if key == "uuid:6bd56dff-d624-4990-a041-d70e21df0faa"
replace ind_var = 0 if key == "uuid:c46b3505-c76a-4882-b658-2fd4db8c3c72"
replace ind_var = 0 if key == "uuid:e6efc18c-7a7b-4132-8535-6e7dff6a7ac7"
replace ind_var = 0 if key == "uuid:90d1e1e8-e397-433d-9199-1031cac8b8b2"
replace ind_var = 0 if key == "uuid:33df7be4-7ed3-4333-b350-13d169e5f9e8"
replace ind_var = 0 if key == "uuid:b4135843-09e3-44e8-b649-7f6dbd35f542"
replace ind_var = 0 if key == "uuid:2d69cae2-bc11-4173-a5df-4264bd41d410"
replace ind_var = 0 if key == "uuid:ae90cd51-ee58-48a1-a6fe-889fcf08947c"
replace ind_var = 0 if key == "uuid:b9db8503-f920-47d7-8c51-d6479521ef3b"
replace ind_var = 0 if key == "uuid:5997c696-23e5-4aff-8dcc-4c0351688c8a"
replace ind_var = 0 if key == "uuid:08f0ed54-98f9-4427-9b44-4e660b0b587d"
replace ind_var = 0 if key == "uuid:b9db8503-f920-47d7-8c51-d6479521ef3b"
replace ind_var = 0 if key == "uuid:84022303-60da-4955-8d55-0a9ba4c498c9"
replace ind_var = 0 if key == "uuid:61320229-0c02-48f3-8f7e-de956c47901f"
replace ind_var = 0 if key == "uuid:322ec7b2-ba87-45b9-812d-dbfdaa8e84b9"
replace ind_var = 0 if key == "uuid:568b7e32-2819-465b-804c-abb5f3234367"
replace ind_var = 0 if key == "uuid:648cabd0-d8bb-4edd-b54d-79f43e1898f6"
replace ind_var = 0 if key == "uuid:322ec7b2-ba87-45b9-812d-dbfdaa8e84b9"
replace ind_var = 0 if key == "uuid:54640edc-0c24-4d19-b5fd-1ef7b02ff3f7"
replace ind_var = 0 if key == "uuid:648cabd0-d8bb-4edd-b54d-79f43e1898f6"
replace ind_var = 0 if key == "uuid:5997c696-23e5-4aff-8dcc-4c0351688c8a"
replace ind_var = 0 if key == "uuid:9b56445b-a27a-487d-81c1-8cf08b18a3f4"
replace ind_var = 0 if key == "uuid:8e5887d9-5caf-49b1-9937-bf3194be19df"
replace ind_var = 0 if key == "uuid:a179c971-c8d3-4d77-9160-4890d793dad1"
replace ind_var = 0 if key == "uuid:1a6dbc16-0aa9-4f14-8d83-03032f5156b9"
replace ind_var = 0 if key == "uuid:4927f745-47f3-4291-a4df-cc42a54c0c5f"
replace ind_var = 0 if key == "uuid:4cfdebc5-579b-42d0-b794-b15ca3d76d05"
replace ind_var = 0 if key == "uuid:39c6bbac-ab4d-40dd-ab10-675b14414eca"
replace ind_var = 0 if key == "uuid:e3d4afc3-003b-4cf9-ac93-63c39fbaa1c3"
replace ind_var = 0 if key == "uuid:fea53255-02cf-493f-823d-016dcc00775a"
replace ind_var = 0 if key == "uuid:3cfdea2d-a374-4d10-9e8b-5bb8e3d04dea"
replace ind_var = 0 if key == "uuid:927795d3-0966-4cc6-9bd2-0ceee0f8bbe8"
replace ind_var = 0 if key == "uuid:5876db44-bf51-4cb8-9785-c206925c8c68"
replace ind_var = 0 if key == "uuid:a70da4bd-2c9f-440f-9943-870137678797"
replace ind_var = 0 if key == "uuid:5876db44-bf51-4cb8-9785-c206925c8c68"
replace ind_var = 0 if key == "uuid:74c9db0a-64c6-41bd-82d1-d85f621a6e1a"
replace ind_var = 0 if key == "uuid:404d64bb-771e-4c85-86ce-ec1ea9b63647"
replace ind_var = 0 if key == "uuid:559b32b7-38a6-4ec1-bcac-d6299c6aeca9"
replace ind_var = 0 if key == "uuid:66b0b7d0-c37f-4ed4-9b1f-72bb0583ba96"
replace ind_var = 0 if key == "uuid:559b32b7-38a6-4ec1-bcac-d6299c6aeca9"
replace ind_var = 0 if key == "uuid:d92acf0d-61ee-4d70-b3b8-c109499ae020"
replace ind_var = 0 if key == "uuid:264e050c-ca67-433c-bc5b-fa53335c1755"
replace ind_var = 0 if key == "uuid:a9d8381b-470f-4704-9042-4af983b17990"

	
	keep if ind_var == 1 
	
	generate issue = "Issue found: Sum of hh_13_`i'_1 - hh_13_`i'_7 is more than hh_10_`i'"
	generate issue_variable_name = "hh_13_`i'_total"
	
	rename hh_13_`i'_total print_issue
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key hh_13_`i'_1  hh_13_`i'_2  hh_13_`i'_3 hh_13_`i'_4  hh_13_`i'_5 hh_13_`i'_6 hh_13_`i'_7 hh_10_`i' 
	  if _N > 0 {
        save "$household_roster\Issue_hh_13_`i'_total_unreasonable.dta", replace
    }
    
	restore
          }
	
***	x.	Hh_21 plus hh_21_o should NOT be greater than hh_18 ***
*** I mixed up the instructions - Molly ***
*KRM - added hh_21_`i'_7 in as it has now been selected *** PROBLEM
forvalues i = 1/57 {

    preserve 

	*** drop no consent households *** 
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 2
	drop if add_new_`i' == 0
	
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
	egen hh_21_`i'_total = rowtotal ( hh_21_o_`i' hh_21_`i'_1  hh_21_`i'_2  hh_21_`i'_3  hh_21_`i'_4  hh_21_`i'_5  hh_21_`i'_6 hh_21_`i'_7 )
        
    *Check if sum of hh_21_i_j and hh_21_o_i is more than sum of hh_18_i
	generate ind_var = 0
	replace ind_var = 1 if hh_21_`i'_total > hh_18_`i'
	replace ind_var = 0 if _household_roster_count < `i'
	replace ind_var = 0 if key == "uuid:d7add78b-5c6b-4f09-a15b-ee9ff0de69e8"
replace ind_var = 0 if key == "uuid:8fdb6f45-873e-4460-b1b7-1ef184fa4ab6"
replace ind_var = 0 if key == "uuid:57bb8e54-caf8-49c9-a0f5-fd636d2a2592"
replace ind_var = 0 if key == "uuid:950634d7-6af7-48f4-81f2-23e84812d304"
replace ind_var = 0 if key == "uuid:07815cfd-fc9e-42e6-823e-83d93c2b9461"
replace ind_var = 0 if key == "uuid:f7b4c6d1-f700-43ec-b688-c5722030e939"
replace ind_var = 0 if key == "uuid:4997f527-1ec1-4a4b-8a9f-85356a6369d7"
replace ind_var = 0 if key == "uuid:a420540e-7ac1-4fdb-ae20-2072c04e743d"
replace ind_var = 0 if key == "uuid:0b0fb3f0-5253-417a-a40c-b4225652ad7f"
replace ind_var = 0 if key == "uuid:7e856dd9-4999-4581-8a10-a211bb7e63b4"
replace ind_var = 0 if key == "uuid:74eb9e02-c087-424c-b7a0-cb63be8a36c7"
replace ind_var = 0 if key == "uuid:d27907d8-f6aa-4b80-81cc-9a1006e1012e"
replace ind_var = 0 if key == "uuid:a420540e-7ac1-4fdb-ae20-2072c04e743d"
replace ind_var = 0 if key == "uuid:a420540e-7ac1-4fdb-ae20-2072c04e743d"
replace ind_var = 0 if key == "uuid:ac8a29b2-ae30-4212-9ae5-d826788cf727"
replace ind_var = 0 if key == "uuid:94d8e8c9-df2a-466b-b173-f7d1403ac905"
replace ind_var = 0 if key == "uuid:0b0fb3f0-5253-417a-a40c-b4225652ad7f"
replace ind_var = 0 if key == "uuid:0b0fb3f0-5253-417a-a40c-b4225652ad7f"
replace ind_var = 0 if key == "uuid:f72c4194-1658-4baa-9e40-7e6b0ea2b3a8"
replace ind_var = 0 if key == "uuid:a63d364d-8238-4c51-a32c-a0b5c9ec3e6a"
replace ind_var = 0 if key == "uuid:a58331c4-b5ce-40a8-af97-c1e0292d8ef1"
replace ind_var = 0 if key == "uuid:b9e97e2c-cb4b-4f65-8865-ff559d932464"
replace ind_var = 0 if key == "uuid:59712e0a-1ba5-483d-8601-552eb329e796"
replace ind_var = 0 if key == "uuid:3d62ede2-09be-4490-8ccf-918371d1b1b9"
replace ind_var = 0 if key == "uuid:94d8e8c9-df2a-466b-b173-f7d1403ac905"
replace ind_var = 0 if key == "uuid:e4d9ab46-b30f-4d93-a47b-9b0e1c367d58"
replace ind_var = 0 if key == "uuid:359accaa-e1f8-4d1c-9aff-706313f0ca4c"
replace ind_var = 0 if key == "uuid:c9c6c412-ce94-4805-96fb-3acb3e1c0732"
replace ind_var = 0 if key == "uuid:fa7f73fd-c387-457f-99aa-da844bb4e83e"
replace ind_var = 0 if key == "uuid:f45cf2eb-9dd7-44c0-b6d1-1b9176ed0dae"
replace ind_var = 0 if key == "uuid:d6b64852-9250-4d85-8208-6fb7b8945ff8"
replace ind_var = 0 if key == "uuid:1f8316b4-c849-40b4-8ced-4cb30d7d5944"
replace ind_var = 0 if key == "uuid:359accaa-e1f8-4d1c-9aff-706313f0ca4c"
replace ind_var = 0 if key == "uuid:3dd76816-ae15-4852-b0bb-9596df462e1a"
replace ind_var = 0 if key == "uuid:ac7acb5b-cc03-405a-b699-c7049bbb6f16"
replace ind_var = 0 if key == "uuid:8b5fa358-6317-4e65-a16f-0fce2d44c6b5"
replace ind_var = 0 if key == "uuid:ac7acb5b-cc03-405a-b699-c7049bbb6f16"
replace ind_var = 0 if key == "uuid:8b5fa358-6317-4e65-a16f-0fce2d44c6b5"
replace ind_var = 0 if key == "uuid:e6d61f8b-bae8-4a27-bda4-6422e002efe7"
replace ind_var = 0 if key == "uuid:14699177-2dd1-4010-8df4-7acc69d307da"
replace ind_var = 0 if key == "uuid:d7cf7d20-89ae-405c-af0f-c9f04d222f68"
replace ind_var = 0 if key == "uuid:17d10f64-73a3-47f9-b5cc-d3181be64f21"
replace ind_var = 0 if key == "uuid:c7c6ac20-be3f-47ba-b2b4-eb17e08123c4"
replace ind_var = 0 if key == "uuid:d7cf7d20-89ae-405c-af0f-c9f04d222f68"
replace ind_var = 0 if key == "uuid:924ae568-e479-4dc0-9311-dd77acb165c1"
replace ind_var = 0 if key == "uuid:ded54860-db67-4e1a-a05c-19603fb0ed65"
replace ind_var = 0 if key == "uuid:5bde4af2-d8dc-4fae-8884-fc042a5d12a6"
replace ind_var = 0 if key == "uuid:e1f57db1-c71f-4b6b-8e34-e79a83b811e1"
replace ind_var = 0 if key == "uuid:94643380-9b5b-4ec2-ac9c-a3fd30a51af7"
replace ind_var = 0 if key == "uuid:82b29ac5-2558-4aa3-a780-b48b45483422"
replace ind_var = 0 if key == "uuid:155e4011-7e23-4a13-9190-c8859bb3641f"
replace ind_var = 0 if key == "uuid:f05825dc-a539-40ff-8384-8edaef71070b"
replace ind_var = 0 if key == "uuid:1a323a88-f1d7-4a74-b448-7ce2d7858fa4"
replace ind_var = 0 if key == "uuid:3836b5eb-ccd2-4c6b-bd5f-bf42d09c166c"
replace ind_var = 0 if key == "uuid:82b29ac5-2558-4aa3-a780-b48b45483422"
replace ind_var = 0 if key == "uuid:3254047a-1f16-4015-a8fd-33c4a15e8787"
replace ind_var = 0 if key == "uuid:7d6f6d9d-c257-4195-8a67-0aecd4e1b233"
replace ind_var = 0 if key == "uuid:347b10a5-29e2-4221-9079-08b5d95c139b"
replace ind_var = 0 if key == "uuid:d7d885fe-9a4f-4a10-8991-80d5fd4dd3f9"
replace ind_var = 0 if key == "uuid:f05825dc-a539-40ff-8384-8edaef71070b"
replace ind_var = 0 if key == "uuid:3836b5eb-ccd2-4c6b-bd5f-bf42d09c166c"
replace ind_var = 0 if key == "uuid:3f50a371-1256-4562-a655-945198622f86"
replace ind_var = 0 if key == "uuid:82b29ac5-2558-4aa3-a780-b48b45483422"
replace ind_var = 0 if key == "uuid:d5f48d8a-650d-40bc-b6ad-a365623fda48"
replace ind_var = 0 if key == "uuid:72625c8e-580a-478f-9989-882ad5867012"
replace ind_var = 0 if key == "uuid:155e4011-7e23-4a13-9190-c8859bb3641f"
replace ind_var = 0 if key == "uuid:94643380-9b5b-4ec2-ac9c-a3fd30a51af7"
replace ind_var = 0 if key == "uuid:d5f48d8a-650d-40bc-b6ad-a365623fda48"
replace ind_var = 0 if key == "uuid:ab7d5d15-0083-4d38-8abb-bb1b924d1b88"
replace ind_var = 0 if key == "uuid:72625c8e-580a-478f-9989-882ad5867012"
replace ind_var = 0 if key == "uuid:347b10a5-29e2-4221-9079-08b5d95c139b"
replace ind_var = 0 if key == "uuid:742d4881-da1e-4e85-9270-0c5bd07d1b00"
replace ind_var = 0 if key == "uuid:94643380-9b5b-4ec2-ac9c-a3fd30a51af7"
replace ind_var = 0 if key == "uuid:1b5acef1-09c9-4be9-ad74-366a633b2c73"
replace ind_var = 0 if key == "uuid:3836b5eb-ccd2-4c6b-bd5f-bf42d09c166c"
replace ind_var = 0 if key == "uuid:f05825dc-a539-40ff-8384-8edaef71070b"
replace ind_var = 0 if key == "uuid:5af3703a-9fbb-417b-9462-88d93d4254f2"
replace ind_var = 0 if key == "uuid:155e4011-7e23-4a13-9190-c8859bb3641f"
replace ind_var = 0 if key == "uuid:ab7d5d15-0083-4d38-8abb-bb1b924d1b88"
replace ind_var = 0 if key == "uuid:7d9f8b44-84f1-4118-b829-ec224829dc78"
replace ind_var = 0 if key == "uuid:94197cc7-302a-4613-b051-35f3647de14f"
replace ind_var = 0 if key == "uuid:bb44cf98-9d46-4333-b702-8f56f6d685b7"
replace ind_var = 0 if key == "uuid:cb40e206-5485-4e94-8ea2-4fb5ab806bc0"
replace ind_var = 0 if key == "uuid:844ab214-bd8f-4cfd-b13e-38ce3bba59a8"
replace ind_var = 0 if key == "uuid:0243f237-580f-48db-81ac-af07d0ec3c7d"
replace ind_var = 0 if key == "uuid:e2eb2697-0ed5-4a5c-8049-b1ea036fbe9c"
replace ind_var = 0 if key == "uuid:74fd4109-e990-42e8-a69a-43a2c2411c7f"
replace ind_var = 0 if key == "uuid:b747834b-3cc5-4e16-a003-c746781d4c3b"
replace ind_var = 0 if key == "uuid:74fd4109-e990-42e8-a69a-43a2c2411c7f"
replace ind_var = 0 if key == "uuid:446cce08-7cc4-44c1-be46-e651f216e5bc"
replace ind_var = 0 if key == "uuid:63a429a2-c4af-4377-9060-8489190a5491"
replace ind_var = 0 if key == "uuid:b508a3ab-9afd-4b4d-ae57-9b3b9c7214de"
replace ind_var = 0 if key == "uuid:e2eb2697-0ed5-4a5c-8049-b1ea036fbe9c"
replace ind_var = 0 if key == "uuid:8f4cbc6a-8472-4738-b738-7057a87ab85e"
replace ind_var = 0 if key == "uuid:e2eb2697-0ed5-4a5c-8049-b1ea036fbe9c"
replace ind_var = 0 if key == "uuid:e2eb2697-0ed5-4a5c-8049-b1ea036fbe9c"
replace ind_var = 0 if key == "uuid:eb71f1ee-5f44-4a52-926b-7db730824f49"
replace ind_var = 0 if key == "uuid:6fd4bf23-18ad-4397-b6e5-51b08c474051"
replace ind_var = 0 if key == "uuid:6aed25d4-b44d-4a4a-95db-cb4659ba83f7"
replace ind_var = 0 if key == "uuid:c3b488c2-9c9d-45fe-a3fa-6576aa6fa1f3"
replace ind_var = 0 if key == "uuid:fd300527-e33a-4519-8ba2-1df30a653a0c"
replace ind_var = 0 if key == "uuid:f74852e0-f784-45df-9ba6-40933da3b8d1"
replace ind_var = 0 if key == "uuid:92bf8c6e-ed5e-45f9-a303-3edb224aa9a9"
replace ind_var = 0 if key == "uuid:33059fa7-c2ec-4757-925c-e9caca8b3365"
replace ind_var = 0 if key == "uuid:c336de53-c390-436d-8371-5e5bc87a526c"
replace ind_var = 0 if key == "uuid:76360573-efa2-4b0d-9979-a990ca4571a4"
replace ind_var = 0 if key == "uuid:e1cd6dc2-003a-44ab-8c0f-3dc63c59ba14"
replace ind_var = 0 if key == "uuid:68e479ee-1a91-4b2c-99d0-cfb335f8aeeb"
replace ind_var = 0 if key == "uuid:7f450507-9f4a-40a5-99e4-8b63c95b4d2c"
replace ind_var = 0 if key == "uuid:e59e2eae-b1ae-449a-8842-d4641331f136"
replace ind_var = 0 if key == "uuid:4a0fe362-32d1-4dad-ba8c-ca382d519c63"
replace ind_var = 0 if key == "uuid:92171a8f-7a48-4292-a5ef-6850b6c04333"
replace ind_var = 0 if key == "uuid:92171a8f-7a48-4292-a5ef-6850b6c04333"
replace ind_var = 0 if key == "uuid:9d9dda6a-deb5-4cce-bd4c-ed3f2bc00381"
replace ind_var = 0 if key == "uuid:b89a7ed1-e6ea-4835-8e6d-2e374b8d1cdb"
replace ind_var = 0 if key == "uuid:e59e2eae-b1ae-449a-8842-d4641331f136"
replace ind_var = 0 if key == "uuid:7df04366-985d-4f5e-895f-61ec47f30529"
replace ind_var = 0 if key == "uuid:1df09cfd-b5f7-4fa5-8227-199fa261ae20"
replace ind_var = 0 if key == "uuid:f5bfd38e-c47c-4d7f-aa1f-37602fef6c9c"
replace ind_var = 0 if key == "uuid:902f961e-7553-4463-81b7-39f9ad8f7903"
replace ind_var = 0 if key == "uuid:e59e2eae-b1ae-449a-8842-d4641331f136"
replace ind_var = 0 if key == "uuid:f5bfd38e-c47c-4d7f-aa1f-37602fef6c9c"
replace ind_var = 0 if key == "uuid:ea66090c-4853-434a-8501-93e90526a596"
replace ind_var = 0 if key == "uuid:5624be26-ca0a-4378-8cf8-c7d181e23ce3"
replace ind_var = 0 if key == "uuid:731b2b96-2cc9-4c40-ab3d-1c8eca615b1d"
replace ind_var = 0 if key == "uuid:7f450507-9f4a-40a5-99e4-8b63c95b4d2c"
replace ind_var = 0 if key == "uuid:a671b107-d7f9-4662-9727-5a5ee7218919"
replace ind_var = 0 if key == "uuid:731b2b96-2cc9-4c40-ab3d-1c8eca615b1d"
replace ind_var = 0 if key == "uuid:38e50014-cbb3-4ccf-a592-222277e3c778"
replace ind_var = 0 if key == "uuid:021408c0-3c5f-42ad-bf3c-4df9fc199963"
replace ind_var = 0 if key == "uuid:f74852e0-f784-45df-9ba6-40933da3b8d1"
replace ind_var = 0 if key == "uuid:c336de53-c390-436d-8371-5e5bc87a526c"
replace ind_var = 0 if key == "uuid:4f33e08d-f88b-4c66-9f8c-5c6ffcb99c7e"
replace ind_var = 0 if key == "uuid:35f6931b-c1e5-4ed4-ac86-d169b66b7963"
replace ind_var = 0 if key == "uuid:e692401a-2af4-4a0f-9e12-1d7bb0856037"
replace ind_var = 0 if key == "uuid:b89a7ed1-e6ea-4835-8e6d-2e374b8d1cdb"
replace ind_var = 0 if key == "uuid:76360573-efa2-4b0d-9979-a990ca4571a4"
replace ind_var = 0 if key == "uuid:0aa1bd0b-c8f4-493d-a32e-5256cc8a58d0"
replace ind_var = 0 if key == "uuid:38e50014-cbb3-4ccf-a592-222277e3c778"
replace ind_var = 0 if key == "uuid:a671b107-d7f9-4662-9727-5a5ee7218919"
replace ind_var = 0 if key == "uuid:c840f2ec-d0ec-4652-9e94-39ce87bad68a"
replace ind_var = 0 if key == "uuid:4c778d8f-97d4-47fa-af7d-7e3314c48feb"
replace ind_var = 0 if key == "uuid:0aa1bd0b-c8f4-493d-a32e-5256cc8a58d0"
replace ind_var = 0 if key == "uuid:27c99328-fe86-4b31-956f-6c9aaf3b1284"
replace ind_var = 0 if key == "uuid:38e50014-cbb3-4ccf-a592-222277e3c778"
replace ind_var = 0 if key == "uuid:c549c58d-ef59-4d7f-a241-ebe47316e790"
replace ind_var = 0 if key == "uuid:68e479ee-1a91-4b2c-99d0-cfb335f8aeeb"
replace ind_var = 0 if key == "uuid:731b2b96-2cc9-4c40-ab3d-1c8eca615b1d"
replace ind_var = 0 if key == "uuid:76360573-efa2-4b0d-9979-a990ca4571a4"
replace ind_var = 0 if key == "uuid:92171a8f-7a48-4292-a5ef-6850b6c04333"
replace ind_var = 0 if key == "uuid:8cb164e9-bedb-4168-b1fa-f5ce9354c2a9"
replace ind_var = 0 if key == "uuid:bbf5c02a-b6e2-4645-bae2-8854d894931f"
replace ind_var = 0 if key == "uuid:e59e2eae-b1ae-449a-8842-d4641331f136"
replace ind_var = 0 if key == "uuid:4a0fe362-32d1-4dad-ba8c-ca382d519c63"
replace ind_var = 0 if key == "uuid:4c778d8f-97d4-47fa-af7d-7e3314c48feb"
replace ind_var = 0 if key == "uuid:ea66090c-4853-434a-8501-93e90526a596"
replace ind_var = 0 if key == "uuid:b1fae32c-057b-45c3-a10b-5fbdf289d4d6"
replace ind_var = 0 if key == "uuid:72ed82ab-7a9a-4eb1-bff3-db27dcae2ad8"
replace ind_var = 0 if key == "uuid:1e25364f-6fd7-4898-9631-7343b0d1b0f7"
replace ind_var = 0 if key == "uuid:dbaf39d5-e977-4dad-a0fd-d3f8f978a2c5"
replace ind_var = 0 if key == "uuid:16671bba-7134-410e-adcc-d943d1515258"
replace ind_var = 0 if key == "uuid:ce5549e0-79b0-4bde-9e8b-37fab5eedf2f"
replace ind_var = 0 if key == "uuid:885049cc-1088-4324-82a2-6a3d1aa5c3bf"
replace ind_var = 0 if key == "uuid:37867bda-7341-492f-a065-8037d1e444de"
replace ind_var = 0 if key == "uuid:4a93facc-81f2-47bf-834f-ade9801ee7c8"
replace ind_var = 0 if key == "uuid:4a93facc-81f2-47bf-834f-ade9801ee7c8"
replace ind_var = 0 if key == "uuid:da41eaad-41fa-4adb-b7c6-7c521bc678cf"
replace ind_var = 0 if key == "uuid:20c6f12b-0474-449e-88cf-7e4bb8572ccf"
replace ind_var = 0 if key == "uuid:16671bba-7134-410e-adcc-d943d1515258"
replace ind_var = 0 if key == "uuid:5dacec94-0b4b-459d-bc8d-7ca6379119bc"
replace ind_var = 0 if key == "uuid:51bbc017-d8de-4e30-9a9b-3594922d7738"
replace ind_var = 0 if key == "uuid:7927b2e6-e46d-4be1-8163-7669e0733149"
replace ind_var = 0 if key == "uuid:7549994f-023a-4e2f-a015-225aaf53ff2b"
replace ind_var = 0 if key == "uuid:dbaf39d5-e977-4dad-a0fd-d3f8f978a2c5"
replace ind_var = 0 if key == "uuid:61144d37-6700-447a-b358-647e4312819f"
replace ind_var = 0 if key == "uuid:4894e36a-965b-440d-aa57-d70254caa566"
replace ind_var = 0 if key == "uuid:dfbffc80-1e52-496c-ba85-f1692acbd5f0"
replace ind_var = 0 if key == "uuid:37867bda-7341-492f-a065-8037d1e444de"
replace ind_var = 0 if key == "uuid:cb84f382-f029-467d-bb51-4ee455ca0c9d"
replace ind_var = 0 if key == "uuid:72ed82ab-7a9a-4eb1-bff3-db27dcae2ad8"
replace ind_var = 0 if key == "uuid:952f24db-030b-475b-a2cb-f383305e65e3"
replace ind_var = 0 if key == "uuid:4a93facc-81f2-47bf-834f-ade9801ee7c8"
replace ind_var = 0 if key == "uuid:7927b2e6-e46d-4be1-8163-7669e0733149"
replace ind_var = 0 if key == "uuid:51bbc017-d8de-4e30-9a9b-3594922d7738"
replace ind_var = 0 if key == "uuid:01639e53-ecd4-43fe-bf12-bd59d60e79e6"
replace ind_var = 0 if key == "uuid:72ed82ab-7a9a-4eb1-bff3-db27dcae2ad8"
replace ind_var = 0 if key == "uuid:885049cc-1088-4324-82a2-6a3d1aa5c3bf"
replace ind_var = 0 if key == "uuid:d9a96108-6ff6-4a01-b035-8c4edbc3d016"
replace ind_var = 0 if key == "uuid:4894e36a-965b-440d-aa57-d70254caa566"
replace ind_var = 0 if key == "uuid:cb84f382-f029-467d-bb51-4ee455ca0c9d"
replace ind_var = 0 if key == "uuid:58f97ff1-d328-4186-b783-6e4eb46e1683"
replace ind_var = 0 if key == "uuid:72ed82ab-7a9a-4eb1-bff3-db27dcae2ad8"
replace ind_var = 0 if key == "uuid:6995a33b-0e9c-458f-9e49-d08266c63a04"
replace ind_var = 0 if key == "uuid:16671bba-7134-410e-adcc-d943d1515258"
replace ind_var = 0 if key == "uuid:44e9ec51-4de3-4be7-985d-1aed9746258a"
replace ind_var = 0 if key == "uuid:952f24db-030b-475b-a2cb-f383305e65e3"
replace ind_var = 0 if key == "uuid:10cdabf2-f022-4539-8c2b-7eaa1bead1d1"
replace ind_var = 0 if key == "uuid:1e25364f-6fd7-4898-9631-7343b0d1b0f7"
replace ind_var = 0 if key == "uuid:4a93facc-81f2-47bf-834f-ade9801ee7c8"
replace ind_var = 0 if key == "uuid:e256772b-6441-4b1e-9274-0991789ff4e9"
replace ind_var = 0 if key == "uuid:dbaf39d5-e977-4dad-a0fd-d3f8f978a2c5"
replace ind_var = 0 if key == "uuid:72ed82ab-7a9a-4eb1-bff3-db27dcae2ad8"
replace ind_var = 0 if key == "uuid:16671bba-7134-410e-adcc-d943d1515258"
replace ind_var = 0 if key == "uuid:21a44c69-6d8a-4ded-b1b8-98280d8f04c1"
replace ind_var = 0 if key == "uuid:4894e36a-965b-440d-aa57-d70254caa566"
replace ind_var = 0 if key == "uuid:175f92a9-aded-464b-a5ef-684193f755d6"
replace ind_var = 0 if key == "uuid:22fd68b3-1f05-41ef-8b1e-3e4abd12196f"
replace ind_var = 0 if key == "uuid:51bbc017-d8de-4e30-9a9b-3594922d7738"
replace ind_var = 0 if key == "uuid:44e9ec51-4de3-4be7-985d-1aed9746258a"
replace ind_var = 0 if key == "uuid:cb84f382-f029-467d-bb51-4ee455ca0c9d"
replace ind_var = 0 if key == "uuid:4894e36a-965b-440d-aa57-d70254caa566"
replace ind_var = 0 if key == "uuid:da41eaad-41fa-4adb-b7c6-7c521bc678cf"
replace ind_var = 0 if key == "uuid:2da18445-e0f4-4b04-a536-bfdaaf05e974"
replace ind_var = 0 if key == "uuid:da41eaad-41fa-4adb-b7c6-7c521bc678cf"
replace ind_var = 0 if key == "uuid:1a3c002d-843a-4466-8c9d-e1ce3192481f"
replace ind_var = 0 if key == "uuid:677eb96e-7e1d-4cce-93d3-f743b6c3290c"
replace ind_var = 0 if key == "uuid:30adca5f-189e-48eb-9f04-aea83e6e68ac"
replace ind_var = 0 if key == "uuid:91d4c4b4-ac34-42e9-9e3d-c3491b708ca0"
replace ind_var = 0 if key == "uuid:215540ae-d768-4832-817a-9fdcc1755eb2"
replace ind_var = 0 if key == "uuid:7663f63b-a20a-4f80-82df-873214c2f9c4"
replace ind_var = 0 if key == "uuid:31c89eaf-8d8c-4319-a80a-e476001b5a9e"
replace ind_var = 0 if key == "uuid:4219536c-3d1b-4d77-a065-f63913f70d0e"
replace ind_var = 0 if key == "uuid:9211237f-7b08-4c13-b007-2bc27f4fe27b"
replace ind_var = 0 if key == "uuid:869babf6-be9d-49ad-a3e6-b949d3719a28"
replace ind_var = 0 if key == "uuid:7857f5dd-b97f-42c2-9506-5fa8bf7847cf"
replace ind_var = 0 if key == "uuid:31c89eaf-8d8c-4319-a80a-e476001b5a9e"
replace ind_var = 0 if key == "uuid:83dde2f0-83a6-4399-a31b-7067f8553efc"
replace ind_var = 0 if key == "uuid:f7c1d3b1-0f51-495c-9ed5-7fd642518c73"
replace ind_var = 0 if key == "uuid:e73c95dc-e245-49a9-abb6-1f9f95bc5fb1"
replace ind_var = 0 if key == "uuid:f7c1d3b1-0f51-495c-9ed5-7fd642518c73"
replace ind_var = 0 if key == "uuid:e73c95dc-e245-49a9-abb6-1f9f95bc5fb1"
replace ind_var = 0 if key == "uuid:f7c1d3b1-0f51-495c-9ed5-7fd642518c73"
replace ind_var = 0 if key == "uuid:001728aa-dfd3-4b19-88d9-daa7c05791c6"
replace ind_var = 0 if key == "uuid:91d4c4b4-ac34-42e9-9e3d-c3491b708ca0"
replace ind_var = 0 if key == "uuid:9a2701e9-2f77-43c6-948a-00c892e2739f"
replace ind_var = 0 if key == "uuid:e73c95dc-e245-49a9-abb6-1f9f95bc5fb1"
replace ind_var = 0 if key == "uuid:31c89eaf-8d8c-4319-a80a-e476001b5a9e"
replace ind_var = 0 if key == "uuid:28908175-7036-4f13-8443-f8d32671115a"
replace ind_var = 0 if key == "uuid:c2de282c-8658-4964-9675-354e51d41670"
replace ind_var = 0 if key == "uuid:757230ee-0ed7-43a2-ab87-de28c4339fd7"
replace ind_var = 0 if key == "uuid:9211237f-7b08-4c13-b007-2bc27f4fe27b"
replace ind_var = 0 if key == "uuid:f46febb7-4f27-4491-8bcb-e26865df976b"
replace ind_var = 0 if key == "uuid:31c89eaf-8d8c-4319-a80a-e476001b5a9e"
replace ind_var = 0 if key == "uuid:95d5efa7-920e-4c24-a832-47290c8adf86"
replace ind_var = 0 if key == "uuid:869babf6-be9d-49ad-a3e6-b949d3719a28"
replace ind_var = 0 if key == "uuid:7857f5dd-b97f-42c2-9506-5fa8bf7847cf"
replace ind_var = 0 if key == "uuid:61ae58e8-67ed-407f-94e6-c83fe4454247"
replace ind_var = 0 if key == "uuid:9a2701e9-2f77-43c6-948a-00c892e2739f"
replace ind_var = 0 if key == "uuid:9a2701e9-2f77-43c6-948a-00c892e2739f"
replace ind_var = 0 if key == "uuid:9211237f-7b08-4c13-b007-2bc27f4fe27b"
replace ind_var = 0 if key == "uuid:3adf763f-622e-4cf3-9e2e-cb5a9909deb2"
replace ind_var = 0 if key == "uuid:372c5f3a-79bf-45ce-a55d-6f9b02144b35"
replace ind_var = 0 if key == "uuid:869babf6-be9d-49ad-a3e6-b949d3719a28"
replace ind_var = 0 if key == "uuid:53fe3ce0-e78b-4d9e-b72e-9f0f0563cd82"
replace ind_var = 0 if key == "uuid:31c89eaf-8d8c-4319-a80a-e476001b5a9e"
replace ind_var = 0 if key == "uuid:001728aa-dfd3-4b19-88d9-daa7c05791c6"
replace ind_var = 0 if key == "uuid:f7c1d3b1-0f51-495c-9ed5-7fd642518c73"
replace ind_var = 0 if key == "uuid:9a2701e9-2f77-43c6-948a-00c892e2739f"
replace ind_var = 0 if key == "uuid:af2c741b-183a-419c-aac4-334755418d88"
replace ind_var = 0 if key == "uuid:887b6285-2eca-449b-885e-3e8a3e9733ac"
replace ind_var = 0 if key == "uuid:e73c95dc-e245-49a9-abb6-1f9f95bc5fb1"
replace ind_var = 0 if key == "uuid:2ec47a04-9451-4eae-863a-709abcb0f494"
replace ind_var = 0 if key == "uuid:95d5efa7-920e-4c24-a832-47290c8adf86"
replace ind_var = 0 if key == "uuid:f46febb7-4f27-4491-8bcb-e26865df976b"
replace ind_var = 0 if key == "uuid:3adf763f-622e-4cf3-9e2e-cb5a9909deb2"
replace ind_var = 0 if key == "uuid:9211237f-7b08-4c13-b007-2bc27f4fe27b"
replace ind_var = 0 if key == "uuid:28908175-7036-4f13-8443-f8d32671115a"
replace ind_var = 0 if key == "uuid:e73c95dc-e245-49a9-abb6-1f9f95bc5fb1"
replace ind_var = 0 if key == "uuid:91d4c4b4-ac34-42e9-9e3d-c3491b708ca0"
replace ind_var = 0 if key == "uuid:757230ee-0ed7-43a2-ab87-de28c4339fd7"
replace ind_var = 0 if key == "uuid:70dadb25-9ae1-4772-b406-419c7d134f96"
replace ind_var = 0 if key == "uuid:61ae58e8-67ed-407f-94e6-c83fe4454247"
replace ind_var = 0 if key == "uuid:dce059c7-c3d8-4f48-9e71-2e6e6ced417b"
replace ind_var = 0 if key == "uuid:7857f5dd-b97f-42c2-9506-5fa8bf7847cf"
replace ind_var = 0 if key == "uuid:65cbfec8-d9d7-4cda-9341-546edf1ffc8b"
replace ind_var = 0 if key == "uuid:31c89eaf-8d8c-4319-a80a-e476001b5a9e"
replace ind_var = 0 if key == "uuid:e73c95dc-e245-49a9-abb6-1f9f95bc5fb1"
replace ind_var = 0 if key == "uuid:e8949caf-47ee-4e5e-8b89-3eced60feb3d"
replace ind_var = 0 if key == "uuid:95d5efa7-920e-4c24-a832-47290c8adf86"
replace ind_var = 0 if key == "uuid:9a2701e9-2f77-43c6-948a-00c892e2739f"
replace ind_var = 0 if key == "uuid:677eb96e-7e1d-4cce-93d3-f743b6c3290c"
replace ind_var = 0 if key == "uuid:f46febb7-4f27-4491-8bcb-e26865df976b"
replace ind_var = 0 if key == "uuid:29afbbec-6664-48db-9cc4-024245c48be8"
replace ind_var = 0 if key == "uuid:a0e2eb23-b126-46c1-a2e9-5f81cfc2e9be"
replace ind_var = 0 if key == "uuid:7857f5dd-b97f-42c2-9506-5fa8bf7847cf"
replace ind_var = 0 if key == "uuid:887b6285-2eca-449b-885e-3e8a3e9733ac"
replace ind_var = 0 if key == "uuid:9211237f-7b08-4c13-b007-2bc27f4fe27b"
replace ind_var = 0 if key == "uuid:e73c95dc-e245-49a9-abb6-1f9f95bc5fb1"
replace ind_var = 0 if key == "uuid:9a2701e9-2f77-43c6-948a-00c892e2739f"
replace ind_var = 0 if key == "uuid:887b6285-2eca-449b-885e-3e8a3e9733ac"
replace ind_var = 0 if key == "uuid:e73c95dc-e245-49a9-abb6-1f9f95bc5fb1"
replace ind_var = 0 if key == "uuid:7857f5dd-b97f-42c2-9506-5fa8bf7847cf"
replace ind_var = 0 if key == "uuid:9211237f-7b08-4c13-b007-2bc27f4fe27b"
replace ind_var = 0 if key == "uuid:86eb5846-fbde-44a1-b04c-7dab574f678b"
replace ind_var = 0 if key == "uuid:c07e60ea-2961-45fb-b5ef-06d4a42f3112"
replace ind_var = 0 if key == "uuid:a389351c-405b-4fcf-bc2d-4f9b647cd821"
replace ind_var = 0 if key == "uuid:1cf5e8e5-012a-4791-a399-071c5984af16"
replace ind_var = 0 if key == "uuid:28e5893e-1205-4647-b375-2ab2e07290f8"
replace ind_var = 0 if key == "uuid:86eb5846-fbde-44a1-b04c-7dab574f678b"
replace ind_var = 0 if key == "uuid:9395c227-458d-4a0c-a7ff-11cb8e93046b"
replace ind_var = 0 if key == "uuid:fc088a43-edd6-4622-af6c-63532af6f8d7"
replace ind_var = 0 if key == "uuid:66c36843-1e4c-4576-9c41-c73386bee59b"
replace ind_var = 0 if key == "uuid:ad62df08-a2f4-412c-9a12-33d751c33145"
replace ind_var = 0 if key == "uuid:a389351c-405b-4fcf-bc2d-4f9b647cd821"
replace ind_var = 0 if key == "uuid:1cf5e8e5-012a-4791-a399-071c5984af16"
replace ind_var = 0 if key == "uuid:883f0ef3-0cc3-4683-a943-c3ffce7e8be4"
replace ind_var = 0 if key == "uuid:28e5893e-1205-4647-b375-2ab2e07290f8"
replace ind_var = 0 if key == "uuid:28e5893e-1205-4647-b375-2ab2e07290f8"
replace ind_var = 0 if key == "uuid:a9b198b5-e8e9-457d-9967-1ac777669d76"
replace ind_var = 0 if key == "uuid:1e699d0e-8fd7-45b6-9918-675b0fa7ec72"
replace ind_var = 0 if key == "uuid:b4135843-09e3-44e8-b649-7f6dbd35f542"
replace ind_var = 0 if key == "uuid:f2320249-e402-4c29-aea1-6c2dab838a8b"
replace ind_var = 0 if key == "uuid:8befef83-7f84-46ca-87f6-742b686956e6"
replace ind_var = 0 if key == "uuid:747bb817-d058-45b2-8f6d-e714a957afe6"
replace ind_var = 0 if key == "uuid:43b22eb4-baf0-4a10-ad3f-06206f134da1"
replace ind_var = 0 if key == "uuid:90d1e1e8-e397-433d-9199-1031cac8b8b2"
replace ind_var = 0 if key == "uuid:f2320249-e402-4c29-aea1-6c2dab838a8b"
replace ind_var = 0 if key == "uuid:5997c696-23e5-4aff-8dcc-4c0351688c8a"
replace ind_var = 0 if key == "uuid:648cabd0-d8bb-4edd-b54d-79f43e1898f6"
replace ind_var = 0 if key == "uuid:b9db8503-f920-47d7-8c51-d6479521ef3b"
replace ind_var = 0 if key == "uuid:f953cc65-f449-4a67-bab4-853b16aabad1"
replace ind_var = 0 if key == "uuid:79cf1220-8069-4576-9ce5-5bafd31008a2"
replace ind_var = 0 if key == "uuid:648cabd0-d8bb-4edd-b54d-79f43e1898f6"
replace ind_var = 0 if key == "uuid:322ec7b2-ba87-45b9-812d-dbfdaa8e84b9"
replace ind_var = 0 if key == "uuid:834bc878-e406-4f6e-88bc-c90a37031753"
replace ind_var = 0 if key == "uuid:008de754-4ff1-43e5-ae4d-21d1760039e2"
replace ind_var = 0 if key == "uuid:1a6dbc16-0aa9-4f14-8d83-03032f5156b9"
replace ind_var = 0 if key == "uuid:4cfdebc5-579b-42d0-b794-b15ca3d76d05"
replace ind_var = 0 if key == "uuid:afc485f1-70e0-4936-8c2c-66328f28ee3d"
replace ind_var = 0 if key == "uuid:8a5eda95-e722-4569-9fcc-33134c4bae2a"
replace ind_var = 0 if key == "uuid:e08a2cc4-c24a-4e63-801c-5ab205695c7b"
replace ind_var = 0 if key == "uuid:927795d3-0966-4cc6-9bd2-0ceee0f8bbe8"
replace ind_var = 0 if key == "uuid:a177145f-c36f-42f1-9595-bb4e759b7923"
replace ind_var = 0 if key == "uuid:44f20f67-c22c-4c86-86d2-0b468d0b47cd"
replace ind_var = 0 if key == "uuid:a0188f55-5d08-45c9-b274-70b5ba016033"

	
	keep if ind_var == 1 
     
	generate issue = "Issue found: Sum of hh_21_`i' and hh_21_o_`i' is more than hh_18_`i'" 
   	generate issue_variable_name = "hh_21_total_`i'"
	rename  hh_21_`i'_total print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key   hh_21_`i'_1  hh_21_`i'_2  hh_21_`i'_3  hh_21_`i'_4  hh_21_`i'_5  hh_21_`i'_6 hh_21_`i'_7 hh_21_o_`i' hh_18_`i'
	
	if _N > 0 {
        save "$household_roster\Issue_Household_sum_less_than_hh_18_`i'.dta", replace
    }
	  restore
    }
  
  

***	i.	hh_ethnicity_o should be answered when hh_ethnicity = 99, response should be text ***  *** CHECKED


forvalues i = 1/57 {
preserve

	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 2
	drop if add_new_`i' == 0
	
    local hh_ethnicity hh_ethnicity_`i'
	local hh_ethnicity_o hh_ethnicity_o_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
	
	
	gen ind_var = 0
    replace ind_var = 1 if `hh_ethnicity' == 99 & missing(`hh_ethnicity_o') 

		
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "`hh_ethnicity_o'"
	rename `hh_ethnicity_o' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_`hh_ethnicity_o'_missing", replace
}
restore

}


***	ii.	hh_releation_with_o should be answered when hh_relation_with = 12 or hh_relation_with = 13, response should be text ***
*** add check to make sure there are that many household members ***    ***CHECKED


forvalues i = 1/57 {
preserve

	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 2
	drop if add_new_`i' == 0
	
    local hh_relation_with hh_relation_with_`i'
	local hh_relation_with_o hh_relation_with_o_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
	
	gen ind_var = 0
	keep if `hh_relation_with' == 12 | `hh_relation_with' == 13 
	replace ind_var = 1 if missing(`hh_relation_with_o') 
	replace ind_var = 0 if _household_roster_count < `i'
	
	keep if ind_var == 1 
	
		
	generate issue = "Missing"
	generate issue_variable_name = "`hh_relation_with_o'"
	rename `hh_relation_with_o' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_`hh_relation_with_o'_missing", replace
}
restore

}


***	iii.	hh_education_level_o should be answered when hh_education_level = 99, response should be text ***   *** CHECKED

forvalues i = 1/57 {
preserve

	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 2
	drop if add_new_`i' == 0
	
	local hh_education_level hh_education_level_`i'
    local hh_education_level_o hh_education_level_o_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
	
	gen ind_var = 0
    replace ind_var = 1 if `hh_education_level' == 99 &  missing(`hh_education_level_o') 
	keep if ind_var == 1 
		
	generate issue = "Missing"
	generate issue_variable_name = "`hh_education_level_o'"
	rename `hh_education_level_o' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_`hh_education_level_o'_missing", replace
}
restore

}


***	iv.	hh_main_activity_o should be answered when hh_main_activity = 99, response should be text ***   ***CHECKED

forvalues i = 1/57 {
preserve

	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 2
	drop if add_new_`i' == 0
	
	local hh_main_activity hh_main_activity_`i'
    local hh_main_activity_o hh_main_activity_o_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
	
	gen ind_var = 0
    replace ind_var = 1 if `hh_main_activity' == 99 &  missing(`hh_main_activity_o') 
	keep if ind_var == 1 
		
	generate issue = "Missing"
	generate issue_variable_name = "`hh_main_activity_o'"
	rename `hh_main_activity_o' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_`hh_main_activity_o'_missing", replace
}
restore

}


***	v.	hh_04 should be answered when hh_03 = 1, should be between 0 and 168 or -9 ***   *** CHECKED

forvalues i = 1/57 {
preserve


	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 2
	drop if add_new_`i' == 0
	
	local hh_04 hh_04_`i'
    local hh_03 hh_03_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
	
	gen ind_var = 0
    keep if `hh_03' == 1 
	replace ind_var = 1 if `hh_04' > 168
	replace ind_var = 1 if `hh_04' < 0 & `hh_04' != -9
	keep if ind_var == 1 

		
	generate issue = "Unreasonable value"
	generate issue_variable_name = "`hh_04'"
	rename `hh_04' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_hh_04_`i'", replace
}
restore

}


*** vi.	hh_05 should be answered when hh_03 = 1, should be between 0 and 168 or -9 ***  *** CHECKED constraint shouldve been 80


forvalues i = 1/57 {
preserve

	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 2
	drop if add_new_`i' == 0
	
	local hh_05 hh_05_`i'
    local hh_03 hh_03_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
	
	gen ind_var = 0
    keep if `hh_03' == 1 
	replace ind_var = 1 if  `hh_05' > 80
	replace ind_var = 1 if `hh_05' < 0 & `hh_05' != -9
	keep if ind_var == 1 

		
	generate issue = "Unreasonable value"
	generate issue_variable_name = "`hh_05'"
	rename `hh_05' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_hh_05_`i'", replace
}
restore

}


***	vii. hh_06 should be answered when hh_03 = 1, should be between 0 and 168 or -9 ***   *** CHECKED CHANGED CONSTRAINT TO 80

forvalues i = 1/57 {
preserve

	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 2
	drop if add_new_`i' == 0
	
	local hh_06 hh_06_`i'
    local hh_03 hh_03_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
	
	gen ind_var = 0    
	keep if `hh_03' == 1 
	replace ind_var = 1 if `hh_06' > 80
	replace ind_var =1 if `hh_06' < 0 & `hh_06' != -9
	keep if ind_var == 1 

		
	generate issue = "Unreasonable value"
	generate issue_variable_name = "`hh_06'"
	rename `hh_06' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_hh_06_`i'", replace
}
restore

}

***	vii. hh_07 should be answered when hh_03 = 1, should be between 0 and 168 or -9 ***  *** CHECKED CHANGED CONSTRAINT TO 80

forvalues i = 1/57 {
preserve

	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 2
	drop if add_new_`i' == 0
	
	local hh_07 hh_07_`i'
    local hh_03 hh_03_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
	
	gen ind_var = 0    
	keep if `hh_03' == 1 
	replace ind_var = 1 if `hh_07' > 80
	replace ind_var =1 if `hh_07' < 0 & `hh_07' != -9
	keep if ind_var == 1 

		
	generate issue = "Unreasonable value"
	generate issue_variable_name = "`hh_07'"
	rename `hh_07' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_hh_07_`i'", replace
}
restore

}

*** ix.	hh_11 should be answered when hh_10 is greater than 0 ***  *** CHECKED

forvalues i = 1/57 {
preserve

	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 2
	drop if add_new_`i' == 0
	
	local hh_11 hh_11_`i'
    local hh_10 hh_10_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
	
	gen ind_var = 0
    replace ind_var = 1 if `hh_10' > 0 & `hh_10' != . & `hh_11' == .
	keep if ind_var == 1 

		
	generate issue = "Missing"
	generate issue_variable_name = "`hh_11'"
	rename `hh_11' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_hh_11_`i'", replace
}
restore

}


***	x.	hh_11_o should be answered when hh_11 = 99 , should be text ***  *** CHECKED


forvalues i = 1/57 {
preserve
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2	
	drop if add_new_`i' == 2
	drop if add_new_`i' == 0
	
    local hh_11 hh_11_`i'
	local hh_11_o hh_11_o_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
	
	gen ind_var = 0
    replace ind_var = 1 if `hh_11' == 99 & missing(`hh_11_o') 
	keep if ind_var == 1 

		
	generate issue = "Missing"
	generate issue_variable_name = "`hh_11_o'"
	rename `hh_11_o' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_hh_11_o_`i'", replace
}
restore

}


*** xi.	hh_12 should be answered when hh_10 is greater than 0 ***
**# Bookmark #1 again a double nested loopy loop 
*** So this is a SurveyCTO quirk - we only need to check if hh_12_`i' ***
*** is not missing, all the others are generated by SurveyCTO ***    **** CHECKED


forvalues i = 1/57 {
    preserve
	
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 2
	drop if add_new_`i' == 0
	
    local hh_10 hh_10_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
    
	tostring(hh_12_`i'), replace 
    gen ind_var = 0  
	replace ind_var = 1 if `hh_10' > 0 & `hh_10' != . & hh_12_`i' == "."
    
    
	keep if ind_var == 1 
    generate issue = "Issue found: missing hh_12 value"
	generate issue_variable_name = "hh_12_`i'"
	rename hh_12_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_hh_12_`i'", replace
}
restore

}


***	xii. hh_12_a should be answered when hh_10 is greater than 0 ***

forvalues i = 1/57 {
preserve	

	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 2
	drop if add_new_`i' == 0
	
    local hh_12_a hh_12_a_`i'
	local hh_10 hh_10_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
	
	gen ind_var = 0
    replace ind_var = 1 if `hh_10' > 0 & `hh_10' != . & `hh_12_a' == .
	
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "`hh_12_a'"
	rename `hh_12_a' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_hh_12_a_`i'", replace
}
restore

}


***	xiii.	hh_12_o should be answered when hh_12_a = 1, should be text ***    /// PROBLEM

forvalues i = 1/57 {
preserve	

	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 2
	drop if add_new_`i' == 0
	
    local hh_12_a hh_12_a_`i'
	local hh_12_o hh_12_o_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
	
	tostring(`hh_12_o'), replace 
	
	gen ind_var = 0
    keep if `hh_12_a' == 1
	replace ind_var = 1 if missing(`hh_12_o')
	
	keep if ind_var == 1 	
	generate issue = "Missing"
	generate issue_variable_name = "`hh_12_o'"
	rename `hh_12_o' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_hh_12_o_`i'", replace
}
restore

}

// CORRECTED
* Checking hh_12_a_o when hh_12_a == 1
forvalues i = 1/57 {
    preserve	
    
    drop if consent == 0 
    drop if still_member_`i' == 0
    drop if still_member_`i' == 2
    drop if add_new_`i' == 2
    drop if add_new_`i' == 0
    
    local hh_12_a hh_12_a_`i'
    local hh_12_a_o hh_12_a_o_`i'
    local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
    rename `pull_hh_full_name_calc' hh_member_name 
    
    tostring(`hh_12_a_o'), replace 

    gen ind_var = 0
    keep if `hh_12_a' == 1
    replace ind_var = 1 if missing(`hh_12_a_o')

    keep if ind_var == 1 	
    generate issue = "Missing"
    generate issue_variable_name = "`hh_12_a_o'"
    rename `hh_12_a_o' print_issue 
    tostring(print_issue), replace
    keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
    if _N > 0 {
        save "$household_roster\Issue_hh_12_a_o_`i'", replace
    }
    restore
}






*** xiv.	hh_13 should be answered when hh_10 is greater than 0, should be between 0 and 168 or -9 *** 
*** The questions are for each activity in the water and should be checked ***
*** in separate files for unreasonable values individually for presentation *** 

*Note: check max i value
forvalues i = 1/57 {
    preserve
	
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 2
	drop if add_new_`i' == 0
	
    local hh_10 hh_10_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
    
	keep if `hh_10' > 0 & `hh_10' != . 
    gen ind_var = 0 
    replace ind_var = 1 if hh_13_`i'_1 < 0 & hh_13_`i'_1 != -9
	replace ind_var = 1 if hh_13_`i'_1 > 168 
	replace ind_var = 0 if hh_12index_`i'_1 == . 
    keep if ind_var == 1 
    generate issue = "Issue found: unreasonable value in hh_13_`i'_1 "
    generate issue_variable_name = "hh_13_`i'_1"
	rename hh_13_`i'_1 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_hh_13_`i'_1_unreasonable", replace
}
restore

}

*Note: check max i value  *** CHECKED
forvalues i = 1/57 {
    preserve
	
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 2
	drop if add_new_`i' == 0
	
    local hh_10 hh_10_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
    
	keep if `hh_10' > 0 & `hh_10' != . 
    gen ind_var = 0 
    replace ind_var = 1 if hh_13_`i'_2 < 0 & hh_13_`i'_2 != -9
	replace ind_var = 1 if hh_13_`i'_2 > 168 
	replace ind_var = 0 if hh_12index_`i'_2 == . 
    keep if ind_var == 1 
    generate issue = "Issue found: unreasonable value in hh_13_`i'_2 "
    generate issue_variable_name = "hh_13_`i'_2"
	rename hh_13_`i'_2 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 { 
		save "$household_roster\Issue_hh_13_`i'_2_unreasonable", replace
}
restore

}

*Note: check max i value  **** CHECKED
forvalues i = 1/57 {
    preserve
	
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 2
	drop if add_new_`i' == 0
	
    local hh_10 hh_10_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
    
	keep if `hh_10' > 0 & `hh_10' != . 
    gen ind_var = 0 
    replace ind_var = 1 if hh_13_`i'_3 < 0 & hh_13_`i'_3 != -9
	replace ind_var = 1 if hh_13_`i'_3 > 168 
	replace ind_var = 0 if hh_12index_`i'_3 == . 
    keep if ind_var == 1 
    generate issue = "Issue found: unreasonable value in hh_13_`i'_3 "
    generate issue_variable_name = "hh_13_`i'_3"
	rename hh_13_`i'_3 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_hh_13_`i'_3_unreasonable", replace
}
restore

}

*Note: check max i value  //CHECKED
forvalues i = 1/57 {
    preserve
	
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 2
	drop if add_new_`i' == 0
	
    local hh_10 hh_10_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
    
	keep if `hh_10' > 0 & `hh_10' != . 
    gen ind_var = 0 
    replace ind_var = 1 if hh_13_`i'_4 < 0 & hh_13_`i'_4 != -9
	replace ind_var = 1 if hh_13_`i'_4 > 168 
	replace ind_var = 0 if hh_12index_`i'_4 == . 
    keep if ind_var == 1 
    generate issue = "Issue found: unreasonable value in hh_13_`i'_4 "
    generate issue_variable_name = "hh_13_`i'_4"
	rename hh_13_`i'_4 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_hh_13_`i'_4_unreasonable", replace
}
restore

}

*Note: check max i value  // CHECKED
forvalues i = 1/57 {
    preserve
	
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 2
	drop if add_new_`i' == 0
	
    local hh_10 hh_10_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
    
	keep if `hh_10' > 0 & `hh_10' != . 
    gen ind_var = 0 
    replace ind_var = 1 if hh_13_`i'_5 < 0 & hh_13_`i'_5 != -9
	replace ind_var = 1 if hh_13_`i'_5 > 168 
	replace ind_var = 0 if hh_12index_`i'_5 == . 
    keep if ind_var == 1 
    generate issue = "Issue found: unreasonable value in hh_13_`i'_5 "
    generate issue_variable_name = "hh_13_`i'_5"
	rename hh_13_`i'_5 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_hh_13_`i'_5_unreasonable", replace
}
restore

}

*Note: check max i value // CHECKED
forvalues i = 1/57 {
    preserve
	
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 2
	drop if add_new_`i' == 0
	
    local hh_10 hh_10_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
    
	keep if `hh_10' > 0 & `hh_10' != . 
    gen ind_var = 0 
    replace ind_var = 1 if hh_13_`i'_6 < 0 & hh_13_`i'_6 != -9
	replace ind_var = 1 if hh_13_`i'_6 > 168 
	replace ind_var = 0 if hh_12index_`i'_6 == . 
    keep if ind_var == 1 
    generate issue = "Issue found: unreasonable value in hh_13_`i'_6 "
    generate issue_variable_name = "hh_13_`i'_6"
	rename hh_13_`i'_6 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_hh_13_`i'_6_unreasonable", replace
}
restore

}

*KRM - added hh_13_`i'_7 in as it's been selected  //STILL AT 7 *** CHECKED

forvalues i = 1/57 {
    preserve
	
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 2
	drop if add_new_`i' == 0
	
    local hh_10 hh_10_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
    
	keep if `hh_10' > 0 & `hh_10' != . 
    gen ind_var = 0 
    replace ind_var = 1 if hh_13_`i'_7 < 0 & hh_13_`i'_7 != -9
	replace ind_var = 1 if hh_13_`i'_7 > 168 
	replace ind_var = 0 if hh_12index_`i'_7 == . 
    keep if ind_var == 1 
    generate issue = "Issue found: unreasonable value in hh_13_`i'_7 "
    generate issue_variable_name = "hh_13_`i'_7"
	rename hh_13_`i'_7 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_hh_13_`i'_7_unreasonable", replace
}
restore

}


***	xv.	hh_13_o should be answered when hh_12_a = 1, should be between 0 and 168 or -9 ***   /// CHANGED TO 80

*Note: check max i value
forvalues i = 1/57 {
preserve

	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 2
	drop if add_new_`i' == 0
	
	local hh_12_a hh_12_a_`i'
    local hh_13_o hh_13_o_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
	
	gen ind_var = 0
	keep if `hh_12_a' == 1
    replace ind_var = 1 if `hh_13_o' > 80
	replace ind_var = 1 if `hh_13_o' < 0 & `hh_13_o' != -9
	keep if ind_var == 1	
	
	generate issue = "Unreasonable value"
	generate issue_variable_name = "`hh_13_o'"
	rename `hh_13_o' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_`hh_13_o_`i''", replace
}
restore

}

***	xvi.	hh_14 should be answered when hh_10 is greater than 0 and hh_12 = 6 , should be between 0 and 5000000 or -9 ***
*** Another SurveyCTO quirk I didn't explain, to check hh_12 = 6, we can check ***   /// CHECKED
*** the indicator that hh_12_6 = 1 *** 


*Note: check max i value
forvalues i = 1/57 {
	
    preserve
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 2
	drop if add_new_`i' == 0

    local hh_14 hh_14_`i'
    local hh_12 hh_12_6_`i' 
    local hh_10 hh_10_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
    
    gen ind_var = 0
	keep if `hh_10' > 0 & `hh_10' != . & `hh_12' == 1 
    replace ind_var = 1 if `hh_14' > 5000000
	replace ind_var = 1 if `hh_14' < 0 & `hh_14' != -9
	keep if ind_var == 1	
	
    generate issue = "Missing"
    generate issue_variable_name = "`hh_14'"
	rename `hh_14' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_hh_14_`i'", replace
}
restore

}

* KRM - left off here if you need to cary over droping for add_new - i don't think you do and that it's redundent 
** hh_14_a – check that when hh_12_6_`i' == 1 there is an answer, and it is between 1 and 500  
*Note: check max i value  *** PROBLEM ISSUES COMING UP FOR -9
forvalues i = 1/57 {
	
    preserve	
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
    local hh_14_a hh_14_a_`i'
    local hh_12_6 hh_12_6_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
    
    gen ind_var = 0
	replace ind_var = 1 if `hh_12_6' == 1 & missing(`hh_14_a')
	replace ind_var = 1 if `hh_12_6' == 1 & (`hh_14_a' < 1 | `hh_14_a' > 500)
	replace ind_var = 0 if key == "uuid:4ea2408a-89a2-4bd4-8bac-9a8ebbffadd7" & hh_14_a_1 == -9
replace ind_var = 0 if key == "uuid:eb71f1ee-5f44-4a52-926b-7db730824f49" & hh_14_a_13 == -9
replace ind_var = 0 if key == "uuid:3a65ea13-ff58-41d9-bdc8-988bba593355" & hh_14_a_2 == -9
replace ind_var = 0 if key == "uuid:5ed16c12-52c1-46e2-a6c4-8ad9c28cfbeb" & hh_14_a_2 == -9
replace ind_var = 0 if key == "uuid:dedd712c-634c-4665-a874-f139341ecd5f" & hh_14_a_5 == -9
replace ind_var = 0 if key == "uuid:20bb7007-297f-432d-8909-7bea1973059d" & hh_14_a_8 == -9
replace ind_var = 0 if key == "uuid:dedd712c-634c-4665-a874-f139341ecd5f" & hh_14_a_8 == -9
	keep if ind_var == 1	
	
    generate issue = "Unreasonable value"
    generate issue_variable_name = "`hh_14_a'"
	rename `hh_14_a' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_HH_Roster_hh_14_a_`i'", replace
}
restore

}

** hh_14_b – check that when hh_12_6_`i' == 1 there is an answer, and it is between 1 and 100
*Note: check max i value  *** PROBLEM ISSUES COMING UP FOR -9 BUT ALSO VALUES LIKE 0 or 250 WHICH BY SURVEYCTO ARE VALID
forvalues i = 1/57 {
	
    preserve	
	
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
    local hh_14_b hh_14_b_`i'
    local hh_12_6 hh_12_6_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
    
    gen ind_var = 0
	replace ind_var = 1 if `hh_12_6' == 1 & missing(`hh_14_b')
	replace ind_var = 1 if `hh_12_6' == 1 & (`hh_14_b' < 1 | `hh_14_b' > 100)
	replace ind_var = 0 if key == "uuid:f0bebe93-a4f0-40a0-8936-233682b356d1" & hh_14_b_2 == -9
replace ind_var = 0 if key == "uuid:8915a062-0f9a-4c85-a7a6-1b4fa6b3e3f1" & hh_14_b_3 == -9
replace ind_var = 0 if key == "uuid:8915a062-0f9a-4c85-a7a6-1b4fa6b3e3f1" & hh_14_b_5 == -9
replace ind_var = 0 if key == "uuid:dedd712c-634c-4665-a874-f139341ecd5f" & hh_14_b_5 == -9
replace ind_var = 0 if key == "uuid:20bb7007-297f-432d-8909-7bea1973059d" & hh_14_b_8 == -9
replace ind_var = 0 if key == "uuid:dedd712c-634c-4665-a874-f139341ecd5f" & hh_14_b_8 == -9
	keep if ind_var == 1	
	
    generate issue = "Unreasonable value"
    generate issue_variable_name = "`hh_14_b'"
	rename `hh_14_b' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_HH_Roster_hh_14_b_`i'", replace
}
restore

}

***	xvii.	hh_15 should be answered when hh_10 is greater than 0 and hh_12 = 6    **** CHECKED

*Note: check max i value
forvalues i = 1/57 {
	
    preserve	
	
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
    local hh_15 hh_15_`i'
    local hh_12 hh_12_6_`i' 
    local hh_10 hh_10_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
    
    gen ind_var = 0
	keep if `hh_10' > 0 & `hh_10' != . & `hh_12' == 6 
    replace ind_var = 1 if `hh_15' == .
	keep if ind_var == 1
	
    generate issue = "Missing"
    generate issue_variable_name = "`hh_15'"
	rename `hh_15' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_`hh_15'", replace
}
restore

}

*** xviii.	hh_15_o should be answered when hh_15 = 99, should be text ***
*Note: check max i value  **** CHECKED
forvalues i = 1/57 {
	
    preserve	
	
    drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	keep if hh_15_`i' == 99
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 

	tostring(hh_15_o_`i'), replace 
	
    gen ind_var = 0
    replace ind_var = 1 if hh_15_o_`i' == "."
	
	keep if ind_var == 1
    generate issue = "Issue found: missing hh_15_o_`i' value"
    generate issue_variable_name = "hh_15_o_`i'"
	rename hh_15_o_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_hh_15_o_`i'", replace
}
restore

}

***	xix.	hh_16 should be answered when hh_10 is greater than 0, should be between 0 and 168 or -9  
*Note: check max i value   // CHANGED TO 80
forvalues i = 1/57 {
preserve

	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	local hh_16 hh_16_`i'
    local hh_10 hh_10_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
	
	gen ind_var = 0
    keep if  `hh_10' > 0 & `hh_10' != . 
	replace ind_var = 1 if `hh_16' > 80
	replace ind_var = 1 if `hh_16' < 0 & `hh_16' != -9
	keep if ind_var == 1	
	
	generate issue = "Unreasonable value"
	generate issue_variable_name = "`hh_16'"
	rename `hh_16' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_`hh_16'", replace
}
restore

}

*** xx.	hh_17 should be answered when hh_10 is greater than 0, should be between 0 and 168 and -9  
*Note: check max i value   // CORRECTION CHANGED TO 80 TO MATCH SURVEYCTO
forvalues i = 1/57 {
	
preserve

	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	local hh_17 hh_17_`i'
    local hh_10 hh_10_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
	
	gen ind_var = 0
    keep if `hh_10' > 0 & `hh_10' != . 
    replace ind_var = 1 if  `hh_17' > 80
	replace ind_var = 1 if `hh_17' < 0 & `hh_17' == -9
	keep if ind_var == 1	
	
	generate issue = "Unreasonable value"
	generate issue_variable_name = "`hh_17'"
	rename `hh_17' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_`hh_17'", replace
}
restore

}


*** xxi. hh_18 should be answered when hh_10 is greater than 0, should be between 168 and -9  

*Note: check max i value    **** CORRECTION CHANGED TO 80 TO MATCH SURVEY CTO
forvalues i = 1/57 {
preserve

	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	local hh_18 hh_18_`i'
    local hh_10 hh_10_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
	
	gen ind_var = 0
	keep if `hh_10' > 0 & `hh_10' != . 
	replace ind_var = 1 if `hh_18' >80
	replace ind_var = 1 if `hh_18' < 0 & `hh_18' != -9
	keep if ind_var == 1
		
	generate issue = "Unreasonable value"
	generate issue_variable_name = "`hh_18'"
	rename `hh_18' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_`hh_18'", replace
}
restore

}


***	xxii. hh_19 should be answered when hh_10 is greater than 0 and hh_18 is greater than 0 ***

*Note: check max i value     **** CHECKED
forvalues i = 1/57 {
preserve

	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	local hh_19 hh_19_`i'
	local hh_18 hh_18_`i'
    local hh_10 hh_10_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
	
	gen ind_var = 0
    keep if `hh_10' > 0 & `hh_10' != . 
	keep if `hh_18' > 0 & `hh_18' != .
	replace ind_var = 1 if `hh_19' == .
	keep if ind_var == 1

		
	generate issue = "Missing"
	generate issue_variable_name = "`hh_19'"
	rename `hh_19' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_`hh_19'", replace
}
restore

}

***	xxiii.	hh_19_o should be answered when hh_19 = 99, should be text *** 

*Note: check max i value
forvalues i = 1/57 {
preserve

	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
    local hh_19 hh_19_`i'
	local hh_19_o hh_19_o_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
	
	gen ind_var = 0
    keep if `hh_19' == 99 
	replace ind_var =1 if missing(`hh_19_o') 
	keep if ind_var == 1
		
	generate issue = "Missing"
	generate issue_variable_name = "`hh_19_o'"
	rename `hh_19_o' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_`hh_19_o'", replace
}
restore

}

*** xxiv.	hh_20 should be answered when hh_10 is greater than 0 and hh_18 is greater than 0 ***

*Note: check max i value   *** CHECKED
forvalues i = 1/57 {
preserve

	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	local hh_20 hh_20_`i'
	local hh_18 hh_18_`i'
    local hh_10 hh_10_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
	
	tostring `hh_20', replace
	gen ind_var = 0
    keep if `hh_10' > 0 & `hh_10' != . 
	keep if `hh_18' > 0 & `hh_18' != .
	replace ind_var = 1 if missing(`hh_20')
	keep if ind_var == 1 

		
	generate issue = "Missing"
	generate issue_variable_name = "`hh_20'"
	rename `hh_20' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_`hh_20'", replace
}
restore

}

***	xxv. hh_20_a should be answered when hh_10 is greater than 0 and hh_18 is greater than 0 ***
*Note: check max i value  *** CHECKED
forvalues i = 1/57 {
preserve

	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	local hh_20_a hh_20_a_`i'
	local hh_18 hh_18_`i'
    local hh_10 hh_10_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
	
	gen ind_var = 0
    keep if `hh_10' > 0 & `hh_10' != .
	keep if `hh_18' > 0 & `hh_18' != . 
	replace ind_var =1 if `hh_20_a' == .
	keep if ind_var == 1 

		
	generate issue = "Missing"
	generate issue_variable_name = "`hh_20_a'"
	rename `hh_20_a' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_`hh_20_a'", replace
}
restore

}


***	xxvi. hh_20_o should be answered when hh_20_a = 1, should be text *** 
*Note: check max i value   *** CHECKED
forvalues i = 1/57 {
preserve

	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	local hh_20_o hh_20_o_`i'
	local hh_20_a hh_20_a_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
  	
	**in case any value in in hh_20_o is not a string 
	tostring `hh_20_o', replace
	gen ind_var = 0
    keep if `hh_20_a' == 1 
	replace ind_var = 1 if missing(`hh_20_o')
	keep if ind_var == 1

		
	generate issue = "Missing"
	generate issue_variable_name = "`hh_20_o'"
	rename `hh_20_o' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_`hh_20_o'", replace
}
restore

}



*** xxvii.	hh_21 should be answered when hh_10 is greater than 0, should be between 0 and 168 or -9 ***  

*Note: check max i value         **** CHECKED: CHANGED BOUND to 80 TO MATCH SURVEYCTO
forvalues i = 1/57 {
    preserve
	
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
    local hh_10 hh_10_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
    
	keep if `hh_10' > 0 & `hh_10' != . 
    gen ind_var = 0 
    replace ind_var = 1 if hh_21_`i'_1 < 0 & hh_21_`i'_1 != -9
	replace ind_var = 1 if hh_21_`i'_1 > 80 
	replace ind_var = 0 if hh_20index_`i'_1 == . 
    keep if ind_var == 1 
    generate issue = "Issue found: unreasonable value in hh_21_`i'_1 "
    generate issue_variable_name = "hh_21_`i'_1"
	rename hh_21_`i'_1 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_hh_21_`i'_1_unreasonable", replace
}
restore

}

*Note: check max i value  *** CHECKED: CHANGED TO 80 TO MATCH SURVEY CTO
forvalues i = 1/57 {
    preserve
	
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
    local hh_10 hh_10_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
    
	keep if `hh_10' > 0 & `hh_10' != . 
    gen ind_var = 0 
    replace ind_var = 1 if hh_21_`i'_2 < 0 & hh_21_`i'_2 != -9
	replace ind_var = 1 if hh_21_`i'_2 > 80 
	replace ind_var = 0 if hh_20index_`i'_2 == . 
    keep if ind_var == 1 
    generate issue = "Issue found: unreasonable value in hh_21_`i'_2 "
    generate issue_variable_name = "hh_21_`i'_2"
	rename hh_21_`i'_2 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_hh_21_`i'_2_unreasonable", replace
}
restore

}

*Note: check max i value     *** CHECKED CHANGED TO 80 TO MATCH SURVEYCTO
forvalues i = 1/57 {
    preserve
	
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
    local hh_10 hh_10_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
    
	keep if `hh_10' > 0 & `hh_10' != . 
    gen ind_var = 0 
    replace ind_var = 1 if hh_21_`i'_3 < 0 & hh_21_`i'_3 != -9
	replace ind_var = 1 if hh_21_`i'_3 > 80 
	replace ind_var = 0 if hh_20index_`i'_3 == . 
    keep if ind_var == 1 
    generate issue = "Issue found: unreasonable value in hh_21_`i'_3 "
    generate issue_variable_name = "hh_21_`i'_3"
	rename hh_21_`i'_3 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_hh_21_`i'_3_unreasonable", replace
}
restore

}

*Note: check max i value     ****** CHECKED 
forvalues i = 1/57 {  
    preserve
	
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
    local hh_10 hh_10_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
    
	keep if `hh_10' > 0 & `hh_10' != . 
    gen ind_var = 0 
    replace ind_var = 1 if hh_21_`i'_4 < 0 & hh_21_`i'_4 != -9
	replace ind_var = 1 if hh_21_`i'_4 > 80 
	replace ind_var = 0 if hh_20index_`i'_4 == . 
    keep if ind_var == 1 
    generate issue = "Issue found: unreasonable value in hh_21_`i'_4 "
    generate issue_variable_name = "hh_21_`i'_4"
	rename hh_21_`i'_4 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_hh_21_`i'_4_unreasonable", replace
}
restore

}

*Note: check max i value   ***** CHECKED
forvalues i = 1/57 {  
    preserve
	
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
    local hh_10 hh_10_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
    
	keep if `hh_10' > 0 & `hh_10' != . 
    gen ind_var = 0 
    replace ind_var = 1 if hh_21_`i'_5 < 0 & hh_21_`i'_5 != -9
	replace ind_var = 1 if hh_21_`i'_5 > 80 
	replace ind_var = 0 if hh_20index_`i'_5 == . 
    keep if ind_var == 1 
    generate issue = "Issue found: unreasonable value in hh_21_`i'_5 "
    generate issue_variable_name = "hh_21_`i'_5"
	rename hh_21_`i'_5 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_hh_21_`i'_5_unreasonable", replace
}
restore

}

*Note: check max i value   *** CHECKED
forvalues i = 1/57 {
    preserve
	
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
    local hh_10 hh_10_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
    
	keep if `hh_10' > 0 & `hh_10' != . 
    gen ind_var = 0 
    replace ind_var = 1 if hh_21_`i'_6 < 0 & hh_21_`i'_6 != -9
	replace ind_var = 1 if hh_21_`i'_6 > 80 
	replace ind_var = 0 if hh_20index_`i'_6 == . 
    keep if ind_var == 1 
    generate issue = "Issue found: unreasonable value in hh_21_`i'_6 "
    generate issue_variable_name = "hh_21_`i'_6"
	rename hh_21_`i'_6 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_hh_21_`i'_6_unreasonable", replace
}
restore

}

*KRM - added hh_21_`i'_7 back in as it's been selected   *** CHECKED


forvalues i = 1/57 {
    preserve
	
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
    local hh_10 hh_10_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
    
	keep if `hh_10' > 0 & `hh_10' != . 
    gen ind_var = 0 
    replace ind_var = 1 if hh_21_`i'_7 < 0 & hh_21_`i'_7 != -9
	replace ind_var = 1 if hh_21_`i'_7 > 80 
	replace ind_var = 0 if hh_20index_`i'_7 == . 
    keep if ind_var == 1 
    generate issue = "Issue found: unreasonable value in hh_21_`i'_7 "
    generate issue_variable_name = "hh_21_`i'_7"
	rename hh_21_`i'_7 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_hh_21_`i'_7_unreasonable", replace
}
restore

}



***	xxviii.	hh_21_o should be answered when hh_20_a = 1 *** CHECKED

*Note: check max i value
forvalues i = 1/57 {
preserve

	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	local hh_21_o hh_21_o_`i'
	local hh_20_a hh_20_a_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
  	
	**in case any value in in hh_20_o is not a string 
	*tostring `hh_20_o', replace
	gen ind_var = 0
	keep if `hh_20_a' == 1 
    replace ind_var = 1 if `hh_21_o' == .
	keep if ind_var == 1

		
	generate issue = "Missing"
    generate issue_variable_name = "`hh_21_o'"
	rename `hh_21_o' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_`hh_21_o'", replace
}
restore

}

*** xxix.	hh_22 should be answered when hh_20 = 6 and hh_10 is greater than 0 and hh_18 is greater than 0, should be greater than 0 or -9 ***
*** add the hh_20 = 6 check ***

*Note: check max i value
forvalues i = 1/57 {
preserve

	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	local hh_22 hh_22_`i'
	local hh_18 hh_18_`i'
    local hh_10 hh_10_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
	
	gen ind_var = 0
	keep if `hh_10' > 0 & `hh_10' != .
	keep if `hh_18' > 0 & `hh_18' != .
	keep if hh_20_6_`i' == 1 
    replace ind_var = 1 if `hh_22' < 0 & `hh_22' != -9
	keep if ind_var == 1

		
	generate issue = "Missing"
	generate issue_variable_name = "`hh_22'"
	rename `hh_22' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_`hh_22'", replace
}
restore

}

***	xxx.	hh_23 should be answered when hh_20 = 6 and hh_10 is greater than 0 and hh_18 is greater than 0 ***
**# Bookmark #3 changed stuff to strings and I'm only calling on hh_23_i (which are just strings) - want to make sure I interpreted this correctly
* CORRECTED

*Note: check max i value
forvalues i = 1/57 {
preserve

	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	local hh_23 hh_23_`i'
	*local hh_23_99 hh_23_99_`i'
	local hh_20 hh_20_6_`i'
	local hh_18 hh_18_`i'
    local hh_10 hh_10_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
	
	tostring `hh_23', replace
	
	gen ind_var = 0
	 
	keep if  `hh_10' > 0 & `hh_10' != . 
	keep if  `hh_18' > 0 & `hh_18' != . 
	keep if `hh_20' == 6  
	replace ind_var = 1 if missing(`hh_23') 
	keep if ind_var == 1

	generate issue = "Missing"
	generate issue_variable_name = "`hh_23'"
	rename `hh_23' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_`hh_23'", replace
}
restore

}

*** xxxi. hh_23_o should be answered when hh_23 = 99, should be text ***
*Note: check max i value  // CHECK
forvalues i = 1/57 {
preserve

	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	local hh_23 hh_23_99_`i'
	local hh_23_o hh_23_o_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
    
	tostring `hh_23_o', replace
		
	gen ind_var = 0
    keep if `hh_23' == 1
	replace ind_var = 1 if missing(`hh_23_o') 
	keep if ind_var == 1

	generate issue = "Missing"
	generate issue_variable_name = "`hh_23_o'"
	rename `hh_23_o' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_`hh_23_o'", replace
}
restore

}


***	xxxii.	the following questions are for ages 4 to 18: hh_26, hh_27, hh_28, hh_29, hh_29_o, hh_30, hh_31, hh_32, hh_33, hh_34, hh_35, hh_36, hh_37, hh_38, hh_39, hh_40, hh_41, hh_42, hh_43, hh_44, hh_45, hh_46, hh_47, hh_48, hh_49 ***

*** add a check to make sure hh_26 is answered correctly since all the others ***
*** depend on it - I missed this one in the instructions *** 

*** hh_26 should be answered when 4 < age < 18 ***   *** CHECKED

*Note: check max i value
forvalues i = 1/57 {
	preserve 
	
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	keep if hh_age_`i' >= 4 & hh_age_`i' <= 18 
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
	
	gen ind_var = 0 
	replace ind_var = 1 if hh_26_`i' == . 
	keep if ind_var == 1 
	
	generate issue = "Issue found: hh_26_`i' value is missing"
    generate issue_variable_name = "hh_26_`i'"
	rename hh_26_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_hh_26_`i'_missing", replace
}

restore
}

***	 1.	hh_27 should be answered when hh_26 = 0 ***  **** CORRECTED: HH_27 SHOULD ALWAYS BE ANSWERED FOR AGE BOUND
*Note: check max i value
forvalues i = 1/57 {
preserve

	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	local hh_27 hh_27_`i'
	local hh_26 hh_26_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
  	
	**in case any value in in hh_27 is not a string 
	*tostring `hh_27', replace
	gen ind_var = 0
	//keep if  `hh_26' == 0
	keep if hh_age_`i' >= 4 & hh_age_`i' <= 18 
    replace ind_var = 1 if `hh_27' == .
	keep if ind_var == 1

		
	generate issue = "Missing"
	generate issue_variable_name = "`hh_27'"
	rename `hh_27' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_`hh_27'", replace
}
restore

}
***	2.	hh_28 should be answered when hh_27 = 1 ***  *** CHECKED
*Note: check max i value
forvalues i = 1/57 {
preserve

	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	local hh_28 hh_28_`i'
	local hh_27 hh_27_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
  	
	gen ind_var = 0
	keep if  `hh_27' == 1
    replace ind_var = 1 if `hh_28' == .
	keep if ind_var == 1

		
	generate issue = "Missing"
	generate issue_variable_name = "`hh_28'"
	rename `hh_28' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_`hh_28'", replace
}
restore

}



*** 3.	hh_29 should be answered when hh_26 = 1 ***   AND WHEN HH_32 == 0  *** CHECKED
*Note: check max i value
forvalues i = 1/57 {
preserve

	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	local hh_29 hh_29_`i'
	local hh_26 hh_26_`i'
	local hh_32 hh_32_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
  	
	gen ind_var = 0
	keep if `hh_26' == 1
	keep if `hh_32' == 0
    replace ind_var = 1 if `hh_29' == .
	keep if ind_var == 1

	generate issue = "Missing"
	generate issue_variable_name = "`hh_29'"
	rename `hh_29' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_`hh_29'", replace
}
restore

}

*** 4.	hh_29_o should be answered when hh_29 = 99, should be text  ***  *** CHECKED
*Note: check max i value
forvalues i = 1/57 {
preserve

	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	local hh_29 hh_29_`i'
	local hh_29_o hh_29_o_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
  	
	gen ind_var = 0
	keep if `hh_29' == 99
    replace ind_var = 1 if missing(`hh_29_o') 
	keep if ind_var == 1
	
	generate issue = "Missing"
	generate issue_variable_name = "`hh_29_o'"
	rename `hh_29_o' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_`hh_29_o'", replace
}
restore

}



*** 5.	hh_30 should be answered when hh_26 = 1 *** *** CHECKED
*Note: check max i value
forvalues i = 1/57 {
preserve

	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	local hh_30 hh_30_`i'
	local hh_26 hh_26_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
	
	gen ind_var = 0
   	keep if  `hh_26' == 1 
	replace ind_var = 1 if `hh_30' == .
	keep if ind_var == 1
		
	generate issue = "Missing"
	generate issue_variable_name = "`hh_30'"
	rename `hh_30' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_`hh_30'", replace
}
restore

}

***	6.	hh_31 should be answered when hh_30 = 1 ***  *** CHECKED
*Note: check max i value
forvalues i = 1/57 {
preserve

	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	local hh_31 hh_31_`i'
	local hh_30 hh_30_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
	  	
	gen ind_var = 0
    keep if `hh_30' == 1 
	replace ind_var = 1 if `hh_31' == .
	keep if ind_var == 1
		
	generate issue = "Missing"
	generate issue_variable_name = "`hh_31'"
	rename `hh_31' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_`hh_31'", replace
}
restore

}


***	7.	hh_32 should be answered when hh_26 = 1 ***  *** CHECKED


*Note: check max i value
forvalues i = 1/57 {
preserve

	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	local hh_32 hh_32_`i'
	local hh_26 hh_26_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
	  	
	gen ind_var = 0
    keep if `hh_26' == 1 
	replace ind_var = 1 if `hh_32' == .
	keep if ind_var == 1
		
	generate issue = "Missing"
	generate issue_variable_name = "`hh_32'"
	rename `hh_32' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_`hh_32'", replace
}
restore

}



*** Block 3: hh_34 should be answered when hh_32 = 2 ***  *** CORRECTED WHEN hh_32 = 0
*Note: check max i value
forvalues i = 1/57 {
    preserve
	
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
    local hh_34 hh_34_`i'
    local hh_32 hh_32_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 

    gen ind_var = 0
    keep if `hh_32' == 0
    replace ind_var = 1 if missing(`hh_34')
    keep if ind_var == 1

    generate issue = "Missing"
    generate issue_variable_name = "`hh_34'"
    rename `hh_34' print_issue
    tostring(print_issue), replace
    keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
    if _N > 0 {
        save "$household_roster/Issue_`hh_34'", replace
    }
    restore
}


*** 9.	hh_34 should be answered when hh_32 = 0 ***  *** CHECKED

*Note: check max i value
forvalues i = 1/57 {
preserve

	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	local hh_34 hh_34_`i'
	local hh_32 hh_32_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
	
	  	
	gen ind_var = 0
    keep if `hh_32' == 0 
	replace ind_var = 1 if `hh_34' == .
	keep if ind_var == 1

		
	generate issue = "Missing"
	generate issue_variable_name = "`hh_34'"
	rename `hh_34' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_`hh_34'", replace
}
restore

}


*** 10.	hh_35 should be answered when hh_32 = 1 ***   *** CHECKED
*Note: check max i value
forvalues i = 1/57 {
preserve
		  	
    drop if consent == 0 
    drop if still_member_`i' == 0
    drop if still_member_`i' == 2

    rename pull_hh_full_name_calc__`i' hh_member_name 
		  	
    gen ind_var = 0
    keep if hh_32_`i' == 1
    replace ind_var = 1 if hh_35_`i' == .
    replace ind_var = 1 if !inlist(hh_35_`i', 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 99)

    keep if ind_var == 1

		
	generate issue = "Missing\Unreaonsable value"
	generate issue_variable_name = "hh_35_`i'"
	rename hh_35_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_hh_35_`i'", replace
}
restore

}


*** 11.	hh_36 should be answered when hh_32 = 1 ***   *** CHECKED
*Note: check max i value
forvalues i = 1/57 {
preserve

	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	local hh_36 hh_36_`i'
	local hh_32 hh_32_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i'
	rename `pull_hh_full_name_calc' hh_member_name

	gen ind_var = 0
	keep if `hh_32' == 1 
    replace ind_var = 1 if `hh_36' == .
	keep if ind_var == 1
	

		
	generate issue = "Missing"
	generate issue_variable_name = "`hh_36'"
	rename `hh_36' print_issue
	
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_`hh_36'", replace
}
restore

}


*** 12.	hh_37 should be answered when hh_32 = 1 ***       *** CHECKED
*Note: check max i value     
forvalues i = 1/57 {
preserve

	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	local hh_37 hh_37_`i'
	local hh_32 hh_32_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i' 
	rename `pull_hh_full_name_calc' hh_member_name 
		  	
	gen ind_var = 0
	keep if `hh_32' == 1 
    replace ind_var = 1 if `hh_37' == .
	keep if ind_var == 1

		
	generate issue = "Missing"
	generate issue_variable_name = "`hh_37'"
	rename `hh_37' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_`hh_37'", replace
}
restore

}


*** 13.	hh_38 should be answered when hh_32 = 1, should be between 0 and 7 or -9 ***  **** CHECKED

*Note: check max i value
forvalues i = 1/57 {
preserve

	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	keep if hh_age_`i' >= 4 & hh_age_`i' <= 18
	local hh_38 hh_38_`i'
	local hh_32 hh_32_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i'
	rename `pull_hh_full_name_calc' hh_member_name

		  	
	gen ind_var = 0
	keep if `hh_32' == 1 
    replace ind_var = 1 if `hh_38' > 7 
	replace ind_var = 1 if `hh_38' < 0 & `hh_38'!= -9
	keep if ind_var == 1

		
	generate issue = "Unreasonable value"
	generate issue_variable_name = "`hh_38'"
	rename `hh_38' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$household_roster\Issue_`hh_38'", replace
}
restore

}

*** 14. hh_39 should be answered when 4 <= age <= 18, and check that it is between -6 and 60 (inclusive of -6 and 60) ***
*Note: check max i value   **** CHECKED
forvalues i = 1/57 {
    preserve
	
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	keep if hh_age_`i' >= 4 & hh_age_`i' <= 18
    local hh_39 hh_39_`i'
    local hh_age hh_age_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i'
	rename `pull_hh_full_name_calc' hh_member_name

		
    gen ind_var = 0
    replace ind_var = 1 if missing(`hh_39')
	replace ind_var = 1 if `hh_39' < -6 & `hh_39' > 60
    keep if ind_var == 1

    generate issue = "Missing"
    generate issue_variable_name = "`hh_39'"
    rename `hh_39' print_issue 
    tostring(print_issue), replace
    keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
    if _N > 0 {
        save "$household_roster\Issue_`hh_39'", replace
    }
    restore
}

*** 15. hh_40 should be answered when 4 <= age <= 18, and check that it is between -6 and 60 (inclusive of -6 and 60) ***
*Note: check max i value   *** CHECKED
forvalues i = 1/57 {
    preserve
	
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	keep if hh_age_`i' >= 4 & hh_age_`i' <= 18
    local hh_40 hh_40_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i'
	rename `pull_hh_full_name_calc' hh_member_name


    gen ind_var = 0
  
    replace ind_var = 1 if missing(`hh_40')
	replace ind_var = 1 if `hh_40' < -6 & `hh_40' > 60
    keep if ind_var == 1

    generate issue = "Missing"
    generate issue_variable_name = "`hh_40'"
    rename `hh_40' print_issue 
    tostring(print_issue), replace
    keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
    if _N > 0 {
        save "$household_roster\Issue_`hh_40'", replace
    }
    restore
}

*** Block 1: hh_41 should be answered when hh_26 = 1, should have constraint ***
*Note: check max i value  *** PROBLEMS AGE IS LESS THAN AGE STARTED SCHOOL?

forvalues i = 1/57 {
    preserve
	
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
/*
	drop if add_new_`i' == 2
	drop if add_new_`i' == 0
*/
	
	keep if hh_age_`i' >= 4 & hh_age_`i' <= 18
    local hh_41 hh_41_`i'
    local hh_26 hh_26_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i'
	rename `pull_hh_full_name_calc' hh_member_name


    gen ind_var = 0
    keep if `hh_26' == 1
    replace ind_var = 1 if missing(`hh_41')
	replace ind_var = 1 if `hh_41' > hh_age_`i'
	rename hh_age_`i' hh_age
	replace ind_var = 0 if key == "uuid:45e97396-5ee5-4b55-ac86-cbd4824e8263" & hh_41_1 == 6 
replace ind_var = 0 if key == "uuid:9559913d-fb26-4d88-a5f2-27f2142af0ee" & hh_41_1 == 10
replace ind_var = 0 if key == "uuid:db27b6db-6d41-4805-b954-5206411f2e37" & hh_41_1 == 7
replace ind_var = 0 if key == "uuid:d18cf803-5676-4b48-8cde-8d83bd2d9a7b" & hh_41_1 == 7
replace ind_var = 0 if key == "uuid:f0c88bdb-6402-4d30-9bac-69dbd3c847b2" & hh_41_10 == 7
replace ind_var = 0 if key == "uuid:93850388-81f9-49ac-a75c-64fadc48d46b" & hh_41_12 == 6
replace ind_var = 0 if key == "uuid:4839ecdd-b500-45b6-92b0-aa6ed8f890de" & hh_41_12 == 7
replace ind_var = 0 if key == "uuid:e35717b1-f96e-4f9a-a5c4-0ac0981f3d28" & hh_41_14 == 6
replace ind_var = 0 if key == "uuid:de358167-c62b-4063-830a-a3f52a40516e" & hh_41_17 == 7
replace ind_var = 0 if key == "uuid:34d8c58a-a617-487a-b010-93ea0b8dc111" & hh_41_2 == 7
replace ind_var = 0 if key == "uuid:272f19bb-809d-43d4-bae9-d3bcfb6ac22b" & hh_41_2 == 6
replace ind_var = 0 if key == "uuid:f46febb7-4f27-4491-8bcb-e26865df976b" & hh_41_2 == 6
replace ind_var = 0 if key == "uuid:28e5893e-1205-4647-b375-2ab2e07290f8" & hh_41_2 == 6
replace ind_var = 0 if key == "uuid:fa6b632a-58f0-4bc1-a921-5abb0680d79e" & hh_41_22 == 7
replace ind_var = 0 if key == "uuid:6ad3f4d8-0bc2-43c2-b6d8-3fb8114647f8" & hh_41_3 == 7
replace ind_var = 0 if key == "uuid:98a31235-4316-4246-b7f6-8ce887c860fb" & hh_41_4 == 6
replace ind_var = 0 if key == "uuid:464e7c98-71a8-4774-a1db-820c4ca30c91" & hh_41_4 == 7
replace ind_var = 0 if key == "uuid:e2b253d2-9e6d-44f3-8916-4797bf2f8177" & hh_41_4 == 7
replace ind_var = 0 if key == "uuid:df66612e-0d16-4894-88d5-33580308ec91" & hh_41_4 == 5
replace ind_var = 0 if key == "uuid:bd1911e9-4cde-45a5-8f06-cea7ef72c905" & hh_41_5 == 6
replace ind_var = 0 if key == "uuid:d7add78b-5c6b-4f09-a15b-ee9ff0de69e8" & hh_41_5 == 6
replace ind_var = 0 if key == "uuid:6d59bac1-ae47-4d19-ae80-294dbf82865c" & hh_41_5 == 7
replace ind_var = 0 if key == "uuid:3b9fe083-0a4e-4db1-8c63-b494c53d403a" & hh_41_5 == 5
replace ind_var = 0 if key == "uuid:41e60432-f713-4dd5-8c23-dce0e4f5116d" & hh_41_5 == 7
replace ind_var = 0 if key == "uuid:b523b6ee-b33f-4331-ac8e-e3770b31148e" & hh_41_5 == 7
replace ind_var = 0 if key == "uuid:fa6b632a-58f0-4bc1-a921-5abb0680d79e" & hh_41_6 == 7
replace ind_var = 0 if key == "uuid:ca054a55-5420-49cc-b0cd-2a077889231b" & hh_41_6 == 7
replace ind_var = 0 if key == "uuid:bc23d519-8a2a-476f-9c2f-029d70938a8a" & hh_41_6 == 7
replace ind_var = 0 if key == "uuid:b0a54e9c-c1e3-4274-8dd3-f3e452663310" & hh_41_6 == 7
replace ind_var = 0 if key == "uuid:798f8ec4-a21b-4154-ab79-d19b423425a3" & hh_41_7 == 7
replace ind_var = 0 if key == "uuid:a6218164-0bc6-47bc-b937-15e0f66a0a1a" & hh_41_7 == 7
replace ind_var = 0 if key == "uuid:05442505-66f5-4640-8f5a-fa86f34dbd12" & hh_41_8 == 7
replace ind_var = 0 if key == "uuid:715348c5-4975-4ab4-9299-efc393087ce8" & hh_41_9 == 6
replace ind_var = 0 if key == "uuid:e35717b1-f96e-4f9a-a5c4-0ac0981f3d28" & hh_41_9 == 6
    keep if ind_var == 1

    generate issue = "Missing/Reported age for starting school is larger than current age"
    generate issue_variable_name = "`hh_41'"
    rename `hh_41' print_issue
    tostring(print_issue), replace
    keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue hh_age print_issue hh_member_name key
    if _N > 0 {
        save "$household_roster/Issue_`hh_41'", replace
    }
    restore
}


*** check to see that hh_42 is not missing, and that it is 0, 1, or 2  ***  

*Note: check max i value  **** PROBLEM is that hh_42 should be only for those who are enrolled in school when hh_32 == 1 FIXED
forvalues i = 1/57 {
    preserve
	
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	keep if hh_age_`i' >= 4 & hh_age_`i' <= 18
	keep if hh_32_`i' == 1
    local hh_42 hh_42_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i'
	rename `pull_hh_full_name_calc' hh_member_name


    gen ind_var = 0
    replace ind_var = 1 if missing(`hh_42')
	replace ind_var = 1  if `hh_42' != 0 & `hh_42' != 1  & `hh_42' != 2

    keep if ind_var == 1

    generate issue = "Missing"
    generate issue_variable_name = "`hh_42'"
    rename `hh_42' print_issue
    tostring(print_issue), replace
    keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
    if _N > 0 {
        save "$household_roster\Issue_HH_Roster_`hh_42'", replace
    }
    restore
}

***  hh_43 should be answered when hh_42 = 1, and that it is 1, 2, or 3 ***

*Note: check max i value
forvalues i = 1/57 {
    preserve
	
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	keep if hh_age_`i' >= 4 & hh_age_`i' <= 18
    local hh_43 hh_43_`i'
    local hh_42 hh_42_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i'
	rename `pull_hh_full_name_calc' hh_member_name


    gen ind_var = 0
    keep if `hh_42' == 1
    replace ind_var = 1 if missing(`hh_43')
	replace ind_var = 1  if `hh_43' != 1 & `hh_43' != 2  & `hh_43' != 3

    keep if ind_var == 1

    generate issue = "Missing"
    generate issue_variable_name = "`hh_43'"
    rename `hh_43' print_issue
    tostring(print_issue), replace
    keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
    if _N > 0 {
        save "$household_roster\Issue_`hh_43'", replace
    }
    restore
}

***  hh_44 should be answered when hh_42 = 2, and that it is 0, 1, or 2 ***  *** PROBLEM should be when hh_42 == 0 FIXED

*Note: check max i value
forvalues i = 1/57 {
    preserve
	
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if add_new_`i' == 2
	drop if add_new_`i' == 0
	drop if still_member_`i' == 2
	keep if hh_age_`i' >= 4 & hh_age_`i' <= 18
    local hh_44 hh_44_`i'
    local hh_42 hh_42_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i'
	rename `pull_hh_full_name_calc' hh_member_name


    gen ind_var = 0
    keep if `hh_42' == 0
    replace ind_var = 1 if missing(`hh_44')
	replace ind_var = 1  if `hh_44' != 0 & `hh_44' != 1  & `hh_44' != 2
    keep if ind_var == 1

    generate issue = "Missing"
    generate issue_variable_name = "`hh_44'"
    rename `hh_44' print_issue
    tostring(print_issue), replace
    keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
    if _N > 0 {
        save "$household_roster\Issue_`hh_44'", replace
    }
    restore
}

***  hh_45 should be answered when hh_44 = 1, and that it is 0, 1, or 2 ***  PROBLEM should be when hh_32 == 1  FIXED
*Note: check max i value
forvalues i = 1/57 {
    preserve
	
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	keep if hh_age_`i' >= 4 & hh_age_`i' <= 18
    local hh_45 hh_45_`i'
    local hh_44 hh_44_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i'
	rename `pull_hh_full_name_calc' hh_member_name

    gen ind_var = 0
    keep if hh_32_`i' == 1
    replace ind_var = 1 if missing(`hh_45')
	replace ind_var = 1  if `hh_45' != 0 & `hh_45' != 1  & `hh_45' != 2
    keep if ind_var == 1

    generate issue = "Missing"
    generate issue_variable_name = "`hh_45'"
    rename `hh_45' print_issue
    tostring(print_issue), replace
    keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
    if _N > 0 {
        save "$household_roster\Issue_`hh_45'", replace
    }
    restore
}

*** 5. hh_46 should be answered when hh_42 = 2, and check that it is between 1 and 8 (inclusive) *** PROBELEM WHEN hh_42 is 0 FIXED
*Note: check max i value
forvalues i = 1/57 {
    preserve
	
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	keep if hh_age_`i' >= 4 & hh_age_`i' <= 18
    local hh_42 hh_42_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i'
	rename `pull_hh_full_name_calc' hh_member_name


    gen ind_var = 0
    keep if `hh_42' == 0
    replace ind_var = 1 if missing(hh_46_`i')
	replace ind_var = 1 if !inlist(hh_46_`i', 1, 2, 3, 4, 5, 6, 7, 8)
    keep if ind_var == 1

    generate issue = "Missing"
    generate issue_variable_name = "hh_46_`i'"
    rename hh_46_`i' print_issue
    tostring(print_issue), replace
    keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
    if _N > 0 {
        save "$household_roster\Issue_hh_46_`i'", replace
    }
    restore
}



* hh_47_a, hh_47_b, hh_47_c, hh_47_d, hh_47_e, hh_47_f, hh_47_g should be answered 
*Note: check max i value


* hh_47_a

forvalues i = 1/57 {
    preserve
	
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	*KRM - clean this up 
/*
	drop if add_new_`i' == 2
	drop if add_new_`i' == 0
*/
	
	keep if hh_age_`i' >= 4 & hh_age_`i' <= 18
	local hh_47_a hh_47_a_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i'
	rename `pull_hh_full_name_calc' hh_member_name
	
	gen ind_var = 0
    replace ind_var = 1 if `hh_47_a' == .
	replace ind_var = 1 if `hh_47_a' < 0 & `hh_47_a' > 100000
	*replace ind_var = 0 if _household_roster_count < `i'
   
    	* keep and add variables to export *
	keep if ind_var == 1 
	
   
    generate issue = "Missing"
    generate issue_variable_name = "`hh_47_a'"
    rename `hh_47_a' print_issue
    tostring(print_issue), replace
	

    keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
    if _N > 0 {
        save "$household_roster\hh_roster_issue_`hh_47_a'", replace
    }
    restore
}

* hh_47_b

forvalues i = 1/57 {
    preserve
	
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	*KRM - clean this
/*
	drop if add_new_`i' == 2
	drop if add_new_`i' == 0
*/
	
	keep if hh_age_`i' >= 4 & hh_age_`i' <= 18
	local hh_47_b hh_47_b_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i'
	rename `pull_hh_full_name_calc' hh_member_name

	
	gen ind_var = 0
    replace ind_var = 1 if `hh_47_b' == .
	replace ind_var = 1 if `hh_47_b' < 0 & `hh_47_b' > 100000
 	*replace ind_var = 0 if _household_roster_count < `i'

   
    	* keep and add variables to export *
	keep if ind_var == 1 
	
   
    generate issue = "Missing"
    generate issue_variable_name = "`hh_47_b'"
    rename `hh_47_b' print_issue
    tostring(print_issue), replace
    keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
    if _N > 0 {
        save "$household_roster\hh_roster_issue_`hh_47_b'", replace
    }
    restore
}

* hh_47_c

forvalues i = 1/57 {
    preserve
	
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	
	*KRM - clean this up 
/*
	drop if add_new_`i' == 0
	drop if add_new_`i' == 2
*/
	
	keep if hh_age_`i' >= 4 & hh_age_`i' <= 18
	local hh_47_c hh_47_c_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i'
	rename `pull_hh_full_name_calc' hh_member_name

	
	gen ind_var = 0
    replace ind_var = 1 if `hh_47_c' == .
	replace ind_var = 1 if `hh_47_c' < 0 & `hh_47_c' > 100000
 	*replace ind_var = 0 if _household_roster_count < `i'

   
    	* keep and add variables to export *
	keep if ind_var == 1 
	
   
    generate issue = "Missing"
    generate issue_variable_name = "`hh_47_c'"
    rename `hh_47_c' print_issue
    tostring(print_issue), replace
    keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
    if _N > 0 {
        save "$household_roster\hh_roster_issue_`hh_47_c'", replace
    }
    restore
}

* hh_47_d

forvalues i = 1/57 {
    preserve
	
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	keep if hh_age_`i' >= 4 & hh_age_`i' <= 18
	
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i'
	rename `pull_hh_full_name_calc' hh_member_name
	local hh_47_d hh_47_d_`i'
	
	gen ind_var = 0
    replace ind_var = 1 if `hh_47_d' == .
	replace ind_var = 1 if `hh_47_d' < 0 & `hh_47_d' > 100000
 	*replace ind_var = 0 if _household_roster_count < `i'

    	* keep and add variables to export *
	keep if ind_var == 1 
	
   
    generate issue = "Missing"
    generate issue_variable_name = "`hh_47_d'"
    rename `hh_47_d' print_issue
    tostring(print_issue), replace
    keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
    if _N > 0 {
        save "$household_roster\hh_roster_issue_`hh_47_d'", replace
    }
    restore
}


* hh_47_e

forvalues i = 1/57 {
    preserve
	
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	keep if hh_age_`i' >= 4 & hh_age_`i' <= 18
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i'
	rename `pull_hh_full_name_calc' hh_member_name
	local hh_47_e hh_47_e_`i'
	
	gen ind_var = 0
	replace ind_var = 1 if `hh_47_e' == .
	replace ind_var = 1 if `hh_47_e' < 0 & `hh_47_e' > 100000
 	replace ind_var = 0 if _household_roster_count < `i'

   
    	* keep and add variables to export *
	keep if ind_var == 1 
	
   
    generate issue = "Missing"
    generate issue_variable_name = "`hh_47_e'"
    rename `hh_47_e' print_issue
    tostring(print_issue), replace
    keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
    if _N > 0 {
        save "$household_roster\hh_roster_issue_`hh_47_e'", replace
    }
    restore
}

* hh_47_f

forvalues i = 1/57 {
    preserve
	
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	keep if hh_age_`i' >= 4 & hh_age_`i' <= 18
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i'
	rename `pull_hh_full_name_calc' hh_member_name
	local hh_47_f hh_47_f_`i'
	
	gen ind_var = 0
	replace ind_var = 1 if `hh_47_f' == .
	replace ind_var = 1 if `hh_47_f' < 0 & `hh_47_f' > 100000
 	replace ind_var = 0 if _household_roster_count < `i'

   
    	* keep and add variables to export *
	keep if ind_var == 1 
	
   
    generate issue = "Missing"
    generate issue_variable_name = "`hh_47_f'"
    rename `hh_47_f' print_issue
    tostring(print_issue), replace
    keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
    if _N > 0 {
        save "$household_roster\hh_roster_issue_`hh_47_f'", replace
    }
    restore
}

* hh_47_g 

forvalues i = 1/57 {
    preserve
	
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	keep if hh_age_`i' >= 4 & hh_age_`i' <= 18
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i'
	rename `pull_hh_full_name_calc' hh_member_name
	local hh_47_g hh_47_g_`i'
	
	gen ind_var = 0
    replace ind_var = 1 if `hh_47_g' == .
	replace ind_var = 1 if `hh_47_g' < 0 & `hh_47_g' > 100000
 	replace ind_var = 0 if _household_roster_count < `i'

   
    	* keep and add variables to export *
	keep if ind_var == 1 
	
   
    generate issue = "Missing"
    generate issue_variable_name = "`hh_47_g'"
    rename `hh_47_g' print_issue
    tostring(print_issue), replace
    keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
    if _N > 0 {
        save "$household_roster\hh_roster_issue_`hh_47_g'", replace
    }
    restore
}


*** 6. hh_47_oth should be answered when hh_47_g_ is selected ***  PROBLEM SHOULD BE WHEN hh_47_g_ is greater than 0  CORRECTED
*Note: check max i value
* Checking hh_47_oth when hh_47_g > 0
forvalues i = 1/57 {
    preserve
	
    drop if consent == 0 
    drop if still_member_`i' == 0
    drop if still_member_`i' == 2
    keep if hh_age_`i' >= 4 & hh_age_`i' <= 18

    local hh_47_oth hh_47_oth_`i'
    local hh_47_g hh_47_g_`i'

    gen ind_var = 0
    keep if `hh_47_g' > 0  // Ensure hh_47_g is greater than 0 before proceeding
    replace ind_var = 1 if missing(`hh_47_oth')

    keep if ind_var == 1

    generate issue = "Missing"
    generate issue_variable_name = "`hh_47_oth'"
    rename `hh_47_oth' print_issue

    * Convert print_issue to string if it's not already
    capture confirm string variable print_issue
    if _rc != 0 {
        tostring print_issue, replace force
    }

    keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key

    if _N > 0 {
        save "$household_roster\Issue_`hh_47_oth'", replace
    }

    restore
}



*** 6. hh_48 should be answered, and check that it is 0, 1, or 2***   *** CHECKED
*Note: check max i value
forvalues i = 1/57 {
    preserve
	
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	keep if hh_age_`i' >= 4 & hh_age_`i' <= 18
    local hh_48 hh_48_`i'
    local hh_47_g hh_47_g_`i'

    gen ind_var = 0
    replace ind_var = 1 if missing(`hh_48')
	replace ind_var = 1  if `hh_48' != 0 & `hh_48' != 1  & `hh_48' != 2
	*replace ind_var = 0 if _household_roster_count < `i'
    keep if ind_var == 1

    generate issue = "Missing"
    generate issue_variable_name = "`hh_48'"
    rename `hh_48' print_issue
    tostring(print_issue), replace
    keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
    if _N > 0 {
        save "$household_roster\Issue_`hh_48'", replace
    }
    restore
}



 ** hh_50 – check that when hh_32 = 1, answer is 0, 1, or 2   *** CHECKED

*Note: check max i value
forvalues i = 1/57 {
    preserve
	
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	keep if hh_age_`i' >= 4 & hh_age_`i' <= 18
    local hh_32 hh_32_`i'

    gen ind_var = 0
    replace ind_var = 1 if `hh_32' ==1 & !inlist(hh_50_`i', 0, 1, 2 )
    keep if ind_var == 1

    generate issue = "Missing"
    generate issue_variable_name = "hh_50_`i'"
    rename hh_50_`i' print_issue
    tostring(print_issue), replace
    keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
    if _N > 0 {
        save "$household_roster\Issue_HH_Roster_hh_50_`i'", replace
    }
    restore
}

** hh_51  check that when hh_32 = 1, answer is 1, 2, 3, 4, 5  *** CHECKED

*Note: check max i value
forvalues i = 1/57 {
    preserve
	
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	keep if hh_age_`i' >= 4 & hh_age_`i' <= 18
    local hh_32 hh_32_`i'

    gen ind_var = 0
	replace ind_var = 1 if `hh_32' ==1 & !inlist(hh_51_`i', 1, 2, 3, 4, 5 )
    keep if ind_var == 1

    generate issue = "Missing"
    generate issue_variable_name = "hh_51_`i'"
    rename hh_51_`i' print_issue
    tostring(print_issue), replace
    keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
    if _N > 0 {
        save "$household_roster\Issue_HH_Roster_hh_51_`i'", replace
    }
    restore
}

** hh_52 -  check that when hh_32 = 1, there is a text entry *** CHECKED

*Note: check max i value
forvalues i = 1/57 {
    preserve
	
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	keep if hh_age_`i' >= 4 & hh_age_`i' <= 18
    local hh_52 hh_52_`i'
    local hh_32 hh_32_`i'

    gen ind_var = 0
	replace ind_var = 1 if `hh_32' ==1 & missing(`hh_52')
    keep if ind_var == 1

    generate issue = "Missing"
    generate issue_variable_name = "`hh_51'"
    rename `hh_52' print_issue
    tostring(print_issue), replace
    keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
    if _N > 0 {
        save "$household_roster\Issue_HH_Roster_`hh_52'", replace
    }
    restore
}

************************************ c.	knowledge section **************************************

***	i.	knowledge_02 should be answered when knowledge_01 = 1, should be text ***    CHECKED


preserve 

	gen ind_var = 0
    keep if knowledge_01 == 1 
	replace ind_var = 1 if missing(knowledge_02)
	keep if ind_var == 1 
	
	generate issue = "Missing"
	generate issue_variable_name = "knowledge_02"
	rename knowledge_02 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$knowledge\Issue_knowledge_02", replace
}
restore


*** ii.	knowledge_03 should be answered when knowledge_01 = 1 ***  CHECKED

preserve 

	gen ind_var = 0
	keep if knowledge_01 == 1
    replace ind_var = 1 if missing(knowledge_03)
	keep if ind_var == 1 
	
	generate issue = "Missing"
	generate issue_variable_name = "knowledge_03"
	rename knowledge_03 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$knowledge\Issue_knowledge_03", replace
}
restore



*** iii.knowledge_04 should be answered when knowledge_03 = 1 ***  CHECKED

preserve 

	gen ind_var = 0
	keep if knowledge_03 == 1
    replace ind_var = 1 if missing(knowledge_04)
	keep if ind_var == 1 
	
	generate issue = "Missing"
	generate issue_variable_name = "knowledge_04"
	rename knowledge_04 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$knowledge\Issue_knowledge_04", replace
}

restore


***	 iv. knowledge_05 should be answered when knowledge_04 = 1  CHECKED

preserve 

	gen ind_var = 0
	keep if knowledge_04 == 1 
	replace ind_var = 1 if missing(knowledge_05)
	keep if ind_var == 1 
	
	generate issue = "Missing"
	generate issue_variable_name = "knowledge_05"
	rename knowledge_05 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$knowledge\Issue_knowledge_05", replace
}

restore

***	v. knowledge_05_o should be answered when knowledge_05 = 99, should be text
*** I screwed up the instructions ***  CHECKED
preserve 

	gen ind_var = 0
    keep if knowledge_05 == 99 
	replace ind_var = 1 if missing(knowledge_05_o)
	keep if ind_var == 1 
	
	generate issue = "Missing"
	generate issue_variable_name = "knowledge_05_o"
	rename knowledge_05_o print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {	
		save "$knowledge\Issue_knowledge_05_o", replace
		}
	
restore


***	vi.	knowledge_08 should be answered when knowledge_07 = 1, should be text *** CHECKED

preserve 

	gen ind_var = 0
    keep if knowledge_07 == 1
	replace ind_var = 1 if missing(knowledge_08)
	keep if ind_var == 1 
	
	generate issue = "Missing"
	generate issue_variable_name = "knowledge_08"
	rename knowledge_08 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$knowledge\Issue_knowledge_08", replace
}

restore

***	i.	knowledge_10 must select at least one and no more than seven *** CHECKED
preserve

	*** drop no consent households *** 
	drop if consent == 0 

	egen knowledge_10_count = rowtotal(knowledge_10_1 knowledge_10_2 knowledge_10_3 knowledge_10_4 knowledge_10_5 knowledge_10_6 knowledge_10_7  knowledge_10_99)
	keep if knowledge_10_count < 0 & knowledge_10_count > 7
	
	gen issue = "Unreasonable value'"
	generate issue_variable_name = "knowledge_10"
	rename knowledge_10_count print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	
 if _N > 0 {
        save "$knowledge\Issue_knowledge_10_count_unreasonable.dta", replace
    }
restore

***	viii. knowledge_10_o should be answered when knowledge_10 = 99, should be text *** CHECKED

preserve 

	gen ind_var = 0
	tostring knowledge_10_o, replace 
    keep if knowledge_10 == "99" 
	replace ind_var = 1 if missing(knowledge_10_o)
	keep if ind_var == 1 

	generate issue = "Missing"
	generate issue_variable_name = "knowledge_10_o"
	rename knowledge_10_o print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$knowledge\Issue_knowledge_10_o", replace
}

restore

*** ix.	knowledge_12_o should be answered when knowledge_12 = 99, should be text *** CHECKED

preserve 

	gen ind_var = 0
    keep if knowledge_12 == 99 
	replace ind_var = 1 if missing(knowledge_12_o)
	keep if ind_var == 1 
	
	generate issue = "Missing"
	generate issue_variable_name = "knowledge_12_o"
	rename knowledge_12_o print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$knowledge\Issue_knowledge_12_o", replace
}

restore

*** x.	knowledge_16 should be answered when knowledge_15 = 1 *** CHECKED


preserve 

	gen ind_var = 0
    keep if knowledge_15 == 1 
	replace ind_var = 1 if missing(knowledge_16)
	keep if ind_var == 1 
	
	generate issue = "Missing"
	generate issue_variable_name = "knowledge_16"
	rename knowledge_16 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$knowledge\Issue_knowledge_16", replace
}

restore


*** xi.	knowledge_19 should be answered when knowledge_18 = 1 *** CHECKED

preserve 

	gen ind_var = 0
    keep if knowledge_18 == 1 
	replace ind_var = 1 if missing(knowledge_19)
	keep if ind_var == 1 
	
	generate issue = "Missing"
	generate issue_variable_name = "knowledge_19"
	rename knowledge_19 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$knowledge\Issue_knowledge_19", replace
}

restore

***	xii. knowledge_19_o should be answered when knowledge_19 = 99, should be text ***   CHECKED

preserve 

	gen ind_var = 0
	tostring knowledge_19_o, replace
    keep if knowledge_19 == 99 
	replace ind_var = 1 if missing(knowledge_19_o)
	keep if ind_var == 1 
	
	generate issue = "Missing"
	generate issue_variable_name = "knowledge_19_o"
	rename knowledge_19_o print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$knowledge\Issue_knowledge_19_o", replace
}

restore



***	xiii. knowledge_20 should be answered when knowledge_18 = 1 ***  CHECKED


preserve 

	gen ind_var = 0
    keep if knowledge_18 == 1
	replace ind_var = 1 if knowledge_20 == .
	keep if ind_var == 1 
	
	generate issue = "Missing"
	generate issue_variable_name = "knowledge_20"
	rename knowledge_20 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$knowledge\Issue_knowledge_20", replace
}

restore

***	xiv. knowledge_20_o should be answered when knowledge_20 = 99, should be text ***   CHECKED

preserve 

	gen ind_var = 0
    keep if knowledge_20 == 99 
	replace ind_var = 1 if missing(knowledge_20_o) 
	keep if ind_var == 1 
	
	generate issue = "Missing"
	generate issue_variable_name = "knowledge_20_o"
	rename knowledge_20_o print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$knowledge\Issue_knowledge_20_o", replace
}

restore


***	xv.	knowledge_21 should be answered when knowledge_18 = 1 ***    CHECKED

preserve 

	gen ind_var = 0
    keep if knowledge_18 == 1 
	replace ind_var = 1 if knowledge_21 == . 
	keep if ind_var == 1 
	
	generate issue = "Missing"
	generate issue_variable_name = "knowledge_21"
	rename knowledge_21 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$knowledge\Issue_knowledge_21", replace
}

restore


*** xvi. knowledge_22 should be answered when knowledge_18 = 1    CHECKED


preserve 

	gen ind_var = 0
    keep if knowledge_18 == 1
	replace ind_var = 1 if knowledge_22 == . 
	keep if ind_var == 1 
	
	generate issue = "Missing"
	generate issue_variable_name = "knowledge_22"
	rename knowledge_22 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$knowledge\Issue_knowledge_22", replace
}

restore


***	 xvii. knowledge_23 should be answered when knowledge_18 = 1 ***   CHECKED
 
**# Bookmark does this make sense 
*** This is a SurveyCTO quirk where we only need to check the first one ***     CHECKED


preserve
	gen ind_var = 0
    replace ind_var = 1 if knowledge_18 == 1 & knowledge_23 == "." 
	keep if ind_var == 1 
	
	
	generate issue = "Missing"
	generate issue_variable_name = "knowledge_23"
	rename knowledge_23 print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
 if _N > 0 {
        save "$knowledge\issue_household_knowledge_23.dta", replace
    }
	
restore

*** xviii. knowledge_23_o should be answered when knowledge_23 = 99, should be text ***   CHECKED

preserve

	gen ind_var = 0
    keep if knowledge_23 == "99" 
	replace ind_var = 1 if missing(knowledge_23_o) 
	keep if ind_var == 1 
	
	
	generate issue = "Missing"
	generate issue_variable_name = "knowledge_23_o"
	rename knowledge_23_o print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$knowledge\Issue_knowledge_23_o", replace
}

restore

******************************* d. health section *************************************

*** check for missing values in health_5_2 ***  CHECKED
*Note: check max i value
forvalues i = 1/57 {

    preserve 

	*** drop no consent households *** 
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 0
	drop if add_new_`i' == 2
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i'
	rename `pull_hh_full_name_calc' hh_member_name
	
	gen ind_var = 0
    replace ind_var = 1 if health_5_2_`i' == .  
 	replace ind_var = 0 if _household_roster_count < `i'

   
    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Missing value"
	generate issue_variable_name = "health_5_2_`i'"
	rename health_5_2_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$health\Issue_Household_health_5_2_`i'.dta", replace
    }
  
    restore
}

***	i. health_5_3 should be answered when health_5_2 = 1 ***
*** We only need to check that at least one is selected and not the individual indicators ***   CHECKED
*Note: check max i value
forvalues i = 1/57 {
preserve

	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 0
	drop if add_new_`i' == 2
	local health_5_2 health_5_2_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i'
	rename `pull_hh_full_name_calc' hh_member_name
		
	tostring(health_5_3_`i'), replace
	
	gen ind_var = 0
	replace ind_var = 1 if `health_5_2' == 1 & health_5_3_`i' == "."
	keep if ind_var == 1 
   
	generate issue = "Issue found: health_5_3_`i' value is missing"
	generate issue_variable_name = "health_5_3_`i'"
	rename health_5_3_`i' print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
 if _N > 0 {
        save "$health\issue_household_health_5_3_`i'.dta", replace
    }
	
restore

}

*** ii.	health_5_3_o should be answered when health_5_3 = 99, should be text ***          CHECKED
*** Can check if health_5_3_99 = 1 to check if health_5_3 = 99 
*Note: check max i value
forvalues i = 1/57 {
preserve

	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 0
	drop if add_new_`i' == 2
	local health_5_3 health_5_3_99_`i'
	local health_5_3_o health_5_3_o_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i'
	rename `pull_hh_full_name_calc' hh_member_name

	
	gen ind_var = 0
	tostring `health_5_3_o', replace
    keep if `health_5_3' == 1 
	replace ind_var = 1 if missing(`health_5_3_o') 
	keep if ind_var == 1 
	
	generate issue = "Missing"
	generate issue_variable_name = "health_5_3_o"
	rename `health_5_3_o' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$health\Issue_`health_5_3_o'", replace
}

restore

}


***	iii. health_5_4 should be answered when health_5_2 = 1 ***   CHECKED
*Note: check max i value
forvalues i = 1/57 {
preserve

	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 0
	drop if add_new_`i' == 2
	local health_5_4 health_5_4_`i'
	local health_5_2 health_5_2_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i'
	rename `pull_hh_full_name_calc' hh_member_name

	
	gen ind_var = 0
	
    keep if `health_5_2' == 1
	replace ind_var = 1 if `health_5_4' == .
	keep if ind_var == 1 
	
	generate issue = "Missing"
	generate issue_variable_name = "health_5_4"
	rename `health_5_4' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$health\Issue_`health_5_4'", replace
}

restore

}

*Rerun these 
*** check for missing values in health_5_5, health_5_6, health_5_7, health_5_8 ***  *** CHECKED
*Note: check max i value
forvalues i = 1/57 {

    preserve 

	*** drop no consent households *** 
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 0
	drop if add_new_`i' == 2
	
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i'
	rename `pull_hh_full_name_calc' hh_member_name

	
	gen ind_var = 0
    replace ind_var = 1 if health_5_5_`i' == .  
 	replace ind_var = 0 if _household_roster_count < `i'
	
    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Missing value"
	generate issue_variable_name = "health_5_5_`i'"
	rename health_5_5_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$health\Issue_Household_health_5_5_`i'.dta", replace
    }
  
    restore
}

*Note: check max i value   **** CHECKED
forvalues i = 1/57 {

    preserve 

	*** drop no consent households *** 
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 0
	drop if add_new_`i' ==  2 

	local pull_hh_full_name_calc pull_hh_full_name_calc__`i'
	rename `pull_hh_full_name_calc' hh_member_name

	
	gen ind_var = 0
    replace ind_var = 1 if health_5_6_`i' == .  
	replace ind_var = 1 if health_5_6_`i' != 0 & health_5_6_`i' != 1 & health_5_6_`i' != 2
 	replace ind_var = 0 if _household_roster_count < `i'
   
    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Missing value"
	generate issue_variable_name = "health_5_6_`i'"
	rename health_5_6_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$health\Issue_Household_health_5_6_`i'.dta", replace
    }
  
    restore
}

** KRM - added back in health_5_7_i  *** CHECKED
*Note: check max i value
forvalues i = 1/57 {

    preserve 

	*** drop no consent households *** 
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 0
	drop if add_new_`i' ==  2 

	local pull_hh_full_name_calc pull_hh_full_name_calc__`i'
	rename `pull_hh_full_name_calc' hh_member_name

	
	gen ind_var = 0
    replace ind_var = 1 if health_5_7_`i' == .  
	replace ind_var = 1 if health_5_7_`i' != 0 & health_5_7_`i' != 1 & health_5_7_`i' != 2
 	replace ind_var = 0 if _household_roster_count < `i'
   
    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Missing value"
	generate issue_variable_name = "health_5_7_`i'"
	rename health_5_7_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$health\Issue_Household_health_5_7_`i'.dta", replace
    }
  
    restore
}


*** Check for missing values in health_5_7_1, and check that it is 0, 1, or 2 *** ****CHECKED
*Note: check max i value
forvalues i = 1/57 {
    preserve 
    *** Drop households without consent ***
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 0
	drop if add_new_`i' == 2
	
	local health_5_7_1 health_5_7_1_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i'
	rename `pull_hh_full_name_calc' hh_member_name


    gen ind_var = 0
    replace ind_var = 1 if `health_5_7_1' == .  
	replace ind_var = 1  if `health_5_7_1' != 0 & `health_5_7_1' != 1  & `health_5_7_1' != 2
    replace ind_var = 0 if _household_roster_count < `i'

    * Keep and add variables to export *
    keep if ind_var == 1 
    generate issue = "Missing value"
    generate issue_variable_name = "`health_5_7_1'"
    rename `health_5_7_1' print_issue 
    tostring(print_issue), replace
    keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key

    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$health\Issue_health_`health_5_7_1'.dta", replace
    }
    restore
}

** health_5_8 check   CHECKED

*Note: check max i value
forvalues i = 1/57 {

    preserve 

	*** drop no consent households *** 
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 0
	drop if add_new_`i' == 2

	local pull_hh_full_name_calc pull_hh_full_name_calc__`i'
	rename `pull_hh_full_name_calc' hh_member_name

	
	gen ind_var = 0
    replace ind_var = 1 if health_5_8_`i' == .  
	replace ind_var = 1 if health_5_8_`i' != 0 & health_5_8_`i' != 1 & health_5_8_`i' != 2	
 	replace ind_var = 0 if _household_roster_count < `i'

   
    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Missing value"
	generate issue_variable_name = "health_5_8_`i'"
	rename health_5_8_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$health\Issue_Household_health_5_8_`i'.dta", replace
    }
  
    restore
}


*** Check for missing values in health_5_9 ***  CHECKED
*Note: check max i value
forvalues i = 1/57 {
    preserve 
    *** Drop households without consent ***
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 0
	drop if add_new_`i' == 2
	
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i'
	rename `pull_hh_full_name_calc' hh_member_name

	
    gen ind_var = 0
    replace ind_var = 1 if health_5_9_`i' == .  
	replace ind_var = 1 if health_5_9_`i' != 0 & health_5_9_`i' != 1 & health_5_9_`i' != 2
    replace ind_var = 0 if _household_roster_count < `i'


    * Keep and add variables to export *
    keep if ind_var == 1 
    generate issue = "Missing value"
    generate issue_variable_name = "health_5_9_`i'"
    rename health_5_9_`i' print_issue 
    tostring(print_issue), replace
    keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key

    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$health\Issue_Household_health_5_9_`i'.dta", replace
    }
    restore
}


*** KRM - added this check, Check for missing values/wrong values in health_5_10 ***  ***CHECKED
*Note: check max i value
forvalues i = 1/57 {
    preserve 
    *** Drop households without consent ***
	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	drop if add_new_`i' == 0
	drop if add_new_`i' == 2
	
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i'
	rename `pull_hh_full_name_calc' hh_member_name

	
    gen ind_var = 0
    replace ind_var = 1 if health_5_10_`i' == .  
	replace ind_var = 1 if health_5_10_`i' != 0 & health_5_10_`i' != 1 & health_5_10_`i' != 2
    replace ind_var = 0 if _household_roster_count < `i'


    * Keep and add variables to export *
    keep if ind_var == 1 
    generate issue = "Missing value"
    generate issue_variable_name = "health_5_10_`i'"
    rename health_5_10_`i' print_issue 
    tostring(print_issue), replace
    keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key

    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$health\Issue_Household_health_5_10_`i'.dta", replace
    }
    restore
}



***	iv.	health_5_11 should be answered when health_5_10 = 1 ***  ***CHECKED
*Note: check max i value
forvalues i = 1/57 {
preserve

	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	local health_5_11 health_5_11_`i'
	local health_5_10 health_5_10_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i'
	rename `pull_hh_full_name_calc' hh_member_name

	
	gen ind_var = 0
	
    keep if `health_5_10' == 1 
	replace ind_var = 1 if `health_5_11' == .
	
	keep if ind_var == 1 
	

	generate issue = "Missing"
	generate issue_variable_name = "health_5_11"
	rename `health_5_11' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$health\Issue_`health_5_11'", replace
}

restore

}


*** v. health_5_11_o should be answered when health_5_11 = 99, should be text ***  CHECKED

*Note: check max i value
forvalues i = 1/57 {
preserve

	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	local health_5_11 health_5_11_`i'
	local health_5_11_o health_5_11_o_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i'
	rename `pull_hh_full_name_calc' hh_member_name

	
	gen ind_var = 0
	
    keep if `health_5_11' == 99 
	replace ind_var = 1 if missing(`health_5_11_o')
	keep if ind_var == 1 
	
	generate issue = "Missing"
	generate issue_variable_name = "health_5_11_o"
	rename `health_5_11_o' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$health\Issue_`health_5_11_o'", replace
}

restore
}

**** vi. health_5_12 should be answered when health_5_10 = 1, should be between 0 and 150 ***
*Note: check max i value   *** ISSUES COMING FROM -9 and OVER 150
forvalues i = 1/57 {
preserve

	drop if consent == 0 
	drop if still_member_`i' == 0
	drop if still_member_`i' == 2
	local health_5_12 health_5_12_`i'
	local health_5_10 health_5_10_`i'
	local pull_hh_full_name_calc pull_hh_full_name_calc__`i'
	rename `pull_hh_full_name_calc' hh_member_name

	
	gen ind_var = 0
	
    keep if `health_5_10' == 1
	replace ind_var = 1 if `health_5_12' > 150 
	replace ind_var = 1 if `health_5_12' < 0 | `health_5_12' == .
	replace ind_var = 0 if key == "uuid:c52e24f8-ed96-47bd-8406-da314b553399" & `health_5_12' == 300
replace ind_var = 0 if key == "uuid:c52e24f8-ed96-47bd-8406-da314b553399" & `health_5_12' == 300
replace ind_var = 0 if key == "uuid:a63d364d-8238-4c51-a32c-a0b5c9ec3e6a" & `health_5_12' == -9
replace ind_var = 0 if key == "uuid:a63d364d-8238-4c51-a32c-a0b5c9ec3e6a" & `health_5_12' == -9
replace ind_var = 0 if key == "uuid:a63d364d-8238-4c51-a32c-a0b5c9ec3e6a" & `health_5_12' == -9
replace ind_var = 0 if key == "uuid:a63d364d-8238-4c51-a32c-a0b5c9ec3e6a" & `health_5_12' == -9
replace ind_var = 0 if key == "uuid:a63d364d-8238-4c51-a32c-a0b5c9ec3e6a" & `health_5_12' == -9
replace ind_var = 0 if key == "uuid:a63d364d-8238-4c51-a32c-a0b5c9ec3e6a" & `health_5_12' == -9
replace ind_var = 0 if key == "uuid:a63d364d-8238-4c51-a32c-a0b5c9ec3e6a" & `health_5_12' == -9
replace ind_var = 0 if key == "uuid:a63d364d-8238-4c51-a32c-a0b5c9ec3e6a" & `health_5_12' == -9
replace ind_var = 0 if key == "uuid:a63d364d-8238-4c51-a32c-a0b5c9ec3e6a" & `health_5_12' == -9
replace ind_var = 0 if key == "uuid:a63d364d-8238-4c51-a32c-a0b5c9ec3e6a" & `health_5_12' == -9
replace ind_var = 0 if key == "uuid:a63d364d-8238-4c51-a32c-a0b5c9ec3e6a" & `health_5_12' == -9
replace ind_var = 0 if key == "uuid:a63d364d-8238-4c51-a32c-a0b5c9ec3e6a" & `health_5_12' == -9
replace ind_var = 0 if key == "uuid:a63d364d-8238-4c51-a32c-a0b5c9ec3e6a" & `health_5_12' == -9
replace ind_var = 0 if key == "uuid:a63d364d-8238-4c51-a32c-a0b5c9ec3e6a" & `health_5_12' == -9
replace ind_var = 0 if key == "uuid:a63d364d-8238-4c51-a32c-a0b5c9ec3e6a" & `health_5_12' == -9
replace ind_var = 0 if key == "uuid:a63d364d-8238-4c51-a32c-a0b5c9ec3e6a" & `health_5_12' == -9
replace ind_var = 0 if key == "uuid:c061f456-3a81-4ff0-a269-fd05569d9747" & `health_5_12' == 500
replace ind_var = 0 if key == "uuid:c061f456-3a81-4ff0-a269-fd05569d9747" & `health_5_12' == 500
replace ind_var = 0 if key == "uuid:8294761e-3bcd-4a16-9dab-14913b5f9e2a" & `health_5_12' == 400
replace ind_var = 0 if key == "uuid:8294761e-3bcd-4a16-9dab-14913b5f9e2a" & `health_5_12' == 400
replace ind_var = 0 if key == "uuid:0ce7d392-22ca-4a4f-abd1-8bb9364ddaa4" & `health_5_12' == 200
replace ind_var = 0 if key == "uuid:0ce7d392-22ca-4a4f-abd1-8bb9364ddaa4" & `health_5_12' == 200
replace ind_var = 0 if key == "uuid:32489a2a-4606-4b8b-85ba-3345d9bb229f" & `health_5_12' == 250
replace ind_var = 0 if key == "uuid:32489a2a-4606-4b8b-85ba-3345d9bb229f" & `health_5_12' == 250
replace ind_var = 0 if key == "uuid:896ef294-6ea0-45d0-9468-3f1bdf54924e" & `health_5_12' == 200
replace ind_var = 0 if key == "uuid:896ef294-6ea0-45d0-9468-3f1bdf54924e" & `health_5_12' == 200
replace ind_var = 0 if key == "uuid:a0af735e-1a67-40ea-b4f4-c65fb5b58ed0" & `health_5_12' == 300
replace ind_var = 0 if key == "uuid:9cf0b8bc-d0cc-4396-9711-d75336bdabfd" & `health_5_12' == 250
replace ind_var = 0 if key == "uuid:63027ea6-4db1-4d75-9e50-07102ad7e66d" & `health_5_12' == 400
replace ind_var = 0 if key == "uuid:63027ea6-4db1-4d75-9e50-07102ad7e66d" & `health_5_12' == 200
replace ind_var = 0 if key == "uuid:a0af735e-1a67-40ea-b4f4-c65fb5b58ed0" & `health_5_12' == 300
replace ind_var = 0 if key == "uuid:63027ea6-4db1-4d75-9e50-07102ad7e66d" & `health_5_12' == 400
replace ind_var = 0 if key == "uuid:201c00d0-75bc-4b0a-8e70-feecab62c8e0" & `health_5_12' == 156
replace ind_var = 0 if key == "uuid:63027ea6-4db1-4d75-9e50-07102ad7e66d" & `health_5_12' == 200
replace ind_var = 0 if key == "uuid:dadd5583-da49-40ff-8eab-3f60938c143f" & `health_5_12' == 300
replace ind_var = 0 if key == "uuid:dadd5583-da49-40ff-8eab-3f60938c143f" & `health_5_12' == 300
replace ind_var = 0 if key == "uuid:a0748e74-08de-480e-a3ff-9a5f8555215b" & `health_5_12' == -9
	keep if ind_var == 1 
	
	generate issue = "Unreaonsable value"
	generate issue_variable_name = "health_5_12"
	rename `health_5_12' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue hh_member_name key
	if _N > 0 {
		save "$health\Issue_`health_5_12'", replace
}

restore

}

*** vii. health_5_14_a should be answered when health_5_13 = 1 ***CHECKED
forvalues i  = 1/57 {
preserve

	gen ind_var = 0
    keep if health_5_13 == 1
	replace ind_var = 1 if health_5_14_a == . 
	keep if ind_var == 1 
	
	
	generate issue = "Missing"
	generate issue_variable_name = "health_5_14_a"
	rename health_5_14_a print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$health\Issue_health_5_14_a", replace
}

restore
}

***	viii. health_5_14_b should be answered when health_5_13 = 1 ***  **** CHECKED
forvalues i = 1/57 {
preserve

	gen ind_var = 0
    keep if health_5_13 == 1 
	replace ind_var = 1 if health_5_14_b == . 
	keep if ind_var == 1 
	
	
	generate issue = "Missing"
	generate issue_variable_name = "health_5_14_b"
	rename health_5_14_b print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$health\Issue_health_5_14_b", replace
}

restore

}
***	ix.	health_5_14_c should be answered when health_5_13 = 1 ***  ***CHECKED
forvalues i = 1/57 {
preserve
	
	gen ind_var = 0
    keep if health_5_13 == 1 
	replace ind_var = 1 if health_5_14_c == . 
	keep if ind_var == 1 
	
	
	generate issue = "Missing"
	generate issue_variable_name = "health_5_14_c"
	rename health_5_14_c print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$health\Issue_health_5_14_c", replace
}

restore
}


********************* Agriculture Section Checks *********************

*** check if list_actifs is missing ***  **CHECKED

    preserve 

	*** drop no consent households *** 
	drop if consent == 0 
	
	gen ind_var = 0
    replace ind_var = 1 if list_actifs == "."  

    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Missing value"
	generate issue_variable_name = "list_actifs"
	rename list_actifs print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$agriculture_inputs\Issue_list_actifs.dta", replace
    }
  
    restore
	
*** check if list_agri_equip is missing ***  ***CHECKED

    preserve 

	*** drop no consent households *** 
	drop if consent == 0 
	
	gen ind_var = 0
    replace ind_var = 1 if list_agri_equip == "."  

    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Missing value"
	generate issue_variable_name = "list_agri_equip"
	rename list_agri_equip print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$agriculture_inputs\Issue_list_agri_equip.dta", replace
    }
  
    restore

*** check if agri_6_5 is missing ***  ***CHECKED

    preserve 

	*** drop no consent households *** 
	drop if consent == 0 
	
	gen ind_var = 0
    replace ind_var = 1 if agri_6_5 == .  

    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Missing value"
	generate issue_variable_name = "agri_6_5"
	rename agri_6_5 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$agriculture_inputs\Issue_agri_6_5.dta", replace
    }
  
    restore
	

*** i.	Actifs_o should be answered when list_actifs_o = 1, should be text  ***   ***CHECKED

preserve 

*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if list_actifs_o == 1 & actifs_o == "."

*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "actifs_o"
	rename actifs_o print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
	save "$agriculture_inputs\Issue_actifs_o_missing.dta", replace 
	}
	
restore

*** ii.	Actifs_o_int should be answered when list_actifs_o = 1, should be between 0 and 100  ***  ***CHECKED

preserve 

*** limit sample to when list_actifs_o = 1 ***
	keep if list_actifs_o == 1 

*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if actifs_o_int < 0 | actifs_o_int > 100

*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "actifs_o_int"
	rename actifs_o_int print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_actifs_o_int_unreasonable.dta", replace 
	}
	
restore

*** iii.	List_agri_equip_o_t should be answered when list_agri_equip_o = 1, should be text ***  ***CHECKED
 
preserve 

*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if list_agri_equip_o == 1 & list_agri_equip_o_t == "."

	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "list_agri_equip_o_t"
	rename list_agri_equip_o_t print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_list_agri_equip_o_t_missing.dta", replace 
	}
	
restore

*** iv.	List_agri_equip_o_int should be answered when list_agri_equip_o = 1, should be between 0 and 100  ***   **CHECKED

preserve 

*** limit sample to when list_agri_equip_o = 1 ***
	keep if list_agri_equip_o == 1 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if list_agri_equip_int < 0 | list_agri_equip_int > 100

	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "list_agri_equip_int"
	rename list_agri_equip_int print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_list_agri_equip_o_int_unreasonable.dta", replace 
	}
	
restore

*** v.	Agri_6_12 should be answered when agri_6_11 = 1  ***   *CHECKED

preserve 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_11 == 1 & agri_6_12 == "."

	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_6_12"
	rename agri_6_12 print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_12_missing.dta", replace 
	}
	
restore

*** vi.	Agri_6_12_o should be answered when agri_6_12 = 99, should be text ***   ***CHECKED

preserve 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_12_99 == 1 & agri_6_12_o == "."

	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_6_12_o"
	rename agri_6_12_o print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_12_o_missing.dta", replace 
	}
		
restore

*** agri_6_15 should be answered when agri_6_14 = 1, should be between 0 and 60 ***  **EXPORTS ONE ISSUE OF -9

preserve 

	*** limit sample to when agri_6_14 = 1 ***
	keep if agri_6_14 == 1 

	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_15 < 0 | agri_6_15 > 60

	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "agri_6_15"
	rename agri_6_15 print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_15_unreasonable.dta", replace 
	}
	
restore

*** agri_6_16 should be answered when agri_6_14 =  ***   ***CHECKED

* Note: Check max i value

forvalue i = 1/5 {
	
	preserve 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_14 == 1 & agri_6_16_`i' == . 
	replace ind_var = 0 if parcelleindex_`i' == . 
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_6_16_`i'"
	rename agri_6_16_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_16_`i'_missing.dta", replace 
	}
	
	restore
}


*** agri_6_17 should be answered when agri_6_14 = 1 ***   ***CHECKED
* Note: Check max i value


forvalue i = 1/5 {
	
	preserve 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_14 == 1 & agri_6_17_`i' == . 
	replace ind_var = 0 if parcelleindex_`i' == . 
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_6_17_`i'"
	rename agri_6_17_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_17_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_18 should be answered when agri_6_14 = 1 ***  CHECKED
* Note: Check max i value

forvalue i=1/5 {
	
	preserve 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_14 == 1 & agri_6_18_`i' == . 
	replace ind_var = 0 if parcelleindex_`i' == . 
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_6_18_`i'"
	rename agri_6_18_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_18_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_19 should be answered when agri_6_14 = 1 *** ***CHECKED
* Note: Check max i value

forvalue i=1/5 {
	
	preserve 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_14 == 1 & agri_6_19_`i' == . 
	replace ind_var = 0 if parcelleindex_`i' == . 
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_6_19_`i'"
	rename agri_6_19_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_19_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_20 should be answered when agri_6_14 = 1 *** **CHECKED
* Note: Check max i value

forvalue i=1/5 {
	
	preserve 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_14 == 1 & agri_6_20_`i' == . 
	replace ind_var = 0 if parcelleindex_`i' == . 
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_6_20_`i'"
	rename agri_6_20_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_20_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_20_o should be answered when agri_6_14 = 1, should be answered when agri_6_20 == 99, should be text ***   **CHECKED
* Note: Check max i value

forvalue i=1/5 {
	
	preserve 
	
	*** restrict sample to agri_6_14 = 1 and agri_6_20 = 99 ***
	keep if agri_6_14 == 1 & agri_6_20_`i' == 99
	
	*** make sure agri_6_20_o is a string variable ***
	tostring(agri_6_20_o_`i'), replace 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_20_o_`i' == "." 
	replace ind_var = 0 if parcelleindex_`i' == . 
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_6_20_o_`i'"
	rename agri_6_20_o_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_20_o_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_21 should be answered when agri_6_14 = 1, should be between 0 and 20000 ***  **CHECKED
*** FLAGGED ***
* Note: Check max i value
forvalue i=1/5 {
	
	preserve 
	
	*** restrict sample to agri_6_14 = 1 ***
	keep if agri_6_14 == 1

	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_21_`i' < 0 | agri_6_21_`i' > 20000 
	replace ind_var = 0 if parcelleindex_`i' == . 
	replace ind_var = 0 if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980" & agri_6_21_1 == -9  // confirmed value from check
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "agri_6_21_`i'"
	rename agri_6_21_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_21_`i'_unreasonable.dta", replace 
	}
	
	restore
}

*** agri_6_22 should be answered when agri_6_14 = 1 ***  ***CHECKED
* Note: Check max i value
forvalue i=1/5 {
	
	preserve 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_14 == 1 & agri_6_22_`i' == . 
	replace ind_var = 0 if parcelleindex_`i' == . 
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_6_22_`i'"
	rename agri_6_22_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_22_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_23 should be answered when agri_6_14 = 1 ***   **CHECKED
* Note: Check max i value
forvalue i=1/5 {
	
	preserve 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_14 == 1 & agri_6_23_`i' == . 
	replace ind_var = 0 if parcelleindex_`i' == . 
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_6_23_`i'"
	rename agri_6_23_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_23_`i'_missing.dta", replace 
	}
	
	restore
}


*** agri_6_23_o should be answered when agri_6_14 = 1, should be answered when agri_6_23 = 99, should be text ***
* Note: Check max i value   ***CHECKED
forvalue i=1/5 {
	
	preserve 
	
	*** restrict sample to agri_6_14 = 1 and agri_6_23 = 99 ***
	keep if agri_6_14 == 1 & agri_6_23_`i' == 99
	
	*** make sure agri_6_20_o is a string variable ***
	tostring(agri_6_23_o_`i'), replace 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_23_o_`i' == "." 
	replace ind_var = 0 if parcelleindex_`i' == . 
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_6_23_o_`i'"
	rename agri_6_23_o_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_23_o_`i'_missing.dta", replace 
	}
	
	restore
}


*** agri_6_24 should be answered when agri_6_14 = 1, should be answered when agri_6_23 = 1 **   CHECKED
* Note: Check max i value
forvalue i=1/5 {
	
	preserve 
	
	*** restrict sample to agri_6_14 = 1 and agri_6_23 = 1 ***
	keep if agri_6_14 == 1 & agri_6_23_`i' == 1
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_24_`i' == . 
	replace ind_var = 0 if parcelleindex_`i' == . 
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_6_24_`i'"
	rename agri_6_24_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_24_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_25 should be answered when agri_6_14 = 1, should be answered when agri_6_23 = 1 **  *CHECKED

forvalue i=1/5 {
* Note: Check max i value	
	preserve 
	
	*** restrict sample to agri_6_14 = 1 and agri_6_23 = 1 ***
	keep if agri_6_14 == 1 & agri_6_23_`i' == 1
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_25_`i' == . 
	replace ind_var = 0 if parcelleindex_`i' == . 
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_6_25_`i'"
	rename agri_6_25_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_25_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_25_o should be answered when agri_6_14 = 1, should be answered when agri_6_25 == 99, should be text *** **CHECKED
* Note: Check max i value
forvalue i=1/5 {
	
	preserve 
	
	*** restrict sample to agri_6_14 = 1 and agri_6_25 = 99 ***
	keep if agri_6_14 == 1 & agri_6_23_`i' == 1 & agri_6_25_`i' == 99
	
	*** make sure agri_6_25_o is a string variable ***
	tostring(agri_6_25_o_`i'), replace 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_25_o_`i' == "." 
	replace ind_var = 0 if parcelleindex_`i' == . 
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_6_25_o_`i'"
	rename agri_6_25_o_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_25_o_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_26 should be answered when agri_6_14 = 1, should be answered when agri_6_23 = 1 **  *CHECKED
* Note: Check max i value
forvalue i=1/5 {
	
	preserve 
	
	*** restrict sample to agri_6_14 = 1 and agri_6_23 = 1 ***
	keep if agri_6_14 == 1 & agri_6_23_`i' == 1
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_26_`i' == . 
	replace ind_var = 0 if parcelleindex_`i' == . 
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_6_26_`i'"
	rename agri_6_26_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_26_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_26_o should be answered when agri_6_14 = 1, should be answered when agri_6_26 == 99, should be text ***   *CHECKED
* Note: Check max i value
forvalue i=1/5 {
	
	preserve 
	
	*** restrict sample to agri_6_14 = 1 and agri_6_26 = 99 ***
	keep if agri_6_14 == 1 & agri_6_23_`i' == 1 & agri_6_26_`i' == 99
	
	*** make sure agri_6_26_o is a string variable ***
	tostring(agri_6_26_o_`i'), replace 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_26_o_`i' == "." 
	replace ind_var = 0 if parcelleindex_`i' == . 
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_6_26_o_`i'"
	rename agri_6_26_o_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_26_o_`i'_missing.dta", replace 
	}
	
	restore
}


*** agri_6_27 should be answered when agri_6_14 = 1, should be answered when agri_6_23 = 1 and agri_6_27 does not equal 6 ***  *CHECKED
* Note: Check max i value
forvalue i=1/5 {
	
	preserve 
	
	*** restrict sample to agri_6_14 = 1 and agri_6_23 = 1 and agri_6_26 != 6 ***
	keep if agri_6_14 == 1 & agri_6_23_`i' == 1 & agri_6_26_`i' != 6
		
	*** make sure agri_6_27 is a string variable ***
	tostring(agri_6_27_`i'), replace 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_27_`i' == "." 
	replace ind_var = 0 if parcelleindex_`i' == . 
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_6_27_`i'"
	rename agri_6_27_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_27_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_28 should be answered when agri_6_14 = 1, should be answered when agri_6_23 = 1 and agri_6_26 does not equal 6 ***   **ISSUES EXPORT  NO AGRI_6_14  still exports these issues though
* Note: Check max i value
forvalue i=1/5 {
	
	preserve 
	
	*** restrict sample to agri_6_14 = 1 and agri_6_23 = 1 and agri_6_26 != 6 ***
	keep if agri_6_23_`i' == 1 & agri_6_26_`i' != 6
		
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_28_`i' == . 
	replace ind_var = 0 if parcelleindex_`i' == . 
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_6_28_`i'"
	rename agri_6_28_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_28_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_29 should be answered when agri_6_14 = 1, should be answered when agri_6_23 = 1 and agri_6_28 = 1 ***  ** CHECKED
* Note: Check max i value
forvalue i=1/5 {
	
	preserve 
	
	*** restrict sample to agri_6_14 = 1 and agri_6_23 = 1 and agri_6_28 = 1 ***
	keep if agri_6_14 == 1 & agri_6_23_`i' == 1 & agri_6_28_`i' == 1
		
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_29_`i' == . 
	replace ind_var = 0 if parcelleindex_`i' == . 
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_6_29_`i'"
	rename agri_6_29_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_29_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_29_o should be answered when agri_6_29 = 99, should be text *** 
* Note: Check max i value  ** CHECKED
forvalue i=1/5 {
	
	preserve 
	
	*** restrict sample to agri_6_14 = 1 and agri_6_23 = 1 and agri_6_29 = 99 ***
	keep if agri_6_14 == 1 & agri_6_23_`i' == 1 & agri_6_29_`i' == 99
	
	*** make sure agri_6_29 is a string variable ***
	tostring(agri_6_29_o_`i'), replace 
		
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_29_o_`i' == "." 
	replace ind_var = 0 if parcelleindex_`i' == . 
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_6_29_o_`i'"
	rename agri_6_29_o_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_29_o_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_30 should be answered when agri_6_14 = 1 *** 
* Note: Check max i value  ** CHECKED
forvalue i=1/5 {
	
	preserve 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_14 == 1 & agri_6_30_`i' == . 
	replace ind_var = 0 if parcelleindex_`i' == . 
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_6_30_`i'"
	rename agri_6_30_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_30_`i'_missing.dta", replace 
	}
	
	restore
}


*** agri_6_31 should be answered when agri_6_14 = 1, should be answered when agri_6_30 = 1 ***  CHECKED
* Note: Check max i value
forvalue i=1/5 {
	
	preserve 
	
	*** restrict sample to agri_6_14 = 1 and agri_6_30 = 1 ***
	keep if agri_6_14 == 1 & agri_6_30_`i' == 1 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_30_`i' == . 
	replace ind_var = 0 if parcelleindex_`i' == . 
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_6_31_`i'"
	rename agri_6_31_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_31_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_31_o should be answered when agri_6_14 = 1, should be answered when agri_6_31 == 99, should be text *** 
* Note: Check max i value   ***CHECKED
forvalue i=1/5 {
	
	preserve 
	
	*** restrict sample to agri_6_14 = 1 and agri_6_30 = 1 ***
	keep if agri_6_14 == 1 & agri_6_30_`i' == 1 & agri_6_31_`i' == 99
	
	*** make sure agri_6_31_o is a string variable ***
	tostring(agri_6_31_o_`i'), replace 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_31_o_`i' == "." 
	replace ind_var = 0 if parcelleindex_`i' == . 
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_6_31_o_`i'"
	rename agri_6_31_o_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_31_o_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_32 should be answered when agri_6_14 = 1, should be answered when agri_6_31 = 3, should be between 0 and 1000*** 
* Note: Check max i value   ***CHECKED
forvalue i=1/5 {
	
	preserve 
	
	*** restrict sample to agri_6_14 = 1 and agri_6_30 = 3 ***
	keep if agri_6_14 == 1 & agri_6_30_`i' == 1 & agri_6_31_`i' == 3
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_32_`i' < 0 | agri_6_32_`i' > 1000 
	replace ind_var = 0 if parcelleindex_`i' == . 
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "agri_6_32_`i'"
	rename agri_6_32_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_32_`i'_unreasonable.dta", replace 
	}
	
	restore
}

*** agri_6_33 should be answered when agri_6_14 = 1, should be answered when agri_6_31 = 3 ***   **CHECKED

forvalue i=1/5 {
	
	preserve 
	
	*** restrict sample to agri_6_14 = 1 and agri_6_30 = 3 ***
	keep if agri_6_14 == 1 & agri_6_30_`i' == 1 & agri_6_31_`i' == 3
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_33_`i' == . 
	replace ind_var = 0 if parcelleindex_`i' == . 
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_6_33_`i'"
	rename agri_6_33_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_33_`i'_missing.dta", replace 
	}
	
	restore
}

*** 18.	Agri_6_33_o should be answered when agri_6_33 = 99, should be text ***   CHECKED

forvalue i=1/5 {
	
	preserve 
	
	*** restrict sample to agri_6_14 = 1 and agri_6_33 = 99 ***
	keep if agri_6_14 == 1 & agri_6_33_`i' == 99
	
	*** make sure string *** 
	tostring(agri_6_33_o_`i'), replace 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_33_o_`i' == "." 
	replace ind_var = 0 if parcelleindex_`i' == . 
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_6_33_o_`i'"
	rename agri_6_33_o_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_33_o_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_34_comp should be answered when agri_6_14 = 1 ***  CHECKED  **CHECKED

forvalue i=1/5 {
	
	preserve 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_14 == 1 & agri_6_34_comp_`i' == . 
	replace ind_var = 0 if parcelleindex_`i' == . 
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_6_34_comp_`i'"
	rename agri_6_34_comp_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_34_comp_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_34 should be answered when agri_6_14 = 1 ***  ***CHECKED

forvalue i=1/5 {
	
	preserve 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_14 == 1 & agri_6_34_`i' == . 
	replace ind_var = 0 if parcelleindex_`i' == . 
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_6_34_`i'"
	rename agri_6_34_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_34_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_35 should be answered when agri_6_14 = 1, should be answered when agri_6_34 = 1, should be between 0 and 50 ***  ***CHECKED

forvalue i=1/5 {
	
	preserve 
	
	*** restrict sample to agri_6_14 = 1 and agri_6_33 = 99 ***
	keep if agri_6_14 == 1 & agri_6_34_`i' == 1
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_35_`i' < 0 | agri_6_35_`i' > 50 
	replace ind_var = 0 if parcelleindex_`i' == . 
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "agri_6_35_`i'"
	rename agri_6_35_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_35_`i'_unreasonable.dta", replace 
	}
	
	restore
}

*** agri_6_36 should be answered when agri_6_14 = 1 ***  **CHECKED

forvalue i=1/5 {
	
	preserve 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_14 == 1 & agri_6_36_`i' == . 
	replace ind_var = 0 if parcelleindex_`i' == . 
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_6_36_`i'"
	rename agri_6_36_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_36_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_37 should be answered when agri_6_14 = 1, should be answered when agri_6_36 = 1, should be between 0 and 50 ***  **CHECKED

forvalue i=1/5 {
	
	preserve 
	
	*** restrict sample to agri_6_14 = 1 and agri_6_36 = 1 ***
	keep if agri_6_14 == 1 & agri_6_36_`i' == 1
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_37_`i' < 0 | agri_6_37_`i' > 50 
	replace ind_var = 0 if parcelleindex_`i' == . 
	replace ind_var = 0 if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980" & agri_6_37_1 == -9 // confirmed value from check
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "agri_6_37_`i'"
	rename agri_6_37_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_37_`i'_unreasonable.dta", replace 
	}
	
	restore
}

*** agri_6_38_a should be answered when agri_6_14 = 1, should be between 0 and 1000 ***
*** FLAGGED ***   ISSUES OUTPUT
forvalue i=1/5 {
	
	preserve 
	
	*** restrict sample to agri_6_14 = 1 ***
	keep if agri_6_14 == 1 & !missing(parcelleindex_`i') 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_38_a_`i' < 0 | agri_6_38_a_`i' > 1000 
	replace ind_var = 0 if parcelleindex_`i' == . 
	replace ind_var = 0 if key == "uuid:4a46ca8e-aa03-4e23-876c-ba33a5c5a74e" & agri_6_38_a_1 == 1500 // confirmed values from corrections
	replace ind_var = 0 if key == "uuid:046d9fb5-af36-42e6-b747-7ef88f2eb3c0" & agri_6_38_a_1 == 1500
	replace ind_var = 0 if key == "uuid:b1fae32c-057b-45c3-a10b-5fbdf289d4d6" & agri_6_38_a_1 == 1200
	replace ind_var = 0 if key == "uuid:b23e5229-ac34-49c5-bb00-dc31eb3bd45a" & agri_6_38_a_1 == 1500
	replace ind_var = 0 if key == "uuid:92171a8f-7a48-4292-a5ef-6850b6c04333" & agri_6_38_a_1 == 1200
	replace ind_var = 0 if key == "uuid:c2106e68-0cfa-4b76-a564-4ec7f7f0689a" & agri_6_38_a_1 == 4500
	replace ind_var = 0 if key == "uuid:7305a580-e706-4203-8d8c-79eaed40ffd9" & agri_6_38_a_1 == 1200
	replace ind_var = 0 if key == "uuid:112ead05-6a4c-4759-b69f-f3b875805f55" & agri_6_38_a_1 == 1400
	replace ind_var = 0 if key == "uuid:72fd4109-9013-42e4-9a0a-bca42653b320" & agri_6_38_a_1 == 1050
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "agri_6_38_a_`i'"
	rename agri_6_38_a_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_38_a_`i'_unreasonable.dta", replace 
	}
	
	restore
}

*** agri_6_38_a_code should be answered when agri_6_14 = 1 ***
*** FLAGGED ***  ***ISSUES OUTPUT
forvalue i=1/5 {
	
	preserve 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	keep if agri_6_14 == 1 & !missing(parcelleindex_`i') & agri_6_38_a_`i' > 0

	replace ind_var = 1 if agri_6_14 == 1 & agri_6_38_a_code_`i' == . 
	replace ind_var = 0 if parcelleindex_`i' == . 
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_6_38_a_code_`i'"
	rename agri_6_38_a_code_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_38_a_code_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_38_a_code_o should be answered when agri_6_14 = 1, should be answered when agri_6_38_a_code = 99, should be text ***  ISSUES OUTPUT

forvalue i=1/5 {
	
	preserve 
	
	*** restrict sample to agri_6_14 = 1 & agri_6_38_a_code = 99 ***
	keep if agri_6_38_a_code_`i' == 99 & !missing(parcelleindex_`i')
	
	*** make sure string *** 
	tostring(agri_6_38_a_code_o_`i'), replace 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_38_a_code_o_`i' == "."
	replace ind_var = 0 if parcelleindex_`i' == . 
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_6_38_a_code_o_`i'"
	rename agri_6_38_a_code_o_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_38_a_code_o_`i'_missing.dta", replace 
	}
	
	restore
}


*** agri_6_39_a should be answered when agri_6_14 = 1, should be between 0 and 1000 ***  ISSUES OUTPUT
*** FLAGGED ***
forvalue i=1/5 {
	
	preserve 
	
	*** restrict sample to agri_6_14 = 1 ***
	keep if agri_6_14 == 1 & !missing(parcelleindex_`i') 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_39_a_`i' < 0 | agri_6_39_a_`i' > 1000 
	replace ind_var = 0 if parcelleindex_`i' == . 
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "agri_6_39_a_`i'"
	rename agri_6_39_a_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_39_a_`i'_unreasonable.dta", replace 
	}
	
	restore
}

*** agri_6_39_a_code should be answered when agri_6_14 = 1 ***   ISSUES OUTPUT

forvalue i=1/5 {
	
	preserve 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	keep if agri_6_14 == 1 & !missing(parcelleindex_`i') & agri_6_39_a_`i' > 0

	replace ind_var = 1 if agri_6_14 == 1 & agri_6_39_a_code_`i' == . 
	replace ind_var = 0 if parcelleindex_`i' == . 
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_6_39_a_code_`i'"
	rename agri_6_39_a_code_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_39_a_code_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_39_a_code_o should be answered when agri_6_14 = 1, should be answered when agri_6_39_a_code = 99, should be text ***  CHECKED

forvalue i=1/5 {
	
	preserve 
	
	*** restrict sample to agri_6_14 = 1 & agri_6_38_a_code = 99 ***
	keep if agri_6_39_a_code_`i' == 99 & !missing(parcelleindex_`i')
	
	*** make sure string *** 
	tostring(agri_6_39_a_code_o_`i'), replace 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_39_a_code_o_`i' == "."
	replace ind_var = 0 if parcelleindex_`i' == . 
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_6_39_a_code_o_`i'"
	rename agri_6_39_a_code_o_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_39_a_code_o_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_40_a should be answered when agri_6_14 = 1, should be between 0 and 1000 ***   ***ISSUES OUTPUT  BECAUSE OF THE BOUNDS
*** FLAGGED ***
forvalue i=1/5 {
	
	preserve 
	
	*** restrict sample to agri_6_14 = 1 ***
	keep if agri_6_14 == 1 & !missing(parcelleindex_`i') 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_40_a_`i' < 0 | agri_6_40_a_`i' > 1000 
	replace ind_var = 0 if parcelleindex_`i' == .
	replace ind_var = 0 if key == "uuid:c2106e68-0cfa-4b76-a564-4ec7f7f0689a" & agri_6_40_a_1 == 2250 // confirmed value from corrections
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "agri_6_40_a_`i'"
	rename agri_6_40_a_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_40_a_`i'_unreasonable.dta", replace 
	}
	
	restore
}

*** agri_6_40_a_code should be answered when agri_6_14 = 1 ***
*** FLAGGED ***   **** ISSUES OUTPUT
forvalue i=1/5 {
	
	preserve 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	keep if agri_6_14 == 1 & !missing(parcelleindex_`i') & agri_6_40_a_`i' > 0

	replace ind_var = 1 if agri_6_14 == 1 & agri_6_40_a_code_`i' == . 
	replace ind_var = 0 if parcelleindex_`i' == . 
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_6_40_a_code_`i'"
	rename agri_6_40_a_code_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_40_a_code_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_40_a_code_o should be answered when agri_6_14 = 1, should be answered when agri_6_40_a_code = 99, should be text ***   ISSUES OUTPUT  FIXED

forvalue i=1/5 {
	
	preserve 
	
	*** restrict sample to agri_6_14 = 1 & agri_6_38_a_code = 99 ***
	keep if agri_6_40_a_code_`i' == 99 & !missing(parcelleindex_`i')
	
	*** make sure string *** 
	tostring(agri_6_40_a_code_o_`i'), replace 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_40_a_code_o_`i' == "."
	replace ind_var = 0 if parcelleindex_`i' == . 
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_6_40_a_code_o_`i'"
	rename agri_6_40_a_code_o_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_40_a_code_o_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_41_a should be answered when agri_6_14 = 1, should be between 0 and 1000 **   **ISSUES OUTPUT
*** FLAGGED ***
forvalue i=1/5 {
	
	preserve 
	
	*** restrict sample to agri_6_14 = 1 ***
	keep if agri_6_14 == 1 & !missing(parcelleindex_`i') 

	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_41_a_`i' < 0 | agri_6_41_a_`i' > 1000 
	replace ind_var = 0 if parcelleindex_`i' == . 
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "agri_6_41_a_`i'"
	rename agri_6_41_a_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_41_a_`i'_unreasonable.dta", replace 
	}
	
	restore
}

*** agri_6_41_a_code should be answered when agri_6_14 = 1 ***
*** FLAGGED ***   ***ISSUES OUTPUT
forvalue i=1/5 {
	
	preserve 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	keep if agri_6_14 == 1 & !missing(parcelleindex_`i') & agri_6_41_a_`i' > 0

	replace ind_var = 1 if agri_6_14 == 1 & agri_6_41_a_code_`i' == . 
	replace ind_var = 0 if missing(parcelleindex_`i')
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_6_41_a_code_`i'"
	rename agri_6_41_a_code_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_41_a_code_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_41_a_code_o should be answered when agri_6_14 = 1, should be answered when agri_6_41_a_code = 99, should be text ***   ISSUES OUTPUT FIXED

forvalue i=1/5 {
	
	preserve 
	
	*** restrict sample to agri_6_14 = 1 & agri_6_41_a_code = 99 ***
	keep if agri_6_41_a_code_`i' == 99 & !missing(parcelleindex_`i')

	
	*** make sure string *** 
	tostring(agri_6_41_a_code_o_`i'), replace 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_41_a_code_o_`i' == "."
	replace ind_var = 0 if parcelleindex_`i' == . 
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_6_41_a_code_o_`i'"
	rename agri_6_41_a_code_o_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_41_a_code_o_`i'_missing.dta", replace 
	}
	
	restore
}

********************* Agriculture Production Section Checks *****************

*** 1.	Cereals_01 should be answered when cereals_consumption = 1, should be between 0 and 30   ***

forvalue i = 1/6 {
	
	preserve 
	
	*** restrict sample to cereals_consumption = 1 ***
	keep if cereals_consumption_`i' == 1 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if cereals_01_`i' < 0 | cereals_01_`i' > 50
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "cereals_01_`i'"
	rename cereals_01_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_production\Issue_cereals_01_`i'_unreasonable.dta", replace 
	}
	
	restore 
}

*** 2.	cereals_02 should be answered when cereals_consumption = 1, should be between 0 and 10000 ***

forvalue i = 1/6 {
	
	preserve 
	
	*** restrict sample to cereals_consumption = 1 ***
	keep if cereals_consumption_`i' == 1 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if cereals_02_`i' < 0 | cereals_02_`i' > 10000
		replace ind_var = 0 if key == "uuid:a8ab108b-bfad-4d97-979e-781ec303068d" & cereals_02_1 == -9
replace ind_var = 0 if key == "uuid:92a20142-025d-44aa-91a4-1c1c4fc151a9" & cereals_02_1 == 10500
replace ind_var = 0 if key == "uuid:568408fd-6ada-4251-80f8-23d8b1258708" & cereals_02_1 == 18400
replace ind_var = 0 if key == "uuid:104f7dff-68f2-4bbd-a2d6-da22b7b72754" & cereals_02_1 == 12000
replace ind_var = 0 if key == "uuid:2bf20bdc-4cf8-407c-b399-cd9a35efd6ba" & cereals_02_1 == 24000
replace ind_var = 0 if key == "uuid:22c42af0-ec97-4fc3-80f5-94d3a684eff8" & cereals_02_1 == 25000
replace ind_var = 0 if key == "uuid:b99d9512-c46b-48a5-a08f-00db51351c27" & cereals_02_1 == 16000
replace ind_var = 0 if key == "uuid:338d1760-bfa2-46fd-9368-469f727d9cef" & cereals_02_1 == 11360
replace ind_var = 0 if key == "uuid:2d35da93-7a0e-4d12-b958-2ff8f42b52a9" & cereals_02_1 == 22400
replace ind_var = 0 if key == "uuid:5e72ce0f-a07d-4bcd-8618-d32576e05c8b" & cereals_02_1 == 15500
replace ind_var = 0 if key == "uuid:340107c5-0475-4534-987f-e832e89a582e" & cereals_02_1 == 19800
replace ind_var = 0 if key == "uuid:5a624ab5-23e1-4f2f-8e58-6d18eb28b4f2" & cereals_02_1 == 15000
replace ind_var = 0 if key == "uuid:5405184a-72e2-45d3-9d4b-7de603a79851" & cereals_02_1 == 14000
replace ind_var = 0 if key == "uuid:b4648e61-1839-42d1-9890-4069ccce8a97" & cereals_02_1 == 16000
replace ind_var = 0 if key == "uuid:ae346c76-805d-4845-af88-e70c606d8389" & cereals_02_1 == 15000
replace ind_var = 0 if key == "uuid:e1cd6dc2-003a-44ab-8c0f-3dc63c59ba14" & cereals_02_1 == 12000
replace ind_var = 0 if key == "uuid:ee63debf-822a-411e-a0f2-d08e9eade8c3" & cereals_02_1 == 15360
replace ind_var = 0 if key == "uuid:b1fae32c-057b-45c3-a10b-5fbdf289d4d6" & cereals_02_1 == 15200
replace ind_var = 0 if key == "uuid:96923c86-ad11-4def-97ce-64a3089a78a1" & cereals_02_1 == 14400
replace ind_var = 0 if key == "uuid:7bc76c9c-7953-4dc6-8f11-a7b27a31fb2e" & cereals_02_1 == 11520
replace ind_var = 0 if key == "uuid:92171a8f-7a48-4292-a5ef-6850b6c04333" & cereals_02_1 == 16000
replace ind_var = 0 if key == "uuid:c2106e68-0cfa-4b76-a564-4ec7f7f0689a" & cereals_02_1 == 24000
replace ind_var = 0 if key == "uuid:309e01e8-8554-4a50-95b3-b8a52e840905" & cereals_02_1 == 64000
replace ind_var = 0 if key == "uuid:983adac5-4009-47c2-8c3e-9976d4b0961b" & cereals_02_1 == 12000
replace ind_var = 0 if key == "uuid:9592ef45-c1b9-4b5b-a4d6-040ac97fdc5f" & cereals_02_1 == 13000
replace ind_var = 0 if key == "uuid:7305a580-e706-4203-8d8c-79eaed40ffd9" & cereals_02_1 == 16000
replace ind_var = 0 if key == "uuid:f4aa1eed-3ba6-43e0-84f4-3c3a2e7c1e14" & cereals_02_1 == 10960
replace ind_var = 0 if key == "uuid:112ead05-6a4c-4759-b69f-f3b875805f55" & cereals_02_1 == 23040
replace ind_var = 0 if key == "uuid:d56edb36-89c5-436c-93d2-f3e9f0f601a5" & cereals_02_1 == 36000
replace ind_var = 0 if key == "uuid:76975ab5-98e2-414f-a9b9-7c15a4ff50f6" & cereals_02_1 == 14240
replace ind_var = 0 if key == "uuid:bc6c1d3d-fa4b-4767-9ae5-c7422db73c6c" & cereals_02_1 == 16800
replace ind_var = 0 if key == "uuid:10cdabf2-f022-4539-8c2b-7eaa1bead1d1" & cereals_02_1 == 16000
replace ind_var = 0 if key == "uuid:e6efc18c-7a7b-4132-8535-6e7dff6a7ac7" & cereals_02_1 == -9
replace ind_var = 0 if key == "uuid:a9b198b5-e8e9-457d-9967-1ac777669d76" & cereals_02_1 == 56250
replace ind_var = 0 if key == "uuid:f2320249-e402-4c29-aea1-6c2dab838a8b" & cereals_02_1 == -9
replace ind_var = 0 if key == "uuid:33c5b9d4-3cf2-4d87-af16-2a2489b94563" & cereals_02_1 == 15750
replace ind_var = 0 if key == "uuid:999e3d4e-a660-48e8-bfa2-146829966c60" & cereals_02_1 == 12800
replace ind_var = 0 if key == "uuid:008de754-4ff1-43e5-ae4d-21d1760039e2" & cereals_02_1 == 23360
replace ind_var = 0 if key == "uuid:9e068357-e209-4055-a615-2ceeefc71a06" & cereals_02_1 == -9
replace ind_var = 0 if key == "uuid:5a4e7e21-f224-48e5-aece-7f9d297dae48" & cereals_02_1 == 40000
replace ind_var = 0 if key == "uuid:af2fa2b6-d183-4406-8d00-4be4c168e97b" & cereals_02_1 == -9
replace ind_var = 0 if key == "uuid:e60944ff-9e24-4e10-b4a2-8439cf1f4eb8" & cereals_02_1 == 11000
replace ind_var = 0 if key == "uuid:397fd602-9a30-4d8b-a9ba-7f46497e6648" & cereals_02_1 == 70000
replace ind_var = 0 if key == "uuid:46693568-4859-402d-ab33-9639f9622ca1" & cereals_02_1 == 31500
replace ind_var = 0 if key == "uuid:5268be61-f198-4614-8dbe-6f18904c78be" & cereals_02_1 == 28000
replace ind_var = 0 if key == "uuid:2b46e567-634a-45f4-abbd-e0174c03900d" & cereals_02_1 == 25000
replace ind_var = 0 if key == "uuid:beafc02c-dc0d-4a2f-896e-e06ddfbebdab" & cereals_02_1 == 17700
replace ind_var = 0 if key == "uuid:49e1ea67-b6bc-4685-822a-04e4963bbd19" & cereals_02_5 == -9
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "cereals_02_`i'"
	rename cereals_02_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_production\Issue_cereals_02_`i'_unreasonable.dta", replace 
	}
	
	restore 
}


*** 3.	cereals_03 should be answered when cereals_consumption = 1, should be less than cereals_02  ***

forvalue i = 1/6 {
	
	preserve 
	
	*** restrict sample to cereals_consumption = 1 ***
	keep if cereals_consumption_`i' == 1 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if cereals_03_`i' > cereals_02_`i' 
	replace ind_var = 0 if key == "uuid:f0d062cd-957e-4375-8a2f-41f4b30a0fb5" & cereals_03_1 == 1926
replace ind_var = 0 if key == "uuid:98f1dac6-2c36-4dc8-871e-f1789e107d6a" & cereals_03_1 == 750
replace ind_var = 0 if key == "uuid:a1261fd4-5c99-4e06-91c4-ac1072db7e5e" & cereals_03_1 == 500
replace ind_var = 0 if key == "uuid:cc130465-b8d1-42da-929f-318c258f73e4" & cereals_03_1 == 425
replace ind_var = 0 if key == "uuid:78d77a89-36f7-4c0f-8fef-22644a8e9c73" & cereals_03_1 == 5600
replace ind_var = 0 if key == "uuid:ba158d3a-b1da-4b04-96c1-271049e9b4cb" & cereals_03_1 == 700
replace ind_var = 0 if key == "uuid:6d59bac1-ae47-4d19-ae80-294dbf82865c" & cereals_03_1 == 2000
replace ind_var = 0 if key == "uuid:844ab214-bd8f-4cfd-b13e-38ce3bba59a8" & cereals_03_1 == 800
replace ind_var = 0 if key == "uuid:43aaed55-2d1c-45d6-913b-22726c7a9a26" & cereals_03_1 == 750
replace ind_var = 0 if key == "uuid:1aafe562-4cb0-4a1f-b7e5-bd58f3386e6e" & cereals_03_1 == 100
replace ind_var = 0 if key == "uuid:9c942a3d-fa44-4758-b268-c040b2ff1248" & cereals_03_1 == 3000
replace ind_var = 0 if key == "uuid:705814d9-cf74-46eb-a1fd-38a61fde156b" & cereals_03_1 == 3500
replace ind_var = 0 if key == "uuid:1ad4d263-f735-4d5b-898e-8449a23cbb09" & cereals_03_1 == 1000
replace ind_var = 0 if key == "uuid:d3a0cf7d-87a7-4373-8b0a-a4a50df9cfa2" & cereals_03_1 == 800
replace ind_var = 0 if key == "uuid:a2b50444-1316-4e2d-b47c-b3cbb7b7e46e" & cereals_03_1 == 420
replace ind_var = 0 if key == "uuid:f9ca4556-2c20-499a-b7fb-03eb3be07b5d" & cereals_03_1 == 500
replace ind_var = 0 if key == "uuid:41d0680a-3871-4f2a-92a6-52d45e652010" & cereals_03_1 == 1000
replace ind_var = 0 if key == "uuid:ea66090c-4853-434a-8501-93e90526a596" & cereals_03_5 == 1000
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "cereals_03_`i'"
	rename cereals_03_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_production\Issue_cereals_03_`i'_unreasonable.dta", replace 
	}
	
	restore 
}

*** 4.	cereals_04 should be answered when cereals_consumption = 1, should be less than cereals_02  ***

forvalue i = 1/6 {
	
	preserve 
	
	*** restrict sample to cereals_consumption = 1 ***
	keep if cereals_consumption_`i' == 1 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if cereals_04_`i' > cereals_02_`i' 
	replace ind_var = 0 if key == "uuid:78d77a89-36f7-4c0f-8fef-22644a8e9c73" & cereals_04_1 == 2800
replace ind_var = 0 if key == "uuid:43aaed55-2d1c-45d6-913b-22726c7a9a26" & cereals_04_1 == 75
replace ind_var = 0 if key == "uuid:9c942a3d-fa44-4758-b268-c040b2ff1248" & cereals_04_1 == 3000
replace ind_var = 0 if key == "uuid:705814d9-cf74-46eb-a1fd-38a61fde156b" & cereals_04_1 == 1000
replace ind_var = 0 if key == "uuid:d3a0cf7d-87a7-4373-8b0a-a4a50df9cfa2" & cereals_04_1 == 300
replace ind_var = 0 if key == "uuid:3b860b05-1279-4807-9ebb-cccdf410537f" & cereals_04_1 == 9500
replace ind_var = 0 if key == "uuid:ee6bb3fb-0c11-44c0-ab45-561b54edfcdc" & cereals_04_1 == 6000
replace ind_var = 0 if key == "uuid:9e068357-e209-4055-a615-2ceeefc71a06" & cereals_04_1 == 0
replace ind_var = 0 if key == "uuid:e9086ca8-03e3-49fb-b7ca-01c40f858435" & cereals_04_6 == 8000
replace ind_var = 0 if key == "uuid:43c5f3aa-5f3e-4087-98de-31d897566c82" & cereals_04_6 == 1400
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "cereals_04_`i'"
	rename cereals_04_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_production\Issue_cereals_04_`i'_unreasonable.dta", replace 
	}
	
	restore 
}

*** 5.	cereals_05 should be answered when cereals_consumption = 1, should be between 0 and 5000  *** 

forvalue i = 1/6 {
	
	preserve 
	
	*** restrict sample to cereals_consumption = 1 ***
	keep if cereals_consumption_`i' == 1 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if cereals_05_`i' < 0 | cereals_05_`i' > 5000
	replace ind_var = 0 if key == "uuid:1ad4d263-f735-4d5b-898e-8449a23cbb09" & cereals_05_1 == -9
replace ind_var = 0 if key == "uuid:e6efc18c-7a7b-4132-8535-6e7dff6a7ac7" & cereals_05_1 == -9
replace ind_var = 0 if key == "uuid:49e1ea67-b6bc-4685-822a-04e4963bbd19" & cereals_05_5 == -9
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "cereals_05_`i'"
	rename cereals_05_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_production\Issue_cereals_05_`i'_unreasonable.dta", replace 
	}
	
	restore 
}


*** 1.	Farines_01 should be answered when farine_tubercules_consumption = 1, should be between 0 and 50  *** 

forvalue i = 1/6 {
	
	preserve 
	
	*** restrict sample to farine_tubercules_consumption = 1 ***
	keep if farine_tubercules_consumption_`i' == 1 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if farines_01_`i' < 0 | farines_01_`i' > 50
	replace ind_var = 0 if key == "uuid:dc9a29e3-3292-4ed0-a27b-33446ca8640b" & farines_01_1 == -9
replace ind_var = 0 if key == "uuid:dc9a29e3-3292-4ed0-a27b-33446ca8640b" & farines_01_2 == -9
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "farines_01_`i'"
	rename farines_01_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_production\Issue_farines_01_`i'_unreasonable.dta", replace 
	}
	
	restore 
}

*** 2.	Farines_02 should be answered when farines_tubercules_consumption = 1, should be between 0 and 10000  *** 

forvalue i = 1/6 {
	
	preserve 
	
	*** restrict sample to farine_tubercules_consumption = 1 ***
	keep if farine_tubercules_consumption_`i' == 1 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if farines_02_`i' < 0 | farines_02_`i' > 10000
	replace ind_var = 0 if key == "uuid:3b860b05-1279-4807-9ebb-cccdf410537f" & farines_02_1 == 20000
replace ind_var = 0 if key == "uuid:b4648e61-1839-42d1-9890-4069ccce8a97" & farines_02_1 == 16000
replace ind_var = 0 if key == "uuid:0b333cd2-bec2-4b5d-81c5-15186feebd5d" & farines_02_1 == 16000
replace ind_var = 0 if key == "uuid:afbcea61-8389-4dcc-a18a-c3c3b5003b5e" & farines_02_1 == 24000
replace ind_var = 0 if key == "uuid:ea6616da-cd59-45c8-aaba-089a3f0510aa" & farines_02_1 == 12800
replace ind_var = 0 if key == "uuid:48f30fc0-4b45-4569-a86b-0f79df8b88b5" & farines_02_1 == 16000
replace ind_var = 0 if key == "uuid:961dde11-cb73-4697-899a-402fcdb81403" & farines_02_1 == 16000
replace ind_var = 0 if key == "uuid:73ed6f0b-339f-467c-98e2-270d4650a641" & farines_02_1 == -9
replace ind_var = 0 if key == "uuid:dc9a29e3-3292-4ed0-a27b-33446ca8640b" & farines_02_1 == -9
replace ind_var = 0 if key == "uuid:2a436357-13ff-4710-a749-b012d58d5685" & farines_02_1 == 60000
replace ind_var = 0 if key == "uuid:04f3040a-9991-412d-9fce-9ee840eafcea" & farines_02_1 == -9
replace ind_var = 0 if key == "uuid:6b2af6f0-abd9-40ce-8bb7-792c1e9e0e18" & farines_02_1 == -9
replace ind_var = 0 if key == "uuid:5af529e5-54e6-40aa-96d8-39fff3fe8f29" & farines_02_1 == 12000
replace ind_var = 0 if key == "uuid:02a39efd-23f1-4815-9b17-ff8b43173d90" & farines_02_1 == -9
replace ind_var = 0 if key == "uuid:32246f7b-b517-478d-b4f2-f8ab414ee1b2" & farines_02_1 == -9
replace ind_var = 0 if key == "uuid:33df7be4-7ed3-4333-b350-13d169e5f9e8" & farines_02_1 == -9
replace ind_var = 0 if key == "uuid:abd77c0d-982e-4867-b847-9531494e4578" & farines_02_1 == 10400
replace ind_var = 0 if key == "uuid:78498830-729b-4669-a8b0-ddb3ba898a73" & farines_02_1 == -9
replace ind_var = 0 if key == "uuid:fe254168-10ee-4b8e-bfe5-5e3d6e47d26e" & farines_02_1 == 84000
replace ind_var = 0 if key == "uuid:3edcedd7-4992-486e-a924-22eb67a877b3" & farines_02_1 == 30000
replace ind_var = 0 if key == "uuid:a1ac2ac5-36fc-4a12-ac9b-45b86f0dc84e" & farines_02_1 == -9
replace ind_var = 0 if key == "uuid:197be989-16e8-4ef0-b91f-a6cb3287c2d8" & farines_02_1 == 16000
replace ind_var = 0 if key == "uuid:0ce7d392-22ca-4a4f-abd1-8bb9364ddaa4" & farines_02_2 == -9
replace ind_var = 0 if key == "uuid:b23d6c34-7e39-4cb2-a08f-4e4731c59360" & farines_02_2 == 45290
replace ind_var = 0 if key == "uuid:c67f0cf6-6d27-4792-9c4b-7aa0e5d75360" & farines_02_2 == 16000
replace ind_var = 0 if key == "uuid:afbcea61-8389-4dcc-a18a-c3c3b5003b5e" & farines_02_2 == 24000
replace ind_var = 0 if key == "uuid:48f30fc0-4b45-4569-a86b-0f79df8b88b5" & farines_02_2 == 20000
replace ind_var = 0 if key == "uuid:dc9a29e3-3292-4ed0-a27b-33446ca8640b" & farines_02_2 == -9
replace ind_var = 0 if key == "uuid:2a436357-13ff-4710-a749-b012d58d5685" & farines_02_2 == 70000
replace ind_var = 0 if key == "uuid:53f60c19-7569-47c2-9423-ee4f516907c9" & farines_02_2 == -9
replace ind_var = 0 if key == "uuid:0af345d0-6960-4805-899a-3123a7c1a547" & farines_02_2 == -9
replace ind_var = 0 if key == "uuid:04f3040a-9991-412d-9fce-9ee840eafcea" & farines_02_2 == -9
replace ind_var = 0 if key == "uuid:6b2af6f0-abd9-40ce-8bb7-792c1e9e0e18" & farines_02_2 == 12000
replace ind_var = 0 if key == "uuid:5af529e5-54e6-40aa-96d8-39fff3fe8f29" & farines_02_2 == 14400
replace ind_var = 0 if key == "uuid:17b1c705-ed89-443b-8ddc-4ca93f033edd" & farines_02_2 == 18000
replace ind_var = 0 if key == "uuid:02a39efd-23f1-4815-9b17-ff8b43173d90" & farines_02_2 == -9
replace ind_var = 0 if key == "uuid:d0347b16-5aee-4340-b320-cdd8a2cc8196" & farines_02_2 == -9
replace ind_var = 0 if key == "uuid:78498830-729b-4669-a8b0-ddb3ba898a73" & farines_02_2 == -9
replace ind_var = 0 if key == "uuid:a1ac2ac5-36fc-4a12-ac9b-45b86f0dc84e" & farines_02_2 == -9
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "farines_02_`i'"
	rename farines_02_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_production\Issue_farines_02_`i'_unreasonable.dta", replace 
	}
	
	restore 
}

*** 3.	Farines_03 should be answered when farines_tubercules_consumption = 1, should be less than farines_02   ***

forvalue i = 1/6 {
	
	preserve 
	
	*** restrict sample to farine_tubercules_consumption = 1 ***
	keep if farine_tubercules_consumption_`i' == 1 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if farines_03_`i' > farines_02_`i' 
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "farines_03_`i'"
	rename farines_03_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_production\Issue_farines_03_`i'_unreasonable.dta", replace 
	}
	
	restore 
} 

*** 4.	Farines_04 should be answered when farines_tubercules_consumption = 1, should be less than farines_02  *** 

forvalue i = 1/6 {
	
	preserve 
	
	*** restrict sample to farine_tubercules_consumption = 1 ***
	keep if farine_tubercules_consumption_`i' == 1 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if farines_04_`i' > farines_02_`i' 
	replace ind_var = 0 if key == "uuid:d0347b16-5aee-4340-b320-cdd8a2cc8196" & farines_04_1 == 79760
replace ind_var = 0 if key == "uuid:5af529e5-54e6-40aa-96d8-39fff3fe8f29" & farines_04_2 == 14420
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "farines_04_`i'"
	rename farines_04_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_production\Issue_farines_04_`i'_unreasonable.dta", replace 
	}
	
	restore 
} 

*** 5.	Farines_05 should be answered when farines_tubercules_consumption = 1, should be between 0 and 5000  *** 

forvalue i = 1/6 {
	
	preserve 
	
	*** restrict sample to farine_tubercules_consumption = 1 ***
	keep if farine_tubercules_consumption_`i' == 1 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if farines_05_`i' < 0 | farines_05_`i' > 5000
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "farines_05_`i'"
	rename farines_05_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_production\Issue_farines_05_`i'_unreasonable.dta", replace 
	}
	
	restore 
}

*** 1.	Legumes_01 should be answered when legumes_consumption = 1, should be between 0 and 50  *** 

forvalue i = 1/6 {
	
	preserve 
	
	*** restrict sample to legumes_consumption = 1 ***
	keep if legumes_consumption_`i' == 1 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if legumes_01_`i' < 0 | legumes_01_`i' > 50
	replace ind_var = 0 if key == "uuid:dc9a29e3-3292-4ed0-a27b-33446ca8640b" & legumes_01_1 == -9   
replace ind_var = 0 if key == "uuid:a174f3ae-1533-4f24-9056-c76dc2c8ec40" & legumes_01_3 == -9
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "legumes_01_`i'"
	rename legumes_01_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_production\Issue_legumes_01_`i'_unreasonable.dta", replace 
	}
	
	restore 
}

*** 2.	legumes_02 should be answered when legumes_consumption = 1, should be between 0 and 10000  *** 

forvalue i = 1/6 {
	
	preserve 
	
	*** restrict sample to legumes_consumption = 1 ***
	keep if legumes_consumption_`i' == 1 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if legumes_02_`i' < 0 | legumes_02_`i' > 10000
	replace ind_var = 0 if key == "uuid:c842e94c-b701-4bbf-828b-d9af9842e9f4" & legumes_02_1 == -9
	replace ind_var = 0 if key == "uuid:f3fc7fa3-cc52-48a4-b153-e65733a5a392" & legumes_02_1 == -9
replace ind_var = 0 if key == "uuid:12b6f47f-aa90-4a91-95c0-ea66bcfb624d" & legumes_02_1 == -9
replace ind_var = 0 if key == "uuid:9774e27c-e111-4b39-ad7c-13f19c44e2b1" & legumes_02_1 == 12500
replace ind_var = 0 if key == "uuid:f22d73d4-c964-43e2-b0f8-0b7af4a740cc" & legumes_02_1 == 36000
replace ind_var = 0 if key == "uuid:5e72ce0f-a07d-4bcd-8618-d32576e05c8b" & legumes_02_1 == 16510
replace ind_var = 0 if key == "uuid:340107c5-0475-4534-987f-e832e89a582e" & legumes_02_1 == 23608
replace ind_var = 0 if key == "uuid:2dc17631-28de-444c-9bfc-c72efb9e0a75" & legumes_02_1 == 16200
replace ind_var = 0 if key == "uuid:ce7d41d9-bce1-4508-a02f-abf2b1b3185d" & legumes_02_1 == 25060
replace ind_var = 0 if key == "uuid:dc9a29e3-3292-4ed0-a27b-33446ca8640b" & legumes_02_1 == -9
replace ind_var = 0 if key == "uuid:88167bbe-853b-48b8-a3f9-6bbb02c12309" & legumes_02_1 == -9
replace ind_var = 0 if key == "uuid:396c8c59-7475-4da5-9fb2-c3531077ab31" & legumes_02_1 == -9
replace ind_var = 0 if key == "uuid:919061ac-5092-4d95-9642-a8f59bbdc4f9" & legumes_02_1 == -9
replace ind_var = 0 if key == "uuid:6fc043eb-a620-4e71-bd62-850b4b3b79cd" & legumes_02_1 == 22400
replace ind_var = 0 if key == "uuid:97dc0ddf-0488-42f5-93b3-1a9a7a87392d" & legumes_02_1 == 10500
replace ind_var = 0 if key == "uuid:d64a294e-43b9-44cd-aab0-d14bc88d71de" & legumes_02_1 == 875000
replace ind_var = 0 if key == "uuid:08f0ed54-98f9-4427-9b44-4e660b0b587d" & legumes_02_1 == 12000
replace ind_var = 0 if key == "uuid:397fd602-9a30-4d8b-a9ba-7f46497e6648" & legumes_02_1 == 16000
replace ind_var = 0 if key == "uuid:07374a46-8b35-4535-8e7f-aee405e62880" & legumes_02_2 == -9
replace ind_var = 0 if key == "uuid:c842e94c-b701-4bbf-828b-d9af9842e9f4" & legumes_02_3 == -9
replace ind_var = 0 if key == "uuid:eed2c8e6-e74f-4fe9-b790-665dbdd4c54d" & legumes_02_3 == -9
replace ind_var = 0 if key == "uuid:e5eb596e-392d-43e1-8ac5-19f7993e9401" & legumes_02_3 == -9
replace ind_var = 0 if key == "uuid:9774e27c-e111-4b39-ad7c-13f19c44e2b1" & legumes_02_3 == 17500
replace ind_var = 0 if key == "uuid:b4648e61-1839-42d1-9890-4069ccce8a97" & legumes_02_3 == 25000
replace ind_var = 0 if key == "uuid:a174f3ae-1533-4f24-9056-c76dc2c8ec40" & legumes_02_3 == -9
replace ind_var = 0 if key == "uuid:a7a54357-649f-4f1e-b7f1-ca2977436360" & legumes_02_3 == -9
replace ind_var = 0 if key == "uuid:4230989a-8a58-4ea0-a832-181386899bf5" & legumes_02_3 == -9
replace ind_var = 0 if key == "uuid:15a3df40-050c-48aa-b4bb-339077411dba" & legumes_02_3 == 20000
replace ind_var = 0 if key == "uuid:08f0ed54-98f9-4427-9b44-4e660b0b587d" & legumes_02_3 == 16000
replace ind_var = 0 if key == "uuid:397fd602-9a30-4d8b-a9ba-7f46497e6648" & legumes_02_3 == -9
replace ind_var = 0 if key == "uuid:abb87752-4a63-446c-9b08-114b67de3f6e" & legumes_02_4 == -9
replace ind_var = 0 if key == "uuid:90310a87-9d8f-4524-b415-99b443a9cd71" & legumes_02_6 == 18000
replace ind_var = 0 if key == "uuid:08f0ed54-98f9-4427-9b44-4e660b0b587d" & legumes_02_6 == 12000
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "legumes_02_`i'"
	rename legumes_02_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_production\Issue_legumes_02_`i'_unreasonable.dta", replace 
	}
	
	restore 
}

*** 3.	legumes_03 should be answered when legumes_consumption = 1, should be less than legumes_02   ***

forvalue i = 1/6 {
	
	preserve 
	
	*** restrict sample to legumes_consumption = 1 ***
	keep if legumes_consumption_`i' == 1 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if legumes_03_`i' > legumes_02_`i' 
	replace ind_var = 0 if key == "uuid:397fd602-9a30-4d8b-a9ba-7f46497e6648" & legumes_03_3 == 150
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "legumes_03_`i'"
	rename legumes_03_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_production\Issue_legumes_03_`i'_unreasonable.dta", replace 
	}
	
	restore 
} 

*** 4.	legumes_04 should be answered when legumes_consumption = 1, should be less than legumes_02  *** 

forvalue i = 1/6 {
	
	preserve 
	
	*** restrict sample to legumes_consumption = 1 ***
	keep if legumes_consumption_`i' == 1 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if legumes_04_`i' > legumes_02_`i' 
	replace ind_var = 0 if key == "uuid:a6aa6572-4ca2-4c8d-8be7-3027d7d09a1b" & legumes_04_6 == 250
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "legumes_04_`i'"
	rename legumes_04_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_production\Issue_legumes_04_`i'_unreasonable.dta", replace 
	}
	
	restore 
} 

*** 5.	legumes_05 should be answered when legumes_consumption = 1, should be between 0 and 5000  *** 

forvalue i = 1/6 {
	
	preserve 
	
	*** restrict sample to legumes_consumption = 1 ***
	keep if legumes_consumption_`i' == 1 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if legumes_05_`i' < 0 | legumes_05_`i' > 5000
	replace ind_var = 0 if key == "uuid:dc9a29e3-3292-4ed0-a27b-33446ca8640b" & legumes_05_1 == -9
replace ind_var = 0 if key == "uuid:a174f3ae-1533-4f24-9056-c76dc2c8ec40" & legumes_05_3 == -9
replace ind_var = 0 if key == "uuid:abb87752-4a63-446c-9b08-114b67de3f6e" & legumes_05_4 == -9
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "legumes_05_`i'"
	rename legumes_05_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_production\Issue_legumes_05_`i'_unreasonable.dta", replace 
	}
	
	restore 
}

*** 1.	Legumineuses_01 should be answered when legumineuses_consumption = 1, should be between 0 and 50  *** 

forvalue i = 1/5 {
	
	preserve 
	
	*** restrict sample to legumineuses_consumption = 1 ***
	keep if legumineuses_consumption_`i' == 1 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if legumineuses_01_`i' < 0 | legumineuses_01_`i' > 50
	replace ind_var = 0 if key == "uuid:8b114889-8bbb-45c2-94f2-eb752a16fe0e" & legumineuses_01_1 == -9
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "legumineuses_01_`i'"
	rename legumineuses_01_`i' print_issue 
	tostring print_issue, replace force
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_production\Issue_legumineuses_01_`i'_unreasonable.dta", replace 
	}
	
	restore 
}

*** 2.	legumineuses_02 should be answered when legumineuses_consumption = 1, should be between 0 and 10000  *** 

forvalue i = 1/5 {
	
	preserve 
	
	*** restrict sample to legumineuses_consumption = 1 ***
	keep if legumineuses_consumption_`i' == 1 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if legumineuses_02_`i' < 0 | legumineuses_02_`i' > 10000
	replace ind_var = 0 if key == "uuid:0b333cd2-bec2-4b5d-81c5-15186feebd5d" & legumineuses_02_1 == 16000
replace ind_var = 0 if key == "uuid:d5c7ff2b-5a98-48e6-ab1c-afdf20b145df" & legumineuses_02_1 == 16000
replace ind_var = 0 if key == "uuid:8b114889-8bbb-45c2-94f2-eb752a16fe0e" & legumineuses_02_1 == -9
replace ind_var = 0 if key == "uuid:88167bbe-853b-48b8-a3f9-6bbb02c12309" & legumineuses_02_1 == -9
replace ind_var = 0 if key == "uuid:0be6fc2e-5699-49b5-9b31-d924e7ad7581" & legumineuses_02_1 == -9
replace ind_var = 0 if key == "uuid:26971b58-f29b-4ca2-835b-f25a19f057c3" & legumineuses_02_1 == -9
replace ind_var = 0 if key == "uuid:32246f7b-b517-478d-b4f2-f8ab414ee1b2" & legumineuses_02_1 == -9
replace ind_var = 0 if key == "uuid:3edcedd7-4992-486e-a924-22eb67a877b3" & legumineuses_02_1 == 13500
replace ind_var = 0 if key == "uuid:8ca82313-2f21-45dd-9c4b-6cd68d8052a8" & legumineuses_02_5 == -9
replace ind_var = 0 if key == "uuid:a9b198b5-e8e9-457d-9967-1ac777669d76" & legumineuses_02_5 == -9
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "legumineuses_02_`i'"
	rename legumineuses_02_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_production\Issue_legumineuses_02_`i'_unreasonable.dta", replace 
	}
	
	restore 
}

*** 3.	legumineuses_03 should be answered when legumineuses_consumption = 1, should be less than legumineuses_02   ***

forvalue i = 1/5 {
	
	preserve 
	
	*** restrict sample to legumineuses_consumption = 1 ***
	keep if legumineuses_consumption_`i' == 1 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if legumineuses_03_`i' > legumineuses_02_`i' 
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "legumineuses_03_`i'"
	rename legumineuses_03_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_production\Issue_legumineuses_03_`i'_unreasonable.dta", replace 
	}
	
	restore 
} 

*** 4.	legumineuses_04 should be answered when legumineuses_consumption = 1, should be less than legumineuses_02  *** 

forvalue i = 1/5 {
	
	preserve 
	
	*** restrict sample to legumineuses_consumption = 1 ***
	keep if legumineuses_consumption_`i' == 1 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if legumineuses_04_`i' > legumineuses_02_`i' 
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "legumineuses_04_`i'"
	rename legumineuses_04_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_production\Issue_legumineuses_04_`i'_unreasonable.dta", replace 
	}
	
	restore 
} 

*** 5.	legumineuses_05 should be answered when legumineuses_consumption = 1, should be between 0 and 5000  *** 

forvalue i = 1/5 {
	
	preserve 
	
	*** restrict sample to legumineuses_consumption = 1 ***
	keep if legumes_consumption_`i' == 1 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if legumineuses_05_`i' < 0 | legumineuses_05_`i' > 5000
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "legumineuses_05_`i'"
	rename legumineuses_05_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_production\Issue_legumineuses_05_`i'_unreasonable.dta", replace 
	}
	
	restore 
}

*** v.	Aquatique_01 should be answered when aquatique_consumption = 1, should be between 0 and 50  *** 

preserve 
	
	*** restrict sample to aquatique_consumption = 1 ***
	keep if aquatique_consumption == 1 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if aquatique_01 < 0 | aquatique_01 > 50
	replace ind_var = 0 if key == "uuid:a0de5050-073d-47e2-934a-cf2cc8d2c532" & aquatique_01 == -9
replace ind_var = 0 if key == "uuid:dedd712c-634c-4665-a874-f139341ecd5f" & aquatique_01 == -9
replace ind_var = 0 if key == "uuid:f0bebe93-a4f0-40a0-8936-233682b356d1" & aquatique_01 == -9
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "aquatique_01"
	rename aquatique_01 print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_production\Issue_aquatique_01_unreasonable.dta", replace 
	}
	
restore 

*** vi.	Aquatique_02 should be answered when aquatique_consumption = 1, should be between 0 and 10000 ***

preserve 
	
	*** restrict sample to aquatique_consumption = 1 ***
	keep if aquatique_consumption == 1 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if aquatique_02 < 0 | aquatique_02 > 10000
	replace ind_var = 0 if key == "uuid:a0de5050-073d-47e2-934a-cf2cc8d2c532" & aquatique_02 == -9
replace ind_var = 0 if key == "uuid:dedd712c-634c-4665-a874-f139341ecd5f" & aquatique_02 == -9
replace ind_var = 0 if key == "uuid:f0bebe93-a4f0-40a0-8936-233682b356d1" & aquatique_02 == -9
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "aquatique_02"
	rename aquatique_02 print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_production\Issue_aquatique_02_unreasonable.dta", replace 
	}
	
restore

*** vii.	Aquatique_03 should be answered when aquatique_consumption = 1, should be less than aquatique_02   ***

preserve 
	
	*** restrict sample to aquatique_consumption = 1 ***
	keep if aquatique_consumption == 1 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if aquatique_03 > aquatique_02 
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "aquatique_03"
	rename aquatique_03 print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_production\Issue_aquatique_03_unreasonable.dta", replace 
	}
	
restore

*** viii.	Aquatique_04 should be answered when aquatique_consumption = 1, should be less than aquatique_02  *** 

preserve 
	
	*** restrict sample to aquatique_consumption = 1 ***
	keep if aquatique_consumption == 1 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if aquatique_04 > aquatique_02 
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "aquatique_04"
	rename aquatique_04 print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_production\Issue_aquatique_04_unreasonable.dta", replace 
	}
	
restore

*** ix.	Aquatique_05 should be answered when aquatique_consumption = 1, should be between 0 and 5000  ***

preserve 
	
	*** restrict sample to aquatique_consumption = 1 ***
	keep if aquatique_consumption == 1 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if aquatique_05 < 0 | aquatique_05 > 5000
	replace ind_var = 0 if key == "uuid:a0de5050-073d-47e2-934a-cf2cc8d2c532" & aquatique_05 == -9 
replace ind_var = 0 if key == "uuid:f0bebe93-a4f0-40a0-8936-233682b356d1" & aquatique_05 == -9
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "aquatique_05"
	rename aquatique_05 print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_production\Issue_aquatique_05_unreasonable.dta", replace 
	}
	
restore

*** x.	Autre_culture should be answered when autre_culture_yesno = 1, should be text  *** 

preserve 

*** generate indicator variable ***
gen ind_var = 0 
replace ind_var = 1 if autre_culture_yesno == 1 & autre_culture == "."

*** keep and add variables to export ***
keep if ind_var == 1 
generate issue = "Missing"
generate issue_variable_name = "autre_culture" 
rename autre_culture print_issue
tostring(print_issue), replace 
keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
if _N > 0 {
	save "$food_consumption\Issue_autre_culture_missing.dta", replace 
}

restore

*** xi.	O_culture_01 should be answered when autre_culture_yesno = 1, should be between 0 and 50  *** 

preserve 
	
	*** restrict sample to autre_culture_yesno = 1 ***
	keep if autre_culture_yesno == 1 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if o_culture_01 < 0 | o_culture_01 > 50
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "o_culture_01"
	rename o_culture_01 print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_production\Issue_o_culture_01_unreasonable.dta", replace 
	}
	
restore 

*** xii.	O_culture_02 should be answered when autre_culture_yesno = 1, should be between 0 and 10000  ***

preserve 
	
	*** restrict sample to autre_culture_yesno = 1 ***
	keep if autre_culture_yesno == 1 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if o_culture_02 < 0 | o_culture_02 > 10000
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "o_culture_02"
	rename o_culture_02 print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_production\Issue_o_culture_02_unreasonable.dta", replace 
	}
	
restore 

*** xiii.	O_culture_03 should be answered when autre_culture_yesno = 1, should be less that o_culture_02   ***

preserve 
	
	*** restrict sample to autre_culture_yesno = 1 ***
	keep if autre_culture_yesno == 1 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if o_culture_03 > o_culture_02 
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "o_culture_03"
	rename o_culture_03 print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_production\Issue_o_culture_03_unreasonable.dta", replace 
	}
	
restore 

*** xiv.	O_culture_04 should be answered when autre_culture_yesno = 1, should be less than o_culture_02  *** 

preserve 
	
	*** restrict sample to autre_culture_yesno = 1 ***
	keep if autre_culture_yesno == 1 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if o_culture_04 > o_culture_02 
	replace ind_var = 0 if key == "uuid:20bb7007-297f-432d-8909-7bea1973059d" & o_culture_04 == 400
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "o_culture_04"
	rename o_culture_04 print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_production\Issue_o_culture_04_unreasonable.dta", replace 
	}
	
restore 

*** xv.	O_culture_05 should be answered when autre_culture_yesno = 1, should be between 0 and 5000 *** 

preserve 
	
	*** restrict sample to autre_culture_yesno = 1 ***
	keep if autre_culture_yesno == 1 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if o_culture_05 < 0 | o_culture_05 > 5000
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "o_culture_05"
	rename o_culture_05 print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$agriculture_production\Issue_o_culture_05_unreasonable.dta", replace 
	}
	
restore 


******************** Food Consumption Checks *************************

*** i.	Food02 should be answered when food01 is greater than 0 ***

preserve 

*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if food01 > 0 & food01 != . & food02 == . 

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "food02" 
	rename food02 print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$food_consumption\Issue_food02_missing.dta", replace 
	}

restore 

*** ii.	Food03 should be answered when food01 is greater than 0  ***

preserve 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if food01 > 0 & food01 != . & food03 == . 

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "food03" 
	rename food03 print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$food_consumption\Issue_food03_missing.dta", replace 
	}

restore 

*** iii.	Food05 should be answered when food03 = 1 ***

preserve 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if food03 == 1 & food05 == . 

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "food05" 
	rename food05 print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$food_consumption\Issue_food05_missing.dta", replace 
	}

restore 

*** iv.	Food06 should be answered when food03 = 1 ***

preserve 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if food03 == 1 & food06 == . 

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "food06" 
	rename food06 print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$food_consumption\Issue_food06_missing.dta", replace 
	}

restore

*** v.	Food07 should be answered when food03 = 1 ***

preserve 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if food03 == 1 & food07 == . 

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "food07" 
	rename food07 print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$food_consumption\Issue_food07_missing.dta", replace 
	}

restore

*** vi.	Food08 should be answered when food03 = 1 ***

preserve 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if food03 == 1 & food08 == . 

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "food08" 
	rename food08 print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$food_consumption\Issue_food08_missing.dta", replace 
	}

restore

*** vii.	Food09 should be answered when food03 = 1 ***

preserve 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if food03 == 1 & food09 == . 

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "food09" 
	rename food09 print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$food_consumption\Issue_food09_missing.dta", replace 
	}

restore

*** viii.	Food11 should be answered when food01 is greater than 0  ***

preserve 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if food01 > 0 & food01 != . & food11 == . 

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "food11" 
	rename food11 print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$food_consumption\Issue_food11_missing.dta", replace 
	}

restore 

*** ix.	Food12 should be answered when food01 is greater than 0  ***

preserve 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if food01 > 0 & food01 != . & food12 == . 

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "food12" 
	rename food12 print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$food_consumption\Issue_food12_missing.dta", replace 
	}

restore 

******************** Income Checks ***********************************

*** agri_income_01 check for missing values ***

preserve 

	*** drop if no consent ***
	drop if consent == 0 

	*** generate indicator variable ***
	gen ind_var = 0
	replace ind_var = 1 if agri_income_01 == . 

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_income_01" 
	rename agri_income_01 print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_01_missing.dta", replace 
	}

restore 

*** species check for missing values ***

preserve 

	*** drop if no consent ***
	drop if consent == 0 

	*** generate indicator variable ***
	gen ind_var = 0
	replace ind_var = 1 if species == "." 

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "species" 
	rename species print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_species_missing.dta", replace 
	}

restore 

*** agri_income_15 check for missing values ***

preserve 

	*** drop if no consent ***
	drop if consent == 0 

	*** generate indicator variable ***
	gen ind_var = 0
	replace ind_var = 1 if agri_income_15 == . 

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_income_15" 
	rename agri_income_15 print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_15_missing.dta", replace 
	}

restore 

*** DROPPED VAR ***
*** agri_income_17 check for missing values ***

// preserve 
//
// 	*** limit to when agri_income_15 = 1 ***
// 	keep if agri_income_15 == 1 
//
// 	*** generate indicator variable ***
// 	gen ind_var = 0
// 	replace ind_var = 1 if agri_income_17 == . 
//
// 	*** keep and add variables to export ***
// 	keep if ind_var == 1 
// 	generate issue = "Missing"
// 	generate issue_variable_name = "agri_income_17" 
// 	rename agri_income_17 print_issue
// 	tostring(print_issue), replace 
// 	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue
// 	if _N > 0 {
// 		save "$income\Issue_agri_income_17_missing.dta", replace 
// 	}
//
// restore 

*** i. agri_income_02 should be answered when agri_income_01 = 1 ***

preserve 

	*** generate indicator variable ***
	gen ind_var = 0
	replace ind_var = 1 if agri_income_01 == 1 & agri_income_02 == . 

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_income_02" 
	rename agri_income_02 print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_02_missing.dta", replace 
	}

restore 

*** ii. agri_income_02_o should be answered when agri_income_02 = 3 ***

preserve 

	*** generate indicator variable ***
	gen ind_var = 0
	replace ind_var = 1 if agri_income_02 == 3 & agri_income_02_o == "." 

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_income_02_o" 
	rename agri_income_02_o print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_02_missing.dta", replace 
	}

restore 


*** iii. agri_income_03 should be answered when agri_income_01 = 1 ***
*** should be between 0 and 365 ***

preserve 

	*** generate indicator variable ***
	gen ind_var = 0
	replace ind_var = 1 if agri_income_01 == 1 & agri_income_03 < 0
	replace ind_var = 1 if agri_income_01 == 1 & agri_income_03 > 365 
	replace ind_var = 0 if key == "uuid:4478880a-f8ca-4a4c-9eb3-67465800791b" & agri_income_03 == -9 // confirmed values from corrections
	replace ind_var = 0 if key == "uuid:c2d6bc2b-f7cb-42d7-a0ef-b6c79d316202" & agri_income_03 == -9
	replace ind_var = 0 if key == "uuid:f8968dc5-d7d2-48ef-b238-31677e5060f8" & agri_income_03 == -9

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "agri_income_03" 
	rename agri_income_03 print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_03_unreasonable.dta", replace 
	}

restore 

*** iv. agri_income_04 should be answered when agri_income_01 = 1 ***

preserve 

	*** generate indicator variable ***
	gen ind_var = 0
	replace ind_var = 1 if agri_income_01 == 1 & agri_income_04 == .

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "agri_income_04" 
	rename agri_income_04 print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_04_missing.dta", replace 
	}

restore 

*** v. agri_income_05 should be answered when agri_income_01 = 1 ***
*** should be between 0 and 10000000 ***

preserve 

	*** generate indicator variable ***
	gen ind_var = 0
	replace ind_var = 1 if agri_income_01 == 1 & agri_income_05 < 0
	replace ind_var = 1 if agri_income_01 == 1 & agri_income_05 > 10000000 
	replace ind_var = 0 if key == "uuid:cda122cf-9280-432d-a1a8-8b7d8c4948f9" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:6942e4de-2992-42cc-b611-72abe5834a35" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:36cc7c65-9580-4182-92d9-ddda36fbb0ea" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:0d7abf18-244e-4440-b557-8ac4589ddf38" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:7b999785-4d17-4867-8512-d3bf09c28590" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:ec674bbd-07e3-4ad3-bb4e-915aed528559" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:d99a8dd2-9a86-4b52-bda5-100b7ac0015d" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:c4551c9e-c0c0-4f4a-b080-e07648e53697" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:e30ea4ae-696d-4a95-b119-ffa43fde532f" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:824199a9-08c8-4346-b9fc-9a67d4068e26" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:e25110ba-6df8-467a-b38e-577b9986dd00" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:97c0bd0c-6d8c-4571-bc15-d2d169449e82" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:24b6fa8e-852f-4176-a864-8d93e07675f2" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:5dbb5ff1-8bb0-42a8-97b9-908ced71a624" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:10ce019a-2990-430a-a81b-7c308a4c7bad" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:b66b0159-426b-41be-af40-5d9f2ef3c0e4" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:8895114d-827e-44d2-93c6-949d4c3c0ebe" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:9147cf5c-0509-4118-994c-462c61bcc4fe" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:d119d84e-18ad-43a8-aaaf-8b807d8af117" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:2a38b805-c7ae-4da3-8ff0-e6647ebd3139" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:ae79a16b-e91d-43dd-bf07-f5d8243dbc65" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:62f6265a-d35b-4b63-a24e-e159377cb165" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:458de09c-ccc6-4759-b192-8dc7c6112bc4" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:4478880a-f8ca-4a4c-9eb3-67465800791b" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:2a436357-13ff-4710-a749-b012d58d5685" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:53f60c19-7569-47c2-9423-ee4f516907c9" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:0af345d0-6960-4805-899a-3123a7c1a547" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:e707c317-45bd-4729-9216-380a140db29d" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:a7a54357-649f-4f1e-b7f1-ca2977436360" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:723843da-05ed-40ec-a63f-3a0374e444c9" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:ca25ba07-535e-4cc2-a8c7-2fa5072d9318" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:c2d6bc2b-f7cb-42d7-a0ef-b6c79d316202" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:f2320249-e402-4c29-aea1-6c2dab838a8b" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:b4135843-09e3-44e8-b649-7f6dbd35f542" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:0be6fc2e-5699-49b5-9b31-d924e7ad7581" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:17b1c705-ed89-443b-8ddc-4ca93f033edd" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:32246f7b-b517-478d-b4f2-f8ab414ee1b2" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:abd77c0d-982e-4867-b847-9531494e4578" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:7d5ce99f-c798-473b-b2f0-e87458bb972f" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:3edcedd7-4992-486e-a924-22eb67a877b3" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:f5ebb1fa-32f5-47fd-8d6b-ffdaa02d551e" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:64a4197f-9a39-4143-8f47-e2fa2e45b5f6" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:bb216791-2b51-4b42-9f67-8616f652ec33" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:f1a3ca58-71ee-4f17-9a08-8b2b64343adb" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:f0bebe93-a4f0-40a0-8936-233682b356d1" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:a398b76a-7378-444c-8717-36fb8d3d46df" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:f8968dc5-d7d2-48ef-b238-31677e5060f8" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:8b3ff069-df75-498b-a1f8-f51f2bd7c059" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:397fd602-9a30-4d8b-a9ba-7f46497e6648" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:87dcb749-21ec-4806-bb69-da9d55f9f5ab" & agri_income_05 == -9
	replace ind_var = 0 if key == "uuid:2b46e567-634a-45f4-abbd-e0174c03900d" & agri_income_05 == -9

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "agri_income_05" 
	rename agri_income_05 print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_05_unreasonable.dta", replace 
	}

restore 

***vi.  agri_income_06 should be answered when agri_income_01 = 1 ***
*** should be between 0 and 10000000 ***

preserve 

	*** generate indicator variable ***
	gen ind_var = 0
	replace ind_var = 1 if agri_income_01 == 1 & agri_income_06 < 0
	replace ind_var = 1 if agri_income_01 == 1 & agri_income_06 > 10000000 
	replace ind_var = 0 if key == "uuid:230eeec0-f4e6-476f-a49b-68a540e6612e" & agri_income_06 == -9
	replace ind_var = 0 if key == "uuid:cda122cf-9280-432d-a1a8-8b7d8c4948f9" & agri_income_06 == -9
	replace ind_var = 0 if key == "uuid:6942e4de-2992-42cc-b611-72abe5834a35" & agri_income_06 == -9
	replace ind_var = 0 if key == "uuid:36cc7c65-9580-4182-92d9-ddda36fbb0ea" & agri_income_06 == -9
	replace ind_var = 0 if key == "uuid:0d7abf18-244e-4440-b557-8ac4589ddf38" & agri_income_06 == -9
	replace ind_var = 0 if key == "uuid:7b999785-4d17-4867-8512-d3bf09c28590" & agri_income_06 == -9
	replace ind_var = 0 if key == "uuid:ec674bbd-07e3-4ad3-bb4e-915aed528559" & agri_income_06 == -9
	replace ind_var = 0 if key == "uuid:d99a8dd2-9a86-4b52-bda5-100b7ac0015d" & agri_income_06 == -9
	replace ind_var = 0 if key == "uuid:e30ea4ae-696d-4a95-b119-ffa43fde532f" & agri_income_06 == -9
	replace ind_var = 0 if key == "uuid:e25110ba-6df8-467a-b38e-577b9986dd00" & agri_income_06 == -9
	replace ind_var = 0 if key == "uuid:97c0bd0c-6d8c-4571-bc15-d2d169449e82" & agri_income_06 == -9
	replace ind_var = 0 if key == "uuid:24b6fa8e-852f-4176-a864-8d93e07675f2" & agri_income_06 == -9
	replace ind_var = 0 if key == "uuid:b66b0159-426b-41be-af40-5d9f2ef3c0e4" & agri_income_06 == -9
	replace ind_var = 0 if key == "uuid:91939cea-af27-4cf0-be7d-1ce751c8163b" & agri_income_06 == -9
	replace ind_var = 0 if key == "uuid:458de09c-ccc6-4759-b192-8dc7c6112bc4" & agri_income_06 == -9
	replace ind_var = 0 if key == "uuid:4478880a-f8ca-4a4c-9eb3-67465800791b" & agri_income_06 == -9
	replace ind_var = 0 if key == "uuid:2a436357-13ff-4710-a749-b012d58d5685" & agri_income_06 == -9
	replace ind_var = 0 if key == "uuid:53f60c19-7569-47c2-9423-ee4f516907c9" & agri_income_06 == -9
	replace ind_var = 0 if key == "uuid:0af345d0-6960-4805-899a-3123a7c1a547" & agri_income_06 == -9
	replace ind_var = 0 if key == "uuid:e707c317-45bd-4729-9216-380a140db29d" & agri_income_06 == -9
	replace ind_var = 0 if key == "uuid:a7a54357-649f-4f1e-b7f1-ca2977436360" & agri_income_06 == -9
	replace ind_var = 0 if key == "uuid:723843da-05ed-40ec-a63f-3a0374e444c9" & agri_income_06 == -9
	replace ind_var = 0 if key == "uuid:ca25ba07-535e-4cc2-a8c7-2fa5072d9318" & agri_income_06 == -9
	replace ind_var = 0 if key == "uuid:c2d6bc2b-f7cb-42d7-a0ef-b6c79d316202" & agri_income_06 == -9
	replace ind_var = 0 if key == "uuid:f2320249-e402-4c29-aea1-6c2dab838a8b" & agri_income_06 == -9
	replace ind_var = 0 if key == "uuid:b4135843-09e3-44e8-b649-7f6dbd35f542" & agri_income_06 == -9
	replace ind_var = 0 if key == "uuid:0be6fc2e-5699-49b5-9b31-d924e7ad7581" & agri_income_06 == -9
	replace ind_var = 0 if key == "uuid:17b1c705-ed89-443b-8ddc-4ca93f033edd" & agri_income_06 == -9
	replace ind_var = 0 if key == "uuid:32246f7b-b517-478d-b4f2-f8ab414ee1b2" & agri_income_06 == -9
	replace ind_var = 0 if key == "uuid:abd77c0d-982e-4867-b847-9531494e4578" & agri_income_06 == -9
	replace ind_var = 0 if key == "uuid:7d5ce99f-c798-473b-b2f0-e87458bb972f" & agri_income_06 == -9
	replace ind_var = 0 if key == "uuid:3edcedd7-4992-486e-a924-22eb67a877b3" & agri_income_06 == -9
	replace ind_var = 0 if key == "uuid:f5ebb1fa-32f5-47fd-8d6b-ffdaa02d551e" & agri_income_06 == -9
	replace ind_var = 0 if key == "uuid:64a4197f-9a39-4143-8f47-e2fa2e45b5f6" & agri_income_06 == -9
	replace ind_var = 0 if key == "uuid:bb216791-2b51-4b42-9f67-8616f652ec33" & agri_income_06 == -9
	replace ind_var = 0 if key == "uuid:f1a3ca58-71ee-4f17-9a08-8b2b64343adb" & agri_income_06 == -9
	replace ind_var = 0 if key == "uuid:f8968dc5-d7d2-48ef-b238-31677e5060f8" & agri_income_06 == -9
	replace ind_var = 0 if key == "uuid:f0bebe93-a4f0-40a0-8936-233682b356d1" & agri_income_06 == -9
	replace ind_var = 0 if key == "uuid:a398b76a-7378-444c-8717-36fb8d3d46df" & agri_income_06 == -9

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "agri_income_06" 
	rename agri_income_06 print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_06_unreasonable.dta", replace 
	}

restore 

*** vii. species_o should be answered when species_autre = 1 ***

preserve 

	*** generate indicator variable ***
	gen ind_var = 0
	replace ind_var = 1 if species_autre == 1 & species_o == "." 

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "species_o" 
	rename species_o print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_species_o_missing.dta", replace 
	}

restore 

*** viii. agri_income_09 should be answered when agri_income_08 is greater than 0 ***
*Note: Please verify max
forvalues i = 1/5{
	preserve 
	
	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_08_`i' > 0 & agri_income_08_`i' != . & agri_income_09_`i' == .
	
	*** keep and add variables to export 
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_income_09_`i'"
	rename agri_income_09_`i' print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
	save "$income\Issue_agri_income_09_`i'_missing.dta", replace 
	}
	restore

}

*** ix. agri_income_09_o should be answered when agri_income_09 = 7, should be text ***
forvalues i = 1/5{
	preserve 
	
	tostring agri_income_09_o_`i', replace
	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_09_`i' == 7 & agri_income_09_o_`i' == "."
	
	*** keep and add variables to export 
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_income_09_o_`i'"
	rename agri_income_09_o_`i' print_issue
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
	save "$income\Issue_agri_income_09_o_`i'_missing.dta", replace 
	}
	restore

}

*** x. agri_income_10 should be answered when agri_income_08 is greater than 0 ***
*** should be between 0 and 1000000 ***
forvalues i = 1/5{
	preserve 
	
	*** limit sample to agri_income_08 > 0 ***
	keep if agri_income_08_`i' > 0 & agri_income_08_`i' != .
	
	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_10_`i' < 0 | agri_income_10_`i' > 1000000
	replace ind_var = 0 if key == "uuid:53f60c19-7569-47c2-9423-ee4f516907c9" & agri_income_10_1 == -9 // were confirmed in checks
	replace ind_var = 0 if key == "uuid:446cce08-7cc4-44c1-be46-e651f216e5bc" & agri_income_10_2 == -9
	
	*** keep and add variables to export 
	keep if ind_var == 1 
	generate issue = "Unreasonable"
	generate issue_variable_name = "agri_income_10_`i'"
	rename agri_income_10_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
	save "$income\Issue_agri_income_10_`i'_unreasonable.dta", replace 
	}
	restore

}

*** xi. agri_income_07_o should be answered when species_autre = 1 ***
*** should be between 0 and 500 ***

preserve 

	*** limit sample to species_autre = 1 ***
	keep if species_autre == 1 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_07_o < 0 | agri_income_07_o > 500

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable"
	generate issue_variable_name = "agri_income_07_o"
	rename agri_income_07_o print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_07_o_unreasonable.dta", replace 
	}

restore

*** xii. agri_income_08_o should be answered when species_autre = 1 ***
*** should be between 0 and 500 ***

preserve 

	*** limit sample to species_autre = 1 ***
	keep if species_autre == 1 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_08_o < 0 | agri_income_08_o > 500

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable"
	generate issue_variable_name = "agri_income_08_o"
	rename agri_income_08_o print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_08_o_unreasonable.dta", replace 
	}

restore

*** xiii. agri_income_09_o_o should be answered when agri_income_08_o > 0 ***

preserve 

	*** limit sample to species_autre = 1 ***
	keep if species_autre == 1 

	*** limit sample to agri_income_08_o > 0 *** 
	keep if agri_income_08_o > 0 & agri_income_08_o != .
		
	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_09_o_o == .

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_income_09_o_o"
	rename agri_income_09_o_o print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_09_o_o_missing.dta", replace 
	}

restore

*** xiv. agri_income_09_o_o_o should be answered when agri_income_09_o_o = 7 ***

preserve 

	*** limit sample to species_autre = 1 ***
	keep if species_autre == 1 

	*** make sure agri_income_09_o_o_o is a string ***
	tostring(agri_income_09_o_o_o), replace 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_09_o_o == 7 & agri_income_09_o_o_o == "."

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_income_09_o_o_o"
	rename agri_income_09_o_o_o print_issue
	tostring(print_issue), replace  
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_09_o_o_o_missing.dta", replace 
	}

restore

*** xv. agri_income_09_o_o should be answered when agri_income_08_o > 0 ***
*** should be between 0 and 1000000 ***

preserve 

	*** limit sample to species_autre = 1 ***
	keep if species_autre == 1 

	*** limit sample to agri_income_08_o > 0 *** 
	keep if agri_income_08_o > 0 & agri_income_08_o != .
		
	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_10_o < 0 | agri_income_10_o > 1000000

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable"
	generate issue_variable_name = "agri_income_10_o"
	rename agri_income_10_o print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_10_o_unreasonable.dta", replace 
	}

restore

*** xvi. animals_sales_t should be answered when animals_sales_o = 1 ***

	preserve 

	*** generate indicator variable ***
	gen ind_var = 0
	replace ind_var = 1 if animals_sales_o == 1 & animals_sales_t == "." 

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "animals_sales_t" 
	rename animals_sales_t print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_animals_sales_t_missing.dta", replace 
	}

restore 

*** xvii. agri_income_13_autre should be answered when agri_income_13 = 99, should be text ***

** agri_income_13_1 is a string 
*Note: confirm max
forvalues i = 1/4 {
	preserve 
	
	*** make sure it is a string ***
	tostring(agri_income_13_autre_`i'), replace 
	
	*** generate indicator variable ***
	gen ind_var = 0
	replace ind_var = 1 if agri_income_13_99_`i' == 1 & agri_income_13_99_`i' != . & agri_income_13_autre_`i' == "."
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_income_13_autre_`i'" 
	rename agri_income_13_autre_`i' print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_13_autre_`i'_missing.dta", replace 
	}
	
	restore
}

*** check that agri_income_11 is not missing ***
forvalues i = 1/4 {
	preserve 


	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_11_`i' < 0 | agri_income_11_`i' > 500
	replace ind_var = 0 if sale_animalesindex_`i' == .

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable"
	generate issue_variable_name = "agri_income_11_`i'"
	rename agri_income_11_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_11_`i'_unreasonable.dta", replace 
	}

	restore
} 

*** xviii.	agri_income_11_o should be answered when animals_sales_o = 1, should be between 0 and 500  ***

preserve 

	*** limit sample to animals_sales_o = 1 ***
	keep if animals_sales_o == 1 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_11_o < 0 | agri_income_11_o > 500

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable"
	generate issue_variable_name = "agri_income_11_o"
	rename agri_income_11_o print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_11_o_unreasonable.dta", replace 
	}

restore

*** check that agri_income_12 is not missing ***
*Note: check max value for i 
forvalues i = 1/2 {
	preserve 


	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_12_`i' < 0 | agri_income_12_`i' > 1000000000
	replace ind_var = 0 if sale_animalesindex_`i' == .

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable"
	generate issue_variable_name = "agri_income_12_`i'"
	rename agri_income_12_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_12_`i'_unreasonable.dta", replace 
	}

	restore
} 

*** xix. agri_income_12_o should be answered when animals_sales_o = 1, should be between 0 and 1000000000 ***

preserve 

	*** limit sample to animals_sales_o = 1 ***
	keep if animals_sales_o == 1 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_12_o < 0 | agri_income_12_o > 1000000000

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable"
	generate issue_variable_name = "agri_income_12_o"
	rename agri_income_12_o print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_12_o_unreasonable.dta", replace 
	}

restore

*** check that agri_income_13 is not missing ***
*Note: check max i value 
*R2 - check max i val

forvalues i = 1/6 {
	
	preserve 

	tostring(agri_income_13_`i'), replace 
	
	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_13_`i' == "."
	replace ind_var = 0 if sale_animalesindex_`i' == .

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable"
	generate issue_variable_name = "agri_income_13_`i'"
	rename agri_income_13_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_13_`i'_unreasonable.dta", replace 
	}

	restore
} 




*** xx.	agri_income_13_o should be answered when animals_sales_o = 1 ***
* UPDATE

preserve 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if animals_sales_o == 1 & agri_income_13_o == .

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_income_13_o"
	rename agri_income_13_o print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_13_o_missing.dta", replace 
	}

restore
*/

*** xxi.	agri_income_14_ o should be answered animals_sales_o = 1, should be between 0 and 1000000000  

preserve 

	*** limit sample to animals_sales_o = 1 ***
	keep if animals_sales_o == 1 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_14_o < 0 | agri_income_14_o > 1000000000

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable"
	generate issue_variable_name = "agri_income_14_o"
	rename agri_income_14_o print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_14_o_unreasonable.dta", replace 
	}

restore

*** xxii.	agri_income_13_o_t should be answered when agri_income_13_o = 4, should be text  ***

preserve 

	*** make sure agri_income_13_o_t is a string ***
	tostring(agri_income_13_o_t), replace 

	*** generate indicator variable ***
	gen ind_var = 0
	replace ind_var = 1 if agri_income_13_o == 4 & agri_income_13_o_t == "."

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_income_13_o_t"
	rename agri_income_13_o_t print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_13_o_t_missing.dta", replace 
	}

restore

*** xxiii.	agri_income_16 should be answered when agri_income_15 = 1, should be between 0 and 50  ***

preserve 

	*** limit sample ***
	keep if agri_income_15 == 1 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_16 < 0 | agri_income_16 > 50
	replace ind_var = 0 if key == "uuid:ae414dc0-3027-4656-9f44-94b899afafe7" & agri_income_16 == -9

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable"
	generate issue_variable_name = "agri_income_16"
	rename agri_income_16 print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_16_unreasonable.dta", replace 
	}

restore

*** xxiv.	agri_income_18 should be answered when agri_income_15 = 1 *** 

preserve 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_15 == 1 & agri_income_18 == ""

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_income_18"
	rename agri_income_18 print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_18_missing.dta", replace 
	}

restore

*** xxv.	agri_income_18_o should be answered when agri_income_18 = 3, should be text  ***

preserve 

	*** generate indicator variable ***
	gen ind_var = 0 
	tostring agri_income_18_o, replace 
	replace ind_var = 1 if agri_income_18_3 == 1 & agri_income_18_o == "."

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_income_18_o"
	rename agri_income_18_o print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_18_o_missing.dta", replace 
	}

restore

*** xxvi.	agri_income_19 should be answered when agri_income_15 = 1, should be between 0 and 100000000 ***

preserve 

	*** limit sample to agri_income_15 = 1 ***
	keep if agri_income_15 == 1 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_19 < 0 | agri_income_19 > 100000000
	replace ind_var = 0 if key == "uuid:c87d313e-22c7-46b4-9aef-a2087808f7a4" & agri_income_19 == -9
	replace ind_var = 0 if key == "uuid:8895114d-827e-44d2-93c6-949d4c3c0ebe" & agri_income_19 == -9
	replace ind_var = 0 if key == "uuid:ae414dc0-3027-4656-9f44-94b899afafe7" & agri_income_19 == -9
	replace ind_var = 0 if key == "uuid:53f60c19-7569-47c2-9423-ee4f516907c9" & agri_income_19 == -9
	replace ind_var = 0 if key == "uuid:4230989a-8a58-4ea0-a832-181386899bf5" & agri_income_19 == -9
	replace ind_var = 0 if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980" & agri_income_19 == -9

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable"
	generate issue_variable_name = "agri_income_19"
	rename agri_income_19 print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_19_unreasonable.dta", replace 
	}

restore


*** xxvii.	agri_income_20_o should be answered when agri_income_20_t = 1, should be text   *** 

preserve 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_20_t == 1 & agri_income_20_o == "."

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_income_20_o"
	rename agri_income_20_o print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_20_o_missing.dta", replace 
	}

restore

*** xxviii.	agri_income_21_h_o should be answered when agri_income_20_t = 1, should be between 0 and 50 ***

preserve 

	*** limit sample to agri_income_20_t = 1 ***
	keep if agri_income_20_t == 1 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_21_h_o < 0 | agri_income_21_h_o > 50

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable"
	generate issue_variable_name = "agri_income_21_h_o"
	rename agri_income_21_h_o print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_21_h_o_unreasonable.dta", replace 
	}

restore

*** xxix.	agri_income_21_f_o should be answered when agri_income_20_t = 1, should be between 0 and 50  ***
 
preserve 

	*** limit sample to agri_income_20_t = 1 ***
	keep if agri_income_20_t == 1 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_21_f_o < 0 | agri_income_21_f_o > 50

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable"
	generate issue_variable_name = "agri_income_21_f_o"
	rename agri_income_21_f_o print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_21_f_o_unreasonable.dta", replace 
	}

	restore

*** xxx.	agri_income_22_o should be answered when agri_income_20_t = 1, should be between 0 and 12 *** 

preserve 

	*** limit sample to agri_income_20_t = 1 ***
	keep if agri_income_20_t == 1 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_22_o < 0 | agri_income_22_o > 12

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable"
	generate issue_variable_name = "agri_income_22_o"
	rename agri_income_22_o print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_22_o_unreasonable.dta", replace 
	}

restore

*** xxxi.	agri_income_23_o should be answered when agri_income_20_t = 1, should be between 0 and 1000000000  *** 

preserve 

	*** limit sample to agri_income_20_t = 1 ***
	keep if agri_income_20_t == 1 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_23_o < 0 | agri_income_23_o > 1000000000

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable"
	generate issue_variable_name = "agri_income_23_o"
	rename agri_income_23_o print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_23_o_unreasonable.dta", replace 
	}

restore

*** xxxii.	agri_income_26 should be answered when agri_income_25 = 1, should be between 0 and 50  ***

preserve 

	*** limit sample to agri_income_25 = 1 ***
	keep if agri_income_25 == 1 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_26 < 0 | agri_income_26 > 50

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable"
	generate issue_variable_name = "agri_income_26"
	rename agri_income_26 print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_26_unreasonable.dta", replace 
	}

restore

*** xxxiii.	agri_income_28 should be answered when agri_income_25 = 1 ***

preserve 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_25 == 1 & agri_income_28 == .

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_income_28"
	rename agri_income_28 print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_28_missing.dta", replace 
	}

restore

*** xxxiv.	agri_income_28_o should be answered when agri_income_28 = 3, should be text  ***

preserve 

	*** verify agri_income_28_o is a string ***
	tostring(agri_income_28_o), replace

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_28 == 3 & agri_income_28_o == "."

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_income_28_o"
	rename agri_income_28_o print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_28_o_missing.dta", replace 
	}

restore

*** xxxv.	agri_income_29 should be answered when agri_income_25 = 1, should be between 0 and 10000000  ***

preserve 

	*** limit sample to agri_income_25 = 1 ***
	keep if agri_income_25 == 1 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_29 < 0 | agri_income_29 > 10000000
	replace ind_var = 0 if key == "uuid:443cfabd-f98c-4336-8e20-80f8957bad20" & agri_income_29 == -9
replace ind_var = 0 if key == "uuid:40069d40-8775-4706-874f-10a74794a83d" & agri_income_29 == -9
replace ind_var = 0 if key == "uuid:4230989a-8a58-4ea0-a832-181386899bf5" & agri_income_29 == -9
replace ind_var = 0 if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980" & agri_income_29 == -9

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable"
	generate issue_variable_name = "agri_income_29"
	rename agri_income_29 print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_29_unreasonable.dta", replace 
	}

restore

*** xxxvi.	agri_income_31 should be answered when agri_income_30 = 1 *** 

preserve 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_30 == 1 & agri_income_31 == "."

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_income_31"
	rename agri_income_31 print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_31_missing.dta", replace 
	}

restore

*** xxxvii.	agri_income_31_o should be answered when agri_income_31 = 6, should be text   ***

preserve 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_31_6 == 1 & agri_income_31_o == "."

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_income_31_o"
	rename agri_income_31_o print_issue
	tostring(print_issue), replace  
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_31_missing_o.dta", replace 
	}

restore

*** xxxviii.	agri_income_32 should be answered when agri_income_30 = 1  ***

preserve 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_30 == 1 & agri_income_32 == .

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_income_32"
	rename agri_income_32 print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_32_missing.dta", replace 
	}

restore

*** xxxix.	agri_income_33 should be answered when agri_income_30 = 1 and agri_income_32 = 1, should be between 0 and 100000000 ***

preserve 

	*** limit sample to agri_income_30 = 1 & agri_income_32 == 1 ***
	keep if agri_income_30 == 1 & agri_income_32 == 1 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_33 < 0 | agri_income_33 > 10000000
replace ind_var = 0 if key == "uuid:ed4a3ab3-eb94-46fa-8ca7-d4305cf8e36e" & agri_income_33 == -9
replace ind_var = 0 if key == "uuid:6f48b23e-f222-48db-b73c-6bedf67a9889" & agri_income_33 == -9
replace ind_var = 0 if key == "uuid:d55a8454-7691-4b6d-bc0e-86712a701bc3" & agri_income_33 == -9
replace ind_var = 0 if key == "uuid:ae86ed43-5ec0-4f1c-904a-e5609618f94f" & agri_income_33 == -9
replace ind_var = 0 if key == "uuid:8c6736ef-01bd-4997-b8e7-02419b77bbb4" & agri_income_33 == -9
replace ind_var = 0 if key == "uuid:6fc34a13-7455-46b5-9d1a-5bafa2e11b9e" & agri_income_33 == -9
replace ind_var = 0 if key == "uuid:d252199f-1a7f-4ae2-8920-97ffe447aefb" & agri_income_33 == -9
replace ind_var = 0 if key == "uuid:cbcda759-6489-4a39-a76a-a93e0b05546c" & agri_income_33 == -9
replace ind_var = 0 if key == "uuid:dbcf5c48-d38a-4900-934d-1589c334478b" & agri_income_33 == -9
replace ind_var = 0 if key == "uuid:c7ecc3c7-f961-4f01-a59e-519ce6d7b325" & agri_income_33 == -9
replace ind_var = 0 if key == "uuid:2c43c97e-4854-45f3-acb7-49a56e4a5276" & agri_income_33 == -9
replace ind_var = 0 if key == "uuid:6942e4de-2992-42cc-b611-72abe5834a35" & agri_income_33 == -9
replace ind_var = 0 if key == "uuid:443cfabd-f98c-4336-8e20-80f8957bad20" & agri_income_33 == -9
replace ind_var = 0 if key == "uuid:1f8316b4-c849-40b4-8ced-4cb30d7d5944" & agri_income_33 == -9
replace ind_var = 0 if key == "uuid:97c0bd0c-6d8c-4571-bc15-d2d169449e82" & agri_income_33 == -9
replace ind_var = 0 if key == "uuid:f0e95d05-f703-4242-bb05-cdf1c7be4e16" & agri_income_33 == -9
replace ind_var = 0 if key == "uuid:4f7289fd-e9ce-47ce-b262-a003ec89ebd4" & agri_income_33 == -9
replace ind_var = 0 if key == "uuid:a7a54357-649f-4f1e-b7f1-ca2977436360" & agri_income_33 == -9
replace ind_var = 0 if key == "uuid:723843da-05ed-40ec-a63f-3a0374e444c9" & agri_income_33 == -9
replace ind_var = 0 if key == "uuid:245c21d7-f36b-4083-9a15-27de32aaf8e0" & agri_income_33 == -9
replace ind_var = 0 if key == "uuid:88167bbe-853b-48b8-a3f9-6bbb02c12309" & agri_income_33 == -9
replace ind_var = 0 if key == "uuid:04f3040a-9991-412d-9fce-9ee840eafcea" & agri_income_33 == -9
replace ind_var = 0 if key == "uuid:6b2af6f0-abd9-40ce-8bb7-792c1e9e0e18" & agri_income_33 == -9
replace ind_var = 0 if key == "uuid:17b1c705-ed89-443b-8ddc-4ca93f033edd" & agri_income_33 == -9
replace ind_var = 0 if key == "uuid:dedd712c-634c-4665-a874-f139341ecd5f" & agri_income_33 == -9
replace ind_var = 0 if key == "uuid:f5ebb1fa-32f5-47fd-8d6b-ffdaa02d551e" & agri_income_33 == -9
replace ind_var = 0 if key == "uuid:64a4197f-9a39-4143-8f47-e2fa2e45b5f6" & agri_income_33 == -9
replace ind_var = 0 if key == "uuid:f8968dc5-d7d2-48ef-b238-31677e5060f8" & agri_income_33 == -9
replace ind_var = 0 if key == "uuid:e62f05aa-7c34-4c69-95d6-f064f3d20cde" & agri_income_33 == -9
	

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable"
	generate issue_variable_name = "agri_income_33"
	rename agri_income_33 print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_33_unreasonable.dta", replace 
	}

restore

*** xl.	agri_income_name should be answered when agri_income_34 = 1  ***

preserve 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_34 == 1 & agri_income_name == "."

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_income_name"
	rename agri_income_name print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_name_missing.dta", replace 
	}

restore

*** xli.	agri_income_35 should be answered when agri_income_34 = 0  *** 

preserve 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_34 == 0 & agri_income_35 == .

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_income_35"
	rename agri_income_35 print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_35_missing.dta", replace 
	}

restore

*** xlii.	agri_income_36 should be answered when agri_income_34 = 1, should be between 0 and 100000000 ***
*Note: check max value for i
forvalues i = 1/2 {
	preserve 

	*** limit sample to agri_income_34 = 1 ***
	keep if agri_income_34 == 1  

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_36_`i' < 0 | agri_income_36_`i' > 10000000
	replace ind_var = 0 if credit_askindex_`i' == . 
	replace ind_var = 0 if key == "uuid:f2320249-e402-4c29-aea1-6c2dab838a8b" & agri_income_36_1 == -9
replace ind_var = 0 if key == "uuid:f2320249-e402-4c29-aea1-6c2dab838a8b" & agri_income_36_2 == -9

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable"
	generate issue_variable_name = "agri_income_36_`i'"
	rename agri_income_36_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_36_`i'_unreasonable.dta", replace 
	}

	restore
}

*** xliii.	agri_income_37 should be answered when agri_income_34 = 1, should be text  *** 

forvalues i = 1/2 {
	preserve 

	*** limit sample to agri_income_34 = 1 ***
	keep if agri_income_34 == 1  

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_37_`i' == "."
	replace ind_var = 0 if credit_askindex_`i' == . 

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable"
	generate issue_variable_name = "agri_income_37_`i'"
	rename agri_income_37_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_37_`i'_missing.dta", replace 
	}

	restore
}

*** xliv.	agri_income_38 should be answered when agri_income_34 = 1, should be less than agri_income_36 *** 
 
forvalues i = 1/2 {
	preserve 

	*** limit sample to agri_income_34 = 1 ***
	keep if agri_income_34 == 1  

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_38_`i' > agri_income_36_`i'
	replace ind_var = 0 if credit_askindex_`i' == . 

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable"
	generate issue_variable_name = "agri_income_38_`i'"
	rename agri_income_38_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_38_`i'_unreasonable.dta", replace 
	}

	restore
}

*** xlv.	agri_income_39 should be answered when agri_income_34 = 1, should be less than agri_income_36, agri_income_36 – agri_income_38 should be greater than agri_income_39   *** 

forvalues i = 1/2 {
	preserve 

	*** limit sample to agri_income_34 = 1 ***
	keep if agri_income_34 == 1  

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_39_`i' > agri_income_36_`i' | ((agri_income_36_`i' - agri_income_38_`i') < agri_income_39_`i')
	replace ind_var = 0 if credit_askindex_`i' == . 

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable"
	generate issue_variable_name = "agri_income_39_`i'"
	rename agri_income_39_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_39_`i'_unreasonable.dta", replace 
	}

	restore
}

*** xlvi.	agri_loan_name should be answered when agri_income_40 = 1 *** 

preserve 

	*** generate indicator variable ***
	tostring agri_loan_name, replace 
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_40 == 1 & agri_loan_name == "."

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_loan_name"
	rename agri_loan_name print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_loan_name_missing.dta", replace 
	}

restore

*** xlvii.	agri_income_41 should be answered when agri_income_40 = 1, should between 0 and 10000000  *** 
*Note: check max value for i
forvalues i = 1/1 {
	preserve 

	*** limit sample to agri_income_40 = 1 ***
	keep if agri_income_40 == 1  

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_41_`i' < 0 | agri_income_41_`i' > 10000000
	replace ind_var = 0 if loanindex_`i' == . 

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable"
	generate issue_variable_name = "agri_income_41_`i'"
	rename agri_income_41_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_41_`i'_unreasonable.dta", replace 
	}

	restore
}

***  xlviii.	agri_income_42 should be answered when agri_income_40 = 1, should be less than agri_income_41   *** 
*Note: check max value for i
forvalues i = 1/1 {
	preserve 

	*** limit sample to agri_income_40 = 1 ***
	keep if agri_income_40 == 1  

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_42_`i' > agri_income_41_`i'
	replace ind_var = 0 if loanindex_`i' == . 
	replace ind_var = 0 if key == "uuid:93743604-01c7-48c5-a295-3242254348b6" & agri_income_42_1 == 0

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable"
	generate issue_variable_name = "agri_income_42_`i'"
	rename agri_income_42_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_42_`i'_unreasonable.dta", replace 
	}

	restore
}

*** xlix.	agri_income_43 should be answered when agri_income_40 = 1, should be less than agri_income_41  *** 
*
*R2 - check i value
forvalues i = 1/1 {
	preserve 

	*** limit sample to agri_income_40 = 1 ***
	keep if agri_income_40 == 1  

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_43_`i' > agri_income_41_`i'
	replace ind_var = 0 if loanindex_`i' == . 

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable"
	generate issue_variable_name = "agri_income_43_`i'"
	rename agri_income_43_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_43_`i'_unreasonable.dta", replace 
	}

	restore
}

*** check if product_divers is missing ***

	preserve 

	*** limit sample to consent ***
	drop if consent == 0  

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if product_divers == "." 

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "product_divers"
	rename product_divers print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_product_divers.dta", replace 
	}

	restore
	
*** check if animal_sales is missing ***

	preserve 

	*** limit sample to consent ***
	drop if consent == 0  

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if animals_sales == "." 

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "animals_sales"
	rename animals_sales print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_animals_sales.dta", replace 
	}

	restore	

*** check if animal_sales is missing ***

	preserve 

	*** limit sample to consent ***
	drop if consent == 0  

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if animals_sales_o == . 

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "animals_sales_o"
	rename animals_sales_o print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_animals_sales_o.dta", replace 
	}

	restore		

*** l.	agri_income_46_o should be answered when agri_income_46 = 4, should be text *** 
*R2 - check i val
forvalues i=1/15 {
	preserve 
	
	*** make sure all are string variables *** 
	tostring(agri_income_46_o_`i'), replace 
	
	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_46_4_`i' == 1 & agri_income_46_o_`i' == "."
	replace ind_var = 0 if productindex_`i' == . 
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_income_46_o_`i'"
	rename agri_income_46_o_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_46_o_`i'_missing.dta", replace 
	}

	restore
	
}

*** li.	expenses_goods_o should be answered when expenses_goods_t = 1  *** 
preserve 

	*** verify expenses_goods_o is a string variable *** 
	tostring(expenses_goods_o), replace 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if expenses_goods_t == 1 & expenses_goods_o == "."

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "expenses_goods_o"
	rename expenses_goods_o print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_expenses_goods_o_missing.dta", replace 
	}

restore


*************************************	HOUSEHOLD INCOME SECTION ************************************************

*** i.	agri_income_07 should be between 0 and 500 ***	
*** ii.	agri_income_08 should be between 0 and 500 ***	
*** For each of these, only some households grow crops ***
*** So we should loop through numbers to not pick up extra values *** 
	*R2 - check max i val 
forvalues i = 1/7{
	preserve
     
    keep if agri_income_07_`i' < 0 | agri_income_07_`i' > 500
	drop if speciesindex_`i' == .
	drop if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980" & agri_income_07_1 == -9
	drop if key == "uuid:cfd81b39-f5e3-40d4-aab0-4b7c3d2da1bd" & agri_income_07_2 == -9
	drop if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980" & agri_income_07_2 == -9
	drop if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980" & agri_income_07_3 == -9
	generate issue = "Issue found: agri_income_07_`i' value not in bound (0<x<500)"
	generate issue_variable_name = "agri_income_07_`i'"
	rename agri_income_07_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_07_`i'_unreasonable", replace
}

    restore
}

preserve
     
    keep if agri_income_07_o < 0 | agri_income_07_o > 500
	drop if species_autre != 1
	generate issue = "Issue found: agri_income_07_o value not in bound (0<x<500)"
	generate issue_variable_name = "agri_income_07_o"
	rename agri_income_07_o print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_07_o_unreasonable", replace
}

restore

	*R2 - check max i val 

forvalues i = 1/7{
	preserve
     
    keep if agri_income_08_`i' < 0 | agri_income_08_`i' > 500
	drop if speciesindex_`i' == .
	drop if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980" & agri_income_08_1 == -9
	drop if key == "uuid:fa6b632a-58f0-4bc1-a921-5abb0680d79e" & agri_income_08_2 == -9
	drop if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980" & agri_income_08_2 == -9
	drop if key == "uuid:fa6b632a-58f0-4bc1-a921-5abb0680d79e" & agri_income_08_3 == -9
	drop if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980" & agri_income_08_3 == -9
	drop if key == "uuid:950634d7-6af7-48f4-81f2-23e84812d304" & agri_income_08_4 == -9
	
	generate issue = "Issue found: agri_income_08_`i' value not in bound (0<x<500)"
	generate issue_variable_name = "agri_income_08_`i'"
	rename agri_income_08_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_08_`i'_unreasonable", replace
}

    restore
}

preserve
     
    keep if agri_income_08_o < 0 | agri_income_08_o > 500
	drop if species_autre != 1
	generate issue = "Issue found: agri_income_08_o value not in bound (0<x<500)"
	generate issue_variable_name = "agri_income_08_o"
	rename agri_income_08_o print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_08_o_unreasonable", replace
}

restore

*** iii.	Agri_income_12 should be between 0 and 100000000 *** 
	*Note: check max i value 
	*R2 - check max i val
forvalues i = 1/6 {
	preserve
     
    keep if agri_income_12_`i' < 0 | agri_income_12_`i' > 100000000
	drop if sale_animalesindex_`i' == .
	generate issue = "Issue found: unreasonable value"
	generate issue_variable_name = "agri_income_12_`i'"
	rename agri_income_12_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_12_`i'_unreasonable", replace
}

    restore
}

	preserve
     
    keep if agri_income_12_o < 0 | agri_income_12_o > 100000000
	drop if animals_sales_o != 1
	generate issue = "Issue found: unreasonable value"
	generate issue_variable_name = "agri_income_12_o"
	rename agri_income_12_o print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_12_o_unreasonable", replace
}

    restore


*** iv.	agri_income_14 should be between 0 and 100000000 ***
	*R2 - check max i val
forvalues i = 1/6{
	preserve
     
    keep if agri_income_14_`i' < 0 | agri_income_14_`i' > 100000000
	drop if sale_animalesindex_`i' == .
	generate issue = "Issue found: unreasonable value"
	generate issue_variable_name = "agri_income_14_`i'"
	rename agri_income_14_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_14_`i'_unreasonable", replace
}

    restore
}

	preserve
     
    keep if agri_income_14_o < 0 | agri_income_14_o > 100000000
	drop if animals_sales_o != 1
	generate issue = "Issue found: unreasonable value"
	generate issue_variable_name = "agri_income_14_o"
	rename agri_income_14_o print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_14_o_unreasonable", replace
}

    restore
	
*** check that agri_income_20 is not missing ***
	preserve 

	*** drop no consent ***
	drop if consent == 0 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_20 == "."

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_income_20"
	rename agri_income_20 print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_20_unreasonable.dta", replace 
	}

	restore
	

***	v.	agri_income_21_h should be between 0 and 50 ***	
***	vi.	agri_income_21_f should be between 0 and 50 ***	
*KRM - added agri_income_21_f_4 agri_income_21_h_4 back in as it's been selected
foreach var of varlist agri_income_21_h_o agri_income_21_h_1 agri_income_21_h_2 agri_income_21_h_3 agri_income_21_f_1 agri_income_21_f_2 agri_income_21_f_3 agri_income_21_f_4 agri_income_21_h_4 {
	
preserve
    
	keep if `var' < 0 | `var' > 50 & `var' != .
	
	generate issue = "Unreasonable value"
	generate issue_variable_name = "`var'"
	rename `var' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_`var'", replace
}

    restore
}

***	vii. agri_income_22 should be less than 12 ***	
*KRM- added agri_income_22_4 back in as it's been selected

foreach var of varlist agri_income_22_o agri_income_22_1 agri_income_22_2 agri_income_22_3 agri_income_22_4 {
preserve
    keep if `var'  != . & `var' > 12
	generate issue = "Unreasonable value"
	generate issue_variable_name = "`var'"
	rename `var' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_`var'", replace
}
 restore
}

*** viii.	agri_income_23 should be between 0 and 1000000000 *** 
*Note: check max i value
	*R2 - check max i val
forvalues i = 1/5 {
	preserve
     
    keep if agri_income_23_`i' < 0 | agri_income_23_`i' > 1000000000
	drop if agri_income_20index_`i' == .
	drop if key == "uuid:88a033cc-ae5d-4bd6-860b-3f14ff81a0f0" & agri_income_23_1 == -9
drop if key == "uuid:8c6736ef-01bd-4997-b8e7-02419b77bbb4" & agri_income_23_1 == -9
drop if key == "uuid:63d08059-817d-45ae-bac7-ccdf05eb4c6a" & agri_income_23_1 == -9
drop if key == "uuid:8f49e817-68d3-4a92-98c6-02ed3739a07f" & agri_income_23_1 == -9
drop if key == "uuid:443cfabd-f98c-4336-8e20-80f8957bad20" & agri_income_23_1 == -9
drop if key == "uuid:31fd0450-5add-4058-bf77-a506823a7fca" & agri_income_23_1 == -9
drop if key == "uuid:bff7956c-0e63-4cf7-b6f8-abf16a8c0276" & agri_income_23_1 == -9
drop if key == "uuid:68a3059c-40a2-47ae-b9a7-d9072411b67a" & agri_income_23_1 == -9
drop if key == "uuid:2a48fd8c-b5b1-423b-87dd-c01cb6405189" & agri_income_23_1 == -9
drop if key == "uuid:c87d313e-22c7-46b4-9aef-a2087808f7a4" & agri_income_23_1 == -9
drop if key == "uuid:07374a46-8b35-4535-8e7f-aee405e62880" & agri_income_23_1 == -9
drop if key == "uuid:e1500728-8f0d-4082-aa0b-7151e4c98c24" & agri_income_23_1 == -9
drop if key == "uuid:d1e9a6b7-4901-4e70-a991-fa6db1906a2a" & agri_income_23_1 == -9
drop if key == "uuid:24b6fa8e-852f-4176-a864-8d93e07675f2" & agri_income_23_1 == -9
drop if key == "uuid:61144d37-6700-447a-b358-647e4312819f" & agri_income_23_1 == -9
drop if key == "uuid:40069d40-8775-4706-874f-10a74794a83d" & agri_income_23_1 == -9
drop if key == "uuid:9147cf5c-0509-4118-994c-462c61bcc4fe" & agri_income_23_1 == -9
drop if key == "uuid:3b9c2531-3c02-4417-85f4-4023e1fd13cf" & agri_income_23_1 == -9
drop if key == "uuid:59d24152-883e-4d28-9e64-01a5d66013fb" & agri_income_23_1 == -9
drop if key == "uuid:ae79a16b-e91d-43dd-bf07-f5d8243dbc65" & agri_income_23_1 == -9
drop if key == "uuid:a0de5050-073d-47e2-934a-cf2cc8d2c532" & agri_income_23_1 == -9
drop if key == "uuid:2a436357-13ff-4710-a749-b012d58d5685" & agri_income_23_1 == -9
drop if key == "uuid:53f60c19-7569-47c2-9423-ee4f516907c9" & agri_income_23_1 == -9
drop if key == "uuid:2d69cae2-bc11-4173-a5df-4264bd41d410" & agri_income_23_1 == -9
drop if key == "uuid:8befef83-7f84-46ca-87f6-742b686956e6" & agri_income_23_1 == -9
drop if key == "uuid:46f5d5d9-d7d5-41a2-abe2-014313e781cf" & agri_income_23_1 == -9
drop if key == "uuid:723843da-05ed-40ec-a63f-3a0374e444c9" & agri_income_23_1 == -9
drop if key == "uuid:ca25ba07-535e-4cc2-a8c7-2fa5072d9318" & agri_income_23_1 == -9
drop if key == "uuid:0b997d0d-f27c-4fb5-bca7-42e6220b29c4" & agri_income_23_1 == -9
drop if key == "uuid:245c21d7-f36b-4083-9a15-27de32aaf8e0" & agri_income_23_1 == -9
drop if key == "uuid:b4135843-09e3-44e8-b649-7f6dbd35f542" & agri_income_23_1 == -9
drop if key == "uuid:0be6fc2e-5699-49b5-9b31-d924e7ad7581" & agri_income_23_1 == -9
drop if key == "uuid:26971b58-f29b-4ca2-835b-f25a19f057c3" & agri_income_23_1 == -9
drop if key == "uuid:8915a062-0f9a-4c85-a7a6-1b4fa6b3e3f1" & agri_income_23_1 == -9
drop if key == "uuid:02a39efd-23f1-4815-9b17-ff8b43173d90" & agri_income_23_1 == -9
drop if key == "uuid:32246f7b-b517-478d-b4f2-f8ab414ee1b2" & agri_income_23_1 == -9
drop if key == "uuid:4d1f8b31-796d-4edf-80d4-823d5fc08571" & agri_income_23_1 == -9
drop if key == "uuid:abd77c0d-982e-4867-b847-9531494e4578" & agri_income_23_1 == -9
drop if key == "uuid:dedd712c-634c-4665-a874-f139341ecd5f" & agri_income_23_1 == -9
drop if key == "uuid:78498830-729b-4669-a8b0-ddb3ba898a73" & agri_income_23_1 == -9
drop if key == "uuid:fe254168-10ee-4b8e-bfe5-5e3d6e47d26e" & agri_income_23_1 == -9
drop if key == "uuid:7d5ce99f-c798-473b-b2f0-e87458bb972f" & agri_income_23_1 == -9
drop if key == "uuid:3edcedd7-4992-486e-a924-22eb67a877b3" & agri_income_23_1 == -9
drop if key == "uuid:bb216791-2b51-4b42-9f67-8616f652ec33" & agri_income_23_1 == -9
drop if key == "uuid:abb87752-4a63-446c-9b08-114b67de3f6e" & agri_income_23_1 == -9
drop if key == "uuid:49e1ea67-b6bc-4685-822a-04e4963bbd19" & agri_income_23_1 == -9
drop if key == "uuid:197be989-16e8-4ef0-b91f-a6cb3287c2d8" & agri_income_23_1 == -9
drop if key == "uuid:e62f05aa-7c34-4c69-95d6-f064f3d20cde" & agri_income_23_1 == -9
drop if key == "uuid:f0bebe93-a4f0-40a0-8936-233682b356d1" & agri_income_23_1 == -9
drop if key == "uuid:6fc043eb-a620-4e71-bd62-850b4b3b79cd" & agri_income_23_1 == -9
drop if key == "uuid:ef0ba8e1-fdef-45f1-9218-25f9493d122e" & agri_income_23_1 == -9
drop if key == "uuid:755e6213-1a72-4412-b634-a3e3259586ea" & agri_income_23_1 == -9
drop if key == "uuid:147fc8cf-acbe-4e51-aa7b-8eb92b783fd0" & agri_income_23_1 == -9
drop if key == "uuid:8d65b726-e9bc-49af-bcbc-762f36075dc8" & agri_income_23_1 == -9
drop if key == "uuid:76e1afe0-c769-48fe-843a-4c17f85fdbec" & agri_income_23_1 == -9
drop if key == "uuid:d3647dde-8f8b-4a1b-a7b8-7a1625ace056" & agri_income_23_1 == -9
drop if key == "uuid:5f863611-f2c8-46aa-b747-7c0081328ac3" & agri_income_23_1 == -9
drop if key == "uuid:c51053da-4b7f-447a-94ca-7576bc6259c6" & agri_income_23_1 == -9
drop if key == "uuid:fee45475-a2e7-453b-aa2d-20bc077e1247" & agri_income_23_1 == -9
drop if key == "uuid:de493f3d-0dd1-4090-a9eb-3a0e67225367" & agri_income_23_1 == -9
drop if key == "uuid:6f13c3cb-d0dd-4c27-b73b-c9a6843687c5" & agri_income_23_1 == -9
drop if key == "uuid:47e49c11-a7c8-4f84-ad73-cecb40bacc62" & agri_income_23_1 == -9
drop if key == "uuid:83daaf4c-5cd4-4774-9364-769d8a3d97e4" & agri_income_23_1 == -9
drop if key == "uuid:03f80375-e27b-4aee-80f2-983af72db81e" & agri_income_23_1 == -9
drop if key == "uuid:af2fa2b6-d183-4406-8d00-4be4c168e97b" & agri_income_23_1 == -9
drop if key == "uuid:c2a63575-25c7-4189-90a2-68a5f7140b9e" & agri_income_23_1 == -9
drop if key == "uuid:6040d2eb-1fae-4730-91e1-6e4f7bb98dfa" & agri_income_23_1 == -9
drop if key == "uuid:634c64a4-3dc4-44bd-9a93-3502cfb663c9" & agri_income_23_1 == -9
drop if key == "uuid:87ecb9b2-7218-4e4d-a645-f1c780305504" & agri_income_23_1 == -9
drop if key == "uuid:128199d5-45c7-4c42-b56f-cbfadf72b88c" & agri_income_23_1 == -9
drop if key == "uuid:008b2d0c-9a04-4426-94d6-7b9b9a83cfc4" & agri_income_23_1 == -9
drop if key == "uuid:a621035f-2fcc-4ada-b25b-8ec0e6d6090c" & agri_income_23_1 == -9
drop if key == "uuid:4a5d7d2a-5de0-435e-af76-30d1ef85e5c0" & agri_income_23_1 == -9
drop if key == "uuid:79e1a0b4-c1c2-4b85-89f7-854a3b3fbc1e" & agri_income_23_1 == -9
drop if key == "uuid:46693568-4859-402d-ab33-9639f9622ca1" & agri_income_23_1 == -9
drop if key == "uuid:83139d1d-2f8e-4508-a16f-ab293c21e60e" & agri_income_23_1 == -9
drop if key == "uuid:beafc02c-dc0d-4a2f-896e-e06ddfbebdab" & agri_income_23_1 == -9
drop if key == "uuid:2a436357-13ff-4710-a749-b012d58d5685" & agri_income_23_2 == -9
drop if key == "uuid:8915a062-0f9a-4c85-a7a6-1b4fa6b3e3f1" & agri_income_23_2 == -9
drop if key == "uuid:a3b4a2de-dfd2-4985-9f7f-88f577cbde09" & agri_income_23_2 == -9
drop if key == "uuid:2bb8d593-96ee-4652-8db4-65eae2b880fe" & agri_income_23_2 == -9
drop if key == "uuid:af2fa2b6-d183-4406-8d00-4be4c168e97b" & agri_income_23_2 == -9
drop if key == "uuid:af2fa2b6-d183-4406-8d00-4be4c168e97b" & agri_income_23_3 == -9
	
	generate issue = "Issue found: unreasonable value"
	generate issue_variable_name = "agri_income_23_`i'"
	rename agri_income_23_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_23_`i'_unreasonable", replace
}

    restore
}

	preserve
     
    keep if agri_income_23_o < 0 | agri_income_23_o > 1000000000
	drop if agri_income_20_t != 1
	drop if key == "uuid:ed4a3ab3-eb94-46fa-8ca7-d4305cf8e36e" & agri_income_23_o == -9 
drop if key == "uuid:8c6736ef-01bd-4997-b8e7-02419b77bbb4" & agri_income_23_o == -9
drop if key == "uuid:2086c8e7-cfb1-472b-ad6d-f21b87b90881" & agri_income_23_o == -9
drop if key == "uuid:8be12456-9c4d-4e61-917b-2f94584d4796" & agri_income_23_o == -9
drop if key == "uuid:d3de785c-2ad1-45a0-a8c0-5e41e53483da" & agri_income_23_o == -9
drop if key == "uuid:dbcf5c48-d38a-4900-934d-1589c334478b" & agri_income_23_o == -9
	
	generate issue = "Issue found: unreasonable value"
	generate issue_variable_name = "agri_income_23_o"
	rename agri_income_23_o print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_23_o_unreasonable", replace
}

    restore

*** ix.	agri_income_45 should be between 0 and 1000000000 ***	
*** Add step to get rid of missings when the household doesn't grow the product ***
*Note: check max i value
forvalues i=1/15 {
preserve
    local var agri_income_45_`i'
    keep if `var' < 0 | `var' > 1000000000
	drop if productindex_`i' == . 
	drop if key == "uuid:2a436357-13ff-4710-a749-b012d58d5685" & agri_income_45_1 == -9
drop if key == "uuid:78498830-729b-4669-a8b0-ddb3ba898a73" & agri_income_45_1 == -9
drop if key == "uuid:9f46c69f-f13a-4f0d-8035-91c346dcb751" & agri_income_45_2 == -9
drop if key == "uuid:f0e95d05-f703-4242-bb05-cdf1c7be4e16" & agri_income_45_2 == -9
drop if key == "uuid:002674f4-6ea0-4f36-9a11-79038e40bbc2" & agri_income_45_2 == -9
drop if key == "uuid:a174f3ae-1533-4f24-9056-c76dc2c8ec40" & agri_income_45_2 == -9
drop if key == "uuid:4478880a-f8ca-4a4c-9eb3-67465800791b" & agri_income_45_2 == -9
drop if key == "uuid:2a436357-13ff-4710-a749-b012d58d5685" & agri_income_45_2 == -9
drop if key == "uuid:e6efc18c-7a7b-4132-8535-6e7dff6a7ac7" & agri_income_45_2 == -9
drop if key == "uuid:f2320249-e402-4c29-aea1-6c2dab838a8b" & agri_income_45_2 == -9
drop if key == "uuid:0b997d0d-f27c-4fb5-bca7-42e6220b29c4" & agri_income_45_2 == -9
drop if key == "uuid:78498830-729b-4669-a8b0-ddb3ba898a73" & agri_income_45_2 == -9
drop if key == "uuid:9b78b42a-a3ec-49d3-a987-30b77f3872d0" & agri_income_45_3 == -9
drop if key == "uuid:36cc7c65-9580-4182-92d9-ddda36fbb0ea" & agri_income_45_3 == -9
drop if key == "uuid:002674f4-6ea0-4f36-9a11-79038e40bbc2" & agri_income_45_3 == -9
drop if key == "uuid:a174f3ae-1533-4f24-9056-c76dc2c8ec40" & agri_income_45_3 == -9
drop if key == "uuid:4478880a-f8ca-4a4c-9eb3-67465800791b" & agri_income_45_3 == -9
drop if key == "uuid:2a436357-13ff-4710-a749-b012d58d5685" & agri_income_45_3 == -9
drop if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980" & agri_income_45_3 == -9
drop if key == "uuid:46c68d66-a26a-41b3-854d-df3e6a061945" & agri_income_45_4 == -9
drop if key == "uuid:2a436357-13ff-4710-a749-b012d58d5685" & agri_income_45_4 == -9
drop if key == "uuid:36cc7c65-9580-4182-92d9-ddda36fbb0ea" & agri_income_45_5 == -9
drop if key == "uuid:46c68d66-a26a-41b3-854d-df3e6a061945" & agri_income_45_5 == -9
drop if key == "uuid:9e53c128-b360-47f1-a624-e5a0e0e8c3cd" & agri_income_45_5 == -9
drop if key == "uuid:3730061c-a719-461a-a962-034ffbfd7e20" & agri_income_45_5 == -9
drop if key == "uuid:f2652d13-6956-4a7e-879b-99bf73b286ac" & agri_income_45_5 == -9
drop if key == "uuid:77adf104-aae7-4179-953f-b5bcf21dadda" & agri_income_45_5 == -9
drop if key == "uuid:2a436357-13ff-4710-a749-b012d58d5685" & agri_income_45_5 == -9
drop if key == "uuid:36cc7c65-9580-4182-92d9-ddda36fbb0ea" & agri_income_45_6 == -9
drop if key == "uuid:46c68d66-a26a-41b3-854d-df3e6a061945" & agri_income_45_6 == -9
drop if key == "uuid:e5eb596e-392d-43e1-8ac5-19f7993e9401" & agri_income_45_6 == -9
drop if key == "uuid:27620229-c213-47f3-8b61-f8ec6c7cd1cc" & agri_income_45_6 == -9
drop if key == "uuid:896ef294-6ea0-45d0-9468-3f1bdf54924e" & agri_income_45_6 == -9
drop if key == "uuid:481263fb-d102-43b2-8504-d72a780bd7e8" & agri_income_45_6 == -9
drop if key == "uuid:f0e95d05-f703-4242-bb05-cdf1c7be4e16" & agri_income_45_7 == -9
drop if key == "uuid:801e11ec-467f-4cc9-9eb6-0dec8dbec2a5" & agri_income_45_7 == -9
	generate issue = "Unreasonable value"
	generate issue_variable_name = "`var'"
	rename `var' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_`var'", replace
}
restore
}

*** check to make sure agri_income_46 is not missing *** 
*Note: check max i value

forvalues i=1/15 {
preserve
    local var agri_income_46_`i'
	tostring(`var'), replace 
    keep if `var' == "."
	drop if productindex_`i' == . 
	generate issue = "Missing"
	generate issue_variable_name = "`var'"
	rename `var' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_`var'", replace
}
restore
}

***	x.	agri_income_47 should be between 0 and 1000000000 ***	

forvalues i = 1/2 {
    preserve
  
    keep if  agri_income_47_`i' < 0 | agri_income_47_`i' > 1000000000
	drop if goodsinex_`i' == . 
	drop if key == "uuid:a1261fd4-5c99-4e06-91c4-ac1072db7e5e" & agri_income_47_1 == -9
	drop if key == "uuid:446cce08-7cc4-44c1-be46-e651f216e5bc" & agri_income_47_1 == -9
	drop if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980" & agri_income_47_1 == -9
	
	generate issue = "Unreasonable value"
	generate issue_variable_name = "agri_income_47_`i'"
	rename agri_income_47_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_47_`i'", replace
	}
	restore 	
}

forvalues i = 1/2 {
    preserve
  
    keep if  agri_income_48_`i' < 0 | agri_income_48_`i' > 1000000000
	drop if goodsinex_`i' == . 
	drop if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980" & agri_income_48_1 == -9
	drop if key == "uuid:a850d7a9-ed56-4f03-8045-6e298dae3fff" & agri_income_48_2 == -9
	generate issue = "Unreasonable value"
	generate issue_variable_name = "agri_income_48_`i'"
	rename agri_income_48_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$income\Issue_agri_income_48_`i'", replace
	}
	restore 	
}

preserve 

	keep if expenses_goods_t == 1 

	keep if  agri_income_47_o < 0 | agri_income_47_o > 1000000000
	generate issue = "Unreasonable value"
	generate issue_variable_name = "agri_income_47_o"
	rename agri_income_47_o print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
		if _N > 0 {
			save "$income\Issue_agri_income_47_o", replace
		}
		
restore 	

******************* Standard of Living Checks ************************

*** living_01_o should be answered when living_01 == 99, should be text *** 

preserve 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if living_01 == 99 & living_01_o == "."

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "living_01_o" 
	rename living_01_o print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$standard_living\Issue_living_01_o_missing.dta", replace 
	}

restore 

*** living_03 should be answered when living_02 =1 ***
preserve 

	*** Generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if living_02 == 1  & living_03 == . 

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "living_03" 
	rename living_03 print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$standard_living\Issue_living_03_missing.dta", replace 
	}

restore 

*** living_03_o should be answered when living_03 == 99, should be text *** 

preserve 

	*** generate indicator variable ***
	tostring living_03_o, replace
	gen ind_var = 0 
	replace ind_var = 1 if living_03 == 99 & living_03_o == "."

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "living_03_o" 
	rename living_03_o print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$standard_living\Issue_living_03_o_missing.dta", replace 
	}

restore 

*** living_04_o should be answered when living_04 == 99, should be text *** 

preserve 

	*** generate indicator variable ***
	tostring living_04_o, replace 
	gen ind_var = 0 
	replace ind_var = 1 if living_04 == 99 & living_04_o == "."

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "living_04_o" 
	rename living_04_o print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$standard_living\Issue_living_04_o_missing.dta", replace 
	}

restore 

*** living_05_o should be answered when living_05 == 99, should be text *** 

************** convert living_05_o to string if not already ********************
tostring living_05_o, replace 

	preserve 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if living_05 == 99 & living_05_o == "."

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "living_05_o" 
	rename living_05_o print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$standard_living\Issue_living_05_o_missing.dta", replace 
	}

restore 

*** living_06_o should be answered when living_06 == 99, should be text *** 

preserve 

	*** generate indicator variable ***
	gen ind_var = 0 
	tostring living_06_o, replace 
	replace ind_var = 1 if living_06 == 99 & living_06_o == "."

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "living_06_o" 
	rename living_06_o print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$standard_living\Issue_living_06_o_missing.dta", replace 
	}

restore 


******************* Enumerator Observations Checks ********************

*** enum_02 should be answered when enum_01 = 1, response should be between 0 and 15 

*** PART 01 - Make sure it is filled out when asked for and reasonable ***

preserve 

	*** Generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if enum_01 == 1 & (enum_02 < 0 | enum_02 > 15)

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "enum_02" 
	rename enum_02 print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$enum_observations\Issue_enum_02_unreasonable.dta", replace 
	}

restore 

*** PART 02 - Check for extra responses ***

preserve 

	*** Generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if enum_01 != 1 & enum_02 != .

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Extra response"
	generate issue_variable_name = "enum_02" 
	rename enum_02 print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$enum_observations\Issue_enum_02_extraresponse.dta", replace 
	}

restore 

*** check if enum_03 is missing ***

    preserve 

	*** drop no consent households *** 
	drop if consent == 0 
	
	gen ind_var = 0
    replace ind_var = 1 if enum_03 == .  

    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Missing value"
	generate issue_variable_name = "enum_03"
	rename enum_03 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$enum_observations\Issue_enum_03.dta", replace
    }
  
    restore

*** enum_03_o should be answered when enum_03 == 99, should be text *** 

preserve 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if enum_03 == 99 & enum_03_o == "."

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "enum_03_o" 
	rename enum_03_o print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$enum_observations\Issue_enum_03_o_missing.dta", replace 
	}

restore 

*** check if enum_04 is missing ***

    preserve 

	*** drop no consent households *** 
	drop if consent == 0 
	
	gen ind_var = 0
    replace ind_var = 1 if enum_04 == .  

    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Missing value"
	generate issue_variable_name = "enum_04"
	rename enum_04 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$enum_observations\Issue_enum_04.dta", replace
    }
  
    restore

*** enum_04_o should be answered when enum_04 == 99, should be text *** 

preserve 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if enum_04 == 99 & enum_04_o == "."

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "enum_04_o" 
	rename enum_04_o print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$enum_observations\Issue_enum_04_o_missing.dta", replace 
	}

restore 

*** enum_05_o should be answered when enum_05 == 99, should be text *** 

preserve 

	*** generate indicator variable ***
	tostring enum_05_o, replace 
	gen ind_var = 0 
	replace ind_var = 1 if enum_05 == 99 & enum_05_o == "."

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "enum_05_o" 
	rename enum_05_o print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$enum_observations\Issue_enum_05_o_missing.dta", replace 
	}

restore 


*** enum_07 should be answered when enum_06 = 3, 4, or 5, should be text *** 

preserve 

*** generate indicator variable ***
gen ind_var = 0 
replace ind_var = 1 if enum_06 == 3 & enum_07 == "."
replace ind_var = 1 if enum_06 == 4 & enum_07 == "."
replace ind_var = 1 if enum_06 == 5 & enum_07 == "."

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "enum_07" 
	rename enum_07 print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$enum_observations\Issue_enum_07_missing.dta", replace 
	}

restore 

****************** Beleifs Data Checks *****************************
*** check if beliefs_01 is missing ***

    preserve 

	*** drop no consent households *** 
	drop if consent == 0 
	
	gen ind_var = 0
    replace ind_var = 1 if beliefs_01 == .  

    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Missing value"
	generate issue_variable_name = "beliefs_01"
	rename beliefs_01 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$beliefs\Issue_beliefs_01.dta", replace
    }
  
    restore

*** check if beliefs_02 is missing ***

    preserve 

	*** drop no consent households *** 
	drop if consent == 0 
	
	gen ind_var = 0
    replace ind_var = 1 if beliefs_02 == .  

    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Missing value"
	generate issue_variable_name = "beliefs_02"
	rename beliefs_02 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$beliefs\Issue_beliefs_02.dta", replace
    }
  
    restore
	
*** check if beliefs_03 is missing ***

    preserve 

	*** drop no consent households *** 
	drop if consent == 0 
	
	gen ind_var = 0
    replace ind_var = 1 if beliefs_03 == .  

    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Missing value"
	generate issue_variable_name = "beliefs_03"
	rename beliefs_03 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$beliefs\Issue_beliefs_03.dta", replace
    }
  
    restore	

	*** check if beliefs_04 is missing ***

    preserve 

	*** drop no consent households *** 
	drop if consent == 0 
	
	gen ind_var = 0
    replace ind_var = 1 if beliefs_04 == .  

    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Missing value"
	generate issue_variable_name = "beliefs_04"
	rename beliefs_04 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$beliefs\Issue_beliefs_04.dta", replace
    }
  
    restore

*** check if beliefs_05 is missing ***

    preserve 

	*** drop no consent households *** 
	drop if consent == 0 
	
	gen ind_var = 0
    replace ind_var = 1 if beliefs_05 == .  

    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Missing value"
	generate issue_variable_name = "beliefs_05"
	rename beliefs_05 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$beliefs\Issue_beliefs_05.dta", replace
    }
  
    restore	

*** check if beliefs_06 is missing ***

    preserve 

	*** drop no consent households *** 
	drop if consent == 0 
	
	gen ind_var = 0
    replace ind_var = 1 if beliefs_06 == .  

    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Missing value"
	generate issue_variable_name = "beliefs_06"
	rename beliefs_06 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$beliefs\Issue_beliefs_06.dta", replace
    }
  
    restore

*** check if beliefs_07 is missing ***

    preserve 

	*** drop no consent households *** 
	drop if consent == 0 
	
	gen ind_var = 0
    replace ind_var = 1 if beliefs_07 == .  

    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Missing value"
	generate issue_variable_name = "beliefs_07"
	rename beliefs_07 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$beliefs\Issue_beliefs_07.dta", replace
    }
  
    restore

*** check if beliefs_08 is missing ***

    preserve 

	*** drop no consent households *** 
	drop if consent == 0 
	
	gen ind_var = 0
    replace ind_var = 1 if beliefs_08 == .  

    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Missing value"
	generate issue_variable_name = "beliefs_08"
	rename beliefs_08 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$beliefs\Issue_beliefs_08.dta", replace
    }
  
    restore	

*** check if beliefs_09 is missing ***

    preserve 

	*** drop no consent households *** 
	drop if consent == 0 
	
	gen ind_var = 0
    replace ind_var = 1 if beliefs_09 == .  

    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Missing value"
	generate issue_variable_name = "beliefs_09"
	rename beliefs_09 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$beliefs\Issue_beliefs_09.dta", replace
    }
  
    restore	
	

	******************* Enumerator Observations Checks ********************

*** enum_02 should be answered when enum_01 = 1, response should be between 0 and 15 

*** PART 01 - Make sure it is filled out when asked for and reasonable ***

preserve 

	*** Generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if enum_01 == 1 & (enum_02 < 0 | enum_02 > 15)

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "enum_02" 
	rename enum_02 print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$enum_observations\Issue_enum_02_unreasonable.dta", replace 
	}

restore 

*** PART 02 - Check for extra responses ***

preserve 

	*** Generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if enum_01 != 1 & enum_02 != .

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Extra response"
	generate issue_variable_name = "enum_02" 
	rename enum_02 print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$enum_observations\Issue_enum_02_extraresponse.dta", replace 
	}

restore 

*** check if enum_03 is missing ***

    preserve 

	*** drop no consent households *** 
	drop if consent == 0 
	
	gen ind_var = 0
    replace ind_var = 1 if enum_03 == .  

    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Missing value"
	generate issue_variable_name = "enum_03"
	rename enum_03 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$enum_observations\Issue_enum_03.dta", replace
    }
  
    restore

*** enum_03_o should be answered when enum_03 == 99, should be text *** 

preserve 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if enum_03 == 99 & enum_03_o == "."

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "enum_03_o" 
	rename enum_03_o print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$enum_observations\Issue_enum_03_o_missing.dta", replace 
	}

restore 

*** check if enum_04 is missing ***

    preserve 

	*** drop no consent households *** 
	drop if consent == 0 
	
	gen ind_var = 0
    replace ind_var = 1 if enum_04 == .  

    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Missing value"
	generate issue_variable_name = "enum_04"
	rename enum_04 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$enum_observations\Issue_enum_04.dta", replace
    }
  
    restore

*** enum_04_o should be answered when enum_04 == 99, should be text *** 

preserve 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if enum_04 == 99 & enum_04_o == "."

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "enum_04_o" 
	rename enum_04_o print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$enum_observations\Issue_enum_04_o_missing.dta", replace 
	}

restore 

*** enum_05_o should be answered when enum_05 == 99, should be text *** 

preserve 

	*** generate indicator variable ***
	tostring enum_05_o, replace 
	gen ind_var = 0 
	replace ind_var = 1 if enum_05 == 99 & enum_05_o == "."

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "enum_05_o" 
	rename enum_05_o print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$enum_observations\Issue_enum_05_o_missing.dta", replace 
	}

restore 


*** enum_07 should be answered when enum_06 = 3, 4, or 5, should be text *** 

preserve 

*** generate indicator variable ***
gen ind_var = 0 
replace ind_var = 1 if enum_06 == 3 & enum_07 == "."
replace ind_var = 1 if enum_06 == 4 & enum_07 == "."
replace ind_var = 1 if enum_06 == 5 & enum_07 == "."

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "enum_07" 
	rename enum_07 print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_name_complet_resp hh_name_complet_resp_new issue_variable_name issue print_issue key
	if _N > 0 {
		save "$enum_observations\Issue_enum_07_missing.dta", replace 
	}

restore 

	
	
*** End of .do file ** 

