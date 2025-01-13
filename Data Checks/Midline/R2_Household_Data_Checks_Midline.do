*** DISES Midline Data Checks - Household Survey***
*** File originally created By: Molly Doruska - Adapted by Kateri Mouawad & Alex Mills ***
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


*** additional file paths ***
global data "$master\Surveys\Baseline CRDES data (Jan-Feb 2024)"

global village_observations "$master\Data Quality Checks\Output\Village_Household_Identifiers"
global household_roster "$master\Data Quality Checks\Output\Baseline\Jan-Feb Output\Household_Roster"
global knowledge "$master\Data Quality Checks\Output\Knowledge"
global health "$master\Data Quality Checks\Output\Health" 
global agriculture_inputs "$master\Data Quality Checks\Output\Agriculture_Inputs"
global agriculture_production "$master\Data Quality Checks\Output\Agriculture_Production"
global food_consumption "$master\Data Quality Checks\Output\Food_Consumption"
global income "$master\Data Quality Checks\Output\Income"
global standard_living "$master\Data Quality Checks\Output\Standard_Living"
global beliefs "$master\Data Quality Checks\Output\Beliefs" 
global public_goods "$master\Data Quality Checks\Output\Public_Goods"
global enum_observations "$master\Data Quality Checks\Output\Enumerator_Observations"

*** Import household data - update this every new data cleaning session ***
import delimited "$data\DISES_enquete_ménage_FINALE_WIDE_6Feb24.csv", clear varnames(1) bindquote(strict)

*** import community survey data ***


*** label variables - location and respondent ***
label variable village_select "Selectionnez le vilalge pour le questionnaire menage"
label variable village_select_o "Nom du village"
label variable hhid_village "Village ID"
label variable consent "Acceptez-vous de faire l'interview et de participier a l'etude"
label variable hh_numero "Nombre de membres dans le menage"
label variable hh_phone "Numero de telephone du menage (ou numero de telephone d'un membre du menage)"
label variable hh_head_name_complet "Nom et prenom du chef du menage"
label variable hh_name_complet_resp "Nom et prenom du repondant"
label variable hh_age_resp "Age du repondant"
label variable hh_gender_resp "Sexe du repondant"
label variable attend_training "Avez-vous assisté à la formation que notre équipe a organisée en [MOIS] 2024 sur l'élimination de la plante aquatique cerat"
label variable who_attended_training "Est-ce que une autre membre de ce menage a assiste a la formation que notre équipe a organisée en [MOIS] 2024 sur l'élimination de la plante aquatique cerato [REMPLACER par le nom local, naithe ?] ?"
label variable training_id "Qui a assiste a la formation (selectionnez de la liste du membres du menage)"
label variable heard_training "Avez-vous entendu parler de la formation menées par le projet ?"
label variable hh_date "Date"
label variable hh_time "Heure"

*** labels for household members - loop through all member numbers ***
*** check the data to ensure this is the maximum number of members in a household ***
forvalues i = 1/28{
	label variable hh_first_name_`i' "Prenom"
	label variable hh_name_`i' "Nom"
	label variable hh_surname_`i' "Surnom"
	label variable hh_full_name_calc_`i' "Full Name"
// UPDATE VARIALE NAME	label variable "Cette personne fait-elle toujours partie du ménage ? "
// UPDATE VARIALE NAME	label variable "Pourquoi cette personne n'est-elle pas dans le ménage ?"
// UPDATE VARIALE NAME	label variable "Y a-t-il d'autres personnes dans le ménage ?"
	label variable hh_gender_`i' "Genre"
	label variable hh_age_`i' "Age"
	label variable hh_ethnicity_`i' "Ethnicite"
	label variable hh_ethnicity_o_`i' "Autre ethnie"
	label variable hh_relation_with_`i' "Relation avec le chef du menage"
	label variable hh_relation_with_o_`i' "Autre forme de relation"
	label variable hh_education_skills_`i' "Education - Competences (chiox multiple)"
	label variable hh_education_skills_0_`i' "Education - Competences - 0 Aucun"
	label variable hh_education_skills_1_`i' "Education - Competences - 1 Peut ecrire une courte letter a sa famille"
	label variable hh_education_skills_2_`i' "Education - Competences - 2 A l'aise avec les chiffres et les calculs"
	label variable hh_education_skills_3_`i' "Education - Competences - 3 Arabisant/peut lire le Coran en arabe"
	label variable hh_education_skills_4_`i' "Education - Competences - 4 Parle couramment le wolof/pulaar"
	label variable hh_education_skills_5_`i' "Education - Competences - 5 Peut lire un journal en francais"
	label variable hh_education_level_`i' "Niveau d'education atteint"
	label variable hh_education_level_o_`i' "Autre niveau"
	label variable hh_education_year_achieve_`i' "Combien d'annees d'etudes [hh_full_name_calc] a-t-il(elle) acheve(e)"
	label variable hh_main_activity_`i' "Activite principale en dehors de la maison"
	label variable hh_main_activity_o_`i' "Autre activite"
	label variable hh_mother_live_`i' "La mere de [hh_full_name_calc] vivait-elle dans le village le jour de la naissance de [hh_full_name_calc]"
	label variable hh_relation_imam_`i' "Lien de parente de [hh_full_name_calc] avec l'Imam ou le Chef du village"
	label variable hh_presence_winter_`i' "Presence en hiver/saison des pluies"
	label variable hh_presence_dry_`i' "Presence en saison seche"
	label variable hh_active_agri_`i' "Est-il/elle un travailleur agricle actif"
	label variable hh_01_`i' "Au cours des 7 derniers jours combien d'heurs [hh_full_name_calc] a consacre aux taches menageres ou a la preparation des repas"
	label variable hh_02_`i' "Au cours des 7 derniers jours combien d'heurs [hh_full_name_calc] a consacre pour chercher de l'eau"
	label variable hh_03_`i' "Au cours des 12 derniers mois, [hh_full_name_calc] a-t-il travaille dans le cadre d'activites agricoles domestiques"
	label variable hh_04_`i' "Au cours des 7 derniers jours, combien d'heures [hh_full_name_calc] a-t-il travaille dans le cadre d'activites agricoles domestiques"
	label variable hh_05_`i' "Pendant la periode de plantation de la derniere campagne agricole, combien d'heures"
	label variable hh_06_`i' "Pendant la periode de croissance maximale de la dernière campagne agricole, combien d'heures"
	label variable hh_07_`i' "Pendant la période de recolte de la dernière campagne agricole, combien de jours"
	label variable hh_08_`i' "Au cours des 7 derniers jours, combien d'heures [hh_full_name_calc] a t-il consacre pour travailler dans un commerce"
	label variable hh_09_`i' "Au cours des 7 derniers jours, combien d'heures [hh_full_name_calc] a t-il consacre pour travailler pour une entreprise"
	label variable hh_10_`i' "Au cours des 12 derniers mois, combien d'heures par semaine en moyenne [hh_full_name_calc] a-t-il passe a moins d'un metre ou dans une source d'eau de surface"
	label variable hh_11_`i' "Quelle(s) source(s) d'eau de surface?"
	label variable hh_11_o_`i' "Autre source"
	label variable hh_12_`i' "Au cours des 12 derniers mois, pourquoi [hh_full_name_calc] a-t-il passé du temps près de (< 1 m) ou dans la/les source(s) d'eau?"
	label variable hh_12_1_`i' "Aller chercher de l'eau pour le menage"
	label variable hh_12_2_`i' "Donner de l'eau au betail"
	label variable hh_12_3_`i' "Aller chercher de l'eau pour l'agriculture"
	label variable hh_12_4_`i' "Laver des vetements"
	label variable hh_12_5_`i' "Faire la vaisselle"
	label variable hh_12_6_`i' "Recolter de la vegetation aquatique"
	label variable hh_12_7_`i' "Nager/se baigner"
	label variable hh_12_8_`i' "Jouer"
	label variable hh_12_a_`i' "Est-ce qu'il a d'autres raisons pour laquelle [hh_full_name_calc] a-t-il passe du temps pres de (< 1 m) ou dans la/les source(s) d'eau?"
	label variable hh_12_o_`i' "Autre a preciser"
	label variable hh_13_`i'_1 "Au cours des 12 derniers mois, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_12 = 1 pres de (< 1 m) ou dans la/les source(s) d'eau?"
	label variable hh_13_`i'_2 "Au cours des 12 derniers mois, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_12 = 2 pres de (< 1 m) ou dans la/les source(s) d'eau?"
	label variable hh_13_`i'_3 "Au cours des 12 derniers mois, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_12 = 3 pres de (< 1 m) ou dans la/les source(s) d'eau?"
	label variable hh_13_`i'_4 "Au cours des 12 derniers mois, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_12 = 4 pres de (< 1 m) ou dans la/les source(s) d'eau?"
	label variable hh_13_`i'_5 "Au cours des 12 derniers mois, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_12 = 5 pres de (< 1 m) ou dans la/les source(s) d'eau?"
	label variable hh_13_`i'_6 "Au cours des 12 derniers mois, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_12 = 6 pres de (< 1 m) ou dans la/les source(s) d'eau?"
	label variable hh_13_`i'_7 "Au cours des 12 derniers mois, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_12 = 7 pres de (< 1 m) ou dans la/les source(s) d'eau?"
	label variable hh_13_o_`i' "Au cours des 12 derniers mois, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a [hh_12_o] pres de (< 1 m) ou dans la/les source(s) d'eau"
	label variable hh_14_`i' "Au cours des 12 derniers mois, combien de vegetation aquatique a-t-il/elle recolte pres de (< 1 m) ou dans la/les source(s) d'eau par semaine, en moyenne (en kg)"
	label variable hh_15_`i' "Comment a-t-il utilise la vegetation aquatique"
	label variable hh_15_o_`i' "Autre a preciser"
	label variable hh_16_`i' "Au cours des 12 derniers mois combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a la production d'engrais, son achat, ou son application sur le champ"
	label variable hh_17_`i' "Au cours des 12 derniers mois combien d'heures [hh_full_name_calc] a t-il consacre a la production d'aliments pour le betail par semaine en moyenne"
	label variable hh_18_`i' "Au cours des 7 derniers jours combien d'heures [hh_full_name_calc] a-t-il passe pres de (< 1 m) ou dans une source d'eau de surface"
	label variable hh_19_`i' "Quelle(s) source(s) d'eau de surface"
	label variable hh_19_o_`i' "Autre a preciser"
	label variable hh_20_`i' "Au cours des 7 derniers jours, pourquoi [hh_full_name_calc] a-t-il passe du temps pres de (< 1 m) ou dans la/les source(s) d'eau"
	label variable hh_20_1_`i' "Aller chercher de l'eau pour le menage"
	label variable hh_20_2_`i' "Donner de l'eau au betail"
	label variable hh_20_3_`i' "Aller chercher de l'eau pour l'agriculture"	
	label variable hh_20_4_`i' "Laver des vetements"
	label variable hh_20_5_`i' "Faire la vaisselle"
	label variable hh_20_6_`i' "Recolter de la vegetation aquatique"
	label variable hh_20_7_`i' "Nager/se baigner"
	label variable hh_20_8_`i' "Jouer"
	label variable hh_20_a_`i' "Est-ce qu'il a d'autres raisons pour laquelle [hh_full_name_calc] a-t-il passe du temps pres de (< 1 m) ou dans la/les source(s) d'eau"
	label variable hh_20_o_`i' "Autre a preciser"
	label variable hh_21_`i'_1 "Au cours des 7 derniers jours, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_20 = 1 pres de (< 1 m) ou dans la/les source(s) d'eau?"
	label variable hh_21_`i'_2 "Au cours des 7 derniers jours, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_20 = 2 pres de (< 1 m) ou dans la/les source(s) d'eau?"
	label variable hh_21_`i'_3 "Au cours des 7 derniers jours, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_20 = 3 pres de (< 1 m) ou dans la/les source(s) d'eau?"
	label variable hh_21_`i'_4 "Au cours des 7 derniers jours, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_20 = 4 pres de (< 1 m) ou dans la/les source(s) d'eau?"
	label variable hh_21_`i'_5 "Au cours des 7 derniers jours, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_20 = 5 pres de (< 1 m) ou dans la/les source(s) d'eau?"
	label variable hh_21_`i'_6 "Au cours des 7 derniers jours, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_20 = 6 pres de (< 1 m) ou dans la/les source(s) d'eau?"
	label variable hh_21_`i'_7 "Au cours des 7 derniers jours, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_20 = 7 pres de (< 1 m) ou dans la/les source(s) d'eau?"
	label variable hh_21_o_`i' "Au cours des 7 derniers jours, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a [hh_20_o] pres de (< 1 m) ou dans la/les source(s) d'eau"
	label variable hh_22_`i' "Au cours des 7 derniers jours, combien de vegetation aquatique a-t-il/elle recolte pres de (< 1 m) ou dans la/les source(s) d'eau (en kg)"
	label variable hh_23_`i' "Comment a-t-il utilise la vegetation aquatique"
	label variable hh_23_1_`i' "Vendre"
	label variable hh_23_2_`i' "Engrais"
	label variable hh_23_3_`i' "Alimentation pour le betail"
	label variable hh_23_4_`i' "Matiere premiere pour le biodigesteur"
	label variable hh_23_5_`i' "Rien"
	label variable hh_23_99_`i' "Autre"
	label variable hh_23_o_`i' "Autre a preciser"
	label variable hh_24_`i' "Au cours des 7 derniers jours combien d'heures [hh_full_name_calc] a t-il consacre a la production d'engrais, son achat, ou son application sur le champ?"
	label variable hh_25_`i' "Au cours des 7 derniers jours combien d'heures [hh_full_name_calc] a t-il consacre a la production d'aliments pour le betail"
	label variable hh_26_`i' "[hh_full_name_calc] a-t-il fait ou fait-il des etudes actuellement dans une ecole formelle"
	label variable hh_27_`i' "Est ce que [hh_full_name_calc] a suivi une ecole non formelle ou une formation non-formelle"
	label variable hh_28_`i' "Quel type d'education non-formelle [hh_full_name_calc] a frequente"
	label variable hh_29_`i' "Quel est le niveau et la classe les plus eleves que [hh_full_name_calc] a reussi a l'ecole"
//	label variable hh_29_o_`i' "Autre a preciser"
	label variable hh_30_`i' "[hh_full_name_calc] a-t-il frequente une ecole au cours de la derniere annee scolaire 2022-23"
	label variable hh_31_`i' "Quel resultat [hh_full_name_calc] a-t-il obtenu au cours de l'annee 2022/2023"
	label variable hh_32_`i' "Est-ce que [hh_full_name_calc] frequente une ecole au cours de la presente annee scolaire 2023/2024"
//	label variable hh_33_`i' "En ce qui concerne les autres eleves de sa classe, pensez-vous que la performance academique de [hh_full_name_calc] est inferieure a celle de la plupart des eleves, a peu pres la meme que celle de la plupart des eleves, ou superieure a celle de la plupart des eleves"
	label variable hh_34_`i' "Quel age avait [hh_full_name_calc] quand il (elle) a cesse d'aller a l'ecole"
	label variable hh_35_`i' "Quelle est le niveau et la classe frequentee par [hh_full_name_calc] au cours de l'annee 2023/2024"
	label variable hh_36_`i' "Pensez-vous que [hh_full_name_calc] reussira son niveau scolaire declare au course de l'annee 2023/2024"
	label variable hh_37_`i' "Au cours des 12 derniers mois, [hh_full_name_calc] a-t-il deja manque plus d'une semaine consecutive d'ecole pour cause de maladie"
	label variable hh_38_`i' "Au cours des 7 derniers jours, combien de jours [hh_full_name_calc] est-il alle a l'ecole pour suivre des cours"
	label variable hh_39_`i' "Qui est la mère ou la belle-mère de cet enfant ? Sélectionnez dans la liste ou ajoutez des catégories supplémentaires : (i) décédée ou (ii) vivante mais ne résidant pas dans le ménage avec l'enfant"
	label variable hh_40_`i' "Qui est le père ou le beau-père de cet enfant ? Sélectionnez dans la liste ou ajoutez des catégories supplémentaires : (i) décédé ou (ii) vivant mais ne résidant pas dans le ménage avec l'enfant"
	label variable hh_41_`i' "Quel âge avait [NOM] quand il (elle) est entré (e) à l'école?"
	label variable hh_42_`i' "[NOM] fréquente-t-il l'école aujourd'hui ?"
	label variable hh_43_`i' "Quand [NOM] fréquente-t-il l'école aujourd'hui ?"
	label variable hh_44_`i' "L'enfant est-il à la maison ?"
	label variable hh_45_`i' "Enquêteur : Observez-vous vous-même l'enfant à la maison ?"
	label variable hh_46_`i' "Quelle est la raison principale pour laquelle l'enfant ne fréquente pas l'école aujourd'hui ?"
	label variable hh_47_`i' "Combien a été dépensé pour l'éducation de [NOM] au cours des 12 derniers mois par le ménage, la famille et les amis ?"
	label variable hh_48_`i' "[NOM] a-t-il été testé pour la bilharziose à l'école ?"
	label variable hh_49_`i' "Consentement pour la vérification de la fréquentation scolaire"	
}

*** knowledge section ***
label variable knowledge_01 "Avez-vous deja entendu parler de la bilharziose"
label variable knowledge_02 "Pouvez-vous nous dire en termes simples ce qu'est la bilharziose"
label variable knowledge_03 "Pensez-vous que la bilharziose est une maladie"
label variable knowledge_04 "Si vous pensez que la bilharziose est une maladie, pensez-vous qu'il s'agit d'une maladie grave"
label variable knowledge_05 "Quelle est la cause de la bilharziose"
label variable knowledge_05_o "Autre cause"
label variable knowledge_06 "A votre avis, comment savez-vous si une personne est atteinte de bilharziose"
label variable knowledge_06_1 "Lorsq'ils ont de la fievre"
label variable knowledge_06_2 "En cas de diarrhee"
label variable knowledge_06_3 "En cas de douleurs a l'estomac"
label variable knowledge_06_4 "En cas de sang dans les urines"
label variable knowledge_06_5 "En cas de demangeaisons"
label variable knowledge_06_6 "Je ne sais pas si c'est le cas"
label variable knowledge_07 "Savez-vous s'il existe un test a l'hopital pour detecter la bilharziose chez un individu"
label variable knowledge_08 "Si oui, lequel"
label variable knowledge_09 "Comment une personne peut-elle se proteger contre la bilharziose"
label variable knowledge_09_1 "Eviter d'uriner dans la riviere"
label variable knowledge_09_2 "Eviter de defequer dans la riviere"
label variable knowledge_09_3 "Eviter de se rendre a la riviere"
label variable knowledge_09_4 "Eviter de marcher pieds nus"
label variable knowledge_09_5 "Dormir sous une moustiquaire"
label variable knowledge_09_6 "Retirer les plantes des points d'eau"
label variable knowledge_09_99 "Autre (a preciser)"
label variable knowledge_09_o "Autre precaution"
label variable knowledge_10 "Comment peut-on contracter la bilharziose"
label variable knowledge_10_1 "En marchant pieds nus"
label variable knowledge_10_2 "En mangeant sans se lever les mains"
label variable knowledge_10_3 "En allant a la riviere"
label variable knowledge_10_4 "En buvant l'eau de la riviere"
label variable knowledge_10_5 "En se faisant piquer par des moustiques"
label variable knowledge_10_6 "Lors de rapports sexuels avec une personne infectee par la bilharziose"
label variable knowledge_10_7 "Je ne sais pas"
label variable knowledge_10_99 "Autre specification"
label variable knowledge_10_o "Autre"
label variable knowledge_11 "Pensez-vous que la bilharziose est contagieuse"
label variable knowledge_12 "Connaissez-vous l'animal qui transmet la bilharziose"
label variable knowledge_12_o "Autre animal"
label variable knowledge_13 "Pensez-vous que la bilharziose peut etre guerie sans traitement"
label variable knowledge_14 "Pensez-vous qu'il existe un medicament pour traiter la bilharziose"
label variable knowledge_15 "Connaissez-vous un traitement traditionnel pour la bilharziose"
label variable knowledge_16 "Pensez-vous que ce traitement traditionnel est efficace, qu'il soigne vraiment"
label variable knowledge_17 "Avez-vous des commentaires sur le traitement de la bilharziose"
label variable knowledge_18 "Avez-vous ete en contact avec un plan d'eau (lac, riviere, ruisseau, marais, etc.) au cours des 12 derniers mois"
label variable knowledge_19 "De quel type de plan d'eau s'agissait-il"
label variable knowledge_19_o "Autre type d'eau"
label variable knowledge_20 "Ou etes-vous entre en contact avec la masse d'eau"
label variable knowledge_20_o "Autre lieu"
label variable knowledge_21 "A quelle frequence"
label variable knowledge_22 "Quand y etes-vous alle pour la derniere fois"
label variable knowledge_23 "Quelles sont les raisons pour lesquelles vous avez ete (ou etes) en contact avec le cours d'eau"
label variable knowledge_23_1 "Pour les taches menageres (vaisselle, lessive, etc.)"
label variable knowledge_23_2 "Pour aller chercher de l'eau"
label variable knowledge_23_3 "Pour sa baigner"
label variable knowledge_23_4 "Jouer"
label variable knowledge_23_5 "Pecher"
label variable knowledge_23_6 "Pour mes activites agricoles"
label variable knowledge_23_99 "Pour d'autres raisons"
label variable knowledge_23_o "Autre raison"

*** health module indiviudals - this is for member index 1 ***
*** verify maximum number in data set ****
forvalues i=1/28 {
    label variable health_5_2_`i' "Est-ce que [health-name] est tombe malade au cours des 12 derniers mois"
	label variable health_5_3_`i' "De quel type de maladie ou de blessure a-t-il/elle souffert"
	label variable health_5_3_1_`i' "Paludisme"
	label variable health_5_3_2_`i' "Bilharzoise"
	label variable health_5_3_3_`i' "Diarrhee"
	label variable health_5_3_4_`i' "Blessures"
	label variable health_5_3_5_`i' "Problemes dentaires"
	label variable health_5_3_6_`i' "Problemes de peau"
	label variable health_5_3_7_`i' "Problemes oculaires"
	label variable health_5_3_8_`i' "Problemes de gorge"
	label variable health_5_3_9_`i' "Maux d'estomac"
	label variable health_5_3_10_`i' "Fatigue"
	label variable health_5_3_11_`i' "IST"
	label variable health_5_3_12_`i' "trachome"
	label variable health_5_3_13_`i' "onchocercose"
	label variable health_5_3_14_`i' "filaroise lymphatique"
	label variable health_5_3_99_`i' "autres (a preciser)"
	label variable health_5_3_o_`i' "Autre maladie"
	label variable health_5_4_`i' "Combien de jours a-t-il/elle manque au travail/a l'ecole en raison d'une maladie ou d'une blessure au cours du dernier mois"
	label variable health_5_5_`i' "A-t-il/elle recu des medicaments pour le traitement de la schistosomiase au cours des 12 derniers mois"
	label variable health_5_6_`i' "Cette personne a-t-elle deja ete diagnostiquee avec la schistosomiase"
	label variable health_5_7_`i' "Cette personne a-t-elle ete affectee par la schistosomiase au cours des 12 derniers mois"
	label variable health_5_7_1_`i' "Cette personne a-t-elle eu de l'urine avec une coloration rose au cours des 12 derniers mois ?"
	label variable health_5_8_`i' "Cette personne a-t-elle eu du sang dans ses urines au cours des 12 derniers mois"
	label variable health_5_9_`i' "Cette personne a-t-elle eu du sang dans ses selles au cours des 12 derniers mois"
	label variable health_5_10_`i' "Avez-vous consulte quelqu'un pour une maladie au cours des 12 derniers mois"
	label variable health_5_11_`i' "Quel type de service de sante/professionnel de sante cette personne a-t-elle consulte en premier lieu"
	label variable health_5_11_o_`i' "Autre type de service de sante"
	label variable health_5_12_`i' "Quelle est la distance en km qui vous separe de ce service ou de ce professionnel de sante"
}

*** labels for health modules at the household level ***
label variable health_5_13 "Avez-vous beneficie de campagnes de sensibilisation sur la schistosomiase au cours des cinq dernieres annees"
label variable health_5_14_a "Manifestation de la bilharzoise"
label variable health_5_14_b "Pratique pour eviter la bilharzose"
label variable health_5_14_c "Mesurer a prendre pour le traitement de la bilharziose"

*** Assets module ***
label variable list_actifs_1 "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Fer a repasser (electrique/non-eletrique)"
label variable list_actifs_2 "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Machine a coudre"
label variable list_actifs_3 "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Television"
label variable list_actifs_4 "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Voiture"
label variable list_actifs_5 "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Refridgerateur"
label variable list_actifs_6 "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Radio"
label variable list_actifs_7 "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Montre/horloge"
label variable list_actifs_8 "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Lit ou matelas"
label variable list_actifs_9 "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Velo"
label variable list_actifs_10 "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Moto"
label variable list_actifs_11 "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Table"
label variable list_actifs_12 "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Chaise"
label variable list_actifs_13 "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Climatiseur"
label variable list_actifs_14 "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Ordinateur"
label variable list_actifs_15 "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Telephone portable"
label variable list_actifs_16 "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Maison"
label variable _actif_number_1 "Combien de [actifs-name] est-ce que vous avez"
label variable _actif_number_2 "Combien de [actifs-name] est-ce que vous avez"
label variable _actif_number_3 "Combien de [actifs-name] est-ce que vous avez"
label variable _actif_number_4 "Combien de [actifs-name] est-ce que vous avez"
label variable _actif_number_5 "Combien de [actifs-name] est-ce que vous avez"
label variable _actif_number_6 "Combien de [actifs-name] est-ce que vous avez"
label variable _actif_number_7 "Combien de [actifs-name] est-ce que vous avez"
label variable _actif_number_8 "Combien de [actifs-name] est-ce que vous avez"
label variable _actif_number_9 "Combien de [actifs-name] est-ce que vous avez"
label variable _actif_number_10 "Combien de [actifs-name] est-ce que vous avez"
label variable _actif_number_11 "Combien de [actifs-name] est-ce que vous avez"
label variable _actif_number_12 "Combien de [actifs-name] est-ce que vous avez"
label variable _actif_number_13 "Combien de [actifs-name] est-ce que vous avez"
label variable _actif_number_14 "Combien de [actifs-name] est-ce que vous avez"
label variable list_actifs_o "Est-ce qu'il y a un autre actif que l'on a pas pris en compte"
label variable actifs_o "Autre Actifs"
label variable actifs_o_int "Combien de [actifs_o] est-ce que vous avez"
label variable list_agri_equip_1 "Votre foyer dispose-t-il aujourd'hui de l'un des equipements suivants? En etat de marche - Charrue"
label variable list_agri_equip_2 "Votre foyer dispose-t-il aujourd'hui de l'un des equipements suivants? En etat de marche - Arara"
label variable list_agri_equip_3 "Votre foyer dispose-t-il aujourd'hui de l'un des equipements suivants? En etat de marche - Animaux de traits"
label variable list_agri_equip_4 "Votre foyer dispose-t-il aujourd'hui de l'un des equipements suivants? En etat de marche - Charrette"
label variable list_agri_equip_5 "Votre foyer dispose-t-il aujourd'hui de l'un des equipements suivants? En etat de marche - Tracteur"
label variable list_agri_equip_6 "Votre foyer dispose-t-il aujourd'hui de l'un des equipements suivants? En etat de marche - Pulverisateur"
label variable list_agri_equip_7 "Votre foyer dispose-t-il aujourd'hui de l'un des equipements suivants? En etat de marche - Groupe Motos Pompes (GMP)"
label variable list_agri_equip_8 "Votre foyer dispose-t-il aujourd'hui de l'un des equipements suivants? En etat de marche - Houes"
label variable list_agri_equip_9 "Votre foyer dispose-t-il aujourd'hui de l'un des equipements suivants? En etat de marche - Hilaires"
label variable list_agri_equip_10 "Votre foyer dispose-t-il aujourd'hui de l'un des equipements suivants? En etat de marche - Daba/faucille"
label variable list_agri_equip_11 "Votre foyer dispose-t-il aujourd'hui de l'un des equipements suivants? En etat de marche - Semoir"
label variable list_agri_equip_12 "Votre foyer dispose-t-il aujourd'hui de l'un des equipements suivants? En etat de marche - Kadiandou"
label variable list_agri_equip_13 "Votre foyer dispose-t-il aujourd'hui de l'un des equipements suivants? En etat de marche - Fanting"
label variable list_agri_equip_14 "Votre foyer dispose-t-il aujourd'hui de l'un des equipements suivants? En etat de marche - Panneaux solaires"
label variable _agri_number_1 "Combien de [agri-name] avez-vous eu" 
label variable _agri_number_2 "Combien de [agri-name] avez-vous eu" 
label variable _agri_number_3 "Combien de [agri-name] avez-vous eu" 
label variable _agri_number_4 "Combien de [agri-name] avez-vous eu" 
label variable _agri_number_5 "Combien de [agri-name] avez-vous eu" 
label variable _agri_number_6 "Combien de [agri-name] avez-vous eu" 
label variable _agri_number_7 "Combien de [agri-name] avez-vous eu" 
label variable _agri_number_8 "Combien de [agri-name] avez-vous eu" 
label variable _agri_number_9 "Combien de [agri-name] avez-vous eu" 
label variable _agri_number_10 "Combien de [agri-name] avez-vous eu" 
label variable list_agri_equip_o "Est-ce qu'il y a un autre equipement agricole que l'on n'a pas pris en compte"
label variable list_agri_equip_o_t "Autre liste"
label variable list_agri_equip_int "Combien de [list_agri_equip_o_t] avez-vous eu"

*** Agriculture Inputs Module ***
label variable agri_6_5 "Avez-vous loue la maison ou etes-vous le proprietaire"
label variable agri_6_6 "Combien de pieces separees le menage possede-t-il"
label variable agri_6_7 "Un membre de votre menage a-t-il un compte bancaire"
label variable agri_6_8 "Un membre de votre menage participe-t-il a des mecanismes informels d'epargne et de credit (par exemple, des associations d'epargne et de credit ou des groupes rotatifs d'epargne et de credit)"
label variable agri_6_9 "Un membre de votre menage fait-il partie d'un groupe de femmes du village"
label variable agri_6_10 "Avez-vous un compte d'argent mobile (ex. Orange Money, Wave, Tigo Cash, Freemoney, K-PAYE)"
label variable agri_6_11 "Si vous aviez besoin de 250 000 FCFA d'ici la semaine prochaine (pour une urgence medicale ou une autre dépense imprevue), seriez-vous en mesure de les obtenir"
label variable agri_6_12 "Comment pourriez-vous obtenir cet argent (reponse a choix multiples)"
label variable agri_6_12_1 "Emprunt bancaire"
label variable agri_6_12_2 "Emprunter sur le compte epargne/pret du village (tontine, groupe de preteurs individuels, etc.)"
label variable agri_6_12_3 "Emprunter aupres de voisins, d'amis ou de parents"
label variable agri_6_12_4 "Utiliser son propre compte d'epargne"
label variable agri_6_12_5 "Vendre des recoltes ou du betail"
label variable agri_6_12_6 "Vendre d'autres biens ou proprietes"
label variable agri_6_12_7 "Argent de poche/maison"
label variable agri_6_12_99 " Autre (veuillez preciser)"
label variable agri_6_12_o "Autre possibilite pour avoir l'argent"
label variable agri_6_14 "Est-ce qu'au moins un membre du ménage a cultivé de la terre (y compris des cultures pérennes), qu'elle lui appartienne ou non, au cours de la dernière saison de culture"
label variable agri_6_15 "Combien de parcelles a l'interieur des champs cultives par le menage"

*** parcel questions ****
*** verify maximum in dataset ***
forvalues i=1/4 {
	label variable agri_6_16_`i' "Ordre de numeration du champ"
	label variable agri_6_17_`i' "Numero de la parcelle dans le champ"
	label variable agri_6_18_`i' "Quel est le mode de gestion de la parcelle"
	label variable agri_6_19_`i' "Quel est le numero d'ordre de la personne qui cultive la parcelle (utiliser les identifiants de la section B sur les caracteristiques demographiques du menage)"
	label variable agri_6_20_`i' "Quelle est la principale culture pratiquee sur cette parcelle au cours de la derniere periode de vegetation"
	label variable agri_6_20_o_`i' "Autre culture principale"
	label variable agri_6_21_`i' "Quelle est la superficie de la parcelle selon l'exploitant ? (Indiquer la superficie en hectares ou en metres carres avec deux decimales)"
	label variable agri_6_22_`i' "Unite"
	label variable agri_6_23_`i' "Quel est le mode d'occupation de cette parcelle"
	label variable agri_6_23_o_`i' "Autre mode d'occupation de cette parcelle"
	label variable agri_6_24_`i' "Quel est le numero d'ordre du proprietaire de la parcelle"
	label variable agri_6_25_`i' "Quel est le mode d'acquisition de cette parcelle"
	label variable agri_6_25_o_`i' "Autre mode d'acquisition de cetter parcelle"
	label variable agri_6_26_`i' "Disposez-vous d'un document legal (titre, acte, certificat, etc.) confirmant votre propriete sur cette parcelle"
	label variable agri_6_26_o_`i' "Autre document legal"
	label variable agri_6_27_`i' "Quels sont les membres du menage figurant sur ce document legal"
	label variable agri_6_27_1_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 1"
	label variable agri_6_27_2_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 2"
	label variable agri_6_27_3_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 3"
	label variable agri_6_27_4_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 4"
	label variable agri_6_27_5_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 5"
	label variable agri_6_27_6_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 6"
	label variable agri_6_27_7_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 7"
	label variable agri_6_27_8_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 8"
	label variable agri_6_27_9_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 9"
	label variable agri_6_27_10_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 10"
	label variable agri_6_27_11_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 11"
	label variable agri_6_27_12_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 12"
	label variable agri_6_27_13_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 13"
	label variable agri_6_27_14_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 14"
	label variable agri_6_27_15_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 15"
	label variable agri_6_27_16_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 16"
	label variable agri_6_27_17_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 17"
	label variable agri_6_27_18_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 18"
	label variable agri_6_27_19_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 19"
	label variable agri_6_27_20_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 20"
	label variable agri_6_27_21_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 21"
	label variable agri_6_27_22_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 22"
	label variable agri_6_27_23_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 23"
	label variable agri_6_27_24_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 24"
	label variable agri_6_27_25_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 25"
	label variable agri_6_27_26_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 26"
	label variable agri_6_27_27_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 27"
	label variable agri_6_27_28_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 28"
	label variable agri_6_27_29_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 29"
	label variable agri_6_27_30_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 30"
	label variable agri_6_27_31_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 31"
	label variable agri_6_27_32_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 32"
	label variable agri_6_27_33_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 33"
	label variable agri_6_27_34_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 34"
	label variable agri_6_27_35_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 35"
	label variable agri_6_27_36_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 36"
	label variable agri_6_27_37_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 37"
	label variable agri_6_27_38_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 38"
	label variable agri_6_27_39_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 39"
	label variable agri_6_27_40_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 40"
	label variable agri_6_27_41_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 41"
	label variable agri_6_27_42_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 42"
	label variable agri_6_27_43_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 43"
	label variable agri_6_27_44_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 44"
	label variable agri_6_27_45_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 45"
	label variable agri_6_27_46_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 46"
	label variable agri_6_27_47_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 47"
	label variable agri_6_27_48_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 48"
	label variable agri_6_27_49_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 49"
	label variable agri_6_27_50_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 50"
	label variable agri_6_27_51_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 51"
	label variable agri_6_27_52_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 52"
	label variable agri_6_27_53_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 53"
	label variable agri_6_27_54_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 54"
	label variable agri_6_27_55_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 55"
	label variable agri_6_27_56_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 56"
	label variable agri_6_27_57_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 57"
	label variable agri_6_27_58_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 58"
	label variable agri_6_27_59_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 59"
	label variable agri_6_27_60_`i' "Quels sont les membres du menage figurant sur ce document legal - membre 60"
	label variable agri_6_28_`i' "Pensez-vous qu'il existe un risque de perdre les droits associes a cette parcelle dans les 5 prochaines annees"
	label variable agri_6_29_`i' "Quelle est la principale preoccupation"
	label variable agri_6_29_o_`i' "Autre type de preoccupation"
	label variable agri_6_30_`i' "Avez-vous utilise du fumier animal sur cette parcelle au cours de cette campagne agricole"
	label variable agri_6_31_`i' "Quelle a ete la principale methode d'acquisition de ce fumier"
	label variable agri_6_31_o_`i' "Autre methode d'acquisition de l'animale"
	label variable agri_6_32_`i' "Quelle quantite de fumier avez-vous appliquee sur la parcelle"
	label variable agri_6_33_`i' "Code Unite"
	label variable agri_6_33_o_`i' "Autre type de quantite"
	label variable agri_6_34_comp_`i' "Avez-vous utilise du compost sur cette parcelle durant cette campagne"
	label variable agri_6_34_`i' "Avez-vous utilise des dechets menagers et autres sur cette parcelle au cours de cette campagne agricole"
	label variable agri_6_35_`i' "Combien de fois avez-vous epandu des dechets menagers sur cette parcelle au cours de cette campagne agricole"
	label variable agri_6_36_`i' "Avez-vous utilise des engrais inorganiques/chimiques sur cette parcelle au cours de cette campagne agricole"
	label variable agri_6_37_`i' "Combien de fois avez-vous epandu des engrais inorganiques sur cette parcelle au cours de cette campagne agricole"
	label variable agri_6_38_a_`i' "Quelle quantite d'Uree avez-vous utilisee"
	label variable agri_6_38_a_code_`i' "Unite"
	label variable agri_6_38_a_code_o_`i' "Autre code"
	label variable agri_6_39_a_`i' "Quelle quantite de Phosphates avez-vous utilisee"
	label variable agri_6_39_a_code_`i' "Unite"
	label variable agri_6_39_a_code_o_`i' "Autre code"
	label variable agri_6_40_a_`i' "Quelle quantite de NPK/Formule unique avez-vous utilisee"
	label variable agri_6_40_a_code_`i' "Unite"
	label variable agri_6_40_a_code_o_`i' "Autre code"
	label variable agri_6_41_a_`i' "Quelle quantite d'autres engrais chimiques avez-vous utilisee"
	label variable agri_6_41_a_code_`i' "Unite"
	label variable agri_6_41_a_code_o_`i' "Autre code"
}

*** Agriculture Production Module ***
*** Cereals ***
forvalues i=1/6{
	label variable cereals_consumption_`i' "Votre menage a t'il cultive du [cereals-name] durant cetter periode"
	label variable cereals_01_`i' "Superficie en hecatre de [cereals-name]"
	label variable cereals_02_`i' "Production totale en 2023 (kg) de [cereals-name]"
	label variable cereals_03_`i' "Quantite autoconsommee en 2023 de [cereals-name]"
	label variable cereals_04_`i' "Quantite vendue en kg en 2023 de [cereals-name]"
	label variable cereals_05_`i' "Prix de vente actuel en FCFA/kg de [cereals-name]"
}

*** Farines et tubercules ***
forvalues i=1/6{
	label variable farine_tubercules_consumption_`i' "Votre menage a t'il cultive du [farines_tubercules-name] durant cetter periode"
	label variable farines_01_`i' "Superficie en hecatre de [farines_tubercules-name]"
	label variable farines_02_`i' "Production totale en 2023 (kg) de [farines_tubercules-name]"
	label variable farines_03_`i' "Quantite autoconsommee en 2023 de [farines_tubercules-name]"
	label variable farines_04_`i' "Quantite vendue en kg en 2023 de [farines_tubercules-name]"
	label variable farines_05_`i' "Prix de vente actuel en FCFA/kg de [farines_tubercules-name]"
}

*** legumes ***
forvalues i=1/6{
	label variable legumes_consumption_`i' "Votre menage a t'il cultive du [legumes-name] durant cetter periode"
	label variable legumes_01_`i' "Superficie en hecatre de [legumes-name]"
	label variable legumes_02_`i' "Production totale en 2023 (kg) de [legumes-name]"
	label variable legumes_03_`i' "Quantite autoconsommee en 2023 de [legumes-name]"
	label variable legumes_04_`i' "Quantite vendue en kg en 2023 de [legumes-name]"
	label variable legumes_05_`i' "Prix de vente actuel en FCFA/kg de [legumes-name]"
}

*** Farines et tubercules ***
forvalues i=1/5{
	label variable legumineuses_consumption_`i' "Votre menage a t'il cultive du [legumineuses-name] durant cetter periode"
	label variable legumineuses_01_`i' "Superficie en hecatre de [legumineuses-name]"
	label variable legumineuses_02_`i' "Production totale en 2023 (kg) de [legumineuses-name]"
	label variable legumineuses_03_`i' "Quantite autoconsommee en 2023 de [legumineuses-name]"
	label variable legumineuses_04_`i' "Quantite vendue en kg en 2023 de [legumineuses-name]"
	label variable legumineuses_05_`i' "Prix de vente actuel en FCFA/kg de [legumineuses-name]"
}

*** aquatiques and other production ***
label variable aquatique_consumption_1 "Votre menage a t'il cultive du [aquatique-name] durant cette periode"
label variable aquatique_01_1 "Superficie en hecatre de [aquatique-name]"
label variable aquatique_02_1 "Production totale en 2023 (kg) de [aquatique-name]"
label variable aquatique_03_1 "Quantite autoconsommee en 2023 de [aquatique-name]"
label variable aquatique_04_1 "Quantite vendue en kg en 2023 de [aquatique-name]"
label variable aquatique_05_1 "Prix de vente actuel en FCFA/kg de [aquatique-name]"
label variable autre_culture_yesno "Est-ce qu'il y a un autre type de culture"
label variable autre_culture "Autre type de culture"
label variable o_culture_01 "Superficie en hectare de [autre-culture]"
label variable o_culture_02 "Production totale en 2023 (kg) de [autre-culture]"
label variable o_culture_03 "Quantite autoconsommee en 2023 de [autre-culture]"
label variable o_culture_04 "Qunatite vendue en kg en 2023 de [autre-culture]"
label variable o_culture_05 "Prix de vente actuel en FCFA/kg de [autre-culture]"

*** Food consumption module ***
label variable food01 "Dans les douze (12) derniers mois, combien de mois a dure la periode de soudure"
label variable food02 "Avez-vous (ou un membre de votre famille) exerce un travail remunere pendant cette période pour faire face a la periode de soudure"
label variable food03 "Avez-vous vendu des biens pour subvenir a vos besoins pendant cette periode"
label variable food05 "Le betail"
label variable food06 "Les charrettes"
label variable food07 "Les outils de production"
label variable food08 "Biens materiels"
label variable food09 "Puiser dans d'autres ressources (par exemple, un magasin)"
label variable food10 "Autres, veuillez preciser"
label variable food11 "Des membres du ménage ont-ils migre pendant cette periode en raison de la periode de soudure"
label variable food12 "Avez-vous saute des repas pendant la journee en raison de la periode de soudure"

*** Household Income module ***
label variable agri_income_01 "Avez-vous (ou un membre de votre menage) effectue un travail remunere au cours des 12 derniers mois"
label variable agri_income_02 "De quel type de travail s'agissait-il (s'agissaient-ils)"
label variable agri_income_02_o "Autre type de travail"
label variable agri_income_03 "Quelle est la duree de ce travail (frequence) dans les derniers 12 mois"
label variable agri_income_04 "Unite de temps"
label variable agri_income_05 "Montant recu en nature et/ou en especes (FCFA) pour ce travail"
label variable agri_income_06 "Quel a ete le montant total (en FCFA) des depenses engagees pour ce travail (transport, nourriture, etc.)"
label variable species "Quelles especes les proprietaires possedent-ils"
label variable species_1 "Bovins"
label variable species_2 "Mouton"
label variable species_3 "Chevre"
label variable species_4 "Cheval (equide)"
label variable species_5 "Ane"
label variable species_6 "Animaux de trait"
label variable species_7 "Porcs"
label variable species_8 "Volaille"

*** Livestock ownership questions ***
*** verify maximum in the data ***
forvalues i=1/6 {
	label variable agri_income_07_`i' "Nombre de tetes de [species-name] actuellement"
	label variable agri_income_08_`i' "Nombre de tetes de [species-name] vendues (cette annee)"
	label variable agri_income_09_`i' " Principales raisons de la vente de [species-name]"
	label variable agri_income_09_o_`i' "Autre raison de vendre"
	label variable agri_income_10_`i' "Prix moyen par tete de [species-name] en FCFA"
}

label variable agri_income_07_o "Nombre de tetes de [species_o] actuellement"
label variable agri_income_08_o "Nombre de tetes de [species_o] vendues (cette annee)"
label variable agri_income_09_o_o "Principales raisons de la vente de [species_o]"
label variable agri_income_09_o_o_o "Autre raison de vendre"
label variable agri_income_10_o "Prix moyen par tete de [species_o] en FCFA"
label variable animals_sales "Revenues de l'elevage"
label variable animals_sales_1 "Bovins"
label variable animals_sales_2 "Mouton"
label variable animals_sales_3 "Chevre"
label variable animals_sales_4 "Cheval (equide)"
label variable animals_sales_5 "Ane"
label variable animals_sales_6 "Animaux de trait"
label variable animals_sales_7 "Porcs"
label variable animals_sales_8 "Volaille"
label variable animals_sales_o "Est-ce qu'il y a d'autres animaux vendus par le menage"
label variable animals_sales_t "Autre animal vendu par le menage"

*** Livestock/animal product sales quesitons ***
*** Verify maximum value in data ***
forvalues i=1/5 {
label variable agri_income_11_`i' "Nombre de tetes de [sale_animales-name] vendus"
label variable agri_income_12_`i' "Montant total en FCFA pour la vente de [sale_animales-name]"
label variable agri_income_13_`i' "Nature des produits provenant de [sale_animales-name] vendus"
label variable agri_income_13_1_`i' "Lait"
label variable agri_income_13_2_`i' "Le beurre"
label variable agri_income_13_3_`i' "Le fumier"
label variable agri_income_13_99_`i' "Autres"
label variable agri_income_14_`i' "Montant en FCFA du total de vente pour les produits provenant de [sale_animales-name]"
label variable agri_income_13_autre_`i' "Autre nature"
}

label variable agri_income_11_o "Nombre de tetes de [animals_sales_t] vendus"
label variable agri_income_12_o "Montant total en FCFA pour la vente de [animals_sales_t]"
label variable agri_income_13_o "Nature des produits provenant de [animals_sales_t] vendus"
label variable agri_income_13_o_1 "Lait"
label variable agri_income_13_o_2 "Le beurre"
label variable agri_income_13_o_3 "Le fumier"
label variable agri_income_13_o_99 "Autres"
label variable agri_income_14_o "Montant en FCFA du total de vente pour les produits provenant de [animals_sales_t]"
label variable agri_income_13_o_t "Autre nature"
label variable agri_income_15 "Avez-vous des employes pour vos activites agricoles"
label variable agri_income_16 "Si oui, veuillez en preciser le nombre"
***DROPPED VAR ***
*label variable agri_income_17 "Ces employes sont-ils remuneres"
label variable agri_income_18 "Comment sont-ils payes"
label variable agri_income_18_o "Autre type de paiement"
label variable agri_income_19 "Quel est le montant total de la remuneration dans les 12 derniers mois pour tous travailleurs (argent plus en nature)"
label variable agri_income_20 "Type d'activite non agricole"
label variable agri_income_20_1 "Peche"
label variable agri_income_20_2 "Sylviculture"
label variable agri_income_20_3 "Artisanat"
label variable agri_income_20_4 "Commerce"
label variable agri_income_20_5 "Services"
label variable agri_income_20_6 "Emploi salaire"
label variable agri_income_20_7 "Transport"
label variable agri_income_20_8 "Recolte"
label variable agri_income_20_t "Est-ce qu'il y a d'autres activites non agricoles"
label variable agri_income_20_o "Autre type d'activites non agricoles"

*** Revenu non agricole types ***
*** verify maximum in data ***
forvalues i=1/3{
	label variable agri_income_21_h_`i' "Nombre de personnes impliquees dans [agri_income_20-name] (Homme)"
	label variable agri_income_21_f_`i' "Nombre de personnes impliquees dans [agri_income_20-name] (Femme)"
	label variable agri_income_22_`i' "Frequence de [agri_income_20-name] par an (nombre de mois)"
	label variable agri_income_23_`i' "Revenus par frequence (par [agri_income_22] mois)"
	*** DROPPED VAR ***
	*label variable agri_income_24_`i' "Revenue annuel total"
}

label variable agri_income_21_h_o "Nombre de personnes impliquees dans [agri_income_20_o] (Homme)"
label variable agri_income_21_f_o "Nombre de personnes impliquees dans [agri_income_20_o] (Femme)"
label variable agri_income_22_o "Frequence de [agri_income_20_o] par an (nombre de mois)" 
label variable agri_income_23_o "Revenus par frequence (par [agri_income_22_o] mois)"
label variable agri_income_25 "Avez-vous des employes pour vos activites non agricoles"
label variable agri_income_26 "Si oui, veuillez en preciser le nombre"
*** DROPPED VAR ***
*label variable agri_income_27 "Ces employes sont-ils remuneres"
label variable agri_income_28 "Comment sont-ils payes"
label variable agri_income_28_1 "En nature"
label variable agri_income_28_1 "En argent"
label variable agri_income_28_3 "Autre"
label variable agri_income_28_o "Autre mode de paiement"
label variable agri_income_29 "Quel est le montant total de la remuneration dans les 12 derniers mois pour tous travailleurs (argent plus en nature)"
label variable agri_income_30 "Certains membres de votre menage migrent-ils a l'interieur ou à l'exterieur du pays"
label variable agri_income_31 "Si oui, ou sont-ils ? (Choix multiple possible s'il y a plusieurs personnes dans une autre zone)"
label variable agri_income_31_1 "Un autre region du Senegal"
label variable agri_income_31_2 "Autres pays d'Afrique"
label variable agri_income_31_3 "Europe"
label variable agri_income_31_4 "Amerique"
label variable agri_income_31_5 "Asie"
label variable agri_income_31_6 "Autre regions"
label variable agri_income_31_o "Autre zone de migration"
label variable agri_income_32 "Si oui, envoient-ils de l'argent pour les besoins du menage"
label variable agri_income_33 "Si oui, combien avez-vous recu au total au cours des 12 derniers mois"
label variable agri_income_34 "Avez-vous (ou un membre de votre menage) contracte un prêt au cours des douze (12) derniers mois"
label variable agri_income_35 "Si non, pourquoi ne l'avez-vous pas fait"
label variable agri_income_name "Choisissez les membres de votre menage qui ont contracte un pret"

*** Credit roster questions ***
*** verify maximum in data ***
forvalues i=1/4{
	label variable agri_income_36_`i' "Quel montant de ce pret [credit_ask-name] a t'il contracte"
	label variable agri_income_37_`i' "Aupres de qui [credit_ask-name] a t'il contracte ce pret"
	label variable agri_income_38_`i' "Quel est le montant de ce pret que [credit_ask-name] deja rembourse"
	label variable agri_income_39_`i' "Quel est le montant de ce pret que [credit_ask-name] reste a payer"
}

label variable agri_loan_name "Choisissez les membres de votre menage qui ont prete de l'argent a d'autres personnes"

*** Loan roster questions - right now only one in the data set but my need a loop ***
label variable agri_income_41_1 "Quel est le montant que [loan-name] a prete a d'autres personnes"
label variable agri_income_42_1 "Quel est le montant prete par [loan-name] a d'autres personnes deja paye"
label variable agri_income_43_1 "Quel est le montant prete par [loan-name] a d'autres personnes encore du"
*** DROPPED VAR ***
*label variable agri_income_44_1 "Quelle est la valeur nette des transferts effectués au cours des 12 derniers mois"

label variable product_divers "Quelles sont les depenses globales du menage au cours des quatre derniers mois, les sources de financement ou les pratiques que vous developpez pour repondre a ces besoins, et qui sont les responsables de ces besoins de financement au sein du menage"
label variable product_divers_1 "Alimentation (produits alimentaires)"
label variable product_divers_2 "La sante"
label variable product_divers_3 "L'education"
label variable product_divers_4 "Eau/Electricite pour le menage"
label variable product_divers_5 "Logement/transport"
label variable product_divers_6 "Depenses pour les appareils menagers et le mobilier"
label variable product_divers_7 "Autres investissements non agricoles"
label variable product_divers_8 "Depenses de construction, de reparation et de modification"
label variable product_divers_9 "Acquisition de moyens de transport"
label variable product_divers_10 "Depenses pour l'habillement et les chaussures du menage"
label variable product_divers_11 "Depenses de reparation et d'achat de divers articles menagers"
label variable product_divers_12 "Depenses pour les ceremonies menageres/acquisition de bijoux et de pierres precieuses"
label variable product_divers_13 "Autres depenses (cadeaux, dons, aides, tabac, alcool, taxes, amendes, assurances)"
label variable product_divers_14 "Frais de telephone/Wifi"
label variable product_divers_99 "Autres depenses"

*** product questions ***
*** verify maximum in data ***
forvalues i=1/11{
	label variable agri_income_45_`i' "Montant en [product-name]"
	label variable agri_income_46_`i' "Source de finacement (choix multiples)"
	label variable agri_income_46_1_`i' "Le credit"
	label variable agri_income_46_2_`i' "Revenus propres"
	label variable agri_income_46_3_`i' "Dons"
	label variable agri_income_46_4_`i' "Autres"
	label variable agri_income_46_o_`i' "Autre source de financement"
}

label variable expenses_goods "Types de dépenses"
label variable expenses_goods_1 "Engrais"
label variable expenses_goods_2 "Aliments pour le betail"
label variable expenses_goods_t "Est-ce qu'il y a d'autre type de depense"
label variable expenses_goods_o "Autre a preciser"
label variable agri_income_47_1 "Montant (KG) de [goods-name]"
label variable agri_income_48_1 "Qunatite (FCFA)"
label variable agri_income_47_2 "Montant (KG) de [goods-name]"
label variable agri_income_48_2 "Qunatite (FCFA)"
label variable agri_income_47_o "Montant (KG) de [expenses_goods_o]"
label variable agri_income_48_o "Qunatite (FCFA)"

*** Living standards section ***
label variable living_01 "Quelle est la principale source d'approvisionnement en eau potable"
label variable living_01_o "Autre source d'approvisionnement en eau"
label variable living_02 "L'eau utilisee est-elle traitee dans le menage"
label variable living_03 "Si oui, comment l'eau est-elle traitee"
label variable living_03_o "Autre type de traitement de l'eau"
label variable living_04 "Quel est le principal type de toilettes utilise par votre menage"
label variable living_04_o "Autre type de toilettes"
label variable living_05 "Quel est le principal combustible utilise pour la cuisine"
label variable living_05_o "Autre type de combustible"
label variable living_06 "Quel est le principal combustible utilise pour l'eclairage"
label variable living_06_o "Autre type de combustible utilise pour l'eclairage"

*** Beleifs section ***
label variable beliefs_01 "Quelle est la probabilite que vous contractiez la bilharziose au cours des 12 prochains mois"
label variable beliefs_02 "Quelle est la probabilite qu'un membre de votre menage contracte la bilharziose au cours des 12 prochains mois"
label variable beliefs_03 "Quelle est la probabilite qu'un enfant choisi au hasard dans votre village, age de 5 a 14 ans, contracte la bilharziose au cours des 12 prochains mois"
label variable beliefs_04 "Dans quelle mesure etes-vous d'accord avec l'affirmation suivante : Les terres de ce village devraient appartenir a la communaute et non a des individus"
label variable beliefs_05 "Dans quelle mesure etes-vous d'accord avec l'affirmation suivante : Les sources d'eau de ce village devraient appartenir a la communaute et non aux individus"
label variable beliefs_06 "Dans quelle mesure etes-vous d'accord avec l'affirmation suivante : Si je travaille sur mes propres terres, j'ai le droit d'utiliser les produits que j'ai obtenus grace a mon travail."
label variable beliefs_07 "Dans quelle mesure etes-vous d'accord avec l'affirmation suivante : Si je travaille sur des terres appartenant a la communaute, j'ai le droit d'utiliser les produits que j'ai obtenus par mon travail."
label variable beliefs_08 "Dans quelle mesure etes-vous d'accord avec l'affirmation suivante : Si je peche dans une source d'eau appartenant a la communaute, j'ai le droit d'utiliser les produits que j'ai obtenus par mon travail."
label variable beliefs_09 "Dans quelle mesure êtes-vous d'accord avec l'affirmation suivante : Si je recolte des produits dans une source d'eau appartenant a la communaute, j'ai le droit d'utiliser les produits que j'ai obtenus par mon travail."

*** Public Goods Games ***
/*
label variable game_intro "Avant d'entrer dans la maison, lancez une piece de monnaie. Notez le resultat ici"
label variable game_01 "Y a-t-il des questions"
label variable game_02 "Veuillez indiquer si vous etes pret a jouer a ce jeu"
label variable consent_game_1 "Pourriez-vous s'il vous plaît reconnaitre que vous avez recu 1200 FCFA"
label variable montant_02 "Montant verse par le repondant pour le jeu A"
label variable game_03 "Y a-t-il des questions"
label variable montant_05 "Montant verse par le repondant pour le jeu B"
label variable montant_07 "Si le montant verse par le repondant pour le jeu B est inferieur a 200 : Pourriez-vous s'il vous plait reconnaitre que vous avez recu 1000 FCFA"
label variable montant_08 "Si le montant verse par le repondant pour le jeu B est d'au moins a 200 : Pourriez-vous s'il vous plait reconnaitre que vous avez recu 1200 FCFA"
label variable face_01 "Y a-t-il des questions"
label variable face_02 "Veuillez indiquer si vous etes pret a jouer a ce jeu"
label variable face_04 "Montant verse par le repondant pour le jeu B"
label variable face_06 "Si le montant verse par le répondant pour le jeu B est inferieur a 200 : Pourriez-vous s'il vous plait reconnaitre que vous avez recu 1000 FCFA"
label variable face_07 "Si le montant verse par le répondant pour le jeu B est d'au moins a 200 : Pourriez-vous s'il vous plait reconnaitre que vous avez reçu 1200 FCFA"
label variable face_09 "Y a-t-il des questions"
label variable face_10 "Veuillez indiquer si, compte tenu de ces instructions, vous etes pret a jouer a ce jeu"
label variable face_11 "Pourriez-vous s'il vous plait reconnaitre que vous avez recu 1200 FCFA"
label variable face_13 "Montant verse par le repondant pour le jeu A"
*/

*** Enumerator Observations ***
label variable enum_01 "D'autres personnes que les repondants ont-elles suivi l'entretien"
label variable enum_02 "Combien de personnes environ ont observe l'entretien"
label variable enum_03 "Quels sont les materiaux principaux utilises pour le toit de la maison ou dort le chef de famille"
label variable enum_03_o "Autre type de materiaux pour le toit"
label variable enum_04 "Quels sont les materiaux principaux utilises pour les murs de la maison ou dort le chef de famille"
label variable enum_04_o "Autre type de materiaux pour les murs"
label variable enum_05 "S'il a ete observe, quels sont les materiaux principaux du sol principal de la maison ou dort le chef de famille"
label variable enum_05_o "Autre type de materiaux pour le sol"
label variable enum_06 "Comment evaluez-vous la comprehension globale des questions par le repondant"
label variable enum_07 "Veuillez indiquer les parties difficiles"
label variable enum_08 "Veuillez donner votre avis sur le revenu du menage"

 
*** Data Checks ***

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

*** check individual identificaiton data for missing values *** 
forvalues i=1/55 {

    preserve 

	*** drop no consent households *** 
	drop if consent == 0 
	
	gen ind_var = 0
    replace ind_var = 1 if hh_first_name_`i' == "."  
 	replace ind_var = 0 if _household_roster_count < `i'
   
    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Missing value"
	generate issue_variable_name = "hh_first_name_`i'"
	rename hh_first_name_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$household_roster\Issue_Household_hh_first_name_`i'.dta", replace
    }
  
    restore
}

forvalues i=1/55 {

    preserve 

	*** drop no consent households *** 
	drop if consent == 0 
	
	gen ind_var = 0
    replace ind_var = 1 if hh_name_`i' == "."  
 	replace ind_var = 0 if _household_roster_count < `i'
   
    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Missing value"
	generate issue_variable_name = "hh_name_`i'"
	rename hh_name_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$household_roster\Issue_Household_hh_name_`i'.dta", replace
    }
  
    restore
}

forvalues i=1/55 {

    preserve 

	*** drop no consent households *** 
	drop if consent == 0 
	 
	tostring(hh_surname_`i'), replace 
	
	gen ind_var = 0
    replace ind_var = 1 if hh_surname_`i' == "."  
 	replace ind_var = 0 if _household_roster_count < `i'
   
    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Missing value"
	generate issue_variable_name = "hh_surname_`i'"
	rename hh_surname_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$household_roster\Issue_Household_hh_surname_`i'.dta", replace
    }
  
    restore
}

***	i.	Age needs to be between 0 and 90 ***
*** I realized these checks were picking up the household that did not give consent ***
*** So for the initial checks without dependencies I added a drop them ***
forvalues i=1/55 {

    preserve 

	*** drop no consent households *** 
	drop if consent == 0 
	
    local hh_age hh_age_`i'
	*** generate indicator variable ***
	gen ind_var = 0
    replace ind_var = 1  if `hh_age' < 0 | `hh_age' > 90    
 	replace ind_var = 0 if _household_roster_count < `i'
   
    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Unreasonable value"
	generate issue_variable_name = "hh_age_`i'"
	rename `hh_age' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$household_roster\Issue_Household_`hh_age'.dta", replace
    }
  
    restore
}
  
***	ii.	Hh_education_level should be less than two when age is less than 18 ***

forvalues i=1/55 {

	preserve 

	*** drop no consent households *** 
	drop if consent == 0 
	
    local hh_age hh_age_`i'
	local hh_education_level hh_education_level_`i'
    gen ind_var = 0
    keep if `hh_age' < 18 
	drop if `hh_education_level' == 99
	replace ind_var = 1 if `hh_education_level' > 2 
	replace ind_var = 0 if _household_roster_count < `i'
  	
	* keep and add variables to export *
	keep if ind_var == 1
    generate issue = "Unreasonable value" 
	generate issue_variable_name = "hh_education_level_`i'"
	rename `hh_education_level' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	
    if _N > 0 {
        save "$household_roster\Issue_Household_`hh_education_level'.dta", replace
    }
	restore
}


***	iii. Hh_education_year_acheive should be less than age ***

forvalues i=1/55 {

	preserve 
	
	*** drop no consent households *** 
	drop if consent == 0 
		
    local hh_age hh_age_`i'
	local hh_education_level hh_education_year_achieve_`i'
    gen ind_var = 0
    replace ind_var = 1 if `hh_education_level ' > `hh_age' & `hh_education_level' != .
	replace ind_var = 0 if _household_roster_count < `i'

	* keep and add variables to export *
	keep if ind_var == 1 
    generate issue = "Unreasonable value" 
	generate issue_variable_name = "hh_education_year_achieve_`i'"
	rename hh_education_year_achieve_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue

	
    if _N > 0 {
        save "$household_roster\Issue_Household_`hh_education_level'.dta", replace
    }
	restore
}

*** check for missing values for hh_03 *** 
forvalues i=1/55 {

    preserve 

	*** drop no consent households *** 
	drop if consent == 0 
	
	gen ind_var = 0
    replace ind_var = 1 if hh_03_`i' == .  
 	replace ind_var = 0 if _household_roster_count < `i'
   
    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Missing value"
	generate issue_variable_name = "hh_03_`i'"
	rename hh_03_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	
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


forvalues i = 1/55 {
	preserve
	
	*** drop no consent households *** 
	drop if consent == 0 
	
	gen ind_var = 0 
	replace ind_var = 1 if hh_01_`i' < 0 & hh_01_`i' != -9
	replace ind_var = 1 if hh_01_`i' > 168
	replace ind_var = 0 if _household_roster_count < `i'
	keep if ind_var == 1 
	
	generate issue = "Unreasonable value"
	generate issue_variable_name = "hh_01_`i'"
	rename hh_01_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue

    
	if _N > 0 {
		save "$household_roster\Issue_Household_hh_01_`i'_unreasonable.dta", replace
	}
    
	restore
}

forvalues i = 1/55 {
	preserve
	
	*** drop no consent households *** 
	drop if consent == 0 
	
	
	gen ind_var = 0 
	replace ind_var = 1 if hh_02_`i' < 0 & hh_02_`i' != -9
	replace ind_var = 1 if hh_02_`i' > 168
	replace ind_var = 0 if _household_roster_count < `i'
	keep if ind_var == 1 
	
	generate issue = "Unreasonable value"
	generate issue_variable_name = "hh_02_`i'"
	rename hh_02_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue

    
	if _N > 0 {
		save "$household_roster\Issue_Household_hh_02_`i'_unreasonable.dta", replace
	}
    
	restore
}

forvalues i = 1/55 {
	preserve

	*** drop no consent households *** 
	drop if consent == 0 
	
	gen ind_var = 0 
	replace ind_var = 1 if hh_08_`i' < 0 & hh_08_`i' != -9
	replace ind_var = 1 if hh_08_`i' > 168
	replace ind_var = 0 if _household_roster_count < `i'
	keep if ind_var == 1 
	
	generate issue = "Unreasonable value"
	generate issue_variable_name = "hh_08_`i'"
	rename hh_08_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue

    
	if _N > 0 {
		save "$household_roster\Issue_Household_hh_08_`i'_unreasonable.dta", replace
	}
    
	restore
}

forvalues i = 1/55 {
	preserve

	*** drop no consent households *** 
	drop if consent == 0 
	
	gen ind_var = 0 
	replace ind_var = 1 if hh_09_`i' < 0 & hh_09_`i' != -9
	replace ind_var = 1 if hh_09_`i' > 168
	replace ind_var = 0 if _household_roster_count < `i'
	keep if ind_var == 1 
	
	generate issue = "Unreasonable value"
	generate issue_variable_name = "hh_09_`i'"
	rename hh_09_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue

    
	if _N > 0 {
		save "$household_roster\Issue_Household_hh_09_`i'_unreasonable.dta", replace
	}
    
	restore
}

forvalues i = 1/55 {
	preserve

	*** drop no consent households *** 
	drop if consent == 0 
	
	gen ind_var = 0 
	replace ind_var = 1 if hh_10_`i' < 0 & hh_10_`i' != -9
	replace ind_var = 1 if 	hh_10_`i' > 168
	replace ind_var = 0 if _household_roster_count < `i'
	keep if ind_var == 1 
	
	generate issue = "Unreasonable value"
	generate issue_variable_name = "hh_10_`i'"
	rename hh_10_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue

    
	if _N > 0 {
		save "$household_roster\Issue_Household_hh_10_`i'_unreasonable.dta", replace
	}
    
	restore
}

***	ix.	The sum of all values for each individual's hh_13 should be less than hh_10 ***


forvalues i = 1/55 {
	
		
	preserve

	*** drop no consent households *** 
	drop if consent == 0 
	
	egen hh_13_`i'_total = rowtotal(hh_13_`i'_1  hh_13_`i'_2  hh_13_`i'_3 hh_13_`i'_4  hh_13_`i'_5 hh_13_`i'_6  hh_13_`i'_7)
	
	gen ind_var = 0 
	replace ind_var = 1 if hh_13_`i'_total > hh_10_`i' 
	replace ind_var = 0 if _household_roster_count < `i'	
	keep if ind_var == 1 
	
	generate issue = "Unreasonable values'"
	generate issue_variable_name = "hh_13_`i'_total"
	
	rename hh_13_`i'_total print_issue
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	  if _N > 0 {
        save "$household_roster\Issue_hh_13_`i'_total_unreasonable.dta", replace
    }
    
	restore
          }
	
***	x.	Hh_21 plus hh_21_o should NOT be greater than hh_18 ***
*** I mixed up the instructions - Molly ***

forvalues i = 1/55 {

    preserve 

	*** drop no consent households *** 
	drop if consent == 0 

	
	egen hh_21_`i'_total = rowtotal ( hh_21_o_`i' hh_21_`i'_1  hh_21_`i'_2  hh_21_`i'_3  hh_21_`i'_4  hh_21_`i'_5  hh_21_`i'_6  hh_21_`i'_7 )
        
    *Check if sum of hh_21_i_j and hh_21_o_i is more than sum of hh_18_i
	generate ind_var = 0
	replace ind_var = 1 if hh_21_`i'_total > hh_18_`i'
	replace ind_var = 0 if _household_roster_count < `i'
	keep if ind_var == 1 
     
	generate issue = "Missing" 
   	generate issue_variable_name = "Issue found: Sum of hh_21_`i' and hh_21_o_`i' is more than hh_18_`i'"
	rename  hh_21_`i'_total print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	
	if _N > 0 {
        save "$household_roster\Issue_Household_sum_less_than_hh_18_`i'.dta", replace
    }
	  restore
    }
  

******************************************* KNOWLEDGE SECTION ***************************************************

***	i.	knowledge_10 must select at least one and no more than seven ***
preserve

	*** drop no consent households *** 
	drop if consent == 0 

	egen knowledge_10_count = rowtotal(knowledge_10_1 knowledge_10_2 knowledge_10_3 knowledge_10_4 knowledge_10_5 knowledge_10_6 knowledge_10_7  knowledge_10_99)
	keep if knowledge_10_count < 0 & knowledge_10_count > 7
	
	gen issue = "Unreasonable value'"
	generate issue_variable_name = "knowledge_10"
	rename knowledge_10_count print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	
 if _N > 0 {
        save "$knowledge\Issue_knowledge_10_count_unreasonable.dta", replace
    }
restore


***	ii.	knowledge_17 should be text ***
*** DROPPED VAR ***
*** decided to skip this check - more of a follow up question ***


*preserve

	* Include line below if there's a string value 
	*tostring knowledge_17, replace 
	
	*keep if missing(knowledge_17) & length(trim(knowledge_17)) == 0
	*generate issue = "Missing"
	*generate issue_variable_name = "Missing knowledge_17"
	*rename knowledge_17 print_issue 
	*(tostring(print_issue), replace
	*keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	
	*if _N > 0 {
    *    save "$knowledge\Issue_knowledge_17_unreasonable.dta", replace
    *}
	
*restore




**************************************** AGRICULTURE SECTION   **********************************************

*** i.	_actif_number should be between 0 and 100 ***	


forvalues i = 1/14 {
preserve

	*** drop no consent households *** 
	drop if consent == 0 

*for _actif
    local var1 _actif_number_`i' 
    keep if `var1' < 0 | `var1' > 100 
	keep if actifsid_`i' != .

	generate issue = "Missing"
	generate issue_variable_name = "`var1'"
	rename `var1' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	
	if _N > 0 {
        save "$agriculture_inputs\Issue_agriculture_`var1'", replace
    }
	
restore
}

***  iii.	_agri_number should be between 0 and 100 ***	

forvalues i = 1/10 {
preserve
	*** drop no consent households *** 
	drop if consent == 0 
	
    local var _agri_number_`i'
    keep if `var' < 0 | `var' > 100
	keep if agriindex_`i' != .
	generate issue = "Unreasonable value"
	generate issue_variable_name = "`var1'"
	rename `var' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	
if _N > 0 {
		save "$agriculture_inputs\Issue_agriculture_`var1'", replace
}
restore

}

***	iv.	agri_6_6 should be between 0 and 50 ***	

preserve
	*** drop no consent households *** 
	drop if consent == 0 

    keep if agri_6_6 < 0 | agri_6_6 > 50
	generate issue = "Unreasonable value"
	generate issue_variable_name = "`var1'"
	rename agri_6_6 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue

if _N > 0 {
		save "$agriculture_inputs\Issue_agriculture_agri_6_6", replace
}
restore

************************************ FOOD CONSUMPTION SECTION ****************************************** 

***	i.	food01 should be between 0 and 12 or -9 ***	

preserve
    
	*** drop no consent households *** 
	drop if consent == 0 
    
	gen ind_var = 0
	replace ind_var = 1 if food01 < 0 & food01 != -9
	replace ind_var = 0 if food01 > 12
	keep if ind_var == 1
	generate issue = "Unreasonable value"
	generate issue_variable_name = "`food01'"
	rename food01 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue

if _N > 0 {
		save "$food_consumption\Issue_food01", replace
}

restore

***	ii.	ii.	food10 should be answered when food03 = 1, should be text ***
*** I missed this conditional - Molly *** 	

preserve

	keep if food03 == 1
	keep if food10 == "."
	generate issue = "Missing"
	generate issue_variable_name = "`food10'"
	rename food10 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
if _N > 0 {
		save "$food_consumption\Issue_food10", replace
}

restore



*************************************	HOUSEHOLD INCOME SECTION ************************************************

*** i.	agri_income_07 should be between 0 and 500 ***	
*** ii.	agri_income_08 should be between 0 and 500 ***	
*** For each of these, only some households grow crops ***
*** So we should loop through numbers to not pick up extra values *** 
	
forvalues i = 1/6 {
	preserve
     
    keep if agri_income_07_`i' < 0 | agri_income_07_`i' > 500
	drop if speciesindex_`i' == .
	generate issue = "Issue found: agri_income_07_`i' value not in bound (0<x<500)"
	generate issue_variable_name = "agri_income_07_`i'"
	rename agri_income_07_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$income\Issue_agri_income_07_o_unreasonable", replace
}

restore

forvalues i = 1/6 {
	preserve
     
    keep if agri_income_08_`i' < 0 | agri_income_08_`i' > 500
	drop if speciesindex_`i' == .
	generate issue = "Issue found: agri_income_08_`i' value not in bound (0<x<500)"
	generate issue_variable_name = "agri_income_08_`i'"
	rename agri_income_08_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$income\Issue_agri_income_08_o_unreasonable", replace
}

restore

*** iii.	Agri_income_12 should be between 0 and 100000000 *** 

forvalues i = 1/5 {
	preserve
     
    keep if agri_income_12_`i' < 0 | agri_income_12_`i' > 100000000
	drop if sale_animalesindex_`i' == .
	generate issue = "Issue found: unreasonable value"
	generate issue_variable_name = "agri_income_12_`i'"
	rename agri_income_12_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$income\Issue_agri_income_12_o_unreasonable", replace
}

    restore


*** iv.	agri_income_14 should be between 0 and 100000000 ***

forvalues i = 1/5 {
	preserve
     
    keep if agri_income_14_`i' < 0 | agri_income_14_`i' > 100000000
	drop if sale_animalesindex_`i' == .
	generate issue = "Issue found: unreasonable value"
	generate issue_variable_name = "agri_income_14_`i'"
	rename agri_income_14_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$income\Issue_agri_income_20_unreasonable.dta", replace 
	}

	restore
	

***	v.	agri_income_21_h should be between 0 and 50 ***	
***	vi.	agri_income_21_f should be between 0 and 50 ***	

foreach var of varlist agri_income_21_h_o agri_income_21_h_1 agri_income_21_h_2 agri_income_21_h_3 agri_income_21_h_4 agri_income_21_f_1 agri_income_21_f_2 agri_income_21_f_3 agri_income_21_f_4 {
	
preserve
    
	keep if `var' < 0 | `var' > 50 & `var' != .
	
	generate issue = "Unreasonable value"
	generate issue_variable_name = "`var'"
	rename `var' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$income\Issue_`var'", replace
}

    restore
}

***	vii. agri_income_22 should be less than 12 ***	

foreach var of varlist agri_income_22_o agri_income_22_1 agri_income_22_2 agri_income_22_3 agri_income_22_4 {
preserve
    keep if `var'  != . & `var' > 12
	generate issue = "Unreasonable value"
	generate issue_variable_name = "`var'"
	rename `var' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$income\Issue_`var'", replace
}
 restore
}

*** viii.	agri_income_23 should be between 0 and 1000000000 *** 

forvalues i = 1/4 {
	preserve
     
    keep if agri_income_23_`i' < 0 | agri_income_23_`i' > 1000000000
	drop if agri_income_20index_`i' == .
	generate issue = "Issue found: unreasonable value"
	generate issue_variable_name = "agri_income_23_`i'"
	rename agri_income_23_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$income\Issue_agri_income_23_`i'_unreasonable", replace
}

    restore
}

	preserve
     
    keep if agri_income_23_o < 0 | agri_income_23_o > 1000000000
	drop if agri_income_20_t != 1
	generate issue = "Issue found: unreasonable value"
	generate issue_variable_name = "agri_income_23_o"
	rename agri_income_23_o print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$income\Issue_agri_income_23_o_unreasonable", replace
}

    restore

*** ix.	agri_income_45 should be between 0 and 1000000000 ***	
*** Add step to get rid of missings when the household doesn't grow the product ***

forvalues i = 1/11 {
preserve
    local var agri_income_45_`i'
    keep if `var' < 0 | `var' > 1000000000
	drop if productindex_`i' == . 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "`var'"
	rename `var' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$income\Issue_`var'", replace
}
restore
}

*** check to make sure agri_income_46 is not missing *** 
forvalues i = 1/11 {
preserve
    local var agri_income_46_`i'
	tostring(`var'), replace 
    keep if `var' == "."
	drop if productindex_`i' == . 
	generate issue = "Missing"
	generate issue_variable_name = "`var'"
	rename `var' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	generate issue = "Unreasonable value"
	generate issue_variable_name = "agri_income_47_`i'"
	rename agri_income_47_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$income\Issue_agri_income_47_`i'", replace
	}
	restore 	
}

forvalues i = 1/2 {
    preserve
  
    keep if  agri_income_48_`i' < 0 | agri_income_48_`i' > 1000000000
	drop if goodsinex_`i' == . 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "agri_income_48_`i'"
	rename agri_income_48_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$income\Issue_agri_income_47_o", replace
	}
	
restore 	

preserve 

keep if expenses_goods_t == 1 

keep if  agri_income_48_o < 0 | agri_income_48_o > 1000000000
generate issue = "Unreasonable value"
generate issue_variable_name = "agri_income_48_o"
rename agri_income_48_o print_issue 
tostring(print_issue), replace
keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$income\Issue_agri_income_48_o", replace
	}
	
restore 

*** check to make sure expenses_goods and expsenses_goods_t are not missing *** 
preserve
    
	*** drop no consent households *** 
	drop if consent == 0 
    
	gen ind_var = 0
	replace ind_var = 1 if expenses_goods == "." 
	keep if ind_var == 1
	generate issue = "Missing"
	generate issue_variable_name = "expenses_goods"
	rename expenses_goods print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
if _N > 0 {
		save "$income\Issue_expenses_goods", replace
}

restore

preserve
    
	*** drop no consent households *** 
	drop if consent == 0 
    
	gen ind_var = 0
	replace ind_var = 1 if expenses_goods_t == . 
	keep if ind_var == 1
	generate issue = "Missing"
	generate issue_variable_name = "expenses_goods_t"
	rename expenses_goods_t print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue

if _N > 0 {
		save "$income\Issue_expenses_goods_t", replace
}

restore

****************************************** PUBLIC GOODS GAME ***********************************

***	i.	montant_02 should be less than 1200 ***
***	ii.	face_13 should be less than 1200 ***

foreach var of varlist montant_02 face_13  {
preserve
    keep if `var' != . & `var' > 1200
	generate issue = "Unreasonable value"
	generate issue_variable_name = "`var'"
	rename `var' print_issue 
	tostring(print_issue), replace
	if _N > 0 {
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
		save "$public_goods\Issue_`var'", replace
}
restore
}


***	iii. montant_05 should be less than 1000 ***
***	iv.	face_04 should be less 1000 ***

foreach var of varlist montant_05 face_04 {
preserve

	keep if `var' != . & `var' > 1000
	generate issue = "Unreasonable value"
	generate issue_variable_name = "`var'"
	rename `var' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$public_goods\Issue_`var'", replace
}
restore
}

***  4.	QUESTIONS WITH DEPENDENCIES
***	a.	starting information ***
***	i.	sup_text should be answered when sup = -777, response should be text ***

preserve
 
	gen ind_var = 0
	tostring(sup), replace
	
    replace ind_var = 1 if sup == "-777" & missing(sup_txt)
	keep if ind_var == 1 
	
	generate issue = "Missing" 
	generate issue_variable_name = "sup_txt"
	rename sup_txt print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$village_observations\Issue_sup_txt_missing", replace
}
restore


***	ii.	enqu_text should be answered when enqu = -777, response should be text 
**# Bookmark #4 - verify if changing enqu_txt to a string is OK

preserve 
	gen ind_var = 0
	tostring(enqu), replace
	tostring(enqu_txt), replace
	
	
    replace ind_var = 1 if enqu == "-777" & missing(enqu_txt) 
	keep if ind_var == 1 
	generate issue_variable_name = "enqu_txt"
	rename enqu_txt print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$village_observations\Issue_enqu_txt_missing", replace
}
restore


**************************************** HOUSEHOLD ROSTER SECTION ***********************************************

***	i.	hh_ethnicity_o should be answered when hh_ethnicity = 99, response should be text ***


forvalues i = 1/55 {
preserve
    local hh_ethnicity hh_ethnicity_`i'
	local hh_ethnicity_o hh_ethnicity_o_`i'
	
	gen ind_var = 0
    replace ind_var = 1 if `hh_ethnicity' == 99 & missing(`hh_ethnicity_o') 
		
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "`hh_ethnicity_o'"
	rename `hh_ethnicity_o' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_`hh_ethnicity_o'_missing", replace
}
restore

}


***	ii.	hh_releation_with_o should be answered when hh_relation_with = 12 or hh_relation_with = 13, response should be text ***
*** add check to make sure there are that many household members ***


forvalues i = 1/55 {
preserve
    local hh_relation_with hh_relation_with_`i'
	local hh_relation_with_o hh_relation_with_o_`i'
	
	gen ind_var = 0
	keep if `hh_relation_with' == 12 | `hh_relation_with' == 13 
	replace ind_var = 1 if missing(`hh_relation_with_o') 
	replace ind_var = 0 if _household_roster_count < `i'
	keep if ind_var == 1 
	
		
	generate issue = "Missing"
	generate issue_variable_name = "`hh_relation_with_o'"
	rename `hh_relation_with_o' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_`hh_relation_with_o'_missing", replace
}
restore

}


***	iii.	hh_education_level_o should be answered when hh_education_level = 99, response should be text ***

forvalues i = 1/55 {
preserve
	local hh_education_level hh_education_level_`i'
    local hh_education_level_o hh_education_level_o_`i'
	
	gen ind_var = 0
    replace ind_var = 1 if `hh_education_level' == 99 &  missing(`hh_education_level_o') 
	keep if ind_var == 1 
		
	generate issue = "Missing"
	generate issue_variable_name = "`hh_education_level_o'"
	rename `hh_education_level_o' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_`hh_education_level_o'_missing", replace
}
restore

}


***	iv.	hh_main_activity_o should be answered when hh_main_activity = 99, response should be text ***

forvalues i = 1/55 {
preserve
	local hh_main_activity hh_main_activity_`i'
    local hh_main_activity_o hh_main_activity_o_`i'
	
	gen ind_var = 0
    replace ind_var = 1 if `hh_main_activity' == 99 &  missing(`hh_main_activity_o') 
	keep if ind_var == 1 
		
	generate issue = "Missing"
	generate issue_variable_name = "`hh_main_activity_o'"
	rename `hh_main_activity_o' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_`hh_main_activity_o'_missing", replace
}
restore

}


***	v.	hh_04 should be answered when hh_03 = 1, should be between 0 and 168 or -9 ***

forvalues i = 1/55 {
preserve
	local hh_04 hh_04_`i'
    local hh_03 hh_03_`i'
	
	gen ind_var = 0
    keep if `hh_03' == 1 
	replace ind_var = 1 if `hh_04' > 168
	replace ind_var = 1 if `hh_04' < 0 & `hh_04' != -9
	keep if ind_var == 1 

		
	generate issue = "Unreasonable value"
	generate issue_variable_name = "`hh_04'"
	rename `hh_04' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_hh_04_`i'", replace
}
restore

}


*** vi.	hh_05 should be answered when hh_03 = 1, should be between 0 and 168 or -9 ***


forvalues i = 1/55 {
preserve
	local hh_05 hh_05_`i'
    local hh_03 hh_03_`i'
	
	gen ind_var = 0
    keep if `hh_03' == 1 
	replace ind_var = 1 if  `hh_05' > 168 
	replace ind_var = 1 if `hh_05' < 0 & `hh_05' != -9
	keep if ind_var == 1 

		
	generate issue = "Unreasonable value"
	generate issue_variable_name = "`hh_05'"
	rename `hh_05' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_hh_05_`i'", replace
}
restore

}


***	vii. hh_06 should be answered when hh_03 = 1, should be between 0 and 168 or -9 ***

forvalues i = 1/55 {
preserve
	local hh_06 hh_06_`i'
    local hh_03 hh_03_`i'
	
	gen ind_var = 0    
	keep if `hh_03' == 1 
	replace ind_var = 1 if `hh_06' > 168
	replace ind_var =1 if `hh_06' < 0 & `hh_06' != -9
	keep if ind_var == 1 

		
	generate issue = "Unreasonable value"
	generate issue_variable_name = "`hh_06'"
	rename `hh_06' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_hh_06_`i'", replace
}
restore

}

***	vii. hh_07 should be answered when hh_03 = 1, should be between 0 and 168 or -9 ***

forvalues i = 1/55 {
preserve
	local hh_07 hh_07_`i'
    local hh_03 hh_03_`i'
	
	gen ind_var = 0    
	keep if `hh_03' == 1 
	replace ind_var = 1 if `hh_07' > 168
	replace ind_var =1 if `hh_07' < 0 & `hh_07' != -9
	keep if ind_var == 1 

		
	generate issue = "Unreasonable value"
	generate issue_variable_name = "`hh_07'"
	rename `hh_07' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_hh_07_`i'", replace
}
restore

}

*** ix.	hh_11 should be answered when hh_10 is greater than 0 ***

forvalues i = 1/55 {
preserve
	local hh_11 hh_11_`i'
    local hh_10 hh_10_`i'
	
	gen ind_var = 0
    replace ind_var = 1 if `hh_10' > 0 & `hh_10' != . & `hh_11' == .
	keep if ind_var == 1 

		
	generate issue = "Missing"
	generate issue_variable_name = "`hh_11'"
	rename `hh_11' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_hh_11_`i'", replace
}
restore

}


***	x.	hh_11_o should be answered when hh_11 = 99 , should be text ***


forvalues i = 1/55 {
preserve	
    local hh_11 hh_11_`i'
	local hh_11_o hh_11_o_`i'
	
	gen ind_var = 0
    replace ind_var = 1 if `hh_11' == 99 & missing(`hh_11_o') 
	keep if ind_var == 1 

		
	generate issue = "Missing"
	generate issue_variable_name = "`hh_11_o'"
	rename `hh_11_o' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_hh_11_o_`i'", replace
}
restore

}


*** xi.	hh_12 should be answered when hh_10 is greater than 0 ***
**# Bookmark #1 again a double nested loopy loop 
*** So this is a SurveyCTO quirk - we only need to check if hh_12_`i' ***
*** is not missing, all the others are generated by SurveyCTO ***


forvalues i = 1/55 {
    preserve
    local hh_10 hh_10_`i'
    
	tostring(hh_12_`i'), replace 
    gen ind_var = 0  
	replace ind_var = 1 if `hh_10' > 0 & `hh_10' != . & hh_12_`i' == "."
    
    
	keep if ind_var == 1 
    generate issue = "Issue found: missing hh_12 value"
	generate issue_variable_name = "hh_12_`i'"
	rename hh_12_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_hh_12_`i'", replace
}
restore

}


***	xii. hh_12_a should be answered when hh_10 is greater than 0 ***

forvalues i = 1/55 {
preserve	
    local hh_12_a hh_12_a_`i'
	local hh_10 hh_10_`i'
	
	gen ind_var = 0
    replace ind_var = 1 if `hh_10' > 0 & `hh_10' != . & `hh_12_a' == .
	
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "`hh_12_a'"
	rename `hh_12_a' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_hh_12_a_`i'", replace
}
restore

}


***	xiii.	hh_12_o should be answered when hh_12_a = 1, should be text ***

forvalues i = 1/55 {
preserve	
    local hh_12_a hh_12_a_`i'
	local hh_12_o hh_12_o_`i'
	
	tostring(`hh_12_o'), replace 
	
	gen ind_var = 0
    keep if `hh_12_a' == 1
	replace ind_var = 1 if missing(`hh_12_o')
	
	keep if ind_var == 1 	
	generate issue = "Missing"
	generate issue_variable_name = "`hh_12_o'"
	rename `hh_12_o' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_hh_12_o_`i'", replace
}
restore

}



**# Bookmark # double nested loop - just want you to look it over so it's acutally working (and if you change something please let me know so I can see where I went wrong!)
*** xiv.	hh_13 should be answered when hh_10 is greater than 0, should be between 0 and 168 or -9 *** 
*** I decided to break out the double nested loop to see what is going on ***
*** The questions are for each activity in the water and should be checked ***
*** in separate files for unreasonable values individually for presentation *** 


forvalues i = 1/55 {
    preserve
    local hh_10 hh_10_`i'
    
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_hh_13_`i'_1_unreasonable", replace
}
restore

}

forvalues i = 1/55 {
    preserve
    local hh_10 hh_10_`i'
    
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_hh_13_`i'_2_unreasonable", replace
}
restore

}

forvalues i = 1/55 {
    preserve
    local hh_10 hh_10_`i'
    
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_hh_13_`i'_3_unreasonable", replace
}
restore

}

forvalues i = 1/55 {
    preserve
    local hh_10 hh_10_`i'
    
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_hh_13_`i'_4_unreasonable", replace
}
restore

}

forvalues i = 1/55 {
    preserve
    local hh_10 hh_10_`i'
    
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_hh_13_`i'_5_unreasonable", replace
}
restore

}

forvalues i = 1/55 {
    preserve
    local hh_10 hh_10_`i'
    
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_hh_13_`i'_6_unreasonable", replace
}
restore

}

forvalues i = 1/55 {
    preserve
    local hh_10 hh_10_`i'
    
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_hh_13_`i'_7_unreasonable", replace
}
restore

}

***	xv.	hh_13_o should be answered when hh_12_a = 1, should be between 0 and 168 or -9 ***


forvalues i = 1/55 {
preserve
	local hh_12_a hh_12_a_`i'
    local hh_13_o hh_13_o_`i'
	
	gen ind_var = 0
	keep if `hh_12_a' == 1
    replace ind_var = 1 if `hh_13_o' > 168
	replace ind_var = 1 if `hh_13_o' < 0 & `hh_13_o' != -9
	keep if ind_var == 1	
	
	generate issue = "Unreasonable value"
	generate issue_variable_name = "`hh_13_o'"
	rename `hh_13_o' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_`hh_13_o_`i''", replace
}
restore

}

***	xvi.	hh_14 should be answered when hh_10 is greater than 0 and hh_12 = 6 , should be between 0 and 5000000 or -9 ***
*** Another SurveyCTO quirk I didn't explain, to check hh_12 = 6, we can check ***
*** the indicator that hh_12_6 = 1 *** 



forvalues i = 1/55 {
	
    preserve	
    local hh_14 hh_14_`i'
    local hh_12 hh_12_6_`i' 
    local hh_10 hh_10_`i'
    
    gen ind_var = 0
	keep if `hh_10' > 0 & `hh_10' != . & `hh_12' == 1 
    replace ind_var = 1 if `hh_14' > 5000000
	replace ind_var = 1 if `hh_14' < 0 & `hh_14' != -9
	keep if ind_var == 1	
	
    generate issue = "Missing"
    generate issue_variable_name = "`hh_14'"
	rename `hh_14' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_hh_14_`i'", replace
}
restore

}
***	xvii.	hh_15 should be answered when hh_10 is greater than 0 and hh_12 = 6 


forvalues i = 1/55 {
	
    preserve	
    local hh_15 hh_15_`i'
    local hh_12 hh_12_6_`i' 
    local hh_10 hh_10_`i'
    
    gen ind_var = 0
	keep if `hh_10' > 0 & `hh_10' != . & `hh_12' == 6 
    replace ind_var = 1 if `hh_15' == .
	keep if ind_var == 1
	
    generate issue = "Missing"
    generate issue_variable_name = "`hh_15'"
	rename `hh_15' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_`hh_15'", replace
}
restore

}

*** xviii.	hh_15_o should be answered when hh_15 = 99, should be text ***

forvalues i = 1/55 {
	
    preserve	
    
	keep if hh_15_`i' == 99

	tostring(hh_15_o_`i'), replace 
	
    gen ind_var = 0
    replace ind_var = 1 if hh_15_o_`i' == "."
	
	keep if ind_var == 1
    generate issue = "Issue found: missing hh_15_o_`i' value"
    generate issue_variable_name = "hh_15_o_`i'"
	rename hh_15_o_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_hh_15_o_`i'", replace
}
restore

}

***	xix.	hh_16 should be answered when hh_10 is greater than 0, should be between 0 and 168 or -9  

forvalues i = 1/55 {
preserve
	local hh_16 hh_16_`i'
    local hh_10 hh_10_`i'
	
	gen ind_var = 0
    keep if  `hh_10' > 0 & `hh_10' != . 
	replace ind_var = 1 if `hh_16' > 168
	replace ind_var = 1 if `hh_16' < 0 & `hh_16' != -9
	keep if ind_var == 1	
	
	generate issue = "Unreasonable value"
	generate issue_variable_name = "`hh_16'"
	rename `hh_16' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_`hh_16'", replace
}
restore

}

*** xx.	hh_17 should be answered when hh_10 is greater than 0, should be between 0 and 168 and -9  

forvalues i = 1/55 {
	
preserve
	local hh_17 hh_17_`i'
    local hh_10 hh_10_`i'
	
	gen ind_var = 0
    keep if `hh_10' > 0 & `hh_10' != . 
    replace ind_var = 1 if  `hh_17' > 168
	replace ind_var = 1 if `hh_17' < 0 & `hh_17' == -9
	keep if ind_var == 1	
	
	generate issue = "Unreasonable value"
	generate issue_variable_name = "`hh_17'"
	rename `hh_17' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_`hh_17'", replace
}
restore

}


*** xxi. hh_18 should be answered when hh_10 is greater than 0, should be between 168 and -9  


forvalues i = 1/55 {
preserve
	local hh_18 hh_18_`i'
    local hh_10 hh_10_`i'
	
	gen ind_var = 0
	keep if `hh_10' > 0 & `hh_10' != . 
	replace ind_var = 1 if `hh_18' >168
	replace ind_var = 1 if `hh_18' < 0 & `hh_18' != -9
	keep if ind_var == 1
		
	generate issue = "Unreasonable value"
	generate issue_variable_name = "`hh_18'"
	rename `hh_18' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_`hh_18'", replace
}
restore

}


***	xxii. hh_19 should be answered when hh_10 is greater than 0 and hh_18 is greater than 0 ***


forvalues i = 1/55 {
preserve
	local hh_19 hh_19_`i'
	local hh_18 hh_18_`i'
    local hh_10 hh_10_`i'
	
	gen ind_var = 0
    keep if `hh_10' > 0 & `hh_10' != . 
	keep if `hh_18' > 0 & `hh_18' != .
	replace ind_var = 1 if `hh_19' == .
	keep if ind_var == 1

		
	generate issue = "Missing"
	generate issue_variable_name = "`hh_19'"
	rename `hh_19' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_`hh_19'", replace
}
restore

}

***	xxiii.	hh_19_o should be answered when hh_19 = 99, should be text *** 


forvalues i = 1/55 {
preserve
    local hh_19 hh_19_`i'
	local hh_19_o hh_19_o_`i'
	
	gen ind_var = 0
    keep if `hh_19' == 99 
	replace ind_var =1 if missing(`hh_19_o') 
	keep if ind_var == 1
		
	generate issue = "Missing"
	generate issue_variable_name = "`hh_19_o'"
	rename `hh_19_o' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_`hh_19_o'", replace
}
restore

}

*** xxiv.	hh_20 should be answered when hh_10 is greater than 0 and hh_18 is greater than 0 ***


forvalues i = 1/55 {
preserve
	local hh_20 hh_20_`i'
	local hh_18 hh_18_`i'
    local hh_10 hh_10_`i'
	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_`hh_20'", replace
}
restore

}

***	xxv. hh_20_a should be answered when hh_10 is greater than 0 and hh_18 is greater than 0 ***

forvalues i = 1/55 {
preserve
	local hh_20_a hh_20_a_`i'
	local hh_18 hh_18_`i'
    local hh_10 hh_10_`i'
	
	gen ind_var = 0
    keep if `hh_10' > 0 & `hh_10' != .
	keep if `hh_18' > 0 & `hh_18' != . 
	replace ind_var =1 if `hh_20_a' == .
	keep if ind_var == 1 

		
	generate issue = "Missing"
	generate issue_variable_name = "`hh_20_a'"
	rename `hh_20_a' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_`hh_20_a'", replace
}
restore

}


***	xxvi. hh_20_o should be answered when hh_20_a = 1, should be text *** 

forvalues i = 1/55 {
preserve
	local hh_20_o hh_20_o_`i'
	local hh_20_a hh_20_a_`i'
  	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_`hh_20_o'", replace
}
restore

}



*** xxvii.	hh_21 should be answered when hh_10 is greater than 0, should be between 0 and 168 or -9 ***  
**# Bookmark #1  again, double nested loop, just want you to look through it:))
*** I also decided to break this one up so we have different files for each sub part *** 

forvalues i = 1/55 {
    preserve
    local hh_10 hh_10_`i'
    
	keep if `hh_10' > 0 & `hh_10' != . 
    gen ind_var = 0 
    replace ind_var = 1 if hh_21_`i'_1 < 0 & hh_21_`i'_1 != -9
	replace ind_var = 1 if hh_21_`i'_1 > 168 
	replace ind_var = 0 if hh_20index_`i'_1 == . 
    keep if ind_var == 1 
    generate issue = "Issue found: unreasonable value in hh_21_`i'_1 "
    generate issue_variable_name = "hh_21_`i'_1"
	rename hh_21_`i'_1 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_hh_21_`i'_1_unreasonable", replace
}
restore

}

forvalues i = 1/55 {
    preserve
    local hh_10 hh_10_`i'
    
	keep if `hh_10' > 0 & `hh_10' != . 
    gen ind_var = 0 
    replace ind_var = 1 if hh_21_`i'_2 < 0 & hh_21_`i'_2 != -9
	replace ind_var = 1 if hh_21_`i'_2 > 168 
	replace ind_var = 0 if hh_20index_`i'_2 == . 
    keep if ind_var == 1 
    generate issue = "Issue found: unreasonable value in hh_21_`i'_2 "
    generate issue_variable_name = "hh_21_`i'_2"
	rename hh_21_`i'_2 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_hh_21_`i'_2_unreasonable", replace
}
restore

}

forvalues i = 1/55 {
    preserve
    local hh_10 hh_10_`i'
    
	keep if `hh_10' > 0 & `hh_10' != . 
    gen ind_var = 0 
    replace ind_var = 1 if hh_21_`i'_3 < 0 & hh_21_`i'_3 != -9
	replace ind_var = 1 if hh_21_`i'_3 > 168 
	replace ind_var = 0 if hh_20index_`i'_3 == . 
    keep if ind_var == 1 
    generate issue = "Issue found: unreasonable value in hh_21_`i'_3 "
    generate issue_variable_name = "hh_21_`i'_3"
	rename hh_21_`i'_3 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_hh_21_`i'_3_unreasonable", replace
}
restore

}

forvalues i = 1/55 {
    preserve
    local hh_10 hh_10_`i'
    
	keep if `hh_10' > 0 & `hh_10' != . 
    gen ind_var = 0 
    replace ind_var = 1 if hh_21_`i'_4 < 0 & hh_21_`i'_4 != -9
	replace ind_var = 1 if hh_21_`i'_4 > 168 
	replace ind_var = 0 if hh_20index_`i'_4 == . 
    keep if ind_var == 1 
    generate issue = "Issue found: unreasonable value in hh_21_`i'_4 "
    generate issue_variable_name = "hh_21_`i'_4"
	rename hh_21_`i'_4 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_hh_21_`i'_4_unreasonable", replace
}
restore

}

forvalues i = 1/55 {
    preserve
    local hh_10 hh_10_`i'
    
	keep if `hh_10' > 0 & `hh_10' != . 
    gen ind_var = 0 
    replace ind_var = 1 if hh_21_`i'_5 < 0 & hh_21_`i'_5 != -9
	replace ind_var = 1 if hh_21_`i'_5 > 168 
	replace ind_var = 0 if hh_20index_`i'_5 == . 
    keep if ind_var == 1 
    generate issue = "Issue found: unreasonable value in hh_21_`i'_5 "
    generate issue_variable_name = "hh_21_`i'_5"
	rename hh_21_`i'_5 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_hh_21_`i'_5_unreasonable", replace
}
restore

}

forvalues i = 1/55 {
    preserve
    local hh_10 hh_10_`i'
    
	keep if `hh_10' > 0 & `hh_10' != . 
    gen ind_var = 0 
    replace ind_var = 1 if hh_21_`i'_6 < 0 & hh_21_`i'_6 != -9
	replace ind_var = 1 if hh_21_`i'_6 > 168 
	replace ind_var = 0 if hh_20index_`i'_6 == . 
    keep if ind_var == 1 
    generate issue = "Issue found: unreasonable value in hh_21_`i'_6 "
    generate issue_variable_name = "hh_21_`i'_6"
	rename hh_21_`i'_6 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_hh_21_`i'_6_unreasonable", replace
}
restore

}

forvalues i = 1/55 {
    preserve
    local hh_10 hh_10_`i'
    
	keep if `hh_10' > 0 & `hh_10' != . 
    gen ind_var = 0 
    replace ind_var = 1 if hh_21_`i'_7 < 0 & hh_21_`i'_7 != -9
	replace ind_var = 1 if hh_21_`i'_7 > 168 
	replace ind_var = 0 if hh_20index_`i'_7 == . 
    keep if ind_var == 1 
    generate issue = "Issue found: unreasonable value in hh_21_`i'_7 "
    generate issue_variable_name = "hh_21_`i'_7"
	rename hh_21_`i'_7 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_hh_21_`i'_7_unreasonable", replace
}
restore

}


***	xxviii.	hh_21_o should be answered when hh_20_a = 1

forvalues i = 1/55 {
preserve
	local hh_21_o hh_21_o_`i'
	local hh_20_a hh_20_a_`i'
  	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_`hh_21_o'", replace
}
restore

}

*** xxix.	hh_22 should be answered when hh_20 = 6 and hh_10 is greater than 0 and hh_18 is greater than 0, should be greater than 0 or -9 ***
*** add the hh_20 = 6 check ***

forvalues i = 1/55 {
preserve
	local hh_22 hh_22_`i'
	local hh_18 hh_18_`i'
    local hh_10 hh_10_`i'
	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_`hh_22'", replace
}
restore

}

***	xxx.	hh_23 should be answered when hh_20 = 6 and hh_10 is greater than 0 and hh_18 is greater than 0 ***
**# Bookmark #3 changed stuff to strings and I'm only calling on hh_23_i (which are just strings) - want to make sure I interpreted this correctly

forvalues i = 1/55 {
preserve
	local hh_23 hh_23_`i'
	*local hh_23_99 hh_23_99_`i'
	local hh_20 hh_20_6_`i'
	local hh_18 hh_18_`i'
    local hh_10 hh_10_`i'
	
	tostring `hh_23', replace
	
	gen ind_var = 0
	 
	keep if  `hh_10' > 0 & `hh_10' != . 
	keep if  `hh_18' > 0 & `hh_18' != . 
	keep if `hh_20' == 1  
	replace ind_var = 1 if missing(`hh_23') 
	keep if ind_var == 1

	generate issue = "Missing"
	generate issue_variable_name = "`hh_23'"
	rename `hh_23' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_`hh_23'", replace
}
restore

}

*** xxxi. hh_23_o should be answered when hh_23 = 99, should be text ***

forvalues i = 1/55 {
preserve
	local hh_23 hh_23_99_`i'
	local hh_23_o hh_23_o_`i'
    
	tostring `hh_23_o', replace
		
	gen ind_var = 0
    keep if `hh_23' == 1
	replace ind_var = 1 if missing(`hh_23_o') 
	keep if ind_var == 1

	generate issue = "Missing"
	generate issue_variable_name = "`hh_23_o'"
	rename `hh_23_o' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_`hh_23_o'", replace
}
restore

}


***	xxxii.	the following questions are for ages 4 to 18: hh_26, hh_27, hh_28, hh_29, hh_29_o, hh_30, hh_31, hh_32, hh_33, hh_34, hh_35, hh_36, hh_37, hh_38, hh_39, hh_40, hh_41, hh_42, hh_43, hh_44, hh_45, hh_46, hh_47, hh_48, hh_49 ***

*** add a check to make sure hh_26 is answered correctly since all the others ***
*** depend on it - I missed this one in the instructions *** 

*** hh_26 should be answered when 4 < age < 18 ***
forvalues i = 1/55 {
	preserve 
	
	keep if hh_age_`i' >= 4 & hh_age_`i' <= 18 
	
	gen ind_var = 0 
	replace ind_var = 1 if hh_26_`i' == . 
	keep if ind_var == 1 
	
	generate issue = "Issue found: hh_26_`i' value is missing"
    generate issue_variable_name = "hh_26_`i'"
	rename hh_26_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_hh_26_`i'_missing", replace
}

restore
}

***	 1.	hh_27 should be answered when hh_26 = 0 ***

forvalues i = 1/55 {
preserve
	local hh_27 hh_27_`i'
	local hh_26 hh_26_`i'
  	
	**in case any value in in hh_27 is not a string 
	*tostring `hh_27', replace
	gen ind_var = 0
	keep if  `hh_26' == 0
    replace ind_var = 1 if `hh_27' == .
	keep if ind_var == 1

		
	generate issue = "Missing"
	generate issue_variable_name = "`hh_27'"
	rename `hh_27' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_`hh_27'", replace
}
restore

}
***	2.	hh_28 should be answered when hh_27 = 1 ***

forvalues i = 1/55 {
preserve
	local hh_28 hh_28_`i'
	local hh_27 hh_27_`i'
  	
	gen ind_var = 0
	keep if  `hh_27' == 1
    replace ind_var = 1 if `hh_28' == .
	keep if ind_var == 1

		
	generate issue = "Missing"
	generate issue_variable_name = "`hh_28'"
	rename `hh_28' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_`hh_28'", replace
}
restore

}

*** 3.	hh_29 should be answered when hh_26 = 1 ***

forvalues i = 1/55 {
preserve
	local hh_29 hh_29_`i'
	local hh_26 hh_26_`i'
  	
	gen ind_var = 0
	keep if `hh_26' == 1
    replace ind_var = 1 if `hh_29' == .
	keep if ind_var == 1

	generate issue = "Missing"
	generate issue_variable_name = "`hh_29'"
	rename `hh_29' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_`hh_29'", replace
}
restore

}

*** 4.	hh_29_o should be answered when hh_29 = 99, should be text  ***

forvalues i = 1/55 {
preserve
	local hh_29 hh_29_`i'
	local hh_29_o hh_29_o_`i'
  	
	gen ind_var = 0
	keep if `hh_29' == 99
    replace ind_var = 1 if missing(`hh_29_o') 
	keep if ind_var == 1
	
	generate issue = "Missing"
	generate issue_variable_name = "`hh_29_o'"
	rename `hh_29_o' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_`hh_29_o'", replace
}
restore

}

*** 5.	hh_30 should be answered when hh_26 = 1 ***

forvalues i = 1/55 {
preserve
	local hh_30 hh_30_`i'
	local hh_26 hh_26_`i'
  	
	gen ind_var = 0
   	keep if  `hh_26' == 1 
	replace ind_var = 1 if `hh_30' == .
	keep if ind_var == 1
		
	generate issue = "Missing"
	generate issue_variable_name = "`hh_30'"
	rename `hh_30' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_`hh_30'", replace
}
restore

}

***	6.	hh_31 should be answered when hh_30 = 1 ***

forvalues i = 1/55 {
preserve
	local hh_31 hh_31_`i'
	local hh_30 hh_30_`i'
	  	
	gen ind_var = 0
    keep if `hh_30' == 1 
	replace ind_var = 1 if `hh_31' == .
	keep if ind_var == 1
		
	generate issue = "Missing"
	generate issue_variable_name = "`hh_31'"
	rename `hh_31' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_`hh_31'", replace
}
restore

}

***	7.	hh_32 should be answered when hh_26 = 1 ***



forvalues i = 1/55 {
preserve
	local hh_32 hh_32_`i'
	local hh_26 hh_26_`i'
	  	
	gen ind_var = 0
    keep if `hh_26' == 1 
	replace ind_var = 1 if `hh_32' == .
	keep if ind_var == 1
		
	generate issue = "Missing"
	generate issue_variable_name = "`hh_32'"
	rename `hh_32' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_`hh_32'", replace
}
restore

}


***	8.	hh_33 should be answered when hh_26 = 1 and hh_32 = 1 ***

forvalues i = 1/55 {
preserve
	local hh_33 hh_33_`i'
	local hh_32 hh_32_`i'
	local hh_26 hh_26_`i'
	  	
	gen ind_var = 0
	keep if `hh_32' == 1 
	keep if `hh_26' == 1
	replace ind_var = 1 if `hh_33' == .
	keep if ind_var == 1

	generate issue = "Missing"
	generate issue_variable_name = "`hh_33'"
	rename `hh_33' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_`hh_33'", replace
}
restore

}

*** 9.	hh_34 should be answered when hh_32 = 0 ***


forvalues i = 1/55 {
preserve
	local hh_34 hh_34_`i'
	local hh_32 hh_32_`i'
	
	  	
	gen ind_var = 0
    keep if `hh_32' == 0 
	replace ind_var = 1 if `hh_34' == .
	keep if ind_var == 1

		
	generate issue = "Missing"
	generate issue_variable_name = "`hh_34'"
	rename `hh_34' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_`hh_34'", replace
}
restore

}


*** 10.	hh_35 should be answered when hh_32 = 1 ***

forvalues i = 1/55 {
preserve
	local hh_35 hh_35_`i'
	local hh_32 hh_32_`i'
		  	
	gen ind_var = 0
	keep if `hh_32' == 1
    replace ind_var = 1 if `hh_35' == .
	keep if ind_var == 1

		
	generate issue = "Missing"
	generate issue_variable_name = "`hh_35'"
	rename `hh_35' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_`hh_35'", replace
}
restore

}
*** 11.	hh_36 should be answered when hh_32 = 1 ***

forvalues i = 1/55 {
preserve
	local hh_36 hh_36_`i'
	local hh_32 hh_32_`i'
		  	
	gen ind_var = 0
	keep if `hh_32' == 1 
    replace ind_var = 1 if `hh_36' == .
	keep if ind_var == 1

		
	generate issue = "Missing"
	generate issue_variable_name = "`hh_36'"
	rename `hh_36' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_`hh_36'", replace
}
restore

}


*** 12.	hh_37 should be answered when hh_32 = 1 ***

forvalues i = 1/55 {
preserve
	local hh_37 hh_37_`i'
	local hh_32 hh_32_`i'
		  	
	gen ind_var = 0
	keep if `hh_32' == 1 
    replace ind_var = 1 if `hh_37' == .
	keep if ind_var == 1

		
	generate issue = "Missing"
	generate issue_variable_name = "`hh_37'"
	rename `hh_37' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_`hh_37'", replace
}
restore

}


*** 13.	hh_38 should be answered when hh_32 = 1, should be between 0 and 7 or -9 ***


forvalues i = 1/55 {
preserve
	local hh_38 hh_38_`i'
	local hh_32 hh_32_`i'
		  	
	gen ind_var = 0
	keep if `hh_32' == 1 
    replace ind_var = 1 if `hh_38' > 7 
	replace ind_var = 1 if `hh_38' < 0 & `hh_38'!= -9
	keep if ind_var == 1

		
	generate issue = "Unreasonable value"
	generate issue_variable_name = "`hh_38'"
	rename `hh_38' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$household_roster\Issue_`hh_38'", replace
}
restore

}

*** 14. hh_39 should be answered when 4 <= age <= 18 ***

forvalues i = 1/55 {
    preserve
    local hh_39 hh_39_`i'
    local hh_age hh_age_`i'

    gen ind_var = 0
    keep if `hh_age' >= 4 & `hh_age' <= 18
    replace ind_var = 1 if missing(`hh_39')
    keep if ind_var == 1

    generate issue = "Missing"
    generate issue_variable_name = "`hh_39'"
    rename `hh_39' print_issue 
    tostring(print_issue), replace
    keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
    if _N > 0 {
        save "$household_roster\Issue_`hh_39'", replace
    }
    restore
}

*** 15. hh_40 should be answered when 4 <= age <= 18 ***

forvalues i = 1/55 {
    preserve
    local hh_40 hh_40_`i'
    local hh_age hh_age_`i'

    gen ind_var = 0
    keep if `hh_age' >= 4 & `hh_age' <= 18
    replace ind_var = 1 if missing(`hh_40')
    keep if ind_var == 1

    generate issue = "Missing"
    generate issue_variable_name = "`hh_40'"
    rename `hh_40' print_issue 
    tostring(print_issue), replace
    keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
    if _N > 0 {
        save "$household_roster\Issue_`hh_40'", replace
    }
    restore
}

*** Block 1: hh_41 should be answered when hh_26 = 1 ***
forvalues i = 1/55 {
    preserve
    local hh_41 hh_41_`i'
    local hh_26 hh_26_`i'

    gen ind_var = 0
    keep if `hh_26' == 1
    replace ind_var = 1 if missing(`hh_41')
    keep if ind_var == 1

    generate issue = "Missing"
    generate issue_variable_name = "`hh_41'"
    rename `hh_41' print_issue
    tostring(print_issue), replace
    keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
    if _N > 0 {
        save "$household_roster/Issue_`hh_41'", replace
    }
    restore
}

*** Block 2: hh_29_o should be answered when hh_29 = 99 ***
forvalues i = 1/55 {
    preserve
    local hh_29 hh_29_`i'
    local hh_29_o hh_29_o_`i'

    gen ind_var = 0
    keep if `hh_29' == 99
    replace ind_var = 1 if missing(`hh_29_o')
    keep if ind_var == 1

    generate issue = "Missing"
    generate issue_variable_name = "`hh_29_o'"
    rename `hh_29_o' print_issue
    tostring(print_issue), replace
    keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
    if _N > 0 {
        save "$household_roster/Issue_`hh_29_o'", replace
    }
    restore
}

*** Block 3: hh_34 should be answered when hh_32 = 2 ***
forvalues i = 1/55 {
    preserve
    local hh_34 hh_34_`i'
    local hh_32 hh_32_`i'

    gen ind_var = 0
    keep if `hh_32' == 2
    replace ind_var = 1 if missing(`hh_34')
    keep if ind_var == 1

    generate issue = "Missing"
    generate issue_variable_name = "`hh_34'"
    rename `hh_34' print_issue
    tostring(print_issue), replace
    keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
    if _N > 0 {
        save "$household_roster/Issue_`hh_34'", replace
    }
    restore
}


*** 1. hh_35 should be answered when hh_23 = 1 ***
forvalues i = 1/55 {
    preserve
    local hh_35 hh_35_`i'
    local hh_23 hh_23_`i'

    gen ind_var = 0
    keep if `hh_23' == 1
    replace ind_var = 1 if missing(`hh_35')
    keep if ind_var == 1

    generate issue = "Missing"
    generate issue_variable_name = "`hh_35'"
    rename `hh_35' print_issue
    tostring(print_issue), replace
    keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
    if _N > 0 {
        save "$household_roster\Issue_`hh_35'", replace
    }
    restore
}

*** 2. hh_43 should be answered when hh_42 = 1 ***
forvalues i = 1/55 {
    preserve
    local hh_43 hh_43_`i'
    local hh_42 hh_42_`i'

    gen ind_var = 0
    keep if `hh_42' == 1
    replace ind_var = 1 if missing(`hh_43')
    keep if ind_var == 1

    generate issue = "Missing"
    generate issue_variable_name = "`hh_43'"
    rename `hh_43' print_issue
    tostring(print_issue), replace
    keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
    if _N > 0 {
        save "$household_roster\Issue_`hh_43'", replace
    }
    restore
}

*** 3. hh_44 should be answered when hh_42 = 2 ***
forvalues i = 1/55 {
    preserve
    local hh_44 hh_44_`i'
    local hh_42 hh_42_`i'

    gen ind_var = 0
    keep if `hh_42' == 2
    replace ind_var = 1 if missing(`hh_44')
    keep if ind_var == 1

    generate issue = "Missing"
    generate issue_variable_name = "`hh_44'"
    rename `hh_44' print_issue
    tostring(print_issue), replace
    keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
    if _N > 0 {
        save "$household_roster\Issue_`hh_44'", replace
    }
    restore
}

*** 4. hh_45 should be answered when hh_44 = 1 ***
forvalues i = 1/55 {
    preserve
    local hh_45 hh_45_`i'
    local hh_44 hh_44_`i'

    gen ind_var = 0
    keep if `hh_44' == 1
    replace ind_var = 1 if missing(`hh_45')
    keep if ind_var == 1

    generate issue = "Missing"
    generate issue_variable_name = "`hh_45'"
    rename `hh_45' print_issue
    tostring(print_issue), replace
    keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
    if _N > 0 {
        save "$household_roster\Issue_`hh_45'", replace
    }
    restore
}

*** 5. hh_46 should be answered when hh_42 = 2 ***
forvalues i = 1/55 {
    preserve
    local hh_46 hh_46_`i'
    local hh_42 hh_42_`i'

    gen ind_var = 0
    keep if `hh_42' == 2
    replace ind_var = 1 if missing(`hh_46')
    keep if ind_var == 1

    generate issue = "Missing"
    generate issue_variable_name = "`hh_46'"
    rename `hh_46' print_issue
    tostring(print_issue), replace
    keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
    if _N > 0 {
        save "$household_roster\Issue_`hh_46'", replace
    }
    restore
}

*** 6. hh_36 should be answered when hh_32 = 1 ***
forvalues i = 1/55 {
    preserve
    local hh_36 hh_36_`i'
    local hh_32 hh_32_`i'

    gen ind_var = 0
    keep if `hh_32' == 1
    replace ind_var = 1 if missing(`hh_36')
    keep if ind_var == 1

    generate issue = "Missing"
    generate issue_variable_name = "`hh_36'"
    rename `hh_36' print_issue
    tostring(print_issue), replace
    keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
    if _N > 0 {
        save "$household_roster\Issue_`hh_36'", replace
    }
    restore
}

*** 7. hh_31 should be answered when hh_30 = 1 ***
forvalues i = 1/55 {
    preserve
    local hh_31 hh_31_`i'
    local hh_30 hh_30_`i'

    gen ind_var = 0
    keep if `hh_30' == 1
    replace ind_var = 1 if missing(`hh_31')
    keep if ind_var == 1

    generate issue = "Missing"
    generate issue_variable_name = "`hh_31'"
    rename `hh_31' print_issue
    tostring(print_issue), replace
    keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
    if _N > 0 {
        save "$household_roster\Issue_`hh_31'", replace
    }
    restore
}

*** 8. hh_28 should be answered when hh_27 = 1 ***
forvalues i = 1/55 {
    preserve
    local hh_28 hh_28_`i'
    local hh_27 hh_27_`i'

    gen ind_var = 0
    keep if `hh_27' == 1
    replace ind_var = 1 if missing(`hh_28')
    keep if ind_var == 1

    generate issue = "Missing"
    generate issue_variable_name = "`hh_28'"
    rename `hh_28' print_issue
    tostring(print_issue), replace
    keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
    if _N > 0 {
        save "$household_roster\Issue_`hh_28'", replace
    }
    restore
}



************************************ c.	knowledge section **************************************

***	i.	knowledge_02 should be answered when knowledge_01 = 1, should be text ***  

preserve 

	gen ind_var = 0
    keep if knowledge_01 == 1 
	replace ind_var = 1 if missing(knowledge_02)
	keep if ind_var == 1 
	
	generate issue = "Missing"
	generate issue_variable_name = "knowledge_02"
	rename knowledge_02 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$knowledge\Issue_knowledge_02", replace
}
restore


*** ii.	knowledge_03 should be answered when knowledge_01 = 1 ***

preserve 

	gen ind_var = 0
	keep if knowledge_01 == 1
    replace ind_var = 1 if missing(knowledge_03)
	keep if ind_var == 1 
	
	generate issue = "Missing"
	generate issue_variable_name = "knowledge_03"
	rename knowledge_03 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$knowledge\Issue_knowledge_03", replace
}
restore



*** iii.knowledge_04 should be answered when knowledge_03 = 1 ***

preserve 

	gen ind_var = 0
	keep if knowledge_03 == 1
    replace ind_var = 1 if missing(knowledge_04)
	keep if ind_var == 1 
	
	generate issue = "Missing"
	generate issue_variable_name = "knowledge_04"
	rename knowledge_04 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$knowledge\Issue_knowledge_04", replace
}

restore


***	 iv. knowledge_05 should be answered when knowledge_04 = 1 

preserve 

	gen ind_var = 0
	keep if knowledge_04 == 1 
	replace ind_var = 1 if missing(knowledge_05)
	keep if ind_var == 1 
	
	generate issue = "Missing"
	generate issue_variable_name = "knowledge_05"
	rename knowledge_05 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$knowledge\Issue_knowledge_05", replace
}

restore

***	v. knowledge_05_o should be answered when knowledge_05 = 99, should be text
*** I screwed up the instructions *** 
preserve 

	gen ind_var = 0
    keep if knowledge_05 == 99 
	replace ind_var = 1 if missing(knowledge_05_o)
	keep if ind_var == 1 
	
	generate issue = "Missing"
	generate issue_variable_name = "knowledge_05_o"
	rename knowledge_05_o print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {	
		save "$knowledge\Issue_knowledge_05_o", replace
		}
	
restore


***	vi.	knowledge_08 should be answered when knowledge_07 = 1, should be text ***

preserve 

	gen ind_var = 0
    keep if knowledge_07 == 1
	replace ind_var = 1 if missing(knowledge_08)
	keep if ind_var == 1 
	
	generate issue = "Missing"
	generate issue_variable_name = "knowledge_08"
	rename knowledge_08 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$knowledge\Issue_knowledge_08", replace
}

restore


***	viii. knowledge_10_o should be answered when knowledge_10 = 99, should be text ***

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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$knowledge\Issue_knowledge_10_o", replace
}

restore

*** ix.	knowledge_12_o should be answered when knowledge_12 = 99, should be text ***

preserve 

	gen ind_var = 0
    keep if knowledge_12 == 99 
	replace ind_var = 1 if missing(knowledge_12_o)
	keep if ind_var == 1 
	
	generate issue = "Missing"
	generate issue_variable_name = "knowledge_12_o"
	rename knowledge_12_o print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$knowledge\Issue_knowledge_12_o", replace
}

restore

*** x.	knowledge_16 should be answered when knowledge_15 = 1 ***


preserve 

	gen ind_var = 0
    keep if knowledge_15 == 1 
	replace ind_var = 1 if missing(knowledge_16)
	keep if ind_var == 1 
	
	generate issue = "Missing"
	generate issue_variable_name = "knowledge_16"
	rename knowledge_16 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$knowledge\Issue_knowledge_16", replace
}

restore


*** xi.	knowledge_19 should be answered when knowledge_18 = 1 ***

preserve 

	gen ind_var = 0
    keep if knowledge_18 == 1 
	replace ind_var = 1 if missing(knowledge_19)
	keep if ind_var == 1 
	
	generate issue = "Missing"
	generate issue_variable_name = "knowledge_19"
	rename knowledge_19 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$knowledge\Issue_knowledge_19", replace
}

restore

***	xii. knowledge_19_o should be answered when knowledge_19 = 99, should be text ***

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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$knowledge\Issue_knowledge_19_o", replace
}

restore



***	xiii. knowledge_20 should be answered when knowledge_18 = 1 ***


preserve 

	gen ind_var = 0
    keep if knowledge_18 == 1
	replace ind_var = 1 if knowledge_20 == .
	keep if ind_var == 1 
	
	generate issue = "Missing"
	generate issue_variable_name = "knowledge_20"
	rename knowledge_20 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$knowledge\Issue_knowledge_20", replace
}

restore

***	xiv. knowledge_20_o should be answered when knowledge_20 = 99, should be text ***

preserve 

	gen ind_var = 0
    keep if knowledge_20 == 99 
	replace ind_var = 1 if missing(knowledge_20_o) 
	keep if ind_var == 1 
	
	generate issue = "Missing"
	generate issue_variable_name = "knowledge_20_o"
	rename knowledge_20_o print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$knowledge\Issue_knowledge_20_o", replace
}

restore


***	xv.	knowledge_21 should be answered when knowledge_18 = 1 ***

preserve 

	gen ind_var = 0
    keep if knowledge_18 == 1 
	replace ind_var = 1 if knowledge_21 == . 
	keep if ind_var == 1 
	
	generate issue = "Missing"
	generate issue_variable_name = "knowledge_21"
	rename knowledge_21 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$knowledge\Issue_knowledge_21", replace
}

restore


*** xvi. knowledge_22 should be answered when knowledge_18 = 1


preserve 

	gen ind_var = 0
    keep if knowledge_18 == 1
	replace ind_var = 1 if knowledge_22 == . 
	keep if ind_var == 1 
	
	generate issue = "Missing"
	generate issue_variable_name = "knowledge_22"
	rename knowledge_22 print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$knowledge\Issue_knowledge_22", replace
}

restore


***	 xvii. knowledge_23 should be answered when knowledge_18 = 1 ***
 
**# Bookmark does this make sense 
*** This is a SurveyCTO quirk where we only need to check the first one *** 


preserve
	gen ind_var = 0
    replace ind_var = 1 if knowledge_18 == 1 & knowledge_23 == "." 
	keep if ind_var == 1 
	
	
	generate issue = "Missing"
	generate issue_variable_name = "knowledge_23"
	rename knowledge_23 print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
 if _N > 0 {
        save "$knowledge\issue_household_knowledge_23.dta", replace
    }
	
restore

*** xviii. knowledge_23_o should be answered when knowledge_23 = 99, should be text ***

preserve

	gen ind_var = 0
    keep if knowledge_23 == "99" 
	replace ind_var = 1 if missing(knowledge_23_o) 
	keep if ind_var == 1 
	
	
	generate issue = "Missing"
	generate issue_variable_name = "knowledge_23_o"
	rename knowledge_23_o print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$knowledge\Issue_knowledge_23_o", replace
}

restore


******************************* d. health section *************************************

*** check for missing values in health_5_2 *** 
forvalues i=1/55 {

    preserve 

	*** drop no consent households *** 
	drop if consent == 0 
	
	gen ind_var = 0
    replace ind_var = 1 if health_5_2_`i' == .  
 	replace ind_var = 0 if _household_roster_count < `i'
   
    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Missing value"
	generate issue_variable_name = "health_5_2_`i'"
	rename health_5_2_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$health\Issue_Household_health_5_2_`i'.dta", replace
    }
  
    restore
}

***	i. health_5_3 should be answered when health_5_2 = 1 ***
*** We only need to check that at least one is selected and not the individual indicators *** 

forvalues i = 1/55 {
preserve

	local health_5_2 health_5_2_`i'
		
	tostring(health_5_3_`i'), replace
	
	gen ind_var = 0
	replace ind_var = 1 if `health_5_2' == 1 & health_5_3_`i' == "."
	keep if ind_var == 1 
   
	generate issue = "Issue found: health_5_3_`i' value is missing"
	generate issue_variable_name = "health_5_3_`i'"
	rename health_5_3_`i' print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
 if _N > 0 {
        save "$health\issue_household_health_5_3_`i'.dta", replace
    }
	
restore

}

*** ii.	health_5_3_o should be answered when health_5_3 = 99, should be text ***
*** Can check if health_5_3_99 = 1 to check if health_5_3 = 99 
 
forvalues i = 1/55 {
preserve
	local health_5_3 health_5_3_99_`i'
	local health_5_3_o health_5_3_o_`i'
	
	gen ind_var = 0
	tostring `health_5_3_o', replace
    keep if `health_5_3' == 1 
	replace ind_var = 1 if missing(`health_5_3_o') 
	keep if ind_var == 1 
	
	generate issue = "Missing"
	generate issue_variable_name = "health_5_3_o"
	rename `health_5_3_o' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$health\Issue_`health_5_3_o'", replace
}

restore

}


***	iii. health_5_4 should be answered when health_5_2 = 1 ***

forvalues i = 1/55 {
preserve

	local health_5_4 health_5_4_`i'
	local health_5_2 health_5_2_`i'
	
	gen ind_var = 0
	
    keep if `health_5_2' == 1
	replace ind_var = 1 if `health_5_4' == .
	keep if ind_var == 1 
	
	generate issue = "Missing"
	generate issue_variable_name = "health_5_4"
	rename `health_5_4' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$health\Issue_`health_5_4'", replace
}

restore

}

*** check for missing values in health_5_5, health_5_6, health_5_7, health_5_8 *** 
forvalues i=1/55 {

    preserve 

	*** drop no consent households *** 
	drop if consent == 0 
	
	gen ind_var = 0
    replace ind_var = 1 if health_5_5_`i' == .  
 	replace ind_var = 0 if _household_roster_count < `i'
   
    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Missing value"
	generate issue_variable_name = "health_5_5_`i'"
	rename health_5_5_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$health\Issue_Household_health_5_5_`i'.dta", replace
    }
  
    restore
}

forvalues i=1/55 {

    preserve 

	*** drop no consent households *** 
	drop if consent == 0 
	
	gen ind_var = 0
    replace ind_var = 1 if health_5_6_`i' == .  
 	replace ind_var = 0 if _household_roster_count < `i'
   
    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Missing value"
	generate issue_variable_name = "health_5_6_`i'"
	rename health_5_6_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$health\Issue_Household_health_5_6_`i'.dta", replace
    }
  
    restore
}

********** DROPPED VAR **************

// forvalues i=1/55 {
//
//     preserve 
//
// 	*** drop no consent households *** 
// 	drop if consent == 0 
//	
// 	gen ind_var = 0
//     replace ind_var = 1 if health_5_7_`i' == .  
//  	replace ind_var = 0 if _household_roster_count < `i'
//   
//     	* keep and add variables to export *
// 	keep if ind_var == 1 	
// 	generate issue =  "Missing value"
// 	generate issue_variable_name = "health_5_7_`i'"
// 	rename health_5_7_`i' print_issue 
// 	tostring(print_issue), replace
// 	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
//	
//     * Export the dataset to Excel conditional on there being an issue
//     if _N > 0 {
//         save "$health\Issue_Household_health_5_7_`i'.dta", replace
//     }
//  
//     restore
// }

forvalues i=1/55 {

    preserve 

	*** drop no consent households *** 
	drop if consent == 0 
	
	gen ind_var = 0
    replace ind_var = 1 if health_5_8_`i' == .  
 	replace ind_var = 0 if _household_roster_count < `i'
   
    	* keep and add variables to export *
	keep if ind_var == 1 	
	generate issue =  "Missing value"
	generate issue_variable_name = "health_5_8_`i'"
	rename health_5_8_`i' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$health\Issue_Household_health_5_8_`i'.dta", replace
    }
  
    restore
}

***	iv.	health_5_11 should be answered when health_5_10 = 1 ***

forvalues i = 1/55 {
preserve

	local health_5_11 health_5_11_`i'
	local health_5_10 health_5_10_`i'
	
	gen ind_var = 0
	
    keep if `health_5_10' == 1 
	replace ind_var = 1 if `health_5_11' == .
	keep if ind_var == 1 
	

	generate issue = "Missing"
	generate issue_variable_name = "health_5_11"
	rename `health_5_11' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$health\Issue_`health_5_11'", replace
}

restore

}


*** v. health_5_11_o should be answered when health_5_11 = 99, should be text ***


forvalues i = 1/55 {
preserve

	local health_5_11 health_5_11_`i'
	local health_5_11_o health_5_11_o_`i'
	
	gen ind_var = 0
	
    keep if `health_5_11' == 99 
	replace ind_var = 1 if missing(`health_5_11_o')
	keep if ind_var == 1 
	
	generate issue = "Missing"
	generate issue_variable_name = "health_5_11_o"
	rename `health_5_11_o' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$health\Issue_`health_5_11_o'", replace
}

restore

}

**** vi. health_5_12 should be answered when health_5_10 = 1, should be between 0 and 150 ***

forvalues i = 1/55 {
preserve

	local health_5_12 health_5_12_`i'
	local health_5_10 health_5_10_`i'
	
	gen ind_var = 0
	
    keep if `health_5_10' == 1
	replace ind_var = 1 if `health_5_12' > 150 
	replace ind_var = 1 if `health_5_12' < 0 | `health_5_12' == .
	keep if ind_var == 1 
	
	generate issue = "Unreaonsable value"
	generate issue_variable_name = "health_5_12"
	rename `health_5_12' print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$health\Issue_`health_5_12'", replace
}

restore

}

*** vii. health_5_14_a should be answered when health_5_13 = 1 

preserve

	gen ind_var = 0
    keep if health_5_13 == 1
	replace ind_var = 1 if health_5_14_a == . 
	keep if ind_var == 1 
	
	
	generate issue = "Missing"
	generate issue_variable_name = "health_5_14_a"
	rename health_5_14_a print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$health\Issue_health_5_14_a", replace
}

restore

***	viii. health_5_14_b should be answered when health_5_13 = 1 ***
 
preserve

	gen ind_var = 0
    keep if health_5_13 == 1 
	replace ind_var = 1 if health_5_14_b == . 
	keep if ind_var == 1 
	
	
	generate issue = "Missing"
	generate issue_variable_name = "health_5_14_b"
	rename health_5_14_b print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$health\Issue_health_5_14_b", replace
}

restore


***	ix.	health_5_14_c should be answered when health_5_13 = 1 ***

preserve
	
	gen ind_var = 0
    keep if health_5_13 == 1 
	replace ind_var = 1 if health_5_14_c == . 
	keep if ind_var == 1 
	
	
	generate issue = "Missing"
	generate issue_variable_name = "health_5_14_c"
	rename health_5_14_c print_issue 
	tostring(print_issue), replace
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$health\Issue_health_5_14_c", replace
}

restore

*** Check for missing values in health_5_7_1 ***
forvalues i=1/55 {
    preserve 
    *** Drop households without consent ***
    drop if consent == 0 

    gen ind_var = 0
    replace ind_var = 1 if health_5_7_1_`i' == .  
    replace ind_var = 0 if _household_roster_count < `i'

    * Keep and add variables to export *
    keep if ind_var == 1 
    generate issue = "Missing value"
    generate issue_variable_name = "health_5_7_1_`i'"
    rename health_5_7_1_`i' print_issue 
    tostring(print_issue), replace
    keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue

    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$health\Issue_Household_health_5_7_1_`i'.dta", replace
    }
    restore
}

*** Check for missing values in health_5_9 ***
forvalues i=1/55 {
    preserve 
    *** Drop households without consent ***
    drop if consent == 0 

    gen ind_var = 0
    replace ind_var = 1 if health_5_9_`i' == .  
    replace ind_var = 0 if _household_roster_count < `i'

    * Keep and add variables to export *
    keep if ind_var == 1 
    generate issue = "Missing value"
    generate issue_variable_name = "health_5_9_`i'"
    rename health_5_9_`i' print_issue 
    tostring(print_issue), replace
    keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue

    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$health\Issue_Household_health_5_9_`i'.dta", replace
    }
    restore
}


*** Check for unreasonable values in health_5_12 ***
forvalues i=1/55 {
    preserve
    local health_5_12 health_5_12_`i'
    local health_5_10 health_5_10_`i'

    gen ind_var = 0
    keep if `health_5_10' == 1
    replace ind_var = 1 if `health_5_12' > 150 
    replace ind_var = 1 if `health_5_12' < 0 | `health_5_12' == .
    keep if ind_var == 1 

    generate issue = "Unreasonable value"
    generate issue_variable_name = "`health_5_12'"
    rename `health_5_12' print_issue 
    tostring(print_issue), replace
    keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue

    if _N > 0 {
        save "$health\Issue_`health_5_12'", replace
    }
    restore
}

*** Check for missing values in health_5_14_a ***
preserve
gen ind_var = 0
keep if health_5_13 == 1
replace ind_var = 1 if health_5_14_a == . 
keep if ind_var == 1 

generate issue = "Missing value"
generate issue_variable_name = "health_5_14_a"
rename health_5_14_a print_issue 
tostring(print_issue), replace
keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue

if _N > 0 {
    save "$health\Issue_health_5_14_a", replace
}
restore

*** Check for missing values in health_5_14_b ***
preserve
gen ind_var = 0
keep if health_5_13 == 1
replace ind_var = 1 if health_5_14_b == . 
keep if ind_var == 1 

generate issue = "Missing value"
generate issue_variable_name = "health_5_14_b"
rename health_5_14_b print_issue 
tostring(print_issue), replace
keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue

if _N > 0 {
    save "$health\Issue_health_5_14_b", replace
}
restore

*** Check for missing values in health_5_14_c ***
preserve
gen ind_var = 0
keep if health_5_13 == 1
replace ind_var = 1 if health_5_14_c == . 
keep if ind_var == 1 

generate issue = "Missing value"
generate issue_variable_name = "health_5_14_c"
rename health_5_14_c print_issue 
tostring(print_issue), replace
keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue

if _N > 0 {
    save "$health\Issue_health_5_14_c", replace
}
restore


********************* Agriculture Section Checks *********************

*** check if list_actifs is missing ***

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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$agriculture_inputs\Issue_list_actifs.dta", replace
    }
  
    restore
	
*** check if list_agri_equip is missing ***

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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$agriculture_inputs\Issue_list_agri_equip.dta", replace
    }
  
    restore

*** check if agri_6_5 is missing ***

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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$agriculture_inputs\Issue_agri_6_5.dta", replace
    }
  
    restore
	

*** i.	Actifs_o should be answered when list_actifs_o = 1, should be text  *** 

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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
	save "$agriculture_inputs\Issue_actifs_o_missing.dta", replace 
	}
	
restore

*** ii.	Actifs_o_int should be answered when list_actifs_o = 1, should be between 0 and 100  *** 

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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_actifs_o_int_unreasonable.dta", replace 
	}
	
restore

*** iii.	List_agri_equip_o_t should be answered when list_agri_equip_o = 1, should be text ***
 
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_list_agri_equip_o_t_missing.dta", replace 
	}
	
restore

*** iv.	List_agri_equip_o_int should be answered when list_agri_equip_o = 1, should be between 0 and 100  *** 

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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_list_agri_equip_o_int_unreasonable.dta", replace 
	}
	
restore

*** v.	Agri_6_12 should be answered when agri_6_11 = 1  ***

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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_12_missing.dta", replace 
	}
	
restore

*** vi.	Agri_6_12_o should be answered when agri_6_12 = 99, should be text ***

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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_12_o_missing.dta", replace 
	}
		
restore

*** agri_6_15 should be answered when agri_6_14 = 1, should be between 0 and 60 ***

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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_15_unreasonable.dta", replace 
	}
	
restore

*** agri_6_16 should be answered when agri_6_14 =  ***

forvalue i = 1/11 {
	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_16_`i'_missing.dta", replace 
	}
	
	restore
}


*** agri_6_17 should be answered when agri_6_14 = 1 ***

forvalue i = 1/11 {
	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_17_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_18 should be answered when agri_6_14 = 1 ***

forvalue i = 1/11 {
	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_18_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_19 should be answered when agri_6_14 = 1 *** 

forvalue i = 1/11 {
	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_19_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_20 should be answered when agri_6_14 = 1 *** 

forvalue i = 1/11 {
	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_20_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_20_o should be answered when agri_6_14 = 1, should be answered when agri_6_20 == 99, should be text *** 

forvalue i = 1/11 {
	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_20_o_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_21 should be answered when agri_6_14 = 1, should be between 0 and 20000 ***
*** FLAGGED ***
forvalue i = 1/11 {
	
	preserve 
	
	*** restrict sample to agri_6_14 = 1 ***
	keep if agri_6_14 == 1

	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_21_`i' < 0 | agri_6_21_`i' > 20000 
	replace ind_var = 0 if parcelleindex_`i' == . 
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "agri_6_21_`i'"
	rename agri_6_21_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_21_`i'_unreasonable.dta", replace 
	}
	
	restore
}

*** agri_6_22 should be answered when agri_6_14 = 1 ***

forvalue i = 1/11 {
	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_22_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_23 should be answered when agri_6_14 = 1 ***

forvalue i = 1/11 {
	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_23_`i'_missing.dta", replace 
	}
	
	restore
}


*** agri_6_23_o should be answered when agri_6_14 = 1, should be answered when agri_6_23 = 99, should be text ***

forvalue i = 1/11 {
	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_23_o_`i'_missing.dta", replace 
	}
	
	restore
}


*** agri_6_24 should be answered when agri_6_14 = 1, should be answered when agri_6_23 = 1 **

forvalue i = 1/11 {
	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_24_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_25 should be answered when agri_6_14 = 1, should be answered when agri_6_23 = 1 **

forvalue i = 1/11 {
	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_25_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_25_o should be answered when agri_6_14 = 1, should be answered when agri_6_25 == 99, should be text *** 

forvalue i = 1/11 {
	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_25_o_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_26 should be answered when agri_6_14 = 1, should be answered when agri_6_23 = 1 **

forvalue i = 1/11 {
	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_26_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_26_o should be answered when agri_6_14 = 1, should be answered when agri_6_26 == 99, should be text ***

forvalue i = 1/11 {
	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_26_o_`i'_missing.dta", replace 
	}
	
	restore
}


*** agri_6_27 should be answered when agri_6_14 = 1, should be answered when agri_6_23 = 1 and agri_6_27 does not equal 6 ***

forvalue i = 1/11 {
	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_27_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_28 should be answered when agri_6_14 = 1, should be answered when agri_6_23 = 1 and agri_6_26 does not equal 6 ***
*** FLAGGED ***
forvalue i = 1/11 {
	
	preserve 
	
	*** restrict sample to agri_6_14 = 1 and agri_6_23 = 1 and agri_6_26 != 6 ***
	keep if agri_6_14 == 1 & agri_6_23_`i' == 1 & agri_6_26_`i' != 6
		
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_28_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_29 should be answered when agri_6_14 = 1, should be answered when agri_6_23 = 1 and agri_6_28 = 1 ***

forvalue i = 1/11 {
	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_29_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_29_o should be answered when agri_6_29 = 99, should be text *** 

forvalue i = 1/11 {
	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_29_o_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_30 should be answered when agri_6_14 = 1 *** 

forvalue i = 1/11 {
	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_30_`i'_missing.dta", replace 
	}
	
	restore
}


*** agri_6_31 should be answered when agri_6_14 = 1, should be answered when agri_6_30 = 1 ***

forvalue i = 1/11 {
	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_31_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_31_o should be answered when agri_6_14 = 1, should be answered when agri_6_31 == 99, should be text *** 

forvalue i = 1/11 {
	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_31_o_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_32 should be answered when agri_6_14 = 1, should be answered when agri_6_31 = 3, should be between 0 and 1000*** 

forvalue i = 1/11 {
	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_32_`i'_unreasonable.dta", replace 
	}
	
	restore
}

*** agri_6_33 should be answered when agri_6_14 = 1, should be answered when agri_6_31 = 3 *** 

forvalue i = 1/11 {
	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_33_`i'_missing.dta", replace 
	}
	
	restore
}

*** 18.	Agri_6_33_o should be answered when agri_6_33 = 99, should be text *** 

forvalue i = 1/11 {
	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_33_o_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_34_comp should be answered when agri_6_14 = 1 *** 

forvalue i = 1/11 {
	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_34_comp_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_34 should be answered when agri_6_14 = 1 *** 

forvalue i = 1/11 {
	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_34_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_35 should be answered when agri_6_14 = 1, should be answered when agri_6_34 = 1, should be between 0 and 50 ***

forvalue i = 1/11 {
	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_35_`i'_unreasonable.dta", replace 
	}
	
	restore
}

*** agri_6_36 should be answered when agri_6_14 = 1 ***

forvalue i = 1/11 {
	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_36_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_37 should be answered when agri_6_14 = 1, should be answered when agri_6_36 = 1, should be between 0 and 50 ***

forvalue i = 1/11 {
	
	preserve 
	
	*** restrict sample to agri_6_14 = 1 and agri_6_36 = 1 ***
	keep if agri_6_14 == 1 & agri_6_36_`i' == 1
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_37_`i' < 0 | agri_6_37_`i' > 50 
	replace ind_var = 0 if parcelleindex_`i' == . 
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "agri_6_37_`i'"
	rename agri_6_37_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_37_`i'_unreasonable.dta", replace 
	}
	
	restore
}

*** agri_6_38_a should be answered when agri_6_14 = 1, should be between 0 and 1000 ***
*** FLAGGED ***
forvalue i = 1/11 {
	
	preserve 
	
	*** restrict sample to agri_6_14 = 1 ***
	keep if agri_6_14 == 1 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_38_a_`i' < 0 | agri_6_38_a_`i' > 1000 
	replace ind_var = 0 if parcelleindex_`i' == . 
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "agri_6_38_a_`i'"
	rename agri_6_38_a_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_38_a_`i'_unreasonable.dta", replace 
	}
	
	restore
}

*** agri_6_38_a_code should be answered when agri_6_14 = 1 ***
*** FLAGGED ***
forvalue i = 1/11 {
	
	preserve 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_14 == 1 & agri_6_38_a_code_`i' == . 
	replace ind_var = 0 if parcelleindex_`i' == . 
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_6_38_a_code_`i'"
	rename agri_6_38_a_code_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_38_a_code_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_38_a_code_o should be answered when agri_6_14 = 1, should be answered when agri_6_38_a_code = 99, should be text ***

forvalue i = 1/11 {
	
	preserve 
	
	*** restrict sample to agri_6_14 = 1 & agri_6_38_a_code = 99 ***
	keep if agri_6_14 == 1 & agri_6_38_a_code_`i' == 99
	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_38_a_code_o_`i'_missing.dta", replace 
	}
	
	restore
}


*** agri_6_39_a should be answered when agri_6_14 = 1, should be between 0 and 1000 ***
*** FLAGGED ***
forvalue i = 1/11 {
	
	preserve 
	
	*** restrict sample to agri_6_14 = 1 ***
	keep if agri_6_14 == 1 
	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_39_a_`i'_unreasonable.dta", replace 
	}
	
	restore
}

*** agri_6_39_a_code should be answered when agri_6_14 = 1 *** 

forvalue i = 1/11 {
	
	preserve 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_14 == 1 & agri_6_39_a_code_`i' == . 
	replace ind_var = 0 if parcelleindex_`i' == . 
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_6_39_a_code_`i'"
	rename agri_6_39_a_code_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_39_a_code_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_39_a_code_o should be answered when agri_6_14 = 1, should be answered when agri_6_39_a_code = 99, should be text ***

forvalue i = 1/11 {
	
	preserve 
	
	*** restrict sample to agri_6_14 = 1 & agri_6_38_a_code = 99 ***
	keep if agri_6_14 == 1 & agri_6_39_a_code_`i' == 99
	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_39_a_code_o_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_40_a should be answered when agri_6_14 = 1, should be between 0 and 1000 ***
*** FLAGGED ***
forvalue i = 1/11 {
	
	preserve 
	
	*** restrict sample to agri_6_14 = 1 ***
	keep if agri_6_14 == 1 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_40_a_`i' < 0 | agri_6_40_a_`i' > 1000 
	replace ind_var = 0 if parcelleindex_`i' == . 
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "agri_6_40_a_`i'"
	rename agri_6_40_a_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_40_a_`i'_unreasonable.dta", replace 
	}
	
	restore
}

*** agri_6_40_a_code should be answered when agri_6_14 = 1 ***
*** FLAGGED ***
forvalue i = 1/11 {
	
	preserve 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_14 == 1 & agri_6_40_a_code_`i' == . 
	replace ind_var = 0 if parcelleindex_`i' == . 
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_6_40_a_code_`i'"
	rename agri_6_40_a_code_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_40_a_code_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_40_a_code_o should be answered when agri_6_14 = 1, should be answered when agri_6_40_a_code = 99, should be text ***

forvalue i = 1/11 {
	
	preserve 
	
	*** restrict sample to agri_6_14 = 1 & agri_6_38_a_code = 99 ***
	keep if agri_6_14 == 1 & agri_6_40_a_code_`i' == 99
	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_40_a_code_o_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_41_a should be answered when agri_6_14 = 1, should be between 0 and 1000 **
*** FLAGGED ***
forvalue i = 1/11 {
	
	preserve 
	
	*** restrict sample to agri_6_14 = 1 ***
	keep if agri_6_14 == 1 
	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_41_a_`i'_unreasonable.dta", replace 
	}
	
	restore
}

*** agri_6_41_a_code should be answered when agri_6_14 = 1 ***
*** FLAGGED ***
forvalue i = 1/11 {
	
	preserve 
	
	*** generate indicator variable *** 
	gen ind_var = 0 
	replace ind_var = 1 if agri_6_14 == 1 & agri_6_41_a_code_`i' == . 
	replace ind_var = 0 if parcelleindex_`i' == . 
	
	*** keep and add variables to export *** 
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_6_41_a_code_`i'"
	rename agri_6_41_a_code_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$agriculture_inputs\Issue_agri_6_41_a_code_`i'_missing.dta", replace 
	}
	
	restore
}

*** agri_6_41_a_code_o should be answered when agri_6_14 = 1, should be answered when agri_6_41_a_code = 99, should be text ***

forvalue i = 1/11 {
	
	preserve 
	
	*** restrict sample to agri_6_14 = 1 & agri_6_41_a_code = 99 ***
	keep if agri_6_14 == 1 & agri_6_41_a_code_`i' == 99
	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "cereals_02_`i'"
	rename cereals_02_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "cereals_03_`i'"
	rename cereals_03_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "cereals_04_`i'"
	rename cereals_04_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "cereals_05_`i'"
	rename cereals_05_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "farines_01_`i'"
	rename farines_01_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "farines_02_`i'"
	rename farines_02_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "farines_04_`i'"
	rename farines_04_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "legumes_01_`i'"
	rename legumes_01_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "legumes_02_`i'"
	rename legumes_02_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "legumes_03_`i'"
	rename legumes_03_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "legumes_04_`i'"
	rename legumes_04_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "legumes_05_`i'"
	rename legumes_05_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "legumineuses_01_`i'"
	rename legumineuses_01_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "legumineuses_02_`i'"
	rename legumineuses_02_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "aquatique_01"
	rename aquatique_01 print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "aquatique_02"
	rename aquatique_02 print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "aquatique_05"
	rename aquatique_05 print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	
	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "o_culture_04"
	rename o_culture_04 print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
// 	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "agri_income_03" 
	rename agri_income_03 print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "agri_income_05" 
	rename agri_income_05 print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable value"
	generate issue_variable_name = "agri_income_06" 
	rename agri_income_06 print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$income\Issue_species_o_missing.dta", replace 
	}

restore 

*** viii. agri_income_09 should be answered when agri_income_08 is greater than 0 ***
forvalues i = 1/6 {
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
	save "$income\Issue_agri_income_09_`i'_missing.dta", replace 
	}
	restore

}

*** ix. agri_income_09_o should be answered when agri_income_09 = 7, should be text ***
forvalues i = 1/6 {
	preserve 
	
	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_09_`i' == 7 & agri_income_09_o_`i' == "."
	
	*** keep and add variables to export 
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_income_09_o_`i'"
	rename agri_income_09_o_`i' print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
	save "$income\Issue_agri_income_09_o_`i'_missing.dta", replace 
	}
	restore

}

*** x. agri_income_10 should be answered when agri_income_08 is greater than 0 ***
*** should be between 0 and 1000000 ***
forvalues i = 1/6 {
	preserve 
	
	*** limit sample to agri_income_08 > 0 ***
	keep if agri_income_08_`i' > 0 & agri_income_08_`i' != .
	
	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_10_`i' < 0 | agri_income_10_`i' > 1000000
	
	*** keep and add variables to export 
	keep if ind_var == 1 
	generate issue = "Unreasonable"
	generate issue_variable_name = "agri_income_10_`i'"
	rename agri_income_10_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$income\Issue_animals_sales_t_missing.dta", replace 
	}

restore 

*** xvii. agri_income_13_autre should be answered when agri_income_13 = 99, should be text ***

** agri_income_13_1 is a string 
	
forvalues i = 1/5 {
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$income\Issue_agri_income_13_autre_`i'_missing.dta", replace 
	}
	
	restore
}

*** check that agri_income_11 is not missing ***
forvalues i = 1/5 {
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$income\Issue_agri_income_11_o_unreasonable.dta", replace 
	}

restore

*** check that agri_income_12 is not missing ***
forvalues i = 1/5 {
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$income\Issue_agri_income_12_o_unreasonable.dta", replace 
	}

restore

*** check that agri_income_13 is not missing ***
forvalues i = 1/5 {
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$income\Issue_agri_income_13_`i'_unreasonable.dta", replace 
	}

	restore
} 


*** xx.	agri_income_13_o should be answered when animals_sales_o = 1 ***

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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$income\Issue_agri_income_13_o_missing.dta", replace 
	}

restore

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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable"
	generate issue_variable_name = "agri_income_16"
	rename agri_income_16 print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$income\Issue_agri_income_16_unreasonable.dta", replace 
	}

restore

*** xxiv.	agri_income_18 should be answered when agri_income_15 = 1 *** 

preserve 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_15 == 1 & agri_income_18 == .

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_income_18"
	rename agri_income_18 print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$income\Issue_agri_income_18_missing.dta", replace 
	}

restore

*** xxv.	agri_income_18_o should be answered when agri_income_18 = 3, should be text  ***

preserve 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_18 == 3 & agri_income_18_o == "."

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_income_18_o"
	rename agri_income_18_o print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable"
	generate issue_variable_name = "agri_income_19"
	rename agri_income_19 print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable"
	generate issue_variable_name = "agri_income_29"
	rename agri_income_29 print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable"
	generate issue_variable_name = "agri_income_33"
	rename agri_income_33 print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$income\Issue_agri_income_35_missing.dta", replace 
	}

restore

*** xlii.	agri_income_36 should be answered when agri_income_34 = 1, should be between 0 and 100000000 ***

forvalues i = 1/4 {
	preserve 

	*** limit sample to agri_income_34 = 1 ***
	keep if agri_income_34 == 1  

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_36_`i' < 0 | agri_income_36_`i' > 10000000
	replace ind_var = 0 if credit_askindex_`i' == . 

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable"
	generate issue_variable_name = "agri_income_36_`i'"
	rename agri_income_36_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$income\Issue_agri_income_36_`i'_unreasonable.dta", replace 
	}

	restore
}

*** xliii.	agri_income_37 should be answered when agri_income_34 = 1, should be text  *** 

forvalues i = 1/4 {
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$income\Issue_agri_income_37_`i'_missing.dta", replace 
	}

	restore
}

*** xliv.	agri_income_38 should be answered when agri_income_34 = 1, should be less than agri_income_36 *** 
 
forvalues i = 1/4 {
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$income\Issue_agri_income_38_`i'_unreasonable.dta", replace 
	}

	restore
}

*** xlv.	agri_income_39 should be answered when agri_income_34 = 1, should be less than agri_income_36, agri_income_36 – agri_income_38 should be greater than agri_income_39   *** 

forvalues i = 1/4 {
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$income\Issue_agri_income_39_`i'_unreasonable.dta", replace 
	}

	restore
}

*** xlvi.	agri_loan_name should be answered when agri_income_40 = 1 *** 

preserve 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_40 == 1 & agri_loan_name == "."

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "agri_loan_name"
	rename agri_loan_name print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$income\Issue_agri_loan_name_missing.dta", replace 
	}

restore

*** xlvii.	agri_income_41 should be answered when agri_income_40 = 1, should between 0 and 10000000  *** 

forvalues i = 1/2 {
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$income\Issue_agri_income_41_`i'_unreasonable.dta", replace 
	}

	restore
}

***  xlviii.	agri_income_42 should be answered when agri_income_40 = 1, should be less than agri_income_41   *** 

forvalues i = 1/2 {
	preserve 

	*** limit sample to agri_income_40 = 1 ***
	keep if agri_income_40 == 1  

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if agri_income_42_`i' > agri_income_41_`i'
	replace ind_var = 0 if loanindex_`i' == . 

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Unreasonable"
	generate issue_variable_name = "agri_income_42_`i'"
	rename agri_income_42_`i' print_issue 
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$income\Issue_agri_income_42_`i'_unreasonable.dta", replace 
	}

	restore
}

*** xlix.	agri_income_43 should be answered when agri_income_40 = 1, should be less than agri_income_41  *** 

forvalues i = 1/2 {
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$income\Issue_agri_income_43_`i'_unreasonable.dta", replace 
	}

	restore
}

*** DROPPED VAR ***

// *** check if agri_income_44 is missing ***
// forvalues i = 1/2 {
// 	preserve 
//
// 	*** limit sample to agri_income_40 = 1 ***
// 	keep if agri_income_40 == 1  
//
// 	*** generate indicator variable ***
// 	gen ind_var = 0 
// 	replace ind_var = 1 if agri_income_44_`i' == .
// 	replace ind_var = 0 if loanindex_`i' == . 
//
// 	*** keep and add variables to export ***
// 	keep if ind_var == 1 
// 	generate issue = "Missing"
// 	generate issue_variable_name = "agri_income_44_`i'"
// 	rename agri_income_44_`i' print_issue 
// 	tostring(print_issue), replace 
// 	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
// 	if _N > 0 {
// 		save "$income\Issue_agri_income_44_`i'.dta", replace 
// 	}
//
// 	restore
// }

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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$income\Issue_animals_sales_o.dta", replace 
	}

	restore		

*** l.	agri_income_46_o should be answered when agri_income_46 = 4, should be text *** 
forvalues i = 1/11 {
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$income\Issue_expenses_goods_o_missing.dta", replace 
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$standard_living\Issue_living_03_missing.dta", replace 
	}

restore 

*** living_03_o should be answered when living_03 == 99, should be text *** 

preserve 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if living_03 == 99 & living_03_o == "."

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "living_03_o" 
	rename living_03_o print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$standard_living\Issue_living_03_o_missing.dta", replace 
	}

restore 

*** living_04_o should be answered when living_04 == 99, should be text *** 

preserve 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if living_04 == 99 & living_04_o == "."

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "living_04_o" 
	rename living_04_o print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$standard_living\Issue_living_05_o_missing.dta", replace 
	}

restore 

*** living_06_o should be answered when living_06 == 99, should be text *** 

preserve 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if living_06 == 99 & living_06_o == "."

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "living_06_o" 
	rename living_06_o print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$standard_living\Issue_living_06_o_missing.dta", replace 
	}

restore 

******************* Public Goods Games Checks ************************

*** montant_07 should be answered when montant_05 is less than 200 ***
preserve 

	*** Generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if montant_05 < 200 & montant_05 != . & montant_07 == . 

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "montant_07" 
	rename montant_07 print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$public_goods\Issue_montant_07_missing.dta", replace 
	}

restore 

*** montant_08 should be answered when montant_05 is greater than 200 ***
preserve 

	*** Generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if montant_05 >= 200 & montant_05 != . & montant_08 == . 

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "montant_08" 
	rename montant_08 print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$public_goods\Issue_montant_08_missing.dta", replace 
	}

restore 

*** face_06 should be answered when face_04 is less than 200 ***
preserve 

	*** Generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if face_04 < 200 & face_04 != . & face_06 == . 

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "face_06" 
	rename face_06 print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$public_goods\Issue_face_06_missing.dta", replace 
	}

restore 

*** face_07 should be answered when face_04 is greater than 200 ***
preserve 

	*** Generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if face_04 >= 200 & face_04 != . & face_07 == . 

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "face_07" 
	rename face_07 print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$public_goods\Issue_face_07_missing.dta", replace 
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	if _N > 0 {
		save "$enum_observations\Issue_enum_04_o_missing.dta", replace 
	}

restore 

*** enum_05_o should be answered when enum_05 == 99, should be text *** 

preserve 

	*** generate indicator variable ***
	gen ind_var = 0 
	replace ind_var = 1 if enum_05 == 99 & enum_05_o == "."

	*** keep and add variables to export ***
	keep if ind_var == 1 
	generate issue = "Missing"
	generate issue_variable_name = "enum_05_o" 
	rename enum_05_o print_issue
	tostring(print_issue), replace 
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	
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
	keep villageid hhid sup enqu sup_name enqu_name hh_phone hh_head_name_complet hh_name_complet_resp issue_variable_name issue print_issue
	
    * Export the dataset to Excel conditional on there being an issue
    if _N > 0 {
        save "$beliefs\Issue_beliefs_09.dta", replace
    }
  
    restore	