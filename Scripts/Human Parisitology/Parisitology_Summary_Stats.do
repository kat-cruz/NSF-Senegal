*** Count infection rates at village level for children *** 
*** Created by Molly Doruska ***
*** Last updated by Molly Doruska ***
*** Last updated on November 5, 2024 *** 


**************************************************
* SET FILE PATHS
**************************************************
disp "`c(username)'"

if "`c(username)'"=="socrm" global path "C:\Users\socrm\Box\NSF Senegal\Data Management\_PartnerData\Child infection dataframe"

if "`c(username)'"=="kls329" global path "C:\Users\kls329\Box\Data Management\_PartnerData\Child infection dataframe"

if "`c(username)'"=="km978" global path "C:\Users\km978\Box\NSF Senegal\Data Management\_PartnerData\Child infection dataframe"

if "`c(username)'"=="Kateri" global path "C:\Users\Kateri\Box\NSF Senegal\Data Management\_PartnerData\Child infection dataframe"

if "`c(username)'"=="admmi" global path "C:\Users\admmi\Box\Data Management\_PartnerData\Child infection dataframe"

***** Global folders ****
global data 	 "${path}\data"
global dataframe "${path}\dataframe" 

***Version Control:
global date = strofreal(date(c(current_date),"DMY"), "%tdYYNNDD")


clear

use "${dataframe}\child_infection_dataframe.dta", clear

*** covert variables from string to numeric *** 
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

save  "${dataframe}\child_infection_dataframe_01.dta", replace 