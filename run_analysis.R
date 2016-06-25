#!/usr/bin/env Rscript

# download the original data
download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip', dest = 'raw.zip')
Sys.Date()
unzip('raw.zip')

# we use the data.table package for data processing
library(data.table)

# read in the original feature matrix from both train and test
train <- fread('UCI HAR Dataset/train/X_train.txt')
test <- fread('UCI HAR Dataset/test/X_test.txt')
# combine train and test
features <- rbind(train, test)

# read in the original feature names
feature.names <- fread('UCI HAR Dataset/features.txt')[, V2]
# annotate the combined feature matrix using the original feature names
setnames(features, feature.names)

# filtering feature matrix: only keep the mean and standard deviation measures
features <- features[, feature.names[grepl('-(mean|std)\\(', feature.names)], with = F]

# make the feature names more descriptive
nms <- colnames(features)
# replace the "t" prefix with "time"
nms <- sub('^t', 'time', nms)
# replace the "f" prefix with "frequencyDomain"
nms <- sub('^f', 'frequencyDomain', nms)
# replace "Acc" with "Acceleration"
nms <- sub('Acc', 'Acceleration', nms)
# replace "Gyro" with "Gyroscope"
nms <- sub('Gyro', 'Gyroscope', nms)
# replace "Mag" with "Magnitude"
nms <- sub('Mag', 'Magnitude', nms)
# replace "mean()" with "mean"
nms <- sub('mean\\(\\)', 'mean', nms)
# replace "std()" with "standardDeviation"
nms <- sub('std\\(\\)', 'standardDeviation', nms)
setnames(features, nms)

# read in the original activity labels 
train.activity <- fread('UCI HAR Dataset/train/y_train.txt')
test.activity <- fread('UCI HAR Dataset/test/y_test.txt')
activity <- rbind(train.activity, test.activity)
setnames(activity, 'label')

# read in the original activity label to name mapping
activity.labels <- fread('UCI HAR Dataset/activity_labels.txt')
setnames(activity.labels, c('label', 'activity'))
# convert the integer label to characters for downstream fast key lookup through data.table
activity.labels[, label := as.character(label)]
setkey(activity.labels, label)
# translate the original activity label list into activity name list
lookup <- activity[, as.character(label)]
activity.names <- activity.labels[lookup]
activity.names[, label := NULL]

# read in the original subject labels
train.subject <- fread('UCI HAR Dataset/train/subject_train.txt')
test.subject <- fread('UCI HAR Dataset/test/subject_test.txt')
subject <- rbind(train.subject, test.subject)
setnames(subject, 'subject')

# combine the subject list, activity name list, and filtered feature list into one variable
combinedData <- cbind(subject, activity.names, features)
# save this dataset
write.table(combinedData, row = F, sep = '\t', file = 'combinedData.tsv')

# generate another tidy data for the average measures for each subject and activity
averageData <- combinedData[, data.frame(t(colMeans(.SD))), by = .(subject, activity)]
# save this dataset 
write.table(averageData, row.name = F, file = 'averageData.txt')
