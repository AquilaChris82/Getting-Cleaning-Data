# Getting-Cleaning-Data
Course Project submission for Getting and Cleaning Data
#About run_analysis.R script
0. Load dplyr
1.Input files
..*subject_test, subject_train
..*y_test, y_train
..*X_test, X_train
..*features.txt
..*activity_labels.txt
2. a function "tidy_table" is called on test and train files
..*features_cols<- use grep to subset features.txt by columns containing 'mean', 'std'
..*subset X data to only include columns in feature_cols
..*join this X subset to y and subject columns using cbind
..*return result as tidy_data_table
3. join the two tidy_data_tables for test and train data using rbind
..*assign result to all_tidy_table
4.read in activity names renaming columns ActivityNo and ActivityName
.. merge on all_tidy_table (will join on ActivityNo)
5. use dplyr's summarise, grouping by Subject,Activity to get means for each measure
.. order results by Subject and ActivityNo
6. write table to tidydata.txt
