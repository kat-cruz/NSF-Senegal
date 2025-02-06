*** DISES Treatment Data Checks ***
*** File Created By: Molly Doruska ***
*** File Last Updated By: Molly Doruska ***
*** File Last Updated On: Oct 21, 2024 ***

clear all 

**** Master file path  ****

if "`c(username)'"=="socrm" {
                global master "C:\Users\socrm\Box\NSF Senegal"
}
else if "`c(username)'"=="km978" {
                global master "C:\Users\km978\Box\NSF Senegal"
				
}

global treatment "$master\Data_Management\Output\Data_Quality_Checks\Treatment"
global issues "$master\Data_Management\Output\Data_Quality_Checks\April_Output\Full Issues"

global data "$master\Data_Management\_CRDES_RawData\Treatment"

*** import treatment notes data ***
*** update with the correct file name ***
import delimited "$data\Exercice de planification_WIDE_21Oct24.csv", clear varnames(1) bindquote(strict)

*** drop pilot village ***
drop if village_select == -999

*** Value Checks ***

*** village name missing *** 
preserve	

    keep if village_code == "."
	
	keep village_code village sup_name date_visit
  
    * Generate an "issue" variable
    generate issue = "Missing"
	
	* Generate name of variable issue 
	gen issue_variable_name = "village_code"
	
	* Rename variable with issue 
	rename village_code print_issue
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$treatment\Issue_Treatment_village_code.dta", replace
	}
restore

*** village chief name missing *** 
preserve	

    keep if chef_name == "."
	
	keep village village_code sup_name date_visit chef_name
  
    * Generate an "issue" variable
    generate issue = "Missing"
	
	* Generate name of variable issue 
	gen issue_variable_name = "chef_name"
	
	* Rename variable with issue 
	rename chef_name print_issue
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$treatment\Issue_Treatment_village_cheif_name.dta", replace
	}
restore

*** date_visit missing *** 
preserve	

    keep if date_visit == "."
	
	keep village village_code sup_name date_visit
  
    * Generate an "issue" variable
    generate issue = "Missing"
	
	* Generate name of variable issue 
	gen issue_variable_name = "date_visit"
	
	* Rename variable with issue 
	rename date_visit print_issue
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$treatment\Issue_Treatment_date_visit.dta", replace
	}
restore

*** supervisor missing *** 
preserve	

    keep if sup_name == "."
	
	keep village village_code sup_name date_visit
  
    * Generate an "issue" variable
    generate issue = "Missing"
	
	* Generate name of variable issue 
	gen issue_variable_name = "sup_name"
	
	* Rename variable with issue 
	rename sup_name print_issue
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$treatment\Issue_Treatment_sup_name.dta", replace
	}
restore

*** village chief telephone missing *** 
preserve	

    keep if chef_phone == .
	
	keep village village_code sup_name date_visit chef_phone
  
    * Generate an "issue" variable
    generate issue = "Missing"
	
	* Generate name of variable issue 
	gen issue_variable_name = "chef_phone"
	
	* Rename variable with issue 
	rename chef_phone print_issue
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$treatment\Issue_Treatment_village_cheif_telephone.dta", replace
	}
restore

*** relais communautaire missing *** 
preserve	

    keep if relais_name == "."
	
	keep village village_code sup_name date_visit relais_name
  
    * Generate an "issue" variable
    generate issue = "Missing"
	
	* Generate name of variable issue 
	gen issue_variable_name = "relais_name"
	
	* Rename variable with issue 
	rename relais_name print_issue
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$treatment\Issue_Treatment_relai_communautaire.dta", replace
	}
restore

*** question 1 missing *** 
preserve	

    keep if q_01 == .
	
	keep village village_code sup_name date_visit q_01
  
    * Generate an "issue" variable
    generate issue = "Missing"
	
	* Generate name of variable issue 
	gen issue_variable_name = "q_01"
	
	* Rename variable with issue 
	rename q_01 print_issue
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$treatment\Issue_Treatment_q_01.dta", replace
	}
restore

*** question 2 missing *** 
preserve	

    keep if q_02 == .
	
	keep village village_code sup_name date_visit q_02
  
    * Generate an "issue" variable
    generate issue = "Missing"
	
	* Generate name of variable issue 
	gen issue_variable_name = "q_02"
	
	* Rename variable with issue 
	rename q_02 print_issue
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$treatment\Issue_Treatment_q_02.dta", replace
	}
restore

*** question 3 missing *** 
preserve	

    keep if q_03 == .
	
	keep village village_code sup_name date_visit q_03
  
    * Generate an "issue" variable
    generate issue = "Missing"
	
	* Generate name of variable issue 
	gen issue_variable_name = "q_03"
	
	* Rename variable with issue 
	rename q_03 print_issue
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$treatment\Issue_Treatment_q_03.dta", replace
	}
restore

*** question 12 missing *** 
preserve	

    keep if q_12 == "."
	
	keep village village_code sup_name date_visit q_12
  
    * Generate an "issue" variable
    generate issue = "Missing"
	
	* Generate name of variable issue 
	gen issue_variable_name = "q_12"
	
	* Rename variable with issue 
	rename q_12 print_issue
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$treatment\Issue_Treatment_q_12.dta", replace
	}
restore

*** question 13 missing *** 
preserve	

    keep if q_13 == .
	
	keep village village_code sup_name date_visit q_13
  
    * Generate an "issue" variable
    generate issue = "Missing"
	
	* Generate name of variable issue 
	gen issue_variable_name = "q_13"
	
	* Rename variable with issue 
	rename q_13 print_issue
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$treatment\Issue_Treatment_q_13.dta", replace
	}
restore

*** question 14 missing *** 
preserve	

    keep if q_14 == .
	
	keep village village_code sup_name date_visit q_14
  
    * Generate an "issue" variable
    generate issue = "Missing"
	
	* Generate name of variable issue 
	gen issue_variable_name = "q_14"
	
	* Rename variable with issue 
	rename q_14 print_issue
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$treatment\Issue_Treatment_q_14.dta", replace
	}
	
restore

*** question 1, the number of participants should be between 1 and 50 ***
preserve	

    keep if q_01 < 1 | q_01 > 50 
	
	keep village village_code sup_name date_visit q_01
  
    * Generate an "issue" variable
    generate issue = "Unreasonable value"
	
	* Generate name of variable issue 
	gen issue_variable_name = "q_01"
	
	* Rename variable with issue 
	rename q_01 print_issue
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$treatment\Issue_Treatment_q_01_unreasonable.dta", replace
	}
restore

*** question 2, the number of participants should be between 1 and 50 ***
preserve	

    keep if q_02 < 1 | q_02 > 50 
	
	keep village village_code sup_name date_visit q_02
  
    * Generate an "issue" variable
    generate issue = "Unreasonable value"
	
	* Generate name of variable issue 
	gen issue_variable_name = "q_02"
	
	* Rename variable with issue 
	rename q_02 print_issue
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$treatment\Issue_Treatment_q_02_unreasonable.dta", replace
	}
	
restore

*** question 3, the reponse should be 0 or 1 ***
preserve	

    keep if q_03 < 0 | q_03 > 1 
	
	keep village village_code sup_name date_visit q_03
  
    * Generate an "issue" variable
    generate issue = "Unreasonable value"
	
	* Generate name of variable issue 
	gen issue_variable_name = "q_03"
	
	* Rename variable with issue 
	rename q_03 print_issue
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$treatment\Issue_Treatment_q_03_unreasonable.dta", replace
	}
	
restore

*** question 14, the number of participants should be between 1 and 3 ***
preserve	

    keep if q_14 < 1 | q_14 > 3 
	
	keep village village_code sup_name date_visit q_14
  
    * Generate an "issue" variable
    generate issue = "Unreasonable value"
	
	* Generate name of variable issue 
	gen issue_variable_name = "q_14"
	
	* Rename variable with issue 
	rename q_14 print_issue
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$treatment\Issue_Treatment_q_14_unreasonable.dta", replace
	}
restore

****** questions for treatment groups A and C *******

*** question 4, response should be 0, 1, 2, 3, 4, or 99  ***
preserve	

	keep if treatment_arms_survey == "A" | treatment_arms_survey == "C" 
	
    gen ind_var = 0 
	replace ind_var = 1 if q_04 < 0 
	replace ind_var = 1 if q_04 > 4 & q_04 != 99 
	keep if ind_var == 1 
	
	keep village village_code sup_name date_visit q_04
  
    * Generate an "issue" variable
    generate issue = "Unreasonable value"
	
	* Generate name of variable issue 
	gen issue_variable_name = "q_04"
	
	* Rename variable with issue 
	rename q_04 print_issue
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$treatment\Issue_Treatment_q4_unreasonable.dta", replace
	}
restore

*** question 5, response should be between 1 and 200  ***
preserve	

	keep if treatment_arms_survey == "A" | treatment_arms_survey == "C"  
	
	keep if q_05 < 1 | q_05 > 200
	
	keep village village_code sup_name date_visit q_05
  
    * Generate an "issue" variable
    generate issue = "Unreasonable value"
	
	* Generate name of variable issue 
	gen issue_variable_name = "q_05"
	
	* Rename variable with issue 
	rename q_05 print_issue
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$treatment\Issue_Treatment_q5_unreasonable.dta", replace
	}
restore

*** question 6, response should be 0 or 1  ***
preserve	

	keep if treatment_arms_survey == "A" | treatment_arms_survey == "C" 
	
	keep if q_06 < 0 | q_06 > 1
	
	keep village village_code sup_name date_visit q_06
  
    * Generate an "issue" variable
    generate issue = "Unreasonable value"
	
	* Generate name of variable issue 
	gen issue_variable_name = "q_06"
	
	* Rename variable with issue 
	rename q_06 print_issue
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$treatment\Issue_Treatment_q6_unreasonable.dta", replace
	}
restore

*** question 7, response should be 0 or 1  ***
preserve	

	keep if treatment_arms_survey == "A" | treatment_arms_survey == "C"  
	
	keep if q_07 < 0 | q_07 > 1
	
	keep village village_code sup_name date_visit q_07
  
    * Generate an "issue" variable
    generate issue = "Unreasonable value"
	
	* Generate name of variable issue 
	gen issue_variable_name = "q_07"
	
	* Rename variable with issue 
	rename q_07 print_issue
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$treatment\Issue_Treatment_q7_unreasonable.dta", replace
	}
restore

*** question 8, response should be 1, 2, 3 or 99  ***
preserve	

	keep if treatment_arms_survey == "A" | treatment_arms_survey == "C"  
	
    gen ind_var = 0 
	replace ind_var = 1 if q_08 < 1 
	replace ind_var = 1 if q_08 > 3 & q_08 != 99 
	keep if ind_var == 1 
	
	keep village village_code sup_name date_visit q_08
  
    * Generate an "issue" variable
    generate issue = "Unreasonable value"
	
	* Generate name of variable issue 
	gen issue_variable_name = "q_08"
	
	* Rename variable with issue 
	rename q_08 print_issue
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$treatment\Issue_Treatment_q8_unreasonable.dta", replace
	}
restore

*** question 9, response should be 0 or 1  ***
preserve	

	keep if treatment_arms_survey == "A" | treatment_arms_survey == "C" 
	
	keep if q_09 < 0 | q_09 > 1
	
	keep village village_code sup_name date_visit q_09
  
    * Generate an "issue" variable
    generate issue = "Unreasonable value"
	
	* Generate name of variable issue 
	gen issue_variable_name = "q_09"
	
	* Rename variable with issue 
	rename q_09 print_issue
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$treatment\Issue_Treatment_q9_unreasonable.dta", replace
	}
restore

*** question 15, response should be 0 or 1  ***
preserve	

	keep if treatment_arms_survey == "A" | treatment_arms_survey == "C"  
	
	keep if q_15 < 0 | q_15 > 1
	
	keep village village_code sup_name date_visit q_15
  
    * Generate an "issue" variable
    generate issue = "Unreasonable value"
	
	* Generate name of variable issue 
	gen issue_variable_name = "q_15"
	
	* Rename variable with issue 
	rename q_15 print_issue
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$treatment\Issue_Treatment_q15_unreasonable.dta", replace
	}
restore

*** question 16, response should be 0 or 1  ***
preserve	

	keep if treatment_arms_survey == "A" | treatment_arms_survey == "C"  
	
	keep if q_16 < 0 | q_16 > 1
	
	keep village village_code sup_name date_visit q_16
  
    * Generate an "issue" variable
    generate issue = "Unreasonable value"
	
	* Generate name of variable issue 
	gen issue_variable_name = "q_16"
	
	* Rename variable with issue 
	rename q_16 print_issue
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$treatment\Issue_Treatment_q16_unreasonable.dta", replace
	}
restore

*** question 17, response should be text  ***
preserve	

	keep if treatment_arms_survey == "A" | treatment_arms_survey == "C"  
	
	keep if q_17 == "."
	
	keep village village_code sup_name date_visit q_17
  
    * Generate an "issue" variable
    generate issue = "Missing"
	
	* Generate name of variable issue 
	gen issue_variable_name = "q_17"
	
	* Rename variable with issue 
	rename q_17 print_issue
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$treatment\Issue_Treatment_q_17_missing.dta", replace
	}
restore

*** question 18, response should be phone number  ***
preserve	

	keep if treatment_arms_survey == "A" | treatment_arms_survey == "C"  
	
	keep if q_18 == .
	
	keep village village_code sup_name date_visit q_18
  
    * Generate an "issue" variable
    generate issue = "Missing"
	
	* Generate name of variable issue 
	gen issue_variable_name = "q_18"
	
	* Rename variable with issue 
	rename q_18 print_issue
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$treatment\Issue_Treatment_q_18_missing.dta", replace
	}
restore

*** question 19, response should 1, 2, or 3 ***
preserve	

	keep if treatment_arms_survey == "A" | treatment_arms_survey == "C"  
	
	keep if q_19 < 1 | q_19 > 3
	
	keep village village_code sup_name date_visit q_19
  
    * Generate an "issue" variable
    generate issue = "Unreasonable value"
	
	* Generate name of variable issue 
	gen issue_variable_name = "q_19"
	
	* Rename variable with issue 
	rename q_19 print_issue
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$treatment\Issue_Treatment_q_19_missing.dta", replace
	}
restore

*** additional dependencies questions *** 
*** question 10, for treatment arms A & C and question 9 is 1, response should be 1, 2, 3, 4, 5, 6, 7, 8, 9, 88 or 99  ***
preserve	

	keep if treatment_arms_survey == "A" | treatment_arms_survey == "C" 
	
	keep if q_09 == 1 
	
    gen ind_var = 0 
	replace ind_var = 1 if q_10 < 1 
	replace ind_var = 1 if q_10 > 9
	replace ind_var = 0 if q_10 == 88
	replace ind_var = 0 if q_10 == 99
	keep if ind_var == 1 
	
	keep village village_code sup_name date_visit q_10
  
    * Generate an "issue" variable
    generate issue = "Unreasonable value"
	
	* Generate name of variable issue 
	gen issue_variable_name = "q_10"
	
	* Rename variable with issue 
	rename q_10 print_issue
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$treatment\Issue_Treatment_q_10_unreasonable.dta", replace
	}
restore

*** question 10, for treatment arms A & C and question 9 is 0 or treatment arm B, response should be 1, 2, 3, 4, 5, 6, 7, 8, 9, 88 or 99  ***
preserve	

	keep if treatment_arms_survey == "A" | treatment_arms_survey == "C"  
	
	keep if q_09 == 0 
	
    gen ind_var = 0 
	replace ind_var = 1 if q_11 < 1 
	replace ind_var = 1 if q_11 > 9
	replace ind_var = 0 if q_11 == 88
	replace ind_var = 0 if q_11 == 99
	keep if ind_var == 1 
	
	keep village village_code sup_name date_visit q_11
  
    * Generate an "issue" variable
    generate issue = "Unreasonable value"
	
	* Generate name of variable issue 
	gen issue_variable_name = "q_11"
	
	* Rename variable with issue 
	rename q_11 print_issue
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$treatment\Issue_Treatment_q11_unreasonable.dta", replace
	}
restore

preserve	

	keep if treatment_arms_survey == "B"  
	
    gen ind_var = 0 
	replace ind_var = 1 if q_11 < 1 
	replace ind_var = 1 if q_11 > 9
	replace ind_var = 0 if q_11 == 88
	replace ind_var = 0 if q_11 == 99
	keep if ind_var == 1 
	
	keep village village_code sup_name date_visit q_11
  
    * Generate an "issue" variable
    generate issue = "Unreasonable value"
	
	* Generate name of variable issue 
	gen issue_variable_name = "q_11"
	
	* Rename variable with issue 
	rename q_11 print_issue
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$treatment\Issue_Treatment_q_11_b_unreasonable.dta", replace
	}
restore

*** import treatment comprehension data ***
*** update_visit with the correct file name ***
import delimited "$data\Questionnaire participant d’intervention - NSF DISES_WIDE_101124.csv", clear varnames(1) bindquote(strict)

*** Value Checks ***

*** village name missing *** 
preserve	

    keep if pull_village == "."
	
	keep pull_village pull_hhid_village pull_select_hhid today
  
    * Generate an "issue" variable
    generate issue = "Missing"
	
	* Generate name of variable issue 
	gen issue_variable_name = "pull_village"
	
	* Rename variable with issue 
	rename pull_village print_issue
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$treatment\Issue_Comprehension_pull_village.dta", replace
	}
restore

*** village ID missing *** 
preserve	

    keep if pull_select_hhid == "."
	
	keep pull_village pull_hhid_village pull_select_hhid today
  
    * Generate an "issue" variable
    generate issue = "Missing"
	
	* Generate name of variable issue 
	gen issue_variable_name = "pull_hhid_village"
	
	* Rename variable with issue 
	rename pull_hhid_village print_issue
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$treatment\Issue_Comprehension_pull_hhid_village.dta", replace
	}
restore

*** date_visit missing *** 
preserve	

    keep if today == "."
	
	keep pull_village pull_hhid_village pull_select_hhid today
  
    * Generate an "issue" variable
    generate issue = "Missing"
	
	* Generate name of variable issue 
	gen issue_variable_name = "today"
	
	* Rename variable with issue 
	rename today print_issue
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$treatment\Issue_Comprehension_date_visit.dta", replace
	}
restore

*** household ID missing *** 
preserve	

    keep if pull_select_hhid == " "
	 
	keep pull_village pull_hhid_village pull_select_hhid today
  
    * Generate an "issue" variable
    generate issue = "Missing"
	
	* Generate name of variable issue 
	gen issue_variable_name = "pull_select_hhid"
	
	* Rename variable with issue 
	rename pull_select_hhid print_issue
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$treatment\Issue_Comprehension_pull_select_hhid.dta", replace
	}
restore

*** question 1.1, response should be between 1 and 6 ***
preserve	

	keep if treatment_arms_survey == "A" | treatment_arms_survey == "C" 
	
	keep if question_11 < 1 | question_11 > 6
	
	keep pull_village pull_hhid_village pull_select_hhid today question_11
  
    * Generate an "issue" variable
    generate issue = "Unreasonable value"
	
	* Generate name of variable issue 
	gen issue_variable_name = "question_11"
	
	* Rename variable with issue 
	rename question_11 print_issue
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$treatment\Issue_Comprehension_q1_1_unreasonable.dta", replace
	}
restore

*** question 1.2, response should be between 1 and 6 ***
preserve	

	keep if treatment_arms_survey == "A" | treatment_arms_survey == "C" 
	
	keep if question_12 < 1 | question_12 > 6
	
	keep pull_village pull_hhid_village pull_select_hhid today question_12
  
    * Generate an "issue" variable
    generate issue = "Unreasonable value"
	
	* Generate name of variable issue 
	gen issue_variable_name = "question_12"
	
	* Rename variable with issue 
	rename question_12 print_issue
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$treatment\Issue_Comprehension_q1_2_unreasonable.dta", replace
	}
restore

*** question 1.3, response should be between 1 and 5 ***
preserve	

	keep if treatment_arms_survey == "A" | treatment_arms_survey == "C"  
	
	keep if question_13 < 1 | question_13 > 5
	
	keep pull_village pull_hhid_village pull_select_hhid today question_13
  
    * Generate an "issue" variable
    generate issue = "Unreasonable value"
	
	* Generate name of variable issue 
	gen issue_variable_name = "question_13"
	
	* Rename variable with issue 
	rename question_13 print_issue
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$treatment\Issue_Comprehension_q1_3_unreasonable.dta", replace
	}
restore

*** question 1.4, response should be between 1 and 5 ***
preserve	

	keep if treatment_arms_survey == "A" | treatment_arms_survey == "C" 
	
	keep if question_14 < 1 | question_14 > 5
	
	keep pull_village pull_hhid_village pull_select_hhid today question_14
  
    * Generate an "issue" variable
    generate issue = "Unreasonable value"
	
	* Generate name of variable issue 
	gen issue_variable_name = "question_14"
	
	* Rename variable with issue 
	rename question_14 print_issue
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$treatment\Issue_Comprehension_q1_4_unreasonable.dta", replace
	}
restore

*** question 2.1, response should be between 1 and 4 ***
preserve	

	keep if treatment_arms_survey == "B" | treatment_arms_survey == "C" 
	
	keep if question_21 < 1 | question_21 > 4
	
	keep pull_village pull_hhid_village pull_select_hhid today question_21
  
    * Generate an "issue" variable
    generate issue = "Unreasonable value"
	
	* Generate name of variable issue 
	gen issue_variable_name = "question_21"
	
	* Rename variable with issue 
	rename question_21 print_issue
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$treatment\Issue_Comprehension_q2_1_unreasonable.dta", replace
	}
restore

*** question 2.2, response should be between 1 and 5 ***
preserve	

	keep if treatment_arms_survey == "B" | treatment_arms_survey == "C" 
	
	keep if question_22 < 1 | question_22 > 5
	
	keep pull_village pull_hhid_village pull_select_hhid today question_22
  
    * Generate an "issue" variable
    generate issue = "Unreasonable value"
	
	* Generate name of variable issue 
	gen issue_variable_name = "question_22"
	
	* Rename variable with issue 
	rename question_22 print_issue
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$treatment\Issue_Comprehension_q2_2_unreasonable.dta", replace
	}
restore

*** question 2.3, response should be between 1 and 5 ***
preserve	

	keep if treatment_arms_survey == "B" | treatment_arms_survey == "C"  
	
	keep if question_23 < 1 | question_23 > 5
	
	keep pull_village pull_hhid_village pull_select_hhid today question_23
  
    * Generate an "issue" variable
    generate issue = "Unreasonable value"
	
	* Generate name of variable issue 
	gen issue_variable_name = "question_23"
	
	* Rename variable with issue 
	rename question_23 print_issue
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$treatment\Issue_Comprehension_q2_3_unreasonable.dta", replace
	}
restore

*** question 3.1, response should be between 1 and 5 ***
preserve	
	
	keep if question_31 < 1 | question_31 > 5
	
	keep pull_village pull_hhid_village pull_select_hhid today question_31
  
    * Generate an "issue" variable
    generate issue = "Unreasonable value"
	
	* Generate name of variable issue 
	gen issue_variable_name = "question_31"
	
	* Rename variable with issue 
	rename question_31 print_issue
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$treatment\Issue_Comprehension_q3_1_unreasonable.dta", replace
	}
restore

*** question 3.2, response should be between 1 and 5 ***
preserve	
	
	keep if question_32 < 1 | question_32 > 5
	
	keep pull_village pull_hhid_village pull_select_hhid today question_32
  
    * Generate an "issue" variable
    generate issue = "Unreasonable value"
	
	* Generate name of variable issue 
	gen issue_variable_name = "question_32"
	
	* Rename variable with issue 
	rename question_32 print_issue
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$treatment\Issue_Comprehension_q3_2_unreasonable.dta", replace
	}
restore

*** question 3.3, response should be between 1 and 5 ***
preserve	
	
	keep if question_34 < 1 | question_34 > 5
	
	keep pull_village pull_hhid_village pull_select_hhid today question_34
  
    * Generate an "issue" variable
    generate issue = "Unreasonable value"
	
	* Generate name of variable issue 
	gen issue_variable_name = "question_34"
	
	* Rename variable with issue 
	rename question_34 print_issue
  
    * Export the dataset to Excel
	if _N > 0 {
    save "$treatment\Issue_Comprehension_q3_3_unreasonable.dta", replace
	}
restore

**** create one output issue file ***

****************** LOOK IN FOLDER AND SEE WHICH OUTPUT ISSUE FILES THERE ARE *******
****************** INCLUDE ALL NEW FILES IN THE FOLDER BELOW *************

use "$treatment\Issue_Treatment_q_18_missing.dta", clear 
append using "$treatment\Issue_Treatment_q_19_missing.dta"
append using "$treatment\Issue_Comprehension_q1_3_unreasonable.dta"  

**************** UPdate_visit date_visit IN FILE NAME ***********************
export excel using "$issues\Treatment_Issues_11Oct24.xlsx", firstrow(variables) 

