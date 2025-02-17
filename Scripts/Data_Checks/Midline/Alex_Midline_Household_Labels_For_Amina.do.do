*==============================================================================

clear all
set mem 100m
set maxvar 30000
set matsize 11000
set more off

**************************************************
* SET FILE PATHS
**************************************************

* Set base Box path for each user
if "`c(username)'"=="socrm" global master "C:\Users\socrm\Box\NSF Senegal"
if "`c(username)'"=="kls329" global master "C:\Users\kls329\Box\NSF Senegal"
if "`c(username)'"=="km978" global master "C:\Users\km978\Box\NSF Senegal"
if "`c(username)'"=="Kateri" global master "C:\Users\Kateri\Box\NSF Senegal"
if "`c(username)'"=="admmi" global master "C:\Users\admmi\Box\NSF Senegal"


**************************** data file paths ****************************`		`	''

global data "$master\Data_Management\_CRDES_RawData\Midline\Household_Survey_Data"
global issuesOriginal "$master\Data_Management\Output\Data_Quality_Checks\Midline\_Midline_Original_Issues_Output"


use "$issuesOriginal\Midline_Survey_Questions.dta", clear

local cereal1 "RIZ"
local cereal2 "MAIS"
local cereal3 "MIL"
local cereal4 "SORGHO"
local cereal5 "NIEBE"
local cereal6 "AUTRES CÉRÉALES"

local farine1 "FARINE MANIOC VERT"
local farine2 "MANIOC SÉCHÉ"
local farine3 "PATATES DOUCES"
local farine4 "POMMES DE TERRE"
local farine5 "IGNAME"
local farine6 "TARO"
local farine7 "AUTRES TUBERCULES"

local legume1 "BRÈDES"
local legume2 "TOMATES"
local legume3 "CAROTTES"
local legume4 "OIGNONS"
local legume5 "CONCOMBRES"
local legume6 "POIVRONS"
local legume7 "AUTRES LÉGUMES"

local legumineuse1 "ARACHIDES"
local legumineuse2 "HARICOTS SECS"
local legumineuse3 "POIS"
local legumineuse4 "LENTILLES"
local legumineuse5 "AUTRES LÉGUMINEUSES"

local aquatique1 "VÉGÉTATION AQUATIQUE"
local autre1 "AUTRES CULTURES"

replace value = subinstr(value, "[cereals-name]", "`cereal1'", .) if strpos(value, "[cereals-name]")
replace value = subinstr(value, "[cereals-name]", "`cereal2'", .) if strpos(value, "[cereals-name]")
replace value = subinstr(value, "[cereals-name]", "`cereal3'", .) if strpos(value, "[cereals-name]")
replace value = subinstr(value, "[cereals-name]", "`cereal4'", .) if strpos(value, "[cereals-name]")
replace value = subinstr(value, "[cereals-name]", "`cereal5'", .) if strpos(value, "[cereals-name]")
replace value = subinstr(value, "[cereals-name]", "`cereal6'", .) if strpos(value, "[cereals-name]")

replace value = subinstr(value, "[farines_tubercules-name]", "`farine1'", .) if strpos(value, "[farines_tubercules-name]")
replace value = subinstr(value, "[farines_tubercules-name]", "`farine2'", .) if strpos(value, "[farines_tubercules-name]")
replace value = subinstr(value, "[farines_tubercules-name]", "`farine3'", .) if strpos(value, "[farines_tubercules-name]")
replace value = subinstr(value, "[farines_tubercules-name]", "`farine4'", .) if strpos(value, "[farines_tubercules-name]")
replace value = subinstr(value, "[farines_tubercules-name]", "`farine5'", .) if strpos(value, "[farines_tubercules-name]")
replace value = subinstr(value, "[farines_tubercules-name]", "`farine6'", .) if strpos(value, "[farines_tubercules-name]")
replace value = subinstr(value, "[farines_tubercules-name]", "`farine7'", .) if strpos(value, "[farines_tubercules-name]")

replace value = subinstr(value, "[legumes-name]", "`legume1'", .) if strpos(value, "[legumes-name]")
replace value = subinstr(value, "[legumes-name]", "`legume2'", .) if strpos(value, "[legumes-name]")
replace value = subinstr(value, "[legumes-name]", "`legume3'", .) if strpos(value, "[legumes-name]")
replace value = subinstr(value, "[legumes-name]", "`legume4'", .) if strpos(value, "[legumes-name]")
replace value = subinstr(value, "[legumes-name]", "`legume5'", .) if strpos(value, "[legumes-name]")
replace value = subinstr(value, "[legumes-name]", "`legume6'", .) if strpos(value, "[legumes-name]")
replace value = subinstr(value, "[legumes-name]", "`legume7'", .) if strpos(value, "[legumes-name]")

replace value = subinstr(value, "[legumineuses-name]", "`legumineuse1'", .) if strpos(value, "[legumineuses-name]")
replace value = subinstr(value, "[legumineuses-name]", "`legumineuse2'", .) if strpos(value, "[legumineuses-name]")
replace value = subinstr(value, "[legumineuses-name]", "`legumineuse3'", .) if strpos(value, "[legumineuses-name]")
replace value = subinstr(value, "[legumineuses-name]", "`legumineuse4'", .) if strpos(value, "[legumineuses-name]")
replace value = subinstr(value, "[legumineuses-name]", "`legumineuse5'", .) if strpos(value, "[legumineuses-name]")

replace value = subinstr(value, "[aquatique-name]", "`aquatique1'", .) if strpos(value, "[aquatique-name]")
replace value = subinstr(value, "[autre-culture]", "`autre1'", .) if strpos(value, "[autre-culture]")

save "$issuesOriginal\Updated_Midline_Survey_Questions.dta", replace
