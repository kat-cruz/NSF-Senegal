*** DISES Midline Data Checks Houseold Survey Question file ***
*** File originally created By: Kateri Mouawad  ***
*** Updates recorded in GitHub ***

*>>>>>>>>>>*===========================* READ ME *===========================*<<<<<<<<<<<*


			*1)	This generates a dataframe that contains the survey variable names and their coresponding survey questions 
			*2)	This will be merged with every check we run to include this information with the output for CRDES to make corrections faster

*==============================================================================

clear all
set mem 100m
set maxvar 30000
set matsize 11000
set more off
set obs 1  // Create one observation  


*==============================================================================


* Set base Box path for each user
if "`c(username)'"=="socrm" global master "C:\Users\socrm\Box"
if "`c(username)'"=="kls329" global master "C:\Users\kls329\Box"
if "`c(username)'"=="km978" global master "C:\Users\km978\Box\NSF Senegal"
if "`c(username)'"=="Kateri" global master "C:\Users\Kateri\Box\NSF Senegal"
if "`c(username)'"=="admmi" global master "C:\Users\admmi\Box\NSF Senegal"



*==============================================================================

global issuesOriginal "$master\Data Management\Output\Data Quality Checks\Midline\_Original_Issues_Output"

*==============================================================================
**************************** generate variables ****************************


gen village_select  =   "Selectionnez le village pour le questionnaire menage"  
gen village_select_o  =   "Nom du village"  
gen hhid_village  =   "Village ID"  
gen consent  =   "Acceptez-vous de faire l'interview et de participier a l'etude"  
gen hh_numero  =   "Nombre de membres dans le menage"  
gen hh_phone  =   "Numero de telephone du menage (ou numero de telephone d'un membre du menage)"  
gen hh_head_name_complet  =   "Nom et prenom du chef du menage"  
gen hh_name_complet_resp  =   "Nom et prenom du repondant"  
gen hh_age_resp  =   "Age du repondant"  
gen hh_gender_resp  =   "Sexe du repondant"  
gen attend_training  =   "Avez-vous assisté à la formation que notre équipe a organisée en [MOIS] 2024 sur l'élimination de la plante aquatique cerat"  
gen who_attended_training  =   "Est-ce que une autre membre de ce menage a assiste a la formation que notre équipe a organisée en [MOIS] 2024 sur l'élimination de la plante aquatique cerato [REMPLACER par le nom local, naithe ?] ?"  
gen training_id  =   "Qui a assiste a la formation (selectionnez de la liste du membres du menage)"  
gen heard_training  =   "Avez-vous entendu parler de la formation menées par le projet ?"  
gen hh_date =  "Date"  
gen hh_time =  "Heure"  

*** labels for household members - loop through all member numbers ***
*** check the data to ensure this is the maximum number of members in a household ***
forvalues i = 1/57{
/*


	gen hh_first_name_`i' =  "Prenom"
	gen hh_name_`i' =  "Nom"
	gen hh_surname_`i' =  "Surnom"
*/
	gen hh_full_name_calc_`i' =  "Full Name"

// UPDATE VARIALE NAME	gen =  "Cette personne fait-elle toujours partie du ménage ? =  "
// UPDATE VARIALE NAME	gen =  "Pourquoi cette personne n'est-elle pas dans le ménage ?"
// UPDATE VARIALE NAME	gen =  "Y a-t-il d'autres personnes dans le ménage ?"
	gen hh_gender_`i' =  "Genre"

	*gen hh_age_`i' =  "Age"
	gen hh_ethnicity_`i' =  "Ethnicite"
	gen hh_ethnicity_o_`i' =  "Autre ethnie"
	gen hh_relation_with_`i' =  "Relation avec le chef du menage"
	gen hh_relation_with_o_`i' =  "Autre forme de relation"
	gen hh_education_skills_`i' =  "Education - Competences (chiox multiple)"
	gen hh_education_skills_0_`i' =  "Education - Competences - 0 Aucun"
	gen hh_education_skills_1_`i' =  "Education - Competences - 1 Peut ecrire une courte letter a sa famille"
	gen hh_education_skills_2_`i' =  "Education - Competences - 2 A l'aise avec les chiffres et les calculs"
	gen hh_education_skills_3_`i' =  "Education - Competences - 3 Arabisant/peut lire le Coran en arabe"
	gen hh_education_skills_4_`i' =  "Education - Competences - 4 Parle couramment le wolof/pulaar"
	gen hh_education_skills_5_`i' =  "Education - Competences - 5 Peut lire un journal en francais"
	gen hh_education_level_`i' =  "Niveau d'education atteint"
	

	gen hh_education_level_o_`i' =  "Autre niveau"
	gen hh_education_year_achieve_`i' =  "Combien d'annees d'etudes [hh_full_name_calc] a-t-il(elle) acheve(e)"
	gen hh_main_activity_`i' =  "Activite principale en dehors de la maison"
	gen hh_main_activity_o_`i' =  "Autre activite"
	gen hh_mother_live_`i' =  "La mere de [hh_full_name_calc] vivait-elle dans le village le jour de la naissance de [hh_full_name_calc]"
	gen hh_relation_imam_`i' =  "Lien de parente de [hh_full_name_calc] avec l'Imam ou le Chef du village"
	gen hh_presence_winter_`i' =  "Presence en hiver/saison des pluies"
	gen hh_presence_dry_`i' =  "Presence en saison seche"
	gen hh_active_agri_`i' =  "Est-il/elle un travailleur agricle actif"
	gen hh_01_`i' =  "Au cours des 7 derniers jours combien d'heurs [hh_full_name_calc] a consacre aux taches menageres ou a la preparation des repas"
	gen hh_02_`i' =  "Au cours des 7 derniers jours combien d'heurs [hh_full_name_calc] a consacre pour chercher de l'eau"
	gen hh_03_`i' =  "Au cours des 12 derniers mois, [hh_full_name_calc] a-t-il travaille dans le cadre d'activites agricoles domestiques"
	gen hh_04_`i' =  "Au cours des 7 derniers jours, combien d'heures [hh_full_name_calc] a-t-il travaille dans le cadre d'activites agricoles domestiques"
	gen hh_05_`i' =  "Pendant la periode de plantation de la derniere campagne agricole, combien d'heures"
	gen hh_06_`i' =  "Pendant la periode de croissance maximale de la dernière campagne agricole, combien d'heures"
	gen hh_07_`i' =  "Pendant la période de recolte de la dernière campagne agricole, combien de jours"
	gen hh_08_`i' =  "Au cours des 7 derniers jours, combien d'heures [hh_full_name_calc] a t-il consacre pour travailler dans un commerce"
	gen hh_09_`i' =  "Au cours des 7 derniers jours, combien d'heures [hh_full_name_calc] a t-il consacre pour travailler pour une entreprise"
	gen hh_10_`i' =  "Au cours des 12 derniers mois, combien d'heures par semaine en moyenne [hh_full_name_calc] a-t-il passe a moins d'un metre ou dans une source d'eau de surface"
	gen hh_11_`i' =  "Quelle(s) source(s) d'eau de surface?"
	gen hh_11_o_`i' =  "Autre source"
	
	gen hh_12_`i' =  "Au cours des 12 derniers mois, pourquoi [hh_full_name_calc] a-t-il passé du temps près de (< 1 m) ou dans la/les source(s) d'eau?"
	gen hh_12_1_`i' =  "Aller chercher de l'eau pour le menage"
	gen hh_12_2_`i' =  "Donner de l'eau au betail"
	gen hh_12_3_`i' =  "Aller chercher de l'eau pour l'agriculture"
	gen hh_12_4_`i' =  "Laver des vetements"
	gen hh_12_5_`i' =  "Faire la vaisselle"
	gen hh_12_6_`i' =  "Recolter de la vegetation aquatique"
	gen hh_12_7_`i' =  "Nager/se baigner"
	gen hh_12_8_`i' =  "Jouer"
	gen hh_12_a_`i' =  "Est-ce qu'il a d'autres raisons pour laquelle [hh_full_name_calc] a-t-il passe du temps pres de (< 1 m) ou dans la/les source(s) d'eau?"
	gen hh_12_o_`i' =  "Autre a preciser"
	gen hh_13_`i'_1 =  "Au cours des 12 derniers mois, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_12 = 1 pres de (< 1 m) ou dans la/les source(s) d'eau?"
	gen hh_13_`i'_2 =  "Au cours des 12 derniers mois, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_12 = 2 pres de (< 1 m) ou dans la/les source(s) d'eau?"
	gen hh_13_`i'_3 =  "Au cours des 12 derniers mois, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_12 = 3 pres de (< 1 m) ou dans la/les source(s) d'eau?"
	gen hh_13_`i'_4 =  "Au cours des 12 derniers mois, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_12 = 4 pres de (< 1 m) ou dans la/les source(s) d'eau?"
	gen hh_13_`i'_5 =  "Au cours des 12 derniers mois, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_12 = 5 pres de (< 1 m) ou dans la/les source(s) d'eau?"
	gen hh_13_`i'_6 =  "Au cours des 12 derniers mois, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_12 = 6 pres de (< 1 m) ou dans la/les source(s) d'eau?"
**# Bookmark #6
	*gen hh_13_`i'_7 =  "Au cours des 12 derniers mois, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_12 = 7 pres de (< 1 m) ou dans la/les source(s) d'eau?"
	gen hh_13_o_`i' =  "Au cours des 12 derniers mois, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a [hh_12_o] pres de (< 1 m) ou dans la/les source(s) d'eau"
	gen hh_14_`i' =  "Au cours des 12 derniers mois, combien de vegetation aquatique a-t-il/elle recolte pres de (< 1 m) ou dans la/les source(s) d'eau par semaine, en moyenne (en kg)"
	gen hh_15_`i' =  "Comment a-t-il utilise la vegetation aquatique"
	gen hh_15_o_`i' =  "Autre a preciser"
	gen hh_16_`i' =  "Au cours des 12 derniers mois combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a la production d'engrais, son achat, ou son application sur le champ"
	gen hh_17_`i' =  "Au cours des 12 derniers mois combien d'heures [hh_full_name_calc] a t-il consacre a la production d'aliments pour le betail par semaine en moyenne"
	gen hh_18_`i' =  "Au cours des 7 derniers jours combien d'heures [hh_full_name_calc] a-t-il passe pres de (< 1 m) ou dans une source d'eau de surface"
	gen hh_19_`i' =  "Quelle(s) source(s) d'eau de surface"
	gen hh_19_o_`i' =  "Autre a preciser"
	
	gen hh_20_`i' =  "Au cours des 7 derniers jours, pourquoi [hh_full_name_calc] a-t-il passe du temps pres de (< 1 m) ou dans la/les source(s) d'eau"
	gen hh_20_1_`i' =  "Aller chercher de l'eau pour le menage"
	gen hh_20_2_`i' =  "Donner de l'eau au betail"
	gen hh_20_3_`i' =  "Aller chercher de l'eau pour l'agriculture"	
	gen hh_20_4_`i' =  "Laver des vetements"
	gen hh_20_5_`i' =  "Faire la vaisselle"
	gen hh_20_6_`i' =  "Recolter de la vegetation aquatique"
	gen hh_20_7_`i' =  "Nager/se baigner"
	gen hh_20_8_`i' =  "Jouer"
	gen hh_20_a_`i' =  "Est-ce qu'il a d'autres raisons pour laquelle [hh_full_name_calc] a-t-il passe du temps pres de (< 1 m) ou dans la/les source(s) d'eau"
	gen hh_20_o_`i' =  "Autre a preciser"
	gen hh_21_`i'_1 =  "Au cours des 7 derniers jours, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_20 = 1 pres de (< 1 m) ou dans la/les source(s) d'eau?"
	gen hh_21_`i'_2 =  "Au cours des 7 derniers jours, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_20 = 2 pres de (< 1 m) ou dans la/les source(s) d'eau?"
	gen hh_21_`i'_3 =  "Au cours des 7 derniers jours, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_20 = 3 pres de (< 1 m) ou dans la/les source(s) d'eau?"
	gen hh_21_`i'_4 =  "Au cours des 7 derniers jours, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_20 = 4 pres de (< 1 m) ou dans la/les source(s) d'eau?"
	gen hh_21_`i'_5 =  "Au cours des 7 derniers jours, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_20 = 5 pres de (< 1 m) ou dans la/les source(s) d'eau?"
	gen hh_21_`i'_6 =  "Au cours des 7 derniers jours, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_20 = 6 pres de (< 1 m) ou dans la/les source(s) d'eau?"
**# Bookmark #7
	*gen hh_21_`i'_7 =  "Au cours des 7 derniers jours, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a hh_20 = 7 pres de (< 1 m) ou dans la/les source(s) d'eau?"
	gen hh_21_o_`i' =  "Au cours des 7 derniers jours, combien d'heures par semaine en moyenne [hh_full_name_calc] a t-il consacre a [hh_20_o] pres de (< 1 m) ou dans la/les source(s) d'eau"
	gen hh_22_`i' =  "Au cours des 7 derniers jours, combien de vegetation aquatique a-t-il/elle recolte pres de (< 1 m) ou dans la/les source(s) d'eau (en kg)"
	gen hh_23_`i' =  "Comment a-t-il utilise la vegetation aquatique"
	gen hh_23_1_`i' =  "Vendre"
	gen hh_23_2_`i' =  "Engrais"
	gen hh_23_3_`i' =  "Alimentation pour le betail"
	gen hh_23_4_`i' =  "Matiere premiere pour le biodigesteur"
	gen hh_23_5_`i' =  "Rien"
	gen hh_23_99_`i' =  "Autre"
	gen hh_23_o_`i' =  "Autre a preciser"
	gen hh_24_`i' =  "Au cours des 7 derniers jours combien d'heures [hh_full_name_calc] a t-il consacre a la production d'engrais, son achat, ou son application sur le champ?"
	gen hh_25_`i' =  "Au cours des 7 derniers jours combien d'heures [hh_full_name_calc] a t-il consacre a la production d'aliments pour le betail"
	gen hh_26_`i' =  "[hh_full_name_calc] a-t-il fait ou fait-il des etudes actuellement dans une ecole formelle"
	gen hh_27_`i' =  "Est ce que [hh_full_name_calc] a suivi une ecole non formelle ou une formation non-formelle"
	gen hh_28_`i' =  "Quel type d'education non-formelle [hh_full_name_calc] a frequente"
	gen hh_29_`i' =  "Quel est le niveau et la classe les plus eleves que [hh_full_name_calc] a reussi a l'ecole"
//	gen hh_29_o_`i' =  "Autre a preciser"
	gen hh_30_`i' =  "[hh_full_name_calc] a-t-il frequente une ecole au cours de la derniere annee scolaire 2022-23"
	gen hh_31_`i' =  "Quel resultat [hh_full_name_calc] a-t-il obtenu au cours de l'annee 2022/2023"
	gen hh_32_`i' =  "Est-ce que [hh_full_name_calc] frequente une ecole au cours de la presente annee scolaire 2023/2024"
//	gen hh_33_`i' =  "En ce qui concerne les autres eleves de sa classe, pensez-vous que la performance academique de [hh_full_name_calc] est inferieure a celle de la plupart des eleves, a peu pres la meme que celle de la plupart des eleves, ou superieure a celle de la plupart des eleves"
	gen hh_34_`i' =  "Quel age avait [hh_full_name_calc] quand il (elle) a cesse d'aller a l'ecole"
	gen hh_35_`i' =  "Quelle est le niveau et la classe frequentee par [hh_full_name_calc] au cours de l'annee 2023/2024"
	gen hh_36_`i' =  "Pensez-vous que [hh_full_name_calc] reussira son niveau scolaire declare au course de l'annee 2023/2024"
	gen hh_37_`i' =  "Au cours des 12 derniers mois, [hh_full_name_calc] a-t-il deja manque plus d'une semaine consecutive d'ecole pour cause de maladie"
	gen hh_38_`i' =  "Au cours des 7 derniers jours, combien de jours [hh_full_name_calc] est-il alle a l'ecole pour suivre des cours"
	gen hh_39_`i' =  "Qui est la mère ou la belle-mère de cet enfant ? Sélectionnez dans la liste ou ajoutez des catégories supplémentaires : (i) décédée ou (ii) vivante mais ne résidant pas dans le ménage avec l'enfant"
	gen hh_40_`i' =  "Qui est le père ou le beau-père de cet enfant ? Sélectionnez dans la liste ou ajoutez des catégories supplémentaires : (i) décédé ou (ii) vivant mais ne résidant pas dans le ménage avec l'enfant"
	gen hh_41_`i' =  "Quel âge avait [NOM] quand il (elle) est entré (e) à l'école?"
	gen hh_42_`i' =  "[NOM] fréquente-t-il l'école aujourd'hui ?"
	gen hh_43_`i' =  "Quand [NOM] fréquente-t-il l'école aujourd'hui ?"
	gen hh_44_`i' =  "L'enfant est-il à la maison ?"
	gen hh_45_`i' =  "Enquêteur : Observez-vous vous-même l'enfant à la maison ?"
	gen hh_46_`i' =  "Quelle est la raison principale pour laquelle l'enfant ne fréquente pas l'école aujourd'hui ?"
	
**# Bookmark #8
	*gen hh_47_`i' =  "Combien a été dépensé pour l'éducation de [NOM] au cours des 12 derniers mois par le ménage, la famille et les amis ?"
	gen hh_48_`i' =  "[NOM] a-t-il été testé pour la bilharziose à l'école ?"
**# Bookmark #10
	*gen hh_49_`i' =  "Consentement pour la vérification de la fréquentation scolaire"	
}

*** knowledge section ***
gen knowledge_01 =  "Avez-vous deja entendu parler de la bilharziose"
gen knowledge_02 =  "Pouvez-vous nous dire en termes simples ce qu'est la bilharziose"
gen knowledge_03 =  "Pensez-vous que la bilharziose est une maladie"
gen knowledge_04 =  "Si vous pensez que la bilharziose est une maladie, pensez-vous qu'il s'agit d'une maladie grave"
gen knowledge_05 =  "Quelle est la cause de la bilharziose"
gen knowledge_05_o =  "Autre cause"
gen knowledge_06 =  "A votre avis, comment savez-vous si une personne est atteinte de bilharziose"
gen knowledge_06_1 =  "Lorsq'ils ont de la fievre"
gen knowledge_06_2 =  "En cas de diarrhee"
gen knowledge_06_3 =  "En cas de douleurs a l'estomac"
gen knowledge_06_4 =  "En cas de sang dans les urines"
gen knowledge_06_5 =  "En cas de demangeaisons"
gen knowledge_06_6 =  "Je ne sais pas si c'est le cas"
gen knowledge_07 =  "Savez-vous s'il existe un test a l'hopital pour detecter la bilharziose chez un individu"
gen knowledge_08 =  "Si oui, lequel"
gen knowledge_09 =  "Comment une personne peut-elle se proteger contre la bilharziose"
gen knowledge_09_1 =  "Eviter d'uriner dans la riviere"
gen knowledge_09_2 =  "Eviter de defequer dans la riviere"
gen knowledge_09_3 =  "Eviter de se rendre a la riviere"
gen knowledge_09_4 =  "Eviter de marcher pieds nus"
gen knowledge_09_5 =  "Dormir sous une moustiquaire"
gen knowledge_09_6 =  "Retirer les plantes des points d'eau"
gen knowledge_09_99 =  "Autre (a preciser)"
gen knowledge_09_o =  "Autre precaution"
gen knowledge_10 =  "Comment peut-on contracter la bilharziose"
gen knowledge_10_1 =  "En marchant pieds nus"
gen knowledge_10_2 =  "En mangeant sans se lever les mains"
gen knowledge_10_3 =  "En allant a la riviere"
gen knowledge_10_4 =  "En buvant l'eau de la riviere"
gen knowledge_10_5 =  "En se faisant piquer par des moustiques"
gen knowledge_10_6 =  "Lors de rapports sexuels avec une personne infectee par la bilharziose"
gen knowledge_10_7 =  "Je ne sais pas"
gen knowledge_10_99 =  "Autre specification"
gen knowledge_10_o =  "Autre"
gen knowledge_11 =  "Pensez-vous que la bilharziose est contagieuse"
gen knowledge_12 =  "Connaissez-vous l'animal qui transmet la bilharziose"
gen knowledge_12_o =  "Autre animal"
gen knowledge_13 =  "Pensez-vous que la bilharziose peut etre guerie sans traitement"
gen knowledge_14 =  "Pensez-vous qu'il existe un medicament pour traiter la bilharziose"
gen knowledge_15 =  "Connaissez-vous un traitement traditionnel pour la bilharziose"
gen knowledge_16 =  "Pensez-vous que ce traitement traditionnel est efficace, qu'il soigne vraiment"
gen knowledge_17 =  "Avez-vous des commentaires sur le traitement de la bilharziose"
gen knowledge_18 =  "Avez-vous ete en contact avec un plan d'eau (lac, riviere, ruisseau, marais, etc.) au cours des 12 derniers mois"
gen knowledge_19 =  "De quel type de plan d'eau s'agissait-il"
gen knowledge_19_o =  "Autre type d'eau"
gen knowledge_20 =  "Ou etes-vous entre en contact avec la masse d'eau"
gen knowledge_20_o =  "Autre lieu"
gen knowledge_21 =  "A quelle frequence"
gen knowledge_22 =  "Quand y etes-vous alle pour la derniere fois"
gen knowledge_23 =  "Quelles sont les raisons pour lesquelles vous avez ete (ou etes) en contact avec le cours d'eau"
gen knowledge_23_1 =  "Pour les taches menageres (vaisselle, lessive, etc.)"
gen knowledge_23_2 =  "Pour aller chercher de l'eau"
gen knowledge_23_3 =  "Pour sa baigner"
gen knowledge_23_4 =  "Jouer"
gen knowledge_23_5 =  "Pecher"
gen knowledge_23_6 =  "Pour mes activites agricoles"
gen knowledge_23_99 =  "Pour d'autres raisons"
gen knowledge_23_o =  "Autre raison"

*** health module indiviudals - this is for member index 1 ***
*** verify maximum number in data set ****
forvalues i = 1/57 {
    gen health_5_2_`i' =  "Est-ce que [health-name] est tombe malade au cours des 12 derniers mois"
	gen health_5_3_`i' =  "De quel type de maladie ou de blessure a-t-il/elle souffert"
	gen health_5_3_1_`i' =  "Paludisme"
	gen health_5_3_2_`i' =  "Bilharzoise"
	gen health_5_3_3_`i' =  "Diarrhee"
	gen health_5_3_4_`i' =  "Blessures"
	gen health_5_3_5_`i' =  "Problemes dentaires"
	gen health_5_3_6_`i' =  "Problemes de peau"
	gen health_5_3_7_`i' =  "Problemes oculaires"
	gen health_5_3_8_`i' =  "Problemes de gorge"
	gen health_5_3_9_`i' =  "Maux d'estomac"
	gen health_5_3_10_`i' =  "Fatigue"
	gen health_5_3_11_`i' =  "IST"
	gen health_5_3_12_`i' =  "trachome"
	gen health_5_3_13_`i' =  "onchocercose"
	gen health_5_3_14_`i' =  "filaroise lymphatique"
	gen health_5_3_99_`i' =  "autres (a preciser)"
	gen health_5_3_o_`i' =  "Autre maladie"
	gen health_5_4_`i' =  "Combien de jours a-t-il/elle manque au travail/a l'ecole en raison d'une maladie ou d'une blessure au cours du dernier mois"
	gen health_5_5_`i' =  "A-t-il/elle recu des medicaments pour le traitement de la schistosomiase au cours des 12 derniers mois"
	gen health_5_6_`i' =  "Cette personne a-t-elle deja ete diagnostiquee avec la schistosomiase"
	gen health_5_7_`i' =  "Cette personne a-t-elle ete affectee par la schistosomiase au cours des 12 derniers mois"
	gen health_5_7_1_`i' =  "Cette personne a-t-elle eu de l'urine avec une coloration rose au cours des 12 derniers mois ?"
	gen health_5_8_`i' =  "Cette personne a-t-elle eu du sang dans ses urines au cours des 12 derniers mois"
	gen health_5_9_`i' =  "Cette personne a-t-elle eu du sang dans ses selles au cours des 12 derniers mois"
	gen health_5_10_`i' =  "Avez-vous consulte quelqu'un pour une maladie au cours des 12 derniers mois"
	gen health_5_11_`i' =  "Quel type de service de sante/professionnel de sante cette personne a-t-elle consulte en premier lieu"
	gen health_5_11_o_`i' =  "Autre type de service de sante"
	gen health_5_12_`i' =  "Quelle est la distance en km qui vous separe de ce service ou de ce professionnel de sante"
}

*** labels for health modules at the household level ***
gen health_5_13 =  "Avez-vous beneficie de campagnes de sensibilisation sur la schistosomiase au cours des cinq dernieres annees"
gen health_5_14_a =  "Manifestation de la bilharzoise"
gen health_5_14_b =  "Pratique pour eviter la bilharzose"
gen health_5_14_c =  "Mesurer a prendre pour le traitement de la bilharziose"

*** Assets module ***
gen list_actifs_1 =  "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Fer a repasser (electrique/non-eletrique)"
gen list_actifs_2 =  "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Machine a coudre"
gen list_actifs_3 =  "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Television"
gen list_actifs_4 =  "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Voiture"
gen list_actifs_5 =  "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Refridgerateur"
gen list_actifs_6 =  "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Radio"
gen list_actifs_7 =  "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Montre/horloge"
gen list_actifs_8 =  "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Lit ou matelas"
gen list_actifs_9 =  "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Velo"
gen list_actifs_10 =  "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Moto"
gen list_actifs_11 =  "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Table"
gen list_actifs_12 =  "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Chaise"
gen list_actifs_13 =  "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Climatiseur"
gen list_actifs_14 =  "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Ordinateur"
gen list_actifs_15 =  "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Telephone portable"
gen list_actifs_16 =  "Avez-vous l'un des objects suivants dans votre foyer aujourd'hui? En etat de marche - Maison"
gen _actif_number_1 =  "Combien de [actifs-name] est-ce que vous avez"
gen _actif_number_2 =  "Combien de [actifs-name] est-ce que vous avez"
gen _actif_number_3 =  "Combien de [actifs-name] est-ce que vous avez"
gen _actif_number_4 =  "Combien de [actifs-name] est-ce que vous avez"
gen _actif_number_5 =  "Combien de [actifs-name] est-ce que vous avez"
gen _actif_number_6 =  "Combien de [actifs-name] est-ce que vous avez"
gen _actif_number_7 =  "Combien de [actifs-name] est-ce que vous avez"
gen _actif_number_8 =  "Combien de [actifs-name] est-ce que vous avez"
gen _actif_number_9 =  "Combien de [actifs-name] est-ce que vous avez"
gen _actif_number_10 =  "Combien de [actifs-name] est-ce que vous avez"
gen _actif_number_11 =  "Combien de [actifs-name] est-ce que vous avez"
gen _actif_number_12 =  "Combien de [actifs-name] est-ce que vous avez"
gen _actif_number_13 =  "Combien de [actifs-name] est-ce que vous avez"
gen _actif_number_14 =  "Combien de [actifs-name] est-ce que vous avez"
gen list_actifs_o =  "Est-ce qu'il y a un autre actif que l'on a pas pris en compte"
gen actifs_o =  "Autre Actifs"
gen actifs_o_int =  "Combien de [actifs_o] est-ce que vous avez"
gen list_agri_equip_1 =  "Votre foyer dispose-t-il aujourd'hui de l'un des equipements suivants? En etat de marche - Charrue"
gen list_agri_equip_2 =  "Votre foyer dispose-t-il aujourd'hui de l'un des equipements suivants? En etat de marche - Arara"
gen list_agri_equip_3 =  "Votre foyer dispose-t-il aujourd'hui de l'un des equipements suivants? En etat de marche - Animaux de traits"
gen list_agri_equip_4 =  "Votre foyer dispose-t-il aujourd'hui de l'un des equipements suivants? En etat de marche - Charrette"
gen list_agri_equip_5 =  "Votre foyer dispose-t-il aujourd'hui de l'un des equipements suivants? En etat de marche - Tracteur"
gen list_agri_equip_6 =  "Votre foyer dispose-t-il aujourd'hui de l'un des equipements suivants? En etat de marche - Pulverisateur"
gen list_agri_equip_7 =  "Votre foyer dispose-t-il aujourd'hui de l'un des equipements suivants? En etat de marche - Groupe Motos Pompes (GMP)"
gen list_agri_equip_8 =  "Votre foyer dispose-t-il aujourd'hui de l'un des equipements suivants? En etat de marche - Houes"
gen list_agri_equip_9 =  "Votre foyer dispose-t-il aujourd'hui de l'un des equipements suivants? En etat de marche - Hilaires"
gen list_agri_equip_10 =  "Votre foyer dispose-t-il aujourd'hui de l'un des equipements suivants? En etat de marche - Daba/faucille"
gen list_agri_equip_11 =  "Votre foyer dispose-t-il aujourd'hui de l'un des equipements suivants? En etat de marche - Semoir"
gen list_agri_equip_12 =  "Votre foyer dispose-t-il aujourd'hui de l'un des equipements suivants? En etat de marche - Kadiandou"
gen list_agri_equip_13 =  "Votre foyer dispose-t-il aujourd'hui de l'un des equipements suivants? En etat de marche - Fanting"
gen list_agri_equip_14 =  "Votre foyer dispose-t-il aujourd'hui de l'un des equipements suivants? En etat de marche - Panneaux solaires"
gen _agri_number_1 =  "Combien de [agri-name] avez-vous eu" 
gen _agri_number_2 =  "Combien de [agri-name] avez-vous eu" 
gen _agri_number_3 =  "Combien de [agri-name] avez-vous eu" 
gen _agri_number_4 =  "Combien de [agri-name] avez-vous eu" 
gen _agri_number_5 =  "Combien de [agri-name] avez-vous eu" 
gen _agri_number_6 =  "Combien de [agri-name] avez-vous eu" 
gen _agri_number_7 =  "Combien de [agri-name] avez-vous eu" 
**# Bookmark #11 - not present
*gen _agri_number_8 =  "Combien de [agri-name] avez-vous eu" 
*gen _agri_number_9 =  "Combien de [agri-name] avez-vous eu" 
*gen _agri_number_10 =  "Combien de [agri-name] avez-vous eu" 
gen list_agri_equip_o =  "Est-ce qu'il y a un autre equipement agricole que l'on n'a pas pris en compte"
gen list_agri_equip_o_t =  "Autre liste"
gen list_agri_equip_int =  "Combien de [list_agri_equip_o_t] avez-vous eu"

*** Agriculture Inputs Module ***
gen agri_6_5 =  "Avez-vous loue la maison ou etes-vous le proprietaire"
gen agri_6_6 =  "Combien de pieces separees le menage possede-t-il"
gen agri_6_7 =  "Un membre de votre menage a-t-il un compte bancaire"
gen agri_6_8 =  "Un membre de votre menage participe-t-il a des mecanismes informels d'epargne et de credit (par exemple, des associations d'epargne et de credit ou des groupes rotatifs d'epargne et de credit)"
gen agri_6_9 =  "Un membre de votre menage fait-il partie d'un groupe de femmes du village"
gen agri_6_10 =  "Avez-vous un compte d'argent mobile (ex. Orange Money, Wave, Tigo Cash, Freemoney, K-PAYE)"
gen agri_6_11 =  "Si vous aviez besoin de 250 000 FCFA d'ici la semaine prochaine (pour une urgence medicale ou une autre dépense imprevue), seriez-vous en mesure de les obtenir"
gen agri_6_12 =  "Comment pourriez-vous obtenir cet argent (reponse a choix multiples)"
gen agri_6_12_1 =  "Emprunt bancaire"
gen agri_6_12_2 =  "Emprunter sur le compte epargne/pret du village (tontine, groupe de preteurs individuels, etc.)"
gen agri_6_12_3 =  "Emprunter aupres de voisins, d'amis ou de parents"
gen agri_6_12_4 =  "Utiliser son propre compte d'epargne"
gen agri_6_12_5 =  "Vendre des recoltes ou du betail"
gen agri_6_12_6 =  "Vendre d'autres biens ou proprietes"
gen agri_6_12_7 =  "Argent de poche/maison"
gen agri_6_12_99 =  " Autre (veuillez preciser)"
gen agri_6_12_o =  "Autre possibilite pour avoir l'argent"
gen agri_6_14 =  "Est-ce qu'au moins un membre du ménage a cultivé de la terre (y compris des cultures pérennes), qu'elle lui appartienne ou non, au cours de la dernière saison de culture"
gen agri_6_15 =  "Combien de parcelles a l'interieur des champs cultives par le menage"

*** parcel questions ****
*** verify maximum in dataset ***
forvalues i=1/5 {
	gen agri_6_16_`i' =  "Ordre de numeration du champ"
	gen agri_6_17_`i' =  "Numero de la parcelle dans le champ"
	gen agri_6_18_`i' =  "Quel est le mode de gestion de la parcelle"
	gen agri_6_19_`i' =  "Quel est le numero d'ordre de la personne qui cultive la parcelle (utiliser les identifiants de la section B sur les caracteristiques demographiques du menage)"
	gen agri_6_20_`i' =  "Quelle est la principale culture pratiquee sur cette parcelle au cours de la derniere periode de vegetation"
	gen agri_6_20_o_`i' =  "Autre culture principale"
	gen agri_6_21_`i' =  "Quelle est la superficie de la parcelle selon l'exploitant ? (Indiquer la superficie en hectares ou en metres carres avec deux decimales)"
	gen agri_6_22_`i' =  "Unite"
	gen agri_6_23_`i' =  "Quel est le mode d'occupation de cette parcelle"
	gen agri_6_23_o_`i' =  "Autre mode d'occupation de cette parcelle"
	gen agri_6_24_`i' =  "Quel est le numero d'ordre du proprietaire de la parcelle"
	gen agri_6_25_`i' =  "Quel est le mode d'acquisition de cette parcelle"
	gen agri_6_25_o_`i' =  "Autre mode d'acquisition de cetter parcelle"
	gen agri_6_26_`i' =  "Disposez-vous d'un document legal (titre, acte, certificat, etc.) confirmant votre propriete sur cette parcelle"
	gen agri_6_26_o_`i' =  "Autre document legal"
	gen agri_6_27_`i' =  "Quels sont les membres du menage figurant sur ce document legal"
	gen agri_6_27_1_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 1"
	gen agri_6_27_2_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 2"
	gen agri_6_27_3_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 3"
	gen agri_6_27_4_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 4"
	gen agri_6_27_5_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 5"
	gen agri_6_27_6_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 6"
	gen agri_6_27_7_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 7"
	gen agri_6_27_8_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 8"
	gen agri_6_27_9_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 9"
	gen agri_6_27_10_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 10"
	gen agri_6_27_11_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 11"
	gen agri_6_27_12_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 12"
	gen agri_6_27_13_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 13"
	gen agri_6_27_14_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 14"
	gen agri_6_27_15_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 15"
	gen agri_6_27_16_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 16"
	gen agri_6_27_17_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 17"
	gen agri_6_27_18_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 18"
	gen agri_6_27_19_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 19"
	gen agri_6_27_20_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 20"
	gen agri_6_27_21_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 21"
	gen agri_6_27_22_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 22"
	gen agri_6_27_23_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 23"
	gen agri_6_27_24_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 24"
	gen agri_6_27_25_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 25"
	gen agri_6_27_26_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 26"
	gen agri_6_27_27_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 27"
	gen agri_6_27_28_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 28"
	gen agri_6_27_29_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 29"
	gen agri_6_27_30_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 30"
	gen agri_6_27_31_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 31"
	gen agri_6_27_32_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 32"
	gen agri_6_27_33_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 33"
	gen agri_6_27_34_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 34"
	gen agri_6_27_35_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 35"
	gen agri_6_27_36_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 36"
	gen agri_6_27_37_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 37"
	gen agri_6_27_38_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 38"
	gen agri_6_27_39_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 39"
	gen agri_6_27_40_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 40"
	gen agri_6_27_41_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 41"
	gen agri_6_27_42_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 42"
	gen agri_6_27_43_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 43"
	gen agri_6_27_44_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 44"
	gen agri_6_27_45_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 45"
	gen agri_6_27_46_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 46"
	gen agri_6_27_47_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 47"
	gen agri_6_27_48_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 48"
	gen agri_6_27_49_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 49"
	gen agri_6_27_50_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 50"
	gen agri_6_27_51_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 51"
	gen agri_6_27_52_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 52"
	gen agri_6_27_53_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 53"
	gen agri_6_27_54_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 54"
	gen agri_6_27_55_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 55"
	gen agri_6_27_56_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 56"
	gen agri_6_27_57_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 57"
	gen agri_6_27_58_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 58"
	gen agri_6_27_59_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 59"
	gen agri_6_27_60_`i' =  "Quels sont les membres du menage figurant sur ce document legal - membre 60"
	gen agri_6_28_`i' =  "Pensez-vous qu'il existe un risque de perdre les droits associes a cette parcelle dans les 5 prochaines annees"
	gen agri_6_29_`i' =  "Quelle est la principale preoccupation"
	gen agri_6_29_o_`i' =  "Autre type de preoccupation"
	gen agri_6_30_`i' =  "Avez-vous utilise du fumier animal sur cette parcelle au cours de cette campagne agricole"
	gen agri_6_31_`i' =  "Quelle a ete la principale methode d'acquisition de ce fumier"
	gen agri_6_31_o_`i' =  "Autre methode d'acquisition de l'animale"
	gen agri_6_32_`i' =  "Quelle quantite de fumier avez-vous appliquee sur la parcelle"
	gen agri_6_33_`i' =  "Code Unite"
	gen agri_6_33_o_`i' =  "Autre type de quantite"
	gen agri_6_34_comp_`i' =  "Avez-vous utilise du compost sur cette parcelle durant cette campagne"
	gen agri_6_34_`i' =  "Avez-vous utilise des dechets menagers et autres sur cette parcelle au cours de cette campagne agricole"
	gen agri_6_35_`i' =  "Combien de fois avez-vous epandu des dechets menagers sur cette parcelle au cours de cette campagne agricole"
	gen agri_6_36_`i' =  "Avez-vous utilise des engrais inorganiques/chimiques sur cette parcelle au cours de cette campagne agricole"
	gen agri_6_37_`i' =  "Combien de fois avez-vous epandu des engrais inorganiques sur cette parcelle au cours de cette campagne agricole"
	gen agri_6_38_a_`i' =  "Quelle quantite d'Uree avez-vous utilisee"
	gen agri_6_38_a_code_`i' =  "Unite"
	gen agri_6_38_a_code_o_`i' =  "Autre code"
	gen agri_6_39_a_`i' =  "Quelle quantite de Phosphates avez-vous utilisee"
	gen agri_6_39_a_code_`i' =  "Unite"
	gen agri_6_39_a_code_o_`i' =  "Autre code"
	gen agri_6_40_a_`i' =  "Quelle quantite de NPK/Formule unique avez-vous utilisee"
	gen agri_6_40_a_code_`i' =  "Unite"
	gen agri_6_40_a_code_o_`i' =  "Autre code"
	gen agri_6_41_a_`i' =  "Quelle quantite d'autres engrais chimiques avez-vous utilisee"
	gen agri_6_41_a_code_`i' =  "Unite"
	gen agri_6_41_a_code_o_`i' =  "Autre code"
}

*** Agriculture Production Module ***
*** Cereals ***
forvalues i=1/6{
	gen cereals_consumption_`i' =  "Votre menage a t'il cultive du [cereals-name] durant cetter periode"
	gen cereals_01_`i' =  "Superficie en hecatre de [cereals-name]"
	gen cereals_02_`i' =  "Production totale en 2023 (kg) de [cereals-name]"
	gen cereals_03_`i' =  "Quantite autoconsommee en 2023 de [cereals-name]"
	gen cereals_04_`i' =  "Quantite vendue en kg en 2023 de [cereals-name]"
	gen cereals_05_`i' =  "Prix de vente actuel en FCFA/kg de [cereals-name]"
}

*** Farines et tubercules ***
forvalues i=1/6{
	gen farine_tubercules_consumption_`i' =  "Votre menage a t'il cultive du [farines_tubercules-name] durant cetter periode"
	gen farines_01_`i' =  "Superficie en hecatre de [farines_tubercules-name]"
	gen farines_02_`i' =  "Production totale en 2023 (kg) de [farines_tubercules-name]"
	gen farines_03_`i' =  "Quantite autoconsommee en 2023 de [farines_tubercules-name]"
	gen farines_04_`i' =  "Quantite vendue en kg en 2023 de [farines_tubercules-name]"
	gen farines_05_`i' =  "Prix de vente actuel en FCFA/kg de [farines_tubercules-name]"
}

*** legumes ***
forvalues i=1/6{
	gen legumes_consumption_`i' =  "Votre menage a t'il cultive du [legumes-name] durant cetter periode"
	gen legumes_01_`i' =  "Superficie en hecatre de [legumes-name]"
	gen legumes_02_`i' =  "Production totale en 2023 (kg) de [legumes-name]"
	gen legumes_03_`i' =  "Quantite autoconsommee en 2023 de [legumes-name]"
	gen legumes_04_`i' =  "Quantite vendue en kg en 2023 de [legumes-name]"
	gen legumes_05_`i' =  "Prix de vente actuel en FCFA/kg de [legumes-name]"
}

*** Farines et tubercules ***
forvalues i=1/5{
	gen legumineuses_consumption_`i' =  "Votre menage a t'il cultive du [legumineuses-name] durant cetter periode"
	gen legumineuses_01_`i' =  "Superficie en hecatre de [legumineuses-name]"
	gen legumineuses_02_`i' =  "Production totale en 2023 (kg) de [legumineuses-name]"
	gen legumineuses_03_`i' =  "Quantite autoconsommee en 2023 de [legumineuses-name]"
	gen legumineuses_04_`i' =  "Quantite vendue en kg en 2023 de [legumineuses-name]"
	gen legumineuses_05_`i' =  "Prix de vente actuel en FCFA/kg de [legumineuses-name]"
}

*** aquatiques and other production ***
gen aquatique_consumption_1 =  "Votre menage a t'il cultive du [aquatique-name] durant cette periode"
gen aquatique_01_1 =  "Superficie en hecatre de [aquatique-name]"
gen aquatique_02_1 =  "Production totale en 2023 (kg) de [aquatique-name]"
gen aquatique_03_1 =  "Quantite autoconsommee en 2023 de [aquatique-name]"
gen aquatique_04_1 =  "Quantite vendue en kg en 2023 de [aquatique-name]"
gen aquatique_05_1 =  "Prix de vente actuel en FCFA/kg de [aquatique-name]"
gen autre_culture_yesno =  "Est-ce qu'il y a un autre type de culture"
gen autre_culture =  "Autre type de culture"
gen o_culture_01 =  "Superficie en hectare de [autre-culture]"
gen o_culture_02 =  "Production totale en 2023 (kg) de [autre-culture]"
gen o_culture_03 =  "Quantite autoconsommee en 2023 de [autre-culture]"
gen o_culture_04 =  "Qunatite vendue en kg en 2023 de [autre-culture]"
gen o_culture_05 =  "Prix de vente actuel en FCFA/kg de [autre-culture]"

*** Food consumption module ***
gen food01 =  "Dans les douze (12) derniers mois, combien de mois a dure la periode de soudure"
gen food02 =  "Avez-vous (ou un membre de votre famille) exerce un travail remunere pendant cette période pour faire face a la periode de soudure"
gen food03 =  "Avez-vous vendu des biens pour subvenir a vos besoins pendant cette periode"
gen food05 =  "Le betail"
gen food06 =  "Les charrettes"
gen food07 =  "Les outils de production"
gen food08 =  "Biens materiels"
gen food09 =  "Puiser dans d'autres ressources (par exemple, un magasin)"
gen food10 =  "Autres, veuillez preciser"
gen food11 =  "Des membres du ménage ont-ils migre pendant cette periode en raison de la periode de soudure"
gen food12 =  "Avez-vous saute des repas pendant la journee en raison de la periode de soudure"

*** Household Income module ***
gen agri_income_01 =  "Avez-vous (ou un membre de votre menage) effectue un travail remunere au cours des 12 derniers mois"
gen agri_income_02 =  "De quel type de travail s'agissait-il (s'agissaient-ils)"
gen agri_income_02_o =  "Autre type de travail"
gen agri_income_03 =  "Quelle est la duree de ce travail (frequence) dans les derniers 12 mois"
gen agri_income_04 =  "Unite de temps"
gen agri_income_05 =  "Montant recu en nature et/ou en especes (FCFA) pour ce travail"
gen agri_income_06 =  "Quel a ete le montant total (en FCFA) des depenses engagees pour ce travail (transport, nourriture, etc.)"
gen species =  "Quelles especes les proprietaires possedent-ils"
gen species_1 =  "Bovins"
gen species_2 =  "Mouton"
gen species_3 =  "Chevre"
gen species_4 =  "Cheval (equide)"
gen species_5 =  "Ane"
gen species_6 =  "Animaux de trait"
gen species_7 =  "Porcs"
gen species_8 =  "Volaille"

*** Livestock ownership questions ***
*** verify maximum in the data ***
/*
forvalues i=1/6 {
	gen agri_income_07_`i' =  "Nombre de tetes de [species-name] actuellement"
	gen agri_income_08_`i' =  "Nombre de tetes de [species-name] vendues (cette annee)"
	gen agri_income_09_`i' =  " Principales raisons de la vente de [species-name]"
	gen agri_income_09_o_`i' =  "Autre raison de vendre"
	gen agri_income_10_`i' =  "Prix moyen par tete de [species-name] en FCFA"
}
*/

gen agri_income_07_o =  "Nombre de tetes de [species_o] actuellement"
gen agri_income_08_o =  "Nombre de tetes de [species_o] vendues (cette annee)"
gen agri_income_09_o_o =  "Principales raisons de la vente de [species_o]"
gen agri_income_09_o_o_o =  "Autre raison de vendre"
gen agri_income_10_o =  "Prix moyen par tete de [species_o] en FCFA"
gen animals_sales =  "Revenues de l'elevage"
gen animals_sales_1 =  "Bovins"
gen animals_sales_2 =  "Mouton"
gen animals_sales_3 =  "Chevre"
gen animals_sales_4 =  "Cheval (equide)"
gen animals_sales_5 =  "Ane"
gen animals_sales_6 =  "Animaux de trait"
gen animals_sales_7 =  "Porcs"
gen animals_sales_8 =  "Volaille"
gen animals_sales_o =  "Est-ce qu'il y a d'autres animaux vendus par le menage"
gen animals_sales_t =  "Autre animal vendu par le menage"

*** Livestock/animal product sales quesitons ***
*** Verify maximum value in data ***
**# Bookmark #12 Like mentioned above, max value will change so be mindful of that

forvalues i=1/2 {
gen agri_income_11_`i' =  "Nombre de tetes de [sale_animales-name] vendus"
gen agri_income_12_`i' =  "Montant total en FCFA pour la vente de [sale_animales-name]"
gen agri_income_13_`i' =  "Nature des produits provenant de [sale_animales-name] vendus"
gen agri_income_13_1_`i' =  "Lait"
gen agri_income_13_2_`i' =  "Le beurre"
gen agri_income_13_3_`i' =  "Le fumier"
gen agri_income_13_99_`i' =  "Autres"
gen agri_income_14_`i' =  "Montant en FCFA du total de vente pour les produits provenant de [sale_animales-name]"
gen agri_income_13_autre_`i' =  "Autre nature"
}

gen agri_income_11_o =  "Nombre de tetes de [animals_sales_t] vendus"
gen agri_income_12_o =  "Montant total en FCFA pour la vente de [animals_sales_t]"
gen agri_income_13_o =  "Nature des produits provenant de [animals_sales_t] vendus"
gen agri_income_13_o_1 =  "Lait"
gen agri_income_13_o_2 =  "Le beurre"
gen agri_income_13_o_3 =  "Le fumier"
gen agri_income_13_o_99 =  "Autres"
gen agri_income_14_o =  "Montant en FCFA du total de vente pour les produits provenant de [animals_sales_t]"
gen agri_income_13_o_t =  "Autre nature"
gen agri_income_15 =  "Avez-vous des employes pour vos activites agricoles"
gen agri_income_16 =  "Si oui, veuillez en preciser le nombre"
***DROPPED VAR ***
*gen agri_income_17 =  "Ces employes sont-ils remuneres"
gen agri_income_18 =  "Comment sont-ils payes"
gen agri_income_18_o =  "Autre type de paiement"
gen agri_income_19 =  "Quel est le montant total de la remuneration dans les 12 derniers mois pour tous travailleurs (argent plus en nature)"
gen agri_income_20 =  "Type d'activite non agricole"
gen agri_income_20_1 =  "Peche"
gen agri_income_20_2 =  "Sylviculture"
gen agri_income_20_3 =  "Artisanat"
gen agri_income_20_4 =  "Commerce"
gen agri_income_20_5 =  "Services"
gen agri_income_20_6 =  "Emploi salaire"
gen agri_income_20_7 =  "Transport"
gen agri_income_20_8 =  "Recolte"
gen agri_income_20_t =  "Est-ce qu'il y a d'autres activites non agricoles"
gen agri_income_20_o =  "Autre type d'activites non agricoles"

*** Revenu non agricole types ***
*** verify maximum in data ***
forvalues i=1/3{
	gen agri_income_21_h_`i' =  "Nombre de personnes impliquees dans [agri_income_20-name] (Homme)"
	gen agri_income_21_f_`i' =  "Nombre de personnes impliquees dans [agri_income_20-name] (Femme)"
	gen agri_income_22_`i' =  "Frequence de [agri_income_20-name] par an (nombre de mois)"
	gen agri_income_23_`i' =  "Revenus par frequence (par [agri_income_22] mois)"
	*** DROPPED VAR ***
	*gen agri_income_24_`i' =  "Revenue annuel total"
}

gen agri_income_21_h_o =  "Nombre de personnes impliquees dans [agri_income_20_o] (Homme)"
gen agri_income_21_f_o =  "Nombre de personnes impliquees dans [agri_income_20_o] (Femme)"
gen agri_income_22_o =  "Frequence de [agri_income_20_o] par an (nombre de mois)" 
gen agri_income_23_o =  "Revenus par frequence (par [agri_income_22_o] mois)"
gen agri_income_25 =  "Avez-vous des employes pour vos activites non agricoles"
gen agri_income_26 =  "Si oui, veuillez en preciser le nombre"
*** DROPPED VAR ***
*gen agri_income_27 =  "Ces employes sont-ils remuneres"
gen agri_income_28 =  "Comment sont-ils payes"
gen agri_income_28_1 =  "En nature"
gen agri_income_28_2 =  "En argent"
gen agri_income_28_3 =  "Autre"
gen agri_income_28_o =  "Autre mode de paiement"
gen agri_income_29 =  "Quel est le montant total de la remuneration dans les 12 derniers mois pour tous travailleurs (argent plus en nature)"
gen agri_income_30 =  "Certains membres de votre menage migrent-ils a l'interieur ou à l'exterieur du pays"
gen agri_income_31 =  "Si oui, ou sont-ils ? (Choix multiple possible s'il y a plusieurs personnes dans une autre zone)"
gen agri_income_31_1 =  "Un autre region du Senegal"
gen agri_income_31_2 =  "Autres pays d'Afrique"
gen agri_income_31_3 =  "Europe"
gen agri_income_31_4 =  "Amerique"
gen agri_income_31_5 =  "Asie"
gen agri_income_31_6 =  "Autre regions"
gen agri_income_31_o =  "Autre zone de migration"
gen agri_income_32 =  "Si oui, envoient-ils de l'argent pour les besoins du menage"
gen agri_income_33 =  "Si oui, combien avez-vous recu au total au cours des 12 derniers mois"
gen agri_income_34 =  "Avez-vous (ou un membre de votre menage) contracte un prêt au cours des douze (12) derniers mois"
gen agri_income_35 =  "Si non, pourquoi ne l'avez-vous pas fait"
gen agri_income_name =  "Choisissez les membres de votre menage qui ont contracte un pret"

*** Credit roster questions ***
*** verify maximum in data ***
**# Bookmark #14 As mentioned above, verify max of data - will change as we get data 

forvalues i=1/5{
	gen agri_income_36_`i' =  "Quel montant de ce pret [credit_ask-name] a t'il contracte"
	gen agri_income_37_`i' =  "Aupres de qui [credit_ask-name] a t'il contracte ce pret"
	gen agri_income_38_`i' =  "Quel est le montant de ce pret que [credit_ask-name] deja rembourse"
	gen agri_income_39_`i' =  "Quel est le montant de ce pret que [credit_ask-name] reste a payer"
}

gen agri_loan_name =  "Choisissez les membres de votre menage qui ont prete de l'argent a d'autres personnes"

*** Loan roster questions - right now only one in the data set but my need a loop ***
gen agri_income_41_1 =  "Quel est le montant que [loan-name] a prete a d'autres personnes"
gen agri_income_42_1 =  "Quel est le montant prete par [loan-name] a d'autres personnes deja paye"
gen agri_income_43_1 =  "Quel est le montant prete par [loan-name] a d'autres personnes encore du"
*** DROPPED VAR ***
*gen agri_income_44_1 =  "Quelle est la valeur nette des transferts effectués au cours des 12 derniers mois"

gen product_divers =  "Quelles sont les depenses globales du menage au cours des quatre derniers mois, les sources de financement ou les pratiques que vous developpez pour repondre a ces besoins, et qui sont les responsables de ces besoins de financement au sein du menage"
gen product_divers_1 =  "Alimentation (produits alimentaires)"
gen product_divers_2 =  "La sante"
gen product_divers_3 =  "L'education"
gen product_divers_4 =  "Eau/Electricite pour le menage"
gen product_divers_5 =  "Logement/transport"
gen product_divers_6 =  "Depenses pour les appareils menagers et le mobilier"
gen product_divers_7 =  "Autres investissements non agricoles"
gen product_divers_8 =  "Depenses de construction, de reparation et de modification"
gen product_divers_9 =  "Acquisition de moyens de transport"
gen product_divers_10 =  "Depenses pour l'habillement et les chaussures du menage"
gen product_divers_11 =  "Depenses de reparation et d'achat de divers articles menagers"
gen product_divers_12 =  "Depenses pour les ceremonies menageres/acquisition de bijoux et de pierres precieuses"
gen product_divers_13 =  "Autres depenses (cadeaux, dons, aides, tabac, alcool, taxes, amendes, assurances)"
gen product_divers_14 =  "Frais de telephone/Wifi"
gen product_divers_99 =  "Autres depenses"

*** product questions ***
*** verify maximum in data ***
forvalues i=1/11{
	gen agri_income_45_`i' =  "Montant en [product-name]"
	gen agri_income_46_`i' =  "Source de finacement (choix multiples)"
	gen agri_income_46_1_`i' =  "Le credit"
	gen agri_income_46_2_`i' =  "Revenus propres"
	gen agri_income_46_3_`i' =  "Dons"
	gen agri_income_46_4_`i' =  "Autres"
	gen agri_income_46_o_`i' =  "Autre source de financement"
}

gen expenses_goods =  "Types de dépenses"
gen expenses_goods_1 =  "Engrais"
gen expenses_goods_2 =  "Aliments pour le betail"
gen expenses_goods_t =  "Est-ce qu'il y a d'autre type de depense"
gen expenses_goods_o =  "Autre a preciser"
gen agri_income_47_1 =  "Montant (KG) de [goods-name]"
gen agri_income_48_1 =  "Qunatite (FCFA)"
gen agri_income_47_2 =  "Montant (KG) de [goods-name]"
gen agri_income_48_2 =  "Qunatite (FCFA)"
gen agri_income_47_o =  "Montant (KG) de [expenses_goods_o]"
gen agri_income_48_o =  "Qunatite (FCFA)"

*** Living standards section ***
gen living_01 =  "Quelle est la principale source d'approvisionnement en eau potable"
gen living_01_o =  "Autre source d'approvisionnement en eau"
gen living_02 =  "L'eau utilisee est-elle traitee dans le menage"
gen living_03 =  "Si oui, comment l'eau est-elle traitee"
gen living_03_o =  "Autre type de traitement de l'eau"
gen living_04 =  "Quel est le principal type de toilettes utilise par votre menage"
gen living_04_o =  "Autre type de toilettes"
gen living_05 =  "Quel est le principal combustible utilise pour la cuisine"
gen living_05_o =  "Autre type de combustible"
gen living_06 =  "Quel est le principal combustible utilise pour l'eclairage"
gen living_06_o =  "Autre type de combustible utilise pour l'eclairage"

*** Beleifs section ***
gen beliefs_01 =  "Quelle est la probabilite que vous contractiez la bilharziose au cours des 12 prochains mois"
gen beliefs_02 =  "Quelle est la probabilite qu'un membre de votre menage contracte la bilharziose au cours des 12 prochains mois"
gen beliefs_03 =  "Quelle est la probabilite qu'un enfant choisi au hasard dans votre village, age de 5 a 14 ans, contracte la bilharziose au cours des 12 prochains mois"
gen beliefs_04 =  "Dans quelle mesure etes-vous d'accord avec l'affirmation suivante : Les terres de ce village devraient appartenir a la communaute et non a des individus"
gen beliefs_05 =  "Dans quelle mesure etes-vous d'accord avec l'affirmation suivante : Les sources d'eau de ce village devraient appartenir a la communaute et non aux individus"
gen beliefs_06 =  "Dans quelle mesure etes-vous d'accord avec l'affirmation suivante : Si je travaille sur mes propres terres, j'ai le droit d'utiliser les produits que j'ai obtenus grace a mon travail."
gen beliefs_07 =  "Dans quelle mesure etes-vous d'accord avec l'affirmation suivante : Si je travaille sur des terres appartenant a la communaute, j'ai le droit d'utiliser les produits que j'ai obtenus par mon travail."
gen beliefs_08 =  "Dans quelle mesure etes-vous d'accord avec l'affirmation suivante : Si je peche dans une source d'eau appartenant a la communaute, j'ai le droit d'utiliser les produits que j'ai obtenus par mon travail."
gen beliefs_09 =  "Dans quelle mesure êtes-vous d'accord avec l'affirmation suivante : Si je recolte des produits dans une source d'eau appartenant a la communaute, j'ai le droit d'utiliser les produits que j'ai obtenus par mon travail."


*** Enumerator Observations ***
gen enum_01 =  "D'autres personnes que les repondants ont-elles suivi l'entretien"
gen enum_02 =  "Combien de personnes environ ont observe l'entretien"
gen enum_03 =  "Quels sont les materiaux principaux utilises pour le toit de la maison ou dort le chef de famille"
gen enum_03_o =  "Autre type de materiaux pour le toit"
gen enum_04 =  "Quels sont les materiaux principaux utilises pour les murs de la maison ou dort le chef de famille"
gen enum_04_o =  "Autre type de materiaux pour les murs"
gen enum_05 =  "S'il a ete observe, quels sont les materiaux principaux du sol principal de la maison ou dort le chef de famille"
gen enum_05_o =  "Autre type de materiaux pour le sol"
gen enum_06 =  "Comment evaluez-vous la comprehension globale des questions par le repondant"
gen enum_07 =  "Veuillez indiquer les parties difficiles"
gen enum_08 =  "Veuillez donner votre avis sur le revenu du menage"



*================================== switch from wide to long ============================================

/*

unab varlist : *  // Capture all variable names
gen id = 1  
reshape long `varlist', i(id) j(variable_name)   
rename `varlist' value  
rename variable_name variable  
drop id  
list variable value 

 
unab varlist : * 
foreach v of varlist `varlist' {
    compress `v'
    replace `v' = substr(`v', 1, 2045) if length(`v') > 2045  // Truncate if needed
}


unab varlist : * 
stack `varlist', into(var_value) wide clear
gen variable_name = _stack
drop _stack
order variable_name var_value
*/
















