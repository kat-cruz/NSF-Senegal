*==============================================================================
* DISES Midline Data Corrections - Household Survey
* File originally created By: Alex Mills
* Updates recorded in GitHub: [Alex_Midline_Household_Data_Corrections.do](https://github.com/kat-cruz/NSF-Senegal/blob/main/Scripts/Data_Processing/Corrections/_Midline_Data_Corrections/Alex_Midline_Household_Data_Corrections.do)
*==============================================================================
*
* Description:
* This script performs data corrections for the DISES Midline Household Survey dataset using the corrections given in the external corrections files.
* Easiest to use an excel formula then check each correction to make sure qualitative answers correspond to the correct numeric answer from the raw survey CTO file.
*
* Key Functions:
* - Import corrected household survey data (`.dta` file).
* - Apply corrections to the household survey data.
* - Serves as a storage for all corrections made and those values that have been confirmed which need to be overlooked in the next round of checks.
*
* Inputs:
* - Survey Data: The corrected midline dataset (`CORRECTED_DISES_Enquête_ménage_midline_VF_WIDE_[DATE].dta`)
* - File Paths: Ensure that user-specific file paths in the `SET FILE PATHS` section are correctly configured.
*
* Outputs:
* - **Household Roster Issue Reports:** Identifies missing values for key household-level variables and exports `.dta` reports for corrections.
*
* Instructions to Run:
* 1. Look at the summary statistics to ensure that the loops are the correct number of responses (for household questions this is the max amount of respondents a household has had. for the agriculture section, this is the number of unique plots/horticultural plants).
* 2. Update the **file paths** in the `"SET FILE PATHS"` section for the correct user.
* 3. Check the corrections date in the dataset import section.
* 4. Run the script sequentially.
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

* Set base Box path for each user
if "`c(username)'"=="socrm" global master "C:\Users\socrm\Box\NSF Senegal"
if "`c(username)'"=="kls329" global master "C:\Users\kls329\Box\NSF Senegal"
if "`c(username)'"=="km978" global master "C:\Users\km978\Box\NSF Senegal"
if "`c(username)'"=="Kateri" global master "C:\Users\Kateri\Box\NSF Senegal"
if "`c(username)'"=="admmi" global master "C:\Users\admmi\Box\NSF Senegal"

**************************** Data file paths ****************************

global data "$master\Data_Management\_CRDES_RawData\Midline\Household_Survey_Data"
global replacement "$master\Data_Management\_CRDES_RawData\Midline\Replacement_Survey_Data"
global baselineids "$master\Data_Management\_CRDES_CleanData\Baseline\Identified"
global issues "$master\Data_Management\Output\Data_Quality_Checks\Midline\_Midline_Original_Issues_Output"
global corrections "$master\Data_Management\External_Corrections\Issues for Justin and Amina\Midline\Issues"
global corrected "$master\Data_Management\Output\Data_Corrections\Midline"

* PART 1
**** Import the corrections
import excel "$corrections\Part1_Household_Issues_19Feb2025.xlsx", clear firstrow

**** Keep those issues they confirmed [Lots of -9's lets check this with molly]
keep if print_issue == correction

**** Export the confirmed... and use the following excel formula to add to the checks to skip over these for now
save "$corrected\DISES_Household_Corrections_Confirmed_Part1.dta", replace
export delimited "$corrected\DISES_Household_Corrections_Confirmed_Part1.csv", replace

* excel formula
* ="replace ind_var = 0 if key == "&CHAR(34)&[[key]]&CHAR(34)&" & "&[[issue_variable_name]]&" == "&[print_issue]]&
/*
replace ind_issue = 0 if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980" & agri_6_21_1 == -9 // added to check
replace ind_issue = 0 if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980" & agri_6_37_1 == -9 // added to check
replace ind_issue = 0 if key == "uuid:4a46ca8e-aa03-4e23-876c-ba33a5c5a74e" & agri_6_38_a_1 == 1500 //added to check
replace ind_issue = 0 if key == "uuid:046d9fb5-af36-42e6-b747-7ef88f2eb3c0" & agri_6_38_a_1 == 1500
replace ind_issue = 0 if key == "uuid:b1fae32c-057b-45c3-a10b-5fbdf289d4d6" & agri_6_38_a_1 == 1200
replace ind_issue = 0 if key == "uuid:b23e5229-ac34-49c5-bb00-dc31eb3bd45a" & agri_6_38_a_1 == 1500
replace ind_issue = 0 if key == "uuid:92171a8f-7a48-4292-a5ef-6850b6c04333" & agri_6_38_a_1 == 1200
replace ind_issue = 0 if key == "uuid:c2106e68-0cfa-4b76-a564-4ec7f7f0689a" & agri_6_38_a_1 == 4500
replace ind_issue = 0 if key == "uuid:7305a580-e706-4203-8d8c-79eaed40ffd9" & agri_6_38_a_1 == 1200
replace ind_issue = 0 if key == "uuid:112ead05-6a4c-4759-b69f-f3b875805f55" & agri_6_38_a_1 == 1400
replace ind_issue = 0 if key == "uuid:72fd4109-9013-42e4-9a0a-bca42653b320" & agri_6_38_a_1 == 1050
replace ind_issue = 0 if key == "uuid:c2106e68-0cfa-4b76-a564-4ec7f7f0689a" & agri_6_40_a_1 == 2250
replace ind_issue = 0 if key == "uuid:4478880a-f8ca-4a4c-9eb3-67465800791b" & agri_income_03 == -9 // added to check
replace ind_issue = 0 if key == "uuid:c2d6bc2b-f7cb-42d7-a0ef-b6c79d316202" & agri_income_03 == -9
replace ind_issue = 0 if key == "uuid:f8968dc5-d7d2-48ef-b238-31677e5060f8" & agri_income_03 == -9
replace ind_issue = 0 if key == "uuid:cda122cf-9280-432d-a1a8-8b7d8c4948f9" & agri_income_05 == -9 // added to check
replace ind_issue = 0 if key == "uuid:6942e4de-2992-42cc-b611-72abe5834a35" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:36cc7c65-9580-4182-92d9-ddda36fbb0ea" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:0d7abf18-244e-4440-b557-8ac4589ddf38" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:7b999785-4d17-4867-8512-d3bf09c28590" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:ec674bbd-07e3-4ad3-bb4e-915aed528559" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:d99a8dd2-9a86-4b52-bda5-100b7ac0015d" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:c4551c9e-c0c0-4f4a-b080-e07648e53697" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:e30ea4ae-696d-4a95-b119-ffa43fde532f" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:824199a9-08c8-4346-b9fc-9a67d4068e26" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:e25110ba-6df8-467a-b38e-577b9986dd00" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:97c0bd0c-6d8c-4571-bc15-d2d169449e82" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:24b6fa8e-852f-4176-a864-8d93e07675f2" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:5dbb5ff1-8bb0-42a8-97b9-908ced71a624" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:10ce019a-2990-430a-a81b-7c308a4c7bad" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:b66b0159-426b-41be-af40-5d9f2ef3c0e4" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:8895114d-827e-44d2-93c6-949d4c3c0ebe" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:9147cf5c-0509-4118-994c-462c61bcc4fe" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:d119d84e-18ad-43a8-aaaf-8b807d8af117" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:2a38b805-c7ae-4da3-8ff0-e6647ebd3139" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:ae79a16b-e91d-43dd-bf07-f5d8243dbc65" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:62f6265a-d35b-4b63-a24e-e159377cb165" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:458de09c-ccc6-4759-b192-8dc7c6112bc4" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:4478880a-f8ca-4a4c-9eb3-67465800791b" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:2a436357-13ff-4710-a749-b012d58d5685" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:53f60c19-7569-47c2-9423-ee4f516907c9" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:0af345d0-6960-4805-899a-3123a7c1a547" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:e707c317-45bd-4729-9216-380a140db29d" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:a7a54357-649f-4f1e-b7f1-ca2977436360" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:723843da-05ed-40ec-a63f-3a0374e444c9" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:ca25ba07-535e-4cc2-a8c7-2fa5072d9318" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:c2d6bc2b-f7cb-42d7-a0ef-b6c79d316202" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:f2320249-e402-4c29-aea1-6c2dab838a8b" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:b4135843-09e3-44e8-b649-7f6dbd35f542" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:0be6fc2e-5699-49b5-9b31-d924e7ad7581" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:17b1c705-ed89-443b-8ddc-4ca93f033edd" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:32246f7b-b517-478d-b4f2-f8ab414ee1b2" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:abd77c0d-982e-4867-b847-9531494e4578" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:7d5ce99f-c798-473b-b2f0-e87458bb972f" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:3edcedd7-4992-486e-a924-22eb67a877b3" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:f5ebb1fa-32f5-47fd-8d6b-ffdaa02d551e" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:64a4197f-9a39-4143-8f47-e2fa2e45b5f6" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:bb216791-2b51-4b42-9f67-8616f652ec33" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:f1a3ca58-71ee-4f17-9a08-8b2b64343adb" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:f0bebe93-a4f0-40a0-8936-233682b356d1" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:a398b76a-7378-444c-8717-36fb8d3d46df" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:f8968dc5-d7d2-48ef-b238-31677e5060f8" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:8b3ff069-df75-498b-a1f8-f51f2bd7c059" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:397fd602-9a30-4d8b-a9ba-7f46497e6648" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:87dcb749-21ec-4806-bb69-da9d55f9f5ab" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:2b46e567-634a-45f4-abbd-e0174c03900d" & agri_income_05 == -9
replace ind_issue = 0 if key == "uuid:230eeec0-f4e6-476f-a49b-68a540e6612e" & agri_income_06 == -9
replace ind_issue = 0 if key == "uuid:cda122cf-9280-432d-a1a8-8b7d8c4948f9" & agri_income_06 == -9
replace ind_issue = 0 if key == "uuid:6942e4de-2992-42cc-b611-72abe5834a35" & agri_income_06 == -9
replace ind_issue = 0 if key == "uuid:36cc7c65-9580-4182-92d9-ddda36fbb0ea" & agri_income_06 == -9
replace ind_issue = 0 if key == "uuid:0d7abf18-244e-4440-b557-8ac4589ddf38" & agri_income_06 == -9
replace ind_issue = 0 if key == "uuid:7b999785-4d17-4867-8512-d3bf09c28590" & agri_income_06 == -9
replace ind_issue = 0 if key == "uuid:ec674bbd-07e3-4ad3-bb4e-915aed528559" & agri_income_06 == -9
replace ind_issue = 0 if key == "uuid:d99a8dd2-9a86-4b52-bda5-100b7ac0015d" & agri_income_06 == -9
replace ind_issue = 0 if key == "uuid:e30ea4ae-696d-4a95-b119-ffa43fde532f" & agri_income_06 == -9
replace ind_issue = 0 if key == "uuid:e25110ba-6df8-467a-b38e-577b9986dd00" & agri_income_06 == -9
replace ind_issue = 0 if key == "uuid:97c0bd0c-6d8c-4571-bc15-d2d169449e82" & agri_income_06 == -9
replace ind_issue = 0 if key == "uuid:24b6fa8e-852f-4176-a864-8d93e07675f2" & agri_income_06 == -9
replace ind_issue = 0 if key == "uuid:b66b0159-426b-41be-af40-5d9f2ef3c0e4" & agri_income_06 == -9
replace ind_issue = 0 if key == "uuid:91939cea-af27-4cf0-be7d-1ce751c8163b" & agri_income_06 == -9
replace ind_issue = 0 if key == "uuid:458de09c-ccc6-4759-b192-8dc7c6112bc4" & agri_income_06 == -9
replace ind_issue = 0 if key == "uuid:4478880a-f8ca-4a4c-9eb3-67465800791b" & agri_income_06 == -9
replace ind_issue = 0 if key == "uuid:2a436357-13ff-4710-a749-b012d58d5685" & agri_income_06 == -9
replace ind_issue = 0 if key == "uuid:53f60c19-7569-47c2-9423-ee4f516907c9" & agri_income_06 == -9
replace ind_issue = 0 if key == "uuid:0af345d0-6960-4805-899a-3123a7c1a547" & agri_income_06 == -9
replace ind_issue = 0 if key == "uuid:e707c317-45bd-4729-9216-380a140db29d" & agri_income_06 == -9
replace ind_issue = 0 if key == "uuid:a7a54357-649f-4f1e-b7f1-ca2977436360" & agri_income_06 == -9
replace ind_issue = 0 if key == "uuid:723843da-05ed-40ec-a63f-3a0374e444c9" & agri_income_06 == -9
replace ind_issue = 0 if key == "uuid:ca25ba07-535e-4cc2-a8c7-2fa5072d9318" & agri_income_06 == -9
replace ind_issue = 0 if key == "uuid:c2d6bc2b-f7cb-42d7-a0ef-b6c79d316202" & agri_income_06 == -9
replace ind_issue = 0 if key == "uuid:f2320249-e402-4c29-aea1-6c2dab838a8b" & agri_income_06 == -9
replace ind_issue = 0 if key == "uuid:b4135843-09e3-44e8-b649-7f6dbd35f542" & agri_income_06 == -9
replace ind_issue = 0 if key == "uuid:0be6fc2e-5699-49b5-9b31-d924e7ad7581" & agri_income_06 == -9
replace ind_issue = 0 if key == "uuid:17b1c705-ed89-443b-8ddc-4ca93f033edd" & agri_income_06 == -9
replace ind_issue = 0 if key == "uuid:32246f7b-b517-478d-b4f2-f8ab414ee1b2" & agri_income_06 == -9
replace ind_issue = 0 if key == "uuid:abd77c0d-982e-4867-b847-9531494e4578" & agri_income_06 == -9
replace ind_issue = 0 if key == "uuid:7d5ce99f-c798-473b-b2f0-e87458bb972f" & agri_income_06 == -9
replace ind_issue = 0 if key == "uuid:3edcedd7-4992-486e-a924-22eb67a877b3" & agri_income_06 == -9
replace ind_issue = 0 if key == "uuid:f5ebb1fa-32f5-47fd-8d6b-ffdaa02d551e" & agri_income_06 == -9
replace ind_issue = 0 if key == "uuid:64a4197f-9a39-4143-8f47-e2fa2e45b5f6" & agri_income_06 == -9
replace ind_issue = 0 if key == "uuid:bb216791-2b51-4b42-9f67-8616f652ec33" & agri_income_06 == -9
replace ind_issue = 0 if key == "uuid:f1a3ca58-71ee-4f17-9a08-8b2b64343adb" & agri_income_06 == -9
replace ind_issue = 0 if key == "uuid:f8968dc5-d7d2-48ef-b238-31677e5060f8" & agri_income_06 == -9
replace ind_issue = 0 if key == "uuid:f0bebe93-a4f0-40a0-8936-233682b356d1" & agri_income_06 == -9
replace ind_issue = 0 if key == "uuid:a398b76a-7378-444c-8717-36fb8d3d46df" & agri_income_06 == -9
replace ind_issue = 0 if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980" & agri_income_07_1 == -9
replace ind_issue = 0 if key == "uuid:cfd81b39-f5e3-40d4-aab0-4b7c3d2da1bd" & agri_income_07_2 == -9
replace ind_issue = 0 if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980" & agri_income_07_2 == -9
replace ind_issue = 0 if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980" & agri_income_07_3 == -9
***** NOTE for agri_income_07 HAD TO CHANGE TO IN THE CHECKS CODE
	drop if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980" & agri_income_07_1 == -9
	drop if key == "uuid:cfd81b39-f5e3-40d4-aab0-4b7c3d2da1bd" & agri_income_07_2 == -9
	drop if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980" & agri_income_07_2 == -9
	drop if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980" & agri_income_07_3 == -9
	
replace ind_issue = 0 if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980" & agri_income_08_1 == -9
replace ind_issue = 0 if key == "uuid:fa6b632a-58f0-4bc1-a921-5abb0680d79e" & agri_income_08_2 == -9
replace ind_issue = 0 if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980" & agri_income_08_2 == -9
replace ind_issue = 0 if key == "uuid:fa6b632a-58f0-4bc1-a921-5abb0680d79e" & agri_income_08_3 == -9
replace ind_issue = 0 if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980" & agri_income_08_3 == -9
replace ind_issue = 0 if key == "uuid:950634d7-6af7-48f4-81f2-23e84812d304" & agri_income_08_4 == -9
****** NOTE for agri_income_08_ HAD TO CHANGE TO IN THE CHECKS CODE
	drop if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980" & agri_income_08_1 == -9
	drop if key == "uuid:fa6b632a-58f0-4bc1-a921-5abb0680d79e" & agri_income_08_2 == -9
	drop if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980" & agri_income_08_2 == -9
	drop if key == "uuid:fa6b632a-58f0-4bc1-a921-5abb0680d79e" & agri_income_08_3 == -9
	drop if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980" & agri_income_08_3 == -9
	drop if key == "uuid:950634d7-6af7-48f4-81f2-23e84812d304" & agri_income_08_4 == -9
	
replace ind_issue = 0 if key == "uuid:53f60c19-7569-47c2-9423-ee4f516907c9" & agri_income_10_1 == -9 //added to check
replace ind_issue = 0 if key == "uuid:446cce08-7cc4-44c1-be46-e651f216e5bc" & agri_income_10_2 == -9
replace ind_issue = 0 if key == "uuid:ae414dc0-3027-4656-9f44-94b899afafe7" & agri_income_16 == -9 // added to check
replace ind_issue = 0 if key == "uuid:c87d313e-22c7-46b4-9aef-a2087808f7a4" & agri_income_19 == -9 // added to check
replace ind_issue = 0 if key == "uuid:8895114d-827e-44d2-93c6-949d4c3c0ebe" & agri_income_19 == -9
replace ind_issue = 0 if key == "uuid:ae414dc0-3027-4656-9f44-94b899afafe7" & agri_income_19 == -9
replace ind_issue = 0 if key == "uuid:53f60c19-7569-47c2-9423-ee4f516907c9" & agri_income_19 == -9
replace ind_issue = 0 if key == "uuid:4230989a-8a58-4ea0-a832-181386899bf5" & agri_income_19 == -9
replace ind_issue = 0 if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980" & agri_income_19 == -9
replace ind_issue = 0 if key == "uuid:88a033cc-ae5d-4bd6-860b-3f14ff81a0f0" & agri_income_23_1 == -9 // added to check
replace ind_issue = 0 if key == "uuid:8c6736ef-01bd-4997-b8e7-02419b77bbb4" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:63d08059-817d-45ae-bac7-ccdf05eb4c6a" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:8f49e817-68d3-4a92-98c6-02ed3739a07f" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:443cfabd-f98c-4336-8e20-80f8957bad20" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:31fd0450-5add-4058-bf77-a506823a7fca" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:bff7956c-0e63-4cf7-b6f8-abf16a8c0276" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:68a3059c-40a2-47ae-b9a7-d9072411b67a" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:2a48fd8c-b5b1-423b-87dd-c01cb6405189" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:c87d313e-22c7-46b4-9aef-a2087808f7a4" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:07374a46-8b35-4535-8e7f-aee405e62880" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:e1500728-8f0d-4082-aa0b-7151e4c98c24" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:d1e9a6b7-4901-4e70-a991-fa6db1906a2a" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:24b6fa8e-852f-4176-a864-8d93e07675f2" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:61144d37-6700-447a-b358-647e4312819f" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:40069d40-8775-4706-874f-10a74794a83d" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:9147cf5c-0509-4118-994c-462c61bcc4fe" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:3b9c2531-3c02-4417-85f4-4023e1fd13cf" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:59d24152-883e-4d28-9e64-01a5d66013fb" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:ae79a16b-e91d-43dd-bf07-f5d8243dbc65" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:a0de5050-073d-47e2-934a-cf2cc8d2c532" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:2a436357-13ff-4710-a749-b012d58d5685" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:53f60c19-7569-47c2-9423-ee4f516907c9" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:2d69cae2-bc11-4173-a5df-4264bd41d410" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:8befef83-7f84-46ca-87f6-742b686956e6" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:46f5d5d9-d7d5-41a2-abe2-014313e781cf" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:723843da-05ed-40ec-a63f-3a0374e444c9" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:ca25ba07-535e-4cc2-a8c7-2fa5072d9318" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:0b997d0d-f27c-4fb5-bca7-42e6220b29c4" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:245c21d7-f36b-4083-9a15-27de32aaf8e0" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:b4135843-09e3-44e8-b649-7f6dbd35f542" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:0be6fc2e-5699-49b5-9b31-d924e7ad7581" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:26971b58-f29b-4ca2-835b-f25a19f057c3" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:8915a062-0f9a-4c85-a7a6-1b4fa6b3e3f1" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:02a39efd-23f1-4815-9b17-ff8b43173d90" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:32246f7b-b517-478d-b4f2-f8ab414ee1b2" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:4d1f8b31-796d-4edf-80d4-823d5fc08571" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:abd77c0d-982e-4867-b847-9531494e4578" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:dedd712c-634c-4665-a874-f139341ecd5f" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:78498830-729b-4669-a8b0-ddb3ba898a73" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:fe254168-10ee-4b8e-bfe5-5e3d6e47d26e" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:7d5ce99f-c798-473b-b2f0-e87458bb972f" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:3edcedd7-4992-486e-a924-22eb67a877b3" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:bb216791-2b51-4b42-9f67-8616f652ec33" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:abb87752-4a63-446c-9b08-114b67de3f6e" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:49e1ea67-b6bc-4685-822a-04e4963bbd19" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:197be989-16e8-4ef0-b91f-a6cb3287c2d8" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:e62f05aa-7c34-4c69-95d6-f064f3d20cde" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:f0bebe93-a4f0-40a0-8936-233682b356d1" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:6fc043eb-a620-4e71-bd62-850b4b3b79cd" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:ef0ba8e1-fdef-45f1-9218-25f9493d122e" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:755e6213-1a72-4412-b634-a3e3259586ea" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:147fc8cf-acbe-4e51-aa7b-8eb92b783fd0" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:8d65b726-e9bc-49af-bcbc-762f36075dc8" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:76e1afe0-c769-48fe-843a-4c17f85fdbec" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:d3647dde-8f8b-4a1b-a7b8-7a1625ace056" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:5f863611-f2c8-46aa-b747-7c0081328ac3" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:c51053da-4b7f-447a-94ca-7576bc6259c6" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:fee45475-a2e7-453b-aa2d-20bc077e1247" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:de493f3d-0dd1-4090-a9eb-3a0e67225367" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:6f13c3cb-d0dd-4c27-b73b-c9a6843687c5" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:47e49c11-a7c8-4f84-ad73-cecb40bacc62" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:83daaf4c-5cd4-4774-9364-769d8a3d97e4" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:03f80375-e27b-4aee-80f2-983af72db81e" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:af2fa2b6-d183-4406-8d00-4be4c168e97b" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:c2a63575-25c7-4189-90a2-68a5f7140b9e" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:6040d2eb-1fae-4730-91e1-6e4f7bb98dfa" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:634c64a4-3dc4-44bd-9a93-3502cfb663c9" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:87ecb9b2-7218-4e4d-a645-f1c780305504" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:128199d5-45c7-4c42-b56f-cbfadf72b88c" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:008b2d0c-9a04-4426-94d6-7b9b9a83cfc4" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:a621035f-2fcc-4ada-b25b-8ec0e6d6090c" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:4a5d7d2a-5de0-435e-af76-30d1ef85e5c0" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:79e1a0b4-c1c2-4b85-89f7-854a3b3fbc1e" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:46693568-4859-402d-ab33-9639f9622ca1" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:83139d1d-2f8e-4508-a16f-ab293c21e60e" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:beafc02c-dc0d-4a2f-896e-e06ddfbebdab" & agri_income_23_1 == -9
replace ind_issue = 0 if key == "uuid:2a436357-13ff-4710-a749-b012d58d5685" & agri_income_23_2 == -9
replace ind_issue = 0 if key == "uuid:8915a062-0f9a-4c85-a7a6-1b4fa6b3e3f1" & agri_income_23_2 == -9
replace ind_issue = 0 if key == "uuid:a3b4a2de-dfd2-4985-9f7f-88f577cbde09" & agri_income_23_2 == -9
replace ind_issue = 0 if key == "uuid:2bb8d593-96ee-4652-8db4-65eae2b880fe" & agri_income_23_2 == -9
replace ind_issue = 0 if key == "uuid:af2fa2b6-d183-4406-8d00-4be4c168e97b" & agri_income_23_2 == -9
replace ind_issue = 0 if key == "uuid:af2fa2b6-d183-4406-8d00-4be4c168e97b" & agri_income_23_3 == -9
replace ind_issue = 0 if key == "uuid:ed4a3ab3-eb94-46fa-8ca7-d4305cf8e36e" & agri_income_23_o == -9 // added to check
replace ind_issue = 0 if key == "uuid:8c6736ef-01bd-4997-b8e7-02419b77bbb4" & agri_income_23_o == -9
replace ind_issue = 0 if key == "uuid:2086c8e7-cfb1-472b-ad6d-f21b87b90881" & agri_income_23_o == -9
replace ind_issue = 0 if key == "uuid:8be12456-9c4d-4e61-917b-2f94584d4796" & agri_income_23_o == -9
replace ind_issue = 0 if key == "uuid:d3de785c-2ad1-45a0-a8c0-5e41e53483da" & agri_income_23_o == -9
replace ind_issue = 0 if key == "uuid:dbcf5c48-d38a-4900-934d-1589c334478b" & agri_income_23_o == -9
replace ind_issue = 0 if key == "uuid:443cfabd-f98c-4336-8e20-80f8957bad20" & agri_income_29 == -9 // added to check
replace ind_issue = 0 if key == "uuid:40069d40-8775-4706-874f-10a74794a83d" & agri_income_29 == -9
replace ind_issue = 0 if key == "uuid:4230989a-8a58-4ea0-a832-181386899bf5" & agri_income_29 == -9
replace ind_issue = 0 if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980" & agri_income_29 == -9
replace ind_issue = 0 if key == "uuid:ed4a3ab3-eb94-46fa-8ca7-d4305cf8e36e" & agri_income_33 == -9 //added to check
replace ind_issue = 0 if key == "uuid:6f48b23e-f222-48db-b73c-6bedf67a9889" & agri_income_33 == -9
replace ind_issue = 0 if key == "uuid:d55a8454-7691-4b6d-bc0e-86712a701bc3" & agri_income_33 == -9
replace ind_issue = 0 if key == "uuid:ae86ed43-5ec0-4f1c-904a-e5609618f94f" & agri_income_33 == -9
replace ind_issue = 0 if key == "uuid:8c6736ef-01bd-4997-b8e7-02419b77bbb4" & agri_income_33 == -9
replace ind_issue = 0 if key == "uuid:6fc34a13-7455-46b5-9d1a-5bafa2e11b9e" & agri_income_33 == -9
replace ind_issue = 0 if key == "uuid:d252199f-1a7f-4ae2-8920-97ffe447aefb" & agri_income_33 == -9
replace ind_issue = 0 if key == "uuid:cbcda759-6489-4a39-a76a-a93e0b05546c" & agri_income_33 == -9
replace ind_issue = 0 if key == "uuid:dbcf5c48-d38a-4900-934d-1589c334478b" & agri_income_33 == -9
replace ind_issue = 0 if key == "uuid:c7ecc3c7-f961-4f01-a59e-519ce6d7b325" & agri_income_33 == -9
replace ind_issue = 0 if key == "uuid:2c43c97e-4854-45f3-acb7-49a56e4a5276" & agri_income_33 == -9
replace ind_issue = 0 if key == "uuid:6942e4de-2992-42cc-b611-72abe5834a35" & agri_income_33 == -9
replace ind_issue = 0 if key == "uuid:443cfabd-f98c-4336-8e20-80f8957bad20" & agri_income_33 == -9
replace ind_issue = 0 if key == "uuid:1f8316b4-c849-40b4-8ced-4cb30d7d5944" & agri_income_33 == -9
replace ind_issue = 0 if key == "uuid:97c0bd0c-6d8c-4571-bc15-d2d169449e82" & agri_income_33 == -9
replace ind_issue = 0 if key == "uuid:f0e95d05-f703-4242-bb05-cdf1c7be4e16" & agri_income_33 == -9
replace ind_issue = 0 if key == "uuid:4f7289fd-e9ce-47ce-b262-a003ec89ebd4" & agri_income_33 == -9
replace ind_issue = 0 if key == "uuid:a7a54357-649f-4f1e-b7f1-ca2977436360" & agri_income_33 == -9
replace ind_issue = 0 if key == "uuid:723843da-05ed-40ec-a63f-3a0374e444c9" & agri_income_33 == -9
replace ind_issue = 0 if key == "uuid:245c21d7-f36b-4083-9a15-27de32aaf8e0" & agri_income_33 == -9
replace ind_issue = 0 if key == "uuid:88167bbe-853b-48b8-a3f9-6bbb02c12309" & agri_income_33 == -9
replace ind_issue = 0 if key == "uuid:04f3040a-9991-412d-9fce-9ee840eafcea" & agri_income_33 == -9
replace ind_issue = 0 if key == "uuid:6b2af6f0-abd9-40ce-8bb7-792c1e9e0e18" & agri_income_33 == -9
replace ind_issue = 0 if key == "uuid:17b1c705-ed89-443b-8ddc-4ca93f033edd" & agri_income_33 == -9
replace ind_issue = 0 if key == "uuid:dedd712c-634c-4665-a874-f139341ecd5f" & agri_income_33 == -9
replace ind_issue = 0 if key == "uuid:f5ebb1fa-32f5-47fd-8d6b-ffdaa02d551e" & agri_income_33 == -9
replace ind_issue = 0 if key == "uuid:64a4197f-9a39-4143-8f47-e2fa2e45b5f6" & agri_income_33 == -9
replace ind_issue = 0 if key == "uuid:f8968dc5-d7d2-48ef-b238-31677e5060f8" & agri_income_33 == -9
replace ind_issue = 0 if key == "uuid:e62f05aa-7c34-4c69-95d6-f064f3d20cde" & agri_income_33 == -9
replace ind_issue = 0 if key == "uuid:f2320249-e402-4c29-aea1-6c2dab838a8b" & agri_income_36_1 == -9 // added to check
replace ind_issue = 0 if key == "uuid:f2320249-e402-4c29-aea1-6c2dab838a8b" & agri_income_36_2 == -9
replace ind_issue = 0 if key == "uuid:93743604-01c7-48c5-a295-3242254348b6" & agri_income_42_1 == 0  // added to check
replace ind_issue = 0 if key == "uuid:2a436357-13ff-4710-a749-b012d58d5685" & agri_income_45_1 == -9 // added to check
replace ind_issue = 0 if key == "uuid:78498830-729b-4669-a8b0-ddb3ba898a73" & agri_income_45_1 == -9
replace ind_issue = 0 if key == "uuid:9f46c69f-f13a-4f0d-8035-91c346dcb751" & agri_income_45_2 == -9
replace ind_issue = 0 if key == "uuid:f0e95d05-f703-4242-bb05-cdf1c7be4e16" & agri_income_45_2 == -9
replace ind_issue = 0 if key == "uuid:002674f4-6ea0-4f36-9a11-79038e40bbc2" & agri_income_45_2 == -9
replace ind_issue = 0 if key == "uuid:a174f3ae-1533-4f24-9056-c76dc2c8ec40" & agri_income_45_2 == -9
replace ind_issue = 0 if key == "uuid:4478880a-f8ca-4a4c-9eb3-67465800791b" & agri_income_45_2 == -9
replace ind_issue = 0 if key == "uuid:2a436357-13ff-4710-a749-b012d58d5685" & agri_income_45_2 == -9
replace ind_issue = 0 if key == "uuid:e6efc18c-7a7b-4132-8535-6e7dff6a7ac7" & agri_income_45_2 == -9
replace ind_issue = 0 if key == "uuid:f2320249-e402-4c29-aea1-6c2dab838a8b" & agri_income_45_2 == -9
replace ind_issue = 0 if key == "uuid:0b997d0d-f27c-4fb5-bca7-42e6220b29c4" & agri_income_45_2 == -9
replace ind_issue = 0 if key == "uuid:78498830-729b-4669-a8b0-ddb3ba898a73" & agri_income_45_2 == -9
replace ind_issue = 0 if key == "uuid:9b78b42a-a3ec-49d3-a987-30b77f3872d0" & agri_income_45_3 == -9
replace ind_issue = 0 if key == "uuid:36cc7c65-9580-4182-92d9-ddda36fbb0ea" & agri_income_45_3 == -9
replace ind_issue = 0 if key == "uuid:002674f4-6ea0-4f36-9a11-79038e40bbc2" & agri_income_45_3 == -9
replace ind_issue = 0 if key == "uuid:a174f3ae-1533-4f24-9056-c76dc2c8ec40" & agri_income_45_3 == -9
replace ind_issue = 0 if key == "uuid:4478880a-f8ca-4a4c-9eb3-67465800791b" & agri_income_45_3 == -9
replace ind_issue = 0 if key == "uuid:2a436357-13ff-4710-a749-b012d58d5685" & agri_income_45_3 == -9
replace ind_issue = 0 if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980" & agri_income_45_3 == -9
replace ind_issue = 0 if key == "uuid:46c68d66-a26a-41b3-854d-df3e6a061945" & agri_income_45_4 == -9
replace ind_issue = 0 if key == "uuid:2a436357-13ff-4710-a749-b012d58d5685" & agri_income_45_4 == -9
replace ind_issue = 0 if key == "uuid:36cc7c65-9580-4182-92d9-ddda36fbb0ea" & agri_income_45_5 == -9
replace ind_issue = 0 if key == "uuid:46c68d66-a26a-41b3-854d-df3e6a061945" & agri_income_45_5 == -9
replace ind_issue = 0 if key == "uuid:9e53c128-b360-47f1-a624-e5a0e0e8c3cd" & agri_income_45_5 == -9
replace ind_issue = 0 if key == "uuid:3730061c-a719-461a-a962-034ffbfd7e20" & agri_income_45_5 == -9
replace ind_issue = 0 if key == "uuid:f2652d13-6956-4a7e-879b-99bf73b286ac" & agri_income_45_5 == -9
replace ind_issue = 0 if key == "uuid:77adf104-aae7-4179-953f-b5bcf21dadda" & agri_income_45_5 == -9
replace ind_issue = 0 if key == "uuid:2a436357-13ff-4710-a749-b012d58d5685" & agri_income_45_5 == -9
replace ind_issue = 0 if key == "uuid:36cc7c65-9580-4182-92d9-ddda36fbb0ea" & agri_income_45_6 == -9
replace ind_issue = 0 if key == "uuid:46c68d66-a26a-41b3-854d-df3e6a061945" & agri_income_45_6 == -9
replace ind_issue = 0 if key == "uuid:e5eb596e-392d-43e1-8ac5-19f7993e9401" & agri_income_45_6 == -9
replace ind_issue = 0 if key == "uuid:27620229-c213-47f3-8b61-f8ec6c7cd1cc" & agri_income_45_6 == -9
replace ind_issue = 0 if key == "uuid:896ef294-6ea0-45d0-9468-3f1bdf54924e" & agri_income_45_6 == -9
replace ind_issue = 0 if key == "uuid:481263fb-d102-43b2-8504-d72a780bd7e8" & agri_income_45_6 == -9
replace ind_issue = 0 if key == "uuid:f0e95d05-f703-4242-bb05-cdf1c7be4e16" & agri_income_45_7 == -9
replace ind_issue = 0 if key == "uuid:801e11ec-467f-4cc9-9eb6-0dec8dbec2a5" & agri_income_45_7 == -9
replace ind_issue = 0 if key == "uuid:a1261fd4-5c99-4e06-91c4-ac1072db7e5e" & agri_income_47_1 == -9 // added check
replace ind_issue = 0 if key == "uuid:446cce08-7cc4-44c1-be46-e651f216e5bc" & agri_income_47_1 == -9
replace ind_issue = 0 if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980" & agri_income_47_1 == -9
replace ind_issue = 0 if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980" & agri_income_48_1 == -9 // added check
replace ind_issue = 0 if key == "uuid:a850d7a9-ed56-4f03-8045-6e298dae3fff" & agri_income_48_2 == -9
replace ind_issue = 0 if key == "uuid:a0de5050-073d-47e2-934a-cf2cc8d2c532" & aquatique_01 == -9 // added check
replace ind_issue = 0 if key == "uuid:dedd712c-634c-4665-a874-f139341ecd5f" & aquatique_01 == -9
replace ind_issue = 0 if key == "uuid:f0bebe93-a4f0-40a0-8936-233682b356d1" & aquatique_01 == -9
replace ind_issue = 0 if key == "uuid:a0de5050-073d-47e2-934a-cf2cc8d2c532" & aquatique_02 == -9 // added check
replace ind_issue = 0 if key == "uuid:dedd712c-634c-4665-a874-f139341ecd5f" & aquatique_02 == -9
replace ind_issue = 0 if key == "uuid:f0bebe93-a4f0-40a0-8936-233682b356d1" & aquatique_02 == -9
replace ind_issue = 0 if key == "uuid:a0de5050-073d-47e2-934a-cf2cc8d2c532" & aquatique_05 == -9  // added check
replace ind_issue = 0 if key == "uuid:f0bebe93-a4f0-40a0-8936-233682b356d1" & aquatique_05 == -9
replace ind_issue = 0 if key == "uuid:a8ab108b-bfad-4d97-979e-781ec303068d" & cereals_02_1 == -9  // added check
replace ind_issue = 0 if key == "uuid:92a20142-025d-44aa-91a4-1c1c4fc151a9" & cereals_02_1 == 10500
replace ind_issue = 0 if key == "uuid:568408fd-6ada-4251-80f8-23d8b1258708" & cereals_02_1 == 18400
replace ind_issue = 0 if key == "uuid:104f7dff-68f2-4bbd-a2d6-da22b7b72754" & cereals_02_1 == 12000
replace ind_issue = 0 if key == "uuid:2bf20bdc-4cf8-407c-b399-cd9a35efd6ba" & cereals_02_1 == 24000
replace ind_issue = 0 if key == "uuid:22c42af0-ec97-4fc3-80f5-94d3a684eff8" & cereals_02_1 == 25000
replace ind_issue = 0 if key == "uuid:b99d9512-c46b-48a5-a08f-00db51351c27" & cereals_02_1 == 16000
replace ind_issue = 0 if key == "uuid:338d1760-bfa2-46fd-9368-469f727d9cef" & cereals_02_1 == 11360
replace ind_issue = 0 if key == "uuid:2d35da93-7a0e-4d12-b958-2ff8f42b52a9" & cereals_02_1 == 22400
replace ind_issue = 0 if key == "uuid:5e72ce0f-a07d-4bcd-8618-d32576e05c8b" & cereals_02_1 == 15500
replace ind_issue = 0 if key == "uuid:340107c5-0475-4534-987f-e832e89a582e" & cereals_02_1 == 19800
replace ind_issue = 0 if key == "uuid:5a624ab5-23e1-4f2f-8e58-6d18eb28b4f2" & cereals_02_1 == 15000
replace ind_issue = 0 if key == "uuid:5405184a-72e2-45d3-9d4b-7de603a79851" & cereals_02_1 == 14000
replace ind_issue = 0 if key == "uuid:b4648e61-1839-42d1-9890-4069ccce8a97" & cereals_02_1 == 16000
replace ind_issue = 0 if key == "uuid:ae346c76-805d-4845-af88-e70c606d8389" & cereals_02_1 == 15000
replace ind_issue = 0 if key == "uuid:e1cd6dc2-003a-44ab-8c0f-3dc63c59ba14" & cereals_02_1 == 12000
replace ind_issue = 0 if key == "uuid:ee63debf-822a-411e-a0f2-d08e9eade8c3" & cereals_02_1 == 15360
replace ind_issue = 0 if key == "uuid:b1fae32c-057b-45c3-a10b-5fbdf289d4d6" & cereals_02_1 == 15200
replace ind_issue = 0 if key == "uuid:96923c86-ad11-4def-97ce-64a3089a78a1" & cereals_02_1 == 14400
replace ind_issue = 0 if key == "uuid:7bc76c9c-7953-4dc6-8f11-a7b27a31fb2e" & cereals_02_1 == 11520
replace ind_issue = 0 if key == "uuid:92171a8f-7a48-4292-a5ef-6850b6c04333" & cereals_02_1 == 16000
replace ind_issue = 0 if key == "uuid:c2106e68-0cfa-4b76-a564-4ec7f7f0689a" & cereals_02_1 == 24000
replace ind_issue = 0 if key == "uuid:309e01e8-8554-4a50-95b3-b8a52e840905" & cereals_02_1 == 64000
replace ind_issue = 0 if key == "uuid:983adac5-4009-47c2-8c3e-9976d4b0961b" & cereals_02_1 == 12000
replace ind_issue = 0 if key == "uuid:9592ef45-c1b9-4b5b-a4d6-040ac97fdc5f" & cereals_02_1 == 13000
replace ind_issue = 0 if key == "uuid:7305a580-e706-4203-8d8c-79eaed40ffd9" & cereals_02_1 == 16000
replace ind_issue = 0 if key == "uuid:f4aa1eed-3ba6-43e0-84f4-3c3a2e7c1e14" & cereals_02_1 == 10960
replace ind_issue = 0 if key == "uuid:112ead05-6a4c-4759-b69f-f3b875805f55" & cereals_02_1 == 23040
replace ind_issue = 0 if key == "uuid:d56edb36-89c5-436c-93d2-f3e9f0f601a5" & cereals_02_1 == 36000
replace ind_issue = 0 if key == "uuid:76975ab5-98e2-414f-a9b9-7c15a4ff50f6" & cereals_02_1 == 14240
replace ind_issue = 0 if key == "uuid:bc6c1d3d-fa4b-4767-9ae5-c7422db73c6c" & cereals_02_1 == 16800
replace ind_issue = 0 if key == "uuid:10cdabf2-f022-4539-8c2b-7eaa1bead1d1" & cereals_02_1 == 16000
replace ind_issue = 0 if key == "uuid:e6efc18c-7a7b-4132-8535-6e7dff6a7ac7" & cereals_02_1 == -9
replace ind_issue = 0 if key == "uuid:a9b198b5-e8e9-457d-9967-1ac777669d76" & cereals_02_1 == 56250
replace ind_issue = 0 if key == "uuid:f2320249-e402-4c29-aea1-6c2dab838a8b" & cereals_02_1 == -9
replace ind_issue = 0 if key == "uuid:33c5b9d4-3cf2-4d87-af16-2a2489b94563" & cereals_02_1 == 15750
replace ind_issue = 0 if key == "uuid:999e3d4e-a660-48e8-bfa2-146829966c60" & cereals_02_1 == 12800
replace ind_issue = 0 if key == "uuid:008de754-4ff1-43e5-ae4d-21d1760039e2" & cereals_02_1 == 23360
replace ind_issue = 0 if key == "uuid:9e068357-e209-4055-a615-2ceeefc71a06" & cereals_02_1 == -9
replace ind_issue = 0 if key == "uuid:5a4e7e21-f224-48e5-aece-7f9d297dae48" & cereals_02_1 == 40000
replace ind_issue = 0 if key == "uuid:af2fa2b6-d183-4406-8d00-4be4c168e97b" & cereals_02_1 == -9
replace ind_issue = 0 if key == "uuid:e60944ff-9e24-4e10-b4a2-8439cf1f4eb8" & cereals_02_1 == 11000
replace ind_issue = 0 if key == "uuid:397fd602-9a30-4d8b-a9ba-7f46497e6648" & cereals_02_1 == 70000
replace ind_issue = 0 if key == "uuid:46693568-4859-402d-ab33-9639f9622ca1" & cereals_02_1 == 31500
replace ind_issue = 0 if key == "uuid:5268be61-f198-4614-8dbe-6f18904c78be" & cereals_02_1 == 28000
replace ind_issue = 0 if key == "uuid:2b46e567-634a-45f4-abbd-e0174c03900d" & cereals_02_1 == 25000
replace ind_issue = 0 if key == "uuid:beafc02c-dc0d-4a2f-896e-e06ddfbebdab" & cereals_02_1 == 17700
replace ind_issue = 0 if key == "uuid:49e1ea67-b6bc-4685-822a-04e4963bbd19" & cereals_02_5 == -9
replace ind_issue = 0 if key == "uuid:f0d062cd-957e-4375-8a2f-41f4b30a0fb5" & cereals_03_1 == 1926  // added check
replace ind_issue = 0 if key == "uuid:98f1dac6-2c36-4dc8-871e-f1789e107d6a" & cereals_03_1 == 750
replace ind_issue = 0 if key == "uuid:a1261fd4-5c99-4e06-91c4-ac1072db7e5e" & cereals_03_1 == 500
replace ind_issue = 0 if key == "uuid:cc130465-b8d1-42da-929f-318c258f73e4" & cereals_03_1 == 425
replace ind_issue = 0 if key == "uuid:78d77a89-36f7-4c0f-8fef-22644a8e9c73" & cereals_03_1 == 5600
replace ind_issue = 0 if key == "uuid:ba158d3a-b1da-4b04-96c1-271049e9b4cb" & cereals_03_1 == 700
replace ind_issue = 0 if key == "uuid:6d59bac1-ae47-4d19-ae80-294dbf82865c" & cereals_03_1 == 2000
replace ind_issue = 0 if key == "uuid:844ab214-bd8f-4cfd-b13e-38ce3bba59a8" & cereals_03_1 == 800
replace ind_issue = 0 if key == "uuid:43aaed55-2d1c-45d6-913b-22726c7a9a26" & cereals_03_1 == 750
replace ind_issue = 0 if key == "uuid:1aafe562-4cb0-4a1f-b7e5-bd58f3386e6e" & cereals_03_1 == 100
replace ind_issue = 0 if key == "uuid:9c942a3d-fa44-4758-b268-c040b2ff1248" & cereals_03_1 == 3000
replace ind_issue = 0 if key == "uuid:705814d9-cf74-46eb-a1fd-38a61fde156b" & cereals_03_1 == 3500
replace ind_issue = 0 if key == "uuid:1ad4d263-f735-4d5b-898e-8449a23cbb09" & cereals_03_1 == 1000
replace ind_issue = 0 if key == "uuid:d3a0cf7d-87a7-4373-8b0a-a4a50df9cfa2" & cereals_03_1 == 800
replace ind_issue = 0 if key == "uuid:a2b50444-1316-4e2d-b47c-b3cbb7b7e46e" & cereals_03_1 == 420
replace ind_issue = 0 if key == "uuid:f9ca4556-2c20-499a-b7fb-03eb3be07b5d" & cereals_03_1 == 500
replace ind_issue = 0 if key == "uuid:41d0680a-3871-4f2a-92a6-52d45e652010" & cereals_03_1 == 1000
replace ind_issue = 0 if key == "uuid:ea66090c-4853-434a-8501-93e90526a596" & cereals_03_5 == 1000
replace ind_issue = 0 if key == "uuid:78d77a89-36f7-4c0f-8fef-22644a8e9c73" & cereals_04_1 == 2800 // added check
replace ind_issue = 0 if key == "uuid:43aaed55-2d1c-45d6-913b-22726c7a9a26" & cereals_04_1 == 75
replace ind_issue = 0 if key == "uuid:9c942a3d-fa44-4758-b268-c040b2ff1248" & cereals_04_1 == 3000
replace ind_issue = 0 if key == "uuid:705814d9-cf74-46eb-a1fd-38a61fde156b" & cereals_04_1 == 1000
replace ind_issue = 0 if key == "uuid:d3a0cf7d-87a7-4373-8b0a-a4a50df9cfa2" & cereals_04_1 == 300
replace ind_issue = 0 if key == "uuid:3b860b05-1279-4807-9ebb-cccdf410537f" & cereals_04_1 == 9500
replace ind_issue = 0 if key == "uuid:ee6bb3fb-0c11-44c0-ab45-561b54edfcdc" & cereals_04_1 == 6000
replace ind_issue = 0 if key == "uuid:9e068357-e209-4055-a615-2ceeefc71a06" & cereals_04_1 == 0
replace ind_issue = 0 if key == "uuid:e9086ca8-03e3-49fb-b7ca-01c40f858435" & cereals_04_6 == 8000
replace ind_issue = 0 if key == "uuid:43c5f3aa-5f3e-4087-98de-31d897566c82" & cereals_04_6 == 1400
replace ind_issue = 0 if key == "uuid:1ad4d263-f735-4d5b-898e-8449a23cbb09" & cereals_05_1 == -9  // added check
replace ind_issue = 0 if key == "uuid:e6efc18c-7a7b-4132-8535-6e7dff6a7ac7" & cereals_05_1 == -9
replace ind_issue = 0 if key == "uuid:49e1ea67-b6bc-4685-822a-04e4963bbd19" & cereals_05_5 == -9
replace ind_issue = 0 if key == "uuid:dc9a29e3-3292-4ed0-a27b-33446ca8640b" & farines_01_1 == -9 // added check
replace ind_issue = 0 if key == "uuid:dc9a29e3-3292-4ed0-a27b-33446ca8640b" & farines_01_2 == -9
replace ind_issue = 0 if key == "uuid:3b860b05-1279-4807-9ebb-cccdf410537f" & farines_02_1 == 20000 // added check
replace ind_issue = 0 if key == "uuid:b4648e61-1839-42d1-9890-4069ccce8a97" & farines_02_1 == 16000
replace ind_issue = 0 if key == "uuid:0b333cd2-bec2-4b5d-81c5-15186feebd5d" & farines_02_1 == 16000
replace ind_issue = 0 if key == "uuid:afbcea61-8389-4dcc-a18a-c3c3b5003b5e" & farines_02_1 == 24000
replace ind_issue = 0 if key == "uuid:ea6616da-cd59-45c8-aaba-089a3f0510aa" & farines_02_1 == 12800
replace ind_issue = 0 if key == "uuid:48f30fc0-4b45-4569-a86b-0f79df8b88b5" & farines_02_1 == 16000
replace ind_issue = 0 if key == "uuid:961dde11-cb73-4697-899a-402fcdb81403" & farines_02_1 == 16000
replace ind_issue = 0 if key == "uuid:73ed6f0b-339f-467c-98e2-270d4650a641" & farines_02_1 == -9
replace ind_issue = 0 if key == "uuid:dc9a29e3-3292-4ed0-a27b-33446ca8640b" & farines_02_1 == -9
replace ind_issue = 0 if key == "uuid:2a436357-13ff-4710-a749-b012d58d5685" & farines_02_1 == 60000
replace ind_issue = 0 if key == "uuid:04f3040a-9991-412d-9fce-9ee840eafcea" & farines_02_1 == -9
replace ind_issue = 0 if key == "uuid:6b2af6f0-abd9-40ce-8bb7-792c1e9e0e18" & farines_02_1 == -9
replace ind_issue = 0 if key == "uuid:5af529e5-54e6-40aa-96d8-39fff3fe8f29" & farines_02_1 == 12000
replace ind_issue = 0 if key == "uuid:02a39efd-23f1-4815-9b17-ff8b43173d90" & farines_02_1 == -9
replace ind_issue = 0 if key == "uuid:32246f7b-b517-478d-b4f2-f8ab414ee1b2" & farines_02_1 == -9
replace ind_issue = 0 if key == "uuid:33df7be4-7ed3-4333-b350-13d169e5f9e8" & farines_02_1 == -9
replace ind_issue = 0 if key == "uuid:abd77c0d-982e-4867-b847-9531494e4578" & farines_02_1 == 10400
replace ind_issue = 0 if key == "uuid:78498830-729b-4669-a8b0-ddb3ba898a73" & farines_02_1 == -9
replace ind_issue = 0 if key == "uuid:fe254168-10ee-4b8e-bfe5-5e3d6e47d26e" & farines_02_1 == 84000
replace ind_issue = 0 if key == "uuid:3edcedd7-4992-486e-a924-22eb67a877b3" & farines_02_1 == 30000
replace ind_issue = 0 if key == "uuid:a1ac2ac5-36fc-4a12-ac9b-45b86f0dc84e" & farines_02_1 == -9
replace ind_issue = 0 if key == "uuid:197be989-16e8-4ef0-b91f-a6cb3287c2d8" & farines_02_1 == 16000
replace ind_issue = 0 if key == "uuid:0ce7d392-22ca-4a4f-abd1-8bb9364ddaa4" & farines_02_2 == -9
replace ind_issue = 0 if key == "uuid:b23d6c34-7e39-4cb2-a08f-4e4731c59360" & farines_02_2 == 45290
replace ind_issue = 0 if key == "uuid:c67f0cf6-6d27-4792-9c4b-7aa0e5d75360" & farines_02_2 == 16000
replace ind_issue = 0 if key == "uuid:afbcea61-8389-4dcc-a18a-c3c3b5003b5e" & farines_02_2 == 24000
replace ind_issue = 0 if key == "uuid:48f30fc0-4b45-4569-a86b-0f79df8b88b5" & farines_02_2 == 20000
replace ind_issue = 0 if key == "uuid:dc9a29e3-3292-4ed0-a27b-33446ca8640b" & farines_02_2 == -9
replace ind_issue = 0 if key == "uuid:2a436357-13ff-4710-a749-b012d58d5685" & farines_02_2 == 70000
replace ind_issue = 0 if key == "uuid:53f60c19-7569-47c2-9423-ee4f516907c9" & farines_02_2 == -9
replace ind_issue = 0 if key == "uuid:0af345d0-6960-4805-899a-3123a7c1a547" & farines_02_2 == -9
replace ind_issue = 0 if key == "uuid:04f3040a-9991-412d-9fce-9ee840eafcea" & farines_02_2 == -9
replace ind_issue = 0 if key == "uuid:6b2af6f0-abd9-40ce-8bb7-792c1e9e0e18" & farines_02_2 == 12000
replace ind_issue = 0 if key == "uuid:5af529e5-54e6-40aa-96d8-39fff3fe8f29" & farines_02_2 == 14400
replace ind_issue = 0 if key == "uuid:17b1c705-ed89-443b-8ddc-4ca93f033edd" & farines_02_2 == 18000
replace ind_issue = 0 if key == "uuid:02a39efd-23f1-4815-9b17-ff8b43173d90" & farines_02_2 == -9
replace ind_issue = 0 if key == "uuid:d0347b16-5aee-4340-b320-cdd8a2cc8196" & farines_02_2 == -9
replace ind_issue = 0 if key == "uuid:78498830-729b-4669-a8b0-ddb3ba898a73" & farines_02_2 == -9
replace ind_issue = 0 if key == "uuid:a1ac2ac5-36fc-4a12-ac9b-45b86f0dc84e" & farines_02_2 == -9
replace ind_issue = 0 if key == "uuid:d0347b16-5aee-4340-b320-cdd8a2cc8196" & farines_04_1 == 79760 // added to check
replace ind_issue = 0 if key == "uuid:5af529e5-54e6-40aa-96d8-39fff3fe8f29" & farines_04_2 == 14420
replace ind_issue = 0 if key == "uuid:c52e24f8-ed96-47bd-8406-da314b553399" & health_5_12 == 300  // added to check
replace ind_issue = 0 if key == "uuid:c52e24f8-ed96-47bd-8406-da314b553399" & health_5_12 == 300
replace ind_issue = 0 if key == "uuid:a63d364d-8238-4c51-a32c-a0b5c9ec3e6a" & health_5_12 == -9
replace ind_issue = 0 if key == "uuid:a63d364d-8238-4c51-a32c-a0b5c9ec3e6a" & health_5_12 == -9
replace ind_issue = 0 if key == "uuid:a63d364d-8238-4c51-a32c-a0b5c9ec3e6a" & health_5_12 == -9
replace ind_issue = 0 if key == "uuid:a63d364d-8238-4c51-a32c-a0b5c9ec3e6a" & health_5_12 == -9
replace ind_issue = 0 if key == "uuid:a63d364d-8238-4c51-a32c-a0b5c9ec3e6a" & health_5_12 == -9
replace ind_issue = 0 if key == "uuid:a63d364d-8238-4c51-a32c-a0b5c9ec3e6a" & health_5_12 == -9
replace ind_issue = 0 if key == "uuid:a63d364d-8238-4c51-a32c-a0b5c9ec3e6a" & health_5_12 == -9
replace ind_issue = 0 if key == "uuid:a63d364d-8238-4c51-a32c-a0b5c9ec3e6a" & health_5_12 == -9
replace ind_issue = 0 if key == "uuid:a63d364d-8238-4c51-a32c-a0b5c9ec3e6a" & health_5_12 == -9
replace ind_issue = 0 if key == "uuid:a63d364d-8238-4c51-a32c-a0b5c9ec3e6a" & health_5_12 == -9
replace ind_issue = 0 if key == "uuid:a63d364d-8238-4c51-a32c-a0b5c9ec3e6a" & health_5_12 == -9
replace ind_issue = 0 if key == "uuid:a63d364d-8238-4c51-a32c-a0b5c9ec3e6a" & health_5_12 == -9
replace ind_issue = 0 if key == "uuid:a63d364d-8238-4c51-a32c-a0b5c9ec3e6a" & health_5_12 == -9
replace ind_issue = 0 if key == "uuid:a63d364d-8238-4c51-a32c-a0b5c9ec3e6a" & health_5_12 == -9
replace ind_issue = 0 if key == "uuid:a63d364d-8238-4c51-a32c-a0b5c9ec3e6a" & health_5_12 == -9
replace ind_issue = 0 if key == "uuid:a63d364d-8238-4c51-a32c-a0b5c9ec3e6a" & health_5_12 == -9
replace ind_issue = 0 if key == "uuid:c061f456-3a81-4ff0-a269-fd05569d9747" & health_5_12 == 500
replace ind_issue = 0 if key == "uuid:c061f456-3a81-4ff0-a269-fd05569d9747" & health_5_12 == 500
replace ind_issue = 0 if key == "uuid:8294761e-3bcd-4a16-9dab-14913b5f9e2a" & health_5_12 == 400
replace ind_issue = 0 if key == "uuid:8294761e-3bcd-4a16-9dab-14913b5f9e2a" & health_5_12 == 400
replace ind_issue = 0 if key == "uuid:0ce7d392-22ca-4a4f-abd1-8bb9364ddaa4" & health_5_12 == 200
replace ind_issue = 0 if key == "uuid:0ce7d392-22ca-4a4f-abd1-8bb9364ddaa4" & health_5_12 == 200
replace ind_issue = 0 if key == "uuid:32489a2a-4606-4b8b-85ba-3345d9bb229f" & health_5_12 == 250
replace ind_issue = 0 if key == "uuid:32489a2a-4606-4b8b-85ba-3345d9bb229f" & health_5_12 == 250
replace ind_issue = 0 if key == "uuid:896ef294-6ea0-45d0-9468-3f1bdf54924e" & health_5_12 == 200
replace ind_issue = 0 if key == "uuid:896ef294-6ea0-45d0-9468-3f1bdf54924e" & health_5_12 == 200
replace ind_issue = 0 if key == "uuid:a0af735e-1a67-40ea-b4f4-c65fb5b58ed0" & health_5_12 == 300
replace ind_issue = 0 if key == "uuid:9cf0b8bc-d0cc-4396-9711-d75336bdabfd" & health_5_12 == 250
replace ind_issue = 0 if key == "uuid:63027ea6-4db1-4d75-9e50-07102ad7e66d" & health_5_12 == 400
replace ind_issue = 0 if key == "uuid:63027ea6-4db1-4d75-9e50-07102ad7e66d" & health_5_12 == 200
replace ind_issue = 0 if key == "uuid:a0af735e-1a67-40ea-b4f4-c65fb5b58ed0" & health_5_12 == 300
replace ind_issue = 0 if key == "uuid:63027ea6-4db1-4d75-9e50-07102ad7e66d" & health_5_12 == 400
replace ind_issue = 0 if key == "uuid:201c00d0-75bc-4b0a-8e70-feecab62c8e0" & health_5_12 == 156
replace ind_issue = 0 if key == "uuid:63027ea6-4db1-4d75-9e50-07102ad7e66d" & health_5_12 == 200
replace ind_issue = 0 if key == "uuid:dadd5583-da49-40ff-8eab-3f60938c143f" & health_5_12 == 300
replace ind_issue = 0 if key == "uuid:dadd5583-da49-40ff-8eab-3f60938c143f" & health_5_12 == 300
replace ind_issue = 0 if key == "uuid:a0748e74-08de-480e-a3ff-9a5f8555215b" & health_5_12 == -9
replace ind_issue = 0 if key == "uuid:4ea2408a-89a2-4bd4-8bac-9a8ebbffadd7" & hh_14_a_1 == -9 // added to check
replace ind_issue = 0 if key == "uuid:eb71f1ee-5f44-4a52-926b-7db730824f49" & hh_14_a_13 == -9
replace ind_issue = 0 if key == "uuid:3a65ea13-ff58-41d9-bdc8-988bba593355" & hh_14_a_2 == -9
replace ind_issue = 0 if key == "uuid:5ed16c12-52c1-46e2-a6c4-8ad9c28cfbeb" & hh_14_a_2 == -9
replace ind_issue = 0 if key == "uuid:dedd712c-634c-4665-a874-f139341ecd5f" & hh_14_a_5 == -9
replace ind_issue = 0 if key == "uuid:20bb7007-297f-432d-8909-7bea1973059d" & hh_14_a_8 == -9
replace ind_issue = 0 if key == "uuid:dedd712c-634c-4665-a874-f139341ecd5f" & hh_14_a_8 == -9
replace ind_issue = 0 if key == "uuid:f0bebe93-a4f0-40a0-8936-233682b356d1" & hh_14_b_2 == -9 // added to check
replace ind_issue = 0 if key == "uuid:8915a062-0f9a-4c85-a7a6-1b4fa6b3e3f1" & hh_14_b_3 == -9
replace ind_issue = 0 if key == "uuid:8915a062-0f9a-4c85-a7a6-1b4fa6b3e3f1" & hh_14_b_5 == -9
replace ind_issue = 0 if key == "uuid:dedd712c-634c-4665-a874-f139341ecd5f" & hh_14_b_5 == -9
replace ind_issue = 0 if key == "uuid:20bb7007-297f-432d-8909-7bea1973059d" & hh_14_b_8 == -9
replace ind_issue = 0 if key == "uuid:dedd712c-634c-4665-a874-f139341ecd5f" & hh_14_b_8 == -9
replace ind_issue = 0 if key == "uuid:45e97396-5ee5-4b55-ac86-cbd4824e8263" & hh_41_1 == 6  // added to check
replace ind_issue = 0 if key == "uuid:9559913d-fb26-4d88-a5f2-27f2142af0ee" & hh_41_1 == 10
replace ind_issue = 0 if key == "uuid:db27b6db-6d41-4805-b954-5206411f2e37" & hh_41_1 == 7
replace ind_issue = 0 if key == "uuid:d18cf803-5676-4b48-8cde-8d83bd2d9a7b" & hh_41_1 == 7
replace ind_issue = 0 if key == "uuid:f0c88bdb-6402-4d30-9bac-69dbd3c847b2" & hh_41_10 == 7
replace ind_issue = 0 if key == "uuid:93850388-81f9-49ac-a75c-64fadc48d46b" & hh_41_12 == 6
replace ind_issue = 0 if key == "uuid:4839ecdd-b500-45b6-92b0-aa6ed8f890de" & hh_41_12 == 7
replace ind_issue = 0 if key == "uuid:e35717b1-f96e-4f9a-a5c4-0ac0981f3d28" & hh_41_14 == 6
replace ind_issue = 0 if key == "uuid:de358167-c62b-4063-830a-a3f52a40516e" & hh_41_17 == 7
replace ind_issue = 0 if key == "uuid:34d8c58a-a617-487a-b010-93ea0b8dc111" & hh_41_2 == 7
replace ind_issue = 0 if key == "uuid:272f19bb-809d-43d4-bae9-d3bcfb6ac22b" & hh_41_2 == 6
replace ind_issue = 0 if key == "uuid:f46febb7-4f27-4491-8bcb-e26865df976b" & hh_41_2 == 6
replace ind_issue = 0 if key == "uuid:28e5893e-1205-4647-b375-2ab2e07290f8" & hh_41_2 == 6
replace ind_issue = 0 if key == "uuid:fa6b632a-58f0-4bc1-a921-5abb0680d79e" & hh_41_22 == 7
replace ind_issue = 0 if key == "uuid:6ad3f4d8-0bc2-43c2-b6d8-3fb8114647f8" & hh_41_3 == 7
replace ind_issue = 0 if key == "uuid:98a31235-4316-4246-b7f6-8ce887c860fb" & hh_41_4 == 6
replace ind_issue = 0 if key == "uuid:464e7c98-71a8-4774-a1db-820c4ca30c91" & hh_41_4 == 7
replace ind_issue = 0 if key == "uuid:e2b253d2-9e6d-44f3-8916-4797bf2f8177" & hh_41_4 == 7
replace ind_issue = 0 if key == "uuid:df66612e-0d16-4894-88d5-33580308ec91" & hh_41_4 == 5
replace ind_issue = 0 if key == "uuid:bd1911e9-4cde-45a5-8f06-cea7ef72c905" & hh_41_5 == 6
replace ind_issue = 0 if key == "uuid:d7add78b-5c6b-4f09-a15b-ee9ff0de69e8" & hh_41_5 == 6
replace ind_issue = 0 if key == "uuid:6d59bac1-ae47-4d19-ae80-294dbf82865c" & hh_41_5 == 7
replace ind_issue = 0 if key == "uuid:3b9fe083-0a4e-4db1-8c63-b494c53d403a" & hh_41_5 == 5
replace ind_issue = 0 if key == "uuid:41e60432-f713-4dd5-8c23-dce0e4f5116d" & hh_41_5 == 7
replace ind_issue = 0 if key == "uuid:b523b6ee-b33f-4331-ac8e-e3770b31148e" & hh_41_5 == 7
replace ind_issue = 0 if key == "uuid:fa6b632a-58f0-4bc1-a921-5abb0680d79e" & hh_41_6 == 7
replace ind_issue = 0 if key == "uuid:ca054a55-5420-49cc-b0cd-2a077889231b" & hh_41_6 == 7
replace ind_issue = 0 if key == "uuid:bc23d519-8a2a-476f-9c2f-029d70938a8a" & hh_41_6 == 7
replace ind_issue = 0 if key == "uuid:b0a54e9c-c1e3-4274-8dd3-f3e452663310" & hh_41_6 == 7
replace ind_issue = 0 if key == "uuid:798f8ec4-a21b-4154-ab79-d19b423425a3" & hh_41_7 == 7
replace ind_issue = 0 if key == "uuid:a6218164-0bc6-47bc-b937-15e0f66a0a1a" & hh_41_7 == 7
replace ind_issue = 0 if key == "uuid:05442505-66f5-4640-8f5a-fa86f34dbd12" & hh_41_8 == 7
replace ind_issue = 0 if key == "uuid:715348c5-4975-4ab4-9299-efc393087ce8" & hh_41_9 == 6
replace ind_issue = 0 if key == "uuid:e35717b1-f96e-4f9a-a5c4-0ac0981f3d28" & hh_41_9 == 6
replace ind_issue = 0 if key == "uuid:d821e832-2f31-4039-9003-20d913da3311" & hh_age_1 == 92 // added to check
replace ind_issue = 0 if key == "uuid:e6aa7e36-c770-4ee8-be3d-4de123c20a17" & hh_age_1 == 92
replace ind_issue = 0 if key == "uuid:2640003a-e439-43ff-a45f-723739ead318" & hh_age_2 == 91
replace ind_issue = 0 if key == "uuid:e8949caf-47ee-4e5e-8b89-3eced60feb3d" & hh_age_3 == 99
replace ind_issue = 0 if key == "uuid:274749b0-85ce-4907-97b2-f15fae16e9bb" & hh_age_3 == 95
replace ind_issue = 0 if key == "uuid:c5be1602-4373-4562-8647-30703fddb2d2" & hh_age_5 == 91
replace ind_issue = 0 if key == "uuid:6bc3c04b-1957-4811-8f2f-2c62506708f3" & hh_age_5 == 92
replace ind_issue = 0 if key == "uuid:443cfabd-f98c-4336-8e20-80f8957bad20" & hh_age_8 == -9
replace ind_issue = 0 if key == "uuid:22a38dae-c26f-4f93-ada7-e4904a6bcea5" & hh_education_level_1 == 4 // added to check
replace ind_issue = 0 if key == "uuid:c5a9ad94-512d-4d5e-86be-32bbaea376a8" & hh_education_level_13 == 3
replace ind_issue = 0 if key == "uuid:102325d0-e44c-43d8-bf45-03fc0d4bbeeb" & hh_education_level_2 == 3
replace ind_issue = 0 if key == "uuid:544b9ce9-1148-4de4-8682-e7a053bc55f6" & hh_education_level_4 == 4
replace ind_issue = 0 if key == "uuid:4b9d032f-e2ac-4e4f-b7f2-bad5b9917eaf" & hh_education_level_4 == 3
replace ind_issue = 0 if key == "uuid:924ae568-e479-4dc0-9311-dd77acb165c1" & hh_education_level_5 == 3
replace ind_issue = 0 if key == "uuid:63d42e02-d823-4062-97c5-479202f66254" & hh_education_level_5 == 3
replace ind_issue = 0 if key == "uuid:749d6e2c-6917-439f-8e0a-ac743dee1e1d" & hh_education_level_5 == 3
replace ind_issue = 0 if key == "uuid:140ccd1f-98cc-4f31-ae6e-948f6b7c88c8" & hh_education_level_5 == 3
replace ind_issue = 0 if key == "uuid:c5a9ad94-512d-4d5e-86be-32bbaea376a8" & hh_education_level_6 == 3
replace ind_issue = 0 if key == "uuid:ce4348d4-f8dc-4f45-859b-f7fb9e9c8222" & hh_education_level_7 == 3
replace ind_issue = 0 if key == "uuid:fe78ae3a-df95-4ba8-9205-133a78bb7675" & hh_education_level_8 == 3
replace ind_issue = 0 if key == "uuid:dc9a29e3-3292-4ed0-a27b-33446ca8640b" & legumes_01_1 == -9    // added to check
replace ind_issue = 0 if key == "uuid:a174f3ae-1533-4f24-9056-c76dc2c8ec40" & legumes_01_3 == -9
replace ind_issue = 0 if key == "uuid:c842e94c-b701-4bbf-828b-d9af9842e9f4" & legumes_02_1 == -9 // added to check
replace ind_issue = 0 if key == "uuid:f3fc7fa3-cc52-48a4-b153-e65733a5a392" & legumes_02_1 == -9 
replace ind_issue = 0 if key == "uuid:12b6f47f-aa90-4a91-95c0-ea66bcfb624d" & legumes_02_1 == -9
replace ind_issue = 0 if key == "uuid:9774e27c-e111-4b39-ad7c-13f19c44e2b1" & legumes_02_1 == 12500
replace ind_issue = 0 if key == "uuid:f22d73d4-c964-43e2-b0f8-0b7af4a740cc" & legumes_02_1 == 36000
replace ind_issue = 0 if key == "uuid:5e72ce0f-a07d-4bcd-8618-d32576e05c8b" & legumes_02_1 == 16510
replace ind_issue = 0 if key == "uuid:340107c5-0475-4534-987f-e832e89a582e" & legumes_02_1 == 23608
replace ind_issue = 0 if key == "uuid:2dc17631-28de-444c-9bfc-c72efb9e0a75" & legumes_02_1 == 16200
replace ind_issue = 0 if key == "uuid:ce7d41d9-bce1-4508-a02f-abf2b1b3185d" & legumes_02_1 == 25060
replace ind_issue = 0 if key == "uuid:dc9a29e3-3292-4ed0-a27b-33446ca8640b" & legumes_02_1 == -9
replace ind_issue = 0 if key == "uuid:88167bbe-853b-48b8-a3f9-6bbb02c12309" & legumes_02_1 == -9
replace ind_issue = 0 if key == "uuid:396c8c59-7475-4da5-9fb2-c3531077ab31" & legumes_02_1 == -9
replace ind_issue = 0 if key == "uuid:919061ac-5092-4d95-9642-a8f59bbdc4f9" & legumes_02_1 == -9
replace ind_issue = 0 if key == "uuid:6fc043eb-a620-4e71-bd62-850b4b3b79cd" & legumes_02_1 == 22400
replace ind_issue = 0 if key == "uuid:97dc0ddf-0488-42f5-93b3-1a9a7a87392d" & legumes_02_1 == 10500
replace ind_issue = 0 if key == "uuid:d64a294e-43b9-44cd-aab0-d14bc88d71de" & legumes_02_1 == 875000
replace ind_issue = 0 if key == "uuid:08f0ed54-98f9-4427-9b44-4e660b0b587d" & legumes_02_1 == 12000
replace ind_issue = 0 if key == "uuid:397fd602-9a30-4d8b-a9ba-7f46497e6648" & legumes_02_1 == 16000
replace ind_issue = 0 if key == "uuid:07374a46-8b35-4535-8e7f-aee405e62880" & legumes_02_2 == -9
replace ind_issue = 0 if key == "uuid:c842e94c-b701-4bbf-828b-d9af9842e9f4" & legumes_02_3 == -9
replace ind_issue = 0 if key == "uuid:eed2c8e6-e74f-4fe9-b790-665dbdd4c54d" & legumes_02_3 == -9
replace ind_issue = 0 if key == "uuid:e5eb596e-392d-43e1-8ac5-19f7993e9401" & legumes_02_3 == -9
replace ind_issue = 0 if key == "uuid:9774e27c-e111-4b39-ad7c-13f19c44e2b1" & legumes_02_3 == 17500
replace ind_issue = 0 if key == "uuid:b4648e61-1839-42d1-9890-4069ccce8a97" & legumes_02_3 == 25000
replace ind_issue = 0 if key == "uuid:a174f3ae-1533-4f24-9056-c76dc2c8ec40" & legumes_02_3 == -9
replace ind_issue = 0 if key == "uuid:a7a54357-649f-4f1e-b7f1-ca2977436360" & legumes_02_3 == -9
replace ind_issue = 0 if key == "uuid:4230989a-8a58-4ea0-a832-181386899bf5" & legumes_02_3 == -9
replace ind_issue = 0 if key == "uuid:15a3df40-050c-48aa-b4bb-339077411dba" & legumes_02_3 == 20000
replace ind_issue = 0 if key == "uuid:08f0ed54-98f9-4427-9b44-4e660b0b587d" & legumes_02_3 == 16000
replace ind_issue = 0 if key == "uuid:397fd602-9a30-4d8b-a9ba-7f46497e6648" & legumes_02_3 == -9
replace ind_issue = 0 if key == "uuid:abb87752-4a63-446c-9b08-114b67de3f6e" & legumes_02_4 == -9
replace ind_issue = 0 if key == "uuid:90310a87-9d8f-4524-b415-99b443a9cd71" & legumes_02_6 == 18000
replace ind_issue = 0 if key == "uuid:08f0ed54-98f9-4427-9b44-4e660b0b587d" & legumes_02_6 == 12000
replace ind_issue = 0 if key == "uuid:397fd602-9a30-4d8b-a9ba-7f46497e6648" & legumes_03_3 == 150  // added to checks
replace ind_issue = 0 if key == "uuid:a6aa6572-4ca2-4c8d-8be7-3027d7d09a1b" & legumes_04_6 == 250 // added to checks
replace ind_issue = 0 if key == "uuid:dc9a29e3-3292-4ed0-a27b-33446ca8640b" & legumes_05_1 == -9 // added to checks
replace ind_issue = 0 if key == "uuid:a174f3ae-1533-4f24-9056-c76dc2c8ec40" & legumes_05_3 == -9
replace ind_issue = 0 if key == "uuid:abb87752-4a63-446c-9b08-114b67de3f6e" & legumes_05_4 == -9
replace ind_issue = 0 if key == "uuid:8b114889-8bbb-45c2-94f2-eb752a16fe0e" & legumineuses_01_1 == -9 // added to checks
replace ind_issue = 0 if key == "uuid:0b333cd2-bec2-4b5d-81c5-15186feebd5d" & legumineuses_02_1 == 16000
replace ind_issue = 0 if key == "uuid:d5c7ff2b-5a98-48e6-ab1c-afdf20b145df" & legumineuses_02_1 == 16000
replace ind_issue = 0 if key == "uuid:8b114889-8bbb-45c2-94f2-eb752a16fe0e" & legumineuses_02_1 == -9
replace ind_issue = 0 if key == "uuid:88167bbe-853b-48b8-a3f9-6bbb02c12309" & legumineuses_02_1 == -9
replace ind_issue = 0 if key == "uuid:0be6fc2e-5699-49b5-9b31-d924e7ad7581" & legumineuses_02_1 == -9
replace ind_issue = 0 if key == "uuid:26971b58-f29b-4ca2-835b-f25a19f057c3" & legumineuses_02_1 == -9
replace ind_issue = 0 if key == "uuid:32246f7b-b517-478d-b4f2-f8ab414ee1b2" & legumineuses_02_1 == -9
replace ind_issue = 0 if key == "uuid:3edcedd7-4992-486e-a924-22eb67a877b3" & legumineuses_02_1 == 13500
replace ind_issue = 0 if key == "uuid:8ca82313-2f21-45dd-9c4b-6cd68d8052a8" & legumineuses_02_5 == -9
replace ind_issue = 0 if key == "uuid:a9b198b5-e8e9-457d-9967-1ac777669d76" & legumineuses_02_5 == -9
replace ind_issue = 0 if key == "uuid:20bb7007-297f-432d-8909-7bea1973059d" & o_culture_04 == 400
*/

* Part 2
import excel "$corrections\Part2_Household_Issues_19Feb2025.xlsx", clear firstrow

* those not highlighted by amina
keep if !(key == "uuid:01639e53-ecd4-43fe-bf12-bd59d60e79e6" & correct == "48" | key == "uuid:a9b198b5-e8e9-457d-9967-1ac777669d76" & corrected == "42")


**** Export the confirmed... and use the following excel formula to add to the checks to skip over these for now
save "$corrected\DISES_Household_Corrections_Confirmed_Part2.dta", replace
export delimited "$corrected\DISES_Household_Corrections_Confirmed_Part2.csv", replace


* use excel formula
* ="replace ind_issue = 0 if key == "&CHAR(34)&[[key]]&CHAR(34)&" & "&[[issue_variable_name]]&" == "&[[corrected]]
/*
replace ind_issue = 0 if key == "uuid:4d6f8ba3-921e-4c44-b880-7c26e5bd52b9" & hh_13_10_total == 12
replace ind_issue = 0 if key == "uuid:91ba8b33-fa95-4775-bf72-c0e18499736c" & hh_13_1_total == 0
replace ind_issue = 0 if key == "uuid:ed4a3ab3-eb94-46fa-8ca7-d4305cf8e36e" & hh_13_1_total == 6
replace ind_issue = 0 if key == "uuid:ed4a3ab3-eb94-46fa-8ca7-d4305cf8e36e" & hh_13_2_total == 7
replace ind_issue = 0 if key == "uuid:2c43c97e-4854-45f3-acb7-49a56e4a5276" & hh_13_2_total == 12
replace ind_issue = 0 if key == "uuid:5e203451-1121-4391-83f9-590148136101" & hh_13_5_total == 5
replace ind_issue = 0 if key == "uuid:610ca467-4669-42cf-83bd-036cfcbef797" & hh_13_5_total == 7
replace ind_issue = 0 if key == "uuid:6fc34a13-7455-46b5-9d1a-5bafa2e11b9e" & hh_13_5_total == 4
replace ind_issue = 0 if key == "uuid:54cf3fe4-e1ce-42cb-9d5e-145583555e00" & hh_13_5_total == 30
replace ind_issue = 0 if key == "uuid:22a38dae-c26f-4f93-ada7-e4904a6bcea5" & hh_13_6_total == 7
replace ind_issue = 0 if key == "uuid:c7ecc3c7-f961-4f01-a59e-519ce6d7b325" & hh_13_6_total == 0
replace ind_issue = 0 if key == "uuid:4887e397-f600-4e7f-93cb-6c20c8aeaf2a" & hh_13_7_total == 0
replace ind_issue = 0 if key == "uuid:9da62ab2-6426-4bbe-8665-003c0a00080f" & hh_13_8_total == 4
replace ind_issue = 0 if key == "uuid:2c43c97e-4854-45f3-acb7-49a56e4a5276" & hh_13_8_total == 4
replace ind_issue = 0 if key == "uuid:d84a37d5-09e5-45ee-94fc-da2954f60d2b" & hh_13_1_total == 14
replace ind_issue = 0 if key == "uuid:202a0a2f-288d-4913-a1c0-51628440129d" & hh_13_1_total == 35
replace ind_issue = 0 if key == "uuid:83b54118-2059-4722-ba2b-bc8b6fff02ea" & hh_13_1_total == 42
replace ind_issue = 0 if key == "uuid:cda122cf-9280-432d-a1a8-8b7d8c4948f9" & hh_13_2_total == 0
replace ind_issue = 0 if key == "uuid:06f20c08-d76a-498a-ba77-dadca0993fb9" & hh_13_2_total == 6
replace ind_issue = 0 if key == "uuid:57bb8e54-caf8-49c9-a0f5-fd636d2a2592" & hh_13_2_total == 4
replace ind_issue = 0 if key == "uuid:07815cfd-fc9e-42e6-823e-83d93c2b9461" & hh_13_3_total == 64
replace ind_issue = 0 if key == "uuid:950634d7-6af7-48f4-81f2-23e84812d304" & hh_13_4_total == 45
replace ind_issue = 0 if key == "uuid:07815cfd-fc9e-42e6-823e-83d93c2b9461" & hh_13_4_total == 12
replace ind_issue = 0 if key == "uuid:8f49e817-68d3-4a92-98c6-02ed3739a07f" & hh_13_4_total == 8
replace ind_issue = 0 if key == "uuid:715348c5-4975-4ab4-9299-efc393087ce8" & hh_13_5_total == 10
replace ind_issue = 0 if key == "uuid:230eeec0-f4e6-476f-a49b-68a540e6612e" & hh_13_8_total == 3
replace ind_issue = 0 if key == "uuid:36cc7c65-9580-4182-92d9-ddda36fbb0ea" & hh_13_9_total == 3
replace ind_issue = 0 if key == "uuid:ab4bc620-6e26-47f3-9530-e99a2768597e" & hh_13_10_total == 15
replace ind_issue = 0 if key == "uuid:f72c4194-1658-4baa-9e40-7e6b0ea2b3a8" & hh_13_10_total == 5
replace ind_issue = 0 if key == "uuid:ab4bc620-6e26-47f3-9530-e99a2768597e" & hh_13_11_total == 7
replace ind_issue = 0 if key == "uuid:d27907d8-f6aa-4b80-81cc-9a1006e1012e" & hh_13_12_total == 14
replace ind_issue = 0 if key == "uuid:f72c4194-1658-4baa-9e40-7e6b0ea2b3a8" & hh_13_13_total == 5
replace ind_issue = 0 if key == "uuid:ce006143-d00a-48fd-928c-252e34c0cec8" & hh_13_1_total == 7
replace ind_issue = 0 if key == "uuid:c1f669a3-8c71-4496-ad2a-48299f1252fa" & hh_13_1_total == 18
replace ind_issue = 0 if key == "uuid:ae96b0a8-e61f-45f0-acdb-dfd03bcaa73f" & hh_13_1_total == 23
replace ind_issue = 0 if key == "uuid:94fc3496-7082-49fc-92ff-c1f97c2200fa" & hh_13_1_total == 9
replace ind_issue = 0 if key == "uuid:7e856dd9-4999-4581-8a10-a211bb7e63b4" & hh_13_1_total == 16
replace ind_issue = 0 if key == "uuid:3d62ede2-09be-4490-8ccf-918371d1b1b9" & hh_13_1_total == 7
replace ind_issue = 0 if key == "uuid:f72c4194-1658-4baa-9e40-7e6b0ea2b3a8" & hh_13_1_total == 19
replace ind_issue = 0 if key == "uuid:0b0fb3f0-5253-417a-a40c-b4225652ad7f" & hh_13_1_total == 36
replace ind_issue = 0 if key == "uuid:f72c4194-1658-4baa-9e40-7e6b0ea2b3a8" & hh_13_2_total == 30
replace ind_issue = 0 if key == "uuid:0b0fb3f0-5253-417a-a40c-b4225652ad7f" & hh_13_2_total == 63
replace ind_issue = 0 if key == "uuid:b9e97e2c-cb4b-4f65-8865-ff559d932464" & hh_13_2_total == 28
replace ind_issue = 0 if key == "uuid:f27e2583-e9b9-4b03-bc4f-a56b8bf18447" & hh_13_3_total == 2
replace ind_issue = 0 if key == "uuid:7e856dd9-4999-4581-8a10-a211bb7e63b4" & hh_13_3_total == 17
replace ind_issue = 0 if key == "uuid:0b0fb3f0-5253-417a-a40c-b4225652ad7f" & hh_13_3_total == 16
replace ind_issue = 0 if key == "uuid:6edd5242-6e3f-4e36-90b5-05a461dc952b" & hh_13_3_total == 24
replace ind_issue = 0 if key == "uuid:e4d9ab46-b30f-4d93-a47b-9b0e1c367d58" & hh_13_3_total == 14
replace ind_issue = 0 if key == "uuid:ac4e0095-40d2-4290-94b4-14930802dbd0" & hh_13_3_total == 3
replace ind_issue = 0 if key == "uuid:a58331c4-b5ce-40a8-af97-c1e0292d8ef1" & hh_13_3_total == 2
replace ind_issue = 0 if key == "uuid:e226d02b-cb74-42c9-bfd2-cfd2ef823aa2" & hh_13_3_total == 42
replace ind_issue = 0 if key == "uuid:94d8e8c9-df2a-466b-b173-f7d1403ac905" & hh_13_4_total == 18
replace ind_issue = 0 if key == "uuid:05e470c2-03bd-4546-9072-21f897c957b0" & hh_13_4_total == 6
replace ind_issue = 0 if key == "uuid:f27e2583-e9b9-4b03-bc4f-a56b8bf18447" & hh_13_4_total == 30
replace ind_issue = 0 if key == "uuid:0e156f00-686e-43cf-b85f-b72427ea07ea" & hh_13_5_total == 17
replace ind_issue = 0 if key == "uuid:94d8e8c9-df2a-466b-b173-f7d1403ac905" & hh_13_5_total == 8
replace ind_issue = 0 if key == "uuid:7eb66aa0-0169-41c4-a623-c4e0dcd139b5" & hh_13_5_total == 13
replace ind_issue = 0 if key == "uuid:e4d9ab46-b30f-4d93-a47b-9b0e1c367d58" & hh_13_6_total == 14
replace ind_issue = 0 if key == "uuid:f72c4194-1658-4baa-9e40-7e6b0ea2b3a8" & hh_13_7_total == 5
replace ind_issue = 0 if key == "uuid:e4d9ab46-b30f-4d93-a47b-9b0e1c367d58" & hh_13_7_total == 16
replace ind_issue = 0 if key == "uuid:94d8e8c9-df2a-466b-b173-f7d1403ac905" & hh_13_7_total == 32
replace ind_issue = 0 if key == "uuid:ae96b0a8-e61f-45f0-acdb-dfd03bcaa73f" & hh_13_7_total == 14
replace ind_issue = 0 if key == "uuid:b9e97e2c-cb4b-4f65-8865-ff559d932464" & hh_13_7_total == 63
replace ind_issue = 0 if key == "uuid:f72c4194-1658-4baa-9e40-7e6b0ea2b3a8" & hh_13_8_total == 12
replace ind_issue = 0 if key == "uuid:0b9db113-4ef6-466e-80d0-190be268de07" & hh_13_8_total == 32
replace ind_issue = 0 if key == "uuid:fa7f73fd-c387-457f-99aa-da844bb4e83e" & hh_13_1_total == 4
replace ind_issue = 0 if key == "uuid:4d26f521-80a5-4da0-8826-f6bdaa39fac4" & hh_13_1_total == 4
replace ind_issue = 0 if key == "uuid:6c3a3767-95be-47d7-a5d3-7e893c18ac0f" & hh_13_1_total == 6
replace ind_issue = 0 if key == "uuid:0ce7d392-22ca-4a4f-abd1-8bb9364ddaa4" & hh_13_1_total == 5
replace ind_issue = 0 if key == "uuid:a4e17fab-1883-4ce7-ae61-d89165dce193" & hh_13_1_total == 5
replace ind_issue = 0 if key == "uuid:9bd0d7cb-a3b9-4ef9-a83c-e48bb8791500" & hh_13_1_total == 5
replace ind_issue = 0 if key == "uuid:acaacc67-ef2f-4d73-a0fa-a58ca30c2153" & hh_13_2_total == 10
replace ind_issue = 0 if key == "uuid:f0e95d05-f703-4242-bb05-cdf1c7be4e16" & hh_13_2_total == 7
replace ind_issue = 0 if key == "uuid:276b30ac-8a01-4e01-8a96-2f23dc4001f8" & hh_13_3_total == 0
replace ind_issue = 0 if key == "uuid:04f82d4c-d64b-4f3d-b127-21f022dd526b" & hh_13_4_total == 8
replace ind_issue = 0 if key == "uuid:17dd2ae2-270d-40a2-8904-226e20abc4f2" & hh_13_4_total == 3
replace ind_issue = 0 if key == "uuid:bff7956c-0e63-4cf7-b6f8-abf16a8c0276" & hh_13_5_total == 0
replace ind_issue = 0 if key == "uuid:2ce3ed31-0439-4336-942e-3885ce4ca0b4" & hh_13_5_total == 3
replace ind_issue = 0 if key == "uuid:7c39851f-d41d-4438-830c-7df92cf9c209" & hh_13_5_total == 10
replace ind_issue = 0 if key == "uuid:1bf03019-0fe3-4171-bf36-5ee1cbc502f5" & hh_13_6_total == 5
replace ind_issue = 0 if key == "uuid:acaacc67-ef2f-4d73-a0fa-a58ca30c2153" & hh_13_6_total == 8
replace ind_issue = 0 if key == "uuid:93743604-01c7-48c5-a295-3242254348b6" & hh_13_7_total == 6
replace ind_issue = 0 if key == "uuid:f0e95d05-f703-4242-bb05-cdf1c7be4e16" & hh_13_7_total == 0
replace ind_issue = 0 if key == "uuid:2ce3ed31-0439-4336-942e-3885ce4ca0b4" & hh_13_7_total == 3
replace ind_issue = 0 if key == "uuid:6c8b1e85-b2f2-4977-a3be-5c53ac28188e" & hh_13_8_total == 8
replace ind_issue = 0 if key == "uuid:f3fc7fa3-cc52-48a4-b153-e65733a5a392" & hh_13_9_total == 18
replace ind_issue = 0 if key == "uuid:8b5fa358-6317-4e65-a16f-0fce2d44c6b5" & hh_13_1_total == 3
replace ind_issue = 0 if key == "uuid:ac7acb5b-cc03-405a-b699-c7049bbb6f16" & hh_13_1_total == 2
replace ind_issue = 0 if key == "uuid:ac7acb5b-cc03-405a-b699-c7049bbb6f16" & hh_13_3_total == 2
replace ind_issue = 0 if key == "uuid:8b5fa358-6317-4e65-a16f-0fce2d44c6b5" & hh_13_3_total == 3
replace ind_issue = 0 if key == "uuid:255d0b95-f83e-45d6-85d8-079546e38ac2" & hh_13_4_total == 14
replace ind_issue = 0 if key == "uuid:8367d735-f929-48ef-bd00-c7f042f3666f" & hh_13_10_total == 26
replace ind_issue = 0 if key == "uuid:de358167-c62b-4063-830a-a3f52a40516e" & hh_13_10_total == 4
replace ind_issue = 0 if key == "uuid:4ad73e64-38f3-461a-8631-05589869add6" & hh_13_4_total == 15
replace ind_issue = 0 if key == "uuid:48307db7-0b01-44ba-9c41-45125c0352bd" & hh_13_9_total == 14
replace ind_issue = 0 if key == "uuid:90fe8f5d-1972-4a14-981b-53c3b8d1bb20" & hh_13_9_total == 8
replace ind_issue = 0 if key == "uuid:99c16594-e479-4aa3-92cc-2a3e9f09cba0" & hh_13_9_total == 18
replace ind_issue = 0 if key == "uuid:d7cf7d20-89ae-405c-af0f-c9f04d222f68" & hh_13_10_total == 14
replace ind_issue = 0 if key == "uuid:7b44e820-4a74-4f8e-b21d-edbc2eed548c" & hh_13_11_total == 14
replace ind_issue = 0 if key == "uuid:8e2a7ee4-2de2-4ed6-baa8-89adbccfa261" & hh_13_1_total == 16
replace ind_issue = 0 if key == "uuid:4cfa8fad-9dae-44cd-9e79-1dd479afc34c" & hh_13_1_total == 5
replace ind_issue = 0 if key == "uuid:d685d816-bff6-4336-b2d7-18e5e0ce6642" & hh_13_1_total == 4
replace ind_issue = 0 if key == "uuid:17d10f64-73a3-47f9-b5cc-d3181be64f21" & hh_13_1_total == 12
replace ind_issue = 0 if key == "uuid:1e6b9d1b-bee3-4d17-b5eb-2610596e005a" & hh_13_2_total == 15
replace ind_issue = 0 if key == "uuid:45e97396-5ee5-4b55-ac86-cbd4824e8263" & hh_13_2_total == 18
replace ind_issue = 0 if key == "uuid:14962970-5438-430e-a873-4b7083b3ff89" & hh_13_5_total == 16
replace ind_issue = 0 if key == "uuid:2f85582e-6352-4e1a-b9b4-6566eec8bd87" & hh_13_6_total == 4
replace ind_issue = 0 if key == "uuid:c7c6ac20-be3f-47ba-b2b4-eb17e08123c4" & hh_13_8_total == 8
replace ind_issue = 0 if key == "uuid:d7cf7d20-89ae-405c-af0f-c9f04d222f68" & hh_13_9_total == 16
replace ind_issue = 0 if key == "uuid:14962970-5438-430e-a873-4b7083b3ff89" & hh_13_9_total == 16
replace ind_issue = 0 if key == "uuid:5280aabf-8b4f-416e-84b9-5b78d5382352" & hh_13_10_total == 3
replace ind_issue = 0 if key == "uuid:94643380-9b5b-4ec2-ac9c-a3fd30a51af7" & hh_13_10_total == 9
replace ind_issue = 0 if key == "uuid:3836b5eb-ccd2-4c6b-bd5f-bf42d09c166c" & hh_13_10_total == 30
replace ind_issue = 0 if key == "uuid:155e4011-7e23-4a13-9190-c8859bb3641f" & hh_13_10_total == 7
replace ind_issue = 0 if key == "uuid:8bc2c8fe-0e98-4b50-9db9-ba66521af34d" & hh_13_1_total == 6
replace ind_issue = 0 if key == "uuid:09622dd4-4613-46e3-939b-c3a43a585bb5" & hh_13_1_total == 5
replace ind_issue = 0 if key == "uuid:ab7d5d15-0083-4d38-8abb-bb1b924d1b88" & hh_13_1_total == 7
replace ind_issue = 0 if key == "uuid:5af0d03f-adee-40c6-837f-cd2d839cfcff" & hh_13_1_total == 5
replace ind_issue = 0 if key == "uuid:dc9ced48-126c-438c-a13d-a25d09b3d415" & hh_13_1_total == 12
replace ind_issue = 0 if key == "uuid:155e4011-7e23-4a13-9190-c8859bb3641f" & hh_13_1_total == 11
replace ind_issue = 0 if key == "uuid:7d6f6d9d-c257-4195-8a67-0aecd4e1b233" & hh_13_1_total == 5
replace ind_issue = 0 if key == "uuid:3836b5eb-ccd2-4c6b-bd5f-bf42d09c166c" & hh_13_1_total == 27
replace ind_issue = 0 if key == "uuid:225f0fda-48a9-4216-bb6a-dcd5cbf8c6a0" & hh_13_2_total == 7
replace ind_issue = 0 if key == "uuid:7d6f6d9d-c257-4195-8a67-0aecd4e1b233" & hh_13_2_total == 4
replace ind_issue = 0 if key == "uuid:8906bfb9-1397-48b5-a2c8-ad8c6a8d05d4" & hh_13_2_total == 4
replace ind_issue = 0 if key == "uuid:273ef459-4a4b-421f-b45f-5938f44138fb" & hh_13_2_total == 4
replace ind_issue = 0 if key == "uuid:82b29ac5-2558-4aa3-a780-b48b45483422" & hh_13_2_total == 6
replace ind_issue = 0 if key == "uuid:5bde4af2-d8dc-4fae-8884-fc042a5d12a6" & hh_13_2_total == 9
replace ind_issue = 0 if key == "uuid:a4402ec7-4feb-48e1-958c-e58af2695a91" & hh_13_2_total == 4
replace ind_issue = 0 if key == "uuid:eb83f695-2664-47fa-817c-9dac667e6e36" & hh_13_2_total == 6
replace ind_issue = 0 if key == "uuid:3836b5eb-ccd2-4c6b-bd5f-bf42d09c166c" & hh_13_2_total == 12
replace ind_issue = 0 if key == "uuid:d44573d3-a9ca-4ddf-9562-1a17f4041335" & hh_13_2_total == 50
replace ind_issue = 0 if key == "uuid:e1f57db1-c71f-4b6b-8e34-e79a83b811e1" & hh_13_2_total == 6
replace ind_issue = 0 if key == "uuid:19e1735c-2567-450b-af13-bf2a4c46401f" & hh_13_2_total == 4
replace ind_issue = 0 if key == "uuid:1c2ad303-cb84-4bf8-a5cf-f5d38b1ee77c" & hh_13_3_total == 4
replace ind_issue = 0 if key == "uuid:7d9f8b44-84f1-4118-b829-ec224829dc78" & hh_13_3_total == 11
replace ind_issue = 0 if key == "uuid:ab7d5d15-0083-4d38-8abb-bb1b924d1b88" & hh_13_3_total == 6
replace ind_issue = 0 if key == "uuid:347b10a5-29e2-4221-9079-08b5d95c139b" & hh_13_3_total == 15
replace ind_issue = 0 if key == "uuid:835ad0a6-7209-486a-9324-9f1201bd9a44" & hh_13_3_total == 5
replace ind_issue = 0 if key == "uuid:d44573d3-a9ca-4ddf-9562-1a17f4041335" & hh_13_4_total == 6
replace ind_issue = 0 if key == "uuid:82b29ac5-2558-4aa3-a780-b48b45483422" & hh_13_4_total == 8
replace ind_issue = 0 if key == "uuid:5280aabf-8b4f-416e-84b9-5b78d5382352" & hh_13_4_total == 5
replace ind_issue = 0 if key == "uuid:155e4011-7e23-4a13-9190-c8859bb3641f" & hh_13_4_total == 8
replace ind_issue = 0 if key == "uuid:d7d885fe-9a4f-4a10-8991-80d5fd4dd3f9" & hh_13_4_total == 7
replace ind_issue = 0 if key == "uuid:52114c0c-1d86-4b02-bfad-1d2915662339" & hh_13_4_total == 4
replace ind_issue = 0 if key == "uuid:b632245d-c09f-449a-8531-7d895647d580" & hh_13_4_total == 4
replace ind_issue = 0 if key == "uuid:ff3a6c1c-3914-48f6-88fd-0ad12b79a00e" & hh_13_4_total == 3
replace ind_issue = 0 if key == "uuid:3836b5eb-ccd2-4c6b-bd5f-bf42d09c166c" & hh_13_4_total == 16
replace ind_issue = 0 if key == "uuid:347b10a5-29e2-4221-9079-08b5d95c139b" & hh_13_5_total == 11
replace ind_issue = 0 if key == "uuid:1c2ad303-cb84-4bf8-a5cf-f5d38b1ee77c" & hh_13_5_total == 5
replace ind_issue = 0 if key == "uuid:e27a987c-199d-4435-9888-71d4f1a0fb69" & hh_13_5_total == 15
replace ind_issue = 0 if key == "uuid:7c9ed2c3-473c-4558-b887-3549340d10d2" & hh_13_5_total == 10
replace ind_issue = 0 if key == "uuid:82b29ac5-2558-4aa3-a780-b48b45483422" & hh_13_5_total == 6
replace ind_issue = 0 if key == "uuid:155e4011-7e23-4a13-9190-c8859bb3641f" & hh_13_5_total == 8
replace ind_issue = 0 if key == "uuid:977bfb1b-9b32-40f3-a5b9-b378470fe0c7" & hh_13_5_total == 4
replace ind_issue = 0 if key == "uuid:cf7580cb-13e6-4b55-9893-3d6a6e4e82b4" & hh_13_6_total == 3
replace ind_issue = 0 if key == "uuid:155e4011-7e23-4a13-9190-c8859bb3641f" & hh_13_6_total == 4
replace ind_issue = 0 if key == "uuid:82b29ac5-2558-4aa3-a780-b48b45483422" & hh_13_6_total == 5
replace ind_issue = 0 if key == "uuid:94e7466e-6e68-47b2-a2e6-3665b1e43ddc" & hh_13_6_total == 4
replace ind_issue = 0 if key == "uuid:f05825dc-a539-40ff-8384-8edaef71070b" & hh_13_6_total == 20
replace ind_issue = 0 if key == "uuid:d5f48d8a-650d-40bc-b6ad-a365623fda48" & hh_13_6_total == 9
replace ind_issue = 0 if key == "uuid:1c2ad303-cb84-4bf8-a5cf-f5d38b1ee77c" & hh_13_6_total == 9
replace ind_issue = 0 if key == "uuid:ab7d5d15-0083-4d38-8abb-bb1b924d1b88" & hh_13_7_total == 12
replace ind_issue = 0 if key == "uuid:3836b5eb-ccd2-4c6b-bd5f-bf42d09c166c" & hh_13_7_total == 30
replace ind_issue = 0 if key == "uuid:bd5809d6-cf3f-4953-84dd-55dde87227f5" & hh_13_7_total == 4
replace ind_issue = 0 if key == "uuid:b6b0e45c-70af-459a-b1fc-68ef8ad671ba" & hh_13_7_total == 25
replace ind_issue = 0 if key == "uuid:742d4881-da1e-4e85-9270-0c5bd07d1b00" & hh_13_7_total == 15
replace ind_issue = 0 if key == "uuid:7d9f8b44-84f1-4118-b829-ec224829dc78" & hh_13_7_total == 27
replace ind_issue = 0 if key == "uuid:b6b0e45c-70af-459a-b1fc-68ef8ad671ba" & hh_13_8_total == 25
replace ind_issue = 0 if key == "uuid:7d9f8b44-84f1-4118-b829-ec224829dc78" & hh_13_9_total == 12
replace ind_issue = 0 if key == "uuid:3c3b579a-f6e1-43d8-8b41-2f3c0d88225c" & hh_13_4_total == 4
replace ind_issue = 0 if key == "uuid:85bf20ba-a400-46bd-b464-e95c8c84b83a" & hh_13_8_total == 2
replace ind_issue = 0 if key == "uuid:844ab214-bd8f-4cfd-b13e-38ce3bba59a8" & hh_13_1_total == 6
replace ind_issue = 0 if key == "uuid:a0da06c7-4f16-44ab-b40a-c8fe75daf322" & hh_13_2_total == 7
replace ind_issue = 0 if key == "uuid:446cce08-7cc4-44c1-be46-e651f216e5bc" & hh_13_2_total == 4
replace ind_issue = 0 if key == "uuid:5cdbeb2d-f857-4604-bd8e-a8c71598c780" & hh_13_2_total == 15
replace ind_issue = 0 if key == "uuid:5ea1d587-2469-4448-92aa-5e52f24e0944" & hh_13_2_total == 7
replace ind_issue = 0 if key == "uuid:6c6af704-258e-4141-89bb-38b76f5fcd0a" & hh_13_2_total == 4
replace ind_issue = 0 if key == "uuid:50b29906-6426-4b14-b03d-be24b5bb4fbc" & hh_13_2_total == 7
replace ind_issue = 0 if key == "uuid:f09c2ec3-49c7-4065-8012-aa9394ead732" & hh_13_2_total == 3
replace ind_issue = 0 if key == "uuid:5cdbeb2d-f857-4604-bd8e-a8c71598c780" & hh_13_4_total == 7
replace ind_issue = 0 if key == "uuid:a0da06c7-4f16-44ab-b40a-c8fe75daf322" & hh_13_4_total == 4
replace ind_issue = 0 if key == "uuid:d087f767-d251-4ab8-a3f3-7f749499d11d" & hh_13_4_total == 6
replace ind_issue = 0 if key == "uuid:50b29906-6426-4b14-b03d-be24b5bb4fbc" & hh_13_4_total == 2
replace ind_issue = 0 if key == "uuid:0243f237-580f-48db-81ac-af07d0ec3c7d" & hh_13_5_total == 0
replace ind_issue = 0 if key == "uuid:d087f767-d251-4ab8-a3f3-7f749499d11d" & hh_13_5_total == 7
replace ind_issue = 0 if key == "uuid:e2eb2697-0ed5-4a5c-8049-b1ea036fbe9c" & hh_13_8_total == 10
replace ind_issue = 0 if key == "uuid:8f4cbc6a-8472-4738-b738-7057a87ab85e" & hh_13_8_total == 3
replace ind_issue = 0 if key == "uuid:eb71f1ee-5f44-4a52-926b-7db730824f49" & hh_13_10_total == 6
replace ind_issue = 0 if key == "uuid:6fd4bf23-18ad-4397-b6e5-51b08c474051" & hh_13_1_total == 3
replace ind_issue = 0 if key == "uuid:a137313a-7bc1-4510-a7cc-367cd5242870" & hh_13_1_total == 6
replace ind_issue = 0 if key == "uuid:6fd4bf23-18ad-4397-b6e5-51b08c474051" & hh_13_2_total == 6
replace ind_issue = 0 if key == "uuid:aa31efb9-7412-4e3a-9439-0bb286420a63" & hh_13_2_total == 5
replace ind_issue = 0 if key == "uuid:50f46c9d-224d-475a-9e79-88c00fd6c213" & hh_13_2_total == 12
replace ind_issue = 0 if key == "uuid:eb71f1ee-5f44-4a52-926b-7db730824f49" & hh_13_3_total == 9
replace ind_issue = 0 if key == "uuid:7e085ce7-6243-4ba5-bb47-88eb94f46bab" & hh_13_3_total == 6
replace ind_issue = 0 if key == "uuid:d956e550-a088-43b7-b422-7417e1341024" & hh_13_4_total == 8
replace ind_issue = 0 if key == "uuid:53f9620b-0bad-4850-8858-daef5ca40bb1" & hh_13_5_total == 16
replace ind_issue = 0 if key == "uuid:a137313a-7bc1-4510-a7cc-367cd5242870" & hh_13_5_total == 6
replace ind_issue = 0 if key == "uuid:5405184a-72e2-45d3-9d4b-7de603a79851" & hh_13_7_total == 5
replace ind_issue = 0 if key == "uuid:50f46c9d-224d-475a-9e79-88c00fd6c213" & hh_13_8_total == 12
replace ind_issue = 0 if key == "uuid:a137313a-7bc1-4510-a7cc-367cd5242870" & hh_13_9_total == 12
replace ind_issue = 0 if key == "uuid:1e9da38f-f800-4f19-93ac-73bbf37def32" & hh_13_9_total == 5
replace ind_issue = 0 if key == "uuid:e59e2eae-b1ae-449a-8842-d4641331f136" & hh_13_10_total == 22
replace ind_issue = 0 if key == "uuid:4a0fe362-32d1-4dad-ba8c-ca382d519c63" & hh_13_10_total == 6
replace ind_issue = 0 if key == "uuid:8fa21ba5-01a7-4793-83e1-dff07d42eb16" & hh_13_10_total == 24
replace ind_issue = 0 if key == "uuid:ea66090c-4853-434a-8501-93e90526a596" & hh_13_11_total == 32
replace ind_issue = 0 if key == "uuid:57dd6094-f7b5-43e7-9c80-108266eac06b" & hh_13_11_total == 29
replace ind_issue = 0 if key == "uuid:71a3b9e5-abc7-4e2c-94a3-006da861982b" & hh_13_11_total == 12
replace ind_issue = 0 if key == "uuid:fe4d47d8-1ccf-4acf-a7b9-e9d0c7e6d252" & hh_13_11_total == 8
replace ind_issue = 0 if key == "uuid:4a0fe362-32d1-4dad-ba8c-ca382d519c63" & hh_13_11_total == 11
replace ind_issue = 0 if key == "uuid:8cb164e9-bedb-4168-b1fa-f5ce9354c2a9" & hh_13_12_total == 25
replace ind_issue = 0 if key == "uuid:731b2b96-2cc9-4c40-ab3d-1c8eca615b1d" & hh_13_12_total == 17
replace ind_issue = 0 if key == "uuid:71a3b9e5-abc7-4e2c-94a3-006da861982b" & hh_13_12_total == 5
replace ind_issue = 0 if key == "uuid:ea66090c-4853-434a-8501-93e90526a596" & hh_13_12_total == 42
replace ind_issue = 0 if key == "uuid:71a3b9e5-abc7-4e2c-94a3-006da861982b" & hh_13_13_total == 19
replace ind_issue = 0 if key == "uuid:8cb164e9-bedb-4168-b1fa-f5ce9354c2a9" & hh_13_13_total == 14
replace ind_issue = 0 if key == "uuid:71a3b9e5-abc7-4e2c-94a3-006da861982b" & hh_13_14_total == 25
replace ind_issue = 0 if key == "uuid:d7df3ea3-ed60-4690-83db-4a41ccfe4d2e" & hh_13_1_total == 12
replace ind_issue = 0 if key == "uuid:e59e2eae-b1ae-449a-8842-d4641331f136" & hh_13_1_total == 9
replace ind_issue = 0 if key == "uuid:cacc2793-2389-4662-9f45-57888c195209" & hh_13_1_total == 5
replace ind_issue = 0 if key == "uuid:b1fae32c-057b-45c3-a10b-5fbdf289d4d6" & hh_13_1_total == 8
replace ind_issue = 0 if key == "uuid:68e479ee-1a91-4b2c-99d0-cfb335f8aeeb" & hh_13_1_total == 29
replace ind_issue = 0 if key == "uuid:f74852e0-f784-45df-9ba6-40933da3b8d1" & hh_13_1_total == 38
replace ind_issue = 0 if key == "uuid:92bf8c6e-ed5e-45f9-a303-3edb224aa9a9" & hh_13_1_total == 5
replace ind_issue = 0 if key == "uuid:33059fa7-c2ec-4757-925c-e9caca8b3365" & hh_13_1_total == 26
replace ind_issue = 0 if key == "uuid:ee63debf-822a-411e-a0f2-d08e9eade8c3" & hh_13_1_total == 18
replace ind_issue = 0 if key == "uuid:cdc2da54-b15a-4620-8ab1-79529d3e76e8" & hh_13_1_total == 33
replace ind_issue = 0 if key == "uuid:a671b107-d7f9-4662-9727-5a5ee7218919" & hh_13_1_total == 30
replace ind_issue = 0 if key == "uuid:96923c86-ad11-4def-97ce-64a3089a78a1" & hh_13_1_total == 9
replace ind_issue = 0 if key == "uuid:06a0710b-f29b-48db-894f-4d4cf39a1b4a" & hh_13_1_total == 18
replace ind_issue = 0 if key == "uuid:fd300527-e33a-4519-8ba2-1df30a653a0c" & hh_13_1_total == 17
replace ind_issue = 0 if key == "uuid:41e60432-f713-4dd5-8c23-dce0e4f5116d" & hh_13_1_total == 15
replace ind_issue = 0 if key == "uuid:7bc76c9c-7953-4dc6-8f11-a7b27a31fb2e" & hh_13_1_total == 18
replace ind_issue = 0 if key == "uuid:2281e503-58c4-4cc7-8d8a-c0f0556fc6fe" & hh_13_1_total == 8
replace ind_issue = 0 if key == "uuid:b23e5229-ac34-49c5-bb00-dc31eb3bd45a" & hh_13_1_total == 12
replace ind_issue = 0 if key == "uuid:f5bfd38e-c47c-4d7f-aa1f-37602fef6c9c" & hh_13_1_total == 40
replace ind_issue = 0 if key == "uuid:1a90220f-66e7-4dbc-9c15-d68d00a2837c" & hh_13_1_total == 24
replace ind_issue = 0 if key == "uuid:8beba4f4-7066-4673-974d-d1e6ce1c202d" & hh_13_1_total == 12
replace ind_issue = 0 if key == "uuid:18f82da1-ec44-4a27-aa91-dc3e5e255ab0" & hh_13_1_total == 18
replace ind_issue = 0 if key == "uuid:38e50014-cbb3-4ccf-a592-222277e3c778" & hh_13_1_total == 31
replace ind_issue = 0 if key == "uuid:98c2222f-078f-4f22-a564-daa6d11a3137" & hh_13_1_total == 12
replace ind_issue = 0 if key == "uuid:97005d53-1aba-40bb-b43e-9ee1381dca64" & hh_13_1_total == 2
replace ind_issue = 0 if key == "uuid:99c82cc7-1de5-4a4a-9f31-d20eecd3780b" & hh_13_1_total == 37
replace ind_issue = 0 if key == "uuid:6807b869-b596-4b86-8e58-0ab895ba820d" & hh_13_1_total == 12
replace ind_issue = 0 if key == "uuid:57dd6094-f7b5-43e7-9c80-108266eac06b" & hh_13_2_total == 16
replace ind_issue = 0 if key == "uuid:3483bf73-dafd-4ff8-9f01-fd15130e5fc1" & hh_13_2_total == 13
replace ind_issue = 0 if key == "uuid:478dad1c-ebf1-4e82-89a3-d7dd1b17b817" & hh_13_2_total == 12
replace ind_issue = 0 if key == "uuid:1df09cfd-b5f7-4fa5-8227-199fa261ae20" & hh_13_2_total == 12
replace ind_issue = 0 if key == "uuid:8cb164e9-bedb-4168-b1fa-f5ce9354c2a9" & hh_13_2_total == 24
replace ind_issue = 0 if key == "uuid:38e50014-cbb3-4ccf-a592-222277e3c778" & hh_13_2_total == 17
replace ind_issue = 0 if key == "uuid:92bf8c6e-ed5e-45f9-a303-3edb224aa9a9" & hh_13_2_total == 5
replace ind_issue = 0 if key == "uuid:18f82da1-ec44-4a27-aa91-dc3e5e255ab0" & hh_13_2_total == 55
replace ind_issue = 0 if key == "uuid:9d9dda6a-deb5-4cce-bd4c-ed3f2bc00381" & hh_13_2_total == 20
replace ind_issue = 0 if key == "uuid:b047f2ab-50c4-44f9-afb1-47950ed4d298" & hh_13_2_total == 13
replace ind_issue = 0 if key == "uuid:a9c4ed22-5c74-45bc-a014-6fa3b78dea51" & hh_13_2_total == 25
replace ind_issue = 0 if key == "uuid:021408c0-3c5f-42ad-bf3c-4df9fc199963" & hh_13_2_total == 40
replace ind_issue = 0 if key == "uuid:4f33e08d-f88b-4c66-9f8c-5c6ffcb99c7e" & hh_13_2_total == 9
replace ind_issue = 0 if key == "uuid:f74852e0-f784-45df-9ba6-40933da3b8d1" & hh_13_2_total == 31
replace ind_issue = 0 if key == "uuid:6b9b2707-4a82-4053-b891-58a4da25d61f" & hh_13_2_total == 8
replace ind_issue = 0 if key == "uuid:8f2f96ba-cb33-4481-b386-214bf00ad3e3" & hh_13_2_total == 22
replace ind_issue = 0 if key == "uuid:fd300527-e33a-4519-8ba2-1df30a653a0c" & hh_13_2_total == 11
replace ind_issue = 0 if key == "uuid:6807b869-b596-4b86-8e58-0ab895ba820d" & hh_13_3_total == 6
replace ind_issue = 0 if key == "uuid:57dd6094-f7b5-43e7-9c80-108266eac06b" & hh_13_3_total == 22
replace ind_issue = 0 if key == "uuid:18f82da1-ec44-4a27-aa91-dc3e5e255ab0" & hh_13_3_total == 16
replace ind_issue = 0 if key == "uuid:8f2f96ba-cb33-4481-b386-214bf00ad3e3" & hh_13_3_total == 23
replace ind_issue = 0 if key == "uuid:fe78ae3a-df95-4ba8-9205-133a78bb7675" & hh_13_3_total == 9
replace ind_issue = 0 if key == "uuid:0aa1bd0b-c8f4-493d-a32e-5256cc8a58d0" & hh_13_3_total == 36
replace ind_issue = 0 if key == "uuid:f74852e0-f784-45df-9ba6-40933da3b8d1" & hh_13_3_total == 32
replace ind_issue = 0 if key == "uuid:f5bfd38e-c47c-4d7f-aa1f-37602fef6c9c" & hh_13_3_total == 14
replace ind_issue = 0 if key == "uuid:06a0710b-f29b-48db-894f-4d4cf39a1b4a" & hh_13_3_total == 11
replace ind_issue = 0 if key == "uuid:38e50014-cbb3-4ccf-a592-222277e3c778" & hh_13_3_total == 30
replace ind_issue = 0 if key == "uuid:b89a7ed1-e6ea-4835-8e6d-2e374b8d1cdb" & hh_13_3_total == 25
replace ind_issue = 0 if key == "uuid:731b2b96-2cc9-4c40-ab3d-1c8eca615b1d" & hh_13_3_total == 26
replace ind_issue = 0 if key == "uuid:44c3f48f-0077-4b77-8299-067409188bf3" & hh_13_3_total == 35
replace ind_issue = 0 if key == "uuid:7f450507-9f4a-40a5-99e4-8b63c95b4d2c" & hh_13_3_total == 19
replace ind_issue = 0 if key == "uuid:902f961e-7553-4463-81b7-39f9ad8f7903" & hh_13_3_total == 34
replace ind_issue = 0 if key == "uuid:cacc2793-2389-4662-9f45-57888c195209" & hh_13_3_total == 13
replace ind_issue = 0 if key == "uuid:43c5f3aa-5f3e-4087-98de-31d897566c82" & hh_13_3_total == 9
replace ind_issue = 0 if key == "uuid:98c2222f-078f-4f22-a564-daa6d11a3137" & hh_13_3_total == 38
replace ind_issue = 0 if key == "uuid:95ab2e1d-999b-4548-bdb3-f2b43f8c8d43" & hh_13_3_total == 9
replace ind_issue = 0 if key == "uuid:8beba4f4-7066-4673-974d-d1e6ce1c202d" & hh_13_3_total == 22
replace ind_issue = 0 if key == "uuid:398fb50b-ed82-412f-948c-8c9b36a4d647" & hh_13_4_total == 25
replace ind_issue = 0 if key == "uuid:6807b869-b596-4b86-8e58-0ab895ba820d" & hh_13_4_total == 12
replace ind_issue = 0 if key == "uuid:b047f2ab-50c4-44f9-afb1-47950ed4d298" & hh_13_4_total == 5
replace ind_issue = 0 if key == "uuid:e692401a-2af4-4a0f-9e12-1d7bb0856037" & hh_13_4_total == 10
replace ind_issue = 0 if key == "uuid:e59e2eae-b1ae-449a-8842-d4641331f136" & hh_13_4_total == 35
replace ind_issue = 0 if key == "uuid:0b064064-0c43-4beb-b04f-f7cbe586b32a" & hh_13_4_total == 2
replace ind_issue = 0 if key == "uuid:44c3f48f-0077-4b77-8299-067409188bf3" & hh_13_4_total == 26
replace ind_issue = 0 if key == "uuid:92171a8f-7a48-4292-a5ef-6850b6c04333" & hh_13_4_total == 19
replace ind_issue = 0 if key == "uuid:b724a25d-830a-4bab-a8e8-0bac4750ce73" & hh_13_4_total == 6
replace ind_issue = 0 if key == "uuid:1a90220f-66e7-4dbc-9c15-d68d00a2837c" & hh_13_4_total == 5
replace ind_issue = 0 if key == "uuid:f74852e0-f784-45df-9ba6-40933da3b8d1" & hh_13_4_total == 20
replace ind_issue = 0 if key == "uuid:4c778d8f-97d4-47fa-af7d-7e3314c48feb" & hh_13_4_total == 12
replace ind_issue = 0 if key == "uuid:06a0710b-f29b-48db-894f-4d4cf39a1b4a" & hh_13_4_total == 17
replace ind_issue = 0 if key == "uuid:2281e503-58c4-4cc7-8d8a-c0f0556fc6fe" & hh_13_4_total == 8
replace ind_issue = 0 if key == "uuid:7df27b6f-72da-4704-ae80-891dc6884470" & hh_13_4_total == 11
replace ind_issue = 0 if key == "uuid:021408c0-3c5f-42ad-bf3c-4df9fc199963" & hh_13_4_total == 29
replace ind_issue = 0 if key == "uuid:92bf8c6e-ed5e-45f9-a303-3edb224aa9a9" & hh_13_4_total == 17
replace ind_issue = 0 if key == "uuid:33059fa7-c2ec-4757-925c-e9caca8b3365" & hh_13_4_total == 40
replace ind_issue = 0 if key == "uuid:35f6931b-c1e5-4ed4-ac86-d169b66b7963" & hh_13_4_total == 5
replace ind_issue = 0 if key == "uuid:18f82da1-ec44-4a27-aa91-dc3e5e255ab0" & hh_13_4_total == 24
replace ind_issue = 0 if key == "uuid:b1fae32c-057b-45c3-a10b-5fbdf289d4d6" & hh_13_4_total == 5
replace ind_issue = 0 if key == "uuid:54f5143b-9911-4187-a30c-9e3239c47476" & hh_13_4_total == 7
replace ind_issue = 0 if key == "uuid:fe78ae3a-df95-4ba8-9205-133a78bb7675" & hh_13_4_total == 20
replace ind_issue = 0 if key == "uuid:0aa1bd0b-c8f4-493d-a32e-5256cc8a58d0" & hh_13_5_total == 25
replace ind_issue = 0 if key == "uuid:6807b869-b596-4b86-8e58-0ab895ba820d" & hh_13_5_total == 22
replace ind_issue = 0 if key == "uuid:c549c58d-ef59-4d7f-a241-ebe47316e790" & hh_13_5_total == 16
replace ind_issue = 0 if key == "uuid:92bf8c6e-ed5e-45f9-a303-3edb224aa9a9" & hh_13_5_total == 26
replace ind_issue = 0 if key == "uuid:b724a25d-830a-4bab-a8e8-0bac4750ce73" & hh_13_5_total == 6
replace ind_issue = 0 if key == "uuid:1a90220f-66e7-4dbc-9c15-d68d00a2837c" & hh_13_5_total == 6
replace ind_issue = 0 if key == "uuid:1df09cfd-b5f7-4fa5-8227-199fa261ae20" & hh_13_5_total == 18
replace ind_issue = 0 if key == "uuid:8cb164e9-bedb-4168-b1fa-f5ce9354c2a9" & hh_13_5_total == 24
replace ind_issue = 0 if key == "uuid:d072558d-e4ba-46a6-b08f-70dcd69a6876" & hh_13_5_total == 11
replace ind_issue = 0 if key == "uuid:f5bfd38e-c47c-4d7f-aa1f-37602fef6c9c" & hh_13_5_total == 27
replace ind_issue = 0 if key == "uuid:057ebbe7-b982-4f48-9287-24be6d59f40a" & hh_13_5_total == 23
replace ind_issue = 0 if key == "uuid:fe78ae3a-df95-4ba8-9205-133a78bb7675" & hh_13_5_total == 22
replace ind_issue = 0 if key == "uuid:cdc2da54-b15a-4620-8ab1-79529d3e76e8" & hh_13_5_total == 7
replace ind_issue = 0 if key == "uuid:4c778d8f-97d4-47fa-af7d-7e3314c48feb" & hh_13_5_total == 16
replace ind_issue = 0 if key == "uuid:18f82da1-ec44-4a27-aa91-dc3e5e255ab0" & hh_13_5_total == 40
replace ind_issue = 0 if key == "uuid:6b9b2707-4a82-4053-b891-58a4da25d61f" & hh_13_5_total == 15
replace ind_issue = 0 if key == "uuid:c840f2ec-d0ec-4652-9e94-39ce87bad68a" & hh_13_5_total == 11
replace ind_issue = 0 if key == "uuid:7df04366-985d-4f5e-895f-61ec47f30529" & hh_13_5_total == 42
replace ind_issue = 0 if key == "uuid:96923c86-ad11-4def-97ce-64a3089a78a1" & hh_13_5_total == 20
replace ind_issue = 0 if key == "uuid:0aa1bd0b-c8f4-493d-a32e-5256cc8a58d0" & hh_13_6_total == 27
replace ind_issue = 0 if key == "uuid:fe4d47d8-1ccf-4acf-a7b9-e9d0c7e6d252" & hh_13_6_total == 8
replace ind_issue = 0 if key == "uuid:6b9b2707-4a82-4053-b891-58a4da25d61f" & hh_13_6_total == 15
replace ind_issue = 0 if key == "uuid:4f33e08d-f88b-4c66-9f8c-5c6ffcb99c7e" & hh_13_6_total == 27
replace ind_issue = 0 if key == "uuid:021408c0-3c5f-42ad-bf3c-4df9fc199963" & hh_13_6_total == 27
replace ind_issue = 0 if key == "uuid:e03c2b73-d6ee-4ade-9f1b-9cbdbc89aef8" & hh_13_6_total == 8
replace ind_issue = 0 if key == "uuid:cdc2da54-b15a-4620-8ab1-79529d3e76e8" & hh_13_6_total == 5
replace ind_issue = 0 if key == "uuid:68e479ee-1a91-4b2c-99d0-cfb335f8aeeb" & hh_13_6_total == 16
replace ind_issue = 0 if key == "uuid:e692401a-2af4-4a0f-9e12-1d7bb0856037" & hh_13_6_total == 14
replace ind_issue = 0 if key == "uuid:fe78ae3a-df95-4ba8-9205-133a78bb7675" & hh_13_6_total == 12
replace ind_issue = 0 if key == "uuid:f5bfd38e-c47c-4d7f-aa1f-37602fef6c9c" & hh_13_6_total == 26
replace ind_issue = 0 if key == "uuid:1df09cfd-b5f7-4fa5-8227-199fa261ae20" & hh_13_6_total == 9
replace ind_issue = 0 if key == "uuid:76360573-efa2-4b0d-9979-a990ca4571a4" & hh_13_6_total == 32
replace ind_issue = 0 if key == "uuid:18f82da1-ec44-4a27-aa91-dc3e5e255ab0" & hh_13_6_total == 18
replace ind_issue = 0 if key == "uuid:fd300527-e33a-4519-8ba2-1df30a653a0c" & hh_13_6_total == 12
replace ind_issue = 0 if key == "uuid:27c99328-fe86-4b31-956f-6c9aaf3b1284" & hh_13_6_total == 6
replace ind_issue = 0 if key == "uuid:ea66090c-4853-434a-8501-93e90526a596" & hh_13_6_total == 34
replace ind_issue = 0 if key == "uuid:4f33e08d-f88b-4c66-9f8c-5c6ffcb99c7e" & hh_13_7_total == 6
replace ind_issue = 0 if key == "uuid:6b9b2707-4a82-4053-b891-58a4da25d61f" & hh_13_7_total == 21
replace ind_issue = 0 if key == "uuid:8cb164e9-bedb-4168-b1fa-f5ce9354c2a9" & hh_13_7_total == 20
replace ind_issue = 0 if key == "uuid:2281e503-58c4-4cc7-8d8a-c0f0556fc6fe" & hh_13_7_total == 25
replace ind_issue = 0 if key == "uuid:398fb50b-ed82-412f-948c-8c9b36a4d647" & hh_13_7_total == 28
replace ind_issue = 0 if key == "uuid:4c778d8f-97d4-47fa-af7d-7e3314c48feb" & hh_13_7_total == 11
replace ind_issue = 0 if key == "uuid:731b2b96-2cc9-4c40-ab3d-1c8eca615b1d" & hh_13_7_total == 13
replace ind_issue = 0 if key == "uuid:c336de53-c390-436d-8371-5e5bc87a526c" & hh_13_7_total == 22
replace ind_issue = 0 if key == "uuid:41e60432-f713-4dd5-8c23-dce0e4f5116d" & hh_13_7_total == 25
replace ind_issue = 0 if key == "uuid:44c3f48f-0077-4b77-8299-067409188bf3" & hh_13_7_total == 30
replace ind_issue = 0 if key == "uuid:a671b107-d7f9-4662-9727-5a5ee7218919" & hh_13_7_total == 19
replace ind_issue = 0 if key == "uuid:76360573-efa2-4b0d-9979-a990ca4571a4" & hh_13_7_total == 43
replace ind_issue = 0 if key == "uuid:fd300527-e33a-4519-8ba2-1df30a653a0c" & hh_13_7_total == 40
replace ind_issue = 0 if key == "uuid:4a0fe362-32d1-4dad-ba8c-ca382d519c63" & hh_13_7_total == 9
replace ind_issue = 0 if key == "uuid:57dd6094-f7b5-43e7-9c80-108266eac06b" & hh_13_8_total == 8
replace ind_issue = 0 if key == "uuid:0aa1bd0b-c8f4-493d-a32e-5256cc8a58d0" & hh_13_8_total == 42
replace ind_issue = 0 if key == "uuid:7f450507-9f4a-40a5-99e4-8b63c95b4d2c" & hh_13_8_total == 23
replace ind_issue = 0 if key == "uuid:4c778d8f-97d4-47fa-af7d-7e3314c48feb" & hh_13_8_total == 10
replace ind_issue = 0 if key == "uuid:ea66090c-4853-434a-8501-93e90526a596" & hh_13_8_total == 62
replace ind_issue = 0 if key == "uuid:38e50014-cbb3-4ccf-a592-222277e3c778" & hh_13_8_total == 39
replace ind_issue = 0 if key == "uuid:e692401a-2af4-4a0f-9e12-1d7bb0856037" & hh_13_8_total == 8
replace ind_issue = 0 if key == "uuid:e59e2eae-b1ae-449a-8842-d4641331f136" & hh_13_8_total == 14
replace ind_issue = 0 if key == "uuid:ea66090c-4853-434a-8501-93e90526a596" & hh_13_9_total == 29
replace ind_issue = 0 if key == "uuid:71a3b9e5-abc7-4e2c-94a3-006da861982b" & hh_13_9_total == 18
replace ind_issue = 0 if key == "uuid:63f9341b-cb38-461f-b438-cb6e08f9b1c7" & hh_13_10_total == 28
replace ind_issue = 0 if key == "uuid:4a93facc-81f2-47bf-834f-ade9801ee7c8" & hh_13_10_total == 21
replace ind_issue = 0 if key == "uuid:16671bba-7134-410e-adcc-d943d1515258" & hh_13_1_total == 76
replace ind_issue = 0 if key == "uuid:885049cc-1088-4324-82a2-6a3d1aa5c3bf" & hh_13_1_total == 56
replace ind_issue = 0 if key == "uuid:bc6c1d3d-fa4b-4767-9ae5-c7422db73c6c" & hh_13_1_total == 9
replace ind_issue = 0 if key == "uuid:d56edb36-89c5-436c-93d2-f3e9f0f601a5" & hh_13_1_total == 70
replace ind_issue = 0 if key == "uuid:72ed82ab-7a9a-4eb1-bff3-db27dcae2ad8" & hh_13_1_total == 14
replace ind_issue = 0 if key == "uuid:ac73ba38-b143-418d-b5b8-ce3c42cc3cbc" & hh_13_1_total == 74
replace ind_issue = 0 if key == "uuid:58f97ff1-d328-4186-b783-6e4eb46e1683" & hh_13_1_total == 7
replace ind_issue = 0 if key == "uuid:e883f07a-0650-4828-9cac-5b7f90fa0721" & hh_13_1_total == 59
replace ind_issue = 0 if key == "uuid:20c6f12b-0474-449e-88cf-7e4bb8572ccf" & hh_13_1_total == 21
replace ind_issue = 0 if key == "uuid:37867bda-7341-492f-a065-8037d1e444de" & hh_13_1_total == 56
replace ind_issue = 0 if key == "uuid:10cdabf2-f022-4539-8c2b-7eaa1bead1d1" & hh_13_1_total == 6
replace ind_issue = 0 if key == "uuid:d119d84e-18ad-43a8-aaaf-8b807d8af117" & hh_13_1_total == 48
replace ind_issue = 0 if key == "uuid:7927b2e6-e46d-4be1-8163-7669e0733149" & hh_13_1_total == 42
replace ind_issue = 0 if key == "uuid:dbaf39d5-e977-4dad-a0fd-d3f8f978a2c5" & hh_13_1_total == 6
replace ind_issue = 0 if key == "uuid:5dacec94-0b4b-459d-bc8d-7ca6379119bc" & hh_13_1_total == 21
replace ind_issue = 0 if key == "uuid:4a93facc-81f2-47bf-834f-ade9801ee7c8" & hh_13_1_total == 21
replace ind_issue = 0 if key == "uuid:1e25364f-6fd7-4898-9631-7343b0d1b0f7" & hh_13_1_total == 24
replace ind_issue = 0 if key == "uuid:44e9ec51-4de3-4be7-985d-1aed9746258a" & hh_13_1_total == 21
replace ind_issue = 0 if key == "uuid:ce5549e0-79b0-4bde-9e8b-37fab5eedf2f" & hh_13_1_total == 60
replace ind_issue = 0 if key == "uuid:d9a96108-6ff6-4a01-b035-8c4edbc3d016" & hh_13_2_total == 6
replace ind_issue = 0 if key == "uuid:4894e36a-965b-440d-aa57-d70254caa566" & hh_13_2_total == 24
replace ind_issue = 0 if key == "uuid:10cdabf2-f022-4539-8c2b-7eaa1bead1d1" & hh_13_2_total == 55
replace ind_issue = 0 if key == "uuid:be9e4bd2-80ed-421f-b7e9-118e547dfd7b" & hh_13_2_total == 6
replace ind_issue = 0 if key == "uuid:7927b2e6-e46d-4be1-8163-7669e0733149" & hh_13_2_total == 55
replace ind_issue = 0 if key == "uuid:16671bba-7134-410e-adcc-d943d1515258" & hh_13_2_total == 56
replace ind_issue = 0 if key == "uuid:6995a33b-0e9c-458f-9e49-d08266c63a04" & hh_13_2_total == 42
replace ind_issue = 0 if key == "uuid:72ed82ab-7a9a-4eb1-bff3-db27dcae2ad8" & hh_13_2_total == 35
replace ind_issue = 0 if key == "uuid:21a44c69-6d8a-4ded-b1b8-98280d8f04c1" & hh_13_2_total == 7
replace ind_issue = 0 if key == "uuid:37867bda-7341-492f-a065-8037d1e444de" & hh_13_2_total == 28
replace ind_issue = 0 if key == "uuid:1e25364f-6fd7-4898-9631-7343b0d1b0f7" & hh_13_2_total == 21
replace ind_issue = 0 if key == "uuid:59d24152-883e-4d28-9e64-01a5d66013fb" & hh_13_2_total == 6
replace ind_issue = 0 if key == "uuid:20c6f12b-0474-449e-88cf-7e4bb8572ccf" & hh_13_2_total == 35
replace ind_issue = 0 if key == "uuid:5dacec94-0b4b-459d-bc8d-7ca6379119bc" & hh_13_2_total == 35
replace ind_issue = 0 if key == "uuid:26b0ed38-3990-4668-bc30-dff21cdb74c0" & hh_13_2_total == 38
replace ind_issue = 0 if key == "uuid:63f9341b-cb38-461f-b438-cb6e08f9b1c7" & hh_13_2_total == 9
replace ind_issue = 0 if key == "uuid:51bbc017-d8de-4e30-9a9b-3594922d7738" & hh_13_2_total == 25
replace ind_issue = 0 if key == "uuid:69019e28-f6ad-44ef-a357-cced4225faa1" & hh_13_3_total == 5
replace ind_issue = 0 if key == "uuid:51bbc017-d8de-4e30-9a9b-3594922d7738" & hh_13_3_total == 42
replace ind_issue = 0 if key == "uuid:16671bba-7134-410e-adcc-d943d1515258" & hh_13_3_total == 8
replace ind_issue = 0 if key == "uuid:952f24db-030b-475b-a2cb-f383305e65e3" & hh_13_3_total == 21
replace ind_issue = 0 if key == "uuid:01639e53-ecd4-43fe-bf12-bd59d60e79e6" & hh_13_3_total == 60
replace ind_issue = 0 if key == "uuid:21a44c69-6d8a-4ded-b1b8-98280d8f04c1" & hh_13_3_total == 14
replace ind_issue = 0 if key == "uuid:d9a96108-6ff6-4a01-b035-8c4edbc3d016" & hh_13_3_total == 13
replace ind_issue = 0 if key == "uuid:10cdabf2-f022-4539-8c2b-7eaa1bead1d1" & hh_13_3_total == 28
replace ind_issue = 0 if key == "uuid:bc6c1d3d-fa4b-4767-9ae5-c7422db73c6c" & hh_13_3_total == 27
replace ind_issue = 0 if key == "uuid:91bc113a-de51-4284-9c11-5f9402f5de2a" & hh_13_3_total == 14
replace ind_issue = 0 if key == "uuid:7927b2e6-e46d-4be1-8163-7669e0733149" & hh_13_3_total == 55
replace ind_issue = 0 if key == "uuid:f4aa1eed-3ba6-43e0-84f4-3c3a2e7c1e14" & hh_13_3_total == 28
replace ind_issue = 0 if key == "uuid:4a93facc-81f2-47bf-834f-ade9801ee7c8" & hh_13_3_total == 21
replace ind_issue = 0 if key == "uuid:cb84f382-f029-467d-bb51-4ee455ca0c9d" & hh_13_3_total == 11
replace ind_issue = 0 if key == "uuid:18b5cc2f-a861-4487-ba1d-8bb0bbbe13cc" & hh_13_3_total == 77
replace ind_issue = 0 if key == "uuid:72ed82ab-7a9a-4eb1-bff3-db27dcae2ad8" & hh_13_3_total == 49
replace ind_issue = 0 if key == "uuid:175f92a9-aded-464b-a5ef-684193f755d6" & hh_13_3_total == 55
replace ind_issue = 0 if key == "uuid:5dacec94-0b4b-459d-bc8d-7ca6379119bc" & hh_13_4_total == 21
replace ind_issue = 0 if key == "uuid:4a93facc-81f2-47bf-834f-ade9801ee7c8" & hh_13_4_total == 14
replace ind_issue = 0 if key == "uuid:6995a33b-0e9c-458f-9e49-d08266c63a04" & hh_13_4_total == 21
replace ind_issue = 0 if key == "uuid:51bbc017-d8de-4e30-9a9b-3594922d7738" & hh_13_4_total == 32
replace ind_issue = 0 if key == "uuid:480e7175-e4f0-467b-ae3d-d2d3c957d314" & hh_13_4_total == 96
replace ind_issue = 0 if key == "uuid:f4aa1eed-3ba6-43e0-84f4-3c3a2e7c1e14" & hh_13_4_total == 28
replace ind_issue = 0 if key == "uuid:10cdabf2-f022-4539-8c2b-7eaa1bead1d1" & hh_13_4_total == 25
replace ind_issue = 0 if key == "uuid:16671bba-7134-410e-adcc-d943d1515258" & hh_13_4_total == 21
replace ind_issue = 0 if key == "uuid:58f97ff1-d328-4186-b783-6e4eb46e1683" & hh_13_4_total == 18
replace ind_issue = 0 if key == "uuid:4894e36a-965b-440d-aa57-d70254caa566" & hh_13_4_total == 14
replace ind_issue = 0 if key == "uuid:21a44c69-6d8a-4ded-b1b8-98280d8f04c1" & hh_13_4_total == 15
replace ind_issue = 0 if key == "uuid:cb84f382-f029-467d-bb51-4ee455ca0c9d" & hh_13_4_total == 28
replace ind_issue = 0 if key == "uuid:72ed82ab-7a9a-4eb1-bff3-db27dcae2ad8" & hh_13_4_total == 21
replace ind_issue = 0 if key == "uuid:44e9ec51-4de3-4be7-985d-1aed9746258a" & hh_13_4_total == 35
replace ind_issue = 0 if key == "uuid:18b5cc2f-a861-4487-ba1d-8bb0bbbe13cc" & hh_13_4_total == 27
replace ind_issue = 0 if key == "uuid:d9a96108-6ff6-4a01-b035-8c4edbc3d016" & hh_13_4_total == 9
replace ind_issue = 0 if key == "uuid:63f9341b-cb38-461f-b438-cb6e08f9b1c7" & hh_13_5_total == 25
replace ind_issue = 0 if key == "uuid:bc6c1d3d-fa4b-4767-9ae5-c7422db73c6c" & hh_13_5_total == 10
replace ind_issue = 0 if key == "uuid:16671bba-7134-410e-adcc-d943d1515258" & hh_13_5_total == 69
replace ind_issue = 0 if key == "uuid:f69cb7e8-65de-4496-b54e-bc11994583e7" & hh_13_5_total == 48
replace ind_issue = 0 if key == "uuid:1e25364f-6fd7-4898-9631-7343b0d1b0f7" & hh_13_5_total == 21
replace ind_issue = 0 if key == "uuid:d56edb36-89c5-436c-93d2-f3e9f0f601a5" & hh_13_5_total == 70
replace ind_issue = 0 if key == "uuid:952f24db-030b-475b-a2cb-f383305e65e3" & hh_13_5_total == 28
replace ind_issue = 0 if key == "uuid:10cdabf2-f022-4539-8c2b-7eaa1bead1d1" & hh_13_5_total == 42
replace ind_issue = 0 if key == "uuid:dbaf39d5-e977-4dad-a0fd-d3f8f978a2c5" & hh_13_5_total == 63
replace ind_issue = 0 if key == "uuid:e256772b-6441-4b1e-9274-0991789ff4e9" & hh_13_5_total == 30
replace ind_issue = 0 if key == "uuid:d36c69ef-5cf2-4f39-bde7-7beb5520e907" & hh_13_5_total == 9
replace ind_issue = 0 if key == "uuid:72ed82ab-7a9a-4eb1-bff3-db27dcae2ad8" & hh_13_5_total == 19
replace ind_issue = 0 if key == "uuid:4a93facc-81f2-47bf-834f-ade9801ee7c8" & hh_13_5_total == 21
replace ind_issue = 0 if key == "uuid:dfbffc80-1e52-496c-ba85-f1692acbd5f0" & hh_13_6_total == 9
replace ind_issue = 0 if key == "uuid:d9a96108-6ff6-4a01-b035-8c4edbc3d016" & hh_13_6_total == 11
replace ind_issue = 0 if key == "uuid:dbaf39d5-e977-4dad-a0fd-d3f8f978a2c5" & hh_13_6_total == 63
replace ind_issue = 0 if key == "uuid:e256772b-6441-4b1e-9274-0991789ff4e9" & hh_13_6_total == 24
replace ind_issue = 0 if key == "uuid:1e25364f-6fd7-4898-9631-7343b0d1b0f7" & hh_13_6_total == 21
replace ind_issue = 0 if key == "uuid:51bbc017-d8de-4e30-9a9b-3594922d7738" & hh_13_6_total == 21
replace ind_issue = 0 if key == "uuid:da41eaad-41fa-4adb-b7c6-7c521bc678cf" & hh_13_6_total == 42
replace ind_issue = 0 if key == "uuid:4894e36a-965b-440d-aa57-d70254caa566" & hh_13_6_total == 14
replace ind_issue = 0 if key == "uuid:f69cb7e8-65de-4496-b54e-bc11994583e7" & hh_13_6_total == 25
replace ind_issue = 0 if key == "uuid:f4aa1eed-3ba6-43e0-84f4-3c3a2e7c1e14" & hh_13_6_total == 77
replace ind_issue = 0 if key == "uuid:8177e88d-e580-4cc3-837c-68966c731d12" & hh_13_6_total == 48
replace ind_issue = 0 if key == "uuid:21a44c69-6d8a-4ded-b1b8-98280d8f04c1" & hh_13_6_total == 22
replace ind_issue = 0 if key == "uuid:16671bba-7134-410e-adcc-d943d1515258" & hh_13_6_total == 21
replace ind_issue = 0 if key == "uuid:44e9ec51-4de3-4be7-985d-1aed9746258a" & hh_13_6_total == 21
replace ind_issue = 0 if key == "uuid:d821e832-2f31-4039-9003-20d913da3311" & hh_13_6_total == 2
replace ind_issue = 0 if key == "uuid:72ed82ab-7a9a-4eb1-bff3-db27dcae2ad8" & hh_13_6_total == 21
replace ind_issue = 0 if key == "uuid:fff75691-71ee-4a1a-9ea0-807f2bd5908a" & hh_13_7_total == 4
replace ind_issue = 0 if key == "uuid:63f9341b-cb38-461f-b438-cb6e08f9b1c7" & hh_13_7_total == 21
replace ind_issue = 0 if key == "uuid:7927b2e6-e46d-4be1-8163-7669e0733149" & hh_13_7_total == 28
replace ind_issue = 0 if key == "uuid:21a44c69-6d8a-4ded-b1b8-98280d8f04c1" & hh_13_7_total == 23
replace ind_issue = 0 if key == "uuid:4894e36a-965b-440d-aa57-d70254caa566" & hh_13_7_total == 16
replace ind_issue = 0 if key == "uuid:9592ef45-c1b9-4b5b-a4d6-040ac97fdc5f" & hh_13_7_total == 35
replace ind_issue = 0 if key == "uuid:72ed82ab-7a9a-4eb1-bff3-db27dcae2ad8" & hh_13_7_total == 21
replace ind_issue = 0 if key == "uuid:cb84f382-f029-467d-bb51-4ee455ca0c9d" & hh_13_7_total == 35
replace ind_issue = 0 if key == "uuid:69019e28-f6ad-44ef-a357-cced4225faa1" & hh_13_7_total == 6
replace ind_issue = 0 if key == "uuid:1e25364f-6fd7-4898-9631-7343b0d1b0f7" & hh_13_7_total == 48
replace ind_issue = 0 if key == "uuid:4a93facc-81f2-47bf-834f-ade9801ee7c8" & hh_13_8_total == 21
replace ind_issue = 0 if key == "uuid:dbaf39d5-e977-4dad-a0fd-d3f8f978a2c5" & hh_13_8_total == 49
replace ind_issue = 0 if key == "uuid:91bc113a-de51-4284-9c11-5f9402f5de2a" & hh_13_8_total == 24
replace ind_issue = 0 if key == "uuid:7927b2e6-e46d-4be1-8163-7669e0733149" & hh_13_8_total == 25
replace ind_issue = 0 if key == "uuid:2da18445-e0f4-4b04-a536-bfdaaf05e974" & hh_13_8_total == 19
replace ind_issue = 0 if key == "uuid:9592ef45-c1b9-4b5b-a4d6-040ac97fdc5f" & hh_13_9_total == 35
replace ind_issue = 0 if key == "uuid:62f6265a-d35b-4b63-a24e-e159377cb165" & hh_13_9_total == 62
replace ind_issue = 0 if key == "uuid:9211237f-7b08-4c13-b007-2bc27f4fe27b" & hh_13_10_total == 10
replace ind_issue = 0 if key == "uuid:91d4c4b4-ac34-42e9-9e3d-c3491b708ca0" & hh_13_10_total == 71
replace ind_issue = 0 if key == "uuid:7857f5dd-b97f-42c2-9506-5fa8bf7847cf" & hh_13_10_total == 16
replace ind_issue = 0 if key == "uuid:31c89eaf-8d8c-4319-a80a-e476001b5a9e" & hh_13_10_total == 28
replace ind_issue = 0 if key == "uuid:677eb96e-7e1d-4cce-93d3-f743b6c3290c" & hh_13_10_total == 28
replace ind_issue = 0 if key == "uuid:b8042304-f055-4121-8b87-84b76c897d63" & hh_13_10_total == 4
replace ind_issue = 0 if key == "uuid:31c89eaf-8d8c-4319-a80a-e476001b5a9e" & hh_13_11_total == 43
replace ind_issue = 0 if key == "uuid:f7c1d3b1-0f51-495c-9ed5-7fd642518c73" & hh_13_11_total == 27
replace ind_issue = 0 if key == "uuid:f7c1d3b1-0f51-495c-9ed5-7fd642518c73" & hh_13_12_total == 14
replace ind_issue = 0 if key == "uuid:e73c95dc-e245-49a9-abb6-1f9f95bc5fb1" & hh_13_12_total == 2
replace ind_issue = 0 if key == "uuid:9c021088-c048-4623-a9cb-ea3cd9292720" & hh_13_13_total == 5
replace ind_issue = 0 if key == "uuid:f7c1d3b1-0f51-495c-9ed5-7fd642518c73" & hh_13_14_total == 10
replace ind_issue = 0 if key == "uuid:9211237f-7b08-4c13-b007-2bc27f4fe27b" & hh_13_1_total == 10
replace ind_issue = 0 if key == "uuid:869babf6-be9d-49ad-a3e6-b949d3719a28" & hh_13_1_total == 7
replace ind_issue = 0 if key == "uuid:00dc6224-fae4-4de7-9d21-2f418b471aca" & hh_13_1_total == 6
replace ind_issue = 0 if key == "uuid:677eb96e-7e1d-4cce-93d3-f743b6c3290c" & hh_13_1_total == 8
replace ind_issue = 0 if key == "uuid:31c89eaf-8d8c-4319-a80a-e476001b5a9e" & hh_13_1_total == 31
replace ind_issue = 0 if key == "uuid:91d4c4b4-ac34-42e9-9e3d-c3491b708ca0" & hh_13_1_total == 4
replace ind_issue = 0 if key == "uuid:61ae58e8-67ed-407f-94e6-c83fe4454247" & hh_13_1_total == 49
replace ind_issue = 0 if key == "uuid:9f0c73e5-660c-4f8f-9be1-e4f4806229f1" & hh_13_1_total == 8
replace ind_issue = 0 if key == "uuid:61ae58e8-67ed-407f-94e6-c83fe4454247" & hh_13_2_total == 36
replace ind_issue = 0 if key == "uuid:9211237f-7b08-4c13-b007-2bc27f4fe27b" & hh_13_2_total == 27
replace ind_issue = 0 if key == "uuid:65cbfec8-d9d7-4cda-9341-546edf1ffc8b" & hh_13_2_total == 4
replace ind_issue = 0 if key == "uuid:9a2701e9-2f77-43c6-948a-00c892e2739f" & hh_13_2_total == 8
replace ind_issue = 0 if key == "uuid:31c89eaf-8d8c-4319-a80a-e476001b5a9e" & hh_13_2_total == 32
replace ind_issue = 0 if key == "uuid:91d4c4b4-ac34-42e9-9e3d-c3491b708ca0" & hh_13_2_total == 12
replace ind_issue = 0 if key == "uuid:dce059c7-c3d8-4f48-9e71-2e6e6ced417b" & hh_13_2_total == 3
replace ind_issue = 0 if key == "uuid:001728aa-dfd3-4b19-88d9-daa7c05791c6" & hh_13_2_total == 3
replace ind_issue = 0 if key == "uuid:18f89f48-e1c9-4d26-a54d-9279f5ca0355" & hh_13_2_total == 7
replace ind_issue = 0 if key == "uuid:e73c95dc-e245-49a9-abb6-1f9f95bc5fb1" & hh_13_2_total == 6
replace ind_issue = 0 if key == "uuid:f46febb7-4f27-4491-8bcb-e26865df976b" & hh_13_3_total == 22
replace ind_issue = 0 if key == "uuid:2fba3e48-9d7b-4b32-ab2d-990fc6d2d413" & hh_13_3_total == 4
replace ind_issue = 0 if key == "uuid:001728aa-dfd3-4b19-88d9-daa7c05791c6" & hh_13_3_total == 12
replace ind_issue = 0 if key == "uuid:70dadb25-9ae1-4772-b406-419c7d134f96" & hh_13_3_total == 6
replace ind_issue = 0 if key == "uuid:fdf33b9e-6ab7-470a-aa87-213e9241982e" & hh_13_3_total == 6
replace ind_issue = 0 if key == "uuid:4219536c-3d1b-4d77-a065-f63913f70d0e" & hh_13_3_total == 41
replace ind_issue = 0 if key == "uuid:7857f5dd-b97f-42c2-9506-5fa8bf7847cf" & hh_13_3_total == 18
replace ind_issue = 0 if key == "uuid:9211237f-7b08-4c13-b007-2bc27f4fe27b" & hh_13_3_total == 9
replace ind_issue = 0 if key == "uuid:887b6285-2eca-449b-885e-3e8a3e9733ac" & hh_13_3_total == 20
replace ind_issue = 0 if key == "uuid:b523b6ee-b33f-4331-ac8e-e3770b31148e" & hh_13_3_total == 21
replace ind_issue = 0 if key == "uuid:31c89eaf-8d8c-4319-a80a-e476001b5a9e" & hh_13_3_total == 34
replace ind_issue = 0 if key == "uuid:c3e6b5a4-b144-4260-bd64-715cff263da9" & hh_13_4_total == 4
replace ind_issue = 0 if key == "uuid:9211237f-7b08-4c13-b007-2bc27f4fe27b" & hh_13_4_total == 18
replace ind_issue = 0 if key == "uuid:6328ecdf-d662-4f49-b937-36e8d7430b79" & hh_13_4_total == 4
replace ind_issue = 0 if key == "uuid:dce059c7-c3d8-4f48-9e71-2e6e6ced417b" & hh_13_4_total == 5
replace ind_issue = 0 if key == "uuid:91d4c4b4-ac34-42e9-9e3d-c3491b708ca0" & hh_13_4_total == 3
replace ind_issue = 0 if key == "uuid:3adf763f-622e-4cf3-9e2e-cb5a9909deb2" & hh_13_4_total == 14
replace ind_issue = 0 if key == "uuid:9a2701e9-2f77-43c6-948a-00c892e2739f" & hh_13_4_total == 10
replace ind_issue = 0 if key == "uuid:7857f5dd-b97f-42c2-9506-5fa8bf7847cf" & hh_13_4_total == 28
replace ind_issue = 0 if key == "uuid:31c89eaf-8d8c-4319-a80a-e476001b5a9e" & hh_13_4_total == 9
replace ind_issue = 0 if key == "uuid:72dbf5df-2ca4-419b-8876-f54246c9919d" & hh_13_5_total == 6
replace ind_issue = 0 if key == "uuid:001728aa-dfd3-4b19-88d9-daa7c05791c6" & hh_13_5_total == 3
replace ind_issue = 0 if key == "uuid:b523b6ee-b33f-4331-ac8e-e3770b31148e" & hh_13_5_total == 14
replace ind_issue = 0 if key == "uuid:29afbbec-6664-48db-9cc4-024245c48be8" & hh_13_5_total == 9
replace ind_issue = 0 if key == "uuid:9211237f-7b08-4c13-b007-2bc27f4fe27b" & hh_13_5_total == 9
replace ind_issue = 0 if key == "uuid:4219536c-3d1b-4d77-a065-f63913f70d0e" & hh_13_5_total == 36
replace ind_issue = 0 if key == "uuid:f7c1d3b1-0f51-495c-9ed5-7fd642518c73" & hh_13_5_total == 26
replace ind_issue = 0 if key == "uuid:dce059c7-c3d8-4f48-9e71-2e6e6ced417b" & hh_13_5_total == 8
replace ind_issue = 0 if key == "uuid:61ae58e8-67ed-407f-94e6-c83fe4454247" & hh_13_5_total == 38
replace ind_issue = 0 if key == "uuid:af2c741b-183a-419c-aac4-334755418d88" & hh_13_5_total == 28
replace ind_issue = 0 if key == "uuid:91d4c4b4-ac34-42e9-9e3d-c3491b708ca0" & hh_13_5_total == 6
replace ind_issue = 0 if key == "uuid:61ae58e8-67ed-407f-94e6-c83fe4454247" & hh_13_6_total == 48
replace ind_issue = 0 if key == "uuid:95d5efa7-920e-4c24-a832-47290c8adf86" & hh_13_6_total == 16
replace ind_issue = 0 if key == "uuid:3adf763f-622e-4cf3-9e2e-cb5a9909deb2" & hh_13_6_total == 19
replace ind_issue = 0 if key == "uuid:2ec47a04-9451-4eae-863a-709abcb0f494" & hh_13_6_total == 34
replace ind_issue = 0 if key == "uuid:e73c95dc-e245-49a9-abb6-1f9f95bc5fb1" & hh_13_7_total == 28
replace ind_issue = 0 if key == "uuid:f7c1d3b1-0f51-495c-9ed5-7fd642518c73" & hh_13_7_total == 12
replace ind_issue = 0 if key == "uuid:c755bc6d-e89f-4f06-bf41-d36b813d17ef" & hh_13_7_total == 6
replace ind_issue = 0 if key == "uuid:3adf763f-622e-4cf3-9e2e-cb5a9909deb2" & hh_13_7_total == 18
replace ind_issue = 0 if key == "uuid:61ae58e8-67ed-407f-94e6-c83fe4454247" & hh_13_7_total == 42
replace ind_issue = 0 if key == "uuid:91d4c4b4-ac34-42e9-9e3d-c3491b708ca0" & hh_13_7_total == 6
replace ind_issue = 0 if key == "uuid:2ec47a04-9451-4eae-863a-709abcb0f494" & hh_13_7_total == 7
replace ind_issue = 0 if key == "uuid:757230ee-0ed7-43a2-ab87-de28c4339fd7" & hh_13_7_total == 5
replace ind_issue = 0 if key == "uuid:7857f5dd-b97f-42c2-9506-5fa8bf7847cf" & hh_13_7_total == 46
replace ind_issue = 0 if key == "uuid:95d5efa7-920e-4c24-a832-47290c8adf86" & hh_13_7_total == 18
replace ind_issue = 0 if key == "uuid:31c89eaf-8d8c-4319-a80a-e476001b5a9e" & hh_13_7_total == 16
replace ind_issue = 0 if key == "uuid:9a2701e9-2f77-43c6-948a-00c892e2739f" & hh_13_7_total == 5
replace ind_issue = 0 if key == "uuid:869babf6-be9d-49ad-a3e6-b949d3719a28" & hh_13_7_total == 8
replace ind_issue = 0 if key == "uuid:29afbbec-6664-48db-9cc4-024245c48be8" & hh_13_7_total == 11
replace ind_issue = 0 if key == "uuid:9211237f-7b08-4c13-b007-2bc27f4fe27b" & hh_13_8_total == 10
replace ind_issue = 0 if key == "uuid:7857f5dd-b97f-42c2-9506-5fa8bf7847cf" & hh_13_8_total == 28
replace ind_issue = 0 if key == "uuid:dce059c7-c3d8-4f48-9e71-2e6e6ced417b" & hh_13_8_total == 5
replace ind_issue = 0 if key == "uuid:887b6285-2eca-449b-885e-3e8a3e9733ac" & hh_13_8_total == 18
replace ind_issue = 0 if key == "uuid:215540ae-d768-4832-817a-9fdcc1755eb2" & hh_13_8_total == 2
replace ind_issue = 0 if key == "uuid:e73c95dc-e245-49a9-abb6-1f9f95bc5fb1" & hh_13_8_total == 10
replace ind_issue = 0 if key == "uuid:b8042304-f055-4121-8b87-84b76c897d63" & hh_13_8_total == 4
replace ind_issue = 0 if key == "uuid:ca23115b-7957-4302-8b26-511c5243ee05" & hh_13_8_total == 6
replace ind_issue = 0 if key == "uuid:61f3b362-cd7a-4dec-9d7c-dc982eb1def9" & hh_13_8_total == 4
replace ind_issue = 0 if key == "uuid:91d4c4b4-ac34-42e9-9e3d-c3491b708ca0" & hh_13_9_total == 87
replace ind_issue = 0 if key == "uuid:9211237f-7b08-4c13-b007-2bc27f4fe27b" & hh_13_9_total == 11
replace ind_issue = 0 if key == "uuid:7857f5dd-b97f-42c2-9506-5fa8bf7847cf" & hh_13_9_total == 28
replace ind_issue = 0 if key == "uuid:3453d9d5-708b-4f02-8897-cc77ef1f6673" & hh_13_9_total == 5
replace ind_issue = 0 if key == "uuid:677eb96e-7e1d-4cce-93d3-f743b6c3290c" & hh_13_9_total == 12
replace ind_issue = 0 if key == "uuid:28e5893e-1205-4647-b375-2ab2e07290f8" & hh_13_11_total == 9
replace ind_issue = 0 if key == "uuid:3005e9a7-0c4f-4735-a3ee-13a5bd96f68e" & hh_13_1_total == 27
replace ind_issue = 0 if key == "uuid:57141e25-c8fe-4256-865c-ffb74b8722f1" & hh_13_1_total == 9
replace ind_issue = 0 if key == "uuid:1e1c2c1b-4f20-4c81-aaa7-6177fd8e9133" & hh_13_1_total == 15
replace ind_issue = 0 if key == "uuid:9c58f46f-beae-4fef-b4ae-65b5d22dbae8" & hh_13_1_total == 28
replace ind_issue = 0 if key == "uuid:a389351c-405b-4fcf-bc2d-4f9b647cd821" & hh_13_1_total == 4
replace ind_issue = 0 if key == "uuid:12bd5e4f-c269-49d9-9ac4-31ce86bde8a5" & hh_13_1_total == 3
replace ind_issue = 0 if key == "uuid:1e57be6b-bcb6-49dd-b73c-989a0acc3f5c" & hh_13_2_total == 0
replace ind_issue = 0 if key == "uuid:da458b40-5f33-47ce-b317-c2e278cd8d79" & hh_13_2_total == 9
replace ind_issue = 0 if key == "uuid:b31f7951-4d7b-41af-b373-a0a283ceba75" & hh_13_2_total == 8
replace ind_issue = 0 if key == "uuid:d856f3b3-2b61-4838-ba0b-4f8a6ea18725" & hh_13_2_total == 7
replace ind_issue = 0 if key == "uuid:9395c227-458d-4a0c-a7ff-11cb8e93046b" & hh_13_2_total == 34
replace ind_issue = 0 if key == "uuid:57141e25-c8fe-4256-865c-ffb74b8722f1" & hh_13_2_total == 4
replace ind_issue = 0 if key == "uuid:102325d0-e44c-43d8-bf45-03fc0d4bbeeb" & hh_13_2_total == 0
replace ind_issue = 0 if key == "uuid:b81044cb-fdfd-41a7-b76b-70a36b935af3" & hh_13_2_total == 2
replace ind_issue = 0 if key == "uuid:86eb5846-fbde-44a1-b04c-7dab574f678b" & hh_13_2_total == 2
replace ind_issue = 0 if key == "uuid:e053fdfb-769e-46cb-963f-d7d62859c636" & hh_13_2_total == 2
replace ind_issue = 0 if key == "uuid:0952b916-0478-409a-aad7-eab78718a734" & hh_13_3_total == 7
replace ind_issue = 0 if key == "uuid:9c58f46f-beae-4fef-b4ae-65b5d22dbae8" & hh_13_3_total == 9
replace ind_issue = 0 if key == "uuid:102325d0-e44c-43d8-bf45-03fc0d4bbeeb" & hh_13_3_total == 0
replace ind_issue = 0 if key == "uuid:75a4d2b2-cae3-4345-aeaa-920a8a97c89c" & hh_13_3_total == 5
replace ind_issue = 0 if key == "uuid:9395c227-458d-4a0c-a7ff-11cb8e93046b" & hh_13_3_total == 0
replace ind_issue = 0 if key == "uuid:fc088a43-edd6-4622-af6c-63532af6f8d7" & hh_13_3_total == 11
replace ind_issue = 0 if key == "uuid:57141e25-c8fe-4256-865c-ffb74b8722f1" & hh_13_4_total == 10
replace ind_issue = 0 if key == "uuid:a0dfe598-6001-469b-a7d8-108daf3c97ff" & hh_13_4_total == 15
replace ind_issue = 0 if key == "uuid:a389351c-405b-4fcf-bc2d-4f9b647cd821" & hh_13_4_total == 5
replace ind_issue = 0 if key == "uuid:a850d7a9-ed56-4f03-8045-6e298dae3fff" & hh_13_4_total == 3
replace ind_issue = 0 if key == "uuid:1cf5e8e5-012a-4791-a399-071c5984af16" & hh_13_4_total == 14
replace ind_issue = 0 if key == "uuid:b81044cb-fdfd-41a7-b76b-70a36b935af3" & hh_13_4_total == 4
replace ind_issue = 0 if key == "uuid:0adb569b-f2f6-43a3-9ad1-5f7f73f18f94" & hh_13_5_total == 11
replace ind_issue = 0 if key == "uuid:7f8ec050-0ea9-4858-b4ec-962ff43746dc" & hh_13_5_total == 0
replace ind_issue = 0 if key == "uuid:a850d7a9-ed56-4f03-8045-6e298dae3fff" & hh_13_6_total == 5
replace ind_issue = 0 if key == "uuid:28e5893e-1205-4647-b375-2ab2e07290f8" & hh_13_7_total == 10
replace ind_issue = 0 if key == "uuid:86db61ce-f9cb-4f7a-b0a5-66ffddfdca6a" & hh_13_7_total == 8
replace ind_issue = 0 if key == "uuid:28e5893e-1205-4647-b375-2ab2e07290f8" & hh_13_8_total == 7
replace ind_issue = 0 if key == "uuid:434fcca5-a3ae-4bdd-a61c-aa38dad0ff28" & hh_13_8_total == 4
replace ind_issue = 0 if key == "uuid:1cf5e8e5-012a-4791-a399-071c5984af16" & hh_13_8_total == 2
replace ind_issue = 0 if key == "uuid:28e5893e-1205-4647-b375-2ab2e07290f8" & hh_13_9_total == 9
replace ind_issue = 0 if key == "uuid:a174f3ae-1533-4f24-9056-c76dc2c8ec40" & hh_13_13_total == 0
replace ind_issue = 0 if key == "uuid:e6efc18c-7a7b-4132-8535-6e7dff6a7ac7" & hh_13_1_total == 0
replace ind_issue = 0 if key == "uuid:2d69cae2-bc11-4173-a5df-4264bd41d410" & hh_13_1_total == 0
replace ind_issue = 0 if key == "uuid:e7469bf6-d4e8-47ee-ae36-7e0c6e04f083" & hh_13_1_total == 7
replace ind_issue = 0 if key == "uuid:26971b58-f29b-4ca2-835b-f25a19f057c3" & hh_13_1_total == 3
replace ind_issue = 0 if key == "uuid:6bd56dff-d624-4990-a041-d70e21df0faa" & hh_13_3_total == 4
replace ind_issue = 0 if key == "uuid:c46b3505-c76a-4882-b658-2fd4db8c3c72" & hh_13_3_total == 6
replace ind_issue = 0 if key == "uuid:e6efc18c-7a7b-4132-8535-6e7dff6a7ac7" & hh_13_3_total == 0
replace ind_issue = 0 if key == "uuid:90d1e1e8-e397-433d-9199-1031cac8b8b2" & hh_13_3_total == 8
replace ind_issue = 0 if key == "uuid:33df7be4-7ed3-4333-b350-13d169e5f9e8" & hh_13_4_total == 3
replace ind_issue = 0 if key == "uuid:b4135843-09e3-44e8-b649-7f6dbd35f542" & hh_13_4_total == 12
replace ind_issue = 0 if key == "uuid:2d69cae2-bc11-4173-a5df-4264bd41d410" & hh_13_4_total == 0
replace ind_issue = 0 if key == "uuid:ae90cd51-ee58-48a1-a6fe-889fcf08947c" & hh_13_7_total == 6
replace ind_issue = 0 if key == "uuid:b9db8503-f920-47d7-8c51-d6479521ef3b" & hh_13_12_total == 4
replace ind_issue = 0 if key == "uuid:5997c696-23e5-4aff-8dcc-4c0351688c8a" & hh_13_13_total == 11
replace ind_issue = 0 if key == "uuid:08f0ed54-98f9-4427-9b44-4e660b0b587d" & hh_13_13_total == 8
replace ind_issue = 0 if key == "uuid:b9db8503-f920-47d7-8c51-d6479521ef3b" & hh_13_16_total == 8
replace ind_issue = 0 if key == "uuid:84022303-60da-4955-8d55-0a9ba4c498c9" & hh_13_1_total == 42
replace ind_issue = 0 if key == "uuid:61320229-0c02-48f3-8f7e-de956c47901f" & hh_13_1_total == 0
replace ind_issue = 0 if key == "uuid:322ec7b2-ba87-45b9-812d-dbfdaa8e84b9" & hh_13_1_total == 21
replace ind_issue = 0 if key == "uuid:568b7e32-2819-465b-804c-abb5f3234367" & hh_13_1_total == 28
replace ind_issue = 0 if key == "uuid:648cabd0-d8bb-4edd-b54d-79f43e1898f6" & hh_13_5_total == 20
replace ind_issue = 0 if key == "uuid:322ec7b2-ba87-45b9-812d-dbfdaa8e84b9" & hh_13_6_total == 7
replace ind_issue = 0 if key == "uuid:54640edc-0c24-4d19-b5fd-1ef7b02ff3f7" & hh_13_7_total == 21
replace ind_issue = 0 if key == "uuid:648cabd0-d8bb-4edd-b54d-79f43e1898f6" & hh_13_7_total == 21
replace ind_issue = 0 if key == "uuid:5997c696-23e5-4aff-8dcc-4c0351688c8a" & hh_13_8_total == 5
replace ind_issue = 0 if key == "uuid:9b56445b-a27a-487d-81c1-8cf08b18a3f4" & hh_13_8_total == 6
replace ind_issue = 0 if key == "uuid:8e5887d9-5caf-49b1-9937-bf3194be19df" & hh_13_10_total == 9
replace ind_issue = 0 if key == "uuid:a179c971-c8d3-4d77-9160-4890d793dad1" & hh_13_10_total == 5
replace ind_issue = 0 if key == "uuid:1a6dbc16-0aa9-4f14-8d83-03032f5156b9" & hh_13_1_total == 12
replace ind_issue = 0 if key == "uuid:4927f745-47f3-4291-a4df-cc42a54c0c5f" & hh_13_2_total == 8
replace ind_issue = 0 if key == "uuid:4cfdebc5-579b-42d0-b794-b15ca3d76d05" & hh_13_2_total == 14
replace ind_issue = 0 if key == "uuid:39c6bbac-ab4d-40dd-ab10-675b14414eca" & hh_13_2_total == 5
replace ind_issue = 0 if key == "uuid:e3d4afc3-003b-4cf9-ac93-63c39fbaa1c3" & hh_13_5_total == 5
replace ind_issue = 0 if key == "uuid:fea53255-02cf-493f-823d-016dcc00775a" & hh_13_5_total == 2
replace ind_issue = 0 if key == "uuid:3cfdea2d-a374-4d10-9e8b-5bb8e3d04dea" & hh_13_8_total == 6
replace ind_issue = 0 if key == "uuid:927795d3-0966-4cc6-9bd2-0ceee0f8bbe8" & hh_13_9_total == 4
replace ind_issue = 0 if key == "uuid:5876db44-bf51-4cb8-9785-c206925c8c68" & hh_13_3_total == 5
replace ind_issue = 0 if key == "uuid:a70da4bd-2c9f-440f-9943-870137678797" & hh_13_3_total == 14
replace ind_issue = 0 if key == "uuid:5876db44-bf51-4cb8-9785-c206925c8c68" & hh_13_4_total == 8
replace ind_issue = 0 if key == "uuid:74c9db0a-64c6-41bd-82d1-d85f621a6e1a" & hh_13_6_total == 3
replace ind_issue = 0 if key == "uuid:404d64bb-771e-4c85-86ce-ec1ea9b63647" & hh_13_7_total == 14
replace ind_issue = 0 if key == "uuid:559b32b7-38a6-4ec1-bcac-d6299c6aeca9" & hh_13_1_total == 4
replace ind_issue = 0 if key == "uuid:66b0b7d0-c37f-4ed4-9b1f-72bb0583ba96" & hh_13_2_total == 3
replace ind_issue = 0 if key == "uuid:559b32b7-38a6-4ec1-bcac-d6299c6aeca9" & hh_13_3_total == 8
replace ind_issue = 0 if key == "uuid:d92acf0d-61ee-4d70-b3b8-c109499ae020" & hh_13_3_total == 42
replace ind_issue = 0 if key == "uuid:264e050c-ca67-433c-bc5b-fa53335c1755" & hh_13_3_total == 3
replace ind_issue = 0 if key == "uuid:a9d8381b-470f-4704-9042-4af983b17990" & hh_13_6_total == 0
*/

* part 3
**** Import the corrections
import excel "$corrections\PART_3 CORRECTED", clear firstrow

**** Keep those issues they confirmed [Lots of -9's lets check this with molly]
keep if !(correction == "64" & key == "uuid:480e7175-e4f0-467b-ae3d-d2d3c957d314")
keep if !(correction == "38" & key == "uuid:61ae58e8-67ed-407f-94e6-c83fe4454247")
keep if !(correction == "73" & key == "uuid:4219536c-3d1b-4d77-a065-f63913f70d0e")
keep if !(correction == "52" & key == "uuid:91d4c4b4-ac34-42e9-9e3d-c3491b708ca0")

**** Export the confirmed... and use the following excel formula to add to the checks to skip over these for now
save "$corrected\DISES_Household_Corrections_Confirmed_Part3.dta", replace
export delimited "$corrected\DISES_Household_Corrections_Confirmed_Part3.csv", replace

* excel formula
* ="replace ind_issue = 0 if key == "&CHAR(34)&D2&CHAR(34)&" & "&N2&" == "&P2
/*
replace ind_issue = 0 if key == "uuid:d7add78b-5c6b-4f09-a15b-ee9ff0de69e8" & hh_21_total_10 == 4
replace ind_issue = 0 if key == "uuid:8fdb6f45-873e-4460-b1b7-1ef184fa4ab6" & hh_21_total_11 == 3
replace ind_issue = 0 if key == "uuid:57bb8e54-caf8-49c9-a0f5-fd636d2a2592" & hh_21_total_2 == 4
replace ind_issue = 0 if key == "uuid:950634d7-6af7-48f4-81f2-23e84812d304" & hh_21_total_4 == 28
replace ind_issue = 0 if key == "uuid:07815cfd-fc9e-42e6-823e-83d93c2b9461" & hh_21_total_4 == 12
replace ind_issue = 0 if key == "uuid:f7b4c6d1-f700-43ec-b688-c5722030e939" & hh_21_total_4 == 10
replace ind_issue = 0 if key == "uuid:4997f527-1ec1-4a4b-8a9f-85356a6369d7" & hh_21_total_6 == 3
replace ind_issue = 0 if key == "uuid:a420540e-7ac1-4fdb-ae20-2072c04e743d" & hh_21_total_1 == 3
replace ind_issue = 0 if key == "uuid:0b0fb3f0-5253-417a-a40c-b4225652ad7f" & hh_21_total_1 == 25
replace ind_issue = 0 if key == "uuid:7e856dd9-4999-4581-8a10-a211bb7e63b4" & hh_21_total_1 == 18
replace ind_issue = 0 if key == "uuid:74eb9e02-c087-424c-b7a0-cb63be8a36c7" & hh_21_total_1 == 8
replace ind_issue = 0 if key == "uuid:d27907d8-f6aa-4b80-81cc-9a1006e1012e" & hh_21_total_12 == 14
replace ind_issue = 0 if key == "uuid:a420540e-7ac1-4fdb-ae20-2072c04e743d" & hh_21_total_19 == 53
replace ind_issue = 0 if key == "uuid:a420540e-7ac1-4fdb-ae20-2072c04e743d" & hh_21_total_3 == 15
replace ind_issue = 0 if key == "uuid:ac8a29b2-ae30-4212-9ae5-d826788cf727" & hh_21_total_3 == 8
replace ind_issue = 0 if key == "uuid:94d8e8c9-df2a-466b-b173-f7d1403ac905" & hh_21_total_4 == 10
replace ind_issue = 0 if key == "uuid:0b0fb3f0-5253-417a-a40c-b4225652ad7f" & hh_21_total_4 == 32
replace ind_issue = 0 if key == "uuid:0b0fb3f0-5253-417a-a40c-b4225652ad7f" & hh_21_total_5 == 31
replace ind_issue = 0 if key == "uuid:f72c4194-1658-4baa-9e40-7e6b0ea2b3a8" & hh_21_total_6 == 21
replace ind_issue = 0 if key == "uuid:a63d364d-8238-4c51-a32c-a0b5c9ec3e6a" & hh_21_total_6 == 50
replace ind_issue = 0 if key == "uuid:a58331c4-b5ce-40a8-af97-c1e0292d8ef1" & hh_21_total_6 == 3
replace ind_issue = 0 if key == "uuid:b9e97e2c-cb4b-4f65-8865-ff559d932464" & hh_21_total_7 == 52
replace ind_issue = 0 if key == "uuid:59712e0a-1ba5-483d-8601-552eb329e796" & hh_21_total_8 == 6
replace ind_issue = 0 if key == "uuid:3d62ede2-09be-4490-8ccf-918371d1b1b9" & hh_21_total_8 == 5
replace ind_issue = 0 if key == "uuid:94d8e8c9-df2a-466b-b173-f7d1403ac905" & hh_21_total_9 == 62
replace ind_issue = 0 if key == "uuid:e4d9ab46-b30f-4d93-a47b-9b0e1c367d58" & hh_21_total_9 == 3
replace ind_issue = 0 if key == "uuid:359accaa-e1f8-4d1c-9aff-706313f0ca4c" & hh_21_total_1 == 7
replace ind_issue = 0 if key == "uuid:c9c6c412-ce94-4805-96fb-3acb3e1c0732" & hh_21_total_2 == 3
replace ind_issue = 0 if key == "uuid:fa7f73fd-c387-457f-99aa-da844bb4e83e" & hh_21_total_2 == 7
replace ind_issue = 0 if key == "uuid:f45cf2eb-9dd7-44c0-b6d1-1b9176ed0dae" & hh_21_total_4 == 5
replace ind_issue = 0 if key == "uuid:d6b64852-9250-4d85-8208-6fb7b8945ff8" & hh_21_total_4 == 7
replace ind_issue = 0 if key == "uuid:1f8316b4-c849-40b4-8ced-4cb30d7d5944" & hh_21_total_6 == 11
replace ind_issue = 0 if key == "uuid:359accaa-e1f8-4d1c-9aff-706313f0ca4c" & hh_21_total_7 == 4
replace ind_issue = 0 if key == "uuid:3dd76816-ae15-4852-b0bb-9596df462e1a" & hh_21_total_8 == 4
replace ind_issue = 0 if key == "uuid:ac7acb5b-cc03-405a-b699-c7049bbb6f16" & hh_21_total_1 == 14
replace ind_issue = 0 if key == "uuid:8b5fa358-6317-4e65-a16f-0fce2d44c6b5" & hh_21_total_1 == 21
replace ind_issue = 0 if key == "uuid:ac7acb5b-cc03-405a-b699-c7049bbb6f16" & hh_21_total_3 == 14
replace ind_issue = 0 if key == "uuid:8b5fa358-6317-4e65-a16f-0fce2d44c6b5" & hh_21_total_3 == 14
replace ind_issue = 0 if key == "uuid:e6d61f8b-bae8-4a27-bda4-6422e002efe7" & hh_21_total_3 == 5
replace ind_issue = 0 if key == "uuid:14699177-2dd1-4010-8df4-7acc69d307da" & hh_21_total_9 == 6
replace ind_issue = 0 if key == "uuid:d7cf7d20-89ae-405c-af0f-c9f04d222f68" & hh_21_total_1 == 12
replace ind_issue = 0 if key == "uuid:17d10f64-73a3-47f9-b5cc-d3181be64f21" & hh_21_total_1 == 8
replace ind_issue = 0 if key == "uuid:c7c6ac20-be3f-47ba-b2b4-eb17e08123c4" & hh_21_total_11 == 8
replace ind_issue = 0 if key == "uuid:d7cf7d20-89ae-405c-af0f-c9f04d222f68" & hh_21_total_3 == 16
replace ind_issue = 0 if key == "uuid:924ae568-e479-4dc0-9311-dd77acb165c1" & hh_21_total_4 == 10
replace ind_issue = 0 if key == "uuid:ded54860-db67-4e1a-a05c-19603fb0ed65" & hh_21_total_7 == 10
replace ind_issue = 0 if key == "uuid:5bde4af2-d8dc-4fae-8884-fc042a5d12a6" & hh_21_total_1 == 6
replace ind_issue = 0 if key == "uuid:e1f57db1-c71f-4b6b-8e34-e79a83b811e1" & hh_21_total_1 == 2
replace ind_issue = 0 if key == "uuid:94643380-9b5b-4ec2-ac9c-a3fd30a51af7" & hh_21_total_1 == 2
replace ind_issue = 0 if key == "uuid:82b29ac5-2558-4aa3-a780-b48b45483422" & hh_21_total_1 == 5
replace ind_issue = 0 if key == "uuid:155e4011-7e23-4a13-9190-c8859bb3641f" & hh_21_total_10 == 7
replace ind_issue = 0 if key == "uuid:f05825dc-a539-40ff-8384-8edaef71070b" & hh_21_total_2 == 5
replace ind_issue = 0 if key == "uuid:1a323a88-f1d7-4a74-b448-7ce2d7858fa4" & hh_21_total_2 == 4
replace ind_issue = 0 if key == "uuid:3836b5eb-ccd2-4c6b-bd5f-bf42d09c166c" & hh_21_total_2 == 15
replace ind_issue = 0 if key == "uuid:82b29ac5-2558-4aa3-a780-b48b45483422" & hh_21_total_3 == 6
replace ind_issue = 0 if key == "uuid:3254047a-1f16-4015-a8fd-33c4a15e8787" & hh_21_total_3 == 6
replace ind_issue = 0 if key == "uuid:7d6f6d9d-c257-4195-8a67-0aecd4e1b233" & hh_21_total_3 == 5
replace ind_issue = 0 if key == "uuid:347b10a5-29e2-4221-9079-08b5d95c139b" & hh_21_total_3 == 2
replace ind_issue = 0 if key == "uuid:d7d885fe-9a4f-4a10-8991-80d5fd4dd3f9" & hh_21_total_4 == 5
replace ind_issue = 0 if key == "uuid:f05825dc-a539-40ff-8384-8edaef71070b" & hh_21_total_4 == 35
replace ind_issue = 0 if key == "uuid:3836b5eb-ccd2-4c6b-bd5f-bf42d09c166c" & hh_21_total_4 == 6
replace ind_issue = 0 if key == "uuid:3f50a371-1256-4562-a655-945198622f86" & hh_21_total_4 == 2
replace ind_issue = 0 if key == "uuid:82b29ac5-2558-4aa3-a780-b48b45483422" & hh_21_total_4 == 12
replace ind_issue = 0 if key == "uuid:d5f48d8a-650d-40bc-b6ad-a365623fda48" & hh_21_total_4 == 10
replace ind_issue = 0 if key == "uuid:72625c8e-580a-478f-9989-882ad5867012" & hh_21_total_5 == 6
replace ind_issue = 0 if key == "uuid:155e4011-7e23-4a13-9190-c8859bb3641f" & hh_21_total_5 == 3
replace ind_issue = 0 if key == "uuid:94643380-9b5b-4ec2-ac9c-a3fd30a51af7" & hh_21_total_5 == 5
replace ind_issue = 0 if key == "uuid:d5f48d8a-650d-40bc-b6ad-a365623fda48" & hh_21_total_6 == 10
replace ind_issue = 0 if key == "uuid:ab7d5d15-0083-4d38-8abb-bb1b924d1b88" & hh_21_total_6 == 7
replace ind_issue = 0 if key == "uuid:72625c8e-580a-478f-9989-882ad5867012" & hh_21_total_6 == 4
replace ind_issue = 0 if key == "uuid:347b10a5-29e2-4221-9079-08b5d95c139b" & hh_21_total_6 == 5
replace ind_issue = 0 if key == "uuid:742d4881-da1e-4e85-9270-0c5bd07d1b00" & hh_21_total_7 == 2
replace ind_issue = 0 if key == "uuid:94643380-9b5b-4ec2-ac9c-a3fd30a51af7" & hh_21_total_7 == 2
replace ind_issue = 0 if key == "uuid:1b5acef1-09c9-4be9-ad74-366a633b2c73" & hh_21_total_7 == 4
replace ind_issue = 0 if key == "uuid:3836b5eb-ccd2-4c6b-bd5f-bf42d09c166c" & hh_21_total_7 == 8
replace ind_issue = 0 if key == "uuid:f05825dc-a539-40ff-8384-8edaef71070b" & hh_21_total_7 == 5
replace ind_issue = 0 if key == "uuid:5af3703a-9fbb-417b-9462-88d93d4254f2" & hh_21_total_8 == 3
replace ind_issue = 0 if key == "uuid:155e4011-7e23-4a13-9190-c8859bb3641f" & hh_21_total_8 == 5
replace ind_issue = 0 if key == "uuid:ab7d5d15-0083-4d38-8abb-bb1b924d1b88" & hh_21_total_8 == 3
replace ind_issue = 0 if key == "uuid:7d9f8b44-84f1-4118-b829-ec224829dc78" & hh_21_total_9 == 5
replace ind_issue = 0 if key == "uuid:94197cc7-302a-4613-b051-35f3647de14f" & hh_21_total_2 == 12
replace ind_issue = 0 if key == "uuid:bb44cf98-9d46-4333-b702-8f56f6d685b7" & hh_21_total_4 == 4
replace ind_issue = 0 if key == "uuid:cb40e206-5485-4e94-8ea2-4fb5ab806bc0" & hh_21_total_5 == 5
replace ind_issue = 0 if key == "uuid:844ab214-bd8f-4cfd-b13e-38ce3bba59a8" & hh_21_total_1 == 7
replace ind_issue = 0 if key == "uuid:0243f237-580f-48db-81ac-af07d0ec3c7d" & hh_21_total_11 == 7
replace ind_issue = 0 if key == "uuid:e2eb2697-0ed5-4a5c-8049-b1ea036fbe9c" & hh_21_total_4 == 6
replace ind_issue = 0 if key == "uuid:74fd4109-e990-42e8-a69a-43a2c2411c7f" & hh_21_total_4 == 6
replace ind_issue = 0 if key == "uuid:b747834b-3cc5-4e16-a003-c746781d4c3b" & hh_21_total_5 == 7
replace ind_issue = 0 if key == "uuid:74fd4109-e990-42e8-a69a-43a2c2411c7f" & hh_21_total_5 == 6
replace ind_issue = 0 if key == "uuid:446cce08-7cc4-44c1-be46-e651f216e5bc" & hh_21_total_6 == 6
replace ind_issue = 0 if key == "uuid:63a429a2-c4af-4377-9060-8489190a5491" & hh_21_total_7 == 4
replace ind_issue = 0 if key == "uuid:b508a3ab-9afd-4b4d-ae57-9b3b9c7214de" & hh_21_total_7 == 14
replace ind_issue = 0 if key == "uuid:e2eb2697-0ed5-4a5c-8049-b1ea036fbe9c" & hh_21_total_7 == 6
replace ind_issue = 0 if key == "uuid:8f4cbc6a-8472-4738-b738-7057a87ab85e" & hh_21_total_8 == 3
replace ind_issue = 0 if key == "uuid:e2eb2697-0ed5-4a5c-8049-b1ea036fbe9c" & hh_21_total_8 == 5
replace ind_issue = 0 if key == "uuid:e2eb2697-0ed5-4a5c-8049-b1ea036fbe9c" & hh_21_total_9 == 5
replace ind_issue = 0 if key == "uuid:eb71f1ee-5f44-4a52-926b-7db730824f49" & hh_21_total_10 == 6
replace ind_issue = 0 if key == "uuid:6fd4bf23-18ad-4397-b6e5-51b08c474051" & hh_21_total_2 == 10
replace ind_issue = 0 if key == "uuid:6aed25d4-b44d-4a4a-95db-cb4659ba83f7" & hh_21_total_4 == 4
replace ind_issue = 0 if key == "uuid:c3b488c2-9c9d-45fe-a3fa-6576aa6fa1f3" & hh_21_total_7 == 3
replace ind_issue = 0 if key == "uuid:fd300527-e33a-4519-8ba2-1df30a653a0c" & hh_21_total_1 == 14
replace ind_issue = 0 if key == "uuid:f74852e0-f784-45df-9ba6-40933da3b8d1" & hh_21_total_1 == 32
replace ind_issue = 0 if key == "uuid:92bf8c6e-ed5e-45f9-a303-3edb224aa9a9" & hh_21_total_1 == 4
replace ind_issue = 0 if key == "uuid:33059fa7-c2ec-4757-925c-e9caca8b3365" & hh_21_total_1 == 13
replace ind_issue = 0 if key == "uuid:c336de53-c390-436d-8371-5e5bc87a526c" & hh_21_total_1 == 17
replace ind_issue = 0 if key == "uuid:76360573-efa2-4b0d-9979-a990ca4571a4" & hh_21_total_1 == 23
replace ind_issue = 0 if key == "uuid:e1cd6dc2-003a-44ab-8c0f-3dc63c59ba14" & hh_21_total_1 == 2
replace ind_issue = 0 if key == "uuid:68e479ee-1a91-4b2c-99d0-cfb335f8aeeb" & hh_21_total_1 == 19
replace ind_issue = 0 if key == "uuid:7f450507-9f4a-40a5-99e4-8b63c95b4d2c" & hh_21_total_10 == 8
replace ind_issue = 0 if key == "uuid:e59e2eae-b1ae-449a-8842-d4641331f136" & hh_21_total_10 == 18
replace ind_issue = 0 if key == "uuid:4a0fe362-32d1-4dad-ba8c-ca382d519c63" & hh_21_total_11 == 3
replace ind_issue = 0 if key == "uuid:92171a8f-7a48-4292-a5ef-6850b6c04333" & hh_21_total_13 == 8
replace ind_issue = 0 if key == "uuid:92171a8f-7a48-4292-a5ef-6850b6c04333" & hh_21_total_19 == 8
replace ind_issue = 0 if key == "uuid:9d9dda6a-deb5-4cce-bd4c-ed3f2bc00381" & hh_21_total_2 == 15
replace ind_issue = 0 if key == "uuid:b89a7ed1-e6ea-4835-8e6d-2e374b8d1cdb" & hh_21_total_2 == 23
replace ind_issue = 0 if key == "uuid:e59e2eae-b1ae-449a-8842-d4641331f136" & hh_21_total_2 == 9
replace ind_issue = 0 if key == "uuid:7df04366-985d-4f5e-895f-61ec47f30529" & hh_21_total_2 == 9
replace ind_issue = 0 if key == "uuid:1df09cfd-b5f7-4fa5-8227-199fa261ae20" & hh_21_total_2 == 20
replace ind_issue = 0 if key == "uuid:f5bfd38e-c47c-4d7f-aa1f-37602fef6c9c" & hh_21_total_2 == 7
replace ind_issue = 0 if key == "uuid:902f961e-7553-4463-81b7-39f9ad8f7903" & hh_21_total_3 == 43
replace ind_issue = 0 if key == "uuid:e59e2eae-b1ae-449a-8842-d4641331f136" & hh_21_total_3 == 15
replace ind_issue = 0 if key == "uuid:f5bfd38e-c47c-4d7f-aa1f-37602fef6c9c" & hh_21_total_3 == 7
replace ind_issue = 0 if key == "uuid:ea66090c-4853-434a-8501-93e90526a596" & hh_21_total_3 == 10
replace ind_issue = 0 if key == "uuid:5624be26-ca0a-4378-8cf8-c7d181e23ce3" & hh_21_total_3 == 8
replace ind_issue = 0 if key == "uuid:731b2b96-2cc9-4c40-ab3d-1c8eca615b1d" & hh_21_total_3 == 17
replace ind_issue = 0 if key == "uuid:7f450507-9f4a-40a5-99e4-8b63c95b4d2c" & hh_21_total_3 == 12
replace ind_issue = 0 if key == "uuid:a671b107-d7f9-4662-9727-5a5ee7218919" & hh_21_total_3 == 18
replace ind_issue = 0 if key == "uuid:731b2b96-2cc9-4c40-ab3d-1c8eca615b1d" & hh_21_total_4 == 24
replace ind_issue = 0 if key == "uuid:38e50014-cbb3-4ccf-a592-222277e3c778" & hh_21_total_4 == 10
replace ind_issue = 0 if key == "uuid:021408c0-3c5f-42ad-bf3c-4df9fc199963" & hh_21_total_4 == 23
replace ind_issue = 0 if key == "uuid:f74852e0-f784-45df-9ba6-40933da3b8d1" & hh_21_total_4 == 20
replace ind_issue = 0 if key == "uuid:c336de53-c390-436d-8371-5e5bc87a526c" & hh_21_total_4 == 33
replace ind_issue = 0 if key == "uuid:4f33e08d-f88b-4c66-9f8c-5c6ffcb99c7e" & hh_21_total_4 == 12
replace ind_issue = 0 if key == "uuid:35f6931b-c1e5-4ed4-ac86-d169b66b7963" & hh_21_total_4 == 5
replace ind_issue = 0 if key == "uuid:e692401a-2af4-4a0f-9e12-1d7bb0856037" & hh_21_total_4 == 12
replace ind_issue = 0 if key == "uuid:b89a7ed1-e6ea-4835-8e6d-2e374b8d1cdb" & hh_21_total_4 == 7
replace ind_issue = 0 if key == "uuid:76360573-efa2-4b0d-9979-a990ca4571a4" & hh_21_total_5 == 35
replace ind_issue = 0 if key == "uuid:0aa1bd0b-c8f4-493d-a32e-5256cc8a58d0" & hh_21_total_5 == 14
replace ind_issue = 0 if key == "uuid:38e50014-cbb3-4ccf-a592-222277e3c778" & hh_21_total_5 == 24
replace ind_issue = 0 if key == "uuid:a671b107-d7f9-4662-9727-5a5ee7218919" & hh_21_total_5 == 29
replace ind_issue = 0 if key == "uuid:c840f2ec-d0ec-4652-9e94-39ce87bad68a" & hh_21_total_5 == 8
replace ind_issue = 0 if key == "uuid:4c778d8f-97d4-47fa-af7d-7e3314c48feb" & hh_21_total_5 == 6
replace ind_issue = 0 if key == "uuid:0aa1bd0b-c8f4-493d-a32e-5256cc8a58d0" & hh_21_total_6 == 18
replace ind_issue = 0 if key == "uuid:27c99328-fe86-4b31-956f-6c9aaf3b1284" & hh_21_total_6 == 3
replace ind_issue = 0 if key == "uuid:38e50014-cbb3-4ccf-a592-222277e3c778" & hh_21_total_6 == 19
replace ind_issue = 0 if key == "uuid:c549c58d-ef59-4d7f-a241-ebe47316e790" & hh_21_total_6 == 5
replace ind_issue = 0 if key == "uuid:68e479ee-1a91-4b2c-99d0-cfb335f8aeeb" & hh_21_total_6 == 9
replace ind_issue = 0 if key == "uuid:731b2b96-2cc9-4c40-ab3d-1c8eca615b1d" & hh_21_total_7 == 13
replace ind_issue = 0 if key == "uuid:76360573-efa2-4b0d-9979-a990ca4571a4" & hh_21_total_7 == 14
replace ind_issue = 0 if key == "uuid:92171a8f-7a48-4292-a5ef-6850b6c04333" & hh_21_total_7 == 6
replace ind_issue = 0 if key == "uuid:8cb164e9-bedb-4168-b1fa-f5ce9354c2a9" & hh_21_total_7 == 15
replace ind_issue = 0 if key == "uuid:bbf5c02a-b6e2-4645-bae2-8854d894931f" & hh_21_total_7 == 6
replace ind_issue = 0 if key == "uuid:e59e2eae-b1ae-449a-8842-d4641331f136" & hh_21_total_7 == 5
replace ind_issue = 0 if key == "uuid:4a0fe362-32d1-4dad-ba8c-ca382d519c63" & hh_21_total_7 == 3
replace ind_issue = 0 if key == "uuid:4c778d8f-97d4-47fa-af7d-7e3314c48feb" & hh_21_total_7 == 6
replace ind_issue = 0 if key == "uuid:ea66090c-4853-434a-8501-93e90526a596" & hh_21_total_9 == 52
replace ind_issue = 0 if key == "uuid:b1fae32c-057b-45c3-a10b-5fbdf289d4d6" & hh_21_total_9 == 6
replace ind_issue = 0 if key == "uuid:72ed82ab-7a9a-4eb1-bff3-db27dcae2ad8" & hh_21_total_1 == 14
replace ind_issue = 0 if key == "uuid:1e25364f-6fd7-4898-9631-7343b0d1b0f7" & hh_21_total_1 == 14
replace ind_issue = 0 if key == "uuid:dbaf39d5-e977-4dad-a0fd-d3f8f978a2c5" & hh_21_total_1 == 6
replace ind_issue = 0 if key == "uuid:16671bba-7134-410e-adcc-d943d1515258" & hh_21_total_1 == 28
replace ind_issue = 0 if key == "uuid:ce5549e0-79b0-4bde-9e8b-37fab5eedf2f" & hh_21_total_1 == 21
replace ind_issue = 0 if key == "uuid:885049cc-1088-4324-82a2-6a3d1aa5c3bf" & hh_21_total_1 == 42
replace ind_issue = 0 if key == "uuid:37867bda-7341-492f-a065-8037d1e444de" & hh_21_total_1 == 28
replace ind_issue = 0 if key == "uuid:4a93facc-81f2-47bf-834f-ade9801ee7c8" & hh_21_total_1 == 14
replace ind_issue = 0 if key == "uuid:4a93facc-81f2-47bf-834f-ade9801ee7c8" & hh_21_total_10 == 14
replace ind_issue = 0 if key == "uuid:da41eaad-41fa-4adb-b7c6-7c521bc678cf" & hh_21_total_11 == 10
replace ind_issue = 0 if key == "uuid:20c6f12b-0474-449e-88cf-7e4bb8572ccf" & hh_21_total_2 == 28
replace ind_issue = 0 if key == "uuid:16671bba-7134-410e-adcc-d943d1515258" & hh_21_total_2 == 14
replace ind_issue = 0 if key == "uuid:5dacec94-0b4b-459d-bc8d-7ca6379119bc" & hh_21_total_2 == 35
replace ind_issue = 0 if key == "uuid:51bbc017-d8de-4e30-9a9b-3594922d7738" & hh_21_total_2 == 28
replace ind_issue = 0 if key == "uuid:7927b2e6-e46d-4be1-8163-7669e0733149" & hh_21_total_2 == 55
replace ind_issue = 0 if key == "uuid:7549994f-023a-4e2f-a015-225aaf53ff2b" & hh_21_total_2 == 12
replace ind_issue = 0 if key == "uuid:dbaf39d5-e977-4dad-a0fd-d3f8f978a2c5" & hh_21_total_2 == 73
replace ind_issue = 0 if key == "uuid:61144d37-6700-447a-b358-647e4312819f" & hh_21_total_2 == 7
replace ind_issue = 0 if key == "uuid:4894e36a-965b-440d-aa57-d70254caa566" & hh_21_total_2 == 22
replace ind_issue = 0 if key == "uuid:dfbffc80-1e52-496c-ba85-f1692acbd5f0" & hh_21_total_2 == 21
replace ind_issue = 0 if key == "uuid:37867bda-7341-492f-a065-8037d1e444de" & hh_21_total_2 == 28
replace ind_issue = 0 if key == "uuid:cb84f382-f029-467d-bb51-4ee455ca0c9d" & hh_21_total_2 == 21
replace ind_issue = 0 if key == "uuid:72ed82ab-7a9a-4eb1-bff3-db27dcae2ad8" & hh_21_total_2 == 28
replace ind_issue = 0 if key == "uuid:952f24db-030b-475b-a2cb-f383305e65e3" & hh_21_total_3 == 14
replace ind_issue = 0 if key == "uuid:4a93facc-81f2-47bf-834f-ade9801ee7c8" & hh_21_total_3 == 14
replace ind_issue = 0 if key == "uuid:7927b2e6-e46d-4be1-8163-7669e0733149" & hh_21_total_3 == 55
replace ind_issue = 0 if key == "uuid:51bbc017-d8de-4e30-9a9b-3594922d7738" & hh_21_total_3 == 23
replace ind_issue = 0 if key == "uuid:01639e53-ecd4-43fe-bf12-bd59d60e79e6" & hh_21_total_3 == 48
replace ind_issue = 0 if key == "uuid:72ed82ab-7a9a-4eb1-bff3-db27dcae2ad8" & hh_21_total_3 == 6
replace ind_issue = 0 if key == "uuid:885049cc-1088-4324-82a2-6a3d1aa5c3bf" & hh_21_total_3 == 56
replace ind_issue = 0 if key == "uuid:d9a96108-6ff6-4a01-b035-8c4edbc3d016" & hh_21_total_4 == 21
replace ind_issue = 0 if key == "uuid:4894e36a-965b-440d-aa57-d70254caa566" & hh_21_total_4 == 14
replace ind_issue = 0 if key == "uuid:cb84f382-f029-467d-bb51-4ee455ca0c9d" & hh_21_total_4 == 28
replace ind_issue = 0 if key == "uuid:58f97ff1-d328-4186-b783-6e4eb46e1683" & hh_21_total_4 == 8
replace ind_issue = 0 if key == "uuid:72ed82ab-7a9a-4eb1-bff3-db27dcae2ad8" & hh_21_total_4 == 21
replace ind_issue = 0 if key == "uuid:6995a33b-0e9c-458f-9e49-d08266c63a04" & hh_21_total_4 == 21
replace ind_issue = 0 if key == "uuid:16671bba-7134-410e-adcc-d943d1515258" & hh_21_total_4 == 16
replace ind_issue = 0 if key == "uuid:44e9ec51-4de3-4be7-985d-1aed9746258a" & hh_21_total_4 == 28
replace ind_issue = 0 if key == "uuid:952f24db-030b-475b-a2cb-f383305e65e3" & hh_21_total_5 == 21
replace ind_issue = 0 if key == "uuid:10cdabf2-f022-4539-8c2b-7eaa1bead1d1" & hh_21_total_5 == 42
replace ind_issue = 0 if key == "uuid:1e25364f-6fd7-4898-9631-7343b0d1b0f7" & hh_21_total_5 == 14
replace ind_issue = 0 if key == "uuid:4a93facc-81f2-47bf-834f-ade9801ee7c8" & hh_21_total_5 == 14
replace ind_issue = 0 if key == "uuid:e256772b-6441-4b1e-9274-0991789ff4e9" & hh_21_total_5 == 14
replace ind_issue = 0 if key == "uuid:dbaf39d5-e977-4dad-a0fd-d3f8f978a2c5" & hh_21_total_5 == 63
replace ind_issue = 0 if key == "uuid:72ed82ab-7a9a-4eb1-bff3-db27dcae2ad8" & hh_21_total_5 == 14
replace ind_issue = 0 if key == "uuid:16671bba-7134-410e-adcc-d943d1515258" & hh_21_total_6 == 8
replace ind_issue = 0 if key == "uuid:21a44c69-6d8a-4ded-b1b8-98280d8f04c1" & hh_21_total_6 == 18
replace ind_issue = 0 if key == "uuid:4894e36a-965b-440d-aa57-d70254caa566" & hh_21_total_6 == 14
replace ind_issue = 0 if key == "uuid:175f92a9-aded-464b-a5ef-684193f755d6" & hh_21_total_6 == 25
replace ind_issue = 0 if key == "uuid:22fd68b3-1f05-41ef-8b1e-3e4abd12196f" & hh_21_total_6 == 70
replace ind_issue = 0 if key == "uuid:51bbc017-d8de-4e30-9a9b-3594922d7738" & hh_21_total_6 == 28
replace ind_issue = 0 if key == "uuid:44e9ec51-4de3-4be7-985d-1aed9746258a" & hh_21_total_6 == 14
replace ind_issue = 0 if key == "uuid:cb84f382-f029-467d-bb51-4ee455ca0c9d" & hh_21_total_7 == 35
replace ind_issue = 0 if key == "uuid:4894e36a-965b-440d-aa57-d70254caa566" & hh_21_total_7 == 14
replace ind_issue = 0 if key == "uuid:da41eaad-41fa-4adb-b7c6-7c521bc678cf" & hh_21_total_8 == 26
replace ind_issue = 0 if key == "uuid:2da18445-e0f4-4b04-a536-bfdaaf05e974" & hh_21_total_8 == 21
replace ind_issue = 0 if key == "uuid:da41eaad-41fa-4adb-b7c6-7c521bc678cf" & hh_21_total_9 == 33
replace ind_issue = 0 if key == "uuid:1a3c002d-843a-4466-8c9d-e1ce3192481f" & hh_21_total_1 == 11
replace ind_issue = 0 if key == "uuid:677eb96e-7e1d-4cce-93d3-f743b6c3290c" & hh_21_total_1 == 28
replace ind_issue = 0 if key == "uuid:30adca5f-189e-48eb-9f04-aea83e6e68ac" & hh_21_total_1 == 13
replace ind_issue = 0 if key == "uuid:91d4c4b4-ac34-42e9-9e3d-c3491b708ca0" & hh_21_total_1 == 22
replace ind_issue = 0 if key == "uuid:215540ae-d768-4832-817a-9fdcc1755eb2" & hh_21_total_1 == 2
replace ind_issue = 0 if key == "uuid:7663f63b-a20a-4f80-82df-873214c2f9c4" & hh_21_total_1 == 4
replace ind_issue = 0 if key == "uuid:31c89eaf-8d8c-4319-a80a-e476001b5a9e" & hh_21_total_1 == 21
replace ind_issue = 0 if key == "uuid:4219536c-3d1b-4d77-a065-f63913f70d0e" & hh_21_total_1 == 20
replace ind_issue = 0 if key == "uuid:9211237f-7b08-4c13-b007-2bc27f4fe27b" & hh_21_total_1 == 10
replace ind_issue = 0 if key == "uuid:869babf6-be9d-49ad-a3e6-b949d3719a28" & hh_21_total_1 == 13
replace ind_issue = 0 if key == "uuid:7857f5dd-b97f-42c2-9506-5fa8bf7847cf" & hh_21_total_10 == 22
replace ind_issue = 0 if key == "uuid:31c89eaf-8d8c-4319-a80a-e476001b5a9e" & hh_21_total_10 == 28
replace ind_issue = 0 if key == "uuid:83dde2f0-83a6-4399-a31b-7067f8553efc" & hh_21_total_10 == 63
replace ind_issue = 0 if key == "uuid:f7c1d3b1-0f51-495c-9ed5-7fd642518c73" & hh_21_total_11 == 9
replace ind_issue = 0 if key == "uuid:e73c95dc-e245-49a9-abb6-1f9f95bc5fb1" & hh_21_total_11 == 14
replace ind_issue = 0 if key == "uuid:f7c1d3b1-0f51-495c-9ed5-7fd642518c73" & hh_21_total_12 == 13
replace ind_issue = 0 if key == "uuid:e73c95dc-e245-49a9-abb6-1f9f95bc5fb1" & hh_21_total_12 == 28
replace ind_issue = 0 if key == "uuid:f7c1d3b1-0f51-495c-9ed5-7fd642518c73" & hh_21_total_16 == 8
replace ind_issue = 0 if key == "uuid:001728aa-dfd3-4b19-88d9-daa7c05791c6" & hh_21_total_2 == 3
replace ind_issue = 0 if key == "uuid:91d4c4b4-ac34-42e9-9e3d-c3491b708ca0" & hh_21_total_2 == 69
replace ind_issue = 0 if key == "uuid:9a2701e9-2f77-43c6-948a-00c892e2739f" & hh_21_total_2 == 61
replace ind_issue = 0 if key == "uuid:e73c95dc-e245-49a9-abb6-1f9f95bc5fb1" & hh_21_total_2 == 28
replace ind_issue = 0 if key == "uuid:31c89eaf-8d8c-4319-a80a-e476001b5a9e" & hh_21_total_2 == 40
replace ind_issue = 0 if key == "uuid:28908175-7036-4f13-8443-f8d32671115a" & hh_21_total_2 == 48
replace ind_issue = 0 if key == "uuid:c2de282c-8658-4964-9675-354e51d41670" & hh_21_total_2 == 14
replace ind_issue = 0 if key == "uuid:757230ee-0ed7-43a2-ab87-de28c4339fd7" & hh_21_total_2 == 9
replace ind_issue = 0 if key == "uuid:9211237f-7b08-4c13-b007-2bc27f4fe27b" & hh_21_total_2 == 14
replace ind_issue = 0 if key == "uuid:f46febb7-4f27-4491-8bcb-e26865df976b" & hh_21_total_3 == 21
replace ind_issue = 0 if key == "uuid:31c89eaf-8d8c-4319-a80a-e476001b5a9e" & hh_21_total_3 == 29
replace ind_issue = 0 if key == "uuid:95d5efa7-920e-4c24-a832-47290c8adf86" & hh_21_total_3 == 5
replace ind_issue = 0 if key == "uuid:869babf6-be9d-49ad-a3e6-b949d3719a28" & hh_21_total_3 == 8
replace ind_issue = 0 if key == "uuid:7857f5dd-b97f-42c2-9506-5fa8bf7847cf" & hh_21_total_3 == 18
replace ind_issue = 0 if key == "uuid:61ae58e8-67ed-407f-94e6-c83fe4454247" & hh_21_total_3 == 61
replace ind_issue = 0 if key == "uuid:9a2701e9-2f77-43c6-948a-00c892e2739f" & hh_21_total_3 == 8
replace ind_issue = 0 if key == "uuid:9a2701e9-2f77-43c6-948a-00c892e2739f" & hh_21_total_4 == 10
replace ind_issue = 0 if key == "uuid:9211237f-7b08-4c13-b007-2bc27f4fe27b" & hh_21_total_4 == 10
replace ind_issue = 0 if key == "uuid:3adf763f-622e-4cf3-9e2e-cb5a9909deb2" & hh_21_total_4 == 14
replace ind_issue = 0 if key == "uuid:372c5f3a-79bf-45ce-a55d-6f9b02144b35" & hh_21_total_4 == 7
replace ind_issue = 0 if key == "uuid:869babf6-be9d-49ad-a3e6-b949d3719a28" & hh_21_total_4 == 3
replace ind_issue = 0 if key == "uuid:53fe3ce0-e78b-4d9e-b72e-9f0f0563cd82" & hh_21_total_4 == 24
replace ind_issue = 0 if key == "uuid:31c89eaf-8d8c-4319-a80a-e476001b5a9e" & hh_21_total_5 == 9
replace ind_issue = 0 if key == "uuid:001728aa-dfd3-4b19-88d9-daa7c05791c6" & hh_21_total_5 == 3
replace ind_issue = 0 if key == "uuid:f7c1d3b1-0f51-495c-9ed5-7fd642518c73" & hh_21_total_5 == 18
replace ind_issue = 0 if key == "uuid:9a2701e9-2f77-43c6-948a-00c892e2739f" & hh_21_total_5 == 52
replace ind_issue = 0 if key == "uuid:af2c741b-183a-419c-aac4-334755418d88" & hh_21_total_5 == 28
replace ind_issue = 0 if key == "uuid:887b6285-2eca-449b-885e-3e8a3e9733ac" & hh_21_total_5 == 10
replace ind_issue = 0 if key == "uuid:e73c95dc-e245-49a9-abb6-1f9f95bc5fb1" & hh_21_total_5 == 8
replace ind_issue = 0 if key == "uuid:2ec47a04-9451-4eae-863a-709abcb0f494" & hh_21_total_6 == 11
replace ind_issue = 0 if key == "uuid:95d5efa7-920e-4c24-a832-47290c8adf86" & hh_21_total_6 == 13
replace ind_issue = 0 if key == "uuid:f46febb7-4f27-4491-8bcb-e26865df976b" & hh_21_total_6 == 12
replace ind_issue = 0 if key == "uuid:3adf763f-622e-4cf3-9e2e-cb5a9909deb2" & hh_21_total_6 == 9
replace ind_issue = 0 if key == "uuid:9211237f-7b08-4c13-b007-2bc27f4fe27b" & hh_21_total_6 == 9
replace ind_issue = 0 if key == "uuid:28908175-7036-4f13-8443-f8d32671115a" & hh_21_total_6 == 13
replace ind_issue = 0 if key == "uuid:e73c95dc-e245-49a9-abb6-1f9f95bc5fb1" & hh_21_total_6 == 36
replace ind_issue = 0 if key == "uuid:91d4c4b4-ac34-42e9-9e3d-c3491b708ca0" & hh_21_total_6 == 49
replace ind_issue = 0 if key == "uuid:757230ee-0ed7-43a2-ab87-de28c4339fd7" & hh_21_total_6 == 10
replace ind_issue = 0 if key == "uuid:70dadb25-9ae1-4772-b406-419c7d134f96" & hh_21_total_6 == 27
replace ind_issue = 0 if key == "uuid:61ae58e8-67ed-407f-94e6-c83fe4454247" & hh_21_total_6 == 18
replace ind_issue = 0 if key == "uuid:dce059c7-c3d8-4f48-9e71-2e6e6ced417b" & hh_21_total_6 == 4
replace ind_issue = 0 if key == "uuid:7857f5dd-b97f-42c2-9506-5fa8bf7847cf" & hh_21_total_7 == 36
replace ind_issue = 0 if key == "uuid:65cbfec8-d9d7-4cda-9341-546edf1ffc8b" & hh_21_total_7 == 15
replace ind_issue = 0 if key == "uuid:31c89eaf-8d8c-4319-a80a-e476001b5a9e" & hh_21_total_7 == 13
replace ind_issue = 0 if key == "uuid:e73c95dc-e245-49a9-abb6-1f9f95bc5fb1" & hh_21_total_7 == 77
replace ind_issue = 0 if key == "uuid:e8949caf-47ee-4e5e-8b89-3eced60feb3d" & hh_21_total_7 == 3
replace ind_issue = 0 if key == "uuid:95d5efa7-920e-4c24-a832-47290c8adf86" & hh_21_total_7 == 9
replace ind_issue = 0 if key == "uuid:9a2701e9-2f77-43c6-948a-00c892e2739f" & hh_21_total_7 == 24
replace ind_issue = 0 if key == "uuid:677eb96e-7e1d-4cce-93d3-f743b6c3290c" & hh_21_total_7 == 30
replace ind_issue = 0 if key == "uuid:f46febb7-4f27-4491-8bcb-e26865df976b" & hh_21_total_7 == 22
replace ind_issue = 0 if key == "uuid:29afbbec-6664-48db-9cc4-024245c48be8" & hh_21_total_7 == 17
replace ind_issue = 0 if key == "uuid:a0e2eb23-b126-46c1-a2e9-5f81cfc2e9be" & hh_21_total_8 == 15
replace ind_issue = 0 if key == "uuid:7857f5dd-b97f-42c2-9506-5fa8bf7847cf" & hh_21_total_8 == 28
replace ind_issue = 0 if key == "uuid:887b6285-2eca-449b-885e-3e8a3e9733ac" & hh_21_total_8 == 20
replace ind_issue = 0 if key == "uuid:9211237f-7b08-4c13-b007-2bc27f4fe27b" & hh_21_total_8 == 7
replace ind_issue = 0 if key == "uuid:e73c95dc-e245-49a9-abb6-1f9f95bc5fb1" & hh_21_total_8 == 14
replace ind_issue = 0 if key == "uuid:9a2701e9-2f77-43c6-948a-00c892e2739f" & hh_21_total_8 == 16
replace ind_issue = 0 if key == "uuid:887b6285-2eca-449b-885e-3e8a3e9733ac" & hh_21_total_9 == 21
replace ind_issue = 0 if key == "uuid:e73c95dc-e245-49a9-abb6-1f9f95bc5fb1" & hh_21_total_9 == 19
replace ind_issue = 0 if key == "uuid:7857f5dd-b97f-42c2-9506-5fa8bf7847cf" & hh_21_total_9 == 28
replace ind_issue = 0 if key == "uuid:9211237f-7b08-4c13-b007-2bc27f4fe27b" & hh_21_total_9 == 10
replace ind_issue = 0 if key == "uuid:86eb5846-fbde-44a1-b04c-7dab574f678b" & hh_21_total_1 == 5
replace ind_issue = 0 if key == "uuid:c07e60ea-2961-45fb-b5ef-06d4a42f3112" & hh_21_total_1 == 3
replace ind_issue = 0 if key == "uuid:a389351c-405b-4fcf-bc2d-4f9b647cd821" & hh_21_total_1 == 4
replace ind_issue = 0 if key == "uuid:1cf5e8e5-012a-4791-a399-071c5984af16" & hh_21_total_10 == 7
replace ind_issue = 0 if key == "uuid:28e5893e-1205-4647-b375-2ab2e07290f8" & hh_21_total_11 == 8
replace ind_issue = 0 if key == "uuid:86eb5846-fbde-44a1-b04c-7dab574f678b" & hh_21_total_2 == 2
replace ind_issue = 0 if key == "uuid:9395c227-458d-4a0c-a7ff-11cb8e93046b" & hh_21_total_2 == 24
replace ind_issue = 0 if key == "uuid:fc088a43-edd6-4622-af6c-63532af6f8d7" & hh_21_total_3 == 6
replace ind_issue = 0 if key == "uuid:66c36843-1e4c-4576-9c41-c73386bee59b" & hh_21_total_3 == 4
replace ind_issue = 0 if key == "uuid:ad62df08-a2f4-412c-9a12-33d751c33145" & hh_21_total_4 == 8
replace ind_issue = 0 if key == "uuid:a389351c-405b-4fcf-bc2d-4f9b647cd821" & hh_21_total_4 == 3
replace ind_issue = 0 if key == "uuid:1cf5e8e5-012a-4791-a399-071c5984af16" & hh_21_total_4 == 7
replace ind_issue = 0 if key == "uuid:883f0ef3-0cc3-4683-a943-c3ffce7e8be4" & hh_21_total_6 == 21
replace ind_issue = 0 if key == "uuid:28e5893e-1205-4647-b375-2ab2e07290f8" & hh_21_total_7 == 14
replace ind_issue = 0 if key == "uuid:28e5893e-1205-4647-b375-2ab2e07290f8" & hh_21_total_9 == 9
replace ind_issue = 0 if key == "uuid:a9b198b5-e8e9-457d-9967-1ac777669d76" & hh_21_total_1 == 42
replace ind_issue = 0 if key == "uuid:1e699d0e-8fd7-45b6-9918-675b0fa7ec72" & hh_21_total_1 == 10
replace ind_issue = 0 if key == "uuid:b4135843-09e3-44e8-b649-7f6dbd35f542" & hh_21_total_10 == 6
replace ind_issue = 0 if key == "uuid:f2320249-e402-4c29-aea1-6c2dab838a8b" & hh_21_total_11 == 4
replace ind_issue = 0 if key == "uuid:8befef83-7f84-46ca-87f6-742b686956e6" & hh_21_total_2 == 14
replace ind_issue = 0 if key == "uuid:747bb817-d058-45b2-8f6d-e714a957afe6" & hh_21_total_2 == 12
replace ind_issue = 0 if key == "uuid:43b22eb4-baf0-4a10-ad3f-06206f134da1" & hh_21_total_2 == 4
replace ind_issue = 0 if key == "uuid:90d1e1e8-e397-433d-9199-1031cac8b8b2" & hh_21_total_3 == 9
replace ind_issue = 0 if key == "uuid:f2320249-e402-4c29-aea1-6c2dab838a8b" & hh_21_total_9 == 5
replace ind_issue = 0 if key == "uuid:5997c696-23e5-4aff-8dcc-4c0351688c8a" & hh_21_total_10 == 10
replace ind_issue = 0 if key == "uuid:648cabd0-d8bb-4edd-b54d-79f43e1898f6" & hh_21_total_13 == 7
replace ind_issue = 0 if key == "uuid:b9db8503-f920-47d7-8c51-d6479521ef3b" & hh_21_total_16 == 8
replace ind_issue = 0 if key == "uuid:f953cc65-f449-4a67-bab4-853b16aabad1" & hh_21_total_2 == 7
replace ind_issue = 0 if key == "uuid:79cf1220-8069-4576-9ce5-5bafd31008a2" & hh_21_total_3 == 5
replace ind_issue = 0 if key == "uuid:648cabd0-d8bb-4edd-b54d-79f43e1898f6" & hh_21_total_4 == 14
replace ind_issue = 0 if key == "uuid:322ec7b2-ba87-45b9-812d-dbfdaa8e84b9" & hh_21_total_6 == 7
replace ind_issue = 0 if key == "uuid:834bc878-e406-4f6e-88bc-c90a37031753" & hh_21_total_7 == 4
replace ind_issue = 0 if key == "uuid:008de754-4ff1-43e5-ae4d-21d1760039e2" & hh_21_total_9 == 3
replace ind_issue = 0 if key == "uuid:1a6dbc16-0aa9-4f14-8d83-03032f5156b9" & hh_21_total_1 == 12
replace ind_issue = 0 if key == "uuid:4cfdebc5-579b-42d0-b794-b15ca3d76d05" & hh_21_total_2 == 10
replace ind_issue = 0 if key == "uuid:afc485f1-70e0-4936-8c2c-66328f28ee3d" & hh_21_total_3 == 3
replace ind_issue = 0 if key == "uuid:8a5eda95-e722-4569-9fcc-33134c4bae2a" & hh_21_total_6 == 14
replace ind_issue = 0 if key == "uuid:e08a2cc4-c24a-4e63-801c-5ab205695c7b" & hh_21_total_6 == 4
replace ind_issue = 0 if key == "uuid:927795d3-0966-4cc6-9bd2-0ceee0f8bbe8" & hh_21_total_9 == 5
replace ind_issue = 0 if key == "uuid:a177145f-c36f-42f1-9595-bb4e759b7923" & hh_21_total_4 == 3
replace ind_issue = 0 if key == "uuid:44f20f67-c22c-4c86-86d2-0b468d0b47cd" & hh_21_total_6 == 3
replace ind_issue = 0 if key == "uuid:a0188f55-5d08-45c9-b274-70b5ba016033" & hh_21_total_4 == 4
*/

import delimited "$data\DISES_Enquête_ménage_midline_VF_WIDE_5Mar2025.csv", clear varnames(1) bindquote(strict)

**** CORRECTIONS 2/24/2025 PART 1
replace o_culture_05 = 500 if key == "uuid:c95998af-5ec9-4610-bf71-4620da7a54e4"
replace legumineuses_05_3 = 300 if key == "uuid:d428eb46-1143-4aa2-a6bc-dc7de948d30e"
replace legumineuses_05_3 = 300 if key == "uuid:9a0c6435-e2cc-41f6-a474-8150f73a1761"
replace legumineuses_05_3 = 300 if key == "uuid:93850388-81f9-49ac-a75c-64fadc48d46b"
replace legumineuses_05_3 = 300 if key == "uuid:bd1911e9-4cde-45a5-8f06-cea7ef72c905"
replace legumineuses_05_3 = 300 if key == "uuid:b42287e5-8e31-4aac-8dc1-2e561d2513e6"
replace legumineuses_05_3 = 300 if key == "uuid:ab7badc9-6f3b-4d27-8431-ae693dcf39d5"
replace legumineuses_05_3 = 300 if key == "uuid:8320c233-c8cb-4feb-b803-9ba786d6a34d"
replace legumineuses_05_3 = 300 if key == "uuid:ae86ed43-5ec0-4f1c-904a-e5609618f94f"
replace legumineuses_05_3 = 300 if key == "uuid:667efd5f-8ca5-4590-9186-f6d5a55eb42e"
replace legumineuses_05_3 = 300 if key == "uuid:7e459848-09f8-4b84-a8c8-08c5e708cf5d"
replace legumineuses_05_3 = 300 if key == "uuid:6fc34a13-7455-46b5-9d1a-5bafa2e11b9e"
replace legumineuses_05_3 = 300 if key == "uuid:a9c38dbd-844b-4ae2-9ef9-c817fdf5317e"
replace legumineuses_05_3 = 300 if key == "uuid:8be12456-9c4d-4e61-917b-2f94584d4796"
replace legumineuses_05_3 = 300 if key == "uuid:d9d4577c-6561-4c34-8803-5410ce71a614"
replace legumineuses_05_3 = 300 if key == "uuid:98a31235-4316-4246-b7f6-8ce887c860fb"
replace legumineuses_05_3 = 300 if key == "uuid:ba1a5af8-a3e4-4da5-af4f-a0fa9ced15e2"
replace legumineuses_05_3 = 300 if key == "uuid:d7add78b-5c6b-4f09-a15b-ee9ff0de69e8"
replace legumineuses_05_3 = 300 if key == "uuid:ee681614-42fc-42c6-901b-f6d8b82cd075"
replace legumineuses_05_3 = 300 if key == "uuid:cf485001-5744-4b2c-a0d8-95dbe52f7941"
replace legumineuses_05_3 = 300 if key == "uuid:13ad0640-e4af-4a3e-804a-c104583c0cfc"
replace legumineuses_05_3 = 300 if key == "uuid:5e203451-1121-4391-83f9-590148136101"
replace legumineuses_05_3 = 300 if key == "uuid:4700fee2-2d6f-46a5-810c-5f3769e9fb4b"
replace legumineuses_05_3 = 300 if key == "uuid:217ff2fe-c5df-426e-aa98-06301425f314"
replace legumineuses_05_3 = 300 if key == "uuid:1470f5f0-104f-4394-8e1a-257b569a556b"
replace legumineuses_05_3 = 300 if key == "uuid:fb82b7c9-c885-48a7-97fe-db2940d0b6a4"
replace legumineuses_05_1 = 300 if key == "uuid:9da62ab2-6426-4bbe-8665-003c0a00080f"
replace legumineuses_05_1 = 300 if key == "uuid:64030e2d-2504-47b4-874f-d8b9206b9b4b"
replace legumineuses_05_1 = 300 if key == "uuid:9a0c6435-e2cc-41f6-a474-8150f73a1761"
replace legumineuses_05_1 = 300 if key == "uuid:519e4ad4-b3cf-4d4b-8f34-bf5862b692a2"
replace legumineuses_05_1 = 300 if key == "uuid:5ca45d67-d0d0-4684-8358-704eb654f40e"
replace legumineuses_05_1 = 300 if key == "uuid:22a38dae-c26f-4f93-ada7-e4904a6bcea5"
replace legumineuses_05_1 = 300 if key == "uuid:4887e397-f600-4e7f-93cb-6c20c8aeaf2a"
replace legumineuses_05_1 = 300 if key == "uuid:ec2ca5e2-b1a9-4f00-84f4-b176703d669d"
replace legumineuses_05_1 = 300 if key == "uuid:610ca467-4669-42cf-83bd-036cfcbef797"
replace legumes_05_3 = 600 if key == "uuid:8320c233-c8cb-4feb-b803-9ba786d6a34d"
replace legumes_05_3 = 600 if key == "uuid:8be12456-9c4d-4e61-917b-2f94584d4796"
replace legumes_05_3 = 600 if key == "uuid:d9d4577c-6561-4c34-8803-5410ce71a614"
replace legumes_05_3 = 600 if key == "uuid:98a31235-4316-4246-b7f6-8ce887c860fb"
replace legumes_05_3 = 600 if key == "uuid:ee681614-42fc-42c6-901b-f6d8b82cd075"
replace legumes_05_3 = 600 if key == "uuid:cf485001-5744-4b2c-a0d8-95dbe52f7941"
replace legumes_05_3 = 600 if key == "uuid:217ff2fe-c5df-426e-aa98-06301425f314"
replace legumes_05_3 = 600 if key == "uuid:1470f5f0-104f-4394-8e1a-257b569a556b"
replace legumes_05_3 = 600 if key == "uuid:fb82b7c9-c885-48a7-97fe-db2940d0b6a4"
replace legumes_05_1 = 600 if key == "uuid:4887e397-f600-4e7f-93cb-6c20c8aeaf2a"
replace legumes_04_3 = 600 if key == "uuid:93850388-81f9-49ac-a75c-64fadc48d46b"
replace legumes_04_3 = 300 if key == "uuid:98a31235-4316-4246-b7f6-8ce887c860fb"
replace legumes_04_1 = 250 if key == "uuid:ec2ca5e2-b1a9-4f00-84f4-b176703d669d"
replace legumes_02_3 = 600 if key == "uuid:667efd5f-8ca5-4590-9186-f6d5a55eb42e"
replace legumes_02_3 = 300 if key == "uuid:7e459848-09f8-4b84-a8c8-08c5e708cf5d"
replace legumes_02_1 = 250 if key == "uuid:64030e2d-2504-47b4-874f-d8b9206b9b4b"
replace legumes_01_3 = 600 if key == "uuid:6fc34a13-7455-46b5-9d1a-5bafa2e11b9e"
replace legumes_01_3 = 600 if key == "uuid:a9c38dbd-844b-4ae2-9ef9-c817fdf5317e"
replace hh_education_level_1 = 4 if key == "uuid:22a38dae-c26f-4f93-ada7-e4904a6bcea5"
replace hh_41_5 = 6 if key == "uuid:bd1911e9-4cde-45a5-8f06-cea7ef72c905"
replace hh_41_5 = 6 if key == "uuid:d7add78b-5c6b-4f09-a15b-ee9ff0de69e8"
replace hh_41_4 = 6 if key == "uuid:98a31235-4316-4246-b7f6-8ce887c860fb"
replace hh_41_12 = 6 if key == "uuid:93850388-81f9-49ac-a75c-64fadc48d46b"
replace hh_12_o_5 = "1" if key == "uuid:ff25ec18-30f1-4aad-8493-f1dfd053d3dd"
replace farines_05_6 = 250 if key == "uuid:d3125773-6ecb-4ef8-ab72-c3789d68a800"
replace farines_04_1 = 250 if key == "uuid:f4dde6af-a6a8-42d1-8080-ca2a7c68e1b5"
replace farines_02_1 = 250 if key == "uuid:6213c19b-f969-425e-8066-f6eee952d92b"
replace correct_hh = 1 if key == "uuid:fb82b7c9-c885-48a7-97fe-db2940d0b6a4"
replace cereals_05_6 = 400 if key == "uuid:18766dcc-4119-4813-9062-0087836e1ed6"
replace cereals_05_6 = 400 if key == "uuid:2c43c97e-4854-45f3-acb7-49a56e4a5276"
replace cereals_05_1 = 400 if key == "uuid:415a7706-613c-4cc2-bcfc-f701ba22087d"
replace cereals_05_1 = 400 if key == "uuid:ed4a3ab3-eb94-46fa-8ca7-d4305cf8e36e"
replace cereals_05_1 = 400 if key == "uuid:d55a8454-7691-4b6d-bc0e-86712a701bc3"
replace cereals_05_1 = 400 if key == "uuid:dddef0a3-c29b-48e5-aa54-a90e22535274"
replace cereals_05_1 = 400 if key == "uuid:219ed5fd-0927-4d45-a276-a34304d603a1"
replace cereals_05_1 = 400 if key == "uuid:1738d925-4f91-4a7b-9a4a-db37b227b413"
replace cereals_05_1 = 400 if key == "uuid:e897f567-966c-4d53-b001-40028f448a1b"
replace cereals_05_1 = 400 if key == "uuid:54cf3fe4-e1ce-42cb-9d5e-145583555e00"
replace cereals_05_1 = 400 if key == "uuid:489ebcc5-b05a-4197-882a-683184c9bbcf"
replace cereals_05_1 = 400 if key == "uuid:031ccc48-bdb7-4697-85e9-12d7713001d9"
replace cereals_05_1 = 400 if key == "uuid:d3de785c-2ad1-45a0-a8c0-5e41e53483da"
replace cereals_05_1 = 400 if key == "uuid:cbcda759-6489-4a39-a76a-a93e0b05546c"
replace cereals_05_1 = 400 if key == "uuid:2c43c97e-4854-45f3-acb7-49a56e4a5276"
replace cereals_05_1 = 400 if key == "uuid:c95998af-5ec9-4610-bf71-4620da7a54e4"
replace cereals_04_1 = 400 if key == "uuid:ed4a3ab3-eb94-46fa-8ca7-d4305cf8e36e"
replace cereals_03_1 = 400 if key == "uuid:610ca467-4669-42cf-83bd-036cfcbef797"
replace cereals_02_1 = 62400 if key == "uuid:8320c233-c8cb-4feb-b803-9ba786d6a34d"
replace agri_income_45_3 = -9 if key == "uuid:9b78b42a-a3ec-49d3-a987-30b77f3872d0"
replace agri_income_33 = -9 if key == "uuid:ed4a3ab3-eb94-46fa-8ca7-d4305cf8e36e"
replace agri_income_33 = -9 if key == "uuid:6f48b23e-f222-48db-b73c-6bedf67a9889"
replace agri_income_33 = -9 if key == "uuid:d55a8454-7691-4b6d-bc0e-86712a701bc3"
replace agri_income_33 = -9 if key == "uuid:ae86ed43-5ec0-4f1c-904a-e5609618f94f"
replace agri_income_33 = -9 if key == "uuid:8c6736ef-01bd-4997-b8e7-02419b77bbb4"
replace agri_income_33 = -9 if key == "uuid:6fc34a13-7455-46b5-9d1a-5bafa2e11b9e"
replace agri_income_33 = -9 if key == "uuid:d252199f-1a7f-4ae2-8920-97ffe447aefb"
replace agri_income_33 = -9 if key == "uuid:cbcda759-6489-4a39-a76a-a93e0b05546c"
replace agri_income_33 = -9 if key == "uuid:dbcf5c48-d38a-4900-934d-1589c334478b"
replace agri_income_33 = -9 if key == "uuid:c7ecc3c7-f961-4f01-a59e-519ce6d7b325"
replace agri_income_33 = -9 if key == "uuid:2c43c97e-4854-45f3-acb7-49a56e4a5276"
replace agri_income_23_o = -9 if key == "uuid:ed4a3ab3-eb94-46fa-8ca7-d4305cf8e36e"
replace agri_income_23_o = -9 if key == "uuid:88a033cc-ae5d-4bd6-860b-3f14ff81a0f0"
replace agri_income_23_o = -9 if key == "uuid:8c6736ef-01bd-4997-b8e7-02419b77bbb4"
replace agri_income_23_o = -9 if key == "uuid:2086c8e7-cfb1-472b-ad6d-f21b87b90881"
replace agri_income_23_o = -9 if key == "uuid:8be12456-9c4d-4e61-917b-2f94584d4796"
replace agri_income_23_o = -9 if key == "uuid:d3de785c-2ad1-45a0-a8c0-5e41e53483da"
replace agri_income_23_o = -9 if key == "uuid:dbcf5c48-d38a-4900-934d-1589c334478b"
replace agri_income_23_1 = -9 if key == "uuid:88a033cc-ae5d-4bd6-860b-3f14ff81a0f0"
replace agri_income_23_1 = -9 if key == "uuid:8c6736ef-01bd-4997-b8e7-02419b77bbb4"
replace agri_income_23_1 = -9 if key == "uuid:63d08059-817d-45ae-bac7-ccdf05eb4c6a"
replace agri_income_08_2 = 1 if key == "uuid:17b395b7-605e-4685-a889-06f860cef4d8"
replace agri_6_40_a_code_3 = 1 if key == "uuid:9a0c6435-e2cc-41f6-a474-8150f73a1761"
replace agri_6_40_a_code_1 = 1 if key == "uuid:88a033cc-ae5d-4bd6-860b-3f14ff81a0f0"
replace agri_6_39_a_code_2 = 1 if key == "uuid:c7ecc3c7-f961-4f01-a59e-519ce6d7b325"
replace agri_6_39_a_2 = 0 if key == "uuid:ec2ca5e2-b1a9-4f00-84f4-b176703d669d"
replace agri_6_39_a_2 = 0 if key == "uuid:c7ecc3c7-f961-4f01-a59e-519ce6d7b325"
replace agri_6_38_a_code_1 = 1 if key == "uuid:15a55cfa-3d02-4c69-9788-c8eef37e02b0"
replace agri_6_38_a_1 = 0 if key == "uuid:15a55cfa-3d02-4c69-9788-c8eef37e02b0"
replace o_culture_05 = 200 if key == "uuid:11ce0c6b-9146-41e6-88fd-c3476ed8df84"
replace o_culture_01 = 0.50 if key == "uuid:0d7abf18-244e-4440-b557-8ac4589ddf38"
replace legumineuses_05_3 = 200 if key == "uuid:f7b4c6d1-f700-43ec-b688-c5722030e939"
replace legumineuses_05_3 = 200 if key == "uuid:c842e94c-b701-4bbf-828b-d9af9842e9f4"
replace legumineuses_05_3 = 200 if key == "uuid:128a3336-2145-4223-830a-b0441699891a"
replace legumineuses_05_3 = 200 if key == "uuid:a6f06172-a08d-4d69-8d71-5f7b569e500c"
replace legumineuses_05_3 = 200 if key == "uuid:8ac88925-7262-478f-ba15-aab4fd2923ef"
replace legumineuses_05_3 = 200 if key == "uuid:c05dfa61-92b8-4b10-b5c3-f7bacc08adae"
replace legumineuses_05_3 = 200 if key == "uuid:57bb8e54-caf8-49c9-a0f5-fd636d2a2592"
replace legumineuses_05_3 = 200 if key == "uuid:1e2622db-664a-41cd-b167-69d0eef375aa"
replace legumineuses_05_3 = 200 if key == "uuid:eed2c8e6-e74f-4fe9-b790-665dbdd4c54d"
replace legumineuses_05_1 = 200 if key == "uuid:950634d7-6af7-48f4-81f2-23e84812d304"
replace legumineuses_05_1 = 200 if key == "uuid:2d1a6ae0-e370-4f0a-accc-dcf57cbb8a4a"
replace legumineuses_05_1 = 200 if key == "uuid:c842e94c-b701-4bbf-828b-d9af9842e9f4"
replace legumineuses_05_1 = 200 if key == "uuid:a6f06172-a08d-4d69-8d71-5f7b569e500c"
replace legumes_05_6 = 200 if key == "uuid:07815cfd-fc9e-42e6-823e-83d93c2b9461"
replace legumes_05_3 = 175 if key == "uuid:f7b4c6d1-f700-43ec-b688-c5722030e939"
replace legumes_05_3 = 175 if key == "uuid:c842e94c-b701-4bbf-828b-d9af9842e9f4"
replace legumes_05_3 = 175 if key == "uuid:c05dfa61-92b8-4b10-b5c3-f7bacc08adae"
replace legumes_05_3 = 175 if key == "uuid:1e2622db-664a-41cd-b167-69d0eef375aa"
replace legumes_05_3 = 175 if key == "uuid:eed2c8e6-e74f-4fe9-b790-665dbdd4c54d"
replace legumes_05_1 = 150 if key == "uuid:c842e94c-b701-4bbf-828b-d9af9842e9f4"
replace legumes_04_1 = 300 if key == "uuid:950634d7-6af7-48f4-81f2-23e84812d304"
replace legumes_02_3 = -9 if key == "uuid:c842e94c-b701-4bbf-828b-d9af9842e9f4"
replace legumes_02_3 = -9 if key == "uuid:eed2c8e6-e74f-4fe9-b790-665dbdd4c54d"
replace legumes_02_1 = -9 if key == "uuid:c842e94c-b701-4bbf-828b-d9af9842e9f4"
replace hh_age_resp = 46 if key == "uuid:2f926078-b492-4431-b567-f9e13545fafe"
replace age_8 = -9 if key == "uuid:443cfabd-f98c-4336-8e20-80f8957bad20"
replace age_1 = 69 if key == "uuid:984ee70d-6f6d-4e94-908e-1c8fc7b606eb"
replace hh_41_9 = 6 if key == "uuid:715348c5-4975-4ab4-9299-efc393087ce8"
replace farines_05_6 = 225 if key == "uuid:11ce0c6b-9146-41e6-88fd-c3476ed8df84"
replace cereals_05_1 = 175 if key == "uuid:8bf01f7f-fd39-4e21-9f1a-b31c83ceaf9a"
replace cereals_05_1 = 175 if key == "uuid:984ee70d-6f6d-4e94-908e-1c8fc7b606eb"
replace cereals_05_1 = 225 if key == "uuid:ff0ec7d0-7b19-4476-85ae-222b4a04f67f"
replace cereals_05_1 = 225 if key == "uuid:fb7a0757-baa4-4af7-8692-97509e1946b2"
replace cereals_05_1 = 175 if key == "uuid:ea6f1aa0-4686-45d7-90af-f0fb8bd95da6"
replace cereals_05_1 = 175 if key == "uuid:7b999785-4d17-4867-8512-d3bf09c28590"
replace cereals_05_1 = 175 if key == "uuid:f273bcdd-6a76-4277-8885-62c4ff1c5ca2"
replace cereals_05_1 = 225 if key == "uuid:8ac88925-7262-478f-ba15-aab4fd2923ef"
replace cereals_05_1 = 225 if key == "uuid:fabed4ff-f860-41fe-9c98-0414b3b96906"
replace cereals_05_1 = 175 if key == "uuid:202a0a2f-288d-4913-a1c0-51628440129d"
replace cereals_02_1 = 2200 if key == "uuid:d84a37d5-09e5-45ee-94fc-da2954f60d2b"
replace cereals_02_1 = 2000 if key == "uuid:843e9a2d-5908-409a-a7ce-e315a6048975"
replace cereals_02_1 = 1500 if key == "uuid:bc16c47a-d6eb-4e45-97a7-b5275bfd1f91"
replace cereals_02_1 = 1300 if key == "uuid:aab4e4e3-d006-4431-b647-f138d25f3b07"
replace agri_income_45_6 = -9 if key == "uuid:36cc7c65-9580-4182-92d9-ddda36fbb0ea"
replace agri_income_45_5 = -9 if key == "uuid:36cc7c65-9580-4182-92d9-ddda36fbb0ea"
replace agri_income_45_3 = -9 if key == "uuid:36cc7c65-9580-4182-92d9-ddda36fbb0ea"
replace agri_income_33 = -9 if key == "uuid:6942e4de-2992-42cc-b611-72abe5834a35"
replace agri_income_33 = -9 if key == "uuid:443cfabd-f98c-4336-8e20-80f8957bad20"
replace agri_income_29 = -9 if key == "uuid:443cfabd-f98c-4336-8e20-80f8957bad20"
replace agri_income_23_1 = -9 if key == "uuid:8f49e817-68d3-4a92-98c6-02ed3739a07f"
replace agri_income_23_1 = -9 if key == "uuid:443cfabd-f98c-4336-8e20-80f8957bad20"
replace agri_income_08_o = -9 if key == "uuid:07815cfd-fc9e-42e6-823e-83d93c2b9461"
replace agri_income_08_4 = -9 if key == "uuid:950634d7-6af7-48f4-81f2-23e84812d304"
replace agri_income_07_o = -9 if key == "uuid:07815cfd-fc9e-42e6-823e-83d93c2b9461"
replace agri_income_06 = -9 if key == "uuid:230eeec0-f4e6-476f-a49b-68a540e6612e"
replace agri_income_06 = -9 if key == "uuid:cda122cf-9280-432d-a1a8-8b7d8c4948f9"
replace agri_income_06 = -9 if key == "uuid:6942e4de-2992-42cc-b611-72abe5834a35"
replace agri_income_06 = -9 if key == "uuid:36cc7c65-9580-4182-92d9-ddda36fbb0ea"
replace agri_income_06 = -9 if key == "uuid:0d7abf18-244e-4440-b557-8ac4589ddf38"
replace agri_income_06 = -9 if key == "uuid:7b999785-4d17-4867-8512-d3bf09c28590"
replace agri_income_06 = -9 if key == "uuid:ec674bbd-07e3-4ad3-bb4e-915aed528559"
replace agri_income_06 = -9 if key == "uuid:d99a8dd2-9a86-4b52-bda5-100b7ac0015d"
replace agri_income_05 = -9 if key == "uuid:cda122cf-9280-432d-a1a8-8b7d8c4948f9"
replace agri_income_05 = -9 if key == "uuid:6942e4de-2992-42cc-b611-72abe5834a35"
replace agri_income_05 = -9 if key == "uuid:36cc7c65-9580-4182-92d9-ddda36fbb0ea"
replace agri_income_05 = -9 if key == "uuid:0d7abf18-244e-4440-b557-8ac4589ddf38"
replace agri_income_05 = -9 if key == "uuid:7b999785-4d17-4867-8512-d3bf09c28590"
replace agri_income_05 = -9 if key == "uuid:ec674bbd-07e3-4ad3-bb4e-915aed528559"
replace agri_income_05 = -9 if key == "uuid:d99a8dd2-9a86-4b52-bda5-100b7ac0015d"
replace agri_6_41_a_code_1 = 1 if key == "uuid:0a43a01a-dbf1-461e-89b9-a835a33c08f7"
replace agri_6_41_a_code_1 = 1 if key == "uuid:12365a5a-4214-4110-8d6f-71a239fd6ddd"
replace agri_6_41_a_1 = 0 if key == "uuid:0a43a01a-dbf1-461e-89b9-a835a33c08f7"
replace agri_6_40_a_code_1 = 1 if key == "uuid:bc96fed2-69a6-4cdf-8d89-2e43ae2532d7"
replace agri_6_40_a_2 = 0 if key == "uuid:bc16c47a-d6eb-4e45-97a7-b5275bfd1f91"
replace legumineuses_05_5 = 300 if key == "uuid:47546bc8-57e7-4827-a110-c0a10c19119a"
replace legumineuses_05_3 = 300 if key == "uuid:a63d364d-8238-4c51-a32c-a0b5c9ec3e6a"
replace legumineuses_05_3 = 300 if key == "uuid:f72c4194-1658-4baa-9e40-7e6b0ea2b3a8"
replace legumineuses_05_3 = 300 if key == "uuid:f85909ab-7a41-488b-8ef6-3b6c9c741342"
replace legumineuses_05_3 = 300 if key == "uuid:ef02696f-ea57-44ac-8aa4-75f92ec3f427"
replace legumineuses_05_3 = 300 if key == "uuid:14c86e34-c194-4f36-b9b9-9e05af3a609a"
replace legumineuses_05_3 = 300 if key == "uuid:a9a2eb7c-4e91-470a-b120-16fd71831ffc"
replace legumineuses_05_3 = 300 if key == "uuid:a420540e-7ac1-4fdb-ae20-2072c04e743d"
replace legumineuses_05_3 = 300 if key == "uuid:39dd24f5-8963-48ff-9c00-a824e9fe8e58"
replace legumineuses_05_1 = 300 if key == "uuid:deb94544-9a4d-4169-a75f-0ee9c84db3e9"
replace legumineuses_05_1 = 300 if key == "uuid:e4d9ab46-b30f-4d93-a47b-9b0e1c367d58"
replace legumes_05_3 = 600 if key == "uuid:f72c4194-1658-4baa-9e40-7e6b0ea2b3a8"
replace legumes_04_6 = 250 if key == "uuid:a6aa6572-4ca2-4c8d-8be7-3027d7d09a1b"
replace hh_age_resp = 37 if key == "uuid:e35b6cb4-4798-4a9f-9204-b8ff061c91c5"
replace hh_age_resp = 61 if key == "uuid:39dd24f5-8963-48ff-9c00-a824e9fe8e58"
replace age_7 = 76 if key == "uuid:256e0731-49c7-493f-8e8a-507a55d78b09"
replace hh_14_b_10 = 4 if key == "uuid:ae1311ec-4bb0-4ac4-94f2-b84f93d1a137"
replace hh_14_a_10 = 28 if key == "uuid:ae1311ec-4bb0-4ac4-94f2-b84f93d1a137"
replace health_5_12_2 = 300 if key == "uuid:c52e24f8-ed96-47bd-8406-da314b553399"
replace health_5_12_2 = 300 if key == "uuid:c52e24f8-ed96-47bd-8406-da314b553399"
replace health_5_12_10 = 0 if key == "uuid:ce006143-d00a-48fd-928c-252e34c0cec8"
replace health_5_12_11 = 0 if key == "uuid:ce006143-d00a-48fd-928c-252e34c0cec8"
replace health_5_12_12 = 0 if key == "uuid:ce006143-d00a-48fd-928c-252e34c0cec8"
replace health_5_12_2 = 0 if key == "uuid:ce006143-d00a-48fd-928c-252e34c0cec8"
replace health_5_12_4 = 0 if key == "uuid:ce006143-d00a-48fd-928c-252e34c0cec8"
replace health_5_12_8 = 0 if key == "uuid:ce006143-d00a-48fd-928c-252e34c0cec8"
replace health_5_12_4 = 0 if key == "uuid:dcb98d0f-b093-49af-a066-e2dd990ff00e"
replace health_5_12_5 = 0 if key == "uuid:dcb98d0f-b093-49af-a066-e2dd990ff00e"
replace health_5_12_1 = -9 if key == "uuid:a63d364d-8238-4c51-a32c-a0b5c9ec3e6a"
replace health_5_12_11 = -9 if key == "uuid:a63d364d-8238-4c51-a32c-a0b5c9ec3e6a"
replace health_5_12_12 = -9 if key == "uuid:a63d364d-8238-4c51-a32c-a0b5c9ec3e6a"
replace health_5_12_2 = -9 if key == "uuid:a63d364d-8238-4c51-a32c-a0b5c9ec3e6a"
replace health_5_12_4 = -9 if key == "uuid:a63d364d-8238-4c51-a32c-a0b5c9ec3e6a"
replace health_5_12_5 = -9 if key == "uuid:a63d364d-8238-4c51-a32c-a0b5c9ec3e6a"
replace health_5_12_8 = -9 if key == "uuid:a63d364d-8238-4c51-a32c-a0b5c9ec3e6a"
replace health_5_12_9 = -9 if key == "uuid:a63d364d-8238-4c51-a32c-a0b5c9ec3e6a"
replace health_5_12_4 = 500 if key == "uuid:c061f456-3a81-4ff0-a269-fd05569d9747"
replace health_5_12_4 = 500 if key == "uuid:c061f456-3a81-4ff0-a269-fd05569d9747"
replace farines_02_1 = 1200 if key == "uuid:9dd87d99-ba8b-4d5e-9075-4ef5adbed212"
replace correct_hh = 1 if key == "uuid:fae90374-b9e4-4dd4-973a-95b5fc359499"
replace cereals_02_1 = 1250 if key == "uuid:f64dd1f9-662f-4e01-b1af-d99bd9d2725f"
replace cereals_02_1 = 1400 if key == "uuid:614b075d-1253-46f3-ba62-eae586e7fd4b"
replace cereals_02_1 = -9 if key == "uuid:a8ab108b-bfad-4d97-979e-781ec303068d"
replace animals_sales_o = 0 if key == "uuid:ca1ec515-aaa2-4a7a-81cd-9c493d0ee399"
replace animals_sales_o = 0 if key == "uuid:7eb66aa0-0169-41c4-a623-c4e0dcd139b5"
replace agri_income_45_6 = -9 if key == "uuid:46c68d66-a26a-41b3-854d-df3e6a061945"
replace agri_income_45_5 = -9 if key == "uuid:46c68d66-a26a-41b3-854d-df3e6a061945"
replace agri_income_45_4 = -9 if key == "uuid:46c68d66-a26a-41b3-854d-df3e6a061945"
replace agri_6_40_a_code_1 = 1 if key == "uuid:b69b3857-9b61-4d93-b17d-9087698d29dd"
replace agri_6_40_a_code_1 = 1 if key == "uuid:ac9fb9d9-9283-417b-ae79-61b85d11d585"
replace agri_6_40_a_code_1 = 1 if key == "uuid:ac8a29b2-ae30-4212-9ae5-d826788cf727"
replace agri_6_28_2 = -9 if key == "uuid:9dd87d99-ba8b-4d5e-9075-4ef5adbed212"
replace agri_6_28_1 = -9 if key == "uuid:9dd87d99-ba8b-4d5e-9075-4ef5adbed212"
replace agri_6_28_1 = -9 if key == "uuid:f59daa5f-8316-4e92-b9d2-60df47a098a0"
replace agri_6_28_1 = -9 if key == "uuid:4f47b14b-2e54-47b1-8265-132aa3d430b2"
replace legumineuses_05_3 = 300 if key == "uuid:e5eb596e-392d-43e1-8ac5-19f7993e9401"
replace legumineuses_05_3 = 300 if key == "uuid:924e4381-5ab0-4f49-9c41-ddb4d0b33b3d"
replace legumineuses_05_3 = 300 if key == "uuid:f3fc7fa3-cc52-48a4-b153-e65733a5a392"
replace legumineuses_05_3 = 300 if key == "uuid:f5b801b2-4f63-4c4c-8b53-3aff721de561"
replace legumineuses_05_3 = 300 if key == "uuid:4035a33e-2bd5-4107-bd3b-7e0232f24f81"
replace legumineuses_05_3 = 300 if key == "uuid:12b6f47f-aa90-4a91-95c0-ea66bcfb624d"
replace legumineuses_05_3 = 300 if key == "uuid:dfd04b1f-4f0e-4bf0-a42c-51e756a93966"
replace legumineuses_05_3 = 300 if key == "uuid:e25110ba-6df8-467a-b38e-577b9986dd00"
replace legumineuses_05_3 = 300 if key == "uuid:93743604-01c7-48c5-a295-3242254348b6"
replace legumineuses_05_3 = 300 if key == "uuid:232224b4-8541-4a06-9f00-7dcca4573eb6"
replace legumineuses_05_3 = 300 if key == "uuid:c87d313e-22c7-46b4-9aef-a2087808f7a4"
replace legumineuses_05_3 = 300 if key == "uuid:115dcd77-61fe-4038-92a0-e8d1083958ab"
replace legumineuses_05_3 = 300 if key == "uuid:a543aca6-17a1-4d96-afa7-d872d7205ad9"
replace legumineuses_05_3 = 300 if key == "uuid:07374a46-8b35-4535-8e7f-aee405e62880"
replace legumineuses_05_3 = 300 if key == "uuid:e1500728-8f0d-4082-aa0b-7151e4c98c24"
replace legumineuses_05_3 = 300 if key == "uuid:aa543528-4309-4e78-a791-eebcab470093"
replace legumineuses_05_3 = 300 if key == "uuid:97c0bd0c-6d8c-4571-bc15-d2d169449e82"
replace legumineuses_05_3 = 300 if key == "uuid:63027ea6-4db1-4d75-9e50-07102ad7e66d"
replace legumineuses_05_2 = 300 if key == "uuid:07374a46-8b35-4535-8e7f-aee405e62880"
replace legumineuses_05_1 = 300 if key == "uuid:f3fc7fa3-cc52-48a4-b153-e65733a5a392"
replace legumineuses_05_1 = 300 if key == "uuid:12b6f47f-aa90-4a91-95c0-ea66bcfb624d"
replace legumes_05_1 = 200 if key == "uuid:f3fc7fa3-cc52-48a4-b153-e65733a5a392"
replace legumes_05_1 = 200 if key == "uuid:12b6f47f-aa90-4a91-95c0-ea66bcfb624d"
replace legumes_02_3 = -9 if key == "uuid:e5eb596e-392d-43e1-8ac5-19f7993e9401"
replace legumes_02_3 = 1200 if key == "uuid:924e4381-5ab0-4f49-9c41-ddb4d0b33b3d"
replace legumes_02_3 = 1720 if key == "uuid:dfd04b1f-4f0e-4bf0-a42c-51e756a93966"
replace legumes_02_3 = 1260 if key == "uuid:e25110ba-6df8-467a-b38e-577b9986dd00"
replace legumes_02_3 = 1260 if key == "uuid:07374a46-8b35-4535-8e7f-aee405e62880"
replace legumes_02_3 = 1720 if key == "uuid:e1500728-8f0d-4082-aa0b-7151e4c98c24"
replace legumes_02_2 = -9 if key == "uuid:07374a46-8b35-4535-8e7f-aee405e62880"
replace legumes_02_1 = -9 if key == "uuid:f3fc7fa3-cc52-48a4-b153-e65733a5a392"
replace legumes_02_1 = -9 if key == "uuid:12b6f47f-aa90-4a91-95c0-ea66bcfb624d"
replace hh_education_level_5 = 1 if key == "uuid:2a48fd8c-b5b1-423b-87dd-c01cb6405189"
replace hh_41_4 = 7 if key == "uuid:801e11ec-467f-4cc9-9eb6-0dec8dbec2a5"
replace health_5_12_1 = 400 if key == "uuid:8294761e-3bcd-4a16-9dab-14913b5f9e2a"
replace health_5_12_1 = 400 if key == "uuid:8294761e-3bcd-4a16-9dab-14913b5f9e2a"
replace health_5_12_5 = 200 if key == "uuid:0ce7d392-22ca-4a4f-abd1-8bb9364ddaa4"
replace health_5_12_5 = 200 if key == "uuid:0ce7d392-22ca-4a4f-abd1-8bb9364ddaa4"
replace health_5_12_8 = 250 if key == "uuid:32489a2a-4606-4b8b-85ba-3345d9bb229f"
replace health_5_12_8 = 250 if key == "uuid:32489a2a-4606-4b8b-85ba-3345d9bb229f"
replace health_5_12_7 = 200 if key == "uuid:896ef294-6ea0-45d0-9468-3f1bdf54924e"
replace health_5_12_7 = 200 if key == "uuid:896ef294-6ea0-45d0-9468-3f1bdf54924e"
replace health_5_12_3 = 300 if key == "uuid:a0af735e-1a67-40ea-b4f4-c65fb5b58ed0"
replace health_5_12_2 = 250 if key == "uuid:9cf0b8bc-d0cc-4396-9711-d75336bdabfd"
replace health_5_12_14 = 400 if key == "uuid:63027ea6-4db1-4d75-9e50-07102ad7e66d"
replace health_5_12_22 = 200 if key == "uuid:63027ea6-4db1-4d75-9e50-07102ad7e66d"
replace health_5_12_3 = 300 if key == "uuid:a0af735e-1a67-40ea-b4f4-c65fb5b58ed0"
replace health_5_12_9 = 300 if key == "uuid:201c00d0-75bc-4b0a-8e70-feecab62c8e0"
replace health_5_12_2 = 100 if key == "uuid:9cf0b8bc-d0cc-4396-9711-d75336bdabfd"
replace health_5_12_14 = 400 if key == "uuid:63027ea6-4db1-4d75-9e50-07102ad7e66d"
replace health_5_12_9 = 156 if key == "uuid:201c00d0-75bc-4b0a-8e70-feecab62c8e0"
replace health_5_12_22 = 200 if key == "uuid:63027ea6-4db1-4d75-9e50-07102ad7e66d"
replace farines_05_2 = -9 if key == "uuid:c0442e67-dd33-43e3-abe6-5ca3872ac0b3"
replace farines_02_2 = -9 if key == "uuid:c0442e67-dd33-43e3-abe6-5ca3872ac0b3"
replace farines_02_2 = -9 if key == "uuid:0ce7d392-22ca-4a4f-abd1-8bb9364ddaa4"
replace animals_sales_o = 0 if key == "uuid:c87d313e-22c7-46b4-9aef-a2087808f7a4"
replace agri_income_47_1 = 23000 if key == "uuid:232224b4-8541-4a06-9f00-7dcca4573eb6"
replace agri_income_47_1 = 22000 if key == "uuid:aa543528-4309-4e78-a791-eebcab470093"
replace agri_income_45_8 = 100000 if key == "uuid:47be8004-98c1-4490-b657-34a347637b20"
replace agri_income_45_8 = 80000 if key == "uuid:d1e9a6b7-4901-4e70-a991-fa6db1906a2a"
replace agri_income_45_7 = -9 if key == "uuid:f0e95d05-f703-4242-bb05-cdf1c7be4e16"
replace agri_income_45_7 = -9 if key == "uuid:801e11ec-467f-4cc9-9eb6-0dec8dbec2a5"
replace agri_income_45_6 = -9 if key == "uuid:e5eb596e-392d-43e1-8ac5-19f7993e9401"
replace agri_income_45_6 = -9 if key == "uuid:27620229-c213-47f3-8b61-f8ec6c7cd1cc"
replace agri_income_45_6 = -9 if key == "uuid:896ef294-6ea0-45d0-9468-3f1bdf54924e"
replace agri_income_45_6 = -9 if key == "uuid:481263fb-d102-43b2-8504-d72a780bd7e8"
replace agri_income_45_6 = 50000 if key == "uuid:f0e95d05-f703-4242-bb05-cdf1c7be4e16"
replace agri_income_45_5 = 30000 if key == "uuid:27620229-c213-47f3-8b61-f8ec6c7cd1cc"
replace agri_income_45_5 = 5000 if key == "uuid:12b6f47f-aa90-4a91-95c0-ea66bcfb624d"
replace agri_income_45_5 = 15000 if key == "uuid:dfd04b1f-4f0e-4bf0-a42c-51e756a93966"
replace agri_income_45_5 = -9 if key == "uuid:9e53c128-b360-47f1-a624-e5a0e0e8c3cd"
replace agri_income_45_5 = -9 if key == "uuid:3730061c-a719-461a-a962-034ffbfd7e20"
replace agri_income_45_4 = 87000 if key == "uuid:12b6f47f-aa90-4a91-95c0-ea66bcfb624d"
replace agri_income_45_4 = 85000 if key == "uuid:c87d313e-22c7-46b4-9aef-a2087808f7a4"
replace agri_income_45_4 = 65000 if key == "uuid:3730061c-a719-461a-a962-034ffbfd7e20"
replace agri_income_45_3 = 40000 if key == "uuid:e1500728-8f0d-4082-aa0b-7151e4c98c24"
replace agri_income_45_2 = 24000 if key == "uuid:27620229-c213-47f3-8b61-f8ec6c7cd1cc"
replace agri_income_45_2 = 20000 if key == "uuid:824199a9-08c8-4346-b9fc-9a67d4068e26"
replace agri_income_45_2 = -9 if key == "uuid:9f46c69f-f13a-4f0d-8035-91c346dcb751"
replace agri_income_45_2 = -9 if key == "uuid:f0e95d05-f703-4242-bb05-cdf1c7be4e16"
replace agri_income_42_1 = 0 if key == "uuid:93743604-01c7-48c5-a295-3242254348b6"
replace agri_income_41_1 = 15000 if key == "uuid:93743604-01c7-48c5-a295-3242254348b6"
replace agri_income_33 = -9 if key == "uuid:1f8316b4-c849-40b4-8ced-4cb30d7d5944"
replace agri_income_33 = -9 if key == "uuid:97c0bd0c-6d8c-4571-bc15-d2d169449e82"
replace agri_income_33 = -9 if key == "uuid:f0e95d05-f703-4242-bb05-cdf1c7be4e16"
replace agri_income_23_o = -9 if key == "uuid:56d685d1-e1a6-432f-9343-3a9c41d3e089"
replace agri_income_23_o = 12000 if key == "uuid:85e806ff-6817-4d98-a0d7-8ad6f8cfaba3"
replace agri_income_23_1 = -9 if key == "uuid:31fd0450-5add-4058-bf77-a506823a7fca"
replace agri_income_23_1 = -9 if key == "uuid:bff7956c-0e63-4cf7-b6f8-abf16a8c0276"
replace agri_income_23_1 = -9 if key == "uuid:68a3059c-40a2-47ae-b9a7-d9072411b67a"
replace agri_income_23_1 = -9 if key == "uuid:2a48fd8c-b5b1-423b-87dd-c01cb6405189"
replace agri_income_23_1 = -9 if key == "uuid:e25110ba-6df8-467a-b38e-577b9986dd00"
replace agri_income_23_1 = -9 if key == "uuid:c87d313e-22c7-46b4-9aef-a2087808f7a4"
replace agri_income_23_1 = 8000 if key == "uuid:115dcd77-61fe-4038-92a0-e8d1083958ab"
replace agri_income_23_1 = -9 if key == "uuid:07374a46-8b35-4535-8e7f-aee405e62880"
replace agri_income_23_1 = -9 if key == "uuid:e1500728-8f0d-4082-aa0b-7151e4c98c24"
replace agri_income_23_1 = -9 if key == "uuid:d1e9a6b7-4901-4e70-a991-fa6db1906a2a"
replace agri_income_23_1 = -9 if key == "uuid:24b6fa8e-852f-4176-a864-8d93e07675f2"
replace agri_income_22_o = 12 if key == "uuid:85e806ff-6817-4d98-a0d7-8ad6f8cfaba3"
replace agri_income_19 = -9 if key == "uuid:c87d313e-22c7-46b4-9aef-a2087808f7a4"
replace agri_income_08_2 = 4 if key == "uuid:f0e95d05-f703-4242-bb05-cdf1c7be4e16"
replace agri_income_06 = -9 if key == "uuid:c4551c9e-c0c0-4f4a-b080-e07648e53697"
replace agri_income_06 = -9 if key == "uuid:e30ea4ae-696d-4a95-b119-ffa43fde532f"
replace agri_income_06 = -9 if key == "uuid:e25110ba-6df8-467a-b38e-577b9986dd00"
replace agri_income_06 = -9 if key == "uuid:97c0bd0c-6d8c-4571-bc15-d2d169449e82"
replace agri_income_06 = -9 if key == "uuid:24b6fa8e-852f-4176-a864-8d93e07675f2"
replace agri_income_05 = -9 if key == "uuid:c4551c9e-c0c0-4f4a-b080-e07648e53697"
replace agri_income_05 = -9 if key == "uuid:e30ea4ae-696d-4a95-b119-ffa43fde532f"
replace agri_income_05 = -9 if key == "uuid:824199a9-08c8-4346-b9fc-9a67d4068e26"
replace agri_income_05 = -9 if key == "uuid:e25110ba-6df8-467a-b38e-577b9986dd00"
replace agri_income_05 = -9 if key == "uuid:97c0bd0c-6d8c-4571-bc15-d2d169449e82"
replace agri_income_05 = -9 if key == "uuid:24b6fa8e-852f-4176-a864-8d93e07675f2"
replace agri_income_05 = -9 if key == "uuid:5dbb5ff1-8bb0-42a8-97b9-908ced71a624"
replace agri_income_03 = 12 if key == "uuid:50898d5f-9c56-4102-acf5-6affdc59d4ed"
replace agri_6_41_a_1 = 0 if key == "uuid:4035a33e-2bd5-4107-bd3b-7e0232f24f81"
replace agri_6_41_a_1 = 0 if key == "uuid:c87d313e-22c7-46b4-9aef-a2087808f7a4"
replace agri_6_39_a_1 = 0 if key == "uuid:04f82d4c-d64b-4f3d-b127-21f022dd526b"
replace agri_6_39_a_1 = 0 if key == "uuid:1f8316b4-c849-40b4-8ced-4cb30d7d5944"
replace agri_6_39_a_1 = 0 if key == "uuid:c9c6c412-ce94-4805-96fb-3acb3e1c0732"
replace agri_6_38_a_code_1 = 1 if key == "uuid:cf2f6567-6a3e-40f2-b123-9bd11591aeb1"
replace agri_6_38_a_1 = 0 if key == "uuid:cf2f6567-6a3e-40f2-b123-9bd11591aeb1"
replace agri_6_28_1 = 0 if key == "uuid:24b6fa8e-852f-4176-a864-8d93e07675f2"
replace agri_6_28_1 = 0 if key == "uuid:f0e95d05-f703-4242-bb05-cdf1c7be4e16"
replace legumineuses_05_3 = 300 if key == "uuid:ff453b25-91fe-4436-8ebc-338f75318796"
replace legumineuses_05_3 = 300 if key == "uuid:97918522-f1cb-430b-b99e-fd2ffbdeef85"
replace legumineuses_05_3 = 300 if key == "uuid:bc558318-ee9a-45f6-af5d-52b69630acf4"
replace legumineuses_05_3 = 300 if key == "uuid:56635d21-e100-48f8-afea-154e6d7e7f87"
replace legumineuses_05_3 = 300 if key == "uuid:4e967cc8-83ab-41bc-ac05-c67bc529dbdb"
replace legumineuses_05_3 = 300 if key == "uuid:d4febba0-ef62-4a2d-b215-9f2edf88d392"
replace legumineuses_05_3 = 300 if key == "uuid:255d0b95-f83e-45d6-85d8-079546e38ac2"
replace legumineuses_05_3 = 300 if key == "uuid:b2202ec3-d0b6-4111-a850-376863e3fef8"
replace legumineuses_05_3 = 300 if key == "uuid:41d6a692-b019-4723-aba2-584fb30b594d"
replace legumineuses_05_3 = 300 if key == "uuid:676c9fa9-17ab-47f0-8b3c-36f785eb8259"
replace legumineuses_05_3 = 300 if key == "uuid:642af3ea-23e3-4b5d-ae33-96b6f497384c"
replace legumineuses_05_3 = 300 if key == "uuid:b34d86ce-46ca-4d8e-a5a0-3b5fcf2d2da2"
replace legumineuses_05_3 = 300 if key == "uuid:1abd03bc-bc6d-47d2-8534-b5fba2b259ee"
replace legumineuses_05_3 = 300 if key == "uuid:64fda970-6161-40d1-9137-1c8eba4a9b96"
replace legumineuses_05_3 = 300 if key == "uuid:de6fe581-aa9e-4c66-88bc-54dec37b0e4f"
replace legumineuses_05_3 = 300 if key == "uuid:8b5fa358-6317-4e65-a16f-0fce2d44c6b5"
replace legumineuses_05_3 = 300 if key == "uuid:2aa0d10c-b78e-4dfe-a7f9-367508bd8988"
replace legumineuses_05_3 = 300 if key == "uuid:aefc062f-b9de-4db1-8c6e-46f66ce9c90f"
replace legumineuses_05_1 = 300 if key == "uuid:25b11d07-11c0-4ac3-b018-16762d01f201"
replace legumineuses_05_1 = 300 if key == "uuid:b34d86ce-46ca-4d8e-a5a0-3b5fcf2d2da2"
replace age_6 = 79 if key == "uuid:255d0b95-f83e-45d6-85d8-079546e38ac2"
replace cereals_02_1 = 1360 if key == "uuid:d4febba0-ef62-4a2d-b215-9f2edf88d392"
replace legumineuses_05_4 = 300 if key == "uuid:e6d61f8b-bae8-4a27-bda4-6422e002efe7"
replace legumineuses_05_3 = 300 if key == "uuid:0616bf14-e0b8-4c96-87f8-e78b38bbbaeb"
replace legumineuses_05_3 = 300 if key == "uuid:48307db7-0b01-44ba-9c41-45125c0352bd"
replace legumineuses_05_3 = 300 if key == "uuid:80eed8af-d776-450b-ab4e-f3d67e01ec39"
replace legumineuses_05_1 = 300 if key == "uuid:9bed3f13-6182-4946-973e-c84ebdb7e64d"
replace legumineuses_05_1 = 300 if key == "uuid:90fe8f5d-1972-4a14-981b-53c3b8d1bb20"
replace legumineuses_05_1 = 300 if key == "uuid:e6d61f8b-bae8-4a27-bda4-6422e002efe7"
replace legumineuses_05_1 = 300 if key == "uuid:48307db7-0b01-44ba-9c41-45125c0352bd"
replace legumes_05_3 = 600 if key == "uuid:0616bf14-e0b8-4c96-87f8-e78b38bbbaeb"
replace legumes_05_3 = 600 if key == "uuid:80eed8af-d776-450b-ab4e-f3d67e01ec39"
replace legumes_02_1 = 1200 if key == "uuid:9bed3f13-6182-4946-973e-c84ebdb7e64d"
replace hh_education_level_9 = 0 if key == "uuid:bb08e9b3-c93c-4a05-addd-49b0be007292"
replace hh_41_7 = 7 if key == "uuid:798f8ec4-a21b-4154-ab79-d19b423425a3"
replace hh_41_5 = 6 if key == "uuid:6508577d-44e4-4131-88e0-8754e50509d7"
replace hh_41_17 = 7 if key == "uuid:de358167-c62b-4063-830a-a3f52a40516e"
replace hh_12_o_1 = "-9" if key == "uuid:e6d61f8b-bae8-4a27-bda4-6422e002efe7"
replace health_5_12_9 = 26 if key == "uuid:de358167-c62b-4063-830a-a3f52a40516e"
replace health_5_12_9 = 26 if key == "uuid:de358167-c62b-4063-830a-a3f52a40516e"
replace health_5_12_5 = 43 if key == "uuid:de358167-c62b-4063-830a-a3f52a40516e"
replace health_5_12_5 = 43 if key == "uuid:de358167-c62b-4063-830a-a3f52a40516e"
replace health_5_12_8 = 4 if key == "uuid:c098e2bf-121b-4e3d-81b6-c1e72f4ea471"
replace health_5_12_8 = 4 if key == "uuid:c098e2bf-121b-4e3d-81b6-c1e72f4ea471"
replace health_5_12_1 = 43 if key == "uuid:3ae7523d-547a-4630-a07e-7e88c407b9e7"
replace health_5_12_1 = 43 if key == "uuid:3ae7523d-547a-4630-a07e-7e88c407b9e7"
replace farines_02_4 = 3200 if key == "uuid:370d88ef-b3d9-4646-8cfc-1135fc57197a"
replace cereals_05_1 = 400 if key == "uuid:1c8bf57e-1ccc-4e98-b168-29bc15bdd520"
replace cereals_05_1 = 400 if key == "uuid:c098e2bf-121b-4e3d-81b6-c1e72f4ea471"
replace cereals_05_1 = 400 if key == "uuid:56ab4aa6-6341-4404-8708-00775bf568b9"
replace cereals_03_1 = 350 if key == "uuid:d61be3bb-3268-4acb-8bc1-296b9031e1cb"
replace cereals_02_1 = 2400 if key == "uuid:b39da8c4-f8e6-48bb-b75b-9a498d140b43"
replace agri_6_28_1 = -9 if key == "uuid:e6d61f8b-bae8-4a27-bda4-6422e002efe7"
replace legumineuses_05_4 = 600 if key == "uuid:b469f9f5-c7f1-4de9-baee-d796aa0b9a12"
replace legumineuses_05_4 = 600 if key == "uuid:d7cf7d20-89ae-405c-af0f-c9f04d222f68"
replace legumineuses_05_4 = 600 if key == "uuid:90087636-54ff-494e-be4f-b7df221f4a1d"
replace legumineuses_05_4 = 600 if key == "uuid:9b8df772-b6cb-4e9a-9694-d5773d97fac5"
replace legumineuses_05_4 = 500 if key == "uuid:94a38643-7c8f-4e15-a9a0-27858a06c18d"
replace legumineuses_05_3 = 500 if key == "uuid:85c3253f-8039-4374-b28f-b9a389c51b66"
replace legumineuses_05_3 = 600 if key == "uuid:10ce019a-2990-430a-a81b-7c308a4c7bad"
replace legumineuses_05_3 = 500 if key == "uuid:920076db-929a-4cd7-9cd9-62e37f877a5c"
replace legumineuses_05_3 = 500 if key == "uuid:d685d816-bff6-4336-b2d7-18e5e0ce6642"
replace legumineuses_05_3 = 600 if key == "uuid:14962970-5438-430e-a873-4b7083b3ff89"
replace legumineuses_05_3 = 600 if key == "uuid:4d4e66ed-0f44-44e0-9f77-3ab43483d17f"
replace legumineuses_05_3 = 600 if key == "uuid:b469f9f5-c7f1-4de9-baee-d796aa0b9a12"
replace legumineuses_05_3 = 600 if key == "uuid:214b4d71-afe8-4c2f-877d-a528a1719e19"
replace legumineuses_05_3 = 600 if key == "uuid:ed799d86-4fb6-4267-9dc6-92d03e222108"
replace legumineuses_05_3 = 600 if key == "uuid:92a20142-025d-44aa-91a4-1c1c4fc151a9"
replace legumineuses_05_3 = 500 if key == "uuid:29b6669e-8082-419f-b5f9-d7047c4504b4"
replace legumineuses_05_3 = 500 if key == "uuid:924ae568-e479-4dc0-9311-dd77acb165c1"
replace legumineuses_05_3 = 500 if key == "uuid:7b44e820-4a74-4f8e-b21d-edbc2eed548c"
replace legumineuses_05_3 = 500 if key == "uuid:568408fd-6ada-4251-80f8-23d8b1258708"
replace legumineuses_05_3 = 600 if key == "uuid:d7cf7d20-89ae-405c-af0f-c9f04d222f68"
replace legumineuses_05_3 = 600 if key == "uuid:74905d28-c72d-47f2-9e44-11941fb2d3d4"
replace legumineuses_05_3 = 600 if key == "uuid:ded54860-db67-4e1a-a05c-19603fb0ed65"
replace legumineuses_05_3 = 500 if key == "uuid:9b8df772-b6cb-4e9a-9694-d5773d97fac5"
replace legumineuses_05_3 = 500 if key == "uuid:17d10f64-73a3-47f9-b5cc-d3181be64f21"
replace legumineuses_05_3 = 500 if key == "uuid:9774e27c-e111-4b39-ad7c-13f19c44e2b1"
replace legumineuses_05_1 = 500 if key == "uuid:45e97396-5ee5-4b55-ac86-cbd4824e8263"
replace legumineuses_05_1 = 500 if key == "uuid:89b3e895-dcd6-4d18-a3f9-fd0910260ae6"
replace legumineuses_05_1 = 500 if key == "uuid:85c3253f-8039-4374-b28f-b9a389c51b66"
replace legumineuses_05_1 = 500 if key == "uuid:b469f9f5-c7f1-4de9-baee-d796aa0b9a12"
replace legumineuses_05_1 = 500 if key == "uuid:8c9013e8-7c41-44ce-8f0a-c1e4b4aa45a8"
replace legumineuses_05_1 = 500 if key == "uuid:214b4d71-afe8-4c2f-877d-a528a1719e19"
replace legumineuses_05_1 = 500 if key == "uuid:83924b21-7f4e-40fd-b878-85a52d33f657"
replace legumineuses_05_1 = 600 if key == "uuid:ed799d86-4fb6-4267-9dc6-92d03e222108"
replace legumineuses_05_1 = 600 if key == "uuid:12c25f1c-dfa1-4230-8e5f-a61dccc9d7b3"
replace legumineuses_05_1 = 600 if key == "uuid:92a20142-025d-44aa-91a4-1c1c4fc151a9"
replace legumineuses_05_1 = 600 if key == "uuid:6ec0c2ce-ca73-4779-8cad-105a844f6479"
replace legumineuses_05_1 = 600 if key == "uuid:94b49199-2c67-400c-8307-6e8313b8f2c3"
replace legumineuses_05_1 = 600 if key == "uuid:d7cf7d20-89ae-405c-af0f-c9f04d222f68"
replace legumineuses_05_1 = 500 if key == "uuid:9774e27c-e111-4b39-ad7c-13f19c44e2b1"
replace legumineuses_05_1 = 600 if key == "uuid:94a38643-7c8f-4e15-a9a0-27858a06c18d"
replace legumes_02_3 = 17500 if key == "uuid:9774e27c-e111-4b39-ad7c-13f19c44e2b1"
replace legumes_02_1 = 12500 if key == "uuid:9774e27c-e111-4b39-ad7c-13f19c44e2b1"
replace hh_education_level_6 = 3 if key == "uuid:c5a9ad94-512d-4d5e-86be-32bbaea376a8"
replace hh_education_level_5 = 3 if key == "uuid:924ae568-e479-4dc0-9311-dd77acb165c1"
replace hh_education_level_13 = 3 if key == "uuid:c5a9ad94-512d-4d5e-86be-32bbaea376a8"
replace hh_age_resp = 53 if key == "uuid:8c9013e8-7c41-44ce-8f0a-c1e4b4aa45a8"
replace age_5 = 91 if key == "uuid:c5be1602-4373-4562-8647-30703fddb2d2"
replace hh_41_1 = 6 if key == "uuid:45e97396-5ee5-4b55-ac86-cbd4824e8263"
replace hh_14_b_10 = 6 if key == "uuid:9774e27c-e111-4b39-ad7c-13f19c44e2b1"
replace hh_14_b_1 = 5 if key == "uuid:4cfa8fad-9dae-44cd-9e79-1dd479afc34c"
replace cereals_02_1 = 10500 if key == "uuid:92a20142-025d-44aa-91a4-1c1c4fc151a9"
replace cereals_02_1 = 18400 if key == "uuid:568408fd-6ada-4251-80f8-23d8b1258708"
replace cereals_02_1 = 12000 if key == "uuid:104f7dff-68f2-4bbd-a2d6-da22b7b72754"
replace cereals_02_1 = 24000 if key == "uuid:2bf20bdc-4cf8-407c-b399-cd9a35efd6ba"
replace cereals_02_1 = 25000 if key == "uuid:22c42af0-ec97-4fc3-80f5-94d3a684eff8"
replace agri_income_23_2 = -9 if key == "uuid:ebb30e88-28c3-475e-9280-687cff7de2dc"
replace agri_income_23_2 = -9 if key == "uuid:920076db-929a-4cd7-9cd9-62e37f877a5c"
replace agri_income_23_2 = -9 if key == "uuid:63404b01-6729-4607-9f41-3e8b9153b9ee"
replace agri_income_23_1 = -9 if key == "uuid:85c3253f-8039-4374-b28f-b9a389c51b66"
replace agri_income_23_1 = -9 if key == "uuid:8e7bd22b-c4fc-43d1-a4c2-dc797a036e43"
replace agri_income_23_1 = -9 if key == "uuid:ebb30e88-28c3-475e-9280-687cff7de2dc"
replace agri_income_23_1 = -9 if key == "uuid:a5be4dc8-b7e6-428a-a5c2-15ca12079878"
replace agri_income_10_1 = 175000 if key == "uuid:a479209e-ee83-47d1-8c0a-ad5927a5d791"
replace agri_income_10_1 = 180000 if key == "uuid:2dbd6e4f-235c-4d72-b91e-62a5c60c2717"
replace agri_income_10_1 = 180000 if key == "uuid:92a20142-025d-44aa-91a4-1c1c4fc151a9"
replace agri_income_05 = -9 if key == "uuid:10ce019a-2990-430a-a81b-7c308a4c7bad"
replace agri_6_28_1 = 0 if key == "uuid:a479209e-ee83-47d1-8c0a-ad5927a5d791"
replace legumineuses_05_3 = 300 if key == "uuid:70b5c2c4-6ddb-4def-ab2a-b4b359a13405"
replace legumineuses_05_3 = 300 if key == "uuid:8e35949e-333d-41de-85e7-805cb4ae4735"
replace legumineuses_05_3 = 300 if key == "uuid:4bc5796a-8221-40ca-94c9-0b9dd1864eb8"
replace legumineuses_05_3 = 300 if key == "uuid:bf9cdfa4-4433-4b78-965c-e83f86b94772"
replace legumineuses_05_3 = 300 if key == "uuid:cf3c651b-3763-4c97-88eb-1da111d56677"
replace legumineuses_05_3 = 300 if key == "uuid:5e9bda67-4df1-4c5d-a106-5aa581fd32f3"
replace legumineuses_05_3 = 300 if key == "uuid:1b5acef1-09c9-4be9-ad74-366a633b2c73"
replace legumineuses_05_3 = 300 if key == "uuid:22a1d3e3-3607-45a4-b92e-7f989af4adf6"
replace legumineuses_05_1 = 300 if key == "uuid:14d5db3b-b609-433b-af04-430129d7a128"
replace legumineuses_05_1 = 300 if key == "uuid:cf3c651b-3763-4c97-88eb-1da111d56677"
replace legumineuses_05_1 = 300 if key == "uuid:27abdb48-c617-41c5-99d6-27c3fbe46330"
replace legumineuses_05_1 = 300 if key == "uuid:efae05c3-3a25-4842-af31-915de9cd187e"
replace legumineuses_04_1 = 2000 if key == "uuid:09622dd4-4613-46e3-939b-c3a43a585bb5"
replace legumes_05_3 = 600 if key == "uuid:1b5acef1-09c9-4be9-ad74-366a633b2c73"
replace legumes_05_3 = 600 if key == "uuid:22a1d3e3-3607-45a4-b92e-7f989af4adf6"
replace hh_phone = 775681982 if key == "uuid:7c9ed2c3-473c-4558-b887-3549340d10d2"
replace hh_phone = 774078721 if key == "uuid:347b10a5-29e2-4221-9079-08b5d95c139b"
replace hh_education_level_3 = 1 if key == "uuid:e27a987c-199d-4435-9888-71d4f1a0fb69"
replace farines_05_4 = 300 if key == "uuid:8906bfb9-1397-48b5-a2c8-ad8c6a8d05d4"
replace farines_05_4 = 300 if key == "uuid:a4402ec7-4feb-48e1-958c-e58af2695a91"
replace farines_05_4 = 300 if key == "uuid:3f50a371-1256-4562-a655-945198622f86"
replace farines_05_4 = 300 if key == "uuid:5af3703a-9fbb-417b-9462-88d93d4254f2"
replace farines_05_2 = 300 if key == "uuid:ab7d5d15-0083-4d38-8abb-bb1b924d1b88"
replace farines_05_2 = 300 if key == "uuid:e27a987c-199d-4435-9888-71d4f1a0fb69"
replace farines_04_2 = 300 if key == "uuid:fd94c62f-d24e-4222-b8cf-061f7311c9f0"
replace cereals_05_1 = 300 if key == "uuid:273ef459-4a4b-421f-b45f-5938f44138fb"
replace cereals_05_1 = 300 if key == "uuid:ab7d5d15-0083-4d38-8abb-bb1b924d1b88"
replace cereals_05_1 = 300 if key == "uuid:8bc2c8fe-0e98-4b50-9db9-ba66521af34d"
replace cereals_05_1 = 300 if key == "uuid:7c9ed2c3-473c-4558-b887-3549340d10d2"
replace cereals_05_1 = 300 if key == "uuid:347b10a5-29e2-4221-9079-08b5d95c139b"
replace cereals_05_1 = 300 if key == "uuid:5280aabf-8b4f-416e-84b9-5b78d5382352"
replace cereals_05_1 = 300 if key == "uuid:94643380-9b5b-4ec2-ac9c-a3fd30a51af7"
replace cereals_05_1 = 300 if key == "uuid:82b29ac5-2558-4aa3-a780-b48b45483422"
replace cereals_05_1 = 300 if key == "uuid:5bde4af2-d8dc-4fae-8884-fc042a5d12a6"
replace cereals_05_1 = 300 if key == "uuid:1a323a88-f1d7-4a74-b448-7ce2d7858fa4"
replace cereals_05_1 = 300 if key == "uuid:1c2ad303-cb84-4bf8-a5cf-f5d38b1ee77c"
replace cereals_05_1 = 300 if key == "uuid:d9316492-141c-491b-987f-4d79982aac32"
replace cereals_05_1 = 300 if key == "uuid:e1f57db1-c71f-4b6b-8e34-e79a83b811e1"
replace cereals_05_1 = 300 if key == "uuid:e3feb380-8bda-4ba7-aa4d-f8cf60bade90"
replace cereals_05_1 = 300 if key == "uuid:7d6f6d9d-c257-4195-8a67-0aecd4e1b233"
replace cereals_05_1 = 300 if key == "uuid:7d9f8b44-84f1-4118-b829-ec224829dc78"
replace cereals_05_1 = 300 if key == "uuid:cf7580cb-13e6-4b55-9893-3d6a6e4e82b4"
replace cereals_05_1 = 300 if key == "uuid:d5f48d8a-650d-40bc-b6ad-a365623fda48"
replace cereals_05_1 = 300 if key == "uuid:3836b5eb-ccd2-4c6b-bd5f-bf42d09c166c"
replace cereals_05_1 = 300 if key == "uuid:d7d885fe-9a4f-4a10-8991-80d5fd4dd3f9"
replace cereals_05_1 = 300 if key == "uuid:155e4011-7e23-4a13-9190-c8859bb3641f"
replace cereals_05_1 = 300 if key == "uuid:1b5acef1-09c9-4be9-ad74-366a633b2c73"
replace cereals_05_1 = 300 if key == "uuid:bd5809d6-cf3f-4953-84dd-55dde87227f5"
replace cereals_05_1 = 300 if key == "uuid:43ae1419-58d1-452c-8dae-d6a5914fddf7"
replace cereals_05_1 = 300 if key == "uuid:742d4881-da1e-4e85-9270-0c5bd07d1b00"
replace cereals_05_1 = 300 if key == "uuid:72625c8e-580a-478f-9989-882ad5867012"
replace cereals_02_1 = 200 if key == "uuid:742d4881-da1e-4e85-9270-0c5bd07d1b00"
replace agri_6_38_a_code_1 = 1 if key == "uuid:5af0d03f-adee-40c6-837f-cd2d839cfcff"
replace agri_6_28_4 = 0 if key == "uuid:3836b5eb-ccd2-4c6b-bd5f-bf42d09c166c"
replace agri_6_28_3 = 0 if key == "uuid:ab7d5d15-0083-4d38-8abb-bb1b924d1b88"
replace agri_6_28_2 = 0 if key == "uuid:ab7d5d15-0083-4d38-8abb-bb1b924d1b88"
replace agri_6_28_1 = 0 if key == "uuid:66c5212c-4c95-449d-8b44-96cc0a244c24"
replace agri_6_28_1 = 0 if key == "uuid:1adf0b30-b0d7-43a6-80f0-00d0a412a197"
replace agri_6_28_1 = 0 if key == "uuid:ab7d5d15-0083-4d38-8abb-bb1b924d1b88"
replace agri_6_28_1 = 0 if key == "uuid:347b10a5-29e2-4221-9079-08b5d95c139b"
replace agri_6_28_1 = 0 if key == "uuid:1a323a88-f1d7-4a74-b448-7ce2d7858fa4"
replace agri_6_28_1 = 0 if key == "uuid:3836b5eb-ccd2-4c6b-bd5f-bf42d09c166c"
replace agri_6_28_1 = 0 if key == "uuid:fd94c62f-d24e-4222-b8cf-061f7311c9f0"
replace legumineuses_05_5 = 300 if key == "uuid:6f5c7dd9-384b-4da2-a470-ac268b4a0955"
replace legumineuses_05_5 = 300 if key == "uuid:d1e7dbf6-ad88-454b-b33e-118dac73265d"
replace legumineuses_05_3 = 300 if key == "uuid:54534f23-70f0-4cab-84c5-d1dd93489fdf"
replace legumineuses_05_3 = 300 if key == "uuid:081d8522-c607-4fa4-8a13-568ab0f5464b"
replace legumineuses_05_3 = 300 if key == "uuid:b9348d87-285c-4b74-bfcc-4ec54fbcaef2"
replace legumineuses_05_3 = 300 if key == "uuid:cd38b352-7293-4c7e-abc7-398817518415"
replace legumineuses_05_3 = 300 if key == "uuid:b7f22d65-4b4f-445b-9826-891455b4c258"
replace legumineuses_05_3 = 300 if key == "uuid:6133e860-70a5-4ea2-87a9-b87d1869de3d"
replace legumineuses_05_3 = 300 if key == "uuid:f8570de1-84f3-4c5e-b2e3-c17116a88dec"
replace legumineuses_05_3 = 300 if key == "uuid:1c6e9164-a428-468b-bf2a-5632df915e4b"
replace legumineuses_05_3 = 300 if key == "uuid:cef0290b-0307-4a8f-b3e3-ff6289d5b070"
replace legumineuses_05_3 = 300 if key == "uuid:20178046-4b11-4ce9-91a4-1e0e4c6d8a82"
replace legumineuses_05_3 = 300 if key == "uuid:5427dc3b-1698-445e-be9f-e79696fbe0f0"
replace legumineuses_05_3 = 300 if key == "uuid:9e359213-fd3b-4c80-9224-69550bc5f954"
replace legumineuses_05_3 = 300 if key == "uuid:d426f9a0-b2f0-4d94-b8e3-9801b0aaded1"
replace legumineuses_05_3 = 300 if key == "uuid:6a4ea1d4-0c0e-4488-8724-39baf98fdcb1"
replace legumineuses_05_3 = 300 if key == "uuid:b7b8e610-6c06-4d03-83e5-3c0db27f27f9"
replace legumineuses_05_3 = 300 if key == "uuid:05442505-66f5-4640-8f5a-fa86f34dbd12"
replace legumineuses_05_3 = 300 if key == "uuid:9720736a-8c2e-48e3-9027-f84cb580e1fe"
replace legumineuses_05_3 = 300 if key == "uuid:aa66233f-4955-47fc-beb9-242d22e341b7"
replace legumineuses_05_3 = 300 if key == "uuid:5a8693ab-5a5d-414d-b820-9756c978ca26"
replace legumineuses_05_3 = 300 if key == "uuid:63ccc157-d87a-4cd1-8c48-f8c499c32a7d"
replace legumineuses_05_3 = 300 if key == "uuid:c331d91c-58b9-4068-b542-a1861628d96b"
replace legumineuses_05_3 = 300 if key == "uuid:a6ce1e06-925e-47ad-9781-af747ba1f4cc"
replace legumineuses_05_3 = 300 if key == "uuid:8dbf2f83-4aba-43e0-b4d1-a1160492b6ee"
replace legumineuses_05_3 = 300 if key == "uuid:d76a46b9-c2d8-4ba4-904c-c7caf7c39787"
replace legumineuses_05_3 = 300 if key == "uuid:7d6ff869-5e43-4321-8ca4-d88820f41195"
replace legumineuses_05_3 = 300 if key == "uuid:216ebb08-a2a9-4d09-8979-04f88d70617b"
replace legumineuses_05_3 = 300 if key == "uuid:3d4f6649-d0b1-46a5-afa1-70ff40b86096"
replace legumineuses_05_3 = 300 if key == "uuid:f0d062cd-957e-4375-8a2f-41f4b30a0fb5"
replace legumineuses_05_3 = 300 if key == "uuid:4fca7dad-4570-4a38-9d91-98a960144baa"
replace legumineuses_05_2 = 300 if key == "uuid:f3560651-f1e7-4183-bb24-e5fb2bb4b530"
replace legumineuses_05_1 = 300 if key == "uuid:f22d73d4-c964-43e2-b0f8-0b7af4a740cc"
replace legumineuses_05_1 = 300 if key == "uuid:c73dc6fd-a708-4c20-aa7e-ea54fe1eba30"
replace legumineuses_05_1 = 300 if key == "uuid:c78b22ea-581a-442c-8574-191fc0ed040c"
replace legumineuses_05_1 = 300 if key == "uuid:6df53ce5-e7c4-4241-af8d-91dad666fa20"
replace legumineuses_05_1 = 300 if key == "uuid:54534f23-70f0-4cab-84c5-d1dd93489fdf"
replace legumineuses_05_1 = 300 if key == "uuid:959359a0-9d8c-4293-92ae-551585292652"
replace legumineuses_05_1 = 300 if key == "uuid:beb716ab-e43c-4e16-80c0-873722167cf7"
replace legumineuses_05_1 = 300 if key == "uuid:5e72ce0f-a07d-4bcd-8618-d32576e05c8b"
replace legumineuses_05_1 = 300 if key == "uuid:340107c5-0475-4534-987f-e832e89a582e"
replace legumineuses_05_1 = 300 if key == "uuid:216ebb08-a2a9-4d09-8979-04f88d70617b"
replace legumineuses_05_1 = 300 if key == "uuid:544b9ce9-1148-4de4-8682-e7a053bc55f6"
replace legumineuses_05_1 = 300 if key == "uuid:2dc17631-28de-444c-9bfc-c72efb9e0a75"
replace legumes_04_1 = 2500 if key == "uuid:216ebb08-a2a9-4d09-8979-04f88d70617b"
replace legumes_02_3 = -9 if key == "uuid:b9348d87-285c-4b74-bfcc-4ec54fbcaef2"
replace legumes_02_3 = -9 if key == "uuid:b7f22d65-4b4f-445b-9826-891455b4c258"
replace legumes_02_3 = -9 if key == "uuid:6133e860-70a5-4ea2-87a9-b87d1869de3d"
replace legumes_02_3 = -9 if key == "uuid:f8570de1-84f3-4c5e-b2e3-c17116a88dec"
replace legumes_02_3 = -9 if key == "uuid:aa66233f-4955-47fc-beb9-242d22e341b7"
replace legumes_02_3 = -9 if key == "uuid:216ebb08-a2a9-4d09-8979-04f88d70617b"
replace legumes_02_3 = -9 if key == "uuid:3d4f6649-d0b1-46a5-afa1-70ff40b86096"
replace legumes_02_1 = 36000 if key == "uuid:f22d73d4-c964-43e2-b0f8-0b7af4a740cc"
replace legumes_02_1 = 16510 if key == "uuid:5e72ce0f-a07d-4bcd-8618-d32576e05c8b"
replace legumes_02_1 = 23608 if key == "uuid:340107c5-0475-4534-987f-e832e89a582e"
replace legumes_02_1 = 16200 if key == "uuid:2dc17631-28de-444c-9bfc-c72efb9e0a75"
replace hh_education_level_4 = 4 if key == "uuid:544b9ce9-1148-4de4-8682-e7a053bc55f6"
replace hh_age_resp = 67 if key == "uuid:b953b4d4-81de-4589-8091-b1efbf0849f0"
replace hh_age_resp = 55 if key == "uuid:9720736a-8c2e-48e3-9027-f84cb580e1fe"
replace hh_41_8 = 7 if key == "uuid:05442505-66f5-4640-8f5a-fa86f34dbd12"
replace hh_41_2 = 7 if key == "uuid:34d8c58a-a617-487a-b010-93ea0b8dc111"
replace hh_12_o_1 = "Traverser" if key == "uuid:beb716ab-e43c-4e16-80c0-873722167cf7"
replace health_5_12_11 = -9 if key == "uuid:dc3b1411-5680-4df5-a72d-001ff41a8864"
replace health_5_12_5 = -9 if key == "uuid:dc3b1411-5680-4df5-a72d-001ff41a8864"
replace health_5_12_8 = -9 if key == "uuid:dc3b1411-5680-4df5-a72d-001ff41a8864"
replace health_5_12_11 = -9 if key == "uuid:dc3b1411-5680-4df5-a72d-001ff41a8864"
replace health_5_12_5 = -9 if key == "uuid:dc3b1411-5680-4df5-a72d-001ff41a8864"
replace health_5_12_8 = -9 if key == "uuid:dc3b1411-5680-4df5-a72d-001ff41a8864"
replace farines_02_2 = 45290 if key == "uuid:b23d6c34-7e39-4cb2-a08f-4e4731c59360"
replace farines_02_1 = 5000 if key == "uuid:081d8522-c607-4fa4-8a13-568ab0f5464b"
replace farines_02_1 = 5600 if key == "uuid:b23d6c34-7e39-4cb2-a08f-4e4731c59360"
replace correct_hh = 1 if key == "uuid:338d1760-bfa2-46fd-9368-469f727d9cef"
replace correct_hh = 1 if key == "uuid:7d6ff869-5e43-4321-8ca4-d88820f41195"
replace cereals_03_1 = 1926 if key == "uuid:f0d062cd-957e-4375-8a2f-41f4b30a0fb5"
replace cereals_02_1 = 16000 if key == "uuid:b99d9512-c46b-48a5-a08f-00db51351c27"
replace cereals_02_1 = 11360 if key == "uuid:338d1760-bfa2-46fd-9368-469f727d9cef"
replace cereals_02_1 = 22400 if key == "uuid:2d35da93-7a0e-4d12-b958-2ff8f42b52a9"
replace cereals_02_1 = 15500 if key == "uuid:5e72ce0f-a07d-4bcd-8618-d32576e05c8b"
replace cereals_02_1 = 19800 if key == "uuid:340107c5-0475-4534-987f-e832e89a582e"
replace agri_income_45_5 = -9 if key == "uuid:f2652d13-6956-4a7e-879b-99bf73b286ac"
replace agri_income_11_1 = 1 if key == "uuid:216ebb08-a2a9-4d09-8979-04f88d70617b"
replace agri_income_06 = -9 if key == "uuid:14173965-524c-42ed-881d-7ba303969f5f"
replace agri_income_06 = -9 if key == "uuid:0b37d7f9-43b1-4a23-b3f0-b41470b1fc34"
replace agri_income_03 = 12 if key == "uuid:3c3b579a-f6e1-43d8-8b41-2f3c0d88225c"
replace agri_6_40_a_code_2 = 1 if key == "uuid:5a8693ab-5a5d-414d-b820-9756c978ca26"
replace agri_6_40_a_code_2 = 1 if key == "uuid:4fca7dad-4570-4a38-9d91-98a960144baa"
replace agri_6_40_a_code_1 = 1 if key == "uuid:a5237b9a-5cd3-4b46-90c7-2551f4a43cef"
replace agri_6_40_a_code_1 = 1 if key == "uuid:7d6ff869-5e43-4321-8ca4-d88820f41195"
replace agri_6_40_a_2 = 0 if key == "uuid:4fca7dad-4570-4a38-9d91-98a960144baa"
replace agri_6_40_a_1 = 0 if key == "uuid:a5237b9a-5cd3-4b46-90c7-2551f4a43cef"
replace agri_6_39_a_code_2 = 1 if key == "uuid:4fca7dad-4570-4a38-9d91-98a960144baa"
replace agri_6_39_a_code_1 = 1 if key == "uuid:ef2a9e2d-15a8-4b34-b9ea-17a240b1d2de"
replace agri_6_39_a_2 = 0 if key == "uuid:4fca7dad-4570-4a38-9d91-98a960144baa"
replace agri_6_38_a_code_1 = 1 if key == "uuid:a5237b9a-5cd3-4b46-90c7-2551f4a43cef"
replace agri_6_38_a_1 = 100 if key == "uuid:a5237b9a-5cd3-4b46-90c7-2551f4a43cef"
replace agri_6_38_a_1 = 500 if key == "uuid:b23d6c34-7e39-4cb2-a08f-4e4731c59360"
replace o_culture_01 = 1 if key == "uuid:e90910c8-d7ed-4f21-b69b-d9e47766adcf"
replace legumineuses_05_4 = 350 if key == "uuid:b66b0159-426b-41be-af40-5d9f2ef3c0e4"
replace legumineuses_05_3 = 350 if key == "uuid:5cdbeb2d-f857-4604-bd8e-a8c71598c780"
replace legumineuses_05_3 = 350 if key == "uuid:b28e71ed-1dad-4dba-82f6-cc301eba04e3"
replace legumes_05_4 = 200 if key == "uuid:b66b0159-426b-41be-af40-5d9f2ef3c0e4"
replace hh_age_resp = 19 if key == "uuid:a0da06c7-4f16-44ab-b40a-c8fe75daf322"
replace age_8 = 42 if key == "uuid:fee681c7-c6ad-45f1-bde9-ba984247d1a4"
replace hh_41_6 = 7 if key == "uuid:fa6b632a-58f0-4bc1-a921-5abb0680d79e"
replace hh_41_5 = 7 if key == "uuid:6d59bac1-ae47-4d19-ae80-294dbf82865c"
replace hh_41_5 = 5 if key == "uuid:3b9fe083-0a4e-4db1-8c63-b494c53d403a"
replace hh_41_4 = 7 if key == "uuid:464e7c98-71a8-4774-a1db-820c4ca30c91"
replace hh_41_4 = 7 if key == "uuid:e2b253d2-9e6d-44f3-8916-4797bf2f8177"
replace hh_41_4 = 5 if key == "uuid:df66612e-0d16-4894-88d5-33580308ec91"
replace hh_41_3 = 7 if key == "uuid:6ad3f4d8-0bc2-43c2-b6d8-3fb8114647f8"
replace hh_41_22 = 7 if key == "uuid:fa6b632a-58f0-4bc1-a921-5abb0680d79e"
replace hh_41_2 = 6 if key == "uuid:272f19bb-809d-43d4-bae9-d3bcfb6ac22b"
replace hh_41_10 = 7 if key == "uuid:f0c88bdb-6402-4d30-9bac-69dbd3c847b2"
replace hh_41_1 = 10 if key == "uuid:9559913d-fb26-4d88-a5f2-27f2142af0ee"
replace cereals_05_3 = 300 if key == "uuid:63a429a2-c4af-4377-9060-8489190a5491"
replace cereals_05_1 = 275 if key == "uuid:b66b0159-426b-41be-af40-5d9f2ef3c0e4"
replace cereals_05_1 = 275 if key == "uuid:054febe7-fddd-4b28-bc8b-21b036034c24"
replace cereals_05_1 = -9 if key == "uuid:1ad4d263-f735-4d5b-898e-8449a23cbb09"
replace cereals_04_1 = 2800 if key == "uuid:78d77a89-36f7-4c0f-8fef-22644a8e9c73"
replace cereals_04_1 = 75 if key == "uuid:43aaed55-2d1c-45d6-913b-22726c7a9a26"
replace cereals_04_1 = 3000 if key == "uuid:9c942a3d-fa44-4758-b268-c040b2ff1248"
replace cereals_04_1 = 1000 if key == "uuid:705814d9-cf74-46eb-a1fd-38a61fde156b"
replace cereals_04_1 = 300 if key == "uuid:d3a0cf7d-87a7-4373-8b0a-a4a50df9cfa2"
replace cereals_03_3 = 800 if key == "uuid:b508a3ab-9afd-4b4d-ae57-9b3b9c7214de"
replace cereals_03_3 = 250 if key == "uuid:27733143-0061-401d-840a-10ef22c379b5"
replace cereals_03_1 = 750 if key == "uuid:98f1dac6-2c36-4dc8-871e-f1789e107d6a"
replace cereals_03_1 = 500 if key == "uuid:a1261fd4-5c99-4e06-91c4-ac1072db7e5e"
replace cereals_03_1 = 425 if key == "uuid:cc130465-b8d1-42da-929f-318c258f73e4"
replace cereals_03_1 = 5600 if key == "uuid:78d77a89-36f7-4c0f-8fef-22644a8e9c73"
replace cereals_03_1 = 700 if key == "uuid:ba158d3a-b1da-4b04-96c1-271049e9b4cb"
replace cereals_03_1 = 2000 if key == "uuid:6d59bac1-ae47-4d19-ae80-294dbf82865c"
replace cereals_03_1 = 800 if key == "uuid:844ab214-bd8f-4cfd-b13e-38ce3bba59a8"
replace cereals_03_1 = 750 if key == "uuid:43aaed55-2d1c-45d6-913b-22726c7a9a26"
replace cereals_03_1 = 100 if key == "uuid:1aafe562-4cb0-4a1f-b7e5-bd58f3386e6e"
replace cereals_03_1 = 3000 if key == "uuid:9c942a3d-fa44-4758-b268-c040b2ff1248"
replace cereals_03_1 = 3500 if key == "uuid:705814d9-cf74-46eb-a1fd-38a61fde156b"
replace cereals_03_1 = 1000 if key == "uuid:1ad4d263-f735-4d5b-898e-8449a23cbb09"
replace cereals_03_1 = 800 if key == "uuid:d3a0cf7d-87a7-4373-8b0a-a4a50df9cfa2"
replace cereals_03_1 = 420 if key == "uuid:a2b50444-1316-4e2d-b47c-b3cbb7b7e46e"
replace cereals_03_1 = 500 if key == "uuid:f9ca4556-2c20-499a-b7fb-03eb3be07b5d"
replace cereals_01_3 = 1 if key == "uuid:b508a3ab-9afd-4b4d-ae57-9b3b9c7214de"
replace cereals_01_1 = 1 if key == "uuid:002674f4-6ea0-4f36-9a11-79038e40bbc2"
replace agri_income_47_1 = -9 if key == "uuid:a1261fd4-5c99-4e06-91c4-ac1072db7e5e"
replace agri_income_47_1 = -9 if key == "uuid:446cce08-7cc4-44c1-be46-e651f216e5bc"
replace agri_income_45_3 = -9 if key == "uuid:002674f4-6ea0-4f36-9a11-79038e40bbc2"
replace agri_income_45_2 = -9 if key == "uuid:002674f4-6ea0-4f36-9a11-79038e40bbc2"
replace agri_income_36_1 = 200000 if key == "uuid:b66b0159-426b-41be-af40-5d9f2ef3c0e4"
replace agri_income_19 = -9 if key == "uuid:8895114d-827e-44d2-93c6-949d4c3c0ebe"
replace agri_income_10_2 = -9 if key == "uuid:446cce08-7cc4-44c1-be46-e651f216e5bc"
replace agri_income_08_3 = -9 if key == "uuid:fa6b632a-58f0-4bc1-a921-5abb0680d79e"
replace agri_income_08_2 = -9 if key == "uuid:fa6b632a-58f0-4bc1-a921-5abb0680d79e"
replace agri_income_06 = -9 if key == "uuid:b66b0159-426b-41be-af40-5d9f2ef3c0e4"
replace agri_income_05 = -9 if key == "uuid:b66b0159-426b-41be-af40-5d9f2ef3c0e4"
replace agri_income_05 = -9 if key == "uuid:8895114d-827e-44d2-93c6-949d4c3c0ebe"
replace o_culture_04 = 400 if key == "uuid:20bb7007-297f-432d-8909-7bea1973059d"
replace legumineuses_05_5 = 500 if key == "uuid:287da5df-7188-40b8-bb38-e3f2c1d1ec95"
replace legumineuses_05_4 = 500 if key == "uuid:287da5df-7188-40b8-bb38-e3f2c1d1ec95"
replace legumineuses_05_4 = 500 if key == "uuid:7f6eb93d-c0f1-4c63-b7fe-3162bfeb6167"
replace legumineuses_05_4 = 500 if key == "uuid:f9b7b3d0-54e8-498a-ba18-cfef2a378726"
replace legumineuses_05_3 = 500 if key == "uuid:1e9da38f-f800-4f19-93ac-73bbf37def32"
replace legumineuses_05_3 = 500 if key == "uuid:56373e8c-7e9f-4c91-a294-8b4955cf2e76"
replace legumineuses_05_3 = 600 if key == "uuid:3b860b05-1279-4807-9ebb-cccdf410537f"
replace legumineuses_05_3 = 500 if key == "uuid:1ea39869-8a62-4ec1-a14b-6626a7c54525"
replace legumineuses_05_3 = 500 if key == "uuid:b4648e61-1839-42d1-9890-4069ccce8a97"
replace legumineuses_05_3 = 500 if key == "uuid:6aed25d4-b44d-4a4a-95db-cb4659ba83f7"
replace legumineuses_05_3 = 500 if key == "uuid:53f9620b-0bad-4850-8858-daef5ca40bb1"
replace legumineuses_05_3 = 500 if key == "uuid:f2db2869-ae1b-4249-af4d-c0aca906f0ba"
replace legumineuses_05_1 = 500 if key == "uuid:e2eb6ce7-c2dd-43be-9557-002c201d07a0"
replace legumineuses_05_1 = 500 if key == "uuid:b7d87bca-fbbb-436b-a34c-f056a36e6643"
replace legumineuses_05_1 = 500 if key == "uuid:ce7d41d9-bce1-4508-a02f-abf2b1b3185d"
replace legumineuses_05_1 = 500 if key == "uuid:4270a5d1-35b0-41c6-8a3c-5818d56a3756"
replace legumineuses_05_1 = 500 if key == "uuid:f9b7b3d0-54e8-498a-ba18-cfef2a378726"
replace legumineuses_05_1 = 500 if key == "uuid:df24e4e3-feeb-4e95-9620-4a934bf62470"
replace legumineuses_04_1 = 9500 if key == "uuid:3b860b05-1279-4807-9ebb-cccdf410537f"
replace legumineuses_02_2 = 6000 if key == "uuid:4b52bd3c-2ffb-4005-b666-82b3e11ed237"
replace legumineuses_02_1 = 16000 if key == "uuid:0b333cd2-bec2-4b5d-81c5-15186feebd5d"
replace legumineuses_02_1 = 16000 if key == "uuid:d5c7ff2b-5a98-48e6-ab1c-afdf20b145df"
replace legumineuses_01_1 = 1.3 if key == "uuid:107b2c30-a7a3-411b-9f75-1b279099a95b"
replace legumes_02_3 = 25000 if key == "uuid:b4648e61-1839-42d1-9890-4069ccce8a97"
replace legumes_02_1 = 25060 if key == "uuid:ce7d41d9-bce1-4508-a02f-abf2b1b3185d"
replace hh_age_resp = 24 if key == "uuid:c31590e7-0301-4527-b614-8fff4e96e147"
replace hh_age_resp = 41 if key == "uuid:0512fcb4-8a05-49c5-8718-121961e647af"
replace hh_age_resp = 44 if key == "uuid:ba2ff202-cbd1-4993-b0e8-098121069f93"
replace hh_41_8 = 7 if key == "uuid:d5c7ff2b-5a98-48e6-ab1c-afdf20b145df"
replace hh_14_b_8 = 2 if key == "uuid:eb71f1ee-5f44-4a52-926b-7db730824f49"
replace hh_14_b_8 = -9 if key == "uuid:20bb7007-297f-432d-8909-7bea1973059d"
replace hh_14_a_8 = -9 if key == "uuid:20bb7007-297f-432d-8909-7bea1973059d"
replace hh_14_a_2 = -9 if key == "uuid:3a65ea13-ff58-41d9-bdc8-988bba593355"
replace hh_14_a_2 = -9 if key == "uuid:5ed16c12-52c1-46e2-a6c4-8ad9c28cfbeb"
replace hh_14_a_13 = -9 if key == "uuid:eb71f1ee-5f44-4a52-926b-7db730824f49"
replace hh_14_a_1 = -9 if key == "uuid:4ea2408a-89a2-4bd4-8bac-9a8ebbffadd7"
replace health_5_12_7 = 0 if key == "uuid:53f9620b-0bad-4850-8858-daef5ca40bb1"
replace health_5_12_7 = 0 if key == "uuid:53f9620b-0bad-4850-8858-daef5ca40bb1"
replace farines_02_2 = 16000 if key == "uuid:c67f0cf6-6d27-4792-9c4b-7aa0e5d75360"
replace farines_02_2 = 24000 if key == "uuid:afbcea61-8389-4dcc-a18a-c3c3b5003b5e"
replace farines_02_2 = 20000 if key == "uuid:48f30fc0-4b45-4569-a86b-0f79df8b88b5"
replace farines_02_1 = 20000 if key == "uuid:3b860b05-1279-4807-9ebb-cccdf410537f"
replace farines_02_1 = 16000 if key == "uuid:b4648e61-1839-42d1-9890-4069ccce8a97"
replace farines_02_1 = 16000 if key == "uuid:0b333cd2-bec2-4b5d-81c5-15186feebd5d"
replace farines_02_1 = 24000 if key == "uuid:afbcea61-8389-4dcc-a18a-c3c3b5003b5e"
replace farines_02_1 = 12800 if key == "uuid:ea6616da-cd59-45c8-aaba-089a3f0510aa"
replace farines_02_1 = 16000 if key == "uuid:48f30fc0-4b45-4569-a86b-0f79df8b88b5"
replace farines_02_1 = 16000 if key == "uuid:961dde11-cb73-4697-899a-402fcdb81403"
replace cereals_05_1 = 400 if key == "uuid:aa31efb9-7412-4e3a-9439-0bb286420a63"
replace cereals_04_1 = 5900 if key == "uuid:ba2ff202-cbd1-4993-b0e8-098121069f93"
replace cereals_04_1 = 9500 if key == "uuid:3b860b05-1279-4807-9ebb-cccdf410537f"
replace cereals_03_1 = 300 if key == "uuid:1e9da38f-f800-4f19-93ac-73bbf37def32"
replace cereals_02_1 = 15000 if key == "uuid:5a624ab5-23e1-4f2f-8e58-6d18eb28b4f2"
replace cereals_02_1 = 14000 if key == "uuid:5405184a-72e2-45d3-9d4b-7de603a79851"
replace cereals_02_1 = 12000 if key == "uuid:7ae9095f-5f7c-4631-81e1-b41e9161fec1"
replace cereals_02_1 = 3500 if key == "uuid:4ea2408a-89a2-4bd4-8bac-9a8ebbffadd7"
replace cereals_02_1 = 3600 if key == "uuid:1ea39869-8a62-4ec1-a14b-6626a7c54525"
replace cereals_02_1 = 16000 if key == "uuid:b4648e61-1839-42d1-9890-4069ccce8a97"
replace cereals_02_1 = 6400 if key == "uuid:0ce826fc-1f7b-40f3-8390-21ac07dbe187"
replace cereals_02_1 = 15000 if key == "uuid:ae346c76-805d-4845-af88-e70c606d8389"
replace cereals_02_1 = 6400 if key == "uuid:567faff7-b009-4376-9928-fd68f3c38f91"
replace cereals_01_1 = 5 if key == "uuid:4ea2408a-89a2-4bd4-8bac-9a8ebbffadd7"
replace agri_income_21_f_1 = 0 if key == "uuid:84ab78c0-588f-4aa3-af68-85d18d1e7e15"
replace agri_income_06 = 0 if key == "uuid:1dc5d7c4-d93f-4e08-8d1a-0eb686d1c457"
replace agri_income_05 = 180000 if key == "uuid:1dc5d7c4-d93f-4e08-8d1a-0eb686d1c457"
replace agri_6_41_a_code_2 = 1 if key == "uuid:4a177d0c-0aa6-425b-b61e-29c832b35cd2"
replace agri_6_41_a_code_2 = 1 if key == "uuid:7ae9095f-5f7c-4631-81e1-b41e9161fec1"
replace agri_6_41_a_code_1 = 1 if key == "uuid:1e9da38f-f800-4f19-93ac-73bbf37def32"
replace agri_6_41_a_code_1 = 1 if key == "uuid:d956e550-a088-43b7-b422-7417e1341024"
replace agri_6_41_a_code_1 = 1 if key == "uuid:f9b7b3d0-54e8-498a-ba18-cfef2a378726"
replace agri_6_41_a_2 = 0 if key == "uuid:7ae9095f-5f7c-4631-81e1-b41e9161fec1"
replace agri_6_41_a_1 = 0 if key == "uuid:b4029e08-3cd6-49d0-95a9-beffe2fad125"
replace agri_6_41_a_1 = 0 if key == "uuid:d956e550-a088-43b7-b422-7417e1341024"
replace agri_6_40_a_code_4 = 1 if key == "uuid:df24e4e3-feeb-4e95-9620-4a934bf62470"
replace agri_6_40_a_code_3 = 1 if key == "uuid:3b860b05-1279-4807-9ebb-cccdf410537f"
replace agri_6_40_a_code_3 = 1 if key == "uuid:b4648e61-1839-42d1-9890-4069ccce8a97"
replace agri_6_40_a_code_3 = 1 if key == "uuid:b3edfb9f-1aa2-47ed-9e7a-2e89d9ad5707"
replace agri_6_40_a_code_3 = 1 if key == "uuid:f2db2869-ae1b-4249-af4d-c0aca906f0ba"
replace agri_6_40_a_code_2 = 1 if key == "uuid:7ae9095f-5f7c-4631-81e1-b41e9161fec1"
replace agri_6_40_a_code_2 = 1 if key == "uuid:6c45e7c7-b78a-413e-b1d1-efff3826e7f2"
replace agri_6_40_a_code_2 = 1 if key == "uuid:53f9620b-0bad-4850-8858-daef5ca40bb1"
replace agri_6_40_a_code_2 = 1 if key == "uuid:7f6eb93d-c0f1-4c63-b7fe-3162bfeb6167"
replace agri_6_40_a_code_1 = 1 if key == "uuid:62850217-368b-4562-a7ae-9af0cd2c2f73"
replace agri_6_40_a_code_1 = 1 if key == "uuid:4a177d0c-0aa6-425b-b61e-29c832b35cd2"
replace agri_6_40_a_code_1 = 1 if key == "uuid:b4029e08-3cd6-49d0-95a9-beffe2fad125"
replace agri_6_40_a_code_1 = 1 if key == "uuid:3284d8be-fa66-43fb-9c28-45896e1aaa70"
replace agri_6_40_a_3 = 0 if key == "uuid:f1529af7-6ab7-47ca-b054-61fe7f0c85b9"
replace agri_6_40_a_2 = 0 if key == "uuid:7ae9095f-5f7c-4631-81e1-b41e9161fec1"
replace agri_6_39_a_code_4 = 1 if key == "uuid:3b860b05-1279-4807-9ebb-cccdf410537f"
replace agri_6_39_a_code_2 = 1 if key == "uuid:0b186a7c-4544-4659-b1a9-2525c3425a57"
replace agri_6_39_a_4 = 0 if key == "uuid:3b860b05-1279-4807-9ebb-cccdf410537f"
replace agri_6_39_a_2 = 0 if key == "uuid:7ae9095f-5f7c-4631-81e1-b41e9161fec1"
replace agri_6_39_a_2 = 0 if key == "uuid:2bf58363-9ba1-412e-bb0a-7579bc601547"
replace agri_6_38_a_code_4 = 1 if key == "uuid:3b860b05-1279-4807-9ebb-cccdf410537f"
replace agri_6_38_a_code_3 = 1 if key == "uuid:4270a5d1-35b0-41c6-8a3c-5818d56a3756"
replace agri_6_38_a_code_2 = 1 if key == "uuid:a137313a-7bc1-4510-a7cc-367cd5242870"
replace agri_6_38_a_code_2 = 1 if key == "uuid:b3edfb9f-1aa2-47ed-9e7a-2e89d9ad5707"
replace agri_6_28_1 = 0 if key == "uuid:ae346c76-805d-4845-af88-e70c606d8389"
//replace o_culture_04 = Confirmer if key == "uuid:57dd6094-f7b5-43e7-9c80-108266eac06b"
//replace o_culture_02 = Confirmer if key == "uuid:b89a7ed1-e6ea-4835-8e6d-2e374b8d1cdb"
replace legumineuses_05_5 = 450 if key == "uuid:f74852e0-f784-45df-9ba6-40933da3b8d1"
replace legumineuses_05_5 = 450 if key == "uuid:95ab2e1d-999b-4548-bdb3-f2b43f8c8d43"
replace legumineuses_05_4 = 500 if key == "uuid:95ab2e1d-999b-4548-bdb3-f2b43f8c8d43"
replace legumineuses_05_3 = 600 if key == "uuid:8f411ac8-56f7-46b8-8af6-80c08b81e973"
replace legumineuses_05_3 = 450 if key == "uuid:b1fae32c-057b-45c3-a10b-5fbdf289d4d6"
replace legumineuses_05_3 = 450 if key == "uuid:c6fd24a7-b13c-406e-98d8-c3077804274d"
replace legumineuses_05_3 = 450 if key == "uuid:38e50014-cbb3-4ccf-a592-222277e3c778"
replace legumineuses_05_3 = 550 if key == "uuid:8f2f96ba-cb33-4481-b386-214bf00ad3e3"
replace legumineuses_05_3 = 600 if key == "uuid:18f82da1-ec44-4a27-aa91-dc3e5e255ab0"
replace legumineuses_05_3 = 600 if key == "uuid:b73837a1-ba69-4f48-9bab-f0edafc21571"
replace legumineuses_05_1 = 700 if key == "uuid:71a3b9e5-abc7-4e2c-94a3-006da861982b"
replace legumineuses_05_1 = 350 if key == "uuid:8f2f96ba-cb33-4481-b386-214bf00ad3e3"
replace legumineuses_02_1 = 400 if key == "uuid:e9086ca8-03e3-49fb-b7ca-01c40f858435"
replace legumes_04_6 = 1900 if key == "uuid:1df09cfd-b5f7-4fa5-8227-199fa261ae20"
replace hh_time = "-9" if key == "uuid:804194f1-f223-4619-b187-d197224402f6"
replace hh_time = "-9" if key == "uuid:c6fd24a7-b13c-406e-98d8-c3077804274d"
replace hh_time = "-9" if key == "uuid:8beba4f4-7066-4673-974d-d1e6ce1c202d"
replace hh_time = "-9" if key == "uuid:2a172b51-3cfd-4eae-aaed-d3cedbdaeb11"
replace hh_time = "-9" if key == "uuid:1df09cfd-b5f7-4fa5-8227-199fa261ae20"
replace hh_education_level_8 = 3 if key == "uuid:fe78ae3a-df95-4ba8-9205-133a78bb7675"
replace hh_education_level_5 = 3 if key == "uuid:63d42e02-d823-4062-97c5-479202f66254"
replace hh_41_5 = 7 if key == "uuid:41e60432-f713-4dd5-8c23-dce0e4f5116d"
replace correct_hh = 1 if key == "uuid:3e0bee12-5290-4b31-81c1-a42afc3d2926"
replace cereals_05_1 = 400 if key == "uuid:bbf5c02a-b6e2-4645-bae2-8854d894931f"
replace cereals_05_1 = 400 if key == "uuid:398fb50b-ed82-412f-948c-8c9b36a4d647"
replace cereals_04_6 = 8000 if key == "uuid:e9086ca8-03e3-49fb-b7ca-01c40f858435"
replace cereals_04_6 = 1400 if key == "uuid:43c5f3aa-5f3e-4087-98de-31d897566c82"
replace cereals_04_1 = 6000 if key == "uuid:ee6bb3fb-0c11-44c0-ab45-561b54edfcdc"
replace cereals_03_5 = 1000 if key == "uuid:ea66090c-4853-434a-8501-93e90526a596"
replace cereals_02_1 = 12000 if key == "uuid:e1cd6dc2-003a-44ab-8c0f-3dc63c59ba14"
replace cereals_02_1 = 15360 if key == "uuid:ee63debf-822a-411e-a0f2-d08e9eade8c3"
replace cereals_02_1 = 15200 if key == "uuid:b1fae32c-057b-45c3-a10b-5fbdf289d4d6"
replace cereals_02_1 = 14400 if key == "uuid:96923c86-ad11-4def-97ce-64a3089a78a1"
replace cereals_02_1 = 8000 if key == "uuid:e692401a-2af4-4a0f-9e12-1d7bb0856037"
replace cereals_02_1 = 11520 if key == "uuid:7bc76c9c-7953-4dc6-8f11-a7b27a31fb2e"
replace cereals_02_1 = 16000 if key == "uuid:92171a8f-7a48-4292-a5ef-6850b6c04333"
replace animals_sales_o = 0 if key == "uuid:8f411ac8-56f7-46b8-8af6-80c08b81e973"
replace animals_sales_o = 0 if key == "uuid:b89a7ed1-e6ea-4835-8e6d-2e374b8d1cdb"
replace agri_income_45_8 = -9 if key == "uuid:398fb50b-ed82-412f-948c-8c9b36a4d647"
replace agri_income_08_4 = 0 if key == "uuid:c6fd24a7-b13c-406e-98d8-c3077804274d"
replace agri_6_41_a_code_4 = 1 if key == "uuid:4c778d8f-97d4-47fa-af7d-7e3314c48feb"
replace agri_6_41_a_code_2 = 1 if key == "uuid:1df09cfd-b5f7-4fa5-8227-199fa261ae20"
replace agri_6_41_a_code_1 = 1 if key == "uuid:b23e5229-ac34-49c5-bb00-dc31eb3bd45a"
replace agri_6_41_a_code_1 = 1 if key == "uuid:92171a8f-7a48-4292-a5ef-6850b6c04333"
replace agri_6_41_a_code_1 = 1 if key == "uuid:c840f2ec-d0ec-4652-9e94-39ce87bad68a"
replace agri_6_41_a_4 = 0 if key == "uuid:4c778d8f-97d4-47fa-af7d-7e3314c48feb"
replace agri_6_41_a_1 = 0 if key == "uuid:b23e5229-ac34-49c5-bb00-dc31eb3bd45a"
replace agri_6_41_a_1 = 0 if key == "uuid:92171a8f-7a48-4292-a5ef-6850b6c04333"
replace agri_6_41_a_1 = 0 if key == "uuid:c840f2ec-d0ec-4652-9e94-39ce87bad68a"
replace agri_6_40_a_1 = 0 if key == "uuid:63d42e02-d823-4062-97c5-479202f66254"
replace agri_6_39_a_code_3 = 1 if key == "uuid:7f450507-9f4a-40a5-99e4-8b63c95b4d2c"
replace agri_6_39_a_code_2 = 1 if key == "uuid:1df09cfd-b5f7-4fa5-8227-199fa261ae20"
replace agri_6_39_a_code_1 = 1 if key == "uuid:171f6913-8000-4ea9-b1d3-b7f19e26b0eb"
replace agri_6_39_a_code_1 = 1 if key == "uuid:4c778d8f-97d4-47fa-af7d-7e3314c48feb"
replace agri_6_39_a_1 = 250 if key == "uuid:18f82da1-ec44-4a27-aa91-dc3e5e255ab0"
replace agri_6_38_a_code_1 = 1 if key == "uuid:804194f1-f223-4619-b187-d197224402f6"
replace agri_6_38_a_1 = 1500 if key == "uuid:4a46ca8e-aa03-4e23-876c-ba33a5c5a74e"
replace agri_6_38_a_1 = 1500 if key == "uuid:046d9fb5-af36-42e6-b747-7ef88f2eb3c0"
replace agri_6_38_a_1 = 1200 if key == "uuid:b1fae32c-057b-45c3-a10b-5fbdf289d4d6"
replace agri_6_38_a_1 = 1500 if key == "uuid:b23e5229-ac34-49c5-bb00-dc31eb3bd45a"
replace agri_6_38_a_1 = 1200 if key == "uuid:92171a8f-7a48-4292-a5ef-6850b6c04333"
replace agri_6_28_2 = 0 if key == "uuid:96923c86-ad11-4def-97ce-64a3089a78a1"
replace legumineuses_05_5 = 300 if key == "uuid:1242f3df-9cca-4b94-887a-dbb306dd6c6a"
replace legumineuses_05_5 = 300 if key == "uuid:e883f07a-0650-4828-9cac-5b7f90fa0721"
replace legumineuses_05_5 = 300 if key == "uuid:fff75691-71ee-4a1a-9ea0-807f2bd5908a"
replace legumineuses_05_5 = 300 if key == "uuid:5e2f86f2-31e1-4ae2-a70c-416fa143f989"
replace legumineuses_05_3 = 300 if key == "uuid:d033952d-7441-42b0-aace-96666788acc8"
replace legumineuses_05_3 = 300 if key == "uuid:26b0ed38-3990-4668-bc30-dff21cdb74c0"
replace legumineuses_05_3 = 300 if key == "uuid:952f24db-030b-475b-a2cb-f383305e65e3"
replace legumineuses_05_3 = 300 if key == "uuid:5e2f86f2-31e1-4ae2-a70c-416fa143f989"
replace legumineuses_05_3 = 300 if key == "uuid:885049cc-1088-4324-82a2-6a3d1aa5c3bf"
replace legumineuses_05_2 = 300 if key == "uuid:2bb2bdb8-7cb5-49a6-88cf-cc9c9fcac5c8"
replace legumineuses_05_1 = 300 if key == "uuid:16671bba-7134-410e-adcc-d943d1515258"
replace legumineuses_05_1 = 300 if key == "uuid:d033952d-7441-42b0-aace-96666788acc8"
replace legumineuses_05_1 = 300 if key == "uuid:fff75691-71ee-4a1a-9ea0-807f2bd5908a"
replace legumineuses_05_1 = 300 if key == "uuid:ce5549e0-79b0-4bde-9e8b-37fab5eedf2f"
replace legumineuses_05_1 = 300 if key == "uuid:b386f6d7-2ba2-4b4e-8c92-a51b07e3727c"
replace legumineuses_05_1 = 300 if key == "uuid:18b5cc2f-a861-4487-ba1d-8bb0bbbe13cc"
replace legumineuses_05_1 = 0 if key == "uuid:51bbc017-d8de-4e30-9a9b-3594922d7738"
replace age_1 = 92 if key == "uuid:d821e832-2f31-4039-9003-20d913da3311"
replace hh_41_6 = 7 if key == "uuid:ca054a55-5420-49cc-b0cd-2a077889231b"
replace hh_41_5 = 7 if key == "uuid:ce5549e0-79b0-4bde-9e8b-37fab5eedf2f"
replace hh_41_3 = 7 if key == "uuid:ca054a55-5420-49cc-b0cd-2a077889231b"
replace cereals_04_1 = -9 if key == "uuid:16671bba-7134-410e-adcc-d943d1515258"
replace cereals_02_1 = 24000 if key == "uuid:c2106e68-0cfa-4b76-a564-4ec7f7f0689a"
replace cereals_02_1 = 64000 if key == "uuid:309e01e8-8554-4a50-95b3-b8a52e840905"
replace cereals_02_1 = 12000 if key == "uuid:983adac5-4009-47c2-8c3e-9976d4b0961b"
replace cereals_02_1 = 13000 if key == "uuid:9592ef45-c1b9-4b5b-a4d6-040ac97fdc5f"
replace cereals_02_1 = 16000 if key == "uuid:7305a580-e706-4203-8d8c-79eaed40ffd9"
replace cereals_02_1 = 10960 if key == "uuid:f4aa1eed-3ba6-43e0-84f4-3c3a2e7c1e14"
replace cereals_02_1 = 23040 if key == "uuid:112ead05-6a4c-4759-b69f-f3b875805f55"
replace cereals_02_1 = 36000 if key == "uuid:d56edb36-89c5-436c-93d2-f3e9f0f601a5"
replace cereals_02_1 = 14240 if key == "uuid:76975ab5-98e2-414f-a9b9-7c15a4ff50f6"
replace cereals_02_1 = 16800 if key == "uuid:bc6c1d3d-fa4b-4767-9ae5-c7422db73c6c"
replace cereals_02_1 = 16000 if key == "uuid:10cdabf2-f022-4539-8c2b-7eaa1bead1d1"
replace agri_income_45_10 = -9 if key == "uuid:6e690859-4817-4dcd-8672-cf08f71f164b"
replace agri_income_33 = 540000 if key == "uuid:61144d37-6700-447a-b358-647e4312819f"
replace agri_income_33 = 450000 if key == "uuid:7549994f-023a-4e2f-a015-225aaf53ff2b"
replace agri_income_33 = -9 if key == "uuid:4f7289fd-e9ce-47ce-b262-a003ec89ebd4"
replace agri_income_33 = 600000 if key == "uuid:986f2955-cda3-471a-8c53-c4a7eefa0fd8"
replace agri_income_33 = 300000 if key == "uuid:477170af-7d72-4fb1-9dc3-8208bdd9442c"
replace agri_income_33 = 420000 if key == "uuid:bc6c1d3d-fa4b-4767-9ae5-c7422db73c6c"
replace agri_income_29 = -9 if key == "uuid:40069d40-8775-4706-874f-10a74794a83d"
replace agri_income_23_1 = -9 if key == "uuid:61144d37-6700-447a-b358-647e4312819f"
replace agri_income_23_1 = -9 if key == "uuid:40069d40-8775-4706-874f-10a74794a83d"
replace agri_income_23_1 = -9 if key == "uuid:9147cf5c-0509-4118-994c-462c61bcc4fe"
replace agri_income_23_1 = -9 if key == "uuid:3b9c2531-3c02-4417-85f4-4023e1fd13cf"
replace agri_income_23_1 = -9 if key == "uuid:59d24152-883e-4d28-9e64-01a5d66013fb"
replace agri_income_23_1 = -9 if key == "uuid:ae79a16b-e91d-43dd-bf07-f5d8243dbc65"
replace agri_income_19 = -9 if key == "uuid:ae414dc0-3027-4656-9f44-94b899afafe7"
replace agri_income_16 = -9 if key == "uuid:ae414dc0-3027-4656-9f44-94b899afafe7"
replace agri_income_06 = -9 if key == "uuid:91939cea-af27-4cf0-be7d-1ce751c8163b"
replace agri_income_06 = 0 if key == "uuid:61144d37-6700-447a-b358-647e4312819f"
replace agri_income_06 = 0 if key == "uuid:9147cf5c-0509-4118-994c-462c61bcc4fe"
replace agri_income_06 = 0 if key == "uuid:983adac5-4009-47c2-8c3e-9976d4b0961b"
replace agri_income_06 = 112500 if key == "uuid:7305a580-e706-4203-8d8c-79eaed40ffd9"
replace agri_income_06 = 0 if key == "uuid:d119d84e-18ad-43a8-aaaf-8b807d8af117"
replace agri_income_06 = 0 if key == "uuid:986f2955-cda3-471a-8c53-c4a7eefa0fd8"
replace agri_income_06 = 0 if key == "uuid:0c528323-d63f-4386-b6b0-17a230566698"
replace agri_income_06 = 0 if key == "uuid:62f6265a-d35b-4b63-a24e-e159377cb165"
replace agri_income_05 = 75000 if key == "uuid:91939cea-af27-4cf0-be7d-1ce751c8163b"
replace agri_income_05 = 250000 if key == "uuid:61144d37-6700-447a-b358-647e4312819f"
replace agri_income_05 = -9 if key == "uuid:9147cf5c-0509-4118-994c-462c61bcc4fe"
replace agri_income_05 = 70000 if key == "uuid:983adac5-4009-47c2-8c3e-9976d4b0961b"
replace agri_income_05 = 600000 if key == "uuid:7305a580-e706-4203-8d8c-79eaed40ffd9"
replace agri_income_05 = -9 if key == "uuid:d119d84e-18ad-43a8-aaaf-8b807d8af117"
replace agri_income_05 = 300000 if key == "uuid:986f2955-cda3-471a-8c53-c4a7eefa0fd8"
replace agri_income_05 = -9 if key == "uuid:2a38b805-c7ae-4da3-8ff0-e6647ebd3139"
replace agri_income_05 = 30000 if key == "uuid:0c528323-d63f-4386-b6b0-17a230566698"
replace agri_income_05 = 150000 if key == "uuid:d56edb36-89c5-436c-93d2-f3e9f0f601a5"
replace agri_income_05 = -9 if key == "uuid:ae79a16b-e91d-43dd-bf07-f5d8243dbc65"
replace agri_income_05 = 250000 if key == "uuid:ca054a55-5420-49cc-b0cd-2a077889231b"
replace agri_income_05 = -9 if key == "uuid:62f6265a-d35b-4b63-a24e-e159377cb165"
replace agri_6_41_a_code_1 = 1 if key == "uuid:952f24db-030b-475b-a2cb-f383305e65e3"
replace agri_6_41_a_1 = 0 if key == "uuid:952f24db-030b-475b-a2cb-f383305e65e3"
replace agri_6_41_a_1 = 0 if key == "uuid:f69cb7e8-65de-4496-b54e-bc11994583e7"
replace agri_6_40_a_1 = 2250 if key == "uuid:c2106e68-0cfa-4b76-a564-4ec7f7f0689a"
replace agri_6_40_a_1 = 0 if key == "uuid:01987b23-5c8a-49a9-948e-79e67cd4d307"
replace agri_6_39_a_1 = 0 if key == "uuid:f69cb7e8-65de-4496-b54e-bc11994583e7"
replace agri_6_38_a_1 = 4500 if key == "uuid:c2106e68-0cfa-4b76-a564-4ec7f7f0689a"
replace agri_6_38_a_1 = 1200 if key == "uuid:7305a580-e706-4203-8d8c-79eaed40ffd9"
replace agri_6_38_a_1 = 1400 if key == "uuid:112ead05-6a4c-4759-b69f-f3b875805f55"
replace agri_6_28_1 = 0 if key == "uuid:f69cb7e8-65de-4496-b54e-bc11994583e7"
replace legumineuses_05_3 = 300 if key == "uuid:887b6285-2eca-449b-885e-3e8a3e9733ac"
replace legumineuses_05_3 = 300 if key == "uuid:677eb96e-7e1d-4cce-93d3-f743b6c3290c"
replace legumineuses_05_3 = 300 if key == "uuid:cfe90a96-29b2-49ae-8505-c1eec3745f3d"
replace legumineuses_05_3 = 300 if key == "uuid:a0ef24fa-d08f-442c-a3a6-373e0f629ef2"
replace legumineuses_05_3 = 300 if key == "uuid:b1d8b6b0-f899-427b-b0a2-96a43f2a092b"
replace legumineuses_05_3 = 300 if key == "uuid:2fba3e48-9d7b-4b32-ab2d-990fc6d2d413"
replace legumineuses_05_3 = 300 if key == "uuid:00dc6224-fae4-4de7-9d21-2f418b471aca"
replace legumineuses_05_3 = 300 if key == "uuid:30adca5f-189e-48eb-9f04-aea83e6e68ac"
replace legumineuses_05_3 = 300 if key == "uuid:02e29539-f3fc-454b-bcfa-612c3e38e64e"
replace legumineuses_05_3 = 300 if key == "uuid:7857f5dd-b97f-42c2-9506-5fa8bf7847cf"
replace legumineuses_05_3 = 300 if key == "uuid:9f0c73e5-660c-4f8f-9be1-e4f4806229f1"
replace legumineuses_05_3 = 300 if key == "uuid:624cc7d4-17b9-4a30-a7f0-ae2f46a48948"
replace legumineuses_05_3 = 300 if key == "uuid:a6c6ad01-0cb0-4c9f-823c-dc6dc4a14256"
replace legumineuses_05_3 = 300 if key == "uuid:c1858219-77cd-4076-8cf8-4059b7d80d2d"
replace legumineuses_05_3 = 300 if key == "uuid:b523b6ee-b33f-4331-ac8e-e3770b31148e"
replace legumineuses_05_3 = 300 if key == "uuid:f7c1d3b1-0f51-495c-9ed5-7fd642518c73"
replace legumineuses_05_3 = 300 if key == "uuid:9211237f-7b08-4c13-b007-2bc27f4fe27b"
replace legumineuses_05_3 = 300 if key == "uuid:869babf6-be9d-49ad-a3e6-b949d3719a28"
replace legumineuses_05_3 = 300 if key == "uuid:3adf763f-622e-4cf3-9e2e-cb5a9909deb2"
replace legumineuses_05_3 = 300 if key == "uuid:83dde2f0-83a6-4399-a31b-7067f8553efc"
replace legumineuses_05_3 = 300 if key == "uuid:61ae58e8-67ed-407f-94e6-c83fe4454247"
replace legumineuses_05_3 = 300 if key == "uuid:4219536c-3d1b-4d77-a065-f63913f70d0e"
replace legumineuses_05_3 = 300 if key == "uuid:91d4c4b4-ac34-42e9-9e3d-c3491b708ca0"
replace legumineuses_05_3 = 300 if key == "uuid:3453d9d5-708b-4f02-8897-cc77ef1f6673"
replace legumineuses_05_3 = 300 if key == "uuid:3e4fa814-7e80-4e40-b3a6-f6e938bcc106"
replace legumineuses_05_3 = 300 if key == "uuid:48744097-2c9b-4fbf-90c8-72d5ffa592c4"
replace legumineuses_05_3 = 300 if key == "uuid:72dbf5df-2ca4-419b-8876-f54246c9919d"
replace legumineuses_05_3 = 300 if key == "uuid:53fe3ce0-e78b-4d9e-b72e-9f0f0563cd82"
replace legumineuses_05_3 = 300 if key == "uuid:6df1086e-fd0a-49a1-a534-3e0867edb34f"
replace legumineuses_05_3 = 300 if key == "uuid:9a2701e9-2f77-43c6-948a-00c892e2739f"
replace legumineuses_05_1 = 300 if key == "uuid:a0ef24fa-d08f-442c-a3a6-373e0f629ef2"
replace legumineuses_05_1 = 300 if key == "uuid:68f2934f-236c-4a70-a156-771cc666fc6f"
replace legumineuses_05_1 = 300 if key == "uuid:f46febb7-4f27-4491-8bcb-e26865df976b"
replace legumineuses_05_1 = 300 if key == "uuid:53fe3ce0-e78b-4d9e-b72e-9f0f0563cd82"
replace legumes_04_3 = 8400 if key == "uuid:00dc6224-fae4-4de7-9d21-2f418b471aca"
replace legumes_02_3 = 6200 if key == "uuid:b1d8b6b0-f899-427b-b0a2-96a43f2a092b"
replace legumes_02_3 = 4350 if key == "uuid:2fba3e48-9d7b-4b32-ab2d-990fc6d2d413"
replace legumes_02_3 = 8400 if key == "uuid:00dc6224-fae4-4de7-9d21-2f418b471aca"
replace legumes_02_3 = 6200 if key == "uuid:c1858219-77cd-4076-8cf8-4059b7d80d2d"
replace legumes_02_3 = 7600 if key == "uuid:f7c1d3b1-0f51-495c-9ed5-7fd642518c73"
replace legumes_02_3 = 3350 if key == "uuid:869babf6-be9d-49ad-a3e6-b949d3719a28"
replace legumes_02_3 = 8645 if key == "uuid:91d4c4b4-ac34-42e9-9e3d-c3491b708ca0"
replace legumes_02_3 = 7380 if key == "uuid:3e4fa814-7e80-4e40-b3a6-f6e938bcc106"
replace legumes_02_3 = 6300 if key == "uuid:9a2701e9-2f77-43c6-948a-00c892e2739f"
replace legumes_01_3 = 1.6 if key == "uuid:c1858219-77cd-4076-8cf8-4059b7d80d2d"
replace age_3 = 99 if key == "uuid:e8949caf-47ee-4e5e-8b89-3eced60feb3d"
replace age_1 = 92 if key == "uuid:e6aa7e36-c770-4ee8-be3d-4de123c20a17"
replace hh_41_9 = 6 if key == "uuid:e35717b1-f96e-4f9a-a5c4-0ac0981f3d28"
replace hh_41_6 = 7 if key == "uuid:bc23d519-8a2a-476f-9c2f-029d70938a8a"
replace hh_41_5 = 7 if key == "uuid:b523b6ee-b33f-4331-ac8e-e3770b31148e"
replace hh_41_2 = 6 if key == "uuid:f46febb7-4f27-4491-8bcb-e26865df976b"
replace hh_41_14 = 6 if key == "uuid:e35717b1-f96e-4f9a-a5c4-0ac0981f3d28"
replace hh_41_1 = 7 if key == "uuid:db27b6db-6d41-4805-b954-5206411f2e37"
replace health_5_12_9 = 8 if key == "uuid:efb4b6b1-a943-48f2-b605-c5f3d1a436db"
replace health_5_12_9 = 8 if key == "uuid:efb4b6b1-a943-48f2-b605-c5f3d1a436db"
replace health_5_12_5 = 17 if key == "uuid:83dde2f0-83a6-4399-a31b-7067f8553efc"
replace health_5_12_5 = 17 if key == "uuid:83dde2f0-83a6-4399-a31b-7067f8553efc"
replace health_5_12_1 = 8 if key == "uuid:c755bc6d-e89f-4f06-bf41-d36b813d17ef"
replace health_5_12_1 = 8 if key == "uuid:c755bc6d-e89f-4f06-bf41-d36b813d17ef"
replace health_5_12_5 = 8 if key == "uuid:ac59e121-fda0-4e0a-9c44-10ae292ec1ec"
replace health_5_12_5 = 8 if key == "uuid:ac59e121-fda0-4e0a-9c44-10ae292ec1ec"
replace cereals_02_4 = 5500 if key == "uuid:6639eccd-02ef-4d99-ac3a-695fe0778d36"
replace cereals_02_1 = 4100 if key == "uuid:a6c6ad01-0cb0-4c9f-823c-dc6dc4a14256"
replace agri_6_40_a_code_1 = 1 if key == "uuid:dce059c7-c3d8-4f48-9e71-2e6e6ced417b"
replace agri_6_40_a_code_1 = 1 if key == "uuid:9f0c73e5-660c-4f8f-9be1-e4f4806229f1"
replace agri_6_40_a_1 = 400 if key == "uuid:3adf763f-622e-4cf3-9e2e-cb5a9909deb2"
replace agri_6_28_1 = 0 if key == "uuid:7857f5dd-b97f-42c2-9506-5fa8bf7847cf"
replace agri_6_28_1 = 0 if key == "uuid:c3e6b5a4-b144-4260-bd64-715cff263da9"
replace agri_6_28_1 = 0 if key == "uuid:48744097-2c9b-4fbf-90c8-72d5ffa592c4"
replace o_culture_01 = 0.5 if key == "uuid:9395c227-458d-4a0c-a7ff-11cb8e93046b"
replace legumineuses_05_5 = 350 if key == "uuid:a0dfe598-6001-469b-a7d8-108daf3c97ff"
replace legumineuses_05_4 = 350 if key == "uuid:d8dd650c-6fbd-46f6-a29f-a59591a96c7c"
replace legumineuses_05_4 = 350 if key == "uuid:3005e9a7-0c4f-4735-a3ee-13a5bd96f68e"
replace legumineuses_05_4 = 350 if key == "uuid:57141e25-c8fe-4256-865c-ffb74b8722f1"
replace legumineuses_05_4 = 350 if key == "uuid:06433daf-d38a-4d07-a2b6-cc9e4a9ad473"
replace legumineuses_05_3 = 350 if key == "uuid:06bc1137-9eb6-42f0-bc02-6737ed6ddd88"
replace legumineuses_05_3 = 350 if key == "uuid:d8dd650c-6fbd-46f6-a29f-a59591a96c7c"
replace legumineuses_05_3 = 350 if key == "uuid:da458b40-5f33-47ce-b317-c2e278cd8d79"
replace legumineuses_05_3 = 350 if key == "uuid:dfe645bb-8daa-40f0-9313-7064612f2e3b"
replace legumineuses_05_3 = 350 if key == "uuid:547fca62-69a2-4f31-8fe3-418351d785a3"
replace legumineuses_05_3 = 350 if key == "uuid:06433daf-d38a-4d07-a2b6-cc9e4a9ad473"
replace legumineuses_05_1 = 350 if key == "uuid:b81044cb-fdfd-41a7-b76b-70a36b935af3"
replace legumineuses_05_1 = 350 if key == "uuid:b34d4ded-458f-4b68-a940-bf4fd5908308"
replace legumineuses_05_1 = 350 if key == "uuid:87348925-9b89-46cc-9e1c-ec02ef720afa"
replace legumineuses_05_1 = 350 if key == "uuid:a850d7a9-ed56-4f03-8045-6e298dae3fff"
replace legumineuses_05_1 = 350 if key == "uuid:d8dd650c-6fbd-46f6-a29f-a59591a96c7c"
replace legumineuses_05_1 = 350 if key == "uuid:29fe99f8-a8a3-4186-8b69-85690206f18c"
replace legumineuses_05_1 = 350 if key == "uuid:a0dfe598-6001-469b-a7d8-108daf3c97ff"
replace legumineuses_05_1 = 350 if key == "uuid:a389351c-405b-4fcf-bc2d-4f9b647cd821"
replace legumineuses_05_1 = 350 if key == "uuid:f6bda047-98aa-4c75-97f9-2136644faaf4"
replace legumineuses_05_1 = 350 if key == "uuid:379c64be-1323-4865-acd5-ed820fbdfad7"
replace legumineuses_05_1 = 300 if key == "uuid:bf09234f-1450-4f7b-a949-f6ce07f26c97"
replace legumineuses_05_1 = 300 if key == "uuid:1e1c2c1b-4f20-4c81-aaa7-6177fd8e9133"
replace legumineuses_05_1 = 500 if key == "uuid:9395c227-458d-4a0c-a7ff-11cb8e93046b"
replace legumes_05_1 = 300 if key == "uuid:b81044cb-fdfd-41a7-b76b-70a36b935af3"
replace legumes_05_1 = 300 if key == "uuid:b34d4ded-458f-4b68-a940-bf4fd5908308"
replace legumes_05_1 = 300 if key == "uuid:1e1c2c1b-4f20-4c81-aaa7-6177fd8e9133"
replace legumes_05_1 = 300 if key == "uuid:9395c227-458d-4a0c-a7ff-11cb8e93046b"
replace legumes_04_4 = 150 if key == "uuid:06433daf-d38a-4d07-a2b6-cc9e4a9ad473"
replace legumes_01_4 = 0.5 if key == "uuid:d8dd650c-6fbd-46f6-a29f-a59591a96c7c"
replace legumes_01_3 = 0.5 if key == "uuid:d8dd650c-6fbd-46f6-a29f-a59591a96c7c"
replace legumes_01_1 = 0.5 if key == "uuid:d8dd650c-6fbd-46f6-a29f-a59591a96c7c"
replace legumes_01_1 = 0.25 if key == "uuid:9395c227-458d-4a0c-a7ff-11cb8e93046b"
replace hh_education_level_2 = 3 if key == "uuid:102325d0-e44c-43d8-bf45-03fc0d4bbeeb"
replace age_5 = 92 if key == "uuid:6bc3c04b-1957-4811-8f2f-2c62506708f3"
replace age_3 = 95 if key == "uuid:5ac7ee7b-7dfa-4cf2-8d51-31ad6a4e0d9d"
replace age_3 = 51 if key == "uuid:57c16684-de86-4c35-8785-13481227d40c"
replace age_2 = 91 if key == "uuid:2640003a-e439-43ff-a45f-723739ead318"
replace hh_41_2 = 6 if key == "uuid:28e5893e-1205-4647-b375-2ab2e07290f8"
replace hh_14_b_6 = 15 if key == "uuid:1f2ff04c-3bd7-473f-8b62-ef487daad0fc"
replace health_5_12_2 = 300 if key == "uuid:dadd5583-da49-40ff-8eab-3f60938c143f"
replace health_5_12_2 = 300 if key == "uuid:dadd5583-da49-40ff-8eab-3f60938c143f"
replace health_5_12_2 = 7 if key == "uuid:c07e60ea-2961-45fb-b5ef-06d4a42f3112"
replace health_5_12_2 = 7 if key == "uuid:c07e60ea-2961-45fb-b5ef-06d4a42f3112"
replace farines_05_2 = -9 if key == "uuid:86eb5846-fbde-44a1-b04c-7dab574f678b"
replace correct_hh = 1 if key == "uuid:0bfb63c8-0f4d-4717-a62c-c0fb05f20b55"
replace cereals_01_1 = 0.5 if key == "uuid:86db61ce-f9cb-4f7a-b0a5-66ffddfdca6a"
replace agri_income_48_2 = -9 if key == "uuid:a850d7a9-ed56-4f03-8045-6e298dae3fff"
replace agri_income_48_2 = 65000 if key == "uuid:d8dd650c-6fbd-46f6-a29f-a59591a96c7c"
replace agri_income_47_2 = 300 if key == "uuid:a850d7a9-ed56-4f03-8045-6e298dae3fff"
replace agri_income_47_1 = 350 if key == "uuid:1e1c2c1b-4f20-4c81-aaa7-6177fd8e9133"
replace agri_income_45_5 = 7500 if key == "uuid:a850d7a9-ed56-4f03-8045-6e298dae3fff"
replace agri_income_45_5 = 5000 if key == "uuid:86eb5846-fbde-44a1-b04c-7dab574f678b"
replace agri_income_45_5 = -9 if key == "uuid:77adf104-aae7-4179-953f-b5bcf21dadda"
replace agri_income_45_5 = 5000 if key == "uuid:1e1c2c1b-4f20-4c81-aaa7-6177fd8e9133"
replace agri_income_45_4 = 32000 if key == "uuid:397a1aff-1e77-4462-9d1d-845bb8450fe8"
replace agri_income_45_2 = 75000 if key == "uuid:1cf5e8e5-012a-4791-a399-071c5984af16"
replace agri_income_45_2 = 20000 if key == "uuid:86eb5846-fbde-44a1-b04c-7dab574f678b"
replace agri_income_45_2 = 10000 if key == "uuid:634a53c8-4418-4a8e-a1a0-e379d1dd70dd"
replace agri_income_45_2 = 60000 if key == "uuid:86db61ce-f9cb-4f7a-b0a5-66ffddfdca6a"
replace agri_income_45_2 = 18000 if key == "uuid:102325d0-e44c-43d8-bf45-03fc0d4bbeeb"
replace agri_income_45_2 = 50000 if key == "uuid:57141e25-c8fe-4256-865c-ffb74b8722f1"
replace agri_income_45_2 = 10000 if key == "uuid:aa0c1815-8bcc-4f5d-9f03-676aabc3854d"
replace agri_income_45_2 = 15000 if key == "uuid:1e57be6b-bcb6-49dd-b73c-989a0acc3f5c"
replace agri_income_45_2 = 25000 if key == "uuid:e6e6aedc-3640-42d2-9ffa-2dec615aae89"
replace agri_income_45_1 = 360000 if key == "uuid:da458b40-5f33-47ce-b317-c2e278cd8d79"
replace agri_income_36_1 = 15000 if key == "uuid:634a53c8-4418-4a8e-a1a0-e379d1dd70dd"
replace agri_income_33 = 90000 if key == "uuid:9395c227-458d-4a0c-a7ff-11cb8e93046b"
replace agri_income_23_2 = 120000 if key == "uuid:4911fbca-e3a3-473f-b158-75a6abe6d880"
replace agri_income_23_1 = 88000 if key == "uuid:a850d7a9-ed56-4f03-8045-6e298dae3fff"
replace agri_income_23_1 = 240000 if key == "uuid:66c36843-1e4c-4576-9c41-c73386bee59b"
replace agri_income_23_1 = 30000 if key == "uuid:2640003a-e439-43ff-a45f-723739ead318"
replace agri_income_23_1 = 54000 if key == "uuid:7f8ec050-0ea9-4858-b4ec-962ff43746dc"
replace agri_income_23_1 = 150000 if key == "uuid:57141e25-c8fe-4256-865c-ffb74b8722f1"
replace agri_income_12_2 = 0 if key == "uuid:102325d0-e44c-43d8-bf45-03fc0d4bbeeb"
replace agri_income_11_2 = 0 if key == "uuid:102325d0-e44c-43d8-bf45-03fc0d4bbeeb"
replace agri_income_08_2 = 0 if key == "uuid:102325d0-e44c-43d8-bf45-03fc0d4bbeeb"
replace agri_income_07_2 = 0 if key == "uuid:102325d0-e44c-43d8-bf45-03fc0d4bbeeb"
replace agri_income_06 = 10000 if key == "uuid:2e5d7a20-32ca-4050-9ce4-a6002eda5a78"
replace agri_income_05 = 36000 if key == "uuid:434fcca5-a3ae-4bdd-a61c-aa38dad0ff28"
replace agri_income_05 = 180000 if key == "uuid:91807637-9e11-44ab-8b84-21db6e0b7d78"
replace agri_6_41_a_code_4 = 1 if key == "uuid:41947862-6080-46f1-95f2-157b95f1a3fe"
replace agri_6_41_a_code_3 = 1 if key == "uuid:1f2ff04c-3bd7-473f-8b62-ef487daad0fc"
replace agri_6_41_a_code_2 = 1 if key == "uuid:1f2ff04c-3bd7-473f-8b62-ef487daad0fc"
replace agri_6_41_a_code_1 = 1 if key == "uuid:732970ab-daff-4e9b-9738-a2249f9c3524"
replace agri_6_41_a_code_1 = 1 if key == "uuid:52b1fcad-232a-4569-9ac7-1e0ce3774d5e"
replace agri_6_40_a_code_1 = 1 if key == "uuid:2e5d7a20-32ca-4050-9ce4-a6002eda5a78"
replace agri_6_40_a_1 = 0 if key == "uuid:2e5d7a20-32ca-4050-9ce4-a6002eda5a78"
replace agri_6_38_a_code_2 = 1 if key == "uuid:dfe645bb-8daa-40f0-9313-7064612f2e3b"
replace agri_6_38_a_1 = 300 if key == "uuid:29fe99f8-a8a3-4186-8b69-85690206f18c"
replace agri_6_38_a_1 = 1050 if key == "uuid:72fd4109-9013-42e4-9a0a-bca42653b320"
replace agri_6_28_2 = 0 if key == "uuid:bf09234f-1450-4f7b-a949-f6ce07f26c97"
replace agri_6_28_1 = 0 if key == "uuid:bf09234f-1450-4f7b-a949-f6ce07f26c97"
replace legumineuses_05_4 = 350 if key == "uuid:abb87752-4a63-446c-9b08-114b67de3f6e"
replace legumineuses_05_3 = 350 if key == "uuid:a174f3ae-1533-4f24-9056-c76dc2c8ec40"
replace legumineuses_05_3 = 350 if key == "uuid:a7a54357-649f-4f1e-b7f1-ca2977436360"
replace legumineuses_05_3 = 350 if key == "uuid:245c21d7-f36b-4083-9a15-27de32aaf8e0"
replace legumineuses_05_3 = 350 if key == "uuid:02037ed1-dc1a-4506-941b-fd49d9df7b53"
replace legumineuses_05_1 = 350 if key == "uuid:dc9a29e3-3292-4ed0-a27b-33446ca8640b"
replace legumineuses_05_1 = 350 if key == "uuid:396c8c59-7475-4da5-9fb2-c3531077ab31"
replace legumineuses_05_1 = 350 if key == "uuid:919061ac-5092-4d95-9642-a8f59bbdc4f9"
replace legumineuses_02_5 = 350 if key == "uuid:e6efc18c-7a7b-4132-8535-6e7dff6a7ac7"
replace legumineuses_02_5 = -9 if key == "uuid:8ca82313-2f21-45dd-9c4b-6cd68d8052a8"
replace legumineuses_02_5 = -9 if key == "uuid:a9b198b5-e8e9-457d-9967-1ac777669d76"
replace legumineuses_02_1 = -9 if key == "uuid:8b114889-8bbb-45c2-94f2-eb752a16fe0e"
replace legumineuses_02_1 = -9 if key == "uuid:88167bbe-853b-48b8-a3f9-6bbb02c12309"
replace legumineuses_02_1 = -9 if key == "uuid:0be6fc2e-5699-49b5-9b31-d924e7ad7581"
replace legumineuses_02_1 = -9 if key == "uuid:26971b58-f29b-4ca2-835b-f25a19f057c3"
replace legumineuses_02_1 = -9 if key == "uuid:32246f7b-b517-478d-b4f2-f8ab414ee1b2"
replace legumineuses_02_1 = 13500 if key == "uuid:3edcedd7-4992-486e-a924-22eb67a877b3"
replace legumineuses_01_1 = -9 if key == "uuid:8b114889-8bbb-45c2-94f2-eb752a16fe0e"
replace legumes_05_4 = -9 if key == "uuid:abb87752-4a63-446c-9b08-114b67de3f6e"
replace legumes_05_3 = -9 if key == "uuid:a174f3ae-1533-4f24-9056-c76dc2c8ec40"
replace legumes_05_1 = -9 if key == "uuid:dc9a29e3-3292-4ed0-a27b-33446ca8640b"
replace legumes_02_4 = -9 if key == "uuid:abb87752-4a63-446c-9b08-114b67de3f6e"
replace legumes_02_3 = -9 if key == "uuid:a174f3ae-1533-4f24-9056-c76dc2c8ec40"
replace legumes_02_3 = -9 if key == "uuid:a7a54357-649f-4f1e-b7f1-ca2977436360"
replace legumes_02_1 = -9 if key == "uuid:dc9a29e3-3292-4ed0-a27b-33446ca8640b"
replace legumes_02_1 = -9 if key == "uuid:88167bbe-853b-48b8-a3f9-6bbb02c12309"
replace legumes_02_1 = -9 if key == "uuid:396c8c59-7475-4da5-9fb2-c3531077ab31"
replace legumes_02_1 = -9 if key == "uuid:919061ac-5092-4d95-9642-a8f59bbdc4f9"
replace legumes_01_3 = -9 if key == "uuid:a174f3ae-1533-4f24-9056-c76dc2c8ec40"
replace legumes_01_1 = -9 if key == "uuid:dc9a29e3-3292-4ed0-a27b-33446ca8640b"
replace hh_name_complet_resp_new = "IDY DIAW" if key == "uuid:90d1e1e8-e397-433d-9199-1031cac8b8b2"
replace hh_14_b_8 = -9 if key == "uuid:dedd712c-634c-4665-a874-f139341ecd5f"
replace hh_14_b_5 = -9 if key == "uuid:8915a062-0f9a-4c85-a7a6-1b4fa6b3e3f1"
replace hh_14_b_5 = -9 if key == "uuid:dedd712c-634c-4665-a874-f139341ecd5f"
replace hh_14_b_3 = -9 if key == "uuid:8915a062-0f9a-4c85-a7a6-1b4fa6b3e3f1"
replace hh_14_b_2 = -9 if key == "uuid:f0bebe93-a4f0-40a0-8936-233682b356d1"
replace hh_14_a_8 = -9 if key == "uuid:dedd712c-634c-4665-a874-f139341ecd5f"
replace hh_14_a_5 = -9 if key == "uuid:dedd712c-634c-4665-a874-f139341ecd5f"
replace health_5_12_3 = -9 if key == "uuid:a0748e74-08de-480e-a3ff-9a5f8555215b"
replace health_5_12_3 = -9 if key == "uuid:a0748e74-08de-480e-a3ff-9a5f8555215b"
replace health_5_12_1 = 0 if key == "uuid:a0748e74-08de-480e-a3ff-9a5f8555215b"
replace health_5_12_1 = 0 if key == "uuid:a0748e74-08de-480e-a3ff-9a5f8555215b"
replace health_5_12_5 = 0 if key == "uuid:396c8c59-7475-4da5-9fb2-c3531077ab31"
replace health_5_12_5 = 0 if key == "uuid:396c8c59-7475-4da5-9fb2-c3531077ab31"
replace health_5_12_2 = 0 if key == "uuid:028b56cf-2638-45fe-972e-7ee617f6e252"
replace health_5_12_2 = 0 if key == "uuid:028b56cf-2638-45fe-972e-7ee617f6e252"
replace farines_05_2 = 500 if key == "uuid:dc9a29e3-3292-4ed0-a27b-33446ca8640b"
replace farines_05_2 = 500 if key == "uuid:53f60c19-7569-47c2-9423-ee4f516907c9"
replace farines_05_2 = 500 if key == "uuid:0af345d0-6960-4805-899a-3123a7c1a547"
replace farines_05_1 = 500 if key == "uuid:73ed6f0b-339f-467c-98e2-270d4650a641"
replace farines_05_1 = 500 if key == "uuid:dc9a29e3-3292-4ed0-a27b-33446ca8640b"
replace farines_04_2 = 14420 if key == "uuid:5af529e5-54e6-40aa-96d8-39fff3fe8f29"
replace farines_04_1 = 79760 if key == "uuid:d0347b16-5aee-4340-b320-cdd8a2cc8196"
replace farines_02_2 = -9 if key == "uuid:dc9a29e3-3292-4ed0-a27b-33446ca8640b"
replace farines_02_2 = 70000 if key == "uuid:2a436357-13ff-4710-a749-b012d58d5685"
replace farines_02_2 = -9 if key == "uuid:53f60c19-7569-47c2-9423-ee4f516907c9"
replace farines_02_2 = -9 if key == "uuid:0af345d0-6960-4805-899a-3123a7c1a547"
replace farines_02_2 = -9 if key == "uuid:04f3040a-9991-412d-9fce-9ee840eafcea"
replace farines_02_2 = 12000 if key == "uuid:6b2af6f0-abd9-40ce-8bb7-792c1e9e0e18"
replace farines_02_2 = 14400 if key == "uuid:5af529e5-54e6-40aa-96d8-39fff3fe8f29"
replace farines_02_2 = 18000 if key == "uuid:17b1c705-ed89-443b-8ddc-4ca93f033edd"
replace farines_02_2 = -9 if key == "uuid:02a39efd-23f1-4815-9b17-ff8b43173d90"
replace farines_02_2 = -9 if key == "uuid:d0347b16-5aee-4340-b320-cdd8a2cc8196"
replace farines_02_2 = -9 if key == "uuid:78498830-729b-4669-a8b0-ddb3ba898a73"
replace farines_02_2 = -9 if key == "uuid:a1ac2ac5-36fc-4a12-ac9b-45b86f0dc84e"
replace farines_02_1 = -9 if key == "uuid:73ed6f0b-339f-467c-98e2-270d4650a641"
replace farines_02_1 = -9 if key == "uuid:dc9a29e3-3292-4ed0-a27b-33446ca8640b"
replace farines_02_1 = 60000 if key == "uuid:2a436357-13ff-4710-a749-b012d58d5685"
replace farines_02_1 = -9 if key == "uuid:04f3040a-9991-412d-9fce-9ee840eafcea"
replace farines_02_1 = -9 if key == "uuid:6b2af6f0-abd9-40ce-8bb7-792c1e9e0e18"
replace farines_02_1 = 12000 if key == "uuid:5af529e5-54e6-40aa-96d8-39fff3fe8f29"
replace farines_02_1 = -9 if key == "uuid:02a39efd-23f1-4815-9b17-ff8b43173d90"
replace farines_02_1 = -9 if key == "uuid:32246f7b-b517-478d-b4f2-f8ab414ee1b2"
replace farines_02_1 = -9 if key == "uuid:33df7be4-7ed3-4333-b350-13d169e5f9e8"
replace farines_02_1 = 10400 if key == "uuid:abd77c0d-982e-4867-b847-9531494e4578"
replace farines_02_1 = -9 if key == "uuid:78498830-729b-4669-a8b0-ddb3ba898a73"
replace farines_02_1 = 84000 if key == "uuid:fe254168-10ee-4b8e-bfe5-5e3d6e47d26e"
replace farines_02_1 = 30000 if key == "uuid:3edcedd7-4992-486e-a924-22eb67a877b3"
replace farines_02_1 = -9 if key == "uuid:a1ac2ac5-36fc-4a12-ac9b-45b86f0dc84e"
replace farines_02_1 = 16000 if key == "uuid:197be989-16e8-4ef0-b91f-a6cb3287c2d8"
replace farines_01_2 = -9 if key == "uuid:dc9a29e3-3292-4ed0-a27b-33446ca8640b"
replace farines_01_1 = -9 if key == "uuid:dc9a29e3-3292-4ed0-a27b-33446ca8640b"
replace cereals_05_5 = -9 if key == "uuid:49e1ea67-b6bc-4685-822a-04e4963bbd19"
replace cereals_05_1 = -9 if key == "uuid:e6efc18c-7a7b-4132-8535-6e7dff6a7ac7"
replace cereals_05_1 = 450 if key == "uuid:4fcda6cc-6186-42db-895b-d6531582834a"
replace cereals_05_1 = 450 if key == "uuid:f2320249-e402-4c29-aea1-6c2dab838a8b"
replace cereals_02_5 = -9 if key == "uuid:49e1ea67-b6bc-4685-822a-04e4963bbd19"
replace cereals_02_1 = -9 if key == "uuid:e6efc18c-7a7b-4132-8535-6e7dff6a7ac7"
replace cereals_02_1 = 56250 if key == "uuid:a9b198b5-e8e9-457d-9967-1ac777669d76"
replace cereals_02_1 = -9 if key == "uuid:f2320249-e402-4c29-aea1-6c2dab838a8b"
replace aquatique_05 = -9 if key == "uuid:a0de5050-073d-47e2-934a-cf2cc8d2c532"
replace aquatique_05 = -9 if key == "uuid:f0bebe93-a4f0-40a0-8936-233682b356d1"
replace aquatique_02 = -9 if key == "uuid:a0de5050-073d-47e2-934a-cf2cc8d2c532"
replace aquatique_02 = -9 if key == "uuid:dedd712c-634c-4665-a874-f139341ecd5f"
replace aquatique_02 = -9 if key == "uuid:f0bebe93-a4f0-40a0-8936-233682b356d1"
replace aquatique_01 = -9 if key == "uuid:a0de5050-073d-47e2-934a-cf2cc8d2c532"
replace aquatique_01 = -9 if key == "uuid:dedd712c-634c-4665-a874-f139341ecd5f"
replace aquatique_01 = -9 if key == "uuid:f0bebe93-a4f0-40a0-8936-233682b356d1"
replace animals_sales_o = 0 if key == "uuid:b3640fb2-c49f-4743-8eda-2c130f0a6d0b"
replace agri_income_45_5 = -9 if key == "uuid:2a436357-13ff-4710-a749-b012d58d5685"
replace agri_income_45_4 = -9 if key == "uuid:2a436357-13ff-4710-a749-b012d58d5685"
replace agri_income_45_3 = -9 if key == "uuid:a174f3ae-1533-4f24-9056-c76dc2c8ec40"
replace agri_income_45_3 = -9 if key == "uuid:4478880a-f8ca-4a4c-9eb3-67465800791b"
replace agri_income_45_3 = -9 if key == "uuid:2a436357-13ff-4710-a749-b012d58d5685"
replace agri_income_45_2 = -9 if key == "uuid:a174f3ae-1533-4f24-9056-c76dc2c8ec40"
replace agri_income_45_2 = -9 if key == "uuid:4478880a-f8ca-4a4c-9eb3-67465800791b"
replace agri_income_45_2 = -9 if key == "uuid:2a436357-13ff-4710-a749-b012d58d5685"
replace agri_income_45_2 = -9 if key == "uuid:e6efc18c-7a7b-4132-8535-6e7dff6a7ac7"
replace agri_income_45_2 = -9 if key == "uuid:f2320249-e402-4c29-aea1-6c2dab838a8b"
replace agri_income_45_2 = -9 if key == "uuid:0b997d0d-f27c-4fb5-bca7-42e6220b29c4"
replace agri_income_45_2 = -9 if key == "uuid:78498830-729b-4669-a8b0-ddb3ba898a73"
replace agri_income_45_1 = -9 if key == "uuid:2a436357-13ff-4710-a749-b012d58d5685"
replace agri_income_45_1 = -9 if key == "uuid:78498830-729b-4669-a8b0-ddb3ba898a73"
replace agri_income_36_2 = -9 if key == "uuid:f2320249-e402-4c29-aea1-6c2dab838a8b"
replace agri_income_36_1 = -9 if key == "uuid:f2320249-e402-4c29-aea1-6c2dab838a8b"
replace agri_income_33 = -9 if key == "uuid:a7a54357-649f-4f1e-b7f1-ca2977436360"
replace agri_income_33 = -9 if key == "uuid:723843da-05ed-40ec-a63f-3a0374e444c9"
replace agri_income_33 = -9 if key == "uuid:245c21d7-f36b-4083-9a15-27de32aaf8e0"
replace agri_income_33 = -9 if key == "uuid:88167bbe-853b-48b8-a3f9-6bbb02c12309"
replace agri_income_33 = -9 if key == "uuid:04f3040a-9991-412d-9fce-9ee840eafcea"
replace agri_income_33 = -9 if key == "uuid:6b2af6f0-abd9-40ce-8bb7-792c1e9e0e18"
replace agri_income_33 = -9 if key == "uuid:17b1c705-ed89-443b-8ddc-4ca93f033edd"
replace agri_income_33 = -9 if key == "uuid:dedd712c-634c-4665-a874-f139341ecd5f"
replace agri_income_33 = -9 if key == "uuid:f5ebb1fa-32f5-47fd-8d6b-ffdaa02d551e"
replace agri_income_33 = -9 if key == "uuid:64a4197f-9a39-4143-8f47-e2fa2e45b5f6"
replace agri_income_33 = -9 if key == "uuid:f8968dc5-d7d2-48ef-b238-31677e5060f8"
replace agri_income_33 = -9 if key == "uuid:e62f05aa-7c34-4c69-95d6-f064f3d20cde"
replace agri_income_23_2 = -9 if key == "uuid:2a436357-13ff-4710-a749-b012d58d5685"
replace agri_income_23_2 = -9 if key == "uuid:8915a062-0f9a-4c85-a7a6-1b4fa6b3e3f1"
replace agri_income_23_1 = -9 if key == "uuid:a0de5050-073d-47e2-934a-cf2cc8d2c532"
replace agri_income_23_1 = -9 if key == "uuid:2a436357-13ff-4710-a749-b012d58d5685"
replace agri_income_23_1 = -9 if key == "uuid:53f60c19-7569-47c2-9423-ee4f516907c9"
replace agri_income_23_1 = -9 if key == "uuid:2d69cae2-bc11-4173-a5df-4264bd41d410"
replace agri_income_23_1 = -9 if key == "uuid:8befef83-7f84-46ca-87f6-742b686956e6"
replace agri_income_23_1 = -9 if key == "uuid:46f5d5d9-d7d5-41a2-abe2-014313e781cf"
replace agri_income_23_1 = -9 if key == "uuid:723843da-05ed-40ec-a63f-3a0374e444c9"
replace agri_income_23_1 = -9 if key == "uuid:ca25ba07-535e-4cc2-a8c7-2fa5072d9318"
replace agri_income_23_1 = -9 if key == "uuid:0b997d0d-f27c-4fb5-bca7-42e6220b29c4"
replace agri_income_23_1 = -9 if key == "uuid:245c21d7-f36b-4083-9a15-27de32aaf8e0"
replace agri_income_23_1 = -9 if key == "uuid:b4135843-09e3-44e8-b649-7f6dbd35f542"
replace agri_income_23_1 = -9 if key == "uuid:0be6fc2e-5699-49b5-9b31-d924e7ad7581"
replace agri_income_23_1 = -9 if key == "uuid:26971b58-f29b-4ca2-835b-f25a19f057c3"
replace agri_income_23_1 = -9 if key == "uuid:8915a062-0f9a-4c85-a7a6-1b4fa6b3e3f1"
replace agri_income_23_1 = -9 if key == "uuid:02a39efd-23f1-4815-9b17-ff8b43173d90"
replace agri_income_23_1 = -9 if key == "uuid:32246f7b-b517-478d-b4f2-f8ab414ee1b2"
replace agri_income_23_1 = -9 if key == "uuid:4d1f8b31-796d-4edf-80d4-823d5fc08571"
replace agri_income_23_1 = -9 if key == "uuid:abd77c0d-982e-4867-b847-9531494e4578"
replace agri_income_23_1 = -9 if key == "uuid:dedd712c-634c-4665-a874-f139341ecd5f"
replace agri_income_23_1 = -9 if key == "uuid:78498830-729b-4669-a8b0-ddb3ba898a73"
replace agri_income_23_1 = -9 if key == "uuid:fe254168-10ee-4b8e-bfe5-5e3d6e47d26e"
replace agri_income_23_1 = -9 if key == "uuid:7d5ce99f-c798-473b-b2f0-e87458bb972f"
replace agri_income_23_1 = -9 if key == "uuid:3edcedd7-4992-486e-a924-22eb67a877b3"
replace agri_income_23_1 = -9 if key == "uuid:bb216791-2b51-4b42-9f67-8616f652ec33"
replace agri_income_23_1 = -9 if key == "uuid:abb87752-4a63-446c-9b08-114b67de3f6e"
replace agri_income_23_1 = -9 if key == "uuid:49e1ea67-b6bc-4685-822a-04e4963bbd19"
replace agri_income_23_1 = -9 if key == "uuid:197be989-16e8-4ef0-b91f-a6cb3287c2d8"
replace agri_income_23_1 = -9 if key == "uuid:e62f05aa-7c34-4c69-95d6-f064f3d20cde"
replace agri_income_23_1 = -9 if key == "uuid:f0bebe93-a4f0-40a0-8936-233682b356d1"
replace agri_income_19 = -9 if key == "uuid:53f60c19-7569-47c2-9423-ee4f516907c9"
replace agri_income_10_1 = -9 if key == "uuid:53f60c19-7569-47c2-9423-ee4f516907c9"
replace agri_income_06 = -9 if key == "uuid:458de09c-ccc6-4759-b192-8dc7c6112bc4"
replace agri_income_06 = -9 if key == "uuid:4478880a-f8ca-4a4c-9eb3-67465800791b"
replace agri_income_06 = -9 if key == "uuid:2a436357-13ff-4710-a749-b012d58d5685"
replace agri_income_06 = -9 if key == "uuid:53f60c19-7569-47c2-9423-ee4f516907c9"
replace agri_income_06 = -9 if key == "uuid:0af345d0-6960-4805-899a-3123a7c1a547"
replace agri_income_06 = -9 if key == "uuid:e707c317-45bd-4729-9216-380a140db29d"
replace agri_income_06 = -9 if key == "uuid:a7a54357-649f-4f1e-b7f1-ca2977436360"
replace agri_income_06 = -9 if key == "uuid:723843da-05ed-40ec-a63f-3a0374e444c9"
replace agri_income_06 = -9 if key == "uuid:ca25ba07-535e-4cc2-a8c7-2fa5072d9318"
replace agri_income_06 = -9 if key == "uuid:c2d6bc2b-f7cb-42d7-a0ef-b6c79d316202"
replace agri_income_06 = -9 if key == "uuid:f2320249-e402-4c29-aea1-6c2dab838a8b"
replace agri_income_06 = -9 if key == "uuid:b4135843-09e3-44e8-b649-7f6dbd35f542"
replace agri_income_06 = -9 if key == "uuid:0be6fc2e-5699-49b5-9b31-d924e7ad7581"
replace agri_income_06 = -9 if key == "uuid:17b1c705-ed89-443b-8ddc-4ca93f033edd"
replace agri_income_06 = -9 if key == "uuid:32246f7b-b517-478d-b4f2-f8ab414ee1b2"
replace agri_income_06 = -9 if key == "uuid:abd77c0d-982e-4867-b847-9531494e4578"
replace agri_income_06 = -9 if key == "uuid:7d5ce99f-c798-473b-b2f0-e87458bb972f"
replace agri_income_06 = -9 if key == "uuid:3edcedd7-4992-486e-a924-22eb67a877b3"
replace agri_income_06 = -9 if key == "uuid:f5ebb1fa-32f5-47fd-8d6b-ffdaa02d551e"
replace agri_income_06 = -9 if key == "uuid:64a4197f-9a39-4143-8f47-e2fa2e45b5f6"
replace agri_income_06 = -9 if key == "uuid:bb216791-2b51-4b42-9f67-8616f652ec33"
replace agri_income_06 = -9 if key == "uuid:f1a3ca58-71ee-4f17-9a08-8b2b64343adb"
replace agri_income_06 = -9 if key == "uuid:f8968dc5-d7d2-48ef-b238-31677e5060f8"
replace agri_income_06 = -9 if key == "uuid:f0bebe93-a4f0-40a0-8936-233682b356d1"
replace agri_income_06 = -9 if key == "uuid:a398b76a-7378-444c-8717-36fb8d3d46df"
replace agri_income_05 = -9 if key == "uuid:458de09c-ccc6-4759-b192-8dc7c6112bc4"
replace agri_income_05 = -9 if key == "uuid:4478880a-f8ca-4a4c-9eb3-67465800791b"
replace agri_income_05 = -9 if key == "uuid:2a436357-13ff-4710-a749-b012d58d5685"
replace agri_income_05 = -9 if key == "uuid:53f60c19-7569-47c2-9423-ee4f516907c9"
replace agri_income_05 = -9 if key == "uuid:0af345d0-6960-4805-899a-3123a7c1a547"
replace agri_income_05 = -9 if key == "uuid:e707c317-45bd-4729-9216-380a140db29d"
replace agri_income_05 = -9 if key == "uuid:a7a54357-649f-4f1e-b7f1-ca2977436360"
replace agri_income_05 = -9 if key == "uuid:723843da-05ed-40ec-a63f-3a0374e444c9"
replace agri_income_05 = -9 if key == "uuid:ca25ba07-535e-4cc2-a8c7-2fa5072d9318"
replace agri_income_05 = -9 if key == "uuid:c2d6bc2b-f7cb-42d7-a0ef-b6c79d316202"
replace agri_income_05 = -9 if key == "uuid:f2320249-e402-4c29-aea1-6c2dab838a8b"
replace agri_income_05 = -9 if key == "uuid:b4135843-09e3-44e8-b649-7f6dbd35f542"
replace agri_income_05 = -9 if key == "uuid:0be6fc2e-5699-49b5-9b31-d924e7ad7581"
replace agri_income_05 = -9 if key == "uuid:17b1c705-ed89-443b-8ddc-4ca93f033edd"
replace agri_income_05 = -9 if key == "uuid:32246f7b-b517-478d-b4f2-f8ab414ee1b2"
replace agri_income_05 = -9 if key == "uuid:abd77c0d-982e-4867-b847-9531494e4578"
replace agri_income_05 = -9 if key == "uuid:7d5ce99f-c798-473b-b2f0-e87458bb972f"
replace agri_income_05 = -9 if key == "uuid:3edcedd7-4992-486e-a924-22eb67a877b3"
replace agri_income_05 = -9 if key == "uuid:f5ebb1fa-32f5-47fd-8d6b-ffdaa02d551e"
replace agri_income_05 = -9 if key == "uuid:64a4197f-9a39-4143-8f47-e2fa2e45b5f6"
replace agri_income_05 = -9 if key == "uuid:bb216791-2b51-4b42-9f67-8616f652ec33"
replace agri_income_05 = -9 if key == "uuid:f1a3ca58-71ee-4f17-9a08-8b2b64343adb"
replace agri_income_05 = -9 if key == "uuid:f0bebe93-a4f0-40a0-8936-233682b356d1"
replace agri_income_05 = -9 if key == "uuid:a398b76a-7378-444c-8717-36fb8d3d46df"
replace agri_income_05 = -9 if key == "uuid:f8968dc5-d7d2-48ef-b238-31677e5060f8"
replace agri_income_03 = -9 if key == "uuid:4478880a-f8ca-4a4c-9eb3-67465800791b"
replace agri_income_03 = -9 if key == "uuid:c2d6bc2b-f7cb-42d7-a0ef-b6c79d316202"
replace agri_income_03 = -9 if key == "uuid:f8968dc5-d7d2-48ef-b238-31677e5060f8"
replace agri_6_40_a_2 = 150 if key == "uuid:2a436357-13ff-4710-a749-b012d58d5685"
replace agri_6_39_a_2 = 150 if key == "uuid:2a436357-13ff-4710-a749-b012d58d5685"
replace agri_6_15 = 4 if key == "uuid:a9b198b5-e8e9-457d-9967-1ac777669d76"
replace legumineuses_05_3 = 300 if key == "uuid:3de71594-b184-4126-bdd0-1e99174e5315"
replace legumineuses_05_3 = 300 if key == "uuid:4230989a-8a58-4ea0-a832-181386899bf5"
replace legumineuses_05_3 = 300 if key == "uuid:6fc043eb-a620-4e71-bd62-850b4b3b79cd"
replace legumineuses_05_3 = 300 if key == "uuid:97dc0ddf-0488-42f5-93b3-1a9a7a87392d"
replace legumineuses_05_3 = 300 if key == "uuid:f025d0b7-08f1-437b-939b-a95a66b3b39d"
replace legumineuses_05_3 = 300 if key == "uuid:2da8fe71-6f6c-40ed-8dd0-49b40dd055b8"
replace legumineuses_05_3 = 300 if key == "uuid:eaf3e868-5a1e-48d1-bece-b675c34e425a"
replace legumineuses_05_3 = 300 if key == "uuid:13dded24-5be3-4260-84f2-d21039e11a1f"
replace legumineuses_05_3 = 300 if key == "uuid:87103ba2-f2d4-4329-8036-5bb0e5031d8f"
replace legumineuses_05_3 = 300 if key == "uuid:46d8ef56-4b41-417a-ad49-c81ac7ef5c92"
replace legumineuses_05_3 = 300 if key == "uuid:a293c39a-aa3c-44d9-9a3f-eddd380e085d"
replace legumineuses_05_3 = 300 if key == "uuid:a7a1c870-882a-4b27-84b7-c365f5fa62f4"
replace legumineuses_05_3 = 300 if key == "uuid:1dd3537b-f2c5-42c9-b8a7-21b01eeba7b2"
replace legumineuses_05_3 = 300 if key == "uuid:90310a87-9d8f-4524-b415-99b443a9cd71"
replace legumineuses_05_3 = 300 if key == "uuid:8ac465af-4f5f-464a-8f10-8ee629685c2c"
replace legumineuses_05_3 = 300 if key == "uuid:6bda2cc5-561c-478d-87db-6953054f512a"
replace legumineuses_05_3 = 300 if key == "uuid:1b43c0eb-5240-4d9a-83be-9cf8cd944a5f"
replace legumineuses_05_3 = 300 if key == "uuid:79cf1220-8069-4576-9ce5-5bafd31008a2"
replace legumineuses_05_3 = 300 if key == "uuid:2afb8c60-9a10-45ea-ab67-8c33edc7c87f"
replace legumineuses_05_3 = 300 if key == "uuid:3939fdcd-4ec2-4c5c-afe4-3dc54ed4d56d"
replace legumineuses_05_3 = 300 if key == "uuid:a3a197e6-78f4-4a68-84cf-ec16ebd16e50"
replace legumineuses_05_3 = 300 if key == "uuid:15a3df40-050c-48aa-b4bb-339077411dba"
replace legumineuses_05_3 = 300 if key == "uuid:c0699877-0821-48c5-ab23-58a3c4021f7d"
replace legumineuses_05_3 = 300 if key == "uuid:08f0ed54-98f9-4427-9b44-4e660b0b587d"
replace legumineuses_05_3 = 300 if key == "uuid:8a204875-4a17-429f-a218-e406d7c726ae"
replace legumineuses_05_3 = 300 if key == "uuid:84022303-60da-4955-8d55-0a9ba4c498c9"
replace legumineuses_05_1 = 300 if key == "uuid:e4b75bd0-1a73-4d45-8c87-88860e018ba3"
replace legumineuses_05_1 = 300 if key == "uuid:6fc043eb-a620-4e71-bd62-850b4b3b79cd"
replace legumineuses_05_1 = 300 if key == "uuid:97dc0ddf-0488-42f5-93b3-1a9a7a87392d"
replace legumineuses_05_1 = 300 if key == "uuid:f025d0b7-08f1-437b-939b-a95a66b3b39d"
replace legumineuses_05_1 = 300 if key == "uuid:2da8fe71-6f6c-40ed-8dd0-49b40dd055b8"
replace legumineuses_05_1 = 300 if key == "uuid:eaf3e868-5a1e-48d1-bece-b675c34e425a"
replace legumineuses_05_1 = 300 if key == "uuid:d64a294e-43b9-44cd-aab0-d14bc88d71de"
replace legumineuses_05_1 = 300 if key == "uuid:632fc82d-6219-4350-8762-928ec98db7a5"
replace legumineuses_05_1 = 300 if key == "uuid:61320229-0c02-48f3-8f7e-de956c47901f"
replace legumineuses_05_1 = 300 if key == "uuid:08f0ed54-98f9-4427-9b44-4e660b0b587d"
replace legumineuses_01_5 = 300 if key == "uuid:cfd81b39-f5e3-40d4-aab0-4b7c3d2da1bd"
replace legumes_05_6 = 1000 if key == "uuid:d64a294e-43b9-44cd-aab0-d14bc88d71de"
replace legumes_05_3 = 600 if key == "uuid:4230989a-8a58-4ea0-a832-181386899bf5"
replace legumes_05_1 = 100 if key == "uuid:d64a294e-43b9-44cd-aab0-d14bc88d71de"
replace legumes_05_1 = 100 if key == "uuid:632fc82d-6219-4350-8762-928ec98db7a5"
replace legumes_04_1 = 100 if key == "uuid:08f0ed54-98f9-4427-9b44-4e660b0b587d"
replace legumes_02_6 = 875 if key == "uuid:d64a294e-43b9-44cd-aab0-d14bc88d71de"
replace legumes_02_6 = 18000 if key == "uuid:90310a87-9d8f-4524-b415-99b443a9cd71"
replace legumes_02_6 = 12000 if key == "uuid:08f0ed54-98f9-4427-9b44-4e660b0b587d"
replace legumes_02_3 = -9 if key == "uuid:4230989a-8a58-4ea0-a832-181386899bf5"
replace legumes_02_3 = 20000 if key == "uuid:15a3df40-050c-48aa-b4bb-339077411dba"
replace legumes_02_3 = 16000 if key == "uuid:08f0ed54-98f9-4427-9b44-4e660b0b587d"
replace legumes_02_1 = 22400 if key == "uuid:6fc043eb-a620-4e71-bd62-850b4b3b79cd"
replace legumes_02_1 = 10500 if key == "uuid:97dc0ddf-0488-42f5-93b3-1a9a7a87392d"
replace legumes_02_1 = 875000 if key == "uuid:d64a294e-43b9-44cd-aab0-d14bc88d71de"
replace legumes_02_1 = 12000 if key == "uuid:08f0ed54-98f9-4427-9b44-4e660b0b587d"
replace health_5_12_8 = 475 if key == "uuid:3277d981-1a8d-4f93-abdc-a725b428e0ab"
replace health_5_12_8 = 475 if key == "uuid:3277d981-1a8d-4f93-abdc-a725b428e0ab"
replace health_5_12_5 = 286 if key == "uuid:f953cc65-f449-4a67-bab4-853b16aabad1"
replace health_5_12_5 = 286 if key == "uuid:f953cc65-f449-4a67-bab4-853b16aabad1"
replace cereals_02_1 = 15750 if key == "uuid:33c5b9d4-3cf2-4d87-af16-2a2489b94563"
replace cereals_02_1 = 12800 if key == "uuid:999e3d4e-a660-48e8-bfa2-146829966c60"
replace cereals_02_1 = 23360 if key == "uuid:008de754-4ff1-43e5-ae4d-21d1760039e2"
replace cereals_01_1 = 0.96 if key == "uuid:cfd81b39-f5e3-40d4-aab0-4b7c3d2da1bd"
replace cereals_01_1 = 0.5 if key == "uuid:b882b825-d605-489e-adde-cde2e46412ca"
replace agri_income_29 = -9 if key == "uuid:4230989a-8a58-4ea0-a832-181386899bf5"
replace agri_income_23_2 = 50000 if key == "uuid:1b43c0eb-5240-4d9a-83be-9cf8cd944a5f"
replace agri_income_23_2 = -9 if key == "uuid:a3b4a2de-dfd2-4985-9f7f-88f577cbde09"
replace agri_income_23_1 = -9 if key == "uuid:6fc043eb-a620-4e71-bd62-850b4b3b79cd"
replace agri_income_23_1 = 100000 if key == "uuid:d64a294e-43b9-44cd-aab0-d14bc88d71de"
replace agri_income_23_1 = -9 if key == "uuid:ef0ba8e1-fdef-45f1-9218-25f9493d122e"
replace agri_income_23_1 = -9 if key == "uuid:755e6213-1a72-4412-b634-a3e3259586ea"
replace agri_income_23_1 = 70000 if key == "uuid:f953cc65-f449-4a67-bab4-853b16aabad1"
replace agri_income_23_1 = -9 if key == "uuid:147fc8cf-acbe-4e51-aa7b-8eb92b783fd0"
replace agri_income_23_1 = 90000 if key == "uuid:ecaa2080-ac3e-4b5b-b24e-9f4fdd3045d1"
replace agri_income_19 = -9 if key == "uuid:4230989a-8a58-4ea0-a832-181386899bf5"
replace agri_income_19 = 35000 if key == "uuid:0098d853-e835-46f6-a1bd-85d8fad95430"
replace agri_income_07_2 = -9 if key == "uuid:cfd81b39-f5e3-40d4-aab0-4b7c3d2da1bd"
replace agri_6_41_a_code_1 = 1 if key == "uuid:4230989a-8a58-4ea0-a832-181386899bf5"
replace agri_6_41_a_1 = 0 if key == "uuid:4230989a-8a58-4ea0-a832-181386899bf5"
replace agri_6_40_a_code_1 = 1 if key == "uuid:4230989a-8a58-4ea0-a832-181386899bf5"
replace agri_6_40_a_1 = 0 if key == "uuid:4230989a-8a58-4ea0-a832-181386899bf5"
replace agri_6_39_a_code_1 = 1 if key == "uuid:4230989a-8a58-4ea0-a832-181386899bf5"
replace agri_6_39_a_1 = 0 if key == "uuid:4230989a-8a58-4ea0-a832-181386899bf5"
replace agri_6_39_a_1 = 0 if key == "uuid:08f631fa-6d83-4a77-a67a-8334ac852020"
replace agri_6_38_a_code_1 = 1 if key == "uuid:4230989a-8a58-4ea0-a832-181386899bf5"
replace agri_6_38_a_1 = 0 if key == "uuid:4230989a-8a58-4ea0-a832-181386899bf5"
replace agri_6_38_a_1 = 300 if key == "uuid:08f631fa-6d83-4a77-a67a-8334ac852020"
replace agri_6_38_a_1 = 150 if key == "uuid:33a452d5-07a7-4109-ad3a-23a2e070c05d"
replace legumineuses_05_3 = 300 if key == "uuid:e6aa3f68-59ac-4a4a-8133-f78ae9191520"
replace legumineuses_05_3 = 300 if key == "uuid:e3d4afc3-003b-4cf9-ac93-63c39fbaa1c3"
replace legumineuses_05_3 = 300 if key == "uuid:76a14944-05df-4adc-ab7b-31fd606fa43a"
replace legumineuses_05_3 = 300 if key == "uuid:a7f9dee5-eae8-474c-926c-683d4aa1f9af"
replace legumineuses_05_3 = 300 if key == "uuid:b57eac61-3653-4fbc-99df-a46c5eb5fa34"
replace legumineuses_05_3 = 300 if key == "uuid:561bd9b2-ac60-427c-88a3-95522789fb6c"
replace legumineuses_05_3 = 300 if key == "uuid:45f1a91f-0849-4024-b948-06be93be0c24"
replace hh_education_level_7 = 2 if key == "uuid:d447c4ab-ff09-4eed-8e1e-948a34e6e6bf"
replace age_5 = 9 if key == "uuid:032096e6-8a3f-45f6-aa8f-3281668a0dc4"
replace age_2 = 10 if key == "uuid:e70a0dfe-c497-413b-9432-7fb876a24783"
replace hh_41_7 = 7 if key == "uuid:a6218164-0bc6-47bc-b937-15e0f66a0a1a"
replace hh_41_6 = 7 if key == "uuid:b0a54e9c-c1e3-4274-8dd3-f3e452663310"
replace hh_41_12 = 7 if key == "uuid:4839ecdd-b500-45b6-92b0-aa6ed8f890de"
replace hh_41_1 = 7 if key == "uuid:d18cf803-5676-4b48-8cde-8d83bd2d9a7b"
replace correct_hh = 1 if key == "uuid:c1beb54f-5d84-45b2-b98b-2c299cb4d1e0"
replace correct_hh = 1 if key == "uuid:32a37739-cc2d-4484-aa12-d94e5fdddf34"
replace cereals_04_1 = 2350 if key == "uuid:b0a54e9c-c1e3-4274-8dd3-f3e452663310"
replace animals_sales_o = 0 if key == "uuid:3b718a1d-8e4f-4317-ab88-016ed99f1297"
replace agri_income_47_1 = 750 if key == "uuid:88eea8c9-1659-4f5b-918b-2a57e12e4f41"
replace agri_income_33 = 150000 if key == "uuid:32a37739-cc2d-4484-aa12-d94e5fdddf34"
replace agri_6_40_a_code_2 = 1 if key == "uuid:130ea232-8ff7-4658-8a8f-1eced4492864"
replace agri_6_39_a_1 = 50 if key == "uuid:927795d3-0966-4cc6-9bd2-0ceee0f8bbe8"
replace agri_6_38_a_code_1 = 1 if key == "uuid:927795d3-0966-4cc6-9bd2-0ceee0f8bbe8"
replace legumineuses_05_4 = 350 if key == "uuid:b1340e73-1f75-4dbb-9d05-ea6013d18be8"
replace legumineuses_05_4 = 350 if key == "uuid:4eaf0711-0729-4c4d-8579-6c57d480a107"
replace legumineuses_05_3 = 350 if key == "uuid:dc59b470-a0e6-47f5-ac3f-0eadff97d6cf"
replace legumineuses_05_3 = 350 if key == "uuid:ba3f8490-acfc-469b-a958-13cf64cfb49c"
replace legumineuses_05_3 = 350 if key == "uuid:4b9d032f-e2ac-4e4f-b7f2-bad5b9917eaf"
replace legumineuses_05_1 = 350 if key == "uuid:601d622d-c37b-4290-8a41-0bf9495a5f4b"
replace legumineuses_05_1 = 350 if key == "uuid:c69f2cf6-9a54-4da7-bf19-742730f95d42"
replace hh_education_level_7 = 3 if key == "uuid:ce4348d4-f8dc-4f45-859b-f7fb9e9c8222"
replace hh_education_level_5 = 3 if key == "uuid:749d6e2c-6917-439f-8e0a-ac743dee1e1d"
replace hh_education_level_5 = 3 if key == "uuid:140ccd1f-98cc-4f31-ae6e-948f6b7c88c8"
replace hh_education_level_5 = 5 if key == "uuid:4b9d032f-e2ac-4e4f-b7f2-bad5b9917eaf"
replace hh_education_level_4 = 3 if key == "uuid:4b9d032f-e2ac-4e4f-b7f2-bad5b9917eaf"
replace hh_education_level_3 = 2 if key == "uuid:1d771bb9-ca40-400d-aeb9-182485e92589"
replace hh_education_level_1 = 4 if key == "uuid:83d16bd0-281f-4b48-9619-8e53f666105d"
replace hh_education_level_1 = 2 if key == "uuid:12f0edf6-afb5-4181-aa03-cd6579a26cdb"
replace farines_02_1 = 1200 if key == "uuid:6a21258a-e5af-4762-ad75-fd2a7001d74f"
replace farines_02_1 = 1800 if key == "uuid:4b9d032f-e2ac-4e4f-b7f2-bad5b9917eaf"
replace correct_hh = 1 if key == "uuid:a6f0743b-8184-4c0f-b9bc-7682aa54ddd2"
replace correct_hh = 1 if key == "uuid:9ba0ccb1-81f1-4fc1-8259-c017cc09a2e6"
replace cereals_05_1 = 350 if key == "uuid:5876db44-bf51-4cb8-9785-c206925c8c68"
replace animals_sales_o = 0 if key == "uuid:c4eeb818-38e3-4bf0-9740-65ee640b3b07"
replace animals_sales_o = 0 if key == "uuid:83d16bd0-281f-4b48-9619-8e53f666105d"
replace animals_sales_o = 0 if key == "uuid:b0cc8236-42e5-40d1-a1f4-1998fed901a6"
replace animals_sales_o = 0 if key == "uuid:0e83e417-47b6-4bcb-b804-2eff61224146"
replace animals_sales_o = 0 if key == "uuid:4d85d589-361b-486a-b9d7-5fc360250957"
replace agri_6_28_1 = 0 if key == "uuid:f11f6582-306e-4554-aaa3-bcf06916a028"
replace agri_6_28_1 = 0 if key == "uuid:04bf1d7a-e81d-46f0-9803-e2996d266783"
replace agri_6_28_1 = 0 if key == "uuid:9b3ebbb1-7d43-4b1b-8776-c61ec72e14e5"
replace agri_6_28_1 = 0 if key == "uuid:2545d1e5-f0e6-4273-aa34-f0b39cceb63e"
replace agri_6_28_1 = 0 if key == "uuid:a2ef3ba5-40ad-4486-959b-b3562888762b"
replace agri_6_28_1 = 0 if key == "uuid:3efff56a-4017-4f34-84bd-cae43118ba3a"
replace agri_6_28_1 = 0 if key == "uuid:388e79fb-3447-4308-baf5-a2cde4d0793f"
replace o_culture_05 = 450 if key == "uuid:d4dcf0ad-efdb-4b52-a2c8-fc30bb8eabdf"
replace o_culture_01 = 0.01 if key == "uuid:3cd8450d-12a4-4346-aaa3-296c1d64bfd0"
replace legumineuses_05_4 = 0 if key == "uuid:397fd602-9a30-4d8b-a9ba-7f46497e6648"
replace legumineuses_05_3 = 0 if key == "uuid:2bb8d593-96ee-4652-8db4-65eae2b880fe"
replace legumineuses_05_3 = 0 if key == "uuid:397fd602-9a30-4d8b-a9ba-7f46497e6648"
replace legumineuses_05_3 = 0 if key == "uuid:8cef28bf-69aa-4f98-ba16-f91f4c60a8ab"
replace legumineuses_05_1 = 0 if key == "uuid:6d42c33e-1ded-4d5c-9ff8-a820cadae74e"
replace legumineuses_05_1 = 0 if key == "uuid:7ed347b8-1b9b-45af-b6c5-94fccc9f2605"
replace legumineuses_05_1 = 0 if key == "uuid:397fd602-9a30-4d8b-a9ba-7f46497e6648"
replace legumes_03_3 = 150 if key == "uuid:397fd602-9a30-4d8b-a9ba-7f46497e6648"
replace legumes_02_3 = -9 if key == "uuid:397fd602-9a30-4d8b-a9ba-7f46497e6648"
replace legumes_02_1 = 16000 if key == "uuid:397fd602-9a30-4d8b-a9ba-7f46497e6648"
replace legumes_01_1 = 0.03 if key == "uuid:7ed347b8-1b9b-45af-b6c5-94fccc9f2605"
replace hh_phone = 784117241 if key == "uuid:e1bbc0b1-e691-4976-814a-8a93127e1859"
replace hh_phone = 702092808 if key == "uuid:47e49c11-a7c8-4f84-ad73-cecb40bacc62"
replace hh_phone = 775645965 if key == "uuid:7a2ce175-761d-4e57-a6f4-d95e1e8734b6"
replace hh_phone = 770352867 if key == "uuid:f52bbf3d-5e16-427d-b9d4-7746957440c9"
replace hh_phone = 782705821 if key == "uuid:981d55fa-1a2e-47e6-8ffb-d707ae9519a4"
replace hh_phone = 783222370 if key == "uuid:83139d1d-2f8e-4508-a16f-ab293c21e60e"
replace hh_education_level_5 = -9 if key == "uuid:83daaf4c-5cd4-4774-9364-769d8a3d97e4"
replace hh_education_level_4 = 1 if key == "uuid:6d1c58cb-27ce-4ac2-81ec-cf85b2c2c772"
replace hh_education_level_4 = 2 if key == "uuid:c2a63575-25c7-4189-90a2-68a5f7140b9e"
replace age_3 = 95 if key == "uuid:274749b0-85ce-4907-97b2-f15fae16e9bb"
replace hh_14_b_8 = 300 if key == "uuid:79e1a0b4-c1c2-4b85-89f7-854a3b3fbc1e"
replace hh_14_b_12 = 300 if key == "uuid:79e1a0b4-c1c2-4b85-89f7-854a3b3fbc1e"
replace hh_14_b_1 = 300 if key == "uuid:79e1a0b4-c1c2-4b85-89f7-854a3b3fbc1e"
replace health_5_12_10 = 18 if key == "uuid:db4102ab-0745-4f42-83cd-9d64bfb746d7"
replace health_5_12_10 = 18 if key == "uuid:db4102ab-0745-4f42-83cd-9d64bfb746d7"
replace health_5_12_7 = 18 if key == "uuid:db4102ab-0745-4f42-83cd-9d64bfb746d7"
replace health_5_12_7 = 18 if key == "uuid:db4102ab-0745-4f42-83cd-9d64bfb746d7"
replace health_5_12_1 = 4 if key == "uuid:f52bbf3d-5e16-427d-b9d4-7746957440c9"
replace health_5_12_1 = 4 if key == "uuid:f52bbf3d-5e16-427d-b9d4-7746957440c9"
replace health_5_12_4 = 30 if key == "uuid:6040d2eb-1fae-4730-91e1-6e4f7bb98dfa"
replace health_5_12_4 = 30 if key == "uuid:6040d2eb-1fae-4730-91e1-6e4f7bb98dfa"
replace health_5_12_2 = 30 if key == "uuid:a9d8381b-470f-4704-9042-4af983b17990"
replace health_5_12_2 = 30 if key == "uuid:a9d8381b-470f-4704-9042-4af983b17990"
replace health_5_12_5 = 30 if key == "uuid:a9d8381b-470f-4704-9042-4af983b17990"
replace health_5_12_5 = 30 if key == "uuid:a9d8381b-470f-4704-9042-4af983b17990"
replace health_5_12_2 = 3 if key == "uuid:e42a568c-18ce-4032-a056-5a490e64ae65"
replace health_5_12_2 = 3 if key == "uuid:e42a568c-18ce-4032-a056-5a490e64ae65"
replace health_5_12_5 = -9 if key == "uuid:128199d5-45c7-4c42-b56f-cbfadf72b88c"
replace health_5_12_5 = -9 if key == "uuid:128199d5-45c7-4c42-b56f-cbfadf72b88c"
replace health_5_12_6 = -9 if key == "uuid:128199d5-45c7-4c42-b56f-cbfadf72b88c"
replace health_5_12_6 = -9 if key == "uuid:128199d5-45c7-4c42-b56f-cbfadf72b88c"
replace health_5_12_2 = 115 if key == "uuid:032d2166-f476-4d12-bfe5-24ecb751b556"
replace health_5_12_11 = 25 if key == "uuid:f59e8972-1bf4-4346-be57-fa08d8dae70a"
replace health_5_12_9 = 115 if key == "uuid:beafc02c-dc0d-4a2f-896e-e06ddfbebdab"
replace health_5_12_11 = 25 if key == "uuid:f59e8972-1bf4-4346-be57-fa08d8dae70a"
replace health_5_12_11 = 25 if key == "uuid:f59e8972-1bf4-4346-be57-fa08d8dae70a"
replace health_5_12_11 = 25 if key == "uuid:f59e8972-1bf4-4346-be57-fa08d8dae70a"
replace health_5_12_2 = 115 if key == "uuid:032d2166-f476-4d12-bfe5-24ecb751b556"
replace health_5_12_9 = 115 if key == "uuid:beafc02c-dc0d-4a2f-896e-e06ddfbebdab"
replace cereals_05_5 = 400 if key == "uuid:d3647dde-8f8b-4a1b-a7b8-7a1625ace056"
replace cereals_04_1 = 0 if key == "uuid:9e068357-e209-4055-a615-2ceeefc71a06"
replace cereals_03_1 = 1800 if key == "uuid:78b9d9fb-f6be-48cc-8f0e-c95caa4d88bd"
replace cereals_03_1 = 1000 if key == "uuid:9e068357-e209-4055-a615-2ceeefc71a06"
replace cereals_03_1 = 1000 if key == "uuid:41d0680a-3871-4f2a-92a6-52d45e652010"
replace cereals_02_1 = 5500 if key == "uuid:78b9d9fb-f6be-48cc-8f0e-c95caa4d88bd"
replace cereals_02_1 = -9 if key == "uuid:9e068357-e209-4055-a615-2ceeefc71a06"
replace cereals_02_1 = 40000 if key == "uuid:5a4e7e21-f224-48e5-aece-7f9d297dae48"
replace cereals_02_1 = -9 if key == "uuid:af2fa2b6-d183-4406-8d00-4be4c168e97b"
replace cereals_02_1 = 11000 if key == "uuid:e60944ff-9e24-4e10-b4a2-8439cf1f4eb8"
replace cereals_02_1 = 70000 if key == "uuid:397fd602-9a30-4d8b-a9ba-7f46497e6648"
replace cereals_02_1 = 31500 if key == "uuid:46693568-4859-402d-ab33-9639f9622ca1"
replace cereals_02_1 = 28000 if key == "uuid:5268be61-f198-4614-8dbe-6f18904c78be"
replace cereals_02_1 = 25000 if key == "uuid:2b46e567-634a-45f4-abbd-e0174c03900d"
replace cereals_02_1 = 17700 if key == "uuid:beafc02c-dc0d-4a2f-896e-e06ddfbebdab"
replace cereals_01_1 = 0.5 if key == "uuid:274749b0-85ce-4907-97b2-f15fae16e9bb"
replace agri_income_48_1 = -9 if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980"
replace agri_income_47_1 = -9 if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980"
replace agri_income_45_3 = -9 if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980"
replace agri_income_33 = 112500 if key == "uuid:6040d2eb-1fae-4730-91e1-6e4f7bb98dfa"
replace agri_income_33 = 125000 if key == "uuid:a9d8381b-470f-4704-9042-4af983b17990"
replace agri_income_29 = -9 if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980"
replace agri_income_23_3 = -9 if key == "uuid:af2fa2b6-d183-4406-8d00-4be4c168e97b"
replace agri_income_23_2 = -9 if key == "uuid:2bb8d593-96ee-4652-8db4-65eae2b880fe"
replace agri_income_23_2 = -9 if key == "uuid:af2fa2b6-d183-4406-8d00-4be4c168e97b"
replace agri_income_23_2 = -9 if key == "uuid:66b0b7d0-c37f-4ed4-9b1f-72bb0583ba96"
replace agri_income_23_1 = -9 if key == "uuid:8d65b726-e9bc-49af-bcbc-762f36075dc8"
replace agri_income_23_1 = -9 if key == "uuid:76e1afe0-c769-48fe-843a-4c17f85fdbec"
replace agri_income_23_1 = -9 if key == "uuid:d3647dde-8f8b-4a1b-a7b8-7a1625ace056"
replace agri_income_23_1 = -9 if key == "uuid:5f863611-f2c8-46aa-b747-7c0081328ac3"
replace agri_income_23_1 = -9 if key == "uuid:c51053da-4b7f-447a-94ca-7576bc6259c6"
replace agri_income_23_1 = -9 if key == "uuid:fee45475-a2e7-453b-aa2d-20bc077e1247"
replace agri_income_23_1 = -9 if key == "uuid:de493f3d-0dd1-4090-a9eb-3a0e67225367"
replace agri_income_23_1 = -9 if key == "uuid:6f13c3cb-d0dd-4c27-b73b-c9a6843687c5"
replace agri_income_23_1 = -9 if key == "uuid:47e49c11-a7c8-4f84-ad73-cecb40bacc62"
replace agri_income_23_1 = -9 if key == "uuid:83daaf4c-5cd4-4774-9364-769d8a3d97e4"
replace agri_income_23_1 = -9 if key == "uuid:03f80375-e27b-4aee-80f2-983af72db81e"
replace agri_income_23_1 = -9 if key == "uuid:af2fa2b6-d183-4406-8d00-4be4c168e97b"
replace agri_income_23_1 = -9 if key == "uuid:c2a63575-25c7-4189-90a2-68a5f7140b9e"
replace agri_income_23_1 = -9 if key == "uuid:6040d2eb-1fae-4730-91e1-6e4f7bb98dfa"
replace agri_income_23_1 = -9 if key == "uuid:634c64a4-3dc4-44bd-9a93-3502cfb663c9"
replace agri_income_23_1 = -9 if key == "uuid:87ecb9b2-7218-4e4d-a645-f1c780305504"
replace agri_income_23_1 = -9 if key == "uuid:128199d5-45c7-4c42-b56f-cbfadf72b88c"
replace agri_income_23_1 = -9 if key == "uuid:008b2d0c-9a04-4426-94d6-7b9b9a83cfc4"
replace agri_income_23_1 = -9 if key == "uuid:a621035f-2fcc-4ada-b25b-8ec0e6d6090c"
replace agri_income_23_1 = -9 if key == "uuid:4a5d7d2a-5de0-435e-af76-30d1ef85e5c0"
replace agri_income_23_1 = -9 if key == "uuid:79e1a0b4-c1c2-4b85-89f7-854a3b3fbc1e"
replace agri_income_23_1 = -9 if key == "uuid:46693568-4859-402d-ab33-9639f9622ca1"
replace agri_income_23_1 = -9 if key == "uuid:83139d1d-2f8e-4508-a16f-ab293c21e60e"
replace agri_income_23_1 = -9 if key == "uuid:beafc02c-dc0d-4a2f-896e-e06ddfbebdab"
replace agri_income_19 = -9 if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980"
replace agri_income_16 = 2 if key == "uuid:beafc02c-dc0d-4a2f-896e-e06ddfbebdab"
replace agri_income_12_o = 0 if key == "uuid:bf294ba7-b237-4550-99e3-0a17d8d3e2f9"
replace agri_income_12_2 = 300000 if key == "uuid:7a2ce175-761d-4e57-a6f4-d95e1e8734b6"
replace agri_income_12_1 = 300000 if key == "uuid:7a2ce175-761d-4e57-a6f4-d95e1e8734b6"
replace agri_income_11_o = 0 if key == "uuid:bf294ba7-b237-4550-99e3-0a17d8d3e2f9"
replace agri_income_11_2 = 2 if key == "uuid:7a2ce175-761d-4e57-a6f4-d95e1e8734b6"
replace agri_income_11_1 = 2 if key == "uuid:7a2ce175-761d-4e57-a6f4-d95e1e8734b6"
replace agri_income_08_o = 0 if key == "uuid:bf294ba7-b237-4550-99e3-0a17d8d3e2f9"
replace agri_income_08_3 = -9 if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980"
replace agri_income_08_3 = 2 if key == "uuid:7a2ce175-761d-4e57-a6f4-d95e1e8734b6"
replace agri_income_08_2 = -9 if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980"
replace agri_income_08_1 = -9 if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980"
replace agri_income_08_1 = 2 if key == "uuid:7a2ce175-761d-4e57-a6f4-d95e1e8734b6"
replace agri_income_07_3 = -9 if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980"
replace agri_income_07_2 = -9 if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980"
replace agri_income_07_1 = -9 if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980"
replace agri_income_06 = 0 if key == "uuid:8b3ff069-df75-498b-a1f8-f51f2bd7c059"
replace agri_income_06 = 0 if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980"
replace agri_income_06 = 0 if key == "uuid:86f3cd49-ec04-42e4-8739-894d77d4df29"
replace agri_income_06 = 0 if key == "uuid:db4102ab-0745-4f42-83cd-9d64bfb746d7"
replace agri_income_06 = 0 if key == "uuid:397fd602-9a30-4d8b-a9ba-7f46497e6648"
replace agri_income_06 = 0 if key == "uuid:87dcb749-21ec-4806-bb69-da9d55f9f5ab"
replace agri_income_06 = 0 if key == "uuid:2b46e567-634a-45f4-abbd-e0174c03900d"
replace agri_income_06 = 0 if key == "uuid:032d2166-f476-4d12-bfe5-24ecb751b556"
replace agri_income_05 = 330000 if key == "uuid:bf294ba7-b237-4550-99e3-0a17d8d3e2f9"
replace agri_income_05 = -9 if key == "uuid:8b3ff069-df75-498b-a1f8-f51f2bd7c059"
replace agri_income_05 = -9 if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980"
replace agri_income_05 = 75000 if key == "uuid:86f3cd49-ec04-42e4-8739-894d77d4df29"
replace agri_income_05 = 100000 if key == "uuid:db4102ab-0745-4f42-83cd-9d64bfb746d7"
replace agri_income_05 = 50000 if key == "uuid:6040d2eb-1fae-4730-91e1-6e4f7bb98dfa"
replace agri_income_05 = -9 if key == "uuid:397fd602-9a30-4d8b-a9ba-7f46497e6648"
replace agri_income_05 = -9 if key == "uuid:87dcb749-21ec-4806-bb69-da9d55f9f5ab"
replace agri_income_05 = -9 if key == "uuid:2b46e567-634a-45f4-abbd-e0174c03900d"
replace agri_income_05 = 360000 if key == "uuid:032d2166-f476-4d12-bfe5-24ecb751b556"
replace agri_income_05 = 480000 if key == "uuid:f59e8972-1bf4-4346-be57-fa08d8dae70a"
replace agri_6_40_a_code_1 = 1 if key == "uuid:559b32b7-38a6-4ec1-bcac-d6299c6aeca9"
replace agri_6_40_a_code_1 = 1 if key == "uuid:8cef28bf-69aa-4f98-ba16-f91f4c60a8ab"
replace agri_6_39_a_code_1 = 1 if key == "uuid:87dcb749-21ec-4806-bb69-da9d55f9f5ab"
replace agri_6_39_a_code_1 = 1 if key == "uuid:a621035f-2fcc-4ada-b25b-8ec0e6d6090c"
replace agri_6_39_a_code_1 = 1 if key == "uuid:8cef28bf-69aa-4f98-ba16-f91f4c60a8ab"
replace agri_6_39_a_1 = 400 if key == "uuid:a621035f-2fcc-4ada-b25b-8ec0e6d6090c"
replace agri_6_37_1 = -9 if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980"
replace agri_6_28_1 = 0 if key == "uuid:196ef3f6-2b0c-4693-baaa-fe562c98fa9a"
replace agri_6_28_1 = 0 if key == "uuid:c2a63575-25c7-4189-90a2-68a5f7140b9e"
replace agri_6_28_1 = 0 if key == "uuid:6f2e56ec-3b05-4cb4-8f7f-e0b1fbdc5f05"
replace agri_6_28_1 = 0 if key == "uuid:8cef28bf-69aa-4f98-ba16-f91f4c60a8ab"
replace agri_6_21_1 = -9 if key == "uuid:99d26de9-4785-4ce7-8789-37db41354980"

* part 2  also note that the 0's have been corrected to -9's but this will toy with the total check which is not working well already
//replace hh_13_4_total = 48 if key == "uuid:01639e53-ecd4-43fe-bf12-bd59d60e79e6"
replace hh_13_4_1 = 24 if key == "uuid:01639e53-ecd4-43fe-bf12-bd59d60e79e6"
replace hh_13_4_2 = 24 if key == "uuid:01639e53-ecd4-43fe-bf12-bd59d60e79e6"
replace hh_10_4 = 48 if key == "uuid:01639e53-ecd4-43fe-bf12-bd59d60e79e6"

//replace hh_13_1_total = 42 if key == "uuid:a9b198b5-e8e9-457d-9967-1ac777669d76"
replace hh_13_1_1 = 8 if key == "uuid:a9b198b5-e8e9-457d-9967-1ac777669d76"
replace hh_13_1_2 = 1 if key == "uuid:a9b198b5-e8e9-457d-9967-1ac777669d76"
replace hh_13_1_3 = 0 if key == "uuid:a9b198b5-e8e9-457d-9967-1ac777669d76"
replace hh_13_1_4 = 18 if key == "uuid:a9b198b5-e8e9-457d-9967-1ac777669d76"
replace hh_13_1_5 = 15 if key == "uuid:a9b198b5-e8e9-457d-9967-1ac777669d76"
replace hh_10_1 = 42 if key == "uuid:a9b198b5-e8e9-457d-9967-1ac777669d76"

* part 3  
//replace hh_21_total_4 = 64 if key == "uuid:480e7175-e4f0-467b-ae3d-d2d3c957d314"
replace hh_21_4_1 = 28 if key == "uuid:480e7175-e4f0-467b-ae3d-d2d3c957d314"
replace hh_21_4_2 = 36 if key == "uuid:480e7175-e4f0-467b-ae3d-d2d3c957d314"

//replace hh_21_total_2 = 38 if key == "uuid:61ae58e8-67ed-407f-94e6-c83fe4454247"
replace hh_21_2_1 = 12 if key == "uuid:61ae58e8-67ed-407f-94e6-c83fe4454247"
replace hh_12_2_2 = 3 if key == "uuid:61ae58e8-67ed-407f-94e6-c83fe4454247"
replace hh_21_2_3 = 9 if key == "uuid:61ae58e8-67ed-407f-94e6-c83fe4454247"
replace hh_21_2_4 = 10 if key == "uuid:61ae58e8-67ed-407f-94e6-c83fe4454247"
replace hh_21_2_5 = 4 if key == "uuid:61ae58e8-67ed-407f-94e6-c83fe4454247"

//replace hh_21_total_3 = 73 if key == "uuid:4219536c-3d1b-4d77-a065-f63913f70d0e"
replace hh_21_3_1 = 16 if key == "uuid:4219536c-3d1b-4d77-a065-f63913f70d0e"
replace hh_21_3_2 = 7 if key == "uuid:4219536c-3d1b-4d77-a065-f63913f70d0e"
replace hh_21_3_3 = 14 if key == "uuid:4219536c-3d1b-4d77-a065-f63913f70d0e"
replace hh_21_3_4 = 7 if key == "uuid:4219536c-3d1b-4d77-a065-f63913f70d0e"
replace hh_21_3_5 = 12 if key == "uuid:4219536c-3d1b-4d77-a065-f63913f70d0e"
replace hh_21_3_6 = 8 if key == "uuid:4219536c-3d1b-4d77-a065-f63913f70d0e"
replace hh_21_3_7 = 9 if key == "uuid:4219536c-3d1b-4d77-a065-f63913f70d0e"

//replace hh_21_total_9 = 52 if key == "uuid:91d4c4b4-ac34-42e9-9e3d-c3491b708ca0"
replace hh_21_9_1 = 24 if key == "uuid:91d4c4b4-ac34-42e9-9e3d-c3491b708ca0"
replace hh_21_9_2 = 14 if key == "uuid:91d4c4b4-ac34-42e9-9e3d-c3491b708ca0"
replace hh_21_9_3 = 14 if key == "uuid:91d4c4b4-ac34-42e9-9e3d-c3491b708ca0"

* Save the corrected dataset
export delimited using "$corrected\CORRECTED_DISES_Enquête_ménage_midline_VF_WIDE_5Mar2025.csv", replace

save "$corrected\CORRECTED_DISES_Enquête_ménage_midline_VF_WIDE_5Mar2025.dta", replace


************************
*** CORRECTIONS 26Feb2025
************************
* excel formula
* ="replace ind_var = 0 if key == "&CHAR(34)&D2&CHAR(34)&" & "&M2&" == "&J2

* for the checks
/*
replace ind_var = 0 if key == "uuid:c4551c9e-c0c0-4f4a-b080-e07648e53697" & agri_income_06 == -9
replace ind_var = 0 if key == "uuid:0b37d7f9-43b1-4a23-b3f0-b41470b1fc34" & agri_income_06 == -9
replace ind_var = 0 if key == "uuid:14173965-524c-42ed-881d-7ba303969f5f" & agri_income_06 == -9

replace ind_var = 0 if key == "uuid:07815cfd-fc9e-42e6-823e-83d93c2b9461" & agri_income_07_o == -9

replace ind_var = 0 if key == "uuid:07815cfd-fc9e-42e6-823e-83d93c2b9461" & agri_income_08_o == -9

replace ind_var = 0 if key == "uuid:7a2ce175-761d-4e57-a6f4-d95e1e8734b6" & agri_income_09_1 == Dépenses familiales
replace ind_var = 0 if key == "uuid:f0e95d05-f703-4242-bb05-cdf1c7be4e16" & agri_income_09_2 == -9
replace ind_var = 0 if key == "uuid:7a2ce175-761d-4e57-a6f4-d95e1e8734b6" & agri_income_09_3 == Dépenses familiales

replace ind_var = 0 if key == "uuid:7a2ce175-761d-4e57-a6f4-d95e1e8734b6" & agri_income_10_1 == 150000
replace ind_var = 0 if key == "uuid:f0e95d05-f703-4242-bb05-cdf1c7be4e16" & agri_income_10_2 == -9
replace ind_var = 0 if key == "uuid:7a2ce175-761d-4e57-a6f4-d95e1e8734b6" & agri_income_10_3 == 150000

replace ind_var = 0 if key == "uuid:e25110ba-6df8-467a-b38e-577b9986dd00" & agri_income_23_1 == -9
replace ind_var = 0 if key == "uuid:ebb30e88-28c3-475e-9280-687cff7de2dc" & agri_income_23_1 == -9
replace ind_var = 0 if key == "uuid:a5be4dc8-b7e6-428a-a5c2-15ca12079878" & agri_income_23_1 == 85000
replace ind_var = 0 if key == "uuid:85c3253f-8039-4374-b28f-b9a389c51b66" & agri_income_23_1 == -9
replace ind_var = 0 if key == "uuid:8e7bd22b-c4fc-43d1-a4c2-dc797a036e43" & agri_income_23_1 == -9
replace ind_var = 0 if key == "uuid:63404b01-6729-4607-9f41-3e8b9153b9ee" & agri_income_23_2 == -9
replace ind_var = 0 if key == "uuid:ebb30e88-28c3-475e-9280-687cff7de2dc" & agri_income_23_2 == -9
replace ind_var = 0 if key == "uuid:920076db-929a-4cd7-9cd9-62e37f877a5c" & agri_income_23_2 == 67000
replace ind_var = 0 if key == "uuid:66b0b7d0-c37f-4ed4-9b1f-72bb0583ba96" & agri_income_23_2 == 150000

replace ind_var = 0 if key == "uuid:88a033cc-ae5d-4bd6-860b-3f14ff81a0f0" & agri_income_23_o == -9
replace ind_var = 0 if key == "uuid:56d685d1-e1a6-432f-9343-3a9c41d3e089" & agri_income_23_o == -9

replace ind_var = 0 if key == "uuid:b66b0159-426b-41be-af40-5d9f2ef3c0e4" & agri_income_39_1 == 182000

replace ind_var = 0 if key == "uuid:6e690859-4817-4dcd-8672-cf08f71f164b" & agri_income_45_10 == 6000
replace ind_var = 0 if key == "uuid:398fb50b-ed82-412f-948c-8c9b36a4d647" & agri_income_45_8 == -9

replace ind_var = 0 if key == "uuid:8320c233-c8cb-4feb-b803-9ba786d6a34d" & cereals_02_1 == 62400
replace ind_var = 0 if key == "uuid:7ae9095f-5f7c-4631-81e1-b41e9161fec1" & cereals_02_1 == 12000

replace ind_var = 0 if key == "uuid:bc16c47a-d6eb-4e45-97a7-b5275bfd1f91" & cereals_03_1 == 4150
replace ind_var = 0 if key == "uuid:d84a37d5-09e5-45ee-94fc-da2954f60d2b" & cereals_03_1 == 5200
replace ind_var = 0 if key == "uuid:614b075d-1253-46f3-ba62-eae586e7fd4b" & cereals_03_1 == 4000
replace ind_var = 0 if key == "uuid:f64dd1f9-662f-4e01-b1af-d99bd9d2725f" & cereals_03_1 == 6200
replace ind_var = 0 if key == "uuid:d4febba0-ef62-4a2d-b215-9f2edf88d392" & cereals_03_1 == 5000
replace ind_var = 0 if key == "uuid:742d4881-da1e-4e85-9270-0c5bd07d1b00" & cereals_03_1 == 1000
replace ind_var = 0 if key == "uuid:9e068357-e209-4055-a615-2ceeefc71a06" & cereals_03_1 == 100
replace ind_var = 0 if key == "uuid:b508a3ab-9afd-4b4d-ae57-9b3b9c7214de" & cereals_03_3 == 800
replace ind_var = 0 if key == "uuid:27733143-0061-401d-840a-10ef22c379b5" & cereals_03_3 == 250

replace ind_var = 0 if key == "uuid:d84a37d5-09e5-45ee-94fc-da2954f60d2b" & cereals_04_1 == 18200
replace ind_var = 0 if key == "uuid:bc16c47a-d6eb-4e45-97a7-b5275bfd1f91" & cereals_04_1 == 10790
replace ind_var = 0 if key == "uuid:843e9a2d-5908-409a-a7ce-e315a6048975" & cereals_04_1 == 22100
replace ind_var = 0 if key == "uuid:aab4e4e3-d006-4431-b647-f138d25f3b07" & cereals_04_1 == 19550
replace ind_var = 0 if key == "uuid:f64dd1f9-662f-4e01-b1af-d99bd9d2725f" & cereals_04_1 == 4000
replace ind_var = 0 if key == "uuid:614b075d-1253-46f3-ba62-eae586e7fd4b" & cereals_04_1 == 1000
replace ind_var = 0 if key == "uuid:d4febba0-ef62-4a2d-b215-9f2edf88d392" & cereals_04_1 == 8600
replace ind_var = 0 if key == "uuid:b39da8c4-f8e6-48bb-b75b-9a498d140b43" & cereals_04_1 == 2200
replace ind_var = 0 if key == "uuid:742d4881-da1e-4e85-9270-0c5bd07d1b00" & cereals_04_1 == 2000
replace ind_var = 0 if key == "uuid:ba2ff202-cbd1-4993-b0e8-098121069f93" & cereals_04_1 == 1200
replace ind_var = 0 if key == "uuid:4ea2408a-89a2-4bd4-8bac-9a8ebbffadd7" & cereals_04_1 == 34000
replace ind_var = 0 if key == "uuid:a6c6ad01-0cb0-4c9f-823c-dc6dc4a14256" & cereals_04_1 == 20500
replace ind_var = 0 if key == "uuid:b0a54e9c-c1e3-4274-8dd3-f3e452663310" & cereals_04_1 == 1350

replace ind_var = 0 if key == "uuid:c0442e67-dd33-43e3-abe6-5ca3872ac0b3" & farines_02_2 == -9

replace ind_var = 0 if key == "uuid:c0442e67-dd33-43e3-abe6-5ca3872ac0b3" & farines_03_2 == -9

replace ind_var = 0 if key == "uuid:6213c19b-f969-425e-8066-f6eee952d92b" & farines_04_1 == 35900
replace ind_var = 0 if key == "uuid:9dd87d99-ba8b-4d5e-9075-4ef5adbed212" & farines_04_1 == 4800
replace ind_var = 0 if key == "uuid:b23d6c34-7e39-4cb2-a08f-4e4731c59360" & farines_04_1 == 55930
replace ind_var = 0 if key == "uuid:081d8522-c607-4fa4-8a13-568ab0f5464b" & farines_04_1 == 5000
replace ind_var = 0 if key == "uuid:6a21258a-e5af-4762-ad75-fd2a7001d74f" & farines_04_1 == 1185
replace ind_var = 0 if key == "uuid:4b9d032f-e2ac-4e4f-b7f2-bad5b9917eaf" & farines_04_1 == 970
replace ind_var = 0 if key == "uuid:c0442e67-dd33-43e3-abe6-5ca3872ac0b3" & farines_04_2 == -9
replace ind_var = 0 if key == "uuid:370d88ef-b3d9-4646-8cfc-1135fc57197a" & farines_04_4 == 3192

replace ind_var = 0 if key == "uuid:c0442e67-dd33-43e3-abe6-5ca3872ac0b3" & farines_05_2 == -9
replace ind_var = 0 if key == "uuid:86eb5846-fbde-44a1-b04c-7dab574f678b" & farines_05_2 == -9

replace ind_var = 0 if key == "uuid:79e1a0b4-c1c2-4b85-89f7-854a3b3fbc1e" & hh_14_b_1 == 100
replace ind_var = 0 if key == "uuid:79e1a0b4-c1c2-4b85-89f7-854a3b3fbc1e" & hh_14_b_12 == 100
replace ind_var = 0 if key == "uuid:79e1a0b4-c1c2-4b85-89f7-854a3b3fbc1e" & hh_14_b_8 == 100

replace ind_var = 0 if key == "uuid:480e7175-e4f0-467b-ae3d-d2d3c957d314" & hh_21_total_4 == 50

replace ind_var = 0 if key == "uuid:e70a0dfe-c497-413b-9432-7fb876a24783" & hh_26_2 == Non
replace ind_var = 0 if key == "uuid:032096e6-8a3f-45f6-aa8f-3281668a0dc4" & hh_26_5 == Non

replace ind_var = 0 if key == "uuid:e70a0dfe-c497-413b-9432-7fb876a24783" & hh_27_2 == Non
replace ind_var = 0 if key == "uuid:032096e6-8a3f-45f6-aa8f-3281668a0dc4" & hh_27_5 == Non

replace ind_var = 0 if key == "uuid:e70a0dfe-c497-413b-9432-7fb876a24783" & hh_39_2 == vivant mais ne résidant pas dans le même ménage
replace ind_var = 0 if key == "uuid:032096e6-8a3f-45f6-aa8f-3281668a0dc4" & hh_39_5 == vivant mais ne résidant pas dans le même ménage

replace ind_var = 0 if key == "uuid:e70a0dfe-c497-413b-9432-7fb876a24783" & hh_40_2 == vivant mais ne résidant pas dans le même ménage
replace ind_var = 0 if key == "uuid:032096e6-8a3f-45f6-aa8f-3281668a0dc4" & hh_40_5 == vivant mais ne résidant pas dans le même ménage

replace ind_var = 0 if key == "uuid:801e11ec-467f-4cc9-9eb6-0dec8dbec2a5" & hh_41_4 == 7
replace ind_var = 0 if key == "uuid:ce5549e0-79b0-4bde-9e8b-37fab5eedf2f" & hh_41_5 == 5
replace ind_var = 0 if key == "uuid:d5c7ff2b-5a98-48e6-ab1c-afdf20b145df" & hh_41_8 == 7

replace ind_var = 0 if key == "uuid:e70a0dfe-c497-413b-9432-7fb876a24783" & hh_47_a_2 == 8000
replace ind_var = 0 if key == "uuid:032096e6-8a3f-45f6-aa8f-3281668a0dc4" & hh_47_a_5 == 8000

replace ind_var = 0 if key == "uuid:e70a0dfe-c497-413b-9432-7fb876a24783" & hh_47_b_2 == 15000
replace ind_var = 0 if key == "uuid:032096e6-8a3f-45f6-aa8f-3281668a0dc4" & hh_47_b_5 == 15000

replace ind_var = 0 if key == "uuid:e70a0dfe-c497-413b-9432-7fb876a24783" & hh_47_c_2 == 0
replace ind_var = 0 if key == "uuid:032096e6-8a3f-45f6-aa8f-3281668a0dc4" & hh_47_c_5 == 0

replace ind_var = 0 if key == "uuid:e70a0dfe-c497-413b-9432-7fb876a24783" & hh_47_d_2 == 0
replace ind_var = 0 if key == "uuid:032096e6-8a3f-45f6-aa8f-3281668a0dc4" & hh_47_d_5 == 0

replace ind_var = 0 if key == "uuid:e70a0dfe-c497-413b-9432-7fb876a24783" & hh_47_e_2 == 0
replace ind_var = 0 if key == "uuid:032096e6-8a3f-45f6-aa8f-3281668a0dc4" & hh_47_e_5 == 0

replace ind_var = 0 if key == "uuid:e70a0dfe-c497-413b-9432-7fb876a24783" & hh_47_f_2 == 0
replace ind_var = 0 if key == "uuid:032096e6-8a3f-45f6-aa8f-3281668a0dc4" & hh_47_f_5 == 0

replace ind_var = 0 if key == "uuid:e70a0dfe-c497-413b-9432-7fb876a24783" & hh_47_g_2 == 0
replace ind_var = 0 if key == "uuid:032096e6-8a3f-45f6-aa8f-3281668a0dc4" & hh_47_g_5 == 0

replace ind_var = 0 if key == "uuid:e70a0dfe-c497-413b-9432-7fb876a24783" & hh_47_oth_2 == 0
replace ind_var = 0 if key == "uuid:032096e6-8a3f-45f6-aa8f-3281668a0dc4" & hh_47_oth_5 == 0

replace ind_var = 0 if key == "uuid:e70a0dfe-c497-413b-9432-7fb876a24783" & hh_48_2 == Non
replace ind_var = 0 if key == "uuid:032096e6-8a3f-45f6-aa8f-3281668a0dc4" & hh_48_5 == Non

replace ind_var = 0 if key == "uuid:5ac7ee7b-7dfa-4cf2-8d51-31ad6a4e0d9d" & hh_age_3 == 95

replace ind_var = 0 if key == "uuid:83d16bd0-281f-4b48-9619-8e53f666105d" & hh_education_level_1 == 4

replace ind_var = 0 if key == "uuid:a9c38dbd-844b-4ae2-9ef9-c817fdf5317e" & legumes_01_3 == 0.4
replace ind_var = 0 if key == "uuid:6fc34a13-7455-46b5-9d1a-5bafa2e11b9e" & legumes_01_3 == 0.4

replace ind_var = 0 if key == "uuid:6133e860-70a5-4ea2-87a9-b87d1869de3d" & legumes_02_3 == -9
replace ind_var = 0 if key == "uuid:b7f22d65-4b4f-445b-9826-891455b4c258" & legumes_02_3 == -9
replace ind_var = 0 if key == "uuid:216ebb08-a2a9-4d09-8979-04f88d70617b" & legumes_02_3 == -9
replace ind_var = 0 if key == "uuid:f8570de1-84f3-4c5e-b2e3-c17116a88dec" & legumes_02_3 == -9
replace ind_var = 0 if key == "uuid:3d4f6649-d0b1-46a5-afa1-70ff40b86096" & legumes_02_3 == -9
replace ind_var = 0 if key == "uuid:aa66233f-4955-47fc-beb9-242d22e341b7" & legumes_02_3 == -9
replace ind_var = 0 if key == "uuid:b9348d87-285c-4b74-bfcc-4ec54fbcaef2" & legumes_02_3 == -9

replace ind_var = 0 if key == "uuid:7e459848-09f8-4b84-a8c8-08c5e708cf5d" & legumes_03_3 == 225
replace ind_var = 0 if key == "uuid:f8570de1-84f3-4c5e-b2e3-c17116a88dec" & legumes_03_3 == -9
replace ind_var = 0 if key == "uuid:6133e860-70a5-4ea2-87a9-b87d1869de3d" & legumes_03_3 == 50
replace ind_var = 0 if key == "uuid:b7f22d65-4b4f-445b-9826-891455b4c258" & legumes_03_3 == 100
replace ind_var = 0 if key == "uuid:216ebb08-a2a9-4d09-8979-04f88d70617b" & legumes_03_3 == 200
replace ind_var = 0 if key == "uuid:3d4f6649-d0b1-46a5-afa1-70ff40b86096" & legumes_03_3 == 90
replace ind_var = 0 if key == "uuid:aa66233f-4955-47fc-beb9-242d22e341b7" & legumes_03_3 == 200
replace ind_var = 0 if key == "uuid:b9348d87-285c-4b74-bfcc-4ec54fbcaef2" & legumes_03_3 == 100

replace ind_var = 0 if key == "uuid:64030e2d-2504-47b4-874f-d8b9206b9b4b" & legumes_04_1 == 3600
replace ind_var = 0 if key == "uuid:9bed3f13-6182-4946-973e-c84ebdb7e64d" & legumes_04_1 == 1450
replace ind_var = 0 if key == "uuid:667efd5f-8ca5-4590-9186-f6d5a55eb42e" & legumes_04_3 == 11250
replace ind_var = 0 if key == "uuid:7e459848-09f8-4b84-a8c8-08c5e708cf5d" & legumes_04_3 == 11250
replace ind_var = 0 if key == "uuid:07374a46-8b35-4535-8e7f-aee405e62880" & legumes_04_3 == 12500
replace ind_var = 0 if key == "uuid:e25110ba-6df8-467a-b38e-577b9986dd00" & legumes_04_3 == 12400
replace ind_var = 0 if key == "uuid:e1500728-8f0d-4082-aa0b-7151e4c98c24" & legumes_04_3 == 17200
replace ind_var = 0 if key == "uuid:dfd04b1f-4f0e-4bf0-a42c-51e756a93966" & legumes_04_3 == 17100
replace ind_var = 0 if key == "uuid:924e4381-5ab0-4f49-9c41-ddb4d0b33b3d" & legumes_04_3 == 11100
replace ind_var = 0 if key == "uuid:3d4f6649-d0b1-46a5-afa1-70ff40b86096" & legumes_04_3 == 18135
replace ind_var = 0 if key == "uuid:216ebb08-a2a9-4d09-8979-04f88d70617b" & legumes_04_3 == 5500
replace ind_var = 0 if key == "uuid:6133e860-70a5-4ea2-87a9-b87d1869de3d" & legumes_04_3 == 11200
replace ind_var = 0 if key == "uuid:aa66233f-4955-47fc-beb9-242d22e341b7" & legumes_04_3 == 17000
replace ind_var = 0 if key == "uuid:b9348d87-285c-4b74-bfcc-4ec54fbcaef2" & legumes_04_3 == 12000
replace ind_var = 0 if key == "uuid:b7f22d65-4b4f-445b-9826-891455b4c258" & legumes_04_3 == 12484
replace ind_var = 0 if key == "uuid:f8570de1-84f3-4c5e-b2e3-c17116a88dec" & legumes_04_3 == 52000
replace ind_var = 0 if key == "uuid:f7c1d3b1-0f51-495c-9ed5-7fd642518c73" & legumes_04_3 == 8000
replace ind_var = 0 if key == "uuid:869babf6-be9d-49ad-a3e6-b949d3719a28" & legumes_04_3 == 13000
replace ind_var = 0 if key == "uuid:3e4fa814-7e80-4e40-b3a6-f6e938bcc106" & legumes_04_3 == 8000
replace ind_var = 0 if key == "uuid:91d4c4b4-ac34-42e9-9e3d-c3491b708ca0" & legumes_04_3 == 11400
replace ind_var = 0 if key == "uuid:2fba3e48-9d7b-4b32-ab2d-990fc6d2d413" & legumes_04_3 == 8000
replace ind_var = 0 if key == "uuid:b1d8b6b0-f899-427b-b0a2-96a43f2a092b" & legumes_04_3 == 10200
replace ind_var = 0 if key == "uuid:c1858219-77cd-4076-8cf8-4059b7d80d2d" & legumes_04_3 == 10200
replace ind_var = 0 if key == "uuid:9a2701e9-2f77-43c6-948a-00c892e2739f" & legumes_04_3 == 16800
replace ind_var = 0 if key == "uuid:d64a294e-43b9-44cd-aab0-d14bc88d71de" & legumes_04_6 == 8750

replace ind_var = 0 if key == "uuid:cfd81b39-f5e3-40d4-aab0-4b7c3d2da1bd" & legumineuses_01_5 == 0.3

replace ind_var = 0 if key == "uuid:09622dd4-4613-46e3-939b-c3a43a585bb5" & legumineuses_04_1 == 1000
replace ind_var = 0 if key == "uuid:3b860b05-1279-4807-9ebb-cccdf410537f" & legumineuses_04_1 == 7500
replace ind_var = 0 if key == "uuid:e9086ca8-03e3-49fb-b7ca-01c40f858435" & legumineuses_04_1 == 1800

replace ind_var = 0 if key == "uuid:b89a7ed1-e6ea-4835-8e6d-2e374b8d1cdb" & o_culture_02 == 12800

replace ind_var = 0 if key == "uuid:57dd6094-f7b5-43e7-9c80-108266eac06b" & o_culture_04 == 2900
*/

* corrections 
replace agri_income_06 = -9 if key == "uuid:c4551c9e-c0c0-4f4a-b080-e07648e53697"
replace agri_income_06 = -9 if key == "uuid:0b37d7f9-43b1-4a23-b3f0-b41470b1fc34"
replace agri_income_06 = -9 if key == "uuid:14173965-524c-42ed-881d-7ba303969f5f"

replace agri_income_07_o = -9 if key == "uuid:07815cfd-fc9e-42e6-823e-83d93c2b9461"

replace agri_income_08_o = -9 if key == "uuid:07815cfd-fc9e-42e6-823e-83d93c2b9461"

replace agri_income_09_1 = -9 if key == "uuid:7a2ce175-761d-4e57-a6f4-d95e1e8734b6"
replace agri_income_09_2 = -9 if key == "uuid:f0e95d05-f703-4242-bb05-cdf1c7be4e16"
replace agri_income_09_3 = -9 if key == "uuid:7a2ce175-761d-4e57-a6f4-d95e1e8734b6"

replace agri_income_10_1 = 150000 if key == "uuid:7a2ce175-761d-4e57-a6f4-d95e1e8734b6"
replace agri_income_10_2 = -9 if key == "uuid:f0e95d05-f703-4242-bb05-cdf1c7be4e16"
replace agri_income_10_3 = 150000 if key == "uuid:7a2ce175-761d-4e57-a6f4-d95e1e8734b6"

replace agri_income_23_1 = -9 if key == "uuid:e25110ba-6df8-467a-b38e-577b9986dd00"
replace agri_income_23_1 = -9 if key == "uuid:ebb30e88-28c3-475e-9280-687cff7de2dc"
replace agri_income_23_1 = 85000 if key == "uuid:a5be4dc8-b7e6-428a-a5c2-15ca12079878"
replace agri_income_23_1 = -9 if key == "uuid:85c3253f-8039-4374-b28f-b9a389c51b66"
replace agri_income_23_1 = -9 if key == "uuid:8e7bd22b-c4fc-43d1-a4c2-dc797a036e43"
replace agri_income_23_2 = -9 if key == "uuid:63404b01-6729-4607-9f41-3e8b9153b9ee"
replace agri_income_23_2 = -9 if key == "uuid:ebb30e88-28c3-475e-9280-687cff7de2dc"
replace agri_income_23_2 = 67000 if key == "uuid:920076db-929a-4cd7-9cd9-62e37f877a5c"
replace agri_income_23_2 = 150000 if key == "uuid:66b0b7d0-c37f-4ed4-9b1f-72bb0583ba96"
replace agri_income_23_o = -9 if key == "uuid:88a033cc-ae5d-4bd6-860b-3f14ff81a0f0"
replace agri_income_23_o = -9 if key == "uuid:56d685d1-e1a6-432f-9343-3a9c41d3e089"

replace agri_income_39_1 = 182000 if key == "uuid:b66b0159-426b-41be-af40-5d9f2ef3c0e4"

replace agri_income_45_10 = 6000 if key == "uuid:6e690859-4817-4dcd-8672-cf08f71f164b"
replace agri_income_45_8 = -9 if key == "uuid:398fb50b-ed82-412f-948c-8c9b36a4d647"

replace cereals_02_1 = 62400 if key == "uuid:8320c233-c8cb-4feb-b803-9ba786d6a34d"
replace cereals_02_1 = 12000 if key == "uuid:7ae9095f-5f7c-4631-81e1-b41e9161fec1"

replace cereals_03_1 = 4150 if key == "uuid:bc16c47a-d6eb-4e45-97a7-b5275bfd1f91"
replace cereals_03_1 = 5200 if key == "uuid:d84a37d5-09e5-45ee-94fc-da2954f60d2b"
replace cereals_03_1 = 4000 if key == "uuid:614b075d-1253-46f3-ba62-eae586e7fd4b"
replace cereals_03_1 = 6200 if key == "uuid:f64dd1f9-662f-4e01-b1af-d99bd9d2725f"
replace cereals_03_1 = 5000 if key == "uuid:d4febba0-ef62-4a2d-b215-9f2edf88d392"
replace cereals_03_1 = 1000 if key == "uuid:742d4881-da1e-4e85-9270-0c5bd07d1b00"
replace cereals_03_1 = 100 if key == "uuid:9e068357-e209-4055-a615-2ceeefc71a06"
replace cereals_03_3 = 800 if key == "uuid:b508a3ab-9afd-4b4d-ae57-9b3b9c7214de"
replace cereals_03_3 = 250 if key == "uuid:27733143-0061-401d-840a-10ef22c379b5"

replace cereals_04_1 = 18200 if key == "uuid:d84a37d5-09e5-45ee-94fc-da2954f60d2b"
replace cereals_04_1 = 10790 if key == "uuid:bc16c47a-d6eb-4e45-97a7-b5275bfd1f91"
replace cereals_04_1 = 22100 if key == "uuid:843e9a2d-5908-409a-a7ce-e315a6048975"
replace cereals_04_1 = 19550 if key == "uuid:aab4e4e3-d006-4431-b647-f138d25f3b07"
replace cereals_04_1 = 4000 if key == "uuid:f64dd1f9-662f-4e01-b1af-d99bd9d2725f"
replace cereals_04_1 = 1000 if key == "uuid:614b075d-1253-46f3-ba62-eae586e7fd4b"
replace cereals_04_1 = 8600 if key == "uuid:d4febba0-ef62-4a2d-b215-9f2edf88d392"
replace cereals_04_1 = 2200 if key == "uuid:b39da8c4-f8e6-48bb-b75b-9a498d140b43"
replace cereals_04_1 = 2000 if key == "uuid:742d4881-da1e-4e85-9270-0c5bd07d1b00"
replace cereals_04_1 = 1200 if key == "uuid:ba2ff202-cbd1-4993-b0e8-098121069f93"
replace cereals_04_1 = 34000 if key == "uuid:4ea2408a-89a2-4bd4-8bac-9a8ebbffadd7"
replace cereals_04_1 = 20500 if key == "uuid:a6c6ad01-0cb0-4c9f-823c-dc6dc4a14256"
replace cereals_04_1 = 1350 if key == "uuid:b0a54e9c-c1e3-4274-8dd3-f3e452663310"

replace farines_02_2 = -9 if key == "uuid:c0442e67-dd33-43e3-abe6-5ca3872ac0b3"

replace farines_03_2 = -9 if key == "uuid:c0442e67-dd33-43e3-abe6-5ca3872ac0b3"

replace farines_04_1 = 35900 if key == "uuid:6213c19b-f969-425e-8066-f6eee952d92b"
replace farines_04_1 = 4800 if key == "uuid:9dd87d99-ba8b-4d5e-9075-4ef5adbed212"
replace farines_04_1 = 55930 if key == "uuid:b23d6c34-7e39-4cb2-a08f-4e4731c59360"
replace farines_04_1 = 5000 if key == "uuid:081d8522-c607-4fa4-8a13-568ab0f5464b"
replace farines_04_1 = 1185 if key == "uuid:6a21258a-e5af-4762-ad75-fd2a7001d74f"
replace farines_04_1 = 970 if key == "uuid:4b9d032f-e2ac-4e4f-b7f2-bad5b9917eaf"
replace farines_04_2 = -9 if key == "uuid:c0442e67-dd33-43e3-abe6-5ca3872ac0b3"
replace farines_04_4 = 3192 if key == "uuid:370d88ef-b3d9-4646-8cfc-1135fc57197a"

replace farines_05_2 = -9 if key == "uuid:c0442e67-dd33-43e3-abe6-5ca3872ac0b3"
replace farines_05_2 = -9 if key == "uuid:86eb5846-fbde-44a1-b04c-7dab574f678b"

replace hh_14_b_1 = 100 if key == "uuid:79e1a0b4-c1c2-4b85-89f7-854a3b3fbc1e"
replace hh_14_b_12 = 100 if key == "uuid:79e1a0b4-c1c2-4b85-89f7-854a3b3fbc1e"
replace hh_14_b_8 = 100 if key == "uuid:79e1a0b4-c1c2-4b85-89f7-854a3b3fbc1e"


// replace hh_21_total_4 = 50 if key == "uuid:480e7175-e4f0-467b-ae3d-d2d3c957d314"
replace hh_21_4_1 = 12 if key == "uuid:480e7175-e4f0-467b-ae3d-d2d3c957d314"
replace hh_21_4_2 = 20 if key == "uuid:480e7175-e4f0-467b-ae3d-d2d3c957d314"

replace hh_26_2 = 0 if key == "uuid:e70a0dfe-c497-413b-9432-7fb876a24783"
replace hh_26_5 = 0 if key == "uuid:032096e6-8a3f-45f6-aa8f-3281668a0dc4"

replace hh_27_2 = 0 if key == "uuid:e70a0dfe-c497-413b-9432-7fb876a24783"
replace hh_27_5 = 0 if key == "uuid:032096e6-8a3f-45f6-aa8f-3281668a0dc4"

* no longer in the household
replace hh_39_2 = -6 if key == "uuid:e70a0dfe-c497-413b-9432-7fb876a24783"
replace hh_39_5 = -6 if key == "uuid:032096e6-8a3f-45f6-aa8f-3281668a0dc4"

* no longer in the household
replace hh_40_2 = -6 if key == "uuid:e70a0dfe-c497-413b-9432-7fb876a24783"
replace hh_40_5 = -6 if key == "uuid:032096e6-8a3f-45f6-aa8f-3281668a0dc4"

replace hh_41_4 = 7 if key == "uuid:801e11ec-467f-4cc9-9eb6-0dec8dbec2a5"
replace hh_41_5 = 5 if key == "uuid:ce5549e0-79b0-4bde-9e8b-37fab5eedf2f"
replace hh_41_8 = 7 if key == "uuid:d5c7ff2b-5a98-48e6-ab1c-afdf20b145df"

replace hh_47_a_2 = 8000 if key == "uuid:e70a0dfe-c497-413b-9432-7fb876a24783"
replace hh_47_a_5 = 8000 if key == "uuid:032096e6-8a3f-45f6-aa8f-3281668a0dc4"
replace hh_47_b_2 = 15000 if key == "uuid:e70a0dfe-c497-413b-9432-7fb876a24783"
replace hh_47_b_5 = 15000 if key == "uuid:032096e6-8a3f-45f6-aa8f-3281668a0dc4"
replace hh_47_c_2 = 0 if key == "uuid:e70a0dfe-c497-413b-9432-7fb876a24783"
replace hh_47_c_5 = 0 if key == "uuid:032096e6-8a3f-45f6-aa8f-3281668a0dc4"
replace hh_47_d_2 = 0 if key == "uuid:e70a0dfe-c497-413b-9432-7fb876a24783"
replace hh_47_d_5 = 0 if key == "uuid:032096e6-8a3f-45f6-aa8f-3281668a0dc4"
replace hh_47_e_2 = 0 if key == "uuid:e70a0dfe-c497-413b-9432-7fb876a24783"
replace hh_47_e_5 = 0 if key == "uuid:032096e6-8a3f-45f6-aa8f-3281668a0dc4"
replace hh_47_f_2 = 0 if key == "uuid:e70a0dfe-c497-413b-9432-7fb876a24783"
replace hh_47_f_5 = 0 if key == "uuid:032096e6-8a3f-45f6-aa8f-3281668a0dc4"
replace hh_47_g_2 = 0 if key == "uuid:e70a0dfe-c497-413b-9432-7fb876a24783"
replace hh_47_g_5 = 0 if key == "uuid:032096e6-8a3f-45f6-aa8f-3281668a0dc4"
replace hh_47_oth_2 = "" if key == "uuid:e70a0dfe-c497-413b-9432-7fb876a24783"
replace hh_47_oth_5 = . if key == "uuid:032096e6-8a3f-45f6-aa8f-3281668a0dc4"

replace hh_48_2 = 0 if key == "uuid:e70a0dfe-c497-413b-9432-7fb876a24783"
replace hh_48_5 = 0 if key == "uuid:032096e6-8a3f-45f6-aa8f-3281668a0dc4"

replace age_3 = 95 if key == "uuid:5ac7ee7b-7dfa-4cf2-8d51-31ad6a4e0d9d"

replace hh_education_level_1 = 4 if key == "uuid:83d16bd0-281f-4b48-9619-8e53f666105d"

replace legumes_01_3 = 0.4 if key == "uuid:a9c38dbd-844b-4ae2-9ef9-c817fdf5317e"
replace legumes_01_3 = 0.4 if key == "uuid:6fc34a13-7455-46b5-9d1a-5bafa2e11b9e"

replace legumes_02_3 = -9 if key == "uuid:6133e860-70a5-4ea2-87a9-b87d1869de3d"
replace legumes_02_3 = -9 if key == "uuid:b7f22d65-4b4f-445b-9826-891455b4c258"
replace legumes_02_3 = -9 if key == "uuid:216ebb08-a2a9-4d09-8979-04f88d70617b"
replace legumes_02_3 = -9 if key == "uuid:f8570de1-84f3-4c5e-b2e3-c17116a88dec"
replace legumes_02_3 = -9 if key == "uuid:3d4f6649-d0b1-46a5-afa1-70ff40b86096"
replace legumes_02_3 = -9 if key == "uuid:aa66233f-4955-47fc-beb9-242d22e341b7"
replace legumes_02_3 = -9 if key == "uuid:b9348d87-285c-4b74-bfcc-4ec54fbcaef2"

replace legumes_03_3 = 225 if key == "uuid:7e459848-09f8-4b84-a8c8-08c5e708cf5d"
replace legumes_03_3 = -9 if key == "uuid:f8570de1-84f3-4c5e-b2e3-c17116a88dec"
replace legumes_03_3 = 50 if key == "uuid:6133e860-70a5-4ea2-87a9-b87d1869de3d"
replace legumes_03_3 = 100 if key == "uuid:b7f22d65-4b4f-445b-9826-891455b4c258"
replace legumes_03_3 = 200 if key == "uuid:216ebb08-a2a9-4d09-8979-04f88d70617b"
replace legumes_03_3 = 90 if key == "uuid:3d4f6649-d0b1-46a5-afa1-70ff40b86096"
replace legumes_03_3 = 200 if key == "uuid:aa66233f-4955-47fc-beb9-242d22e341b7"
replace legumes_03_3 = 100 if key == "uuid:b9348d87-285c-4b74-bfcc-4ec54fbcaef2"

replace legumes_04_1 = 3600 if key == "uuid:64030e2d-2504-47b4-874f-d8b9206b9b4b"
replace legumes_04_1 = 1450 if key == "uuid:9bed3f13-6182-4946-973e-c84ebdb7e64d"
replace legumes_04_3 = 11250 if key == "uuid:667efd5f-8ca5-4590-9186-f6d5a55eb42e"
replace legumes_04_3 = 11250 if key == "uuid:7e459848-09f8-4b84-a8c8-08c5e708cf5d"
replace legumes_04_3 = 12500 if key == "uuid:07374a46-8b35-4535-8e7f-aee405e62880"
replace legumes_04_3 = 12400 if key == "uuid:e25110ba-6df8-467a-b38e-577b9986dd00"
replace legumes_04_3 = 17200 if key == "uuid:e1500728-8f0d-4082-aa0b-7151e4c98c24"
replace legumes_04_3 = 17100 if key == "uuid:dfd04b1f-4f0e-4bf0-a42c-51e756a93966"
replace legumes_04_3 = 11100 if key == "uuid:924e4381-5ab0-4f49-9c41-ddb4d0b33b3d"
replace legumes_04_3 = 18135 if key == "uuid:3d4f6649-d0b1-46a5-afa1-70ff40b86096"
replace legumes_04_3 = 5500 if key == "uuid:216ebb08-a2a9-4d09-8979-04f88d70617b"
replace legumes_04_3 = 11200 if key == "uuid:6133e860-70a5-4ea2-87a9-b87d1869de3d"
replace legumes_04_3 = 17000 if key == "uuid:aa66233f-4955-47fc-beb9-242d22e341b7"
replace legumes_04_3 = 12000 if key == "uuid:b9348d87-285c-4b74-bfcc-4ec54fbcaef2"
replace legumes_04_3 = 12484 if key == "uuid:b7f22d65-4b4f-445b-9826-891455b4c258"
replace legumes_04_3 = 52000 if key == "uuid:f8570de1-84f3-4c5e-b2e3-c17116a88dec"
replace legumes_04_3 = 8000 if key == "uuid:f7c1d3b1-0f51-495c-9ed5-7fd642518c73"
replace legumes_04_3 = 13000 if key == "uuid:869babf6-be9d-49ad-a3e6-b949d3719a28"
replace legumes_04_3 = 8000 if key == "uuid:3e4fa814-7e80-4e40-b3a6-f6e938bcc106"
replace legumes_04_3 = 11400 if key == "uuid:91d4c4b4-ac34-42e9-9e3d-c3491b708ca0"
replace legumes_04_3 = 8000 if key == "uuid:2fba3e48-9d7b-4b32-ab2d-990fc6d2d413"
replace legumes_04_3 = 10200 if key == "uuid:b1d8b6b0-f899-427b-b0a2-96a43f2a092b"
replace legumes_04_3 = 10200 if key == "uuid:c1858219-77cd-4076-8cf8-4059b7d80d2d"
replace legumes_04_3 = 16800 if key == "uuid:9a2701e9-2f77-43c6-948a-00c892e2739f"
replace legumes_04_6 = 8750 if key == "uuid:d64a294e-43b9-44cd-aab0-d14bc88d71de"

replace legumineuses_01_5 = 0.3 if key == "uuid:cfd81b39-f5e3-40d4-aab0-4b7c3d2da1bd"

replace legumineuses_04_1 = 1000 if key == "uuid:09622dd4-4613-46e3-939b-c3a43a585bb5"
replace legumineuses_04_1 = 7500 if key == "uuid:3b860b05-1279-4807-9ebb-cccdf410537f"
replace legumineuses_04_1 = 1800 if key == "uuid:e9086ca8-03e3-49fb-b7ca-01c40f858435"

replace o_culture_02 = 12800 if key == "uuid:b89a7ed1-e6ea-4835-8e6d-2e374b8d1cdb"
replace o_culture_04 = 2900 if key == "uuid:57dd6094-f7b5-43e7-9c80-108266eac06b"



* Save the corrected dataset
export delimited using "$corrected\CORRECTED_DISES_Enquête_ménage_midline_VF_WIDE_5Mar2025.csv", replace

save "$corrected\CORRECTED_DISES_Enquête_ménage_midline_VF_WIDE_5Mar2025.dta", replace
