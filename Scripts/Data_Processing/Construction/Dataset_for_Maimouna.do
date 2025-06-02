*** Subset data for Maimouna Bobacar Salou *** 
*** File Created By: Molly Doruska ***
*** File Last Updated By: Molly Doruska ***
*** File Last Updated On: June 2, 2025 ***

clear all 

set maxvar 20000

**** Master file path  ****
if "`c(username)'"=="mollydoruska" {
                global master "/Users/mollydoruska/Library/CloudStorage/Box-Box/NSF Senegal/Data_Management"
}
else if "`c(username)'"=="kls329" {
                global master "/Users/kls329\Box\NSF Senegal\Data_Management"
}
else if "`c(username)'"=="km978" {
                global master "C:\Users\km978\Box\NSF Senegal\Data_Management"
}
else if "`c(username)'"=="Kateri" {
                global master "C:\Users\Kateri\Box\NSF Senegal\Data_Management"
}

*** additional file paths ***
global data "$master/Data/_CRDES_CleanData/Baseline/Deidentified"
global midlinedata "$master/Data/_CRDES_CleanData/Midline/Deidentified"
global maimouna "$master/External_Sharing/Maimouna"

*** subset data for Maimouna's analysis *** 
*** baseline data *** 

*** import geography data *** 
use "$data/Complete_Baseline_Geographies.dta", clear 

keep hhid region 

replace region = "SAINT LOUIS" if region == ""

tempfile baselinegeo
save `baselinegeo'

*** import household roster data *** 
use "$data/Complete_Baseline_Household_Roster.dta", clear 

keep hhid hhid_village hh_gender_* hh_age* hh_education_skills_5* hh_education_level_* hh_education_year_achieve_* hh_main_activity_* hh_12_1_* hh_12_2_* hh_12_3_* hh_12_4_* hh_12_5_* hh_12_6_* hh_12_7_* hh_12_8_* hh_12_a_* hh_12_o_* hh_15_* hh_16_* hh_17_* hh_23_1_* hh_23_2_* hh_23_3_* hh_23_4_* hh_23_5_* hh_23_99_* 
drop hh_education_level_o_* hh_15_o_* 

tempfile baselinehh 
save `baselinehh'

*** import knowledge data *** 
use "$data/Complete_Baseline_Knowledge.dta", clear 

keep hhid knowledge_23_* 

tempfile baselineknow
save `baselineknow'

*** import agriculture data *** 
use "$data/Complete_Baseline_Agriculture.dta", clear 

keep hhid list_agri_equip_* agriindex_* agriname_* _agri_number_* agri_6_10 agri_6_11 agri_6_12_* agri_6_26* agri_6_27_1 agri_6_27_2 agri_6_27_3 agri_6_27_4 agri_6_27_5 agri_6_27_6 agri_6_27_7 agri_6_27_8 agri_6_27_9 agri_6_27_10 agri_6_27_11 

drop agri_6_26_o_* 

tempfile baselineag 
save `baselineag'

*** import income data ***
use "$data/Complete_Baseline_Income.dta", clear  

keep hhid agri_income_05 agri_income_06 product_divers_* agri_income_45_* agri_income_46_1_* agri_income_46_2_* agri_income_46_3_* agri_income_46_4_* agri_income_46_o_* 

tempfile baselineincome 
save `baselineincome'

*** import production data *** 
use "$data/Complete_Baseline_Production.dta", clear  

keep hhid cereals_01_1 cereals_01_2 cereals_01_3 cereals_01_4 aquatique_01_1 aquatique_02_1 aquatique_03_1 aquatique_04_1

tempfile baselineprod 
save `baselineprod'

*** import beliefs data *** 
use "$data/Complete_Baseline_Beliefs.dta", clear 

keep hhid beliefs_05 beliefs_06

*** merge baseline datafiles together *** 
merge 1:1 hhid using `baselinegeo'

drop _merge 

merge 1:1 hhid using `baselinehh'

drop _merge 

merge 1:1 hhid using `baselineknow'

drop _merge 

merge 1:1 hhid using `baselineag'

drop _merge 

merge 1:1 hhid using `baselineincome'

drop _merge 

merge 1:1 hhid using `baselineprod'

drop _merge 

merge 1:1 hhid using "$data/household_head_index.dta" 

drop _merge 

gen round = 1 

keep if region == "SAINT LOUIS" | region == "SAINT-LOUIS" | region == "Saint-Louis"

tempfile maimounabaseline
save `maimounabaseline'

*** import geography data *** 
use "$midlinedata/Complete_Midline_Geographies.dta", clear 

keep hhid region 

tempfile midlinegeo
save `midlinegeo'

*** import household roster data *** 
use "$midlinedata/Complete_Midline_Household_Roster.dta", clear 

keep hhid hhid_village hh_gender_* hh_age* hh_relation_with_* hh_education_skills_5* hh_education_level_* hh_education_year_achieve_* hh_main_activity_* hh_12_1_* hh_12_2_* hh_12_3_* hh_12_4_* hh_12_5_* hh_12_6_* hh_12_7_* hh_12_8_* hh_12_a_* hh_12_o_* hh_15_* hh_16_* hh_17_* hh_23_1_* hh_23_2_* hh_23_3_* hh_23_4_* hh_23_5_* hh_23_99_* 
drop hh_education_level_o_* hh_15_o_* 

tempfile midlinehh 
save `midlinehh'

*** import knowledge data *** 
use "$midlinedata/Complete_Midline_Knowledge.dta", clear 

keep hhid knowledge_23_* 

tempfile midlineknow
save `midlineknow'

*** import agriculture data *** 
use "$midlinedata/Complete_Midline_Agriculture.dta", clear 

keep hhid list_agri_equip_* agriindex_* agriname_* _agri_number_* agri_6_10 agri_6_11 agri_6_12_* agri_6_26* agri_6_27_1 agri_6_27_2 agri_6_27_3 agri_6_27_4 agri_6_27_5 agri_6_27_6 agri_6_27_7 agri_6_27_8 agri_6_27_9

drop agri_6_26_o_* 
tempfile midlineag 
save `midlineag'

*** import income data ***
use "$midlinedata/Complete_Midline_Income.dta", clear  

keep hhid agri_income_05 agri_income_06 product_divers_* agri_income_45_* agri_income_46_1_* agri_income_46_2_* agri_income_46_3_* agri_income_46_4_* agri_income_46_o_* 

tempfile midlineincome 
save `midlineincome'

*** import production data *** 
use "$midlinedata/Complete_Midline_Production.dta", clear  

keep hhid cereals_01_1 cereals_01_2 cereals_01_3 cereals_01_4 aquatique_01_1 aquatique_02_1 aquatique_03_1 aquatique_04_1

tempfile midlineprod 
save `midlineprod'

*** import beliefs data *** 
use "$midlinedata/Complete_Midline_Beliefs.dta", clear 

keep hhid beliefs_05 beliefs_06

*** merge midline datafiles together *** 
merge 1:1 hhid using `midlinegeo'

drop _merge 

merge 1:1 hhid using `midlinehh'

drop _merge 

merge 1:1 hhid using `midlineknow'

drop _merge 

merge 1:1 hhid using `midlineag'

drop _merge 

merge 1:1 hhid using `midlineincome'

drop _merge 

merge 1:1 hhid using `midlineprod'

drop _merge 

gen round = 2

keep if region == "SAINT LOUIS" | region == "SAINT-LOUIS" | region == "Saint-Louis"

*** append baseline and midline data ** 

append using `maimounabaseline', force

*** reorder variables *** 
order hhid region hhid_village hh_* knowledge_* list_agri_equip* agri_* product_divers* cereals* aquatique* , first 

*** save dataset *** 
save "$maimouna/dises_data_for_maimouna.dta", replace 

export delimited using "$maimouna/dises_data_for_maimouna.csv", replace 
