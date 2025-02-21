*==============================================================================

* written by: Kateri Mouawad
* Created: February 2025
* Updates recorded in GitHub

*>>>>>>>>>>**--*--*--*--*--*--*--*--** READ ME **--*--*--*--*--*--*--*--**<<<<<<<<<<<*
		
clear all
set mem 100m
set maxvar 30000
set matsize 11000
set more off

**************************************************
* SET FILE PATHS
**************************************************


* Set base Box path for each user
if "`c(username)'"=="socrm" global master "C:\Users\socrm\Box"
if "`c(username)'"=="kls329" global master "C:\Users\kls329\Box"
if "`c(username)'"=="km978" global master "C:\Users\km978\Box\NSF Senegal"
if "`c(username)'"=="Kateri" global master "C:\Users\Kateri\Box\NSF Senegal"
if "`c(username)'"=="admmi" global master "C:\Users\admmi\Box\NSF Senegal"


* Define project-specific paths
global data "$master\Data_Management\Output\Data_Analysis\Parasitological_Analysis_Data\Analysis_Data"
*global output "$master\Data_Management\_Partner_CleanData\Parasitological_Analysis_Data\Analysis_Data"

use "$data\base_child_infection_dataframe.dta", clear

** drop unneeded vars 

drop epls_ucad_id epls_or_ucad data_source sex_hp age_hp

** keep only scored data 

keep if match_score != .

 
 *** create binaries ***
 

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

foreach var in health_5_5_ health_5_6_ health_5_7_ health_5_8_ health_5_9_ health_5_10_ {
    replace `var' = .a if `var' == 2
}


* Calculate egg counts

	gen sh_egg_count = cond(fu_p1 > 0, fu_p1, fu_p2)

	gen p1_avg = (p1_kato1_k1_pg + p1_kato2_k2_peg) / 2
	gen p2_avg = (p2_kato1_k1_epg + p2_kato2_k2_epg) / 2

	gen sm_egg_count = cond(p1_avg > 0, p1_avg, p2_avg)

* Create total egg count
	gen total_egg = sm_egg_count + sh_egg_count

* Scale water contact variable


* Replace "missed" with "0h00" to represent zero time
replace BegeningTimesampling = "0h00" if BegeningTimesampling == "missed"
replace Endsamplingtime = "0h00" if Endsamplingtime == "missed"

*  Remove the apostrophe at the end of the time strings
replace BegeningTimesampling = subinstr(BegeningTimesampling, "'", "", .)
replace Endsamplingtime = subinstr(Endsamplingtime, "'", "", .)

*  Remove any ":" that appears right after "h" for both variables
replace BegeningTimesampling = regexr(BegeningTimesampling, "h:", "h")
replace Endsamplingtime = regexr(Endsamplingtime, "h:", "h")

*  Replace "h" with ":" only if it exists and ":" is not already present for both variables
replace BegeningTimesampling = subinstr(BegeningTimesampling, "h", ":", .) if strpos(BegeningTimesampling, "h") > 0 & strpos(BegeningTimesampling, ":") == 0

replace Endsamplingtime = subinstr(Endsamplingtime, "h", ":", .) if strpos(Endsamplingtime, "h") > 0 & strpos(Endsamplingtime, ":") == 0







replace BegeningTimesampling = trim(BegeningTimesampling)
replace Endsamplingtime = trim(Endsamplingtime)

gen double BegeningTimesampling_time = clock(BegeningTimesampling, "HH:MM")
gen double Endsamplingtime_time = clock(Endsamplingtime, "HH:MM")













/*

* Replace "h" with ":" to match Stata's time format
	gen BegeningTimesampling_str = subinstr(BegeningTimesampling, "h", ":", .)
	gen Endsamplingtime_str = subinstr(Endsamplingtime, "h", ":", .)

* Convert to Stata time format
gen double BegeningTimesampling_time = clock(BegeningTimesampling_str, "HH:MM")
gen double Endsamplingtime_time = clock(Endsamplingtime_str, "HH:MM")

* Calculate total time in minutes
gen total_time = (Endsamplingtime_time - BegeningTimesampling_time) / 60000  // Convert milliseconds to minutes

* Handle missing values
replace total_time = 0 if missing(total_time)

* Ensure Humanwatercontact is numeric
destring Humanwatercontact, replace force

* Create scaled variable
gen scaled = Humanwatercontact / total_time

* Handle missing values in scaled variable
replace scaled = 0 if missing(scaled)
*/











