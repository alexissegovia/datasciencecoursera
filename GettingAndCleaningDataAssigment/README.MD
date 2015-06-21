Alexis Segovia -- 21/06/2015

Peer Assessments /Getting and Cleaning Data Course Project

How the scripts work

## Create one R script called run_analysis.R that does the following. 
## 1.- Merges the training and the test sets to create one data set.
## 2.- Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3.- Uses descriptive activity names to name the activities in the data set
## 4.- Appropriately labels the data set with descriptive variable names. 
## 5.- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Alexis Segovia from Venezuela -- Sorry for my English..

A.) We need to use the following libraries:

require("data.table")
require("reshape2")

B.) Next, I must you use descriptive names of activities, columns labels of the dataset. For example:

features <- read.table("./UCI HAR Dataset Proyect/features.txt")[,2]
activity_labels <- read.table("./UCI HAR Dataset Proyect/activity_labels.txt")[,2]
id_labels   = c("subject", "Activity_ID", "Activity_Label")

C.) To extract the mean and standard deviation of the measures I use the function "grepl"

Subsequently loaded and processed supplied test

X_test <- read.table("./UCI HAR Dataset Proyect/test/X_test.txt")
Y_test <- read.table("./UCI HAR Dataset Proyect/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset Proyect/test/subject_test.txt")

D.) Then the data bind is executed to generate information and get organized tidy data

test_bindData <- cbind(as.data.table(subject_test), Y_test, X_test)

E.) Finally, and in general, I unify and format the data to generate the file tidy_data.text

meltData = melt(bindData, id = id_labels, measure.vars = data_labels)
tidy_data   = dcast(meltData, subject + Activity_Label ~ variable, mean)
write.table(tidy_data, file = "./UCI HAR Dataset Proyect/tidy_data.txt",row.names = FALSE)
