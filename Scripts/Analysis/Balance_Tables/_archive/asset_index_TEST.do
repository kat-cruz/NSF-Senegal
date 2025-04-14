clear


* Create sample livestock ownership variables
gen cattle = 2       // Number of cattle owned
gen goats = 5        // Number of goats owned
gen sheep = 3        // Number of sheep owned
gen poultry = 10     // Number of poultry (chickens, ducks, etc.)
gen donkeys = 1      // Number of donkeys owned

* Compute TLU based on standard conversion factors
gen TLU = (cattle * 1.0) + (goats * 0.1) + (sheep * 0.1) + (poultry * 0.01) + (donkeys * 0.5)

* Display results
list cattle goats sheep poultry donkeys TLU


clear
set seed 12345  // Ensure reproducibility
set obs 100     // Create data for 100 households

* Generate synthetic binary asset ownership variables (1 = owns, 0 = does not own)
gen owns_tv = round(runiform())  
gen owns_fridge = round(runiform())  
gen owns_phone = round(runiform())  
gen owns_car = round(runiform() * 0.5)   // Fewer households own cars
gen owns_bike = round(runiform())  
gen owns_motorcycle = round(runiform() * 0.3)  // Fewer households own motorcycles
gen piped_water = round(runiform())  
gen electricity = round(runiform())  
gen improved_sanitation = round(runiform())  

* Generate a continuous variable for number of rooms in the house
gen num_rooms = round(rnormal(3, 1))  
replace num_rooms = max(num_rooms, 1)  // Ensure at least 1 room

* Generate a continuous variable for livestock holdings (TLU - Tropical Livestock Units)
gen livestock_tlu = abs(rnormal(2, 1))  

* Check data summary
summarize owns_tv owns_fridge owns_phone owns_car owns_bike owns_motorcycle piped_water electricity improved_sanitation num_rooms livestock_tlu

* Standardize continuous variables before PCA
foreach var in num_rooms livestock_tlu {
    egen z_`var' = std(`var')  // Create z-score versions
}


** The correlation matrix standardizes the data, making comparisons between these variables possible, and prevents highly correlated variables (such as the binary ones) from distorting the PCA results.

* Run PCA on asset variables
pca owns_tv owns_fridge owns_phone owns_car owns_bike owns_motorcycle piped_water electricity improved_sanitation z_num_rooms z_livestock_tlu

* Display variance explained by each component
screeplot, ytitle("Proportion of Variance Explained") 


**   PC1 (the first principal component) is typically used as the asset index because it explains the most variation in the data and is often interpreted as a measure of wealth or socioeconomic status in the context of PCA.

* Extract the first principal component (PC1) as the asset index
predict asset_index if e(sample), score

* Normalize the asset index for better interpretability
egen asset_index_std = std(asset_index)

* Display results
list owns_tv owns_fridge owns_phone owns_car owns_bike asset_index_std if _n <= 10, sep(0)

* Save dataset with PCA results
save synthetic_asset_data.dta, replace


















