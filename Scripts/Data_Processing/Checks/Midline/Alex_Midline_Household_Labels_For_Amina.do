*==============================================================================
* DISES Midline Data Checks - Household Survey Labels
* File originally created By: Alex Mills
* Updates recorded in GitHub: [Alex_Midline_Household_Labels_For_Amina.do](https://github.com/kat-cruz/NSF-Senegal/blob/main/Scripts/Data_Processing/Checks/Midline/Alex_Midline_Household_Labels_For_Amina.do)
*==============================================================================
*
* Description:
* This script processes and updates the Midline Household Survey labels for the NSF Senegal project. It sets file paths, defines replacement variables, replaces placeholders in the dataset, and saves the updated file.
*
* Key Functions:
* - Import household survey labels (`.dta` file).
* - Set up file paths for different users.
* - Define replacement variables for various categories.
* - Replace placeholders in the `value` column with corresponding variables.
* - Save the updated dataset.
*
* Inputs:
* - **Survey Data:** The household data labels (`Midline_Survey_Questions.dta`)
* - **File Paths:** Ensure that user-specific file paths in the `SET FILE PATHS` section are correctly configured.
*
* Outputs:
* - **Updated Household labels:** The updated dataset (`Updated_Midline_Survey_Questions.dta`)
*
* Instructions to Run:
* 1. Update the **file paths** in the `"SET FILE PATHS"` section for the correct user.
* 2. Run the script sequentially in Stata.
* 3. Verify that the placeholders in the `value` column are correctly replaced with the corresponding variables.
* 4. Check the updated dataset saved in the specified directory.
*
*==============================================================================

clear all
set mem 100m
set maxvar 30000
set matsize 11000
set more off

**************************************************
* SET FILE PATHS
**************************************************

if "`c(username)'"=="socrm" global master "C:\Users\socrm\Box\NSF Senegal"
if "`c(username)'"=="kls329" global master "C:\Users\kls329\Box\NSF Senegal"
if "`c(username)'"=="km978" global master "C:\Users\km978\Box\NSF Senegal"
if "`c(username)'"=="Kateri" global master "C:\Users\Kateri\Box\NSF Senegal"
if "`c(username)'"=="admmi" global master "C:\Users\admmi\Box\NSF Senegal"

global data "$master\Data_Management\_CRDES_RawData\Midline\Household_Survey_Data"
global issuesOriginal "$master\Data_Management\Output\Data_Quality_Checks\Midline\_Midline_Original_Issues_Output"

use "$issuesOriginal\Midline_Survey_Questions.dta", clear

**************************************************
* Define Replacement Variables
**************************************************

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

local species1 "BOVINS"
local species2 "MOUTON"
local species3 "CHEVRE"
local species4 "CHEVAL (EQUIDE)"
local species5 "ANE"
local species6 "ANIMAUX DE TRAIT"
local species7 "PORCS"
local species8 "VOLAILLE"

local goods1 "ENGRAIS"
local goods2 "ALIMENTS POUR LE BETAIL"
local goods3 "AUTRES DEPENSES"

**************************************************
* Replace Placeholders in `value` Column
**************************************************

* Cereals
forvalues i=1/6 {
    replace value = subinstr(value, "[cereals-name]", "`cereal`i''", .) if strpos(value, "[cereals-name]")
}

* Farines et Tubercules
forvalues i=1/7 {
    replace value = subinstr(value, "[farines_tubercules-name]", "`farine`i''", .) if strpos(value, "[farines_tubercules-name]")
}

* Légumes
forvalues i=1/7 {
    replace value = subinstr(value, "[legumes-name]", "`legume`i''", .) if strpos(value, "[legumes-name]")
}

* Légumineuses Séchées
forvalues i=1/5 {
    replace value = subinstr(value, "[legumineuses-name]", "`legumineuse`i''", .) if strpos(value, "[legumineuses-name]")
}

* Végétation Aquatique
replace value = subinstr(value, "[aquatique-name]", "`aquatique1'", .) if strpos(value, "[aquatique-name]")

* Other Cultures
replace value = subinstr(value, "[autre-culture]", "`autre1'", .) if strpos(value, "[autre-culture]")

* Species
forvalues i=1/8 {
    replace value = subinstr(value, "[species-name]", "`species`i''", .) if strpos(value, "[species-name]")
}

* Agricultural Goods
forvalues i=1/3 {
    replace value = subinstr(value, "[goods-name]", "`goods`i''", .) if strpos(value, "[goods-name]")
}

**************************************************
* Save Updated File
**************************************************
save "$issuesOriginal\Updated_Midline_Survey_Questions.dta", replace
