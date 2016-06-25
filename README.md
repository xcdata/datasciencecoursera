
## Processing in run_analysis.R

-!/usr/bin/env Rscript
- download the original data
- we use the data.table package for data processing
- read in the original feature matrix from both train and test
- combine train and test
- read in the original feature names
- annotate the combined feature matrix using the original feature names
- filtering feature matrix: only keep the mean and standard deviation measures
- make the feature names more descriptive
- replace the "t" prefix with "time"
- replace the "f" prefix with "frequencyDomain"
- replace "Acc" with "Acceleration"
- replace "Gyro" with "Gyroscope"
- replace "Mag" with "Magnitude"
- replace "mean()" with "mean"
- replace "std()" with "standardDeviation"
- read in the original activity labels 
- read in the original activity label to name mapping
- convert the integer label to characters for downstream fast key lookup through data.table
- translate the original activity label list into activity name list
- read in the original subject labels
- combine the subject list, activity name list, and filtered feature list into one variable
- save this dataset
- generate another tidy data for the average measures for each subject and activity
- save this dataset 
