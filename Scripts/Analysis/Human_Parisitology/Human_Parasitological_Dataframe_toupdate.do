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
global data "$master\Data_Management\Output\Data_Analysis\Parasitological_Analysis_Data\Analysis_Data"
*global output "$master\Data_Management\_Partner_CleanData\Parasitological_Analysis_Data\Analysis_Data"


*<><<><><>><><<><><>>
* LOAD IN DATA
*<><<><><>><><<><><>>

use "$data\base_child_infection_dataframe.dta", clear


*<><<><><>><><<><><>>
* BEGIN DATA CLEANING/PROCESSING
*<><<><><>><><<><><>>	


** drop unneeded vars 

drop epls_ucad_id epls_or_ucad data_source sex_hp age_hp

** keep only scored data 

keep if match_score != .



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


*********************************************** Calculate egg counts ***********************************************

	gen sh_egg_count = cond(fu_p1 > 0, fu_p1, fu_p2)

	gen p1_avg = (p1_kato1_k1_pg + p1_kato2_k2_peg) / 2
	gen p2_avg = (p2_kato1_k1_epg + p2_kato2_k2_epg) / 2

	gen sm_egg_count = cond(p1_avg > 0, p1_avg, p2_avg)

* Create total egg count
	gen total_egg = sm_egg_count + sh_egg_count


*********************************************** Scale water contact variable ****************************************************************

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


***************************************************************************************************************



save "${data}\child_infection_dataframe_analysis.dta", replace

































