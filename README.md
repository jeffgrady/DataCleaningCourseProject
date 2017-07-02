# Data Cleaning Course Project

This is my R code for cleaning and aggregating the data for the
Data Cleaning course project.

## File Descriptions

* `run_analysis.R` loads and cleans the data as described by the
  assignment and outputs the file `combined_data.txt` and `tidy_data.txt`.  To use
  `run_analysis.R`:
```
> source('run_analysis.R')
> main()
```
* `README.md` this file.
* `CodeBook.md` a description of the data and how it was processed.
* `combined_data.txt` is a text file of the combined data as processed by `run_analysis.R`.  It was written using R's `write.table()`.
* `tidy_data.txt` is a text file of the mean of every variable in `combined_data.txt` for all activities
   and all subjects, minus the categories I generated.  It was also written using R's `write.table()`.

