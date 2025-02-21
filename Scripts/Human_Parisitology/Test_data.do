* Step 1: Generate fake data
clear
set obs 10
gen BegeningTimesampling = "11h03"
replace BegeningTimesampling = "12h15" in 2
replace BegeningTimesampling = "14h45" in 3
replace BegeningTimesampling = "16h30" in 4
replace BegeningTimesampling = "09h20" in 5
replace BegeningTimesampling = "10h05" in 6
replace BegeningTimesampling = "13h50" in 7
replace BegeningTimesampling = "17h00" in 8
replace BegeningTimesampling = "08h30" in 9
replace BegeningTimesampling = "15h10" in 10

* Step 2: Create Endsamplingtime with some missing values ("missed")
gen Endsamplingtime = "missed"
replace Endsamplingtime = "12h45" in 2
replace Endsamplingtime = "15h30" in 3
replace Endsamplingtime = "17h10" in 4
replace Endsamplingtime = "10h45" in 5
replace Endsamplingtime = "11h55" in 6
replace Endsamplingtime = "13h10" in 7
replace Endsamplingtime = "18h20" in 8
replace Endsamplingtime = "09h50" in 9
replace Endsamplingtime = "16h40" in 10

* Step 3: Clean the time format (remove extra colons and replace "h" with ":")
replace BegeningTimesampling = regexr(BegeningTimesampling, "h:", "h")
replace Endsamplingtime = regexr(Endsamplingtime, "h:", "h")

* Remove apostrophe in the time (if present)
replace BegeningTimesampling = subinstr(BegeningTimesampling, "'", "", .)
replace Endsamplingtime = subinstr(Endsamplingtime, "'", "", .)

* Replace "h" with ":" to make it compatible with Stata's time format
replace BegeningTimesampling = subinstr(BegeningTimesampling, "h", ":", .)
replace Endsamplingtime = subinstr(Endsamplingtime, "h", ":", .)

* Step 4: Clean the time strings by trimming any extra spaces
replace BegeningTimesampling = trim(BegeningTimesampling)
replace Endsamplingtime = trim(Endsamplingtime)

* Step 5: Handle the "missed" values and replace with a default value (e.g., "00:00")
replace Endsamplingtime = "00:00" if Endsamplingtime == "missed"

* Step 6: Convert string to Stata time format (HH:MM)
gen double BegeningTimesampling_time = clock(BegeningTimesampling, "HH:MM")
gen double Endsamplingtime_time = clock(Endsamplingtime, "HH:MM")

* Step 7: Display the results after conversion to check
list BegeningTimesampling Endsamplingtime BegeningTimesampling_time Endsamplingtime_time

* Step 8: Compute time difference in minutes
gen total_time = (Endsamplingtime_time - BegeningTimesampling_time) / 60000  // Convert milliseconds to minutes

* Step 9: Handle missing values in the total time
replace total_time = 0 if missing(total_time)