# Alexis Segovia
# Peer Assessments /Getting and Cleaning Data Course Project 

## You should create one R script called run_analysis.R that does the following. 
## 1.- Merges the training and the test sets to create one data set.
## 2.- Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3.- Uses descriptive activity names to name the activities in the data set
## 4.- Appropriately labels the data set with descriptive variable names. 
## 5.- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Sorry for my English..

1.- I need to use the following packages
require("data.table")
require("reshape2")

2.- According to Project needs, I must to use descriptive names of columns, activities and labels (features.txt, activity_labels.txt) 
for example:

features <- read.table("./UCI HAR Dataset Proyect/features.txt")[,2]
activity_labels <- read.table("./UCI HAR Dataset Proyect/activity_labels.txt")[,2]
names(Y_test) = c("Activity_ID", "Activity_Label")

3.- For the extraction of mean and standard deviation function I use "grepl".

4.- Subsequently loaded and processed supplied test.

5.- Then, the data bind is executed to generate information and get tidy data.

6.- Finally, I unify and format the data to generate the file tidy_data.text

