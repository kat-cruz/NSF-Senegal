*==============================================================================
* Program: Analyse "Other" options in Midline data 
* ==============================================================================
* written by: Kateri MOuawad
* Created: May 2025
* Updates recorded in GitHub 


* <><<><><>> Read Me  <><<><><>>

			** This file processes: 

			**	             		
	
			** This .do file outputs:

			**	            	
			
	** PROCEDURE:
	
	** 1) 
	
	
*-----------------------------------------*
**# INITIATE SCRIPT
*-----------------------------------------*

	clear all
		set mem 100m
		set maxvar 30000
		set matsize 11000
	set more off

*-----------------------------------------*
**# SET FILE PATHS
*-----------------------------------------*
*^*^* Set base Box path for each user

	if "`c(username)'"=="socrm" global master "C:\Users\socrm\Box"
	if "`c(username)'"=="kls329" global master "C:\Users\kls329\Box"
	if "`c(username)'"=="km978" global master "C:\Users\km978\Box\NSF Senegal"
	if "`c(username)'"=="Kateri" global master "C:\Users\Kateri\Box\NSF Senegal"
	if "`c(username)'"=="admmi" global master "C:\Users\admmi\Box"
	
	global midline "$master\Data_Management\Data\_CRDES_CleanData\Midline\Deidentified"

*^*^* Define project-specific paths

	global midline_agriculture "$midline\Complete_Midline_Agriculture.dta"
	global midline_beliefs "$midline\Complete_Midline_Beliefs.dta"
	global midline_community "$midline\Complete_Midline_Community.dta"
	global midline_enumerator "$midline\Complete_Midline_Enumerator_Observations.dta"
	global midline_geographies "$midline\Complete_Midline_Geographies.dta"
	global midline_health "$midline\Complete_Midline_Health.dta"
	global midline_household "$midline\Complete_Midline_Household_Roster.dta"
	global midline_income "$midline\Complete_Midline_Income.dta"
	global midline_knowledge "$midline\Complete_Midline_Knowledge.dta"
	global midline_lean "$midline\Complete_Midline_Lean_Season.dta"
	global midline_production "$midline\Complete_Midline_Production.dta"
	global midline_standard "$midline\Complete_Midline_Standard_Of_Living.dta"
	global midline_community "$midline\Complete_Midline_Community.dta"
	
	global out "$master\Data_Management\Documentation\Survey_Responses\Midline"

		
*<><<><><>><><<><><>>
**# BEGIN SCRIPT
*<><<><><>><><<><><>>

*-------------------*
**### Household Roster
*-------------------* 
	
	use "$midline_household", clear 
	
** 	keep variables that were listed to have a percentage of 5%> of "other" response
	
	keep hhid hh_29* hh_46* still_member_whynot* hh_main_activity* hh_relation_with_o*
	
	tostring hh_29_o* hh_46_o* still_member_whynot_o* hh_main_activity_o* hh_relation_with_o*, replace 
	
	reshape long hh_29_ hh_29_o_ hh_46_ hh_46_o_  /// 
	hh_main_activity_ hh_main_activity_o_ ///
	still_member_whynot_ still_member_whynot_o_ hh_relation_with_o_, ///
	i(hhid) j(id)
	
		preserve

		foreach var of varlist hh_29_ hh_46_ hh_main_activity_ still_member_whynot_ {
			
			keep hhid `var' `var'o_
			
			// Drop if the string variable is empty
			drop if `var'o_ == ""
			drop if `var'o_ == "."
			
			// Export to Excel
			export excel using "$out/`var'o_.xlsx", firstrow(variables) replace

			restore
			preserve
		}

		restore
		
		
		

	
*-------------------*
**### Knowledge
*-------------------* 
 
	use "$midline_knowledge", clear 
	
	keep hhid knowledge_09_99  knowledge_09_o knowledge_23 knowledge_23_o ///
	knowledge_20 knowledge_20_o ///
	knowledge_19 knowledge_19_o ///
	
		preserve

		foreach var of varlist knowledge_23 knowledge_20 knowledge_19 {
			
			keep hhid `var' `var'_o
			
			// Drop if the string variable is empty
			drop if `var'_o == ""
			drop if `var'_o == "."
			
			// Export to Excel
			export excel using "$out/`var'_o.xlsx", firstrow(variables) replace

			restore
			preserve
		}

		restore
		
		
	
*-------------------*
**### Health
*-------------------* 
   

		
use "$midline_health", clear 
	
** 	keep variables that were listed to have a percentage of 5%> of "other" response
	
	keep hhid health_5_3* health_5_3_o* 
	
	tostring health_5_3* health_5_3_o*, replace 
	
	reshape long health_5_3_ health_5_3_o_, ///
	i(hhid) j(id)
	
		preserve

		foreach var of varlist health_5_3_ {
			
			keep hhid `var' `var'o_
			
			// Drop if the string variable is empty
			drop if `var'o_ == ""
			drop if `var'o_ == "."
			
			// Export to Excel
			export excel using "$out/`var'o_.xlsx", firstrow(variables) replace

			restore
			preserve
		}

		restore
		
*-------------------*
**### Living
*-------------------* 
 
	use "$midline_standard", clear 
	
	keep hhid living_03  living_03_o
	
		preserve

		foreach var of varlist living_03 {
			
			keep hhid `var' `var'_o
			
			// Drop if the string variable is empty
			drop if `var'_o == ""
			drop if `var'_o == "."
			
			// Export to Excel
			export excel using "$out/`var'_o.xlsx", firstrow(variables) replace

			restore
			preserve
		}

		restore
				
		
		
		
		
*-------------------*
**### Enumerator
*-------------------* 
 
	use "$midline_enumerator", clear 
	
	keep hhid enum_04  enum_04_o
	
		preserve

		foreach var of varlist enum_04 {
			
			keep hhid `var' `var'_o
			
			// Drop if the string variable is empty
			drop if `var'_o == ""
			drop if `var'_o == "."
			
			// Export to Excel
			export excel using "$out/`var'_o.xlsx", firstrow(variables) replace

			restore
			preserve
		}

		restore
				
		
				
*-------------------*
**### Agriculture 
*-------------------* 
 
	use "$midline_agriculture", clear 
	
	keep hhid list_agri_equip_o  list_agri_equip_o_t  list_actifs_o actifs_o agri_6_20_o* agri_6_20* 
	
		preserve

			keep hhid list_agri_equip_o  list_agri_equip_o_t
			
			// Export to Excel
			export excel using "$out/list_agri_equip_o_t.xlsx", firstrow(variables) replace

			restore
			
			
		preserve

			keep hhid list_actifs_o actifs_o
			
			// Export to Excel
			export excel using "$out/actifs_o.xlsx", firstrow(variables) replace

		restore

		preserve

		keep hhid agri_6_20_o* agri_6_20*
			tostring agri_6_20_o*, replace 
			reshape long agri_6_20_o_ agri_6_20_, i(hhid) j(id)
			
			// Export to Excel
			export excel using "$out/agri_6_20_o_.xlsx", firstrow(variables) replace

		restore
		
		
		
		
*-------------------*
**### Income 
*-------------------* 
 
	use "$midline_income", clear 
	
	keep hhid expenses_goods_o expenses_goods_t
	
			export excel using "$out/expenses_goods_o.xlsx", firstrow(variables) replace

		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		