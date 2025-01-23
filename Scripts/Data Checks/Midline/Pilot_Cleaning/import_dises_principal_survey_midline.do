* import_dises_principal_survey_midline.do
*
* 	Imports and aggregates "DISES_ Principal Survey MIDLINE" (ID: dises_principal_survey_midline) data.
*
*	Inputs:  "DISES_ Principal Survey MIDLINE_WIDE.csv"
*	Outputs: "DISES_ Principal Survey MIDLINE.dta"
*
*	Output by SurveyCTO January 17, 2025 2:19 PM.

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
local csvfile "DISES_ Principal Survey MIDLINE_WIDE.csv"
local dtafile "DISES_ Principal Survey MIDLINE.dta"
local corrfile "DISES_ Principal Survey MIDLINE_corrections.csv"
local note_fields1 ""
local text_fields1 "deviceid devicephonenum username device_info duration caseid record_text village_select_o hhid_village region departement commune village grappe schoolmosqueclinic grappe_int sup_txt sup_name"
local text_fields2 "consent_notes start_survey respondent_name school_water_use grade_loop grade_loop_count grade_loop_repeat_count grade_loop_index_* grade_loop_name_* classroom_loop_count_* classroom_index_*"
local text_fields3 "photo_enrollment_2024_* grade_loop_2025 grade_loop_count_2025 grade_loop_repeat_2025_count grade_loop_index_2025_* grade_loop_name_2025_* classroom_loop_2025_count_* classroom_index_2025_*"
local text_fields4 "photo_enrollment_2025_* main_absenteeism_reasons schistosomiasis_sources schistosomiasis_treatment_date instanceid"
local date_fields1 "today"
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
	label define sup 1 "Superviseur 1" 2 "Superviseur 2" 3 "Superviseur 3" 4 "Superviseur 4" 5 "Superviseur 5"
	label values sup sup

	label variable sup_txt "PLEASE ENTER THE NAME"
	note sup_txt: "PLEASE ENTER THE NAME"

	label variable consent_obtain "Have you obtained oral or written consent to participate in this survey?"
	note consent_obtain: "Have you obtained oral or written consent to participate in this survey?"
	label define consent_obtain 1 "Yes" 0 "No"
	label values consent_obtain consent_obtain

	label variable consent_notes "If 'No,' specify why consent was not provided:"
	note consent_notes: "If 'No,' specify why consent was not provided:"

	label variable respondent_is_director "Is the person you are interviewing the school director?"
	note respondent_is_director: "Is the person you are interviewing the school director?"
	label define respondent_is_director 1 "Yes" 0 "No"
	label values respondent_is_director respondent_is_director

	label variable respondent_is_not_director "Why are you not able to interview the school director?"
	note respondent_is_not_director: "Why are you not able to interview the school director?"
	label define respondent_is_not_director 1 "They are away from work (traveling, sick, etc.)" 2 "Cannot get through to their phone" 3 "There is not currently a school director" 99 "Other, specify"
	label values respondent_is_not_director respondent_is_not_director

	label variable respondent_other_role "If 'No,' who are you interviewing? Options: 1 – Deputy Director 2 – Teacher 3 – "
	note respondent_other_role: "If 'No,' who are you interviewing? Options: 1 – Deputy Director 2 – Teacher 3 – Other"
	label define respondent_other_role 1 "Deputy Director" 2 "Teacher" 99 "Other, specify"
	label values respondent_other_role respondent_other_role

	label variable respondent_name "Respondent's full name:"
	note respondent_name: "Respondent's full name:"

	label variable respondent_phone_primary "Primary contact number of respondent:"
	note respondent_phone_primary: "Primary contact number of respondent:"

	label variable respondent_phone_secondary "Secondary contact number of respondent:"
	note respondent_phone_secondary: "Secondary contact number of respondent:"

	label variable respondent_gender "Respondent’s gender: 1 – Male 2 – Female"
	note respondent_gender: "Respondent’s gender: 1 – Male 2 – Female"
	label define respondent_gender 1 "Male" 2 "Female"
	label values respondent_gender respondent_gender

	label variable respondent_age "Respondent’s age (in completed years):"
	note respondent_age: "Respondent’s age (in completed years):"

	label variable director_experience_general "If Director: How long have you been a director (at any school)? (Years)"
	note director_experience_general: "If Director: How long have you been a director (at any school)? (Years)"

	label variable director_experience_specific "If Director: How long have you been a director at this school? (Years)"
	note director_experience_specific: "If Director: How long have you been a director at this school? (Years)"

	label variable school_water_main "What is the school’s main source of water? Options: 1 – Piped 2 – Tubewell 3 – W"
	note school_water_main: "What is the school’s main source of water? Options: 1 – Piped 2 – Tubewell 3 – Well 4 – Rainwater 5 – River, Lake, or Canal 6 – Other"
	label define school_water_main 1 "Piped" 2 "Tubewell" 3 "Well" 4 "Rainwater" 5 "River, Lake, or Canal" 99 "Other, specify"
	label values school_water_main school_water_main

	label variable school_distance_river "How far is the school from the closest community access point to collect surface"
	note school_distance_river: "How far is the school from the closest community access point to collect surface water( (e.g., river/lake/canal )(in meters)?"

	label variable school_children_water_collection "Does the school ever send children to the river, lake or canal to collect surfac"
	note school_children_water_collection: "Does the school ever send children to the river, lake or canal to collect surface water?"
	label define school_children_water_collection 1 "Yes" 0 "No"
	label values school_children_water_collection school_children_water_collection

	label variable school_water_use "If 'Yes,' what is this water used for? Options: 1 – Drinking 2 – Cleaning 3 – Wa"
	note school_water_use: "If 'Yes,' what is this water used for? Options: 1 – Drinking 2 – Cleaning 3 – Watering plants 4 – Other"

	label variable school_reading_french "Does the school have reading materials in French for grades 1–3?"
	note school_reading_french: "Does the school have reading materials in French for grades 1–3?"
	label define school_reading_french 1 "Yes" 0 "No"
	label values school_reading_french school_reading_french

	label variable school_reading_local "Does the school have any reading materials in [local language] for grades 1–3?"
	note school_reading_local: "Does the school have any reading materials in [local language] for grades 1–3?"
	label define school_reading_local 1 "Yes" 0 "No"
	label values school_reading_local school_reading_local

	label variable school_computer_access "Does the school have any computer equipment available to students?"
	note school_computer_access: "Does the school have any computer equipment available to students?"
	label define school_computer_access 1 "Yes" 0 "No"
	label values school_computer_access school_computer_access

	label variable school_meal_program "Does the school have a regular school meal program?"
	note school_meal_program: "Does the school have a regular school meal program?"
	label define school_meal_program 1 "Yes" 0 "No"
	label values school_meal_program school_meal_program

	label variable school_teachers "How many teachers work at this school regularly?"
	note school_teachers: "How many teachers work at this school regularly?"

	label variable school_staff_paid_non_teaching "How many paid non-teaching staff work at this school regularly?"
	note school_staff_paid_non_teaching: "How many paid non-teaching staff work at this school regularly?"

	label variable school_staff_volunteers "How many unpaid volunteers (excluding council members) work at this school regul"
	note school_staff_volunteers: "How many unpaid volunteers (excluding council members) work at this school regularly?"

	label variable school_council "Does the school have a council?"
	note school_council: "Does the school have a council?"
	label define school_council 1 "Yes" 0 "No"
	label values school_council school_council

	label variable council_school_staff "If 'Yes,' how many school staff members sit on the school council?"
	note council_school_staff: "If 'Yes,' how many school staff members sit on the school council?"

	label variable council_community_members "If 'Yes,' how many community members (who are not school staff) sit on the schoo"
	note council_community_members: "If 'Yes,' how many community members (who are not school staff) sit on the school council?"

	label variable council_women "If 'Yes,' how many women sit on the school council?"
	note council_women: "If 'Yes,' how many women sit on the school council?"

	label variable council_chief_involvement "If 'Yes,' does the village chief sit on the school council?"
	note council_chief_involvement: "If 'Yes,' does the village chief sit on the school council?"
	label define council_chief_involvement 1 "Yes" 0 "No"
	label values council_chief_involvement council_chief_involvement

	label variable grade_loop "Loop by grade level: How many grades were taught in 2024?"
	note grade_loop: "Loop by grade level: How many grades were taught in 2024?"

	label variable grade_loop_2025 "How many grades are taught at the school this year?"
	note grade_loop_2025: "How many grades are taught at the school this year?"

	label variable absenteeism_problem "Do you think student absenteeism is a problem in your school (among children who"
	note absenteeism_problem: "Do you think student absenteeism is a problem in your school (among children who are already enrolled)?"
	label define absenteeism_problem 1 "Yes" 0 "No"
	label values absenteeism_problem absenteeism_problem

	label variable main_absenteeism_reasons "What are the main reasons for student absenteeism in your school? [Select multip"
	note main_absenteeism_reasons: "What are the main reasons for student absenteeism in your school? [Select multiple]"

	label variable absenteeism_top_reason "Of those selected, which would you say is the #1 reason? [Select one]"
	note absenteeism_top_reason: "Of those selected, which would you say is the #1 reason? [Select one]"
	label define absenteeism_top_reason 1 "Poor health" 2 "Household chores (not agriculutral responsibilities)" 3 "Skipping school" 4 "Inaccesible due to distance or weather" 5 "Agricultural work" 6 "Non-agricultural work" 99 "Other, specify"
	label values absenteeism_top_reason absenteeism_top_reason

	label variable schistosomiasis_problem "Do you think schistosomiasis (bilharzia) is a problem in your school among stude"
	note schistosomiasis_problem: "Do you think schistosomiasis (bilharzia) is a problem in your school among students?"
	label define schistosomiasis_problem 1 "Yes" 0 "No"
	label values schistosomiasis_problem schistosomiasis_problem

	label variable peak_schistosomiasis_month "In what month do students typically get the most schistosomiasis (bilharzia) inf"
	note peak_schistosomiasis_month: "In what month do students typically get the most schistosomiasis (bilharzia) infections?"
	label define peak_schistosomiasis_month 1 "Jaunary" 2 "February" 3 "March" 4 "April" 5 "May" 6 "June" 7 "July" 8 "August" 9 "September" 10 "October" 11 "November" 12 "December"
	label values peak_schistosomiasis_month peak_schistosomiasis_month

	label variable schistosomiasis_primary_effect "What do you think is the primary way that schistosomiasis (bilharzia) affects st"
	note schistosomiasis_primary_effect: "What do you think is the primary way that schistosomiasis (bilharzia) affects students?"
	label define schistosomiasis_primary_effect 1 "Students miss school because they stay home due to the illness" 2 "Students attend school but are unable to learn well because they are sick"
	label values schistosomiasis_primary_effect schistosomiasis_primary_effect

	label variable schistosomiasis_sources "Where do you think children get schistosomiasis?"
	note schistosomiasis_sources: "Where do you think children get schistosomiasis?"

	label variable schistosomiasis_treatment_minist "Did the Ministry of Health come to your school in December to administer medicin"
	note schistosomiasis_treatment_minist: "Did the Ministry of Health come to your school in December to administer medicine to students for schistosomiasis (bilharzia)?"
	label define schistosomiasis_treatment_minist 1 "Yes" 0 "No"
	label values schistosomiasis_treatment_minist schistosomiasis_treatment_minist

	label variable schistosomiasis_treatment_date "When is the last time that someone came to administer medicine to students for s"
	note schistosomiasis_treatment_date: "When is the last time that someone came to administer medicine to students for schistosomiasis (bilharzia)?"



	capture {
		foreach rgvar of varlist classroom_count_* {
			label variable `rgvar' "Loop by classrooms: How many classrooms are in Grade \${grade_loop_name}?"
			note `rgvar': "Loop by classrooms: How many classrooms are in Grade \${grade_loop_name}?"
		}
	}

	capture {
		foreach rgvar of varlist enrollment_2024_male_* {
			label variable `rgvar' "How many male students enrolled in Grade \${grade_loop_name} Classroom \${classr"
			note `rgvar': "How many male students enrolled in Grade \${grade_loop_name} Classroom \${classroom_index}?"
		}
	}

	capture {
		foreach rgvar of varlist enrollment_2024_female_* {
			label variable `rgvar' "How many female students enrolled in Grade \${grade_loop_name} Classroom \${clas"
			note `rgvar': "How many female students enrolled in Grade \${grade_loop_name} Classroom \${classroom_index}?"
		}
	}

	capture {
		foreach rgvar of varlist passing_2024_male_* {
			label variable `rgvar' "How many male students passed Grade \${grade_loop_name} Classroom \${classroom_i"
			note `rgvar': "How many male students passed Grade \${grade_loop_name} Classroom \${classroom_index}?"
		}
	}

	capture {
		foreach rgvar of varlist passing_2024_female_* {
			label variable `rgvar' "How many female students passed Grade \${grade_loop_name} Classroom \${classroom"
			note `rgvar': "How many female students passed Grade \${grade_loop_name} Classroom \${classroom_index}?"
		}
	}

	capture {
		foreach rgvar of varlist photo_enrollment_2024_* {
			label variable `rgvar' "Take a photo of enrollment log for Grade \${grade_loop_name} Classroom \${classr"
			note `rgvar': "Take a photo of enrollment log for Grade \${grade_loop_name} Classroom \${classroom_index}:"
		}
	}

	capture {
		foreach rgvar of varlist classroom_count_2025_* {
			label variable `rgvar' "How many classrooms are in Grade \${grade_loop_name_2025}?"
			note `rgvar': "How many classrooms are in Grade \${grade_loop_name_2025}?"
		}
	}

	capture {
		foreach rgvar of varlist enrollment_2025_male_* {
			label variable `rgvar' "How many male students are enrolled in Grade \${grade_loop_name_2025} Classroom "
			note `rgvar': "How many male students are enrolled in Grade \${grade_loop_name_2025} Classroom \${classroom_index_2025} this year?"
		}
	}

	capture {
		foreach rgvar of varlist enrollment_2025_female_* {
			label variable `rgvar' "How many female students are enrolled in Grade \${grade_loop_name_2025} Classroo"
			note `rgvar': "How many female students are enrolled in Grade \${grade_loop_name_2025} Classroom \${classroom_index_2025} this year?"
		}
	}

	capture {
		foreach rgvar of varlist photo_enrollment_2025_* {
			label variable `rgvar' "Take a photo of the enrollment log for Grade \${grade_loop_name_2025} Classroom "
			note `rgvar': "Take a photo of the enrollment log for Grade \${grade_loop_name_2025} Classroom \${classroom_index_2025}:"
		}
	}

	capture {
		foreach rgvar of varlist attendence_regularly_* {
			label variable `rgvar' "Do teachers record student attendance regularly? 1 - Yes 2 - No"
			note `rgvar': "Do teachers record student attendance regularly? 1 - Yes 2 - No"
			label define `rgvar' 1 "Yes" 0 "No"
			label values `rgvar' `rgvar'
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
*   Corrections file path and filename:  DISES_ Principal Survey MIDLINE_corrections.csv
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
