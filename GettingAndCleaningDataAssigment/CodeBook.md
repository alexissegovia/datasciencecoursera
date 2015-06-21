
CodeBook for the Getting and Cleanning Data

Human Activity Recognition Using Smartphones Dataset
Version 1.0

Data source

The project data were taken from the following address:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

Owner:

Jhons Hopkins Bloomberg School of Public Health

Developed by:

Jorge L. Reyes-Ortiz(1,2), Davide Anguita(1), Alessandro Ghio(1), Luca Oneto(1) and Xavier Parra(2)
1 - Smartlab - Non-Linear Complex Systems Laboratory
DITEN - Università  degli Studi di Genova, Genoa (I-16145), Italy. 
2 - CETpD - Technical Research Centre for Dependency Care and Autonomous Living
Universitat Politècnica de Catalunya (BarcelonaTech). Vilanova i la Geltrú (08800), Spain
activityrecognition '@' smartlab.ws 

Objective of the revised work:

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

Objective of the proyect:

Create one R script called run_analysis.R that does the following:
 
Merges the training and the test sets to create one data set.
Extracts only the measurements on the mean and standard deviation for each measurement. 
Uses descriptive activity names to name the activities in the data set
Appropriately labels the data set with descriptive variable names. 
From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Detail records:

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

Dataset supplied:

- 'README.txt'
- 'features_info.txt': Shows information about the variables used on the feature vector.
- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent:

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

Notes: 
======
- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.
- The units used for the accelerations (total and body) are 'g's (gravity of earth -> 9.80665 m/seg2).
- The gyroscope units are rad/seg.
- A video of the experiment including an example of the 6 recorded activities with one of the participants can be seen in the following link: http://www.youtube.com/watch?v=XOEN9W05_4A

Additional libraries used:

- data.table
- reshape2

Main scripts:

- features <- read.table("./UCI HAR Dataset Proyect/features.txt")[,2]
# Extract only the measurements on the mean and standard deviation for each measurement.
- extract_measurements <- grepl("mean|std", features)
- X_test <- read.table("./UCI HAR Dataset Proyect/test/X_test.txt")
- Y_test <- read.table("./UCI HAR Dataset Proyect/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset Proyect/test/subject_test.txt")
# Bind data
- test_bindData <- cbind(as.data.table(subject_test), Y_test, X_test)
## Load and process X_train, y_train data and subject_train
- X_train <- read.table("./UCI HAR Dataset Proyect/train/X_train.txt")
- Y_train <- read.table("./UCI HAR Dataset Proyect/train/y_train.txt")
- subject_train <- read.table("./UCI HAR Dataset Proyect/train/subject_train.txt")
# Bind data
- train_bindData <- cbind(as.data.table(subject_train), Y_train, X_train)
## Merge test_bindData and train_bindData
bindData = rbind(test_bindData, train_bindData)
## Assign the labels 
- id_labels   = c("subject", "Activity_ID", "Activity_Label")
- data_labels = setdiff(colnames(bindData), id_labels)
- meltData = melt(bindData, id = id_labels, measure.vars = data_labels)
- tidy_data   = dcast(meltData, subject + Activity_Label ~ variable, mean)
- write.table(tidy_data, file = "./UCI HAR Dataset Proyect/tidy_data.txt",row.names = FALSE)
