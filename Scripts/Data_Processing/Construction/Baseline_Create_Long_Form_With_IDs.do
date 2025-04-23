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

	
	*** additional file paths ***
	global data "$master\Data_Management\Output\Data_Processing\Checks\Corrections\Baseline"
	global data_raw "$master\Data_Management\Data\_CRDES_RawData\Baseline"
	global hhids "$master\Data_Management\Output\Data_Processing\ID_Creation\Baseline"
	global data_deidentified "$master\Data_Management\Data\_CRDES_CleanData\Baseline\Deidentified"
	global data_identified "$master\Data_Management\Data\_CRDES_CleanData\Baseline\Identified"

	*** import complete data for geographic and preliminary information ***
	use "$data\DISES_Baseline_Household_Corrected_PII", clear 
	
	****update this data bc u need the hhids bruh
	
	
// Loop through all variables in the dataset
ds, has(type numeric)  // You can drop "has(type numeric)" if you want to check all vars
foreach var of varlist `r(varlist)' {
    
    // Only proceed if the variable matches the pattern hh_#_#_#
    if regexm("`var'", "^hh_[0-9]+_[0-9]+_[0-9]+$") {
        
        // Extract the i and j using regular expressions
        local i = regexs(2)
        local j = regexs(3)

        // Extract i and j using capture to avoid errors
        if regexm("`var'", "^hh_([0-9]+)_([0-9]+)_([0-9]+)$") {
            local i = real(regexs(2))
            local j = real(regexs(3))
            
            // Check if middle number is greater than last number
            if `i' > `j' {
                di as error "⚠️ Possibly misordered: `var'"
            }
        }
    }
}


























