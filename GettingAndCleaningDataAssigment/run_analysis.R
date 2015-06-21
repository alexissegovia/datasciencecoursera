## You should create one R script called run_analysis.R that does the following. 
## 1.- Merges the training and the test sets to create one data set.
## 2.- Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3.- Uses descriptive activity names to name the activities in the data set
## 4.- Appropriately labels the data set with descriptive variable names. 
## 5.- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Alexis Segovia from Venezuela -- Sorry for my English..

require("data.table")
require("reshape2")

## Extract the names of the columns
features <- read.table("./UCI HAR Dataset Proyect/features.txt")[,2]

## Extract the names of the activity labels
## 3.- Uses descriptive activity names to name the activities in the data set
activity_labels <- read.table("./UCI HAR Dataset Proyect/activity_labels.txt")[,2]

## 2.- Extract only the measurements on the mean and standard deviation for each measurement.
extract_measurements <- grepl("mean|std", features)

## Load and process X_test, y_test data and subject_test
X_test <- read.table("./UCI HAR Dataset Proyect/test/X_test.txt")
Y_test <- read.table("./UCI HAR Dataset Proyect/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset Proyect/test/subject_test.txt")

## Extract the names of the columns
names(X_test) = features

## Extract only the measurements on the mean and standard deviation for each measurement.
X_test = X_test[,extract_measurements]

## Load activity labels
## 3.- Uses descriptive activity names to name the activities in the data set
Y_test[,2] = activity_labels[y_test[,1]]

## Extract the names of the columns
names(Y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

## Bind data
test_bindData <- cbind(as.data.table(subject_test), Y_test, X_test)

## Load and process X_train, y_train data and subject_train
X_train <- read.table("./UCI HAR Dataset Proyect/train/X_train.txt")
Y_train <- read.table("./UCI HAR Dataset Proyect/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset Proyect/train/subject_train.txt")

## Extract the names of the columns
names(X_train) = features

## Reassign only the measurements on the mean and standard deviation for each measurement.
X_train = X_train[,extract_measurements]

## Load activity data
Y_train[,2] = activity_labels[Y_train[,1]]

## Extract the names of the columns
names(Y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

## Bind data
train_bindData <- cbind(as.data.table(subject_train), Y_train, X_train)

## Merge test_bindData and train_bindData
bindData = rbind(test_bindData, train_bindData)

## Assign the labels 
## 4.- Appropriately labels the data set with descriptive variable names.
id_labels   = c("subject", "Activity_ID", "Activity_Label")


data_labels = setdiff(colnames(bindData), id_labels)
meltData = melt(bindData, id = id_labels, measure.vars = data_labels)

## Apply mean function to dataset using dcast function
## 5.- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidy_data   = dcast(meltData, subject + Activity_Label ~ variable, mean)

## Upload data set as a txt file created with write.table() using row.name=FALSE
write.table(tidy_data, file = "./UCI HAR Dataset Proyect/tidy_data.txt",row.names = FALSE)


