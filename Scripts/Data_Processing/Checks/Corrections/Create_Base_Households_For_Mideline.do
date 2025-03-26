*** DISES data create long and wide data for midline survey *** 
*** File Created By: Molly Doruska ***
*** File Last Updated By: Molly Doruska ***
*** File Last Updated On: November 19, 2024 ***

 * READ ME: This .Do file uses the INDIVIDUAL ID file to create a listing of people and households to survey again for the midline survey.
 
 **PROCEDURE:
		* (1) Import complete Individual IDs from Baseline. 
		* (2) keep RELEVENT variabels for midline survey. 
		* (3) Reshape data from long to wide to create baseline ID dataset with individual IDs  

  *** This Do File PROCESSES: ** All_Villages_With_Individual_IDs.dta 

  *** This Do File CREATES: 
							  ** Households_For_Midline_Long.dta
							  ** Households_For_Midline_Wide.dta
				   
 ** UPDATE NOTES:

clear all 

set maxvar 20000

**** Master file path  ****

if "`c(username)'"=="socrm" {
                global master "C:\Users\socrm\Box\NSF Senegal\Data Management"
}
else if "`c(username)'"=="km978" {
                global master "C:\Users\km978\Box\NSF Senegal\Data Management"
				
}

*** additional file paths ***
global data "$master\_CRDES_CleanData\Baseline\Identified"


*** import all data *** 
use "$data\DISES_Baseline_Complete_PII.dta", clear 

*** keep gps data to merge into wide and long formats for midline *** 
keep hhid gpd_datalatitude gpd_datalongitude gpd_dataaccuracy 

save "$data\DISES_Baseline_HH_Locations.dta", replace 

*** import individual IDs *** 
use "$data\All_Villages_With_Individual_IDs.dta", clear 

*** keep hhid, name information and name and age, gender of each individual *** 
keep hhid_village hhid hh_phone hh_head_name_complet hh_name_complet_resp hh_age_resp hh_gender_resp hh_full_name_calc_ hh_gender_ hh_age_ individual individ

*** reorder variables so all IDs are at the beginning *** 
order hhid_village hhid individ, first 

*** merge in location data *** 
merge m:1 hhid using "$data\DISES_Baseline_HH_Locations"

drop _merge 

*** save long data *** 
save "$data\Households_For_Midline_Long.dta" 

export excel "$data\Households_For_Midline_Long.xlsx", firstrow(variables)

*** reshape to wide data *** 
reshape wide hh_full_name_calc_ hh_gender_ hh_age_ individ, i(hhid_village hhid hh_head_name_complet hh_name_complet_resp hh_age_resp hh_gender_resp hh_phone gpd_datalatitude gpd_datalongitude gpd_dataaccuracy) j(individual)

*** save wide data *** 
save "$data\Households_For_Midline_Wide.dta" 

export excel "$data\Households_For_Midline_Wide.xlsx", firstrow(variables)
