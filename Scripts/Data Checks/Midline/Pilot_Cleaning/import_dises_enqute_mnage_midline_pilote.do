* import_dises_enqute_mnage_midline_pilote.do
*
* 	Imports and aggregates "DISES_Enquête ménage midline pilote" (ID: dises_enqute_mnage_midline_pilote) data.
*
*	Inputs:  "DISES_Enquête ménage midline pilote_WIDE.csv"
*	Outputs: "DISES_Enquête ménage midline pilote.dta"
*
*	Output by SurveyCTO January 17, 2025 2:20 PM.

* initialize Stata
clear all
set more off
set mem 100m

* initialize workflow-specific parameters
*	Set overwrite_old_data to 1 if you use the review and correction
*	workflow and allow un-approving of submissions. If you do this,
*	incoming data will overwrite old data, so you won't want to make
*	changes to data in your local .dta file (such changes can be
*	overwritten with each new import).
local overwrite_old_data 0

* initialize form-specific parameters
local csvfile "DISES_Enquête ménage midline pilote_WIDE.csv"
local dtafile "DISES_Enquête ménage midline pilote.dta"
local corrfile "DISES_Enquête ménage midline pilote_corrections.csv"
local note_fields1 ""
local text_fields1 "deviceid devicephonenum username device_info duration caseid record_text village_select_o hhid_village region departement commune village grappe schoolmosqueclinic grappe_int sup_txt sup_name enqu_o"
local text_fields2 "enqu_txt enqu_name no_consent_explain start_survey start_identification hh_head_name_complet hh_head_name_complet_label hh_global_id hh_size_load hh_name_complet_resp hh_name_complet_resp_id"
local text_fields3 "training_id end_identification start_hh_composition rpt_mem_count fu_mem_id_* pull_hh_full_name_calc__* pull_hh_gender__* pull_hh_age__* still_member_whynot_o_* nom_complet_* hh_full_name_calc_*"
local text_fields4 "hh_ethnicity_o_* hh_relation_with_o_* hh_education_skills_* hh_education_level_o_* hh_main_activity_o_* hh_11_o_* hh_12_* hh_12_o_* hh_12_calc_* hh_12_roster_count_* hh_12index_* hh_12name_*"
local text_fields5 "hh_13_sum_* hh_15_o_* hh_19_o_* hh_20_* hh_20_o_* hh_20_calc_* hh_20_roster_count_* hh_20index_* hh_20name_* hh_21_sum_* hh_23_* hh_23_o_* relation_txt_* posif_here_* posif_chef_* is_chef_* is_man_*"
local text_fields6 "is_woman_* full_name_age_* new_mem_n name_list name_list_txt hh_size_actual hh_currentlist father_list mother_list count_chefs firstname_mem1 firstname_mem2 firstname_mem3 firstname_mem4"
local text_fields7 "firstname_mem5 firstname_mem6 firstname_mem7 firstname_mem8 firstname_mem9 firstname_mem10 firstname_mem11 firstname_mem12 firstname_mem13 firstname_mem14 firstname_mem15 firstname_mem16"
local text_fields8 "firstname_mem17 firstname_mem18 firstname_mem19 firstname_mem20 firstname_mem21 firstname_mem22 firstname_mem23 firstname_mem24 firstname_mem25 firstname_mem26 firstname_mem27 firstname_mem28"
local text_fields9 "firstname_mem29 firstname_mem30 firstname_mem31 firstname_mem32 firstname_mem33 firstname_mem34 firstname_mem35 firstname_mem36 firstname_mem37 firstname_mem38 firstname_mem39 firstname_mem40"
local text_fields10 "firstname_mem41 firstname_mem42 firstname_mem43 firstname_mem44 firstname_mem45 firstname_mem46 firstname_mem47 firstname_mem48 firstname_mem49 firstname_mem50 firstname_mem51 firstname_mem52"
local text_fields11 "firstname_mem53 firstname_mem54 firstname_mem55 firstname_mem56 firstname_mem57 firstname_mem58 firstname_mem59 firstname_mem60 age_mem1 age_mem2 age_mem3 age_mem4 age_mem5 age_mem6 age_mem7 age_mem8"
local text_fields12 "age_mem9 age_mem10 age_mem11 age_mem12 age_mem13 age_mem14 age_mem15 age_mem16 age_mem17 age_mem18 age_mem19 age_mem20 age_mem21 age_mem22 age_mem23 age_mem24 age_mem25 age_mem26 age_mem27 age_mem28"
local text_fields13 "age_mem29 age_mem30 age_mem31 age_mem32 age_mem33 age_mem34 age_mem35 age_mem36 age_mem37 age_mem38 age_mem39 age_mem40 age_mem41 age_mem42 age_mem43 age_mem44 age_mem45 age_mem46 age_mem47 age_mem48"
local text_fields14 "age_mem49 age_mem50 age_mem51 age_mem52 age_mem53 age_mem54 age_mem55 age_mem56 age_mem57 age_mem58 age_mem59 age_mem60 list_chef end_roster end_hh_composition hh_group_supplement_count"
local text_fields15 "hh_schoolindex_* hh_scoohlname_* hh_schoolage_* hh_schoolgenre_* hh_add_new_* hh_still_member_* hh_29_o_* hh_47_oth_* start_knowledge knowledge_02 knowledge_05_o knowledge_06 knowledge_08 knowledge_09"
local text_fields16 "knowledge_09_o knowledge_10 knowledge_10_o knowledge_12_o knowledge_17 knowledge_19_o knowledge_20_o knowledge_23 knowledge_23_o end_knowledge start_health_status _health_roster_count healthindex_*"
local text_fields17 "healthname_* healthage_* healthgenre_* health_add_new_* health_still_member_* health_5_3_* health_5_3_o_* health_5_11_o_* end_health_status start_actif list_actifs list_actifscount"
local text_fields18 "_actifs_roster_count actifsid_* actifsname_* actifs_o list_agri_equip list_agri_equipcount _agri_roster_count agriindex_* agriname_* list_agri_equip_o_t agri_6_12 agri_6_12_o _parcelle_roster_count"
local text_fields19 "parcelleindex_* agri_6_20_o_* agri_6_23_o_* agri_6_25_o_* agri_6_26_o_* agri_6_27_* agri_6_29_o_* agri_6_31_o_* agri_6_33_o_* agri_6_38_a_code_o_* agri_6_39_a_code_o_* agri_6_40_a_code_o_*"
local text_fields20 "agri_6_41_a_code_o_* end_actif start_crops _cereals_roster_count cerealsposition_* cerealsname_* _farine_tubercules_roster_count farine_tuberculesposition_* farine_tuberculesname_*"
local text_fields21 "legumes_roster_count legumesposition_* legumesname_* legumineuses_roster_count legumineusesposition_* legumineusesname_* aquatique_roster_count aquatiqueposition_* aquatiquename_* autre_culture"
local text_fields22 "end_crops start_food food10 end_food start_income agri_income_02_o species species_o species_count _species_roster_count speciesindex_* speciesname_* agri_income_09_o_* agri_income_09_o_o_o"
local text_fields23 "animals_sales animals_sales_t animals_sales_count _animals_sales_roster_count sale_animalesindex_* sale_animalesname_* agri_income_13_* agri_income_13_autre_* agri_income_13_o agri_income_13_o_t"
local text_fields24 "agri_income_18_o agri_income_20 agri_income_20_o agri_income_20_calc agri_income_20_roster_count agri_income_20index_* agri_income_20name_* agri_income_28 agri_income_28_o agri_income_31"
local text_fields25 "agri_income_31_o agri_income_name agri_income_name_calc credit_roster_count credit_askindex_* credit_askname_* agri_income_37_* restant_pret_* agri_loan_name agri_loan_name_calc loan_roster_count"
local text_fields26 "loanindex_* loanname_* product_divers product_diverscount _production_roster_count productindex_* productname_* agri_income_46_* agri_income_46_o_* expenses_goods expenses_goods_o expenses_goods_count"
local text_fields27 "_agriculture_goods_roster_count goodsindex_* goodsname_* end_income start_living living_01_o living_03_o living_04_o living_05_o living_06_o end_living start_beliefs end_beliefs start_enumerator"
local text_fields28 "enum_03_o enum_04_o enum_05_o enum_07 end_enumerator instanceid instancename"
local date_fields1 "today hh_date"
local datetime_fields1 "submissiondate starttime endtime"

disp
disp "Starting import of: `csvfile'"
disp

* import data from primary .csv file
insheet using "`csvfile'", names clear

* drop extra table-list columns
cap drop reserved_name_for_field_*
cap drop generated_table_list_lab*

* continue only if there's at least one row of data to import
if _N>0 {
	* drop note fields (since they don't contain any real data)
	forvalues i = 1/100 {
		if "`note_fields`i''" ~= "" {
			drop `note_fields`i''
		}
	}
	
	* format date and date/time fields
	forvalues i = 1/100 {
		if "`datetime_fields`i''" ~= "" {
			foreach dtvarlist in `datetime_fields`i'' {
				cap unab dtvarlist : `dtvarlist'
				if _rc==0 {
					foreach dtvar in `dtvarlist' {
						tempvar tempdtvar
						rename `dtvar' `tempdtvar'
						gen double `dtvar'=.
						cap replace `dtvar'=clock(`tempdtvar',"MDYhms",2025)
						* automatically try without seconds, just in case
						cap replace `dtvar'=clock(`tempdtvar',"MDYhm",2025) if `dtvar'==. & `tempdtvar'~=""
						format %tc `dtvar'
						drop `tempdtvar'
					}
				}
			}
		}
		if "`date_fields`i''" ~= "" {
			foreach dtvarlist in `date_fields`i'' {
				cap unab dtvarlist : `dtvarlist'
				if _rc==0 {
					foreach dtvar in `dtvarlist' {
						tempvar tempdtvar
						rename `dtvar' `tempdtvar'
						gen double `dtvar'=.
						cap replace `dtvar'=date(`tempdtvar',"MDY",2025)
						format %td `dtvar'
						drop `tempdtvar'
					}
				}
			}
		}
	}

	* ensure that text fields are always imported as strings (with "" for missing values)
	* (note that we treat "calculate" fields as text; you can destring later if you wish)
	tempvar ismissingvar
	quietly: gen `ismissingvar'=.
	forvalues i = 1/100 {
		if "`text_fields`i''" ~= "" {
			foreach svarlist in `text_fields`i'' {
				cap unab svarlist : `svarlist'
				if _rc==0 {
					foreach stringvar in `svarlist' {
						quietly: replace `ismissingvar'=.
						quietly: cap replace `ismissingvar'=1 if `stringvar'==.
						cap tostring `stringvar', format(%100.0g) replace
						cap replace `stringvar'="" if `ismissingvar'==1
					}
				}
			}
		}
	}
	quietly: drop `ismissingvar'


	* consolidate unique ID into "key" variable
	replace key=instanceid if key==""
	drop instanceid


	* label variables
	label variable key "Unique submission ID"
	cap label variable submissiondate "Date/time submitted"
	cap label variable formdef_version "Form version used on device"
	cap label variable review_status "Review status"
	cap label variable review_comments "Comments made during review"
	cap label variable review_corrections "Corrections made during review"


	label variable village_select "Selectionnez le village pour le questionnaire ménage"
	note village_select: "Selectionnez le village pour le questionnaire ménage"
	label define village_select 1 "010A,Saint-Louis,Dagana,Keur Birane Kobar" 2 "010B,Saint-Louis,Dagana,Gueum Yalla" 3 "011A,SAINT LOUIS,DAGANA,ASSY" 4 "011B,SAINT LOUIS,DAGANA,Ndiakhaye" 5 "012A,SAINT LOUIS,DAGANA,Mbilor" 6 "012B,Louga,Louga,Diaminar" 7 "013A,Saint-Louis,Dagana,Ndelle Boye" 8 "013B,Saint-Louis,Dagana,Minguene Boye" 9 "020A,SAINT LOUIS,,NDIAMAR" 10 "020B,SAINT-LOUIS,PODOR,NDIAYENE PENDAO" 11 "021A,SAINT-LOUIS,DAGANA,EL DEBIYAYE MARAYE II (16151)" 12 "021B,SAINT LOUIS,PODOR,THIANGAYE" 13 "022A,LOUGA,LOUGA,DIAMINAR LOYENE" 14 "022B,SAINT-LOUIS,DAGANA,El Mohamed Amar" 15 "023A,Saint-Louis,Dagana,Thilla" 16 "023B,SAINT LOUIS,DAGANA,MBERAYE" 17 "030A,SAINT LOUIS,DAGANA,KASSACK NORD" 18 "030B,SAINT LOUIS,PODOR,DIABOBES" 19 "031A,SAINT LOUIS,SAINT LOUIS,NGAYE" 20 "031B,SAINT LOUIS,DAGANA,SANEINTE TACQUE" 21 "032A,SAINT-LOUIS,DAGANA,Dioss Peulh" 22 "032B,SAINT LOUIS,DAGANA,MBOUBENE PEULH" 23 "033A,LOUGA,LOUGA,GUEO" 24 "033B,SAINT LOUIS,DAGANA,YETTI YONI (BOUNTOU NDIEUGNE)" 25 "040A,SAINT LOUIS,DAGANA,DIAWAR" 26 "040B,SAINT LOUIS,PODOR,DIAMEL (DIAMEL DJIERY)" 27 "041A,SAINT LOUIS ,PODOR,Mbantou" 28 "041B,SAINT LOUIS,PODOR,NDORMBOSS" 29 "042A,SAINT LOUIS,DAGANA,AMOURA" 30 "042B,SAINT LOUIS,DAGANA,NADIEL I" 31 "043A,SAINT LOUIS,DAGANA,TREICH PEULH" 32 "043B,SAINT LOUIS,DAGANA,NDER" 33 "050A,SAINT LOUIS,DAGANA,KHEUNE" 34 "050B,SAINT LOUIS,PODOR,NDIAWARA" 35 "051A,SAINT LOUIS,DAGANA,YAMANE" 36 "051B,SAINT LOUIS,PODOR,THIELAO" 37 "052A,SAINT LOUIS,DAGANA,THILENE" 38 "052B,SAINT LOUIS,Diama,Taba treich" 39 "053A,SAINT LOUIS,DAGANA,DIAGAMBAL I" 40 "053B,SAINT LOUIS,PODOR,DARA ALAYBE" 41 "060A,SAINT LOUIS,DAGANA,THIAGAR" 42 "060B,SAINT LOUIS,PODOR,GUEDE" 43 "061A,SAINT LOUIS,DAGANA,NGOMENE" 44 "061B,SAINT LOUIS,PODOR,DEMBE" 45 "062A,SAINT LOUIS,,ROSS BETHIO (ODABE NAWAR)" 46 "062B,SAINT LOUIS,PODOR,FANAYE DIERY" 47 "063A,SAINT-LOUIS,DAGANA,NDIAYE MBERESSE (NDIAYE NGAINTHE)" 48 "063B,SAINT LOUIS,PODOR,DIAMAL" 49 "070A,SAINT LOUIS,DAGANA,NDIETENE" 50 "070B,SAINT LOUIS,PODOR,H3 PETEL DIEGUESS" 51 "071A,SAINT LOUIS,DAGANA,TEMEYE" 52 "071B,SAINT LOUIS,PODOR,DIARRA" 53 "072A,SAINT LOUIS,DAGANA,MBAGAME" 54 "072B,SAINT LOUIS,PODOR,DODEL" 55 "073A,SAINT LOUIS,DAGANA,NDIOUNG MBERESSE" 56 "073B,Louga,Louga,Keur Momar Sarr,FÃ©to" 57 "080A,SAINT LOUIS,DAGANA,LEWAH (TEMEYE LEWAH)" 58 "080B,SAINT LOUIS,PODOR,THIEWLE" 59 "081A,SAINT LOUIS,PODOR,BOULEYDI" 60 "081B,SAINT LOUIS,PODOR,GAMADJI SARRE" 61 "082A,SAINT LOUIS,PODOR,DARA SALAM" 62 "082B,SAINT LOUIS,PODOR,NGEUNDAR ( GARAGE NGUENDAR )" 63 "083A,SAINT LOUIS,DAGANA,KHARE" 64 "083B,SAINT LOUIS,PODOR,NGAOULE" 65 "090A,SAINT LOUIS,PODOR,DADO" 66 "090B,SAINT LOUIS,PODOR,NDIAYENE SARE" 67 "091A,SAINT LOUIS,PODOR,DOUE" 68 "091B,SAINT LOUIS,PODOR,LERABE" 69 "092A,SAINT LOUIS,DAGANA,NDOMBO ALARBA" 70 "092B,SAINT LOUIS,PODOR,OURO MADIHOU" 71 "093A,SAINT LOUIS,,GUIDAKHAR" 72 "093B,SAINT LOUIS,PODOR,MBOYO" 73 "100A,SAINT LOUIS,PODOR,FONDE ASS" 74 "100B,SAINT LOUIS,PODOR,KADIOGUE (DIABOBES II)" 75 "101A,SAINT LOUIS,PODOR,DONAYE" 76 "101B,SAINT LOUIS,PODOR,AGNAM TONGUEL" 77 "102A,SAINT LOUIS,DAGANA,NDOMBO" 78 "102B,SAINT LOUIS,PODOR,FANAYE WALO" 79 "103A,SAINT LOUIS,PODOR,LOBBOUDOU DOUE" 80 "103B,SAINT LOUIS,PODOR,DIEGUESS DAROU SALAM" 81 "110A,SAINT LOUIS,PODOR,KODITH" 82 "110B,SAINT LOUIS,DAGANA,KHOR" 83 "111A,SAINT LOUIS,DAGANA,DIADIAM III" 84 "111B,SAINT LOUIS,GANDON,Ndialakhar wolof" 85 "112A,SAINT LOUIS,DAGANA,BISSETTE I" 86 "112B,SAINT LOUIS,DAGANA,NAERE" 87 "113A,SAINT LOUIS,DAGANA,SAVOIGNE PIONNIERS" 88 "113B,SAINT LOUIS,PODOR,PATHE GALLO" 89 "120B,Saint-Louis,Dagana,SYER" 90 "121A,Louga,Louga,MERINA GEWEL" 91 "121B,Saint-Louis,Dagana,FOSS" 92 "122A,Saint-Louis,Dagana,MBAKHANA" 93 "123A,Saint-Louis,Dagana,MBARIGO" 94 "123B,Saint-Louis,Dagana,MALLA TACK" 95 "131A,Saint-Louis,Dagana,NDIOL MAURE" 96 "131B,Saint-Louis,Dagana,MALLA" 97 "132A,Louga,Louga,GANKETTE BALLA" 98 "133A,Saint-Louis,Dagana,GADE TAMAKH" 99 "141A,Saint-Louis,Dagana,PAKH" 100 "142A,Saint-Louis,Dagana,TIGUETTE" 101 "143A,Louga,Louga,NDIBE" 102 "151A,Saint-Louis,Dagana,DIADIAM I" 103 "161A,Saint-Louis,Dagana,SAVOIGNE PEULH" 104 "171A,Saint-Louis,Dagana,MBEURBEUF"
	label values village_select village_select

	label variable sup "PLEASE SELECT THE NAME OF YOUR SUPERVISOR"
	note sup: "PLEASE SELECT THE NAME OF YOUR SUPERVISOR"
	label define sup 1 "Equipe pilote"
	label values sup sup

	label variable sup_txt "PLEASE ENTER THE NAME"
	note sup_txt: "PLEASE ENTER THE NAME"

	label variable enqu "SURVEYOR: PLEASE SELECT YOUR NAME"
	note enqu: "SURVEYOR: PLEASE SELECT YOUR NAME"
	label define enqu 1 "Boubacar Mama BA" 2 "Amadou Korka BA" 3 "Aissatou DIA" 4 "Ahmeth iyane Dia" 5 "Abou DIALLO" 6 "Kadiatou DIALLO" 7 "Abdourahmane DIAMANKA" 8 "Ousmane DIAO" 9 "Samsidine DIAW" 10 "Ibrahima GACKO" 11 "Bocar GUEYE" 12 "Oumy GUEYE" 13 "Moussa Gueye" 14 "Bineta KANE" 15 "Fatimata Djiby Kelly" 16 "Ibrahima Ly" 17 "Tidiane MBAYE" 18 "Bineta SOW" 19 "Mamadou SOW" 20 "Demba Gorel Sow" 21 "Djiby Diouf Sow" 22 "Mouhamed Sow" 23 "Thierno Hamidou SY" 24 "Mamoudou THIAM" 25 "Abdoul Aziz Toure" 26 "Mamadou Misbaou Balde" 27 "Amadou Mamadou Barro" 28 "Marie Sow" 29 "Abasse Tall" 30 "Mamoudou Talla" -777 "Other surveyor"
	label values enqu enqu

	label variable enqu_txt "PLEASE ENTER THE NAME"
	note enqu_txt: "PLEASE ENTER THE NAME"

	label variable consent "1.1. Supervisor Only: Do you agree to do the interview and to participate in the"
	note consent: "1.1. Supervisor Only: Do you agree to do the interview and to participate in the study?"
	label define consent 0 "[ 0 ] No (Supervisor: Thank you for your time! End the interview.)" 1 "[ 1 ] Yes" 2 "[ 2 ] FIELD RETURN NECESSARY"
	label values consent consent

	label variable hh_49 "You have at least one child currently attending formal schooling. Today, our res"
	note hh_49: "You have at least one child currently attending formal schooling. Today, our research team has one enumerator at the school who is checking school attendance for children in our study sample. We will each child is they are present in the classroom, and then ask them their age, gender and household head to verify their identity. This information will be kept confidential. De-identified data from this study may be shared with the research community at large to advance science and health. We will remove or code any personal information that could identify the child before files are shared with other researchers to ensure that, by current scientific standards and known methods, no one will be able to identify the child from the information we share. We are not aware of any risk that would result from participation. Do we have your permission to use data from the school attendance check for children from this household as part of research? 1=Yes 2=No"
	label define hh_49 1 "Yes" 0 "No" 2 "Don't know/did not answer"
	label values hh_49 hh_49

	label variable status_consent_no "Status consent"
	note status_consent_no: "Status consent"
	label define status_consent_no 1 "ménage non-trouvé" 2 "ménage refusé" 3 "Personne n'était disponible pendant toute la période de l'enquête." 5 "personne ciblé décédée" 6 "personne ciblé migrée hors du pays" 4 "Autre" 0 "Personne ciblée à tracker"
	label values status_consent_no status_consent_no

	label variable no_consent_explain "Donnez une explication SVP"
	note no_consent_explain: "Donnez une explication SVP"

	label variable hh_numero "2.6 Number of Household member"
	note hh_numero: "2.6 Number of Household member"

	label variable hh_phone "2.7. Household phone number (or a household member's telephone number)"
	note hh_phone: "2.7. Household phone number (or a household member's telephone number)"

	label variable hh_head_name_complet "2.8 Name and Surname of the Household Head"
	note hh_head_name_complet: "2.8 Name and Surname of the Household Head"

	label variable hh_global_id "HHID of the household"
	note hh_global_id: "HHID of the household"

	label variable hh_name_complet_resp "2.9 Name and Surname of the Respondent (if different from the household head)"
	note hh_name_complet_resp: "2.9 Name and Surname of the Respondent (if different from the household head)"

	label variable hh_name_complet_resp_id "What is the individual ID of the respondent? (Select from exisiting household ro"
	note hh_name_complet_resp_id: "What is the individual ID of the respondent? (Select from exisiting household roster or add additional ID)"

	label variable hh_age_resp "2.10 Age of the Respondent"
	note hh_age_resp: "2.10 Age of the Respondent"

	label variable hh_gender_resp "2.11 Gender of the Respondent"
	note hh_gender_resp: "2.11 Gender of the Respondent"
	label define hh_gender_resp 1 "1. Man" 2 "2. Woman"
	label values hh_gender_resp hh_gender_resp

	label variable attend_training "Did you attend the training our team ran in [MONTH] 2024 on removal of the aquat"
	note attend_training: "Did you attend the training our team ran in [MONTH] 2024 on removal of the aquatic plant cerato [REPLACE with local name, naithe?]?"
	label define attend_training 1 "Yes" 0 "No" 2 "Don't know/did not answer"
	label values attend_training attend_training

	label variable who_attended_training "Did another member of this household attend the training our team ran in [MONTH]"
	note who_attended_training: "Did another member of this household attend the training our team ran in [MONTH] 2024 on removal of the aquatic plant cerato [REPLACE with local name, nianthe?]"
	label define who_attended_training 1 "Yes" 0 "No" 2 "Don't know/did not answer"
	label values who_attended_training who_attended_training

	label variable training_id "Which member of the household attended training (should select from list and rec"
	note training_id: "Which member of the household attended training (should select from list and record the ID or select another person and fill in information)"

	label variable heard_training "Have you heard about the training sessions conducted as a part of the project?"
	note heard_training: "Have you heard about the training sessions conducted as a part of the project?"
	label define heard_training 1 "Yes" 0 "No" 2 "Don't know/did not answer"
	label values heard_training heard_training

	label variable hh_date "2.13 Date"
	note hh_date: "2.13 Date"

	label variable hh_time "2.14 Time"
	note hh_time: "2.14 Time"

	label variable showroster "AGENT ENQUETEUR : dites 'voici la liste des membres du ménage' : [LIRE TOUTE LA "
	note showroster: "AGENT ENQUETEUR : dites 'voici la liste des membres du ménage' : [LIRE TOUTE LA LISTE CI DESSOUS A HAUTE VOIX POUR LE REPONDANT]"
	label define showroster -6 "Vivant.e mais ne résidant pas dans le ménage avec l'enfant." -5 "[décédé.e]" -4 "[ne fait pas partie du ménage]" -2 "Personne" -1 "Tous les membres du ménage" 0 "Personnes hors du ménage" 1 "\${firstname_mem1}, Age : \${age_mem1}, pos 1" 2 "\${firstname_mem2}, Age : \${age_mem2}, pos 2" 3 "\${firstname_mem3}, Age : \${age_mem3}, pos 3" 4 "\${firstname_mem4}, Age : \${age_mem4}, pos 4" 5 "\${firstname_mem5}, Age : \${age_mem5}, pos 5" 6 "\${firstname_mem6}, Age : \${age_mem6}, pos 6" 7 "\${firstname_mem7}, Age : \${age_mem7}, pos 7" 8 "\${firstname_mem8}, Age : \${age_mem8}, pos 8" 9 "\${firstname_mem9}, Age : \${age_mem9}, pos 9" 10 "\${firstname_mem10}, Age : \${age_mem10}, pos 10" 11 "\${firstname_mem11}, Age : \${age_mem11}, pos 11" 12 "\${firstname_mem12}, Age : \${age_mem12}, pos 12" 13 "\${firstname_mem13}, Age : \${age_mem13}, pos 13" 14 "\${firstname_mem14}, Age : \${age_mem14}, pos 14" 15 "\${firstname_mem15}, Age : \${age_mem15}, pos 15" 16 "\${firstname_mem16}, Age : \${age_mem16}, pos 16" 17 "\${firstname_mem17}, Age : \${age_mem17}, pos 17" 18 "\${firstname_mem18}, Age : \${age_mem18}, pos 18" 19 "\${firstname_mem19}, Age : \${age_mem19}, pos 19" 20 "\${firstname_mem20}, Age : \${age_mem20}, pos 20" 21 "\${firstname_mem21}, Age : \${age_mem21}, pos 21" 22 "\${firstname_mem22}, Age : \${age_mem22}, pos 22" 23 "\${firstname_mem23}, Age : \${age_mem23}, pos 23" 24 "\${firstname_mem24}, Age : \${age_mem24}, pos 24" 25 "\${firstname_mem25}, Age : \${age_mem25}, pos 25" 26 "\${firstname_mem26}, Age : \${age_mem26}, pos 26" 27 "\${firstname_mem27}, Age : \${age_mem27}, pos 27" 28 "\${firstname_mem28}, Age : \${age_mem28}, pos 28" 29 "\${firstname_mem29}, Age : \${age_mem29}, pos 29" 30 "\${firstname_mem30}, Age : \${age_mem30}, pos 30" 31 "\${firstname_mem31}, Age : \${age_mem31}, pos 31" 32 "\${firstname_mem32}, Age : \${age_mem32}, pos 32" 33 "\${firstname_mem33}, Age : \${age_mem33}, pos 33" 34 "\${firstname_mem34}, Age : \${age_mem34}, pos 34" 35 "\${firstname_mem35}, Age : \${age_mem35}, pos 35" 36 "\${firstname_mem36}, Age : \${age_mem36}, pos 36" 37 "\${firstname_mem37}, Age : \${age_mem37}, pos 37" 38 "\${firstname_mem38}, Age : \${age_mem38}, pos 38" 39 "\${firstname_mem39}, Age : \${age_mem39}, pos 39" 40 "\${firstname_mem40}, Age : \${age_mem40}, pos 40" 41 "\${firstname_mem41}, Age : \${age_mem41}, pos 41" 42 "\${firstname_mem42}, Age : \${age_mem42}, pos 42" 43 "\${firstname_mem43}, Age : \${age_mem43}, pos 43" 44 "\${firstname_mem44}, Age : \${age_mem44}, pos 44" 45 "\${firstname_mem45}, Age : \${age_mem45}, pos 45" 46 "\${firstname_mem46}, Age : \${age_mem46}, pos 46" 47 "\${firstname_mem47}, Age : \${age_mem47}, pos 47" 48 "\${firstname_mem48}, Age : \${age_mem48}, pos 48" 49 "\${firstname_mem49}, Age : \${age_mem49}, pos 49" 50 "\${firstname_mem50}, Age : \${age_mem50}, pos 50" 51 "\${firstname_mem51}, Age : \${age_mem51}, pos 51" 52 "\${firstname_mem52}, Age : \${age_mem52}, pos 52" 53 "\${firstname_mem53}, Age : \${age_mem53}, pos 53" 54 "\${firstname_mem54}, Age : \${age_mem54}, pos 54" 55 "\${firstname_mem55}, Age : \${age_mem55}, pos 55" 56 "\${firstname_mem56}, Age : \${age_mem56}, pos 56" 57 "\${firstname_mem57}, Age : \${age_mem57}, pos 57" 58 "\${firstname_mem58}, Age : \${age_mem58}, pos 58" 59 "\${firstname_mem59}, Age : \${age_mem59}, pos 59" 60 "\${firstname_mem60}, Age : \${age_mem60}, pos 60"
	label values showroster showroster

	label variable final_list "The final list of household members you have declared is shown below. Can you co"
	note final_list: "The final list of household members you have declared is shown below. Can you confirm that all household members have been taken into account?"
	label define final_list -6 "Vivant.e mais ne résidant pas dans le ménage avec l'enfant." -5 "[décédé.e]" -4 "[ne fait pas partie du ménage]" -2 "Personne" -1 "Tous les membres du ménage" 0 "Personnes hors du ménage" 1 "\${firstname_mem1}, Age : \${age_mem1}, pos 1" 2 "\${firstname_mem2}, Age : \${age_mem2}, pos 2" 3 "\${firstname_mem3}, Age : \${age_mem3}, pos 3" 4 "\${firstname_mem4}, Age : \${age_mem4}, pos 4" 5 "\${firstname_mem5}, Age : \${age_mem5}, pos 5" 6 "\${firstname_mem6}, Age : \${age_mem6}, pos 6" 7 "\${firstname_mem7}, Age : \${age_mem7}, pos 7" 8 "\${firstname_mem8}, Age : \${age_mem8}, pos 8" 9 "\${firstname_mem9}, Age : \${age_mem9}, pos 9" 10 "\${firstname_mem10}, Age : \${age_mem10}, pos 10" 11 "\${firstname_mem11}, Age : \${age_mem11}, pos 11" 12 "\${firstname_mem12}, Age : \${age_mem12}, pos 12" 13 "\${firstname_mem13}, Age : \${age_mem13}, pos 13" 14 "\${firstname_mem14}, Age : \${age_mem14}, pos 14" 15 "\${firstname_mem15}, Age : \${age_mem15}, pos 15" 16 "\${firstname_mem16}, Age : \${age_mem16}, pos 16" 17 "\${firstname_mem17}, Age : \${age_mem17}, pos 17" 18 "\${firstname_mem18}, Age : \${age_mem18}, pos 18" 19 "\${firstname_mem19}, Age : \${age_mem19}, pos 19" 20 "\${firstname_mem20}, Age : \${age_mem20}, pos 20" 21 "\${firstname_mem21}, Age : \${age_mem21}, pos 21" 22 "\${firstname_mem22}, Age : \${age_mem22}, pos 22" 23 "\${firstname_mem23}, Age : \${age_mem23}, pos 23" 24 "\${firstname_mem24}, Age : \${age_mem24}, pos 24" 25 "\${firstname_mem25}, Age : \${age_mem25}, pos 25" 26 "\${firstname_mem26}, Age : \${age_mem26}, pos 26" 27 "\${firstname_mem27}, Age : \${age_mem27}, pos 27" 28 "\${firstname_mem28}, Age : \${age_mem28}, pos 28" 29 "\${firstname_mem29}, Age : \${age_mem29}, pos 29" 30 "\${firstname_mem30}, Age : \${age_mem30}, pos 30" 31 "\${firstname_mem31}, Age : \${age_mem31}, pos 31" 32 "\${firstname_mem32}, Age : \${age_mem32}, pos 32" 33 "\${firstname_mem33}, Age : \${age_mem33}, pos 33" 34 "\${firstname_mem34}, Age : \${age_mem34}, pos 34" 35 "\${firstname_mem35}, Age : \${age_mem35}, pos 35" 36 "\${firstname_mem36}, Age : \${age_mem36}, pos 36" 37 "\${firstname_mem37}, Age : \${age_mem37}, pos 37" 38 "\${firstname_mem38}, Age : \${age_mem38}, pos 38" 39 "\${firstname_mem39}, Age : \${age_mem39}, pos 39" 40 "\${firstname_mem40}, Age : \${age_mem40}, pos 40" 41 "\${firstname_mem41}, Age : \${age_mem41}, pos 41" 42 "\${firstname_mem42}, Age : \${age_mem42}, pos 42" 43 "\${firstname_mem43}, Age : \${age_mem43}, pos 43" 44 "\${firstname_mem44}, Age : \${age_mem44}, pos 44" 45 "\${firstname_mem45}, Age : \${age_mem45}, pos 45" 46 "\${firstname_mem46}, Age : \${age_mem46}, pos 46" 47 "\${firstname_mem47}, Age : \${age_mem47}, pos 47" 48 "\${firstname_mem48}, Age : \${age_mem48}, pos 48" 49 "\${firstname_mem49}, Age : \${age_mem49}, pos 49" 50 "\${firstname_mem50}, Age : \${age_mem50}, pos 50" 51 "\${firstname_mem51}, Age : \${age_mem51}, pos 51" 52 "\${firstname_mem52}, Age : \${age_mem52}, pos 52" 53 "\${firstname_mem53}, Age : \${age_mem53}, pos 53" 54 "\${firstname_mem54}, Age : \${age_mem54}, pos 54" 55 "\${firstname_mem55}, Age : \${age_mem55}, pos 55" 56 "\${firstname_mem56}, Age : \${age_mem56}, pos 56" 57 "\${firstname_mem57}, Age : \${age_mem57}, pos 57" 58 "\${firstname_mem58}, Age : \${age_mem58}, pos 58" 59 "\${firstname_mem59}, Age : \${age_mem59}, pos 59" 60 "\${firstname_mem60}, Age : \${age_mem60}, pos 60"
	label values final_list final_list

	label variable final_list_confirm "Was the list confirmed?"
	note final_list_confirm: "Was the list confirmed?"
	label define final_list_confirm 1 "Oui" 0 "Non"
	label values final_list_confirm final_list_confirm

	label variable knowledge_01 "4.1. Have you ever heard of bilharzia?"
	note knowledge_01: "4.1. Have you ever heard of bilharzia?"
	label define knowledge_01 1 "Yes" 0 "No" 2 "Don't know/did not answer"
	label values knowledge_01 knowledge_01

	label variable knowledge_02 "4.2. If yes, can you tell us in simple terms what bilharzia is?"
	note knowledge_02: "4.2. If yes, can you tell us in simple terms what bilharzia is?"

	label variable knowledge_03 "4.3. If 'yes,' do you think bilharzia is a disease?"
	note knowledge_03: "4.3. If 'yes,' do you think bilharzia is a disease?"
	label define knowledge_03 1 "Yes" 2 "No" 3 "Don't know"
	label values knowledge_03 knowledge_03

	label variable knowledge_04 "4.4. If you think bilharzia is a disease, do you think it is a serious disease?"
	note knowledge_04: "4.4. If you think bilharzia is a disease, do you think it is a serious disease?"
	label define knowledge_04 1 "Yes" 0 "No" 2 "Don't know/did not answer"
	label values knowledge_04 knowledge_04

	label variable knowledge_05 "4.5. If 'Yes,' what is the cause of bilharzia?"
	note knowledge_05: "4.5. If 'Yes,' what is the cause of bilharzia?"
	label define knowledge_05 1 "1. Virus" 2 "2. Worm" 3 "3. Bacteria" 4 "4. Water" 5 "5. I don't know" 99 "99. Other"
	label values knowledge_05 knowledge_05

	label variable knowledge_05_o "Other cause"
	note knowledge_05_o: "Other cause"

	label variable knowledge_06 "4.6. In your opinion, how do you know if someone has bilharzia?"
	note knowledge_06: "4.6. In your opinion, how do you know if someone has bilharzia?"

	label variable knowledge_07 "4.7. Do you know if there is a test at the hospital to detect bilharzia in an in"
	note knowledge_07: "4.7. Do you know if there is a test at the hospital to detect bilharzia in an individual?"
	label define knowledge_07 1 "Yes" 0 "No" 2 "Don't know/did not answer"
	label values knowledge_07 knowledge_07

	label variable knowledge_08 "4.8. If yes, which one?"
	note knowledge_08: "4.8. If yes, which one?"

	label variable knowledge_09 "4.9. How can a person protect themselves from bilharzia?"
	note knowledge_09: "4.9. How can a person protect themselves from bilharzia?"

	label variable knowledge_09_o "Other form of protection"
	note knowledge_09_o: "Other form of protection"

	label variable knowledge_10 "4.10. How can one contract bilharzia?"
	note knowledge_10: "4.10. How can one contract bilharzia?"

	label variable knowledge_10_o "Other"
	note knowledge_10_o: "Other"

	label variable knowledge_11 "4.11. Do you think bilharzia is contagious?"
	note knowledge_11: "4.11. Do you think bilharzia is contagious?"
	label define knowledge_11 1 "Yes" 0 "No" 2 "Don't know/did not answer"
	label values knowledge_11 knowledge_11

	label variable knowledge_12 "4.12. Do you know the animal that transmits bilharzia?"
	note knowledge_12: "4.12. Do you know the animal that transmits bilharzia?"
	label define knowledge_12 1 "1 . I don't know" 2 "2 . Mosquitoes" 3 "3 . Large terrestrial snails" 4 "4 . Small river snails" 5 "5 . Flies" 99 "99 . Other specify"
	label values knowledge_12 knowledge_12

	label variable knowledge_12_o "Other animals"
	note knowledge_12_o: "Other animals"

	label variable knowledge_13 "4.13 Do you think bilharzia can be cured without treatment?"
	note knowledge_13: "4.13 Do you think bilharzia can be cured without treatment?"
	label define knowledge_13 1 "Yes" 0 "No" 2 "Don't know/did not answer"
	label values knowledge_13 knowledge_13

	label variable knowledge_14 "4.14 Do you think there is a medicine to treat bilharzia?"
	note knowledge_14: "4.14 Do you think there is a medicine to treat bilharzia?"
	label define knowledge_14 1 "Yes" 0 "No" 2 "Don't know/did not answer"
	label values knowledge_14 knowledge_14

	label variable knowledge_15 "4.15 Are you aware of a traditional treatment for bilharzia?"
	note knowledge_15: "4.15 Are you aware of a traditional treatment for bilharzia?"
	label define knowledge_15 1 "Yes" 0 "No" 2 "Don't know/did not answer"
	label values knowledge_15 knowledge_15

	label variable knowledge_16 "4.16 If yes, do you think this traditional treatment is effective, that it reall"
	note knowledge_16: "4.16 If yes, do you think this traditional treatment is effective, that it really treats?"
	label define knowledge_16 1 "Yes" 0 "No" 2 "Don't know/did not answer"
	label values knowledge_16 knowledge_16

	label variable knowledge_17 "4.17 Do you have any comments on the treatment of bilharzia?"
	note knowledge_17: "4.17 Do you have any comments on the treatment of bilharzia?"

	label variable knowledge_18 "4.17 Have you been in contact with a water body (lake, river, stream, marsh, etc"
	note knowledge_18: "4.17 Have you been in contact with a water body (lake, river, stream, marsh, etc.) in the last 12 months?"
	label define knowledge_18 1 "Yes" 0 "No" 2 "Don't know/did not answer"
	label values knowledge_18 knowledge_18

	label variable knowledge_19 "4.18 If 'yes,' what type of water body was it?"
	note knowledge_19: "4.18 If 'yes,' what type of water body was it?"
	label define knowledge_19 1 "1 . Lake" 2 "2 . River" 3 "3 . Stream" 99 "99 . Other"
	label values knowledge_19 knowledge_19

	label variable knowledge_19_o "Other type of water"
	note knowledge_19_o: "Other type of water"

	label variable knowledge_20 "4.20 If 'yes,' where did you come into contact with the water body?"
	note knowledge_20: "4.20 If 'yes,' where did you come into contact with the water body?"
	label define knowledge_20 1 "1. At home" 2 "2. At school/workplace" 3 "3. At the plantation" 99 "99. Other"
	label values knowledge_20 knowledge_20

	label variable knowledge_20_o "Other lieu"
	note knowledge_20_o: "Other lieu"

	label variable knowledge_21 "4.21 If 'yes,' how often?"
	note knowledge_21: "4.21 If 'yes,' how often?"
	label define knowledge_21 1 "1. Every day" 2 "2. Every week" 3 "3. A few times per month"
	label values knowledge_21 knowledge_21

	label variable knowledge_22 "4.22 If 'yes,' when was the last time you went there?"
	note knowledge_22: "4.22 If 'yes,' when was the last time you went there?"
	label define knowledge_22 1 "1. Today" 2 "2. Yesterday" 3 "3. This week" 4 "4. Last week" 5 "5. This month" 6 "6. Last month" 7 "7. Before last month"
	label values knowledge_22 knowledge_22

	label variable knowledge_23 "4.23 If 'Yes,' what are the reasons you have been (or are) in contact with the w"
	note knowledge_23: "4.23 If 'Yes,' what are the reasons you have been (or are) in contact with the watercourse?"

	label variable knowledge_23_o "Other reason"
	note knowledge_23_o: "Other reason"

	label variable health_5_13 "5.13. Have you received awareness campaigns about schistosomiasis in the last fi"
	note health_5_13: "5.13. Have you received awareness campaigns about schistosomiasis in the last five years?"
	label define health_5_13 1 "Yes" 0 "No" 2 "Don't know/did not answer"
	label values health_5_13 health_5_13

	label variable health_5_14_a "a. Manifestation de la bilharziose"
	note health_5_14_a: "a. Manifestation de la bilharziose"
	label define health_5_14_a 1 "Yes" 0 "No" 2 "Don't know/did not answer"
	label values health_5_14_a health_5_14_a

	label variable health_5_14_b "b. pratique pour éviter la bilharzose"
	note health_5_14_b: "b. pratique pour éviter la bilharzose"
	label define health_5_14_b 1 "Yes" 0 "No" 2 "Don't know/did not answer"
	label values health_5_14_b health_5_14_b

	label variable health_5_14_c "c. mesurer à prendre pour le traitement de la bilharziose?"
	note health_5_14_c: "c. mesurer à prendre pour le traitement de la bilharziose?"
	label define health_5_14_c 1 "Yes" 0 "No" 2 "Don't know/did not answer"
	label values health_5_14_c health_5_14_c

	label variable list_actifs "6.1. Do you have any of the following items in your household today? In working "
	note list_actifs: "6.1. Do you have any of the following items in your household today? In working order"

	label variable list_actifs_o "Est-ce qu'il y a un autre actif que l'on a pas pris en compte?"
	note list_actifs_o: "Est-ce qu'il y a un autre actif que l'on a pas pris en compte?"
	label define list_actifs_o 1 "Yes" 0 "No" 2 "Don't know/did not answer"
	label values list_actifs_o list_actifs_o

	label variable actifs_o "Autre actifs"
	note actifs_o: "Autre actifs"

	label variable actifs_o_int "6.2. How many of \${actifs_o} did you have?"
	note actifs_o_int: "6.2. How many of \${actifs_o} did you have?"

	label variable list_agri_equip "6.3 Do you have any of the following equipment in your household today? In worki"
	note list_agri_equip: "6.3 Do you have any of the following equipment in your household today? In working order"

	label variable list_agri_equip_o "Est-ce qu'il y a un autre équipement agricole que l'on n'a pas pris en compte?"
	note list_agri_equip_o: "Est-ce qu'il y a un autre équipement agricole que l'on n'a pas pris en compte?"
	label define list_agri_equip_o 1 "Yes" 0 "No" 2 "Don't know/did not answer"
	label values list_agri_equip_o list_agri_equip_o

	label variable list_agri_equip_o_t "Other list"
	note list_agri_equip_o_t: "Other list"

	label variable list_agri_equip_int "How many of \${list_agri_equip_o_t} did you have?"
	note list_agri_equip_int: "How many of \${list_agri_equip_o_t} did you have?"

	label variable agri_6_5 "6.5. Did you rent the house or are you the owner?"
	note agri_6_5: "6.5. Did you rent the house or are you the owner?"
	label define agri_6_5 1 "[ 1 ] Loué" 2 "[ 2 ] propriétaire" 3 "[ 3 ] Resident non proprietaire qui ne paie pas de loyer" 97 "[ 97 ] ne sait pas" 98 "[98] ne répond pas"
	label values agri_6_5 agri_6_5

	label variable agri_6_6 "6.6. How many separate rooms does the household have?"
	note agri_6_6: "6.6. How many separate rooms does the household have?"

	label variable agri_6_7 "6.7 Does anyone in your household have a bank account?"
	note agri_6_7: "6.7 Does anyone in your household have a bank account?"
	label define agri_6_7 0 "0. No" 1 "1. Yes" 97 "97. Don't know" 98 "98. No response"
	label values agri_6_7 agri_6_7

	label variable agri_6_8 "6.8 Does any member of your household participate in informal savings and credit"
	note agri_6_8: "6.8 Does any member of your household participate in informal savings and credit mechanisms (e.g., savings and credit associations or rotating savings and credit groups)?"
	label define agri_6_8 0 "0. No" 1 "1. Yes" 97 "97. Don't know" 98 "98. No response"
	label values agri_6_8 agri_6_8

	label variable agri_6_9 "6.9 Is any member of your household part of a village women's group?"
	note agri_6_9: "6.9 Is any member of your household part of a village women's group?"
	label define agri_6_9 0 "0. No" 1 "1. Yes" 97 "97. Don't know" 98 "98. No response"
	label values agri_6_9 agri_6_9

	label variable agri_6_10 "6.10 Do you have a mobile money account (e.g., Orange Money, Wave, Tigo Cash)?"
	note agri_6_10: "6.10 Do you have a mobile money account (e.g., Orange Money, Wave, Tigo Cash)?"
	label define agri_6_10 0 "0. No" 1 "1. Yes" 97 "97. Don't know" 98 "98. No response"
	label values agri_6_10 agri_6_10

	label variable agri_6_11 "6.11 If you needed 250,000 FCFA by next week (for a medical emergency or another"
	note agri_6_11: "6.11 If you needed 250,000 FCFA by next week (for a medical emergency or another unexpected expense), would you be able to get it?"
	label define agri_6_11 0 "0. No" 1 "1. Yes" 97 "97. Don't know" 98 "98. No response"
	label values agri_6_11 agri_6_11

	label variable agri_6_12 "6.12 How could you get this money? (multiple-choice response)"
	note agri_6_12: "6.12 How could you get this money? (multiple-choice response)"

	label variable agri_6_12_o "6.12_o Other posibility to get the money"
	note agri_6_12_o: "6.12_o Other posibility to get the money"

	label variable agri_6_14 "6.13 Has at least one member of the household cultivated land (including perenni"
	note agri_6_14: "6.13 Has at least one member of the household cultivated land (including perennial crops), whether owned by them or not, during the last growing season?"
	label define agri_6_14 1 "Yes" 0 "No" 2 "Don't know/did not answer"
	label values agri_6_14 agri_6_14

	label variable agri_6_15 "How many parcels within the fields cultivated by the household?"
	note agri_6_15: "How many parcels within the fields cultivated by the household?"

	label variable autre_culture_yesno "Est-ce qu'il y a un autre type de culture?"
	note autre_culture_yesno: "Est-ce qu'il y a un autre type de culture?"
	label define autre_culture_yesno 1 "Yes" 0 "No" 2 "Don't know/did not answer"
	label values autre_culture_yesno autre_culture_yesno

	label variable autre_culture "Autre type de culture"
	note autre_culture: "Autre type de culture"

	label variable o_culture_01 "11.2 Superficie en hectare de \${autre_culture}"
	note o_culture_01: "11.2 Superficie en hectare de \${autre_culture}"

	label variable o_culture_02 "11.3 Production totale en 2024 (kg) de \${autre_culture}"
	note o_culture_02: "11.3 Production totale en 2024 (kg) de \${autre_culture}"

	label variable o_culture_03 "11.4 Quantité autoconsommée en 2024 de \${autre_culture}"
	note o_culture_03: "11.4 Quantité autoconsommée en 2024 de \${autre_culture}"

	label variable o_culture_04 "11.5 Quantité vendue en kg en 2024 de \${autre_culture}"
	note o_culture_04: "11.5 Quantité vendue en kg en 2024 de \${autre_culture}"

	label variable o_culture_05 "11.6 Prix de vente actuel en FCFA/kg de \${autre_culture}"
	note o_culture_05: "11.6 Prix de vente actuel en FCFA/kg de \${autre_culture}"

	label variable food01 "7.1 Last year, how many months did the lean season last?"
	note food01: "7.1 Last year, how many months did the lean season last?"

	label variable food02 "7.2 Did you (or a family member) engage in paid work during this period to cope "
	note food02: "7.2 Did you (or a family member) engage in paid work during this period to cope with the lean season?"
	label define food02 1 "Yes" 0 "No" 2 "Don't know/did not answer"
	label values food02 food02

	label variable food03 "7.3 Did you sell assets to meet your needs during this period?"
	note food03: "7.3 Did you sell assets to meet your needs during this period?"
	label define food03 1 "Yes" 0 "No" 2 "Don't know/did not answer"
	label values food03 food03

	label variable food05 "a) Livestock"
	note food05: "a) Livestock"
	label define food05 1 "Yes" 0 "No" 2 "Don't know/did not answer"
	label values food05 food05

	label variable food06 "b) Carts"
	note food06: "b) Carts"
	label define food06 1 "Yes" 0 "No" 2 "Don't know/did not answer"
	label values food06 food06

	label variable food07 "c) Production tools"
	note food07: "c) Production tools"
	label define food07 1 "Yes" 0 "No" 2 "Don't know/did not answer"
	label values food07 food07

	label variable food08 "d) Material goods"
	note food08: "d) Material goods"
	label define food08 1 "Yes" 0 "No" 2 "Don't know/did not answer"
	label values food08 food08

	label variable food09 "e) Drawing from other resources (e.g., a shop)"
	note food09: "e) Drawing from other resources (e.g., a shop)"
	label define food09 1 "Yes" 0 "No" 2 "Don't know/did not answer"
	label values food09 food09

	label variable food10 "f) Others, please specify"
	note food10: "f) Others, please specify"

	label variable food11 "7.5 Did any household members migrate during this period due to the lean season?"
	note food11: "7.5 Did any household members migrate during this period due to the lean season?"
	label define food11 1 "Yes" 0 "No" 2 "Don't know/did not answer"
	label values food11 food11

	label variable food12 "7.6 Did you skip meals during the day due to the lean season?"
	note food12: "7.6 Did you skip meals during the day due to the lean season?"
	label define food12 1 "Yes" 0 "No" 2 "Don't know/did not answer"
	label values food12 food12

	label variable agri_income_01 "8.1 Did you (or any member of your household) engage in paid agricultural work i"
	note agri_income_01: "8.1 Did you (or any member of your household) engage in paid agricultural work in the last 12 months?"
	label define agri_income_01 1 "Yes" 0 "No" 2 "Don't know/did not answer"
	label values agri_income_01 agri_income_01

	label variable agri_income_02 "8.2 What type of work was it?"
	note agri_income_02: "8.2 What type of work was it?"
	label define agri_income_02 1 "[1] Agricultural laborer" 2 "[2] Technician" 3 "[3] Other, to be specified"
	label values agri_income_02 agri_income_02

	label variable agri_income_02_o "Other type of work"
	note agri_income_02_o: "Other type of work"

	label variable agri_income_03 "8.3 What was the duration of this work (frequency)?"
	note agri_income_03: "8.3 What was the duration of this work (frequency)?"

	label variable agri_income_04 "8.4. Unit of time"
	note agri_income_04: "8.4. Unit of time"
	label define agri_income_04 1 "[1] Number of days" 2 "[2] Number of weeks" 3 "[3] Number of months"
	label values agri_income_04 agri_income_04

	label variable agri_income_05 "8.5 Amount received in kind and/or in cash for this work."
	note agri_income_05: "8.5 Amount received in kind and/or in cash for this work."

	label variable agri_income_06 "8.6 What was the total amount of expenses incurred for this work (transportation"
	note agri_income_06: "8.6 What was the total amount of expenses incurred for this work (transportation, food, etc.)?"

	label variable species "What species do the owners own? Census of Livestock Resources of the Household"
	note species: "What species do the owners own? Census of Livestock Resources of the Household"

	label variable species_autre "Est-ce qu'il y a d'autres espèces possédées par le ménage?"
	note species_autre: "Est-ce qu'il y a d'autres espèces possédées par le ménage?"
	label define species_autre 1 "Yes" 0 "No" 2 "Don't know/did not answer"
	label values species_autre species_autre

	label variable species_o "Autre espèces"
	note species_o: "Autre espèces"

	label variable agri_income_07_o "8.8 Nombre de têtes de \${species_o} actuellement"
	note agri_income_07_o: "8.8 Nombre de têtes de \${species_o} actuellement"

	label variable agri_income_08_o "8.9 Nombre de têtes de \${species_o} vendues (cette année)"
	note agri_income_08_o: "8.9 Nombre de têtes de \${species_o} vendues (cette année)"

	label variable agri_income_09_o_o "8.10 Principales raisons de la vente de \${species_o}"
	note agri_income_09_o_o: "8.10 Principales raisons de la vente de \${species_o}"
	label define agri_income_09_o_o 1 "1= input needs" 2 "2= agricultural equipment needs" 3 "3=immediate spending needs" 4 "4= familyceremony" 5 "5= death of animal ;" 6 "6= illness expenses" 7 "7= others, to be specified"
	label values agri_income_09_o_o agri_income_09_o_o

	label variable agri_income_09_o_o_o "Autre raison de vendre"
	note agri_income_09_o_o_o: "Autre raison de vendre"

	label variable agri_income_10_o "8.11 Prix moyen par tête de \${species_o} en FCFA"
	note agri_income_10_o: "8.11 Prix moyen par tête de \${species_o} en FCFA"

	label variable animals_sales "Income from Livestock Production Sale of Animals"
	note animals_sales: "Income from Livestock Production Sale of Animals"

	label variable animals_sales_o "Est-ce qu'il y a d'autres animaux vendus par le ménage?"
	note animals_sales_o: "Est-ce qu'il y a d'autres animaux vendus par le ménage?"
	label define animals_sales_o 1 "Yes" 0 "No" 2 "Don't know/did not answer"
	label values animals_sales_o animals_sales_o

	label variable animals_sales_t "Autre animal vendu par le ménage?"
	note animals_sales_t: "Autre animal vendu par le ménage?"

	label variable agri_income_11_o "8.13 Nombre de têtes de \${animals_sales_t} vendus"
	note agri_income_11_o: "8.13 Nombre de têtes de \${animals_sales_t} vendus"

	label variable agri_income_12_o "8.14 Montant en FCFA pour la vente de \${animals_sales_t}"
	note agri_income_12_o: "8.14 Montant en FCFA pour la vente de \${animals_sales_t}"

	label variable agri_income_13_o "8.15 Nature des produits provenant de \${animals_sales_t} vendus"
	note agri_income_13_o: "8.15 Nature des produits provenant de \${animals_sales_t} vendus"

	label variable agri_income_14_o "8.16 Montant en FCFA du total de vente pour les produits provenant de \${animals"
	note agri_income_14_o: "8.16 Montant en FCFA du total de vente pour les produits provenant de \${animals_sales_t}"

	label variable agri_income_13_o_t "Other nature"
	note agri_income_13_o_t: "Other nature"

	label variable agri_income_15 "8.17 Do you have employees for your agricultural activities?"
	note agri_income_15: "8.17 Do you have employees for your agricultural activities?"
	label define agri_income_15 1 "Yes" 0 "No" 2 "Don't know/did not answer"
	label values agri_income_15 agri_income_15

	label variable agri_income_16 "8.19 If yes, please specify the number."
	note agri_income_16: "8.19 If yes, please specify the number."

	label variable agri_income_17 "8.20 Are these employees paid?"
	note agri_income_17: "8.20 Are these employees paid?"
	label define agri_income_17 1 "Yes" 0 "No" 2 "Don't know/did not answer"
	label values agri_income_17 agri_income_17

	label variable agri_income_18 "8.21 How are they paid?"
	note agri_income_18: "8.21 How are they paid?"
	label define agri_income_18 1 "1. In kind" 2 "2. Money" 3 "3. Other (please specify)"
	label values agri_income_18 agri_income_18

	label variable agri_income_18_o "Other paid mode"
	note agri_income_18_o: "Other paid mode"

	label variable agri_income_19 "8.22 What is the total amount of payment in the last 12 months?"
	note agri_income_19: "8.22 What is the total amount of payment in the last 12 months?"

	label variable agri_income_20 "8.23 Type of non agricultural activity"
	note agri_income_20: "8.23 Type of non agricultural activity"

	label variable agri_income_20_t "Est-ce qu'il y a d'autres activités non agricoles?"
	note agri_income_20_t: "Est-ce qu'il y a d'autres activités non agricoles?"
	label define agri_income_20_t 1 "Yes" 0 "No" 2 "Don't know/did not answer"
	label values agri_income_20_t agri_income_20_t

	label variable agri_income_20_o "8.23_o Other type of non agricultural activity"
	note agri_income_20_o: "8.23_o Other type of non agricultural activity"

	label variable agri_income_21_h_o "8.24 Number of People Involved (man)"
	note agri_income_21_h_o: "8.24 Number of People Involved (man)"

	label variable agri_income_21_f_o "8.24 Number of People Involved (woman)"
	note agri_income_21_f_o: "8.24 Number of People Involved (woman)"

	label variable agri_income_22_o "8.25 Activity frequenct per year (months)"
	note agri_income_22_o: "8.25 Activity frequenct per year (months)"

	label variable agri_income_23_o "8.26 Income by frequency"
	note agri_income_23_o: "8.26 Income by frequency"

	label variable agri_income_25 "8.28 Do you have employees for your non-agricultural activities?"
	note agri_income_25: "8.28 Do you have employees for your non-agricultural activities?"
	label define agri_income_25 1 "Yes" 0 "No" 2 "Don't know/did not answer"
	label values agri_income_25 agri_income_25

	label variable agri_income_26 "8.29 If yes, please specify the number."
	note agri_income_26: "8.29 If yes, please specify the number."

	label variable agri_income_27 "8.30 Are these employees paid?"
	note agri_income_27: "8.30 Are these employees paid?"
	label define agri_income_27 1 "Yes" 0 "No" 2 "Don't know/did not answer"
	label values agri_income_27 agri_income_27

	label variable agri_income_28 "8.31 How are they paid?"
	note agri_income_28: "8.31 How are they paid?"

	label variable agri_income_28_o "8.31_o Other mode of payment"
	note agri_income_28_o: "8.31_o Other mode of payment"

	label variable agri_income_29 "8.32 Total amount of payment in the last 12 months?"
	note agri_income_29: "8.32 Total amount of payment in the last 12 months?"

	label variable agri_income_30 "8.33 Do you have any members of your household migrating within or outside the c"
	note agri_income_30: "8.33 Do you have any members of your household migrating within or outside the country?"
	label define agri_income_30 1 "Yes" 0 "No" 2 "Don't know/did not answer"
	label values agri_income_30 agri_income_30

	label variable agri_income_31 "8.34 If yes, where are they?"
	note agri_income_31: "8.34 If yes, where are they?"

	label variable agri_income_31_o "8.34_o Other migration zone"
	note agri_income_31_o: "8.34_o Other migration zone"

	label variable agri_income_32 "8.35 If yes, do they send money for household needs?"
	note agri_income_32: "8.35 If yes, do they send money for household needs?"
	label define agri_income_32 1 "Yes" 0 "No" 2 "Don't know/did not answer"
	label values agri_income_32 agri_income_32

	label variable agri_income_33 "8.36. If yes, how much have you received in total in the last 12 months?"
	note agri_income_33: "8.36. If yes, how much have you received in total in the last 12 months?"

	label variable agri_income_34 "8.37 Have you (or a member of your household) taken a loan during this year?"
	note agri_income_34: "8.37 Have you (or a member of your household) taken a loan during this year?"
	label define agri_income_34 1 "Yes" 0 "No" 2 "Don't know/did not answer"
	label values agri_income_34 agri_income_34

	label variable agri_income_35 "8.38 If no, why didn't you do it?"
	note agri_income_35: "8.38 If no, why didn't you do it?"
	label define agri_income_35 1 "1= I didn't need it" 2 "2= I tried but it was rejected" 3 "3= I had no one to ask" 4 "4= I knew it was impossible so I didn't even try" 5 "5= I didn't have collateral" 6 "6= I was afraid of losing my collateral" 7 "7= I was afraid I couldn't repay" 8 "8= The interest rates were too high" 9 "9= It contradicted my religious beliefs" 99 "10= Other (please specify))"
	label values agri_income_35 agri_income_35

	label variable agri_income_name "Choisissez les membres de votre ménage qui ont contracté un prêt."
	note agri_income_name: "Choisissez les membres de votre ménage qui ont contracté un prêt."

	label variable agri_income_40 "8.43 Have you (or a member of your household) lent money to others during this y"
	note agri_income_40: "8.43 Have you (or a member of your household) lent money to others during this year?"
	label define agri_income_40 1 "Yes" 0 "No" 2 "Don't know/did not answer"
	label values agri_income_40 agri_income_40

	label variable agri_loan_name "Choisissez les membres de votre ménage qui ont prêté de l'argent à d'autres pers"
	note agri_loan_name: "Choisissez les membres de votre ménage qui ont prêté de l'argent à d'autres personnes."

	label variable product_divers "What are the overall expenses of the household in the last four months, the fina"
	note product_divers: "What are the overall expenses of the household in the last four months, the financing sources or practices you are developing to meet these needs, and who are the responsible parties for these financing needs within the household?"

	label variable expenses_goods "8.51 Types of expenses"
	note expenses_goods: "8.51 Types of expenses"

	label variable expenses_goods_t "Est-ce qu'il y a d'autre type de dépense?"
	note expenses_goods_t: "Est-ce qu'il y a d'autre type de dépense?"
	label define expenses_goods_t 1 "Yes" 0 "No" 2 "Don't know/did not answer"
	label values expenses_goods_t expenses_goods_t

	label variable expenses_goods_o "Autre à préciser"
	note expenses_goods_o: "Autre à préciser"

	label variable agri_income_47_o "Amount (KG) of \${expenses_goods_o}"
	note agri_income_47_o: "Amount (KG) of \${expenses_goods_o}"

	label variable agri_income_48_o "Amount (FCFA)"
	note agri_income_48_o: "Amount (FCFA)"

	label variable living_01 "9.1 What is the main source of drinking water supply?"
	note living_01: "9.1 What is the main source of drinking water supply?"
	label define living_01 1 "1 = Indoor tap" 2 "2 = Public tap" 3 "3 = Neighbor's tap" 4 "4 = Protected well" 5 "5 = Unprotected well" 6 "6 = Borehole" 7 "7 = Tanker truck service" 8 "8 = Water vendor" 9 "9 = Spring" 10 "10 = Stream" 99 "99 = Other"
	label values living_01 living_01

	label variable living_01_o "9.1_o Other source of drinking water"
	note living_01_o: "9.1_o Other source of drinking water"

	label variable living_02 "9.2 Is the water used treated in the household?"
	note living_02: "9.2 Is the water used treated in the household?"
	label define living_02 1 "Yes" 0 "No" 2 "Don't know/did not answer"
	label values living_02 living_02

	label variable living_03 "9.3 If yes, how do you treat the water?"
	note living_03: "9.3 If yes, how do you treat the water?"
	label define living_03 1 "1 = Bleach/Aqua tabs" 2 "2 = Boiling" 3 "3 = Filtration" 99 "99 = Other (please specify)"
	label values living_03 living_03

	label variable living_03_o "9.3_o Other type of water treat"
	note living_03_o: "9.3_o Other type of water treat"

	label variable living_04 "9.4 What type of toilet facilities does the household use?"
	note living_04: "9.4 What type of toilet facilities does the household use?"
	label define living_04 1 "0 None/Outdoors" 2 "1 Flush toilet with sewer" 3 "2 Flush toilet with septic tank" 4 "3 Bucket" 5 "4 Covered pit latrine" 6 "5 Uncovered pit latrine" 7 "6 Improved latrines" 99 "99 Others"
	label values living_04 living_04

	label variable living_04_o "9.4_o Other type of toilet facilities"
	note living_04_o: "9.4_o Other type of toilet facilities"

	label variable living_05 "9.5 What is the primary fuel used for cooking?"
	note living_05: "9.5 What is the primary fuel used for cooking?"
	label define living_05 1 "1 Charcoal" 2 "2 Firewood" 3 "3 Gas" 4 "4 Electricity" 5 "5 Petrol/oil/ethanol" 6 "6 Animal waste/dung" 7 "7 Solar" 99 "99 Other"
	label values living_05 living_05

	label variable living_05_o "9.5_ Other type of primary fuel for cooking"
	note living_05_o: "9.5_ Other type of primary fuel for cooking"

	label variable living_06 "9.6 What is the primary fuel used for lighting?"
	note living_06: "9.6 What is the primary fuel used for lighting?"
	label define living_06 1 "1 Electricity (Sénélec)" 2 "2 Electric generator" 3 "3 Solar" 4 "4 Gas lamp" 5 "5 Oil/hurricane lamp" 6 "6 Candle" 7 "7 Torchlight" 99 "99 Other"
	label values living_06 living_06

	label variable living_06_o "9.6_o Other type of primary fuel used for ligthing"
	note living_06_o: "9.6_o Other type of primary fuel used for ligthing"

	label variable beliefs_01 "10.1 How likely is it that you will contract schistosomiasis in the next 12 mont"
	note beliefs_01: "10.1 How likely is it that you will contract schistosomiasis in the next 12 months?"
	label define beliefs_01 1 "1 = Very likely" 2 "2 = Somewhat likely" 3 "3 = Neutral" 4 "4 = Unlikely" 5 "5 = Not at all likely" 6 "6 = Currently affected by schistosomiasis"
	label values beliefs_01 beliefs_01

	label variable beliefs_02 "10.2 How likely is it that a member of your household will contract schistosomia"
	note beliefs_02: "10.2 How likely is it that a member of your household will contract schistosomiasis in the next 12 months? (If there is already a household member affected by schistosomiasis, ask the question for all unaffected individuals)"
	label define beliefs_02 1 "1 = Very likely" 2 "2 = Somewhat likely" 3 "3 = Neutral" 4 "4 = Unlikely" 5 "5 = Not at all likely" 6 "6 = Currently affected by schistosomiasis"
	label values beliefs_02 beliefs_02

	label variable beliefs_03 "10.3 How likely is it that a randomly chosen child in your village, between the "
	note beliefs_03: "10.3 How likely is it that a randomly chosen child in your village, between the ages of 5 and 14, will contract schistosomiasis in the next 12 months?"
	label define beliefs_03 1 "1 = Very likely" 2 "2 = Somewhat likely" 3 "3 = Neutral" 4 "4 = Unlikely" 5 "5 = Not at all likely"
	label values beliefs_03 beliefs_03

	label variable beliefs_04 "10.4 To what extent do you agree with the following statement: The lands in this"
	note beliefs_04: "10.4 To what extent do you agree with the following statement: The lands in this village should be owned by the community and not individuals."
	label define beliefs_04 1 "1 = Strongly agree" 2 "2 = Agree" 3 "3 = Neither agree nor disagree" 4 "4 = Disagree" 5 "5 = Strongly disagree"
	label values beliefs_04 beliefs_04

	label variable beliefs_05 "10.5 To what extent do you agree with the following statement: The water sources"
	note beliefs_05: "10.5 To what extent do you agree with the following statement: The water sources in this village should be owned by the community and not individuals."
	label define beliefs_05 1 "1 = Strongly agree" 2 "2 = Agree" 3 "3 = Neither agree nor disagree" 4 "4 = Disagree" 5 "5 = Strongly disagree"
	label values beliefs_05 beliefs_05

	label variable beliefs_06 "10.6 To what extent do you agree with the following statement: If I work on my o"
	note beliefs_06: "10.6 To what extent do you agree with the following statement: If I work on my own lands, I have the right to use the products I obtained through my work."
	label define beliefs_06 1 "1 = Strongly agree" 2 "2 = Agree" 3 "3 = Neither agree nor disagree" 4 "4 = Disagree" 5 "5 = Strongly disagree"
	label values beliefs_06 beliefs_06

	label variable beliefs_07 "10.7 To what extent do you agree with the following statement: If I work on land"
	note beliefs_07: "10.7 To what extent do you agree with the following statement: If I work on lands owned by the community, I have the right to use the products I obtained through my work."
	label define beliefs_07 1 "1 = Strongly agree" 2 "2 = Agree" 3 "3 = Neither agree nor disagree" 4 "4 = Disagree" 5 "5 = Strongly disagree"
	label values beliefs_07 beliefs_07

	label variable beliefs_08 "10.8 To what extent do you agree with the following statement: If I fish in a wa"
	note beliefs_08: "10.8 To what extent do you agree with the following statement: If I fish in a water source owned by the community, I have the right to use the products I obtained through my work."
	label define beliefs_08 1 "1 = Strongly agree" 2 "2 = Agree" 3 "3 = Neither agree nor disagree" 4 "4 = Disagree" 5 "5 = Strongly disagree"
	label values beliefs_08 beliefs_08

	label variable beliefs_09 "10.9 To what extent do you agree with the following statement: If I harvest prod"
	note beliefs_09: "10.9 To what extent do you agree with the following statement: If I harvest products from a water source owned by the community, I have the right to use the products I obtained through my work."
	label define beliefs_09 1 "1 = Strongly agree" 2 "2 = Agree" 3 "3 = Neither agree nor disagree" 4 "4 = Disagree" 5 "5 = Strongly disagree"
	label values beliefs_09 beliefs_09

	label variable enum_01 "12.1 Did other people besides the respondents follow the interview?"
	note enum_01: "12.1 Did other people besides the respondents follow the interview?"
	label define enum_01 1 "Yes" 0 "No" 2 "Don't know/did not answer"
	label values enum_01 enum_01

	label variable enum_02 "12.2 Approximately, how many people observed the interview?"
	note enum_02: "12.2 Approximately, how many people observed the interview?"

	label variable enum_03 "12.3 What are the roof materials of the house where the head of the household sl"
	note enum_03: "12.3 What are the roof materials of the house where the head of the household sleeps?"
	label define enum_03 1 "[1] Concrete/cement" 2 "[2] Tile/slate" 3 "[3] Zinc" 4 "[4] Thatch/straw" 99 "[99] Other"
	label values enum_03 enum_03

	label variable enum_03_o "Other roof materials"
	note enum_03_o: "Other roof materials"

	label variable enum_04 "12.4 What are the wall materials of the house where the head of the household sl"
	note enum_04: "12.4 What are the wall materials of the house where the head of the household sleeps?"
	label define enum_04 1 "[1] Cement bricks" 2 "[2] Mud bricks" 3 "[3] Wood" 4 "[4] Metal sheeting/zinc" 5 "[5] Rammed earth" 6 "[6] Straw/Stalks" 99 "[99] Other"
	label values enum_04 enum_04

	label variable enum_04_o "Other wall materials"
	note enum_04_o: "Other wall materials"

	label variable enum_05 "12.5 If observed, what is the main floor material of the house where the head of"
	note enum_05: "12.5 If observed, what is the main floor material of the house where the head of the household sleeps?"
	label define enum_05 1 "[1] Mud" 2 "[2] Dirt" 3 "[3] Stone/baked earth" 4 "[4] Cement/concrete blocks" 5 "[5] Wood" 99 "[99] Other"
	label values enum_05 enum_05

	label variable enum_05_o "Other main floor material"
	note enum_05_o: "Other main floor material"

	label variable enum_06 "12.6 How do you rate the respondent's overall understanding of the questions?"
	note enum_06: "12.6 How do you rate the respondent's overall understanding of the questions?"
	label define enum_06 1 "[1] The respondent understood everything well" 2 "[2] The respondent understood most things well" 3 "[3] The respondent understood some things well" 4 "[4] The respondent understood very few things well" 5 "[5] The respondent understood almost nothing"
	label values enum_06 enum_06

	label variable enum_07 "12.7 Please indicate the difficult parts."
	note enum_07: "12.7 Please indicate the difficult parts."

	label variable enum_08 "12.8 Please give your opinion on the household's income."
	note enum_08: "12.8 Please give your opinion on the household's income."
	label define enum_08 1 "[1] Very poor" 2 "[2] Below average" 3 "[3] Average" 4 "[4] Above average" 5 "[5] Rich"
	label values enum_08 enum_08



	capture {
		foreach rgvar of varlist add_new_* {
			label variable `rgvar' "Voici la liste des membres du ménage: \${name_list_txt} Y a-t-il un nouveau memb"
			note `rgvar': "Voici la liste des membres du ménage: \${name_list_txt} Y a-t-il un nouveau membre à ajouter ?"
			label define `rgvar' 1 "Yes" 0 "No" 2 "Don't know/did not answer"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist still_member_* {
			label variable `rgvar' "Ancien Membre Nom complet: \${pull_hh_full_name_calc_} Age: \${pull_hh_age_} Cet"
			note `rgvar': "Ancien Membre Nom complet: \${pull_hh_full_name_calc_} Age: \${pull_hh_age_} Cette personne fait-elle partie du ménage actuel de la personne ciblée ? AGENT ENQUETEUR : S'il y a des corrections à faire, vous pouvez les faire à l'écran suivante."
			label define `rgvar' 1 "Yes" 0 "No" 2 "Don't know/did not answer"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist still_member_whynot_* {
			label variable `rgvar' "Pourquoi il/elle n´est plus membre du ménage?"
			note `rgvar': "Pourquoi il/elle n´est plus membre du ménage?"
			label define `rgvar' 11 "C'est la personne ciblée elle même qui a changé de ménage" 1 "S'est marié(e), mais habite dans la même concession" 2 "S'est marié(e), et habite dans une concession différente" 3 "A déménagé avec des parents dans la même concession" 4 "A déménagé avec des parents dans un village/quartier différent" 5 "A déménagé pour d’autres raisons, dans le même village/quartier" 6 "A déménagé pour d’autres raisons dans un village/quartier différent" 7 "A migré hors du pays" 8 "Est décédé(e)" 9 "Pas reconnu / erreur" -777 "Autre à spécifier"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist still_member_whynot_o_* {
			label variable `rgvar' "Autre raison"
			note `rgvar': "Autre raison"
		}
	}

	capture {
		foreach rgvar of varlist nom_complet_* {
			label variable `rgvar' "Nom complet"
			note `rgvar': "Nom complet"
		}
	}

	capture {
		foreach rgvar of varlist hh_gender_* {
			label variable `rgvar' "3.3. Gender"
			note `rgvar': "3.3. Gender"
			label define `rgvar' 1 "1. Man" 2 "2. Woman"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist age_* {
			label variable `rgvar' "3.4. Age (in completed years)"
			note `rgvar': "3.4. Age (in completed years)"
		}
	}

	capture {
		foreach rgvar of varlist hh_ethnicity_* {
			label variable `rgvar' "3.5. Ethnicity"
			note `rgvar': "3.5. Ethnicity"
			label define `rgvar' 1 "1. Wolof" 2 "2. Sérer" 3 "3. Peulh" 4 "4. Diola" 5 "5. Moor" 7 "7. Lébou" 8 "8. Soninké" 99 "99. other"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hh_ethnicity_o_* {
			label variable `rgvar' "Other ethnicity"
			note `rgvar': "Other ethnicity"
		}
	}

	capture {
		foreach rgvar of varlist hh_relation_with_* {
			label variable `rgvar' "3.6. Relationship with the Household Head"
			note `rgvar': "3.6. Relationship with the Household Head"
			label define `rgvar' 1 "01. Head of household (themselves)" 2 "02. Spouse of the CM" 3 "03. Son/Daughter of the CM" 4 "05. Spouse of son/daughter of CM" 5 "05. Grandson/Granddaughter of the CM" 6 "06. Father/Mother of the CM" 7 "07. Father/Mother of the CM’s spouse" 8 "08. Brother/Sister of the CM" 9 "09. Brother/Sister of the CM’s spouse" 10 "10. Adopted child" 11 "11. Domestic help" 12 "12. Other person related to CM" 13 "13. Other person not related to CM" 14 "14. Niece/ Nephew"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hh_relation_with_o_* {
			label variable `rgvar' "Other relationship form"
			note `rgvar': "Other relationship form"
		}
	}

	capture {
		foreach rgvar of varlist hh_education_skills_* {
			label variable `rgvar' "3.7. Education - Skills (multiple choice)"
			note `rgvar': "3.7. Education - Skills (multiple choice)"
		}
	}

	capture {
		foreach rgvar of varlist hh_education_level_* {
			label variable `rgvar' "3.8. Level of Education Reached"
			note `rgvar': "3.8. Level of Education Reached"
			label define `rgvar' 0 "0. No level" 1 "1 . Primary level" 2 "2 . Secondary level" 3 "3 . Tertiary level" 4 "4. Technical and vocational school" 99 "99 . Other level"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hh_education_level_o_* {
			label variable `rgvar' "Other level"
			note `rgvar': "Other level"
		}
	}

	capture {
		foreach rgvar of varlist hh_education_year_achieve_* {
			label variable `rgvar' "3.9. How many years of schooling has \${hh_full_name_calc} completed?"
			note `rgvar': "3.9. How many years of schooling has \${hh_full_name_calc} completed?"
		}
	}

	capture {
		foreach rgvar of varlist hh_main_activity_* {
			label variable `rgvar' "3.10. Main activity outside the home"
			note `rgvar': "3.10. Main activity outside the home"
			label define `rgvar' 0 "0 . Unemployed" 1 "1 . Agriculture" 2 "2 . Livestock farming" 3 "3 . Fishing" 4 "4 . Forestry" 5 "5 . Handicraft" 6 "6 . Commerce" 7 "7 . Salaried employment" 8 "8 . Transportation" 9 "9 . Harvesting/Gathering" 10 "11 . Pupil/student" 99 "99 . Other(to be specified)"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hh_main_activity_o_* {
			label variable `rgvar' "Other activity"
			note `rgvar': "Other activity"
		}
	}

	capture {
		foreach rgvar of varlist hh_mother_live_* {
			label variable `rgvar' "3.11. Did \${hh_full_name_calc} 's mother live in the village on the day of \${h"
			note `rgvar': "3.11. Did \${hh_full_name_calc} 's mother live in the village on the day of \${hh_full_name_calc}'s birth?"
			label define `rgvar' 1 "Yes" 0 "No" 2 "Don't know/did not answer"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hh_relation_imam_* {
			label variable `rgvar' "3.12. Family relationship with the imam or village chief"
			note `rgvar': "3.12. Family relationship with the imam or village chief"
			label define `rgvar' 1 "1. Imam" 2 "2. Village chief" 3 "3. both" 4 "4. none"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hh_presence_winter_* {
			label variable `rgvar' "3.13. Presence in the Winter/Rainy Season"
			note `rgvar': "3.13. Presence in the Winter/Rainy Season"
			label define `rgvar' 1 "Yes" 0 "No" 2 "Don't know/did not answer"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hh_presence_dry_* {
			label variable `rgvar' "3.14. Presence in the Dry Season"
			note `rgvar': "3.14. Presence in the Dry Season"
			label define `rgvar' 1 "Yes" 0 "No" 2 "Don't know/did not answer"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hh_active_agri_* {
			label variable `rgvar' "3.15. Is he/she an active agricultural laborer?"
			note `rgvar': "3.15. Is he/she an active agricultural laborer?"
			label define `rgvar' 1 "Yes" 0 "No" 2 "Don't know/did not answer"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hh_01_* {
			label variable `rgvar' "3.16. Au cours des 7 derniers jours combien d'heures \${hh_full_name_calc} a con"
			note `rgvar': "3.16. Au cours des 7 derniers jours combien d'heures \${hh_full_name_calc} a consacré aux tâches ménagères ou à la préparation des repas?"
		}
	}

	capture {
		foreach rgvar of varlist hh_02_* {
			label variable `rgvar' "3.17. Au cours des 7 derniers jours combien d'heures \${hh_full_name_calc} a t-i"
			note `rgvar': "3.17. Au cours des 7 derniers jours combien d'heures \${hh_full_name_calc} a t-il consacré pour aller chercher de l'eau?"
		}
	}

	capture {
		foreach rgvar of varlist hh_03_* {
			label variable `rgvar' "3.18. Au cours des 12 derniers mois, \${hh_full_name_calc} a-t-il travaillé dans"
			note `rgvar': "3.18. Au cours des 12 derniers mois, \${hh_full_name_calc} a-t-il travaillé dans le cadre d'activités agricoles domestiques (y compris les activités liées à l'élevage et à la pêche), que ce soit pour la vente ou pour l'alimentation du ménage ? (skip à 3.23 si 'non')"
			label define `rgvar' 1 "Yes" 0 "No" 2 "Don't know/did not answer"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hh_04_* {
			label variable `rgvar' "3.19. Au cours des 7 derniers jours, combien d'heures \${hh_full_name_calc} a-t-"
			note `rgvar': "3.19. Au cours des 7 derniers jours, combien d'heures \${hh_full_name_calc} a-t-il travaillé dans le cadre d'activités agricoles domestiques (y compris les activités liées à l'élevage et à la pêche), que ce soit pour la vente ou pour l'alimentation du ménage ?"
		}
	}

	capture {
		foreach rgvar of varlist hh_05_* {
			label variable `rgvar' "3.20.Pendant la période de plantation de la dernière campagne agricole, combien "
			note `rgvar': "3.20.Pendant la période de plantation de la dernière campagne agricole, combien d'heures \${hh_full_name_calc} a-t-il travaillé dans le cadre d'activités agricoles au cours d'une semaine normale (période de 7 jours)?"
		}
	}

	capture {
		foreach rgvar of varlist hh_06_* {
			label variable `rgvar' "3.21. Pendant la période de croissance maximale de la dernière campagne agricole"
			note `rgvar': "3.21. Pendant la période de croissance maximale de la dernière campagne agricole (après la plantation et avant la récolte), combien d'heures \${hh_full_name_calc} a-t-il travaillé dans le cadre d'activités agricoles au cours d'une semaine normale (période de 7 jours)?"
		}
	}

	capture {
		foreach rgvar of varlist hh_07_* {
			label variable `rgvar' "3.22. Pendant la période de récolte de la dernière campagne agricole, combien de"
			note `rgvar': "3.22. Pendant la période de récolte de la dernière campagne agricole, combien de jours \${hh_full_name_calc} a-t-il travaillé dans le cadre d'activités agricoles au cours d'une semaine normale (période de 7 jours)?"
		}
	}

	capture {
		foreach rgvar of varlist hh_08_* {
			label variable `rgvar' "3.23. Au cours des 7 derniers jours, combien d'heures \${hh_full_name_calc} a t-"
			note `rgvar': "3.23. Au cours des 7 derniers jours, combien d'heures \${hh_full_name_calc} a t-il consacré pour travailler dans un commerce, une activité de transformation, ou un service marchand pour son propre compte ou pour le compte d'un autre membre du ménage? Par exemple comme artisan ou commerçant"
		}
	}

	capture {
		foreach rgvar of varlist hh_09_* {
			label variable `rgvar' "3.24. Au cours des 7 derniers jours, combien d'heures \${hh_full_name_calc} a t-"
			note `rgvar': "3.24. Au cours des 7 derniers jours, combien d'heures \${hh_full_name_calc} a t-il consacré pour travailler pour une entreprise, pour l'Etat, pour un patron ou toute autre personne qui n'est pas membre de votre ménage? (même à temps partiel ou de manière occasionnelle)"
		}
	}

	capture {
		foreach rgvar of varlist hh_10_* {
			label variable `rgvar' "3.25. Au cours des 12 derniers mois, combien d'heures par semaine en moyenne \${"
			note `rgvar': "3.25. Au cours des 12 derniers mois, combien d'heures par semaine en moyenne \${hh_full_name_calc} a-t-il passé à moins d'un mètre ou dans une source d'eau de surface? (si 0, skip 3.26 - 3.38)"
		}
	}

	capture {
		foreach rgvar of varlist hh_11_* {
			label variable `rgvar' "3.26. Quelle(s) source(s) d'eau de surface? 1 = Lac, 2=étang, 3=rivière, 4=canal"
			note `rgvar': "3.26. Quelle(s) source(s) d'eau de surface? 1 = Lac, 2=étang, 3=rivière, 4=canal d'irrigation, 99= autre (à préciser)"
			label define `rgvar' 1 "1 . Lake" 2 "2 . Pond" 3 "3 . River" 4 "4 . Irrigation canal" 99 "99 . Other (specify)"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hh_11_o_* {
			label variable `rgvar' "Autre source"
			note `rgvar': "Autre source"
		}
	}

	capture {
		foreach rgvar of varlist hh_12_* {
			label variable `rgvar' "3.27. Au cours des 12 derniers mois, pourquoi \${hh_full_name_calc} a-t-il passé"
			note `rgvar': "3.27. Au cours des 12 derniers mois, pourquoi \${hh_full_name_calc} a-t-il passé du temps près de (< 1 m) ou dans la/les source(s) d'eau? (choix muliples) (1 = aller chercher de l'eau pour le ménage, 2= donner de l'eau au bétail, 3= aller chercher de l'eau pour l'agriculture, 4=laver des vêtements, 5=faire la vaisselle, 6 = récolter de la végétation aquatique, 7=nager/se baigner, 8=jouer, 99=autre(à préciser)"
		}
	}

	capture {
		foreach rgvar of varlist hh_12_a_* {
			label variable `rgvar' "Est-ce qu'il a d'autres raisons pour laquelle \${hh_full_name_calc} a-t-il passé"
			note `rgvar': "Est-ce qu'il a d'autres raisons pour laquelle \${hh_full_name_calc} a-t-il passé du temps près de (< 1 m) ou dans la/les source(s) d'eau?"
			label define `rgvar' 1 "Yes" 0 "No" 2 "Don't know/did not answer"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hh_12_o_* {
			label variable `rgvar' "Autre raison"
			note `rgvar': "Autre raison"
		}
	}

	capture {
		foreach rgvar of varlist hh_13_* {
			label variable `rgvar' "3.28. Au cours des 12 derniers mois, combien d'heures par semaine en moyenne \${"
			note `rgvar': "3.28. Au cours des 12 derniers mois, combien d'heures par semaine en moyenne \${hh_full_name_calc} a t-il consacré à \${hh_12-name} près de (< 1 m) ou dans la/les source(s) d'eau?"
		}
	}

	capture {
		foreach rgvar of varlist hh_13_o_* {
			label variable `rgvar' "3.28. Au cours des 12 derniers mois, combien d'heures par semaine en moyenne \${"
			note `rgvar': "3.28. Au cours des 12 derniers mois, combien d'heures par semaine en moyenne \${hh_full_name_calc} a t-il consacré à \${hh_12_o} près de (< 1 m) ou dans la/les source(s) d'eau?"
		}
	}

	capture {
		foreach rgvar of varlist hh_14_* {
			label variable `rgvar' "3.29. (skip cette question si l'option 6 à 3.27 n'a pas été sélectionnée.) Au co"
			note `rgvar': "3.29. (skip cette question si l'option 6 à 3.27 n'a pas été sélectionnée.) Au cours des 12 derniers mois, combien de végétation aquatique a-t-il/elle recolté près de (< 1 m) ou dans la/les source(s) d'eau par semaine, en moyenne? (1= kg Tipha, 2= kg autre)"
		}
	}

	capture {
		foreach rgvar of varlist hh_14_a_* {
			label variable `rgvar' "3.29.a. Au cours des 12 derniers mois, combien de fois a-t-il/elle recolté de vé"
			note `rgvar': "3.29.a. Au cours des 12 derniers mois, combien de fois a-t-il/elle recolté de végétation aquatique près de (< 1 m) ou dans la/les source(s) d'eau?"
		}
	}

	capture {
		foreach rgvar of varlist hh_14_b_* {
			label variable `rgvar' "3.29.b. Pour chaque fois, en moyenne, combien de végétation aquatique a-t-il/ell"
			note `rgvar': "3.29.b. Pour chaque fois, en moyenne, combien de végétation aquatique a-t-il/elle recolté près de (< 1 m) ou dans la/les source(s) d'eau? (1= kg Tipha, 2= kg autre)'"
		}
	}

	capture {
		foreach rgvar of varlist hh_15_* {
			label variable `rgvar' "3.30. (skip cette question si l'option 6 à 3.27 n'a pas été sélectionnée.) Comme"
			note `rgvar': "3.30. (skip cette question si l'option 6 à 3.27 n'a pas été sélectionnée.) Comment a-t-il utilisé la végétation aquatique ?"
			label define `rgvar' 1 "1= Vendre" 2 "2= Engrais" 3 "3= Alimentation pour le betail" 4 "4=Matière première pour le biodigesteur" 5 "5= Rien" 99 "99= Autre (à préciser)"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hh_15_o_* {
			label variable `rgvar' "Autre à préciser"
			note `rgvar': "Autre à préciser"
		}
	}

	capture {
		foreach rgvar of varlist hh_16_* {
			label variable `rgvar' "3.31. Au cours des 12 derniers mois combien d'heures par semaine en moyenne \${h"
			note `rgvar': "3.31. Au cours des 12 derniers mois combien d'heures par semaine en moyenne \${hh_full_name_calc} a t-il consacré à la production d'engrais, son achat, ou son application sur le champ?"
		}
	}

	capture {
		foreach rgvar of varlist hh_17_* {
			label variable `rgvar' "3.32. Au cours des 12 derniers mois combien d'heures \${hh_full_name_calc} a t-i"
			note `rgvar': "3.32. Au cours des 12 derniers mois combien d'heures \${hh_full_name_calc} a t-il consacré à la production d'aliments pour le bétail par semaine en moyenne?"
		}
	}

	capture {
		foreach rgvar of varlist hh_18_* {
			label variable `rgvar' "3.33. Au cours des 7 derniers jours combien d'heures \${hh_full_name_calc} a-t-i"
			note `rgvar': "3.33. Au cours des 7 derniers jours combien d'heures \${hh_full_name_calc} a-t-il passé près de (< 1 m) ou dans une source d'eau de surface? (si 0, skip 3.34-3.40)"
		}
	}

	capture {
		foreach rgvar of varlist hh_19_* {
			label variable `rgvar' "3.34. Quelle(s) source(s) d'eau de surface? 1 = Lac, 2=étang, 3=rivière, 4=canal"
			note `rgvar': "3.34. Quelle(s) source(s) d'eau de surface? 1 = Lac, 2=étang, 3=rivière, 4=canal d'irrigation, 99= autre (à préciser)"
			label define `rgvar' 1 "1 . Lake" 2 "2 . Pond" 3 "3 . River" 4 "4 . Irrigation canal" 99 "99 . Other (specify)"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hh_19_o_* {
			label variable `rgvar' "Autre à préciser"
			note `rgvar': "Autre à préciser"
		}
	}

	capture {
		foreach rgvar of varlist hh_20_* {
			label variable `rgvar' "3.35. Au cours des 7 derniers jours, pourquoi \${hh_full_name_calc} a-t-il passé"
			note `rgvar': "3.35. Au cours des 7 derniers jours, pourquoi \${hh_full_name_calc} a-t-il passé du temps près de (< 1 m) ou dans la/les source(s) d'eau? (choix muliples) (1 = aller chercher de l'eau pour le ménage, 2= donner de l'eau au bétail, 3= aller chercher de l'eau pour l'agriculture, 4=laver des vêtements, 5=faire la vaisselle, 6 = récolter de la végétation aquatique, 7=nager/se baigner, 8=jouer, 99=autre(à préciser)"
		}
	}

	capture {
		foreach rgvar of varlist hh_20_a_* {
			label variable `rgvar' "Est-ce qu'il a d'autres raisons pour laquelle \${hh_full_name_calc} a-t-il passé"
			note `rgvar': "Est-ce qu'il a d'autres raisons pour laquelle \${hh_full_name_calc} a-t-il passé du temps près de (< 1 m) ou dans la/les source(s) d'eau?"
			label define `rgvar' 1 "Yes" 0 "No" 2 "Don't know/did not answer"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hh_20_o_* {
			label variable `rgvar' "Autre raison"
			note `rgvar': "Autre raison"
		}
	}

	capture {
		foreach rgvar of varlist hh_21_* {
			label variable `rgvar' "3.36. Au cours des 7 derniers jours combien d'heures \${hh_full_name_calc} a t-i"
			note `rgvar': "3.36. Au cours des 7 derniers jours combien d'heures \${hh_full_name_calc} a t-il consacré à \${hh_20-name} à près de (< 1 m) ou dans la/les source(s) d'eau?"
		}
	}

	capture {
		foreach rgvar of varlist hh_21_o_* {
			label variable `rgvar' "3.36.autre. Au cours des 7 derniers jours combien d'heures \${hh_full_name_calc}"
			note `rgvar': "3.36.autre. Au cours des 7 derniers jours combien d'heures \${hh_full_name_calc} a t-il consacré à \${hh_20_o} à près de (< 1 m) ou dans la/les source(s) d'eau?"
		}
	}

	capture {
		foreach rgvar of varlist hh_22_* {
			label variable `rgvar' "3.37. (skip cette question si l'option 6 à 3.35 n'a pas été sélectionnée.) Au co"
			note `rgvar': "3.37. (skip cette question si l'option 6 à 3.35 n'a pas été sélectionnée.) Au cours des 7 derniers jours, combien de végétation aquatique a-t-il/elle recolté près de (< 1 m) ou dans la/les source(s) d'eau? (1= kg Tipha, 2= kg autre)"
		}
	}

	capture {
		foreach rgvar of varlist hh_23_* {
			label variable `rgvar' "3.38. (skip cette question si l'option 6 à 3.35 n'a pas été sélectionnée.) Comme"
			note `rgvar': "3.38. (skip cette question si l'option 6 à 3.35 n'a pas été sélectionnée.) Comment a-t-il utilisé la végétation aquatique ? 1= Vendre, 2= Engrais, 3= Alimentation pour le betail, 4=Matière première pour le biodigesteur, 5= Rien, 99= Autre (à préciser)"
		}
	}

	capture {
		foreach rgvar of varlist hh_23_o_* {
			label variable `rgvar' "Autre à préciser"
			note `rgvar': "Autre à préciser"
		}
	}

	capture {
		foreach rgvar of varlist hh_24_* {
			label variable `rgvar' "3.39. Au cours des 7 derniers jours combien d'heures \${hh_full_name_calc} a t-i"
			note `rgvar': "3.39. Au cours des 7 derniers jours combien d'heures \${hh_full_name_calc} a t-il consacré à la production d'engrais, son achat, ou son application sur le champ?"
		}
	}

	capture {
		foreach rgvar of varlist hh_25_* {
			label variable `rgvar' "3.40. Au cours des 7 derniers jours combien d'heures \${hh_full_name_calc} a t-i"
			note `rgvar': "3.40. Au cours des 7 derniers jours combien d'heures \${hh_full_name_calc} a t-il consacré à la production d'aliments pour le bétail?"
		}
	}

	capture {
		foreach rgvar of varlist newmem_why_* {
			label variable `rgvar' "Pourquoi il/elle n’était pas enregistré(e) comme membre de votre ménage lors de "
			note `rgvar': "Pourquoi il/elle n’était pas enregistré(e) comme membre de votre ménage lors de la dernière collecte ?"
			label define `rgvar' 10 "C'est la personne ciblée elle même qui a changé de ménage" 1 "Est né(e) après la dernière collecte" 2 "N’habitait pas ici au moment de la dernière collecte" 3 "Etait en voyage ou en exode lors de la dernière collecte" 4 "Habitait ici, mais la liste est incomplète"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hh_39_* {
			label variable `rgvar' "Who is this child's mother or stepmother? Select from the roster or add addition"
			note `rgvar': "Who is this child's mother or stepmother? Select from the roster or add additional categories of (i) deceased or (ii) living but not residing in the household with the child"
			label define `rgvar' -6 "Vivant.e mais ne résidant pas dans le ménage avec l'enfant." -5 "[décédé.e]" -4 "[ne fait pas partie du ménage]" -2 "Personne" -1 "Tous les membres du ménage" 0 "Personnes hors du ménage" 1 "\${firstname_mem1}, Age : \${age_mem1}, pos 1" 2 "\${firstname_mem2}, Age : \${age_mem2}, pos 2" 3 "\${firstname_mem3}, Age : \${age_mem3}, pos 3" 4 "\${firstname_mem4}, Age : \${age_mem4}, pos 4" 5 "\${firstname_mem5}, Age : \${age_mem5}, pos 5" 6 "\${firstname_mem6}, Age : \${age_mem6}, pos 6" 7 "\${firstname_mem7}, Age : \${age_mem7}, pos 7" 8 "\${firstname_mem8}, Age : \${age_mem8}, pos 8" 9 "\${firstname_mem9}, Age : \${age_mem9}, pos 9" 10 "\${firstname_mem10}, Age : \${age_mem10}, pos 10" 11 "\${firstname_mem11}, Age : \${age_mem11}, pos 11" 12 "\${firstname_mem12}, Age : \${age_mem12}, pos 12" 13 "\${firstname_mem13}, Age : \${age_mem13}, pos 13" 14 "\${firstname_mem14}, Age : \${age_mem14}, pos 14" 15 "\${firstname_mem15}, Age : \${age_mem15}, pos 15" 16 "\${firstname_mem16}, Age : \${age_mem16}, pos 16" 17 "\${firstname_mem17}, Age : \${age_mem17}, pos 17" 18 "\${firstname_mem18}, Age : \${age_mem18}, pos 18" 19 "\${firstname_mem19}, Age : \${age_mem19}, pos 19" 20 "\${firstname_mem20}, Age : \${age_mem20}, pos 20" 21 "\${firstname_mem21}, Age : \${age_mem21}, pos 21" 22 "\${firstname_mem22}, Age : \${age_mem22}, pos 22" 23 "\${firstname_mem23}, Age : \${age_mem23}, pos 23" 24 "\${firstname_mem24}, Age : \${age_mem24}, pos 24" 25 "\${firstname_mem25}, Age : \${age_mem25}, pos 25" 26 "\${firstname_mem26}, Age : \${age_mem26}, pos 26" 27 "\${firstname_mem27}, Age : \${age_mem27}, pos 27" 28 "\${firstname_mem28}, Age : \${age_mem28}, pos 28" 29 "\${firstname_mem29}, Age : \${age_mem29}, pos 29" 30 "\${firstname_mem30}, Age : \${age_mem30}, pos 30" 31 "\${firstname_mem31}, Age : \${age_mem31}, pos 31" 32 "\${firstname_mem32}, Age : \${age_mem32}, pos 32" 33 "\${firstname_mem33}, Age : \${age_mem33}, pos 33" 34 "\${firstname_mem34}, Age : \${age_mem34}, pos 34" 35 "\${firstname_mem35}, Age : \${age_mem35}, pos 35" 36 "\${firstname_mem36}, Age : \${age_mem36}, pos 36" 37 "\${firstname_mem37}, Age : \${age_mem37}, pos 37" 38 "\${firstname_mem38}, Age : \${age_mem38}, pos 38" 39 "\${firstname_mem39}, Age : \${age_mem39}, pos 39" 40 "\${firstname_mem40}, Age : \${age_mem40}, pos 40" 41 "\${firstname_mem41}, Age : \${age_mem41}, pos 41" 42 "\${firstname_mem42}, Age : \${age_mem42}, pos 42" 43 "\${firstname_mem43}, Age : \${age_mem43}, pos 43" 44 "\${firstname_mem44}, Age : \${age_mem44}, pos 44" 45 "\${firstname_mem45}, Age : \${age_mem45}, pos 45" 46 "\${firstname_mem46}, Age : \${age_mem46}, pos 46" 47 "\${firstname_mem47}, Age : \${age_mem47}, pos 47" 48 "\${firstname_mem48}, Age : \${age_mem48}, pos 48" 49 "\${firstname_mem49}, Age : \${age_mem49}, pos 49" 50 "\${firstname_mem50}, Age : \${age_mem50}, pos 50" 51 "\${firstname_mem51}, Age : \${age_mem51}, pos 51" 52 "\${firstname_mem52}, Age : \${age_mem52}, pos 52" 53 "\${firstname_mem53}, Age : \${age_mem53}, pos 53" 54 "\${firstname_mem54}, Age : \${age_mem54}, pos 54" 55 "\${firstname_mem55}, Age : \${age_mem55}, pos 55" 56 "\${firstname_mem56}, Age : \${age_mem56}, pos 56" 57 "\${firstname_mem57}, Age : \${age_mem57}, pos 57" 58 "\${firstname_mem58}, Age : \${age_mem58}, pos 58" 59 "\${firstname_mem59}, Age : \${age_mem59}, pos 59" 60 "\${firstname_mem60}, Age : \${age_mem60}, pos 60"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hh_40_* {
			label variable `rgvar' "Who is this child's father or stepfather? Select from the roster or add addition"
			note `rgvar': "Who is this child's father or stepfather? Select from the roster or add additional categories of (i) deceased or (ii) living but not residing in the household with the child"
			label define `rgvar' -6 "Vivant.e mais ne résidant pas dans le ménage avec l'enfant." -5 "[décédé.e]" -4 "[ne fait pas partie du ménage]" -2 "Personne" -1 "Tous les membres du ménage" 0 "Personnes hors du ménage" 1 "\${firstname_mem1}, Age : \${age_mem1}, pos 1" 2 "\${firstname_mem2}, Age : \${age_mem2}, pos 2" 3 "\${firstname_mem3}, Age : \${age_mem3}, pos 3" 4 "\${firstname_mem4}, Age : \${age_mem4}, pos 4" 5 "\${firstname_mem5}, Age : \${age_mem5}, pos 5" 6 "\${firstname_mem6}, Age : \${age_mem6}, pos 6" 7 "\${firstname_mem7}, Age : \${age_mem7}, pos 7" 8 "\${firstname_mem8}, Age : \${age_mem8}, pos 8" 9 "\${firstname_mem9}, Age : \${age_mem9}, pos 9" 10 "\${firstname_mem10}, Age : \${age_mem10}, pos 10" 11 "\${firstname_mem11}, Age : \${age_mem11}, pos 11" 12 "\${firstname_mem12}, Age : \${age_mem12}, pos 12" 13 "\${firstname_mem13}, Age : \${age_mem13}, pos 13" 14 "\${firstname_mem14}, Age : \${age_mem14}, pos 14" 15 "\${firstname_mem15}, Age : \${age_mem15}, pos 15" 16 "\${firstname_mem16}, Age : \${age_mem16}, pos 16" 17 "\${firstname_mem17}, Age : \${age_mem17}, pos 17" 18 "\${firstname_mem18}, Age : \${age_mem18}, pos 18" 19 "\${firstname_mem19}, Age : \${age_mem19}, pos 19" 20 "\${firstname_mem20}, Age : \${age_mem20}, pos 20" 21 "\${firstname_mem21}, Age : \${age_mem21}, pos 21" 22 "\${firstname_mem22}, Age : \${age_mem22}, pos 22" 23 "\${firstname_mem23}, Age : \${age_mem23}, pos 23" 24 "\${firstname_mem24}, Age : \${age_mem24}, pos 24" 25 "\${firstname_mem25}, Age : \${age_mem25}, pos 25" 26 "\${firstname_mem26}, Age : \${age_mem26}, pos 26" 27 "\${firstname_mem27}, Age : \${age_mem27}, pos 27" 28 "\${firstname_mem28}, Age : \${age_mem28}, pos 28" 29 "\${firstname_mem29}, Age : \${age_mem29}, pos 29" 30 "\${firstname_mem30}, Age : \${age_mem30}, pos 30" 31 "\${firstname_mem31}, Age : \${age_mem31}, pos 31" 32 "\${firstname_mem32}, Age : \${age_mem32}, pos 32" 33 "\${firstname_mem33}, Age : \${age_mem33}, pos 33" 34 "\${firstname_mem34}, Age : \${age_mem34}, pos 34" 35 "\${firstname_mem35}, Age : \${age_mem35}, pos 35" 36 "\${firstname_mem36}, Age : \${age_mem36}, pos 36" 37 "\${firstname_mem37}, Age : \${age_mem37}, pos 37" 38 "\${firstname_mem38}, Age : \${age_mem38}, pos 38" 39 "\${firstname_mem39}, Age : \${age_mem39}, pos 39" 40 "\${firstname_mem40}, Age : \${age_mem40}, pos 40" 41 "\${firstname_mem41}, Age : \${age_mem41}, pos 41" 42 "\${firstname_mem42}, Age : \${age_mem42}, pos 42" 43 "\${firstname_mem43}, Age : \${age_mem43}, pos 43" 44 "\${firstname_mem44}, Age : \${age_mem44}, pos 44" 45 "\${firstname_mem45}, Age : \${age_mem45}, pos 45" 46 "\${firstname_mem46}, Age : \${age_mem46}, pos 46" 47 "\${firstname_mem47}, Age : \${age_mem47}, pos 47" 48 "\${firstname_mem48}, Age : \${age_mem48}, pos 48" 49 "\${firstname_mem49}, Age : \${age_mem49}, pos 49" 50 "\${firstname_mem50}, Age : \${age_mem50}, pos 50" 51 "\${firstname_mem51}, Age : \${age_mem51}, pos 51" 52 "\${firstname_mem52}, Age : \${age_mem52}, pos 52" 53 "\${firstname_mem53}, Age : \${age_mem53}, pos 53" 54 "\${firstname_mem54}, Age : \${age_mem54}, pos 54" 55 "\${firstname_mem55}, Age : \${age_mem55}, pos 55" 56 "\${firstname_mem56}, Age : \${age_mem56}, pos 56" 57 "\${firstname_mem57}, Age : \${age_mem57}, pos 57" 58 "\${firstname_mem58}, Age : \${age_mem58}, pos 58" 59 "\${firstname_mem59}, Age : \${age_mem59}, pos 59" 60 "\${firstname_mem60}, Age : \${age_mem60}, pos 60"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hh_26_* {
			label variable `rgvar' "3.41. \${hh_scoohl-name} a-t-il fait ou fait-il des études actuellement dans une"
			note `rgvar': "3.41. \${hh_scoohl-name} a-t-il fait ou fait-il des études actuellement dans une école formelle? 1=oui, 2=non [si non, skip à hh_27]"
			label define `rgvar' 1 "Yes" 0 "No" 2 "Don't know/did not answer"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hh_41_* {
			label variable `rgvar' "How old was [\${hh_scoohl-name}] when he/she started school?"
			note `rgvar': "How old was [\${hh_scoohl-name}] when he/she started school?"
		}
	}

	capture {
		foreach rgvar of varlist hh_32_* {
			label variable `rgvar' "3.47. Is \${hh_scoohl-name} attending school during the current school year 2024"
			note `rgvar': "3.47. Is \${hh_scoohl-name} attending school during the current school year 2024/2025?"
			label define `rgvar' 1 "Yes" 0 "No" 2 "Don't know/did not answer"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hh_29_* {
			label variable `rgvar' "3.44. What is the highest level and grade that \${hh_scoohl-name} achieved in sc"
			note `rgvar': "3.44. What is the highest level and grade that \${hh_scoohl-name} achieved in school ?"
			label define `rgvar' 1 "1.Primary – 1st year" 2 "2.Primary – 2nd year" 3 "3.Primary – 3rd year" 4 "4.Primary – 4th year" 5 "5.Primary – 5th year" 6 "6.Primary – 6th year" 7 "7. Secondary 1 (Middle) - 7th year" 8 "8. Secondary 1 (Middle) - 8th year" 9 "9. Secondary 1 (Middle) - 9th year" 10 "10. Secondary 1 (Middle) - 10th year" 11 "11. Secondary 2 (Higher) - 11th year" 12 "12. Secondary 2 (Higher) - 12th year" 13 "13. Secondary 2 (Higher) - 13th year" 14 "14. More than upper secondary (e.g. university)" 99 "99. Other (to be specified)"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hh_29_o_* {
			label variable `rgvar' "Other"
			note `rgvar': "Other"
		}
	}

	capture {
		foreach rgvar of varlist hh_34_* {
			label variable `rgvar' "3.49. How old was \${hh_scoohl-name} when they stopped going to school ?"
			note `rgvar': "3.49. How old was \${hh_scoohl-name} when they stopped going to school ?"
		}
	}

	capture {
		foreach rgvar of varlist hh_35_* {
			label variable `rgvar' "3.50. What is the level and class attended by \${hh_scoohl-name} during the year"
			note `rgvar': "3.50. What is the level and class attended by \${hh_scoohl-name} during the year 2024/2025?"
			label define `rgvar' 1 "1.Primary – 1st year" 2 "2.Primary – 2nd year" 3 "3.Primary – 3rd year" 4 "4.Primary – 4th year" 5 "5.Primary – 5th year" 6 "6.Primary – 6th year" 7 "7. Secondary 1 (Middle) - 7th year" 8 "8. Secondary 1 (Middle) - 8th year" 9 "9. Secondary 1 (Middle) - 9th year" 10 "10. Secondary 1 (Middle) - 10th year" 11 "11. Secondary 2 (Higher) - 11th year" 12 "12. Secondary 2 (Higher) - 12th year" 13 "13. Secondary 2 (Higher) - 13th year" 14 "14. More than upper secondary (e.g. university)" 99 "99. Other (to be specified)"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hh_50_* {
			label variable `rgvar' "Does this child currently attend a school located in this community?"
			note `rgvar': "Does this child currently attend a school located in this community?"
			label define `rgvar' 1 "Yes" 0 "No" 2 "Don't know/did not answer"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hh_51_* {
			label variable `rgvar' "How does the child commute to this school?"
			note `rgvar': "How does the child commute to this school?"
			label define `rgvar' 1 "1=walks" 2 "2=bike" 3 "3=moto" 4 "4=public transport" 5 "5= lives in other menage during the week"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hh_42_* {
			label variable `rgvar' "Is [\${hh_scoohl-name}] attending school today? 1 = Yes, 2 = No"
			note `rgvar': "Is [\${hh_scoohl-name}] attending school today? 1 = Yes, 2 = No"
			label define `rgvar' 1 "Yes" 0 "No" 2 "Don't know/did not answer"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hh_43_* {
			label variable `rgvar' "When is [\${hh_scoohl-name}] attending school today? 1 = Morning, 2 = Afternoon,"
			note `rgvar': "When is [\${hh_scoohl-name}] attending school today? 1 = Morning, 2 = Afternoon, 3 = Both morning and afternoon"
			label define `rgvar' 1 "1 = Morning" 2 "2 = Afternoon" 3 "3 = Both morning and afternoon"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hh_44_* {
			label variable `rgvar' "Is the child home? 1 = Yes, 2 = No"
			note `rgvar': "Is the child home? 1 = Yes, 2 = No"
			label define `rgvar' 1 "Yes" 0 "No" 2 "Don't know/did not answer"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hh_45_* {
			label variable `rgvar' "Enumerator: Do you yourself observe the child at home? 1 = Yes, 2 = No"
			note `rgvar': "Enumerator: Do you yourself observe the child at home? 1 = Yes, 2 = No"
			label define `rgvar' 1 "Yes" 0 "No" 2 "Don't know/did not answer"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hh_46_* {
			label variable `rgvar' "What is the primary reason that the child is not attending school today? (In ran"
			note `rgvar': "What is the primary reason that the child is not attending school today? (In random order) 1 = Poor Health, 2 = Household chores (not agriculture) 3 = Skipping school, 4 = Inaccessible due to distance or weather, 5 = agricultural work, 6 = non-agricultural work, 7 = other (specify)"
			label define `rgvar' 1 "1 = Poor Health" 2 "2 = Household chores (not agriculture)" 3 "3 = Skipping school" 5 "5 = agricultural work" 6 "6 = non-agricultural work" 7 "7 = other (specify)"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hh_36_* {
			label variable `rgvar' "3.51. Do you think that \${hh_scoohl-name} will succeed at their declared academ"
			note `rgvar': "3.51. Do you think that \${hh_scoohl-name} will succeed at their declared academic level in 2024/2025 ?"
			label define `rgvar' 1 "Yes" 0 "No" 2 "Don't know/did not answer"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hh_30_* {
			label variable `rgvar' "3.45. Did \${hh_scoohl-name} attend any school during the past school year 2024-"
			note `rgvar': "3.45. Did \${hh_scoohl-name} attend any school during the past school year 2024-24?"
			label define `rgvar' 1 "Yes" 0 "No" 2 "Don't know/did not answer"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hh_31_* {
			label variable `rgvar' "3.46. What result did \${hh_scoohl-name} achieve during the 2024/2024 school yea"
			note `rgvar': "3.46. What result did \${hh_scoohl-name} achieve during the 2024/2024 school year ?"
			label define `rgvar' 1 "1. Graduate, studies completed" 2 "2. Moving to the next class" 3 "3. Failure, repetition" 4 "4. Failure, dismissal" 5 "5. Dropout during the year"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hh_37_* {
			label variable `rgvar' "3.52. During the last 12 months, has \${hh_scoohl-name} ever missed more than on"
			note `rgvar': "3.52. During the last 12 months, has \${hh_scoohl-name} ever missed more than one consecutive week of school due to illness ?"
			label define `rgvar' 1 "Yes" 0 "No" 2 "Don't know/did not answer"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hh_38_* {
			label variable `rgvar' "3.53. During the last seven days, how many days did \${hh_scoohl-name} go to sch"
			note `rgvar': "3.53. During the last seven days, how many days did \${hh_scoohl-name} go to school for classes ?"
		}
	}

	capture {
		foreach rgvar of varlist hh_27_* {
			label variable `rgvar' "3.42. Did \${hh_scoohl-name} attend non-formal school or non-formal training ? 1"
			note `rgvar': "3.42. Did \${hh_scoohl-name} attend non-formal school or non-formal training ? 1=yes, 2=no"
			label define `rgvar' 1 "Yes" 0 "No" 2 "Don't know/did not answer"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hh_28_* {
			label variable `rgvar' "3.43. What type of non-formal education did \${hh_scoohl-name} attend ?"
			note `rgvar': "3.43. What type of non-formal education did \${hh_scoohl-name} attend ?"
			label define `rgvar' 1 "1. Koranic school" 2 "2. Professionnal training" 3 "3. Literacy lessons" 99 "99. Others (language courses, etc.)"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hh_47_a_* {
			label variable `rgvar' "How much was spent on [\${hh_scoohl-name}]'s education in the last 12 months by "
			note `rgvar': "How much was spent on [\${hh_scoohl-name}]'s education in the last 12 months by the household, family and friends: a. Registration and tuition fees"
		}
	}

	capture {
		foreach rgvar of varlist hh_47_b_* {
			label variable `rgvar' "How much was spent on [\${hh_scoohl-name}]'s education in the last 12 months by "
			note `rgvar': "How much was spent on [\${hh_scoohl-name}]'s education in the last 12 months by the household, family and friends: b. supplies"
		}
	}

	capture {
		foreach rgvar of varlist hh_47_c_* {
			label variable `rgvar' "How much was spent on [\${hh_scoohl-name}]'s education in the last 12 months by "
			note `rgvar': "How much was spent on [\${hh_scoohl-name}]'s education in the last 12 months by the household, family and friends: c. uniforms"
		}
	}

	capture {
		foreach rgvar of varlist hh_47_d_* {
			label variable `rgvar' "How much was spent on [\${hh_scoohl-name}]'s education in the last 12 months by "
			note `rgvar': "How much was spent on [\${hh_scoohl-name}]'s education in the last 12 months by the household, family and friends:d. school meals"
		}
	}

	capture {
		foreach rgvar of varlist hh_47_e_* {
			label variable `rgvar' "How much was spent on [\${hh_scoohl-name}]'s education in the last 12 months by "
			note `rgvar': "How much was spent on [\${hh_scoohl-name}]'s education in the last 12 months by the household, family and friends: e. school transport"
		}
	}

	capture {
		foreach rgvar of varlist hh_47_f_* {
			label variable `rgvar' "How much was spent on [\${hh_scoohl-name}]'s education in the last 12 months by "
			note `rgvar': "How much was spent on [\${hh_scoohl-name}]'s education in the last 12 months by the household, family and friends: f. tutoring or rehersal classes"
		}
	}

	capture {
		foreach rgvar of varlist hh_47_g_* {
			label variable `rgvar' "How much was spent on [\${hh_scoohl-name}]'s education in the last 12 months by "
			note `rgvar': "How much was spent on [\${hh_scoohl-name}]'s education in the last 12 months by the household, family and friends: g. other (specify)"
		}
	}

	capture {
		foreach rgvar of varlist hh_47_oth_* {
			label variable `rgvar' "Other to precise"
			note `rgvar': "Other to precise"
		}
	}

	capture {
		foreach rgvar of varlist hh_48_* {
			label variable `rgvar' "Was [\${hh_scoohl-name}] tested for schistosomiasis at school?"
			note `rgvar': "Was [\${hh_scoohl-name}] tested for schistosomiasis at school?"
			label define `rgvar' 1 "Yes" 0 "No" 2 "Don't know/did not answer"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist health_5_2_* {
			label variable `rgvar' "5.2. Has \${health-name} fallen ill in the last 12 months? (Skip 5.4 if no)"
			note `rgvar': "5.2. Has \${health-name} fallen ill in the last 12 months? (Skip 5.4 if no)"
			label define `rgvar' 1 "Yes" 0 "No" 2 "Don't know/did not answer"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist health_5_3_* {
			label variable `rgvar' "5.3. What kind of illness or injury did he/she suffer from?"
			note `rgvar': "5.3. What kind of illness or injury did he/she suffer from?"
		}
	}

	capture {
		foreach rgvar of varlist health_5_3_o_* {
			label variable `rgvar' "Other illness"
			note `rgvar': "Other illness"
		}
	}

	capture {
		foreach rgvar of varlist health_5_4_* {
			label variable `rgvar' "5.4. How many days did he/she miss work/school due to illness or injury in the l"
			note `rgvar': "5.4. How many days did he/she miss work/school due to illness or injury in the last month?"
		}
	}

	capture {
		foreach rgvar of varlist health_5_5_* {
			label variable `rgvar' "5.5. Did he/she receive medication for schistosomiasis treatment in the last 12 "
			note `rgvar': "5.5. Did he/she receive medication for schistosomiasis treatment in the last 12 months?"
			label define `rgvar' 1 "Yes" 0 "No" 2 "Don't know/did not answer"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist health_5_6_* {
			label variable `rgvar' "5.6. Has this person ever been diagnosed with schistosomiasis?"
			note `rgvar': "5.6. Has this person ever been diagnosed with schistosomiasis?"
			label define `rgvar' 1 "Yes" 0 "No" 2 "Don't know/did not answer"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist health_5_7_* {
			label variable `rgvar' "5.7. Has this person been affected by schistosomiasis in the last 12 months?"
			note `rgvar': "5.7. Has this person been affected by schistosomiasis in the last 12 months?"
			label define `rgvar' 1 "Yes" 0 "No" 2 "Don't know/did not answer"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist health_5_8_* {
			label variable `rgvar' "5.8. Has this person had blood in their urine in the last 12 months?"
			note `rgvar': "5.8. Has this person had blood in their urine in the last 12 months?"
			label define `rgvar' 1 "Yes" 0 "No" 2 "Don't know/did not answer"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist health_5_9_* {
			label variable `rgvar' "5.9. Has this person had blood in their stool in the last 12 months?"
			note `rgvar': "5.9. Has this person had blood in their stool in the last 12 months?"
			label define `rgvar' 1 "Yes" 0 "No" 2 "Don't know/did not answer"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist health_5_10_* {
			label variable `rgvar' "5.10. Did you consult someone for an illness in the last 12 months?"
			note `rgvar': "5.10. Did you consult someone for an illness in the last 12 months?"
			label define `rgvar' 1 "Yes" 0 "No" 2 "Don't know/did not answer"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist health_5_11_* {
			label variable `rgvar' "5.11. What kind of health service/healthcare professional did he/she consult fir"
			note `rgvar': "5.11. What kind of health service/healthcare professional did he/she consult first?"
			label define `rgvar' 1 "01. Health hut/post" 2 "02. Traditional healer/marabout" 3 "03. Doctor/Private clinic" 4 "04. Pharmacy/pharmacist" 5 "05. Midwife/Nurse" 6 "06. Public Hospital" 7 "07. Health center" 8 "08. Private clinic/Dispensary hospital" 9 "09. Company doctor" 99 "99.other (to be specified)"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist health_5_11_o_* {
			label variable `rgvar' "5.11_o Other health service"
			note `rgvar': "5.11_o Other health service"
		}
	}

	capture {
		foreach rgvar of varlist health_5_12_* {
			label variable `rgvar' "5.12. What is the distance in km to this service or healthcare professional?"
			note `rgvar': "5.12. What is the distance in km to this service or healthcare professional?"
		}
	}

	capture {
		foreach rgvar of varlist _actif_number_* {
			label variable `rgvar' "6.2. How many of \${actifs-name} did you have?"
			note `rgvar': "6.2. How many of \${actifs-name} did you have?"
		}
	}

	capture {
		foreach rgvar of varlist _agri_number_* {
			label variable `rgvar' "How many of \${agri-name} did you have?"
			note `rgvar': "How many of \${agri-name} did you have?"
		}
	}

	capture {
		foreach rgvar of varlist agri_6_16_* {
			label variable `rgvar' "Number order of the field"
			note `rgvar': "Number order of the field"
		}
	}

	capture {
		foreach rgvar of varlist agri_6_17_* {
			label variable `rgvar' "Parcel Number in the Field"
			note `rgvar': "Parcel Number in the Field"
		}
	}

	capture {
		foreach rgvar of varlist agri_6_18_* {
			label variable `rgvar' "What is the management mode of the parcel?"
			note `rgvar': "What is the management mode of the parcel?"
			label define `rgvar' 1 "1=Individual" 2 "2=Collective"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist agri_6_19_* {
			label variable `rgvar' "What is the order number of the person who cultivates the parcel? (Use IDs from "
			note `rgvar': "What is the order number of the person who cultivates the parcel? (Use IDs from Section B on Household Demographic Characteristics)"
			label define `rgvar' -6 "Vivant.e mais ne résidant pas dans le ménage avec l'enfant." -5 "[décédé.e]" -4 "[ne fait pas partie du ménage]" -2 "Personne" -1 "Tous les membres du ménage" 0 "Personnes hors du ménage" 1 "\${firstname_mem1}, Age : \${age_mem1}, pos 1" 2 "\${firstname_mem2}, Age : \${age_mem2}, pos 2" 3 "\${firstname_mem3}, Age : \${age_mem3}, pos 3" 4 "\${firstname_mem4}, Age : \${age_mem4}, pos 4" 5 "\${firstname_mem5}, Age : \${age_mem5}, pos 5" 6 "\${firstname_mem6}, Age : \${age_mem6}, pos 6" 7 "\${firstname_mem7}, Age : \${age_mem7}, pos 7" 8 "\${firstname_mem8}, Age : \${age_mem8}, pos 8" 9 "\${firstname_mem9}, Age : \${age_mem9}, pos 9" 10 "\${firstname_mem10}, Age : \${age_mem10}, pos 10" 11 "\${firstname_mem11}, Age : \${age_mem11}, pos 11" 12 "\${firstname_mem12}, Age : \${age_mem12}, pos 12" 13 "\${firstname_mem13}, Age : \${age_mem13}, pos 13" 14 "\${firstname_mem14}, Age : \${age_mem14}, pos 14" 15 "\${firstname_mem15}, Age : \${age_mem15}, pos 15" 16 "\${firstname_mem16}, Age : \${age_mem16}, pos 16" 17 "\${firstname_mem17}, Age : \${age_mem17}, pos 17" 18 "\${firstname_mem18}, Age : \${age_mem18}, pos 18" 19 "\${firstname_mem19}, Age : \${age_mem19}, pos 19" 20 "\${firstname_mem20}, Age : \${age_mem20}, pos 20" 21 "\${firstname_mem21}, Age : \${age_mem21}, pos 21" 22 "\${firstname_mem22}, Age : \${age_mem22}, pos 22" 23 "\${firstname_mem23}, Age : \${age_mem23}, pos 23" 24 "\${firstname_mem24}, Age : \${age_mem24}, pos 24" 25 "\${firstname_mem25}, Age : \${age_mem25}, pos 25" 26 "\${firstname_mem26}, Age : \${age_mem26}, pos 26" 27 "\${firstname_mem27}, Age : \${age_mem27}, pos 27" 28 "\${firstname_mem28}, Age : \${age_mem28}, pos 28" 29 "\${firstname_mem29}, Age : \${age_mem29}, pos 29" 30 "\${firstname_mem30}, Age : \${age_mem30}, pos 30" 31 "\${firstname_mem31}, Age : \${age_mem31}, pos 31" 32 "\${firstname_mem32}, Age : \${age_mem32}, pos 32" 33 "\${firstname_mem33}, Age : \${age_mem33}, pos 33" 34 "\${firstname_mem34}, Age : \${age_mem34}, pos 34" 35 "\${firstname_mem35}, Age : \${age_mem35}, pos 35" 36 "\${firstname_mem36}, Age : \${age_mem36}, pos 36" 37 "\${firstname_mem37}, Age : \${age_mem37}, pos 37" 38 "\${firstname_mem38}, Age : \${age_mem38}, pos 38" 39 "\${firstname_mem39}, Age : \${age_mem39}, pos 39" 40 "\${firstname_mem40}, Age : \${age_mem40}, pos 40" 41 "\${firstname_mem41}, Age : \${age_mem41}, pos 41" 42 "\${firstname_mem42}, Age : \${age_mem42}, pos 42" 43 "\${firstname_mem43}, Age : \${age_mem43}, pos 43" 44 "\${firstname_mem44}, Age : \${age_mem44}, pos 44" 45 "\${firstname_mem45}, Age : \${age_mem45}, pos 45" 46 "\${firstname_mem46}, Age : \${age_mem46}, pos 46" 47 "\${firstname_mem47}, Age : \${age_mem47}, pos 47" 48 "\${firstname_mem48}, Age : \${age_mem48}, pos 48" 49 "\${firstname_mem49}, Age : \${age_mem49}, pos 49" 50 "\${firstname_mem50}, Age : \${age_mem50}, pos 50" 51 "\${firstname_mem51}, Age : \${age_mem51}, pos 51" 52 "\${firstname_mem52}, Age : \${age_mem52}, pos 52" 53 "\${firstname_mem53}, Age : \${age_mem53}, pos 53" 54 "\${firstname_mem54}, Age : \${age_mem54}, pos 54" 55 "\${firstname_mem55}, Age : \${age_mem55}, pos 55" 56 "\${firstname_mem56}, Age : \${age_mem56}, pos 56" 57 "\${firstname_mem57}, Age : \${age_mem57}, pos 57" 58 "\${firstname_mem58}, Age : \${age_mem58}, pos 58" 59 "\${firstname_mem59}, Age : \${age_mem59}, pos 59" 60 "\${firstname_mem60}, Age : \${age_mem60}, pos 60"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist agri_6_20_* {
			label variable `rgvar' "What is the main crop grown on this parcel during the last growing season?"
			note `rgvar': "What is the main crop grown on this parcel during the last growing season?"
			label define `rgvar' 1 "RIZ" 2 "MAIS" 3 "MIL" 4 "SORGHO" 5 "NIEBE" 6 "MANIOC" 7 "PATATE DOUCES" 8 "POMME DE TERRE" 9 "IGNAME" 10 "TARO" 11 "TOMATES" 12 "CARROTTES" 13 "OIGNONS" 14 "CONCOMBRES" 15 "POIVRONS" 16 "ARACHIDES" 17 "HARICOTS" 18 "POIS" 99 "AUTRES (PRECISEZ)"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist agri_6_20_o_* {
			label variable `rgvar' "Other crop grown"
			note `rgvar': "Other crop grown"
		}
	}

	capture {
		foreach rgvar of varlist agri_6_21_* {
			label variable `rgvar' "What is the area of the parcel according to the operator? (Provide the area in h"
			note `rgvar': "What is the area of the parcel according to the operator? (Provide the area in hectares or square meters with two decimal places)"
		}
	}

	capture {
		foreach rgvar of varlist agri_6_22_* {
			label variable `rgvar' "Unit"
			note `rgvar': "Unit"
			label define `rgvar' 1 "Hectare (Ha)" 2 "Square Meter (m^2)"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist agri_6_23_* {
			label variable `rgvar' "What is the land tenure mode of this parcel?"
			note `rgvar': "What is the land tenure mode of this parcel?"
			label define `rgvar' 1 "1=Owner" 2 "2=Free loan" 3 "3=Leasing" 4 "4=Sharecropping" 5 "5=Pledge" 99 "99=Other"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist agri_6_23_o_* {
			label variable `rgvar' "Other mode of land tenure"
			note `rgvar': "Other mode of land tenure"
		}
	}

	capture {
		foreach rgvar of varlist agri_6_24_* {
			label variable `rgvar' "What is the order number of the owner of the parcel?"
			note `rgvar': "What is the order number of the owner of the parcel?"
			label define `rgvar' -6 "Vivant.e mais ne résidant pas dans le ménage avec l'enfant." -5 "[décédé.e]" -4 "[ne fait pas partie du ménage]" -2 "Personne" -1 "Tous les membres du ménage" 0 "Personnes hors du ménage" 1 "\${firstname_mem1}, Age : \${age_mem1}, pos 1" 2 "\${firstname_mem2}, Age : \${age_mem2}, pos 2" 3 "\${firstname_mem3}, Age : \${age_mem3}, pos 3" 4 "\${firstname_mem4}, Age : \${age_mem4}, pos 4" 5 "\${firstname_mem5}, Age : \${age_mem5}, pos 5" 6 "\${firstname_mem6}, Age : \${age_mem6}, pos 6" 7 "\${firstname_mem7}, Age : \${age_mem7}, pos 7" 8 "\${firstname_mem8}, Age : \${age_mem8}, pos 8" 9 "\${firstname_mem9}, Age : \${age_mem9}, pos 9" 10 "\${firstname_mem10}, Age : \${age_mem10}, pos 10" 11 "\${firstname_mem11}, Age : \${age_mem11}, pos 11" 12 "\${firstname_mem12}, Age : \${age_mem12}, pos 12" 13 "\${firstname_mem13}, Age : \${age_mem13}, pos 13" 14 "\${firstname_mem14}, Age : \${age_mem14}, pos 14" 15 "\${firstname_mem15}, Age : \${age_mem15}, pos 15" 16 "\${firstname_mem16}, Age : \${age_mem16}, pos 16" 17 "\${firstname_mem17}, Age : \${age_mem17}, pos 17" 18 "\${firstname_mem18}, Age : \${age_mem18}, pos 18" 19 "\${firstname_mem19}, Age : \${age_mem19}, pos 19" 20 "\${firstname_mem20}, Age : \${age_mem20}, pos 20" 21 "\${firstname_mem21}, Age : \${age_mem21}, pos 21" 22 "\${firstname_mem22}, Age : \${age_mem22}, pos 22" 23 "\${firstname_mem23}, Age : \${age_mem23}, pos 23" 24 "\${firstname_mem24}, Age : \${age_mem24}, pos 24" 25 "\${firstname_mem25}, Age : \${age_mem25}, pos 25" 26 "\${firstname_mem26}, Age : \${age_mem26}, pos 26" 27 "\${firstname_mem27}, Age : \${age_mem27}, pos 27" 28 "\${firstname_mem28}, Age : \${age_mem28}, pos 28" 29 "\${firstname_mem29}, Age : \${age_mem29}, pos 29" 30 "\${firstname_mem30}, Age : \${age_mem30}, pos 30" 31 "\${firstname_mem31}, Age : \${age_mem31}, pos 31" 32 "\${firstname_mem32}, Age : \${age_mem32}, pos 32" 33 "\${firstname_mem33}, Age : \${age_mem33}, pos 33" 34 "\${firstname_mem34}, Age : \${age_mem34}, pos 34" 35 "\${firstname_mem35}, Age : \${age_mem35}, pos 35" 36 "\${firstname_mem36}, Age : \${age_mem36}, pos 36" 37 "\${firstname_mem37}, Age : \${age_mem37}, pos 37" 38 "\${firstname_mem38}, Age : \${age_mem38}, pos 38" 39 "\${firstname_mem39}, Age : \${age_mem39}, pos 39" 40 "\${firstname_mem40}, Age : \${age_mem40}, pos 40" 41 "\${firstname_mem41}, Age : \${age_mem41}, pos 41" 42 "\${firstname_mem42}, Age : \${age_mem42}, pos 42" 43 "\${firstname_mem43}, Age : \${age_mem43}, pos 43" 44 "\${firstname_mem44}, Age : \${age_mem44}, pos 44" 45 "\${firstname_mem45}, Age : \${age_mem45}, pos 45" 46 "\${firstname_mem46}, Age : \${age_mem46}, pos 46" 47 "\${firstname_mem47}, Age : \${age_mem47}, pos 47" 48 "\${firstname_mem48}, Age : \${age_mem48}, pos 48" 49 "\${firstname_mem49}, Age : \${age_mem49}, pos 49" 50 "\${firstname_mem50}, Age : \${age_mem50}, pos 50" 51 "\${firstname_mem51}, Age : \${age_mem51}, pos 51" 52 "\${firstname_mem52}, Age : \${age_mem52}, pos 52" 53 "\${firstname_mem53}, Age : \${age_mem53}, pos 53" 54 "\${firstname_mem54}, Age : \${age_mem54}, pos 54" 55 "\${firstname_mem55}, Age : \${age_mem55}, pos 55" 56 "\${firstname_mem56}, Age : \${age_mem56}, pos 56" 57 "\${firstname_mem57}, Age : \${age_mem57}, pos 57" 58 "\${firstname_mem58}, Age : \${age_mem58}, pos 58" 59 "\${firstname_mem59}, Age : \${age_mem59}, pos 59" 60 "\${firstname_mem60}, Age : \${age_mem60}, pos 60"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist agri_6_25_* {
			label variable `rgvar' "What is the acquisition mode of this parcel?"
			note `rgvar': "What is the acquisition mode of this parcel?"
			label define `rgvar' 1 "1=Purchase" 2 "2=Inheritance" 3 "3=Marriage" 4 "4=Gift" 99 "99=Other (specify)"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist agri_6_25_o_* {
			label variable `rgvar' "Other mode of acquisition of this parcel"
			note `rgvar': "Other mode of acquisition of this parcel"
		}
	}

	capture {
		foreach rgvar of varlist agri_6_26_* {
			label variable `rgvar' "Do you have a legal document (title, deed, certificate, etc.) confirming your ow"
			note `rgvar': "Do you have a legal document (title, deed, certificate, etc.) confirming your ownership of this parcel?"
			label define `rgvar' 1 "1=Land title" 2 "2=Exploitation permit" 3 "3=Official report" 4 "4=Lease" 5 "5=Sales agreement" 99 "99=Other" 6 "6=None (if 'none,' skip the next question)"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist agri_6_26_o_* {
			label variable `rgvar' "Other legal document"
			note `rgvar': "Other legal document"
		}
	}

	capture {
		foreach rgvar of varlist agri_6_27_* {
			label variable `rgvar' "Which household members are listed on this legal document?"
			note `rgvar': "Which household members are listed on this legal document?"
		}
	}

	capture {
		foreach rgvar of varlist agri_6_28_* {
			label variable `rgvar' "Do you think there is a risk of losing the rights associated with this parcel in"
			note `rgvar': "Do you think there is a risk of losing the rights associated with this parcel in the next 5 years?"
			label define `rgvar' 1 "Yes" 0 "No" 2 "Don't know/did not answer"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist agri_6_29_* {
			label variable `rgvar' "What is the main concern?"
			note `rgvar': "What is the main concern?"
			label define `rgvar' 1 "1=Land boundary dispute" 2 "2=Ownership: related to inheritance" 3 "3=Property: sale-related" 4 "4=Property: expropriation" 99 "99=Other (please specify)"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist agri_6_29_o_* {
			label variable `rgvar' "Other type of concern"
			note `rgvar': "Other type of concern"
		}
	}

	capture {
		foreach rgvar of varlist agri_6_30_* {
			label variable `rgvar' "Did you use animal manure on this parcel during this farming season?"
			note `rgvar': "Did you use animal manure on this parcel during this farming season?"
			label define `rgvar' 1 "Yes" 0 "No" 2 "Don't know/did not answer"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist agri_6_31_* {
			label variable `rgvar' "What was the main method of acquiring this animal manure?"
			note `rgvar': "What was the main method of acquiring this animal manure?"
			label define `rgvar' 1 "1=Direct penning" 2 "2=Indirect penning" 3 "3=Purchase" 99 "99=Other (specify)"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist agri_6_31_o_* {
			label variable `rgvar' "Other method for the animal acquisition"
			note `rgvar': "Other method for the animal acquisition"
		}
	}

	capture {
		foreach rgvar of varlist agri_6_32_* {
			label variable `rgvar' "What quantity of organic fertilizer have you applied to the parcel?"
			note `rgvar': "What quantity of organic fertilizer have you applied to the parcel?"
		}
	}

	capture {
		foreach rgvar of varlist agri_6_33_* {
			label variable `rgvar' "Unite code"
			note `rgvar': "Unite code"
			label define `rgvar' 1 "1=Kg" 2 "2=Large sack" 3 "3=Medium sack" 4 "4=Small sack" 5 "5=Donkey cart" 6 "6=Cow cart" 7 "7=Bucket" 8 "8=Basket" 99 "99=Other (specify)"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist agri_6_33_o_* {
			label variable `rgvar' "Other quantity code"
			note `rgvar': "Other quantity code"
		}
	}

	capture {
		foreach rgvar of varlist agri_6_34_comp_* {
			label variable `rgvar' "Avez-vous utilisé du compost sur cette parcelle durant cette campagne?"
			note `rgvar': "Avez-vous utilisé du compost sur cette parcelle durant cette campagne?"
			label define `rgvar' 1 "Yes" 0 "No" 2 "Don't know/did not answer"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist agri_6_34_* {
			label variable `rgvar' "Did you use household and other waste on this parcel during this farming season?"
			note `rgvar': "Did you use household and other waste on this parcel during this farming season?"
			label define `rgvar' 1 "Yes" 0 "No" 2 "Don't know/did not answer"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist agri_6_35_* {
			label variable `rgvar' "How many times have you applied household waste to this parcel during this farmi"
			note `rgvar': "How many times have you applied household waste to this parcel during this farming season?"
		}
	}

	capture {
		foreach rgvar of varlist agri_6_36_* {
			label variable `rgvar' "Did you use inorganic/chemical fertilizer on this parcel during this farming sea"
			note `rgvar': "Did you use inorganic/chemical fertilizer on this parcel during this farming season?"
			label define `rgvar' 1 "Yes" 0 "No" 2 "Don't know/did not answer"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist agri_6_37_* {
			label variable `rgvar' "How many times have you applied inorganic fertilizers to this parcel during this"
			note `rgvar': "How many times have you applied inorganic fertilizers to this parcel during this farming season?"
		}
	}

	capture {
		foreach rgvar of varlist agri_6_38_a_* {
			label variable `rgvar' "Quelle quantité d’Urée avez-vous utilisée ? Mettre zéro si l’urée n’est pas util"
			note `rgvar': "Quelle quantité d’Urée avez-vous utilisée ? Mettre zéro si l’urée n’est pas utilisée"
		}
	}

	capture {
		foreach rgvar of varlist agri_6_38_a_code_* {
			label variable `rgvar' "Unité"
			note `rgvar': "Unité"
			label define `rgvar' 1 "1=Kilogramme" 2 "2=Tonne" 3 "3=Sac" 99 "99=Autre"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist agri_6_38_a_code_o_* {
			label variable `rgvar' "Autre code"
			note `rgvar': "Autre code"
		}
	}

	capture {
		foreach rgvar of varlist agri_6_39_a_* {
			label variable `rgvar' "Quelle quantité de Phosphates avez-vous utilisée ? Mettre zéro si le Phosphate n"
			note `rgvar': "Quelle quantité de Phosphates avez-vous utilisée ? Mettre zéro si le Phosphate n’est pas utilis"
		}
	}

	capture {
		foreach rgvar of varlist agri_6_39_a_code_* {
			label variable `rgvar' "Unité"
			note `rgvar': "Unité"
			label define `rgvar' 1 "1=Kilogramme" 2 "2=Tonne" 3 "3=Sac" 99 "99=Autre"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist agri_6_39_a_code_o_* {
			label variable `rgvar' "Autre code"
			note `rgvar': "Autre code"
		}
	}

	capture {
		foreach rgvar of varlist agri_6_40_a_* {
			label variable `rgvar' "Quelle quantité de NPK/Formule unique avez-vous utilisée? Mettre zéro si le NPK "
			note `rgvar': "Quelle quantité de NPK/Formule unique avez-vous utilisée? Mettre zéro si le NPK n’est pas utilisé"
		}
	}

	capture {
		foreach rgvar of varlist agri_6_40_a_code_* {
			label variable `rgvar' "Unité"
			note `rgvar': "Unité"
			label define `rgvar' 1 "1=Kilogramme" 2 "2=Tonne" 3 "3=Sac" 99 "99=Autre"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist agri_6_40_a_code_o_* {
			label variable `rgvar' "Autre code"
			note `rgvar': "Autre code"
		}
	}

	capture {
		foreach rgvar of varlist agri_6_41_a_* {
			label variable `rgvar' "Quelle quantité d’autres engrais chimiques avez-vous utilisée ? Mettre zéro si l"
			note `rgvar': "Quelle quantité d’autres engrais chimiques avez-vous utilisée ? Mettre zéro si l'autre n’est pas utilisé"
		}
	}

	capture {
		foreach rgvar of varlist agri_6_41_a_code_* {
			label variable `rgvar' "Unité"
			note `rgvar': "Unité"
			label define `rgvar' 1 "1=Kilogramme" 2 "2=Tonne" 3 "3=Sac" 99 "99=Autre"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist agri_6_41_a_code_o_* {
			label variable `rgvar' "Autre code"
			note `rgvar': "Autre code"
		}
	}

	capture {
		foreach rgvar of varlist cereals_consumption_* {
			label variable `rgvar' "Did your household consume \${cereals-name} during this period?"
			note `rgvar': "Did your household consume \${cereals-name} during this period?"
			label define `rgvar' 1 "Yes" 0 "No" 2 "Don't know/did not answer"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist cereals_01_* {
			label variable `rgvar' "11.2 Area in hectare of \${cereals-name}"
			note `rgvar': "11.2 Area in hectare of \${cereals-name}"
		}
	}

	capture {
		foreach rgvar of varlist cereals_02_* {
			label variable `rgvar' "11.3 Total production in 2024 (kg) of \${cereals-name}"
			note `rgvar': "11.3 Total production in 2024 (kg) of \${cereals-name}"
		}
	}

	capture {
		foreach rgvar of varlist cereals_03_* {
			label variable `rgvar' "11.4 Quantity self-consumed in 2024 of \${cereals-name}"
			note `rgvar': "11.4 Quantity self-consumed in 2024 of \${cereals-name}"
		}
	}

	capture {
		foreach rgvar of varlist cereals_04_* {
			label variable `rgvar' "11.5 Quantity sold in kg in 2024 of \${cereals-name}"
			note `rgvar': "11.5 Quantity sold in kg in 2024 of \${cereals-name}"
		}
	}

	capture {
		foreach rgvar of varlist cereals_05_* {
			label variable `rgvar' "11.6 Current sale price in FCFA/kg of \${cereals-name}"
			note `rgvar': "11.6 Current sale price in FCFA/kg of \${cereals-name}"
		}
	}

	capture {
		foreach rgvar of varlist farine_tubercules_consumption_* {
			label variable `rgvar' "Did your household consume \${farine_tubercules-name} during this period?"
			note `rgvar': "Did your household consume \${farine_tubercules-name} during this period?"
			label define `rgvar' 1 "Yes" 0 "No" 2 "Don't know/did not answer"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist farines_01_* {
			label variable `rgvar' "11.2 Area in hectare of \${farine_tubercules-name}"
			note `rgvar': "11.2 Area in hectare of \${farine_tubercules-name}"
		}
	}

	capture {
		foreach rgvar of varlist farines_02_* {
			label variable `rgvar' "11.3 Total production in 2024 (kg) of \${farine_tubercules-name}"
			note `rgvar': "11.3 Total production in 2024 (kg) of \${farine_tubercules-name}"
		}
	}

	capture {
		foreach rgvar of varlist farines_03_* {
			label variable `rgvar' "11.4 Quantity self-consumed in 2024 of \${farine_tubercules-name}"
			note `rgvar': "11.4 Quantity self-consumed in 2024 of \${farine_tubercules-name}"
		}
	}

	capture {
		foreach rgvar of varlist farines_04_* {
			label variable `rgvar' "11.5 Quantity sold in kg in 2024 of \${farine_tubercules-name}"
			note `rgvar': "11.5 Quantity sold in kg in 2024 of \${farine_tubercules-name}"
		}
	}

	capture {
		foreach rgvar of varlist farines_05_* {
			label variable `rgvar' "11.6 Current sale price in FCFA/kg of \${farine_tubercules-name}"
			note `rgvar': "11.6 Current sale price in FCFA/kg of \${farine_tubercules-name}"
		}
	}

	capture {
		foreach rgvar of varlist legumes_consumption_* {
			label variable `rgvar' "Did your household consume \${legumes-name} during this period?"
			note `rgvar': "Did your household consume \${legumes-name} during this period?"
			label define `rgvar' 1 "Yes" 0 "No" 2 "Don't know/did not answer"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist legumes_01_* {
			label variable `rgvar' "11.2 Area in hectare of \${legumes-name}"
			note `rgvar': "11.2 Area in hectare of \${legumes-name}"
		}
	}

	capture {
		foreach rgvar of varlist legumes_02_* {
			label variable `rgvar' "11.3 Total production in 2024 (kg) of \${legumes-name}"
			note `rgvar': "11.3 Total production in 2024 (kg) of \${legumes-name}"
		}
	}

	capture {
		foreach rgvar of varlist legumes_03_* {
			label variable `rgvar' "11.4 Quantity self-consumed in 2024 of \${legumes-name}"
			note `rgvar': "11.4 Quantity self-consumed in 2024 of \${legumes-name}"
		}
	}

	capture {
		foreach rgvar of varlist legumes_04_* {
			label variable `rgvar' "11.5 Quantity sold in kg in 2024 of \${legumes-name}"
			note `rgvar': "11.5 Quantity sold in kg in 2024 of \${legumes-name}"
		}
	}

	capture {
		foreach rgvar of varlist legumes_05_* {
			label variable `rgvar' "11.6 Current sale price in FCFA/kg of \${farine_tubercules-name}"
			note `rgvar': "11.6 Current sale price in FCFA/kg of \${farine_tubercules-name}"
		}
	}

	capture {
		foreach rgvar of varlist legumineuses_consumption_* {
			label variable `rgvar' "Did your household consume \${legumineuses-name} during this period?"
			note `rgvar': "Did your household consume \${legumineuses-name} during this period?"
			label define `rgvar' 1 "Yes" 0 "No" 2 "Don't know/did not answer"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist legumineuses_01_* {
			label variable `rgvar' "11.2 Area in hectare of \${legumineuses-name}"
			note `rgvar': "11.2 Area in hectare of \${legumineuses-name}"
		}
	}

	capture {
		foreach rgvar of varlist legumineuses_02_* {
			label variable `rgvar' "11.3 Total production in 2024 (kg) of \${legumineuses-name}"
			note `rgvar': "11.3 Total production in 2024 (kg) of \${legumineuses-name}"
		}
	}

	capture {
		foreach rgvar of varlist legumineuses_03_* {
			label variable `rgvar' "11.4 Quantity self-consumed in 2024 of \${legumineuses-name}"
			note `rgvar': "11.4 Quantity self-consumed in 2024 of \${legumineuses-name}"
		}
	}

	capture {
		foreach rgvar of varlist legumineuses_04_* {
			label variable `rgvar' "11.5 Quantity sold in kg in 2024 of \${legumineuses-name}"
			note `rgvar': "11.5 Quantity sold in kg in 2024 of \${legumineuses-name}"
		}
	}

	capture {
		foreach rgvar of varlist legumineuses_05_* {
			label variable `rgvar' "11.6 Current sale price in FCFA/kg of \${farine_tubercules-name}"
			note `rgvar': "11.6 Current sale price in FCFA/kg of \${farine_tubercules-name}"
		}
	}

	capture {
		foreach rgvar of varlist aquatique_consumption_* {
			label variable `rgvar' "Did your household consume \${aquatique-name} during this period?"
			note `rgvar': "Did your household consume \${aquatique-name} during this period?"
			label define `rgvar' 1 "Yes" 0 "No" 2 "Don't know/did not answer"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist aquatique_01_* {
			label variable `rgvar' "11.2 Area in hectare of \${aquatique-name}"
			note `rgvar': "11.2 Area in hectare of \${aquatique-name}"
		}
	}

	capture {
		foreach rgvar of varlist aquatique_02_* {
			label variable `rgvar' "11.3 Total production in 2024 (kg) of \${aquatique-name}"
			note `rgvar': "11.3 Total production in 2024 (kg) of \${aquatique-name}"
		}
	}

	capture {
		foreach rgvar of varlist aquatique_03_* {
			label variable `rgvar' "11.4 Quantity self-consumed in 2024 of \${aquatique-name}"
			note `rgvar': "11.4 Quantity self-consumed in 2024 of \${aquatique-name}"
		}
	}

	capture {
		foreach rgvar of varlist aquatique_04_* {
			label variable `rgvar' "11.5 Quantity sold in kg in 2024 of \${aquatique-name}"
			note `rgvar': "11.5 Quantity sold in kg in 2024 of \${aquatique-name}"
		}
	}

	capture {
		foreach rgvar of varlist aquatique_05_* {
			label variable `rgvar' "11.6 Current sale price in FCFA/kg of \${farine_tubercules-name}"
			note `rgvar': "11.6 Current sale price in FCFA/kg of \${farine_tubercules-name}"
		}
	}

	capture {
		foreach rgvar of varlist agri_income_07_* {
			label variable `rgvar' "8.8 Number of Heads of \${species-name} Currently"
			note `rgvar': "8.8 Number of Heads of \${species-name} Currently"
		}
	}

	capture {
		foreach rgvar of varlist agri_income_08_* {
			label variable `rgvar' "8.9 Number of Livestock of \${species-name} Sold (this year)"
			note `rgvar': "8.9 Number of Livestock of \${species-name} Sold (this year)"
		}
	}

	capture {
		foreach rgvar of varlist agri_income_09_* {
			label variable `rgvar' "8.10 Main reasons for selling"
			note `rgvar': "8.10 Main reasons for selling"
			label define `rgvar' 1 "1= input needs" 2 "2= agricultural equipment needs" 3 "3=immediate spending needs" 4 "4= familyceremony" 5 "5= death of animal ;" 6 "6= illness expenses" 7 "7= others, to be specified"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist agri_income_09_o_* {
			label variable `rgvar' "Other reason for selling"
			note `rgvar': "Other reason for selling"
		}
	}

	capture {
		foreach rgvar of varlist agri_income_10_* {
			label variable `rgvar' "8.11 Average price per head in FCFA"
			note `rgvar': "8.11 Average price per head in FCFA"
		}
	}

	capture {
		foreach rgvar of varlist agri_income_11_* {
			label variable `rgvar' "8.13 Number of Heads of \${sale_animales-name} sales"
			note `rgvar': "8.13 Number of Heads of \${sale_animales-name} sales"
		}
	}

	capture {
		foreach rgvar of varlist agri_income_12_* {
			label variable `rgvar' "8.14 Amount in FCFA"
			note `rgvar': "8.14 Amount in FCFA"
		}
	}

	capture {
		foreach rgvar of varlist agri_income_13_* {
			label variable `rgvar' "8.15 Nature des produits provenant de \${sale_animales-name}"
			note `rgvar': "8.15 Nature des produits provenant de \${sale_animales-name}"
		}
	}

	capture {
		foreach rgvar of varlist agri_income_14_* {
			label variable `rgvar' "8.16 Amount in FCFA"
			note `rgvar': "8.16 Amount in FCFA"
		}
	}

	capture {
		foreach rgvar of varlist agri_income_13_autre_* {
			label variable `rgvar' "Other nature"
			note `rgvar': "Other nature"
		}
	}

	capture {
		foreach rgvar of varlist agri_income_21_h_* {
			label variable `rgvar' "8.24 Number of People Involved (man)"
			note `rgvar': "8.24 Number of People Involved (man)"
		}
	}

	capture {
		foreach rgvar of varlist agri_income_21_f_* {
			label variable `rgvar' "8.24 Number of People Involved (woman)"
			note `rgvar': "8.24 Number of People Involved (woman)"
		}
	}

	capture {
		foreach rgvar of varlist agri_income_22_* {
			label variable `rgvar' "8.25 Activity frequenct per year (months)"
			note `rgvar': "8.25 Activity frequenct per year (months)"
		}
	}

	capture {
		foreach rgvar of varlist agri_income_23_* {
			label variable `rgvar' "8.26 Income by frequency"
			note `rgvar': "8.26 Income by frequency"
		}
	}

	capture {
		foreach rgvar of varlist agri_income_24_* {
			label variable `rgvar' "8.27 Total annual income"
			note `rgvar': "8.27 Total annual income"
		}
	}

	capture {
		foreach rgvar of varlist agri_income_36_* {
			label variable `rgvar' "8.39 If yes, how much?"
			note `rgvar': "8.39 If yes, how much?"
		}
	}

	capture {
		foreach rgvar of varlist agri_income_37_* {
			label variable `rgvar' "8.40 From whom? (source of credit)"
			note `rgvar': "8.40 From whom? (source of credit)"
		}
	}

	capture {
		foreach rgvar of varlist agri_income_38_* {
			label variable `rgvar' "8.41 What is the amount already repaid?"
			note `rgvar': "8.41 What is the amount already repaid?"
		}
	}

	capture {
		foreach rgvar of varlist agri_income_39_* {
			label variable `rgvar' "8.42 What is the Remaining Amount to Pay?"
			note `rgvar': "8.42 What is the Remaining Amount to Pay?"
		}
	}

	capture {
		foreach rgvar of varlist agri_income_41_* {
			label variable `rgvar' "8.44 If yes, what is the amount?"
			note `rgvar': "8.44 If yes, what is the amount?"
		}
	}

	capture {
		foreach rgvar of varlist agri_income_42_* {
			label variable `rgvar' "8.45 What is the amount already paid?"
			note `rgvar': "8.45 What is the amount already paid?"
		}
	}

	capture {
		foreach rgvar of varlist agri_income_43_* {
			label variable `rgvar' "8.48 What is the amount due?"
			note `rgvar': "8.48 What is the amount due?"
		}
	}

	capture {
		foreach rgvar of varlist agri_income_44_* {
			label variable `rgvar' "8.47 What is the net value of transfers in the last 12 months?"
			note `rgvar': "8.47 What is the net value of transfers in the last 12 months?"
		}
	}

	capture {
		foreach rgvar of varlist agri_income_45_* {
			label variable `rgvar' "8.49 amount of \${product-name}"
			note `rgvar': "8.49 amount of \${product-name}"
		}
	}

	capture {
		foreach rgvar of varlist agri_income_46_* {
			label variable `rgvar' "8.50 sources of financing (multiple choices)"
			note `rgvar': "8.50 sources of financing (multiple choices)"
		}
	}

	capture {
		foreach rgvar of varlist agri_income_46_o_* {
			label variable `rgvar' "8.50_o Other financing source for \${product-name}"
			note `rgvar': "8.50_o Other financing source for \${product-name}"
		}
	}

	capture {
		foreach rgvar of varlist agri_income_47_* {
			label variable `rgvar' "Amount (KG) of \${goods-name}"
			note `rgvar': "Amount (KG) of \${goods-name}"
		}
	}

	capture {
		foreach rgvar of varlist agri_income_48_* {
			label variable `rgvar' "Amount (FCFA)"
			note `rgvar': "Amount (FCFA)"
		}
	}




	* append old, previously-imported data (if any)
	cap confirm file "`dtafile'"
	if _rc == 0 {
		* mark all new data before merging with old data
		gen new_data_row=1
		
		* pull in old data
		append using "`dtafile'"
		
		* drop duplicates in favor of old, previously-imported data if overwrite_old_data is 0
		* (alternatively drop in favor of new data if overwrite_old_data is 1)
		sort key
		by key: gen num_for_key = _N
		drop if num_for_key > 1 & ((`overwrite_old_data' == 0 & new_data_row == 1) | (`overwrite_old_data' == 1 & new_data_row ~= 1))
		drop num_for_key

		* drop new-data flag
		drop new_data_row
	}
	
	* save data to Stata format
	save "`dtafile'", replace

	* show codebook and notes
	codebook
	notes list
}

disp
disp "Finished import of: `csvfile'"
disp

* OPTIONAL: LOCALLY-APPLIED STATA CORRECTIONS
*
* Rather than using SurveyCTO's review and correction workflow, the code below can apply a list of corrections
* listed in a local .csv file. Feel free to use, ignore, or delete this code.
*
*   Corrections file path and filename:  DISES_Enquête ménage midline pilote_corrections.csv
*
*   Corrections file columns (in order): key, fieldname, value, notes

capture confirm file "`corrfile'"
if _rc==0 {
	disp
	disp "Starting application of corrections in: `corrfile'"
	disp

	* save primary data in memory
	preserve

	* load corrections
	insheet using "`corrfile'", names clear
	
	if _N>0 {
		* number all rows (with +1 offset so that it matches row numbers in Excel)
		gen rownum=_n+1
		
		* drop notes field (for information only)
		drop notes
		
		* make sure that all values are in string format to start
		gen origvalue=value
		tostring value, format(%100.0g) replace
		cap replace value="" if origvalue==.
		drop origvalue
		replace value=trim(value)
		
		* correct field names to match Stata field names (lowercase, drop -'s and .'s)
		replace fieldname=lower(subinstr(subinstr(fieldname,"-","",.),".","",.))
		
		* format date and date/time fields (taking account of possible wildcards for repeat groups)
		forvalues i = 1/100 {
			if "`datetime_fields`i''" ~= "" {
				foreach dtvar in `datetime_fields`i'' {
					* skip fields that aren't yet in the data
					cap unab dtvarignore : `dtvar'
					if _rc==0 {
						gen origvalue=value
						replace value=string(clock(value,"MDYhms",2025),"%25.0g") if strmatch(fieldname,"`dtvar'")
						* allow for cases where seconds haven't been specified
						replace value=string(clock(origvalue,"MDYhm",2025),"%25.0g") if strmatch(fieldname,"`dtvar'") & value=="." & origvalue~="."
						drop origvalue
					}
				}
			}
			if "`date_fields`i''" ~= "" {
				foreach dtvar in `date_fields`i'' {
					* skip fields that aren't yet in the data
					cap unab dtvarignore : `dtvar'
					if _rc==0 {
						replace value=string(clock(value,"MDY",2025),"%25.0g") if strmatch(fieldname,"`dtvar'")
					}
				}
			}
		}

		* write out a temp file with the commands necessary to apply each correction
		tempfile tempdo
		file open dofile using "`tempdo'", write replace
		local N = _N
		forvalues i = 1/`N' {
			local fieldnameval=fieldname[`i']
			local valueval=value[`i']
			local keyval=key[`i']
			local rownumval=rownum[`i']
			file write dofile `"cap replace `fieldnameval'="`valueval'" if key=="`keyval'""' _n
			file write dofile `"if _rc ~= 0 {"' _n
			if "`valueval'" == "" {
				file write dofile _tab `"cap replace `fieldnameval'=. if key=="`keyval'""' _n
			}
			else {
				file write dofile _tab `"cap replace `fieldnameval'=`valueval' if key=="`keyval'""' _n
			}
			file write dofile _tab `"if _rc ~= 0 {"' _n
			file write dofile _tab _tab `"disp"' _n
			file write dofile _tab _tab `"disp "CAN'T APPLY CORRECTION IN ROW #`rownumval'""' _n
			file write dofile _tab _tab `"disp"' _n
			file write dofile _tab `"}"' _n
			file write dofile `"}"' _n
		}
		file close dofile
	
		* restore primary data
		restore
		
		* execute the .do file to actually apply all corrections
		do "`tempdo'"

		* re-save data
		save "`dtafile'", replace
	}
	else {
		* restore primary data		
		restore
	}

	disp
	disp "Finished applying corrections in: `corrfile'"
	disp
}
