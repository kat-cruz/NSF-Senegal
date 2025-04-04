*==============================================================================

* written by: Kateri Mouawad
* Created: February 2025
* Updates recorded in GitHub


* <><<><><>> Read Me  <><<><><>>


*<><<><><>><><<><><>>
* INITIATE SCRIPT
*<><<><><>><><<><><>>
		
clear all
set mem 100m
set maxvar 30000
set matsize 11000
set more off

*<><<><><>><><<><><>>
* SET FILE PATHS
*<><<><><>><><<><><>>

*^*^* Set base Box path for each user
if "`c(username)'"=="socrm" global master "C:\Users\socrm\Box\NSF Senegal"
if "`c(username)'"=="kls329" global master "C:\Users\kls329\Box\NSF Senegal"
if "`c(username)'"=="km978" global master "C:\Users\km978\Box\NSF Senegal"
if "`c(username)'"=="Kateri" global master "C:\Users\Kateri\Box\NSF Senegal"
if "`c(username)'"=="admmi" global master "C:\Users\admmi\Box\NSF Senegal"


*^*^* Define project-specific paths
global data "$master\Data_Management\Output\Analysis\Parasitological_Analysis_Data\Analysis_Data"
global crdes_data "${master}\Data_Management\Data\_CRDES_CleanData"
global eco_data "${master}\Data_Management\Data\_Partner_RawData\Ecological_Data\Baseline"
global output "${master}\Data_Management\Output\Analysis\Parasitological_Analysis_Data\Analysis_Data"

*global output "$master\Data_Management\_Partner_CleanData\Parasitological_Analysis_Data\Analysis_Data"


*<><<><><>><><<><><>>
* LOAD IN DATA
*<><<><><>><><<><><>>

use "$data\01_prepped_inf_matches_df.dta", clear


*<><<><><>><><<><><>>	
* BEGIN DATA CLEANING/PROCESSING
*<><<><><>><><<><><>>	

*^*^* Load and prep data

	use "${crdes_data}\Baseline\Deidentified\Complete_Baseline_Health.dta", clear // health data 

	merge 1:1 hhid using "${crdes_data}\Baseline\Deidentified\Complete_Baseline_Household_Roster.dta" // hh roster data
		drop _merge

	merge 1:1 hhid using "${crdes_data}\Baseline\Deidentified\Complete_Baseline_Standard_Of_Living.dta" // standard of living data
		drop _merge 

	merge 1:1 hhid using "${crdes_data}\Baseline\Deidentified\Complete_Baseline_Agriculture.dta" // ag data
		drop _merge
	 
	merge m:1 hhid_village using "${crdes_data}\Baseline\Deidentified\Complete_Baseline_Community.dta" // community data
		drop _merge 

	merge m:1 hhid_village using "${eco_data}\DISES_baseline_ecological data.dta" // ecological data 
		drop _merge 


	keep hhid hh_age* hh_gender*  ///
		hh_26* ///
		living_01  ///
		health_5_3_* health_5_5* health_5_9* ///
		q_23 q_24
		Cerratophyllummassg Bulinus Biomph Humanwatercontact Schistoinfection InfectedBulinus  InfectedBiomphalaria schisto_indicator 

*^*^* keep only scored data 

	keep if match_score != .
	 
*drop strings 
drop hh_12_o* hh_12_a* hh_12_ro* hh_12_cal* hh_13_o* hh_13_s* hh_19_o* hh_ethnicity_o* hh_29_o* list_actifs_o 

foreach i of numlist 1/55 {
    drop hh_12_`i'
}


* Reshape long with hhid and id
forval i = 1/7 {
    * Loop over the second index (1 to 55)
    forval j = 1/55 {
        * Construct the old and new variable names
        local oldname = "hh_13_`j'_`i'"
        local newname = "hh_13_`i'_`j'"
        
        * Rename if the old variable exists
        cap rename `oldname' `newname'
    }
}




*variables removed: hh_age hh_gender living_01 living_02 living_03 living_04

* Reshape long with hhid and id
	reshape long health_5_3_2_ health_5_4_ health_5_5_ health_5_6_  health_5_8_ health_5_9_ health_5_10_ hh_ethnicity_  hh_10_  ///
	hh_12index_1_ hh_12index_2_ hh_12index_3_ hh_12index_4_ hh_12index_5_ hh_12index_6_ hh_12index_7_ hh_12_1_ hh_12_2_ hh_12_3_ hh_12_4_ hh_12_5_ hh_12_6_ hh_12_7_ hh_12_8_ ///
	hh_13_1_ hh_13_2_ hh_13_3_ hh_13_4_ hh_13_5_ hh_13_6_ hh_13_7_ hh_18_ hh_19_ hh_22_ hh_26_ hh_29_ hh_30_ hh_31_ hh_32_ hh_33_ hh_37_ hh_age_ hh_gender_, ///
		i(hhid) j(id)
	
	 
** filter hh_13 **

forvalues j = 1/8 {
    gen hh_13_0`j' = .
    forvalues i = 1/7 {
        replace hh_13_0`j' = hh_13_`i'_ if hh_12index_`i' == `j'
    }
}


drop hh_13_7_ hh_13_6_ hh_13_5_ hh_13_4_ hh_13_3_ hh_13_2_ hh_13_1_ 
drop hh_12index_7_ hh_12index_6_ hh_12index_5_ hh_12index_4_ hh_12index_3_ hh_12index_2_ hh_12index_1_



* Create matching individual_id_crdes
	tostring hhid, replace format("%12.0f")
	tostring id, gen(str_id) format("%02.0f")
	gen str individual_id_crdes = hhid + str_id
	format individual_id_crdes %15s

* Create wealth index variable 
	gen wealthindex=list_actifscount/16

* **Keep only individual_id_crdes and variables of interest to avoid conflicts**
keep individual_id_crdes  hh_ethnicity_ hh_age_ hh_gender_ hh_age_resp ///
		health_5_3_2_ health_5_4_ health_5_5_ health_5_6_ health_5_8_ health_5_9_ health_5_10_ ///
		hh_10_ hh_12_* hh_13_0* hh_18_ hh_19_ hh_22_ hh_26_ hh_29_ hh_30_ hh_31_ hh_32_ hh_33_ hh_37_ ///
		living_01 living_02 living_03 living_04 ///
		wealthindex list_actifscount list_actifs ///
		q_18 q_19 q_23 q_24 q_35_check q_39 q_49 q_46 q_51 ///
		Cerratophyllummassg Bulinus Biomph Humanwatercontact BegeningTimesampling Endsamplingtime Schistoinfection InfectedBulinus InfectedBiomphalaria schisto_indicator 

* Save temp health data
*save "${dataframe}\temp_health_reshaped.dta", replace

* KRM - new df w/ the other features 
save "${output}\temp_features_reshaped.dta", replace

* Load main dataset 
use "${output}\child_infection_dataframe.dta", clear

* Merge health variables where individual_id_crdes matches
merge m:1 individual_id_crdes using "${output}\temp_features_reshaped.dta", ///
    keep(master match) ///
    nogenerate

sort village_id individual_id_crdes

***  covert variables from string to numeric *** 
		* written by MJD *
		destring fu_p1 fu_p2 p1_kato1_k1_pg p1_kato2_k2_peg p2_kato1_k1_epg p2_kato2_k2_epg, replace force 

		*** count infection of s. haematobium *** 
		gen sh_inf = 0 
		replace sh_inf = 1 if fu_p1 > 0 & fu_p1 != .
		replace sh_inf = 1 if fu_p2 > 0 & fu_p2 != . 

		gen sm_inf = 0 
		replace sm_inf = 1 if p1_kato1_k1_pg > 0 & p1_kato1_k1_pg != . 
		replace sm_inf = 1 if p1_kato2_k2_peg > 0 & p1_kato2_k2_peg != . 
		replace sm_inf = 1 if p2_kato1_k1_epg > 0 & p2_kato1_k1_epg != . 
		replace sm_inf = 1 if p2_kato2_k2_epg > 0 & p2_kato2_k2_epg != . 

		*** summarize infection results by village *** 
		bysort village_id: sum sh_inf sm_inf
		  
		*** summarize infection results overall ***
		sum sh_inf sm_inf  
*********************************************************

drop Notes sex_crdes 


order   village_id village_name individual_id_crdes hhid_crdes epls_ucad_id match_score age_crdes epls_or_ucad data_source ///
		sex_hp age_hp hh_age_resp  hh_age_ hh_gender_ hh_ethnicity_  ///
		health_5_3_2_ health_5_4_ health_5_5_ health_5_6_ health_5_8_ health_5_9_ health_5_10_  ///
		hh_10_ hh_12_* hh_13_0* hh_18_ hh_19_ hh_22_ hh_26_ hh_29_ hh_30_ hh_31_ hh_32_ hh_33_ hh_37_  ///
		living_01 living_02 living_03 living_04 ///
		list_actifs list_actifscount wealthindex  ///
		q_18 q_19 q_23 q_24 q_35_check q_39 q_49 q_46 q_51 ///
		schisto_indicator fu_p1 fu_p2 omega_vivant_1 sm_fu_1 fu_p2 omega_vivant_2 sm_fu_2 p1_kato1_omega p1_kato1_k1_pg pq_kato2_omega p1_kato2_k2_peg sh_kk_1 p2_kato1_omega p2_kato1_k1_epg p2_kato2_omega p2_kato2_k2_epg sh_kk_2 sh_inf sm_inf pzq_1 		pzq_2 ///
	    Cerratophyllummassg Bulinus Biomph Humanwatercontact BegeningTimesampling Endsamplingtime Schistoinfection InfectedBulinus InfectedBiomphalaria


* Save the final dataset

save "${output}\base_child_infection_dataframe.dta", replace

























	* Creating binary variables for hh_29
	foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 99 {
		gen hh_29_`x' = hh_29_ == `x'
		replace hh_29_`x' = 0 if missing(hh_29_)
	}

	* Creating binary variables for living_01
	foreach x in 1 2 3 4 5 6 7 8 9 10 99 {
		gen living_01_`x' = living_01 == `x'
		replace living_01_`x' = 0 if missing(living_01)
	}

	* Creating binary variables for living_03

	foreach x in 1 2 3 99 {
		gen living_03_`x' = living_03 == `x'
		replace living_03_`x' = 0 if missing(living_03)
	}

	* Creating binary variables for living_04
	foreach x in 1 2 3 4 5 6 7 99 {
		gen living_04_`x' = living_04 == `x'
		replace living_04_`x' = 0 if missing(living_04)
	}


** replace 2s for hh_03 health_5_2 health_5_5 health_5_6 health_5_7 as missings 

	foreach var in health_5_5_ health_5_6_ health_5_8_ health_5_9_ health_5_10_ {
		replace `var' = .a if `var' == 2
	}


*<><<><><>><><<><><>> 
* Calculate egg counts
*<><<><><>><><<><><>>	

	gen sh_egg_count = cond(fu_p1 > 0, fu_p1, fu_p2)

	gen p1_avg = (p1_kato1_k1_pg + p1_kato2_k2_peg) / 2
	gen p2_avg = (p2_kato1_k1_epg + p2_kato2_k2_epg) / 2

	gen sm_egg_count = cond(p1_avg > 0, p1_avg, p2_avg)

* Create total egg count
	gen total_egg = sm_egg_count + sh_egg_count


*<><<><><>><><<><><>>	
* Scale water contact variable 
*<><<><><>><><<><><>>	
/*

	* Create new variables to preserve original data
	gen BegeningTimesampling_clean = BegeningTimesampling
	gen Endsamplingtime_clean = Endsamplingtime

	* Replace "missed" with "0h00" to represent zero time
	/*
	replace BegeningTimesampling_clean = "0h00" if BegeningTimesampling_clean == "missed"
	replace Endsamplingtime_clean = "0h00" if Endsamplingtime_clean == "missed"
	*/

	* Remove the apostrophe at the end of the time strings
	replace BegeningTimesampling_clean = subinstr(BegeningTimesampling_clean, "'", "", .)
	replace Endsamplingtime_clean = subinstr(Endsamplingtime_clean, "'", "", .)

	* Remove any ":" that appears right after "h" for both variables
	replace BegeningTimesampling_clean = regexr(BegeningTimesampling_clean, "h:", "h")
	replace Endsamplingtime_clean = regexr(Endsamplingtime_clean, "h:", "h")

	* Replace "h" with ":" only if "h" exists and ":" is not already present
	replace BegeningTimesampling_clean = subinstr(BegeningTimesampling_clean, "h", ":", .) if strpos(BegeningTimesampling_clean, "h") > 0 & strpos(BegeningTimesampling_clean, ":") == 0
	replace Endsamplingtime_clean = subinstr(Endsamplingtime_clean, "h", ":", .) if strpos(Endsamplingtime_clean, "h") > 0 & strpos(Endsamplingtime_clean, ":") == 0


	replace BegeningTimesampling_clean = trim(BegeningTimesampling_clean)
	replace Endsamplingtime_clean = trim(Endsamplingtime_clean)

	gen double BegeningTimesampling_time = clock(BegeningTimesampling_clean, "hm")
	format BegeningTimesampling_time %tc

	gen double Endsamplingtime_time = clock(Endsamplingtime_clean, "hm")
	format Endsamplingtime_time %tc

	* Convert datetime to total minutes since midnight
	gen BegeningTimesampling_minutes = hh(BegeningTimesampling_time) * 60 + mm(BegeningTimesampling_time)
	gen Endsamplingtime_minutes = hh(Endsamplingtime_time) * 60 + mm(Endsamplingtime_time)

	* Compute total time difference in minutes
	gen total_time = abs(Endsamplingtime_minutes - BegeningTimesampling_minutes)
		
	* Create the scaled variable
	destring Humanwatercontact, replace 
	gen scaled = Humanwatercontact / total_time

	* Replace missing values in total_time with 0
	replace total_time = 0 if missing(total_time)

	* Replace missing values in scaled with 0
	replace scaled = 0 if missing(scaled)

	replace total_time = abs(Endsamplingtime_minutes - BegeningTimesampling_minutes) if !missing(Endsamplingtime_minutes)


	replace total_time = . if missing(Endsamplingtime_minutes)

	drop BegeningTimesampling_time Endsamplingtime_time

*/

*<><<><><>><><<><><>>	



save "${data}\child_infection_dataframe_analysis.dta", replace

































